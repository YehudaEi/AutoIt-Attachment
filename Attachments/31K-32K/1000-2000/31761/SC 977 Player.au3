#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1
	Author:          Foxhound

	Script Function:
	Shoutcast player.
	This is a little player I wrote that connects to the .977 Hitz Internet Radio
	Station and fetches the Arist name and song as well as lyrics and cover art using Chart Lyrics API (if it exists)
	A lot of the functions can be cleaned up a bit but this will have to do for now.
	You are welcome to edit and redistribute this source as much as you like.


#ce ----------------------------------------------------------------------------
AutoItSetOption("TrayAutoPause", 0)
HotKeySet("{ESC}", "abort")
HotKeySet("{F5}", "refresh")
HotKeySet("{F6}", "_lyricGUI")
Global $lyricData, $coverData, $ieObj, $author, $song, $metaObj, $lyricGUIData[2]
#include <IE.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\homepc\desktop\lyricgui.kxf
$Form1_1 = GUICreate("Lyrics", 640, 370)
;$Group1 = GUICtrlCreateGroup("lol - wtf", 8, 72, 401, 273)
$Pic1 = GUICtrlCreatePic("", 32, 88, 345, 241, BitOR($SS_NOTIFY, $WS_GROUP, $WS_BORDER, $WS_CLIPSIBLINGS, $GUI_ONTOP))
$Label1 = GUICtrlCreateLabel("No Image Available", 150, 176, 200, 36)
$Label2 = GUICtrlCreateLabel("", 8, 40, 150, 17)
$Edit1 = GUICtrlCreateEdit("", 432, 77, 177, 265, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $ES_CENTER, $ES_READONLY))
$Button1 = GUICtrlCreateButton("Close", 240, 32, 75, 25, $WS_GROUP)
GUICtrlSetState($Label1, $GUI_HIDE)
#EndRegion ### END Koda GUI section ###
MsgBox(0, ".977 Player", "Press ESC to exit," & @CRLF & "Press F5 to refresh song title." & @CRLF & "Press F6 to fetch lyrics to current song." & @CRLF & "Note: The lyric function is imperfect and you may get the wrong lyrics or none at all")
TrayTip("", "Loading player...please wait", 10)
play()
Func play()
	$url = "http://www.shoutcast.com/shoutcast-cdn/flash/popupPlayer_V19.swf?stationid=http://yp.shoutcast.com/sbin/tunein-station.pls?id=1280356&play_status=1"
	If IsObj($ieObj) == 0 Then
		$ieObj = _IECreate($url, 0, 0, 0) ;song stream
		TrayTip(".977 Player", "Current Song: " & getTitle(), 10, 1)
	EndIf
	While 1
		Sleep(60000)
	WEnd
EndFunc   ;==>play
Func abort()
	_IEQuit($ieObj)
	_IEQuit($metaObj)
	Exit
EndFunc   ;==>abort
Func getTitle()
	;Fetch the title of the song playing embedded deep inside the html source code of Shoutcasts home page.
	;The alternative was pulling this information from their Flash Object, but seeing as I can't figure out how to
	;pull text from flash, this will have to do. This method also explains why the song info updates a lot slower.
	;UPDATE: This issue has now been fixed by using http://205.188.215.230:8002/index.html
	If IsObj($metaObj) == 0 Then
		$metaObj = _IECreate("http://205.188.215.230:8002/index.html", 0, 0)
	EndIf
	_IENavigate($metaObj, "http://205.188.215.230:8002/index.html")
	While 1
		$source = _IEBodyReadText($metaObj) ;FIXME
		$tar = _StringBetween2($source, "Current Song: ", "Written")
		If StringLen($tar) <> 0 Then ExitLoop
	WEnd

	Return ($tar)
EndFunc   ;==>getTitle
Func _StringBetween2($s, $from, $to)
	;This helpful function taken from: http://www.autoitscript.com/forum/index.php?sho wtopic=89554
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>_StringBetween2
Func refresh()
	TrayTip(".977 Player", "Updating", 10, 1)
	TrayTip(".977 Player - Refreshed", "Current Song: " & getTitle(), 10, 1)
EndFunc   ;==>refresh

Func getLyrics()

	;----------------Alter for correct song/title format (Artist - Song Name) ------------------------------------------------------------------
	TrayTip(".977 Player", "Fetching Lyrics", 10, 1)
	$lyricArray = StringSplit(getTitle(), "-")
	If @error = 1 Then
		MsgBox(16, "", "Error parsing lyrics data. Malformed Track/Song name")
		play()
		;note $lyricArray[1] = Artist $lyricArray[2] = Song
	ElseIf IsArray($lyricArray) Then
		$author = $lyricArray[1]
		$song = $lyricArray[2]
	Else
		MsgBox(16, "", "Unable to retrieve lyrics/song name")
		play()
	EndIf
	;---------------------------
	$lyricURL = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist=" & $author & "&song=" & $song
	If IsObj($metaObj) == 0 Then
		$metaObj = _IECreate($lyricURL, 0, 0)
	EndIf
	_IENavigate($metaObj, $lyricURL)
	$lyricData = _StringBetween2(_IEBodyReadText($metaObj), "<Lyric>", "</Lyric>")
	$coverData = _StringBetween2(_IEBodyReadText($metaObj), "<LyricCovertArtUrl>", "</LyricCovertArtUrl>")
	If StringLen($lyricData) == 0 Then $lyricData = "Lyrics not found."
	$lyricGUIData[0] = $coverData
	$lyricGUIData[1] = $lyricData
	If IsArray($lyricGUIData) == 0 Then
		Return (999)
	Else
		Return ($lyricGUIData)
	EndIf
EndFunc   ;==>getLyrics
Func _lyricGUI()
	GUICtrlSetState($Label2,$GUI_ONTOP)
	GUICtrlSetData($Label2, getTitle())
	;catch nonarray returns
	If getLyrics() == 999 Then
		MsgBox(0, "", "Error fetching lyrics")
		play()
	EndIf
	GUISetState(@SW_SHOW)
	;array 0 = cover art url
	;array 1 = lyrics
	If FileExists(@TempDir & "\coverData.jpg") Then FileDelete(@TempDir & "\coverData.jpg")
	GUICtrlSetData($Edit1, $lyricData)
	InetGet($coverData, @TempDir & "\coverData.jpg", 0, 0)
	If Not FileExists(@TempDir & "\coverData.jpg") Then
		GUICtrlSetState($Label1, $GUI_SHOW)
		;MsgBox(0, "", "reached code - then")
	Else
		;MsgBox(0, "", "reached code - else")
		GUICtrlSetImage($Pic1, @TempDir & "\coverData.jpg")
	EndIf
	While 1
		$nMsg = GUIGetMsg()
		If $nMsg == $GUI_EVENT_CLOSE Then
			GUISetState(@SW_HIDE)
			play()
		ElseIf $nMsg = $Button1 Then
			GUISetState(@SW_HIDE)
			play()
		EndIf
	WEnd
EndFunc   ;==>_lyricGUI