#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\Ico\WinrarSZ.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Comprimeix per el programa PingT Complet
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Fileversion=1.1.0.12
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

If Not FileExists("Rar.exe") Then FileInstall("Rar.exe", @ScriptDir & "\Rar.exe", 1)

If $CmdLine[0] = 2 Then
	$n = _RunDOS('Rar.exe a PingT' & $CmdLine[2] & '.zip -m5 -n "' & $CmdLine[1] & '"')
	Exit($n)
Else
	Exit(20)
EndIf
