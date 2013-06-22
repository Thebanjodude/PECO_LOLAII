#include "Globals.INC"

Function InspectPanel2()
	
	Integer j
	Real rightoffset, leftoffset, beta, mu, rho, phi
	Real dx, dy, m1, m2
	
	Trap 2, MemSw(jobAbortH) = True GoTo exitInspectPanel ' arm trap
	Go PreScan ' Collision Avoidance Waypoint
	SystemStatus = InspectingPanel
	
	GetPanelArray() '
	DerivethetaR()
	PanelArrayIndex = 0
	GetThetaR() 'Get first r and theta
	Pause
	
'	FindPickUpError()
	Go prescan CP
	
	For j = 0 To recNumberOfHoles - 1 'j is the hole # we are on
		
		 currentInspectHole = j ' Use these to tell HMI the which hole we are working on.
		 currentPreinspectHole = j
		
		If j <> 0 Then
			IncrementIndex()
			GetThetaR() ' get the next r and theta
		EndIf
		
		If r = 0 Then
			Print "r=0"
			Pause
		EndIf

		If Theta = 0 Or Theta = 90 Or Theta = 180 Or Theta = 270 Then
			
			Print Theta, r
'			RotatedError(Theta) ' Set RotatedOffset Point
			
			P23 = (LaserCenter) +X(r) -U(Theta)
			Go P23
			GoTo skip
			Pause
			
		EndIf
			
		If j = 0 Then ' Find the slopes of the lines that connect the holes
			mu = findmu(recNumberOfHoles - 1, j + 1) 'the last hole to the hole+1
		ElseIf j = recNumberOfHoles - 1 Then
			mu = findmu(j - 1, 0) 'from the hole before to the hole
		Else
			mu = findmu(j - 1, j + 1) 'from the hole before to the hole
		EndIf

		Print "mu", mu

		rho = mu ' this is the place to experiment with the angle

		'Rotate PanelOffset to Theta		
			
		If (0 < Theta And Theta < 90) Or (180 < Theta And Theta < 270) Then
			
			phi = Theta + rho
			Print "phi:", phi
            P23 = (LaserCenter) +X(r) -U(phi)
	       	Go P23
	       	Wait 1
			dx = r - (r * Cos(DegToRad(rho)))
	       	dy = r * Sin(DegToRad(rho))
	       	P23 = P23 -X(dx) +Y(dy)
	       	Go P23
	       	Wait 1

		ElseIf (90 < Theta And Theta < 180) Or (270 < Theta And Theta < 360) Then
			If j <> 0 Then

			EndIf

			phi = Theta - rho
			Print "phi:", phi
            P23 = (LaserCenter) +X(r) -U(phi)
	       	Go P23
	       	Wait 1
			dx = r - (r * Cos(DegToRad(rho)))
	       	dy = r * Sin(DegToRad(rho))
            P23 = P23 +X(dx) +Y(dy)
 	       	Go P23
 	 	    Wait 1
 	 	    
		Else
			Print "Error, theta is greater than 360"
		EndIf
			
	
'		ChangeProfile("00")
'		RightOffset = GetLaserMeasurement("03")
'		leftoffset = GetLaserMeasurement("04")
'		thetaOffset = RadToDeg(Asin((RightOffset + leftoffset) / (2 * r)))
'		
'		Print "thetaOffset: ", thetaOffset
'		PanelOffset = PanelOffset -U(thetaOffset)
'		FindPickUpError()	

	skip:
	Next
	
exitInspectPanel:
	
Fend

'Function InspectPanel(HoleInspect As Boolean) As Boolean
'	
'	Trap 2, MemSw(jobAbortH) = True GoTo exitInspectPanel ' arm trap
'	Go PreScan ' Collision Avoidance Waypoint
'	SystemStatus = InspectingPanel
'	InspectPanel = False
'	
'	Integer k, j
'	Real beta, mu, m1, m2, r1, phi, rho
'	Real y1, y2, y3, dy, dx, deltaRotX, deltaRotY
'	Real RightOffset, LeftOffset
'  	  	
'  	GetPanelArray()
'
'	GetThetaR() 'get first r and theta
'	PanelArrayIndex = 0
'
'	Redim InspectionArray(22, 1) ' Make the arrays big enough to fit all the panels
'	Redim PassFailArray(22, 1)
'	recInsertDepth = .165 ' fake for testing
'
'	For j = 0 To recNumberOfHoles - 1 'j is the hole # we are on
'
'		If j <> 0 Then
'			IncrementIndex()
'			GetThetaR() ' get the next r and theta
'		EndIf
'
'		If r = 0 Then
'			Print "r=0"
'			Pause
'		EndIf
'
'		PrintCoordArray() ' visual inspection make sure we have the right array
'	
'		If j = 0 Then ' Find the slopes of the lines that connect the holes
'			m1 = FindSlope(recNumberOfHoles - 1, j) 'the last hole to the hole
'			m2 = FindSlope(j, j + 1) 'from the hole to the next hole
'		ElseIf j = recNumberOfHoles - 1 Then
'			m1 = FindSlope(j - 1, j) 'from the hole before to the hole
'			m2 = FindSlope(j, 0) ' from the last hole to the first hole
'		Else
'			m1 = FindSlope(j - 1, j) 'from the hole before to the hole
'			m2 = FindSlope(j, j + 1) 'from the hole to the next hole
'		EndIf
'
'		If Theta = 0 Then
'			beta = 180
'			mu = 0
'		ElseIf (Theta = 90) Then
'			beta = 180
'			mu = 0
'		ElseIf (Theta = 270) Then
'			beta = 180
'			mu = 0
'		ElseIf (270 < Theta And Theta < 360) Or (90 < Theta And Theta < 180) Then
'	 		beta = GetAngle(m1, m2) + 90 ' add 180 because its obtuse
'			mu = (180 - beta) / 2
'		ElseIf (0 < Theta And Theta < 90) Or (180 < Theta And Theta < 270) Then
'			beta = GetAngle(m1, m2) + 90
'			mu = (180 - beta) / 2
'		Else
'			Print "error, theta is defined as < 360"
'			'recipe error...?
'			Pause
'		EndIf
'
'		rho = mu ' this is the place to experiment with the angle
'
'		'Rotate PanelOffset to Theta		
'
'		If Theta = 0 Or Theta = 90 Or Theta = 180 Or Theta = 270 Then
'		
'			RotatedError(Theta)
'			
'			P23 = (LaserCenter) -Y(r) -U(Theta)
'			Go P23
'			Pause
'			
'		ElseIf (0 < Theta And Theta < 90) Or (180 < Theta And Theta < 270) Then
'			
'			RotatedError(Theta)
'
'			phi = Theta + rho
'			RotatedError(phi)
'			Print "phi:", phi
'            P23 = (LaserCenter) -Y(r) -U(phi)
'
'			dy = r - (r * Cos(DegToRad(rho)))
'	       	dx = r * Sin(DegToRad(rho))
'	       	P23 = P23 -X(dx) +Y(dy)
'
'		ElseIf (90 < Theta And Theta < 180) Or (270 < Theta And Theta < 360) Then
'			If j <> 0 Then
'				RotatedError(Theta)
'			EndIf
'
'			phi = Theta - rho
'			RotatedError(phi)
'			Print "phi:", phi
'            P23 = (LaserCenter) -Y(r) -U(phi)
'
'			dy = r - (r * Cos(DegToRad(rho)))
'	       	dx = r * Sin(DegToRad(rho))
'            P23 = P23 +X(dx) +Y(dy)
'            
'		Else
'			Print "Error, theta is greater than 360"
'		EndIf
'
'		If j = 0 Then
'		' We find the theta offset using the laset scanner. We use the position of the
'		'hole walls and derive theta offset 
'				Go P23 - RotatedOffset
'				ChangeProfile("00")
'				RightOffset = GetLaserMeasurement("03")
'				LeftOffset = GetLaserMeasurement("04")
'				thetaerror = RadToDeg(Asin((RightOffset + LeftOffset) / (2 * r)))
'				
'				Print "thetaerror: ", thetaerror
'
'				If Abs(thetaerror) > 3 Then
'					Print "thetaoffset is more than 3 deg"
'					Pause
'				EndIf
'
''				PanelOffset = PanelOffset -U(thetaerror)
'				FindPickUpError()
''				Print "PanelOffset:", PanelOffset
''				RotatedError(Theta)
'		EndIf
'		
'		Print "RotatedOffset:", RotatedOffset
'		P23 = P23 - RotatedOffset
'		Go P23
'		Print "j:", j
'		Print " position:", P23
'		
'		If HoleInspect = True Then
'			Go P23 -Z(8) -X(5)
'			Wait .1
''			MeasureInsertDepth()
'			ChangeProfile("10")
'			Print "diff", MicroMetersToInches(GetLaserMeasurement("11") - GetLaserMeasurement("13"))
'
'		Else
'		'switch to correct laser Profile		
'			ChangeProfile("07")
'			Print GetLaserMeasurement("01")
'			If GetLaserMeasurement("01") > 35 Then ' There is already an insert so set skip flag
'				PanelArray(j, SkipFlagColumn) = 1
'			EndIf
'
'		EndIf
'		Pause
'		
'	InspectPanel = True
'Next
'
'	PrintPassFailArray()
''	PrintInspectionArray()
''	PrintPanelArray()
'
'	UnpackInspectionArrays()
'
'exitInspectPanel:
'
'	SystemStatus = MovingPanel
'	Go PreScan ' Go Home
'	Trap 2 'disarm trap
'Fend
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
	
	PrintInspectionArray()
	
Fend
Function MicroMetersToInches(um As Real) As Real
		MicroMetersToInches = um * .00003937
Fend
Function PassOrFail(measurement As Real) As Boolean 'Pass is True	
	
	Real DepthInsertError
	
	DepthInsertError = Abs(recInsertDepth - measurement)
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
Function FakeLogging()
	
	Integer i
	recNumberOfHoles = 23
	Redim InspectionArray(22, 1)
	
	For i = 0 To recNumberOfHoles - 1
		InspectionArray(i, LeftSpotFace) = i
		InspectionArray(i, RightSpotFace) = i
	Next

PrintInspectionArray
UnpackInspectionArrays
Fend

Function UnpackInspectionArrays()
	
'Sending a JSON array is a pain so we are just unpacking the array into seperate vars 	
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
	'Sending a JSON array is a pain so we are just unpacking the array into seperate vars 
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
	
Fend
Function RotatedError(HoleAngle As Real, StationAngle As Real)
	
	Real Xoffset, Yoffset, xerror, yerror

'	xerror = CX(PanelPickupCorct)
'	yerror = CY(PanelPickupCorct)
	
	Yoffset = -CX(PanelPickupCorct) 'switch the coordinates
	Xoffset = CY(PanelPickupCorct)
	
'	Xoffset = xerror * Cos(DegToRad(HoleAngle + StationAngle)) + yerror * Sin(DegToRad(HoleAngle + StationAngle))
'	Yoffset = xerror * Sin(DegToRad(HoleAngle + StationAngle)) + yerror * Cos(DegToRad(HoleAngle + StationAngle))
	
'	If HoleAngle = 90 Or HoleAngle = 270 Then ' In the ppt pres it has this correction but I 
''		Xoffset = -Xoffset 					' still am not sure its needed. We will see
'		Yoffset = -Yoffset
'	EndIf
	
	RotatedOffset = RotatedOffset :X(Xoffset) :Y(Yoffset)
	Print "RotatedOffset", RotatedOffset
	
Fend
Function findmu(pt1 As Real, pt2 As Real) As Real
	
Real x1, x2, y1, y2, dx, dy
	
x1 = PanelCordinates(pt1, 0)
x2 = PanelCordinates(pt2, 0)
y1 = PanelCordinates(pt1, 1)
y2 = PanelCordinates(pt2, 1)

dx = x2 - x1
dy = y2 - y1

If dx = 0 Or dy = 0 Then
	Print "error calculating mu, dx or dy =0"
	Pause
EndIf

findmu = Atan(Abs(dx / dy))

Fend
'Function RotatePanelOffset(angle As Real) 'in degrees
'		
'		'Compute the rotated X,Y and U PanelOffset components
'		RotatedOffset = RotatedOffset :X(CX(PanelOffset) * Sin(DegToRad(angle)) + CY(PanelOffset) * Cos(DegToRad(angle)))
''		Print "	RotatedOffset:", RotatedOffset
'		RotatedOffset = RotatedOffset :Y(CX(PanelOffset) * Cos(DegToRad(angle)) + CY(PanelOffset) * Sin(DegToRad(angle)))
''		Print "	RotatedOffset:", RotatedOffset
'		RotatedOffset = RotatedOffset :U(CU(PanelOffset))
'		Print "	RotatedOffset:", RotatedOffset
'Fend



