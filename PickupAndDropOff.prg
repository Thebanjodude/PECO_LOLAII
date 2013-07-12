#include "Globals.INC"

Function DropOffPanel(stupidCompiler1 As Byte) As Integer 'byte me
' You can't return a value unless you pass it one	

'Trap 2, MemSw(jobAbortH) = True GoTo exitPushPanel ' arm trap

	DropOffPanel = 2 ' dafult to fail
	SystemStatus = StatePushPanel
	PanelPassedInspection = True ' fake it for testing	

	panelDataTxRdy = True ' Tell HMI to readout hole data
	
' this is for hmi logging
'	Wait MemSw(panelDataTxAckH) = True, 3
'	Redim InspectionArray(0, 0) ' clear all the values in the Inspection Array
'	panelDataTxRdy = false ' reset flag	
'	If TW = True Then ' catch that the HMI timed out without acking
'		DropOffPanel = False
'		erHmiDataAck = True
'		Print "no data ack from hmi"
'		GoTo exitPushPanel
'	EndIf
	
	If outMagInt = True Then ' Check interlock status
		DropOffPanel = 1 ' Interlock is open		
		Exit Function
	EndIf
	
	Jump PreScan LimZ zLimit
	Jump OutmagWaypoint LimZ zLimit
	
	Do Until OutMagDropOffSignal = True
		Wait .25 ' wait until the output magazine is ready
	Loop
	
	Jump P(recOutmag) LimZ zLimit
	
	Off suctionCupsH ' fake
	suctionCupsCC = False
	Wait suctionWaitTime ' Allow time for cups to unseal
	RobotPlacedPanel = True ' Tell the output magazine we put a panel into it
	Jump OutmagWaypoint LimZ zLimit

	OutputMagSignal = True ' Give permission for output magazine to dequeue next panel	
	
	PanelPassedInspection = True 'fake
	
	If PanelPassedInspection = False Then
		erPanelFailedInspection = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause ' wait for operator to continue
		stackLightRedCC = False ' turn off only after ack
		stackLightAlrmCC = False
	EndIf

	SystemStatus = StateMoving
	PanelPassedInspection = False ' rest flag
	DropOffPanel = DropoffSuccessful

	jobNumPanelsDone = jobNumPanelsDone + 1 ' Increment how many panels we have pulled		
	If jobNumPanelsDone = jobNumPanels Then
		jobDone = True ' We have finished the run, don't execute the main loop
	EndIf

'exitPushPanel:
	erPanelFailedInspection = False
	erHmiDataAck = False
	
If MemSw(jobAbortH) = True Then 'Check if the operator wants to abort the job
	MemOff (jobAbortH) ' reset flag	
EndIf

Trap 2 ' disarm trap	

Fend
Function PickupPanel(stupidCompiler As Byte) As Integer 'byte me
' You can't return a value unless you pass it one...
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPopPanel ' arm trap

	PickupPanel = 2 ' Default to fail

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
	
	Do While ZmaxTorque <= .3 ' Approach the panel slowly until we hit a torque limit
		JTran 3, -.5 ' Move only the z-axis downward in .5mm increments
	Loop

	suctionCupsCC = True ' Turn on the cups because we have engaged a panel
	Wait suctionWaitTime ' Allow time for cups to seal on panel	
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
Function JointTorqueMonitor()

' This is a function that runs as a background task. 
	
	ATCLR ' Clear the buffers
    PTCLR
        
Do While True
	ZmaxTorque = PTRQ(3) ' Get the z axis peak torque	
	PTCLR ' Clear the buffers	
Loop
	
Fend

