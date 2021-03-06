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

			If Sw(inMagPnlRdyH) = True Then ' A panel is not present, move platen up
				inMagMtrCC = True
				inMagMtrDirCC = True
				NextState = StatePresentNextPart
				
				If inMagUpLim = True Then 'If upper limit is reached then the magazine is out of panels 
					erInMagEmpty = True ' Tell operator the magazine is empty
					NextState = StateLowering
				EndIf
			Else
				Off inMagMtrH  ' Turn off motor
				inMagMtrCC = False
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
			NextState = StateInMagPaused
			
		Default
			
			inMagCurrentState = StateInMagUnknown
			inMagMtrCC = False ' Turn off the motor becuase something unforseen has occured
			erUnknown = True ' Tell operator there is an unknown error
	Send
	
	inMagCurrentState = NextState 'Set next state to current state after we break from case statment
		
	' This block of code checks if an interlock has been opened. 
	If inMagInterlock = True And InmagInterlockFlag = False Then
		' I am not sure if this interlock is hardware controlled, it should be.
		InmagInterlockFlag = True ' Set a flag
		InmagLastState = inMagCurrentState ' Save the current state before we pause
		inMagCurrentState = StateInMagPaused ' Send the state machine to paused
	ElseIf inMagInterlock = False And InmagInterlockFlag = True Then
		InmagInterlockFlag = False ' Reset flag
		inMagCurrentState = InmagLastState ' Go to the state before the interlock was open
	EndIf

Loop

Fend


Function OutMagControlRefactor()

Integer NextState
Boolean OutmagInterlockFlag

outMagCurrentState = StateOutMagWaitingUser ' When we power on the magazine waits for the operator

Do While True

	Select outMagCurrentState
		
		Case StateReadyToReceive
			
      If outMagGoHome = True Then
				OutMagDropOffSignal = False ' Tell robot the output mag is NOT ready
				outMagGoHome = False ' Reset Flag
				NextState = StateGoHome
			ElseIf RobotPlacedPanel = True Then
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
			
			If RobotPlacedPanel = True Then ' There is a panel to be moved down
				RobotPlacedPanel = False ' Reset Flag
				
				If Sw(outMagPanelRdyH) = True Then
					outMagMtrDirCC = False  'Set direction to Down
					outMagMtrCC = True ' Turn on Motor					
					TmReset (10)
					Do Until Sw(outMagPanelRdyH) = False Or Tmr(10) > .2
						Wait .1
						Print "looking for panel..."
					Loop
				EndIf
				
				NextState = StateOutMagLowering
			ElseIf Sw(outMagPanelRdyH) = False Then ' There is still a panel to be moved down
				outMagMtrDirCC = False  'Set direction to Down
				outMagMtrCC = True ' Turn on Motor	
				NextState = StateOutMagLowering
			Else
				outMagMtrCC = False ' Turn off Motor		
				NextState = StateReadyToReceive
			EndIf
			
			If outMagLowLim = True Then ' If we try and lower the platen but the lower EOT is true then the magazine is full
				outMagMtrCC = False ' Turn off Motor	
				erOutMagFull = True
				OutMagDropOffSignal = False ' Tell the robot it cannot drop off a panel
				NextState = StateOutMagWaitingUser
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
				
				If outMagUpLim = False And Sw(outMagPanelRdyH) = True Then ' Keep raisng until we hit EOT or a panel is detected
					outMagMtrDirCC = True 'Set direction to UP 
					outMagMtrCC = True
					NextState = StateRaising
				ElseIf Sw(outMagPanelRdyH) = False Then
					' A panel is in the output magazine and it tripped the sensor. We need to move it down
					' until it is out of the way
					Off outMagMtrH  'Turn off motor	
					outMagMtrCC = False
					NextState = StateOutMagLowering
				ElseIf outMagUpLim = True Then
					' The platen is at the very top without any panels in the magazine
					Off outMagMtrH  'Turn off motor	
					outMagMtrCC = False
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
			NextState = StateOutMagPaused
			
		Default
			outMagCurrentState = StateOutMagUnknown
			erUnknown = True
			outMagMtrCC = False ' Turn off motor
	Send

	outMagCurrentState = NextState 'Set next state to current state after we break from case statment
		
	' This block of code checks if an interlock has been opened. 
	If outMagInt = True And OutmagInterlockFlag = False Then
		' I am not sure if this interlock is hardware controlled, it should be.
		OutmagInterlockFlag = True ' Set a flag
		OutmagLastState = outMagCurrentState ' Save the current state before we pause
		outMagCurrentState = StateOutMagPaused ' Send the state machine to paused
	ElseIf outMagInt = False And OutmagInterlockFlag = True Then
		OutmagInterlockFlag = False ' Reset flag
		outMagCurrentState = OutmagLastState ' Go to the state before the interlock was open
	EndIf

Loop

Fend

