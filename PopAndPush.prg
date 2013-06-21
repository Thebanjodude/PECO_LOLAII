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
	
	Motor On ' fake for test
	
	Real x1, y1, x0, y0, dtheta, dx, dy, r1, r2, ThetaT, thetaE, thetaA
	Real da
	Integer i
	PanelPickupCorct = PanelPickupCorct :X(0) :Y(0) :Z(0) :U(0) ' initialize to zero

	Go PreScan CP  ' Use CP so it's not jumpy
	Wait .25
	ThetaT = CalculateThetaT(0, 8)
	Print "ThetaT", ThetaT

'For i = 0 To 15
	FindYpickupError(0, 0) ' Go to the zero hole and find the pick up error
	hole0 = Here
	x0 = CX(hole0)
	Print "x0:", x0
	y0 = CY(hole0)
	Print "y0", y0
	PanelPickupCorct = PanelPickupCorct :X(0) :Y(0) :Z(0) :U(0) 'reset
	Print "going to hole 1"
	Go PreScan CP
	FindYpickupError(8, 0)
'Next
'	PrintCoordQuillArray()
	hole1 = Here
	x1 = CX(hole1)
	Print "x1:", x1
	y1 = CY(hole1)
	Print "y1", y1
	dx = x0 - x1
	dy = y0 - y1
	
	Print dx, dy
	thetaA = RadToDeg(Atan(dy / dx))
	Print "thetaA", thetaA
	
	thetaE = thetaA - ThetaT
	Print "ThetaE", ThetaE
	
	FindYpickupError(0, 90 - ThetaE) ' Go to the zero hole and find the pick up error
	hole0 = Here
	x0 = CX(hole0)
	Print x0
	y0 = CY(hole0)
	Print y0
	PanelPickupCorct = PanelPickupCorct :X(0) :Y(0) :Z(0) :U(0) 'reset
	Print "going to hole 1"
	FindYpickupError(8, 90 - ThetaE)
	hole1 = Here
		
	x1 = CX(hole1)
	Print x1
	y1 = CY(hole1)
	Print y1
	dx = x0 - x1
	dy = y0 - y1
	
	Print dx, dy
	thetaA = RadToDeg(Atan(dy / dx))
	Print "da", thetaA
	
	thetaE = thetaA - ThetaT
	Print "ThetaE", ThetaE
	
	
'	PanelPickupCorct = PanelPickupCorct :X(0) :Y(0) :Z(0) :U(-dtheta) ' initialize to zero 
'	
'	FindYpickupError(0) ' now go back to the first hole, see what the real errors are
'	FindYpickupError(1) ' then go back to the other hole and test that its zero
			
Fend
Function CalculateThetaT(Hole0 As Integer, Hole1 As Integer) As Real
	
	Real tHole0x, tHole0y, tHole1x, tHole1y
	
	GetPanelCoords()
	
	'pull the coordinates and assign them
	tHole0x = PanelCordinates(Hole0, 0)
	tHole0y = PanelCordinates(Hole0, 1)
	tHole1x = PanelCordinates(Hole1, 0)
	tHole1y = PanelCordinates(Hole1, 1)
	
	Print "dx", tHole0x - tHole1x
	Print "dy", tHole0y - tHole1y
	
	'this is a special case for 180 deg apart
	CalculateThetaT = RadToDeg(Atan((tHole0y - tHole1y) / (tHole0x - tHole1x))) ' find the theta between the holes
	Print CalculateThetaT
Fend
Function FindYpickupError(holenumber As Integer, ThetaE As Real) As Real
	
	Motor On
	Power Low
	Real dy1, dy2, XpickupError, YpickupError, AnvilOffset, x0, y0, thetaerror
	
'	Go PreScan CP
	YpickupError = 0
	XpickupError = 0
	zLimit = 0 ' fake for testing
	HolecenterY = HolecenterY :X(0) :Y(0) :U(0) :Z(0) 'reset
	GetPanelArray() ' fake for testing
	DerivethetaR() ' fake for testing

'	x0 = PanelCordinates(holenumber, 0) ' get hole coordinates
'	y0 = PanelCordinates(holenumber, 1)

	r = PanelArray(holenumber, 0)
	theta = PanelArray(holenumber, 1)
	Print "theta,r", Theta, r
	
	HolecenterY = Lasercenter +X(r) :U(-Theta + 45 + ThetaE)
'	HolecenterY = Lasercenter +X(x0) +Y(y0) :U(45 + ThetaE) '+ PanelPickupCorct  ' guess where the first hole is
	Go HolecenterY  ' Go to where we think the first hole is
	Wait .25
	ChangeProfile("00")
	dy1 = GetLaserMeasurement("03")
	dy2 = GetLaserMeasurement("04")

	YpickupError = -(dy2 + dy1) / 2 ' calculate the y error	negate so it moves to correct itself
	
	HolecenterY = HolecenterY +Y(YpickupError)
	Move HolecenterY ' make the correction
	Wait .25 ' wait for panel to settle under the laser
	
	If Abs(YpickupError) <= .01 Then
		Print "Ben, you need to go through the loop more times!"
	EndIf
	
	Move HoleCenterY +X(25) ' pull back from the hole and then...
	Move HolecenterY +X(-45) CP Till Sw(holeDetectedH) ' move until we find the hole center
	
	If TillOn = False Then ' if we didnt see a hole then throw and error
		Print "missed hole"
		erPanelStatusUnknown = True
		Pause
'		Go PreScan ' go to way point
	Else
		erPanelStatusUnknown = False
	EndIf
	
'	XpickupError = CX(Here) - CX(LaserCenter) - x0
	' if laser is calibrated wrong it will mess up the X error calculation

'	PanelPickupCorct = PanelPickupCorct :X(XpickupError) :Y(YpickupError) 'update error point
'	Print "PanelPickupCorct", PanelPickupCorct
	
	PanelCordinatesQuill(holenumber, 0) = CX(Here)
	PanelCordinatesQuill(holenumber, 1) = CY(Here)
	
'	Pause
'	Go PreScan CP
'	Print "going to center"
'	HolecenterY = Lasercenter +X(r) :U(-Theta + 45) + PanelPickupCorct '+ RotatedOffset
'	Go HolecenterY
'	Pause
'	Jump LaserToHeatStake LimZ zLimit 'jump to waypoint
'	Pause
'	P23 = HotStakeCenter -Y(Sin(DegToRad(45)) * PanelArray(0, RadiusColumn)) +X(Cos(DegToRad(45)) * PanelArray(0, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn))
'	Jump P23 LimZ zLimit
'	Pause
'	P23 = P23 +X(Cos(DegToRad(45) * XpickupError)) +Y(Sin(DegToRad(45)) * YpickupError)
'	Jump P23 LimZ zLimit
	
'	SFree 1, 2
'	
'	AnvilOffset = 0
'	Do Until Sw(HSPanelPresntH) = True
'		Go P23 -Z(AnvilOffset)
'		AnvilOffset = AnvilOffset + 0.50
'	Loop
'	
'	SLock 1, 2
	
'	Pause
'	Jump LaserToHeatStake LimZ zLimit 'jump to waypoint
'	P23 = HotStakeCenter -Y(Sin(DegToRad(45)) * PanelArray(8, RadiusColumn)) +X(Cos(DegToRad(45)) * PanelArray(8, RadiusColumn)) :U(PanelArray(8, ThetaColumn))
'	Pause
'	P23 = P23 +X(-XpickupError) +Y(-YpickupError)
'	Jump P23 LimZ zLimit
'	
'	AnvilOffset = 0
'	Do Until Sw(HSPanelPresntH) = True
'		Go P23 -Z(AnvilOffset)
'		AnvilOffset = AnvilOffset + 0.25
'	Loop
	
'	RotatedError(Theta)
'	Print P23
'	P23 = P23 + RotatedOffset
'	Go P23

Fend
'Function FindYpickupError2(holenumber As Integer) As Real
'	
'	Motor On
'	Power Low
'	Real dy1, dy2, XpickupError, YpickupError, AnvilOffset, x0, y0, thetaerror
'	
'	Go PreScan CP
'	YpickupError = 0
'	XpickupError = 0
'	zLimit = 0 ' fake for testing
'	HolecenterY = HolecenterY :X(0) :Y(0) :U(0) :Z(0) 'reset
'	GetPanelArray() ' fake for testing
'	DerivethetaR()
'
'	r = PanelArray(holenumber, 0) ' get hole  info
'	theta = PanelArray(holenumber, 1)
'	
'	HolecenterY = Lasercenter +X(r) :U(-Theta - 45)
'	Go HolecenterY  ' Go to where we think the first hole is
'	ChangeProfile("00")
'	dy1 = GetLaserMeasurement("03")
'	dy2 = GetLaserMeasurement("04")
'
'	YpickupError = -(dy2 + dy1) / 2 ' calculate the y error	negate so it moves to correct itself
''	Print "YpickupError", YpickupError ' print for testing
'	Pause
'	HolecenterY = HolecenterY +Y(YpickupError)
'	Move HolecenterY ' make the correction
'	Wait .1 ' wait for panel to settle under the laser
'	
'	Move HoleCenterY +X(25) ' pull back from the hole and then...
'	Move HolecenterY +X(-58) CP Till Sw(holeDetectedH) ' move until we find the hole center
'	
'	If TillOn = False Then ' if we didnt see a hole then throw and error
'		Print "missed hole"
'		erPanelStatusUnknown = True
'		Pause
''		Go PreScan ' go to way point
'	Else
'		erPanelStatusUnknown = False
'	EndIf
'	
'	XpickupError = CX(Here) - CX(LaserCenter) - r
'	' if laser is calibrated wrong it will mess up the X error calculation
''	Print "XpickupError,YpickupError", XpickupError, YpickupError
'
'	PanelPickupCorct = PanelPickupCorct :X(XpickupError) :Y(YpickupError) 'update error point
'	Print "PanelPickupCorct", PanelPickupCorct
'	
'	x = CX(Here)
'	y = CY(Here)
'	Theta = CU(Here)
	
	'put them into an array...
'	Go PreScan CP
'	Print "going to center"
'	HolecenterY = Lasercenter +X(r) :U(-Theta + 45) + PanelPickupCorct '+ RotatedOffset
'	Go HolecenterY
'	Pause
'	Jump LaserToHeatStake LimZ zLimit 'jump to waypoint
'	Pause
'	P23 = HotStakeCenter -Y(Sin(DegToRad(45)) * PanelArray(0, RadiusColumn)) +X(Cos(DegToRad(45)) * PanelArray(0, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn))
'	Jump P23 LimZ zLimit
'	Pause
'	P23 = P23 +X(Cos(DegToRad(45) * XpickupError)) +Y(Sin(DegToRad(45)) * YpickupError)
'	Jump P23 LimZ zLimit
	
'	SFree 1, 2
'	
'	AnvilOffset = 0
'	Do Until Sw(HSPanelPresntH) = True
'		Go P23 -Z(AnvilOffset)
'		AnvilOffset = AnvilOffset + 0.50
'	Loop
'	
'	SLock 1, 2
	
'	Pause
'	Jump LaserToHeatStake LimZ zLimit 'jump to waypoint
'	P23 = HotStakeCenter -Y(Sin(DegToRad(45)) * PanelArray(8, RadiusColumn)) +X(Cos(DegToRad(45)) * PanelArray(8, RadiusColumn)) :U(PanelArray(8, ThetaColumn))
'	Pause
'	P23 = P23 +X(-XpickupError) +Y(-YpickupError)
'	Jump P23 LimZ zLimit
'	
'	AnvilOffset = 0
'	Do Until Sw(HSPanelPresntH) = True
'		Go P23 -Z(AnvilOffset)
'		AnvilOffset = AnvilOffset + 0.25
'	Loop
	
'	RotatedError(Theta)
'	Print P23
'	P23 = P23 + RotatedOffset
'	Go P23

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
	
'	Print "LaserXcoordinate", LaserXcoordinate
	
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
	


