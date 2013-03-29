#include "Globals.INC"

Function IOTable ' This is just a sample IOTable, it needs to be populated with Actual DIO 

'Xqt IntComTest ' This just toggles bits and increments integers to test the HMI Comms
OnErr GoTo errHandler ' Define where to go when a controller error occurs
Do While True
	
'Inputs
airPressHigh = IOTableBooleans(Sw(AirPressHighH), MemSw(airPressHighFV), MemSw(airPressHighF))
airPressLow = IOTableBooleans(Sw(AirPressLowH), MemSw(airPressLowFV), MemSw(airPressLowF))
cbMonBowlFeder = IOTableBooleans(Sw(cbMonBowlFederH), MemSw(cbMonBowlFederFV), MemSw(cbMonBowlFederF))
cbMonDebrisRmv = IOTableBooleans(Sw(cbMonDebrisRmvH), MemSw(cbMonDebrisRmvFV), MemSw(cbMonDebrisRmvF))
cbMonFlashRmv = IOTableBooleans(Sw(cbMonFlashRmvH), MemSw(cbMonFlashRmvFV), MemSw(cbMonFlashRmvF))
cbMonHeatStake = IOTableBooleans(Sw(cbMonHeatStakeH), MemSw(cbMonHeatStakeFV), MemSw(cbMonHeatStakeF))
cbMonInMag = IOTableBooleans(Sw(cbMonInMagH), MemSw(cbMonInMagFV), MemSw(cbMonInMagF))
cbMonOutMag = IOTableBooleans(Sw(cbMonOutMagH), MemSw(cbMonOutMagFV), MemSw(cbMonOutMagF))
cbMonPAS24vdc = IOTableBooleans(Sw(cbMonPAS24vdcH), MemSw(cbMonPAS24vdcFV), MemSw(cbMonPAS24vdcF))
cbMonPnumatic = IOTableBooleans(Sw(cbMonPnumaticH), MemSw(cbMonPnumaticFV), MemSw(cbMonPnumaticF))
cbMonSafety = IOTableBooleans(Sw(cbMonSafetyH), MemSw(cbMonSafetyFV), MemSw(cbMonSafetyF))
dcPwrOk = IOTableBooleans(Sw(dcPwrOkH), MemSw(dcPwrOkFV), MemSw(dcPwrOkF))
flashPnlPrsnt = IOTableBooleans(Sw(FlashPnlPrsntH), MemSw(FlashPnlPrsntFV), MemSw(FlashPnlPrsntF))
frontInterlock = IOTableBooleans(Sw(frontInterlockH), MemSw(frontInterlockFV), MemSw(frontInterlockF))
hsPanelPresnt = IOTableBooleans(Sw(HSPanelPresntH), MemSw(hsPanelPresntFV), MemSw(hsPanelPresntF))
inMagInterlock = IOTableBooleans(Sw(inMagInterlockH), MemSw(inMagInterlockFV), MemSw(inMagInterlockF))
inMagLowerLim = IOTableBooleans(Sw(inMagLowerLimH), MemSw(inMagLowerLimFV), MemSw(inMagLowerLimF))
inMagPnlRdy = IOTableBooleans(Sw(inMagPnlRdyH), MemSw(inMagPnlRdyFV), MemSw(inMagPnlRdyF))
inMagUpperLim = IOTableBooleans(Sw(inMagUpperLimH), MemSw(inMagUpperLimFV), MemSw(inMagUpperLimF))
leftInterlock = IOTableBooleans(Sw(leftInterlockH), MemSw(leftInterlockFV), MemSw(leftInterlockF))
outMagInt = IOTableBooleans(Sw(outMagIntH), MemSw(outMagIntFV), MemSw(outMagIntF))
outMagLowerLim = IOTableBooleans(Sw(outMagLowerLimH), MemSw(outMagLowerLimFV), MemSw(outMagLowerLimF))
outMagPanelRdy = IOTableBooleans(Sw(outMagPanelRdyH), MemSw(outMagPanelRdyFV), MemSw(outMagPanelRdyF))
outMagUpperLim = IOTableBooleans(Sw(outMagUpperLimH), MemSw(outMagUpperLimFV), MemSw(outMagUpperLimF))
rightInterlock = IOTableBooleans(Sw(rightInterlockH), MemSw(rightInterlockFV), MemSw(rightInterlockF))

'Outputs
debrisMtr = IOTableBooleans(debrisMtrCC, MemSw(debrisMtrFV), MemSw(debrisMtrF))
If debrisMtr = True Then
        On (debrisMtrH)
    Else
        Off (debrisMtrH)
    EndIf
flashCyc = IOTableBooleans(flashCycCC, MemSw(flashCycFV), MemSw(flashCycF))
If flashCyc = True Then
        On (flashCycH)
    Else
        Off (flashCycH)
    EndIf
flashMtr = IOTableBooleans(flashMtrCC, MemSw(flashMtrFV), MemSw(flashMtrF))
If flashMtr = True Then
        On (flashMtrH)
    Else
        Off (flashMtrH)
    EndIf
inMagMtr = IOTableBooleans(inMagMtrCC, MemSw(inMagMtrFV), MemSw(inMagMtrF))
If inMagMtr = True Then
        On (inMagMtrH)
    Else
        Off (inMagMtrH)
    EndIf
inMagMtrDir = IOTableBooleans(inMagMtrDirCC, MemSw(inMagMtrDirFV), MemSw(inMagMtrDirF))
If inMagMtrDir = True Then
        On (inMagMtrDirH)
    Else
        Off (inMagMtrDirH)
    EndIf
outMagMtr = IOTableBooleans(outMagMtrCC, MemSw(outMagMtrFV), MemSw(outMagMtrF))
If outMagMtr = True Then
        On (outMagMtrH)
    Else
        Off (outMagMtrH)
    EndIf
outMagMtrDir = IOTableBooleans(outMagMtrDirCC, MemSw(outMagMtrDirFV), MemSw(outMagMtrDirF))
If outMagMtrDir = True Then
        On (outMagMtrDirH)
    Else
        Off (outMagMtrDirH)
    EndIf
stackLightAlrm = IOTableBooleans(stackLightAlrmCC, MemSw(stackLightAlrmFV), MemSw(stackLightAlrmF))
If stackLightAlrm = True Then
        On (stackLightAlrmH)
    Else
        Off (stackLightAlrmH)
    EndIf
stackLightGrn = IOTableBooleans(stackLightGrnCC, MemSw(stackLightGrnFV), MemSw(stackLightGrnF))
If stackLightGrn = True Then
        On (stackLightGrnH)
    Else
        Off (stackLightGrnH)
    EndIf
stackLightRed = IOTableBooleans(stackLightRedCC, MemSw(stackLightRedFV), MemSw(stackLightRedF))
If stackLightRed = True Then
        On (stackLightRedH)
    Else
        Off (stackLightRedH)
    EndIf
stackLightYel = IOTableBooleans(stackLightYelCC, MemSw(stackLightYelFV), MemSw(stackLightYelF))
If stackLightYel = True Then
        On (stackLightYelH)
    Else
        Off (stackLightYelH)
    EndIf
suctionCups = IOTableBooleans(suctionCupsCC, MemSw(suctionCupsFV), MemSw(suctionCupsF))
If suctionCups = True Then
        On (suctionCupsH)
    Else
        Off (suctionCupsH)
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
Function IOTableBooleans(CtrlCodeValue As Boolean, HMIForceValue As Boolean, HMIForceFlag As Boolean) As Boolean
		
	Boolean Value
	Value = CtrlCodeValue 'Set value to what the control code wants it to be
	
	If HMIForceFlag = True Then ' Check If we want to force it 
		Value = HMIForceValue ' Take forced value from HMI, overwrite control code
	EndIf
	
	IOTableBooleans = Value ' Return Value
	
Fend
Function IOTableIntegers(CtrlCodeValue As Integer, HMIForceValue As Integer, HMIForceFlag As Boolean) As Integer
	
	Integer Value
	Value = CtrlCodeValue
	
	If HMIForceFlag = True Then ' Check If we want to force it 
		Value = HMIForceValue ' Take forced value from HMI, overwrite control code
	EndIf
	
	IOTableIntegers = Value ' Return Value
	
Fend
Function IOTableReals(CtrlCodeValue As Real, HMIForceValue As Real, HMIForceFlag As Boolean) As Real
	
	Integer Value
	Value = CtrlCodeValue
	
	If HMIForceFlag = True Then ' Check If we want to force it 
		Value = HMIForceValue ' Take forced value from HMI, overwrite control code
	EndIf
	
	IOTableReals = Value ' Return Value
	
Fend
Function iotransfer()
' This task runs continuously in the background updating variables between the controller and HMI
' write and read variables to HMI
                
    Integer i, j
    String response$
    String outstring$
    
    ' define the connection to the HMI
'    SetNet #201, "10.22.2.30", 1502, CRLF, NONE, 0
    SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0

    Do While True 'g_io_xfr_on = 1
   	OnErr GoTo RetryConnection ' on any error retry connection
  
RetryConnection:
      	Wait 1.0 'send I/O once per second
        If ChkNet(201) < 0 Then ' If port is not open
        	Off (HMI_connected), Forced ' initialize to off
            OpenNet #201 As Client
            Print "Attempted Open TCP port to HMI"
        Else
            On (HMI_connected), Forced 'indicate HMI is connected
            ' write variable data to HMI
'            Write #201, Chr$(12) 'this breaks the JSON interpreter

heartBeat = Not heartBeat
'Tx to HMI:
Print #201, "{", Chr$(&H22) + "backInterlockACK" + Chr$(&H22), ":", Str$(backInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "frontInterlockACK" + Chr$(&H22), ":", Str$(frontInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "inMagGoHome" + Chr$(&H22), ":", Str$(inMagGoHome), "}",
Print #201, "{", Chr$(&H22) + "inMagIntLockAck" + Chr$(&H22), ":", Str$(inMagIntLockAck), "}",
Print #201, "{", Chr$(&H22) + "inMagLoaded" + Chr$(&H22), ":", Str$(inMagLoaded), "}",
Print #201, "{", Chr$(&H22) + "jobPause" + Chr$(&H22), ":", Str$(jobPause), "}",
Print #201, "{", Chr$(&H22) + "jobResume" + Chr$(&H22), ":", Str$(jobResume), "}",
Print #201, "{", Chr$(&H22) + "jobStart" + Chr$(&H22), ":", Str$(jobStart), "}",
Print #201, "{", Chr$(&H22) + "jobStop" + Chr$(&H22), ":", Str$(jobStop), "}",
Print #201, "{", Chr$(&H22) + "leftInterlockACK" + Chr$(&H22), ":", Str$(leftInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "outMagGoHome" + Chr$(&H22), ":", Str$(outMagGoHome), "}",
Print #201, "{", Chr$(&H22) + "outMagIntLockAck" + Chr$(&H22), ":", Str$(outMagIntLockAck), "}",
Print #201, "{", Chr$(&H22) + "outMagUnloaded" + Chr$(&H22), ":", Str$(outMagUnloaded), "}",
Print #201, "{", Chr$(&H22) + "rightInterlockACK" + Chr$(&H22), ":", Str$(rightInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "sftyFrmIlockAck" + Chr$(&H22), ":", Str$(sftyFrmIlockAck), "}",
Print #201, "{", Chr$(&H22) + "erBackSafetyFrameOpen" + Chr$(&H22), ":", Str$(erBackSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erBowlFeederBreaker" + Chr$(&H22), ":", Str$(erBowlFeederBreaker), "}",
Print #201, "{", Chr$(&H22) + "erDCPower" + Chr$(&H22), ":", Str$(erDCPower), "}",
Print #201, "{", Chr$(&H22) + "erDCPowerHeatStake" + Chr$(&H22), ":", Str$(erDCPowerHeatStake), "}",
Print #201, "{", Chr$(&H22) + "erDebrisRemovalBreaker" + Chr$(&H22), ":", Str$(erDebrisRemovalBreaker), "}",
Print #201, "{", Chr$(&H22) + "erEstop" + Chr$(&H22), ":", Str$(erEstop), "}",
Print #201, "{", Chr$(&H22) + "erFlashBreaker" + Chr$(&H22), ":", Str$(erFlashBreaker), "}",
Print #201, "{", Chr$(&H22) + "erFrontSafetyFrameOpen" + Chr$(&H22), ":", Str$(erFrontSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erHeatStakeBreaker" + Chr$(&H22), ":", Str$(erHeatStakeBreaker), "}",
Print #201, "{", Chr$(&H22) + "erHighPressure" + Chr$(&H22), ":", Str$(erHighPressure), "}",
Print #201, "{", Chr$(&H22) + "erInMagBreaker" + Chr$(&H22), ":", Str$(erInMagBreaker), "}",
Print #201, "{", Chr$(&H22) + "erInMagCrowding" + Chr$(&H22), ":", Str$(erInMagCrowding), "}",
Print #201, "{", Chr$(&H22) + "erInMagEmpty" + Chr$(&H22), ":", Str$(erInMagEmpty), "}",
Print #201, "{", Chr$(&H22) + "erInMagOpenInterlock" + Chr$(&H22), ":", Str$(erInMagOpenInterlock), "}",
Print #201, "{", Chr$(&H22) + "erLaserScanner" + Chr$(&H22), ":", Str$(erLaserScanner), "}",
Print #201, "{", Chr$(&H22) + "erLeftSafetyFrameOpen" + Chr$(&H22), ":", Str$(erLeftSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erLowPressure" + Chr$(&H22), ":", Str$(erLowPressure), "}",
Print #201, "{", Chr$(&H22) + "erOutMagBreaker" + Chr$(&H22), ":", Str$(erOutMagBreaker), "}",
Print #201, "{", Chr$(&H22) + "erOutMagCrowding" + Chr$(&H22), ":", Str$(erOutMagCrowding), "}",
Print #201, "{", Chr$(&H22) + "erOutMagFull" + Chr$(&H22), ":", Str$(erOutMagFull), "}",
Print #201, "{", Chr$(&H22) + "erOutMagOpenInterlock" + Chr$(&H22), ":", Str$(erOutMagOpenInterlock), "}",
Print #201, "{", Chr$(&H22) + "erPanelFailedInspection" + Chr$(&H22), ":", Str$(erPanelFailedInspection), "}",
Print #201, "{", Chr$(&H22) + "erPanelStatusUnknown" + Chr$(&H22), ":", Str$(erPanelStatusUnknown), "}",
Print #201, "{", Chr$(&H22) + "erPnumaticsBreaker" + Chr$(&H22), ":", Str$(erPnumaticsBreaker), "}",
Print #201, "{", Chr$(&H22) + "erRC180" + Chr$(&H22), ":", Str$(erRC180), "}",
Print #201, "{", Chr$(&H22) + "erRightSafetyFrameOpen" + Chr$(&H22), ":", Str$(erRightSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erSafetySystemBreaker" + Chr$(&H22), ":", Str$(erSafetySystemBreaker), "}",
Print #201, "{", Chr$(&H22) + "erUnknown" + Chr$(&H22), ":", Str$(erUnknown), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanel" + Chr$(&H22), ":", Str$(erWrongPanel), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanelDims" + Chr$(&H22), ":", Str$(erWrongPanelDims), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanelHoles" + Chr$(&H22), ":", Str$(erWrongPanelHoles), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanelInsert" + Chr$(&H22), ":", Str$(erWrongPanelInsert), "}",
Print #201, "{", Chr$(&H22) + "erRecEntryMissing" + Chr$(&H22), ":", Str$(erRecEntryMissing), "}",
Print #201, "{", Chr$(&H22) + "erParamEntryMissing" + Chr$(&H22), ":", Str$(erParamEntryMissing), "}",
Print #201, "{", Chr$(&H22) + "airPressHigh" + Chr$(&H22), ":", Str$(airPressHigh), "}",
Print #201, "{", Chr$(&H22) + "airPressLow" + Chr$(&H22), ":", Str$(airPressLow), "}",
Print #201, "{", Chr$(&H22) + "cbMonBowlFeder" + Chr$(&H22), ":", Str$(cbMonBowlFeder), "}",
Print #201, "{", Chr$(&H22) + "cbMonDebrisRmv" + Chr$(&H22), ":", Str$(cbMonDebrisRmv), "}",
Print #201, "{", Chr$(&H22) + "cbMonFlashRmv" + Chr$(&H22), ":", Str$(cbMonFlashRmv), "}",
Print #201, "{", Chr$(&H22) + "cbMonHeatStake" + Chr$(&H22), ":", Str$(cbMonHeatStake), "}",
Print #201, "{", Chr$(&H22) + "cbMonInMag" + Chr$(&H22), ":", Str$(cbMonInMag), "}",
Print #201, "{", Chr$(&H22) + "cbMonOutMag" + Chr$(&H22), ":", Str$(cbMonOutMag), "}",
Print #201, "{", Chr$(&H22) + "cbMonPAS24vdc" + Chr$(&H22), ":", Str$(cbMonPAS24vdc), "}",
Print #201, "{", Chr$(&H22) + "cbMonPnumatic" + Chr$(&H22), ":", Str$(cbMonPnumatic), "}",
Print #201, "{", Chr$(&H22) + "cbMonSafety" + Chr$(&H22), ":", Str$(cbMonSafety), "}",
Print #201, "{", Chr$(&H22) + "dcPwrOk" + Chr$(&H22), ":", Str$(dcPwrOk), "}",
Print #201, "{", Chr$(&H22) + "flashPnlPrsnt" + Chr$(&H22), ":", Str$(FlashPnlPrsnt), "}",
Print #201, "{", Chr$(&H22) + "frontInterlock" + Chr$(&H22), ":", Str$(frontInterlock), "}",
Print #201, "{", Chr$(&H22) + "hsPanelPresnt" + Chr$(&H22), ":", Str$(hsPanelPresnt), "}",
Print #201, "{", Chr$(&H22) + "inMagInterlock" + Chr$(&H22), ":", Str$(inMagInterlock), "}",
Print #201, "{", Chr$(&H22) + "inMagLowerLim" + Chr$(&H22), ":", Str$(inMagLowerLim), "}",
Print #201, "{", Chr$(&H22) + "inMagPnlRdy" + Chr$(&H22), ":", Str$(inMagPnlRdy), "}",
Print #201, "{", Chr$(&H22) + "inMagUpperLim" + Chr$(&H22), ":", Str$(inMagUpperLim), "}",
Print #201, "{", Chr$(&H22) + "leftInterlock" + Chr$(&H22), ":", Str$(leftInterlock), "}",
Print #201, "{", Chr$(&H22) + "outMagInt" + Chr$(&H22), ":", Str$(outMagInt), "}",
Print #201, "{", Chr$(&H22) + "outMagLowerLim" + Chr$(&H22), ":", Str$(outMagLowerLim), "}",
Print #201, "{", Chr$(&H22) + "outMagPanelRdy" + Chr$(&H22), ":", Str$(outMagPanelRdy), "}",
Print #201, "{", Chr$(&H22) + "outMagUpperLim" + Chr$(&H22), ":", Str$(outMagUpperLim), "}",
Print #201, "{", Chr$(&H22) + "rightInterlock" + Chr$(&H22), ":", Str$(rightInterlock), "}",
Print #201, "{", Chr$(&H22) + "debrisMtr" + Chr$(&H22), ":", Str$(debrisMtr), "}",
Print #201, "{", Chr$(&H22) + "flashCyc" + Chr$(&H22), ":", Str$(flashCyc), "}",
Print #201, "{", Chr$(&H22) + "flashMtr" + Chr$(&H22), ":", Str$(flashMtr), "}",
Print #201, "{", Chr$(&H22) + "hsInstallInsrt" + Chr$(&H22), ":", Str$(hsInstallInsrt), "}",
Print #201, "{", Chr$(&H22) + "inMagMtr" + Chr$(&H22), ":", Str$(inMagMtr), "}",
Print #201, "{", Chr$(&H22) + "inMagMtrDir" + Chr$(&H22), ":", Str$(inMagMtrDir), "}",
Print #201, "{", Chr$(&H22) + "outMagMtr" + Chr$(&H22), ":", Str$(outMagMtr), "}",
Print #201, "{", Chr$(&H22) + "outMagMtrDir" + Chr$(&H22), ":", Str$(outMagMtrDir), "}",
Print #201, "{", Chr$(&H22) + "stackLightAlrm" + Chr$(&H22), ":", Str$(stackLightAlrm), "}",
Print #201, "{", Chr$(&H22) + "stackLightGrn" + Chr$(&H22), ":", Str$(stackLightGrn), "}",
Print #201, "{", Chr$(&H22) + "stackLightRed" + Chr$(&H22), ":", Str$(stackLightRed), "}",
Print #201, "{", Chr$(&H22) + "stackLightYel" + Chr$(&H22), ":", Str$(stackLightYel), "}",
Print #201, "{", Chr$(&H22) + "suctionCups" + Chr$(&H22), ":", Str$(suctionCups), "}",
Print #201, "{", Chr$(&H22) + "systemState" + Chr$(&H22), ":", Str$(SystemState), "}",
Print #201, "{", Chr$(&H22) + "ctrlrErrAxisNumber" + Chr$(&H22), ":", Str$(ctrlrErrAxisNumber), "}",
'Print #201, "{", Chr$(&H22) + "ctrlrErrMsg" + Chr$(&H22), ":", Str$(ctrlrErrMsg), "}",
Print #201, "{", Chr$(&H22) + "ctrlrErrorNum" + Chr$(&H22), ":", Str$(ctrlrErrorNum), "}",
Print #201, "{", Chr$(&H22) + "ctrlrLineNumber" + Chr$(&H22), ":", Str$(ctrlrLineNumber), "}",
Print #201, "{", Chr$(&H22) + "ctrlrTaskNumber" + Chr$(&H22), ":", Str$(ctrlrTaskNumber), "}",
Print #201, "{", Chr$(&H22) + "errorStatus" + Chr$(&H22), ":", Str$(errorStatus), "}",
Print #201, "{", Chr$(&H22) + "eStopStatus" + Chr$(&H22), ":", Str$(eStopStatus), "}",
Print #201, "{", Chr$(&H22) + "heartBeat" + Chr$(&H22), ":", Str$(heartBeat), "}",
Print #201, "{", Chr$(&H22) + "homePositionStatus" + Chr$(&H22), ":", Str$(homePositionStatus), "}",
Print #201, "{", Chr$(&H22) + "joint1Status" + Chr$(&H22), ":", Str$(joint1Status), "}",
Print #201, "{", Chr$(&H22) + "joint2Status" + Chr$(&H22), ":", Str$(joint2Status), "}",
Print #201, "{", Chr$(&H22) + "joint3Status" + Chr$(&H22), ":", Str$(joint3Status), "}",
Print #201, "{", Chr$(&H22) + "joint4Status" + Chr$(&H22), ":", Str$(joint4Status), "}",
Print #201, "{", Chr$(&H22) + "motorOnStatus" + Chr$(&H22), ":", Str$(motorOnStatus), "}",
Print #201, "{", Chr$(&H22) + "motorPowerStatus" + Chr$(&H22), ":", Str$(motorPowerStatus), "}",
Print #201, "{", Chr$(&H22) + "pauseStatus" + Chr$(&H22), ":", Str$(pauseStatus), "}",
Print #201, "{", Chr$(&H22) + "safeGuardInput" + Chr$(&H22), ":", Str$(safeGuardInput), "}",
Print #201, "{", Chr$(&H22) + "tasksRunningStatus" + Chr$(&H22), ":", Str$(tasksRunningStatus), "}",
Print #201, "{", Chr$(&H22) + "teachModeStatus" + Chr$(&H22), ":", Str$(teachModeStatus), "}",
Print #201, "{", Chr$(&H22) + "hsProbeTemp" + Chr$(&H22), ":", Str$(hsProbeTemp), "}",
Print #201, "{", Chr$(&H22) + "inMagCurrentState" + Chr$(&H22), ":", Str$(inMagCurrentState), "}",
Print #201, "{", Chr$(&H22) + "jobDone" + Chr$(&H22), ":", Str$(jobDone), "}",
Print #201, "{", Chr$(&H22) + "jobNumPanelsDone" + Chr$(&H22), ":", Str$(jobNumPanelsDone), "}",
Print #201, "{", Chr$(&H22) + "outMagCurrentState" + Chr$(&H22), ":", Str$(outMagCurrentState), "}",

'            	Print #201, "Laser Measurement = ", g_LaserMeasure
        EndIf
	Loop
Fend
' This task is used to query the laser measurement
Function LS_cmd()
                
    Integer i, j, NumTokens
    String Tokens$(0)
    String response$
    String outstring$

                
'   Do While g_io_xfr_on = 1
   Print "Entered LS_CMD"

        	Print "Trying Laser..."
        	Print #203, "MS,0,01"
        	Wait 1.0
            i = ChkNet(203)
            If i > 0 Then
            	Read #203, response$, i
            	numTokens = ParseStr(response$, tokens$(), ",")
'  				g_LaserMeasure = Val(Tokens$(1))
                Print "Measurement: ", response$
            EndIf
'	Loop
Fend
Function setVars(response$ As String)
    Integer i, j, numTokens
    String tokens$(0)
    String outstring$
    String match$
    String prepend$
    match$ = "{:} " + Chr$(&H22)
    
	numTokens = ParseStr(response$, tokens$(), match$)
	If numTokens <> 2 Then ' TODO for ben, something is running too fast
		Print "error---", response$, " -- ", numTokens
	EndIf
'	Print tokens$(0), " : ", tokens$(1)
	
	Select tokens$(0)
 'Rx from HMI:
 Case "backInterlockACKBtn"
   If tokens$(1) = "true" Then
       backInterlockACKBtn = True
       backInterlockACK = True
   Else
       backInterlockACKBtn = False
   EndIf
   Print "backInterlockACKBtn:", backInterlockACKBtn
Case "frontInterlockACKBtn"
   If tokens$(1) = "true" Then
       frontInterlockACKBtn = True
       frontInterlockACK = True
   Else
       frontInterlockACKBtn = False
   EndIf
   Print "frontInterlockACKBtn:", frontInterlockACKBtn
Case "inMagGoHomeBtn"
   If tokens$(1) = "true" Then
       inMagGoHomeBtn = True
       inMagGoHome = True
   Else
       inMagGoHomeBtn = False
   EndIf
   Print "inMagGoHomeBtn:", inMagGoHomeBtn
Case "inMagIntLockAckBtn"
   If tokens$(1) = "true" Then
       inMagIntLockAckBtn = True
       inMagIntLockAck = True
   Else
       inMagIntLockAckBtn = False
   EndIf
   Print "inMagIntLockAckBtn:", inMagIntLockAckBtn
Case "inMagLoadedBtn"
   If tokens$(1) = "true" Then
       inMagLoadedBtn = True
       inMagLoaded = True
   Else
       inMagLoadedBtn = False
   EndIf
   Print "inMagLoadedBtn:", inMagLoadedBtn
Case "jobPauseBtn"
   If tokens$(1) = "true" Then
       jobPauseBtn = True
       jobPause = True
       jobResume = False
   Else
       jobPauseBtn = False
   EndIf
   Print "jobPauseBtn:", jobPauseBtn
Case "jobResumeBtn"
   If tokens$(1) = "true" Then
       jobResumeBtn = True
       jobPause = False
       jobResume = True
       
   Else
       jobResumeBtn = False
   EndIf
   Print "jobResumeBtn:", jobResumeBtn
Case "jobStartBtn"
   If tokens$(1) = "true" Then
       jobStartBtn = True
       jobStart = True
   Else
       jobStartBtn = False
   EndIf
   Print "jobStartBtn:", jobStartBtn
Case "jobStopBtn"
   If tokens$(1) = "true" Then
       jobStopBtn = True
       jobStop = True
   Else
       jobStopBtn = False
   EndIf
   Print "jobStopBtn:", jobStopBtn
Case "leftInterlockACKBtn"
   If tokens$(1) = "true" Then
       leftInterlockACKBtn = True
       leftInterlockACK = True
   Else
       leftInterlockACKBtn = False
   EndIf
   Print "leftInterlockACKBtn:", leftInterlockACKBtn
Case "outMagGoHomeBtn"
   If tokens$(1) = "true" Then
       outMagGoHomeBtn = True
       outMagGoHome = True
   Else
       outMagGoHomeBtn = False
   EndIf
   Print "outMagGoHomeBtn:", outMagGoHomeBtn
Case "outMagIntLockAckBtn"
   If tokens$(1) = "true" Then
       outMagIntLockAckBtn = True
       outMagIntLockAck = True
   Else
       outMagIntLockAckBtn = False
   EndIf
   Print "outMagIntLockAckBtn:", outMagIntLockAckBtn
Case "outMagUnloadedBtn"
   If tokens$(1) = "true" Then
       outMagUnloadedBtn = True
       outMagUnloaded = True
   Else
       outMagUnloadedBtn = False
   EndIf
   Print "outMagUnloadedBtn:", outMagUnloadedBtn
Case "rightInterlockACKBtn"
   If tokens$(1) = "true" Then
       rightInterlockACKBtn = True
       rightInterlockACK = True
   Else
       rightInterlockACKBtn = False
   EndIf
   Print "rightInterlockACKBtn:", rightInterlockACKBtn
Case "sftyFrmIlockAckBtn"
   If tokens$(1) = "true" Then
       sftyFrmIlockAckBtn = True
       sftyFrmIlockAck = True
   Else
       sftyFrmIlockAckBtn = False
   EndIf
   Print "sftyFrmIlockAckBtn:", sftyFrmIlockAckBtn
Case "airPressHighF"
    If tokens$(1) = "true" Then
        MemOn (airPressHighF)
    Else
        MemOff (airPressHighF)
    EndIf
Case "airPressHighFV"
    If tokens$(1) = "true" Then
        MemOn (airPressHighFV)
    Else
        MemOff (airPressHighFV)
    EndIf
Case "airPressLowF"
    If tokens$(1) = "true" Then
        MemOn (airPressLowF)
    Else
        MemOff (airPressLowF)
    EndIf
Case "airPressLowFV"
    If tokens$(1) = "true" Then
        MemOn (airPressLowFV)
    Else
        MemOff (airPressLowFV)
    EndIf
Case "cbMonBowlFederF"
    If tokens$(1) = "true" Then
        MemOn (cbMonBowlFederF)
    Else
        MemOff (cbMonBowlFederF)
    EndIf
Case "cbMonBowlFederFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonBowlFederFV)
    Else
        MemOff (cbMonBowlFederFV)
    EndIf
Case "cbMonDebrisRmvF"
    If tokens$(1) = "true" Then
        MemOn (cbMonDebrisRmvF)
    Else
        MemOff (cbMonDebrisRmvF)
    EndIf
Case "cbMonDebrisRmvFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonDebrisRmvFV)
    Else
        MemOff (cbMonDebrisRmvFV)
    EndIf
Case "cbMonFlashRmvF"
    If tokens$(1) = "true" Then
        MemOn (cbMonFlashRmvF)
    Else
        MemOff (cbMonFlashRmvF)
    EndIf
Case "cbMonFlashRmvFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonFlashRmvFV)
    Else
        MemOff (cbMonFlashRmvFV)
    EndIf
Case "cbMonHeatStakeF"
    If tokens$(1) = "true" Then
        MemOn (cbMonHeatStakeF)
    Else
        MemOff (cbMonHeatStakeF)
    EndIf
Case "cbMonHeatStakeFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonHeatStakeFV)
    Else
        MemOff (cbMonHeatStakeFV)
    EndIf
Case "cbMonInMagF"
    If tokens$(1) = "true" Then
        MemOn (cbMonInMagF)
    Else
        MemOff (cbMonInMagF)
    EndIf
Case "cbMonInMagFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonInMagFV)
    Else
        MemOff (cbMonInMagFV)
    EndIf
Case "cbMonOutMagF"
    If tokens$(1) = "true" Then
        MemOn (cbMonOutMagF)
    Else
        MemOff (cbMonOutMagF)
    EndIf
Case "cbMonOutMagFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonOutMagFV)
    Else
        MemOff (cbMonOutMagFV)
    EndIf
Case "cbMonPAS24vdcF"
    If tokens$(1) = "true" Then
        MemOn (cbMonPAS24vdcF)
    Else
        MemOff (cbMonPAS24vdcF)
    EndIf
Case "cbMonPAS24vdcFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonPAS24vdcFV)
    Else
        MemOff (cbMonPAS24vdcFV)
    EndIf
Case "cbMonPnumaticF"
    If tokens$(1) = "true" Then
        MemOn (cbMonPnumaticF)
    Else
        MemOff (cbMonPnumaticF)
    EndIf
Case "cbMonPnumaticFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonPnumaticFV)
    Else
        MemOff (cbMonPnumaticFV)
    EndIf
Case "cbMonSafetyF"
    If tokens$(1) = "true" Then
        MemOn (cbMonSafetyF)
    Else
        MemOff (cbMonSafetyF)
    EndIf
Case "cbMonSafetyFV"
    If tokens$(1) = "true" Then
        MemOn (cbMonSafetyFV)
    Else
        MemOff (cbMonSafetyFV)
    EndIf
Case "dcPwrOkF"
    If tokens$(1) = "true" Then
        MemOn (dcPwrOkF)
    Else
        MemOff (dcPwrOkF)
    EndIf
Case "dcPwrOkFV"
    If tokens$(1) = "true" Then
        MemOn (dcPwrOkFV)
    Else
        MemOff (dcPwrOkFV)
    EndIf
Case "flashPnlPrsntF"
    If tokens$(1) = "true" Then
        MemOn (FlashPnlPrsntF)
    Else
        MemOff (FlashPnlPrsntF)
    EndIf
Case "flashPnlPrsntFV"
    If tokens$(1) = "true" Then
        MemOn (FlashPnlPrsntFV)
    Else
        MemOff (FlashPnlPrsntFV)
    EndIf
Case "frontInterlockF"
    If tokens$(1) = "true" Then
        MemOn (frontInterlockF)
    Else
        MemOff (frontInterlockF)
    EndIf
Case "frontInterlockFV"
    If tokens$(1) = "true" Then
        MemOn (frontInterlockFV)
    Else
        MemOff (frontInterlockFV)
    EndIf
Case "hsPanelPresntF"
    If tokens$(1) = "true" Then
        MemOn (hsPanelPresntF)
    Else
        MemOff (hsPanelPresntF)
    EndIf
Case "hsPanelPresntFV"
    If tokens$(1) = "true" Then
        MemOn (hsPanelPresntFV)
    Else
        MemOff (hsPanelPresntFV)
    EndIf
Case "inMagInterlockF"
    If tokens$(1) = "true" Then
        MemOn (inMagInterlockF)
    Else
        MemOff (inMagInterlockF)
    EndIf
Case "inMagInterlockFV"
    If tokens$(1) = "true" Then
        MemOn (inMagInterlockFV)
    Else
        MemOff (inMagInterlockFV)
    EndIf
Case "inMagLowerLimF"
    If tokens$(1) = "true" Then
        MemOn (inMagLowerLimF)
    Else
        MemOff (inMagLowerLimF)
    EndIf
Case "inMagLowerLimFV"
    If tokens$(1) = "true" Then
        MemOn (inMagLowerLimFV)
    Else
        MemOff (inMagLowerLimFV)
    EndIf
Case "inMagPnlRdyF"
    If tokens$(1) = "true" Then
        MemOn (inMagPnlRdyF)
    Else
        MemOff (inMagPnlRdyF)
    EndIf
Case "inMagPnlRdyFV"
    If tokens$(1) = "true" Then
        MemOn (inMagPnlRdyFV)
    Else
        MemOff (inMagPnlRdyFV)
    EndIf
Case "inMagUpperLimF"
    If tokens$(1) = "true" Then
        MemOn (inMagUpperLimF)
    Else
        MemOff (inMagUpperLimF)
    EndIf
Case "inMagUpperLimFV"
    If tokens$(1) = "true" Then
        MemOn (inMagUpperLimFV)
    Else
        MemOff (inMagUpperLimFV)
    EndIf
Case "leftInterlockF"
    If tokens$(1) = "true" Then
        MemOn (leftInterlockF)
    Else
        MemOff (leftInterlockF)
    EndIf
Case "leftInterlockFV"
    If tokens$(1) = "true" Then
        MemOn (leftInterlockFV)
    Else
        MemOff (leftInterlockFV)
    EndIf
Case "outMagIntF"
    If tokens$(1) = "true" Then
        MemOn (outMagIntF)
    Else
        MemOff (outMagIntF)
    EndIf
Case "outMagIntFV"
    If tokens$(1) = "true" Then
        MemOn (outMagIntFV)
    Else
        MemOff (outMagIntFV)
    EndIf
Case "outMagLowerLimF"
    If tokens$(1) = "true" Then
        MemOn (outMagLowerLimF)
    Else
        MemOff (outMagLowerLimF)
    EndIf
Case "outMagLowerLimFV"
    If tokens$(1) = "true" Then
        MemOn (outMagLowerLimFV)
    Else
        MemOff (outMagLowerLimFV)
    EndIf
Case "outMagPanelRdyF"
    If tokens$(1) = "true" Then
        MemOn (outMagPanelRdyF)
    Else
        MemOff (outMagPanelRdyF)
    EndIf
Case "outMagPanelRdyFV"
    If tokens$(1) = "true" Then
        MemOn (outMagPanelRdyFV)
    Else
        MemOff (outMagPanelRdyFV)
    EndIf
Case "outMagUpperLimF"
    If tokens$(1) = "true" Then
        MemOn (outMagUpperLimF)
    Else
        MemOff (outMagUpperLimF)
    EndIf
Case "outMagUpperLimFV"
    If tokens$(1) = "true" Then
        MemOn (outMagUpperLimFV)
    Else
        MemOff (outMagUpperLimFV)
    EndIf
Case "rightInterlockF"
    If tokens$(1) = "true" Then
        MemOn (rightInterlockF)
    Else
        MemOff (rightInterlockF)
    EndIf
Case "rightInterlockFV"
    If tokens$(1) = "true" Then
        MemOn (rightInterlockFV)
    Else
        MemOff (rightInterlockFV)
    EndIf
Case "debrisMtrF"
    If tokens$(1) = "true" Then
        MemOn (debrisMtrF)
    Else
        MemOff (debrisMtrF)
    EndIf
Case "debrisMtrFV"
    If tokens$(1) = "true" Then
        MemOn (debrisMtrFV)
    Else
        MemOff (debrisMtrFV)
    EndIf
Case "flashCycF"
    If tokens$(1) = "true" Then
        MemOn (flashCycF)
    Else
        MemOff (flashCycF)
    EndIf
Case "flashCycFV"
    If tokens$(1) = "true" Then
        MemOn (flashCycFV)
    Else
        MemOff (flashCycFV)
    EndIf
Case "flashMtrF"
    If tokens$(1) = "true" Then
        MemOn (flashMtrF)
    Else
        MemOff (flashMtrF)
    EndIf
Case "flashMtrFV"
    If tokens$(1) = "true" Then
        MemOn (flashMtrFV)
    Else
        MemOff (flashMtrFV)
    EndIf
Case "hsInstallInsrtF"
    If tokens$(1) = "true" Then
        MemOn (hsInstallInsrtF)
    Else
        MemOff (hsInstallInsrtF)
    EndIf
Case "hsInstallInsrtFV"
    If tokens$(1) = "true" Then
        MemOn (hsInstallInsrtFV)
    Else
        MemOff (hsInstallInsrtFV)
    EndIf
Case "inMagMtrF"
    If tokens$(1) = "true" Then
        MemOn (inMagMtrF)
    Else
        MemOff (inMagMtrF)
    EndIf
Case "inMagMtrFV"
    If tokens$(1) = "true" Then
        MemOn (inMagMtrFV)
    Else
        MemOff (inMagMtrFV)
    EndIf
Case "inMagMtrDirF"
    If tokens$(1) = "true" Then
        MemOn (inMagMtrDirF)
    Else
        MemOff (inMagMtrDirF)
    EndIf
Case "inMagMtrDirFV"
    If tokens$(1) = "true" Then
        MemOn (inMagMtrDirFV)
    Else
        MemOff (inMagMtrDirFV)
    EndIf
Case "outMagMtrF"
    If tokens$(1) = "true" Then
        MemOn (outMagMtrF)
    Else
        MemOff (outMagMtrF)
    EndIf
Case "outMagMtrFV"
    If tokens$(1) = "true" Then
        MemOn (outMagMtrFV)
    Else
        MemOff (outMagMtrFV)
    EndIf
Case "outMagMtrDirF"
    If tokens$(1) = "true" Then
        MemOn (outMagMtrDirF)
    Else
        MemOff (outMagMtrDirF)
    EndIf
Case "outMagMtrDirFV"
    If tokens$(1) = "true" Then
        MemOn (outMagMtrDirFV)
    Else
        MemOff (outMagMtrDirFV)
    EndIf
Case "stackLightAlrmF"
    If tokens$(1) = "true" Then
        MemOn (stackLightAlrmF)
    Else
        MemOff (stackLightAlrmF)
    EndIf
Case "stackLightAlrmFV"
    If tokens$(1) = "true" Then
        MemOn (stackLightAlrmFV)
    Else
        MemOff (stackLightAlrmFV)
    EndIf
Case "stackLightGrnF"
    If tokens$(1) = "true" Then
        MemOn (stackLightGrnF)
    Else
        MemOff (stackLightGrnF)
    EndIf
Case "stackLightGrnFV"
    If tokens$(1) = "true" Then
        MemOn (stackLightGrnFV)
    Else
        MemOff (stackLightGrnFV)
    EndIf
Case "stackLightRedF"
    If tokens$(1) = "true" Then
        MemOn (stackLightRedF)
    Else
        MemOff (stackLightRedF)
    EndIf
Case "stackLightRedFV"
    If tokens$(1) = "true" Then
        MemOn (stackLightRedFV)
    Else
        MemOff (stackLightRedFV)
    EndIf
Case "stackLightYelF"
    If tokens$(1) = "true" Then
        MemOn (stackLightYelF)
    Else
        MemOff (stackLightYelF)
    EndIf
Case "stackLightYelFV"
    If tokens$(1) = "true" Then
        MemOn (stackLightYelFV)
    Else
        MemOff (stackLightYelFV)
    EndIf
Case "suctionCupsF"
    If tokens$(1) = "true" Then
        MemOn (suctionCupsF)
    Else
        MemOff (suctionCupsF)
    EndIf
Case "suctionCupsFV"
    If tokens$(1) = "true" Then
        MemOn (suctionCupsFV)
    Else
        MemOff (suctionCupsFV)
    EndIf
Case "anvilZlimit"
    AnvilZlimit = Val(tokens$(1))
    Print "anvilZlimit:", AnvilZlimit
Case "recBossHeight"
    recBossHeight = Val(tokens$(1))
    Print "recBossHeight:", recBossHeight
Case "recFlashRequired"
    If tokens$(1) = "true" Then
        recFlashRequired = True
    Else
        recFlashRequired = False
    EndIf
    Print "recFlashRequired:", recFlashRequired
Case "recInsertDepth"
    recInsertDepth = Val(tokens$(1))
    Print "recInsertDepth:", recInsertDepth
Case "recInsertType"
    recInsertType = Val(tokens$(1))
    Print "recInsertType:", recInsertType
Case "recMajorDim"
    recMajorDim = Val(tokens$(1))
    Print "recMajorDim:", recMajorDim
Case "recMinorDim"
    recMinorDim = Val(tokens$(1))
    Print "recMinorDim:", recMinorDim
Case "recNumberOfHoles"
    recNumberOfHoles = Val(tokens$(1))
    Redim PanelCordinates(recNumberOfHoles, 2)
    Print "recNumberOfHoles:", recNumberOfHoles
Case "recTemp"
    recTemp = Val(tokens$(1))
    Print "recTemp:", recTemp
Case "recZDropOff"
    recZDropOff = Val(tokens$(1))
    Print "recZDropOff:", recZDropOff
Case "systemSpeed"
    SystemSpeed = Val(tokens$(1))
    Print "systemSpeed:", SystemSpeed
Case "systemState"
    SystemState = Val(tokens$(1))
    Print "systemState:", SystemState
    
Case "hole0X"
    PanelCordinates(0, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole0Y"
    PanelCordinates(0, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole1X"
    PanelCordinates(1, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole1Y"
    PanelCordinates(1, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole2X"
    PanelCordinates(2, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole2Y"
    PanelCordinates(2, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole3X"
    PanelCordinates(3, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole3Y"
    PanelCordinates(3, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole4X"
    PanelCordinates(4, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole4Y"
    PanelCordinates(4, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole5X"
    PanelCordinates(5, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole5Y"
    PanelCordinates(5, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole6X"
    PanelCordinates(6, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole6Y"
    PanelCordinates(6, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole7X"
    PanelCordinates(7, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole7Y"
    PanelCordinates(7, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole8X"
    PanelCordinates(8, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole8Y"
    PanelCordinates(8, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole9X"
    PanelCordinates(9, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole9Y"
    PanelCordinates(9, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole10X"
    PanelCordinates(10, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole10Y"
    PanelCordinates(10, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole11X"
    PanelCordinates(11, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole11Y"
    PanelCordinates(11, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole12X"
    PanelCordinates(12, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole12Y"
    PanelCordinates(12, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole13X"
    PanelCordinates(13, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole13Y"
    PanelCordinates(13, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole14X"
    PanelCordinates(14, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole14Y"
    PanelCordinates(14, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole15X"
    PanelCordinates(15, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole15Y"
    PanelCordinates(15, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole16X"
    PanelCordinates(16, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole16Y"
    PanelCordinates(16, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole17X"
    PanelCordinates(17, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole17Y"
    PanelCordinates(17, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole18X"
    PanelCordinates(18, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole18Y"
    PanelCordinates(18, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole19X"
    PanelCordinates(19, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole19Y"
    PanelCordinates(19, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole20X"
    PanelCordinates(20, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole20Y"
    PanelCordinates(20, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole21X"
    PanelCordinates(21, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole21Y"
    PanelCordinates(21, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole22X"
    PanelCordinates(22, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole22Y"
    PanelCordinates(22, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Default
	' TMH for now print come back and do something useful
	Print "Invalid Token received"
Send
	
Fend
Function HmiListen()
                
    Integer i, j, numTokens
    String tokens$(0)
    String response$
    String outstring$
    String match$
    String prepend$
    Integer ProcessLastToken
     
    ' define the connection to the HMI
    SetNet #202, "10.22.251.68", 1503, CRLF, NONE, 0
    
    prepend$ = ""
    
    OpenNet #202 As Server
 
    Do While True
	    i = ChkNet(202)
	    j = 0
	    Select i
	    	Case -3 'port is not open
	    		OpenNet #202 As Server
	    	Case < 1
	    		prepend$ = ""
	   		Case > 0
				ProcessLastToken = 0
				If i > 200 Then
					i = 200
				EndIf
			   	Read #202, response$, i
			   	response$ = prepend$ + response$
			   	If Right$(response$, 1) = "}" Then 'the last token is ok, so process it
			   		ProcessLastToken = 1
			   	EndIf
				numTokens = ParseStr(response$, tokens$(), "}")
				numTokens = numTokens + ProcessLastToken

				Do While j < numTokens - 1
					setVars(tokens$(j))
					j = j + 1
				Loop
				If ProcessLastToken Then
					prepend$ = ""
				Else
					prepend$ = tokens$(numTokens - 1)
				EndIf
	    Send
	Loop
Fend
Function IntComTest()
	Do While True
	'ints
	systemStatus = systemStatus + 1
	jobNumPanelsDone = jobNumPanelsDone + 2
	hsProbeTemp = hsProbeTemp + 3
	ctrlrLineNumber = ctrlrLineNumber + 1
	ctrlrTaskNumber = ctrlrTaskNumber + 1
	ctrlrErrAxisNumber = ctrlrErrAxisNumber + 1
	ctrlrErrorNum = ctrlrErrorNum + 1
	'bools
	erUnknown = True
	erEstop = True
	erPanelFailedInspection = True
	erFrontSafetyFrameOpen = True
	erBackSafetyFrameOpen = True
	erLeftSafetyFrameOpen = True
	erRightSafetyFrameOpen = True
	erLowPressure = True
	erHighPressure = True
	erPanelStatusUnknown = True
	erWrongPanelHoles = True
	erWrongPanelDims = True
	erWrongPanel = True
	erWrongPanelInsert = True
	erInMagEmpty = True
	erInMagOpenInterlock = True
	erInMagCrowding = True
	erOutMagFull = True
	erOutMagOpenInterlock = True
	erOutMagCrowding = True
	erLaserScanner = True
	erDCPower = True
	erDCPowerHeatStake = True
	erHeatStakeBreaker = True
	erBowlFeederBreaker = True
	erInMagBreaker = True
	erOutMagBreaker = True
	erFlashBreaker = True
	erDebrisRemovalBreaker = True
	erPnumaticsBreaker = True
	erSafetySystemBreaker = True
	erRC180 = True
	'SOH
	homePositionStatus = True
	motorOnStatus = True
	motorPowerStatus = True
	joint1Status = True
	joint2Status = True
	joint3Status = True
	joint4Status = True
	eStopStatus = True
	errorStatus = True
	tasksRunningStatus = True
	pauseStatus = True
	teachModeStatus = True
	
	Wait .75
	
	erUnknown = False
	erEstop = False
	erPanelFailedInspection = False
	erFrontSafetyFrameOpen = False
	erBackSafetyFrameOpen = False
	erLeftSafetyFrameOpen = False
	erRightSafetyFrameOpen = False
	erLowPressure = False
	erHighPressure = False
	erPanelStatusUnknown = False
	erWrongPanelHoles = False
	erWrongPanelDims = False
	erWrongPanel = False
	erWrongPanelInsert = False
	erInMagEmpty = False
	erInMagOpenInterlock = False
	erInMagCrowding = False
	erOutMagFull = False
	erOutMagOpenInterlock = False
	erOutMagCrowding = False
	erLaserScanner = False
	erDCPower = False
	erDCPowerHeatStake = False
	erHeatStakeBreaker = False
	erBowlFeederBreaker = False
	erInMagBreaker = False
	erOutMagBreaker = False
	erFlashBreaker = False
	erDebrisRemovalBreaker = False
	erPnumaticsBreaker = False
	erSafetySystemBreaker = False
	erRC180 = False
	
	'SOH
	motorOnStatus = False
	motorPowerStatus = False
	joint1Status = False
	joint2Status = False
	joint3Status = False
	joint4Status = False
	eStopStatus = False
	errorStatus = False
	tasksRunningStatus = False
	pauseStatus = False
	teachModeStatus = False
	
	Loop
Fend


