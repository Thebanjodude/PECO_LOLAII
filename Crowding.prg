#include "Globals.INC"

Function CrowdingSequence() As Integer

Trap 2, MemSw(jobAbortH) = True GoTo exitCrowding ' arm trap

	Jump Prescan LimZ zLimit
	Jump PreHotStake LimZ zLimit
	
	Off (CrowdingH) ' Make sure the crowding is open
	Wait 3
	Jump P(recPreCrowding) LimZ zLimit 'Jump to the crowding location
	suctionCupsCC = False ' Turn off suction cups
	Wait recSuctionWaitTime ' wait for cups to release
	Jump P(recCrowding) +Z(30) ' Relese the suction cups and move them out of the way for crowding
	Wait .25
	On (CrowdingH) ' Close crowding
	
	' wait for verification that the crowding has closed
'	Do Until pasCrowding = True
'		Wait .25
'	Loop
	
	Wait 3 ' wait for the crowd to take place
	
	Go P(recCrowding)
	suctionCupsCC = True ' Turn on cups
	Wait recSuctionWaitTime

	Off (CrowdingH) ' Open crowding
	' wait for verification that the crowding has opened
' this do loop got stuck during testing, skip over for now	

'	Do Until pasCrowding = False
'		Wait .25
'	Loop
	Wait 3 ' wait for the crowd to open	
	
	CrowdingSequence = 0
	
exitCrowding:
	
If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
	jobAbort = True
	MemOff (jobAbortH) ' reset membit
	Off (CrowdingH) ' Open crowding	
EndIf

	Jump PreHotStake LimZ zLimit ' move away from a panel
	Jump PreScan LimZ zLimit ' Go Home

Trap 2 ' Disarm trap

Fend

