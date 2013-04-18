#include "Globals.INC"

Function PopPanel()
	
	Print "poping Panel"
	SystemStatus = PickingPanel
	
retry:

	Do Until inMagIntlock = False 'And hmiAck = True
		Wait .1 ' wait for user to close inmaginterlock
	Loop
	
'	WaitSig InMagPickUpSignal ' Wait for inmag to confirm a panel is ready to be picked up
	
	suctionCupsCC = True
	Jump InputMagCenter LimZ zLimit Sense Sw(inMagIntlockH) = True
	
	If JS = False Then ' Jump executed normally
		Wait suctionWaitTime ' Allow time for cups to seal on panel
		SystemStatus = MovingPanel
'		Jump ScanCenter LimZ zLimit ' Collision Avoidance Waypoint
'		Signal InMagRobotClearSignal ' Give permission for input magazine to queue up next panel
	Else
		GoTo retry 'Interlock was opened during jump
	EndIf
	
'	FindPickUpError() ' after we pick up a panel, find the pickup offsets
	
	Go ScanCenter3
	
Fend
Function PushPanel()
	
	Print "Pushing a panel"
	SystemStatus = DepositingPanel
	PanelPassedInspection = True ' fake it for testing	
'	PanelPassedInspection = False ' rest flag
	
	If PanelPassedInspection = False Then
	'	Jump PanelFailDropOffPoint LimZ Zlimit
		suctionCups = False
		Wait 1 ' Give time for panel to relese from suction cups
		erPanelFailedInspection = True
		Pause
	Else
		retry:
		
		Do Until outMagInt = False
			Wait .25 ' Wait for output magazine interlock door to close
		Loop
		
'		WaitSig OutMagDropOffSignal
		
		Jump OutputMagCenter -Z(recPanelThickness) LimZ zLimit Sense Sw(outMagIntH) = True
		
		If JS = False Then
			suctionCups = False
			SystemStatus = MovingPanel
			Jump ScanCenter LimZ zLimit ' Collision Avoidance Waypoint
'			Signal OutputMagSignal ' Give permission for output magazine to dequeue next panel
		Else
			GoTo retry ' interlock was opened during a jump
		EndIf
		
		If jobNumPanelsDone = jobNumPanels Then
			jobDone = True ' We have finished the run, don't execute the main loop
		EndIf
		
		Print "jobdone", jobDone
		
		jobNumPanelsDone = jobNumPanelsDone + 1 ' Increments how many panels we have finished
			
		Go ScanCenter3
		
'		Signal OutMagRobotClearSignal ' Tell outmag the robot it out of the way, ok to move
		
	EndIf
	
Fend
Function FindPickUpError()
	
Real d1, d2
Integer i

Speed 10 'slow it down so we get a better reading
SpeedS 50
	
	Go ScanCenter3 - PanelOffset CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move ScanCenterLong - PanelOffset CP Till Sw(LaserGo)
	
	If TillOn = False Then
	'If we think we have a panel and we actually dotn have one then should re-pop a panel?
		erPanelStatusUnknown = True
		stackLightYelCC = True
		stackLightAlrmCC = True
		Pause
	Else
		erPanelStatusUnknown = False
		stackLightYelCC = False
		stackLightAlrmCC = False
	EndIf
	
	d1 = CY(CurPos)
	
	ChangeProfile("00")
	Move (ScanCenter3 - PanelOffset) :U(CU(CurPos))
	Go (ScanCenter3 - PanelOffset) +U(180) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanCenterLong - PanelOffset) :U(CU(CurPos)) CP Till Sw(laserGo)
	d2 = CY(CurPos)
	yOffset = (d2 - d1) /2 ' I dont think its /2
	
'	Print "yOffset", yOffset
	
	d1 = 0
	d2 = 0
	
	ChangeProfile("00")
	Move (ScanCenter3 - PanelOffset) :U(CU(CurPos))
	Go (ScanCenter3 - PanelOffset) +U(90) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanCenterShort - PanelOffset) :U(CU(CurPos)) CP Till Sw(laserGo)
	
	If TillOn = False Then
		erPanelStatusUnknown = True
		stackLightYelCC = True
		stackLightAlrmCC = True
		Pause
	Else
		erPanelStatusUnknown = False
		stackLightYelCC = False
		stackLightAlrmCC = False
	EndIf
	'Use CY in both x and y offsets because we are only modulating along the Y-axis
	d1 = CY(CurPos)

	ChangeProfile("00")
	Move (ScanCenter3 - PanelOffset) :U(CU(CurPos))
	Go (ScanCenter3 - PanelOffset) +U(270) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanCenterShort - PanelOffset) :U(CU(CurPos)) CP Till Sw(laserGo)
	d2 = CY(CurPos)

	xOffset = (d2 - d1) /2  ' I dont think its /2P23 - RotatedOffset
	
'	Print "xOffset", xOffset
	
	d1 = 0
	d2 = 0
	ChangeProfile("00")
	Move (ScanCenter3 - PanelOffset) :U(CU(CurPos))
	Go (scancenter3 - PanelOffset)
	
	PanelOffset = PanelOffset :X(xOffset) :Y(yOffset) 'update offset point
	Print "PanelOffset:", PanelOffset
			
Fend

	


