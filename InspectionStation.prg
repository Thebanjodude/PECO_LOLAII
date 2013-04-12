#include "Globals.INC"

Function InspectPanel(HoleInspect As Boolean)
	'	HoleInspect As Boolean
	
	Go ScanCenter3 ' Collision Avoidance Waypoint	
	
	SystemStatus = InspectingPanel
	
	Integer k, j
	Real beta, mu, m1, m2, r1, phi, rho
	Real y1, y2, y3, dy, dx, deltaRotX, deltaRotY
	Real RightOffset, LeftOffset
	
  	
	GetThetaR() 'get first r and theta
'	FindPickUpError()
	PanelArrayIndex = 0
	
	Redim InspectionArray(22, 1) ' Make the arrays big enough to fit all the panels
	Redim PassFailArray(22, 1)
	
	recInsertDepth = .079
	
	For j = 0 To recNumberOfHoles - 1 'k is the hole # we are on
		
		If j <> 0 Then
			IncrementIndex()
			GetThetaR()
		EndIf
		
		If r = 0 Then
			Print "r=0"
			Pause
		EndIf
		
		Print "r:", r

		If j = 0 Then ' Find the slopes of the lines that connect the holes
			m1 = FindSlope(recNumberOfHoles - 1, j) 'the last hole to the hole
			m2 = FindSlope(j, j + 1) 'from the hole to the next hole
		ElseIf j = recNumberOfHoles - 1 Then
			m1 = FindSlope(j - 1, j) 'from the hole before to the hole
			m2 = FindSlope(j, 0) ' from the last hole to the first hole
		Else
			m1 = FindSlope(j - 1, j) 'from the hole before to the hole
			m2 = FindSlope(j, j + 1) 'from the hole to the next hole
		EndIf
	
'		Print "m1:", m1
'		Print "m2:", m2
		Print "Theta", Theta
'		Print "beta Unchanged", GetAngle(m1, m2)
		If Theta = 0 Then
			beta = 90
		ElseIf (Theta = 90) Then
			beta = 180
		ElseIf (Theta = 270) Then
			beta = 0
		ElseIf (90 < Theta And Theta < 180) Then
	 		beta = GetAngle(m1, m2) + 180 ' add 180 because its obtuse
		ElseIf (270 < Theta And Theta < 360) Or (0 < Theta And Theta < 90) Or (180 < Theta And Theta < 270) Then
			beta = GetAngle(m1, m2) + 90
		Else
			Print "error, theta is defined as < 360"
			Pause
		EndIf
		
		Print "beta:", beta
				
		mu = (180 - beta) / 2
		
		Print "Mu:", mu
		
		rho = mu ' this is the place to experiment with the angle
		
		'Rotate PanelOffset to Theta		
		
		If Theta = 0 Then ' If this works, they are all the same so condense the if's!
			If j <> 0 Then
			RotatePanelOffset(Theta)
			EndIf
			P23 = (scancenter5) -Y(r) -U(Theta)
			'Go P23 - RotatedOffset
		ElseIf Theta = 90 Then
			If j <> 0 Then
			RotatePanelOffset(Theta)
			EndIf
			P23 = (scancenter5) -Y(r) -U(Theta)
			'Go P23 - RotatedOffset
		ElseIf Theta = 180 Then
			If j <> 0 Then
			RotatePanelOffset(Theta)
			EndIf
			P23 = (scancenter5) -Y(r) -U(Theta)
			'Go P23 - RotatedOffset
		ElseIf Theta = 270 Then
			If j <> 0 Then
			RotatePanelOffset(Theta)
			EndIf
			P23 = (scancenter5) -Y(r) -U(Theta)
			'Go P23 - RotatedOffset
		ElseIf (0 < Theta And Theta < 90) Then
			If j <> 0 Then
				RotatePanelOffset(Theta)
			EndIf
			
			phi = rho + Theta
			RotatePanelOffset(phi)
			Print "phi:", phi
            P23 = (scancenter5) -Y(r) -U(phi)
			
			dy = r - (r * Cos(DegToRad(rho)))
			P23 = P23 +Y(dy)
			
	       	dx = r * Sin(DegToRad(rho))
            P23 = P23 -X(dx)

		ElseIf (90 < Theta And Theta < 180) Then
			If j <> 0 Then
				RotatePanelOffset(Theta)
			EndIf
		ElseIf (180 < Theta And Theta < 270) Then
			If j <> 0 Then
				RotatePanelOffset(Theta)
			EndIf
		ElseIf (270 < Theta And Theta < 360) Then
			If j <> 0 Then
				RotatePanelOffset(Theta)
			EndIf
		Else
			Print "Error, theta is greater than 360"
		EndIf

		If j = 0 Then
		' We find the theta off set using the laset scanner. We use the position of the
		'hole walls and derive theta offset 
				Go P23 - RotatedOffset
				ChangeProfile("00")
				RightOffset = GetLaserMeasurement("03")
				LeftOffset = GetLaserMeasurement("04")
				thetaOffset = RadToDeg(Asin((RightOffset + LeftOffset) / (2 * r)))
'				Print "RightOffset: ", RightOffset
'				Print "LeftOffset: ", LeftOffset
				Print "thetaOffset: ", thetaOffset
				
				If Abs(thetaOffset) > 3 Then
					Print "thetaoffset it more than 3 deg"
					Pause
				EndIf
				'thetaoffset is calculated with wrong sign
				PanelOffset = PanelOffset -U(thetaOffset)
				FindPickUpError()
				Print "PanelOffset:", PanelOffset
				RotatePanelOffset(Theta)
				'P23 = P23 - RotatedOffset
		EndIf
	
		Go P23 - RotatedOffset
		Print "j:", j
		Print " position:", P23
		If HoleInspect = True Then
			MeasureInsertDepth()
		Else
		'switch to correct laser Profile
			ChangeProfile("07")
			Print GetLaserMeasurement("01")
			If GetLaserMeasurement("01") > 35 Then ' There is already an insert so set skip flag
				PanelArray(j, SkipFlagColumn) = 1
			EndIf
		EndIf
		
		Pause
Next


'	PrintPassFailArray()
'	PrintInspectionArray()
	PrintPanelArray()
	
	UnpackInspectionArrays()
		
	SystemStatus = MovingPanel
	Go ScanCenter3 ' Collision Avoidance Waypoint
	
Fend
Function MeasureInsertDepth()
	
	ChangeProfile("01")
	'Get the Left Spot face measurement, see if it is in spec and save the data to two arrays. 
	'No multi-datatype arrays in spel :( 
	InspectionArray(PanelArrayIndex, LeftSpotFace) = MicroMetersToInches(GetLaserMeasurement("12"))
	PassFailArray(PanelArrayIndex, LeftSpotFace) = PassOrFail(InspectionArray(PanelArrayIndex, LeftSpotFace))
	ChangeProfile("02")
	'Get the right Spot face measurement, see if it is in spec and save the data to two arrays 
	InspectionArray(PanelArrayIndex, RightSpotFace) = MicroMetersToInches(GetLaserMeasurement("11"))
	PassFailArray(PanelArrayIndex, RightSpotFace) = PassOrFail(InspectionArray(PanelArrayIndex, RightSpotFace))
	
Fend
Function MicroMetersToInches(um As Real) As Real
		MicroMetersToInches = um * .00003937
Fend
Function PassOrFail(measurement As Real) As Boolean 'Pass is True	
	
	Real DepthInsertError
	
	DepthInsertError = Abs(recInsertDepth - measurement)
	Print DepthInsertError
	
' TODO: make the tolerance a variable and make it adjustable via the hmi, we have .006 but theirs is more loose	
	If (DepthInsertError < 0.006) Then
		PassOrFail = True ' Passed		
		PanelPassedInspection = True
	Else
		'Dont alert opperator yet, this is only on a hole by hole basis
		PassOrFail = False
		PanelPassedInspection = False
	EndIf
	
Fend
Function ChangeProfile(ProfileNumber$ As String) As Boolean

    Integer i, NumTokens
    String Tokens$(0)
    String response$
    
'    SetNet #201, "10.22.251.171", 7351, CRLF, NONE, 0
    
	If ChkNet(203) < 0 Then ' If port is not open
		OpenNet #203 As Client
		Print "Attempted Open TCP port to HMI"
	EndIf
	
	Print #203, "PW" + "," + ProfileNumber$

	Wait .55
	
    i = ChkNet(203)
    If i > 0 Then
    	Read #203, response$, i
    	NumTokens = ParseStr(response$, Tokens$(), ",")
  '  	Print Tokens$(0)
	EndIf
	
Fend
Function ChangeOffset(InsertDepth$ As String) 'laser offset is in micrometers
    
    Integer i, NumTokens, j
    String Tokens$(0)
    String response$, command$
    
'    SetNet #201, "10.22.251.171", 7351, CRLF, NONE, 0
    
	If ChkNet(203) < 0 Then ' If port is not open
		OpenNet #203 As Client
		Print "Attempted Open TCP port to HMI"
	EndIf
		   
	ChangeProfile("01")
	Wait .25
	
	command$ = "SW,OF,1,12," + InsertDepth$
	Print #203, command$
	Wait .25
	
    i = ChkNet(203)
    If i > 0 Then
    	Read #203, response$, i
    	NumTokens = ParseStr(response$, Tokens$(), ",")
    	Print response$
   EndIf
   
   ChangeProfile("02")
   Wait .25
   
	command$ = "SW,OF,1,11," + InsertDepth$
	Print command$
	Print #203, command$
	
	Wait .25
	
    i = ChkNet(203)
    If i > 0 Then
    	Read #203, response$, i
    	NumTokens = ParseStr(response$, Tokens$(), ",")
    	Print response$
   EndIf

Fend
Function GetLaserMeasurement(OutNumber$ As String) As Real
                
    Integer i, NumTokens
    String Tokens$(0), response$
    
'	SetNet #203, "10.22.251.171", 7351, CRLF, NONE, 0
    
	If ChkNet(203) < 0 Then ' If port is not open
		OpenNet #203 As Client
		Print "Attempted Open TCP port to HMI"
	EndIf
                
	Print #203, "MS,0," + OutNumber$
	Wait .5
	
    i = ChkNet(203)
    If i > 0 Then
    	Read #203, response$, i
      	NumTokens = ParseStr(response$, Tokens$(), ",")
  		GetLaserMeasurement = Val(Tokens$(1))
    EndIf

Fend
Function PrintPassFailArray()
	
	Integer n, PrintArrayIndex
	
	Print "#" + " " + "L" + " " + "R"

	For n = 0 To recNumberOfHoles - 1
		Print Str$(n) + " " + Str$(PassFailArray(PrintArrayIndex, LeftSpotFace)) + " " + Str$(PassFailArray(PrintArrayIndex, RightSpotFace))
		PrintArrayIndex = PrintArrayIndex + 1
	Next
	
	PrintArrayIndex = 0 	'Reset index
	
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
Function UnpackInspectionArrays()
	
hole0L = InspectionArray(0, LeftSpotFace)
hole0R = InspectionArray(0, RightSpotFace)
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

Integer n

For n = 0 To recNumberOfHoles - 1
		
	If PassFailArray(n, LeftSpotFace) = False Or PassFailArray(n, RightSpotFace) = False Then
		Print "hole " + Str$(n) + " failed!"
	EndIf
	
Next
	
Fend
Function PickUpPanel
	Off (15)
	Go ScanCenter3 :U(CU(CurPos))
	Go PrePickUp2 - PickUpOffset
	Go PickUp2 - PickUpOffset
	On (15)
	Wait 1
	Go PrePickup2 - PickUpOffset
	Go ScanCenter3 :U(CU(CurPos))
	Go ScanCenter3
	Pause
Fend
Function DropOffPanel
	Go ScanCenter3 :U(CU(CurPos))
	Go DropOff
	Off (15)
	Wait 2
	Go ScanCenter3
	Pause
Fend
Function RotatePanelOffset(angle As Real)
		
		'Compute the rotated X,Y and U PanelOffset components
		RotatedOffset = RotatedOffset :X(CX(PanelOffset) * Cos(DegToRad(angle)) + CY(PanelOffset) * Sin(DegToRad(angle)))
		Print "	RotatedOffset:", RotatedOffset
		RotatedOffset = RotatedOffset :Y(CX(PanelOffset) * Sin(DegToRad(angle)) + CY(PanelOffset) * Cos(DegToRad(angle)))
		Print "	RotatedOffset:", RotatedOffset
		RotatedOffset = RotatedOffset :U(CU(PanelOffset))
		Print "	RotatedOffset:", RotatedOffset
Fend



