#include "Globals.INC"

Function main

PowerOnSequence() ' Initialize the system and prepare it to do a job

OnErr GoTo errHandler ' Define where to go when a controller error occurs

Do While True

	SystemStatus = Idle
	
	SetInitialValues()
	CheckInitialParameters() ' Has the hmi has given us all the parameters we need to do a job?
		
'	Print "jobStart ", jobStart
'	Wait 1

	' fake for testing
	jobStart = True
	RecEntryMissing = False
	ParamEntryMissing = False
	stackLightGrnCC = False
	
	Move scancenter3 :U(CU(CurPos))
	
	Go PickUp
			
	If jobStart = True And RecEntryMissing = False And ParamEntryMissing = False And jobDone = False And HotStakeTempRdy() = True Then
		Print "doing a job"
		
		PanelOffset = PanelOffset :X(0) :Y(0) :Z(0) :U(0)
		
'		PickUpPanel()
		
		stackLightGrnCC = True
'		Wait 1
'		PopPanel() ' Go to input magazine and pick up a panel
		FindPickUpError()
		DerivethetaR()
'		InspectPanel(Preinspection) 'Look for pre-existing inserts, set flags
		
'		DropOffPanel()
'		HotStakePanel() ' Take panel to hot stake machine; install all inserts
'		FlashRemoval() ' Take panel to flash removal station, remove all flash as required
		InspectPanel(Inspection) ' Take Panel to scanner 
'		PushPanel() ' Take Panel to output magazine and drop it off
'		Pause
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
		
		SystemPause()
	EResume
		
Fend
Function PowerOnSequence()
	
	retry:
'	If PowerOnHomeCheck() = False Then GoTo retry ' Don't let the robot move unless its near home
	
	Motor On
	Power Low
	Speed 20
	Accel 50, 50
	
	Print "ready"

	' define the connection to the LASER
    SetNet #203, "10.22.251.171", 7351, CR, NONE, 0
    OpenNet #203 As Client

	' Execute Tasks
	Xqt 2, IOTableInputs, NoEmgAbort
	Xqt 3, IOTableOutputs, Normal
	Xqt 4, SystemMonitor, NoEmgAbort
	Xqt 5, iotransfer, NoEmgAbort
	Xqt 6, HmiListen, NoEmgAbort
	Xqt 7, InMagControl, Normal ' First state is lowering 
	Xqt 8, OutMagControl, Normal ' First state is raising 
	
	' go ScanCenter LimZ zLimit ' Go home
	
Fend
Function SetInitialValues()
	' This is going to be OBS-the HMI will initialize the vars and I will check that
	'they get initialized
	SystemSpeed = 50
	AnvilZlimit = -150.00
	suckTime = .5
	SystemAccel = 30
	zLimit = -15
'	jobNumPanelsDone = 0
'	jobNumPanels = 0
Fend
Function CheckInitialParameters()
'check if the hmi has pushed all the recipe values to the controller, if not throw an error 	
'check if the hmi has pushed all the parameter values to the controller, if not throw an error 

	'add in check that panelarray is nonzero
	
	If recBossHeight = 0.0 Or recInsertDepth = 0.0 Then
		RecEntryMissing = True
	ElseIf recMajorDim = 0.0 Or recMinorDim = 0.0 Or recZDropOff = 0.0 Then
		RecEntryMissing = True
	ElseIf recInsertType = 0 Or recNumberOfHoles = 0 Then
		RecEntryMissing = True
	ElseIf recTemp = 0 Then
		RecEntryMissing = True
	Else
		RecEntryMissing = False
	EndIf
	
	If RecEntryMissing = True Then
		erRecEntryMissing = True
		stackLightYelCC = True
	Else
		erRecEntryMissing = False
		stackLightYelCC = False
	EndIf
	
'	Print "erRecEntryMissing", erRecEntryMissing

	If AnvilZlimit = 0.0 Or suckTime = 0.0 Then
		ParamEntryMissing = True
	ElseIf SystemSpeed = 0 Or SystemAccel = 0 Then
		ParamEntryMissing = True
	Else
		ParamEntryMissing = False
	EndIf
	
	If ParamEntryMissing = True Then
		erParamEntryMissing = True
		stackLightYelCC = True
		stackLightAlrmCC = True
	Else
		erParamEntryMissing = False
		stackLightYelCC = False
		stackLightAlrmCC = False
	EndIf

Fend
Function HotStakeTempRdy() As Boolean
	
	' Make 5% an adjustable parameter via the hmi l8r
	
	'Is the current temp within the tolerance to start a job?
	If Abs(recTemp - heatStakeCurrentTemp) < Abs(heatStakeTempTolerance) Then
		HotStakeTempRdy = True
		erHeatStakeTemp = False
		stackLightYelCC = False
	Else
		HotStakeTempRdy = False ' Temperature is not in range
		erHeatStakeTemp = True
		stackLightYelCC = True
		stackLightAlrmCC = True ' Do we want to siren on when its heating up? Doesnt make sense...
	EndIf
	
	HotStakeTempRdy = True ' fake for testing

Fend
Function PowerOnHomeCheck() As Boolean
	
'TODO:check for leftyness and rightness!!
	
	Real distx, disty, distz, distance
	#define startUpDistMax 150 '+/-300mm from home position
	#define startUpHeight 25 ' +/-10mm from home position
	
	distx = Abs(CX(CurPos) - CX(Scancenter3))
	disty = Abs(CY(CurPos) - CY(Scancenter3))
	distz = Abs(CZ(CurPos) - CZ(Scancenter3))
	Print "x", distx
	Print "y", disty
	Print "z", distz
	
	distance = Sqr(distx * distx + disty * disty) ' How the hell do you square numbers?
'	Print "distance", distance

	If distance > startUpDistMax Then
		erRobotNotAtHome = True
		PowerOnHomeCheck = False
		Print "Distance NOT OK,distance"
	ElseIf Abs(distz) > startUpHeight Then
		erRobotNotAtHome = True
		PowerOnHomeCheck = False
		Print "Distance NOT OK,z"
	Else
		erRobotNotAtHome = False
		PowerOnHomeCheck = True
		Print "Distance OK"
	EndIf
	
	If PowerOnHomeCheck = False Then
		Motor On
		SFree 1, 2, 3, 4
		Print "move robot to home position"
'		Do Until UserAck = True
'			Wait .1
'		Loop
	Pause
	EndIf
		
Fend


