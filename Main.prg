#include "Globals.INC"

Function main()
OnErr GoTo errHandler ' Define where to go when a controller error occurs	

On suctionCupsH ' fake

'jobStart = True 'fake
recSuctionWaitTime = 1 'fake
zLimit = -12.5 'fake
SystemSpeed = 25
SystemAccel = 35
'recFlashDwellTime = 0
insertDepthTolerance = .010
recFlashRequired = False
recPointsTable = 1

PowerOnSequence() ' Initialize the system and prepare it to do a job

jobDone = False ' reset flag
jobStart = False ' reset flag


'TeachPointsUnderLaser()
'Quit All

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
		
		If jobStart = True Then 'And HotStakeTempRdy = 0 Then ' Fake for testing'
		
			If CheckInitialParameters() = 0 Then
				mainCurrentState = StatePopPanel
				'mainCurrentState = StatePreinspection
				'mainCurrentState = StateHotStakePanel
				'mainCurrentState = StateFlashRemoval
				'mainCurrentState = StateCrowding
				ChoosePointsTable()
				Do Until pasMessageDB = 2 ' wait for the HS to get home before we move (this wastes a lot of time)
					MBWrite(pasGoHomeAddr, 1, MBTypeCoil) ' Home the heat stake machine by toggling
					Wait 1
					MBWrite(pasGoHomeAddr, 0, MBTypeCoil)
					Do While pasMessageDB = 9
						'waiting for the heat stake to finish homeing
						Wait .5
					Loop
				Loop
				jobAbort = False 'reset flag
				jobNumPanelsDone = 0 ' reset panel counter
				panelDataTxRdy = False ' make sure var is set to false so it changes when we want HMI to read out data
				Redim PassFailArray(23, 1) ' Clear array, always 23 rows
				Redim InspectionArray(23, 1) 'Clear array, always 23 rows
			ElseIf pasEmptyBowlFeederandTrack = True Then
				TmReset (3) ' reset timer 3 before we switch states
				mainCurrentState = StateEmptyingBowlandTrack
			Else
				mainCurrentState = StateIdle ' Stay in idle until ready
			EndIf
		EndIf
		
	Case StatePopPanel
	' This state picks up a panel from the input magazine. Then takes the panel to the home	
	' position. 
	
		ChoosePointsTable() ' Load points table that panel is programed under
	
		StatusCheckPickUp = PickupPanel(0) ' Call the function that picks up a panel
				
		If StatusCheckPickUp = 0 Then ' Panel was picked up successfully
			mainCurrentState = StateCrowding
			'mainCurrentState = StatePushPanel ' fake for testing
			'mainCurrentState = StateHotStakePanel
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
'			mainCurrentState = StatePreinspection
'			mainCurrentState = StateInspection
'			mainCurrentState = StateHotStakePanel
'			mainCurrentState = StateFlashRemoval
			mainCurrentState = StatePushPanel
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
		
	Case StateEmptyingBowlandTrack
			' The button on the HMI should be greyed out if the state is not in idle
			' Setting this register in the PLC initiates a sequence that empties the bowl feeder and track
			' MBWrite(pasEmptyBowlFeederandTrackAddr, 1, MBType16) 
			
			If pasEmptyingSequenceDone = True Or Tmr(3) >= 600 Then
				mainCurrentState = StateIdle ' go back to idle because we are finished
			Else
				mainCurrentState = StateEmptyingBowlandTrack
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
	
	retry:

	If PowerOnHomeCheck() = False Then GoTo retry ' Don't let the robot move unless its near home
	
	Motor On
	Power High
	
	Speed SystemSpeed
	Accel SystemAccel, SystemAccel 'Paramterize these numbers
	QP (On) ' turn On quick pausing	
	
'	Move PreScan :U(CU(CurPos)) ' go home
'	Move PreScan ROT ' go home
	
Fend
Function CheckInitialParameters() As Integer
'check if the hmi has pushed all the recipe values to the controller, if not throw an error 	
'check if the hmi has pushed all the parameter values to the controller, if not throw an error 

	If recBossCrossArea = 0 Then 'recNumberOfHoles = 0 Or recInsertType = 0 Or
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print " recBossCrossArea = 0" 'recNumberOfHoles = 0 Or recInsertType = 0 Or
	ElseIf recInmag = 0 Or recOutmag = 0 Or recCrowding = 0 Or recPreCrowding = 0 Then
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print "recInmag = 0 Or recOutmag = 0 Or recCrowding = 0 Or recPreCrowding = "
	ElseIf recFirstHolePointInspection = 0 Or recLastHolePointInspection = 0 Or recFirstHolePointHotStake = 0 Or recLastHolePointHotStake = 0 Or recFirstHolePointFlash = 0 Or recLastHolePointFlash = 0 Then
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print "recFirstHolePointInspection = 0 Or recLastHolePointInspection = 0 Or recFirstHolePointHotStake = 0 Or recLastHolePointHotStake = 0 Or recFirstHolePointFlash = 0 Or recLastHolePointFlash = 0"
	ElseIf recPointsTable > 3 Or recPointsTable = 0 Then
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print "0 < recPointsTable < 3"
	ElseIf recSuctionWaitTime = 0 Or SystemSpeed = 0 Or SystemAccel = 0 Or zLimit = 0 Then
		CheckInitialParameters = 2
		erParamEntryMissing = True
		Print "recSuctionWaitTime = 0 Or SystemSpeed = 0 Or SystemAccel = 0 Or zLimit = 0"
	Else
		CheckInitialParameters = 0
		erRecEntryMissing = False
		erParamEntryMissing = False
	EndIf

Fend
Function HotStakeTempRdy() As Boolean
	
	If pasOTAOnOffZone1 = True And pasOTAOnOffZone2 = True Then
		HotStakeTempRdy = True ' ready to start job
	Else
		HotStakeTempRdy = False ' Temperature is not in range
	EndIf
	
Fend
Function PowerOnHomeCheck() As Boolean
	
	Real distx, disty, distz, distance
' TODO: Parameterize these #defines?
	#define startUpDistMax 150 '+/-150mm from home position
	
	distx = Abs(CX(CurPos) - CX(PreScan))
	disty = Abs(CY(CurPos) - CY(PreScan))
	
	distance = Sqr(distx * distx + disty * disty) ' How the hell do you square numbers?
	
	Print "distance away from home: ", distance

	If distance > startUpDistMax Or Hand(Here) = 1 Then  'Check is the position is close to home. If not throw error
		erRobotNotAtHome = True
		PowerOnHomeCheck = False
		Print "Distance NOT OK Or Arm Orientation NOT OK"
	Else
		erRobotNotAtHome = False
		PowerOnHomeCheck = True
		Print "Distance OK and Arm Orientation OK"
	EndIf
	
	'	Print Hand(Here)
	
	If PowerOnHomeCheck = False Then ' When false, free all the joints so opperator can move
		Motor On
		SFree 1, 2, 3, 4
		Print "move robot to home position"
		Pause
	EndIf
		
Fend
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
Function ChoosePointsTable()
	' Choose which points table to load

	If recPointsTable = 1 Then
		LoadPoints "points.pts"
	ElseIf recPointsTable = 2 Then
		LoadPoints "points2.pts"
	ElseIf recPointsTable = 3 Then
		LoadPoints "points3.pts"
	Else
		erUnknown = True
		Print "point Table is Unknown"
	EndIf
Fend
Function SavePointsTable()
	' Choose which points table to save

	If recPointsTable = 1 Then
		SavePoints "points.pts"
	ElseIf recPointsTable = 2 Then
		SavePoints "points2.pts"
	ElseIf recPointsTable = 3 Then
		SavePoints "points3.pts"
	Else
		erUnknown = True
		Print "point Table is Unknown"
	EndIf
Fend
Function TeachPointsUnderLaser()
' This function will only work in the operator aligns the hole with minimal error in all 3 axis's
On suctionCupsH
suctionCupsCC = True
Pause

' all tolerances are +/- mm
#define Xtolerance .5
#define Ytolerance .5
#define Ztolerance 5

Real XLaserError, XLaserTolerance
Real YLaserError, YLaserTolerance
Real ZLaserError, ZLaserTolerance
Real tempY1, tempY2
Integer i

recFirstHolePointInspection = 6
recLastHolePointInspection = 6
recPointsTable = 3

Motor On
Power Low

ChoosePointsTable() ' load correct points table
ChangeProfile("00") ' Change profile on the laser

For i = recFirstHolePointInspection To recLastHolePointInspection
' add checks for laser out of range (-9999's)

	SFree 1, 2, 3, 4 ' unlock motors, allows operator to roughly place hole
	Pause ' wait for operator to continue
	SLock 1, 2, 3, 4 ' lock motors
	
redoZ:
	ZLaserError = GetLaserMeasurement("06")
	Print "ZLaserError: ", ZLaserError
	If ZLaserError = -999.999 Then
		Print "Laser Z not in range, please adjust"
		SFree 1, 2, 3, 4 ' unlock motors, allows operator to roughly place hole
		Pause ' wait for operator to continue
		GoTo redoZ
	EndIf
	
	If Abs(ZLaserError) > ZLaserTolerance Then
	
'	Do While Abs(ZLaserError) > ZLaserTolerance
		JTran 3, -1 * ZLaserError
		Wait .25
		ZLaserError = GetLaserMeasurement("06")
		Print "ZLaserError: ", ZLaserError
'	Loop
	EndIf
	
	Print "Z is done"
	P(i) = Here ' save the point 
	
redoY:
	YLaserError = GetLaserMeasurement("05")
	Print "YLaserError: ", YLaserError
	If YLaserError = -999.999 Then
		Print "Laser Y not in range, please adjust"
		SFree 1, 2, 3, 4 ' unlock motors, allows operator to roughly place hole
		Pause ' wait for operator to continue
		GoTo redoY
	EndIf
	
' the problem with this is that I can't determine which way to correct (becuase it's a circle).	
' the problem with this method is if we cross the diameter with our .1mm move	

	tempY1 = GetLaserMeasurement("05")
	Print "tempY1", tempY1
	Move P(i) +Y(0.1) ' move a little to see if we are 
	tempY2 = GetLaserMeasurement("05")
	Print "tempY2", tempY2
	
	YLaserError = GetLaserMeasurement("05")
	If Abs(YLaserError) > YLaserTolerance Then
	
'	Do While Abs(YLaserError) > YLaserTolerance
		If tempY1 < tempY2 Then
			Move P(i) +Y(-1 * YLaserError)
		Else
			Move P(i) +Y(YLaserError)
		EndIf
'	Loop
	EndIf
	
	Wait .25
	YLaserError = GetLaserMeasurement("05")
	Print "YLaserError: ", YLaserError
	
	Print "Y is done"
	P(i) = Here ' save the point 
	
redoX:
	XLaserError = GetLaserMeasurement("07")
	Print "XLaserError: ", XLaserError
	If XLaserError = -999.999 Then
		Print "Laser X not in range, please adjust"
		SFree 1, 2, 3, 4 ' unlock motors, allows operator to roughly place hole
		Pause ' wait for operator to continue
		GoTo redoX
	EndIf
	
	If Abs(XLaserError) > XLaserTolerance Then
'	Do While Abs(XLaserError) < XLaserTolerance
		Move P(i) +X(-1 * XLaserError / 2)
		Wait .25
		XLaserError = GetLaserMeasurement("07")
		Print "XLaserError: ", XLaserError
'	Loop
	EndIf
	
	Print "X is done"
	P(i) = Here ' save the point 
	
Next

	SFree 1, 2, 3, 4
	SavePointsTable() ' save the points table
Fend

