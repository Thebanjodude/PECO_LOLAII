#include "Globals.INC"

Function SystemMonitor()
	
OnErr GoTo errHandler ' Define where to go when a controller error occurs	

' Monitor System Pressures, voltages, interlocks, Hot Stake Machine, CBs, E-stop, and ctrlr errors

Do While True
	
	StateOfHealth()
	
	If inMagInterlock = True Then ' If an interlock gets tripped then halt the state machine
		
		Halt InMagControl
		erInMagOpenInterlock = True
		inMagCurrentState = StatePaused
		
		If mainCurrentState = StatePopPanel Then
'			Pause ' if interlock open Pause only when in pop state
		EndIf
		
	Else
		Resume InMagControl ' When the interlock is back into position resume where we left off
		erInMagOpenInterlock = False
	EndIf
	
	If outMagInt = True Then ' If an interlock gets tripped then halt the state machine
		
		Halt OutMagControl
		erOutMagOpenInterlock = True
		outMagCurrentState = StatePaused
		
		If mainCurrentState = StatePushPanel Then
'			Pause ' pause robot movement to avoid pinchpoint
		EndIf
	Else
	 	Resume OutMagControl ' When the interlock is back into position resume where we left off
	 	erOutMagOpenInterlock = False
	EndIf
	
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
		stackLightRedCC = True
		stackLightAlrmCC = True
	Else
		erEstop = False
	EndIf
	
	'If the in/out magazine sensor diff signals are the same then we know there is a problem	
	If (inMagLowLim And inMagLowLimN = True) Then
		erInMagLowSensorBad = True
		stackLightRedCC = True
'		Pause
	Else
		erInMagLowSensorBad = False
	EndIf
	
	If (inMagUpLim And inMagUpLimN = True) Then
		erInMagUpSensorBad = True
		stackLightRedCC = True
'		Pause
	Else
		erInMagUpSensorBad = False
	EndIf
	
	If (outMagLowLim And outMagLowLimN = True) Then
		erOutMagLowSensorBad = True
		stackLightRedCC = True
'		Pause
	Else
		erOutMagLowSensorBad = False
	EndIf
	
	If (outMagUpLim And outMagUpLimN = True) Then
		erOutMagUpSensorBad = True
		stackLightRedCC = True
'		Pause
	Else
		erOutMagUpSensorBad = False
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
			stackLightRedCC = False
			erIllegalArmMove = False
		EndIf
				
	EndIf
	
If airPressHigh = True Or airPressLow = True Or (airPressLow And airPressHigh) Or cbMonHeatStake = False Or cbMonInMag = False Or cbMonOutMag = False Or cbMonDebrisRmv = False Or cbMonSafety = False Or cbMonPAS24vdc = False Or EStopOn = True Or (inMagLowLim And inMagLowLimN = True) Or (inMagUpLim And inMagUpLimN = True) Or (outMagLowLim And outMagLowLimN = True) Or (outMagUpLim And outMagUpLimN = True) Then
	stackLightRedCC = True
	stackLightAlrmCC = True
EndIf
	
If inMagInterlock = True Or outMagInt = True Then
	stackLightYelCC = True
EndIf

If (stackLightRedCC Or stackLightYelCC) Then
	stackLightGrnCC = False
Else
	stackLightGrnCC = True
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



