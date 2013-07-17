' System Global Vars and #defines
Global Integer SystemSpeed, SystemAccel, mainCurrentState
Global Real suctionWaitTime ' Time in seconds it takes for the EOAT to make a good suction on a panel
Global Boolean suctionCups, suctionCupsCC, holeDetected, maintMode
Global Integer systemStatus ' Integer that tells opperator what state the sytem is in-see State tab in IOT
Global Real zLimit ' the highest the EOAT can move without hitting periphials
#define ScanSpeed 35 ' Percent Speed the arm moves during the scanning process
#define Zaxis 3 ' The z axis is address by "3" (x,y,z,theta)
#define Preinspection 1
#define Postinspection 2
Global Real ZmaxTorque ' Monitors Z torque
Global Boolean abortjob
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
Global Boolean SkipHoleArray(0, 0), DeepBoss ' This needs to be global
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
Global Real recInsertDepth, recPanelThickness
Global Real recTempProbe, recTempTrack
Global Integer FirstHolePointInspection, LastHolePointInspection
Global Integer FirstHolePointHotStake, LastHolePointHotStake
Global Integer FirstHolePointFlash, LastHolePointFlash
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
Global Real pasMessageDB
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
Global Real pasMessageDBSet
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






