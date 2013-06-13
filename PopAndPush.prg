#include "Globals.INC"

Function PopPanel() As Boolean
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPopPanel ' arm trap

suctionWaitTime = .5 'fake
zLimit = -2 'fake

retry:

	If inMagInterlock = True Then 'Check Interlock status
		PopPanel = False
		GoTo exitPopPanel
	EndIf
	
'	WaitSig InMagPickUpSignal ' Wait for inmag to confirm a panel is ready to be picked up
	Jump InMagCenter LimZ zLimit

	suctionCupsCC = True
	On (suctionCupsH) ' fake
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
If MemSw(jobAbortH) = True Then 'check if the operator wants to abort the job
	jobAbort = True
EndIf

Trap 2 'disarm trap
    
Fend
Function PushPanel() As Boolean
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPushPanel ' arm trap
	
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
'	Jump Waypoint1 LimZ zLimit
'	Jump Waypoint0 LimZ zLimit
	Jump OutMagCenter LimZ zLimit
'	Jump OutMagCenter -Z(recPanelThickness) LimZ zLimit
	suctionCupsCC = False
	Wait suctionWaitTime ' Allow time for cups to unseal				
	Jump Waypoint0 LimZ zLimit
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
	PushPanel = True 'fake??
'	Signal OutMagRobotClearSignal ' Tell outmag the robot it out of the way, ok to move

exitPushPanel:
	erPanelFailedInspection = False
	erHmiDataAck = False

Trap 2 ' disarm trap	

Fend
Function FindPickUpError() As Boolean
	
Real d1, d2
Integer i

PanelPickupError = PanelPickupError :X(0) :Y(0) :X(0) :U(0)

Speed 10 'slow it down so we get a better reading
SpeedS 50
	
	Go PreScan CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move ScanLong CP Till Sw(edgeDetectGoH)
	
	If TillOn = False Then
		Print "missed edge"
		erPanelStatusUnknown = True
	Else
		erPanelStatusUnknown = False
	EndIf
	
	d1 = CX(CurPos)
	
	ChangeProfile("00") ' Null profile
	Move (PreScan) :U(CU(CurPos))
	Go (PreScan) +U(180) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanLong) :U(CU(CurPos)) CP Till Sw(edgeDetectGoH)
	
	If TillOn = False Then
		Print "missed edge"
		erPanelStatusUnknown = True
	Else
		erPanelStatusUnknown = False
	EndIf
	
	d2 = CX(CurPos)
	xerror = Abs((d1 - d2) / 2)
	
	If d1 > d2 Then
		xerror = -xerror
	EndIf
	
	Print "xerror", xerror
	
	d1 = 0
	d2 = 0
	
	ChangeProfile("00") ' Null profile
	Move (PreScan) :U(CU(CurPos))
	Go (PreScan) +U(90) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanShort) :U(CU(CurPos)) CP Till Sw(edgeDetectGoH)
	
	If TillOn = False Then
		Print "missed edge"
		erPanelStatusUnknown = True
	Else
		erPanelStatusUnknown = False
	EndIf
	'Use Cx in both x and y offsets because we are only modulating along the x-axis
	d1 = CX(CurPos)

	ChangeProfile("00") ' Null profile
	Move (PreScan) :U(CU(CurPos))
	Go (PreScan) +U(270) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("03")
	Move (ScanShort) :U(CU(CurPos)) CP Till Sw(edgeDetectGoH)
	
	If TillOn = False Then
		Print "missed edge"
		erPanelStatusUnknown = True
	Else
		erPanelStatusUnknown = False
	EndIf
	
	d2 = CX(CurPos)
	yerror = (d1 - d2) /2
	
	If d1 > d2 Then
		yerror = -yerror
	EndIf
	
	Print "yerror", yerror
	
	d1 = 0
	d2 = 0
	
	ChangeProfile("00") ' Null profile
	Move (PreScan) :U(CU(CurPos))
	Go (PreScan)
	
	PanelPickupError = PanelPickupError :X(xerror) :Y(yerror) 'update error point
	Print "PanelPickupError:", PanelPickupError
	
	FindPickUpError = True
	
	Print "done"
	Pause
			
Fend

	


