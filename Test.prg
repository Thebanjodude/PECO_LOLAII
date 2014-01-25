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
' mock for loading recipe values
Function loadRecipe
		
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

