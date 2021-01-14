#include <GUIConstants.au3>
#include <File.au3>
#include <Misc.au3>
#Include <GuiList.au3>

Dim $ConnectedSocket = -1
Global $CSock[1]
Dim $MainSocket

$CSock[0] = 0

;;;client
$socket = -1

$nick=FileReadLine(@scriptdir & "/settings.ini", 1)

If FileExists(@scriptdir & "/settings.ini") Then 
	Sleep(10)
Else
	_FileCreate(@scriptdir & "/settings.ini")
EndIf
	
	If FileReadLine(@scriptdir & "/settings.ini", 1) = "" Then $nick = InputBox("K Chat Program","Enter a nickname to use when chatting")

While 1
If $nick = "" Then 
	$nick=InputBox("K Chat Program", "Please enter a nickname")
	Else
	_FileWriteToLine(@scriptdir & "/settings.ini", 1, $nick, 1)
	ExitLoop
	EndIf
WEnd
;;;;;;;;;;;;;;;;;;;;
If FileReadLine(@scriptdir & "/settings.ini", 2) = "" Then
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

$port = "3333"
$ipaddress = InputBox("IpAdress", "Enter the ip to connect to, leave blank if you are the server!")
If $ipaddress = "" Then
$ipaddress = @ipaddress2


$MainSocket = _TCPCreateMainListeningSocket($ipaddress, $port, 100)
If @ERROR Or $MainSocket = -1 Then Exit
EndIf

TCPStartup()

;gui
$gui = GUICreate($nick & "'s Chat",580,250)
$menu=GuiCtrlCreateMenu("Program")
$set=GuiCtrlCreateMenuItem("Settings", $menu)
$menu1=GuiCtrlCreateMenuItem("Exit", $menu)
$menu3=GuiCtrlCreateMenu("Help")
$menu4=GuiCtrlCreateMenuItem("About", $menu3)
$userlist=GuiCtrlCreateLabel("UserList:", 485, 5)
$bsend = GUICtrlCreateButton("Send",380,145,60,80)
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
	TCPSend($socket, "Server: " & $nick & " is connected.")
    EndIf

    

;;;;;;;;
While 1
	$nick=FileReadLine(@scriptdir & "/settings.ini", 1)
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit
	If $msg = $menu1 Then Exit
	If $msg = $menu4 Then MsgBox(0, "About", "Simple Chat Program. Coding by Kreatorul, 2007. Contact: bal_dabac@yahoo.com")
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
				_FileWriteToLine(@scriptdir & "/settings.ini", 1, GuiCtrlReaD($ninput), 1)
		If $nick <> GuiCtrlReaD($ninput) Then
		TCPSend($socket, "Server: " & $nick & " changed name to " & GuiCtrlReaD($ninput) & ".")
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
            ElseIf $ret2 <> "" Then
                Broadcast($ret2)
            EndIf
        Next
        If $br <> "" Then
            $br = StringSplit(StringTrimRight($br,1),@LF)
            For $n = 1 to $br[0]
                RemoveSocket(Int($br[$n]))
            Next
        EndIf
    EndIf
  	

   If $msg = $bsend Then
    $ret = TCPSend($socket, $nick & ": " & GUICtrlRead($input))
    If @ERROR Or $ret < 0 Then ExitLoop
    GUICtrlSetData($input,"")
    GUICtrlSetState($input,$GUI_FOCUS)
EndIf

HotKeySet("{ENTER}", "Bsend")
   
   $ret = TCPRecv($socket, 512)
   If @ERROR Or $ret < 0 Then ExitLoop
   If StringLen($ret) > 0 Then
	    If StringInStr($ret, "is connected.") Then
		    If StringTrimLeft(StringTrimRight($ret, 14), 10) <> $nick Then
		   _GuiCtrlListAddItem($list, StringTrimLeft(StringTrimRight($ret, 14), 10))
	   EndIf
   EndIf
   If StringInStr($ret, "is disconnected.") Then _GUICtrlListDeleteItem($list, _GuiCtrlListFindString($list, StringTrimLeft(StringTrimRight($ret, 17), 10), 1))
	    GUICtrlSetData($edit, GUICtrlRead($edit) & @CRLF & $ret)
		GUICtrlSendMsg($edit, $EM_SCROLLCARET, 0, 0)
		EndIf
	
	Sleep(1)
WEnd
;loop end

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

Func Broadcast($szData)
    For $B_n = 1 to $CSock[0]
        TCPSend($CSock[$B_n],$CSock[0] & "-" & $szData)
    Next
EndFunc

Func OnAutoItExit()
	TCPSend($socket, "Server: " & $nick & " is disconnected.")
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

Func AddSocket($AS_sock)
    $AS_n = $CSock[0] + 1
    ReDim $CSock[$AS_n + 1]
    $CSock[0] = $AS_n
    $CSock[$AS_n] = $AS_sock
EndFunc

Func _TCPCreateMainListeningSocket($szIP, $szPort, $szNumConnect)
    TCPStartup()
    $TCMLS_MainSocket = TCPListen($szIP, $szPORT, $szNumConnect)
    If @ERROR Or $TCMLS_MainSocket = -1 Then Return -1
    Return $TCMLS_MainSocket
EndFunc

Func Bsend()
	$ret = TCPSend($socket, $nick & ": " & GUICtrlRead($input))
    GUICtrlSetData($input,"")
    GUICtrlSetState($input,$GUI_FOCUS)
	EndFunc