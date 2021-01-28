#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <array.au3>
#include <inet.au3>
#include <String.au3>
#Include <File.au3>
#include <GuiListView.au3>
#include <Date.au3>
Opt('MustDeclareVars', 0)

;==============================================
;==============================================
;SERVER!! Start Me First !!!!!!!!!!!!!!!
;==============================================
;==============================================





    Global $szIPADDRESS = @IPAddress1
    Global $nPORT = "5900"
    Global $MainSocket, $GOOEY, $szIP_Accepted1, $szIP_Accepted2,  $Free_socket, $msg, $recv1, $recv2, $Track, $hListView
    Global $edit
    Global $server_to_adr
    Global $server_to_port = "5900"

    Global Const $MaxConnection = 100; Maximum user connections
    Global $ConnectedSocket1[ ($MaxConnection + 1) ]
    Global $ConnectedSocket2[ ($MaxConnection + 1) ]

    Dim $vnc_servers_tmp
    _FileReadToArray("vncList.txt",$vnc_servers_tmp)
    Global $vnc_servers
    Dim $vnc_servers[UBound($vnc_servers_tmp)][2]

For $Track=1 to $vnc_servers_tmp[0] Step 1
$vnc_servers[$Track][0] = $vnc_servers_tmp[$Track]
$vnc_servers[$Track][1] = -1
Next



;~ _ArrayDisplay($vnc_servers, "f")



Example()

Func Example()
   ; Set Some reusable info
   ; Set your Public IP address (@IPAddress1) here.
;   Local $szServerPC = @ComputerName
;   Local $szIPADDRESS = TCPNameToIP($szServerPC)


; Null all socets
;---------------------------------------------
    For $Track = 0 To $MaxConnection Step 1
        $ConnectedSocket1[$Track] = -1
        $ConnectedSocket2[$Track] = -1
    Next
;--------------------------------------------


   ; Start The TCP Services
   ;==============================================
    TCPStartup()

   ; Create a Listening "SOCKET".
   ;   Using your IP Address and Port 33891.
   ;==============================================

  $MainSocket = TCPListen($szIPADDRESS, $nPORT)

   ; If the Socket creation fails, exit.
    If $MainSocket = -1 Then Exit


   ; Create a GUI for messages
   ;==============================================
    $GOOEY = GUICreate("My Server (IP: " & $szIPADDRESS & ")", 800, 200)
    $edit = GUICtrlCreateEdit("", 10, 10, 480, 180)
    $hListView = GUICtrlCreateListView("", 490, 10, 300, 180)
        _GUICtrlListView_AddColumn($hListView, "VNC Server IP", 190)
        _GUICtrlListView_AddColumn($hListView, "socket", 70)
            _GUICtrlListView_AddArray($hListView, $vnc_servers)
    GUISetState()


   ; Initialize a variable to represent a connection
   ;==============================================
;~     $ConnectedSocket1 = -1
;~     $ConnectedSocket2 = -1



   ; GUI Message Loop
   ;==============================================
    While 1

       ;Wait for and Accept a connection
   ;==============================================
    $Free_socket = SocketSearch()

$ConnectedSocket1[$Free_socket] = TCPAccept($MainSocket)

If $ConnectedSocket1[$Free_socket] <> -1 Then
    ;Check socket  usage
;~         Scan_sockets()
        $server_to_adr = find_vnc($Free_socket)
    ; Connect to other host whre to send recieved data
        $ConnectedSocket2[$Free_socket] = TCPConnect($server_to_adr, $server_to_port)
    ; Get IP of client connecting
        $szIP_Accepted1 = SocketToIP($ConnectedSocket1[$Free_socket])
        $szIP_Accepted2 = SocketToIP($ConnectedSocket2[$Free_socket])
Add_msg("User conected from IP: "&$szIP_Accepted1& " to IP: "&$szIP_Accepted2)
Add_msg("Using socket: " &$Free_socket)


AdlibEnable("Gui_update", 1000)


;~ _ArrayDisplay($vnc_servers, "servers")
EndIf

        $msg = GUIGetMsg()

       ; GUI Closed
       ;--------------------
        If $msg = $GUI_EVENT_CLOSE Then ExitLoop


For $Track = 0 To $MaxConnection Step 1
    If $ConnectedSocket1[$Track] <> - 1 Then

    ; Try to receive (up to) 2048 bytes
       ;----------------------------------------------------------------
        $recv1 = TCPRecv($ConnectedSocket1[$Track], 2048)
       ; If the receive failed with @error then the socket has disconnected
       ;----------------------------------------------------------------
;~         If @error Then ExitLoop
       ; Try to receive (up to) 2048 bytes
       ;----------------------------------------------------------------
        $recv2 = TCPRecv($ConnectedSocket2[$Track], 2048)
       ; If the receive failed with @error then the socket has disconnected
       ;----------------------------------------------------------------
;~         If @error Then ExitLoop

       ; Update the edit control with what we have received
       ;----------------------------------------------------------------
        Local $ret
        If $recv1 <> "" Then
        $ret = TCPSend($ConnectedSocket2[$Track], $recv1)
;~         If @error Or $ret < 0 Then openSocket($Track)
        EndIf

        If $recv2 <> "" Then
        $ret = TCPSend($ConnectedSocket1[$Track], $recv2)
;~         If @error Or $ret < 0 Then openSocket($Track)
        EndIf

;~         If $ConnectedSocket1[$Track] = -1 Then
;~         TCPCloseSocket($ConnectedSocket1[$Track])
;~         Add_msg("User disconected " & SocketToIP($ConnectedSocket2[$Track]))
;~         EndIf
    EndIf

Next

WEnd

;~ 192.168.1.135





;~     Add_msg("Shudown..")
;~     TCPShutdown()
EndFunc  ;==>Example


Func find_vnc($SHOCKET)
    Local $Trackm
For $Trackm=1 to $vnc_servers_tmp[0] Step 1
    if $vnc_servers[$Trackm][1] = -1 Then
    $vnc_servers[$Trackm][1] = $SHOCKET
    Return $vnc_servers[$Trackm][0]
    EndIf
Next

EndFunc




Func openSocket($SHOCKETm)
    Local $iIndex , $Trackg
        Add_msg("User disconected Socket: " &$SHOCKETm& " IP: "& SocketToIP($ConnectedSocket1[$SHOCKETm]))
    TCPCloseSocket($ConnectedSocket2[$SHOCKETm])
    TCPCloseSocket($ConnectedSocket1[$SHOCKETm])
        $ConnectedSocket1[$SHOCKETm] = -1
        $ConnectedSocket2[$SHOCKETm] = -1

For $Trackg = 1 to UBound($vnc_servers)-1
			ConsoleWrite("Track: "&$Trackg&"  "&$vnc_servers[$Trackg][1] &" = "& $SHOCKETm &""&@CRLF)
	If $vnc_servers[$Trackg][1] = $SHOCKETm Then
		ConsoleWrite("OK"&@CRLF)
		Add_msg("Server sucesfuly found VNC server to free up for disconected socket" & $Trackg)
		Add_msg("Array NO: " & $Trackg)
		$vnc_servers[$Trackg][1] = -1
;~ 		Break
	EndIf

Next


;~     $iIndex = _ArraySearch($vnc_servers, $SHOCKETm, 0, 0, 0, 1, 1)
;~     If @error Then
;~         Add_msg("Cand find server to free up for disconected socket" & $SHOCKETm)
;~     Else
;~         $vnc_servers[$iIndex][1] = -1
;~         Add_msg("Server sucesfuly found VNC server to free up for disconected socket" & $SHOCKETm)
;~ 		Add_msg("Array NO: " & $iIndex)
;~     EndIf

EndFunc

Func Scan_sockets()
;~     Add_msg("Socket scandig start")
    Local $ret, $Trackp
    For $Trackp = 0 To $MaxConnection Step 1
    if $ConnectedSocket1[$Trackp] <> -1 Then
		$ret = TCPSend($ConnectedSocket1[$Trackp], "")
        Select
			Case @error
				openSocket($Trackp)
			Case $ret < 0
				openSocket($Trackp)
		EndSelect

		$ret = TCPSend($ConnectedSocket2[$Trackp], "")
        Select
			Case @error
				openSocket($Trackp)
			Case $ret < 0
				openSocket($Trackp)
		EndSelect
    EndIf
	Next
;~     Add_msg("Socket scandig end")
EndFunc


; Function to return IP Address from a connected socket.
;----------------------------------------------------------------------
Func SocketToIP($SHOCKET)
    Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, _
            "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc  ;==>SocketToIP

;Function to add text to gui text area
;----------------------------------------------------------------------
Func Add_msg($msg)
    Global $edit
    GUICtrlSetData($edit, _NowTime() & " >  " & $msg & @CRLF & GUICtrlRead($edit))
EndFunc;==>Add_msg


Func SocketSearch()
    For $Track = 0 To $MaxConnection Step 1
        If $ConnectedSocket1[$Track] = -1 Then Return $Track
    Next
EndFunc  ;==>SocketSearch

Func Gui_update()
	Scan_sockets()
	    _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListView)); items added with UDF function can be deleted using UDF function
    _GUICtrlListView_AddArray($hListView, $vnc_servers)
EndFunc
