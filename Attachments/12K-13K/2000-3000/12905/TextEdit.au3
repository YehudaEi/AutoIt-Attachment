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
	MsgBox(0,"TextEdit 1.0","Action canceled!")
	Exit
EndIf
Local $gui, $StatusBar1, $msg
Local $a_PartsRightEdge[1] = [400]
Local $a_PartsText[1] = ["Opened file: " & $file]
$gui = GUICreate("TextEdit 1.0",400,400)
GUISetIcon("shell32.dll",70)
HotKeySet("{F1}", "About")
Func About()
	MsgBox(64,"About TextEdit","TextEdit 1.0" & @CRLF & "By Richard Gatinho")
EndFunc
$filemenu = GUICtrlCreateMenu("File")
$open = GUICtrlCreateMenuItem("Open",$filemenu)
$save = GUICtrlCreateMenuItem("Save",$filemenu)
$exit = GUICtrlCreateMenuItem("Exit",$filemenu)
$editmenu = GUICtrlCreateMenu("Edit")

$copy = GUICtrlCreateMenuItem("Copy      CTRL+C",$editmenu)
HotKeySet("^c","copy")
Func copy()
	MsgBox(0,"TextEdit 1.0","Under development!")
EndFunc
HotKeySet("^v","paste")
Func paste()
	MsgBox(0,"TextEdit 1.0","Under development!")
EndFunc
$paste = GUICtrlCreateMenuItem("Paste     CTRL+V",$editmenu)
$utilities = GUICtrlCreateMenu("Utilities")
$msgboxwiz = GUICtrlCreateMenuItem("MsgBoxWiz",$utilities)
$inputboxwiz = GUICtrlCreateMenuItem("InpuxBoxWiz",$utilities)
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
			MsgBox(0,"TextEdit 1.0","Under development!")
		Case $msg = $tray_exit
			Exit
		Case $msg = $exit
			Exit
		Case $msg = $save
			MsgBox(0,"TextEdit 1.0","Under development!")
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
    EndSelect
Wend