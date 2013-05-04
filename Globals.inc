' System Global Vars and #defines
Global Integer SystemSpeed, SystemAccel
Global Real suctionWaitTime ' Time in seconds it takes for the EOAT to make a good suction on a panel
Global Boolean suctionCups, suctionCupsCC, holeDetected, maintMode
Global Integer systemStatus ' Integer that tells opperator what state the sytem is in-see State tab in IOT
Global Real zLimit ' the highest the EOAT can move without hitting periphials
#define ScanSpeed 35 ' Percent Speed the arm moves during the scanning process
Global Real xOffset, yOffset, thetaOffset
Global Real PanelCordinates(22, 1)
#define Zaxis 3 ' The z axis is address by "3" (x,y,z,theta)
#define Preinspection False
#define Inspection True
Global Boolean edgeDetectGo, edgeDetectHi, edgeDetectLo, pauseFlag

'Commands from HMI
Global Boolean jobDone
Global Integer jobNumPanels, jobNumPanelsDone, abortJob
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
Global Boolean inMagLowLim, inMagUpLim, inMagIntlock, inMagIntLockAck
Global Boolean inMagLowLimN, inMagUpLimN
Global Boolean InMagRobotClearSignal ' Signal robot is out of the way,OK to move Inmag
Global Boolean InMagPickUpSignal ' Signal robot it can pick up a panel from inmag
Global Real InMagTorqueLim
Global Integer inMagCurrentState
Global Boolean inMagMtrCC, inMagMtrDirCC

' Output Magazine Global Vars
Global Boolean outMagGoHome, outMagUnloaded, OutputMagSignal, outMagMtr 'DIO to run the output magazine
Global Boolean outMagPanelRdy, outMagMtrDir, outMagUpLim, outMagUpLimN
Global Boolean outMagLowLim, outMagLowLimN, outMagInt, outMagIntLockAck
Global Real OutMagTorqueLim
Global Boolean OutMagDropOffSignal ' Signal robot it can Drop Off a panel to outmag
Global Boolean OutMagRobotClearSignal ' Signal robot is out of the way,OK to move outmag
Global Integer outMagCurrentState
Global Boolean outMagMtrCC, outMagMtrDirCC

'Inspection Station Global Vars
Global Boolean PanelPassedInspection ' Indicates if the panel passes inspection
Global Integer x, z ' Increment for P(x) to define edge and num of holes found
Global Real CurrentThetaHere, insertDepthTolerance
Global Boolean PassFailArray(0, 0)
Global Real InspectionArray(0, 0)
#define RightSpotFace 0
#define LeftSpotFace 1

'System Monitor Vars
Global Boolean cbMonHeatStake, cbMonInMag, cbMonOutMag, cbMonDebrisRmv, cbMonSafety, cbMonPAS24vdc
Global Boolean stackLightRed, stackLightYel, stackLightGrn, stackLightAlrm
Global Boolean stackLightRedCC, stackLightYelCC, stackLightGrnCC, stackLightAlrmCC
Global Boolean airPressHigh, airPressLow
Global Boolean backIntlock1, frontIntlock1, leftIntlock1, rightIntlock
Global Boolean backIntlock2, frontIntlock2, leftIntlock2
Global Boolean heartBeat

'Hot Stake and Flash Removal Global Vars
Global Real PanelArray(25, 2)
Global Real Theta, r
Global Real AnvilZlimit, heatStakeCurrentTemp, heatStakeTempTolerance
Global Integer PanelArrayIndex
Global Boolean SkippedLastHole, hsInstallInsrt, flashPanelPresnt, hsPanelPresnt
Global Boolean removeFlash, FlashPnlPrsnt, debrisMtr
Global Boolean removeFlashCC, debrisMtrCC, hsDataTransferRdy, hsDataTransferACK
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
Global Boolean recFlashRequired
Global Real recInsertDepth, recPanelThickness
Global Real recTemp, hsProbeTemp

'Error Vars
Global Boolean erPanelFailedInspection, erFrontSafetyFrameOpen, erBackSafetyFrameOpen
Global Boolean erLeftSafetyFrameOpen, erRightSafetyFrameOpen, erLowPressure
Global Boolean erHighPressure, erPanelStatusUnknown, erWrongPanelHoles
Global Boolean erWrongPanelDims, erWrongPanel, erWrongPanelInsert
Global Boolean erInMagEmpty, erInMagOpenInterlock, erOutMagCrowding
Global Boolean erInMagCrowding, erOutMagFull, erOutMagOpenInterlock
Global Boolean erLaserScanner, erDCPower, erDCPowerHeatStake, erHeatStakeTemp
Global Boolean erHeatStakeBreaker, erBowlFeederBreaker, erInMagBreaker
Global Boolean erOutMagBreaker, erFlashBreaker, erDebrisRemovalBreaker
Global Boolean erPnumaticsBreaker, erSafetySystemBreaker, erRC180, erIllegalArmMove
Global Boolean erUnknown, erEstop, erRecEntryMissing, erParamEntryMissing, erRobotNotAtHome
Global Boolean RecEntryMissing, ParamEntryMissing
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

'System State Numbers
Global Integer SystemState
#define Unknown 0
#define Idle 1
#define PickingPanel 3
#define ScanningPanel 5
#define InstallingInserts 6
#define RemovingFlash 7
#define InspectingPanel 8
#define DepositingPanel 9
#define MovingPanel 4
#define WaitingForOperator 10
#define BuiltInTestMode 11
#define SystemPaused 12

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




