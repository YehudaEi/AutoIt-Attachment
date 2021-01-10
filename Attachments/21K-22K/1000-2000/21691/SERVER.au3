;Server Script. RUN FIRST
TCPStartUp()
$MainSocket = TCPListen(TCPNameToIP(@computername), 65432,  100 )
If $MainSocket = -1 Then Exit
While 1
    $ConnectedSocket = TCPAccept( $MainSocket)
    If $ConnectedSocket >= 0 Then
        msgbox(0,"","connected",1)
        ExitLoop
    EndIf
Wend
While 1
    $Message=TCPRecv($ConnectedSocket,2048)
    Sleep(25)
    If $Message<>"" Then
        Switch $Message
            Case "IPAddress"
                $Info=@IPAddress1
            Case "ComputerName"
                $Info=@ComputerName
            Case "UserName"
                $Info=@UserName
	
			Case "LogonDomain"
            			$Info=@LogonDomain  
			
		    Case "block"
			MsgBox(0, "BLOCKED", "The Administrator has blocked your input!")
		    BlockInput(1)
			
			Case "unblock"
			BlockInput(0)
			MsgBox(0, "UNBLOCK", "The Administrator has unblocked your input!")
		    
			Case "shutdown"
			Shutdown(5)
			
		    Case "logoff"
			Shutdown(0)
			
		    Case "reboot"
			Shutdown(6)
			
			Case "msg1"
			MsgBox(0,"Whatching", "IM WHATCHING YOU")
			
		    Case "msg2"
			MsgBox(0, "","DONT YOU DARE PRESS THAT BUTTON")
			
			Case Else 
                $Info="Command Unknown!"
        EndSwitch
        TCPSend($ConnectedSocket,$Info)
    EndIf
WEnd