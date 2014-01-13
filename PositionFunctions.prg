#include "Globals.INC"


' ------------MOCK------------
' ---------TODO--Replace with recipe values-------
Function LoadPanelInfo()
	
	Call loadRecipe

Fend

Function PanelFindXerror As Real
	Real xShouldBe, tempx
	Boolean foundCenter
	
	xShouldBe = CX(CurPos)

	tempx = GetLaserMeasurement("07") / 2
	Do While Not foundCenter
		' output 7 should return a + or - number indicating the magnitude of error from center
		' move the panel on the x axis by 1/2 the error value until the error is within tolerance
		Go CurPos -X(tempx)
		tempx = GetLaserMeasurement("07") / 2
		If tempx > -holeTolerance And tempx < holeTolerance Then foundCenter = True
	Loop
	PanelFindXerror = CX(CurPos) - xShouldBe
Fend

' find the y pickup error
Function PanelFindYerror As Real
	Real width, widthPrevious
	Real yShouldBe
	Boolean foundCenter
	Integer stepSize

	stepSize = 1
	yShouldBe = CY(CurPos)
	foundCenter = False
	width = 0
	widthPrevious = 0

	' attempt to ensure that we start on the outside of the panel
	Go CurPos -Y(0.5) /L
	Do While Not foundCenter
		widthPrevious = width
		width = -GetLaserMeasurement("04") + GetLaserMeasurement("03")

		If width > widthPrevious Then
			'we are still moving into the hole
			Go CurPos +Y(stepSize) /L
		Else
			'we have passed the center of the hole, move back by half a step
			Go CurPos -Y(stepSize / 2) /L
			foundCenter = True
		EndIf
	Loop
	
	PanelFindYerror = CY(CurPos) - yShouldBe
Fend

' helper function to calculate theta
Function findTheta(angA As Real, sideB As Real, sideC As Real) As Real
	Real sideA, angB, angC
	
	' law of Cosines
	' a **2 = b **2 + c**2 - 2bc * cos(A)
	'sideA = Sqr(sideB ** 2 + sideC ** 2 - 2 * sideB * sideC * Cos(DegToRad(angA)))

	sideA = findSideA(angA, sideB, sideC)
	
	' law of sines
	' sin(B)/b = sin(A)/a
	angB = RadToDeg(Asin(Sin(angA) * sideB / sideA))
	
	' in case it comes up	
	' 180 = angA + angB + angC
	' angC = 180 - angA - angB
	
	findTheta = angB
Fend
Function findSideA(angA As Real, sideB As Real, sideC As Real) As Real
	' law of Cosines
	' a **2 = b **2 + c**2 - 2bc * cos(A)
	findSideA = Sqr(sideB ** 2 + sideC ** 2 - 2 * sideB * sideC * Cos(DegToRad(angA)))
Fend

' attempt to find the xyTheta pickup error
Function PanelFindPickupError
	Real errorY(3), errorX(3), errorTheta(3)
	Real theta(3)
	Integer hole

	ChangeProfile("00") ' Change profile on the laser
	Call changeSpeed(slow)

	Print "finding first two holes for error detection"
	For hole = 1 To 2
	' check the position of the first two holes
		PanelHoleToXYZT(hole, CX(Laser), CY(Laser), CZ(PreScan), -90 - PanelHoleTangent(hole))
		
		errorX(hole) = PanelFindXerror
		errorY(hole) = PanelFindYerror
'		errorTheta(hole) = findTheta(90, errorX(hole), errorY(hole))

 	Next

	' assume that errors that we are finding in robot cord space can be applied to panel cord space
	' we know the absolute values of the x and y errors for two locations

'	Print "found Theta offset, recalculating"
'	LoadPanelInfo
'    PanelRecipeRotate(PanelPickupErrorTheta)
'	xy2RadiusRotationTangent

	Print "finding XY offsets"
	hole = 1
	PanelHoleToXYZT(hole, CX(Laser), CY(Laser), CZ(PreScan), -90 - PanelHoleTangent(hole))
	errorX(0) = PanelFindXerror
	errorY(0) = PanelFindYerror

	Print "done with error correction detection"
	Print "------------------------"

	PanelPickupErrorX = -errorY(0)
	PanelPickupErrorY = errorX(0)

	Print "panel error x = ", PanelPickupErrorX
	Print "panel error y = ", PanelPickupErrorY
	Print "----------------------------"

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
	newTheta = Theta + EOATcorrection + magazineCorrection
		
	'pre calculate these	
	sinTheta = Sin(DegToRad(newTheta))
	cosTheta = Cos(DegToRad(newTheta))
	
	For hole = 1 To PanelHoleCount
		newX = (PanelHoleX(hole) * cosTheta) - (PanelHoleY(hole) * sinTheta)
		newY = (PanelHoleX(hole) * sinTheta) + (PanelHoleY(hole) * cosTheta)
		PanelHoleX(hole) = newX
		PanelHoleY(hole) = newY
	Next
Fend
' shift the panel matrix by specific XY amount
Function PanelRecipeTranslate(x As Double, y As Double)
		
	Integer hole

	For hole = 1 To PanelHoleCount
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
	PanelHoleX(0) = PanelHoleX(PanelHoleCount)
	PanelHoleY(0) = PanelHoleY(PanelHoleCount)
	PanelHoleX(PanelHoleCount + 1) = PanelHoleX(1)
	PanelHoleY(PanelHoleCount + 1) = PanelHoleY(1)
	
	'just to be safe
	PanelHoleTangent(0) = 360
	
	For hole = 1 To PanelHoleCount

		' the radius is the hypotenuse of the angle formed by the x and y values
		PanelHoleRadius(hole) = Sqr((PanelHoleX(hole) ** 2) + (PanelHoleY(hole) ** 2))
		
		' the angle between the x-axis and the hole is the arctangent of y divided by x	
		' if x is zero (hole is on the y axis) then the angle is 90 degrees just poke it in to avoid div by zero error
		If PanelHoleX(hole) = 0 Then
			angle = 90
		Else
			angle = Abs(RadToDeg(Atan(PanelHoleY(hole) / PanelHoleX(hole))))
		EndIf
		
		' for the first quadrant we are done. For the others we still have some math to do
		' if we are in the second quadrant 
		If (PanelHoleX(hole) <= 0) And (PanelHoleY(hole) > 0) Then 'include positive y-axis in this quadrant
			angle = 90 - angle ' rotation from positive y-axis around to the angle we found above
			angle = angle + 90 ' add in the 90 degrees of rotation from the first quadrant
			
		' else if we are in the third quadrant
		ElseIf (PanelHoleX(hole) < 0) And (PanelHoleY(hole) <= 0) Then ' include negative x-axis in this quadrant
			angle = angle + 180 ' angle down from the negative x-axis plus 180 degrees rotation from quadrants one and two
			
		' else if we are in the forth quadrant
		ElseIf (PanelHoleX(hole) >= 0) And (PanelHoleY(hole) < 0) Then ' include negative y-axis in this quadrant
			angle = 90 - angle ' rotation from negative y-axis around to the angle we found above
			angle = angle + 270 ' add in the rotation through the other three quadrants
		EndIf
			
		PanelHoleRotation(hole) = angle ' store the angle we calculated
		
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
		
		'Print "Hole ", hole, " has radius ", PanelHoleRadius(hole), " and rotation ", PanelHoleRotation(hole), " Tangent is ", PanelHoleTangent(hole)
	
	Next
Fend
' This function will move a panel hole over an x,y coordinate in robot space with the specified rotation
' The rotation is relative to the hole i.e. the hole is the center of rotation
Function PanelHoleToXYZT(hole As Integer, x As Double, y As Double, z As Double, Theta As Double)

	Double rotX
	Double rotY
	
	'rotate about the hole 
	rotX = (-PanelHoleX(hole) * Cos(DegToRad(Theta))) - (-PanelHoleY(hole) * Sin(DegToRad(Theta)))
	rotY = (-PanelHoleX(hole) * Sin(DegToRad(Theta))) + (-PanelHoleY(hole) * Cos(DegToRad(Theta)))
	
	' now put the quill at that point with the x,y offset to the hole
	Print "  --  x:", x + rotX, " y:", y + rotY, " z:", z, " u:", Theta
	Go XY(x + rotX, y + rotY, z, Theta) /L

Fend

