#include "Globals.INC"

Function HotStakePanel()
	
'	FindPickUpError()
	
	SystemStatus = InstallingInserts

	Boolean SkippedHole
	Integer k
	Double AnvilOffset, CurrentZ
  	
	PanelArrayIndex = 0 ' Reset Index

	GetPanelArray()
	GetThetaR()
	zLimit = -135

	For k = 0 To recNumberOfHoles - 1
		
		If k <> 0 Then
			IncrementIndex()
			GetThetaR()
		EndIf

		SkippedHole = False 'Reset flag
		
		If PanelArray(PanelArrayIndex, SkipFlagColumn) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 'Set flag
		EndIf

		If SkippedHole = False Then 'If the flag is set then we have finished all holes
		
            P23 = HotStakeCenter2 -Y(Sin(45) * PanelArray(PanelArrayIndex, RadiusColumn)) +X(Cos(45) * PanelArray(PanelArrayIndex, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn) + 135)
			Print P23
			Jump P23 LimZ zLimit
						
'Comment this out for testing						
'			Do Until Sw(HSPanelPresntH) = True Or CurrentZ >= AnvilZlimit ' Move down until we touchoff on the anvil. 
'				Move P23 -Z(AnvilOffset)
'				AnvilOffset = AnvilOffset + 0.25
'				CurrentZ = CZ(RealPos)
'			Loop
'				
'			If Sw(HSPanelPresntH) = True Then
'				hsInstallInsrt = True
'			'	wait ? ' Wait for heatstake machine to receive the signal, time based or event based, im not sure yet
'				hsInstallInsrt = False
'			Else
'                erPanelStatusUnknown = True
'                SystemPause()
'			EndIf
		
			Wait .4 ' Instead of wait, this is where the feedback from the HS Station will be
		EndIf

	Next
	
	SystemStatus = MovingPanel
'	Go ScanCenter ' Collision Avoidance Waypoint
	
Fend
Function FlashRemoval()
	
'	FindPickUpError()
	
'gross pickup
'	yOffset = 24.9001
'	xOffset = -28.1702

'std pick up
'yOffset = 1.1698
'xOffset = -0.480103

'	thetaOffset = RadToDeg(Atan(yOffset / xOffset))
'	Print "thetaOffset", thetaOffset
	
	SystemStatus = RemovingFlash
	
	recFlashRequired = True ' for testing
	If recFlashRequired = False Then GoTo SkipFlash
	
	Boolean SkippedHole
	Integer t, AnvilOffset
	Double CurrentZ
	
	zLimit = -135
	PanelArrayIndex = 0 ' Reset index for IncrementArray Function
	
'	GetPanelArray()
	GetThetaR() ' Call function that assignes first r and theta
	
	For t = 0 To recNumberOfHoles - 1
		
		If t <> 0 Then
			IncrementIndex()
			GetThetaR()
		EndIf
				
		SkippedHole = False 'Reset flag
		
		If PanelArray(PanelArrayIndex, SkipFlagColumn) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 'Set flag
		EndIf

		If SkippedHole = False Then 'If the flag is true then we have finished all holes
 		
			P23 = FlashCenter2 +X(PanelArray(PanelArrayIndex, RadiusColumn) - xOffset) +Y(yOffset) :U(PanelArray(PanelArrayIndex, ThetaColumn) + thetaOffset)
'			Print CU(P23)
			Jump P23 LimZ zLimit ' Limit the jump hight
			
'comment this out for testing
'			Do Until FlashPnlPrsnt = True Or CurrentZ >= AnvilZlimit ' Move down until we touchoff on the anvil. Add over torque error.
'				Move P23 -Z(AnvilOffset)
'				AnvilOffset = AnvilOffset + 0.25
'				CurrentZ = CZ(RealPos)
'			Loop
'			
'			If FlashPnlPrsnt = True Then
'				flashMtr = True
'				flashCyc = True
'				Wait .1 ' Instead of wait, this is where the feedback(gating) from the FR Station will be
'				flashMtr = False
'				flashCyc = False
'			Else
'			erPanelStatusUnknown = True
'				SystemPause()
'			EndIf
		EndIf
		
	Next
	
	SkipFlash:
	
	SystemStatus = MovingPanel
'	Go ScanCenter ' Collision Avoidance Waypoint
		
Fend
Function DerivethetaR()
	
'Do I need to sort the rows?
	
Real error1, theta1, theta2
Integer CoordIndex, i

'GetPanelArray()
GetPanelCoords() ' load up the array with all the corrdinates
'PrintCoordArray()
	
For i = 0 To recNumberOfHoles - 1

	If PanelCordinates(i, 1) = 0 And PanelCordinates(i, 0) > 0 Then
		PanelArray(PanelArrayIndex, ThetaColumn) = 0
	ElseIf PanelCordinates(i, 0) = 0 And PanelCordinates(i, 1) > 0 Then
		PanelArray(PanelArrayIndex, ThetaColumn) = 90
	ElseIf PanelCordinates(i, 1) = 0 And PanelCordinates(i, 0) < 0 Then
		PanelArray(PanelArrayIndex, ThetaColumn) = 180
	ElseIf PanelCordinates(i, 0) = 0 And PanelCordinates(i, 1) < 0 Then
		PanelArray(PanelArrayIndex, ThetaColumn) = 270
	ElseIf PanelCordinates(i, 0) > 0 And PanelCordinates(i, 1) > 0 Then ' first quadrant, x and y are positive
 		PanelArray(PanelArrayIndex, ThetaColumn) = RadToDeg(Atan(PanelCordinates(i, 1) / PanelCordinates(i, 0))) 'atan(y/x)
	ElseIf PanelCordinates(i, 0) < 0 And PanelCordinates(i, 1) > 0 Then ' second quadrant, x is neg, y is pos
		PanelArray(PanelArrayIndex, ThetaColumn) = 180 + RadToDeg(Atan(PanelCordinates(i, 1) / PanelCordinates(i, 0))) 'atan(y/x)
	ElseIf PanelCordinates(i, 0) < 0 And PanelCordinates(i, 1) < 0 Then ' third quadrant, x and y are negitive
		PanelArray(PanelArrayIndex, ThetaColumn) = 180 + RadToDeg(Atan(PanelCordinates(i, 1) / PanelCordinates(i, 0))) 'atan(y/x)
	ElseIf PanelCordinates(i, 0) > 0 And PanelCordinates(i, 1) < 0 Then ' fourth quadrant, x is pos y is negitive
		PanelArray(PanelArrayIndex, ThetaColumn) = 360 + RadToDeg(Atan(PanelCordinates(i, 1) / PanelCordinates(i, 0))) 'atan(y/x)
	EndIf
	
	PanelArray(PanelArrayIndex, RadiusColumn) = Sqr(PanelCordinates(i, xCoord) * PanelCordinates(i, xCoord) + (PanelCordinates(i, yCoord) * (PanelCordinates(i, yCoord))))
	
	IncrementIndex()

Next i
	PrintPanelArray()
	PanelArrayIndex = 0
'	Print theta1
'
'	theta2 = PanelArray(CoordIndex, 1)
'	CoordIndex = CoordIndex + 1
'	error1 = theta1 - theta2
'	Print error1
	
Fend
Function IncrementIndex() ' Increment all the indexes
	PanelArrayIndex = PanelArrayIndex + 1
Fend
Function GetThetaR()
		r = PanelArray(PanelArrayIndex, RadiusColumn) 'Reassign r and theta
		Theta = PanelArray(PanelArrayIndex, ThetaColumn)
Fend
Function GetPanelArray() ' Hardcoded Array for 88554
	
'	recMajorDim = 247.142
'	recMinorDim = 143.764
'	recNumberOfHoles = 16
'	
'	PanelArray(0, 0) = 223.52
'	PanelArray(1, 0) = 211.125
'	PanelArray(2, 0) = 174.6
'	PanelArray(3, 0) = 137.998
'	PanelArray(4, 0) = 121.92
'	PanelArray(5, 0) = 137.998
'	PanelArray(6, 0) = 174.6
'	PanelArray(7, 0) = 211.125
'	PanelArray(8, 0) = 223.52
'	PanelArray(9, 0) = 211.125
'	PanelArray(10, 0) = 174.6
'	PanelArray(11, 0) = 137.998
'	PanelArray(12, 0) = 121.92
'	PanelArray(13, 0) = 137.998
'	PanelArray(14, 0) = 174.6
'	PanelArray(15, 0) = 211.125
'		
'	PanelArray(0, 1) = 0
'	PanelArray(1, 1) = 18.17728756
'	PanelArray(2, 1) = 36.26356586
'	PanelArray(3, 1) = 58.93929219
'	PanelArray(4, 1) = 90
'	PanelArray(5, 1) = 121.0591007
'	PanelArray(6, 1) = 143.7426597
'	PanelArray(7, 1) = 161.8183864
'	PanelArray(8, 1) = 180
'	PanelArray(9, 1) = 198.1816136
'	PanelArray(10, 1) = 216.2573403
'	PanelArray(11, 1) = 238.9408993
'	PanelArray(12, 1) = 270
'	PanelArray(13, 1) = 301.0591007
'	PanelArray(14, 1) = 323.7426597
'	PanelArray(15, 1) = 341.8183864
'
'	'Skip flags
'	PanelArray(0, 2) = 0
'	PanelArray(1, 2) = 0
'	PanelArray(2, 2) = 0
'	PanelArray(3, 2) = 0
'	PanelArray(4, 2) = 0
'	PanelArray(5, 2) = 0
'	PanelArray(6, 2) = 0
'	PanelArray(7, 2) = 0
'	PanelArray(8, 2) = 0
'	PanelArray(9, 2) = 0
'	PanelArray(10, 2) = 0
'	PanelArray(11, 2) = 0
'	PanelArray(12, 2) = 0
'	PanelArray(13, 2) = 0
'	PanelArray(14, 2) = 0
'	PanelArray(15, 2) = 0
'
'  	PrintPanelArray() ' Print for testing/troubleshooting
'  	
 Fend
Function PrintPanelArray()
	
	Integer n, PrintArrayIndex

	For n = 0 To recNumberOfHoles - 1
		Print Str$(PanelArray(PrintArrayIndex, RadiusColumn)) + " " + Str$(PanelArray(PrintArrayIndex, ThetaColumn)) + " " + Str$(PanelArray(PrintArrayIndex, SkipFlagColumn))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset indexes
	
Fend
Function InTomm(mm As Real) As Real
	'1in=25.4mm	
	InTomm = mm * 25.4
Fend
Function GetPanelCoords()
	
'88553
recNumberOfHoles = 18
Redim PanelCordinates(recNumberOfHoles - 1, 2)
'in inches
'PanelCordinates(0, 0) = 8.6340
'PanelCordinates(1, 0) = 7.1780
'PanelCordinates(2, 0) = 4.9191
'PanelCordinates(3, 0) = 2.4775
'PanelCordinates(4, 0) = 0
'PanelCordinates(5, 0) = -2.4775
'PanelCordinates(6, 0) = -4.9191
'PanelCordinates(7, 0) = -7.1780
'PanelCordinates(8, 0) = -8.6340
'PanelCordinates(9, 0) = -8.6340
'PanelCordinates(10, 0) = -7.1780
'PanelCordinates(11, 0) = -4.9191
'PanelCordinates(12, 0) = -2.4775
'PanelCordinates(13, 0) = 0
'PanelCordinates(14, 0) = 2.4775
'PanelCordinates(15, 0) = 4.9191
'PanelCordinates(16, 0) = 7.1780
'PanelCordinates(17, 0) = 8.6340
'
'PanelCordinates(0, 1) = 1.2379
'PanelCordinates(1, 1) = 3.2431
'PanelCordinates(2, 1) = 4.2593
'PanelCordinates(3, 1) = 4.6885
'PanelCordinates(4, 1) = 4.8000
'PanelCordinates(5, 1) = 4.6885
'PanelCordinates(6, 1) = 4.2593
'PanelCordinates(7, 1) = 3.2431
'PanelCordinates(8, 1) = 1.2379
'PanelCordinates(9, 1) = -1.2379
'PanelCordinates(10, 1) = -3.2431
'PanelCordinates(11, 1) = -4.2593
'PanelCordinates(12, 1) = -4.6885
'PanelCordinates(13, 1) = -4.8000
'PanelCordinates(14, 1) = -4.6885
'PanelCordinates(15, 1) = -4.2593
'PanelCordinates(16, 1) = -3.2431
'PanelCordinates(17, 1) = -1.2379

PanelCordinates(0, 0) = InTomm(8.6340)
PanelCordinates(1, 0) = InTomm(7.1780)
PanelCordinates(2, 0) = InTomm(4.9191)
PanelCordinates(3, 0) = InTomm(2.4775)
PanelCordinates(4, 0) = InTomm(0)
PanelCordinates(5, 0) = InTomm(-2.4775)
PanelCordinates(6, 0) = InTomm(-4.9191)
PanelCordinates(7, 0) = InTomm(-7.1780)
PanelCordinates(8, 0) = InTomm(-8.6340)
PanelCordinates(9, 0) = InTomm(-8.6340)
PanelCordinates(10, 0) = InTomm(-7.1780)
PanelCordinates(11, 0) = InTomm(-4.9191)
PanelCordinates(12, 0) = InTomm(-2.4775)
PanelCordinates(13, 0) = InTomm(0)
PanelCordinates(14, 0) = InTomm(2.4775)
PanelCordinates(15, 0) = InTomm(4.9191)
PanelCordinates(16, 0) = InTomm(7.1780)
PanelCordinates(17, 0) = InTomm(8.6340)

PanelCordinates(0, 1) = InTomm(1.2379)
PanelCordinates(1, 1) = InTomm(3.2431)
PanelCordinates(2, 1) = InTomm(4.2593)
PanelCordinates(3, 1) = InTomm(4.6885)
PanelCordinates(4, 1) = InTomm(4.8000)
PanelCordinates(5, 1) = InTomm(4.6885)
PanelCordinates(6, 1) = InTomm(4.2593)
PanelCordinates(7, 1) = InTomm(3.2431)
PanelCordinates(8, 1) = InTomm(1.2379)
PanelCordinates(9, 1) = InTomm(-1.2379)
PanelCordinates(10, 1) = InTomm(-3.2431)
PanelCordinates(11, 1) = InTomm(-4.2593)
PanelCordinates(12, 1) = InTomm(-4.6885)
PanelCordinates(13, 1) = InTomm(-4.8000)
PanelCordinates(14, 1) = InTomm(-4.6885)
PanelCordinates(15, 1) = InTomm(-4.2593)
PanelCordinates(16, 1) = InTomm(-3.2431)
PanelCordinates(17, 1) = InTomm(-1.2379)
	
'88554	
'PanelCordinates(0, 0) = 223.52
'PanelCordinates(1, 0) = 200.584
'PanelCordinates(2, 0) = 140.792
'PanelCordinates(3, 0) = 71.1962
'PanelCordinates(4, 0) = 0
'PanelCordinates(5, 0) = -71.1962
'PanelCordinates(6, 0) = -140.792
'PanelCordinates(7, 0) = -200.584
'PanelCordinates(8, 0) = -223.52
'PanelCordinates(9, 0) = -200.584
'PanelCordinates(10, 0) = -140.792
'PanelCordinates(11, 0) = -71.1962
'PanelCordinates(12, 0) = 0
'PanelCordinates(13, 0) = 71.1962
'PanelCordinates(14, 0) = 140.792
'PanelCordinates(15, 0) = 200.584
'
'PanelCordinates(0, 1) = 0
'PanelCordinates(1, 1) = 65.8622
'PanelCordinates(2, 1) = 103.276
'PanelCordinates(3, 1) = 118.212
'PanelCordinates(4, 1) = 121.92
'PanelCordinates(5, 1) = 118.212
'PanelCordinates(6, 1) = 103.276
'PanelCordinates(7, 1) = 65.8622
'PanelCordinates(8, 1) = 0
'PanelCordinates(9, 1) = -65.8622
'PanelCordinates(10, 1) = -103.276
'PanelCordinates(11, 1) = -118.212
'PanelCordinates(12, 1) = -121.92
'PanelCordinates(13, 1) = -118.212
'PanelCordinates(14, 1) = -103.276
'PanelCordinates(15, 1) = -65.8622
	
Fend
Function PrintCoordArray()
	
	Integer n, PrintArrayIndex

	For n = 0 To recNumberOfHoles - 1
		Print Str$(n) + " " + Str$(PanelCordinates(PrintArrayIndex, 0)) + " " + Str$(PanelCordinates(PrintArrayIndex, 1))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset indexes
	
Fend
Function FindSlope(pt1 As Integer, pt2 As Integer) As Real
	
	GetPanelCoords()
		Print "pt1:", pt1
		Print "pt2:", pt2
		
	If pt1 = -99 Then ' Find slope of a point from the origin
		Print "x2:", PanelCordinates(pt2, 0)
		Print "y2:", PanelCordinates(pt2, 1)
		
			If PanelCordinates(pt2, 0) = 0 Then
				FindSlope = 9999999
			Else
				FindSlope = PanelCordinates(pt2, 1) / PanelCordinates(pt2, 0)
			EndIf
		
	ElseIf pt1 = pt2 Then
		Print "pts are the same"
		FindSlope = 0
	ElseIf PanelCordinates(pt2, 0) = PanelCordinates(pt1, 0) Then
		FindSlope = 9999999 'the slope is infinity
	Else
		Print "x1:", PanelCordinates(pt1, 0)
		Print "y1:", PanelCordinates(pt1, 1)
		Print "x2:", PanelCordinates(pt2, 0)
		Print "y2:", PanelCordinates(pt2, 1)
	   	FindSlope = (PanelCordinates(pt2, 1) - PanelCordinates(pt1, 1)) /(PanelCordinates(pt2, 0) - PanelCordinates(pt1, 0))
	EndIf
	
Fend
Function test

	Real beta, mu, theta5, theta6, theta4, theta9, m0, m1, m2, thetaguess, r1, phi
	Integer hole, i
	recNumberOfHoles = 18
	
	DerivethetaR()
	
	PrintCoordArray()
	
	hole = 0
	
For i = 0 To 17
	
	Print "hole #", hole
	
	If hole = 0 Then ' Find the slopes of the lines that connect the holes
'		m0 = FindSlope(-99, hole) 'from the origin to the hole
		m1 = FindSlope(recNumberOfHoles - 1, hole) 'the last hole to the hole
		m2 = FindSlope(hole, hole + 1) 'from the hole to the next hole
	ElseIf hole = recNumberOfHoles - 1 Then
'		m0 = FindSlope(-99, hole) 'from the origin to the hole
		m1 = FindSlope(hole - 1, hole) 'from the hole before to the hole
		m2 = FindSlope(hole, 0) ' from the last hole to the first hole
	Else
'		m0 = FindSlope(-99, hole) 'from the origin to the hole
		m1 = FindSlope(hole - 1, hole) 'from the hole before to the hole
		m2 = FindSlope(hole, hole + 1) 'from the hole to the next hole
	EndIf
	
'	Print "m0:", m0
	Print "m1:", m1
	Print "m2:", m2
	
	Theta = PanelArray(hole, ThetaColumn) 'get theta and r
	r1 = PanelArray(hole, RadiusColumn)
	Print "Theta", Theta
	
	Print "beta Unchanged", GetAngle(m1, m2)
	
	Print 0 < Theta And Theta < 180
	 
	If (90 < Theta And Theta < 180) Or (Theta = 90) Or (Theta = 270) Then
		beta = GetAngle(m1, m2) + 180 ' add 180 because its obtuse
	ElseIf (270 < Theta Or Theta < 360) Or (0 < Theta Or Theta < 90) Or (180 < Theta And Theta < 270) Then
		beta = GetAngle(m1, m2) + 90 'changed from 90
	Else
		Print " error"
		Pause
	EndIf

'	If 90 < Theta < 180 Then
'		beta = GetAngle(m1, m2) + 180 'changed from 0
'	ElseIf Theta = 90 Or Theta = 270 Then
'		beta = GetAngle(m1, m2) + 180 ' add 180 because its obtuse
'	ElseIf 270 < Theta < 360 Then
'		beta = GetAngle(m1, m2) + 90 'changed from 90
'	Else  0 < Theta < 90 Then
'		beta = GetAngle(m1, m2) + 90
'	EndIf
		Print "Theta", Theta
		mu = (180 - beta) / 2
	
	If 0 < Theta > 90 Or 270 < Theta > 360 Then
		' If we are in the first or fourth quadrant then we need to move +x
		phi = 90 - mu - Theta
		P23 = scancenter5 -Y(r1 * Cos(DegToRad(mu))) :U(phi) -X(r1 * Sin(DegToRad(mu)))
	ElseIf 90 < Theta > 180 Then
		phi = 90 + mu - Theta
		P23 = scancenter5 -Y(r1 * Cos(DegToRad(mu))) :U(phi) +X(r1 * Sin(DegToRad(mu)))
	Else
		phi = 90 + mu - Theta
		P23 = scancenter5 -Y(r1 * Cos(DegToRad(mu))) :U(phi) +X(r1 * Sin(DegToRad(mu)))
	EndIf
	
	Print "beta=", beta
	Print "mu=", mu
	Print "Phi=", phi
	
	Print P23
	Wait 1
	Move P23 ROT CP
	hole = hole + 1
Next i

Fend
Function GetAngle(Slope1 As Real, Slope2 As Real) As Real
		
		GetAngle = RadToDeg(Atan(Abs((Slope1 - Slope2) / (1 + Slope1 * Slope2))))
Fend

