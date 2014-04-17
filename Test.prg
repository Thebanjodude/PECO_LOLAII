#include "Globals.INC"

' a place to hold test code

' test the pickup error from the crowding sequence
Function testCrowding
	Integer count, hole
	Real errorX, errorY
	
	count = 0
	holeTolerance = 0.01
	stepsize = 0.25
	
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
		Call CrowdingSequence
	Loop
Fend

