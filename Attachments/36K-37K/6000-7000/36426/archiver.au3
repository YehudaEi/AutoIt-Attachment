#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#Include <Array.au3>
#include <File.au3>
#include <Crypt.au3>
Global $board_first = 17
Global $board_last = 18
Global $board_last = 18
Global $ponychan = "http://www.ponychan.net/chan/rp/"
Global $h_path = "Pages\Thumbnails\MD5_index.txt"
Global $h_index = StringSplit(FileRead($h_path), @LF)
Global $h_queue[1]
Global $h_found = False
Global $thread_contents
DirCreate("Pages")
DirCreate("Pages\Thumbnails")
DirCreate("Temp")
FileDelete("Temp\*.*")
;~ FileDelete("Pages\Thumbnails\*.*")
;~ FileDelete("Pages\*.*")
FileCopy($h_path, $h_path&".bak", 1)
;~ MsgBox(0, "", $h_path&".bak")
$h_file = FileOpen($h_path, 2)

;Download the pages on the board
Download_Board()

;HTML archiving loop
For $board_current = $board_first to $board_last
;	Get the pages on the current board
	$thread_array = Strip_Page($board_current)
;	Download each thread in turn
	For $thread_download In $thread_array
		Download_Thread($thread_download)
	Next
Next

;Wait for all thread downloads to complete
While InetGetInfo() > 0
	Sleep(200)
WEnd

;HTML processing loop
$thread_array = _FileListToArray("Temp", "*.html", 1)
For $thread_file In $thread_array
	Html_Cleanup($thread_file)
Next

For $h_dump = 1 To UBound($h_index)-1
	FileWrite($h_file, $h_index[$h_dump]&@LF)
Next
FileClose($h_file)

;###############################
;####### Functions #############
;###############################
;Download the pages
Func Download_Board()
	For $page = $board_first to $board_last
		InetGet($ponychan&$page&".html", "Temp\"&$page&".html", 1, 1)
		;Wait until thumbnails are downloaded
		While InetGetInfo() > 0
			TrayTip("Downloading board pages ", "Now downloading page: "&$page, 10)
			Sleep(500)
		WEnd
	Next
	Throttle(0, 1)
EndFunc

;Download individual threads
Func Download_Thread($x1)
	$thread_file = StringTrimLeft($x1, 36)
	InetGet($x1, "Temp\"&$thread_file, 1, 1)
	Throttle(10, 2)
EndFunc

;Download images
Func Download_Image($raw_line, $line_number)
	Local $return[3]
	$image_URL = StringMid($raw_line, (StringInStr($raw_line, '"', 1, 3)+1), (StringInStr($raw_line, '"', 1, 4))-(StringInStr($raw_line, '"', 1, 3))-1)
	$image_file = StringMid($raw_line, (StringInStr($raw_line, '/', 1, 6)+1), (StringInStr($raw_line, '"', 1, 4))-(StringInStr($raw_line, '/', 1, 6))-1)
	;Check for matching filenames
	$check = Hash_Check($image_file)
	If $check = False Then
		_ArrayAdd($h_queue, $line_number&"|"&$image_file)
		InetGet($image_URL, "Temp\"&$image_file, 0, 1)
		Throttle(50, 3)
;~ 		MsgBox(0, UBound($h_queue),$line_number&"|"&$image_file)
		Return False
	;If the file exists in the hashlist
	ElseIf $check > 0 Then
		$hash_entry = StringSplit($h_index[$check], "|,")
;~ 		MsgBox(0, "DI 2", $hash_entry[2])
		$thread_contents[$line_number] = StringReplace($thread_contents[$line_number], $image_URL, "Thumbnails\"&$hash_entry[2])
		Return True
	Else
		MsgBox(0, "", "Something is wrong...")
	EndIf
EndFunc


Func Throttle($x1, $x2)
	While InetGetInfo() > $x1
		Sleep($x2*1000)
	WEnd
EndFunc

Func Strip_Page($x1)
	TrayTip("Please wait...", "Searching for links on page "&$x1, 5)
	Local $thread_array[1], $thread_loc
	$page_array = StringSplit(FileRead("Temp\"&$x1&".html"), @CRLF, 1)
	TrayTip("Please wait", "Searching for thread links...", 10)
	For $x2 = 1 to $page_array[0]-1
		If StringLeft($page_array[$x2], 46) = '[<a href="http://www.ponychan.net/chan/rp/res/' and StringRight($page_array[$x2], 11) = '">View</a>]' Then
			$thread_loc = StringTrimLeft($page_array[$x2], 10)
			$thread_loc = StringTrimRight($thread_loc, 11)

;############## DELETE THIS PART LATER!!!
;~ 			If $thread_loc = 'http://www.ponychan.net/chan/rp/res/37747963.html' Then
			_ArrayAdd($thread_array, $thread_loc)
;~ 			EndIf
		EndIf
	Next
	FileDelete("Temp\"&$x1&".html")
	Return($thread_array)
EndFunc

Func Html_Cleanup($thread_file)
	TrayTip("Processing thread "&$thread_file, "Stripping excess HTML...", 5)
	ReDim $h_queue[1]
	$thread_contents = StringReplace(FileRead("Temp\"&$thread_file), @CRLF, @LF)
	$thread_contents = StringTrimLeft($thread_contents, StringInStr($thread_contents, '<span class="filesize">')-1)
	$thread_contents = '<div class="logo">Roleplay</div><link rel="stylesheet" type="text/css" href="http://www.ponychan.net/chan/css/img_global.css" /><link rel="stylesheet" type="text/css" href="http://www.ponychan.net/chan/css/colgate.css" id="userstylelink" />'&$thread_contents
	$thread_contents = StringLeft($thread_contents, StringInStr($thread_contents, '<div class="postfooter">', 1, -1)-1)
	$thread_contents = StringReplace($thread_contents, "http://www.ponychan.net/chan/rp/res/"&$thread_file, "", 0, 2)
	$thread_contents = StringSplit($thread_contents, @LF, 1)
	For $x1 = 1 To $thread_contents[0]
		If StringInStr($thread_contents[$x1], '<div class="postfooter">', 1) > 0 Then
			For $x2 = $x1 To $x1 +5
				$thread_contents[$x2] = ""
			Next
			$x1 = $x1 + 5
		ElseIf	$thread_contents[$x1] = '<span class="filesize">' Then
			For $x2 = $x1 To $x1 +19
				$thread_contents[$x2] = ""
			Next
			$x1 = $x1 + 19
		ElseIf $thread_contents[$x1] = "<a" Then
			For $x2 = $x1 To $x1 +3
				$thread_contents[$x2] = ""
			Next
			$x1 = $x1 + 3
		ElseIf StringLeft($thread_contents[$x1], 15) = '<span id="thumb' Then
			;Image redundancy check processing
			$check = Download_Image($thread_contents[$x1], $x1)
		EndIf
	Next
	;Wait for all thumbnails to finish downloading
	While InetGetInfo() > 0
		Sleep(200)
	WEnd


	;Process "new" thumbnails
	TrayTip("Processing thread "&$thread_file, "Checking for duplicate thumbnails...", 5)
	For $x = 1 To UBound($h_queue)-1
		$data = StringSplit($h_queue[$x], "|,")
;~ 		If UBound($data) < 2 Then MsgBox(0, "", $h_queue[$x])
		If UBound($thread_contents) < $data[1]-1 Then MsgBox(0, UBound($thread_contents), $data[1])
;~ 		If UBound($thread_contents) < $data[1]-1
		$image_URL = StringMid($thread_contents[$data[1]], (StringInStr($thread_contents[$data[1]], '"', 1, 3)+1), (StringInStr($thread_contents[$data[1]], '"', 1, 4))-(StringInStr($thread_contents[$data[1]], '"', 1, 3))-1)
		$file_to_check = "Temp\"&$data[2]
		$h_hash = _Crypt_HashFile($file_to_check, $CALG_MD5)
;~ 		MsgBox(0, "", $h_hash)
		$check = Hash_Check($h_hash)
		;If there aren't any MD5 matches
		If $check = False Then
;~ 			MsgBox(0, "hash check none", $h_index[$check])
			_ArrayAdd($h_index, $h_hash&"|"&$data[2])
			FileMove("Temp\"&$data[2], "Pages\Thumbnails\"&$data[2])
			$thread_contents[$data[1]] = StringReplace($thread_contents[$data[1]], $image_URL, "Thumbnails\"&$data[2])
;~ 			MsgBox(0, "move", $thread_contents[$data[1]])
		;If a MD5 match has been found
		ElseIf $check > 0 Then
			;Add the new filename to the hash index
			$h_index[$check] = $h_index[$check]&","&$data[2]
			;Point the img src to the preexisting file
			$replace = StringSplit($h_index[$check], "|,")
			$thread_contents[$data[1]] = StringReplace($thread_contents[$data[1]], $image_URL, "Thumbnails\"&$replace[2])
;~ 			MsgBox(0, "hash check found", $data[2])
		EndIf
	Next

	$x2 = FileOpen("Pages\"&$thread_file, 2)
	For $x1 = 1 to $thread_contents[0]
		If $thread_contents[$x1] <> "" then FileWrite($x2, $thread_contents[$x1]&@LF)
	Next
	FileClose($x2)
EndFunc


Func Hash_Check($check)
	For $x = 1 To UBound($h_index)-1
		If StringInStr($h_index[$x], $check, 1) > 0 Then
			Return($x)
		EndIf
	Next
	Return False
EndFunc