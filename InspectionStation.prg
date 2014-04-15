#include "Globals.INC"

Function InspectPanel(SelectRoutine As Integer) As Integer

	SystemStatus = StateInspection
	InspectPanel = 2 ' default to fail 
	Integer i
	Real BossCrosssectionalArea
	Redim SkipHoleArray(recNumberOfHoles, 0) ' Size the arrays
	
	Redim InspectionArray(0, 0) ' clear all the values in the Inspection Array
	Redim PassFailArray(0, 0)   ' clear all the values in the PassFail Array
	
	Redim PassFailArray(23, 1) 		' Clear array, always 23 rows
  Redim InspectionArray(23, 1)	' Clear array, always 23 rows
	
	If Not HomeCheck Then findHome
	
	currentPreinspectHole = 1 ' This tells the HMI which hole we are working on during preinspection
	currentInspectHole = 1 ' This tells the HMI which hole we are working on during inspection

	'if needed the profile will be changed by the inspection function
	ChangeProfile("07")

	For i = 1 To PanelHoleCount
		
		PanelHoleToXYZT(i, CX(laser), CY(laser), CZ(PreScan), 90 - PanelHoleTangent(i))
		
		Wait 0.5
		
		If SelectRoutine = 1 Then

			' The following code block detects if an insert is in the hole already.			

			BossCrosssectionalArea = GetLaserMeasurement("01") ' This measurement checks for pre-existing inserts
			
			Print "BossCrosssectionalArea: ", BossCrosssectionalArea, "  Recipe: ", recBossCrossArea
			If BossCrosssectionalArea > recBossCrossArea Then ' There is already an insert so set skip flag
				SkipHoleArray(currentPreinspectHole, 0) = 1
				Print "Hole ", currentPreinspectHole, " is already populated"
			EndIf

			currentPreinspectHole = currentPreinspectHole + 1
			
		ElseIf SelectRoutine = 2 Then
			
			MeasureInsertDepth(currentInspectHole) ' Measures each spot face, left and right, then populates inspection array with measurements in inches
			UnpackInspectionArrays()
			currentInspectHole = currentInspectHole + 1
		EndIf
			
	Next
	
	InspectPanel = 0 ' Inspection occured without errors

	SystemStatus = StateMoving
	findHome
	Trap 2 'disarm trap
	
Fend



Function GetLaserMeasurement(OutNumber$ As String) As Real
                
  Integer i, NumTokens, waitCount, portstatus
  String Tokens$(0), response$, bit$, chars$(0)
  
	erLaserScanner = False

    
	If ChkNet(203) < 0 Then ' If port is not open
		OpenNet #203 As Client
		Print "Attempted Open TCP port to HMI"
	EndIf
                
	Print #203, "MS,0," + OutNumber$
	
	i = 0
	waitCount = 0
	Redim chars$(0)
	
	Do While True
		'only read off of the port what it has available
		portstatus = ChkNet(203)

		If portstatus > 0 Then
			'data is available, put it into the response string
			Redim Preserve chars$(UBound(chars$) + 1)
			
			Read #203, bit$, 1
			chars$(i) = bit$
			
			i = i + 1
			
		ElseIf portstatus = 0 Then
			'nothing on the port
			waitCount = waitCount + 1
			If waitCount > 5 Then
				'we have all we are going to get, leave
				Exit Do
			EndIf
			Wait 0.05
		Else
			'something went wrong
			Print "LASER: laser port error: ", portstatus
			GetLaserMeasurement = -1
			Exit Function
		EndIf
	Loop
	
	For i = 0 To UBound(chars$)
		response$ = response$ + chars$(i)
	Next
	
	NumTokens = ParseStr(response$, Tokens$(), ",")
	
	If NumTokens < 1 Then
		'something went wrong
		Print "LASER: error --full message: ", response$
	EndIf
	
	If response$ = "MS" + Chr$(&hd) Then
		' throw an error if we dont get the proper responce
		erLaserScanner = True
		Print "LASER: error - MS  ---full message: ", response$
	EndIf

	GetLaserMeasurement = Val(Tokens$(1)) ' return value

Fend


Function MeasureInsertDepth(Index As Integer)
	
	'Get the Left Spot face measurement, see if it is in spec and save the data to two arrays. 
	ChangeProfile("01")
	InspectionArray(Index, LeftSpotFace) = MicroMetersToInches(GetLaserMeasurement("12"))
	PassFailArray(Index, LeftSpotFace) = PassOrFail(InspectionArray(Index, LeftSpotFace))
	
	'Get the right Spot face measurement, see if it is in spec and save the data to two arrays 
	ChangeProfile("02")
	InspectionArray(Index, RightSpotFace) = MicroMetersToInches(GetLaserMeasurement("11"))
	PassFailArray(Index, RightSpotFace) = PassOrFail(InspectionArray(Index, RightSpotFace))
	
Fend


Function ChangeProfile(ProfileNumber$ As String) As Boolean
	
'This function changes the active profile of the laser scanner. Just tell it which profile you want it to run. 
'Set up profiles in its IDE

    Integer i, NumTokens
    String Tokens$(0)
    String response$
        
	If ChkNet(203) < 0 Then ' If port is not open
		OpenNet #203 As Client
		Print "Attempted Open TCP port to HMI"
	EndIf
	
	Print #203, "PW" + "," + ProfileNumber$ ' Per laser scanner manual this is how you change profiles

    i = ChkNet(203)
	Do Until i > 0
	    i = ChkNet(203)
	    If i < 0 Then Exit Function 'port error
	    Wait 0.05
	Loop

    If i > 0 Then  'should be, but just in case...
    	Read #203, response$, i

		If response$ = "PW" + Chr$(&hd) Then
			erLaserScanner = False
      	Else
      		erLaserScanner = True
      		Print "Laser Scanner error"
      	EndIf
	EndIf
	 
Fend


Function PassOrFail(measurement As Real) As Boolean 'Pass is True	
	' Measurement is assumed to be inches
	
	Real DepthInsertError
	
	DepthInsertError = recInsertDepth - measurement
	Print "DepthInsertError:", DepthInsertError
	
	If (Abs(DepthInsertError) < insertDepthTolerance) Then
		PassOrFail = True ' Passed
	Else
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


Function UnpackInspectionArrays()
	
	'Sending a JSON array is a pain so we are just unpacking the array into seperate vars
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



