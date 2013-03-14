'Global Integer g_twiddle
'Global Boolean g_io_xfr_on
Global Integer NextThetaPoint




'' This task runs continuously in the background updating variables
''   between the controller and HMI
'' write variables to HMI
'' read variables from HMI
'Function iotransfer()
'                
'    Integer data_table_size
'    Integer i, j
'    String response$
'    String outstring$
'                
'    data_table_size = 10
'    Integer data_table(0)
'    Redim data_table(data_table_size)
'    
'    data_table(0) = 34
'    data_table(1) = 245
'    data_table(3) = 745
'    data_table(4) = 0
'                
'    ' define the connection to the HMI
'    SetNet #201, "10.22.251.171", 1502, CRLF, NONE, 0
'
'    Do While g_io_xfr_on = 1
'        ' update the data table with a global value that's changing
'        data_table(0) = g_twiddle
'        
'        ' rembember to update transaction ID in final code
'        
'        Wait 1.0 'send I/O once per second
'        If ChkNet(201) < 0 Then ' If port is not open
'            Off (HMI_connected), Forced ' initialize to off
'            OpenNet #201 As Client
'            Print "Attempted Open TCP port to HMI"
'        Else
'            On (HMI_connected), Forced 'indicate HMI is connected
'
'            ' write variable data to HMI
'            For i = 0 To data_table_size
'            '    outstring$ = "{",Str$(i),",",Str$(data_table(i)),"}"
'            '    Write #201, "{", Str$(i), ",", Str$(data_table(i)), "}"
'                Print #201, "{", Str$(i), ",", Str$(data_table(i)), "}"
'            Next
'            Wait 3.0 ' way too long but ok for testing
'            i = ChkNet(201)
'            If i > 0 Then
'                Print "Byte Read back"
'            '    Read #201, response$, i
'                Print "HMI responded with: ", response$
'            Else
'                Print "No Response from HMI"
'            EndIf
'        EndIf
'    Loop
'Fend

