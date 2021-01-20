#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=P:\Desktop\Media\ico\REPORTL.ICO
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Yosyp
#AutoIt3Wrapper_Res_Fileversion=1.0.0.16
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Yosyp Petriv
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#Tidy_Parameters=/bdir P:\Desktop\Projects\!AU3\BackUp
#Obfuscator_Parameters=/cs=0 /cn=0 /cf=1 /cv=1 /sf=1 /sv=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Debug_Mode=n
#include-once
;#include "P:\Desktop\Projects\!AU3\mylib.au3"


$dir = @ScriptDir
$pls = @AppDataDir & "\Winamp\Winamp.m3u8"

$ndir = $dir & "\Winamp"

If FileExists($ndir) Then
	If Not DirRemove($ndir, 1) Then
		RunWait('cmd.exe /c del /f /q "' & $ndir & '\*.*"')
	EndIf
EndIf

$count = 10000

$file = FileOpen($pls, 128)

If $file = -1 Then
	MsgBox(0, "Error", "Can't Open " & $pls)
	Exit
EndIf

While True
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop

	If StringLeft($line, 1) == "#" Then
		If StringLeft($line, 7) == "#EXTINF" Then
			$mp3n = ctrans(mailtrans(StringRight($line, StringLen($line) - StringInStr($line, ",", 2, 1))))
			ContinueLoop
		Else
			ContinueLoop
		EndIf
	EndIf

	If StringLeft($line, 1) == "\" Then
		$mp3 = StringLeft($pls, 2) & $line
	Else
		$mp3 = $dir & "\" & $line
	EndIf
	$dst = $mp3n & '.' & StringRight($mp3, StringLen($mp3) - StringInStr($mp3, ".", 2, -1))

	If Not FileExists($mp3) Then
		ContinueLoop
	EndIf

	If Not FileExists($ndir) Then
		DirCreate($ndir)
	EndIf

	$count += 1

	FileCreateNTFSLink($mp3, $ndir & "\" & StringRight($count, StringLen($count) - 1) & " " & $dst, 1)

WEnd

FileClose($file)

Func StrRep($txt,$txta,$txtb)
	$txt=StringReplace($txt,StringLower($txta),StringLower($txtb),0,1);
	$txt=StringReplace($txt,StringUpper($txta),StringUpper($txtb),0,1);
	Return $txt
EndFunc

Func mailtrans($txt)
$txt=StrRep($txt,"à","а")
$txt=StrRep($txt,"á","б")
$txt=StrRep($txt,"â","в")
$txt=StrRep($txt,"ã","г")
$txt=StrRep($txt,"´","ґ")
$txt=StrRep($txt,"ä","д")
$txt=StrRep($txt,"å","е")
$txt=StrRep($txt,"º","є")
$txt=StrRep($txt,"æ","ж")
$txt=StrRep($txt,"ç","з")
$txt=StrRep($txt,"è","и")
$txt=StrRep($txt,"³","і")
$txt=StrRep($txt,"¿","ї")
$txt=StrRep($txt,"é","й")
$txt=StrRep($txt,"ê","к")
$txt=StrRep($txt,"ë","л")
$txt=StrRep($txt,"ì","м")
$txt=StrRep($txt,"í","н")
$txt=StrRep($txt,"î","о")
$txt=StrRep($txt,"ï","п")
$txt=StrRep($txt,"ð","р")
$txt=StrRep($txt,"ñ","с")
$txt=StrRep($txt,"ò","т")
$txt=StrRep($txt,"è","у")
$txt=StrRep($txt,"ó","у")
$txt=StrRep($txt,"ô","ф")
$txt=StrRep($txt,"õ","х")
$txt=StrRep($txt,"ö","ц")
$txt=StrRep($txt,"÷","ч")
$txt=StrRep($txt,"ø","ш")
$txt=StrRep($txt,"ù","щ")
$txt=StrRep($txt,"þ","ю")
$txt=StrRep($txt,"ÿ","я")
$txt=StrRep($txt,"ß","я")
$txt=StrRep($txt,"ü","ь")
Return $txt
EndFunc   ;==>mailtrans

Func ctrans($txt)
$txt=StrRep($txt,"в","v")
$txt=StrRep($txt,"б","b")
$txt=StrRep($txt,"а","a")
$txt=StrRep($txt,"ю","ju")
$txt=StrRep($txt,"ч","ch")
$txt=StrRep($txt,"г","h")
$txt=StrRep($txt,"ґ","g")
$txt=StrRep($txt,"д","d")
$txt=StrRep($txt,"е","e")
$txt=StrRep($txt,"є","ye")
$txt=StrRep($txt,"ж","zh")
$txt=StrRep($txt,"з","z")
$txt=StrRep($txt,"и","y")
$txt=StrRep($txt,"і","i")
$txt=StrRep($txt,"ї","ji")
$txt=StrRep($txt,"й","j")
$txt=StrRep($txt,"к","k")
$txt=StrRep($txt,"л","l")
$txt=StrRep($txt,"м","m")
$txt=StrRep($txt,"н","n")
$txt=StrRep($txt,"р","r")
$txt=StrRep($txt,"п","p")
$txt=StrRep($txt,"о","o")
$txt=StrRep($txt,"с","s")
$txt=StrRep($txt,"т","t")
$txt=StrRep($txt,"у","u")
$txt=StrRep($txt,"ф","f")
$txt=StrRep($txt,"х","x")
$txt=StrRep($txt,"ц","c")
$txt=StrRep($txt,"ш","sh")
$txt=StrRep($txt,"щ","sch")
$txt=StrRep($txt,"я","ya")
$txt=StrRep($txt,"ь","`")
$txt=StrRep($txt,"ы","u")
Return $txt
EndFunc   ;==>mailtrans