
'System Monitor Vars
Global Boolean cbMonHeatStake, cbMonInMag, cbMonOutMag, cbMonDebrisRmv, cbMonSafety, cbMonPAS24vdc
Global Boolean stackLightRed, stackLightYel, stackLightGrn, stackLightAlrm
Global Boolean stackLightRedCC, stackLightYelCC, stackLightGrnCC, stackLightAlrmCC
Global Boolean airPressHigh, airPressLow
Global Boolean backIntlock1, frontIntlock1, leftIntlock1, rightIntlock
Global Boolean backIntlock2, frontIntlock2, leftIntlock2
Global Boolean heartBeat, dc24vOK

'Error Vars
Global Boolean erPanelFailedInspection, erFrontSafetyFrameOpen, erBackSafetyFrameOpen
Global Boolean erLeftSafetyFrameOpen, erRightSafetyFrameOpen, erLowPressure
Global Boolean erHighPressure, erPanelStatusUnknown, erWrongPanelHoles
Global Boolean erWrongPanelDims, erWrongPanel, erWrongPanelInsert, erHmiDataAck
Global Boolean erInMagEmpty, erInMagOpenInterlock, erOutMagCrowding, erPanelUndefined
Global Boolean erInMagCrowding, erOutMagFull, erOutMagOpenInterlock, erBadPressureSensor
Global Boolean erLaserScanner, erDCPower, erDCPowerHeatStake, erHeatStakeTemp
Global Boolean erHeatStakeBreaker, erBowlFeederBreaker, erInMagBreaker
Global Boolean erOutMagBreaker, erFlashBreaker, erDebrisRemovalBreaker
Global Boolean erPnumaticsBreaker, erSafetySystemBreaker, erRC180, erIllegalArmMove
Global Boolean erUnknown, erEstop, erRecEntryMissing, erParamEntryMissing, erRobotNotAtHome
Global Boolean RecEntryMissing, ParamEntryMissing, erHMICommunication, erFlashStation
Global Boolean erInMagLowSensorBad, erInMagUpSensorBad, erOutMagLowSensorBad, erOutMagUpSensorBad
Global Boolean erModbusPort, erModbusCommand, erModbusTimeout

'State of Health Global Vars
Global String ctrlrErrMsg$
Global Integer ctrlrLineNumber, ctrlrTaskNumber, ctrlrErrAxisNumber, ctrlrErrorNum
Global Boolean motorOnStatus, motorPowerStatus, eStopStatus, errorStatus
Global Boolean tasksRunningStatus, pauseStatus, teachModeStatus, homePositionStatus
Global Boolean joint1Status, joint2Status, joint3Status, joint4Status, safeGuardInput



