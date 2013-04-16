#include "Globals.INC"

'This comment is just to test that git is working!

Function SystemMonitor()
	
OnErr GoTo errHandler ' Define where to go when a controller error occurs	
	
Boolean InMagInterlockFlag, OutMagInterlockFlag, ReturnFromEstopFlag, safeGuardInputFlag
Boolean frontInterlockFlag, backInterlockFlag, LeftInterlockFlag, RightInterlockFlag
Boolean airPressHighFlag, cbMonHeatStakeFlag, cbMonBowlFederFlag, airPressLowFlag
Boolean cbMonInMagFlag, cbMonOutMagFlag, cbMonPAS24vdcFlag, dcPwrOkFlag
Boolean cbMonFlashRmvFlag, cbMonSafetyFlag, cbMonDebrisRmvFlag, cbMonPnumaticFlag
 	
' Monitor System Pressures, voltages, interlocks, Hot Stake Machine, CBs, E-stop, and ctrlr errors

Do While True
	
	StateOfHealth()

	If inMagInterlock = True Then ' If an interlock gets tripped then halt the state machine
		Halt InMagControl
		erInMagOpenInterlock = True
		stackLightYelCC = True
		InMagInterlockFlag = True ' Set flag
'		inMagCurrentState = StatePaused
	ElseIf inMagIntLockAck = True And InMagInterlockFlag = True Then
		Resume InMagControl ' When the interlock is back into position resume where we left off
		erInMagOpenInterlock = False
		stackLightYelCC = False
		InMagInterlockFlag = False ' Reset flag
	EndIf
	
	If outMagInt = True Then ' If an interlock gets tripped then halt the state machine
		Halt OutMagControl
		erOutMagOpenInterlock = True
		stackLightYelCC = True
		OutMagInterlockFlag = True ' Set flag
	ElseIf outMagIntLockAck = True And OutMagInterlockFlag = True Then
	 	Resume OutMagControl ' When the interlock is back into position resume where we left off
	 	erOutMagOpenInterlock = False
	 	stackLightYelCC = False
	 	OutMagInterlockFlag = False ' Reset flag
	EndIf
	
	If frontInterlock = True Then ' If an interlock gets tripped then halt the state machine
		erFrontSafetyFrameOpen = True
		stackLightYelCC = True
		frontInterlockFlag = True ' Set flag
		Pause
	ElseIf frontInterlockACK = True And frontInterlockFlag = True Then
	 	erFrontSafetyFrameOpen = False
		stackLightYelCC = False
	 	frontInterlockFlag = False ' Reset flag
	EndIf
	
	If backInterlock = True Then ' If an interlock gets tripped then halt the state machine
		erBackSafetyFrameOpen = True
		stackLightYelCC = True
		backInterlockFlag = True ' Set flag
		Pause
	ElseIf backInterlockACK = True And backInterlockFlag = True Then
	 	erBackSafetyFrameOpen = False
		stackLightYelCC = False
	 	backInterlockFlag = False ' Reset flag
	EndIf
	
	If leftInterlock = True Then ' If an interlock gets tripped then halt the state machine
		erLeftSafetyFrameOpen = True
		stackLightYelCC = True
		LeftInterlockFlag = True ' Set flag
		Pause
	ElseIf leftInterlockACK = True And LeftInterlockFlag = True Then
	 	erLeftSafetyFrameOpen = False
		stackLightYelCC = False
	 	LeftInterlockFlag = False ' Reset flag
	EndIf
	
	If rightInterlock = True Then ' If an interlock gets tripped then halt the state machine
		erRightSafetyFrameOpen = True
		stackLightYelCC = True
		RightInterlockFlag = True ' Set flag
		Pause
	ElseIf rightInterlockACK = True And RightInterlockFlag = True Then
	 	erRightSafetyFrameOpen = False
		stackLightYelCC = False
	 	RightInterlockFlag = False ' Reset flag
	EndIf
	
	If airPressHigh = True Then
		erHighPressure = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		airPressHighFlag = True
		Pause
	ElseIf airPressHigh = False And airPressHighFlag = True Then
		erHighPressure = False
		airPressHighFlag = False
	EndIf
	
	If airPressLow = True Then
		erLowPressure = True
		airPressLowFlag = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause
	ElseIf airPressLow = False And airPressLowFlag = True Then
		erLowPressure = False
		stackLightRedCC = False
		stackLightAlrmCC = False
	EndIf
	
	If cbMonHeatStake = True Then
		erHeatStakeBreaker = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		cbMonHeatStakeFlag = True
		Pause
	ElseIf cbMonHeatStake = False And cbMonHeatStakeFlag = True Then
		erHeatStakeBreaker = False
		stackLightRedCC = False
		stackLightAlrmCC = False
		cbMonHeatStakeFlag = False
	EndIf
	
	If cbMonBowlFeder = True Then
		erBowlFeederBreaker = True
		cbMonBowlFederFlag = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause
	ElseIf cbMonBowlFeder = False And cbMonBowlFederFlag = True Then
		erBowlFeederBreaker = False
		cbMonBowlFederFlag = False
		stackLightRedCC = False
		stackLightAlrmCC = False
	EndIf
	
	If cbMonInMag = True Then
		erInMagBreaker = True
		cbMonInMagFlag = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause
	ElseIf cbMonInMag = False And cbMonInMagFlag = True Then
		erInMagBreaker = False
		stackLightRedCC = False
		stackLightAlrmCC = False
		cbMonInMagFlag = False
	EndIf
	
	If cbMonOutMag = True Then
		erOutMagBreaker = True
		cbMonOutMagFlag = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause
	ElseIf cbMonOutMag = False And cbMonOutMagFlag = True Then
		erOutMagBreaker = False
		cbMonOutMagFlag = False
		stackLightRedCC = False
		stackLightAlrmCC = False
	EndIf
	
	If cbMonFlashRmv = True Then
		stackLightRedCC = True
		stackLightAlrmCC = True
		erFlashBreaker = True
		cbMonFlashRmvFlag = True
		Pause
	ElseIf cbMonFlashRmv = False And cbMonFlashRmvFlag = True Then
		stackLightRedCC = False
		stackLightAlrmCC = False
		erFlashBreaker = False
		cbMonFlashRmvFlag = False
	EndIf
	
	If cbMonDebrisRmv = True Then
		erDebrisRemovalBreaker = True
		cbMonDebrisRmvFlag = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause
	ElseIf cbMonDebrisRmv = False And cbMonDebrisRmvFlag = True Then
		stackLightRedCC = False
		stackLightAlrmCC = False
		erDebrisRemovalBreaker = False
		cbMonDebrisRmvFlag = False
	EndIf
	
	If cbMonSafety = True Then
		stackLightRedCC = True
		stackLightAlrmCC = True
		erSafetySystemBreaker = True
		cbMonSafetyFlag = True
	ElseIf cbMonSafety = False And cbMonSafetyFlag = True Then
		stackLightRedCC = False
		stackLightAlrmCC = False
		erSafetySystemBreaker = False
		cbMonSafetyFlag = False
	EndIf
	
	If cbMonPnumatic = True Then
		stackLightRedCC = True
		stackLightAlrmCC = True
		erPnumaticsBreaker = True
		cbMonPnumaticFlag = True
	ElseIf cbMonPnumatic = False And cbMonPnumaticFlag = True Then
		stackLightRedCC = False
		stackLightAlrmCC = False
		erPnumaticsBreaker = False
		cbMonPnumaticFlag = False
	EndIf
	
	If dcPwrOk = True Then
		stackLightRedCC = True
		stackLightAlrmCC = True
		erDCPower = True
		dcPwrOkFlag = True
		Pause
	ElseIf dcPwrOk = False And dcPwrOkFlag = True Then
		stackLightRedCC = False
		stackLightAlrmCC = False
		erDCPower = False
		dcPwrOkFlag = False
	EndIf
	
	If cbMonPAS24vdc = True Then
		stackLightRedCC = True
		stackLightAlrmCC = True
		erDCPowerHeatStake = True
		cbMonPAS24vdcFlag = True
		Pause
	ElseIf cbMonPAS24vdc = False And cbMonPAS24vdcFlag = True Then
		stackLightRedCC = False
		stackLightAlrmCC = False
		erDCPowerHeatStake = False
		cbMonPAS24vdc = False
	EndIf
	
	'Heat stake temp checking 
	If HotStakeTempRdy = False Then
		Pause
	EndIf
	
	If EStopOn = True Then
		erEstop = True
		stackLightRedCC = True
		stackLightAlrmCC = True
	Else
		erEstop = False
		stackLightRedCC = False
		stackLightAlrmCC = False
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
Function SystemPause() ' We might just be able to use the pause command instead of this function
	Halt main
	Halt InMagControl
	Halt OutMagControl
	SystemStatus = SystemPaused
Fend
Function SystemUnPause() ' This will become obs if systempause is not needed
    Resume main
	Resume InMagControl
	Resume OutMagControl
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


