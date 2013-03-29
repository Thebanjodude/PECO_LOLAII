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
	yOffset = 24.9001
	xOffset = -28.1702

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
	
	GetPanelArray()
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
Function Derivetheta
	
Real error1, theta1, theta2
Integer CoordIndex, i

GetPanelArray()
GetPanelCoords()
PrintCoordArray()
	
For i = 0 To 15
	If PanelCoordinates(CoordIndex, 1) = 0 And PanelCoordinates(CoordIndex, 0) > 0 Then
		theta1 = 0
	ElseIf PanelCoordinates(CoordIndex, 0) = 0 And PanelCoordinates(CoordIndex, 1) > 0 Then
		theta1 = 90
	ElseIf PanelCoordinates(CoordIndex, 1) = 0 And PanelCoordinates(CoordIndex, 0) < 0 Then
		theta1 = 180
	ElseIf PanelCoordinates(CoordIndex, 0) = 0 And PanelCoordinates(CoordIndex, 1) < 0 Then
		theta1 = 270
	ElseIf PanelCoordinates(CoordIndex, 0) > 0 And PanelCoordinates(CoordIndex, 1) > 0 Then ' first quadrant, x and y are positive
 		theta1 = RadToDeg(Atan(PanelCoordinates(CoordIndex, 1) / PanelCoordinates(CoordIndex, 0))) 'atan(y/x)
	ElseIf PanelCoordinates(CoordIndex, 0) < 0 And PanelCoordinates(CoordIndex, 1) > 0 Then ' second quadrant, x is neg, y is pos
		theta1 = 180 + RadToDeg(Atan(PanelCoordinates(CoordIndex, 1) / PanelCoordinates(CoordIndex, 0))) 'atan(y/x)
	ElseIf PanelCoordinates(CoordIndex, 0) < 0 And PanelCoordinates(CoordIndex, 1) < 0 Then ' third quadrant, x and y are negitive
		theta1 = 180 + RadToDeg(Atan(PanelCoordinates(CoordIndex, 1) / PanelCoordinates(CoordIndex, 0))) 'atan(y/x)
	ElseIf PanelCoordinates(CoordIndex, 0) > 0 And PanelCoordinates(CoordIndex, 1) < 0 Then ' fourth quadrant, x is pos y is negitive
		theta1 = 360 + RadToDeg(Atan(PanelCoordinates(CoordIndex, 1) / PanelCoordinates(CoordIndex, 0))) 'atan(y/x)

	EndIf
	
'	Print theta1

	theta2 = PanelArray(CoordIndex, 1)
	CoordIndex = CoordIndex + 1
	error1 = theta1 - theta2
	Print error1

Next i
	
Fend
Function IncrementIndex() ' Increment all the indexes
	PanelArrayIndex = PanelArrayIndex + 1
Fend
Function GetThetaR()
		r = PanelArray(PanelArrayIndex, RadiusColumn) 'Reassign r and theta
		Theta = PanelArray(PanelArrayIndex, ThetaColumn)
Fend
Function GetPanelArray() ' Hardcoded Array for 88554
	
	recMajorDim = 247.142
	recMinorDim = 143.764
	recNumberOfHoles = 16
	
	PanelArray(0, 0) = 223.52
	PanelArray(1, 0) = 211.125
	PanelArray(2, 0) = 174.6
	PanelArray(3, 0) = 137.998
	PanelArray(4, 0) = 121.92
	PanelArray(5, 0) = 137.998
	PanelArray(6, 0) = 174.6
	PanelArray(7, 0) = 211.125
	PanelArray(8, 0) = 223.52
	PanelArray(9, 0) = 211.125
	PanelArray(10, 0) = 174.6
	PanelArray(11, 0) = 137.998
	PanelArray(12, 0) = 121.92
	PanelArray(13, 0) = 137.998
	PanelArray(14, 0) = 174.6
	PanelArray(15, 0) = 211.125
		
	PanelArray(0, 1) = 0
	PanelArray(1, 1) = 18.17728756
	PanelArray(2, 1) = 36.26356586
	PanelArray(3, 1) = 58.93929219
	PanelArray(4, 1) = 90
	PanelArray(5, 1) = 121.0591007
	PanelArray(6, 1) = 143.7426597
	PanelArray(7, 1) = 161.8183864
	PanelArray(8, 1) = 180
	PanelArray(9, 1) = 198.1816136
	PanelArray(10, 1) = 216.2573403
	PanelArray(11, 1) = 238.9408993
	PanelArray(12, 1) = 270
	PanelArray(13, 1) = 301.0591007
	PanelArray(14, 1) = 323.7426597
	PanelArray(15, 1) = 341.8183864

	'Skip flags
	PanelArray(0, 2) = 0
	PanelArray(1, 2) = 0
	PanelArray(2, 2) = 0
	PanelArray(3, 2) = 0
	PanelArray(4, 2) = 0
	PanelArray(5, 2) = 0
	PanelArray(6, 2) = 0
	PanelArray(7, 2) = 0
	PanelArray(8, 2) = 0
	PanelArray(9, 2) = 0
	PanelArray(10, 2) = 0
	PanelArray(11, 2) = 0
	PanelArray(12, 2) = 0
	PanelArray(13, 2) = 0
	PanelArray(14, 2) = 0
	PanelArray(15, 2) = 0

  	PrintPanelArray() ' Print for testing/troubleshooting
  	
 Fend
Function PrintPanelArray()
	
	Integer n, PrintArrayIndex

	For n = 0 To recNumberOfHoles - 1
		Print Str$(PanelArray(PrintArrayIndex, RadiusColumn)) + " " + Str$(PanelArray(PrintArrayIndex, ThetaColumn)) + " " + Str$(PanelArray(PrintArrayIndex, SkipFlagColumn))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset indexes
	
Fend
Function GetPanelCoords()
	
PanelCoordinates(0, 0) = 223.52
PanelCoordinates(1, 0) = 200.584
PanelCoordinates(2, 0) = 140.792
PanelCoordinates(3, 0) = 71.1962
PanelCoordinates(4, 0) = 0
PanelCoordinates(5, 0) = -71.1962
PanelCoordinates(6, 0) = -140.792
PanelCoordinates(7, 0) = -200.584
PanelCoordinates(8, 0) = -223.52
PanelCoordinates(9, 0) = -200.584
PanelCoordinates(10, 0) = -140.792
PanelCoordinates(11, 0) = -71.1962
PanelCoordinates(12, 0) = 0
PanelCoordinates(13, 0) = 71.1962
PanelCoordinates(14, 0) = 140.792
PanelCoordinates(15, 0) = 200.584

PanelCoordinates(0, 1) = 0
PanelCoordinates(1, 1) = 65.8622
PanelCoordinates(2, 1) = 103.276
PanelCoordinates(3, 1) = 118.212
PanelCoordinates(4, 1) = 121.92
PanelCoordinates(5, 1) = 118.212
PanelCoordinates(6, 1) = 103.276
PanelCoordinates(7, 1) = 65.8622
PanelCoordinates(8, 1) = 0
PanelCoordinates(9, 1) = -65.8622
PanelCoordinates(10, 1) = -103.276
PanelCoordinates(11, 1) = -118.212
PanelCoordinates(12, 1) = -121.92
PanelCoordinates(13, 1) = -118.212
PanelCoordinates(14, 1) = -103.276
PanelCoordinates(15, 1) = -65.8622
	
Fend
Function PrintCoordArray()
	
	Integer n, PrintArrayIndex

	For n = 0 To 15
		Print Str$(PanelCoordinates(PrintArrayIndex, 0)) + " " + Str$(PanelCoordinates(PrintArrayIndex, 1))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset indexes
	
Fend
