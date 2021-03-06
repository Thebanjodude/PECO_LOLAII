#include "Globals.INC"

'print out the recipe values
Function PanelPrintRecipe
	Integer hole
	Print "  X  ,  Y  ,  Theta"
	Print "-------------------------"
	For hole = 1 To recNumberOfHoles
		Print PanelHoleX(hole), ",", PanelHoleY(hole), ",", PanelHoleTangent(hole)
	Next
Fend

' attempt to find the xyTheta pickup error
Function PanelFindPickupError
	Integer hole
	Real negCos, negSin, laserTheta

	ChangeProfile("00") ' Change profile on the laser
	Call changeSpeed(slow)
		
	'precalculate radius to holes, rotation to holes along radius and tangent angle to holes
	' this will allow us to move the holes close to where they need to be
	' the system theta error is accounted for in panelRecipeRotate()
	Print "precalculating...."
	PanelRecipeRotate(PanelPickupErrorTheta + systemThetaError)
	xy2RadiusRotationTangent


	'Find the real hole location and then save that point
	For hole = 1 To recNumberOfHoles
		laserTheta = 90 - PanelHoleTangent(hole)
		negCos = Cos(DegToRad(-laserTheta))
		negSin = Sin(DegToRad(-laserTheta))
		
		PanelHoleToXYZT(hole, CX(Laser), CY(Laser), CZ(PreScan), laserTheta)
	
		PanelFindHole
		PanelFindXerror
		PanelFindYerror
		
		' put the new hole location into panel space
		PanelHoleX(hole) = ((CX(CurPos) - CX(laser)) * negCos) - ((CY(CurPos) - CY(laser)) * negSin)
		PanelHoleY(hole) = ((CX(CurPos) - CX(laser)) * negSin) + ((CY(CurPos) - CY(laser)) * negCos)
	Next
	
	Print "Done with error correction."

	Call changeSpeed(fast)
Fend

' rotate the panel matrix about the origin
Function PanelRecipeRotate(Theta As Double)
		
	Integer hole
	Double sinTheta
	Double cosTheta
	Double newTheta
	Double newX
	Double newY
	
	'add in the offsets needed to put everything on the same cord system as the robot
'	newTheta = Theta + systemThetaError
	newTheta = Theta
		
	'pre calculate these	
	sinTheta = Sin(DegToRad(newTheta))
	cosTheta = Cos(DegToRad(newTheta))
	
	For hole = 1 To recNumberOfHoles
		newX = (PanelHoleX(hole) * cosTheta) - (PanelHoleY(hole) * sinTheta)
		newY = (PanelHoleX(hole) * sinTheta) + (PanelHoleY(hole) * cosTheta)
		PanelHoleX(hole) = newX
		PanelHoleY(hole) = newY
	Next
Fend

' shift the panel matrix by specific XY amount
Function PanelRecipeTranslate(x As Double, y As Double)
		
	Integer hole

	For hole = 1 To recNumberOfHoles
		PanelHoleX(hole) = PanelHoleX(hole) + x
		PanelHoleY(hole) = PanelHoleY(hole) + y
	Next
Fend


' Given a pre-populated array of x,y values for the holes in a panel and a number of holes
'  this function will step through and calculate the radius and rotation from the center
'  of the panel out to each hole and populate a coresponding radius and rotation value.
'  the rotation is calculated and stored as the rotation in degrees from the positive x-axis
'  to the radius that goes from the center of the panel through the center of the hole
'  It will also calculate an approximate tangent to the panel at each hole location
Function xy2RadiusRotationTangent()
	
	Integer hole
	Real angle
	Real deltaX
	Real deltaY

	' to make wrap around easier store a copy for the highest number hole values in array postion zero
	'  and a copy of the lowest number hole (always 1) in the array postion one higher than the hole count
	PanelHoleX(0) = PanelHoleX(recNumberOfHoles)
	PanelHoleY(0) = PanelHoleY(recNumberOfHoles)
	PanelHoleX(recNumberOfHoles + 1) = PanelHoleX(1)
	PanelHoleY(recNumberOfHoles + 1) = PanelHoleY(1)
	
	'just to be safe
	PanelHoleTangent(0) = 360
	
	For hole = 1 To recNumberOfHoles

		' the approximate tangent is the angle perpendicular to the line connecting the two adjacent holes
		' first find the angle relative to the x-axis of the line connecting the adjacent holes
		' this is alot like the calculations above but just finding the angle from one adjacent hole to the other
		' adjacent hole as though one was the center of the panel
		
		' find the difference between the x and y positions of the two adjacent holes		
		deltaX = PanelHoleX(hole + 1) - PanelHoleX(hole - 1)
		deltaY = PanelHoleY(hole + 1) - PanelHoleY(hole - 1)
		
		If deltaX = 0 Then
			angle = 90
		Else
			angle = Abs(RadToDeg(Atan(deltaY / deltaX)))
		EndIf
			
		' for the first quadrant we are done. For the others we still have some math to do
		' if we are in the second quadrant 
		If (deltaX <= 0) And (deltaY > 0) Then 'include positive y-axis in this quadrant
			angle = 90 - angle ' rotation from positive y-axis around to the angle we found above
			angle = angle + 90 ' add in the 90 degrees of rotation from the first quadrant
			
		' else if we are in the third quadrant
		ElseIf (deltaX < 0) And (deltaY <= 0) Then ' include negative x-axis in this quadrant
			angle = angle + 180 ' angle down from the negative x-axis plus 180 degrees rotation from quadrants one and two
			
		' else if we are in the forth quadrant
		ElseIf (deltaX >= 0) And (deltaY < 0) Then ' include negative y-axis in this quadrant
			angle = 90 - angle ' rotation from negative y-axis around to the angle we found above
			angle = angle + 270 ' add in the rotation through the other three quadrants
		EndIf

		PanelHoleTangent(hole) = angle - 90   ' store the angle tangent to the calculated angle
		
		' we increment the hole count in a clockwise manner (for those of you who remember analog clocks...)		
		'   this means that each successive tangent should be more negative than the previous one
		'   so we are going to use -360 to handle the wrap
		If PanelHoleTangent(hole - 1) < PanelHoleTangent(hole) Then
			PanelHoleTangent(hole) = PanelHoleTangent(hole) - 360
		EndIf
	Next
Fend


' This function will move a panel hole over an x,y coordinate in robot space with the specified rotation
' The rotation is relative to the hole i.e. the hole is the center of rotation
Function PanelHoleToXYZT(hole As Integer, x As Double, y As Double, z As Double, Theta As Double)

	Double rotX
	Double rotY
	
	'rotate about the hole 
'	rotX = (-PanelHoleX(hole) * Cos(DegToRad(Theta))) - (-PanelHoleY(hole) * Sin(DegToRad(Theta)))
'	rotY = (-PanelHoleX(hole) * Sin(DegToRad(Theta))) + (-PanelHoleY(hole) * Cos(DegToRad(Theta)))
	rotX = (PanelHoleX(hole) * Cos(DegToRad(Theta))) - (PanelHoleY(hole) * Sin(DegToRad(Theta)))
	rotY = (PanelHoleX(hole) * Sin(DegToRad(Theta))) + (PanelHoleY(hole) * Cos(DegToRad(Theta)))

	' now put the quill at that point with the x,y offset to the hole
	'Print "  --  x:", x + rotX, " y:", y + rotY, " z:", z, " u:", Theta
	'Go XY(x + rotX, y + rotY, z, Theta) /L
	Jump XY(x + rotX, y + rotY, z, Theta) /L

Fend

'	Grab a panel, clear existing error offsets and learn the new hole positions
Function StartLearnPanel
	PickupPanel
	CrowdingSequence
	
	'clear existing pickup error
	PanelPickupErrorX = 0
	PanelPickupErrorY = 0
	PanelPickupErrorTheta = 0

	Print "x,y -- recipe at start learn panel"
	Integer i
	For i = 1 To recNumberOfHoles
		Print PanelHoleX(i), ",", PanelHoleY(i)
	Next

	PanelFindPickupError
Fend

'moves the panel away from the laser and walks it in to ensure that the error
' measurement routines work
Function PanelFindHole
	Integer count
	Real value

	Go CurPos -Y(30) /L
	
	'A hole should be ~0.765in(~19.43mm) in diameter
	' anything larger than that is not a hole; we are off target
	'
	'Keep stepping in until we are past the edge of the hole
	Do While count < 9
		If Abs(GetLaserMeasurement("07")) < 20.0 Then
			count = count + 1
		EndIf
		Go CurPos +Y(1) /L
	Loop
Fend

Function PanelFindXerror As Real
	Real xShouldBe, tempx
	Boolean foundCenter
	
	xShouldBe = CX(CurPos)

	tempx = GetLaserMeasurement("07") / 4
'	Print "finding X",
	Do While Not foundCenter
'		Print ".",
		' output 7 should return a + or - number indicating the magnitude of error from center
		' move the panel on the x axis by 1/4 the error value until the error is within tolerance
		'		using a 1/4 instead of 1/2 should keep the seeking down
		' output 7 will return -999 if there is a problem with the measurement, so check for that
		' a hole should be less than 20mm in diameter 
		If Abs(tempx) > 20 Then
			'fail... somehow
			If tempx > 0 Then
				tempx = 1
			Else
				tempx = -1
			EndIf
			'tempx = 20
		EndIf
		Go CurPos -X(tempx)
		tempx = GetLaserMeasurement("07") / 4
		If tempx > -holeTolerance And tempx < holeTolerance Then foundCenter = True
	Loop

'	Print " found!"
	PanelFindXerror = CX(CurPos) - xShouldBe
Fend



' find the y pickup error
'
' The diameter of the hole is known (0.765in/19.4mm), so the radius is 9.7mm
' The measured width of the hole is parallel to diameter
' Yerror is perpendicular to the measured width
Function PanelFindYerror As Real
	Real width
	Real yShouldBe
	Real C, A
	Double Yerror
	Real littleC, c_over_b
	Real YerrorOld
	Double Ymove
	Boolean verbose
	Integer missedCenterCount

	' init vars
	YerrorOld = 20
	yShouldBe = CY(CurPos)
	width = 0
	missedCenterCount = 0

	verbose = False
	'verbose = True

	If verbose Then Print "littleC, yerror, ymove, width, C, A"

	Do While True
		width = -GetLaserMeasurement("04") + GetLaserMeasurement("03")
		
		' check for out of bounds width measurements, and force a step if the 
		'    measurement is too large (hole is ~20mm)
		If Abs(width) > holeDiameter Then width = 1
		
		'check to see if we are at the center of the hole
		If (holeDiameter - width) < 0.1 Then
			If verbose Then Print "Width: ", width
			Exit Do
		EndIf

		' find the angle between Yerror and the radius from the center to where 
		'		the width measurement touches the side of the hole
		'		C = sin-1 (c/b)
		littleC = 0.5 * width
		c_over_b = littleC / holeRadius

		' ensure that we don't feed arcsin a value that's too large
		If c_over_b >= 1 Then c_over_b = 0.999999

		If verbose Then Print littleC,
		C = RadToDeg(Asin(c_over_b))
		
		'	find the angle between the radius from the center and measured width
		'		all angles added up to 180, so 180 - 90 - C = A
		A = 90 - C
		
		' sovle for Yerror
		'		Yerror = radius * sin(A)
		'		/4 is to reduce dithering, the robot will only move by 1/4 of the error
		'			until we are within tolerance
		Yerror = holeRadius * Sin(DegToRad(A))
		Ymove = Yerror /8

		If verbose Then Print Yerror, ",", Ymove, ",", width, ",", C, ",", A
		
		'If Yerror > -holeTolerance And Yerror < holeTolerance Then Exit Do
		'If Yerror < 0.25 Then Exit Do
		
		If YerrorOld + 0.5 < Yerror Then
			missedCenterCount = missedCenterCount + 1
			If missedCenterCount > 3 Then
				If verbose Then Print "refinding X due to gross y error"
				PanelFindXerror
				missedCenterCount = 0
			Else
				Go CurPos -Y(5)
				If verbose Then Print "missed center of hole"
			EndIf
			YerrorOld = 20
		Else
			Go CurPos +Y(Ymove)
			YerrorOld = Yerror
		EndIf
	Loop
	
	PanelFindYerror = CY(CurPos) - yShouldBe
Fend

