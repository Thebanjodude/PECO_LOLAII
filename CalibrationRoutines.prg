Function main2() ' Main2 is called by the HMI using the setprogram command available through Remote Ethernet
	
Real RecCrossSectionalArea
' This function is for the operator to determine the cross sectional area of a panel. Each panel has a different
' cross sectional area when an insert is and is not present. Therefore, we need to measure it on a panel by panel basis.
' The HMI will save it as a recipe value in its database. 

' We need to use the same profile that tells the operator when the hole is in the center of the laser profile
' Eventually there will be visual feedback for the operator.

Do While True
	
	ChangeProfile("") ' Chage the correct profile  
	RecCrossSectionalArea = GetLaserMeasurement("") ' Out xxx is the measurement to find the cross sectional area. 
	Wait 1
	
Loop

Fend


