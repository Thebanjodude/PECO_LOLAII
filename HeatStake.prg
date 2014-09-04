#include "Globals.INC"

Function HotStakePanel() As Integer

	SystemStatus = StateHotStakePanel
	
	Integer i
	Real RobotZOnAnvil
	Boolean SkippedHole
	currentHSHole = 1 				' Start at 1 (we are skipping the 0 index in the array)
	HotStakePanel = 2 				' default to fail	
	
	' check to see if the PLC is in the correct state for entering the insertion program
	If MemSw(m_idle) = False Then
		Print "HEAT STAKE: Error - PLC not ready"
		Pause
	EndIf
	
	' Present panel to hot stake
	If Not HomeCheck Then findHome
	Jump PreHotStake 'LimZ zLimit
	
	' Tell PLC to start the insertion process
	MBWrite(103, True, MBTypeCoil)
	
	' ready signal from PLC
	Wait MemSw(m_ready) = True

	' allows us to update SkipHoleArray
'	Pause
	
	
	'For i = recFirstHolePointHotStake To recLastHolePointHotStake
	For i = 1 To recNumberOfHoles

		SkippedHole = False 							'Reset flag		
		If SkipHoleArray(currentHSHole, 0) <> 0 Then 	' When nonzero, don't populate the hole because we want to skip it
			SkippedHole = True 							'Set flag
			Print "Skipped Hole"
		EndIf
		
		'testing	
		'SkippedHole = True
		'SkippedHole = False
		
		If SkippedHole = False Then 			'If the flag is set then skip the hole
			
			'Jump P(i) +Z(10) LimZ zLimit  		' Go to the next hole
			LimZ 20.0
			PanelHoleToXYZT(i, CX(hotstake), CY(hotstake), CZ(prehotstake) + 10, 135 - PanelHoleTangent(i))
			
			SFree 1, 2 							' free X and Y

			Do While Sw(HSPanelPresntH) = False
				JTran 3, -.5 					' Move only the z-axis downward in increments
			Loop
			
			' Tell PLC to insert one part
			MBWrite(105, True, MBTypeCoil)

			' Wait for the PLC to start
			Wait MemSw(m_inserting) = True
			
			' Reset the start insertion bit
			MBWrite(105, False, MBTypeCoil)
			
			' Wait for the PLC to finsih
			Wait MemSw(m_ready) = True
			
'			Wait 3

			ZmaxTorque = 0
			PTCLR (3)

			SLock 1, 2, 3, 4 						' lock all the joints so we can move again
			Go XY(CX(CurPos), CY(CurPos), CZ(prehotstake), CU(CurPos)) /L
	
		EndIf
		
		currentHSHole = currentHSHole + 1
	Next
	
	HotStakePanel = 0 							' HS station executed without a problem
		
	SystemStatus = StateMoving

	findHome
	
	' Tell the PLC to leave the inserting state
	MBWrite(104, True, MBTypeCoil)
	Wait MemSw(m_idle) = True

	' cleanup flags
	MBWrite(103, False, MBTypeCoil)
	MBWrite(104, False, MBTypeCoil)
			
Trap 2 ' disarm trap	

Fend

