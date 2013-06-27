#include "Globals.INC"

Function DropOffPanel(stupidCompiler1 As Byte) As Integer 'byte me
' You can't return a value unless you pass it one	

Trap 2, MemSw(jobAbortH) = True GoTo exitPushPanel ' arm trap

'	DropOffPanel = 2 ' dafult to fail
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
		Exit Function
	EndIf
	
	Jump PreScan LimZ zLimit
	Jump OutmagWaypoint LimZ zLimit
	
	Do Until OutMagDropOffSignal = True
		Wait .25 ' wait until the output magazine is ready
	Loop
	
	Jump Outmag2 LimZ zLimit
	
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
		Exit Function
	EndIf
	
	Jump PreScan LimZ zLimit
	
	Do Until InMagPickUpSignal = True ' Wait for inmag to confirm a panel is ready to be picked up
		Wait .25
	Loop
	
	InMagPickUpSignal = False ' reset trigger
	
	Jump Inmag2 +Z(5) LimZ zLimit
	
	PTCLR
	Do While ZmaxTorque < .3
		JTran 3, -.5
	Loop
	
	Print "torqe met"

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
Function JointTorqueMonitor()
	
	Real Tpklow, Tpkhigh, TAvglow, TAvgHigh
	
'	Tpklow = 100
'	Tpkhigh = 0
'	TAvglow = 100
'	TAvgHigh = 0
	

	' This test is to determine if we can sense when the robot picks up a panel
		
	ATCLR
    PTCLR
        
Do While True
	
	ZmaxTorque = PTRQ(3)
'	Print "ZmaxTorque", ZmaxTorque
	
	ATCLR
	PTCLR
	
'		Print " The Average torque on the Z axis is ", ATRQ(3) 'ditto
'		Print " The Peak torque on the Z axis is ", PTRQ(3) 'ditto
'		
'		If Tpklow > PTRQ(3) Then
'			Tpklow = PTRQ(3)
'		EndIf
'		
'		If Tpkhigh < PTRQ(3) Then
'			Tpkhigh = PTRQ(3)
'		EndIf
'		
'		If TAvglow > ATRQ(3) Then
'			TAvglow = ATRQ(3)
'		EndIf
'		
'		If TAvgHigh < ATRQ(3) Then
'			TAvgHigh = ATRQ(3)
'		EndIf

'	Print " Tpklow is: ", Tpklow
'	Print " Tpkhigh is: ", Tpkhigh
'	Print " Tavglow is: ", TAvglow
'	Print " Tavghigh is: ", TAvgHigh

Loop
	
Fend

