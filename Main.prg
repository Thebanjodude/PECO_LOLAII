#include "Globals.INC"

Function main

SetInitialValues()
PowerOnSequence()
CheckInitialValues()
OnErr GoTo errHandler ' Define where to go when a controller error occurs

Do While True

	SystemStatus = Idle
	
	If robStart = True Then
		Print "doing a job"
		Wait 1
		PopPanel() ' Go to input magazine and pick up a panel
'		PreInspection() ' Take panel to scanner; compare recipe data and populate PanelArray with r's and theta's
		HotStakePanel() ' Take panel to hot stake machine; install all inserts
		FlashRemoval() ' Take panel to flash removal station, remove all flash as required
'		Inspection() ' Take Panel to scanner returns pass/fail
		PushPanel() ' Take Panel to output magazine and drop it off
		Pause
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
	Xqt 7, OutMagControl, Normal ' First state is raising 
	
	' Define interupts
'	Trap 2 MemSw(MagTorqueLimF) Call MagTorqueErrorISR
	
	Jump ScanCenter LimZ Zlimit ' Go home
	
Fend
Function SetInitialValues
	' This is going to be OBS-the HMI will initialize the vars and I will check that
	'they get initialized
'	SystemSpeed = 50
	AnvilZlimit = -150.00
Fend
Function CheckInitialValues()
	'this is where I will check to make sure all the parameters are initialized
	'if not then throw an error
Fend


