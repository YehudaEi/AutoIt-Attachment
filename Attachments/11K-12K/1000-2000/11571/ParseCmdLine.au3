#include-once

Func _If2($b,$t,$f)
	If $b Then Return $t
	Return $f
EndFunc

; _ParseCmdLine: parses command line switches
; $cl[] is a copy of $CmdLine[] (or a another suitably initialised array)
; $args[] is an array with the command line arguments (see example code)
; $switch is the switch character (default "-")
; $cs=1 means switches are case-sensitive (default not case-sensitive)
;
; returns 1 for success and 0 for failure
; @error is 1 if either $cl or $args is not an array
; @error is 2 if there's an error in $args; @extended points to the entry in question
; @error is 3 if there's an error in $cl; @extended points to the entry in question
; upon successful return $cl[] is trimmed to hold only unprocessed entries
Func _ParseCmdLine(ByRef $cl,$args,$switch="-",$cs=0)
	Local $i,$j,$a,$v,$s
	If Not IsArray($cl) And Not IsArray($args) Then Return SetError(1,0,0)
	For $i=0 To UBound($args)-1                 ; outer loop over all args
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
			If StringLeft($cl[$j],StringLen($switch))=$switch Then ; check switch char
				$s=StringMid($cl[$j],StringLen($switch)+1,StringLen($a[2]))
				If $cs=0 Then $s=StringLower($s)
				If $s==$a[2] Then                     ; and switch string
					$s=StringMid($cl[$j],StringLen($switch)+StringLen($a[2])+1)
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
