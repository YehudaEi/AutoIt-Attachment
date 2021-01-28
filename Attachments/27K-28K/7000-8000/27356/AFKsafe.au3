#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=data\ico\afk_safe.ico
#AutoIt3Wrapper_outfile=AFKsafe v1.0 BETA.exe
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ #cs
;~  AutoIt Version: 3.3.0.0
;~  Author:            Nick  <NicoTn> Kamoen (MAIL AT: nickkamoen@gmail.com)

;~  Script Name: AFK.safe
;~  Script Version: 1.0
;~ #ce

;; CONTS


;Global Const $MF_BYCOMMAND = 0x00000000  ; In <GUIConstants.au3>
;Global Const $MF_BYPOSITION = 0x00000400 ; In <GUIConstants.au3>
If Not IsDeclared("LR_LOADFROMFILE") Then Global Const $LR_LOADFROMFILE = 0x0010
If Not IsDeclared("LR_LOADMAP3DCOLORS") Then Global Const $LR_LOADMAP3DCOLORS = 0x00001000
If Not IsDeclared("LR_LOADTRANSPARENT") Then Global Const $LR_LOADTRANSPARENT = 0x0020
If Not IsDeclared("MF_DEFAULT") Then Global Const $MF_DEFAULT = 0x00001000
If Not IsDeclared("MF_POPUP") Then Global Const $MF_POPUP = 0x00000010
If Not IsDeclared("MF_SEPARATOR") Then Global Const $MF_SEPARATOR = 0x00000800
If Not IsDeclared("MF_OWNERDRAW") Then Global Const $MF_OWNERDRAW = 0x00000100
If Not IsDeclared("CLR_NONE") Then Global Const $CLR_NONE = 0xFFFFFFFF
If Not IsDeclared("LR_DEFAULTSIZE") Then Global Const $LR_DEFAULTSIZE = 0x0040
If Not IsDeclared("LR_CREATEDIBSECTION") Then Global Const $LR_CREATEDIBSECTION = 0x2000
Global Const $IMAGE_BITMAP = 0
Global Const $IMAGE_ICON = 1
Global Const $BF_FLAT = 0x4000
Global Const $LR_DEFAULTCOLOR = 0x0000
Global Const $TRAY_ENABLE = 64
Global Const $TRAY_DISABLE = 128
Global Const $BS_FLAT = 0x8000

;~ ;; Includes
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>
#include <BlockInputEx.au3>
#include <GuiStatusBar.au3>
#include <HotKeyInput.au3>
#include "includes\_Crypt.au3"
#include <ModernMenu.au3>
#include <_WinAnimate.au3>
#Include <String.au3>
#include-once
;~ Opt("MustDeclareVars", 1)

;; Other
Global $dir_dat = @ScriptDir & "\data"
Global $dir_img = $dir_dat & "\img\"
Global $dir_ico = $dir_dat & "\ico\"


;;Declare Var
Global $mGUI, $header, $version_label, $unlock, $reset, $pass, $hStatus, $w_pos[4], $tm_ctrl_ico, $tm_ctrl_cm, $tm_ctrl_afk, $op_gui, $msg, $i_data, $password_in
Global $xy[2], $password_crypt, $tray_ctrl, $options, $coords[2], $read_ini, $password_decrypt, $sm_ctrl, $side_text, $hFont, $op_gui,$test,$checked
;~ $hFont = _WinAPI_CreateFont(12, _
;~ 0, _
;~ 0, _
;~ 0, _
;~ $FW_NORMAL, _
;~ False, _
;~ False, _
;~ False, _
;~ $DEFAULT_CHARSET, _
;~ $OUT_OUTLINE_PRECIS, _
;~ $CLIP_DEFAULT_PRECIS, _
;~ $DEFAULT_QUALITY, _
;~ $DEFAULT_PITCH, _
;~ 'Verdana')
;~ If $hFont Then _WinAPI_SetFont($tm_ctrl_afk, $hFont)

;; Globals
Global $ver = "1.0"
Global $wHandle = "AFK.safe " & $ver
Global $locked = 0
Global $dll = DllOpen("user32.dll")
Global $read = IniRead("data\data.ini", "main", "setup", 0);; Locals
Global $qhide = 0
Global $options = 1
Dim $tm_ctrl[8], $hImg[8]
Local $aParts[2] = [135, 74], $hIcons[2]
If Not FileExists("data\data.ini") Then _setup(1)
If $read = 0 Or $read < "" Then _setup(2)
If $read = 1 Then
	Global $xi = IniRead("data\data.ini", "main", "X", -1)
	Global $yi = IniRead("data\data.ini", "main", "Y", -1)
EndIf

;; MAIN
$mGUI = GUICreate($wHandle, 209, 201, $xi, $yi, BitOR($WS_POPUP, $WS_BORDER))
GUISetFont(7.5, 9, 4, "Verdana", $mGUI)
GUISetIcon($dir_ico & "afk_safe.ico", -1, $mGUI)
GUISetBkColor(0x000000, "AFK")
$header = GUICtrlCreatePic("data\img\header.jpg", 0, 0, 210, 54)
GUICtrlSetStyle($header, -1, $GUI_WS_EX_PARENTDRAG)
$version_label = GUICtrlCreateLabel($ver, 185, 40, 25, 25, $SS_CENTER)
GUICtrlSetState(-1, @SW_DISABLE)
GUICtrlSetColor(-1, 0x00F400)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
Dim $buttons[10]
$buttons[0] = GUICtrlCreateButton("0", 70, 131, 70, 25, $BS_FLAT)
$buttons[1] = GUICtrlCreateButton("1", 0, 56, 70, 25, $BS_FLAT)
$buttons[2] = GUICtrlCreateButton("2", 70, 56, 70, 25, $BS_FLAT)
$buttons[3] = GUICtrlCreateButton("3", 140, 56, 70, 25, $BS_FLAT)
$buttons[4] = GUICtrlCreateButton("4", 0, 81, 70, 25, $BS_FLAT)
$buttons[5] = GUICtrlCreateButton("5", 70, 81, 70, 25, $BS_FLAT)
$buttons[6] = GUICtrlCreateButton("6", 140, 81, 70, 25, $BS_FLAT)
$buttons[7] = GUICtrlCreateButton("7", 0, 106, 70, 25, $BS_FLAT)
$buttons[8] = GUICtrlCreateButton("8", 70, 106, 70, 25, $BS_FLAT)
$buttons[9] = GUICtrlCreateButton("9", 140, 106, 70, 25, $BS_FLAT)
$unlock = GUICtrlCreateButton("Unlock", 0, 131, 70, 25, $BS_FLAT)
GUICtrlSetState(-1, $GUI_DISABLE)
$reset = GUICtrlCreateButton("Reset!", 140, 131, 70, 25, $BS_FLAT)
$pass = GUICtrlCreateInput("", 0, 155, 209, 20, BitOR($ES_READONLY, $ES_NUMBER, $ES_PASSWORD))
Global $hInstance = _WinAPI_GetModuleHandle("shell32.dll")
$hStatus = _GUICtrlStatusBar_Create($mGUI, -1)
_GUICtrlStatusBar_SetMinHeight($hStatus, 24)
_GUICtrlStatusBar_SetParts($hStatus, $aParts)
_GUICtrlStatusBar_SetText($hStatus, "2009 © NicoTn", 0)
_GUICtrlStatusBar_SetText($hStatus, "Unlocked", 1)
$hIcons[1] = _WinAPI_LoadImage(0, "data\ico\unlocked.ico", $IMAGE_ICON, 14, 14, $LR_LOADFROMFILE + $LR_DEFAULTCOLOR)
$hIcons[0] = _WinAPI_LoadImage(0, "data\ico\about.ico", $IMAGE_ICON, 24, 24, $LR_LOADFROMFILE + $LR_DEFAULTCOLOR)
_GUICtrlStatusBar_SetIcon($hStatus, 0, $hIcons[0])
_GUICtrlStatusBar_SetIcon($hStatus, 1, $hIcons[1])
GUICtrlSetState($tm_ctrl[4], $GUI_CHECKED)
GUICtrlSetState($tm_ctrl[4], $TRAY_DISABLE)
GUISetState(@SW_SHOW,$mGUI)	
WinActivate($wHandle, "")

Local $icon_on = 1
If $read = 1 Then
	$w_pos = WinGetPos($mGUI)
	IniWrite("data\data.ini", "main", "X", $w_pos[0])
	IniWrite("data\data.ini", "main", "Y", $w_pos[1])
EndIf

$tm_ctrl_ico = _TrayIconCreate("-AFK.safe- ", @ScriptDir & "\data\ico\afk_safe.ico")
_TrayIconSetClick(-1, 16)
; Show the tray icon
$tm_ctrl_cm = _TrayCreateContextMenu() ; is the same like _TrayCreateContextMenu(-1) or _TrayCreateContextMenu($nTrayIcon1)
$nSideItem3 = _CreateSideMenu($tm_ctrl_cm)
$side_text = _SetSideMenuText($nSideItem3, "AFK.Save " & $ver)
_SetSideMenuColor($nSideItem3, 0x009600); yellow; default color - white
_SetSideMenuBkColor($nSideItem3, 0x00000) ; bottom start color - dark blue
_SetSideMenuBkGradColor($nSideItem3, 0x000000) ; top end color - orange
$tm_ctrl[0] = _TrayCreateMenu("-AFK.safe-")
$tm_ctrl[1] = _TrayCreateItem("About", $tm_ctrl[0], 1, 1)
$tm_ctrl[2] = _TrayCreateItem("Help", $tm_ctrl[0])
_TrayCreateItem("")
_TrayItemSetIcon(-1, "", 0)
$tm_ctrl[3] = _TrayCreateItem("Hide")
_TrayItemSetIcon(-1, "", 0)
$tm_ctrl[4] = _TrayCreateItem("Unhide")
GUICtrlSetState($tm_ctrl[4], $TRAY_DISABLE)
_TrayItemSetIcon(-1, "", 0)
$tm_ctrl[5] = _TrayCreateItem("Lock")
$tm_ctrl[6] = _TrayCreateItem("Options")
_TrayCreateItem("")
_TrayItemSetIcon(-1, "", 0)
$tm_ctrl[7] = _TrayCreateItem("Exit")
_TrayItemSetIcon($tm_ctrl[0], "data\ico\afk_safe.ico", 0)
_TrayItemSetIcon($tm_ctrl[1], "data\ico\about.ico", 0)
_TrayItemSetIcon($tm_ctrl[2], "data\ico\help.ico", 24)
_TrayItemSetIcon($tm_ctrl[3], "data\ico\w_min.ico", 0)
_TrayItemSetIcon($tm_ctrl[4], "data\ico\w_max.ico", 0)
_TrayItemSetIcon($tm_ctrl[5], "data\ico\lockdown_b.ico", 0)
_TrayItemSetSelIcon($tm_ctrl[5], "data\ico\lockdown.ico", 0)
_TrayItemSetIcon($tm_ctrl[6], "data\ico\options.ico", 0)
_TrayItemSetIcon($tm_ctrl[7], "data\ico\exit.ico", 0)
_skin(1)
_TrayIconSetState()


; Settings
Global $qLockKey = IniRead("data\data.ini","main","qlockkey","{END}")
Global $qHideKey = IniRead("data\data.ini","main","qhidekey","{HOME}")
HotKeySet("{"&$qLockKey&"}", "_qlock")
HotKeySet("{"&$qHideKey&"}", "_qhideon")


;; OPTIONS GUI
; options - quicklock
;				-  quick hide/Unhide
;              
$op_gui = GUICreate("AFK.safe - Options", 270, 100, $xi+212,$yi)
GUISetIcon($dir_ico & "afk_safe.ico", 1, $op_gui)
GUISetFont(7.5,7,0,"Verdana",$op_gui)

GUICtrlCreateGroup("Options",0,0,270,100)
GUICtrlCreateLabel("Quick lock: ",10,20,60,15)
$qLockKey_input = _GUICtrlCreateHotKeyInput(0,70,15,75,20)
GUICtrlCreateLabel("Current key: ",150,20,75,20)  
$curr_l = GUICtrlCreateInput("{"&$qLockKey&"}",215,15,50,20,$ES_READONLY)
GUICtrlCreateLabel("Quick hide: ",10,50,60,15)
$qHideKey_input = _GUICtrlCreateHotKeyInput(0,70,42,75,20)
GUICtrlCreateLabel("Current key: ",150,50,75,15)
$cur_h = GUICtrlCreateInput("{"&$qHideKey&"}",215,42,50,20,$ES_READONLY)
$save_settings = GUICtrlCreateButton("Save settings!",60,70,100,25,$BS_FLAT)
$save_settingsEx = GUICtrlCreateButton("Save and exit!",165,70,100,25,$BS_FLAT)

While 1
	$msg = GUIGetMsg(1)
	If $msg[0] = $GUI_EVENT_CLOSE Then 
		 If $msg[1] = $mGUI Then Exit
		  If $Msg[1] = $op_gui Then 
			GUISetState(@SW_HIDE, $op_gui)
			GUISwitch($mGUI)
			$options = 0
		EndIf
	EndIf

	If $msg[0] = $buttons[1] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "1")
	If $msg[0] = $buttons[2] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "2")
	If $msg[0] = $buttons[3] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "3")
	If $msg[0] = $buttons[4] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "4")
	If $msg[0] = $buttons[5] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "5")
	If $msg[0] = $buttons[6] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "6")
	If $msg[0]= $buttons[7] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "7")
	If $msg[0] = $buttons[8] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "8")
	If $msg[0] = $buttons[9] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "9")
	If $msg[0] = $buttons[0] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "0")
	If $msg[0] = $reset Then GUICtrlSetData($pass, "")
	If $msg[0] = $unlock Then
		Sleep(100)
	EndIf
	
	if $qhide = 1 Then HotKeySet("{"&$qHideKey&"}", "_qhideoff")
	if $qhide = 0 Then HotKeySet("{"&$qHideKey&"}", "_qhideon")

	
	;; OPTION EVENTS!
	if $msg[0] = $save_settingsEx Then
		 If $Msg[1] = $op_gui Then 
			$newLockKey = GUICtrlRead($qLockKey_input)
			$newHideKey = GUICtrlRead($qHideKey_input)
			MsgBox(0,"",$newLockKey&" - "&$newHideKey)
			Local $save_lk, $save_hk			
			
			if $newLockKey = "None" Then 
				$skip_lk = 1
				$newLockKey = $qLockKey
			else
				$skip_lk = 0
			EndIf			
			if $newHideKey = "None" Then 
				$skip_hk = 1
				$newHideKey = $qHideKey
			else
				$skip_hk = 0
			EndIf						
			if $skip_lk = 1 And $skip_hk = 1 Then _save(-1)	
			if $skip_lk = 0 And $skip_hk = 1 Then _save(1)
			if $skip_lk = 1 And $skip_hk = 0 Then _save(2)	
			if $skip_lk = 0 and $skip_hk = 0 Then _save(3)		
		   GUISetState(@SW_HIDE, $op_gui)
			GUISwitch($mGUI)

		EndIf	 
	EndIf
	if $msg[0] = $save_settings Then
		 If $Msg[1] = $op_gui Then 
			$newLockKey = GUICtrlRead($qLockKey_input)
			$newHideKey = GUICtrlRead($qHideKey_input)
			MsgBox(0,"",$newLockKey&" - "&$newHideKey)
			Local $save_lk, $save_hk			
			
			if $newLockKey = "None" Then 
				$skip_lk = 1
				$newLockKey = $qLockKey
			else
				$skip_lk = 0
			EndIf			
			if $newHideKey = "None" Then 
				$skip_hk = 1
				$newHideKey = $qHideKey
			else
				$skip_hk = 0
			EndIf						
			if $skip_lk = 1 And $skip_hk = 1 Then _save(-1)	
			if $skip_lk = 0 And $skip_hk = 1 Then _save(1)
			if $skip_lk = 1 And $skip_hk = 0 Then _save(2)	
			if $skip_lk = 0 and $skip_hk = 0 Then _save(3)		
			EndIf	 
	EndIf
	
;~ 	;; TRAY EVENTS!
	If $msg[0] = $tm_ctrl[6] Then 
		if $options = 0 Then
			GUISwitch($op_gui)
			GUISetState(@SW_SHOW,"AFK.safe - Options")		
		EndIf	
	EndIf
;~ 	If $msg[0] = $tm_ctrl[5] Or _IsPressed("23", $dll) Then _lockdown()
	If $msg[0] = $tm_ctrl[5] Then _qlock()
	If $msg[0] = $tm_ctrl[3] Then _WinToTray($wHandle, 1)
	If $msg[0] = $tm_ctrl[4] Then _WinToTray($wHandle, 2)
	If $msg[0] = $tm_ctrl[7] Then Exit		
WEnd

;~ ;; Functions
Func onautoitexit()
	_BlockInputEx(0)
	If $locked = 1 Then
		MsgBox(16, $wHandle, "Please unlock before Exiting!")
	EndIf
	If $locked = 0 Then
		_loadtray(3, "AFK.safe", "Saving!", "Save Complete!")
	EndIf
	If $locked = -1 Then
		_TrayIconDelete($tm_ctrl_ico)
			If $icon_on = 1 Then
				_WinAPI_DestroyIcon($hIcons[0])
				_WinAPI_DestroyIcon($hIcons[1])
			EndIf
	EndIf
;~ 	If $icon_on = 1 Then
;~ 		_WinAPI_DestroyIcon($hIcons[0])
;~ 		_WinAPI_DestroyIcon($hIcons[1])
;~ 	EndIf
	_TrayIconDelete($tm_ctrl_ico)
EndFunc   ;==>onautoitexit
;;
Func exits()
	$locked = -1
	Exit
EndFunc   ;==>exits
;;
Func _loadtray($times = 20, $title = "_loadtray()", $t_msg = "Loading", $f_msg = "Done")
	#cs ----------------------------------------------------------------------------o
		Function: _LoadTray()
		Parameters: $times = "number",  $title = "text-string", "$t_msg = "text-string"
		$times   = The number of times u want the loading pop-up to loop.
		$title       = The Title of the loading pop-up.
		$t_msg = The message u want to include with the load.
	#ce ----------------------------------------------------------------------------
;~ 	For $i = 1 To $times
;~ 		TrayTip($tm_ctrl_ico, $title, "[-] " & $t_msg, 0.100, 1)
;~ 		Sleep(100)
;~ 		TrayTip($tm_ctrl_ico, $title, "[\] " & $t_msg, 0.100, 1)
;~ 		Sleep(100)
;~ 		TrayTip($tm_ctrl_ico, $title, "[|] " & $t_msg, 0.100, 1)
;~ 		Sleep(100)
;~ 		TrayTip($tm_ctrl_ico, $title, "[/] " & $t_msg, 0.100, 1)
;~ 		Sleep(100)
;~ 		If $i = $times Then
;~ 			TrayTip($tm_ctrl_ico, $title, $f_msg, 0.100, 1)
;~ 			Sleep(2000)
;~ 			TrayTip("", "", 1)
;~ 		EndIf
;~ 	Next
EndFunc   ;==>_loadtray
;;
Func _setup($id)
	If $id = 1 Then
		MsgBox(64, $wHandle & " !FIRST RUN!", "You have started AFK.safe for the first time! " & @CRLF & "AFK.safe will now automatically install the files needed!")
		Sleep(1000)
		FileWrite("data\data.ini", "; AFK.Safe - DATA FILE!;" & @CRLF)
		FileWrite("data\data.ini", "; !!!DO NOt MODIFY BELOW!!! ;" & @CRLF)
		FileWrite("data\data.ini", "; !!! CHANGING INFORMATION BELOW CAN CAUSE MALFUNCTION !!! ;" & @CRLF)
		$i_data = "setup=1"
		IniWriteSection("data\data.ini", "main", $i_data, 0)
		_loadtray(5, $wHandle, "Creating Files", "Done! AFK.safe wil now start!")
	EndIf
	If $id = 2 Then
		$i_data = "setup=1"
		IniWriteSection("data\data.ini", "main", $i_data, 0)
	EndIf
EndFunc   ;==>_setup
;;
Func _qhideon()
	_WinToTray($wHandle,1)
EndFunc
Func _qhideoff()
	_WinToTray($wHandle,2)
EndFunc
Func _WinToTray($handle, $function)
	If $function = 1 Then
		$qhide = 1
		GUICtrlSetState($tm_ctrl[3], $GUI_CHECKED)
		GUICtrlSetState($tm_ctrl[3], $TRAY_DISABLE)
		GUICtrlSetState($tm_ctrl[4], $TRAY_ENABLE)
		GUICtrlSetState($tm_ctrl[4], $GUI_UNCHECKED)
		WinSetState($handle, "", @SW_HIDE)
		_TrayTip($tm_ctrl_ico, $wHandle, "Minimized to Tray", 2)
		Sleep(2000)
		_TrayTip($tm_ctrl_ico, "", "", 2)
	EndIf
	If $function = 2 Then
		$qhide = 0
		GUICtrlSetState($tm_ctrl[3], $TRAY_ENABLE)
		GUICtrlSetState($tm_ctrl[3], $GUI_UNCHECKED)
		GUICtrlSetState($tm_ctrl[4], $GUI_CHECKED)
		GUICtrlSetState($tm_ctrl[4], $TRAY_DISABLE)
		WinSetState($handle, "", @SW_RESTORE)
		_TrayTip($tm_ctrl_ico, $wHandle, "Restored from Tray", 2)
		Sleep(2000)
		_TrayTip($tm_ctrl_ico, "", "", 2)
		Sleep(100)
	EndIf
EndFunc   ;==>_WinToTray
;;
func _qlock()
	if $qhide = 1 then _WinToTray($wHandle,2)
	_lockdown()
EndFunc

Func _lockdown()
	WinActivate($wHandle, "")
	$password_in = InputBox("AFK,safe " & $ver & " - Choose you password!", "Enter your password (only numbers!).", "", "*")
	If $password_in < " " Then 
		_TrayTip($tm_ctrl_ico, $wHandle, "Please enter a password!", 2)
		Sleep(2000)
		_TrayTip($tm_ctrl_ico, "", "", 2)
	EndIf
	If StringIsAlNum($password_in) = 0 Then
		$xy = MouseGetPos()
		ToolTip("Please enter a password with only numbers!", $xy[0], $xy[1])
		Sleep(2000)
		ToolTip("")
	Else
		$password_crypt = crypt(1, $password_in, "AFK.safe.decrypt.pass")
		If FileExists(@HomeDrive & "\WINDOWS\Temp\Temp1337.ini") Then FileDelete(@HomeDrive & "\WINDOWS\Temp\Temp1337.ini")
		FileWrite(@HomeDrive & "\WINDOWS\Temp\Temp1337.ini", "")
		IniWrite(@HomeDrive & "\WINDOWS\Temp\Temp1337.ini", "afksafe", "cpass", $password_crypt)
		GUICtrlSetState($unlock, $GUI_ENABLE)
		Global $locked = 1
		_BlockInputEx(3)
		GUICtrlSetData($pass, "")
		_GUICtrlStatusBar_SetText($hStatus, "LOCKED", 1)
		$hIcons[1] = _WinAPI_LoadImage(0, "data\ico\lock.ico", $IMAGE_ICON, 14, 14, $LR_LOADFROMFILE + $LR_DEFAULTCOLOR)
		_GUICtrlStatusBar_SetIcon($hStatus, 1, $hIcons[1])
		GUICtrlSetStyle($header, -1, -1)
	EndIf
	While $locked = 1
		WinMove($mGUI, "", $xi, $yi)
		If ProcessExists("taskmgr.exe") Then ProcessClose("taskmgr.exe")
		$coords = WinGetPos($mGUI)
		_MouseTrap($coords[0], $coords[1], $coords[0] + $coords[2], $coords[1] + $coords[3])
		$msg = GUIGetMsg(1)
		If $msg[0] = $buttons[0] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "0")
		If $msg[0] = $buttons[1] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "1")
		If $msg[0] = $buttons[2] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "2")
		If $msg[0] = $buttons[3] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "3")
		If $msg[0]= $buttons[4] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "4")
		If $msg[0] = $buttons[5] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "5")
		If $msg[0] = $buttons[6] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "6")
		If $msg[0] = $buttons[7] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "7")
		If $msg[0] = $buttons[8] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "8")
		If $msg[0] = $buttons[9] Then GUICtrlSetData($pass, GUICtrlRead($pass) & "9")
		If $msg[0] = $reset Then GUICtrlSetData($pass, "")
		If $msg[0] = $unlock Then
			$read_ini = IniRead(@HomeDrive & "\WINDOWS\Temp\Temp1337.ini", "afksafe", "cpass", "")
			$password_decrypt = crypt(0, $read_ini, "AFK.safe.decrypt.pass")
			If $password_decrypt = GUICtrlRead($pass) Then
				_BlockInputEx(0)
				GUICtrlSetState($unlock, $GUI_DISABLE)
				Global $locked = 0
				GUICtrlSetData($pass, "")
				If $locked = 0 Then
					_MouseTrap()
					MsgBox(64, $wHandle, "AFK.safe UNLOCKED!!",3)
					_GUICtrlStatusBar_SetText($hStatus, "Unlocked", 1)
					$hIcons[1] = _WinAPI_LoadImage(0, "data\ico\unlocked.ico", $IMAGE_ICON, 14, 14, $LR_LOADFROMFILE + $LR_DEFAULTCOLOR)
					_GUICtrlStatusBar_SetIcon($hStatus, 1, $hIcons[1])
					GUICtrlSetStyle($header, -1, $GUI_WS_EX_PARENTDRAG)
				EndIf
			Else
				MsgBox(16, "AFK.safe - ERROR!", "Password is incorrect!",3)
				GUICtrlSetData($pass, "")
			EndIf
		EndIf
	WEnd
EndFunc   ;==>_lockdown
;;
Func _skin($id)
	If $id = 1 Then
		_SetTrayBkColor(0x000000)
		_SetTrayIconBkColor(0x000000)
;~ 		_SetTrayIconBkGrdColor(0xFFFFFF)
		_SetTrayIconBkGrdColor(0xCCCCCC)
		_SetTrayIconBkGrdColor(0x545454)
		_SetTraySelectRectColor(0x00FF00)
		_SetTraySelectTextColor(0x00FF00)
		_SetTraySelectBkColor(0x000000)
		_SetTrayTextColor(0x00FF00)
	EndIf
EndFunc   ;==>_skin
;;


Func _save($type)	
	   if $type = -1 Then 
			_TrayTip($tm_ctrl_ico,$wHandle&" - Save settings","No changes made, nothing will be saved!",2)
			sleep(2000)
			_TrayTip($tm_ctrl_ico,"","")
			$checked = 1
		EndIf
		if $type = 1 Then
			dim $s_type[1]
			$s_type[0] = "You are about to replace your current quick lock hotkey: "&$qLockKey&" for a new quick lock hotkey: "& $newLockKey&@CRLF&"Are you sure?"
			$save_check = MsgBox(052,$wHandle&" - Save Settings",$s_type[0])
			$checked = 1
		EndIf		
		if $type = 2 Then
			dim $s_type[1]
			$s_type[0] = "You are about to replace your current quick hide hotkey: "&$qHideKey&" for a new quick hide hotkey: "& $newHideKey&@CRLF&"Are you sure?"
			$save_check = MsgBox(052,$wHandle&" - Save Settings",$s_type[0])
			$checked = 1
		EndIf		
		if $type = 3 Then
			dim $s_type[1]
			$s_type[0] = "You are about to replace your current quick lock hotkey: "&$qLockKey&" for the hotkey: "& $newLockKey&"."&@CRLF&"And you are about to replace your current quick hide hotkey: "&$qHideKey&" for the hotkey: "&$newHideKey&@CRLF&"Are you sure?"
			$save_check = MsgBox(052,$wHandle&" - Save Settings",$s_type[0])
			$checked = 1
		EndIf
		if $checked = 1 Then
			If $save_check = 6 then
				$sLockKey = IniWrite("data\data.ini","main","qlockkey",$newLockKey)
				$sHideKey = IniWrite("data\data.ini","main","qhidekey",$newHideKey)
				Global $qLockKey = IniRead("data\data.ini","main","qlockkey","{END}")
				Global $qHideKey = IniRead("data\data.ini","main","qhidekey","{HOME}")
				GUICtrlSetData($curr_l,"{"&$qLockKey&"}")
				GUICtrlSetData($cur_h,"{"&$qHideKey&"}") 
				HotKeySet("{"&$qLockKey&"}", "_qlock")
				HotKeySet("{"&$qHideKey&"}", "_qhideon")
				MsgBox(64,$wHandle&" - Settings saved!","Your setting has been saved!")
			EndIf
			if $save_check = 7 then 
				MsgBox(0,$wHandle&" - Save Settings","You have selected not to save the hotkey(s)."&@CRLF&"Press ok to continue.",0,"AFK.safe - Options")			
			EndIf
		EndIf
EndFunc