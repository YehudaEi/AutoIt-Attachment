;Edited version of kreatorul's chat server
#region INCLUDES
#include<GUIConstants.au3>
#include<Array.au3>
#include<String.au3>
#include<Misc.au3>
#include<GUIList.au3>
#include<File.au3>
#endregion Includes
;xxxxxxxxxxxxxx
#region Vars 
Global $CSock[1]
Dim $ConnectedSocket = -1
Dim $MainSocket
Global $USERS[1]
$CSock[0] = 0
$socket = -1
$p_info="%I^N^F^O%"
$p_msg="%M^S^G%"
$p_user="%U^S^E^R%"
$ret=-1


#endregion Vars
;xxxxxxxxxxxxxx
Opt("OnExitFunc" , "OnQuit")
;xxxxxxxxxxxxxx
If FileExists(@scriptdir & "/settings.ini") Then 
	Sleep(10)
Else
	_FileCreate(@scriptdir & "/settings.ini")
EndIf
$nick=FileReadLine(@scriptdir & "/settings.ini", 1)
If $nick = "" Then $nick = InputBox("K Chat Program","Enter a nickname to use when chatting")
If @error=1 Then
	Exit
EndIf
While 1
	If @error=1 Then Exit
	If $nick = "" Then 
		$nick=InputBox("K Chat Program", "Please enter a nickname")
	Else
		_FileWriteToLine(@scriptdir & "/settings.ini", 1, $nick, 1)
		ExitLoop
	EndIf
WEnd
;;;;;;;;;;;;;;;;;;;;
If FileReadLine		(@scriptdir & "/settings.ini", 2) = "" Then
	_FileWriteToLine(@scriptdir & "/settings.ini", 2, "000000", 1)
	_FileWriteToLine(@scriptdir & "/settings.ini", 3, "Arial", 1)
	_FileWriteToLine(@scriptdir & "/settings.ini", 4, "9", 1)
	_FileWriteToLine(@scriptdir & "/settings.ini", 5, "400", 1)
	_FileWriteToLine(@scriptdir & "/settings.ini", 6, "1", 1)
EndIf

$f=FileReadLine(@scriptdir & "/settings.ini", 2)
$n=FileReadLine(@scriptdir & "/settings.ini", 3)
$s=FileReadLine(@scriptdir & "/settings.ini", 4)
$w=FileReadLine(@scriptdir & "/settings.ini", 5)
$a=FileReadLine(@scriptdir & "/settings.ini", 6)
;;;;;;;;;;;;;;;;;
$server=0
$port = "3333"
$ipaddress = InputBox("IpAdress", "Enter the ip to connect to, blank for server!",@IPAddress1)
If @error=1 Then Exit
If $ipaddress = "" Then
	$server=1
	HotKeySet("^P" , "display")
	$ipaddress = @ipaddress1
	$MainSocket = _TCPCreateMainListeningSocket($ipaddress, $port, 100)
	If @ERROR Or $MainSocket = -1 Then Exit
Else
	TCPStartup()
EndIf

;gui
$gui = GUICreate($nick & "'s Chat",580,250)
If $server=1 Then
	WinSetTitle($nick & "'s Chat" ,"" , $nick & "'s Chat (Server)")
Else
	WinSetTitle($nick & "'s Chat" ,"" , $nick & "'s Chat (Client)")
EndIf
$menu=GuiCtrlCreateMenu("Program")
$set=GuiCtrlCreateMenuItem("Settings", $menu)
$menu1=GuiCtrlCreateMenuItem("Exit", $menu)
$menu3=GuiCtrlCreateMenu("Help")
$menu4=GuiCtrlCreateMenuItem("About", $menu3)
$userlist=GuiCtrlCreateLabel("UserList:", 485, 5)
$bsend = GUICtrlCreateButton("Send",380,145,60,80,$BS_DEFPUSHBUTTON)
$list=GuiCtrlCreateList($nick, 445, 22, 125, 213)
$edit = GUICtrlCreateEdit("",5,5,435,130,BitOR($ES_AUTOVSCROLL,$WS_VSCROLL,$ES_READONLY))
GUICtrlSetFont(-1,$s,$w,$a,$n)
GuiCtrlSetColor(-1, $f)
GuiCtrlSetBkColor(-1, 0xffffff)
$input = GUICtrlCreateEdit("",5,145,375,80,BitOR($WS_VSCROLL,$ES_AUTOVSCROLL,$ES_MULTILINE))
GUICtrlSetFont($input,$s,$w,$a,$n)
GuiCtrlSetColor($input, $f)
GUISetState()
GUICtrlSetState($input,$GUI_FOCUS)

$socket = TCPConnect(TcpNameToIp($ipaddress), $port)

If $socket < 0 Then 
	MsgBox(0,"Error","Could not connect to server")
	Exit
Else
	TCPSend($socket, $p_info&"Server: " & $nick & " is connected.")
EndIf

;;;LOOP;;;
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit
	If $msg = $menu1 Then Exit
	If $msg = $menu4 Then MsgBox(64, "About", 	"Simple Chat Program. Initial coding by Kreatorul, 2007. Contact: bal_dabac@yahoo.com"&@lf& _
												"Emproved by Nerd , m4dm4n.4_3v3r@yahoo.com")
	If $msg = $set Then
		$gui2=GuiCreate("Settings", 200, 100)
		$label=GuiCtrlCreateLabel("Nickname:", 5, 8)
		$ninput=GuiCtrlCreateInput("", 65, 5, 130)
		$label1=GuiCtrlCreateLabel("Chat Font:", 5, 41)
		$color=GuiCtrlCreateButton("Select", 65, 35, 130)
		$sett=GuiCtrlCreateButton("Ok", 65, 70, 70)
		GuiSetState()
	
		While 1
			$msgg=GuiGetMsg()
			If $msgg=$Gui_Event_Close Then
				GuIDelete($gui2)
				ExitLoop
			EndIf
			If $msgg=$color then 
				$font=_ChooseFont()
				If (@error) Then
					GuiCtrlSetColor($edit, $f)
					GuiCtrlSetColor($input, $f)
					GUICtrlSetFont($edit, $s, $w, $a, $n)
					GUICtrlSetFont($input, $s, $w, $a, $n)
				Else
					GuiCtrlSetColor($edit, $font[7])
					GuiCtrlSetColor($input, $font[7])
					GUICtrlSetFont($edit, $font[3], $font[4], $font[1], $font[2]) 
					GUICtrlSetFont($input, $font[3], $font[4], $font[1], $font[2]) 
					$s=$font[3]
					$n=$font[2]
					$w=$font[4]
					$a=$font[1]
					$f=$font[7]
					_FileWriteToLine(@scriptdir & "/settings.ini", 2, $font[7], 1)
					_FileWriteToLine(@scriptdir & "/settings.ini", 3, $font[2], 1)
					_FileWriteToLine(@scriptdir & "/settings.ini", 4, $font[3], 1)
					_FileWriteToLine(@scriptdir & "/settings.ini", 5, $font[4], 1)
					_FileWriteToLine(@scriptdir & "/settings.ini", 6, $font[1], 1)
				EndIf
			EndIf
			If $msgg=$sett Then
				If GuiCtrlRead($ninput) <> "" Then
					If $nick <> GuiCtrlReaD($ninput) Then
						_FileWriteToLine(@scriptdir & "/settings.ini", 1, GuiCtrlReaD($ninput), 1)
						TCPSend($socket, $p_msg&"Server: " & $nick & " changed name to " & GuiCtrlReaD($ninput) & ".")
						$nick=FileReadLine(@scriptdir & "/settings.ini", 1)
						GUICtrlSetData($input,"")
					EndIf
				EndIf
				GuiDelete($gui2)
				ExitLoop
				GUICtrlSetState($ninput,$GUI_FOCUS)
			EndIf
		Wend
	EndIf	
	$ConnectedSocket = TCPAccept($MainSocket)
    If @ERROR = 0 And $ConnectedSocket > -1 Then
        AddSocket($ConnectedSocket)
    EndIf

    If $CSock[0] > 0 Then
        $br = ""
        For $n = 1 to $CSock[0]
            $ret2 = TCPRecv($CSock[$n], 512)
            If @error <> 0 Then
                $br = $br & $n & @LF
            Else
				If StringInStr($ret2, "is connected.") And StringInStr($ret2 , $p_info) Then
					$asd=StringTrimLeft($ret2 , StringLen($p_info)+2)
					_ArrayAdd($USERS , StringTrimLeft(StringTrimRight($ret2,14), 17))
					$ulist=_ArrayToString($USERS,"|")
					Broadcast(StringTrimLeft($ret2,StringLen($p_info))&$p_user&$ulist);
				ElseIf StringInStr($ret2 , $p_msg) Then
					Broadcast($ret2)
				ElseIf StringInStr($ret2 , "is disconnected.") And StringInStr($ret2 , $p_info) Then
					Broadcast($ret2)
				EndIf
			EndIf
        Next
        If $br <> "" Then
            $br = StringSplit(StringTrimRight($br,1),@LF)
            For $n = 1 to $br[0]
                RemoveSocket(Int($br[$n]))
				_ArrayDelete($USERS , $br[$n]+1)
            Next
        EndIf
    EndIf
  	

	If $msg = $bsend Then
		If GUICtrlRead($input)<>"" Then
			$ret = TCPSend($socket, $p_msg&$nick & ": " & GUICtrlRead($input))
			If @ERROR Or $ret < 0 Then ExitLoop
			GUICtrlSetData($input,"")
		EndIf
		GUICtrlSetState($input,$GUI_FOCUS)
	EndIf
	
	$ret = TCPRecv($socket, 512)
	If @ERROR Or $ret < 0 Then ExitLoop
	If StringLen($ret) > 0 Then
		If StringInStr($ret , $p_msg) Then
			GUICtrlSetData($edit, GUICtrlRead($edit) & @CRLF & StringTrimLeft($ret,StringLen($p_msg)))
			GUICtrlSendMsg($edit, $EM_SCROLLCARET, 0, 0)
			
			If StringInStr($ret , " changed name to ") Then
				$aux=StringTrimLeft($ret , StringLen($p_msg))
				$aux=StringSplit($aux , " changed name to " , 1)
				$name1=StringTrimLeft($aux[1] , 8)
				$name2=StringTrimRight($aux[2] , 1)
				_GUICtrlListReplaceString($list , _GUICtrlListFindString($list , $name1) , $name2)
			EndIf
		EndIf
		If StringInStr($ret , $p_user) Then
			$ulist=StringSplit($ret , $p_user,1)
			GUICtrlSetData($edit, GUICtrlRead($edit) & @CRLF & $ulist[1])
			GUICtrlSendMsg($edit, $EM_SCROLLCARET, 0, 0)
			$usr=StringSplit($ulist[2] , "|",1)
			_GUICtrlListClear($list)
			For $i=1 To $usr[0]
				_GUICtrlListAddItem($list , $usr[$i])
			Next
			_GUICtrlListDeleteItem($list , 0)
		EndIf
		If StringInStr($ret , $p_info) Then
			GUICtrlSetData($edit, GUICtrlRead($edit) & @CRLF & StringTrimLeft($ret,StringLen($p_info)))
			GUICtrlSendMsg($edit, $EM_SCROLLCARET, 0, 0)
			If StringInStr($ret , " is disconnected.") Then
				$aux=StringTrimLeft($ret , StringLen($p_info))
				$aux=StringTrimRight(StringTrimLeft($aux , 8),17)
				$zz=_GUICtrlListFindString($list,$aux)
				_GUICtrlListDeleteItem($list , $zz)
			EndIf
		EndIf
	EndIf
	
	Sleep(1)
WEnd
;loop end

#region FUNCTIONS


Func _TCPCreateMainListeningSocket($szIP, $szPort, $szNumConnect)
    TCPStartup()
    $TCMLS_MainSocket = TCPListen($szIP, $szPORT, $szNumConnect)
    If @ERROR Or $TCMLS_MainSocket = -1 Then Return -1
    Return $TCMLS_MainSocket
EndFunc

Func AddSocket($AS_sock)
    $AS_n = $CSock[0] + 1
    ReDim $CSock[$AS_n + 1]
    $CSock[0] = $AS_n
    $CSock[$AS_n] = $AS_sock
EndFunc

Func RemoveSocket($instance)
    Dim $aTemp[$CSock[0]]
    
    $aTemp[0] = $CSock[0] - 1
    $RS_i = 1
    If $aTemp[0] > 0 Then
        For $RS_n = 1 to $CSock[0]
            If $RS_n <> $instance Then
                $aTemp[$RS_i] = $CSock[$RS_n]
                $RS_i = $RS_i + 1
            EndIf
        Next
    EndIf
    $CSock = $aTemp
EndFunc
Func OnQuit()
	TCPSend($socket, $p_info&"Server: " & $nick & " is disconnected.")
	Sleep(1000)
    If @ERROR Or $ret < 0 Then Exit
    GUICtrlSetData($input,"")
    GUICtrlSetState($input,$GUI_FOCUS)
	For $n = 1 to $CSock[0]
        TCPCloseSocket($CSock[$n])
    Next
   TCPCloseSocket($MainSocket )
   TCPShutDown()
    If $socket >= 0 Then TCPCloseSocket($socket)
EndFunc
	
	
Func display()
	_ArrayDisplay($USERS)
EndFunc
#endregion FUNCTIONS


Func Broadcast($szData)
    For $B_n = 1 to $CSock[0]
        TCPSend($CSock[$B_n],$szData);$CSock[0] & "-" & 
    Next
EndFunc
Func MSG()
	MsgBox(16,"" , "Server closed!")
EndFunc









