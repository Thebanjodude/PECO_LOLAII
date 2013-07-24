#include "Globals.INC"

Function main()
OnErr GoTo errHandler ' Define where to go when a controller error occurs	

PowerOnSequence() ' Initialize the system and prepare it to do a job

'jobStart = True 'fake
'recInmag = 10 '88558
'recOutmag = 13 '88558
recFlashRequired = False
suctionWaitTime = 2 'fake
zLimit = -12.5 'fake
recFlashDwellTime = 0
insertDepthTolerance = .006
'______________________________________
'recNumberOfHoles = 16 ' fake for test
'recInsertDepth = 0.165 ' fake for testing
'recInmag = 50
'recOutmag = 101
'recPreCrowding = 51
'recCrowding = 52
'recFirstHolePointInspection = 53
'recLastHolePointInspection = 68
'recFirstHolePointHotStake = 69
'recLastHolePointHotStake = 84
'recFirstHolePointFlash = 85
'recLastHolePointFlash = 100
'LoadPoints "points.pts"
'DeepBoss = True
'_____________________________________
'recNumberOfHoles = 23 ' fake for test
'recInmag = 50
'recOutmag = 122
'recPreCrowding = 51
'recCrowding = 52
'recFirstHolePointInspection = 53
'recLastHolePointInspection = 75
'recFirstHolePointHotStake = 76
'recLastHolePointHotStake = 98
'recFirstHolePointFlash = 99
'recLastHolePointFlash = 121
'LoadPoints "points2.pts"
'DeepBoss = False
'______________________________________
recNumberOfHoles = 14 ' fake for test
recInsertDepth = 0.030 ' fake for testing
recInmag = 103
recOutmag = 148
recPreCrowding = 104
recCrowding = 105
recFirstHolePointInspection = 106
recLastHolePointInspection = 119
recFirstHolePointHotStake = 120
recLastHolePointHotStake = 133
recFirstHolePointFlash = 134
recLastHolePointFlash = 147
LoadPoints "points.pts"
MediumBoss = True
'___________________________________________
Power High ' Manually set power. This will be done in PowerOnSequence()
Speed 30 ' fake for test
jobDone = False ' fake for test
jobStart = False ' reset flag

mainCurrentState = StateIdle ' The first state is Idle

'Calibrate()
'Print "done"
'Pause

Do While True

Select mainCurrentState

	Case StateIdle
	' This state waits for the operator to start a job and the heat stake machine 
	' to come up to temp. Also, if any of the other states encounters a major error, it returns	
	' to the idle state and waits for an operator.
		
		If jobStart = True Then 'And HotStakeTempRdy = 0 and CheckInitialParameters()=0 Then ' Fake for testing
			mainCurrentState = StatePopPanel
			'mainCurrentState = StatePreinspection
			'mainCurrentState = StateHotStakePanel
			'mainCurrentState = StateFlashRemoval
			'mainCurrentState = StateCrowding
			Do Until pasMessageDB = 2 ' wait for the HS to get home before we move (this wastes a lot of time)
				MBWrite(pasGoHomeAddr, 1, MBTypeCoil) ' Home the heat stake machine by toggling
				Wait 1
				MBWrite(pasGoHomeAddr, 0, MBTypeCoil)
				Do While pasMessageDB = 9
			'waiting for the heat stake to finish homeing
					Wait .5
				Loop
			Loop
			jobStart = False ' reset flag
			jobAbort = False 'reset flag
			jobNumPanelsDone = 0 ' reset panel counter
			Redim PassFailArray(23, 1) ' Clear array, always 23 rows
			Redim InspectionArray(23, 1) 'Clear array, always 23 rows
			
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
		
		If jobAbort = True Then
			mainCurrentState = StatePushPanel ' push a panel before going to idle
			Print "aborting pick up"
		EndIf
				
	Case StateCrowding
		'This state Moves a panel from the home location, crowds it, then
		' presents it to the laser scanner for pre-inspection
		
		StatusCheckCrowding = CrowdingSequence(0) ' Add return ints for crowd seq for errors...

'		If StatusCheckCrowding = 0 Then
			mainCurrentState = StatePreinspection
'			mainCurrentState = StateInspection
'			mainCurrentState = StateHotStakePanel
'			mainCurrentState = StateFlashRemoval
'			mainCurrentState = StatePushPanel
'		ElseIf StatusCheckCrowding = 2 Then
'			mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle
'		EndIf
		
		If jobAbort = True Then
			mainCurrentState = StatePushPanel ' Go drop off the panel before we quit 
		EndIf

	Case StatePreinspection
		' This state uses the laser scanner to find pre-installed inserts and attempts
		' to check if the correct panel has been put into the magazine.
		
			StatusCheckPreinspection = InspectPanel(1) ' 1=Preinspection 
			If StatusCheckPreinspection = 0 Then
				mainCurrentState = StateHotStakePanel
'				mainCurrentState = StateInspection
'				mainCurrentState = StatePushPanel
				Print "Preinspection executed"
			ElseIf StatusCheckPreinspection = 2 Then
				mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle 
				' go to this state if we cant find all the holes 
			EndIf
			
			If jobAbort = True Then
				mainCurrentState = StatePushPanel ' Drop off the panel before we quit 
			EndIf
		
	Case StateHotStakePanel
		' This state iterates through each hole and installs all inserts
		
		StatusCheckHotStake = HotStakePanel(0)
		If StatusCheckHotStake = 0 Then
			Print "hot stake done"
			If recFlashRequired = False Then
				mainCurrentState = StateInspection ' Flash not required so skip it
				'mainCurrentState = StatePushPanel
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
			' I dont know if pushing is the correct solution...? if the tool never made it home it would
			' break it when it tried to move (cause its stuck in the hole)
			mainCurrentState = StatePushPanel ' Drop off a panel before we go to idle
		EndIf

		If jobAbort = True Then
			mainCurrentState = StatePushPanel ' Go to push then idle because the operator wants to quit
		EndIf
		
	Case StateInspection
		' This state uses the laser scanner to measure and log the depths of each insert at two places
		' No matter the result of the InspectPanel() routine it always pushes a panel, but we need to know why
		' it pushed-thus the different checks.
		
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
		ElseIf StatusCheckDropOff = 2 Then
			Pause
		EndIf
		
		If jobAbort = True Or jobDone = True Then
			Jump PreScan LimZ zLimit ' go home
			mainCurrentState = StateIdle ' Go to idle because the operator wants to quit or job is done	
			jobAbort = False ' reset flag
			jobStart = False ' reset flag
			jobDone = False ' reset flag
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
    Xqt 7, InmagControl, Normal
    Xqt 8, OutMagControlRefactor(), Normal
	MBInitialize() ' Kick off the modbus
retry:

	ClearMemory() ' writes a zero to all the memIO

'	If PowerOnHomeCheck() = False Then GoTo retry ' Don't let the robot move unless its near home
	
	Motor On
	Power Low
	Speed 20 'Paramterize these numbers
	Accel 50, 50
	QP (On) ' turn On quick pausing	
	
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
	
	If pasOTAOnOffZone1 = True And pasOTAOnOffZone2 = True Then
		HotStakeTempRdy = True ' ready to start job
	Else
		HotStakeTempRdy = False ' Temperature is not in range
	EndIf
	
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

Function ClearMemory()
	
	For x = 0 To 15
		MemOutW x, 0 ' This writes 0 to all memory locations in word chunks
	Next
	
	x = 0
	
Fend
Function TestHeatStake()
	
	Do Until jobStart = True
		Wait .1
	Loop
	
	Do Until pasMessageDB = 2 ' wait for the HS to get home before we move (this wastes a lot of time)
			MBWrite(pasGoHomeAddr, 1, MBTypeCoil) ' Home the heat stake machine by toggling
			Wait 1
			MBWrite(pasGoHomeAddr, 0, MBTypeCoil)
			Do While pasMessageDB = 9
			'waiting for the heat stake to finish homeing
				Wait .5
			Loop
	Loop
	
	Do Until pasMessageDB = 3
		On heatStakeGoH, 1 ' Tell HS to go to soft home position
		Wait 1.25
	Loop
	
	HSProbeFinalPosition = 12
	
Do While True
		
	MBWrite(pasInsertDepthAddr, inches2Modbus(HSProbeFinalPosition), MBType32) ' Send final weld depth
 	MBWrite(pasInsertEngageAddr, inches2Modbus(HSProbeFinalPosition - .65), MBType32) ' Set engagement
	
	Do Until pasMessageDB = 4
		On heatStakeGoH, 1 ' Tell the HS to install 1 insert
		Wait .5
	Loop
	
	Do Until pasMessageDB = 4
		Wait .1
	Loop
	
	HSProbeFinalPosition = HSProbeFinalPosition + .1
	
Loop
	
Fend

