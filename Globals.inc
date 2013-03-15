
' System Global Vars and #defines
#define Zlimit -135 ' Zlimit is the highest position the z-axis can go without hitting anything.
Global Integer SystemSpeed, SystemSpeedDef, SystemSpeedFV
Global Integer jobNumPanelsDone, hsProbeTemp, hmiStatus, systemStatus
Global Boolean suctionCups, sftyFrmIlockAck, robStop, robPause
Global Boolean robResume
#define SystemAccel 30 ' Percent acceleration the arm uses during regular opperation
#define ScanSpeed 35 ' Percent Speed the arm moves during the scanning process
#define SuckTime .5 ' Time in seconds it takes for the EOAT to make a good suction on a panel
#define Zaxis 3 ' The z axis is address by "3" (x,y,z,theta)
#define NumOfUserDefinedErrors 40 ' Number of user defined errors
Global Integer x, z, xhFV, xh ' Increment for P(x) to define edge

'Commands from HMI
Global Boolean hmiPause, startJob, robStart, hmiStopJob, jobDone
Global Boolean HmiPauseFlag
Global Integer jobNumPanels

' Input Magazine Global Vars
Global Boolean inMagGoHome, inMagLoaded, inMagPnlRdy, inMagMtr, inMagMtrDir ' DIO to run intput the magazine
Global Boolean inMagLowerLim, inMagUpperLim, inMagInterlock, inMagIntLockAck
Global Boolean InMagRobotClearSignal ' Signal robot is out of the way,OK to move Inmag
Global Boolean InMagPickUpSignal ' Signal robot it can pick up a panel from inmag
Global Real InMagTorqueLim
Global Integer inMagCurrentState

' Output Magazine Global Vars
Global Boolean outMagGoHome, outMagUnloaded, OutputMagSignal, outMagMtr 'DIO to run the output magazine
Global Boolean outMagPanelRdy, outMagMtrDir, outMagUpperLim
Global Boolean outMagLowerLim, outMagInt, outMagIntLockAck
Global Real OutMagTorqueLim
Global Boolean OutMagDropOffSignal ' Signal robot it can Drop Off a panel to outmag
Global Boolean OutMagRobotClearSignal ' Signal robot is out of the way,OK to move outmag
Global Integer outMagCurrentState

'Inspection Station Global Vars
'Global Real ScanOffset ' Distance the arm needs to move to keep the edge of the panel under the scanner
Global Boolean PanelPassedInspection ' Indicates if the panel passes inspection

'system Monitor Vars
Global Boolean cbMonHeatStake, cbMonBowlFeder, cbMonInMag
Global Boolean cbMonOutMag, cbMonFlashRmv, cbMonDebrisRmv
Global Boolean dcPwrOk, cbMonPnumatic, cbMonSafety, cbMonPAS24vdc
Global Boolean stackLightRed, stackLightYel, stackLightGrn, stackLightAlrm
Global Boolean airPressHigh, airPressLow
Global Boolean backInterlock, frontInterlock, leftInterlock, rightInterlock
Global Boolean backInterlockACK, frontInterlockACK, leftInterlockACK, rightInterlockACK


'Hot Stake and Flash Removal Global Vars
Global Real Theta, r ', PanelArray(0, 0)
Global Real AnvilZlimit, AnvilZlimitDef, AnvilZlimitFV ' Hard limit for anvil
Global Integer PanelArrayIndex
Global Boolean SkippedLastHole, hsInstallInsrt, flashPanelPresnt, hsPanelPresnt
Global Boolean flashMtr, flashCyc, FlashPnlPrsnt, debrisMtr

#define RadiusColumn 0 'The first column in the array are radii
#define ThetaColumn 1 'The second column in the array are thetas
#define SkipFlagColumn 2 'The third column in the array are flags for holes if we want to skip them

' Recipe Ingredients for Panels
#define InsertTypeUnknown 0
#define AluminumInsert 1
#define StainlessInsert 2
Global Integer recNumberOfHoles, recInsertType
Global Boolean recFlashRequired
Global Real recZDropOff, recInsertDepth, recPanelThickness
Global Real recTemp, recMinorDim, recMajorDim, recBossHeight

'Error Vars
Global Boolean erPanelFailedInspection, erFrontSafetyFrameOpen, erBackSafetyFrameOpen
Global Boolean erLeftSafetyFrameOpen, erRightSafetyFrameOpen, erLowPressure
Global Boolean erHighPressure, erPanelStatusUnknown, erWrongPanelHoles
Global Boolean erWrongPanelDims, erWrongPanel, erWrongPanelInsert
Global Boolean erInMagEmpty, erInMagOpenInterlock, erOutMagCrowding
Global Boolean erInMagCrowding, erOutMagFull, erOutMagOpenInterlock
Global Boolean erLaserScanner, erDCPower, erDCPowerHeatStake
Global Boolean erHeatStakeBreaker, erBowlFeederBreaker, erInMagBreaker
Global Boolean erOutMagBreaker, erFlashBreaker, erDebrisRemovalBreaker
Global Boolean erPnumaticsBreaker, erSafetySystemBreaker, erRC180
Global Boolean erUnknown, erEstop


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
#define DCpwrError 34
#define DCpwrHeatStakeError 35
#define HeatStakeCBTripped 36
#define BowlFeederCBTripped 37
#define InMagCBTripped 38
#define OutMagCBTripped 39
#define FlashCBTripped 40
#define DebrisCBTripped 41
#define PnumaticsCBTripped 42
#define SafetySystemCBTripped 43


'System State Numbers
'Global Integer SystemStatus
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

' Vars I needed while testing...will clean up and organize later!
'Global Boolean Var0, Var1, InputVar0, InputVar1, OutputVar0, OutputVar0RealWorld
Global Double PanelArray(15, 2) ' Change this back to 0,0
