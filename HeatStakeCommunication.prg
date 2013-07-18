#include "Globals.INC"

' modbus write queque
' structure to maintain a queue of pending
' writes to the PLC via modbus
Integer MBQueueAddress(MBWriteQueueSize)
Long MBQueueValue(MBWriteQueueSize)
Byte MBQueueType(MBWriteQueueSize)
Integer MBMessageID(MBWriteQueueSize)
Integer MBQueueHead
Integer MBQueueTail

String CRLF$
Integer modMessage(256)
Integer modResponse(256)
Integer modbusMessageID
Boolean testcoil
Boolean testinput

'globals for testing

Function TestMB()
	Integer i
	Integer writtenValue
	Long readValue
	Integer writeStatus
	Integer portStatus
	String testString$
	Integer modLength
	 
	' Initialize modbus variables including read address vector
'	MBInitialize()
	
	' stuff the queue with writes of various types at full speed
'	MBWrite(&h0100, &hFACE, MBType16)
'	MBWrite(&h0100, &hAABBCCDD, MBType32)
'	MBWrite(&h0112, &h1234, MBTypeCoil)
'	MBWrite(&h0112, &hFFFF, MBTypeCoil)
'	MBWrite(&h0112, &h0000, MBTypeCoil)
'	Wait 3
'	MBWrite(&h0100, &hFACE, MBTypeCoil)
'	MBWrite(&h0100, &hFACE, MBType16)
'	MBWrite(&h0100, &hFACE, MBType16)
'	Wait 5
'	MBWrite(&h0100, &hFACE, MBType32)
'	MBWrite(&h0100, &hFACE, MBType32)
'	MBWrite(&h0100, &hFACE, MBTypeCoil)
'	MBWrite(&h0100, &hFACE, MBTypeCoil)
'	MBWrite(&h0100, &hFACE, MBType32)
'	MBWrite(&h0100, &hFACE, MBType32)
'	MBWrite(&h0100, &hFACE, MBTypeCoil)
'	MBWrite(&h0100, &hFACE, MBTypeCoil)
'	MBWrite(&h0100, &hFACE, MBType32)
'	MBWrite(&h0100, &hFACE, MBType32)
'	MBWrite(&h0100, &hFACE, MBTypeCoil)
'	MBWrite(&h0100, &hFACE, MBTypeCoil)
	
	Do While 1
		Wait 1
		Print "pasInsertDetected", pasInsertDetected
		Print "pasSteelInsert", pasSteelInsert
		Print "pasJogSpeed", pasJogSpeed
		Print "---"
		
'	MBWrite(pasSlideExtendAddr, 1, MBTypeCoil)
'	Wait 5 ' wait for coil change
'	Print mbRead(pasSlideExtendAddr)
	
'	MBWrite(pasSlideExtendAddr, 0, MBTypeCoil)
'	Wait 5
	Loop
	
Fend
Function MBInitialize()
	
	' clear global modbus error flags
	erModbusTimeout = False
	erModbusCommand = False
	erModbusPort = False
	
	' initialize queue pointers
	MBQueueHead = 0
	MBQueueTail = 0
	
	' kick off the command processing task
	Xqt 10, MBCommandTask, NoEmgAbort
	
Fend
'place modbus write commands into a queue to be processed by a seperate task
' MBCommandTask Return False if the requested command cannont be queued
Function MBWrite(Address As Integer, Value As Long, Type As Byte) As Boolean
	
	' if queue overflows return FALSE from function call not able to queue request
	If (MBQueueHead + 1 = MBQueueTail) Or (MBQueueHead = MBWriteQueueSize And MBQueueTail = 0) Then
		MBWrite = False
		Print "overflow"
		Exit Function
	EndIf
	
	Print "queueing request", Address, Value, Type
	
	
	' range check against type here if I decide to become untrusting TMH
	
	' queue the request
	MBQueueAddress(MBQueueHead) = Address
	MBQueueValue(MBQueueHead) = Value
	MBQueueType(MBQueueHead) = Type
	MBQueueHead = MBQueueHead + 1
	
	' check for wrap around
	If MBQueueHead > MBWriteQueueSize Then
		MBQueueHead = 0 ' wrap around at upper bound of queue array
	EndIf
	
	MBWrite = True
Fend
' function runs as a stand alone task to monitor modbus write queue
' and send commands to PLC
Function MBCommandTask()
	Boolean temp_bool
	Integer CurrentReadNum
	Integer MBNumReadValues
	Integer portStatus
	Long result
	
	CurrentReadNum = 1
	MBNumReadValues = 48
	
	' set up the TCP port on the HMI that we use to tunnel to serial ports	
	' the IP is the HMI's IP address the port is the port that is tied to
	' the matching FPGA serial port line termination is somewhat irrelavent
	' since we are using the binary send and receive the timeout is set to
	' 20ms which is almost 6 times the theoritial tranfer time of the typical 7 byte transfer
	SetNet #204, "10.22.251.171", 7352, CR, NONE, 3
	OpenNet #204 As Client
	
	' each time through this infinite loop one modbus command will be executed.
	' If there are commands to be written they will be removed from the queue
	' and written, otherwise the next modbus read will be executed 
	' any communication or CRC errors will abort this background task at which
	' time it will require a call to MBinitialize to set things up and kick
	' this off again.
	
	' give things a chance to settle
	Wait 3
	
	' retart the metering timer
	TmReset 1
	Do While 1
		' if the port is not open try to open it
		portStatus = ChkNet(204)
		If portStatus < 0 Then
			OpenNet #204 As Client
			portStatus = ChkNet(204)
			Print "portStatus is: ", portStatus
			' if we are unable to open it set an error and abort
			If portStatus < 0 Then
				erModbusPort = True
				Exit Function
			EndIf
		EndIf
		
		'if the queue isn't empty there is something to do
		If MBQueueHead <> MBQueueTail Then
			Print "something in the queue!"
			If MBQueueType(MBQueueTail) = MBType16 Then
				' send one MB word command
				modbusWriteRegister(MBQueueAddress(MBQueueTail), MBQueueValue(MBQueueTail))
				' advance pointer and check for wrap around
				MBQueueTail = MBQueueTail + 1
				If MBQueueTail > MBWriteQueueSize Then
					MBQueueTail = 0
				EndIf
					
			ElseIf MBQueueType(MBQueueTail) = MBType32 Then
				' send two MB word command
				' write the two 16bit words
				modbusWriteRegister(MBQueueAddress(MBQueueTail), (MBQueueValue(MBQueueTail) And &hFFFF))
				modbusWriteRegister(MBQueueAddress(MBQueueTail) + 1, RShift(MBQueueValue(MBQueueTail), 16))
				' advance pointer and check for wrap around
				MBQueueTail = MBQueueTail + 1
				If MBQueueTail > MBWriteQueueSize Then
					MBQueueTail = 0
				EndIf
			ElseIf MBQueueType(MBQueueTail) = MBTypeCoil Then
				' set or clear MB coil
				' any non-zero value will set coil
				Print "writing type coil"
				If MBQueueValue(MBQueueTail) = 0 Then
					temp_bool = False
				Else
					temp_bool = True
				EndIf
				modbusWriteCoil(MBQueueAddress(MBQueueTail), temp_bool)
				' advance pointer and check for wrap around
				MBQueueTail = MBQueueTail + 1
				If MBQueueTail > MBWriteQueueSize Then
					MBQueueTail = 0
				EndIf
			Else
				'invalid type
			EndIf
		Else
			' read not more than twice per second
			' TODO -- change this from a busy wait to a "wait on XXX" were XXX is a free running timer
			Do While Tmr(1) < 0.5
				Wait 0.1
			Loop
			
			'restart the timer so that we can come back and check to 
			'see if a 0.5 second has passed
			TmReset 1

			' priority reads
			result = modbusReadRegister(&hA4B0)
				pasInsertDetected = BTst(result, 4)
				pasSteelInsert = BTst(result, 5)
				pasShuttleMidway = BTst(result, 6)
				pasShuttleLoadPosition = BTst(result, 8)
				pasShuttleNoLoad = BTst(result, 9)
				pasShuttleExtend = BTst(result, 10)
				pasInsertInShuttle = BTst(result, 11)
			result = modbusReadRegister(&hA479)
				pasHeadDown = BTst(result, 4)
				pasHeadUp = BTst(result, 5)
				pasSlideExtend = BTst(result, 7)
				pasInsertGripper = BTst(result, 8)
				pas1inLoadInsertCylinder = BTst(result, 9)
				pasBowlDumpOpen = BTst(result, 11)
				pasVibTrack = BTst(result, 12)
				pasBowlFeeder = BTst(result, 13)
				pasBlowInsert = BTst(result, 14)
			result = modbusReadRegister(&hA7B8)
				pasMCREStop = BTst(result, 0)
				pasStart = BTst(result, 1)
				pasHeadinsertPickupRetract = BTst(result, 6)
				pasHeadinsertpickupextend = BTst(result, 7)
			pasCrowding = modbusReadInput(&h03A5)
			pasVerticalLocation = modbusRead32Register(&h0002) * .000000762939
			pasPreHeatActual = modbusReadRegister(&hA147) * 0.1
			pasDwellActual = modbusReadRegister(&hA148) * 0.1
			pasCoolActual = modbusReadRegister(&hA149) * 0.1
			pasMessageDB = modbusReadRegister(pasMessageDBADDR)

			
			' lazy reads
			Select CurrentReadNum
			Case 1
				pasHome = modbusReadInput(&h0057)
			Case 2
				pasSoftHome = modbusRead32Register(&h00FE) * .000000762939
			Case 3
				pasInsertPosition = modbusRead32Register(&h0100) * .000000762939
			Case 4
				pasInsertDepth = modbusRead32Register(&h0102) * .000000762939
			Case 5
				pasSoftStop = modbusRead32Register(&h0104) * .000000762939
			Case 6
				pasHomeIPM = modbusRead32Register(&h0106) * .0000457764
			Case 7
				pasInsertPickupIPM = modbusRead32Register(&h0108) * .0000457764
			Case 8
				pasHeatStakingIPM = modbusRead32Register(&h010A) * .0000457764
			Case 9
				pasInsertEngageIPM = modbusRead32Register(&h010E) * .0000457764
			Case 10
				pasInsertEngage = modbusRead32Register(&h0118) * .000000762939
			Case 11
				pasSetTempZone1 = modbusReadRegister(&h012C)
			Case 12
				pasSetTempZone2 = modbusReadRegister(&h012D)
			Case 13
				pasActualTempZone1 = modbusReadRegister(&h0132)
			Case 14
				pasActualTempZone2 = modbusReadRegister(&h0133)
			Case 15
				pasPIDsetupMaxTempZone1 = modbusReadRegister(&h0138)
			Case 16
				pasPIDsetupMaxTempZone2 = modbusReadRegister(&h0139)
			Case 17
				pasPIDsetupInTempZone1 = modbusReadRegister(&h0149)
			Case 18
				pasPIDsetupInTempZone2 = modbusReadRegister(&h014A)
			Case 19
				pasPIDsetupOffsetZone1 = modbusReadRegister(&h015A)
			Case 20
				pasPIDsetupOffsetZone2 = modbusReadRegister(&h015B)
			Case 21
				pasPIDsetupPZone1 = modbusReadRegister(&h0164)
			Case 22
				pasPIDsetupIZone1 = modbusReadRegister(&h0165)
			Case 23
				pasPIDsetupDZone1 = modbusReadRegister(&h0166)
			Case 24
				pasPIDsetupPZone2 = modbusReadRegister(&h016E)
			Case 25
				pasPIDsetupIZone2 = modbusReadRegister(&h016F)
			Case 26
				pasPIDsetupDZone2 = modbusReadRegister(&h0170)
			Case 27
				pasInsertPreheat = modbusReadRegister(&h0190) * 0.1
			Case 28
				pasDwell = modbusReadRegister(&h0191) * 0.1
			Case 29
				pasCool = modbusReadRegister(&h0192) * 0.1
			Case 30
				pasJogSpeed = modbusReadRegister(&h01FE) * 0.5
			Case 31
				pasMaxLoadmeter = modbusReadRegister(&h0265) * 0.1
			Case 32
				pasLoadMeter = modbusReadRegister(&h028B) * -0.1
			Case 33
				pasHighTempAlarm = modbusReadInput(&h0402)
			Case 34
				pasInsertType = modbusReadInput(&h0230)
			Case 35
				pasTempOnOff = modbusReadInput(&h000D)
			Case 36
				pasMasterTemp = modbusReadInput(&h0401)
			Case 37
				pasUpLimit = modbusReadInput(&h0055)
			Case 38
				pasLowerlimit = modbusReadInput(&h0056)
			Case 39
				pasOTAOnOffZone1 = modbusReadInput(&h0403)
			Case 40
				pasOTAOnOffZone2 = modbusReadInput(&h0404)
			Case 41
				pasOnOffZone1 = modbusReadInput(&h012C)
			Case 42
				pasOnOffZone2 = modbusReadInput(&h012D)
			Case 43
				pasMaxTempOnOffZone1 = modbusReadInput(&h040D)
			Case 44
				pasMaxTempOnOffZone2 = modbusReadInput(&h040E)
			Case 45
				pasMaxTempZone1 = modbusReadInput(&h0028)
			Case 46
				pasMaxTempZone2 = modbusReadInput(&h0029)
			Case 47
				pasPIDTuneDoneZone1 = modbusReadInput(&h0138)
			Case 48
				pasPIDTuneDoneZone2 = modbusReadInput(&h0139)
			Send
			
			CurrentReadNum = CurrentReadNum + 1

			If CurrentReadNum > MBNumReadValues Then
				CurrentReadNum = 1
			EndIf
		EndIf
	Loop
Fend
Function modbusCRC(modLength As Integer) As Long
	
	Long CRC
	Long lowBit
	Integer bitCount
	Integer byteCount
	
	' initialize the CRC
	CRC = &hFFFF

	' step through the entire message
	'Print "outer loop running from 0 to ", modLength - 1
	For byteCount = 0 To modLength - 1
		'Print "processing byte: ", Str$(modMessage(byteCount))

		' XOR current byte of message with CRC
		CRC = CRC Xor modMessage(byteCount)
		'Print "after XOR with byte 0x", Hex$(modMessage(byteCount)), CRC
		
		' proceed through 8 shift operations XORing with polynomial if necessary
		For bitCount = 0 To 7
			'capture the low order bit before we shift it away
			lowBit = CRC And 1
		
			' shift CRC right one bit
			CRC = RShift(CRC, 1)
		
			' if the least significant bit was a 1, XOR it with polynomial constant 1010000000000001
			If lowBit = 1 Then
				CRC = CRC Xor &b1010000000000001
				'Print "after XOR with poly: ", CRC
			Else
				'Print "No XOR with poly   : ", CRC
			EndIf
		Next
	Next
	
	'Print "resulting CRC is: ", CRC
	modbusCRC = CRC
	
Fend
Function modbusResponseCRC(modLength As Integer) As Boolean
	
	Long CRC
	Long lowBit
	Integer bitCount
	Integer byteCount
	
	' initialize the CRC
	CRC = &hFFFF

	' step through the entire message
	'Print "outer loop running from 0 to ", modLength - 1
	For byteCount = 0 To modLength - 3
		' XOR current byte of message with CRC
		CRC = CRC Xor modResponse(byteCount)
		'Print "after XOR with byte 0x", Hex$(modMessage(byteCount)), CRC
		
		' proceed through 8 shift operations XORing with polynomial if necessary
		For bitCount = 0 To 7
			'capture the low order bit before we shift it away
			lowBit = CRC And 1
		
			' shift CRC right one bit
			CRC = RShift(CRC, 1)
		
			' if the least significant bit was a 1, XOR it with polynomial constant 1010000000000001
			If lowBit = 1 Then
				CRC = CRC Xor &b1010000000000001
				'Print "after XOR with poly: ", CRC
			Else
				'Print "No XOR with poly   : ", CRC
			EndIf
		Next
	Next
	
	If (modResponse(modLength - 2) = CRC And &hFF) And (modResponse(modLength - 1) = RShift(CRC, 8)) Then
		modbusResponseCRC = True
	Else
		modbusResponseCRC = False
	EndIf
Fend
' Given a feed rate in inches per minute (stored in a real) this fuction
' will perform the appropriate transfer function and bit twiddling
' to return a long that can be sent to modbusWriteRegister
Function feedRate2Modbus(ipm As Real) As Long
	' 4.57764e-005
	feedRate2Modbus = ipm /.0000457764
Fend
' Given a length in inches (stored in a real) this fuction
' will perform the appropriate transfer function and bit twiddling
' to return a long that can be sent to modbusWriteRegister
Function inches2Modbus(inches As Real) As Long
	' 7.62939e-007
	inches2Modbus = inches /.000000762939
Fend
' Given a time in seconds (stored in a real) this fuction
' will perform the appropriate transfer function and bit twiddling
' to return a long that can be sent to modbusWriteRegister
Function seconds2Modbus(seconds As Real) As Long
	seconds2Modbus = seconds / -0.1
Fend
' function receives jog speed as number from 1 to 100 and 
' performs transfer function and bit twiddling to return
' a value that can be sent to modbusWriteRegister
Function JogRate2Modbus(jog As Real) As Long
	JogRate2Modbus = jog /0.005
Fend
Function modbusWrite32Register(regNum As Long, value As Long) As Integer
	modbusWriteRegister(regNum, value And &hFFFF)
	modbusWriteRegister(regNum + 1, LShift(value, 16))
Fend

' This function is for writing a single 16 Modbus register on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return a ??? for success or -1 for failure
' calling type and return value are "Long" 
Function modbusWriteRegister(regNum As Long, value As Long) As Integer
	
	Integer portStatus
	Long CRC
	Integer i
	Boolean validResponse
	Integer modByteRx(1)
	
	'build the command and send it to PLC
	' function code		0x06
	' address high 		0x00
	' address low		0x00
	' value high		0x00
	' value low			0x00
	modMessage(0) = MBMitsubishiAddress 'PLC modbus address
	modMessage(1) = MBCmdWriteRegister
	modMessage(2) = RShift(regNum, 8) ' high byte of address
	modMessage(3) = regNum And &hFF ' low byte of address
	modMessage(4) = RShift(value, 8) ' high byte of value
	modMessage(5) = value And &hFF ' low byte of value
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8
	
	'clear the response buffer
	For i = 0 To 7
		modResponse(i) = 0
	Next
	
	' process the response or timeout
	'wait for a predefinded timeout period of time or for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 6 if no error
	'modResponse(2) = Register address high byte
	'modResponse(3) = Register address low byte
	'modResponse(4) = value high byte
	'modResponse(5) = value low byte
	'modResponse(6) = CRC low byte
	'modResponse(7) = CRC high byte
	'ReadBin #204, modResponse(), 8
	
	i = 0
	Do While True
		portStatus = ChkNet(204)
		If portStatus > 0 Then
			ReadBin #204, modByteRx(), 1
			modResponse(i) = modByteRx(0)
		ElseIf portStatus = 0 Then
			Exit Do
		Else
			Print "modbus port error: ", portStatus
		EndIf
		i = i + 1
	Loop
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(8)
	If validResponse = False Then
		erModbusCommand = True
	EndIf
	
Fend
Function modbusRead32Register(regNum As Long) As Long
	Long msw
	Long lsw

	lsw = modbusReadRegister(regNum)
	msw = modbusReadRegister(regNum + 1)
	
	modbusRead32Register = LShift(msw, 16) + (lsw And &hFFFF)

Fend

' This function is for reading a single 16 bit Modbus register from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge.
' It will then wait for a response from the PLC
Function modbusReadRegister(regNum As Long) As Long
	
	Long CRC
	Integer i
	Integer portStatus
	Boolean validResponse
	Integer modByteRx(1)
	
	'build the command and send it to PLC
	' function code		0x03
	' address high 		0x00
	' address low		0x02
	' No. of Regs high 	0x01
	' No. of Regs low	0x8F
	modMessage(0) = MBMitsubishiAddress
	modMessage(1) = MBCmdReadRegister ' function code
	modMessage(2) = RShift(regNum, 8) ' high byte of address
	modMessage(3) = regNum And &hFF ' low byte of address
	modMessage(4) = 0 ' high byte of No. of regs is always zero 
	modMessage(5) = 1 ' low byte of No. of regs is one i.e. read one register
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	' debug
	'For i = 0 To 7
	'	Print "modMessage(", Str$(i), ") = ", Hex$(modMessage(i))
	'Next
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8

	'clear the response buffer
	For i = 0 To 7
		modResponse(i) = 0
	Next

	'process the response or timeout 
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 3 if no error
	'modResponse(2) = No. Bytes returned. Should be 2 for one 16 bit register
	'modResponse(3) = value returned high byte
	'modResponse(4) = value returned low byte
	'modResponse(5) = CRC low byte
	'modResponse(6) = CRC high byte
	
	' might have a problem here...
'	ReadBin #204, modResponse(), 7
	' trying this instead
	i = 0
	Do While True
		portStatus = ChkNet(204)
		If portStatus > 0 Then
			ReadBin #204, modByteRx(), 1
			modResponse(i) = modByteRx(0)
		ElseIf portStatus = 0 Then
			Exit Do
		Else
			Print "modbus port error: ", portStatus
		EndIf
		i = i + 1
	Loop
	
'	If regNum = &h0FE Or regNum = &h0FF Then
'		Print "--", regNum
'		Print modResponse(0)
'		Print modResponse(1)
'		Print modResponse(2)
'		Print modResponse(3)
'		Print modResponse(4)
'		Print modResponse(5)
'		Print modResponse(6)
'	EndIf
	
'		Print modResponse(3)
'		Print modResponse(4)
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(7) ' TODO: Fix this, it returns false
	If validResponse = False Then
		erModbusCommand = True
	EndIf
	
	modbusReadRegister = LShift(modResponse(3), 8) + modResponse(4)

Fend
' This function is for writing a single Modbus coil on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return a ??? for success or -1 for failure
Function modbusWriteCoil(coilNum As Long, value As Boolean)
	
	Integer portStatus
	Long CRC
	Integer i
	Boolean validResponse
	Integer modByteRx(1)
	
	portStatus = ChkNet(204)

	'build the command and send it to PLC
	modMessage(0) = MBMitsubishiAddress 'PLC modbus address change to variable when integrated with rest of code TMH
	modMessage(1) = MBCmdWriteCoil ' function code
	modMessage(2) = RShift(coilNum, 8) ' high byte of address
	modMessage(3) = coilNum And &hFF ' low byte of address
	If value = True Then
		modMessage(4) = &hFF; ' constant for setting coil on
		modMessage(5) = 0;
	ElseIf value = False Then
		modMessage(4) = 0; ' constant for setting coil off
		modMessage(5) = 0;
	EndIf
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	' debugging simply print the contents of the message
'	Print "WriteCoilReached"
'	For i = 0 To 7
'		Print "modMessage(", Str$(i), ") = ", Hex$(modMessage(i))
'	Next
	
	' if port is not open exit with error
	If portStatus < 0 Then
		modbusWriteCoil = -1 'error port should remain open
		Print "Bailing! not port open"
		Exit Function
	EndIf
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8
	
	'clear the response buffer
	For i = 0 To 7
		modResponse(i) = 0
	Next
	
	' process the response or timeout
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 5 if no error
	'modResponse(2) = Register address high byte
	'modResponse(3) = Register address low byte
	'modResponse(4) = value high byte
	'modResponse(5) = value low byte
	'modResponse(6) = CRC low byte
	'modResponse(7) = CRC high byte
'	ReadBin #204, modResponse(), 8

	i = 0
	Do While True
		portStatus = ChkNet(204)
		If portStatus > 0 Then
			ReadBin #204, modByteRx(), 1
			modResponse(i) = modByteRx(0)
		ElseIf portStatus = 0 Then
			Exit Do
		Else
			Print "modbus port error: ", portStatus
		EndIf
		i = i + 1
	Loop
	
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(8)
	If validResponse = False Then
		erModbusCommand = True
	EndIf

	
Fend

' This function is for reading a single Modbus coil on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return the coil status
Function modbusReadCoil(coilNum As Long)
	
	Long CRC
	Integer i
	Boolean validResponse
	Integer portStatus
	Integer modByteRx(1)


	'build the command and send it to PLC
	modMessage(0) = MBMitsubishiAddress 'PLC modbus address change to variable when integrated with rest of code TMH
	modMessage(1) = MBCmdReadCoil ' function code
	modMessage(2) = RShift(coilNum, 8) ' high byte of address
	modMessage(3) = coilNum And &hFF ' low byte of address
	modMessage(4) = 0;
	modMessage(5) = 1; ' keep things simple by only allowing the read of one coil
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8
	
	'clear the response buffer
	For i = 0 To 7
		modResponse(i) = 0
	Next
		
	' process the response or timeout
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 1 if no error
	'modResponse(2) = byte count should be 1 since we only read one coil
	'modResponse(3) = data byte
	'modResponse(4) = CRC low byte
	'modResponse(5) = CRC high byte

'	ReadBin #204, modResponse(), 6
	i = 0
	Do While True
		portStatus = ChkNet(204)
		If portStatus > 0 Then
			ReadBin #204, modByteRx(), 1
			modResponse(i) = modByteRx(0)
		ElseIf portStatus = 0 Then
			Exit Do
		Else
			Print "modbus port error: ", portStatus
		EndIf
		i = i + 1
	Loop


	If modResponse(3) And &h01 Then
		modbusReadCoil = True
	Else
		modbusReadCoil = False
	EndIf
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(6)
	If validResponse = False Then
		erModbusCommand = True
	EndIf
	
Fend

' This function is for reading a single Modbus input on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return the input status
Function modbusReadInput(inputNum As Long)
	
	Long CRC
	Integer i
	Boolean validResponse
	Integer portStatus
	Integer modByteRx(1)

	
	'build the command and send it to PLC
	modMessage(0) = MBMitsubishiAddress 'PLC modbus address change to variable when integrated with rest of code TMH
	modMessage(1) = MBCmdReadInput ' function code
	modMessage(2) = RShift(inputNum, 8) ' high byte of address
	modMessage(3) = inputNum And &hFF ' low byte of address
	modMessage(4) = 0;
	modMessage(5) = 1; ' keep things simple by only allowing the read of one coil
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	'debug
'	For i = 0 To 7
'		Print "modMessage(", Str$(i), ") = ", Hex$(modMessage(i))
'	Next
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8
	
	'clear the response buffer
	For i = 0 To 10
		modResponse(i) = 0
	Next

	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 1 if no error
	'modResponse(2) = byte count should be 1 since we only read one coil
	'modResponse(3) = data byte
	'modResponse(4) = CRC low byte
	'modResponse(5) = CRC high byte
	
	'ReadBin #204, modResponse(), 6
	i = 0
	Do While True
		portStatus = ChkNet(204)
		If portStatus > 0 Then
			ReadBin #204, modByteRx(), 1
			modResponse(i) = modByteRx(0)
		ElseIf portStatus = 0 Then
			Exit Do
		Else
			Print "modbus port error: ", portStatus
		EndIf
		i = i + 1
	Loop

	If modResponse(3) = 0 Then
		modbusReadInput = False
	Else
		modbusReadInput = True
	EndIf
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(6)
	If validResponse = False Then
		erModbusCommand = True
	EndIf
	
Fend
