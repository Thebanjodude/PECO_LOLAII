#include "Globals.INC"

' a place to hold test code

Function runTest
	Integer hole
			
	holeTolerance = 0.01
	'stepsize = 0.1
	stepsize = 0.25
	
' the EOAT is 135deg off of zero and the panel recipes are 180deg off
'#define PanelOffsetTheta 315
' sorta, its really panels are placed into the magazine 90deg off counterclockwise
' and the eoat is 45deg off clockwise
' so we need a correction of -45deg
	EOATcorrection = 38
	magazineCorrection = -90
	systemThetaError = EOATcorrection + magazineCorrection

	Call changeSpeed(fast)

	Pause
	
	LoadPanelInfo
	
	ChoosePointsTable()
	PickupPanel
	CrowdingSequence
	
	'clear existing pickup error
	PanelPickupErrorX = 0
	PanelPickupErrorY = 0
	PanelPickupErrorTheta = 0

	Call changeSpeed(slow)

	PanelFindPickupError
	
	Call changeSpeed(slow)

Print "current pos:    ", "  --  x:", CX(CurPos), " y:", CY(CurPos), " z:", CZ(CurPos), " u:", CU(CurPos)
	Do While True
		Pause
			
		'move to location
		For hole = 1 To PanelHoleCount
			'Print "Laser-hole:  ", hole,
			PanelHoleToXYZT(hole, CX(laser), CY(laser), CZ(PreScan), -90 - PanelHoleTangent(hole))
			If hole = 1 Then Print "current pos:    ", "  --  x:", CX(CurPos), " y:", CY(CurPos), " z:", CZ(CurPos), " u:", CU(CurPos)
			'Pause
			'Wait 1
		Next
	
'		For hole = 1 To PanelHoleCount
'			Print "Heatstake-Hole:  ", hole,
'			PanelHoleToXYZT(hole, CX(hotstake), CY(hotstake), CZ(PreHotStake), -45 - PanelHoleTangent(hole))
'			'Pause
'			Wait 1
'		Next

	Loop
Fend

