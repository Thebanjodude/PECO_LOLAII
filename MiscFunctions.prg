#include "Globals.INC"


Function InTomm(inches As Real) As Real
	InTomm = inches * 25.4
Fend


Function mmToin(mm As Real) As Real
	mmToin = mm * 0.0393701
Fend


Function HomeCheck() As Boolean
	
	Real distx, disty, distz, distance
' TODO: Parameterize these #defines?
'	#define startUpDistMax 150 '+/-150mm from home position
	#define startUpDistMax 5 '+/-5mm from home position
	
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


Function sendInsertPresent(holeNum As Integer)
	Select holeNum
		Case 0
			'reset all insertPresent vars
			insertPresent01 = False;
			insertPresent02 = False;
			insertPresent03 = False;
			insertPresent04 = False;
			insertPresent05 = False;
			insertPresent06 = False;
			insertPresent07 = False;
			insertPresent08 = False;
			insertPresent09 = False;
			insertPresent10 = False;
			insertPresent11 = False;
			insertPresent12 = False;
			insertPresent13 = False;
			insertPresent14 = False;
			insertPresent15 = False;
			insertPresent16 = False;
			insertPresent17 = False;
			insertPresent18 = False;
			insertPresent19 = False;
			insertPresent20 = False;
			insertPresent21 = False;
			insertPresent22 = False;
			insertPresent23 = False;
		Case 1
			insertPresent01 = True;
		Case 2
			insertPresent02 = True;
		Case 03
			insertPresent03 = True;
		Case 04
			insertPresent04 = True;
		Case 05
			insertPresent05 = True;
		Case 06
			insertPresent06 = True;
		Case 07
			insertPresent07 = True;
		Case 08
			insertPresent08 = True;
		Case 09
			insertPresent09 = True;
		Case 10
			insertPresent10 = True;
		Case 11
			insertPresent11 = True;
		Case 12
			insertPresent12 = True;
		Case 13
			insertPresent13 = True;
		Case 14
			insertPresent14 = True;
		Case 15
			insertPresent15 = True;
		Case 16
			insertPresent16 = True;
		Case 17
			insertPresent17 = True;
		Case 18
			insertPresent18 = True;
		Case 19
			insertPresent19 = True;
		Case 20
			insertPresent20 = True;
		Case 21
			insertPresent21 = True;
		Case 22
			insertPresent22 = True;
		Case 23
			insertPresent23 = True;
		Default
			' do nothing
	Send
Fend

