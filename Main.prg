#include "Globals.INC"

Function main

PowerOnSequence()

OnErr GoTo errHandler ' Define where to go when a controller error occurs

Do While True

	SystemStatus = Idle
	
	CheckInitialValues()
	CheckRecipeInitialization()
	
Do While False
	If jobStart = True And RecEntryMissing = False Then
		Print "doing a job"
		Wait 1
'		PopPanel() ' Go to input magazine and pick up a panel
'		PreInspection() ' Take panel to scanner; compare recipe data and populate PanelArray with r's and theta's
'		HotStakePanel() ' Take panel to hot stake machine; install all inserts
'		FlashRemoval() ' Take panel to flash removal station, remove all flash as required
'		Inspection() ' Take Panel to scanner returns pass/fail
'		PushPanel() ' Take Panel to output magazine and drop it off
'		Pause
	EndIf
Loop
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
	
	SetInitialValues()
	CheckInitialValues()
	
	Motor On
	Power High
	Speed 50
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
	Xqt 7, OutMagControl, Normal ' First state is raising \
	
	' Define interupts
'	Trap 2 MemSw(MagTorqueLimF) Call MagTorqueErrorISR
	
	Jump ScanCenter LimZ Zlimit ' Go home
	
Fend
Function SetInitialValues
	' This is going to be OBS-the HMI will initialize the vars and I will check that
	'they get initialized
	SystemSpeed = 50
	AnvilZlimit = -150.00
Fend
Function CheckInitialValues()
	
	Print "AnvilZlimit:", AnvilZlimit
	Print "SystemSpeed:", SystemSpeed

	If AnvilZlimit = 0.0 Then
		ParamEntryMissing = True
	ElseIf SystemSpeed = 0 Then
		ParamEntryMissing = True
	Else
		ParamEntryMissing = False
	EndIf
	
	If ParamEntryMissing = True Then
		erParamEntryMissing = True
	Else
		erParamEntryMissing = False
	EndIf
	
	Print "erParamEntryMissing", erParamEntryMissing
	Wait .5
	
Fend
Function CheckRecipeInitialization()
	
	Print "recBossHeight:", recBossHeight
	Print "recInsertDepth:", recInsertDepth
	Print "recMajorDim:", recMajorDim
	Print "recMinorDim:", recMinorDim
	Print "recZDropOff:", recZDropOff
	Print "recInsertType:", recInsertType
	Print "recNumberOfHoles:", recNumberOfHoles
	
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
	
	Print "erRecEntryMissing", erRecEntryMissing
	Wait .5

Fend

	


