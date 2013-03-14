'Function UTSystemMonitor()
'
'Halt IOTable
'
'Do While True
'
'Wait 1
'Print TaskState(1)
'
'cbMonHeatStake = True
'If TaskState(main) = 3 And erHeatStakeBreaker = True Then
'	Print "Halting Test Passed"
'Else
'	Print "Halting Test Failed"
'EndIf
'
'Wait 1
'
'cbMonHeatStake = False
'If TaskState(main) = 1 And erHeatStakeBreaker = False Then
'	Print "Resuming test Passed"
'Else
'	Print "Resuming test Failed"
'EndIf
'Loop
'cbMonBowlFeder = True
'cbMonInMag = True
'cbMonOutMag = True
'cbMonFlashRmv = True
'cbMonDebrisRmv = True
'cbMonPnumatic = True
'cbMonSafety = True
'cbMonPAS24vdc = True

'Fend

'Function InterlockUnitTest() 'Interlock As Boolean, erInterlock As Boolean, TaskNumber As Integer) As Boolean
'	Integer state
'	Boolean TestHalting, TestResuming
'	
''	Xqt 2, IOTable
'	Xqt 3, SystemMonitor
'	Xqt 6, InMagControl
'	inMagInterlock = True 'Stimulus
''	Halt InMagControl
'	
'	state = TaskState(6)
'	Print state
'	
'	If state = 3 And erInMagOpenInterlock = True Then
'		TestHalting = True
'	Else
'		TestHalting = False
'		Print "Halting Failed"
'	EndIf
'	
'	inMagInterlock = False 'Stimulus
'	
'	state = TaskState(6)
'	Print state
'	
'	If state = 1 And erInMagOpenInterlock = False Then
'		TestResuming = True
'	Else
'		TestResuming = False
'		Print "Resuming Failed"
'	EndIf
'	
'	If TestHalting = True And TestResuming = True Then
'		InterlockUnitTest = True 'Pass
'		Print "Interlock Test Passed"
'	Else
'		InterlockUnitTest = False 'Fail
'		Print "Interlock Test failed"
'	EndIf
'
'Fend

