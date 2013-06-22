Function TeachPoints()
' Using the all-thread to teach the points, then using the known distances of the EOAT to  
' derive the location of the anvil

HotStakeCenter = HSanvil -X(InTomm(2.0)) +Y(InTomm(4.06)) :U(135) :Z(-25)
FlashCenter = Flashanvil -X(InTomm(2.0)) +Y(InTomm(4.06)) :U(203.795) :Z(-25)
	
Print "HotStakeCenter", HotStakeCenter
Print "FlashCenter", FlashCenter
	
Fend

