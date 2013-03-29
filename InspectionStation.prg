#include "Globals.INC"
Global Integer FirstHolePoint, DoubleTriggered
Global Real CurrentTheta, LastTheta

Function ScanPanel() ' This code is just a place holder until we work out the edge following...

Motor On
Power Low
SpeedS 500
AccelS 1000
SpeedR 400
AccelR 300
Speed 10
Accel 10, 10

Integer t


retrace:
GetPanelArray()
PrintPanelArray()

FindPickUpError()

Pause


PanelArrayIndex = 0
'Trap 1 ' turn off trap

GoTo retrace

Fend
Function FindPickUpError()
	
Real distance, error1, d1, d2
Real yOffset1, yOffset2
Integer i

'recMajorDim = 247.142
'recMinorDim = 143.764

Speed 10 'slow it down so we get a better reading
SpeedS 20
	
	Go ScanCenter3 CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 CP Till Sw(laserGo)
	d1 = CY(CurPos)
	On (laserP1)
	
	Go ScanCenter3 +U(180) CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 +U(180) CP Till Sw(laserGo)
	d2 = CY(CurPos)
	On (laserP1)
	yOffset = d1 - d2
	
	Print "yOffset", yOffset
	
	d1 = 0
	d2 = 0
	
	Go ScanCenter3 +U(90) CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 +U(90) CP Till Sw(laserGo)
	d1 = CY(CurPos)
	On (laserP1)
	
	Go ScanCenter3 +U(270) CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 +U(270) CP Till Sw(laserGo)
	d2 = CY(CurPos)
	On (laserP1)
	xOffset = d1 - d2
	
	Print "xOffset", xOffset
	
	d1 = 0
	d2 = 0
	
'	thetaOffset = Asin(yOffset / xOffset)

'	Move ScanCenter4 Till Sw(laserGo)
'	distance = 635 - CY(CurPos) '635mm is an eyeballed y coordinate of laser scannr
'	yOffset1 = recMajorDim - distance
'
'	Print "CY(CurPos)", CY(CurPos)
'	Print "yoffset1:", yOffset1
'	
'	Move ScanCenter3 +U(180) ROT  ' Use CP so it's not jumpy, may need to be abs :U
'	Wait .5
'	
'	Move ScanCenter4 +U(180) Till Sw(laserGo)
'	distance = 635 - CY(CurPos) '635mm is an eyeballed y coordinate of laser scannr
'	yOffset2 = recMajorDim - distance
'	Print "yoffset2:", yOffset2
'	
'	error1 = yOffset1 - yOffset2
'	
'	Print "error1", error1
		
'	Move ScanCenter3 +U(90) CP   ' Use CP so it's not jumpy, may need to be abs :U
'	Wait .5
'	
'	Move ScanCenter4 +U(90) CP Till Sw(laserGo)
'	distance = 635 - CY(CurPos) '635mm is an eyeballed y coordinate of laser scannr
'	xOffset = recMinorDim - distance
''	Print "CY(CurPos)", CY(CurPos)
'	Print "xoffset:", xOffset

	Go Home1

Fend
Function Inspection() As Boolean
	SystemStatus = InspectingPanel
	
	Boolean SkippedHole
	Integer k
	Real tanxOffset, tanThetaOffset, tanyOffset
  	
  	DerivethetaR()
	GetThetaR() 'get first r and theta
'	On (laserP2) 'Switch to insert inspection profile
	Print xOffset
	Print yOffset
	
	For k = 0 To recNumberOfHoles - 1
		
		If k <> 0 Then
			IncrementIndex()
			GetThetaR()
			
			If r = 0 Then
				Print "r=0"
				Pause
			EndIf
		EndIf

		SkippedHole = False 'Reset flag
		
		If PanelArray(PanelArrayIndex, SkipFlagColumn) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 'Set flag
		EndIf

		If SkippedHole = False Then 'If the flag is set then we have finished all holes		
			
		'	tanThetaOffset = 90 - PanelArray(PanelArrayIndex, ThetaColumn)
			tanxOffset = PanelArray(PanelArrayIndex, RadiusColumn) * Sin(90 - PanelArray(PanelArrayIndex, ThetaColumn))
			tanxOffset = PanelArray(PanelArrayIndex, RadiusColumn) * Cos(90 - PanelArray(PanelArrayIndex, ThetaColumn))
			Print "tanThetaOffset", tanThetaOffset
			Print "tanxOffset", tanxOffset
			Print "tanyOffset", tanyOffset
			
			P23 = InspectionCenter -Y(PanelArray(PanelArrayIndex, RadiusColumn) + yOffset) +X(xOffset) :U(PanelArray(PanelArrayIndex, ThetaColumn) + 90)
			Print "P23", P23
			'Pause
			
			Wait 1.5
			Move P23 CP
			P23 = InspectionCenter -Y(tanyOffset) +X(+tanxOffset) +U(tanThetaOffset)
			
			Wait 1.5
			'Pass/fail stuff goes here
				'Return Pass/Fail, work with Scott on the logging aspect 
			'	If PanelPassedInspection = False Then
			'		erPanelFailedInspection = True
			'		SystemPause()
			'	Else
			'		erPanelFailedInspection = False
			'	EndIf
		EndIf

	Next
	
	SystemStatus = MovingPanel
	Go ScanCenter3 ' Collision Avoidance Waypoint
	
Fend
Function GoToHoles()
	
Speed 50
Accel 10, 10
	Integer j
	
	Print "going to the holes I found: ", z
	
	If z = 0 Then
		Print "Didnt Find Any holes"
		GoTo skip
	EndIf
	
	For j = 600 To 600 + z - 1
		Go P(j)
		Wait 2
  	Next j
  	
	Skip:
	
Fend
Function LaserAlarm
	Print "Laser Alarm"
'	SetErrorArrayFlag(LaserAlarmError, True)
'	SystemPause()
Pause
	Trap 3 Sw(laserHi) = True And Sw(laserLo) = True Call LaserAlarm
Fend
Function PreInspection()
	SystemStatus = ScanningPanel
	ScanPanel() ' During ScanPanel the scanner will write PanelArray in the IOTable
	
	SystemStatus = MovingPanel
	Go ScanCenter ' Collision Avoidance Waypoint
Fend


