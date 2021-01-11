#include <GUIConstants.au3>
#include <GuiList.au3>
#Include <GuiListView.au3>
#Include <Array.au3>
#Include <File.au3>
#Include <String.au3>
#include <Misc.au3>
$color = 0x6F8BFD
$color2 = 0x6F8BFD
$maincolor = 0xD0D3FB
$maincolor2 = 0xD0D3FB
$lcolor = 0
$lcolor2 = 0
$name = "yourTunes"
$count = 1 ; used for general counting
$a = 1 ;used for CD folders
$b = 1 ;used when trimming the right
$c = 1 ;used when trimming the left
$v = 45 ;used for volume

	$wholegui = GuiCreate($name, 900, 704, -1, -1)
	GUISetBkColor ($color)
	GUISetFont (12)
	
	$filemenu = GuiCtrlCreateMenu ("File")
		$addfile = GuiCtrlCreateMenuItem("Add a file...", $filemenu)
		$addfolder = GuiCtrlCreateMenuItem("Add a folder...", $filemenu)
			GuiCtrlCreateMenuitem ("",$filemenu)
		$libraryinfo = GuiCtrlCreateMenuItem("Get Library Info", $filemenu)
			GuiCtrlCreateMenuitem ("",$filemenu)
		$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)

		
	$edit = GuiCtrlCreateMenu ("Edit")
		$clear = GuictrlCreateMenuItem("Clear Selected Songs", $edit)
		
	$controlmenu = GuiCtrlCreateMenu("Controls") 
		$stopplayitem = GuiCtrlCreateMenuItem("Play                         Enter", $controlmenu)
				GuiCtrlSetState($stopplayitem, $GUI_Disable)
			GuiCtrlCreateMenuitem ("",$controlmenu)
		$nextitem = GuiCtrlCreateMenuItem("Next                        Ctrl+N", $controlmenu)
				GuiCtrlSetState($nextitem, $GUI_Disable)
		$backitem = GuiCtrlCreateMenuItem("Back                        Ctrl+B", $controlmenu)
				GuiCtrlSetState($backitem, $GUI_Disable)
			GuiCtrlCreateMenuitem ("",$controlmenu)
		$volumeup = GuiCtrlCreateMenuItem("Volume Up               Ctrl+Up", $controlmenu)
		$volumedown = GuiCtrlCreateMenuItem("Volume Down          Ctrl+Down", $controlmenu)
		$mute = GuiCtrlCreateMenuItem("Mute                       Ctrl+M", $controlmenu)
			GuiCtrlCreateMenuitem ("",$controlmenu)
		$ejectdisc = GuiCtrlCreateMenuITem("Eject Disc                Ctrl+E", $controlmenu)
		
	$extrasmenu = GuiCtrlCreateMenu ("Extras")
		$changecolor = GuiCtrlCreateMenuItem("Change color layout", $extrasmenu)
	
	$main = GuiCtrlCreateListview("", 4, 6, 892, 610, $LVS_SHOWSELALWAYS)
		GUICtrlSetBkColor($main, $maincolor)
		_GUICtrlListViewInsertColumn($main, 0, "Name", "", 252)
		_GUICtrlListViewInsertColumn($main, 1, "Album", "", 252)
		_GUICtrlListViewInsertColumn($main, 2, "Artist", "", 252)
		_GUICtrlListViewInsertColumn($main, 3, "File Size", "", 132)
		$B_DESCENDING = (_GUICtrlListViewGetSubItemsCount ($main))

$read = InireadsectionNames(@DesktopCommonDir & "\Music.ini")
$q = 1
$e = 1 
Do
	Do 
		$more = InireadSection(@DesktopCommonDir & "\Music.ini", $read[$q])
		$evenm = Stringsplit($more[$e][1], "\")
		If @error then exitloop
		GUICtrlCreateListViewItem($more[$e][0] & "|" & $evenm[1] & "|" & $read[$q] & "|" & $evenm[2] & "KB", $main)
		$e += 1
		Until $more[0][0] < $e
	$q += 1
	$e = 1
	Until $q > $read[0]


	$volumelabel = GuiCtrlCreateLabel("Volume:", 700, 625, 60, 25)
	$slider = GuiCtrlCreateSlider(760, 623, 130, 25)
		GUICtrlSetLimit(-1,100,0)
		GUICtrlSetData($slider,$v)
		
	$search = GuiCtrlCreateInput("", 70, 624, 200, 23)
		$searchlabel = GuiCtrlCreatelabel("Search", 10, 627, 60, 25)
		$go = GuiCtrlCreateButton("Go", 273, 623, 30, 25)
	$play = GuiCtrlCreateButton("Play Selected Song", 350, 623, 200, 25)
	$next = GuICtrlCreateButton(">", 560, 623, 30, 25)
	$back = GuiCtrlCreateButton("<", 310, 623, 30, 25)
	$stop = GuiCtrlCreateButton("Stop", 608, 623, 80, 25)
		GuiCtrlSetState($stop, $GUI_Disable)
	
	$currentsong = GuiCtrlCreateLabel("Song Playing:", 10, 655, 110, 25)
	$songplaying = GuiCtrlCreateInput("", 115, 654, 645, 23, Bitor($ES_Readonly, $ES_CENTER), $WS_EX_STATICEDGE)
	$exit = GuiCtrlCreateButton("Exit", 770, 653, 120, 25)
	

Guisetstate()

Loop()
Func Loop()
While 1
	$msg = Guigetmsg()
		If $msg = $GUI_EVENT_CLOSE Then Exit
		If $msg = $exit Then Exit
		If $msg = $exititem Then Exit
		If $msg = $addfile Then Addfile()
		If $msg = $addfolder Then Addfolder()
		If $msg = $next  Then Next1()
		If $msg = $nextitem Then Next1()
		If BitAND(_IsPressed("11"), _ISpressed("4E"), WinActive($name)) then Next1()
		If $msg = $back Then Back()
		If $msg = $backitem Then Back()
		If BitAND(_IsPressed("11"), _ISpressed("42"), WinActive($name)) Then Back()
		If $msg = $volumeup Then 
			$v = $v + 10
			GUICtrlSetData($slider,$v)
			Endif
		If BitAnd(_IsPressed("11"), _IsPressed("26"), WinActive($name)) Then 
			$v = $v + 2
			GUICtrlSetData($slider,$v)
			Endif
		If $msg = $volumedown Then 
			$v = $v - 10
			GUICtrlSetData($slider,$v)
			Endif
		If BitAnd(_IsPressed("11"), _IsPressed("28"), WinActive($name)) Then 
			$v = $v - 2
			GUICtrlSetData($slider,$v)
			Endif	
		If $msg = $mute Then Mute()
		If BitAnd(_IsPressed("11"), _IsPressed("4D"), WinActive($name)) Then Mute()
		If $msg = $ejectdisc Then CDTray("D:", "Open")
		If BitAND(_IsPressed("11"), _ISpressed("45"), WinActive($name)) Then CDTray("D:", "Open")
		If BitAND(_IsPressed("11"), _ISpressed("53"), WinActive($name)) Then Stop()
		If $msg = $main Then _GUICtrlListViewSort($main, $B_DESCENDING, GUICtrlGetState($main))
		If $msg = $stopplayitem Then Stop() 
		If $msg = $changecolor Then Changecolor()
		If $msg = $play or _IsPressed("0D") Then Play()
		If $msg = $stop Then Stop()
		If $msg = $clear then 
			$f = _GUICtrlListViewGetCurSel($main)
			$ff = _GUICtrlListViewGetItemTextArray($main, $f)
			_GUICtrlListViewDeleteItemsSelected ($main)
			Msgbox(0, "", "Artist: " & $ff[3] & "     Key: " & $ff[1])
			Inidelete(@DesktopCommonDir & "\Music.ini", $ff[3], $ff[1])
			Endif
		If $msg = $libraryinfo then 
			If _GUICtrlListViewGetItemCount($main) > 1 Then Msgbox(0, "Library Info", "You have " & _GUICtrlListViewGetItemCount($main) & " songs in you library")
			If _GUICtrlListViewGetItemCount($main) = 1 Then Msgbox(0, "Library Info", "You have 1 song in you library")	
			If _GUICtrlListViewGetItemCount($main) = 0 Then Msgbox(0, "Library Info", "You have no songs in you library")
			Endif
		If $msg = $go then mySearch(GuiCtrlRead($search), 3, 6, 0)
		SoundSetWaveVolume(GuiCtrlRead($slider))
	Wend 
Endfunc



Func Addfile()
	While 1
		$songtoadd = FileOpenDialog("Choose file...", @MyDocumentsDir & "\My Music", "(*.mp3)|(*.wav)")
		$songsize = Filegetsize($songtoadd)
		$1songsize = Round ($songsize / 1024)
		$songsize = _Stringinsert($1songsize, ",", -3)
		If @error then exitloop
		$string = Stringsplit($songtoadd, "\")
		$x = $string[0] - 1
		$album = $string[$x]
		$w = $string[0] - 2
		$artist = $string[$w]
		$y = $string[0]
		$song = $string[$y]
		$simpsong = Stringsplit($song, ".")
		$song = $simpsong[1]
		$item1 = GuiCtrlCreateListViewItem($song & "|" & $album & "|" & $artist & "|" & $songsize & " KB", $main)
		Exitloop
	Wend
Endfunc

Func Play()
		If winactive($name) then
			$songtoplay = Stringsplit(GUICtrlRead(GUICtrlRead($Main)), "|")
			If GUICtrlRead($Main) = "" then Loop()
			Guictrlsetdata($songplaying, $songtoplay[1])
			Soundplay(@MyDocumentsDir & "\My Music\" & $songtoplay[3] & "\" & $songtoplay[2] & "\" & $songtoplay[1] & ".mp3", 1)
			GuiCtrlSetState($stop, $GUI_Enable)
			GuiCtrlSetState($stopplayitem, $GUI_Hide)
			Traytip("", "Current song: " & $songtoplay[1], 2)
			GuiCtrlSetState($nextitem, $GUI_Enable)
			GuiCtrlSetState($backitem, $GUI_Enable)
		Endif
Endfunc

	
Func Addfolder()
While 1
	$z = 1
	$x = 1
	$Foldertoadd = FileSelectFolder("Choose a folder to add to your library", @MyDocumentsDir)
	If @error then exitloop
	$file = _FileListToArray($Foldertoadd)
	Do
		$completedir = $Foldertoadd & "\" & $file[$z]
		$songsize = Filegetsize($completedir)
		$1songsize = Round ($songsize / 1024)
		;Msgbox(0, "", $1songsize)
		$newsongsize = (_Stringinsert ($1songsize, "____", -3))
		;Msgbox(0, "", $newsongsize)
		$string = StringSplit($completedir, "\")
		$x = $string[0] - 1
		$album = $string[$x]
		$w = $string[0] - 2
		$artist = $string[$w]
		$y = $string[0]
		$ofcsong = $string[$y]
		$simpsong = Stringsplit($ofcsong, ".mp3", 1)
		If $simpsong[0] <> 1 then
			$song = $simpsong[1]
			$verifymp3= $simpsong[0] 
			GuiCtrlCreateListViewItem($song & "|" & $album & "|" & $artist & "|" & $newsongsize & " KB", $main)
			Iniwrite(@DesktopCommonDir & "\Music.ini", $artist, $song, $album & "\" & $newsongsize)
			$z = $z + 1
			EndIf
		If $simpsong[0] = 1 then 
			$z = $z + 1
			Endif
	Until $z > $file[0]
	Exitloop
	Wend
Endfunc
	
Func Changecolor ()
	$colorchange = GuiCreate("Color Properties", 300, 390)
		GUISetBkColor ($color)
	$bkcolor = GuiCtrlCreateButton("Change background", 10, 10, 280, 25)
	$lbcolor = GuiCtrlCreateButton("Change label color", 10, 45, 280, 25)
	$amaincolor = GuiCtrlCreateButton("Change list color", 10, 80, 280, 25)
	$samplelabel = GuiCtrlCreateLabel("This will be the color of you label", 10, 300, 290, 25, $SS_CENTER)
		GUICtrlSetColor(-1,$lcolor)
	$samplemain = GuiCtrlCreateLabel("", 70, 120, 160, 160, "", $WS_EX_STATICEDGE)
		GuiCtrlSetBkColor(-1, $maincolor)
	$ok = GuiCtrlCreateButton("OK", 40, 340, 80, 30)
	$cancel = GuiCtrlCreateButton("Cancel", 180, 340, 70, 30)
	GuiSetState()
	
	While 1
		$ms = GuiGetMsg()
			If $ms = $GUI_EVENT_CLOSE then
				GuiDelete($colorchange)
				Loop()
				Endif
			If $ms = $cancel then 	
				GuiDelete($colorchange)
				Loop()
				Endif
			If $ms = $bkcolor then 
				$color2 = _ChooseColor (2, $color, 2)
				GUISetBkColor($color2)
				Endif
			If $ms = $lbcolor then 
				$lcolor2 = _ChooseColor (2, $lcolor, 2)
				GUICtrlSetColor($samplelabel, $lcolor2)
				Endif
			If $ms = $amaincolor then 
				$maincolor2 = _ChooseColor (2, $maincolor, 2)
				GuiCtrlSetBkColor($samplemain, $maincolor2)
				Endif
			If $ms <> $bkcolor Then $color = $color2	
			If $ms <> $maincolor Then $maincolor = $maincolor2
			If $ms = $ok Then
				GuiCtrlSetState($slider, $GUI_Disable)
				GUICtrlSetColor($currentsong, $lcolor2)
				GUICtrlSetColor($volumelabel, $lcolor2)
				GUICtrlSetColor($searchlabel, $lcolor2)
				GUICtrlSetBkColor($main, $maincolor2)
				GUISetBkColor($color2, $wholegui)
				$color = $color2
				$lcolor = $lcolor2
				$maincolor = $maincolor2
				GuiCtrlSetState($slider, $GUI_Enable)
				GuiDelete($colorchange)
				Exitloop
				Endif
	Wend
EndFunc


Func Stop()
	If winactive($name) then
		If GUICtrlGetState($stop) = 80 then
			Soundplay(@WindowsDir & "\media\start.wav")
			GuiCtrlSetState($stop, $GUI_Disable)
			GuiCtrlSetData($songplaying, "")
		Endif
	Endif
Endfunc

#cs
Func Getsong()
Do
	Global $Folder = _FileListToArray(@MyDocumentsDir & "\My Music\" & $artist)
	Global $Foldera = _FileListToArray(@MyDocumentsDir & "\My Music\" & $artist & "\" & $Folder[$a])
	Do 
		Do
			$goodright = StringRight($song, 7)
			$Goodrightfive = StringRight($Foldera[$b], 7)
		IF $goodright = $Goodrightfive then exitloop
			$Foldera[$b] = StringTrimRight($Foldera[$b], 1)
			$count = $count + 1
		IF $goodright = $Goodrightfive then exitloop
		Until $count > 6
			IF $goodright <> $Goodrightfive then $b = $b + 1
			IF $goodright <> $Goodrightfive then $count = 1
				IF $goodright = $Goodrightfive then
					$count = 1
					Do
						Do
							$goodleft = stringleft($song, 7)
							$Goodleftfive = StringLeft($Foldera[$c], 7)
						If $goodleft = $goodleftfive then exitloop	
							$Foldera[$c] = StringTrimLeft($Foldera[$c], 1)
							$count = $count + 1
						If $goodleft = $goodleftfive then exitloop
						Until  $count > 6
							If $goodleft <> $goodleftfive then $c = $c + 1
							If $goodleft <> $goodleftfive then $count = 1
							If $goodleft = $goodleftfive then exitloop
					Until $c > $foldera[0]
				Endif
		If $goodright = $goodrightfive then exitloop		
		Until $b > $foldera[0]
		If $B = $C then exitloop
		If $B <> $C then 
			$a = $a + 1
			$b = 1
			$c = 1
			$count = 1
		Endif
		Continueloop
		If $B = $C then exitloop
Until $a > $folder[0]
Endfunc		
#ce

Func Next1()
		GuiCtrlSetState($main, $GUI_Focus)
		Send("{down}")
		Play()
	Endfunc
	
Func Back()
		GuiCtrlSetState($main, $GUI_Focus)
		Send("{up}")
		Play()
	Endfunc
	
Func Mute()
	Send("{VOLUME_MUTE}")
	If GuiCtrlRead($mute) = 68 then 
		GUICtrlSetState($mute,$GUI_CHECKED)
		Loop()
		Endif
	If GuiCtrlRead($mute) = 65 then 
		GUICtrlSetState($mute,$GUI_UNCHECKED)
		Loop()
		Endif			
	Endfunc
	
Func Search()
	$r = 0
	$total = _GUICtrlListViewGetItemCount($main)
	Do
		$ret = _GUICtrlListViewGetItemText ($main, $r, 0)
		If $ret = GuiCtrlRead($search) then 
			_GUICtrlListViewSetItemSelState($Main, $r, 1, 1)
			Play()
			Exitloop
			Endif
		$r = $r + 1 
		Until $r > $total
	
	Endfunc
	
Func mySearch($search, $start, $end, $c)
	If $search = "" then Seterror(1)
	$r = $start
	If $end = -1 then $totala = _GUICtrlListViewGetItemCount($main)
	If $end < -1 then return Seterror(1)
	If $end > -1 then $totala = $end
	If $end > _GUICtrlListViewGetItemCount($main) then $totala = _GUICtrlListViewGetItemCount($main)
	Do
		$ret = _GUICtrlListViewGetItemText ($main, $r, $c)
		If $ret = $search then 
						_GUICtrlListViewSetItemSelState($Main, $r, 1, 1)
			Play()
			Return 1
			Exitloop
			Endif
		$r = $r + 1 
	Until $r > $totala
	If $r > $totala then Seterror(2)
Endfunc	