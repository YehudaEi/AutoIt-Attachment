#include <GUIConstants.au3>
#Include <Constants.au3>

Global Const $s_Title = 'TrayAndGUI'
Global Const $s_Version = 'v0.1'
Global Const $GUI_Height = '460'
Global Const $GUI_Width = '412'

AutoItSetOption("WinTitleMatchMode", 4)

$Transparenz 		=	RegRead ("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz")	; Wert zwischen 0 - 255

TraySetToolTip($s_Title & " - " & $s_Version)
Opt("TrayAutoPause",0) 
Opt("TrayMenuMode",1) 

$resultitem		= TrayCreateItem("Result")
TrayCreateItem("")
$settingsmenuitem	= TrayCreateMenu("Preferences")
$settingstransmenuitem	= TrayCreateMenu("Transparenz",$settingsmenuitem )
$settingstrans10item	= TrayCreateItem("10 %",  $settingstransmenuitem)
$settingstrans20item	= TrayCreateItem("20 %",  $settingstransmenuitem)
$settingstrans30item	= TrayCreateItem("30 %",  $settingstransmenuitem)
$settingstrans40item	= TrayCreateItem("40 %",  $settingstransmenuitem)
$settingstrans50item	= TrayCreateItem("50 %",  $settingstransmenuitem)
$settingstrans60item	= TrayCreateItem("60 %",  $settingstransmenuitem)
$settingstrans70item	= TrayCreateItem("70 %",  $settingstransmenuitem)
$settingstrans80item	= TrayCreateItem("80 %",  $settingstransmenuitem)
$settingstrans90item	= TrayCreateItem("90 %",  $settingstransmenuitem)
$settingstrans100item	= TrayCreateItem("100 %", $settingstransmenuitem)
TrayCreateItem("")
$exititem		= TrayCreateItem("Quit")

TraySetState()

Transparenz()

While 1

$msgTray = 	TrayGetMsg()
$msgGUI = 	GUIGetMsg()

	If $msgGUI = $GUI_EVENT_CLOSE Then
	ExitLoop
	EndIf
		
	If $msgTray = $settingstrans10item Then
	Transparenz10()
	EndIf

	If $msgTray = $settingstrans20item Then
	Transparenz20()
	EndIf

	If $msgTray = $settingstrans30item Then
	Transparenz30()
	EndIf

	If $msgTray = $settingstrans40item Then
	Transparenz40()
	EndIf

	If $msgTray = $settingstrans50item Then
	Transparenz50()
	EndIf

	If $msgTray = $settingstrans60item Then
	Transparenz60()
	EndIf

	If $msgTray = $settingstrans70item Then
	Transparenz70()
	EndIf

	If $msgTray = $settingstrans80item Then
	Transparenz80()
	EndIf

	If $msgTray = $settingstrans90item Then
	Transparenz90()
	EndIf

	If $msgTray = $settingstrans100item Then
	Transparenz100()
	EndIf

	If $msgTray = $resultitem Then
	Results()
	EndIf
	
	If $msgTray = $exititem then 
	ExitLoop
	EndIf
Wend

Exit

Func Transparenz()
	If $Transparenz=26 then
	TrayItemSetState($settingstrans10item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"26")
	EndIf

	If $Transparenz=51 then
	TrayItemSetState($settingstrans20item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"51")
	EndIf

	If $Transparenz=77 then
	TrayItemSetState($settingstrans30item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"77")
	EndIf

	If $Transparenz=102 then
	TrayItemSetState($settingstrans40item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"102")
	EndIf

	If $Transparenz=128 then
	TrayItemSetState($settingstrans50item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"128")
	EndIf

	If $Transparenz=153 then
	TrayItemSetState($settingstrans60item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"153")
	EndIf

	If $Transparenz=179 then
	TrayItemSetState($settingstrans70item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"179")
	EndIf

	If $Transparenz=204 then
	TrayItemSetState($settingstrans80item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"204")
	EndIf

	If $Transparenz=230 then
	TrayItemSetState($settingstrans90item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"230")
	EndIf

	If $Transparenz=255 then
	TrayItemSetState($settingstrans100item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"255")
	EndIf
EndFunc

Func Transparenz10()
	TrayItemSetState($settingstrans10item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"26")
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz20()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"51")
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz30()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"77")
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc


Func Transparenz40()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"102")
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz50()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"128")
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz60()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"153")
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz70()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"179")
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz80()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"204")
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz90()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"230")
	TrayItemSetState($settingstrans100item,$TRAY_UNCHECKED)
EndFunc

Func Transparenz100()
	TrayItemSetState($settingstrans10item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans20item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans30item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans40item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans50item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans60item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans70item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans80item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans90item,$TRAY_UNCHECKED)
	TrayItemSetState($settingstrans100item,$TRAY_CHECKED)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz",	"REG_SZ",	"255")
EndFunc


Func Results()

$RESULT_WINDOW = GUICreate($s_Title &" " & $s_Version, $GUI_Width, $GUI_Height, -1, -1,$WS_EX_LAYERED)

		$Transparenz=RegRead ("HKEY_CURRENT_USER\SOFTWARE\TrayAndGUI",	"Transparenz")
		WinSetTrans("classname=AutoIt v3 GUI", "", $Transparenz)
		
		$tab=GUICtrlCreateTab (10,10,$GUI_Width -20, $GUI_Height -75, $TCS_MULTILINE,$TCS_TOOLTIPS)
		$tab_01=GUICtrlCreateTabitem ("just a tab")		
		$tab_01_Group_1 = GUICtrlCreateGroup("with a group",		20, 55,  370, 80)
		$tab_01_Label_02 = GUICtrlCreateLabel("and a label",  	40,  75, 250, 20)

		$ResultQuitButton	=	GUICtrlCreateButton ("OK", 340,400,60)
		GUISetState()
While 1
	$msg = GUIGetMsg()

	Select
		Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
		Case $msg = $ResultQuitButton
		ExitLoop
	EndSelect
WEnd
GUIDelete()

EndFunc  ;==>_Results

