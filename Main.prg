#include "Globals.INC"

Function main

PowerOnSequence() ' Initialize the system and prepare it to do a job

OnErr GoTo errHandler ' Define where to go when a controller error occurs

Do While True

	SystemStatus = Idle
	
	SetInitialValues()
	CheckInitialValues() ' Has the hmi has given us all the parameters we need to do a job?
	CheckRecipeInitialization()
	
'	Print "jobStart ", jobStart
'	Wait 1

	jobStart = True
	RecEntryMissing = False
	ParamEntryMissing = False

	If jobStart = True And RecEntryMissing = False And ParamEntryMissing = False And jobDone = False Then
		Print "doing a job"
'		Wait 1
'		PopPanel() ' Go to input magazine and pick up a panel
'		FindPickUpError()
		InspectPanel(True) 'Look for pre-existing inserts, set flags 
'		HotStakePanel() ' Take panel to hot stake machine; install all inserts
'		FlashRemoval() ' Take panel to flash removal station, remove all flash as required
'		InspectPanel(true) ' Take Panel to scanner 
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
	
	Motor On
	Power High
	Speed 20
	Accel 50, 50

	' define the connection to the LASER
    SetNet #203, "10.22.251.171", 7351, CR, NONE, 0
    OpenNet #203 As Client

	' Execute Tasks
	Xqt 2, IOTable, NoEmgAbort
	Xqt 3, SystemMonitor, NoEmgAbort
	Xqt 4, iotransfer, NoEmgAbort
	Xqt 5, HmiListen, NoEmgAbort
	Xqt 6, InMagControl, Normal ' First state is lowering 
	Xqt 7, OutMagControl, Normal ' First state is raising 
	
	' Jump ScanCenter LimZ zLimit ' Go home
	
Fend
Function SetInitialValues()
	' This is going to be OBS-the HMI will initialize the vars and I will check that
	'they get initialized
	SystemSpeed = 50
	AnvilZlimit = -150.00
	suckTime = .5
	SystemAccel = 30
	zLimit = -85
'	jobNumPanelsDone = 0
'	jobNumPanels = 0
Fend
Function CheckInitialValues()
'check if the hmi has pushed all the parameter values to the controller, if not throw an error 
	
'	Print "AnvilZlimit:", AnvilZlimit
'	Print "SystemSpeed:", SystemSpeed

	If AnvilZlimit = 0.0 Or suckTime = 0.0 Then
		ParamEntryMissing = True
	ElseIf SystemSpeed = 0 Or SystemAccel = 0 Then
		ParamEntryMissing = True
	Else
		ParamEntryMissing = False
	EndIf
	
	If ParamEntryMissing = True Then
		erParamEntryMissing = True
	Else
		erParamEntryMissing = False
	EndIf
	
'	Print "erParamEntryMissing", erParamEntryMissing
	
Fend
Function CheckRecipeInitialization()
'check if the hmi has pushed all the recipe values to the controller, if not throw an error 	
	
'	Print "recBossHeight:", recBossHeight
'	Print "recInsertDepth:", recInsertDepth
'	Print "recMajorDim:", recMajorDim
'	Print "recMinorDim:", recMinorDim
'	Print "recZDropOff:", recZDropOff
'	Print "recInsertType:", recInsertType
'	Print "recNumberOfHoles:", recNumberOfHoles

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
	Else
		erRecEntryMissing = False
	EndIf
	
'	Print "erRecEntryMissing", erRecEntryMissing
	Wait .5

Fend

	


