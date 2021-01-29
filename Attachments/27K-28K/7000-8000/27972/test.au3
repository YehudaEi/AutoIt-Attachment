#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <IE.au3>
#Include <string.au3>
#include <array.au3>
Opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
;22.09.2009 12:30

local $guipre = GUICreate("DVB-Shotter 5.45 preload", 270, 250, -1, -1, $WS_BORDER)
$dvb1 = GUICtrlCreateCheckbox("DVB Viewer", 10, 10, 130, 20)
$dvb2 = GUICtrlCreateCombo("Hotkey (opt.)", 170, 10, 85, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "F3|F4|F5|F6|F7|F8|F9", "Hotkey (opt.)")
$vlc1 = GUICtrlCreateCheckbox("", 10, 40, 20, 20)
$vlcs = GUICtrlCreateCombo("VLC media player", 30, 40, 130, 20, $CBS_DROPDOWNLIST)
$vlc2 = GUICtrlCreateCombo("Hotkey (opt.)", 170, 40, 85, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "F3|F4|F5|F6|F7|F8|F9", "Hotkey (opt.)")
$lss1 = GUICtrlCreateCheckbox("BB-10 Livestream", 10, 70, 130, 20)
$lss2 = GUICtrlCreateCombo("Hotkey (opt.)", 170, 70, 85, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "F3|F4|F5|F6|F7|F8|F9", "Hotkey (opt.)")
GUICtrlCreateGroup("Konfig-Datei", 5, 95, 255, 90, $WS_DLGFRAME)
GuiCtrlCreateLabel("(nur die ??? ersetzen):", 10, 110, 245, 20, $SS_CENTER)
GUICtrlSetColor(-1,0xff0000)
GUICtrlCreateInput ( @AppDataDir & "\???.cfg", 15, 130, 235, 20, $ES_READONLY+$ES_AUTOHSCROLL)
$prec = GUICtrlCreateInput ( "", 85, 155, 100, 20) 
$hilfe = GuiCtrlCreateButton("Hilfe", 210, 155, 40, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1) 
$preshotter = GuiCtrlCreateButton("DVB-Shotter starten", 80, 193, 110, 25)
$exit = GuiCtrlCreateButton("Exit", 220, 198, 40, 20)
GUICtrlSetState ( 4, $GUI_DISABLE)
GUICtrlSetState ( 6, $GUI_DISABLE)
GUICtrlSetState ( 7, $GUI_DISABLE)
GUICtrlSetState ( 8, $GUI_DISABLE);
GUICtrlSetState ( 9, $GUI_DISABLE)
GUISetState(@SW_SHOW)
$child = 1
Do
	Sleep(10)
	$mMsg = GUIGetMsg()
	Switch $mMsg
		Case $preshotter
			$precfg = @AppDataDir & "\" & GUICtrlRead ($prec) & ".cfg"
			$precfg0 = GUICtrlRead ($prec)
			if GUICtrlRead ($prec) = "" then
			    $precfg = @AppDataDir & "\dvb-shotter.cfg"
				$precfg0 = "dvb-shotter"
			endif
			if FileReadLine ( $precfg, 16) = "zugriff" then
				if MsgBox(20, "Fehler", $precfg & @CRLF & @CRLF & "Gewählte Konfig-Datei wird gerade verwendet!" & @CRLF & @CRLF & "Trotzdem fortfahren?") = 6 then $child = 0
			Else
				$child = 0
			endif
		case $exit
			exit
		Case $hilfe
			MsgBox(64, "Hilfe", "Feld leer lassen = Konfiguration ""dvb-shotter.cfg"" wird geladen." & @CRLF & @CRLF & "Vorhandenen Dateiname eingeben lädt diese als Konfiguration." & @CRLF & @CRLF & "Neuen Dateiname eingeben erstellt eine neue Konfigurationsdatei.")
		Case $dvb1
			if GUICtrlRead ( $dvb1 ) = 1 Then
				GUICtrlSetState ( 4, $GUI_ENABLE)
			Else
				GUICtrlSetData(4, "Hotkey (opt.)")
				GUICtrlSetState ( 4, $GUI_DISABLE)
			EndIf
		Case $vlc1
			if GUICtrlRead ( $vlc1 ) = 1 Then
				$vlcerr = 0
				If FileExists(@AppDataDir & "\vlc\vlcrc") Then
					$chars = FileRead(@AppDataDir & "\vlc\vlcrc")
                    $result = StringSplit($chars, "snapshot-path=", 1)
                    $result2 = StringSplit($result[2], ".jpg", 1)
                    $datei2 = $result2[1] & ".jpg"
                    $typ = StringRight ( $datei2, 4 )
                    if $typ = ".jpg" AND StringInStr ( $chars, "snapshot-format=jpg") then
						if (StringLen ( $datei2 ) - StringInStr ( $datei2, "\", 0, -1)) > 22 OR StringInStr ( $datei2, " ") > 0 then 
							MsgBox(16,"VLC Einstellungen bitte anpassen:", "Einstellungen-->Video" & @CRLF & "Video-Schnappschuss-Verzeichnis: (Pfad UND Dateiname) !!!" & @CRLF & @CRLF & "Beispiel: ""C:\Windows\Temp\vlcsnap.jpg""" & @CRLF & "(KEINE Leer- und Sonder-Zeichen!)" & @CRLF & @CRLF & "Video-Schnappschuss-Format: jpg")
							$vlcerr = 1
						endif
				    else
						MsgBox(16,"VLC Einstellungen bitte anpassen:", "Einstellungen-->Video" & @CRLF & "Video-Schnappschuss-Verzeichnis: (Pfad UND Dateiname) !!!" & @CRLF & @CRLF & "Beispiel: ""C:\Windows\Temp\vlcsnap.jpg""" & @CRLF & "(KEINE Leer- und Sonder-Zeichen!)" & @CRLF & @CRLF & "Video-Schnappschuss-Format: jpg")
						$vlcerr = 1
			        endif
					if StringInStr ( $chars, "image-out-replace=1") = 0 and StringInStr ( $chars, "scene-replace=1") = 0 then
							MsgBox(16,"VLC Einstellungen bitte anpassen:", "Einstellungen-->Video-->Ausgabemodule-->Bilddatei" & @CRLF & @CRLF & "Haken bei ""Immer in die selbe Datei schreiben""")
							$vlcerr = 1
					endif
		            if StringInStr ( $chars, "key-snapshot=s") = 0 OR StringInStr ( $chars, "key-stop=s") > 0 then
						MsgBox(16,"VLC Einstellungen bitte anpassen:", "Einstellungen-->Interface-->Hotkeys-Einstellungen" & @CRLF & @CRLF & "Videoschnappschuss:    ""s""    ohne [ALT], [STGR], [SHIFT]" & @CRLF & @CRLF & "Taste ""s"" darf NICHT  durch weitere Hotkeys (Stop-Funktion) belegt sein!!!")
						$vlcerr = 1
					endif
			        FileInstall("dummy", $datei2, 1)
                    if FileReadLine ( $datei2, 1) = "dummy" then
						FileDelete ($datei2)
		            Else
						MsgBox(16,"VLC Einstellungen prüfen!", "Test-Zugriff auf """ & $datei2 & """ fehlgeschlagen!" & @CRLF & @CRLF & "Einstellungen-->Video" & @CRLF & "Video-Schnappschuss-Verzeichnis: (Pfad UND Dateiname) !!!" & @CRLF & @CRLF & "Beispiel: ""C:\Windows\Temp\vlcsnap.jpg""" & @CRLF & "(KEINE Leer- und Sonder-Zeichen!)" & @CRLF & @CRLF & "Video-Schnappschuss-Format: jpg")
						$vlcerr = 1
			        EndIf
				else
					$datei2 = @TempDir & "\09876.jpg"
		            $typ = ".jpg"
		            $vlcerr = 1
		            MsgBox(16,"Fehler:", "VLC-Player nicht gefunden! KonfigDatei ""VLCRC"" wird in """ & @AppDataDir & "\vlc\"" erwartet!" & @CRLF & @CRLF & "Zum Erstellen einmal die Einstellungen im VLC sichern!")
				endif
				if $vlcerr = 0 then
					$vlci = 1
					$vlcselect = WinList("VLC media player")
					$vcount = ""
					$vactiv = 0
					If $vlcselect[0][0] > 0 Then
						For $vlci = 1 to $vlcselect[0][0]
							If $vlcselect[$vlci][0] <> "" AND IsVisible($vlcselect[$vlci][1]) Then 
								$vactiv = $vactiv + 1
								$vcount =  "VLC media player - " & $vactiv & "|" & $vcount
								WinSetTitle ($vlcselect[$vlci][1], "", "VLC media player - " & $vactiv)
							endif
						Next
					EndIf
					if $vactiv = 0 then
						GUICtrlSetState ( 6, $GUI_ENABLE)
	                else
						GUICtrlDelete ( 6 )
					    $vlcs = GUICtrlCreateCombo("Auswahl (opt.)", 30, 40, 130, 20, $CBS_DROPDOWNLIST)
	                    GUICtrlSetData(6, $vcount, "Auswahl (opt.)")
					endif
					GUICtrlSetState ( 7, $GUI_ENABLE)
				Else
					GUICtrlDelete ( 6 )
					$vlcs = GUICtrlCreateCombo("VLC media player", 30, 40, 130, 20, $CBS_DROPDOWNLIST)
					GUICtrlSetState ( 6, $GUI_DISABLE)
					GUICtrlSetData(7, "Hotkey (opt.)")
				    GUICtrlSetState ( 7, $GUI_DISABLE)
					GUICtrlSetState ( $vlc1, $GUI_UNCHECKED)
				endif
			Else
				GUICtrlDelete ( 6 )
				$vlcs = GUICtrlCreateCombo("VLC media player", 30, 40, 130, 20, $CBS_DROPDOWNLIST)
				GUICtrlSetState ( 6, $GUI_DISABLE)
				GUICtrlSetData(7, "Hotkey (opt.)")
				GUICtrlSetState ( 7, $GUI_DISABLE)
				$datei2 = @TempDir & "\09876.jpg"
	            $typ = ".jpg"
	            $vlcerr = 1
			EndIf
		#cs
		Case $lss1
			if GUICtrlRead ( $lss1 ) = 1 Then
				GUICtrlSetState ( 9, $GUI_ENABLE)
			Else
				GUICtrlSetData(9, "Hotkey (opt.)")
				GUICtrlSetState ( 9, $GUI_DISABLE)
			EndIf
		#ce
		case $dvb2
			if GUICtrlRead ( $dvb2 ) = GUICtrlRead ( $vlc2 ) or GUICtrlRead ( $dvb2 ) = GUICtrlRead ( $lss2 ) and GUICtrlRead ( $dvb2 ) <> "Hotkey (opt.)" then
				GUICtrlSetData(4, "Hotkey (opt.)")
				MsgBox(16, "Fehler", "Hotkey Mehrfachbelegung nicht zulässig!")
			endif
		case $vlc2
			if GUICtrlRead ( $vlc2 ) = GUICtrlRead ( $dvb2 ) or GUICtrlRead ( $vlc2 ) = GUICtrlRead ( $lss2 ) and GUICtrlRead ( $vlc2 ) <> "Hotkey (opt.)" then
				GUICtrlSetData(7, "Hotkey (opt.)")
				MsgBox(16, "Fehler", "Hotkey Mehrfachbelegung nicht zulässig!")
			endif
		case $lss2
			if GUICtrlRead ( $lss2 ) = GUICtrlRead ( $dvb2 ) or GUICtrlRead ( $lss2 ) = GUICtrlRead ( $vlc2 ) and GUICtrlRead ( $lss2 ) <> "Hotkey (opt.)" then
				GUICtrlSetData(9, "Hotkey (opt.)")
				MsgBox(16, "Fehler", "Hotkey Mehrfachbelegung nicht zulässig!")
			endif
	EndSwitch
Until $child = 0
$dvb1 = GUICtrlRead ( $dvb1 ); 1 = dvb viewer ja
$dvb2 =  GUICtrlRead ($dvb2); dvb hotkey
$vlc1 = GUICtrlRead ( $vlc1 ); 1 = vlc player ja
if $vlc1 <> 1 then 
	$vlcerr = 1
	$datei2 = @TempDir & "\09876.jpg"
	$typ = StringRight ( $datei2, 4 )
endif

_predel($datei2)
$datei3 = @TempDir & "\" & $precfg0 & "\ptmp.jpg"
_predel($datei3)
$datei3 = @TempDir & "\" & $precfg0 & "\ptmp.bmp"
_predel($datei3)
$datei3 = @TempDir & "\" & $precfg0 & "\ptmp.tif"
_predel($datei3)
$datei3 = @TempDir & "\" & $precfg0 & "\ptmp.png"
_predel($datei3)
$datei3 = @TempDir & "\" & $precfg0 & "\ptmp.gif"
_predel($datei3)
$datei3 = @TempDir & "\" & $precfg0 & "\09876org.jpg"
_predel($datei3)
$vlcs = GUICtrlRead ( $vlcs ); vlc fenstertitel
$vlc2 =  GUICtrlRead ($vlc2); vlc hotkey
$lss1 = GUICtrlRead ( $lss1 ); 1 = stream ja
$lss2 =  GUICtrlRead ($lss2); stream hotkey
GUIDelete($guipre)

_IEErrorHandlerRegister ()
_IELoadWaitTimeout (1000)
$oIE = _IECreateEmbedded ()
Opt ( "TrayIconHide", 1 )
Opt("GuiOnEventMode", 1)
Global $irfan, $wmark, $filter, $egg2, $egg3, $egg4, $gui2, $orglink, $weck, $charslab, $htmlog, $htmclip, $4log
Global $updat, $snip, $shack, $size, $precurl, $newcurl, $buch, $vlcs1, $vlcs2, $tmptit, $bra1, $bra2, $cfgstatus, $siz1, $siz2
Global $datei2, $skb, $file, $chars, $result, $res2, $show, $list, $ontop, $pretv, $typ4, $xo, $yo, $4c2, $php, $iy, $wmt
Global $checklog, $cl2, $d1, $d2, $d3, $wecker, $weckstunde, $weckminute, $s2, $pretv1, $cov, $x, $y, $datei4pre, $datei4cnt, $4c1

DirCreate(@TempDir & "\" & $precfg0)
if $dvb2 <> "Hotkey (opt.)" then HotKeySet("{" & $dvb2 & "}", "_dvbspontan")
if $vlc2 <> "Hotkey (opt.)" then HotKeySet("{" & $vlc2 & "}", "_vlcspontan")
if $lss2 <> "Hotkey (opt.)" then HotKeySet("{" & $lss2 & "}", "_lssspontan")
if $lss1 = 1 then
	$maingui = GuiCreate("DVB Shotter ..5.45", 516, 447)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
	$oIE2 = _IECreateEmbedded ()
	$streamint = 1
Else
	$maingui = GuiCreate("DVB Shotter ..5.45", 410, 155)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
	$streamint = 0
endif


   
if FileExists($precfg) then
	$size = FileReadLine ( $precfg, 1)
	$opt2 = FileReadLine ( $precfg, 2)
	$top = FileReadLine ( $precfg, 3)
	$log = FileReadLine ( $precfg, 4)
	$opt3 = FileReadLine ( $precfg, 5)
	$opt4 = FileReadLine ( $precfg, 6)
	$opt5 = FileReadLine ( $precfg, 8)
	$col = FileReadLine ( $precfg, 7)
	$br1 = FileReadLine ( $precfg, 9)
	$br2 = FileReadLine ( $precfg, 10)
	$thread = FileReadLine ( $precfg, 11)
	$log2 = FileReadLine ( $precfg, 12)
	$ttit = FileReadLine ( $precfg, 13)
	$buch0 = FileReadLine ( $precfg, 14)
	$plus = FileReadLine ( $precfg, 15)
	$pretv = FileReadLine ( $precfg, 17)
else
	$size = "Bildgröße: keine Änderung"
	$opt2 = "Zwischenablage: nur die URL"
	$top = 0
	$log = 0
	$log2 = 0
    $opt3 = "Upload-Server: abload.de"
	$opt4 = 1
    $col = 0
    $opt5 = 0
    $br1 = 0
    $br2 = 0
    $thread = ""
    $ttit = ""
	$buch0 = "Bilderbuch: AUS"
	$plus = ""
	$pretv = 0
endif
;_curl($datei2)

$listcount = 0
$streamok1 = "ok"
$streamok2 = 2
$time2 = ""
$weck = ""
$timestamp = ""
;_buch()
$listlabel = 0
$waiting = "init"

$tab=GUICtrlCreateTab (1, 1, 250, 155)

$tab0=GUICtrlCreateTabitem ("Start")
$dvb = GuiCtrlCreateButton("DVB", 4, 26, 80, 30, $GUI_SS_DEFAULT_BUTTON)
if $dvb1 <> 1 then GUICtrlSetData($dvb, "")
if $dvb2 <> "Hotkey (opt.)" then GUICtrlSetData($dvb, "DVB  " & $dvb2)
$dvb2 = GUICtrlRead ( $dvb )
;if $dvb1 = 1 then GUICtrlSetOnEvent(-1, "_dvb")
$vlc = GuiCtrlCreateButton("VLC", 165, 26, 80, 30, $GUI_SS_DEFAULT_BUTTON)
if $vlc1 <> 1 then GUICtrlSetData($vlc, "")
if $vlc2 <> "Hotkey (opt.)" then GUICtrlSetData($vlc, "VLC  " & $vlc2)
$vlc2 = GUICtrlRead ( $vlc )
;if $vlc1 = 1 then GUICtrlSetOnEvent(-1, "_vlc")
GuiCtrlCreateButton($listcount, 227, 55, 20, 20, $SS_CENTER )
GuiCtrlSetBkColor(-1, 0xED1C24)
;GUICtrlSetOnEvent(-1, "_list1")
GuiCtrlCreateButton("", 227, 100, 20, 20)
GuiCtrlSetBkColor(-1, 0xED1C24)
;GUICtrlSetOnEvent(-1, "_fremd")
GUICtrlCreateInput ( "", 22, 75, 205, 20, $ES_READONLY+$ES_AUTOHSCROLL)
GuiCtrlCreateLabel("Bereit...", 22, 100, 148, 15, $SS_CENTER)
;GUICtrlSetOnEvent(-1, "_list2")
$snip = GuiCtrlCreateButton("Desktop", 4, 115, 80, 30) ;11
;GUICtrlSetOnEvent(-1, "_snip")
$shack = GuiCtrlCreateButton("Datei", 90, 115, 80, 30) ;12
;GUICtrlSetOnEvent(-1, "_shack")
GUICtrlCreateCombo ("org", 175, 97, 42, 14,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1,"40|80|160|240|320|480|640|800|K24", "org") 
GUICtrlSetOnEvent(-1, "_irfan")
GUICtrlCreateCheckbox (" ", 230, 79, 15, 15) ;14
$lss = GuiCtrlCreateButton("Stream", 90, 26, 70, 30, $GUI_SS_DEFAULT_BUTTON) ;15
if $lss1 <> 1 then GUICtrlSetData($lss, "")
if $lss2 <> "Hotkey (opt.)" then GUICtrlSetData($lss, "Stream  " & $lss2)
$lss2 = GUICtrlRead ( $lss )
;if $lss1 = 1 then GUICtrlSetOnEvent(-1, "_lss")
$original = GuiCtrlCreateButton("+ Original: nein", 122, 55, 80, 20);14
;GUICtrlSetOnEvent(-1, "_org1")
if $plus = "+ Original: ja" then GUICtrlSetData ($original, $plus)
$setup = GuiCtrlCreateButton("Setup", 22, 55, 50, 20);15
GUICtrlSetOnEvent(-1, "_setup")
GUICtrlCreateCheckbox ("Datum", 175, 120, 48, 14) 
GUICtrlSetBkColor ( -1, 0xffffff )
GUICtrlCreateCheckbox ("Logo", 175, 138, 42, 14) 
GUICtrlSetBkColor ( -1, 0xffffff )

$tab1=GUICtrlCreateTabitem ("Liste")
GuiCtrlCreateEdit("", 3, 25, 238, 105)
;GuiCtrlCreateButton("copy", 4, 132, 66, 20)
;GUICtrlSetOnEvent(-1, "_list1")
GuiCtrlCreateButton("reset", 75, 132, 66, 20)
;GUICtrlSetOnEvent(-1, "_list2")

$tab2=GUICtrlCreateTabitem ("Über")
GUICtrlCreatePic ( @TempDir & "\a.jpg", 8, 50, 112, 74)
GUICtrlSetOnEvent(-1, "_egg")
GuiCtrlCreateLabel(@CRLF & "DVB-Shotter 5.45" & @CRLF & "(22092009.1230)" & @CRLF & @CRLF & "© 2009 andygo", 138, 50, 100, 74, $SS_CENTER)
$GUIActiveX = GUICtrlCreateObj($oIE, 10, 120, 1, 1)
GUICtrlCreateTabitem ("")
   
if $streamint = 1 then
	$GUIActiveX2 = GUICtrlCreateObj($oIE2, 1, 156, 532, 308)
	_IENavigate ($oIE2, @TempDir & "\streamlite.htm")
Else
	GUICtrlCreateLabel ("", 120, 45, 1, 1)
EndIf
GUICtrlCreatePic ( @TempDir & "\a.jpg", 255, 5, 150, 112)
GuiCtrlCreateLabel ( "(" & $listlabel & ")  ", 255, 120, 150, 25)
;GUICtrlSetOnEvent(-1, "_listlabel")
GUICtrlSetColor(-1,0x404040)
_irfan()
_gui2()
$egg = GUICreate("DVB-Shotter 5.45 Easteregg", 168, 252, -1, -1, $WS_BORDER)
$dialog = @WindowsDir & "\"
$opt4 = 0

_cfgfile("zugriff")

$preurl = ""
$posturl = ""
if $opt2 = "[img]URL[/img]" then
	$preurl = "[img]"
	$posturl = "[/img]"
elseif $opt2 = "[img]URL[/img] & neue Zeile" then
    $preurl = "[img]"
    $posturl = "[/img]" & @CRLF
endif
if $opt3 = "OFFLINE - MODUS" then 
	GUICtrlSetData ( 9, "OFFLINE - MODUS")
	GUICtrlSetState ( 14, $GUI_UNCHECKED )
	GUICtrlSetState ( 14, $GUI_DISABLE)
endif
$name = 0
_sc()
$tmptit = "Upload"

GuiSetState(@sw_show, $maingui)
GuiCtrlCreateLabel ( "", 230, 1, 20, 20)
GUICtrlSetOnEvent(-1, "_www")
GUICtrlSetColor(-1,0x404040)
GUICtrlSetFont (-1, 12)
GuiCtrlCreateLabel ( "", 197, 1, 21, 20)
GUICtrlSetOnEvent(-1, "_showlog")
GUICtrlSetColor(-1,0x404040)
GUICtrlSetFont (-1, 12)
GuiCtrlCreateLabel ( "", 132, 5, 31, 15); 61 Datum
GUICtrlSetColor(-1,0x404040)
GuiCtrlCreateLabel ( "", 165, 5, 24, 15); 62 Logo
GUICtrlSetColor(-1,0x404040)
if $name = 0 then
	$name = 1
	if $buch0 <> "Bilderbuch: AUS" then 
		WinSetTitle ( "..5.45", "+ Original:",  "DVB Shotter 5.45  -  " & $buch0)
	elseif $size = "Bildgröße: keine Änderung" then
		WinSetTitle ( "..5.45", "+ Original:",  "DVB Shotter 5.45  -  " & $tmptit & ": Originalgröße")
	Else
		WinSetTitle ( "..5.45", "+ Original:",  "DVB Shotter 5.45  -  " & $tmptit & ": " & $size)
	endif
EndIf
if $br2 = 1 then
	GUICtrlSetState ( 14, $GUI_CHECKED )
	$br2 = 4
endif
if guictrlread(38) = 1 then GUICtrlSetData (61, "Datum")
if guictrlread(37) = 1 then GUICtrlSetData (62, "Logo")
if StringLen ($log) > 2 then GUICtrlSetData (60, "log")
$datei4cnt = 0
$4log = 0
While 1
if $waiting = "init" Then
	$waiting = 0
    if $top = 1 then WinSetOnTop ( "DVB Shotter 5.45", "+ Original:", 1 )
endif
_watch()
sleep(50)

WEnd

func _sc()
	if GUICtrlRead (30) = "Bildgröße: keine Änderung" Then
		GUICtrlSetData($original, "+ Original: nein")
		$br1 = 4
	    GUICtrlSetState ( 16, $GUI_DISABLE)
	Else
		GUICtrlSetState ( 16, $GUI_ENABLE)
    EndIf
endfunc

func _cfgfile(const $cfgstatus)
	FileInstall("dvb-shotter.cfg", $precfg, 1)
    FileOpen($precfg, 2) 
    FileWriteLine($precfg, $size)
	FileWriteLine($precfg, $opt2)
    FileWriteLine($precfg, $top)
    FileWriteLine($precfg, $log)
    FileWriteLine($precfg, $opt3)
    FileWriteLine($precfg, $opt4)
    FileWriteLine($precfg, $col)
    FileWriteLine($precfg, $opt5)
    FileWriteLine($precfg, $br1)
    FileWriteLine($precfg, $br2)
    FileWriteLine($precfg, $thread)
    FileWriteLine($precfg, $log2)
    FileWriteLine($precfg, $ttit)
    FileWriteLine($precfg, $buch0)
	FileWriteLine($precfg, GUICtrlRead($original))
	FileWriteLine($precfg, $cfgstatus)
	FileWriteLine($precfg, $pretv)
	FileClose($precfg)
EndFunc

Func _Quit()
	_cfgfile("ende")
	FileDelete (@TempDir & "\" & $precfg0 & "\watermark.license")
	Exit
EndFunc




Func _ontop()
   Switch $top
      Case 0
         WinSetOnTop ( "DVB Shotter 5.45", "+ Original:", 1 )
         $top = 1
      Case 1
         WinSetOnTop ( "DVB Shotter 5.45", "+ Original:", 0 )
         $top = 0
    EndSwitch
EndFunc



func _watch()
	
endfunc




Func _curl(ByRef $curl)
	
EndFunc

Func _savesetup()
	$streamok1 = "ok"
    $streamok2 = 2
	FileOpen($precfg, 2) 
    FileWriteLine($precfg, GUICtrlRead (30))
    FileWriteLine($precfg, GUICtrlRead (31))
    FileWriteLine($precfg, $top)
    FileWriteLine($precfg, $log)
    FileWriteLine($precfg, GUICtrlRead (34))
    FileWriteLine($precfg, GUICtrlRead (35))
    FileWriteLine($precfg, GUICtrlRead (37))
    FileWriteLine($precfg, GUICtrlRead (38))
	FileWriteLine($precfg, $br1)
	FileWriteLine($precfg, $br2)
	FileWriteLine($precfg, GUICtrlRead (40))
	FileWriteLine($precfg, $log2)
	FileWriteLine($precfg, GUICtrlRead (44))
	FileWriteLine($precfg, GUICtrlRead (36));buch
	FileWriteLine($precfg, GUICtrlRead($original))
	FileWriteLine($precfg, "zugriff");line 16
	FileWriteLine($precfg, $pretv)
    FileClose($precfg)
	$size = FileReadLine ( $precfg, 1)
    _irfan()
    $opt2 = FileReadLine ( $precfg, 2)
    $top = FileReadLine ( $precfg, 3)
    if $top = "#" then $top = 0
    $log = FileReadLine ( $precfg, 4)
    if StringLen ($log) <= 2 then $log = 0
	$opt3 = FileReadLine ( $precfg, 5)
    ;_curl($datei2)
	if $opt3 = "OFFLINE - MODUS" then
		GUICtrlSetState ( 14, $GUI_UNCHECKED )
	    GUICtrlSetState ( 14, $GUI_DISABLE)
	Else
		GUICtrlSetState ( 14, $GUI_ENABLE)
	endif
    $opt4 = FileReadLine ( $precfg, 6)
	if $opt4 <= 0 then $opt4 = 1
    $opt5 = FileReadLine ( $precfg, 8)
    $col = FileReadLine ( $precfg, 7)
    $br1 = FileReadLine ( $precfg, 9)
    $br2 = FileReadLine ( $precfg, 10)
	$thread = FileReadLine ( $precfg, 11)
	$ttit = FileReadLine ( $precfg, 13)
    GUICtrlSetData (61, "")
	GUICtrlSetData (62, "")
	if guictrlread(38) = 1 then GUICtrlSetData (61, "Datum")
    if guictrlread(37) = 1 then GUICtrlSetData (62, "Logo")
	FileOpen(@TempDir & "\" & $precfg0 & "\auto.htm", 2) 
    FileWriteLine(@TempDir & "\" & $precfg0 & "\auto.htm", "<form action=""                                                  ")
    FileWriteLine(@TempDir & "\" & $precfg0 & "\auto.htm", $thread)
    FileWriteLine(@TempDir & "\" & $precfg0 & "\auto.htm", """ method=""post"" name=""auto""><input type=""text"" name=""title"" id=""fe-title"" /><textarea name=""text"" id=""fe-text"" rows=""10"" cols=""50""></textarea><input type=""submit"" name=""confirm"" value=""Senden"" /></form>")
    FileClose(@TempDir & "\" & $precfg0 & "\auto.htm")
    $preurl = ""
    $posturl = ""
    if $opt2 = "[img]URL[/img]" then
		$preurl = "[img]"
        $posturl = "[/img]"
    elseif $opt2 = "[img]URL[/img] & neue Zeile" then
        $preurl = "[img]"
        $posturl = "[/img]" & @CRLF
    endif
    if GUICtrlRead ( 41 ) = "1" then
		GUICtrlSetFont (5, 12, 800)
        GuiCtrlSetColor(5, 0xED1C24)
        GUICtrlSetFont (6, 12, 800)
        GuiCtrlSetColor(6, 0xED1C24)
	    GUICtrlSetFont (15, 12, 800)
        GuiCtrlSetColor(15, 0xED1C24)
    Else
       ; _aboff()
   endif
   $prebuch = $buch
   $buch0 = guictrlread (36)
   ;_buch()
   if $buch > 0 then 
	   WinSetTitle ( "5.45is", "+ Original:",  "DVB Shotter 5.45  -  " & guictrlread (36))
   elseif $size = "Bildgröße: keine Änderung" then
	   if $tmptit = "PreFix" Then
			WinSetTitle ( "5.45is", "+ Original:",  "DVB Shotter 5.45  -  " & $tmptit & ": auto*576")
		Else
			WinSetTitle ( "5.45is", "+ Original:",  "DVB Shotter 5.45  -  " & $tmptit & ": Originalgröße")
		endif
   Else
	   WinSetTitle ( "5.45is", "+ Original:",  "DVB Shotter 5.45  -  " & $tmptit & ": " & $size)
   endif
   if $prebuch <> $buch Then
	   GUICtrlSetData(21, "")
       $opt4 = 0
       ClipPut ("")
       $listcount = 0
	   GUICtrlSetData ( 7, $listcount)
   endif
   _sc()
   if guictrlread (52) = 1 and guictrlread (30) = "Bildgröße: keine Änderung" then msgbox (64, "Hinweis", "Die Option PreFix ohne Änderung der Bildgröße erzeugt eine Ausgabe von auto*576.")
EndFunc





 

Func _wake()
	
EndFunc



func _vlcspontan()

EndFunc

func _dvbspontan()

EndFunc

func _lssspontan()

EndFunc
  
func _fremd()
	
Endfunc

Func _org1()
	
EndFunc

func _listlabel()
	$listlabel = 0
	GUICtrlSetData ( 29, "(" & $listlabel & ")  " & $time2 & @CRLF & $charslab) 
endfunc



func _dis()
	$waiting = 1
	FileDelete ( @TempDir & "\" & $precfg0 & "\curl.txt" )
	FileDelete (@TempDir & "\" & $precfg0 & "\test.txt")
	$charslab = ""
	$x = ""
	$y = ""
    FileDelete ( $datei2 )
    GUICtrlSetState ( 3, $GUI_DISABLE)
    GUICtrlSetState ( 7, $GUI_DISABLE)
    GUICtrlSetState ( 8, $GUI_DISABLE)
    GUICtrlSetState ( 13, $GUI_DISABLE)
    GUICtrlSetState ( 14, $GUI_DISABLE)
    GUICtrlSetState ( 16, $GUI_DISABLE)
	GUICtrlSetState ( 17, $GUI_DISABLE)
	GUICtrlSetState ( 5, $GUI_DISABLE)
	GUICtrlSetState ( 6, $GUI_DISABLE)
    GUICtrlSetState ( 11, $GUI_DISABLE)
    GUICtrlSetState ( 12, $GUI_DISABLE)
    GUICtrlSetState ( 15, $GUI_DISABLE)
	GUICtrlSetData ( 59, "")
    GUICtrlSetData ( 9, "")
    GuiCtrlSetBkColor(7, 0xED1C24)
    GuiCtrlSetBkColor(8, 0xED1C24)
    ClipPut ( "" )
    GUICtrlSetColor(10,0xff0000)
    GUICtrlSetData ( 10, "preparing upload...")
	$orglink = ""
EndFunc
	
func _en()
	GUICtrlSetState ( 3, $GUI_ENABLE)
    GUICtrlSetState ( 7, $GUI_ENABLE)
    GUICtrlSetState ( 8, $GUI_ENABLE)
    GUICtrlSetState ( 14, $GUI_ENABLE)
    GUICtrlSetState ( 17, $GUI_ENABLE)
	GUICtrlSetState ( 6, $GUI_ENABLE)
    GUICtrlSetState ( 5, $GUI_ENABLE)
	GUICtrlSetState ( 11, $GUI_ENABLE)
    GUICtrlSetState ( 12, $GUI_ENABLE)
	GUICtrlSetState ( 13, $GUI_ENABLE)
	GUICtrlSetState ( 15, $GUI_ENABLE)
	$4log = 0
	_sc()
EndFunc

func _setup()
	if $waiting = 0 Then
		$br1 = guictrlread (13)
		$br2 = guictrlread (14)
		$waiting = 1
		WinSetTitle ( "[ACTIVE]", "+ Original:",  "DVB Shotter 5.45is")
		GuiCtrlSetBkColor(7, 0xED1C24)
        GuiCtrlSetBkColor(8, 0xED1C24)
		GUISetState ( @SW_DISABLE, $maingui )
        Opt("GuiOnEventMode", 0)
		;_fixchk()
        GuiSetState(@sw_show, $gui2)
		;_cov()
		;_delay()
        $child = 1
		if $vlcerr = 0 then	GUICtrlSetState ( $vlcs1, $GUI_ENABLE )
		Do
			sleep(10)
            $mMsg = GUIGetMsg()
		    Switch $mMsg
				case 37 to 38
					;_fixchk()
				case $ontop
					_ontop()
				case $cov
					;_cov()
				case $checklog
					;_checklog()
				case $cl2
					;_checklog2()
				case 39, 42, 45 to 48
					;_delay()
				case $vlcs1
					$vlci = 1
					$vlcselect = WinList("VLC media player")
					$vcount = ""
					$vactiv = 0
					If $vlcselect[0][0] > 0 Then
						For $vlci = 1 to $vlcselect[0][0]
							If $vlcselect[$vlci][0] <> "" AND IsVisible($vlcselect[$vlci][1]) Then 
								$vactiv = $vactiv + 1
								$vcount =  "VLC media player - " & $vactiv & "|" & $vcount
								WinSetTitle ($vlcselect[$vlci][1], "", "VLC media player - " & $vactiv)
							endif
						Next
					EndIf
					if $vactiv = 0 then
						GUICtrlSetState ( $vlcs2, $GUI_DISABLE)
					else
						GUICtrlDelete ( $vlcs2 )
						$vlcs2 = GUICtrlCreateCombo("Auswahl (opt.)", 100, 280, 130, 20, $CBS_DROPDOWNLIST)
						GUICtrlSetData($vlcs2, $vcount, "Auswahl (opt.)")
					endif
			    case $s2
					if StringLen ( GUICtrlRead(44) ) > 50 then
						MsgBox(16,"Fehler", "Titel max. 50 Zeichen!")
					Else
						$vlcs = GUICtrlRead ( $vlcs2 ); vlc fenstertitel
					    $child = 0
					endif
			 EndSwitch
		 Until $child = 0
		 GUICtrlSetState ( $vlcs1, $GUI_DISABLE )
		 GUICtrlSetState ( $vlcs2, $GUI_DISABLE)
		 if GUICtrlRead(9) = "OFFLINE - MODUS" then GUICtrlSetData ( 9, "")
		 if GUICtrlRead(34) = "OFFLINE - MODUS" then GUICtrlSetData ( 9, "OFFLINE - MODUS")
		 _savesetup()
		 GuiSetState(@sw_hide, $gui2)
		 GUISetState ( @SW_ENABLE, $maingui )
		 WinActivate ( "DVB Shotter 5.45", "+ Original:" )
         Opt("GuiOnEventMode", 1)
	     $waiting = 0
	 endif
endfunc
 
func _gui2()
	    $gui2 = GUICreate("DVB-Shotter 5.45 Setup", 250, 368, -1, -1, $WS_BORDER)
        GUICtrlCreateCombo ("Bildgröße: keine Änderung", 76, 5, 158, 10, $CBS_DROPDOWNLIST)
        GUICtrlSetData(-1,"40 x auto|80 x auto|160 x auto|240 x auto|320 x auto|480 x auto|640 x auto|800 x auto|1024 x auto", $size) 
        GUICtrlCreateCombo ("Zwischenablage: nur die URL", 36, 85, 178, 10, $CBS_DROPDOWNLIST)
        GUICtrlSetData(-1,"[img]URL[/img]|[img]URL[/img] & neue Zeile|HTML", $opt2) 
        $ontop = GUICtrlCreateCheckbox ( "Shotter onTop", 5, 316, 83, 20)
		$checklog = GUICtrlCreateCheckbox ( "TV-Shots speichern && Logdatei", 36, 108)
        $cl2 = GUICtrlCreateCombo ("OFFLINE - MODUS", 31, 58, 188, 10, $CBS_DROPDOWNLIST)
        GUICtrlSetData(-1,"Upload-Server: abload.de|Upload-Server: bayimg.com|Upload-Server: imagebanana.com|Upload-Server: imageshack.us|Upload-Server: imagespread.com|Upload-Server: img-teufel.de|Upload-Server: ipics.biz|Upload-Server: pic.leech.it|Upload-Server: pic-upload.de", $opt3)
		GUICtrlCreateCombo ("1", 174, 137, 40, 10, $CBS_DROPDOWNLIST)
        GUICtrlSetData(-1,"2|3|6|12", $opt4)
		GUICtrlCreateCombo ("Bilderbuch: AUS", 36, 137, 110, 20, $CBS_DROPDOWNLIST)
        GUICtrlSetData(-1,"Bilderbuch: 4|Bilderbuch: 6|Bilderbuch: 8|Bilderbuch: 10|Bilderbuch: 12|Bilderbuch: 60|Bilderbuch: 120", $buch0)
        $bra1 = GUICtrlCreateCheckbox ( "Copyright-Logo", 125, 30, 88, 20)
		$bra2 = GUICtrlCreateCheckbox ( "Datum && Uhrzeit", 5, 30, 92, 20)
        $d1 = GUICtrlCreateCombo("00", 5, 230, 40, 20, $CBS_DROPDOWNLIST) ; 37
        GUICtrlSetData(-1, "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23", "01") 
        GUICtrlCreateInput ( $thread, 5, 162, 70, 20) ;38
        $cov = GUICtrlCreateCheckbox ( "AutoLoop", 5, 205, 80, 20) ;39
		$d2 = GUICtrlCreateSlider(100, 205, 140, 20) ;40
        GUICtrlSetLimit(-1, 600, 1) 	; change min/max value
        GUICtrlSetData(-1, 140)
        GUICtrlCreateLabel ("alle ", 5, 260, 210, 15) ;41
        GUICtrlCreateInput ( $ttit, 115, 162, 125, 20) ;42
        $d3 = GUICtrlCreateCombo("00", 60, 230, 40, 20, $CBS_DROPDOWNLIST) ; 43
        GUICtrlSetData(-1, "05|10|15|20|25|30|35|40|45|50|55", "15")
		$wecker = GUICtrlCreateCheckbox ( "", 120, 230, 20, 20) ; 44
		$weckstunde = GUICtrlCreateCombo("00", 150, 230, 40, 20, $CBS_DROPDOWNLIST) ; 45
        GUICtrlSetData(-1, "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23", "09") 
		$weckminute = GUICtrlCreateCombo("00", 200, 230, 40, 20, $CBS_DROPDOWNLIST) ; 46
        GUICtrlSetData(-1, "05|10|15|20|25|30|35|40|45|50|55", "05")
        $s2 = GuiCtrlCreateButton("Einstellungen speichern", 110, 316, 130, 20)
		$vlcs1 = GuiCtrlCreateButton ("VLC Fenster", 15, 286, 75, 20)
		$vlcs2 = GUICtrlCreateCombo($vlcs, 100, 285, 130, 20, $CBS_DROPDOWNLIST);30, 40, 130, 20
		$pretv1 = GUICtrlCreateLabel ( "", 3, 200, 238, 1, $SS_SUNKEN);GUICtrlCreateCheckbox ( "PreFix", 5, 5, 50, 20)
		GUICtrlCreateLabel ( "", 3, 51, 238, 1, $SS_SUNKEN)
		GUICtrlCreateLabel ( "", 3, 131, 238, 1, $SS_SUNKEN)
		GUICtrlCreateLabel ( "Sevenload ID               PostingTitel", 7, 183, 238, 14)
		GUICtrlCreateLabel ( "", 3, 200, 238, 1, $SS_SUNKEN)
		GUICtrlCreateLabel ( "", 3, 279, 238, 1, $SS_SUNKEN)
		GUICtrlCreateLabel ( "", 3, 311, 238, 1, $SS_SUNKEN)
		_cov()
		GUICtrlSetState ( $vlcs1, $GUI_DISABLE )
		GUICtrlSetState ( $vlcs2, $GUI_DISABLE )
		if $top = 1 then GUICtrlSetState ( 32, $GUI_CHECKED )
		if $pretv = 1 then GUICtrlSetState ( 52, $GUI_CHECKED )
		if StringLen ($log) > 2 then GUICtrlSetState ( 33, $GUI_CHECKED )
		if $opt5 = 1 then
			GUICtrlSetState ( 38, $GUI_CHECKED );Datum
		    $opt5 = 4
		endif
	    if $col = 1 then
		    GUICtrlSetState ( 37, $GUI_CHECKED );Logo
            $col = 4
	    endif
endfunc
	
func _egg()
	if $waiting = 0 Then
		$waiting = 1
		GUISetState ( @SW_DISABLE, $maingui )
        GuiSetState(@sw_show, $egg)
		Opt("GuiOnEventMode", 0)
		WinSetOnTop ( "Easteregg", "", 1 )
		$ip = 253
	    Do
			GUICtrlDelete ($egg2)
	        $egg2 = GUICtrlCreatePic ( @TempDir & "\a.jpg", 26, $ip, 112, 74)
			GUICtrlDelete ($egg3)
 	        $egg3 = GUICtrlCreatePic ( @TempDir & "\i82.jpg", 26, $ip + 84, 112, 74)
			GUICtrlDelete ($egg4)
	        $egg4 = GUICtrlCreatePic ( @TempDir & "\s07.jpg", 26, $ip + 168, 112, 74)
			sleep(20)
 	        $ip = $ip - 1
			$mMsg = GUIGetMsg()
		    Switch $mMsg
				case 63 to 65
			        $ip = -244
			EndSwitch
		Until $ip <= -243
		GuiSetState(@sw_hide, $egg)
		GUISetState ( @SW_ENABLE, $maingui )
		Opt("GuiOnEventMode", 1)
		WinActivate ( "DVB Shotter 5.45", "© 2009 andygo" )
        $waiting = 0
	 endif
 endfunc
 
func _irfan()
	$irfan = ""
	$iy = 0
    if $size = "40 x auto" then $irfan = " /resize=(40,0) /aspectratio /resample"
    if $size = "80 x auto" then	$irfan = " /resize=(80,0) /aspectratio /resample"
    if $size = "160 x auto" then $irfan = " /resize=(160,0) /aspectratio /resample"
    if $size = "240 x auto" then $irfan = " /resize=(240,0) /aspectratio /resample"
    if $size = "320 x auto" then $irfan = " /resize=(320,0) /aspectratio /resample"
    if $size = "480 x auto" then $irfan = " /resize=(480,0) /aspectratio /resample"
    if $size = "640 x auto" then $irfan = " /resize=(640,0) /aspectratio /resample"
    if $size = "800 x auto" then $irfan = " /resize=(800,0) /aspectratio /resample"
    if $size = "1024 x auto" then $irfan = " /resize=(1024,0) /aspectratio /resample"
	if $irfan <> "" then $iy = 1
	$siz1 = 0
	$siz2 = ""
	if guictrlread (13) = "40" then $siz2 = " /resize=(40,0) /aspectratio /resample"
    if guictrlread (13) = "80" then	$siz2 = " /resize=(80,0) /aspectratio /resample"
    if guictrlread (13) = "160" then $siz2 = " /resize=(160,0) /aspectratio /resample"
    if guictrlread (13) = "240" then $siz2 = " /resize=(240,0) /aspectratio /resample"
    if guictrlread (13) = "320" then $siz2 = " /resize=(320,0) /aspectratio /resample"
    if guictrlread (13) = "480" then $siz2 = " /resize=(480,0) /aspectratio /resample"
    if guictrlread (13) = "640" then $siz2 = " /resize=(640,0) /aspectratio /resample"
    if guictrlread (13) = "800" then $siz2 = " /resize=(800,0) /aspectratio /resample"
    if guictrlread (13) = "K24" then $siz2 = " /resize=(1024,0) /aspectratio /resample"
	if $siz2 <> "" then $siz1 = 1
EndFunc

func _filter(ByRef $filter)

endfunc

Func _verr()
	$chars = FileRead(@AppDataDir & "\vlc\vlcrc")
    if StringInStr ( $chars, $datei2) = 0 then
		MsgBox(16,"Fehler", "VLC media player:" & @CRLF & @CRLF & "Angabe der Screenshot-Datei fehlerhaft!")
	elseif StringInStr ( $chars, "image-out-replace=1") = 0 and StringInStr ( $chars, "scene-replace=1") = 0 then
        MsgBox(16,"Fehler", "VLC media player:" & @CRLF & @CRLF & "Option ""immer in die selbe Datei schreiben"" prüfen!")
	elseif StringInStr ( $chars, "key-snapshot=s" & @CRLF) = 0 then
	    MsgBox(16,"Fehler", "VLC media player:" & @CRLF & @CRLF & "1.: Hotkey-Einstellung für Screenshot ""S"" Taste geändert?" & @CRLF & @CRLF & "2.: Video-Stream neu starten" & @CRLF & @CRLF & "3.: VLC Fensterauswahl prüfen")
	elseif StringInStr ( $chars, "snapshot-format=jpg") = 0 then
		MsgBox(16,"Fehler", "VLC media player:" & @CRLF & @CRLF & "Screenshot-Format JPG prüfen!")
	elseif StringInStr ( $chars, "key-stop=s" & @CRLF) > 0 then
		MsgBox(16,"Fehler", "VLC media player:" & @CRLF & @CRLF & "Hotkey ""S"" darf nicht doppelt belegt sein!")
	else
		MsgBox(16,"Fehler", "Screenshot konnte nicht gespeichert werden!" & @CRLF & @CRLF & "Firewall prüfen: i_view32.exe, curl.exe, watermark.exe")
    endif		
EndFunc

Func _buch()

EndFunc

Func _lableer()

EndFunc

Func _aboff()
	GUICtrlSetFont (5, 9, 400)
	GuiCtrlSetColor(5, 0x000000)
	GUICtrlSetFont (6, 9, 400)
	GuiCtrlSetColor(6, 0x000000)
	GUICtrlSetFont (15, 9, 400)
	GuiCtrlSetColor(15, 0x000000)
	GUICtrlSetStyle($vlc, $GUI_SS_DEFAULT_BUTTON)
	GUICtrlSetStyle($dvb, $GUI_SS_DEFAULT_BUTTON)
	GUICtrlSetStyle($lss, $GUI_SS_DEFAULT_BUTTON)
EndFunc
						
Func IsVisible($handle)
	If BitAnd( WinGetState($handle), 2 ) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func _www()
   if StringInStr ( guictrlread (9), "http://") then Run(@ComSpec & " /c " & "start " & guictrlread (9), "", @SW_HIDE)
EndFunc

Func _showlog()
	if FileExists ( $log & "screenshots.htm" ) = 1 then Run(@ComSpec & " /c " & "start " & $log & "screenshots.htm", "", @SW_HIDE)
	if guictrlread (33) = 1 and FileExists ( $log & "screenshots.htm" ) = 0 then Msgbox (64, "Logdatei", "Keine Einträge in der Logdatei vorhanden.")
EndFunc
	
Func _cov()
	if guictrlread (41) = 1 then
		GUICtrlSetState ( 39, $GUI_ENABLE)
		GUICtrlSetState ( 42, $GUI_ENABLE)
		GUICtrlSetState ( 43, $GUI_ENABLE)
		GUICtrlSetState ( 45, $GUI_ENABLE)
		GUICtrlSetState ( 46, $GUI_ENABLE)
		GUICtrlSetState ( 47, $GUI_ENABLE)
		GUICtrlSetState ( 48, $GUI_ENABLE)
	Else
		GUICtrlSetState ( 39, $GUI_DISABLE)
		GUICtrlSetState ( 42, $GUI_DISABLE)
		GUICtrlSetState ( 43, $GUI_DISABLE)
		GUICtrlSetState ( 45, $GUI_DISABLE)
		GUICtrlSetState ( 46, $GUI_DISABLE)
		GUICtrlSetState ( 47, $GUI_DISABLE)
		GUICtrlSetState ( 48, $GUI_DISABLE)
	EndIf
EndFunc

Func _htmlog()
	
EndFunc

func _predel(ByRef $predel)
	if FileExists ($predel) then
		FileSetAttrib($predel, "-R", 1)
		if FileDelete ( $predel ) = 0 then MsgBox(16, "Fehler", "Zugriffsfehler! Bitte manuell löschen:" & @CRLF & @CRLF & $predel)
	endif
EndFunc

func _fixchk()
	if guictrlread (37) = 4 and guictrlread (38) = 4 Then
		GUICtrlSetState ( 52, $GUI_UNCHECKED)
		GUICtrlSetState ( 52, $GUI_DISABLE)
		$pretv = 0
		$tmptit = "Upload"
	Else
		GUICtrlSetState ( 52, $GUI_ENABLE)
	EndIf
EndFunc

func _plusinfo()
	
EndFunc

func _htm()
	
endfunc

			



			