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
' and the eoat is ... well... yeah
	EOATcorrection = -45 - 10.6885
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

'	Call changeSpeed(slow)

'	PanelFindPickupError


	'precalculate radius to holes, rotation to holes along radius and tangent angle to holes
	' this will allow us to move the holes close to where they need to be
	' the system theta error is accounted for in panelRecipeRotate()
	Print "precalculating...."
	LoadPanelInfo
    PanelRecipeRotate(PanelPickupErrorTheta)
	xy2RadiusRotationTangent

	Call changeSpeed(slow)


Print "current pos:    ", "  --  x:", CX(CurPos), " y:", CY(CurPos), " z:", CZ(CurPos), " u:", CU(CurPos)
	Do While True
		'Pause
			
		'move to location
		For hole = 1 To PanelHoleCount
			'Print "Laser-hole:  ", hole,
			PanelHoleToXYZT(hole, CX(laser), CY(laser), CZ(PreScan), 90 - PanelHoleTangent(hole))
			If hole = 1 Then Print "current pos:    ", "  --  x:", CX(CurPos), " y:", CY(CurPos), " z:", CZ(CurPos), " u:", CU(CurPos)
			'Pause
			'Wait 1
		Next

		Pause
		LoadPanelInfo
		If blah Then
			PanelRecipeRotate(foo)
	    	PanelRecipeTranslate(xd, yd)
	    Else
	    	PanelRecipeTranslate(xd, yd)
			PanelRecipeRotate(foo)
	    EndIf
		xy2RadiusRotationTangent

'		For hole = 1 To PanelHoleCount
'			Print "Heatstake-Hole:  ", hole,
'			PanelHoleToXYZT(hole, CX(hotstake), CY(hotstake), CZ(PreHotStake), -45 - PanelHoleTangent(hole))
'			'Pause
'			Wait 1
'		Next

	Loop
Fend

