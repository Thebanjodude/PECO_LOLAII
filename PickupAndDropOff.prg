#include "Globals.INC"

Function DropOffPanel() As Integer

	Integer count
	
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


	If startLearning = False Then
		' Only log data if we are not learning a new panel... this logging functionality
		'  should be moved to a different function
		
		' --TODO-- Add panel fail code here
		
		panelDataTxRdy = True ' Tell HMI to readout hole data
	
		count = 0
		Do While panelDataTxACK = False
			count = count + 1
			If count > 10 Then
				erHmiDataAck = True
				Print "no data ack from hmi"
				Pause
				Exit Do
			EndIf
			Wait 1
		Loop
	
		panelDataTxRdy = False ' reset flag	
	EndIf
	
	changeSpeed(slow)
	
	Jump MagOUT
	If JS = True Then
		Pause ' we hit somthing so pause
	EndIf

	changeSpeed(fast)

	suctionCupsCC = False
	Wait recSuctionWaitTime ' Allow time for cups to unseal
	RobotPlacedPanel = True ' Tell the output magazine we put a panel into it

	findHome

	OutputMagSignal = True ' Give permission for output magazine to dequeue next panel	

	SystemStatus = StateMoving
	DropOffPanel = DropoffSuccessful

	jobNumPanelsDone = jobNumPanelsDone + 1 ' Increment how many panels we have pulled		
	If jobNumPanelsDone >= jobNumPanels Then
		jobDone = True ' We have finished the run, don't execute the main loop
	EndIf

	erPanelFailedInspection = False
	erHmiDataAck = False

	findHome

Fend



Function PickupPanel() As Integer 'byte me
	
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
		
	'Jump MagIN +Z(10) LimZ zLimit Sense Sw(inMagInterlockH)
	Jump MagIN +Z(10) Sense Sw(inMagInterlockH)
	
	If JS = True Then ' Its possible to open an interock during the jump so check if it was opened
		PickupPanel = 1 ' Interlock is open
		Jump PreScan 'LimZ zLimit ' Go home
		Exit Function
	EndIf

	PTCLR (3)
	ZmaxTorque = 0
	Do While ZmaxTorque <= .3 'Or TorqueCounter > 25 ' Approach the panel slowly until we hit a torque limit
		JTran 3, -.5 ' Move only the z-axis downward in .5mm increments
		ZmaxTorque = PTRQ(3)
	Loop
	
	suctionCupsCC = True ' Turn on the cups because we have engaged a panel
	Wait recSuctionWaitTime ' Allow time for cups to seal on panel	
	Jump PreScan 'LimZ zLimit ' Go home		
	
	PickupPanel = 0 ' We successfully picked up a panel

	InMagRobotClearSignal = True ' Give permission for input magazine to queue up next panel
	SystemStatus = StateMoving

Fend

