#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\_resources\images\App_installer.ico
#AutoIt3Wrapper_Outfile=InstallDownloader.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=RapidStudio Install Downloader
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=© Copyright, RapidStudio 2010
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #AutoIt3Wrapper_Run_After=""C:\Program Files\Microsoft SDKs\Windows\v7.0\Bin\signtool.exe" sign /a /t http://timestamp.comodoca.com/authenticode "%out%""
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.3.6.1
	Author:         Francisca Carstens
	
	Script Function:
	Download all installation files and launch setup.
	
	
	
#ce ----------------------------------------------------------------------------
#Region -> Includes
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <GuiStatusBar.au3>
#include <Timers.au3>
#include <GuiButton.au3>
#include <_CRC.au3>
#include <File.au3>
#include <Process.au3>
#include <ProgressConstants.au3>
#EndRegion -> Includes

#Region -> Options
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 2)
Opt("TrayIconDebug", 1)
Opt("MustDeclareVars", 1)
#EndRegion -> Options
If _Singleton("InstallDownloader", 1) = 0 Then Exit ;make sure only one copy of the script is running


#Region -> Declarations & GUI
Local $textL = 30, $progW = 500
Local $string = _TempFile(@TempDir, "rsinst~", "", 5)
Local $array = StringSplit($string, ".")
Local $TEMP = $array[1]
DirCreate($TEMP)

Local $StatusBar, $hDownload, $nBytes, $nRead, $nSize, $calc, $speed, $ProgressDownload, $stop, $file, $starttime, $step, $StatusBar, $progressbar0, $progressbar2, $progressbar3, $progressbar, $Progress, $url
Local $goto = 2
Local $version = 'basic'
Local $hGUI = GUICreate("Install Downloader", 615, 360, -1, -1)
GUISetBkColor(0x000000)
GUICtrlSetDefColor(0xffffff)
$StatusBar = _GUICtrlStatusBar_Create($hGUI)
Local $label1 = GUICtrlCreateLabel('Click the "Continue" button to download the installation files for RapidStudio Album Maker.', $textL, 15 + 50, 555, 50)
Local $label2 = GUICtrlCreateLabel("", $textL, 125, 470, 30)
Local $label3 = GUICtrlCreateLabel("", $textL, 165, 470, 15)
Local $label4 = GUICtrlCreateLabel("", 543, 145, 50, 15)
Local $label5 = GUICtrlCreateLabel("", 543, 185, 50, 15)
Local $label6 = GUICtrlCreateLabel("", 5, 320, 100, 15)
GUICtrlSetColor(-1, 0x333333)
Local $label7 = GUICtrlCreateLabel("", $textL, 205, 470, 15)
Local $label8 = GUICtrlCreateLabel("", 543, 225, 50, 15)
Local $but1 = GUICtrlCreateButton("Continue", 485, 260, 100, 50)
GUICtrlSetBkColor(-1, 0xffffff)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreatePic($TEMP & '\button-shadow.jpg', 486, 310, 98, 24)
Local $tempdir = 'C:\Temp\rsinst'
Local $root = "http://hosted01.rapidstudio.co.za/RSInstall"
Global $BufferSize = 0x20000
Global $Timer = TimerInit()
Global $CRC32 = 0, $CRC16 = 0
Global $Data
;~ Local $skipdotnet = 0

Local $checkfile = $TEMP & '\CRC_' & $version & '.txt', $supportEXE = $TEMP & '\support_autosetup.exe', $varsEXE = $TEMP & '\VarsUpdate.exe', $dirlist = $TEMP & '\dirlist.txt', $findlist = $TEMP & '\findlist.txt', $errorlog = $TEMP & '\errorlog.txt', $ini = $TEMP & '\params.ini'
Local $fileh, $errorlogh, $inih, $checkhandle, $begin, $retry, $dirsize, $afile, $urlfile, $sfile, $FileString, $FileName, $crcinfile, $dirarray, $dir, $aFileName, $findlisth, $afind, $lineNr, $copySrc, $FileHandle, $CRCCopySrc, $dotnet, $diff, $continue
Local $i, $iMax, $vMax, $n, $continue
Local $oHTTP, $HTMLSource, $aSource, $aFileh, $size_orig
#EndRegion -> Declarations & GUI



TraySetState()
TraySetToolTip("RS Install Downloader")



_Main()

Func _Main()
	GUISetState()
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $but1
				If $goto = 2 Then
					GUICtrlSetData($label1, 'Please wait while the installation files are being downloaded from RapidStudio.  When the download is complete, the installation will be launched automatically.')
					DirCreate($tempdir & '\' & $version)

					Ping("www.google.com", 250)
					If Not (@error = 0) Then
						MsgBox(48, "Error connecting to the internet", "Could not connect to the internet." & @CRLF & "Error Code: " & @error)
						Exit
					EndIf

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

					$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
					$oHTTP.Open("GET", "http://www.rapidstudio.info/fran/downloader_info.php")
					$oHTTP.Send()
					$HTMLSource = $oHTTP.Responsetext
					$aSource = StringSplit($HTMLSource, "=")
					$size_orig = $aSource[2]

					$url = $root & '/config/support_autosetup.exe'
					InetGet($url, $supportEXE, 1, 1)
					$url = $root & '/config/VarsUpdate.exe'
					InetGet($url, $varsEXE, 1, 1)
					$goto = 3
					_GUICtrlButton_Click($but1)
				EndIf

				If $goto = 3 Then
					GUICtrlSetData($progressbar0, 100)
					GUICtrlSetData($label5, "")
					GUICtrlSetState($but1, $GUI_DISABLE)
;~ 					#cs
					#Region - >check & download files
					$fileh = FileOpen($dirlist, 2)
					FileClose($fileh)
					$fileh = FileOpen($findlist, 2)
					FileClose($fileh)
					$errorlogh = FileOpen($errorlog, 2)
					FileClose($errorlogh)
					GUICtrlDelete($progressbar0)
					$checkhandle = FileOpen($checkfile)
					GUICtrlSetData($label2, 'Preparing download...')
					$begin = TimerInit()
					$progressbar = GUICtrlCreateProgress($textL, 100 + 45, $progW, 17, $PBS_SMOOTH)
					_GUICtrlStatusBar_SetText($StatusBar, "Ready")
					$iMax = _FileCountLines($checkfile)
					$retry = 0
					$progressbar2 = GUICtrlCreateProgress($textL, 140 + 45, $progW, 17, $PBS_SMOOTH)
					GUICtrlSetData($label2, 'Overall Progress')
					GUICtrlSetData($progressbar, 0)
					For $i = 1 To $iMax
						$Progress = $i / $iMax * 100
						GUICtrlSetData($progressbar, $Progress)
						GUICtrlSetData($label4, Round($Progress, 2) & " %")
						$dirsize = DirGetSize($tempdir & "\" & $version)
						_GUICtrlStatusBar_SetText($StatusBar, "Processing file: " & $i & ' of ' & $iMax & @TAB & "Done: " & Round($dirsize / 1024 / 1024, 2) & " MB / " & $size_orig & " MB " & @TAB)
						$afile = StringSplit(FileReadLine($checkfile, $i), '=')
						$urlfile = StringStripWS(StringReplace($afile[1], '\', '/'), 3)
						$sfile = $tempdir & '\' & $version & '\' & $afile[1] ;$sfile = $setuppath & '\RapidStudioInstall' & '\' & FileReadLine($checkfile, $i)
						$FileString = StringStripWS($sfile, 3)
						$FileName = StringStripWS($afile[1], 3)
						GUICtrlSetData($label3, "Checking: " & $FileName)
						GUICtrlSetColor($label3, 0x009900)
						$crcinfile = StringStripWS($afile[2], 3)
						_getmessage()
						$CRC32 = 0
						$dirarray = StringSplit($FileString, "\")
						$vMax = $dirarray[0]
						$dir = ''
						For $v = 1 To $vMax - 1
							$dir &= $dirarray[$v] & '\'
						Next
						_getmessage()
						DirCreate($dir)
						If FileExists($FileString) = False Then
							_getmessage()
							;Search for the FileName in the dirlist
							$aFileName = StringSplit($FileName, "\")
							$n = $aFileName[0]

							_RunDOS('find /N /I "' & $aFileName[$n] & '" "' & $dirlist & '" > "' & $findlist & '"')
							$findlisth = FileOpen($findlist)

							If Not (FileReadLine($findlisth, 3) = "") Then ;If a file was found read the line number and find the file in the dirlist
								_getmessage()
								$afind = StringSplit(FileReadLine($findlisth, 3), ']')
								$lineNr = StringReplace($afind[1], '[', "")
								$copySrc = $afind[2]

								;Compare the CRC of the file to the CRC of the file to be downloaded
								$CRC32 = 0
								$FileHandle = FileOpen($copySrc, 16)
								For $ii = 1 To Ceiling(FileGetSize($copySrc) / $BufferSize)
									_getmessage()
									$Data = FileRead($FileHandle, $BufferSize)
									$CRC32 = _CRC32($Data, BitNOT($CRC32))
								Next
								_getmessage()
								FileClose($FileHandle)
								$CRCCopySrc = Hex($CRC32, 8)
								;If CRC is the same, then copy the file that has already been downloaded and continue
								If $crcinfile = $CRCCopySrc Then
									_getmessage()
									FileCopy($copySrc, $FileString, 2)
									ConsoleWrite($lineNr & @TAB & $afind[2] & @CRLF)
									ConsoleWrite($crcinfile & @TAB & $CRCCopySrc & @CRLF)
									ConsoleWrite('Copied file from "' & $copySrc & '" to "' & $FileString & '"' & @CRLF & @CRLF)
								Else ;If CRC is not the same, then download the file and continue
									_getmessage()
									GUICtrlSetData($label3, "Downloading: " & $FileName)
									GUICtrlSetColor($label3, 0xffffff)
									$continue = 0
									Start_DL2($root & '/' & $version & '/' & $urlfile, $tempdir & '\' & $version & "\" & $FileName)
								EndIf

							Else ;If a file was NOT found then download the file and continue
								_getmessage()

								; If the filename does not equal 'dotnet2.0.exe', then download it.
								If Not ($aFileName[$n] = 'dotnet2.0.exe') Then
									_getmessage()
									GUICtrlSetData($label3, "Downloading: " & $FileName)
									GUICtrlSetColor($label3, 0xffffff)
									$continue = 0
									Start_DL2($root & '/' & $version & '/' & $urlfile, $tempdir & '\' & $version & "\" & $FileName)
									_getmessage()

								EndIf

							EndIf
						EndIf
						_getmessage()
						GUICtrlSetData($label5, "")
					Next
					#EndRegion - >check & download files
					$diff = TimerDiff($begin)

					GUICtrlSetData($label1, "Installing additional support applications..." & @CRLF & "Download took approximately " & Round(($diff / 1000) / 60) & " minutes.")
					MsgBox(0, "Timer", "Download took approximately " & Round(($diff / 1000) / 60) & " minutes.")
					GUICtrlSetData($label2, "")
					GUICtrlSetData($label3, "")
					GUICtrlSetData($label4, "")
					GUICtrlSetData($label5, "")
					GUICtrlSetData($label6, "")
					GUICtrlSetData($label7, "")
					GUICtrlSetData($label8, "")
					GUICtrlDelete($progressbar2)
					GUICtrlDelete($progressbar3)
				EndIf


		EndSwitch
	WEnd




EndFunc   ;==>_Main

Func _getmessage()
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			If MsgBox(3 + 48, "Are you sure?", "The download is still in progress." & @CRLF & @CRLF & "Do you really want to exit?") = 6 Then
				Exit
			EndIf
		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_MINIMIZE)
	EndSwitch
EndFunc   ;==>_getmessage

Func Start_DL2($url, $file)
	If $url <> "" And $file <> "" Then
		$nSize = InetGetSize($url)
		$hDownload = InetGet($url, $file, 1, 1)
		AdlibRegister("DL_Check2", 20)
		Sleep(20)
		$starttime = TimerInit()
	EndIf
EndFunc   ;==>Start_DL2

Func DL_Check2()
	$continue = 0
	While $continue = 0
		_getmessage()
		If InetGetInfo($hDownload, 2) Then
			InetClose($hDownload)
			$nRead = $nSize
			$calc = Int(100 * $nRead / $nSize)
			GUICtrlSetData($progressbar2, $calc)
			GUICtrlSetData($label5, Round($calc, 2) & " %")
			$stop = 0
			AdlibUnRegister("DL_Check2")
			$continue = 1

		Else
			$nRead = InetGetInfo($hDownload, 0)
			$calc = Int(100 * $nRead / $nSize)
			$speed = Round(($nRead / 1024 * 8) / (_Timer_Diff($starttime) / 1000))
			GUICtrlSetData($progressbar2, $calc)
			GUICtrlSetData($label5, Round($calc, 2) & " % ")
		EndIf
	WEnd
EndFunc   ;==>DL_Check2