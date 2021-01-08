; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.103
; Author:         	Michael
;
; Script Function:	Start your favorite application from tray
;
;Date:				23.05.2006 Start scripting Traytoolbar
;ChangeLog			24.05.2006 Reduce Memory usage / Code from Valuater 
;					IF Slide out Config Mode Off
;					26.05.2006 Tooltip / Func Reset Toolbar
;					27.05.2006 Use Setup Icon if not configured
;					28.05.2006 Use Config Panel with more settings Parameter & userdefined Tooltip
;					02.06.2006 Select Icon from Dll or cpl or exe / F10 for config mode
;			
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <constants.au3>
#NoTrayIcon
HotKeySet("{F10}","_ConfigOn")
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode", 1)
TraySetClick(16)
Global $Button[11],$x,$file,$IconFile,$IconID,$ConfigSelectIcon
Global $app="TrayToolBar"
Global $ConfigFlag=0
Global $LockFlag=0
Global $IniFile=@ScriptDir&"\"& $app &".tcf"
$font="Comic Sans MS"
$TimerStart = 0
$appWidth=50
$appHeight=405
$Speed=500
_checkIni()
$MainHwnd=GUICreate($app,$appWidth,$appHeight,@DesktopWidth-$appWidth,@DesktopHeight-$appHeight-30,($WS_SYSMENU),BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST ) )
GUISetFont (8, -1, 0, $font)
GUISetBkColor("0xCCCCCC",$MainHwnd)
$Button[1] = GUICtrlCreateButton("Setup", 5, 2, 35, 35,BitOR($BS_ICON,$BS_CENTER))
$Button[2] = GUICtrlCreateButton("Setup", 5, 40, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[3] = GUICtrlCreateButton("Setup", 5, 78, 35, 35,BitOR($BS_ICON,$BS_CENTER))
$Button[4] = GUICtrlCreateButton("Setup", 5, 116, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[5] = GUICtrlCreateButton("Setup", 5, 154, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[6] = GUICtrlCreateButton("Setup", 5, 192, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[7] = GUICtrlCreateButton("Setup", 5, 230, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[8] = GUICtrlCreateButton("Setup", 5, 268, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[9] = GUICtrlCreateButton("Setup", 5, 306, 35, 35, BitOR($BS_ICON,$BS_CENTER))
$Button[10] = GUICtrlCreateButton("Setup", 5, 344, 35, 35, BitOR($BS_ICON,$BS_CENTER))
;second gui for settings
$configHwnd=GUICreate("Settings",250,250,@DesktopWidth-250-$appWidth,@DesktopHeight-$appHeight-30,$WS_SYSMENU,$WS_EX_TOPMOST)
$ConfigLabel1=GUICtrlCreateLabel("Application",10,10)
$ConfigInput1=GUICtrlCreateInput("",30,30,180,20)
$ConfigButton1=GUICtrlCreateButton("@",10,30,20,20)
GUICtrlSetTip($ConfigButton1,"Select application")
$ConfigLabel2=GUICtrlCreateLabel("Parameters",10,60)
$ConfigInput2=GUICtrlCreateInput("",10,80,190,20)
$configLabel3=GUICtrlCreateLabel("Tooltip",10,110,100,20)
$ConfigInput3=GUICtrlCreateInput("",10,130,190,20)
$configLabel4=GUICtrlCreateLabel("Icon",10,155)
$ConfigIcon=GUICtrlCreateButton("",10,170,35,35,$BS_ICON)
$ConfigButton2=GUICtrlCreateButton("Save",170,190,70,20)
GUISetState(@SW_HIDE,$configHwnd)
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
		;$trayMsg =TrayGetMsg()
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
		Case $Msg=$ConfigButton1
			_ConfigButton()	
		Case $Msg=$ConfigButton2
			_SaveButtonSettings()
			GUISetState(@SW_HIDE,$configHwnd)
			_ReDrawButton()
			_ConfigOff()
		Case $Msg=$ConfigIcon
		;Select Icon from file
		_PickIcon()
		
		$var=StringSplit($ConfigSelectIcon,",")
		GUICtrlSetImage($ConfigIcon,$var[1],$var[2])
		
		Case $Msg=$GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE,$configHwnd)
			_slide_out()
		EndSelect
	wend
	Sleep(200)
EndFunc

Func _checkAction()
	If GUICtrlRead($Button[$x])="Setup" and $ConfigFlag=0 then
			$file=""
			GUICtrlSetData($ConfigInput1,"")
			GUICtrlSetData($ConfigInput2,"")
			GUICtrlSetData($ConfigInput3,"")
			GUICtrlSetImage($ConfigIcon,"shell32.dll",162)
			
			GUISetState(@SW_SHOW,$configHwnd)
			ElseIf $ConfigFlag=1 then
			$file=IniRead($IniFile,$app,"Button"&$x,"")
			GUICtrlSetData($ConfigInput1,StringTrimLeft($file,StringInStr($file,"\",0,-1)))
			GUICtrlSetData($ConfigInput2,IniRead($IniFile,$app,"Parameter"&$x,""))
			GUICtrlSetData($ConfigInput3,IniRead($IniFile,$app,"ToolTip"&$x,StringTrimRight(StringTrimLeft($file,StringInStr($file,"\",0,-1)),4)))
			;read Icon 
			$ConfigSelectIcon=IniRead($IniFile,$app,"Icon"&$x,"")
			$var=StringSplit($ConfigSelectIcon,",")
			GUICtrlSetImage($ConfigIcon,$var[1],$var[2])		
			GUISetState(@SW_SHOW,$configHwnd)
	Else
			;Start Program
			$var=IniRead($IniFile,$app,"Button"&$x,"")
			$param=IniRead($IniFile,$app,"Parameter"&$x,"")
				if $param<>"" Then
					run($var&" "&$param)
				Else
					run($var)
				EndIf
			_slide_out()
	EndIf		
EndFunc	

Func _ConfigButton()
	GUISetState(@SW_SHOW,$configHwnd)
	$file=FileOpenDialog("Select Program",@ProgramFilesDir&"\","Programs (*.exe;*.cmd)")
	if not @error Then
	GUICtrlSetData($ConfigInput1,StringTrimLeft($file,StringInStr($file,"\",0,-1)))
	GuiCtrlSetData($ConfigInput3,StringTrimRight(StringTrimLeft($file,StringInStr($file,"\",0,-1)),4))
	$var=StringRight($file,3)
		If $var="exe" Then
		$ConfigSelectIcon=$file&",0"	
		
		GUICtrlSetImage($ConfigIcon,$file,0)
		Else
		$ConfigSelectIcon="shell32.dll,2"
		GUICtrlSetImage($ConfigIcon,"shell32.dll",2)
		EndIf
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
			Iniwrite($IniFile,$app,"Parameter"&$i,"")
			Iniwrite($IniFile,$app,"ToolTip"&$i,"Click to Setup")
			IniWrite($IniFile,$app,"Icon"&$i,"shell32,162")
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
Else ;button has configured	
	$file=IniRead($IniFile,$app,"Button"&$i,"")
	GUICtrlSetData($Button[$i],$i)
	$ConfigSelectIcon=IniRead($IniFile,$app,"Icon"&$i,"")
	$var=StringSplit($ConfigSelectIcon,",")
	GuiCtrlsetImage($Button[$i],$var[1],$var[2])
	$var=IniRead($IniFile,$app,"ToolTip"&$i,"")
	if $var <>"" Then
		GUICtrlSetTip($Button[$i],$var)
		else
		GUICtrlSetTip($Button[$i],StringTrimRight(StringTrimLeft($file,StringInStr($file,"\",0,-1)),4))
		EndIf
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

Func _SaveButtonSettings()
	if GUICtrlRead($ConfigInput1)<>"" then
		Iniwrite($IniFile,$app,"Button"&$x,$file)
		IniWrite($IniFile,$app,"Parameter"&$x,GUICtrlRead($ConfigInput2))
		Iniwrite($IniFile,$app,"Tooltip"&$x,GUICtrlRead($ConfigInput3))
		Iniwrite($IniFile,$app,"Icon"&$x,$ConfigSelectIcon)
	EndIf
$ConfigFlag=0
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
			Iniwrite($IniFile,$app,"Parameter"&$i,"")
			Iniwrite($IniFile,$app,"ToolTip"&$i,"Click to Setup")
			Iniwrite($IniFile,$app,"Icon"&$i,"shell32.dll,162")			
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

Func _PickIcon() ;Taken from helpfile ;-)
	$sFileName  = $file

; Create a strcuture to store the icon index
$stIcon     =  DllStructCreate("int")

If @OSType = "WIN32_NT" Then
    ; Convert and store the filename as a wide char string
    $nBuffersize    = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $sFileName, "int", -1, "ptr", 0, "int", 0)
    $stString       = DLLStructCreate("byte[" & 2 * $nBuffersize[0] & "]")
    DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $sFileName, "int", -1, "ptr", DllStructGetPtr($stString), "int", $nBuffersize[0])
Else
    ; Win'9x
    $stString       = DLLStructCreate("char[260]")
    DllStructSetData($stString, 1, $sFileName)
EndIf

;Run the PickIconDlg - '62' is the ordinal value for this function
DllCall("shell32.dll", "none", 62, "hwnd", 0, "ptr", DllStructGetPtr($stString), "int", DllStructGetSize($stString), "ptr", DllStructGetPtr($stIcon))

If @OSType = "WIN32_NT" Then
    ; Convert the new selected filename back from a wide char string
    $nBuffersize    = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "int", 0, "int", 0x00000200, "ptr", DllStructGetPtr($stString), "int", -1, "ptr", 0, "int", 0, "ptr", 0, "ptr", 0)
    $stFile         = DLLStructCreate("char[" & $nBuffersize[0] & "]")
    DllCall("kernel32.dll", "int", "WideCharToMultiByte", "int", 0, "int", 0x00000200, "ptr", DllStructGetPtr($stString), "int", -1, "ptr", DllStructGetPtr($stFile), "int", $nBuffersize[0], "ptr", 0, "ptr", 0)
    $sFileName      = DllStructGetData($stFile, 1)
Else
    $sFileName      = DllStructGetData($stString, 1)
EndIf

$nIconIndex         = DllStructGetData($stIcon, 1)

$stBuffer   = 0
$stFile     = 0
$stIcon     = 0
$ConfigSelectIcon=$sFileName&","&$nIconIndex
return $ConfigSelectIcon
EndFunc


Func _ReduceMemory($i_PID = -1);from Valuater see http://www.autoitscript.com/forum/index.ph...topic=19370&hl=
    
   If $i_PID <> -1 Then
Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
Else
Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
EndIf
If @error Then Return 1
Return $ai_Return[0]
EndFunc;==> _ReduceMemory()
