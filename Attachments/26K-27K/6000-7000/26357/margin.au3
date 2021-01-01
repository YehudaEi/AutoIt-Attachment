#include <Date.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <EditConstants.au3>
Opt("TrayAutoPause",0)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)

HotKeySet("{ESC}", "Minimize")
HotKeySet("^\", "GoTime")
TraySetClick(16)
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE,"GoTime")
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "GoTime")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitScript")
TraySetState()

GUICreate("AB Margin/Markup", 180, 260, 400, 400, $WS_CAPTION, $WS_EX_TOPMOST)
GUICtrlCreateLabel ("Cost", 5, 170)
GUICtrlCreateLabel ("Retail", 40, 170)
GUICtrlCreateLabel ("Margin", 90, 170)
GUICtrlCreateLabel ("Markup", 140, 170)

$cost1 = GUICtrlCreateLabel ("", 5, 185, 30, 15)
$retail1 = GUICtrlCreateLabel ("", 40, 185, 30, 15)
$margin1 = GUICtrlCreateLabel ("", 90, 185, 40, 15)
$markup1 = GUICtrlCreateLabel ("", 140, 185, 40, 15)
$cost2 = GUICtrlCreateLabel ("", 5, 200, 30, 15)
$retail2 = GUICtrlCreateLabel ("", 40, 200, 30, 15)
$margin2 = GUICtrlCreateLabel ("", 90, 200, 40, 15)
$markup2 = GUICtrlCreateLabel ("", 140, 200, 40, 15)
$cost3 = GUICtrlCreateLabel ("", 5, 215, 30, 15)
$retail3 = GUICtrlCreateLabel ("", 40, 215, 30, 15)
$margin3 = GUICtrlCreateLabel ("", 90, 215, 40, 15)
$markup3 = GUICtrlCreateLabel ("", 140, 215, 40, 15)
$cost4 = GUICtrlCreateLabel ("", 5, 230, 30, 15)
$retail4 = GUICtrlCreateLabel ("", 40, 230, 30, 15)
$margin4 = GUICtrlCreateLabel ("", 90, 230, 40, 15)
$markup4 = GUICtrlCreateLabel ("", 140, 230, 40, 15)
$cost5 = GUICtrlCreateLabel ("", 5, 245, 30, 15)
$retail5 = GUICtrlCreateLabel ("", 40, 245, 30, 15)
$margin5 = GUICtrlCreateLabel ("", 90, 245, 40, 15)
$markup5 = GUICtrlCreateLabel ("", 140, 245, 40, 15)

GUICtrlCreateLabel ("Cost:", 18, 18, 70, 20)
GUICtrlCreateLabel ("Retail:", 12, 41, 70, 20)
$cost = GUICtrlCreateInput ("", 60,  15, 70, 20) 
$retail = GUICtrlCreateInput ("", 60,  38, 70, 20)
$calculate = GUICtrlCreateButton("Calculate", 15, 70, 60)
$clear = GUICtrlCreateButton("Clear", 85, 70, 60)
$copycost = GUICtrlCreateButton("Copy",135, 16, 30, 17)
$copyretail = GUICtrlCreateButton("Copy",135, 39, 30, 17)
$copymargin = GUICtrlCreateButton("Copy",135, 116, 30, 17)
$copymarkup = GUICtrlCreateButton("Copy",135, 139, 30, 17)
GUICtrlCreateLabel ("Margin:", 13, 118, 70, 20)
GUICtrlCreateLabel ("Markup:", 10, 141, 70, 20)
$marginbox = GUICtrlCreateInput ("", 60,  115, 70, 20) 
$markupbox = GUICtrlCreateInput ("", 60,  138, 70, 20)
GUISetBkColor (0xff2626) 
GUISetState (@SW_HIDE)

$count = 1
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $copycost
            $costvalue = GUICtrlRead($cost)
            clipput ($costvalue)
        Case $msg = $copyretail
            $retailvalue = GUICtrlRead($retail)
            clipput ($retailvalue)
        Case $msg = $copymargin
            $marginvalue = GUICtrlRead($marginbox)
            clipput ($marginvalue)
        Case $msg = $copymarkup
            $markupvalue = GUICtrlRead($markupbox)
            clipput ($markupvalue)                                
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $calculate
            $retailvalue = GUICtrlRead($retail)
            $costvalue = GUICtrlRead($cost)
            $marginvalue = GUICtrlRead($marginbox)
            $markupvalue = GUICtrlRead($markupbox)
            if $retailvalue = "" AND $markupvalue = "" Then
                $retailvalue = Round(($costvalue * ($marginvalue/100)+$costvalue), 2)
                GUICtrlSetData ($retail, $retailvalue)
            ElseIf $costvalue = "" AND $markupvalue = "" Then
                $costvalue = Round($retailvalue - ($retailvalue * ($marginvalue/100)), 2)
                GUICtrlSetData ($cost, $costvalue)
            ElseIf $retailvalue = "" AND $marginvalue = "" Then
                $retailvalue = Round(($costvalue * ($markupvalue/100)+$costvalue), 2)
                GUICtrlSetData ($retail, $retailvalue)
            else
                $margin = Round(((($retailvalue - $costvalue)/$retailvalue)*100), 2)
                GUICtrlSetData ($marginbox, ($margin & "%"))
                $markup = Round(((($retailvalue - $costvalue)/$costvalue)*100), 2)
                GUICtrlSetData ($markupbox, ($markup & "%"))
            EndIf
            $marginvalue = GUICtrlRead($marginbox)
            $markupvalue = GUICtrlRead($markupbox)
  
  
            GUICtrlSetData ($cost5, GUICtrlRead($cost4))
            GUICtrlSetData ($retail5, GUICtrlRead($retail4))
            GUICtrlSetData ($margin5, GUICtrlRead($margin4))
            GUICtrlSetData ($markup5, GUICtrlRead($markup4)) 
            GUICtrlSetData ($cost4, GUICtrlRead($cost3))
            GUICtrlSetData ($retail4, GUICtrlRead($retail3))
            GUICtrlSetData ($margin4, GUICtrlRead($margin3))
            GUICtrlSetData ($markup4, GUICtrlRead($markup3))
            GUICtrlSetData ($cost3, GUICtrlRead($cost2))
            GUICtrlSetData ($retail3, GUICtrlRead($retail2))
            GUICtrlSetData ($margin3, GUICtrlRead($margin2))
            GUICtrlSetData ($markup3, GUICtrlRead($markup2))
            GUICtrlSetData ($cost2, GUICtrlRead($cost1))
            GUICtrlSetData ($retail2, GUICtrlRead($retail1))
            GUICtrlSetData ($margin2, GUICtrlRead($margin1))
            GUICtrlSetData ($markup2, GUICtrlRead($markup1))                                    
            GUICtrlSetData ($cost1, $costvalue)
            GUICtrlSetData ($retail1, $retailvalue)
            GUICtrlSetData ($margin1, $marginvalue)
            GUICtrlSetData ($markup1, $markupvalue)







        Case $msg = $clear
            GUICtrlSetData ($marginbox, (""))
            GUICtrlSetData ($markupbox, (""))
            GUICtrlSetData ($cost, (""))
            GUICtrlSetData ($retail, (""))
            GUICtrlSetState ($cost, $GUI_FOCUS)
    EndSelect
Wend

Func GoTime()
     GUISetState (@SW_SHOW)
     GUICtrlSetData ($marginbox, (""))
     GUICtrlSetData ($markupbox, (""))
     GUICtrlSetData ($cost, (""))
     GUICtrlSetData ($retail, (""))
     GUICtrlSetState ($cost, $GUI_FOCUS)
EndFunc

Func Minimize()
     GUISetState (@SW_HIDE)
EndFunc

Func ExitScript()
Exit
EndFunc