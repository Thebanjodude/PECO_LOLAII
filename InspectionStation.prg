#include "Globals.INC"
Global Integer FirstHolePoint, DoubleTriggered
Global Real CurrentTheta, LastTheta

Function PreInspection()
	SystemStatus = ScanningPanel
	ScanPanel() ' During ScanPanel the scanner will write PanelArray in the IOTable
	
	SystemStatus = MovingPanel
	Go ScanCenter ' Collision Avoidance Waypoint
Fend
Function Inspection() As Boolean
	SystemStatus = InspectingPanel
	ScanPanel()
	
	'Return Pass/Fail, work with Scott on the logging aspect 
	If PanelPassedInspection = False Then
		erPanelFailedInspection = True
		SystemPause()
	Else
		erPanelFailedInspection = False
	EndIf
	
	SystemStatus = MovingPanel
	Go ScanCenter  ' Collision Avoidance Waypoint

Fend
Function ScanPanel() ' This code is just a place holder until we work out the edge following...

Motor On
Power High
SpeedS 500
AccelS 1000
SpeedR 400
AccelR 300
Speed 5
Accel 10, 10

Integer t
TracePanelEdge()

retrace:

FindHoles()

For t = 0 To 2
	GoToHoles() ' Play back the holes we found
Next

Print "Adjust laser parameters now"
Print "DoubleTriggered: ", DoubleTriggered
Pause
z = 0
DoubleTriggered = 0
Trap 1 ' turn off trap
GoTo retrace

Fend
Function TracePanelEdge()
	
x = 100 ' start edge points at 100
Off (laserP1) ' Change to laser profile 0

Go ScanCenter -Y(40) CP  ' Use CP so it's not jumpy
Wait 1

Go ScanCenter2 CP Till Sw(laserGo)
Move Here -Y(1.2)
P(x) = Here
x = x + 1

Trap 1 Sw(laserHi) = True Or Sw(laserLo) Call EdgeDetected
Print "Edge time start: ", Time$

Do While CU(Here) < (480) 'Spin around 360 degrees

     Move EdgeDetect :U(465) CP ROT
	
If CU(Here) > 460 Then
	Exit Do
EndIf

'Trap 1 ' turn off trap
Loop
Print "Edge time end: ", Time$
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
Function FindHoles()
	
Speed 1
Accel 100, 100
FirstHolePoint = 600 'start hole locations at 600	
Integer i
i = 100
On (laserP1) ' Change to laser profile 1	

Print "Scan time start: ", Time$
Go P(100) +Y(23) +Z(3.5) CP
Trap 2 Sw(holeDetected) Xqt RecordTheta ' Arm Trap	
	For i = 100 To (x - 1)
		Go P(i) +Y(23) +Z(3.5) CP
	Next i
Trap 2 'turn off trap
Print "Scan time end: ", Time$
Print "found holes:", z

Fend
Function RecordTheta

CurrentTheta = CU(CurPos)

Print CurrentTheta - LastTheta

If Abs(CurrentTheta - LastTheta) > 3 Then
	Print "found a hole"
	P(FirstHolePoint + z) = CurPos
	z = z + 1 ' count num of holes found
Else
	DoubleTriggered = DoubleTriggered + 1
EndIf

LastTheta = CurrentTheta

Trap 2 Sw(holeDetected) Xqt RecordTheta 'rearm trap

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
