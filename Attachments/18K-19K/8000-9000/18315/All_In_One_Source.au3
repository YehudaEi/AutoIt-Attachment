#include <GUIConstants.au3>
#include <IE.au3>
#include <Sound.au3>
#include <Misc.au3>
#Include <INet.au3>

$Form1 = GUICreate("All In One App", 633, 447, 193, 115)
$Tab1 = GUICtrlCreateTab(8, 8, 617, 433)
$TabSheet1 = GUICtrlCreateTabItem("Web Browser")
$Obj1 = ObjCreate("Shell.Explorer.2")
$Obj1_ctrl = GUICtrlCreateObj($Obj1, 16, 32, 602, 372)
$Button1 = GUICtrlCreateButton("URL", 24, 408, 587, 25, 0)
$TabSheet2 = GUICtrlCreateTabItem("Notepad")
$EDIT = GUICtrlCreateEdit("", 16, 40, 601, 361)
$Button2 = GUICtrlCreateButton("New", 96, 408, 75, 25, 0)
$Button3 = GUICtrlCreateButton("Save", 176, 408, 75, 25, 0)
$Button4 = GUICtrlCreateButton("Open", 16, 408, 75, 25, 0)
;$Button45 = GuiCtrlCreateButton("Font", 257, 408, 75, 25, 0)
$Button5N = GuICtrlCreateButton("Run AU3 Script", 540, 408, 80, 25,0)
$TabSheet3 = GUICtrlCreateTabItem("Music Player")
$Button5 = GUICtrlCreateButton("Load Sound", 16, 32, 75, 401, 0)
$Button6 = GUICtrlCreateButton("Play Sound", 96, 32, 75, 201, 0)
$Button7 = GUICtrlCreateButton("Pause Sound", 176, 32, 75, 105, 0)
$Button8 = GUICtrlCreateButton("Stop Sound", 256, 32, 75, 57, 0)
$Button9 = GUICtrlCreateButton("Resume Sound", 336, 32, 83, 25, 0)
$TabSheet4 = GUICtrlCreateTabItem("Task Manager")
$List1 = GUICtrlCreateList("", 16, 32, 121, 396)
$Button10 = GUICtrlCreateButton("Refresh List", 136, 32, 235, 393, 0)
$Button11 = GUICtrlCreateButton("Kill Task", 376, 32, 243, 393, 0)
$TabSheet5 = GUICtrlCreateTabItem("Misc")
$Label2 = GUICtrlCreateLabel("", 40, 32, 4, 4)
$Label3 = GUICtrlCreateLabel("Diagnostics:", 16, 32, 62, 17)
$Button12 = GUICtrlCreateButton("Open CD Tray", 16, 56, 75, 25, 0)
$Button13 = GUICtrlCreateButton("Beep Test", 16, 88, 75, 25, 0)
$Button14 = GUICtrlCreateButton("SAPI Test", 16, 120, 75, 25, 0)
$Button15 = GUICtrlCreateButton("System Info", 16, 152, 75, 25, 0)
$Button16 = GUICtrlCreateButton("Monitor On/Off Test", 16, 184, 99, 25, 0)
$Button17 = GUICtrlCreateButton("Internet Test", 16, 216, 75, 25, 0)
$Button18 = GUICtrlCreateButton("Color Test", 16, 248, 75, 25, 0)
$Label4 = GuiCtrlCreateLabel("Misc:", 16, 275, 62, 17)
$Button19 = GuiCtrlCreateButton("Youtube Downloader", 16, 290, 110, 25, 0)
GUICtrlCreateTabItem("")
_IENavigate($Obj1, "www.google.com")
GUISetState()

While 1
	Winsettitle("All In One Application Copyright Justin Reno 2007.", "", "All In One Application Copyright Justin Reno 2007. "&@Hour&":"&@Min&":"&@Sec&"")
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
        Case $Button1
			$URL = Inputbox("Web Browser", "What is the URL you want to go to?")
			_IENavigate($Obj1, $URL)
		Case $Button2
			GuiCtrlSetData($EDIT, "")
		Case $Button3
			$FileSave = Filesavedialog("Save Text File", "", "Text Files (*.txt)", 2)
			$Text = GuiCtrlRead($edit)
			Filewrite($Filesave, $Text)
		Case $Button4
			$Fileopen = FileOpenDialog("Open Text File",@Desktopdir, "Text Files(*.txt)", 1)
            GUICtrlSetData($EDIT, FileRead($Fileopen))
		Case $Button5N
			$Readedit = GuiCtrlRead($EDIT)
			filewrite(@Scriptdir&"\script.au3", $readedit)
			Run('"' & @AutoItExe & '" /AutoIt3ExecuteScript "'& @Scriptdir &'\script.au3"')
			sleep(500)
			Filedelete(@Scriptdir&"\script.au3")
		Case $Button5
			$soundfile = FileOpenDialog("Open Music File", "", "MP3(*.mp3)|Wave Files(*.wav)")
			$sound = _SoundOpen($soundfile)
			_SoundPlay($sound)
		Case $Button6
			_SoundOpen($sound)
			_SoundPlay($sound)
		Case $Button7
			_SoundPause($sound)
		Case $Button8
			_SoundStop($sound)
		Case $Button9
			_SoundResume($sound)
		Case $Button10
			$list = ProcessList()
            For $i = 1 to $List[0][0]
                GUICtrlSetData($List1 , $List[$i][0] )
            Next
		Case $Button11
			$Taskkillmessage = MsgBox(20, GUICtrlRead($List1) ,"Are you sure you want to close this process?")
            Select
                Case $Taskkillmessage = 6 ;Yes
                    ProcessClose(GUICtrlRead($List1))
		EndSelect
	Case $Button12
        $CD = Inputbox("What is your CD Drive Letter?", "Type the letter of your CD Drive: (eg. D:)")
		CDtray(""&$CD&"", "OPEN")
	Case $Button13
		beep("1000", "500")
	Case $Button14
		$Text = "This is a SAPI Test"
		$oSp = ObjCreate("SAPI.SpVoice")
        $oSp.Speak($Text)
	Case $Button15
		_Systeminfo()
	Case $Button16
		_Mononoff()
	Case $Button17
		_IECreate("www.google.com")
	Case $Button18
		_Flicker()
	Case $Button19
		$sYouTubeLink = Inputbox("Youtube Downloader", "Type in the url of the Youtube video:")
			If StringLen($sYouTubeLink) = 0 Then
				MsgBox(16, "Youtube Video Downloader", "You must enter a link!")
			EndIf
			$sCode = _INetGetSource($sYouTubeLink)
			$s_t = StringRegExp($sCode, "&t=(.*?)&", 3)
			$s_v = StringMid($sYouTubeLink, StringInStr($sYouTubeLink, "v=") + 2)
			$sDownloadLink = "http://youtube.com/get_video?video_id=" & $s_v & "&t=" & $s_t[0]
			$oIE = _IECreate($sDownloadLink, 0, 0, 1)
	EndSwitch
WEnd

Func _Systeminfo()
$INFO = ""
$INFO &= "OS: "&@OSVersion 
$INFO &= @CRLF
$INFO &= "Computer Name: "&@ComputerName
$INFO &= @CRLF
$INFO &= "Desktop Dir: "&@DesktopDir
$INFO &= @CRLF
$INFO &= "Home Drive: "&@HomeDrive
$INFO &= @CRLF
$INFO &= "IP Address: "&@IPAddress1
$INFO &= @CRLF
$INFO &= "My Documents Dir: "&@MyDocumentsDir
$INFO &= @CRLF
$INFO &= "Program Files Dir: "&@ProgramFilesDir
$INFO &= @CRLF
$INFO &= "Start Up Dir: "&@StartupDir
$INFO &= @CRLF
$INFO &= "System Dir: "&@SystemDir
$INFO &= @CRLF
$INFO &= "Temp Dir: "&@TempDir
$INFO &= @CRLF
$INFO &= "Username: "&@UserName
$INFO &= @CRLF
$INFO &= "Window Dir: "&@WindowsDir
MsgBox(4096,"System Information:", $INFO)
endfunc

Func _Mononoff()
	Opt("WinTitleMatchMode", 4)
			$hwnd = WinGetHandle("classname=Progman")
			$user32 = DllOpen("user32.dll")
			Global Const $lciWM_SYSCommand = 274
			Global Const $lciSC_MonitorPower = 61808
			Global Const $lciPower_Off = 2
			Global Const $lciPower_On = -1
			DllCall($user32, "int", "SendMessage", "hwnd", $hwnd, "int", $lciWM_SYSCommand, "int", $lciSC_MonitorPower, "int", $lciPower_Off)
			Sleep(1000)
			DllCall($user32, "int", "SendMessage", "hwnd", $hwnd, "int", $lciWM_SYSCommand, "int", $lciSC_MonitorPower, "int", $lciPower_On)
		endfunc
		
Func _Flicker()
    $WIndow = GUICreate("", @DesktopWidth + 200, @DesktopHeight + 200, -1, -1, $WS_POPUP + $WS_BORDER, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
    GUISetState(@SW_SHOW)
    $BkColor = 0xFF0000
    ProcessSetPriority(@ScriptName, 4)
For $i = 1000 to 1 Step -1
		If $BkColor = 0xFF0000 Then 
            $BkColor = 0x00FF00
        ElseIf $BkColor = 0x00FF00 Then 
            $BkColor = 0x0000FF
        ElseIf $BkColor = 0x0000FF Then 
            $BkColor = 0xFF0000 
        EndIf   
        GUISetBkColor($BkColor)
next
    GUIDelete()
    ProcessSetPriority(@ScriptName, 0)
EndFunc
