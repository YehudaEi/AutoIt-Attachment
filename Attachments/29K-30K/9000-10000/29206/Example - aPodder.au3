; aPodder - Podcast Downloader with Time Scheduler and TrayTip
; Fles are Downloaded to Folders under: My Documents\Downloads\Temp -- Change \Temp fields (3 fields per podcast) to folder needed per podcast address
; Shown is for two Podcast Addresses. Add additional Podcast for More
; Works only with webpages that have <link></link> formatting
; Last Update: 01-08-2010
; Added: Clear TrayTip after each download session
While 1
	Sleep(245)
	If @HOUR = 11 and @MIN = 10 and @SEC = 00 Then;<======== CHANGE TIME NEEDED TO DOWNLOAD
		Dim $objHTTP
		Dim $objReturn
		Dim $Result
		Dim $packageQueryUrl = "http://";<============== INSERT WEB ADDRESS WITHIN QUOTES
		$objHTTP = ObjCreate("Microsoft.XMLHTTP")
		$objHTTP.Open("Get", $packageQueryUrl, False)
		$objHTTP.Send
		$Result = $objHTTP.ResponseText
		$nOffset = 0
		$a = 0
		While $a <= 3;<================================= Change Number of Podcast to Download PLUS 1
			$a = $a + 1
			$links = StringRegExp($Result, '(?i)(?s)(?:.*?)<link>(.*?)</link>', 1, $nOffset)
			If @error = 0 Then
				$nOffset = @extended
			Else
				ExitLoop
			EndIf
			For $i = 0 To UBound($links) - 1
				$out = StringRegExpReplace($links[$i], '\s', '', 1)
				If Not StringInStr($out, ".mp3", 0) Then
				Else
					$get = $links[0]
					$get = StringRegExpReplace($get, '\s', '')
					$name = StringRegExp($get, '(?i)(?s)(?:.*)/(.*?).mp3', 1)
					If Not FileExists(@MyDocumentsDir & "\Downloads\temp\") Then DirCreate(@MyDocumentsDir & "\Downloads\temp\")
					ConsoleWrite("MP3 Link: " & $get & @CRLF & "MP3 Name: " & $name[0] & ".mp3" & @CRLF)
					InetGet($get, @MyDocumentsDir & "\Downloads\temp\" & $name[0] & ".mp3", 0, 1)
					While @InetGetActive
						Sleep(250)
						TrayTip("Downloading Podcast", "File: " & $name[0] & ".mp3     " & "Bytes = " & @InetGetBytesRead, 10, 16)
					WEnd
				EndIf
			Next
		WEnd
		Sleep(5000)
		TrayTip("", "", 5)
	EndIf
	If @HOUR = 12 and @MIN = 10 and @SEC = 00 Then;<======== CHANGE TIME NEEDED TO DOWNLOAD
		Dim $objHTTP
		Dim $objReturn
		Dim $Result
		Dim $packageQueryUrl = "http://";<============== INSERT WEB ADDRESS WITHIN QUOTES
		$objHTTP = ObjCreate("Microsoft.XMLHTTP")
		$objHTTP.Open("Get", $packageQueryUrl, False)
		$objHTTP.Send
		$Result = $objHTTP.ResponseText
		$nOffset = 0
		$a = 0
		While $a <= 4;<================================= Change Number of Podcast to Download PLUS 1
			$a = $a + 1
			$links = StringRegExp($Result, '(?i)(?s)(?:.*?)<link>(.*?)</link>', 1, $nOffset)
			If @error = 0 Then
				$nOffset = @extended
			Else
				ExitLoop
			EndIf
			For $i = 0 To UBound($links) - 1
				$out = StringRegExpReplace($links[$i], '\s', '', 1)
				If Not StringInStr($out, ".mp3", 0) Then
				Else
					$get = $links[0]
					$get = StringRegExpReplace($get, '\s', '')
					$name = StringRegExp($get, '(?i)(?s)(?:.*)/(.*?).mp3', 1)
					If Not FileExists(@MyDocumentsDir & "\Downloads\temp\") Then DirCreate(@MyDocumentsDir & "\Downloads\temp\")
					ConsoleWrite("MP3 Link: " & $get & @CRLF & "MP3 Name: " & $name[0] & ".mp3" & @CRLF)
					InetGet($get, @MyDocumentsDir & "\Downloads\temp\" & $name[0] & ".mp3", 0, 1)
					While @InetGetActive
						Sleep(250)
						TrayTip("Downloading Podcast", "File: " & $name[0] & ".mp3     " & "Bytes = " & @InetGetBytesRead, 10, 16)
					WEnd
				EndIf
			Next
		WEnd
		Sleep(5000)
		TrayTip("", "", 5)
	EndIf
WEnd