#include "Globals.INC"

'Function Inspection()
'	
''	SystemStatus = InspectingPanel
'	
'	Integer j
'	Real beta, mu, m1, m2, r1, phi
'  	
'  	DerivethetaR()
''  	PrintCoordArray()
'	GetThetaR() 'get first r and theta
''	On (laserP2) 'Switch to insert inspection profile
'
''	FindPickUpError()
''	xOffset = -.384
''	yOffset = 1.168	
'
'	For j = 0 To recNumberOfHoles - 1 'k is the hole # we are on
'		
'		If j <> 0 Then
'			IncrementIndex()
'			GetThetaR()
'		EndIf
'		
'		If r = 0 Then
'			Print "r=0"
'			Pause
'		EndIf
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
'	'	Print "m1:", m1
'	'	Print "m2:", m2	
'	'	Print "Theta", Theta
'	'	Print "beta Unchanged", GetAngle(m1, m2)
'	
'		If (Theta = 90) Then
'			beta = 180
'		ElseIf (Theta = 270) Then
'			beta = 0
'		ElseIf (90 < Theta And Theta < 180) Then
'	 		beta = GetAngle(m1, m2) + 180 ' add 180 because its obtuse
'		ElseIf (270 < Theta Or Theta < 360) Or (0 < Theta Or Theta < 90) Or (180 < Theta And Theta < 270) Then
'			beta = GetAngle(m1, m2) + 90 'changed from 90
'		Else
'			Print "error, theta is defined as < 360"
'			Pause
'		EndIf
'		
'		mu = (180 - beta) / 2
'		
'		rho = mu /2
'	
'		If Theta = 0 Then
'			P23 = scancenter5 -Y(r1) :U(90)
'		ElseIf Theta = 90 Then
'			P23 = scancenter5 -Y(r1) :U(0)
'		ElseIf Theta = 180 Then
'			P23 = scancenter5 -Y(r1) :U(-90)
'		ElseIf Theta = 270 Then
'			P23 = scancenter5 -Y(r1) :U(-180)
'		ElseIf (0 < Theta And Theta < 90) Then
'			phi = 90 - Theta - mu
'			P23 = scancenter5 -Y(r1 * Cos(DegToRad(mu))) :U(phi) -X(r1 * Sin(DegToRad(mu)))
'		ElseIf (90 < Theta And Theta < 180) Then
'			phi = 90 - Theta - mu
'			P23 = scancenter5 -Y(r1 * Cos(DegToRad(mu))) :U(phi) -X(r1 * Sin(DegToRad(mu)))
'		ElseIf (180 < Theta And Theta < 270) Then
'			phi = 90 - Theta - mu
'			P23 = scancenter5 -Y(r1 * Cos(DegToRad(mu))) :U(phi) -X(r1 * Sin(DegToRad(mu)))
'		ElseIf (270 < Theta And Theta < 360) Then
'			phi = 90 - Theta + mu
'			P23 = scancenter5 -Y(r1 * Cos(DegToRad(mu))) :U(phi) +X(r1 * Sin(DegToRad(mu)))
'		Else
'			Print "Error, theta is greater than 360"
'		EndIf
'		
'	'	Print "beta=", beta
'	'	Print "mu=", mu
'	'	Print "Phi=", phi
'		
'	'	Print P23
'		Wait 2
'		Move P23 -X(xOffset) -Y(yOffset) ROT CP
'		
'		If HoleInspect = True Then
'		'switch to right laser Profile
'		'measure
'		'switch to left
'		'measure
'		
'		'data logging
'	
'		'Pass/fail stuff goes here
'			'Return Pass/Fail, work with Scott on the logging aspect 
'		'	If PanelPassedInspection = False Then
'		'		erPanelFailedInspection = True
'		'		SystemPause()
'		'	Else
'		'		erPanelFailedInspection = False
'		'	EndIf
'		
'		Else
'		'switch to correct laser Profile
'		' This is where I will check the hole for pre-exisiting inserts
'		'If there is an insert then set the flag high so it wont get inserted
'		
'		EndIf
'
'Next
'	
'	SystemStatus = MovingPanel
'	Go ScanCenter3 ' Collision Avoidance Waypoint
'	
'Fend
Function FindPickUpError()
	
Real d1, d2
Integer i

'recMajorDim = 247.142
'recMinorDim = 143.764

Speed 10 'slow it down so we get a better reading
SpeedS 20
	
	Go ScanCenter3 CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 CP Till Sw(laserGo)
	d1 = CY(CurPos)
	On (laserP1)
	
	Go ScanCenter3 +U(180) CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 +U(180) CP Till Sw(laserGo)
	d2 = CY(CurPos)
	On (laserP1)
	yOffset = d1 - d2
	
	Print "yOffset", yOffset
	
	d1 = 0
	d2 = 0
	
	Go ScanCenter3 +U(90) CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 +U(90) CP Till Sw(laserGo)
	d1 = CY(CurPos)
	On (laserP1)
	
	Go ScanCenter3 +U(270) CP  ' Use CP so it's not jumpy
	Wait .25
	
	Off (laserP1)
	Move ScanCenter4 +U(270) CP Till Sw(laserGo)
	d2 = CY(CurPos)
	On (laserP1)
	xOffset = d1 - d2
	
	Print "xOffset", xOffset
	
	d1 = 0
	d2 = 0
	
Fend

