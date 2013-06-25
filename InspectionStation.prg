#include "Globals.INC"

Function InspectPanel(blah As Integer) As Boolean
	LoadPoints "points3.pts"
	Trap 2, MemSw(jobAbortH) = True GoTo exitInspectPanel ' arm trap
	
	SystemStatus = InspectingPanel
	InspectPanel = False
	
	Jump PreScan LimZ zLimit
	
	Integer i
	Redim SkipHoleArray(recNumberOfHoles - 1, 0)
	Redim InspectionArray(recNumberOfHoles - 1, 1) ' Make the arrays big enough to fit all the panels
	Redim PassFailArray(recNumberOfHoles - 1, 1)
	
	recNumberOfHoles = 16 'fake	
	recPartNumber = 12345 ' fake
	
	currentPreinspectHole = 0 ' This tells the HMI which hole we are working on
	currentInspectHole = 0 ' This tells the HMI which hole we are working on
	
	Select recPartNumber
		Case 88555
			LoadPoints "points3.pts" ' define which points table to use
			FirstHolePointInspection = 158
			LastHolePointInspection = 174
		Case 12345
			LoadPoints "points3.pts" ' define which points table to use
'			FirstHolePointInspection = 231
'			LastHolePointInspection = 233
			FirstHolePointInspection = 248
			LastHolePointInspection = 250
		Default
			Print "Panel points undefined"
	Send
	
	For i = FirstHolePointInspection To LastHolePointInspection
		
		Go PreScan :U(CU(P(i)))
		
		Go P(i)
		
		If blah = 1 Then

			ChangeProfile("07")
			Print GetLaserMeasurement("01")
			
			If Abs(GetLaserMeasurement("01")) < 250 Then ' There is already an insert so set skip flag
				SkipHoleArray(currentPreinspectHole, 0) = 1
				Print "Hole ", i, " is already populated"
			EndIf
			
			currentPreinspectHole = currentPreinspectHole + 1
		ElseIf blah = 2 Then
			
		MeasureInsertDepth(currentPreinspectHole)

		currentInspectHole = currentInspectHole + 1
		
		Else
			Print "state undefined"
		EndIf
			
		Go P(i) -Y(50)
		Wait .5
	Next
	
	InspectPanel = True ' Inspection occured without errors
	Go PreScan :U(CU(Here))

'	PrintPassFailArray()
'	PrintInspectionArray()
'	PrintPanelArray()
'	UnpackInspectionArrays()

exitInspectPanel:

	SystemStatus = MovingPanel
	Jump PreScan LimZ zLimit ' Go Home
	Trap 2 'disarm trap
Fend

'Function PassOrFail(measurement As Real) As Boolean 'Pass is True	
'	
'	Real DepthInsertError
'	
'	DepthInsertError = Abs(recInsertDepth - measurement)
'	Print "DepthInsertError:", DepthInsertError
'	
'' TODO: make the tolerance a variable and make it adjustable via the hmi, we have .006 but theirs is more loose	
'	If (DepthInsertError < insertDepthTolerance) Then
'		PassOrFail = True ' Passed		
'		PanelPassedInspection = True
'	Else
'		'Dont alert opperator yet, this is only on a hole by hole basis
'		PassOrFail = False
'		PanelPassedInspection = False
'	EndIf
'	
'Fend

'Function PrintPassFailArray()
'	
'	Integer n, PrintArrayIndex
'	
'	Print "#" + " " + "L" + " " + "R"
'
'	For n = 0 To recNumberOfHoles - 1
'		Print Str$(n) + " " + Str$(PassFailArray(PrintArrayIndex, LeftSpotFace)) + " " + Str$(PassFailArray(PrintArrayIndex, RightSpotFace))
'		PrintArrayIndex = PrintArrayIndex + 1
'	Next
'	
'	PrintArrayIndex = 0 	'Reset index
'	
'Fend

'Function FakeLogging()
'	
'	Integer i
'	recNumberOfHoles = 23
'	Redim InspectionArray(22, 1)
'	
'	For i = 0 To recNumberOfHoles - 1
'		InspectionArray(i, LeftSpotFace) = i
'		InspectionArray(i, RightSpotFace) = i
'	Next
'
'PrintInspectionArray
'UnpackInspectionArrays
'Fend
'
'Function UnpackInspectionArrays()
'	
''Sending a JSON array is a pain so we are just unpacking the array into seperate vars 	
'hole0L = InspectionArray(0, LeftSpotFace)
'hole0R = InspectionArray(0, RightSpotFace)
'hole1R = InspectionArray(1, RightSpotFace)
'hole1L = InspectionArray(1, LeftSpotFace)
'hole2R = InspectionArray(2, RightSpotFace)
'hole2L = InspectionArray(2, LeftSpotFace)
'hole3R = InspectionArray(3, RightSpotFace)
'hole3L = InspectionArray(3, LeftSpotFace)
'hole4R = InspectionArray(4, RightSpotFace)
'hole4L = InspectionArray(4, LeftSpotFace)
'hole5R = InspectionArray(5, RightSpotFace)
'hole5L = InspectionArray(5, LeftSpotFace)
'hole6R = InspectionArray(6, RightSpotFace)
'hole6L = InspectionArray(6, LeftSpotFace)
'hole7R = InspectionArray(7, RightSpotFace)
'hole7L = InspectionArray(7, LeftSpotFace)
'hole8R = InspectionArray(8, RightSpotFace)
'hole8L = InspectionArray(8, LeftSpotFace)
'hole9R = InspectionArray(9, RightSpotFace)
'hole9L = InspectionArray(9, LeftSpotFace)
'hole10R = InspectionArray(10, RightSpotFace)
'hole10L = InspectionArray(10, LeftSpotFace)
'hole11R = InspectionArray(11, RightSpotFace)
'hole11L = InspectionArray(11, LeftSpotFace)
'hole12R = InspectionArray(12, RightSpotFace)
'hole12L = InspectionArray(12, LeftSpotFace)
'hole13R = InspectionArray(13, RightSpotFace)
'hole13L = InspectionArray(13, LeftSpotFace)
'hole14R = InspectionArray(14, RightSpotFace)
'hole14L = InspectionArray(14, LeftSpotFace)
'hole15R = InspectionArray(15, RightSpotFace)
'hole15L = InspectionArray(15, LeftSpotFace)
'hole16R = InspectionArray(16, RightSpotFace)
'hole16L = InspectionArray(16, LeftSpotFace)
'hole17R = InspectionArray(17, RightSpotFace)
'hole17L = InspectionArray(17, LeftSpotFace)
'hole18R = InspectionArray(18, RightSpotFace)
'hole18L = InspectionArray(18, LeftSpotFace)
'hole19R = InspectionArray(19, RightSpotFace)
'hole19L = InspectionArray(19, LeftSpotFace)
'hole20R = InspectionArray(20, RightSpotFace)
'hole20L = InspectionArray(20, LeftSpotFace)
'hole21R = InspectionArray(21, RightSpotFace)
'hole21L = InspectionArray(21, LeftSpotFace)
'hole22R = InspectionArray(22, RightSpotFace)
'hole22L = InspectionArray(22, LeftSpotFace)
'
'Integer n
'
''For n = 0 To recNumberOfHoles - 1
''		
''	'comment this out during integration
''	If PassFailArray(n, LeftSpotFace) = False Or PassFailArray(n, RightSpotFace) = False Then
''		Print "hole " + Str$(n) + " failed!"
''	EndIf
''	
''Next
'	
'Fend
'Function UnpackPassFailArray()
'	'Sending a JSON array is a pain so we are just unpacking the array into seperate vars 
'	'If either spotface fails then the hole fails
'	
'	hole0PF = PassFailArray(0, LeftSpotFace) Or PassFailArray(0, RightSpotFace)
'	hole1PF = PassFailArray(1, LeftSpotFace) Or PassFailArray(1, RightSpotFace)
'	hole2PF = PassFailArray(2, LeftSpotFace) Or PassFailArray(2, RightSpotFace)
'	hole3PF = PassFailArray(3, LeftSpotFace) Or PassFailArray(3, RightSpotFace)
'	hole4PF = PassFailArray(4, LeftSpotFace) Or PassFailArray(4, RightSpotFace)
'	hole5PF = PassFailArray(5, LeftSpotFace) Or PassFailArray(5, RightSpotFace)
'	hole6PF = PassFailArray(6, LeftSpotFace) Or PassFailArray(6, RightSpotFace)
'	hole7PF = PassFailArray(7, LeftSpotFace) Or PassFailArray(7, RightSpotFace)
'	hole8PF = PassFailArray(8, LeftSpotFace) Or PassFailArray(8, RightSpotFace)
'	hole9PF = PassFailArray(9, LeftSpotFace) Or PassFailArray(9, RightSpotFace)
'	hole10PF = PassFailArray(10, LeftSpotFace) Or PassFailArray(10, RightSpotFace)
'	hole11PF = PassFailArray(11, LeftSpotFace) Or PassFailArray(11, RightSpotFace)
'	hole12PF = PassFailArray(12, LeftSpotFace) Or PassFailArray(12, RightSpotFace)
'	hole13PF = PassFailArray(13, LeftSpotFace) Or PassFailArray(13, RightSpotFace)
'	hole14PF = PassFailArray(14, LeftSpotFace) Or PassFailArray(14, RightSpotFace)
'	hole15PF = PassFailArray(15, LeftSpotFace) Or PassFailArray(15, RightSpotFace)
'	hole16PF = PassFailArray(16, LeftSpotFace) Or PassFailArray(16, RightSpotFace)
'	hole17PF = PassFailArray(17, LeftSpotFace) Or PassFailArray(17, RightSpotFace)
'	hole18PF = PassFailArray(18, LeftSpotFace) Or PassFailArray(18, RightSpotFace)
'	hole19PF = PassFailArray(19, LeftSpotFace) Or PassFailArray(19, RightSpotFace)
'	hole20PF = PassFailArray(20, LeftSpotFace) Or PassFailArray(20, RightSpotFace)
'	hole21PF = PassFailArray(21, LeftSpotFace) Or PassFailArray(21, RightSpotFace)
'	hole22PF = PassFailArray(22, LeftSpotFace) Or PassFailArray(22, RightSpotFace)
'	
'Fend


Function HotStakeTest()
	LoadPoints "points3.pts"
	
	Integer i
	
	Jump PreHotStake LimZ -12.5
	
	Select recPartNumber
		Case 88555
			LoadPoints "points3.pts" ' define which points table to use
			FirstHolePointHotStake = 175
			LastHolePointHotStake = 190
		Case 88123
			LoadPoints "points2.pts" ' define which points table to use
			'FirstHolePointInspection = xxx
			'LastHolePointInspection = xxx
		Case 12345
			LoadPoints "points3.pts" ' define which points table to use
			'FirstHolePointHotStake = 225
			'LastHolePointHotStake = 227
			FirstHolePointHotStake = 245
			LastHolePointHotStake = 247
		Default
			Print "Panel points undefined"
	Send
	
	For i = FirstHolePointHotStake To LastHolePointHotStake
		Jump P(i)
		Wait 1
	Next

Fend
Function FlashTest()
	LoadPoints "points3.pts"
	Integer i
	
	Jump PreFlash
	
'	For i = 191 To 206

	For i = 228 To 230
		Jump P(i)
		Wait 1
	Next

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

	Wait .3 ' wait for laser scanner to receive the command. This may be able to be shortened up

    i = ChkNet(203)
    If i > 0 Then
    	Read #203, response$, i
    	Print response$
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
	
	ChangeProfile("01")
	'Get the Left Spot face measurement, see if it is in spec and save the data to two arrays. 
	InspectionArray(Index, LeftSpotFace) = MicroMetersToInches(GetLaserMeasurement("12"))
'	PassFailArray(PanelArrayIndex, LeftSpotFace) = PassOrFail(InspectionArray(PanelArrayIndex, LeftSpotFace))
	ChangeProfile("02")
	'Get the right Spot face measurement, see if it is in spec and save the data to two arrays 
	InspectionArray(Index, RightSpotFace) = MicroMetersToInches(GetLaserMeasurement("11"))
'	PassFailArray(PanelArrayIndex, RightSpotFace) = PassOrFail(InspectionArray(PanelArrayIndex, RightSpotFace))
	
	PrintInspectionArray()
	
Fend
Function PrintInspectionArray()
	
	Integer n, PrintArrayIndex
	
	Print "#" + " " + "L" + " " + "R"

	For n = 0 To recNumberOfHoles - 1
		Print Str$(n) + " " + Str$(InspectionArray(PrintArrayIndex, LeftSpotFace)) + " " + Str$(InspectionArray(PrintArrayIndex, RightSpotFace))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset index
	
Fend
Function MicroMetersToInches(um As Real) As Real
		MicroMetersToInches = um * .00003937
Fend
Function CrowdingSequence()
	Jump temnest LimZ -12.5
	Off suctionCupsH
	Wait 2.5
	Go temnest +Z(30)
	Wait .5
	On nestpneu
	Wait .5
	Off nestpneu
	Wait .5
	On nestpneu
	Wait .5
	Off nestpneu
	Wait .5
	On nestpneu
	Wait 3
	Jump temnest LimZ -12.5
	On suctionCupsH
	Wait 2
	Off nestpneu
	Go temnest +Z(30)
Fend


