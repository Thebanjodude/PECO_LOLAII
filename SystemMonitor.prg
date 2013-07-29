#include "Globals.INC"

Function SystemMonitor()
' This function constantly monitors System Pressures, voltages, interlocks, Stake Machine,
'CBs, E-stop, and controller errors. It reports them to the HMI for viewing and acking.

OnErr GoTo errHandler ' Define where to go when a controller error occurs	

ResetErrors() ' resets all errors

Do While True
	
	StateOfHealth()
	
	If frontIntlock1 = True Then
		erFrontSafetyFrameOpen = True
	Else
	 	erFrontSafetyFrameOpen = False
	EndIf
	
	If frontIntlock2 = True Then
		erFrontSafetyFrameOpen = True
	Else
	 	erFrontSafetyFrameOpen = False
	EndIf
	
	If backIntlock1 = True Then
		erBackSafetyFrameOpen = True
	Else
	 	erBackSafetyFrameOpen = False
	EndIf
	
	If backIntlock2 = True Then
		erBackSafetyFrameOpen = True
	Else
	 	erBackSafetyFrameOpen = False
	EndIf
	
	If leftIntlock1 = True Then
		erLeftSafetyFrameOpen = True
	Else
		erLeftSafetyFrameOpen = False
	EndIf

	If leftIntlock2 = True Then
		erLeftSafetyFrameOpen = True
	Else
	 	erLeftSafetyFrameOpen = False
	EndIf
	
	If rightIntlock = True Then
		erRightSafetyFrameOpen = True
	Else
	 	erRightSafetyFrameOpen = False
	EndIf
	
	If airPressHigh = False Then
		erHighPressure = True
'		Pause
	Else
		erHighPressure = False
	EndIf
	
	If airPressLow = False Then
		erLowPressure = True
'		Pause
	Else
		erLowPressure = False
	EndIf
	
	If (airPressLow = False And airPressHigh = False) = True Then
		erBadPressureSensor = True
'		Pause
	Else
		erBadPressureSensor = False
	EndIf
	
	If cbMonHeatStake = False Then
		erHeatStakeBreaker = True
'		Pause
	Else
		erHeatStakeBreaker = False
	EndIf

	If cbMonInMag = False Then
		erInMagBreaker = True
'		Pause
	Else
		erInMagBreaker = False
	EndIf

	If cbMonOutMag = False Then
		erOutMagBreaker = True
'		Pause
	Else
		erOutMagBreaker = False
	EndIf
	
	If cbMonDebrisRmv = False Then
		erDebrisRemovalBreaker = True
'		Pause
	Else
		erDebrisRemovalBreaker = False
	EndIf
	
	If cbMonSafety = False Then
		erSafetySystemBreaker = True
'		Pause
	Else
		erSafetySystemBreaker = False
	EndIf

	If cbMonPAS24vdc = False Then
		erDCPowerHeatStake = True
'		Pause
	Else
		erDCPowerHeatStake = False
	EndIf
	
	'Heat stake temp checking 
	If HotStakeTempRdy = False Then
'		Pause
	EndIf
	
	If EStopOn = True Then
		erEstop = True
	Else
		erEstop = False
	EndIf
	
	'If the in/out magazine sensor diff signals are the same then we know there is a problem	
	If (inMagLowLim And inMagLowLimN = True) Then
		erInMagLowSensorBad = True
'		Pause
	Else
		erInMagLowSensorBad = False
	EndIf
	
	If (inMagUpLim And inMagUpLimN = True) Then
		erInMagUpSensorBad = True

'		Pause
	Else
		erInMagUpSensorBad = False
	EndIf
	
	If (outMagLowLim And outMagLowLimN = True) Then
		erOutMagLowSensorBad = True

'		Pause
	Else
		erOutMagLowSensorBad = False
	EndIf
	
	If (outMagUpLim And outMagUpLimN = True) Then
		erOutMagUpSensorBad = True
'		Pause
	Else
		erOutMagUpSensorBad = False
	EndIf
	
	If erLaserScanner = True Then ' The laser scanner has lost comms
'		Pause
	EndIf
	
	If erUnknown = True Then
	'	Pause
	EndIf
	
	If HotStakeTempRdy = False Then
		erHeatStakeTemp = True
	Else
		erHeatStakeTemp = False
	EndIf
	
' In this section I set the error in the main routine and the lights and pausing are changed here	
'erPanelStatusUnknown = True
If EStopOn = True Or erLowPressure = True Or erHighPressure = True Or cbMonHeatStake = False Or cbMonInMag = False Or cbMonOutMag = False Or cbMonDebrisRmv = False Or cbMonSafety = False Or cbMonPAS24vdc = False Then
	stackLightRedCC = True
	If alarmMute = True Then ' Mute the alarm
		stackLightAlrmCC = False
	Else
		stackLightAlrmCC = True
	EndIf
Else
	stackLightRedCC = False
	stackLightAlrmCC = False
EndIf
	
If inMagInterlock = True Or outMagInt = True Or erInMagEmpty = True Or erOutMagFull = True Then ' If a magazine interlock is open then turn on the yelow light
	stackLightYelCC = True
Else
	stackLightYelCC = False
EndIf

If (stackLightRedCC Or stackLightYelCC) Then ' Turn off the green light if the red or yellow is on
	stackLightGrnCC = False
Else
	stackLightGrnCC = True
EndIf

If PauseOn = True Then
	mainCurrentState = StatePaused
EndIf
	
Loop

	errHandler:
		
		'Assign things of interest to var names
		ctrlrErrMsg$ = ErrMsg$(Err)
	 	ctrlrLineNumber = Erl
		ctrlrTaskNumber = Ert
	 	ctrlrErrAxisNumber = Era
	 	ctrlrErrorNum = Err
	 	
	 	' Print error for testing/troubleshooting
	 	Print "Error Message:", ctrlrErrMsg$
		Print "Error Line Number:", ctrlrLineNumber
		Print "Error Task Number:", ctrlrTaskNumber
		Print "Error AxisNumber:", ctrlrErrAxisNumber
		Print "Error Number:", ctrlrErrorNum
		
		Pause
	EResume

Fend
Function StateOfHealth()

	homePositionStatus = GetSOHStatus(1, HomePositionStatusBitNum, HomePositionStatusMask)
	motorOnStatus = GetSOHStatus(1, MotorOnStatusBitNum, MotorOnStatusMask)
	motorPowerStatus = GetSOHStatus(1, MotorPowerStatusBitNum, MotorPowerStatusMask)
	joint1Status = GetSOHStatus(1, Joint1StatusBitNum, Joint1StatusMask)
	joint2Status = GetSOHStatus(1, Joint2StatusBitNum, Joint2StatusMask)
	joint3Status = GetSOHStatus(1, Joint3StatusBitNum, Joint3StatusMask)
	joint4Status = GetSOHStatus(1, Joint4StatusBitNum, Joint4StatusMask)
	
	'For some reason my GetStatus function would not read address 0, so I kinda hacked my own function	
	eStopStatus = RShift(Stat(0) And EstopStatusMask, EstopStatusBitNum)
	errorStatus = RShift(Stat(0) And ErrorStatusMask, ErrorStatusBitNum)
	tasksRunningStatus = RShift(Stat(0) And TasksRunningMask, TasksRunningStatusBitNum)
	pauseStatus = RShift(Stat(0) And PauseStatusMask, PauseStatusBitNum)
	teachModeStatus = RShift(Stat(0) And TeachModeStatusMask, TeachModeStatusBitNum)
	safeGuardInput = RShift(Stat(0) And SafeGuardMask, SafeGuardBitNum)
	
' Print for troubleshooting	  
'	Print "Motor Status:", MotorOnStatus
'	Print "Motor Power Status:", MotorPowerStatus
'	Print "Joint 1 Status:", Joint1Status
'	Print "Tasks Running Status:", TasksRunningStatus
'	
'	Print "Estop Status is:", EstopStatus
'	Print "Error Status is:", ErrorStatus
'	Print "Tasks Running Status is:", TasksRunningStatus
'	Print "Pause Status is:", PauseStatus
'	Print "Teach Mode Status is:", TeachModeStatus
	
Fend
Function GetSOHStatus(address As Integer, bitnumber As Integer, bitmask As Integer) As Boolean
	
	GetSOHStatus = RShift(Stat(address) And bitmask, bitnumber)
	
Fend
Function ResetErrors()
	
'sets all errors to false when we start runing. We need this so the HMI does not show the errors from the last time is was shut down.
  erPanelFailedInspection = False; erFrontSafetyFrameOpen = False; erBackSafetyFrameOpen = False
  erLeftSafetyFrameOpen = False; erRightSafetyFrameOpen = False; erLowPressure = False
  erHighPressure = False; erPanelStatusUnknown = False; erWrongPanelHoles = False
  erWrongPanelDims = False; erWrongPanel = False; erWrongPanelInsert = False; erHmiDataAck = False
  erInMagEmpty = False; erInMagOpenInterlock = False; erOutMagCrowding = False; erPanelUndefined = False
  erInMagCrowding = False; erOutMagFull = False; erOutMagOpenInterlock = False; erBadPressureSensor = False
  erLaserScanner = False; erDCPower = False; erDCPowerHeatStake = False; erHeatStakeTemp = False
  erHeatStakeBreaker = False; erBowlFeederBreaker = False; erInMagBreaker = False ';erModbusPort;erModbusCommand,erModbusCommand
  erOutMagBreaker = False; erFlashBreaker = False; erDebrisRemovalBreaker = False
  erPnumaticsBreaker = False; erSafetySystemBreaker = False; erRC180 = False; erIllegalArmMove = False
  erUnknown = False; erEstop = False; erRecEntryMissing = False; erParamEntryMissing = False; erRobotNotAtHome = False
  RecEntryMissing = False; ParamEntryMissing = False; erHMICommunication = False; erFlashStation = False
  erInMagLowSensorBad = False; erInMagUpSensorBad = False; erOutMagLowSensorBad = False; erOutMagUpSensorBad = False
Fend


