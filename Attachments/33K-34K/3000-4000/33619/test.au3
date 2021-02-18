#include <GUIConstants.au3>
#include <_CRC.au3>
#include <File.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Date.au3>

Local $hGUI = GUICreate('Download File', 800, 370)
;Local $Progress = GUICtrlCreateProgress(10, 10, 780, 20)

DirCreate(@TempDir & '\RS Media Manager\')

GUISetState()

#Region -> Create Temp Dir
Local $string = _TempFile(@TempDir, "rsinst~", "", 5)
Local $array = StringSplit($string, ".")
Local $TEMP = $array[1]
DirCreate($TEMP)
Local $tempdir = 'C:\Temp\rsinst'
#EndRegion -> Create Temp Dir

#Region -> Declare files & Variables
Local $root = "http://hosted01.rapidstudio.co.za/RSInstall"
$version = 'basic'
$checkfile = $TEMP & '\CRC_' & $version & '.txt'
Global $BufferSize = 0x20000
Global $Timer = TimerInit()
Global $CRC32 = 0, $CRC16 = 0
Global $Data
$tCur = _Date_Time_GetSystemTime()
$tStr = _Date_Time_SystemTimeToDateTimeStr($tCur, 1)
$tStr = StringReplace($tStr, ":", "")
$tStr = StringReplace($tStr, "/", "")
$tStr = StringReplace($tStr, " ", "")
$errorlog = @DesktopDir & "\errorlog_" & $tStr & '.txt'
$countCorrupt = 0
#EndRegion -> Declare files & Variables

#Region -> Get CRC Checkfile
; Call crc_check.php page and write response to a file CRC_basic.txt
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET", "http://www.rapidstudio.info/fran/crc_check.php")
$oHTTP.Send()
$HTMLSource = $oHTTP.Responsetext
$aSource = StringSplit($HTMLSource, ",")
$afile = $checkfile
$aFileh = FileOpen($afile, 2)
FileWrite($afile, $HTMLSource)
FileClose($aFileh)
#EndRegion -> Get CRC Checkfile

#Region -> Get url and target filestring
For $i = 1 To 20
	$afile = StringSplit(FileReadLine($checkfile, $i), '=')
	$urlfile = StringStripWS(StringReplace($afile[1], '\', '/'), 3)
	$sfile = $tempdir & '\' & $version & '\' & $afile[1] ;$sfile = $setuppath & '\RapidStudioInstall' & '\' & FileReadLine($checkfile, $i)
	$FileString = StringStripWS($sfile, 3)
	$FileName = StringStripWS($afile[1], 3)
Next
#EndRegion -> Get url and target filestring




$count = 0
$zMax = 20
$zMax = _FileCountLines($checkfile)
Dim $hDownloadNo[$zMax];say we want up to 10 downloads. We can increase with ReDim if needed
$iIndex = 0
Dim $Progress[$zMax];could be progress bars but for this example just make them edits
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

;~ $hListBox = GUICtrlCreateList("", 2, 2, 396, 296, BitOR($WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY, $LBS_DISABLENOSCROLL, $WS_HSCROLL))
$hListBox = GUICtrlCreateListView("Filename | Size (KB) | Progress(%) | Status | | ", 2, 52, 796, 296, $LVS_NOSORTHEADER)
GUICtrlSetState(-1, $GUI_HIDE)
_GUICtrlListView_SetColumnWidth($hListBox, 1, 100)
_GUICtrlListView_SetColumnWidth($hListBox, 2, 50)
_GUICtrlListView_SetColumnWidth($hListBox, 3, 70)
_GUICtrlListView_SetColumnWidth($hListBox, 4, 70)
_GUICtrlListView_SetColumnWidth($hListBox, 5, 70)

AdlibRegister("_getmessage", 100)

;~ If $inmax < 0 Then $inmax = 0
;~ If $inmax > 9 Then $inmax = 20

$label1 = GUICtrlCreateLabel("Preparing download...", 15, 15, 300, 15)
$Progress1 = GUICtrlCreateProgress(15, 30, 300, 17)
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

_GUICtrlListView_SetColumnWidth($hListBox, 0, 300)
GUICtrlSetState($hListBox, $GUI_SHOW)


$var = DirGetSize($tempdir & '\' & $version)
If Round($var / 1024 / 1024) > 40 Then ;if dirsize is bigger than 40MB
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
	_CRC_Check()
Else
	GUICtrlSetData($label1, "Downloading files...")
	$countDownload = 0
	$next = 4
	For $n = 0 To $next
		$iIndex[$n] = _GUICtrlListView_AddItem($hListBox, $FileDir[$n])
		$hDownloadNo[$n] = _RSMWare_GetData($root & '/' & $version & '/' & $urlfile[$n], $Target[$n])
		$countDownload += 1
	Next
	AdlibRegister("SetProgress", 500)
EndIf



While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			AdlibUnRegister("SetProgress")
			GUICtrlSetData($label1, "Cancelling download...")
			For $n = 0 To $next
				$percent = $n / $next * 100
				GUICtrlSetData($Progress1, $percent)
;~ 					If $hDownloadNo[$n] <> 0 Then
						InetClose($hDownloadNo[$n])
;~ 					EndIf
			Next
			AdlibUnRegister("_getmessage")
			Exit
	EndSwitch
WEnd

Func _CRC_Check()
	GUICtrlSetData($label1, "Performing CRC Check...")
	$countCorrupt = 0
	$fileh = FileOpen($errorlog, 1)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
	For $n = 0 To $inmax
		$iIndex[$n] = _GUICtrlListView_AddItem($hListBox, $FileDir[$n])
		GUICtrlSetData($Progress1, $n / $inmax * 100)
		$CRC32 = 0
		$FileHandle = FileOpen($Target[$n], 16)
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], "Checking", 3)
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
			$countCorrupt += 1

			FileWriteLine($fileh, $FileName[$n] & "=" & $crcinfile[$n])
		EndIf
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], $CRCTarget[$n], 4)
		_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], $crcinfile[$n], 5)

	Next
	Sleep(1000)
	If $countCorrupt = 0 Then
		MsgBox(0, "", "0 files corrupt.  Continue to setup.")
		AdlibUnRegister("SetProgress")
	Else
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListBox))
		GUICtrlSetData($label1, "Downloading files...")
		_Download_Files()
	EndIf

	GUICtrlSetData($label1, "CRC Check Complete: " & $countCorrupt & " files corrupt")
	FileClose($fileh)
EndFunc   ;==>_CRC_Check

Func _RSMWare_GetData($url, $Target)
	Local $hDownload = InetGet($url, $Target, 1, 1)
	ConsoleWrite("handle = " & $hDownload & @CRLF)
	Return $hDownload
EndFunc   ;==>_RSMWare_GetData

Func SetProgress()
	Local $state
	For $n = 0 To $inmax
		If $hDownloadNo[$n] <> 0 Then
			ConsoleWrite("Get data for handle " & $n & @CRLF)
			$state = InetGetInfo($hDownloadNo[$n]);, -1)
			If @error = 0 Then
				ConsoleWrite("bytes for " & $n & "= " & $state[0] & @CRLF)
				If $state[0] > 0 Then
					_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], Round($state[0] / 1024) & " / " & Round($state[1] / 1024), 1)
					_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], Round(Ceiling(($state[0] / $state[1]) * 100)) & "%", 2)
					_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], 'In Progress', 3)
				EndIf
;~ 				GUICtrlSetData($Progress[$n], Ceiling(($state[0] / $state[1]) * 100))
				If $state[2] Then
					$hDownloadNo[$n] = 0
					InetClose($hDownloadNo[$n])
					_GUICtrlListView_AddSubItem($hListBox, $iIndex[$n], 'Complete', 3)
					$count += 1
					$next += 1
					GUICtrlSetData($label1, "Done: " & $count & " of " & $zMax)
					GUICtrlSetData($Progress1, $count / $zMax * 100)
					If $count = $zMax Then
						AdlibUnRegister("SetProgress")
						AdlibUnRegister("_getmessage")
						MsgBox(0,"downloads done", "delete one file")
						_CRC_Check()
					EndIf
					;>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>ADD THE NEXT FILE TO DOWNLOAD TO THE LIST<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<
					If $next - 1 < $inmax Then
						$iIndex[$next] = _GUICtrlListView_AddItem($hListBox, $FileDir[$next])
						$hDownloadNo[$next] = _RSMWare_GetData($root & '/' & $version & '/' & $urlfile[$next], $Target[$next])
					EndIf
					If $next > 13 Then _GUICtrlListView_Scroll($hListBox, 0, 10000)
				EndIf

			EndIf
		EndIf
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
					If $hDownloadNo[$n] <> 0 Then
						InetClose($hDownloadNo[$n])
						FileDelete($Target[$n])
					EndIf
				Next
				AdlibUnRegister("_getmessage")
				Exit

			EndIf
		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_MINIMIZE)
	EndSwitch
EndFunc   ;==>_getmessage

Func _Download_Files()
	FileMove($errorlog, $checkfile, 1)
	$zMax = _FileCountLines($checkfile)
	Dim $hDownloadNo[$zMax]
	$iIndex = 0
	Dim $Progress[$zMax]
	Dim $Target[$zMax]
	Dim $FileDir[$zMax]
	Dim $iIndex[$zMax]
	Dim $urlfile[$zMax]
	Dim $CRCTarget[$zMax]
	Dim $crcinfile[$zMax]
	Dim $FileName[$zMax]
	$inmax = $zMax
	$inmax -= 1
	$label1 = GUICtrlCreateLabel("Preparing new checklist for download...", 15, 15, 300, 15)
	$Progress1 = GUICtrlCreateProgress(15, 30, 300, 17)

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

	AdlibRegister("SetProgress", 500)
EndFunc   ;==>_Download_Files