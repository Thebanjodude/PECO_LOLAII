' System Global Vars and #defines
Global Integer SystemSpeed, SystemAccel, mainCurrentState
Global Real suctionWaitTime ' Time in seconds it takes for the EOAT to make a good suction on a panel
Global Boolean suctionCups, suctionCupsCC, holeDetected, maintMode
Global Integer systemStatus ' Integer that tells opperator what state the sytem is in-see State tab in IOT
Global Real zLimit ' the highest the EOAT can move without hitting periphials
#define ScanSpeed 35 ' Percent Speed the arm moves during the scanning process
Global Real PanelCordinates(22, 1)
#define Zaxis 3 ' The z axis is address by "3" (x,y,z,theta)
#define Preinspection 1
#define Postinspection 2
Global Real ZmaxTorque, ZavgTorque ' Monitors Z torque

'Global Integer NextState
Global Boolean monEstop1, monEstop2, jobAbortBtn, alarmMute, alarmTog, alarmMuteBtn
Global Boolean edgeDetectGo, edgeDetectHi, edgeDetectLo, pauseFlag
Global Boolean panelDataTxACKBtn, eStopReset, eStopResetCC
Global Boolean GoFlag, ReturnFlag 'flags to make sure we dont break the drill
Global Real PanelCordinatesQuill(22, 1)

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

'Inmag States
#define StateInMagUnknown 0
#define StatePartPresent 1
#define StatePartRemoved 2
#define StatePresentNextPart 3
#define StateLowering 4
#define StateWaitingUser 5
#define StateInMagPaused 6

#define PickupSuccessful 0
#define InmagIlockOpen 1
#define InmagError 2

Global Integer InmagLastState

'Outmag States
#define StateOutMagUnknown 0
#define StateReadyToReceive 1
#define StateOutMagPartPresent 2
#define StateOutMagLowering 3
#define StateOutMagWaitingUser 4
#define StateRaising 5
#define StateGoHome 6
#define StateOutMagPaused 7

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
Global Boolean SkipHoleArray(0, 0) ' This needs to be global
Global Integer currentInspectHole, currentPreinspectHole
#define RightSpotFace 0
#define LeftSpotFace 1

'System Monitor Vars
Global Boolean cbMonHeatStake, cbMonInMag, cbMonOutMag, cbMonDebrisRmv, cbMonSafety, cbMonPAS24vdc
Global Boolean stackLightRed, stackLightYel, stackLightGrn, stackLightAlrm
Global Boolean stackLightRedCC, stackLightYelCC, stackLightGrnCC, stackLightAlrmCC
Global Boolean airPressHigh, airPressLow
Global Boolean backIntlock1, frontIntlock1, leftIntlock1, rightIntlock
Global Boolean backIntlock2, frontIntlock2, leftIntlock2
Global Boolean heartBeat, dc24vOK

'Hot Stake and Flash Removal Global Vars
Global Real PanelArray(25, 2)
Global Real Theta, r, AnvilZlimit
Global Integer PanelArrayIndex
Global Boolean heatStakeGoCC, heatStakeGo
Global Boolean SkippedLastHole, hsInstallInsrt, flashPanelPresnt, hsPanelPresnt
Global Boolean drillGo, drillReturn, FlashPnlPrsnt, debrisMtr, FlashHomeCC, flashHomeNO, flashHomeNC
Global Boolean drillGoCC, drillReturnCC, debrisMtrCC, panelDataTxRdy, panelDataTxACK
Global Integer currentHSHole, currentFlashHole
Global Real flashDwellTime ' How long the flash tool is in contact with the insert
#define RadiusColumn 0 'The first column in the array are radii
#define ThetaColumn 1 'The second column in the array are thetas
#define SkipFlagColumn 2 'The third column in the array are flags for holes if we want to skip them

' Recipe Ingredients for Panels
#define InsertTypeUnknown 0
#define AluminumInsert 1
#define StainlessInsert 2
#define xCoord 0
#define YCoord 1
Global Integer recNumberOfHoles, recInsertType
Global Double recPartNumber
Global Boolean recFlashRequired
Global Real recInsertDepth, recPanelThickness
Global Real recTempProbe, recTempTrack
Global Integer FirstHolePointInspection, LastHolePointInspection
Global Integer FirstHolePointHotStake, LastHolePointHotStake
Global Integer FirstHolePointFlash, LastHolePointFlash

'Error Vars
Global Boolean erPanelFailedInspection, erFrontSafetyFrameOpen, erBackSafetyFrameOpen
Global Boolean erLeftSafetyFrameOpen, erRightSafetyFrameOpen, erLowPressure
Global Boolean erHighPressure, erPanelStatusUnknown, erWrongPanelHoles
Global Boolean erWrongPanelDims, erWrongPanel, erWrongPanelInsert, erHmiDataAck
Global Boolean erInMagEmpty, erInMagOpenInterlock, erOutMagCrowding
Global Boolean erInMagCrowding, erOutMagFull, erOutMagOpenInterlock, erBadPressureSensor
Global Boolean erLaserScanner, erDCPower, erDCPowerHeatStake, erHeatStakeTemp
Global Boolean erHeatStakeBreaker, erBowlFeederBreaker, erInMagBreaker
Global Boolean erOutMagBreaker, erFlashBreaker, erDebrisRemovalBreaker
Global Boolean erPnumaticsBreaker, erSafetySystemBreaker, erRC180, erIllegalArmMove
Global Boolean erUnknown, erEstop, erRecEntryMissing, erParamEntryMissing, erRobotNotAtHome
Global Boolean RecEntryMissing, ParamEntryMissing, erHMICommunication, erFlashStation
Global Boolean erInMagLowSensorBad, erInMagUpSensorBad, erOutMagLowSensorBad, erOutMagUpSensorBad


' Error Code array indexes, from IOT Excel MessageDB
'Since we rolled these into the IOT and turned them into Bools, these are OBS
#define UnknownError 0 ' An error occured but we are not sure what happened
#define EStopActive 1 ' The E-Stop is engaged
#define PanelFailed 2 ' A panel failed inspection
#define PickUpFailedPanel 3 ' We did not pick up a panel from the input mag
#define ControllerError 4 ' The EPSON RC 180 controller has generated an error
#define frontInterlockError 6 ' The Front interlock is open
#define backInterlockError 7 ' The Back interlock is open
#define LeftInterlockError 8 ' The Left interlock is open
#define RightInterlockError 9 ' The Right interlock is open
#define LowAirPressure 12 ' The system air pressure is too low, we might drop a panel
#define HighAirPressure 13 ' The system air pressure is too high we are risking breaking the robot
#define InMagInterlockOpen 23 'The Input Magazine's interlock is open
#define OutMagInterlockOpen 29 'The Output Magazine's interlock is open
#define OutMagTooTight 30 ' The Output Magazine crowding is too tight, opperator needs to loosen
#define InMagTooTight 24 ' The Input Magazine crowding is too tight, opperator needs to loosen
#define PanelStatusUnknown 15 ' The hotstake anvil or flash anvil did not detect a panel
#define InMagEmpty 22 ' Input Magazine is empty, opperator needs to fill it
#define OutMagFull 28 ' Output Magazine is full, opperator needs to empty it
#define LaserAlarmError 33 'The Laser scanner is not seeing the expected panel profile 
#define DCpwrHeatStakeError 35
#define HeatStakeCBTripped 36
#define InMagCBTripped 38
#define OutMagCBTripped 39
#define DebrisCBTripped 41
#define SafetySystemCBTripped 43

'State of Health Global Vars and defines
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

'Hole X,Y Coordinites, sent from HMI (center of panel is origin)
Global Real hole0Y, hole1X, hole1Y, hole2X, hole2Y, hole3X, hole3Y, hole4X, hole4Y
Global Real hole5X, hole5Y, hole6X, hole6Y, hole7X, hole7Y, hole8X, hole8Y, hole9X, hole9Y
Global Real hole10X, hole10Y, hole11X, hole11Y, hole12X, hole12Y, hole13X, hole13Y, hole14X, hole14Y
Global Real hole15X, hole15Y, hole16X, hole16Y, hole17X, hole17Y, hole18X, hole18Y, hole19X, hole19Y
Global Real hole20X, hole20Y, hole21X, hole21Y, hole22X, hole22Y

'Left and Right Spotface Measurements=> send to HMI
Global Real hole0L, hole0R, hole1R, hole1L, hole2R, hole2L, hole3R, hole3L, hole4R, hole4L
Global Real hole5R, hole5L, hole6R, hole6L, hole7R, hole7L, hole8R, hole8L, hole9R, hole9L
Global Real hole10R, hole10L, hole11R, hole11L, hole12R, hole12L, hole13R, hole13L, hole14R, hole14L
Global Real hole15R, hole15L, hole16R, hole16L, hole17R, hole17L, hole18R, hole18L, hole19R, hole19L
Global Real hole20R, hole20L, hole21R, hole21L, hole22R, hole22L

' Send HMI all the holes that passed or failed ,(True=Pass)
' When a hole fails the operator will know which hole failed.
Global Boolean hole0PF, hole1PF, hole2PF, hole3PF, hole4PF
Global Boolean hole5PF, hole6PF, hole7PF, hole8PF, hole9PF
Global Boolean hole10PF, hole11PF, hole12PF, hole13PF, hole14PF
Global Boolean hole15PF, hole16PF, hole17PF, hole18PF, hole19PF
Global Boolean hole20PF, hole21PF, hole22PF

'Heat Stake vars
Global Boolean pasAlarmGroup
Global Boolean pasRemoteAlarmAcknowledge, pasRemoteAlarmAcknowledgeBtn
Global Boolean pasHighTempAlarm
Global Boolean pasInsertType
Global Boolean pasGoHome, pasGoHomeBtn
Global Boolean pasInsertDetected
Global Boolean pasSteelInsert
Global Boolean pasShuttleLoadPosition
Global Boolean pasShuttleNoLoad
Global Boolean pasShuttleExtend
Global Boolean pasInsertInShuttle
Global Boolean pasShuttleMidway
Global Boolean pasHeadDown, pasHeadDownBtn
Global Boolean pasHeadUp, pasHeadUpBtn
Global Boolean pasResetMax, pasResetMaxBtn
Global Boolean pasResetHighTemp, pasResetHighTempBtn
Global Boolean pasTempOnOff, pasTempOnOffBtn
Global Boolean pasMasterTemp, pasMasterTempBtn
Global Boolean pasUpLimit, pasUpLimitBtn
Global Boolean pasLowerlimit, pasLowerlimitBtn
Global Boolean pasHome, pasHomeBtn
Global Boolean pasMCREStop, pasMCREStopBtn
Global Boolean pasStart, pasStartBtn
Global Boolean pasHeadinsertPickupRetract
Global Boolean pasHeadinsertpickupextend
Global Boolean pasSlideExtend, pasSlideExtendBtn
Global Boolean pas1inLoadInsertCylinder
Global Boolean pasBowlDumpOpen, pasBowlDumpOpenBtn
Global Boolean pasBlowInsert, pasBlowInsertBtn
Global Boolean pasVibTrack, pasVibTrackBtn
Global Boolean pasBowlFeeder, pasBowlFeederBtn
Global Boolean pasInsertGripper, pasInsertGripperBtn
Global Boolean pasOTAOnOffZone1, pasOTAOnOffZone1Btn
Global Boolean pasOTAOnOffZone2, pasOTAOnOffZone2Btn
Global Boolean pasOTAOnOffZone3, pasOTAOnOffZone3Btn
Global Boolean pasOTAOnOffZone4, pasOTAOnOffZone4Btn
Global Boolean pasOnOffZone1, pasOnOffZone1Btn
Global Boolean pasOnOffZone2, pasOnOffZone2Btn
Global Boolean pasOnOffZone3, pasOnOffZone3Btn
Global Boolean pasOnOffZone4, pasOnOffZone4Btn
Global Boolean pasMaxTempOnOffZone1, pasMaxTempOnOffZone1Btn
Global Boolean pasMaxTempOnOffZone2, pasMaxTempOnOffZone2Btn
Global Boolean pasMaxTempOnOffZone3, pasMaxTempOnOffZone3Btn
Global Boolean pasMaxTempOnOffZone4, pasMaxTempOnOffZone4Btn
Global Boolean pasInTempZone1
Global Boolean pasInTempZone2
Global Boolean pasInTempZone3
Global Boolean pasInTempZone4
Global Boolean pasMaxTempZone1
Global Boolean pasMaxTempZone2
Global Boolean pasMaxTempZone3
Global Boolean pasMaxTempZone4
Global Boolean pasStartPIDTuneZone1, pasStartPIDTuneZone1Btn
Global Boolean pasStartPIDTuneZone2, pasStartPIDTuneZone2Btn
Global Boolean pasStartPIDTuneZone4, pasStartPIDTuneZone4Btn
Global Boolean pasPIDTuneDoneZone1, pasPIDTuneDoneZone1Btn
Global Boolean pasPIDTuneDoneZone2, pasPIDTuneDoneZone2Btn
Global Boolean pasPIDTuneDoneZone3, pasPIDTuneDoneZone3Btn
Global Boolean pasPIDTuneFailZone1, pasPIDTuneFailZone1Btn
Global Boolean pasPIDTuneFailZone2, pasPIDTuneFailZone2Btn
Global Boolean pasPIDTuneFailZone3, pasPIDTuneFailZone3Btn
Global Long pasMessageDB
Global Long pasSoftHome
Global Long pasInsertPosition
Global Long pasInsertDepth
Global Long pasSoftStop
Global Long pasHomeIPM
Global Long pasInsertPickupIPM
Global Long pasHeatStakingIPM
Global Long pasInsertEngageIPM
Global Long pasInsertEngage
Global Long pasSetTempZone1
Global Long pasVerticalLocation
Global Integer pasPIDsetupSetPointZone1
Global Integer pasSetTempZone2
Global Integer pasPIDsetupSetPointZone2
Global Integer pasPIDsetupSetPointZone3
Global Integer pasPIDsetupSetPointZone4
Global Integer pasActualTempZone1
Global Integer pasPIDsetupActualZone1
Global Integer pasActualTempZone2
Global Integer pasPIDsetupActualZone2
Global Integer pasPIDsetupActualZone3
Global Integer pasPIDsetupActualZone4
Global Integer pasPIDsetupMaxTempZone1
Global Integer pasPIDsetupMaxTempZone2
Global Integer pasPIDsetupMaxTempZone3
Global Integer pasPIDsetupMaxTempZone4
Global Integer pasPIDsetupInTempZone1
Global Integer pasPIDsetupInTempZone2
Global Integer pasPIDsetupInTempZone3
Global Integer pasPIDsetupInTempZone4
Global Integer pasPIDsetupOffsetZone1
Global Integer pasPIDsetupOffsetZone2
Global Integer pasPIDsetupOffsetZone3
Global Integer pasPIDsetupOffsetZone4
Global Integer pasPIDsetupPZone1
Global Integer pasPIDShowPZone1
Global Integer pasPIDsetupIZone1
Global Integer pasPIDShowPZone2
Global Integer pasPIDsetupDZone1
Global Integer pasPIDShowIZone1
Global Integer pasPIDShowIZone2
Global Integer pasPIDShowDZone1
Global Integer pasPIDShowDZone2
Global Integer pasPIDsetupPZone2
Global Integer pasPIDsetupIZone2
Global Integer pasPIDsetupDZone2
Global Integer pasPIDsetupPZone3
Global Integer pasPIDsetupIZone3
Global Integer pasPIDsetupDZone3
Global Integer pasPIDsetupPZone4
Global Integer pasPIDsetupIZone4
Global Integer pasPIDsetupDZone4
Global Integer pasInsertPreheat
Global Integer pasDwell
Global Integer pasCool
Global Integer pasRecipe
Global Integer pasJogSpeed
Global Integer pasMaxLoadmeter
Global Integer pasLoadMeter
Global Integer pasPreHeatActual
Global Integer pasDwellActual
Global Integer pasCoolActual
Global Boolean pas1inLoadInsertCylinderBtn, pasInsertTypeBtn

'defines for hs
#define pasAlarmGroupAddr &h0032
#define pasRemoteAlarmAcknowledgeAddr &h0034
#define pasHighTempAlarmAddr &h0402
#define pasInsertTypeAddr &h0230
#define pasGoHomeAddr &h0001
#define pasInsertDetectedAddr &h0384
#define pasSteelInsertAddr &h0385
#define pasShuttleLoadPositionAddr &h0388
#define pasShuttleNoLoadAddr &h0389
#define pasShuttleExtendAddr &h038A
#define pasInsertInShuttleAddr &h038B
#define pasShuttleMidwayAddr &h0386
#define pasHeadDownAddr &h0014
#define pasHeadUpAddr &h0015
#define pasResetMaxAddr &h0069
#define pasResetHighTempAddr &h03F9
#define pasTempOnOffAddr &h000D
#define pasMasterTempAddr &h0401
#define pasUpLimitAddr &h0055
#define pasLowerlimitAddr &h0056
#define pasHomeAddr &h0057
#define pasMCREStopAddr &h3400
#define pasStartAddr &h3401
#define pasHeadinsertPickupRetractAddr &h3406
#define pasHeadinsertpickupextendAddr &h3407
#define pasSlideExtendAddr &h0017
#define pas1inLoadInsertCylinderAddr &h0019
#define pasBowlDumpOpenAddr &h001B
#define pasBlowInsertAddr &h001E
#define pasVibTrackAddr &h001C
#define pasBowlFeederAddr &h001D
#define pasInsertGripperAddr &h0018
#define pasOTAOnOffZone1Addr &h0403
#define pasOTAOnOffZone2Addr &h0404
#define pasOTAOnOffZone3Addr &h0405
#define pasOTAOnOffZone4Addr &h0406
#define pasOnOffZone1Addr &h012C
#define pasOnOffZone2Addr &h012D
#define pasOnOffZone3Addr &h012E
#define pasOnOffZone4Addr &h012F
#define pasMaxTempOnOffZone1Addr &h040D
#define pasMaxTempOnOffZone2Addr &h040E
#define pasMaxTempOnOffZone3Addr &h040F
#define pasMaxTempOnOffZone4Addr &h0410
#define pasInTempZone1Addr &h
#define pasInTempZone2Addr &h
#define pasInTempZone3Addr &h
#define pasInTempZone4Addr &h
#define pasMaxTempZone1Addr &h0028
#define pasMaxTempZone2Addr &h0029
#define pasMaxTempZone3Addr &h002A
#define pasMaxTempZone4Addr &h002B
#define pasStartPIDTuneZone1Addr &h0132
#define pasStartPIDTuneZone2Addr &h0133
#define pasStartPIDTuneZone4Addr &h0135
#define pasPIDTuneDoneZone1Addr &h0138
#define pasPIDTuneDoneZone2Addr &h0139
#define pasPIDTuneDoneZone3Addr &h013B
#define pasPIDTuneFailZone1Addr &h
#define pasPIDTuneFailZone2Addr &h
#define pasPIDTuneFailZone3Addr &h


' modbus constants	
#define MBMitsubishiAddress 4
#define MBCmdReadCoil 1
#define MBCmdReadInput 2
#define MBCmdReadRegister 3
#define MBCmdWriteCoil 5
#define MBCmdWriteRegister 6
#define MBTypeCoil 1
#define MBType16 2
#define MBType32 3
#define MBWriteQueueSize 30






