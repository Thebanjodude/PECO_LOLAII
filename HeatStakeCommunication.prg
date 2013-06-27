#include "Globals.INC"

'modbus monitoring variables
Boolean ErModbusTimeout 'did not recieve response before timeout
Boolean ErModbusPort ' TCP port to HMI is not open
Boolean ErModbusCommand ' Invalid command or parameter in modbus communication

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
	ErModbusTimeout = False
	ErModbusCommand = False
	ErModbusPort = False
	
	' initialize queue pointers
	MBQueueHead = 0
	MBQueueTail = 0
	
	' kick off the command processing task
	Xqt 9, MBCommandTask, NoEmgAbort
	
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
	
	CurrentReadNum = 1
	MBNumReadValues = 116
	
	' set up the TCP port on the HMI that we use to tunnel to serial ports	
	' the IP is the HMI's IP address the port is the port that is tied to
	' the matching FPGA serial port line termination is somewhat irrelavent
	' since we are using the binary send and receive the timeout is set to
	' 20ms which is almost 6 times the theoritial tranfer time of the typical 7 byte transfer
	SetNet #204, "10.22.251.171", 7352, CR, NONE, 0.1
	OpenNet #204 As Client
	
	' each time through this infinite loop one modbus command will be executed.
	' If there are commands to be written they will be removed from the queue
	' and written, otherwise the next modbus read will be executed 
	' any communication or CRC errors will abort this background task at which
	' time it will require a call to MBinitialize to set things up and kick
	' this off again.
	Do While 1
		
		'Print ".",
		
		' if the port is not open try to open it
		portStatus = ChkNet(204)
		If portStatus < 0 Then
			OpenNet #204 As Client
			Wait 1
			portStatus = ChkNet(204)
			Print "portStatus is: ", portStatus
			Wait 10
			' if we are unable to open it set an error and abort
			If portStatus < 0 Then
				ErModbusPort = True
				Exit Function
			EndIf
		EndIf
		
		'if the queue isn't empty there is something to do
		If MBQueueHead <> MBQueueTail Then
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
			Select CurrentReadNum
				Case 1
					pasAlarmGroup = modbusReadInput(&h0032)
				Case 2
					pasRemoteAlarmAcknowledge = modbusReadInput(&h0034)
				Case 3
					pasHighTempAlarm = modbusReadInput(&h0402)
				Case 4
					pasInsertType = modbusReadInput(&h0230)
				Case 5
					pasGoHome = modbusReadInput(&h0001)
				Case 6
					pasInsertDetected = modbusReadInput(&h0384)
				Case 7
					pasSteelInsert = modbusReadInput(&h0385)
				Case 8
					pasShuttleLoadPosition = modbusReadInput(&h0388)
				Case 9
					pasShuttleNoLoad = modbusReadInput(&h0389)
				Case 10
					pasShuttleExtend = modbusReadInput(&h038A)
				Case 11
					pasInsertInShuttle = modbusReadInput(&h038B)
				Case 12
					pasShuttleMidway = modbusReadInput(&h0386)
				Case 13
					pasHeadDown = modbusReadInput(&h0014)
				Case 14
					pasHeadUp = modbusReadInput(&h0015)
				Case 15
					pasResetMax = modbusReadInput(&h0069)
				Case 16
					pasResetHighTemp = modbusReadInput(&h03F9)
				Case 17
					pasTempOnOff = modbusReadInput(&h000D)
				Case 18
					pasMasterTemp = modbusReadInput(&h0401)
				Case 19
					pasUpLimit = modbusReadInput(&h0055)
				Case 20
					pasLowerlimit = modbusReadInput(&h0056)
				Case 21
					pasHome = modbusReadInput(&h0057)
				Case 22
					pasMCREStop = modbusReadInput(&h3400)
				Case 23
					pasStart = modbusReadInput(&h3401)
				Case 24
					pasHeadinsertPickupRetract = modbusReadInput(&h3406)
				Case 25
					pasHeadinsertpickupextend = modbusReadInput(&h3407)
				Case 26
					pasSlideExtend = modbusReadInput(&h0017)
				Case 27
					pas1inLoadInsertCylinder = modbusReadInput(&h0019)
				Case 28
					pasBowlDumpOpen = modbusReadInput(&h001B)
				Case 29
					pasBlowInsert = modbusReadInput(&h001E)
				Case 30
					pasVibTrack = modbusReadInput(&h001C)
				Case 31
					pasBowlFeeder = modbusReadInput(&h001D)
				Case 32
					pasInsertGripper = modbusReadInput(&h0018)
				Case 33
					pasOTAOnOffZone1 = modbusReadInput(&h0403)
				Case 34
					pasOTAOnOffZone2 = modbusReadInput(&h0404)
				Case 35
					'pasOTAOnOffZone3 = modbusReadInput(&h0405)
				Case 36
					'pasOTAOnOffZone4 = modbusReadInput(&h0406)
				Case 37
					pasOnOffZone1 = modbusReadInput(&h012C)
				Case 38
					pasOnOffZone2 = modbusReadInput(&h012D)
				Case 39
					pasOnOffZone3 = modbusReadInput(&h012E)
				Case 40
					pasOnOffZone4 = modbusReadInput(&h012F)
				Case 41
					pasMaxTempOnOffZone1 = modbusReadInput(&h040D)
				Case 42
					pasMaxTempOnOffZone2 = modbusReadInput(&h040E)
				Case 43
					'pasMaxTempOnOffZone3 = modbusReadInput(&h040F)
				Case 44
					'pasMaxTempOnOffZone4 = modbusReadInput(&h0410)
				Case 45
					pasMaxTempZone1 = modbusReadInput(&h0028)
				Case 46
					pasMaxTempZone2 = modbusReadInput(&h0029)
				Case 47
					pasMaxTempZone3 = modbusReadInput(&h002A)
				Case 48
					pasMaxTempZone4 = modbusReadInput(&h002B)
				Case 49
					pasStartPIDTuneZone1 = modbusReadInput(&h0132)
				Case 50
					pasStartPIDTuneZone2 = modbusReadInput(&h0133)
				Case 51
					'pasStartPIDTuneZone4 = modbusReadInput(&h0135)
				Case 52
					pasPIDTuneDoneZone1 = modbusReadInput(&h0138)
				Case 53
					pasPIDTuneDoneZone2 = modbusReadInput(&h0139)
				Case 54
					pasPIDTuneDoneZone3 = modbusReadInput(&h013B)
				Case 55
					pasMessageDB = modbusReadRegister(&h0009)
				Case 56
					pasSoftHome = LShift(modbusReadRegister(&h00FE), 16)
					pasSoftHome = pasSoftHome + modbusReadRegister(&h00FF) And &hFFFF
					'7.62939e-007
					pasSoftHome = pasSoftHome * .000000762939
				Case 57
					pasInsertPosition = LShift(modbusReadRegister(&h0100), 16)
					pasInsertPosition = pasInsertPosition + modbusReadRegister(&h0101) And &hFFFF
					pasInsertPosition = pasInsertPosition * .000000762939
				Case 58
					pasInsertDepth = LShift(modbusReadRegister(&h0102), 16)
					pasInsertDepth = pasInsertDepth + modbusReadRegister(&h103) And &hFFFF
					pasInsertDepth = pasInsertDepth * .000000762939
				Case 59
					pasSoftStop = LShift(modbusReadRegister(&h0104), 16)
					pasSoftStop = pasSoftStop + modbusReadRegister(&h0105) And &hFFFF
					pasSoftStop = pasSoftStop * .000000762939
				Case 60
					pasHomeIPM = LShift(modbusReadRegister(&h0106), 16)
					pasHomeIPM = pasHomeIPM + modbusReadRegister(&h0107) And &hFFFF
					'4.57764e-005
					pasHomeIPM = pasHomeIPM * .0000457764
				Case 61
					pasInsertPickupIPM = LShift(modbusReadRegister(&h0108), 16)
					pasInsertPickupIPM = pasInsertPickupIPM + modbusReadRegister(&h0109) And &hFFFF
					pasInsertPickupIPM = pasInsertPickupIPM * .0000457764
				Case 62
					pasHeatStakingIPM = LShift(modbusReadRegister(&h010A), 16)
					pasHeatStakingIPM = pasHeatStakingIPM + modbusReadRegister(&h010B) And &hFFFF
					pasHeatStakingIPM = pasHeatStakingIPM * .0000457764
				Case 63
					pasInsertEngageIPM = LShift(modbusReadRegister(&h010E), 16)
					pasInsertEngageIPM = pasInsertEngageIPM + modbusReadRegister(&h010F) And &hFFFF
					pasInsertEngageIPM = pasInsertEngageIPM * .0000457764
				Case 64
					pasInsertEngage = LShift(modbusReadRegister(&h0118), 16)
					pasInsertEngage = pasInsertEngage + modbusReadRegister(&h0119) And &hFFFF
					pasInsertEngage = pasInsertEngage * .000000762939
				Case 65
					pasSetTempZone1 = modbusReadRegister(&h012C)
				Case 66
					pasPIDsetupSetPointZone1 = modbusReadRegister(&h012C)
				Case 67
					pasSetTempZone2 = modbusReadRegister(&h012D)
				Case 68
					pasPIDsetupSetPointZone2 = modbusReadRegister(&h012D)
				Case 69
					pasPIDsetupSetPointZone3 = modbusReadRegister(&h012E)
				Case 70
					pasPIDsetupSetPointZone4 = modbusReadRegister(&h012F)
				Case 71
					pasActualTempZone1 = modbusReadRegister(&h0132) ' should these be the same?
					Print "getting temp", pasActualTempZone1
				Case 72
					pasPIDsetupActualZone1 = modbusReadRegister(&h0132) ' should these be the same?
				Case 73
					pasActualTempZone2 = modbusReadRegister(&h0133)
				Case 74
					pasPIDsetupActualZone2 = modbusReadRegister(&h0133)
				Case 75
					'pasPIDsetupActualZone3 = modbusReadRegister(&h0134)
				Case 76
					'pasPIDsetupActualZone4 = modbusReadRegister(&h0135)
				Case 77
					pasPIDsetupMaxTempZone1 = modbusReadRegister(&h0138)
				Case 78
					pasPIDsetupMaxTempZone2 = modbusReadRegister(&h0139)
				Case 79
					'pasPIDsetupMaxTempZone3 = modbusReadRegister(&h013A)
				Case 80
					'pasPIDsetupMaxTempZone4 = modbusReadRegister(&h013B)
				Case 81
					pasPIDsetupInTempZone1 = modbusReadRegister(&h0149)
				Case 82
					pasPIDsetupInTempZone2 = modbusReadRegister(&h014A)
				Case 83
					'pasPIDsetupInTempZone3 = modbusReadRegister(&h014B)
				Case 84
					'pasPIDsetupInTempZone4 = modbusReadRegister(&h014C)
				Case 85
					pasPIDsetupOffsetZone1 = modbusReadRegister(&h015A)
				Case 86
					pasPIDsetupOffsetZone2 = modbusReadRegister(&h015B)
				Case 87
					'pasPIDsetupOffsetZone3 = modbusReadRegister(&h015C)
				Case 88
					'pasPIDsetupOffsetZone4 = modbusReadRegister(&h015D)
				Case 89
					pasPIDsetupPZone1 = modbusReadRegister(&h0164)
				Case 90
					pasPIDShowPZone1 = modbusReadRegister(&h0164)
				Case 91
					pasPIDsetupIZone1 = modbusReadRegister(&h0165)
				Case 92
					pasPIDShowPZone2 = modbusReadRegister(&h0165)
				Case 93
					pasPIDsetupDZone1 = modbusReadRegister(&h0166)
				Case 94
					pasPIDShowIZone1 = modbusReadRegister(&h0168)
				Case 95
					pasPIDShowIZone2 = modbusReadRegister(&h0169)
				Case 96
					pasPIDShowDZone1 = modbusReadRegister(&h016C)
				Case 97
					pasPIDShowDZone2 = modbusReadRegister(&h016D)
				Case 98
					pasPIDsetupPZone2 = modbusReadRegister(&h016E)
				Case 99
					pasPIDsetupIZone2 = modbusReadRegister(&h016F)
				Case 100
					pasPIDsetupDZone2 = modbusReadRegister(&h0170)
				Case 101
				'	pasPIDsetupPZone3 = modbusReadRegister(&h0178)
				Case 102
				'	pasPIDsetupIZone3 = modbusReadRegister(&h0179)
				Case 103
				'	pasPIDsetupDZone3 = modbusReadRegister(&h017A)
				Case 104
					'pasPIDsetupPZone4 = modbusReadRegister(&h0182)
				Case 105
				'	pasPIDsetupIZone4 = modbusReadRegister(&h0183)
				Case 106
				'	pasPIDsetupDZone4 = modbusReadRegister(&h0184)
				Case 107
					pasInsertPreheat = modbusReadRegister(&h0190)
				Case 108
					Print "*"
					pasDwell = modbusReadRegister(&h0191)
				Case 109
					pasCool = modbusReadRegister(&h0192)
				Case 110
					pasRecipe = modbusReadRegister(&h01C2)
				Case 111
					pasJogSpeed = modbusReadRegister(&h01FE)
				Case 112
					pasMaxLoadmeter = modbusReadRegister(&h0265)
				Case 113
					pasLoadMeter = modbusReadRegister(&h028B)
				Case 114
					pasPreHeatActual = modbusReadRegister(&hA147)
				Case 115
					pasDwellActual = modbusReadRegister(&hA148)
				Case 116
					pasCoolActual = modbusReadRegister(&hA149)
					
				'Default
				'	MBNumReadValues = CurrentReadNum - 1
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
Function inches2Modbus(inches As Long) As Long
	' 7.62939e-007
	inches2Modbus = inches /.000000762939
Fend
' Given a time in seconds (stored in a real) this fuction
' will perform the appropriate transfer function and bit twiddling
' to return a long that can be sent to modbusWriteRegister
Function seconds2Modbus(seconds As Long) As Long
	seconds2Modbus = seconds / -0.1
Fend
' function receives jog speed as number from 1 to 100 and 
' performs transfer function and bit twiddling to return
' a value that can be sent to modbusWriteRegister
Function JogRate2Modbus(jog As Real) As Long
	JogRate2Modbus = jog /0.005
Fend
Function modbusWrite32Register(regNum As Long, value As Long) As Integer
	modbusWriteRegister(regNum, RShift(value, 16))
	modbusWriteRegister(regNum + 1, value And &hFFFF)
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
	ReadBin #204, modResponse(), 8
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(8)
	If validResponse = False Then
		ErModbusCommand = True
	EndIf
	
Fend
Function modbusRead32Register(regNum As Long) As Long
	Long msw
	Long lsw

	msw = modbusReadRegister(regNum)
	lsw = modbusReadRegister(regNum + 1)
	
	modbusRead32Register = LShift(msw, 16) + (lsw And &hFFFF)

Fend

' This function is for reading a single 16 bit Modbus register from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' using the HMI ethernet to serial dameon as a bridge.
' It will then wait for a response from the PLC
Function modbusReadRegister(regNum As Long) As Long
	
	Long CRC
	Integer i
	Boolean validResponse
	
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
	ReadBin #204, modResponse(), 7
	
	If regNum = &h01FE Then
		Print modResponse(0)
		Print modResponse(1)
		Print modResponse(2)
		Print modResponse(3)
		Print modResponse(4)
		Print modResponse(5)
		Print modResponse(6)
	EndIf
	
		Print modResponse(3)
		Print modResponse(4)
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(7) ' TODO: Fix this, it returns false
	If validResponse = False Then
		ErModbusCommand = True
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
	ReadBin #204, modResponse(), 8
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(8)
	If validResponse = False Then
		ErModbusCommand = True
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
	ReadBin #204, modResponse(), 6
	If modResponse(3) And &h01 Then
		modbusReadCoil = True
	Else
		modbusReadCoil = False
	EndIf
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(6)
	If validResponse = False Then
		ErModbusCommand = True
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
	
	ReadBin #204, modResponse(), 6

	If modResponse(3) = 0 Then
		modbusReadInput = False
	Else
		modbusReadInput = True
	EndIf
	
	' check for valid response CRC
	validResponse = modbusResponseCRC(6)
	If validResponse = False Then
		ErModbusCommand = True
	EndIf
	
Fend