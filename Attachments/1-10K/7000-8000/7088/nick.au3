#include <GUIConstants.au3>
#include <GuiList.au3>
#include <GuiListView.au3>
#include <Process.au3>
#include<Array.au3>
#include<File.au3>
;#NoTrayIcon


GUICreate("fun",640,480)


$mylist = GUICtrlCreateList("", 5, 165, 629, 165, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY))
;GUICtrlSetLimit(-1,200) ; to limit horizontal scrolling

$outlook = GUICtrlCreateCheckbox ("Somebody works on this computer and it has Microsoft Outlook or Outlook Express e-Mail.", 5, 350)
$exchange = GUICtrlCreateCheckbox ("This computer is an unattended Server and has Microsoft Exchange Installed.", 5, 368)
$nonms = GUICtrlCreateCheckbox ("This computer is an unattended Server and has a non Microsoft e-Mail system installed.", 5, 386)

GuiSetState()


While 1

$msg = GUIGetMsg()


If BitAnd(GuiCtrlRead($outlook),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState ( $exchange, $GUI_UNCHECKED )
			GUICtrlSetState ( $nonms, $GUI_UNCHECKED )
			;GUICtrlSetState ( $outlook, $GUI_CHECKED )
EndIf

If BitAnd(GuiCtrlRead($exchange),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState ( $outlook, $GUI_UNCHECKED )
			GUICtrlSetState ( $nonms, $GUI_UNCHECKED )
			;GUICtrlSetState ( $exchange, $GUI_CHECKED )
EndIf

If BitAnd(GuiCtrlRead($nonms),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState ( $exchange, $GUI_UNCHECKED )
			GUICtrlSetState ( $outlook, $GUI_UNCHECKED )
			;GUICtrlSetState ( $nonms, $GUI_CHECKED )
EndIf

WEnd

GUIDelete()

Exit