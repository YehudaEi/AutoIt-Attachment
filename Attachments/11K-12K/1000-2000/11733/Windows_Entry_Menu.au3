#include <GUIConstants.au3>
Dim $ItemCustomerExist = 0, $ItemArticleExist = 0, $ItemSerialExist = 0
Dim $stat_Customer, $stat_Article, $stat_Serial
Dim $itemCustomer, $itemArticle, $itemSerial

$MainGUI = GUICreate("Main", Default, Default, Default, Default, BitOr($WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_MAXIMIZE))
$menu0 = GUICtrlCreateMenu("File")
$m0_item1 = GUICtrlCreateMenuItem("End", $menu0)
$menu1 = GUICtrlCreateMenu("Master Data")
$m1_item1 = GUICtrlCreateMenuItem("Customer                 Strg+U", $menu1)
$m1_item2 = GUICtrlCreateMenuItem("Articles                    Strg+A", $menu1)
$m1_item3 = GUICtrlCreateMenuItem("Serial Number's       Strg+S", $menu1)
$menu2 = GUICtrlCreateMenu("Window")
$menu3 = GUICtrlCreateMenu("?")
$m2_item1 = GUICtrlCreateMenuItem("Help", $menu3)
$m2_item2 = GUICtrlCreateMenuItem("About", $menu3)

$CustomerGUI = GUICreate("Customer", 867, 551, -1, -1, BitOr($WS_CAPTION, $WS_POPUP, $WS_SYSMENU), $WS_EX_TOPMOST)
$ArticleGUI = GUICreate("Articles", 867, 551, -1, -1, BitOr($WS_CAPTION, $WS_POPUP, $WS_SYSMENU), $WS_EX_TOPMOST)
$SerialGUI = GUICreate("Serial Number's", 867, 551, -1, -1, BitOr($WS_CAPTION, $WS_POPUP, $WS_SYSMENU), $WS_EX_TOPMOST)

GUISetState(@SW_SHOW,$MainGUI)
HotKeySet("^u", "_StrgU")
HotKeySet("^a", "_StrgA")
HotKeySet("^s", "_StrgS")

While 1
	_SetEntryWindowMenu()
	$msg = GuiGetMsg(1)
	Select
	Case $msg[0] = $GUI_EVENT_CLOSE
		Select
		Case $msg[1] = $MainGUI
			ExitLoop
		Case $msg[1] = $CustomerGUI
			GUISetState(@SW_HIDE,$CustomerGUI)
		Case $msg[1] = $ArticleGUI
			GUISetState(@SW_HIDE,$ArticleGUI)
 		Case $msg[1] = $SerialGUI
 			GUISetState(@SW_HIDE,$SerialGUI)
		EndSelect
	Case $msg[1] = $MainGUI 
		Select
		Case $msg[0] = $m0_item1
			ExitLoop
		Case $msg[0] = $m1_item1
			GUISetState(@SW_SHOW,$CustomerGUI)
		Case $msg[0] = $m1_item2
			GUISetState(@SW_SHOW,$ArticleGUI)
		Case $msg[0] = $m1_item3
 			GUISetState(@SW_SHOW,$SerialGUI)
		Case $msg[0] = $itemCustomer
			WinActivate("Customer")
		Case $msg[0] = $itemArticle
			WinActivate("Articles")
		Case $msg[0] = $itemSerial
			WinActivate("Serial Number's")
		Case $msg[0] = $m2_item1
;~ 			Help
		Case $msg[0] = $m2_item2
;~ 			About
		EndSelect
	EndSelect	
WEnd

Func _StrgU()
	GUISetState(@SW_SHOW,$CustomerGUI)
EndFunc

Func _StrgA()
	GUISetState(@SW_SHOW,$ArticleGUI)
EndFunc

Func _StrgS()
 	GUISetState(@SW_SHOW,$SerialGUI)
EndFunc

Func _SetEntryWindowMenu()
	$stat_Customer = WinGetState("Customer")
	If $stat_Customer = 7 Or $stat_Customer = 15 Then
		If $ItemCustomerExist = 0 Then
			$itemCustomer = GUICtrlCreateMenuItem("Customer", $menu2)
			$ItemCustomerExist = 1
		EndIf 
	Else
		If $ItemCustomerExist = 1 Then
			GUICtrlDelete($itemCustomer)
			$ItemCustomerExist = 0
		EndIf
	EndIf
	$stat_Article = WinGetState("Articles")
	If $stat_Article = 7 Or $stat_Article = 15 Then
		If $ItemArticleExist = 0 Then
			$itemArticle = GUICtrlCreateMenuItem("Articles", $menu2)
			$ItemArticleExist = 1
		EndIf
	Else
		If $ItemArticleExist = 1 Then
			GUICtrlDelete($itemArticle)
			$ItemArticleExist = 0
		EndIf
	EndIf
	$stat_Serial = WinGetState("Serial Number's")
	If $stat_Serial = 7 Or $stat_Serial = 15 Then
		If $ItemSerialExist = 0 Then
			$itemSerial = GUICtrlCreateMenuItem("Serial Number's", $menu2)
			$ItemSerialExist = 1
		EndIf
	Else
		If $ItemSerialExist = 1 Then
			GUICtrlDelete($itemSerial)
			$ItemSerialExist = 0
		EndIf
	EndIf	
EndFunc
		