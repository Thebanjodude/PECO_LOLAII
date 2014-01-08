' Used Timers
' TMR-
'	0  -  IOT (hmi comms) - iotransfer()
'	1  -  Crowding open delay -- crowdingSequence()
'	2  -  
'	3  -  dump delay (obsoleted)
'	4  -  
'	5  -  
'	6  -  
'	7  -  
'	8  -  
'	9  -  
'	10 -  OutMagControlRefactor() - delay before sensing a panel
'	11 -  
'	12 -  
'	13 -  
'	14 -  
'	15 -  

' System Global Vars and #defines
Global Integer SystemSpeed, SystemAccel, mainCurrentState
Global Boolean suctionCups, suctionCupsCC, holeDetected, maintMode
Global Integer systemStatus ' Integer that tells opperator what state the sytem is in-see State tab in IOT
Global Real zLimit ' the highest the EOAT can move without hitting periphials
#define ScanSpeed 35 ' Percent Speed the arm moves during the scanning process
#define Zaxis 3 ' The z axis is address by "3" (x,y,z,theta)
#define Preinspection 1
#define Postinspection 2
Global Real ZmaxTorque ' Monitors Z torque
Global Integer Crowding

'Global Integer NextState
Global Boolean monEstop1, monEstop2, jobAbortBtn, alarmMute, alarmTog, alarmMuteBtn
Global Boolean edgeDetectGo, edgeDetectHi, edgeDetectLo, pauseFlag
Global Boolean panelDataTxACKBtn, eStopReset, eStopResetCC
Global Boolean GoFlag, ReturnFlag 'flags to make sure we dont break the drill

'Main() States
#define StateUnknown 0
#define StateIdle 1
#define StatePaused 2
#define StatePopPanel 3
#define StateMoving 4
#define StatePreinspection 5
#define StateHotStakePanel 6
#define StateFlashRemoval 7
#define StateInspection 8
#define StatePushPanel 9
#define StateCrowding 10
#define StateEmptyingBowlandTrack 11

'Inmag States
#define StateInMagUnknown 0
#define StatePartPresent 1
#define StatePartRemoved 2
#define StatePresentNextPart 3
#define StateLowering 4
#define StateWaitingUser 5
#define StateInMagPaused 6

'PickUpPanel Return Values
#define PickupSuccessful 0
#define InmagIlockOpen 1
#define InmagError 2

'Outmag States
#define StateOutMagUnknown 0
#define StateReadyToReceive 1
#define StateOutMagPartPresent 2
#define StateOutMagLowering 3
#define StateOutMagWaitingUser 4
#define StateRaising 5
#define StateGoHome 6
#define StateOutMagPaused 7

'DropOffPanel Return Values
#define DropoffSuccessful 0
#define OutmagIlockOpen 1
#define OutmagError 2
Global Integer OutmagLastState

'Commands from HMI
Global Boolean jobDone
Global Integer jobNumPanels, jobNumPanelsDone, jobAbort
Global Boolean backInterlockACKBtn, frontInterlockACKBtn
Global Boolean inMagGoHomeBtn, inMagIntLockAckBtn, inMagLoadedBtn
Global Boolean jobPauseBtn, jobResumeBtn, jobStartBtn, abortJobBtn
Global Boolean jobStopBtn, leftInterlockACKBtn, outMagGoHomeBtn
Global Boolean outMagIntLockAckBtn, outMagUnloadedBtn, rightInterlockACKBtn, sftyFrmIlockAckBtn
Global Boolean backInterlockACK, frontInterlockACK
Global Boolean jobPause, jobResume, jobStart
Global Boolean jobStop, leftInterlockACK
Global Boolean rightInterlockACK, sftyFrmIlockAck

' Input Magazine Global Vars
Global Boolean inMagGoHome, inMagLoaded, inMagPnlRdy, inMagMtr, inMagMtrDir ' DIO to run intput the magazine
Global Boolean inMagLowLim, inMagUpLim, inMagInterlock, inMagIntLockAck
Global Boolean inMagLowLimN, inMagUpLimN
Global Real InMagTorqueLim
Global Integer inMagCurrentState
Global Boolean inMagMtrCC, inMagMtrDirCC
Global Boolean InMagRobotClearSignal  ' Signal robot is out of the way,OK to move Inmag
Global Boolean InMagPickUpSignal  ' Signal robot it can pick up a panel from inmag
Global Integer InmagLastState

' Output Magazine Global Vars
Global Boolean outMagGoHome, outMagUnloaded, OutputMagSignal, outMagMtr 'DIO to run the output magazine
Global Boolean outMagPanelRdy, outMagMtrDir, outMagUpLim, outMagUpLimN
Global Boolean outMagLowLim, outMagLowLimN, outMagInt, outMagIntLockAck
Global Real OutMagTorqueLim, recOutmagPickupOffset
Global Boolean OutMagDropOffSignal ' Signal robot it can Drop Off a panel to outmag
Global Boolean OutMagRobotClearSignal  ' Signal robot is out of the way,OK to move outmag
Global Integer outMagCurrentState
Global Boolean outMagMtrCC, outMagMtrDirCC, RobotPlacedPanel

'Inspection Station Global Vars
Global Boolean PanelPassedInspection ' Indicates if the panel passes inspection
Global Integer x, z ' Increment for P(x) to define edge and num of holes found
Global Real CurrentThetaHere, insertDepthTolerance
Global Boolean PassFailArray(0, 0)
Global Real InspectionArray(0, 0), recInmagPickupOffset
Global Boolean SkipHoleArray(0, 0), DeepBoss, MediumBoss ' This needs to be global
Global Boolean panelDataTxRdy, panelDataTxACK
Global Integer currentInspectHole, currentPreinspectHole
#define RightSpotFace 1
#define LeftSpotFace 0

'System Monitor Vars
Global Boolean cbMonHeatStake, cbMonInMag, cbMonOutMag, cbMonDebrisRmv, cbMonSafety, cbMonPAS24vdc
Global Boolean stackLightRed, stackLightYel, stackLightGrn, stackLightAlrm
Global Boolean stackLightRedCC, stackLightYelCC, stackLightGrnCC, stackLightAlrmCC
Global Boolean airPressHigh, airPressLow
Global Boolean backIntlock1, frontIntlock1, leftIntlock1, rightIntlock
Global Boolean backIntlock2, frontIntlock2, leftIntlock2
Global Boolean heartBeat, dc24vOK

'Flash Removal Global Vars
Global Boolean SkippedLastHole, flashPanelPresnt
Global Boolean drillGo, drillReturn, FlashPnlPrsnt, debrisMtr, FlashHomeCC, flashHomeNO, flashHomeNC
Global Boolean drillGoCC, drillReturnCC, debrisMtrCC
Global Integer currentFlashHole

'Heat Stake Global Vars
Global Boolean hsPanelPresnt
Global Boolean boot, gotoReady, doInsertion, DoneInserting, startDump, doneDumping
Global Boolean bootCC, gotoReadyCC, doInsertionCC, doneInsertingCC, startDumpCC, doneDumpingCC
Global Boolean bootDelay, idle, ready, inserting, dumping
Global Integer currentHSHole
Global Real ZSpotfacetoQuillOffset, ZLasertoHeatStake, HSProbeFinalPosition
Global Real PreInspectionArray(0, 0)

' Recipe Ingredients for Panels
#define InsertTypeUnknown 0
#define AluminumInsert 1
#define StainlessInsert 2
#define xCoord 0
#define YCoord 1
Global Integer recNumberOfHoles, recInsertType, recInmag, recOutmag, recCrowding, recPreCrowding
Global Double recPartNumber
Global Boolean recFlashRequired, recPopPanelRequired, recPreinspectionRequired, recCrowdingRequired
Global Boolean recHotStakePanelRequired, recInspectionRequired, recPushPanelRequired
Global Real recInsertDepth, recZLaserToHeatStake, recHeatStakeOffset
Global Real recTempProbe, recTempTrack, recBossCrossArea, recSuctionWaitTime
Global Integer recFirstHolePointInspection, recLastHolePointInspection
Global Integer recFirstHolePointHotStake, recLastHolePointHotStake, recPointsTable
Global Integer recFirstHolePointFlash, recLastHolePointFlash
Global Real recFlashDwellTime ' How long the flash tool is in contact with the insert

'Error Vars
Global Boolean erPanelFailedInspection, erFrontSafetyFrameOpen, erBackSafetyFrameOpen
Global Boolean erLeftSafetyFrameOpen, erRightSafetyFrameOpen, erLowPressure
Global Boolean erHighPressure, erPanelStatusUnknown, erWrongPanelHoles
Global Boolean erWrongPanelDims, erWrongPanel, erWrongPanelInsert, erHmiDataAck
Global Boolean erInMagEmpty, erInMagOpenInterlock, erOutMagCrowding, erPanelUndefined
Global Boolean erInMagCrowding, erOutMagFull, erOutMagOpenInterlock, erBadPressureSensor
Global Boolean erLaserScanner, erDCPower, erDCPowerHeatStake, erHeatStakeTemp
Global Boolean erHeatStakeBreaker, erBowlFeederBreaker, erInMagBreaker ', erModbusPort, erModbusCommand,erModbusCommand
Global Boolean erOutMagBreaker, erFlashBreaker, erDebrisRemovalBreaker
Global Boolean erPnumaticsBreaker, erSafetySystemBreaker, erRC180, erIllegalArmMove
Global Boolean erUnknown, erEstop, erRecEntryMissing, erParamEntryMissing, erRobotNotAtHome
Global Boolean RecEntryMissing, ParamEntryMissing, erHMICommunication, erFlashStation
Global Boolean erInMagLowSensorBad, erInMagUpSensorBad, erOutMagLowSensorBad, erOutMagUpSensorBad
'modbus monitoring variables
Boolean erModbusTimeout 'did not recieve response before timeout
Boolean erModbusPort ' TCP port to HMI is not open
Boolean erModbusCommand ' Invalid command or parameter in modbus communication

'State of Health Global Vars and defines
Global Integer StatusCheckPickUp, StatusCheckCrowding, StatusCheckPreinspection, StatusCheckInspection
Global Integer StatusCheckHotStake, StatusCheckFlash, StatusCheckDropOff
Global String ctrlrErrMsg$
Global Integer ctrlrLineNumber, ctrlrTaskNumber, ctrlrErrAxisNumber, ctrlrErrorNum
Global Boolean motorOnStatus, motorPowerStatus, eStopStatus, errorStatus
Global Boolean tasksRunningStatus, pauseStatus, teachModeStatus, homePositionStatus
Global Boolean joint1Status, joint2Status, joint3Status, joint4Status, safeGuardInput

#define MotorOnStatusBitNum 4
#define MotorPowerStatusBitNum 6
#define EstopStatusBitNum 20
#define ErrorStatusBitNum 18
#define TasksRunningStatusBitNum 16
#define PauseStatusBitNum 16
#define TeachModeStatusBitNum 19
#define HomePositionStatusBitNum 5
#define Joint1StatusBitNum 11
#define Joint2StatusBitNum 10
#define Joint3StatusBitNum 9
#define Joint4StatusBitNum 8
#define SafeGuardBitNum 22

#define MotorOnStatusMask &H10
#define MotorPowerStatusMask &H40
#define EstopStatusMask &H100000
#define ErrorStatusMask &H40000
#define TasksRunningMask &H10000
#define PauseStatusMask &H20000
#define TeachModeStatusMask &H80000
#define HomePositionStatusMask &H20
#define Joint1StatusMask &H800
#define Joint2StatusMask &H400
#define Joint3StatusMask &H200
#define Joint4StatusMask &H100
#define SafeGuardMask &H400000


'Left and Right Spotface Measurements=> send to HMI
Global Real hole0R, hole0L, hole1R, hole1L, hole2R, hole2L, hole3R, hole3L, hole4R, hole4L
Global Real hole5R, hole5L, hole6R, hole6L, hole7R, hole7L, hole8R, hole8L, hole9R, hole9L
Global Real hole10R, hole10L, hole11R, hole11L, hole12R, hole12L, hole13R, hole13L, hole14R, hole14L
Global Real hole15R, hole15L, hole16R, hole16L, hole17R, hole17L, hole18R, hole18L, hole19R, hole19L
Global Real hole20R, hole20L, hole21R, hole21L, hole22R, hole22L, hole23L, hole23R

' Send HMI all the holes that passed or failed ,(True=Pass)
' When a hole fails the operator will know which hole failed.
Global Boolean hole0PF, hole1PF, hole2PF, hole3PF, hole4PF
Global Boolean hole5PF, hole6PF, hole7PF, hole8PF, hole9PF
Global Boolean hole10PF, hole11PF, hole12PF, hole13PF, hole14PF
Global Boolean hole15PF, hole16PF, hole17PF, hole18PF, hole19PF
Global Boolean hole20PF, hole21PF, hole22PF, hole23PF


Global Boolean abortJobBtnOld
Global Boolean abortjobOld
Global Boolean airPressHighOld
Global Boolean airPressLowOld
Global Boolean alarmMuteBtnOld
Global Boolean alarmMuteOld
Global Boolean alarmTogOld
Global Boolean backInterlockACKBtnOld
Global Boolean backInterlockACKOld
Global Boolean backIntlock1Old
Global Boolean backIntlock2Old
Global Boolean cbMonDebrisRmvOld
Global Boolean cbMonHeatStakeOld
Global Boolean cbMonInMagOld
Global Boolean cbMonOutMagOld
Global Boolean cbMonPAS24vdcOld
Global Boolean cbMonSafetyOld
Global Boolean dc24vOKOld
Global Boolean debrisMtrCCOld
Global Boolean debrisMtrOld
Global Boolean drillGoCCOld
Global Boolean drillGoOld
Global Boolean drillReturnCCOld
Global Boolean drillReturnOld
Global Boolean edgeDetectGoOld
Global Boolean edgeDetectHiOld
Global Boolean edgeDetectLoOld
Global Boolean flashHomeNCOld
Global Boolean erBackSafetyFrameOpenOld
Global Boolean erBadPressureSensorOld
Global Boolean erBowlFeederBreakerOld
Global Boolean erDCPowerHeatStakeOld
Global Boolean erDCPowerOld
Global Boolean erDebrisRemovalBreakerOld
Global Boolean erEstopOld
Global Boolean erFlashBreakerOld
Global Boolean erFlashStationOld
Global Boolean erFrontSafetyFrameOpenOld
Global Boolean erHeatStakeBreakerOld
Global Boolean erHeatStakeTempOld
Global Boolean erHighPressureOld
Global Boolean erHMICommunicationOld
Global Boolean erHmiDataAckOld
Global Boolean erIllegalArmMoveOld
Global Boolean erInMagBreakerOld
Global Boolean erInMagCrowdingOld
Global Boolean erInMagEmptyOld
Global Boolean erInMagLowSensorBadOld
Global Boolean erInMagOpenInterlockOld
Global Boolean erInMagUpSensorBadOld
Global Boolean erLaserScannerOld
Global Boolean erLeftSafetyFrameOpenOld
Global Boolean erLowPressureOld
Global Boolean erModbusCommandOld
Global Boolean erModbusPortOld
Global Boolean erModbusTimeoutOld
Global Boolean erOutMagBreakerOld
Global Boolean erOutMagCrowdingOld
Global Boolean erOutMagFullOld
Global Boolean erOutMagLowSensorBadOld
Global Boolean erOutMagOpenInterlockOld
Global Boolean erOutMagUpSensorBadOld
Global Boolean erPanelFailedInspectionOld
Global Boolean erPanelStatusUnknownOld
Global Boolean erPanelUndefinedOld
Global Boolean erParamEntryMissingOld
Global Boolean erPnumaticsBreakerOld
Global Boolean erRC180Old
Global Boolean erRecEntryMissingOld
Global Boolean erRightSafetyFrameOpenOld
Global Boolean erRobotNotAtHomeOld
Global Boolean errorStatusOld
Global Boolean erSafetySystemBreakerOld
Global Boolean erUnknownOld
Global Boolean erWrongPanelDimsOld
Global Boolean erWrongPanelHolesOld
Global Boolean erWrongPanelInsertOld
Global Boolean erWrongPanelOld
Global Boolean eStopResetCCOld
Global Boolean eStopResetOld
Global Boolean eStopStatusOld
Global Boolean FlashHomeCCOld
Global Boolean flashHomeNOOld
Global Boolean flashPanelPresntOld
Global Boolean FlashPnlPrsntOld
Global Boolean frontInterlockACKBtnOld
Global Boolean frontInterlockACKOld
Global Boolean frontIntlock1Old
Global Boolean frontIntlock2Old
Global Boolean GoFlagOld
Global Boolean heartBeatOld
Global Boolean heatStakeGoCCOld
Global Boolean heatStakeGoOld
Global Boolean hole0PFOld
Global Boolean hole10PFOld
Global Boolean hole11PFOld
Global Boolean hole12PFOld
Global Boolean hole13PFOld
Global Boolean hole14PFOld
Global Boolean hole15PFOld
Global Boolean hole16PFOld
Global Boolean hole17PFOld
Global Boolean hole18PFOld
Global Boolean hole19PFOld
Global Boolean hole1PFOld
Global Boolean hole20PFOld
Global Boolean hole21PFOld
Global Boolean hole22PFOld
Global Boolean hole23PFOld
Global Boolean hole2PFOld
Global Boolean hole3PFOld
Global Boolean hole4PFOld
Global Boolean hole5PFOld
Global Boolean hole6PFOld
Global Boolean hole7PFOld
Global Boolean hole8PFOld
Global Boolean hole9PFOld
Global Boolean holeDetectedOld
Global Boolean homePositionStatusOld
Global Boolean hsInstallInsrtOld
Global Boolean hsPanelPresntOld
Global Boolean inMagGoHomeBtnOld
Global Boolean inMagGoHomeOld
Global Boolean inMagInterlockOld
Global Boolean inMagIntLockAckBtnOld
Global Boolean inMagIntLockAckOld
Global Boolean inMagLoadedBtnOld
Global Boolean inMagLoadedOld
Global Boolean inMagLowLimNOld
Global Boolean inMagLowLimOld
Global Boolean inMagMtrCCOld
Global Boolean inMagMtrDirCCOld
Global Boolean inMagMtrDirOld
Global Boolean inMagMtrOld
Global Boolean InMagPickUpSignalOld
Global Boolean inMagPnlRdyOld
Global Boolean InMagRobotClearSignalOld
Global Boolean inMagUpLimNOld
Global Boolean inMagUpLimOld
Global Boolean jobAbortBtnOld
Global Boolean jobDoneOld
Global Boolean jobPauseBtnOld
Global Boolean jobPauseOld
Global Boolean jobResumeBtnOld
Global Boolean jobResumeOld
Global Boolean jobStartBtnOld
Global Boolean jobStartOld
Global Boolean jobStopBtnOld
Global Boolean jobStopOld
Global Boolean joint1StatusOld
Global Boolean joint2StatusOld
Global Boolean joint3StatusOld
Global Boolean joint4StatusOld
Global Boolean leftInterlockACKBtnOld
Global Boolean leftInterlockACKOld
Global Boolean leftIntlock1Old
Global Boolean leftIntlock2Old
Global Boolean maintModeOld
Global Boolean monEstop1Old
Global Boolean monEstop2Old
Global Boolean motorOnStatusOld
Global Boolean motorPowerStatusOld
Global Boolean OutMagDropOffSignalOld
Global Boolean outMagGoHomeBtnOld
Global Boolean outMagGoHomeOld
Global Boolean outMagIntLockAckBtnOld
Global Boolean outMagIntLockAckOld
Global Boolean outMagIntOld
Global Boolean outMagLowLimNOld
Global Boolean outMagLowLimOld
Global Boolean outMagMtrCCOld
Global Boolean outMagMtrDirCCOld
Global Boolean outMagMtrDirOld
Global Boolean outMagMtrOld
Global Boolean outMagPanelRdyOld
Global Boolean OutMagRobotClearSignalOld
Global Boolean outMagUnloadedBtnOld
Global Boolean outMagUnloadedOld
Global Boolean outMagUpLimNOld
Global Boolean outMagUpLimOld
Global Boolean OutputMagSignalOld
Global Boolean panelDataTxACKBtnOld
Global Boolean panelDataTxACKOld
Global Boolean panelDataTxRdyOld
Global Boolean PanelPassedInspectionOld
Global Boolean ParamEntryMissingOld
Global Boolean pauseFlagOld
Global Boolean pauseStatusOld
Global Boolean RecEntryMissingOld
Global Boolean recFlashRequiredOld
Global Boolean ReturnFlagOld
Global Boolean rightInterlockACKBtnOld
Global Boolean rightInterlockACKOld
Global Boolean rightIntlockOld
Global Boolean RobotPlacedPanelOld
Global Boolean safeGuardInputOld
Global Boolean sftyFrmIlockAckBtnOld
Global Boolean sftyFrmIlockAckOld
Global Boolean SkippedLastHoleOld
Global Boolean stackLightAlrmCCOld
Global Boolean stackLightAlrmOld
Global Boolean stackLightGrnCCOld
Global Boolean stackLightGrnOld
Global Boolean stackLightRedCCOld
Global Boolean stackLightRedOld
Global Boolean stackLightYelCCOld
Global Boolean stackLightYelOld
Global Boolean suctionCupsCCOld
Global Boolean suctionCupsOld
Global Boolean tasksRunningStatusOld
Global Boolean teachModeStatusOld
Global Double recPartNumberOld
Global Integer CrowdingOld
Global Integer ctrlrErrAxisNumberOld
Global Integer ctrlrErrorNumOld
Global Integer ctrlrLineNumberOld
Global Integer ctrlrTaskNumberOld
Global Integer currentFlashHoleOld
Global Integer currentHSHoleOld
Global Integer currentInspectHoleOld
Global Integer currentPreinspectHoleOld
Global Integer FirstHolePointFlashOld
Global Integer FirstHolePointHotStakeOld
Global Integer FirstHolePointInspectionOld
Global Integer inMagCurrentStateOld
Global Integer jobAbortOld
Global Integer jobNumPanelsDoneOld
Global Integer jobNumPanelsOld
Global Integer LastHolePointFlashOld
Global Integer LastHolePointHotStakeOld
Global Integer LastHolePointInspectionOld
Global Integer mainCurrentStateOld
Global Integer outMagCurrentStateOld
Global Integer OutmagLastStateOld
Global Integer recCrowdingOld
Global Integer recInmagOld
Global Integer recInsertTypeOld
Global Integer recNumberOfHolesOld
Global Integer recOutmagOld
Global Integer recPreCrowdingOld
Global Integer StatusCheckCrowdingOld
Global Integer StatusCheckDropOffOld
Global Integer StatusCheckFlashOld
Global Integer StatusCheckHotStakeOld
Global Integer StatusCheckInspectionOld
Global Integer StatusCheckPickUpOld
Global Integer StatusCheckPreinspectionOld
Global Integer SystemAccelOld
Global Integer SystemSpeedOld
Global Integer systemStatusOld
Global Integer xOld
Global Integer zOld
Global Real CurrentThetaHereOld
Global Real hole0LOld
Global Real hole0ROld
Global Real hole10LOld
Global Real hole10ROld
Global Real hole11LOld
Global Real hole11ROld
Global Real hole12LOld
Global Real hole12ROld
Global Real hole13LOld
Global Real hole13ROld
Global Real hole14LOld
Global Real hole14ROld
Global Real hole15LOld
Global Real hole15ROld
Global Real hole16LOld
Global Real hole16ROld
Global Real hole17LOld
Global Real hole17ROld
Global Real hole18LOld
Global Real hole18ROld
Global Real hole19LOld
Global Real hole19ROld
Global Real hole1LOld
Global Real hole1ROld
Global Real hole20LOld
Global Real hole20ROld
Global Real hole21LOld
Global Real hole21ROld
Global Real hole22LOld
Global Real hole22ROld
Global Real hole23LOld
Global Real hole23ROld
Global Real hole2LOld
Global Real hole2ROld
Global Real hole3LOld
Global Real hole3ROld
Global Real hole4LOld
Global Real hole4ROld
Global Real hole5LOld
Global Real hole5ROld
Global Real hole6LOld
Global Real hole6ROld
Global Real hole7LOld
Global Real hole7ROld
Global Real hole8LOld
Global Real hole8ROld
Global Real hole9LOld
Global Real hole9ROld
Global Real InMagTorqueLimOld
Global Real insertDepthToleranceOld
Global Real OutMagTorqueLimOld
Global Real recFlashDwellTimeOld
Global Real recInmagPickupOffsetOld
Global Real recInsertDepthOld
Global Real recOutmagPickupOffsetOld
Global Real recPanelThicknessOld
Global Real recTempProbeOld
Global Real recTempTrackOld
Global Real recSuctionWaitTimeOld
Global Real zLimitOld
Global Real ZmaxTorqueOld
Global String ctrlrErrMsgOld$

