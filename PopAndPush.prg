#include "Globals.INC"

Function PopPanel() As Boolean
	
Trap 2, MemSw(abortJobH) = True GoTo exitPopPanel ' arm trap

suctionWaitTime = 1
zLimit = -2

retry:

	If inMagIntlock = True Then 'Check Interlock status
		PopPanel = False
		GoTo exitPopPanel
	EndIf
	
'	WaitSig InMagPickUpSignal ' Wait for inmag to confirm a panel is ready to be picked up
	Jump InMagCenter LimZ zLimit

	suctionCupsCC = True
	Wait suctionWaitTime ' Allow time for cups to seal on panel
	Jump Prescan LimZ zLimit
'	Signal InMagRobotClearSignal ' Give permission for input magazine to queue up next panel

	PopPanel = True
	SystemStatus = MovingPanel
	
	jobNumPanelsDone = jobNumPanelsDone + 1 ' Increment how many panels we have pulled		
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

	panelDataTxRdy = True ' Tell HMI to readout hole data
	MemOn (panelDataTxAckH) ' fake
	
	Wait MemSw(panelDataTxAckH) = True, 3
	
	If TW = True Then ' catch that the HMI timed out without acking
		PushPanel = False
		erHmiDataAck = True
		Print "no data ack from hmi"
		GoTo exitPushPanel
	EndIf
	
	If outMagInt = True Then ' Check interlock status
		PushPanel = False
		GoTo exitPushPanel
	EndIf
		
'	WaitSig OutMagDropOffSignal		
	Jump Waypoint1 LimZ zLimit
	Jump InMagCenter LimZ zLimit
	Jump Waypoint0 LimZ zLimit
	Jump OutMagCenter LimZ zLimit
'	Jump OutMagCenter -Z(recPanelThickness) LimZ zLimit
	suctionCupsCC = False
	Wait suctionWaitTime ' Allow time for cups to unseal				
	Jump Waypoint0
	Jump InMagCenter LimZ zLimit
	Signal OutputMagSignal ' Give permission for output magazine to dequeue next panel	
	
	PanelPassedInspection = True 'fake
	
	If PanelPassedInspection = False Then
		erPanelFailedInspection = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause ' wait for operator to continue
		stackLightRedCC = False ' turn off only after ack
		stackLightAlrmCC = False
	EndIf

	panelDataTxRdy = False 'reset flag
	SystemStatus = MovingPanel
	PanelPassedInspection = False ' rest flag
	PushPanel = True
'	Signal OutMagRobotClearSignal ' Tell outmag the robot it out of the way, ok to move

exitPushPanel:
	erPanelFailedInspection = False
	erHmiDataAck = False

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

	


