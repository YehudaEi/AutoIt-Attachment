#include-once
Func ControlSendPlus($title, $text, $className, $string, $flag)

Local $ctrl=0,$alt=0,$upper,$start,$end,$i,$char,$and,$Chr5Index,$isUpper,$ret
If $flag = 2 OR $flag = 3 Then $ctrl = 1
If $flag = 2 OR $flag = 4 Then $alt = 1
If $flag <> 1 Then $flag = 0
$upper = StringSplit('~!@#$%^&*()_+|{}:"<>?ABCDEFGHIJKLMNOPQRSTUVWXYZ', "")

If $flag <> 1 Then

  $string = StringReplace($string, "{{}", "+[")
  $string = StringReplace($string, "{}}", "+]")


  Local $Chr5[StringLen($string) / 2 + 1]
  For $i = 1 To StringLen($string)
    $start = StringInStr($string, "{")
    If $start = 0 Then ExitLoop
    $end = StringInStr($string, "}")
    If $end = 0 Then ExitLoop;
 
    $Chr5[$i] = StringMid($string, $start, $end - $start + 1)

    $string = StringMid($string, 1, $start - 1) & Chr(5) 
     StringMid($string, $end + 1, StringLen($string))
  Next


  Local $Modifiers[StringLen($string) + 1]
  For $i = 1 To StringLen($string)
    $char = StringMid($string, $i, 1)
    $and = 0
    If $char = "+" Then
      $and = 1
    ElseIf $char = "^" Then
      $and = 2
    ElseIf $char = "!" Then
      $and = 4
    ElseIf $char = "" Then
      ExitLoop
    EndIf
    If $and <> 0 Then
      $Modifiers[$i] = BitOR($Modifiers[$i], $and)
      $string = StringMid($string, 1, $i - 1) 
       StringMid($string, $i + 1, StringLen($string))
      $i = $i - 1
    EndIf
  Next
Else
  Local $Modifiers[StringLen($string) + 1]
EndIf


$Chr5Index = 1
For $i = 1 To StringLen($string)
  $char = StringMid($string, $i, 1)
  If $char = Chr(5) Then
    $char = $Chr5[$Chr5Index]
    $Chr5Index = $Chr5Index + 1
  EndIf
  $isUpper = 0
  For $j = 1 To UBound($upper) - 1
    If $char == $upper[$j] Then $isUpper = 1
  Next

  If $isUpper = 1 OR BitAND($Modifiers[$i], 1) = 1 Then Send("{SHIFTDOWN}")
  If BitAND($Modifiers[$i], 4) = 4 AND NOT $alt Then $char = "!" & $char
  If BitAND($Modifiers[$i], 2) = 2 AND NOT $ctrl Then $char = "^" & $char
  If BitAND($Modifiers[$i], 4) = 4 AND $alt Then Send("{ALTDOWN}")
  If BitAND($Modifiers[$i], 2) = 2 AND $ctrl Then Send("{CTRLDOWN}")
  $ret = ControlSend($title, $text, $className, $char, $flag)
  If BitAND($Modifiers[$i], 4) = 4 AND $alt Then Send("{ALTUP}")
  If BitAND($Modifiers[$i], 2) = 2 AND $ctrl Then Send("{CTRLUP}")
  If $isUpper = 1 OR BitAND($Modifiers[$i], 1) = 1 Then Send("{SHIFTUP}")
  If NOT $ret Then return 0
Next
return 1
EndFunc