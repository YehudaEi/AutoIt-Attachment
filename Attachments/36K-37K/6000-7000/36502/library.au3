#cs ----------------------------------------------------------------------------
TO DO: InetGetsize for threads

#ce ----------------------------------------------------------------------------
#Include <Array.au3>
#include <File.au3>
#include <Crypt.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Array.au3>
_SQLite_Startup()
Global $database = _SQLite_Open("thumbnails.db"), $hQuery, $aRow, $sMsg, $sDummy, $fn_check, $us_array, $iRows, $iColumns, $image_check, $tb_check
Global $board_first = 17, $board_last = 17
Global $ponychan = "http://www.ponychan.net/chan/rp/"
Global $thread_contents, $thread_array[1], $inet[1] = ["header"], $d_ = "', '"

;General cleanup
_SQLite_Exec($database, "DELETE FROM unsorted;")
FileDelete("Temp\*.*")
DirCreate("Pages")
DirCreate("Pages\Thumbnails")
DirCreate("Temp")

;Download the pages on the board
;~ Download("http://guildedage.net/webcomic/chapter-15/chapter-15-cover/", "temp\test.html")
Download_Board()
Strip_Board_Pages()
Download_Threads()

;HTML processing loop
$thread_array = _FileListToArray("Temp", "*.html", 1)
For $x = 1 to UBound($thread_array)-1
	TrayTip("Processing thread "&StringTrimRight($thread_array[$x], 5), UBound($thread_array)-$x-1&" threads remain", 5)
	ConsoleWrite("Processing thread "&$thread_array[$x]&@CRLF)
	Html_Process($thread_array[$x])
Next

_SQLite_Close()
_SQLite_Shutdown()


;###############################
;####### Functions #############
;###############################
;Download the pages
Func Download_Board()
	TrayTip("Please wait...", "Downloading board pages "&$board_first&" through "&$board_last, 10)
	ConsoleWrite("Downloading board pages"&@CRLF)
	For $page = $board_first to $board_last
		Download($ponychan&$page&".html", "Temp\"&$page&".html", 1, 1)
	Next
	Download_Close()
EndFunc

;Download the threads
Func Strip_Board_Pages()
	;Scrape each downloaded page
	For $x = $board_first To $board_last
		TrayTip("Please wait...", "Searching for links on page "&$x, 10)
		ConsoleWrite("Searching for links on page "&$x&@CRLF)
		;Split the board page into rows
		$page_array = StringSplit(FileRead("Temp\"&$x&".html"), @CRLF, 1)
		;Check for thread links
		For $x2 = 1 to $page_array[0]-1
			If StringLeft($page_array[$x2], 46) = '[<a href="http://www.ponychan.net/chan/rp/res/' and StringRight($page_array[$x2], 11) = '">View</a>]' Then
				$thread_loc = StringTrimLeft($page_array[$x2], 10)
				$thread_loc = StringTrimRight($thread_loc, 11)
				;DELETE THIS LATER
				If $thread_loc = "http://www.ponychan.net/chan/rp/res/37813514.html" Then
				_ArrayInsert($thread_array, 0, $thread_loc)
				EndIf
			EndIf
		Next
	;Delete the scraped file
	FileDelete("Temp\"&$x&".html")
	Next
EndFunc

;Download individual threads
Func Download_Threads()
	;Download threads
	For $x = 0 To UBound($thread_array)-1
		$thread_url = $thread_array[$x]
		$thread_file = StringTrimLeft($thread_array[$x], 36)
		Download($thread_url, "Temp\"&$thread_file, 1, 1)
	Next
	Download_Close()
EndFunc


Func Html_Process($thread_file)
	;move this later
	;Check if the thread size has changed since last time
	$check_size = Check_Thread_Size($thread_file)
	If $check_size = 1 Then
		Return
	; If the thread has changed or hasn't been archived yet, process it now
	Else
		HTML_Cleanup($thread_file)
		Duplicate_Check()
		Download_Images()
		Download_Close()
		Sort_Images()
		$thread_title = Index_Thread($thread_file)
		;Dump the processed file
		$x2 = FileOpen("Pages\"&$thread_file, 2)
		FileWriteLine($x2, "<title>"&$thread_title&"</title>")
		For $x1 = 1 to $thread_contents[0]
			If $thread_contents[$x1] <> "" then FileWrite($x2, $thread_contents[$x1]&@LF)
		Next
		;Wrap up
		FileClose($x2)
;~ 		FileDelete("Temp\"&$thread_file)
	EndIf
EndFunc


Func Duplicate_Check()
	;Load the unsorted array
	_SQLite_GetTable2d($database, "SELECT * FROM unsorted", $us_array, $iRows, $iColumns)
	;Check for duplicate filenames
	For $x = 0 To UBound($us_array)-1
		$image_file = $us_array[$x][0]
		_SQLite_GetTable2d($database, "SELECT * FROM tb WHERE filenames LIKE '%"&$image_file&"%';", $image_check, $iRows, $iColumns)
		$image_file = $us_array[$x][0]
		$image_URL = $us_array[$x][1]
		$line_number = $us_array[$x][2]
		;If there is a pre-existing filename match, reroute the HTML and delete it from the queue
		If UBound($image_check) = 2 Then
			$image_template = $image_check[1][0]
			$thread_contents[$line_number] = StringReplace($thread_contents[$line_number], $image_URL, "Thumbnails\"&$image_template)
			_SQLite_Exec($database, "DELETE FROM unsorted WHERE filename = '"&$image_file&"';")
		EndIf
	Next
EndFunc

Func Download_Images()
	_SQLite_GetTable2d($database, "SELECT * FROM unsorted", $us_array, $iRows, $iColumns)
	For $x = 1 to UBound($us_array)-1
		Download($us_array[$x][1], "Temp\"&$us_array[$x][0], 0, 1)
	Next
EndFunc

;Tidy up the HTML
Func HTML_Cleanup($thread_file)
	$thread_contents = StringReplace(FileRead("Temp\"&$thread_file), @CRLF, @LF)
	$thread_contents = StringTrimLeft($thread_contents, StringInStr($thread_contents, '<span class="filesize">')-1)
	$thread_contents = '<div class="logo">Roleplay</div><link rel="stylesheet" type="text/css" href="http://www.ponychan.net/chan/css/img_global.css" /><link rel="stylesheet" type="text/css" href="http://www.ponychan.net/chan/css/colgate.css" id="userstylelink" />'&$thread_contents
	$thread_contents = StringLeft($thread_contents, StringInStr($thread_contents, '<div class="postfooter">', 1, -1)-1)
	$thread_contents = StringReplace($thread_contents, "http://www.ponychan.net/chan/rp/res/"&$thread_file, "", 0, 2)
	$thread_contents = StringSplit($thread_contents, @LF, 1)
	For $x = 1 To $thread_contents[0]
		If StringInStr($thread_contents[$x], '<div class="postfooter">', 1) > 0 Then
			For $x2 = $x To $x +5
				$thread_contents[$x2] = ""
			Next
			$x = $x + 5
		ElseIf	$thread_contents[$x] = '<span class="filesize">' Then
			For $x2 = $x To $x +19
				$thread_contents[$x2] = ""
			Next
			$x = $x + 19
		ElseIf $thread_contents[$x] = "<a" Then
			For $x2 = $x To $x +3
				$thread_contents[$x2] = ""
			Next
			$x = $x + 3
		ElseIf StringLeft($thread_contents[$x], 15) = '<span id="thumb' Then
			Queue_Image($thread_contents[$x], $x)
		EndIf
	Next
EndFunc

;Queue thumbnails for redundancy checking
Func Queue_Image($raw_line, $line_number)
	$image_URL = StringMid($raw_line, (StringInStr($raw_line, '"', 1, 3)+1), (StringInStr($raw_line, '"', 1, 4))-(StringInStr($raw_line, '"', 1, 3))-1)
	$image_file = StringMid($raw_line, (StringInStr($raw_line, '/', 1, 6)+1), (StringInStr($raw_line, '"', 1, 4))-(StringInStr($raw_line, '/', 1, 6))-1)
	_SQLite_Exec($database, "INSERT INTO unsorted (filename, url, line) VALUES ('"&$image_file&$d_&$image_URL&$d_&$line_number&"');")
EndFunc

;Compare the sizes of downloaded and last archived file
Func Check_Thread_Size($thread_file)
	$thread_size = FileGetSize("Temp\"&$thread_file)
	$thread_number = StringTrimRight($thread_file, 5)
	_SQLite_GetTable2d($database, "SELECT size FROM threads WHERE threadno= '"&$thread_number&"';", $fn_check, $iRows, $iColumns)
	If UBound($fn_check) = 1 Then
		Return(-1)
	ElseIf UBound($fn_check) = 2 And $fn_check[0][1] = $thread_size Then
		Return(1)
	ElseIf UBound($fn_check) = 2 And $fn_check[0][1] <> $thread_size Then
		Return(0)
	Else
		MsgBox(0, "Check_Thread_Size", "That's odd...")
	EndIf
EndFunc






;Sort images without duplicate filenames
Func Sort_Images()
	;Pull up the list of unsorted thumbnails and respective line numbers in the thread
	; 0 - filename | 1 - URL | 2 - line number
	_SQLite_GetTable2d($database, "SELECT * FROM unsorted;", $us_array, $iRows, $iColumns)
	; Go through the unsorted array
	For $x = 1 To UBound($us_array)-1
		$image_file = $us_array[$x][0]
		$image_URL = $us_array[$x][1]
		$line_number = $us_array[$x][2]
		$image_size = FileGetSize("Temp\"&$us_array[$x][0])
		$image_hash = _Crypt_HashFile("Temp\"&$us_array[$x][0], $CALG_MD5)
		If $image_hash = -1 Then
			MsgBox(0, "Overload", $us_array[$x][0])
			Exit
		EndIf
		;Check for MD5 and size matches
		_SQLite_GetTable2d($database, "SELECT * FROM tb WHERE MD5= '"&$image_hash&"' AND Size = '"&$image_size&"';", $tb_check, $iRows, $iColumns)
		;If there's no match
		If UBound($tb_check) = 1 Then
			;Create an index for this template thumbnail, move it to thumbnails folder and update the HTML
			_SQLite_Exec($database, "INSERT INTO tb (template, filenames, MD5, size) VALUES ('"&$image_file&"', '"&$image_file&"', '"&$image_hash&"', '"&$image_size&"');")
			FileMove("Temp\"&$image_file, "Pages\Thumbnails\")
			$thread_contents[$line_number] = StringReplace($thread_contents[$line_number], $image_URL, "Thumbnails\"&$image_file)
		;If there is a match
		ElseIf UBound($tb_check) = 2 Then
			;Update the filenames field with the new filename, delete it and update the HTML
			_SQLite_Exec($database, "UPDATE tb SET filenames = '"&$tb_check[1][1]&","&$image_file&"' WHERE MD5 = '"&$image_hash&"' AND size = '"&$image_size&"';")
;~ 			FileDelete("Temp\"&$image_file)
			$thread_contents[$line_number] = StringReplace($thread_contents[$line_number], $image_URL, "Thumbnails\"&$tb_check[1][0])
		; If there's... more than one match, I guess?
		Else
			MsgBox(0, "MD5 sorting", "more than one match?")
		EndIf
	Next
	_SQLite_Exec($database, "DELETE FROM unsorted;")
EndFunc

;Pause excessive concurrent downloads
Func Download($x1, $x2, $x3 = 0, $x4 = 1)
	;Delay the adding of another download if there are too many concurrent downloads

	While UBound($inet) >= 11
		Inet_Cleanup()
	Sleep(1000)
	WEnd
	;Start the download, add the handle to the end of the $inet array
	_ArrayAdd($inet, InetGet($x1, $x2, $x3, $x4))
EndFunc



Func Inet_Cleanup()
	For $x = UBound($inet)-1 To 1 Step -1
		$inet_info = InetGetInfo($inet[$x], -1)
		;If the download was complete and successful
		If $inet_info[2] = True And $inet_info[3] = True Then
			InetClose($inet[$x])
			_ArrayDelete($inet, $x)
			$x = 1
		;If the download was complete and unsuccessful
		ElseIf $inet_info[2] = True And $inet_info[3] = False Then
			ConsoleWriteError("Download error: "&_ArrayToString($inet_info)&@CRLF)
			InetClose($inet[$x])
			_ArrayDelete($inet, $x)
			$x = 1
		EndIf
	Next
EndFunc

Func Download_Close()
	While UBound($inet) > 1
		Inet_Cleanup()
		Sleep(200)
	WEnd
EndFunc

;Dump thread information into the database
Func Index_Thread($thread_file)
	Local $thread_number = StringTrimRight($thread_file, 5), $thread_poster, $thread_time, $thread_title
	;Check if the thread has already been indexed
	_SQLite_GetTable2d($database, "SELECT threadno FROM threads WHERE threadno= '"&$thread_number&"';", $fn_check, $iRows, $iColumns)
	;If it has, update the size field for future reference
	If UBound($fn_check) = 2 Then
		_SQLite_Exec($database, "UPDATE tb SET size = '"&FileGetSize("Temp\"&$thread_file&"' WHERE threadno = '"&$thread_number&"';"))
	ElseIf UBound($fn_check) = 1 Then
		For $x = 1 To UBound($thread_contents)-1
;~ 				MsgBox(0, "", $thread_contents[$x])
			;Check for thread title
			If StringLeft($thread_contents[$x], 24) = '<span class="filetitle">' Then
				$thread_title = $thread_contents[$x+1]
				$thread_title = StringReplace($thread_title, "'", "`")
;~ 				MsgBox(0, "", $thread_title)
			;Check for OP name
			ElseIf StringLeft($thread_contents[$x], 41) = '<span class="postername"><a href="mailto:' Then
				$thread_poster = StringTrimLeft($thread_contents[$x], StringInStr($thread_contents[$x], ">", 1, 2))
				$thread_poster = StringReplace($thread_poster, '</a></span><span class="postertrip">', "")
				$thread_poster = StringTrimRight($thread_poster, 7)
				$thread_poster = StringReplace($thread_poster, "'", "`")
			ElseIf StringLeft($thread_contents[$x], 25) = '<span class="postername">' Then
				$thread_poster = StringTrimLeft($thread_contents[$x], StringInStr($thread_contents[$x], ">", 1, 1))
				$thread_poster = StringReplace($thread_poster, '</span><span class="postertrip">', "")
				$thread_poster = StringTrimRight($thread_poster, 7)
				$thread_poster = StringReplace($thread_poster, '</a>', "")
				$thread_poster = StringReplace($thread_poster, "'", "`")
			ElseIf StringLeft($thread_contents[$x], 23) = '<span class="posttime">' Then
				$thread_time = StringTrimLeft($thread_contents[$x], 23)
				$thread_time = StringTrimRight($thread_time, 7)
				$thread_size = FileGetSize("Temp\"&$thread_file)
				_SQLite_Exec($database, "INSERT INTO threads (threadno, poster, title, time, size) VALUES ('"&$thread_number&"', '"&$thread_poster&"', '"&$thread_title&"', '"&$thread_time&"', '"&$thread_size&"');")
				Return($thread_title)
			EndIf
		Next
	;For unpredicted stuff
	Else
		MsgBox(0, "Huh", "That's not supposed to happen.")
	EndIf
EndFunc

