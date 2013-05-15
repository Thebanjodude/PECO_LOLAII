#include "Globals.INC"

Function SystemMonitor()
	
OnErr GoTo errHandler ' Define where to go when a controller error occurs	

' Monitor System Pressures, voltages, interlocks, Hot Stake Machine, CBs, E-stop, and ctrlr errors

Do While True
	
	StateOfHealth()
	
	If inMagIntlock = True Then ' If an interlock gets tripped then halt the state machine
		
		Halt InMagControl
		erInMagOpenInterlock = True
		stackLightYelCC = True
		inMagCurrentState = StatePaused
		
		If MainCurrentState = StatePopPanel Then
			Pause ' if interlock open Pause only when in pop
		EndIf
		
	Else
		Resume InMagControl ' When the interlock is back into position resume where we left off
		erInMagOpenInterlock = False
		stackLightGrnCC = True
	EndIf
	
	If outMagInt = True Then ' If an interlock gets tripped then halt the state machine
		
		Halt OutMagControl
		erOutMagOpenInterlock = True
		stackLightYelCC = True
		outMagCurrentState = StatePaused
		
		If MainCurrentState = StatePushPanel Then
			Pause ' pause robot movement to avoid pinchpoint
		EndIf
	Else
	 	Resume OutMagControl ' When the interlock is back into position resume where we left off
	 	erOutMagOpenInterlock = False
		stackLightGrnCC = True
	EndIf
	
	If frontIntlock1 = True Then ' If an interlock gets tripped then halt the state machine
		erFrontSafetyFrameOpen = True
		stackLightYelCC = True
	Else
		stackLightGrnCC = True
	 	erFrontSafetyFrameOpen = False
	EndIf
	
	If frontIntlock2 = True Then ' If an interlock gets tripped then halt the state machine
		erFrontSafetyFrameOpen = True
		stackLightYelCC = True
	Else
		stackLightGrnCC = True
	 	erFrontSafetyFrameOpen = False
	EndIf
	
	If backIntlock1 = True Then ' If an interlock gets tripped then halt the state machine
		erBackSafetyFrameOpen = True
		stackLightYelCC = True
	Else
		stackLightGrnCC = True
	 	erBackSafetyFrameOpen = False
	EndIf
	
	If backIntlock2 = True Then ' If an interlock gets tripped then halt the state machine
		erBackSafetyFrameOpen = True
		stackLightYelCC = True
	Else
		stackLightGrnCC = True
	 	erBackSafetyFrameOpen = False
	EndIf
	
	If leftIntlock1 = True Then ' If an interlock gets tripped then halt the state machine
		erLeftSafetyFrameOpen = True
		stackLightYelCC = True
	Else
		stackLightGrnCC = True
	 	erLeftSafetyFrameOpen = False
	EndIf

	If leftIntlock2 = True Then ' If an interlock gets tripped then halt the state machine
		erLeftSafetyFrameOpen = True
		stackLightYelCC = True
	Else
		stackLightGrnCC = True
	 	erLeftSafetyFrameOpen = False
	EndIf
	
	If rightIntlock = True Then ' If an interlock gets tripped then halt the state machine
		erRightSafetyFrameOpen = True
		stackLightYelCC = True
	Else
		stackLightGrnCC = True
	 	erRightSafetyFrameOpen = False
	EndIf
	
	If airPressHigh = True Then
		erHighPressure = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		'Turn off main air supply to the machine! Do we even have one?
'		Pause
	Else
		stackLightGrnCC = True
		erHighPressure = False
	EndIf
	
	If airPressLow = True Then
		erLowPressure = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		Pause
	Else
		stackLightGrnCC = True
		stackLightAlrmCC = False
	EndIf
	
	If cbMonHeatStake = True Then
		erHeatStakeBreaker = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		Pause
	Else
		stackLightGrnCC = True
		erHeatStakeBreaker = False
	EndIf

	If cbMonInMag = True Then
		erInMagBreaker = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		Pause
	Else
		stackLightGrnCC = True
		erInMagBreaker = False
	EndIf
	
	If cbMonOutMag = True Then
		erOutMagBreaker = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		Pause
	Else
		stackLightGrnCC = True
		erOutMagBreaker = False
	EndIf
	
	If cbMonDebrisRmv = True Then
		erDebrisRemovalBreaker = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		Pause
	Else
		stackLightGrnCC = True
		erDebrisRemovalBreaker = False
	EndIf
	
	If cbMonSafety = True Then
		stackLightRedCC = True
		stackLightAlrmCC = True
		erSafetySystemBreaker = True
'		pause
	Else
		stackLightGrnCC = True
		erSafetySystemBreaker = False
	EndIf

	If cbMonPAS24vdc = True Then
		stackLightRedCC = True
		stackLightAlrmCC = True
		erDCPowerHeatStake = True
'		Pause
	Else
		stackLightGrnCC = True
		erDCPowerHeatStake = False
	EndIf
	
	'Heat stake temp checking 
	If HotStakeTempRdy = False Then
'		Pause
	EndIf
	
	If EStopOn = True Then
		erEstop = True
		stackLightRedCC = True
		stackLightAlrmCC = True
	Else
		stackLightGrnCC = True
		erEstop = False
	EndIf
	
	'If the in/out magazine sensor diff signals are the same then we know there is a problem	
	If inMagLowLim = inMagLowLimN Then
		erInMagLowSensorBad = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		pause
	Else
		stackLightGrnCC = True
		erInMagLowSensorBad = False
	EndIf
	
	If inMagUpLim = inMagUpLimN Then
		erInMagUpSensorBad = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		pause		
	Else
		stackLightGrnCC = True
		erInMagUpSensorBad = False
	EndIf
	
	If outMagLowLim = outMagLowLimN Then
		erOutMagLowSensorBad = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		pause		
	Else
		stackLightGrnCC = True
		erOutMagLowSensorBad = False
	EndIf
	
	If outMagUpLim = outMagUpLimN Then
		erOutMagUpSensorBad = True
		stackLightRedCC = True
		stackLightAlrmCC = True
'		pause
	Else
		stackLightGrnCC = True
		erOutMagUpSensorBad = False
	EndIf
	
	If Sw(MaintanceMode) = True Then
		maintMode = True
	Else
		maintMode = False
	EndIf
	
	If PauseOn = True And pauseFlag = False Then
		' Change this from P50 to a lable so it doesn't get overwritten
		P50 = Here ' save the location where it paused
		Print P50
		pauseFlag = True
	ElseIf PauseOn = False And pauseFlag = True Then
		Real distx, disty, distz, distance
		pauseFlag = False
		distx = Abs(CX(P50) - CX(Here))
		disty = Abs(CY(P50) - CY(Here))
		distz = Abs(CZ(P50) - CZ(Here))
		distance = Sqr(distx * distx + disty * disty) ' How the hell do you square numbers?
'TODO: Parameterize these?
		If distance > 25 Or distz > 15 Then
			Print "panel fails"
			erIllegalArmMove = True
			stackLightRedCC = True
			'is there a way to have the opperator catch the panel?
			Quit All
		Else
			stackLightRedCC = True
			erIllegalArmMove = False
		EndIf
				
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



