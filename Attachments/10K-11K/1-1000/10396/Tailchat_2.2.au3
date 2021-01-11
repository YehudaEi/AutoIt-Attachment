#include <File.au3>
#include <GUIConstants.au3>
#Include <GuiEdit.au3>
#Include <array.au3>
#Include <Misc.au3>

Opt("GUIOnEventMode", 1)
Opt('GUICloseOnESC', 1)
Dim $aCurrentUSers[1]
;     Start GUI Window and Elements creation -->
$W_size_w = 320
$Wsize_h = 400

$mainWindow = GUICreate("Tailchat", $W_size_w, $Wsize_h, "", "", $WS_SIZEBOX + $WS_SYSMENU)
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")


$filemenu = GUICtrlCreateMenu("&File")
$fileitem = GUICtrlCreateMenuitem("Open", $filemenu)
GUICtrlSetOnEvent($fileitem, "FileopenButton")
$separator1 = GUICtrlCreateMenuitem("", $filemenu, 2)
$exititem = GUICtrlCreateMenuitem("Exit", $filemenu)
GUICtrlSetOnEvent($exititem, "CLOSEClicked")

$Viewmenu = GUICtrlCreateMenu("&View")
$currentusersitem = GUICtrlCreateMenuitem("Current_Users", $Viewmenu)
GUICtrlSetOnEvent($currentusersitem, "ShowUsers")

$Toolsmenu = GUICtrlCreateMenu("&Tools")
$optionsitem = GUICtrlCreateMenuitem("Options", $Toolsmenu)
GUICtrlSetOnEvent($optionsitem, "Options")


$helpmenu = GUICtrlCreateMenu("&Help")
$aboutitem = GUICtrlCreateMenuitem("About TailChat", $helpmenu)
GUICtrlSetOnEvent($aboutitem, "About")




$editControl = GUICtrlCreateEdit("", 10, 10, 300, $Wsize_h - 200, $WS_VSCROLL + $ES_AUTOVSCROLL + $ES_READONLY)
$chatControl = GUICtrlCreateEdit("", 10, $Wsize_h - 180, 300, 80, $ES_WANTRETURN)

$ChatButton = GUICtrlCreateButton("Send", 10, $Wsize_h - 90, -1, 20)
GUICtrlSetOnEvent($ChatButton, "ChatButton")

$AwayCheck = GUICtrlCreateCheckbox("TrayTip", 220, $Wsize_h - 90, -1, 20)
GUICtrlSetOnEvent($AwayCheck, "Notification")

$PushButton = GUICtrlCreateCheckbox("Alwaysontop", 220, $Wsize_h - 75, -1, 20)
GUICtrlSetOnEvent($PushButton, "PushButton")

$usercheck = GUICtrlCreateCheckbox("Username", 220, $Wsize_h - 60, -1, 20)
GUICtrlSetState($usercheck, 1)
GUICtrlSetState(-1, $gui_hide)

$InputControl = GUICtrlCreateInput("", 0, 20, $W_size_w, 20, $ES_READONLY)
GUICtrlSetState(-1, $gui_hide)

;~ $statusbar1 = _GuiCtrlStatusBarCreate($mainWindow, 100, "Ready")

$notify_on_minimize = 0
$initial = 0
$File_opened = 0
$count2 = 0
$scan2 = ""

While 1
	Tailit()
	Sleep(100)
WEnd

Func Tailit()
	$error = 0
	$file = ControlGetText("Tailchat", "", $InputControl)
	$count = _FileCountLines($file)
	$scan = FileReadLine($file, $count)
	$file_contents = ""
	If WinActive("Tailchat") = 1 Then
		If _IsPressed("0D") Then
			ChatButton()
		EndIf
	EndIf
	
	
	For $x = 1 To $count
		$scan3 = FileReadLine($file, $x)
		$display = _isSystemLine($file, $scan3, $x)
		If $display = 1 Then
			$file_contents &= $scan3 & @CRLF
		ElseIf $display = 0 Then
		EndIf
	Next
	
	
	if ($File_opened = 1) and ($initial = 0) Then
		GUICtrlSetData($editControl, $file_contents)
		_GUICtrlEditLineScroll($editControl, 0, $count)
		$initial = 1
	EndIf
	
	If $File_opened = 1 Then
		Select
			Case $count2 <> $count
				
				GUICtrlSetData($editControl, $file_contents)
				If BitAND(WinGetState("Tailchat"), 16) Then
					If $notify_on_minimize = 1 Then
						TrayTip("TailChat", $scan, 5, 1)
					EndIf
				EndIf
				
				_GUICtrlEditLineScroll($editControl, 0, $count)
				
			Case $scan2 <> $scan
				GUICtrlSetData($editControl, $file_contents)
				_GUICtrlEditLineScroll($editControl, 0, $count)
		EndSelect
	EndIf
	
	$count2 = $count
	$scan2 = $scan
	
EndFunc   ;==>Tailit

Func FileopenButton()
	$nologin = 0
	$old_file = ""
	If $File_opened = 1 Then
		$old_file = $selected_file
	EndIf
	Global $selected_file = FileOpenDialog("Open", @ScriptDir, "Text Files (*.*)")
	If $selected_file = "" Then
		$selected_file = $old_file
		$nologin = 1
	Else
		_logout()
	EndIf
	GUICtrlSetData($InputControl, $selected_file)
	Global $openfile = FileOpen($selected_file, 0)
	$error = @error
	$File_opened = 1
	If $nologin <> 1 Then
		_login()
	EndIf
EndFunc   ;==>FileopenButton

Func CLOSEClicked()
	_logout()
	FileClose($openfile)
	
	Exit
EndFunc   ;==>CLOSEClicked

Func ChatButton()
	
	$check_status = GUICtrlRead($usercheck)
	$inputtext = ControlGetText("", "", $chatControl)
	If $File_opened = 1 Then
		If $check_status = 1 Then
			$inputtext = @HOUR & ":" & @MIN & " " & @UserName & ":   " & $inputtext
		EndIf
		$openfilewrite = FileOpen($selected_file, 1)
		FileWriteLine($openfilewrite, $inputtext)
		GUICtrlSetData($chatControl, "")
		FileClose($openfilewrite)
	Else
		MsgBox(0, "No chat", "No chat has been logged into, nothing to send")
	EndIf
EndFunc   ;==>ChatButton

Func PushButton()
	If GUICtrlRead($PushButton) = 1 Then
		WinSetOnTop("Tailchat", "", 1)
	ElseIf GUICtrlRead($PushButton) = 4 Then
		WinSetOnTop("Tailchat", "", 0)
	EndIf
EndFunc   ;==>PushButton

Func _login()
	$openfilewrite = FileOpen($selected_file, 1)
	_FileWriteToLine($selected_file, 1, "##~~!!" & @UserName & "|" & @HOUR & @MIN & "|" & Random(1, 20, 1), 0)
	FileWriteLine($openfilewrite, "--> " & @UserName & " has joined this chat at " & @HOUR & ":" & @MIN)
	FileClose($openfilewrite)
EndFunc   ;==>_login

Func _logout()
	$openfilewrite = FileOpen($selected_file, 1)
	_RemoveOnlineUser()
	FileWriteLine($openfilewrite, "--> " & @UserName & " has left at " & @HOUR & ":" & @MIN)
	FileClose($openfilewrite)
EndFunc   ;==>_logout

Func Notification()
	If GUICtrlRead($AwayCheck) = 1 Then
		$notify_on_minimize = 1
	ElseIf GUICtrlRead($AwayCheck) = 4 Then
		$notify_on_minimize = 0
	EndIf
EndFunc   ;==>Notification

Func _isSystemLine($file, $scan3, $x)
	If StringInStr($scan3, "##~~!!") <> 0 Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_isSystemLine

Func _RemoveOnlineUser()
	Dim $atest, $aloc[1]
	_FileReadToArray($selected_file, $atest)
	For $x = 1 to (UBound($atest) - 1)
		$isme = StringInStr($atest[$x], "##~~!!" & @UserName)
		If $isme <> 0 Then
			_ArrayAdd($aloc, $x)
		EndIf
	Next
	For $y = (UBound($aloc) - 1) To 1 Step - 1
		_FileWriteToLine($selected_file, $aloc[$y], "", 1)
	Next
EndFunc   ;==>_RemoveOnlineUser

Func ShowUsers()
	If $File_opened = 1 Then
		Dim $aEntFile, $afileusers[1]
		_FileReadToArray($selected_file, $aEntFile)
		For $x = 1 To UBound($aEntFile) - 1
			If StringInStr($aEntFile[$x], "##~~!!") <> 0 Then
				$sUser = StringTrimLeft($aEntFile[$x], 6)
				$aSubUser = StringSplit($sUser, "|")
				_ArrayAdd($afileusers, $aSubUser[1])
			EndIf
		Next
		_ArrayDisplay($afileusers, "Array : aFileUsers ")
	Else
		MsgBox(0, "No Chat opened", "There are no users to display since you are not currently logged into a chat")
	EndIf
EndFunc   ;==>ShowUsers
Func Options()
EndFunc   ;==>Options

Func About()
	MsgBox(64, "About Tail Chat 2.2", "Tailchat was written in AutoIT V3.2" & @LF & @LF & "Written by : Blademonkey")
EndFunc   ;==>About