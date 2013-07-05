#include "Globals.INC"

Function main()
OnErr GoTo errHandler ' Define where to go when a controller error occurs	

PowerOnSequence() ' Initialize the system and prepare it to do a job

'jobStart = True 'fake
'recPartNumber = 88555 ' fake for testing
'recPartNumber = 88558 ' fake for testing
recNumberOfHoles = 16 ' fake for test
recFlashRequired = True
recInsertDepth = .165 ' fake for testing
suctionWaitTime = 2 'fake
zLimit = -12.5 'fake
recInmag = 50
recOutmag = 101
recPreCrowding = 51
recCrowding = 52
recFlashDwellTime = 1
FirstHolePointInspection = 53
LastHolePointInspection = 68
FirstHolePointHotStake = 69
LastHolePointHotStake = 84
FirstHolePointFlash = 85
LastHolePointFlash = 100
LoadPoints "points.pts"
Power High ' Manually set power. This will be done in PowerOnSequence()
Speed 65

mainCurrentState = StateIdle ' The first state is Idle

Do While True

Select mainCurrentState

	Case StateIdle
	' This state waits for the operator to start a job and the heat stake machine 
	' to come up to temp. Also, if any of the other states encounters a major error, it returns	
	' to the idle state and waits for an operator.
		
		If jobStart = True Then 'And HotStakeTempRdy = 0 and CheckInitialParameters()=0 Then ' Fake for testing
			mainCurrentState = StatePopPanel
			jobStart = False ' reset flag
		Else
			mainCurrentState = StateIdle ' Stay in idle until ready
		EndIf
		
	Case StatePopPanel
	' This state picks up a panel from the input magazine. Then takes the panel to the home	
	' position. 
	
		StatusCheckPickUp = PickupPanel(0) ' Call the function that picks up a panel
				
		If StatusCheckPickUp = 0 Then ' Panel was picked up successfully
			mainCurrentState = StateCrowding
			'mainCurrentState = StatePushPanel ' fake for testing
			Print "Pick up Successful"
		ElseIf StatusCheckPickUp = 1 Then ' Keep trying until the interlock is closed
			mainCurrentState = StatePopPanel
			Print "Waiting for Interlock"
		ElseIf StatusCheckPickUp = 2 Then
			Jump PreScan LimZ zLimit ' go back home
			mainCurrentState = StateIdle ' Go to idle because there was an error 
			Print "Pickup failed"
		Else
			mainCurrentState = StateIdle ' Go to idle because its the only thing to do
			Print "going to idle"
		EndIf
		
'		If jobAbort = True Then
'			mainCurrentState = StatePushPanel ' push a panel before going to idle
'			print "aborting pick up)
'		EndIf
				
	Case StateCrowding
		'This state Moves a panel from the home location, crowds it, then
		' presents it to the laser scanner for pre-inspection
		
		'Bug-> abort job and leave the panel in the nest!
		
		StatusCheckCrowding = CrowdingSequence(0) ' Add return ints for crowd seq for errors...

'		If StatusCheckCrowding = 0 Then
			mainCurrentState = StatePreinspection
'		ElseIf StatusCheckCrowding = 2 Then
'			mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle
'		EndIf
		
'		If jobAbort = True Then
'			mainCurrentState = StatePushPanel ' Go drop off the panel before we quit 
'		EndIf

	Case StatePreinspection
		' This state uses the laser scanner to find pre-installed inserts and attempts
		' to check if the correct panel has been put into the magazine.
		
			StatusCheckPreinspection = InspectPanel(1) ' 1=Preinspection 
			If StatusCheckPreinspection = 0 Then
				mainCurrentState = StateHotStakePanel
'				mainCurrentState = StateInspection
				Print "Preinspection executed"
			ElseIf StatusCheckPreinspection = 2 Then
				mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle 
				' go to this state if we cant find all the holes 
			EndIf
			
			If jobAbort = True Then
				mainCurrentState = StatePushPanel ' Drop off the panel before we quit 
				Print "aborting"
			EndIf
		
	Case StateHotStakePanel
		' This state iterates through each hole and installs all inserts
		
		StatusCheckHotStake = HotStakePanel(0)
		If StatusCheckHotStake = 0 Then
			Print "hot stake done"
			If recFlashRequired = False Then
				mainCurrentState = StateInspection ' Flash not required so skip it
			Else
				mainCurrentState = StateFlashRemoval ' The next state is normally Flash Removal
			EndIf
		ElseIf StatusCheckHotStake = 2 Then
			mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle
		EndIf
		
		If jobAbort = True Then
			mainCurrentState = StatePushPanel ' Drop off the panel before we quit	
		EndIf
		
	Case StateFlashRemoval

		StatusCheckFlash = FlashPanel(recFlashDwellTime)
		If StatusCheckFlash = 0 Then
			mainCurrentState = StateInspection
		ElseIf StatusCheckFlash = 2 Then ' Go to idle because there was an error
			mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle
		EndIf

		If jobAbort = True Then
			mainCurrentState = StatePushPanel ' Go to idle because the operator wants to quit
		EndIf
		
	Case StateInspection
		' This state uses the laser scanner to find pre-installed inserts and attempts
		' to check if the correct panel has been put into the magazine.
		' Add other checks
		
			StatusCheckInspection = InspectPanel(2) ' 2=Inspection of Install Inserts 
			If StatusCheckInspection = 0 Then
				mainCurrentState = StatePushPanel
				Print "Inspection Executed"
			ElseIf StatusCheckPreinspection = 2 Then
				mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle
			EndIf
			
		If jobAbort = True Then
			mainCurrentState = StatePushPanel ' Go to idle because the operator wants to quit	
		EndIf
		
	Case StatePushPanel
	' This state drops off a panel into the output magazine. 		
	
		StatusCheckDropOff = DropOffPanel(0)
		
		If StatusCheckDropOff = 0 Then ' We successfully dropped off a panel
			mainCurrentState = StatePopPanel
		ElseIf StatusCheckDropOff = 1 Then ' Keep trying until the interlock is closed
			mainCurrentState = StatePushPanel
		EndIf
		
		If jobAbort = True Or jobDone = True Then
			Jump PreScan LimZ zLimit ' go home
			mainCurrentState = StateIdle ' Go to idle because the operator wants to quit or job is done	
			jobAbort = False ' reset flag
			jobStart = False ' reset flag
			jobDone = True ' set flag
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
	MBInitialize() ' Kick off the modbus
retry:

'	If PowerOnHomeCheck() = False Then GoTo retry ' Don't let the robot move unless its near home
	
	Motor On
	Power Low
	Speed 20 'Paramterize these numbers
	Accel 50, 50
	QP (On) ' turn On quick pausing	
	Fine 1000, 1000, 1000, 1000 ' set the robot to high accuracy 	
	
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
	
	If pasPIDsetupInTempZone1 = True And pasPIDsetupInTempZone2 = True Then
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
' TODO: Parameterize these #defines?
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

Function getRobotPoints() As Integer
'This is where PECO will put a case in for each panel they have. 	
'From the recipe, the part number is chosen from this case statement and all the taught points are loaded up 
'at runtime.

	Select recPartNumber
		
		Case 88555
			
			LoadPoints "points.pts"
			FirstHolePointInspection = 350
			LastHolePointInspection = 365
			FirstHolePointHotStake = 400
			LastHolePointHotStake = 405
			FirstHolePointFlash = 316
			LastHolePointFlash = 331
			recInmag = 45
			recOutmag = 55

			erPanelUndefined = False
			getRobotPoints = 0
			
		Case 88558
			LoadPoints "points.pts"
			recInmag = 54
			recOutmag = 55
			erPanelUndefined = False
			getRobotPoints = 0
		
		Default
			' An operator chose a panel part number that has not been programmed into the system
			erPanelUndefined = True
			getRobotPoints = 2
	Send
Fend
Function testLaser()
	
	Crowding = 100
	
Do While True
	LoadPoints "points.pts"
	Integer i, s
	zLimit = -12.5
	suctionWaitTime = 1
	recNumberOfHoles = 3
	s = 0
	Motor On
	Power High
	Speed 50
	Accel 50, 50
	Redim InspectionArray(2, 1)
	
	CrowdingSequence(0)
	Jump PreScan LimZ zLimit
	
For i = 110 To 112
	Jump P(i) LimZ zLimit
	MeasureInsertDepth(s)
	s = s + 1
	Go P(i) -Y(50)
Next

	PrintInspectionArray()
	Jump PreScan LimZ zLimit
Loop

Fend
	

