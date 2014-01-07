#include "Globals.INC"

Function idleState(currentState As Integer) As Integer
	' This state waits for the operator to start a job.
	' Also, if any of the other states encounters a major error, it returns
	' to the idle state and waits for an operator.

	If jobStart = True Then
		' the And contstruct doesn't short circuit when the first boolean fails...
		'   which means lots and lots of failure messages until the HMI pushes recipies values.
		'   So, lets check for the initial parameters after we start our first job.
		If CheckInitialParameters = 0 Then
			currentState = StatePopPanel
			ChoosePointsTable() 			' Change to the correct points table for the selected panel
			jobAbort = False 				' reset flag
			jobNumPanelsDone = 0 			' reset panel counter
			panelDataTxRdy = False 			' make sure var is set to false so it changes when we want HMI to read out data
		EndIf
	EndIf
	idleState = currentState				' update the state value
Fend

Function popPanelState(currentState As Integer) As Integer
	' This state picks up a panel from the input magazine and moves it to the home position

	If recPopPanelRequired = False Then		' We are skipping this state
		currentState = StateCrowding
		GoTo popPanelStateEnd
	EndIf
	
	Select PickupPanel						' Call the function that picks up a panel and check its return value

		Case 0								' Panel was picked up successfully		
			currentState = StateCrowding
			Print "Pick up Successful"
		Case 1 								' Keep trying until the interlock is closed
			currentState = StatePopPanel
			Print "Waiting for Interlock"
		Case 2								' Go to idle because there was an error 
			Jump PreScan LimZ zLimit 		' go back home
			currentState = StateIdle
			Print "Pickup failed"
		Default								' Unknown return value, return to idle
			currentState = StateIdle
			Print "Panel state machine failure... returning to idle"
	Send

	popPanelStateEnd:
	popPanelState = currentState
Fend
Function crowdingState(currentState As Integer) As Integer
	'This state Moves a panel from the home location, crowds it, then presents it to the laser scanner for pre-inspection

	If recCrowdingRequired = False Then 				' Check if we want to skip this state
			currentState = StatePreinspection 			' skip crowding, go to next state
			GoTo crowdingStateEnd
	EndIf
	
	If CrowdingSequence = 0 Then						' there were no problems with the crowding
		currentState = StatePreinspection
	EndIf
	
	crowdingStateEnd:
	crowdingState = currentState
Fend
Function preinspectionState(currentState As Integer) As Integer
	' This state uses the laser scanner to find pre-installed inserts and attempts
	' to check if the correct panel has been put into the magazine.

	If recPreinspectionRequired = False Then 	'Check if we want to skip this state
		currentState = StateHotStakePanel
		GoTo preinspectionStateEnd
	EndIf

	Select InspectPanel(1)						' 1=Preinspection TODO - change this to a #define
		Case 0
			currentState = StateHotStakePanel
			Print "Preinspection executed"
		Case 2									' failed preinspection
			currentState = StatePushPanel 	' Drop off a panel before we go to idle 
		Default
			currentState = StatePushPanel
	Send
	
	preinspectionStateEnd:
	preinspectionState = currentState
Fend
Function insertionState(currentState As Integer) As Integer
	' This state iterates through each hole and installs all inserts
	If recHotStakePanelRequired = False Then 		'Check if we want to skip this state
		currentState = StatePushPanel
		GoTo insertionStateEnd
	EndIf
	
	Select HotStakePanel
		Case 0
			Print "hot stake done"
			If recFlashRequired = False Then
				currentState = StateInspection 		' Flash not required so skip it
			Else
				currentState = StateFlashRemoval 	' The next state is normally Flash Removal
			EndIf
		Case 2										' Error
			currentState = StatePushPanel 			' Drop off a panel before we go to idle
		Default
			currentState = StatePushPanel
	Send

	insertionStateEnd:
	insertionState = currentState
Fend
Function flashRemovalState(currentState As Integer) As Integer
	' This state performs flash removal
	If recFlashRequired = False Then 'Check if we want to skip this state
		currentState = StateInspection
		GoTo flashRemovalStateEnd
	EndIf

	Select FlashPanel(recFlashDwellTime)
		Case 0
			currentState = StateInspection
		Case 2										' Error
			currentState = StatePushPanel 			' Drop off a panel before we go to idle
		Default
			currentState = StatePushPanel
	Send

	flashRemovalStateEnd:
	flashRemovalState = currentState
Fend
Function inspectionState(currentState As Integer) As Integer
	' This state uses the laser scanner to measure and log the depths of each insert at two places
	' No matter the result of the InspectPanel() routine it always pushes a panel, but we need to know why
	' it pushed-thus the different checks.

	If recInspectionRequired = False Then 'Check if we want to skip this state
		currentState = StatePushPanel
		GoTo inspectionStateEnd
	EndIf
	
	Select InspectPanel(2)				' 2=Inspection of Install Inserts 
		Case 0
			currentState = StatePushPanel
			Print "Inspection Executed"
		Case 2
			currentState = StatePushPanel ' Drop off a panel before we go to idle
		Default
			currentState = StatePushPanel
	Send

	inspectionStateEnd:
	inspectionState = currentState
Fend
Function pushPanelState(currentState As Integer) As Integer
	' This state drops off a panel into the output magazine. 		
				 
	If recPushPanelRequired = False Then 	'Check if we want to skip this state
		currentState = StateIdle
		GoTo pushPanelStateEnd
	EndIf
	
	Select DropOffPanel
		Case 0 								' We successfully dropped off a panel
			currentState = StatePopPanel
		Case 1								' Keep trying until the interlock is closed
			currentState = StatePushPanel
		Case 2
			Pause
		Default
			currentState = StateIdle
	Send

	' TODO -- check to ensure that the jump doesn't cause issues with the rest of this state
	If jobAbort = True Or jobDone = True Then
		Jump PreScan LimZ zLimit ' go home
		currentState = StateIdle ' Go to idle because the operator wants to quit or job is done	
		jobAbort = False ' reset flag
		jobStart = False ' reset flag
		jobDone = False ' reset flag
	EndIf

	pushPanelStateEnd:
	pushPanelState = currentState
Fend
Function dumpState(currentState As Integer) As Integer
	' This is handled by the PLC, we will set a bit to start and another when done
	' Once the PLC is done, we will be able to leave this state
	' The button on the HMI should be greyed out if the state is not in idle
	' If pasEmptyingSequenceDone = True Or Tmr(3) >= 600 Then
	currentState = StateIdle ' go back to idle because we are finished

	dumpState = currentState
Fend

