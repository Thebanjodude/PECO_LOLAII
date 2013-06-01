#include "Globals.INC"

Function IOTableInputs()

OnErr GoTo errHandler ' Define where to go when a controller error occurs

Do While True
	
'Inputs
airPressHigh = IOTableBooleans(Sw(AirPressHighH), MemSw(airPressHighFV), MemSw(airPressHighF))
airPressLow = IOTableBooleans(Sw(AirPressLowH), MemSw(airPressLowFV), MemSw(airPressLowF))
backIntlock1 = IOTableBooleans(Sw(backIntlock1H), MemSw(backIntlock1FV), MemSw(backIntlock1F))
backIntlock2 = IOTableBooleans(Sw(backIntlock2H), MemSw(backIntlock2FV), MemSw(backIntlock2F))
'cbMonBowlFeder = IOTableBooleans(Sw(cbMonBowlFederH), MemSw(cbMonBowlFederFV), MemSw(cbMonBowlFederF))
cbMonDebrisRmv = IOTableBooleans(Sw(cbMonDebrisRmvH), MemSw(cbMonDebrisRmvFV), MemSw(cbMonDebrisRmvF))
cbMonHeatStake = IOTableBooleans(Sw(cbMonHeatStakeH), MemSw(cbMonHeatStakeFV), MemSw(cbMonHeatStakeF))
cbMonInMag = IOTableBooleans(Sw(cbMonInMagH), MemSw(cbMonInMagFV), MemSw(cbMonInMagF))
cbMonOutMag = IOTableBooleans(Sw(cbMonOutMagH), MemSw(cbMonOutMagFV), MemSw(cbMonOutMagF))
dc24vOK = IOTableBooleans(Sw(dc24vOKH), MemSw(dc24vOKFV), MemSw(dc24vOKF))
cbMonPAS24vdc = IOTableBooleans(Sw(cbMonPAS24vdcH), MemSw(cbMonPAS24vdcFV), MemSw(cbMonPAS24vdcF))
cbMonSafety = IOTableBooleans(Sw(cbMonSafetyH), MemSw(cbMonSafetyFV), MemSw(cbMonSafetyF))
edgeDetectGo = IOTableBooleans(Sw(edgeDetectGoH), MemSw(edgeDetectGoFV), MemSw(edgeDetectGoF))
edgeDetectHi = IOTableBooleans(Sw(edgeDetectHiH), MemSw(edgeDetectHiFV), MemSw(edgeDetectHiF))
edgeDetectLo = IOTableBooleans(Sw(edgeDetectLoH), MemSw(edgeDetectLoFV), MemSw(edgeDetectLoF))
flashPnlPrsnt = IOTableBooleans(Sw(FlashPnlPrsntH), MemSw(FlashPnlPrsntFV), MemSw(FlashPnlPrsntF))
frontIntlock1 = IOTableBooleans(Sw(frontIntlock1H), MemSw(frontIntlock1FV), MemSw(frontIntlock1F))
frontIntlock2 = IOTableBooleans(Sw(frontIntlock2H), MemSw(frontIntlock2FV), MemSw(frontIntlock2F))
holeDetected = IOTableBooleans(Sw(holeDetectedH), MemSw(holeDetectedFV), MemSw(holeDetectedF))
hsPanelPresnt = IOTableBooleans(Sw(HSPanelPresntH), MemSw(hsPanelPresntFV), MemSw(hsPanelPresntF))
inMagInterlock = IOTableBooleans(Sw(inMagInterlockH), MemSw(inMagInterlockFV), MemSw(inMagInterlockF))
inMagLowLim = IOTableBooleans(Sw(inMagLowLimH), MemSw(inMagLowLimFV), MemSw(inMagLowLimF))
inMagLowLimN = IOTableBooleans(Sw(inMagLowLimNH), MemSw(inMagLowLimNFV), MemSw(inMagLowLimNF))
inMagPnlRdy = IOTableBooleans(Sw(inMagPnlRdyH), MemSw(inMagPnlRdyFV), MemSw(inMagPnlRdyF))
inMagUpLim = IOTableBooleans(Sw(inMagUpLimH), MemSw(inMagUpLimFV), MemSw(inMagUpLimF))
inMagUpLimN = IOTableBooleans(Sw(inMagUpLimNH), MemSw(inMagUpLimNFV), MemSw(inMagUpLimNF))
leftIntlock1 = IOTableBooleans(Sw(leftIntlock1H), MemSw(leftIntlock1FV), MemSw(leftIntlock1F))
leftIntlock2 = IOTableBooleans(Sw(leftIntlock2H), MemSw(leftIntlock2FV), MemSw(leftIntlock2F))
maintMode = IOTableBooleans(Sw(MaintModeH), MemSw(maintModeFV), MemSw(maintModeF))
outMagInt = IOTableBooleans(Sw(outMagIntH), MemSw(outMagIntFV), MemSw(outMagIntF))
outMagLowLim = IOTableBooleans(Sw(outMagLowLimH), MemSw(outMagLowLimFV), MemSw(outMagLowLimF))
outMagLowLimN = IOTableBooleans(Sw(outMagLowLimNH), MemSw(outMagLowLimNFV), MemSw(outMagLowLimNF))
outMagPanelRdy = IOTableBooleans(Sw(outMagPanelRdyH), MemSw(outMagPanelRdyFV), MemSw(outMagPanelRdyF))
outMagUpLim = IOTableBooleans(Sw(outMagUpLimH), MemSw(outMagUpLimFV), MemSw(outMagUpLimF))
outMagUpLimN = IOTableBooleans(Sw(outMagUpLimNH), MemSw(outMagUpLimNFV), MemSw(outMagUpLimNF))
rightIntlock = IOTableBooleans(Sw(rightIntlockH), MemSw(rightIntlockFV), MemSw(rightIntlockF))
monEstop1 = IOTableBooleans(Sw(monEstop1H), MemSw(monEstop1FV), MemSw(monEstop1F))
monEstop2 = IOTableBooleans(Sw(monEstop2H), MemSw(monEstop2FV), MemSw(monEstop2F))

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
'Outputs
Function IOTableOutputs()
	
OnErr GoTo errHandler ' Define where to go when a controller error occurs
	
Do While True
'Dont Delete when updating----	
stackLightAlrm = IOTableBooleans(stackLightAlrmCC, MemSw(stackLightAlrmFV), MemSw(stackLightAlrmF))
If stackLightAlrm = True Then
	If alarmTog = True Then
			If alarmMute = False Then
				On (stackLightAlrmH)
			EndIf
	Else
		alarmTog = True
		alarmMute = False
	EndIf
Else
	Off (stackLightAlrmH)
	alarmTog = False
EndIf
'-------
debrisMtr = IOTableBooleans(debrisMtrCC, MemSw(debrisMtrFV), MemSw(debrisMtrF))
If debrisMtr = True Then
        On (debrisMtrH)
    Else
        Off (debrisMtrH)
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
removeFlash = IOTableBooleans(removeFlashCC, MemSw(removeFlashFV), MemSw(removeFlashF))
If removeFlash = True Then
        On (removeFlashH)
    Else
        Off (removeFlashH)
    EndIf
returnFlash = IOTableBooleans(returnFlashCC, MemSw(returnFlashFV), MemSw(returnFlashF))
If returnFlash = True Then
        On (returnFlashH)
    Else
        Off (returnFlashH)
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
	Pause
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
            OpenNet #201 As Client
            Print "Attempted Open TCP port to HMI"
        Else
            ' write variable data to HMI
'            Write #201, Chr$(12) 'this breaks the JSON interpreter
		EndIf
heartBeat = Not heartBeat
'Tx to HMI:
Print #201, "{", Chr$(&H22) + "backInterlockACK" + Chr$(&H22), ":", Str$(backInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "frontInterlockACK" + Chr$(&H22), ":", Str$(frontInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "inMagGoHome" + Chr$(&H22), ":", Str$(inMagGoHome), "}",
Print #201, "{", Chr$(&H22) + "inMagIntLockAck" + Chr$(&H22), ":", Str$(inMagIntLockAck), "}",
Print #201, "{", Chr$(&H22) + "inMagLoaded" + Chr$(&H22), ":", Str$(inMagLoaded), "}",
Print #201, "{", Chr$(&H22) + "jobAbort" + Chr$(&H22), ":", Str$(jobAbort), "}",
Print #201, "{", Chr$(&H22) + "jobStart" + Chr$(&H22), ":", Str$(jobStart), "}",
Print #201, "{", Chr$(&H22) + "leftInterlockACK" + Chr$(&H22), ":", Str$(leftInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "outMagGoHome" + Chr$(&H22), ":", Str$(outMagGoHome), "}",
Print #201, "{", Chr$(&H22) + "outMagIntLockAck" + Chr$(&H22), ":", Str$(outMagIntLockAck), "}",
Print #201, "{", Chr$(&H22) + "outMagUnloaded" + Chr$(&H22), ":", Str$(outMagUnloaded), "}",
Print #201, "{", Chr$(&H22) + "rightInterlockACK" + Chr$(&H22), ":", Str$(rightInterlockACK), "}",
Print #201, "{", Chr$(&H22) + "sftyFrmIlockAck" + Chr$(&H22), ":", Str$(sftyFrmIlockAck), "}",
Print #201, "{", Chr$(&H22) + "erBackSafetyFrameOpen" + Chr$(&H22), ":", Str$(erBackSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erDCPower" + Chr$(&H22), ":", Str$(erDCPower), "}",
Print #201, "{", Chr$(&H22) + "erDCPowerHeatStake" + Chr$(&H22), ":", Str$(erDCPowerHeatStake), "}",
Print #201, "{", Chr$(&H22) + "erDebrisRemovalBreaker" + Chr$(&H22), ":", Str$(erDebrisRemovalBreaker), "}",
Print #201, "{", Chr$(&H22) + "erEstop" + Chr$(&H22), ":", Str$(erEstop), "}",
Print #201, "{", Chr$(&H22) + "erFrontSafetyFrameOpen" + Chr$(&H22), ":", Str$(erFrontSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erHeatStakeBreaker" + Chr$(&H22), ":", Str$(erHeatStakeBreaker), "}",
Print #201, "{", Chr$(&H22) + "erHeatStakeTemp" + Chr$(&H22), ":", Str$(erHeatStakeTemp), "}",
Print #201, "{", Chr$(&H22) + "erHighPressure" + Chr$(&H22), ":", Str$(erHighPressure), "}",
Print #201, "{", Chr$(&H22) + "erHMICommunication" + Chr$(&H22), ":", Str$(erHMICommunication), "}",
Print #201, "{", Chr$(&H22) + "erIllegalArmMove" + Chr$(&H22), ":", Str$(erIllegalArmMove), "}",
Print #201, "{", Chr$(&H22) + "erInMagBreaker" + Chr$(&H22), ":", Str$(erInMagBreaker), "}",
Print #201, "{", Chr$(&H22) + "erInMagCrowding" + Chr$(&H22), ":", Str$(erInMagCrowding), "}",
Print #201, "{", Chr$(&H22) + "erInMagEmpty" + Chr$(&H22), ":", Str$(erInMagEmpty), "}",
Print #201, "{", Chr$(&H22) + "erInMagLowSensorBad" + Chr$(&H22), ":", Str$(erInMagLowSensorBad), "}",
Print #201, "{", Chr$(&H22) + "erInMagOpenInterlock" + Chr$(&H22), ":", Str$(erInMagOpenInterlock), "}",
Print #201, "{", Chr$(&H22) + "erInMagUpSensorBad" + Chr$(&H22), ":", Str$(erInMagUpSensorBad), "}",
Print #201, "{", Chr$(&H22) + "erBadPressureSensor" + Chr$(&H22), ":", Str$(erBadPressureSensor), "}",
Print #201, "{", Chr$(&H22) + "erLaserScanner" + Chr$(&H22), ":", Str$(erLaserScanner), "}",
Print #201, "{", Chr$(&H22) + "erLeftSafetyFrameOpen" + Chr$(&H22), ":", Str$(erLeftSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erLowPressure" + Chr$(&H22), ":", Str$(erLowPressure), "}",
Print #201, "{", Chr$(&H22) + "erOutMagBreaker" + Chr$(&H22), ":", Str$(erOutMagBreaker), "}",
Print #201, "{", Chr$(&H22) + "erOutMagCrowding" + Chr$(&H22), ":", Str$(erOutMagCrowding), "}",
Print #201, "{", Chr$(&H22) + "erOutMagFull" + Chr$(&H22), ":", Str$(erOutMagFull), "}",
Print #201, "{", Chr$(&H22) + "erOutMagLowSensorBad" + Chr$(&H22), ":", Str$(erOutMagLowSensorBad), "}",
Print #201, "{", Chr$(&H22) + "erOutMagOpenInterlock" + Chr$(&H22), ":", Str$(erOutMagOpenInterlock), "}",
Print #201, "{", Chr$(&H22) + "erOutMagUpSensorBad" + Chr$(&H22), ":", Str$(erOutMagUpSensorBad), "}",
Print #201, "{", Chr$(&H22) + "erPanelFailedInspection" + Chr$(&H22), ":", Str$(erPanelFailedInspection), "}",
Print #201, "{", Chr$(&H22) + "erPanelStatusUnknown" + Chr$(&H22), ":", Str$(erPanelStatusUnknown), "}",
Print #201, "{", Chr$(&H22) + "erParamEntryMissing" + Chr$(&H22), ":", Str$(erParamEntryMissing), "}",
Print #201, "{", Chr$(&H22) + "erRC180" + Chr$(&H22), ":", Str$(erRC180), "}",
Print #201, "{", Chr$(&H22) + "erRecEntryMissing" + Chr$(&H22), ":", Str$(erRecEntryMissing), "}",
Print #201, "{", Chr$(&H22) + "erRightSafetyFrameOpen" + Chr$(&H22), ":", Str$(erRightSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erRobotNotAtHome" + Chr$(&H22), ":", Str$(erRobotNotAtHome), "}",
Print #201, "{", Chr$(&H22) + "erSafetySystemBreaker" + Chr$(&H22), ":", Str$(erSafetySystemBreaker), "}",
Print #201, "{", Chr$(&H22) + "erUnknown" + Chr$(&H22), ":", Str$(erUnknown), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanel" + Chr$(&H22), ":", Str$(erWrongPanel), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanelDims" + Chr$(&H22), ":", Str$(erWrongPanelDims), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanelHoles" + Chr$(&H22), ":", Str$(erWrongPanelHoles), "}",
Print #201, "{", Chr$(&H22) + "erWrongPanelInsert" + Chr$(&H22), ":", Str$(erWrongPanelInsert), "}",
Print #201, "{", Chr$(&H22) + "erHmiDataAck" + Chr$(&H22), ":", Str$(erHmiDataAck), "}",
Print #201, "{", Chr$(&H22) + "hole0L" + Chr$(&H22), ":", Str$(hole0L), "}",
Print #201, "{", Chr$(&H22) + "hole0R" + Chr$(&H22), ":", Str$(hole0R), "}",
Print #201, "{", Chr$(&H22) + "hole10L" + Chr$(&H22), ":", Str$(hole10L), "}",
Print #201, "{", Chr$(&H22) + "hole10R" + Chr$(&H22), ":", Str$(hole10R), "}",
Print #201, "{", Chr$(&H22) + "hole11L" + Chr$(&H22), ":", Str$(hole11L), "}",
Print #201, "{", Chr$(&H22) + "hole11R" + Chr$(&H22), ":", Str$(hole11R), "}",
Print #201, "{", Chr$(&H22) + "hole12L" + Chr$(&H22), ":", Str$(hole12L), "}",
Print #201, "{", Chr$(&H22) + "hole12R" + Chr$(&H22), ":", Str$(hole12R), "}",
Print #201, "{", Chr$(&H22) + "hole13L" + Chr$(&H22), ":", Str$(hole13L), "}",
Print #201, "{", Chr$(&H22) + "hole13R" + Chr$(&H22), ":", Str$(hole13R), "}",
Print #201, "{", Chr$(&H22) + "hole14L" + Chr$(&H22), ":", Str$(hole14L), "}",
Print #201, "{", Chr$(&H22) + "hole14R" + Chr$(&H22), ":", Str$(hole14R), "}",
Print #201, "{", Chr$(&H22) + "hole15L" + Chr$(&H22), ":", Str$(hole15L), "}",
Print #201, "{", Chr$(&H22) + "hole15R" + Chr$(&H22), ":", Str$(hole15R), "}",
Print #201, "{", Chr$(&H22) + "hole16L" + Chr$(&H22), ":", Str$(hole16L), "}",
Print #201, "{", Chr$(&H22) + "hole16R" + Chr$(&H22), ":", Str$(hole16R), "}",
Print #201, "{", Chr$(&H22) + "hole17L" + Chr$(&H22), ":", Str$(hole17L), "}",
Print #201, "{", Chr$(&H22) + "hole17R" + Chr$(&H22), ":", Str$(hole17R), "}",
Print #201, "{", Chr$(&H22) + "hole18L" + Chr$(&H22), ":", Str$(hole18L), "}",
Print #201, "{", Chr$(&H22) + "hole18R" + Chr$(&H22), ":", Str$(hole18R), "}",
Print #201, "{", Chr$(&H22) + "hole19L" + Chr$(&H22), ":", Str$(hole19L), "}",
Print #201, "{", Chr$(&H22) + "hole19R" + Chr$(&H22), ":", Str$(hole19R), "}",
Print #201, "{", Chr$(&H22) + "hole1L" + Chr$(&H22), ":", Str$(hole1L), "}",
Print #201, "{", Chr$(&H22) + "hole1R" + Chr$(&H22), ":", Str$(hole1R), "}",
Print #201, "{", Chr$(&H22) + "hole20L" + Chr$(&H22), ":", Str$(hole20L), "}",
Print #201, "{", Chr$(&H22) + "hole20R" + Chr$(&H22), ":", Str$(hole20R), "}",
Print #201, "{", Chr$(&H22) + "hole21L" + Chr$(&H22), ":", Str$(hole21L), "}",
Print #201, "{", Chr$(&H22) + "hole21R" + Chr$(&H22), ":", Str$(hole21R), "}",
Print #201, "{", Chr$(&H22) + "hole22L" + Chr$(&H22), ":", Str$(hole22L), "}",
Print #201, "{", Chr$(&H22) + "hole22R" + Chr$(&H22), ":", Str$(hole22R), "}",
Print #201, "{", Chr$(&H22) + "hole2L" + Chr$(&H22), ":", Str$(hole2L), "}",
Print #201, "{", Chr$(&H22) + "hole2R" + Chr$(&H22), ":", Str$(hole2R), "}",
Print #201, "{", Chr$(&H22) + "hole3L" + Chr$(&H22), ":", Str$(hole3L), "}",
Print #201, "{", Chr$(&H22) + "hole3R" + Chr$(&H22), ":", Str$(hole3R), "}",
Print #201, "{", Chr$(&H22) + "hole4L" + Chr$(&H22), ":", Str$(hole4L), "}",
Print #201, "{", Chr$(&H22) + "hole4R" + Chr$(&H22), ":", Str$(hole4R), "}",
Print #201, "{", Chr$(&H22) + "hole5L" + Chr$(&H22), ":", Str$(hole5L), "}",
Print #201, "{", Chr$(&H22) + "hole5R" + Chr$(&H22), ":", Str$(hole5R), "}",
Print #201, "{", Chr$(&H22) + "hole6L" + Chr$(&H22), ":", Str$(hole6L), "}",
Print #201, "{", Chr$(&H22) + "hole6R" + Chr$(&H22), ":", Str$(hole6R), "}",
Print #201, "{", Chr$(&H22) + "hole7L" + Chr$(&H22), ":", Str$(hole7L), "}",
Print #201, "{", Chr$(&H22) + "hole7R" + Chr$(&H22), ":", Str$(hole7R), "}",
Print #201, "{", Chr$(&H22) + "hole8L" + Chr$(&H22), ":", Str$(hole8L), "}",
Print #201, "{", Chr$(&H22) + "hole8R" + Chr$(&H22), ":", Str$(hole8R), "}",
Print #201, "{", Chr$(&H22) + "hole9L" + Chr$(&H22), ":", Str$(hole9L), "}",
Print #201, "{", Chr$(&H22) + "hole9R" + Chr$(&H22), ":", Str$(hole9R), "}",
Print #201, "{", Chr$(&H22) + "airPressHigh" + Chr$(&H22), ":", Str$(airPressHigh), "}",
Print #201, "{", Chr$(&H22) + "airPressLow" + Chr$(&H22), ":", Str$(airPressLow), "}",
Print #201, "{", Chr$(&H22) + "backIntlock1" + Chr$(&H22), ":", Str$(backIntlock1), "}",
Print #201, "{", Chr$(&H22) + "backIntlock2" + Chr$(&H22), ":", Str$(backIntlock2), "}",
'Print #201, "{", Chr$(&H22) + "cbMonBowlFeder" + Chr$(&H22), ":", Str$(cbMonBowlFeder), "}",
Print #201, "{", Chr$(&H22) + "cbMonDebrisRmv" + Chr$(&H22), ":", Str$(cbMonDebrisRmv), "}",
Print #201, "{", Chr$(&H22) + "cbMonHeatStake" + Chr$(&H22), ":", Str$(cbMonHeatStake), "}",
Print #201, "{", Chr$(&H22) + "cbMonInMag" + Chr$(&H22), ":", Str$(cbMonInMag), "}",
Print #201, "{", Chr$(&H22) + "cbMonOutMag" + Chr$(&H22), ":", Str$(cbMonOutMag), "}",
Print #201, "{", Chr$(&H22) + "dc24vOK" + Chr$(&H22), ":", Str$(dc24vOK), "}",
Print #201, "{", Chr$(&H22) + "cbMonPAS24vdc" + Chr$(&H22), ":", Str$(cbMonPAS24vdc), "}",
Print #201, "{", Chr$(&H22) + "cbMonSafety" + Chr$(&H22), ":", Str$(cbMonSafety), "}",
Print #201, "{", Chr$(&H22) + "edgeDetectGo" + Chr$(&H22), ":", Str$(edgeDetectGo), "}",
Print #201, "{", Chr$(&H22) + "edgeDetectHi" + Chr$(&H22), ":", Str$(edgeDetectHi), "}",
Print #201, "{", Chr$(&H22) + "edgeDetectLo" + Chr$(&H22), ":", Str$(edgeDetectLo), "}",
Print #201, "{", Chr$(&H22) + "flashPnlPrsnt" + Chr$(&H22), ":", Str$(FlashPnlPrsnt), "}",
Print #201, "{", Chr$(&H22) + "frontIntlock1" + Chr$(&H22), ":", Str$(frontIntlock1), "}",
Print #201, "{", Chr$(&H22) + "frontIntlock2" + Chr$(&H22), ":", Str$(frontIntlock2), "}",
Print #201, "{", Chr$(&H22) + "holeDetected" + Chr$(&H22), ":", Str$(holeDetected), "}",
Print #201, "{", Chr$(&H22) + "hsPanelPresnt" + Chr$(&H22), ":", Str$(hsPanelPresnt), "}",
Print #201, "{", Chr$(&H22) + "inMagInterlock" + Chr$(&H22), ":", Str$(inMagInterlock), "}",
Print #201, "{", Chr$(&H22) + "inMagLowLim" + Chr$(&H22), ":", Str$(inMagLowLim), "}",
Print #201, "{", Chr$(&H22) + "inMagLowLimN" + Chr$(&H22), ":", Str$(inMagLowLimN), "}",
Print #201, "{", Chr$(&H22) + "inMagPnlRdy" + Chr$(&H22), ":", Str$(inMagPnlRdy), "}",
Print #201, "{", Chr$(&H22) + "inMagUpLim" + Chr$(&H22), ":", Str$(inMagUpLim), "}",
Print #201, "{", Chr$(&H22) + "inMagUpLimN" + Chr$(&H22), ":", Str$(inMagUpLimN), "}",
Print #201, "{", Chr$(&H22) + "leftIntlock1" + Chr$(&H22), ":", Str$(leftIntlock1), "}",
Print #201, "{", Chr$(&H22) + "leftIntlock2" + Chr$(&H22), ":", Str$(leftIntlock2), "}",
Print #201, "{", Chr$(&H22) + "maintMode" + Chr$(&H22), ":", Str$(maintMode), "}",
Print #201, "{", Chr$(&H22) + "outMagInt" + Chr$(&H22), ":", Str$(outMagInt), "}",
Print #201, "{", Chr$(&H22) + "outMagLowLim" + Chr$(&H22), ":", Str$(outMagLowLim), "}",
Print #201, "{", Chr$(&H22) + "outMagLowLimN" + Chr$(&H22), ":", Str$(outMagLowLimN), "}",
Print #201, "{", Chr$(&H22) + "outMagPanelRdy" + Chr$(&H22), ":", Str$(outMagPanelRdy), "}",
Print #201, "{", Chr$(&H22) + "outMagUpLim" + Chr$(&H22), ":", Str$(outMagUpLim), "}",
Print #201, "{", Chr$(&H22) + "outMagUpLimN" + Chr$(&H22), ":", Str$(outMagUpLimN), "}",
Print #201, "{", Chr$(&H22) + "rightIntlock" + Chr$(&H22), ":", Str$(rightIntlock), "}",
Print #201, "{", Chr$(&H22) + "debrisMtr" + Chr$(&H22), ":", Str$(debrisMtr), "}",
Print #201, "{", Chr$(&H22) + "inMagMtr" + Chr$(&H22), ":", Str$(inMagMtr), "}",
Print #201, "{", Chr$(&H22) + "inMagMtrDir" + Chr$(&H22), ":", Str$(inMagMtrDir), "}",
Print #201, "{", Chr$(&H22) + "outMagMtr" + Chr$(&H22), ":", Str$(outMagMtr), "}",
Print #201, "{", Chr$(&H22) + "outMagMtrDir" + Chr$(&H22), ":", Str$(outMagMtrDir), "}",
Print #201, "{", Chr$(&H22) + "removeFlash" + Chr$(&H22), ":", Str$(removeFlash), "}",
Print #201, "{", Chr$(&H22) + "returnFlash" + Chr$(&H22), ":", Str$(returnFlash), "}",
Print #201, "{", Chr$(&H22) + "stackLightAlrm" + Chr$(&H22), ":", Str$(stackLightAlrm), "}",
Print #201, "{", Chr$(&H22) + "stackLightGrn" + Chr$(&H22), ":", Str$(stackLightGrn), "}",
Print #201, "{", Chr$(&H22) + "stackLightRed" + Chr$(&H22), ":", Str$(stackLightRed), "}",
Print #201, "{", Chr$(&H22) + "stackLightYel" + Chr$(&H22), ":", Str$(stackLightYel), "}",
Print #201, "{", Chr$(&H22) + "suctionCups" + Chr$(&H22), ":", Str$(suctionCups), "}",
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
Print #201, "{", Chr$(&H22) + "heatStakeCurrentTemp" + Chr$(&H22), ":", Str$(heatStakeCurrentTemp), "}",
Print #201, "{", Chr$(&H22) + "hole0PF" + Chr$(&H22), ":", Str$(hole0PF), "}",
Print #201, "{", Chr$(&H22) + "hole10PF" + Chr$(&H22), ":", Str$(hole10PF), "}",
Print #201, "{", Chr$(&H22) + "hole11PF" + Chr$(&H22), ":", Str$(hole11PF), "}",
Print #201, "{", Chr$(&H22) + "hole12PF" + Chr$(&H22), ":", Str$(hole12PF), "}",
Print #201, "{", Chr$(&H22) + "hole13PF" + Chr$(&H22), ":", Str$(hole13PF), "}",
Print #201, "{", Chr$(&H22) + "hole14PF" + Chr$(&H22), ":", Str$(hole14PF), "}",
Print #201, "{", Chr$(&H22) + "hole15PF" + Chr$(&H22), ":", Str$(hole15PF), "}",
Print #201, "{", Chr$(&H22) + "hole16PF" + Chr$(&H22), ":", Str$(hole16PF), "}",
Print #201, "{", Chr$(&H22) + "hole17PF" + Chr$(&H22), ":", Str$(hole17PF), "}",
Print #201, "{", Chr$(&H22) + "hole18PF" + Chr$(&H22), ":", Str$(hole18PF), "}",
Print #201, "{", Chr$(&H22) + "hole19PF" + Chr$(&H22), ":", Str$(hole19PF), "}",
Print #201, "{", Chr$(&H22) + "hole1PF" + Chr$(&H22), ":", Str$(hole1PF), "}",
Print #201, "{", Chr$(&H22) + "hole20PF" + Chr$(&H22), ":", Str$(hole20PF), "}",
Print #201, "{", Chr$(&H22) + "hole21PF" + Chr$(&H22), ":", Str$(hole21PF), "}",
Print #201, "{", Chr$(&H22) + "hole22PF" + Chr$(&H22), ":", Str$(hole22PF), "}",
Print #201, "{", Chr$(&H22) + "hole2PF" + Chr$(&H22), ":", Str$(hole2PF), "}",
Print #201, "{", Chr$(&H22) + "hole3PF" + Chr$(&H22), ":", Str$(hole3PF), "}",
Print #201, "{", Chr$(&H22) + "hole4PF" + Chr$(&H22), ":", Str$(hole4PF), "}",
Print #201, "{", Chr$(&H22) + "hole5PF" + Chr$(&H22), ":", Str$(hole5PF), "}",
Print #201, "{", Chr$(&H22) + "hole6PF" + Chr$(&H22), ":", Str$(hole6PF), "}",
Print #201, "{", Chr$(&H22) + "hole7PF" + Chr$(&H22), ":", Str$(hole7PF), "}",
Print #201, "{", Chr$(&H22) + "hole8PF" + Chr$(&H22), ":", Str$(hole8PF), "}",
Print #201, "{", Chr$(&H22) + "hole9PF" + Chr$(&H22), ":", Str$(hole9PF), "}",
Print #201, "{", Chr$(&H22) + "inMagCurrentState" + Chr$(&H22), ":", Str$(inMagCurrentState), "}",
Print #201, "{", Chr$(&H22) + "jobDone" + Chr$(&H22), ":", Str$(jobDone), "}",
Print #201, "{", Chr$(&H22) + "jobNumPanelsDone" + Chr$(&H22), ":", Str$(jobNumPanelsDone), "}",
Print #201, "{", Chr$(&H22) + "outMagCurrentState" + Chr$(&H22), ":", Str$(outMagCurrentState), "}",
Print #201, "{", Chr$(&H22) + "panelDataTxRdy" + Chr$(&H22), ":", Str$(panelDataTxRdy), "}",
'dont delete when updating
Print #201, "{", Chr$(&H22) + "monEstop1" + Chr$(&H22), ":", Str$(monEstop1), "}",
Print #201, "{", Chr$(&H22) + "monEstop2" + Chr$(&H22), ":", Str$(monEstop2), "}",
'-------
	Loop
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
	
	Select Tokens$(0)
 'Rx from HMI:
Case "backInterlockACKBtn"
   If Tokens$(1) = "true" Then
       backInterlockACKBtn = True
       backInterlockACK = True
   Else
       backInterlockACKBtn = False
   EndIf
   Print "backInterlockACKBtn:", backInterlockACKBtn
Case "frontInterlockACKBtn"
   If Tokens$(1) = "true" Then
       frontInterlockACKBtn = True
       frontInterlockACK = True
   Else
       frontInterlockACKBtn = False
   EndIf
   Print "frontInterlockACKBtn:", frontInterlockACKBtn
Case "inMagGoHomeBtn"
   If Tokens$(1) = "true" Then
       inMagGoHomeBtn = True
       inMagGoHome = True
   Else
       inMagGoHomeBtn = False
   EndIf
   Print "inMagGoHomeBtn:", inMagGoHomeBtn
Case "inMagIntLockAckBtn"
   If Tokens$(1) = "true" Then
       inMagIntLockAckBtn = True
       inMagIntLockAck = True
   Else
       inMagIntLockAckBtn = False
   EndIf
   Print "inMagIntLockAckBtn:", inMagIntLockAckBtn
Case "inMagLoadedBtn"
   If Tokens$(1) = "true" Then
       inMagLoadedBtn = True
       inMagLoaded = True
   Else
       inMagLoadedBtn = False
   EndIf
   Print "inMagLoadedBtn:", inMagLoadedBtn
Case "jobAbortBtn"
   If Tokens$(1) = "true" Then
       jobAbortBtn = True
       jobAbort = True
   Else
       jobAbortBtn = False
   EndIf
   Print "jobAbortBtn:", jobAbortBtn
Case "jobStartBtn"
   If Tokens$(1) = "true" Then
       jobStartBtn = True
       jobStart = True
   Else
       jobStartBtn = False
   EndIf
   Print "jobStartBtn:", jobStartBtn
Case "leftInterlockACKBtn"
   If Tokens$(1) = "true" Then
       leftInterlockACKBtn = True
       leftInterlockACK = True
   Else
       leftInterlockACKBtn = False
   EndIf
   Print "leftInterlockACKBtn:", leftInterlockACKBtn
Case "outMagGoHomeBtn"
   If Tokens$(1) = "true" Then
       outMagGoHomeBtn = True
       outMagGoHome = True
   Else
       outMagGoHomeBtn = False
   EndIf
   Print "outMagGoHomeBtn:", outMagGoHomeBtn
Case "outMagIntLockAckBtn"
   If Tokens$(1) = "true" Then
       outMagIntLockAckBtn = True
       outMagIntLockAck = True
   Else
       outMagIntLockAckBtn = False
   EndIf
   Print "outMagIntLockAckBtn:", outMagIntLockAckBtn
Case "outMagUnloadedBtn"
   If Tokens$(1) = "true" Then
       outMagUnloadedBtn = True
       outMagUnloaded = True
   Else
       outMagUnloadedBtn = False
   EndIf
   Print "outMagUnloadedBtn:", outMagUnloadedBtn
Case "rightInterlockACKBtn"
   If Tokens$(1) = "true" Then
       rightInterlockACKBtn = True
       rightInterlockACK = True
   Else
       rightInterlockACKBtn = False
   EndIf
   Print "rightInterlockACKBtn:", rightInterlockACKBtn
Case "sftyFrmIlockAckBtn"
   If Tokens$(1) = "true" Then
       sftyFrmIlockAckBtn = True
       sftyFrmIlockAck = True
   Else
       sftyFrmIlockAckBtn = False
   EndIf
   Print "sftyFrmIlockAckBtn:", sftyFrmIlockAckBtn
Case "hole0X"
    PanelCordinates(0, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole0Y"
    PanelCordinates(0, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole10X"
    PanelCordinates(10, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole10Y"
    PanelCordinates(10, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole11X"
    PanelCordinates(11, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole11Y"
    PanelCordinates(11, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole12X"
    PanelCordinates(12, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole12Y"
    PanelCordinates(12, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole13X"
    PanelCordinates(13, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole13Y"
    PanelCordinates(13, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole14X"
    PanelCordinates(14, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole14Y"
    PanelCordinates(14, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole15X"
    PanelCordinates(15, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole15Y"
    PanelCordinates(15, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole16X"
    PanelCordinates(16, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole16Y"
    PanelCordinates(16, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole17X"
    PanelCordinates(17, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole17Y"
    PanelCordinates(17, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole18X"
    PanelCordinates(18, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole18Y"
    PanelCordinates(18, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole19X"
    PanelCordinates(19, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole19Y"
    PanelCordinates(19, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole1X"
    PanelCordinates(1, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole1Y"
    PanelCordinates(1, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole20X"
    PanelCordinates(20, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole20Y"
    PanelCordinates(20, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole21X"
    PanelCordinates(21, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole21Y"
    PanelCordinates(21, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole22X"
    PanelCordinates(22, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole22Y"
    PanelCordinates(22, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole2X"
    PanelCordinates(2, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole2Y"
    PanelCordinates(2, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole3X"
    PanelCordinates(3, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole3Y"
    PanelCordinates(3, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole4X"
    PanelCordinates(4, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole4Y"
    PanelCordinates(4, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole5X"
    PanelCordinates(5, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole5Y"
    PanelCordinates(5, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole6X"
    PanelCordinates(6, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole6Y"
    PanelCordinates(6, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole7X"
    PanelCordinates(7, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole7Y"
    PanelCordinates(7, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole8X"
    PanelCordinates(8, 0) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole8Y"
    PanelCordinates(8, 1) = Val(Tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole9X"
    PanelCordinates(9, 0) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "hole9Y"
    PanelCordinates(9, 1) = Val(tokens$(1)) * 25.4 'convert inches to mm (mm are the default Epson unit)
Case "airPressHighF"
    If tokens$(1) = "true" Then
        MemOn (airPressHighF)
    Else
        MemOff (airPressHighF)
    EndIf
Case "airPressHighFV"
    If Tokens$(1) = "true" Then
        MemOn (airPressHighFV)
    Else
        MemOff (airPressHighFV)
    EndIf
Case "airPressLowF"
    If Tokens$(1) = "true" Then
        MemOn (airPressLowF)
    Else
        MemOff (airPressLowF)
    EndIf
Case "airPressLowFV"
    If Tokens$(1) = "true" Then
        MemOn (airPressLowFV)
    Else
        MemOff (airPressLowFV)
    EndIf
Case "backIntlock1F"
    If Tokens$(1) = "true" Then
        MemOn (backIntlock1F)
    Else
        MemOff (backIntlock1F)
    EndIf
Case "backIntlock1FV"
    If Tokens$(1) = "true" Then
        MemOn (backIntlock1FV)
    Else
        MemOff (backIntlock1FV)
    EndIf
Case "backIntlock2F"
    If Tokens$(1) = "true" Then
        MemOn (backIntlock2F)
    Else
        MemOff (backIntlock2F)
    EndIf
Case "backIntlock2FV"
    If Tokens$(1) = "true" Then
        MemOn (backIntlock2FV)
    Else
        MemOff (backIntlock2FV)
    EndIf
'Case "cbMonBowlFederF"
'    If tokens$(1) = "true" Then
'        MemOn (cbMonBowlFederF)
'    Else
'        MemOff (cbMonBowlFederF)
'    EndIf
'Case "cbMonBowlFederFV"
'    If tokens$(1) = "true" Then
'        MemOn (cbMonBowlFederFV)
'    Else
'        MemOff (cbMonBowlFederFV)
'    EndIf
Case "cbMonDebrisRmvF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonDebrisRmvF)
    Else
        MemOff (cbMonDebrisRmvF)
    EndIf
Case "cbMonDebrisRmvFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonDebrisRmvFV)
    Else
        MemOff (cbMonDebrisRmvFV)
    EndIf
Case "cbMonHeatStakeF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonHeatStakeF)
    Else
        MemOff (cbMonHeatStakeF)
    EndIf
Case "cbMonHeatStakeFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonHeatStakeFV)
    Else
        MemOff (cbMonHeatStakeFV)
    EndIf
Case "monEstop1"
    If Tokens$(1) = "true" Then
        monEstop1 = True
    Else
        monEstop1 = False
    EndIf
    Print "monEstop1:", monEstop1
Case "monEstop2"
    If tokens$(1) = "true" Then
        monEstop2 = True
    Else
        monEstop2 = False
    EndIf
    Print "monEstop2:", monEstop2
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
Case "dc24vOKF"
    If tokens$(1) = "true" Then
        MemOn (dc24vOKF)
    Else
        MemOff (dc24vOKF)
    EndIf
Case "dc24vOKFV"
    If tokens$(1) = "true" Then
        MemOn (dc24vOKFV)
    Else
        MemOff (dc24vOKFV)
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
Case "edgeDetectGoF"
    If tokens$(1) = "true" Then
        MemOn (edgeDetectGoF)
    Else
        MemOff (edgeDetectGoF)
    EndIf
Case "edgeDetectGoFV"
    If tokens$(1) = "true" Then
        MemOn (edgeDetectGoFV)
    Else
        MemOff (edgeDetectGoFV)
    EndIf
Case "edgeDetectHiF"
    If tokens$(1) = "true" Then
        MemOn (edgeDetectHiF)
    Else
        MemOff (edgeDetectHiF)
    EndIf
Case "edgeDetectHiFV"
    If tokens$(1) = "true" Then
        MemOn (edgeDetectHiFV)
    Else
        MemOff (edgeDetectHiFV)
    EndIf
Case "edgeDetectLoF"
    If tokens$(1) = "true" Then
        MemOn (edgeDetectLoF)
    Else
        MemOff (edgeDetectLoF)
    EndIf
Case "edgeDetectLoFV"
    If tokens$(1) = "true" Then
        MemOn (edgeDetectLoFV)
    Else
        MemOff (edgeDetectLoFV)
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
Case "frontIntlock1F"
    If tokens$(1) = "true" Then
        MemOn (frontIntlock1F)
    Else
        MemOff (frontIntlock1F)
    EndIf
Case "frontIntlock1FV"
    If tokens$(1) = "true" Then
        MemOn (frontIntlock1FV)
    Else
        MemOff (frontIntlock1FV)
    EndIf
Case "frontIntlock2F"
    If tokens$(1) = "true" Then
        MemOn (frontIntlock2F)
    Else
        MemOff (frontIntlock2F)
    EndIf
Case "frontIntlock2FV"
    If tokens$(1) = "true" Then
        MemOn (frontIntlock2FV)
    Else
        MemOff (frontIntlock2FV)
    EndIf
Case "holeDetectedF"
    If tokens$(1) = "true" Then
        MemOn (holeDetectedF)
    Else
        MemOff (holeDetectedF)
    EndIf
Case "holeDetectedFV"
    If tokens$(1) = "true" Then
        MemOn (holeDetectedFV)
    Else
        MemOff (holeDetectedFV)
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
Case "inMagLowLimF"
    If tokens$(1) = "true" Then
        MemOn (inMagLowLimF)
    Else
        MemOff (inMagLowLimF)
    EndIf
Case "inMagLowLimFV"
    If tokens$(1) = "true" Then
        MemOn (inMagLowLimFV)
    Else
        MemOff (inMagLowLimFV)
    EndIf
Case "inMagLowLimNF"
    If tokens$(1) = "true" Then
        MemOn (inMagLowLimNF)
    Else
        MemOff (inMagLowLimNF)
    EndIf
Case "inMagLowLimNFV"
    If tokens$(1) = "true" Then
        MemOn (inMagLowLimNFV)
    Else
        MemOff (inMagLowLimNFV)
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
Case "inMagUpLimF"
    If tokens$(1) = "true" Then
        MemOn (inMagUpLimF)
    Else
        MemOff (inMagUpLimF)
    EndIf
Case "inMagUpLimFV"
    If tokens$(1) = "true" Then
        MemOn (inMagUpLimFV)
    Else
        MemOff (inMagUpLimFV)
    EndIf
Case "inMagUpLimNF"
    If tokens$(1) = "true" Then
        MemOn (inMagUpLimNF)
    Else
        MemOff (inMagUpLimNF)
    EndIf
Case "inMagUpLimNFV"
    If tokens$(1) = "true" Then
        MemOn (inMagUpLimNFV)
    Else
        MemOff (inMagUpLimNFV)
    EndIf
Case "leftIntlock1F"
    If tokens$(1) = "true" Then
        MemOn (leftIntlock1F)
    Else
        MemOff (leftIntlock1F)
    EndIf
Case "leftIntlock1FV"
    If tokens$(1) = "true" Then
        MemOn (leftIntlock1FV)
    Else
        MemOff (leftIntlock1FV)
    EndIf
Case "leftIntlock2F"
    If tokens$(1) = "true" Then
        MemOn (leftIntlock2F)
    Else
        MemOff (leftIntlock2F)
    EndIf
Case "leftIntlock2FV"
    If tokens$(1) = "true" Then
        MemOn (leftIntlock2FV)
    Else
        MemOff (leftIntlock2FV)
    EndIf
Case "maintModeF"
    If tokens$(1) = "true" Then
        MemOn (maintModeF)
    Else
        MemOff (maintModeF)
    EndIf
Case "maintModeFV"
    If tokens$(1) = "true" Then
        MemOn (maintModeFV)
    Else
        MemOff (maintModeFV)
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
Case "outMagLowLimF"
    If tokens$(1) = "true" Then
        MemOn (outMagLowLimF)
    Else
        MemOff (outMagLowLimF)
    EndIf
Case "outMagLowLimFV"
    If tokens$(1) = "true" Then
        MemOn (outMagLowLimFV)
    Else
        MemOff (outMagLowLimFV)
    EndIf
Case "outMagLowLimNF"
    If tokens$(1) = "true" Then
        MemOn (outMagLowLimNF)
    Else
        MemOff (outMagLowLimNF)
    EndIf
Case "outMagLowLimNFV"
    If tokens$(1) = "true" Then
        MemOn (outMagLowLimNFV)
    Else
        MemOff (outMagLowLimNFV)
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
Case "outMagUpLimF"
    If tokens$(1) = "true" Then
        MemOn (outMagUpLimF)
    Else
        MemOff (outMagUpLimF)
    EndIf
Case "outMagUpLimFV"
    If tokens$(1) = "true" Then
        MemOn (outMagUpLimFV)
    Else
        MemOff (outMagUpLimFV)
    EndIf
Case "outMagUpLimNF"
    If tokens$(1) = "true" Then
        MemOn (outMagUpLimNF)
    Else
        MemOff (outMagUpLimNF)
    EndIf
Case "outMagUpLimNFV"
    If tokens$(1) = "true" Then
        MemOn (outMagUpLimNFV)
    Else
        MemOff (outMagUpLimNFV)
    EndIf
Case "rightIntlockF"
    If tokens$(1) = "true" Then
        MemOn (rightIntlockF)
    Else
        MemOff (rightIntlockF)
    EndIf
Case "rightIntlockFV"
    If tokens$(1) = "true" Then
        MemOn (rightIntlockFV)
    Else
        MemOff (rightIntlockFV)
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
Case "removeFlashF"
    If tokens$(1) = "true" Then
        MemOn (removeFlashF)
    Else
        MemOff (removeFlashF)
    EndIf
Case "removeFlashFV"
    If tokens$(1) = "true" Then
        MemOn (removeFlashFV)
    Else
        MemOff (removeFlashFV)
    EndIf
Case "returnFlashF"
    If tokens$(1) = "true" Then
        MemOn (returnFlashF)
    Else
        MemOff (returnFlashF)
    EndIf
Case "returnFlashFV"
    If tokens$(1) = "true" Then
        MemOn (returnFlashFV)
    Else
        MemOff (returnFlashFV)
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
Case "heatStakeTempTolerance"
    heatStakeTempTolerance = Val(tokens$(1))
    Print "heatStakeTempTolerance:", heatStakeTempTolerance
Case "insertDepthTolerance"
    insertDepthTolerance = Val(tokens$(1))
    Print "insertDepthTolerance:", insertDepthTolerance
Case "jobNumPanels"
    jobNumPanels = Val(tokens$(1))
    Print "jobNumPanels:", jobNumPanels
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
Case "recNumberOfHoles"
    recNumberOfHoles = Val(tokens$(1))
    Print "recNumberOfHoles:", recNumberOfHoles
Case "recPanelThickness"
    recPanelThickness = Val(tokens$(1))
    Print "recPanelThickness:", recPanelThickness
Case "recTemp"
    recTemp = Val(tokens$(1))
    Print "recTemp:", recTemp
Case "suctionWaitTime"
    suctionWaitTime = Val(tokens$(1))
    Print "suctionWaitTime:", suctionWaitTime
Case "systemAccel"
    SystemAccel = Val(tokens$(1))
    Print "systemAccel:", SystemAccel
Case "systemSpeed"
    SystemSpeed = Val(tokens$(1))
    Print "systemSpeed:", SystemSpeed
Case "systemState"
    If tokens$(1) = "true" Then
        SystemState = True
    Else
        SystemState = False
    EndIf
    Print "systemState:", SystemState
Case "zlimit"
    zLimit = Val(tokens$(1))
    Print "zlimit:", zLimit
Case "flashDwellTime"
    flashDwellTime = Val(tokens$(1))
    Print "flashDwellTime:", flashDwellTime
Case "panelDataTxACK"
    If tokens$(1) = "true" Then
        panelDataTxACK = True
    Else
        panelDataTxACK = False
    EndIf
    Print "panelDataTxACK:", panelDataTxACK
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
String CRLF$
Integer modMessage(256)
Integer modbusMessageID

Function Main3()
	Integer i
	Integer writtenValue
	Long readValue
	Integer writeStatus
	Integer portStatus
	String testString$
	Integer modLength
	
	readValue = 0
	CRLF$ = Chr$(13) + Chr$(10)
	 
	SetNet #204, "10.22.251.171", 7352, CR, NONE, 0
	
	'Xqt twiddle_test, NoPause	
		
	readValue = modbusReadRegister(16)
	
	'set initial modbus ID as 0
	modbusMessageID = 0;
	
	Do While 1
		Wait 2.0
		portStatus = ChkNet(204)
		If portStatus < 0 Then
			Print "portStatus: ", portStatus
			OpenNet #204 As Client
		EndIf
		'Print #204, "Calling Modbus"
		'writeStatus = modbusWriteRegister(&h33, &hAAFF)
		writeStatus = modbusWriteRegister(&h33, modbusMessageID)
		modbusMessageID = modbusMessageID + 1
	Loop
	
Fend
Function modbusCRC(modLength As Integer) As Long
	
	Long CRC
	Long lowBit
	Integer bitCount
	Integer byteCount
	
	' initialize the CRC
	CRC = &hFFFF

	' step through the entire message
	'Print "outer loop running from 0 to ", modLength - 1
	For byteCount = 0 To modLength - 1
		'Print "processing byte: ", Str$(modMessage(byteCount))

		' XOR current byte of message with CRC
		CRC = CRC Xor modMessage(byteCount)
		'Print "after XOR with byte 0x", Hex$(modMessage(byteCount)), CRC
		
		' proceed through 8 shift operations XORing with polynomial if necessary
		For bitCount = 0 To 7
			'capture the low order bit before we shift it away
			lowBit = CRC And 1
		
			' shift CRC right one bit
			CRC = RShift(CRC, 1)
		
			' if the least significant bit was a 1, XOR it with polynomial constant 1010000000000001
			If lowBit = 1 Then
				CRC = CRC Xor &b1010000000000001
				'Print "after XOR with poly: ", CRC
			Else
				'Print "No XOR with poly   : ", CRC
			EndIf
		Next
	Next
	
	'Print "resulting CRC is: ", CRC
	modbusCRC = CRC
	
Fend
' This function is for writing a single 16 Modbus register on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return a ??? for success or -1 for failure
' calling type and return value are "Long" 
Function modbusWriteRegister(regNum As Long, value As Long) As Integer
	
	Integer portStatus
	Long CRC
	Long modResponse(10)
	Integer i
	
	portStatus = ChkNet(204)
	


	'build the command and send it to PLC
	' function code		0x06
	' address high 		0x00
	' address low		0x00
	' value high		0x00
	' value low			0x00
	modMessage(0) = &h11 'PLC modbus address
	modMessage(1) = 6 ' function code
	modMessage(2) = RShift(regNum, 8) ' high byte of address
	modMessage(3) = regNum And &hFF ' low byte of address
	modMessage(4) = RShift(value, 8) ' high byte of value
	modMessage(5) = value And &hFF ' low byte of value
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	For i = 0 To 7
		Print "modMessage(", Str$(i), ") = ", Hex$(modMessage(i))
	Next
	
	' if port is not open exit with error
	If portStatus < 0 Then
		modbusWriteRegister = -1 'error port should remain open
		Print "Bailing! not port open"
		Exit Function
	EndIf
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8
	
	' TMH possibly delay or check for bytes returned here	
	' TMH may be a better way to do this but I wanted to avoid blocking if nothing is returned
	Wait 1
	If ChkNet(204) < 7 Then
		modbusWriteRegister = -2 ' error invalid or no response
	Else
		' process the response or timeout
		'wait for a predefinded period of time for the expected number of characters
		'modResponse(0) = address of master
		'modResponse(1) = function. Should be 6 if no error
		'modResponse(2) = Register address high byte
		'modResponse(3) = Register address low byte
		'modResponse(4) = value high byte
		'modResponse(5) = value low byte
		'modResponse(6) = CRC low byte
		'modResponse(7) = CRC high byte
		ReadBin #204, modResponse(), 8
	EndIf
	
Fend
' This function is for reading a single 16 bit Modbus register from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge.
' It will then wait for a response from the PLC
Function modbusReadRegister(regNum As Long) As Long
	
	Integer portStatus
	Long CRC
	Long modResponse(10)
	Integer i
	
	portStatus = ChkNet(204)


	'build the command and send it to PLC
	' function code		0x03
	' address high 		0x00
	' address low		0x00
	' No. of Regs high 	0x00
	' No. of Regs low	0x01
	modMessage(0) = &h11 'PLC modbus address
	modMessage(1) = 3 ' function code
	modMessage(2) = RShift(regNum, 8) ' high byte of address
	modMessage(3) = regNum And &hFF ' low byte of address
	modMessage(4) = 0 ' high byte of No. of regs is always zero 
	modMessage(5) = 1 ' low byte of No. of regs is one i.e. read one register
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	For i = 0 To 7
	'	Print "modMessage(", Str$(i), ") = ", Hex$(modMessage(i))
	Next
	
	' if port is not open exit with error
	If portStatus < 0 Then
		modbusReadRegister = -1 'error port should remain open
		Print "Bailing! not port open"
		Exit Function
	EndIf
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8

	' delay then check for bytes returned 	
	' TMH may be a better way to do this but I wanted to avoid blocking if nothing is returned
	Wait 1
	If ChkNet(204) < 7 Then
		modbusReadRegister = -2 ' error invalid or no response
	Else
		'process the response or timeout 
		'wait for a predefinded period of time for the expected number of characters
		'modResponse(0) = address of master
		'modResponse(1) = function. Should be 3 if no error
		'modResponse(2) = No. Bytes returned. Should be 2 for one 16 bit register
		'modResponse(3) = value returned high byte
		'modResponse(4) = value returned low byte
		'modResponse(5) = CRC low byte
		'modResponse(6) = CRC high byte
		ReadBin #204, modResponse(), 7
		
		modbusReadRegister = LShift(modMessage(3), 8) And (modMessage(4))
		
	EndIf
		
Fend
' Write a single coil value on the PLC
' Call with coil number
' Returns 1 for success 0 for failure
Function modbusWriteCoil(coilNum As Integer, value As Boolean)
	
Fend
' Read a single coil value from the PLC
' Call with coil number
' Returns boolean value of coil
Function modbusReadCoil(coilNum As Integer) As Boolean
	modbusReadCoil = 1
Fend


