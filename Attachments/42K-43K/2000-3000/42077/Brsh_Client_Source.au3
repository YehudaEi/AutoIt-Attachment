#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=brsh.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Brsh Client
#AutoIt3Wrapper_Res_Description=Brsh Client
#AutoIt3Wrapper_Res_Fileversion=0.1.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=bahadirkaanuysal@gmail.com
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------


global $strusername = "**"
global $strPassword = "**"
global $agentip
;$wbemFlags=48

#include <EditConstants.au3>
#include <WindowsConstants.au3>
;#include <Base64.au3>
#include <Timers.au3>
#include <Constants.au3>




Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")



; Com Error Handler
Func MyErrFunc()
$HexNumber = Hex($oMyError.Number, 8)
$strMSG = "Error Number: " & $HexNumber & @CRLF
$strMsg &= "WinDescription: " & $oMyError.WinDescription & @CRLF
$strMsg &= "Script Line: " & $oMyError.ScriptLine & @CRLF
ConsoleWrite( "ERROR"& $strMSG)
SetError(1)
Endfunc


;;$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")    ; Initialize a COM error handler
;;; This is my custom defined error handler
;;Func MyErrFunc()
;;  ConsoleWrite("We intercepted a COM Error !"    & @CRLF  & @CRLF & _
;;             "err.description is: " & @TAB & $oMyError.description  & @CRLF & _
;;             "err.windescription:"   & @TAB & $oMyError.windescription & @CRLF & _
;;             "err.number is: "       & @TAB & hex($oMyError.number,8)  & @CRLF & _
;;			   "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
;;             "err.scriptline is: "   & @TAB & $oMyError.scriptline   & @CRLF & _
;;             "err.source is: "       & @TAB & $oMyError.source       & @CRLF & _
;;             "err.helpfile is: "       & @TAB & $oMyError.helpfile     & @CRLF & _
;;             "err.helpcontext is: " & @TAB & $oMyError.helpcontext _
;;            )
;;Endfunc


if Not FileExists(@ScriptDir&"\authentication.ini") then
consolewrite("Authentication.ini file not found please control the file or create new one using info: first line= [AUTH] second line= KEY=YOURKEY"&@crlf)
endif
Global $PacketEND = "*[" & iniread(@ScriptDir&"\authentication.ini","AUTH","KEY","DEFAULT") & "]*";  "[PACKET_END]" ; Defines the end of a packet
Global $PacketMSG = "[PACKET_TYPE_0001]" ; THE COMMAND SENT FOR EXECUTION
Global $PacketPNG = "[PACKET_TYPE_0002]" ; Base64 of FILE TRANSFER binary.
Global $PacketPCI = "[PACKET_TYPE_0003]" ; UserName@PC name
Global $PacketKEY = "[PACKET_TYPE_0004]" ; Change Agent's Authentication Key
Global $PacketKEYNotMatch = "[PACKET_TYPE_0005]" ; Access Denied
Global $PacketEXT = "[PACKET_TYPE_0006]" ;Name of the file to be send
Global $PacketDEST = "[PACKET_TYPE_0007]" ;Destination of the file to be saved


Global $MaxConnections = 1000 ; Maximum number of allowed connections.
Global $PacketSize = 10000 ; Maximum size to receive when packets are checked.
Global $Connection[$MaxConnections + 1][11]
global $i=1
Opt("TCPTimeout", 0)
Opt("GUIOnEventMode", 1)
Global $WS2_32 = DllOpen("Ws2_32.dll") ; Opens Ws2_32.dll to be used later.
Global $NTDLL = DllOpen("ntdll.dll") ; Opens NTDll.dll to be used later.
Global $TotalConnections = 0 ; Holds total connection number.
Global $SocketListen = -1 ; Variable for TCPListen()



global $port = 33892
global $isanyvaliddata=0


If $CmdLine[0] = 0 or $CmdLine[0] = 1  Then
ConsoleWrite(@crlf&@crlf&@crlf&@crlf)

ConsoleWrite("Remote Machines In Workgroup, User Pass Authentication:"&@crlf)
ConsoleWrite('           Usage   : BRSH <PCNAME(or IP)> <username> <password> "command"'&@crlf)
ConsoleWrite('           Example : BRSH 10.3.125.3 administrator 123456 "notepad.exe"'&@crlf&@crlf&@crlf)

ConsoleWrite("For Authorized Users and Domain Admins:"&@crlf)
ConsoleWrite('           Usage   : BRSH <PCNAME(or IP)> "command"'&@crlf)
ConsoleWrite('           Example : BRSH 10.3.125.3 "notepad.exe"'&@crlf)
ConsoleWrite("           Note    : Use command in double quates if command contains spaces"&@crlf)
ConsoleWrite('           Example : BRSH 10.3.125.3 "D:\SOME FOLDER\notepad.exe" '&@crlf&@crlf&@crlf)


ConsoleWrite('AGENT Usage , Assuming Remote PC/Server has  "BRSHAGENT" service running. '&@crlf)
ConsoleWrite('           Usage   : BRSH AGENT <PCNAME(or IP)> "Command" '&@crlf)
ConsoleWrite('           Example : BRSH AGENT 10.3.125.3 "Net Start" '&@crlf&@crlf&@crlf)

ConsoleWrite("AGENT Authentication Key Change;"&@crlf)
ConsoleWrite('           Usage   : BRSH AGENTKEYCHANGE <PCNAME(or IP)> "NEWKEY" '&@crlf&@crlf)
ConsoleWrite('           Example : BRSH agentkeychange 10.3.125.3 "QWEASD123456789" '&@crlf&@crlf&@crlf)


ConsoleWrite("AGENT File Transfer;"&@crlf)
ConsoleWrite('           Usage   : BRSH AGENTSENDFILE <PCNAME(or IP)> "file location and file name to be send" "File destination to be saved on remote pc" '&@crlf)
ConsoleWrite('           Example1: BRSH agentsendfile 10.3.125.3 "C:\Run.bat" "C:\" '&@crlf)
ConsoleWrite('           Example2: BRSH agentsendfile 10.3.125.3 "C:\Test.txt" "D:\" '&@crlf&@crlf&@crlf)
ConsoleWrite("Author: BAHADIR KAAN UYSAL"&@crlf)
Exit
endif

if ubound($cmdline)=2 or ubound($cmdline)=1 Then
ConsoleWrite(@crlf&@crlf&@crlf&@crlf)

ConsoleWrite("Remote Machines In Workgroup, User Pass Authentication:"&@crlf)
ConsoleWrite('           Usage   : BRSH <PCNAME(or IP)> <username> <password> "command"'&@crlf)
ConsoleWrite('           Example : BRSH 10.3.125.3 administrator 123456 "notepad.exe"'&@crlf&@crlf&@crlf)

ConsoleWrite("For Authorized Users and Domain Admins:"&@crlf)
ConsoleWrite('           Usage   : BRSH <PCNAME(or IP)> "command"'&@crlf)
ConsoleWrite('           Example : BRSH 10.3.125.3 "notepad.exe"'&@crlf)
ConsoleWrite("           Note    : Use command in double quates if command contains spaces"&@crlf)
ConsoleWrite('           Example : BRSH 10.3.125.3 "D:\SOME FOLDER\notepad.exe" '&@crlf&@crlf&@crlf)


ConsoleWrite('AGENT Usage , Assuming Remote PC/Server has  "BRSHAGENT" service running. '&@crlf)
ConsoleWrite('           Usage   : BRSH AGENT <PCNAME(or IP)> "Command" '&@crlf)
ConsoleWrite('           Example : BRSH AGENT 10.3.125.3 "Net Start" '&@crlf&@crlf&@crlf)

ConsoleWrite("AGENT Authentication Key Change;"&@crlf)
ConsoleWrite('           Usage   : BRSH AGENTKEYCHANGE <PCNAME(or IP)> "NEWKEY" '&@crlf&@crlf)
ConsoleWrite('           Example : BRSH agentkeychange 10.3.125.3 "QWEASD123456789" '&@crlf&@crlf&@crlf)


ConsoleWrite("AGENT File Transfer;"&@crlf)
ConsoleWrite('           Usage   : BRSH AGENTSENDFILE <PCNAME(or IP)> "file location and file name to be send" "File destination to be saved on remote pc" '&@crlf)
ConsoleWrite('           Example1: BRSH agentsendfile 10.3.125.3 "C:\Run.bat" "C:\" '&@crlf)
ConsoleWrite('           Example2: BRSH agentsendfile 10.3.125.3 "C:\Test.txt" "D:\" '&@crlf&@crlf&@crlf)
ConsoleWrite("Author: BAHADIR KAAN UYSAL"&@crlf)
Exit
endif


if $cmdline[1]="agent" Then
				if ubound($cmdline)=4 Then
							 TCPStartup()

							if stringinstr(string($cmdline[2]),".") Then
							$agentip=$cmdline[2]
						Else
							$agentip=TCPNameToIP($cmdline[2])
							endif

							$agentcommand=$cmdline[3]
							consolewrite("Remote PC Agent IP:"&$agentip&@crlf)
							consolewrite("Command:"&$CmdLine[3]&@crlf)



								$socket = TCPConnect($agentip, $port)
								If @error Then
									consolewrite("Connection Error , Could not connect to the port."&@crlf& "Please be sure that agent is running on the remote side. Exiting."&@crlf)
									Exit
								EndIf

								AGENTCONNECTION()
					Else

					ConsoleWrite('           Usage   : BRSH AGENT <PCNAME(or IP)> "Command" '&@crlf)

                    endif

endif


if $cmdline[1]="agentkeychange" Then

	           if ubound($cmdline)=4 Then
							TCPStartup()

							if stringinstr(string($cmdline[2]),".") Then
							$agentip=$cmdline[2]
							Else
							$agentip=TCPNameToIP($cmdline[2])
							endif

							$agentcommand=$cmdline[3]
							consolewrite("Remote PC Agent IP:"&$agentip&@crlf)
							consolewrite("New Authentication Key:"&$CmdLine[3]&@crlf)



							$socket = TCPConnect($agentip, $port)
							If @error Then
									consolewrite("Connection Error , Could not connect to the port."&@crlf& "Please be sure that agent is running on the remote side. Exiting."&@crlf)
								Exit
							EndIf

							AGENTCONNECTION()
						Else
							ConsoleWrite('           Usage   : BRSH AGENTKEYCHANGE <PCNAME(or IP)> "NEWKEY" '&@crlf)
                endif

		Else

endif


   if $cmdline[1]="agentsendfile" Then
	if ubound($cmdline)=5 Then
				   Local $size = FileGetSize($CmdLine[3])

				   $size=$size/1048576

		if $size < 5 then

		            TCPStartup()

					if stringinstr(string($cmdline[2]),".") Then
					$agentip=$cmdline[2]
					Else
					$agentip=TCPNameToIP($cmdline[2])
					endif

					$agentcommand=$cmdline[3]

                    ;ConsoleWrite(ubound($cmdline))


								consolewrite("Remote PC Agent IP:"&$agentip&@crlf)
								consolewrite("File Location:"&$CmdLine[3]&@crlf)
								consolewrite("Destination:"&$CmdLine[4]&@crlf)
								global $filelocation=$CmdLine[3]
								global $destination =$CmdLine[4]



								$socket = TCPConnect($agentip, $port)
								If @error Then
									consolewrite("Connection Error , Could not connect to the port."&@crlf& "Please be sure that agent is running on the remote side. Exiting."&@crlf)
									Exit
								EndIf

								AGENTCONNECTION()


		Else
               consolewrite("Can not send file.File size has to be smaller than 5MB")
		endif
							Else
							ConsoleWrite('           Usage   : BRSH AGENTSENDFILE <PCNAME(or IP)> "file location and file name to be send" "File destination to be saved on the remote pc" '&@crlf)

					endif
endif





						if ubound($cmdline)=3 Then
							if $cmdline[1]="agentsendfile" or $cmdline[1]="agentkeychange" or $cmdline[1]="agent" then
								else
								$1=$cmdline[1]
								$2=$cmdline[2]
								consolewrite("Remote PC:"&$CmdLine[1]&@crlf)
								consolewrite("Command:"&$CmdLine[2]&@crlf)
								RemoteExecute($1,$2)
							endif
						EndIf

						if ubound($cmdline)=5 then
							    if $cmdline[1]="agentsendfile" or $cmdline[1]="agentkeychange" or $cmdline[1]="agent" then
								else
												 $1=$cmdline[1]
												 $2=$cmdline[2]
												 $3=$cmdline[3]
												 $4=$cmdline[4]
											consolewrite("Remote PC:"&$CmdLine[1]&@crlf)
											consolewrite("Username:"&$CmdLine[2]&@crlf)
											consolewrite("Password:"&$CmdLine[3]&@crlf)
											consolewrite("Command:"&$CmdLine[4]&@crlf)
											$strUsername=$2
											$strPassword=$3
											RemoteExecute($1,$4)
								endif
						endif


func RemoteExecute($strComputer,$CommandLine)

   Local $objWMIService, $objProcess, $objProgram

if $strUsername<>"**" and $strPassword<>"**" then

    $objSWbemLocator = ObjCreate("WbemScripting.SWbemLocator")
    If @error Then
        ConsoleWrite("Error: failed to create $objSWbemLocator"&@crlf)
        Exit
    EndIf


    $objWMI = $objSWbemLocator.ConnectServer($strComputer, "root\cimv2", $strUsername, $strPassword)    ; This works for remote pc if pass actual credentials and works for local if pass null credentials
    If @error  Then
        ConsoleWrite("Error: failed to create $objWMI"&@crlf)
        Exit
    EndIf

Else
	$objWMI = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
endif

If @error Then
   ConsoleWrite("Could not make a remote connection,Please Check Username&Password also remote machine's WMI service functionality."&@crlf)
   exit
endif






$objWMI.Security_.ImpersonationLevel = 3
$objProcess = $objWMI.Get("Win32_Process")
$objProgram = $objProcess.Methods_("Create").InParameters.SpawnInstance_
$objProgram.CommandLine = $CommandLine
$objOutParams = $objWMI.ExecMethod("Win32_Process", "Create", $objProgram)
$PID = $objOutParams.ProcessId
$ReturnValue = $objOutParams.ReturnValue


Switch $ReturnValue
        Case 0
            ConsoleWrite("The remote command completed successfully"&@crlf)
			ConsoleWrite("Started Process PID="&$PID)
        Case 2
            ConsoleWrite("Answer from Remote Computer: Access denied")
        Case 3
            ConsoleWrite("Insufficient privilege to launch remote command")
        Case 8
            ConsoleWrite("Unknown failure")
        Case 9
            ConsoleWrite("Path not found")
        Case 21
           ConsoleWrite ("Invalid parameter passed to script: " & @CRLF & _
                        "$strComputer: " & $strComputer & @CRLF & _
                        "$CommandLine: " & $CommandLine)
        Case Else
           ConsoleWrite ("Unknown error" & @CRLF & _
                        "ResultCode: " & $ReturnValue)
    EndSwitch
endfunc


#cs

Func RemoteExecute($strProgToRun)

    Local $objWMIService, $objProcess, $objProgram

    $objSWbemLocator = ObjCreate("WbemScripting.SWbemLocator")
    If Not IsObj($objSWbemLocator) Then
        MsgBox(0, "Error", "Error: failed to create $objSWbemLocator")
        Exit
    EndIf

    $objWMI = $objSWbemLocator.ConnectServer($strComputer, "root\cimv2", $strUsername, $strPassword)    ; This works for remote pc if pass actual credentials and works for local if pass null credentials
    If Not IsObj($objWMI) Then
        MsgBox(0, "Error", "Error: failed to create $objWMI")
        Exit
    EndIf

    $objWMI.Security_.ImpersonationLevel = 3

    $objProcess = $objWMI.Get("Win32_Process")

    $objProgram = $objProcess.Methods_("Create").InParameters.SpawnInstance_
    $objProgram.CommandLine = $strProgToRun

    $objWMI.ExecMethod("Win32_Process", "Create", $objProgram)                                          ; Execute the program now at the command line.

EndFunc     ; End of Func RemoteExecute()

;*****************************
#ce



Func AGENTCONNECTION()

	; Sends the current user's name and the computers name.
	;MsgBox(0, "Test 2", "Sending Username and Computername, the packet being sent is: " & @CRLF & @CRLF & $PacketPCI & @UserName & "@" & @ComputerName & $PacketEND)
	TCPSend($socket, $PacketPCI & @UserName & "@" & @ComputerName & $PacketEND)

	; Sends a plain message.
	;MsgBox(0, "Test 1", "Sending a plain text message, the packet being send is: " & @CRLF & @CRLF & $PacketMSG & "net start" & $PacketEND);"This is a test message."
	if $cmdline[1]="agent" then
	TCPSend($socket, $PacketMSG & $agentcommand & $PacketEND);"This is a test message."
	endif

    if $cmdline[1]="agentkeychange" Then
	TCPSend($socket, $PacketKEY & $agentcommand & $PacketEND);"This is a test message."
	endif


   if $cmdline[1]="agentsendfile" Then
					; Sends Base64 converted Globe.png
					;MsgBox(0, "Test 3", "Sending Globe.png, the packet being sent is too large to show, but would be: " & @CRLF & @CRLF & $PacketPNG & "Base64_converted_binary" & $PacketEND)
					$File = $filelocation;@ScriptDir & "\" & "BKmigros.pdf"
					$extension=Stringinstr($File ,"\",0,-1)
					$extension=$extension+1
					$max=StringLen($file)
					$extensionstring=stringmid($File,$extension,$max)
					$extensionstring=$PacketEXT & $extensionstring & $PacketEND
					$destination=$PacketDEST & $destination & $PacketEND
					TCPSend($socket,$extensionstring)
					TCPSend($socket,$destination)


								Local $sBuff, $iFileOp,$sRecv

								$iFileOp = FileOpen($File, 16)
								If @error Then Return 0
								$sBuff = FileRead($iFileOp)
								FileClose($iFileOp)




					$DataCOMP=_LZNTCompress($sBuff)
					consolewrite("Sending File Please Wait.."&@crlf)
					;TCPSend($socket,$PacketPNG)

					$DataCOMP=$PacketPNG&$DataCOMP&$PacketEND

					$Length = StringLen($DataCOMP)
					For $i = 1 To $Length Step 150000
						Sleep(5)
						;consolewrite($i&@crlf)
						TCPSend($socket, StringMid($DataComp, $i, 150000))
					Next
                    ;TCPSend($socket,$PacketEND)

                               ; TCPSend($socket,$PacketPNG)
								;While BinaryLen($sBuff)
								;	$iSendReturn = TCPSend($socket,$sBuff)
								;	If @error Then Return 0

								;	$sBuff = BinaryMid ($sBuff, $iSendReturn + 1, BinaryLen ($sBuff) - $iSendReturn)
								;WEnd
                               ; TCPSend($socket,$PacketEND)
    endif


	;Local $starttime = _Timer_Init()
	While 1
		;ToolTip(_Timer_Diff($starttime))
	_ReceivePackets()
    _Sleep(1000, $NTDLL)
		;$currenttime=Int(_Timer_Diff($starttime))/1000
		;msgbox(0,"",$currenttime)
		;if $currenttime>60 Then
			;msgbox(0,"","selam 60saniyeyi geçti")
		;	exitloop
		;endif
		if $isanyvaliddata=1 Then
			ExitLoop
		endif
	WEnd



	; Sends the current user's name and the computers name.
	;MsgBox(0, "Test 2", "Sending Username and Computername, the packet being sent is: " & @CRLF & @CRLF & $PacketPCI & @UserName & "@" & @ComputerName & $PacketEND)
	;TCPSend($socket, $PacketPCI & @UserName & "@" & @ComputerName & $PacketEND)


EndFunc

Func _SocketToIP($SHOCKET) ; IP of the connecting client.
	$isanyvaliddata=0
	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	Local $aRet = DllCall($WS2_32, "int", "getpeername", "int", $SHOCKET, "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall($WS2_32, "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc   ;==>_SocketToIP

func _ReceivePackets()
$RecvPacket = TCPRecv($socket, $PacketSize) ; Attempt to receive data
		If @error Then ; If there was an error, the connection is probably down.
			_CheckBadConnection() ; So, we call the function to check.

		EndIf

;ConsoleWrite("Alinan Paket = "&$RecvPacket&@crlf)
         ;$Connection[$i][2]=""
		If $RecvPacket <> "" Then ; If we got data...
			$Connection[$i][2] &= $RecvPacket ; Add it to the packet buffer.
			;ConsoleWrite(">> New Packet from " & _SocketToIP($socket) & @CRLF & "+> " & $RecvPacket & @CRLF & @CRLF) ; Let us know we got a packet in scite.
		EndIf

          ;ConsoleWrite("$Connection[$i][2]=="&$Connection[$i][2]&@crlf)
          ;ConsoleWrite("$PacketKEYNotMatch=="&$PacketKEYNotMatch&@crlf)
			  if StringInStr($Connection[$i][2],$PacketKEYNotMatch) Then
                  consolewrite("Authentication key is invalid.Please check your key." & @CRLF)
			      Exit
              endif



		If StringInStr($Connection[$i][2], $PacketEND) Then ; If we received the end of a packet, then we will process it.
			Local $RawPackets = $Connection[$i][2] ; Transfer all the data we have to a new variable.
			Local $LengthOfPAcketEnd = StringLen($PacketEND)
			Local $PrefixSuffixLength = 18 + $LengthOfPAcketEnd
			Local $FirstPacketLength = StringInStr($RawPackets, $PacketEND) - $PrefixSuffixLength ; Get the length of the packet, and subtract the length of the prefix/suffix.
			Local $PacketType = StringLeft($RawPackets, 18) ; Copy the first 18 characters, since that is where the packet type is put.
			$LengthOfPAcketEnd = $LengthOfPAcketEnd - 1
			Local $CompletePacket = StringMid($RawPackets, 19, $FirstPacketLength + $LengthOfPAcketEnd) ; Extract the packet.
			Local $PacketsLeftover = StringTrimLeft($RawPackets, $FirstPacketLength + $PrefixSuffixLength + $LengthOfPAcketEnd) ; Trim what we are using, so we only have what is left over. (any incomplete packets)
			$Connection[$i][2] = $PacketsLeftover ; Transfer any leftover packets back to the buffer.
			; Writes some stuff to the console for debugging.
			;ConsoleWrite(">> Full packet found!" & @CRLF)
			;ConsoleWrite("+> Type: " & $PacketType & @CRLF)
			;ConsoleWrite("+> Packet: " &@crlf& $CompletePacket & @CRLF)

			if $PacketType=$PacketMSG Then
				ConsoleWrite(@crlf& $CompletePacket & @CRLF)
				exit;ConsoleWrite("Do not forget to change BRSH Client Authentication Key to manage this agent." & @CRLF)
			endif

			if $PacketType=$PacketKEY Then
				ConsoleWrite(@crlf& $CompletePacket & @CRLF)
				ConsoleWrite("Do not forget to change BRSH Client Authentication Key to manage this agent." & @CRLF)
			Else

				ConsoleWrite(@crlf& $CompletePacket & @CRLF)

			endif

			;ConsoleWrite("!> Left in buffer: " & $Connection[$i][2] & @CRLF & @CRLF)
			; Since we extracted a packet, we will send it to the processor.
			;_ProcessFullPacket($CompletePacket, $PacketType, $i)
			$isanyvaliddata=1

			Else
		EndIf
	endfunc

Func _Sleep($MicroSeconds, $NTDLL = "ntdll.dll") ; Faster sleep than Sleep().
	Local $DllStruct
	$DllStruct = DllStructCreate("int64 time;")
	DllStructSetData($DllStruct, "time", -1 * ($MicroSeconds * 10))
	DllCall($NTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", DllStructGetPtr($DllStruct))
EndFunc   ;==>_Sleep



Func _CheckBadConnection()

TCPSend($Connection[$i][0], "CONNECTION_TEST") ; Send a test packet
		If @error Then ; If the send fails..
			TCPCloseSocket($Connection[$i][0]) ; Close the socket,
			$Connection[$i][0] = -"" ; Set socket to nothing,
			;$Connection[$i][1] = "" ; Empty gui control,
			;ContinueLoop ; and continue checking for more bad connections.
		EndIf

endfunc

Func _ProcessFullPacket($CompletePacket, $PacketType, $ArraySlotNumber)
	Switch $PacketType
		Case $PacketMSG
			;TrayTip("New message from " & _SocketToIP($Connection[$ArraySlotNumber][0]), $CompletePacket, 5, 1)
			;MsgBox(0, "", $CompletePacket)
			Dim $DOS = "", $Message = '' ;; added "= ''" for show only.

			ConsoleWrite($CompletePacket & @CRLF)

			;MsgBox(0, "New Message", "Message From " & _SocketToIP($Connection[$ArraySlotNumber][0]) & @CRLF & @CRLF & $CompletePacket)
		Case $PacketPNG
			If StringLen($CompletePacket) > 1 Then ; This check must be added because _Base64Decode() will crash the script if it gets empty input.
				;Local $Base64DecodedToPNGBinary = _Base64Decode($CompletePacket)
				Local $DateTime = "[" & @MON & "-" & @MDAY & "-" & @YEAR & "] [" & @HOUR & "-" & @MIN & "-" & @SEC & "]"
				Local $File = @ScriptDir & "\" & $DateTime & ".png"
				Local $FileOpen = FileOpen($File, 2)
				;FileWrite($FileOpen, $Base64DecodedToPNGBinary)
				FileClose($FileOpen)
				ShellExecute($File)
			Else
				MsgBox(16, "Error", "Received empty PNG packet.")
			EndIf
		Case $PacketPCI
			Local $PacketPCISplit = StringSplit($CompletePacket, "@", 1)
			Local $UserName = $PacketPCISplit[1]
			Local $CompName = $PacketPCISplit[2]
			GUICtrlSetData($Connection[$ArraySlotNumber][1], "|||" & $UserName & "|" & $CompName)

	EndSwitch
EndFunc   ;==>_ProcessFullPacket



; #FUNCTION# ;===============================================================================
;
; Name...........: _LZNTDecompress
; Description ...: Decompresses input data.
; Syntax.........: _LZNTDecompress ($bBinary)
; Parameters ....: $vInput - Binary data to decompress.
; Return values .: Success - Returns decompressed binary data.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Error decompressing.
; Author ........: trancexx
; Related .......: _LZNTCompress
; Link ..........; <a href='http://msdn.microsoft.com/en-us/library/bb981784.aspx' class='bbc_url' title='External link' rel='nofollow external'>http://msdn.microsoft.com/en-us/library/bb981784.aspx</a>
;
;==========================================================================================
Func _LZNTDecompress($bBinary)

	If Not IsBinary($bBinary) Then $bBinary = Binary($bBinary)


    Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
    DllStructSetData($tInput, 1, $bBinary)

    Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer

    Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", _
            "ushort", 2, _
            "ptr", DllStructGetPtr($tBuffer), _
            "dword", DllStructGetSize($tBuffer), _
            "ptr", DllStructGetPtr($tInput), _
            "dword", DllStructGetSize($tInput), _
            "dword*", 0)

    If @error Or $a_Call[0] Then
        Return SetError(1, 0, "") ; error decompressing
    EndIf

    Local $tOutput = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($tBuffer))

    Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_LZNTDecompress



; #FUNCTION# ;===============================================================================
;
; Name...........: _LZNTCompress
; Description ...: Compresses input data.
; Syntax.........: _LZNTCompress ($vInput [, $iCompressionFormatAndEngine])
; Parameters ....: $vInput - Data to compress.
;                  $iCompressionFormatAndEngine - Compression format and engine type. Default is 2 (standard compression). Can be:
;                  |2 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_STANDARD
;                  |258 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_MAXIMUM
; Return values .: Success - Returns compressed binary data.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Error determining workspace buffer size.
;                  |2 - Error compressing.
; Author ........: trancexx
; Related .......: _LZNTDecompress
; Link ..........; <a href='http://msdn.microsoft.com/en-us/library/bb981783.aspx' class='bbc_url' title='External link' rel='nofollow external'>http://msdn.microsoft.com/en-us/library/bb981783.aspx</a>
;
;==========================================================================================
Func _LZNTCompress($vInput, $iCompressionFormatAndEngine = 2)

    If Not ($iCompressionFormatAndEngine = 258) Then
        $iCompressionFormatAndEngine = 2
    EndIf

    Local $bBinary = Binary($vInput)

    Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
    DllStructSetData($tInput, 1, $bBinary)

    Local $a_Call = DllCall("ntdll.dll", "int", "RtlGetCompressionWorkSpaceSize", _
            "ushort", $iCompressionFormatAndEngine, _
            "dword*", 0, _
            "dword*", 0)

    If @error Or $a_Call[0] Then
        Return SetError(1, 0, "") ; error determining workspace buffer size
    EndIf

    Local $tWorkSpace = DllStructCreate("byte[" & $a_Call[2] & "]") ; workspace is needed for compression

    Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer

    Local $a_Call = DllCall("ntdll.dll", "int", "RtlCompressBuffer", _
            "ushort", $iCompressionFormatAndEngine, _
            "ptr", DllStructGetPtr($tInput), _
            "dword", DllStructGetSize($tInput), _
            "ptr", DllStructGetPtr($tBuffer), _
            "dword", DllStructGetSize($tBuffer), _
            "dword", 4096, _
            "dword*", 0, _
            "ptr", DllStructGetPtr($tWorkSpace))

    If @error Or $a_Call[0] Then
        Return SetError(2, 0, "") ; error compressing
    EndIf

    Local $tOutput = DllStructCreate("byte[" & $a_Call[7] & "]", DllStructGetPtr($tBuffer))

    Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_LZNTCompress


Func _DecToBin($dec)
    if (not IsInt($dec)) or ($dec < 0) Then return -1
    $bin = ""
    If $dec=0 Then Return "0"
    While $dec<>0
        $bin= BitAND ($dec, 1)&$bin
        $dec = BitShift ( $dec,1 )
    WEnd
    Return $bin
EndFunc

Func _BinToDec($bin)
     if (not IsString($bin))  Then return -1
     $end=StringLen($bin)
     $dec=0
     for $cpt=1 to $end
         $char=stringmid($bin,$end+1-$cpt,1)
         Select
         case $char="1"
            $dec=BitXOR($dec,bitshift(1,-($cpt-1)))
        Case $char="0"
        ; nothing
        Case Else
        ;error
            return -1
        EndSelect
    Next
    return $dec
EndFunc

Func _CharToBin($char)
    If (Not IsString($char)) Or (StringLen($char)<>1) Then Return -1
    $val=asc($char)
    Return _DecToBin($val)
EndFunc

Func _BinToChar($bin)
    If (Not IsString($bin)) Or (StringLen($bin)<1) Or (StringLen($bin)>8) Then Return -1
    $dec=_BinToDec($bin)
    if $dec<>-1 Then Return chr($dec)
    return -1
EndFunc
