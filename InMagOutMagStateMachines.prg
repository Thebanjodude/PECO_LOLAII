#include "Globals.INC"

Function InmagControl()
	
' This is the state machine for the input magazine. Each state is non-blocking. Every state points back to itself 
' if the condition(s) for transition are not met.

Integer NextState
Boolean InmagInterlockFlag

inMagCurrentState = StateWaitingUser ' When we power on the magazine waits for the operator
InMagRobotClearSignal = True ' initialization, because the robot starts at home

Do While True
	
	Select inMagCurrentState
		
		Case StatePartPresent
			
			If inMagGoHome = True Then ' User wants magazine to go home
				InMagPickUpSignal = False ' Robot cannot pick a panel from the magazine
				inMagGoHome = False 'Clear Flag
				NextState = StateLowering
			ElseIf inMagPnlRdy = True Then
				InMagPickUpSignal = False ' Robot cannot pick a panel from the magazine
				NextState = StatePartRemoved
			Else
				InMagPickUpSignal = True ' Robot can pick a panel from the magazine
				NextState = StatePartPresent
			EndIf
			
		Case StatePartRemoved
					
			If InMagRobotClearSignal = True Then
				' The robot has retreived a panel and is out of the way, magazine can queue up
				NextState = StatePresentNextPart
			Else
				NextState = StatePartRemoved
			EndIf
			
		Case StatePresentNextPart
			
			If inMagPnlRdy = True Then ' A panel is not present, move platen up
				inMagMtrDirCC = True 'Set direction to UP
				inMagMtrCC = True ' Turn on motor
				NextState = StatePresentNextPart
			ElseIf inMagUpLim = True Then 'If upper limit is reached then the magazine is out of panels 
				erInMagEmpty = True ' Tell operator the magazine is empty
				NextState = StateLowering
			Else
				inMagMtrCC = False ' Turn off motor
				NextState = StatePartPresent
			EndIf
			
		Case StateLowering
		
			If inMagLowLim = False Then ' Keep lowering until we hit the lower limit (home)
				inMagMtrDirCC = False 'set direction to DOWN
				inMagMtrCC = True ' Turn on motor
				NextState = StateLowering
			Else
				inMagMtrCC = False ' Turn off motor
				NextState = StateWaitingUser
			EndIf
			
		Case StateWaitingUser
			
			If inMagLoaded = True Then
				erInMagEmpty = False ' the user has ack'ed that they loaded the input magazine
				inMagLoaded = False 'Clear Flag
				NextState = StatePresentNextPart
			Else
				NextState = StateWaitingUser
			EndIf
			
		Case StateInMagPaused
			inMagMtrCC = False ' Turn off the motor becuase we are paused
			
		Default
			inMagCurrentState = StateInMagUnknown
			erUnknown = True ' Tell operator there is an unknown error
	Send
	
	inMagCurrentState = NextState 'Set next state to current state after we break from case statment
		
	' This block of code checks if an interlock has been opened. 
	If inMagInterlock = True Then
		' I am not sure if this interlock is hardware controlled, it should be.
		InmagInterlockFlag = True ' Set a flag
		InmagLastState = inMagCurrentState ' Save the current state before we pause
		NextState = StateInMagPaused ' Send the state machine to paused
	ElseIf inMagInterlock = False And InmagInterlockFlag = True Then
		InmagInterlockFlag = False ' Reset flag
		inMagCurrentState = InmagLastState ' Go to the state before the interlock was open
	EndIf

Loop

Fend
Function OutMagControl

Integer NextState

outMagCurrentState = StateOutMagWaitingUser ' On start up go to home position

Do While True

	Select outMagCurrentState
		Case StateReadyToReceive
			
			OutMagDropOffSignal = True ' Tell robot the output mag is ready
			' Don't leave state unless panel is detected Or user specifies go home
			Do Until outMagGoHome = True Or RobotPlacedPanel = True 'outMagPanelRdy = False Or 
				Wait .1 ' Do nothing
			Loop

			If outMagGoHome = True Then ' Determine which state to go to next
				NextState = StateGoHome
				outMagGoHome = False ' Reset Flag
			Else
				NextState = StateOutMagPartPresent
			EndIf
			
			RobotPlacedPanel = False
			OutMagDropOffSignal = False ' Tell robot the output mag is not ready

		Case StateOutMagPartPresent

			Do Until OutputMagSignal = True
				Wait .25 ' Wait for main program to move robot out of the way
			Loop
			OutputMagSignal = False 'reset trigger
			NextState = StateOutMagLowering

		Case StateOutMagLowering
			
			Boolean PartPresentTrigger, endloop
			
			PartPresentTrigger = False ' Ititialize
			endloop = False
			
			Do Until endloop = True Or outMagLowLim = True
				outMagMtrDirCC = False 'Set direction to Down
				outMagMtrCC = True
				
				If outMagPanelRdy = False Then
					PartPresentTrigger = True
				EndIf
			
				If PartPresentTrigger = True And outMagPanelRdy = True Then
					endloop = True
				EndIf
			Loop

			outMagMtrCC = False

            If outMagLowLim = True Then 'Determine which state to go to next
				NextState = StateOutMagWaitingUser
				erOutMagFull = True
				OutMagDropOffSignal = False
			Else
				NextState = StateReadyToReceive
			EndIf

		Case StateOutMagWaitingUser
			
			Do Until outMagUnloaded = True ' Don't leave state until magazine has been unloaded
				Wait .1
			Loop

			NextState = StateRaising

			erOutMagFull = False ' The user has ack'ed that they unloaded the output mag.
			outMagUnloaded = False ' Reset Flag

			If outMagPanelRdy = False Then
				erOutMagFull = True ' The user has ack'ed that they unloaded the output mag.
				outMagUnloaded = False ' Reset Flag
				NextState = StateOutMagWaitingUser
			EndIf

		Case StateRaising
			
		' I edited this on accident instead of the revised versio, if you need it, get it from the repo

		Case StateGoHome

			Do Until outMagLowLim = True
				outMagMtrDirCC = False 'Set direction to DOWN
				outMagMtrCC = True
			Loop

			outMagMtrCC = False

			outMagGoHome = False 'Clear Flag

			NextState = StateOutMagWaitingUser

		Default
			erUnknown = True
	Send

outMagCurrentState = NextState 'Set next state to current state after we break from case statment

Print "outMagCurrentState", outMagCurrentState
Loop

Fend
Function MagTorqueErrorISR

InMagTorqueLim = 12345 ' Empirically define this limit
OutMagTorqueLim = -12345 ' Empirically define this limit
	
	If InMagTorqueLim > PTRQ(Zaxis) Then
		Off (suctionCupsH) ' Stop attempt at picking up a panel
		Jump PreScan LimZ zLimit ' Go to a safe place
		erInMagCrowding = True
		' Get user ack before leaving ISR	
	EndIf

		If OutMagTorqueLim < PTRQ(Zaxis) Then
		On (suctionCupsH) ' Double check suction cups are on
		Jump PreScan LimZ zLimit ' Go to a safe place
		erOutMagCrowding = True
		' Get user ack before leaving ISR	
	EndIf
	
	PTCLR Zaxis ' Clear peak torque zaxis value

Fend
Function OutMagControlRefactored()

Integer NextState

outMagCurrentState = StateOutMagWaitingUser ' When we power on the magazine waits for the operator

Do While True

	Select outMagCurrentState
		
		Case StateReadyToReceive
			
            If outMagGoHome = True Then
				OutMagDropOffSignal = False ' Tell robot the output mag is NOT ready
				outMagGoHome = False ' Reset Flag
				NextState = StateGoHome
			ElseIf RobotPlacedPanel = True Then
				RobotPlacedPanel = False ' Reset Flag
				OutMagDropOffSignal = False ' Tell robot the output mag is NOT ready
				NextState = StateOutMagPartPresent
			Else
				OutMagDropOffSignal = True ' Tell robot the output mag is ready
				NextState = StateReadyToReceive
			EndIf

		Case StateOutMagPartPresent

			If OutputMagSignal = True Then ' Wait for robot to move out of the way before we dequeue
				OutputMagSignal = False 'Reset flag
				NextState = StateOutMagLowering
			Else
				NextState = StateOutMagPartPresent
			EndIf

		Case StateOutMagLowering
			
			Boolean PartPresentTrigger, endloop
			
			PartPresentTrigger = False ' Ititialize
			endloop = False
			
			Do Until endloop = True Or outMagLowLim = True
				outMagMtrDirCC = False 'Set direction to Down
				outMagMtrCC = True
				
				If outMagPanelRdy = False Then
					PartPresentTrigger = True
				EndIf
			
				If PartPresentTrigger = True And outMagPanelRdy = True Then
					endloop = True
				EndIf
			Loop

			outMagMtrCC = False

            If outMagLowLim = True Then 'Determine which state to go to next
				NextState = StateOutMagWaitingUser
				erOutMagFull = True
				OutMagDropOffSignal = False
			Else
				NextState = StateReadyToReceive
			EndIf

		Case StateOutMagWaitingUser
			
			If outMagUnloaded = True Then ' Don't leave state until magazine has been unloaded
				erOutMagFull = False ' The user has ack'ed that they unloaded the output mag.
				outMagUnloaded = False ' Reset Flag
				NextState = StateRaising
			Else
				NextState = StateOutMagWaitingUser
			EndIf

		Case StateRaising
				
				If outMagUpLim = True Or outMagPanelRdy = True Then ' Keep raisng until we hit EOT or a panel is detected
					outMagMtrDirCC = True 'Set direction to UP 
					outMagMtrCC = True
					NextState = StateRaising
				ElseIf outMagPanelRdy = False Then
					' A panel is in the output magazine and it tripped the sensor. We need to move it down
					' until it is out of the way
					outMagMtrCC = False 'Turn off motor	
					NextState = StateOutMagLowering
				ElseIf outMagUpLim = False Then
					' The platen is at the very top without any panels in the magazine
					outMagMtrCC = False 'Turn off motor
					NextState = StateReadyToReceive
				EndIf

		Case StateGoHome

			If outMagLowLim = False Then ' Keep lowering until we hit the lower limit (home)
				outMagMtrDirCC = False 'Set direction to DOWN
				outMagMtrCC = True ' Turn on motor
				NextState = StateGoHome
			Else
				outMagGoHome = False 'Clear Flag
				outMagMtrCC = False ' Turn off motor
				NextState = StateOutMagWaitingUser
			EndIf
			
		Case StateOutMagPaused
			outMagMtrCC = False ' Turn off motor becuase we are paused

		Default
			outMagCurrentState = StateOutMagUnknown
			erUnknown = True
	Send

	outMagCurrentState = NextState 'Set next state to current state after we break from case statment

Loop

Fend
