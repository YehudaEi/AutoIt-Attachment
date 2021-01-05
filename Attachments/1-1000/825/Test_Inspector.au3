#include <GUIConstants.au3>
#include <Inspector.au3>

Global $x_pixel = 200
Global $y_pixel = 200
Global $aaa[3]
$aaa[0]="a0"
$aaa[1]="a1"
$aaa[2]="a2"

Dim $bbbbb[6]
$bbbbb[1]="b1"
$bbbbb[4]="b4"

Dim $hans="dadas"
Dim $fluffy=12.44478903295846579
Dim $win=10
Dim $huiwi=100
Dim $winhu=1000
Dim $kawinhun=10000

$rc=init_Inspector("^{F1}")
if $rc <> 0 Then
	MsgBox(4096,"ERROR setting HotKey",$rc)
EndIf

$rc=filter_Inspector("iwi,hun")



MsgBox(4096,"Start - Inspector Test Script","Inspector is active, press Ctrl-F1 for variable inspector messagebox",2)
While 1
	$i = $i + 1
	$b = $b + $i
	sleep(1000)
	if $i = 10 Then
		init_Inspector("")
		MsgBox(4096,"Stop","Inspector is not active")
	EndIf	
	if $i = 20 Then
		MsgBox(4096,"Call Inspector","Calling Inspector from code")
		call_Inspector()
	EndIf	
	if $i = 30 Then
		init_Inspector("^{F1}")
		MsgBox(4096,"Start","Inspector is active again, press Ctrl-F1")
	EndIf	
	if $i = 40 Then
		MsgBox(4096,"Quit","Quitting test script")
		Exit
	EndIf	
WEnd
Exit
