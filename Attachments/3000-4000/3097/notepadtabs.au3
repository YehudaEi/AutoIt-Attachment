#include <Array.au3>
#include <ANYGUI.au3>
#include <guiconstants.au3>
#Include <GuiTab.au3>

Opt("WinTitleMatchMode", 3)
Opt("WinWaitDelay", 0)
Opt("GUIOnEventMode", 1)

$pid = Run("notepad.exe")
WinWait("Untitled - Notepad")
$hWnd = _GuiTarget("Untitled - Notepad", 1)

$child = _TargetaddChild("", 0, 0, 5000, 20)
$newtab = GUICtrlCreateButton("+", 0, 0, 20, 20, $BS_ICON + $BS_FLAT)
$closetab = GUICtrlCreateButton("X", 25, 0, 20, 20, $BS_ICON + $BS_FLAT)
$tab = GUICtrlCreateTab(50, 0, 5000, 20)
$tabs = _ArrayCreate(GUICtrlCreateTabItem("Untitled"))
GUICtrlCreateTabItem("")

GUICtrlSetImage($newtab, "shell32.dll", 225, 0)
GUICtrlSetImage($closetab, "shell32.dll", 131, 0)

GUICtrlSetOnEvent($newtab, "onNewTab")
GUICtrlSetOnEvent($closetab, "onCloseTab")

GUISetState(@SW_SHOW)
While WinExists($hWnd)
  $size = WinGetClientSize($hWnd)
  If WinExists($hWnd) Then
    ControlMove($hWnd, "", 15, 0, 20, $size[0], $size[1] - 43)
    ControlMove($hWnd, "", "SysTabControl321", 25, 0, $size[0] - 50, 20)
    ControlMove($hWnd, "", "Button2", $size[0] - 20, 0, 20, 20)
  EndIf

  Sleep(100)
WEnd

Func onNewTab()
  _ArrayAdd($tabs, GUICtrlCreateTabItem("Untitled"))
  GUICtrlCreateTabItem("")
EndFunc

Func onCloseTab()
  $curr = _GUICtrlTabGetCurSel($tab)
  $num = _GUICtrlTabGetItemCount($tab)

  If $curr < $num - 1 Then
    _GUICtrlTabDeleteItem($tab, $curr)
    _ArrayDelete($tabs, $curr)
    _GUICtrlTabSetCurSel($tab, $curr)
  ElseIf $num > 1 Then
    _GUICtrlTabDeleteItem($tab, $curr)
    _ArrayDelete($tabs, $curr)
    _GUICtrlTabSetCurSel($tab, $num - 2)
  Else
    _ArrayAdd($tabs, GUICtrlCreateTabItem("Untitled"))
    GUICtrlCreateTabItem("")
    _GUICtrlTabSetCurSel($tab, 1)
    _GUICtrlTabDeleteItem($tab, 0)
    _ArrayDelete($tabs, 0)
  EndIf
EndFunc