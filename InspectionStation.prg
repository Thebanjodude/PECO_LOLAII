#include "Globals.INC"
Global Integer FirstHolePoint, DoubleTriggered
Global Real CurrentTheta, LastTheta

Function ScanPanel() ' This code is just a place holder until we work out the edge following...

Motor On
Power Low
SpeedS 500
AccelS 1000
SpeedR 400
AccelR 300
Speed 10
Accel 10, 10

Integer t
TracePanelEdge()

retrace:

FindHoles()

GoToHoles() ' Play back the holes we found

Inspection()

Print "Adjust laser parameters now"
Print "DoubleTriggered: ", DoubleTriggered

Pause
z = 0
DoubleTriggered = 0
PanelArrayIndex = 0
'Trap 1 ' turn off trap
Redim PanelArray(25, 2) ' Reinitialize panel array
GoTo retrace

Fend
Function EdgeDetected
	
	If Sw(laserLo) = True Then
		Move Here +Y(1.2)
	ElseIf Sw(laserHi) = True Then
		Move Here -Y(1.2)
	EndIf
	
	P(x) = Here
	x = x + 1
	
	Trap 1 Sw(laserHi) = True Or Sw(laserLo) Call EdgeDetected
		
Fend
Function TracePanelEdge()
	
x = 100 ' start edge points at 100
Off (laserP1) ' Change to laser profile 0

Go ScanCenter3 CP  ' Use CP so it's not jumpy
Wait .5

Go ScanCenter4 CP Till Sw(laserGo)
Move Here -Y(1.2)
P(x) = Here
x = x + 1

Trap 1 Sw(laserHi) = True Or Sw(laserLo) Call EdgeDetected
Print "Edge time start: ", Time$

Do While CU(Here) < (490) 'Spin around 360 degrees

     Move ScanCenter3 :U(485) CP ROT
	
If CU(Here) > 455 Then
	Exit Do
EndIf
Loop

Trap 1 ' turn off trap

Print "Edge time end: ", Time$
Fend
Function FindHoles()
	
Speed 1
Accel 100, 100
FirstHolePoint = 600 'Start hole locations at 600	
Integer i
i = 100
On (laserP1) ' Change to laser profile 1	

Print "Scan time start: ", Time$
Go P(100) +Y(23) +Z(3.5) CP ' go to the first point

Trap 4 Sw(holeDetected) Xqt RecordTheta ' Arm Trap	

	For i = 100 To (x - 1)
		Go P(i) +Y(23) +Z(3.5) CP
	Next i
	
Trap 4 'turn off trap
recNumberOfHoles = z
PrintPanelArray()
Print "Scan time end: ", Time$
Print "found holes:", z

Fend
Function RecordTheta

CurrentTheta = CU(CurPos)
Print "called trap"
	
If CurrentTheta - LastTheta > 5 Or z = 0 Then ' need z=0 to see first hole
	r = 635 - CY(CurPos) '635mm is an eyeballed y coordinate of laser scannr
	PanelArray(PanelArrayIndex, RadiusColumn) = r 'Assign r and theta to array
	PanelArray(PanelArrayIndex, ThetaColumn) = CurrentTheta
	PanelArrayIndex = PanelArrayIndex + 1

	Print "found a hole"
	P(FirstHolePoint + z) = CurPos

	z = z + 1 ' count num of holes found
	LastTheta = CurrentTheta
'TODO:add check to make sure we dont increment beyond bounds
Else
	DoubleTriggered = DoubleTriggered + 1
EndIf

Trap 4 Sw(holeDetected) Xqt RecordTheta 'rearm trap

Fend
Function Inspection() As Boolean
	SystemStatus = InspectingPanel
	
	Boolean SkippedHole
	Integer k
  	
	PanelArrayIndex = 0 ' Reset Index

	GetThetaR()
	Print "r", r
	Print "theta", Theta
	
	For k = 0 To z - 1
		
		If k <> 0 Then
			IncrementIndex()
			GetThetaR()
			Print "r", r
			Print "theta", Theta
			
			If r = 0 Then
				Print "r=0"
				Pause
			EndIf
		EndIf

		SkippedHole = False 'Reset flag
		
		If PanelArray(PanelArrayIndex, SkipFlagColumn) <> 0 Then ' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 'Set flag
		EndIf

		If SkippedHole = False Then 'If the flag is set then we have finished all holes		
			P23 = InspectionCenter -Y(PanelArray(PanelArrayIndex, RadiusColumn)) :U(PanelArray(PanelArrayIndex, ThetaColumn))
			Move P23 CP ROT
			Wait 1
			'Pass/fail stuff goes here
		EndIf

	Next
	
	'Return Pass/Fail, work with Scott on the logging aspect 
'	If PanelPassedInspection = False Then
'		erPanelFailedInspection = True
'		SystemPause()
'	Else
'		erPanelFailedInspection = False
'	EndIf
	
	SystemStatus = MovingPanel
	Go ScanCenter3 ' Collision Avoidance Waypoint
	
Fend
Function GoToHoles()
	
Speed 50
Accel 10, 10
	Integer j
	
	Print "going to the holes I found: ", z
	
	If z = 0 Then
		Print "Didnt Find Any holes"
		GoTo skip
	EndIf
	
	For j = 600 To 600 + z - 1
		Go P(j)
		Wait .5
  	Next j
  	
	Skip:
	
Fend
Function LaserAlarm
	Print "Laser Alarm"
'	SetErrorArrayFlag(LaserAlarmError, True)
'	SystemPause()
Pause
	Trap 3 Sw(laserHi) = True And Sw(laserLo) = True Call LaserAlarm
Fend
Function PreInspection()
	SystemStatus = ScanningPanel
	ScanPanel() ' During ScanPanel the scanner will write PanelArray in the IOTable
	
	SystemStatus = MovingPanel
	Go ScanCenter ' Collision Avoidance Waypoint
Fend
