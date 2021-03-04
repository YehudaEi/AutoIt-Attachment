
; IS NOT WORKING if includes present
;===============================================================================
;
; Program Name:		GetFileLineError
; Description:		Find the line of File given the error line reported by the compiled program
;					Ueses a Recursive call Sistem
;
; Parameter(s):		$Path Program full path of Sorce program Ex.   $path="C:\users\jony\autoit test\teste.au3"
;                   $Errorline               Ex.   $Errorline = 6551 ; Executable reported error Line
;					$Debug	Debug level,   Defulat 0 No trce
;						1- Start and End File Lines,
;						2- File #include line  Format:>(ident space)(FileName):(File Line)  (Line text)
;						3- #include-once List
;
; Requirement(s):   Source code used to create the executable
;					$includePath Path of Include files with "\" Ex. $includePath="C:\Program Files (x86)\AutoIt3\Include\"
;
; Return Value(s):	ConsoleWrite  with de Program ou Mudule name and da file line of the error And MsgBox
;
; Author(s):		Elias Assad Neto
; Date Created:		June 6 2012
;
;===============================================================================

; Parameters Input

$ProgramPath = "GetFileLineError.au3"
$Errorline = 12452; Executable error Line

$Debug = 2    ; Debug Level


; Includ Path ended with "\"
$includePath="C:\Program Files (x86)\AutoIt3\Include\"
If Not FileExists($includePath) Then $includePath="C:\Program Files\AutoIt3\Include\"
If Not FileExists($includePath) Then
	MsgBox(0x10,"GetFileLineError"," Include File Directory Not Found")
	Exit
EndIf


; Var initialization ========================================

$i = StringInStr($ProgramPath,"\",0,-1) ; Last "\" position
$dir = StringLeft($ProgramPath,$i) ; Path Dir with "\"
$file = StringMid($ProgramPath,$i+1) ; Program name

$includeOnce = "" ; Include-Once File List

$line = 0

$RecursionLevel = 0 ; Recursion Level used to ident debug lines

; Program Start =============================================

#include <INet.au3> ; Para enviar e-Mail em caso de *ERRO
#include <IE.au3>
#include <File.au3>
#include <Array.au3>
#include <GuiStatusBar.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ProgressConstants.au3> ;3.3.0.0
#include <WindowsConstants.au3> ;3.3.0.0
#include <StaticConstants.au3>
#include <Timers.au3>

$S = ProcessFile($file,$Debug)
ConsoleWrite(@CRLF & @CRLF & $S & @CRLF)
If $S <> "" Then
	MsgBox(0x40,"GetFileLineError",$S)
Else
	MsgBox(0x40,"GetFileLineError","Executable Line " & $Errorline & " Not Found in: " & $file)
EndIf


; Program End ===============================================

; Function Decalration ======================================

Func ProcessFile($FileName, $Trace=0) ; Recursive fuction to find Line, Debug Level 0,1,2,3
	$ph = $dir;
	$s = FileRead($ph & $FileName) ; Search File in the source directory
	If $s = ""  Then
		$ph = $includePath
		$s = FileRead($ph & $FileName) ; Search File in the Include directory
	EndIf
	$phf = $ph & $FileName
	If $s = "" Then Return "ERROR File " & $FileName & " NOT Found Search for Error line Aborted"
	$t = ""
	For $i=1 To $RecursionLevel  ; Ident formating
		$t &= @TAB
	Next
	If StringInStr(StringLeft($s,16),"#include-once")=1 Then ; File #include-once detectaed
		If StringInStr($includeOnce,$FileName) Then Return ; Return file already processed
		$includeOnce &= $FileName & ";"; Adds the name of the File in the includeOnce list
		If $Trace >=3 Then ConsoleWrite($t & '$includeOnce="' & $includeOnce & '"' & @CRLF) ; Debug level 3
	EndIf
	If $RecursionLevel = 0 Then
		If $Trace Then ConsoleWrite("+" & $t & "Programa Start( " & $FileName & " ) line " & $line+1 & @CRLF) ; Debug level >=1
	Else
		If $Trace Then ConsoleWrite("+" & $t & "Include  Start( " & $FileName & " ) line " & $line+1 & @CRLF) ; Debug level >=1
	EndIf
	$RecursionLevel +=1
	$s1 = ""
	Do ; ExitLoop Block
		$as = StringSplit($s,@CRLF,1) ; String to Array
		If @Compiled And $as[UBound($as)] = "" Then $i=$i ; PopUp ERROR wen compiled
		For $i=1 to UBound($as)-1 ; $i File Line
			$line+=1 ; Incrementa a linha Global
			If $line = $Errorline Then ; Achou a Linha terminou
				$s1 = "ERROR Line Found in " & $phf & " at File Line: " & $i ; Nome do Modulo mais linha local
				Return $s1 ; Retorna com o dado e termina a recursividade
			EndIf
			If StringInStr(StringStripWS($as[$i],3),'#include ')=1 then
				$as1 = StringRegExp($as[$i],"(?i)\#include (<(.*)>|""(.*?)""|''(.*?)'')",3) ; pega o nome do modulo <xxx>, "xxx" ou 'xxx'
				If UBound($as1)>1 Then ; Ok
					$s1 = $as1[UBound($as1)-1] ; takes the last item that is the file name
					If $Trace >=2 And StringInStr($includeOnce,$s1)=0 Then ConsoleWrite(">" & $t & $FileName & ":" & $i & "  " & $as[$i] & @CRLF) ; Debug level >=2
					$s1 = ProcessFile($s1,$Trace) ; Here comes recursion
					If $s1 <> "" Then ExitLoop ; Get out of the recursion cascading exiting all levels
				EndIf
			EndIf
		Next
	Until 1
	$RecursionLevel -=1
	If $s1 = "" Then
		If $RecursionLevel = 0 Then
			If $Trace Then ConsoleWrite("-" & $t & "Programa  End( " & $FileName & " ) line " & $line & " Program File Lines: " & UBound($as)-1 & @CRLF) ; Debug level >=1
		Else
			If $Trace Then ConsoleWrite("-" & $t & "Include   End( " & $FileName & " ) line " & $line & " Include File Lines: " & UBound($as)-1 & @CRLF) ; Debug level >=1
		EndIf
	EndIf
	Return $s1 ; Return "" if Includ end, or is $s1 <> "" is da result exiting all recursion levels
EndFunc


