Global Boolean g_io_xfr_on, inMagMtr
Global Integer NextThetaPoint, recNumberOfHoles
Global Integer g_RoboVars(10)
Global Integer g_HmiVars(10)
Global Real g_LaserMeasure

Function IOTEST
	Integer i
	Integer NumChars
	String InString$
	Port:201

	' kick off the HMI communication task
	g_io_xfr_on = 1
	Xqt iotransfer, NoEmgAbort
	Xqt HmiListen, NoEmgAbort
	
	' define the connection to the LASER
    SetNet #203, "10.22.251.171", 7351, CR, NONE, 0
    OpenNet #203 As Client
	
	'start theta record points at 100
	NextThetaPoint = 100
	
'	Do While 1
'		P(100) = Here
'		Print "initial theta is :", CU(P(NextThetaPoint))
'		Wait 1.0
'		Print "Calling laser measure"
'		Call LS_cmd
'		Wait Sw(8)

'		Trap 1 Sw(9) Xqt RecordTheta
'		Call Rotate
'		Print "Theta captured was: ", CU(P(NextThetaPoint))
'		Wait 1.0
'		Move P(100) ROT
'		Wait 1.0
'		Move Here :U(0) ROT
'	Loop
Fend
Function iotransfer()
' This task runs continuously in the background updating variables between the controller and HMI
' write and read variables to HMI
                
    Integer i, j
    String response$
    String outstring$
    
    ' define the connection to the HMI
'    SetNet #201, "10.22.2.30", 1502, CRLF, NONE, 0
    SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0

    Do While g_io_xfr_on = 1
    	Wait 1.0 'send I/O once per second
        If ChkNet(201) < 0 Then ' If port is not open
        	Off (HMI_connected), Forced ' initialize to off
            OpenNet #201 As Client
            'Print "Attempted Open TCP port to HMI"
        Else
            On (HMI_connected), Forced 'indicate HMI is connected
            ' write variable data to HMI
'            Write #201, Chr$(12) 'this breaks the JSON interpreter

				'Tx to HMI:
				Print #201, "{", Chr$(&H22) + "inMagMtr" + Chr$(&H22), ":", Str$(inMagMtr), "}"
				Print #201, "{", Chr$(&H22) + "inMagMtrDir" + Chr$(&H22), ":", Str$(inMagMtrDir), "}"
				Print #201, "{", Chr$(&H22) + "inMagPanelRdy" + Chr$(&H22), ":", Str$(inMagPanelRdy), "}"
				Print #201, "{", Chr$(&H22) + "inMagUpperLim" + Chr$(&H22), ":", Str$(inMagUpperLim), "}"
				Print #201, "{", Chr$(&H22) + "inMagLowerLim" + Chr$(&H22), ":", Str$(inMagLowerLim), "}"
				Print #201, "{", Chr$(&H22) + "inMagInterlock" + Chr$(&H22), ":", Str$(inMagInterlock), "}"
				Print #201, "{", Chr$(&H22) + "outMagMtr" + Chr$(&H22), ":", Str$(outMagMtr), "}"
				Print #201, "{", Chr$(&H22) + "outMagMtrDir" + Chr$(&H22), ":", Str$(outMagMtrDir), "}"
				Print #201, "{", Chr$(&H22) + "outMagPanelRdy" + Chr$(&H22), ":", Str$(outMagPanelRdy), "}"
				Print #201, "{", Chr$(&H22) + "outMagUpperLim" + Chr$(&H22), ":", Str$(outMagUpperLim), "}"
				Print #201, "{", Chr$(&H22) + "outMagLowerLim" + Chr$(&H22), ":", Str$(outMagLowerLim), "}"
				Print #201, "{", Chr$(&H22) + "outMagInt" + Chr$(&H22), ":", Str$(outMagInt), "}"
				Print #201, "{", Chr$(&H22) + "flashMtr" + Chr$(&H22), ":", Str$(flashMtr), "}"
				Print #201, "{", Chr$(&H22) + "flashCyc" + Chr$(&H22), ":", Str$(flashCyc), "}"
				Print #201, "{", Chr$(&H22) + "flashPnlPrsnt" + Chr$(&H22), ":", Str$(FlashPnlPrsnt), "}"
				Print #201, "{", Chr$(&H22) + "hsPanelPresnt" + Chr$(&H22), ":", Str$(hsPanelPresnt), "}"
				Print #201, "{", Chr$(&H22) + "hsInstallInsrt" + Chr$(&H22), ":", Str$(hsInstallInsrt), "}"
				Print #201, "{", Chr$(&H22) + "cbMonHeatStake" + Chr$(&H22), ":", Str$(cbMonHeatStake), "}"
				Print #201, "{", Chr$(&H22) + "cbMonBowlFeder" + Chr$(&H22), ":", Str$(cbMonBowlFeder), "}"
				Print #201, "{", Chr$(&H22) + "cbMonInMag" + Chr$(&H22), ":", Str$(cbMonInMag), "}"
				Print #201, "{", Chr$(&H22) + "cbMonFlashRmv" + Chr$(&H22), ":", Str$(cbMonFlashRmv), "}"
				Print #201, "{", Chr$(&H22) + "cbMonDebrisRmv" + Chr$(&H22), ":", Str$(cbMonDebrisRmv), "}"
				Print #201, "{", Chr$(&H22) + "dcPwrOk" + Chr$(&H22), ":", Str$(dcPwrOk), "}"
				Print #201, "{", Chr$(&H22) + "cbMonPnumatic" + Chr$(&H22), ":", Str$(cbMonPnumatic), "}"
				Print #201, "{", Chr$(&H22) + "cbMonSafety" + Chr$(&H22), ":", Str$(cbMonSafety), "}"
				Print #201, "{", Chr$(&H22) + "cbMonPAS24vdc" + Chr$(&H22), ":", Str$(cbMonPAS24vdc), "}"
				Print #201, "{", Chr$(&H22) + "hmiPause" + Chr$(&H22), ":", Str$(hmiPause), "}"
				Print #201, "{", Chr$(&H22) + "suctionCups" + Chr$(&H22), ":", Str$(suctionCups), "}"
				
				'Integers
				Print #201, "{", Chr$(&H22) + "systemStatus" + Chr$(&H22), ":", Str$(systemStatus), "}"
				Print #201, "{", Chr$(&H22) + "hmiStatus" + Chr$(&H22), ":", Str$(hmiStatus), "}"
				Print #201, "{", Chr$(&H22) + "hsProbeTemp" + Chr$(&H22), ":", Str$(hsProbeTemp), "}"
				Print #201, "{", Chr$(&H22) + "jobNumPanelsDone" + Chr$(&H22), ":", Str$(jobNumPanelsDone), "}"
				
'				'Errors
'				'Print error vars here	


'            	Print #201, "Laser Measurement = ", g_LaserMeasure
        EndIf
	Loop
Fend
' This task runs continuously in the background listening
'   for input from the HMI and updating global variables

Function setVars(response$ As String)
    Integer i, j, numTokens
    String tokens$(0)
    String outstring$
    String match$
    String prepend$

    match$ = "{:} " + Chr$(&H22)
    
	numTokens = ParseStr(response$, tokens$(), match$)
	If numTokens <> 2 Then ' TODO for ben, something is running too fast
		Print "error---", response$, " -- ", numTokens
	EndIf
'	Print tokens$(0), " : ", tokens$(1)
	
	Select tokens$(0)
	Case "inMagGoHome"
		If tokens$(1) = "true" Then
			inMagGoHome = True
		Else
			inMagGoHome = False
		EndIf
		Print "inMagGoHome:", inMagGoHome
	Case "outMagGoHome"
		If tokens$(1) = "true" Then
			outMagGoHome = True
		Else
			outMagGoHome = False
		EndIf
		Print "outMagGoHome:", outMagGoHome
	Case "inMagLoaded"
		If tokens$(1) = "true" Then
			inMagLoaded = True
		Else
			inMagLoaded = False
		EndIf
		Print "inMagLoaded:", inMagLoaded
	Case "outMagUnloaded"
		If tokens$(1) = "true" Then
			outMagUnloaded = True
		Else
			outMagUnloaded = False
		EndIf
		Print "outMagUnloaded:", outMagUnloaded
	Case "inMagIntLockAck"
		If tokens$(1) = "true" Then
			inMagIntLockAck = True
		Else
			inMagIntLockAck = False
		EndIf
		Print "inMagIntLockAck:", inMagIntLockAck
	Case "outMagIntLockAck"
		If tokens$(1) = "true" Then
			outMagIntLockAck = True
		Else
			outMagIntLockAck = False
		EndIf
		Print "outMagIntLockAck:", outMagIntLockAck
	Case "recNumberOfHoles"
			recNumberOfHoles = Val(tokens$(1))
		Print "recNumberOfHoles:", recNumberOfHoles
	Case "recFlashRequired"
		If tokens$(1) = "true" Then
			recFlashRequired = True
		Else
			recFlashRequired = False
		EndIf
		Print "recFlashRequired:", recFlashRequired
	Case "recZDropOff"
			recZDropOff = Val(tokens$(1))
		Print "recZDropOff:", recZDropOff
	Case "recInsertType"
			recInsertType = Val(tokens$(1))
		Print "recInsertType:", recInsertType
	Case "recInsertDepth"
			recInsertDepth = Val(tokens$(1))
		Print "recInsertDepth:", recInsertDepth
	Case "recMajorDim"
			recMajorDim = Val(tokens$(1))
		Print "recMajorDim:", recMajorDim
	Case "recMinorDim"
			recMinorDim = Val(tokens$(1))
		Print "recMinorDim:", recMinorDim
	Case "sftyFrmIlockAck"
		If tokens$(1) = "true" Then
			sftyFrmIlockAck = True
		Else
			sftyFrmIlockAck = False
		EndIf
		Print "sftyFrmIlockAck:", sftyFrmIlockAck
	Case "inMagMtrF"
		If tokens$(1) = "true" Then
			MemOn (inMagMtrF)
		Else
			MemOff (inMagMtrF)
		EndIf
	Case "inMagMtrDirF"
		If tokens$(1) = "true" Then
			MemOn (inMagMtrDirF)
		Else
			MemOff (inMagMtrDirF)
		EndIf
	Case "inMagPartReadyF"
		If tokens$(1) = "true" Then
			MemOn (inMagPartReadyF)
		Else
			MemOff (inMagPartReadyF)
		EndIf
	Case "inMagUpperLimF"
		If tokens$(1) = "true" Then
			MemOn (inMagUpperLimF)
		Else
			MemOff (inMagUpperLimF)
		EndIf
	Case "inMagLowerLimF"
		If tokens$(1) = "true" Then
			MemOn (inMagLowerLimF)
		Else
			MemOff (inMagLowerLimF)
		EndIf
	Case "inMagInterlockF"
		If tokens$(1) = "true" Then
			MemOn (inMagInterlockF)
		Else
			MemOff (inMagInterlockF)
		EndIf
	Case "outMagMtrF"
		If tokens$(1) = "true" Then
			MemOn (outMagMtrF)
		Else
			MemOff (outMagMtrF)
		EndIf
	Case "outMagMtrDirF"
		If tokens$(1) = "true" Then
			MemOn (outMagMtrDirF)
		Else
			MemOff (outMagMtrDirF)
		EndIf
	Case "outMagPartRdyF"
		If tokens$(1) = "true" Then
			MemOn (outMagPartRdyF)
		Else
			MemOff (outMagPartRdyF)
		EndIf
	Case "outMagUpperLimF"
		If tokens$(1) = "true" Then
			MemOn (outMagUpperLimF)
		Else
			MemOff (outMagUpperLimF)
		EndIf
	Case "outMagLowerLimF"
		If tokens$(1) = "true" Then
			MemOn (outMagLowerLimF)
		Else
			MemOff (outMagLowerLimF)
		EndIf
	Case "outMagIntF"
		If tokens$(1) = "true" Then
			MemOn (outMagIntF)
		Else
			MemOff (outMagIntF)
		EndIf
	Case "flashMtrF"
		If tokens$(1) = "true" Then
			MemOn (flashMtrF)
		Else
			MemOff (flashMtrF)
		EndIf
	Case "flashCycF"
		If tokens$(1) = "true" Then
			MemOn (flashCycF)
		Else
			MemOff (flashCycF)
		EndIf
	Case "inMagMtrFV"
		If tokens$(1) = "true" Then
			MemOn (inMagMtrFV)
		Else
			MemOff (inMagMtrFV)
		EndIf
	Case "inMagMtrDirFV"
		If tokens$(1) = "true" Then
			MemOn (inMagMtrDirFV)
		Else
			MemOff (inMagMtrDirFV)
		EndIf
	Case "inMagPartReadyFV"
		If tokens$(1) = "true" Then
			MemOn (inMagPartReadyFV)
		Else
			MemOff (inMagPartReadyFV)
		EndIf
	Case "inMagUpperLimFV"
		If tokens$(1) = "true" Then
			MemOn (inMagUpperLimFV)
		Else
			MemOff (inMagUpperLimFV)
		EndIf
	Case "inMagLowerLimFV"
		If tokens$(1) = "true" Then
			MemOn (inMagLowerLimFV)
		Else
			MemOff (inMagLowerLimFV)
		EndIf
	Case "inMagInterlockFV"
		If tokens$(1) = "true" Then
			MemOn (inMagInterlockFV)
		Else
			MemOff (inMagInterlockFV)
		EndIf
	Case "outMagMtrFV"
		If tokens$(1) = "true" Then
			MemOn (outMagMtrFV)
		Else
			MemOff (outMagMtrFV)
		EndIf
	Case "outMagMtrDirFV"
		If tokens$(1) = "true" Then
			MemOn (outMagMtrDirFV)
		Else
			MemOff (outMagMtrDirFV)
		EndIf
	Case "outMagPartRdyFV"
		If tokens$(1) = "true" Then
			MemOn (outMagPartRdyFV)
		Else
			MemOff (outMagPartRdyFV)
		EndIf
	Case "outMagUpperLimFV"
		If tokens$(1) = "true" Then
			MemOn (outMagUpperLimFV)
		Else
			MemOff (outMagUpperLimFV)
		EndIf
	Case "outMagLowerLimFV"
		If tokens$(1) = "true" Then
			MemOn (outMagLowerLimFV)
		Else
			MemOff (outMagLowerLimFV)
		EndIf
	Case "outMagIntFV"
		If tokens$(1) = "true" Then
			MemOn (outMagIntFV)
		Else
			MemOff (outMagIntFV)
		EndIf
	Case "flashMtrFV"
		If tokens$(1) = "true" Then
			MemOn (flashMtrFV)
		Else
			MemOff (flashMtrFV)
		EndIf
	Case "flashCycFV"
		If tokens$(1) = "true" Then
			MemOn (flashCycFV)
		Else
			MemOff (flashCycFV)
		EndIf
	Case "hsInstallInsrtF"
		If tokens$(1) = "true" Then
			MemOn (hsInstallInsrtF)
		Else
			MemOff (hsInstallInsrtF)
		EndIf
	Case "hsInstallInsrtFV"
		If tokens$(1) = "true" Then
			MemOn (hsInstallInsrtFV)
		Else
			MemOff (hsInstallInsrtFV)
		EndIf
	Case "cbMonHeatStakeF"
		If tokens$(1) = "true" Then
			MemOn (cbMonHeatStakeF)
		Else
			MemOff (cbMonHeatStakeF)
		EndIf
	Case "cbMonBowlFederF"
		If tokens$(1) = "true" Then
			MemOn (cbMonBowlFederF)
		Else
			MemOff (cbMonBowlFederF)
		EndIf
	Case "cbMonInMagF"
		If tokens$(1) = "true" Then
			MemOn (cbMonInMagF)
		Else
			MemOff (cbMonInMagF)
		EndIf
	Case "cbMonOutMagF"
		If tokens$(1) = "true" Then
			MemOn (cbMonOutMagF)
		Else
			MemOff (cbMonOutMagF)
		EndIf
	Case "cbMonFlashRmvF"
		If tokens$(1) = "true" Then
			MemOn (cbMonFlashRmvF)
		Else
			MemOff (cbMonFlashRmvF)
		EndIf
	Case "cbMonDebrisRmvF"
		If tokens$(1) = "true" Then
			MemOn (cbMonDebrisRmvF)
		Else
			MemOff (cbMonDebrisRmvF)
		EndIf
	Case "dcPwrOkF"
		If tokens$(1) = "true" Then
			MemOn (dcPwrOkF)
		Else
			MemOff (dcPwrOkF)
		EndIf
	Case "cbMonPnumaticF"
		If tokens$(1) = "true" Then
			MemOn (cbMonPnumaticF)
		Else
			MemOff (cbMonPnumaticF)
		EndIf
	Case "cbMonSafetyF"
		If tokens$(1) = "true" Then
			MemOn (cbMonSafetyF)
		Else
			MemOff (cbMonSafetyF)
		EndIf
	Case "cbMonPAS24vdcF"
		If tokens$(1) = "true" Then
			MemOn (cbMonPAS24vdcF)
		Else
			MemOff (cbMonPAS24vdcF)
		EndIf
	Case "cbMonHeatStakeFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonHeatStakeFV)
		Else
			MemOff (cbMonHeatStakeFV)
		EndIf
	Case "cbMonBowlFederFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonBowlFederFV)
		Else
			MemOff (cbMonBowlFederFV)
		EndIf
	Case "cbMonInMagFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonInMagFV)
		Else
			MemOff (cbMonInMagFV)
		EndIf
	Case "cbMonOutMagFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonOutMagFV)
		Else
			MemOff (cbMonOutMagFV)
		EndIf
	Case "cbMonFlashRmvFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonFlashRmvFV)
		Else
			MemOff (cbMonFlashRmvFV)
		EndIf
	Case "cbMonDebrisRmvFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonDebrisRmvFV)
		Else
			MemOff (cbMonDebrisRmvFV)
		EndIf
	Case "dcPwrOkFV"
		If tokens$(1) = "true" Then
			MemOn (dcPwrOkFV)
		Else
			MemOff (dcPwrOkFV)
		EndIf
	Case "cbMonPnumaticFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonPnumaticFV)
		Else
			MemOff (cbMonPnumaticFV)
		EndIf
	Case "cbMonSafetyFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonSafetyFV)
		Else
			MemOff (cbMonSafetyFV)
		EndIf
	Case "cbMonPAS24vdcFV"
		If tokens$(1) = "true" Then
			MemOn (cbMonPAS24vdcFV)
		Else
			MemOff (cbMonPAS24vdcFV)
		EndIf
	Case "anvilZlimit"
			AnvilZlimit = Val(tokens$(1))
		Print "anvilZlimit:", AnvilZlimit
	Case "systemSpeed"
			SystemSpeed = Val(tokens$(1))
		Print "systemSpeed:", SystemSpeed
	Case "recTemp"
			recTemp = Val(tokens$(1))
		Print "recTemp:", recTemp
	Case "jobNumPanels"
	Case "hmiStopJob"
		If tokens$(1) = "true" Then
			hmiStopJob = True
		Else
			hmiStopJob = False
		EndIf
		Print "hmiStopJob:", hmiStopJob
	Case "robStart"
		If tokens$(1) = "true" Then
			robStart = True
		Else
			robStart = False
		EndIf
		Print "robStart:", robStart
	Case "robStop"
		If tokens$(1) = "true" Then
			robStop = True
		Else
			robStop = False
		EndIf
		Print "robStop:", robStop
	Case "robPause"
		If tokens$(1) = "true" Then
			robPause = True
		Else
			robPause = False
		EndIf
		Print "robPause:", robPause
	Case "robResume"
		If tokens$(1) = "true" Then
			robResume = True
		Else
			robResume = False
		EndIf
		Print "robResume:", robResume
	Case "recBossHeight"
			recBossHeight = Val(tokens$(1))
		Print "recBossHeight:", recBossHeight


	Default
			' TMH for now print come back and do something useful
			'Print "Invalid Token received"
	Send
	
	
	
Fend

Function HmiListen()
                
    Integer i, j, numTokens
    String tokens$(0)
    String response$
    String outstring$
    String match$
    String prepend$
    Integer ProcessLastToken
     
    ' define the connection to the HMI
    SetNet #202, "10.22.251.68", 1503, CRLF, NONE, 0
    
    prepend$ = ""
    
    OpenNet #202 As Server
 
    Do While True
	    i = ChkNet(202)
	    j = 0
	    Select i
	    	Case -3 'port is not open
	    		OpenNet #202 As Server
	    	Case < 1
	    		prepend$ = ""
	   		Case > 0
				ProcessLastToken = 0
				If i > 200 Then
					i = 200
				EndIf
			   	Read #202, response$, i
			   	response$ = prepend$ + response$
			   	If Right$(response$, 1) = "}" Then 'the last token is ok, so process it
			   		ProcessLastToken = 1
			   	EndIf
				numTokens = ParseStr(response$, tokens$(), "}")
				numTokens = numTokens + ProcessLastToken

				Do While j < numTokens - 1
					setVars(tokens$(j))
					j = j + 1
				Loop
				If ProcessLastToken Then
					prepend$ = ""
				Else
					prepend$ = tokens$(numTokens - 1)
				EndIf
	    Send

	Loop
    	

Fend
' This task is used to query the laser measurement
Function LS_cmd()
                
    Integer i, j, NumTokens
    String Tokens$(0)
    String response$
    String outstring$
                
'   Do While g_io_xfr_on = 1
   Print "Entered LS_CMD"

        	Print "Trying Laser..."
        	Print #203, "MS,0,01"
        	Wait 1.0
            i = ChkNet(203)
            If i > 0 Then
            	Read #203, response$, i
            	NumTokens = ParseStr(response$, Tokens$(), ",")
  				g_LaserMeasure = Val(Tokens$(1))
                Print "Measurement: ", response$
            EndIf
'	Loop
Fend
