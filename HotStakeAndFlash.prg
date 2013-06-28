#include "Globals.INC"

Function HotStakePanel(StupidCompiler2 As Byte) As Integer

	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap

	Integer i

	SystemStatus = StateHotStakePanel
	
	Jump PreHotStake LimZ zLimit ' Present panel to hot stake

	For i = FirstHolePointHotStake To LastHolePointHotStake
		
		Jump P(i) ' Go to the next hole

		If hsPanelPresnt = False Then ' A boss should be engaging the anvil but it isnt...
			erPanelStatusUnknown = True
			HotStakePanel = 2
			SystemStatus = StateMoving
			Jump PreHotStake :U(CU(Here)) LimZ zLimit ' Pull back from the hot stake machine
			Exit Function ' exit with error
		EndIf

		' Add Tanda's Heat State Function here, it should tell the HS to install an insert
			
		Pause ' Added for Testing
	Next
		
exitHotStake:

	SystemStatus = StateMoving
	Jump PreHotStake :U(CU(Here)) LimZ zLimit ' Pull back from the hot stake machine
	
	If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
		jobAbort = True
	EndIf

Trap 2 ' disarm trap	

Fend
Function FlashPanel(DwellTime As Real) As Integer
	Trap 2, MemSw(jobAbortH) = True GoTo exitFlash ' arm trap
	
	Integer i
	
	SystemStatus = StateFlashRemoval
	
	Jump PreFlash LimZ zLimit ' Present panel to flash machine
	
	For i = FirstHolePointFlash To LastHolePointFlash
		
		Jump P(i)
		
		If flashPanelPresnt = False Then ' A boss should be engaging the anvil but it isnt...
			erPanelStatusUnknown = True
			FlashPanel = 2 ' exit with error
			SystemStatus = StateMoving
			Jump PreFlash :U(CU(Here)) LimZ zLimit ' Back out of the flash station
			Exit Function
		EndIf
		
		drillGoCC = True 'Begin stroking the drill
	
		Wait DwellTime + 2.25 '2.25 is about the time it takes to bottom out.
	
	    If flashHomeNO = False Then ' Check that the drill actually left the home position
			
			drillReturnCC = True ' Tell the drill to return
			Wait 2.25 ' wait for drill to go back to the top
	
			If flashHomeNO = True Then
				FlashPanel = 0 ' The drill returned to its home position
			Else
				FlashPanel = 2 ' The drill is stuck
				erFlashStation = True
				Exit For ' exit with error
			EndIf
			erFlashStation = False
			
		Else
			FlashPanel = 2 ' the drill never left
			erFlashStation = True
			Exit For  ' exit with error
		EndIf
		
		Pause ' added in for testing
		
	Next
	
exitFlash:

	SystemStatus = StateMoving
	Jump PreFlash :U(CU(Here)) LimZ zLimit ' go home
	
	If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
		jobAbort = True ' Set flag
	EndIf

	Trap 2 ' disarm trap
Fend
Function InTomm(mm As Real) As Real
	InTomm = mm * 25.4
Fend


