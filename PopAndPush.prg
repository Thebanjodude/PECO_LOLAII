#include "Globals.INC"

Function DropOffPanel() As Boolean
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPushPanel ' arm trap

	DropOffPanel = False ' dafult to fail
	SystemStatus = DepositingPanel
	PanelPassedInspection = True ' fake it for testing	

	panelDataTxRdy = True ' Tell HMI to readout hole data
	MemOn (panelDataTxAckH) ' fake
	
' this is for hmi logging
'	Wait MemSw(panelDataTxAckH) = True, 3
'	
'	If TW = True Then ' catch that the HMI timed out without acking
'		DropOffPanel = False
'		erHmiDataAck = True
'		Print "no data ack from hmi"
'		GoTo exitPushPanel
'	EndIf
	
	If outMagInt = True Then ' Check interlock status
		DropOffPanel = False
		GoTo exitPushPanel
	EndIf
		
'	WaitSig OutMagDropOffSignal		

	Jump PreScan LimZ zLimit
	Jump OutmagWaypoint LimZ zLimit
	Jump Outmag LimZ zLimit
	
	Off suctionCupsH ' fake
	suctionCupsCC = False
	Wait suctionWaitTime ' Allow time for cups to unseal
	Jump OutmagWaypoint LimZ zLimit

'	Signal OutputMagSignal ' Give permission for output magazine to dequeue next panel	
	
	PanelPassedInspection = True 'fake
	
	If PanelPassedInspection = False Then
		erPanelFailedInspection = True
		stackLightRedCC = True
		stackLightAlrmCC = True
		Pause ' wait for operator to continue
		stackLightRedCC = False ' turn off only after ack
		stackLightAlrmCC = False
	EndIf

	panelDataTxRdy = False 'reset flag
	SystemStatus = MovingPanel
	PanelPassedInspection = False ' rest flag
	DropOffPanel = True 'fake??
'	Signal OutMagRobotClearSignal ' Tell outmag the robot it out of the way, ok to move

	jobNumPanelsDone = jobNumPanelsDone + 1 ' Increment how many panels we have pulled		
	If jobNumPanelsDone = jobNumPanels Then
		jobDone = True ' We have finished the run, don't execute the main loop
	EndIf

exitPushPanel:
	erPanelFailedInspection = False
	erHmiDataAck = False

Trap 2 ' disarm trap	

Fend
Function PickupPanel() As Boolean
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPopPanel ' arm trap

	PickupPanel = False ' default to fail

retry:

	If inMagInterlock = True Then 'Check Interlock status
		PickupPanel = False
		GoTo exitPopPanel
	EndIf
	
	Jump PreScan LimZ -12.5
	
'	WaitSig InMagPickUpSignal ' Wait for inmag to confirm a panel is ready to be picked up
	Jump Inmag LimZ -12.5 LimZ zLimit

	suctionCupsCC = True
	On (suctionCupsH) ' fake
	Wait suctionWaitTime ' Allow time for cups to seal on panel
	
	PickupPanel = True
'	SystemStatus = StateMoving
	Jump PreScan LimZ -12.5
	
'	Signal InMagRobotClearSignal ' Give permission for input magazine to queue up next panel
	
exitPopPanel:
If MemSw(jobAbortH) = True Then 'check if the operator wants to abort the job
	jobAbort = True
	PickupPanel = False
EndIf

Trap 2 'disarm trap

Fend
