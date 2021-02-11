If ProcessExists("nksp.exe") Then Exit
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1
	Author:          Foxhound

	Internet Radio Player v.1.1
	-------------------------------

	Script Function:
	After a few weeks of tinkering with the .977 Player,
	I recreated the whole script and added several new functions. So much so that I had to release it as a completely different script
	This script is an Internet Radio Player that allows you to tune into several different internet radio stations	All of the stations
	are based on Shoutcast.


	Features:
	* Automatically fetch Lyrics and Cover data to currently playing music(if it's a music station)
	* Select seven different radio stations to tune into ( more to come)
	* Get artist and song name of currently playing song



	Basics of what this script does:
	Choose a station ---> Create object, Embed flash player ----> Create another object, go to station's shoutcast website and
	pull 'now playing' song info ---> put that song into getLyrics() which will use Chart Lyrics website to return XML data
	containing link to cover art and the actual lyrics which are  parsed and displayed onto a GUI. Rinse and Repeat.


	-Issues -
	*Even with _IEQuit, the ieObj and metaObj may still linger. I've added a warning if it does happen.

	- Changelog -

	- v.0.1
	*Recreated the lyrics GUI
	*Removed auto music data feature
	*Fixed IeOBJ and metaObj lingering after script closing
	*Cleaned up getLyrics() functions

	- v.1.0
	*New Lyrics GUI
	*Changed script name from .977 player to Internet Radio
	*Multiple radio stations

	-v.1.1
	*Removed Hotkeys
	*Added New Tray Menu to replace hotkeys
	*Fixed - getTitle() stuck in loop if called without a correct source

	- Soon to come -
	*New update feature. INI support to handle URL's and other music data(see code below). Since the links might become out-of-date, new
	function will allow the player to update itself by downloading an update.ini file
	*Sound Mute/Volume functions
	*Manual song search and stream(search for a song, and play it)

	If you have any questions, please post it here:
	http://www.autoitscript.com/forum/index.php?showtopic=119419


#ce ----------------------------------------------------------------------------
#include <IE.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
;HotKeySet("{ESC}", "abort")
;HotKeySet("{F5}", "refresh")
;HotKeySet("{F7}", "_station")
Global $lyricData, $coverData, $ieObj, $author, $song, $metaObj, $lyricGUIData[2], $url, $titleSource, $getTitleSource _
		, $lyricLabel, $lyricGroup, $picFrame, $lyricEditBox
#region ----------------Lyrics GUI
$trayStation = TrayCreateItem("Select a radio station")
$trayGetLyrics = TrayCreateItem("Get lyrics to current song")
$trayGetCurrentSong = TrayCreateItem("Update current song")
$trayAbout = TrayCreateItem("About")
TrayCreateItem("")
$trayExit = TrayCreateItem("Exit")
$lyricForm = GUICreate("Lyrics", 633, 369, 256, 172)
$lyricGroup = GUICtrlCreateGroup("", 8, 32, 609, 329)
$picFrame = GUICtrlCreatePic("", 24, 56, 337, 281, BitOR($SS_NOTIFY, $WS_GROUP, $WS_BORDER, $WS_CLIPSIBLINGS))
$lyricEditBox = GUICtrlCreateEdit("Searching for lyrics...", 408, 56, 201, 289, BitOR($ES_CENTER, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL, $WS_BORDER))
GUICtrlSetData(-1, "lyricEditBox")
GUICtrlSetFont(-1, 10, 400, 0, "arial")
GUICtrlSetStyle($picFrame, $GUI_ONTOP)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_HIDE)
#endregion----------------------


#Region-------------STATION GUI
$stationForm = GUICreate("Internet Radio Player Version 1.0", 383, 123)
$stationGroup = GUICtrlCreateGroup("Choose a radio station from the list to tune into.", 8, 8, 369, 105)
$stationCombo = GUICtrlCreateCombo("Choose a station from the list...", 16, 40, 273, 25)
GUICtrlSetData(-1, ".977 The Hitz Channel|-=[:: HOT 108 JAMZ ::]=|CINEMIX - The Spirit of Soundtracks|Alex Jones - Infowars|Absolutely Smooth Jazz - S K Y . F M|181.FM - Kickin' Country|KCRW ALL NEWS")
$stationTuneButton = GUICtrlCreateButton("Tune In", 293, 38, 75, 24, BitOR($BS_DEFPUSHBUTTON, $WS_GROUP))
$currentStationLabel = GUICtrlCreateLabel("Current station: None", 40,80, 300, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_HIDE)
#EndRegion-------------------------
_station()
Func _station()
	GUISetState(@SW_SHOW,$stationForm)
	While 1
		$sMsg = GUIGetMsg()
		$tMsg = TrayGetMsg()
		If $tMsg == $trayStation Then _station()
		If $tMsg == $trayGetLyrics Then _lyricGUI()
		If $tMsg == $trayExit Then abort()
		If $tMsg == $trayAbout Then MsgBox(64,"Internet Radio Player","This script was created by Foxhound. You can find the project post here "&@CRLF&"http://www.autoitscript.com/forum/index.php?showtopic=119419")
		If $tMsg == $trayGetCurrentSong Then refresh()
		If $sMsg == $GUI_EVENT_CLOSE Then GUISetState(@SW_HIDE, $stationForm)
		If $sMsg == $stationTuneButton Then
			;---------ADD STATIONS HERE ---this section will be replaced by an INI in future versions of this script.
			$stationSelected = GUICtrlRead($stationCombo)
			If $stationSelected == ".977 The Hitz Channel" Then
				$titleSource = "                                      "
				$url = "                                                                                                                                                   "
				GUICtrlSetData($currentStationLabel,"Current Station: "& $stationSelected)
				GUISetState(@SW_HIDE, $stationForm)
				play($url)
			ElseIf $stationSelected == "-=[:: HOT 108 JAMZ ::]=" Then
				$titleSource = "                                      "
				$url = "                                                                                                                                                   "
				GUICtrlSetData($currentStationLabel,"Current Station: "& $stationSelected)
				GUISetState(@SW_HIDE, $stationForm)
				play($url)
			ElseIf $stationSelected == "CINEMIX - The Spirit of Soundtracks" Then
				$titleSource = "                                    "
				$url = "                                                                                                                                                   "
				GUICtrlSetData($currentStationLabel,"Current Station: "& $stationSelected)
				GUISetState(@SW_HIDE, $stationForm)
				play($url)
			ElseIf $stationSelected == "Absolutely Smooth Jazz - S K Y . F M" Then
				$titleSource = "                                    "
				$url = "                                                                                                                                               "
				GUICtrlSetData($currentStationLabel,"Current Station: "& $stationSelected)
				GUISetState(@SW_HIDE)
				play($url)
			ElseIf $stationSelected == "Alex Jones - Infowars" Then
				$titleSource = "                          "
				$url = "                                                                                                                                                   "
				GUICtrlSetData($currentStationLabel,"Current Station: "& $stationSelected)
				GUISetState(@SW_HIDE, $stationForm)
				play($url)
			ElseIf $stationSelected == "181.FM - Kickin' Country" Then
				$titleSource = "                            "
				$url = "                                                                                                                                                   "
				GUICtrlSetData($currentStationLabel,"Current Station: "& $stationSelected)
				GUISetState(@SW_HIDE, $stationForm)
				play($url)
			ElseIf $stationSelected == "KCRW ALL NEWS" Then
				$titleSource = "NONE"
				$url = "                                                                                                                                                    "
				GUICtrlSetData($currentStationLabel,"Current Station: "& $stationSelected)
				GUISetState(@SW_HIDE, $stationForm)
				play($url)

			EndIf
			;---------------------------------
		EndIf
		;MsgBox(0,"","done")

	WEnd
EndFunc   ;==>_station

Func play($url = "                                      ")
	;HotKeySet("{F6}", "_lyricGUI")

	TrayTip("", "Loading player...please wait", 10)
	If IsObj($ieObj) == 0 Then
		$ieObj = _IECreate("", 0, 0, 1) ;song stream
	EndIf
	_IENavigate($ieObj, $url, 1)
	;If $titleSource == "NONE" Then TrayTip("Internet Radio Player", "Current Song: " & "Not Available", 10, 1)
	TrayTip("Internet Radio Player", "Current Song: " & getTitle($titleSource), 10, 1)
	While 1
		$tMsg = TrayGetMsg()
		If $tMsg == $trayGetCurrentSong Then refresh()
		If $tMsg == $trayStation Then _station()
		If $tMsg == $trayAbout Then MsgBox(64,"Internet Radio Player","This script was created by Foxhound. You can find the project post here "&@CRLF&"http://www.autoitscript.com/forum/index.php?showtopic=119419")
		If $tMsg == $trayGetLyrics Then _lyricGUI()
		If $tMsg == $trayExit Then abort()
	WEnd
EndFunc   ;==>play
Func getTitle($getTitleSource)
	if $getTitleSource == "NONE" Then Return("No Data Available")
	;Fetch the title of the song playing embedded deep inside the html source code of Shoutcasts home page.
	;The alternative was pulling this information from their Flash Object, but seeing as I can't figure out how to
	;pull text from flash, this will have to do. This method also explains why the song info updates a lot slower.
	;UPDATE: This issue has now been fixed by using                                       
	If IsObj($metaObj) == 0 Then
		$metaObj = _IECreate($getTitleSource, 0, 0)
	EndIf
	_IENavigate($metaObj, $getTitleSource)
	$loopCount = 0
	While 1
		$source = _IEBodyReadText($metaObj) ;FIXME
		$rawTitle = _StringBetween2($source, "Current Song: ", "Written")
		If StringLen($rawTitle) <> 0 Then
			ExitLoop
		Else
			$loopCount += 1
			If $loopCount = 30 Then  ; simple error handling to prevent infinite loop.
			Return("Error - Error")
			EndIf
		EndIf



	WEnd

	Return ($rawTitle)
EndFunc   ;==>getTitle
Func _StringBetween2($s, $from, $to)
	;This helpful function taken from: http://www.autoitscript.com/forum/index.php?sho wtopic=89554
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>_StringBetween2
Func refresh()
	TrayTip("Internet Radio Player", "Updating...please wait", 10, 1)
	TrayTip("Internet Radio Player - Refreshed", "Current Song: " & getTitle($titleSource), 10, 1)
EndFunc   ;==>refresh

Func getLyrics()

	;----------------Alter for correct song/title format (Artist - Song Name) ------------------------------------------------------------------
	;TrayTip("Internet Radio Player", "Fetching Lyrics", 10, 1)
	$lyricArray = StringSplit(getTitle($titleSource), "-")
	If @error = 1 Then
		MsgBox(16, "", "Error parsing lyrics data. Malformed Track/Song name")
		play($url)
		;note $lyricArray[1] = Artist $lyricArray[2] = Song
	ElseIf IsArray($lyricArray) Then
		$author = $lyricArray[1]
		$song = $lyricArray[2]
	Else
		MsgBox(16, "", "Unable to retrieve lyrics/song name")
		play($url)
	EndIf
	;---------------------------
	$lyricURL = "                                                               " & $author & "&song=" & $song
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
	GUICtrlSetData($lyricEditBox, "Searching for lyrics...")
	GUISetState(@SW_SHOW, $lyricForm)
	If getLyrics() == 999 Then
		MsgBox(0, "", "Unable to find song and lyric data.")
		GUISetState(@SW_HIDE)
	EndIf
	#EndRegion ### END Koda GUI section ###
	InetGet($lyricGUIData[0], @TempDir & "\coverArt.jpg")
	If FileExists(@TempDir & "\coverArt.jpg") Then
		GUICtrlSetImage($picFrame, @TempDir & "\coverArt.jpg")
	Else
		GUICtrlSetData($lyricLabel, "Cover art image does not exist")
	EndIf

	GUICtrlSetData($lyricGroup, getTitle($titleSource))
	GUICtrlSetData($lyricEditBox, $lyricGUIData[1])
	While 1
		$nMsg = GUIGetMsg()
		$tMsg = TrayGetMsg()
		If $tMsg == $trayGetCurrentSong Then refresh()
		If $tMsg == $trayStation Then _station()
		If $tMsg == $trayGetLyrics Then _lyricGUI()
		If $tMsg == $trayExit Then abort()
		If $tMsg == $trayAbout Then MsgBox(64,"Internet Radio Player","This script was created by Foxhound. You can find the project post here "&@CRLF&"http://www.autoitscript.com/forum/index.php?showtopic=119419")
		If $nMsg == $GUI_EVENT_CLOSE Then
			GUICtrlSetData($lyricLabel, "")
			FileDelete(@TempDir & "\coverArt.jpg")
			GUISetState(@SW_HIDE, $lyricForm)
		EndIf
	WEnd
EndFunc   ;==>_lyricGUI
Func abort()
	_IEQuit($ieObj)
	_IEQuit($metaObj)
	Sleep(1000)
	If ProcessExists("iexplore.exe") Then
		MsgBox(16, "", "Oh no! IE still lives! This script did not close properly, please make sure iexplore.exe is closed from the process list") ;Heads up if obj didn't close properly.
	EndIf
	Exit
EndFunc   ;==>abort