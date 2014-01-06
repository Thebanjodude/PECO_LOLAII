#include "Globals.INC"

Function HotStakePanel() As Integer

	Trap 2, MemSw(jobAbortH) = True GoTo exitHotStake ' arm trap

	SystemStatus = StateHotStakePanel
	
	Integer i
	Real RobotZOnAnvil
	Boolean SkippedHole
	currentHSHole = 1 				' Start at 1 (we are skipping the 0 index in the array)
	HotStakePanel = 2 				' default to fail	
	
	If Not idle Then				' the PLC isn't in the correct state for entering the insertion program
		GoTo exitHotStake
	EndIf
	
	Jump PreScan LimZ zLimit 		' just to make sure we are home	
	Jump PreHotStake LimZ zLimit 	' Present panel to hot stake
	
	gotoReadyCC = True				' Tell PLC to start the insertion process
	
	Do Until ready					' ready signal from PLC
		Wait .25
	Loop

	For i = recFirstHolePointHotStake To recLastHolePointHotStake

		SkippedHole = False 							'Reset flag		
		If SkipHoleArray(currentHSHole, 0) <> 0 Then 	' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 							'Set flag
			Print "Skipped Hole"
		EndIf
		
		If SkippedHole = False Then 			'If the flag is set then skip the hole
		
			Jump P(i) +Z(10) LimZ zLimit  		' Go to the next hole        
			SFree 1, 2 							' free X and Y

			Do While Sw(HSPanelPresntH) = False
				JTran 3, -.5 					' Move only the z-axis downward in increments
			Loop
			
			doInsertionCC = True

			'Wait insertingH
			Wait Sw(3)

			Do While inserting
				Wait .5
			Loop
			doInsertionCC = False

			ZmaxTorque = 0
			PTCLR (3)

			SLock 1, 2, 3, 4 						' lock all the joints so we can move again
			Speed SystemSpeed
	
		EndIf
		
		currentHSHole = currentHSHole + 1
	
		'Wait readyH								' give the PLC time to get back to ready state
		Wait Sw(2)
'		If Not ready Then						' something has gone wrong with the plc
'			Exit For
'		EndIf
		
	Next
	
	HotStakePanel = 0 							' HS station executed without a problem
		
exitHotStake:

	If MemSw(jobAbortH) = True Then 	'Check if the operator wants to abort the job
		jobAbort = True
		SLock 1, 2, 3, 4 				' lock all the joints so we can move again
		Speed SystemSpeed
		MemOff (jobAbortH) 				' turn off abort bit
	EndIf
		
	SystemStatus = StateMoving
	Jump PreHotStake :U(CU(Here)) LimZ zLimit 	' Pull back from the hot stake machine
	Jump preScan LimZ zLimit 					' go home

	doneInsertingCC = True				' Tell the PLC to leave the inserting state
	Do Until idle						' indication that the plc is idle
		Wait .5
	Loop
	gotoReadyCC = False					' reset flag
	doneInsertingCC = False				' reset flag
		
Trap 2 ' disarm trap	

Fend

