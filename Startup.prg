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
    
    'Xqt 9 -- Unused
    'Xqt 10 -- Used in HeatStakeComms for MBCommandTask
    
    Call MBInitialize
    
	' Start the PLC
	'Wait bootDelayH
	Wait Sw(0)
	bootCC = True 'Let the PLC know that it is safe to boot
	'Wait idleH
	Wait Sw(1)
	bootCC = False 'PLC has booted, reset the boot flag

	ClearMemory() ' writes a zero to all the memIO
	
	Motor On
	Power High
	
	Speed SystemSpeed
	Accel SystemAccel, SystemAccel 'Paramterize these numbers
	SpeedS SystemSpeed
	AccelS SystemAccel, SystemAccel
	QP (On) ' turn On quick pausing	
	
	findHome

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
Function ClearMemory()
	
	Integer i
	
	For i = 0 To 15
		MemOutW i, 0 ' This writes 0 to all memory locations in word chunks
	Next
	i = 0
	
Fend

