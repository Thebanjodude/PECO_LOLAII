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

Integer transactionID

String CRLF$
'Integer modMessage(256)
Integer modResponse(256)
Integer modbusMessageID
Boolean testcoil
Boolean testinput


' comms globals
Boolean m_inserting
Boolean m_idle
Boolean m_ready
Boolean m_bootDelay
Boolean m_bootDone
Boolean m_findingHOme
Boolean m_dumprunning
Boolean m_manualmodeon


'testing
Function mbTest()
	Wait 3
	Do While True
		'MBWrite(1099, transactionID, MBType16)
		'MBWrite(100, Int(Tmr(1)) Mod 2, MBTypeCoil)
		Wait 1
	Loop
Fend
' <testing>
Function set_m_inserting(var As Boolean)
	m_inserting = var
Fend
Function set_m_idle(var As Boolean)
	 m_idle = var
Fend
Function set_m_ready(var As Boolean)
	 m_ready = var
Fend
Function set_m_bootDelay(var As Boolean)
	 m_bootDelay = var
Fend
Function set_m_bootDone(var As Boolean)
	 m_bootDone = var
Fend
Function set_m_findingHOme(var As Boolean)
	 m_findingHOme = var
Fend
Function set_m_dumprunning(var As Boolean)
	 m_dumprunning = var
Fend
Function set_m_manualmodeon(var As Boolean)
	 m_manualmodeon = var
Fend

' </testing>

Function MBInitialize()
	
	' clear global modbus error flags
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
	
	'Print "MODBUS: queueing request", Address, value, Type
	
	' prevent multiple calls to mbwrite from stomping on each other
'	SyncLock 1  'I will need to play with this since I'm not seeing how it is blocking -- it just throws an error according the help file...  SJE
	
	' range check against type here if I decide to become untrusting TMH
	
	' queue the request
	MBQueueAddress(MBQueueHead) = Address
	MBQueueValue(MBQueueHead) = value
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
	Integer portStatus, i
	Long inputs
	
	
' comms 
Boolean l_inserting
Boolean l_idle
Boolean l_ready
Boolean l_bootDelay
Boolean l_bootDone
Boolean l_findingHOme
Boolean l_dumprunning
Boolean l_manualmodeon
	
	
	
	' set up for the TCP port on the PLC
	SetNet #204, "10.22.251.64", 502, CR, NONE, 0.2
	'SetNet #204, "10.22.2.30", 502, CR, NONE, 0.2
		OpenNet #204 As Client
	
	' each time through this infinite loop one modbus command will be executed.
	' If there are commands to be written they will be removed from the queue
	' and written, otherwise the next modbus read will be executed 
	' any communication errors will abort this background task at which
	' time it will require a call to MBinitialize to set things up and kick
	' this off again.
	
	' give things a chance to settle
	Wait 3
	
	' retart the metering timer
	TmReset 2
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
		Do While Tmr(2) < 0.5
			If MBQueueHead <> MBQueueTail Then
				'a write command has shown up, give it priority
                Exit Do
			EndIf
			Wait 0.05
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
				'Print "writing type coil"
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
			'
			' so it turns out that memory management on this guy is weird.
			' ...the delay comes in when we try to process data that hits globals, there is a
			' ~7-10 ms penalty for every global/modual memory access.
			' That adds up fast when you are talking ~90 vars
			
			'Print "MODBUS: Time since last modbus read: ", Tmr(2)
			
			'restart the timer so that we can come back and check to 
			'see if a 0.5 second has passed
			TmReset 2

			'read the data off of the PLC
			TmReset 15
			
			'--TODO-- map plc memory & write read/write calls
			inputs = modbusReadMultipleInput(200, 8)
			' parse
			set_m_inserting(BTst(inputs, 0))
			set_m_idle(BTst(inputs, 1))
			set_m_ready(BTst(inputs, 2))
			set_m_bootDelay(BTst(inputs, 3))
			set_m_bootDone(BTst(inputs, 4))
			set_m_findingHOme(BTst(inputs, 5))
			set_m_dumprunning(BTst(inputs, 6))
			set_m_manualmodeon(BTst(inputs, 7))
			
'			inputs = modbusReadMultipleInput(300, 2)
'			' parse
'
'			inputs = modbusReadMultipleInput(400, 9)
'			' parse
'			
'			inputs = modbusReadMultipleInput(500, 11)
'			' parse

			Print "Time to obtain data - function: ", Tmr(15)
			
			TmReset 15
			inputs = modbusReadMultipleInput(200, 8)

			g_inserting = BTst(inputs, 0)
			g_idle = BTst(inputs, 1)
			g_ready = BTst(inputs, 2)
			g_bootDelay = BTst(inputs, 3)
			g_bootDone = BTst(inputs, 4)
			g_findingHOme = BTst(inputs, 5)
			g_dumprunning = BTst(inputs, 6)
			g_manualmodeon = BTst(inputs, 7)
			
			Print "Time to obtain data - global  : ", Tmr(15)
			
			
			TmReset 15
			inputs = modbusReadMultipleInput(200, 8)

			l_inserting = BTst(inputs, 0)
			l_idle = BTst(inputs, 1)
			l_ready = BTst(inputs, 2)
			l_bootDelay = BTst(inputs, 3)
			l_bootDone = BTst(inputs, 4)
			l_findingHOme = BTst(inputs, 5)
			l_dumprunning = BTst(inputs, 6)
			l_manualmodeon = BTst(inputs, 7)
			
			Print "Time to obtain data - local   : ", Tmr(15)
			
			
			TmReset 15
			inputs = modbusReadMultipleInput(200, 8)

			' slow - same as using globals
'			m_inserting = BTst(inputs, 0)
'			m_idle = BTst(inputs, 1)
'			m_ready = BTst(inputs, 2)
'			m_bootDelay = BTst(inputs, 3)
'			m_bootDone = BTst(inputs, 4)
'			m_findingHOme = BTst(inputs, 5)
'			m_dumprunning = BTst(inputs, 6)
'			m_manualmodeon = BTst(inputs, 7)
			
			' Fast - pain to code
'			If BTst(inputs, 0) Then
'				MemOn (mem_inserting)
'			Else
'				MemOff (mem_inserting)
'			EndIf
'			If BTst(inputs, 1) Then
'				MemOn (mem_idle)
'			Else
'				MemOff (mem_idle)
'			EndIf
'			If BTst(inputs, 2) Then
'				MemOn (mem_ready)
'			Else
'				MemOff (mem_ready)
'			EndIf
'			If BTst(inputs, 3) Then
'				MemOn (mem_bootDelay)
'			Else
'				MemOff (mem_bootDelay)
'			EndIf
'			If BTst(inputs, 4) Then
'				MemOn (mem_bootDone)
'			Else
'				MemOff (mem_bootDone)
'			EndIf
'			If BTst(inputs, 5) Then
'				MemOn (mem_findingHome)
'			Else
'				MemOff (mem_findingHome)
'			EndIf
'			If BTst(inputs, 6) Then
'				MemOn (mem_dumpRunning)
'			Else
'				MemOff (mem_dumpRunning)
'			EndIf
'			If BTst(inputs, 7) Then
'				MemOn (mem_manualModeOn)
'			Else
'				MemOff (mem_manualModeOn)
'			EndIf
			
			' fast -- pain to maintain
			MemOut 23, inputs
	
			Print "Time to obtain data - memory   : ", Tmr(15)
			
			
			'modbusReadMultipleRegister(1098, 2)
			'Print "reg 1098, 1099: ", LShift(modResponse(9), 8) + modResponse(10), ",", LShift(modResponse(11), 8) + modResponse(12)

		EndIf
	Loop
Fend

' This function is for writing a single 16 Modbus register on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' It will then wait for a response and return a ??? for success or -1 for failure
' calling type and return value are "Long" 
Function modbusWriteRegister(regNum As Long, value As Long) As Integer
	Integer modMessage(256)
	
	'build the command and send it to PLC
	' Transaction ID high	0x??
	' Transaction ID low	0x??
	' protocol id high		0x00
	' protocol id low		0x00
	' length high			0x00
	' length low			0x06
	' unit id				0xff
	' function code			0x06
	' address high 			0x??
	' address low			0x??
	' value high			0x??
	' value low				0x??
	
	transactionID = transactionID + 1
	modMessage(0) = RShift(transactionID, 8)
	modMessage(1) = transactionID And &hFF
	modMessage(2) = 0
	modMessage(3) = 0
	modMessage(4) = 0
	modMessage(5) = &h06
	modMessage(6) = &hFF
	modMessage(7) = MBCmdWriteRegister
	modMessage(8) = RShift(regNum, 8) ' high byte of address
	modMessage(9) = regNum And &hFF ' low byte of address
	modMessage(10) = RShift(value, 8) ' high byte of value
	modMessage(11) = value And &hFF ' low byte of value
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 12
	
	' process the response or timeout
	'wait for a predefinded timeout period of time or for the expected number of characters
	'modResponse(0) = Transaction ID high - Same ID as request
	'modResponse(1) = Transaction ID low - Same ID as request
	'modResponse(2) = protocol id high
	'modResponse(3) = protocol id low
	'modResponse(4) = length high
	'modResponse(5) = length low
	'modResponse(6) = unit id 
	'modResponse(7) = function. Should be 6 if no error
	'modResponse(8) = Register address high byte
	'modResponse(9) = Register address low byte
	'modResponse(10) = value high byte
	'modResponse(11) = value low byte
	
	If modbusReadPort(12) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read(after write) plc register address: ", Hex$(regNum)
		'exit function
	EndIf

Fend

' This function is for reading a single 16 bit Modbus register from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' It will then wait for a response from the PLC
Function modbusReadRegister(regNum As Long) As Long
	Integer modMessage(256)
	
	'build the command and send it to PLC
	' Transaction ID high	0x??
	' Transaction ID low	0x??
	' protocol id high		0x00
	' protocol id low		0x00
	' length high			0x00
	' length low			0x06
	' unit id				0xff
	' function code			0x03
	' address high 			0x??
	' address low			0x??
	' No. of Regs high 		0x00
	' No. of Regs low		0x01
	
	transactionID = transactionID + 1
	modMessage(0) = RShift(transactionID, 8)
	modMessage(1) = transactionID And &hFF
	modMessage(2) = 0
	modMessage(3) = 0
	modMessage(4) = 0
	modMessage(5) = &h06
	modMessage(6) = &hFF
	modMessage(7) = MBCmdReadRegister ' function code
	modMessage(8) = RShift(regNum, 8) ' high byte of address
	modMessage(9) = regNum And &hFF ' low byte of address
	modMessage(10) = 0 ' high byte of No. of regs is always zero 
	modMessage(11) = 1 ' low byte of No. of regs is one i.e. read one register
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 12

	'process the response or timeout 
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = Transaction ID high - Same ID as request
	'modResponse(1) = Transaction ID low - Same ID as request
	'modResponse(2) = protocol id high
	'modResponse(3) = protocol id low
	'modResponse(4) = length high
	'modResponse(5) = length low
	'modResponse(6) = unit id
	'modResponse(7) = function. Should be 3 if no error
	'modResponse(8) = No. Bytes returned. Should be 2 for one 16 bit register
	'modResponse(9) = value high byte
	'modResponse(10) = value low byte
	
	If modbusReadPort(11) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc register address: ", Hex$(regNum)
		'exit function
	EndIf

	modbusReadRegister = LShift(modResponse(9), 8) + modResponse(10)

Fend

' This function is for reading a single 16 bit Modbus input register from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' and then wait for a response from the PLC
Function modbusReadInputRegister(regNum As Long) As Long
	Integer modMessage(256)
	
	'build the command and send it to PLC
	' Transaction ID high	0x??
	' Transaction ID low	0x??
	' protocol id high		0x00
	' protocol id low		0x00
	' length high			0x00
	' length low			0x06
	' unit id				0xff
	' function code			0x04
	' address high 			0x??
	' address low			0x??
	' No. of Regs high 		0x00
	' No. of Regs low		0x01

	transactionID = transactionID + 1
	modMessage(0) = RShift(transactionID, 8)
	modMessage(1) = transactionID And &hFF
	modMessage(2) = 0
	modMessage(3) = 0
	modMessage(4) = 0
	modMessage(5) = &h06
	modMessage(6) = &hFF
	modMessage(7) = MBCmdReadInputRegister ' function code
	modMessage(8) = RShift(regNum, 8) ' high byte of address
	modMessage(9) = regNum And &hFF ' low byte of address
	modMessage(10) = 0 ' high byte of No. of regs is always zero 
	modMessage(11) = 1 ' low byte of No. of regs is one i.e. read one register
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 12

	'process the response or timeout 
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = Transaction ID high - Same ID as request
	'modResponse(1) = Transaction ID low - Same ID as request
	'modResponse(2) = protocol id high
	'modResponse(3) = protocol id low
	'modResponse(4) = length high
	'modResponse(5) = length low
	'modResponse(6) = unit id
	'modResponse(7) = function. Should be 4 if no error
	'modResponse(8) = No. Bytes returned. Should be 2 for one 16 bit register
	'modResponse(9) = value returned high byte
	'modResponse(10) = value returned low byte

	If modbusReadPort(11) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc register address: ", Hex$(regNum)
		'exit function
	EndIf

	modbusReadInputRegister = LShift(modResponse(9), 8) + modResponse(10)

Fend

' This function is for reading a multiple 16 bit Modbus registers from the PLC
' It will build a valid Modbus RTU request and send it to the PLC
' It will then wait for a response from the PLC
' 
' ****************************************************************************
' **********  This function relies upon the global modResponse()  ************
' **********  It should only be called from the MBCommandTask()   ************
' ****************************************************************************
Function modbusReadMultipleRegister(regNum As Long, numRegToRead As Long) As Boolean
	Integer modMessage(256)
	
	'build the command and send it to PLC
	' Transaction ID high	0x??
	' Transaction ID low	0x??
	' protocol id high		0x00
	' protocol id low		0x00
	' length high			0x00
	' length low			0x06
	' unit id				0xff
	' function code			0x03
	' address high 			0x00
	' address low			0x14
	' No. of Regs high 		0x00
	' No. of Regs low		0x31
		
	transactionID = transactionID + 1
	modMessage(0) = RShift(transactionID, 8)
	modMessage(1) = transactionID And &hFF
	modMessage(2) = 0
	modMessage(3) = 0
	modMessage(4) = 0
	modMessage(5) = &h06
	modMessage(6) = &hFF
	modMessage(7) = MBCmdReadRegister ' function code
	modMessage(8) = RShift(regNum, 8) ' high byte of address
	modMessage(9) = regNum And &hFF ' low byte of address
	modMessage(10) = RShift(numRegToRead, 8) ' high byte of No. of regs
	modMessage(11) = numRegToRead And &hFF ' low byte of No. of regs
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 12

	'process the response or timeout 
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = Transaction ID high - Same ID as request
	'modResponse(1) = Transaction ID low - Same ID as request
	'modResponse(2) = protocol id high
	'modResponse(3) = protocol id low
	'modResponse(4) = length high
	'modResponse(5) = length low
	'modResponse(6) = unit id
	'modResponse(7) = function. Should be 3 if no error
	'modResponse(8) = No. Bytes returned. Should be 2 * numRegToRead
	'modResponse(9) = first value returned high byte
	'modResponse(10) = first value returned low byte
	' ...
	'modResponse(numRegToRead - 1) = last value returned high byte
	'modResponse(numRegToRead    ) = last value returned low byte

	'numRegToRead (16 bit) * 2 (mobus is 8 bit) + 9 (overhead)
	If modbusReadPort(numRegToRead * 2 + 9) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc register addresses: ", Hex$(regNum), " - ", Hex$(regNum + numRegToRead)
		modbusReadMultipleRegister = False
		'Exit Function
	EndIf
	modbusReadMultipleRegister = True
Fend


' This function is for writing a single Modbus coil on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' It will then wait for a response and return a ??? for success or -1 for failure
Function modbusWriteCoil(coilNum As Long, value As Boolean)
	Integer modMessage(256)
	
	'build the command and send it to PLC
	' Transaction ID high	0x??
	' Transaction ID low	0x??
	' protocol id high		0x00
	' protocol id low		0x00
	' length high			0x00
	' length low			0x06
	' unit id				0xff
	' function code			0x05
	' address high 			0x??
	' address low			0x??
	' Output value		 	0x00 or 0xFF
	' Output value padding	0x00

	transactionID = transactionID + 1
	modMessage(0) = RShift(transactionID, 8)
	modMessage(1) = transactionID And &hFF
	modMessage(2) = 0
	modMessage(3) = 0
	modMessage(4) = 0
	modMessage(5) = &h06
	modMessage(6) = &hFF
	modMessage(7) = MBCmdWriteCoil ' function code
	modMessage(8) = RShift(coilNum, 8) ' high byte of address
	modMessage(9) = coilNum And &hFF ' low byte of address
	If value = True Then
		modMessage(10) = &hFF; ' constant for setting coil on
	Else
		modMessage(10) = 0; ' constant for setting coil off
	EndIf
	modMessage(11) = 0;
	
	' send the message to the PLC
	WriteBin #204, modMessage(), 12
	
	' process the response or timeout
	'wait for a predefinded period of time for the expected number of characters
	'modResponse(0) = Transaction ID high - Same ID as request
	'modResponse(1) = Transaction ID low - Same ID as request
	'modResponse(2) = protocol id high
	'modResponse(3) = protocol id low
	'modResponse(4) = length high
	'modResponse(5) = length low
	'modResponse(6) = unit id
	'modResponse(7) = function. Should be 5 if no error
	'modResponse(8) = Register address high byte
	'modResponse(9) = Register address low byte
	'modResponse(10) = value high byte
	'modResponse(11) = value low byte

	If modbusReadPort(12) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read(after write) plc address: ", Hex$(coilNum)
		'exit function
	EndIf
Fend

' This function is for reading a single Modbus input on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' It will then wait for a response and return the input status
Function modbusReadInput(inputNum As Long) As Boolean
	Integer modMessage(256)
	
	'build the command and send it to PLC
	' Transaction ID high	0x??
	' Transaction ID low	0x??
	' protocol id high		0x00
	' protocol id low		0x00
	' length high			0x00
	' length low			0x06
	' unit id				0xff	
	' function code			0x02
	' address high 			0x??
	' address low			0x??
	' No. of coils high 	0x00
	' No. of coils low		0x01
	transactionID = transactionID + 1
	modMessage(0) = RShift(transactionID, 8)
	modMessage(1) = transactionID And &hFF
	modMessage(2) = 0
	modMessage(3) = 0
	modMessage(4) = 0
	modMessage(5) = &h06
	modMessage(6) = &hFF
	modMessage(7) = MBCmdReadInput ' function code
	modMessage(8) = RShift(inputNum, 8) ' high byte of address
	modMessage(9) = inputNum And &hFF ' low byte of address
	modMessage(10) = 0
	modMessage(11) = 1 ' keep things simple by only allowing the read of one coil

	' send the message to the PLC
	WriteBin #204, modMessage(), 12

	'modResponse(0) = Transaction ID high - Same ID as request
	'modResponse(1) = Transaction ID low - Same ID as request
	'modResponse(2) = protocol id high
	'modResponse(3) = protocol id low
	'modResponse(4) = length high
	'modResponse(5) = length low
	'modResponse(6) = unit id
	'modResponse(7) = function. Should be 2 if no error
	'modResponse(8) = byte count should be 1 since we only read one coil
	'modResponse(9) = data byte
	
	If modbusReadPort(10) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc input address: ", Hex$(inputNum)
		'exit function
	EndIf

	If modResponse(9) = 0 Then
		modbusReadInput = False
	Else
		modbusReadInput = True
	EndIf

Fend

' This function is for reading multiple Modbus inputs on the PLC
' It will build a valid Modbus RTU message and send it to the PLC
' It will then wait for a response and return the input status
Function modbusReadMultipleInput(inputNum As Long, numberCoils As Long) As Long
	Integer modMessage(256)
	Integer readNum, j

	'build the command and send it to PLC
	' Transaction ID high	0x??
	' Transaction ID low	0x??
	' protocol id high		0x00
	' protocol id low		0x00
	' length high			0x00
	' length low			0x06
	' unit id				0xff	
	' function code			0x02
	' address high 			0x??
	' address low			0x??
	' No. of coils high 	0x00
	' No. of coils low		0x01 - 0x20
	
	transactionID = transactionID + 1
	If numberCoils > 32 Or numberCoils < 1 Then
		numberCoils = 32
		Print "Attempted to read too many coils with modbusReadMultipleInput(), only reading first 32"
	EndIf
	
	modMessage(0) = RShift(transactionID, 8)
	modMessage(1) = transactionID And &hFF
	modMessage(2) = 0
	modMessage(3) = 0
	modMessage(4) = 0
	modMessage(5) = &h06
	modMessage(6) = &hFF
	modMessage(7) = MBCmdReadInput ' function code
	modMessage(8) = RShift(inputNum, 8) ' high byte of address
	modMessage(9) = inputNum And &hFF ' low byte of address
	modMessage(10) = 0
	modMessage(11) = numberCoils

	' send the message to the PLC
	WriteBin #204, modMessage(), 12

	'modResponse(0) = Transaction ID high - Same ID as request
	'modResponse(1) = Transaction ID low - Same ID as request
	'modResponse(2) = protocol id high
	'modResponse(3) = protocol id low
	'modResponse(4) = length high
	'modResponse(5) = length low
	'modResponse(6) = unit id
	'modResponse(7) = function. Should be 2 if no error
	'modResponse(8) = byte count
	'modResponse(9) = data byte
	'...
	'modResponse(numberCoils/8 - 1) = data byte
	
	readNum = Int(numberCoils / 8)
	'and since everything on this robot seems to round down...
	If (readNum * 8) < numberCoils Then
		readNum = readNum + 1
	EndIf
	
	If modbusReadPort(9 + readNum) = -1 Then
		'we didn't get the response expected...
		Print "MODBUS: failed to read plc input address: ", Hex$(inputNum)
		'exit function
	EndIf
	
	modbusReadMultipleInput = 0
	For j = 9 To readNum + 8
		modbusReadMultipleInput = modbusReadMultipleInput + LShift(modResponse(j), (j - 9) * 8)
	Next
Fend

'this function will provide read support from the modbus port
' and return the number of bytes read
' or return -1 on error
Function modbusReadPort(length As Integer) As Integer
	Integer i, j
	Integer portStatus

	'clear the response buffer
	Redim modResponse(256)

	'give the port a chance to transmit and the PLC a chance to respond
'	Wait 0.2

' fall back solution
'	Integer modByteRx(1)
'	i = 0
'	Do While True
'		'only read off of the port what it has available
'		portStatus = ChkNet(204)
'        If portStatus > 0 Then
'			ReadBin #204, modByteRx(), 1
'			modResponse(i) = modByteRx(0)
'		ElseIf portStatus = 0 Then
'			Exit Do
'		Else
'			Print "MODBUS: modbus port error: ", portStatus
'			modbusReadPort = -1
'			Exit Function
'		EndIf
'		
'		i = i + 1
'	Loop

'-----------------------------------------------------
' alt. solution
	' get number of bytes available to read
	portStatus = ChkNet(204)
	' read said number of bytes
	ReadBin #204, modResponse(), portStatus
	' let the rest of the function know what to expect for num bytes read
	i = portStatus
	'Print "MODBUS: Time to read from PLC: ", Tmr(1)
'-----------------------------------------------------

	If i < length Then
		'we failed to rx a full modbus response -- bail
		Print "MODBUS: failed to rx full modbus response packet, only ", i, " bytes rx'd, expected ", length, " bytes"
		modbusReadPort = -1
		Exit Function
	EndIf

	If i > length Then
		'for some reason we received too many bytes -- bail
		Print "MODBUS: response from PLC was larger than expected, num bytes rx'd/bytes expected: ", i, "/", length
'		For j = 0 To i
'			Print "MODBUS: packet(", j, "): ", modResponse(j)
'		Next
		modbusReadPort = -1
		Exit Function
	EndIf
	
	If BTst(modResponse(7), 7) = True Then
	'If modResponse(1) > 128 Then
		String mbError$
		'PLC set the error bit, get the error code
		Select modResponse(8)
			Case 01
				mbError$ = "0x01 - ILLEGAL FUNCTION"
			Case 02
				mbError$ = "0x02 - ILLEGAL DATA ADDRESS"
			Case 03
				mbError$ = "0x03 - ILLEGAL DATA VALUE"
			Case 04
				mbError$ = "0x04 - SLAVE DEVICE FAILURE"
			Case 05
				mbError$ = "0x05 - ACKNOWLEDGE"
			Case 06
				mbError$ = "0x06 - SLAVE DEVICE BUSY"
			Case 08
				mbError$ = "0x08 - MEMORY PARITY ERROR"
			Case 11 ' 0x0A
				mbError$ = "0x0A - GATEWAY PATH UNAVAILABLE"
			Case 12 ' 0x0B
				mbError$ = "0x0B - GATEWAY TARGET DEVICE FAILED TO RESPOND"
			Default
				mbError$ = "0x" + Hex$(modResponse(2)) + " - UNKNOWN MODBUS ERROR"
		Send
		'the function code in an error = 0x80 + function, so subtracting 0x80 gives us the function code for display purposes 
		Print "MODBUS: error bit was set in response to read, function/exception code is: ", Hex$(modResponse(1) - (&h80)), " / ", mbError$
		modbusReadPort = -1
		Exit Function
	EndIf
	
	'return the number of bytes read
	modbusReadPort = i
Fend

