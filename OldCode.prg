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
