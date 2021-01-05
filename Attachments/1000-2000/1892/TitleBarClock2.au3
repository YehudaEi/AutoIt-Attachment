AutoItSetOption ("MouseCoordMode", 0)

Global $hwnd, $title
;Global $count, $wCount, $size
Global $Win_HWND[100], $Win_Size[100]

$wCount = 0
$hwnd = WinGetHandle("")
$title = WinGetTitle($hwnd)

While 1
   If _IsPressed('01') = 1  Then    ; LEFT Click
      Sleep(250)
      If _IsPressed('01') = 0  Then       ; LEFT Click Release -> RollUp
         $pos = MouseGetPos()
         If $pos[0] > 22 AND $pos[1] < 25 Then CheckHWND($hwnd)
      Else
         While _IsPressed('01')
            Sleep(250)
         WEnd
      EndIf
   EndIf
   SetTitle($hwnd,$title)
   $newhwnd = WinGetHandle("")
   If Not @Error And $newhwnd <> $hwnd Then
      WinSetTitle($hwnd,"",$title)
      $hwnd = $newhwnd
      $title = WinGetTitle($hwnd)
   EndIf
   Sleep(200)
WEnd
;-------------------------------
Func SetTitle($h,$t)
   WinSetTitle($h,"",$t & " < " & @hour & ":" & @min & ":" & @sec & " >")
EndFunc
;-------------------------------
Func CheckHWND($hwnd)
   $hwnd = WinGetHandle("")
   $size = WinGetPos("")
   If $size[3] = 27 then
      For $count = 0 to $wCount
         If $Win_HWND[$count] = $hwnd Then
            $size[3] = $Win_Size[$count]
            WinMove($hwnd, "", $size[0], $size[1], $size[2], $size[3])
            $Win_HWND[$count] = $Win_HWND[$wCount]
            $Win_Size[$count] = $Win_Size[$wCount]
            $wCount = $wCount - 1
            ExitLoop
         EndIf
      Next
   Else
      $Win_HWND[$wCount] = $hwnd
      $Win_Size[$wCount] = $size[3]
      $wCount = $wCount + 1
      WinMove($hwnd, "", $size[0], $size[1], $size[2], 27)
   EndIf
EndFunc
;-------------------------------
Func OnAutoItExit()
   WinSetTitle($hwnd,"",$title)
   For $count = 0 to $wCount
      $hwnd = $Win_HWND[$count]
      WinActivate($hwnd)
      $size = WinGetPos("")
      $size[3] = $Win_Size[$count]
      WinMove($hwnd, "", $size[0], $size[1], $size[2], $size[3])
   Next
   AutoItSetOption ("MouseCoordMode", 1)
   Exit
EndFunc
;-------------------------------
Func _IsPressed($hexKey)
  Local $aR, $bRv    ;$hexKey
  $hexKey = '0x' & $hexKey
  $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
  If $aR[0] <> 0 Then
     $bRv = 1
  Else
     $bRv = 0
  EndIf
  Return $bRv
EndFunc
