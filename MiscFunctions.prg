#include "Globals.INC"


Function InTomm(inches As Real) As Real
	InTomm = inches * 25.4
Fend
Function mmToin(mm As Real) As Real
	mmToin = mm * 0.0393701
Fend
Function ChoosePointsTable()
	' Choose which points table to load

	If recPointsTable = 1 Then
		LoadPoints "points.pts"
	ElseIf recPointsTable = 2 Then
		LoadPoints "points2.pts"
	ElseIf recPointsTable = 3 Then
		LoadPoints "points3.pts"
	Else
		erUnknown = True
		Print "point Table is Unknown"
	EndIf
Fend
Function SavePointsTable()
	' Choose which points table to save

	If recPointsTable = 1 Then
		SavePoints "points.pts"
	ElseIf recPointsTable = 2 Then
		SavePoints "points2.pts"
	ElseIf recPointsTable = 3 Then
		SavePoints "points3.pts"
	Else
		erUnknown = True
		Print "point Table is Unknown"
	EndIf
Fend
Function HomeCheck() As Boolean
	
	Real distx, disty, distz, distance
' TODO: Parameterize these #defines?
	#define startUpDistMax 150 '+/-150mm from home position
	
	distx = Abs(CX(CurPos) - CX(PreScan))
	disty = Abs(CY(CurPos) - CY(PreScan))
	
	distance = Sqr(distx ** 2 + disty ** 2)
	
'	Print "distance away from home: ", distance

	If distance > startUpDistMax Or Hand(Here) = 1 Then  'Check is the position is close to home. If not throw error
		erRobotNotAtHome = True
		HomeCheck = False
'		Print "Distance NOT OK Or Arm Orientation NOT OK"
	Else
		erRobotNotAtHome = False
		HomeCheck = True
'		Print "Distance OK and Arm Orientation OK"
	EndIf
		
Fend
Function findHome
	' return to the home position (PreScan)

	Real posX, posY, posZ
	Integer quad
	
	posX = CX(Here)
	posY = CY(Here)
	
	' make sure we are NOT at home (in XY, homecheck doesn't check Z or U)
	If HomeCheck Then Exit Function

	'find out which quadrant we are in and move to the nearest way point
	quad = 0
	If posX >= 0 Then quad = quad Or 1
	If posY >= 0 Then quad = quad Or 2
	' quad == int(binary)
	'         y-
	'          |   flash removal
	'     1(01)| 0(00)
	' x+ ------|------ x-
	'     3(11)| 2(10)
	'          |   heat stake
	'         y+
	
	Select quad
		Case 0
			posZ = CZ(PreFlash)
            Go XY(posX, posY, posZ, CU(Here)) /L
			Go PreFlash CP
			Go PreHotStake CP
			Go PreScan
		Case 1
			posZ = CZ(OutmagWaypoint)
            Go XY(posX, posY, posZ, CU(Here)) /L
			Go OutmagWaypoint CP
			Go PreScan
		Case 2
			posZ = CZ(PreHotStake)
            Go XY(posX, posY, posZ, CU(Here)) /L
			Go PreHotStake CP
			Go PreScan
		Case 3
			posZ = CZ(PreScan)
            Go XY(posX, posY, posZ, CU(Here)) /L
			Go PreScan
	Send
	
	HomeCheck  'clears errors from not being at home
Fend
Function changeSpeed(gotoSpeed As Integer)
	Select gotoSpeed
		Case slow
			Accel 20, 20
			AccelS 20, 20
			Speed 10
			SpeedS 10
		Case fast
			Accel 50, 50
			AccelS 50, 50
			Speed 100
			SpeedS 100
		Default
			Print "error selecting speed, defaulting to slow"
			Call changeSpeed(slow)
	Send
Fend

