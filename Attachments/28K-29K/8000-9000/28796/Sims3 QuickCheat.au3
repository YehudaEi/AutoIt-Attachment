#NoTrayIcon
#include <GuiConstants.au3>
Opt("RunErrorsFatal", 0)

Dim $GUI, $Pic, $label, $Button_1, $Commands

$Path = IniReadSection("Commands.ini", "EXEPath")

if $Path[1][1] = "0" Then
$message = "Please locate your sims 3 exe"
$var = FileOpenDialog($message, "C:\Program Files\Electronic Arts\The Sims 3\Game\Bin\", "Sims 3 (Sims3Launcher.exe; TS3.exe)", 1 + 4 )
If @error Then
    MsgBox(4096,"","Game exe not found")
Else
    $var = StringReplace($var, "|", @CRLF)
	$Path = "Location = " & $var
	FileChangeDir(@ScriptDir)
	IniWriteSection("Commands.ini","EXEPath",$Path)
EndIf
EndIf

$Path = IniReadSection("Commands.ini", "EXEPath")
$App = Run($Path [1][1])

_INI()

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $Button_1
			Run(@ComSpec & " /c " & 'Commands.ini', "", @SW_HIDE)
			WinWait("Commands.ini","")
			WinWaitClose("Commands.ini","")
			GUIDelete ($GUI)
			_INI()
    EndSelect
Wend

Func _INI()
$Commands = IniReadSection("Commands.ini", "Commands")

HotKeySet("{F1}","_Command1")
HotKeySet("{F2}","_Command2")
HotKeySet("{F3}","_Command3")
HotKeySet("{F4}","_Command4")
HotKeySet("{F5}","_Command5")
HotKeySet("{F6}","_Command6")
HotKeySet("{F7}","_Command7")
HotKeySet("{F8}","_Command8")
HotKeySet("{F9}","_Command9")
HotKeySet("{F10}","_Command10")
HotKeySet("{F11}","_Command11")


$GUI = GUICreate("Sims 3 Auto Cheater", 500, 230, 200, 1)
$Pic = GUICtrlCreatePic("TS3Auto.jpg", 5, 5, 280, 190)
$label = GUICtrlCreateLabel("F1: " & $Commands[1][1], 290, 10)
$label = GUICtrlCreateLabel("F2: " & $Commands[2][1], 290, 30)
$label = GUICtrlCreateLabel("F3: " & $Commands[3][1], 290, 50)
$label = GUICtrlCreateLabel("F4: " & $Commands[4][1], 290, 70)
$label = GUICtrlCreateLabel("F5: " & $Commands[5][1], 290, 90)
$label = GUICtrlCreateLabel("F6: " & $Commands[6][1], 290, 110)
$label = GUICtrlCreateLabel("F7: " & $Commands[7][1], 290, 130)
$label = GUICtrlCreateLabel("F8: " & $Commands[8][1], 290, 150)

$label = GUICtrlCreateLabel("F9: " & $Commands[9][1], 290, 170)
$label = GUICtrlCreateLabel("F10: " & $Commands[10][1], 290, 190)
$label = GUICtrlCreateLabel("F11: " & $Commands[11][1], 290, 210)

$Button_1 = GUICtrlCreateButton ("Edit Configuration",  70, 202, 150)

GUISetState()
EndFunc

Func _Command1()
Send("^+c")
Sleep(200)
Send($Commands[1][1])
Send("{ENTER}")
EndFunc

Func _Command2()
Send("^+c")
Sleep(200)
Send($Commands[2][1])
Send("{ENTER}")
EndFunc

Func _Command3()
Send("^+c")
Sleep(200)
Send($Commands[3][1])
Send("{ENTER}")
EndFunc

Func _Command4()
Send("^+c")
Sleep(200)
Send($Commands[4][1])
Send("{ENTER}")
EndFunc	

Func _Command5()
Send("^+c")
Sleep(200)
Send($Commands[5][1])
Send("{ENTER}")
EndFunc	

Func _Command6()
Send("^+c")
Sleep(200)
Send($Commands[6][1])
Send("{ENTER}")
EndFunc	

Func _Command7()
Send("^+c")
Sleep(200)
Send($Commands[7][1])
Send("{ENTER}")
EndFunc

Func _Command8()
Send("^+c")
Sleep(200)
Send($Commands[8][1])
Send("{ENTER}")
EndFunc

Func _Command9()
Send("^+c")
Sleep(200)
Send($Commands[9][1])
Send("{ENTER}")
EndFunc	

Func _Command10()
Send("^+c")
Sleep(200)
Send($Commands[10][1])
Send("{ENTER}")
EndFunc	

Func _Command11()
Send("^+c")
Sleep(200)
Send($Commands[11][1])
Send("{ENTER}")
EndFunc