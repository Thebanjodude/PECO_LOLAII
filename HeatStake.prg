#include "Globals.INC"

Function HotStakePanel() As Integer

	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap
	' While the HS is in state 4, installing an insert, I revoke the ability to abort.
	SystemStatus = StateHotStakePanel
	
	Integer i, Counter
	Real RobotZOnAnvil
	Boolean SkippedHole
	currentHSHole = 1 ' Start at 1 (we are skipping the 0 index in the array)
	HotStakePanel = 2 ' default to fail	
	
	Jump PreScan LimZ zLimit ' just to make sure we are home	
	Jump PreHotStake LimZ zLimit ' Present panel to hot stake
	
	'update to new PLC interface
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
		
		If currentHSHole = 3 Or currentHSHole = 4 Or currentHSHole = 5 Or currentHSHole = 11 Or currentHSHole = 12 Then ' The keys are in the way of fixed ears so skip 'em
			SkippedHole = True 'Set flag
			Print "Skipped Hole"
		EndIf

		If SkippedHole = False Then 'If the flag is set then skip the hole
		
			Jump P(i) +Z(10) LimZ zLimit  ' Go to the next hole        
			SFree 1, 2 ' free X and Y

			Counter = 0 ' reset counter
			Do While Sw(HSPanelPresntH) = False 'Or Counter > 20 ' Approach the panel slowly until we hit the anvil switch
				JTran 3, -.5 ' Move only the z-axis downward in increments
				Counter = Counter + 1
			Loop
			
			Print "HS Counter:", Counter
			
'			If Counter > 20 Then ' A boss should be engaging the anvil but it isnt...
'				erPanelStatusUnknown = True
'				HotStakePanel = 2 ' fail
'				Print "Boss did not engage the anvil"
'				SLock 1, 2, 3, 4
				'Speed SystemSpeed
'				GoTo exitHotStake
'			EndIf
 				
' 			GoTo skiphotstake ' fake for testing
 				
 		'update to new plc interface
'			Do Until pasMessageDB = 4
'				On heatStakeGoH, 1 ' Tell the HS to install 1 insert
'				Wait .5
'			Loop
			
			ZmaxTorque = 0
			PTCLR (3)
	
	'	update to new PLC interface
'			Do Until pasMessageDB = 3 ' monitor the torque when hs is installing insert
'				ZmaxTorque = PTRQ(3)
'				If ZmaxTorque > .3 Then
'					erUnknown = True ' replace this with a real error
'					Print "Over torque: HS vs Robot"
'					Pause
'				EndIf
'			Loop
			
'	skiphotstake: ' fake for testing
'	Wait 1 ' fake for testing
			Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap

		EndIf
		
		currentHSHole = currentHSHole + 1
		SLock 1, 2, 3, 4 ' unlock all the joints so we can move again
		Speed SystemSpeed
		
	Next
	
	HotStakePanel = 0 ' HS station executed without a problem
		
exitHotStake:

	If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
		jobAbort = True
		SLock 1, 2, 3, 4 ' unlock all the joints so we can move again
		Speed SystemSpeed
		MemOff (jobAbortH) ' turn off abort bit
	EndIf

'	update to new PLC interface
'	Do Until pasMessageDB = 2 ' wait for the HS to get home before we move (this wastes a lot of time)
'		MBWrite(pasGoHomeAddr, 1, MBTypeCoil) ' Home the heat stake machine by toggling
'		Wait 1
'		MBWrite(pasGoHomeAddr, 0, MBTypeCoil)
'		
'		' while the heat stake is homing the messageDB is 9
'		' so lets give it a chance to go home before we throw it into
'		'   a loop of homing where we will not see the messageDB == 2
'		Do While pasMessageDB = 9
'			'waiting for the heat stake to finish homeing
'			Wait .5
'		Loop
'	Loop
		
	SystemStatus = StateMoving
	Jump PreHotStake :U(CU(Here)) LimZ zLimit ' Pull back from the hot stake machine
	Jump preScan LimZ zLimit ' go home
		
Trap 2 ' disarm trap	

Fend

