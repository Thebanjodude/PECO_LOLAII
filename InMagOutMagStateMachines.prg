
#include "Globals.INC"

Function InMagControl

Integer NextState

inMagCurrentState = StateWaitingUser ' When we power on the magazine it waits for the operator

Do While True
	
	Select inMagCurrentState
		Case StatePartPresent

			InMagPickUpSignal = True ' Tell The controller the magazine is ready
			' Don't leave state unless part is removed or user commands magazine home
			Do Until inMagPnlRdy = True Or inMagGoHome = True
				Wait .25 ' Do nothing
			Loop
			
			If inMagGoHome = True Then ' Determine which state to go to next
				NextState = StateLowering
				inMagGoHome = False 'Clear Flag
			Else
				NextState = StatePartRemoved
			EndIf

		Case StatePartRemoved
					
			Do Until InMagRobotClearSignal = True
				Wait .25 ' Wait for main program to move robot out of the way
			Loop
			
			InMagRobotClearSignal = False ' reset trigger
			NextState = StatePresentNextPart
			
		Case StatePresentNextPart
			
			'Don't leave state until panel is in position or EOT is reached
			Do Until Sw(inMagPnlRdyH) = False Or inMagUpLim = True
				inMagMtrDirCC = True 'set direction to UP
				inMagMtrCC = True
			Loop
			
			Off inMagMtrH
			inMagMtrCC = False
			
			If inMagUpLim = True Then 'If upper limit is reached then the magazine is out of panels 
				NextState = StateLowering
				erInMagEmpty = True
			Else
				NextState = StatePartPresent
			EndIf
			
		Case StateLowering
		
			Do Until inMagLowLim = True ' Don't leave state until magazine has reached lower limit (home)
				inMagMtrDirCC = False 'set direction to DOWN
				inMagMtrCC = True
			Loop
			
			inMagMtrCC = False
			
			NextState = StateWaitingUser
			
		Case StateWaitingUser
			
			Print "waiting for user to load more panels"
			Do Until inMagLoaded = True
				' Send message to HMI "waiting for user to load more panels"
				Wait .1
			Loop
			
			inMagLoaded = False
			erInMagEmpty = False ' the user has ack'ed that they loaded the input magazine
			NextState = StatePresentNextPart
			inMagLoaded = False 'Clear Flag
			Print "User hit ready"
			
		Default
			Print "Current State is Null" ' We should NEVER get here...
			erUnknown = True
	Send
	
inMagCurrentState = NextState 'Set next state to current state after we break from case statment
Print "inMagCurrentState", inMagCurrentState
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
			Do Until outMagPanelRdy = False Or outMagGoHome = True
				Wait .1 ' Do nothing
			Loop

			If outMagGoHome = True Then ' Determine which state to go to next
				NextState = StateGoHome
				outMagGoHome = False ' Reset Flag
			Else
				NextState = StateOutMagPartPresent
			EndIf

		Case StateOutMagPartPresent

			Do Until OutputMagSignal = True
				Wait .25 ' Wait for main program to move robot out of the way
			Loop
			OutputMagSignal = False 'reset trigger
			NextState = StateOutMagLowering

		Case StateOutMagLowering

			Do Until outMagPanelRdy = True Or outMagLowLim = True
				outMagMtrDirCC = False 'Set direction to Down
				outMagMtrCC = True
			Loop

			outMagMtrCC = False

            If outMagLowLim = True Then 'Determine which state to go to next
				NextState = StateOutMagWaitingUser
				erOutMagFull = True
			Else
				NextState = StateReadyToReceive
			EndIf

		Case StateOutMagWaitingUser

			Do Until outMagUnloaded = True ' Don't leave state until magazine has been unloaded
				Wait .1
			Loop
			
'			If outMagPanelRdy = True Then
'				NextState = StateOutMagLowering
'			Else
				NextState = StateRaising
'			EndIf

			outMagUnloaded = False
			erOutMagFull = False ' The user has ack'ed that they unloaded the output mag.
			outMagUnloaded = False ' Reset Flag

		Case StateRaising

			Do Until outMagUpLim = True Or Sw(outMagPanelRdyH) = False  ' Move magazine up until we hit the upper limit
'				outMagMtrDirCC = True 'Set direction to UP 
'				outMagMtrCC = True
				On (outMagMtrH)
				outMagMtrDirCC = True 'Set direction to UP 
			Loop

			Off (outMagMtrH)
			outMagMtrCC = False

			NextState = StateReadyToReceive

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


'Function OutMagControl
'
'Integer NextState
'
'outMagCurrentState = StateOutMagWaitingUser ' On start up go to home position
'
'Do While True
'				
'	Select outMagCurrentState
'		Case StateReadyToReceive
'		
'			' Don't leave state unless panel is detected Or user specifies go home
'			Do Until outMagPanelRdy = False Or outMagGoHome = True
'				Wait .1 ' Do nothing
'			Loop
'			
'			If outMagGoHome = True Then ' Determine which state to go to next
'				NextState = StateGoHome
'				outMagGoHome = False ' Reset Flag
'			Else
'				NextState = StateOutMagPartPresent
'			EndIf
'			
'		Case StateOutMagPartPresent
'			
'			'WaitSig OutputMagSignal ' Wait for main program to move robot out of the way
'			NextState = StateOutMagLowering
'			
'		Case StateOutMagLowering
'			
'			Do Until outMagPanelRdy = True Or outMagLowLim = True
'				outMagMtrDirCC = False 'Set direction to Down
'				outMagMtrCC = True
'			Loop
'			
'			outMagMtrCC = False
'			
'            If outMagLowLim = True Then 'Determine which state to go to next
'				NextState = StateOutMagWaitingUser
'				erOutMagFull = True
'			Else
'				NextState = StateReadyToReceive
'				Signal OutMagDropOffSignal
'			EndIf
'	
'		Case StateOutMagWaitingUser
'						
'			Do Until outMagUnloaded = True ' Don't leave state until magazine has been unloaded
'				Wait .1
'			Loop
'			
'			erOutMagFull = False ' The user has ack'ed that they unloaded the output mag.
'			outMagUnloaded = False ' Reset Flag
'			NextState = StateRaising
'			
'		Case StateRaising
'			
'			'WaitSig OutMagRobotClearSignal
'			
'			Do Until outMagLowLim = True Or Sw(outMagPanelRdyH) = False  ' Move magazine up until we hit the upper limit
'				outMagMtrDirCC = True 'Set direction to UP 
'				outMagMtrCC = True
'			Loop
'			
'			outMagMtrCC = False
'	
'			NextState = StateReadyToReceive
'			
'		Case StateGoHome
'			
'			Do Until outMagLowLim = True
'				outMagMtrDirCC = False 'Set direction to DOWN
'				outMagMtrCC = True
'			Loop
'			
'			outMagMtrCC = False
'					
'			outMagGoHome = False 'Clear Flag
'			
'			NextState = StateOutMagWaitingUser
'			
'		Default
'			erUnknown = True
'	Send
'
'outMagCurrentState = NextState 'Set next state to current state after we break from case statment
'
'Print "outMagCurrentState", outMagCurrentState
'Loop
'	
'Fend
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

