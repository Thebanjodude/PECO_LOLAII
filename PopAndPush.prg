#include "Globals.INC"

Function PopPanel()
	
	Print "poping Panel"
	SystemStatus = PickingPanel
	
retry:

	Do Until inMagInterlock = False 'And hmiAck = True
		Wait .1 ' wait for user to close inmaginterlock
	Loop
	
'	WaitSig InMagPickUpSignal ' Wait for inmag to confirm a panel is ready to be picked up
	
	suctionCups = True
	Jump InputMagCenter LimZ Zlimit Sense Sw(inMagInterlockH) = True
	
	If JS = False Then ' Jump executed normally
		Wait SuckTime ' Allow time for cups to seal on panel
		SystemStatus = MovingPanel
		Jump ScanCenter LimZ Zlimit ' Collision Avoidance Waypoint
'		Signal InMagRobotClearSignal ' Give permission for input magazine to queue up next panel
	Else
		GoTo retry 'Interlock was opened during jump
	EndIf

Fend
Function PushPanel()
	
	SystemStatus = DepositingPanel
	PanelPassedInspection = True ' fake it for testing	
	
	If PanelPassedInspection = False Then
	'	Jump PanelFailDropOffPoint LimZ Zlimit
		suctionCups = False
		Wait .1 ' Give time for panel to relese from suction cups
		erPanelFailedInspection = True
		jobPauseFlag = True 'Set flag
		SystemPause()
	Else
		retry:
		
		Do Until outMagInt = False
			Wait .25 ' Wait for output magazine interlock door to close
		Loop
		
'		WaitSig OutMagDropOffSignal
		
		Jump OutputMagCenter LimZ Zlimit Sense Sw(outMagIntlockH) = True
		
		If JS = False Then
			suctionCups = False
			SystemStatus = MovingPanel
			Jump ScanCenter LimZ Zlimit ' Collision Avoidance Waypoint
'			Signal OutputMagSignal ' Give permission for output magazine to dequeue next panel
		Else
			GoTo retry
		EndIf
		
		Jump ScanCenter LimZ Zlimit ' Go home
		
'		Signal OutMagRobotClearSignal ' Tell outmag the robot it out of the way, ok to move
		
	EndIf
	
Fend

