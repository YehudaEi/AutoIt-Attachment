$uname = IniRead(@ScriptDir & "\ChattaData.chdt", "User", "Name", "Unknown")
$chmw = IniRead(@ScriptDir & "\ChattaData.chdt", "Sounds", "Sound", 3)
$fsize = IniRead(@ScriptDir & "\ChattaData.chdt", "Font", "FColor", "00x999999")
$fname = IniRead(@ScriptDir & "\ChattaData.chdt", "Font", "FName", "Tahoma")
FileInstall("E:\NewChatMessage1.wav", @ScriptDir & "\NewChatMessage1.wav")
FileInstall("E:\NewChatMessage2.wav", @ScriptDir & "\NewChatMessage2.wav")
FileInstall("E:\NewChatMessage3.wav", @ScriptDir & "\NewChatMessage3.wav")
AutoItSetOption("TrayAutoPause", 0)
#include <GUIConstants.au3>
#include <Misc.au3>
#include <Array.au3>
$show = TrayCreateItem("Show Chatta")
$exit = TrayCreateItem("Exit Chatta")
$Form3 = GUICreate("Chatta", 169, 173, 281, 168)
$newchat = GUICtrlCreateButton("New", 8.5, 8.5, 153, 41, 0)
$joinbutton = GUICtrlCreateButton("Join", 8.5, 56, 153, 49, 0)
$opt = GUICtrlCreateButton("Options..", 8.5, 144, 153, 25, 0)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	$tmsg = TrayGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $newchat
		;begin New Chat
		$d = FileSaveDialog("New Chat", "C:\", "Chatta Chats (*.chat)")
		If FileExists($d & ".chat") Then
			MsgBox(0, "Sorry", "You can't replace an existing chat.")
			Run(@ScriptDir & "\Chatta.exe")
			Exit
		EndIf
		If MsgBox(4, "Open Chat?", "Would you like to open this chat to the public?") = 7 Then
			IniWrite($d & ".chat", "Chat", "Open", 0)
			$allowed = InputBox("Chatta Allowed Chatters", "Enter the name of the chatter that you want to be allowed.")
			IniWrite($d & ".chat", "Chat", "Allowed user 1", $allowed)
			$allowed = InputBox("Chatta Allowed Chatters", "Enter the name of the second chatter that you want to be allowed.")
			IniWrite($d & ".chat", "Chat", "Allowed user 2", $allowed)
			$allowed = InputBox("Chatta Allowed Chatters", "Enter the name of the third chatter that you want to be allowed.")
			IniWrite($d & ".chat", "Chat", "Allowed user 3", $allowed)
		Else
			IniWrite($d & ".chat", "Chat", "Open", 1)
		EndIf
	IniWrite($d & ".chat", "Users", "User 1", $uname)
$u1 = IniRead($d & ".chat", "Users", "User 1", "")
$u2 = IniRead($d & ".chat", "Users", "User 2", "")
$u3 = IniRead($d & ".chat", "Users", "User 3", "")
$Form2 = GUICreate($d & ".chat Chatta Chat", 318.5, 253, 257, 170)
$TextPut = GUICtrlCreateInput("", 8.5, 220, 241, 21)
GUISetState(@SW_SHOW)
Global $lr = ""
Global $lastsentuser = ""
$lrbefore = $lr
$gr = 0
$log = 0
$LastSent1 = ""
$lr1 = ""
$lr2 = ""
$lr3 = ""
$lr4 = ""
$lr5 = ""
$lru1 = ""
$lru2 = ""
$lru3 = ""
$lru4 = ""
$lru5 = ""
$lrc1 = ""
$lrc2 = ""
$lrc3 = ""
$lrc4 = ""
$lrc5 = ""
$z = ""
Global $fc5 
Global $fc4
Global $fc4 
Global $fc3
Global $fc3
Global $fc2
Global $fc2 
Global $fc1
Global $fc1 
Global $lrfs
Global $fn5 
Global $fn4
Global $fn4 
Global $fn3
Global $fn3 
Global $fn2
Global $fn2 
Global $fn1
Global $fn1 
global $lrfn
$time = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC
While 1
	$lr = IniRead($d & ".chat", "Chat", "Last Sent-", "")
		If $lrbefore <> $lr Then
			If IniRead(@ScriptDir & "ChattaData.chdt", "Log?", "Log...", 0) = 1 Then
				IniWrite(@ScriptDir & "ChattaData.chdt", "Log?", "Log" & $gr + 1, $lr)
				$gr = $gr + 1
			EndIf
			$lastsentuser = IniRead($d & ".chat", "Chat", "Last Sent User", "")
			$lrfn = IniRead($d & ".chat", "Chat", "Last Sent Font Name", "Tahoma")
			$lrfc = IniRead($d & ".chat", "Chat", "Last Sent Font Color", 000000)
			$lr5 = $lr4
			$lr4 = $lr3
			$lr3 = $lr2
			$lr2 = $lr1
			$lr1 = $lr
			$lru5 = $lru4
			$lru4 = $lru3
			$lru3 = $lru2
			$lru2 = $lru1
			$lru1 = $lastsentuser
			$fc5 = $fc4
			$fc4 = $fc3
			$fc3 = $fc2
			$fc2 = $fc1
			$fc1 = $lrfc
			$fn5 = $fn4
			$fn4 = $fn3
			$fn3 = $fn2
			$fn2 = $fn1
			$fn1 = $lrfn
			GUICtrlDelete($lrc1)
			$lrc1 = GUICtrlCreateLabel($lru1 & " says: " & $lr1, 8.5, 146, 500, 30)
			GUICtrlSetFont($lrc1, 8.5, -1, -1, $fn1)
			GUICtrlSetColor($lrc1, $lrfc)
			GUICtrlDelete($lrc2)
			$lrc2 = GUICtrlCreateLabel($lru2 & " says: " & $lr2, 8.5, 116, 500, 30)
			GUICtrlSetFont($lrc2, 8.5, -1, -1, $fn2)
			GUICtrlSetColor($lrc2, $fc2)
			GUICtrlDelete($lrc3)
			$lrc3 = GUICtrlCreateLabel($lru3 & " says: " & $lr3, 8.5, 86, 500, 30)
			GUICtrlSetFont($lrc3, 8.5, -1, -1, $fn3)
			GUICtrlSetColor($lrc3, $fc3)
			GUICtrlDelete($lrc4)
			$lrc4 = GUICtrlCreateLabel($lru4 & " says: " & $lr4, 8.5, 56, 500, 30)
			GUICtrlSetFont($lrc4, 8.5, -1, -1, $fn4)
			GUICtrlSetColor($lrc4, $fc4)
			GUICtrlDelete($lrc5)
			$lrc5 = GUICtrlCreateLabel($lru5 & " says: " & $lr5, 8.5, 26, 500, 30)
			GUICtrlSetFont($lrc5, 8.5, -1, -1, $fn5)
			GUICtrlSetColor($lrc5, $fc5)
			If WinActive($d & " Chatta Chat") = 0 Then
				SoundPlay(@ScriptDir & "\NewChatMessage" & $chmw & ".wav")
			EndIf
		EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			If MsgBox(4, "Delete?", "Would you like to delete this chat? If you have Log Chats on, it will still be there in the chat log.") = 6 Then
				FileDelete($d & ".chat")
				Run(@ScriptDir & "\Chatta.exe")
				Exit
			Else
				Run(@ScriptDir & "\Chatta.exe")
				Exit
			EndIf

		Case $TextPut
			$LastSent1 = GUICtrlRead($TextPut)
			IniWrite($d & ".chat", "Chat", "Last Sent-", $LastSent1)
			IniWrite($d & ".chat", "Chat", "Last Sent User", $uname)
			GUICtrlDelete($TextPut)
			$TextPut = GUICtrlCreateInput("", 8.5, 220, 241, 21)
			ControlFocus($d & " Chatta Chat", "", $TextPut)
			IniWrite($d & ".chat", "Chat", "Last Sent Font Name", $fname)
			IniWrite($d & ".chat", "Chat", "Last Sent Font Color", $fsize)
			
		
		EndSwitch
		$log = IniRead($d & ".chat", "Chat", "Last Sent-", $LastSent1)
		IniWrite(@ScriptDir & "ChattaData.chdt", "Log?", "Log" & $gr + 1, $gr)
		$lrbefore = $lr
		
WEnd
;end New Chat
			
		
	Case $joinbutton
;begin Join Chat
$d = FileOpenDialog("Open Chat", "C:\", "Chatta Chats (*.chat)")
If @error = 1 Then
	MsgBox(0, "Sorry", "ERROR!!! ARGH!!!")
	Run(@ScriptDir & "\Chatta.exe")
	Exit
EndIf
If IniRead($d & ".chat", "Chat", "Open", 1) = 0 Then
	If IniRead($d & ".chat", "Chat", "Allowed user 1", "") <> $uname Then
		If IniRead($d & ".chat", "Chat", "Allowed user 2", "") <> $uname Then
			If IniRead($d & ".chat", "Chat", "Allowed user 3", "") <> $uname Then
				MsgBox(0, "Sorry", "This chat is private, and you are not on the allowed-user list.")
				Run(@ScriptDir & "\Chatta.exe")
				Exit
			EndIf
		EndIf
	EndIf
EndIf
If IniRead($d , "Users", "User 1", "") <> "" then
	If IniRead($d , "Users", "User 2", "") <> "" then
		If IniRead($d , "Users", "User 3", "") <> "" Then
			If IniRead($d , "Users", "User 4", "") <> "" Then
				If IniRead($d , "Users", "User 5", "") <> "" Then
					MsgBox(0, "Sorry!", "This chat is full.")
					Run(@ScriptDir & "\Chatta.exe")
					Exit
				Else
					IniWrite($d , "Users", "User 5", "")
				EndIf
			Else
			IniWrite($d , "Users", "User 4", "")
			EndIf
		Else
			IniWrite($d , "Users", "User 3", $uname)
		EndIf
	Else
		IniWrite($d , "Users", "User 2", $uname)
	EndIf
Else
	IniWrite($d , "Users", "User 1", $uname)
EndIf
$u1 = IniRead($d , "Users", "User 1", "")
$u2 = IniRead($d , "Users", "User 2", "")
$u3 = IniRead($d , "Users", "User 3", "")
$Form1 = GUICreate($d & " Chatta Chat", 318.5, 253, 257, 170)
$TextPut = GUICtrlCreateInput("", 8.5, 220, 241, 21)
GUISetState(@SW_SHOW)
Global $lr = ""
Global $lastsentuser = ""
$lrbefore = $lr
$gr = 0
$log = 0
$LastSent1 = 0
$time = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC
$LastSent1 = ""
$lr1 = ""
$lr2 = ""
$lr3 = ""
$lr4 = ""
$lr5 = ""
$lru1 = ""
$lru2 = ""
$lru3 = ""
$lru4 = ""
$lru5 = ""
$lrc1 = ""
$lrc2 = ""
$lrc3 = ""
$lrc4 = ""
$lrc5 = ""
$z = ""
Global $fc5 
Global $fc4
Global $fc4 
Global $fc3
Global $fc3 
Global $fc2
Global $fc2 
Global $fc1
Global $fc1 
Global $lrfs
Global $fn5 
Global $fn4
Global $fn4 
Global $fn3
Global $fn3 
Global $fn2
Global $fn2 
Global $fn1
Global $fn1 
global $lrfn
While 1
	
	$lr = IniRead($d , "Chat", "Last Sent-", "")
	If @MIN & @SEC > $time Then
		$time = @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC
		If FileExists($d) = 0 then
			MsgBox(0, "Sorry", "The person who created this chat has deleted it.")
			Run(@ScriptDir & "\Chatta.exe")
			Exit
		EndIf
	EndIf
	If $lrbefore <> $lr Then
			If IniRead(@ScriptDir & "ChattaData.chdt", "Log?", "Log...", 0) = 1 Then
				IniWrite(@ScriptDir & "ChattaData.chdt", "Log?", "Log" & $gr + 1, $lr)
				$gr = $gr + 1
			EndIf
			$lastsentuser = IniRead($d, "Chat", "Last Sent User", "")
			$lrfn = IniRead($d, "Chat", "Last Sent Font Name", "Tahoma")
			$lrfc = IniRead($d, "Chat", "Last Sent Font Color", 000000)
			$lr5 = $lr4
			$lr4 = $lr3
			$lr3 = $lr2
			$lr2 = $lr1
			$lr1 = $lr
			$lru5 = $lru4
			$lru4 = $lru3
			$lru3 = $lru2
			$lru2 = $lru1
			$lru1 = $lastsentuser
			$fc5 = $fc4
			$fc4 = $fc3
			$fc3 = $fc2
			$fc2 = $fc1
			$fc1 = $lrfc
			$fn5 = $fn4
			$fn4 = $fn3
			$fn3 = $fn2
			$fn2 = $fn1
			$fn1 = $lrfn
			GUICtrlDelete($lrc1)
			$lrc1 = GUICtrlCreateLabel($lru1 & " says: " & $lr1, 8.5, 146, 500, 30)
			GUICtrlSetFont($lrc1, 8.5, -1, -1, $fn1)
			GUICtrlSetColor($lrc1, $lrfc)
			GUICtrlDelete($lrc2)
			$lrc2 = GUICtrlCreateLabel($lru2 & " says: " & $lr2, 8.5, 116, 500, 30)
			GUICtrlSetFont($lrc2, 8.5, -1, -1, $fn2)
			GUICtrlSetColor($lrc2, $fc2)
			GUICtrlDelete($lrc3)
			$lrc3 = GUICtrlCreateLabel($lru3 & " says: " & $lr3, 8.5, 86, 500, 30)
			GUICtrlSetFont($lrc3, 8.5, -1, -1, $fn3)
			GUICtrlSetColor($lrc3, $fc3)
			GUICtrlDelete($lrc4)
			$lrc4 = GUICtrlCreateLabel($lru4 & " says: " & $lr4, 8.5, 56, 500, 30)
			GUICtrlSetFont($lrc4, 8.5, -1, -1, $fn4)
			GUICtrlSetColor($lrc4, $fc4)
			GUICtrlDelete($lrc5)
			$lrc5 = GUICtrlCreateLabel($lru5 & " says: " & $lr5, 8.5, 26, 500, 30)
			GUICtrlSetFont($lrc5, 8.5, -1, -1, $fn5)
			GUICtrlSetColor($lrc5, $fc5)
			If WinActive($d & " Chatta Chat") = 0 Then
				SoundPlay(@ScriptDir & "\NewChatMessage" & $chmw & ".wav")
			EndIf
		EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
			Run(@ScriptDir & "\Chatta.exe")
			Exit

		Case $TextPut
			$LastSent1 = GUICtrlRead($TextPut)
			IniWrite($d , "Chat", "Last Sent-", $LastSent1)
			IniWrite($d , "Chat", "Last Sent User", $uname)
			GUICtrlDelete($TextPut)
			$TextPut = GUICtrlCreateInput("", 8.5, 220, 241, 21)
			ControlFocus($d & " Chatta Chat", "", $TextPut)
			IniWrite($d, "Chat", "Last Sent Font Name", $fname)
			IniWrite($d, "Chat", "Last Sent Font Color", $fsize)
		
		EndSwitch
		$log = IniRead($d , "Chat", "Last Sent-", $LastSent1)
		$lrbefore = $lr
WEnd
;end Join Chat

	Case $opt
;begin Options
#include <GUIConstants.au3>

$Form1 = GUICreate("Chatta Options", 256, 234, 193, 115)
$apply = GUICtrlCreateButton("Apply", 8, 176, 113, 49, 0)
$cancel = GUICtrlCreateButton("Cancel", 128, 176, 121, 49, 0)
$unm = GUICtrlCreateLabel("Username:", 8, 8, 55, 17)
$unme = GUICtrlCreateInput($uname, 8, 32, 241, 21)
$logchats = GUICtrlCreateCheckbox("Log Chats", 8, 64, 161, 17)
$1s = GUICtrlCreateRadio("Message Sound 1", 8, 85)
$2s = GUICtrlCreateRadio("Message Sound 2", 8, 105)
$3s = GUICtrlCreateRadio("Message Sound 3", 8, 125)
$4s = GUICtrlCreateRadio("No Message Sound", 8, 145)
$font = GUICtrlCreateButton("Font...", 120, 85)
If $chmw = 1 Then
	GUICtrlSetState($1s, $GUI_CHECKED)
ElseIf $chmw = 2 Then
	GUICtrlSetState($2s, $GUI_CHECKED)
ElseIf $chmw = 3 Then
	GUICtrlSetState($3s, $GUI_CHECKED)
EndIf
	
If IniRead(@ScriptDir & "ChattaData.chdt", "Log?", "Log...", 0) = 1 Then
	GUICtrlSetState($logchats, $GUI_CHECKED)
EndIf
GUISetState(@SW_SHOW)
$sound = 0
$f = _ArrayCreate("")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
_ArrayAdd($f, "")
While 1
	$nMsg2 = GUIGetMsg()
	Switch $nMsg2
		Case $GUI_EVENT_CLOSE
			Run(@ScriptDir & "\Chatta.exe")
			Exit
			
		Case $font
			$f = _ChooseFont($fname, $fsize)
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")
			_ArrayAdd($f, "")

		Case $apply
			IniWrite(@ScriptDir & "\ChattaData.chdt", "User", "Name", GUICtrlRead($unme))
			If GUICtrlRead($1s) = $GUI_CHECKED Then
				$sound = 1
			ElseIf GUICtrlRead($2s) = $GUI_CHECKED Then
				$sound = 2
			ElseIf GUICtrlRead($3s) = $GUI_CHECKED Then
				$sound = 3
			Else
				$sound = 0
			EndIf
			If GUICtrlRead($logchats) = $GUI_CHECKED Then
				IniWrite(@ScriptDir & "\ChattaData.chdt", "Log?", "Log...", 1)
			Else
				IniWrite(@ScriptDir & "\ChattaData.chdt", "Log?", "Log...", 0)
			EndIf
			IniWrite(@ScriptDir & "\ChattaData.chdt", "Sounds", "Sound", $sound)
			IniWrite(@ScriptDir & "\ChattaData.chdt", "Font", "FName", $f[2])
			IniWrite(@ScriptDir & "\ChattaData.chdt", "Font", "FColor", $f[7])
			Run(@ScriptDir & "\Chatta.exe")
			Exit

		Case $cancel
			Run(@ScriptDir & "\Chatta.exe")
			Exit
	EndSwitch
WEnd
;end Options
	EndSwitch
	Switch $tmsg
	Case $show
		GUISetState(@SW_SHOW)
	Case $exit
		Exit
	EndSwitch
WEnd
