; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>
;
; @ CommandLine parameter:
; Null 9 Files (all without folderTree)
; 1.para or 2.para = delete --> PcInfoTM.exe deletes itself
; 1.para or 2.para = folderTree --> all files including folderTree (takes a bit longer)
;
; Script Function:
;
; Gather some information and save them in 1 Zip file (10 txt-files).
; The script is made for supporters. They can gather information about a
; system and send them to the experts. It works on WIN XP SP2.
;
; ToDo: Error --> Logfile & some more information :-)
; ----------------------------------------------------------------------------

#include <Array.au3>
#include <file.au3>
#include <Process.au3>
#NoTrayIcon
$b = TimerInit() ; Timer
; Array for the file-names
Dim $avArray[11] ; incl Log-File Dim $avArray[12]
$avArray[1] = @ScriptDir & "\" & 'TM_FileAssoziation.txt'
$avArray[2] = @ScriptDir & "\" & 'TM_SystemInfo.txt'
$avArray[3] = @ScriptDir & "\" & 'TM_Windows.txt'
$avArray[4] = @ScriptDir & "\" & 'TM_Environment.txt'
$avArray[5] = @ScriptDir & "\" & 'TM_ProcessList.txt'
$avArray[6] = @ScriptDir & "\" & 'TM_User.txt'
$avArray[7] = @ScriptDir & "\" & 'TM_AutoStart.txt'
$avArray[8] = @ScriptDir & "\" & 'TM_Software.txt'
$avArray[9] = @ScriptDir & "\" & 'TM_FolderTree.txt'
$avArray[10] = @ScriptDir & "\" & 'TM_HardwareInfo.txt'
;$avArray[11] = @ScriptDir & "\" & 'TM_Log.txt' 	# future :-)

$file = FileOpen(@ScriptDir & "\" & 'TM_Software.txt', 2)
$file1 = FileOpen(@ScriptDir & "\" & 'TM_AutoStart.txt', 2)
$file2 = FileOpen(@ScriptDir & "\" & 'TM_User.txt', 2)
$file3 = FileOpen(@ScriptDir & "\" & 'TM_HardwareInfo.txt', 2)
;$file4 = FileOpen(@ScriptDir & "\" & 'TM_Log.txt' , 2)


FileWriteLine($file, "Software-component                                         " & "Version        " & "Publisher           " & "UninstallString")

If $CmdLine[0] > 0 And $CmdLine[1] = "folderTree" Then
	folderTree()
ElseIf $CmdLine[0] > 1 And $CmdLine[2] = "folderTree" Then
	folderTree()             ; tree-command for drive c:\@ProgramFilesDir
EndIf
installedSoftware()          ; Return array with all software intalled on the local system
hwInfo()                     ; Gather some hardware information
ipconfig()                   ; ipconfig-command
autoStart()                  ; detects the autostart-files
system()                     ; some system information
tasklist()                   ; lists the processes
environment()                ; set-command
windows()                    ; some system information
systeminfo()                 ; some system information
fileAssoziation()            ; assoziation file to program
FileClose($file)
FileClose($file1)
FileClose($file3)
FileWriteLine($file2, "*****************************************************************************************************")
FileWriteLine($file2, "The report with PcInfo by Th.Meger took : " & Round(TimerDiff($b)) & " ms")
FileClose($file2)
;FileClose($file4)
If $CmdLine[0] > 0 And $CmdLine[1] = "folderTree" Then
	Sleep(20000)         ; give the system time to complete all the commands
Else
	Sleep(10000)
EndIf
If $CmdLine[0] > 1 And $CmdLine[2] = "folderTree" Then
	Sleep(20000)         ; give the system time to complete all the commands
Else
	Sleep(10000)
EndIf
zipTXT()                     ; zip the nine txt-files
deleteTxtFiles()             ; delete the nine txt-Files
Exit (0)

; ----------------------------------------------------------------------------
; Author:         Thorsten Meger
; Script Function: Func installedSoftware
; ----------------------------------------------------------------------------

Func installedSoftware()
	Local $Count = 1
	Local Const $regkey = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
	
	While 1
		$key = RegEnumKey($regkey, $Count)
		If @error <> 0 Then ExitLoop
		$line = RegRead($regkey & '\' & $key, 'Displayname')
		$line1 = RegRead($regkey & '\' & $key, 'DisplayVersion')
		$line2 = RegRead($regkey & '\' & $key, 'Publisher')
		$line3 = RegRead($regkey & '\' & $key, 'UninstallString')
		$line = StringReplace($line, ' (remove only)', '')
		$line = fullfill(60, $line, ' ')
		$line1 = fullfill(15, $line1, ' ')
		$line2 = fullfill(20, $line2, ' ')
		FileWriteLine($file, $line & $line1 & $line2 & $line3)
		If $line <> '' Then
			If Not IsDeclared('avArray') Then Dim $avArray[1]
			ReDim $avArray[UBound($avArray) + 1]
			$avArray[0] = UBound($avArray) - 1
			$avArray[UBound($avArray) - 1] = $line
		EndIf
		$Count = $Count + 1
	WEnd
	If Not IsDeclared('avArray') Then
		SetError(1)
		Return ('')
	Else
		SetError(0)
		Return ($avArray)
	EndIf
EndFunc   ;==>installedSoftware

; ----------------------------------------------------------------------------
; Author:         Thorsten Meger
; Script Function: Func fullfill
; ----------------------------------------------------------------------------

Func fullfill($maxLength, $string, $fullFillChar)
	; $maxLength 	= maximum string size
	; $fullFillChar = char to fullfill the string
	While 1
		If StringLen($string) < $maxLength Then
			$string = $string & $fullFillChar
			ContinueLoop
		EndIf
		ExitLoop
	WEnd
	Return $string
EndFunc   ;==>fullfill

Func ipconfig()
	Run(@ComSpec & " /c " & "ipconfig /all > " & @ScriptDir & "\" & "TM_IPconfig.txt", "", @SW_HIDE)
EndFunc   ;==>ipconfig

; ----------------------------------------------------------------------------
; Author:         Thorsten Meger
; Script Function: Func autoStart
; ----------------------------------------------------------------------------

Func autoStart()
	Local $Count = 1
	Local Const $regkey = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
	
	While 1
		$key = RegEnumVal($regkey, $Count)
		If @error <> 0 Then ExitLoop
		$line = RegRead($regkey, $key)
		FileWriteLine($file1, $line)
		If $line <> '' Then
			If Not IsDeclared('avArray') Then Dim $avArray[1]
			ReDim $avArray[UBound($avArray) + 1]
			$avArray[0] = UBound($avArray) - 1
			$avArray[UBound($avArray) - 1] = $line
		EndIf
		$Count = $Count + 1
	WEnd
	$search = FileFindFirstFile(@StartupCommonDir & "\*.*")
	If $search = -1 Then
		MsgBox(0, "Error", "No files/directories matched the search pattern")
		Exit
	EndIf
	While 1
		$foundFile = FileFindNextFile($search)
		If @error Then ExitLoop
		FileWriteLine($file1, $foundFile)
	WEnd
EndFunc   ;==>autoStart

; ----------------------------------------------------------------------------
; Author:         Thorsten Meger
; Script Function: Func system
; ----------------------------------------------------------------------------

Func system()
	$hdSizeC = DriveSpaceTotal( "c:\")
	$hdFreeSizeC = DriveSpaceFree( "c:\")
	$hdSizeD = DriveSpaceTotal( "d:\")
	$hdFreeSizeD = DriveSpaceFree( "d:\")
	FileWriteLine($file2, _
			"Hostname           : " & @ComputerName & @CRLF _
			 & "Domain             : " & @LogonDomain & @CRLF _
			 & "LogonServer        : " & @LogonServer & @CRLF _
			 & "OS Type            : " & @OSTYPE & @CRLF _
			 & "Version            : " & @OSVersion & @CRLF _
			 & "ServicePack        : " & @OSServicePack & @CRLF _
			 & "Drive C size       : " & Round($hdSizeC) & "MB" & @CRLF _
			 & "Drive C free       : " & Round($hdFreeSizeC) & "MB" & @CRLF _
			 & "Drive D size       : " & Round($hdSizeD) & "MB" & @CRLF _
			 & "Drive D free       : " & Round($hdFreeSizeD) & "MB" & @CRLF _
			 & "ScriptStarting User: " & @UserName)
	If IsAdmin() Then
		FileWriteLine($file2, "Account            : Administrator" & @CRLF)
	Else
		FileWriteLine($file2, "Account            : User" & @CRLF)
	EndIf
	$loggedInUser = RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\", "AltDefaultUserName")
	FileWriteLine($file2, "Loggedin User      : " & $loggedInUser)
EndFunc   ;==>system

; ----------------------------------------------------------------------------
; Author:         Thorsten Meger
; Script Functions: Functions started in "DOS-Shell"
; ----------------------------------------------------------------------------

Func tasklist()
	Run(@ComSpec & " /c " & "tasklist /v > " & $avArray[5], "", @SW_HIDE)
EndFunc   ;==>tasklist

Func environment()
	Run(@ComSpec & " /c " & "set > " & $avArray[4], "", @SW_HIDE)
	Sleep(200)
	Run(@ComSpec & " /c " & "net use >> " & $avArray[4], "", @SW_HIDE)
EndFunc   ;==>environment

Func windows()
	Run(@ComSpec & " /c " & "netsh diag show os /v > " & $avArray[3], "", @SW_HIDE)
EndFunc   ;==>windows

Func systeminfo()
	Run(@ComSpec & " /c " & "systeminfo.exe > " & $avArray[2], "", @SW_HIDE)
EndFunc   ;==>systeminfo

Func fileAssoziation()
	Run(@ComSpec & " /c " & "assoc > " & $avArray[1], "", @SW_HIDE)
EndFunc   ;==>fileAssoziation

Func folderTree()
	Run(@ComSpec & " /c " & "tree " & @ProgramFilesDir & " /a > " & $avArray[9], "", @SW_HIDE)
EndFunc   ;==>folderTree

Func deleteTxtFiles()
	FileDelete(@ScriptDir & "\TM_*.txt")
EndFunc   ;==>deleteTxtFiles

; ----------------------------------------------------------------------------
; Author:         mozart90 + Thorsten Meger
; Script Function: Easy Zip compression under Win XP
; ----------------------------------------------------------------------------

Func zipTXT()
	$oShell = ObjCreate("Shell.Application")           ; Create s shell Object
	$ZipAchive = @ScriptDir & "\" & 'TM_PCInfo2.0.zip'
	If IsObj($oShell) Then
		initZip($ZipAchive)                            ; Create an emtpy zip file with header
		$oDir = $oShell.NameSpace ($ZipAchive)         ; Use the zip file as an "Folder"
		For $i = 10 To 1 Step - 1
			$oDir.CopyHere ($avArray[$i])              ; Copy the 10 files in the "Zip Folder"
		Next
		Sleep(700)                                     ; Give the Objekt a litte bit time to work
	Else
		MsgBox(0, "Error", "Error creating Object.")
	EndIf
EndFunc   ;==>zipTXT

Func initZip($zip_path_name)
	$init_zipString = Chr(80) & Chr(75) & Chr(5) & Chr(6)   ; Create the Header String
	For $n = 1 To 18
		$init_zipString = $init_zipString & Chr(0)          ; the Header
	Next
	$file = FileOpen($zip_path_name, 2)
	FileWrite($file, $init_zipString)                       ; Write the string in a file
	FileClose($file)
EndFunc   ;==>initZip

; ----------------------------------------------------------------------------
; Author:         Thorsten Meger
; Script Function: _SelfDelete if para "delete" is set as 1st or 2nd para
; ----------------------------------------------------------------------------

Func OnAutoItExit()
	If ($CmdLine[0] > 0 And $CmdLine[1] = "delete") Or ($CmdLine[0] > 1 And $CmdLine[2] = "delete") Then
		_SelfDelete()
	Else
		Exit (0)
	EndIf
EndFunc   ;==>OnAutoItExit

Func _SelfDelete()
	Local $cmdfile
	FileDelete(@TempDir & "\scratch.cmd")
	$cmdfile = ':loop' & @CRLF _
			 & 'del "' & @ScriptFullPath & '"' & @CRLF _
			 & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
			 & 'del ' & @TempDir & '\scratch.cmd'
	FileWrite(@TempDir & "\scratch.cmd", $cmdfile)
	Run(@TempDir & "\scratch.cmd", @TempDir, @SW_HIDE)
EndFunc   ;==>_SelfDelete

; ----------------------------------------------------------------------------
; Author: Chaos2
; Script Function: output basic hardware info
; ----------------------------------------------------------------------------

Func hwInfo()
	$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	
	$colSettings = $objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
	$colMemory = $objWMIService.ExecQuery ("Select * from Win32_ComputerSystem")
	$colCPU = $objWMIService.ExecQuery ("Select * from CIM_Processor")
	$colVideoinfo = $objWMIService.ExecQuery ("Select * from Win32_VideoController")
	$colSound = $objWMIService.ExecQuery ("Select * from Win32_SoundDevice")
	$colMouse = $objWMIService.ExecQuery ("Select * from Win32_PointingDevice")
	$colMonitor = $objWMIService.ExecQuery ("Select * from Win32_DesktopMonitor")
	$colNIC = $objWMIservice.ExecQuery ("Select * from Win32_NetworkAdapter WHERE Netconnectionstatus = 2")
	Dim $pcinfo
	For $object In $colCPU
		$pcinfo = $pcinfo & StringStripWS($object.Name, 1) & @CRLF
	Next
	
	For $objOperatingSystem In $colSettings
		$pcinfo = $pcinfo & $objOperatingSystem.Caption & " Build " & $objOperatingSystem.BuildNumber & " Servicepack " & $objOperatingSystem.ServicePackMajorVersion & "." & $objOperatingSystem.ServicePackMinorVersion & @CRLF
		$pcinfo = $pcinfo & "Available Physical Memory                     : " & String(Int(Number($objOperatingSystem.FreePhysicalMemory) / 1024)) & " Mb" & @CRLF
	Next
	
	For $object In $colMemory
		$pcinfo = $pcinfo & "Total Physical Memory                         : " & String(Int(Number($object.TotalPhysicalMemory) / (1024 * 1024))) & " Mb" & @CRLF
	Next
	
	$objFSO = ObjCreate("Scripting.FileSystemObject")
	$colDrives = $objFSO.Drives
	
	$Opticaldrives = "Opticaldrives			                	          : "
	
	For $object In $colDrives
		If ($object.DriveType == 2) Then
			$pcinfo = $pcinfo & "Total space on                                : " & $object.DriveLetter & ":\  (" & $object.VolumeName & ")  = " & String(Round((Number($object.TotalSize) / (1024 * 1024 * 1024)), 2)) & " Gb" & @CRLF
			$pcinfo = $pcinfo & "Free space on                                 : " & $object.DriveLetter & ":\  (" & $object.VolumeName & ")  = " & String(Round((Number($object.FreeSpace) / (1024 * 1024 * 1024)), 2)) & " Gb" & @CRLF
		Else
			$Opticaldrives = $Opticaldrives & $object.DriveLetter & ":\ "
		EndIf
	Next
	
	$pcinfo = $pcinfo & $Opticaldrives & @CRLF
	
	For $object In $colVideoinfo
		$pcinfo = $pcinfo & "Video card 				                            : " & $object.Description & @CRLF
	Next
	
	For $object In $colSound
		$pcinfo = $pcinfo & "Sound device			                    	      : " & $object.Description & @CRLF
	Next
	
	For $object In $colMouse
		$pcinfo = $pcinfo & "Mouse                                         : " & $object.Description & @CRLF
	Next
	
	For $object In $colMonitor
		$pcinfo = $pcinfo & "Monitor 			                                : " & $object.Description & @CRLF
	Next
	
	For $object In $colNIC
		$pcinfo = $pcinfo & $object.Name & @CRLF
	Next
	FileWrite($file3, "Hardware Information" & @CRLF & "********************" & @CRLF & @CRLF & $pcinfo)
EndFunc   ;==>hwInfo