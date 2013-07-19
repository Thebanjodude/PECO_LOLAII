#include "Globals.INC"

Function HotStakePanel(StupidCompiler2 As Byte) As Integer

	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap
	SystemStatus = StateHotStakePanel
	
	Integer i, Counter
	Real RobotZOnAnvil
	Boolean SkippedHole
	currentHSHole = 1 ' Start at 1 (we are skipping the 0 index in the array)
	HotStakePanel = 2 ' default to fail	
	recHeatStakeOffset = .050 ' positive is deeper
	
	ZLasertoHeatStake = 291.42372 ' This is a calibrated value, it will be stored in the HMI	
	
	Jump PreHotStake LimZ zLimit ' Present panel to hot stake

	Do Until pasMessageDB = 3
		On heatStakeGoH, 1 ' Tell HS to go to soft home position
		Wait 1.25
	Loop

	For i = FirstHolePointHotStake To LastHolePointHotStake

		SkippedHole = False 'Reset flag		
		If SkipHoleArray(currentHSHole, 0) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 'Set flag
			Print "Skipped Hole"
		EndIf

		If SkippedHole = False Then 'If the flag is set then skip the hole
		
			Jump P(i) +Z(10) LimZ zLimit  ' Go to the next hole        
			SFree 1, 2 ' free X and Y

			Counter = 0 ' reset counter
			Do While Sw(HSPanelPresntH) = False Or Counter > 30 ' Approach the panel slowly until we hit the anvil switch
				JTran 3, -.25 ' Move only the z-axis downward in .25mm increments
				Counter = Counter + 1
			Loop
			
			Print "Counter:", Counter
			
			If Counter > 30 Then ' A boss should be engaging the anvil but it isnt...
				erPanelStatusUnknown = True
				HotStakePanel = 2 ' fail
				Print "Boss did not engage the anvil"
				GoTo exitHotStake
			EndIf

			RobotZOnAnvil = CZ(Here) ' Get z coord when boss is on anvil
'			Print "RobotZOnAnvil", RobotZOnAnvil
'			Print "RobotZOnAnvil - ZSpotfacetoQuillOffset", RobotZOnAnvil - ZSpotfacetoQuillOffset

            HSProbeFinalPosition = (ZLasertoHeatStake - (RobotZOnAnvil - PreInspectionArray(currentHSHole, 0)) + InTomm(recInsertDepth) + InTomm(recHeatStakeOffset)) /25.4
            Print "heat stake Position:", HSProbeFinalPosition
            
            If HSProbeFinalPosition > 12.8 Then
				erUnknown = True ' replace this with a real error
            	Pause
                HotStakePanel = 2 ' default to fail		
            	Exit Function
            EndIf
            
            MBWrite(pasInsertDepthAddr, inches2Modbus(HSProbeFinalPosition), MBType32) ' Send final weld depth
 			MBWrite(pasInsertEngageAddr, inches2Modbus(HSProbeFinalPosition - .65), MBType32) ' Set engagement point
			
			' give modbus a chance to update the value from 3 to something else
			Do Until pasMessageDB = 4
				On heatStakeGoH, 1 ' Tell the HS to install 1 insert
				Wait .5
			Loop
			
			ZmaxTorque = 0
			PTCLR (3)
	
			Do Until pasMessageDB = 3 ' monitor the torque when hs is installing insert
				ZmaxTorque = PTRQ(3)
				If ZmaxTorque > .3 Then
					erUnknown = True ' replace this with a real error
					Print "Over torque: HS vs Robot"
					Pause
				EndIf
			Loop

			'Pause ' for testing
		
		EndIf
		
			currentHSHole = currentHSHole + 1
			SLock 1, 2, 3, 4 ' unlock all the joints so we can move again
	Next
		
exitHotStake:

	Do Until pasMessageDB = 2 ' wait for the HS to get home before we move (this wastes a lot of time)
		MBWrite(pasGoHomeAddr, 1, MBTypeCoil) ' Home the heat stake machine by toggling
		Wait 1
		MBWrite(pasGoHomeAddr, 0, MBTypeCoil)
		
		' while the heat stake is homing the messageDB is 9
		' so lets give it a chance to go home before we throw it into
		'   a loop of homing where we will not see the messageDB == 2
		Do While pasMessageDB = 9
			'waiting for the heat stake to finish homeing
			Wait .5
		Loop
	Loop

	SystemStatus = StateMoving
	Jump PreHotStake :U(CU(Here)) LimZ zLimit ' Pull back from the hot stake machine
	
	If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
		jobAbort = True
	EndIf
		
Trap 2 ' disarm trap	

Fend
Function FlashPanel(DwellTime As Real) As Integer
	Trap 2, MemSw(jobAbortH) = True GoTo exitFlash ' arm trap
	SystemStatus = StateFlashRemoval
	
	Integer i
	currentFlashHole = 1
	
	Jump PreFlash LimZ zLimit ' Present panel to flash machine
	
	For i = FirstHolePointFlash To LastHolePointFlash
		
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
		On DrillGoH, 1 'fake
		On debrisMtrH
		
		Wait DwellTime + 2.25 '2.25 is the time it takes to bottom out.
	
	    If flashHomeNO = True Then ' Check that the drill actually left the home position

			On (DrillReturnH), 1, 0 'fake
'			drillReturnCC = True ' Tell the drill to return (toggle)
'			drillReturnCC = False
			Wait 2.25 ' wait for drill to go back to the top
			
			Off debrisMtrH
			
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
			Off debrisMtrH
			Pause
			Exit For  ' exit with error
		EndIf
		
		Wait 1
'		Pause ' added in for testing

		currentFlashHole = currentFlashHole + 1
		
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


