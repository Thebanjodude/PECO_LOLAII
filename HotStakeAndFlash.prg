#include "Globals.INC"

Function HotStakePanel() As Boolean
	
	Power High
	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap
	
	SystemStatus = InstallingInserts
	Boolean SkippedHole
	Double AnvilOffset, CurrentZ
	
	TeachPoints() ' set new coords for anvil
  	
	PanelArrayIndex = 0 ' Reset Index	
	zLimit = 0 'fake

	PanelArrayIndex = 0
	GetPanelArray()
	DerivethetaR()
	GetThetaR()
	
'	FindPickUpError() 'fake
	
'	Jump LaserToHeatStake LimZ zLimit ' Take a safe path
	Jump PreHotStake CP

	For currentHSHole = 0 To recNumberOfHoles - 1
		
		If currentHSHole <> 0 Then
			IncrementIndex()
			GetThetaR()
		EndIf

		SkippedHole = False 'Reset flag
		
		If PanelArray(PanelArrayIndex, SkipFlagColumn) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 'Set flag
			Print "Skipped Hole"
		EndIf

		If SkippedHole = False Then 'If the flag is set then we have finished all holes		
			        	
			Print r, Theta
			SLock 1, 2, 3, 4
        	P23 = HotStakeCenter -Y(Sin(DegToRad(45)) * PanelArray(PanelArrayIndex, RadiusColumn)) +X(Cos(DegToRad(45)) * PanelArray(PanelArrayIndex, RadiusColumn)) :U(-PanelArray(PanelArrayIndex, ThetaColumn))
'			Jump P23 LimZ zLimit
'			RotatedError(Theta)
'			Print P23
'			P23 = P23 + RotatedOffset
			Jump P23
						
'Comment this out for testing						
' Instead, I could use the same method to get the panel to the outmag...anvil-recpanelthickness
		AnvilOffset = 0
		Do Until Sw(HSPanelPresntH) = True ' Move down until we touchoff on the anvil. 
			SFree 1, 2
			Move P23 -Z(AnvilOffset)
			AnvilOffset = AnvilOffset + .75
'			CurrentZ = CZ(RealPos)
		Loop
		SLock 1, 2
		
		Print "hole number", currentHSHole, "hole diff:", P23 - Here
		
		P23 = Here
		

		AnvilOffset = 0
		
		Move P23 +Z(10)
		Do Until Sw(HSPanelPresntH) = True ' Move down until we touchoff on the anvil. 
			SFree 1, 2
			Move P23 -Z(AnvilOffset)
			AnvilOffset = AnvilOffset + .5
''			CurrentZ = CZ(RealPos)
		Loop
'		Pause
		SLock 1, 2
'			
'		If HSPanelPresntCC = True Then
'			hsInstallInsrtCC = True
'		'	wait ? ' Wait for heatstake machine to receive the signal, time based or event based, im not sure yet

'		Else
'            erPanelStatusUnknown = True
'            stackLightYelCC = True
'            stackLightAlrmCC = True
			HotStakePanel = False ' send the state back to idle
'            Pause
'		EndIf
'			Wait .4 ' Instead of wait, this is where the feedback from the HS Station will be
'			hsInstallInsrtCC = False 'reset flag
		EndIf

	Next
		
'	Jump PreScan LimZ zLimit
	HotStakePanel = True 'fake
	
exitHotStake:

	SystemStatus = MovingPanel
	Trap 2 ' disarm trap
'	Go PreScan 'Go Home
	
Fend
Function FlashRemoval() As Boolean
	
	Trap 2, MemSw(jobAbortH) = True GoTo exitFlash ' arm trap
	SystemStatus = RemovingFlash
	
	suctionWaitTime = 1 'fake
	zLimit = -2 'fake
	
'	Jump Waypoint2 LimZ zLimit
		
	recFlashRequired = True ' fake for testing
	If recFlashRequired = False Then GoTo SkipFlash
	
	Boolean SkippedHole
	Integer t, AnvilOffset
	Double CurrentZ
	
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
			Print "skipped hole"
		Else
			SkippedHole = False
		EndIf

		If SkippedHole = False Then 'If the flag is true then we have finished all holes
 		
			P23 = FlashCenter +Y(Sin(DegToRad(23.795)) * PanelArray(PanelArrayIndex, RadiusColumn)) +X(Cos(DegToRad(23.795)) * PanelArray(PanelArrayIndex, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn) + (23.795 + 135))
			Print P23
			Jump P23 LimZ zLimit ' Limit the jump hight
			
			
'Potential Problem: The switch may engage before the panel is firmly on the anvil. The threaded conical peice on the anvil will solve that problem.			
'comment this out for testing
'		Do Until FlashPnlPrsntCC = True Or CurrentZ >= AnvilZlimit ' Move down until we touchoff on the anvil. Add over torque error.
'			Move P23 -Z(AnvilOffset)
'			AnvilOffset = AnvilOffset + 0.25
'			CurrentZ = CZ(RealPos)
'		Loop		

			If RemoveFlash(flashDwellTime) = True Then
				FlashRemoval = True ' flash removal for the hole executed correctly
			Else
				FlashRemoval = False ' send the state back to idle because there was a problem
				Pause
			EndIf
	EndIf
Next

	SkipFlash:
	exitFlash:
	
	Trap 2 ' disarm trap
	SystemStatus = MovingPanel
	Jump PreScan LimZ zLimit ' Collision Avoidance Waypoint
			
Fend
Function DerivethetaR()
	
Integer i ' index for loop

'GetPanelCoords() ' load up the array with all the corrdinates
	
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
	
	'Does SPEL+ not have a x^2 function?
	PanelArray(PanelArrayIndex, RadiusColumn) = Sqr(PanelCordinates(i, xCoord) * PanelCordinates(i, xCoord) + (PanelCordinates(i, yCoord) * (PanelCordinates(i, yCoord))))
	
	IncrementIndex()

Next i

'	PrintPanelArray()
	PanelArrayIndex = 0
	
Fend
Function IncrementIndex() ' Increment all the indexes
	PanelArrayIndex = PanelArrayIndex + 1
Fend
Function GetThetaR()
		r = PanelArray(PanelArrayIndex, RadiusColumn) 'Reassign r and theta
		Theta = PanelArray(PanelArrayIndex, ThetaColumn)
Fend
Function GetPanelArray() ' Hardcoded Array
	
recNumberOfHoles = 16
	
'88555 and 89294
PanelCordinates(0, 0) = InTomm(8.8)
PanelCordinates(1, 0) = InTomm(7.897)
PanelCordinates(2, 0) = InTomm(5.543)
PanelCordinates(3, 0) = InTomm(2.803)
PanelCordinates(4, 0) = InTomm(0)
PanelCordinates(5, 0) = InTomm(-2.803)
PanelCordinates(6, 0) = InTomm(-5.543)
PanelCordinates(7, 0) = InTomm(-7.897)
PanelCordinates(8, 0) = InTomm(-8.8)
PanelCordinates(9, 0) = InTomm(-7.897)
PanelCordinates(10, 0) = InTomm(-5.543)
PanelCordinates(11, 0) = InTomm(-2.803)
PanelCordinates(12, 0) = InTomm(0)
PanelCordinates(13, 0) = InTomm(2.803)
PanelCordinates(14, 0) = InTomm(5.543)
PanelCordinates(15, 0) = InTomm(7.897)

PanelCordinates(0, 1) = InTomm(0)
PanelCordinates(1, 1) = InTomm(2.593)
PanelCordinates(2, 1) = InTomm(4.066)
PanelCordinates(3, 1) = InTomm(4.654)
PanelCordinates(4, 1) = InTomm(4.800)
PanelCordinates(5, 1) = InTomm(4.654)
PanelCordinates(6, 1) = InTomm(4.066)
PanelCordinates(7, 1) = InTomm(2.593)
PanelCordinates(8, 1) = InTomm(0)
PanelCordinates(9, 1) = InTomm(-2.593)
PanelCordinates(10, 1) = InTomm(-4.066)
PanelCordinates(11, 1) = InTomm(-4.654)
PanelCordinates(12, 1) = InTomm(-4.800)
PanelCordinates(13, 1) = InTomm(-4.654)
PanelCordinates(14, 1) = InTomm(-4.066)
PanelCordinates(15, 1) = InTomm(-2.593)
	
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

'  	PrintPanelArray() ' Print for testing/troubleshooting
  	
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
	
' this will go away during integration
	
'88553
recNumberOfHoles = 16
Redim PanelCordinates(recNumberOfHoles - 1, 1)
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

'PanelCordinates(0, 0) = InTomm(8.6340)
'PanelCordinates(1, 0) = InTomm(7.1780)
'PanelCordinates(2, 0) = InTomm(4.9191)
'PanelCordinates(3, 0) = InTomm(2.4775)
'PanelCordinates(4, 0) = InTomm(0)
'PanelCordinates(5, 0) = InTomm(-2.4775)
'PanelCordinates(6, 0) = InTomm(-4.9191)
'PanelCordinates(7, 0) = InTomm(-7.1780)
'PanelCordinates(8, 0) = InTomm(-8.6340)
'PanelCordinates(9, 0) = InTomm(-8.6340)
'PanelCordinates(10, 0) = InTomm(-7.1780)
'PanelCordinates(11, 0) = InTomm(-4.9191)
'PanelCordinates(12, 0) = InTomm(-2.4775)
'PanelCordinates(13, 0) = InTomm(0)
'PanelCordinates(14, 0) = InTomm(2.4775)
'PanelCordinates(15, 0) = InTomm(4.9191)
'PanelCordinates(16, 0) = InTomm(7.1780)
'PanelCordinates(17, 0) = InTomm(8.6340)
'
'PanelCordinates(0, 1) = InTomm(1.2379)
'PanelCordinates(1, 1) = InTomm(3.2431)
'PanelCordinates(2, 1) = InTomm(4.2593)
'PanelCordinates(3, 1) = InTomm(4.6885)
'PanelCordinates(4, 1) = InTomm(4.8000)
'PanelCordinates(5, 1) = InTomm(4.6885)
'PanelCordinates(6, 1) = InTomm(4.2593)
'PanelCordinates(7, 1) = InTomm(3.2431)
'PanelCordinates(8, 1) = InTomm(1.2379)
'PanelCordinates(9, 1) = InTomm(-1.2379)
'PanelCordinates(10, 1) = InTomm(-3.2431)
'PanelCordinates(11, 1) = InTomm(-4.2593)
'PanelCordinates(12, 1) = InTomm(-4.6885)
'PanelCordinates(13, 1) = InTomm(-4.8000)
'PanelCordinates(14, 1) = InTomm(-4.6885)
'PanelCordinates(15, 1) = InTomm(-4.2593)
'PanelCordinates(16, 1) = InTomm(-3.2431)
'PanelCordinates(17, 1) = InTomm(-1.2379)
'	
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

'88555
PanelCordinates(0, 0) = InTomm(8.8)
PanelCordinates(1, 0) = InTomm(7.897)
PanelCordinates(2, 0) = InTomm(5.543)
PanelCordinates(3, 0) = InTomm(2.803)
PanelCordinates(4, 0) = InTomm(0)
PanelCordinates(5, 0) = InTomm(-2.803)
PanelCordinates(6, 0) = InTomm(-5.543)
PanelCordinates(7, 0) = InTomm(-7.897)
PanelCordinates(8, 0) = InTomm(-8.8)
PanelCordinates(9, 0) = InTomm(-7.897)
PanelCordinates(10, 0) = InTomm(-5.543)
PanelCordinates(11, 0) = InTomm(-2.803)
PanelCordinates(12, 0) = InTomm(0)
PanelCordinates(13, 0) = InTomm(2.803)
PanelCordinates(14, 0) = InTomm(5.543)
PanelCordinates(15, 0) = InTomm(7.897)

PanelCordinates(0, 1) = InTomm(0)
PanelCordinates(1, 1) = InTomm(2.593)
PanelCordinates(2, 1) = InTomm(4.066)
PanelCordinates(3, 1) = InTomm(4.654)
PanelCordinates(4, 1) = InTomm(4.800)
PanelCordinates(5, 1) = InTomm(4.654)
PanelCordinates(6, 1) = InTomm(4.066)
PanelCordinates(7, 1) = InTomm(2.593)
PanelCordinates(8, 1) = InTomm(0)
PanelCordinates(9, 1) = InTomm(-2.593)
PanelCordinates(10, 1) = InTomm(-4.066)
PanelCordinates(11, 1) = InTomm(-4.654)
PanelCordinates(12, 1) = InTomm(-4.800)
PanelCordinates(13, 1) = InTomm(-4.654)
PanelCordinates(14, 1) = InTomm(-4.066)
PanelCordinates(15, 1) = InTomm(-2.593)
	
Fend
Function PrintCoordArray()
	
	Integer n, PrintArrayIndex

	For n = 0 To recNumberOfHoles - 1
		Print Str$(n) + " " + Str$(PanelCordinates(PrintArrayIndex, 0)) + " " + Str$(PanelCordinates(PrintArrayIndex, 1))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset indexes
	
Fend
Function PrintCoordQuillArray()
	
	Integer n, PrintArrayIndex

	For n = 0 To recNumberOfHoles - 1
		Print Str$(n) + " " + Str$(PanelCordinatesQuill(PrintArrayIndex, 0)) + " " + Str$(PanelCordinatesQuill(PrintArrayIndex, 1))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset indexes
	
Fend

Function GetAngle(Slope1 As Real, Slope2 As Real) As Real
	
		If Slope1 * Slope2 = -1 Then
			
			Print "error, divide by zero"
			Pause
			GoTo skiptoend
			
		EndIf
		
		GetAngle = RadToDeg(Atan(Abs((Slope1 - Slope2) / (1 + Slope1 * Slope2))))
		
		If Slope1 = 0 And Slope2 = 0 Then ' Special case
			GetAngle = 180
		EndIf
		
		skiptoend:
		Print GetAngle
Fend
Function FindSlope(pt1 As Integer, pt2 As Integer) As Real
	
'	GetPanelCoords()
	
	If pt1 = pt2 Then 'error check
		Print "pts are the same"
		Pause
		FindSlope = -99999
	ElseIf PanelCordinates(pt2, 0) = PanelCordinates(pt1, 0) Then
		FindSlope = 9999999 'the slope is infinity
	ElseIf PanelCordinates(pt2, 1) = PanelCordinates(pt1, 1) Then
		FindSlope = 0
	Else
	   	FindSlope = (PanelCordinates(pt2, 1) - PanelCordinates(pt1, 1)) /((PanelCordinates(pt2, 0) - PanelCordinates(pt1, 0)))
	EndIf
	
Fend
Function RemoveFlash(DwellTime As Real) As Boolean
	
	drillGoCC = True 'turn on the drill
	
	Wait DwellTime + 2.25 '2.25 is about the time it takes to bottom out.
	
    If flashHomeNO = False Then ' check that the drill actually left the home position
		drillReturnCC = True ' Tell the drill to return
		Wait 2.25 ' wait for drill to go back to the top
		
		If flashHomeNO = True Then
			RemoveFlash = True
		Else
			RemoveFlash = False
		EndIf
		erFlashStation = False
	Else
		RemoveFlash = False
		Print "did not stroke"
		erFlashStation = True
		Pause
	EndIf
	
	Print "RemoveFlash", RemoveFlash
	
Fend

