#include "Globals.INC"

Function main()
OnErr GoTo errHandler ' Define where to go when a controller error occurs	

PowerOnSequence() ' Initialize the system and prepare it to do a job

Integer check, check2, NextState, StatusCheckPickUp, StatusCheckDropOff

jobStart = True 'fake
recPartNumber = 12345 ' fake for testing
recNumberOfHoles = 16 ' fake for test
recInsertDepth = .165 ' fake for testing
suctionWaitTime = 1.5 'fake
zLimit = -12.5 'fake

mainCurrentState = StatePopPanel
'mainCurrentState = StateIdle ' The first state is Idle

Power High

Do While True

'This is just a sequence I use for easy testing
'CrowdingSequence()
'InspectPanel(Preinspection)
'HotStakeTest()
'FlashTest()
'InspectPanel(Postinspection)

'mainCurrentState = StateIdle ' The first state is Idle

'The state machine below is production code, I will integrate incrementally



Select mainCurrentState

	Case StateIdle
		jobDone = False
		If jobStart = True Then 'And HotStakeTempRdy = True Then
			mainCurrentState = StatePopPanel
		Else
			mainCurrentState = StateIdle
		EndIf
		
	Case StatePopPanel
		
		StatusCheckPickUp = PickupPanel(0)
		Print "StatusCheckPickUp", StatusCheckPickUp
		
		If StatusCheckPickUp = 0 Then
			Print "here"
			mainCurrentState = StatePushPanel
		ElseIf StatusCheckPickUp = 1 Then
			mainCurrentState = StatePopPanel ' keep visititng until the interlock is closed
		Else
			mainCurrentState = StateIdle ' Go to idle because there was an error
		EndIf

'	Case StatePreinspection
'		If True Then
'			NextState = StateHotStakePanel
'		Else
'			NextState = StateIdle
'		EndIf
'		
'	Case StateHotStakePanel
'		If HotStakePanel = True Then
'			Print "done"
'			Pause
'			NextState = StateFlashRemoval
'		Else
'			NextState = StateIdle
'		EndIf
'	Case StateFlashRemoval
'		If FlashRemoval = True Then
'			NextState = StatePushPanel
'		Else
'			NextState = StateIdle
'		EndIf
	Case StatePushPanel
		
		StatusCheckDropOff = DropOffPanel(0)
		Print "StatusCheckDropOff", StatusCheckDropOff
		
		If StatusCheckDropOff = 0 Then
			mainCurrentState = StatePopPanel
		ElseIf StatusCheckDropOff = 1 Then
			mainCurrentState = StatePushPanel
		Else
			mainCurrentState = StateIdle
		EndIf
	Send
		
		'mainCurrentState = NextState
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
'Function SetInitialValues()
'	' This is going to be OBS-the HMI will initialize the vars and I will check that
'	'they get initialized
'	jobStart = True ' fake
'	SystemSpeed = 50
'	AnvilZlimit = -150.00
'	suctionWaitTime = 2
'	SystemAccel = 30
'	zLimit = -15
''	jobNumPanelsDone = 0
''	jobNumPanels = 0
'Fend
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

