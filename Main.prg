#include "Globals.INC"

Function main()
OnErr GoTo errHandler ' Define where to go when a controller error occurs	

PowerOnSequence() ' Initialize the system and prepare it to do a job

Integer check, check2, NextState

jobStart = True 'fake
recPartNumber = 88555 ' fake for testing
recNumberOfHoles = 16 ' fake for test
recInsertDepth = .165 ' fake for testing
suctionWaitTime = 1.5 'fake
zLimit = -12.5 'fake
Power Low ' Manually set power to This will be done in PowerOnSequence()

Do While True

Loop

Do While True

mainCurrentState = StateIdle ' The first state is Idle

Select mainCurrentState

	Case StateIdle
	' This state waits for the operator to start a job and the heat stake machine 
	' to come up to temp. Also, if any of the other states encounters a major error, it returns	
	' to the idle state and waits for an operator.
	
		jobDone = False ' reset job done (move this)
		jobAbort = False ' reset job abort (move this)
		
		If jobStart = True Then 'And HotStakeTempRdy = True Then ' Fake for testing
			mainCurrentState = StatePopPanel
		Else
			mainCurrentState = StateIdle ' Stay in idle until ready
		EndIf
		
	Case StatePopPanel
	' This state picks up a panel from the input magazine. Then takes the panel to the home	
	' position. 
	
		StatusCheckPickUp = PickupPanel(0) ' Call the function that picks up a panel
				
		If StatusCheckPickUp = 0 Then ' Panel was picked up successfully
			mainCurrentState = StateCrowding
		ElseIf StatusCheckPickUp = 1 Then ' Keep trying until the interlock is closed
			mainCurrentState = StatePopPanel
		ElseIf StatusCheckPickUp = 2 Or abortJob = True Then
			mainCurrentState = StateIdle ' Go to idle because there was an error or we want to quit
		EndIf
		
	Case StateCrowding
		'This state Moves a panel from the home location, crowds it, then
		' presents it to the laser scanner for pre-inspection
		
		StatusCheckCrowding = CrowdingSequence(0) ' Add return ints for crowd seq for errors...

		If StatusCheckCrowding = 0 Then
			mainCurrentState = StatePreinspection
		ElseIf StatusCheckCrowding = 2 Or abortJob = True Then
			mainCurrentState = StateIdle ' Go to idle because there was an error or we want to quit
		EndIf

	Case StatePreinspection
		' This state uses the laser scanner to find pre-installed inserts and attempts
		' to check if the correct panel has been put into the magazine.
		' Add other checks
		
			StatusCheckPreinspection = InspectPanel(1) ' 1=Preinspection 
			If StatusCheckPreinspection = 0 Then
				mainCurrentState = StateHotStakePanel
			ElseIf StatusCheckPreinspection = 2 Or abortJob = True Then
				mainCurrentState = StateIdle ' Go to idle because there was an error or we want to quit
			EndIf
'		
	Case StateHotStakePanel
		' This state iterates through each hole and install an insert
		
		StatusCheckHotStake = HotStakePanel(0)
		If StatusCheckHotStake = 0 Then
			mainCurrentState = StateFlashRemoval ' The next state is Flash Removal
		ElseIf StatusCheckHotStake = 2 Or abortJob = True Then
				mainCurrentState = StateIdle ' Go to idle because there was an error or we want to quit
		EndIf
		
'	Case StateFlashRemoval

		StatusCheckFlash = FlashPanel(0)
'		If StatusCheckFlash = 0 Then
			mainCurrentState = StatePushPanel
'		Else
'			NextState = StateIdle
'		EndIf
	Case StatePushPanel
	' This state drops off a panel into the output magazine. 		
	
		StatusCheckDropOff = DropOffPanel(0)
		
		If StatusCheckDropOff = 0 Then ' We successfully dropped off a panel
			mainCurrentState = StatePopPanel
		ElseIf StatusCheckDropOff = 1 Then ' Keep trying until the interlock is closed
			mainCurrentState = StatePushPanel
		Else
			mainCurrentState = StateIdle ' Go to idle because there was an error
		EndIf
	Send
		
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
Function PowerOnSequence()
	
	' define the connection to the LASER
    SetNet #203, "10.22.251.171", 7351, CR, NONE, 0
    OpenNet #203 As Client

	' Execute Tasks
	Xqt 2, IOTableInputs, NoEmgAbort
	Xqt 3, IOTableOutputs, NoEmgAbort
	Xqt 4, SystemMonitor, NoEmgAbort
	Xqt 5, iotransfer, NoEmgAbort
	Xqt 6, HmiListen, NoEmgAbort
	Xqt 7, InMagControl, Normal ' First state is lowering 
	Xqt 8, OutMagControl, Normal ' First state is raising 
	Xqt 9, JointTorqueMonitor(), Normal
	'MBInitialize() ' Kick off the modbus
retry:

'	If PowerOnHomeCheck() = False Then GoTo retry ' Don't let the robot move unless its near home
	
	Motor On
	Power Low
	Speed 20 'Paramterize these numbers
	Accel 50, 50
	QP (On) ' turn On quick pausing	
	Fine 1000, 1000, 1000, 1000 ' set the robot to high accuracy 	
	LoadPoints "points3.pts"
	
'	Move PreScan :U(CU(CurPos)) ' go home
'	Move PreScan ROT ' go home

	
Fend
'Function CheckInitialParameters() As Boolean
''check if the hmi has pushed all the recipe values to the controller, if not throw an error 	
''check if the hmi has pushed all the parameter values to the controller, if not throw an error 
'
'	'add in check that panelarray is nonzero
'	
'	If recInsertDepth = 0 Or recInsertType = 0 Or recNumberOfHoles = 0 Or recTempProbe = 0 Or recTempTrack = 0 Then
'		CheckInitialParameters = False
'	Else
'		CheckInitialParameters = True
'	EndIf
'	
'	If AnvilZlimit = 0 Or suctionWaitTime = 0 Or SystemSpeed = 0 Or SystemAccel = 0 Then
'		CheckInitialParameters = False
'	Else
'		CheckInitialParameters = True
'	EndIf
'	
'CheckInitialParameters = True 'fake for testing
'
'Fend
Function HotStakeTempRdy() As Boolean
	
	Boolean probeInTemp, trackInTemp
	
	'Is the current temp within the tolerance to start or continue a job?
'	If Abs(recTempProbe - pasActualTempZone1) < Abs(probeTempTolerance) Then
'		probeInTemp = True
'	Else
'		probeInTemp = False
'	EndIf
'	
'	If Abs(recTempTrack - pasActualTempZone2) < Abs(trackTempTolerance) Then
'		trackInTemp = True
'	Else
'		trackInTemp = False
'	EndIf
	
	If probeInTemp = True And trackInTemp = True Then
		HotStakeTempRdy = True ' ready to start job
		erHeatStakeTemp = False
	Else
		HotStakeTempRdy = False ' Temperature is not in range
		erHeatStakeTemp = True
	EndIf
	
	HotStakeTempRdy = True ' fake for testing
	
Fend
'Function PowerOnHomeCheck() As Boolean
'	
'	Real distx, disty, distz, distance
''TODO: Parameterize these #defines?
'	#define startUpDistMax 300 '+/-150mm from home position
'	
'	distx = Abs(CX(CurPos) - CX(PreScan))
'	disty = Abs(CY(CurPos) - CY(PreScan))
'	
'	distance = Sqr(distx * distx + disty * disty) ' How the hell do you square numbers?
'
'	If distance > startUpDistMax Then 'Check is the position is close to home. If not throw error
'		erRobotNotAtHome = True
'		PowerOnHomeCheck = False
''		Print "Distance NOT OK, distance"
'	Else
'		erRobotNotAtHome = False
'		PowerOnHomeCheck = True
''		Print "Distance OK"
'	EndIf
'	
'	Print Hand(Here)
'	
'	If Hand(Here) = 1 Then ' throw the error if the arm is in "righty" orientation
'		erRobotNotAtHome = True
'		PowerOnHomeCheck = False
'		Print "Arm Orientation NOT OK"
'	Else
'		erRobotNotAtHome = False
'		PowerOnHomeCheck = True
'		Print "Arm Orientation OK"
'	EndIf
'	
'	If PowerOnHomeCheck = False Then ' When false, free all the joints so opperator can move
'		Motor On
'		SFree 1, 2, 3, 4
'		Print "move robot to home position"
'		Pause
'	EndIf
'		
'Fend
'

Function getRobotPoints()
	
	Select recPartNumber
		
		Case 88555
			
			LoadPoints "points.pts"
			FirstHolePointInspection = 350
			LastHolePointInspection = 365
			FirstHolePointHotStake = 400
			LastHolePointHotStake = 405
			'FirstHolePointFlash = 316
			'LastHolePointFlash = 331
			
		Case 12345
		
		Default
			Print "No point defined for this panel"
			'throw and error
	Send
Fend
