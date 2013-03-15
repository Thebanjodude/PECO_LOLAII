#include "Globals.INC"

Function IOTable ' This is just a sample IOTable, it needs to be populated with Actual DIO 

'Xqt IntComTest ' This just toggles bits and increments integers to test the HMI Comms
OnErr GoTo errHandler ' Define where to go when a controller error occurs
Do While True
	
'Inputs
inMagPnlRdy = IOTableBooleans(Sw(inMagPnlRdyH), MemSw(inMagPnlRdyFV), MemSw(inMagPnlRdyF))
inMagUpperLim = IOTableBooleans(Sw(inMagUpperLimH), MemSw(inMagUpperLimFV), MemSw(inMagUpperLimF))
inMagLowerLim = IOTableBooleans(Sw(inMagLowerLimH), MemSw(inMagLowerLimFV), MemSw(inMagLowerLimF))
inMagInterlock = IOTableBooleans(Sw(inMagInterlockH), MemSw(inMagInterlockFV), MemSw(inMagInterlockF))
outMagPanelRdy = IOTableBooleans(Sw(outMagPanelRdyH), MemSw(outMagPanelRdyFV), MemSw(outMagPanelRdyF))
outMagUpperLim = IOTableBooleans(Sw(outMagUpperLimH), MemSw(outMagUpperLimFV), MemSw(outMagUpperLimF))
outMagLowerLim = IOTableBooleans(Sw(outMagLowerLimH), MemSw(outMagLowerLimFV), MemSw(outMagLowerLimF))
outMagInt = IOTableBooleans(Sw(outMagIntH), MemSw(outMagIntFV), MemSw(outMagIntF))
flashPnlPrsnt = IOTableBooleans(Sw(FlashPnlPrsntH), MemSw(FlashPnlPrsntFV), MemSw(FlashPnlPrsntF))
hsPanelPresnt = IOTableBooleans(Sw(HSPanelPresntH), MemSw(hsPanelPresntFV), MemSw(hsPanelPresntF))
leftInterlock = IOTableBooleans(Sw(leftInterlockH), MemSw(leftInterlockFV), MemSw(leftInterlockF))
rightInterlock = IOTableBooleans(Sw(rightInterlockH), MemSw(rightInterlockFV), MemSw(rightInterlockF))
frontInterlock = IOTableBooleans(Sw(frontInterlockH), MemSw(frontInterlockFV), MemSw(frontInterlockF))
airPressHigh = IOTableBooleans(Sw(AirPressHighH), MemSw(airPressHighFV), MemSw(airPressHighF))
airPressLow = IOTableBooleans(Sw(AirPressLowH), MemSw(airPressLowFV), MemSw(airPressLowF))
cbMonHeatStake = IOTableBooleans(Sw(cbMonHeatStakeH), MemSw(cbMonHeatStakeFV), MemSw(cbMonHeatStakeF))
cbMonBowlFeder = IOTableBooleans(Sw(cbMonBowlFederH), MemSw(cbMonBowlFederFV), MemSw(cbMonBowlFederF))
cbMonInMag = IOTableBooleans(Sw(cbMonInMagH), MemSw(cbMonInMagFV), MemSw(cbMonInMagF))
cbMonOutMag = IOTableBooleans(Sw(cbMonOutMagH), MemSw(cbMonOutMagFV), MemSw(cbMonOutMagF))
cbMonFlashRmv = IOTableBooleans(Sw(cbMonFlashRmvH), MemSw(cbMonFlashRmvFV), MemSw(cbMonFlashRmvF))
cbMonDebrisRmv = IOTableBooleans(Sw(cbMonDebrisRmvH), MemSw(cbMonDebrisRmvFV), MemSw(cbMonDebrisRmvF))
dcPwrOk = IOTableBooleans(Sw(dcPwrOkH), MemSw(dcPwrOkFV), MemSw(dcPwrOkF))
cbMonPnumatic = IOTableBooleans(Sw(cbMonPnumaticH), MemSw(cbMonPnumaticFV), MemSw(cbMonPnumaticF))
cbMonSafety = IOTableBooleans(Sw(cbMonSafetyH), MemSw(cbMonSafetyFV), MemSw(cbMonSafetyF))
cbMonPAS24vdc = IOTableBooleans(Sw(cbMonPAS24vdcH), MemSw(cbMonPAS24vdcFV), MemSw(cbMonPAS24vdcF))

'Outputs
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
flashMtr = IOTableBooleans(flashMtrCC, MemSw(flashMtrFV), MemSw(flashMtrF))
If flashMtr = True Then
        On (flashMtrH)
    Else
        Off (flashMtrH)
    EndIf
flashCyc = IOTableBooleans(flashCycCC, MemSw(flashCycFV), MemSw(flashCycF))
If flashCyc = True Then
        On (flashCycH)
    Else
        Off (flashCycH)
    EndIf
suctionCups = IOTableBooleans(suctionCupsCC, MemSw(suctionCupsFV), MemSw(suctionCupsF))
If suctionCups = True Then
        On (suctionCupsH)
    Else
        Off (suctionCupsH)
    EndIf
debrisMtr = IOTableBooleans(debrisMtrCC, MemSw(debrisMtrFV), MemSw(debrisMtrF))
If debrisMtr = True Then
        On (debrisMtrH)
    Else
        Off (debrisMtrH)
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
stackLightGrn = IOTableBooleans(stackLightGrnCC, MemSw(stackLightGrnFV), MemSw(stackLightGrnF))
If stackLightGrn = True Then
        On (stackLightGrnH)
    Else
        Off (stackLightGrnH)
    EndIf
stackLightAlrm = IOTableBooleans(stackLightAlrmCC, MemSw(stackLightAlrmFV), MemSw(stackLightAlrmF))
If stackLightAlrm = True Then
        On (stackLightAlrmH)
    Else
        Off (stackLightAlrmH)
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

			'Tx to HMI:
Print #201, "{", Chr$(&H22) + "inMagMtr" + Chr$(&H22), ":", Str$(inMagMtr), "}"
Print #201, "{", Chr$(&H22) + "inMagMtrDir" + Chr$(&H22), ":", Str$(inMagMtrDir), "}"
Print #201, "{", Chr$(&H22) + "inMagPnlRdy" + Chr$(&H22), ":", Str$(inMagPnlRdy), "}"
Print #201, "{", Chr$(&H22) + "inMagUpperLim" + Chr$(&H22), ":", Str$(inMagUpperLim), "}"
Print #201, "{", Chr$(&H22) + "inMagLowerLim" + Chr$(&H22), ":", Str$(inMagLowerLim), "}"
Print #201, "{", Chr$(&H22) + "inMagInterlock" + Chr$(&H22), ":", Str$(inMagInterlock), "}"
Print #201, "{", Chr$(&H22) + "outMagMtr" + Chr$(&H22), ":", Str$(outMagMtr), "}"
Print #201, "{", Chr$(&H22) + "outMagMtrDir" + Chr$(&H22), ":", Str$(outMagMtrDir), "}"
Print #201, "{", Chr$(&H22) + "outMagPanelRdy" + Chr$(&H22), ":", Str$(outMagPanelRdy), "}"
Print #201, "{", Chr$(&H22) + "outMagUpperLim" + Chr$(&H22), ":", Str$(outMagUpperLim), "}"
Print #201, "{", Chr$(&H22) + "outMagLowerLim" + Chr$(&H22), ":", Str$(outMagLowerLim), "}"
Print #201, "{", Chr$(&H22) + "outMagInt" + Chr$(&H22), ":", Str$(outMagInt), "}"
Print #201, "{", Chr$(&H22) + "flashMtr" + Chr$(&H22), ":", Str$(flashMtr), "}"
Print #201, "{", Chr$(&H22) + "flashCyc" + Chr$(&H22), ":", Str$(flashCyc), "}"
Print "unplug now"
Wait 2
Print #201, "{", Chr$(&H22) + "flashPnlPrsnt" + Chr$(&H22), ":", Str$(FlashPnlPrsnt), "}"
Print #201, "{", Chr$(&H22) + "hsPanelPresnt" + Chr$(&H22), ":", Str$(hsPanelPresnt), "}"
Print #201, "{", Chr$(&H22) + "leftInterlock" + Chr$(&H22), ":", Str$(leftInterlock), "}"
Print #201, "{", Chr$(&H22) + "rightInterlock" + Chr$(&H22), ":", Str$(rightInterlock), "}"
Print #201, "{", Chr$(&H22) + "frontInterlock" + Chr$(&H22), ":", Str$(frontInterlock), "}"
Print #201, "{", Chr$(&H22) + "airPressHigh" + Chr$(&H22), ":", Str$(airPressHigh), "}"
Print #201, "{", Chr$(&H22) + "airPressLow" + Chr$(&H22), ":", Str$(airPressLow), "}"
Print #201, "{", Chr$(&H22) + "hsInstallInsrt" + Chr$(&H22), ":", Str$(hsInstallInsrt), "}"
Print #201, "{", Chr$(&H22) + "cbMonHeatStake" + Chr$(&H22), ":", Str$(cbMonHeatStake), "}"
Print #201, "{", Chr$(&H22) + "cbMonBowlFeder" + Chr$(&H22), ":", Str$(cbMonBowlFeder), "}"
Print #201, "{", Chr$(&H22) + "cbMonInMag" + Chr$(&H22), ":", Str$(cbMonInMag), "}"
Print #201, "{", Chr$(&H22) + "cbMonOutMag" + Chr$(&H22), ":", Str$(cbMonOutMag), "}"
Print #201, "{", Chr$(&H22) + "cbMonFlashRmv" + Chr$(&H22), ":", Str$(cbMonFlashRmv), "}"
Print #201, "{", Chr$(&H22) + "cbMonDebrisRmv" + Chr$(&H22), ":", Str$(cbMonDebrisRmv), "}"
Print #201, "{", Chr$(&H22) + "dcPwrOk" + Chr$(&H22), ":", Str$(dcPwrOk), "}"
Print #201, "{", Chr$(&H22) + "cbMonPnumatic" + Chr$(&H22), ":", Str$(cbMonPnumatic), "}"
Print #201, "{", Chr$(&H22) + "cbMonSafety" + Chr$(&H22), ":", Str$(cbMonSafety), "}"
Print #201, "{", Chr$(&H22) + "cbMonPAS24vdc" + Chr$(&H22), ":", Str$(cbMonPAS24vdc), "}"
Print #201, "{", Chr$(&H22) + "systemStatus" + Chr$(&H22), ":", Str$(systemStatus), "}"
Print #201, "{", Chr$(&H22) + "jobNumPanelsDone" + Chr$(&H22), ":", Str$(jobNumPanelsDone), "}"
'Print #201, "{", Chr$(&H22) + "jobNextPanel" + Chr$(&H22), ":", Str$(jobNextPanel), "}"
Print #201, "{", Chr$(&H22) + "jobDone" + Chr$(&H22), ":", Str$(jobDone), "}"
Print #201, "{", Chr$(&H22) + "hmiPause" + Chr$(&H22), ":", Str$(hmiPause), "}"
'Print #201, "{", Chr$(&H22) + "hmiResume" + Chr$(&H22), ":", Str$(hmiResume), "}"
Print #201, "{", Chr$(&H22) + "hsProbeTemp" + Chr$(&H22), ":", Str$(hsProbeTemp), "}"
Print #201, "{", Chr$(&H22) + "suctionCups" + Chr$(&H22), ":", Str$(suctionCups), "}"
Print #201, "{", Chr$(&H22) + "erUnknown" + Chr$(&H22), ":", Str$(erUnknown), "}"
Print #201, "{", Chr$(&H22) + "erEstop" + Chr$(&H22), ":", Str$(erEstop), "}"
Print #201, "{", Chr$(&H22) + "erPanelFailedInspection" + Chr$(&H22), ":", Str$(erPanelFailedInspection), "}"
Print #201, "{", Chr$(&H22) + "erFrontSafetyFrameOpen" + Chr$(&H22), ":", Str$(erFrontSafetyFrameOpen), "}"
Print #201, "{", Chr$(&H22) + "erBackSafetyFrameOpen" + Chr$(&H22), ":", Str$(erBackSafetyFrameOpen), "}"
Print #201, "{", Chr$(&H22) + "erLeftSafetyFrameOpen" + Chr$(&H22), ":", Str$(erLeftSafetyFrameOpen), "}"
Print #201, "{", Chr$(&H22) + "erRightSafetyFrameOpen" + Chr$(&H22), ":", Str$(erRightSafetyFrameOpen), "}"
Print #201, "{", Chr$(&H22) + "erLowPressure" + Chr$(&H22), ":", Str$(erLowPressure), "}"
Print #201, "{", Chr$(&H22) + "erHighPressure" + Chr$(&H22), ":", Str$(erHighPressure), "}"
Print #201, "{", Chr$(&H22) + "erPanelStatusUnknown" + Chr$(&H22), ":", Str$(erPanelStatusUnknown), "}"
Print #201, "{", Chr$(&H22) + "erWrongPanelHoles" + Chr$(&H22), ":", Str$(erWrongPanelHoles), "}"
Print #201, "{", Chr$(&H22) + "erWrongPanelDims" + Chr$(&H22), ":", Str$(erWrongPanelDims), "}"
Print #201, "{", Chr$(&H22) + "erWrongPanel" + Chr$(&H22), ":", Str$(erWrongPanel), "}"
Print #201, "{", Chr$(&H22) + "erWrongPanelInsert" + Chr$(&H22), ":", Str$(erWrongPanelInsert), "}"
Print #201, "{", Chr$(&H22) + "erInMagEmpty" + Chr$(&H22), ":", Str$(erInMagEmpty), "}"
Print #201, "{", Chr$(&H22) + "erInMagOpenInterlock" + Chr$(&H22), ":", Str$(erInMagOpenInterlock), "}"
Print #201, "{", Chr$(&H22) + "erInMagCrowding" + Chr$(&H22), ":", Str$(erInMagCrowding), "}"
Print #201, "{", Chr$(&H22) + "erOutMagFull" + Chr$(&H22), ":", Str$(erOutMagFull), "}"
Print #201, "{", Chr$(&H22) + "erOutMagOpenInterlock" + Chr$(&H22), ":", Str$(erOutMagOpenInterlock), "}"
Print #201, "{", Chr$(&H22) + "erOutMagCrowding" + Chr$(&H22), ":", Str$(erOutMagCrowding), "}"
Print #201, "{", Chr$(&H22) + "erLaserScanner" + Chr$(&H22), ":", Str$(erLaserScanner), "}"
Print #201, "{", Chr$(&H22) + "erDCPower" + Chr$(&H22), ":", Str$(erDCPower), "}"
Print #201, "{", Chr$(&H22) + "erDCPowerHeatStake" + Chr$(&H22), ":", Str$(erDCPowerHeatStake), "}"
Print #201, "{", Chr$(&H22) + "erHeatStakeBreaker" + Chr$(&H22), ":", Str$(erHeatStakeBreaker), "}"
Print #201, "{", Chr$(&H22) + "erBowlFeederBreaker" + Chr$(&H22), ":", Str$(erBowlFeederBreaker), "}"
Print #201, "{", Chr$(&H22) + "erInMagBreaker" + Chr$(&H22), ":", Str$(erInMagBreaker), "}"
Print #201, "{", Chr$(&H22) + "erOutMagBreaker" + Chr$(&H22), ":", Str$(erOutMagBreaker), "}"
Print #201, "{", Chr$(&H22) + "erFlashBreaker" + Chr$(&H22), ":", Str$(erFlashBreaker), "}"
Print #201, "{", Chr$(&H22) + "erDebrisRemovalBreaker" + Chr$(&H22), ":", Str$(erDebrisRemovalBreaker), "}"
Print #201, "{", Chr$(&H22) + "erPnumaticsBreaker" + Chr$(&H22), ":", Str$(erPnumaticsBreaker), "}"
Print #201, "{", Chr$(&H22) + "erSafetySystemBreaker" + Chr$(&H22), ":", Str$(erSafetySystemBreaker), "}"
Print #201, "{", Chr$(&H22) + "erRC180" + Chr$(&H22), ":", Str$(erRC180), "}"
Print #201, "{", Chr$(&H22) + "homePositionStatus" + Chr$(&H22), ":", Str$(homePositionStatus), "}"
Print #201, "{", Chr$(&H22) + "motorOnStatus" + Chr$(&H22), ":", Str$(motorOnStatus), "}"
Print #201, "{", Chr$(&H22) + "motorPowerStatus" + Chr$(&H22), ":", Str$(motorPowerStatus), "}"
Print #201, "{", Chr$(&H22) + "joint1Status" + Chr$(&H22), ":", Str$(joint1Status), "}"
Print #201, "{", Chr$(&H22) + "joint2Status" + Chr$(&H22), ":", Str$(joint2Status), "}"
Print #201, "{", Chr$(&H22) + "joint3Status" + Chr$(&H22), ":", Str$(joint3Status), "}"
Print #201, "{", Chr$(&H22) + "joint4Status" + Chr$(&H22), ":", Str$(joint4Status), "}"
Print #201, "{", Chr$(&H22) + "eStopStatus" + Chr$(&H22), ":", Str$(eStopStatus), "}"
Print #201, "{", Chr$(&H22) + "errorStatus" + Chr$(&H22), ":", Str$(errorStatus), "}"
Print #201, "{", Chr$(&H22) + "tasksRunningStatus" + Chr$(&H22), ":", Str$(tasksRunningStatus), "}"
Print #201, "{", Chr$(&H22) + "pauseStatus" + Chr$(&H22), ":", Str$(pauseStatus), "}"
Print #201, "{", Chr$(&H22) + "teachModeStatus" + Chr$(&H22), ":", Str$(teachModeStatus), "}"
Print #201, "{", Chr$(&H22) + "safeGuardInput" + Chr$(&H22), ":", Str$(safeGuardInput), "}"
'Print #201, "{", Chr$(&H22) + "ctrlrErrMsg" + Chr$(&H22), ":", Str$(ctrlrErrMsg), "}"
Print #201, "{", Chr$(&H22) + "ctrlrLineNumber" + Chr$(&H22), ":", Str$(ctrlrLineNumber), "}"
Print #201, "{", Chr$(&H22) + "ctrlrTaskNumber" + Chr$(&H22), ":", Str$(ctrlrTaskNumber), "}"
Print #201, "{", Chr$(&H22) + "ctrlrErrAxisNumber" + Chr$(&H22), ":", Str$(ctrlrErrAxisNumber), "}"
Print #201, "{", Chr$(&H22) + "ctrlrErrorNum" + Chr$(&H22), ":", Str$(ctrlrErrorNum), "}"
Print #201, "{", Chr$(&H22) + "inMagCurrentState" + Chr$(&H22), ":", Str$(inMagCurrentState), "}"
Print #201, "{", Chr$(&H22) + "outMagCurrentState" + Chr$(&H22), ":", Str$(outMagCurrentState), "}"
Print #201, "{", Chr$(&H22) + "debrisMtr" + Chr$(&H22), ":", Str$(debrisMtr), "}"
Print #201, "{", Chr$(&H22) + "stackLightRed" + Chr$(&H22), ":", Str$(stackLightRed), "}"
Print #201, "{", Chr$(&H22) + "stackLightYel" + Chr$(&H22), ":", Str$(stackLightYel), "}"
Print #201, "{", Chr$(&H22) + "stackLightGrn" + Chr$(&H22), ":", Str$(stackLightGrn), "}"
Print #201, "{", Chr$(&H22) + "stackLightAlrm" + Chr$(&H22), ":", Str$(stackLightAlrm), "}"

'            	Print #201, "Laser Measurement = ", g_LaserMeasure
        EndIf
	Loop
Fend
' This task runs continuously in the background listening
'   for input from the HMI and updating global variables
Function HmiListen()
                
    Integer i, j, NumTokens
    String Tokens$(0)
    String response$
    String outstring$
    String match$
                
    ' define the connection to the HMI
    SetNet #202, "10.22.251.68", 1503, CRLF, NONE, 0
    
    match$ = "{:} " + Chr$(&H22)
 
    Do While True 'g_io_xfr_on = 1

        If ChkNet(202) < 0 Then ' If port is not open
            OpenNet #202 As Server
        Else
            i = ChkNet(202)
            If i > 0 Then
            	Read #202, response$, i
            	'numTokens = ParseStr(inputString, tokens$(), delimiters)
				NumTokens = ParseStr(response$, Tokens$(), match$)
				Print "Number of Tokens is: ", NumTokens
				Print response$
				Select Tokens$(0)
 
 
 
 'Rx from HMI:
Case "inMagGoHome"
   If Tokens$(1) = "true" Then
       inMagGoHome = True
   Else
       inMagGoHome = False
   EndIf
   Print "inMagGoHome:", inMagGoHome
Case "outMagGoHome"
   If Tokens$(1) = "true" Then
       outMagGoHome = True
   Else
       outMagGoHome = False
   EndIf
   Print "outMagGoHome:", outMagGoHome
Case "inMagLoaded"
   If Tokens$(1) = "true" Then
       inMagLoaded = True
   Else
       inMagLoaded = False
   EndIf
   Print "inMagLoaded:", inMagLoaded
Case "outMagUnloaded"
   If Tokens$(1) = "true" Then
       outMagUnloaded = True
   Else
       outMagUnloaded = False
   EndIf
   Print "outMagUnloaded:", outMagUnloaded
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
Case "inMagUpperLimF"
    If Tokens$(1) = "true" Then
        MemOn (inMagUpperLimF)
    Else
        MemOff (inMagUpperLimF)
    EndIf
Case "inMagUpperLimFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagUpperLimFV)
    Else
        MemOff (inMagUpperLimFV)
    EndIf
Case "inMagLowerLimF"
    If Tokens$(1) = "true" Then
        MemOn (inMagLowerLimF)
    Else
        MemOff (inMagLowerLimF)
    EndIf
Case "inMagLowerLimFV"
    If Tokens$(1) = "true" Then
        MemOn (inMagLowerLimFV)
    Else
        MemOff (inMagLowerLimFV)
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
Case "inMagIntLockAck"
   If Tokens$(1) = "true" Then
       inMagIntLockAck = True
   Else
       inMagIntLockAck = False
   EndIf
   Print "inMagIntLockAck:", inMagIntLockAck
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
Case "outMagUpperLimF"
    If Tokens$(1) = "true" Then
        MemOn (outMagUpperLimF)
    Else
        MemOff (outMagUpperLimF)
    EndIf
Case "outMagUpperLimFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagUpperLimFV)
    Else
        MemOff (outMagUpperLimFV)
    EndIf
Case "outMagLowerLimF"
    If Tokens$(1) = "true" Then
        MemOn (outMagLowerLimF)
    Else
        MemOff (outMagLowerLimF)
    EndIf
Case "outMagLowerLimFV"
    If Tokens$(1) = "true" Then
        MemOn (outMagLowerLimFV)
    Else
        MemOff (outMagLowerLimFV)
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
Case "outMagIntLockAck"
   If Tokens$(1) = "true" Then
       outMagIntLockAck = True
   Else
       outMagIntLockAck = False
   EndIf
   Print "outMagIntLockAck:", outMagIntLockAck
Case "flashMtrF"
    If Tokens$(1) = "true" Then
        MemOn (flashMtrF)
    Else
        MemOff (flashMtrF)
    EndIf
Case "flashMtrFV"
    If Tokens$(1) = "true" Then
        MemOn (flashMtrFV)
    Else
        MemOff (flashMtrFV)
    EndIf
Case "flashCycF"
    If Tokens$(1) = "true" Then
        MemOn (flashCycF)
    Else
        MemOff (flashCycF)
    EndIf
Case "flashCycFV"
    If Tokens$(1) = "true" Then
        MemOn (flashCycFV)
    Else
        MemOff (flashCycFV)
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
Case "recNumberOfHoles"
    recNumberOfHoles = Val(Tokens$(1))
    Print "recNumberOfHoles:", recNumberOfHoles
Case "recFlashRequired"
    If Tokens$(1) = "true" Then
        recFlashRequired = True
    Else
        recFlashRequired = False
    EndIf
    Print "recFlashRequired:", recFlashRequired
Case "recZDropOff"
    recZDropOff = Val(Tokens$(1))
    Print "recZDropOff:", recZDropOff
Case "recInsertType"
    recInsertType = Val(Tokens$(1))
    Print "recInsertType:", recInsertType
Case "recInsertDepth"
    recInsertDepth = Val(Tokens$(1))
    Print "recInsertDepth:", recInsertDepth
Case "recMajorDim"
    recMajorDim = Val(Tokens$(1))
    Print "recMajorDim:", recMajorDim
Case "recMinorDim"
    recMinorDim = Val(Tokens$(1))
    Print "recMinorDim:", recMinorDim
Case "sftyFrmIlockAck"
   If Tokens$(1) = "true" Then
       sftyFrmIlockAck = True
   Else
       sftyFrmIlockAck = False
   EndIf
   Print "sftyFrmIlockAck:", sftyFrmIlockAck
Case "leftInterlockF"
    If Tokens$(1) = "true" Then
        MemOn (leftInterlockF)
    Else
        MemOff (leftInterlockF)
    EndIf
Case "leftInterlockFV"
    If Tokens$(1) = "true" Then
        MemOn (leftInterlockFV)
    Else
        MemOff (leftInterlockFV)
    EndIf
Case "leftInterlockACK"
   If Tokens$(1) = "true" Then
       leftInterlockACK = True
   Else
       leftInterlockACK = False
   EndIf
   Print "leftInterlockACK:", leftInterlockACK
Case "rightInterlockF"
    If Tokens$(1) = "true" Then
        MemOn (rightInterlockF)
    Else
        MemOff (rightInterlockF)
    EndIf
Case "rightInterlockFV"
    If Tokens$(1) = "true" Then
        MemOn (rightInterlockFV)
    Else
        MemOff (rightInterlockFV)
    EndIf
Case "rightInterlockACK"
   If Tokens$(1) = "true" Then
       rightInterlockACK = True
   Else
       rightInterlockACK = False
   EndIf
   Print "rightInterlockACK:", rightInterlockACK
Case "backInterlockACK"
   If Tokens$(1) = "true" Then
       backInterlockACK = True
   Else
       backInterlockACK = False
   EndIf
   Print "backInterlockACK:", backInterlockACK
Case "frontInterlockF"
    If Tokens$(1) = "true" Then
        MemOn (frontInterlockF)
    Else
        MemOff (frontInterlockF)
    EndIf
Case "frontInterlockFV"
    If Tokens$(1) = "true" Then
        MemOn (frontInterlockFV)
    Else
        MemOff (frontInterlockFV)
    EndIf
Case "frontInterlockACK"
   If Tokens$(1) = "true" Then
       frontInterlockACK = True
   Else
       frontInterlockACK = False
   EndIf
   Print "frontInterlockACK:", frontInterlockACK
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
Case "cbMonBowlFederF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonBowlFederF)
    Else
        MemOff (cbMonBowlFederF)
    EndIf
Case "cbMonBowlFederFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonBowlFederFV)
    Else
        MemOff (cbMonBowlFederFV)
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
Case "cbMonFlashRmvF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonFlashRmvF)
    Else
        MemOff (cbMonFlashRmvF)
    EndIf
Case "cbMonFlashRmvFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonFlashRmvFV)
    Else
        MemOff (cbMonFlashRmvFV)
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
Case "dcPwrOkF"
    If Tokens$(1) = "true" Then
        MemOn (dcPwrOkF)
    Else
        MemOff (dcPwrOkF)
    EndIf
Case "dcPwrOkFV"
    If Tokens$(1) = "true" Then
        MemOn (dcPwrOkFV)
    Else
        MemOff (dcPwrOkFV)
    EndIf
Case "cbMonPnumaticF"
    If Tokens$(1) = "true" Then
        MemOn (cbMonPnumaticF)
    Else
        MemOff (cbMonPnumaticF)
    EndIf
Case "cbMonPnumaticFV"
    If Tokens$(1) = "true" Then
        MemOn (cbMonPnumaticFV)
    Else
        MemOff (cbMonPnumaticFV)
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
Case "anvilZlimit"
    AnvilZlimit = Val(Tokens$(1))
    Print "anvilZlimit:", AnvilZlimit
Case "systemSpeed"
    SystemSpeed = Val(Tokens$(1))
    Print "systemSpeed:", SystemSpeed
Case "recTemp"
    recTemp = Val(Tokens$(1))
    Print "recTemp:", recTemp
Case "jobNumPanels"
Case "hmiStopJob"
   If Tokens$(1) = "true" Then
       hmiStopJob = True
   Else
       hmiStopJob = False
   EndIf
   Print "hmiStopJob:", hmiStopJob
Case "robStart"
   If Tokens$(1) = "true" Then
       robStart = True
   Else
       robStart = False
   EndIf
   Print "robStart:", robStart
Case "robStop"
   If Tokens$(1) = "true" Then
       robStop = True
   Else
       robStop = False
   EndIf
   Print "robStop:", robStop
Case "robPause"
   If Tokens$(1) = "true" Then
       robPause = True
   Else
       robPause = False
   EndIf
   Print "robPause:", robPause
Case "robResume"
   If Tokens$(1) = "true" Then
       robResume = True
   Else
       robResume = False
   EndIf
   Print "robResume:", robResume
Case "recBossHeight"
    recBossHeight = Val(Tokens$(1))
    Print "recBossHeight:", recBossHeight
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

				Default
						' TMH for now print come back and do something useful
						'Print "Invalid Token received"
				Send
            EndIf
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
            	NumTokens = ParseStr(response$, Tokens$(), ",")
'  				g_LaserMeasure = Val(Tokens$(1))
                Print "Measurement: ", response$
            EndIf
'	Loop
Fend
Function IntComTest()
	Do While True
	'ints
	systemStatus = systemStatus + 1
	jobNumPanelsDone = jobNumPanelsDone + 2
	hsProbeTemp = hsProbeTemp + 3
	hmiStatus = hmiStatus + 4
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
'' How to use the IOT Functions with DIO and Vars
'
''	'Digital Inputs	
''	InputVar0 = IOTableFunction(Sw(Input0), MemSw(HMIInput0), MemSw(ForceInput0))
''	Print InputVar0 ' Print for troubleshooting
'	
''	'Digital Outputs	
''	OutputVar0RealWorld = IOTableFunction(OutputVar0, MemSw(HMIOutput0), MemSw(ForceOutput0))
''	If OutputVar0RealWorld = True Then
''		On Output0
''	Else
''		Off Output0
''	EndIf
 'Parameters to run the system, Integers
'	SystemSpeed = IOTableIntegers(SystemSpeedDef, SystemSpeedFV, MemSw(SystemSpeedF))
'	' for testing
'	x = IOTableIntegers(xh, xhFV, MemSw(xhF))
