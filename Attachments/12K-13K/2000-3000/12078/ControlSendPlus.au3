#include-once
Func ControlSendPlus($title, $text, $className, $string, $flag)
;VERSION 2.0.3 (06/13/2004)
    Local $ctrl = 0, $alt = 0, $upper, $start, $end, $i, $char, $and, $Chr5Index, $isUpper, $ret
    If $flag = 2 Or $flag = 3 Then $ctrl = 1
    If $flag = 2 Or $flag = 4 Then $alt = 1
    If $flag <> 1 Then $flag = 0;set the flag to the default function style
    $upper = StringSplit('~!@#$%^&*()_+|{}:"<>?ABCDEFGHIJKLMNOPQRSTUVWXYZ', "")
    
    If $flag <> 1 Then;don't replace special chars if it's raw mode
  ;replace {{} and {}} with +[ and +] so they will be displayed properly
        $string = StringReplace($string, "{{}", "+[")
        $string = StringReplace($string, "{}}", "+]")
  ;replace all special chars with Chr(5)
  ;add the special char to an array.  each Chr(5) corresponds with an element
        Local $Chr5[StringLen($string) / 2 + 1]
        For $i = 1 To StringLen($string)
            $start = StringInStr($string, "{")
            If $start = 0 Then ExitLoop;no more open braces, so no more special chars
            $end = StringInStr($string, "}")
            If $end = 0 Then ExitLoop;no more close braces, so no more special chars
      ;parse inside of braces:
            $Chr5[$i] = StringMid($string, $start, $end - $start + 1)
      ;replace with Chr(5) leaving the rest of the string:
            $string = StringMid($string, 1, $start - 1) & Chr(5) & _
                    StringMid($string, $end + 1, StringLen($string))
        Next
  ;take out any "!", "^", or "+" characters
  ;add them to the $Modifiers array to be used durring key sending
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
                $string = StringMid($string, 1, $i - 1) & _
                        StringMid($string, $i + 1, StringLen($string))
                $i = $i - 1
            EndIf
        Next
    Else;it is raw mode, so set up an all-0 modifier array
        Local $Modifiers[StringLen($string) + 1]
    EndIf
    
;now send the chars
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
  ;1 SHIFT, 2 CTRL, 4 ALT (programmer note to keep the bits straight)
        If $isUpper = 1 Or BitAND($Modifiers[$i], 1) = 1 Then Send("{SHIFTDOWN}")
        If BitAND($Modifiers[$i], 4) = 4 And Not $alt Then $char = "!" & $char
        If BitAND($Modifiers[$i], 2) = 2 And Not $ctrl Then $char = "^" & $char
        If BitAND($Modifiers[$i], 4) = 4 And $alt Then Send("{ALTDOWN}")
        If BitAND($Modifiers[$i], 2) = 2 And $ctrl Then Send("{CTRLDOWN}")
        $ret = ControlSend($title, $text, $className, $char, $flag)
        If BitAND($Modifiers[$i], 4) = 4 And $alt Then Send("{ALTUP}")
        If BitAND($Modifiers[$i], 2) = 2 And $ctrl Then Send("{CTRLUP}")
        If $isUpper = 1 Or BitAND($Modifiers[$i], 1) = 1 Then Send("{SHIFTUP}")
        If Not $ret Then Return 0;window or control not found
    Next
    Return 1
EndFunc;==>ControlSendPlus