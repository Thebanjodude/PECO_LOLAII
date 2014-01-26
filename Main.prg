#include "Globals.INC"

Function blah(num As Long)
	Integer i, foo
	
'	Print "num: ", num, " --base2: ",
	
	For i = 31 To 0 Step -1
		foo = BTst(num, i)
'		If BTst(num, i) = 0 Then
'			Print "0",
'		Else
'			Print "1",
'		EndIf
	Next
	
'	Print "."
Fend
Function blah2(num As Long)
	Integer i, foo
	
'	Print "num: ", num, " --base2: ",
	
	For i = 31 To 0 Step -1
		foo = RShift(num, i) And &h01
'		If foo = 0 Then
'			Print "0",
'		Else
'			Print "1",
'		EndIf
	Next
	
'	Print "."
Fend

Function main()
	OnErr GoTo errHandler ' Define where to go when a controller error occurs	
	
	Integer j
	
	TmReset 1
	For j = 0 To 300
		Call blah(255)
	Next
	Print "Bst    Took: ", Tmr(1) / 300, " seconds"
'	Print "Bst    Took: ", Tmr(1), " seconds"

	TmReset 1
	For j = 0 To 300
		Call blah2(255)
	Next
	Print "Rshift Took: ", Tmr(1) / 300, " seconds"
'	Print "Rshift Took: ", Tmr(1), " seconds"

	Exit Function
	
		
	
	
	
	'Set system vars
	recSuctionWaitTime = 1 'fake
	zLimit = -12.5 'fake
	SystemSpeed = 100
	SystemAccel = 35
	insertDepthTolerance = .010
	recPointsTable = 1
	
	'Testing Area for State skipping
	recPopPanelRequired = True
	recCrowdingRequired = True
	recPreinspectionRequired = True
	'recFlashRequired = True ' this is actually a recipe variable
	recHotStakePanelRequired = True
	recInspectionRequired = True
	recPushPanelRequired = True
	
	PowerOnSequence() ' Initialize the system and prepare it to do a job
	
	jobDone = False ' reset flag
	jobStart = False ' reset flag
	
	'TeachPointsUnderLaser() ' prototype teaching code (get it close and hone in on it)

	Call runTest
	Exit Function
	
	Call changeSpeed(slow)
	
	mainCurrentState = StateIdle ' The first state is Idle
	
	Do While True
		Select mainCurrentState
		
			Case StateIdle
			' This state waits for the operator to initate an activity
				mainCurrentState = idleState(mainCurrentState)
				
			Case StatePopPanel
			' This state picks up a panel from the input magazine and moves it to the home position
				mainCurrentState = popPanelState(mainCurrentState)
				
			Case StateCrowding
			'This state Moves a panel from the home location, crowds it, then presents it to the laser scanner for pre-inspection
				mainCurrentState = crowdingState(mainCurrentState)

			Case StatePreinspection
			' This state uses the laser scanner to find pre-installed inserts and attempts
			' to check if the correct panel has been put into the magazine.
				mainCurrentState = preinspectionState(mainCurrentState)
				
			Case StateHotStakePanel
			' This state iterates through each hole and installs all inserts
				mainCurrentState = insertionState(mainCurrentState)
				
			Case StateFlashRemoval
			' This state performs flash removal
				mainCurrentState = flashRemovalState(mainCurrentState)
				
			Case StateInspection
			' This state uses the laser scanner to measure and log the depths of each insert at two places
				mainCurrentState = inspectionState(mainCurrentState)
				
			Case StatePushPanel
			' This state drops off a panel into the output magazine. 		
				mainCurrentState = pushPanelState(mainCurrentState)
				
			Case StateEmptyingBowlandTrack
			' This state dumps inserts out of the system
				mainCurrentState = dumpState(mainCurrentState)
				
		Send
		
		If jobAbort = True Then ' push a panel before going to idle
			mainCurrentState = StatePushPanel
		EndIf

	Loop
	
	errHandler:
		
		'Assign things of interest to var names
		ctrlrErrMsg$ = ErrMsg$(Err)
	 	ctrlrLineNumber = Erl
		ctrlrTaskNumber = Ert
	 	ctrlrErrAxisNumber = Era
	 	ctrlrErrorNum = Err
	 	
	 	' Print error for testing/troubleshooting
	 	Print "Error Message:", ctrlrErrMsg$
		Print "Error Line Number:", ctrlrLineNumber
		Print "Error Task Number:", ctrlrTaskNumber
		Print "Error AxisNumber:", ctrlrErrAxisNumber
		Print "Error Number:", ctrlrErrorNum
		Pause
	EResume
		
Fend

