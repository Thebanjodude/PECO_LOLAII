#include "Globals.INC"

Function main()
	OnErr GoTo errHandler ' Define where to go when a controller error occurs	

'TESTING -- load good recipe values
	PanelHoleX(1) = -179.77422356472
	PanelHoleY(1) = -132.43134762242
	PanelHoleX(2) = -198.74718812993
	PanelHoleY(2) = -65.430033536321
	PanelHoleX(3) = -171.28250945707
	PanelHoleY(3) = -1.2308079334744
	PanelHoleX(4) = -125.81555021263
	PanelHoleY(4) = 52.394106332387
	PanelHoleX(5) = -72.306435100346
	PanelHoleY(5) = 98.487582032034
	PanelHoleX(6) = -14.342672809443
	PanelHoleY(6) = 138.8740766902
	PanelHoleX(7) = 49.550656486224
	PanelHoleY(7) = 168.63071744313
	PanelHoleX(8) = 119.87504912673
	PanelHoleY(8) = 175.80813542419
	PanelHoleX(9) = 177.55140497248
	PanelHoleY(9) = 134.94664363107
	PanelHoleX(10) = 196.31157030827
	PanelHoleY(10) = 67.960417532818
	PanelHoleX(11) = 168.91278936305
	PanelHoleY(11) = 4.0936103569875
	PanelHoleX(12) = 123.68260670645
	PanelHoleY(12) = -49.580648081697
	PanelHoleX(13) = 69.963353937622
	PanelHoleY(13) = -95.243638741817
	PanelHoleX(14) = 12.070102407699
	PanelHoleY(14) = -135.56428412077
	PanelHoleX(15) = -51.428110387016
	PanelHoleY(15) = -166.55008614946
	PanelHoleX(16) = -121.9716809477
	PanelHoleY(16) = -172.70294046714

	'Set system vars
	recSuctionWaitTime = 1 'fake
	zLimit = -1 'fake
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
	
	' the EOAT is XXXdeg off of zero and the panel recipes are YYYdeg off
	' sorta, its really panels are placed into the magazine 90deg off counterclockwise
	' and the eoat is ... well... yeah
	EOATcorrection = -45 - 7.8
	magazineCorrection = -90
	systemThetaError = EOATcorrection + magazineCorrection
	
'	'TeachPointsUnderLaser() ' prototype teaching code (get it close and home in on it)
'	Call runTest()
'	Exit Function
	
'	'test the repeatability of the crowding sequence
'	Pause
'	Call PanelPrintRecipe
'	Call testCrowding
'	Exit Function


	Call PanelPrintRecipe
	
	Call changeSpeed(fast)
	
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

