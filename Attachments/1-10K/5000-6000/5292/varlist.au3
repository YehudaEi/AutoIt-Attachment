; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.88
; Author:         Orangey
;
; Script Function:
;	Finds and lists variables in an AutoIt script.
;
; ----------------------------------------------------------------------------

#include <file.au3>
#include <Process.au3>
#include <GUIConstants.au3>
#include <string.au3>
#include <Array.au3>

$au3script = FileOpenDialog("Please choose a file to parse", @DesktopDir, "AutoIt Script (*.au3)")
$ok = FileOpen($au3script, 0)
_FileCreate("c:\temp.txt")
$au3temp = FileOpen("c:\temp.txt", 2)

If $ok = -1 Then
	MsgBox(0,"Warning","This file cannot be opened")
	FileClose($au3script)
	FileClose($au3temp)
	FileDelete($au3temp)
	Exit
EndIf

$cnt = 1
$invalid = 1
While 1
    $line = FileReadLine( $au3script, $cnt )
	$cnt = $cnt + 1
	If @error = -1 Then ExitLoop
Wend
				
GuiCreate("Parsing: " &$au3script, 445,110,(@DesktopWidth-445)/2, (@DesktopHeight-78)/2 , 0x04CF0000)
$progressbar1 = GUICtrlCreateProgress (20,70,380,20)
$label = GUICtrlCreateLabel ( "Total Lines to Parse: " &$cnt, 20, 10, 380, 20)
$label_2 = GUICtrlCreateLabel ( "", 20, 40, 380, 20)
GUICtrlSetData ($progressbar1, 0)
GUISetState ()
Sleep(1000)

$i=0
Do
	$i = $i + 1
	$j=0
	Do
		$j = $j + 1
		$linefix = FileReadLine($au3script, $i)
		$lf = StringInStr($linefix, "$")
		If $lf <> 0 Then
			$bad = stringinstr($linefix, Chr($j))
			If $bad <> 0 AND $bad > $lf Then
				$fix = StringMid($linefix, $lf, $bad-$lf)
				FileWriteLine($au3temp, $fix)
			Else 
			EndIf
		ElseIf $lf = 0 Then
			ExitLoop
		EndIf
		GUICtrlSetData($label_2, "ASCII Decoding Process: " &$j)
	Until $j = 35
	$a = 36
	Do
		$a = $a + 1
		$linefix = FileReadLine($au3script, $i)
		$lf = StringInStr($linefix, "$")
		If $lf <> 0 Then
			$bad = stringinstr($linefix, Chr($a))
			If $bad <> 0 AND $bad > $lf Then
				$fix = StringMid($linefix, $lf, $bad-$lf)
				FileWriteLine($au3temp, $fix)
			Else 
			EndIf
		ElseIf $lf = 0 Then
			ExitLoop
		EndIf
		GUICtrlSetData($label_2, "ASCII Decoding Process: " &$a)
	Until $a = 47
	$b=57
	Do
		$b = $b + 1
		$linefix = FileReadLine($au3script, $i)
		$lf = StringInStr($linefix, "$")
		If $lf <> 0 Then
			$bad = stringinstr($linefix, Chr($b))
			If $bad <> 0 AND $bad > $lf Then
				$fix = StringMid($linefix, $lf, $bad-$lf)
				FileWriteLine($au3temp, $fix)
			Else 
			EndIf
		ElseIf $lf = 0 Then
			ExitLoop
		EndIf
		GUICtrlSetData($label_2, "ASCII Decoding Process: " &$b)
	Until $b = 64
	$c=90
	Do
		$c = $c + 1
		$linefix = FileReadLine($au3script, $i)
		$lf = StringInStr($linefix, "$")
		If $lf <> 0 Then
			$bad = stringinstr($linefix, Chr($c))
			If $bad <> 0 AND $bad > $lf Then
				$fix = StringMid($linefix, $lf, $bad-$lf)
				FileWriteLine($au3temp, $fix)
			Else 
			EndIf
		ElseIf $lf = 0 Then
			ExitLoop
		EndIf
		GUICtrlSetData($label_2, "ASCII Decoding Process: " &$c)
	Until $c = 94
	$d=95
	Do
		$d = $d + 1
		$linefix = FileReadLine($au3script, $i)
		$lf = StringInStr($linefix, "$")
		If $lf <> 0 Then
			$bad = stringinstr($linefix, Chr($d))
			If $bad <> 0 AND $bad > $lf Then
				$fix = StringMid($linefix, $lf, $bad-$lf)
				FileWriteLine($au3temp, $fix)
			Else 
			EndIf
		ElseIf $lf = 0 Then
			ExitLoop
		EndIf
		GUICtrlSetData($label_2, "ASCII Decoding Process: " &$d)
	Until $d = 96
	$e=122
	Do
		$e = $e + 1
		$linefix = FileReadLine($au3script, $i)
		$lf = StringInStr($linefix, "$")
		If $lf <> 0 Then
			$bad = stringinstr($linefix, Chr($e))
			If $bad <> 0 AND $bad > $lf Then
				$fix = StringMid($linefix, $lf, $bad-$lf)
				FileWriteLine($au3temp, $fix)
			Else 
			EndIf
		ElseIf $lf = 0 Then
			ExitLoop
		EndIf
		GUICtrlSetData($label_2, "ASCII Decoding Process: " &$e)
	Until $e = 127
	$f=127
	Do
		$f = $f + 1
		$linefix = FileReadLine($au3script, $i)
		$lf = StringInStr($linefix, "$")
		If $lf <> 0 Then
			$bad = stringinstr($linefix, Chr($f))
			If $bad <> 0 AND $bad > $lf Then
				$fix = StringMid($linefix, $lf, $bad-$lf)
				FileWriteLine($au3temp, $fix)
			Else 
			EndIf
		ElseIf $lf = 0 Then
			ExitLoop
		EndIf
		GUICtrlSetData($label_2, "ASCII Decoding Process: " &$f)
	Until $f = 255
	GUICtrlSetData($label, "Parsing Line: " &$i &" of " &$cnt)
	GUICtrlSetData ($progressbar1, ($i/$cnt)*100)
Until $i = $cnt
FileClose($au3temp)
FileClose($au3script)

GuiCreate("", 247,70,(@DesktopWidth-247)/2, (@DesktopHeight-70)/2 , 0x04CF0000)
$label_3 = GUICtrlCreateLabel("Please Wait", 30, 10, 180, 40)

$au3tempor = FileOpen("c:\temp.txt", 0)
_FileCreate("c:\temp2.txt")
$au3temp2 = FileOpen("c:\temp2.txt", 2)

$cnt = 1
While 1
    $line = FileReadLine( $au3tempor, $cnt )
	$cnt = $cnt + 1
    If @error = -1 Then ExitLoop
Wend

$x = 1
Do
	$line = FileReadLine( $au3tempor, $x)
	$linecomp = StringStripWS($line, 8)
	$usexists = StringInStr($linecomp, "_")
	$repdoll = StringReplace($linecomp, "$", "47b0wh94gh60s96hf7hgd")
	If $usexists <> 0 Then
		$repus = StringReplace($repdoll, "_", "234gf08g208420ghadnvb")
		$repus_alnum = StringIsAlNum($repus)
		If $repus_alnum = 1 Then
			$repushex = _StringToHex($repus)
			FileWriteLine($au3temp2, $repushex)
		EndIf
	EndIf
	$repdoll_alnum = StringIsAlNum($repdoll)
	If $repdoll_alnum = 1 Then
		$repdollhex = _StringToHex($repdoll)
		FileWriteLine($au3temp2, $repdollhex)
	EndIf
	$x = $x + 1
Until $x = $cnt
FileWriteLine($au3temp2, "END")
FileClose($au3temp2)
FileClose($au3tempor)

$au3tempor2 = FileOpen("c:\temp2.txt", 0)
_FileCreate("c:\temp3.txt")
$au3temp3 = FileOpen("c:\temp3.txt", 2)

$cnt = 1
While 1
    $line = FileReadLine( $au3tempor2, $cnt )
	$cnt = $cnt + 1
    If @error = -1 Then ExitLoop
Wend

Dim $avArray[$cnt]

$bb=0
$xcnt = 1
Do
    $line = FileReadLine( $au3tempor2, $xcnt )
	$avArray[$bb] = $line
	$bb = $bb + 1
	$xcnt = $xcnt + 1
    If @error = -1 Then ExitLoop
Until $bb = ($cnt-1)

_ArraySort( $avArray)

$ba = 2
Do
	$line = $avArray[$ba]
	$linex = $avArray[$ba+1]
	If $linex <> $line Then
		$hexline = _HexToString($line)
		$repdoll = StringReplace($hexline, "47b0wh94gh60s96hf7hgd", "$")
		If StringInStr($hexline,"234gf08g208420ghadnvb") <> 0 Then 
			$repus = StringReplace($repdoll, "234gf08g208420ghadnvb", "_")
			FileWriteLine($au3temp3, $repus)
		Else
			FileWriteLine($au3temp3, $repdoll)
		EndIf
	EndIf
	$ba = $ba + 1
Until $ba = $cnt-1

FileClose($au3temp3)
FileClose($au3tempor2)

$au3tempor3 = FileOpen("c:\temp3.txt", 0)
_FileCreate(@DesktopDir &"\AutoIt Variable List.txt")
$au3temp4 = FileOpen(@DesktopDir &"\AutoIt Variable List.txt", 2)

FileWriteLine($au3temp4, "Variable List For: " &$au3script)
$cnt = 1
While 1
    $line = FileReadLine( $au3tempor2, $cnt )
	$cnt = $cnt + 1
    If @error = -1 Then ExitLoop
Wend

$cnty = 1
Do
    $line = FileReadLine( $au3tempor3, $cnty )
	If StringInStr($line,"$",0,2) <> 0 Then
		$df = 0
	Else
		FileWriteLine($au3temp4, $line)
	EndIf
	$cnty = $cnty + 1
Until $cnty = $cnt

FileClose($au3tempor3)
FileClose($au3temp4)

FileDelete("c:\temp3.txt")
FileDelete("c:\temp2.txt")
FileDelete("c:\temp.txt")

GUIDelete()
Exit