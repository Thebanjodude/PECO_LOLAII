'#include "Globals.INC"
'
'Function main()
'	
'Integer NextState
'
'PowerOnSequence() ' Initialize the system and prepare it to do a job
''TestMB() ' fake for test
'
'OnErr GoTo errHandler ' Define where to go when a controller error occurs
'
'Do While True
'
'	MBWrite(&h012C, 150, MBType16)
'	MBWrite(&h012D, 145, MBType16)
''	Print "readback", pasSetTemp, pasSetTempZone2
''	
''	Print pasActualTempZone1
''	Print pasActualTempZone2
''	
''	Print "pasPIDsetupInTempZone1", pasPIDsetupInTempZone1
''	Print "pasPIDsetupInTempZone2", pasPIDsetupInTempZone2
'
'	Wait 1
'Loop
'
'mainCurrentState = StateIdle ' The first state is Idle
'jobStart = True 'fake
'
''FakeLogging() ' fake logged values for Scott
'
'Do While True
'		
'	Select mainCurrentState
'		
'	Case StateIdle
'		jobDone = False
'		If jobStart = True And HotStakeTempRdy = True Then
'			NextState = StatePopPanel
'		Else
'			NextState = StateIdle
'		EndIf
'	Case StatePopPanel
'		If PopPanel = True Then
'			NextState = StatePreinspection
'		Else
'			NextState = StateIdle
'		EndIf
'		
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
'	Case StatePushPanel
'		If PushPanel = True Then
'			NextState = StatePopPanel
'		ElseIf jobDone = True Then
'			Nextstate = StateIdle
'		EndIf
'
''	Case StateIdle
''		SetInitialValues() ' get rid of this during integration
''		If CheckInitialParameters() = True And HotStakeTempRdy() = True And jobStart = True Then
''			NextState = StatePopPanel
''		Else
''			NextState = StateIdle
''		EndIf
''	Case StatePopPanel
''		If PopPanel = True Then
''			NextState = StateFindPickUpError
''
''		ElseIf inMagIntlock = True Then
''			NextState = PopPanel
''		Else
''			NextState = StateIdle
''		EndIf
''	Case StateFindPickUpError
''		If FindPickUpError = True Then
''			DerivethetaR()
''			NextState = StatePreinspection
''		Else
''			NextState = StateIdle
''		EndIf
''	Case StatePreinspection
''			If InspectPanel(Preinspection) = True Then
''				NextState = StateHotStakePanel
''			Else
''				NextState = StateIdle
''			EndIf
''	Case StateHotStakePanel
''		If HotStakePanel = True Then
''			NextState = StateFlashRemoval
''		Else
''			NextState = StateIdle
''		EndIf
''	Case StateFlashRemoval
''		If FlashRemoval = True Then
''			NextState = StatePopPanel
''		Else
''			NextState = StateIdle
''		EndIf
''	Case StatePreinspection
''		If InspectPanel(Inspection) = True Then
''			NextState = StatePushPanel
''		Else
''			NextState = StateIdle
''		EndIf
''	Case StatePushPanel
''		If PushPanel = True Then
''			NextState = StatePopPanel
''		ElseIf inMagIntlock = True Then
''			NextState = PushPanel
''		Else
''			NextState = StateIdle
''		EndIf
''	Default
''		Print "Current State is Null" ' We should NEVER get here...
''		erUnknown = True
''		Pause
'	Send
'	
'	If jobAbort = True Then 'Check if the user has aborted the job
'		NextState = StateIdle
'		jobStart = False
'	EndIf
'	
'mainCurrentState = NextState 'Set next state to current state after we break from case statment
'
'Loop
'
'	errHandler:
'		
'		'Assign things of interest to var names
'		ctrlrErrMsg$ = ErrMsg$(Err)
'	 	ctrlrLineNumber = Erl
'		ctrlrTaskNumber = Ert
'	 	ctrlrErrAxisNumber = Era
'	 	ctrlrErrorNum = Err
'	 	
'	 	
'	 	' Print error for testing/troubleshooting
'	 	Print "Error Message:", ctrlrErrMsg$
'		Print "Error Line Number:", ctrlrLineNumber
'		Print "Error Task Number:", ctrlrTaskNumber
'		Print "Error AxisNumber:", ctrlrErrAxisNumber
'		Print "Error Number:", ctrlrErrorNum
'		Pause
'	EResume
'		
'Fend
'Function PowerOnSequence()
'	
'	' define the connection to the LASER
'    SetNet #203, "10.22.251.171", 7351, CR, NONE, 0
'    OpenNet #203 As Client
'
'	' Execute Tasks
'	Xqt 2, IOTableInputs, NoEmgAbort
'	Xqt 3, IOTableOutputs, NoEmgAbort
'	Xqt 4, SystemMonitor, NoEmgAbort
'	Xqt 5, iotransfer, NoEmgAbort
'	Xqt 6, HmiListen, NoEmgAbort
'	Xqt 7, InMagControl, Normal ' First state is lowering 
'	Xqt 8, OutMagControl, Normal ' First state is raising 
'	MBInitialize()
'retry:
'
'	If PowerOnHomeCheck() = False Then GoTo retry ' Don't let the robot move unless its near home
'	
'	Motor On
'	Power Low
'	Speed 20 'Paramterize these numbers
'	Accel 50, 50
'	QP (On) ' turn On quick pausing	
'	
''	Move PreScan :U(CU(CurPos)) ' go home
''	Move PreScan ROT ' go home
'
'	If CX(LaserCenter) = 0 Or CY(LaserCenter) = 0 Then
'		Print "calibration needed"
''		CalibrateLaserLocation()
'	EndIf
'	
'Fend
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
'Function HotStakeTempRdy() As Boolean
'	
'	Boolean probeInTemp, trackInTemp
'	
'	'Is the current temp within the tolerance to start or continue a job?
''	If Abs(recTempProbe - pasActualTempZone1) < Abs(probeTempTolerance) Then
''		probeInTemp = True
''	Else
''		probeInTemp = False
''	EndIf
''	
''	If Abs(recTempTrack - pasActualTempZone2) < Abs(trackTempTolerance) Then
''		trackInTemp = True
''	Else
''		trackInTemp = False
''	EndIf
'	
'	If probeInTemp = True And trackInTemp = True Then
'		HotStakeTempRdy = True ' ready to start job
'		erHeatStakeTemp = False
'	Else
'		HotStakeTempRdy = False ' Temperature is not in range
'		erHeatStakeTemp = True
'	EndIf
'	
'	HotStakeTempRdy = True ' fake for testing
'	
'Fend
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

