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
Real xerror1, xerror2, midpoint
Real yerror1, yerror2
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
	Print "d1", d1
	
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
	Print "d2", d2
	midpoint = (d1 + d2) /2
	Print "midpoint", midpoint
	
	xerror1 = Abs(midpoint - d1)
	xerror2 = Abs(midpoint - d2)
	Print "xerror1", xerror1
	Print "xerror2", xerror2
	
	xerror = (xerror1 + xerror2) /2
	
	If d1 > d2 Then
		xerror = -xerror
	EndIf
	
	Print "xerror", xerror
	
	d1 = 0
	d2 = 0
	midpoint = 0
	
	ChangeProfile("00") ' Null profile
	Move (PreScan) :U(CU(CurPos))
	Go (PreScan) -U(90) CP  ' Use CP so it's not jumpy
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
	Print "d1", d1

	ChangeProfile("00") ' Null profile
	Move (PreScan) :U(CU(CurPos))
	Go (PreScan) -U(270) CP  ' Use CP so it's not jumpy
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
	Print "d2", d2
	
	midpoint = (d1 + d2) /2
	Print "midpoint", midpoint
	
	yerror1 = Abs(midpoint - d1)
	yerror2 = Abs(midpoint - d2)
	Print "yerror1", yerror1
	Print "yerror2", yerror2
	
	yerror = (yerror1 + yerror2) /2
	
	If d1 > d2 Then
		yerror = -yerror
	EndIf
	
	Print "yerror", yerror
	
	d1 = 0
	d2 = 0
	midpoint = 0
	
	ChangeProfile("00") ' Null profile
	Move (PreScan) :U(CU(CurPos))
	Go (PreScan)
	
	PanelPickupError = PanelPickupError :X(xerror) :Y(yerror) 'update error point
	Print "PanelPickupError:", PanelPickupError
	
	FindPickUpError = True
	
	Print "done"
	Pause
			
Fend
Function CalibrateLaserLocation()
	
Real eoatLegnth, EOATyerror, zoffset
Real x1, LaserXcoordinate, LaserYcoordinate, LaserZcoordinate

'At the start LaserCalibrY is approx where the EAOT drop off is.

eoatLegnth = InTomm(12.5) ' overall dim
	
Speed 25 'slow it down so we get a better reading
SpeedS 50

	Go PreScan :Z(-85) CP  ' Use CP so it's not jumpy			
	ChangeProfile("12")
	
	Move LaserCalibrY CP ' go to about where the drop off should be
	Wait 1 ' wait for EOAT to settle
	
	EOATyerror = -1 * GetLaserMeasurement("01")
	Print "EOATyerror", EOATyerror
	Pause
	Do Until Abs(EOATyerror) <= 0.01
		LaserCalibrY = LaserCalibrY +Y(EOATyerror)
		Go LaserCalibrY
		Wait 1
		EOATyerror = -1 * GetLaserMeasurement("01")
		Print "EOATyerror", EOATyerror
	Loop

	Pause
	
	LaserYcoordinate = CY(LaserCalibrY) - 16.02 ' add the EOAT step offset	
	LaserCalibrY = LaserCalibrY :Y(LaserYcoordinate)
	Go LaserCalibrY
	Wait .25
	
'	Print -1 * GetLaserMeasurement("01") 'test-error should be 16.02	
	Print "LaserYcoordinate", LaserYcoordinate
	Pause
	
	Go PreScan :Z(-85) CP  ' Use CP so it's not jump
	Wait .25
	
	ChangeProfile("11")
	Move LaserCalibrMax :Y(CY(LaserCalibrY)) CP Till Sw(edgeDetectGoH) ' capture the very tip of the EOAT

	 If TillOn = True Then ' if we get to Laser calibr then we missed 
	 	Print "missed EOAT"
	 EndIf
		
	x1 = CX(CurPos) ' x1 is where we captured the tip
	Print "x1", x1
	
	LaserXcoordinate = x1 - (eoatLegnth /2) ' distance between the quill center and laser
	
	Print "LaserXcoordinate", LaserXcoordinate
	
	zoffset = GetLaserMeasurement("14")
	LaserZcoordinate = CZ(LaserCalibrMax) + zoffset
	
	zoffset = GetLaserMeasurement("14")
	Do Until EOATyerror <= .02
		zoffset = GetLaserMeasurement("14")
		Print "zoffset", zoffset
		LaserCalibrY = LaserCalibrY +Z(zoffset)
		Go LaserCalibrY
		Wait .25
	Loop
	
	Pause
'	
'	' It is important to know that LaserCenter is defined as 0,0 and
'	' populated by this function. It will remain 0,0 in the points table
'	' but the calibrated values are set in memory.
'	
'	LaserCenter = LaserCenter :X(LaserXcoordinate) :Y(LaserYcoordinate)
'	Print "LaserCenter", LaserCenter
	
Fend
	


