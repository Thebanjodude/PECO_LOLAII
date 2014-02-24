#include "Globals.INC"


' ------------MOCK------------
' ---------TODO--Replace with recipe values-------
Function LoadPanelInfo()
	' load the following vars with the corrected values
	'  this might be pulled into LoadRecipe
	'  --Just remember that the recipe values need to be translated to robot space....

'	Global Preserve Integer PanelHoleCount
'	Global Preserve Double PanelHoleX(25)
'	Global Preserve Double PanelHoleY(25)
'	Global Preserve Double PanelHoleTangent(25)
'	Global Preserve Double PanelPickupErrorX
'	Global Preserve Double PanelPickupErrorY
'	Global Preserve Double PanelPickupErrorTheta
	
	'for now
	Call LoadRecipe
	
Fend

' ------------MOCK------------
' ---------TODO--Replace with recipe values from HMI-------
Function LoadRecipe
		
	' panel pn:  51010
	PanelHoleCount = 23
	
	PanelHoleX(1) = InTomm(8.850)
	PanelHoleY(1) = InTomm(0.000)
	PanelHoleX(2) = InTomm(8.350)
	PanelHoleY(2) = InTomm(-1.950)
	PanelHoleX(3) = InTomm(7.090)
	PanelHoleY(3) = InTomm(-3.360)
	PanelHoleX(4) = InTomm(5.320)
	PanelHoleY(4) = InTomm(-4.190)
	PanelHoleX(5) = InTomm(3.410)
	PanelHoleY(5) = InTomm(-4.629)
	PanelHoleX(6) = InTomm(1.460)
	PanelHoleY(6) = InTomm(-4.814)
	PanelHoleX(7) = InTomm(-0.460)
	PanelHoleY(7) = InTomm(-4.846)
	PanelHoleX(8) = InTomm(-2.420)
	PanelHoleY(8) = InTomm(-4.744)
	PanelHoleX(9) = InTomm(-4.350)
	PanelHoleY(9) = InTomm(-4.450)
	PanelHoleX(10) = InTomm(-6.200)
	PanelHoleY(10) = InTomm(-3.854)
	PanelHoleX(11) = InTomm(-7.800)
	PanelHoleY(11) = InTomm(-2.764)
	PanelHoleX(12) = InTomm(-8.740)
	PanelHoleY(12) = InTomm(-1.021)
	PanelHoleX(13) = InTomm(-8.740)
	PanelHoleY(13) = InTomm(1.021)
	PanelHoleX(14) = InTomm(-7.800)
	PanelHoleY(14) = InTomm(2.764)
	PanelHoleX(15) = InTomm(-6.200)
	PanelHoleY(15) = InTomm(3.854)
	PanelHoleX(16) = InTomm(-4.350)
	PanelHoleY(16) = InTomm(4.450)
	PanelHoleX(17) = InTomm(-2.420)
	PanelHoleY(17) = InTomm(4.744)
	PanelHoleX(18) = InTomm(-0.460)
	PanelHoleY(18) = InTomm(4.846)
	PanelHoleX(19) = InTomm(1.460)
	PanelHoleY(19) = InTomm(4.814)
	PanelHoleX(20) = InTomm(3.410)
	PanelHoleY(20) = InTomm(4.629)
	PanelHoleX(21) = InTomm(5.320)
	PanelHoleY(21) = InTomm(4.190)
	PanelHoleX(22) = InTomm(7.090)
	PanelHoleY(22) = InTomm(3.360)
	PanelHoleX(23) = InTomm(8.350)
	PanelHoleY(23) = InTomm(1.950)
	
Fend

' attempt to find the xyTheta pickup error
Function PanelFindPickupError
	Integer hole
	Real negCos, negSin, laserTheta

	ChangeProfile("00") ' Change profile on the laser
	Call changeSpeed(slow)
	
	LoadRecipe
	
	'precalculate radius to holes, rotation to holes along radius and tangent angle to holes
	' this will allow us to move the holes close to where they need to be
	' the system theta error is accounted for in panelRecipeRotate()
	Print "precalculating...."
	PanelRecipeRotate(PanelPickupErrorTheta + systemThetaError)
	xy2RadiusRotationTangent


	'Find the real hole location and then save that point
	For hole = 1 To PanelHoleCount
		laserTheta = 90 - PanelHoleTangent(hole)
		negCos = Cos(DegToRad(-laserTheta))
		negSin = Sin(DegToRad(-laserTheta))
		
		PanelHoleToXYZT(hole, CX(Laser), CY(Laser), CZ(PreScan), laserTheta)
	
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
	Go XY(x + rotX, y + rotY, z, Theta) /L

Fend

Function PanelFindXerror As Real
	Real xShouldBe, tempx
	Boolean foundCenter
	
	xShouldBe = CX(CurPos)

	tempx = GetLaserMeasurement("07") / 2
	Print "finding X",
	Do While Not foundCenter
		Print ".",
		' output 7 should return a + or - number indicating the magnitude of error from center
		' move the panel on the x axis by 1/4 the error value until the error is within tolerance
		'		using a 1/4 instead of 1/2 should keep the seeking down
		Go CurPos -X(tempx)
		tempx = GetLaserMeasurement("07") / 4
		If tempx > -holeTolerance And tempx < holeTolerance Then foundCenter = True
	Loop

	Print " found!"
	PanelFindXerror = CX(CurPos) - xShouldBe
Fend

' find the y pickup error
Function PanelFindYerror As Real
	Real width, widthPrevious
	Real yShouldBe
	Boolean foundCenter, outsideHole
	Integer count

	yShouldBe = CY(CurPos)
	foundCenter = False
	width = 0
	widthPrevious = 0

	' attempt to ensure that we start on the outside of the panel
	Go CurPos -Y(4) /L
	outsideHole = False
	
	Print "finding Y",
	Do While Not foundCenter
		Print ".",
		widthPrevious = width
		width = -GetLaserMeasurement("04") + GetLaserMeasurement("03")

		If width < widthPrevious Then
			'we might have passed the center
			'increment counter, we want to be 6 steps past the center
			count = count + 1
		Else
			'we might have had a false positive, remove it
			count = count - 1
			If count < 0 Then count = 0
			outsideHole = True
		EndIf
		
		If count > 6 Then
			'check to see if we started on the correct side of the hole
			If outsideHole = True Then
				'we have passed the center of the hole, move back to center
				Go CurPos -Y(stepsize * 6) /L
				foundCenter = True
			Else
				'we started on the wrong side of the hole, do over
				Go CurPos -Y(stepsize * 18) /L
				count = 0
			EndIf
		Else
			'step in one more time
			Go CurPos +Y(stepsize) /L
		EndIf
	Loop
	
	Print " found!"
	PanelFindYerror = CY(CurPos) - yShouldBe
Fend

