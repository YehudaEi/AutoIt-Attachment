; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.103
; Author:         	Michael
;
; Script Function:	Start your favorite application from tray
;
;Date:				23.05.2006 Start scripting
;ChangeLog			24.05.2006 Reduce Memory usage / Code from Valuater 
;					IF Slide out Config Mode Off
;					26.05.2006 Tooltip / Func Reset Toolbar
;					27.05.2006 Use Setup Icon if not configured
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <constants.au3>
#NoTrayIcon
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode", 1)
TraySetClick(16)
Global $Button[11],$x
Global $app="TrayToolBar"
Global $ConfigFlag=0
Global $LockFlag=0
Global $IniFile=@ScriptDir&"\"& $app &".TCF"
$font="Comic Sans MS"
$TimerStart = 0
$appWidth=50
$appHeight=405
$Speed=500
_checkIni()
$MainHwnd=GUICreate($app,$appWidth,$appHeight,@DesktopWidth-$appWidth,@DesktopHeight-$appHeight-30,($WS_SYSMENU),BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST ) )
GUISetFont (8, -1, 0, $font)
GUISetBkColor("0xCCCCCC",$MainHwnd)
$Button[1] = GUICtrlCreateButton("Setup", 5, 2, 35, 35,BitOR($BS_ICON,$BS_CENTER) )
$Button[2] = GUICtrlCreateButton("Setup", 5, 40, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[3] = GUICtrlCreateButton("Setup", 5, 78, 35, 35,BitOR($BS_ICON,$BS_CENTER))
$Button[4] = GUICtrlCreateButton("Setup", 5, 116, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[5] = GUICtrlCreateButton("Setup", 5, 154, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[6] = GUICtrlCreateButton("Setup", 5, 192, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[7] = GUICtrlCreateButton("Setup", 5, 230, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[8] = GUICtrlCreateButton("Setup", 5, 268, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[9] = GUICtrlCreateButton("Setup", 5, 306, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[10] = GUICtrlCreateButton("Setup", 5, 344, 35, 35, BitOR($BS_ICON,$BS_CENTER))
_ReDrawButton()
;------------Tray Settings------------
$TrayMnuShow= TrayCreateItem("Show")
TrayItemSetOnEvent(-1, "_slide_in")
$TrayMnuOption=TrayCreateMenu("Options")
$TrayMnuLock=TrayCreateItem("Lock Toolbar",$TrayMnuOption)
TrayItemSetOnEvent(-1, "_LockBar")
TrayCreateItem("",$TrayMnuOption)
$TrayMnuLoad=TrayCreateItem("Load Settings",$TrayMnuOption)
TrayItemSetOnEvent(-1, "_LoadSettings")
$TrayMnuSaveAs=TrayCreateItem("Save Settings",$TrayMnuOption)
TrayItemSetOnEvent(-1, "_SaveSettings")
$TrayMnuReset=TrayCreateItem("Reset current Toolbar",$TrayMnuOption)
TrayItemSetOnEvent(-1, "_ResetSettings")
$TrayMnuSetup=TrayCreateItem("Setup Mode")
TrayItemSetOnEvent(-1, "_ConfigOn")
TrayCreateItem("")
$TrayMnuExit= TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Exit")
TraySetState()
_slide_in();Start

_main()

Func _main()
	while 1
		if TimerDiff($TimerStart) > 60000 then
			_ReduceMemory()	
			$TimerStart = TimerInit()
		EndIF
		$Msg = GUIGetMsg()
		$trayMsg =TrayGetMsg()
	Select
		Case  $Msg=$Button[1]
			$x=1
			_checkAction()
		Case  $Msg=$Button[2]
			$x=2
			_checkAction()
		Case  $Msg=$Button[3]
			$x=3
			_checkAction()
		Case  $Msg=$Button[4]
			$x=4
			_checkAction()
		Case  $Msg=$Button[5]
			$x=5
			_checkAction()
		Case  $Msg=$Button[6]
			$x=6
			_checkAction()
		Case  $Msg=$Button[7]
			$x=7
			_checkAction()
		Case  $Msg=$Button[8]
			$x=8
			_checkAction()
		Case  $Msg=$Button[9]
			$x=9
			_checkAction()
		Case $Msg=$Button[10]
			$x=10
			_checkAction()
		Case $Msg=$GUI_EVENT_CLOSE
			_slide_out()
		EndSelect
	wend
	Sleep(100)
EndFunc



Func _checkAction()
	If $ConfigFlag=1 or GUICtrlRead($Button[$x])="Setup" then
			_SetupButton()
			Else
			;Start Program
			$var=IniRead($IniFile,$app,"Button"&$x,"")
			run($var)
			_slide_out()
			EndIf		
EndFunc	

Func _SetupButton()
$var=FileOpenDialog("Select Program",@ProgramFilesDir&"\","Programs (*.exe)")
if not @error Then
Iniwrite($IniFile,$app,"Button"&$x,$var)
_ConfigOff()
_ReDrawButton()
Else
_ConfigOff()	
EndIf	
EndFunc	

Func _slide_in()
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $MainHwnd, "int", $Speed, "long", 0x00040008);slide-in from bottom
GUISetState(@SW_SHOW, $MainHwnd)
EndFunc

Func _slide_out()
	if $ConfigFlag=1 then _ConfigOff()
if $LockFlag=0 then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $MainHwnd, "int", $Speed, "long", 0x00050004);slide-out to bottom	
EndFunc

Func _ConfigOn()
$ConfigFlag=1	
 GUISetBkColor("0xF00000",$MainHwnd)
 GUISetCursor(3,1)
_slide_in()
EndFunc	

Func _ConfigOff()
	$ConfigFlag=0	
	GUISetBkColor("0xCCCCCC",$MainHwnd)
	GUISetCursor(2,1)
	_slide_in()
EndFunc	

Func _checkIni()
	If not FileExists($IniFile) Then ;create new ini
		for $i=1 to 10
			IniWrite($IniFile,$app,"Button"&$i,"Setup")
		next
			IniWrite($IniFile,$app,"LastConfig",$IniFile)
		Else
		$var=IniRead($IniFile,$app,"LastConfig",$IniFile)
		if $var<>$IniFile then $IniFile=$var
	EndIf

EndFunc

Func _ReDrawButton()
	for $i=1 to 10
	$var=IniRead($IniFile,$app,"Button"&$i,"Setup")
	If $var="Setup" Then
		GUICtrlSetImage($Button[$i], 'shell32.dll', 162, $BS_ICON) ;Use setup Icon 
		GUICtrlSetData($Button[$i],"Setup")
		GUICtrlSetTip($Button[$i],"Click to Setup")
Else	
	$file=IniRead($IniFile,$app,"Button"&$i,"")
	GUICtrlSetImage($Button[$i],$file,"Button"&$i,1)
	GUICtrlSetData($Button[$i],$i)
	GUICtrlSetTip($Button[$i],StringTrimLeft($file,StringInStr($file,"\",0,-1)))
	EndIf
	next
EndFunc	

Func _lockBar()
	if $LockFlag=0 Then
		_slide_in()
		$LockFlag=1
		TrayItemSetState($TrayMnuLock,$TRAY_CHECKED)
	Else
		$LockFlag=0
		TrayItemSetState($TrayMnuLock,$TRAY_UNCHECKED)
	EndIf		
	
EndFunc	

Func _SaveSettings()
$file=FileSaveDialog($app,@ScriptDir&"\","TrayToolBar Profile (*.tcf)")
if not @error then
	if StringRight($file,4)<>".tcf" then $file=$file &".tcf"
		Dim $aRecords
		If Not _FileReadToArray($IniFile,$aRecords) Then
		MsgBox(4096,"Error", " Error reading settings     error:" & @error)
	Else
	_FileWriteFromArray($file,$aRecords,1)
	IniWrite($IniFile,$app,"LastConfig",$file)	
	$IniFile=$file
	EndIf
EndIf
EndFunc	

Func _LoadSettings()
$file=FileOpenDialog($app,@ScriptDir&"\","Config (*.tcf)",1,"TrayToolBar.tcf")
	if Not @error Then
	$IniFile=$file
	_ReDrawButton()
	EndIf	
EndFunc	

Func _ResetSettings()
$var=MsgBox(4,$app,"Shure reset all settings "&$app&" ?")
		if $var=6 Then
			for $i=1 to 10
			Iniwrite($IniFile,$app,"Button"&$i,"Setup")
			Next	
		EndIf
		_ReDrawButton()
EndFunc	


Func _exit()
$LockFlag=0	
IniWrite(@ScriptDir&"\"& $app&".tcf",$app,"LastConfig",$IniFile)	
_slide_out()
exit
EndFunc	



Func _ReduceMemory($i_PID = -1);from Valuater see http://www.autoitscript.com/forum/index.php?showtopic=19370&hl=
    
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    Return $ai_Return
EndFunc;==> _ReduceMemory()
