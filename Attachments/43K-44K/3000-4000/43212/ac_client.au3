#include <Sound.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <String.au3>
#include "WinHttp.au3"
#include "Bass.au3"
#include "BassConstants.au3"


HotKeySet("!{ESC}", "_Exit")
HotKeySet("!{a}", "_Add")
OnAutoItExitRegister('_OnAutoItExit1')
Opt("WinDetectHiddenText", 0)



Global $playing_state = -1
Global $_X = @DesktopWidth - 130
Global $_Y = @DesktopHeight - 80
Global $sSound
Global $sPlayed = 0
Global $checked = 0
Global $Mutation = ""
Global $hMediaInfoDll
Global $hUser32Dll = DllOpen('user32.dll')
Global $iTimeOut
Global $oGlobalIE, $iDetails
Global $sTempDir = @TempDir & '\MSE'
Global Const $SMTO_ABORTIFHUNG = 0x0002
Global Const $SMTO_NOTIMEOUTIFNOTHUNG = 0x0008
Global $sRegKeySettings = 'HKCU\Software\Mp3SearchEngine\Settings', $sRegPreviousSound
Global $iSearchGui, $hGuiMain, $sMainGuiTitle, $hInetGet, $sSosoCookie
Global $iBitRate, $iSizeEx, $sTitle2, $iMaxTimeOut = 3000
Global $sTempFile = _FileGenerateRandomName($sTempDir, 'tmp')
Global $sSoundcloudSrc = _FileGenerateRandomName($sTempDir, 'src'), $hDownload3
Global $sMp3iliSrc = _FileGenerateRandomName($sTempDir, 'src'), $hDownload6, $smp3iliUrl
Global $sUserAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25 (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)'
Global $aLinks[1], $iTimeOut = 1000
Global $Path
Global $aName = ""
Global $sTempDir = @TempDir & '\AutID'
Global $dlFolder = @ScriptDir & "\Playlist"
Global $sMp3iliSrc = _FileGenerateRandomName($sTempDir, 'src'), $hDownload6, $smp3iliUrl
Global $_AudiodumpSrc = _GenerateRandomFileName($sTempDir, 'src'), $hDownload9, $_AudiodumpUrl
Global Const $sPath = @ScriptDir & "\Banned.ini"
Global $oSong, $SongName, $sSongList[1], $tSong
If Not FileExists($sPath) Then FileInstall("Banned.ini", "Banned.ini")
If Not FileExists($dlFolder) Then DirCreate($dlFolder)
Global $Bans = IniReadSection($sPath, "Banned")

;Open Bass.DLL.  Required for all function calls.
_BASS_STARTUP("BASS.dll")
_BASS_Init(0, -1, 44100, 0, "")
If @error Then
	MsgBox(0, "BASS_INIT", "Error initiating bass.dll." & @LF & "Error: " & @error, 1)
	Exit
EndIf


If Not WinExists("ac_client") Then
	MsgBox(0, "Error", "ac_client.exe not running." & @LF & "Run ac_client.exe before running this application.")
	Exit
Else
	$Tittle = WinGetTitle("ac_client")
	If $Tittle <> "ac_client" Then
;~ 		ConsoleWrite($Tittle & @LF)
	Else
		Do
			Sleep(500) ;Sleep until a song starts
		Until WinGetTitle("ac_client") <> "ac_client"
	EndIf
EndIf

While 1
	Sleep(250)
	If Not WinExists("ac_client") Then
		MsgBox(0, "Error", "ac_client not runnin." & @LF & "Run ac_client.exe before running this application.")
		Exit
	EndIf
	$sSong = _Get()
	$tSong = _GetSong()
	ToolTip("Playing: " & $sSong & " - " & $tSong, $_X - 250, $_Y)
	Select
		Case $sSong <> $oSong
			If _Check($sSong) = True Then
				_Stop()
				$oSong = $sSong
			Else
				$aName = $sSong
				_Song()
				ReDim $aLinks[1]
				If $Mutation = "Muted" Then
					_ReSetFocus()
;~ 					ConsoleWrite("Volume reset" & @LF)
				EndIf
;~ 				ConsoleWrite("Going on" & @LF)
				$oSong = $sSong
			EndIf

		Case $sSong == $oSong ;If no song is playing, or if the same song is playing, do nothing.
			If $Mutation = "Muted" Then
				_ReSetFocus()
;~ 				ConsoleWrite("Volume reset" & @LF)
			EndIf
			Sleep(250)
	EndSelect
WEnd

Func _Check($sSong)
	$sSong = StringStripWS($sSong, 3)
	For $X = 1 To $Bans[0][0]
		If $Bans[$X][1] == $sSong Then
			TrayTip("", "Muting: " & $Bans[$X][1], 0)
			Return True
		EndIf
	Next
EndFunc   ;==>_Check

Func _Get()
	$sTitle = WinGetTitle("ac_client")
	If StringLen($sTitle) > 9 Then
		$sTitle = StringSplit(StringTrimLeft($sTitle, 10), " –", 1)
		If $sTitle[1] <> "" Then
			Return $sTitle[1]
		Else
			$sTitle = WinGetTitle("ac_client")
			$sTitle = StringSplit(StringTrimLeft($sTitle, 10), " –", 1)
			For $i = 0 To UBound($sTitle) - 1
				If $sTitle[$i] <> "" And StringIsDigit($sTitle[$i]) <> 1 And $sTitle[$i] <> "-" Then
					$sTitle[$i] = StringRegExpReplace($sTitle[$i], "\h*-\V*", "")
					Return $sTitle[$i]
				EndIf
			Next
		EndIf
	Else
		Return False
	EndIf
EndFunc   ;==>_Get

Func _GetSong()
	$sTitle = WinGetTitle("ac_client")
	If StringLen($sTitle) > 9 Then
		$sTitle = StringSplit(StringTrimLeft($sTitle, 10), " –", 1)
		If $sTitle[1] <> "" Then
			Return $sTitle[2]
		Else
			$sTitle = WinGetTitle("ac_client")
			$sTitle = StringSplit(StringTrimLeft($sTitle, 10), " –", 1)
			For $i = 0 To UBound($sTitle) - 1
				If $sTitle[$i] <> "" And StringIsDigit($sTitle[$i]) <> 1 And $sTitle[$i] <> "-" Then
					$sTitle[$i] = StringRegExpReplace($sTitle[$i], "\h*-\V*", "")
					Return $sTitle[$i]
				EndIf
			Next
		EndIf
	Else
		Return False
	EndIf
EndFunc   ;==>_GetSong

Func _Exit()
	TrayTip("", "Bye bye", 1)
	Exit
EndFunc   ;==>_Exit

Func _Stop()
	$Pos = WinGetPos("ac_client")
	_SetFocus()
	ControlClick("ac_client", "", "", "Primary", 1, 120, $Pos[3] - 20)
	If $oSong = "" Or _IsInBanlist($oSong) = True Then
		Return
	EndIf
	If FileExists($Path) And _IsInBanlist($oSong) = False Then
;~ 		ConsoleWrite("_Stop artist exists and not banned" & @LF & "Path is: " & $Path & @LF)
	Else
;~ 		ConsoleWrite("_Stop artist doesnt exists or is banned" & @LF & "Path is: " & $Path & @LF)
		If _Get() = False Then
			_SetFocus()
			ControlSend("ac_client", "", "", "{Space}")
		EndIf
		Return
	EndIf
	$Pos = WinGetPos("ac_client")
	_SetFocus()
	ControlClick("ac_client", "", "", "Primary", 1, 120, $Pos[3] - 20)
	$Mutation = "Muted"
;~ 	ConsoleWrite("Muted" & @LF)
	Sleep(250)
	_SetFocus()
	For $X = 1 To $Bans[0][0]
		If WinGetTitle("ac_client") = $Bans[$X][1] Then
			ControlSend("ac_client", "", "", "{Space}")
			ExitLoop
		EndIf
	Next
	Local $sSound = _BASS_StreamCreateFile(False, $Path, 0, 0, 0)
	_BASS_ChannelPlay($sSound, 1)
	Local $song_length = _BASS_ChannelGetLength($sSound, $BASS_POS_BYTE)
	Sleep(1000)
	$sTitle = WinGetTitle("ac_client")
	While WinGetTitle("ac_client") = $sTitle
		Do
			Sleep(1000)
			ToolTip("Playing: " & _FileGetProperty($Path, "Name") & " - " & _FileGetProperty($Path, "Title"), $_X - 150, $_Y)
		Until WinGetTitle("ac_client") <> $sTitle
	WEnd
	While 1
		Sleep(1000)
		$current = _BASS_ChannelGetPosition($sSound, $BASS_POS_BYTE)
		If $current >= $song_length Then ExitLoop
		For $X = 1 To $Bans[0][0]
			If WinGetTitle("ac_client") <> "ac_client" Then
				_SetFocus()
				ControlSend("ac_client", "", "", "{Space}")
				Do
					Sleep(1000)
					$current = _BASS_ChannelGetPosition($sSound, $BASS_POS_BYTE)
					$percent = Round(($current / $song_length) * 100, 0)
					If $current >= $song_length Then ExitLoop
					ToolTip("Playing: " & _FileGetProperty($Path, "Name") & " - " & _FileGetProperty($Path, "Title") & @CRLF & "Completed: " & $percent & "%", $_X - 150, $_Y)
					If WinGetTitle("ac_client") <> "ac_client" Then
						_SetFocus()
						ControlSend("ac_client", "", "", "{Space}")
					EndIf
				Until $current >= $song_length
				ExitLoop
			EndIf
		Next
	WEnd
	_BASS_Free()
	FileDelete($Path)
	_BASS_STARTUP("BASS.dll")
	_BASS_Init(0, -1, 44100, 0, "")
	If @error Then
		MsgBox(0, "BASS_INIT", "Error initiating bass.dll." & @LF & "Error: " & @error, 1)
		Exit
	EndIf
	ToolTip("")
	$sPlayed = 1
	$Pos = WinGetPos("ac_client")
	_SetFocus()
	ControlClick("ac_client", "", "", "Primary", 1, 200, $Pos[3] - 20)
	If WinGetTitle("ac_client") = "ac_client" Then ControlSend("ac_client", "", "", "{Space}")
EndFunc   ;==>_Stop

Func _IsInBanlist($sSong)
	$sSong = StringStripWS($sSong, 3)
	Local $sReturn
	For $X = 1 To $Bans[0][0]
		If $Bans[$X][1] == $sSong Then
			$sReturn = True
			ExitLoop
		Else
			$sReturn = False
		EndIf
	Next
	Return $sReturn
EndFunc   ;==>_IsInBanlist

Func _SetFocus()
	Local $var = WinList()
	Local $state = WinGetState("ac_client")
	If BitAND($state, 16) Then
		WinSetState($state, "", @SW_RESTORE)
	EndIf
	If WinActive("ac_client") Then
		For $i = 1 To $var[0][0]
			If Not StringInStr($var[$i][0], "ac_client") And $var[$i][0] <> "" And IsVisible($var[$i][1]) Then
;~ 				ConsoleWrite("Changing focus to: Title = " & $var[$i][0] & @LF)
				WinActivate($var[$i][0])
				ExitLoop
			EndIf
		Next
	EndIf
EndFunc   ;==>_SetFocus

Func _ReSetFocus()
	Local $var = WinList()
	Local $state = WinGetState("ac_client")
	Local $Pos = WinGetPos("ac_client")
	If BitAND($state, 16) Then
		WinSetState($state, "", @SW_RESTORE)
	EndIf
	If WinActive("ac_client") Then
		For $i = 1 To $var[0][0]
			If Not StringInStr($var[$i][0], "ac_client") And $var[$i][0] <> "" And IsVisible($var[$i][1]) Then
;~ 				ConsoleWrite("ReSetFocus: Title = " & $var[$i][0] & @LF)
				WinActivate($var[$i][0])
				ControlClick("ac_client", "", "", "Primary", 1, 200, $Pos[3] - 20)
				WinActivate("ac_client")
				ExitLoop
			EndIf
		Next
	Else
		ControlClick("ac_client", "", "", "Primary", 1, 200, $Pos[3] - 20)
	EndIf
	$Mutation = "Unmuted"
;~ 	ConsoleWrite("Unmuted" & @LF)
EndFunc   ;==>_ReSetFocus

Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf

EndFunc   ;==>IsVisible

Func _Song()
	If $aName = "" Then
;~ 		ConsoleWrite("_Song artist is incorrect!" & @LF)
		Return
	Else
;~ 		ConsoleWrite("_Song() started, name is: " & $aName & @LF)
	EndIf
	$Path = $dlFolder & "\" & $aName & ".mp3"
	Local $Banlist = _IsInBanlist($aName)
	If FileExists($Path) And $Banlist = False Then
		Return
	Else
;~ 		ConsoleWrite("_Song path failed, checking if artist is banned..." & @LF)
		If $Banlist = False Then
;~ 			ConsoleWrite("Downaloading: " & $aName & @LF)
			_ReSetFocus()
			_Mp3Search_Skull($aName)
			_Mp3Search_Soundcloud($aName)
			_Mp3Search_Myfreemp3($aName)
			_Mp3Search_Mp3ili($aName)
			_Mp3Search_Audiodump($aName)
			If UBound($aLinks) >= 10 Then
				InetGet($aLinks[Round(Random(1, 10))], $Path, 1 + 2 + 8)
				If @error Then
					ConsoleWrite("Retrying InetGet" & @LF)
					InetGet($aLinks[Round(Random(1, 10))], $Path, 1 + 2 + 8)
				Else
;~ 					ConsoleWrite("Succed" & @LF)
				EndIf
;~ 				ConsoleWrite($aLinks[$sNumber] & @LF)
;~ 				ConsoleWrite($aName & " succesfully downloaded!" & @LF)
			Else
				ConsoleWrite("Failed to download. No mp3 found" & @LF)
			EndIf
		Else
;~ 			ConsoleWrite("_Song avoided, artist in banlist" & @LF)
		EndIf
	EndIf
EndFunc   ;==>_Song

Func _Add()
	$sTitle = WinGetTitle("ac_client")
	If StringLen($sTitle) > 9 Then
		$sTitle = StringSplit(StringTrimLeft($sTitle, 10), "–", 1)
		$sTitle = $sTitle[1]
		IniWrite($sPath, "Banned", $Bans[0][0] + 1, $sTitle)
		_Sort()
		TrayTip("", "Banished: " & $sTitle, 1)
	Else
;~ 		ConsoleWrite("Error adding artist." & @CRLF)
	EndIf
	$oSong = ""
EndFunc   ;==>_Add

Func _Sort()
	$Bans = IniReadSection($sPath, "Banned")
	_ArraySort($Bans, 0, 1, 0, 1)
	IniDelete($sPath, "Banned")
	For $X = 1 To $Bans[0][0]
		IniWrite($sPath, "Banned", $X, $Bans[$X][1])
		$Bans[$X][0] = $X
	Next
	$Bans = IniReadSection($sPath, "Banned")
EndFunc   ;==>_Sort

Func _Mp3Search_Myfreemp3($sQuery)
	Local $sSourceCode = _InetGetSourceCode('                          ' & StringReplace($sQuery, ' ', '+'))
	Local $aStringBetween2, $aStringBetween3, $sDownloadUrl, $iSizeEx, $sTitle, $iGo, $sFrom = 'myfreemp3'
	Local $aStringBetween = _StringBetween($sSourceCode, 'data-aid=', '/a>')
	If Not @error Then
		For $i = 0 To UBound($aStringBetween) - 1
			$aStringBetween2 = _StringBetween($aStringBetween[$i], '"', '" data')
			If Not @error Then
				$aStringBetween3 = _StringBetween($aStringBetween[$i], '">', '<')
				If Not @error Then
					$sDownloadUrl = '                              ' & $aStringBetween2[0] & '/'
					If Not _AlreadyInArray($aLinks, $sDownloadUrl, 1, 1) Then
						$sTitle = _StringProper(_StringClean($aStringBetween3[0]))
						If StringLen($sTitle) > 3 Then
							$sTitle = _StringRemoveDigitsFromStart($sTitle)
							$sTitle = _StringRemoveFromStart($sTitle, '-')
							$iGo = 0
							If $iDetails = 1 Then
								$iSizeEx = _InetGetInfoEx($sDownloadUrl, $iMaxTimeOut)
								If $iSizeEx > 1048576 And $iBitRate > 95 Then $iGo = 1
							Else
								$iGo = 1
								$iSizeEx = ''
								$iBitRate = ''
							EndIf
							If $iGo Then
								_ArrayAdd($aLinks, $sDownloadUrl)
								If @Compiled Then _WM_SENDDATA($hGuiMain, $sTitle & '|' & $sDownloadUrl & '|' & $iSizeEx & '|' & $iBitRate & '|' & $sFrom)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			Sleep(10)
		Next
	EndIf
EndFunc   ;==>_Mp3Search_Myfreemp3

Func _Mp3Search_Skull($sQuery)
	$sQuery = StringReplace(StringReplace($sQuery, '-', ' '), ' ', '_')
	Local $sUrl = '                        ' & $sQuery & '.html', $sSourceCode, $aStringSplit, $sDownloadUrl, $sTitle, $iGo, $sFrom, $sStringInStr1, $sStringInStr2
	$sSourceCode = _InetGetSourceCode($sUrl)
	If StringInStr($sSourceCode, 'Sorry, no results found') Then Return
	$sStringInStr1 = StringInStr($sSourceCode, 'info mp3 here')
	$sStringInStr2 = StringInStr($sSourceCode, '===')
	If $sStringInStr1 And $sStringInStr2 Then $sSourceCode = StringMid($sSourceCode, $sStringInStr1, $sStringInStr2 - $sStringInStr1)
	$aStringSplit = StringSplit($sSourceCode, @CRLF)
	$aStringSplit = _ArrayDeleteElementWithoutStrings($aStringSplit, 'mp3', '</div>')
	If Not IsArray($aStringSplit) Or UBound($aStringSplit) - 1 < 1 Then Return
	ReDim $aStringSplit[UBound($aStringSplit) - 1]
	$sFrom = 'mp3Skull'
	For $i = 0 To UBound($aStringSplit) - 2 Step 2
		$sTitle = _StringBetween($aStringSplit[$i], '<b>', '</b>')
		If Not @error Then
			$sTitle = _StringProper(_StringClean(StringReplace($sTitle[0], ' mp3', '')))
			If StringLen($sTitle) > 3 Then
				$sDownloadUrl = _StringBetween($aStringSplit[$i + 1], 'href="', '"')
				If Not @error Then
					$sDownloadUrl = StringReplace($sDownloadUrl[0], '\', '')
					If Not _AlreadyInArray($aLinks, $sDownloadUrl, 1, 1) Then
						If Not _StringOneOfTheseInStr($sDownloadUrl, 'rayfile.com|fileden.com|kickinthepeanuts.com') Then
							$iGo = 0
							$iBitRate = ''
							If $iDetails = 1 Then
								$iSizeEx = _InetGetInfoEx($sDownloadUrl, $iMaxTimeOut)
								If $iSizeEx > 1048576 And $iBitRate > 95 Then
									$iGo = 1
									If StringLen($sTitle2) > 3 Then $sTitle2 = _StringProper(_StringClean($sTitle2))
									If StringLen($sTitle2) > 3 Then $sTitle = $sTitle2
									$sTitle = _StringRemoveDigitsFromStart($sTitle)
									$sTitle = _StringRemoveFromStart($sTitle, '-')
								EndIf
							Else
								$iGo = 1
								$iSizeEx = ''
							EndIf
							If $iGo Then
								_ArrayAdd($aLinks, $sDownloadUrl)
								If @Compiled Then _WM_SENDDATA($hGuiMain, $sTitle & '|' & $sDownloadUrl & '|' & $iSizeEx & '|' & $iBitRate & '|' & $sFrom)
							EndIf
						EndIf
					EndIf
				Else
					$i -= 1
				EndIf
			EndIf
		EndIf
		Sleep(10)
	Next
EndFunc   ;==>_Mp3Search_Skull

Func _Mp3Search_Soundcloud($sQuery)
	Local $sFrom = 'soundcloud', $sSCConsumerKey = 'db840ada2477a93d5fdbcc96a46b37c1'
	Local $aStringBetween, $hGetSourceCode_TimerInit, $sSourceCode, $sDownloadUrl, $sTitle, $iGo, $iDuration
	Local $sQuery2 = StringReplace($sQuery, ' ', '|')
	$sQuery = StringReplace($sQuery, ' ', '+')
	$hDownload3 = InetGet('                                   ' & $sQuery & '&consumer_key=' & $sSCConsumerKey & '&limit=200', $sSoundcloudSrc, 1 + 2 + 8, 1)
	$hGetSourceCode_TimerInit = TimerInit()
	Do
		If TimerDiff($hGetSourceCode_TimerInit) > 7000 Then ; if server is overloaded
			InetClose($hDownload3)
			ExitLoop
		EndIf
	Until InetGetInfo($hDownload3, 2)
	$sSourceCode = FileRead($sSoundcloudSrc)
	FileDelete($sSoundcloudSrc)
	Local $aFormat, $aSize, $aDuration, $aTitle, $aStreamUrl
	$aStringBetween = _StringBetween($sSourceCode, '<track>', '</track>')
	If Not @error Then
		For $i = 0 To UBound($aStringBetween) - 1
			$aFormat = _StringBetween($aStringBetween[$i], '<original-format>', '</original-format>')
			If Not @error Then
				$aSize = _StringBetween($aStringBetween[$i], '<original-content-size type="integer">', '</original-content-size>')
				If Not @error Then
					$aDuration = _StringBetween($aStringBetween[$i], '<duration type="integer">', '</duration>')
					If Not @error Then
						$aTitle = _StringBetween($aStringBetween[$i], '<title>', '</title>')
						If Not @error Then
							$aStreamUrl = _StringBetween($aStringBetween[$i], '<stream-url>', '</stream-url>')
							If Not @error Then
								If $aFormat[0] = 'mp3' And $aSize[0] > 1048576 And $aSize[0] < 12 * 1024 * 1024 Then ; only mp3 and size 1 to 12 mb
									$sDownloadUrl = $aStreamUrl[0] & '?consumer_key=' & $sSCConsumerKey
									If Not _AlreadyInArray($aLinks, $sDownloadUrl, 1, 1) Then
										$sTitle = _StringProper(_StringClean(StringReplace(StringReplace($aTitle[0], ' cover', ''), 'cover ', '')))
										$sTitle = _StringRemoveDigitsFromStart($sTitle)
										$sTitle = _StringRemoveFromStart($sTitle, '-')
										If _StringOneOfTheseInStr($sTitle, $sQuery2) And Not _StringOneOfTheseInStr($sTitle, 'preview|karaok|demo|cover') Then ; filter results
											If StringLen($sTitle) > 3 Then
												$iGo = 0
												$iBitRate = ''
												If $iDetails = 1 Then
													$iDuration = $aDuration[0] / 1000 ; sec
													$iSizeEx = _WinHttpGetFileSize($sDownloadUrl)
													If $iSizeEx > 1048576 Then
														$iBitRate = _FileGetBitRate($iSizeEx, $iDuration)
														If $iBitRate > 95 Then $iGo = 1
													EndIf
												Else
													$iGo = 1
													$iSizeEx = ''
													$iBitRate = ''
												EndIf
												If $iGo Then
													_ArrayAdd($aLinks, $sDownloadUrl)
													If @Compiled Then _WM_SENDDATA($hGuiMain, $sTitle & '|' & $sDownloadUrl & '|' & $iSizeEx & '|' & $iBitRate & '|' & $sFrom)
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			Sleep(10)
		Next
	EndIf
	$hDownload3 = 0
EndFunc   ;==>_Mp3Search_Soundcloud

Func _FileGetBitRate($iSize, $iDuration)
	Local $iBitRate = $iSize / 1024 / $iDuration * 8
	Switch $iBitRate
		Case 65 To 96
			$iBitRate = 96
		Case 97 To 112
			$iBitRate = 112
		Case 113 To 128
			$iBitRate = 128
		Case 129 To 160
			$iBitRate = 160
		Case 161 To 192
			$iBitRate = 192
		Case 193 To 224
			$iBitRate = 224
		Case 225 To 256
			$iBitRate = 256
		Case 257 To 320
			$iBitRate = 320
		Case Else
			$iBitRate = 0
	EndSwitch
	Return $iBitRate
EndFunc   ;==>_FileGetBitRate

Func _WinHttpGetFileSize($sDownloadFileUrl, $sCookie = '')
	Local $sUserAgent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25 (compatible; Googlebot-Mobile/2.1; +http://www.google.com/bot.html)'
	Local $hOpen = _WinHttpOpen($sUserAgent), $iFileSize
	Local $aCrackedUrl = _WinHttpCrackUrl($sDownloadFileUrl, $ICU_DECODE)
	If Not @error Then
		Local $sHostName = $aCrackedUrl[2]
		_WinHttpSetTimeouts($hOpen, 0, $iTimeOut, $iTimeOut, $iTimeOut)
		Local $hConnect = _WinHttpConnect($hOpen, $sHostName)
		Local $sFileName = $aCrackedUrl[6] & $aCrackedUrl[7]
		Local $hRequest = _WinHttpOpenRequest($hConnect, 'GET', $sFileName, 'HTTP/1.1', $sHostName)
		_WinHttpAddRequestHeaders($hRequest, 'Accept: application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, application/msword, */*')
		_WinHttpAddRequestHeaders($hRequest, 'Accept-Encoding: gzip, deflate')
		_WinHttpAddRequestHeaders($hRequest, 'Connection: Keep-Alive')
		If $sCookie <> '' Then _WinHttpAddRequestHeaders($hRequest, 'Cookie: ' & $sCookie)
		_WinHttpSendRequest($hRequest)
		_WinHttpReceiveResponse($hRequest)
		If _WinHttpQueryDataAvailable($hRequest) Then $iFileSize = _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_CONTENT_LENGTH)
		_WinHttpCloseHandle($hRequest)
		_WinHttpCloseHandle($hConnect)
	EndIf
	_WinHttpCloseHandle($hOpen)
	Return $iFileSize
EndFunc   ;==>_WinHttpGetFileSize

Func _StringRemoveFromStart($sString, $sStringToRemove)
	While StringLeft(StringStripWS($sString, 7), 1) = $sStringToRemove
		$sString = StringTrimLeft($sString, 1)
	WEnd
	Return StringStripWS($sString, 7)
EndFunc   ;==>_StringRemoveFromStart

Func _StringRemoveDigitsFromStart($sString)
	While StringIsDigit(StringLeft(StringStripWS($sString, 7), 1))
		$sString = StringTrimLeft($sString, 1)
	WEnd
	Return $sString
EndFunc   ;==>_StringRemoveDigitsFromStart

Func _StringReplaceHtmlSymbolEntities($sString)
	Return StringRegExpReplace($sString, '&#([[:xdigit:]]+);', Execute(ChrW('0x$1')))
EndFunc   ;==>_StringReplaceHtmlSymbolEntities

Func _StringReplaceUnicodeChars($sString)
	Return Execute('"' & StringRegExpReplace($sString, '(?i)\\U([[:xdigit:]]{2,4})', '"&chrw(0x$1)&"') & '"')
EndFunc   ;==>_StringReplaceUnicodeChars

Func _StringReplaceCyrillicChars($sString)
	Return StringRegExpReplace($sString, '[^[:alnum:]\-\s\x{0400}-\x{04FF}]', '')
EndFunc   ;==>_StringReplaceCyrillicChars

Func _StringReplaceAccent($sString)
	$sString = StringReplace($sString, 'Â°', '°')
	$sString = StringReplace($sString, 'Ã§', 'c')
	$sString = StringReplace($sString, 'ÃŸ', 'ss')
	$sString = StringReplace($sString, "’", "'")
	$sString = StringReplace($sString, 'â‚¬', '€')
	$sString = StringRegExpReplace($sString, '(Ãš|Ãª|Ã©|Ã¨|Ã«|Â«|Â©|ã©|ãš|ãª|ã¨|ã«|â«|â©|ÃƒÂ¨|ÃƒÂ©|ÃƒÂª)', 'e')
	$sString = StringRegExpReplace($sString, '(ÃƒÂ§|Ãƒâ€¡)', 'c')
	$sString = StringRegExpReplace($sString, '(ÃŽ|Ã¶|Ã³|Ã´|ãŽ|ã¶|ã³|ã´|ÃƒÂ´)', 'o')
	$sString = StringRegExpReplace($sString, '(Ã»|Ã¼|Ã¹|ÃŒ|Ãº|ã»|ã¼|ã¹|ãŒ|ãº|ÃƒÂ»|ÃƒÂ¹)', 'u')
	$sString = StringRegExpReplace($sString, '(Ã¯|Ã®|ã¯|ã®|ÃƒÂ®)', 'i')
	$sString = StringRegExpReplace($sString, '(Ã |Ã¢|Ã¤|Ã€|Ã£|Ã¡|Ã¥|ã |ã¢|ã¤|ã€|ã£|ã¡|ã¥|ÃƒÂ¢|ÃƒÂ|ãƒâ)', 'a')
	$sString = StringReplace($sString, 'Ã', 'a')
	Local $aPattern[7][2] = [['[àáãâáäåÁÀÄÂÅœŒÆ]', 'a'],['[éêèéëÉÈËÊ]', 'e'],['[íîïìÍÌÏÎ]', 'i'],['[óõôòöÓÒÖÔøØ]', 'o'],['[úûùüÚÙÜÛ]', 'u'],['[ýÿÝ]', 'y'],['[çÇ]', 'c']]
	For $i = 0 To 6
		$sString = StringRegExpReplace($sString, $aPattern[$i][0], $aPattern[$i][1])
	Next
	Return $sString
EndFunc   ;==>_StringReplaceAccent

Func _StringClean($sString)
	$sString = StringRegExpReplace($sString, '%([[:xdigit:]]+)', Execute(Chr('0x$1')))
	$sString = StringReplace($sString, '&quot;', '"')
	$sString = StringReplace($sString, '&apos;', "'")
	$sString = StringReplace($sString, '&amp;', '&')
	$sString = StringReplace($sString, '&lt;', '<')
	$sString = StringReplace($sString, '&gt;', '>')
	$sString = _StringReplaceHtmlSymbolEntities($sString)
	If StringRegExp($sString, '(?i)U([[:xdigit:]]{2,4})') Then
		$sString = StringReplace($sString, ' u', '\u')
		$sString = _StringReplaceUnicodeChars($sString)
	EndIf
	$sString = StringReplace($sString, '-', 'IIIIIII')
	$sString = StringReplace($sString, "'", 'JJJJJJJ')
	$sString = StringStripWS(StringReplace(StringReplace($sString, 'IIIIIII', '-'), 'JJJJJJJ', "'"), 7)
	If StringRight($sString, 1) = '-' Then $sString = StringTrimRight($sString, 1)
	If StringLeft($sString, 1) = '-' Then $sString = StringTrimLeft($sString, 1)
	Do
		$sString = StringReplace($sString, "''", "'")
	Until Not @extended
	$sString = _StringRemoveDigitsFromStart($sString)
	While StringLeft(StringStripWS($sString, 7), 1) = '-'
		$sString = StringTrimLeft($sString, 1)
	WEnd
	$sString = _StringReplaceCyrillicChars($sString)
	$sString = _StringReplaceAccent($sString)
	If StringLeft(StringStripWS($sString, 7), 1) = '-' Then
		Do
			$sString = StringTrimLeft(StringStripWS($sString, 7), 1)
		Until StringLeft(StringStripWS($sString, 7), 1) <> '-'
	EndIf
	If StringRight(StringStripWS($sString, 7), 1) = '-' Then
		Do
			$sString = StringTrimRight(StringStripWS($sString, 7), 1)
		Until StringRight(StringStripWS($sString, 7), 1) <> '-'
	EndIf
	$sString = StringReplace($sString, ' cover', '')
	Return StringStripWS(_StringReplaceUnWantedChars($sString), 7)
EndFunc   ;==>_StringClean

Func _StringReplaceUnWantedChars($sString)
	Return StringReplace(StringRegExpReplace($sString, '[/:;.,_*?!"^`&~${}<>|#%]', ' '), '\', ' ')
EndFunc   ;==>_StringReplaceUnWantedChars

Func _AlreadyInArray($aSearch, $sItem, $iStart = 0, $iPartial = 0)
	Local $iIndex = _ArraySearch($aSearch, $sItem, $iStart, 0, 0, $iPartial)
	If Not @error Then Return $iIndex
EndFunc   ;==>_AlreadyInArray

Func _FileGenerateRandomName($sDirectory, $sExt)
	Do
		Local $sTempName = '~', $sTempPath
		While StringLen($sTempName) < 12
			$sTempName = $sTempName & Chr(Round(Random(97, 122), 0))
		WEnd
		$sTempPath = $sDirectory & '\' & $sTempName & '.' & $sExt
	Until Not FileExists($sTempPath)
	Return $sTempPath
EndFunc   ;==>_FileGenerateRandomName

Func _WinHttpGetSourceCode($sFileUrl, $sReferer, $sCookie)
	Local $hOpen = _WinHttpOpen($sUserAgent)
	Local $hRequest, $hConnect, $iFileSize, $chunk, $data
	_WinHttpSetOption($hOpen, $WINHTTP_OPTION_REDIRECT_POLICY, $WINHTTP_OPTION_REDIRECT_POLICY_NEVER)
	Local $aCrackedUrl = _WinHttpCrackUrl($sFileUrl, $ICU_DECODE)
	If Not @error Then
		Local $sHostName = $aCrackedUrl[2]
		$hConnect = _WinHttpConnect($hOpen, $sHostName)
		Local $sFileName = $aCrackedUrl[6] & $aCrackedUrl[7]
		If StringLeft($sFileName, 1) <> '/' Then $sFileName = '/' & $sFileName
		$hRequest = _WinHttpOpenRequest($hConnect, 'GET', $sFileName, 'HTTP/1.1', $sHostName)
		_WinHttpAddRequestHeaders($hRequest, 'Accept: application/x-ms-application, image/jpeg, application/xaml+xml, image/gif, image/pjpeg, application/x-ms-xbap, application/msword, */*')
		If $sReferer Then _WinHttpAddRequestHeaders($hRequest, 'Referer: ' & $sReferer)
		_WinHttpAddRequestHeaders($hRequest, 'Accept-Encoding: gzip, deflate')
		_WinHttpAddRequestHeaders($hRequest, 'Connection: Keep-Alive')
		_WinHttpAddRequestHeaders($hRequest, 'Cookie: ' & $sCookie)
		_WinHttpSendRequest($hRequest)
		_WinHttpReceiveResponse($hRequest)
		If _WinHttpQueryDataAvailable($hRequest) Then
			$data = Binary('')
			While 1
				$chunk = _WinHttpReadData($hRequest, 2)
				If Not @extended Then ExitLoop
				$data &= $chunk
				Sleep(10)
			WEnd
		EndIf
	EndIf
	If $hRequest Then _WinHttpCloseHandle($hRequest)
	If $hConnect Then _WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hOpen)
	If $data Then Return BinaryToString($data)
EndFunc   ;==>_WinHttpGetSourceCode

Func _StringOneOfTheseInStr($inStr, $sString)
	Local $sStringArray = StringSplit($sString, '|')
	If @error Then Return
	For $i = 1 To UBound($sStringArray) - 1
		If StringInStr($inStr, $sStringArray[$i]) Then Return 1
	Next
EndFunc   ;==>_StringOneOfTheseInStr

Func _WM_SENDDATA($hWnd, $sData)
	Local $tCOPYDATA, $tMsg, $aRet, $Ret
	$tMsg = DllStructCreate('char[' & StringLen($sData) + 1 & ']')
	DllStructSetData($tMsg, 1, $sData)
	$tCOPYDATA = DllStructCreate('ulong_ptr;dword;ptr')
	DllStructSetData($tCOPYDATA, 2, StringLen($sData) + 1)
	DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMsg))
	While 1
		$aRet = DllCall($hUser32Dll, 'int', 'IsHungAppWindow', 'hwnd', $hGuiMain)
		If Not @error And Not $aRet[0] Then ExitLoop
		Sleep(1000)
	WEnd
	$Ret = DllCall($hUser32Dll, 'lparam', 'SendMessageTimeout', 'hwnd', $hWnd, 'int', $WM_COPYDATA, 'wparam', 0, 'lparam', DllStructGetPtr($tCOPYDATA), 'uint', BitOR($SMTO_ABORTIFHUNG, $SMTO_NOTIMEOUTIFNOTHUNG), 'uint', 1000, 'dword_ptr*', 0) ; ok
	If @error Or $Ret[0] = -1 Then Return 0
	Return 1
EndFunc   ;==>_WM_SENDDATA

Func _InetGetInfoEx($sFileUrl, $iTimeOut)
	$sTitle2 = ''
	If FileExists($sTempFile) Then FileDelete($sTempFile)
	$iBitRate = ''
	$hInetGet = InetGet($sFileUrl, $sTempFile, 11, 1)
	Local $hInetTimerInit = TimerInit()
	Local $aMediaInfoNew = DllCall($hMediaInfoDll, 'ptr', 'MediaInfo_New'), $iSize, $ret1, $ret2, $aInfosGet
	Do
		$iSize = InetGetInfo($hInetGet, 1)
		If Not @error And $iSize > 0 Then
			If $iSize < 1048576 Or $iSize > 1048576 * 12 Then
				$iSize = 0
				ExitLoop
			EndIf
			DllCall($hMediaInfoDll, 'int', 'MediaInfo_Open', 'ptr', $aMediaInfoNew[0], 'wstr', $sTempFile)
			If Not $sTitle2 Then
				$ret1 = DllCall($hMediaInfoDll, 'wstr', 'MediaInfo_Get', 'ptr', $aMediaInfoNew[0], 'int', 0, 'int', 0, 'wstr', 'Performer', 'int', 1, 'int', 0)
				$ret2 = DllCall($hMediaInfoDll, 'wstr', 'MediaInfo_Get', 'ptr', $aMediaInfoNew[0], 'int', 0, 'int', 0, 'wstr', 'Title', 'int', 1, 'int', 0)
				If $ret1[0] And $ret2[0] Then $sTitle2 = $ret1[0] & ' - ' & $ret2[0]
			EndIf
			$aInfosGet = DllCall($hMediaInfoDll, 'wstr', 'MediaInfo_Get', 'ptr', $aMediaInfoNew[0], 'int', 0, 'int', 0, 'wstr', 'BitRate', 'int', 1, 'int', 0)
			$iBitRate = Int($aInfosGet[0] / 1000)
			DllCall($hMediaInfoDll, 'none', 'MediaInfo_Close', 'ptr', $aMediaInfoNew[0])
			If $iBitRate Then ExitLoop
		EndIf
		Sleep(250)
	Until TimerDiff($hInetTimerInit) > $iTimeOut
	DllCall($hMediaInfoDll, 'none', 'MediaInfo_Delete', 'ptr', $aMediaInfoNew[0])
	$aMediaInfoNew = 0
	InetClose($hInetGet)
	$hInetGet = 0
	If Not _FileIsMp3($sTempFile) Or $iBitRate <= 96 Then $iSize = 0
	FileDelete($sTempFile)
	Return $iSize
EndFunc   ;==>_InetGetInfoEx

Func _InetGetSourceCode($sUrl)
	Return BinaryToString(InetRead($sUrl))
EndFunc   ;==>_InetGetSourceCode

Func _FileIsMp3($sMp3FilePath)
	Local $bHeader = StringToBinary(FileRead($sMp3FilePath))
	$bHeader = StringReplace(StringTrimLeft($bHeader, 2), '00', '')
	If StringLeft($bHeader, 6) = '494433' Or StringLeft($bHeader, 2) = 'FF' Then Return True
EndFunc   ;==>_FileIsMp3

Func _ArrayDeleteElementWithoutStrings($aArray, $sString1, $sString2, $iBase = 0)
	Local $aAdd[1]
	For $Element In $aArray
		If StringInStr($Element, $sString1) And StringInStr($Element, $sString2) Then _ArrayAdd($aAdd, $Element)
	Next
	If Not $iBase Then _ArrayDelete($aAdd, 0)
	Return $aAdd
EndFunc   ;==>_ArrayDeleteElementWithoutStrings

Func _Max($nNum1, $nNum2)
	If Not IsNumber($nNum1) Then Return SetError(1, 0, 0)
	If Not IsNumber($nNum2) Then Return SetError(2, 0, 0)
	If $nNum1 > $nNum2 Then
		Return $nNum1
	Else
		Return $nNum2
	EndIf
EndFunc   ;==>_Max

Func _SosoConvertWmaUrlToMp3Url($sWmaUrl)
	Local $sEndStringMid = StringMid($sWmaUrl, StringInStr($sWmaUrl, '.qqmusic.qq.com'))
	Local $sWmaUrlMid = StringMid($sWmaUrl, 14, StringInStr($sWmaUrl, '.qqmusic.qq.com') - 14) + 10
	Local $sMp3Url = 'http://stream' & $sWmaUrlMid & $sEndStringMid
	Local $i = StringInStr($sMp3Url, '.com/') + 5
	$sMp3Url = StringMid($sMp3Url, 1, $i - 1) & StringMid($sMp3Url, $i, 2) + 18 & StringMid($sMp3Url, $i + 2)
	Return StringReplace($sMp3Url, '.wma', '.mp3')
EndFunc   ;==>_SosoConvertWmaUrlToMp3Url

Func _IEClickSound($iClickSound = 1)
	If Not $sRegPreviousSound Then $sRegPreviousSound = RegRead($sRegKeySettings, 'PreviousSound')
	If Not $sRegPreviousSound Then
		$sRegPreviousSound = RegRead('HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current', '')
		RegWrite($sRegKeySettings, 'PreviousSound', 'REG_EXPAND_SZ', $sRegPreviousSound)
	EndIf
	If $iClickSound Then
		If $sRegPreviousSound Then RegWrite('HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current', '', 'REG_EXPAND_SZ', $sRegPreviousSound)
	Else
		If $sRegPreviousSound Then RegWrite('HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current', '', 'REG_EXPAND_SZ', 'Disable')
	EndIf
EndFunc   ;==>_IEClickSound

Func _IEGetCookie($sUrl)
	Local $oIE = ObjCreate('InternetExplorer.Application')
	$oGlobalIE = $oIE
	If Not IsObj($oIE) Then Return SetError(1, 0, 0)
	$oIE.Width = 200
	$oIE.Height = 100
	$oIE.Visible = 0
	$oIE.AddressBar = 0
	$oIE.MenuBar = 0
	$oIE.StatusBar = 0
	$oIE.ToolBar = 0
	$oIE.Left = 0
	$oIE.Top = 0
	$oIE.Resizable = 0
	$oIE.Silent = True
	Local $hIETimerInit = TimerInit()
	$oIE.Navigate($sUrl)
	Do
		Sleep(250)
		If TimerDiff($hIETimerInit) > 7000 Or Not WinExists($sMainGuiTitle) Then
			$oIE.Stop
			$oIE.quit
			Return SetError(2, 0, 0)
		EndIf
	Until Not $oIE.Busy
	Local $sCookie = $oIE.document.cookie
	$oIE.quit
	$oGlobalIE = 0
	$oIE = 0
	Return $sCookie
EndFunc   ;==>_IEGetCookie

Func _GenerateRandomFileName($_Dir, $_Ext)
	Do
		Local $_TempName = '~', $_TempPath
		While StringLen($_TempName) < 12
			$_TempName = $_TempName & Chr(Round(Random(97, 122), 0))
		WEnd
		$_TempPath = $_Dir & '\' & $_TempName & '.' & $_Ext
	Until Not FileExists($_TempPath)
	Return $_TempPath
EndFunc   ;==>_GenerateRandomFileName

Func _OnAutoItExit1()
	_BASS_Free()
	DirRemove($dlFolder, 1)
	DllClose($hUser32Dll)
	;If WinExists("ac_client") Then Run('"' & @AutoItExe & '"' & ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '" /restart')
EndFunc   ;==>_OnAutoItExit1

Func _FileGetProperty(Const $S_PATH, Const $S_PROPERTY = "")
	If Not FileExists($S_PATH) Then Return SetError(1, 0, 0)

	Local Const $S_FILE = StringTrimLeft($S_PATH, StringInStr($S_PATH, "\", 0, -1))
	Local Const $S_DIR = StringTrimRight($S_PATH, StringLen($S_FILE) + 1)

	Local Const $objShell = ObjCreate("Shell.Application")
	If @error Then Return SetError(3, 0, 0)

	Local Const $objFolder = $objShell.NameSpace($S_DIR)
	Local Const $objFolderItem = $objFolder.Parsename($S_FILE)

	If $S_PROPERTY Then
		For $i = 0 To 99
			If $objFolder.GetDetailsOf($objFolder.Items, $i) = $S_PROPERTY Then Return $objFolder.GetDetailsOf($objFolderItem, $i)
		Next
		Return SetError(2, 0, 0)
	EndIf

	Local $av_ret[1][2] = [[1]]
	For $i = 0 To 99
		If $objFolder.GetDetailsOf($objFolder.Items, $i) Then
			ReDim $av_ret[$av_ret[0][0] + 1][2]
			$av_ret[$av_ret[0][0]][0] = $objFolder.GetDetailsOf($objFolder.Items, $i)
			$av_ret[$av_ret[0][0]][1] = $objFolder.GetDetailsOf($objFolderItem, $i)
			$av_ret[0][0] += 1
		EndIf
	Next

	If Not $av_ret[1][0] Then Return SetError(2, 0, 0)
	$av_ret[0][0] -= 1

	Return $av_ret
EndFunc   ;==>_FileGetProperty

Func FileDownload($url, $SavePath)
	If FileExists($SavePath) Then FileDelete($SavePath) ; So it won't crash since it is not pure autoit
	Local $xml, $Stream
	$xml = ObjCreate("Microsoft.XMLHTTP")
	$Stream = ObjCreate("Adodb.Stream")
	$xml.Open("GET", $url, 0)
	$xml.Send
	$Stream.Type = 1
	$Stream.Open
	$Stream.write($xml.ResponseBody)
	$Stream.SaveToFile($SavePath)
	$Stream.Close
EndFunc   ;==>FileDownload

Func _Mp3Search_Mp3ili($sQuery)
	$sQuery = StringLower(StringReplace($sQuery, ' ', '+'))
	Local $sFrom = 'mp3ili', $sSourceCode, $aStringBetween, $sDownloadUrl, $aTitle, $sTitle, $iGo, $sDuration, $aStringSplit, $iDuration
	Local $smp3iliUrl = '                          ' & $sQuery
	Local $hGetSourceCode_TimerInit = TimerInit()
	$hDownload6 = InetGet($smp3iliUrl, $sMp3iliSrc, 1 + 2 + 8, 1)
	Do
		If TimerDiff($hGetSourceCode_TimerInit) > 7000 Then ; if server is overloaded
			InetClose($hDownload6)
			ExitLoop
		EndIf
	Until InetGetInfo($hDownload6, 2)
	$sSourceCode = FileRead($sMp3iliSrc)
	FileDelete($sMp3iliSrc)
	$aStringBetween = _StringBetween($sSourceCode, '<noindex><a href="', '<div style="h')
	If Not @error Then
		For $i = 0 To UBound($aStringBetween) - 1
			$sDownloadUrl = StringMid($aStringBetween[$i], 1, StringInStr($aStringBetween[$i], '"') - 1)
			If Not _AlreadyInArray($aLinks, $sDownloadUrl, 1, 1) Then
				$aTitle = _StringBetween($aStringBetween[$i], 'title="', '"><img')
				If Not @error Then
					$sTitle = _StringProper(StringStripWS(StringRegExpReplace(_StringClean($aTitle[0]), '(?i)[^a-z0-9]', ' '), 7))
					If StringLen($sTitle) > 3 Then
						$sTitle = _StringRemoveDigitsFromStart($sTitle)
						$sTitle = _StringRemoveFromStart($sTitle, '-')
						$iGo = 0
						If $iDetails = 1 Then
							$sDuration = StringMid($aStringBetween[$i], StringInStr($aStringBetween[$i], '(', 0, -1) + 1, StringInStr($aStringBetween[$i], ')', 0, -1) - StringInStr($aStringBetween[$i], '(', 0, -1) - 1)
							$aStringSplit = StringSplit($sDuration, ':', 1 + 2)
							If Not @error Then
								$iDuration = $aStringSplit[0] * 60 + $aStringSplit[1]
								$iSizeEx = _WinHttpGetFileSize($sDownloadUrl)
								If $iSizeEx > 1048576 Then
									$iBitRate = _FileGetBitRate($iSizeEx, $iDuration)
									If $iBitRate > 95 Then
										$iGo = 1
										_ArrayAdd($aLinks, $sDownloadUrl)
									EndIf
								EndIf
							EndIf
						Else
							$iGo = 1
							$iSizeEx = ''
							$iBitRate = ''
						EndIf
						If $iGo And @Compiled Then _WM_SENDDATA($hGuiMain, $sTitle & '|' & $sDownloadUrl & '|' & $iSizeEx & '|' & $iBitRate & '|' & $sFrom)
					EndIf
				EndIf
			EndIf
			Sleep(10)
		Next
	EndIf
	$hDownload6 = 0
EndFunc   ;==>_Mp3Search_Mp3ili

Func _Mp3Search_Audiodump($sQuery)
	$sQuery = StringReplace($sQuery, ' ', '+')
	Local $iPageNb = 10, $iPage = 0, $sFrom = 'audiodump', $hTimerInit, $sData
	Local $sSourceCode = BinaryToString(InetRead('                         ', 1 + 2 + 8))
	Local $aExtractedVal = StringRegExp($sSourceCode, '(?s)(?i)"v" value="(.*?)">', 3)
	If Not IsArray($aExtractedVal) Then Return
	Local $sReferer = '                         ', $sUrl, $sCookie, $aStringSplit, $aStringSplit2, $aStringSplit3, $sDownloadUrl, $sTitle, $iGo, $aStringSplit4, $iDuration
	Do
		$iPage += 1
		$sUrl = '                                      ' & $iPage & '&v=' & $aExtractedVal[0] & '&q=' & $sQuery
		$hTimerInit = TimerInit()
		$sSourceCode = _WinHttpGetSourceCode($sUrl, $sReferer, $sCookie)
		$aStringSplit = StringSplit($sSourceCode, @CRLF)
		For $i = 0 To UBound($aStringSplit) - 1
			If StringInStr($aStringSplit[$i], 'dancing.html?x') Then
				$sData = _StringBetween($aStringSplit[$i], '. <a href="', ') <')
				If Not @error Then
					For $k = 0 To UBound($sData) - 1
						If Not StringInStr($sData[$k], 'search.php?') Then
							$aStringSplit2 = StringSplit($sData[$k], '">', 1 + 2)
							If Not @error Then
								$sDownloadUrl = $aStringSplit2[0]
								If StringInStr($sDownloadUrl, '&#') Then $sDownloadUrl = _StringReplaceHtmlSymbolEntities($sDownloadUrl)
								$aStringSplit3 = StringSplit($aStringSplit2[1], '</a> (', 1 + 2)
								If Not @error Then
									$sTitle = _StringProper(StringReplace(_StringClean($aStringSplit3[0]), "'j", "j'"))
									$sTitle = _StringRemoveDigitsFromStart($sTitle)
									$sTitle = _StringRemoveFromStart($sTitle, '-')
									If Not _AlreadyInArray($aLinks, $sDownloadUrl, 1, 1) And Not StringInStr($sDownloadUrl, '|') Then
										If StringLen($sTitle) > 3 Then
											$iGo = 0
											If $iDetails = 1 Then
												$aStringSplit4 = StringSplit($aStringSplit3[1], ':', 1 + 2)
												If Not @error Then
													$iDuration = $aStringSplit4[0] * 60 + $aStringSplit4[1]
													$iSizeEx = _WinHttpGetFileSize($sDownloadUrl)
													$iBitRate = _FileGetBitRate($iSizeEx, $iDuration)
													If $iBitRate > 95 And $iSizeEx > 1048576 Then $iGo = 1
												EndIf
											Else
												$iGo = 1
												$iSizeEx = ''
												$iBitRate = ''
											EndIf
											If $iGo Then
												_ArrayAdd($aLinks, $sDownloadUrl)
												If @Compiled Then _WM_SENDDATA($hGuiMain, $sTitle & '|' & $sDownloadUrl & '|' & $iSizeEx & '|' & $iBitRate & '|' & $sFrom)
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					Next
				EndIf
			EndIf
			Sleep(10)
		Next
		Sleep(50)
		$sReferer = $sUrl
	Until $iPage >= $iPageNb
EndFunc   ;==>_Mp3Search_Audiodump
