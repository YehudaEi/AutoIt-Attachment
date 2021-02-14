#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=WMIRepair.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=ThatGuy2223
#AutoIt3Wrapper_Res_Description=WMI Reinstall/Repair Interactive
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Process.au3>
#Include <File.au3>

;ReadMe
;Windows XP/Windows XP X64 Only
;This script reinstalls WMI.

$M = Msgbox(3,"WMI Reapair 1.1","Do you have the original Windows CD?")
If $M = 2 Then
Exit
Endif
If $M = 6 Then
CD()
EndIf
If $M = 7 Then
NOCD()
EndIf

Func NOCD()
$1 = FileSelectFolder ( "C:\WINDOWS\ServicePackFiles\I386 or ADM64 folder.", "C:\", "")
If @error = 1 Then
Exit
Endif

;OSArch Check
If @OSArch = "X86" Then

;Copies WMI Inf Installation File.
FileCopy ( "C:\WINDOWS\inf\wbemoc.inf",$1 &"\wbemoc_reinstall_x86.inf")
;Adds [Components] Section To Inf For Sysocmgr.
IniWriteSection ( $1 &"\wbemoc_reinstall_x86.inf", "Components", "WBEM=ocgen.dll,OcEntry,wbemoc.inf,,7")
;Creates Sysocmgr Answer File.
_FileCreate($1 &"\I.txt")
IniWriteSection ( $1 &"I.txt", "Components", "WMI = on")
;Starts Sysocmgr WMI Reinstall Silently.(Take out /q to see passive GUI.)
;_Rundos("sysocmgr /i:"&$1&"\wbemoc_reinstall_x86.inf /u:"&$1&"\I.txt /f")
_Rundos("sysocmgr /i:"&$1&"\wbemoc_reinstall_x86.inf")
Else

;X64 Section
;Checks For Windows X64 Installation Files

;Copies WMI Inf Installation File.
FileCopy ( "C:\WINDOWS\inf\wbemoc.inf",$1 &"\wbemoc_reinstall_x64.inf")
;Adds [Components] Section To Inf For Sysocmgr.
IniWriteSection ( $1 &"\wbemoc_reinstall_x64.inf", "Components", "WBEM=ocgen.dll,OcEntry,wbemoc.inf,,7")
;Creates Sysocmgr Answer File.
_FileCreate($1 &"\I.txt")
IniWriteSection ( $1 &"\I.txt", "Components", "WMI = on")
;Starts Sysocmgr WMI Reinstall Silently. (Take out /q to see passive GUI.)
;_Rundos("sysocmgr /i:"&$1&"\wbemoc_reinstall_x64.inf /u:"&$1&"\I.txt /f")
_Rundos("sysocmgr /i:"&$1&"\wbemoc_reinstall_x64.inf")
Endif
Exit
EndFunc

Func CD()
If @OSArch = "X86" Then

;Copies WMI Inf Installation File.
FileCopy ( "C:\WINDOWS\inf\wbemoc.inf","C:\WINDOWS\wbemoc_reinstall_x86.inf")
;Adds [Components] Section To Inf For Sysocmgr.
IniWriteSection ( "C:\WINDOWS\wbemoc_reinstall_x86.inf", "Components", "WBEM=ocgen.dll,OcEntry,wbemoc.inf,,7")
;Creates Sysocmgr Answer File.
_FileCreate("C:\WINDOWS\I.txt")
IniWriteSection ( "C:\WINDOWS\I.txt", "Components", "WMI = on")
;Starts Sysocmgr WMI Reinstall Silently.(Take out /q to see passive GUI.)
;_Rundos("sysocmgr /i:C:\WINDOWS\wbemoc_reinstall_x86.inf /u:C:\WINDOWS\I.txt /f")
_Rundos("sysocmgr /i:C:\WINDOWS\wbemoc_reinstall_x86.inf")
Else

;X64 Section
;Checks For Windows X64 Installation Files

;Copies WMI Inf Installation File.
FileCopy ( "C:\WINDOWS\inf\wbemoc.inf","C:\WINDOWS\wbemoc_reinstall_x64.inf")
;Adds [Components] Section To Inf For Sysocmgr.
IniWriteSection ( "C:\WINDOWS\wbemoc_reinstall_x64.inf", "Components", "WBEM=ocgen.dll,OcEntry,wbemoc.inf,,7")
;Creates Sysocmgr Answer File.
_FileCreate("C:\WINDOWS\I.txt")
IniWriteSection ( "C:\WINDOWS\I.txt", "Components", "WMI = on")
;Starts Sysocmgr WMI Reinstall Silently. (Take out /q to see passive GUI.)
;_Rundos("sysocmgr /i:C:\WINDOWS\wbemoc_reinstall_x64.inf /u:C:\WINDOWS\I.txt /f")
_Rundos("sysocmgr /i:C:\WINDOWS\wbemoc_reinstall_x64.inf")
Endif
Exit
EndFunc



