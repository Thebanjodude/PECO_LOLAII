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
		Print "MODBUS: write buffer overflow - write not commited"
		Exit Function
	EndIf
	
'	Print "MODBUS: queueing request", Address, Value, Type
	
	' prevent multiple calls to mbwrite from stomping on each other
'	SyncLock 1  'I will need to play with this since I'm not seeing how it is blocking -- it just throws an error according the help file...  SJE
	
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
'	SyncUnlock 1
Fend
' function runs as a stand alone task to monitor modbus write queue
' and send commands to PLC
Function MBCommandTask()
	Boolean temp_bool
	Boolean abSelect
	Integer CurrentReadNum
	Integer MBNumReadValues
	Integer portStatus
	Long result
	
	CurrentReadNum = 1
	MBNumReadValues = 28
	
	Integer count
	Integer maxCount
	
	count = 0
	maxCount = 10
	
	' set up the TCP port on the HMI that we use to tunnel to serial ports	
	' the IP is the HMI's IP address the port is the port that is tied to
	' the matching FPGA serial port line termination is somewhat irrelavent
	' since we are using the binary send and receive the timeout is set to
	' 20ms which is almost 6 times the theoritial tranfer time of the typical 7 byte transfer
	SetNet #204, "10.22.251.171", 7352, CR, NONE, .02
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
			Print "MODBUS: portStatus is: ", portStatus
			' if we are unable to open it set an error and abort
			If portStatus < 0 Then
				Print "MODBUS: port error, port status is:", portStatus
				erModbusPort = True
				Exit Function
			EndIf
		EndIf

		'perform reads not more than twice per second, giving priority to writes
		Do While Tmr(1) < 0.5
			If MBQueueHead <> MBQueueTail Then
				'a write command has shown up, give it priority
                Exit Do
			EndIf
			Wait 0.1
		Loop
		
		'if the queue isn't empty there is something to do
		If MBQueueHead <> MBQueueTail Then
			'Print "MODBUS: something in the queue!"
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
				Print "MODBUS: error with write, invalid MBQueueType"
			EndIf
		Else
			'Read data from the PLC
			
			'Print "MODBUS: Time since last modbus read: ", Tmr(1)
			
			'restart the timer so that we can come back and check to 
			'see if a 0.5 second has passed
			TmReset 1

			'read the data off of the PLC
			' start at modbus address 0x0014 (PLC memory location D20)
			' and read the next 49 regs ending at modbus address 0x044 (inclusive)
			' (PLC memory location D68, inclusive)
			' the result will be stored in modResponse, us modGetResult to pull values

			If count < maxCount Then
				'read the six time sensitive regs
				modbusReadMultipleRegister(&h0014, 6)
			Else
				'do a full read, get everything else
				modbusReadMultipleRegister(&h0014, 49)
			EndIf
			
'			Print "MODBUS: Time to pull data from PLC: ", Tmr(1)
			
			'process the data
			' the results should be stored in modResponse()
			' so pull them out and map them to vars
			pasCrowding = BTst(modResponse(5), 15)
			pasMessageDB = LShift(modResponse(9), 8) + modResponse(10)
			pasInsertDetected = BTst(modResponse(5), 8)
			pasSteelInsert = BTst(modResponse(5), 9)
			pasShuttleMidway = BTst(modResponse(5), 10)
			pasShuttleLoadPosition = BTst(modResponse(5), 11)
			pasShuttleNoLoad = BTst(modResponse(5), 12)
			pasShuttleExtend = BTst(modResponse(5), 13)
			pasInsertInShuttle = BTst(modResponse(5), 14)
			pasHeadDown = BTst(modResponse(4), 5)
			pasHeadUp = BTst(modResponse(4), 6)
			pasSlideExtend = BTst(modResponse(4), 7)
			pasInsertGripper = BTst(modResponse(3), 8)
			pas1inLoadInsertCylinder = BTst(modResponse(3), 9)
			pasBowlDumpOpen = BTst(modResponse(3), 10)
			pasVibTrack = BTst(modResponse(3), 11)
			pasBowlFeeder = BTst(modResponse(3), 12)
			pasBlowInsert = BTst(modResponse(3), 13)
			pasMCREStop = BTst(modResponse(8), 6)
			pasStart = BTst(modResponse(8), 7)
			pasHeadinsertPickupRetract = BTst(modResponse(7), 8)
			pasHeadinsertpickupextend = BTst(modResponse(7), 9)
			pasVerticalLocation = (LShift((LShift(modResponse(11), 8) + modResponse(12)), 16) + ((LShift(modResponse(13), 8) + modResponse(14)) And &hFFFF)) * .000000762939
			pasHome = BTst(modResponse(6), 2)
			
			'check to see if we are doing a full read
			If count >= maxCount Then
				pasPreHeatActual = (LShift(modResponse(65), 8) + modResponse(66)) * 0.1
				pasDwellActual = (LShift(modResponse(67), 8) + modResponse(68)) * 0.1
				pasCoolActual = (LShift(modResponse(69), 8) + modResponse(70)) * 0.1
				pasSoftHome = (LShift((LShift(modResponse(35), 8) + modResponse(36)), 16) + ((LShift(modResponse(37), 8) + modResponse(38)) And &hFFFF)) * .000000762939
				pasInsertPosition = (LShift((LShift(modResponse(43), 8) + modResponse(44)), 16) + ((LShift(modResponse(45), 8) + modResponse(46)) And &hFFFF)) * .000000762939
				pasInsertDepth = (LShift((LShift(modResponse(19), 8) + modResponse(20)), 16) + ((LShift(modResponse(21), 8) + modResponse(22)) And &hFFFF)) * .000000762939
				pasSoftStop = (LShift((LShift(modResponse(15), 8) + modResponse(16)), 16) + ((LShift(modResponse(17), 8) + modResponse(18)) And &hFFFF)) * .000000762939
				pasHomeIPM = (LShift((LShift(modResponse(39), 8) + modResponse(40)), 16) + ((LShift(modResponse(41), 8) + modResponse(42)) And &hFFFF)) * .0000457764
				pasInsertPickupIPM = (LShift((LShift(modResponse(47), 8) + modResponse(48)), 16) + ((LShift(modResponse(49), 8) + modResponse(50)) And &hFFFF)) * .0000457764
				pasHeatStakingIPM = (LShift((LShift(modResponse(23), 8) + modResponse(24)), 16) + ((LShift(modResponse(25), 8) + modResponse(26)) And &hFFFF)) * .0000457764
				pasInsertEngageIPM = (LShift((LShift(modResponse(31), 8) + modResponse(32)), 16) + ((LShift(modResponse(33), 8) + modResponse(34)) And &hFFFF)) * .0000457764
				pasInsertEngage = (LShift((LShift(modResponse(27), 8) + modResponse(28)), 16) + ((LShift(modResponse(29), 8) + modResponse(30)) And &hFFFF)) * .000000762939
				pasSetTempZone1 = LShift(modResponse(59), 8) + modResponse(60)
				pasSetTempZone2 = LShift(modResponse(63), 8) + modResponse(64)
				pasActualTempZone1 = LShift(modResponse(57), 8) + modResponse(58)
				pasActualTempZone2 = LShift(modResponse(61), 8) + modResponse(62)
				pasPIDsetupMaxTempZone1 = LShift(modResponse(87), 8) + modResponse(88)
				pasPIDsetupMaxTempZone2 = LShift(modResponse(89), 8) + modResponse(90)
				pasPIDsetupInTempZone1 = LShift(modResponse(83), 8) + modResponse(84)
				pasPIDsetupInTempZone2 = LShift(modResponse(85), 8) + modResponse(86)
				pasPIDsetupOffsetZone1 = LShift(modResponse(91), 8) + modResponse(92)
				pasPIDsetupOffsetZone2 = LShift(modResponse(93), 8) + modResponse(94)
				pasPIDsetupPZone1 = LShift(modResponse(71), 8) + modResponse(72)
				pasPIDsetupIZone1 = LShift(modResponse(75), 8) + modResponse(76)
				pasPIDsetupDZone1 = LShift(modResponse(79), 8) + modResponse(80)
				pasPIDsetupPZone2 = LShift(modResponse(73), 8) + modResponse(74)
				pasPIDsetupIZone2 = LShift(modResponse(77), 8) + modResponse(78)
				pasPIDsetupDZone2 = LShift(modResponse(81), 8) + modResponse(82)
				pasInsertPreheat = (LShift(modResponse(95), 8) + modResponse(96)) * 0.1
				pasDwell = (LShift(modResponse(97), 8) + modResponse(98)) * 0.1
				pasCool = (LShift(modResponse(99), 8) + modResponse(100)) * 0.1
				pasJogSpeed = (LShift(modResponse(55), 8) + modResponse(56)) * 0.5
				pasMaxLoadmeter = (LShift(modResponse(53), 8) + modResponse(54)) * 0.1
				pasLoadMeter = (LShift(modResponse(51), 8) + modResponse(52)) * -0.1
				pasHighTempAlarm = BTst(modResponse(8), 1)
				pasInsertType = BTst(modResponse(6), 7)
				pasTempOnOff = BTst(modResponse(4), 4)
				pasMasterTemp = BTst(modResponse(8), 0)
				pasUpLimit = BTst(modResponse(6), 0)
				pasLowerlimit = BTst(modResponse(6), 1)
				pasOTAOnOffZone1 = BTst(modResponse(8), 2)
				pasOTAOnOffZone2 = BTst(modResponse(8), 3)
				pasOnOffZone1 = BTst(modResponse(6), 3)
				pasOnOffZone2 = BTst(modResponse(6), 4)
				pasMaxTempOnOffZone1 = BTst(modResponse(8), 4)
				pasMaxTempOnOffZone2 = BTst(modResponse(8), 5)
				pasMaxTempZone1 = BTst(modResponse(3), 14)
				pasMaxTempZone2 = BTst(modResponse(3), 15)
				pasPIDTuneDoneZone1 = BTst(modResponse(6), 5)
				pasPIDTuneDoneZone2 = BTst(modResponse(6), 6)
				pasPIDTuneFailZone1 = BTst(modResponse(4), 0)
				pasPIDTuneFailZone2 = BTst(modResponse(4), 1)
				pasInTempZone1 = BTst(modResponse(4), 2)
				pasInTempZone2 = BTst(modResponse(4), 3)
			EndIf
			
			count = count + 1
			
			If count > maxCount Then
				count = 0
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
	'Print "outer loop running from 0 to ", modLength - 3
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

	If (modResponse(modLength - 2) = (CRC And &hFF)) And (modResponse(modLength - 1) = RShift(CRC, 8)) Then
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
	
	Long CRC
	
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
	If modbusReadPort(8) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read(after write) plc register address: ", Hex$(regNum)
		'exit function
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
	
	'build the command and send it to PLC
	' function code		0x03
	' address high 		0x00
	' address low		0x02
	' No. of Regs high 	0x00
	' No. of Regs low	0x01
	modMessage(0) = MBMitsubishiAddress
	modMessage(1) = MBCmdReadRegister ' function code
	modMessage(2) = RShift(regNum, 8) ' high byte of address
	modMessage(3) = regNum And &hFF ' low byte of address
	modMessage(4) = 0 ' high byte of No. of regs is always zero 
	modMessage(5) = 1 ' low byte of No. of regs is one i.e. read one register
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8

	'process the response or timeout 
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 3 if no error
	'modResponse(2) = No. Bytes returned. Should be 2 for one 16 bit register
	'modResponse(3) = value returned high byte
	'modResponse(4) = value returned low byte
	'modResponse(5) = CRC low byte
	'modResponse(6) = CRC high byte
	
'	ReadBin #204, modResponse(), 7
	If modbusReadPort(7) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc register address: ", Hex$(regNum)
		'exit function
	EndIf

	modbusReadRegister = LShift(modResponse(3), 8) + modResponse(4)

Fend

' This function is for reading a single 16 bit Modbus inpur register from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge.
' It will then wait for a response from the PLC
Function modbusReadInputRegister(regNum As Long) As Long
	
	Long CRC
	
	'build the command and send it to PLC
	' function code		0x04
	' address high 		0x00
	' address low		0x02
	' No. of Regs high 	0x00
	' No. of Regs low	0x01
	modMessage(0) = MBMitsubishiAddress
	modMessage(1) = MBCmdReadInputRegister ' function code
	modMessage(2) = RShift(regNum, 8) ' high byte of address
	modMessage(3) = regNum And &hFF ' low byte of address
	modMessage(4) = 0 ' high byte of No. of regs is always zero 
	modMessage(5) = 1 ' low byte of No. of regs is one i.e. read one register
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8

	'process the response or timeout 
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 4 if no error
	'modResponse(2) = No. Bytes returned. Should be 2 for one 16 bit register
	'modResponse(3) = value returned high byte
	'modResponse(4) = value returned low byte
	'modResponse(5) = CRC low byte
	'modResponse(6) = CRC high byte
	
'	ReadBin #204, modResponse(), 7
	If modbusReadPort(7) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc register address: ", Hex$(regNum)
		'exit function
	EndIf

	modbusReadInputRegister = LShift(modResponse(3), 8) + modResponse(4)

Fend

' This function is for reading a multiple 16 bit Modbus registers from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge.
' It will then wait for a response from the PLC
' 
' ****************************************************************************
' **********  This function relies upon the global modResponse()  ************
' **********  It should only be called from the MBCommandTask()   ************
' ****************************************************************************
Function modbusReadMultipleRegister(regNum As Long, numRegToRead As Long)
	
	Long CRC
	
	'build the command and send it to PLC
	' function code		0x03
	' address high 		0x00
	' address low		0x14
	' No. of Regs high 	0x00
	' No. of Regs low	0x31
	modMessage(0) = MBMitsubishiAddress
	modMessage(1) = MBCmdReadRegister ' function code
	modMessage(2) = RShift(regNum, 8) ' high byte of address
	modMessage(3) = regNum And &hFF ' low byte of address
	modMessage(4) = RShift(numRegToRead, 8) ' high byte of No. of regs
	modMessage(5) = numRegToRead And &hFF ' low byte of No. of regs
	CRC = modbusCRC(6) ' get the CRC of these 6 bytes
	modMessage(6) = CRC And &hFF ' low byte of CRC is first 
	modMessage(7) = RShift(CRC, 8) ' then the high byte of the CRC
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8

	'process the response or timeout 
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 3 if no error
	'modResponse(2) = No. Bytes returned. Should be 2 * numRegToRead
	'modResponse(3) = first value returned high byte
	'modResponse(4) = first value returned low byte
	' ...
	'modResponse(numRegToRead - 1) = last value returned high byte
	'modResponse(numRegToRead    ) = last value returned low byte
	'modResponse(numRegToRead + 4) = CRC low byte
	'modResponse(numRegToRead + 5) = CRC high byte

	'numRegToRead (16 bit) * 2 (mobus is 8 bit) + 6 (overhead)
	If modbusReadPort(numRegToRead * 2 + 6) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc register address: ", Hex$(regNum)
		'exit function
	EndIf
Fend


' This function is for writing a single Modbus coil on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return a ??? for success or -1 for failure
Function modbusWriteCoil(coilNum As Long, value As Boolean)
	
	Long CRC

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
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 8
	
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
	If modbusReadPort(8) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read(after write) plc address: ", Hex$(coilNum)
		'exit function
	EndIf
Fend

' This function is for reading a single Modbus coil on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return the coil status
Function modbusReadCoil(coilNum As Long)
	
	Long CRC

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
	
	' process the response or timeout
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 1 if no error
	'modResponse(2) = byte count should be 1 since we only read one coil
	'modResponse(3) = data byte
	'modResponse(4) = CRC low byte
	'modResponse(5) = CRC high byte

'	ReadBin #204, modResponse(), 6
	If modbusReadPort(6) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc coil address: ", Hex$(coilNum)
		'exit function
	EndIf
	
	If modResponse(3) And &h01 Then
		modbusReadCoil = True
	Else
		modbusReadCoil = False
	EndIf
Fend

' This function is for reading a single Modbus input on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge
' It will then wait for a response and return the input status
Function modbusReadInput(inputNum As Long)
	
	Long CRC
	
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

	' send the message to the PLC
	WriteBin #204, modMessage(), 8

	'modResponse(0) = address of master
	'modResponse(1) = function. Should be 1 if no error
	'modResponse(2) = byte count should be 1 since we only read one coil
	'modResponse(3) = data byte
	'modResponse(4) = CRC low byte
	'modResponse(5) = CRC high byte
	
	'ReadBin #204, modResponse(), 6
	If modbusReadPort(6) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc input address: ", Hex$(inputNum)
		'exit function
	EndIf

	If modResponse(3) = 0 Then
		modbusReadInput = False
	Else
		modbusReadInput = True
	EndIf

Fend

'this function will provide read support from the modbus port
' and return the number of bytes read
' or return -1 on error
Function modbusReadPort(length As Integer) As Integer
	Integer i, j
	Integer portStatus
	Integer modByteRx(1)

	'clear the response buffer
	Redim modResponse(256)

	'give the port a chance to transmit and the PLC a chance to respond
	Wait 0.1

	i = 0
	Do While True
		'only read off of the port what it has available
		portStatus = ChkNet(204)
        If portStatus > 0 Then
			ReadBin #204, modByteRx(), 1
			modResponse(i) = modByteRx(0)
		ElseIf portStatus = 0 Then
			Exit Do
		Else
			Print "MODBUS: modbus port error: ", portStatus
			modbusReadPort = -1
			Exit Function
		EndIf
		
		i = i + 1
	Loop

	If i < 6 Then
		'we failed to rx a full modbus response -- bail
		Print "MODBUS: failed to rx full modbus response packet, only ", i, " bytes rx'd, expected ", length, " bytes"
		modbusReadPort = -1
		Exit Function
	EndIf

	If i > length Then
		'for some reason we received too many bytes -- bail
		Print "MODBUS: response from PLC was larger than expected, num bytes rx'd/bytes expected: ", i, "/", length
		For j = 0 To i
			Print "MODBUS: packet(", j, "): ", modResponse(j)
		Next
		modbusReadPort = -1
		Exit Function
	EndIf
	
	If BTst(modResponse(1), 7) = True Then
	'If modResponse(1) > 128 Then
		String mbError$
		'PLC set the error bit, get the error code
		Select modResponse(2)
			Case 01
				mbError$ = "0x01 - ILLEGAL FUNCTION"
			Case 02
				mbError$ = "0x01 - ILLEGAL DATA ADDRESS"
			Case 03
				mbError$ = "0x01 - ILLEGAL DATA VALUE"
			Case 04
				mbError$ = "0x01 - SLAVE DEVICE FAILURE"
			Case 05
				mbError$ = "0x01 - ACKNOWLEDGE"
			Case 06
				mbError$ = "0x01 - SLAVE DEVICE BUSY"
			Case 08
				mbError$ = "0x01 - MEMORY PARITY ERROR"
			Case 11 ' 0x0A
				mbError$ = "0x01 - GATEWAY PATH UNAVAILABLE"
			Case 12 ' 0x0B
				mbError$ = "0x01 - GATEWAY TARGET DEVICE FAILED TO RESPOND"
			Default
				mbError$ = "0x" + Hex$(modResponse(2)) + " - UNKNOWN MODBUS ERROR"
		Send
		'the function code in an error = 0x80 + function, so subtracting 0x80 gives us the function code for display purposes 
		Print "MODBUS: error bit was set in response to read, function/exception code is: ", Hex$(modResponse(1) - (&h80)), " / ", mbError$
		modbusReadPort = -1
		Exit Function
	EndIf
	
	' check for valid response CRC
	If modbusResponseCRC(i) = False Then
		Print "MODBUS: invalid CRC on read"
		modbusReadPort = -1
		Exit Function
	EndIf
	
	'return the number of bytes read
	modbusReadPort = i
Fend

