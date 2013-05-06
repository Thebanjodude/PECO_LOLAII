#include "Globals.INC"

Function PopPanel() As Boolean
	
Trap 2, MemSw(abortJobH) = True GoTo exitPopPanel ' arm trap

retry:

	If inMagIntlock = True Then 'Check Interlock status
		PopPanel = False
		GoTo exitPopPanel
	EndIf
	
'	WaitSig InMagPickUpSignal ' Wait for inmag to confirm a panel is ready to be picked up
	Jump InMagCenter LimZ zLimit Sense Sw(inMagIntlockH) = True
	
	If JS = False Then ' Jump executed without inmag interlock being opened
		suctionCupsCC = True
		Wait suctionWaitTime ' Allow time for cups to seal on panel
		Jump Prescan LimZ zLimit
'		Signal InMagRobotClearSignal ' Give permission for input magazine to queue up next panel
	Else
		GoTo retry 'Interlock was opened during jump
	EndIf
	
	PopPanel = True
	SystemStatus = MovingPanel
	Go PreScan 'Go Home	
	jobNumPanelsDone = jobNumPanelsDone + 1 ' Increment how many panels we have finished	
	
	If jobNumPanelsDone = jobNumPanels Then
		jobDone = True ' We have finished the run, don't execute the main loop
	EndIf
	
exitPopPanel:

If MemSw(abortJobH) = True Then
	abortJob = True
EndIf

Trap 2 'disarm trap
    
Fend
Function PushPanel() As Boolean
	
Trap 2, MemSw(abortJobH) = True GoTo exitPushPanel ' arm trap
	
	SystemStatus = DepositingPanel
	PanelPassedInspection = True ' fake it for testing	
'	PanelPassedInspection = False ' rest flag

	hsDataTxRdy = True ' Tell HMI to readout hole data
	MemOn (hsDataTxAckH) ' fake
	
	Wait MemSw(hsDataTxAckH) = True, 3
	
	If TW = True Then
		PushPanel = False
		erHMICommunication = True
		GoTo exitPushPanel
	EndIf

	If PanelPassedInspection = False Then
'		Jump PanelFailDropOffPoint LimZ zLimit
		suctionCups = False
		Wait suctionWaitTime ' Allow time for cups to unseal
		erPanelFailedInspection = True
		Pause
	Else
		retry:
		
		If outMagInt = True Then ' Check interlock status
			PushPanel = False
			GoTo exitPushPanel
		EndIf
		
'		WaitSig OutMagDropOffSignal
		Go Waypoint0
		Jump OutMagCenter -Z(recPanelThickness) LimZ zLimit Sense Sw(outMagIntH) = True
		
		If JS = False Then ' Jump executed without outmag interlock being opened
			suctionCupsCC = False
			Wait suctionWaitTime ' Allow time for cups to unseal				
			Signal OutputMagSignal ' Give permission for output magazine to dequeue next panel
		Else
			GoTo retry ' interlock was opened during a jump
		EndIf
		
	EndIf
	
		hsDataTxRdy = False 'reset flag	
		SystemStatus = MovingPanel
		Jump Waypoint0
		PushPanel = True
'		Signal OutMagRobotClearSignal ' Tell outmag the robot it out of the way, ok to move

exitPushPanel:

Trap 2 ' disarm trap	

Fend
Function FindPickUpError()
	
Real d1, d2
Integer i

Speed 10 'slow it down so we get a better reading
SpeedS 50
	
	Go PreScan - PanelOffset CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move ScanLong - PanelOffset CP Till Sw(LaserGo)
	
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
	Move (PreScan - PanelOffset) :U(CU(CurPos))
	Go (PreScan - PanelOffset) +U(180) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanLong - PanelOffset) :U(CU(CurPos)) CP Till Sw(LaserGo)
	d2 = CY(CurPos)
	yOffset = (d2 - d1) /2 ' I dont think its /2
	
'	Print "yOffset", yOffset
	
	d1 = 0
	d2 = 0
	
	ChangeProfile("00")
	Move (PreScan - PanelOffset) :U(CU(CurPos))
	Go (PreScan - PanelOffset) +U(90) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanShort - PanelOffset) :U(CU(CurPos)) CP Till Sw(LaserGo)
	
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
	Move (PreScan - PanelOffset) :U(CU(CurPos))
	Go (PreScan - PanelOffset) +U(270) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanShort - PanelOffset) :U(CU(CurPos)) CP Till Sw(LaserGo)
	d2 = CY(CurPos)

	xOffset = (d2 - d1) /2  ' I dont think its /2P23 - RotatedOffset
	
'	Print "xOffset", xOffset
	
	d1 = 0
	d2 = 0
	ChangeProfile("00")
	Move (PreScan - PanelOffset) :U(CU(CurPos))
	Go (PreScan - PanelOffset)
	
	PanelOffset = PanelOffset :X(xOffset) :Y(yOffset) 'update offset point
	Print "PanelOffset:", PanelOffset
			
Fend

	


