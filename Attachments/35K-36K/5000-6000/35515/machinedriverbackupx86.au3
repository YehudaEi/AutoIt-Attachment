; driver machine backup - by ndog
; Backs up drivers using Driver Genius and Double Driver
; last updated @ 22/09/2011
; version 0.7.4

#RequireAdmin

; Check if we're on 32-bit OS ;If @OSArch = "X64" Then
;	MsgBox(64,"Wrong Version", "You are running "& @OSVersion &"_"& @OSArch & ". Please run the x64 bit version")
;	Exit
;EndIf

#include <mmb_cpux86.au3>
#include <mmb.au3>
#include <File.au3>

;Double Driver Install
DirCreate(@TempDir & "\Double Driver")
FileInstall(".\Include\Double Driver\ddc.exe",@TempDir & "\Double Driver\", 1)
FileInstall(".\Include\Double Driver\dd.dll",@TempDir & "\Double Driver\", 1)

;Driver Genius Install
DirCreate(@TempDir & "\DriverGenius")
FileInstall(".\Include\DriverGenius\AlphaImageControl.ocx",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\AniGIF.ocx",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\clmultidx7.ocx",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\CodejockControls.ocx",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\DriverGenius.exe",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\LiveUpdate.exe",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\aspr_ide.dll",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\XceedZip.dll",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\zlib1.dll",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\xcdsfx32.bin",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\DriverGenius.cfg",@TempDir & "\DriverGenius\", 1)
FileInstall(".\Include\DriverGenius\DriversDB.dbd",@TempDir & "\DriverGenius\", 1)
DirCreate(@TempDir &"\DriverGenius\Languages")
FileInstall(".\Include\DriverGenius\Languages\English.lng",@TempDir & "\DriverGenius\Languages\", 1)

;Working Folder
$src = @TempDir & "\drivers_drivergenius"
$dst = @TempDir & "\drivers_doubledriver"



; Create the temp file needed to get Machine Info
_GetCPUzInfo()
$outputdir = @ScriptDir &"\"& _GetLaptop() &"\"& _GetManufacturer() &"\"& _GetModel() &"\"& @OSVersion &"_"& @OSArch
MsgBox(0,"Your Machine will be backed up to: ",$outputdir,5)

;Run Double Driver First
DirRemove($dst,1)
DirCreate($dst)
RunWait(@TempDir & "\Double Driver\ddc.exe b /target:"&@TempDir&"\drivers_doubledriver", @TempDir, @SW_HIDE)

;Run Driver Genius Second
DirRemove($src,1)
DirCreate($src)
RunWait(@TempDir & "\DriverGenius\DriverGenius.exe /B/T/D "&@TempDir&"\drivers_drivergenius", @TempDir, @SW_HIDE)

;scan source folder for immediate folders and create array of folders
$srcdirlist=_FileListToArray($src, "*", 2)
;_ArrayDisplay($srcdirlist,"$srcdirList") ;debugging

;parse through the destination folder sub-folders
;if matches are found to the array then perform operations

;scan the destination folder
$aFolders = _FileListToArray($dst)
For $i = 1 To UBound($aFolders) - 1
	
	;scan the sub folders one level deep
	$xFolders = _FileListToArray($dst&"\"& $aFolders[$i],"*",2)
	For $j = 1 To UBound($xFolders) - 1
		;MsgBox(0,"",$dst &@LF& $aFolders[$i] &@LF& $xFolders[$j] &@LF&"aFolder..." &$i& "xFolder..." &$j) ;debugging

		;scan through the $srcdirlist array and if it finds a match with the current loop then do work
		For $k = 1 To UBound($srcdirlist) - 1
			;MsgBox(0,"",$srcdirlist[$k]&@LF&$xFolders[$j]) ;debug
			
			; match directly (not needed)
			;If $srcdirlist[$k] = $xFolders[$j] Then 
			;	MsgBox (0,"match",$srcdirlist[$k])
			;	ExitLoop
			;EndIf
			
			;replace all '-' with 'space' on strings so they are the same
			$sFsr = StringRegExpReplace($srcdirlist[$k], "[-]"," ")
			$xFsr = StringRegExpReplace($xFolders[$j], "[-]"," ")

			;move and replace destination folder with source folder
			If $sFsr = $xFsr Then 
				;MsgBox (0,"match",$srcdirlist[$k]) ; eg Intel(R) ICH7M MDH SATA AHCI Controller ; eg Intel(R) ICH7M-U LPC Interface Controller - 27B9
				
				FileMove($dst &"\"& $aFolders[$i] &"\"& $xFolders[$j] &"\restore.ini",@TempDir,1)
				DirRemove($dst &"\"& $aFolders[$i] &"\"& $xFolders[$j],1)
				DirMove($src &"\"& $srcdirlist[$k],$dst &"\"& $aFolders[$i] &"\"& $xFolders[$j],1)
				FileMove(@TempDir &"\restore.ini", $dst &"\"& $aFolders[$i] &"\"& $xFolders[$j],1)
				
				ExitLoop
			EndIf
		
		Next
	Next
Next

; Cleanup folders
DirRemove($dst & "\Image",1) ; Scanners
DirRemove($dst & "\Monitor",1) ; Screen
DirRemove($dst & "\Printer",1)
DirRemove($dst & "\Wireless Communication Devices",1)

; Cleanup subfolders
DirRemove($dst & "Display\LogMeIn Mirror Driver",1) ; LogMeIn

DirRemove($dst & "\Net\Teefer2 Miniport",1) ; SEP Network Driver

DirRemove($dst & "\Net\VMware Virtual Ethernet Adapter for VMnet1",1) ; VMWare
DirRemove($dst & "\Net\VMware Virtual Ethernet Adapter for VMnet8",1)
DirRemove($dst & "\USB\VMware USB Device",1)
DirRemove($dst & "\Mouse\VMware Pointing Device",1)

DirRemove($dst & "\Net\Apple Mobile Device Ethernet",1) ; Apple iTunes
DirRemove($dst & "\USB\Apple Mobile Device USB Driver",1)

DirRemove($dst & "\Net\Check Point Virtual Network Adapter For SecureClient",1) ; VPN software - SecureClient
DirRemove($dst & "\Net\TAP-Win32 Adapter V9",1)
DirRemove($dst & "\Net\SecuRemote Miniport",1)

DirRemove($dst & "\Net\NetLimiter Ndis Miniport Service",1) ; NetLimiter

DirRemove($dst & "\USB\Sony DSC",1) ; ???



; Remove empty folders - http://www.autoitscript.com/forum/topic/77323-search-for-empty-folders-and-delete-them/page__view__findpost__p__560019
_delEmpty($dst)
Func _delEmpty($dir)
    $folderList = _FileListToArray($dir, "*", 2)
    If @error <> 4 Then
        For $i = 1 to $folderList[0]
            _delEmpty($dir & "\" & $folderList[$i])
        Next
    EndIf
    $fileList = _FileListToArray($dir, -1, 0)
    If @error = 4 Then DirRemove($dir)
EndFunc




; Create the output
DirCreate($outputdir)

; Move temp drivers backup into final destination
For $i = 1 To UBound($aFolders) - 1
	DirMove($dst&"\"& $aFolders[$i],$outputdir,1)
Next

;Cleanup machine
DirRemove(@MyDocumentsDir & "\DriverGenius",1)
DirRemove(@TempDir & "\Double Driver",1)
DirRemove(@TempDir & "\DriverGenius",1)
DirRemove(@TempDir & "\drivers_drivergenius",1)
DirRemove(@TempDir & "\drivers_doubledriver",1)

FileDelete(@TempDir & "\cpuz.exe")
FileDelete(@TempDir & "\cpuz64.exe")
FileDelete(@TempDir & "\mysystem.txt")

;Final GUI
MsgBox(0,"Your Machine was backed up to: ",$outputdir)