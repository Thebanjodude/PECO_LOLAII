#include "Defines.inc"
#include "HMI.inc"
#include "Recipe.inc"
#include "Error.inc"

' Used Timers
' TMR-
'	0  -  IOT (hmi comms) - iotransfer()
'	1  -  Crowding open delay -- crowdingSequence()
'	2  -  modbus delay -- MBCommandTask()
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

'<TESTING>
'Global Real foo
'Global Real xd, yd
'Global Boolean blah
'</TESTING>

' System Global Vars and #defines
Global Integer SystemSpeed, System, mainCurrentState
Global Boolean suctionCups, suctionCupsCC, holeDetected, maintMode
Global Integer systemStatus ' Integer that tells opperator what state the sytem is in-see State tab in IOT
Global Real zLimit ' the highest the EOAT can move without hitting periphials
Global Real ZmaxTorque ' Monitors Z torque
Global Integer Crowding

'Global Integer NextState
Global Boolean monEstop1, monEstop2, jobAbort, alarmMute, alarmTog, alarmMuteBtn
Global Boolean edgeDetectGo, edgeDetectHi, edgeDetectLo, pauseFlag
Global Boolean panelDataTxACKBtn, eStopReset, eStopResetCC
Global Boolean GoFlag, ReturnFlag 'flags to make sure we dont break the drill

' Input Magazine Global Vars
Global Boolean inMagGoHome, inMagLoaded, inMagPnlRdy, inMagMtr, inMagMtrDir ' DIO to run intput the magazine
Global Boolean inMagLowLim, inMagUpLim, inMagInterlock
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
Global Boolean outMagLowLim, outMagLowLimN, outMagInt
Global Real OutMagTorqueLim, recOutmagPickupOffset
Global Boolean OutMagDropOffSignal ' Signal robot it can Drop Off a panel to outmag
Global Boolean OutMagRobotClearSignal  ' Signal robot is out of the way,OK to move outmag
Global Integer outMagCurrentState
Global Boolean outMagMtrCC, outMagMtrDirCC, RobotPlacedPanel
Global Integer OutmagLastState

'Inspection Station Global Vars
Global Boolean PanelPassedInspection ' Indicates if the panel passes inspection
Global Real insertDepthTolerance
Global Boolean PassFailArray(0, 0)
Global Real InspectionArray(0, 0), recInmagPickupOffset
Global Boolean SkipHoleArray(0, 0)
Global Boolean panelDataTxRdy, panelDataTxACK
Global Integer currentInspectHole, currentPreinspectHole

'Flash Removal Global Vars
Global Boolean flashPanelPresnt
Global Boolean drillGo, drillReturn, FlashPnlPrsnt, debrisMtr, FlashHomeCC, flashHomeNO, flashHomeNC
Global Boolean drillGoCC, drillReturnCC, debrisMtrCC
Global Integer currentFlashHole

'Heat Stake Global Vars
Global Boolean hsPanelPresnt
Global Integer currentHSHole
Global Real PreInspectionArray(0, 0)

' PositionFunction globals

'--TODO-- replace the preserve vars with code to pull the values from the HMI
'-------<MOCK>-----------------

Global Preserve Integer PanelHoleCount
Global Preserve Double PanelHoleX(25)
Global Preserve Double PanelHoleY(25)
Global Preserve Double PanelHoleTangent(25)
Global Preserve Double PanelPickupErrorX
Global Preserve Double PanelPickupErrorY
Global Preserve Double PanelPickupErrorTheta

'Global Integer PanelHoleCount
'Global Double PanelHoleX(25)
'Global Double PanelHoleY(25)
'Global Double PanelHoleTangent(25)
'Global Double PanelPickupErrorX
'Global Double PanelPickupErrorY
'Global Double PanelPickupErrorTheta
'-----</MOCK>-------------------
Global Double holeTolerance '+/- mm to center of hole
Global Double EOATcorrection
Global Double magazineCorrection
Global Double stepsize
Global Double systemThetaError

