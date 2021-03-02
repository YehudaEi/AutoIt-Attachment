
#region    ;************ Includes ************

#include <String.au3>
#include <Constants.au3>
#include <GuiListBox.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Inet.au3>
#include <AssoArrays.au3>

#endregion    ;************ Includes ************


Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

Dim $Uarr[7] = [-1, "::", "|", "/", "-", "\", "|"]

$ConnectedSocket = ""
$TSTimeout = 0

$updTimer = 99999
$USwitch = 0

$tick = -1

$inifile = "config"
$CurProfile = ""

$Qport = 10011

LoadIni()
Func LoadIni()
	If Not IsArray(IniReadSectionNames($inifile & ".ini")) then
		If Not FileExists($inifile & ".ini") Then
			MsgBox(0,"Welcome to the TS3 Query Viewer","If this is the first time you are using this program, please "&@CRLF& _
													   "click on the 'C' button to create a new server profile."&@CRLF& _
													   "Always click on the 'Save' button after you have made changes."&@CRLF&@CRLF& _
													   "                                   Have Fun!")
		EndIf
		$temp = FileOpen($inifile & ".ini", 2)
		FileClose($temp)

		x($inifile & ".__Global__.Last", "default")
		x($inifile & ".__Global__.Autostart", "")
		x($inifile & ".__Global__.ShowSelf", "1")

		x($inifile & ".default.IP", "1.1.1.1:123")
		x($inifile & ".default.LoginName", "")
		x($inifile & ".default.LoginPW", "")

		_WriteAssocToIni($inifile, "", 1)


	Else
		_ReadAssocFromIni($inifile)
		x_display(); Write config tree to console

	EndIf

EndFunc   ;==>LoadIni


TraySetClick(8)
TraySetIcon("Shell32.dll", -85)

$TRAY_copyIP = TrayCreateItem("No Inet IP")
TrayItemSetOnEvent($TRAY_copyIP, "copyIP")

TrayCreateItem("")

TrayCreateItem("About")
TrayItemSetOnEvent(-1, "ShowAbout")

TrayCreateItem("")

TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "Close")

TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "MinRes")

Func ShowAbout()
	GUISetState(@SW_SHOW, $GUI_About)
EndFunc   ;==>ShowAbout

Func Close()
	If $ConnectedSocket Then
		TS3Send("quit")
		TCPCloseSocket($ConnectedSocket)
	EndIf
	TCPShutdown()
	Exit
EndFunc   ;==>Close



; ##### Main GUI ######
#region ### START Koda GUI section ### Form=
$GUI = GUICreate("TS3 Query Viewer", 200 + 20, 126, 559, 179, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX))

Opt("GUIResizeMode", $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
$c_ConnBut = GUICtrlCreateCheckbox("C", 201, 1, 18, 18, BitOR($BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetOnEvent(-1, "c_ConnBut")
GUICtrlSetTip ( -1, "Connect" )

Opt("GUIResizeMode", $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKVCENTER)
$c_OptBut = GUICtrlCreateCheckbox("O", 201, 36, 18, 18, BitOR($BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetOnEvent(-1, "c_OptBut")
GUICtrlSetTip ( -1, "Options" )

Opt("GUIResizeMode", $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
$c_UpdateBut = GUICtrlCreateCheckbox("U", 201, 71, 18, 18, BitOR($BS_PUSHLIKE, $WS_TABSTOP))
GUICtrlSetOnEvent(-1, "c_UpdateBut")
GUICtrlSetTip ( -1, "Update List" )

$i_UpdTime = GUICtrlCreateInput("10", 201, 91, 18, 18)
GUICtrlSetTip ( -1, "Update evey seconds" )

$l_UpdAni = GUICtrlCreateLabel("", 208, 111, 18, 18)

Opt("GUIResizeMode", $GUI_DOCKBORDERS)

$GUI_lv = GUICtrlCreateListView("", 0, 0, 199, 125, BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $WS_HSCROLL, $WS_VSCROLL), 0)

_GUICtrlListView_InsertColumn($GUI_lv, 0, "Name", 50)
_GUICtrlListView_InsertColumn($GUI_lv, 1, "MH", 10)
_GUICtrlListView_InsertColumn($GUI_lv, 2, "Channel", 50)

GUISetOnEvent($GUI_EVENT_CLOSE, "MinRes")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "MinRes")
GUISetOnEvent($GUI_EVENT_RESTORE, "MinRes")
GUIRegisterMsg($WM_GETMINMAXINFO, 'MY_WM_GETMINMAXINFO')

GUISetState(@SW_HIDE)
#endregion ### END Koda GUI section ###


Func MinRes()
	If BitAND(WinGetState($GUI), 2) Then
		Exit
		GUISetState(@SW_HIDE)
	Else
		GUISetState(@SW_SHOW)
		$updTimer = 99999
	EndIf
EndFunc   ;==>MinRes

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
	Switch $hWnd
		Case $GUI
			$minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
			DllStructSetData($minmaxinfo, 7, 150) ; min X
			DllStructSetData($minmaxinfo, 8, 120) ; min Y
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_GETMINMAXINFO



; ##### Connect Child GUI ######
#region ### START Koda GUI section ### Form=
$GUI_Connect = GUICreate("Connect to TS3 Server", 330, 228, Default, Default, Default, Default, $GUI)
GUISetOnEvent($GUI_EVENT_CLOSE, "Closesub", $GUI_Connect)

GUICtrlCreateLabel("Label", 135, 8, 40, 20, $SS_CENTER)
$i_name = GUICtrlCreateInput("", 197, 6, 120, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))

GUICtrlCreateLabel("IP:Port", 136, 38, 40, 20, $SS_CENTER)
$i_ip = GUICtrlCreateInput("", 197, 36, 120, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))

GUICtrlCreateLabel("Query Login Name", 136, 62, 58, 24, $SS_CENTER)
$i_loginname = GUICtrlCreateInput("", 197, 65, 120, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))

GUICtrlCreateLabel("Query Login PW", 136, 93, 58, 24, $SS_CENTER)
$i_loginpw = GUICtrlCreateInput("", 197, 96, 120, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_PASSWORD))

GUICtrlCreateLabel("Hide PW", 232, 121, 47, 17)
$c_pwhide = GUICtrlCreateCheckbox("Hide PW", 284, 119, 16, 19)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "c_pwhideclick")

$b_connect = GUICtrlCreateButton("Connect", 175, 139, 83, 28)
GUICtrlSetOnEvent(-1, "b_connect")
$b_addser = GUICtrlCreateButton("Add", 158, 174, 25, 23)
GUICtrlSetOnEvent(-1, "b_addser")
$b_delser = GUICtrlCreateButton("Del", 194, 174, 27, 23)
GUICtrlSetOnEvent(-1, "b_delser")
$b_saveser = GUICtrlCreateButton("Save", 232, 171, 43, 28)
GUICtrlSetOnEvent(-1, "b_saveser")
$b_autoconnect = GUICtrlCreateCheckbox("Autoconnect", 180, 199, 80, 23)
GUICtrlSetOnEvent(-1, "b_autoconnect")

$GUIc_List = _GUICtrlListBox_Create($GUI_Connect, "", 0, 0, 129, 201, BitOR($LBS_NOTIFY, $WS_VSCROLL, $WS_BORDER))

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

GUISetState(@SW_HIDE)
#endregion ### END Koda GUI section ###


Func c_pwhideclick()
	GUISetState(@SW_LOCK, $GUI_Connect)
	Local $tmp_pw = GUICtrlRead($i_loginpw)
	If GUICtrlRead($c_pwhide) = $GUI_CHECKED Then ; Masked
		GUICtrlDelete($i_loginpw)
		GUISwitch($GUI_Connect)
		$i_loginpw = GUICtrlCreateInput($tmp_pw, 197, 96, 100, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_PASSWORD))
		GUISwitch($GUI)
	Else ; Plain
		GUICtrlDelete($i_loginpw)
		GUISwitch($GUI_Connect)
		$i_loginpw = GUICtrlCreateInput($tmp_pw, 197, 96, 100, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
		GUISwitch($GUI)
	EndIf
	GUISetState(@SW_UNLOCK, $GUI_Connect)
EndFunc   ;==>c_pwhideclick

Func b_connect()
	x("com.connect", 1)
EndFunc   ;==>b_connect

Func b_addser()
	Local $t_arr = xkeys($inifile)
	Local $t_str = _ArrayToString($t_arr, "[")
	ConsoleWrite("$t_str=" & $t_str & @LF)
	$t_arr = StringRegExp($t_str, "\[New(\d*)", 3)
	If Not IsArray($t_arr) Then
		$t_name = "New"
	Else
		$t_name = "New" & _ArrayMax($t_arr, 1) + 1
	EndIf

	x($inifile & "." & $t_name & ".IP", "1.1.1.1:9987")
	x($inifile & "." & $t_name & ".LoginName", "")
	x($inifile & "." & $t_name & ".LoginPW", "")

	_GUICtrlListBox_AddString($GUIc_List, $t_name)
	_GUICtrlListBox_SelectString($GUIc_List, $t_name)
	SelectProfile($t_name)

EndFunc   ;==>b_addser

Func b_delser()
	$i_seli = _GUICtrlListBox_GetCurSel($GUIc_List)
	$t_str = _GUICtrlListBox_GetText($GUIc_List, $i_seli)
	ConsoleWrite("cursel(" & $i_seli & "): " & $t_str & @LF)
	_GUICtrlListBox_DeleteString($GUIc_List, $i_seli)
	$i_cari = _GUICtrlListBox_GetCaretIndex($GUIc_List)
	_GUICtrlListBox_SetCurSel($GUIc_List, $i_cari)

	x_del($inifile & "." & $t_str)
	_WriteAssocToIni($inifile, '', 1)
	SelectProfile(_GUICtrlListBox_GetText($GUIc_List, $i_cari))

EndFunc   ;==>b_delser

Func b_saveser()
	$t_str = _GUICtrlListBox_GetText($GUIc_List, _GUICtrlListBox_GetCurSel($GUIc_List))
	$t_Inpstr = GUICtrlRead($i_name)
	If Not ($t_str = $t_Inpstr) Then
		x_del($inifile & "." & $t_str)
		_GUICtrlListBox_ReplaceString($GUIc_List, _GUICtrlListBox_GetCurSel($GUIc_List), $t_Inpstr)
		_GUICtrlListBox_SelectString($GUIc_List, $t_Inpstr)
	EndIf
	x($inifile & "." & $t_Inpstr & ".IP", GUICtrlRead($i_ip))
	x($inifile & "." & $t_Inpstr & ".LoginName", GUICtrlRead($i_loginname))
	x($inifile & "." & $t_Inpstr & ".LoginPW", GUICtrlRead($i_loginpw))

	_WriteAssocToIni($inifile, '', 1)

	SelectProfile($t_Inpstr)

EndFunc   ;==>b_saveser

Func b_autoconnect()
	$t_str = _GUICtrlListBox_GetText($GUIc_List, _GUICtrlListBox_GetCurSel($GUIc_List))
	If BitAND(GUICtrlRead($b_autoconnect), $GUI_CHECKED) Then
		x($inifile & ".__Global__.Last", $t_str)
		x($inifile & ".__Global__.Autostart", 1)
	Else
		x($inifile & ".__Global__.Autostart", "")
	EndIf
EndFunc   ;==>b_autoconnect

Func Closesub()
	GUISetState(@SW_HIDE, @GUI_WinHandle)
EndFunc   ;==>Closesub


; ##### About GUI ######
#Region ### START Koda GUI section ### Form=
$GUI_About = GUICreate("About", 324, 241, 302, 218)
GUICtrlCreateGroup("", 8, 8, 305, 185)
GUICtrlCreateLabel("TS3 Query Viewer", 104, 56, 90, 17)
GUICtrlCreateLabel("v. 1.00", 128, 88, 37, 17)
GUICtrlCreateLabel("Comments and Bugreports to", 40, 160, 140, 17)
GUICtrlCreateLabel("Copyright: ADSoft", 199, 124, 88, 17)
GUICtrlCreateLabel("Coded by Qsek", 31, 124, 77, 17)
GUICtrlCreateLabel("TS3@adminmap.de", 181, 160, 98, 17)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor(-1, 0)
GUICtrlSetOnEvent(-1, "OpenEmail")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateButton("&OK", 124, 208, 75, 25, 0)
GUICtrlSetOnEvent(-1, "Closesub")
GUISetOnEvent($GUI_EVENT_CLOSE, "Closesub")
GUISetState(@SW_HIDE)
#EndRegion ### END Koda GUI section ###

Func OpenEmail()
	ShellExecute("mailto:ts3@adminmap.de")
EndFunc


InitProfileList()
Func InitProfileList()

	$CurProfile = SelectProfile(x($inifile & ".__Global__.Last")) ; Load Last Profile or default one

	_GUICtrlListBox_BeginUpdate($GUIc_List)
	_GUICtrlListBox_ResetContent($GUIc_List)
	$t_arr = xkeys($inifile)
	For $i = 1 To UBound($t_arr) - 1
		_GUICtrlListBox_AddString($GUIc_List, $t_arr[$i])
	Next
	_GUICtrlListBox_EndUpdate($GUIc_List)
	_GUICtrlListBox_SelectString($GUIc_List, $CurProfile)

EndFunc   ;==>InitProfileList


Func SelectProfile($s_last)

	If x($inifile & "." & $s_last & ".IP") == "" Then
		$t_arr = xkeys($inifile)

		Switch UBound($t_arr)
			Case 2 To 999; Get the first profile available
				x($inifile & ".__Global__.Last", $t_arr[1])
				$s_last = $t_arr[1]
			Case 0 ; Nothing in ini? create Global section and goto next case
				x($inifile & ".__Global__.Last", "default")
				x($inifile & ".__Global__.Autostart", "")
				x($inifile & ".__Global__.ShowSelf", "1")
				ContinueCase
			Case 1 ; No profiles? then create default one
				x($inifile & ".default.IP", "1.1.1.1:123")
				x($inifile & ".default.LoginName", "")
				x($inifile & ".default.LoginPW", "")

				x($inifile & ".__Global__.Last", "default")

				_WriteAssocToIni($inifile)
				$s_last = "default"
		EndSwitch
	EndIf
	If x($inifile & ".__Global__.Last") = $s_last And x($inifile & ".__Global__.Autostart") = "1" Then
		GUICtrlSetState($b_autoconnect, $GUI_CHECKED)
	Else
		GUICtrlSetState($b_autoconnect, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($i_name, $s_last)
	GUICtrlSetData($i_ip, x($inifile & "." & $s_last & ".IP"))
	GUICtrlSetData($i_loginname, x($inifile & "." & $s_last & ".LoginName"))
	GUICtrlSetData($i_loginpw, x($inifile & "." & $s_last & ".LoginPW"))

	Return $s_last

EndFunc   ;==>SelectProfile



; #### All loaded, now show GUI ####

GUISetState(@SW_SHOW, $GUI)


TCPStartup()

If x($inifile & ".__Global__.Autostart") = 1 Then
	Connect()
EndIf

Func Connect()
	If $ConnectedSocket Then
		TCPCloseSocket($ConnectedSocket)
		$ConnectedSocket = ""
		$clientarr = ""
		$updTimer = 99999
	EndIf

	$ip = ""
	$PublicIP = _GetIP()
	If @error Then $PublicIP = "No Inet IP"
	TrayItemSetText($TRAY_copyIP, $PublicIP)

	$tarr = StringSplit(x($inifile & "." & $CurProfile & ".IP"), ":", 3)
	Switch UBound($tarr)
		Case 2
			$ip = $tarr[0]
			$c_port = $tarr[1]
		Case 1
			$ip = $tarr[0]
			$c_port = 9987
		Case Else
			Exit
	EndSwitch

	$pingip = Ping($ip, 2000)
	If @error Then
		MsgBox(0, "Warning", "Ping Failed (ErrorCode:" & @error & "). Does your server allow Pinging?")
	Else
		ConsoleWrite("Ping success:" & $pingip & @CRLF)
	EndIf

	If Not ConnectClick($ip) Then Return
	Global $channelarr = ""
	Global $ret = ""

	; TS3Send will not process if $ConnectedSocket = "" resulting from a previous TS3Send which did not recieve "msg=ok"

	If x($inifile & "." & $CurProfile & ".LoginName") Or x($inifile & "." & $CurProfile & ".LoginPW") Then
		TS3Send("login client_login_name=" & x($inifile & "." & $CurProfile & ".LoginName") & " client_login_password=" & x($inifile & "." & $CurProfile & ".LoginPW"))
	EndIf
	TS3Send("use port=" & $c_port)
	$ret = TS3Send("channellist")
	$channelarr = StringSplit(StringReplace($ret, @LF & @CR, ""), "|", 3)

EndFunc   ;==>Connect

Func ConnectClick($s_ip)

	$ConnectedSocket = TCPConnect(TCPNameToIP($s_ip), $Qport)
	If @error Then

		MsgBox(0, "Error", "TCPConnect failed on address: " & TCPNameToIP($s_ip) & ":" & $Qport)
		Return False
	Else
		ConsoleWrite(@CRLF & "+TCPConnect to " & $s_ip & ":" & $Qport & "  --> success" & @CRLF)
	EndIf
	$recv = recv("Welcome to the TeamSpeak 3 ServerQuery interface,")

	If Not StringInStr($recv, "TS3") Then
		MsgBox(0, "Warning", "Unknown Welcome response: " & $recv)
	EndIf
	$TSTimeout = TimerInit()
	Return True
EndFunc   ;==>ConnectClick







While 1
	If x("com.connect") = 1 Then
		ConsoleWrite("!Connecting..." & @LF)
		x("com.connect", 0)

		$t_str = _GUICtrlListBox_GetText($GUIc_List, _GUICtrlListBox_GetCurSel($GUIc_List))

		x($inifile & "." & $t_str & ".IP", GUICtrlRead($i_ip))
		x($inifile & "." & $t_str & ".LoginName", GUICtrlRead($i_loginname))
		x($inifile & "." & $t_str & ".LoginPW", GUICtrlRead($i_loginpw))

		$CurProfile = $t_str

		Connect()
		ConsoleWrite("!Connecting END" & @LF)
	EndIf

	If $ConnectedSocket And ($updTimer = 99999 Or ($USwitch And $tick <> @SEC)) Then
		$updTimer += 1
		If $updTimer > GUICtrlRead($i_UpdTime) Then
			If $updTimer < 100000 Then $updTimer = 0
			$Uarr[0] = 1
			GUICtrlSetData($l_UpdAni, $Uarr[$Uarr[0]])
			If Not IsDeclared("ret") Then ContinueLoop
			$Array = GetClientArray($ret)
			If Not IsArray($Array) Then
				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI_lv))
				ContinueLoop
			EndIf
			SetClientArray($Array)
		EndIf
		$tick = @SEC
	EndIf

	If $Uarr[0] >= 1 Then
		GUICtrlSetData($l_UpdAni, $Uarr[$Uarr[0]])
		$Uarr[0] += 1
		If $Uarr[0] > 5 Then
			$Uarr[0] = -1
		EndIf
	EndIf
	Sleep(50)
	If $Uarr[0] = -1 Then
		GUICtrlSetData($l_UpdAni, "")
	EndIf

WEnd

Func c_ConnBut()
	If GUICtrlRead($c_ConnBut) = $GUI_CHECKED Then
		GUISetState(@SW_SHOW, $GUI_Connect)
	Else
		GUISetState(@SW_HIDE, $GUI_Connect)
	EndIf
EndFunc   ;==>c_ConnBut

Func c_OptBut()
	If GUICtrlRead($c_OptBut) = $GUI_CHECKED Then

	Else

	EndIf
EndFunc   ;==>c_OptBut

Func c_UpdateBut()
	If GUICtrlRead($c_UpdateBut) = $GUI_CHECKED Then
		$USwitch = 1
		$updTimer = GUICtrlRead($i_UpdTime) + 1
	Else
		$USwitch = 0
	EndIf
EndFunc   ;==>c_UpdateBut






Func SetClientArray($sArray)
	GUISetState(@SW_LOCK)
	$aSelItem = _GUICtrlListView_GetNextItem($GUI_lv)

	$aFocItem = _GUICtrlListView_GetNextItem($GUI_lv, -1, 0, 4)

	$aOrigin = _GUICtrlListView_GetOrigin($GUI_lv)

	_GUICtrlListView_BeginUpdate($GUI_lv)



	$ret = _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($GUI_lv))

	_GUICtrlListView_AddArray($GUI_lv, $sArray)
	If Not IsArray($sArray) Then
		_GUICtrlListView_SetColumnWidth($GUI_lv, 0, $LVSCW_AUTOSIZE_USEHEADER)
		_GUICtrlListView_SetColumnWidth($GUI_lv, 1, $LVSCW_AUTOSIZE_USEHEADER)
	Else
		_GUICtrlListView_SetColumnWidth($GUI_lv, 0, $LVSCW_AUTOSIZE)
		If _GUICtrlListView_GetColumnWidth($GUI_lv, 0) < 40 Then _GUICtrlListView_SetColumnWidth($GUI_lv, 0, 39)
		_GUICtrlListView_SetColumnWidth($GUI_lv, 1, $LVSCW_AUTOSIZE)
		If _GUICtrlListView_GetColumnWidth($GUI_lv, 1) < 28 Then _GUICtrlListView_SetColumnWidth($GUI_lv, 1, 27)
	EndIf

	_GUICtrlListView_SetColumnWidth($GUI_lv, 2, $LVSCW_AUTOSIZE_USEHEADER)
	If _GUICtrlListView_GetItemCount($GUI_lv) > 5 Then
		$GUI_lvcw = _GUICtrlListView_GetColumnWidth($GUI_lv, 2)
		_GUICtrlListView_SetColumnWidth($GUI_lv, 2, $GUI_lvcw - 16)
	EndIf

	_GUICtrlListView_Scroll($GUI_lv, $aOrigin[0], $aOrigin[1])

	_GUICtrlListView_SetItemSelected($GUI_lv, $aSelItem)
	_GUICtrlListView_SetItemFocused($GUI_lv, $aFocItem)

	_GUICtrlListView_EndUpdate($GUI_lv)
	GUISetState(@SW_UNLOCK)

EndFunc   ;==>SetClientArray



Func GetClientArray($sInput)
	$Uarr[0] = 1
	Dim $channelarr2D[UBound($channelarr)][2]
	For $i = 0 To UBound($channelarr) - 1
		$channelarr2D[$i][0] = StringRegExpReplace($channelarr[$i], ".*?cid=(\d*) .+", "\1")
		$temp = StringRegExpReplace($channelarr[$i], ".*?channel_name=(.*?) .+", "\1")
		$temp = StringReplace($temp, "\s", " ")
		$temp = StringReplace($temp, "Â", "")
		$channelarr2D[$i][1] = $temp
	Next

	$ret = TS3Send("clientlist -voice")
	If Not $ret Then Return 0
	$clientarr = StringSplit(StringReplace($ret, @LF & @CR, ""), "|", 3)

	While 1
		$tfound = 0
		For $i = 0 To UBound($clientarr) - 1
			If StringInStr($clientarr[$i], "serveradmin\sfrom\s") Then
				$tfound = 1
				_ArrayDelete($clientarr, $i)
				ExitLoop
			EndIf
		Next
		If $tfound Then ContinueLoop
		ExitLoop
	WEnd

	If IsArray($clientarr) Then
		Dim $clientarr2D[UBound($clientarr)][3]
		For $i = 0 To UBound($clientarr) - 1

			$temp = StringRegExpReplace($clientarr[$i], ".*?client_nickname=(.*?) .+", "\1")
			$temp = StringReplace($temp, "\s", " ")
			$temp = StringReplace($temp, "Â", "")
			$clientarr2D[$i][0] = $temp ; Nivkname

			$chanID = StringRegExpReplace($clientarr[$i], ".*?cid=(\d*) .+", "\1")
			$chanArrIdx = _ArraySearch($channelarr2D, $chanID, 0, 0, 0, 0, 0, 0)

			If $chanArrIdx = -1 Then
				$clientarr = ""
				Return 0
			EndIf
			$clientarr2D[$i][2] = $channelarr2D[$chanArrIdx][1] ; Channel Name

			$clim = StringRegExpReplace($clientarr[$i], ".*?client_input_muted=(\d) .+", "\1")
			$clom = StringRegExpReplace($clientarr[$i], ".*?client_output_muted=(\d) .+", "\1")
			If $clim = 1 Then
				$clim = "M"
			Else
				$clim = ""
			EndIf
			If $clom = 1 Then
				$clom = "H"
			Else
				$clom = ""
			EndIf
			$clientarr2D[$i][1] = $clim & $clom ; Muted/Headphones

		Next
		_ArraySort($clientarr2D, 0, 0, 0, 2)
	Else
		Return -1
	EndIf

	Return $clientarr2D

EndFunc   ;==>GetClientArray


Func copyIP()
	Local $trayip = TrayItemGetText($TRAY_copyIP)
	If $trayip = "No Inet IP" Then Return
	ClipPut($trayip)
	TrayTip("", $trayip & " copied to the clipboard", 0)
	AdlibRegister("CloseTrayTip", 3000)
EndFunc   ;==>copyIP

Func CloseTrayTip()
	TrayTip("", "", 0)
	AdlibUnRegister("CloseTrayTip")
EndFunc   ;==>CloseTrayTip

Func TS3Send($execStr)
	If $ConnectedSocket = "" Then Return False
	If $TSTimeout And TimerDiff($TSTimeout) > 60000 Then
		$clientarr = ""
		Connect()
		$updTimer = 99999
	Else
		$TSTimeout = TimerInit()
	EndIf
	$tt = TCPSend($ConnectedSocket, $execStr & @LF) ; Send to Server
	$recv = recv("msg=ok")
	Return $recv
EndFunc   ;==>TS3Send

Func recv($s_string = "")

	$data = ""
	$recv = ""
	$i = 0
	While 1
		Sleep(10)
		$recv = TCPRecv($ConnectedSocket, 2048)

		$data &= $recv

		If $s_string Then
			If StringInStr($recv, $s_string) Then
				ExitLoop
			EndIf
			$t_srex = StringRegExp($recv, "error id=(\d+) msg=(\S+) failed_permid=(\d+)", 3)
			Select
				Case UBound($t_srex) = 3
					TCPCloseSocket($ConnectedSocket)
					$ConnectedSocket = ""
					$clientarr = ""
					$updTimer = 99999
					$t_srex[1] = StringReplace($t_srex[1], "\s", " ")
					MsgBox(0, "Error", "Error ID: " & @TAB & @TAB & $t_srex[0] & @CRLF & "Message: " & @TAB & $t_srex[1] & @CRLF & "Failed Perm. ID: " & @TAB & $t_srex[2])
					SetError(1)
					Return False
				Case StringLeft($recv, 5) = "error"
					TCPCloseSocket($ConnectedSocket)
					$ConnectedSocket = ""
					$clientarr = ""
					$updTimer = 99999

					MsgBox(0, "Unknown Error", $recv)
					SetError(1)
					Return False

					ExitLoop

			EndSelect

		EndIf
		If $i > 500 Then
			ConsoleWrite("!string '" & $s_string & "' ...Timeout" & @CRLF)
			ConsoleWrite("Recieved instead: " & $data & @CRLF)
			ConsoleWrite("Closing Connection" & @CRLF)
			TCPCloseSocket($ConnectedSocket)
			$ConnectedSocket = ""
			SetError(1)
			$clientarr = ""
			$updTimer = 99999
			Return False
		EndIf

		$i += 1
	WEnd

	Return $data
EndFunc   ;==>recv


Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode
	If Not IsHWnd($GUIc_List) Then $GUIc_List = GUICtrlGetHandle($GUIc_List)
	$hWndFrom = $ilParam
	$iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
	$iCode = BitShift($iwParam, 16) ; Hi Word

	Switch $hWndFrom
		Case $GUIc_List
			Switch $iCode
				Case $LBN_SELCHANGE ; Sent when the selection in a list box has changed
					SelectProfile(_GUICtrlListBox_GetText($GUIc_List, _GUICtrlListBox_GetCurSel($GUIc_List)))
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
