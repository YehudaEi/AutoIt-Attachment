#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\Ico\zip.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Descomprimeix per el programa PingT complet
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Fileversion=1.1.0.25
#AutoIt3Wrapper_Res_LegalCopyright=TaliSoft
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#NoTrayIcon
#include <Process.au3>
#include <Zip.au3>
#include <Date.au3>

If Not FileExists("UnRar.exe") Then FileInstall("UnRar.exe", @ScriptDir & "\UnRar.exe", 1)

If $CmdLine[0] = 3 Then
	$a = StringSplit($CmdLine[1], "\")
	If $CmdLine[3] = "/1" Then
		$aFitxers = _Zip_List($CmdLine[1])
		For $i = 1 To $aFitxers[0]
			MsgBox(0, "Fitxer a copiar", $aFitxers[$i], 2)
			$c = FileCopy(StringReplace($CmdLine[1], $a[$a[0]], "") & $aFitxers[$i], StringReplace($CmdLine[1], $a[$a[0]], "") & "Fitxers\BackUp\" & StringReplace(_NowCalcDate(), "/", "\"), 8)
			MsgBox(0, "Copy Result", $c, 1)
		Next
	EndIf
	$n = _RunDOS('UnRar.exe e -o+ "' & $CmdLine[1] & '" "' & StringReplace($CmdLine[1], $a[$a[0]], "") & '"') 
	If $n = 0 Then
		FileDelete($CmdLine[1])
		FileDelete($CmdLine[2])
	EndIf
	Exit($n)
Else
	Exit(20)
EndIf
	