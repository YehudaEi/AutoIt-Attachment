#NoTrayIcon
#AutoIt3Wrapper_Res_Comment=Built for Highland Elementary School 
#AutoIt3Wrapper_Res_Description=Cross Computer Lab Automation System
#AutoIt3Wrapper_Res_Fileversion=3.1
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement= P
#AutoIt3Wrapper_Res_LegalCopyright=Jon Cross
#AutoIt3Wrapper_Run_Tidy=y
#Include <File.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Misc.au3>
#include <Timers.au3>
#include <string.au3>
#include <ChangeResolution.au3>
#include <Process.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include <Array.au3>
if _Singleton("CrossAutomation",1) = 0 Then
    Msgbox(0,"Warning","An occurence of Computer Lab Automation is already running.", 10)
    Exit
EndIf
Global $ControlerType
 If $cmdline[0] > 0 Then
	Switch $cmdline[1]
	Case "HEARTS", "-h"
		$ControlerType = "Hearts Lab Controler"
		Global $Server = "\\adm-24-server01\rcdata\ComputerAutomation\HEARTS Lab Commands"
		$Switch = "HEARTS"
	EndSwitch
	Else
		Global $Server = "\\adm-24-server01\rcdata\ComputerAutomation\Computer Lab Commands"
		$Switch = "Lab"
		$ControlerType = "Computer Lab Controler"
		EndIf
Opt("TrayMenuMode",1)
Global $Local ="C:\HighlandAutomation"
Global $iIdleTime
$Refresh  = TrayCreateItem("Refresh Computer", -1, 0)
$teacher = TrayCreateItem("Teacher Mode", -1, 1)
$close = TrayCreateItem("Exit", -1, 9)
$admin = TrayCreateItem("Admin Mode", -1, 2)
TraySetIcon("Shell32.dll",13)
TraySetState()
MainSystem()

Func MainSystem()
While 1
	$iIdleTime = _Timer_GetIdleTime()	
	IF FileExists("C:\thinclient") Then 
		Exit
	ElseIf $iIdleTime > 1800000 Then ;#30 Minute Idle time 
		DesktopRefresh()
	Elseif not ProcessExists("Rules.exe") AND $iIdleTime > 600000 Then ;#10 Minute Idle time 
		Run($Local&"\Rules.exe")
	Elseif FileExists($Server&"\garfield") Then
		Garfield()
	ElseIF FileExists($Server&"\shutdown")Then
		shutdown (8)
	ElseIF FileExists($Server&"\logoff")Then
		Shutdown (0)
	ElseIF FileExists($Server&"\reboot")Then
		Shutdown (2)
	ElseIf FileExists($Server&"\ProcessClose")Then
		ProcessClose1()
	ElseIf FileExists($Server&"\ProcessOpen")Then
		ProcessOpen()
	Elseif FileExists($Server&"\OpenWeb")Then
		OpenWeb()
	ElseIF FileExists($Server&"\nonet")Then
		ProcessClose("IExplore.exe")
	ElseIF FileExists($Server&"\xattack") Then
		ProcessClose("TimezAttackLauncher.exe")
		ProcessClose("BigBrainz_TimezAttackWin.exe")
	ElseIf FileExists($Server&"\mute") Then
		Send("{VOLUME_MUTE}")
		Sleep(100)
	ElseIf FileExists($Server&"\attentionON")Then
		Attention()		
	ElseIf FileExists($Server&"\messageON")Then
		Message()
	ElseIf FileExists($Server&"\TakeAttendance")Then
		Attendance()
	ElseIf FileExists($Server&"\ClassResponce")Then
		ClassResponce()
	ElseIf FileExists($Server&"\refresh") Then
		DesktopRefresh()
		Sleep(10000)
	ElseIf FileExists($Server&"\Printeroff")Then
		PrinterOff()
	ElseIf FileExists($Server&"\PrinterOn")Then
		PrinterOn()
	ElseIF ProcessExists("GoogleTalk.exe")Then
		ProcessClose("GoogleTalk.exe")
	ElseIF @ComputerName = "Hil-Jcross" Then
		_Controler()
	EndIf
	$msg = TrayGetMsg()	
Select
	Case $msg  = 0
		ContinueLoop
	Case $msg = $refresh
		DesktopRefresh()
	Case $msg = $close
		close()
	Case $msg = $teacher
		Teacher()
	Case $msg = $admin
		_StartControler()
	EndSelect
WEnd
EndFunc

Func Close()
	$var = IniReadSection($Server&"\settings.ini", "exit")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$password = $var[$i][1]
	$decript = _HexToString($password)
Next	
	$passwd = InputBox("Security Check", "Enter Exit password.", "", "*", 190, 115,-1,-1, 5)
IF $passwd = $decript then 	
	Exit
Else
	MsgBox(48, "Wrong Password", "Sorry, that was not the correct Password!",3)
EndIf
EndIf
EndFunc

Func ProcessClose1()
$var = IniReadSection($Server&"\settings.ini", "Process")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$Process = $var[$i][1]
Next
ProcessClose($Process)
EndIf
EndFunc

Func ProcessOpen()
$var = IniReadSection($Server&"\settings.ini", "Process")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$Process = $var[$i][1]
Next
Run($Process)
Sleep(3000)
EndIf
EndFunc

Func PrinterOff()
	RunASWait("areyjones", "rusd.edu", "heretohelp", 0,  @ComSpec & " /C net Stop Spooler", "",@SW_HIDE)
	TraySetIcon("Shell32.dll",48)
	TraySetState(4)
EndFunc

Func PrinterOn()
	RunASWait("areyjones", "rusd.edu", "heretohelp", 0,  @ComSpec & " /C net Start Spooler", "",@SW_HIDE)
	TraySetIcon("Shell32.dll",13)
	TraySetState(16)
EndFunc

Func OpenWeb()
$var = IniReadSection($Server&"\settings.ini", "Process")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$Process = $var[$i][1]
Next
Run("C:\Program Files\Internet Explorer\iexplore.exe "&$Process)
Sleep(3000)
EndIf
EndFunc

Func Teacher()
$var = IniReadSection($Server&"\settings.ini", "teacher")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$password = $var[$i][1]
	$decript = _HexToString($password)
Next	
$passwd = InputBox("Security Check", "Enter Teacher password.", "", "*", 190, 115,-1,-1,5)
IF $passwd = $decript then 	
	PrinterOn()
	TeacherMode()
Else
	MsgBox(48, "Wrong Password", "Sorry, that was not the correct Password!",3)
EndIf
EndIf
EndFunc

Func TeacherMode()
	$CompName = @ComputerName
	$Date =_NowDate()
	$Time = _NowTime()
	$Exit = TrayCreateItem("Exit Teacher Mode", -1, 1)
	TrayItemDelete($Teacher)
	TraySetState()
	TraySetIcon("Shell32.dll",45)
	TraySetState(4)
	IniWrite($Server&"\settings.ini", $CompName, $Date, $Time)
	TrayTip("Teacher Mode", "This Computer is in Teacher Mode. Click HERE when Done.", 30, 1)
	While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $exit
			ExitLoop
		Case FileExists($Server&"\teacheroff")
			Exitloop
		EndSelect
	WEnd
	TrayItemDelete($Exit)
	INIDelete($Server&"\settings.ini", $CompName)
	TraySetIcon("Shell32.dll",13)
	TraySetState(16)
	$teacher = TrayCreateItem("Teacher Mode", -1, 1)
EndFunc

Func Attention()
	$var1 = IniReadSection($Server&"\settings.ini", "attention")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var1[0][0]
	$color = $var1[$i][1]
Next
BlockInput(1)
GUICreate("Attention", @DesktopWidth + 10, @DesktopHeight +35, -1, -1, -1, $WS_EX_TOPMOST)
GUISetBkColor($color)
GUISetState(@SW_SHOW)
While 1
If FileExists($Server&"\attentionOFF") Then ExitLoop
	WEnd
	GUIDelete()
	BlockInput(0)
	EndIf
EndFunc

Func Attendance()
	Local $Name
	$Name = Inputbox("Attendance", "Enter Your First and Last Name","","","","",-1,-1,60)
	WinSetonTop("Welcome to the Highland Computer Lab", "", 0)
	WinSetOnTop("Attendance","",1)
	FileWriteLine($Server&"\Attendance.txt", $Name)
	FileClose($Server&"\Attendance.txt")
	MsgBox(0, "Thank You", "Thank You", 10)
EndFunc

Func ClassResponce()
$var6 = IniReadSection($Server&"\settings.ini", "question")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var6[0][0]
	$Question = $var6[$i][1]
Next
	$Name = Inputbox("Class Question",$Question&" Before your answer type your name.","","","","",-1,-1,60)
	WinSetonTop("Welcome to the Highland Computer Lab", "", 0)
	WinSetOnTop("Class Question","",1)
	FileWriteLine($Server&"\Answers.txt", $Name)
	FileClose($Server&"\Answers.txt")
	MsgBox(0, "Thank You", "Thank You", 10)
	EndIf
EndFunc

Func Message()
$var2 = IniReadSection($Server&"\settings.ini", "message")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var2[0][0]
	$message = $var2[$i][1]
Next
	GUICreate("Attention", 355, 125, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOPMOST)
	GUISetFont(10, 400)
	GUICtrlCreateedit($Message, 1, 1, 325,115, $ES_READONLY, $WS_EX_TRANSPARENT )
	GUISetState()
	While 1
If FileExists($Server&"\messageOFF") Then 
	ExitLoop
	Endif
	WEnd
	GUIDelete()
	EndIf
EndFunc

Func Garfield()
	Blockinput(1)
	If FileExists($server&"\garfield") Then
	Splashimageon("Do I Look like I am Kidding?", $Local&"\garfield.bmp")
	Sleep(1000)
	Endif
	If FileExists($Server&"\garfieldoff") Then
	SplashOff()
	BlockInput(0)
	EndIf
EndFunc

Func DesktopRefresh()
Processclose("Rules.exe")
BlockInput(1)
;#Change Screen Res
IF @ComputerName = "Hil-Jcross" Then
$iWidth = 1280
$iHeight = 1024
$iBitsPP = 32
$iRefreshRate = 60
$vRes = _ChangeScreenRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
Else
$iWidth = 1024
$iHeight = 768
$iBitsPP = 32
$iRefreshRate = 60
$vRes = _ChangeScreenRes($iWidth, $iHeight, $iBitsPP, $iRefreshRate)
EndIf
If @error Then
MsgBox(262160, "ERROR", "Unable to change screen Resolution")
EndIf
;#End Change Screen
SplashImageOn("Welcome to Highland Elementary School", $Local&"\splash.bmp");Splash Screen durring scrip run time
;Deletes all icons on the local accound desktop.
FileDelete(@DesktopDir &"\*.*") 
;Office Icons are created in only Office Version 2002, 2003 and 2007.
IF FileExists("C:\Program Files\Microsoft Office\Office11\WinWord.exe") Then
FileCreateShortcut("C:\Program Files\Microsoft Office\Office11\WinWord.exe", @Desktopdir & "\Word","C:\Program Files\Microsoft Office\Office11","","","C:\Program Files\Microsoft Office\Office11\WinWord.exe")
FileCreateShortcut("C:\Program Files\Microsoft Office\Office11\PowerPNT.exe", @Desktopdir & "\Power Point","C:\Program Files\Microsoft Office\Office11","","","C:\Program Files\Microsoft Office\Office11\PowerPNT.exe")
Elseif FileExists("C:\Program Files\Microsoft Office\Office10\WinWord.exe") Then
FileCreateShortcut("C:\Program Files\Microsoft Office\Office10\WinWord.exe", @Desktopdir & "\Word","C:\Program Files\Microsoft Office\Office10","","","C:\Program Files\Microsoft Office\Office10\WinWord.exe")
FileCreateShortcut("C:\Program Files\Microsoft Office\Office10\PowerPNT.exe", @Desktopdir & "\Power Point","C:\Program Files\Microsoft Office\Office10","","","C:\Program Files\Microsoft Office\Office10\PowerPNT.exe")
Elseif FileExists("C:\Program Files\Microsoft Office\Office12\WinWord.exe") Then
FileCreateShortcut("C:\Program Files\Microsoft Office\Office12\WinWord.exe", @Desktopdir & "\Word","C:\Program Files\Microsoft Office\Office12","","","C:\Program Files\Microsoft Office\Office12\WinWord.exe")
FileCreateShortcut("C:\Program Files\Microsoft Office\Office12\PowerPNT.exe", @Desktopdir & "\Power Point","C:\Program Files\Microsoft Office\Office12","","","C:\Program Files\Microsoft Office\Office12\PowerPNT.exe")
Else 
	EndIF
;Shortcuts will be created recreated
Filecopy($Server&"\desktop\*.*", @DesktopDir)
;Reset Google Talk
If ProcessExists("GoogleTalk.exe") Then
		ProcessClose("GoogleTalk.exe")
endif
IF FileExists ("C:\Program Files\Google\Google Talk\googletalk.exe") Then
		Run('"C:\Program Files\Google\Google Talk\googletalk.exe" '& _
	'/factoryreset')
EndIf
;Deletes temp Files and Misc Files
FileDelete(@UserProfileDir&"\Cookies\*.txt")
FileDelete(@UserProfileDir&"\Local Settings\Temporary Internet Files\*.*")
FileDelete(@TempDir&"\*.*")
FileDelete(@UserProfileDir&"\Recent\*.*")
FileDelete(@UserProfileDir&"\Nethood\*.*")
FileDelete(@FavoritesDir&"\*.*")
FileDelete(@AppDataDir&"\Microsoft\Internet Explorer\Quick Launch\*.*")
DirRemove(@FavoritesDir&"\Links", 1)
DirRemove(@FavoritesDir&"\Favorites Bar", 1)
DirRemove(@UserProfileDir&"\Local Settings\Temp", 1)
ShellExecuteWait("RunDll32.exe"," InetCpl.cpl,ClearMyTracksByProcess 4351")
FileRecycleEmpty()
;Computer Lab Display Theme will be applied.
Send("#m",0)
ShellExecute($Local&"\Lab Theme.Theme")
sleep(3000)
ControlFocus("Display Properties", "", "")
ControlSend("Display Properties", "", 1, "{ENTER}", 0)
Sleep(2000)
WinWaitClose("Display Properties")
ControlFocus("Program Manager", "", "")
;Desktop Icons Will be Auto Arragned
Sleep (3000)
MouseClick("Right", 920,25)
Send("I")
Send("A")
SplashOff()
BlockInput(0)
;RESTART Deamon
Ping("adm-24-server01")
If @error Then
Run($local&"\Refresher.exe",$local)
	Exit
Else
FileDelete($local&"\Refresher.exe")
FileCopy("\\adm-24-server01\rcdata\ComputerAutomation\Refresher.exe",$Local,1)
Run($local&"\Refresher.exe",$local)
Endif
Exit
EndFunc

;##########CONTROLER CODE##########

Func _StartControler()
Ping ("adm-24-server01")
If @error Then
	MsgBox(0, "Connection Error", "Server not online!")
Else
Local $var, $password, $Passwd, $decript
$var = IniReadSection($Server&"\settings.ini", "password")
If @error Then 
	MsgBox(4096, "", "INI Read Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$password = $var[$i][1]
	$decript = _HexToString($password)
Next	
	$passwd = InputBox("Security Check", "Enter your password.", "", "*", 190, 115, -1,-1,5)
	IF $passwd = $decript then 
		_ControlerCheck()
	Else
		MsgBox(48, "Wrong Password", "Sorry, that was not the correct Password!", 3)
		MainSystem()
	EndIf
EndIf
Endif 
EndFunc

Func _ControlerCheck()

Local $Var1, $Var2, $IP, $User
$var1 = IniReadSection($Server&"\settings.ini", "Controller_IP")
$var2 = IniReadSection($Server&"\settings.ini", "Controller_User")
If @error Then 
	MsgBox(4096, "", "INI Read Error Occurred.")
	Exit
Else
	For $i = 1 To $var1[0][0]
	$IP = $var1[$i][1]
Next
	For $i = 1 To $Var2[0][0]
	$User = $Var2[$i][1]
Next
IF $IP = "OPEN" Then
	INIWrite($Server&"\settings.ini", "Controller_IP", "key", @IPAddress1)
	INIWrite($Server&"\settings.ini", "Controller_User", "key", @UserName)
Else
	MsgBox(48, "ERROR", "The Controller is currently being used by:"&@CRLF&"User: "&$user &@CRLF&"Computer: "&$IP)
	MainSystem()
EndIf
_Controler()
Endif
EndFunc

Func _Controler()
	;Gui Items 
	Local $msg, $GUI
	;Menu Items
	Local $exit, $fileMenu, $adminmenu, $tpass, $CPass, $EPass, $Refresh
	;Buttons
	Local $Button_1,$Button_2,$Button_3,$Button_4,$Button_5,$Button_6,$Button_7,$Button_8,$Button_9,$Button_0,$Button_M,$Button_MO
	Local $Button_A,$Button_C,$button_10,$Button_11,$Button_12, $Button_13, $Button_14, $Button_15, $Button_16, $Button_17, $Garfield, $Garfield0
	;Functions
	Local $Color
	TrayItemDelete($Admin)
	TrayItemDelete($Teacher)
	TraySetState()
	TraySetIcon("Shell32.dll",55)
	TraySetState(4)
	$Gui = GUICreate($ControlerType, 420, 145)
	$FileMenu = GuiCtrlCreateMenu("&File")
	$Refresh = GUICtrlCreateMenuItem("Refresh", $FileMenu)
	$Exit = GUICtrlCreateMenuItem("Exit", $FileMenu)
	$adminmenu = GUICtrlCreateMenu("&Admin")
	$Tpass = GUICtrlCreateMenuItem("Teacher Password", $adminmenu)
	$Cpass = GUICtrlCreateMenuItem("Controller Password", $adminmenu)
	$Epass = GUICtrlCreateMenuItem("Exit Password", $adminmenu)
	GUISetFont(9, 300)
	GUICtrlCreateTab(15, 15, 390, 100)
GUICtrlCreateTabItem("Power")
	$Button_1 = GUICtrlCreateButton("Shutdown Computers", 25, 50)
	$Button_2 = GUICtrlCreateButton("Reboot Computers", 25, 80)
	$Button_3 = GUICtrlCreateButton("Logoff Computers", 150, 80)
GUICtrlCreateTabItem("Program Options")
	$Button_4 = GUICtrlCreateButton("Internet Off", 25, 50)
	$Button_5 = GUICtrlCreateButton("Internet On", 25, 80)
	$Button_10 = GUICtrlCreateButton("TimezAttack On", 100, 80)
	$Button_11 = GUICtrlCreateButton("TimezAttack Off", 100, 50)
	$Button_13 = GUICtrlCreateButton("Open Website", 200, 80)
	$Button_12 = GUICtrlCreateButton("Mute Computer", 200, 50)
	$Button_8 = GuiCtrlCreateButton("Close Process", 300, 80)
	$Button_9 = GuiCtrlCreateButton("Open Process", 300, 50)
GUICtrlCreateTabItem("Attention")
	GUICtrlSetState(-1, $GUI_SHOW)
	$Button_6 = GUICtrlCreateButton("Attention On", 25, 50)
	$Button_7 = GUICtrlCreateButton("Attention Off", 25, 80)
	$Garfield = GUICtrlCreateButton("Garfield On", 300, 50)
	$Garfield0 = GUICtrlCreateButton("Garfield Off", 300, 80)
	$Button_C = GUICtrlCreateButton("Attention Color", 200, 80)
;~ 	Color Code for Button?
	$var1 = IniReadSection($Server&"\settings.ini", "attention")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var1[0][0]
	$color = $var1[$i][1]
Next
	GUICtrlSetBkColor(-1, $color)
	endif
	$Button_M = GUICTRLCreateButton("Message On", 100, 50)
	$Button_MO = GUICTRLCreateButton("Message Off", 100, 80)
GUICtrlCreateTabItem("Misc")
	$Button_14 = GuiCtrlCreateButton("Class Question", 100, 50)
	$Button_15 = GuiCtrlCreateButton("Class Answers", 100, 80)
	$Button_0 = GuiCtrlCreateButton("Attendance", 25, 50)
	$Button_A = GuiCtrlCreateButton("Show File", 25, 80)
	$Button_16 = GuiCtrlCreateButton("Printer ON", 200, 50)
	$Button_17 = GuiCtrlCreateButton("Printer OFF", 200, 80)
	GUICtrlCreateTabItem("")

	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				_Exit()
			Case $msg = $exit
				_Exit()
			Case $msg = $Button_1
				_Shutdown()
			Case $msg = $Button_2
				_Reboot()
			Case $msg = $Button_3
				_Logoff()
			Case $msg = $Button_4
				_DisableInt()
			Case $msg = $Button_5
				_EnableInt()
			Case $msg = $Button_6
				_EnableATT()
			Case $msg = $Button_10
				_Enablextk()
			Case $msg = $Button_11
				_DisableXtk()
			Case $msg = $Button_7
				_DisableATT()
			Case $Msg = $Button_8
				_CloseProcess()
			Case $Msg = $Button_9
				_OpenProcess()
			Case $msg = $Refresh
				_Refresh()
			Case $msg = $Button_0
				_Attendance()
			Case $msg = $Button_M
				_MessageON()
			Case $msg = $Button_MO
				_MessageOFF()
			Case $msg = $CPass
				_CPassword()
			Case $msg = $TPass
				_TPassword()
			Case $msg = $EPass
				_ExitPassword()
			Case $msg = $Button_A
				_ShowAttendance()
			Case $Msg = $Button_12
				_Mute()
			Case $msg = $Button_13
				_OpenWeb()
			Case $msg = $Button_14
				_ClassQuestion()
			Case $Msg = $Button_15
				_ShowAnswers()
			Case $Msg = $Button_17
				_PrinterOFF()
			Case $Msg = $Button_16
				_PrinterON()
			Case $MSG = $Garfield
				_Garfield()
			Case $MSG = $Garfield0
				_Garfield0()
			Case $msg = $Button_C
				_ShowChoice($GUI, $color, 2, _ChooseColor(2, 0xFF0000, 2, $GUI),"")
			EndSelect
	WEnd
EndFunc

Func _CloseProcess()
Local $VarProcess
$VarProcess = Inputbox("Title of Process", "Type the title of the Process to Close")
IniWriteSection($Server&"\Settings.ini", "Process", "Key="&$VarProcess)
_FileCreate($Server&"\ProcessClose")
Sleep(2000)
FileDelete($Server&"\ProcessClose")
EndFunc

Func _OpenWeb()
Local $VarProcess
$VarProcess = Inputbox("Open Website", "Type the web address to Open")
IniWriteSection($Server&"\Settings.ini", "Process", "Key="&$VarProcess)
_FileCreate($Server&"\OpenWeb")
Sleep(2000)
FileDelete($Server&"\OpenWeb")
EndFunc

Func _OpenProcess()
Local $VarProcess
$VarProcess = Inputbox("Title of Process", "Type the title of the Process to Open")
IniWriteSection($Server&"\Settings.ini", "Process", "Key="&$VarProcess)
_FileCreate($Server&"\ProcessOpen")
Sleep(2000)
FileDelete($Server&"\ProcessOpen")
EndFunc

Func _ShowChoice($GUI, $color, $Type, $Choose, $sMessage)
	Local $cr
	If $Choose <> -1 Then
			IniWriteSection($Server&"\Settings.ini", "Attention", "Key="&$Choose)
	EndIf
EndFunc

Func _Shutdown()
_FileCreate ($Server&"\shutdown")
Sleep(10000)
fileDelete($Server&"\shutdown")
MsgBox(0,"Shutdown", "Command Done")
EndFunc

Func _Reboot()
_FileCreate ($Server&"\reboot")
Sleep(10000)
fileDelete($Server&"\reboot")
MsgBox(0,"Reboot", "Command Done")
EndFunc

Func _Logoff()
_FileCreate ($Server&"\logoff")
Sleep(10000)
fileDelete($Server&"\logoff")
MsgBox(0,"Logoff", "Command Done")
EndFunc

Func _garfield()
_FileCreate ($Server&"\garfield")
EndFunc

Func _garfield0()
fileDelete($Server&"\garfield")
_FileCreate ($Server&"\garfieldoff")
Sleep(5000)
fileDelete($Server&"\garfieldoff")
EndFunc

Func _DisableInt()
_FileCreate ($Server&"\nonet")
MsgBox(0,"Disable Internet", "Internet OFF")
EndFunc

Func _EnableInt()
fileDelete($Server&"\nonet")
MsgBox(0,"Disable Internet", "Internet On")
EndFunc

Func _PrinterOff()
_FileCreate ($Server&"\PrinterOff")
MsgBox(0,"Printer", "Status:OFF")
EndFunc

Func _PrinterOn()
	fileDelete($Server&"\PrinterOff")
	_FileCreate($Server&"\PrinterOn")
	Sleep(2000)
	FileDelete($Server&"\PrinterOn")
	MsgBox(0,"Printer", "Status:ON")
EndFunc

Func _Disablextk()
_FileCreate ($Server&"\xattack")
MsgBox(0,"Timez Attack", "Status: OFF")
EndFunc

Func _Enablextk()
fileDelete($Server&"\xattack")
MsgBox(0,"Timez Attack", "Status: On")
EndFunc

Func _MessageON()
Local $Message
	$Message = Inputbox("Message to Class", "Type Message to Class.", "","")
	IniWriteSection($Server&"\Settings.ini", "message", "key="&$Message)
	fileDelete($Server&"\messageoff")
	_FileCreate($Server&"\messageon")
EndFunc

Func _MessageOff()
	fileDelete($Server&"\messageon")
	_FileCreate($Server&"\messageoff")
	Sleep(2000)
	FileDelete($Server&"\messageoff")
EndFunc

Func _EnableATT()
FileDelete($Server&"\attentionOFF")
_FileCreate ($Server&"\attentionON")
EndFunc

Func _DisableATT()
	FileDelete($Server&"\attentionON")
	_FileCreate($Server&"\attentionOFF")
	Sleep(2000)
	FileDelete($Server&"\attentionOFF")
EndFunc

Func _Mute()
_FileCreate ($Server&"\mute")
Sleep(100)
FileDelete($Server&"\mute")
EndFunc

Func _Refresh()
_FileCreate ($Server&"\refresh")
Sleep(2000)
fileDelete($Server&"\refresh")
EndFunc

Func _Attendance()
	Local $Question
	_FileCreate ($Server&"\TakeAttendance")
	Sleep(2000)
	FileDelete($Server&"\TakeAttendance")
EndFunc

Func _CPassword()
	Local $var, $password, $Passwd, $newPass, $encript ,$decript
$var = IniReadSection($server&"\settings.ini", "admin")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$password = $var[$i][1]
	$decript = _HexToString($password)
Next	
	$passwd = InputBox("Admin Login", "Enter your password.", "", "*", 190, 115)
	IF $passwd = $decript then 
		$newPass =Inputbox("Change Passowrd", "Type in the new Password", "", "*")
		if @error Then
			MsgBox(48, "ERROR", "ERROR")
		Else
		 $encript = _StringtoHex($newpass)
		INIWrite($Server&"\settings.ini", "password", "key", $encript)
		MsgBox(0, "New Password", "Password is Set.")
	EndIf
	Else
		MsgBox(48, "Wrong Password", "Sorry, that was not the correct Password!")
	EndIf
EndIf
EndFunc

Func _ExitPassword()
	Local $var, $password, $Passwd, $newPass, $encript ,$decript
$var = IniReadSection($server&"\settings.ini", "admin")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$password = $var[$i][1]
	$decript = _HexToString($password)
Next	
	$passwd = InputBox("Admin Login", "Enter your password.", "", "*", 190, 115)
	IF $passwd = $decript then 
		$newPass =Inputbox("Change Passowrd", "Type in the new Password", "", "*")
		if @error Then
			MsgBox(48, "ERROR", "ERROR")
		Else
		 $encript = _StringtoHex($newpass)
		INIWrite($Server&"\settings.ini", "Exit", "key", $encript)
		MsgBox(0, "New Password", "Password is Set.")
	EndIf
	Else
		MsgBox(48, "Wrong Password", "Sorry, that was not the correct Password!")
	EndIf
EndIf
EndFunc

Func _TPassword()
	Local $var, $password, $Passwd, $newPass, $encript ,$decript
$var = IniReadSection($server&"\settings.ini", "admin")
If @error Then 
	MsgBox(4096, "", "Error occurred.")
Else
	For $i = 1 To $var[0][0]
	$password = $var[$i][1]
	$decript = _HexToString($password)
Next	
	$passwd = InputBox("Admin Login", "Enter your password.", "", "*", 190, 115)
	IF $passwd = $decript then 
		$newPass =Inputbox("Change Passowrd", "Type in the new Password", "", "*")
		if @error Then
			MsgBox(48, "ERROR", "ERROR")
		Else
		 $encript = _StringtoHex($newpass)
		INIWrite($Server&"\settings.ini", "teacher", "key", $encript)
		MsgBox(0, "New Password", "Password is Set.")
	EndIf
	Else
		MsgBox(48, "Wrong Password", "Sorry, that was not the correct Password!")
	EndIf
EndIf
EndFunc

Func _ShowAttendance()
	local $delete
	If Fileexists($Server&"\Attendance.txt") Then
	ShellExecute($Server&"\attendance.txt")
	Sleep(1000)
	WinWaitClose("Attendance.txt - Notepad")
	$delete = MsgBox(4, "Attendance", "Delete File?")
	If $delete = 6 Then
		Filedelete($Server&"\Attendance.txt")
		EndIf
Else
Msgbox(0, "ERROR", "Attendance has not been taken.")
Endif
endfunc

Func _ShowAnswers()
	local $delete
	If Fileexists($Server&"\Answers.txt") Then
	ShellExecute($Server&"\Answers.txt")
	Sleep(1000)
	WinWaitClose("Answers.txt - Notepad")
	$delete = MsgBox(4, "Answers", "Delete File?")
	If $delete = 6 Then
		Filedelete($Server&"\Answers.txt")
		EndIf
Else
Msgbox(0, "ERROR", "No Answers file.")
Endif
endfunc

Func _ClassQuestion()
	Local $Question
	$Question = Inputbox("Question for Class", "Type Question to Class.", "","")
	IniWriteSection($Server&"\Settings.ini", "Question", "key="&$Question)
	_FileCreate ($Server&"\ClassResponce")
	Sleep(2000)
	FileDelete($Server&"\ClassResponce")
	EndFunc

Func _exit()
	GUIDelete()
	INIWrite($Server&"\settings.ini", "Controller_IP", "key", "OPEN")
	INIWrite($Server&"\settings.ini", "Controller_User", "key", "OPEN")
	fileDelete($Server&"\shutdown")
	fileDelete($Server&"\reboot")
	fileDelete($Server&"\logoff")
	fileDelete($Server&"\nonet")
	fileDelete($Server&"\AttentionON")
	fileDelete($Server&"\AttentionOFF")
	fileDelete($Server&"\refresh")
	fileDelete($Server&"\message")
	fileDelete($Server&"\messageon")
	fileDelete($Server&"\messageoff")
	fileDelete($Server&"\TakeAttendance")
	fileDelete($Server&"\mute")
	fileDelete($Server&"\xattack")
	fileDelete($Server&"\PrinterOff")
	fileDelete($Server&"\GoogleOn")
	filedelete($Server&"\garfield")
	$teacher = TrayCreateItem("Teacher Mode", -1, 1)
	$Admin = TrayCreateItem("Admin Mode", -1, 2)
	TraySetIcon("Shell32.dll",13)
	TraySetState(16)
	IF @ComputerName = "Hil-Jcross" Then
	MsgBox(0, "Computer Lab Automation", "You have closed the Controler")
	Exit
	Else
	MainSystem()
	EndIf
EndFunc