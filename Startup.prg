#include "Globals.INC"

Function PowerOnSequence()
	
	' define the connection to the LASER
    SetNet #203, "10.22.251.171", 7351, CR, NONE, 0
    OpenNet #203 As Client

	' Execute Tasks
	Xqt 2, IOTableInputs, NoEmgAbort
	Xqt 3, IOTableOutputs, NoEmgAbort
	Xqt 4, SystemMonitor, NoEmgAbort
	Xqt 5, iotransfer, NoEmgAbort
	Xqt 6, HmiListen, NoEmgAbort
    Xqt 7, InmagControl, Normal
    Xqt 8, OutMagControlRefactor(), Normal

	' Start the PLC
	'Wait bootDelayH
	Wait Sw(0)
	bootCC = True 'Let the PLC know that it is safe to boot
	'Wait idleH
	Wait Sw(1)
	bootCC = False 'PLC has booted, reset the boot flag
	
retry:

	ClearMemory() ' writes a zero to all the memIO
	
	retry:

	If PowerOnHomeCheck() = False Then GoTo retry ' Don't let the robot move unless its near home
	
	Motor On
	Power High
	
	Speed SystemSpeed
	Accel SystemAccel, SystemAccel 'Paramterize these numbers
	QP (On) ' turn On quick pausing	
	
'	Move PreScan :U(CU(CurPos)) ' go home
'	Move PreScan ROT ' go home
	
Fend
Function CheckInitialParameters() As Integer
'check if the hmi has pushed all the recipe values to the controller, if not throw an error 	
'check if the hmi has pushed all the parameter values to the controller, if not throw an error 

	If recBossCrossArea = 0 Then 'recNumberOfHoles = 0 Or recInsertType = 0 Or
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print " recBossCrossArea = 0" 'recNumberOfHoles = 0 Or recInsertType = 0 Or
	ElseIf recInmag = 0 Or recOutmag = 0 Or recCrowding = 0 Or recPreCrowding = 0 Then
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print "recInmag = 0 Or recOutmag = 0 Or recCrowding = 0 Or recPreCrowding = "
	ElseIf recFirstHolePointInspection = 0 Or recLastHolePointInspection = 0 Or recFirstHolePointHotStake = 0 Or recLastHolePointHotStake = 0 Or recFirstHolePointFlash = 0 Or recLastHolePointFlash = 0 Then
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print "recFirstHolePointInspection = 0 Or recLastHolePointInspection = 0 Or recFirstHolePointHotStake = 0 Or recLastHolePointHotStake = 0 Or recFirstHolePointFlash = 0 Or recLastHolePointFlash = 0"
	ElseIf recPointsTable > 3 Or recPointsTable = 0 Then
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print "0 < recPointsTable < 3"
	ElseIf recSuctionWaitTime = 0 Or SystemSpeed = 0 Or SystemAccel = 0 Or zLimit = 0 Then
		CheckInitialParameters = 2
		erParamEntryMissing = True
		Print "recSuctionWaitTime = 0 Or SystemSpeed = 0 Or SystemAccel = 0 Or zLimit = 0"
	Else
		CheckInitialParameters = 0
		erRecEntryMissing = False
		erParamEntryMissing = False
	EndIf

Fend
Function HotStakeTempRdy() As Boolean
	
	' TODO - once code is done in PLC communicate it back to the robot
		HotStakeTempRdy = True ' ready to start job
'		HotStakeTempRdy = False ' Temperature is not in range
	
Fend
Function PowerOnHomeCheck() As Boolean
	
	Real distx, disty, distz, distance
' TODO: Parameterize these #defines?
	#define startUpDistMax 150 '+/-150mm from home position
	
	distx = Abs(CX(CurPos) - CX(PreScan))
	disty = Abs(CY(CurPos) - CY(PreScan))
	
	distance = Sqr(distx * distx + disty * disty) ' How the hell do you square numbers?
	
	Print "distance away from home: ", distance

	If distance > startUpDistMax Or Hand(Here) = 1 Then  'Check is the position is close to home. If not throw error
		erRobotNotAtHome = True
		PowerOnHomeCheck = False
		Print "Distance NOT OK Or Arm Orientation NOT OK"
	Else
		erRobotNotAtHome = False
		PowerOnHomeCheck = True
		Print "Distance OK and Arm Orientation OK"
	EndIf
	
	'	Print Hand(Here)
	
	If PowerOnHomeCheck = False Then ' When false, free all the joints so opperator can move
		Motor On
		SFree 1, 2, 3, 4
		Print "move robot to home position"
		Pause
	EndIf
		
Fend
Function ClearMemory()
	
	For x = 0 To 15
		MemOutW x, 0 ' This writes 0 to all memory locations in word chunks
	Next
	x = 0
	
Fend

