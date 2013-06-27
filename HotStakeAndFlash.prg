#include "Globals.INC"

Function HotStakePanel(StupidCompiler2 As Byte) As Integer

	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap

	Integer i

	SystemStatus = StateHotStakePanel
	
	Jump PreHotStake LimZ zLimit ' Present panel to hot stake
	
	getRobotPoints()
	For i = FirstHolePointHotStake To LastHolePointHotStake
		
		Jump P(i) ' Go to the next hole

		If hsPanelPresnt = False Then ' A boss should be engaging the anvil but it isnt...
			erPanelStatusUnknown = True
			HotStakePanel = 2
			Exit Function
		EndIf

		' Add Tanda's Heat State Function here, it should tell the HS to install an insert
			
		Pause ' Added for Testing
	Next
	
	Jump PreFlash LimZ zLimit ' Present panel to hot stake
	SystemStatus = StateMoving
	
exitHotStake:

If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
	jobAbort = True
EndIf

Trap 2 ' disarm trap	

Fend
Function FlashPanel(StupidCompiler2 As Byte) As Integer
	'	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap
	
	Integer i
	
	Jump PreFlash LimZ zLimit ' Present panel to flash machine
	
	getRobotPoints()
	For i = FirstHolePointFlash To LastHolePointFlash
		
		Jump P(i)
		' Add in stroke function here		
		Pause
		
	Next

Fend
'	
'	Trap 2, MemSw(jobAbortH) = True GoTo exitFlash ' arm trap
'	SystemStatus = RemovingFlash
'	
'	suctionWaitTime = 1 'fake
'	zLimit = -2 'fake
'	
''	Jump Waypoint2 LimZ zLimit
'		
'	recFlashRequired = True ' fake for testing
'	If recFlashRequired = False Then GoTo SkipFlash
'	
'	Boolean SkippedHole
'	Integer t, AnvilOffset
'	Double CurrentZ
'	
'	PanelArrayIndex = 0 ' Reset index for IncrementArray Function
'	GetPanelArray()
'	GetThetaR() ' Call function that assignes first r and theta
'	
'	For t = 0 To recNumberOfHoles - 1
'			
'		If t <> 0 Then
'			IncrementIndex()
'			GetThetaR()
'		EndIf
'		
'		SkippedHole = False 'Reset flag
'		
'		If PanelArray(PanelArrayIndex, SkipFlagColumn) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
'			SkippedHole = True 'Set flag
'			Print "skipped hole"
'		Else
'			SkippedHole = False
'		EndIf
'
'		If SkippedHole = False Then 'If the flag is true then we have finished all holes
' 		
'			P23 = FlashCenter +Y(Sin(DegToRad(23.795)) * PanelArray(PanelArrayIndex, RadiusColumn)) +X(Cos(DegToRad(23.795)) * PanelArray(PanelArrayIndex, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn) + (23.795 + 135))
'			Print P23
'			Jump P23 LimZ zLimit ' Limit the jump hight
'			
'			
''Potential Problem: The switch may engage before the panel is firmly on the anvil. The threaded conical peice on the anvil will solve that problem.			
''comment this out for testing
''		Do Until FlashPnlPrsntCC = True Or CurrentZ >= AnvilZlimit ' Move down until we touchoff on the anvil. Add over torque error.
''			Move P23 -Z(AnvilOffset)
''			AnvilOffset = AnvilOffset + 0.25
''			CurrentZ = CZ(RealPos)
''		Loop		
'
'			If RemoveFlash(flashDwellTime) = True Then
'				FlashRemoval = True ' flash removal for the hole executed correctly
'			Else
'				FlashRemoval = False ' send the state back to idle because there was a problem
'				Pause
'			EndIf
'	EndIf
'Next
'
'	SkipFlash:
'	exitFlash:
'	
'	Trap 2 ' disarm trap
'	SystemStatus = MovingPanel
'	Jump PreScan LimZ zLimit ' Collision Avoidance Waypoint
'			
'Fend

'Function PrintPanelArray()
'	
'	Integer n, PrintArrayIndex
'
'	For n = 0 To recNumberOfHoles - 1
'		Print Str$(PanelArray(PrintArrayIndex, RadiusColumn)) + " " + Str$(PanelArray(PrintArrayIndex, ThetaColumn)) + " " + Str$(PanelArray(PrintArrayIndex, SkipFlagColumn))
'		PrintArrayIndex = PrintArrayIndex + 1
'	Next
'	
'	PrintArrayIndex = 0 	'Reset indexes
'	
'Fend
Function InTomm(mm As Real) As Real
	'1in=25.4mm	
	InTomm = mm * 25.4
Fend

'Fend
'Function PrintCoordArray()
'	
'	Integer n, PrintArrayIndex
'
'	For n = 0 To recNumberOfHoles - 1
'		Print Str$(n) + " " + Str$(PanelCordinates(PrintArrayIndex, 0)) + " " + Str$(PanelCordinates(PrintArrayIndex, 1))
'		PrintArrayIndex = PrintArrayIndex + 1
'	Next
'	
'	PrintArrayIndex = 0 	'Reset indexes
'	
'Fend


