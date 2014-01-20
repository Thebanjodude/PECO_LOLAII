
' System Global #defines
#define ScanSpeed 35 ' Percent Speed the arm moves during the scanning process
#define Zaxis 3 ' The z axis is address by "3" (x,y,z,theta)
#define Preinspection 1
#define Postinspection 2

' System speeds
#define slow 1
#define fast 2

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

'Inspection Station Defines
#define RightSpotFace 1
#define LeftSpotFace 0

' Recipe Ingredients for Panels
#define InsertTypeUnknown 0
#define AluminumInsert 1
#define StainlessInsert 2
#define xCoord 0
#define YCoord 1

'State of Health Global Defines
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


