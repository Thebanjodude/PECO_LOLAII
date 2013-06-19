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
	
	Real dx, dy, dtheta
	
	PanelPickupError = PanelPickupError :X(0) :Y(0) :Z(0) :U(0) ' initialize to zero

	Go PreScan CP  ' Use CP so it's not jumpy
	Wait .25
	
'	dy = FindYpickupError(0) ' Go to the zero hole and find the Y pick up error
'	dx = FindXpickupError(0) ' Find the X pick up error

'	PanelPickupError = PanelPickupError :X(dx) :Y(dy) 'update error point
'	Print "PanelPickupError:", PanelPickupError
'test-----	
	r = PanelArray(0, 0)
	theta = PanelArray(0, 1)
	
 	Move Lasercenter +X(r) :U(Theta) + PanelPickupError
 	Pause
'----------	
	' when we rotate 90 deg then dx and dy switch
'	dx = FindXpickupError(4) ' Go to the zero hole and find the X pick up error
'	dy = FindYpickupError(4) ' Find the Y pick up error
	' If dx and dy were zero then there was no theta pick up error	
	
	dtheta = Atan(dy / dx) ' this is an area of suspicion
	
	PanelPickupError = PanelPickupError :X(0) :Y(0) :U(dtheta) 'update error point
	Print "PanelPickupError:", PanelPickupError
	
	' Now we need to go back to the first hole and find the real XY pick up error with the theta 	
	'error accounted for
'	dy = FindYpickupError(0) ' go to the zero hole and find the Y pick up error
'	dx = FindXpickupError(0) ' Find the X pick up error
	
	PanelPickupError = PanelPickupError :X(dx) :Y(dy)  'update error point
	Print "PanelPickupError:", PanelPickupError
	
	FindPickUpError = True
	
	Print "done"
	Pause
			
Fend
Function FindYpickupError(holenumber As Integer) As Real
	
	Motor On
	Power High
	
	' code somthing so when theta =! 0 for the first hole and theta=! 90 for the second
	
	Real dy1, dy2, XpickupError, YpickupError, AnvilOffset
	
	Jump PreScan CP LimZ zLimit  ' Use CP so it's not jumpy
	
	zLimit = 0 ' fake for testing
	
	GetPanelArray() ' fake for testing
	DerivethetaR()
	
	r = PanelArray(holenumber, 0)
	theta = PanelArray(holenumber, 1)
	
	Print r, Theta
	
	' Add pickuperror point to the move?
	HolecenterY = Lasercenter +X(r) :U(Theta + 45) ' guess where the first hole is
	Move HolecenterY ' Go to where we think the first hole is
	ChangeProfile("00")
	Pause
	dy1 = GetLaserMeasurement("03")
	dy2 = GetLaserMeasurement("04")
		
'Do Until Abs((dy2 + dy1) / 2) <= .01 ' the error is +- .01mm

	YpickupError = -(dy2 + dy1) / 2 ' calculate the y error	
		
	HolecenterY = HolecenterY +Y(YpickupError)
	Move HolecenterY ' make the correction
	Wait .25
	dy1 = GetLaserMeasurement("03")
	dy2 = GetLaserMeasurement("04")
	Print "dy1,dy2", dy1, dy2 ' print for testing
	
	If Abs((dy2 + dy1) / 2) <= .01 Then
		Print "Ben, you need to go through the loop more times"
	EndIf
' if we loop we need to accumulare the error	
'Loop
	
	Print HolecenterY
	
	Move HoleCenterY +X(25) ' pull back from the hole and then...
	Move HolecenterY +X(-58) CP Till Sw(holeDetectedH) ' move until we find the hole center
	 
	Pause
	
	If TillOn = False Then ' if we didnt see a hole then throw and error
		Print "missed hole"
		erPanelStatusUnknown = True
	Else
		erPanelStatusUnknown = False
	EndIf
	
	XpickupError = (CX(Here) - CX(LaserCenter)) - r ' calculate the dx error
	Print "XpickupError,YpickupError", XpickupError, YpickupError
	
	Jump LaserToHeatStake LimZ zLimit 'jump to waypoint
	Pause
	P23 = HotStakeCenter -Y(Sin(DegToRad(45)) * PanelArray(0, RadiusColumn)) +X(Cos(DegToRad(45)) * PanelArray(0, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn))
	Jump P23 LimZ zLimit
	Pause
	P23 = P23 +X(XpickupError) +Y(YpickupError)
	Jump P23 LimZ zLimit
	
	SFree 1, 2
	
	AnvilOffset = 0
	Do Until Sw(HSPanelPresntH) = True
		Go P23 -Z(AnvilOffset)
		AnvilOffset = AnvilOffset + 0.25
	Loop
	
	SLock 1, 2
	
	Pause
	Jump LaserToHeatStake LimZ zLimit 'jump to waypoint
	P23 = HotStakeCenter -Y(Sin(DegToRad(45)) * PanelArray(8, RadiusColumn)) +X(Cos(DegToRad(45)) * PanelArray(8, RadiusColumn)) :U(PanelArray(8, ThetaColumn))
	Pause
	P23 = P23 +X(-XpickupError) +Y(-YpickupError)
	Jump P23 LimZ zLimit
	
	AnvilOffset = 0
	Do Until Sw(HSPanelPresntH) = True
		Go P23 -Z(AnvilOffset)
		AnvilOffset = AnvilOffset + 0.25
	Loop
	
'	RotatedError(Theta)
'	Print P23
'	P23 = P23 + RotatedOffset
'	Go P23

Fend
'Function FindXpickupError(holenumber As Integer) As Real
'	
'	' code somthing so when theta =! 0 for the first hole and theta=! 90 for the second\
'	Speed 1 'slow it down so we get a better reading
'	SpeedS 5
'	Go PreScan CP  ' Use CP so it's not jumpy	
'	
'	r = PanelArray(holenumber, 0) ' get theta and r
'	theta = PanelArray(holenumber, 1)
'	
'	ChangeProfile("00") ' change to hole finding profile
'	Move Lasercenter :X(-475) :Y(-58.56) :U(Theta + 45) :Z(-14) CP Till Sw(holeDetectedH) ' move until we find the hole
'	Pause
'	If TillOn = False Then ' if we didnt see a hole then throw and error
'		Print "missed edge"
'		erPanelStatusUnknown = True
'	Else
'		erPanelStatusUnknown = False
'	EndIf
'
'	FindXpickupError = (CU(Here) - CX(LaserCenter)) - r ' calculate the dx error
'	Print "FindXpickupError", FindXpickupError
'
'Fend

'Function FindPickUpError() As Boolean
'	
'Real d1, d2
'Real xerror1, xerror2, midpoint
'Real yerror1, yerror2
'Integer i
'
'PanelPickupError = PanelPickupError :X(0) :Y(0) :X(0) :U(0)
'
'Speed 10 'slow it down so we get a better reading
'SpeedS 50
'	
'	Go PreScan CP  ' Use CP so it's not jumpy
'	Wait .25
'	
'	ChangeProfile("03")
'	Move ScanLong CP Till Sw(edgeDetectGoH)
'	
'	If TillOn = False Then
'		Print "missed edge"
'		erPanelStatusUnknown = True
'	Else
'		erPanelStatusUnknown = False
'	EndIf
'	
'	d1 = CX(CurPos)
'	Print "d1", d1
'	
'	ChangeProfile("00") ' Null profile
'	Move (PreScan) :U(CU(CurPos))
'	Go (PreScan) +U(180) CP  ' Use CP so it's not jumpy
'	Wait .25
'	
'	ChangeProfile("03")
'	Move (ScanLong) :U(CU(CurPos)) CP Till Sw(edgeDetectGoH)
'	
'	If TillOn = False Then
'		Print "missed edge"
'		erPanelStatusUnknown = True
'	Else
'		erPanelStatusUnknown = False
'	EndIf
'	
'	d2 = CX(CurPos)
'	Print "d2", d2
'	midpoint = (d1 + d2) /2
'	Print "midpoint", midpoint
'	
'	xerror1 = Abs(midpoint - d1)
'	xerror2 = Abs(midpoint - d2)
'	Print "xerror1", xerror1
'	Print "xerror2", xerror2
'	
'	xerror = (xerror1 + xerror2) /2
'	
'	If d1 > d2 Then
'		xerror = -xerror
'	EndIf
'	
'	Print "xerror", xerror
'	
'	d1 = 0
'	d2 = 0
'	midpoint = 0
'	
'	ChangeProfile("00") ' Null profile
'	Move (PreScan) :U(CU(CurPos))
'	Go (PreScan) -U(90) CP  ' Use CP so it's not jumpy
'	Wait .25
'	
'	ChangeProfile("03")
'	Move (ScanShort) :U(CU(CurPos)) CP Till Sw(edgeDetectGoH)
'	
'	If TillOn = False Then
'		Print "missed edge"
'		erPanelStatusUnknown = True
'	Else
'		erPanelStatusUnknown = False
'	EndIf
'	'Use Cx in both x and y offsets because we are only modulating along the x-axis
'	d1 = CX(CurPos)
'	Print "d1", d1
'
'	ChangeProfile("00") ' Null profile
'	Move (PreScan) :U(CU(CurPos))
'	Go (PreScan) -U(270) CP  ' Use CP so it's not jumpy
'	Wait .25
'	
'	ChangeProfile("03")
'	Move (ScanShort) :U(CU(CurPos)) CP Till Sw(edgeDetectGoH)
'	
'	If TillOn = False Then
'		Print "missed edge"
'		erPanelStatusUnknown = True
'	Else
'		erPanelStatusUnknown = False
'	EndIf
'	
'	d2 = CX(CurPos)
'	Print "d2", d2
'	
'	midpoint = (d1 + d2) /2
'	Print "midpoint", midpoint
'	
'	yerror1 = Abs(midpoint - d1)
'	yerror2 = Abs(midpoint - d2)
'	Print "yerror1", yerror1
'	Print "yerror2", yerror2
'	
'	yerror = (yerror1 + yerror2) /2
'	
'	If d1 > d2 Then
'		yerror = -yerror
'	EndIf
'	
'	Print "yerror", yerror
'	
'	d1 = 0
'	d2 = 0
'	midpoint = 0
'	
'	ChangeProfile("00") ' Null profile
'	Move (PreScan) :U(CU(CurPos))
'	Go (PreScan)
'	
'	PanelPickupError = PanelPickupError :X(xerror) :Y(yerror) 'update error point
'	Print "PanelPickupError:", PanelPickupError
'	
'	FindPickUpError = True
'	
'	Print "done"
'	Pause
'			
'Fend
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
	Wait .5 ' wait for EOAT to settle
	
	EOATyerror = -1 * GetLaserMeasurement("01")
	Print "EOATyerror", EOATyerror

	Do Until Abs(EOATyerror) <= 0.02
		LaserCalibrY = LaserCalibrY +Y(EOATyerror)
		Go LaserCalibrY
		Wait 1
		EOATyerror = -1 * GetLaserMeasurement("01")
		Print "EOATyerror", EOATyerror
	Loop
	Pause
	
	LaserYcoordinate = CY(Here) - 16.02 ' add the EOAT step offset	
	LaserCalibrY = LaserCalibrY :Y(LaserYcoordinate)
	Print "LaserYcoordinate", LaserYcoordinate
	Go LaserCalibrY ' go to where the center of the EOAT is
	Pause
	
	Go PreScan :Z(-85) CP  ' Use CP so it's not jumpy
	Wait .25
	
	ChangeProfile("11")
	Move LaserCalibrMax :Y(LaserYcoordinate) CP Till Sw(edgeDetectGoH) ' capture the very tip of the EOAT

	 If TillOn = False Then ' if we get to Laser calibr then we missed 
	 	Print "missed EOAT"
	 EndIf
		
	x1 = CX(CurPos) ' x1 is where we captured the tip
	Print "x1", x1
	
	LaserXcoordinate = x1 - (eoatLegnth /2) ' distance between the quill center and laser
	
	Print "LaserXcoordinate", LaserXcoordinate
	
' comment this out until it matters	
'	zoffset = GetLaserMeasurement("15")
'	LaserZcoordinate = CZ(LaserCalibrMax) + zoffset
'	
'	zoffset = GetLaserMeasurement("15")
'	Do Until EOATyerror <= .02
'		zoffset = GetLaserMeasurement("15")
'		Print "zoffset", zoffset
'		LaserCalibrY = LaserCalibrY +Z(zoffset)
'		Go LaserCalibrY
'		Wait .25
'	Loop
	
	Pause
'	
'	' It is important to know that LaserCenter is defined as 0,0 and
'	' populated by this function. It will remain 0,0 in the points table
'	' but the calibrated values are set in memory.
'	
	LaserCenter = LaserCenter :X(LaserXcoordinate) :Y(LaserYcoordinate) :Z(LaserZcoordinate)
	Print "LaserCenter", LaserCenter
	
Fend
	


