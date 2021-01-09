;||----------------------------------------------------------||
;||----------------------------------------------------------||
;||Function _DirGet()          
;||Syntax:  _DirGet($Path="",$Filter="",$Flag=0,$Status="")
;||Requirement(s):   <Array.au3><File.au3>
;||On Success : Return Dir's Files Summary
;||On Fail : Exit script                                     
;||Author : d4rk < Le Khuong Duy >               
;||----------------------------------------------------------||
;||----------------------------------------------------------||
#include <File.au3>
#include <Array.au3>
Func _DirGet($Path="",$Filter="",$Flag=0,$Status="")
Dim $Total,$Count
$Chars=_ArrayCreate("R","A","S","H","N","D","O","C","T","")
For $j=0 to UBound($Chars)-1
if $Status<>$Chars[$j] Then
$Count=$Count+1
Else
EndIf
Next

if $Count=10 Then
	ConsoleWrite("_DirGet Call with wrong attribute ")
	Exit
EndIf
;------------------------
If $Path="" Then
	$Path=@ScriptDir & "\"
Else
	$Path=$Path
EndIf
;------------------------
If $Filter="" Then
	$Filter="*.*"
Else
	$Filter=$Filter
EndIf
;------------------------
If $Status="" Then
$Files=_FileListToArray($Path,$Filter,$Flag)
$Bound=UBound($Files)-1
Return $Bound
EndIf

$Files=_FileListToArray($Path,$Filter,$Flag)
For $i=1 to UBound($Files)-1
	$GetStatus=FileGetAttrib($Path & $Files[$i])
	If StringInStr($GetStatus,$Status) Then
	$Total=$Total+1
EndIf
Next
Return $Total
EndFunc
