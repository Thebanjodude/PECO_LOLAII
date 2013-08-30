#include "Globals.INC"

Function HotStakePanel(StupidCompiler2 As Byte) As Integer

	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap
	' While the HS is in state 4, installing an insert, I revoke the ability to abort.
	SystemStatus = StateHotStakePanel
	
	Integer i, Counter
	Real RobotZOnAnvil, ProbeToEarsOffset, ClearPanelLip
	Boolean SkippedHole
	currentHSHole = 1 ' Start at 1 (we are skipping the 0 index in the array)
	HotStakePanel = 2 ' default to fail	
	
	ClearPanelLip = 7 'mm
	ProbeToEarsOffset = 11.2222 ' inches
	
	Jump PreHotStake -Z(15) LimZ zLimit ' Present panel to hot stake
	
	Off panelEarLockH ' make sure the valve is off so there is room to put the panel between the cylinder and the ears
	
' fake for testing		
'	Do Until pasMessageDB = 3
'		On heatStakeGoH, 1 ' Tell HS to go to soft home position
'		Wait 1.25
'	Loop

	For i = recFirstHolePointHotStake To recLastHolePointHotStake

		SkippedHole = False 'Reset flag		
		If SkipHoleArray(currentHSHole, 0) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 'Set flag
			Print "Skipped Hole"
		EndIf
		
		If currentHSHole = 3 Or currentHSHole = 5 Or currentHSHole = 11 Or currentHSHole = 12 Then ' The keys are in the way of fixed ears so skip 'em
			SkippedHole = True 'Set flag
			Print "Skipped Hole"
		EndIf

		If SkippedHole = False Then 'If the flag is set then skip the hole

			Go PreHotStake :U(CU(P(i))) :Z(CZ(P(i)) - ClearPanelLip) ' rotate to the correct theta position				
			SpeedS 1000 ' slow down
			Move P(i) :U(CU(P(i))) :Z(CZ(P(i)) - ClearPanelLip)
			Move P(i) :Z(PreInspectionArray(currentHSHole, 0)) ' Now move up so the ears are lightly touching the panel			
	
			Wait .1	'wait a little bit before we lock the panel
			On panelEarLockH ' lock the panel in place
			
			HSProbeFinalPosition = ProbeToEarsOffset + recInsertDepth + recHeatStakeOffset 'calculate HS position
			Print "HSProbeFinalPosition", HSProbeFinalPosition
			
			MBWrite(pasInsertDepthAddr, inches2Modbus(HSProbeFinalPosition), MBType32) ' Send final weld depth
 			MBWrite(pasInsertEngageAddr, inches2Modbus(HSProbeFinalPosition - .35), MBType32) ' Set engagement point
           
            If HSProbeFinalPosition > 12.4 Then ' Check if we are going to send the probe too far.
				erUnknown = True ' replace this with a real error
            	Pause
                HotStakePanel = 2 ' default to fail		
               	SLock 1, 2, 3, 4 ' unlock all the joints so we can move again
               	Power High
				Speed SystemSpeed
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
            	Exit Function
            EndIf
 				
 			GoTo skiphotstake ' fake for testing
 				
			Do Until pasMessageDB = 4
				On heatStakeGoH, 1 ' Tell the HS to install 1 insert
				Wait .5
			Loop
			
			ZmaxTorque = 0
			PTCLR (3)
	
			Do Until pasMessageDB = 3 ' Monitor the torque when hs is installing insert
				ZmaxTorque = PTRQ(3)
				If ZmaxTorque > .3 Then
					erUnknown = True ' replace this with a real error
					Print "Over torque: HS vs Robot"
					Pause
				EndIf
			Loop
			
	skiphotstake: ' fake for testing	

			Wait 3
			Off panelEarLockH ' relese panel
			Wait .25
			
			Move P(i) -Z(ClearPanelLip)
            Move PreHotStake :U(CU(P(i))) :Z(CZ(P(i)) - ClearPanelLip) ' rotate to the correct theta position    
			
			Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap

		EndIf
		
		currentHSHole = currentHSHole + 1
		SLock 1, 2, 3, 4 ' unlock all the joints so we can move again
		Speed SystemSpeed
		SpeedS 1000 ' slow down
		
	Next
	
	HotStakePanel = 0 ' HS station executed without a problem
		
exitHotStake:

	If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
		jobAbort = True
		SLock 1, 2, 3, 4 ' unlock all the joints so we can move again
		Speed SystemSpeed
		MemOff (jobAbortH) ' turn off abort bit
	EndIf

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
		
Trap 2 ' disarm trap	

Fend
Function FlashPanel(DwellTime As Real) As Integer
	Trap 2, MemSw(jobAbortH) = True GoTo exitFlash ' arm trap
	SystemStatus = StateFlashRemoval
	
	Integer i
	currentFlashHole = 1
	
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
	Jump PreFlash :U(CU(Here)) LimZ zLimit ' go home

	Trap 2 ' disarm trap
Fend
Function InTomm(inches As Real) As Real
	InTomm = inches * 25.4
Fend
Function mmToin(mm As Real) As Real
	mmToin = mm * 0.0393701
Fend


