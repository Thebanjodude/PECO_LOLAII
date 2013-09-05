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
Global Boolean heartBeat, dc24vOK, pasEmptyBowlFeederandTrack, pasEmptyBowlFeederandTrackBTN

'Hot Stake and Flash Removal Global Vars
Global Boolean heatStakeGoCC, heatStakeGo
Global Boolean SkippedLastHole, hsInstallInsrt, flashPanelPresnt, hsPanelPresnt
Global Boolean drillGo, drillReturn, FlashPnlPrsnt, debrisMtr, FlashHomeCC, flashHomeNO, flashHomeNC
Global Boolean drillGoCC, drillReturnCC, debrisMtrCC, panelDataTxRdy, panelDataTxACK
Global Integer currentHSHole, currentFlashHole
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
Global Boolean recFlashRequired
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

'Heat Stake vars
Global Boolean pasCrowding
Global Boolean pasAlarmGroup
Global Boolean pasRemoteAlarmAcknowledge, pasRemoteAlarmAcknowledgeBtn
Global Boolean pasHighTempAlarm
Global Boolean pasInsertType, pasEmptyingSequenceDone
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
Global Integer pasMessageDB
Global Real pasSoftHome
Global Real pasInsertPosition
Global Real pasInsertDepth
Global Real pasSoftStop
Global Real pasHomeIPM
Global Real pasInsertPickupIPM
Global Real pasHeatStakingIPM
Global Real pasInsertEngageIPM
Global Real pasInsertEngage
Global Real pasSetTempZone1
Global Real pasVerticalLocation
Global Long pasPIDsetupSetPointZone1
Global Long pasSetTempZone2
Global Long pasPIDsetupSetPointZone2
Global Long pasPIDsetupSetPointZone3
Global Long pasPIDsetupSetPointZone4
Global Long pasActualTempZone1
Global Long pasPIDsetupActualZone1
Global Long pasActualTempZone2
Global Long pasPIDsetupActualZone2
Global Long pasPIDsetupActualZone3
Global Long pasPIDsetupActualZone4
Global Long pasPIDsetupMaxTempZone1
Global Long pasPIDsetupMaxTempZone2
Global Long pasPIDsetupMaxTempZone3
Global Long pasPIDsetupMaxTempZone4
Global Long pasPIDsetupInTempZone1
Global Long pasPIDsetupInTempZone2
Global Long pasPIDsetupInTempZone3
Global Long pasPIDsetupInTempZone4
Global Long pasPIDsetupOffsetZone1
Global Long pasPIDsetupOffsetZone2
Global Long pasPIDsetupOffsetZone3
Global Long pasPIDsetupOffsetZone4
Global Long pasPIDsetupPZone1
Global Long pasPIDShowPZone1
Global Long pasPIDsetupIZone1
Global Long pasPIDShowPZone2
Global Long pasPIDsetupDZone1
Global Long pasPIDShowIZone1
Global Long pasPIDShowIZone2
Global Long pasPIDShowDZone1
Global Long pasPIDShowDZone2
Global Long pasPIDsetupPZone2
Global Long pasPIDsetupIZone2
Global Long pasPIDsetupDZone2
Global Long pasPIDsetupPZone3
Global Long pasPIDsetupIZone3
Global Long pasPIDsetupDZone3
Global Long pasPIDsetupPZone4
Global Long pasPIDsetupIZone4
Global Long pasPIDsetupDZone4
Global Long pasInsertPreheat
Global Long pasDwell
Global Long pasCool
Global Long pasRecipe
Global Long pasJogSpeed
Global Long pasMaxLoadmeter
Global Long pasLoadMeter
Global Long pasPreHeatActual
Global Long pasDwellActual
Global Long pasCoolActual
Global Boolean pas1inLoadInsertCylinderBtn, pasInsertTypeBtn
Global Long pasMessageDBSet
Global Real pasSoftHomeSet
Global Real pasInsertPositionSet
Global Real pasInsertDepthSet
Global Real pasSoftStopSet
Global Real pasHomeIPMSet
Global Real pasInsertPickupIPMSet
Global Real pasHeatStakingIPMSet
Global Real pasInsertEngageIPMSet
Global Real pasInsertEngageSet
Global Real pasSetTempZone1Set
Global Real pasVerticalLocationSet
Global Long pasPIDsetupSetPointZone1Set
Global Long pasSetTempZone2Set
Global Long pasPIDsetupSetPointZone2Set
Global Long pasPIDsetupSetPointZone3Set
Global Long pasPIDsetupSetPointZone4Set
Global Long pasActualTempZone1Set
Global Long pasPIDsetupActualZone1Set
Global Long pasActualTempZone2Set
Global Long pasPIDsetupActualZone2Set
Global Long pasPIDsetupActualZone3Set
Global Long pasPIDsetupActualZone4Set
Global Long pasPIDsetupMaxTempZone1Set
Global Long pasPIDsetupMaxTempZone2Set
Global Long pasPIDsetupMaxTempZone3Set
Global Long pasPIDsetupMaxTempZone4Set
Global Long pasPIDsetupInTempZone1Set
Global Long pasPIDsetupInTempZone2Set
Global Long pasPIDsetupInTempZone3Set
Global Long pasPIDsetupInTempZone4Set
Global Long pasPIDsetupOffsetZone1Set
Global Long pasPIDsetupOffsetZone2Set
Global Long pasPIDsetupOffsetZone3Set
Global Long pasPIDsetupOffsetZone4Set
Global Long pasPIDsetupPZone1Set
Global Long pasPIDShowPZone1Set
Global Long pasPIDsetupIZone1Set
Global Long pasPIDShowPZone2Set
Global Long pasPIDsetupDZone1Set
Global Long pasPIDShowIZone1Set
Global Long pasPIDShowIZone2Set
Global Long pasPIDShowDZone1Set
Global Long pasPIDShowDZone2Set
Global Long pasPIDsetupPZone2Set
Global Long pasPIDsetupIZone2Set
Global Long pasPIDsetupDZone2Set
Global Long pasPIDsetupPZone3Set
Global Long pasPIDsetupIZone3Set
Global Long pasPIDsetupDZone3Set
Global Long pasPIDsetupPZone4Set
Global Long pasPIDsetupIZone4Set
Global Long pasPIDsetupDZone4Set
Global Long pasInsertPreheatSet
Global Long pasDwellSet
Global Long pasCoolSet
Global Long pasRecipeSet
Global Long pasJogSpeedSet
Global Long pasMaxLoadmeterSet
Global Long pasLoadMeterSet
Global Long pasPreHeatActualSet
Global Long pasDwellActualSet
Global Long pasCoolActualSet

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
#define pasPIDsetupOffsetZone2Addr &h015B
#define pasPIDsetupIZone1Addr &h0165
#define pasPIDsetupMaxTempZone1Addr &h0138
#define pasPIDsetupMaxTempZone2Addr &h0139
#define pasPIDsetupIZone2Addr &h016F
#define pasPIDsetupOffsetZone1Addr &h015A
#define pasPIDsetupPZone1Addr &h0164

#define pasSoftStopADDR &h0104
#define pasVerticalLocationADDR &h0002
#define pasInsertDepthADDR &h0102
#define pasHeatStakingIPMADDR &h010A
#define pasDwellADDR &h0191
#define pasCoolADDR &h0192
#define pasInsertEngageADDR &h0118
#define pasInsertEngageIPMADDR &h010E
#define pasInsertPreheatADDR &h0190
#define pasSoftHomeADDR &h00FE
#define pasHomeIPMADDR &h0106
#define pasInsertPositionADDR &h0100
#define pasInsertPickupIPMADDR &h0108
#define pasRecipeADDR &h01C2
#define pasMessageDBADDR &h0009
#define pasLoadMeterADDR &h028B
#define pasMaxLoadmeterADDR &h0265
#define pasJogSpeedADDR &h01FE
#define pasActualTempZone1ADDR &h0132
#define pasSetTempZone1ADDR &h012C
#define pasActualTempZone2ADDR &h0133
#define pasSetTempZone2ADDR &h012D
#define pasPreHeatActualADDR &hA147
#define pasDwellActualADDR &hA148
#define pasCoolActualADDR &hA149
#define pasPIDsetupPZone2ADDR &h016E
#define pasPIDsetupPZone3ADDR &h0178
#define pasPIDsetupPZone4ADDR &h0182
#define pasPIDsetupIZone3ADDR &h0179
#define pasPIDsetupIZone4ADDR &h0183
#define pasPIDsetupDZone1ADDR &h0166
#define pasPIDsetupDZone2ADDR &h0170
#define pasPIDsetupDZone3ADDR &h017A
#define pasPIDsetupDZone4ADDR &h0184
#define pasPIDShowPZone1ADDR &h0164
#define pasPIDShowPZone2ADDR &h0165
#define pasPIDShowIZone1ADDR &h0168
#define pasPIDShowIZone2ADDR &h0169
#define pasPIDShowDZone1ADDR &h016C
#define pasPIDShowDZone2ADDR &h016D
#define pasPIDsetupActualZone1ADDR &h0132
#define pasPIDsetupActualZone2ADDR &h0133
#define pasPIDsetupActualZone3ADDR &h0134
#define pasPIDsetupActualZone4ADDR &h0135
#define pasPIDsetupSetPointZone1ADDR &h012C
#define pasPIDsetupSetPointZone2ADDR &h012D
#define pasPIDsetupSetPointZone3ADDR &h012E
#define pasPIDsetupSetPointZone4ADDR &h012F
#define pasPIDsetupInTempZone1ADDR &h0149
#define pasPIDsetupInTempZone2ADDR &h014A
#define pasPIDsetupInTempZone3ADDR &h014B
#define pasPIDsetupInTempZone4ADDR &h014C
#define pasPIDsetupMaxTempZone3ADDR &h013A
#define pasPIDsetupMaxTempZone4ADDR &h013B
#define pasPIDsetupOffsetZone3ADDR &h015C
#define pasPIDsetupOffsetZone4ADDR &h015D
#define pasCrowdingADDR &h03A5
'#define pasEmptyBowlFeederandTrackADDR &hXXXX

' modbus constants	
#define MBMitsubishiAddress 4
#define MBCmdReadCoil 1
#define MBCmdReadInput 2
#define MBCmdReadRegister 3
#define MBCmdReadInputRegister 4
#define MBCmdWriteCoil 5
#define MBCmdWriteRegister 6
#define MBTypeCoil 1
#define MBType16 2
#define MBType32 3
#define MBWriteQueueSize 30

'	Global Preserve Boolean abortJobBtnOld
'	Global Preserve Boolean abortjobOld
'	Global Preserve Boolean airPressHighOld
'	Global Preserve Boolean airPressLowOld
'	Global Preserve Boolean alarmMuteBtnOld
'	Global Preserve Boolean alarmMuteOld
'	Global Preserve Boolean alarmTogOld
'	Global Preserve Boolean backInterlockACKBtnOld
'	Global Preserve Boolean backInterlockACKOld
'	Global Preserve Boolean backIntlock1Old
'	Global Preserve Boolean backIntlock2Old
'	Global Preserve Boolean cbMonDebrisRmvOld
'	Global Preserve Boolean cbMonHeatStakeOld
'	Global Preserve Boolean cbMonInMagOld
'	Global Preserve Boolean cbMonOutMagOld
'	Global Preserve Boolean cbMonPAS24vdcOld
'	Global Preserve Boolean cbMonSafetyOld
'	Global Preserve Boolean dc24vOKOld
'	Global Preserve Boolean debrisMtrCCOld
'	Global Preserve Boolean debrisMtrOld
'	Global Preserve Boolean drillGoCCOld
'	Global Preserve Boolean drillGoOld
'	Global Preserve Boolean drillReturnCCOld
'	Global Preserve Boolean drillReturnOld
'	Global Preserve Boolean edgeDetectGoOld
'	Global Preserve Boolean edgeDetectHiOld
'	Global Preserve Boolean edgeDetectLoOld
'	Global Preserve Boolean flashHomeNCOld
'	Global Preserve Boolean erBackSafetyFrameOpenOld
'	Global Preserve Boolean erBadPressureSensorOld
'	Global Preserve Boolean erBowlFeederBreakerOld
'	Global Preserve Boolean erDCPowerHeatStakeOld
'	Global Preserve Boolean erDCPowerOld
'	Global Preserve Boolean erDebrisRemovalBreakerOld
'	Global Preserve Boolean erEstopOld
'	Global Preserve Boolean erFlashBreakerOld
'	Global Preserve Boolean erFlashStationOld
'	Global Preserve Boolean erFrontSafetyFrameOpenOld
'	Global Preserve Boolean erHeatStakeBreakerOld
'	Global Preserve Boolean erHeatStakeTempOld
'	Global Preserve Boolean erHighPressureOld
'	Global Preserve Boolean erHMICommunicationOld
'	Global Preserve Boolean erHmiDataAckOld
'	Global Preserve Boolean erIllegalArmMoveOld
'	Global Preserve Boolean erInMagBreakerOld
'	Global Preserve Boolean erInMagCrowdingOld
'	Global Preserve Boolean erInMagEmptyOld
'	Global Preserve Boolean erInMagLowSensorBadOld
'	Global Preserve Boolean erInMagOpenInterlockOld
'	Global Preserve Boolean erInMagUpSensorBadOld
'	Global Preserve Boolean erLaserScannerOld
'	Global Preserve Boolean erLeftSafetyFrameOpenOld
'	Global Preserve Boolean erLowPressureOld
'	Global Preserve Boolean erModbusCommandOld
'	Global Preserve Boolean erModbusPortOld
'	Global Preserve Boolean erModbusTimeoutOld
'	Global Preserve Boolean erOutMagBreakerOld
'	Global Preserve Boolean erOutMagCrowdingOld
'	Global Preserve Boolean erOutMagFullOld
'	Global Preserve Boolean erOutMagLowSensorBadOld
'	Global Preserve Boolean erOutMagOpenInterlockOld
'	Global Preserve Boolean erOutMagUpSensorBadOld
'	Global Preserve Boolean erPanelFailedInspectionOld
'	Global Preserve Boolean erPanelStatusUnknownOld
'	Global Preserve Boolean erPanelUndefinedOld
'	Global Preserve Boolean erParamEntryMissingOld
'	Global Preserve Boolean erPnumaticsBreakerOld
'	Global Preserve Boolean erRC180Old
'	Global Preserve Boolean erRecEntryMissingOld
'	Global Preserve Boolean erRightSafetyFrameOpenOld
'	Global Preserve Boolean erRobotNotAtHomeOld
'	Global Preserve Boolean errorStatusOld
'	Global Preserve Boolean erSafetySystemBreakerOld
'	Global Preserve Boolean erUnknownOld
'	Global Preserve Boolean erWrongPanelDimsOld
'	Global Preserve Boolean erWrongPanelHolesOld
'	Global Preserve Boolean erWrongPanelInsertOld
'	Global Preserve Boolean erWrongPanelOld
'	Global Preserve Boolean eStopResetCCOld
'	Global Preserve Boolean eStopResetOld
'	Global Preserve Boolean eStopStatusOld
'	Global Preserve Boolean FlashHomeCCOld
'	Global Preserve Boolean flashHomeNOOld
'	Global Preserve Boolean flashPanelPresntOld
'	Global Preserve Boolean FlashPnlPrsntOld
'	Global Preserve Boolean frontInterlockACKBtnOld
'	Global Preserve Boolean frontInterlockACKOld
'	Global Preserve Boolean frontIntlock1Old
'	Global Preserve Boolean frontIntlock2Old
'	Global Preserve Boolean GoFlagOld
'	Global Preserve Boolean heartBeatOld
'	Global Preserve Boolean heatStakeGoCCOld
'	Global Preserve Boolean heatStakeGoOld
'	Global Preserve Boolean hole0PFOld
'	Global Preserve Boolean hole10PFOld
'	Global Preserve Boolean hole11PFOld
'	Global Preserve Boolean hole12PFOld
'	Global Preserve Boolean hole13PFOld
'	Global Preserve Boolean hole14PFOld
'	Global Preserve Boolean hole15PFOld
'	Global Preserve Boolean hole16PFOld
'	Global Preserve Boolean hole17PFOld
'	Global Preserve Boolean hole18PFOld
'	Global Preserve Boolean hole19PFOld
'	Global Preserve Boolean hole1PFOld
'	Global Preserve Boolean hole20PFOld
'	Global Preserve Boolean hole21PFOld
'	Global Preserve Boolean hole22PFOld
'	Global Preserve Boolean hole2PFOld
'	Global Preserve Boolean hole3PFOld
'	Global Preserve Boolean hole4PFOld
'	Global Preserve Boolean hole5PFOld
'	Global Preserve Boolean hole6PFOld
'	Global Preserve Boolean hole7PFOld
'	Global Preserve Boolean hole8PFOld
'	Global Preserve Boolean hole9PFOld
'	Global Preserve Boolean holeDetectedOld
'	Global Preserve Boolean homePositionStatusOld
'	Global Preserve Boolean hsInstallInsrtOld
'	Global Preserve Boolean hsPanelPresntOld
'	Global Preserve Boolean inMagGoHomeBtnOld
'	Global Preserve Boolean inMagGoHomeOld
'	Global Preserve Boolean inMagInterlockOld
'	Global Preserve Boolean inMagIntLockAckBtnOld
'	Global Preserve Boolean inMagIntLockAckOld
'	Global Preserve Boolean inMagLoadedBtnOld
'	Global Preserve Boolean inMagLoadedOld
'	Global Preserve Boolean inMagLowLimNOld
'	Global Preserve Boolean inMagLowLimOld
'	Global Preserve Boolean inMagMtrCCOld
'	Global Preserve Boolean inMagMtrDirCCOld
'	Global Preserve Boolean inMagMtrDirOld
'	Global Preserve Boolean inMagMtrOld
'	Global Preserve Boolean InMagPickUpSignalOld
'	Global Preserve Boolean inMagPnlRdyOld
'	Global Preserve Boolean InMagRobotClearSignalOld
'	Global Preserve Boolean inMagUpLimNOld
'	Global Preserve Boolean inMagUpLimOld
'	Global Preserve Boolean jobAbortBtnOld
'	Global Preserve Boolean jobDoneOld
'	Global Preserve Boolean jobPauseBtnOld
'	Global Preserve Boolean jobPauseOld
'	Global Preserve Boolean jobResumeBtnOld
'	Global Preserve Boolean jobResumeOld
'	Global Preserve Boolean jobStartBtnOld
'	Global Preserve Boolean jobStartOld
'	Global Preserve Boolean jobStopBtnOld
'	Global Preserve Boolean jobStopOld
'	Global Preserve Boolean joint1StatusOld
'	Global Preserve Boolean joint2StatusOld
'	Global Preserve Boolean joint3StatusOld
'	Global Preserve Boolean joint4StatusOld
'	Global Preserve Boolean leftInterlockACKBtnOld
'	Global Preserve Boolean leftInterlockACKOld
'	Global Preserve Boolean leftIntlock1Old
'	Global Preserve Boolean leftIntlock2Old
'	Global Preserve Boolean maintModeOld
'	Global Preserve Boolean monEstop1Old
'	Global Preserve Boolean monEstop2Old
'	Global Preserve Boolean motorOnStatusOld
'	Global Preserve Boolean motorPowerStatusOld
'	Global Preserve Boolean OutMagDropOffSignalOld
'	Global Preserve Boolean outMagGoHomeBtnOld
'	Global Preserve Boolean outMagGoHomeOld
'	Global Preserve Boolean outMagIntLockAckBtnOld
'	Global Preserve Boolean outMagIntLockAckOld
'	Global Preserve Boolean outMagIntOld
'	Global Preserve Boolean outMagLowLimNOld
'	Global Preserve Boolean outMagLowLimOld
'	Global Preserve Boolean outMagMtrCCOld
'	Global Preserve Boolean outMagMtrDirCCOld
'	Global Preserve Boolean outMagMtrDirOld
'	Global Preserve Boolean outMagMtrOld
'	Global Preserve Boolean outMagPanelRdyOld
'	Global Preserve Boolean OutMagRobotClearSignalOld
'	Global Preserve Boolean outMagUnloadedBtnOld
'	Global Preserve Boolean outMagUnloadedOld
'	Global Preserve Boolean outMagUpLimNOld
'	Global Preserve Boolean outMagUpLimOld
'	Global Preserve Boolean OutputMagSignalOld
'	Global Preserve Boolean panelDataTxACKBtnOld
'	Global Preserve Boolean panelDataTxACKOld
'	Global Preserve Boolean panelDataTxRdyOld
'	Global Preserve Boolean PanelPassedInspectionOld
'	Global Preserve Boolean ParamEntryMissingOld
'	Global Preserve Boolean pas1inLoadInsertCylinderBtnOld
'	Global Preserve Boolean pas1inLoadInsertCylinderOld
'	Global Preserve Boolean pasAlarmGroupOld
'	Global Preserve Boolean pasBlowInsertBtnOld
'	Global Preserve Boolean pasBlowInsertOld
'	Global Preserve Boolean pasBowlDumpOpenBtnOld
'	Global Preserve Boolean pasBowlDumpOpenOld
'	Global Preserve Boolean pasBowlFeederBtnOld
'	Global Preserve Boolean pasBowlFeederOld
'	Global Preserve Boolean pasGoHomeBtnOld
'	Global Preserve Boolean pasGoHomeOld
'	Global Preserve Boolean pasHeadDownBtnOld
'	Global Preserve Boolean pasHeadDownOld
'	Global Preserve Boolean pasHeadinsertpickupextendOld
'	Global Preserve Boolean pasHeadinsertPickupRetractOld
'	Global Preserve Boolean pasHeadUpBtnOld
'	Global Preserve Boolean pasHeadUpOld
'	Global Preserve Boolean pasHighTempAlarmOld
'	Global Preserve Boolean pasHomeBtnOld
'	Global Preserve Boolean pasHomeOld
'	Global Preserve Boolean pasInsertDetectedOld
'	Global Preserve Boolean pasInsertGripperBtnOld
'	Global Preserve Boolean pasInsertGripperOld
'	Global Preserve Boolean pasInsertInShuttleOld
'	Global Preserve Boolean pasInsertTypeBtnOld
'	Global Preserve Boolean pasInsertTypeOld
'	Global Preserve Boolean pasInTempZone1Old
'	Global Preserve Boolean pasInTempZone2Old
'	Global Preserve Boolean pasInTempZone3Old
'	Global Preserve Boolean pasInTempZone4Old
'	Global Preserve Boolean pasLowerlimitBtnOld
'	Global Preserve Boolean pasLowerlimitOld
'	Global Preserve Boolean pasMasterTempBtnOld
'	Global Preserve Boolean pasMasterTempOld
'	Global Preserve Boolean pasMaxTempOnOffZone1BtnOld
'	Global Preserve Boolean pasMaxTempOnOffZone1Old
'	Global Preserve Boolean pasMaxTempOnOffZone2BtnOld
'	Global Preserve Boolean pasMaxTempOnOffZone2Old
'	Global Preserve Boolean pasMaxTempOnOffZone3BtnOld
'	Global Preserve Boolean pasMaxTempOnOffZone3Old
'	Global Preserve Boolean pasMaxTempOnOffZone4BtnOld
'	Global Preserve Boolean pasMaxTempOnOffZone4Old
'	Global Preserve Boolean pasMaxTempZone1Old
'	Global Preserve Boolean pasMaxTempZone2Old
'	Global Preserve Boolean pasMaxTempZone3Old
'	Global Preserve Boolean pasMaxTempZone4Old
'	Global Preserve Boolean pasMCREStopBtnOld
'	Global Preserve Boolean pasMCREStopOld
'	Global Preserve Boolean pasOnOffZone1BtnOld
'	Global Preserve Boolean pasOnOffZone1Old
'	Global Preserve Boolean pasOnOffZone2BtnOld
'	Global Preserve Boolean pasOnOffZone2Old
'	Global Preserve Boolean pasOnOffZone3BtnOld
'	Global Preserve Boolean pasOnOffZone3Old
'	Global Preserve Boolean pasOnOffZone4BtnOld
'	Global Preserve Boolean pasOnOffZone4Old
'	Global Preserve Boolean pasOTAOnOffZone1BtnOld
'	Global Preserve Boolean pasOTAOnOffZone1Old
'	Global Preserve Boolean pasOTAOnOffZone2BtnOld
'	Global Preserve Boolean pasOTAOnOffZone2Old
'	Global Preserve Boolean pasOTAOnOffZone3BtnOld
'	Global Preserve Boolean pasOTAOnOffZone3Old
'	Global Preserve Boolean pasOTAOnOffZone4BtnOld
'	Global Preserve Boolean pasOTAOnOffZone4Old
'	Global Preserve Boolean pasPIDTuneDoneZone1BtnOld
'	Global Preserve Boolean pasPIDTuneDoneZone1Old
'	Global Preserve Boolean pasPIDTuneDoneZone2BtnOld
'	Global Preserve Boolean pasPIDTuneDoneZone2Old
'	Global Preserve Boolean pasPIDTuneDoneZone3BtnOld
'	Global Preserve Boolean pasPIDTuneDoneZone3Old
'	Global Preserve Boolean pasPIDTuneFailZone1BtnOld
'	Global Preserve Boolean pasPIDTuneFailZone1Old
'	Global Preserve Boolean pasPIDTuneFailZone2BtnOld
'	Global Preserve Boolean pasPIDTuneFailZone2Old
'	Global Preserve Boolean pasPIDTuneFailZone3BtnOld
'	Global Preserve Boolean pasPIDTuneFailZone3Old
'	Global Preserve Boolean pasRemoteAlarmAcknowledgeBtnOld
'	Global Preserve Boolean pasRemoteAlarmAcknowledgeOld
'	Global Preserve Boolean pasResetHighTempBtnOld
'	Global Preserve Boolean pasResetHighTempOld
'	Global Preserve Boolean pasResetMaxBtnOld
'	Global Preserve Boolean pasResetMaxOld
'	Global Preserve Boolean pasShuttleExtendOld
'	Global Preserve Boolean pasShuttleLoadPositionOld
'	Global Preserve Boolean pasShuttleMidwayOld
'	Global Preserve Boolean pasShuttleNoLoadOld
'	Global Preserve Boolean pasSlideExtendBtnOld
'	Global Preserve Boolean pasSlideExtendOld
'	Global Preserve Boolean pasStartBtnOld
'	Global Preserve Boolean pasStartOld
'	Global Preserve Boolean pasStartPIDTuneZone1BtnOld
'	Global Preserve Boolean pasStartPIDTuneZone1Old
'	Global Preserve Boolean pasStartPIDTuneZone2BtnOld
'	Global Preserve Boolean pasStartPIDTuneZone2Old
'	Global Preserve Boolean pasStartPIDTuneZone4BtnOld
'	Global Preserve Boolean pasStartPIDTuneZone4Old
'	Global Preserve Boolean pasSteelInsertOld
'	Global Preserve Boolean pasTempOnOffBtnOld
'	Global Preserve Boolean pasTempOnOffOld
'	Global Preserve Boolean pasUpLimitBtnOld
'	Global Preserve Boolean pasUpLimitOld
'	Global Preserve Boolean pasVibTrackBtnOld
'	Global Preserve Boolean pasVibTrackOld
'	Global Preserve Boolean pauseFlagOld
'	Global Preserve Boolean pauseStatusOld
'	Global Preserve Boolean RecEntryMissingOld
'	Global Preserve Boolean recFlashRequiredOld
'	Global Preserve Boolean ReturnFlagOld
'	Global Preserve Boolean rightInterlockACKBtnOld
'	Global Preserve Boolean rightInterlockACKOld
'	Global Preserve Boolean rightIntlockOld
'	Global Preserve Boolean RobotPlacedPanelOld
'	Global Preserve Boolean safeGuardInputOld
'	Global Preserve Boolean sftyFrmIlockAckBtnOld
'	Global Preserve Boolean sftyFrmIlockAckOld
'	Global Preserve Boolean SkippedLastHoleOld
'	Global Preserve Boolean stackLightAlrmCCOld
'	Global Preserve Boolean stackLightAlrmOld
'	Global Preserve Boolean stackLightGrnCCOld
'	Global Preserve Boolean stackLightGrnOld
'	Global Preserve Boolean stackLightRedCCOld
'	Global Preserve Boolean stackLightRedOld
'	Global Preserve Boolean stackLightYelCCOld
'	Global Preserve Boolean stackLightYelOld
'	Global Preserve Boolean suctionCupsCCOld
'	Global Preserve Boolean suctionCupsOld
'	Global Preserve Boolean tasksRunningStatusOld
'	Global Preserve Boolean teachModeStatusOld
'	Global Preserve Double recPartNumberOld
'	Global Preserve Integer CrowdingOld
'	Global Preserve Integer ctrlrErrAxisNumberOld
'	Global Preserve Integer ctrlrErrorNumOld
'	Global Preserve Integer ctrlrLineNumberOld
'	Global Preserve Integer ctrlrTaskNumberOld
'	Global Preserve Integer currentFlashHoleOld
'	Global Preserve Integer currentHSHoleOld
'	Global Preserve Integer currentInspectHoleOld
'	Global Preserve Integer currentPreinspectHoleOld
'	Global Preserve Integer FirstHolePointFlashOld
'	Global Preserve Integer FirstHolePointHotStakeOld
'	Global Preserve Integer FirstHolePointInspectionOld
'	Global Preserve Integer inMagCurrentStateOld
'	Global Preserve Integer jobAbortOld
'	Global Preserve Integer jobNumPanelsDoneOld
'	Global Preserve Integer jobNumPanelsOld
'	Global Preserve Integer LastHolePointFlashOld
'	Global Preserve Integer LastHolePointHotStakeOld
'	Global Preserve Integer LastHolePointInspectionOld
'	Global Preserve Integer mainCurrentStateOld
'	Global Preserve Integer outMagCurrentStateOld
'	Global Preserve Integer OutmagLastStateOld
'	Global Preserve Integer recCrowdingOld
'	Global Preserve Integer recInmagOld
'	Global Preserve Integer recInsertTypeOld
'	Global Preserve Integer recNumberOfHolesOld
'	Global Preserve Integer recOutmagOld
'	Global Preserve Integer recPreCrowdingOld
'	Global Preserve Integer StatusCheckCrowdingOld
'	Global Preserve Integer StatusCheckDropOffOld
'	Global Preserve Integer StatusCheckFlashOld
'	Global Preserve Integer StatusCheckHotStakeOld
'	Global Preserve Integer StatusCheckInspectionOld
'	Global Preserve Integer StatusCheckPickUpOld
'	Global Preserve Integer StatusCheckPreinspectionOld
'	Global Preserve Integer SystemAccelOld
'	Global Preserve Integer SystemSpeedOld
'	Global Preserve Integer systemStatusOld
'	Global Preserve Integer xOld
'	Global Preserve Integer zOld
'	Global Preserve Long pasActualTempZone1Old
'	Global Preserve Long pasActualTempZone1SetOld
'	Global Preserve Long pasActualTempZone2Old
'	Global Preserve Long pasActualTempZone2SetOld
'	Global Preserve Long pasCoolActualOld
'	Global Preserve Long pasCoolActualSetOld
'	Global Preserve Long pasCoolOld
'	Global Preserve Long pasCoolSetOld
'	Global Preserve Long pasDwellActualOld
'	Global Preserve Long pasDwellActualSetOld
'	Global Preserve Long pasDwellOld
'	Global Preserve Long pasDwellSetOld
'	Global Preserve Long pasInsertPreheatOld
'	Global Preserve Long pasInsertPreheatSetOld
'	Global Preserve Long pasJogSpeedOld
'	Global Preserve Long pasJogSpeedSetOld
'	Global Preserve Long pasLoadMeterOld
'	Global Preserve Long pasLoadMeterSetOld
'	Global Preserve Long pasMaxLoadmeterOld
'	Global Preserve Long pasMaxLoadmeterSetOld
'	Global Preserve Long pasPIDsetupActualZone1Old
'	Global Preserve Long pasPIDsetupActualZone1SetOld
'	Global Preserve Long pasPIDsetupActualZone2Old
'	Global Preserve Long pasPIDsetupActualZone2SetOld
'	Global Preserve Long pasPIDsetupActualZone3Old
'	Global Preserve Long pasPIDsetupActualZone3SetOld
'	Global Preserve Long pasPIDsetupActualZone4Old
'	Global Preserve Long pasPIDsetupActualZone4SetOld
'	Global Preserve Long pasPIDsetupDZone1Old
'	Global Preserve Long pasPIDsetupDZone1SetOld
'	Global Preserve Long pasPIDsetupDZone2Old
'	Global Preserve Long pasPIDsetupDZone2SetOld
'	Global Preserve Long pasPIDsetupDZone3Old
'	Global Preserve Long pasPIDsetupDZone3SetOld
'	Global Preserve Long pasPIDsetupDZone4Old
'	Global Preserve Long pasPIDsetupDZone4SetOld
'	Global Preserve Long pasPIDsetupInTempZone1Old
'	Global Preserve Long pasPIDsetupInTempZone1SetOld
'	Global Preserve Long pasPIDsetupInTempZone2Old
'	Global Preserve Long pasPIDsetupInTempZone2SetOld
'	Global Preserve Long pasPIDsetupInTempZone3Old
'	Global Preserve Long pasPIDsetupInTempZone3SetOld
'	Global Preserve Long pasPIDsetupInTempZone4Old
'	Global Preserve Long pasPIDsetupInTempZone4SetOld
'	Global Preserve Long pasPIDsetupIZone1Old
'	Global Preserve Long pasPIDsetupIZone1SetOld
'	Global Preserve Long pasPIDsetupIZone2Old
'	Global Preserve Long pasPIDsetupIZone2SetOld
'	Global Preserve Long pasPIDsetupIZone3Old
'	Global Preserve Long pasPIDsetupIZone3SetOld
'	Global Preserve Long pasPIDsetupIZone4Old
'	Global Preserve Long pasPIDsetupIZone4SetOld
'	Global Preserve Long pasPIDsetupMaxTempZone1Old
'	Global Preserve Long pasPIDsetupMaxTempZone1SetOld
'	Global Preserve Long pasPIDsetupMaxTempZone2Old
'	Global Preserve Long pasPIDsetupMaxTempZone2SetOld
'	Global Preserve Long pasPIDsetupMaxTempZone3Old
'	Global Preserve Long pasPIDsetupMaxTempZone3SetOld
'	Global Preserve Long pasPIDsetupMaxTempZone4Old
'	Global Preserve Long pasPIDsetupMaxTempZone4SetOld
'	Global Preserve Long pasPIDsetupOffsetZone1Old
'	Global Preserve Long pasPIDsetupOffsetZone1SetOld
'	Global Preserve Long pasPIDsetupOffsetZone2Old
'	Global Preserve Long pasPIDsetupOffsetZone2SetOld
'	Global Preserve Long pasPIDsetupOffsetZone3Old
'	Global Preserve Long pasPIDsetupOffsetZone3SetOld
'	Global Preserve Long pasPIDsetupOffsetZone4Old
'	Global Preserve Long pasPIDsetupOffsetZone4SetOld
'	Global Preserve Long pasPIDsetupPZone1Old
'	Global Preserve Long pasPIDsetupPZone1SetOld
'	Global Preserve Long pasPIDsetupPZone2Old
'	Global Preserve Long pasPIDsetupPZone2SetOld
'	Global Preserve Long pasPIDsetupPZone3Old
'	Global Preserve Long pasPIDsetupPZone3SetOld
'	Global Preserve Long pasPIDsetupPZone4Old
'	Global Preserve Long pasPIDsetupPZone4SetOld
'	Global Preserve Long pasPIDsetupSetPointZone1Old
'	Global Preserve Long pasPIDsetupSetPointZone1SetOld
'	Global Preserve Long pasPIDsetupSetPointZone2Old
'	Global Preserve Long pasPIDsetupSetPointZone2SetOld
'	Global Preserve Long pasPIDsetupSetPointZone3Old
'	Global Preserve Long pasPIDsetupSetPointZone3SetOld
'	Global Preserve Long pasPIDsetupSetPointZone4Old
'	Global Preserve Long pasPIDsetupSetPointZone4SetOld
'	Global Preserve Long pasPIDShowDZone1Old
'	Global Preserve Long pasPIDShowDZone1SetOld
'	Global Preserve Long pasPIDShowDZone2Old
'	Global Preserve Long pasPIDShowDZone2SetOld
'	Global Preserve Long pasPIDShowIZone1Old
'	Global Preserve Long pasPIDShowIZone1SetOld
'	Global Preserve Long pasPIDShowIZone2Old
'	Global Preserve Long pasPIDShowIZone2SetOld
'	Global Preserve Long pasPIDShowPZone1Old
'	Global Preserve Long pasPIDShowPZone1SetOld
'	Global Preserve Long pasPIDShowPZone2Old
'	Global Preserve Long pasPIDShowPZone2SetOld
'	Global Preserve Long pasPreHeatActualOld
'	Global Preserve Long pasPreHeatActualSetOld
'	Global Preserve Long pasRecipeOld
'	Global Preserve Long pasRecipeSetOld
'	Global Preserve Long pasSetTempZone2Old
'	Global Preserve Long pasSetTempZone2SetOld
'	Global Preserve Real CurrentThetaHereOld
'	Global Preserve Real hole0LOld
'	Global Preserve Real hole0ROld
'	Global Preserve Real hole10LOld
'	Global Preserve Real hole10ROld
'	Global Preserve Real hole11LOld
'	Global Preserve Real hole11ROld
'	Global Preserve Real hole12LOld
'	Global Preserve Real hole12ROld
'	Global Preserve Real hole13LOld
'	Global Preserve Real hole13ROld
'	Global Preserve Real hole14LOld
'	Global Preserve Real hole14ROld
'	Global Preserve Real hole15LOld
'	Global Preserve Real hole15ROld
'	Global Preserve Real hole16LOld
'	Global Preserve Real hole16ROld
'	Global Preserve Real hole17LOld
'	Global Preserve Real hole17ROld
'	Global Preserve Real hole18LOld
'	Global Preserve Real hole18ROld
'	Global Preserve Real hole19LOld
'	Global Preserve Real hole19ROld
'	Global Preserve Real hole1LOld
'	Global Preserve Real hole1ROld
'	Global Preserve Real hole20LOld
'	Global Preserve Real hole20ROld
'	Global Preserve Real hole21LOld
'	Global Preserve Real hole21ROld
'	Global Preserve Real hole22LOld
'	Global Preserve Real hole22ROld
'	Global Preserve Real hole2LOld
'	Global Preserve Real hole2ROld
'	Global Preserve Real hole3LOld
'	Global Preserve Real hole3ROld
'	Global Preserve Real hole4LOld
'	Global Preserve Real hole4ROld
'	Global Preserve Real hole5LOld
'	Global Preserve Real hole5ROld
'	Global Preserve Real hole6LOld
'	Global Preserve Real hole6ROld
'	Global Preserve Real hole7LOld
'	Global Preserve Real hole7ROld
'	Global Preserve Real hole8LOld
'	Global Preserve Real hole8ROld
'	Global Preserve Real hole9LOld
'	Global Preserve Real hole9ROld
'	Global Preserve Real InMagTorqueLimOld
'	Global Preserve Real insertDepthToleranceOld
'	Global Preserve Real OutMagTorqueLimOld
'	Global Preserve Real pasHeatStakingIPMOld
'	Global Preserve Real pasHeatStakingIPMSetOld
'	Global Preserve Real pasHomeIPMOld
'	Global Preserve Real pasHomeIPMSetOld
'	Global Preserve Real pasInsertDepthOld
'	Global Preserve Real pasInsertDepthSetOld
'	Global Preserve Real pasInsertEngageIPMOld
'	Global Preserve Real pasInsertEngageIPMSetOld
'	Global Preserve Real pasInsertEngageOld
'	Global Preserve Real pasInsertEngageSetOld
'	Global Preserve Real pasInsertPickupIPMOld
'	Global Preserve Real pasInsertPickupIPMSetOld
'	Global Preserve Real pasInsertPositionOld
'	Global Preserve Real pasInsertPositionSetOld
'	Global Preserve Real pasMessageDBOld
'	Global Preserve Real pasMessageDBSetOld
'	Global Preserve Real pasSetTempZone1Old
'	Global Preserve Real pasSetTempZone1SetOld
'	Global Preserve Real pasSoftHomeOld
'	Global Preserve Real pasSoftHomeSetOld
'	Global Preserve Real pasSoftStopOld
'	Global Preserve Real pasSoftStopSetOld
'	Global Preserve Real pasVerticalLocationOld
'	Global Preserve Real pasVerticalLocationSetOld
'	Global Preserve Real recFlashDwellTimeOld
'	Global Preserve Real recInmagPickupOffsetOld
'	Global Preserve Real recInsertDepthOld
'	Global Preserve Real recOutmagPickupOffsetOld
'	Global Preserve Real recPanelThicknessOld
'	Global Preserve Real recTempProbeOld
'	Global Preserve Real recTempTrackOld
'	Global Preserve RealrecSuctionWaitTimeOld
'	Global Preserve Real zLimitOld
'	Global Preserve Real ZmaxTorqueOld
'	Global Preserve String ctrlrErrMsgOld$

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
	Global Boolean pas1inLoadInsertCylinderBtnOld
	Global Boolean pas1inLoadInsertCylinderOld
	Global Boolean pasAlarmGroupOld
	Global Boolean pasBlowInsertBtnOld
	Global Boolean pasBlowInsertOld
	Global Boolean pasBowlDumpOpenBtnOld
	Global Boolean pasBowlDumpOpenOld
	Global Boolean pasBowlFeederBtnOld
	Global Boolean pasBowlFeederOld
	Global Boolean pasGoHomeBtnOld
	Global Boolean pasGoHomeOld
	Global Boolean pasHeadDownBtnOld
	Global Boolean pasHeadDownOld
	Global Boolean pasHeadinsertpickupextendOld
	Global Boolean pasHeadinsertPickupRetractOld
	Global Boolean pasHeadUpBtnOld
	Global Boolean pasHeadUpOld
	Global Boolean pasHighTempAlarmOld
	Global Boolean pasHomeBtnOld
	Global Boolean pasHomeOld
	Global Boolean pasInsertDetectedOld
	Global Boolean pasInsertGripperBtnOld
	Global Boolean pasInsertGripperOld
	Global Boolean pasInsertInShuttleOld
	Global Boolean pasInsertTypeBtnOld
	Global Boolean pasInsertTypeOld
	Global Boolean pasInTempZone1Old
	Global Boolean pasInTempZone2Old
	Global Boolean pasInTempZone3Old
	Global Boolean pasInTempZone4Old
	Global Boolean pasLowerlimitBtnOld
	Global Boolean pasLowerlimitOld
	Global Boolean pasMasterTempBtnOld
	Global Boolean pasMasterTempOld
	Global Boolean pasMaxTempOnOffZone1BtnOld
	Global Boolean pasMaxTempOnOffZone1Old
	Global Boolean pasMaxTempOnOffZone2BtnOld
	Global Boolean pasMaxTempOnOffZone2Old
	Global Boolean pasMaxTempOnOffZone3BtnOld
	Global Boolean pasMaxTempOnOffZone3Old
	Global Boolean pasMaxTempOnOffZone4BtnOld
	Global Boolean pasMaxTempOnOffZone4Old
	Global Boolean pasMaxTempZone1Old
	Global Boolean pasMaxTempZone2Old
	Global Boolean pasMaxTempZone3Old
	Global Boolean pasMaxTempZone4Old
	Global Boolean pasMCREStopBtnOld
	Global Boolean pasMCREStopOld
	Global Boolean pasOnOffZone1BtnOld
	Global Boolean pasOnOffZone1Old
	Global Boolean pasOnOffZone2BtnOld
	Global Boolean pasOnOffZone2Old
	Global Boolean pasOnOffZone3BtnOld
	Global Boolean pasOnOffZone3Old
	Global Boolean pasOnOffZone4BtnOld
	Global Boolean pasOnOffZone4Old
	Global Boolean pasOTAOnOffZone1BtnOld
	Global Boolean pasOTAOnOffZone1Old
	Global Boolean pasOTAOnOffZone2BtnOld
	Global Boolean pasOTAOnOffZone2Old
	Global Boolean pasOTAOnOffZone3BtnOld
	Global Boolean pasOTAOnOffZone3Old
	Global Boolean pasOTAOnOffZone4BtnOld
	Global Boolean pasOTAOnOffZone4Old
	Global Boolean pasPIDTuneDoneZone1BtnOld
	Global Boolean pasPIDTuneDoneZone1Old
	Global Boolean pasPIDTuneDoneZone2BtnOld
	Global Boolean pasPIDTuneDoneZone2Old
	Global Boolean pasPIDTuneDoneZone3BtnOld
	Global Boolean pasPIDTuneDoneZone3Old
	Global Boolean pasPIDTuneFailZone1BtnOld
	Global Boolean pasPIDTuneFailZone1Old
	Global Boolean pasPIDTuneFailZone2BtnOld
	Global Boolean pasPIDTuneFailZone2Old
	Global Boolean pasPIDTuneFailZone3BtnOld
	Global Boolean pasPIDTuneFailZone3Old
	Global Boolean pasRemoteAlarmAcknowledgeBtnOld
	Global Boolean pasRemoteAlarmAcknowledgeOld
	Global Boolean pasResetHighTempBtnOld
	Global Boolean pasResetHighTempOld
	Global Boolean pasResetMaxBtnOld
	Global Boolean pasResetMaxOld
	Global Boolean pasShuttleExtendOld
	Global Boolean pasShuttleLoadPositionOld
	Global Boolean pasShuttleMidwayOld
	Global Boolean pasShuttleNoLoadOld
	Global Boolean pasSlideExtendBtnOld
	Global Boolean pasSlideExtendOld
	Global Boolean pasStartBtnOld
	Global Boolean pasStartOld
	Global Boolean pasStartPIDTuneZone1BtnOld
	Global Boolean pasStartPIDTuneZone1Old
	Global Boolean pasStartPIDTuneZone2BtnOld
	Global Boolean pasStartPIDTuneZone2Old
	Global Boolean pasStartPIDTuneZone4BtnOld
	Global Boolean pasStartPIDTuneZone4Old
	Global Boolean pasSteelInsertOld
	Global Boolean pasTempOnOffBtnOld
	Global Boolean pasTempOnOffOld
	Global Boolean pasUpLimitBtnOld
	Global Boolean pasUpLimitOld
	Global Boolean pasVibTrackBtnOld
	Global Boolean pasVibTrackOld
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
	Global Long pasActualTempZone1Old
	Global Long pasActualTempZone1SetOld
	Global Long pasActualTempZone2Old
	Global Long pasActualTempZone2SetOld
	Global Long pasCoolActualOld
	Global Long pasCoolActualSetOld
	Global Long pasCoolOld
	Global Long pasCoolSetOld
	Global Long pasDwellActualOld
	Global Long pasDwellActualSetOld
	Global Long pasDwellOld
	Global Long pasDwellSetOld
	Global Long pasInsertPreheatOld
	Global Long pasInsertPreheatSetOld
	Global Long pasJogSpeedOld
	Global Long pasJogSpeedSetOld
	Global Long pasLoadMeterOld
	Global Long pasLoadMeterSetOld
	Global Long pasMaxLoadmeterOld
	Global Long pasMaxLoadmeterSetOld
	Global Long pasPIDsetupActualZone1Old
	Global Long pasPIDsetupActualZone1SetOld
	Global Long pasPIDsetupActualZone2Old
	Global Long pasPIDsetupActualZone2SetOld
	Global Long pasPIDsetupActualZone3Old
	Global Long pasPIDsetupActualZone3SetOld
	Global Long pasPIDsetupActualZone4Old
	Global Long pasPIDsetupActualZone4SetOld
	Global Long pasPIDsetupDZone1Old
	Global Long pasPIDsetupDZone1SetOld
	Global Long pasPIDsetupDZone2Old
	Global Long pasPIDsetupDZone2SetOld
	Global Long pasPIDsetupDZone3Old
	Global Long pasPIDsetupDZone3SetOld
	Global Long pasPIDsetupDZone4Old
	Global Long pasPIDsetupDZone4SetOld
	Global Long pasPIDsetupInTempZone1Old
	Global Long pasPIDsetupInTempZone1SetOld
	Global Long pasPIDsetupInTempZone2Old
	Global Long pasPIDsetupInTempZone2SetOld
	Global Long pasPIDsetupInTempZone3Old
	Global Long pasPIDsetupInTempZone3SetOld
	Global Long pasPIDsetupInTempZone4Old
	Global Long pasPIDsetupInTempZone4SetOld
	Global Long pasPIDsetupIZone1Old
	Global Long pasPIDsetupIZone1SetOld
	Global Long pasPIDsetupIZone2Old
	Global Long pasPIDsetupIZone2SetOld
	Global Long pasPIDsetupIZone3Old
	Global Long pasPIDsetupIZone3SetOld
	Global Long pasPIDsetupIZone4Old
	Global Long pasPIDsetupIZone4SetOld
	Global Long pasPIDsetupMaxTempZone1Old
	Global Long pasPIDsetupMaxTempZone1SetOld
	Global Long pasPIDsetupMaxTempZone2Old
	Global Long pasPIDsetupMaxTempZone2SetOld
	Global Long pasPIDsetupMaxTempZone3Old
	Global Long pasPIDsetupMaxTempZone3SetOld
	Global Long pasPIDsetupMaxTempZone4Old
	Global Long pasPIDsetupMaxTempZone4SetOld
	Global Long pasPIDsetupOffsetZone1Old
	Global Long pasPIDsetupOffsetZone1SetOld
	Global Long pasPIDsetupOffsetZone2Old
	Global Long pasPIDsetupOffsetZone2SetOld
	Global Long pasPIDsetupOffsetZone3Old
	Global Long pasPIDsetupOffsetZone3SetOld
	Global Long pasPIDsetupOffsetZone4Old
	Global Long pasPIDsetupOffsetZone4SetOld
	Global Long pasPIDsetupPZone1Old
	Global Long pasPIDsetupPZone1SetOld
	Global Long pasPIDsetupPZone2Old
	Global Long pasPIDsetupPZone2SetOld
	Global Long pasPIDsetupPZone3Old
	Global Long pasPIDsetupPZone3SetOld
	Global Long pasPIDsetupPZone4Old
	Global Long pasPIDsetupPZone4SetOld
	Global Long pasPIDsetupSetPointZone1Old
	Global Long pasPIDsetupSetPointZone1SetOld
	Global Long pasPIDsetupSetPointZone2Old
	Global Long pasPIDsetupSetPointZone2SetOld
	Global Long pasPIDsetupSetPointZone3Old
	Global Long pasPIDsetupSetPointZone3SetOld
	Global Long pasPIDsetupSetPointZone4Old
	Global Long pasPIDsetupSetPointZone4SetOld
	Global Long pasPIDShowDZone1Old
	Global Long pasPIDShowDZone1SetOld
	Global Long pasPIDShowDZone2Old
	Global Long pasPIDShowDZone2SetOld
	Global Long pasPIDShowIZone1Old
	Global Long pasPIDShowIZone1SetOld
	Global Long pasPIDShowIZone2Old
	Global Long pasPIDShowIZone2SetOld
	Global Long pasPIDShowPZone1Old
	Global Long pasPIDShowPZone1SetOld
	Global Long pasPIDShowPZone2Old
	Global Long pasPIDShowPZone2SetOld
	Global Long pasPreHeatActualOld
	Global Long pasPreHeatActualSetOld
	Global Long pasRecipeOld
	Global Long pasRecipeSetOld
	Global Long pasSetTempZone2Old
	Global Long pasSetTempZone2SetOld
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
	Global Real pasHeatStakingIPMOld
	Global Real pasHeatStakingIPMSetOld
	Global Real pasHomeIPMOld
	Global Real pasHomeIPMSetOld
	Global Real pasInsertDepthOld
	Global Real pasInsertDepthSetOld
	Global Real pasInsertEngageIPMOld
	Global Real pasInsertEngageIPMSetOld
	Global Real pasInsertEngageOld
	Global Real pasInsertEngageSetOld
	Global Real pasInsertPickupIPMOld
	Global Real pasInsertPickupIPMSetOld
	Global Real pasInsertPositionOld
	Global Real pasInsertPositionSetOld
	Global Real pasMessageDBOld
	Global Real pasMessageDBSetOld
	Global Real pasSetTempZone1Old
	Global Real pasSetTempZone1SetOld
	Global Real pasSoftHomeOld
	Global Real pasSoftHomeSetOld
	Global Real pasSoftStopOld
	Global Real pasSoftStopSetOld
	Global Real pasVerticalLocationOld
	Global Real pasVerticalLocationSetOld
	Global Real recFlashDwellTimeOld
	Global Real recInmagPickupOffsetOld
	Global Real recInsertDepthOld
	Global Real recOutmagPickupOffsetOld
	Global Real recPanelThicknessOld
	Global Real recTempProbeOld
	Global Real recTempTrackOld
	Global Real recsuctionWaitTimeOld
	Global Real zLimitOld
	Global Real ZmaxTorqueOld
	Global String ctrlrErrMsgOld$






