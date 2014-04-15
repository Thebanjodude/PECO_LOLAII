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
  
	ClearMemory() ' writes a zero to all the memIO
	
	Motor On
	Power High
	
	' Find home before we start the PLC
	'  This will move the robot out of the way of the heat stake before it moves
	changeSpeed(slow)
	findHome
	
	' Start the PLC
	' check to see if the PLC waiting to boot or has already booted
	'  if it has already booted, assume it was an e-stop
	Wait MemSw(m_bootDelay) = True Or MemSw(m_bootDone) = True
	' Let the PLC know that it is safe to boot, if it has already booted it will
	'  ignore this bit.
	MBWrite(100, True, MBTypeCoil)

	' Wait for the PLC to reach the idle state
	Wait MemSw(m_idle) = True

	QP (On) ' turn On quick pausing	
Fend


Function CheckInitialParameters() As Integer
'check if the hmi has pushed all the recipe values to the controller, if not throw an error 	
'check if the hmi has pushed all the parameter values to the controller, if not throw an error 

	If recBossCrossArea = 0 Then 'recNumberOfHoles = 0 Or recInsertType = 0 Or
		CheckInitialParameters = 2
		erRecEntryMissing = True
		Print " recBossCrossArea = 0" 'recNumberOfHoles = 0 Or recInsertType = 0 Or
	ElseIf recSuctionWaitTime = 0 Or zLimit = 0 Then
		CheckInitialParameters = 2
		erParamEntryMissing = True
		Print "recSuctionWaitTime = 0 Or zLimit = 0"
	Else
		CheckInitialParameters = 0
		erRecEntryMissing = False
		erParamEntryMissing = False
	EndIf

Fend


Function ClearMemory()
	
	Integer i
	
	For i = 0 To 15
		MemOutW i, 0 ' This writes 0 to all memory locations in word chunks
	Next
	i = 0
	
Fend

