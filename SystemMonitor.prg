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
		InMagInterlockFlag = True ' Set flag
'		inMagCurrentState = StatePaused
	ElseIf inMagIntLockAck = True And InMagInterlockFlag = True Then
		Resume InMagControl ' When the interlock is back into position resume where we left off
		erInMagOpenInterlock = False
		InMagInterlockFlag = False ' Reset flag
	EndIf
	
	If outMagInt = True Then ' If an interlock gets tripped then halt the state machine
		Halt OutMagControl
		erOutMagOpenInterlock = True
		OutMagInterlockFlag = True ' Set flag
	ElseIf outMagIntLockAck = True And OutMagInterlockFlag = True Then
	 	Resume OutMagControl ' When the interlock is back into position resume where we left off
	 	erOutMagOpenInterlock = False
	 	OutMagInterlockFlag = False ' Reset flag
	EndIf
	
	If frontInterlock = True Then ' If an interlock gets tripped then halt the state machine
		SystemPause()
		erFrontSafetyFrameOpen = True
		frontInterlockFlag = True ' Set flag
	ElseIf frontInterlockACK = True And frontInterlockFlag = True Then
	 	SystemUnPause()
	 	erFrontSafetyFrameOpen = False
	 	frontInterlockFlag = False ' Reset flag
	EndIf
	
	If backInterlock = True Then ' If an interlock gets tripped then halt the state machine
		SystemPause()
		erBackSafetyFrameOpen = True
		backInterlockFlag = True ' Set flag
	ElseIf backInterlockACK = True And backInterlockFlag = True Then
	 	SystemUnPause()
	 	erBackSafetyFrameOpen = False
	 	backInterlockFlag = False ' Reset flag
	EndIf
	
	If leftInterlock = True Then ' If an interlock gets tripped then halt the state machine
		SystemPause()
		erLeftSafetyFrameOpen = True
		LeftInterlockFlag = True ' Set flag
	ElseIf leftInterlockACK = True And LeftInterlockFlag = True Then
	 	SystemUnPause()
	 	erLeftSafetyFrameOpen = False
	 	LeftInterlockFlag = False ' Reset flag
	EndIf
	
	If rightInterlock = True Then ' If an interlock gets tripped then halt the state machine
		SystemPause()
		erRightSafetyFrameOpen = True
		RightInterlockFlag = True ' Set flag
	ElseIf rightInterlockACK = True And RightInterlockFlag = True Then
	 	SystemUnPause()
	 	erRightSafetyFrameOpen = False
	 	RightInterlockFlag = False ' Reset flag
	EndIf
	
	If airPressHigh = True Then
		SystemPause()
		erHighPressure = True
		airPressHighFlag = True
	ElseIf airPressHigh = False And airPressHighFlag = True Then
		SystemUnPause()
		erHighPressure = False
		airPressHighFlag = False
	EndIf
	
	If airPressLow = True Then
		SystemPause()
		erLowPressure = True
		airPressLowFlag = True
	ElseIf airPressLow = False And airPressLowFlag = True Then
		SystemUnPause()
		erLowPressure = False
	EndIf
	
	If cbMonHeatStake = True Then
		SystemPause()
		erHeatStakeBreaker = True
		cbMonHeatStakeFlag = True
	ElseIf cbMonHeatStake = False And cbMonHeatStakeFlag = True Then
		SystemUnPause()
		erHeatStakeBreaker = False
		cbMonHeatStakeFlag = False
	EndIf
	
	If cbMonBowlFeder = True Then
		SystemPause()
		erBowlFeederBreaker = True
		cbMonBowlFederFlag = True
	ElseIf cbMonBowlFeder = False And cbMonBowlFederFlag = True Then
		SystemUnPause()
		erBowlFeederBreaker = False
		cbMonBowlFederFlag = False
	EndIf
	
	If cbMonInMag = True Then
		SystemPause()
		erInMagBreaker = True
		cbMonInMagFlag = True
	ElseIf cbMonInMag = False And cbMonInMagFlag = True Then
		SystemUnPause()
		erInMagBreaker = False
		cbMonInMagFlag = False
	EndIf
	
	If cbMonOutMag = True Then
		SystemPause()
		erOutMagBreaker = True
		cbMonOutMagFlag = True
	ElseIf cbMonOutMag = False And cbMonOutMagFlag = True Then
		SystemUnPause()
		erOutMagBreaker = False
		cbMonOutMagFlag = False
	EndIf
	
	If cbMonFlashRmv = True Then
		SystemPause()
		erFlashBreaker = True
		cbMonFlashRmvFlag = True
	ElseIf cbMonFlashRmv = False And cbMonFlashRmvFlag = True Then
		SystemUnPause()
		erFlashBreaker = False
		cbMonFlashRmvFlag = False
	EndIf
	
	If cbMonDebrisRmv = True Then
		SystemPause()
		erDebrisRemovalBreaker = True
		cbMonDebrisRmvFlag = True
	ElseIf cbMonDebrisRmv = False And cbMonDebrisRmvFlag = True Then
		SystemUnPause()
		erDebrisRemovalBreaker = False
		cbMonDebrisRmvFlag = False
	EndIf
	
	If cbMonSafety = True Then
		SystemPause()
		erSafetySystemBreaker = True
		cbMonSafetyFlag = True
	ElseIf cbMonSafety = False And cbMonSafetyFlag = True Then
		SystemUnPause()
		erSafetySystemBreaker = False
		cbMonSafetyFlag = False
	EndIf
	
	If cbMonPnumatic = True Then
		SystemPause()
		erPnumaticsBreaker = True
		cbMonPnumaticFlag = True
	ElseIf cbMonPnumatic = False And cbMonPnumaticFlag = True Then
		SystemUnPause()
		erPnumaticsBreaker = False
		cbMonPnumaticFlag = False
	EndIf
	
	If dcPwrOk = True Then
		SystemPause()
		erDCPower = True
		dcPwrOkFlag = True
	ElseIf dcPwrOk = False And dcPwrOkFlag = True Then
		SystemUnPause()
		erDCPower = False
		dcPwrOkFlag = False
	EndIf
	
	If cbMonPAS24vdc = True Then
		SystemPause()
		erDCPowerHeatStake = True
		cbMonPAS24vdcFlag = True
	ElseIf cbMonPAS24vdc = False And cbMonPAS24vdcFlag = True Then
		SystemUnPause()
		erDCPowerHeatStake = False
		cbMonPAS24vdc = False
	EndIf
	
	'Heat stake temp checking 
		If 1.05 * recTemp <= hsProbeTemp <= .95 * recTemp Then 'temp must be within 5%
			erHeatStakeTemp = False
		Else
			erHeatStakeTemp = True 'throw error because we are out of tolerance
		EndIf
	
	'Global Pause Initiated from HMI
	If jobPause = True Then
		SystemPause()
		jobPauseFlag = True 'Set Flag	
	ElseIf jobResume = True Then ' Pick up exactly where we left off
		SystemUnPause()
		jobPauseFlag = False ' Reset flag	
	EndIf
	
	If jobStop = True Then
	
	EndIf
	
	If safeGuardInput = True Then
		safeGuardInputFlag = True
	ElseIf safeGuardInput = False And safeGuardInputFlag = True Then
		Resume All
		safeGuardInputFlag = False
	EndIf

	If EStopOn = True Then
		erEstop = True
	Else
		erEstop = False
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
		
		SystemPause()
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
	
	'For some reason my GetStatus function would not read address 0, so I kinda hacked it	
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


