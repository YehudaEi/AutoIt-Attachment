#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>

Global $t = "Temp", $gui, $eMsg, $exit, $a = "Running", $d = "Not running"
Global $raw, $rawgui, $totalkey, $vkeyraw, $reset
Global $valgui, $vkeyval, $valcon, $valcopy, $valsave

opt("GUICloseOnEsc", 1)
$maingui = GUICreate($t, 525, 130)
GUISetFont(11, 500, "", "Tahoma")
$raw = GUICtrlCreateButton("Bug", 5, 6, 100, 30)
$log = GUICtrLCreateButton("B", 5, 36, 100, 30)
$info = GUICtrlCreateButton("C", 5, 66, 100, 30)
$valid = GUICtrlCreateButton("SaveDialog", 5, 96, 100, 30)
$start = GUICtrlCreateButton("Start!", 425, 85, 95, 40)
$stop = GUICtrlCreateButton("Stop!", 425, 85, 95, 40)
GUICtrlCreateLabel("Status:", 425, 45, 44, 18)
$status = GUICtrlCreateLabel("", 425, 65, 75, 19)
GUICtrlCreateLabel("Select Region:", 425, 5, 100, 25)
GUISetFont(7, 200, "")
$region = GUICtrlCreateCombo("", 425, 25, 95, 30)
$regiondata = GUICtrlSetData($region, "Data1|Data2|Data3|Data4")
GUICtrlSetState($start, $GUI_FOCUS)
GUISetState()
GUICtrlSetData($status, $d)
ControlHide($t, "", 8)

While 1
   $gui = GUIGetMsg(1)
   Switch $gui[1]
   Case $maingui
	  Switch $gui[0]
   Case $GUI_EVENT_CLOSE
	  If GUICtrlRead($status) = $a Then
		 $exit = MsgBox(292, $t, "Still running! Continue to exit?")
	  EndIf
	  If $exit = 6 Then
		 ExitLoop
	  ElseIf $exit = 7 Then
		 WinActivate($t)
	  Else
		 ExitLoop
	  EndIf
   Case $info
	  info()
   Case $start
	  mainStart()
   Case $stop
	  stop()
   Case $log
	  ;//DO NOTHING
   Case $raw
	  GUICtrlSetState($raw, $GUI_DISABLE)
	  a()
   Case $valid
	  GUICtrlSetState($valid, $GUI_DISABLE)
	  b()
	  EndSwitch
   Case $rawgui
	  Switch $gui[1]
   Case $GUI_EVENT_CLOSE
	  GUIDelete($rawgui)
	  GUICtrlSetState($raw, $GUI_ENABLE)
	  EndSwitch
   Case $valgui
	  Switch $gui[0]
   Case $GUI_EVENT_CLOSE
	  GUIDelete($valgui)
	  GUICtrlSetState($valid, $GUI_ENABLE)
   Case $valsave
	  FileSaveDialog("Save valid keys to...", @ScriptDir, "Text files (*.txt)", 2) ;bug for Raw Output occurs here?
	  EndSwitch
   EndSwitch
   WEnd

Func mainStart()
   If GUICtrlRead($region) = "" Then
	  $eMsg = MsgBox(0x30, $t, "No region selected. Please select a region!")
	  $eMsg = 1
	  Else
	  GUICtrLSetData($status, $a)
	  ControlHide($t, "", 7)
	  ControlShow($t, "", 8)
	  GUICtrlSetState($region, $GUI_DISABLE)
	  If GUICtrlRead($status) = $a Then
		 $eMsg = 0
		 EndIf
	  EndIf
EndFunc

Func stop()
   ControlHide($t, "", 8)
   ControlShow($t, "", 7)
   GUICtrlSetState($region, $GUI_ENABLE)
   GUICtrlSetData($status, $d)
EndFunc

Func info()
   MsgBox(0, $t & " - Information", "blah")
EndFunc

Func changeLog()
   ;//DO NOTHING
EndFunc

Func a()
   $rawgui = GUICreate($t, 500, 250)
   GUISetFont(11, 500, "", "Tahoma")
   $totalkey = GUICtrlCreateLabel("Total # of keys generated:", 5, 5)
   $vkeyraw = GUICtrlCreateLabel("Total # of valid keys:", 340, 5)
   $rawcon = GUICtrlCreateEdit("Not running.", 5, 30, 490, 180, $ES_READONLY)
   GUISetFont(15, 550)
   $reset = GUICtrlCreateButton("RESET", 5, 213, 490, 35)
   GUICtrlSetState($reset, $GUI_FOCUS)
   GUISetState()
EndFunc

Func b()
   $valgui = GUICreate($t, 300, 230)
   GUISetFont(11, 500, "", "Tahoma")
   $vkeyval = GUICtrlCreateLabel("List of all valid keys", 5, 5)
   $valcon = GUICtrlCreateEdit("", 5, 30, 290, 160, $ES_READONLY)
   GUICtrlSetData($valcon, "Nothing yet!")
   $valcopy = GUICtrlCreateButton("Copy all to clipboard", 5, 195, 145, 30)
   $valsave = GUICtrLCreateButton("Save all to file", 150, 195, 145, 30)
   GUISetState()
EndFunc
