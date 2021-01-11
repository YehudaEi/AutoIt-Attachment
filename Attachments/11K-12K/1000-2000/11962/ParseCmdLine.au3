#include-once

Func _If2($b,$t,$f)
  If $b Then Return $t
  Return $f
EndFunc

Func IsSwitch($cl,$switch)
  If StringLeft($switch,1)<>"^" Then $switch="^("&$switch&")"
  Local $r=StringRegExp($cl,$switch,1)
  If @Error=0 Then Return StringLen($r[0])
  If @Error=1 Then Return 0
  Return -1
EndFunc

;==============================================================================
;
; Name:            _ParseCmdLine(), v1.01
; Description:     parses command line switches
; Parameter(s):    $cl: a copy of $CmdLine (or another suitably initialised array)
;   $args is an array with the command line arguments
;     each entry in $args is a string with 4 parts, separated by a | : "type|switch|var|default"
;     "type" is either b for a boolean or s for a string switch
;     "switch" is what the user has to type on the command line (can be a simple regular expression)
;     "var" is the AU3 variable (w/o the $) that will hold the result (needs not be declared)
;     "default" is the default initialiser for "var"
;     "default" is optional: if it's missing a boolean (ie "type" b) comes back false, a string (s) empty
;   $switch is the switch character (default "-")
;   $cs=1 means switches are case-sensitive (default not case-sensitive)
; Requirement(s):  AutoIt
; Return Value(s): on success - returns 1, $cl is trimmed to hold only unprocessed entries
;   on failure - returns 0
;     @error is 1 if either $cl or $args is not an array
;     @error is 2 if there's an error in $args; @extended points to the entry in question
;     @error is 3 if there's an error in $cl; @extended points to the entry in question
;     @error is 4 if there's an unprocessed switch left in $cl; @extended points to the entry in question
;     @error is 5 if the regular expression in $switch is invalid
; Author(s):       thomasl
;
;==============================================================================
Func _ParseCmdLine(ByRef $cl,$args,$switch="-",$cs=0)
  Local $i,$j,$a,$v,$s,$l
  If Not IsArray($cl) And Not IsArray($args) Then Return SetError(1,0,0)
  For $i=0 To UBound($args)-1                  ; outer loop over all args
    $a=StringSplit($args[$i],"|")
    Switch $a[0]
      Case 3
        $v=_If2($a[1]="b",False,"")            ; use defaults
      Case 4
        $v=_If2($a[1]="b",$a[4]="True",$a[4])  ; use initialiser
      Case Else
        Return SetError(2,$i,0)
    EndSwitch
    Assign($a[3],$v,2)                        ; assign value in case the switch is not encountered
    If $cs=0 Then $a[2]=StringLower($a[2])
    For $j=1 To $cl[0]                        ; inner loop over command line args
      If $cl[$j]="" Then ContinueLoop
      $l=IsSwitch($cl[$j],($switch))
      If $l=-1 Then Return SetError(5,0,0)
      If $l>0 Then
        $s=StringMid($cl[$j],$l+1,StringLen($a[2]))
        If $cs=0 Then $s=StringLower($s)
        If $s==$a[2] Then                     ; and switch string
          $s=StringMid($cl[$j],$l+StringLen($a[2])+1)
          If $a[1]="b" Then                   ; boolean?
            If $s<>"" Then Return SetError(3,$j,0)
            Assign($a[3],_If2($v,False,True))
          Else                                ; string
            Assign($a[3],$s)
          EndIf
          $cl[$j]="" ; clear this entry
        EndIf
      EndIf
    Next
  Next
  $j=1
  For $i=1 To $cl[0] ; clean up $cl[]
    If $cl[$i]<>"" Then
      If IsSwitch($cl[$i],($switch))>0 Then Return SetError(4,$i,0)
      If $i>$j Then
        $cl[$j]=$cl[$i]
        $cl[$i]=""
      EndIf
      $j+=1
    EndIf
  Next
  $cl[0]=$j-1
  Return SetError(0,0,1) ; home and dry
EndFunc
