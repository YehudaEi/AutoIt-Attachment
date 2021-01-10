#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=add source.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Saves Autoit Source Files into EXEs
#AutoIt3Wrapper_Res_Fileversion=1
#AutoIt3Wrapper_Res_LegalCopyright=Ilia Bakhmoutski
#AutoIt3Wrapper_Res_Language=4105
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include<rijndael.au3>
#include<string.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>

Global $pad_char, $b

$mainGUI = GUICreate("Save/Retrieve Autoit Script To/From EXE", 516, 218, -1, -1)
$param_group = GUICtrlCreateGroup("Parameters", 16, 16, 488, 151)
$exe_lab = GUICtrlCreateLabel("Choose Executable", 32, 48, 96, 17)
$au3_lab = GUICtrlCreateLabel("Choose Script", 32, 84, 70, 17)
$pass_lab = GUICtrlCreateLabel("Password", 32, 120, 50, 17)
$exe_path = GUICtrlCreateInput("", 141, 45, 257, 21, $ES_READONLY)
$au3_path = GUICtrlCreateInput("", 141, 80, 257, 21)
$pass_input = GUICtrlCreateInput("", 141, 117, 257, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
$exe_browse = GUICtrlCreateButton("Browse", 416, 42, 75, 25, 0)
$au3_browse = GUICtrlCreateButton("Browse", 416, 77, 75, 25, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$add_script = GUICtrlCreateButton("Add", 139, 178, 75, 25, 0)
$retr_script = GUICtrlCreateButton("Extract", 325, 178, 75, 25, 0)
GUICtrlSetState($add_script, $GUI_DISABLE)
GUICtrlSetState($retr_script, $GUI_DISABLE)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $exe_browse
			$exe_path_select = FileOpenDialog("Select Executable", GUICtrlRead($exe_path), "Executable (*.exe)", 3, "")
			If Not @error Then
				GUICtrlSetData($exe_path, $exe_path_select)
				$open_file = FileOpen(GUICtrlRead($exe_path), 16)
				$read_contents = FileRead($open_file)
				FileClose($open_file)
				$find_script = _StringBetween($read_contents, _StringToHex("---Encrypted Script Start---"), _StringToHex("---Encrypted Script End---"))
				If @error Then
					GUICtrlSetState($retr_script, $GUI_DISABLE)
					GUICtrlSetState($add_script, $GUI_ENABLE)
					GUICtrlSetData($add_script, "Add")
					GUICtrlSetData($au3_path, "")
					$script_exists = 0
				Else
					GUICtrlSetState($add_script, $GUI_ENABLE)
					GUICtrlSetData($add_script, "Replace")
					$script_exists = 1
					GUICtrlSetState($retr_script, $GUI_ENABLE)
					GUICtrlSetData($au3_path, StringMid(GUICtrlRead($exe_path), 1, StringLen(GUICtrlRead($exe_path)) - 4) & ".au3")
				EndIf
			Else
				ContinueLoop
			EndIf
		Case $au3_browse
			$au3_path_select = FileOpenDialog("Select Script", GUICtrlRead($exe_path), "Autoit Script (*.au3)", 10, "")
			If Not @error Then
				GUICtrlSetData($au3_path, $au3_path_select)
			Else
				ContinueLoop
			EndIf
		Case $add_script
			If GUICtrlRead($au3_path) = "" Then
				MsgBox(16, "No Source", "Choose Script File.")
				ContinueLoop
			EndIf
			script_add()
		Case $retr_script
			If GUICtrlRead($au3_path) = "" Then
				MsgBox(16, "No Source", "Choose Script File.")
				ContinueLoop
			EndIf
			retrieve_script()
	EndSwitch
WEnd


Func script_add()
	GUISetState(@SW_HIDE, $mainGUI)
	$progress_gui = GUICreate("", 288, 44, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER), $WS_EX_TOOLWINDOW)
	$progress = GUICtrlCreateProgress(9, 7, 266, 28, $PBS_SMOOTH)
	GUISetState(@SW_SHOW)
	$open_file = FileOpen(GUICtrlRead($exe_path), 16)
	$file_contents = FileRead($open_file)
	GUICtrlSetData($progress, 16.66)
	$open_script = FileOpen(GUICtrlRead($au3_path), 16)
	$script_read = FileRead($open_script)
	$pass = GUICtrlRead($pass_input)
	GUICtrlSetData($progress, 33.32)
	FileClose($open_script)
	FileClose($open_file)
	If StringLen($pass) < 33 And StringLen($pass) <> 0 Then
		Switch StringLen($pass)
			Case 1 To 15
				$pad = 16 - StringLen($pass)
				For $a = 1 To $pad
					$b = $b + 1
					$pad_char = $pad_char & $b
					If $b = 9 Then $b = 1
				Next
			Case 17 To 19
				$pad = 20 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
			Case 21 To 23
				$pad = 24 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
			Case 25 To 27
				$pad = 28 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
			Case 29 To 31
				$pad = 32 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
		EndSwitch
	Else
		MsgBox(16, "Password Too Long Or Too Short", "Password cannot have more than 32 or less than 1 character(s).")
		GUIDelete($progress_gui)
		GUISetState(@SW_SHOW, $mainGUI)
		Return
	EndIf
	GUICtrlSetData($progress, 49.98)
	$encrypt_script = _rndCipher($pass & $pad_char, $script_read)
	GUICtrlSetData($progress, 66.64)
	If $script_exists = 0 Then
		$save_file = FileOpen(FileSaveDialog("Save Modified Executable", GUICtrlRead($exe_path), "Executable (*.exe)", 18, ""), 18)
		If $save_file = -1 Then
			MsgBox(48, "Failed", "Failed To Save File.")
			GUIDelete($progress_gui)
			GUISetState(@SW_SHOW, $mainGUI)
			Return
		EndIf
		GUICtrlSetData($progress, 83.3)
		FileWrite($save_file, $file_contents & _StringToHex("---Encrypted Script Start---") & StringMid($encrypt_script, 3) & _StringToHex("---Encrypted Script End---"))
	Else
		GUICtrlSetData($progress, 83.3)
		$save_file = FileOpen(GUICtrlRead($exe_path), 18)
		FileWrite($save_file, StringReplace($file_contents, $find_script[0], StringMid($encrypt_script, 3), 1))
	EndIf
	GUICtrlSetData($progress, 100)
	FileClose($save_file)
	$pad_char = ""
	MsgBox(64, "Finished", "All Done   ")
	GUIDelete($progress_gui)
	GUISetState(@SW_SHOW, $mainGUI)
	$b = 0
EndFunc   ;==>script_add

Func retrieve_script()
	GUISetState(@SW_HIDE, $mainGUI)
	$progress_gui = GUICreate("", 288, 44, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER), $WS_EX_TOOLWINDOW)
	$progress = GUICtrlCreateProgress(9, 7, 266, 28, $PBS_SMOOTH)
	GUISetState(@SW_SHOW)
	$pass = GUICtrlRead($pass_input)
	If StringLen($pass) < 33 And StringLen($pass) <> 0 Then
		Switch StringLen($pass)
			Case 1 To 15
				$pad = 16 - StringLen($pass)
				For $a = 1 To $pad
					$b = $b + 1
					$pad_char = $pad_char & $b
					If $b = 9 Then $b = 1
				Next
			Case 17 To 19
				$pad = 20 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
			Case 21 To 23
				$pad = 24 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
			Case 25 To 27
				$pad = 28 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
			Case 29 To 31
				$pad = 32 - StringLen($pass)
				For $a = 1 To $pad
					$pad_char = $pad_char & $a
				Next
		EndSwitch
	Else
		MsgBox(16, "Password Too Long Or Too Short", "Password cannot have more than 32 or less than 1 character(s).")
		GUIDelete($progress_gui)
		GUISetState(@SW_SHOW, $mainGUI)
		Return
	EndIf
	GUICtrlSetData($progress, 20)
	$decrypt_script = _rndInvCipher($pass & $pad_char, "0x" & $find_script[0])
	GUICtrlSetData($progress, 60)
	$save_script = FileOpen(GUICtrlRead($au3_path), 18)
	FileWrite($save_script, $decrypt_script)
	FileClose($save_script)
	GUICtrlSetData($progress, 100)
	$pad_char = ""
	MsgBox(64, "Finished", "All Done   ")
	GUIDelete($progress_gui)
	GUISetState(@SW_SHOW, $mainGUI)
	$b = 0
EndFunc   ;==>retrieve_script