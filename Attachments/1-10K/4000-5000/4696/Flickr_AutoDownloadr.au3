; Flickr AutoDownloadr 1.0.1
; Ben Shepherd, September 2005
; Connects to www.flickr.com to download the photos from a given user,
; and displays the photos in a fullscreen window while downloading in the background.

; version history
; 1.0.1 (20/10/5): couple of bugfixes
; added 'delete' functionality for users
; more error checking and reporting when adding new users
; initial ("downloading image 1") window is now a progress bar
; 1.0 (19/10/5): finally, hit 1.0!

#NoTrayIcon
#include <GUIConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <get_image_size.au3>
#include "convert_html_chars.au3"
#include <get_exif_data.au3>
$jheadpath = @TempDir & "\jhead.exe"
FileInstall ("H:\jhead.exe", $jheadpath)

;HttpSetProxy (1)

$appname = "Flickr AutoDownloadr"
$inifile = $appname & ".ini"
$flickrsite = "                     "

$browseaction = IniRead ($inifile, "Main", "BrowseAction", 0)
$userlist = IniRead ($inifile, "Main", "UserList", "")
$friendlynames = IniRead ($inifile, "Main", "FriendlyNames", "")
$defaultuser = IniRead ($inifile, "Main", "DefaultUser", "")
$defaultres = IniRead ($inifile, "Main", "DefaultRes", "high")
$savefolder = IniRead ($inifile, "Main", "SaveFolder", FileGetLongName (@MyDocumentsDir & "\Flickr Photos\"))
$removeonexit = IniRead ($inifile, "Main", "RemoveOnExit", $GUI_UNCHECKED)
$openfolder = IniRead ($inifile, "Main", "OpenFolder", FileGetLongName (@MyDocumentsDir))
$transpeed = IniRead ($inifile, "Main", "TransitionSpeed", 5)
$effect = IniRead ($inifile, "Main", "TransitionEffect", "fade")
$autoadvance = IniRead ($inifile, "Main", "AutoAdvance", 1)
$mintime = IniRead ($inifile, "Main", "MinTime", 5)
$lastpicupdate = 0
$hotkeysset = 0
$getexif = FileExists ($jheadpath)
$exifdata = ""
$verbosity = IniRead ($inifile, "Main", "EXIFVerbosity", 0)
$textsize = IniRead ($inifile, "Main", "TextSize", 10)

If $CmdLine[0] > 0 Then
	;command line args supplied - process them
	Dim $photofile [1]
	For $i = 1 To $CmdLine[0]
		If FileExists ($CmdLine[$i]) Then
			; if it's a list file, add in all the files in the list
			If StringLower (StringRight ($CmdLine[$i], 4)) = ".lst" Then
				Dim $list
				If _FileReadToArray ($CmdLine[$i], $list) = 1 Then
					$listfolder = StringLeft ($CmdLine[$i], StringInStr ($CmdLine[$i], "\", 0, -1) - 1)
					$listdrive = StringLeft ($CmdLine[$i], 2)
					For $j = 1 To $list[0]
						; x:\folder\file or \\server\share\file?
						If StringMid ($list[$j], 2, 1) = ":" Or StringLeft ($list[$j], 2) = "\\" Then
							If FileExists ($list[$j]) Then _ArrayAdd ($photofile, $list[$j])
						; \path\file?
						ElseIf StringLeft ($list[$j], 1) = "\" Then
							If FileExists ($listdrive & $list[$j]) Then _ArrayAdd ($photofile, $listdrive & $list[$j])
						; relative path
						Else
							If FileExists ($listfolder & "\" & $list[$j]) Then _ArrayAdd ($photofile, $listfolder & "\" & $list[$j])
						EndIf
					Next
				EndIf
			ElseIf StringInStr (FileGetAttrib ($CmdLine[$i]), "D") > 0 Then
				$playlistfile = @TempDir & "\" & $appname & " piclist.txt"
				RunWait (@ComSpec & ' /c dir/s/b *.jpg >"' & $playlistfile & '"', $CmdLine[$i], @SW_HIDE)
				$playlist = StringSplit (FileRead ($playlistfile, FileGetSize ($playlistfile)), @CRLF, 1)
				For $j = 1 To $playlist[0]
					;MsgBox (0, $appname, $playlist[$i])
					If FileExists ($playlist[$j]) Then _ArrayAdd ($photofile, FileGetLongName ($playlist[$j]))
				Next
				;FileDelete ($playlistfile)			
			Else
				If FileExists ($CmdLine[$i]) Then _ArrayAdd ($photofile, $CmdLine [$i])
			EndIf
		EndIf
	Next
	If checkFiles () = 0 Then
		MsgBox (0, $appname, "No valid files selected.")
		Exit 1
	EndIf
	$online = 0
	$browseaction = 2
	;_ArrayDisplay ($photofile, "$photofile")
Else
	$winwidth = 440
	$winheight = 220
	;Opt ("GUICoordMode", 2)	; relative to cell mode
	GUICreate ($appname, $winwidth, $winheight, -1, -1, -1, $WS_EX_ACCEPTFILES)
	GUICtrlCreateGroup ("&Browse", 10, 10, $winwidth - 20, 85)
	
	Dim $radio[3]
	$radio[0] = GUICtrlCreateRadio ("Flickr photos from this &user", 20, 25, 160, 20)
	GUICtrlSetTip ($radio[0], "Browse one user's photo archive")
	$radio[1] = GUICtrlCreateRadio ("Flickr photos from &all users", 20, 45, 160, 20)
	GUICtrlSetTip ($radio[1], "Browse a random selection of interesting photos from the last seven days")
	$radio[2] = GUICtrlCreateRadio ("Photos on this &computer", 20, 65, 160, 20)
	GUICtrlSetState ($radio[$browseaction], $GUI_CHECKED)
	
	$userdropdown = GUICtrlCreateCombo ("", 180, 25, 130, 100, $CBS_DROPDOWNLIST)
	GUICtrlSetData ($userdropdown, $friendlynames, $defaultuser)
	$newbutton = GUICtrlCreateButton ("&New...", 320, 25, 45, 20)
	GUICtrlSetTip ($newbutton, "Pick a Flickr user not on this list")
	$deletebutton = GUICtrlCreateButton ("&Delete", $winwidth - 70, 25, 50, 20)
	GUICtrlSetTip ($deletebutton, "Delete this user name from the list")
	$openfilebox = GUICtrlCreateInput ("", 180, 65, 200, 20)
	GUICtrlSetState ($openfilebox, $GUI_DISABLE + $GUI_ACCEPTFILES)
	GUICtrlSetTip ($openfilebox, "Click the button to browse for photos to view, or drag-and-drop")
	$openbrowsebutton = GUICtrlCreateButton ("...", $winwidth - 50, 65, 30, 20)
	
	GUICtrlCreateGroup ("&Flickr", 10, 100, $winwidth - 20, 80)
		
	GUICtrlCreateLabel ("Photo &resolution:", 20, 119, 80, 20)
	$resdropdown = GUICtrlCreateCombo ("low", 120, 115, 100, 100, $CBS_DROPDOWNLIST)
	GUICtrlSetTip ($resdropdown, "Higher resolution photos will take longer to download")
	GUICtrlSetData ($resdropdown, "medium|high|original", $defaultres)
	$reslabel = GUICtrlCreateLabel ("", 230, 119, 150, 20)
	updateResText ()

	GUICtrlCreateLabel ("&Save photos in:", 20, 147, 80, 20)
	$savefolderbox = GUICtrlCreateInput ($savefolder, 120, 145, 150, 20)
	GUICtrlSetTip ($savefolderbox, "The photos will be stored on your computer for viewing")
	GUICtrlSetState ($savefolderbox, $GUI_ACCEPTFILES)
	$savebrowsebutton = GUICtrlCreateButton ("...", 280, 145, 20, 20)

	$removeonexitcheck = GUICtrlCreateCheckbox ("&Remove on exit", 315, 145, 100, 20, $BS_RIGHTBUTTON)
	GUICtrlSetTip ($removeonexitcheck, "Remove the photos from your computer when the program exits")
	GUICtrlSetState ($removeonexitcheck, $removeonexit)

	$okbutton = GUICtrlCreateButton ("OK", $winwidth - 210, $winheight - 30, 60, 20, $BS_DEFPUSHBUTTON)
	$cancelbutton = GUICtrlCreateButton ("Cancel", $winwidth - 140, $winheight - 30, 60, 20)
	$aboutbutton = GUICtrlCreateButton ("About", $winwidth - 70, $winheight - 30, 60, 20)

	GUISetState (@SW_SHOW)
	Do
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton Then
			Exit
		ElseIf $msg = $savebrowsebutton Then
			$newfolder = FileSelectFolder ("Select a folder to save photos", "", 5, $savefolder)
			If $newfolder <> "" Then GUICtrlSetData ($savefolderbox, $newfolder)
		ElseIf $msg = $openbrowsebutton Then
			$openfiles = FileOpenDialog ("Select photos to view", $openfolder, "Photos (*.jpg)|Lists (*.lst)|All files (*.*)", 7)
			If $openfiles <> "" Then
				$photofile = StringSplit ($openfiles, "|")
				If $photofile[0] > 1 Then
					$openfolder = $photofile[1]
					For $i = 2 To $photofile[0]
						$photofile[$i] = $openfolder & "\" & $photofile[$i]
					Next
					_ArrayDelete ($photofile, 0)
				EndIf
				$nphotos = $photofile[0]
				$browseaction = 2
				GUICtrlSetState ($radio[$browseaction], $GUI_CHECKED)
			EndIf
			GUICtrlSetData ($openfilebox, $openfiles)
		ElseIf $msg = $resdropdown Then
			updateResText ()
		ElseIf $msg = $newbutton Then
			; if new user has been typed in the dropdown box, add this to the choices
			; we need to add the |s to make sure we find a whole user name
			;GUISetState (@SW_DISABLE)
			$user = InputBox ($appname, "Enter the user name or URL to photos")
			If $user = "" Then ContinueLoop
			If StringLower (StringLeft ($user, StringLen ($flickrsite))) = $flickrsite Then
				$user = StringMid ($user, StringLen ($flickrsite & "/photos/") + 1)
				$user = StringLeft ($user, StringInStr ($user, "/") - 1)
			EndIf
			GUISetCursor (15, 1) ;wait
			SplashTextOn ($appname, "Querying site: please wait...", 200, 30)
			$friendlyname = getLinkInPage ($flickrsite & "/photos/" & $user & "/", "<TITLE>")
			;MsgBox (0, $appname, $friendlyname)
			If @error Then
				SplashOff ()
				MsgBox (0, $appname, "Error downloading user's page")
			ElseIf $friendlyname = "Flickr: page not found" Then
				SplashOff ()
				MsgBox (0, $appname, "User not found on Flickr site")
			Else
				$friendlyname = StringMid ($friendlyname, StringInStr ($friendlyname, " from ") + 6)
				;MsgBox (0, $appname, $friendlyname)
				If $user <> "" And StringInstr ("|" & $userlist & "|", "|" & $user & "|") = 0 Then
					$userlist = $userlist & "|" & $user
					$friendlynames = $friendlynames & "|" & $friendlyname
					IniWrite ($inifile, "Main", "FriendlyNames", $friendlynames)
					IniWrite ($inifile, "Main", "UserList", $userlist)
				EndIf
				GUICtrlSetData ($userdropdown, $friendlynames, $friendlyname)
				GUICtrlSetState ($radio[0], $GUI_CHECKED)
				SplashOff ()
			EndIf
			;GUISetState (@SW_ENABLE + @SW_SHOW)
			GUISetCursor (2)
			
		ElseIf $msg = $deletebutton Then
			$friendlyname = GUICtrlRead ($userdropdown)
			;MsgBox (0, $appname, $friendlyname & @CRLF & $userlist)
			$userlist = StringSplit ($userlist, "|")
			$friendlynames = StringSplit ($friendlynames, "|")
			For $i = 1 To $userlist[0]
				If $friendlyname = $friendlynames[$i] Then
					;MsgBox (0, $appname, "match:" & $friendlyname)
					_ArrayDelete ($userlist, $i)
					_ArrayDelete ($friendlynames, $i)
					ExitLoop
				EndIf
			Next
			;_ArrayDisplay ($userlist, $appname)
			If UBound ($friendlynames) > 0 Then $friendlyname = $friendlynames[1]
			$userlist = _ArrayToString ($userlist, "|", 1)
			$friendlynames = _ArrayToString ($friendlynames, "|", 1)
			;MsgBox (0, $appname, @error)
			;Exit
			GUICtrlSetData ($userdropdown, "|" & $friendlynames, $friendlyname)
			IniWrite ($inifile, "Main", "FriendlyNames", $friendlynames)
			IniWrite ($inifile, "Main", "UserList", $userlist)
			GUICtrlSetState ($radio[0], $GUI_CHECKED)
			
		ElseIf $msg = $okbutton	Then
			For $i = 0 To 2
				;MsgBox (0, $appname, $i & ": " & GUICtrlGetState ($radio[$i]))
				If GUICtrlRead ($radio[$i]) = $GUI_CHECKED Then $browseaction = $i
			Next
			;MsgBox (0, "BrowseAction", $browseaction)
			If $browseaction = 1 Then
				$user = "All Flickr Users"
			Else
				$friendlyname = GUICtrlRead ($userdropdown)
				$userlist = StringSplit ($userlist, "|")
				$friendlynames = StringSplit ($friendlynames, "|")
				For $i = 1 To $userlist[0]
					If $friendlyname = $friendlynames[$i] Then $user = $userlist[$i]
				Next
			EndIf
			If $browseaction < 2 Then
				$usersavefolder = GUICtrlRead ($savefolderbox) & "\" & $user
				If Not FileExists ($usersavefolder) And Not DirCreate ($usersavefolder) Then
					MsgBox (0, $appname, "Couldn't create folder " & $usersavefolder & " - please choose another.")
					$msg = 0
				EndIf
			Else
				If checkFiles () = 0 Then
					MsgBox (0, $appname, "No valid files selected!")
					$msg = 0
				EndIf
			EndIf
			
		ElseIf $msg = $aboutbutton Then
			MsgBox (0, $appname, "Displays a fullscreen slideshow of the photos you want - " & @CRLF & _
				"whether it's your photos, your friends' photos" & @CRLF & _
				"or a collection of interesting photos on Flickr." & @CRLF & @CRLF & _
				"Questions and abuse to Ben Shepherd: bjashepherd@gmail.com")
		
		ElseIf $msg = $userdropdown Then
			GUICtrlSetState ($radio[0], $GUI_CHECKED)
		EndIf
	Until $msg = $okbutton
	
	IniWrite ($inifile, "Main", "BrowseAction", $browseaction)
	If $browseaction < 2 Then
		$res = GUICtrlRead ($resdropdown)
		Select
		Case $res = "low"
			$ressuffix = "_m"
		Case $res = "medium"
			$ressuffix = ""
		Case $res = "high"
			$ressuffix = "_b"
		Case $res = "original"
			$ressuffix = "_o"
		EndSelect
		$removeonexit = GUICtrlRead ($removeonexitcheck)
		IniWrite ($inifile, "Main", "RemoveOnExit", $removeonexit)
		If StringInStr (FileGetAttrib ($savefolder), "D") = 0 Then DirCreate ($savefolder)
		If $browseaction = 0 Then IniWrite ($inifile, "Main", "DefaultUser", $friendlyname)
		IniWrite ($inifile, "Main", "DefaultRes", $res)
		IniWrite ($inifile, "Main", "SaveFolder", $savefolder)
		$savefolder = $usersavefolder
		$online = 1
	Else
		IniWrite ($inifile, "Main", "OpenFolder", $openfolder)
		$online = 0
	EndIf
	GUIDelete ()
EndIf

Func updateResText ()
	$res = GUICtrlRead ($resdropdown)
	If $res = "low" Then
		$restext = "240 x 180"
	ElseIf $res = "medium" Then
		$restext = "500 x 375"
	ElseIf $res = "high" Then
		$restext = "1024 x 768"
	ElseIf $res = "original" Then
		$restext = "1280+"
	EndIf
	GUICtrlSetData ($reslabel, $restext)
EndFunc	

Func checkFiles ()
	Global $nphotos = UBound ($photofile) - 1
	Global $title[$nphotos + 2], $desc[$nphotos + 2], $photopagearray[$nphotos + 2]
	If $nphotos = 0 Then
		Return 0
	EndIf
	For $j = 1 To $nphotos
		$photofile[$j] = FileGetLongName ($photofile[$j])
		$title[$j] = StringTrimLeft ($photofile[$j], StringInStr ($photofile[$j], "\", 0, -1))
	Next
	Return 1
EndFunc	

;Opt ("GUICoordMode", 1)
HotKeySet ("{ESC}", "Quit")

; we create two windows, so we can fade convincingly between them
Dim $win[2], $img[2]
Dim $label[2][16]
FileInstall ("H:\blank.jpg", @TempDir & "\blank.jpg")
$minimised = 0
For $currentwin = 0 To 1
	$win[$currentwin] = GUICreate ($appname, @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP + $WS_SYSMENU)
	GUISetBkColor (0x000000) ;black
	$img[$currentwin] = GUICtrlCreatePic (@TempDir & "\blank.jpg", 0, 0, @DesktopWidth, @DesktopHeight)
	; create label for photo name: bold + font size 12, top left
	createLabel (0, 10, 10, @DesktopWidth / 2 - 30, 20, -1, 2, 600)
	; photo description: just below name label
	createLabel (2, 10, 35, @DesktopWidth / 2 - 30, 50)
	; EXIF info: top right
	createLabel (4, @DesktopWidth / 2, 10, @DesktopWidth / 2 - 30, @DesktopHeight / 2, $SS_RIGHT)
	; info text: bottom left
	createLabel (6, 10, @DesktopHeight - 30, 3 * @DesktopWidth / 4 - 30, 20)
	; downloading info: bottom right
	createLabel (8, @DesktopWidth / 2, @DesktopHeight - 30, @DesktopWidth / 2 - 30, 20, $SS_RIGHT)
	; help text: centre
	createLabel (10, @DesktopWidth / 4, @DesktopHeight / 4 - 50, @DesktopWidth / 2, 40, $SS_CENTER, 16, 600)
	createLabel (12, @DesktopWidth / 4 - 20, @DesktopHeight / 4, @DesktopWidth / 4, @DesktopHeight / 2, $SS_RIGHT)
	createLabel (14, @DesktopWidth / 2 + 20, @DesktopHeight / 4, @DesktopWidth / 4, @DesktopHeight / 2, $SS_LEFTNOWORDWRAP)
	$helptext = $GUI_SHOW
	help () ; switch off help by default
	updateLabelText (10, "Flickr AutoDownloadr: Help")
	$ht = "Function keys:|left, right, up, down|HOME, END|F1, H|ESC|T|V|O|W|F8|+, -|E|A|<, >" 
	$ht = StringReplace ($ht, "|", @CRLF)
	updateLabelText (12, $ht)
	$ht = @CRLF & "back, forward through images|first, last image downloaded so far|help page on/off|exit|text on/off|more/less info|open in external viewer|view Web page|minimise|increase, decrease text size|change transition effect|auto advance on/off (when online only)|change auto advance time"
	$ht = StringReplace ($ht, "|", @CRLF)
	updateLabelText (14, $ht)

	$texton = $GUI_SHOW
Next
FileDelete (@TempDir & "\blank.jpg")
$currentwin = 0
Func createLabel ($labelnum, $left, $top, $width, $height, $style = -1, $fontsizeextra = 0, $fontweight = 400)
	$label[$currentwin][$labelnum] = GUICtrlCreateLabel ("", $left, $top, $width, $height, BitOR ($style, $SS_NOPREFIX))
	GUICtrlSetFont ($label[$currentwin][$labelnum], $textsize + $fontsizeextra, $fontweight)
	$label[$currentwin][$labelnum + 1] = GUICtrlCreateLabel ("", $left + 1, $top + 1, $width, $height, BitOR ($style, $SS_NOPREFIX))
	GUICtrlSetColor ($label[$currentwin][$labelnum + 1], 0xffffff)
	GUICtrlSetFont ($label[$currentwin][$labelnum + 1], $textsize + $fontsizeextra, $fontweight)
EndFunc

If $online Then 
	;$tempwin = GUICreate ($appname, $winwidth, $winheight)
	;$statuslabel = GUICtrlCreateLabel ( "Downloading first index page..." & @CRLF & "(press ESC to cancel)", 0, 20, $winwidth, $winheight - 20, $SS_CENTER)
	;GUISetState (@SW_SHOW)
	ProgressOn ($appname, "Downloading first index page...", "(press ESC to cancel)")

	If $browseaction = 0 Then
		$nphotos = Number (getLinkInPage ($flickrsite & "/photos/" & $user & "/", '/archives/">Archives</a> ('))
		If $nphotos = 0 Then
			MsgBox (0, $appname, "Failed reading photo index page (error " & @error & ")")
			Exit 1
		EndIf
		;MsgBox (0, $appname, $nphotos & @CRLF & "Error: " & @error)
	
		; search through the page until a link to a non-set photo is found: we don't want to be looking at a set
		$i = 0
		Do
			$i = $i + 1
			$photopage = $flickrsite & getLinkInPage ("", '<a href="/photos/' & $user & '/', $i)
		Until StringInstr ($photopage, "/sets/") = 0
		;MsgBox (0, $appname, $photopage)
	Else
		$photopage = $flickrsite & getLinkInPage ($flickrsite & "/explore/interesting/7days/", '<td class="Photo"><a href="')
		$nphotos = 1000
	EndIf
	
	If @error Then
		MsgBox (0, $appname, "Failed reading photo index page (error " & @error & ")")
		Exit 1
	EndIf
	Dim $photofile [$nphotos + 2], $title[$nphotos + 2], $desc[$nphotos + 2], $photopagearray[$nphotos + 2]

EndIf

$i = 1
Do
	If $online Then
		$begin = TimerInit()
	
		; get photo ID, server, secret code, title, description
		$photopagearray[$i] = $photopage
		$photoid = getLinkInPage ($photopage, "global_photos['")
		$server = getLinkInPage ("", "global_photos['" & $photoid & "'].server = '")
		$secret = getLinkInPage ("", "global_photos['" & $photoid & "'].secret = '")
		$title[$i] = _ConvertHTMLChars (getLinkInPage ("", '<h1 id="title_div' & $photoid & '">'))
		$desc[$i] = _ConvertHTMLChars (getLinkInPage ("", ' class="photoDescription">'))
		;TODO: check for errors here
		
		$photourl = "                         " & $server & "/" & $photoid & "_" & $secret & $ressuffix & ".jpg"
		;MsgBox (0x40000, $appname, $photourl)
		$size = InetGetSize ($photourl)
		
		$photofile[$i] = $savefolder & "\" & $photoid & "_" & $res & ".jpg"
		;MsgBox (0, $appname, $photofile[$i])
		If FileGetSize ($photofile[$i]) <> $size Then
			$done = 0
			While $done = 0
				InetGet ($photourl, $photofile[$i], 0, 1)
				While @InetGetActive = 1
					$progress = Round (100 * @InetGetBytesRead / $size)
					If $progress < 0 Then
						$splashtext = ""
					Else
						$splashtext = "Downloading image " & $i & ": " & $progress & "% done"
					EndIf
					If $i = 1 Then
						;GUICtrlSetData ($statuslabel, $splashtext & @CRLF & "(press ESC to cancel)")
						ProgressSet ($progress, $progress & "% done", "Downloading image " & $i)
					Else
						updateLabelText (8, $splashtext)
					EndIf
					Sleep (500)
				WEnd
				If @InetGetBytesRead >= 0 Then
					$done = 1
				Else
					If MsgBox (4, $appname, "Failed downloading from URL:" & @CRLF & $photourl & @CRLF & @CRLF & "Retry?") = 7 Then ;no
						ExitLoop (2)
					EndIf
				EndIf
			WEnd
			;GUIDelete ($tempwin)
			ProgressOff ()
			
			$timetaken = Round (TimerDiff ($begin) / 1000)
			$splashtext = "Downloaded image " & $i & " in " & $timetaken & " seconds"
			updateLabelText (8, $splashtext)
		EndIf
	EndIf
	
	If $i = 1 Then
		$now = 1
		$direction = 1
		updatePic ()
		GUISetState (@SW_SHOW, $win[0])
		GUISetState (@SW_HIDE, $win[1])
		AdlibEnable ("checkWinState")
		setHotKeys ()
	EndIf
	
	If $browseaction = 0 Then
		$photopage = $flickrsite & getLinkInPage ("", '<a class="contextThumbLink" href="')
	ElseIf $browseaction = 1 Then
		$photopage = $flickrsite & getLinkInPage ($flickrsite & "/explore/interesting/7days/", '<td class="Photo"><a href="', 1, 1)
	EndIf
	;MsgBox (0, "", $photopage)
	$i = $i + 1
	If $autoadvance = 1 And $browseaction < 2 And $minimised = 0 Then
		If TimerDiff ($lastpicupdate) >= 1000 * $mintime Then
			rightPressed ()
		Else
			AdlibEnable ("rightPressed", 1000 * $mintime - TimerDiff ($lastpicupdate))
		EndIf
	EndIf
Until $i > $nphotos

If $online Then 
	;GUIDelete ($tempwin) ;needed in case of an error downloading
	ProgressOff ()
EndIf
Do
Until GUIGetMsg () = $GUI_EVENT_CLOSE

; Image Sizes
;on main page (500px):                                                        
;large:                                                      
;medium:                                                    
;small:                                                      
;		                                         [_size].jpg

Func setHotKeys ()
	HotKeySet ("{ESC}", "Quit")
	HotKeySet ("{RIGHT}", "rightPressed")
	HotKeySet ("{LEFT}", "leftPressed")
	HotKeySet ("{UP}", "upPressed")
	HotKeySet ("{DOWN}", "downPressed")
	HotKeySet ("{HOME}", "firstPic")
	HotKeySet ("{END}", "lastPic")
	HotKeySet ("{F1}", "help")
	HotKeySet ("h", "help")
	HotKeySet ("t", "toggleText")
	HotKeySet ("{F8}", "minimise")
	HotKeySet ("v", "exifVerbosity")
	HotKeySet ("=", "textSizeUp")
	HotKeySet ("-", "textSizeDown")
	HotKeySet ("e", "changeEffect")
	HotKeySet (",", "slowDown")
	HotKeySet (".", "speedUp")
	HotKeySet ("a", "autoAdvanceToggle")
	HotKeySet ("o", "openInExtViewer")
	HotKeySet ("w", "openInBrowser")
	HotKeySet ("[", "autoAdvanceFaster")
	HotKeySet ("]", "autoAdvanceSlower")
	$hotkeysset = 1
EndFunc	

Func cancelHotKeys ()
	HotKeySet ("{ESC}")
	HotKeySet ("{RIGHT}")
	HotKeySet ("{LEFT}")
	HotKeySet ("{UP}")
	HotKeySet ("{DOWN}")
	HotKeySet ("{HOME}")
	HotKeySet ("{END}")
	HotKeySet ("{F1}")
	HotKeySet ("h")
	HotKeySet ("t")
	HotKeySet ("{F8}")
	HotKeySet ("v")
	HotKeySet ("=")
	HotKeySet ("-")
	HotKeySet ("e")
	HotKeySet (",")
	HotKeySet (".")
	HotKeySet ("a")
	HotKeySet ("o")
	HotKeySet ("w")
	HotKeySet ("[")
	HotKeySet ("]")
	$hotkeysset = 0
EndFunc	

; getLinkInPage
; give it a URL and some link text to search for
; it will return the linked-to url
; the link text can be <A HREF="http://www.site.com/
;					   <IMG SRC="
; or anything
; on error, returns "" and sets @error:
; 1: internet download failed
; 2: link not found in downloaded page
; 3: couldn't figure out quote character from context
; 4: couldn't open downloaded page to read
; specify a blank URL to use the last downloaded file
; and not get it from the internet
Func getLinkInPage ($url, $linktext, $occ = 1, $reload = 0)
	; at the moment, we will just use one file for this function
	; however, might need to specify a file later on if we refer to it again outside the function
	; (or maybe pass a ByRef var to hold the filecontents)
	$downloadfile = @TempDir & "\temp.html"
	;$downloadfile = "E:\photo_page.htm"
	;#cs	
	If $url <> "" Then
		If InetGet ($url, $downloadfile, $reload) = 0 Then
			SetError (1)
			Return ""
		EndIf
	EndIf
	;#ce
	$index = FileRead ($downloadfile, FileGetSize ($downloadfile))
	If @error = 1 Then
		SetError (4)
		Return ""
	EndIf
	$beginquotes = "'" & '"<>()'
	$endquotes = "'" & '"><)('
	$quotechar = "" 
	Local $i, $p, $q
	For $i = StringLen ($linktext) To 1 Step -1
		$p = StringInStr ($beginquotes, StringMid ($linktext, $i, 1))
		If $p > 0 Then 
			$quotepos = $i
			$quotechar = StringMid ($endquotes, $p, 1)
			ExitLoop
		EndIf
	Next
	;MsgBox (0, $appname, $quotechar)
	;Msgbox (0, "", $linktext)
	If $quotechar = "" Then
		SetError (3)
		Return ""
	EndIf
	$p = StringInStr ($index, $linktext, 0, $occ)
	$q = StringInStr (StringMid ($index, $p + $quotepos), $quotechar)
	;Msgbox (0, "", $p & " " & $q)
	If $p > 0 And $q > 0 Then
		$retval = StringMid ($index, $p + $quotepos, $q - 1)
		;MsgBox (0, "", $retval)
		Return $retval
	Else
		SetError (2)
		Return ""
	EndIf
	;MsgBox (0, "", $photopage)
EndFunc

Func Quit ()
	If $removeonexit = $GUI_CHECKED And $browseaction < 2 Then
		For $j = 1 To $i - 1
			FileDelete ($photofile[$j])
		Next
		FileDelete ($jheadpath)
	EndIf
	Exit 2
EndFunc

Func updateLabelText ($labelnum, $text)
	GUICtrlSetData ($label[$currentwin][$labelnum], $text)
	GUICtrlSetData ($label[$currentwin][$labelnum] + 1, $text)
EndFunc

Func exifVerbosity ()
	$verbosity = 1 - $verbosity
	updateImageInfo ()
	IniWrite ($inifile, "Main", "EXIFVerbosity", $verbosity)
EndFunc

Func updatePic ()
	cancelHotKeys () ; we need to do this while transitioning or the program gets confused..
	If $effect = "fade to black" Then
		GUISetState (@SW_SHOW, $win[$currentwin])
		$blackwin = GUICreate ($appname, @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP + $WS_SYSMENU)
		WinSetOnTop ($blackwin, "", 1)
		GUISetBkColor (0)
		WinSetTrans ($blackwin, "", 0)
		GUISetState (@SW_SHOW, $blackwin)
		For $t = 255 / (2 * $transpeed) To 255 Step 255 / ($transpeed)
			WinSetTrans ($blackwin, "", $t)
			Sleep (25)
		Next
		$currentwin = 1 - $currentwin
		;GUISetState (@SW_HIDE, $win[1 - $currentwin])
		;GUISetState (@SW_ENABLE, $win[$currentwin])
	EndIf
	GUISwitch ($win[$currentwin])
	updateLabelText (0, $title[$now])
	updateLabelText (2, $desc[$now])
	$imgwidth = 1
	$imgheight = 1
	If $getexif Then
		$exifdata = _GetEXIFData ($photofile[$now])
		If Not @error Then
			updateImageInfo ()
			For $x = 1 To $exifdata[0][0]
				If $exifdata[$x][0] = "Resolution" Then
					$imgsize = StringSplit ($exifdata[$x][1], "x")
					$imgwidth = Number ($imgsize[1])
					$imgheight = Number ($imgsize[2])
					ExitLoop
				EndIf
			Next
		EndIf
	EndIf
	; if this didn't work, use get_image_size - it's slower but more reliable
	If $imgwidth = 1 Then
		$imgsize = _GetImageSize ($photofile[$now])
		If IsArray ($imgsize) Then
			$imgwidth = $imgsize[0]
			$imgheight = $imgsize[1]
		Else
			$imgwidth = @DesktopWidth
			$imgheight = @DesktopHeight
		EndIf
	EndIf
	
	;MsgBox (0, $appname, $imgwidth & " x " & $imgheight)
	$aspectratio = $imgwidth / $imgheight
	If $aspectratio >= 1 Then
		$scale = @DesktopWidth / $imgwidth
		GUICtrlSetPos ($img[$currentwin], 0, 0.5 * (@DesktopHeight - $scale * $imgheight), @DesktopWidth, $scale * $imgheight)
	Else
		$scale = @DesktopHeight / $imgheight
		GUICtrlSetPos ($img[$currentwin], 0.5 * (@DesktopWidth - $scale * $imgwidth), 0, $scale * $imgwidth, @DesktopHeight)
	EndIf
	updateLabelText (6, "Showing image " & $now & " of " & $nphotos)
	If GUICtrlSetImage ($img[$currentwin], $photofile[$now]) = 0 Then
		updateLabelText (6, "Failed to set image to " & $photofile[$now])
		;GUICtrlSetImage ($img, "E:\Ben Shepherd\Pictures\Hall bench 1.jpg")
	ElseIf FileGetSize ($photofile[$now]) = 2873 Then ;probably Flickr's 'image not available' image
		updateLabelText (0, "Image not available")
		updateLabelText (2, "Try using a different resolution setting.")
		updateLabelText (4, "")
		updateLabelText (6, "")
	EndIf
	
	If $effect = "fade" Then
		; fade in the current window
		WinSetTrans ($win[$currentwin], "", 0)
		WinMove ($win[$currentwin], "", 0, 0)
		GUISetState (@SW_SHOW, $win[$currentwin])
		;MsgBox (0, $appname, 255 / $transpeed)
		For $t = 255 / $transpeed To 255 Step 255 / $transpeed
			WinSetTrans ($win[$currentwin], "", $t)
			Sleep (25)
		Next
		;WinSetTrans ($win[$currentwin], "", 255)
		;MsgBox (0, $appname, "here?")
		WinMove ($win[1 - $currentwin], "", @DesktopWidth, 0)
		;MsgBox (0, $appname, TimerDiff ($begin))
	ElseIf $effect = "slide" Or $effect = "shift" Then
		WinMove ($win[$currentwin], "", $direction * @DesktopWidth, 0)
		GUISetState (@SW_SHOW, $win[$currentwin])
		For $x = $direction * @DesktopWidth To 0 Step (-$direction) * @DesktopWidth / $transpeed
			WinMove ($win[$currentwin], "", $x, 0)
			If $effect = "shift" Then WinMove ($win[1 - $currentwin], "", $x - $direction * @DesktopWidth, 0)
			Sleep (25)
		Next
		WinMove ($win[$currentwin], "", 0, 0)
		WinMove ($win[1 - $currentwin], "", @DesktopWidth, 0)
	ElseIf $effect = "fade to black" Then
		For $t = 255 To 255 / (2 * $transpeed) Step -255 / ($transpeed)
			WinSetTrans ($blackwin, "", $t)
			Sleep (25)
		Next
		WinSetTrans ($blackwin, "", 0)
		GUIDelete ($blackwin)
		GUISwitch ($win[$currentwin])
	EndIf
	GUISetState (@SW_HIDE, $win[1 - $currentwin])
	$lastpicupdate = TimerInit ()
	setHotKeys ()
EndFunc

Func changeEffect ()
	Select
	Case $effect = "fade"
		$effect = "slide"
	Case $effect = "slide"
		$effect = "shift"
	Case $effect = "shift"
		$effect = "fade"
	EndSelect
	updateLabelText (6, "Transition '" & $effect & "' selected")
EndFunc

Func slowDown ()
	changeSpeed (-1)
EndFunc

Func speedUp ()
	changeSpeed (1)
EndFunc

Func changeSpeed ($delta)
	$transpeed = Round (($transpeed + 11) / 12) + $delta
	If $transpeed < 1 Then $transpeed = 10
	If $transpeed > 10 Then $transpeed = 1
	If $transpeed = 1 Then
		$suffix = " (instant)"
	ElseIf $transpeed = 10 Then
		$suffix = " (very slow)"
	Else
		$suffix = ""
	EndIf
	updateLabelText (6, "Transition time: " & $transpeed & $suffix)
	$transpeed = 12 * $transpeed - 11
EndFunc

Func updateImageInfo ()
	If Not IsArray ($exifdata) Then Return
	$labeltext = ""
	If $verbosity = 1 Then
		For $x = 4 To $exifdata[0][0]
			If $exifdata[$x][0] <> "" And $exifdata[$x][1] <> "" Then $labeltext = $labeltext & $exifdata[$x][0] & ": " & $exifdata[$x][1] & @CRLF
		Next
	Else
		; first three are just file related (name, size, date)
		For $x = 4 To $exifdata[0][0]
			If $exifdata[$x][0] = "Date/Time" Then
				$labeltext = $exifdata[$x][1]
				ExitLoop
			EndIf
		Next
	EndIf
	updateLabelText (4, $labeltext)
EndFunc

Func changePic ($delta)
	; switch off adlib to prevent more autoadvancement before it's due
	AdlibDisable ()
	; however, this may stop the hotkeys from being re-registered if the window gets minimised
	If $minimised = 1 Then AdlibEnable ("checkWinState")
	If $now = 1 And $delta < 0 Then
		updateLabelText (6, "At first picture")
	ElseIf $now >= $i - 1 And $delta > 0 Then
		updateLabelText (6, "At last picture")
	Else
		updateLabelText (6, "Changing...")
		$now = $now + $delta
		If $now < 1 Then 
			$now = 1
		ElseIf $now > $i - 1 Then
			$now = $i - 1
		EndIf
		$direction = $delta / Abs ($delta)
		$currentwin = 1 - $currentwin
		updatePic ()
	EndIf
EndFunc

Func leftPressed ()
	changePic (-1)
EndFunc
Func rightPressed ()
	changePic (1)
EndFunc
Func upPressed ()
	changePic (-10)
EndFunc
Func downPressed ()
	changePic (10)
EndFunc
Func firstPic ()
	changePic (-$nphotos)
EndFunc
Func lastPic ()
	changePic ($nphotos)
EndFunc

Func help ()
	If $helptext = $GUI_HIDE Then
		$helptext = $GUI_SHOW
	Else
		$helptext = $GUI_HIDE
	EndIf
	Local $i
	For $i = 10 to 15
		GUICtrlSetState ($label[0][$i], $helptext)
		GUICtrlSetState ($label[1][$i], $helptext)
	Next
EndFunc

Func toggleText ()
	If $texton = $GUI_HIDE Then
		$texton = $GUI_SHOW
	Else
		$texton = $GUI_HIDE
	EndIf
	Local $i
	For $i = 0 To 9
		GUICtrlSetState ($label[0][$i], $texton)
		GUICtrlSetState ($label[1][$i], $texton)
	Next
EndFunc

Func textSizeUp ()
	textSizeChange (1)
EndFunc

Func textSizeDown ()
	textSizeChange (-1)
EndFunc

Func textSizeChange ($delta)
	;Opt ("GUICoordMode", 0)	; relative to window
	;GUISetCoord (0, 0)
	;TODO: fix this
	$textsize = $textsize + $delta
	For $w = 0 To 1
		For $x = 0 To 15
			If $x = 0 Or $x = 1 Then
				$extra = 2
			ElseIf $x = 10 Or $x = 11 Then
				$extra = 6
			Else
				$extra = 0
			EndIf
			GUICtrlSetFont ($label[$w][$x], $textsize + $extra)
			;If $x = 6 Or $x = 7 Then
			;	$cp = ControlGetPos ($win[$w], "", $label[$w][$x])
			;	MsgBox (0, $appname, $cp[0] & @CRLF & $cp[1] & @CRLF & $cp[2] & @CRLF & $cp[3])
			;	GUICtrlSetPos ($label[$w][$x], $cp[0], $cp[1] - 4 * $delta)
			;ElseIf $x = 8 Or $x = 9 Then
			;	$cp = ControlGetPos ($win[$w], "", $label[$w][$x])
			;	GUICtrlSetPos ($label[$w][$x], $cp[0], $cp[1] - 4 * $delta, $cp[2], $cp[3] + 4 * $delta)
			;EndIf
		Next
	Next
	IniWrite ($inifile, "Main", "TextSize", $textsize)
EndFunc

Func minimise ()
	;stop autoadvancement
	AdlibDisable ()
	GUISetState (@SW_MINIMIZE, $win[$currentwin])
	$minimised = 1
	AdlibEnable ("checkWinState")
	cancelHotKeys ()
EndFunc

Func autoAdvanceToggle ()
	If $browseaction = 2 Then Return
	If $autoadvance = $GUI_CHECKED Then
		$autoadvance = $GUI_UNCHECKED
		$aatxt = "off"
	Else
		$autoadvance = $GUI_CHECKED
		$aatxt = "on, every " & $mintime & " seconds"
	EndIf
	updateLabelText (6, "Auto advance " & $aatxt)
	IniWrite ($inifile, "Main", "AutoAdvance", $autoadvance)
EndFunc

Func autoAdvanceFaster ()
	If $mintime > 1 Then $mintime = $mintime - 1
	updateLabelText (6, "Auto advance interval: " & $mintime & " seconds")
	IniWrite ($inifile, "Main", "MinTime", $mintime)
EndFunc

Func autoAdvanceSlower ()
	$mintime = $mintime + 1
	updateLabelText (6, "Auto advance interval: " & $mintime & " seconds")
	IniWrite ($inifile, "Main", "MinTime", $mintime)
EndFunc

Func checkWinState ()
	; check if the window has been restored; if so we need to re-enable the hotkeys
	;$q = $q + 1
	;updateLabelText (6, "checking " & $q)
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit 2
	;updateLabelText (6, WinGetState ($win[$currentwin]))
	If $hotkeysset = 0 And BitAND (WinGetState ($win[$currentwin]), 8) Then
		setHotKeys ()
		$minimised = 0
	EndIf
EndFunc

Func openInExtViewer ()
	minimise ()
	;MsgBox (0, "", $now)
	Run ('cmd.exe /c start "" "' & $photofile[$now] & '"', "", @SW_HIDE)
EndFunc

Func openInBrowser ()
	If $browseaction < 2 Then
		minimise ()
		;MsgBox (0, "", $now)
		Run ('cmd.exe /c start "" ' & $photopagearray[$now], "", @SW_HIDE)
	EndIf
EndFunc