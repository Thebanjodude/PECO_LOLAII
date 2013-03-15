'NOTE: Replace all direct inputs and outputs with var names in IOTable. They are IO so I can test. 
#include "Globals.INC"

Function InMagControl

#define StatePartPresent 0
#define StatePartRemoved 1
#define StatePresentNextPart 2
#define StateLowering 3
#define StateWaitingUser 4

Integer NextState

inMagCurrentState = StateLowering ' When we power on the magazine it goes to the home position

Do While True
	
	Select inMagCurrentState
		Case StatePartPresent
			
			' Don't leave state unless part is removed or user commands magazine home
			Do Until inMagPanelRdy = False Or inMagGoHome = True
				Wait .1 ' Do nothing
			Loop
			
			If inMagGoHome = True Then ' Determine which state to go to next
				NextState = StateLowering
				inMagGoHome = False 'Clear Flag
			Else
				NextState = StatePartRemoved
			EndIf

		Case StatePartRemoved
					
		'	WaitSig InMagRobotClearSignal ' Wait for main program to move robot out of the way
			NextState = StatePresentNextPart
			
		Case StatePresentNextPart
			
			'Don't leave state until panel is in position or EOT is reached
			Do Until inMagPanelRdy = True Or inMagUpperLim = True
				inMagMtrDir = False 'set direction to UP
				inMagMtr = True
			Loop
			
			inMagMtr = False
			
			If inMagUpperLim = True Then 'If upper limit is reached then the magazine is out of panels 
				NextState = StateLowering
				erInMagEmpty = True
			Else
				NextState = StatePartPresent
				Signal InMagPickUpSignal
			EndIf
			
		Case StateLowering
		
			Do Until inMagLowerLim = True ' Don't leave state until magazine has reached lower limit (home)
				inMagMtrDir = True 'set direction to DOWN
				inMagMtr = True
			Loop
			
			inMagMtr = False
			
			NextState = StateWaitingUser
			
		Case StateWaitingUser
			
			Do Until inMagLoaded = True
				' Send message to HMI "waiting for user to load more panels"
			Loop
			
			erInMagEmpty = False ' the user has ack'ed that they loaded the input magazine
			NextState = StatePresentNextPart
			inMagLoaded = False 'Clear Flag
			
		Default
			Print "Current State is Null" ' We should NEVER get here...
			erUnknown = True
	Send
	
inMagCurrentState = NextState 'Set next state to current state after we break from case statment

Loop

Fend
Function OutMagControl

#define StateReadyToReceive 0
#define StateOutMagPartPresent 1
#define StateOutMagLowering 2
#define StateOutMagWaitingUser 3
#define StateRaising 4
#define StateGoHome 5

Integer NextState

outMagCurrentState = StateReadyToReceive ' On start up go to home position

Do While True
				
	Select outMagCurrentState
		Case StateReadyToReceive
		
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
			
			WaitSig OutputMagSignal ' Wait for main program to move robot out of the way
			NextState = StateOutMagLowering
			
		Case StateOutMagLowering
			
			Do Until outMagPanelRdy = True Or Sw(outMagLowerLimH) = True
				outMagMtrDir = True 'Set direction to Down
				outMagMtr = True
			Loop
			
			outMagMtr = False
			
            If outMagLowerLim = True Then 'Determine which state to go to next
				NextState = StateOutMagWaitingUser
				erOutMagFull = True
			Else
				NextState = StateReadyToReceive
				Signal OutMagDropOffSignal
			EndIf
	
		Case StateOutMagWaitingUser
						
			Do Until outMagUnloaded = True ' Don't leave state until magazine has been unloaded
				Wait .1
			Loop
			
			erOutMagFull = False ' The user has ack'ed that they unloaded the output mag.
			outMagUnloaded = False ' Reset Flag
			NextState = StateRaising
			
		Case StateRaising
			
			WaitSig OutMagRobotClearSignal
			
			Do Until outMagUpperLim = True ' Move magazine up until we hit the upper limit
				outMagMtrDir = False 'Set direction to UP 
				outMagMtr = True
			Loop
			
			outMagMtr = False
	
			NextState = StateReadyToReceive
			
		Case StateGoHome
			
			Do Until outMagLowerLim = True
				outMagMtrDir = True 'Set direction to DOWN
				outMagMtr = True
			Loop
			
			outMagMtr = False
					
			outMagGoHome = False 'Clear Flag
			
			NextState = StateOutMagWaitingUser
			
		Default
			erUnknown = True
	Send

outMagCurrentState = NextState 'Set next state to current state after we break from case statment

Loop
	
Fend
Function MagTorqueErrorISR

InMagTorqueLim = 12345 ' Empirically define this limit
OutMagTorqueLim = -12345 ' Empirically define this limit
	
	If InMagTorqueLim > PTRQ(Zaxis) Then
		Off (suctionCupsH) ' Stop attempt at picking up a panel
		Jump ScanCenter LimZ Zlimit ' Go to a safe place
		erInMagCrowding = True
		' Get user ack before leaving ISR	
	EndIf

		If OutMagTorqueLim < PTRQ(Zaxis) Then
		On (suctionCupsH) ' Double check suction cups are on
		Jump ScanCenter LimZ Zlimit ' Go to a safe place
		erOutMagCrowding = True
		' Get user ack before leaving ISR	
	EndIf
	
	PTCLR Zaxis ' Clear peak torque zaxis value

Fend

