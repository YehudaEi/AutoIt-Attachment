#include <File.Au3>
#include <array.au3>
#include <GUIConstants.au3>
#include <IE.au3>
#Include <Constants.au3>
AutoItSetOption("trayicondebug", 1)
Dim $players[1] = [0]
Dim $folder, $probable
RegRead("HKEY_CURRENT_USER\SOFTWARE\X-Arcade\Starfish", "HHFolder")
If @error = 0 Then
	$folder = RegRead("HKEY_CURRENT_USER\SOFTWARE\X-Arcade\Starfish", "HHFolder")
ElseIf $folder = "" Then
	If FileExists("c:\Program Files\pokerstars\HandHistory\") Then
		$probable = "c:\Program Files\pokerstars\HandHistory\" 
	Else
		$probable = @ProgramFilesDir
	EndIf
	$folder = FileSelectFolder("Select your Pokerstars hand history Folder (Usualy your playername)", "c:\", 0, $probable)
	If @error = 1 Then
        RegDelete("HKEY_CURRENT_USER\SOFTWARE\X-Arcade\Starfish")		
		Exit
	Else
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\X-Arcade\Starfish", "HHFolder", "REG_SZ", $folder)
	MsgBox(64, "StarFish", "The location of your hand history folder was saved in the registry.")
	EndIf
Else
	$folder = RegRead("HKEY_CURRENT_USER\SOFTWARE\X-Arcade\Starfish", "HHFolder")
EndIf
$files = _FileListToArray($folder, "*.txt", 1)
Dim $latest, $latestdate = -1
For $i = 1 To UBound($files) - 1
	$temp = FileGetTime($folder & "\" & $files[$i], 1, 1)
	If $latestdate = -1 Or $temp > $latestdate Then
		$latest = $files[$i]
		$latestdate = $temp
	EndIf
Next
$handle = FileOpen($folder & "\" & $latest, 0)
If @error Then MsgBox(1, "Error", "")
Do
	$temp = FileReadLine($handle)
	If @error = -1 Then ExitLoop
	If StringLeft($temp, 4) = "Seat"  Then
		ReDim $players[UBound($players) + 1]
		
		$data = StringMid($temp, StringInStr($temp, ":") + 2, StringInStr(StringTrimLeft($temp, 6), ")"))
		$players[UBound($players) - 1] = StringLeft($data, StringInStr($data, " ") - 1)
	EndIf
Until False
Dim $array2[1]
For $i = 0 To UBound($players) - 1
	For $j = 0 To UBound($array2) - 1
		If $players[$i] = $array2[$j] Then ContinueLoop 2
	Next
	ReDim $array2[UBound($array2) + 1]
	$array2[UBound($array2) - 1] = $players[$i]
Next
_ArraySort($array2)
;_ArrayDisplay($array2)
Dim $oIE, $sInputBoxAnswer
Global $selection
For $x = 1 To 18
	_Selectplayer()
	_GetIT()
	$x = $x + 1
Next
;===========
Func _Selectplayer()
	
	$Form1 = GUICreate("Starfish - Top Shark player seeker", 315, 167, 193, 115)
	$Group1 = GUICtrlCreateGroup($folder, 8, 8, 297, 145)
	$List1 = GUICtrlCreateCombo($players[1], 16, 56, 281, 19)
	GUICtrlSetData(-1, _ArrayToString($array2, "|"))
	$Label1 = GUICtrlCreateLabel("Select a player or enter a playername", 32, 32, 359, 17)
	$Button1 = GUICtrlCreateButton("OK", 16, 100, 80, 33, $BS_DEFPUSHBUTTON)
	$Button2 = GUICtrlCreateButton("Cancel", 116, 100, 80, 33, 0)
	$Button3 = GUICtrlCreateButton("Reset Folder", 216, 100, 80, 33, 0)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Button1
				GUISetState(@SW_HIDE)
				$selection = GUICtrlRead($List1)
				Return $selection
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Button2
				Exit
			Case $Button3
				RegDelete("HKEY_CURRENT_USER\SOFTWARE\X-Arcade\Starfish")
				_restart()
		EndSwitch
	WEnd
	
EndFunc   ;==>_Selectplayer
Func _GetIT()
	If Not WinExists("Top Shark") Then
		$oIE = _IECreate("www.pokerprolabs.com/TopShark/topshark.aspx?pokernetwork=1&playername=" & $selection)
	Else
		_IENavigate($oIE, "www.pokerprolabs.com/TopShark/topshark.aspx?pokernetwork=1&playername=" & $selection)
	EndIf
	;Exit
EndFunc   ;==>_GetIT
Func _restart()
	Opt("GUIOnEventMode", 0)
	; Restart your program
	; Author UP_NORTH
	If @Compiled = 1 Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>_restart