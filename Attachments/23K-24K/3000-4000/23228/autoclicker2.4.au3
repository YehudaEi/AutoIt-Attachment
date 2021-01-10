#include <GUIConstantsEx.au3>

HotKeySet("{F2}", "Toggleleft")
HotKeySet("{F3}", "Togglemiddle")
HotKeySet("{F4}", "Toggleright")
HotKeySet("{F6}", "Togglespace")
HotKeySet("{F7}", "Togglecustom")
HotKeySet("{`}", "setcustom")
HotKeySet("{lshift}{`}", "setcustom")
HotKeySet("{ESC}", "Terminate")

Dim $left = 0
Dim $middle = 0
Dim $right = 0
Dim $space = 0
Dim $custom = 0
Dim $cus = "{TAB}" ;what key is sent by F7
Local $SS_CENTER

ToolTip("active. press ~ for help",0,0)
sleep(500)
ToolTip("")
ToolTip("active. press ~ for help",@desktopwidth-120,0)
sleep(500)
ToolTip("")
ToolTip("active. press ~ for help",@desktopwidth-120,@desktopheight-20)
sleep(500)
ToolTip("")
ToolTip("active. press ~ for help",0,@desktopheight-20)
sleep(500)
ToolTip("")
ToolTip("press ~ for help",(@desktopwidth-120)/2,(@desktopheight-20)/2)
sleep(2000)
ToolTip("")

;;;; Body of program would go here ;;;;
While 1
	if $left = 1 Then
		MouseClick("left")
	ElseIf $middle = 1 Then
		MouseClick("middle")
	ElseIf $right = 1 Then
		MouseClick("right")
	ElseIf $space = 1 Then
		send("{space}")
	elseif $custom = 1 then
		send($cus)
	Else 
		sleep(100)
		ToolTip("")
	EndIf
WEnd
;;;;;;;;

Func Toggleleft()
	if $left = 0 then
		$left = 1
	Else 
		$left = 0
	EndIf
$middle = 0
$right = 0
$space = 0
$custom = 0
EndFunc

Func Togglemiddle()
	if $middle = 0 then
		$middle = 1
	Else 
		$middle = 0
	EndIf
$left = 0
$right = 0
$space = 0
$custom = 0
EndFunc

Func Toggleright()
	if $right = 0 then
		$right = 1
	Else 
		$right = 0
	EndIf
$middle = 0
$left = 0
$space = 0
$custom = 0
EndFunc

Func Togglespace()
	if $space = 0 then
		$space = 1
	Else 
		$space = 0
	EndIf
$middle = 0
$right = 0
$left = 0
$custom = 0
EndFunc

Func Togglecustom()
	if $custom = 0 then
		$custom = 1
	Else 
		$custom = 0
	EndIf
$middle = 0
$right = 0
$left = 0
$space = 0
EndFunc

Func setcustom()
	ToolTip("")
	$left = 0
	$middle = 0
	$right = 0
	$space = 0
	$custom = 0
	$gui = GUICreate("select custom autokey",220,170)
	$combo2 = GUICtrlCreateCombo("",10,10,200,30)
	GUICtrlSetData(-1,"{TAB}|{UP}|{DOWN}|{LEFT}|{RIGHT}|{ENTER}|{NUMPADENTER}|{LSHIFT}|{RSHIFT}|{LCTRL}|{RCTRL}|{LALT}|{RALT}|{LWIN}|{RWIN}|{BACKSPACE}|{DELETE}|{HOME}|{END}|{INSERT}|{PGUP}|{PGDN}|{PRINTSCREEN}") ;|{a}|{b}|{c}|{d}|{e}|{f}|{g}|{h}|{i}|{j}|{k}|{l}|{m}|{n}|{o}|{p}|{q}|{r}|{s}|{t}|{u}|{v}|{w}|{x}|{y}|{z}
	GUICtrlCreateLabel("select a key to autopress or type some text to autotype. Version 2.4             F1-autoclick left          F2-autoclick middle F2 autoclick right        F6 autosend space F7 curently sends " & $cus & "                                                                                    autoclicker / autokeysender / autotalker by corganno, at dd_omaga@hotmail.com.",10,60,200,150,$SS_CENTER)
	$button = GUICtrlCreateButton("ok",10,36,200,20)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then Exit
		If $msg = $button Then 
			$cus = GUICtrlRead($combo2)
			GUIDelete($gui)
			ExitLoop
		endif
	WEnd
EndFunc

Func Terminate()
	Exit 0
EndFunc


