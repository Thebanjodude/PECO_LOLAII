#include "Globals.INC"

Function IOTableInputs()
	
OnErr GoTo errHandler ' Define where to go when a controller error occurs

Do While True
'Inputs
airPressHigh = IOTableBooleans(Sw(AirPressHighH), MemSw(airPressHighFV), MemSw(airPressHighF))
airPressLow = IOTableBooleans(Sw(AirPressLowH), MemSw(airPressLowFV), MemSw(airPressLowF))
backIntlock1 = IOTableBooleans(Sw(backIntlock1H), MemSw(backIntlock1FV), MemSw(backIntlock1F))
backIntlock2 = IOTableBooleans(Sw(backIntlock2H), MemSw(backIntlock2FV), MemSw(backIntlock2F))
cbMonDebrisRmv = IOTableBooleans(Sw(cbMonDebrisRmvH), MemSw(cbMonDebrisRmvFV), MemSw(cbMonDebrisRmvF))
cbMonHeatStake = IOTableBooleans(Sw(cbMonHeatStakeH), MemSw(cbMonHeatStakeFV), MemSw(cbMonHeatStakeF))
cbMonInMag = IOTableBooleans(Sw(cbMonInMagH), MemSw(cbMonInMagFV), MemSw(cbMonInMagF))
cbMonOutMag = IOTableBooleans(Sw(cbMonOutMagH), MemSw(cbMonOutMagFV), MemSw(cbMonOutMagF))
cbMonPAS24vdc = IOTableBooleans(Sw(cbMonPAS24vdcH), MemSw(cbMonPAS24vdcFV), MemSw(cbMonPAS24vdcF))
cbMonSafety = IOTableBooleans(Sw(cbMonSafetyH), MemSw(cbMonSafetyFV), MemSw(cbMonSafetyF))
dc24vOK = IOTableBooleans(Sw(dc24vOKH), MemSw(dc24vOKFV), MemSw(dc24vOKF))
edgeDetectGo = IOTableBooleans(Sw(edgeDetectGoH), MemSw(edgeDetectGoFV), MemSw(edgeDetectGoF))
edgeDetectHi = IOTableBooleans(Sw(edgeDetectHiH), MemSw(edgeDetectHiFV), MemSw(edgeDetectHiF))
edgeDetectLo = IOTableBooleans(Sw(edgeDetectLoH), MemSw(edgeDetectLoFV), MemSw(edgeDetectLoF))
flashHomeNC = IOTableBooleans(Sw(FlashHomeNCH), MemSw(flashHomeNCFV), MemSw(flashHomeNCF))
flashHomeNO = IOTableBooleans(Sw(FlashHomeNOH), MemSw(flashHomeNOFV), MemSw(flashHomeNOF))
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
monEstop1 = IOTableBooleans(Sw(monEstop1H), MemSw(monEstop1FV), MemSw(monEstop1F))
monEstop2 = IOTableBooleans(Sw(monEstop2H), MemSw(monEstop2FV), MemSw(monEstop2F))
outMagInt = IOTableBooleans(Sw(outMagIntH), MemSw(outMagIntFV), MemSw(outMagIntF))
outMagLowLim = IOTableBooleans(Sw(outMagLowLimH), MemSw(outMagLowLimFV), MemSw(outMagLowLimF))
outMagLowLimN = IOTableBooleans(Sw(outMagLowLimNH), MemSw(outMagLowLimNFV), MemSw(outMagLowLimNF))
outMagPanelRdy = IOTableBooleans(Sw(outMagPanelRdyH), MemSw(outMagPanelRdyFV), MemSw(outMagPanelRdyF))
outMagUpLim = IOTableBooleans(Sw(outMagUpLimH), MemSw(outMagUpLimFV), MemSw(outMagUpLimF))
outMagUpLimN = IOTableBooleans(Sw(outMagUpLimNH), MemSw(outMagUpLimNFV), MemSw(outMagUpLimNF))
rightIntlock = IOTableBooleans(Sw(rightIntlockH), MemSw(rightIntlockFV), MemSw(rightIntlockF))

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
'Dont Delete when updating-------------
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

drillGo = IOTableBooleans(drillGoCC, MemSw(drillGoFV), MemSw(drillGoF))
If drillGo = True Then

	If GoFlag = False Then
        On (DrillGoH), .25, 0
        GoFlag = True
    EndIf
    
    If DrillGoH = Off Then
    	drillGoCC = False
    	MemOff (drillGoFV)
    	GoFlag = False
    EndIf
    
    Else
        Off (DrillGoH)
        GoFlag = False
 	EndIf
    
drillReturn = IOTableBooleans(drillReturnCC, MemSw(drillReturnFV), MemSw(drillReturnF))
If drillReturn = True Then

	If ReturnFlag = False Then
        On (DrillReturnH), .25, 0
        ReturnFlag = True
    EndIf
    
    If DrillReturnH = Off Then
    	drillReturnCC = False
    	MemOff (drillReturnFV)
    	ReturnFlag = False
    EndIf
Else
    Off (DrillReturnH)
    ReturnFlag = False
EndIf

'---------------------
debrisMtr = IOTableBooleans(debrisMtrCC, MemSw(debrisMtrFV), MemSw(debrisMtrF))
If debrisMtr = True Then
        On (debrisMtrH)
    Else
        Off (debrisMtrH)
    EndIf
eStopReset = IOTableBooleans(eStopResetCC, MemSw(eStopResetFV), MemSw(eStopResetF))
If eStopReset = True Then
        On (eStopResetH)
    Else
        Off (eStopResetH)
    EndIf
heatStakeGo = IOTableBooleans(heatStakeGoCC, MemSw(heatStakeGoFV), MemSw(heatStakeGoF))
If heatStakeGo = True Then
        On (heatStakeGoH)
    Else
        Off (heatStakeGoH)
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
	Pause
EResume

Fend
Function IOTableBooleans(CtrlCodeValue As Boolean, HMIForceValue As Boolean, HMIForceFlag As Boolean) As Boolean
		
	Boolean Value
	Value = CtrlCodeValue 'Set value to what the control code wants it to be
	
	If HMIForceFlag = True Then ' Check If we want to force it 
		Value = HMIForceValue ' Take forced value from HMI, overwrite control code
	EndIf
	
	IOTableBooleans = value ' Return Value
	
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
' writes and reads variables to HMI
                
    Integer i, j
    String response$
    String outstring$
    
    ' define the connection to the HMI
'    SetNet #201, "10.22.2.30", 1502, CRLF, NONE, 0
    SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0

    Do While True
    	
   	OnErr GoTo RetryConnection ' on any error retry connection
  
RetryConnection:
      	'Wait .5 'send I/O once per second
        If ChkNet(201) < 0 Then ' If port is not open
            OpenNet #201 As Client
            Print "Attempted Open TCP port to HMI"
        Else
            ' write variable data to HMI
'            Write #201, Chr$(12) 'this breaks the JSON interpreter
		EndIf
		
heartBeat = Not heartBeat
'Tx to HMI:
Print #201, "{", Chr$(&H22) + "alarmMute" + Chr$(&H22), ":", Str$(alarmMute), "}",
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
Print #201, "{", Chr$(&H22) + "erBadPressureSensor" + Chr$(&H22), ":", Str$(erBadPressureSensor), "}",
Print #201, "{", Chr$(&H22) + "erDCPower" + Chr$(&H22), ":", Str$(erDCPower), "}",
Print #201, "{", Chr$(&H22) + "erDCPowerHeatStake" + Chr$(&H22), ":", Str$(erDCPowerHeatStake), "}",
Print #201, "{", Chr$(&H22) + "erDebrisRemovalBreaker" + Chr$(&H22), ":", Str$(erDebrisRemovalBreaker), "}",
Print #201, "{", Chr$(&H22) + "erEstop" + Chr$(&H22), ":", Str$(erEstop), "}",
Print #201, "{", Chr$(&H22) + "erFlashStation" + Chr$(&H22), ":", Str$(erFlashStation), "}",
Print #201, "{", Chr$(&H22) + "erFrontSafetyFrameOpen" + Chr$(&H22), ":", Str$(erFrontSafetyFrameOpen), "}",
Print #201, "{", Chr$(&H22) + "erHeatStakeBreaker" + Chr$(&H22), ":", Str$(erHeatStakeBreaker), "}",
Print #201, "{", Chr$(&H22) + "erHeatStakeTemp" + Chr$(&H22), ":", Str$(erHeatStakeTemp), "}",
Print #201, "{", Chr$(&H22) + "erHighPressure" + Chr$(&H22), ":", Str$(erHighPressure), "}",
Print #201, "{", Chr$(&H22) + "erHMICommunication" + Chr$(&H22), ":", Str$(erHMICommunication), "}",
Print #201, "{", Chr$(&H22) + "erHmiDataAck" + Chr$(&H22), ":", Str$(erHmiDataAck), "}",
Print #201, "{", Chr$(&H22) + "erPanelUndefined" + Chr$(&H22), ":", Str$(erPanelUndefined), "}",
Print #201, "{", Chr$(&H22) + "erIllegalArmMove" + Chr$(&H22), ":", Str$(erIllegalArmMove), "}",
Print #201, "{", Chr$(&H22) + "erInMagBreaker" + Chr$(&H22), ":", Str$(erInMagBreaker), "}",
Print #201, "{", Chr$(&H22) + "erInMagCrowding" + Chr$(&H22), ":", Str$(erInMagCrowding), "}",
Print #201, "{", Chr$(&H22) + "erInMagEmpty" + Chr$(&H22), ":", Str$(erInMagEmpty), "}",
Print #201, "{", Chr$(&H22) + "erInMagLowSensorBad" + Chr$(&H22), ":", Str$(erInMagLowSensorBad), "}",
Print #201, "{", Chr$(&H22) + "erInMagOpenInterlock" + Chr$(&H22), ":", Str$(erInMagOpenInterlock), "}",
Print #201, "{", Chr$(&H22) + "erInMagUpSensorBad" + Chr$(&H22), ":", Str$(erInMagUpSensorBad), "}",
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
Print #201, "{", Chr$(&H22) + "erWrongPanelHoles" + Chr$(&H22), ":", Str$(erWrongPanelHoles), "}",
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
Print #201, "{", Chr$(&H22) + "cbMonDebrisRmv" + Chr$(&H22), ":", Str$(cbMonDebrisRmv), "}",
Print #201, "{", Chr$(&H22) + "cbMonHeatStake" + Chr$(&H22), ":", Str$(cbMonHeatStake), "}",
Print #201, "{", Chr$(&H22) + "cbMonInMag" + Chr$(&H22), ":", Str$(cbMonInMag), "}",
Print #201, "{", Chr$(&H22) + "cbMonOutMag" + Chr$(&H22), ":", Str$(cbMonOutMag), "}",
Print #201, "{", Chr$(&H22) + "cbMonPAS24vdc" + Chr$(&H22), ":", Str$(cbMonPAS24vdc), "}",
Print #201, "{", Chr$(&H22) + "cbMonSafety" + Chr$(&H22), ":", Str$(cbMonSafety), "}",
Print #201, "{", Chr$(&H22) + "dc24vOK" + Chr$(&H22), ":", Str$(dc24vOK), "}",
Print #201, "{", Chr$(&H22) + "edgeDetectGo" + Chr$(&H22), ":", Str$(edgeDetectGo), "}",
Print #201, "{", Chr$(&H22) + "edgeDetectHi" + Chr$(&H22), ":", Str$(edgeDetectHi), "}",
Print #201, "{", Chr$(&H22) + "edgeDetectLo" + Chr$(&H22), ":", Str$(edgeDetectLo), "}",
Print #201, "{", Chr$(&H22) + "flashHomeNC" + Chr$(&H22), ":", Str$(flashHomeNC), "}",
Print #201, "{", Chr$(&H22) + "flashHomeNO" + Chr$(&H22), ":", Str$(flashHomeNO), "}",
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
Print #201, "{", Chr$(&H22) + "monEstop1" + Chr$(&H22), ":", Str$(monEstop1), "}",
Print #201, "{", Chr$(&H22) + "monEstop2" + Chr$(&H22), ":", Str$(monEstop2), "}",
Print #201, "{", Chr$(&H22) + "outMagInt" + Chr$(&H22), ":", Str$(outMagInt), "}",
Print #201, "{", Chr$(&H22) + "outMagLowLim" + Chr$(&H22), ":", Str$(outMagLowLim), "}",
Print #201, "{", Chr$(&H22) + "outMagLowLimN" + Chr$(&H22), ":", Str$(outMagLowLimN), "}",
Print #201, "{", Chr$(&H22) + "outMagPanelRdy" + Chr$(&H22), ":", Str$(outMagPanelRdy), "}",
Print #201, "{", Chr$(&H22) + "outMagUpLim" + Chr$(&H22), ":", Str$(outMagUpLim), "}",
Print #201, "{", Chr$(&H22) + "outMagUpLimN" + Chr$(&H22), ":", Str$(outMagUpLimN), "}",
Print #201, "{", Chr$(&H22) + "rightIntlock" + Chr$(&H22), ":", Str$(rightIntlock), "}",
Print #201, "{", Chr$(&H22) + "debrisMtr" + Chr$(&H22), ":", Str$(debrisMtr), "}",
Print #201, "{", Chr$(&H22) + "drillGo" + Chr$(&H22), ":", Str$(drillGo), "}",
Print #201, "{", Chr$(&H22) + "drillReturn" + Chr$(&H22), ":", Str$(drillReturn), "}",
Print #201, "{", Chr$(&H22) + "eStopReset" + Chr$(&H22), ":", Str$(eStopReset), "}",
Print #201, "{", Chr$(&H22) + "heatStakeGo" + Chr$(&H22), ":", Str$(heatStakeGo), "}",
Print #201, "{", Chr$(&H22) + "inMagMtr" + Chr$(&H22), ":", Str$(inMagMtr), "}",
Print #201, "{", Chr$(&H22) + "inMagMtrDir" + Chr$(&H22), ":", Str$(inMagMtrDir), "}",
Print #201, "{", Chr$(&H22) + "outMagMtr" + Chr$(&H22), ":", Str$(outMagMtr), "}",
Print #201, "{", Chr$(&H22) + "outMagMtrDir" + Chr$(&H22), ":", Str$(outMagMtrDir), "}",
Print #201, "{", Chr$(&H22) + "stackLightAlrm" + Chr$(&H22), ":", Str$(stackLightAlrm), "}",
Print #201, "{", Chr$(&H22) + "stackLightGrn" + Chr$(&H22), ":", Str$(stackLightGrn), "}",
Print #201, "{", Chr$(&H22) + "stackLightRed" + Chr$(&H22), ":", Str$(stackLightRed), "}",
Print #201, "{", Chr$(&H22) + "stackLightYel" + Chr$(&H22), ":", Str$(stackLightYel), "}",
Print #201, "{", Chr$(&H22) + "suctionCups" + Chr$(&H22), ":", Str$(suctionCups), "}",
Print #201, "{", Chr$(&H22) + "pas1inLoadInsertCylinder" + Chr$(&H22), ":", Str$(pas1inLoadInsertCylinder), "}",
Print #201, "{", Chr$(&H22) + "pasBlowInsert" + Chr$(&H22), ":", Str$(pasBlowInsert), "}",
Print #201, "{", Chr$(&H22) + "pasBowlDumpOpen" + Chr$(&H22), ":", Str$(pasBowlDumpOpen), "}",
Print #201, "{", Chr$(&H22) + "pasBowlFeeder" + Chr$(&H22), ":", Str$(pasBowlFeeder), "}",
Print #201, "{", Chr$(&H22) + "pasGoHome" + Chr$(&H22), ":", Str$(pasGoHome), "}",
Print #201, "{", Chr$(&H22) + "pasHeadDown" + Chr$(&H22), ":", Str$(pasHeadDown), "}",
Print #201, "{", Chr$(&H22) + "pasHeadUp" + Chr$(&H22), ":", Str$(pasHeadUp), "}",
Print #201, "{", Chr$(&H22) + "pasInsertGripper" + Chr$(&H22), ":", Str$(pasInsertGripper), "}",
Print #201, "{", Chr$(&H22) + "pasInsertType" + Chr$(&H22), ":", Str$(pasInsertType), "}",
Print #201, "{", Chr$(&H22) + "pasMasterTemp" + Chr$(&H22), ":", Str$(pasMasterTemp), "}",
Print #201, "{", Chr$(&H22) + "pasMaxTempOnOffZone1" + Chr$(&H22), ":", Str$(pasMaxTempOnOffZone1), "}",
Print #201, "{", Chr$(&H22) + "pasMaxTempOnOffZone2" + Chr$(&H22), ":", Str$(pasMaxTempOnOffZone2), "}",
Print #201, "{", Chr$(&H22) + "pasOnOffZone1" + Chr$(&H22), ":", Str$(pasOnOffZone1), "}",
Print #201, "{", Chr$(&H22) + "pasOnOffZone2" + Chr$(&H22), ":", Str$(pasOnOffZone2), "}",
Print #201, "{", Chr$(&H22) + "pasOTAOnOffZone1" + Chr$(&H22), ":", Str$(pasOTAOnOffZone1), "}",
Print #201, "{", Chr$(&H22) + "pasOTAOnOffZone2" + Chr$(&H22), ":", Str$(pasOTAOnOffZone2), "}",
Print #201, "{", Chr$(&H22) + "pasRemoteAlarmAcknowledge" + Chr$(&H22), ":", Str$(pasRemoteAlarmAcknowledge), "}",
Print #201, "{", Chr$(&H22) + "pasResetHighTemp" + Chr$(&H22), ":", Str$(pasResetHighTemp), "}",
Print #201, "{", Chr$(&H22) + "pasResetMax" + Chr$(&H22), ":", Str$(pasResetMax), "}",
Print #201, "{", Chr$(&H22) + "pasSlideExtend" + Chr$(&H22), ":", Str$(pasSlideExtend), "}",
Print #201, "{", Chr$(&H22) + "pasStartPIDTuneZone1" + Chr$(&H22), ":", Str$(pasStartPIDTuneZone1), "}",
Print #201, "{", Chr$(&H22) + "pasStartPIDTuneZone2" + Chr$(&H22), ":", Str$(pasStartPIDTuneZone2), "}",
Print #201, "{", Chr$(&H22) + "pasTempOnOff" + Chr$(&H22), ":", Str$(pasTempOnOff), "}",
Print #201, "{", Chr$(&H22) + "pasVibTrack" + Chr$(&H22), ":", Str$(pasVibTrack), "}",
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
Print #201, "{", Chr$(&H22) + "currentFlashHole" + Chr$(&H22), ":", Str$(currentFlashHole), "}",
Print #201, "{", Chr$(&H22) + "currentHSHole" + Chr$(&H22), ":", Str$(currentHSHole), "}",
Print #201, "{", Chr$(&H22) + "currentInspectHole" + Chr$(&H22), ":", Str$(currentInspectHole), "}",
Print #201, "{", Chr$(&H22) + "currentPreinspectHole" + Chr$(&H22), ":", Str$(currentPreinspectHole), "}",
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
Print #201, "{", Chr$(&H22) + "mainCurrentState" + Chr$(&H22), ":", Str$(mainCurrentState), "}",
Print #201, "{", Chr$(&H22) + "outMagCurrentState" + Chr$(&H22), ":", Str$(outMagCurrentState), "}",
Print #201, "{", Chr$(&H22) + "panelDataTxRdy" + Chr$(&H22), ":", Str$(panelDataTxRdy), "}",
Print #201, "{", Chr$(&H22) + "pasActualTempZone1" + Chr$(&H22), ":", Str$(pasActualTempZone1), "}",
Print #201, "{", Chr$(&H22) + "pasActualTempZone2" + Chr$(&H22), ":", Str$(pasActualTempZone2), "}",
Print #201, "{", Chr$(&H22) + "pasAlarmGroup" + Chr$(&H22), ":", Str$(pasAlarmGroup), "}",
Print #201, "{", Chr$(&H22) + "pasCoolActual" + Chr$(&H22), ":", Str$(pasCoolActual), "}",
Print #201, "{", Chr$(&H22) + "pasDwellActual" + Chr$(&H22), ":", Str$(pasDwellActual), "}",
Print #201, "{", Chr$(&H22) + "pasHeadInsertpickupextend" + Chr$(&H22), ":", Str$(pasHeadinsertpickupextend), "}",
Print #201, "{", Chr$(&H22) + "pasHeadInsertPickupRetract" + Chr$(&H22), ":", Str$(pasHeadinsertPickupRetract), "}",
Print #201, "{", Chr$(&H22) + "pasHighTempAlarm" + Chr$(&H22), ":", Str$(pasHighTempAlarm), "}",
Print #201, "{", Chr$(&H22) + "pasHome" + Chr$(&H22), ":", Str$(pasHome), "}",
Print #201, "{", Chr$(&H22) + "pasInsertDetected" + Chr$(&H22), ":", Str$(pasInsertDetected), "}",
Print #201, "{", Chr$(&H22) + "pasInsertInShuttle" + Chr$(&H22), ":", Str$(pasInsertInShuttle), "}",
Print #201, "{", Chr$(&H22) + "pasInTempZone1" + Chr$(&H22), ":", Str$(pasInTempZone1), "}",
Print #201, "{", Chr$(&H22) + "pasInTempZone2" + Chr$(&H22), ":", Str$(pasInTempZone2), "}",
Print #201, "{", Chr$(&H22) + "pasLoadMeter" + Chr$(&H22), ":", Str$(pasLoadMeter), "}",
Print #201, "{", Chr$(&H22) + "pasLowerlimit" + Chr$(&H22), ":", Str$(pasLowerlimit), "}",
Print #201, "{", Chr$(&H22) + "pasMaxLoadmeter" + Chr$(&H22), ":", Str$(pasMaxLoadmeter), "}",
Print #201, "{", Chr$(&H22) + "pasMaxTempZone1" + Chr$(&H22), ":", Str$(pasMaxTempZone1), "}",
Print #201, "{", Chr$(&H22) + "pasMaxTempZone2" + Chr$(&H22), ":", Str$(pasMaxTempZone2), "}",
Print #201, "{", Chr$(&H22) + "pasMCREStop" + Chr$(&H22), ":", Str$(pasMCREStop), "}",
Print #201, "{", Chr$(&H22) + "pasMessageDB" + Chr$(&H22), ":", Str$(pasMessageDB), "}",
Print #201, "{", Chr$(&H22) + "pasPIDsetupActualZone1" + Chr$(&H22), ":", Str$(pasPIDsetupActualZone1), "}",
Print #201, "{", Chr$(&H22) + "pasPIDsetupActualZone2" + Chr$(&H22), ":", Str$(pasPIDsetupActualZone2), "}",
Print #201, "{", Chr$(&H22) + "pasPreHeatActual" + Chr$(&H22), ":", Str$(pasPreHeatActual), "}",
Print #201, "{", Chr$(&H22) + "pasShuttleExtend" + Chr$(&H22), ":", Str$(pasShuttleExtend), "}",
Print #201, "{", Chr$(&H22) + "pasShuttleLoadPosition" + Chr$(&H22), ":", Str$(pasShuttleLoadPosition), "}",
Print #201, "{", Chr$(&H22) + "pasShuttleMidway" + Chr$(&H22), ":", Str$(pasShuttleMidway), "}",
Print #201, "{", Chr$(&H22) + "pasShuttleNoLoad" + Chr$(&H22), ":", Str$(pasShuttleNoLoad), "}",
Print #201, "{", Chr$(&H22) + "pasStart" + Chr$(&H22), ":", Str$(pasStart), "}",
Print #201, "{", Chr$(&H22) + "pasSteelInsert" + Chr$(&H22), ":", Str$(pasSteelInsert), "}",
Print #201, "{", Chr$(&H22) + "pasUpLimit" + Chr$(&H22), ":", Str$(pasUpLimit), "}",
Print #201, "{", Chr$(&H22) + "pasVerticalLocation" + Chr$(&H22), ":", Str$(pasVerticalLocation), "}",


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
	
	Select tokens$(0)
 'Rx from HMI:
 
'_____Dont delete while updating 
Case "jobAbortBtn"
   If tokens$(1) = "true" Then
       jobAbortBtn = True
       MemOn (jobAbortH)
   Else
       jobAbortBtn = False
   EndIf
   Print "jobAbortBtn:", jobAbortBtn
'__________________

Case "alarmMuteBtn"
   If tokens$(1) = "true" Then
       alarmMuteBtn = True
       alarmMute = True
   Else
       alarmMuteBtn = False
   EndIf
   Print "alarmMuteBtn:", alarmMuteBtn
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
Case "panelDataTxACKBtn"
   If Tokens$(1) = "true" Then
       panelDataTxACKBtn = True
       panelDataTxACK = True
   Else
       panelDataTxACKBtn = False
   EndIf
   Print "panelDataTxACKBtn:", panelDataTxACKBtn
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
Case "airPressHighF"
    If Tokens$(1) = "true" Then
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
Case "cbMonInMagF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonInMagF)
    Else
        MemOff (cbMonInMagF)
    EndIf
Case "cbMonInMagFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonInMagFV)
    Else
        MemOff (cbMonInMagFV)
    EndIf
Case "cbMonOutMagF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonOutMagF)
    Else
        MemOff (cbMonOutMagF)
    EndIf
Case "cbMonOutMagFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonOutMagFV)
    Else
        MemOff (cbMonOutMagFV)
    EndIf
Case "cbMonPAS24vdcF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonPAS24vdcF)
    Else
        MemOff (cbMonPAS24vdcF)
    EndIf
Case "cbMonPAS24vdcFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonPAS24vdcFV)
    Else
        MemOff (cbMonPAS24vdcFV)
    EndIf
Case "cbMonSafetyF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonSafetyF)
    Else
        MemOff (cbMonSafetyF)
    EndIf
Case "cbMonSafetyFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonSafetyFV)
    Else
        MemOff (cbMonSafetyFV)
    EndIf
Case "dc24vOKF"
    If Tokens$(1) = "true" Then
        MemOn (dc24vOKF)
    Else
        MemOff (dc24vOKF)
    EndIf
Case "dc24vOKFV"
    If Tokens$(1) = "true" Then
        MemOn (dc24vOKFV)
    Else
        MemOff (dc24vOKFV)
    EndIf
Case "edgeDetectGoF"
    If Tokens$(1) = "true" Then
        MemOn (edgeDetectGoF)
    Else
        MemOff (edgeDetectGoF)
    EndIf
Case "edgeDetectGoFV"
    If Tokens$(1) = "true" Then
        MemOn (edgeDetectGoFV)
    Else
        MemOff (edgeDetectGoFV)
    EndIf
Case "edgeDetectHiF"
    If Tokens$(1) = "true" Then
        MemOn (edgeDetectHiF)
    Else
        MemOff (edgeDetectHiF)
    EndIf
Case "edgeDetectHiFV"
    If Tokens$(1) = "true" Then
        MemOn (edgeDetectHiFV)
    Else
        MemOff (edgeDetectHiFV)
    EndIf
Case "edgeDetectLoF"
    If Tokens$(1) = "true" Then
        MemOn (edgeDetectLoF)
    Else
        MemOff (edgeDetectLoF)
    EndIf
Case "edgeDetectLoFV"
    If Tokens$(1) = "true" Then
        MemOn (edgeDetectLoFV)
    Else
        MemOff (edgeDetectLoFV)
    EndIf
Case "flashHomeNCF"
    If Tokens$(1) = "true" Then
        MemOn (flashHomeNCF)
    Else
        MemOff (flashHomeNCF)
    EndIf
Case "flashHomeNCFV"
    If Tokens$(1) = "true" Then
        MemOn (flashHomeNCFV)
    Else
        MemOff (flashHomeNCFV)
    EndIf
Case "flashHomeNOF"
    If Tokens$(1) = "true" Then
        MemOn (flashHomeNOF)
    Else
        MemOff (flashHomeNOF)
    EndIf
Case "flashHomeNOFV"
    If Tokens$(1) = "true" Then
        MemOn (flashHomeNOFV)
    Else
        MemOff (flashHomeNOFV)
    EndIf
Case "flashPnlPrsntF"
    If Tokens$(1) = "true" Then
        MemOn (FlashPnlPrsntF)
    Else
        MemOff (FlashPnlPrsntF)
    EndIf
Case "flashPnlPrsntFV"
    If Tokens$(1) = "true" Then
        MemOn (FlashPnlPrsntFV)
    Else
        MemOff (FlashPnlPrsntFV)
    EndIf
Case "frontIntlock1F"
    If Tokens$(1) = "true" Then
        MemOn (frontIntlock1F)
    Else
        MemOff (frontIntlock1F)
    EndIf
Case "frontIntlock1FV"
    If Tokens$(1) = "true" Then
        MemOn (frontIntlock1FV)
    Else
        MemOff (frontIntlock1FV)
    EndIf
Case "frontIntlock2F"
    If Tokens$(1) = "true" Then
        MemOn (frontIntlock2F)
    Else
        MemOff (frontIntlock2F)
    EndIf
Case "frontIntlock2FV"
    If Tokens$(1) = "true" Then
        MemOn (frontIntlock2FV)
    Else
        MemOff (frontIntlock2FV)
    EndIf
Case "holeDetectedF"
    If Tokens$(1) = "true" Then
        MemOn (holeDetectedF)
    Else
        MemOff (holeDetectedF)
    EndIf
Case "holeDetectedFV"
    If Tokens$(1) = "true" Then
        MemOn (holeDetectedFV)
    Else
        MemOff (holeDetectedFV)
    EndIf
Case "hsPanelPresntF"
    If Tokens$(1) = "true" Then
        MemOn (hsPanelPresntF)
    Else
        MemOff (hsPanelPresntF)
    EndIf
Case "hsPanelPresntFV"
    If Tokens$(1) = "true" Then
        MemOn (hsPanelPresntFV)
    Else
        MemOff (hsPanelPresntFV)
    EndIf
Case "inMagInterlockF"
    If Tokens$(1) = "true" Then
        MemOn (inMagInterlockF)
    Else
        MemOff (inMagInterlockF)
    EndIf
Case "inMagInterlockFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagInterlockFV)
    Else
        MemOff (inMagInterlockFV)
    EndIf
Case "inMagLowLimF"
    If Tokens$(1) = "true" Then
        MemOn (inMagLowLimF)
    Else
        MemOff (inMagLowLimF)
    EndIf
Case "inMagLowLimFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagLowLimFV)
    Else
        MemOff (inMagLowLimFV)
    EndIf
Case "inMagLowLimNF"
    If Tokens$(1) = "true" Then
        MemOn (inMagLowLimNF)
    Else
        MemOff (inMagLowLimNF)
    EndIf
Case "inMagLowLimNFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagLowLimNFV)
    Else
        MemOff (inMagLowLimNFV)
    EndIf
Case "inMagPnlRdyF"
    If Tokens$(1) = "true" Then
        MemOn (inMagPnlRdyF)
    Else
        MemOff (inMagPnlRdyF)
    EndIf
Case "inMagPnlRdyFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagPnlRdyFV)
    Else
        MemOff (inMagPnlRdyFV)
    EndIf
Case "inMagUpLimF"
    If Tokens$(1) = "true" Then
        MemOn (inMagUpLimF)
    Else
        MemOff (inMagUpLimF)
    EndIf
Case "inMagUpLimFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagUpLimFV)
    Else
        MemOff (inMagUpLimFV)
    EndIf
Case "inMagUpLimNF"
    If Tokens$(1) = "true" Then
        MemOn (inMagUpLimNF)
    Else
        MemOff (inMagUpLimNF)
    EndIf
Case "inMagUpLimNFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagUpLimNFV)
    Else
        MemOff (inMagUpLimNFV)
    EndIf
Case "leftIntlock1F"
    If Tokens$(1) = "true" Then
        MemOn (leftIntlock1F)
    Else
        MemOff (leftIntlock1F)
    EndIf
Case "leftIntlock1FV"
    If Tokens$(1) = "true" Then
        MemOn (leftIntlock1FV)
    Else
        MemOff (leftIntlock1FV)
    EndIf
Case "leftIntlock2F"
    If Tokens$(1) = "true" Then
        MemOn (leftIntlock2F)
    Else
        MemOff (leftIntlock2F)
    EndIf
Case "leftIntlock2FV"
    If Tokens$(1) = "true" Then
        MemOn (leftIntlock2FV)
    Else
        MemOff (leftIntlock2FV)
    EndIf
Case "maintModeF"
    If Tokens$(1) = "true" Then
        MemOn (maintModeF)
    Else
        MemOff (maintModeF)
    EndIf
Case "maintModeFV"
    If Tokens$(1) = "true" Then
        MemOn (maintModeFV)
    Else
        MemOff (maintModeFV)
    EndIf
Case "monEstop1F"
    If Tokens$(1) = "true" Then
        MemOn (monEstop1F)
    Else
        MemOff (monEstop1F)
    EndIf
Case "monEstop1FV"
    If Tokens$(1) = "true" Then
        MemOn (monEstop1FV)
    Else
        MemOff (monEstop1FV)
    EndIf
Case "monEstop2F"
    If Tokens$(1) = "true" Then
        MemOn (monEstop2F)
    Else
        MemOff (monEstop2F)
    EndIf
Case "monEstop2FV"
    If Tokens$(1) = "true" Then
        MemOn (monEstop2FV)
    Else
        MemOff (monEstop2FV)
    EndIf
Case "outMagIntF"
    If Tokens$(1) = "true" Then
        MemOn (outMagIntF)
    Else
        MemOff (outMagIntF)
    EndIf
Case "outMagIntFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagIntFV)
    Else
        MemOff (outMagIntFV)
    EndIf
Case "outMagLowLimF"
    If Tokens$(1) = "true" Then
        MemOn (outMagLowLimF)
    Else
        MemOff (outMagLowLimF)
    EndIf
Case "outMagLowLimFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagLowLimFV)
    Else
        MemOff (outMagLowLimFV)
    EndIf
Case "outMagLowLimNF"
    If Tokens$(1) = "true" Then
        MemOn (outMagLowLimNF)
    Else
        MemOff (outMagLowLimNF)
    EndIf
Case "outMagLowLimNFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagLowLimNFV)
    Else
        MemOff (outMagLowLimNFV)
    EndIf
Case "outMagPanelRdyF"
    If Tokens$(1) = "true" Then
        MemOn (outMagPanelRdyF)
    Else
        MemOff (outMagPanelRdyF)
    EndIf
Case "outMagPanelRdyFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagPanelRdyFV)
    Else
        MemOff (outMagPanelRdyFV)
    EndIf
Case "outMagUpLimF"
    If Tokens$(1) = "true" Then
        MemOn (outMagUpLimF)
    Else
        MemOff (outMagUpLimF)
    EndIf
Case "outMagUpLimFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagUpLimFV)
    Else
        MemOff (outMagUpLimFV)
    EndIf
Case "outMagUpLimNF"
    If Tokens$(1) = "true" Then
        MemOn (outMagUpLimNF)
    Else
        MemOff (outMagUpLimNF)
    EndIf
Case "outMagUpLimNFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagUpLimNFV)
    Else
        MemOff (outMagUpLimNFV)
    EndIf
Case "rightIntlockF"
    If Tokens$(1) = "true" Then
        MemOn (rightIntlockF)
    Else
        MemOff (rightIntlockF)
    EndIf
Case "rightIntlockFV"
    If Tokens$(1) = "true" Then
        MemOn (rightIntlockFV)
    Else
        MemOff (rightIntlockFV)
    EndIf
Case "debrisMtrF"
    If Tokens$(1) = "true" Then
        MemOn (debrisMtrF)
    Else
        MemOff (debrisMtrF)
    EndIf
Case "debrisMtrFV"
    If Tokens$(1) = "true" Then
        MemOn (debrisMtrFV)
    Else
        MemOff (debrisMtrFV)
    EndIf
Case "drillGoF"
    If Tokens$(1) = "true" Then
        MemOn (drillGoF)
    Else
        MemOff (drillGoF)
    EndIf
Case "drillGoFV"
    If Tokens$(1) = "true" Then
        MemOn (drillGoFV)
    Else
        MemOff (drillGoFV)
    EndIf
Case "drillReturnF"
    If Tokens$(1) = "true" Then
        MemOn (drillReturnF)
    Else
        MemOff (drillReturnF)
    EndIf
Case "drillReturnFV"
    If Tokens$(1) = "true" Then
        MemOn (drillReturnFV)
    Else
        MemOff (drillReturnFV)
    EndIf
Case "eStopResetF"
    If Tokens$(1) = "true" Then
        MemOn (eStopResetF)
    Else
        MemOff (eStopResetF)
    EndIf
Case "eStopResetFV"
    If Tokens$(1) = "true" Then
        MemOn (eStopResetFV)
    Else
        MemOff (eStopResetFV)
    EndIf
Case "heatStakeGoF"
    If Tokens$(1) = "true" Then
        MemOn (heatStakeGoF)
    Else
        MemOff (heatStakeGoF)
    EndIf
Case "heatStakeGoFV"
    If Tokens$(1) = "true" Then
        MemOn (heatStakeGoFV)
    Else
        MemOff (heatStakeGoFV)
    EndIf
Case "inMagMtrF"
    If Tokens$(1) = "true" Then
        MemOn (inMagMtrF)
    Else
        MemOff (inMagMtrF)
    EndIf
Case "inMagMtrFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagMtrFV)
    Else
        MemOff (inMagMtrFV)
    EndIf
Case "inMagMtrDirF"
    If Tokens$(1) = "true" Then
        MemOn (inMagMtrDirF)
    Else
        MemOff (inMagMtrDirF)
    EndIf
Case "inMagMtrDirFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagMtrDirFV)
    Else
        MemOff (inMagMtrDirFV)
    EndIf
Case "outMagMtrF"
    If Tokens$(1) = "true" Then
        MemOn (outMagMtrF)
    Else
        MemOff (outMagMtrF)
    EndIf
Case "outMagMtrFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagMtrFV)
    Else
        MemOff (outMagMtrFV)
    EndIf
Case "outMagMtrDirF"
    If Tokens$(1) = "true" Then
        MemOn (outMagMtrDirF)
    Else
        MemOff (outMagMtrDirF)
    EndIf
Case "outMagMtrDirFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagMtrDirFV)
    Else
        MemOff (outMagMtrDirFV)
    EndIf
Case "stackLightAlrmF"
    If Tokens$(1) = "true" Then
        MemOn (stackLightAlrmF)
    Else
        MemOff (stackLightAlrmF)
    EndIf
Case "stackLightAlrmFV"
    If Tokens$(1) = "true" Then
        MemOn (stackLightAlrmFV)
    Else
        MemOff (stackLightAlrmFV)
    EndIf
Case "stackLightGrnF"
    If Tokens$(1) = "true" Then
        MemOn (stackLightGrnF)
    Else
        MemOff (stackLightGrnF)
    EndIf
Case "stackLightGrnFV"
    If Tokens$(1) = "true" Then
        MemOn (stackLightGrnFV)
    Else
        MemOff (stackLightGrnFV)
    EndIf
Case "stackLightRedF"
    If Tokens$(1) = "true" Then
        MemOn (stackLightRedF)
    Else
        MemOff (stackLightRedF)
    EndIf
Case "stackLightRedFV"
    If Tokens$(1) = "true" Then
        MemOn (stackLightRedFV)
    Else
        MemOff (stackLightRedFV)
    EndIf
Case "stackLightYelF"
    If Tokens$(1) = "true" Then
        MemOn (stackLightYelF)
    Else
        MemOff (stackLightYelF)
    EndIf
Case "stackLightYelFV"
    If Tokens$(1) = "true" Then
        MemOn (stackLightYelFV)
    Else
        MemOff (stackLightYelFV)
    EndIf
Case "suctionCupsF"
    If Tokens$(1) = "true" Then
        MemOn (suctionCupsF)
    Else
        MemOff (suctionCupsF)
    EndIf
Case "suctionCupsFV"
    If Tokens$(1) = "true" Then
        MemOn (suctionCupsFV)
    Else
        MemOff (suctionCupsFV)
    EndIf
Case "insertDepthTolerance"
    insertDepthTolerance = Val(Tokens$(1))
    Print "insertDepthTolerance:", insertDepthTolerance
Case "jobNumPanels"
    jobNumPanels = Val(Tokens$(1))
    Print "jobNumPanels:", jobNumPanels
Case "pasCoolSet"
    pasCool = Val(Tokens$(1))
    Print "pasCool:", pasCool
Case "pasDwellSet"
    pasDwell = Val(Tokens$(1))
    Print "pasDwell:", pasDwell
Case "pasHeatStakingIPMSet"
    pasHeatStakingIPM = Val(Tokens$(1))
    Print "pasHeatStakingIPM:", pasHeatStakingIPM
Case "pasHomeIPMSet"
    pasHomeIPM = Val(Tokens$(1))
    Print "pasHomeIPM:", pasHomeIPM
Case "pasInsertDepthSet"
    pasInsertDepth = Val(Tokens$(1))
    Print "pasInsertDepth:", pasInsertDepth
Case "pasInsertEngageSet"
    pasInsertEngage = Val(Tokens$(1))
    Print "pasInsertEngage:", pasInsertEngage
Case "pasInsertEngageIPMSet"
    pasInsertEngageIPM = Val(Tokens$(1))
    Print "pasInsertEngageIPM:", pasInsertEngageIPM
Case "pasInsertPickupIPMSet"
    pasInsertPickupIPM = Val(Tokens$(1))
    Print "pasInsertPickupIPM:", pasInsertPickupIPM
Case "pasInsertPositionSet"
    pasInsertPosition = Val(Tokens$(1))
    Print "pasInsertPosition:", pasInsertPosition
Case "pasInsertPreheatSet"
    pasInsertPreheat = Val(Tokens$(1))
    Print "pasInsertPreheat:", pasInsertPreheat
Case "pasJogSpeedSet"
    pasJogSpeed = Val(Tokens$(1))
    Print "pasJogSpeed:", pasJogSpeed
Case "pasPIDsetupDZone1Set"
    pasPIDsetupDZone1 = Val(Tokens$(1))
    Print "pasPIDsetupDZone1:", pasPIDsetupDZone1
Case "pasPIDsetupDZone2Set"
    pasPIDsetupDZone2 = Val(Tokens$(1))
    Print "pasPIDsetupDZone2:", pasPIDsetupDZone2
Case "pasPIDsetupInTempZone1Set"
    pasPIDsetupInTempZone1 = Val(Tokens$(1))
    Print "pasPIDsetupInTempZone1:", pasPIDsetupInTempZone1
Case "pasPIDsetupInTempZone2Set"
    pasPIDsetupInTempZone2 = Val(Tokens$(1))
    Print "pasPIDsetupInTempZone2:", pasPIDsetupInTempZone2
Case "pasPIDsetupIZone1Set"
    pasPIDsetupIZone1 = Val(Tokens$(1))
    Print "pasPIDsetupIZone1:", pasPIDsetupIZone1
Case "pasPIDsetupIZone2Set"
    pasPIDsetupIZone2 = Val(Tokens$(1))
    Print "pasPIDsetupIZone2:", pasPIDsetupIZone2
Case "pasPIDsetupMaxTempZone1Set"
    pasPIDsetupMaxTempZone1 = Val(Tokens$(1))
    Print "pasPIDsetupMaxTempZone1:", pasPIDsetupMaxTempZone1
Case "pasPIDsetupMaxTempZone2Set"
    pasPIDsetupMaxTempZone2 = Val(Tokens$(1))
    Print "pasPIDsetupMaxTempZone2:", pasPIDsetupMaxTempZone2
Case "pasPIDsetupOffsetZone1Set"
    pasPIDsetupOffsetZone1 = Val(Tokens$(1))
    Print "pasPIDsetupOffsetZone1:", pasPIDsetupOffsetZone1
Case "pasPIDsetupOffsetZone2Set"
    pasPIDsetupOffsetZone2 = Val(Tokens$(1))
    Print "pasPIDsetupOffsetZone2:", pasPIDsetupOffsetZone2
Case "pasPIDsetupPZone1Set"
    pasPIDsetupPZone1 = Val(Tokens$(1))
    Print "pasPIDsetupPZone1:", pasPIDsetupPZone1
Case "pasPIDsetupPZone2Set"
    pasPIDsetupPZone2 = Val(Tokens$(1))
    Print "pasPIDsetupPZone2:", pasPIDsetupPZone2
Case "pasPIDsetupSetPointZone1Set"
    pasPIDsetupSetPointZone1 = Val(Tokens$(1))
    Print "pasPIDsetupSetPointZone1:", pasPIDsetupSetPointZone1
Case "pasPIDsetupSetPointZone2Set"
    pasPIDsetupSetPointZone2 = Val(Tokens$(1))
    Print "pasPIDsetupSetPointZone2:", pasPIDsetupSetPointZone2
Case "pasPIDShowDZone1Set"
    pasPIDShowDZone1 = Val(Tokens$(1))
    Print "pasPIDShowDZone1:", pasPIDShowDZone1
Case "pasPIDShowDZone2Set"
    pasPIDShowDZone2 = Val(Tokens$(1))
    Print "pasPIDShowDZone2:", pasPIDShowDZone2
Case "pasPIDShowIZone1Set"
    pasPIDShowIZone1 = Val(Tokens$(1))
    Print "pasPIDShowIZone1:", pasPIDShowIZone1
Case "pasPIDShowIZone2Set"
    pasPIDShowIZone2 = Val(Tokens$(1))
    Print "pasPIDShowIZone2:", pasPIDShowIZone2
Case "pasPIDShowPZone1Set"
    pasPIDShowPZone1 = Val(Tokens$(1))
    Print "pasPIDShowPZone1:", pasPIDShowPZone1
Case "pasPIDShowPZone2Set"
    pasPIDShowPZone2 = Val(Tokens$(1))
    Print "pasPIDShowPZone2:", pasPIDShowPZone2
Case "pasPIDTuneDoneZone1Set"
    If Tokens$(1) = "true" Then
 		pasPIDTuneDoneZone1 = True
 	Else
 		pasPIDTuneDoneZone1 = False
    EndIf
    Print "pasPIDTuneDoneZone1:", pasPIDTuneDoneZone1
Case "pasPIDTuneDoneZone3Set"
    If Tokens$(1) = "true" Then
 		pasPIDTuneDoneZone3 = True
 	Else
 		pasPIDTuneDoneZone3 = False
    EndIf
    Print "pasPIDTuneDoneZone3:", pasPIDTuneDoneZone3
Case "pasPIDTuneFailZone1Set"
    If Tokens$(1) = "true" Then
	 pasPIDTuneFailZone1 = True
		 Else
	 pasPIDTuneFailZone1 = False
    EndIf
    Print "pasPIDTuneFailZone1:", pasPIDTuneFailZone1
Case "pasPIDTuneFailZone2Set"
    If Tokens$(1) = "true" Then
	 pasPIDTuneFailZone2 = True
		 Else
	pasPIDTuneFailZone2 = False
    EndIf
    Print "pasPIDTuneFailZone2:", pasPIDTuneFailZone2
Case "pasRecipeSet"
    pasRecipe = Val(Tokens$(1))
    Print "pasRecipe:", pasRecipe
Case "pasSetTempZone1Set"
    pasSetTempZone1 = Val(Tokens$(1))
    Print "pasSetTempZone1:", pasSetTempZone1
Case "pasSetTempZone2Set"
    pasSetTempZone2 = Val(Tokens$(1))
    Print "pasSetTempZone2:", pasSetTempZone2
Case "pasSoftHomeSet"
    pasSoftHome = Val(Tokens$(1))
    Print "pasSoftHome:", pasSoftHome
Case "pasSoftStopSet"
    pasSoftStop = Val(Tokens$(1))
    Print "pasSoftStop:", pasSoftStop
Case "recFlashRequired"
    If Tokens$(1) = "true" Then
        recFlashRequired = True
    Else
        recFlashRequired = False
    EndIf
    Print "recFlashRequired:", recFlashRequired
Case "recInmagPickupOffset"
    recInmagPickupOffset = Val(Tokens$(1))
    Print "recInmagPickupOffset:", recInmagPickupOffset
Case "recInsertDepth"
    recInsertDepth = Val(Tokens$(1))
    Print "recInsertDepth:", recInsertDepth
Case "recFlashDwellTime"
    recFlashDwellTime = Val(Tokens$(1))
    Print "recFlashDwellTime:", recFlashDwellTime
Case "recInsertType"
    recInsertType = Val(Tokens$(1))
    Print "recInsertType:", recInsertType
Case "recNumberOfHoles"
    recNumberOfHoles = Val(Tokens$(1))
    Print "recNumberOfHoles:", recNumberOfHoles
Case "recOutmagPickupOffset"
    recOutmagPickupOffset = Val(Tokens$(1))
    Print "recOutmagPickupOffset:", recOutmagPickupOffset
Case "recPanelThickness"
    recPanelThickness = Val(Tokens$(1))
    Print "recPanelThickness:", recPanelThickness
Case "suctionWaitTime"
    suctionWaitTime = Val(Tokens$(1))
    Print "suctionWaitTime:", suctionWaitTime
Case "systemAccel"
    SystemAccel = Val(Tokens$(1))
    Print "systemAccel:", SystemAccel
Case "systemSpeed"
    SystemSpeed = Val(Tokens$(1))
    Print "systemSpeed:", SystemSpeed
Case "zlimit"
    zLimit = Val(Tokens$(1))
    Print "zlimit:", zLimit
Case "pas1inLoadInsertCylinderBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pas1inLoadInsertCylinderAddr, 1, MBTypeCoil)
   Else
       MBWrite(pas1inLoadInsertCylinderAddr, 0, MBTypeCoil)
   EndIf
   Print "pas1inLoadInsertCylinderBtn:", pas1inLoadInsertCylinderBtn
Case "pasBlowInsertBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasBlowInsertAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasBlowInsertAddr, 0, MBTypeCoil)
   EndIf
   Print "pasBlowInsertBtn:", pasBlowInsertBtn
Case "pasBowlDumpOpenBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasBowlDumpOpenAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasBowlDumpOpenAddr, 0, MBTypeCoil)
   EndIf
   Print "pasBowlDumpOpenBtn:", pasBowlDumpOpenBtn
Case "pasBowlFeederBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasBowlFeederAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasBowlFeederAddr, 0, MBTypeCoil)
   EndIf
   Print "pasBowlFeederBtn:", pasBowlFeederBtn
Case "pasGoHomeBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasGoHomeAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasGoHomeAddr, 0, MBTypeCoil)
   EndIf
   Print "pasGoHomeBtn:", pasGoHomeBtn
Case "pasHeadDownBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasHeadDownAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasHeadDownAddr, 0, MBTypeCoil)
   EndIf
   Print "pasHeadDownBtn:", pasHeadDownBtn
Case "pasHeadUpBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasHeadUpAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasHeadUpAddr, 0, MBTypeCoil)
   EndIf
   Print "pasHeadUpBtn:", pasHeadUpBtn
Case "pasInsertGripperBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasInsertGripperAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasInsertGripperAddr, 0, MBTypeCoil)
   EndIf
   Print "pasInsertGripperBtn:", pasInsertGripperBtn
Case "pasInsertTypeBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasInsertTypeAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasInsertTypeAddr, 0, MBTypeCoil)
   EndIf
   Print "pasInsertTypeBtn:", pasInsertTypeBtn
Case "pasMasterTempBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasMasterTempAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasMasterTempAddr, 0, MBTypeCoil)
   EndIf
   Print "pasMasterTempBtn:", pasMasterTempBtn
Case "pasMaxTempOnOffZone1Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasMaxTempOnOffZone1Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasMaxTempOnOffZone1Addr, 0, MBTypeCoil)
   EndIf
   Print "pasMaxTempOnOffZone1Btn:", pasMaxTempOnOffZone1Btn
Case "pasMaxTempOnOffZone2Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasMaxTempOnOffZone2Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasMaxTempOnOffZone2Addr, 0, MBTypeCoil)
   EndIf
   Print "pasMaxTempOnOffZone2Btn:", pasMaxTempOnOffZone2Btn
Case "pasOnOffZone1Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasOnOffZone1Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasOnOffZone1Addr, 0, MBTypeCoil)
   EndIf
   Print "pasOnOffZone1Btn:", pasOnOffZone1Btn
Case "pasOnOffZone2Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasOnOffZone2Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasOnOffZone2Addr, 0, MBTypeCoil)
   EndIf
   Print "pasOnOffZone2Btn:", pasOnOffZone2Btn
Case "pasOTAOnOffZone1Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasOTAOnOffZone1Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasOTAOnOffZone1Addr, 0, MBTypeCoil)
   EndIf
   Print "pasOTAOnOffZone1Btn:", pasOTAOnOffZone1Btn
Case "pasOTAOnOffZone2Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasOTAOnOffZone2Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasOTAOnOffZone2Addr, 0, MBTypeCoil)
   EndIf
   Print "pasOTAOnOffZone2Btn:", pasOTAOnOffZone2Btn
Case "pasRemoteAlarmAcknowledgeBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasRemoteAlarmAcknowledgeAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasRemoteAlarmAcknowledgeAddr, 0, MBTypeCoil)
   EndIf
   Print "pasRemoteAlarmAcknowledgeBtn:", pasRemoteAlarmAcknowledgeBtn
Case "pasResetHighTempBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasResetHighTempAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasResetHighTempAddr, 0, MBTypeCoil)
   EndIf
   Print "pasResetHighTempBtn:", pasResetHighTempBtn
Case "pasResetMaxBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasResetMaxAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasResetMaxAddr, 0, MBTypeCoil)
   EndIf
   Print "pasResetMaxBtn:", pasResetMaxBtn
Case "pasSlideExtendBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasSlideExtendAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasSlideExtendAddr, 0, MBTypeCoil)
   EndIf
   Print "pasSlideExtendBtn:", pasSlideExtendBtn
Case "pasStartPIDTuneZone1Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasStartPIDTuneZone1Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasStartPIDTuneZone1Addr, 0, MBTypeCoil)
   EndIf
   Print "pasStartPIDTuneZone1Btn:", pasStartPIDTuneZone1Btn
Case "pasStartPIDTuneZone2Btn"
   If Tokens$(1) = "true" Then
       MBWrite(pasStartPIDTuneZone2Addr, 1, MBTypeCoil)
   Else
       MBWrite(pasStartPIDTuneZone2Addr, 0, MBTypeCoil)
   EndIf
   Print "pasStartPIDTuneZone2Btn:", pasStartPIDTuneZone2Btn
Case "pasTempOnOffBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasTempOnOffAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasTempOnOffAddr, 0, MBTypeCoil)
   EndIf
   Print "pasTempOnOffBtn:", pasTempOnOffBtn
Case "pasVibTrackBtn"
   If Tokens$(1) = "true" Then
       MBWrite(pasVibTrackAddr, 1, MBTypeCoil)
   Else
       MBWrite(pasVibTrackAddr, 0, MBTypeCoil)
   EndIf
   Print "pasVibTrackBtn:", pasVibTrackBtn



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


