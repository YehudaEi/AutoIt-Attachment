#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.4.9
	Author:         myName
	
	Script Function:
	Template AutoIt script.
	
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstants.au3>
#include <Sound.au3>
#include <Array.au3>
#include <GUIComboBox.au3>
#include <File.au3>
#include <GuiListView.au3>

;thanks to SmOke_N for .ini sort func
;Simucal also
;and many others :)
;v2.1.7
;2.1.7: Reads unknown files' info, includes library cleaner, includes introduction, has Song menu

Opt("TrayAutoPause", 0)
Opt("OnExitFunc", "write")

HotKeySet("!s", "seek")
HotKeySet("{MEDIA_NEXT}", "SnNext")
HotKeySet("{MEDIA_PREV}", "SnPrevious")
HotKeySet("{MEDIA_PLAY_PAUSE}", "SnPlay")

$CURRENTVERSION = "2.1.7"

If @Compiled Then
	RunWait(@ScriptDir & "\MPUpdater.exe", @ScriptDir)
EndIf

If IniRead(@ScriptDir & "\MediaPlayerData.data", "Main", "2.1.7", 1) = 1 Then
	FileDelete(@ScriptDir & "\MPUpdater.exe")
	FileInstall("H:\Au3 Programs\MPUpdater.exe", @ScriptDir & "\MPUpdater.exe")
	IniWrite(@ScriptDir & "\MPInfo.data", "version", "number", $CURRENTVERSION)
	IniWrite(@ScriptDir & "\MediaPlayerData.data", "Main", "2.1.7", 0)
	FileInstall("H:\Au3 Programs\LibraryCleaner.exe", @ScriptDir & "\LibraryCleaner.exe")
	FileInstall("H:\Au3 Programs\MediaPlayer Help.doc", @ScriptDir & "\MediaPlayer Help.doc")
	If IniRead(@ScriptDir & "\MediaPlayerData.data", "Main", "First", 1) = 0 Then
		MsgBox(0, "MediaPlayer 2.1.7 Update", "Thank you for updating your copy of MediaPlayer. New features include:" & @CRLF & "	-Reads info from files even if they aren't in the library" & @CRLF & "	-New Library Cleaner to remove nonexistent files from library" & @CRLF & "	-Song menu (do things with the song that is selected in the List)" & @CRLF & "	-And much more!")
	EndIf
EndIf

If IniRead(@ScriptDir & "\MediaPlayerData.data", "Main", "First", 1) = 1 Then
	MsgBox(0, "Welcome to MediaPlayer!", "MediaPlayer shall now Index the My Music folder to create a library.")
	$a1 = _FileListToArrayEx(@MyDocumentsDir & "\My Music", "*.mp3", 1, ' ', True)
	$a2 = _FileListToArrayEx(@MyDocumentsDir & "\My Music", "*.wma", 1, ' ', True)
	$added = _AddArrays($a1, $a2)
	If IsArray($added) Then
		IndexDirectory(@MyDocumentsDir & "\My Music")
		_IniSort(@ScriptDir & "\Years.data")
		_IniSort(@ScriptDir & "\Genres.data")
		_IniSort(@ScriptDir & "\GroupNames.data")
		_IniSort(@ScriptDir & "\AlbumTitles.data")
	Else
		If MsgBox(4, "Error", "No MP3 Files were detected in your My Music folder. Would you like to specify another directory with MP3 files?") = 6 Then
			IndexDirectory(FileSelectFolder("Select a folder containing MP3 or WMA files.", ""))
			_IniSort(@ScriptDir & "\Years.data")
			_IniSort(@ScriptDir & "\Genres.data")
			_IniSort(@ScriptDir & "\GroupNames.data")
			_IniSort(@ScriptDir & "\AlbumTitles.data")
		Else
			Exit
		EndIf
	EndIf
	IniWrite(@ScriptDir & "\MediaPlayerData.data", "Main", "First", 0)
	Sleep(1000)
	FileInstall("H:\Au3 Programs\Scr1.JPG", @ScriptDir & "\Scr1.JPG")
	FileInstall("H:\Au3 Programs\Scr2.JPG", @ScriptDir & "\Scr2.JPG")
	If MsgBox(4, "MediaPlayer", "Would you like a short introduction to MediaPlayer?") = 6 Then
		MsgBox(0, "Choosing Songs", "To play a song in the list, you can either use the back-forward buttons, or you can click on it and then click on ""Sound Name""")
		SplashImageOn("MediaPlayer Introduction", @ScriptDir & "\Scr1.JPG")
		Sleep(4000)
		SplashOff()
		MsgBox(0, "Song Information", "To find out more information about a song, hover your mouse over the ""Now Playing"" label.")
		SplashImageOn("MediaPlayer Introduction", @ScriptDir & "\Scr2.JPG")
		Sleep(4000)
		SplashOff()
		MsgBox(0, "MediaPlayer Introduction", "You have completed the MediaPlayer introduction! For more in-depth information on how to use MediaPlayer, consult the Help file in the Help menu.")
	EndIf
	IniWrite(@ScriptDir & "\MPInfo.data", "version", "number", $CURRENTVERSION)
EndIf

$display = ""
$filetype = ""
$counter = ""
$prevcounter = ""
$volume = _SoundGetWaveVolume()
$nowplaying = ""
$seekbar = ""
$aud = ""
$list = "null"
$readfrom = "null"
$random = 0
$audstatus = "null"
$songlist = _ArrayCreate("")
$fullpaths = _ArrayCreate("")
$hiding = 0
$x = 0
$m = 0
$x2 = 0
$prevmsg = 0
$Button1 = ""
$menuitemsexist = 0
$songs = "null"
Global $ButtonExit
Global $listentoartist = "null"
Global $listentoalbum = "null"
Global $listentogenre = "null"
Global $listentoyear = "null"
Global $SearchAdd = "n"
Global $SearchExit = "n"
Global $SearchButton = "n"
Global $SearchListView = "n"
Global $SearchInput = "n"
Global $listexists = 0
Global $types
Global $inputspec
Global $songs
Global $ButtonAdd
Global $ButtonCancel
Global $c = 0
Global $listprev = "d"
Global $repeat = 0
Global $searching = 0
$chmen = 0
SoundSetWaveVolume($volume)

$tr_play = TrayCreateItem("Play/Pause")
$tr_next = TrayCreateItem("Next")
$tr_previous = TrayCreateItem("Previous")
$tr_vol = TrayCreateItem("Volume " & $volume)
$tr_hide = TrayCreateItem("Hide")

If FileExists(@ScriptDir & "\Songs2.data") = 0 Then
	$filenum = 1
ElseIf FileExists(@ScriptDir & "\Songs3.data") = 0 Then
	$filenum = 2
ElseIf FileExists(@ScriptDir & "\Songs4.data") = 0 Then
	$filenum = 3
ElseIf FileExists(@ScriptDir & "\Songs5.data") = 0 Then
	$filenum = 4
ElseIf FileExists(@ScriptDir & "\Songs6.data") = 0 Then
	$filenum = 5
ElseIf FileExists(@ScriptDir & "\Songs7.data") = 0 Then
	$filenum = 6
ElseIf FileExists(@ScriptDir & "\Songs8.data") = 0 Then
	$filenum = 7
ElseIf FileExists(@ScriptDir & "\Songs9.data") = 0 Then
	$filenum = 8
ElseIf FileExists(@ScriptDir & "\Songs10.data") = 0 Then
	$filenum = 9
Else
	$filenum = 10
EndIf

#Region ### START Koda GUI section ### Form=g:\applications\koda formdesigner\forms\soundplay.kxf
$Form1_1 = GUICreate("MediaPlayer", 442, 326)
$file = GUICtrlCreateMenu("File")
$fileopenmenu = GUICtrlCreateMenu("Open...", $file)
$listcontrolsmenu = GUICtrlCreateMenu("List...", $file)
$indexingmenu = GUICtrlCreateMenu("Index...", $file)
$fileopen = GUICtrlCreateMenuItem("Open File", $fileopenmenu)
$loaddir = GUICtrlCreateMenuItem("Load Directory", $fileopenmenu)
$savefile = GUICtrlCreateMenuItem("Save File", $file)
$syncfolders = GUICtrlCreateMenuItem("Sync Folders", $file)
$clearlist = GUICtrlCreateMenuItem("Clear List", $listcontrolsmenu)
$indexlist = GUICtrlCreateMenuItem("Index List", $indexingmenu)
$indexdir = GUICtrlCreateMenuItem("Index Directory", $indexingmenu)
$cleanlibrary = GUICtrlCreateMenuItem("Clean Library", $indexingmenu)
;$directory = GUICtrlCreateMenuItem("Directory", $file)
GUICtrlCreateMenuItem("", $file)
$hide = GUICtrlCreateMenuItem("Hide", $file)
GUICtrlCreateMenuItem("", $file)
$openplaylist = GUICtrlCreateMenuItem("Open Playlist", $file)
$saveplaylist = GUICtrlCreateMenuItem("Save Playlist", $file)
$playmenu = GUICtrlCreateMenu("Play")
$songm = GUICtrlCreateMenu("Song")
$remvfromlist = GUICtrlCreateMenuItem("Remove from List", $songm)
$opendir = GUICtrlCreateMenuItem("Open Containing Directory", $songm)
$getinfo = GUICtrlCreateMenuItem("Info...", $songm)
$delete = GUICtrlCreateMenuItem("Delete", $songm)
$ctrl_random = GUICtrlCreateMenuItem("Random (Off)", $playmenu)
$ctrl_repeat = GUICtrlCreateMenuItem("Repeat One (Off)", $playmenu)
$ctrl_playtype = GUICtrlCreateMenuItem("Play Type", $playmenu)
$ctrl_addsongs = GUICtrlCreateMenuItem("Add Songs", $playmenu)
$ctrl_searchdb = GUICtrlCreateMenuItem("Search Library", $playmenu)
$help = GUICtrlCreateMenu("Help")
$about = GUICtrlCreateMenuItem("About", $help)
$helpf = GUICtrlCreateMenuItem("Help", $help)

$submGenres = GUICtrlCreateMenu("Genres", $playmenu)
$submYears = GUICtrlCreateMenu("Years", $playmenu)
$submAlbums = GUICtrlCreateMenu("Albums", $playmenu)
$submArtists = GUICtrlCreateMenu("Artists", $playmenu)

Global Const $WM_ENTERMENULOOP = 0x0211
Global Const $WM_EXITMENULOOP = 0x0212
GUIRegisterMsg($WM_ENTERMENULOOP, "EnterMenu")
GUIRegisterMsg($WM_EXITMENULOOP, "ExitMenu")

ListArtists()
ListYears()
ListAlbums()
ListGenres()

$playpause = GUICtrlCreateButton("|>||", 193, 240, 65, 49)
GUICtrlSetTip(-1, "Not started")
$ctrl_next = GUICtrlCreateButton("|>|>|", 265, 248, 65, 33)
$previous = GUICtrlCreateButton("|<|<|", 119, 248, 65, 33)
$main = GUICtrlCreateGroup("", 111, 224, 225, 73)
$vol = GUICtrlCreateButton("Volume " & $volume, 350, 251, 80)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;graphic
If IniRead(@ScriptDir & "\MediaPlayerData.data", "Skins", "SkinName", "Classic") = "Onyx" Then
	$rgtime = TimerInit()
	AdlibEnable("Graphics", 80)
	GUISetBkColor(0x000000, $Form1_1)
	$next = 0
	$title = WinGetTitle("")
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $aud
			
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cleanlibrary
			Run(@ScriptDir & "\LibraryCleaner.exe", @ScriptDir)
		Case $opendir
			If GUICtrlRead($list) <> 0 Then
				$read = SBMs(GUICtrlRead(GUICtrlRead($list)), 1)
				$Asearch = _ArraySearch($songlist, $read)
				If $Asearch <> -1 Then
					ShellExecute(getdir($fullpaths[$Asearch]))
				EndIf
			EndIf
		Case $getinfo
			If GUICtrlRead($list) <> 0 Then
				$read = SBMs(GUICtrlRead(GUICtrlRead($list)), 1)
				$Asearch = _ArraySearch($songlist, $read)
				If $Asearch <> -1 Then
					$file = $fullpaths[$Asearch]
					$artist = _FindInfo($file, "Group Name")
					$album = _FindInfo($file, "Album Title")
					$genre = _FindInfo($file, "Genre")
					$year = _FindInfo($file, "Year")
					MsgBox(0, $file & " info", "Artist: " & $artist & @CRLF & "Album: " & $album & @CRLF & "Genre: " & $genre & @CRLF & "Year: " & $year)
				EndIf
			EndIf
		Case $delete
			If GUICtrlRead($list) <> 0 Then
				$read = SBMs(GUICtrlRead(GUICtrlRead($list)), 1)
				$Asearch = _ArraySearch($songlist, $read)
				$file = $fullpaths[$Asearch]
				$msgb = MsgBox(3, "Delete File?", "Would you like to delete the file from your hard drive as well as your computer?")
				If $msgb = 6 Then
					FileDelete($file)
				ElseIf $msgb = 7 Then
					$cont = 1
				Else
					$cont = 0
				EndIf
				If $cont Then
					For $i = 1 To $filenum
						$SArray = IniReadSectionNames(@ScriptDir & "\Songs" & $i & ".data")
						If _ArraySearch($SArray, $file) <> -1 Then
							ExitLoop
						EndIf
					Next
					IniDelete(@ScriptDir & "\Songs" & $i & ".data", $file)
					$artist = _FindInfo($file, "Group Name")
					$album = _FindInfo($file, "Album Title")
					$genre = _FindInfo($file, "Genre")
					$year = _FindInfo($file, "Year")
					$Dgenreread = SectionToArray("Genres", $genre)
					$Dsearch = _ArraySearch($Dgenreread, $file)
					If $Dsearch <> -1 Then
						IniDelete(@ScriptDir & "\Genres.data", $genre, $Dsearch)
						For $z = $Dsearch + 1 To $Dgenreread[0]
							$read = IniRead(@ScriptDir & "\Genres.data", $genre, $z, "nofile")
							IniWrite(@ScriptDir & "\Genres.data", $genre, $z - 1, $read)
						Next
						IniDelete(@ScriptDir & "\Genres.data", $genre, $Dgenreread[0])
						IniWrite(@ScriptDir & "\Genres.data", $genre, "Number", $Dgenreread[0] - 1)
					EndIf
					$Dyearread = SectionToArray("Year", $year)
					$Dsearch = _ArraySearch($Dyearread, $file)
					If $Dsearch <> -1 Then
						IniDelete(@ScriptDir & "\Years.data", $year, $Dsearch)
						For $z = $Dsearch + 1 To $Dyearread[0]
							$read = IniRead(@ScriptDir & "\Years.data", $year, $z, "nofile")
							IniWrite(@ScriptDir & "\Years.data", $year, $z - 1, $read)
						Next
						IniDelete(@ScriptDir & "\Years.data", $year, $Dyearread[0])
						IniWrite(@ScriptDir & "\Years.data", $year, "Number", $Dyearread[0] - 1)
					EndIf
					$Dartistread = SectionToArray("GroupNames", $artist)
					$Dsearch = _ArraySearch($Dartistread, $file)
					If $Dsearch <> -1 Then
						IniDelete(@ScriptDir & "\GroupNames.data", $artist, $Dsearch)
						For $z = $Dsearch + 1 To $Dartistread[0]
							$read = IniRead(@ScriptDir & "\GroupNames.data", $artist, $z, "nofile")
							IniWrite(@ScriptDir & "\GroupNames.data", $artist, $z - 1, $read)
						Next
						IniDelete(@ScriptDir & "\GroupNames.data", $artist, $Dartistread[0])
						IniWrite(@ScriptDir & "\GroupNames.data", $artist, "Number", $Dartistread[0] - 1)
					EndIf
					$Dalbumread = SectionToArray("AlbumTitles", $album)
					$Dsearch = _ArraySearch($Dalbumread, $file)
					If $Dsearch <> -1 Then
						IniDelete(@ScriptDir & "\AlbumTitles.data", $album, $Dsearch)
						For $z = $Dsearch + 1 To $Dartistread[0]
							$read = IniRead(@ScriptDir & "\AlbumTitles.data", $album, $z, "nofile")
							IniWrite(@ScriptDir & "\AlbumTitles.data", $album, $z - 1, $read)
						Next
						IniDelete(@ScriptDir & "\AlbumTitles.data", $album, $Dalbumread[0])
						IniWrite(@ScriptDir & "\AlbumTitles.data", $album, "Number", $Dalbumread[0] - 1)
					EndIf
				EndIf
			EndIf
		Case $ctrl_searchdb
			SearchLib()
		Case $clearlist
			$x = 0
			$x2 = 0
			GUICtrlDelete($list)
			$list = GUICtrlCreateListView("Sound Name|Artist", 32, 10, 380, 180)
			_GUICtrlListView_SetColumnWidth ($list, 0, 266)
			_GUICtrlListView_SetColumnWidth ($list, 1, 109)
		Case $indexdir
			$idr = FileSelectFolder("Select the directory to index.", "")
			IndexDirectory($idr)
			_IniSort(@ScriptDir & "\Years.data")
			_IniSort(@ScriptDir & "\Genres.data")
			_IniSort(@ScriptDir & "\GroupNames.data")
			_IniSort(@ScriptDir & "\AlbumTitles.data")
			MsgBox(0, "Directory indexed.", "The directory you selected has been indexed. It is recommeneded that you restart MediaPlayer to apply library changes.")
		Case $ButtonExit
			GUIDelete($Form2)
		Case $about
			MsgBox(0, "About MediaPlayer", "MediaPlayer (c) 2007 Banana Fred Software" & @CRLF & "Visit our website at www.bananafredsoft.com" & @CRLF & "Help and support at bananafred@gmail.com" & @CRLF & "You are currently nunning MediaPlayer " & $CURRENTVERSION & @CRLF & "Icon by Holly :)")
		Case $helpf
			ShellExecute(@ScriptDir & "\MediaPlayer Help.doc")
		Case $ctrl_next
			SnNext()
		Case $fileopen
			$opendialog = FileOpenDialog("Open Media File", "", "All Media Files (*.avi;*.JPG;*.jpeg;*.bmp;*.mp3;*.wav;*.wma)|Audio Files (*.mp3;*.wav;*.wma)|Image Files (*.JPG;*.jpg;*.jpeg;*.bmp)|Video Files (*.avi)")
			If BitOR(StringRight($opendialog, 3) = "mp3", StringRight($opendialog, 3) = "wav", StringRight($opendialog, 3) = "wma") Then
				GUICtrlDelete($nowplaying)
				GUICtrlDelete($display)
				GUICtrlDelete($counter)
				GUICtrlDelete($seekbar)
				Global $prevcounter = ""
				Global $readfrom = $opendialog
				Global $filetype = "audio"
				Global $display = ""
				Global $aud = _SoundOpen($readfrom)
				Global $audstatus = "not started"
				If $listexists = 0 Then
					Global $list = GUICtrlCreateListView("Sound Name|Artist", 32, 10, 380, 180)
					_GUICtrlListView_SetColumnWidth ($list, 0, 266)
					_GUICtrlListView_SetColumnWidth ($list, 1, 109)
					$listexists = 1
				EndIf
				_ArrayAdd($songlist, "")
				$x += 1
				$x2 += 1
				Global $split2 = StringSplit($readfrom, "\")
				Global $nf = $split2[$split2[0]]
				Global $nextfile = $nf
				$songlist[$x] = $nf
				_ArrayAdd($fullpaths, $readfrom)
				$fullpaths[$x2] = $readfrom
				GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($readfrom, "Group Name"), "%null%", "Unknown"), $list)
				Global $snum = _ArraySearch($songlist, $split2[$split2[0]])
				Global $counter = GUICtrlCreateLabel(Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)), 7, 250, 100)
				GUICtrlSetFont(-1, 16)
				If _FindInfo($readfrom, "Song Name") <> "%null%" Then
					Global $nowp = _FindInfo($readfrom, "Song Name")
				Else
					Global $nowp = $nextfile
				EndIf
				Global $nowplaying = GUICtrlCreateLabel("Now Playing: " & $nowp, 15, 200, 200, 30)
				GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
				Global $seekbar = GUICtrlCreateSlider(215, 200, 200, 20)
				GUICtrlSetLimit(-1, _SoundLength($aud, 2) / 1000, 0)
				Global $nf = $nextfile
				;GUICTrlsetData($directory, StringTrimRight(getdir($readfrom), 1))
				MenuItems()
			ElseIf BitOR(StringRight($opendialog, 3) = "JPG", StringRight($opendialog, 3) = "jpg", StringRight($opendialog, 4) = "jpeg", StringRight($opendialog, 3) = "bmp") Then
				ControlDeletes()
				$readfrom = $opendialog
				$filetype = "image"
				$display = GUICtrlCreatePic($readfrom, 81, 10, 280, 210)
			ElseIf StringRight($opendialog, 3) = "avi" Then
				ControlDeletes()
				$readfrom = $opendialog
				$filetype = "video"
				mciSendString ("close Test_Video")
				mciSendString ("open " & FileGetShortName($readfrom) & " alias Test_Video")
				mciSendString ("window Test_Video handle " & Number($Form1_1)) ;assign video to our GUI
				mciSendString ("put Test_Video destination at 81 10 280 210") ;set top left width height
				mciSendString ("play Test_Video")
				$vidstatus = "play"
			EndIf

		Case $playpause
			SnPlay()
		Case $remvfromlist
			If GUICtrlRead($list) <> 0 Then
				$search = _ArraySearch($songlist, SBMs(GUICtrlRead(GUICtrlRead($list)), 1))
				_ArrayDelete($songlist, $search)
				_ArrayDelete($fullpaths, $search)
				GUICtrlDelete(GUICtrlRead($list))
				$x -= 1
				$x2 -= 1
				$prevmsg = TimerInit()
			EndIf
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $savefile
			$opendialog = FileSaveDialog("Save As...", "", "All Files (*.*)")
			If FileExists($opendialog) Then
				$split = StringSplit($readfrom, ".")
				FileCopy($readfrom, $opendialog & "." & $split[$split[0]])
			EndIf
		Case $ctrl_playtype
			PlayIndiv()
		Case $previous
			If _SoundPos($aud) <> "00:00:00" Then
				SnPrevious()
			Else
				If $filetype = "audio" Then
					_SoundClose($aud)
					If $snum = 0 Then
						$snum = $x
						$nf = $songlist[$snum]
					Else
						$snum -= 1
						$nf = $songlist[$snum]
					EndIf
					$readfrom = $fullpaths[_ArraySearch($songlist, $nf) ]
					$aud = _SoundOpen($readfrom)
					_GUICtrlListView_SetItemSelected ($list, $snum, 1)
					If $audstatus = "playing" Then
						_SoundPlay($aud)
					Else
						$audstatus = "not started"
					EndIf
					If _FindInfo($readfrom, "Song Name") <> "%null%" Then
						Global $nowp = _FindInfo($readfrom, "Song Name")
					Else
						Global $nowp = $nf
					EndIf
					GUICtrlSetData($nowplaying, 'Now Playing: ' & $nowp)
					GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
					$state = WinGetState("MediaPlayer")
					If BitAND($state, 16) Then
						TrayTip($nf, Shorten(_SoundLength($aud, 1)) & @CRLF & _FindInfo($readfrom, "Group Name") & @CRLF & _FindInfo($readfrom, "Album Title"), 4)
					EndIf
					GUICtrlSetLimit($seekbar, _SoundLength($aud, 2) / 1000, 0)
					MenuItems()
				EndIf
			EndIf
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $ctrl_addsongs
			AddIndiv()
		Case $listentoyear
			OpenType("Years", _FindInfo($readfrom, "Year"))
		Case $saveplaylist
			$saveto = FileSaveDialog("Save Playlist", "", "MediaPlayer Playlists (*.mpp)")
			If $saveto <> "" Then
				$spcount = 0
				Do
					IniWrite($saveto & ".mpp", "Songs", $spcount, $fullpaths[$spcount])
					$spcount += 1
				Until $spcount = $x2
				IniWrite($saveto & ".mpp", "Songs", "Number", $x2)
			EndIf
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $vol
			$mainpos = WinGetPos("MediaPlayer")
			$volgui = GUICreate("Volume", 200, 60, $mainpos[0] + 470, $mainpos[1] + 254)
			$slider = GUICtrlCreateSlider(20, 20, 160, 20)
			GUICtrlSetData(-1, $volume)
			GUICtrlSetLimit(-1, 100, 0)
			GUISetState(@SW_SHOW)
			GUISwitch($volgui)
			
			Do
				$msg2 = GUIGetMsg()
				$winpos = WinGetPos("Volume")
				If $msg2 = $slider Then
					SoundSetWaveVolume(GUICtrlRead($slider))
					$volume = GUICtrlRead($slider)
					GUICtrlSetData($vol, "Volume " & $volume)
				EndIf
				$vguicoords = GUIGetCursorInfo($volgui)
				If IsArray($vguicoords) Then
					If $vguicoords[4] = $slider Then
						ToolTip(GUICtrlRead($slider), MouseGetPos(0) - 20, MouseGetPos(1) - 20)
					Else
						ToolTip("")
					EndIf
				EndIf
				GUICtrlSetTip($slider, GUICtrlRead($slider))
			Until $msg2 = $GUI_EVENT_CLOSE
			GUIDelete($volgui)
			GUISwitch($Form1_1)
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $listentogenre
			OpenType("Genres", _FindInfo($readfrom, "Genre"))
		Case $openplaylist
			OpenPlaylist()
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $list
			_SoundClose($aud)
			$nf = SBMs(GUICtrlRead(GUICtrlRead($list)), 1)
			$snum = _ArraySearch($songlist, $nf)
			$readfrom = $fullpaths[$snum]
			$aud = _SoundOpen($readfrom)
			_GUICtrlListView_SetItemSelected ($list, $snum, 1)
			If $audstatus = "playing" Then
				_SoundPlay($aud)
			Else
				$audstatus = "not started"
			EndIf
			$state = WinGetState("MediaPlayer")
			If _FindInfo($readfrom, "Song Name") <> "%null%" Then
				Global $nowp = _FindInfo($readfrom, "Song Name")
			Else
				Global $nowp = $nf
			EndIf
			GUICtrlSetData($nowplaying, 'Now Playing: ' & $nowp)
			GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
			GUICtrlSetLimit($seekbar, _SoundLength($aud, 2) / 1000, 0)
			MenuItems()
		Case $syncfolders
			SyncFolders()
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $listentoalbum
			OpenType("AlbumTitles", _FindInfo($readfrom, "Album Title"))
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $ctrl_random
			If $random = 1 Then
				$random = 0
				GUICtrlSetData($ctrl_random, "Random (Off)")
			Else
				$random = 1
				GUICtrlSetData($ctrl_random, "Random (On)")
				$repeat = 0
				GUICtrlSetData($ctrl_repeat, "Repeat One (Off)")
			EndIf
		Case $ctrl_repeat
			If $repeat = 1 Then
				$repeat = 0
				GUICtrlSetData($ctrl_repeat, "Repeat One (Off)")
			Else
				$repeat = 1
				GUICtrlSetData($ctrl_repeat, "Repeat One (On)")
				$random = 0
				GUICtrlSetData($ctrl_random, "Random (Off)")
			EndIf
		Case $hide
			Hide()
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $listentoartist
			OpenType("GroupNames", _FindInfo($readfrom, "Group Name"))
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $loaddir
			OpenDir()
			$prevmsg = TimerInit()
		Case $indexlist
			IndexList()
	EndSwitch
	Switch $nMsg
		Case $aud
			
		Case $inputspec
			If GUICtrlRead($types) = "Artist" Then
				$typeread = "GroupNames"
			ElseIf GUICtrlRead($types) = "Album" Then
				$typeread = "AlbumTitles"
			ElseIf GUICtrlRead($types) = "Year" Then
				$typeread = "Years"
			ElseIf GUICtrlRead($types) = "Genre" Then
				$typeread = "Genres"
			Else
				$typeread = "null"
			EndIf
			If $typeread <> "null" Then
				GUICtrlDelete($songs)
				$songs = GUICtrlCreateListView("Songs                                    ", 8, 40, 281, 137)
				$fullpaths2 = _ArrayCreate("")
				$conts = _ArrayCreate("")
				$readsection = IniReadSection(@ScriptDir & "\" & $typeread & ".data", GUICtrlRead($inputspec))
				For $count = 0 To IniRead(@ScriptDir & "\" & $typeread & ".data", GUICtrlRead($inputspec), "Number", 1)
					$ready = IniRead(@ScriptDir & "\" & $typeread & ".data", GUICtrlRead($inputspec), $count, "")
					_ArrayAdd($fullpaths2, $ready)
					_ArrayAdd($conts, GUICtrlCreateListViewItem(StringReplace($ready, getdir($ready), ""), $songs))
				Next
				$count += 1
			EndIf
		Case $seekbar
			$hr = (GUICtrlRead($seekbar) - Mod(GUICtrlRead($seekbar), 3600)) / 3600
			$min = (GUICtrlRead($seekbar) - Mod(GUICtrlRead($seekbar), 60)) / 60
			$sec = Mod(GUICtrlRead($seekbar), 60)
			$s = _SoundSeek($aud, $hr, $min, $sec)
			_SoundPlay($aud)
		Case $ButtonAdd
			If $audstatus <> "playing" Then
				GUISwitch($Form1_1)
				GUICtrlDelete($nowplaying)
				GUICtrlDelete($display)
				GUICtrlDelete($counter)
				GUICtrlDelete($seekbar)
				Global $prevcounter = ""
				Global $readfrom = $fullpaths2[_ArraySearch($conts, GUICtrlRead($songs)) ]
				Global $filetype = "audio"
				Global $display = ""
				_SoundClose($aud)
				Global $aud = _SoundOpen($readfrom)
				Global $audstatus = "not started"
				If $listexists = 0 Then
					Global $list = GUICtrlCreateListView("Sound Name|Artist", 32, 10, 380, 180)
					_GUICtrlListView_SetColumnWidth ($list, 0, 266)
					_GUICtrlListView_SetColumnWidth ($list, 1, 109)
					$listexists = 1
				EndIf
				_ArrayAdd($songlist, "")
				$x += 1
				$x2 += 1
				Global $split2 = StringSplit($readfrom, "\")
				Global $nf = $split2[$split2[0]]
				Global $nextfile = $nf
				$songlist[$x] = $nf
				_ArrayAdd($fullpaths, $readfrom)
				$fullpaths[$x2] = $readfrom
				GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($readfrom, "Group Name"), "%null%", "Unknown"), $list)
				Global $snum = _ArraySearch($songlist, $split2[$split2[0]])
				Global $counter = GUICtrlCreateLabel(Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)), 7, 250, 100)
				GUICtrlSetFont(-1, 16)
				If _FindInfo($readfrom, "Song Name") <> "%null%" Then
					Global $nowp = _FindInfo($readfrom, "Song Name")
				Else
					Global $nowp = $nextfile
				EndIf
				Global $nowplaying = GUICtrlCreateLabel("Now Playing: " & $nowp, 15, 200, 200, 30)
				GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
				Global $seekbar = GUICtrlCreateSlider(215, 200, 200, 20)
				GUICtrlSetLimit(-1, _SoundLength($aud, 2) / 1000, 0)
				Global $nf = $nextfile
				;GUICTrlsetData($directory, StringTrimRight(getdir($readfrom), 1))
				MenuItems()
				GUISwitch($Form4)
				$nMsg = 0
			Else
				_ArrayAdd($songlist, "")
				$x += 1
				$x2 += 1
				$songlist[$x] = GUICtrlRead(GUICtrlRead($songs))
				_ArrayAdd($fullpaths, "")
				$fullpaths[$x2] = $fullpaths2[_ArraySearch($conts, GUICtrlRead($songs)) ]
				GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($fullpaths[$x2], "Group Name"), "%null%", "Unknown"), $list)
			EndIf
		Case $ButtonCancel
			GUIDelete($Form4)
	EndSwitch
	If $searching = 1 Then
		Switch $nMsg
			Case $aud
				
			Case $SearchExit
				$searching = 0
				GUIDelete($SearchDB)
			Case $SearchButton
				$pos = WinGetPos("")
				_GUICtrlListView_DeleteAllItems ($SearchListView)
				SplashTextOn("Searching - MediaPlayer", "MediaPlayer is searching your library...", 400, 30, $pos[0] + (($pos[2] / 2) - 200), $pos[1] + (($pos[3] / 2) - 15))
				$sartists = IniReadSectionNames(@ScriptDir & "\GroupNames.data")
				$salbums = IniReadSectionNames(@ScriptDir & "\AlbumTitles.data")
				$songsZ = _ArrayCreate(0)
				For $p = 1 To $filenum
					$sarray = IniReadSectionNames(@ScriptDir & "\Songs" & $p & ".data")
					For $q = 1 To $sarray[0]
						_ArrayAdd($songsZ, $sarray[$q])
						$songsZ[0] += 1
					Next
				Next
				$songtitles = _ArrayCreate(0)
				For $p = 1 To $songsZ[0]
					_ArrayAdd($songtitles, _FindInfo($songsZ[$p], "Song Name"))
				Next
				$songtitles[0] = $songsZ[0]
				$results = _ArrayCreate(0)
				$resultstype = _ArrayCreate(0)
				For $p = 1 To $songtitles[0]
					If StringInStr($songtitles[$p], GUICtrlRead($SearchInput)) Then
						_ArrayAdd($results, $songsZ[$p])
						$results[0] += 1
						_ArrayAdd($resultstype, "Song")
					EndIf
				Next
				For $p = 1 To $sartists[0]
					If StringInStr($sartists[$p], GUICtrlRead($SearchInput)) Then
						_ArrayAdd($results, $sartists[$p])
						$results[0] += 1
						_ArrayAdd($resultstype, "Artist")
					EndIf
				Next
				For $p = 1 To $salbums[0]
					If StringInStr($salbums[$p], GUICtrlRead($SearchInput)) Then
						_ArrayAdd($results, $salbums[$p])
						$results[0] += 1
						_ArrayAdd($resultstype, "Album")
					EndIf
				Next
				SplashOff()
				$carray = _ArrayCreate(0)
				For $p = 1 To $results[0]
					If FileExists($results[$p]) Then
						$resultfiltered = StringReplace($results[$p], getdir($results[$p]), "")
					Else
						$resultfiltered = $results[$p]
					EndIf
					GUISwitch($SearchDB)
					$ca = GUICtrlCreateListViewItem($resultstype[$p] & ": " & $resultfiltered, $SearchListView)
					GUISwitch($Form1_1)
					_ArrayAdd($carray, $ca)
				Next
			Case $SearchAdd
				$searching = 0
				If GUICtrlRead($SearchListView) <> 0 Then
					$resultnum = _ArraySearch($carray, GUICtrlRead($SearchListView))
					Switch $resultstype[$resultnum]
						Case "Album"
							GUIDelete($SearchDB)
							OpenType("AlbumTitles", $results[$resultnum])
						Case "Artist"
							GUIDelete($SearchDB)
							OpenType("GroupNames", $results[$resultnum])
						Case "Song"
							GUIDelete($SearchDB)
							If $audstatus <> "playing" Then
								GUISwitch($Form1_1)
								GUICtrlDelete($nowplaying)
								GUICtrlDelete($display)
								GUICtrlDelete($counter)
								GUICtrlDelete($seekbar)
								Global $prevcounter = ""
								Global $readfrom = $results[$resultnum]
								Global $filetype = "audio"
								Global $display = ""
								_SoundClose($aud)
								Global $aud = _SoundOpen($readfrom)
								Global $audstatus = "not started"
								If $listexists = 0 Then
									Global $list = GUICtrlCreateListView("Sound Name|Artist", 32, 10, 380, 180)
									_GUICtrlListView_SetColumnWidth ($list, 0, 266)
									_GUICtrlListView_SetColumnWidth ($list, 1, 109)
									$listexists = 1
								EndIf
								_ArrayAdd($songlist, "")
								$x += 1
								$x2 += 1
								Global $split2 = StringSplit($readfrom, "\")
								Global $nf = $split2[$split2[0]]
								Global $nextfile = $nf
								$songlist[$x] = $nf
								_ArrayAdd($fullpaths, $readfrom)
								$fullpaths[$x2] = $readfrom
								GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($readfrom, "Group Name"), "%null", "Unknown"), $list)
								Global $snum = _ArraySearch($songlist, $split2[$split2[0]])
								Global $counter = GUICtrlCreateLabel(Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)), 7, 250, 100)
								GUICtrlSetFont(-1, 16)
								If _FindInfo($readfrom, "Song Name") <> "%null%" Then
									Global $nowp = _FindInfo($readfrom, "Song Name")
								Else
									Global $nowp = $nextfile
								EndIf
								Global $nowplaying = GUICtrlCreateLabel("Now Playing: " & $nowp, 15, 200, 200, 30)
								GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
								Global $seekbar = GUICtrlCreateSlider(215, 200, 200, 20)
								GUICtrlSetLimit(-1, _SoundLength($aud, 2) / 1000, 0)
								Global $nf = $nextfile
								;GUICTrlsetData($directory, StringTrimRight(getdir($readfrom), 1))
								MenuItems()
								$nMsg = 0
							Else
								_ArrayAdd($songlist, "")
								$x += 1
								$x2 += 1
								$songlist[$x] = StringReplace($results[$resultnum], getdir($results[$resultnum]), "")
								_ArrayAdd($fullpaths, "")
								$fullpaths[$x2] = $results[$resultnum]
								GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($results[$resultnum], "Group name"), "%null%", "Unknown"), $list)
							EndIf
					EndSwitch
				EndIf
		EndSwitch
	EndIf
	Switch $nMsg
		Case $aud
			
		Case $Button1
			Select
				Case GUICtrlRead($Radio1) = $GUI_CHECKED
					$read = GUICtrlRead($Input1)
					GUIDelete($Form2)
					GUISwitch($Form1_1)
					OpenType("Years", $read)
				Case GUICtrlRead($Radio2) = $GUI_CHECKED
					$read = GUICtrlRead($Input1)
					GUIDelete($Form2)
					GUISwitch($Form1_1)
					OpenType("GroupNames", $read)
				Case GUICtrlRead($Radio3) = $GUI_CHECKED
					$read = GUICtrlRead($Input1)
					GUIDelete($Form2)
					GUISwitch($Form1_1)
					OpenType("AlbumTitles", BR($read))
				Case GUICtrlRead($Radio4) = $GUI_CHECKED
					$read = GUICtrlRead($Input1)
					GUIDelete($Form2)
					GUISwitch($Form1_1)
					OpenType("Genres", $read)
			EndSelect
	EndSwitch
	If TimerDiff($chmen) < 4000 Then
	For $m = 0 To $conttypearraygens[0]
		If $nMsg = 0 Then
			
		ElseIf BitAND($nMsg = $conttypearraygens[$m], TimerDiff($prevmsg) > 1000) Then
			OpenType("Genres", $sectionnamearraygens[$m])
		EndIf
	Next
	For $m = 0 To $conttypearraygrps[0]
		If $nMsg = 0 Then
			
		ElseIf BitAND($nMsg = $conttypearraygrps[$m], TimerDiff($prevmsg) > 1000) Then
			OpenType("GroupNames", $sectionnamearraygrps[$m])
		EndIf
	Next
	For $m = 0 To $conttypearrayalbs[0]
		If $nMsg = 0 Then
			
		ElseIf BitAND($nMsg = $conttypearrayalbs[$m], TimerDiff($prevmsg) > 1000) Then
			OpenType("AlbumTitles", BR($sectionnamearrayalbs[$m]))
		EndIf
	Next
	For $m = 0 To $conttypearrayyers[0]
		If $nMsg = 0 Then
			
		ElseIf BitAND($nMsg = $conttypearrayyers[$m], TimerDiff($prevmsg) > 1000) Then
			OpenType("Years", $sectionnamearrayyers[$m])
		EndIf
	Next
	EndIf
	$tmsg = TrayGetMsg()
	Switch $tmsg
		Case $tr_next
			SnNext()
		Case $tr_previous
			SnPrevious()
		Case $tr_play
			SnPlay()
		Case $tr_hide
			Hide()
		Case $tr_vol
			$volgui = GUICreate("Volume", 200, 60, @DesktopWidth - 230, @DesktopHeight - 130)
			$slider = GUICtrlCreateSlider(20, 20, 160, 20)
			GUICtrlSetData(-1, $volume)
			GUICtrlSetLimit(-1, 100, 0)
			GUISetState(@SW_SHOW)
			GUISwitch($volgui)
			
			Do
				$msg2 = GUIGetMsg()
				If $msg2 = $slider Then
					SoundSetWaveVolume(GUICtrlRead($slider))
					$volume = GUICtrlRead($slider)
					GUICtrlSetData($vol, "Volume " & $volume)
					TrayItemSetText($tr_vol, "Volume " & $volume)
				EndIf
			Until $msg2 = $GUI_EVENT_CLOSE
			GUIDelete($volgui)
			GUISwitch($Form1_1)
	EndSwitch
	If $filetype = "audio" Then
		If Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)) <> $prevcounter Then
			GUICtrlSetData($counter, Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)))
			$prevcounter = Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1))
			TraySetToolTip($nowp & " - " & _FindInfo($readfrom, "Group Name") & " (" & Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)) & ")")
			If $audstatus = "playing" Then
				GUICtrlSetData($seekbar, _SoundPos($aud, 2) / 1000)
			EndIf
		EndIf
	EndIf
	If $filetype = "audio" Then
		If _SoundPos($aud, 2) = _SoundLength($aud, 2) Then
			If $audstatus = "playing" Then
				_SoundClose($aud)
				If BitAND($random = 0, $repeat = 0) Then
					If $snum = $x Then
						$snum = 0
					Else
						$snum += 1
					EndIf
				ElseIf $random = 1 Then
					$snum = Random(0, $x, 1)
				ElseIf $repeat = 1 Then
					$snum = $snum
				EndIf
				_GUICtrlListView_SetItemSelected ($list, $snum, 1)
				$nf = $songlist[$snum]
				$readfrom = $fullpaths[$snum]
				$aud = _SoundOpen($readfrom)
				If $audstatus = "playing" Then
					_SoundPlay($aud)
				Else
					$audstatus = "not started"
				EndIf
				$state = WinGetState("MediaPlayer")
				TrayTip($nf, Shorten(_SoundLength($aud, 1)) & @CRLF & _FindInfo($readfrom, "Group Name") & @CRLF & _FindInfo($readfrom, "Album Title"), 4)
				If _FindInfo($readfrom, "Song Name") <> "%null%" Then
					Global $nowp = _FindInfo($readfrom, "Song Name")
				Else
					Global $nowp = $nf
				EndIf
				GUICtrlSetData($nowplaying, 'Now Playing: ' & $nowp)
				GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
				GUICtrlSetLimit($seekbar, _SoundLength($aud, 2) / 1000, 0)
				MenuItems()
			EndIf
		EndIf
	EndIf
	If $filetype = "video" Then
		mciSendString ("set Test_Video time format milliseconds")
		If mciSendString ("status Test_Video position") = mciSendString ("status Test_Video length") Then mciSendString ("seek Test_Video to 0")
		mciSendString ("play Test_Video")
		$vidstatus = "play"
	EndIf
WEnd

Func Shorten($string)
	If StringLeft($string, 4) = "00:0" Then
		Return StringTrimLeft($string, 4)
	ElseIf StringLeft($string, 3) = "00:" Then
		Return StringTrimLeft($string, 3)
	ElseIf StringLeft($string, 1) = "0" Then
		Return StringTrimLeft($string, 1)
	EndIf
EndFunc   ;==>Shorten

Func seek()
	If $filetype = "audio" Then
		$input = InputBox("Seek", "Enter in HH:MM:SS format or MM:SS format.", "", "", 200, 150)
		$split = StringSplit($input, ":")
		If $split[0] = 3 Then
			_SoundSeek($aud, $split[1], $split[2], $split[3])
		ElseIf $split[0] = 2 Then
			_SoundSeek($aud, 0, $split[1], $split[2])
		EndIf
		_SoundPlay($aud)
	EndIf
EndFunc   ;==>seek

Func getdir($filename)
	$split = StringSplit($filename, "\")
	If Not @error Then
		$dir = ""
		$num = 1
		Do
			$dir &= $split[$num] & "\"
			$num += 1
		Until $num = $split[0]
		Return $dir
	EndIf
EndFunc   ;==>getdir

Func SnNext()
	If $filetype = "audio" Then
		_SoundClose($aud)
		If $random = 1 Then
			$snum = Random(0, $x, 1)
			$nf = $songlist[$snum]
		ElseIf BitOR($snum = $x, $snum > $x) Then
			$snum = 0
			$nf = $songlist[$snum]
		Else
			$snum += 1
			$nf = $songlist[$snum]
		EndIf
		_GUICtrlListView_SetItemSelected ($list, $snum, 1)
		$readfrom = $fullpaths[_ArraySearch($songlist, $nf) ]
		$aud = _SoundOpen($readfrom)
		If $audstatus = "playing" Then
			_SoundPlay($aud)
		Else
			$audstatus = "not started"
		EndIf
		If _FindInfo($readfrom, "Song Name") <> "%null%" Then
			Global $nowp = _FindInfo($readfrom, "Song Name")
		Else
			Global $nowp = $nf
		EndIf
		GUICtrlSetData($nowplaying, 'Now Playing: ' & $nowp)
		GUICtrlSetTip($nowplaying, "Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year"))
		$state = WinGetState("MediaPlayer")
		If BitAND($state, 16) Then
			TrayTip($nf, Shorten(_SoundLength($aud, 1)) & @CRLF & _FindInfo($readfrom, "Group Name") & @CRLF & _FindInfo($readfrom, "Album Title"), 4)
		EndIf
		GUICtrlSetLimit($seekbar, _SoundLength($aud, 2) / 1000, 0)
	EndIf
	MenuItems()
EndFunc   ;==>SnNext

Func SnPrevious()
	_SoundStop($aud)
	_SoundPlay($aud)
	$audstatus = "playing"
EndFunc   ;==>SnPrevious

Func SnPlay()
	If $filetype = "audio" Then
		If $audstatus = "not started" Then ;not started
			_SoundPlay($aud)
			$audstatus = "playing"
			GUICtrlSetTip($playpause, "Playing")
		ElseIf $audstatus = "paused" Then ;paused
			_SoundResume($aud)
			$audstatus = "playing"
			GUICtrlSetTip($playpause, "Playing")
		ElseIf $audstatus = "playing" Then ;playing
			_SoundPause($aud)
			$audstatus = "paused"
			GUICtrlSetTip($playpause, "Paused")
		EndIf
	ElseIf $filetype = "video" Then
		If $vidstatus = "play" Then
			mciSendString ("pause Test_Video")
			$vidstatus = "pause"
		ElseIf $vidstatus = "pause" Then
			mciSendString ("play Test_Video")
			$vidstatus = "play"
		EndIf
	EndIf
EndFunc   ;==>SnPlay

Func write()
	IniWrite(@ScriptDir & "\MediaPlayerData.data", "Previous", "Volume", $volume)
EndFunc   ;==>write

Func ControlDeletes()
	GUICtrlDelete($list)
	GUICtrlDelete($nowplaying)
	GUICtrlDelete($seekbar)
	GUICtrlDelete($counter)
	GUICtrlDelete($display)
	$listexists = 0
EndFunc   ;==>ControlDeletes

Func SyncFolders()
	If MsgBox(4, "MediaPlayer", "Would you like to synchronize two folders?") = 6 Then
		$synchronizefolder = FileSelectFolder("Select the folder to synchronize.", "")
		$originalfolder = FileSelectFolder("Select the folder to synchronize it with.", "")
		DirCopy($originalfolder, $synchronizefolder, 0)
		$firstfileinsync = FileFindFirstFile($synchronizefolder & "\*.*")
		Do
			$nextfileinsync = FileFindNextFile($firstfileinsync)
			If FileExists($originalfolder & "\" & $nextfileinsync) = 0 Then
				FileDelete($synchronizefolder & "\" & $nextfileinsync)
			EndIf
		Until @error
	EndIf
EndFunc   ;==>SyncFolders

Func Hide()
	If $hiding = 0 Then
		$hiding = 1
		GUICtrlSetData($hide, "Show")
		TrayItemSetText($tr_hide, "Show")
		GUISetState(@SW_HIDE, $Form1_1)
	Else
		$hiding = 0
		GUICtrlSetData($hide, "Hide")
		TrayItemSetText($tr_hide, "Hide")
		GUISetState(@SW_SHOW, $Form1_1)
	EndIf
EndFunc   ;==>Hide

Func OpenDir()
	$opendialog = FileOpenDialog("Load Music", "", "Music Files (*.mp3;*.wav)")
	If $opendialog <> "" Then
		ControlDeletes()
		Global $prevcounter = ""
		Global $readfrom = $opendialog
		Global $filetype = "audio"
		Global $display = ""
		Global $aud = _SoundOpen($readfrom)
		Global $audstatus = "not started"
		Global $list = GUICtrlCreateListView("Sound Name|Artist", 32, 10, 380, 180)
		_GUICtrlListView_SetColumnWidth ($list, 0, 266)
		_GUICtrlListView_SetColumnWidth ($list, 1, 109)
		$listexists = 1
		Global $folderfile = FileFindFirstFile(getdir($readfrom) & "*." & StringRight($readfrom, 3))
		Global $x = 0
		Global $x2 = 0
		Do
			_ArrayAdd($songlist, "")
			$songlist[$x] = FileFindNextFile($folderfile)
			$error = @error
			_ArrayAdd($fullpaths, "")
			$fullpaths[$x2] = getdir($readfrom) & $songlist[$x]
			GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($fullpaths[$x2], "Group Name"), "%null%", "Unknown"), $list)
			$x += 1
			$x2 += 1
		Until $error
		Global $split2 = StringSplit($readfrom, "\")
		Global $nf = $split2[$split2[0]]
		Global $nextfile = $nf
		Global $snum = _ArraySearch($songlist, $split2[$split2[0]])
		Global $counter = GUICtrlCreateLabel(Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)), 7, 250, 100)
		GUICtrlSetFont(-1, 16)
		If _FindInfo($readfrom, "Song Name") <> "%null%" Then
			Global $nowp = _FindInfo($readfrom, "Song Name")
		Else
			Global $nowp = $nextfile
		EndIf
		Global $nowplaying = GUICtrlCreateLabel("Now Playing: " & $nowp, 15, 200, 200, 30)
		GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
		Global $seekbar = GUICtrlCreateSlider(215, 200, 200, 20)
		GUICtrlSetLimit(-1, _SoundLength($aud, 2) / 1000, 0)
		Global $nf = $nextfile
		;GUICTrlsetData($directory, StringTrimRight(getdir($readfrom), 1))
		MenuItems()
	EndIf
EndFunc   ;==>OpenDir

Func IndexList()
	$msg = MsgBox(4, "Index List", "Would you like the list to be automatically indexed?")
	Global $split3 = StringSplit($readfrom, "\")
	Global $yearprv = ""
	Global $albtitleprv = $split3[$split3[0] - 1]
	Global $groupnameprv = ""
	Global $genreprv = ""
	Global $inum = 0
	Global $exitloop = 0
	If $msg = 6 Then
		ProgressOn("Indexing...", "0%")
	EndIf
	Do
		If $songlist[$inum] <> "" Then
			#cs
				$array1 = _ID3TagToArray ($fullpaths[$inum], 1, "TIT2|TALB|TPE1|TYER|APIC")
				If IsArray($array1) Then
				If $array1[0] > 6 Then
				$Asplit = StringSplit($array1[1], "|")
				If $Asplit[0] = 2 Then
				$songname = $Asplit[2]
				EndIf
				$Asplit = StringSplit($array1[2], "|")
				If $Asplit[0] = 2 Then
				If $Asplit[2] <> "" Then
				$groupname = $Asplit[2]
				Else
				$groupname = $groupnameprv
				EndIf
				EndIf
				$Asplit = StringSplit($array1[3], "|")
				If $Asplit[0] = 2 Then
				If $Asplit[2] <> "" Then
				$albumtitle = $Asplit[2]
				Else
				$albumtitle = $albtitleprv
				EndIf
				EndIf
				$Asplit = StringSplit($array1[4], "|")
				If $Asplit[0] = 2 Then
				If $Asplit[2] <> "" Then
				$year = $Asplit[2]
				Else
				$year = $yearprv
				EndIf
				EndIf
				$Asplit = StringSplit($array1[7], "|")
				If $Asplit[0] = 2 Then
				If $Asplit[2] <> "" Then
				$genre = $Asplit[2]
				Else
				$genre = $genreprv
				EndIf
				EndIf
				Else
				$genre = 'Unknown Genre'
				$year = 'Unknown Year'
				$groupname = 'Unknown Artist'
				$songname = 'Unknown Song'
				$albumtitle = 'Unknown Album'
				EndIf
				Else
				$genre = 'Unknown Genre'
				$year = 'Unknown Year'
				$groupname = 'Unknown Artist'
				$songname = 'Unknown Song'
				$albumtitle = 'Unknown Album'
				EndIf
			#ce
			$readingfrom = $fullpaths[$inum]
			$genreread = _GetExtProperty($readingfrom, 20)
			;If $genreread = 0 Then
			;	$genre = "Unknown Genre"
			;Else
			$genre = $genreread
			;EndIf
			$artistread = _GetExtProperty($readingfrom, 16)
			;If $artistreaderead = 0 Then
			;	$groupname = "Unknown Artist"
			;Else
			$groupname = $artistread
			;EndIf
			$albumread = _GetExtProperty($readingfrom, 17)
			;If $albumread = 0 Then
			;	$albumtitle = "Unknown Album"
			;Else
			$albumtitle = $albumread
			;EndIf
			$yearread = _GetExtProperty($readingfrom, 18)
			;If $yearread = 0 Then
			;	$year = "Unknown Year"
			;Else
			$year = $yearread
			;EndIf
			$titleread = _GetExtProperty($readingfrom, 10)
			;If $titleread = 0 Then
			;	$songname = "Unknown Song"
			;Else
			$songname = $titleread
			;EndIf
			#Region ### START Koda GUI section ### Form=
			$Form1 = GUICreate("Index", 229, 197, 193, 115)
			GUISwitch($Form1)
			$Label1 = GUICtrlCreateLabel("Year:", 8, 12, 29, 17)
			Global $inpYear = GUICtrlCreateInput($year, 40, 8, 177, 21)
			$Label2 = GUICtrlCreateLabel("Album Title:", 8, 40, 59, 17)
			Global $inpAlbumTitle = GUICtrlCreateInput($albumtitle, 72, 40, 145, 21)
			$Label3 = GUICtrlCreateLabel("Group Name:", 8, 72, 67, 17)
			Global $inpGroupName = GUICtrlCreateInput($groupname, 80, 72, 137, 21)
			$Label4 = GUICtrlCreateLabel("Song Name:", 8, 104, 63, 17)
			Global $inpSongName = GUICtrlCreateInput($songname, 80, 104, 137, 21)
			$Label5 = GUICtrlCreateLabel("Music Genre:", 8, 136, 67, 17)
			Global $inpGenre = GUICtrlCreateInput($genre, 80, 136, 137, 21)
			$btnNext = GUICtrlCreateButton("Next", 8, 168, 73, 25, 0)
			GUICtrlSetState(-1, $GUI_DEFBUTTON)
			$btnFinished = GUICtrlCreateButton("Finished", 88, 168, 65, 25, 0)
			$btnCancel = GUICtrlCreateButton("Cancel", 160, 168, 65, 25, 0)
			If $msg = 7 Then
				GUISetState(@SW_SHOW)
			Else
				GUISetState(@SW_HIDE)
			EndIf
			#EndRegion ### END Koda GUI section ###

			While 1
				$nMsg = GUIGetMsg()
				If $msg = 6 Then $nMsg = $btnNext
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						$exitloop = 1
						GUIDelete($Form1)
						ExitLoop
					Case $btnNext
						ProgressSet(Round(($inum / $x2) * 100), "", Round(($inum / $x2) * 100) & "%")
						Writes()
						$inum += 1
						GUIDelete($Form1)
						ExitLoop
					Case $btnFinished
						Writes()
						$exitloop = 1
						GUIDelete($Form1)
						GUISwitch($Form1_1)
						ExitLoop
					Case $btnCancel
						$exitloop = 1
						GUIDelete($Form1)
						GUISwitch($Form1_1)
						ExitLoop
				EndSwitch
			WEnd
		EndIf
	Until BitOR($exitloop = 1, $inum = $x + 1)
	ProgressOff()
	GUISwitch($Form1_1)
EndFunc   ;==>IndexList

Func Writes()
	$reas = SectionToArray("Years", GUICtrlRead($inpYear))
	If _ArraySearch($reas, $fullpaths[$inum]) = -1 Then
		IniWrite(@ScriptDir & "\Years.data", GUICtrlRead($inpYear), IniRead(@ScriptDir & "\Years.data", GUICtrlRead($inpYear), "Number", -1) + 1, $fullpaths[$inum])
		IniWrite(@ScriptDir & "\Years.data", GUICtrlRead($inpYear), "Number", IniRead(@ScriptDir & "\Years.data", GUICtrlRead($inpYear), "Number", -1) + 1)
	EndIf
	$reas = SectionToArray("Genres", GUICtrlRead($inpGenre))
	If _ArraySearch($reas, $fullpaths[$inum]) = -1 Then
		IniWrite(@ScriptDir & "\Genres.data", GUICtrlRead($inpGenre), IniRead(@ScriptDir & "\Genres.data", GUICtrlRead($inpGenre), "Number", -1) + 1, $fullpaths[$inum])
		IniWrite(@ScriptDir & "\Genres.data", GUICtrlRead($inpGenre), "Number", IniRead(@ScriptDir & "\Genres.data", GUICtrlRead($inpGenre), "Number", -1) + 1)
	EndIf
	$reas = SectionToArray("GroupNames", GUICtrlRead($inpGroupName))
	If _ArraySearch($reas, $fullpaths[$inum]) = -1 Then
		IniWrite(@ScriptDir & "\GroupNames.data", GUICtrlRead($inpGroupName), IniRead(@ScriptDir & "\GroupNames.data", GUICtrlRead($inpGroupName), "Number", -1) + 1, $fullpaths[$inum])
		IniWrite(@ScriptDir & "\GroupNames.data", GUICtrlRead($inpGroupName), "Number", IniRead(@ScriptDir & "\GroupNames.data", GUICtrlRead($inpGroupName), "Number", -1) + 1)
	EndIf
	$reas = SectionToArray("AlbumTitles", GUICtrlRead($inpAlbumTitle))
	If _ArraySearch($reas, $fullpaths[$inum]) = -1 Then
		IniWrite(@ScriptDir & "\AlbumTitles.data", GUICtrlRead($inpAlbumTitle), IniRead(@ScriptDir & "\AlbumTitles.data", GUICtrlRead($inpAlbumTitle), "Number", -1) + 1, $fullpaths[$inum])
		IniWrite(@ScriptDir & "\AlbumTitles.data", GUICtrlRead($inpAlbumTitle), "Number", IniRead(@ScriptDir & "\AlbumTitles.data", GUICtrlRead($inpAlbumTitle), "Number", -1) + 1)
	EndIf
	_IniSort(@ScriptDir & "\Years.data")
	_IniSort(@ScriptDir & "\Genres.data")
	_IniSort(@ScriptDir & "\GroupNames.data")
	_IniSort(@ScriptDir & "\AlbumTitles.data")
	If IniRead(@ScriptDir & "\Songs1.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(1, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs2.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(2, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs3.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(3, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs4.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(4, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs5.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(5, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs6.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(6, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs7.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(7, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs8.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(8, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs9.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(9, $fullpaths[$inum])
	ElseIf IniRead(@ScriptDir & "\Songs10.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex(10, $fullpaths[$inum])
	EndIf
	$yearprv = GUICtrlRead($inpYear)
	$albtitleprv = GUICtrlRead($inpAlbumTitle)
	$groupnameprv = GUICtrlRead($inpGroupName)
	$genreprv = GUICtrlRead($inpGenre)
EndFunc   ;==>Writes

Func IndivSongIndex($num, $filep)
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Year", GUICtrlRead($inpYear))
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Genre", GUICtrlRead($inpGenre))
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Album Title", GUICtrlRead($inpAlbumTitle))
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Song Name", GUICtrlRead($inpSongName))
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Group Name", GUICtrlRead($inpGroupName))
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", "Other", "Number", IniRead(@ScriptDir & "\Songs" & $num & ".data", "Other", "Number", 0) + 1)
EndFunc   ;==>IndivSongIndex

Func _FindInfo($filename, $info)
	$songsN = 1
	Do
		$next = IniRead(@ScriptDir & "\Songs" & $songsN & ".data", $filename, $info, "%null%")
		If $next <> "%null%" Then
			Return $next
		EndIf
		$songsN += 1
	Until $songsN = 10
	If $info = "Group Name" Then
		$iReadz = 16
	ElseIf $info = "Song Name" Then
		$iReadz = 10
	ElseIf $info = "Album Title" Then
		$iReadz = 17
	ElseIf $info = "Year" Then
		$iReadz = 18
	ElseIf $info = "Genre" Then
		$iReadz = 20
	EndIf
	$iReadz2 = _GetExtProperty($filename, $iReadz)
	Return $iReadz2
EndFunc   ;==>_FindInfo

Func OpenType($type, $name)
	ControlDeletes()
	Global $prevcounter = ""
	Global $filetype = "audio"
	$readfrom = IniRead(@ScriptDir & "\" & $type & ".data", $name, 0, "")
	Global $display = ""
	_SoundClose($aud)
	Global $aud = _SoundOpen($readfrom)
	Global $audstatus = "not started"
	Global $list = GUICtrlCreateListView("Sound Name|Artist", 32, 10, 380, 180)
	_GUICtrlListView_SetColumnWidth ($list, 0, 266)
	_GUICtrlListView_SetColumnWidth ($list, 1, 109)
	$listexists = 1
	Global $x = 0
	Global $x2 = 0
	Do
		_ArrayAdd($songlist, "")
		_ArrayAdd($fullpaths, "")
		$songlist[$x] = StringReplace(IniRead(@ScriptDir & "\" & $type & ".data", $name, $x, ""), getdir(IniRead(@ScriptDir & "\" & $type & ".data", $name, $x, "")), "")
		$fullpaths[$x2] = IniRead(@ScriptDir & "\" & $type & ".data", $name, $x, "")
		If $songlist[$x] <> "" Then
			GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($fullpaths[$x2], "Group Name"), "%null%", "Unknown"), $list)
		EndIf
		$x += 1
		$x2 += 1
	Until $x > IniRead(@ScriptDir & "\" & $type & ".data", $name, "Number", 1)
	Global $split2 = StringSplit($readfrom, "\")
	Global $nf = $split2[$split2[0]]
	Global $nextfile = $nf
	Global $snum = _ArraySearch($songlist, $split2[$split2[0]])
	Global $counter = GUICtrlCreateLabel(Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)), 7, 250, 100)
	GUICtrlSetFont(-1, 16)
	If _FindInfo($readfrom, "Song Name") <> "%null%" Then
		Global $nowp = _FindInfo($readfrom, "Song Name")
	Else
		Global $nowp = $nextfile
	EndIf
	Global $nowplaying = GUICtrlCreateLabel("Now Playing: " & $nowp, 15, 200, 200, 30)
	GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
	Global $seekbar = GUICtrlCreateSlider(215, 200, 200, 20)
	GUICtrlSetLimit(-1, _SoundLength($aud, 2) / 1000, 0)
	Global $nf = $nextfile
	;GUICTrlsetData($directory, StringTrimRight(getdir($readfrom), 1))
	MenuItems()
EndFunc   ;==>OpenType

Func PlayIndiv()
	#include <GUIConstants.au3>

	#Region ### START Koda GUI section ### Form=
	Global $Form2 = GUICreate("Play Type", 253, 64, 193, 115, $WS_POPUP)
	GUISwitch($Form2)
	Global $Radio1 = GUICtrlCreateRadio("Year", 8, 8, 49, 17)
	Global $Radio2 = GUICtrlCreateRadio("Artist", 59, 8, 49, 17)
	Global $Radio3 = GUICtrlCreateRadio("Album", 110, 8, 57, 17)
	Global $Radio4 = GUICtrlCreateRadio("Genre", 169, 8, 57, 17)
	Global $Input1 = GUICtrlCreateInput("", 7, 35, 166, 21)
	Global $Button1 = GUICtrlCreateButton("Play", 181, 32, 70, 25, 0)
	Global $ButtonExit = GUICtrlCreateButton("x", 233, 0, 20, 20)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
EndFunc   ;==>PlayIndiv

Func OpenPlaylist()
	$opend = FileOpenDialog("Open Playlist", "", "MediaPlayer Playlists (*.mpp)")
	If $opend <> "" Then
		ControlDeletes()
		Global $prevcounter = ""
		Global $filetype = "audio"
		$readfrom = IniRead($opend, "Songs", 0, "")
		Global $display = ""
		_SoundClose($aud)
		Global $aud = _SoundOpen($readfrom)
		Global $audstatus = "not started"
		Global $list = GUICtrlCreateListView("Sound Name|Artist", 32, 10, 380, 180)
		_GUICtrlListView_SetColumnWidth ($list, 0, 266)
		_GUICtrlListView_SetColumnWidth ($list, 1, 109)
		$listexists = 1
		Global $x = 0
		Global $x2 = 0
		Do
			_ArrayAdd($songlist, "")
			_ArrayAdd($fullpaths, "")
			$songlist[$x] = StringReplace(IniRead($opend, "Songs", $x, ""), getdir(IniRead($opend, "Songs", $x, "")), "")
			$fullpaths[$x2] = IniRead($opend, "Songs", $x2, "")
			If $songlist[$x] <> "" Then
				GUICtrlCreateListViewItem($songlist[$x] & "|" & StringReplace(_FindInfo($fullpaths[$x2], "Group Name"), "%null%", "Unknown"), $list)
			EndIf
			$x += 1
			$x2 += 1
		Until $x = IniRead($opend, "Songs", "Number", 1)
		Global $split2 = StringSplit($readfrom, "\")
		Global $nf = $split2[$split2[0]]
		Global $nextfile = $nf
		Global $snum = _ArraySearch($songlist, $split2[$split2[0]])
		Global $counter = GUICtrlCreateLabel(Shorten(_SoundPos($aud, 1)) & "/" & Shorten(_SoundLength($aud, 1)), 7, 250, 100)
		GUICtrlSetFont(-1, 16)
		If _FindInfo($readfrom, "Song Name") <> "%null%" Then
			Global $nowp = _FindInfo($readfrom, "Song Name")
		Else
			Global $nowp = $nextfile
		EndIf
		Global $nowplaying = GUICtrlCreateLabel("Now Playing: " & $nowp, 15, 200, 200, 30)
		GUICtrlSetTip($nowplaying, P("Artist: " & _FindInfo($readfrom, "Group Name") & @CRLF & "Album: " & _FindInfo($readfrom, "Album Title") & @CRLF & "Year: " & _FindInfo($readfrom, "Year")))
		Global $seekbar = GUICtrlCreateSlider(215, 200, 200, 20)
		GUICtrlSetLimit(-1, _SoundLength($aud, 2) / 1000, 0)
		Global $nf = $nextfile
		MenuItems()
	EndIf
EndFunc   ;==>OpenPlaylist

Func P($string)
	Return StringReplace($string, "%null%", "Unknown")
EndFunc   ;==>P

Func ListAlbums()
	Global $sectionnamearrayalbs = IniReadSectionNames(@ScriptDir & "\AlbumTitles.data")
	Global $conttypearrayalbs = _ArrayCreate(0)
	$i = 1
	For $i = 1 To $sectionnamearrayalbs[0]
		_ArrayAdd($conttypearrayalbs, GUICtrlCreateMenuItem(RP($sectionnamearrayalbs[$i]), $submAlbums))
	Next
	$conttypearrayalbs[0] = $sectionnamearrayalbs[0]
EndFunc   ;==>ListAlbums

Func ListGenres()
	Global $sectionnamearraygens = IniReadSectionNames(@ScriptDir & "\Genres.data")
	Global $conttypearraygens = _ArrayCreate("")
	$i = 1
	For $i = 1 To $sectionnamearraygens[0]
		_ArrayAdd($conttypearraygens, GUICtrlCreateMenuItem($sectionnamearraygens[$i], $submGenres))
	Next
	$conttypearraygens[0] = $sectionnamearraygens[0]
EndFunc   ;==>ListGenres

Func ListYears()
	Global $sectionnamearrayyers = IniReadSectionNames(@ScriptDir & "\Years.data")
	Global $conttypearrayyers = _ArrayCreate("")
	$i = 1
	For $i = 1 To $sectionnamearrayyers[0]
		_ArrayAdd($conttypearrayyers, GUICtrlCreateMenuItem($sectionnamearrayyers[$i], $submYears))
	Next
	$conttypearrayyers[0] = $sectionnamearrayyers[0]
EndFunc   ;==>ListYears

Func ListArtists()
	Global $sectionnamearraygrps = IniReadSectionNames(@ScriptDir & "\GroupNames.data")
	Global $conttypearraygrps = _ArrayCreate("")
	$i = 1
	For $i = 1 To $sectionnamearraygrps[0]
		_ArrayAdd($conttypearraygrps, GUICtrlCreateMenuItem($sectionnamearraygrps[$i], $submArtists))
	Next
	$conttypearraygrps[0] = $sectionnamearraygrps[0]
EndFunc   ;==>ListArtists

Func _IniSort($hIni)
	Local $aIRSN = IniReadSectionNames($hIni)
	If Not IsArray($aIRSN) Then Return SetError(1, 0, 0)
	_ArraySort($aIRSN, 0, 1)
	Local $aKey, $sHold
	For $iCC = 1 To UBound($aIRSN) - 1
		Local $aIRS = IniReadSection($hIni, $aIRSN[$iCC])
		If Not IsArray($aIRS) Then ContinueLoop
		For $xCC = 1 To $aIRS[0][0]
			$aKey &= $aIRS[$xCC][0] & Chr(1)
		Next
		If $aKey Then
			$aKey = StringSplit(StringTrimRight($aKey, 1), Chr(1))
			_ArraySort($aKey, 0, 1)
			$sHold &= '[' & $aIRSN[$iCC] & ']' & @CRLF
			For $aCC = 1 To UBound($aKey) - 1
				$sHold &= $aKey[$aCC] & '=' & IniRead($hIni, $aIRSN[$iCC], $aKey[$aCC], 'blahblah') & @CRLF
			Next
			$aKey = ''
		EndIf
	Next
	If $sHold Then
		$sHold = StringTrimRight($sHold, 2)
		FileClose(FileOpen($hIni, 2))
		FileWrite($hIni, $sHold)
		Return 1
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_IniSort

Func AddIndiv()
	#Region ### START Koda GUI section ### Form=
	$addingindiv = 1
	Global $Form4 = GUICreate("Enter", 299, 207, 193, 115, $WS_POPUP)
	$types = GUICtrlCreateCombo("Artist", 8, 8, 161, 25)
	_GUICtrlComboBox_AddString ($types, "Genre")
	_GUICtrlComboBox_AddString ($types, "Album")
	_GUICtrlComboBox_AddString ($types, "Year")
	$inputspec = GUICtrlCreateInput("", 176, 8, 113, 21)
	$songs = GUICtrlCreateListView("Songs                                    ", 8, 40, 281, 137)
	$ButtonAdd = GUICtrlCreateButton("Add", 8, 184, 97, 17, 0)
	$ButtonCancel = GUICtrlCreateButton("Exit", 112, 184, 89, 17, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	$prevmsg = TimerInit()
EndFunc   ;==>AddIndiv

Func IndexDirectory($dir)
	$lists = _AddArrays(_FileListToArrayEx($dir, "*.mp3", 1, ' ', True), _FileListToArrayEx($dir, "*.wma", 1, ' ', True))
	ProgressOn("Indexing...", "Indexing " & $dir, "0% Complete")
	For $numC = 1 To $lists[0]
		Writes2($lists[$numC])
		ProgressSet(Round(($numC / $lists[0]) * 100), Round(($numC / $lists[0]) * 100) & "% Complete")
	Next
	ProgressOff()
EndFunc   ;==>IndexDirectory

Func SectionToArray($file, $section)
	$array = _ArrayCreate("")
	$array[0] = IniRead(@ScriptDir & "\" & $file & ".data", $section, "Number", 1)
	For $num2 = 0 To $array[0]
		_ArrayAdd($array, IniRead(@ScriptDir & "\" & $file & ".data", $section, $num2, ""))
	Next
	Return $array
EndFunc   ;==>SectionToArray


Func _FileListToArrayEx($sPath, $sFilter = '*.*', $iFlag = 0, $sExclude = '', $iRecurse = False)
	If Not FileExists($sPath) Then Return SetError(1, 1, '')
	If $sFilter = -1 Or $sFilter = Default Then $sFilter = '*.*'
	If $iFlag = -1 Or $iFlag = Default Then $iFlag = 0
	If $sExclude = -1 Or $sExclude = Default Then $sExclude = ''
	Local $aBadChar[6] = ['\', '/', ':', '>', '<', '|']
	$sFilter = StringRegExpReplace($sFilter, '\s*;\s*', ';')
	If StringRight($sPath, 1) <> '\' Then $sPath &= '\'
	For $iCC = 0 To 5
		If StringInStr($sFilter, $aBadChar[$iCC]) Or _
				StringInStr($sExclude, $aBadChar[$iCC]) Then Return SetError(2, 2, '')
	Next
	If StringStripWS($sFilter, 8) = '' Then Return SetError(2, 2, '')
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, '')
	Local $oFSO = ObjCreate("Scripting.FileSystemObject"), $sTFolder
	$sTFolder = $oFSO.GetSpecialFolder (2)
	Local $hOutFile = @TempDir & $oFSO.GetTempName
	If Not StringInStr($sFilter, ';') Then $sFilter &= ';'
	Local $aSplit = StringSplit(StringStripWS($sFilter, 8), ';'), $sRead, $sHoldSplit
	For $iCC = 1 To $aSplit[0]
		If StringStripWS($aSplit[$iCC], 8) = '' Then ContinueLoop
		If StringLeft($aSplit[$iCC], 1) = '.' And _
				UBound(StringSplit($aSplit[$iCC], '.')) - 2 = 1 Then $aSplit[$iCC] = '*' & $aSplit[$iCC]
		$sHoldSplit &= '"' & $sPath & $aSplit[$iCC] & '" '
	Next
	$sHoldSplit = StringTrimRight($sHoldSplit, 1)
	If $iRecurse Then
		RunWait(@ComSpec & ' /c dir /b /s /a ' & $sHoldSplit & ' > "' & $hOutFile & '"', '', @SW_HIDE)
	Else
		RunWait(@ComSpec & ' /c dir /b /a ' & $sHoldSplit & ' /o-e /od > "' & $hOutFile & '"', '', @SW_HIDE)
	EndIf
	$sRead &= FileRead($hOutFile)
	If Not FileExists($hOutFile) Then Return SetError(4, 4, '')
	FileDelete($hOutFile)
	If StringStripWS($sRead, 8) = '' Then SetError(4, 4, '')
	Local $aFSplit = StringSplit(StringTrimRight(StringStripCR($sRead), 1), @LF)
	Local $sHold
	For $iCC = 1 To $aFSplit[0]
		If $sExclude And StringLeft($aFSplit[$iCC], _
				StringLen(StringReplace($sExclude, '*', ''))) = StringReplace($sExclude, '*', '') Then ContinueLoop
		Switch $iFlag
			Case 0
				If StringRegExp($aFSplit[$iCC], '\w:\\') = 0 Then
					$sHold &= $sPath & $aFSplit[$iCC] & Chr(1)
				Else
					$sHold &= $aFSplit[$iCC] & Chr(1)
				EndIf
			Case 1
				If StringInStr(FileGetAttrib($sPath & '\' & $aFSplit[$iCC]), 'd') = 0 And _
						StringInStr(FileGetAttrib($aFSplit[$iCC]), 'd') = 0 Then
					If StringRegExp($aFSplit[$iCC], '\w:\\') = 0 Then
						$sHold &= $sPath & $aFSplit[$iCC] & Chr(1)
					Else
						$sHold &= $aFSplit[$iCC] & Chr(1)
					EndIf
				EndIf
			Case 2
				If StringInStr(FileGetAttrib($sPath & '\' & $aFSplit[$iCC]), 'd') Or _
						StringInStr(FileGetAttrib($aFSplit[$iCC]), 'd') Then
					If StringRegExp($aFSplit[$iCC], '\w:\\') = 0 Then
						$sHold &= $sPath & $aFSplit[$iCC] & Chr(1)
					Else
						$sHold &= $aFSplit[$iCC] & Chr(1)
					EndIf
				EndIf
		EndSwitch
	Next
	If StringTrimRight($sHold, 1) Then Return StringSplit(StringTrimRight($sHold, 1), Chr(1))
	Return SetError(4, 4, '')
EndFunc   ;==>_FileListToArrayEx

Func Writes2($file3)
	#cs
		$array1 = _ID3TagToArray ($file3, 1, "TIT2|TALB|TPE1|TYER|APIC")
		If IsArray($array1) Then
		If $array1[0] > 6 Then
		$Asplit = StringSplit($array1[1], "|")
		If $Asplit[0] = 2 Then
		Global $songname = $Asplit[2]
		Else
		Global $songname = 'Unknown Song'
		EndIf
		$Asplit = StringSplit($array1[2], "|")
		If $Asplit[0] = 2 Then
		If $Asplit[2] <> "" Then
		Global $groupname = $Asplit[2]
		Else
		Global $groupname = 'Unknown Group'
		EndIf
		EndIf
		$Asplit = StringSplit($array1[3], "|")
		If $Asplit[0] = 2 Then
		If $Asplit[2] <> "" Then
		Global $albumtitle = $Asplit[2]
		Else
		Global $albumtitle = 'Unknown Album'
		EndIf
		EndIf
		$Asplit = StringSplit($array1[4], "|")
		If $Asplit[0] = 2 Then
		If $Asplit[2] <> "" Then
		Global $year = $Asplit[2]
		Else
		Global $year = 'Unknown Year'
		EndIf
		EndIf
		$Asplit = StringSplit($array1[7], "|")
		If $Asplit[0] = 2 Then
		If $Asplit[2] <> "" Then
		Global $genre = $Asplit[2]
		Else
		Global $genre = 'Unknown Genre'
		EndIf
		EndIf
		Else
		$genre = 'Unknown Genre'
		$year = 'Unknown Year'
		$groupname = 'Unknown Artist'
		$songname = 'Unknown Song'
		$albumtitle = 'Unknown Album'
		EndIf
		Else
		$genre = 'Unknown Genre'
		$year = 'Unknown Year'
		$groupname = 'Unknown Artist'
		$songname = 'Unknown Song'
		$albumtitle = 'Unknown Album'
		EndIf
	#ce
	$readingfrom = $file3
	$genreread = _GetExtProperty($readingfrom, 20)
	;MsgBox(0, "", $genreread)
	;If $genreread <> 0 Then
	Global $genre = $genreread
	;Else
	;	Global $genre = "Unknown Genre"
	;EndIf
	$artistread = _GetExtProperty($readingfrom, 16)
	;MsgBox(0, "", $artistread)
	;If $artistread <> 0 Then
	Global $groupname = $artistread
	;Else
	;	Global $groupname = "Unknown Artist"
	;EndIf
	$albumread = _GetExtProperty($readingfrom, 17)
	;MsgBox(0, "", $albumread)
	;If $albumread <> 0 Then
	Global $albumtitle = $albumread
	;Else
	;	Global $albumtitle = "Unknown Album"
	;EndIf
	$yearread = _GetExtProperty($readingfrom, 18)
	;MsgBox(0, "", $yearread)
	;If $yearread <> 0 Then
	Global $year = $yearread
	;Else
	;	Global $year = "Unknown Year"
	;EndIf
	$titleread = _GetExtProperty($readingfrom, 10)
	;MsgBox(0, "", $titleread)
	;If $titleread <> 0 Then
	Global $songname = $titleread
	;Else
	;	Global $songname = "Unknown Song"
	;EndIf
	$reas = SectionToArray("Years", $year)
	If _ArraySearch($reas, $file3) = -1 Then
		IniWrite(@ScriptDir & "\Years.data", $year, IniRead(@ScriptDir & "\Years.data", $year, "Number", -1) + 1, $file3)
		IniWrite(@ScriptDir & "\Years.data", $year, "Number", IniRead(@ScriptDir & "\Years.data", $year, "Number", -1) + 1)
	EndIf
	$reas = SectionToArray("Genres", $genre)
	If _ArraySearch($reas, $file3) = -1 Then
		IniWrite(@ScriptDir & "\Genres.data", $genre, IniRead(@ScriptDir & "\Genres.data", $genre, "Number", -1) + 1, $file3)
		IniWrite(@ScriptDir & "\Genres.data", $genre, "Number", IniRead(@ScriptDir & "\Genres.data", $genre, "Number", -1) + 1)
	EndIf
	$reas = SectionToArray("GroupNames", $groupname)
	If _ArraySearch($reas, $file3) = -1 Then
		IniWrite(@ScriptDir & "\GroupNames.data", $groupname, IniRead(@ScriptDir & "\GroupNames.data", $groupname, "Number", -1) + 1, $file3)
		IniWrite(@ScriptDir & "\GroupNames.data", $groupname, "Number", IniRead(@ScriptDir & "\GroupNames.data", $groupname, "Number", -1) + 1)
	EndIf
	$reas = SectionToArray("AlbumTitles", $albumtitle)
	If _ArraySearch($reas, $file3) = -1 Then
		IniWrite(@ScriptDir & "\AlbumTitles.data", BR($albumtitle), IniRead(@ScriptDir & "\AlbumTitles.data", BR($albumtitle), "Number", -1) + 1, $file3)
		IniWrite(@ScriptDir & "\AlbumTitles.data", BR($albumtitle), "Number", IniRead(@ScriptDir & "\AlbumTitles.data", BR($albumtitle), "Number", -1) + 1)
	EndIf
	If IniRead(@ScriptDir & "\Songs1.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(1, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs2.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(2, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs3.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(3, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs4.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(4, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs5.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(5, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs6.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(6, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs7.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(7, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs8.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(8, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs9.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(9, $file3)
	ElseIf IniRead(@ScriptDir & "\Songs10.data", "Other", "Number", 0) <= 200 Then
		IndivSongIndex2(10, $file3)
	EndIf
EndFunc   ;==>Writes2

Func IndivSongIndex2($num, $filep)
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Year", $year)
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Genre", $genre)
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Album Title", $albumtitle)
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Song Name", $songname)
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", BR($filep), "Group Name", $groupname)
	IniWrite(@ScriptDir & "\Songs" & $num & ".data", "Other", "Number", IniRead(@ScriptDir & "\Songs" & $num & ".data", "Other", "Number", 0) + 1)
EndFunc   ;==>IndivSongIndex2

Func Graphics()
	;If WinActive($title) Then
	If $next = 1 Then
		$next = 0
		GUICtrlSetColor($counter, 0x888888)
		GUICtrlSetColor($nowplaying, 0x888888)
		GUICtrlSetBkColor($list, 0x000000)
		GUICtrlSetColor($list, 0x888888)
		GUICtrlSetBkColor($seekbar, 0x000000)
		_GUICtrlListView_SetColumnWidth ($list, 0, 0)
		_GUICtrlListView_SetColumnWidth ($list, 0, 266)
		_GUICtrlListView_SetColumnWidth ($list, 1, 109)
		$listprev = $list
	EndIf
	$m = GUIGetCursorInfo()
	If IsArray($m) Then
		Switch $m[4]
			Case $playpause
				If $c = 0 Then
					GUICtrlSetBkColor($playpause, 0x999999)
					$c = 1
				EndIf
			Case $ctrl_next
				If $c = 0 Then
					GUICtrlSetBkColor($ctrl_next, 0x999999)
					$c = 1
				EndIf
			Case $previous
				If $c = 0 Then
					GUICtrlSetBkColor($previous, 0x999999)
					$c = 1
				EndIf
			Case $vol
				If $c = 0 Then
					GUICtrlSetBkColor($vol, 0x999999)
					$c = 1
				EndIf
			Case Else
				If $c = 1 Then
					GUICtrlSetBkColor($ctrl_next, 0x666666)
					GUICtrlSetBkColor($previous, 0x666666)
					GUICtrlSetBkColor($playpause, 0x666666)
					GUICtrlSetBkColor($vol, 0x666666)
					$c = 0
				EndIf
		EndSwitch
	Else
		GUICtrlSetBkColor($ctrl_next, 0x666666)
		GUICtrlSetBkColor($previous, 0x666666)
		GUICtrlSetBkColor($playpause, 0x666666)
		$c = 0
	EndIf
	If BitOR($list <> $listprev, _GUICtrlListView_GetBkColor ($list) <> 0x000000) Then
		$next = 1
		GUICtrlSetColor($counter, 0x888888)
		GUICtrlSetColor($nowplaying, 0x888888)
		GUICtrlSetBkColor($list, 0x000000)
		GUICtrlSetColor($list, 0x888888)
		GUICtrlSetBkColor($seekbar, 0x000000)
		_GUICtrlListView_SetColumnWidth ($list, 0, 0)
		_GUICtrlListView_SetColumnWidth ($list, 0, 266)
		_GUICtrlListView_SetColumnWidth ($list, 1, 109)
		$listprev = $list
	EndIf
	;EndIf
EndFunc   ;==>Graphics

Func SearchLib()
	#Region ### START Koda GUI section ### Form=
	Global $searching = 1
	Global $SearchDB = GUICreate("Search MediaPlayer Library", 539, 404, 193, 115, $WS_POPUP)
	$SearchInput = GUICtrlCreateInput("", 8, 8, 441, 21)
	$SearchButton = GUICtrlCreateButton("Search", 456, 8, 73, 25, 0)
	$SearchListView = GUICtrlCreateListView("Results", 8, 40, 521, 320)
	_GUICtrlListView_SetColumnWidth ($SearchListView, 0, 500)
	$SearchAdd = GUICtrlCreateButton("Play", 8, 363, 530 / 2, 27)
	$SearchExit = GUICtrlCreateButton("Exit", 12 + 530 / 2, 363, (570 / 2) - 30, 27)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ##
EndFunc   ;==>SearchLib

Func EnterMenu()
	Return
EndFunc   ;==>EnterMenu

Func ExitMenu()
	Global $chmen = TimerInit()
	Return
EndFunc   ;==>ExitMenu

Func MenuItems()
	;MsgBox(0, "MI", "")
	;MsgBox(0, $menuitemsexist, "")
	;MsgBox(0, $readfrom, "")
	If $menuitemsexist = 0 Then
		GUICtrlCreateMenuItem("", $playmenu)
		If _FindInfo($readfrom, "Group Name") <> "%null%" Then
			Global $listentoartist = GUICtrlCreateMenuItem("Listen to songs from " & _FindInfo($readfrom, "Group Name"), $playmenu)
		EndIf
		If _FindInfo($readfrom, "Year") <> "%null%" Then
			Global $listentoyear = GUICtrlCreateMenuItem("Listen to songs from " & _FindInfo($readfrom, "Year"), $playmenu)
		EndIf
		If _FindInfo($readfrom, "Album Title") <> "%null%" Then
			Global $listentoalbum = GUICtrlCreateMenuItem("Listen to songs from " & _FindInfo($readfrom, "Album Title"), $playmenu)
		EndIf
		If _FindInfo($readfrom, "Genre") <> "%null%" Then
			Global $listentogenre = GUICtrlCreateMenuItem("Listen to " & _FindInfo($readfrom, "Genre"), $playmenu)
		EndIf
		Global $menuitemsexist = 1
	Else
		If _FindInfo($readfrom, "Group Name") <> "%null%" Then
			GUICtrlSetData($listentoartist, "Listen to songs from " & _FindInfo($readfrom, "Group Name"))
		EndIf
		If _FindInfo($readfrom, "Year") <> "%null%" Then
			GUICtrlSetData($listentoyear, "Listen to songs from " & _FindInfo($readfrom, "Year"))
		EndIf
		If _FindInfo($readfrom, "Album Title") <> "%null%" Then
			GUICtrlSetData($listentoalbum, "Listen to songs from " & _FindInfo($readfrom, "Album Title"))
		EndIf
		If _FindInfo($readfrom, "Genre") <> "%null%" Then
			GUICtrlSetData($listentogenre, "Listen to " & _FindInfo($readfrom, "Genre"))
		EndIf
	EndIf
EndFunc   ;==>MenuItems

Func SBMs($string, $splitnum)
	$split = StringSplit($string, "|")
	If BitOR($splitnum < 0, $splitnum > $split[0]) Then
		Return 0
	Else
		Return $split[$splitnum]
	EndIf
EndFunc   ;==>SBMs

;===============================================================================
; Function Name:	GetExtProperty($sPath,$iProp)
; Description:      Returns an extended property of a given file.
; Parameter(s):     $sPath - The path to the file you are attempting to retrieve an extended property from.
;                   $iProp - The numerical value for the property you want returned. If $iProp is is set
;							  to -1 then all properties will be returned in a 1 dimensional array in their corresponding order.
;							The properties are as follows:
;							Name = 0
;							Size = 1
;							Type = 2
;							DateModified = 3
;							DateCreated = 4
;							DateAccessed = 5
;							Attributes = 6
;							Status = 7
;							Owner = 8
;							Author = 9
;							Title = 10
;							Subject = 11
;							Category = 12
;							Pages = 13
;							Comments = 14
;							Copyright = 15
;							Artist = 16
;							AlbumTitle = 17
;							Year = 18
;							TrackNumber = 19
;							Genre = 20
;							Duration = 21
;							BitRate = 22
;							Protected = 23
;							CameraModel = 24
;							DatePictureTaken = 25
;							Dimensions = 26
;							Width = 27
;							Height = 28
;							Company = 30
;							Description = 31
;							FileVersion = 32
;							ProductName = 33
;							ProductVersion = 34
; Requirement(s):   File specified in $spath must exist.
; Return Value(s):  On Success - The extended file property, or if $iProp = -1 then an array with all properties
;                   On Failure - 0, @Error - 1 (If file does not exist)
; Author(s):        Simucal (Simucal@gmail.com)
; Note(s):
;
;===============================================================================
Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$iExist = FileExists($sPath)
	If $iExist = 0 Then
		SetError(1)
		Return 0
	Else
		$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
		$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		$oShellApp = ObjCreate("shell.application")
		$oDir = $oShellApp.NameSpace ($sDir)
		$oFile = $oDir.Parsename ($sFile)
		If $iProp = -1 Then
			Local $aProperty[35]
			For $i = 0 To 34
				$aProperty[$i] = $oDir.GetDetailsOf ($oFile, $i)
			Next
			Return $aProperty
		Else
			$sProperty = $oDir.GetDetailsOf ($oFile, $iProp)
			If $sProperty = "" Then
				Return 0
			Else
				Return $sProperty
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty

Func _AddArrays($ato, $afrom)
	If BitAND(IsArray($ato), IsArray($afrom)) Then
		For $i = 1 To $afrom[0]
			_ArrayAdd($ato, $afrom[$i])
			$ato[0] += 1
		Next
		Return $ato
	Else
		If IsArray($ato) Then
			Return $ato
		ElseIf IsArray($afrom) Then
			Return $afrom
		Else
			Return 0
		EndIf
	EndIf
EndFunc   ;==>_AddArrays

Func BR($string)
	$string = StringReplace($string, "[", "(*")
	Return StringReplace($string, "]", "*)")
EndFunc   ;==>BR

Func RP($string)
	$string = StringReplace($string, "(*", "[")
	Return StringReplace($string, "*)", "]")
EndFunc   ;==>RP

Func _SoundGetWaveVolume()
    Local $WaveVol = -1, $p, $ret
    Const $MMSYSERR_NOERROR = 0
    $p = DllStructCreate("dword")
    If @error Then
        SetError(2)
        Return -2
    EndIf
    $ret = DllCall("winmm.dll", "long", "waveOutGetVolume", "long", -1, "long", DllStructGetPtr($p))
    If($ret[0] == $MMSYSERR_NOERROR) Then
        $WaveVol = Round(Dec(StringRight(Hex(DllStructGetData($p, 1), 8), 4)) / 0xFFFF * 100)
    Else
        SetError(1)
    EndIf
    $Struct = 0
    Return $WaveVol
EndFunc   ;==>_SoundGetWaveVolume