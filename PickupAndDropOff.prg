#include "Globals.INC"

Function DropOffPanel() As Integer

	DropOffPanel = 2 ' default to fail
	SystemStatus = StatePushPanel
	PanelPassedInspection = True ' fake it for testing	
	
	If outMagInt = True Then ' Check interlock status
		DropOffPanel = 1 ' Interlock is open		
		Exit Function
	EndIf
	
	If Not HomeCheck Then findHome
	Jump OutmagWaypoint 'LimZ zLimit
	
	Do Until OutMagDropOffSignal = True
		Wait .25 ' wait until the output magazine is ready
		' --TODO-- add signal to operator that something is wrong
	Loop


	' --TODO-- Add panel fail code here
	
	panelDataTxRdy = True ' Tell HMI to readout hole data
	Wait MemSw(panelDataTxAckH) = True, 10
	panelDataTxRdy = False ' reset flag	
	If TW = True Then ' catch that the HMI timed out without acking
		erHmiDataAck = True
		Print "no data ack from hmi"
		'Pause
	EndIf
	
	Xqt OutputMagTorqueSense, NoPause ' during this jump check if we hit anything

	changeSpeed(slow)
	
	' see if we can use a global point
	'Jump P(recOutmag) LimZ zLimit ' Sense MemSw(outmagOvrTorq) = True
	Jump MagOUT_51010 'LimZ zLimit ' Sense MemSw(outmagOvrTorq) = True
		If JS = True Then
			Pause ' we hit somthing so pause
		EndIf
	MemOff (outmagOvrTorq) ' reset bit
	Quit OutputMagTorqueSense

	changeSpeed(fast)

'	Off suctionCupsH ' fake
	suctionCupsCC = False
	Wait recSuctionWaitTime ' Allow time for cups to unseal
	RobotPlacedPanel = True ' Tell the output magazine we put a panel into it

	findHome
	'Jump OutmagWaypoint LimZ zLimit

	OutputMagSignal = True ' Give permission for output magazine to dequeue next panel	

	SystemStatus = StateMoving
	DropOffPanel = DropoffSuccessful

	jobNumPanelsDone = jobNumPanelsDone + 1 ' Increment how many panels we have pulled		
	If jobNumPanelsDone >= jobNumPanels Then
		jobDone = True ' We have finished the run, don't execute the main loop
	EndIf

	erPanelFailedInspection = False
	erHmiDataAck = False
	
	If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
		jobAbort = True ' set flag
		MemOff (jobAbortH) ' reset flag		
	EndIf

	findHome

Fend



Function PickupPanel() As Integer 'byte me
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPopPanel ' arm trap

	Integer TorqueCounter
	PickupPanel = 2 ' Default to fail	
	TorqueCounter = 0 ' reset counter

	If inMagInterlock = True Then 'Check Interlock status
		PickupPanel = 1 ' Interlock is open
		Exit Function
	EndIf
	
	suctionCupsCC = False ' Before we pick up a panel make sure we dont have a panel already
	If Not HomeCheck Then
		findHome ' Go home
	EndIf
	
	' Make this non blocking by checking for var then exit function with pickuppanel=1, revisit l8r
	Do Until InMagPickUpSignal = True ' Wait for inmag to confirm a panel is ready to be picked up
		Wait .25
	Loop
	
	InMagRobotClearSignal = False ' the robot is about to visit the magazine.
		
	' see if we can use a global point to pickup panels
	'Jump P(recInmag) +Z(5) LimZ zLimit Sense Sw(inMagInterlockH)
	'Jump magin_51010 +Z(5) LimZ zLimit Sense Sw(inMagInterlockH)
	Jump magin_51010 +Z(5) Sense Sw(inMagInterlockH)
	
	If JS = True Then ' Its possible to open an interock during the jump so check if it was opened
		PickupPanel = 1 ' Interlock is open
		Jump PreScan 'LimZ zLimit ' Go home
		Exit Function
	EndIf

	PTCLR (3)
	ZmaxTorque = 0
	Do While ZmaxTorque <= .3 'Or TorqueCounter > 25 ' Approach the panel slowly until we hit a torque limit
		JTran 3, -.5 ' Move only the z-axis downward in .5mm increments
'		TorqueCounter = TorqueCounter + 1
		ZmaxTorque = PTRQ(3)
	Loop
	
'	If TorqueCounter > 25 Then
'		PickupPanel = 2 ' Failed to pick up panel
'		Exit Function
'	EndIf
	
	suctionCupsCC = True ' Turn on the cups because we have engaged a panel
	Wait recSuctionWaitTime ' Allow time for cups to seal on panel	
	Jump PreScan 'LimZ zLimit ' Go home		
	
	PickupPanel = 0 ' We successfully picked up a panel

exitPopPanel:
If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
	jobAbort = True
	MemOff (jobAbortH)
EndIf
	InMagRobotClearSignal = True ' Give permission for input magazine to queue up next panel
	SystemStatus = StateMoving

Trap 2 'disarm trap

Fend



Function OutputMagTorqueSense
	
	PTCLR ' clear
		
	Do While True
		'Print "Outmag Placement Torque: ", PTRQ(3)
		If PTRQ(3) > 0.3 Then
			'MemOn (outmagOvrTorq)
			'erOutMagCrowding = True
		EndIf
	Loop
Fend

