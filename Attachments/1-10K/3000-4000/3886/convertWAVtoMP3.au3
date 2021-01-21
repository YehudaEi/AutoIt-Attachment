;WAV to MP3 Automator 1.0
;
;by Glenn Martin, 7/7/2005
;
;Purpose:	I was frustrated by the lack of free CD ripping utilities on the web. Those that were available	either
;			limited which tracks you could rip or how many you could rip before you would need to register the program.
;			Then I discovered that while my music player of choice, the free version of WinAmp, would not allow me to rip tracks
;			to MP3 without registering, it would allow me to rip to WAV without restriction. A quick search for "free audio
;			editor" later and I had found Audacity, which would let me convert the tracks from WAV to MP3 after ripping. And
;			because I could find no way to convert files in bulk, I wrote one: the file you are reading right now.
;
;			Enjoy.
;
;
;
;Requires:  *WinAmp 5.0 or later
;				* set General Prefs -> CD Ripping -> Specify Naming Conventions
;				equal to "<Artist> - <Album>\[<Album>][##]<Artist> - <Title>" before ripping tracks
;			*Audacity 1.2.2 or later
;				* add the shortcut Ctrl-\ to mean "Export as MP3"
;			*AutoIt v3 (of course!)
;
;Shoutouts:	* The AutoIt community.
;			* the folks at Mozilla.org, for giving us Firefox, truly the greatest web browser ever.
;			* the makers of Crimson Editor, my text editor of choice.
;			* Nullsoft, for giving us WinAmp.
;			* Dominic Mazzoni, Joshua Haberman, Matt Brubeck, and the whole Audacity team.
;			* Sourceforge.net, the guys who host Audacity.
;
;Contact:	* Email me! 	gamartin@student.umass.edu
;			* IM me!		MrWantsToBeMrBig

Opt("WinTitleMatchMode",2)

;NOTE: all commented MsgBoxes were for debug purposes. I'm leaving them in for future editing.
;If you plan to use the file as is and make no improvements, feel free to delete them.

;expected input: a pathname (e.g. G:\cd Ripped) that contains an m3u file
Dim $pathname = InputBox("File Name", "Enter pathname (omit final \):")
;MsgBox(1,"pathname",$pathname)

Dim $lastslash = StringInStr($pathname, "\", 0, -1)
;MsgBox(1,"lastslash",$lastslash)								

Dim $m3ufilename = StringTrimLeft($pathname, $lastslash)
;MsgBox(1,"m3ufilename",$m3ufilename)

Dim $dash = StringInStr($m3ufilename, "-")
;MsgBox(1,"dash",$dash)

;get title of album and artist
Dim $artist = StringLeft($m3ufilename, $dash - 1)
;MsgBox(1,"artist",$artist)

Dim $album = StringTrimLeft($m3ufilename, $dash + 1)
;MsgBox(1,"album",$album)

$m3ufilename = $m3ufilename & ".m3u"
;MsgBox(1,"m3ufilename",$m3ufilename)

;open the m3ufile
$playlist = FileOpen($pathname & "\" & $m3ufilename, 0)
;MsgBox(1,"playlist opened?",$playlist)
If $playlist = -1 then
	MsgBox(0, "Error", "M3U file " & $pathname & "\" & $m3ufilename & " not found. Exiting.")
	Exit
EndIf

;read in, line by line, each song title
Dim $tracknum = 1
;MsgBox(1,"tracknum",$tracknum)

Dim $wavfilename = FileReadLine($playlist, (2 * $tracknum + 1))

Do
	;MsgBox(1,"wavfilename",$wavfilename)
	
	$wavfilenamedash = StringInStr($wavfilename, "-")
	;MsgBox(1,"wavfilenamedash",$wavfilenamedash)
	
	$title = StringTrimLeft($wavfilename, $wavfilenamedash + 1)
	$title = StringTrimRight($title, 4)
	;MsgBox(1,"title",$title)
	
	Send("#r")
	WinWaitActive("Run")
	Send("{ASC 034}e:\audacity\audacity.exe{ASC 034} {ASC 034}")
	Send($pathname & "\" & $wavfilename)
	Send("{ASC 034}")

	Send("{ENTER}")

	WinWaitActive("Import")
	WinWaitNotActive("Import")
	
	Send("^\")
	WinWaitActive("Save MP3 File As:")
	Send($pathname & "\" & $wavfilename)
	Send("{BACKSPACE 3}MP3")
	Send("{ENTER}")
	WinWaitActive("Edit the ID3 tags for the MP3 file")
	Send("{TAB 2}" & $title)
	Send("{TAB}" & $artist)
	Send("{TAB}" & $album)
	Send("{TAB}" & $tracknum & "{ENTER}")
	WinWaitActive("Export")
	WinWaitNotActive("Export")
	Send("!{F4}")
	Send("!n")
	
	$tracknum = $tracknum + 1
	;MsgBox(1,"tracknum",$tracknum)
	
	$wavfilename = FileReadLine($playlist, 2 * $tracknum + 1)
Until $wavfilename = ""