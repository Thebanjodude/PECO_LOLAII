#include "Globals.INC"

Function CrowdingSequence() As Integer

	' Make sure the crowding is open
	crowdingCC = False
	TmReset 1
	
	' make sure we start from home
	If Not HomeCheck Then findHome
	
	Go PreHotStake CP
	Do Until Tmr(1) > 0.5
		Wait 0.1
	Loop
	
	Jump CwdIN
	
	suctionCupsCC = False ' Turn off suction cups
	Wait recSuctionWaitTime ' wait for cups to release

	Jump CwdOUT +Z(30)

	' crowding sequence
'	crowdingXCC = True
'	Wait 0.5
	crowdingCC = True
	Wait 0.5
'	crowdingXCC = False
'	Wait 0.5
	
'	Go CwdOut
	PTCLR (3)
	ZmaxTorque = 0
	Do While ZmaxTorque <= .3 'Or TorqueCounter > 25 ' Approach the panel slowly until we hit a torque limit
		JTran 3, -.5 ' Move only the z-axis downward in .5mm increments
		ZmaxTorque = PTRQ(3)
	Loop

	suctionCupsCC = True ' Turn on cups
	Wait recSuctionWaitTime

	crowdingCC = False
'	Wait 0.5 ' wait for the crowding to open
	Wait 1
	
	Call changeSpeed(slow)
	Go XY(CX(CurPos), CY(CurPos), -10, CU(CurPos)) /L
	Go XY(CX(PreFlash), CY(PreFlash), CZ(CurPos), CU(CurPos)) /L
	Go XY(CX(PreHotStake), CY(PreHotStake), CZ(CurPos), CU(CurPos)) /L
	Go PreHotStake
	Call changeSpeed(fast)
	
	CrowdingSequence = 0
	
	findHome
	
Trap 2 ' Disarm trap

Fend

