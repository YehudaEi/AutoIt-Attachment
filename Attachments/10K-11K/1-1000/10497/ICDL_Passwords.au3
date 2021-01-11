#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.1.1.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#NoTrayIcon
#include <GuiConstants.au3>
#include <GuiCombo.au3>
#include <file.au3>

Global Const $WM_COMMAND = 0x0111
Global Const $CBN_EDITCHANGE = 5;
Global Const $CBN_SELCHANGE = 1;
Global Const $CBN_EDITUPDATE = 6;
Global Const $DebugIt = 1
Global $old_string = ""
$GUI_ICDL = GUICreate("ICDL Passwords", 200, 190)
GUISetState (@SW_SHOW)

GUICtrlCreateLabel("Students Name:", 15, 15)
$Username = GUICtrlCreateCombo("", 15, 35, 170, 20)
$old_string = ""
GUICtrlCreateLabel("Type the students name in full", 15, 65)
GUICtrlCreateLAbel("ie: firstname lastname", 15, 80)

$GetPassword = GUICtrlCreateButton("Get Password", 50, 110, 100)
$Maintenance = GUICtrlCreateButton("Maintenance (admin only)", 25, 150, 150)

HotKeySet ("{ESC}", "_NewUser")

$file = FileOpen(@ScriptDir&"\"&"users.txt", 0)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file containing passwords")
    Exit
EndIf
$NumberOfLines = _FileCountLines(@ScriptDir&"\"&"users.txt")

$LineNumber = 1
While 1
	$Line = FileReadLine($File, $LineNumber)
	If @error = -1 Then ExitLoop
	$Line1 = Stringlen($Line)
	$Line2 = $line1 - 6
	$Line3 = StringRight($Line, $line2)
	_GUICtrlComboAddString($username, $line3)
	$LineNumber = $lineNumber + 1
WEnd

GUISetState()
GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
    $msg = GUIGetMsg()
    Select
        Case $msg = $GetPassword
		$UName = StringUpper(GUICtrlRead($Username))
		For $i = 0 To $NumberOfLines Step 1
		$line = FileReadLine($file, $i)
		If @error = -1 Then ExitLoop
		$UsernameAndPassword = StringRegExp($line, $Uname, 0)
			If @extended = 1 then
				$Password = StringLeft($line, 6)
				MsgBox(0, "Password Is", "The password for "&GUICtrlRead($Username)&" is: " &$Password)
			EndIF
		Next
	Case $msg = $Maintenance
		MsgBox(0, "Maintenace:", "maintenance has been started")
		ExitLoop
    EndSelect
WEnd





Func _Combo_Changed()
    ;----------------------------------------------------------------------------------------------
    If $DebugIt Then    ConsoleWrite (_DebugHeader("Combo Changed:" & GUICtrlRead($username)))
    ;----------------------------------------------------------------------------------------------
    _GUICtrlComboAutoComplete($username, $old_string)
EndFunc   ;==>_Combo_Changed

Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
    Local $nNotifyCode = _HiWord($wParam)
    Local $nID = _LoWord($wParam)
    Local $hCtrl = $lParam
   
    Switch $nID
        Case $username
            Switch $nNotifyCode
                Case $CBN_EDITUPDATE, $CBN_EDITCHANGE ; when user types in new data
                    _Combo_Changed()
                Case    $CBN_SELCHANGE ; item from drop down selected
                    _Combo_Changed()
            EndSwitch
    EndSwitch
    ; Proceed the default Autoit3 internal message commands.
    ; You also can complete let the line out.
    ; !!! But only 'Return' (without any value) will not proceed
    ; the default Autoit3-message in the future !!!
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND

Func _DebugHeader($s_text)
    Return _
            "!===========================================================" & @LF & _
            "+===========================================================" & @LF & _
            "-->" & $s_text & @LF & _
            "+===========================================================" & @LF
EndFunc   ;==>_DebugHeader

Func _HiWord($x)
    Return BitShift($x, 16)
EndFunc   ;==>_HiWord

Func _LoWord($x)
    Return BitAND($x, 0xFFFF)
EndFunc   ;==>_LoWord

Func _NewUser()
	FileClose($File)
	$file = FileOpen(@ScriptDir&"\"&"users.txt", 1)
	If $file = -1 Then
	    MsgBox(0, "Error", "Unable to open file containing passwords")
 	   Exit
	EndIf
	GUICreate("Maintenance", 200, 190, -1, -1, -1, -1, $GUI_ICDL)
	GUISetState (@SW_SHOW)
		GUICTrlCreateLabel("First Name", 15, 15)
		$FirstName = GUICtrlCreateInput("", 15, 30, 170)
		GUICTrlCreateLabel("Lastname", 15, 60)
		$LastName = GUICtrlCreateInput("", 15, 75, 170)
		GUICTrlCreateLabel("Password", 15, 105)
		$NewPassword = GUICtrlCreateInput("", 15, 120, 170)
		$Add_User = GUICtrlCreateButton("Add User", 50, 155, 100)
While 1
	$Msg = GUIGetMsg()
	Select
		Case $Msg = $GUI_EVENT_CLOSE
			Exit
		Case $Msg = $Add_User
			$NewUserLine = String(GUICtrlRead($NewPassword)&GUICtrlRead($FirstName)&" "&GUICtrlRead($LastName))
			$NextLineInFile = $NumberOfLines + 1
			_FileWriteToLine($File, $NextLineInFile, $NewUserLine, 0)
			Sleep(1000)
			Exit
	EndSelect

WEnd
EndFunc   ;==>_NewUser