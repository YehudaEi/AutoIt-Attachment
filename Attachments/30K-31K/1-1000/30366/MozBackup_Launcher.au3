#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Matteo Guallini

 Script Function:
	MozBackup_Launcher

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;Command line example *.cmd : "MozBackup_Launcher.exe myprofile.mozprofile"

#include <Timers.au3>
#Include <File.au3>
#include <array.au3>



$appname=StringMid(@ScriptName,1,StringLen(@ScriptName)-4)
$MozProfile="MozBackup_Launcher.mozprofile" ;default profile

If FileExists(@ScriptDir&"\"&"MozBackup.exe")=0 Then
	MsgBox(48+262144,$appname,"MozBackup.exe not found. The file must be in the same directory of the application. Program will be closed.",30)
	Exit
EndIf

If $CmdLine[0] = 0 Then $MozProfile="MozBackup_Launcher.mozprofile"

If $CmdLine[0] = 1 Then $MozProfile=$CmdLine[1] ;loads the file *.mozprofile from command line

If $CmdLine[0] > 1 Then
	MsgBox(48+262144,$appname,"Wrong command line. Program will be closed.",30)
	Exit
EndIf

If FileExists($MozProfile)=0 Then
	MsgBox(48+262144,$appname,"File '" &$MozProfile&"' not found. Program will be closed.",30)
	Exit
EndIf

$starttime=TimerInit()

While ProcessExists("thunderbird.exe")>0
	ProcessClose("thunderbird.exe")
	If _Timer_Diff($starttime)>60000 then
		MsgBox(48+262144,$appname,"The program is open. Close the program and press OK",0)
		ExitLoop
	EndIf
WEnd

$OutpotPCV=IniRead($MozProfile,"General","output","NA")



Dim $szDrive, $szDir, $szFName, $szExt
$OutpotPCVAr = _PathSplit($OutpotPCV, $szDrive, $szDir, $szFName, $szExt)

If IsArray($OutpotPCVar)=1 Then

	FileDelete($OutpotPCVAr[1]&$OutpotPCVAr[2]&"*"&$OutpotPCVAr[4])
	;MsgBox(48+262144,$appname,$OutpotPCVAr[1]&$OutpotPCVAr[2]&"*"&$OutpotPCVAr[4],0)

Else

	MsgBox(48+262144,$appname,"The backup file contained in '"&$MozProfile&"' isn't correct",0)

EndIf

ShellExecute("mozbackup.exe", '"'&$MozProfile&'"',@ScriptDir)

While ProcessExists("MozBackup.exe")>0
	If ProcessExists("thunderbird.exe")>0 Then
		ProcessClose("thunderbird.exe")
		MsgBox(48+262144,$appname,"Mozilla Thunderbird has been closed because the Backup is running.",30)
	EndIf
WEnd

Sleep(10000)

Run(@ProgramFilesDir&"\Mozilla Thunderbird\thunderbird.exe")


