#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=for use only for evaluation purposes
#AutoIt3Wrapper_Res_Fileversion=0.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Ian Maxwell - MaxImuM AdVaNtAgE SofTWarE 2011
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.3.7.14 (beta)
	Author:         Ian Maxwell (llewxam @ AutoitScript forum)
	
	Script Function:
	Compare local HWIDs to an online database; update local drivers and update online database
	
	;~ need to , MD5 check for dupe names w/ rename for alts, weight field in SQL, install verification check
	
#ce ----------------------------------------------------------------------------


#include <File.au3>
#include <Array.au3>
#include <FTPEx.au3>
#include <MySQL.au3>
#include <GuiTreeView.au3>
#include <GDIpProgress.au3>

If @OSArch == "X64" Then DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)

FileInstall("devcon.exe", @TempDir & "\devcon.exe", 1)
FileInstall("7z.exe", @TempDir & "\7z.exe", 1)
FileInstall("7z.dll", @TempDir & "\7z.dll", 1)
FileInstall("libmysql.dll", @ScriptDir & "\libmysql.dll", 1)

DirRemove(@TempDir & "\DI_O", 1)
DirCreate(@TempDir & "\DI_O")

TCPStartup()
$ServerAddress = TCPNameToIP("DOMAIN_NAME")
$ServerDatabase = "DATABASE_NAME"
$ServerUsername = "DATABASE_USERNAME"
$ServerPassword = "DATABASE_PASSWORD"
$FTPServerAddress = 'FTP_SERVER'
$FTPUsername = 'FTP_USERNAME'
$FTPPassword = 'FTP_PASSWORD'
Local $Action

_MySQL_InitLibrary()
If @error Then Exit MsgBox(0, '', "")
$MysqlConn = _MySQL_Init()
$Connected = _MySQL_Real_Connect($MysqlConn, $ServerAddress, $ServerUsername, $ServerPassword, $ServerDatabase)
If $Connected = 0 Then Exit MsgBox(16, 'Connection Error', _MySQL_Error($MysqlConn))

$OSType = "Type1"
If @OSVersion == "WIN_2003" Or @OSVersion == "WIN_XP" Or @OSVersion == "WIN_2000" Then $OSType = "Type2"
If @OSVersion == "WIN_2008R2" Or @OSVersion == "WIN_7" Or @OSVersion == "WIN_2008" Or @OSVersion == "WIN_VISTA" Then $OSType = "Type3"
If $OSType == "Type1" Then
	MsgBox(0, "WTF??", "What the hell OS is this????  :)" & @CR & @CR & @OSVersion)
	Exit
EndIf
$OSType &= @OSArch

$Green = 0x00ff00

SplashTextOn("Gathering Device Info...", "Please Wait...", 400, 50)

Local $AllHWIDArray
$AllHWIDArray = _GetAllDriverFiles()

Local $Count
Local $Condense[1000][4]
For $a = 1 To $AllHWIDArray[0] - 1
	If StringLeft($AllHWIDArray[$a], 1) <> " " Then
		If StringInStr($AllHWIDArray[$a + 2], "file(s)") Then
			$Count += 1
			$Condense[0][0] += 1
			$Condense[$Count][0] = $AllHWIDArray[$a]
			$Name = StringSplit($AllHWIDArray[$a + 1], "    Name: ", 1)
			$Condense[$Count][1] = $Name[2]
			$Break = StringSplit($AllHWIDArray[$a + 2], "file(s)", 1)
			$GetNumber = StringSplit($Break[1], ". ", 1)
			For $c = 1 To $GetNumber[2]
				$Condense[$Count][2] &= StringStripWS($AllHWIDArray[$a + 2 + $c], 1) & "|"
			Next
			Local $INFInfo[2]
			$INFInfo = _GetINFInfo($Break[1])
			$Condense[$Count][2] &= $INFInfo[0]
			$Condense[$Count][3] &= StringStripWS($INFInfo[1], 8)
		EndIf
	EndIf
Next
SplashOff()

$ChooseGUI = GUICreate("DI_O ALPHA", 800, 700)
$ButtonChooseInstallation = GUICtrlCreateButton("Installing", 10, 10, 380, 40)
$ButtonChooseUpload = GUICtrlCreateButton("Uploading", 410, 10, 380, 40)
GUISetState(@SW_SHOW, $ChooseGUI)

Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit
	If $MSG == $ButtonChooseInstallation Then
		GUICtrlCreateLabel("Matches:", 10, 80, 60, 15)
		$Tree = GUICtrlCreateTreeView(10, 100, 780, 390, $TVS_CHECKBOXES)
		$Action = "Install"
		ExitLoop
	EndIf
	If $MSG == $ButtonChooseUpload Then
		$ProgressBarTotal = _ProgressCreate(10, 65, 780, 10, $Green, $Green, 0x000000, 0x000000)
		_ProgressSetText($ProgressBarTotal, "")
		$Action = "Upload"
		ExitLoop
	EndIf
Until 1 = 2
GUICtrlDelete($ButtonChooseInstallation)
GUICtrlDelete($ButtonChooseUpload)
$LabelStatus = GUICtrlCreateLabel("", 10, 10, 780, 40)
$ProgressBar = _ProgressCreate(10, 55, 780, 10, $Green, $Green, 0x000000, 0x000000)
_ProgressSetText($ProgressBar, "")


For $a = 1 To $Count
	$ThisHWID = StringReplace($Condense[$a][0], "\", "!")
	$ThisHWID = StringReplace($ThisHWID, "&", "$")

	If $Action == "Upload" Then
		GUICtrlSetData($LabelStatus, "Checking for a match to " & $ThisHWID)
		$LookForMatch = _FindOnServer($ThisHWID)
		If $LookForMatch == 0 Then
			GUICtrlSetData($LabelStatus, "Not found on server, archiving " & $ThisHWID)
			_Archive($ThisHWID, $Condense[$a][2], $Condense[$a][3], $Condense[$a][1])
		EndIf
		_ProgressSet($ProgressBarTotal, $a / $Count * 100)
	EndIf

	If $Action == "Install" Then
		$ShowName = StringReplace($ThisHWID, "!", "\")
		$ShowName = StringReplace($ShowName, "$", "&")
		GUICtrlSetData($LabelStatus, "Checking for a match to " & $ShowName)
		$LookForMatch = _FindOnServer($ThisHWID)
		$BreakLookForMatch = StringSplit($LookForMatch, "|")
		If $BreakLookForMatch[0] == 2 Then
			$Path = $BreakLookForMatch[1]
			$FriendlyName = $BreakLookForMatch[2]
			If $Path <> "" Then
				$RemotePath = $FTPServerAddress & "/DI_O/" & $Path
				$FileSize = InetGetSize($RemotePath, 1)
				$GetFileName = StringSplit($Path, "/")
				GUICtrlCreateTreeViewItem($FriendlyName & "   |HWID:" & $ShowName & "|   " & _ByteSuffix($FileSize), $Tree)
			EndIf
		EndIf
		_ProgressSet($ProgressBar, $a / $Count * 100)
	EndIf
Next

If $Action == "Upload" Then
	GUIDelete($ChooseGUI)
	MsgBox(64, "DONE", "Upload to server is now done." & @CR & @CR & "NOW GET BACK TO WORK!!")
	Exit
ElseIf $Action == "Install" Then
	_ProgressDelete($ProgressBar)
	GUICtrlDelete($LabelStatus)
	$ButtonInstall = GUICtrlCreateButton("Install Selected", 410, 10, 380, 40)
	_MySQL_Close($MysqlConn)
	_MySQL_EndLibrary()
	Do
		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then Exit
		If $MSG == $ButtonInstall Then
			GUICtrlDelete($ButtonInstall)
			$FindTreeItems = _GUICtrlTreeView_GetFirstItem($Tree)
			Do
				$TreeItemStatus = _GUICtrlTreeView_GetChecked($Tree, $FindTreeItems)
				If $TreeItemStatus Then
					_FetchFromServer(_GUICtrlTreeView_GetText($Tree, $FindTreeItems))
					_GUICtrlTreeView_SetChecked($Tree, $FindTreeItems, False)
				EndIf
				$FindTreeItems = _GUICtrlTreeView_GetNextSibling($Tree, $FindTreeItems)
			Until Not $FindTreeItems
			If @OSArch == "X86" Then
				FileInstall("dpinst.exe", @TempDir & "\DI_O\dpinst.exe", 1)
			ElseIf @OSArch == "X64" Then
				FileInstall("dpinst64.exe", @TempDir & "\DI_O\dpinst.exe", 1)
			EndIf
			FileInstall("dpinst.xml", @TempDir & "\DI_O\dpinst.xml", 1)
			$LabelStatus = GUICtrlCreateLabel("Installing the selected drivers", 10, 10, 380, 40)
			ShellExecuteWait(@TempDir & "\DI_O\dpinst.exe", "/S /SA /SE /SW")
			GUICtrlDelete($LabelStatus)
			MsgBox(64, "DONE", "Installation is now finished." & @CR & @CR & "NOW GET BACK TO WORK!!")
			Exit
		EndIf
	Until 1 = 2
	Exit
EndIf










Func _GetAllDriverFiles()
	Local $sAllHWIDArray
	$AllHWIDLog = _TempFile(@TempDir, "~", ".log", 7)
	$CMD = Chr(34) & @TempDir & "\devcon.exe driverfiles * > " & $AllHWIDLog & Chr(34)
	RunWait(@ComSpec & " /c " & $CMD, @TempDir, @SW_HIDE)
	_FileReadToArray($AllHWIDLog, $sAllHWIDArray)
	FileDelete($AllHWIDLog)
	Return ($sAllHWIDArray)
EndFunc   ;==>_GetAllDriverFiles


Func _FindLocalHWIDs()
	Local $sAllHWIDArray
	$AllHWIDLog = _TempFile(@TempDir, "~", ".log", 7)
	$CMD = Chr(34) & @TempDir & "\devcon.exe find * > " & $AllHWIDLog & Chr(34)
	RunWait(@ComSpec & " /c " & $CMD, @TempDir, @SW_HIDE)
	_FileReadToArray($AllHWIDLog, $sAllHWIDArray)
	FileDelete($AllHWIDLog)
	Return ($sAllHWIDArray)
EndFunc   ;==>_FindLocalHWIDs


Func _GetFiles($sHWID)
	Local $sAllFilesArray
	$AllFilesLog = _TempFile(@TempDir, "~", ".log", 7)
	$CMD = Chr(34) & @TempDir & "\devcon.exe driverfiles '" & $sHWID & "' > " & $AllFilesLog & Chr(34)
	RunWait(@ComSpec & " /c " & $CMD, @TempDir, @SW_HIDE)
	_FileReadToArray($AllFilesLog, $sAllFilesArray)
	FileDelete($AllFilesLog)
	Return ($sAllFilesArray)
EndFunc   ;==>_GetFiles


Func _GetINFInfo($Info)
	$BreakInfo = StringSplit($Info, " ")
	$INFInfo[0] = $BreakInfo[8]
	$INFInfo[1] = IniRead($BreakInfo[8], "Version", "DriverVer", "Unknown")
	Return $INFInfo
EndFunc   ;==>_GetINFInfo


Func _Archive($ArchiveName, $FileList, $DateStamp, $FriendlyName)
	$BreakFileList = StringSplit($FileList, "|")
	If $BreakFileList[0] > 1 Then
		$ArchiveDir = @TempDir & "\" & $ArchiveName
		DirRemove($ArchiveDir, 1)
		DirCreate($ArchiveDir)
		$LogFile = FileOpen($ArchiveDir & "\contents.txt", 1)
		FileWriteLine($LogFile, "Archive compiled by DI_O, MaxImuM AdVaNtAge SofTWarE")
		For $a = 1 To $BreakFileList[0]

			$TrimSpaces = $BreakFileList[$a]
			Do
;~ 				MsgBox(0, "trim", $TrimSpaces)
				If StringLeft($TrimSpaces, 1) <> " " Then ExitLoop
				$TrimSpaces = StringTrimLeft($TrimSpaces, 1)
			Until 1 = 2

			$CopyToArchiveDir = FileCopy($TrimSpaces, $ArchiveDir & "\", 1 + 8)
			If $CopyToArchiveDir == 0 Then
				ConsoleWrite($TrimSpaces & @CR)
				MsgBox(0, "oops", $TrimSpaces & @CR & "failed to copy" & @CR & FileGetSize($TrimSpaces) & @CR & Asc(StringLeft($TrimSpaces, 1)))
			EndIf
			FileWriteLine($LogFile, $TrimSpaces)
		Next
		FileClose($LogFile)
		$BreakDateStamp = StringSplit($DateStamp, ",")
		RunWait(@TempDir & "\7z.exe a " & @TempDir & "\" & $ArchiveName & ".zip" & " " & $ArchiveDir & "\", "", @SW_HIDE)
		GUICtrlSetData($LabelStatus, "Not found on server, uploading " & $ArchiveName & @CR & _ByteSuffix(FileGetSize(@TempDir & "\" & $ArchiveName & ".zip")))
		$FTPOpen = _FTP_Open('MyFTP')
		$FTPConnect = _FTP_Connect($FTPOpen, $FTPServerAddress, $FTPUsername, $FTPPassword)
		$FTPSend = _FTP_ProgressUploadMod($FTPConnect, @TempDir & "\" & $ArchiveName & ".zip", "public_html/DI_O/" & $OSType & "/" & $ArchiveName & ".zip")
		$FTPClose = _FTP_Close($FTPOpen)



		$Query = "INSERT INTO " & $OSType & " (HWID, Path, DateStamp, Version, FriendlyName) VALUES ('" & $ArchiveName & "', '" & $OSType & "/" & $ArchiveName & ".zip" & "', '" & StringStripWS($BreakDateStamp[1], 8) & "', '" & StringStripWS($BreakDateStamp[2], 8) & "', '" & $FriendlyName & "')"
		If _MySQL_Real_Query($MysqlConn, $Query) = $MYSQL_ERROR Then
;~ 			MsgBox(0, 'Error', _MySQL_Error($MysqlConn))
			_MySQL_Close($MysqlConn)
			_MySQL_EndLibrary()
			$MysqlConn = _MySQL_Init()
			$Connected = _MySQL_Real_Connect($MysqlConn, $ServerAddress, $ServerUsername, $ServerPassword, $ServerDatabase)
			If $Connected = 0 Then Exit MsgBox(16, 'Connection Error', _MySQL_Error($MysqlConn))
			If _MySQL_Real_Query($MysqlConn, $Query) = $MYSQL_ERROR Then
				MsgBox(0, 'Error', _MySQL_Error($MysqlConn))
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_Archive


Func _FindOnServer($PerHWID)
	$Query = "SELECT * FROM " & $OSType & " WHERE HWID='" & _MySQL_Real_Escape_String($MysqlConn, $PerHWID) & "'"
;~ 	$Connected = _MySQL_Real_Connect($MysqlConn, $ServerAddress, $ServerUsername, $ServerPassword, $ServerDatabase)
	If _MySQL_Real_Query($MysqlConn, $Query) = $MYSQL_ERROR Then
;~ 			MsgBox(0, 'Error', _MySQL_Error($MysqlConn))
		_MySQL_Close($MysqlConn)
		_MySQL_EndLibrary()
		$MysqlConn = _MySQL_Init()
		$Connected = _MySQL_Real_Connect($MysqlConn, $ServerAddress, $ServerUsername, $ServerPassword, $ServerDatabase)
		If $Connected = 0 Then Exit MsgBox(16, 'Connection Error', _MySQL_Error($MysqlConn))
		If _MySQL_Real_Query($MysqlConn, $Query) = $MYSQL_ERROR Then
			MsgBox(0, 'Error', _MySQL_Error($MysqlConn))
		EndIf
	Else
		$result = _MySQL_Store_Result($MysqlConn)
		$Fetch = _MySQL_Fetch_Result_StringArray($result)
		_MySQL_Free_Result($result)
		If IsArray($Fetch) Then
			$Path = $Fetch[1][1]
			$FriendlyName = $Fetch[1][4]
			Return $Path & "|" & $FriendlyName
		EndIf
	EndIf
	Return 0
EndFunc   ;==>_FindOnServer


Func _FTP_ProgressUploadMod($l_FTPSession, $s_LocalFile, $s_RemoteFile, $FunctionToCall = "yes")
	If $__ghWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
	Local $ai_InternetCloseHandle, $glen, $last, $x, $parts, $buffer, $ai_ftpwrite, $result, $out, $i, $ret
	Local $ai_ftpopenfile = DllCall($__ghWinInet_FTP, 'handle', 'FtpOpenFileW', 'handle', $l_FTPSession, 'wstr', $s_RemoteFile, 'dword', $GENERIC_WRITE, 'dword', $FTP_TRANSFER_TYPE_BINARY, 'dword_ptr', 0)
	If @error Or $ai_ftpopenfile[0] = 0 Then Return SetError(-3, _WinAPI_GetLastError(), 0)
	If $FunctionToCall = "" Then ProgressOn("FTP Upload", "Uploading " & $s_LocalFile)
	Local $fhandle = FileOpen($s_LocalFile, 16)
	$glen = FileGetSize($s_LocalFile)
	$last = Mod($glen, 100)
	$x = ($glen - $last) / 100
	If $x = 0 Then
		$x = $last
		$parts = 1
	ElseIf $last > 0 Then
		$parts = 101
	Else
		$parts = 100
	EndIf
	If $x < $last Then
		$buffer = DllStructCreate("byte[" & $last & "]")
	Else
		$buffer = DllStructCreate("byte[" & $x & "]")
	EndIf
	For $i = 1 To $parts
		Select
			Case $i = 101 And $last > 0
				$x = $last
		EndSelect
		DllStructSetData($buffer, 1, FileRead($fhandle, $x))
		$ai_ftpwrite = DllCall($__ghWinInet_FTP, 'bool', 'InternetWriteFile', 'handle', $ai_ftpopenfile[0], 'ptr', DllStructGetPtr($buffer), 'dword', $x, 'dword*', $out)
		If @error Or $ai_ftpwrite[0] = 0 Then
			Local $lasterror = _WinAPI_GetLastError()
			$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_ftpopenfile[0])
			FileClose($fhandle)
			Return SetError(-4, $lasterror, 0)
		EndIf
		_ProgressSet($ProgressBar, $i)
		Sleep(10)
	Next
	FileClose($fhandle)
	If $FunctionToCall = "" Then ProgressOff()
	$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_ftpopenfile[0])
	If @error Or $ai_InternetCloseHandle[0] = 0 Then Return SetError(-5, 0, 0)
	Return 1
EndFunc   ;==>_FTP_ProgressUploadMod


Func _ByteSuffix($bytes)
	Local $x, $bytes_suffix[6] = [" B", " KB", " MB", " GB", " TB", " PB"]
	While $bytes > 1023
		$x += 1
		$bytes /= 1024
	WEnd
	Return StringFormat('%.2f', $bytes) & $bytes_suffix[$x]
EndFunc   ;==>_ByteSuffix


Func _FetchFromServer($WhatToFind)
	$Green = 0x00ff00
	$ProgressBar = _ProgressCreate(10, 55, 780, 10, $Green, $Green, 0x000000, 0x000000)
	_ProgressSetText($ProgressBar, "")
	$BreakWhat = StringSplit($WhatToFind, "|HWID:", 1)
	$FriendlyName = $BreakWhat[1]
	$BreakMore = StringSplit($BreakWhat[2], "|   ", 1)
	$ArchiveName = $BreakMore[1]
	$ArchiveName = StringReplace($ArchiveName, "\", "!")
	$ArchiveName = StringReplace($ArchiveName, "&", "$")
	$RemotePath = $FTPServerAddress & "/DI_O/" & $OSType & "/" & $ArchiveName & ".zip"
	$FileSize = InetGetSize($RemotePath, 1)
	$LabelStatus = GUICtrlCreateLabel("Found on server, downloading " & $FriendlyName & @CR & _ByteSuffix($FileSize), 10, 10, 380, 40)
	$Downloading = InetGet($RemotePath, @TempDir & "\DI_O\" & $ArchiveName & ".zip", 1, 1)
	Do
		Sleep(50)
		$DLStatus = InetGetInfo($Downloading, 0)
		_ProgressSet($ProgressBar, $DLStatus / $FileSize * 100)
	Until InetGetInfo($Downloading, 2)
	_ProgressDelete($ProgressBar)
	GUICtrlSetData($LabelStatus, "Extracting " & $FriendlyName)
	RunWait(@TempDir & "\7z.exe x " & @TempDir & "\DI_O\" & $ArchiveName & ".zip -y -o" & @TempDir & "\DI_O", "", @SW_HIDE)
	GUICtrlDelete($LabelStatus)
EndFunc   ;==>_FetchFromServer