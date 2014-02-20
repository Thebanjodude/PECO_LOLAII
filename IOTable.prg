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
	OnErr GoTo errHandler
	
	Do While True

		'Dont Delete when updating-------------
		drillReturn = IOTableBooleans(drillReturnCC, MemSw(drillReturnFV), MemSw(drillReturnF))
		If drillReturn = True Then
			If ReturnFlag = False Then
				On (DrillReturnH), .25, 0
				ReturnFlag = True
			Else
				drillReturnCC = False
				' ************************************************************
				' *********                                          *********
				' *********  Why are we fiddling with forced values? *********
				' *********                                          *********
				' ************************************************************
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

		drillGo = IOTableBooleans(drillGoCC, MemSw(drillGoFV), MemSw(drillGoF))
		If drillGo = True Then
			On (DrillGoH)
		Else
			Off (DrillGoH)
		EndIf

		eStopReset = IOTableBooleans(eStopResetCC, MemSw(eStopResetFV), MemSw(eStopResetF))
		If eStopReset = True Then
			On (eStopResetH)
		Else
			Off (eStopResetH)
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
		
		crowding = IOTableBooleans(crowdingCC, MemSw(crowdingFV), MemSw(crowdingF))
		If crowding = True Then
			On CrowdingH
		Else
			Off CrowdingH
		EndIf
		
		crowdingX = IOTableBooleans(crowdingXCC, MemSw(crowdingXFV), MemSw(crowdingXF))
		If crowdingX = True Then
			On crowdingXH
		Else
			Off crowdingXH
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
	
	' we will not recover short of a reboot anyway... so....
	Quit IOTableOutputs
	
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
' writes and reads variables to HMI
                
	Integer i, j
	String response$
	String outstring$
    
	' some vars to hold the old values
	' this will need to be cleaned up, currently it is just a copy of all the global vars
	' ===========================================================================
	' To recreate this list:  
	'
	' `awk '{ gsub("," ,"\n"$1);  print}' vars | awk '{sub(/$/, "Old");print}' -  | sort > varsNew` 
	'
	'  where vars is a list of vars without any #defines or blank lines or comments or so forth...  (and no arrays)
	' ===========================================================================
   
	Boolean abortJobBtnOld
	Boolean abortjobOld
	Boolean airPressHighOld
	Boolean airPressLowOld
	Boolean alarmMuteBtnOld
	Boolean alarmMuteOld
	Boolean alarmTogOld
	Boolean backInterlockACKBtnOld
	Boolean backInterlockACKOld
	Boolean backIntlock1Old
	Boolean backIntlock2Old
	Boolean cbMonDebrisRmvOld
	Boolean cbMonHeatStakeOld
	Boolean cbMonInMagOld
	Boolean cbMonOutMagOld
	Boolean cbMonPAS24vdcOld
	Boolean cbMonSafetyOld
	Boolean dc24vOKOld
	Boolean debrisMtrCCOld
	Boolean debrisMtrOld
	Boolean drillGoCCOld
	Boolean drillGoOld
	Boolean drillReturnCCOld
	Boolean drillReturnOld
	Boolean edgeDetectGoOld
	Boolean edgeDetectHiOld
	Boolean edgeDetectLoOld
	Boolean flashHomeNCOld
	Boolean erBackSafetyFrameOpenOld
	Boolean erBadPressureSensorOld
	Boolean erBowlFeederBreakerOld
	Boolean erDCPowerHeatStakeOld
	Boolean erDCPowerOld
	Boolean erDebrisRemovalBreakerOld
	Boolean erEstopOld
	Boolean erFlashBreakerOld
	Boolean erFlashStationOld
	Boolean erFrontSafetyFrameOpenOld
	Boolean erHeatStakeBreakerOld
	Boolean erHeatStakeTempOld
	Boolean erHighPressureOld
	Boolean erHMICommunicationOld
	Boolean erHmiDataAckOld
	Boolean erIllegalArmMoveOld
	Boolean erInMagBreakerOld
	Boolean erInMagCrowdingOld
	Boolean erInMagEmptyOld
	Boolean erInMagLowSensorBadOld
	Boolean erInMagOpenInterlockOld
	Boolean erInMagUpSensorBadOld
	Boolean erLaserScannerOld
	Boolean erLeftSafetyFrameOpenOld
	Boolean erLowPressureOld
	Boolean erModbusCommandOld
	Boolean erModbusPortOld
	Boolean erModbusTimeoutOld
	Boolean erOutMagBreakerOld
	Boolean erOutMagCrowdingOld
	Boolean erOutMagFullOld
	Boolean erOutMagLowSensorBadOld
	Boolean erOutMagOpenInterlockOld
	Boolean erOutMagUpSensorBadOld
	Boolean erPanelFailedInspectionOld
	Boolean erPanelStatusUnknownOld
	Boolean erPanelUndefinedOld
	Boolean erParamEntryMissingOld
	Boolean erPnumaticsBreakerOld
	Boolean erRC180Old
	Boolean erRecEntryMissingOld
	Boolean erRightSafetyFrameOpenOld
	Boolean erRobotNotAtHomeOld
	Boolean errorStatusOld
	Boolean erSafetySystemBreakerOld
	Boolean erUnknownOld
	Boolean erWrongPanelDimsOld
	Boolean erWrongPanelHolesOld
	Boolean erWrongPanelInsertOld
	Boolean erWrongPanelOld
	Boolean eStopResetCCOld
	Boolean eStopResetOld
	Boolean eStopStatusOld
	Boolean FlashHomeCCOld
	Boolean flashHomeNOOld
	Boolean flashPanelPresntOld
	Boolean FlashPnlPrsntOld
	Boolean frontInterlockACKBtnOld
	Boolean frontInterlockACKOld
	Boolean frontIntlock1Old
	Boolean frontIntlock2Old
	Boolean GoFlagOld
	Boolean heartBeatOld
	Boolean hole0PFOld
	Boolean hole10PFOld
	Boolean hole11PFOld
	Boolean hole12PFOld
	Boolean hole13PFOld
	Boolean hole14PFOld
	Boolean hole15PFOld
	Boolean hole16PFOld
	Boolean hole17PFOld
	Boolean hole18PFOld
	Boolean hole19PFOld
	Boolean hole1PFOld
	Boolean hole20PFOld
	Boolean hole21PFOld
	Boolean hole22PFOld
	Boolean hole23PFOld
	Boolean hole2PFOld
	Boolean hole3PFOld
	Boolean hole4PFOld
	Boolean hole5PFOld
	Boolean hole6PFOld
	Boolean hole7PFOld
	Boolean hole8PFOld
	Boolean hole9PFOld
	Boolean holeDetectedOld
	Boolean homePositionStatusOld
	Boolean hsPanelPresntOld
	Boolean inMagGoHomeBtnOld
	Boolean inMagGoHomeOld
	Boolean inMagInterlockOld
	Boolean inMagLoadedBtnOld
	Boolean inMagLoadedOld
	Boolean inMagLowLimNOld
	Boolean inMagLowLimOld
	Boolean inMagMtrCCOld
	Boolean inMagMtrDirCCOld
	Boolean inMagMtrDirOld
	Boolean inMagMtrOld
	Boolean InMagPickUpSignalOld
	Boolean inMagPnlRdyOld
	Boolean InMagRobotClearSignalOld
	Boolean inMagUpLimNOld
	Boolean inMagUpLimOld
	Boolean jobAbortBtnOld
	Boolean jobDoneOld
	Boolean jobPauseBtnOld
	Boolean jobPauseOld
	Boolean jobResumeBtnOld
	Boolean jobResumeOld
	Boolean jobStartBtnOld
	Boolean jobStartOld
	Boolean jobStopBtnOld
	Boolean jobStopOld
	Boolean joint1StatusOld
	Boolean joint2StatusOld
	Boolean joint3StatusOld
	Boolean joint4StatusOld
	Boolean leftInterlockACKBtnOld
	Boolean leftInterlockACKOld
	Boolean leftIntlock1Old
	Boolean leftIntlock2Old
	Boolean maintModeOld
	Boolean monEstop1Old
	Boolean monEstop2Old
	Boolean motorOnStatusOld
	Boolean motorPowerStatusOld
	Boolean OutMagDropOffSignalOld
	Boolean outMagGoHomeBtnOld
	Boolean outMagGoHomeOld
	Boolean outMagIntOld
	Boolean outMagLowLimNOld
	Boolean outMagLowLimOld
	Boolean outMagMtrCCOld
	Boolean outMagMtrDirCCOld
	Boolean outMagMtrDirOld
	Boolean outMagMtrOld
	Boolean outMagPanelRdyOld
	Boolean OutMagRobotClearSignalOld
	Boolean outMagUnloadedBtnOld
	Boolean outMagUnloadedOld
	Boolean outMagUpLimNOld
	Boolean outMagUpLimOld
	Boolean OutputMagSignalOld
	Boolean panelDataTxRdyOld
	Boolean PanelPassedInspectionOld
	Boolean ParamEntryMissingOld
	Boolean pauseFlagOld
	Boolean pauseStatusOld
	Boolean RecEntryMissingOld
	Boolean recFlashRequiredOld
	Boolean ReturnFlagOld
	Boolean rightInterlockACKBtnOld
	Boolean rightInterlockACKOld
	Boolean rightIntlockOld
	Boolean RobotPlacedPanelOld
	Boolean safeGuardInputOld
	Boolean sftyFrmIlockAckBtnOld
	Boolean sftyFrmIlockAckOld
	Boolean stackLightAlrmCCOld
	Boolean stackLightAlrmOld
	Boolean stackLightGrnCCOld
	Boolean stackLightGrnOld
	Boolean stackLightRedCCOld
	Boolean stackLightRedOld
	Boolean stackLightYelCCOld
	Boolean stackLightYelOld
	Boolean suctionCupsCCOld
	Boolean suctionCupsOld
	Boolean tasksRunningStatusOld
	Boolean teachModeStatusOld

	Boolean m_insertingOld
	Boolean m_idleOld
	Boolean m_readyOld
	Boolean m_bootDelayOld
	Boolean m_bootDoneOld
	Boolean m_findingHomeOld
	Boolean m_dumpRunningOld
	Boolean m_manualModeOnOld
	Boolean m_erInsertTempOld
	Boolean m_erServoNotRdyOld
	Boolean m_HeaterMCROnOld
	Boolean m_BowlFeederOnOld
	Boolean m_VibTrackOnOld
	Boolean m_LoadInsertOld
	Boolean m_ExtendShuttleOld
	Boolean m_ActiveCoolingOld
	Boolean m_InsertGripperOld
	Boolean m_InsertDischargOld
	Boolean m_InsertRejectOld
	Boolean m_EmgStopOld
	Boolean m_ShuttleParkedOld
	Boolean m_ShuttlePickupOld
	Boolean m_ShuttlePIOld
	Boolean m_ShuttleNPIOld
	Boolean m_InsertOnShuttlOld
	Boolean m_InsertdetectedOld
	Boolean m_InsertDetAluOld
	Boolean m_InsertAtTempOld
	Boolean m_GripperEarsOutOld
	Boolean m_GripperEarsInOld

	Double recPartNumberOld
	Integer ctrlrErrAxisNumberOld
	Integer ctrlrErrorNumOld
	Integer ctrlrLineNumberOld
	Integer ctrlrTaskNumberOld
	Integer currentFlashHoleOld
	Integer currentHSHoleOld
	Integer currentInspectHoleOld
	Integer currentPreinspectHoleOld
	Integer FirstHolePointFlashOld
	Integer FirstHolePointHotStakeOld
	Integer FirstHolePointInspectionOld
	Integer inMagCurrentStateOld
	Integer jobAbortOld
	Integer jobNumPanelsDoneOld
	Integer jobNumPanelsOld
	Integer LastHolePointFlashOld
	Integer LastHolePointHotStakeOld
	Integer LastHolePointInspectionOld
	Integer mainCurrentStateOld
	Integer outMagCurrentStateOld
	Integer OutmagLastStateOld
	Integer recCrowdingOld
	Integer recInmagOld
	Integer recInsertTypeOld
	Integer recNumberOfHolesOld
	Integer recOutmagOld
	Integer recPreCrowdingOld
	Integer SystemAccelOld
	Integer SystemSpeedOld
	Integer systemStatusOld
	Integer xOld
	Integer zOld
	
	Long PLC_Delay_BlowOffTimeOld
	Long PLC_Delay_InsertLoadOld
	Long PLC_Speed_TorqueModeOld
	Long PLC_Torque_TorqueModeOld
	Long PLC_Delay_RejectBlowOffOld
	Long PLC_Delay_FindHomeOld
	Long PLC_Delay_ActiveCoolingOld
	Long PLC_Delay_TorqueDwellOld
	Long PLC_Delay_GripperOld
	Long PLC_Delay_PanelContactOld
	Long PLC_Delay_ShuttleExtendedOld
	Long PLC_InsertTypeOld
	Long PLC_PanelContactTorqueOld
	Long PLC_InsertTempOkBandOld
	Long PLC_PID_SetValueOld
	Long PLC_PID_ProcessValueOld
	Long PLC_ServoMotorCurrentValueOld
	
	Real hole0LOld
	Real hole0ROld
	Real hole10LOld
	Real hole10ROld
	Real hole11LOld
	Real hole11ROld
	Real hole12LOld
	Real hole12ROld
	Real hole13LOld
	Real hole13ROld
	Real hole14LOld
	Real hole14ROld
	Real hole15LOld
	Real hole15ROld
	Real hole16LOld
	Real hole16ROld
	Real hole17LOld
	Real hole17ROld
	Real hole18LOld
	Real hole18ROld
	Real hole19LOld
	Real hole19ROld
	Real hole1LOld
	Real hole1ROld
	Real hole20LOld
	Real hole20ROld
	Real hole21LOld
	Real hole21ROld
	Real hole22LOld
	Real hole22ROld
	Real hole23LOld
	Real hole23ROld
	Real hole2LOld
	Real hole2ROld
	Real hole3LOld
	Real hole3ROld
	Real hole4LOld
	Real hole4ROld
	Real hole5LOld
	Real hole5ROld
	Real hole6LOld
	Real hole6ROld
	Real hole7LOld
	Real hole7ROld
	Real hole8LOld
	Real hole8ROld
	Real hole9LOld
	Real hole9ROld
	Real InMagTorqueLimOld
	Real insertDepthToleranceOld
	Real OutMagTorqueLimOld
	Real recFlashDwellTimeOld
	Real recInmagPickupOffsetOld
	Real recInsertDepthOld
	Real recOutmagPickupOffsetOld
	Real recPanelThicknessOld
	Real recTempProbeOld
	Real recTempTrackOld
	Real recSuctionWaitTimeOld
	Real zLimitOld
	Real ZmaxTorqueOld
	String ctrlrErrMsgOld$
   
	' define the connection to the HMI
	SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0

	TmReset (0) 'reset timer 0
	
	Do While True
	  OnErr GoTo RetryConnection ' on any error retry connection

	RetryConnection:
  	If ChkNet(201) < 0 Then ' If port is not open
  		Wait 2 'give things a chance to settle before opening the port
       OpenNet #201 As Client
       Print "Attempted Open TCP port to HMI"
		EndIf
		
		'send I/O not more than twice per second
		' TODO -- fix to not be a busy wait
		Do While Tmr(0) < 0.5
			Wait 0.1
		Loop
		
		'restart the timer so that we can come back and check to 
		'see if a 0.5 second has passed
		TmReset 0
			
		heartBeat = Not heartBeat
		
		' ===========================================================================
		' `awk '{ gsub(/"/,"",$6) ;print $6}' printsOld | awk '{ print "If "$1" <> 	 \
		' "$1"Old Then\n\tPrint #201, \"{\", Chr$(&H22) + \""$1"\" + Chr$(&H22), 			\
		' \":\", Str$("$1"), \"}\",\n\t"$1"Old = "$1"\nEndIf"}' - > printsNew
		' ===========================================================================

		'Tx to HMI:

		'_Don' replace when updating robot.txt_____________
		If ctrlrErrMsg$ <> ctrlrErrMsgOld$ Then
			Print #201, "{", Chr$(&H22) + "ctrlrErrMsg$" + Chr$(&H22), ":", Chr$(&H22) + ctrlrErrMsg$ + Chr$(&H22), "}",
			ctrlrErrMsg$ = ctrlrErrMsgOld$
		EndIf
		'_____________
	
		If alarmMute <> alarmMuteOld Then
			Print #201, "{", Chr$(&H22) + "alarmMute" + Chr$(&H22), ":", Str$(alarmMute), "}",
			alarmMuteOld = alarmMute
		EndIf
		If backInterlockACK <> backInterlockACKOld Then
			Print #201, "{", Chr$(&H22) + "backInterlockACK" + Chr$(&H22), ":", Str$(backInterlockACK), "}",
			backInterlockACKOld = backInterlockACK
		EndIf
		If frontInterlockACK <> frontInterlockACKOld Then
			Print #201, "{", Chr$(&H22) + "frontInterlockACK" + Chr$(&H22), ":", Str$(frontInterlockACK), "}",
			frontInterlockACKOld = frontInterlockACK
		EndIf
		If inMagGoHome <> inMagGoHomeOld Then
			Print #201, "{", Chr$(&H22) + "inMagGoHome" + Chr$(&H22), ":", Str$(inMagGoHome), "}",
			inMagGoHomeOld = inMagGoHome
		EndIf
		If inMagLoaded <> inMagLoadedOld Then
			Print #201, "{", Chr$(&H22) + "inMagLoaded" + Chr$(&H22), ":", Str$(inMagLoaded), "}",
			inMagLoadedOld = inMagLoaded
		EndIf
		If jobAbort <> jobAbortOld Then
			Print #201, "{", Chr$(&H22) + "jobAbort" + Chr$(&H22), ":", Str$(jobAbort), "}",
			jobAbortOld = jobAbort
		EndIf
		If jobStart <> jobStartOld Then
			Print #201, "{", Chr$(&H22) + "jobStart" + Chr$(&H22), ":", Str$(jobStart), "}",
			jobStartOld = jobStart
		EndIf
		If leftInterlockACK <> leftInterlockACKOld Then
			Print #201, "{", Chr$(&H22) + "leftInterlockACK" + Chr$(&H22), ":", Str$(leftInterlockACK), "}",
			leftInterlockACKOld = leftInterlockACK
		EndIf
		If outMagGoHome <> outMagGoHomeOld Then
			Print #201, "{", Chr$(&H22) + "outMagGoHome" + Chr$(&H22), ":", Str$(outMagGoHome), "}",
			outMagGoHomeOld = outMagGoHome
		EndIf
		If outMagUnloaded <> outMagUnloadedOld Then
			Print #201, "{", Chr$(&H22) + "outMagUnloaded" + Chr$(&H22), ":", Str$(outMagUnloaded), "}",
			outMagUnloadedOld = outMagUnloaded
		EndIf
		If rightInterlockACK <> rightInterlockACKOld Then
			Print #201, "{", Chr$(&H22) + "rightInterlockACK" + Chr$(&H22), ":", Str$(rightInterlockACK), "}",
			rightInterlockACKOld = rightInterlockACK
		EndIf
		If sftyFrmIlockAck <> sftyFrmIlockAckOld Then
			Print #201, "{", Chr$(&H22) + "sftyFrmIlockAck" + Chr$(&H22), ":", Str$(sftyFrmIlockAck), "}",
			sftyFrmIlockAckOld = sftyFrmIlockAck
		EndIf
		If erBackSafetyFrameOpen <> erBackSafetyFrameOpenOld Then
			Print #201, "{", Chr$(&H22) + "erBackSafetyFrameOpen" + Chr$(&H22), ":", Str$(erBackSafetyFrameOpen), "}",
			erBackSafetyFrameOpenOld = erBackSafetyFrameOpen
		EndIf
		If erBadPressureSensor <> erBadPressureSensorOld Then
			Print #201, "{", Chr$(&H22) + "erBadPressureSensor" + Chr$(&H22), ":", Str$(erBadPressureSensor), "}",
			erBadPressureSensorOld = erBadPressureSensor
		EndIf
		If erDCPower <> erDCPowerOld Then
			Print #201, "{", Chr$(&H22) + "erDCPower" + Chr$(&H22), ":", Str$(erDCPower), "}",
			erDCPowerOld = erDCPower
		EndIf
		If erDCPowerHeatStake <> erDCPowerHeatStakeOld Then
			Print #201, "{", Chr$(&H22) + "erDCPowerHeatStake" + Chr$(&H22), ":", Str$(erDCPowerHeatStake), "}",
			erDCPowerHeatStakeOld = erDCPowerHeatStake
		EndIf
		If erDebrisRemovalBreaker <> erDebrisRemovalBreakerOld Then
			Print #201, "{", Chr$(&H22) + "erDebrisRemovalBreaker" + Chr$(&H22), ":", Str$(erDebrisRemovalBreaker), "}",
			erDebrisRemovalBreakerOld = erDebrisRemovalBreaker
		EndIf
		If erEstop <> erEstopOld Then
			Print #201, "{", Chr$(&H22) + "erEstop" + Chr$(&H22), ":", Str$(erEstop), "}",
			erEstopOld = erEstop
		EndIf
		If erFlashStation <> erFlashStationOld Then
			Print #201, "{", Chr$(&H22) + "erFlashStation" + Chr$(&H22), ":", Str$(erFlashStation), "}",
			erFlashStationOld = erFlashStation
		EndIf
		If erFrontSafetyFrameOpen <> erFrontSafetyFrameOpenOld Then
			Print #201, "{", Chr$(&H22) + "erFrontSafetyFrameOpen" + Chr$(&H22), ":", Str$(erFrontSafetyFrameOpen), "}",
			erFrontSafetyFrameOpenOld = erFrontSafetyFrameOpen
		EndIf
		If erHeatStakeBreaker <> erHeatStakeBreakerOld Then
			Print #201, "{", Chr$(&H22) + "erHeatStakeBreaker" + Chr$(&H22), ":", Str$(erHeatStakeBreaker), "}",
			erHeatStakeBreakerOld = erHeatStakeBreaker
		EndIf
		If erHeatStakeTemp <> erHeatStakeTempOld Then
			Print #201, "{", Chr$(&H22) + "erHeatStakeTemp" + Chr$(&H22), ":", Str$(erHeatStakeTemp), "}",
			erHeatStakeTempOld = erHeatStakeTemp
		EndIf
		If erHighPressure <> erHighPressureOld Then
			Print #201, "{", Chr$(&H22) + "erHighPressure" + Chr$(&H22), ":", Str$(erHighPressure), "}",
			erHighPressureOld = erHighPressure
		EndIf
		If erHMICommunication <> erHMICommunicationOld Then
			Print #201, "{", Chr$(&H22) + "erHMICommunication" + Chr$(&H22), ":", Str$(erHMICommunication), "}",
			erHMICommunicationOld = erHMICommunication
		EndIf
		If erHmiDataAck <> erHmiDataAckOld Then
			Print #201, "{", Chr$(&H22) + "erHmiDataAck" + Chr$(&H22), ":", Str$(erHmiDataAck), "}",
			erHmiDataAckOld = erHmiDataAck
		EndIf
		If erPanelUndefined <> erPanelUndefinedOld Then
			Print #201, "{", Chr$(&H22) + "erPanelUndefined" + Chr$(&H22), ":", Str$(erPanelUndefined), "}",
			erPanelUndefinedOld = erPanelUndefined
		EndIf
		If erIllegalArmMove <> erIllegalArmMoveOld Then
			Print #201, "{", Chr$(&H22) + "erIllegalArmMove" + Chr$(&H22), ":", Str$(erIllegalArmMove), "}",
			erIllegalArmMoveOld = erIllegalArmMove
		EndIf
		If erInMagBreaker <> erInMagBreakerOld Then
			Print #201, "{", Chr$(&H22) + "erInMagBreaker" + Chr$(&H22), ":", Str$(erInMagBreaker), "}",
			erInMagBreakerOld = erInMagBreaker
		EndIf
		If erInMagCrowding <> erInMagCrowdingOld Then
			Print #201, "{", Chr$(&H22) + "erInMagCrowding" + Chr$(&H22), ":", Str$(erInMagCrowding), "}",
			erInMagCrowdingOld = erInMagCrowding
		EndIf
		If erInMagEmpty <> erInMagEmptyOld Then
			Print #201, "{", Chr$(&H22) + "erInMagEmpty" + Chr$(&H22), ":", Str$(erInMagEmpty), "}",
			erInMagEmptyOld = erInMagEmpty
		EndIf
		If erInMagLowSensorBad <> erInMagLowSensorBadOld Then
			Print #201, "{", Chr$(&H22) + "erInMagLowSensorBad" + Chr$(&H22), ":", Str$(erInMagLowSensorBad), "}",
			erInMagLowSensorBadOld = erInMagLowSensorBad
		EndIf
		If erInMagOpenInterlock <> erInMagOpenInterlockOld Then
			Print #201, "{", Chr$(&H22) + "erInMagOpenInterlock" + Chr$(&H22), ":", Str$(erInMagOpenInterlock), "}",
			erInMagOpenInterlockOld = erInMagOpenInterlock
		EndIf
		If erInMagUpSensorBad <> erInMagUpSensorBadOld Then
			Print #201, "{", Chr$(&H22) + "erInMagUpSensorBad" + Chr$(&H22), ":", Str$(erInMagUpSensorBad), "}",
			erInMagUpSensorBadOld = erInMagUpSensorBad
		EndIf
		If erLaserScanner <> erLaserScannerOld Then
			Print #201, "{", Chr$(&H22) + "erLaserScanner" + Chr$(&H22), ":", Str$(erLaserScanner), "}",
			erLaserScannerOld = erLaserScanner
		EndIf
		If erLeftSafetyFrameOpen <> erLeftSafetyFrameOpenOld Then
			Print #201, "{", Chr$(&H22) + "erLeftSafetyFrameOpen" + Chr$(&H22), ":", Str$(erLeftSafetyFrameOpen), "}",
			erLeftSafetyFrameOpenOld = erLeftSafetyFrameOpen
		EndIf
		If erLowPressure <> erLowPressureOld Then
			Print #201, "{", Chr$(&H22) + "erLowPressure" + Chr$(&H22), ":", Str$(erLowPressure), "}",
			erLowPressureOld = erLowPressure
		EndIf
		If erOutMagBreaker <> erOutMagBreakerOld Then
			Print #201, "{", Chr$(&H22) + "erOutMagBreaker" + Chr$(&H22), ":", Str$(erOutMagBreaker), "}",
			erOutMagBreakerOld = erOutMagBreaker
		EndIf
		If erOutMagCrowding <> erOutMagCrowdingOld Then
			Print #201, "{", Chr$(&H22) + "erOutMagCrowding" + Chr$(&H22), ":", Str$(erOutMagCrowding), "}",
			erOutMagCrowdingOld = erOutMagCrowding
		EndIf
		If erOutMagFull <> erOutMagFullOld Then
			Print #201, "{", Chr$(&H22) + "erOutMagFull" + Chr$(&H22), ":", Str$(erOutMagFull), "}",
			erOutMagFullOld = erOutMagFull
		EndIf
		If erOutMagLowSensorBad <> erOutMagLowSensorBadOld Then
			Print #201, "{", Chr$(&H22) + "erOutMagLowSensorBad" + Chr$(&H22), ":", Str$(erOutMagLowSensorBad), "}",
			erOutMagLowSensorBadOld = erOutMagLowSensorBad
		EndIf
		If erOutMagOpenInterlock <> erOutMagOpenInterlockOld Then
			Print #201, "{", Chr$(&H22) + "erOutMagOpenInterlock" + Chr$(&H22), ":", Str$(erOutMagOpenInterlock), "}",
			erOutMagOpenInterlockOld = erOutMagOpenInterlock
		EndIf
		If erOutMagUpSensorBad <> erOutMagUpSensorBadOld Then
			Print #201, "{", Chr$(&H22) + "erOutMagUpSensorBad" + Chr$(&H22), ":", Str$(erOutMagUpSensorBad), "}",
			erOutMagUpSensorBadOld = erOutMagUpSensorBad
		EndIf
		If erPanelFailedInspection <> erPanelFailedInspectionOld Then
			Print #201, "{", Chr$(&H22) + "erPanelFailedInspection" + Chr$(&H22), ":", Str$(erPanelFailedInspection), "}",
			erPanelFailedInspectionOld = erPanelFailedInspection
		EndIf
		If erPanelStatusUnknown <> erPanelStatusUnknownOld Then
			Print #201, "{", Chr$(&H22) + "erPanelStatusUnknown" + Chr$(&H22), ":", Str$(erPanelStatusUnknown), "}",
			erPanelStatusUnknownOld = erPanelStatusUnknown
		EndIf
		If erParamEntryMissing <> erParamEntryMissingOld Then
			Print #201, "{", Chr$(&H22) + "erParamEntryMissing" + Chr$(&H22), ":", Str$(erParamEntryMissing), "}",
			erParamEntryMissingOld = erParamEntryMissing
		EndIf
		If erRC180 <> erRC180Old Then
			Print #201, "{", Chr$(&H22) + "erRC180" + Chr$(&H22), ":", Str$(erRC180), "}",
			erRC180Old = erRC180
		EndIf
		If erRecEntryMissing <> erRecEntryMissingOld Then
			Print #201, "{", Chr$(&H22) + "erRecEntryMissing" + Chr$(&H22), ":", Str$(erRecEntryMissing), "}",
			erRecEntryMissingOld = erRecEntryMissing
		EndIf
		If erRightSafetyFrameOpen <> erRightSafetyFrameOpenOld Then
			Print #201, "{", Chr$(&H22) + "erRightSafetyFrameOpen" + Chr$(&H22), ":", Str$(erRightSafetyFrameOpen), "}",
			erRightSafetyFrameOpenOld = erRightSafetyFrameOpen
		EndIf
		If erRobotNotAtHome <> erRobotNotAtHomeOld Then
			Print #201, "{", Chr$(&H22) + "erRobotNotAtHome" + Chr$(&H22), ":", Str$(erRobotNotAtHome), "}",
			erRobotNotAtHomeOld = erRobotNotAtHome
		EndIf
		If erSafetySystemBreaker <> erSafetySystemBreakerOld Then
			Print #201, "{", Chr$(&H22) + "erSafetySystemBreaker" + Chr$(&H22), ":", Str$(erSafetySystemBreaker), "}",
			erSafetySystemBreakerOld = erSafetySystemBreaker
		EndIf
		If erUnknown <> erUnknownOld Then
			Print #201, "{", Chr$(&H22) + "erUnknown" + Chr$(&H22), ":", Str$(erUnknown), "}",
			erUnknownOld = erUnknown
		EndIf
		If erWrongPanelHoles <> erWrongPanelHolesOld Then
			Print #201, "{", Chr$(&H22) + "erWrongPanelHoles" + Chr$(&H22), ":", Str$(erWrongPanelHoles), "}",
			erWrongPanelHolesOld = erWrongPanelHoles
		EndIf
		If hole0L <> hole0LOld Then
			Print #201, "{", Chr$(&H22) + "hole0L" + Chr$(&H22), ":", Str$(hole0L), "}",
			hole0LOld = hole0L
		EndIf
		If hole0R <> hole0ROld Then
			Print #201, "{", Chr$(&H22) + "hole0R" + Chr$(&H22), ":", Str$(hole0R), "}",
			hole0ROld = hole0R
		EndIf
		If hole10L <> hole10LOld Then
			Print #201, "{", Chr$(&H22) + "hole10L" + Chr$(&H22), ":", Str$(hole10L), "}",
			hole10LOld = hole10L
		EndIf
		If hole10R <> hole10ROld Then
			Print #201, "{", Chr$(&H22) + "hole10R" + Chr$(&H22), ":", Str$(hole10R), "}",
			hole10ROld = hole10R
		EndIf
		If hole11L <> hole11LOld Then
			Print #201, "{", Chr$(&H22) + "hole11L" + Chr$(&H22), ":", Str$(hole11L), "}",
			hole11LOld = hole11L
		EndIf
		If hole11R <> hole11ROld Then
			Print #201, "{", Chr$(&H22) + "hole11R" + Chr$(&H22), ":", Str$(hole11R), "}",
			hole11ROld = hole11R
		EndIf
		If hole12L <> hole12LOld Then
			Print #201, "{", Chr$(&H22) + "hole12L" + Chr$(&H22), ":", Str$(hole12L), "}",
			hole12LOld = hole12L
		EndIf
		If hole12R <> hole12ROld Then
			Print #201, "{", Chr$(&H22) + "hole12R" + Chr$(&H22), ":", Str$(hole12R), "}",
			hole12ROld = hole12R
		EndIf
		If hole13L <> hole13LOld Then
			Print #201, "{", Chr$(&H22) + "hole13L" + Chr$(&H22), ":", Str$(hole13L), "}",
			hole13LOld = hole13L
		EndIf
		If hole13R <> hole13ROld Then
			Print #201, "{", Chr$(&H22) + "hole13R" + Chr$(&H22), ":", Str$(hole13R), "}",
			hole13ROld = hole13R
		EndIf
		If hole14L <> hole14LOld Then
			Print #201, "{", Chr$(&H22) + "hole14L" + Chr$(&H22), ":", Str$(hole14L), "}",
			hole14LOld = hole14L
		EndIf
		If hole14R <> hole14ROld Then
			Print #201, "{", Chr$(&H22) + "hole14R" + Chr$(&H22), ":", Str$(hole14R), "}",
			hole14ROld = hole14R
		EndIf
		If hole15L <> hole15LOld Then
			Print #201, "{", Chr$(&H22) + "hole15L" + Chr$(&H22), ":", Str$(hole15L), "}",
			hole15LOld = hole15L
		EndIf
		If hole15R <> hole15ROld Then
			Print #201, "{", Chr$(&H22) + "hole15R" + Chr$(&H22), ":", Str$(hole15R), "}",
			hole15ROld = hole15R
		EndIf
		If hole16L <> hole16LOld Then
			Print #201, "{", Chr$(&H22) + "hole16L" + Chr$(&H22), ":", Str$(hole16L), "}",
			hole16LOld = hole16L
		EndIf
		If hole16R <> hole16ROld Then
			Print #201, "{", Chr$(&H22) + "hole16R" + Chr$(&H22), ":", Str$(hole16R), "}",
			hole16ROld = hole16R
		EndIf
		If hole17L <> hole17LOld Then
			Print #201, "{", Chr$(&H22) + "hole17L" + Chr$(&H22), ":", Str$(hole17L), "}",
			hole17LOld = hole17L
		EndIf
		If hole17R <> hole17ROld Then
			Print #201, "{", Chr$(&H22) + "hole17R" + Chr$(&H22), ":", Str$(hole17R), "}",
			hole17ROld = hole17R
		EndIf
		If hole18L <> hole18LOld Then
			Print #201, "{", Chr$(&H22) + "hole18L" + Chr$(&H22), ":", Str$(hole18L), "}",
			hole18LOld = hole18L
		EndIf
		If hole18R <> hole18ROld Then
			Print #201, "{", Chr$(&H22) + "hole18R" + Chr$(&H22), ":", Str$(hole18R), "}",
			hole18ROld = hole18R
		EndIf
		If hole19L <> hole19LOld Then
			Print #201, "{", Chr$(&H22) + "hole19L" + Chr$(&H22), ":", Str$(hole19L), "}",
			hole19LOld = hole19L
		EndIf
		If hole19R <> hole19ROld Then
			Print #201, "{", Chr$(&H22) + "hole19R" + Chr$(&H22), ":", Str$(hole19R), "}",
			hole19ROld = hole19R
		EndIf
		If hole1L <> hole1LOld Then
			Print #201, "{", Chr$(&H22) + "hole1L" + Chr$(&H22), ":", Str$(hole1L), "}",
			hole1LOld = hole1L
		EndIf
		If hole1R <> hole1ROld Then
			Print #201, "{", Chr$(&H22) + "hole1R" + Chr$(&H22), ":", Str$(hole1R), "}",
			hole1ROld = hole1R
		EndIf
		If hole20L <> hole20LOld Then
			Print #201, "{", Chr$(&H22) + "hole20L" + Chr$(&H22), ":", Str$(hole20L), "}",
			hole20LOld = hole20L
		EndIf
		If hole20R <> hole20ROld Then
			Print #201, "{", Chr$(&H22) + "hole20R" + Chr$(&H22), ":", Str$(hole20R), "}",
			hole20ROld = hole20R
		EndIf
		If hole21L <> hole21LOld Then
			Print #201, "{", Chr$(&H22) + "hole21L" + Chr$(&H22), ":", Str$(hole21L), "}",
			hole21LOld = hole21L
		EndIf
		If hole21R <> hole21ROld Then
			Print #201, "{", Chr$(&H22) + "hole21R" + Chr$(&H22), ":", Str$(hole21R), "}",
			hole21ROld = hole21R
		EndIf
		If hole22L <> hole22LOld Then
			Print #201, "{", Chr$(&H22) + "hole22L" + Chr$(&H22), ":", Str$(hole22L), "}",
			hole22LOld = hole22L
		EndIf
		If hole22R <> hole22ROld Then
			Print #201, "{", Chr$(&H22) + "hole22R" + Chr$(&H22), ":", Str$(hole22R), "}",
			hole22ROld = hole22R
		EndIf
	
	'why was this missing????
		If hole23L <> hole23LOld Then
			Print #201, "{", Chr$(&H22) + "hole23L" + Chr$(&H22), ":", Str$(hole23L), "}",
			hole23LOld = hole23L
		EndIf
		If hole23R <> hole23ROld Then
			Print #201, "{", Chr$(&H22) + "hole23R" + Chr$(&H22), ":", Str$(hole23R), "}",
			hole23ROld = hole23R
		EndIf
	'end of missing code----------------------------------
	
		If hole2L <> hole2LOld Then
			Print #201, "{", Chr$(&H22) + "hole2L" + Chr$(&H22), ":", Str$(hole2L), "}",
			hole2LOld = hole2L
		EndIf
		If hole2R <> hole2ROld Then
			Print #201, "{", Chr$(&H22) + "hole2R" + Chr$(&H22), ":", Str$(hole2R), "}",
			hole2ROld = hole2R
		EndIf
		If hole3L <> hole3LOld Then
			Print #201, "{", Chr$(&H22) + "hole3L" + Chr$(&H22), ":", Str$(hole3L), "}",
			hole3LOld = hole3L
		EndIf
		If hole3R <> hole3ROld Then
			Print #201, "{", Chr$(&H22) + "hole3R" + Chr$(&H22), ":", Str$(hole3R), "}",
			hole3ROld = hole3R
		EndIf
		If hole4L <> hole4LOld Then
			Print #201, "{", Chr$(&H22) + "hole4L" + Chr$(&H22), ":", Str$(hole4L), "}",
			hole4LOld = hole4L
		EndIf
		If hole4R <> hole4ROld Then
			Print #201, "{", Chr$(&H22) + "hole4R" + Chr$(&H22), ":", Str$(hole4R), "}",
			hole4ROld = hole4R
		EndIf
		If hole5L <> hole5LOld Then
			Print #201, "{", Chr$(&H22) + "hole5L" + Chr$(&H22), ":", Str$(hole5L), "}",
			hole5LOld = hole5L
		EndIf
		If hole5R <> hole5ROld Then
			Print #201, "{", Chr$(&H22) + "hole5R" + Chr$(&H22), ":", Str$(hole5R), "}",
			hole5ROld = hole5R
		EndIf
		If hole6L <> hole6LOld Then
			Print #201, "{", Chr$(&H22) + "hole6L" + Chr$(&H22), ":", Str$(hole6L), "}",
			hole6LOld = hole6L
		EndIf
		If hole6R <> hole6ROld Then
			Print #201, "{", Chr$(&H22) + "hole6R" + Chr$(&H22), ":", Str$(hole6R), "}",
			hole6ROld = hole6R
		EndIf
		If hole7L <> hole7LOld Then
			Print #201, "{", Chr$(&H22) + "hole7L" + Chr$(&H22), ":", Str$(hole7L), "}",
			hole7LOld = hole7L
		EndIf
		If hole7R <> hole7ROld Then
			Print #201, "{", Chr$(&H22) + "hole7R" + Chr$(&H22), ":", Str$(hole7R), "}",
			hole7ROld = hole7R
		EndIf
		If hole8L <> hole8LOld Then
			Print #201, "{", Chr$(&H22) + "hole8L" + Chr$(&H22), ":", Str$(hole8L), "}",
			hole8LOld = hole8L
		EndIf
		If hole8R <> hole8ROld Then
			Print #201, "{", Chr$(&H22) + "hole8R" + Chr$(&H22), ":", Str$(hole8R), "}",
			hole8ROld = hole8R
		EndIf
		If hole9L <> hole9LOld Then
			Print #201, "{", Chr$(&H22) + "hole9L" + Chr$(&H22), ":", Str$(hole9L), "}",
			hole9LOld = hole9L
		EndIf
		If hole9R <> hole9ROld Then
			Print #201, "{", Chr$(&H22) + "hole9R" + Chr$(&H22), ":", Str$(hole9R), "}",
			hole9ROld = hole9R
		EndIf
		If airPressHigh <> airPressHighOld Then
			Print #201, "{", Chr$(&H22) + "airPressHigh" + Chr$(&H22), ":", Str$(airPressHigh), "}",
			airPressHighOld = airPressHigh
		EndIf
		If airPressLow <> airPressLowOld Then
			Print #201, "{", Chr$(&H22) + "airPressLow" + Chr$(&H22), ":", Str$(airPressLow), "}",
			airPressLowOld = airPressLow
		EndIf
		If backIntlock1 <> backIntlock1Old Then
			Print #201, "{", Chr$(&H22) + "backIntlock1" + Chr$(&H22), ":", Str$(backIntlock1), "}",
			backIntlock1Old = backIntlock1
		EndIf
		If backIntlock2 <> backIntlock2Old Then
			Print #201, "{", Chr$(&H22) + "backIntlock2" + Chr$(&H22), ":", Str$(backIntlock2), "}",
			backIntlock2Old = backIntlock2
		EndIf
		If cbMonDebrisRmv <> cbMonDebrisRmvOld Then
			Print #201, "{", Chr$(&H22) + "cbMonDebrisRmv" + Chr$(&H22), ":", Str$(cbMonDebrisRmv), "}",
			cbMonDebrisRmvOld = cbMonDebrisRmv
		EndIf
		If cbMonHeatStake <> cbMonHeatStakeOld Then
			Print #201, "{", Chr$(&H22) + "cbMonHeatStake" + Chr$(&H22), ":", Str$(cbMonHeatStake), "}",
			cbMonHeatStakeOld = cbMonHeatStake
		EndIf
		If cbMonInMag <> cbMonInMagOld Then
			Print #201, "{", Chr$(&H22) + "cbMonInMag" + Chr$(&H22), ":", Str$(cbMonInMag), "}",
			cbMonInMagOld = cbMonInMag
		EndIf
		If cbMonOutMag <> cbMonOutMagOld Then
			Print #201, "{", Chr$(&H22) + "cbMonOutMag" + Chr$(&H22), ":", Str$(cbMonOutMag), "}",
			cbMonOutMagOld = cbMonOutMag
		EndIf
		If cbMonPAS24vdc <> cbMonPAS24vdcOld Then
			Print #201, "{", Chr$(&H22) + "cbMonPAS24vdc" + Chr$(&H22), ":", Str$(cbMonPAS24vdc), "}",
			cbMonPAS24vdcOld = cbMonPAS24vdc
		EndIf
		If cbMonSafety <> cbMonSafetyOld Then
			Print #201, "{", Chr$(&H22) + "cbMonSafety" + Chr$(&H22), ":", Str$(cbMonSafety), "}",
			cbMonSafetyOld = cbMonSafety
		EndIf
		If dc24vOK <> dc24vOKOld Then
			Print #201, "{", Chr$(&H22) + "dc24vOK" + Chr$(&H22), ":", Str$(dc24vOK), "}",
			dc24vOKOld = dc24vOK
		EndIf
		If edgeDetectGo <> edgeDetectGoOld Then
			Print #201, "{", Chr$(&H22) + "edgeDetectGo" + Chr$(&H22), ":", Str$(edgeDetectGo), "}",
			edgeDetectGoOld = edgeDetectGo
		EndIf
		If edgeDetectHi <> edgeDetectHiOld Then
			Print #201, "{", Chr$(&H22) + "edgeDetectHi" + Chr$(&H22), ":", Str$(edgeDetectHi), "}",
			edgeDetectHiOld = edgeDetectHi
		EndIf
		If edgeDetectLo <> edgeDetectLoOld Then
			Print #201, "{", Chr$(&H22) + "edgeDetectLo" + Chr$(&H22), ":", Str$(edgeDetectLo), "}",
			edgeDetectLoOld = edgeDetectLo
		EndIf
		If flashHomeNC <> flashHomeNCOld Then
			Print #201, "{", Chr$(&H22) + "flashHomeNC" + Chr$(&H22), ":", Str$(flashHomeNC), "}",
			flashHomeNCOld = flashHomeNC
		EndIf
		If flashHomeNO <> flashHomeNOOld Then
			Print #201, "{", Chr$(&H22) + "flashHomeNO" + Chr$(&H22), ":", Str$(flashHomeNO), "}",
			flashHomeNOOld = flashHomeNO
		EndIf
		If FlashPnlPrsnt <> FlashPnlPrsntOld Then
			Print #201, "{", Chr$(&H22) + "flashPnlPrsnt" + Chr$(&H22), ":", Str$(FlashPnlPrsnt), "}",
			flashPnlPrsntOld = FlashPnlPrsnt
		EndIf
		If frontIntlock1 <> frontIntlock1Old Then
			Print #201, "{", Chr$(&H22) + "frontIntlock1" + Chr$(&H22), ":", Str$(frontIntlock1), "}",
			frontIntlock1Old = frontIntlock1
		EndIf
		If frontIntlock2 <> frontIntlock2Old Then
			Print #201, "{", Chr$(&H22) + "frontIntlock2" + Chr$(&H22), ":", Str$(frontIntlock2), "}",
			frontIntlock2Old = frontIntlock2
		EndIf
		If holeDetected <> holeDetectedOld Then
			Print #201, "{", Chr$(&H22) + "holeDetected" + Chr$(&H22), ":", Str$(holeDetected), "}",
			holeDetectedOld = holeDetected
		EndIf
		If hsPanelPresnt <> hsPanelPresntOld Then
			Print #201, "{", Chr$(&H22) + "hsPanelPresnt" + Chr$(&H22), ":", Str$(hsPanelPresnt), "}",
			hsPanelPresntOld = hsPanelPresnt
		EndIf
		If inMagInterlock <> inMagInterlockOld Then
			Print #201, "{", Chr$(&H22) + "inMagInterlock" + Chr$(&H22), ":", Str$(inMagInterlock), "}",
			inMagInterlockOld = inMagInterlock
		EndIf
		If inMagLowLim <> inMagLowLimOld Then
			Print #201, "{", Chr$(&H22) + "inMagLowLim" + Chr$(&H22), ":", Str$(inMagLowLim), "}",
			inMagLowLimOld = inMagLowLim
		EndIf
		If inMagLowLimN <> inMagLowLimNOld Then
			Print #201, "{", Chr$(&H22) + "inMagLowLimN" + Chr$(&H22), ":", Str$(inMagLowLimN), "}",
			inMagLowLimNOld = inMagLowLimN
		EndIf
		If inMagPnlRdy <> inMagPnlRdyOld Then
			Print #201, "{", Chr$(&H22) + "inMagPnlRdy" + Chr$(&H22), ":", Str$(inMagPnlRdy), "}",
			inMagPnlRdyOld = inMagPnlRdy
		EndIf
		If inMagUpLim <> inMagUpLimOld Then
			Print #201, "{", Chr$(&H22) + "inMagUpLim" + Chr$(&H22), ":", Str$(inMagUpLim), "}",
			inMagUpLimOld = inMagUpLim
		EndIf
		If inMagUpLimN <> inMagUpLimNOld Then
			Print #201, "{", Chr$(&H22) + "inMagUpLimN" + Chr$(&H22), ":", Str$(inMagUpLimN), "}",
			inMagUpLimNOld = inMagUpLimN
		EndIf
		If leftIntlock1 <> leftIntlock1Old Then
			Print #201, "{", Chr$(&H22) + "leftIntlock1" + Chr$(&H22), ":", Str$(leftIntlock1), "}",
			leftIntlock1Old = leftIntlock1
		EndIf
		If leftIntlock2 <> leftIntlock2Old Then
			Print #201, "{", Chr$(&H22) + "leftIntlock2" + Chr$(&H22), ":", Str$(leftIntlock2), "}",
			leftIntlock2Old = leftIntlock2
		EndIf
		If maintMode <> maintModeOld Then
			Print #201, "{", Chr$(&H22) + "maintMode" + Chr$(&H22), ":", Str$(maintMode), "}",
			maintModeOld = maintMode
		EndIf
		If monEstop1 <> monEstop1Old Then
			Print #201, "{", Chr$(&H22) + "monEstop1" + Chr$(&H22), ":", Str$(monEstop1), "}",
			monEstop1Old = monEstop1
		EndIf
		If monEstop2 <> monEstop2Old Then
			Print #201, "{", Chr$(&H22) + "monEstop2" + Chr$(&H22), ":", Str$(monEstop2), "}",
			monEstop2Old = monEstop2
		EndIf
		If outMagInt <> outMagIntOld Then
			Print #201, "{", Chr$(&H22) + "outMagInt" + Chr$(&H22), ":", Str$(outMagInt), "}",
			outMagIntOld = outMagInt
		EndIf
		If outMagLowLim <> outMagLowLimOld Then
			Print #201, "{", Chr$(&H22) + "outMagLowLim" + Chr$(&H22), ":", Str$(outMagLowLim), "}",
			outMagLowLimOld = outMagLowLim
		EndIf
		If outMagLowLimN <> outMagLowLimNOld Then
			Print #201, "{", Chr$(&H22) + "outMagLowLimN" + Chr$(&H22), ":", Str$(outMagLowLimN), "}",
			outMagLowLimNOld = outMagLowLimN
		EndIf
		If outMagPanelRdy <> outMagPanelRdyOld Then
			Print #201, "{", Chr$(&H22) + "outMagPanelRdy" + Chr$(&H22), ":", Str$(outMagPanelRdy), "}",
			outMagPanelRdyOld = outMagPanelRdy
		EndIf
		If outMagUpLim <> outMagUpLimOld Then
			Print #201, "{", Chr$(&H22) + "outMagUpLim" + Chr$(&H22), ":", Str$(outMagUpLim), "}",
			outMagUpLimOld = outMagUpLim
		EndIf
		If outMagUpLimN <> outMagUpLimNOld Then
			Print #201, "{", Chr$(&H22) + "outMagUpLimN" + Chr$(&H22), ":", Str$(outMagUpLimN), "}",
			outMagUpLimNOld = outMagUpLimN
		EndIf
		If rightIntlock <> rightIntlockOld Then
			Print #201, "{", Chr$(&H22) + "rightIntlock" + Chr$(&H22), ":", Str$(rightIntlock), "}",
			rightIntlockOld = rightIntlock
		EndIf
		If debrisMtr <> debrisMtrOld Then
			Print #201, "{", Chr$(&H22) + "debrisMtr" + Chr$(&H22), ":", Str$(debrisMtr), "}",
			debrisMtrOld = debrisMtr
		EndIf
		If drillGo <> drillGoOld Then
			Print #201, "{", Chr$(&H22) + "drillGo" + Chr$(&H22), ":", Str$(drillGo), "}",
			drillGoOld = drillGo
		EndIf
		If drillReturn <> drillReturnOld Then
			Print #201, "{", Chr$(&H22) + "drillReturn" + Chr$(&H22), ":", Str$(drillReturn), "}",
			drillReturnOld = drillReturn
		EndIf
		If eStopReset <> eStopResetOld Then
			Print #201, "{", Chr$(&H22) + "eStopReset" + Chr$(&H22), ":", Str$(eStopReset), "}",
			eStopResetOld = eStopReset
		EndIf
		If inMagMtr <> inMagMtrOld Then
			Print #201, "{", Chr$(&H22) + "inMagMtr" + Chr$(&H22), ":", Str$(inMagMtr), "}",
			inMagMtrOld = inMagMtr
		EndIf
		If inMagMtrDir <> inMagMtrDirOld Then
			Print #201, "{", Chr$(&H22) + "inMagMtrDir" + Chr$(&H22), ":", Str$(inMagMtrDir), "}",
			inMagMtrDirOld = inMagMtrDir
		EndIf
		If outMagMtr <> outMagMtrOld Then
			Print #201, "{", Chr$(&H22) + "outMagMtr" + Chr$(&H22), ":", Str$(outMagMtr), "}",
			outMagMtrOld = outMagMtr
		EndIf
		If outMagMtrDir <> outMagMtrDirOld Then
			Print #201, "{", Chr$(&H22) + "outMagMtrDir" + Chr$(&H22), ":", Str$(outMagMtrDir), "}",
			outMagMtrDirOld = outMagMtrDir
		EndIf
		If stackLightAlrm <> stackLightAlrmOld Then
			Print #201, "{", Chr$(&H22) + "stackLightAlrm" + Chr$(&H22), ":", Str$(stackLightAlrm), "}",
			stackLightAlrmOld = stackLightAlrm
		EndIf
		If stackLightGrn <> stackLightGrnOld Then
			Print #201, "{", Chr$(&H22) + "stackLightGrn" + Chr$(&H22), ":", Str$(stackLightGrn), "}",
			stackLightGrnOld = stackLightGrn
		EndIf
		If stackLightRed <> stackLightRedOld Then
			Print #201, "{", Chr$(&H22) + "stackLightRed" + Chr$(&H22), ":", Str$(stackLightRed), "}",
			stackLightRedOld = stackLightRed
		EndIf
		If stackLightYel <> stackLightYelOld Then
			Print #201, "{", Chr$(&H22) + "stackLightYel" + Chr$(&H22), ":", Str$(stackLightYel), "}",
			stackLightYelOld = stackLightYel
		EndIf
		If suctionCups <> suctionCupsOld Then
			Print #201, "{", Chr$(&H22) + "suctionCups" + Chr$(&H22), ":", Str$(suctionCups), "}",
			suctionCupsOld = suctionCups
		EndIf
		If ctrlrErrAxisNumber <> ctrlrErrAxisNumberOld Then
			Print #201, "{", Chr$(&H22) + "ctrlrErrAxisNumber" + Chr$(&H22), ":", Str$(ctrlrErrAxisNumber), "}",
			ctrlrErrAxisNumberOld = ctrlrErrAxisNumber
		EndIf
		If ctrlrErrorNum <> ctrlrErrorNumOld Then
			Print #201, "{", Chr$(&H22) + "ctrlrErrorNum" + Chr$(&H22), ":", Str$(ctrlrErrorNum), "}",
			ctrlrErrorNumOld = ctrlrErrorNum
		EndIf
		If ctrlrLineNumber <> ctrlrLineNumberOld Then
			Print #201, "{", Chr$(&H22) + "ctrlrLineNumber" + Chr$(&H22), ":", Str$(ctrlrLineNumber), "}",
			ctrlrLineNumberOld = ctrlrLineNumber
		EndIf
		If ctrlrTaskNumber <> ctrlrTaskNumberOld Then
			Print #201, "{", Chr$(&H22) + "ctrlrTaskNumber" + Chr$(&H22), ":", Str$(ctrlrTaskNumber), "}",
			ctrlrTaskNumberOld = ctrlrTaskNumber
		EndIf
		If errorStatus <> errorStatusOld Then
			Print #201, "{", Chr$(&H22) + "errorStatus" + Chr$(&H22), ":", Str$(errorStatus), "}",
			errorStatusOld = errorStatus
		EndIf
		If eStopStatus <> eStopStatusOld Then
			Print #201, "{", Chr$(&H22) + "eStopStatus" + Chr$(&H22), ":", Str$(eStopStatus), "}",
			eStopStatusOld = eStopStatus
		EndIf
		If heartBeat <> heartBeatOld Then
			Print #201, "{", Chr$(&H22) + "heartBeat" + Chr$(&H22), ":", Str$(heartBeat), "}",
			heartBeatOld = heartBeat
		EndIf
		If homePositionStatus <> homePositionStatusOld Then
			Print #201, "{", Chr$(&H22) + "homePositionStatus" + Chr$(&H22), ":", Str$(homePositionStatus), "}",
			homePositionStatusOld = homePositionStatus
		EndIf
		If joint1Status <> joint1StatusOld Then
			Print #201, "{", Chr$(&H22) + "joint1Status" + Chr$(&H22), ":", Str$(joint1Status), "}",
			joint1StatusOld = joint1Status
		EndIf
		If joint2Status <> joint2StatusOld Then
			Print #201, "{", Chr$(&H22) + "joint2Status" + Chr$(&H22), ":", Str$(joint2Status), "}",
			joint2StatusOld = joint2Status
		EndIf
		If joint3Status <> joint3StatusOld Then
			Print #201, "{", Chr$(&H22) + "joint3Status" + Chr$(&H22), ":", Str$(joint3Status), "}",
			joint3StatusOld = joint3Status
		EndIf
		If joint4Status <> joint4StatusOld Then
			Print #201, "{", Chr$(&H22) + "joint4Status" + Chr$(&H22), ":", Str$(joint4Status), "}",
			joint4StatusOld = joint4Status
		EndIf
		If motorOnStatus <> motorOnStatusOld Then
			Print #201, "{", Chr$(&H22) + "motorOnStatus" + Chr$(&H22), ":", Str$(motorOnStatus), "}",
			motorOnStatusOld = motorOnStatus
		EndIf
		If motorPowerStatus <> motorPowerStatusOld Then
			Print #201, "{", Chr$(&H22) + "motorPowerStatus" + Chr$(&H22), ":", Str$(motorPowerStatus), "}",
			motorPowerStatusOld = motorPowerStatus
		EndIf
		If pauseStatus <> pauseStatusOld Then
			Print #201, "{", Chr$(&H22) + "pauseStatus" + Chr$(&H22), ":", Str$(pauseStatus), "}",
			pauseStatusOld = pauseStatus
		EndIf
		If safeGuardInput <> safeGuardInputOld Then
			Print #201, "{", Chr$(&H22) + "safeGuardInput" + Chr$(&H22), ":", Str$(safeGuardInput), "}",
			safeGuardInputOld = safeGuardInput
		EndIf
		If tasksRunningStatus <> tasksRunningStatusOld Then
			Print #201, "{", Chr$(&H22) + "tasksRunningStatus" + Chr$(&H22), ":", Str$(tasksRunningStatus), "}",
			tasksRunningStatusOld = tasksRunningStatus
		EndIf
		If teachModeStatus <> teachModeStatusOld Then
			Print #201, "{", Chr$(&H22) + "teachModeStatus" + Chr$(&H22), ":", Str$(teachModeStatus), "}",
			teachModeStatusOld = teachModeStatus
		EndIf
		If currentFlashHole <> currentFlashHoleOld Then
			Print #201, "{", Chr$(&H22) + "currentFlashHole" + Chr$(&H22), ":", Str$(currentFlashHole), "}",
			currentFlashHoleOld = currentFlashHole
		EndIf
		If currentHSHole <> currentHSHoleOld Then
			Print #201, "{", Chr$(&H22) + "currentHSHole" + Chr$(&H22), ":", Str$(currentHSHole), "}",
			currentHSHoleOld = currentHSHole
		EndIf
		If currentInspectHole <> currentInspectHoleOld Then
			Print #201, "{", Chr$(&H22) + "currentInspectHole" + Chr$(&H22), ":", Str$(currentInspectHole), "}",
			currentInspectHoleOld = currentInspectHole
		EndIf
		If currentPreinspectHole <> currentPreinspectHoleOld Then
			Print #201, "{", Chr$(&H22) + "currentPreinspectHole" + Chr$(&H22), ":", Str$(currentPreinspectHole), "}",
			currentPreinspectHoleOld = currentPreinspectHole
		EndIf
		If hole0PF <> hole0PFOld Then
			Print #201, "{", Chr$(&H22) + "hole0PF" + Chr$(&H22), ":", Str$(hole0PF), "}",
			hole0PFOld = hole0PF
		EndIf
		If hole10PF <> hole10PFOld Then
			Print #201, "{", Chr$(&H22) + "hole10PF" + Chr$(&H22), ":", Str$(hole10PF), "}",
			hole10PFOld = hole10PF
		EndIf
		If hole11PF <> hole11PFOld Then
			Print #201, "{", Chr$(&H22) + "hole11PF" + Chr$(&H22), ":", Str$(hole11PF), "}",
			hole11PFOld = hole11PF
		EndIf
		If hole12PF <> hole12PFOld Then
			Print #201, "{", Chr$(&H22) + "hole12PF" + Chr$(&H22), ":", Str$(hole12PF), "}",
			hole12PFOld = hole12PF
		EndIf
		If hole13PF <> hole13PFOld Then
			Print #201, "{", Chr$(&H22) + "hole13PF" + Chr$(&H22), ":", Str$(hole13PF), "}",
			hole13PFOld = hole13PF
		EndIf
		If hole14PF <> hole14PFOld Then
			Print #201, "{", Chr$(&H22) + "hole14PF" + Chr$(&H22), ":", Str$(hole14PF), "}",
			hole14PFOld = hole14PF
		EndIf
		If hole15PF <> hole15PFOld Then
			Print #201, "{", Chr$(&H22) + "hole15PF" + Chr$(&H22), ":", Str$(hole15PF), "}",
			hole15PFOld = hole15PF
		EndIf
		If hole16PF <> hole16PFOld Then
			Print #201, "{", Chr$(&H22) + "hole16PF" + Chr$(&H22), ":", Str$(hole16PF), "}",
			hole16PFOld = hole16PF
		EndIf
		If hole17PF <> hole17PFOld Then
			Print #201, "{", Chr$(&H22) + "hole17PF" + Chr$(&H22), ":", Str$(hole17PF), "}",
			hole17PFOld = hole17PF
		EndIf
		If hole18PF <> hole18PFOld Then
			Print #201, "{", Chr$(&H22) + "hole18PF" + Chr$(&H22), ":", Str$(hole18PF), "}",
			hole18PFOld = hole18PF
		EndIf
		If hole19PF <> hole19PFOld Then
			Print #201, "{", Chr$(&H22) + "hole19PF" + Chr$(&H22), ":", Str$(hole19PF), "}",
			hole19PFOld = hole19PF
		EndIf
		If hole1PF <> hole1PFOld Then
			Print #201, "{", Chr$(&H22) + "hole1PF" + Chr$(&H22), ":", Str$(hole1PF), "}",
			hole1PFOld = hole1PF
		EndIf
		If hole20PF <> hole20PFOld Then
			Print #201, "{", Chr$(&H22) + "hole20PF" + Chr$(&H22), ":", Str$(hole20PF), "}",
			hole20PFOld = hole20PF
		EndIf
		If hole21PF <> hole21PFOld Then
			Print #201, "{", Chr$(&H22) + "hole21PF" + Chr$(&H22), ":", Str$(hole21PF), "}",
			hole21PFOld = hole21PF
		EndIf
		If hole22PF <> hole22PFOld Then
			Print #201, "{", Chr$(&H22) + "hole22PF" + Chr$(&H22), ":", Str$(hole22PF), "}",
			hole22PFOld = hole22PF
		EndIf
	
	
		If hole23PF <> hole23PFOld Then
			Print #201, "{", Chr$(&H22) + "hole23PF" + Chr$(&H22), ":", Str$(hole23PF), "}",
			hole23PFOld = hole23PF
		EndIf
	
	
		If hole2PF <> hole2PFOld Then
			Print #201, "{", Chr$(&H22) + "hole2PF" + Chr$(&H22), ":", Str$(hole2PF), "}",
			hole2PFOld = hole2PF
		EndIf
		If hole3PF <> hole3PFOld Then
			Print #201, "{", Chr$(&H22) + "hole3PF" + Chr$(&H22), ":", Str$(hole3PF), "}",
			hole3PFOld = hole3PF
		EndIf
		If hole4PF <> hole4PFOld Then
			Print #201, "{", Chr$(&H22) + "hole4PF" + Chr$(&H22), ":", Str$(hole4PF), "}",
			hole4PFOld = hole4PF
		EndIf
		If hole5PF <> hole5PFOld Then
			Print #201, "{", Chr$(&H22) + "hole5PF" + Chr$(&H22), ":", Str$(hole5PF), "}",
			hole5PFOld = hole5PF
		EndIf
		If hole6PF <> hole6PFOld Then
			Print #201, "{", Chr$(&H22) + "hole6PF" + Chr$(&H22), ":", Str$(hole6PF), "}",
			hole6PFOld = hole6PF
		EndIf
		If hole7PF <> hole7PFOld Then
			Print #201, "{", Chr$(&H22) + "hole7PF" + Chr$(&H22), ":", Str$(hole7PF), "}",
			hole7PFOld = hole7PF
		EndIf
		If hole8PF <> hole8PFOld Then
			Print #201, "{", Chr$(&H22) + "hole8PF" + Chr$(&H22), ":", Str$(hole8PF), "}",
			hole8PFOld = hole8PF
		EndIf
		If hole9PF <> hole9PFOld Then
			Print #201, "{", Chr$(&H22) + "hole9PF" + Chr$(&H22), ":", Str$(hole9PF), "}",
			hole9PFOld = hole9PF
		EndIf
		If inMagCurrentState <> inMagCurrentStateOld Then
			Print #201, "{", Chr$(&H22) + "inMagCurrentState" + Chr$(&H22), ":", Str$(inMagCurrentState), "}",
			inMagCurrentStateOld = inMagCurrentState
		EndIf
		If jobDone <> jobDoneOld Then
			Print #201, "{", Chr$(&H22) + "jobDone" + Chr$(&H22), ":", Str$(jobDone), "}",
			jobDoneOld = jobDone
		EndIf
		If jobNumPanelsDone <> jobNumPanelsDoneOld Then
			Print #201, "{", Chr$(&H22) + "jobNumPanelsDone" + Chr$(&H22), ":", Str$(jobNumPanelsDone), "}",
			jobNumPanelsDoneOld = jobNumPanelsDone
		EndIf
		If mainCurrentState <> mainCurrentStateOld Then
			Print #201, "{", Chr$(&H22) + "mainCurrentState" + Chr$(&H22), ":", Str$(mainCurrentState), "}",
			mainCurrentStateOld = mainCurrentState
		EndIf
		If outMagCurrentState <> outMagCurrentStateOld Then
			Print #201, "{", Chr$(&H22) + "outMagCurrentState" + Chr$(&H22), ":", Str$(outMagCurrentState), "}",
			outMagCurrentStateOld = outMagCurrentState
		EndIf
		If panelDataTxRdy <> panelDataTxRdyOld Then
			Print #201, "{", Chr$(&H22) + "panelDataTxRdy" + Chr$(&H22), ":", Str$(panelDataTxRdy), "}",
			panelDataTxRdyOld = panelDataTxRdy
		EndIf


		'PLC values of interest
		If MemSw(m_inserting) <> m_insertingOld Then
			Print #201, "{", Chr$(&H22) + "PLC_inserting" + Chr$(&H22), ":", Str$(MemSw(m_inserting)), "}",
			m_insertingOld = MemSw(m_inserting)
		EndIf
		If MemSw(m_idle) <> m_idleOld Then
			Print #201, "{", Chr$(&H22) + "PLC_idle" + Chr$(&H22), ":", Str$(MemSw(m_idle)), "}",
			m_idleOld = MemSw(m_idle)
		EndIf
		If MemSw(m_ready) <> m_readyOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ready" + Chr$(&H22), ":", Str$(MemSw(m_ready)), "}",
			m_readyOld = MemSw(m_ready)
		EndIf
		If MemSw(m_bootDelay) <> m_bootDelayOld Then
			Print #201, "{", Chr$(&H22) + "PLC_bootDelay" + Chr$(&H22), ":", Str$(MemSw(m_bootDelay)), "}",
			m_bootDelayOld = MemSw(m_bootDelay)
		EndIf
		If MemSw(m_bootDone) <> m_bootDoneOld Then
			Print #201, "{", Chr$(&H22) + "PLC_bootDone" + Chr$(&H22), ":", Str$(MemSw(m_bootDone)), "}",
			m_bootDoneOld = MemSw(m_bootDone)
		EndIf
		If MemSw(m_findingHome) <> m_findingHomeOld Then
			Print #201, "{", Chr$(&H22) + "PLC_findingHome" + Chr$(&H22), ":", Str$(MemSw(m_findingHome)), "}",
			m_findingHomeOld = MemSw(m_findingHome)
		EndIf
		If MemSw(m_dumpRunning) <> m_dumpRunningOld Then
			Print #201, "{", Chr$(&H22) + "PLC_dumpRunning" + Chr$(&H22), ":", Str$(MemSw(m_dumpRunning)), "}",
			m_dumpRunningOld = MemSw(m_dumpRunning)
		EndIf
		If MemSw(m_manualModeOn) <> m_manualModeOnOld Then
			Print #201, "{", Chr$(&H22) + "PLC_manualModeOn" + Chr$(&H22), ":", Str$(MemSw(m_manualModeOn)), "}",
			m_manualModeOnOld = MemSw(m_manualModeOn)
		EndIf
		If MemSw(m_erInsertTemp) <> m_erInsertTempOld Then
			Print #201, "{", Chr$(&H22) + "PLC_erInsertTemp" + Chr$(&H22), ":", Str$(MemSw(m_erInsertTemp)), "}",
			m_erInsertTempOld = MemSw(m_erInsertTemp)
		EndIf
		If MemSw(m_erServoNotRdy) <> m_erServoNotRdyOld Then
			Print #201, "{", Chr$(&H22) + "PLC_erServoNotRdy" + Chr$(&H22), ":", Str$(MemSw(m_erServoNotRdy)), "}",
			m_erServoNotRdyOld = MemSw(m_erServoNotRdy)
		EndIf
		If MemSw(m_HeaterMCROn) <> m_HeaterMCROnOld Then
			Print #201, "{", Chr$(&H22) + "PLC_HeaterMCROn" + Chr$(&H22), ":", Str$(MemSw(m_HeaterMCROn)), "}",
			m_HeaterMCROnOld = MemSw(m_HeaterMCROn)
		EndIf
		If MemSw(m_BowlFeederOn) <> m_BowlFeederOnOld Then
			Print #201, "{", Chr$(&H22) + "PLC_BowlFeederOn" + Chr$(&H22), ":", Str$(MemSw(m_BowlFeederOn)), "}",
			m_BowlFeederOnOld = MemSw(m_BowlFeederOn)
		EndIf
		If MemSw(m_VibTrackOn) <> m_VibTrackOnOld Then
			Print #201, "{", Chr$(&H22) + "PLC_VibTrackOn" + Chr$(&H22), ":", Str$(MemSw(m_VibTrackOn)), "}",
			m_VibTrackOnOld = MemSw(m_VibTrackOn)
		EndIf
		If MemSw(m_LoadInsert) <> m_LoadInsertOld Then
			Print #201, "{", Chr$(&H22) + "PLC_LoadInsert" + Chr$(&H22), ":", Str$(MemSw(m_LoadInsert)), "}",
			m_LoadInsertOld = MemSw(m_LoadInsert)
		EndIf
		If MemSw(m_ExtendShuttle) <> m_ExtendShuttleOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ExtendShuttle" + Chr$(&H22), ":", Str$(MemSw(m_ExtendShuttle)), "}",
			m_ExtendShuttleOld = MemSw(m_ExtendShuttle)
		EndIf
		If MemSw(m_ActiveCooling) <> m_ActiveCoolingOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ActiveCooling" + Chr$(&H22), ":", Str$(MemSw(m_ActiveCooling)), "}",
			m_ActiveCoolingOld = MemSw(m_ActiveCooling)
		EndIf
		If MemSw(m_InsertGripper) <> m_InsertGripperOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertGripper" + Chr$(&H22), ":", Str$(MemSw(m_InsertGripper)), "}",
			m_InsertGripperOld = MemSw(m_InsertGripper)
		EndIf
		If MemSw(m_InsertDischarg) <> m_InsertDischargOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertDischarg" + Chr$(&H22), ":", Str$(MemSw(m_InsertDischarg)), "}",
			m_InsertDischargOld = MemSw(m_InsertDischarg)
		EndIf
		If MemSw(m_InsertReject) <> m_InsertRejectOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertReject" + Chr$(&H22), ":", Str$(MemSw(m_InsertReject)), "}",
			m_InsertRejectOld = MemSw(m_InsertReject)
		EndIf
		If MemSw(m_EmgStop) <> m_EmgStopOld Then
			Print #201, "{", Chr$(&H22) + "PLC_EmgStop" + Chr$(&H22), ":", Str$(MemSw(m_EmgStop)), "}",
			m_EmgStopOld = MemSw(m_EmgStop)
		EndIf
		If MemSw(m_ShuttleParked) <> m_ShuttleParkedOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ShuttleParked" + Chr$(&H22), ":", Str$(MemSw(m_ShuttleParked)), "}",
			m_ShuttleParkedOld = MemSw(m_ShuttleParked)
		EndIf
		If MemSw(m_ShuttlePickup) <> m_ShuttlePickupOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ShuttlePickup" + Chr$(&H22), ":", Str$(MemSw(m_ShuttlePickup)), "}",
			m_ShuttlePickupOld = MemSw(m_ShuttlePickup)
		EndIf
		If MemSw(m_ShuttlePI) <> m_ShuttlePIOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ShuttlePI" + Chr$(&H22), ":", Str$(MemSw(m_ShuttlePI)), "}",
			m_ShuttlePIOld = MemSw(m_ShuttlePI)
		EndIf
		If MemSw(m_ShuttleNPI) <> m_ShuttleNPIOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ShuttleNPI" + Chr$(&H22), ":", Str$(MemSw(m_ShuttleNPI)), "}",
			m_ShuttleNPIOld = MemSw(m_ShuttleNPI)
		EndIf
		If MemSw(m_InsertOnShuttl) <> m_InsertOnShuttlOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertOnShuttl" + Chr$(&H22), ":", Str$(MemSw(m_InsertOnShuttl)), "}",
			m_InsertOnShuttlOld = MemSw(m_InsertOnShuttl)
		EndIf
		If MemSw(m_InsertDetected) <> m_InsertdetectedOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Insertdetected" + Chr$(&H22), ":", Str$(MemSw(m_InsertDetected)), "}",
			m_InsertdetectedOld = MemSw(m_InsertDetected)
		EndIf
		If MemSw(m_InsertDetAlu) <> m_InsertDetAluOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertDetAlu" + Chr$(&H22), ":", Str$(MemSw(m_InsertDetAlu)), "}",
			m_InsertDetAluOld = MemSw(m_InsertDetAlu)
		EndIf
		If MemSw(m_InsertAtTemp) <> m_InsertAtTempOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertAtTemp" + Chr$(&H22), ":", Str$(MemSw(m_InsertAtTemp)), "}",
			m_InsertAtTempOld = MemSw(m_InsertAtTemp)
		EndIf
		If MemSw(m_GripperEarsOut) <> m_GripperEarsOutOld Then
			Print #201, "{", Chr$(&H22) + "PLC_GripperEarsOut" + Chr$(&H22), ":", Str$(MemSw(m_GripperEarsOut)), "}",
			m_GripperEarsOutOld = MemSw(m_GripperEarsOut)
		EndIf
		If MemSw(m_GripperEarsIn) <> m_GripperEarsInOld Then
			Print #201, "{", Chr$(&H22) + "PLC_GripperEarsIn" + Chr$(&H22), ":", Str$(MemSw(m_GripperEarsIn)), "}",
			m_GripperEarsInOld = MemSw(m_GripperEarsIn)
		EndIf

		
		
		If PLC_Delay_BlowOffTime <> PLC_Delay_BlowOffTimeOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_BlowOffTime" + Chr$(&H22), ":", Str$(PLC_Delay_BlowOffTime), "}",
			PLC_Delay_BlowOffTimeOld = PLC_Delay_BlowOffTime
		EndIf
		If PLC_Delay_InsertLoad <> PLC_Delay_InsertLoadOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_InsertLoad" + Chr$(&H22), ":", Str$(PLC_Delay_InsertLoad), "}",
			PLC_Delay_InsertLoadOld = PLC_Delay_InsertLoad
		EndIf
		If PLC_Speed_TorqueMode <> PLC_Speed_TorqueModeOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Speed_TorqueMode" + Chr$(&H22), ":", Str$(PLC_Speed_TorqueMode), "}",
			PLC_Speed_TorqueModeOld = PLC_Speed_TorqueMode
		EndIf
		If PLC_Torque_TorqueMode <> PLC_Torque_TorqueModeOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Torque_TorqueMode" + Chr$(&H22), ":", Str$(PLC_Torque_TorqueMode), "}",
			PLC_Torque_TorqueModeOld = PLC_Torque_TorqueMode
		EndIf
		If PLC_Delay_RejectBlowOff <> PLC_Delay_RejectBlowOffOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_RejectBlowOff" + Chr$(&H22), ":", Str$(PLC_Delay_RejectBlowOff), "}",
			PLC_Delay_RejectBlowOffOld = PLC_Delay_RejectBlowOff
		EndIf
		If PLC_Delay_FindHome <> PLC_Delay_FindHomeOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_FindHome" + Chr$(&H22), ":", Str$(PLC_Delay_FindHome), "}",
			PLC_Delay_FindHomeOld = PLC_Delay_FindHome
		EndIf
		If PLC_Delay_ActiveCooling <> PLC_Delay_ActiveCoolingOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_ActiveCooling" + Chr$(&H22), ":", Str$(PLC_Delay_ActiveCooling), "}",
			PLC_Delay_ActiveCoolingOld = PLC_Delay_ActiveCooling
		EndIf
		If PLC_Delay_TorqueDwell <> PLC_Delay_TorqueDwellOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_TorqueDwell" + Chr$(&H22), ":", Str$(PLC_Delay_TorqueDwell), "}",
			PLC_Delay_TorqueDwellOld = PLC_Delay_TorqueDwell
		EndIf
		If PLC_Delay_Gripper <> PLC_Delay_GripperOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_Gripper" + Chr$(&H22), ":", Str$(PLC_Delay_Gripper), "}",
			PLC_Delay_GripperOld = PLC_Delay_Gripper
		EndIf
		If PLC_Delay_PanelContact <> PLC_Delay_PanelContactOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_PanelContact" + Chr$(&H22), ":", Str$(PLC_Delay_PanelContact), "}",
			PLC_Delay_PanelContactOld = PLC_Delay_PanelContact
		EndIf
		If PLC_Delay_ShuttleExtended <> PLC_Delay_ShuttleExtendedOld Then
			Print #201, "{", Chr$(&H22) + "PLC_Delay_ShuttleExtended" + Chr$(&H22), ":", Str$(PLC_Delay_ShuttleExtended), "}",
			PLC_Delay_ShuttleExtendedOld = PLC_Delay_ShuttleExtended
		EndIf
		If PLC_InsertType <> PLC_InsertTypeOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertType" + Chr$(&H22), ":", Str$(PLC_InsertType), "}",
			PLC_InsertTypeOld = PLC_InsertType
		EndIf
		If PLC_PanelContactTorque <> PLC_PanelContactTorqueOld Then
			Print #201, "{", Chr$(&H22) + "PLC_PanelContactTorque" + Chr$(&H22), ":", Str$(PLC_PanelContactTorque), "}",
			PLC_PanelContactTorqueOld = PLC_PanelContactTorque
		EndIf
		If PLC_InsertTempOkBand <> PLC_InsertTempOkBandOld Then
			Print #201, "{", Chr$(&H22) + "PLC_InsertTempOkBand" + Chr$(&H22), ":", Str$(PLC_InsertTempOkBand), "}",
			PLC_InsertTempOkBandOld = PLC_InsertTempOkBand
		EndIf
		If PLC_PID_SetValue <> PLC_PID_SetValueOld Then
			Print #201, "{", Chr$(&H22) + "PLC_PID_SetValue" + Chr$(&H22), ":", Str$(PLC_PID_SetValue), "}",
			PLC_PID_SetValueOld = PLC_PID_SetValue
		EndIf
		If PLC_PID_ProcessValue <> PLC_PID_ProcessValueOld Then
			Print #201, "{", Chr$(&H22) + "PLC_PID_ProcessValue" + Chr$(&H22), ":", Str$(PLC_PID_ProcessValue), "}",
			PLC_PID_ProcessValueOld = PLC_PID_ProcessValue
		EndIf
		If PLC_ServoMotorCurrentValue <> PLC_ServoMotorCurrentValueOld Then
			Print #201, "{", Chr$(&H22) + "PLC_ServoMotorCurrentValue" + Chr$(&H22), ":", Str$(PLC_ServoMotorCurrentValue), "}",
			PLC_ServoMotorCurrentValueOld = PLC_ServoMotorCurrentValue
		EndIf

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
	
	Select tokens$(0)
	'Rx from HMI:

	Case "alarmMuteBtn"
		If tokens$(1) = "true" Then
			alarmMuteBtn = True
			alarmMute = True
		Else
			alarmMuteBtn = False
		EndIf
	Case "backInterlockACKBtn"
		If tokens$(1) = "true" Then
			backInterlockACKBtn = True
			backInterlockACK = True
		Else
			backInterlockACKBtn = False
		EndIf
	Case "frontInterlockACKBtn"
		If tokens$(1) = "true" Then
			frontInterlockACKBtn = True
			frontInterlockACK = True
		Else
			frontInterlockACKBtn = False
		EndIf
	Case "inMagGoHomeBtn"
		If tokens$(1) = "true" Then
			inMagGoHomeBtn = True
			inMagGoHome = True
		Else
			inMagGoHomeBtn = False
		EndIf
	Case "inMagLoadedBtn"
		If tokens$(1) = "true" Then
			inMagLoadedBtn = True
			inMagLoaded = True
		Else
			inMagLoadedBtn = False
		EndIf
	Case "jobAbortBtn"
		If tokens$(1) = "true" Then
			jobAbortBtn = True
			jobAbort = True
		Else
			jobAbortBtn = False
		EndIf
	Case "jobStartBtn"
		If tokens$(1) = "true" Then
			jobStartBtn = True
			jobStart = True
		Else
			jobStartBtn = False
		EndIf
	Case "leftInterlockACKBtn"
		If tokens$(1) = "true" Then
			leftInterlockACKBtn = True
			leftInterlockACK = True
		Else
			leftInterlockACKBtn = False
		EndIf
	Case "outMagGoHomeBtn"
		If tokens$(1) = "true" Then
			outMagGoHomeBtn = True
			outMagGoHome = True
		Else
			outMagGoHomeBtn = False
		EndIf
	Case "outMagUnloadedBtn"
		If tokens$(1) = "true" Then
			outMagUnloadedBtn = True
			outMagUnloaded = True
		Else
			outMagUnloadedBtn = False
		EndIf
	Case "panelDataTxACKBtn"
		If tokens$(1) = "true" Then
			panelDataTxACKBtn = True
			panelDataTxACK = True
		Else
			panelDataTxACKBtn = False
		EndIf
	Case "rightInterlockACKBtn"
		If tokens$(1) = "true" Then
			rightInterlockACKBtn = True
			rightInterlockACK = True
		Else
			rightInterlockACKBtn = False
		EndIf
	Case "sftyFrmIlockAckBtn"
		If tokens$(1) = "true" Then
			sftyFrmIlockAckBtn = True
			sftyFrmIlockAck = True
		Else
			sftyFrmIlockAckBtn = False
		EndIf
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
	Case "backIntlock1F"
		If tokens$(1) = "true" Then
			MemOn (backIntlock1F)
		Else
			MemOff (backIntlock1F)
		EndIf
	Case "backIntlock1FV"
		If tokens$(1) = "true" Then
			MemOn (backIntlock1FV)
		Else
			MemOff (backIntlock1FV)
		EndIf
	Case "backIntlock2F"
		If tokens$(1) = "true" Then
			MemOn (backIntlock2F)
		Else
			MemOff (backIntlock2F)
		EndIf
	Case "backIntlock2FV"
		If tokens$(1) = "true" Then
			MemOn (backIntlock2FV)
		Else
			MemOff (backIntlock2FV)
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
	Case "cbMonHeatStakeF"
		If tokens$(1) = "true" Then
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
	Case "recTempProbe"
		recTempProbe = Val(Tokens$(1))
	Case "recTempTrack"
		recTempTrack = Val(Tokens$(1))
	Case "recFirstHolePointInspection"
		recFirstHolePointInspection = Val(Tokens$(1))
	Case "recLastHolePointInspection"
		recLastHolePointInspection = Val(Tokens$(1))
	Case "recFirstHolePointHotStake"
		recFirstHolePointHotStake = Val(Tokens$(1))
	Case "recLastHolePointHotStake"
		recLastHolePointHotStake = Val(Tokens$(1))
	Case "recFirstHolePointFlash"
		recFirstHolePointFlash = Val(Tokens$(1))
	Case "recLastHolePointFlash"
		recLastHolePointFlash = Val(Tokens$(1))
	Case "recFlashDwellTime"
		recFlashDwellTime = Val(Tokens$(1))
	Case "recHeatStakeOffset"
		recHeatStakeOffset = Val(Tokens$(1))
	Case "recBossCrossArea"
		recBossCrossArea = Val(Tokens$(1))
	Case "recPointsTable"
		recPointsTable = Val(Tokens$(1))
	Case "recInmag"
		recInmag = Val(Tokens$(1))
	Case "recOutmag"
		recOutmag = Val(Tokens$(1))
	Case "recCrowding"
		recCrowding = Val(Tokens$(1))
	Case "recPreCrowding"
		recPreCrowding = Val(Tokens$(1))
	Case "jobNumPanels"
		jobNumPanels = Val(Tokens$(1))
	Case "recFlashRequired"
		If Tokens$(1) = "true" Then
			recFlashRequired = True
		Else
			recFlashRequired = False
		EndIf
	Case "recInmagPickupOffset"
		recInmagPickupOffset = Val(Tokens$(1))
	Case "recInsertDepth"
		recInsertDepth = Val(Tokens$(1))
	Case "recFlashDwellTime"
		recFlashDwellTime = Val(Tokens$(1))
	Case "recInsertType"
		recInsertType = Val(Tokens$(1))
	Case "recNumberOfHoles"
		recNumberOfHoles = Val(Tokens$(1))
	Case "recOutmagPickupOffset"
		recOutmagPickupOffset = Val(Tokens$(1))
	Case "suctionWaitTime"
		recSuctionWaitTime = Val(Tokens$(1))
	Case "zlimit"
		zLimit = Val(Tokens$(1))
		
	' PLC Comms
	Case "PLC_Delay_BlowOffTime"
		Print "put write request into queue"
		MBWrite(1000, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_InsertLoad"
		MBWrite(1001, Val(Tokens$(1)), MBType16)
	Case "PLC_Speed_TorqueMode"
		MBWrite(1002, Val(Tokens$(1)), MBType32)
	Case "PLC_Torque_TorqueMode"
		MBWrite(1004, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_RejectBlowOff"
		MBWrite(1005, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_FindHome"
		MBWrite(1006, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_ActiveCooling"
		MBWrite(1007, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_TorqueDwell"
		MBWrite(1008, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_Gripper"
		MBWrite(1009, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_PanelContact"
		MBWrite(1010, Val(Tokens$(1)), MBType16)
	Case "PLC_Delay_ShuttleExtended"
		MBWrite(1011, Val(Tokens$(1)), MBType16)
	Case "PLC_InsertType"
		MBWrite(1020, Val(Tokens$(1)), MBType16)
	Case "PLC_PanelContactTorque"
		MBWrite(1021, Val(Tokens$(1)), MBType16)
	Case "PLC_InsertTempOkBand"
		MBWrite(1022, Val(Tokens$(1)), MBType16)
	Case "PLC_PID_SetValue"
		MBWrite(1130, Val(Tokens$(1)), MBType16)
	Case "PLC_HeaterMCROn_MM"
		If Tokens$(1) = "true" Then
			MBWrite(434, True, MBTypeCoil)
		Else
			MBWrite(434, False, MBTypeCoil)
		EndIf
	Case "PLC_HeaterMCROn_VALUE"
		If Tokens$(1) = "true" Then
			MBWrite(435, True, MBTypeCoil)
		Else
			MBWrite(435, False, MBTypeCoil)
		EndIf
	Case "PLC_BowlFeederOn_MM"
		If Tokens$(1) = "true" Then
			MBWrite(436, True, MBTypeCoil)
		Else
			MBWrite(436, False, MBTypeCoil)
		EndIf
	Case "PLC_BowlFeederOn_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(437, True, MBTypeCoil)
		Else
			MBWrite(437, False, MBTypeCoil)
		EndIf
	Case "PLC_VibTrackOn_MM"
		If tokens$(1) = "true" Then
			MBWrite(438, True, MBTypeCoil)
		Else
			MBWrite(438, False, MBTypeCoil)
		EndIf
	Case "PLC_VibTrackOn_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(439, True, MBTypeCoil)
		Else
			MBWrite(439, False, MBTypeCoil)
		EndIf
	Case "PLC_LoadInsert_MM"
		If tokens$(1) = "true" Then
			MBWrite(440, True, MBTypeCoil)
		Else
			MBWrite(440, False, MBTypeCoil)
		EndIf
	Case "PLC_LoadInsert_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(441, True, MBTypeCoil)
		Else
			MBWrite(441, False, MBTypeCoil)
		EndIf
	Case "PLC_ExtendShuttle_MM"
		If tokens$(1) = "true" Then
			MBWrite(442, True, MBTypeCoil)
		Else
			MBWrite(442, False, MBTypeCoil)
		EndIf
	Case "PLC_ExtendShuttle_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(443, True, MBTypeCoil)
		Else
			MBWrite(443, False, MBTypeCoil)
		EndIf
	Case "PLC_ActiveCoolingOn_MM"
		If tokens$(1) = "true" Then
			MBWrite(444, True, MBTypeCoil)
		Else
			MBWrite(444, False, MBTypeCoil)
		EndIf
	Case "PLC_ActiveCoolingOn_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(445, True, MBTypeCoil)
		Else
			MBWrite(445, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertGripperOn_MM"
		If tokens$(1) = "true" Then
			MBWrite(446, True, MBTypeCoil)
		Else
			MBWrite(446, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertGripperOn_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(447, True, MBTypeCoil)
		Else
			MBWrite(447, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertDischargeOn_MM"
		If tokens$(1) = "true" Then
			MBWrite(448, True, MBTypeCoil)
		Else
			MBWrite(448, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertDischargeOn_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(449, True, MBTypeCoil)
		Else
			MBWrite(449, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertRejectOn_MM"
		If tokens$(1) = "true" Then
			MBWrite(450, True, MBTypeCoil)
		Else
			MBWrite(450, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertRejectOn_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(451, True, MBTypeCoil)
		Else
			MBWrite(451, False, MBTypeCoil)
		EndIf
	Case "PLC_EmgStop_MM"
		If tokens$(1) = "true" Then
			MBWrite(534, True, MBTypeCoil)
		Else
			MBWrite(534, False, MBTypeCoil)
		EndIf
	Case "PLC_EmgStop_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(535, True, MBTypeCoil)
		Else
			MBWrite(535, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttleParked_MM"
		If tokens$(1) = "true" Then
			MBWrite(536, True, MBTypeCoil)
		Else
			MBWrite(536, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttleParked_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(537, True, MBTypeCoil)
		Else
			MBWrite(537, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttlePickupPos_MM"
		If tokens$(1) = "true" Then
			MBWrite(538, True, MBTypeCoil)
		Else
			MBWrite(538, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttlePickupPos_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(539, True, MBTypeCoil)
		Else
			MBWrite(539, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttlePlaceInsert_MM"
		If tokens$(1) = "true" Then
			MBWrite(540, True, MBTypeCoil)
		Else
			MBWrite(540, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttlePlaceInsert_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(541, True, MBTypeCoil)
		Else
			MBWrite(541, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttleNearPlaceInsert_MM"
		If tokens$(1) = "true" Then
			MBWrite(542, True, MBTypeCoil)
		Else
			MBWrite(542, False, MBTypeCoil)
		EndIf
	Case "PLC_ShuttleNearPlaceInsert_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(543, True, MBTypeCoil)
		Else
			MBWrite(543, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertOnShuttle_MM"
		If tokens$(1) = "true" Then
			MBWrite(544, True, MBTypeCoil)
		Else
			MBWrite(544, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertOnShuttle_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(545, True, MBTypeCoil)
		Else
			MBWrite(545, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertDetected_MM"
		If tokens$(1) = "true" Then
			MBWrite(546, True, MBTypeCoil)
		Else
			MBWrite(546, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertDetected_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(547, True, MBTypeCoil)
		Else
			MBWrite(547, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertDetectedAluOnly_MM"
		If tokens$(1) = "true" Then
			MBWrite(548, True, MBTypeCoil)
		Else
			MBWrite(548, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertDetectedAluOnly_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(549, True, MBTypeCoil)
		Else
			MBWrite(549, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertAtTemp_MM"
		If tokens$(1) = "true" Then
			MBWrite(550, True, MBTypeCoil)
		Else
			MBWrite(550, False, MBTypeCoil)
		EndIf
	Case "PLC_InsertAtTemp_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(551, True, MBTypeCoil)
		Else
			MBWrite(551, False, MBTypeCoil)
		EndIf
	Case "PLC_GripperEarsOut_MM"
		If tokens$(1) = "true" Then
			MBWrite(552, True, MBTypeCoil)
		Else
			MBWrite(552, False, MBTypeCoil)
		EndIf
	Case "PLC_GripperEarsOut_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(553, True, MBTypeCoil)
		Else
			MBWrite(553, False, MBTypeCoil)
		EndIf
	Case "PLC_GripperEarsIn_MM"
		If tokens$(1) = "true" Then
			MBWrite(554, True, MBTypeCoil)
		Else
			MBWrite(554, False, MBTypeCoil)
		EndIf
	Case "PLC_GripperEarsIn_VALUE"
		If tokens$(1) = "true" Then
			MBWrite(555, True, MBTypeCoil)
		Else
			MBWrite(555, False, MBTypeCoil)
		EndIf


	' /end PLC comms
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


