#include "Globals.INC"

Function InspectPanel(SelectRoutine As Integer) As Integer

'	Trap 2, MemSw(jobAbortH) = True GoTo exitInspectPanel ' arm trap
	Real ZdiffFromLaserCenter, RobotZposition
	SystemStatus = StateInspection
'	InspectPanel = 2 ' default to fail
	
	Jump PreScan LimZ zLimit
	
	Integer i
	Real BossCrosssectionalArea
	Redim SkipHoleArray(recNumberOfHoles, 0) ' Size the arrays
	Redim PreInspectionArray(recNumberOfHoles, 0)
	
	currentPreinspectHole = 1 ' This tells the HMI which hole we are working on during preinspection
	currentInspectHole = 1 ' This tells the HMI which hole we are working on during inspection

	For i = FirstHolePointInspection To LastHolePointInspection
		
		Go PreScan :U(CU(P(i))) ' Stay in prescan but rotate the panel to its final U position before we move under

		Go P(i)
		
		If SelectRoutine = 1 Then

			ChangeProfile("07")
			Wait .25
			ZdiffFromLaserCenter = (GetLaserMeasurement("05") + GetLaserMeasurement("06")) / 2 ' take an average from the left and the right
			RobotZposition = CZ(Here) ' Where are we at in robot Z when we take the laser measurement
			
			Print "ZdiffFromLaserCenter, RobotZposition:", ZdiffFromLaserCenter, RobotZposition
            
            If Abs(ZdiffFromLaserCenter) > 25 Then
				' Throw an Error
				Print "Hole not within Laser Range"
				erUnknown = True
            	Pause
                InspectPanel = 2 ' default to fail		
            	Exit Function
            EndIf
			
			ZSpotfacetoQuillOffset = RobotZposition - ZdiffFromLaserCenter
			
			Print "ZSpotfacetoQuillOffset:", ZSpotfacetoQuillOffset
			
			PreInspectionArray(currentPreinspectHole, 0) = ZSpotfacetoQuillOffset
			
			ChangeProfile("07")
			BossCrosssectionalArea = GetLaserMeasurement("01") ' This measurement checks for pre-existing inserts
			
		If DeepBoss = True Then ' There are different volumes of bosses
			If BossCrosssectionalArea > -400 Then ' There is already an insert so set skip flag
				SkipHoleArray(currentPreinspectHole, 0) = 1
				Print "Hole ", currentPreinspectHole, " is already populated"
			EndIf
		Else
			If BossCrosssectionalArea > -300 Then ' There is already an insert so set skip flag
				SkipHoleArray(currentPreinspectHole, 0) = 1
				Print "Hole ", currentPreinspectHole, " is already populated"
			EndIf
		EndIf

'			ChangeProfile("00")
'			Print "Hole error:", GetLaserMeasurement("05")
			
''			If Abs(BossCrosssectionalArea) < 12345 Then ' We dont see an empty hole or a populated hole. Panel is backwards or 
''				erPanelStatusUnknown = True
''				InspectPanel = 2					' the wrong panel was put into the magazine
''				'back out of the laser	
''				Exit For
''			EndIf
			
			currentPreinspectHole = currentPreinspectHole + 1
			
		ElseIf SelectRoutine = 2 Then
			MeasureInsertDepth(currentInspectHole) ' Measures each spot face, left and right, then populates inspection array with measurements in inches
			currentInspectHole = currentInspectHole + 1
		Else
			Print "Inspection argument undefined"
			InspectPanel = 2 ' fail
			Exit Function
		EndIf
			
		Go P(i) -Y(50) ' Pull back from laser scanner then rotate so we dont endanger it
		Wait .25
	Next
	
	If SelectRoutine = 1 Then
		PrintPreInspectionArray()
	Else
		PrintInspectionArray()
		PrintPassFailArray()
		UnpackInspectionArrays()
	EndIf

	InspectPanel = 0 ' Inspection occured without errors
	Go PreScan :U(CU(Here))

exitInspectPanel:

	SystemStatus = StateMoving
	Jump PreScan LimZ zLimit ' Go Home
	Trap 2 'disarm trap
Fend
Function PassOrFail(measurement As Real) As Boolean 'Pass is True	
	' Measurement is assumed to be inches
	
	Real DepthInsertError
	
	DepthInsertError = recInsertDepth - measurement
	Print "DepthInsertError:", DepthInsertError
	
' TODO: make the tolerance a variable and make it adjustable via the hmi, we have .006 but theirs is more loose	
	If (DepthInsertError < insertDepthTolerance) Then
		PassOrFail = True ' Passed		
		PanelPassedInspection = True
	Else
		'Dont alert opperator yet, this is only on a hole by hole basis
		PassOrFail = False
		PanelPassedInspection = False
	EndIf
	
Fend
Function PrintPassFailArray()
	
	Integer n
	
	Print "#" + " " + "L" + " " + "R"

	For n = 1 To recNumberOfHoles
		Print Str$(n) + " " + Str$(PassFailArray(n, LeftSpotFace)) + " " + Str$(PassFailArray(n, RightSpotFace))
	Next
	
Fend

Function FakeLogging()

	Integer i
	recNumberOfHoles = 23
	Redim InspectionArray(recNumberOfHoles - 1, 1)
	
	For i = 0 To recNumberOfHoles - 1
		InspectionArray(i, LeftSpotFace) = i
		InspectionArray(i, RightSpotFace) = i
	Next

	PrintInspectionArray()
	UnpackInspectionArrays()
	UnpackPassFailArray()

	panelDataTxRdy = True ' Tell HMI to readout hole data
	
'	MemOn (panelDataTxAckH) ' fake
	
' this is for hmi logging
	Wait MemSw(panelDataTxAckH) = True, 3
	If TW = True Then ' catch that the HMI timed out without acking
		erHmiDataAck = True
		Print "no data ack from hmi"
	EndIf

	panelDataTxRdy = False ' reset flag
	MemOff (panelDataTxAckH) ' reset flag
	Print "ending log"
	jobDone = True
	
Fend
Function UnpackInspectionArrays()
	
'Sending a JSON array is a pain so we are just unpacking the array into seperate vars\ 	
hole0R = InspectionArray(0, RightSpotFace)
hole0L = InspectionArray(0, LeftSpotFace)
hole1R = InspectionArray(1, RightSpotFace)
hole1L = InspectionArray(1, LeftSpotFace)
hole2R = InspectionArray(2, RightSpotFace)
hole2L = InspectionArray(2, LeftSpotFace)
hole3R = InspectionArray(3, RightSpotFace)
hole3L = InspectionArray(3, LeftSpotFace)
hole4R = InspectionArray(4, RightSpotFace)
hole4L = InspectionArray(4, LeftSpotFace)
hole5R = InspectionArray(5, RightSpotFace)
hole5L = InspectionArray(5, LeftSpotFace)
hole6R = InspectionArray(6, RightSpotFace)
hole6L = InspectionArray(6, LeftSpotFace)
hole7R = InspectionArray(7, RightSpotFace)
hole7L = InspectionArray(7, LeftSpotFace)
hole8R = InspectionArray(8, RightSpotFace)
hole8L = InspectionArray(8, LeftSpotFace)
hole9R = InspectionArray(9, RightSpotFace)
hole9L = InspectionArray(9, LeftSpotFace)
hole10R = InspectionArray(10, RightSpotFace)
hole10L = InspectionArray(10, LeftSpotFace)
hole11R = InspectionArray(11, RightSpotFace)
hole11L = InspectionArray(11, LeftSpotFace)
hole12R = InspectionArray(12, RightSpotFace)
hole12L = InspectionArray(12, LeftSpotFace)
hole13R = InspectionArray(13, RightSpotFace)
hole13L = InspectionArray(13, LeftSpotFace)
hole14R = InspectionArray(14, RightSpotFace)
hole14L = InspectionArray(14, LeftSpotFace)
hole15R = InspectionArray(15, RightSpotFace)
hole15L = InspectionArray(15, LeftSpotFace)
hole16R = InspectionArray(16, RightSpotFace)
hole16L = InspectionArray(16, LeftSpotFace)
hole17R = InspectionArray(17, RightSpotFace)
hole17L = InspectionArray(17, LeftSpotFace)
hole18R = InspectionArray(18, RightSpotFace)
hole18L = InspectionArray(18, LeftSpotFace)
hole19R = InspectionArray(19, RightSpotFace)
hole19L = InspectionArray(19, LeftSpotFace)
hole20R = InspectionArray(20, RightSpotFace)
hole20L = InspectionArray(20, LeftSpotFace)
hole21R = InspectionArray(21, RightSpotFace)
hole21L = InspectionArray(21, LeftSpotFace)
hole22R = InspectionArray(22, RightSpotFace)
hole22L = InspectionArray(22, LeftSpotFace)
hole23L = InspectionArray(23, LeftSpotFace)
hole23R = InspectionArray(23, RightSpotFace)

Integer n

'For n = 0 To recNumberOfHoles - 1
'		
'	'comment this out during integration
'	If PassFailArray(n, LeftSpotFace) = False Or PassFailArray(n, RightSpotFace) = False Then
'		Print "hole " + Str$(n) + " failed!"
'	EndIf
'	
'Next
	
Fend
Function UnpackPassFailArray()
	'If either spotface fails then the hole fails	
	
	hole0PF = PassFailArray(0, LeftSpotFace) Or PassFailArray(0, RightSpotFace)
	hole1PF = PassFailArray(1, LeftSpotFace) Or PassFailArray(1, RightSpotFace)
	hole2PF = PassFailArray(2, LeftSpotFace) Or PassFailArray(2, RightSpotFace)
	hole3PF = PassFailArray(3, LeftSpotFace) Or PassFailArray(3, RightSpotFace)
	hole4PF = PassFailArray(4, LeftSpotFace) Or PassFailArray(4, RightSpotFace)
	hole5PF = PassFailArray(5, LeftSpotFace) Or PassFailArray(5, RightSpotFace)
	hole6PF = PassFailArray(6, LeftSpotFace) Or PassFailArray(6, RightSpotFace)
	hole7PF = PassFailArray(7, LeftSpotFace) Or PassFailArray(7, RightSpotFace)
	hole8PF = PassFailArray(8, LeftSpotFace) Or PassFailArray(8, RightSpotFace)
	hole9PF = PassFailArray(9, LeftSpotFace) Or PassFailArray(9, RightSpotFace)
	hole10PF = PassFailArray(10, LeftSpotFace) Or PassFailArray(10, RightSpotFace)
	hole11PF = PassFailArray(11, LeftSpotFace) Or PassFailArray(11, RightSpotFace)
	hole12PF = PassFailArray(12, LeftSpotFace) Or PassFailArray(12, RightSpotFace)
	hole13PF = PassFailArray(13, LeftSpotFace) Or PassFailArray(13, RightSpotFace)
	hole14PF = PassFailArray(14, LeftSpotFace) Or PassFailArray(14, RightSpotFace)
	hole15PF = PassFailArray(15, LeftSpotFace) Or PassFailArray(15, RightSpotFace)
	hole16PF = PassFailArray(16, LeftSpotFace) Or PassFailArray(16, RightSpotFace)
	hole17PF = PassFailArray(17, LeftSpotFace) Or PassFailArray(17, RightSpotFace)
	hole18PF = PassFailArray(18, LeftSpotFace) Or PassFailArray(18, RightSpotFace)
	hole19PF = PassFailArray(19, LeftSpotFace) Or PassFailArray(19, RightSpotFace)
	hole20PF = PassFailArray(20, LeftSpotFace) Or PassFailArray(20, RightSpotFace)
	hole21PF = PassFailArray(21, LeftSpotFace) Or PassFailArray(21, RightSpotFace)
	hole22PF = PassFailArray(22, LeftSpotFace) Or PassFailArray(22, RightSpotFace)
	hole23PF = PassFailArray(23, LeftSpotFace) Or PassFailArray(23, RightSpotFace)
	
Fend

Function ChangeProfile(ProfileNumber$ As String) As Boolean
	
'This function changes the active profile of the laser scanner. Just tell it which profile you want it to run. 
'Set up profiles in its IDE

    Integer i, NumTokens
    String Tokens$(0)
    String response$
    
'    SetNet #201, "10.22.251.171", 7351, CRLF, NONE, 0
    
	If ChkNet(203) < 0 Then ' If port is not open
		OpenNet #203 As Client
		Print "Attempted Open TCP port to HMI"
	EndIf
	
	Print #203, "PW" + "," + ProfileNumber$ ' Per laser scanner manual this is how you change profiles

	Wait .25 ' wait for laser scanner to receive the command. This may be able to be shortened up

    i = ChkNet(203)
    If i > 0 Then
    	Read #203, response$, i
    	'Print response$
    		If response$ = "PW" + Chr$(&hd) Then
				erLaserScanner = False
	      	Else
	      		erLaserScanner = True
	      		Print "Laser Scanner error"
	      	EndIf
	EndIf
	 
Fend
Function GetLaserMeasurement(OutNumber$ As String) As Real
                
    Integer i, NumTokens
    String Tokens$(0), response$, responceCR$
    
'	SetNet #203, "10.22.251.171", 7351, CRLF, NONE, 0
    
	If ChkNet(203) < 0 Then ' If port is not open
		OpenNet #203 As Client
		Print "Attempted Open TCP port to HMI"
	EndIf
                
	Print #203, "MS,0," + OutNumber$
	Wait .5
	
' This routine checks the buffer for a returned value from the laser scanner, 
' checks for the correct responce from the laser and returns requested data.
    i = ChkNet(203)
    If i > 0 Then
    	Read #203, response$, i
'    	Print response$ ' for testing
      	NumTokens = ParseStr(response$, Tokens$(), ",")
	     	If response$ = "MS" + Chr$(&hd) Then ' throw an error if we dont get the proper responce
	      		erLaserScanner = True
	      		Print "Laser Scanner error"
	      	Else
	      		erLaserScanner = False
	      	EndIf
  		GetLaserMeasurement = Val(Tokens$(1)) ' return value
    EndIf

Fend
Function MeasureInsertDepth(Index As Integer)
	
	'Get the Left Spot face measurement, see if it is in spec and save the data to two arrays. 
	ChangeProfile("01")
	InspectionArray(Index, LeftSpotFace) = MicroMetersToInches(GetLaserMeasurement("12"))
'	PassFailArray(Index, LeftSpotFace) = PassOrFail(InspectionArray(Index, LeftSpotFace))
	
	'Get the right Spot face measurement, see if it is in spec and save the data to two arrays 
	ChangeProfile("02")
	InspectionArray(Index, RightSpotFace) = MicroMetersToInches(GetLaserMeasurement("11"))
'	PassFailArray(Index, RightSpotFace) = PassOrFail(InspectionArray(Index, RightSpotFace))
	
Fend
Function PrintInspectionArray()
	
	Integer n
	
	Print "#" + " " + "L" + " " + "R"

	For n = 1 To recNumberOfHoles
		Print Str$(n) + " " + Str$(InspectionArray(n, LeftSpotFace)) + " " + Str$(InspectionArray(n, RightSpotFace))
	Next

Fend
Function PrintPreInspectionArray()
	
	Integer n
	
	Print "#" + " " + "ZdiffFromLaserCenter"

	For n = 1 To recNumberOfHoles
		Print Str$(n) + " " + Str$(PreInspectionArray(n, 0))

	Next

Fend
Function PrintSkipArray()
	
	Integer n
	
	Print "#" + " Skipped?"

	For n = 1 To recNumberOfHoles
		Print Str$(n) + " " + Str$(SkipHoleArray(n, 0))
	Next
	
Fend
Function MicroMetersToInches(um As Real) As Real
		MicroMetersToInches = um * .00003937
Fend
Function CrowdingSequence(StupidCompiler3 As Byte) As Integer

Trap 2, MemSw(jobAbortH) = True GoTo exitCrowding ' arm trap

	Jump Prescan LimZ zLimit
	Jump PreHotStake LimZ zLimit
	MBWrite(pasCrowdingADDR, 0, MBTypeCoil) ' Make sure the crowding is open
	Jump P(recPreCrowding) LimZ zLimit 'Jump to the crowding location
	suctionCupsCC = False ' Turn off suction cups
	Wait suctionWaitTime ' wait for cups to release
	Go P(recCrowding) +Z(15) ' Relese the suction cups and move them out of the way for crowding
	Wait .25
	MBWrite(pasCrowdingADDR, 1, MBTypeCoil) ' Close crowding

	' wait for verification that the crowding has closed
	Do Until pasCrowding = True
		Wait .25
	Loop
	
	Wait 1 ' wait for the crowd to take place
	
'	Do While ZmaxTorque < .3 ' Approach the panel slowly until we hit a torque limit
'		JTran 3, -.5 ' Move only the z-axis downward in .5mm increments
'	Loop
	
	Go P(recCrowding)
	suctionCupsCC = True ' Turn on cups
	Wait suctionWaitTime
	MBWrite(pasCrowdingADDR, 0, MBTypeCoil) ' Open crowding

	' wait for verification that the crowding has opened
	Do Until pasCrowding = False
		Wait .25
	Loop
	Wait 1 ' wait for the crowd to open	
	
	CrowdingSequence = 0
	
exitCrowding:
	
If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
	jobAbort = True
EndIf

Trap 2 ' Disarm trap

Fend


