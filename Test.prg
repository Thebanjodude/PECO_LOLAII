#include "Globals.INC"

' a place to hold test code

Function runTest
	Integer hole
			
	holeTolerance = 0.01
	stepsize = 0.01
	'stepsize = 0.25
	
' the EOAT is XXXdeg off of zero and the panel recipes are YYYdeg off
' sorta, its really panels are placed into the magazine 90deg off counterclockwise
' and the eoat is ... well... yeah
'	EOATcorrection = -45 ' - 11.585
'	magazineCorrection = -90
'	systemThetaError = EOATcorrection + magazineCorrection

	Call changeSpeed(fast)

	Pause
	
	'LoadPanelInfo
	
	ChoosePointsTable()
	PickupPanel
	CrowdingSequence
	
	'clear existing pickup error
	PanelPickupErrorX = 0
	PanelPickupErrorY = 0
	PanelPickupErrorTheta = 0


	PanelFindPickupError

'<TESTING>
'	'precalculate radius to holes, rotation to holes along radius and tangent angle to holes
'	' this will allow us to move the holes close to where they need to be
'	' the system theta error is accounted for in panelRecipeRotate()
'	Print "precalculating...."
'	LoadPanelInfo
'	PanelRecipeRotate(PanelPickupErrorTheta)
'	xy2RadiusRotationTangent
'
'	Do While True
'		Call changeSpeed(slow)
'		PanelHoleToXYZT(1, CX(laser), CY(laser), CZ(PreScan), 90 - PanelHoleTangent(1))
'		Wait 3
'		Print GetLaserMeasurement("07")
'		CrowdingSequence
'	Loop

'</TESTING>

	Call changeSpeed(slow)

	
	'Print "current pos:    ", "  --  x:", CX(CurPos), " y:", CY(CurPos), " z:", CZ(CurPos), " u:", CU(CurPos)
	
	Integer count
	count = 0
	Do While True
		Pause
			
		'move to location
		For hole = 1 To PanelHoleCount
			'Print "Laser-hole:  ", hole,
			PanelHoleToXYZT(hole, CX(laser), CY(laser), CZ(PreScan), 90 - PanelHoleTangent(hole))
			If hole = 1 Then Print "current pos:    ", "  --  x:", CX(CurPos), " y:", CY(CurPos), " z:", CZ(CurPos), " u:", CU(CurPos)
			'Pause
			'Wait 1
		Next
		
		count = count + 1
		If count > 3 Then Go PreScan

'<TESTING>
'		Pause
'		LoadPanelInfo
'		If blah Then
'			PanelRecipeRotate(foo)
'	    	PanelRecipeTranslate(xd, yd)
'	    Else
'	    	PanelRecipeTranslate(xd, yd)
'			PanelRecipeRotate(foo)
'	    EndIf
'		xy2RadiusRotationTangent
'</TESTING>

'		For hole = 1 To PanelHoleCount
'			Print "Heatstake-Hole:  ", hole,
'			PanelHoleToXYZT(hole, CX(hotstake), CY(hotstake), CZ(PreHotStake), -45 - PanelHoleTangent(hole))
'			'Pause
'			Wait 1
'		Next

	Loop
Fend


' test the pickup error from the crowding sequence
Function testCrowding
	Integer count, hole
	Real errorX, errorY
	
	count = 0
	holeTolerance = 0.01
	stepsize = 0.25
	
	ChoosePointsTable()
	PickupPanel
	ChangeProfile("00")
	
	Call CrowdingSequence
	
	Do While True
		count = count + 1

		For hole = 1 To PanelHoleCount
			PanelHoleToXYZT(hole, CX(Laser), CY(Laser), CZ(PreScan), 90 - PanelHoleTangent(hole))
		
			errorX = PanelFindXerror
			errorY = PanelFindYerror
			
			Print "Pass-", count, " Error X:Y = ", errorX, ":", errorY
		Next
		
		Call findHome
		Call CrowdingSequence_forTest
	Loop
Fend

