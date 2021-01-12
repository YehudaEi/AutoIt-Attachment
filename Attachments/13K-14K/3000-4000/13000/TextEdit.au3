; DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1)
$tray_exit = TrayCreateItem("Exit")
#include <GUIConstants.au3>
#Include <GuiStatusBar.au3>
#include <File.au3>
TraySetIcon("shell32.dll",70)
$file = FileOpenDialog("Choose text file","Desktop","Text Files (*.txt)")
$readfile = FileOpen($file, 0)
$text = FileRead($readfile)
If $file = "" Then
	MsgBox(0,"TextEdit 0.0 alpha 1","Action canceled!")
	Exit
EndIf
Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[1] = [400]
Local $a_PartsText[1] = ["Opened file: " & $file]
$gui = GUICreate("TextEdit 0.0 alpha 1",400,400,$WS_EX_ACCEPTFILES)
GUISetIcon("shell32.dll",70)
HotKeySet("{F1}", "About")
Func About()
	MsgBox(64,"About TextEdit","TextEdit 0.0 alpha 1" & @CRLF & "By Richard Gatinho")
EndFunc
$filemenu = GUICtrlCreateMenu("File")
$open = GUICtrlCreateMenuItem("Open",$filemenu)
$save = GUICtrlCreateMenuItem("Save",$filemenu)
$exit = GUICtrlCreateMenuItem("Exit",$filemenu)
$editmenu = GUICtrlCreateMenu("Edit")
$copy = GUICtrlCreateMenuItem("Copy",$editmenu)
Func copy()
	MsgBox(0,"TextEdit 0.0 alpha 1","Under development!")
EndFunc
Func paste()
	MsgBox(0,"TextEdit 0.0 alpha 1","Under development!")
EndFunc
$paste = GUICtrlCreateMenuItem("Paste",$editmenu)
$utilities = GUICtrlCreateMenu("Utilities")
$msgboxwiz = GUICtrlCreateMenuItem("MsgBoxWiz",$utilities)
$inputboxwiz = GUICtrlCreateMenuItem("InputBoxWiz",$utilities)
$ping = GUIctrlCreateMenuItem("Ping",$utilities)
$tracert = GUICtrlCreateMenuItem("Tracert",$utilities)
$sysinfo = GUICtrlCreateMenuItem("SysInfo",$utilities)
$editor = GUICtrlCreateEdit($text,-1,-1,400,360)
$statusbar = _GUICtrlStatusBarCreate($gui,$a_PartsRightEdge,$a_PartsText)
_GUICtrlStatusBarSetIcon($statusbar, 0, "shell32.dll", 70)
GUISetState()
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
		Case $msg = $GUI_EVENT_RESIZED
            _GUICtrlStatusBarResize ($StatusBar1)
		Case $msg = $open
			ShellExecute(@ScriptDir & "\TextEdit.au3")
			Exit
		Case $msg = $tray_exit
			Exit
		Case $msg = $exit
			Exit 
		Case $msg = $save
			MsgBox(0,"TextEdit 0.0 alpha 1","Under development!")
		Case $msg = $copy
			copy()
		Case $msg = $paste
			paste()
		Case $msg = $msgboxwiz
			$msgbox_title = InputBox("MsgBoxWiz","Title","")
			$msgbox_text = InputBox("MsgBoxWiz","Text","")
			ClipPut("MsgBox(0," & $msgbox_title & "," & $msgbox_text & ")")
			MsgBox(64,"MsgBoxWiz","Copied AutoIt code to clipboard!" & @CRLF & "Press OK to test.")
			MsgBox(0,$msgbox_title,$msgbox_text) 
		Case $msg = $inputboxwiz
      		$inputbox_title = InputBox("InputBoxWiz","Title")
			$inputbox_prompt = InputBox("InputBoxWiz","Prompt")
			$inputbox_default = InputBox("InputBoxWiz","Default text (leave blank for no text)")
			ClipPut('InputBox(' & $inputbox_title & ',' & $inputbox_prompt & ',' & $inputbox_default & ')')
 			MsgBox(64,"MsgBoxWiz","Copied AutoIt code to clipboard!" & @CRLF & "Press OK to test.")
			InputBox($inputbox_title,$inputbox_prompt,$inputbox_default)
		Case $msg = $tracert
			$tracert = InputBox("Tracert","Host or IP address:")
			If $tracert = "" Then 
				MsgBox(0,"Tracert","Action canceled!")
			Else
				Run(@ComSpec & " /c tracert " & $tracert & " -w 60000 & pause")
			EndIf
		Case $msg = $ping
			$var1 = InputBox("Ping","Insert site name or IP Address to ping:")
			If $var1 = "" Then 
				MsgBox(0,"Ping","Action canceled! You will receive a bad destination error.")
			EndIf
			$var2 = Ping($var1,60000)
			If $var2 Then
				Msgbox(0,"Ping","Online, roundtrip was:" & $var2)
			Else
				If @error = 1 Then
						MsgBox(16,"Ping","Host is offline!")
				Else
					If @error = 2 Then
						MsgBox(16,"Ping","Unreachable host!")
					Else
						If @error = 3 Then
							MsgBox(16,"Ping","Bad destination!")
						Else
							If @error = 4 Then
									MsgBox(16,"Ping","Unknown error!")
							EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Case $msg = $sysinfo
				; ShellExecute(@ScriptDir & '\SysInfo.exe')
	EndSelect
Wend