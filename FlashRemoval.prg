#include "Globals.INC"

Function FlashPanel(DwellTime As Real) As Integer
	SystemStatus = StateFlashRemoval
	
	Integer i
	currentFlashHole = 1
	
	If Not HomeCheck Then findHome
	Move PreHotStake CP
	Move PreFlash

	'On debrisMtrH 'Turn on Vacuum
	debrisMtrCC = True
	
	For i = 1 To recNumberOfHoles
		
    Jump P(i) 'LimZ zLimit
		
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

		currentFlashHole = currentFlashHole + 1
		
	Next
	
	
'	Off debrisMtrH 'Turn off Vacuum
	debrisMtrCC = False
	SystemStatus = StateMoving
	
	findHome

	Trap 2 ' disarm trap
Fend


