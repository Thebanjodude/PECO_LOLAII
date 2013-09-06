#include "Globals.INC"

Function DropOffPanel(stupidCompiler1 As Byte) As Integer
' You can't return a value unless you pass it one	

	DropOffPanel = 2 ' dafult to fail
	SystemStatus = StatePushPanel
	PanelPassedInspection = True ' fake it for testing	
	
	If outMagInt = True Then ' Check interlock status
		DropOffPanel = 1 ' Interlock is open		
		Exit Function
	EndIf
	
	Jump PreScan LimZ zLimit
	Jump OutmagWaypoint LimZ zLimit
	
	Do Until OutMagDropOffSignal = True
		Wait .25 ' wait until the output magazine is ready
	Loop

	panelDataTxRdy = True ' Tell HMI to readout hole data
	
' this is for hmi logging
	Wait MemSw(panelDataTxAckH) = True, 10
	panelDataTxRdy = False ' reset flag	
	If TW = True Then ' catch that the HMI timed out without acking
		erHmiDataAck = True
		Print "no data ack from hmi"
		Pause
	EndIf
	
	Xqt OutputMagTorqueSense, NoPause
	Jump P(recOutmag) LimZ zLimit Sense MemSw(outmagOvrTorq) = True
	Quit OutputMagTorqueSense
	
	If JS = True Then
		Pause
	EndIf
	
	Off suctionCupsH ' fake
	suctionCupsCC = False
	Wait recSuctionWaitTime ' Allow time for cups to unseal
	RobotPlacedPanel = True ' Tell the output magazine we put a panel into it
	Redim InspectionArray(0, 0) ' clear all the values in the Inspection Array
	Jump OutmagWaypoint LimZ zLimit

	OutputMagSignal = True ' Give permission for output magazine to dequeue next panel	
	
	PanelPassedInspection = True 'fake
	
'	If PanelPassedInspection = False Then
'		erPanelFailedInspection = True
'		Pause ' wait for operator to continue
'	EndIf

	SystemStatus = StateMoving
	PanelPassedInspection = False ' rest flag
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

Fend
Function PickupPanel(stupidCompiler As Byte) As Integer 'byte me
' You can't return a value unless you pass it one...
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPopPanel ' arm trap

	Integer TorqueCounter
	PickupPanel = 2 ' Default to fail	
	TorqueCounter = 0 ' reset counter

	If inMagInterlock = True Then 'Check Interlock status
		PickupPanel = 1 ' Interlock is open
		Exit Function
	EndIf
	
	Jump PreScan LimZ zLimit ' Go home
	
	' Make this non blocking by checking for var then exit function with pickuppanel=1, revisit
	Do Until InMagPickUpSignal = True ' Wait for inmag to confirm a panel is ready to be picked up
		Wait .25
	Loop
	
	InMagRobotClearSignal = False ' the robot is about to visit the magazine.
	Jump P(recInmag) +Z(5) LimZ zLimit Sense Sw(inMagInterlockH)
	
	If JS = True Then ' Its possible to open an interock during the jump so check if it was opened
		PickupPanel = 1 ' Interlock is open
		Jump PreScan LimZ zLimit ' Go home
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
	Jump PreScan LimZ zLimit ' Go home		
	
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


