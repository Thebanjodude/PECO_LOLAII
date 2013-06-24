'Function TeachPoints()
'' Using the all-thread to teach the points, then using the known distances of the EOAT to  
'' derive the location of the anvil
'
'HotStakeCenter = HSanvil -X(InTomm(2.0)) +Y(InTomm(4.06)) :U(135) :Z(-25)
'FlashCenter = Flashanvil -X(InTomm(2.0)) +Y(InTomm(4.06)) :U(203.795) :Z(-25)
'	
'Print "HotStakeCenter", HotStakeCenter
'Print "FlashCenter", FlashCenter
'	
'Fend
'Function CalibrateEOAT()
'	
'Real eoatLegnth, EOATyerror1, EOATyerror2, zoffset, yerror0, yerror180, EOATyerror3, EOATyerror4
'Real x1, LaserXcoordinate, LaserYcoordinate, LaserZcoordinate, thetaerror, thetaerror1, thetaerror2
'
'Speed 25 'slow it down so we get a better reading
'SpeedS 50
'
'	Go PreScan :Z(-85) CP  ' Use CP so it's not jumpy			
'	ChangeProfile("12")
'	
'	Go LaserCalibr -Y(2.5) CP ' go to about where the drop off should be
'	Wait 2 ' wait for EOAT to settle	
'	EOATyerror1 = GetLaserMeasurement("01")
'	Print "EOATyerror1", EOATyerror1
'	
'	Go LaserCalibr +Y(2.5) CP ' go to about where the drop off should be
'	Wait 2 ' wait for EOAT to settle	
'	EOATyerror2 = GetLaserMeasurement("01")
'	Print "EOATyerror2", EOATyerror2
'
'	yerror0 = EOATyerror1 - EOATyerror2
'	thetaerror1 = RadToDeg(Atan(yerror0 / 5))
'	Print "thetaerror1", thetaerror1
'	
'	Go LaserCalibr -Y(2.5) +U(180)  ' go to about where the drop off should be
'	Wait .5 ' wait for EOAT to settle	
'	EOATyerror3 = GetLaserMeasurement("01")
'	Print "EOATyerror3", EOATyerror3
'	
'	Go LaserCalibr +Y(2.5) +U(180) CP ' go to about where the drop off should be
'	Wait .5 ' wait for EOAT to settle	
'	EOATyerror4 = GetLaserMeasurement("01")
'	Print "EOATyerror4", EOATyerror4
'	
'	yerror180 = EOATyerror3 - EOATyerror4
'	thetaerror2 = RadToDeg(Atan(yerror180 / 5))
'	Print "thetaerror2", thetaerror2
'	
'	thetaerror = (thetaerror1 + thetaerror2) /2
'	Print "thetaerror", thetaerror
'	
'	EOATOffset = EOATOffset :U(thetaerror)
'	
'	Go PreScan :Z(-85) CP  ' Use CP so it's not jumpy
'	Wait .25
'	
'Fend
'Function CalibrateLaserLocation()
'	
'Real eoatLegnth, EOATxerror, zoffset
'Real yTouchPoint, LaserXcoordinate, LaserYcoordinate, LaserZcoordinate
'
''At the start LaserCalibrY is approx where the EAOT drop off is.
'
'eoatLegnth = InTomm(12.5) ' overall dim
'
''CalibrateEOAT() ' unfake
'LaserCalibr = LaserCalibr '+U(CU(EOATOffset))
'
'Print EOATOffset
'	
'Speed 25 'slow it down so we get a better reading
'SpeedS 50
'
'	Go PreScan :Z(-85) CP  ' Use CP so it's not jumpy			
'	ChangeProfile("12")
'	
'	Move LaserCalibr CP ' go to about where the drop off should be
'	Wait .5 ' wait for EOAT to settle
'	Print "Check that the EOAT is square with the laser"
'	Pause
'	
'	EOATxerror = -1 * GetLaserMeasurement("01")
'	Print "EOATxerror", EOATxerror
'
'	Do Until Abs(EOATxerror) <= 0.020
'		LaserCalibr = LaserCalibr +X(EOATxerror)
'		Go LaserCalibr
'		EOATxerror = -1 * GetLaserMeasurement("01")
'		Print "EOATxerror: ", EOATxerror
'	Loop
'	Pause
'	
'	LaserXcoordinate = CX(Here) - 16.02 ' add the EOAT step offset	
'	LaserCalibr = LaserCalibr :X(LaserXcoordinate)
'	Print "LaserXcoordinate", LaserXcoordinate
'	Go LaserCalibr ' go to where the center of the EOAT is to get a visual check
'	Print "is the EOAT about center with the laser?"
'	Pause
'	
'	Go PreScan :X(LaserXcoordinate) :Z(-85) CP  ' Use CP so it's not jumpy
'	Wait .25
'	
'	ChangeProfile("11")
'	Move LaserCalibrMax :X(LaserXcoordinate) CP Till Sw(edgeDetectGoH) ' capture the very tip of the EOAT
'
'	 If TillOn = False Then ' if we get to Laser calibr then we missed 
'	 	Print "missed EOAT"
'	 EndIf
'		
'	yTouchPoint = CY(CurPos) ' yTouchPoint is where we captured the tip of the EOAT
'	Print "yTouchPoint", yTouchPoint
'	
'	LaserYcoordinate = yTouchPoint + (eoatLegnth /2) ' distance between the quill center and laser
'	
'	Print "LaserYcoordinate", LaserYcoordinate
'	
'' comment this out until it matters	
''	zoffset = GetLaserMeasurement("15")
''	LaserZcoordinate = CZ(LaserCalibrMax) + zoffset
''	
''	zoffset = GetLaserMeasurement("15")
''	Do Until EOATyerror <= .02
''		zoffset = GetLaserMeasurement("15")
''		Print "zoffset", zoffset
''		LaserCalibrY = LaserCalibrY +Z(zoffset)
''		Go LaserCalibrY
''		Wait .25
''	Loop
'	
'	Pause
''	
''	' It is important to know that LaserCenter is defined as 0,0 and
''	' populated by this function. It will remain 0,0 in the points table
''	' but the calibrated values are set in volitale memory.
''	
'	LaserCenter = LaserCenter :X(LaserXcoordinate) :Y(LaserYcoordinate) :Z(LaserZcoordinate)
'	Print "LaserCenter", LaserCenter
'	
'Fend
