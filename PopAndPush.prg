#include "Globals.INC"

Function DropOffPanel(stupidCompiler1 As Byte) As Integer 'byte me
' You can't return a value unless you pass it one	

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
		DropOffPanel = OutmagIlockOpen
		GoTo exitPushPanel
	EndIf
	
	OutMagDropOffSignal = False

	Jump PreScan LimZ zLimit
	Jump OutmagWaypoint LimZ zLimit
	
	Do Until OutMagDropOffSignal = True And outMagInt = False
		Wait .25 ' wait until the output magazine is ready
	Loop
	
	Jump Outmag LimZ zLimit
	
	Off suctionCupsH ' fake
	suctionCupsCC = False
	Wait suctionWaitTime ' Allow time for cups to unseal
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

	panelDataTxRdy = False 'reset flag
	SystemStatus = MovingPanel
	PanelPassedInspection = False ' rest flag
	DropOffPanel = DropoffSuccessful
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
Function PickupPanel(stupidCompiler As Byte) As Integer 'byte me
' You can't return a value unless you pass it one
	
Trap 2, MemSw(jobAbortH) = True GoTo exitPopPanel ' arm trap

'	PickupPanel = 2 ' default to fail

retry:

	If inMagInterlock = True Then 'Check Interlock status
		PickupPanel = 1
		GoTo exitPopPanel
	EndIf
	
	Jump PreScan LimZ zLimit
	
	Do Until InMagPickUpSignal = True ' Wait for inmag to confirm a panel is ready to be picked up
		Wait .25
	Loop
	
	InMagPickUpSignal = False ' reset trigger
	
	Jump Inmag LimZ zLimit

	suctionCupsCC = True
	Wait suctionWaitTime ' Allow time for cups to seal on panel
	
	SystemStatus = StateMoving
	Jump PreScan LimZ zLimit
	
	InMagRobotClearSignal = True ' Give permission for input magazine to queue up next panel
	PickupPanel = 0
	
exitPopPanel:
If MemSw(jobAbortH) = True Then 'check if the operator wants to abort the job
	jobAbort = True
EndIf

Trap 2 'disarm trap

Fend
