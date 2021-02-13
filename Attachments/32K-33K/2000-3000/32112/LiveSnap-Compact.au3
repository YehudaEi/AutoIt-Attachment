#RequireAdmin
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <Timers.au3>
#include <Process.au3>
#Include <Misc.au3>
#include <Constants.au3>
#Include <GuiButton.au3>
#Include <Clipboard.au3>
#Include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <file.au3>
Break(0)
Opt("TrayAutoPause",0)
Opt("WinTitleMatchMode", 2)
FileInstall("dvbs-de.lng", @TempDir & "\dvbs-de.lng", 1)
FileInstall("dvbs-en.lng", @TempDir & "\dvbs-en.lng", 1)
if StringInStr("0409 0809 0c09 1009 1409 1809 1c09 2009 2409 2809 2c09 3009 3409", @OSLang) then
    $language = "english"
	$langcfg = "en"
	Dim $interface
    _FileReadToArray(@TempDir & "\dvbs-"&StringLeft($language, 2)&".lng",$interface)
else
	$language = "deutsch"
	$langcfg = ""
	Dim $interface
    _FileReadToArray(@TempDir & "\dvbs-"&StringLeft($language, 2)&".lng",$interface)
endif
SplashTextOn("LiveSnap", @CRLF & $interface[1], 250, 80);initialisieren start
FileInstall("a2.jpg", @TempDir & "\a2.jpg", 1)
FileInstall("leer.jpg", @TempDir & "\leer.jpg", 1)
FileInstall("oben.jpg", @TempDir & "\oben.jpg", 1)
FileInstall("unten.jpg", @TempDir & "\unten.jpg", 1)
FileInstall("links.jpg", @TempDir & "\links.jpg", 1)
FileInstall("rechts.jpg", @TempDir & "\rechts.jpg", 1)
FileInstall("rota0.jpg", @TempDir & "\rota0.jpg", 1)
FileInstall("rotal.jpg", @TempDir & "\rotal.jpg", 1)
FileInstall("rotar.jpg", @TempDir & "\rotar.jpg", 1)
FileInstall("rota0.jpg", @TempDir & "\draw0.jpg", 1)
FileInstall("draw.jpg", @TempDir & "\draw.jpg", 1)
FileInstall("bold0.jpg", @TempDir & "\bold0.jpg", 1)
FileInstall("bold1.jpg", @TempDir & "\bold1.jpg", 1)
FileInstall("ital0.jpg", @TempDir & "\ital0.jpg", 1)
FileInstall("ital1.jpg", @TempDir & "\ital1.jpg", 1)
FileInstall("under0.jpg", @TempDir & "\under0.jpg", 1)
FileInstall("under1.jpg", @TempDir & "\under1.jpg", 1)
FileInstall("strike0.jpg", @TempDir & "\strike0.jpg", 1)
FileInstall("strike1.jpg", @TempDir & "\strike1.jpg", 1)
FileInstall("left1.jpg", @TempDir & "\left1.jpg", 1)
FileInstall("center1.jpg", @TempDir & "\center1.jpg", 1)
FileInstall("right1.jpg", @TempDir & "\right1.jpg", 1)
FileInstall("trans1.jpg", @TempDir & "\trans1.jpg", 1)
FileInstall("white1.jpg", @TempDir & "\white1.jpg", 1)
FileInstall("fonts.txt", @TempDir & "\fonts.txt", 1)
FileInstall("irfaneffekte.txt", @TempDir & "\irfaneffekte.txt", 1)
FileInstall("sprech.png", @TempDir & "\sprech.png", 1)
FileInstall("denk.png", @TempDir & "\denk.png", 1)
FileInstall("laut.png", @TempDir & "\laut.png", 1)
FileInstall("smilemap.jpg", @TempDir & "\smilemap.jpg", 1)
FileInstall("smile31.png", @TempDir & "\smile31.png", 1)
FileInstall("smile32.png", @TempDir & "\smile32.png", 1)
FileInstall("smile33.png", @TempDir & "\smile33.png", 1)
FileInstall("smile34.png", @TempDir & "\smile34.png", 1)
FileInstall("smile35.png", @TempDir & "\smile35.png", 1)
FileInstall("smile36.png", @TempDir & "\smile36.png", 1)
FileInstall("smile37.png", @TempDir & "\smile37.png", 1)
FileInstall("smile38.png", @TempDir & "\smile38.png", 1)
FileInstall("smile39.png", @TempDir & "\smile39.png", 1)
FileInstall("smile40.png", @TempDir & "\smile40.png", 1)
FileInstall("smile41.png", @TempDir & "\smile41.png", 1)
FileInstall("smile42.png", @TempDir & "\smile42.png", 1)
FileInstall("smile1.png", @TempDir & "\smile1.png", 1)
FileInstall("smile2.png", @TempDir & "\smile2.png", 1)
FileInstall("smile3.png", @TempDir & "\smile3.png", 1)
FileInstall("smile4.png", @TempDir & "\smile4.png", 1)
FileInstall("smile5.png", @TempDir & "\smile5.png", 1)
FileInstall("smile6.png", @TempDir & "\smile6.png", 1)
FileInstall("smile7.png", @TempDir & "\smile7.png", 1)
FileInstall("smile8.png", @TempDir & "\smile8.png", 1)
FileInstall("smile9.png", @TempDir & "\smile9.png", 1)
FileInstall("smile10.png", @TempDir & "\smile10.png", 1)
FileInstall("smile11.png", @TempDir & "\smile11.png", 1)
FileInstall("smile12.png", @TempDir & "\smile12.png", 1)
FileInstall("smile13.png", @TempDir & "\smile13.png", 1)
FileInstall("smile14.png", @TempDir & "\smile14.png", 1)
FileInstall("smile15.png", @TempDir & "\smile15.png", 1)
FileInstall("smile16.png", @TempDir & "\smile16.png", 1)
FileInstall("smile17.png", @TempDir & "\smile17.png", 1)
FileInstall("smile18.png", @TempDir & "\smile18.png", 1)
FileInstall("smile19.png", @TempDir & "\smile19.png", 1)
FileInstall("smile20.png", @TempDir & "\smile20.png", 1)
FileInstall("smile21.png", @TempDir & "\smile21.png", 1)
FileInstall("smile22.png", @TempDir & "\smile22.png", 1)
FileInstall("smile23.png", @TempDir & "\smile23.png", 1)
FileInstall("smile24.png", @TempDir & "\smile24.png", 1)
FileInstall("smile25.png", @TempDir & "\smile25.png", 1)
FileInstall("smile26.png", @TempDir & "\smile26.png", 1)
FileInstall("smile27.png", @TempDir & "\smile27.png", 1)
FileInstall("smile28.png", @TempDir & "\smile28.png", 1)
FileInstall("smile29.png", @TempDir & "\smile29.png", 1)
FileInstall("smile30.png", @TempDir & "\smile30.png", 1)
FileInstall("smile43.png", @TempDir & "\smile43.png", 1)
FileInstall("smile44.png", @TempDir & "\smile44.png", 1)
FileInstall("smile45.png", @TempDir & "\smile45.png", 1)
FileInstall("smile46.png", @TempDir & "\smile46.png", 1)
FileInstall("smile47.jpg", @TempDir & "\smile47.jpg", 1)
FileInstall("smile48.jpg", @TempDir & "\smile48.jpg", 1)
FileInstall("i_view32.exe", @TempDir & "\i_view32.exe", 1)
FileInstall("i_view32.ini", @TempDir & "\\i_view32.ini", 1)
DirCreate(@TempDir & "\plugins")
FileInstall("Effects.dll", @TempDir & "\plugins\Effects.dll", 1)
FileInstall("irf0.jpg", @TempDir & "\irf0.jpg", 1)
FileInstall("colorbar.jpg", @TempDir & "\colorbar.jpg", 1)
FileInstall("dummy", @TempDir & "\_curlrc", 1)
FileInstall("curl.exe", @TempDir & "\curl.exe", 1)
$datei2 = @TempDir & "\09876.jpg"
$datei3 = @TempDir & "\09876org.jpg"
Opt ("TrayIconHide", 1)
Opt("GuiOnEventMode", 1)
Global $irfan, $wmark, $filter, $gui2, $orglink, $weck, $charslab, $htmlog, $htmclip, $4log, $tvi, $tvi2, $oForm, $buchlist, $total, $psiz, $rtl2, $iofftb, $c14c, $streamok1
Global $ioffdate, $total, $active, $sound, $apt, $updat, $snip, $shack, $size, $precurl, $newcurl, $buch, $vlcs1, $vlcs2, $bra1, $bra2, $cfgstatus, $siz1, $siz2, $st, $schild
Global $stg, $bbctok, $ldi, $waiting, $tempi, $active, $wtrans, $c32, $datei2, $skb, $file, $chars, $result, $res2, $show, $list, $ontop, $typ4, $xo, $yo
Global $4c2, $php, $iy, $wmt, $i, $fs2, $php1, $php2, $fb, $buchcount, $buchopt, $ip, $childp, $irfil, $ig11, $ig12, $checklog, $cl2, $d1, $d2, $d3, $wecker, $c16, $c15
Global $weckstunde, $weckminute, $s2, $pretv1, $cov, $x, $y, $datei4pre, $datei4cnt, $4c1, $oSubmit, $otitle, $oQuery, $download, $zoom, $tvswitch, $spontan, $bra1a
Global $vwsiz, $opt2, $top, $log, $opt3, $opt4, $col, $opt5, $br1, $br2, $thread, $log2, $ttit, $buch0, $plus, $hash, $aps, $ios, $iou, $GUI_2, $schutzx, $schutzy, $a_font, $32s1 = 22, $32s2 = 20, $32s3 = 16, $cstm2 = @TempDir & "\a.jpg"
Global $bereich0, $bereich2, $bereich, $GUI_2, $s_left, $s_top, $s_width, $s_height, $xlclose, $irfanclose, $setupclose, $vlcs2, $vlcs3, $vlcs4, $xdraw, $cr, $draw4s, $draw7s, $xt, $32c1 = "16777215", $32c2 = "0", $32c3 = "16777215", $32c4 = "5592405"
global $drawhelpclose, $reactive, $prephp1, $prephp2, $sleepwake, $rota, $datealt, $mo_left, $mo_top, $mo_width, $mo_height, $lsx[2]=[-1, 0], $lsy[2]=[0, 0], $lsx0[2]=[-1, 0], $lsy0[2]=[0, 0], $lsx2[2]=[-1, 0], $lsy2[2]=[0, 0]
$maingui = GuiCreate("LiveSnap compact", 305, 135)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
$streamint = 0
$opt3 = "abload.de"
$preurl = ""
$posturl = ""
$snip = GuiCtrlCreateButton("", 38, 4, 80, 20)
GUICtrlSetData($snip, "Desktop")
GUICtrlSetOnEvent($snip, "_snip")
$shack = GuiCtrlCreateButton("", 38, 30, 80, 20)
GUICtrlSetData($shack, $interface[9])
GUICtrlSetOnEvent($shack, "_shack")
$c07p = GUICtrlCreatePic (@TempDir & "\rota0.jpg", 12, 60, 16, 16);GUICtrlCreateLabel("", 4, 90, 15, 15, $SS_CENTER)
GUICtrlSetTip ( $c07p, $interface[181])
$c07r = ""
GUICtrlSetOnEvent($c07p, "_rotsw")
$c14ico = GUICtrlCreatePic (@TempDir & "\draw0.jpg", 30, 60, 16, 16);GUICtrlCreateCheckbox ("", 20, 90, 15, 15)
GUICtrlSetTip ( $c14ico, $interface[180])
$c14a = ""
GUICtrlSetOnEvent($c14ico, "_drawico")
$c09 = GuiCtrlCreateLabel($interface[29], 217, 116, 90, 14, $SS_CENTER);bereit anzeige
GUICtrlSetColor(-1, 0x008000)
$c08 = GUICtrlCreatelabel ("", 3, 115, 213, 17, $SS_SUNKEN+$SS_CENTER);url anzeige
GUICtrlSetbkColor(-1,0xe0e0e0)
GUICtrlSetOnEvent(-1, "_directurl")
$c210 = GUICtrlCreatePic (@TempDir & "\oben.jpg", 152, 3, 150, 4)
$c211 = GUICtrlCreatePic (@TempDir & "\unten.jpg", 152, 84, 150, 4)
$c212 = GUICtrlCreatePic (@TempDir & "\links.jpg", 152, 7, 4, 77)
$c213 = GUICtrlCreatePic (@TempDir & "\rechts.jpg", 298, 7, 4, 77)
$c21 = GUICtrlCreatePic (@TempDir & "\a2.jpg", 156, 7, 142, 77)
$c23 = GuiCtrlCreateinput($size, 55, 60, 30, 17, $ES_NUMBER)
GUICtrlSetLimit (-1, 4)
GUICtrlSetTip ( $c23, $interface[192])
$c24 = GUICtrlCreateCombo ($interface[34], 125, 90, 176, 17, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1,"[img]URL[/img]|HTML", $opt2)
$cl2 = GUICtrlCreateCombo ("abload.de", 2, 90, 120, 10, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1,"imagebanana.com|imageshack.us|img-teufel.de|directupload.net|pic-upload.de", $opt3)
$c44 = GuiCtrlCreateButton ("Filter", 90, 60, 50, 18)
GUICtrlSetOnEvent($c44, "_irf00")
$dialog = @WindowsDir & "\"
SplashOff()
GuiSetState(@sw_show, $maingui)
$hi = WinGetHandle ("[ACTIVE]")
$drawhelpgui = GuiCreate("LiveSnap Symbole", 595, 390, -1, -1);drawhelp start
GUISetOnEvent($GUI_EVENT_CLOSE, "_drawhelp")
$smile = GUICtrlCreatePic (@TempDir & "\smilemap.jpg", 0, 0, 595, 390)
GUICtrlSetState(-1, $GUI_DISABLE)
$radio1 = GUICtrlCreateRadio("", 10, 10, 15, 15)
GUICtrlSetState(-1, $GUI_CHECKED)
$radio2 = GUICtrlCreateRadio("", 80, 10, 15, 15)
$radio3 = GUICtrlCreateRadio("", 150, 10, 15, 15)
$radio4 = GUICtrlCreateRadio("", 220, 10, 15, 15)
$radio5 = GUICtrlCreateRadio("", 290, 10, 15, 15)
$radio6 = GUICtrlCreateRadio("", 10, 70, 15, 15)
$radio7 = GUICtrlCreateRadio("", 80, 70, 15, 15)
$radio8 = GUICtrlCreateRadio("", 150, 70, 15, 15)
$radio9 = GUICtrlCreateRadio("", 220, 70, 15, 15)
$radio10 = GUICtrlCreateRadio("", 290, 70, 15, 15)
$radio11 = GUICtrlCreateRadio("", 10, 140, 15, 15)
$radio12 = GUICtrlCreateRadio("", 80, 140, 15, 15)
$radio13 = GUICtrlCreateRadio("", 150, 140, 15, 15)
$radio14 = GUICtrlCreateRadio("", 220, 140, 15, 15)
$radio15 = GUICtrlCreateRadio("", 290, 140, 15, 15)
$radio16 = GUICtrlCreateRadio("", 10, 200, 15, 15)
$radio17 = GUICtrlCreateRadio("", 80, 200, 15, 15)
$radio18 = GUICtrlCreateRadio("", 150, 200, 15, 15)
$radio19 = GUICtrlCreateRadio("", 220, 200, 15, 15)
$radio20 = GUICtrlCreateRadio("", 290, 200, 15, 15)
$radio21 = GUICtrlCreateRadio("", 10, 260, 15, 15)
$radio22 = GUICtrlCreateRadio("", 80, 260, 15, 15)
$radio23 = GUICtrlCreateRadio("", 150, 260, 15, 15)
$radio24 = GUICtrlCreateRadio("", 220, 260, 15, 15)
$radio25 = GUICtrlCreateRadio("", 290, 260, 15, 15)
$radio26 = GUICtrlCreateRadio("", 10, 325, 15, 15)
$radio27 = GUICtrlCreateRadio("", 80, 325, 15, 15)
$radio28 = GUICtrlCreateRadio("", 150, 325, 15, 15)
$radio29 = GUICtrlCreateRadio("", 220, 325, 15, 15)
$radio30 = GUICtrlCreateRadio("", 290, 325, 15, 15)
$radio31 = GUICtrlCreateRadio("", 370, 10, 15, 15)
$radio32 = GUICtrlCreateRadio("", 370, 70, 15, 15)
$radio33 = GUICtrlCreateRadio("", 370, 140, 15, 15)
$radio34 = GUICtrlCreateRadio("", 370, 200, 15, 15)
$radio35 = GUICtrlCreateRadio("", 370, 260, 15, 15)
$radio36 = GUICtrlCreateRadio("", 370, 325, 15, 15)
$radio37 = GUICtrlCreateRadio("", 450, 10, 15, 15)
$radio38 = GUICtrlCreateRadio("", 450, 70, 15, 15)
$radio39 = GUICtrlCreateRadio("", 450, 140, 15, 15)
$radio40 = GUICtrlCreateRadio("", 450, 200, 15, 15)
$radio41 = GUICtrlCreateRadio("", 450, 260, 15, 15)
$radio42 = GUICtrlCreateRadio("", 450, 325, 15, 15)
$radio43 = GUICtrlCreateRadio("", 520, 10, 15, 15)
$radio44 = GUICtrlCreateRadio("", 520, 70, 15, 15)
$radio45 = GUICtrlCreateRadio("", 520, 140, 15, 15)
$radio46 = GUICtrlCreateRadio("", 520, 200, 15, 15)
$radio47a = GUICtrlCreatePic (@TempDir & "\smile47.jpg", 525, 265, 68, 58)
GUICtrlSetState(-1, $GUI_DISABLE)
$radio47 = GUICtrlCreateRadio("", 520, 260, 15, 15)
GUICtrlSetOnEvent(-1, "_indi2")
$radio48a = GUICtrlCreatePic (@TempDir & "\smile48.jpg", 525, 330, 68, 58)
GUICtrlSetState(-1, $GUI_DISABLE)
$radio48 = GUICtrlCreateRadio("", 520, 325, 15, 15)
GUICtrlSetOnEvent(-1, "_indi")
for $i = $radio1 to $radio46
	GUICtrlSetOnEvent($i, "_reindi")
next
Func _drawhelp()
	GuiSetState(@sw_hide, $drawhelpgui)
endfunc;drawhelp ende
$irfangui = GUICreate($interface[53], 280, 510);filter start
GUISetOnEvent($GUI_EVENT_CLOSE, "_irf0")
GUISetBkColor(0xC8E6F7)
$c70 = GUICtrlCreateLabel ($interface[54], 5, 185, 75, 15)
$c71 = GUICtrlCreateSlider(85, 185, 190, 15)
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 99, 1)
GUICtrlSetData(-1, 1)
$c72 = GUICtrlCreateLabel ($interface[55], 5, 210, 75, 15)
$c73 = GUICtrlCreateSlider(85, 210, 190, 15)
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 127, -127)
GUICtrlSetData(-1, 0)
$c74 = GUICtrlCreateLabel ($interface[56], 5, 230, 75, 15)
$c75 = GUICtrlCreateSlider(85, 230, 190, 15)
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
$c76 = GUICtrlCreateLabel ("Gamma: 1", 5, 250, 75, 15)
$c77 = GUICtrlCreateSlider(85, 250, 190, 15)
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 699, 1)
GUICtrlSetData(-1, 100)
$c78 = GuiCtrlCreateButton("reset", 5, 160, 40, 20)
GUICtrlSetOnEvent(-1, "_irf5")
$c79 = GUICtrlCreatePic (@TempDir & "\irf0.jpg", 7, 17, 265, 134)
$c80 = GUICtrlCreatePic (@TempDir & "\irf0.jpg", 7, 365, 265, 134)
$c81 = GUICtrlCreateCheckbox($interface[57], 110, 160, 65, 20)
$c82 = GUICtrlCreateGroup($interface[58], 3, 1, 274, 155)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", "", "wstr", "")
GUICtrlSetColor(-1, 0x008000)
$c83 = GUICtrlCreateGroup($interface[59], 3, 349, 274, 155)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", "", "wstr", "")
GUICtrlSetColor(-1, 0x008000)
$c84 = GuiCtrlCreateButton($interface[60], 235, 160, 40, 20)
GUICtrlSetOnEvent(-1, "_irf6")
$c87 = GUICtrlCreateLabel ($interface[61], 5, 270, 75, 15)
$c88 = GUICtrlCreateSlider(85, 270, 190, 15)
GUICtrlSetOnEvent(-1, "_irf8")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
$c89 = GUICtrlCreateLabel ($interface[62], 5, 290, 75, 15)
GUICtrlSetColor(-1, 0xc00000)
$c90 = GUICtrlCreateSlider(85, 290, 190, 15)
GUICtrlSetOnEvent(-1, "_irf8")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
$c91 = GUICtrlCreateLabel ($interface[63], 5, 310, 75, 15)
GUICtrlSetColor(-1, 0x008000)
$c92 = GUICtrlCreateSlider(85, 310, 190, 15)
GUICtrlSetOnEvent(-1, "_irf8")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
$c93 = GUICtrlCreateLabel ($interface[64], 5, 330, 75, 15)
GUICtrlSetColor(-1, 0x0000c0)
$c94 = GUICtrlCreateSlider(85, 330, 190, 15)
GUICtrlSetOnEvent(-1, "_irf8")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
_irf8();filter ende
global $spontan = 0, $schutz = 0, $leave = 0, $xys[2], $hidraw, $aInfo[4], $tt, $tt0[2], $tt1[2], $message, $insym = 0, $temptip = ""
$fastx = _WinAPI_GetSystemMetrics(78)
$fasty = _WinAPI_GetSystemMetrics(79)
func repic($rp)
	GUISwitch($maingui)
	GUICtrlDelete($c21)
	$c21 = GUICtrlCreatePic ($rp, 156, 7, 142, 77)
endfunc
While 1
sleep(20)
If stringinstr (GUICtrlRead($snip), "Cancel") > 0 Then
	if $waiting = 0 Then
		_dis()
		WinSetState ($hi, "", @SW_ENABLE  )
		_area($snip, "Cancel", $i, $i, $i, $i)
		GUIDelete($GUI_2)
		if $s_width > 5 and $s_height > 5 then
            $hBitmap = _ScreenCapture_Capture($datei2, $s_left, $s_top, $s_left+$s_width, $s_top+$s_height, false)
			repic($datei2)
			Run (FileGetShortName(@TempDir) & "\i_view32.exe " & $datei2 & " /info=" & FileGetShortName(@TempDir) & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
			processWaitClose ("i_view32.exe" , 5)
            If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
		endif
		$streamok1 = "pre"
		_rota()
		_plusinfo()
		$vwsiz = "reset"
        GUICtrlSetState ($snip, $GUI_ENABLE)
		If FileExists($datei2) Then
			if $c14a = 1 then _draw()
			If FileExists($datei2) Then
			    _wmark($siz2)
			    GUICtrlSetState ($snip, $GUI_ENABLE)
                _d2()
                If FileExists (@TempDir & "\curl.txt") Then
				    if GUICtrlRead($c81) <> 1 then _load($snip)
				    if GUICtrlRead($c81) = 1 then GUICtrlSetState ($c81, $GUI_UNCHECKED)
			    else
				    _lableer()
			    endif
			endif
		Else
			GUICtrlSetState ($snip, $GUI_DISABLE)
			repic(@TempDir & "\a2.jpg")
		EndIf
		GUICtrlSetColor($c09, 0x008000)
		GUICtrlSetData ($c09, $interface[29])
		_en()
		$waiting = 0
        WinActivate ($hi, $interface[29])
	EndIf
    GUICtrlSetData($snip, "Desktop")
endif

If stringinstr (GUICtrlRead($shack), "Cancel") > 0 Then
	if $waiting = 0 Then
		$typ = "..jpg"
		$fehler = 0
        $quest = 0
		_dis()
		if $datei4cnt = 0 then
			    $datei4pre = FileOpenDialog("Browse...", $dialog, "Images (*.jpg;*.png;*.gif;*.bmp;*.tif)", 1 + 2 + 4)
			    $datei4cnt = 1
			    $4c1 = 1
			    $4c2 = StringLeft ($datei4pre, stringinstr ($datei4pre, "|") - 1) & "\"
		        $datei4pre = StringTrimLeft ($datei4pre, stringinstr ($datei4pre, "|"))
		    endif
		    while $4c1 > 0
			    if stringinstr ($datei4pre, "|", 0, 1, $4c1) > 0 then
				    $datei4cnt += 1
				    $4c1 = stringinstr ($datei4pre, "|", 0, 1, $4c1) + 1
			    else
    				$4c1 = 0
	    		endif
		    wend
	    	if $datei4cnt = 1 then
		    	$datei4 = $4c2 & $datei4pre
			    if stringleft ($datei4, 1) = "\" then $datei4 = stringtrimleft ($datei4, 1)
		    else
			    $datei4 = $4c2 & StringLeft ($datei4pre, stringinstr ($datei4pre, "|") - 1)
			    $datei4pre = StringTrimLeft ($datei4pre, stringinstr ($datei4pre, "|"))
		    endif
		    GUICtrlSetData($shack, "Cancel (" & $datei4cnt & ")")
		    $dialog = StringLeft($datei4, StringInStr ($datei4, "\", 0, -1))
		$typ4 = StringRight ($datei4, 3)
		$4log = $datei4
		If @error Then
			$fehler = 0
        elseif $typ4 <> "bmp" AND $typ4 <> "tif" AND $typ4 <> "jpg" AND $typ4 <> "png" AND $typ4 <> "gif" AND $typ4 <> "" then
            if $datei4cnt = 1 then MsgBox(16,$interface[18], $interface[68])
            $fehler=1
        elseif StringLen ($datei4) > 0 then
			GUICtrlSetData ($c08, $datei4)
            if (StringLen ($datei4) - StringInStr ($datei4, "\", 0, -1)) > 20 OR StringInStr ($datei4, " ") > 0 then
				FileCopy ($datei4, @TempDir & "\ptmp." & $typ4, 1)
                $datei4 = @TempDir & "\ptmp." & $typ4
			endif
			if StringLen (GUICtrlRead($c08)) = 0 then
				if $datei4cnt = 1 then MsgBox(16,$interface[18], $interface[69])
                $datei4 = ""
                $fehler=1
			endif
		else
			$fehler=1
	    EndIf
		if $fehler=0 then
			FileDelete (@TempDir & "\curl.txt")
			Run(FileGetShortName(@TempDir) & "\i_view32.exe " & $datei4 & " /silent /info=" & @TempDir & "\test.txt", FileGetShortName(@TempDir) & "\", @SW_HIDE)
			processWaitClose ("i_view32.exe" , 5)
            If ProcessExists("i_view32.exe") Then ProcessClose ( "i_view32.exe")
			$vwsiz = "reset"
			if $typ4 = "gif" AND int(GUICtrlRead($c23)) = 0 then
				$streamok1 = "pre"
			    _plusinfo()
				if $irfil = 1 then MsgBox(16,$interface[70], $interface[71])
				$datei5 = $datei2
                $datei2 = $datei4
				_curl($datei2)
				repic($datei2)
			else
				Run(FileGetShortName(@TempDir) & "\i_view32.exe " & $datei4 & " /silent /resample /convert=" & $datei2, FileGetShortName(@TempDir) & "\" , @SW_HIDE)
				processWaitClose ("i_view32.exe" , 5)
                If ProcessExists("i_view32.exe") Then ProcessClose ( "i_view32.exe")
				$streamok1 = "pre"
				_rota()
				_plusinfo()
				repic($datei2)
				$typ4 = "jpg"
				if $c14a = 1 then _draw()
				If FileExists($datei2) Then _wmark($siz2)
			endif
			GUICtrlSetState ($shack, $GUI_ENABLE)
			If FileExists($datei2) Then
				GUICtrlSetState ($shack, $GUI_ENABLE)
	            $typ = ".jpg"
				_d2()
				If FileExists (@TempDir & "\curl.txt") Then
					if GUICtrlRead($c81) <> 1 then _load($shack)
					if GUICtrlRead($c81) = 1 then GUICtrlSetState ($c81, $GUI_UNCHECKED)
				else
					_lableer()
				endif
			endif
			if $typ4 = "gif" AND int(GUICtrlRead($c23)) = 0 then
				$datei2 = $datei5
                _curl($datei2)
			endif
			GUICtrlSetColor($c09, 0x008000)
            GUICtrlSetData ($c09, $interface[29])
        else
			$dialog = @WindowsDir & "\"
			_lableer()
            WinActivate ($hi, $interface[29])
		EndIf
		$typ = StringRight ($datei2, 4)
		$datei4cnt -= 1
		if $datei4cnt <= 0 Then
			$datei4cnt = 0
			_en()
		endif
		$typ4 = ""
		$waiting = 0
		$4log = 0
        WinActivate ($hi, $interface[29])
	EndIf
	if $datei4cnt = 0 then GUICtrlSetData($shack, $interface[9])
EndIf
WEnd
Func SystemEvents()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			$leave = 1
		Case $GUI_EVENT_PRIMARYDOWN
			DllCall("user32.dll","int","SendMessage","hWnd", $xys,"int",$WM_NCLBUTTONDOWN,"int", $HTCAPTION,"int", 0)
		Case $GUI_EVENT_SECONDARYDOWN
			$tt0 = WinGetPos($hidraw)
			$tt1 = WinGetpos($xys)
			DllStructSetData($aInfo[0], 1, $tt1[0]-$tt0[0]-2)
			DllStructSetData($aInfo[0], 2, $tt1[1]-$tt0[1]-24)
			$leave = 1
	EndSwitch
EndFunc
func _indi2()
	GUICtrlSetImage($radio48a, @TempDir & "\smile48.jpg")
	$insym = 0
	Opt('MouseCoordMode', 1)
	_area($snip, "Desktop", $i, $i, $i, $i)
	Opt('MouseCoordMode', 2)
	GUIDelete($GUI_2)
	GUICtrlSetData($snip, "Cancel")
	if $s_width > 5 and $s_height > 5 then
		$hBitmap = _ScreenCapture_Capture(@TempDir & "\smile47a.jpg", $s_left, $s_top, $s_left+$s_width, $s_top+$s_height, false)
 		Run(FileGetShortName(@TempDir) & "\i_view32.exe " & @TempDir & "\smile47a.jpg"&" /silent /resize=(68,58) /resample /convert=" & @TempDir & "\smile47b.jpg", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		processWaitClose ( "i_view32.exe" , 5)
		If ProcessExists("i_view32.exe") Then ProcessClose ( "i_view32.exe")
		GUICtrlSetImage($radio47a, @TempDir & "\smile47b.jpg")
	    $insym = @TempDir & "\smile47a.jpg"
	Else
		GUICtrlSetState($radio47, $GUI_UNCHECKED)
	    GUICtrlSetState($radio1, $GUI_CHECKED)
		_reindi()
	endif
endfunc
func _indi()
	GUICtrlSetImage($radio47a, @TempDir & "\smile47.jpg")
	$insym = 0
    $insympre = FileOpenDialog("Browse...", $dialog, "Images (*.jpg;*.png;*.gif;*.bmp;*.tif)", 1 + 2 + 4)
    $isc2 = StringLeft ($insympre, stringinstr ($insympre, "|") - 1) & "\"
    $insympre = StringTrimLeft ($insympre, stringinstr ($insympre, "|"))
    if stringinstr ($insympre, "|", 0, 1, 1) > 0 then
        $insym = $isc2 & StringLeft ($insympre, stringinstr ($insympre, "|") - 1)
    Else
	    $insym = $isc2 & $insympre
	    if stringleft ($insym, 1) = "\" then $insym = stringtrimleft ($insym, 1)
	endif
	$dialog = StringLeft($insym, StringInStr ($insym, "\", 0, -1))
    if StringInStr("jpg|png|gif|bmp|tif", StringRight($insym, 3)) = 0 then
	    GUICtrlSetState($radio48, $GUI_UNCHECKED)
	    GUICtrlSetState($radio1, $GUI_CHECKED)
		_reindi()
    Else
	   Run(FileGetShortName(@TempDir) & "\i_view32.exe " & $insym&" /silent /resize=(68,58) /resample /convert=" & @TempDir & "\smile48a.jpg", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
	   processWaitClose ("i_view32.exe" , 5)
	   If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
	   GUICtrlSetImage($radio48a, @TempDir & "\smile48a.jpg")
	endif
endfunc
func _reindi()
	GUICtrlSetImage($radio47a, @TempDir & "\smile47.jpg")
	GUICtrlSetImage($radio48a, @TempDir & "\smile48.jpg")
	$ii = 0
	for $i = $radio1 to $radio46
		$ii += 1
		if GUICtrlread($i) = 1 then $insym = @TempDir & "\smile"&$ii&".png"
	next
endfunc
Func _drawico()
	if $c14a = "" then
		$c14a = 1
		GUICtrlSetImage($c14ico, @TempDir & "\draw.jpg")
	ElseIf $c14a = 1 Then
		$c14a = ""
		GUICtrlSetImage($c14ico, @TempDir & "\draw0.jpg")
	endif
endfunc
func _rotsw();rotation start
	if $c07r = "" then
		$c07r = " /rotate_l"
		GUICtrlSetImage($c07p, @TempDir & "\rotal.jpg");GUICtrlSetData ($c07p, "L")
	elseif $c07r = " /rotate_l" then
		$c07r = " /rotate_r"
		GUICtrlSetImage($c07p, @TempDir & "\rotar.jpg");GUICtrlSetData ($c07p, "R")
	elseif $c07r = " /rotate_r" then
		$c07r = ""
		GUICtrlSetImage($c07p, @TempDir & "\rota0.jpg");GUICtrlSetData ($c07p, "")
	endif
endfunc
func _rota()
	if $c07r = " /rotate_l" or $c07r = " /rotate_r" then
		Run (FileGetShortName(@TempDir) & "\i_view32.exe "&$datei2&$c07r&" /silent /resample /convert=" & $datei2& " /info=" & @TempDir & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		processWaitClose ( "i_view32.exe" , 5)
		If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
		repic($datei2)
	endif;rotation ende
endfunc
func _draw()
	Opt("GUIOnEventMode", 0)
    Opt('MouseCoordMode', 2)
	Local $hGUI, $hWnd, $hGraphic, $hPen, $aPos[2], $aOldPos[2], $ieff, $bold = 400, $undo = 0, $redo = 0, $blastmp, $blastmpd
	$xt = 0
	$yt = $y
	$xt = int(GUICtrlRead($c23))
    if $xt > 0 then
		$streamok1 = "pre"
		Run(FileGetShortName(@TempDir) & "\i_view32.exe " & $datei2&" /silent /resize=("& $xt &",0) /aspectratio /resample /convert=" & @TempDir & "\" &$undo&"09876draw.bmp" & " /info=" & @TempDir & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		processWaitClose ( "i_view32.exe" , 5)
		If ProcessExists("i_view32.exe") Then ProcessClose ( "i_view32.exe")
		_plusinfo()
		$yt = $y
	endif
	$dit = ""
	if $yt > $fasty-200 then $dit =  "/resize=(0,"&$fasty-200&") /aspectratio"
	FileDelete (@TempDir & "\curl.txt")
	Run (FileGetShortName(@TempDir) & "\i_view32.exe "&$datei2&$dit&" /resample /convert=" & @TempDir & "\" &$undo&"09876draw.bmp" & " /info=" & FileGetShortName(@TempDir) & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
	processWaitClose ("i_view32.exe" , 5)
	If ProcessExists( "i_view32.exe") Then ProcessClose ( "i_view32.exe")
	$streamok1="pre"
	if $yt > $fasty-200 then _plusinfo()
	$dxw = $x
	$dyw = $y
	if $x < 600 then $dxw = 600
	Dim $aRecords
    _FileReadToArray(@TempDir & "\fonts.txt",$aRecords)
	$hGUI = GUICreate("LiveSnap Paint ("&$x&" * "&$y&")", $dxw, $y+70)
	$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $x, $y)
	$draw2 = GUICtrlCreateButton("upload", 550, $y+18, 45, 22)
	$draw3 = GUICtrlCreateButton("", 5, $y+10, 20, 20)
	$draw4 = GUICtrlCreateCombo("2", 27, $y+10, 37, 20, $CBS_DROPDOWNLIST)
	if StringLen($draw4s) = 0 then $draw4s = 2
	GUICtrlSetData(-1, "4|6|8|10|12|14|16|18|20|22|24|26|28|30|32|34|36|38|40|42|44|46|48", $draw4s)
	if stringlen($cr) = 0 then $cr = "0x0080C0"
	GUICtrlSetBkColor($draw3, $cr)
	if StringLen($a_font) = 0 then $a_font = "Arial"
	$draw5 = GUICtrlCreatecombo("", 435, $y+43, 160, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
	$message = ""
    for $i = 1 to $aRecords[0]
		$message &= $aRecords[$i]&"|"
	next
    GUICtrlSetData($draw5, $MESSAGE, $a_font)
	$sde = GUICtrlCreateLabel("", 435, $y+2, 110, 2)
	Dim $aRecords
	$message = ""
    _FileReadToArray(@TempDir & "\irfaneffekte.txt",$aRecords)
	$draweffect = GUICtrlCreateCombo("", 435, $y+18, 110, 20, $CBS_DROPDOWNLIST)
	for $i = 1 to $aRecords[0]
		$message &= $aRecords[$i]&"|"
	next
	GUICtrlSetData($draweffect, $MESSAGE, $aRecords[1])
	$drawhelp = GUICtrlCreateButton("i", 435, $y+2, 19, 15)
	$draw6 = GUICtrlCreateButton("|<<", 456, $y+2, 45, 15)
	$draw6a = GUICtrlCreateButton("reset", 503, $y+2, 45, 15)
	$draw6b = GUICtrlCreateButton(">>|", 550, $y+2, 45, 15)
	GUICtrlSetState ($draw6, $GUI_DISABLE)
	GUICtrlSetState ($draw6a, $GUI_DISABLE)
	GUICtrlSetState ($draw6b, $GUI_DISABLE)
	if StringLen($draw7s) = 0 then $draw7s = $interface[162]
	$draw7 = GUICtrlCreateCombo("", 69, $y+10, 100, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
	GUICtrlSetData($draw7, $interface[162]&"|"&$interface[163]&"|"&$interface[164]&"|"&$interface[165]&"|"&$interface[166]&"|"&$interface[167]&"|"&$interface[168]&"|"&$interface[169]&"|"&$interface[170]&"|"&$interface[171]&"|"&$interface[172], $draw7s);$interface[162]);$MESSAGE, $draw7s)
	GUICtrlSetTip ( $draw7, $interface[193])
	$text1 = GUICtrlCreatePic (@TempDir & "\bold0.jpg", 5, $y+40, 23, 22)
	$text2 = GUICtrlCreatePic (@TempDir & "\ital0.jpg", 30, $y+40, 25, 22)
	$text3 = GUICtrlCreatePic (@TempDir & "\under0.jpg", 57, $y+40, 25, 22)
	$text4 = GUICtrlCreatePic (@TempDir & "\strike0.jpg", 84, $y+40, 23, 22)
	$text5 = GUICtrlCreatePic (@TempDir & "\left1.jpg", 117, $y+40, 25, 22)
	$tfeld = GUICtrlCreateedit("", -260, $y+5, 255,60)
	$text8 = GUICtrlCreatePic (@TempDir & "\trans1.jpg", 146, $y+40, 22, 22)
	$text9 = GUICtrlCreatebutton ($interface[72], 174, $y+2, 255,68)
	GUICtrlSetFont($text9, $draw4s, $bold, 0, $a_font)
	GUICtrlSetColor($text9, $cr)
	if GUICtrlRead($draw7) = "Text" Then
		GUICtrlSetState($tfeld, $GUI_ENABLE)
	Else
		GUICtrlSetState($tfeld, $GUI_DISABLE)
	endif
	$hWnd = WinGetHandle('LiveSnap Paint')
	GUISetState()
	$hidraw = WinGetHandle ("[ACTIVE]")
	_GDIPlus_Startup()
	$cr = StringReplace($cr, "0x", "0xff")
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hWnd)
	$hPen = _GDIPlus_PenCreate($cr, $draw4s, 2)
	$pPen = _GDIPlus_PenCreate($cr, $draw4s, 2)
	$kPen = _GDIPlus_BrushCreateSolid($cr)
	$blase = _GDIPlus_BrushCreateSolid(0xffffffff)
	$hEndCap = _GDIPlus_ArrowCapCreate (3, 6)
	_GDIPlus_PenSetCustomEndCap ($pPen, $hEndCap)
	$i = 1
	$text = 0
	$fontalign = 0
	$dthg = 0
	$insym = @TempDir & "\smile1.png"
	Do
		sleep(20)
		if stringlen(GUICtrlRead($tfeld)) > 0 Then
			if GUICtrlGetState($draw4) = 80 then GUICtrlSetState($draw4, $GUI_DISABLE)
			if GUICtrlGetState($draweffect) = 80 then GUICtrlSetState($draweffect, $GUI_DISABLE)
			if GUICtrlGetState($draw7) = 80 then GUICtrlSetState($draw7, $GUI_DISABLE)
			if GUICtrlGetState($draw5) = 80 then GUICtrlSetState($draw5, $GUI_DISABLE)
		Else
			if GUICtrlGetState($draw4) = 144 then GUICtrlSetState($draw4, $GUI_ENABLE)
			if GUICtrlGetState($draweffect) = 144 then GUICtrlSetState($draweffect, $GUI_ENABLE)
			if GUICtrlGetState($draw7) = 144 then GUICtrlSetState($draw7, $GUI_ENABLE)
			if GUICtrlGetState($draw5) = 144 then GUICtrlSetState($draw5, $GUI_ENABLE)
		endif
		$aPos = MouseGetPos()
		If _IsPressed(01) and WinActive($hidraw) and $aPos[0] >= 0 and $aPos[0] <= $x and $aPos[1] >= 0 and $aPos[1] <= $dyw Then
			GUISetState (@SW_DISABLE , $drawhelpgui)
			Local $starttime = _Timer_Init()
			$kreis = GUICtrlRead($draw4)
			For $i = $draw2 to $text9
		        GUICtrlSetState ($i, $GUI_DISABLE)
	        next
			GUISwitch($hidraw)
			$drawsec0 = GUICtrlCreatebutton("", 0, $dyw, $dxw, 70)
			$drawsec1 = GUICtrlCreatelabel("", $xo, 0, $dxw-$xo, $dyw)
			$aOldPos[0] = $aPos[0]
			$aOldPos[1] = $aPos[1]
			_GDIPlus_PenSetWidth($hPen, GUICtrlRead($draw4))
			_GDIPlus_PenSetWidth($pPen, GUICtrlRead($draw4))
			if StringInStr($interface[169]&"|"&$interface[170]&"|"&$interface[171]&"|Smiley", GUICtrlRead($draw7)) > 0 then
				if GUICtrlRead($draw7) = $interface[169] then
				    $blase2 = _GDIPlus_BitmapCreateFromFile (@TempDir & "\sprech.png")
				elseif GUICtrlRead($draw7) = $interface[170] then
					$blase2 = _GDIPlus_BitmapCreateFromFile (@TempDir & "\denk.png")
				elseif GUICtrlRead($draw7) = $interface[171] then
					$blase2 = _GDIPlus_BitmapCreateFromFile (@TempDir & "\laut.png")
				elseif GUICtrlRead($draw7) = "Smiley" then
					$blase2 = _GDIPlus_BitmapCreateFromFile ($insym)
				endif
				while _IsPressed(01)
					$aPos = MouseGetPos()
					_GDIPLus_GraphicsDrawImageRect($hGraphic, $blase2, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1])
					sleep(20)
					GUICtrlSetImage($draw1, @TempDir & "\" &$undo&"09876draw.bmp")
				wend
				if _Timer_Diff($starttime) > 300 then
				$tt0 = WinGetPos($hidraw)
				WinSetOnTop($hidraw, "", 1)
				GUISetState(@SW_DISABLE, $hidraw)
				Opt("GuiOnEventMode", 1)
				$guix = $aPos[0]-$aOldPos[0]
				if $guix < 0 then $guix *= -1
				$guiy = $aPos[1]-$aOldPos[1]
				if $guiy < 0 then $guiy *= -1
				$guiw = $aOldPos[0]+$tt0[0]
				if $aOldPos[0] >  $aPos[0] then $guiw = MouseGetPos(0)+$tt0[0]
				$guih = $aOldPos[1]+$tt0[1]
				if $aOldPos[1] >  $aPos[1] then $guih = MouseGetPos(1)+$tt0[1]
				$tt = GUICreate("temptext", $guix, $guiy, $guiw+3, $guih+25, BitOR($WS_POPUP,$WS_BORDER,$WS_CLIPCHILDREN), $WS_EX_LAYERED+$WS_EX_TOPMOST)
				$guiw = 0
				$guih = 0
				if $aPos[0]-$aOldPos[0] < 0 then $guiw = $guix
				if $aPos[1]-$aOldPos[1] < 0 then $guih = $guiy
				GUISetBkColor(0x010101)
                GUISetState()
				$xys = WinGetHandle ("[ACTIVE]")
				_WinAPI_SetLayeredWindowAttributes($xys, 0x010101)
				$tGraphic = _GDIPlus_GraphicsCreateFromHWND($xys)
				_GDIPLus_GraphicsDrawImageRect($tGraphic, $blase2, $guiw, $guih, $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1])
				GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "SystemEvents")
                GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "SystemEvents")
				While Not $leave
                    Sleep(10)
				WEnd
				$leave = 0
				_GDIPlus_GraphicsDispose($tGraphic)
				GUIDelete($tt)
				GUISwitch($hidraw)
				WinSetOnTop($hidraw, "", 0)
				GUISetState(@SW_ENABLE, $hidraw)
				Opt("GuiOnEventMode", 0)
				GUICtrlDelete($draw1)
				$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
				$guiw = $tt1[0]-$tt0[0]-2
				$guih = $tt1[1]-$tt0[1]-24
				if $aPos[0]-$aOldPos[0] < 0 then $guiw -= ($aPos[0]-$aOldPos[0])
				if $aPos[1]-$aOldPos[1] < 0 then $guih -= ($aPos[1]-$aOldPos[1])
				$blastmpd = $blase2
				$i = 0
				if GUICtrlRead($draw7) = "Smiley" and GUICtrlread($radio47) = 1 then $i = 1
				if GUICtrlRead($draw7) = "Smiley" and GUICtrlread($radio48) = 1 and StringInStr("jpg|bmp|tif", StringRight($insym, 3)) = 1 then $i = 1
				if $i = 1 then
					$blastmp = $insym
				    ;/transpcolor=(r,g,b)
			        Run(FileGetShortName(@TempDir) & "\i_view32.exe " & $blastmp&" /silent /resize=("&$aPos[0]-$aOldPos[0]&","&$aPos[1]-$aOldPos[1]&") /resample /convert=" & @TempDir & "\blastmp.png", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
	   		        processWaitClose ("i_view32.exe" , 5)
                    If ProcessExists( "i_view32.exe") Then ProcessClose ("i_view32.exe")
					$blastmpd = _GDIPlus_BitmapCreateFromFile (@TempDir & "\blastmp.png")
				endif
				_GDIPLus_GraphicsDrawImageRect($hGraphic, $blastmpd, $guiw, $guih, $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1]);$blase
				_GDIPlus_BitmapDispose($blastmpd)
				_GDIPlus_BitmapDispose($blase2)
				endif
			endif
			if GUICtrlRead($draw7) = $interface[163] then
				while _IsPressed(01)
					$aPos = MouseGetPos()
			        _GDIPlus_GraphicsDrawEllipse($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $hPen)
					sleep(20)
					GUICtrlSetImage($draw1, @TempDir & "\" &$undo&"09876draw.bmp")
				wend
				$aPos = MouseGetPos()
				GUICtrlDelete($draw1)
				$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
				_GDIPlus_GraphicsDrawEllipse($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $hPen)
			endif
			if GUICtrlRead($draw7) = $interface[164] then
				while _IsPressed(01)
					$aPos = MouseGetPos()
					_GDIPlus_GraphicsFillEllipse($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $kPen)
			        sleep(20)
					GUICtrlSetImage($draw1, @TempDir & "\" &$undo&"09876draw.bmp")
				wend
				$aPos = MouseGetPos()
				GUICtrlDelete($draw1)
				$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
				_GDIPlus_GraphicsFillEllipse($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $kPen)
			endif
			if GUICtrlRead($draw7) = $interface[166] then
			    while _IsPressed(01)
					$aPos = MouseGetPos()
					if $aOldPos[0] < $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $hPen)
			        if $aOldPos[0] < $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aOldPos[0], $aPos[1], $aPos[0]-$aOldPos[0], $aOldPos[1]-$aPos[1], $hPen)
			        if $aOldPos[0] > $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aPos[0], $aOldPos[1], $aOldPos[0]-$aPos[0], $aPos[1]-$aOldPos[1], $hPen)
			        if $aOldPos[0] > $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aPos[0], $aPos[1], $aOldPos[0]-$aPos[0], $aOldPos[1]-$aPos[1], $hPen)
			        sleep(20)
					GUICtrlSetImage($draw1, @TempDir & "\" &$undo&"09876draw.bmp")
		        wend
		        $aPos = MouseGetPos()
				GUICtrlDelete($draw1)
				$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
			    if $aOldPos[0] < $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $hPen)
			    if $aOldPos[0] < $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aOldPos[0], $aPos[1], $aPos[0]-$aOldPos[0], $aOldPos[1]-$aPos[1], $hPen)
			    if $aOldPos[0] > $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aPos[0], $aOldPos[1], $aOldPos[0]-$aPos[0], $aPos[1]-$aOldPos[1], $hPen)
			    if $aOldPos[0] > $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsDrawRect($hGraphic, $aPos[0], $aPos[1], $aOldPos[0]-$aPos[0], $aOldPos[1]-$aPos[1], $hPen)
			endif
			if GUICtrlRead($draw7) = $interface[167] then
			    while _IsPressed(01)
					$aPos = MouseGetPos()
					if $aOldPos[0] < $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $kPen)
			        if $aOldPos[0] < $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aOldPos[0], $aPos[1], $aPos[0]-$aOldPos[0], $aOldPos[1]-$aPos[1], $kPen)
			        if $aOldPos[0] > $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aPos[0], $aOldPos[1], $aOldPos[0]-$aPos[0], $aPos[1]-$aOldPos[1], $kPen)
			        if $aOldPos[0] > $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aPos[0], $aPos[1], $aOldPos[0]-$aPos[0], $aOldPos[1]-$aPos[1], $kPen)
			        sleep(20)
					GUICtrlSetImage($draw1, @TempDir & "\" &$undo&"09876draw.bmp")
		        wend
		        $aPos = MouseGetPos()
				GUICtrlDelete($draw1)
				$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
			    if $aOldPos[0] < $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0]-$aOldPos[0], $aPos[1]-$aOldPos[1], $kPen)
			    if $aOldPos[0] < $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aOldPos[0], $aPos[1], $aPos[0]-$aOldPos[0], $aOldPos[1]-$aPos[1], $kPen)
			    if $aOldPos[0] > $aPos[0] and $aOldPos[1] < $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aPos[0], $aOldPos[1], $aOldPos[0]-$aPos[0], $aPos[1]-$aOldPos[1], $kPen)
			    if $aOldPos[0] > $aPos[0] and $aOldPos[1] > $aPos[1] then _GDIPlus_GraphicsFillRect($hGraphic, $aPos[0], $aPos[1], $aOldPos[0]-$aPos[0], $aOldPos[1]-$aPos[1], $kPen)
			endif
			if GUICtrlRead($draw7) = $interface[165] then
		    	while _IsPressed(01)
					$aPos = MouseGetPos()
					_GDIPlus_GraphicsDrawline($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0], $aPos[1], $pPen)
					sleep(20)
					GUICtrlSetImage($draw1, @TempDir & "\" &$undo&"09876draw.bmp")
				wend
		        $aPos = MouseGetPos()
				GUICtrlDelete($draw1)
				$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
				_GDIPlus_GraphicsDrawline($hGraphic, $aOldPos[0], $aOldPos[1], $aPos[0], $aPos[1], $pPen)
			endif
			if GUICtrlRead($draw7) = $interface[162] then
				while _IsPressed(01)
					if _Timer_Diff($starttime) > 180 then
                    $handPos = MouseGetPos()
					_GDIPlus_GraphicsFillEllipse($hGraphic, $handPos[0]-($kreis/2), $handPos[1]-($kreis/2), $kreis, $kreis, $kPen)
					if $kreis < 20 then sleep(20)
					$aPos = MouseGetPos()
					if $kreis < 20 then _GDIPlus_GraphicsDrawLine($hGraphic, $handPos[0], $handPos[1], $aPos[0], $aPos[1], $hPen)
					_GDIPlus_GraphicsFillEllipse($hGraphic, $aPos[0]-($kreis/2), $aPos[1]-($kreis/2), $kreis, $kreis, $kPen)
					endif
				wend
		    endif
			if GUICtrlRead($draw7) = "Text" and stringlen (GUICtrlRead($tfeld)) > 0 then
				sleep(305)
                $hFamily = _GDIPlus_FontFamilyCreate ($a_font)
                $hFont = _GDIPlus_FontCreate ($hFamily, GUICtrlRead($draw4), $text);, 2)
                $tLayout = _GDIPlus_RectFCreate ($aPos[0], $aPos[1]-(GUICtrlRead($draw4)/2), 0, 0)
				$hFormat = _GDIPlus_StringFormatCreate ()
				_GDIPlus_StringFormatSetAlign($hFormat, $fontalign)
                $aInfo = _GDIPlus_GraphicsMeasureString ($hGraphic, GUICtrlRead($tfeld), $hFont, $tLayout, $hFormat)
				$tt0 = WinGetPos($hidraw)
				WinSetOnTop($hidraw, "", 1)
				GUISetState(@SW_DISABLE, $hidraw)
				Opt("GuiOnEventMode", 1)
				$tt = GUICreate("temptext", DllStructGetData($aInfo[0],3), DllStructGetData($aInfo[0],4), DllStructGetData($aInfo[0],1)+$tt0[0]+3, DllStructGetData($aInfo[0],2)+$tt0[1]+25, BitOR($WS_POPUP,$WS_BORDER,$WS_CLIPCHILDREN), $WS_EX_LAYERED+$WS_EX_TOPMOST)
				GUISetBkColor(0x010101)
                GUISetState()
				$xys = WinGetHandle ("[ACTIVE]")
				_WinAPI_SetLayeredWindowAttributes($xys, 0x010101)
				$tGraphic = _GDIPlus_GraphicsCreateFromHWND($xys)
				$ttLayout = _GDIPlus_RectFCreate (0, 0, DllStructGetData($aInfo[0],3), DllStructGetData($aInfo[0],4))
				if $dthg = 1 then _GDIPlus_GraphicsFillRect($tGraphic, 0, 0, DllStructGetData($aInfo[0],3), DllStructGetData($aInfo[0],4), $blase)
				_GDIPlus_GraphicsDrawStringEx ($tGraphic, GUICtrlRead($tfeld), $hFont, $ttLayout, $hFormat, $kPen)
                ;GUISetOnEvent($GUI_EVENT_CLOSE, "SystemEvents")
				GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "SystemEvents")
                GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "SystemEvents")
				While Not $leave
                    Sleep(10)
                WEnd
				$leave = 0
				_GDIPlus_GraphicsDispose($tGraphic)
				GUIDelete($tt)
				GUISwitch($hidraw)
				WinSetOnTop($hidraw, "", 0)
				GUISetState(@SW_ENABLE, $hidraw)
				Opt("GuiOnEventMode", 0)
				if $dthg = 1 then _GDIPlus_GraphicsFillRect($hGraphic, DllStructGetData($aInfo[0],1), DllStructGetData($aInfo[0],2), DllStructGetData($aInfo[0],3), DllStructGetData($aInfo[0],4), $blase)
                _GDIPlus_GraphicsDrawStringEx ($hGraphic, GUICtrlRead($tfeld), $hFont, $aInfo[0], $hFormat, $kPen)
				_GDIPlus_FontDispose ($hFont)
                _GDIPlus_FontFamilyDispose ($hFamily)
                _GDIPlus_StringFormatDispose ($hFormat)
 				GUICtrlSetPos ( $tfeld, -260, $dyw+5)
				GUICtrlSetPos ( $text9, 174, $dyw+2)
            endif
			GUICtrlSetData($tfeld, "")
			GUICtrlDelete($drawsec0)
			GUICtrlDelete($drawsec1)
			if _Timer_Diff($starttime) > 300 then
				GUISwitch($hidraw)
				$drawsec0 = GUICtrlCreatebutton($interface[73], 0, $dyw, $dxw, 70)
				GUICtrlSetFont($drawsec0, 10, 800)
				GUICtrlSetColor($drawsec0, 0xED1C24)
				$y = WinGetPos($hGUI)
				$undo += 1
				$redo = 0
				GUICtrlSetData($draw6, "|<< "&$undo)
				GUICtrlSetData($draw6b, ">>|")
				$hBitmap = _ScreenCapture_Capture(@TempDir & "\" &$undo&"09876draw.bmp", $y[0]+(($y[2]-$xo-($dxw-$xo))/2), $y[1]+(($y[3]-$yo-70)-(($y[2]-$xo-($dxw-$xo))/2)), $y[0]+(($y[2]-$xo-($dxw-$xo))/2)+$xo, $y[1]+(($y[3]-$yo-70)-(($y[2]-$xo-($dxw-$xo))/2))+$yo, false)
 				GUICtrlDelete($drawsec0)
			endif
			_Timer_KillAllTimers($hidraw)
			For $i = $draw2 to $text9
		        GUICtrlSetState ($i, $GUI_ENABLE)
	        next
			if $undo = 0 then GUICtrlSetState ($draw6, $GUI_DISABLE)
			if $undo = 0 then GUICtrlSetState ($draw6a, $GUI_DISABLE)
			if $redo = 0 then GUICtrlSetState ($draw6b, $GUI_DISABLE)
	        if GUICtrlRead($draweffect) <> "Effekt (optional)" then ControlClick ( $hidraw, "", $sde)
			if GUICtrlRead($draw7) = "Text" Then
				GUICtrlSetState($tfeld, $GUI_ENABLE)
			Else
				GUICtrlSetState($tfeld, $GUI_DISABLE)
			endif
			$a_font = GUICtrlRead($draw5)
			$draw4s = GUICtrlRead($draw4)
			GUICtrlSetFont($text9, GUICtrlRead($draw4), $bold, $text, $a_font)
			GUISetState (@SW_ENABLE , $drawhelpgui)
		EndIf
		$aOldPos[0] = $aPos[0]
        $aOldPos[1] = $aPos[1]
		$mMsg = GUIGetMsg(1)
		Switch $mMsg[0]
			case $radio1 to $radio46
				_reindi()
				GUICtrlSetData($tfeld, "")
				GUICtrlSetState($tfeld, $GUI_DISABLE)
				GUICtrlSetPos ( $tfeld, -260, $dyw+5)
				GUICtrlSetPos ( $text9, 174, $dyw+2)
				GUICtrlSetData($draw7, "Smiley")
			case $radio47, $radio48, $drawhelp
				if $mMsg[0] = $radio47 then _indi2()
				if $mMsg[0] = $radio48 then _indi()
				if $mMsg[0] = $drawhelp then GuiSetState(@sw_show, $drawhelpgui)
		        if $mMsg[0] = $drawhelp then $drawhelpclose = WinGetHandle ("[active]")
				GUICtrlSetData($tfeld, "")
				GUICtrlSetState($tfeld, $GUI_DISABLE)
				GUICtrlSetPos ( $tfeld, -260, $dyw+5)
				GUICtrlSetPos ( $text9, 174, $dyw+2)
				GUICtrlSetData($draw7, "Smiley")
			case $text9
				GUICtrlSetData($draw7, "Text")
				GUICtrlSetState($tfeld, $GUI_ENABLE)
				GUICtrlSetPos ( $tfeld, 174, $dyw+5)
				GUICtrlSetPos ( $text9, -260, $dyw+2)
			case $draw5
				$a_font = GUICtrlRead($draw5)
				GUICtrlSetFont($text9, GUICtrlRead($draw4), $bold, $text, GUICtrlRead($draw5))
			case $draw7
				if GUICtrlRead($draw7) = "Text" Then
					GUICtrlSetState($tfeld, $GUI_ENABLE)
					GUICtrlSetPos ( $tfeld, 174, $dyw+5)
				    GUICtrlSetPos ( $text9, -260, $dyw+2)
				Else
					GUICtrlSetData($tfeld, "")
					GUICtrlSetState($tfeld, $GUI_DISABLE)
					GUICtrlSetPos ( $tfeld, -260, $dyw+5)
			        GUICtrlSetPos ( $text9, 174, $dyw+2)
				endif
			case $text1
				if $text = 0 or $text = 2 or $text = 4 or $text = 6 or $text = 8 or $text = 10 or $text = 12 or $text = 14 Then
					$text += 1
					$bold = 800
					GUICtrlSetImage($text1, @TempDir & "\bold1.jpg")
				Else
					$text -= 1
					$bold = 400
					GUICtrlSetImage($text1, @TempDir & "\bold0.jpg")
				EndIf
				GUICtrlSetFont($text9, GUICtrlRead($draw4), $bold, $text, GUICtrlRead($draw5))
			case $text2
				if $text <> 2 and $text <> 3 and $text <> 6 and $text <> 7 and $text <> 10 and $text <> 11 and $text <> 14 and $text <> 15 Then
					$text += 2
					GUICtrlSetImage($text2, @TempDir & "\ital1.jpg")
				Else
					$text -= 2
					GUICtrlSetImage($text2, @TempDir & "\ital0.jpg")
				endif
				GUICtrlSetFont($text9, GUICtrlRead($draw4), 400, $text, GUICtrlRead($draw5))
			case $text3
				if $text <> 4 and $text <> 5 and $text <> 6 and $text <> 7 and $text < 12 Then
					$text += 4
					GUICtrlSetImage($text3, @TempDir & "\under1.jpg")
				Else
					$text -=4
					GUICtrlSetImage($text3, @TempDir & "\under0.jpg")
				endif
				GUICtrlSetFont($text9, GUICtrlRead($draw4), 400, $text, GUICtrlRead($draw5))
			case $text4
				if $text < 8 Then
					$text += 8
					GUICtrlSetImage($text4, @TempDir & "\strike1.jpg")
				Else
					$text -= 8
					GUICtrlSetImage($text4, @TempDir & "\strike0.jpg")
				endif
				GUICtrlSetFont($text9, GUICtrlRead($draw4), 400, $text, GUICtrlRead($draw5))
			case $text5
				if $fontalign = 0 Then
					$fontalign = 1
				    GUICtrlSetImage($text5, @TempDir & "\center1.jpg")
				elseif $fontalign = 1 Then
					$fontalign = 2
					GUICtrlSetImage($text5, @TempDir & "\right1.jpg")
				Else
					$fontalign = 0
				    GUICtrlSetImage($text5, @TempDir & "\left1.jpg")
				endif
			case $text8
				 if $dthg = 0 then
				     $dthg = 1
				     GUICtrlSetImage($text8, @TempDir & "\white1.jpg")
			     Else
				     $dthg = 0
				     GUICtrlSetImage($text8, @TempDir & "\trans1.jpg")
				 endif
			case $draweffect, $sde
				if GUICtrlRead($draweffect) <> "Effekt (optional)" then
				    For $i = $draw2 to $text9
		                GUICtrlSetState ($i, $GUI_DISABLE)
	                next
					$ieff = ""
					if GUICtrlRead($draweffect) = "H-Spiegel" then $ieff = "/hflip"
					if GUICtrlRead($draweffect) = "V-Spiegel" then $ieff = "/vflip"
					if GUICtrlRead($draweffect) = "Negativ" then $ieff = "/invert"
					if GUICtrlRead($draweffect) = "Graustufen" then $ieff = "/gray"
					if GUICtrlRead($draweffect) = "Blur 2" then $ieff = "/effect=(2,10,255)"
					if GUICtrlRead($draweffect) = "Oil Paint" then $ieff = "/effect=(4,150,0)"
					if GUICtrlRead($draweffect) = "Edge Detection" then $ieff = "/effect=(5,5,0)"
					if GUICtrlRead($draweffect) = "Explosion" then $ieff = "/effect=(7,15,0)"
					if GUICtrlRead($draweffect) = "Pixelize" then $ieff = "/effect=(8,10,0)"
					if GUICtrlRead($draweffect) = "Sepia" then $ieff = "/effect=(14,0,0)"
					if GUICtrlRead($draweffect) = "Raindrop" then $ieff = "/effect=(15,0,0)"
					if GUICtrlRead($draweffect) = "Fragment" then $ieff = "/effect=(18,12,0)"
					if GUICtrlRead($draweffect) = "Zoom Blur" then $ieff = "/effect=(23,120,0)"
					if GUICtrlRead($draweffect) = "Rock" then $ieff = "/effect=(24,4,0)"
					if GUICtrlRead($draweffect) = "Relief" then $ieff = "/effect=(25,0,0)"
					if GUICtrlRead($draweffect) = "Find Edges" then $ieff = "/effect=(26,2,0)"
					if GUICtrlRead($draweffect) = "Fish Eye" then $ieff = "/effect=(27,20,0)"
					if GUICtrlRead($draweffect) = "Noise" then $ieff = "/effect=(29,75,0)"
					if GUICtrlRead($draweffect) = "Snow" then $ieff = "/effect=(30,25,0)"
					if GUICtrlRead($draweffect) = "Circular Waves" then $ieff = "/effect=(31,15,0)"
					if GUICtrlRead($draweffect) = "Metallic" then $ieff = "/effect=(35,64,0)"
					if GUICtrlRead($draweffect) = "Metallic - Gold" then $ieff = "/effect=(36,64,0)"
					if GUICtrlRead($draweffect) = "Metallic - Ice" then $ieff = "/effect=(37,64,0)"
					GUISwitch($hidraw)
					$drawsec0 = GUICtrlCreatebutton($interface[73], 0, $dyw-70, $dxw, 70)
				    GUICtrlSetFont($drawsec0, 10, 800)
				    GUICtrlSetColor($drawsec0, 0xED1C24)
					$undo += 1
					$redo = 0
					GUICtrlSetData($draw6, "|<< "&$undo)
					GUICtrlSetData($draw6b, ">>|")
					Run (FileGetShortName(@TempDir) & "\i_view32.exe "&@TempDir & "\" &$undo-1&"09876draw.bmp "&$ieff&" /silent /convert=" & @TempDir & "\" &$undo&"09876draw.bmp", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
					processWaitClose ( "i_view32.exe" , 5)
                    If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
					GUICtrlDelete($drawsec0)
                    GUICtrlDelete($draw1)
				    $draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
				    For $i = $draw2 to $text9
		                GUICtrlSetState ($i, $GUI_ENABLE)
	                next
					GUICtrlSetState ($draw6b, $GUI_DISABLE)
	                GUICtrlSetData($draweffect, "Effekt (optional)")
				Endif
			case $draw6, $draw6a, $draw6b
				if $undo > 0 then
					if $mMsg[0] = $draw6 then
					    $undo -= 1
					    $redo += 1
				    elseif $mMsg[0] = $draw6a then
					    $redo += $undo
					    $undo = 0
					endif
 					GUICtrlSetData($draw6, "|<< "&$undo)
				endif
				if $redo > 0 then
					if $mMsg[0] = $draw6b then
						$redo -= 1
						$undo += 1
						GUICtrlSetData($draw6, "|<< "&$undo)
						GUICtrlSetState ($draw6, $GUI_ENABLE)
						GUICtrlSetState ($draw6a, $GUI_ENABLE)
					endif
					GUICtrlSetData($draw6b, ">>| "&$redo)
				    GUICtrlSetState ($draw6b, $GUI_ENABLE)
				endif
				if $undo = 0 then
					GUICtrlSetState ($draw6, $GUI_DISABLE)
					GUICtrlSetState ($draw6a, $GUI_DISABLE)
					GUICtrlSetData($draw6, "|<<")
				endif
				if $redo = 0 then
				    GUICtrlSetData($draw6b, ">>|")
				    GUICtrlSetState ($draw6b, $GUI_DISABLE)
				endif
				GUICtrlSetPos ( $tfeld, -260, $dyw+5)
				GUICtrlSetPos ( $text9, 174, $dyw+2)
				GUICtrlSetData($tfeld, "")
				GUISwitch($hidraw)
				GUICtrlDelete($draw1)
				$draw1 = GUICtrlCreatePic (@TempDir & "\" &$undo&"09876draw.bmp", 0, 0, $xo, $yo)
			case $draw2
				$i = 0
				if $yt > $fasty-200 then $xt = 0
				if $yt > $fasty-200 and msgbox(68,"LiveSnap",$interface[74]&$xo&" * "&$yo&$interface[75]) = 7 then
				    $i = -1
				endif
			case $GUI_EVENT_CLOSE
				if $mMsg[1] = $irfanclose Then
					_irf0()
				elseif $mMsg[1] = $drawhelpclose Then
					_drawhelp()
				else
					$i = -1
				endif
			case $draw3
				$cr = StringReplace($cr, "0xff", "0x")
				$crold = $cr
				$cr =  _ChooseColor(2, $cr, 2)
				if $cr = -1 then $cr = $crold
				GUICtrlSetBkColor($draw3, $cr)
				GUICtrlSetColor($text9, $cr)
				$cr = StringReplace($cr, "0x", "0xff")
				_GDIPlus_PenSetColor($hPen, $cr)
				_GDIPlus_PenSetColor($pPen, $cr)
				_GDIPlus_BrushSetSolidColor($kPen, $cr)
				if Stringlen (GUICtrlRead($tfeld)) = 0 then
		            GUICtrlSetPos ( $tfeld, -260, $dyw+5)
			        GUICtrlSetPos ( $text9, 174, $dyw+2)
				endif
		    case $draw4
				$draw4s = GUICtrlRead($draw4)
				GUICtrlSetFont($text9, GUICtrlRead($draw4), $bold, $text, GUICtrlRead($draw5))
		EndSwitch
		if $draw4s <> GUICtrlRead($draw4) or $a_font <> GUICtrlRead($draw5) then
		    GUICtrlSetPos ( $tfeld, -260, $dyw+5)
			GUICtrlSetPos ( $text9, 174, $dyw+2)
			$draw4s = GUICtrlRead($draw4)
			$a_font = GUICtrlRead($draw5)
			GUICtrlSetFont($text9, GUICtrlRead($draw4), $bold, $text, GUICtrlRead($draw5))
		endif
	until $i <= 0
	$cr = StringReplace($cr, "0xff", "0x")
	$draw4s = GUICtrlRead($draw4)
	$draw7s = GUICtrlRead($draw7)
	$a_font = GUICtrlRead($draw5)
	_GDIPlus_ArrowCapDispose ($hEndCap)
    _GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($pPen)
	_GDIPlus_BrushDispose($kPen)
	_GDIPlus_BrushDispose($blase)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	Opt("GUIOnEventMode", 1)
	Opt('MouseCoordMode', 1)
	if $i = 0 then
		GUISwitch($hidraw)
 		$drawsec0 = GUICtrlCreatebutton("upload...", 0, $dyw-70, $dxw, 70)
		GUICtrlSetFont($drawsec0, 10, 800)
		GUICtrlSetColor($drawsec0, 0xED1C24)
	    Run (FileGetShortName(@TempDir) & "\i_view32.exe "&@TempDir & "\" &$undo&"09876draw.bmp /silent /jpgq=100 /convert=" & $datei2 & " /info=" & FileGetShortName(@TempDir) & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		processWaitClose ("i_view32.exe" , 5)
		If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
	elseif $i = -1 then
		$vwsiz = "vlcfehler"
	    FileDelete($datei2)
		_exx()
	endif
	GUIDelete($hGUI)
endfunc

Func _Quit()
	if msgbox(68,"LiveSnap",$interface[22]) = 6 then Exit
EndFunc

func _picfile()
	$i = 0
	while not FileExists($datei2)
		sleep(20)
		$i += 1
		if $i > 150 then ExitLoop
	WEnd
endfunc

func _dlv()
	$vwsiz = "reset"
	repic($datei2)
	$xdraw = 0
	if $xdraw = 1 or $c14a = 1 then
        Run(FileGetShortName(@TempDir) & "\i_view32.exe " & $datei2 & " /silent /info=" & FileGetShortName(@TempDir) & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		If ProcessExists( "i_view32.exe") Then processWaitClose ( "i_view32.exe" , 5)
		If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
	endif
	$streamok1 = "pre"
	_rota()
	if $xdraw = 1 or $c14a = 1 then
		_plusinfo()
		if $c14a = 1 then _draw()
	endif
	If FileExists($datei2) Then _wmark($irfan)
endfunc

Func _snip()
	_tv($snip, "Desktop", $i, $streamok1);if GUICtrlRead($snip) = "Desktop" then
EndFunc

Func _shack()
	_tv($shack, $interface[9], $i, $streamok1)
EndFunc

Func _tv($tv1, $tv2, byref $i, Byref $streamok1)
	Switch GUICtrlRead($tv1)
		Case $tv2
			$ip = 0
			if $tv1 = $snip or $tv1 = $shack then
				if int(guictrlread($c23)) > 2500 then msgbox(16,$interface[18], $interface[79])
				if int(guictrlread($c23)) <= 2500 and $waiting = 0 Then GUICtrlSetData($tv1, "Cancel")
			Else
			    if $waiting = 0 Then GUICtrlSetData($tv1, "Cancel")
			endif
		Case else
			_exx()
			GUICtrlSetData($tv1, $tv2)
	EndSwitch
EndFunc

Func _tvi($tvi, $tvi2)
	GUICtrlSetState ($tvi, $GUI_ENABLE)
    _d2()
    If FileExists (@TempDir & "\curl.txt") Then
	    if GUICtrlRead($c81) <> 1 then _load($tvi)
		if GUICtrlRead($c81) = 1 then GUICtrlSetState ($c81, $GUI_UNCHECKED)
		_en()
            GUICtrlSetData($tvi, $tvi2)
        GUICtrlSetColor($c09, 0x008000);GUICtrlSetColor($c09,0x000000)
        GUICtrlSetData ($c09, $interface[29])
    else
        GUICtrlSetData($tvi, $tvi2)
        _lableer()
        _en()
    endif
Endfunc

func _exx()
	$schutz = 0
	$spontan = 0
	$datei4cnt = 0
	$waiting = 0
	$apt = 0
	$weck = 2
	$i = -1
	$ip = -1
	$streamok1 = 4711
	$streamok2 = 47110815
	GUICtrlSetData ($c08, "")
	repic(@TempDir & "\a2.jpg")
	FileDelete (@TempDir & "\curl.txt")
	GUICtrlSetData ($c09, $interface[86])
	_en()
endfunc

Func _curl($curl)
	$precurl = FileOpen(@TempDir & "\_curlrc", 2)
	if $opt3 = "imageshack.us" then
		$newcurl = "-F fileupload=@" & $curl & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--location-trusted" & @CRLF & "--url ""                         """
    elseif $opt3 = "abload.de" then
        $newcurl = "-F img0=@" & $curl & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""                               """
	elseif $opt3 = "imagebanana.com" then
		$newcurl = "-F upload[]=@" & $curl & @CRLF & "-F send=Hochladen!" & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--location-trusted" & @CRLF & "--url ""                           """
	elseif $opt3 = "pic-upload.de" then
	   $newcurl = "-F file=@" & $curl & @CRLF & "-F Submit= Bild Hochladen " & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""                                            """
    elseif $opt3 = "directupload.net" then
	   $newcurl = "-F bilddatei=@" & $curl & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""                                                 """
	elseif $opt3 = "img-teufel.de" then
	   $newcurl = "-F upload_image=@" & $curl & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""                                    """
	else
	   MsgBox(16, $interface[18], $interface[97])
	   Exit
	endif
    FileWrite($precurl, $newcurl)
    FileClose($precurl)
EndFunc

Func _wmark($wm4)
	$psiz = int(GUICtrlRead($c23))
	if $c14a = 1 and $xt = 0 then $psiz = 0
	if $psiz > 0 then Run(FileGetShortName(@TempDir) & "\i_view32.exe " &$datei2 &" /silent /resize=("& $wm4 &",0) /aspectratio /resample /convert=" & $datei2 & " /info=" & @TempDir & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		if $psiz <= 0 then Run(FileGetShortName(@TempDir) & "\i_view32.exe " &$datei2 & " /info=" & FileGetShortName(@TempDir) & "\test.txt", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		If ProcessExists("i_view32.exe") Then processWaitClose ("i_view32.exe" , 5)
		If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
	if $vwsiz <> "vlcfehler" Then repic($datei2)
EndFunc

Func _d2()
	$skb = (FileGetSize ($datei2) / 1024)
	if GUICtrlRead($c81) = 1 and StringRight ($datei2, 3) = "jpg" Then
	    FileCopy($datei2, @TempDir & "\irf0.jpg", 1)
		Run(FileGetShortName(@TempDir) & "\i_view32.exe " & @TempDir & "\irf0.jpg /silent /advancedbatch /sharpen="&GUICtrlRead($c71)&" /contrast="&GUICtrlRead($c73)&" /bright="&GUICtrlRead($c75)&" /gamma="&GUICtrlRead($c77)/100&" /resample /convert=" & @TempDir & "\irf1.jpg", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
	    processWaitClose ("i_view32.exe" , 5)
	    If ProcessExists( "i_view32.exe") Then ProcessClose ( "i_view32.exe")
		GUICtrlSetImage ($c79, @TempDir & "\irf0.jpg")
		GUICtrlSetImage ($c80, @TempDir & "\irf1.jpg")
	endif
	if StringRight ($datei2, 3) = "jpg" then;irfanquali
		if $irfil = 1 then Run(FileGetShortName(@TempDir) & "\i_view32.exe " & $datei2 & " /silent /advancedbatch /sharpen="&GUICtrlRead($c71)&" /contrast="&GUICtrlRead($c73)&" /bright="&GUICtrlRead($c75)&" /gamma="&GUICtrlRead($c77)/100&" /resample /convert=" & $datei2, FileGetShortName(@TempDir) & "\" , @SW_HIDE)
		if $irfil = 1 then processWaitClose ("i_view32.exe" , 5)
		If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
		if $irfil = 1 then repic($datei2);GUICtrlSetImage ($c21, $datei2)
	endif;irfanquali
	if GUICtrlRead($c81) = 1 then repic(@TempDir & "\a2.jpg");GUICtrlSetImage ($c21, @TempDir & "\a2.jpg")
	local $foo = Run(FileGetShortName(@TempDir) & "\curl.exe", FileGetShortName(@TempDir) & "\", @SW_HIDE, $STDERR_CHILD), $line
		While $ip = 0 and ProcessExists ("curl.exe")
			$line = StderrRead($foo)
         	$line = StringRegExp($line, '\d+', 3)
			if NOT @error then
				if $line[0] = 100 then $line[0] = 99
			    GUICtrlSetData ($c09, "uploading " & $line[0] & " %")
			endif
	        sleep(50)
			if $waiting = 0 then exitloop
        Wend
		Processclose ("curl.exe")
		GUICtrlSetData ($c09, "uploading 100 %")
	    if FileExists (@TempDir & "\curl.txt") = 0 Then FileInstall("dummy", @TempDir & "\curl.txt", 1)
EndFunc

func _load($ldi)
	$file = FileOpen(@TempDir & "\curl.txt", 0)
        $chars = FileRead($file)
        FileClose($file)
        _filter($datei2)
        if stringlen ($chars) > 100 then $chars = "Error"
		$show = $chars
		if $preurl = "[img]" then $show = StringTrimLeft ($chars, 5)
	    $chars = $chars & $posturl
		if stringinstr ($show, ".jpg") > 0 or stringinstr ($show, ".gif") > 0 and $show <> $orglink then
			GUICtrlSetColor($c08,0x000000)
			GUICtrlSetData ($c08, $show)
			if $opt2 = $interface[34] then _li($ldi, "", "   ", "", "", "")
            if $opt2 = "HTML" then _li($ldi, "<a href=""", """ target=_blank><img src=""", """></a>", "<img src=""", """>")
            if stringinstr($opt2, "[img]") > 0 then _li($ldi, "[URL=", "][IMG]", "[/IMG][/URL]", "[img]", "[/img]")
		endif
EndFunc

func _li($ldi, $li1, $li2, $li3, $li4, $li5)
    if stringinstr ($orglink, ".jpg") > 0 or stringinstr ($orglink, ".gif") > 0 then
		ClipPut($li1 & $orglink & $li2 & $show & $li3 & @CRLF)
	Else
		ClipPut($li4 & $show & $li5 & @CRLF)
	EndIf
endfunc

func _dis()
	$opt3 = GUICtrlRead($cl2)
	$opt2 = GUICtrlRead($c24)
	_irfan()
    _ini2()
	FileDelete ( @TempDir & "\curl.txt" )
	FileDelete (@TempDir & "\test.txt")
	FileDelete ( $datei2 )
	$4log = 0
	$waiting = 1
	$charslab = ""
	$x = ""
	$y = ""
    For $i = $snip to $c08
		GUICtrlSetState ($i, $GUI_DISABLE)
	next
	GUICtrlSetState ($c09, $GUI_ENABLE)
	if $sleepwake = 1 then GUICtrlSetState ($c08, $GUI_ENABLE)
	if $sleepwake = 0 then GUICtrlSetData ($c08, "")
    if $sleepwake = 0 then ClipPut ("")
    GUICtrlSetColor($c09,0xff0000)
    GUICtrlSetData ($c09, "preparing upload...")
	$orglink = ""
	GUISetState (@SW_DISABLE, $irfangui)
EndFunc

func _en()
	For $i = $snip to $c08
		GUICtrlSetState ($i, $GUI_ENABLE)
	next
	GUISetState (@SW_ENABLE, $irfangui)
	GUICtrlSetData ($c09, $interface[29])
EndFunc

func _ini2()
	_curl($datei2)
    if $opt2 = "[img]URL[/img]" or $opt2 = $interface[35] then $preurl = "[img]"
    if $opt2 = "[img]URL[/img]" then $posturl = "[/img]"
    if $opt2 = $interface[35] then $posturl = "[/img]" & @CRLF
endfunc

func _irfan()
	$irfan = ""
	$iy = 0
	if $size > 0 then $irfan = $size
    if $irfan <> "" then $iy = 1
	$siz1 = 0
	$siz2 = ""
	if int(guictrlread ($c23)) > 0 then $siz2 = guictrlread ($c23)
    if $siz2 <> "" then $siz1 = 1
EndFunc

func _filter($filter)
	if $opt3 = "imageshack.us" then
		$result = StringInStr($chars, "url_image_path"" value=""")
        $chars = StringTrimLeft($chars, $result + 22)
		$result = StringInStr($chars, """")
        $res2 = StringLen ($chars)
        $chars = StringTrimRight($chars, $res2 - $result + 1)
		$result = StringInStr($chars, "/")
        $res2 = StringLeft ($chars, $result -1)
        $chars = $preurl & "http://" & $res2 & ".imageshack.us/" & $chars
	elseif $opt3 = "abload.de" then
		$result = StringInStr($chars, "&quot;;}}")
	    $res2 = StringLen ($chars)
	    $chars = StringTrimRight($chars, $res2 - $result + 1)
		while StringInStr($chars, ":&quot;") > 0
			$res2 = StringInStr($chars, ":&quot;")
			$chars = StringTrimLeft($chars, $res2 + 6)
		wend
		$chars = $preurl & "                         " & $chars
	elseif $opt3 = "imagebanana.com" then
	    $result = StringInStr($chars, "][IMG]")
		$chars = StringTrimLeft($chars, $result + 5)
        $result = StringInStr($chars, "[")
		$res2 = StringLen ($chars)
        $chars = $preurl & StringReplace(StringTrimRight($chars, $res2 - $result + 1), "/thumb", "")
	elseif $opt3 = "pic-upload.de" then
	    $result = StringInStr($chars, "[IMG]")
        $chars = StringTrimLeft($chars, $result + 4)
        $result = StringInStr($chars, "[/IMG]")
		$res2 = StringLen ($chars)
		$chars = $preurl & StringTrimRight($chars, $res2 - $result + 1)
		$chars = StringReplace ($chars, "/thumb", "")
	elseif $opt3 = "directupload.net" then
	    $result = StringInStr($chars, "[URL=                           ][IMG]")
        $chars = StringTrimLeft($chars, $result + 37)
        $result = StringInStr($chars, "[/IMG]")
		$res2 = StringLen ($chars)
        $chars = $preurl & StringTrimRight($chars, $res2 - $result + 1)
	elseif $opt3 = "img-teufel.de" then
	    $result = StringInStr($chars, "[IMG]                                 ")
        $chars = StringTrimLeft($chars, $result + 4)
        $result = StringInStr($chars, "[/IMG]")
		$res2 = StringLen ($chars)
        $chars = $preurl & StringTrimRight($chars, $res2 - $result + 1)
	Else
		MsgBox(16, $interface[18], $interface[113])
	    Exit
	EndIf
endfunc

Func _lableer()
	GUICtrlSetColor($c09, 0x008000);GUICtrlSetColor($c09,0x000000)
    GUICtrlSetData ($c09, $interface[29])
    ClipPut ("")
    repic(@TempDir & "\a2.jpg")
	$time2 = ""
	$charslab = ""
EndFunc

Func IsVisible($handle)
	If BitAnd(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

func _plusinfo()
	$chars = FileRead(@TempDir & "\test.txt")
	$result = StringInStr($chars, "dimensions")
	$charslab = StringTrimleft ($chars, $result + 12)
	$result = StringInStr($charslab, "Pixels")
	$res2 = StringLen ($charslab)
	$charslab = StringTrimRight($charslab, $res2 - $result - 4)
	$x = Stringleft ($charslab, StringInStr($charslab, " ") -1)
    $y = Stringtrimleft ($charslab, StringInStr($charslab, " x") +2)
 	$y = Stringleft ($y, StringInStr($y, "  Pixel")-1)
	if $streamok1 = "pre" then
		$streamok1 = StringTrimLeft($chars, StringInStr($chars, "number"))
	    $streamok1 = StringLeft ($streamok1, StringInStr($streamok1, "current"))
		$xo = $x
		$yo = $y
	endif
	$charslab = ""
EndFunc

func _irfanslide($irf1, $irf2, $irf3)
	GUICtrlSetData($irf1, $irf2 & GUICtrlRead($irf1+1) / $irf3)
endfunc
func _irf00()
	GuiSetState(@sw_show, $irfangui)
	$irfanclose = WinGetHandle ("[active]")
endfunc
func _irf0()
	GuiSetState(@sw_hide, $irfangui)
endfunc
func _irf1()
	_irf2()
	_irfprev()
endfunc

func _irf2()
	_irfanslide($c70, $interface[122], 1)
	_irfanslide($c72, $interface[123], 1)
	_irfanslide($c74, $interface[124], 1)
	_irfanslide($c76, "Gamma: ", 100)
	_irfanslide($c87, $interface[126], 1)
	_irfanslide($c89, $interface[127], 1)
	_irfanslide($c91, $interface[128], 1)
	_irfanslide($c93, $interface[129], 1)
endfunc

func _irf5()
	GUICtrlSetData($c71, 1)
	GUICtrlSetData($c73, 0)
	GUICtrlSetData($c75, 0)
	GUICtrlSetData($c77, 100)
	GUICtrlSetData($c88, 0)
	GUICtrlSetData($c90, 0)
	GUICtrlSetData($c92, 0)
	GUICtrlSetData($c94, 0)
	_irf2()
	$irfil = 0
	FileInstall("irf0.jpg", @TempDir & "\irf0.jpg", 1)
	FileInstall("i_view32.ini", @TempDir & "\i_view32.ini", 1)
	GUICtrlSetImage ($c79, @TempDir & "\irf0.jpg")
	GUICtrlSetImage ($c80, @TempDir & "\irf0.jpg")
endfunc

func _irf6()
	MsgBox(64, $interface[130], $interface[131] & @CRLF & @CRLF & $interface[132] & @CRLF & @CRLF & $interface[133])
endfunc

func _irf8()
	$irfanbatch = FileOpen(@TempDir & "\i_view32.ini", 2)
    FileWriteLine($irfanbatch,"[Batch]")
    FileWriteLine($irfanbatch,"AdvSaturationVal="&guictrlread ($c88))
	FileWriteLine($irfanbatch,"AdvColRVal="&guictrlread ($c90))
	FileWriteLine($irfanbatch,"AdvColGVal="&guictrlread ($c92))
	FileWriteLine($irfanbatch,"AdvColBVal="&guictrlread ($c94))
	if guictrlread ($c88) <> 0 then
	    FileWriteLine($irfanbatch,"AdvSaturation=1")
	else
		FileWriteLine($irfanbatch,"AdvSaturation=0")
	endif
	if guictrlread ($c90) <> 0 then
	    FileWriteLine($irfanbatch,"AdvColR=1")
	else
		FileWriteLine($irfanbatch,"AdvColR=0")
	endif
	if guictrlread ($c92) <> 0 then
	    FileWriteLine($irfanbatch,"AdvColG=1")
	else
		FileWriteLine($irfanbatch,"AdvColG=0")
	endif
	if guictrlread ($c94) <> 0 then
	    FileWriteLine($irfanbatch,"AdvColB=1")
	else
		FileWriteLine($irfanbatch,"AdvColB=0")
	endif
	FileClose($irfanbatch)
	_irf1()
EndFunc

func _irfprev()
	$irfil = 0
	if GUICtrlRead($c71) > 1 or GUICtrlRead($c73) <> 0 or GUICtrlRead($c75) <> 0 or GUICtrlRead($c77)/100 <> 1  or GUICtrlRead($c88) <> 0 or GUICtrlRead($c90) <> 0 or GUICtrlRead($c92) <> 0 or GUICtrlRead($c94) <> 0 then $irfil = 1
	FileDelete (@TempDir & "\irf1.jpg")
	Run(FileGetShortName(@TempDir) & "\i_view32.exe " & @TempDir & "\irf0.jpg /silent /advancedbatch /sharpen="&GUICtrlRead($c71)&" /contrast="&GUICtrlRead($c73)&" /bright="&GUICtrlRead($c75)&" /gamma="&GUICtrlRead($c77)/100&" /resample /convert=" & @TempDir & "\irf1.jpg", FileGetShortName(@TempDir) & "\" , @SW_HIDE)
	processWaitClose ("i_view32.exe" , 5)
	If ProcessExists("i_view32.exe") Then ProcessClose ("i_view32.exe")
	GUICtrlSetImage ($c80, @TempDir & "\irf1.jpg")
EndFunc

Func _directurl()
	if StringInStr (guictrlread($c08), "http://") > 0 Then
		$show = guictrlread($c08);
		$opt2 = GUICtrlRead($c24)
		if $opt2 = $interface[34] then _li($ldi, "", "   ", "", "", "")
		if $opt2 = "HTML" then _li($ldi, "<a href=""", """ target=_blank><img src=""", """></a>", "<img src=""", """>")
		if stringinstr($opt2, "[img]") > 0 then _li($ldi, "[URL=", "][IMG]", "[/IMG][/URL]", "[img]", "[/img]")
	    ;clipput($show)
	    GUICtrlSetBkColor ($c08, 0xC8E6F7)
	    GUICtrlSetData($c08, $interface[137])
	    sleep(400)
	    GUICtrlSetbkColor($c08,0xe0e0e0)
	    GUICtrlSetData($c08, $show)
	endif
EndFunc

func _area($a1, $a2, byref $a3, byref $a4, byref $a5, byref $a6)
	$var = WinList()
	For $i = 1 to $var[0][0]
		If $var[$i][0] <> "" AND $var[$i][0] <> "start" AND IsVisible($var[$i][1]) Then WinSetState ($var[$i][0], "", @SW_DISABLE  )
	Next
    $GUI_2 = GUICreate("", 1, 1, -1, -1, 0x80000000 + 0x00800000, 0x00000008)
    GUISetBkColor(0x0c6eec)
    WinSetTrans($GUI_2, "", 130)
    local $s_left = "", $s_top = "", $s_width = "", $s_height = "", $mgp[2]
    $i = _Timer_Init()
    Local $hGUI = GUICreate("", $fastx+50, $fasty+50, -15, -25, -1, 0x00000080)
    GUISetBkColor(0xffffff)
    WinSetTrans($hGUI, "", 40)
    WinSetOnTop($hGUI, "", 1)
    GUISetCursor(3)
	GUISetState(@SW_SHOW, $hGUI)
	While Not _IsPressed(01)
	    if _Timer_Diff($i) > 400 then GUICtrlSetData($a1, $a2)
	    if _Timer_Diff($i) > 800 then
		    $i = _Timer_Init()
		    GUICtrlSetData($a1, "")
	    endif
	    $mgp = MouseGetPos()
	    Sleep(50)
    WEnd
    GUICtrlSetData($a1, $a2)
    WinMove($GUI_2, "", $mgp[0], $mgp[1], 1, 1)
    GUISetState(@SW_SHOW, $GUI_2)
    While _IsPressed(01)
	    $mgp_2 = MouseGetPos()
        If $mgp_2[0] > $mgp[0] And $mgp_2[1] > $mgp[1] Then
		    local $s_left = $mgp[0], $s_top = $mgp[1], $s_width = $mgp_2[0] - $mgp[0], $s_height = $mgp_2[1] - $mgp[1]
		ElseIf $mgp_2[0] > $mgp[0] And $mgp_2[1] < $mgp[1] Then
		    Local $s_left = $mgp[0], $s_top = $mgp_2[1], $s_width = $mgp_2[0] - $mgp[0], $s_height = $mgp[1] - $mgp_2[1]
		ElseIf $mgp_2[0] < $mgp[0] And $mgp_2[1] > $mgp[1] Then
		    Local $s_left = $mgp_2[0], $s_top = $mgp[1], $s_width = $mgp[0] - $mgp_2[0], $s_height = $mgp_2[1] - $mgp[1]
		ElseIf $mgp_2[0] < $mgp[0] And $mgp_2[1] < $mgp[1] Then
		    Local $s_left = $mgp_2[0], $s_top = $mgp_2[1], $s_width = $mgp[0] - $mgp_2[0], $s_height = $mgp[1] - $mgp_2[1]
		EndIf
	    WinMove($GUI_2, "", $s_left, $s_top, $s_width, $s_height)
	    if $streamint = 0 then WinSetOnTop($hGUI, "", 1)
	    ToolTip($s_width & "x" & $s_height)
	    sleep(50)
    WEnd
	ToolTip("")
    GLOBAL $s_left = $s_left, $s_top = $s_top, $s_width = $s_width, $s_height = $s_height
    GUIDelete($hGUI)
    $var = WinList()
	For $i = 1 to $var[0][0]
	    If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then WinSetState ($var[$i][0], "", @SW_ENABLE  )
	Next
endfunc