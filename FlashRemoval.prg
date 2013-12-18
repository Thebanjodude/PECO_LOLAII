#include "Globals.INC"

Function FlashPanel(DwellTime As Real) As Integer
	Trap 2, MemSw(jobAbortH) = True GoTo exitFlash ' arm trap
	SystemStatus = StateFlashRemoval
	
	Integer i
	currentFlashHole = 1
	
	Jump preScan LimZ zLimit ' make sure we are in the right position before we jump to flash station
	Jump PreHotStake LimZ zLimit ' waypoint so we don't hit anything	
	Jump PreFlash LimZ zLimit ' Present panel to flash machine
	'On debrisMtrH 'Turn on Vacuum
	debrisMtrCC = True
	
	For i = recFirstHolePointFlash To recLastHolePointFlash
		
		Jump P(i) LimZ zLimit
		
'		If flashPanelPresnt = False Then ' A boss should be engaging the anvil but it isnt...
'			erPanelStatusUnknown = True
'			FlashPanel = 2 ' exit with error
'			SystemStatus = StateMoving
'			Jump PreFlash :U(CU(Here)) LimZ zLimit ' Back out of the flash station
'			Exit Function
'		EndIf
'		
'		drillGoCC = True 'Begin stroking the drill (requires a toggle)
'		drillGoCC = False

		On DrillGoH, 1 'Stroke Tool
		
		Wait DwellTime + 2.25 '2.25 is the time it takes to bottom out.
	
	    If flashHomeNO = True Then ' Check that the drill actually left the home position

			On (DrillReturnH), 1, 0 'fake
'			drillReturnCC = True ' Tell the drill to return (toggle)
'			drillReturnCC = False
			Wait 2.25 ' wait for drill to go back to the top
				
			If flashHomeNO = False Then
				FlashPanel = 0 ' The drill returned to its home position
			Else
				FlashPanel = 2 ' The drill is stuck
				erFlashStation = True
				Print "Never got back home"
				Pause
				Exit For ' exit with error
			EndIf
			erFlashStation = False
			
		Else
			FlashPanel = 2 ' the drill never left
			erFlashStation = True
			Print "Never left home"
			Pause
			Exit For  ' exit with error
		EndIf
		
		Wait 1
'		Pause ' added in for testing

		currentFlashHole = currentFlashHole + 1
		
	Next
	
exitFlash:

	If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
		jobAbort = True ' Set flag
		Off (DrillGoH)
		Wait .1
		On (DrillReturnH)
		Do Until flashHomeNO = False ' wait for drill to get home before we move
			Wait .1
		Loop
		Off (DrillReturnH)
		MemOff (jobAbortH) 'reset bit
	EndIf
	
'	Off debrisMtrH 'Turn off Vacuum
	debrisMtrCC = False
	SystemStatus = StateMoving
	
	Jump PreFlash :U(CU(Here)) LimZ zLimit ' going home
	Jump PreHotStake LimZ zLimit ' waypoint
	Jump prescan LimZ zLimit ' go home

	Trap 2 ' disarm trap
Fend


