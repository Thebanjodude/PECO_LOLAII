'Function JointTorqueTest
'	
'	Motor On
'	Power High
'	Speed 100
'	Accel 100, 100
'	
'	Real Tlow, Thigh, TAvglow, TAvgHigh
'	Integer k
'	
'	Tlow = 100
'	Thigh = 0
'	TAvglow = 100
'	TAvgHigh = 0
'	
'	Move P25 'bottom
'	Wait .25
'	' This test is to determine if we can sense when the robot picks up a panel
'		
'	For k = 0 To 15
'		
'        ATCLR
'        PTCLR
'		
'		Move P26 'top
'		Wait .25
'		
'		Print " The Average torque on the Z axis is ", ATRQ(3) 'ditto
'		Print " The Peak torque on the Z axis is ", PTRQ(3) 'ditto
'		
'		If Tlow > PTRQ(3) Then
'			Tlow = PTRQ(3)
'		EndIf
'		
'		If Thigh < PTRQ(3) Then
'			Thigh = PTRQ(3)
'		EndIf
'		
'		If TAvglow > ATRQ(3) Then
'			TAvglow = ATRQ(3)
'		EndIf
'		
'		If TAvgHigh < ATRQ(3) Then
'			TAvgHigh = ATRQ(3)
'		EndIf
'		
'		Print k
'		
'		Move P25 'bottom
'		Wait .25
'		
'		Next
'	Print " Tlow is: ", Tlow
'	Print " Thigh is: ", Thigh
'	Print " Tavglow is: ", TAvglow
'	Print " Tavghigh is: ", TAvgHigh
'	
'	SFree
'	Motor Off
'
'Fend


''''Old Code
'	Do While Theta1 < 359
'		Scancenter = ScanCenter -Y(130 * Sin(DegToRad(Theta1))) ' +U(DegToRad(Theta1))
'		Go ScanCenter
'		Theta1 = Theta1 + 4
'	Loop

'-Y(Abs(b * Cos(DegToRad(Theta1)) + a * Sin(DegToRad(Theta1)))
' Do While True
' 	
'	Go RM0
'	Wait .2
'	Go RM1
'Loop

'	ScanCenter = ScanCenter :U(Theta1)
'	Go ScanCenter

'Function LoadPanelRecipe(PanelPartNumber As Integer)
'' are we going to populate the recipe values manually or autonomously?
'	
'#define SS 0
'#define AL 1
'
'#define PanelX 1
'#define PanelY 2
''ect
'
' Integer NumOfHoles 'Global
' Integer InsertType 'Global
''ect
'
'	Select PanelPartNumber
'		Case PanelX
'			NumOfHoles = 16
'			InsertType = SS
'			'ect
'		Case PanelY
'			NumOfHoles = 11
'			InsertType = AL
'			'ect
'		Default ' We should NEVER get here...
''			Error ER_UDE ' Panel type selected does not exist
'	Send
'	
'Fend

'Xqt throwerror, NoPause 'Normal 'NoPause, NoEmgAbort

'Function IncrementArrayOld
'	
'' add in some smarts here...count how many holes we have inserted...somthing	
'
'	r = PanelArray(IndexR, 0)
'	Theta = PanelArray(IndexTheta, 1)
'	
'	If PanelArray(IndexSkip, 2) <> 0 Then ' when zero, don't populate the hole
'		IndexR = IndexR + 1 'skip to the next r 
'		IndexTheta = IndexTheta + 1 'skip to the next Theta 
'		IndexSkip = IndexSkip + 1
'		
'		Print "skipped hole"
'		Print IndexR
'		r = PanelArray(IndexR, 0) ' reassign r and theta
'		Theta = PanelArray(IndexTheta, 1)
'	EndIf
'	
'	IndexR = IndexR + 1
'	IndexTheta = IndexTheta + 1
'	IndexSkip = IndexSkip + 1
'	
'Fend

' Combine the three functions below into one! They are all exactly the same, keep them for historical reference
'Function SetOutput(OutputToSet As Boolean, HMI As Boolean, Force As Boolean) As Boolean
'		
'	Boolean OutputValue
'	
'	OutputValue = OutputToSet 'set value to what the control code wants it to be
'	
'	If Force = True Then ' Check If we want to force it 
'		OutputValue = HMI ' take forced value from HMI, overwrite control code
'	EndIf
'	
'	SetOutput = OutputValue
'	
'Fend
'Function SetInput(InputToSet As Boolean, HMI As Boolean, Force As Boolean) As Boolean
'		
'	Boolean InputValue
'	
'	InputValue = InputToSet 'set value to what the control code wants it to be
'	
'	If Force = True Then ' Check If we want to force it 
'		InputValue = HMI ' take forced value from HMI, overwrite control code
'	EndIf
'	
'	SetInput = InputValue
'	
'Fend
'Function SetVar(VarToSet As Boolean, HMI As Boolean, Force As Boolean) As Boolean
'		
'	Boolean VarValue
'	VarValue = VarToSet 'set value to what the control code wants it to be
'	
'	If Force = True Then ' Check If we want to force it 
'		VarValue = HMI ' take forced value from HMI, overwrite control code
'	EndIf
'	
'	SetVar = VarValue
'	
'Fend

'Function FlashRemoval ' Idont think we need a state machine for flash removal
'
'#define StateIdle 0
'#define StateMoveToHole 1
'#define StateRemovingFlash 2
'
'Integer NextState
'Integer CurrentState
'
'CurrentState = StateIdle  ' On start up the State shall be in Idle
'
'Do While True
'				
'	Select CurrentState
'		Case StateIdle
'		
'			Do Until FlashEnable = True ' Don't leave state unless panel is in flash removal station
'				Wait 2 ' Don't Spam Run Window
'			Loop
'
'			FlashEnable = False 'Clear Flag
'			NextState = StateMoveToHole ' Determine which state to go to next
'
'		Case StateMoveToHole
'			
'			Do Until MemSw(FlashPanelReady) = True 'Don't Leave state until Main program give is permission via an enable bit
'				Print "Waiting for Panel Ready Signal"
'				Wait 2 ' Don't Spam Run Window
'			Loop
'			
'			NextState = StateRemovingFlash
'			Print "Robot Moving Panel to next hole" ' This is where we will actually program it in
'									
'			MemOff (StateFlashMove) ' Turn Bit OFF in I/O Monitor	
'			MemOff (FlashPanelReady) ' Clear Flag
'			MemOn (FlashGo) ' Tell Flash Tool to stroke
'			
'			
'		Case StateRemovingFlash
'			Print "Current State is Removing Flash"
'			MemOn (StateFlashRemove) ' Turn Bit ON in I/O Monitor (Keep track of states visually)
'			
'			Do Until MemSw(FlashFinished) = True
'				Print "Removing Flash"
'				Wait 2 ' Don't Spam Run Window
'			Loop
'			
'			If FlashLastHole = True Then
'				NextState = StateIdle
'			Else
'				NextState = StateMoveToHole
'			EndIf
'			
'			MemOff (StateFlashRemove) 'Turn Bit OFF in I/O Monitor
'			MemOff (FlashFinished) 'Clear Flag
'			MemOff (FlashGo) ' Clear Flag
'			
'		Default
'			Print "Current State is Null" ' We should NEVER get here...
'			Error ER_UDE
'	Send
'	
'CurrentState = NextState 'Set next state to current state after we break from case statment
'
'Loop
'
'Fend

'Function PanelArrayPopulate
'	
'	Integer i, j
'		
'	Print "How Many Holes In your Panel?"
'	Input recNumberOfHoles
'	
'	Redim PanelArray(recNumberOfHoles, recNumberOfHoles, recNumberOfHoles)
'		
'	For i = 0 To (recNumberOfHoles - 1)
'		Print "Input all radii in mm"
'		Input r
'		PanelArray(i, 0) = r
'  	Next i
'  	
'  	For j = 0 To (recNumberOfHoles - 1)
'  		Print "Input all Thetas in degrees"
'		Input Theta
'  		PanelArray(j, 1) = Theta
'  	Next
'  	
'  	PrintPanelArray()
'  	Wait 4
'  	GoToHoles()
'
'Fend
' array for little golden test panel, wooden
'	recNumberOfHoles = 8 ' Build a panel definition manually
'	PanelArray(0, 0) = 99.72
'	PanelArray(1, 0) = 132.28
'	PanelArray(2, 0) = 132.28
'	PanelArray(3, 0) = 99.72
'	PanelArray(4, 0) = 99.72
'	PanelArray(5, 0) = 132.28
'	PanelArray(6, 0) = 132.28
'	PanelArray(7, 0) = 99.72
'	
'	PanelArray(0, 1) = 60
'	PanelArray(1, 1) = 80
'	PanelArray(2, 1) = 100
'	PanelArray(3, 1) = 120
'	PanelArray(4, 1) = 240
'	PanelArray(5, 1) = 260
'	PanelArray(6, 1) = 280
'	PanelArray(7, 1) = 300
'	
'	PanelArray(0, 2) = 0 '1
'	PanelArray(1, 2) = 0
'	PanelArray(2, 2) = 0 '1
'	PanelArray(3, 2) = 0
'	PanelArray(4, 2) = 0 '1
'	PanelArray(5, 2) = 0
'	PanelArray(6, 2) = 0 '1
'	PanelArray(7, 2) = 0

'			HotStakeCenter = HotStakeCenter :U(0) ' Make Theta Offset it is back to zero each time through
'			If Theta > 90 Then
'		 		HotStakeCenter = HotStakeCenter :U(180)
'				Theta = Theta - 180 ' I dont remember what this was far...:(
'	'			Move HotStakeMove
' 			EndIf
' edge following algoritm I wrote
'#define Offset 5 ' This is just a guess, 10mm between two triggers
'	
'Select True
'	Case Sw(ScanTooClose) = On
'		Move ScanCenter +Y(Offset)
'	Case Sw(ScanTooFar) = On
'		Move ScanCenter -Y(Offset)
'Send
'
'Fend
'

'Do While Theta1 < 360 'Spin around 360 degrees
'	
'	Speed 100 ' Slow down speed for scan, needs adjusting		
'	
'	a = 50.8 'minor axis of "elipse"
'	b = 127 'major axis of "elipse"
'
'	P23 = ScanCenter +Y(a + Abs((b - a) * Sin(DegToRad(Theta1)))) +U(Theta1)
'	Go P23 CP  ' Use CP so it's not jumpy
'	Theta1 = Theta1 + 10
'	
'Loop
'	Speed SystemSpeed ' Reset speed
'Fend
'Global Boolean g_io_xfr_on
'Global Integer NextThetaPoint
'Global Integer g_RoboVars(10)
'Global Integer g_HmiVars(10)
'Global Real g_LaserMeasure
'
'Function testIO
'	Integer i
'	Integer NumChars
'	String InString$
'	Port:201
'	
'
'	' kick off the HMI communication task
'	g_io_xfr_on = 1
'	Xqt iotransfer, NoEmgAbort
'	Xqt HmiListen, NoEmgAbort
'	
'	' define the connection to the LASER
'    SetNet #203, "10.22.251.171", 7351, CR, NONE, 0
'    OpenNet #203 As Client
'	
'	
'	'start theta record points at 100
'	NextThetaPoint = 100
'	
'	Do While 1
'		P(100) = Here
''		Print "initial theta is :", CU(P(NextThetaPoint))
'		Wait 1.0
'		Print "Calling laser measure"
'		Call LS_cmd
''		Wait Sw(8)
''		Trap 1 Sw(9) Xqt RecordTheta
''		Call Rotate
''		Print "Theta captured was: ", CU(P(NextThetaPoint))
''		Wait 1.0
''		Move P(100) ROT
''		Wait 1.0
''		Move Here :U(0) ROT
'	Loop
'Fend
'Function Rotate
'	SpeedS (10)
'	SpeedR 360
'	P1 = Here
'	Move P1 +U(180) ROT
'Fend
'Function RecordTheta
'	P(NextThetaPoint) = CurPos
''	NextThetaPoint = NextThetaPoint + 1
'Fend
'' This task runs continuously in the background updating variables
''   between the controller and HMI
'' write variables to HMI
'' read variables from HMI
'Function iotransfer()
'                
'    Integer i, j
'    String response$
'    String outstring$
'    
'    ' define the connection to the HMI
'    SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0
'
'    Do While g_io_xfr_on = 1
'    	Wait 1.0 'send I/O once per second
'        If ChkNet(201) < 0 Then ' If port is not open
'        	Off (HMI_connected), Forced ' initialize to off
'            OpenNet #201 As Client
'            Print "Attempted Open TCP port to HMI"
'        Else
'            On (HMI_connected), Forced 'indicate HMI is connected
'            ' write variable data to HMI
'            Write #201, Chr$(12)
'            For i = 0 To 9
'            	Print #201, "{", Str$(i), ":", Str$(g_RoboVars(i)), "}"
'            Next
'            	Print #201, "Laser Measurement = ", g_LaserMeasure
'        EndIf
'	Loop
'Fend
'' This task runs continuously in the background listening
''   for input from the HMI and updating global variables
'Function HmiListen()
'                
'    Integer i, j, NumTokens
'    String Tokens$(0)
'    String response$
'    String outstring$
'    String match$
'                
'    ' define the connection to the HMI
'    SetNet #202, "10.22.251.68", 1503, CRLF, NONE, 0
'    
'    match$ = "{:} " + Chr$(&H22)
'
'    Do While g_io_xfr_on = 1
'
'        If ChkNet(202) < 0 Then ' If port is not open
'            OpenNet #202 As Server
'        Else
'            i = ChkNet(202)
'            If i > 0 Then
'            	Read #202, response$, i
'            	'numTokens = ParseStr(inputString, tokens$(), delimiters)
'				NumTokens = ParseStr(response$, Tokens$(), match$)
'				Print "Number of Tokens is: ", NumTokens
'				Select Tokens$(0)
'					Case "hmiPause"
'						g_RoboVars(0) = Val(Tokens$(1))
'					Case "hmiResume"
'						g_RoboVars(1) = Val(Tokens$(1))
'					Case "hmiStartJob"
'						g_RoboVars(2) = Val(Tokens$(1))
'					Case "hmiStatus"
'						g_RoboVars(3) = Val(Tokens$(1))
'					Case "hmiStopJob"
'						g_RoboVars(4) = Val(Tokens$(1))
'					Case "hmiSystemIdle"
'						g_RoboVars(5) = Val(Tokens$(1))
'					Case "hmiSystemReady"
'						g_RoboVars(6) = Val(Tokens$(1))
'					Default
'						' TMH for now print come back and do something useful
'						'Print "Invalid Token received"
'				Send
'            EndIf
'        EndIf
'	Loop
'Fend
'' This task is used to query the laser measurement
'Function LS_cmd()
'                
'    Integer i, j, NumTokens
'    String Tokens$(0)
'    String response$
'    String outstring$
'                
''   Do While g_io_xfr_on = 1
'   Print "Entered LS_CMD"
'
'        	Print "Trying Laser..."
'        	Print #203, "MS,0,01"
'        	Wait 1.0
'            i = ChkNet(203)
'            If i > 0 Then
'            	Read #203, response$, i
'            	NumTokens = ParseStr(response$, Tokens$(), ",")
'  				g_LaserMeasure = Val(Tokens$(1))
'                Print "Measurement: ", response$
'            EndIf
''	Loop
'Fend



'Function iotransfer()
'                
'                String response$
'                Integer data_table_size
'                                
'                ' for now just use a 200 byte (100 register) xfer + 13 bytes header
'                data_table_size = 200
'                Byte ModbusXfr(0)
'                Redim ModbusXfr(data_table_size + 13)
'                
'                ' place to capture the modbus response
'                Byte Modbus_Response(5)
'                
'                Integer Comm_Transaction_ID
'                Integer MB_transfer_size
'                
'                ' initial transaction id. This will increment with each transaction
'                Comm_Transaction_ID = 0
'                
'                ' send a unique transaction ID for each transfer 
'                ' then increment the transfer counter
'                ModbusXfr(0) = Int(Comm_Transaction_ID / 256)
'                ModbusXfr(1) = Comm_Transaction_ID Mod 256
'                Comm_Transaction_ID = Comm_Transaction_ID + 1
'                
'                ' this word is always zero for modbus protocol
'                ModbusXfr(2) = 0
'                ModbusXfr(3) = 0
'                
'                ' we are always sending the whole table so this will
'                ' be the table size plus 5 bytes for the modbus PDU
'                ModbusXfr(4) = Int((data_table_size + 7) / 256)
'                ModbusXfr(5) = (data_table_size + 7) Mod 256
'                
'                ' remote slave ID, leave at 255 for TCP/IP since we aren't
'                ' routing through to a serial slave
'                ModbusXfr(6) = 255
'                
'                ' Modbus "Write Multiple Registers" command
'                ModbusXfr(7) = 16
'                
'                ' starting modbus register. we send the whole table
'                ' so start at zero
'                ModbusXfr(8) = 0
'                ModbusXfr(9) = 0
'                
'                ' quantity of modbus registers remember they are 16 bit
'                ModbusXfr(10) = Int((data_table_size / 2) / 256)
'                ModbusXfr(11) = (data_table_size / 2) Mod 256
'                
'                ' byte count of data
'                ModbusXfr(11) = data_table_size
'                
'                ' robot data starts at ModbusXfr(12) and goes to ModbusXfr(212)
'                'ModbusXfr(12) = Comm_Transaction_ID
'                
'                
'                ' define the connection to the HMI
'                SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0
'
'                Do While g_io_xfr_on = 1
'                                ModbusXfr(30) = x
'                                Wait 1.0 'send I/O once per second
'                                If ChkNet(201) < 0 Then ' If port is not open
'                                                Off (HMI_connected), Forced ' initialize to off
'                                                OpenNet #201 As Client
'                                                Print "Attempted Open TCP port to HMI"
'                                Else
'                                                On (HMI_connected), Forced 'indicate HMI is connected
'                                                ' write out the modbus message
'                                                WriteBin #201, ModbusXfr(), 213
'                                                Wait 1.0 ' way too long but ok for testing
'                                                If ChkNet(201) > 0 Then
'                                                              ReadBin #201, Modbus_Response(), 5
'                                                                Print "HMI responded"
'                                                Else
'                                                                Print "No Response from HMI"
'                                                EndIf
'                                EndIf
'                Loop
'Fend
'
'
'Function SetErrorArrayFlag(ErrorArrayIndex As Integer, TrueOrFalse As Boolean)
'	
'	ErrorArray(ErrorArrayIndex) = TrueOrFalse
'	PrintErrorArray() ' Print for testing/troubleshooting
'	
'Fend
'Function PrintErrorArray()
'	
'	Integer n, ErrorIndexPrint
'	
'	For n = 0 To NumOfUserDefinedErrors
'		Print Str$(n) + " " + Str$(ErrorArray(ErrorIndexPrint))
'		ErrorIndexPrint = ErrorIndexPrint + 1
'	Next
'	
'	ErrorIndexPrint = 0 	'Reset index
'	
'Fend
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
'Function iotransfer()
'' This task runs continuously in the background updating variables between the controller and HMI
'' write and read variables to HMI
'                
'    Integer i, j
'    String response$
'    String outstring$
'    
'    ' define the connection to the HMI
''    SetNet #201, "10.22.2.30", 1502, CRLF, NONE, 0
'    SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0
'
'    Do While g_io_xfr_on = 1
'    	Wait 1.0 'send I/O once per second
'        If ChkNet(201) < 0 Then ' If port is not open
'        	Off (HMI_connected), Forced ' initialize to off
'            OpenNet #201 As Client
'            Print "Attempted Open TCP port to HMI"
'        Else
'            On (HMI_connected), Forced 'indicate HMI is connected
'            ' write variable data to HMI
''            Write #201, Chr$(12) 'this breaks the JSON interpreter
'
'				'Tx to HMI:
'				Print #201, "{", Chr$(&H22) + "inMagMtr" + Chr$(&H22), ":", Str$(inMagMtr), "}"
'				Print #201, "{", Chr$(&H22) + "inMagMtrDir" + Chr$(&H22), ":", Str$(inMagMtrDir), "}"
'				Print #201, "{", Chr$(&H22) + "inMagPanelRdy" + Chr$(&H22), ":", Str$(inMagPanelRdy), "}"
'				Print #201, "{", Chr$(&H22) + "inMagUpperLim" + Chr$(&H22), ":", Str$(inMagUpperLim), "}"
'				Print #201, "{", Chr$(&H22) + "inMagLowerLim" + Chr$(&H22), ":", Str$(inMagLowerLim), "}"
'				Print #201, "{", Chr$(&H22) + "inMagInterlock" + Chr$(&H22), ":", Str$(inMagInterlock), "}"
'				Print #201, "{", Chr$(&H22) + "outMagMtr" + Chr$(&H22), ":", Str$(outMagMtr), "}"
'				Print #201, "{", Chr$(&H22) + "outMagMtrDir" + Chr$(&H22), ":", Str$(outMagMtrDir), "}"
'				Print #201, "{", Chr$(&H22) + "outMagPanelRdy" + Chr$(&H22), ":", Str$(outMagPanelRdy), "}"
'				Print #201, "{", Chr$(&H22) + "outMagUpperLim" + Chr$(&H22), ":", Str$(outMagUpperLim), "}"
'				Print #201, "{", Chr$(&H22) + "outMagLowerLim" + Chr$(&H22), ":", Str$(outMagLowerLim), "}"
'				Print #201, "{", Chr$(&H22) + "outMagInt" + Chr$(&H22), ":", Str$(outMagInt), "}"
'				Print #201, "{", Chr$(&H22) + "flashMtr" + Chr$(&H22), ":", Str$(flashMtr), "}"
'				Print #201, "{", Chr$(&H22) + "flashCyc" + Chr$(&H22), ":", Str$(flashCyc), "}"
'				Print #201, "{", Chr$(&H22) + "flashPnlPrsnt" + Chr$(&H22), ":", Str$(FlashPnlPrsnt), "}"
'				Print #201, "{", Chr$(&H22) + "hsPanelPresnt" + Chr$(&H22), ":", Str$(hsPanelPresnt), "}"
'				Print #201, "{", Chr$(&H22) + "hsInstallInsrt" + Chr$(&H22), ":", Str$(hsInstallInsrt), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonHeatStake" + Chr$(&H22), ":", Str$(cbMonHeatStake), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonBowlFeder" + Chr$(&H22), ":", Str$(cbMonBowlFeder), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonInMag" + Chr$(&H22), ":", Str$(cbMonInMag), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonFlashRmv" + Chr$(&H22), ":", Str$(cbMonFlashRmv), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonDebrisRmv" + Chr$(&H22), ":", Str$(cbMonDebrisRmv), "}"
'				Print #201, "{", Chr$(&H22) + "dcPwrOk" + Chr$(&H22), ":", Str$(dcPwrOk), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonPnumatic" + Chr$(&H22), ":", Str$(cbMonPnumatic), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonSafety" + Chr$(&H22), ":", Str$(cbMonSafety), "}"
'				Print #201, "{", Chr$(&H22) + "cbMonPAS24vdc" + Chr$(&H22), ":", Str$(cbMonPAS24vdc), "}"
'				Print #201, "{", Chr$(&H22) + "hmiPause" + Chr$(&H22), ":", Str$(hmiPause), "}"
'				Print #201, "{", Chr$(&H22) + "suctionCups" + Chr$(&H22), ":", Str$(suctionCups), "}"
'				
'				'Integers
'				Print #201, "{", Chr$(&H22) + "systemStatus" + Chr$(&H22), ":", Str$(systemStatus), "}"
'				Print #201, "{", Chr$(&H22) + "hmiStatus" + Chr$(&H22), ":", Str$(hmiStatus), "}"
'				Print #201, "{", Chr$(&H22) + "hsProbeTemp" + Chr$(&H22), ":", Str$(hsProbeTemp), "}"
'				Print #201, "{", Chr$(&H22) + "jobNumPanelsDone" + Chr$(&H22), ":", Str$(jobNumPanelsDone), "}"
'				
'				'Errors
'				'Print error and SOH vars here					
' 				Print #201, "{", Chr$(&H22) + "erUnknown" + Chr$(&H22), ":", Str$(erUnknown), "}"
'				Print #201, "{", Chr$(&H22) + "erEstop" + Chr$(&H22), ":", Str$(erEstop), "}"
'				Print #201, "{", Chr$(&H22) + "erPanelFailedInspection" + Chr$(&H22), ":", Str$(erPanelFailedInspection), "}"
'				Print #201, "{", Chr$(&H22) + "erFrontSafetyFrameOpen" + Chr$(&H22), ":", Str$(erFrontSafetyFrameOpen), "}"
'				Print #201, "{", Chr$(&H22) + "erBackSafetyFrameOpen" + Chr$(&H22), ":", Str$(erBackSafetyFrameOpen), "}"
'				Print #201, "{", Chr$(&H22) + "erLeftSafetyFrameOpen" + Chr$(&H22), ":", Str$(erLeftSafetyFrameOpen), "}"
'				Print #201, "{", Chr$(&H22) + "erRightSafetyFrameOpen" + Chr$(&H22), ":", Str$(erRightSafetyFrameOpen), "}"
'				Print #201, "{", Chr$(&H22) + "erLowPressure" + Chr$(&H22), ":", Str$(erLowPressure), "}"
'				Print #201, "{", Chr$(&H22) + "erHighPressure" + Chr$(&H22), ":", Str$(erHighPressure), "}"
'				Print #201, "{", Chr$(&H22) + "erPanelStatusUnknown" + Chr$(&H22), ":", Str$(erPanelStatusUnknown), "}"
'				Print #201, "{", Chr$(&H22) + "erWrongPanelHoles" + Chr$(&H22), ":", Str$(erWrongPanelHoles), "}"
'				Print #201, "{", Chr$(&H22) + "erWrongPanelDims" + Chr$(&H22), ":", Str$(erWrongPanelDims), "}"
'				Print #201, "{", Chr$(&H22) + "erWrongPanel" + Chr$(&H22), ":", Str$(erWrongPanel), "}"
'				Print #201, "{", Chr$(&H22) + "erWrongPanelInsert" + Chr$(&H22), ":", Str$(erWrongPanelInsert), "}"
'				Print #201, "{", Chr$(&H22) + "erInMagEmpty" + Chr$(&H22), ":", Str$(erInMagEmpty), "}"
'				Print #201, "{", Chr$(&H22) + "erInMagOpenInterlock" + Chr$(&H22), ":", Str$(erInMagOpenInterlock), "}"
'				Print #201, "{", Chr$(&H22) + "erInMagCrowding" + Chr$(&H22), ":", Str$(erInMagCrowding), "}"
'				Print #201, "{", Chr$(&H22) + "erOutMagFull" + Chr$(&H22), ":", Str$(erOutMagFull), "}"
'				Print #201, "{", Chr$(&H22) + "erOutMagOpenInterlock" + Chr$(&H22), ":", Str$(erOutMagOpenInterlock), "}"
'				Print #201, "{", Chr$(&H22) + "erOutMagCrowding" + Chr$(&H22), ":", Str$(erOutMagCrowding), "}"
'				Print #201, "{", Chr$(&H22) + "erLaserScanner" + Chr$(&H22), ":", Str$(erLaserScanner), "}"
'				Print #201, "{", Chr$(&H22) + "erDCPower" + Chr$(&H22), ":", Str$(erDCPower), "}"
'				Print #201, "{", Chr$(&H22) + "erDCPowerHeatStake" + Chr$(&H22), ":", Str$(erDCPowerHeatStake), "}"
'				Print #201, "{", Chr$(&H22) + "erHeatStakeBreaker" + Chr$(&H22), ":", Str$(erHeatStakeBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erBowlFeederBreaker" + Chr$(&H22), ":", Str$(erBowlFeederBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erInMagBreaker" + Chr$(&H22), ":", Str$(erInMagBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erOutMagBreaker" + Chr$(&H22), ":", Str$(erOutMagBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erFlashBreaker" + Chr$(&H22), ":", Str$(erFlashBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erDebrisRemovalBreaker" + Chr$(&H22), ":", Str$(erDebrisRemovalBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erPnumaticsBreaker" + Chr$(&H22), ":", Str$(erPnumaticsBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erSafetySystemBreaker" + Chr$(&H22), ":", Str$(erSafetySystemBreaker), "}"
'				Print #201, "{", Chr$(&H22) + "erRC180" + Chr$(&H22), ":", Str$(erRC180), "}"
'				'SOH
'				Print #201, "{", Chr$(&H22) + "homePositionStatus" + Chr$(&H22), ":", Str$(homePositionStatus), "}"
'				Print #201, "{", Chr$(&H22) + "motorOnStatus" + Chr$(&H22), ":", Str$(motorOnStatus), "}"
'				Print #201, "{", Chr$(&H22) + "motorPowerStatus" + Chr$(&H22), ":", Str$(motorPowerStatus), "}"
'				Print #201, "{", Chr$(&H22) + "joint1Status" + Chr$(&H22), ":", Str$(joint1Status), "}"
'				Print #201, "{", Chr$(&H22) + "joint2Status" + Chr$(&H22), ":", Str$(joint2Status), "}"
'				Print #201, "{", Chr$(&H22) + "joint3Status" + Chr$(&H22), ":", Str$(joint3Status), "}"
'				Print #201, "{", Chr$(&H22) + "joint4Status" + Chr$(&H22), ":", Str$(joint4Status), "}"
'				Print #201, "{", Chr$(&H22) + "eStopStatus" + Chr$(&H22), ":", Str$(eStopStatus), "}"
'				Print #201, "{", Chr$(&H22) + "errorStatus" + Chr$(&H22), ":", Str$(errorStatus), "}"
'				Print #201, "{", Chr$(&H22) + "tasksRunningStatus" + Chr$(&H22), ":", Str$(tasksRunningStatus), "}"
'				Print #201, "{", Chr$(&H22) + "pauseStatus" + Chr$(&H22), ":", Str$(pauseStatus), "}"
'				Print #201, "{", Chr$(&H22) + "teachModeStatus" + Chr$(&H22), ":", Str$(teachModeStatus), "}"
''				Print #201, "{", Chr$(&H22) + "ctrlrErrMsg$" + Chr$(&H22), ":", ctrlrErrMsg$, "}"
'				Print #201, "{", Chr$(&H22) + "ctrlrLineNumber" + Chr$(&H22), ":", Str$(ctrlrLineNumber), "}"
'				Print #201, "{", Chr$(&H22) + "ctrlrTaskNumber" + Chr$(&H22), ":", Str$(ctrlrTaskNumber), "}"
'				Print #201, "{", Chr$(&H22) + "ctrlrErrAxisNumber" + Chr$(&H22), ":", Str$(ctrlrErrAxisNumber), "}"
'				Print #201, "{", Chr$(&H22) + "ctrlrErrorNum" + Chr$(&H22), ":", Str$(ctrlrErrorNum), "}"
'
''            	Print #201, "Laser Measurement = ", g_LaserMeasure
'        EndIf
'	Loop
'Fend
'' This task runs continuously in the background listening
''   for input from the HMI and updating global variables
'Function HmiListen()
'                
'    Integer i, j, NumTokens
'    String Tokens$(0)
'    String response$
'    String outstring$
'    String match$
'                
'    ' define the connection to the HMI
'    SetNet #202, "10.22.251.68", 1503, CRLF, NONE, 0
'    
'    match$ = "{:} " + Chr$(&H22)
' 
'    Do While True 'g_io_xfr_on = 1
'
'        If ChkNet(202) < 0 Then ' If port is not open
'            OpenNet #202 As Server
'        Else
'            i = ChkNet(202)
'            If i > 0 Then
'            	Read #202, response$, i
'            	'numTokens = ParseStr(inputString, tokens$(), delimiters)
'				NumTokens = ParseStr(response$, Tokens$(), match$)
'				Print "Number of Tokens is: ", NumTokens
'				Print response$
'				Select Tokens$(0)
'  					'Rx from HMI:
'				Case "inMagGoHome"
'				   If Tokens$(1) = "true" Then
'				       inMagGoHome = True
'				   Else
'				       inMagGoHome = False
'				   EndIf
'				   Print "inMagGoHome:", inMagGoHome
'				Case "outMagGoHome"
'				   If Tokens$(1) = "true" Then
'				       outMagGoHome = True
'				   Else
'				       outMagGoHome = False
'				   EndIf
'				   Print "outMagGoHome:", outMagGoHome
'				Case "inMagLoaded"
'				   If Tokens$(1) = "true" Then
'				       inMagLoaded = True
'				   Else
'				       inMagLoaded = False
'				   EndIf
'				   Print "inMagLoaded:", inMagLoaded
'				Case "outMagUnloaded"
'				   If Tokens$(1) = "true" Then
'				       outMagUnloaded = True
'				   Else
'				       outMagUnloaded = False
'				   EndIf
'				   Print "outMagUnloaded:", outMagUnloaded
'				Case "inMagIntLockAck"
'				   If Tokens$(1) = "true" Then
'				       inMagIntLockAck = True
'				   Else
'				       inMagIntLockAck = False
'				   EndIf
'				   Print "inMagIntLockAck:", inMagIntLockAck
'				Case "outMagIntLockAck"
'				   If Tokens$(1) = "true" Then
'				       outMagIntLockAck = True
'				   Else
'				       outMagIntLockAck = False
'				   EndIf
'				   Print "outMagIntLockAck:", outMagIntLockAck
'				Case "recNumberOfHoles"
'				    recNumberOfHoles = Val(Tokens$(1))
'				    Print "recNumberOfHoles:", recNumberOfHoles
'				Case "recFlashRequired"
'				    If Tokens$(1) = "true" Then
'				        recFlashRequired = True
'				    Else
'				        recFlashRequired = False
'				    EndIf
'				    Print "recFlashRequired:", recFlashRequired
'				Case "recZDropOff"
'				    recZDropOff = Val(Tokens$(1))
'				    Print "recZDropOff:", recZDropOff
'				Case "recInsertType"
'				    recInsertType = Val(Tokens$(1))
'				    Print "recInsertType:", recInsertType
'				Case "recInsertDepth"
'				    recInsertDepth = Val(Tokens$(1))
'				    Print "recInsertDepth:", recInsertDepth
'				Case "recMajorDim"
'				    recMajorDim = Val(Tokens$(1))
'				    Print "recMajorDim:", recMajorDim
'				Case "recMinorDim"
'				    recMinorDim = Val(Tokens$(1))
'				    Print "recMinorDim:", recMinorDim
'				Case "sftyFrmIlockAck"
'				   If Tokens$(1) = "true" Then
'				       sftyFrmIlockAck = True
'				   Else
'				       sftyFrmIlockAck = False
'				   EndIf
'				   Print "sftyFrmIlockAck:", sftyFrmIlockAck
'				Case "inMagMtrF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagMtrF)
'				    Else
'				        MemOff (inMagMtrF)
'				    EndIf
'				Case "inMagMtrDirF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagMtrDirF)
'				    Else
'				        MemOff (inMagMtrDirF)
'				    EndIf
'				Case "inMagPartReadyF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagPartReadyF)
'				    Else
'				        MemOff (inMagPartReadyF)
'				    EndIf
'				Case "inMagUpperLimF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagUpperLimF)
'				    Else
'				        MemOff (inMagUpperLimF)
'				    EndIf
'				Case "inMagLowerLimF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagLowerLimF)
'				    Else
'				        MemOff (inMagLowerLimF)
'				    EndIf
'				Case "inMagInterlockF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagInterlockF)
'				    Else
'				        MemOff (inMagInterlockF)
'				    EndIf
'				Case "outMagMtrF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagMtrF)
'				    Else
'				        MemOff (outMagMtrF)
'				    EndIf
'				Case "outMagMtrDirF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagMtrDirF)
'				    Else
'				        MemOff (outMagMtrDirF)
'				    EndIf
'				Case "outMagPartRdyF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagPartRdyF)
'				    Else
'				        MemOff (outMagPartRdyF)
'				    EndIf
'				Case "outMagUpperLimF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagUpperLimF)
'				    Else
'				        MemOff (outMagUpperLimF)
'				    EndIf
'				Case "outMagLowerLimF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagLowerLimF)
'				    Else
'				        MemOff (outMagLowerLimF)
'				    EndIf
'				Case "outMagIntF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagIntF)
'				    Else
'				        MemOff (outMagIntF)
'				    EndIf
'				Case "flashMtrF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (flashMtrF)
'				    Else
'				        MemOff (flashMtrF)
'				    EndIf
'				Case "flashCycF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (flashCycF)
'				    Else
'				        MemOff (flashCycF)
'				    EndIf
'				Case "inMagMtrFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagMtrFV)
'				    Else
'				        MemOff (inMagMtrFV)
'				    EndIf
'				Case "inMagMtrDirFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagMtrDirFV)
'				    Else
'				        MemOff (inMagMtrDirFV)
'				    EndIf
'				Case "inMagPartReadyFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagPartReadyFV)
'				    Else
'				        MemOff (inMagPartReadyFV)
'				    EndIf
'				Case "inMagUpperLimFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagUpperLimFV)
'				    Else
'				        MemOff (inMagUpperLimFV)
'				    EndIf
'				Case "inMagLowerLimFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagLowerLimFV)
'				    Else
'				        MemOff (inMagLowerLimFV)
'				    EndIf
'				Case "inMagInterlockFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (inMagInterlockFV)
'				    Else
'				        MemOff (inMagInterlockFV)
'				    EndIf
'				Case "outMagMtrFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagMtrFV)
'				    Else
'				        MemOff (outMagMtrFV)
'				    EndIf
'				Case "outMagMtrDirFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagMtrDirFV)
'				    Else
'				        MemOff (outMagMtrDirFV)
'				    EndIf
'				Case "outMagPartRdyFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagPartRdyFV)
'				    Else
'				        MemOff (outMagPartRdyFV)
'				    EndIf
'				Case "outMagUpperLimFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagUpperLimFV)
'				    Else
'				        MemOff (outMagUpperLimFV)
'				    EndIf
'				Case "outMagLowerLimFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagLowerLimFV)
'				    Else
'				        MemOff (outMagLowerLimFV)
'				    EndIf
'				Case "outMagIntFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (outMagIntFV)
'				    Else
'				        MemOff (outMagIntFV)
'				    EndIf
'				Case "flashMtrFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (flashMtrFV)
'				    Else
'				        MemOff (flashMtrFV)
'				    EndIf
'				Case "flashCycFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (flashCycFV)
'				    Else
'				        MemOff (flashCycFV)
'				    EndIf
'				Case "hsInstallInsrtF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (hsInstallInsrtF)
'				    Else
'				        MemOff (hsInstallInsrtF)
'				    EndIf
'				Case "hsInstallInsrtFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (hsInstallInsrtFV)
'				    Else
'				        MemOff (hsInstallInsrtFV)
'				    EndIf
'				Case "cbMonHeatStakeF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonHeatStakeF)
'				    Else
'				        MemOff (cbMonHeatStakeF)
'				    EndIf
'				Case "cbMonBowlFederF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonBowlFederF)
'				    Else
'				        MemOff (cbMonBowlFederF)
'				    EndIf
'				Case "cbMonInMagF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonInMagF)
'				    Else
'				        MemOff (cbMonInMagF)
'				    EndIf
'				Case "cbMonOutMagF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonOutMagF)
'				    Else
'				        MemOff (cbMonOutMagF)
'				    EndIf
'				Case "cbMonFlashRmvF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonFlashRmvF)
'				    Else
'				        MemOff (cbMonFlashRmvF)
'				    EndIf
'				Case "cbMonDebrisRmvF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonDebrisRmvF)
'				    Else
'				        MemOff (cbMonDebrisRmvF)
'				    EndIf
'				Case "dcPwrOkF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (dcPwrOkF)
'				    Else
'				        MemOff (dcPwrOkF)
'				    EndIf
'				Case "cbMonPnumaticF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonPnumaticF)
'				    Else
'				        MemOff (cbMonPnumaticF)
'				    EndIf
'				Case "cbMonSafetyF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonSafetyF)
'				    Else
'				        MemOff (cbMonSafetyF)
'				    EndIf
'				Case "cbMonPAS24vdcF"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonPAS24vdcF)
'				    Else
'				        MemOff (cbMonPAS24vdcF)
'				    EndIf
'				Case "cbMonHeatStakeFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonHeatStakeFV)
'				    Else
'				        MemOff (cbMonHeatStakeFV)
'				    EndIf
'				Case "cbMonBowlFederFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonBowlFederFV)
'				    Else
'				        MemOff (cbMonBowlFederFV)
'				    EndIf
'				Case "cbMonInMagFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonInMagFV)
'				    Else
'				        MemOff (cbMonInMagFV)
'				    EndIf
'				Case "cbMonOutMagFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonOutMagFV)
'				    Else
'				        MemOff (cbMonOutMagFV)
'				    EndIf
'				Case "cbMonFlashRmvFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonFlashRmvFV)
'				    Else
'				        MemOff (cbMonFlashRmvFV)
'				    EndIf
'				Case "cbMonDebrisRmvFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonDebrisRmvFV)
'				    Else
'				        MemOff (cbMonDebrisRmvFV)
'				    EndIf
'				Case "dcPwrOkFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (dcPwrOkFV)
'				    Else
'				        MemOff (dcPwrOkFV)
'				    EndIf
'				Case "cbMonPnumaticFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonPnumaticFV)
'				    Else
'				        MemOff (cbMonPnumaticFV)
'				    EndIf
'				Case "cbMonSafetyFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonSafetyFV)
'				    Else
'				        MemOff (cbMonSafetyFV)
'				    EndIf
'				Case "cbMonPAS24vdcFV"
'				    If Tokens$(1) = "true" Then
'				        MemOn (cbMonPAS24vdcFV)
'				    Else
'				        MemOff (cbMonPAS24vdcFV)
'				    EndIf
'				Case "anvilZlimit"
'				    AnvilZlimit = Val(Tokens$(1))
'				    Print "anvilZlimit:", AnvilZlimit
'				Case "systemSpeed"
'				    SystemSpeed = Val(Tokens$(1))
'				    Print "systemSpeed:", SystemSpeed
'				Case "recTemp"
'				    recTemp = Val(Tokens$(1))
'				    Print "recTemp:", recTemp
'				Case "jobNumPanels"
'				Case "hmiStopJob"
'				   If Tokens$(1) = "true" Then
'				       hmiStopJob = True
'				   Else
'				       hmiStopJob = False
'				   EndIf
'				   Print "hmiStopJob:", hmiStopJob
'				Case "robStart"
'				   If Tokens$(1) = "true" Then
'				       robStart = True
'				   Else
'				       robStart = False
'				   EndIf
'				   Print "robStart:", robStart
'				Case "robStop"
'				   If Tokens$(1) = "true" Then
'				       robStop = True
'				   Else
'				       robStop = False
'				   EndIf
'				   Print "robStop:", robStop
'				Case "robPause"
'				   If Tokens$(1) = "true" Then
'				       robPause = True
'				   Else
'				       robPause = False
'				   EndIf
'				   Print "robPause:", robPause
'				Case "robResume"
'				   If Tokens$(1) = "true" Then
'				       robResume = True
'				   Else
'				       robResume = False
'				   EndIf
'				   Print "robResume:", robResume
'				Case "recBossHeight"
'				    recBossHeight = Val(Tokens$(1))
'				    Print "recBossHeight:", recBossHeight
'
'				Default
'						' TMH for now print come back and do something useful
'						'Print "Invalid Token received"
'				Send
'            EndIf
'        EndIf
'	Loop
'Fend
'Function EdgeDetected
'	
'	If Sw(laserLo) = True Then
'		Move Here +Y(1.6)
'	ElseIf Sw(laserHi) = True Then
'		Move Here -Y(1.6)
'	EndIf
'	
'	P(x) = Here
'	x = x + 1
'	
'	Trap 1 Sw(laserHi) = True Or Sw(laserLo) Call EdgeDetected
'		
'Fend
'Function TracePanelEdge()
'	
'x = 100 ' start edge points at 100
'Off (laserP1) ' Change to laser profile 0
'

'
'Go ScanCenter4 CP Till Sw(laserGo)
'Move Here -Y(1.2)
'P(x) = Here
'x = x + 1
'
'Trap 1 Sw(laserHi) = True Or Sw(laserLo) Call EdgeDetected
'Print "Edge time start: ", Time$
'
'Do While CU(Here) < (490) 'Spin around 360 degrees
'
'     Move ScanCenter3 :U(485) CP ROT
'	
'If CU(Here) > 455 Then
'	Exit Do
'EndIf
'Loop
'
'Trap 1 ' turn off trap
'
'Print "Edge time end: ", Time$
'Fend
'Function FindHoles()
'	
'Speed 1
'Accel 20, 20
'FirstHolePoint = 600 'Start hole locations at 600	
'Integer i
'i = 100
'On (laserP1) ' Change to laser profile 1	
'
'Print "Scan time start: ", Time$
'Go P(100) +Y(23) +Z(3.5) CP ' go to the first point
'
'Trap 4 Sw(holeDetected) Xqt RecordTheta ' Arm Trap	
'
'	For i = 100 To (x - 1)
'		Go P(i) +Y(23) +Z(3.5) CP
'	Next i
'	
'Trap 4 'turn off trap
'recNumberOfHoles = z
'PrintPanelArray()
'Print "Scan time end: ", Time$
'Print "found holes:", z
'
'Fend
'Function RecordTheta
'	
'CurrentTheta = CU(CurPos)
'
'Print "called trap"
'	
'If CurrentTheta - LastTheta > 6 Or z = 0 Then ' need z=0 to see first hole
'	r = 635 - CY(CurPos) '635mm is an eyeballed y coordinate of laser scannr
'	PanelArray(PanelArrayIndex, RadiusColumn) = r 'Assign r and theta to array
'	PanelArray(PanelArrayIndex, ThetaColumn) = CurrentTheta
'	PanelArrayIndex = PanelArrayIndex + 1
'
'	Print "found a hole"
'	P(FirstHolePoint + z) = CurPos
'
'	z = z + 1 ' count num of holes found
'	LastTheta = CurrentTheta
''TODO:add check to make sure we don't increment panelarray beyond bounds
'Else
'	DoubleTriggered = DoubleTriggered + 1
'EndIf
'
'Trap 4 Sw(holeDetected) Xqt RecordTheta 'rearm trap
'
'Fend

'Function RecordTheta
'	
'CurrentTheta = CU(CurPos)
''Print "called trap"
'	
'If CurrentTheta - LastTheta < 5 Or z = 0 Then
'	If z = 0 Then
'		rAvg = CY(CurPos)
'		thetaAvg = CU(CurPos)
'		LastTheta = thetaAvg
'	Else
'		r = 635 - CY(CurPos) '635mm is an eyeballed y coordinate of laser scannr
'		rAvg = (rAvg + r) /2  'Running average
'		
'		Theta = CU(CurPos)
'		thetaAvg = (thetaAvg + Theta) /2
'	EndIf
'		
'ElseIf CurrentTheta - LastTheta > 5 Then ' need z=0 to see first hole
'
'	PanelArray(PanelArrayIndex, RadiusColumn) = rAvg 'Assign r and theta to array
'	PanelArray(PanelArrayIndex, ThetaColumn) = thetaAvg
'
'	PanelArrayIndex = PanelArrayIndex + 1
'	z = z + 1 ' count num of holes found
'	
'	LastTheta = thetaAvg
'	Print "found a hole"
'	
''	P(FirstHolePoint + z) = CurPos
'	
''TODO:add check to make sure we dont increment beyond bounds
'EndIf
'
'Trap 4 Sw(holeDetected) Xqt RecordTheta 'rearm trap
'
'Fend

'Function Inspection() As Boolean
'	SystemStatus = InspectingPanel
'	
'	Boolean SkippedHole
'	Integer k
'  	
'	PanelArrayIndex = 0 ' Reset Index
'	GetThetaR()
'	
'	Go waypoint1
'	
'	For k = 0 To z - 1
'		
'		If k <> 0 Then
'			IncrementIndex()
'			GetThetaR()
'			
'			If r = 0 Then
'				Print "r=0"
'				Pause
'			EndIf
'		EndIf
'
'		SkippedHole = False 'Reset flag
'		
'		If PanelArray(PanelArrayIndex, SkipFlagColumn) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
'			SkippedHole = True 'Set flag
'		EndIf
'
'		If SkippedHole = False Then 'If the flag is set then we have finished all holes		
'			P23 = InspectionCenter -X(PanelArray(PanelArrayIndex, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn) - 90)
'			Move P23 CP ROT
'			Wait 1
'			'Pass/fail stuff goes here
'		EndIf
'
'	Next
'	
'	Go waypoint1
	
	'Return Pass/Fail, work with Scott on the logging aspect 
'	If PanelPassedInspection = False Then
'		erPanelFailedInspection = True
'		SystemPause()
'	Else
'		erPanelFailedInspection = False
'	EndIf
	
'	SystemStatus = MovingPanel
'	Go ScanCenter3 ' Collision Avoidance Waypoint
	
'Fend
