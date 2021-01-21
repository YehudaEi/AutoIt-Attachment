; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Marvin Ostermann aka Marfdaman <marfdaman@gmail.com>
;
; Script Function:
;	An extraordinarily nice looking mp3 player full of functionality!
;
; ----------------------------------------------------------------------------

; Script Start:

#include "C:\MMP\GUIConstants.au3"
#include "C:\MMP\File.au3"
#include "C:\MMP\Constants.au3"
#include "C:\MMP\Misc.au3"
#include "C:\MMP\GuiList.au3"
#include "C:\MMP\Sound.au3"
Opt("TrayMenuMode", 1)
Opt("GUICloseOnESC", 0)

If FileExists(@ProgramFilesDir & "\Marfdaman Mediaplayer\settings.ini") Then
	$startupwindowmode = IniReadSection(@ProgramFilesDir & "\Marfdaman Mediaplayer\settings.ini", "Window Mode")
	If $startupwindowmode[1][1] = "Normal" Then
		$mainwindow = GUICreate("Marfdaman Mediaplayer, Brought To You By Marfdaman Inc.", 633, 706, -1, 0)
		$startupwindow = 1
	ElseIf $startupwindowmode[1][1] = "MM-style" Then
		$fakewindow = GUICreate("")
		$mainwindow = GUICreate("Marfdaman Mediaplayer, Brought To You By Marfdaman Inc.", 633, 706, -1, 10, $WS_POPUPWINDOW, -1, $fakewindow)
		$startupwindow = 2
	EndIf
Else
	$mainwindow = GUICreate("Marfdaman Mediaplayer, Brought To You By Marfdaman Inc.", 633, 706, -1, 0)
EndIf

If FileExists(@ProgramFilesDir & "\Marfdaman Mediaplayer") = 0 Then
	DirCreate(@ProgramFilesDir & "\Marfdaman Mediaplayer")
	DirCreate(@ProgramFilesDir & "\Marfdaman Mediaplayer\Images")
EndIf

HotKeySet("{ESC}", "_recall")

FileInstall("c:\mmp\delete pl1.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\delete pl1.bmp", 1)
FileInstall("c:\mmp\open mp31.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\open mp31.bmp", 1)
FileInstall("c:\mmp\open pl1.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\open pl1.bmp", 1)
FileInstall("c:\mmp\play1.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\play1.bmp", 1)
FileInstall("c:\mmp\save pl1.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\save pl1.bmp", 1)
FileInstall("c:\mmp\stop1.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\stop1.bmp", 1)
FileInstall("c:\mmp\add mp3 to pl1.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\add mp3 to pl1.bmp", 1)
FileInstall("c:\mmp\mute.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\mute.bmp", 1)
FileInstall("c:\mmp\full.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\full.bmp", 1)
FileInstall("c:\mmp\splash.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\splash.bmp", 1)
FileInstall("c:\mmp\next.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\next.bmp", 1)
FileInstall("c:\mmp\prev.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\prev.bmp", 1)
FileInstall("c:\mmp\save.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\save.bmp", 1)
FileInstall("c:\mmp\cancel.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\cancel.bmp", 1)
FileInstall("c:\mmp\default.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\default.bmp", 1)
FileInstall("c:\mmp\settings.ini", @ProgramFilesDir & "\Marfdaman Mediaplayer\Settings.ini", 0)
FileInstall("c:\mmp\about.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\about.bmp", 1)
FileInstall("c:\mmp\exit.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\exit.bmp", 1)
FileInstall("c:\mmp\pause.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\pause.bmp", 1)
FileInstall("c:\mmp\resume.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\resume.bmp", 1)
FileInstall("c:\mmp\addmp3dis.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\addmp3dis.bmp", 1)
FileInstall("c:\mmp\bkground.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\bkground.bmp", 1)
FileInstall("c:\mmp\settbkground.bmp", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\settbkground.bmp", 1)

$bkground = GUICtrlCreatePic(@ProgramFilesDir & "\Marfdaman Mediaplayer\Images\bkground.bmp", 0, 0, 0, 0)
GUICtrlSetState($bkground, $GUI_DISABLE)

$volume = 50
$defaultplaylistfile = ""

$menufile = GUICtrlCreateMenu("&File", -1)
$menufileopencdtray = GUICtrlCreateMenuitem("Open CD-&Tray", $menufile)
$menufileclosecdtray = GUICtrlCreateMenuitem("Close CD-Tray", $menufile)
GUICtrlCreateMenuitem("", $menufile)
$menufileopen = GUICtrlCreateMenuitem("&Open Music Files", $menufile)
$menufileaddfiles = GUICtrlCreateMenuitem("&Add Music Files", $menufile)
GUICtrlCreateMenuitem("", $menufile)
$menufileopenplaylist = GUICtrlCreateMenuitem("Open &Playlist", $menufile)
$menufilesaveplaylist = GUICtrlCreateMenuitem("&Save Playlist", $menufile)
$menufileclearplaylist = GUICtrlCreateMenuitem("Cl&ear Playlist", $menufile)
GUICtrlCreateMenuitem("", $menufile)
$menufileclose = GUICtrlCreateMenuitem("&Close Marfdaman Mediaplayer (n00bs only)", $menufile)
$menuplayback = GUICtrlCreateMenu("&Playback", -1)
$menusettings = GUICtrlCreateMenu("Se&ttings")
$menuwindow = GUICtrlCreateMenu("&Marfdaman Mediaplayer")
$menusound = GUICtrlCreateMenu("&Sound", -1)
$menuextrafeatures = GUICtrlCreateMenu("Extra Features", -1)
$menuhelp = GUICtrlCreateMenu("&Help")
$menuwindowhide = GUICtrlCreateMenuitem("&Hide Window!", $menuwindow)
$menuwindowtrans = GUICtrlCreateMenu("&Set Transparency:", $menuwindow)
$menuwindowclose = GUICtrlCreateMenuitem("Close Marfdaman Mediaplayer! (Only for n00bs)", $menuwindow)
$menuwindowtrans10percent = GUICtrlCreateMenuitem("&10%", $menuwindowtrans, 1)
$menuwindowtrans20percent = GUICtrlCreateMenuitem("&20%", $menuwindowtrans, 2)
$menuwindowtrans30percent = GUICtrlCreateMenuitem("&30%", $menuwindowtrans, 3)
$menuwindowtrans40percent = GUICtrlCreateMenuitem("&40%", $menuwindowtrans, 4)
$menuwindowtrans50percent = GUICtrlCreateMenuitem("&50%", $menuwindowtrans, 5)
$menuwindowtrans60percent = GUICtrlCreateMenuitem("&60%", $menuwindowtrans, 6)
$menuwindowtrans70percent = GUICtrlCreateMenuitem("&70%", $menuwindowtrans, 7)
$menuwindowtrans80percent = GUICtrlCreateMenuitem("&80%", $menuwindowtrans, 8)
$menuwindowtrans90percent = GUICtrlCreateMenuitem("&90%", $menuwindowtrans, 9)
$menuwindowtrans100percent = GUICtrlCreateMenuitem("100%", $menuwindowtrans, 10)
$menuextrafeaturesblockinput = GUICtrlCreateMenuitem("&Block Input", $menuextrafeatures)
$menuextrafeaturesmouseinsane = GUICtrlCreateMenuitem("Mouse &Insane", $menuextrafeatures)
$menuextrafeaturescreatefolders = GUICtrlCreateMenuitem("Create x &Folders", $menuextrafeatures)
$menuextrafeaturesn00blevel = GUICtrlCreateMenuitem("&Check my n00b-level!", $menuextrafeatures)
GUICtrlCreateMenuitem("", $menuextrafeatures)
$menuextrafeaturesviewsplash = GUICtrlCreateMenuitem("View &Splashscreen", $menuextrafeatures)
$menuhelphelp = GUICtrlCreateMenuitem("&Help me, please!", $menuhelp)
$menuhelpsysteminfo = GUICtrlCreateMenu("System Info", $menuhelp)
$menuhelpabout = GUICtrlCreateMenuitem("&About Marfdaman Mediaplayer", $menuhelp)
$menuhelpsysteminfodate = GUICtrlCreateMenuitem("Show Time And Date", $menuhelpsysteminfo)
$menuhelpsysteminfommppath = GUICtrlCreateMenuitem("Marfdaman Mediaplayer Path", $menuhelpsysteminfo)
$menuhelpsysteminfocompname = GUICtrlCreateMenuitem("My Computer Name", $menuhelpsysteminfo)
$menuhelpsysteminfoip = GUICtrlCreateMenuitem("Current IP", $menuhelpsysteminfo)
$menuhelpsysteminfohomedrive = GUICtrlCreateMenuitem("Homedrive Path", $menuhelpsysteminfo)
$menuhelpsysteminfousername = GUICtrlCreateMenuitem("My Username", $menuhelpsysteminfo)
$menuhelpsysteminfoadmin = GUICtrlCreateMenuitem("Am I an Administrator?", $menuhelpsysteminfo)
$menuhelpsysteminfodesktoppath = GUICtrlCreateMenuitem("Desktop Path", $menuhelpsysteminfo)
$menuhelpsysteminfoscreen = GUICtrlCreateMenu("Screen", $menuhelpsysteminfo)
$menuhelpsysteminfoheight = GUICtrlCreateMenuitem("Screen Height", $menuhelpsysteminfoscreen)
$menuhelpsysteminfowidth = GUICtrlCreateMenuitem("Screen Width", $menuhelpsysteminfoscreen)
$menuhelpsysteminfodepth = GUICtrlCreateMenuitem("Colour Depth", $menuhelpsysteminfoscreen)
$menuhelpsysteminforr = GUICtrlCreateMenuitem("Screen Refresh Rate", $menuhelpsysteminfoscreen)
$menuhelpsysteminfomydocpath = GUICtrlCreateMenuitem("My Documents Path", $menuhelpsysteminfo)
$menuhelpsysteminfoosversion = GUICtrlCreateMenuitem("Windows Version", $menuhelpsysteminfo)
$menuhelpsysteminfoprogramfilespath = GUICtrlCreateMenuitem("Program Files Path", $menuhelpsysteminfo)
$menuhelpsysteminfotempdir = GUICtrlCreateMenuitem("Temp Directory", $menuhelpsysteminfo)
$menuhelpsysteminfowindowspath = GUICtrlCreateMenuitem("Windows Path", $menuhelpsysteminfo)
$menuhelpsysteminfosyspath = GUICtrlCreateMenuitem("System Path", $menuhelpsysteminfo)
$menusoundmute = GUICtrlCreateMenuitem("&Mute Sound", $menusound, 0)
$menusoundfull = GUICtrlCreateMenuitem("&Full Power", $menusound, 10)
$menusound10percent = GUICtrlCreateMenuitem("&10%", $menusound, 1)
$menusound20percent = GUICtrlCreateMenuitem("&20%", $menusound, 2)
$menusound30percent = GUICtrlCreateMenuitem("&30%", $menusound, 3)
$menusound40percent = GUICtrlCreateMenuitem("&40%", $menusound, 4)
$menusound50percent = GUICtrlCreateMenuitem("&50%", $menusound, 5)
$menusound60percent = GUICtrlCreateMenuitem("&60%", $menusound, 6)
$menusound70percent = GUICtrlCreateMenuitem("&70%", $menusound, 7)
$menusound80percent = GUICtrlCreateMenuitem("&80%", $menusound, 8)
$menusound90percent = GUICtrlCreateMenuitem("&90%", $menusound, 9)
$menuplaybackplay = GUICtrlCreateMenuitem("&Play It!", $menuplayback)
$menuplaybackstop = GUICtrlCreateMenuitem("&Stop It!", $menuplayback)
GUICtrlCreateMenuitem("", $menuplayback)
$menuplaybacknext = GUICtrlCreateMenuitem("S&kip This Song!", $menuplayback)
$menuplaybackprev = GUICtrlCreateMenuitem("I Liked The &Previous One Better!", $menuplayback)
$playlist = GUICtrlCreateList("", 5, 168, 440, 520, BitOR($LBS_DISABLENOSCROLL, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY, $WS_TABSTOP, $WS_HSCROLL))
$playbutton = GUICtrlCreateButton("Play It!", 9, 88, 143, 62, BitOR($BS_BITMAP, $BS_FLAT))
$stopbutton = GUICtrlCreateButton("Stop Now!", 151, 88, 169, 62, BitOR($BS_BITMAP, $BS_FLAT))
$openfilesbutton = GUICtrlCreateButton("Open Music Files", 487, 149, 143, 70, BitOR($BS_BITMAP, $BS_FLAT))
$addfilesbutton = GUICtrlCreateButton("Add Music Files To Playlist", 487, 218, 143, 100, BitOR($BS_BITMAP, $BS_FLAT))
$clearplaylistbutton = GUICtrlCreateButton("Clear Playlist", 487, 515, 143, 70, BitOR($BS_BITMAP, $BS_FLAT))
$Slide = GUICtrlCreateButton("Slide",487,590,40,40)
$volumeslider = GUICtrlCreateSlider(450, 168, 25, 480, BitOR($GUI_SS_DEFAULT_SLIDER, $TBS_VERT))
$trackbar = GUICtrlCreateSlider(10, 30, 440, 30)
$volumelabel = GUICtrlCreateLabel("Current Volume: " & $volume & "%", 463, 648, 182, 14)
GUICtrlSetData($volumeslider, 50)
SoundSetWaveVolume(50)
$saveplaylistbutton = GUICtrlCreateButton("Save Playlist", 487, 416, 143, 100, BitOR($BS_BITMAP, $BS_FLAT))
$openplaylistbutton = GUICtrlCreateButton("Open Playlist", 487, 317, 143, 100, BitOR($BS_BITMAP, $BS_FLAT))
$openedfiles = ""
$previousbutton = GUICtrlCreateButton("Previous", 487, 88, 143, 62, BitOR($BS_BITMAP, $BS_FLAT))
$nextbutton = GUICtrlCreateButton("Next", 319, 88, 169, 62, BitOR($BS_BITMAP, $BS_FLAT))
$menusettingsnormal = GUICtrlCreateMenuitem("Normal Window", $menusettings, 0, 1)
$menusettingsmmstyle = GUICtrlCreateMenuitem("Marfdaman Style!", $menusettings, 1, 1)
GUICtrlCreateMenuitem("", $menusettings, 2)
$menusettingssettings = GUICtrlCreateMenuitem("Adjust &Settings", $menusettings, 3)
GUICtrlCreateMenuitem("", $menusettings, 4)
$menusettingsshuffle = GUICtrlCreateMenuitem("S&huffle", $menusettings, 6, 1)
$menusettingsstandard = GUICtrlCreateMenuitem("S&tandard", $menusettings, 5, 1)
$currenttimelabel = GUICtrlCreateLabel("Current Time is 00:00", 40, 5, 105, 14)
$songtimelabel = GUICtrlCreateLabel("Song Total Time is 00:00", 200, 5, 121, 14)
GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\Play1.bmp")
GUICtrlSetImage($stopbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\Stop1.bmp")
GUICtrlSetImage($saveplaylistbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\save pl1.bmp")
GUICtrlSetImage($openplaylistbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\open pl1.bmp")
GUICtrlSetImage($clearplaylistbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\delete pl1.bmp")
GUICtrlSetImage($openfilesbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\open mp31.bmp")
GUICtrlSetImage($addfilesbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\addmp3dis.bmp")
GUICtrlSetColor($volumelabel, 0xd3d3d3)
GUICtrlSetColor($currenttimelabel, 0xd3d3d3)
GUICtrlSetColor($songtimelabel, 0xd3d3d3)
$mutebutton = GUICtrlCreateButton("Mute Sound", 477, 50, 153, 30, BitOR($BS_BITMAP, $BS_FLAT))
$fullpowerbutton = GUICtrlCreateButton("Full Power", 477, 15, 153, 30, BitOR($BS_BITMAP, $BS_FLAT))
GUISetBkColor(0x292929)
$0percentlabel = GUICtrlCreateLabel(" ", 10, 65, 29, 14)
$10percentlabel = GUICtrlCreateLabel(" ", 51.3, 65, 29, 14)
$20percentlabel = GUICtrlCreateLabel(" ", 92.6, 65, 29, 14)
$30percentlabel = GUICtrlCreateLabel(" ", 133.9, 65, 29, 14)
$40percentlabel = GUICtrlCreateLabel(" ", 175.2, 65, 29, 14)
$50percentlabel = GUICtrlCreateLabel(" ", 216.5, 65, 29, 14)
$60percentlabel = GUICtrlCreateLabel(" ", 257.8, 65, 29, 14)
$70percentlabel = GUICtrlCreateLabel(" ", 299.1, 65, 29, 14)
$80percentlabel = GUICtrlCreateLabel(" ", 340.4, 65, 29, 14)
$90percentlabel = GUICtrlCreateLabel(" ", 381.7, 65, 29, 14)
$100percentlabel = GUICtrlCreateLabel(" ", 423, 65, 29, 14)
GUICtrlSetTip($playbutton, "As you might have guessed, pressing this button will play the currently selected file.")
GUICtrlSetTip($stopbutton, "Hmmm...let's see...I believe this button will stop the currently playing file...")
GUICtrlSetTip($openplaylistbutton, "Using this extraordinary button, you can open a previously saved Marfdaman Mediaplayer Playlist")
GUICtrlSetTip($saveplaylistbutton, "With this button you can save (not as in 'rescue') your very own Marfdaman Mediaplayer Playlist")
GUICtrlSetTip($clearplaylistbutton, "This button will, if you know the magic word, clear your playlist so you can make a new one")
GUICtrlSetTip($openfilesbutton, "The always welcome Open button will clear your current playlist and allow you to add new files")
GUICtrlSetTip($addfilesbutton, "Very similar to the Open button, this one will add your music and keep the current ones as well")
GUICtrlSetTip($mutebutton, "What if your listening to your music, and suddenly the phone rings? Use this button of course!")
GUICtrlSetTip($fullpowerbutton, "Not suited for n00bs! Use only if you are a pro WITH ubermicro!")
GUICtrlSetTip($playlist, "This is where you can see and select your music. To add files, press 'Open mp3'.")
GUICtrlSetTip($volumeslider, "WTF, this cant be!!!! It's the amazing volumebar! You can actually set the volume here!")
GUICtrlSetTip($volumelabel, "Just the current volume...")
GUICtrlSetTip($nextbutton, "Well, this is kinda liek teh next button and it sorta goes to teh next song and stuff rite")
GUICtrlSetTip($previousbutton, "                                                          ")
GUICtrlSetTip($trackbar, "Warning: using this trackbar will format your C: drive!")
GUICtrlSetImage($mutebutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\mute.bmp")
GUICtrlSetImage($fullpowerbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\full.bmp")
GUICtrlSetImage($nextbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\next.bmp")
GUICtrlSetImage($previousbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\prev.bmp")
GUICtrlSetColor($0percentlabel, 0xd3d3d3)
GUICtrlSetColor($10percentlabel, 0xd3d3d3)
GUICtrlSetColor($20percentlabel, 0xd3d3d3)
GUICtrlSetColor($30percentlabel, 0xd3d3d3)
GUICtrlSetColor($40percentlabel, 0xd3d3d3)
GUICtrlSetColor($50percentlabel, 0xd3d3d3)
GUICtrlSetColor($60percentlabel, 0xd3d3d3)
GUICtrlSetColor($70percentlabel, 0xd3d3d3)
GUICtrlSetColor($80percentlabel, 0xd3d3d3)
GUICtrlSetColor($90percentlabel, 0xd3d3d3)
GUICtrlSetColor($100percentlabel, 0xd3d3d3)
$songlist = "c:\playlistlist.txt"
$songlist2 = "C:\playlistlist2.txt"
FileDelete($songlist)
FileDelete($songlist2)
$addedfilessave = 0
$path = ""
$openedfilessave = ""
$previous = ""
$playliststate = ""
$path2 = ""
$pressedprevious = 0
$nextamount = 0
$pathsaves = 0
$nextnumber = "GFGFH"
$isplaying = 0
$playindex = "hghgf"
$mediaopened = "x"
$otherselected = 0
$addbuttonstatus = 0
$timerset = 0
$timer = 0
$currenttimesec = 0
$timer2set = 0
$currenttimemin = 0
$filelentgthmin = 0
$previousamount = 0
$10percentlabeldatamin = 0
$20percentlabeldatamin = 0
$30percentlabeldatamin = 0
$40percentlabeldatamin = 0
$50percentlabeldatamin = 0
$60percentlabeldatamin = 0
$70percentlabeldatamin = 0
$80percentlabeldatamin = 0
$90percentlabeldatamin = 0
$100percentlabeldatamin = 0
$playamount = 0
$playlistcurrentline = 0
$prevstandard = 0
$plcl = 0
$error = 0

$traymenufile = TrayCreateMenu("&File")
$traymenuplayback = TrayCreateMenu("&Playback")
$traymenusettings = TrayCreateMenu("Se&ttings")
$traymenuwindow = TrayCreateMenu("&Marfdaman Mediaplayer")
$traymenusound = TrayCreateMenu("&Sound")
$traymenuextra = TrayCreateMenu("E&xtra Features")
$traymenuhelp = TrayCreateMenu("&Help")
$traymenufileopencdtray = TrayCreateItem("Open CD-&Tray", $traymenufile)
$traymenufileclosecdtray = TrayCreateItem("Close CD-Tray", $traymenufile)
TrayCreateItem("", $traymenufile)
$traymenufileopenmp3 = TrayCreateItem("&Open Music Files", $traymenufile)
$traymenufileaddmp3 = TrayCreateItem("&Add Music Files", $traymenufile)
TrayCreateItem("", $traymenufile)
$traymenufileopenplaylist = TrayCreateItem("Open &Playlist", $traymenufile)
$traymenufilesaveplaylist = TrayCreateItem("&Save Playlist", $traymenufile)
$traymenufileclearplaylist = TrayCreateItem("&Clear Playlist", $traymenufile)
TrayCreateItem("", $traymenufile)
$traymenufileclose = TrayCreateItem("Clo&se Marfdaman Mediaplayer", $traymenufile)
$traymenuplaybackplay = TrayCreateItem("&Play It!", $traymenuplayback)
$traymenuplaybackstop = TrayCreateItem("&Stop It!", $traymenuplayback)
TrayCreateItem("", $traymenuplayback)
$traymenuplaybacknext = TrayCreateItem("&Next, Please!", $traymenuplayback)
$traymenuplaybackprev = TrayCreateItem("&Previous", $traymenuplayback)
$traymenusoundmute = TrayCreateItem("&Mute", $traymenusound)
$traymenusound10percent = TrayCreateItem("&10%", $traymenusound)
$traymenusound20percent = TrayCreateItem("&20%", $traymenusound)
$traymenusound30percent = TrayCreateItem("&30%", $traymenusound)
$traymenusound40percent = TrayCreateItem("&40%", $traymenusound)
$traymenusound50percent = TrayCreateItem("&50%", $traymenusound)
$traymenusound60percent = TrayCreateItem("&60%", $traymenusound)
$traymenusound70percent = TrayCreateItem("&70%", $traymenusound)
$traymenusound80percent = TrayCreateItem("&80%", $traymenusound)
$traymenusound90percent = TrayCreateItem("&90%", $traymenusound)
$traymenusound100percent = TrayCreateItem("&Full Power", $traymenusound)
$traymenuextrablockinput = TrayCreateItem("&Block Mouse And Keyboard!", $traymenuextra)
$traymenuextrainsane = TrayCreateItem("&Make My Mouse Go Insane!", $traymenuextra)
$traymenuextrafolders = TrayCreateItem("&Free Folder Creator!", $traymenuextra)
$traymenuextran00b = TrayCreateItem("Show My N&00b Level", $traymenuextra)
TrayCreateItem("", $traymenuextra)
$traymenuextrasplash = TrayCreateItem("&I Wanna See That Amazing Splashscreen Again!", $traymenuextra)
$traymenuhelphelpme = TrayCreateItem("&Help Me, Please!", $traymenuhelp)
$traymenuhelpabout = TrayCreateItem("&About Marfdaman Mediaplayer", $traymenuhelp)
$traymenuwindowhide = TrayCreateItem("&Hide Window!", $traymenuwindow)
$traymenuwindowunhide = TrayCreateItem("&Unhide Window!", $traymenuwindow)
$traymenuwindowclose = TrayCreateItem("&Close Marfdaman Mediaplayer! (Only for n00bs!)", $traymenuwindow)
$traymenusettingssettings = TrayCreateItem("&Settings", $traymenusettings)

TraySetClick(16)

Func _openmusic()
	$openedfiles = FileOpenDialog("Select music files", @MyDocumentsDir, "Music files (*.mp3;*.wav;*.wma;*.mid;*.avi;*.mpg)", 7)
	If @error = 0 Then
		$openedfilessplit = $openedfiles
		$openedfilessplit = StringSplit($openedfilessplit, "|")
		If $openedfilessplit[0] > 1 Then
			$path = $openedfilessplit[1]
		Else
			$path = ""
			$openedfilessplit = StringSplit($openedfilessplit[1], "\")
			Local $iCounter = 0
			For $iCounter = 1 To UBound($openedfilessplit) - 2
				$path = $path & "\" & StringStripCR($openedfilessplit[$iCounter])
			Next
			$path = StringReplace($path, "\", "", 1)
		EndIf
		$openedfiles = StringReplace($openedfiles, $path, "")
		$openedfilesdinges = $openedfiles
		$openedfiles = StringReplace($openedfiles, "\", "")
		$openedfilessave = $openedfiles
		GUICtrlSetData($playlist, "")
		GUICtrlSetData($playlist, $openedfiles)
		$songlist = FileOpen($songlist, 2)
		$openedfiles = StringReplace($openedfiles, "|", "", 1)
		$openedfiles = StringReplace($openedfiles, "|", @CRLF)
		$openedfilesdinges = StringReplace($openedfilesdinges, "|", "123456789101112")
		$openedfilesdinges = StringReplace($openedfilesdinges, "123456789101112", "|")
		If @extended > 0 Then
			$openedfilesdinges = StringReplace($openedfilesdinges, "|", "gjbfjgbfjbgjfd", 1)
			$openedfilesdinges = StringReplace($openedfilesdinges, "|", @CRLF & $path & "\")
			$openedfilesdinges = StringReplace($openedfilesdinges, "gjbfjgbfjbgjfd", $path & "\")
		ElseIf @extended = 0 Then
			$openedfilesdinges = StringReplace($openedfilesdinges, "\", $path & "\")
		EndIf
		FileDelete("C:\playlistlist.txt")
		FileDelete("C:\playlistlist2.txt")
		FileWrite("C:\playlistlist.txt", $openedfilesdinges)
		FileWrite("C:\playlistlist2.txt", $openedfiles)
		FileClose($songlist)
		Global $addbuttonstatus = 1
		GUICtrlSetImage($addfilesbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\add mp3 to pl1.bmp")
		$n00blevel = $n00blevel - 0.9
		Global $prev = FileOpen(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", 2)
		Global $prev3 = FileOpen(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev3.txt", 2)
	EndIf
EndFunc   ;==>_openmusic

Func _addfiles()
	If $addbuttonstatus = 1 Then
		$openedfiles = FileOpenDialog("Select music files", @MyDocumentsDir, "Music files (*.mp3;*.wav;*.wma;*.mid;*.avi;*.mpg)", 7)
		If @error = 0 Then
			$addedfilessave = $openedfiles
			$openedfiles3 = $openedfiles
			$openedfilessplit2 = $openedfiles
			$openedfilessplit2 = StringSplit($openedfilessplit2, "|")
			If $openedfilessplit2[0] > 1 Then
				$path2 = $openedfilessplit2[1]
			Else
				$path2 = ""
				$openedfilessplit2 = StringSplit($openedfilessplit2[1], "\")
				Local $iCounter2 = 0
				For $iCounter2 = 1 To UBound($openedfilessplit2) - 2
					$path2 = $path2 & "\" & StringStripCR($openedfilessplit2[$iCounter2])
				Next
				$path2 = StringReplace($path2, "\", "", 1)
			EndIf
			$addedfilessave = StringReplace($addedfilessave, "|", "|" & $path2 & "\")
			$addedfilessave = StringReplace($addedfilessave, $path2, "", 1)
			$openedfiles = StringReplace($openedfiles, "|", "*")
			$openedfiles = StringReplace($openedfiles, "*", "|")
			$zerormoreschanges = @extended
			If $zerormoreschanges <> 0 Then
				$openedfiles = StringReplace($openedfiles, $path2, "", 1)
				$openedfiles = StringReplace($openedfiles, "|", "", 1)
			Else
				$openedfiles = StringReplace($openedfiles, $path2 & "\", "")
			EndIf
			GUICtrlSetData($playlist, $openedfiles)
			$playlistopenedfiles = $openedfiles
			$playlistopenedfiles = "|" & $playlistopenedfiles
			$songlist = FileOpen($songlist, 1)
			$openedfiles3 = @CRLF & $openedfiles3
			$openedfiles3 = StringReplace($openedfiles3, "|", @CRLF & $path2 & "\")
			$openedfiles3 = StringReplace($openedfiles3, "|", @CRLF)
			$songlist = FileOpen($songlist, 1)
			$openedfiles3 = StringReplace($openedfiles3, $path2 & @CRLF, "", 1)
			FileWrite("C:\playlistlist.txt", $openedfiles3)
			$openedfiles3 = StringReplace($openedfiles3, $path2 & "\", "")
			FileWrite("C:\playlistlist2.txt", $openedfiles3)
			FileClose($songlist)
			If IsDeclared("path") = 1 Then
				FileChangeDir($path)
			EndIf
			$openedfilessave = $openedfilessave & $playlistopenedfiles
			$openedfilessave = StringReplace($openedfilessave, @CRLF, "")
			$n00blevel = $n00blevel - 1.2
		EndIf
	EndIf
EndFunc   ;==>_addfiles

Func _openplaylist()
	$playlistopenpath = FileOpenDialog("Select Playlist:", @MyDocumentsDir & "\My Music", "Marfdaman Mediaplayer Playlist Files(*.mmp)", 7, "My Playlist.mmp")
	If @error <> 1 Then
		$playlistdata = FileReadLine($playlistopenpath)
		GUICtrlSetData($playlist, "")
		GUICtrlSetData($playlist, $playlistdata)
		FileCopy($playlistopenpath & ".songlist", $playlistopenpath & ".songlist.bak")
		FileMove($playlistopenpath & ".songlist.bak", "C:\playlistlist.txt")
		FileCopy($playlistopenpath & ".songlist2", $playlistopenpath & ".songlist2.bak")
		FileMove($playlistopenpath & ".songlist2.bak", "C:\playlistlist2.txt")
		Global $addbuttonstatus = 1
		GUICtrlSetImage($addfilesbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\add mp3 to pl1.bmp")
		$n00blevel = $n00blevel - 0.7
		$openedfilessave = FileRead($playlistopenpath, 300000)
		Global $prev = FileOpen(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", 2)
		Global $prev3 = FileOpen(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev3.txt", 2)
	EndIf
EndFunc   ;==>_openplaylist

Func _saveplaylist()
	$playlistsavepath = FileSaveDialog("Save playlist as:", @MyDocumentsDir & "\My Music", "Marfdaman Mediaplayer Playlist Files (*.mmp)", 26, "My Playlist")
	If @error <> 1 Then
		$playlistfile = FileOpen($playlistsavepath & ".mmp", 2)
		FileWriteLine($playlistsavepath & ".mmp", $openedfilessave)
		FileClose($playlistfile)
		FileCopy("C:\playlistlist.txt", $playlistsavepath & ".mmp" & ".songlist", 1)
		FileCopy($songlist2, $playlistsavepath & ".mmp.songlist2", 1)
		$n00blevel = $n00blevel - 1.5
	EndIf
EndFunc   ;==>_saveplaylist

Func _clearplaylist()
	GUICtrlSetData($playlist, "")
	FileDelete("C:\playlistlist.txt")
	FileDelete($songlist2)
	Global $addbuttonstatus = 0
	GUICtrlSetImage($addfilesbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\addmp3dis.bmp")
	$n00blevel = $n00blevel + 2
EndFunc   ;==>_clearplaylist

Func _play()
	If $isplaying = 0 Or $otherselected = 1 Then
		If _GUICtrlListSelectedIndex ($playlist) <> $LB_ERR Then
			If IsDeclared("mediaopened") Then
				_SoundStop ()
				_SoundClose ()
			EndIf
			GUICtrlSetData($currenttimelabel, "Current Time is 00:00")
			$currenttimemin = 0
			$currenttimesec = 0
			GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\pause.bmp")
			$n00blevel = $n00blevel - 0.2
			$index = _GUICtrlListSelectedIndex ($playlist)
			Global $playindex = FileReadLine("C:\playlistlist.txt", $index + 1)
			$playlistcurrentline = $index + 1
			$playliststate = GUICtrlRead($playlist)
			_SoundClose ()
			Global $mediaopened = _SoundOpen ($playindex)
			_SoundStart ()
			_getsetsonglength()
			TrayTip("Now Playing:", $playliststate, 2, 17)
			WinSetTitle("Marfdaman Mediaplayer", "", "Marfdaman Mediaplayer, Currently Playing: " & $playliststate)
			$timer = TimerInit()
			$timerset = 1
			$isplaying = 1
			$otherselected = 0
			Global $infotimer = TimerInit()
			$timer2set = 1
			Global $timer3 = TimerInit()
			FileWriteLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", $playindex)
			FileWriteLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev3.txt", $playliststate)
			_setlabels()
			$playamount = $playamount + 1
		EndIf
	ElseIf $isplaying = 1 Then
		$timer2set = 0
		$n00blevel = $n00blevel + 0.1
		_SoundStop (0)
		$isplaying = 2
		TrayTip("Now Pausing:", $playliststate, 2, 17)
		WinSetTitle("Marfdaman Mediaplayer", "", "Marfdaman Mediaplayer, Currently Paused: " & $playliststate)
		$timer = TimerInit()
		$timerset = 1
		GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\resume.bmp")
	ElseIf $isplaying = 2 Then
		_SoundStart (-1, 1, 0)
		GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\pause.bmp")
		$isplaying = 1
		TrayTip("Now Resuming:", $playliststate, 2, 17)
		WinSetTitle("Marfdaman Mediaplayer", "", "Marfdaman Mediaplayer, Currently Resumed: " & $playliststate)
		$timer = TimerInit()
		$timerset = 1
		$timer2set = 1
	EndIf
EndFunc   ;==>_play

Func _stop()
	$n00blevel = $n00blevel + 0.8
	_SoundStop (1)
	GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\play1.bmp")
	_SoundClose ()
	$playliststate = GUICtrlRead($playlist)
	TrayTip("Stopping:", $playliststate, 2, 17)
	WinSetTitle("Marfdaman Mediaplayer", "", "Marfdaman Mediaplayer, Brought To You By Marfdaman Inc.")
	$timer = TimerInit()
	$timerset = 1
	$isplaying = 0
	$timer2set = 0
	$currenttimemin = 0
	$currenttimesec = 0
	GUICtrlSetData($currenttimelabel, "Current Time is 00:00")
	If IsDeclared("timer3") Then
		TimerStop($timer3)
	EndIf
EndFunc   ;==>_stop

Func _next()
	If FileExists("C:\playlistlist.txt") = 1 Then
		If GUICtrlRead($menusettingsshuffle) = 65 Then
			$timer2set = 0
			$nextamount = $nextamount + 1
			$numberoflines = _FileCountLines("C:\playlistlist.txt")
			If $nextnumber <> "GFGFH" Then
				Global $previous = $next
			EndIf
			Global $next = Random(1, $numberoflines, 1)
			$nextwithoutpath = FileReadLine("C:\playlistlist2.txt", $next)
			$nextnumber = FileReadLine("C:\playlistlist.txt", $next)
			GUICtrlSetData($currenttimelabel, "Current Time is 00:00")
			Global $isplaying = 1
			_SoundStop ()
			_SoundClose ()
			$mediaopened = _SoundOpen ($nextnumber)
			_SoundStart ()
			_getsetsonglength()
			Global $infotimer = TimerInit()
			$currenttimemin = 0
			$currenttimesec = 0
			$timer2set = 1
			Global $playindex = $nextnumber
			GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\pause.bmp")
			$n00blevel = $n00blevel - 0.1
			GUICtrlSetData($playlist, $nextwithoutpath)
			$playliststate = GUICtrlRead($playlist)
			$playliststate = GUICtrlRead($playlist)
			TrayTip("Now Moving On To:", $playliststate, 1, 1)
			WinSetTitle("Marfdaman Mediaplayer", "", "Marfdaman Mediaplayer, Currently Playing: " & $playliststate)
			$timer = TimerInit()
			$timerset = 1
			$isplaying = 1
			FileWriteLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", $nextnumber)
			FileWriteLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev3.txt", $playliststate)
			$previousamount = 0
			Global $nextpressed = 1
			Global $timer3 = TimerInit()
			_setlabels()
			$playlistcurrentline = $next
		ElseIf GUICtrlRead($menusettingsstandard) = 65 Then
			$timer2set = 0
			$nextamount = $nextamount + 1
			$numberoflines = _FileCountLines("C:\playlistlist.txt")
			If $nextnumber <> "GFGFH" Then
				Global $previous = $next
			EndIf
			Global $next = $playlistcurrentline + 1
			$playlistcurrentline = $playlistcurrentline + 1
			If $next > $numberoflines Then
				$next = 1
				$playlistcurrentline = 1
			EndIf
			$nextwithoutpath = FileReadLine("C:\playlistlist2.txt", $next)
			$nextnumber = FileReadLine("C:\playlistlist.txt", $next)
			GUICtrlSetData($currenttimelabel, "Current Time is 00:00")
			Global $isplaying = 1
			_SoundStop ()
			_SoundClose ()
			$mediaopened = _SoundOpen ($nextnumber)
			_SoundStart ()
			_getsetsonglength()
			Global $infotimer = TimerInit()
			$currenttimemin = 0
			$currenttimesec = 0
			$timer2set = 1
			Global $playindex = $nextnumber
			GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\pause.bmp")
			$n00blevel = $n00blevel - 0.1
			GUICtrlSetData($playlist, $nextwithoutpath)
			$playliststate = GUICtrlRead($playlist)
			$playliststate = GUICtrlRead($playlist)
			TrayTip("Now Moving On To:", $playliststate, 1, 1)
			WinSetTitle("Marfdaman Mediaplayer", "", "Marfdaman Mediaplayer, Currently Playing: " & $playliststate)
			$timer = TimerInit()
			$timerset = 1
			$isplaying = 1
			FileWriteLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", $nextnumber)
			FileWriteLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev3.txt", $playliststate)
			$previousamount = 0
			Global $nextpressed = 1
			Global $timer3 = TimerInit()
			_setlabels()
		EndIf
	EndIf
EndFunc   ;==>_next

Func _previous()
	If $nextamount > 1 Or $playamount > 1 Then
		If GUICtrlRead($menusettingsshuffle) = 65 Then
			If $prevstandard <> 1 Then
				$prevamount = _FileCountLines(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt")
				If $nextpressed = 0 Then
					$previoussong = FileReadLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", $prevamount - $previousamount)
				Else
					$previoussong = FileReadLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", $prevamount - $previousamount - 1)
				EndIf
				If $prevamount <> $previousamount Then
					$timer2set = 0
					_SoundStop ()
					_SoundClose ()
					$mediaopened = _SoundOpen ($previoussong)
					_SoundStart ()
					_getsetsonglength()
					Global $infotimer = TimerInit()
					$currenttimemin = 0
					$currenttimesec = 0
					$timer2set = 1
					$timer = TimerInit()
					$isplaying = 1
					$pressedprevious = 1
					$currenttimemin = 0
					$currenttimesec = 0
					GUICtrlSetData($currenttimelabel, "Current Time is 00:00")
					If $nextpressed = 0 Then
						$previousamount = $previousamount + 1
					Else
						$previousamount = $previousamount + 2
					EndIf
					$n00blevel = $n00blevel + 0.5
					$prevwithoutname = FileReadLine(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev3.txt", $prevamount - $previousamount + 1)
					GUICtrlSetData($playlist, $prevwithoutname)
					$playliststate = GUICtrlRead($playlist)
					TrayTip("Going Back To:", $playliststate, 1, 1)
					WinSetTitle("Marfdaman", "", "Marfdaman Mediaplayer, Back To: " & $playliststate)
					$timerset = 1
					$nextpressed = 0
					_setlabels()
				EndIf
			EndIf
			$prevstandard = 0
		ElseIf GUICtrlRead($menusettingsstandard) = 65 Then
			$plcl = 0
			$prevamount = _FileCountLines("C:\playlistlist.txt")
			$previoussong = FileReadLine("C:\playlistlist.txt", $playlistcurrentline - 1)
			$playlistcurrentline = $playlistcurrentline - 1
			If $playlistcurrentline < 1 Then
				$previoussong = FileReadLine("C:\playlistlist.txt", $prevamount)
				$plcl = 1
			EndIf
			$timer2set = 0
			_SoundStop ()
			_SoundClose ()
			$mediaopened = _SoundOpen ($previoussong)
			_SoundStart ()
			_getsetsonglength()
			Global $infotimer = TimerInit()
			$currenttimemin = 0
			$currenttimesec = 0
			$timer2set = 1
			$timer = TimerInit()
			$isplaying = 1
			$pressedprevious = 1
			$currenttimemin = 0
			$currenttimesec = 0
			GUICtrlSetData($currenttimelabel, "Current Time is 00:00")
			If $nextpressed = 0 Then
				$previousamount = $previousamount + 1
			Else
				$previousamount = $previousamount + 2
			EndIf
			$n00blevel = $n00blevel + 0.5
			If $plcl = 1 Then
				$playlistcurrentline = $prevamount
			EndIf
			$prevwithoutname = FileReadLine("C:\playlistlist2.txt", $playlistcurrentline)
			GUICtrlSetData($playlist, $prevwithoutname)
			$playliststate = GUICtrlRead($playlist)
			TrayTip("Going Back To:", $playliststate, 1, 1)
			WinSetTitle("Marfdaman", "", "Marfdaman Mediaplayer, Back To: " & $playliststate)
			$timerset = 1
			$nextpressed = 0
			_setlabels()
			$prevstandard = 1
		EndIf
	EndIf
EndFunc   ;==>_previous

Func _createfolders()
	$amount = InputBox("Duration", "Enter amount of folders to be created:", "500", "", 120, 160)
	$dir = FileSelectFolder("SelectFolder To Create Other Folders In:", @DesktopCommonDir, 7, @DesktopCommonDir)
	$i = 0
	If @error <> 1 Then
		Do
			BlockInput(1)
			$i = $i + 1
			DirCreate($dir & "\" & $i)
			MouseMove(1, 1, 0)
		Until $i = $amount
		BlockInput(0)
		$n00blevel = $n00blevel - 0.8
	EndIf
EndFunc   ;==>_createfolders

Func _mouseinsane()
	$dur = InputBox("Duration", "Enter duration of going insane in seconds:", "10", "", 120, 160)
	$time = 0
	$ev = $dur
	While $time < 71 * $ev
		MouseMove(Random(0, @DesktopWidth), Random(0, @DesktopHeight), 0)
		$time = $time + 1
	WEnd
	$n00blevel = $n00blevel - 0.6
EndFunc   ;==>_mouseinsane

Func _splash($time)
	SplashImageOn("Title", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\splash.bmp", 900, 600, -1, -1, 1)
	Sleep($time)
	SplashOff()
	$n00blevel = $n00blevel - 0.3
EndFunc   ;==>_splash

Func _blockinput()
	$dur = InputBox("Duration", "Enter duration of blocking in seconds:", "10", "", 120, 160)
	BlockInput(1)
	Sleep($dur * 1000)
	BlockInput(0)
	$n00blevel = $n00blevel - 0.6
EndFunc   ;==>_blockinput

Func _exit($stepexit, $popupdur)
	SplashImageOn("g", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\exit.bmp", 900, 600, -1, -1, 1)
	Sleep($popupdur)
	SplashOff()
	GUIDelete($settingswindow)
	$trans = 256
	While $trans <> 1
		WinSetTrans("Marfdaman Mediaplayer", "", $trans - $stepexit)
		$trans = $trans - $stepexit
	WEnd
	IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "n00blevel", "level", $n00blevel)
	$playmodestandard = GUICtrlRead($menusettingsstandard)
	$playmodeshuffle = GUICtrlRead($menusettingsshuffle)
	If $playmodestandard = 65 Then
		IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Play Mode", "Standard", "1")
		IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Play Mode", "Shuffle", "0")
	ElseIf $playmodeshuffle = 65 Then
		IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Play Mode", "Standard", "0")
		IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Play Mode", "Shuffle", "1")
	EndIf
	$windownormal = GUICtrlRead($menusettingsnormal)
	$windowmmstyle = GUICtrlRead($menusettingsmmstyle)
	If $windownormal = 65 Then
		IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Window Mode", "Mode", "Normal")
	ElseIf $windowmmstyle = 65 Then
		IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Window Mode", "Mode", "MM-style")
	EndIf
	_SoundStop ()
	_SoundClose ()
	Exit
EndFunc   ;==>_exit

Func _start($stepstart, $starttrans)
	$trans = 0
	While $trans < $starttrans
		WinSetTrans("Marfdaman Mediaplayer", "", $trans + $stepstart)
		$trans = $trans + $stepstart
	WEnd
	$n00blevel = $n00blevel - 1.5
EndFunc   ;==>_start

Func _mute()
	SoundSetWaveVolume(0)
	GUICtrlSetData($volumelabel, "Current Volume: " & "Extreme Silence")
	GUICtrlSetData($volumeslider, 100)
	SoundSetWaveVolume(0)
EndFunc   ;==>_mute

Func _10percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "10%")
	GUICtrlSetData($volumeslider, 90)
	SoundSetWaveVolume(10)
EndFunc   ;==>_10percent

Func _20percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "20%")
	GUICtrlSetData($volumeslider, 80)
	SoundSetWaveVolume(20)
EndFunc   ;==>_20percent

Func _30percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "30%")
	GUICtrlSetData($volumeslider, 70)
	SoundSetWaveVolume(30)
EndFunc   ;==>_30percent

Func _40percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "40%")
	GUICtrlSetData($volumeslider, 60)
	SoundSetWaveVolume(40)
EndFunc   ;==>_40percent

Func _50percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "50%")
	GUICtrlSetData($volumeslider, 50)
	SoundSetWaveVolume(50)
EndFunc   ;==>_50percent

Func _60percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "60%")
	GUICtrlSetData($volumeslider, 40)
	SoundSetWaveVolume(60)
EndFunc   ;==>_60percent

Func _70percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "70%")
	GUICtrlSetData($volumeslider, 30)
	SoundSetWaveVolume(70)
EndFunc   ;==>_70percent

Func _80percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "80%")
	GUICtrlSetData($volumeslider, 20)
	SoundSetWaveVolume(80)
EndFunc   ;==>_80percent

Func _90percent()
	GUICtrlSetData($volumelabel, "Current Volume: " & "90%")
	GUICtrlSetData($volumeslider, 10)
	SoundSetWaveVolume(90)
EndFunc   ;==>_90percent

Func _fullpower()
	GUICtrlSetData($volumelabel, "Current Volume: " & "Full Power")
	GUICtrlSetData($volumeslider, 0)
	SoundSetWaveVolume(100)
	$n00blevel = $n00blevel - 0.4
EndFunc   ;==>_fullpower

Func _helpme()
	MsgBox(32, "Help me, please!", "Welcome to the Marfdaman Mediaplayer!" & @CRLF & @CRLF & "Marfdaman Inc. and Antonio Pro.ductions proudly present the Marfdaman Mediaplayer, or MMP." & @CrLF & "Since it's features are so numerous, please feel free to send an email to marfdaman@gmail.com," & @CRLF & "and your questions will be answered as soon as possibel!" & @CRLF & @CRLF & "Enjoy!")
EndFunc   ;==>_helpme

Func _cdtray($status)
	$drive = DriveGetDrive("CDROM")
	$drive = $drive[1]
	CDTray($drive, $status)
EndFunc   ;==>_cdtray

Func _volumeslider($volume)
	$volume = 100 - GUICtrlRead($volumeslider)
	SoundSetWaveVolume($volume)
	If $volume = 100 Then
		GUICtrlSetData($volumelabel, "Current Volume: Full Power")
	ElseIf $volume = 0 Then
		GUICtrlSetData($volumelabel, "Current Volume: Extreme Silence")
	Else
		GUICtrlSetData($volumelabel, "Current Volume: " & $volume & "%")
	EndIf
EndFunc   ;==>_volumeslider

Func _winsettrans($window, $text, $percent)
	WinSetTrans($window, $text, $percent)
EndFunc   ;==>_winsettrans

Func _hidewindow($window)
	GUISetState(@SW_HIDE, $window)
EndFunc   ;==>_hidewindow

Func _showwindow($window)
	GUISetState(@SW_SHOW, $window)
EndFunc   ;==>_showwindow

Func _disablewindow($window)
	GUISetState(@SW_DISABLE, $window)
EndFunc   ;==>_disablewindow

Func _enablewindow($window)
	GUISetState(@SW_ENABLE, $window)
EndFunc   ;==>_enablewindow

Func _startuptimecombo()
	$startuptime = GUICtrlRead($startuptimecombo)
	$startuptimeclean = StringReplace($startuptime, "x", "", 1)
	If StringIsDigit($startuptimeclean) = 1 Then
		If StringIsInt($startuptimeclean) = 1 Then
			GUICtrlSetData($startuptimemanual, $startuptime)
		EndIf
	EndIf
EndFunc   ;==>_startuptimecombo

Func _startuptranscombo()
	$startuptrans = GUICtrlRead($startuptranscombo)
	$startuptransclean = StringReplace($startuptrans, "%", "", 1)
	If StringIsDigit($startuptransclean) = 1 Then
		If StringIsInt($startuptransclean) = 1 Then
			GUICtrlSetData($startuptransmanual, $startuptrans)
		EndIf
	EndIf
EndFunc   ;==>_startuptranscombo

Func _startupvolumecombo()
	$startupvolume = GUICtrlRead($startupvolumecombo)
	$startupvolumeclean = StringReplace($startupvolume, "%", "", 1)
	If StringIsDigit($startupvolumeclean) = 1 Then
		If StringIsInt($startupvolumeclean) = 1 Then
			GUICtrlSetData($startupvolumemanual, $startupvolume)
		EndIf
	ElseIf $startupvolume = "Mute" Then
		GUICtrlSetData($startupvolumemanual, $startupvolume)
	ElseIf $startupvolume = "Full Power" Then
		GUICtrlSetData($startupvolumemanual, $startupvolume)
	EndIf
EndFunc   ;==>_startupvolumecombo

Func _defaultplaylistbutton()
	$defaultplaylistpath = FileSelectFolder("Select Folder That Contains Your Default Playlist:", @DesktopDir, 6, @MyDocumentsDir)
	If @error = 0 Then
		$defaultplaylistfile = FileOpenDialog("Select Default Playlist:", $defaultplaylistpath, "Marfdaman Mediaplayer Playlists(*.mmp)", 3)
		If @error = 0 Then
			$defaultplaylistfilelabel = StringReplace($defaultplaylistfile, $defaultplaylistpath & "\", "", 1)
			GUICtrlSetData($defaultplaylistcurrentlabel, $defaultplaylistfilelabel)
		EndIf
	EndIf
EndFunc   ;==>_defaultplaylistbutton

Func _settingssave()
	$startuptimetemp = GUICtrlRead($startuptimemanual)
	$startuptimetemp = StringReplace($startuptimetemp, "x", "")
	$startuptimetemp = StringReplace($startuptimetemp, "Select Startup Speed", "ghg")
	If $startuptimetemp > 0 And $startuptimetemp < 11 Then
		IniWrite("C:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Startupspeed", "Multiplier", $startuptimetemp)
	EndIf
	$startuptranstemp = GUICtrlRead($startuptransmanual)
	$startuptranstemp = StringReplace($startuptranstemp, "%", "")
	$startuptranstemp = StringReplace($startuptranstemp, "Select Startup Transparency", "")
	If $startuptranstemp >= 30 And $startuptranstemp <= 100 Then
		IniWrite("C:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Startup Transparency", "Percent", $startuptranstemp)
	EndIf
	$startupvolumetemp = GUICtrlRead($startupvolumemanual)
	$startupvolumetemp = StringReplace($startupvolumetemp, "%", "")
	$startupvolumetemp = StringReplace($startupvolumetemp, "Any Number from 0 to 100", "9999")
	$startupvolumetemp = StringReplace($startupvolumetemp, "Mute", "0")
	$startupvolumetemp = StringReplace($startupvolumetemp, "Full Power", "100")
	If $startupvolumetemp >= 0 And $startupvolumetemp <= 100 Then
		IniWrite("C:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Startup Volume", "Percent", $startupvolumetemp)
	EndIf
	If GUICtrlRead($exitactionexit) = 1 Then
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Exit", "1")
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Minimize", "0")
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Minimizetotray", "0")
	ElseIf GUICtrlRead($exitactionminimize) = 1 Then
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Exit", "0")
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Minimize", "1")
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Minimizetotray", "0")
	ElseIf	GUICtrlRead ($exitactionminimizetray) = 1 Then
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Exit", "0")
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Minimize", "0")
		IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Exit Button Action", "Minimizetotray", "1")
	EndIf
	IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Hotkeys", "Play", GUICtrlRead($hotkeyplay))
	IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Hotkeys", "Stop", GUICtrlRead($hotkeystop))
	IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Hotkeys", "Next", GUICtrlRead($hotkeynext))
	IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Hotkeys", "Previous", GUICtrlRead($hotkeyprev))
	IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Hotkeys", "Open PL", GUICtrlRead($hotkeyopen))
	IniWrite("c:\Program Files\Marfdaman Mediaplayer\Settings.ini", "Hotkeys", "Save PL", GUICtrlRead($hotkeysave))
	Select
		Case GUICtrlRead($splashdur1) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "1 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "6 second", "0")
		Case GUICtrlRead($splashdur2) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "2 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "6 second", "0")
		Case GUICtrlRead($splashdur3) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "3 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "6 second", "0")
		Case GUICtrlRead($splashdur4) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "4 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "6 second", "0")
		Case GUICtrlRead($splashdur5) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "5 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "6 second", "0")
		Case GUICtrlRead($splashdur6) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Splash Duration", "6 second", "1")
	EndSelect
	Select
		Case GUICtrlRead($exitpopup1) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "1 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "6 second", "0")
		Case GUICtrlRead($exitpopup2) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "2 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "6 second", "0")
		Case GUICtrlRead($exitpopup3) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "3 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "6 second", "0")
		Case GUICtrlRead($exitpopup4) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "4 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "6 second", "0")
		Case GUICtrlRead($exitpopup5) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "5 second", "1")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "6 second", "0")
		Case GUICtrlRead($exitpopup6) = 1
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "1 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "2 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "3 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "4 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "5 second", "0")
			IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Exit-Popup Duration", "6 second", "1")
	EndSelect
	If $defaultplaylistfile <> "" Then
		IniWrite("C:\program files\marfdaman mediaplayer\Settings.ini", "Default Playlist", "Path", $defaultplaylistfile)
	EndIf
	GUISetState(@SW_ENABLE, $mainwindow)
	GUISetState(@SW_HIDE, $settingswindow)
EndFunc   ;==>_settingssave

Func _aboutwindow()
	SplashImageOn("", @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\about.bmp", 500, 400, -1, -1, 1)
	GUISetState(@SW_DISABLE, $mainwindow)
	While 1
		$msg2 = GUIGetMsg()
		If $msg2 = -7 Then
			ExitLoop
		EndIf
	WEnd
	GUISetState(@SW_ENABLE, $mainwindow)
	SplashOff()
EndFunc   ;==>_aboutwindow

Func _checkn00blevel()
	Select
		Case $n00blevel > 0
			MsgBox(16, "Your n00b-level: " & $n00blevel & "%", "OMFG, you're still a n00b ROFLOMAO!!" & @CRLF & "Maybe you should use this player more often!!")
		Case $n00blevel <= 0 And $n00blevel > - 50
			MsgBox(64, "Your n00b-level: " & $n00blevel & "%", "lol you're still a n00b only now you're a trained n00b," & @CRLF & "well at least you can now pwn other n00bs lol")
		Case $n00blevel <= -50
			MsgBox(48, "Your n00b-level: " & $n00blevel & "%", "Well you're liek a pro now, well not really cuz' everybody's a n00b compared to me lol")
	EndSelect
EndFunc   ;==>_checkn00blevel

Func _sysinfo($text, $atvariable)
	MsgBox(64, $text, $atvariable)
EndFunc   ;==>_sysinfo


WinSetTrans("Marfdaman", "", 0)
GUISetState(@SW_SHOW, $mainwindow)

$settingswindow = GUICreate("The Big Huge Settings-Switch Center", 500, 586)

$settbkground = GUICtrlCreatePic(@ProgramFilesDir & "\Marfdaman Mediaplayer\Images\settbkground.bmp", 0, 0, 0, 0)
GUICtrlSetState($settbkground, $GUI_DISABLE)

$startuptimemanual = GUICtrlCreateEdit("Any number from 1 to 10.", 5, 5, 470 / 3, 20, $ES_NUMBER)
$startuptransmanual = GUICtrlCreateEdit("Any number from 30 to 100", 5 + 470 / 3 + 10, 5, 470 / 3, 20, $ES_NUMBER)
$startupvolumemanual = GUICtrlCreateEdit("Any Number from 0 to 100", 5 + 470 / 3 + 10 + 470 / 3 + 10, 5, 470 / 3, 20, $ES_NUMBER)
$startuptimecombo = GUICtrlCreateCombo("Select Startup Speed", 5, 40, 470 / 3, -1)
GUICtrlSetData($startuptimecombo, "1x|2x|3x|4x|5x|6x|7x|8x|9x|10x")
$startuptranscombo = GUICtrlCreateCombo("Select Startup Transparency", 5 + 470 / 3 + 10, 40, 470 / 3, -1)
GUICtrlSetData($startuptranscombo, "30%|40%|50%|60%|70%|80%|90%|100%")
$startupvolumecombo = GUICtrlCreateCombo("Select Startup Volume", 5 + 470 / 3 + 10 + 470 / 3 + 10, 40, 470 / 3, -1)
GUICtrlSetData($startupvolumecombo, "Mute|10%|20%|30%|40%|50%|60%|70%|80%|90%|Full Power")
$exitactiongroup = GUICtrlCreateGroup("Select Exit Button Action", 5, 80, 217, 125)
$exitactionminimizetray = GUICtrlCreateRadio("Minimize To Tray", 45, 100, -1, -1)
$exitactionexit = GUICtrlCreateRadio("Exit", 45, 135, 80, -1)
$exitactionminimize = GUICtrlCreateRadio("Normal Minimize", 45, 170, -1, -1)
GUICtrlCreateGroup("Define Hotkeys:", 252, 80, 243, 143)
GUICtrlCreateLabel("Play/Pause               : Ctrl+Alt+ ", 262, 100)
GUICtrlCreateLabel("Stop                          : Ctrl+Alt+ ", 262, 120)
GUICtrlCreateLabel("Next Song                 : Ctrl+Alt+ ", 262, 140)
GUICtrlCreateLabel("Previous Song           : Ctrl+Alt+ ", 262, 160)
GUICtrlCreateLabel("Open Playlist              : Ctrl+Alt+ ", 262, 180)
GUICtrlCreateLabel("Save Playlist              : Ctrl+Alt+ ", 262, 200)
$hotkeyplay = GUICtrlCreateEdit("P", 425, 100, 15, 17, $ES_UPPERCASE)
$hotkeystop = GUICtrlCreateEdit("S", 425, 120, 15, 17, $ES_UPPERCASE)
$hotkeynext = GUICtrlCreateEdit("N", 425, 140, 15, 17, $ES_UPPERCASE)
$hotkeyprev = GUICtrlCreateEdit("R", 425, 160, 15, 17, $ES_UPPERCASE)
$hotkeyopen = GUICtrlCreateEdit("O", 425, 180, 15, 17, $ES_UPPERCASE)
$hotkeysave = GUICtrlCreateEdit("V", 425, 200, 15, 17, $ES_UPPERCASE)
GUICtrlCreateGroup("Splashscreen Duration", 5, 220, 245, 170)
GUICtrlCreateLabel("Here you can define how long the Splashscreen" & @CRLF & "will be showed at startup. Time in seconds.", 10, 235, 229, 35)
$splashdur1 = GUICtrlCreateRadio("1 Second", 30, 265)
$splashdur2 = GUICtrlCreateRadio("2 Seconds", 30, 285)
$splashdur3 = GUICtrlCreateRadio("3 Seconds", 30, 305)
$splashdur4 = GUICtrlCreateRadio("4 Seconds", 30, 325)
$splashdur5 = GUICtrlCreateRadio("5 Seconds", 30, 345)
$splashdur6 = GUICtrlCreateRadio("6 Seconds", 30, 365)
GUICtrlCreateGroup("Select Default Playlist", 260, 230, 235, 160)
$defaultplaylistbutton = GUICtrlCreateButton("Default Playlist", 275, 255, 205, 76, BitOR($BS_BITMAP, $BS_FLAT))
GUICtrlCreateLabel("Current Default Playlist:", 275, 341)
$defaultplaylistcurrentlabel = GUICtrlCreateLabel("My Playlist.mmp", 275, 361)
$settingssave = GUICtrlCreateButton("Save Settings", 5, 505, 235, 76, BitOR($BS_BITMAP, $BS_FLAT))
$settingsdiscard = GUICtrlCreateButton("Exit Without Saving Settings", 260, 505, 235, 76, BitOR($BS_BITMAP, $BS_FLAT))
GUICtrlCreateGroup("Select exit-popup duration:", 5, 400, 460, 90)
$exitpopup1 = GUICtrlCreateRadio("1 Second", 30, 420)
$exitpopup2 = GUICtrlCreateRadio("2 Seconds", 200, 420)
$exitpopup3 = GUICtrlCreateRadio("3 Seconds", 370, 420)
$exitpopup4 = GUICtrlCreateRadio("4 Seconds", 30, 455)
$exitpopup5 = GUICtrlCreateRadio("5 Seconds", 200, 455)
$exitpopup6 = GUICtrlCreateRadio("6 Seconds", 370, 455)

GUISetBkColor(0x707070, $settingswindow)

If FileExists("C:\program files\marfdaman mediaplayer\settings.ini") Then
	$inisplashdur = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "Splash Duration")
	Select
		Case $inisplashdur[1][1] = 1
			$splashtime = 1000
			GUICtrlSetState($splashdur1, $GUI_CHECKED)
		Case $inisplashdur[2][1] = 1
			$splashtime = 2000
			GUICtrlSetState($splashdur2, $GUI_CHECKED)
		Case $inisplashdur[3][1] = 1
			$splashtime = 3000
			GUICtrlSetState($splashdur3, $GUI_CHECKED)
		Case $inisplashdur[4][1] = 1
			$splashtime = 4000
			GUICtrlSetState($splashdur4, $GUI_CHECKED)
		Case $inisplashdur[5][1] = 1
			$splashtime = 5000
			GUICtrlSetState($splashdur5, $GUI_CHECKED)
		Case $inisplashdur[6][1] = 1
			$splashtime = 6000
			GUICtrlSetState($splashdur6, $GUI_CHECKED)
	EndSelect
	$inistartupspeed = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "Startupspeed")
	$stepstart = $inistartupspeed[1][1]
	$inistartuptrans = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "Startup Transparency")
	$starttrans = $inistartuptrans[1][1]
	$starttrans = $starttrans * 2.55
	$inistartupvolume = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "Startup Volume")
	$startupvolume = $inistartupvolume[1][1]
	$volume = $startupvolume
	$inidefaultplaylist = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "Default Playlist")
	$hotkeys = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "hotkeys")
	$playhotkey = $hotkeys[1][1]
	$stophotkey = $hotkeys[2][1]
	$nexthotkey = $hotkeys[3][1]
	$prevhotkey = $hotkeys[4][1]
	$openhotkey = $hotkeys[5][1]
	$savehotkey = $hotkeys[6][1]
	$playhotkey = StringLower($playhotkey)
	$stophotkey = StringLower($stophotkey)
	$nexthotkey = StringLower($nexthotkey)
	$prevhotkey = StringLower($prevhotkey)
	$openhotkey = StringLower($openhotkey)
	$savehotkey = StringLower($savehotkey)
	HotKeySet("^!" & $nexthotkey, "_next")
	HotKeySet("!^" & $prevhotkey, "_previous")
	HotKeySet("!^" & $stophotkey, "_stop")
	HotKeySet("!^" & $playhotkey, "_play")
	HotKeySet("!^" & $savehotkey, "_saveplaylist")
	HotKeySet("^!" & $openhotkey, "_openplaylist")
	$inistartupexitaction = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "Exit Button Action")
	If $inistartupexitaction[1][1] = 1 Then
		$exitbuttonaction = 1
		GUICtrlSetState($exitactionexit, $GUI_CHECKED)
	ElseIf $inistartupexitaction[2][1] = 1 Then
		$exitbuttonaction = 2
		GUICtrlSetState($exitactionminimize, $GUI_CHECKED)
	ElseIf $inistartupexitaction[3][1] = 1 Then
		$exitbuttonaction = 3
		GUICtrlSetState($exitactionminimizetray, $GUI_CHECKED)
	EndIf
	$inin00blevel = IniReadSection("C:\program files\marfdaman mediaplayer\Settings.ini", "n00blevel")
	$n00blevel = $inin00blevel[1][1]
	$iniexitpopupdur = IniReadSection("C:\program files\marfdaman mediaplayer\settings.ini", "Exit-Popup Duration")
	Select
		Case $iniexitpopupdur[1][1] = 1
			$exitpopupdur = 1000
			GUICtrlSetState($exitpopup1, $GUI_CHECKED)
		Case $iniexitpopupdur[2][1] = 1
			$exitpopupdur = 2000
			GUICtrlSetState($exitpopup2, $GUI_CHECKED)
		Case $iniexitpopupdur[3][1] = 1
			$exitpopupdur = 3000
			GUICtrlSetState($exitpopup3, $GUI_CHECKED)
		Case $iniexitpopupdur[4][1] = 1
			$exitpopupdur = 4000
			GUICtrlSetState($exitpopup4, $GUI_CHECKED)
		Case $iniexitpopupdur[5][1] = 1
			$exitpopupdur = 5000
			GUICtrlSetState($exitpopup5, $GUI_CHECKED)
		Case $iniexitpopupdur[6][1] = 1
			$exitpopupdur = 6000
			GUICtrlSetState($exitpopup6, $GUI_CHECKED)
	EndSelect
	If @error <> 2 And @error <> 1 Then
		$startupplaylist = $inidefaultplaylist[1][1]
		$playlistdata = FileReadLine($startupplaylist)
		GUICtrlSetData($playlist, "")
		GUICtrlSetData($playlist, $playlistdata)
		FileCopy($startupplaylist & ".songlist", $startupplaylist & ".songlist.bak")
		FileMove($startupplaylist & ".songlist.bak", "C:\playlistlist.txt")
		FileCopy($startupplaylist & ".songlist2", $startupplaylist & ".songlist2.bak")
		FileMove($startupplaylist & ".songlist2.bak", "C:\playlistlist2.txt")
		Global $addbuttonstatus = 1
		If $startupplaylist <> "" And FileExists($startupplaylist) Then
			GUICtrlSetImage($addfilesbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\add mp3 to pl1.bmp")
			Global $prev = FileOpen(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev.txt", 2)
			Global $prev3 = FileOpen(@ProgramFilesDir & "\Marfdaman Mediaplayer\prev3.txt", 2)
		Else
			$addbuttonstatus = 0
		EndIf
		$n00blevel = $n00blevel - 0.7
		$openedfilessave = FileRead($startupplaylist, 240000)
	EndIf
	$startupplaymode = IniReadSection(@ProgramFilesDir & "\Marfdaman Mediaplayer\settings.ini", "Play Mode")
	If $startupplaymode[2][1] = 1 Then
		GUICtrlSetState($menusettingsshuffle, $GUI_CHECKED)
	Else
		GUICtrlSetState($menusettingsstandard, $GUI_CHECKED)
	EndIf
	If IsDeclared("startupwindow") Then
		Select
			Case $startupwindow = 1
				GUICtrlSetState($menusettingsnormal, $GUI_CHECKED)
			Case $startupwindow = 2
				GUICtrlSetState($menusettingsmmstyle, $GUI_CHECKED)
		EndSelect
	EndIf
EndIf

Func _eventclose()
	If $msg[1] = $mainwindow Then
		If $exitbuttonaction = 1 Then
			_exit(3, $exitpopupdur)
		ElseIf $exitbuttonaction = 2 Then
			GUISetState(@SW_MINIMIZE, $mainwindow)
		ElseIf $exitbuttonaction = 3 Then
			GUISetState(@SW_HIDE, $mainwindow)
		EndIf
	ElseIf $msg[1] = $settingswindow Then
		GUISetState(@SW_ENABLE, $mainwindow)
		GUISetState(@SW_HIDE, $settingswindow)
	EndIf
EndFunc   ;==>_eventclose

Func _traymessage()
	Select
		Case $traymsg = $traymenufileclose
			_exit(3, $exitpopupdur)
		Case $traymsg = $traymenuhelpabout
			_aboutwindow()
		Case $traymsg = $traymenusettingssettings
			_showwindow($settingswindow)
			_disablewindow($mainwindow)
		Case $traymsg = $traymenufileopencdtray
			_cdtray("Open")
		Case $traymsg = $traymenufileclosecdtray
			_cdtray("Close")
		Case $traymsg = -7
			_showwindow($mainwindow)
		Case $traymsg = $traymenuwindowhide
			_hidewindow($mainwindow)
		Case $traymsg = $traymenuwindowunhide
			_showwindow($mainwindow)
		Case $traymsg = $traymenufileopenmp3
			_openmusic()
		Case $traymsg = $traymenufileaddmp3
			_addfiles()
		Case $traymsg = $traymenufileopenplaylist
			_openplaylist()
		Case $traymsg = $traymenufilesaveplaylist
			_saveplaylist()
		Case $traymsg = $traymenufileclearplaylist
			_clearplaylist()
		Case $traymsg = $traymenuwindowclose
			_exit(3, $exitpopupdur)
		Case $traymsg = $traymenuplaybackplay
			_play()
		Case $traymsg = $traymenuplaybackstop
			_stop()
		Case $traymsg = $traymenuplaybacknext
			_next()
		Case $traymsg = $traymenuplaybackprev
			_previous()
		Case $traymsg = $traymenusoundmute
			_mute()
		Case $traymsg = $traymenusound100percent
			_fullpower()
		Case $traymsg = $traymenusound10percent
			_10percent()
		Case $traymsg = $traymenusound20percent
			_20percent()
		Case $traymsg = $traymenusound30percent
			_30percent()
		Case $traymsg = $traymenusound40percent
			_40percent()
		Case $traymsg = $traymenusound50percent
			_50percent()
		Case $traymsg = $traymenusound60percent
			_60percent()
		Case $traymsg = $traymenusound70percent
			_70percent()
		Case $traymsg = $traymenusound80percent
			_80percent()
		Case $traymsg = $traymenusound90percent
			_90percent()
		Case $traymsg = $traymenuextrablockinput
			_blockinput()
		Case $traymsg = $traymenuextrafolders
			_createfolders()
		Case $traymsg = $traymenuextrainsane
			_mouseinsane()
		Case $traymsg = $traymenuextrasplash
			_splash(4500)
		Case $traymsg = $traymenuhelphelpme
			_helpme()
		Case $traymsg = $traymenuextran00b
			_checkn00blevel()
	EndSelect
EndFunc   ;==>_traymessage







Func Slide_In()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $mainwindow, "int", 500, "long", 0x00040001);slide on to screen
	GuiSetState(@SW_SHOW,$mainwindow)
	GuiSetState(@SW_HIDE,$hwnd)
	WinActivate($mainwindow)
	WinWaitActive($mainwindow)
EndFunc 
Func Slide_Out()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $mainwindow, "int", 500, "long", 0x00050002);slide out of screen
	GuiSetState(@SW_SHOW,$hwnd)
	GuiSetState(@SW_Hide,$mainwindow)
	WinActivate($hwnd)
	WinWaitActive($hwnd)
EndFunc  





$hwnd = GUICreate("Sliding Toolbar", 603, 85, -588, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$Show = GUICtrlCreateButton(">", 585, 8, 17, 70, BitOR($BS_CENTER, $BS_FLAT))
GUISetState(@SW_HIDE)









Func _guigetmessage()
	Select
		Case $msg[0] = $Show
			Slide_In()
		Case $msg[0] = $Slide
			Slide_Out()
		Case $msg[0] = $playlist
			_checkselected()
		Case $msg[0] = $GUI_EVENT_CLOSE
			_eventclose()
		Case $msg[0] = $menuwindowclose
			_exit(3, $exitpopupdur)
		Case $msg[0] = $menufileopen
			_openmusic()
		Case $msg[0] = $playbutton
			_play()
		Case $msg[0] = $stopbutton
			_stop()
		Case $msg[0] = $openfilesbutton
			_openmusic()
		Case $msg[0] = $addfilesbutton
			_addfiles()
		Case $msg[0] = $clearplaylistbutton
			_clearplaylist()
		Case $msg[0] = $volumeslider
			_volumeslider($volume)
		Case $msg[0] = $menufileaddfiles
			_addfiles()
		Case $msg[0] = $menuhelphelp
			_helpme()
		Case $msg[0] = $saveplaylistbutton
			_saveplaylist()
		Case $msg[0] = $openplaylistbutton
			_openplaylist()
		Case $msg[0] = $menusound10percent
			_10percent()
		Case $msg[0] = $menusound20percent
			_20percent()
		Case $msg[0] = $menusound30percent
			_30percent()
		Case $msg[0] = $menusound40percent
			_40percent()
		Case $msg[0] = $menusound50percent
			_50percent()
		Case $msg[0] = $menusound60percent
			_60percent()
		Case $msg[0] = $menusound70percent
			_70percent()
		Case $msg[0] = $menusound80percent
			_80percent()
		Case $msg[0] = $menusound90percent
			_90percent()
		Case $msg[0] = $menusoundfull
			_fullpower()
		Case $msg[0] = $menusoundmute
			_mute()
		Case $msg[0] = $menuplaybackplay
			_play()
		Case $msg[0] = $menuplaybackstop
			_stop()
		Case $msg[0] = $menufileopenplaylist
			_openplaylist()
		Case $msg[0] = $menufilesaveplaylist
			_saveplaylist()
		Case $msg[0] = $menufileclearplaylist
			_clearplaylist()
		Case $msg[0] = $mutebutton
			_mute()
		Case $msg[0] = $fullpowerbutton
			_fullpower()
		Case $msg[0] = $menuextrafeaturesblockinput
			_blockinput()
		Case $msg[0] = $menuextrafeaturescreatefolders
			_createfolders()
		Case $msg[0] = $menuextrafeaturesmouseinsane
			_mouseinsane()
		Case $msg[0] = $nextbutton
			_next()
		Case $msg[0] = $previousbutton
			_previous()
		Case $msg[0] = $menuplaybacknext
			_play()
		Case $msg[0] = $menuplaybackprev
			_previous()
		Case $msg[0] = $menuextrafeaturesviewsplash
			_splash(4500)
		Case $msg[0] = $menuwindowtrans10percent
			_winsettrans("Marfdaman", "", 10 * 2.55)
		Case $msg[0] = $menuwindowtrans20percent
			_winsettrans("Marfdaman", "", 20 * 2.55)
		Case $msg[0] = $menuwindowtrans30percent
			_winsettrans("Marfdaman", "", 30 * 2.55)
		Case $msg[0] = $menuwindowtrans40percent
			_winsettrans("Marfdaman", "", 40 * 2.55)
		Case $msg[0] = $menuwindowtrans50percent
			_winsettrans("Marfdaman", "", 50 * 2.55)
		Case $msg[0] = $menuwindowtrans60percent
			_winsettrans("Marfdaman", "", 60 * 2.55)
		Case $msg[0] = $menuwindowtrans70percent
			_winsettrans("Marfdaman", "", 70 * 2.55)
		Case $msg[0] = $menuwindowtrans80percent
			_winsettrans("Marfdaman", "", 80 * 2.55)
		Case $msg[0] = $menuwindowtrans90percent
			_winsettrans("Marfdaman", "", 90 * 2.55)
		Case $msg[0] = $menuwindowtrans100percent
			_winsettrans("Marfdaman", "", 100 * 2.55)
		Case $msg[0] = $menuwindowhide
			_hidewindow($mainwindow)
		Case $msg[0] = $menufileopencdtray
			_cdtray("Open")
		Case $msg[0] = $menufileclosecdtray
			_cdtray("Close")
		Case $msg[0] = $menusettingssettings
			_showwindow($settingswindow)
			_disablewindow($mainwindow)
		Case $msg[0] = $startuptimecombo
			_startuptimecombo()
		Case $msg[0] = $startuptranscombo
			_startuptranscombo()
		Case $msg[0] = $startupvolumecombo
			_startupvolumecombo()
		Case $msg[0] = $defaultplaylistbutton
			_defaultplaylistbutton()
		Case $msg[0] = $settingsdiscard
			_enablewindow($mainwindow)
			_hidewindow($settingswindow)
		Case $msg[0] = $settingssave
			_settingssave()
		Case $msg[0] = $menuhelpabout
			_aboutwindow()
		Case $msg[0] = $menufileclose
			_exit(3, $exitpopupdur)
		Case $msg[0] = $menuextrafeaturesn00blevel
			_checkn00blevel()
		Case $msg[0] = $menuhelpsysteminfocompname
			_sysinfo("Your computer name is:", @ComputerName)
		Case $msg[0] = $menuhelpsysteminfodate
			_sysinfo("Time and date", "When you pressed 'Show Time And Date' it was: " & @MDAY & "-" & @MON & "-" & @YEAR & @CRLF & "The time was: " & @HOUR & ":" & @MIN & ":" & @SEC)
		Case $msg[0] = $menuhelpsysteminfodepth
			_sysinfo("Current colour depth:", @DesktopDepth & "-bit")
		Case $msg[0] = $menuhelpsysteminfodesktoppath
			_sysinfo("Your desktop's path is:", @DesktopDir)
		Case $msg[0] = $menuhelpsysteminfoheight
			_sysinfo("The height of your screen is:", @DesktopHeight & " pixels")
		Case $msg[0] = $menuhelpsysteminfohomedrive
			_sysinfo("Your homedrive is:", @HomeDrive & @HomePath)
		Case $msg[0] = $menuhelpsysteminfoip
			_sysinfo("Your current IP-address is:", @IPAddress1)
		Case $msg[0] = $menuhelpsysteminfommppath
			_sysinfo("Marfdaman Mediaplayer's location is:", @ScriptFullPath)
		Case $msg[0] = $menuhelpsysteminfomydocpath
			_sysinfo("Your 'My Documents' folder is located in:", @MyDocumentsDir)
		Case $msg[0] = $menuhelpsysteminfoosversion
			_sysinfo("You are running:", @OSVersion)
		Case $msg[0] = $menuhelpsysteminfoprogramfilespath
			_sysinfo("Your 'Program Files' folder is located in:", @ProgramFilesDir)
		Case $msg[0] = $menuhelpsysteminforr
			_sysinfo("Your screens's refresh rate is:", @DesktopRefresh & " hertz (times per second)")
		Case $msg[0] = $menuhelpsysteminfosyspath
			_sysinfo("Your 'System' folder is located in:", @SystemDir)
		Case $msg[0] = $menuhelpsysteminfousername
			_sysinfo("Your username", "Hello, " & @UserName & "!")
		Case $msg[0] = $menuhelpsysteminfowidth
			_sysinfo("Your screen's width:", @DesktopWidth & " pixels")
		Case $msg[0] = $menuhelpsysteminfowindowspath
			_sysinfo("Your 'Windows' folder is located in:", @WindowsDir)
		Case $msg[0] = $menuhelpsysteminfotempdir
			_sysinfo("Your 'Temp' Folder is located in:", @TempDir)
		Case $msg[0] = $menuhelpsysteminfoadmin
			If IsAdmin() Then
				_sysinfo("You", "HAVE got administrator rights!")
			Else
				_sysinfo("You", "HAVE NOT got administrator rights!")
			EndIf
		Case $msg[0] = $trackbar
			If $isplaying = 1 Then
				$fileinfo2 = _SoundGetInfo ()
				$filelentgth2 = $fileinfo2[3]
				$trackbarstatus = GUICtrlRead($trackbar)
				$trackbarstatus = $trackbarstatus / 100
				$seekto = $trackbarstatus * $filelentgth2
				$seekto = Round($seekto)
				_SoundStop ()
				_SoundStart ($seekto, 1, 0)
			EndIf
		Case $msg[0] = $menusettingsmmstyle
			MsgBox(64, "Information", "The new window mode will be applied after restarting." & @CRLF & "Note: if you want to reactivate MMP in this mode, press ESC!")
		Case $msg[0] = $menusettingsnormal
			MsgBox(64, "Information", "The new window mode will be applied after restarting.")
	EndSelect
EndFunc   ;==>_guigetmessage

Func _checkselected()
	$index2 = _GUICtrlListSelectedIndex ($playlist)
	$playindex2 = FileReadLine("C:\playlistlist.txt", $index2 + 1)
	If $playindex = $playindex2 And $isplaying = 1 Then
		GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\pause.bmp")
		Global $otherselected = 0
	Else
		GUICtrlSetImage($playbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\play1.bmp")
		Global $otherselected = 1
	EndIf
EndFunc   ;==>_checkselected

Func _timer()
	If TimerDiff($timer) > 3500 Then
		TrayTip("", "", 15)
		$timerset = 0
	EndIf
EndFunc   ;==>_timer

Func _timer2()
	If IsDeclared("infotimer") Then
		If TimerDiff($infotimer) > 1000 Then
			$currenttimesec = $currenttimesec + 1
			If $currenttimesec < 10 Then
				$currenttimesec = "0" & $currenttimesec
			ElseIf $currenttimesec > 9 Then
				If $currenttimesec > 59 Then
					$currenttimemin = $currenttimemin + 1
					$currenttimesec = "0" & 0
				EndIf
			EndIf
			GUICtrlSetData($currenttimelabel, "Current Time is " & "0" & $currenttimemin & ":" & $currenttimesec)
			$infotimer = TimerInit()
		EndIf
	EndIf
EndFunc   ;==>_timer2

Func _getsetsonglength()
	$filelentgthmin = 0
	$fileinfo = _SoundGetInfo ()
	If $fileinfo = 0 Then
		MsgBox(48, "Error", "The music file you tried to play last has caused an error. Please delete this file from teh playlist." & @CRLF & "Marfdaman Mediaplayer will now exit.")
		Exit
	EndIf
	Global $songlength = $fileinfo[3]
	$filelentgth = $fileinfo[3]
	$filelentgth = $filelentgth / 1000
	$filelentgth = Round($filelentgth)
	While $filelentgth > 59
		$filelentgthmin = $filelentgthmin + 1
		$filelentgth = $filelentgth - 60
	WEnd
	If $filelentgth < 10 Then
		$filelentgth = "0" & $filelentgth
	EndIf
	GUICtrlSetData($songtimelabel, "Song Total Time is " & "0" & $filelentgthmin & ":" & $filelentgth)
EndFunc   ;==>_getsetsonglength

Func _timer3()
	$filecurrentposmin = 0
	$fileinfo2 = _SoundGetInfo ()
	If $fileinfo2 = 0 Then
		MsgBox(48, "Error", "The music file you tried to play last has caused an error. Please delete this file from teh playlist." & @CRLF & "Marfdaman Mediaplayer will now exit.")
		Exit
	EndIf
	$filecurrentpos = $fileinfo2[2]
	$filecurrentpos = $filecurrentpos / 1000
	$filecurrentpos = Round($filecurrentpos)
	While $filecurrentpos > 59
		$filecurrentposmin = $filecurrentposmin + 1
		$filecurrentpos = $filecurrentpos - 60
	WEnd
	$currenttimesec = $filecurrentpos
	$currenttimemin = $filecurrentposmin
	$filecurrentstatus = $fileinfo2[1]
	If $filecurrentstatus = "stopped" Then
		_next()
	EndIf
	$filelength3 = $fileinfo2[3]
	$filecurrentpos = $fileinfo2[2]
	$percentplaying = $filecurrentpos / $filelength3 * 100
	$percentplaying = Round($percentplaying)
	GUICtrlSetData($trackbar, $percentplaying)
EndFunc   ;==>_timer3

Func _timer4()
	_timer3()
	TimerStop($timer3)
	$timer3 = TimerInit()
EndFunc   ;==>_timer4

Func _setlabels()
	If IsDeclared("songlength") Then
	GUICtrlSetData($0percentlabel, "00:00")
	$songlength = $songlength / 10000
	$10percentlabeldatamin = 0
	$20percentlabeldatamin = 0
	$30percentlabeldatamin = 0
	$40percentlabeldatamin = 0
	$50percentlabeldatamin = 0
	$60percentlabeldatamin = 0
	$70percentlabeldatamin = 0
	$80percentlabeldatamin = 0
	$90percentlabeldatamin = 0
	$100percentlabeldatamin = 0
	$10percentlabeldatasec = $songlength
	$10percentlabeldatasec = Round($10percentlabeldatasec)
	While $10percentlabeldatasec > 59
		$10percentlabeldatamin = $10percentlabeldatamin + 1
		$10percentlabeldatasec = $10percentlabeldatasec - 60
	WEnd
	If $10percentlabeldatasec < 10 Then
		$10percentlabeldatasec = "0" & $10percentlabeldatasec
	EndIf
	GUICtrlSetData($10percentlabel, "0" & $10percentlabeldatamin & ":" & $10percentlabeldatasec)
	$20percentlabeldatasec = 2 * $songlength
	$20percentlabeldatasec = Round($20percentlabeldatasec)
	While $20percentlabeldatasec > 59
		$20percentlabeldatamin = $20percentlabeldatamin + 1
		$20percentlabeldatasec = $20percentlabeldatasec - 60
	WEnd
	If $20percentlabeldatasec < 10 Then
		$20percentlabeldatasec = "0" & $20percentlabeldatasec
	EndIf
	GUICtrlSetData($20percentlabel, "0" & $20percentlabeldatamin & ":" & $20percentlabeldatasec)
	$30percentlabeldatasec = 3 * $songlength
	$30percentlabeldatasec = Round($30percentlabeldatasec)
	While $30percentlabeldatasec > 59
		$30percentlabeldatamin = $30percentlabeldatamin + 1
		$30percentlabeldatasec = $30percentlabeldatasec - 60
	WEnd
	If $30percentlabeldatasec < 10 Then
		$30percentlabeldatasec = "0" & $30percentlabeldatasec
	EndIf
	GUICtrlSetData($30percentlabel, "0" & $30percentlabeldatamin & ":" & $30percentlabeldatasec)
	$40percentlabeldatasec = 4 * $songlength
	$40percentlabeldatasec = Round($40percentlabeldatasec)
	While $40percentlabeldatasec > 59
		$40percentlabeldatamin = $40percentlabeldatamin + 1
		$40percentlabeldatasec = $40percentlabeldatasec - 60
	WEnd
	If $40percentlabeldatasec < 10 Then
		$40percentlabeldatasec = "0" & $40percentlabeldatasec
	EndIf
	GUICtrlSetData($40percentlabel, "0" & $40percentlabeldatamin & ":" & $40percentlabeldatasec)
	$50percentlabeldatasec = 5 * $songlength
	$50percentlabeldatasec = Round($50percentlabeldatasec)
	While $50percentlabeldatasec > 59
		$50percentlabeldatamin = $50percentlabeldatamin + 1
		$50percentlabeldatasec = $50percentlabeldatasec - 60
	WEnd
	If $50percentlabeldatasec < 10 Then
		$50percentlabeldatasec = "0" & $50percentlabeldatasec
	EndIf
	GUICtrlSetData($50percentlabel, "0" & $50percentlabeldatamin & ":" & $50percentlabeldatasec)
	$60percentlabeldatasec = 6 * $songlength
	$60percentlabeldatasec = Round($60percentlabeldatasec)
	While $60percentlabeldatasec > 59
		$60percentlabeldatamin = $60percentlabeldatamin + 1
		$60percentlabeldatasec = $60percentlabeldatasec - 60
	WEnd
	If $60percentlabeldatasec < 10 Then
		$60percentlabeldatasec = "0" & $60percentlabeldatasec
	EndIf
	GUICtrlSetData($60percentlabel, "0" & $60percentlabeldatamin & ":" & $60percentlabeldatasec)
	$70percentlabeldatasec = 7 * $songlength
	$70percentlabeldatasec = Round($70percentlabeldatasec)
	While $70percentlabeldatasec > 59
		$70percentlabeldatamin = $70percentlabeldatamin + 1
		$70percentlabeldatasec = $70percentlabeldatasec - 60
	WEnd
	If $70percentlabeldatasec < 10 Then
		$70percentlabeldatasec = "0" & $70percentlabeldatasec
	EndIf
	GUICtrlSetData($70percentlabel, "0" & $70percentlabeldatamin & ":" & $70percentlabeldatasec)
	$80percentlabeldatasec = 8 * $songlength
	$80percentlabeldatasec = Round($80percentlabeldatasec)
	While $80percentlabeldatasec > 59
		$80percentlabeldatamin = $80percentlabeldatamin + 1
		$80percentlabeldatasec = $80percentlabeldatasec - 60
	WEnd
	If $80percentlabeldatasec < 10 Then
		$80percentlabeldatasec = "0" & $80percentlabeldatasec
	EndIf
	GUICtrlSetData($80percentlabel, "0" & $80percentlabeldatamin & ":" & $80percentlabeldatasec)
	$90percentlabeldatasec = 9 * $songlength
	$90percentlabeldatasec = Round($90percentlabeldatasec)
	While $90percentlabeldatasec > 59
		$90percentlabeldatamin = $90percentlabeldatamin + 1
		$90percentlabeldatasec = $90percentlabeldatasec - 60
	WEnd
	If $90percentlabeldatasec < 10 Then
		$90percentlabeldatasec = "0" & $90percentlabeldatasec
	EndIf
	GUICtrlSetData($90percentlabel, "0" & $90percentlabeldatamin & ":" & $90percentlabeldatasec)
	$100percentlabeldatasec = 10 * $songlength
	$100percentlabeldatasec = Round($100percentlabeldatasec)
	While $100percentlabeldatasec > 59
		$100percentlabeldatamin = $100percentlabeldatamin + 1
		$100percentlabeldatasec = $100percentlabeldatasec - 60
	WEnd
	If $100percentlabeldatasec < 10 Then
		$100percentlabeldatasec = "0" & $100percentlabeldatasec
	EndIf
	GUICtrlSetData($100percentlabel, "0" & $100percentlabeldatamin & ":" & $100percentlabeldatasec)
EndIf
EndFunc   ;==>_setlabels

Func _recall()
	WinMinimizeAll()
	WinActivate("Marfdaman Mediaplayer, Brought To You By Marfdaman Inc.")
EndFunc

_splash($splashtime); Show the splashscreen for () milliseconds
WinActivate("Marfdaman")
_start($stepstart, $starttrans)
_volumeslider($startupvolume)
GUICtrlSetData($volumeslider, 100 - $startupvolume)
SoundSetWaveVolume($volume)
If $volume = 100 Then
	GUICtrlSetData($volumelabel, "Current Volume: Full Power")
ElseIf $volume = 0 Then
	GUICtrlSetData($volumelabel, "Current Volume: Extreme Silence")
Else
	GUICtrlSetData($volumelabel, "Current Volume: " & $startupvolume & "%")
EndIf

GUICtrlSetImage($settingssave, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\save.bmp")
GUICtrlSetImage($settingsdiscard, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\cancel.bmp")
GUICtrlSetImage($defaultplaylistbutton, @ProgramFilesDir & "\Marfdaman Mediaplayer\Images\default.bmp")


While 1
	$msg = GUIGetMsg(1)
	$traymsg = TrayGetMsg()
	If $msg[0] > 0 Or $msg[0] = $GUI_EVENT_CLOSE Then
		_guigetmessage()
	EndIf
	If $traymsg <> 0 Then
		_traymessage()
	EndIf
	If $timerset = 1 Then
		_timer()
	EndIf
	If $timer2set = 1 Then
		_timer2()
	EndIf
	If $isplaying = 1 And IsDeclared("timer3") And TimerDiff($timer3) > 2000 Then
		_timer4()
	EndIf
WEnd