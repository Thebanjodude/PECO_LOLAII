#include "Globals.INC"

Function CrowdingSequence() As Integer

Trap 2, MemSw(jobAbortH) = True GoTo exitCrowding ' arm trap

	' Make sure the crowding is open
	Off (CrowdingH)
	TmReset 1
	
	' make sure we start from home
	If Not HomeCheck Then findHome
	
	Go PreHotStake CP
	Do Until Tmr(1) > 0.5
		Wait 0.1
	Loop
	
	' lets see if we can use a global point
	'Jump P(recPreCrowding)
	Jump cwdin_51010
	
	suctionCupsCC = False ' Turn off suction cups
	Wait recSuctionWaitTime ' wait for cups to release

	' lets see if we can use a global point
	'Jump P(recCrowding) +Z(30) ' Relese the suction cups and move them out of the way for crowding
	Jump cwdout_51010 +Z(30) ' Relese the suction cups and move them out of the way for crowding

	' crowding sequence
	On crowdingXH
	Wait 0.5
	On CrowdingH
	Wait 0.5
	Off crowdingXH
	Wait 0.5
	
'	Wait 3
	
	' lets see if we can use a global point
	'Go P(recCrowding)
	Go cwdout_51010
	suctionCupsCC = True ' Turn on cups
	Wait recSuctionWaitTime

	Off (CrowdingH) ' Open crowding
	Wait 0.5 ' wait for the crowding to open
	
	Go XY(CX(PreFlash), CY(PreFlash), CZ(PreFlash), CU(CurPos)) /L
	Go PreFlash
	
	CrowdingSequence = 0
	
exitCrowding:
	
If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
	jobAbort = True
	MemOff (jobAbortH) ' reset membit
	Off (CrowdingH) ' Open crowding	
EndIf

	findHome
	
Trap 2 ' Disarm trap

Fend

