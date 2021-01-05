#include-once

Func GUICtrlCreateLine($x1, $y1, $x2, $y2, $size = 1, $color = "0x000000")
if $x1<>$x2 Then
  $coeff_line = ( $y2-$y1 ) / ( $x2-$x1 )
  $p = $y2 - ( $coeff_line * $x2 )
  $alg = Int((Abs($x2 - $x1)) / $size)
  Dim $id[$alg + 2]
  $id[0] = $alg + 1
  if $x1>$x2 Then
      $tmp=$x1
      $x1=$x2
      $x2=$tmp
   Endif
  For $a = $x1 to $x2 step $size
    $alg = Int((Abs($x2 - $a)) / $size)
    $id[$alg + 1] = GUICtrlCreateLabel("", $a, ( $a * $coeff_line ) + $p, $size, $size)
    GUICtrlSetBkColor($id[$alg + 1], $color)
  Next
  Return $id
Else
    $alg = Int((Abs($y2 - $y1)) / $size)
    Dim $id[$alg + 2]
    $id[0] = $alg + 1
    if $y1>$y2 Then
      $tmp=$y1
      $y1=$y2
      $y2=$tmp
   Endif
    For $a = $y1 to $y2 step $size
    $alg = Int((Abs($y2 - $a)) / $size)
    $id[$alg + 1] = GUICtrlCreateLabel("", $x1, $a, $size, $size)
    GUICtrlSetBkColor($id[$alg + 1], $color)
    Next
    Return $id
EndIf
EndFunc

Func GUICtrlDeleteGroup($array)
  If not IsArray($array) Then Return 0
  For $i = 1 to $array[0]
    GUICtrlDelete($array[$i])
  Next
  Return 1
EndFunc