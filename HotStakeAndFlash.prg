#include "Globals.INC"

Function HotStakePanel() ' Add anvil touchoff feedback code
	
	SystemStatus = InstallingInserts

	Boolean SkippedHole
	Integer k
	Double AnvilOffset, CurrentZ
  	
	PanelArrayIndex = 0 ' Reset Index

	GetPanelArray()
	GetThetaR()

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
		
			P23 = HotStakeCenter -X(PanelArray(PanelArrayIndex, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn))
			Jump P23 LimZ Zlimit
						
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
		
			Wait .1 ' Instead of wait, this is where the feedback from the HS Station will be
		EndIf

	Next
	
	SystemStatus = MovingPanel
	Go ScanCenter ' Collision Avoidance Waypoint
	
Fend
Function FlashRemoval()
	
	SystemStatus = RemovingFlash
	
	recFlashRequired = True ' for testing
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
		EndIf

		If SkippedHole = False Then 'If the flag is true then we have finished all holes
 		
			P23 = FlashCenter +X(PanelArray(PanelArrayIndex, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn) + 180) ' Add 180 because its on the other side of the table
			Jump P23 LimZ Zlimit ' Limit the jump hight
			
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
	Go ScanCenter ' Collision Avoidance Waypoint
		
Fend
Function IncrementIndex() ' Increment all the indexes
	PanelArrayIndex = PanelArrayIndex + 1
Fend
Function GetThetaR()
		r = PanelArray(PanelArrayIndex, 0) 'Reassign r and theta
		Theta = PanelArray(PanelArrayIndex, 1)
Fend
Function GetPanelArray() ' Hardcoded Array for 88554

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

