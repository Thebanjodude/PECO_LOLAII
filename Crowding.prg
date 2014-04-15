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
	
	' lets see if we can use a global point
	'Jump P(recPreCrowding)
'TODO -- FIX THIS
'	Jump cwdin_51010
	Jump P(15)
	
	suctionCupsCC = False ' Turn off suction cups
	Wait recSuctionWaitTime ' wait for cups to release

	' lets see if we can use a global point
	'Jump P(recCrowding) +Z(30) ' Relese the suction cups and move them out of the way for crowding
'TODO -- FIX THIS
'	Jump cwdout_51010 +Z(30) ' Relese the suction cups and move them out of the way for crowding
	Jump P(16) +Z(30)

	' crowding sequence
	crowdingXCC = True
	Wait 0.5
	crowdingCC = True
	Wait 0.5
	crowdingXCC = False
	Wait 0.5
	
	' lets see if we can use a global point
	'Go P(recCrowding)
'TODO -- FIX THIS
'	Go cwdout_51010
	Go P(16)

	suctionCupsCC = True ' Turn on cups
	Wait recSuctionWaitTime

	crowdingCC = False
	Wait 0.5 ' wait for the crowding to open
	
	Call changeSpeed(slow)
'	Go XY(CX(PreFlash), CY(PreFlash), CZ(PreFlash), CU(CurPos)) /L
	Go XY(CX(CurPos), CY(CurPos), -10, CU(CurPos)) /L
	Go XY(CX(PreFlash), CY(PreFlash), CZ(CurPos), CU(CurPos)) /L
	Go XY(CX(PreHotStake), CY(PreHotStake), CZ(CurPos), CU(CurPos)) /L
	Go PreHotStake
	Call changeSpeed(fast)
	
	CrowdingSequence = 0
	
	findHome
	
Trap 2 ' Disarm trap

Fend



'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'***********************  DONT LEAVE THIS FUNCTION HERE **************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************
'*********************************************************************


Function CrowdingSequence_forTest() As Integer

	' Make sure the crowding is open
	crowdingCC = False
	TmReset 1
	
	' make sure we start from home
	If Not HomeCheck Then findHome
	
	Go PreHotStake CP
	Do Until Tmr(1) > 0.5
		Wait 0.1
	Loop
	
	' lets see if we can use a global point
	'Jump P(recPreCrowding)
	Jump P(16) -X(10) -Y(10)
	
	suctionCupsCC = False ' Turn off suction cups
	Wait recSuctionWaitTime ' wait for cups to release

	Jump P(16) +Z(30)

	' crowding sequence
	crowdingXCC = True
	Wait 0.5
	crowdingCC = True
	Wait 0.5
	crowdingXCC = False
	Wait 0.5
	
	Go P(16)

	suctionCupsCC = True ' Turn on cups
	Wait recSuctionWaitTime

	crowdingCC = False
	Wait 0.5 ' wait for the crowding to open
	
	Call changeSpeed(slow)
	Go XY(CX(CurPos), CY(CurPos), -10, CU(CurPos)) /L
	Go XY(CX(PreFlash), CY(PreFlash), CZ(CurPos), CU(CurPos)) /L
	Go XY(CX(PreHotStake), CY(PreHotStake), CZ(CurPos), CU(CurPos)) /L
	Go PreHotStake
	Call changeSpeed(fast)
	
	CrowdingSequence_forTest = 0
	
	findHome
	
Trap 2 ' Disarm trap

Fend

