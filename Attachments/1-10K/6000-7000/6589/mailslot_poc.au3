#include <GUIConstants.au3>

Dim $larry, $curly, $moe

;Create the mailslot
$ourcall = DllCall("kernel32.dll", "ptr", "CreateMailslot", "str", "\\.\mailslot\AutoIt3", "int", 0, "int", -1, "ptr", 0)
If Not $ourCall[0] Then
   MsgBox(0, "Error", "Couldn't create mail slot!")
Else
   $ourMailslot = $ourCall[0]
EndIf

$GUI = GUICreate("UniqueMessengerName",300,200,@DesktopWidth - 300, @DesktopHeight,$WS_POPUP)
GUISetBkColor(0x000000)

;
; Window region functions by Larry
;
$a = CreateRoundRectRgn(0,0,300,100,50,50)
$b = CreateRoundRectRgn(40,100,240,30,20,20)
CombineRgn($a,$b)
$b = CreateRoundRectRgn(80,130,190,20,10,10)
CombineRgn($a,$b)
SetWindowRgn($GUI,$a)
;
;

$static = GUICtrlCreateLabel("", 10,10,290,90)
GUICtrlSetColor($static, 0xFFFFFF)
GUISetState()

$notShowing = 1
While 1
   ; Test for messages if we're not currently dsiplaying one
   If $notShowing Then
      $ourCall = DllCall("kernel32.dll", "int", "GetMailslotInfo", "ptr", $ourMailslot, "int_ptr", 0, "int_ptr", $larry,  "int_ptr", $curly,  "int_ptr", 0)
      If Not $ourCall[0] Then
         MsgBox(0, "Error", "Couldn't get mail slot info!")
      Else
         If $ourCall[4] Then
            ; Message(s) present
            $msgSize = $ourCall[3]
            ; Create byte buffer the size of the next message
            $ourBuffer = DllStructCreate("byte[" & $msgSize & "]")
            ; Do read
            $ourCall = DllCall( "kernel32.dll", "int", "ReadFile", "ptr", $ourMailslot, "ptr",DllStructGetPtr($ourBuffer), "int",$msgSize, "int_ptr",$moe, "ptr",0 )
            If Not IsArray($ourCall) Then
               MsgBox(0, "Error", "Couldn't read from mail slot!")
            Else
               ; Data read, so typecast bytes down to characters
               $ourChars = DllStructCreate("char[" & $msgSize & "]", DllStructGetPtr($ourBuffer))
               $charMsg = DllStructGetData($ourChars, 1)
               ; Show window and display message
               For $placement = 0 to 200
                  WinMove("UniqueMessengerName", "", @DesktopWidth - 300, @DesktopHeight - $placement)
               Next
               GUICtrlSetData($static, $charMsg)
               $notShowing = 0
            EndIf
            ; Release buffer
            $ourBuffer = 0
         EndIf
      EndIf
   EndIf
   $msg = GUIGetMsg()
   If $msg = $static Or $msg = $GUI_EVENT_CLOSE Then
      For $placement = 255 to 0 Step -5
         WinSetTrans("UniqueMessengerName", "", $placement)
      Next
      ; Hide window
      WinMove("UniqueMessengerName", "", @DesktopWidth - 300, @DesktopHeight - $placement)
      WinSetTrans("UniqueMessengerName", "", 255)
      $notShowing = 1
      GUICtrlSetData($static, "")
   EndIf
WEnd

Func OnAutoItExit()
   ; Release mailslot handle
   $ourCall = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $ourMailslot)
EndFunc   ;==>OnAutoItExit

;
; Window region functions by Larry
;
Func SetWindowRgn($h_win, $rgn)
   DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc   ;==>SetWindowRgn

Func CreatePolyRgn($pt)
   Local $ALTERNATE = 1
   Local $buffer = ""
   
   $pt = StringSplit($pt,",")
   For $i = 1 to $pt[0]
      $buffer = $buffer & "int;"
   Next
   $buffer = StringTrimRight($buffer,1)
   $lppt = DllStructCreate($buffer)
   For $i = 1 to $pt[0]
      DllStructSetData($lppt,$i,$pt[$i])
   Next
   $ret = DllCall("gdi32.dll","long","CreatePolygonRgn","ptr",DllStructGetPtr($lppt),"int",Int($pt[0] / 2),"int",$ALTERNATE)
   $lppt = 0
   Return $ret[0]
EndFunc   ;==>CreatePolyRgn

Func CreateRoundRectRgn($l, $t, $w, $h, $e1, $e2)
   $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $l, "long", $t, "long", $l + $w, "long", $t + $h, "long", $e1, "long", $e2)
   Return $ret[0]
EndFunc   ;==>CreateRoundRectRgn

Func CombineRgn(ByRef $rgn1, ByRef $rgn2)
   DllCall("gdi32.dll", "long", "CombineRgn", "long", $rgn1, "long", $rgn1, "long", $rgn2, "int", 2)
EndFunc   ;==>CombineRgn
;
;