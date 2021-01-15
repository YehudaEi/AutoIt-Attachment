#NoTrayIcon
#include<GUIConstants.au3>
#include<Math.au3>
#include<File.au3>
#include<String.au3>
#include<Misc.au3>

_Singleton("GUI Launcher")

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnEsc", 0)
Opt("GUIResizeMode", 802)

Global $Run[256], $Browse[256], $Counter = 0, $WidthPos1 = -195, $HeightPos1 = 1, $WidthPos2 = -100, $HeightPos2 = 2, $Dir[256], $Execute[256], $File
Global $FileName = @ScriptDir & "\Setting.ini"

_OpenIni()

$mainfrm = GUICreate("GUI Launcher", 199, 55, -1, -1, $WS_MINIMIZEBOX + $WS_CAPTION)
$filemenu = GUICtrlCreateMenu("File")
$filemini = GUICtrlCreateMenuItem("Minimize", $filemenu)
$fileexit = GUICtrlCreateMenuItem("Exit", $filemenu)
$createmenu = GUICtrlCreateMenu("Options")
$createitem = GUICtrlCreateMenuItem("Add Button", $createmenu)
$loadini = GUICtrlCreateMenuItem("Load Setting", $createmenu)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUICtrlSetOnEvent($fileexit, "_Exit")
GUICtrlSetOnEvent($filemini, "_Minimize")
GUICtrlSetOnEvent($createitem, "_CreateButton")
GUICtrlSetOnEvent($loadini, "_LoadfromIni")
GUISetFont(9, 400, 0, "Tahoma")
GUISetState()
While 1
	Sleep(1)
WEnd
Func _Exit()
	_CloseIni()
	GUIDelete($mainfrm)
	ProgressOn("Saving current setting into Ini", "", "", Default, Default)
	For $i = 0 To UBound($Dir, 1) - 1
		IniWrite($FileName, "Directory", "Directory." & $i, $Dir[$i])
		If $i > 125 Then ProgressSet(25)
		If $i > 254 Then ProgressSet(50)
		Sleep(5)
	Next
	Sleep(100)
	For $i = 0 To UBound($Execute, 1) - 1
		IniWrite($FileName, "Execute", "Execute." & $i, $Execute[$i])
		If $i > 125 Then ProgressSet(75)
		If $i > 254 Then ProgressSet(95)
		Sleep(5)
	Next
	IniWrite($FileName, "Counter", "Counter.#", $Counter)
	ProgressSet(100)
	Sleep(200)
	ProgressOff()
	Exit
EndFunc   ;==>_Exit
Func _CreateButton()
	Local $WinPos = WinGetPos($mainfrm)
	$WidthPos1 += 200
	$WidthPos2 += 200
	$Run[$Counter] = GUICtrlCreateButton("Executable", $WidthPos1, $HeightPos1, 90, 30)
	GUICtrlSetOnEvent(-1, "_RunExecute")
	GUICtrlSetFont(-1, 9, 400, 0, "Tahoma")
	$Browse[$Counter] = GUICtrlCreateButton("Browse", $WidthPos2, $HeightPos2, 90, 30)
	GUICtrlSetOnEvent(-1, "_BrowseDirc")
	GUICtrlSetFont(-1, 9, 400, 0, "Tahoma")
	$Counter += 1
	If $Counter > 253 Then
		GUICtrlSetState($createitem, $GUI_DISABLE)
	EndIf
	If _MathCheckDiv($Counter, 3) = 1 Then
		If $Counter > 3 Then
		Else
			WinMove($mainfrm, "", $WinPos[0], $WinPos[1], $WinPos[2] + 198, $WinPos[3])
		EndIf
	Else
		$WidthPos1 -= 600
		$WidthPos2 -= 600
		$HeightPos1 += 35
		$HeightPos2 += 35
		WinMove($mainfrm, "", $WinPos[0], $WinPos[1], $WinPos[2], $WinPos[3] + 35)
	EndIf
EndFunc   ;==>_CreateButton
Func _RunExecute()
	Local $Id = @GUI_CtrlHandle
	For $i = 0 To UBound($Run, 1) - 1
		If GUICtrlGetHandle($Run[$i]) = $Id Then
			ShellExecute($Dir[$i])
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_RunExecute
Func _BrowseDirc()
	Local $Id = @GUI_CtrlHandle
	Local $Dirc, $String, $Display
	$Dirc = FileOpenDialog("Please Select the File", @DesktopDir, "All (*.*)", 1 + 2)
	$String = StringSplit($Dirc, ".")
	$String2 = StringSplit($String[1], "\")
	$Display = UBound($String2, 1) - 1
	For $i = 0 To UBound($Browse, 1) - 1
		If GUICtrlGetHandle($Browse[$i]) = $Id Then
			$Dir[$i] = $Dirc
			$Execute[$i] = $String2[$Display]
			GUICtrlSetData($Run[$i], $Execute[$i])
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_BrowseDirc
Func _LoadfromIni()
	Local $IniRead
	If FileExists($FileName) Then
		GUISetState(@SW_HIDE, $mainfrm)
		ProgressOn("Loading Setting from Ini", "", "", Default, Default)
		$IniRead = IniRead($FileName, "Counter", "Counter.#", 0)
		For $i = 1 To $IniRead
			_CreateButton()
		Next
		ProgressSet(50)
		Sleep(100)
		For $i = 0 To UBound($Dir, 1) - 1
			$Dir[$i] = IniRead($FileName, "Directory", "Directory." & $i, "")
			If $i > 125 Then ProgressSet(60)
			If $i > 254 Then ProgressSet(70)
			Sleep(5)
		Next
		Sleep(100)
		For $i = 0 To UBound($Execute, 1) - 1
			$Execute[$i] = IniRead($FileName, "Execute", "Execute." & $i, "")
			GUICtrlSetData($Run[$i], IniRead($FileName, "Execute", "Execute." & $i, ""))
			If $i > 125 Then ProgressSet(80)
			If $i > 254 Then ProgressSet(95)
			Sleep(5)
		Next
		ProgressSet(100)
		Sleep(200)
		ProgressOff()
		GUISetState(@SW_SHOW, $mainfrm)
	Else
		MsgBox(64, "Error", "File do not exist, failed to load setting", 3)
		Return
	EndIf
EndFunc   ;==>_LoadfromIni
Func _OpenIni()
	If FileExists($FileName) Then
		$File = FileOpen($FileName, 0)
	EndIf
EndFunc   ;==>_OpenIni
Func _CloseIni()
	If FileExists($FileName) Then
		FileClose($File)
	EndIf
EndFunc   ;==>_CloseIni
Func _Minimize()
	GUISetState(@SW_MINIMIZE, $mainfrm)
EndFunc   ;==>_Minimize