#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\_resources\images\icons_v7\DL_1.ico
#AutoIt3Wrapper_Outfile=InstallDownloader.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=RapidStudio Install Downloader
#AutoIt3Wrapper_Res_Fileversion=1.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=© Copyright, RapidStudio 2010
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_After=""C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin\signtool.exe" sign /a /t http://timestamp.comodoca.com/authenticode "%out%""
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.3.6.1
	Author:         Francisca Carstens
	
	Script Function:
	Download all installation files
	Perform CRC check
	Download missing files
	Check dotnet install
	Download dotnet if necessary
	Download and install support applications
	Launch Setup
	
	FEATURE REQUESTS:
	- Check if DotNet is installed. If later than version 2.0, then don't download the file. >>> done
	
	********************************************************************************************************************************************************************************************************
	PENDING BUGS:
	
	
	PENDING FEATURE REQUESTS:
	
	********************************************************************************************************************************************************************************************************
	
	
	####################################################################
	
	####################################################################
	
	
#ce ----------------------------------------------------------------------------



#include <GUIConstants.au3>
#include <_CRC.au3>
#include <File.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Date.au3>
#include <Timers.au3>
#include <ButtonConstants.au3>
#include <Process.au3>
#include <GUICtrlHyperLink.au3>
#include <Debug.au3>
#include <AutoItErrorHandler_UDF_fc.au3>

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
Local $tempdir = 'C:\Temp\rsinst'
;~ $debugreport = _TempFile($tempdir, "debug~", ".txt")
$tCur = _Date_Time_GetSystemTime()
$array = _Date_Time_SystemTimeToArray($tCur)
#cs
	[0] - Month
	[1] - Day
	[2] - Year
	[3] - Hour
	[4] - Minutes
	[5] - Seconds
	[6] - Milliseconds
	[7] - Day of week
#ce
$tCur = $array[2] & $array[0] & $array[1] & $array[3] & $array[4] & $array[5]
$debugreport = 'C:\Temp\debug\' & 'debug_' & $tCur & ".txt"
$fileh = FileOpen($debugreport, 8)
FileClose($fileh)
If FileExists('C:\Temp\debug') = False Then DirCreate('C:\Temp\debug')
_DebugSetup("RapidStudio Install Downloader Debug", False, 4, $debugreport)
_Debug('start', $tempdir)
$regerror = _RegRead()
_Debug('$regerror = _RegRead()', $regerror)
;~ AdlibRegister("_Debug")

#Region -> Create Temp Dir
Local $string = _TempFile(@TempDir, "rsinst~", "", 5)
Local $array = StringSplit($string, ".")
Local $TEMP = $array[1]
If FileExists($TEMP) = False Then DirCreate($TEMP)
#EndRegion -> Create Temp Dir

If $regerror = 0 Then
	_Debug('If $regerror = 0 Then _GUI()', $regerror)
	_GUI()
EndIf
Func _GUI()
	$width = 600
	$height = 265
	$gui1 = GUICreate("Upgrade Recommended", $width, $height, -1, 10, BitOR($GUI_SS_DEFAULT_GUI, $DS_SETFOREGROUND), $WS_EX_TOPMOST)
	_Debug('$gui1 = GUICreate(...)', $gui1)

	$label1 = GUICtrlCreateLabel("You already have RapidStudio installed.", 15, 15, $width - 30, 45)
	_Debug('$label1 = GUICtrlCreateLabel(...)', $label1)
	GUICtrlSetFont(-1, 8.5, 800, "", "", 2)
	GUICtrlCreateLabel("Uninstalling the old version and installing a fresh copy will remove all your existing content.  It is highly reccomended that you rather choose the 'UPGRADE' option.", 15, 30, $width - 30, 45)

	GUICtrlCreateLabel("Click the Upgrade button to upgrade RapidStudio AlbumMaker to the latest version.", 30, 90, $width - 60, 15)

	GUICtrlCreateGroup("Upgrade", 15, 75, $width - 30, 75)
	GUICtrlSetFont(-1, 8.5, 800, "", "", 2)
	$but2 = GUICtrlCreateButton("&Upgrade", $width - 130, 105, 100, 30, $BS_DEFPUSHBUTTON)

	$group = GUICtrlCreateGroup("Install Anyway", 15, 165, $width - 30, 90)
	GUICtrlSetFont(-1, 8.5, 800, "", "", 2)
	$label2 = GUICtrlCreateLabel("I understand the implications of installing a fresh copy of RapidStudio.  I want to continue anyway.", 30, 180, $width - 60, 30)
	$chk = GUICtrlCreateCheckbox("Tick this box if you agree and wish to continue downloading the installation files.", 30, 210, 400, 15)
	$but1 = GUICtrlCreateButton("&Install", $width - 130, 210, 100, 30)
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUISetState()
	_Debug('GUISetState($gui1)', $gui1)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				_Debug('Case $GUI_EVENT_CLOSE: $gui1', $gui1)
				If MsgBox(4096 + 4 + 32, "Cancel Setup", "Are you sure you want to cancel setup?") = 6 Then Exit
			Case $but1
				_Debug('Case $but1 (INSTALL): $gui1', $but1)
				ExitLoop
			Case $chk
				_Debug('Case $chk: $gui1', $chk)
				If BitAND(GUICtrlRead($chk), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($but1, $GUI_ENABLE)
				Else
					GUICtrlSetState($but1, $GUI_DISABLE)
				EndIf
			Case $but2
				_Debug('Case $but2 (UPGRADE): $gui1', $but2)
				ShellExecute('http://upgrade.rapidstudio.co.za')
				Exit
		EndSwitch
	WEnd
	GUIDelete($gui1)
EndFunc   ;==>_GUI

#Region -> GUI
FileInstall('resources\header-2.jpg', $TEMP & '\header.jpg')
FileInstall('resources\button-shadow-2.jpg', $TEMP & '\button-shadow.jpg')
FileInstall('resources\dot-2.jpg', $TEMP & '\dot.jpg')
FileInstall('resources\continue-1.ico', $TEMP & '\continue-1.ico')
FileInstall('resources\finish-1.ico', $TEMP & '\finish-1.ico')
Local $hGUI = GUICreate('RapidStudio Install Downloader', 800, 500)
Local $textL = 30, $progW = 710, $textT = 70, $g = 30
GUISetBkColor(0xffffff)
GUICtrlSetDefColor(0x000000)
GUICtrlCreatePic($TEMP & '\header.jpg', 0, 0, 800, 71)
GUICtrlCreatePic($TEMP & '\dot.jpg', 2, 410, 796, 4)
DirCreate($TEMP)
$hListBox = GUICtrlCreateListView(" | | | | | ", $textL, 130, 740, 270, $LVS_NOSORTHEADER)
GUICtrlSetState(-1, $GUI_HIDE)
$label1 = GUICtrlCreateLabel('Please wait...', $textL, $textT, 740, 200)
$label2 = GUICtrlCreateLabel("", $progW + $textL + 5, $textT + $g + 2, 50, 15)
GUICtrlSetState(-1, $GUI_HIDE)
$label3 = GUICtrlCreateLabel("", $textL, 465, 200, 30)
$but1 = GUICtrlCreateButton("&Continue", 615, 425, 170, 53)
GUICtrlSetStyle(-1, $BS_ICON)
GUICtrlSetImage($but1, $TEMP & '\continue-1.ico')
GUICtrlSetState(-1, $GUI_DISABLE)

$shadow = GUICtrlCreatePic($TEMP & '\button-shadow.jpg', 615, 478, 170, 18)
GUICtrlSetState(-1, $GUI_HIDE)
$Progress1 = GUICtrlCreateProgress($textL, $textT + $g, $progW, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$chk = GUICtrlCreateCheckbox("Delete setup files.", $textL, 220)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetState(-1, $GUI_CHECKED)


GUISetState()
#EndRegion -> GUI
#Region -> Declare files & Variables
$labcode = "none"
$sublabcode = "none"
$sitename = "none"
$issub = "none"
$ini = $TEMP & '\params.ini'
$inih = FileOpen($ini, 2)
IniWrite($ini, "PARAMS", "LABCODE", $labcode)
IniWrite($ini, "PARAMS", "SITENAME", $sitename)
IniWrite($ini, "PARAMS", "ISSUB", $issub)
IniWrite($ini, "PARAMS", "SUBLABCODE", $sublabcode)
FileClose($inih)
Local $root = "http://hosted01.rapidstudio.co.za/RSInstall"
$version = 'basic'
$checkfile = $TEMP & '\CRC_' & $version & '.txt'
$FileNameUpdater = 'support_autosetup.exe'
$TargetUpdater = $TEMP & '\support_autosetup.exe'
$FileNameVars = 'VarsUpdate.exe'
$TargetVars = $TEMP & '\VarsUpdate.exe'
Global $BufferSize = 0x20000
Global $Timer = TimerInit()
Global $CRC32 = 0, $CRC16 = 0
Global $Data
$tCur = _Date_Time_GetSystemTime()
$tStr = _Date_Time_SystemTimeToDateTimeStr($tCur, 1)
$tStr = StringReplace($tStr, ":", "")
$tStr = StringReplace($tStr, "/", "")
$tStr = StringReplace($tStr, " ", "")
$errorlog = _TempFile($TEMP, "err~", ".txt")
$dirlist = _TempFile($TEMP, "dir~", ".txt")
$countCorrupt = 0
$sucess = 0
Local $hDownload
Local $fileno
Local $exit = 0
$count = 0
$regerror = 0
Local $msg = ""
#EndRegion -> Declare files & Variables


#Region -> Get CRC Checkfile & Set array variables
; Call crc_check.php page and write response to a file CRC_basic.txt
$ping = 0
While $ping = 0
	GUICtrlSetData($label1, "Please wait. Checking internet connection...")
	GUICtrlSetData($label1, "Please wait. Checking internet connection... ping: www.google.com")
	$ping = Ping('www.google123.com', 4000)
	GUICtrlSetData($label1, "Please wait. Checking internet connection... ping: www.yahoo.com")
	If $ping = 0 Then $ping = Ping('www.yahoo.com', 4000)
	GUICtrlSetData($label1, "Please wait. Checking internet connection... ping: www.facebook.com")
	If $ping = 0 Then $ping = Ping('www.facebook.com', 4000)
	GUICtrlSetData($label1, "Please wait. Checking internet connection... ping: www.twitter.com")
	If $ping = 0 Then $ping = Ping('www.twitter.com', 4000)
	If $ping > 0 Then ExitLoop
	If $ping = 0 Then
		If MsgBox(5, "Error connecting to site", "Are you connected to the internet?" & @CRLF & @CRLF & "Either you are not connected to the internet or your computer is blocking internet access for this application.") = 2 Then
			DirRemove($TEMP, 1)
			Exit
		EndIf
	EndIf

WEnd


GUICtrlSetData($label1, "Please wait. Retrieving directory download size...")
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
_Debug('ObjCreate("winhttp.winhttprequest.5.1")', $oHTTP)
$oHTTP.Open("GET", "http://hosted01.rapidstudio.co.za/RSInstall/config/get_installdir_size.php")
_Debug('$oHTTP.Open("GET", "http://hosted01.rapidstudio.co.za/RSInstall/config/get_installdir_size.php")', $oHTTP)
$oHTTP.Send()
_Debug('$oHTTP.Send()', $oHTTP)
$HTMLSource = $oHTTP.Responsetext
_Debug('$oHTTP.Responsetext', $HTMLSource)
$dirsize = $HTMLSource
GUICtrlSetData($label1, "Please wait. Retrieving crc checkfile...")
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
_Debug('ObjCreate("winhttp.winhttprequest.5.1")', $oHTTP)
$oHTTP.Open("GET", "http://hosted01.rapidstudio.co.za/RSInstall/config/crc_check.php")
_Debug('$oHTTP.Open("GET", "http://hosted01.rapidstudio.co.za/RSInstall/config/crc_check.php")', $oHTTP)
$oHTTP.Send()
_Debug('$oHTTP.Send()', $oHTTP)
$HTMLSource = $oHTTP.Responsetext
_Debug('$oHTTP.Send()', $HTMLSource)
$aSource = StringSplit($HTMLSource, ",")
$afile = $checkfile
$aFileh = FileOpen($afile, 2)
FileWrite($afile, $HTMLSource)
_Debug('FileWrite($afile, $HTMLSource)', $aFileh)
FileClose($aFileh)

#Region -> Remove dotnet2.0.exe from file
GUICtrlSetData($label1, "Please wait. Make ready crc checkfile...")
_FileReadToArray($checkfile, $array)
_Debug('_FileReadToArray($checkfile, $array)', $checkfile)
;~ ShellExecute($checkfile, "", "", "edit")
If $array[0] < 2 Then
	_Debug('If $array[0] < 2 Then', $array[0])
	MsgBox(48, "Error", "Error retrieving filelist." & @CRLF & "Your computer is not allowing this application access to the internet.")
	DirRemove($TEMP, 1)
	Exit
EndIf
$file = _TempFile(@TempDir, "~", ".txt")
$fileh = FileOpen($file, 1)
$iMax = $array[0]
For $i = 1 To $iMax
	$array2 = StringSplit($array[$i], '=')
	$FileName = StringStripWS($array2[1], 3)
	$var = StringInStr($FileName, "dotnet2.0.exe")
	If $var > 0 Then
		_Debug('StringInStr($FileName, "dotnet2.0.exe"): $var > 0', $var)
		$crcDotnet = StringStripWS($array2[2], 3)
		$urlDotnet = StringStripWS(StringReplace($array2[1], '\', '/'), 3)
		$FileDirDotnet = StringStripWS($array2[1], 3)
		$sfile = $tempdir & '\' & $version & '\' & $array2[1] ;$sfile = $setuppath & '\RapidStudioInstall' & '\' & FileReadLine($checkfile, $i)
		$FileString = StringStripWS($sfile, 3)
		$FileNameDotnet = StringStripWS($array2[1], 3)
		$dirarray = StringSplit($FileString, "\")
		$vMax = $dirarray[0]
		$dir = ''
		For $v = 1 To $vMax - 1
			$dir &= $dirarray[$v] & '\'
		Next
		DirCreate($dir)
		$TargetDotnet = $tempdir & '\' & $version & "\" & $FileNameDotnet
		;MsgBox(0, "dotnet", "$crcDotnet = " & $crcDotnet & @CRLF & "$urlDotnet = " & $urlDotnet & @CRLF & "$FileDirDotnet = " & $dir & @CRLF & "$FileNameDotnet = " & $FileNameDotnet)
	Else
		FileWriteLine($fileh, $array[$i])
	EndIf
Next
FileClose($fileh)
FileMove($file, $checkfile, 1)
_Debug('FileMove($file, $checkfile, 1)', $checkfile)
;ShellExecuteWait($checkfile, "", "", "edit")
#EndRegion -> Remove dotnet2.0.exe from file

GUICtrlSetData($label1, "Please wait. Countlines...")
$zMax = _FileCountLines($checkfile)
_Debug('_FileCountLines($checkfile)', $checkfile)
Dim $hDownloadNo[$zMax];say we want up to 10 downloads. We can increase with ReDim if needed
$iIndex = 0
Dim $Target[$zMax]
Dim $FileDir[$zMax]
Dim $iIndex[$zMax]
Dim $urlfile[$zMax]
Dim $CRCTarget[$zMax]
Dim $crcinfile[$zMax]
Dim $FileName[$zMax]
$inmax = $zMax;set the number of consecutive downloads
$inmax -= 1
$next = 0
#EndRegion -> Get CRC Checkfile & Set array variables









GUICtrlSetData($label1, "Welcome to the RapidStudio Install Downloader." & @CRLF & @CRLF & _
		'This application will download the installation files for RapidStudio Album Maker.  Please note that downloading these files may take some time, as there are many files to download.  ' & _
		'Once the files are downloaded, a CRC check will be performed to make sure that all the files were downloaded successfully.  If the CRC check fails on any files, it will download those files again.' & @CRLF & @CRLF & _
		'Once the CRC Check is complete, the installation will start automatically.  Please try not to close this application during any stage of processing tasks, as this might cause the installation to become corrupt.' & @CRLF & @CRLF & @CRLF & _
		'Please click on the "Continue" button to start the download. (Approximate size of download: ' & Round($dirsize / 1024 / 1024, 2) - 22.4 & ' MB)')
_Debug('GUICtrlsetData($label1)', $label1)
GUICtrlSetState($but1, $GUI_ENABLE)
_Debug('$but1', $but1)
GUICtrlSetCursor($but1, 0)
_Debug('$but1', $but1)
GUICtrlSetState($shadow, $GUI_SHOW)
_Debug('$shadow', $shadow)



While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			_Debug('Case $GUI_EVENT_CLOSE: $hGUI', $sucess)
			_Debug('Case $GUI_EVENT_CLOSE: $hGUI', $exit)
			If $sucess = 1 Then
				If $exit = 1 Then
					AdlibUnRegister("SetProgress")
;~ 					AdlibUnRegister("_Debug")
					DirRemove($TEMP, 1)
					Exit
				ElseIf MsgBox(48 + 3, "Are you sure?", "This application is still busy processing tasks." & @CRLF & @CRLF & "Do you really want to exit?") = 6 Then
					AdlibUnRegister("SetProgress")
;~ 					AdlibUnRegister("_Debug")
					DirRemove($TEMP, 1)
					Exit
				EndIf
			Else
				AdlibUnRegister("SetProgress")
				GUICtrlSetData($label1, "Cancelling download...")
;~ 				For $n = 0 To $next
;~ 					$percent = $n / $next * 100
;~ 					GUICtrlSetData($Progress1, $percent)
;~ 					InetClose($hDownloadNo[$n])
;~ 				Next
				AdlibUnRegister("_getmessage")
;~ 				AdlibUnRegister("_Debug")
				DirRemove($TEMP, 1)
				Exit
			EndIf

		Case $but1
			_Debug('Case $but1: $hGUI', $exit)
			If $exit = 1 Then
				DirRemove($TEMP, 1)
				If BitAND(GUICtrlRead($chk), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($but1, $GUI_DISABLE)
					_DeleteFiles()
				Else
;~ 				If MsgBox(32 + 3, "Finish", "Would you like to remove the setup files?" & @CRLF & @CRLF & $tempdir & " (" & Round(DirGetSize($tempdir) / 1024 / 1024, 2) & " MB)") = 6 Then
;~ 					DirRemove($tempdir, 1)
;~ 				EndIf
					Exit
				EndIf
			ElseIf $exit = 2 Then
				DirRemove($TEMP, 1)
				Exit
			Else
				GUICtrlSetState($label2, $GUI_SHOW)
				GUICtrlSetPos($label1, $textL, $textT, 740, 30)
				_GUICtrlListView_SetColumn($hListBox, 0, "Filename")
				_GUICtrlListView_SetColumn($hListBox, 1, "Size (KB)")
				_GUICtrlListView_SetColumn($hListBox, 2, "Progress (%)")
				_GUICtrlListView_SetColumn($hListBox, 3, "Status")
				_GUICtrlListView_SetColumnWidth($hListBox, 1, 100)
				_GUICtrlListView_SetColumnWidth($hListBox, 2, $LVSCW_AUTOSIZE_USEHEADER)
				_GUICtrlListView_SetColumnWidth($hListBox, 3, 70)
				_GUICtrlListView_SetColumnWidth($hListBox, 4, 70)
				_GUICtrlListView_SetColumnWidth($hListBox, 5, 70)
				AdlibRegister("_getmessage", 100)
				GUICtrlSetState($but1, $GUI_DISABLE)
				GUICtrlSetData($label1, "Preparing download...")
				_Debug('GUICtrlSetData($label1, "Preparing download...")', $label1)
				GUICtrlSetState($Progress1, $GUI_SHOW)
				_Debug('GUICtrlSetState($Progress1, $GUI_SHOW)', $Progress1)
				For $n = 0 To $inmax
					$percent = ($n / $inmax * 100)
					GUICtrlSetData($Progress1, $percent)
					GUICtrlSetData($label2, Round($n / $inmax * 100) & " %")
					$afile = StringSplit(FileReadLine($checkfile, $n + 1), '=')

					$crcinfile[$n] = StringStripWS($afile[2], 3)
					$urlfile[$n] = StringStripWS(StringReplace($afile[1], '\', '/'), 3)
					$FileDir[$n] = StringStripWS($afile[1], 3)
					$sfile = $tempdir & '\' & $version & '\' & $afile[1] ;$sfile = $setuppath & '\RapidStudioInstall' & '\' & FileReadLine($checkfile, $i)
					$FileString = StringStripWS($sfile, 3)
					$FileName[$n] = StringStripWS($afile[1], 3)
					If @error Then _Debug("Preparing Download: File " & $n & " of " & $inmax, $FileName[$n])
					$dirarray = StringSplit($FileString, "\")
					$vMax = $dirarray[0]
					$dir = ''
					For $v = 1 To $vMax - 1
						$dir &= $dirarray[$v] & '\'
					Next
					If FileExists($dir) = False Then
						DirCreate($dir)
						If @error Then _Debug("Dircreate($dir)", $dir)
					EndIf
					$Target[$n] = $tempdir & '\' & $version & "\" & $FileName[$n]
				Next
				GUICtrlSetData($label2, 0)
				_GUICtrlListView_SetColumnWidth($hListBox, 0, 300)
				GUICtrlSetState($hListBox, $GUI_SHOW)
				_Debug("GUICtrlSetState($hListBox, $GUI_SHOW)", $hListBox)
				GUICtrlSetState($but1, $GUI_HIDE)
				_Debug("GUICtrlSetState($but1, $GUI_HIDE)", $but1)
				GUICtrlSetState($shadow, $GUI_HIDE)
				_Debug("GUICtrlSetState($shadow, $GUI_HIDE)", $shadow)

				$var = DirGetSize($tempdir & '\' & $version)
				If Round($var / 1024 / 1024) > 40 Then ;if dirsize is bigger than 40MB
					_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
					_Debug("_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))", $hListBox)
					_CRC_Check()
				Else
					GUICtrlSetData($label1, "Downloading files...")
					_Debug("GUICtrlSetData($label1, 'Downloading files...')", $label1)
					$countDownload = 0
					$next = 4
					For $n = 0 To $next
						$iIndex[$n] = _GUICtrlListView_AddItem($hListBox, $FileDir[$n])
						If @error Then _Debug("_GUICtrlListView_AddItem($hListBox, $FileDir[$n])", $FileDir[$n])
						$hDownloadNo[$n] = _RSMWare_GetData($root & '/' & $version & '/' & $urlfile[$n], $Target[$n])
						$countDownload += 1
					Next
					AdlibRegister("SetProgress", 500)
				EndIf
			EndIf
	EndSwitch
WEnd

Func _Debug($varname, $var)
	FileWriteLine($debugreport, "============================================================================")
	FileWriteLine($debugreport, _DateTimeFormat(_NowCalc(), 0))
;~ 	_DebugReport("message", True)
	If @error Then _DebugReportEx("detail", True)
	_DebugReportVar($varname, $var)

EndFunc   ;==>_Debug

Func _CRC_Check()
;~ 	GUICtrlSetData($label3, "Performing CRC Check...")
	$countCorrupt = 0
	$errorlog = _TempFile($TEMP, "err~", ".txt")
	$fileh = FileOpen($errorlog, 2)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
	AdlibRegister("_getmessage")
	For $n = 0 To $inmax
		$iIndex[$n] = _GUICtrlListView_AddItem($hListBox, $FileDir[$n])
		GUICtrlSetData($Progress1, $n / $inmax * 100)
		GUICtrlSetData($label2, Round($n / $inmax * 100, 2) & " %")
		GUICtrlSetData($label1, "Checking " & $n & " of " & $inmax)
		$CRC32 = 0
		$FileHandle = FileOpen($Target[$n], 16)
		If @error Then _Debug('FileOpen($Target[n])' & '(' & $n & ')', $Target[$n])
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], "Checking", 3)
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], Round(FileGetSize($Target[$n]) / 1024, 2) & ' KB', 1)
		If $n > 13 Then _GUICtrlListView_Scroll($hListBox, 0, 10000)
		For $ii = 1 To Ceiling(FileGetSize($Target[$n]) / $BufferSize)
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], Round($ii / Ceiling(FileGetSize($Target[$n]) / $BufferSize) * 100) & "%", 2)
			$Data = FileRead($FileHandle, $BufferSize)
			$CRC32 = _CRC32($Data, BitNOT($CRC32))
		Next

		FileClose($FileHandle)
		$CRCTarget[$n] = Hex($CRC32, 8)
		If $crcinfile[$n] = $CRCTarget[$n] Then
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], "Passed", 3)
		Else
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], "Corrupt", 3)
			_Debug('Corrupt' & '(' & $n & '): ', $Target[$n])
			$countCorrupt += 1

			FileWriteLine($fileh, $FileName[$n] & "=" & $crcinfile[$n])
		EndIf
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], $CRCTarget[$n], 4)
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], $crcinfile[$n], 5)

	Next
	Sleep(1000)
	If $countCorrupt = 0 Then
;~ 		MsgBox(0,"error check","$countCorrupt = " $countCorrupt)
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
;~ 		MsgBox(0,"error check","items deleted after CRC check " & @CRLF & "$countcorrupt = " &  $countCorrupt)
		GUICtrlSetData($label1, "CRC Check Complete: " & $countCorrupt & " files corrupt")
;~ 		MsgBox(0,"error check","label1 set after CRC check " & @CRLF & "$countcorrupt = " &  $countCorrupt)
;~ 		MsgBox(0, "", "0 files corrupt.  Continue to setup.")
		AdlibUnRegister("SetProgress")
;~ 		MsgBox(0,"error check",'AdlibUnRegister("SetProgress") after CRC check ' & @CRLF & "$countcorrupt = " &  $countCorrupt)
		AdlibUnRegister("_getmessage")
;~ 		MsgBox(0,"error check",'AdlibUnRegister("_getmessage") after CRC check ' & @CRLF & "$countcorrupt = " &  $countCorrupt)
		$sucess = 1
		GUICtrlSetData($Progress1, 0)
		_CRC_DotNet_Check()
	Else
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
		GUICtrlSetData($label1, "CRC Check Complete: " & $countCorrupt & " files corrupt")
		GUICtrlSetData($label1, "Downloading files...")
		_Download_Files()
		GUICtrlSetData($label3, "")
	EndIf

	FileClose($fileh)
	$checkfile = $errorlog
EndFunc   ;==>_CRC_Check

Func _RSMWare_GetData($url, $Target)
	$var = StringReplace($Target, "C:\TEMP\rsinst\basic", "")
	Local $hDownload = InetGet($url, $Target, 1, 1)
	If @error Then _Debug('Download: ', $var)
	$Timer = _Timer_Init()
;~ 	ConsoleWrite("handle = " & $hDownload & @CRLF)
	Return $hDownload
EndFunc   ;==>_RSMWare_GetData

Func SetProgress()
	Local $state
	For $n = 0 To $inmax
		;If $hDownloadNo[$n] <> 0 Then
		;ConsoleWrite("Get data for handle " & $n & @CRLF)
		$state = InetGetInfo($hDownloadNo[$n]);, -1)
		If @error = 0 Then
			;ConsoleWrite("bytes for " & $n & "= " & $state[0] & @CRLF)
			If $state[0] > 0 Then
				_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], Round($state[0] / 1024) & " / " & Round($state[1] / 1024), 1)
				_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], Round(Ceiling(($state[0] / $state[1]) * 100)) & "%", 2)
				_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], 'Downloading', 3)
			EndIf
			If $state[2] Then
				$hDownloadNo[$n] = 0
				InetClose($hDownloadNo[$n])
				_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], 'Complete', 3)
				_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], "", 4)
				$count += 1
				$next += 1
				GUICtrlSetData($label1, "Done: " & $count & " of " & $zMax)
				GUICtrlSetData($Progress1, $count / $zMax * 100)
				GUICtrlSetData($label2, Round($count / $zMax * 100, 2) & " %")
				If $count = $zMax Then
					AdlibUnRegister("SetProgress")
					AdlibUnRegister("_getmessage")
					GUICtrlSetData($label2, "")
					GUICtrlSetData($label3, "")
					;MsgBox(0, "downloads done", "delete one file")  ;for testing
					_CRC_Check()
				EndIf
				;>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>ADD THE NEXT FILE TO DOWNLOAD TO THE LIST<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<
				If $next - 1 < $inmax Then
					$iIndex[$next] = _GUICtrlListView_AddItem($hListBox, $FileDir[$next])
					If @error Then _Debug('_GUICtrlListView_AddItem($hListBox, $FileDir[$next])', $FileDir[$next])
					$hDownloadNo[$next] = _RSMWare_GetData($root & '/' & $version & '/' & $urlfile[$next], $Target[$next])
				EndIf
				If $next > 13 Then _GUICtrlListView_Scroll($hListBox, 0, 10000)
			EndIf

		EndIf
		;EndIf
	Next

EndFunc   ;==>SetProgress

Func _getmessage()
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			If MsgBox(3 + 48, "Are you sure?", "The download is still in progress." & @CRLF & @CRLF & "Do you really want to exit?") = 6 Then
				AdlibUnRegister("SetProgress")
				GUICtrlSetData($label1, "Cancelling download...")
				For $n = 0 To $next
					$percent = $n / $next * 100
					GUICtrlSetData($Progress1, $percent)
					;If $hDownloadNo[$n] <> 0 Then
					InetClose($hDownloadNo[$n])
					;EndIf
				Next
				AdlibUnRegister("_getmessage")
				DirRemove($TEMP, 1)
				Exit

			EndIf
		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_MINIMIZE)
	EndSwitch
EndFunc   ;==>_getmessage

Func _Download_Files()
	GUICtrlSetData($label3, "Downloading files...")
	$checkfile = $errorlog
;~ 	$var = FileMove($errorlog, $checkfile, 1)
;~ 	ConsoleWrite("Return value for file move (line: 279): " & $var & @CRLF)

	$zMax = _FileCountLines($checkfile)
	_Debug("Downloading files: $zMax = _FileCountlines()", $zMax)
	Dim $hDownloadNo[$zMax]
	$iIndex = 0
	Dim $Target[$zMax]
	Dim $FileDir[$zMax]
	Dim $iIndex[$zMax]
	Dim $urlfile[$zMax]
	Dim $CRCTarget[$zMax]
	Dim $crcinfile[$zMax]
	Dim $FileName[$zMax]
	$inmax = $zMax
	$inmax -= 1
	GUICtrlSetData($label1, "Preparing new checklist for download...")
	_Debug("Preparing new checklist for download...", $inmax)

	For $n = 0 To $inmax
		$percent = ($n / $inmax * 100)
		GUICtrlSetData($Progress1, $percent)

		$afile = StringSplit(FileReadLine($checkfile, $n + 1), '=')
		$crcinfile[$n] = StringStripWS($afile[2], 3)
		$urlfile[$n] = StringStripWS(StringReplace($afile[1], '\', '/'), 3)
		$FileDir[$n] = StringStripWS($afile[1], 3)
		$sfile = $tempdir & '\' & $version & '\' & $afile[1] ;$sfile = $setuppath & '\RapidStudioInstall' & '\' & FileReadLine($checkfile, $i)
		$FileString = StringStripWS($sfile, 3)
		$FileName[$n] = StringStripWS($afile[1], 3)
		$dirarray = StringSplit($FileString, "\")
		$vMax = $dirarray[0]
		$dir = ''
		For $v = 1 To $vMax - 1
			$dir &= $dirarray[$v] & '\'
		Next
		DirCreate($dir)
		$Target[$n] = $tempdir & '\' & $version & "\" & $FileName[$n]
	Next
	GUICtrlSetData($label1, "Downloading files...")
	$countDownload = 0
	$count = 0
	If $inmax > 1 Then
		If $inmax > 4 Then
			$next = 4
		Else
			$next = $inmax
		EndIf
		For $n = 0 To $next
			$iIndex[$n] = _GUICtrlListView_AddItem($hListBox, $FileDir[$n])
			$hDownloadNo[$n] = _RSMWare_GetData($root & '/' & $version & '/' & $urlfile[$n], $Target[$n])
			$countDownload += 1
		Next
	Else
		$n = 0
		$iIndex[$n] = _GUICtrlListView_AddItem($hListBox, $FileDir[$n])
		$hDownloadNo[$n] = _RSMWare_GetData($root & '/' & $version & '/' & $urlfile[$n], $Target[$n])
		$countDownload += 1
	EndIf

	AdlibRegister("SetProgress", 500)
EndFunc   ;==>_Download_Files

Func SetProgressDotnet()
	$state = InetGetInfo($hDownload)
	If @error = 0 Then
		If $state[0] > 0 Then
			$calc = Int(100 * $state[0] / $state[1])
			$speed = Round(($state[0] / 1024 * 8) / (_Timer_Diff($Timer) / 1000))
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], $speed & " Kbs", 4)
			GUICtrlSetData($Progress1, Ceiling(($state[0] / $state[1] * 100)))
			GUICtrlSetData($label2, Round(Ceiling(($state[0] / $state[1] * 100))) & ' %')
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], Round($state[0] / 1024 / 1024, 2) & " / " & Round($state[1] / 1024 / 1024, 2), 1)
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], Round(Ceiling(($state[0] / $state[1]) * 100), 2) & "%", 2)
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], 'In Progress', 3)
			#Region -> Progress (percentage) & Time Left (hr, min, sec)
			$diff = TimerDiff($Timer)
			$stimeleft = "Calculating..."
			If $diff > 3000 Then
				$stimeleft = "Calculating..."
				If $calc > 0 Then
					$timeleft = Round((($diff / $calc * 100) - $diff) / 1000)
					If $timeleft > 60 Then
						$frac = $timeleft / 60
						$afrac = StringSplit($frac, ".")
						If $afrac[0] > 1 Then
							$min = $afrac[1]
							$sec = StringLeft($afrac[2], 2)
							$sec = Round($sec / 100 * 60)
						Else
							$min = $frac
							$sec = 0
						EndIf
						$stimeleft = $min & "m " & $sec & "s"
						If $min > 60 Then
							$frac = $min / 60
							$afrac = StringSplit($frac, ".")
							If $afrac[0] > 1 Then
								$hour = $afrac[1]
								$min = StringLeft($afrac[2], 2)
								$min = Round($min / 100 * 60)
							Else
								$hour = $frac
								$min = 0
							EndIf
							$stimeleft = $hour & "h " & $min & "m " & $sec & "s"
						EndIf
					Else
						$stimeleft = $timeleft & "s"
					EndIf
				Else
					$timeleft = '....'
				EndIf
			Else
				$stimeleft = "Calculating..."
			EndIf

			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], $stimeleft, 5)
			#EndRegion -> Progress (percentage) & Time Left (hr, min, sec)
		EndIf
		If $state[2] Then
			InetClose($hDownload)
			AdlibUnRegister("SetProgressDotnet")
			GUICtrlSetData($label2, "")
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
			_CRC_DotNet_Check()
		EndIf

	Else
		MsgBox(0, "Error", "InetGetInfo error: " & @error)
	EndIf
EndFunc   ;==>SetProgressDotnet

Func _CRC_DotNet_Check()
	GUICtrlSetData($label1, "Performing CRC Check (dotnet2.0.exe)...")
;~ 	MsgBox(0, "errorcheck", "$FileNameDotnet = " & $FileNameDotnet)
;~ 	MsgBox(0, "errorcheck", "iindex[0] = " & $iIndex[0])

	$iIndex[0] = _GUICtrlListView_AddItem($hListBox, $FileNameDotnet)
	If $iIndex = -1 Then MsgBox(0, "errorcheck", "Item not added")
	_GUICtrlListView_SetColumnWidth($hListBox, 0, $LVSCW_AUTOSIZE)
	$CRC32 = 0
	$FileHandle = FileOpen($TargetDotnet, 16)
	_GUICtrlListView_SetColumn($hListBox, 1, 'Size (MB)')
	_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], Round(FileGetSize($TargetDotnet) / 1024 / 1024, 2) & ' MB', 1)
	_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], "Checking", 3)
	For $ii = 1 To Ceiling(FileGetSize($TargetDotnet) / $BufferSize)
		Sleep(10)
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], Round($ii / Ceiling(FileGetSize($TargetDotnet) / $BufferSize) * 100) & "%", 2)
		GUICtrlSetData($Progress1, $ii / Ceiling(FileGetSize($TargetDotnet) / $BufferSize) * 100)
		GUICtrlSetData($label2, Round($ii / Ceiling(FileGetSize($TargetDotnet) / $BufferSize) * 100) & " %")
		$Data = FileRead($FileHandle, $BufferSize)
		$CRC32 = _CRC32($Data, BitNOT($CRC32))
	Next

	FileClose($FileHandle)
	$CRCTarget = Hex($CRC32, 8)
	If $crcDotnet = $CRCTarget Then
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], "Passed", 3)
		Sleep(2000)
		GUICtrlSetData($label2, "")
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
		$fileno = 1
		_Support($fileno)
	Else
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], "Corrupt", 3)
		GUICtrlSetData($label2, "")
		_Dotnet()
	EndIf

EndFunc   ;==>_CRC_DotNet_Check

Func _Dotnet()
	GUICtrlSetData($label1, "Checking dotnet...")
	_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], "Checking", 3)
	Local $skipdotnet = 0
	#Region .Net (dotnet)
	$dotnet = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5', 'Version')
	If @error Then
		$dotnet = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0', 'Version')
		If @error Then
			$dotnet = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727', 'Version')
			If @error Then
				;MsgBox(0, "dotnet", ".Net will be downloaded.") ;for testing
				GUICtrlSetData($label1, "Downloading " & $FileNameDotnet & "...")
				$hDownload = _RSMWare_GetData($root & '/' & $version & '/' & $urlDotnet, $TargetDotnet)
				_GUICtrlListView_SetColumn($hListBox, 4, 'Speed (Kb / second)')
				_GUICtrlListView_SetColumn($hListBox, 5, 'Time left (approx)')
				_GUICtrlListView_SetColumnWidth($hListBox, 4, $LVSCW_AUTOSIZE_USEHEADER)
				_GUICtrlListView_SetColumnWidth($hListBox, 5, $LVSCW_AUTOSIZE_USEHEADER)
				AdlibRegister("SetProgressDotnet", 100)
				$skipdotnet = 0
			Else
				GUICtrlSetData($label1, ".Net 2.0 found")
				$skipdotnet = 1
				;MsgBox(0, "dotnet", ".Net will NOT be downloaded!!! VERSION 2.0 installed") ;for testing
			EndIf
		Else
			GUICtrlSetData($label1, ".Net 3.0 found")
			$skipdotnet = 1
			;MsgBox(0, "dotnet", ".Net will NOT be downloaded!!! VERSION 3.0 installed") ;for testing
		EndIf
	Else
		GUICtrlSetData($label1, ".Net 3.5 found")
		$skipdotnet = 1
		;MsgBox(0, "dotnet", ".Net will NOT be downloaded!!! VERSION 3.5 Installed") ;for testing
	EndIf
	;ConsoleWrite(@CRLF & 'Testing dotnet result = ' & $dotnet & @CRLF & "Error Code = " & @error & @CRLF & @CRLF)
	If $skipdotnet = 1 Then
		Sleep(2000)
		$fileno = 1
		_Support($fileno)
	EndIf
	#EndRegion .Net (dotnet)

EndFunc   ;==>_Dotnet

Func _Support($fileno)
	GUICtrlSetData($label1, "Downloading and installing additional support applications...")
	GUICtrlSetData($Progress1, 0)
	If $fileno = 1 Then
		$FileName = $FileNameUpdater
	ElseIf $fileno = 2 Then
		$FileName = $FileNameVars
	EndIf
	GUICtrlSetData($label1, "Downloading " & $FileName & "...")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
	$iIndex[0] = _GUICtrlListView_AddItem($hListBox, $FileName)
	_GUICtrlListView_SetColumnWidth($hListBox, 0, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumn($hListBox, 4, 'Speed (Kb / second)')
	_GUICtrlListView_SetColumn($hListBox, 5, 'Time left (approx)')
	_GUICtrlListView_SetColumnWidth($hListBox, 4, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth($hListBox, 5, $LVSCW_AUTOSIZE_USEHEADER)
	If $fileno = 1 Then
		$Target = $TargetUpdater
		$hDownload = _RSMWare_GetData($root & '/config/support_autosetup.exe', $Target)
	ElseIf $fileno = 2 Then
		$Target = $TargetVars
		$hDownload = _RSMWare_GetData($root & '/config/VarsUpdate.exe', $Target)
	EndIf
	AdlibRegister("SetProgressSupport", 100)
EndFunc   ;==>_Support

Func SetProgressSupport()
	$state = InetGetInfo($hDownload)
	If @error = 0 Then
		If $state[0] > 0 Then
			$calc = Int(100 * $state[0] / $state[1])
			$speed = Round(($state[0] / 1024 * 8) / (_Timer_Diff($Timer) / 1000))
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], $speed & " Kbs", 4)
			GUICtrlSetData($Progress1, Ceiling(($state[0] / $state[1] * 100)))
			GUICtrlSetData($label2, Round(Ceiling(($state[0] / $state[1] * 100))) & ' %')
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], Round($state[0] / 1024 / 1024, 2) & " / " & Round($state[1] / 1024 / 1024, 2), 1)
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], Round(Ceiling(($state[0] / $state[1]) * 100), 2) & "%", 2)
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], 'In Progress', 3)
			#Region -> Progress (percentage) & Time Left (hr, min, sec)
			$diff = TimerDiff($Timer)
			$stimeleft = "Calculating..."
			If $diff > 3000 Then
				$stimeleft = "Calculating..."
				If $calc > 0 Then
					$timeleft = Round((($diff / $calc * 100) - $diff) / 1000)
					If $timeleft > 60 Then
						$frac = $timeleft / 60
						$afrac = StringSplit($frac, ".")
						If $afrac[0] > 1 Then
							$min = $afrac[1]
							$sec = StringLeft($afrac[2], 2)
							$sec = Round($sec / 100 * 60)
						Else
							$min = $frac
							$sec = 0
						EndIf
						$stimeleft = $min & "m " & $sec & "s"
						If $min > 60 Then
							$frac = $min / 60
							$afrac = StringSplit($frac, ".")
							If $afrac[0] > 1 Then
								$hour = $afrac[1]
								$min = StringLeft($afrac[2], 2)
								$min = Round($min / 100 * 60)
							Else
								$hour = $frac
								$min = 0
							EndIf
							$stimeleft = $hour & "h " & $min & "m " & $sec & "s"
						EndIf
					Else
						$stimeleft = $timeleft & "s"
					EndIf
				Else
					$timeleft = '....'
				EndIf
			Else
				$stimeleft = "Calculating..."
			EndIf
			_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], $stimeleft, 5)
			#EndRegion -> Progress (percentage) & Time Left (hr, min, sec)
			If $state[2] Then
				InetClose($hDownload)
				AdlibUnRegister("SetProgressSupport")
				GUICtrlSetData($label2, "")
				_GUICtrlListView_AddSubItem($hListBox, $iIndex[0], 'Complete', 3)
				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
				If $fileno = 1 Then
					RunWait($TargetUpdater)
					$fileno = 2
					_Support($fileno)
				ElseIf $fileno = 2 Then
					_Setup()
				EndIf
			EndIf
		EndIf
	Else
		MsgBox(0, "Error", "InetGetInfo error: " & @error)
	EndIf
EndFunc   ;==>SetProgressSupport

Func _Setup()
	GUICtrlSetState($hListBox, $GUI_HIDE)
	GUICtrlSetPos($label1, $textL, $textT, 740, 200)
	GUICtrlDelete($label2)
	GUICtrlSetData($label1, "Running Setup..." & @CRLF & "Please follow the prompts in the setup wizard to install RapidStudio.")
	GUICtrlSetState($Progress1, $GUI_HIDE)
	_GUICtrlListView_SetColumn($hListBox, 0, "")
	_GUICtrlListView_SetColumn($hListBox, 1, "")
	_GUICtrlListView_SetColumn($hListBox, 2, "")
	_GUICtrlListView_SetColumn($hListBox, 3, "")
	_GUICtrlListView_SetColumn($hListBox, 4, "")
	_GUICtrlListView_SetColumn($hListBox, 5, "")
	Run($tempdir & '\' & $version & '\Setup.exe', $tempdir & '\' & $version)
	_Debug('Run($tempdir & "\" & $version & "\Setup.exe", $tempdir & "\" & $version)', $tempdir)
	WinSetState("RapidStudio Setup", "", @SW_MINIMIZE) ;= Minimize window
	WinSetState("RapidStudio Setup", "", @SW_RESTORE) ;= Undoes a window minimization or maximization
	WinSetOnTop("RapidStudio Setup", "", 1) ;= Change a window's "Always On Top" attribute. *** 1 = set on top flag ***
	Run($TargetVars)
	_Debug('Run($TargetVars): ', $TargetVars)
	AdlibRegister("_SetupWait", 100)
EndFunc   ;==>_Setup

Func _SetupWait()
	GUICtrlSetPos($label1, $textL, $textT, 740, 150)
	If ProcessExists($FileNameVars) Then
		GUISetState(@SW_DISABLE)
		If Not (ProcessExists("Setup.exe")) Then
			If Not ($msg = "Running UpdateVars.exe" & @CRLF & "Please be patient. We're almost done.") Then
				$msg = "Running UpdateVars.exe" & @CRLF & "Please be patient. We're almost done."
				GUICtrlSetData($label1, $msg)
				GUISetState(@SW_MINIMIZE)
				GUISetState(@SW_RESTORE)
			EndIf
		EndIf
	Else
		GUISetState(@SW_ENABLE)
		_RegRead()
		If $regerror = 0 Then

			GUICtrlSetState($label1, $GUI_HIDE)
			$msg = "Success!" & @CRLF & "It seems RapidStudio Album Maker was downloaded and installed successfully." & @CRLF & @CRLF & _
					"If RapidStudio did not install properly or if you experienced any problems during this download and install, please contact our support agents." & @CRLF & @CRLF & @CRLF & @CRLF & _
					'Would you like to delete the setup files from the temp directory?  Tick the "Delete Setup Files" checkbox before clicking the "Finish" button.' & @CRLF & _
					$tempdir & " (" & Round(DirGetSize($tempdir) / 1024 / 1024, 2) & " MB)"
			GUICtrlSetData($label1, $msg)
			GUICtrlSetState($label1, $GUI_SHOW)
			GUICtrlSetState($chk, $GUI_SHOW)
			$exit = 1
		ElseIf $regerror = 1 Then
			GUICtrlSetState($label1, $GUI_HIDE)
			$msg = "Error!" & @CRLF & "It seems RapidStudio Album Maker failed to install." & @CRLF & @CRLF & _
					"Please run this application again to correct the error.  NOTE: The downloader will NOT overwrite the files already downloaded unless the files are corrupt.  " & _
					"Only the missing/corrupt files will be downloaded if you run this Install Downloader again." & @CRLF & @CRLF & _
					"If the problem persists, please contact our support agents."
			GUICtrlSetData($label1, $msg)
			GUICtrlSetState($label1, $GUI_SHOW)
			ProcessClose("VarsUpdate.exe")
			$exit = 2
		EndIf
		GUICtrlSetData($but1, "Finish")
		GUICtrlSetImage($but1, $TEMP & '\finish-1.ico')
		GUICtrlSetState($but1, $GUI_SHOW)
		GUICtrlSetState($shadow, $GUI_SHOW)
		GUICtrlSetState($but1, $GUI_ENABLE)
		AdlibUnRegister("_SetupWait")
	EndIf
EndFunc   ;==>_SetupWait

Func _RegRead()
	RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RapidStudio_RapidStudio", "")
	If @error > 0 Then
		;Key does not exist
;~ 		MsgBox(48, "Error", "Oops! It looks like there was a problem with the installation.")
		$regerror = 1
	Else
		;Key does exist
		$regerror = 0
	EndIf
	Return $regerror
EndFunc   ;==>_RegRead

Func _DeleteFiles()
	GUICtrlSetPos($label1, $textL, $textT, 740, 15)
	GUICtrlSetData($label1, "Preparing to delete setup files...")
	GUICtrlSetState($Progress1, $GUI_SHOW)
	GUICtrlSetData($Progress1, 0)
	GUICtrlSetData($but1, "&Cancel")
	GUICtrlSetState($hListBox, $GUI_SHOW)
	_GUICtrlListView_SetColumn($hListBox, 0, "Filename")
	_GUICtrlListView_SetColumn($hListBox, 1, "Size (KB)")
	_GUICtrlListView_SetColumn($hListBox, 2, "")
	_GUICtrlListView_SetColumn($hListBox, 3, "Status")
	_GUICtrlListView_SetColumnWidth($hListBox, 1, 100)
	_GUICtrlListView_SetColumnWidth($hListBox, 0, 200)
	_GUICtrlListView_SetColumnWidth($hListBox, 3, 70)
	_GUICtrlListView_SetColumnWidth($hListBox, 4, 70)
	_GUICtrlListView_SetColumnWidth($hListBox, 5, 70)
	$fileh = FileOpen($dirlist, 2)
	FileClose($fileh)
	_RunDOS('dir "' & $tempdir & '" /B /D /S /A:-D  >> "' & $dirlist & '"')
	_FileReadToArray($dirlist, $array)
	GUICtrlSetData($label1, "Deleting setup files...")
	$iMax = $array[0]
	Dim $iIndex[$iMax]
	For $i = 0 To $iMax - 1
		$calc = $i / $iMax * 100
		GUICtrlSetData($label2, Round($calc, 2) & ' %')
		$iIndex[$i] = _GUICtrlListView_AddItem($hListBox, $array[$i + 1])
		GUICtrlSetData($Progress1, $calc)
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$i], "Deleting", 3)
		FileDelete($array[$i + 1])
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$i], "Done", 3)
		If $i > 13 Then _GUICtrlListView_Scroll($hListBox, 0, 10000)
	Next
	DirRemove($tempdir, 1)
	DirRemove($TEMP, 1)
	GUICtrlSetData($label1, "Done deleting setup files...")
	Exit
EndFunc   ;==>_DeleteFiles