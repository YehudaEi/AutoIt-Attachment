#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <INet.au3>
#include <ComboConstants.au3>
#include <Constants.au3>
#include <Timers.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#Include <Misc.au3>
#include <unixtime.au3>
#include <IE.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
global $text, $services, $ii, $array2[2], $count2, $chars, $pm, $oVLC, $oPlaylist, $oAudio, $vp, $user_stop = True, $cbtn, $seplist, $clh, $vlc1, $Event_Now_Name, $ig
global $oVLC, $Event_Now_Extended_Description, $epgmsg, $hardware, $nch, $unixstop, $Event_Now_Begin, $ip, $pid, $c16, $epguser = 0, $audio = 1, $CurrentService, $loopzap = 0
if $CmdLine[0] = 3 and ProcessExists($CmdLine[1]) then
	if $CmdLine[3] = 1 then
		$seplist = GuiCreate("VLC Debug Konsole", 409, 230, -1, -1, -1, BitOR(0x00000080, 0x00000100))
        GUISetOnEvent($GUI_EVENT_CLOSE, "_closelist")
        $c16 = GuiCtrlCreateEdit("", 0, 0, 409, 208, $ES_WANTRETURN+$WS_VSCROLL+$WS_HSCROLL+$ES_AUTOVSCROLL+$ES_MULTILINE)
		GUICtrlSetBkColor (-1,0xFDFBB7)
        $clh = GuiCtrlCreatebutton("Clear", 367, 210, 40, 20, $GUI_SS_DEFAULT_BUTTON)
        GUICtrlSetOnEvent($clh, "_historyclear")
	    $gui = GUICreate("LAN.TV", 512, 385)
	    $cinfo = GUICtrlCreateLabel("", 2, 365, 460, 15)
		$cbtn = GUICtrlCreateButton("Konsole", 465, 365, 45, 18)
		GUICtrlSetOnEvent(-1, "_seplist")
	Else
		ProcessClose($CmdLine[1])
		$gui = GUICreate("LAN.TV", 512, 363)
	endif
else
	exit msgbox(16, "Fehler", "Parameter!")
Endif
Func _seplist()
	GuiSetState(@sw_show, $seplist)
	GUICtrlSetOnEvent($cbtn, "_closelist")
endfunc
Func _closelist()
	GuiSetState(@sw_hide, $seplist)
	GUICtrlSetOnEvent($cbtn, "_seplist")
endfunc
func _historyclear()
	if StringLen(GUICtrlRead($c16)) > 0 and msgbox(68,"VLC Debug Konsole","Konsole leeren?") = 6 then
		IniWrite(@AppDataDir & "\vlc"&$CmdLine[1]&".ini", "receiver", "console", "")
	    GUICtrlSetData($c16, "")
		GUICtrlSetData($cinfo, "")
	endif
endfunc
;==> Create VLC Object
global $left = -3, $top = -4, $width = 518, $height = 297
global Const $html = _
	"<style type=""text/css"">html, body, vlc {margin: 0px; padding: 0px; overflow: hidden;}</style>" & @CRLF & _
	"<object classid=""clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921""" & @CRLF & _
	"codebase=""http://downloads.videolan.org/pub/videolan/vlc/latest/win32/axvlc.cab""" & @CRLF & _
	"width=""" & $width & """ height=""" & $height & """" & @CRLF & _
	"id=""vlc"" events=""True"">" & @CRLF & _
	"</object>"
$oIE = _IECreateEmbedded ()
$oIEActiveX = GUICtrlCreateObj($oIE, $left, $top, $width, $height-4)
_IENavigate($oIE, "about:blank")
_IEDocWriteHTML($oIE, $html)
$vlc1 = _IEGetObjByName($oIE, "vlc")
if stringlen($vlc1.versionInfo()) < 5 Then
	GUICtrlDelete($oIEActiveX)
	_IEQuit($oIE)
	exit msgbox(16, "Fehler", "Einbetten fehlgeschlagen, bitte VLC Installation prüfen!")
EndIf
;<== Create VLC Object
FileInstall("tv-epg.jpg", @TempDir & "\tv-epg.jpg", 1)
FileInstall("tv-rezap.jpg", @TempDir & "\tv-rezap.jpg", 1)
FileInstall("tv-play.jpg", @TempDir & "\tv-play.jpg", 1)
FileInstall("tv-stop.jpg", @TempDir & "\tv-stop.jpg", 1)
FileInstall("tv-mute1.jpg", @TempDir & "\tv-mute1.jpg", 1)
FileInstall("tv-mute0.jpg", @TempDir & "\tv-mute0.jpg", 1)
$bouquets = GUICtrlCreateCombo("Senderlisten", 287, 291, 220, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
GUICtrlSetOnEvent(-1, "_bouquet")
$services = GUICtrlCreateCombo("Sender", 287, 316, 220, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
$eb = GUICtrlCreatepic (@TempDir & "\tv-epg.jpg", 4, 340, 33, 20)
GUICtrlSetOnEvent(-1, "_epg")
GUICtrlSetTip(-1, "EPG der aktuellen Sendung")
$rezap = GUICtrlCreatePic (@TempDir & "\tv-rezap.jpg", 48, 340, 21, 20)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "_zap")
GUICtrlSetTip(-1, "Rezap (falls kein Bild, weil auf dem Receiver gezappt wurde)")
$play = GUICtrlCreatePic (@TempDir & "\tv-play.jpg", 80, 340, 21, 20)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "_play")
GUICtrlSetTip(-1, "Play")
$stop = GUICtrlCreatepic (@TempDir & "\tv-stop.jpg", 112, 340, 21, 20)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "_stop")
GUICtrlSetTip(-1, "Stop")
$mute = GUICtrlCreatePic (@TempDir & "\tv-mute1.jpg", 144, 340, 21, 20)
GUICtrlSetOnEvent(-1, "_mute")
GUICtrlSetTip(-1, "Mute")
$vlp = GUICtrlCreateLabel("10 %", 168, 343, 30, 16, $SS_RIGHT)
GUICtrlSetColor(-1,0x727272)
$volume = GUICtrlCreateSlider(201, 340, 308, 20)
GUICtrlSetLimit(-1, 200, 0)
GUICtrlSetData(-1, 10)
GUICtrlSetOnEvent(-1, "_volume")
GUICtrlSetTip(-1, "Volume")
DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'int', 0) ; Classic-Style
$pm = GUICtrlCreateProgress(4, 291, 280, 12, $PBS_SMOOTH)
GUICtrlSetColor(-1, 0x309eee); not working with Windows XP Style
GUICtrlSetbkColor(-1,0xaeb5be)
DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'int', 7) ; Standard-Windows-Style
$a1 = GUICtrlCreateLabel("", 4, 305, 225, 15)
$a2 = GUICtrlCreateLabel("", 233, 305, 50, 15, $SS_RIGHT)
$b1 = GUICtrlCreateLabel("", 4, 323, 225, 15)
$b2 = GUICtrlCreateLabel("", 233, 323, 50, 15, $SS_RIGHT)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
$ip = $CmdLine[2]
Opt("GuiOnEventMode", 1)
SplashTextOn("LAN.TV.Setup", "Receiver-Check: "&$ip&@CRLF& "bitte warten...", 300, 80, -1, -1, 18)
if StringInStr (_INetGetSource ( "http://"&$ip&"/video.m3u" ), $ip) then
	WinSetTitle($gui, "", $ip)
	$text = _INetGetSource ( "http://"&$ip&"/cgi-bin/getServices?ref=4097:7:0:6:0:0:0:0:0:0:" )
	$text = StringReplace($text, "4097", @CRLF&";4097")
	$array1 = _StringExplode($text, ";", 0)
	$message = ""
	$count = _ArrayUnique($array1)
	for $i = 0 to $count[0]-1
		if StringLeft($array1[$i], 4) = "4097" then $message &= $array1[$i+1]&"|"
	next
	$message = StringToBinary($message)
	$message = BinaryToString($message, 4)
    GUICtrlSetData($bouquets, $message, "Senderlisten")
	GUISetState()
	$hardware = "enigma1"
elseif StringInStr (_INetGetSource ( "http://"&$ip&"/web/getpid" ), $ip) then
	WinSetTitle($gui, "", $ip)
	$text = StringReplace(_INetGetSource ( "http://"&$ip&"/web/getservices" ), "<e2", @CRLF&"<e2")
	$text = StringReplace($text, "</e2servicereference>", "")
	$text = StringReplace($text, "</e2servicename>", "")
	$text = StringReplace($text, "</e2service>", "")
	$text = StringReplace($text, "<e2service>", "")
	$text = StringReplace($text, "</e2servicelist>", "")
	$text = StringTrimLeft($text, StringInStr($text, "<e2servicereference>")-1)
	$text = StringReplace($text, @CRLF, "")
	$array1 = _StringExplode($text, "<e2servicereference>", 0)
	$message = ""
	$count = _ArrayUnique($array1)
	for $i = 0 to $count[0]-1
		if StringLen($array1[$i]) > 5 then $message &= StringTrimLeft($array1[$i],StringInStr($array1[$i],"<e2servicename>")+14)&"|"
	next
	$message = StringToBinary($message)
	$message = BinaryToString($message, 4)
	$message = StringReplace($message, "&lt;", "<")
	$message = StringReplace($message, "&gt;", ">")
	GUICtrlSetData($bouquets, $message, "Senderlisten")
	GUISetState()
	$hardware = "enigma2"
ElseIf StringInStr (_INetGetSource ( "http://"&$ip&"/control/exec?Y_Live&url" ), $ip) then ;then / "192") then
	WinSetTitle($gui, "", $ip)
	$text = _INetGetSource ( "http://"&$ip&"/control/getbouquets" )
	$array1 = _StringExplode($text, @LF, 0)
	$message = ""
	$count = _ArrayUnique($array1)
	for $i = 0 to $count[0]-1
		if StringLen($array1[$i]) > 5 then $message &= StringTrimLeft($array1[$i],StringInStr($array1[$i]," "))&"|"
	next
	GUICtrlSetData($bouquets, $message, "Senderlisten")
	GUISetState()
	$hardware = "neutrino"
	If StringInStr (_INetGetSource ( "http://"&$ip&"/control/getmode" ), "tv") = 0 then _INetGetSource ( "http://"&$ip&"/control/setmode?tv")
Else
	SplashOff()
	exit MsgBox(16, "Info", "Connect zum Receiver fehlgeschlagen.")
endif
$ii = 1
while stringlen(IniRead ( @AppDataDir & "\andygoreceiver.ini", "receiver", $ii, "" )) > 0
	if IniRead ( @AppDataDir & "\andygoreceiver.ini", "receiver", $ii, "" ) = $ip then
		exitloop
	else
		$ii += 1
	endif
wend
iniwrite(@AppDataDir & "\andygoreceiver.ini", "receiver", $ii,  $ip)
SplashOff()
$t = _Timer_Init()
$vd = 10
;==> VLC Debug Data
if $CmdLine[3] = 1 then _Timer_SetTimer($gui,100,"addup")
func addup($a, $b, $c, $d)
	$tmp = IniRead ( @AppDataDir & "\vlc"&$CmdLine[1]&".ini", "receiver", "console", "" )
	if GUICtrlRead($cinfo) <> $tmp then
	    GUICtrlSetData ($cinfo, $tmp)
		_GUICtrlEdit_AppendText($c16, @CRLF & $tmp)
	endif
endfunc
;<== VLC Debug Data
while 1
	sleep(20)
	if _Timer_Diff($t) > 15000 and $epguser = 2 then _epgupd($hardware); EPG Abfrage alle x.000 Sekunden
	while _IsPressed(01)
		if $vd <> GUICtrlRead($volume) then
		    _volume()
		    $vd = GUICtrlRead($volume)
		    GUICtrlSetData($vlp, $vd & " %")
		endif
		sleep(10)
	wend
wend
func _epgupd($hwtype)
	$t = _Timer_Init()
	$ii = 0
	if $user_stop = False then
		Opt("GUIOnEventMode", 0)
	    FileDelete(@TempDir & "\"&$ip&".txt")
		if $hwtype = "enigma1" then
			sleep(2000)
			$ig = InetGet ( "http://"&$ip&"/cgi-bin/channelinfo" ,@TempDir & "\"&$ip&".txt", 1, 1 )
		elseif $hwtype = "enigma2" then
			$ig = InetGet ( "http://"&$ip&"/web/updates.html" ,@TempDir & "\"&$ip&".txt", 1, 1 )
		elseif $hwtype = "neutrino" Then
			$ig = InetGet ( "http://"&$ip&"/control/epg?xml=true&details=true&channelid="&$nch ,@TempDir & "\"&$ip&".txt", 1, 1 )
		endif
		While InetGetInfo($ig, 0) < 1024
			$ii += 1
	        sleep(20)
			if $ii > 900 then ExitLoop
		wend
		InetClose($ig)
		Opt("GUIOnEventMode", 1)
		if $hwtype = "enigma1" then
		    $file = FileOpen ( @TempDir & "\"&$ip&".txt", 128 )
		elseif $hwtype = "enigma2" then
		    $file = FileOpen ( @TempDir & "\"&$ip&".txt", 128 )
		elseif $hwtype = "neutrino" Then
			$file = FileOpen ( @TempDir & "\"&$ip&".txt", 0 )
		endif
	    $chars = FileRead($file)
	    FileClose($file)
		if $hwtype = "enigma1" then
		    $chars = StringReplace($chars, "<", @CRLF&"<")
		    $CurrentTime = @HOUR&":"&@MIN
		    $CurrentService = GUICtrlRead($services)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "class=""time"">")+12)
		    $Event_Now_Begin = StringLeft($chars, 5)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "<td>(")+4)
		    $duration = int(StringLeft($chars, StringInStr($chars, ")")-1))
		    $chars = StringTrimLeft($chars, StringInStr($chars, "class=""event"">")+13)
		    $Event_Now_Name = StringLeft($chars, StringInStr($chars, "</span>")-1)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "class=""description"">")+19)
		    $Event_Now_Extended_Description = StringLeft($chars, StringInStr($chars, "</span>")-1)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "class=""time"">")+12)
		    $Event_Next_Begin = StringLeft($chars, 5)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "<td>(")+4)
		    $Event_Next_Remaining = int(StringLeft($chars, StringInStr($chars, ")")-1))
		    $chars = StringTrimLeft($chars, StringInStr($chars, "class=""event"">")+13)
		    $Event_Next_Name = StringLeft($chars, StringInStr($chars, "</span>")-1)
            if int(StringLeft($Event_Next_Begin,2)) > int(StringLeft($CurrentTime,2)) then
	            $Event_Now_Remaining = 60 * (int(StringLeft($Event_Next_Begin,2)) - int(StringLeft($CurrentTime,2)))
		        $Event_Now_Remaining -= int(Stringright($CurrentTime,2))
		        $Event_Now_Remaining += int(Stringright($Event_Next_Begin,2))
	        elseif int(StringLeft($Event_Next_Begin,2)) = int(StringLeft($CurrentTime,2)) then
		        $Event_Now_Remaining = int(Stringright($Event_Next_Begin,2)) - int(Stringright($CurrentTime,2))
	        else
 		        $Event_Now_Remaining = 60 * (24 - int(StringLeft($CurrentTime,2)))
		        $Event_Now_Remaining -= int(Stringright($CurrentTime,2))
			    $Event_Now_Remaining += int(StringLeft($Event_Next_Begin,2)) * 60
		        $Event_Now_Remaining += int(Stringright($Event_Next_Begin,2))
	        endif
	    elseif $hwtype = "enigma2" then
	        $chars = StringLeft($chars,StringInStr($chars, "Event_Next_Extended_Description")-30)
		    $chars = StringReplace($chars, "û", "ß")
	        $chars = StringReplace($chars, "<script>parent.set(""", "")
	        $CurrentTime = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $CurrentService = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $Event_Now_Name = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $Event_Now_Extended_Description = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """);</script>")-StringInStr($chars, """, """)-4)
	        $Event_Now_Extended_Description = StringReplace($Event_Now_Extended_Description, "\""", """")
	        $Event_Now_Extended_Description = StringReplace($Event_Now_Extended_Description, "\n", @CRLF)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $Event_Now_Begin = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $Event_Now_Remaining = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $Event_Next_Name = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $Event_Next_Begin = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
	        $chars = StringTrimLeft($chars, StringInStr($chars, "</script>")+8)
	        $Event_Next_Remaining = StringMid($chars, StringInStr($chars, """, """)+4, StringInStr($chars, """)")-StringInStr($chars, """, """)-4)
		    if int(StringLeft($Event_Next_Begin,2)) > int(StringLeft($Event_Now_Begin,2)) then
	            $duration = 60 * (int(StringLeft($Event_Next_Begin,2)) - int(StringLeft($Event_Now_Begin,2)))
		        $duration -= int(Stringright($Event_Now_Begin,2))
		        $duration += int(Stringright($Event_Next_Begin,2))
	        elseif int(StringLeft($Event_Next_Begin,2)) = int(StringLeft($Event_Now_Begin,2)) then
		        $duration = int(Stringright($Event_Next_Begin,2)) - int(Stringright($Event_Now_Begin,2))
	        else
 		        $duration = 60 * (24 - int(StringLeft($Event_Now_Begin,2)))
		        $duration -= int(Stringright($Event_Now_Begin,2))
			    $duration += int(StringLeft($Event_Next_Begin,2)) * 60
		        $duration += int(Stringright($Event_Next_Begin,2))
	        endif
        elseif $hwtype = "neutrino" Then
		    $CurrentTime = _INetGetSource("http://"&$ip&"/control/gettime")
		    $CurrentDate = _INetGetSource("http://"&$ip&"/control/getdate")
		    $unixcurrent = _TimeMakeStamp(StringRight($CurrentTime, 2), StringMid($CurrentTime, 4, 2), StringLeft($CurrentTime, 2), StringLeft($CurrentDate, 2), StringMid($CurrentDate, 4, 2), StringRight($CurrentDate, 4))
		    $CurrentService = StringMid($chars, StringInStr($chars, "<channel_name><![CDATA[")+23, StringInStr($chars, "]]></channel_name>")-StringInStr($chars, "<channel_name><![CDATA[")-23)
		    $unixstop = 0
            while $unixstop < $unixcurrent
    		    $chars = StringTrimLeft($chars, StringInStr($chars, "<start_t>")+8)
	            $Event_Now_Begin = StringLeft($chars, 5)
		        $chars = StringTrimLeft($chars, StringInStr($chars, "<stop_sec>")+9)
		        $unixstop = int(StringLeft($chars, StringInStr($chars, "</stop_sec>")-1))
			    if StringLen($unixstop) < 10 then
				    GUICtrlSetData ($a1, "                            Lade EPG-Daten...")
			        exitloop
			    endif
		    wend
            $Event_Now_Remaining = int(($unixstop - $unixcurrent)/60)
            $chars = StringTrimLeft($chars, StringInStr($chars, "<duration_min>")+13)
		    $duration = int(StringLeft($chars, StringInStr($chars, "</duration_min>")-1))
		    $chars = StringTrimLeft($chars, StringInStr($chars, "<description><![CDATA[")+21)
		    $Event_Now_Name = StringLeft($chars, StringInStr($chars, "]]></description>")-1)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "<info2><![CDATA[")+15)
            $Event_Now_Extended_Description = StringLeft($chars, StringInStr($chars, "]]></info2>")-1)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "<start_t>")+8)
		    $Event_Next_Begin = StringLeft($chars, 5)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "<duration_min>")+13)
		    $Event_Next_Remaining = StringLeft($chars, StringInStr($chars, "</duration_min>")-1)
		    $chars = StringTrimLeft($chars, StringInStr($chars, "<description><![CDATA[")+21)
		    $Event_Next_Name = StringLeft($chars, StringInStr($chars, "]]></description>")-1)
	    endif
		$t = _Timer_Init()
	endif
	if $ii > 900 then
		GUICtrlSetData($a1, "")
		GUICtrlSetData($a2, "")
		GUICtrlSetData($b1, "")
		GUICtrlSetData($b2, "")
		GUICtrlSetData($epgmsg, "")
		GUICtrlSetData($pm, 0)
		GUICtrlSetData ($a1, "                            abgebrochen")
		sleep(350)
		GUICtrlSetData ($a1, "")
		$epguser = 1
	endif
	if $ii < 900 and $user_stop = False and StringInStr(GUICtrlRead ($services), $CurrentService) then;if not test
		if StringLen($Event_Now_Extended_Description) > StringLen($epgmsg) then $epgmsg = $Event_Now_Extended_Description
		if guictrlread($a1) <> $Event_Now_Begin&"   "&$Event_Now_Name then
		    GUICtrlSetData($a1, $Event_Now_Begin&"   "&$Event_Now_Name)
			$epgmsg = $Event_Now_Extended_Description
			$epguser = 2
		endif
		if $hwtype = "enigma1" and StringTrimLeft(guictrlread($a2),1) <> $Event_Now_Remaining then
			GUICtrlSetData($a2, "+"&$Event_Now_Remaining)
			GUICtrlSetData($pm, int($Event_Now_Remaining)/($duration/100))
		elseif $hwtype = "enigma2" and guictrlread($a2) <> $Event_Now_Remaining then
		    GUICtrlSetData($a2, $Event_Now_Remaining)
			GUICtrlSetData($pm, int($Event_Now_Remaining)/($duration/100))
		elseif $hwtype = "neutrino" and StringTrimLeft(guictrlread($a2),1) <> $Event_Now_Remaining then
		    GUICtrlSetData($a2, "+"&$Event_Now_Remaining)
			GUICtrlSetData($pm, int($Event_Now_Remaining)/($duration/100))
		endif
		if guictrlread($b1) <> $Event_Next_Begin&"   "&$Event_Next_Name then GUICtrlSetData($b1, $Event_Next_Begin&"   "&$Event_Next_Name)
		if guictrlread($b2) <> $Event_Next_Remaining then GUICtrlSetData($b2, $Event_Next_Remaining)
	Elseif $user_stop = True then
		GUICtrlSetData($a1, "")
		GUICtrlSetData($a2, "")
		GUICtrlSetData($b1, "")
		GUICtrlSetData($b2, "")
		$epguser = 0
		GUICtrlSetData($pm, 0)
		if StringInStr(GUICtrlRead ($services), $CurrentService) then _stop()
	endif
endfunc
func _quit()
	if msgbox(68,"Frage", "LAN.TV beenden?") = 6 then ProcessClose(@AutoItPID)
		;_stop()
		;$ii = 0
		;Exit
	;endif
endfunc
func _bouquet()
	ControlFocus ( $gui, "", $a1 )
	for $i = 0 to $count[0]-1
		GUISwitch($gui)
		GUICtrlDelete($services)
		if $hardware = "enigma1" then
			for $i = 0 to $count[0]-1
		        if GUICtrlRead($bouquets) = $array1[$i] then
				    $message = $array1[$i]
					ExitLoop
				endif
	        next
			$message = StringToBinary($message)
	        $message = BinaryToString($message, 4)
		elseif $hardware = "enigma2" then
		    $message = StringToBinary($array1[$i])
	        $message = BinaryToString($message, 4)
	        $message = StringReplace($message, "&lt;", "<")
	        $message = StringReplace($message, "&gt;", ">")
		elseif $hardware = "neutrino" then
			$message = $array1[$i]
		endif
	    if StringInStr($message, GUICtrlRead ($bouquets)) then
	        $services = GUICtrlCreateCombo("Sender", 287, 316, 220, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
			GUICtrlSetOnEvent(-1, "_zap")
			if $hardware = "enigma1" then
			    $text = _INetGetSource("http://"&$ip&"/cgi-bin/getServices?ref="&$array1[$i-1])
				$array2 = _StringExplode($text, @LF, 0)
			elseif $hardware = "enigma2" then
				$text = StringReplace(_INetGetSource ( "http://"&$ip&"/web/getservices?sRef="&Stringleft($array1[$i], StringInStr($array1[$i], "<e2servicename>")-1) ), "<e2", @CRLF&"<e2")
	            $text = StringReplace($text, "</e2servicereference>", "")
	            $text = StringReplace($text, "</e2servicename>", "")
	            $text = StringReplace($text, "</e2service>", "")
	            $text = StringReplace($text, "<e2service>", "")
	            $text = StringReplace($text, "</e2servicelist>", "")
	            $text = StringTrimLeft($text, StringInStr($text, "<e2servicereference>")-1)
			    $text = StringReplace($text, @CRLF, "")
	            $array2 = _StringExplode($text, "<e2servicereference>", 0)
		    elseif $hardware = "neutrino" then
			    $text = _INetGetSource ( "http://"&$ip&"/control/getbouquet?bouquet="&Stringleft($array1[$i], StringInStr($array1[$i], " ")-1) )
                $array2 = _StringExplode($text, @LF, 0)
			endif
	        $message = ""
	        $count2 = _ArrayUnique($array2)
			if $hardware = "enigma1" then
				for $ii = 0 to $count2[0]-1
		            if StringLen($array2[$ii]) > 5 then $message &= StringLeft(StringTrimLeft($array2[$ii],StringInStr($array2[$ii],";")), StringInStr(StringTrimLeft($array2[$ii],StringInStr($array2[$ii],";")),";")-1)&"|"
				next
				$message = StringToBinary($message)
	            $message = BinaryToString($message, 4)
			elseif $hardware = "enigma2" then
	            for $ii = 0 to $count2[0]-1
		            if StringLen($array2[$ii]) > 5 then $message &= StringTrimLeft($array2[$ii],StringInStr($array2[$ii],"<e2servicename>")+14)&"|"
			    next
			    $message = StringToBinary($message)
	            $message = BinaryToString($message, 4)
			    $message = StringReplace($message, "&lt;", "<")
	            $message = StringReplace($message, "&gt;", ">")
		    elseif $hardware = "neutrino" then
			    for $ii = 0 to $count2[0]-1
		            if StringLen($array2[$ii]) > 5 then $message &=  StringTrimLeft(StringTrimLeft($array2[$ii],StringInStr($array2[$ii], " ")),StringInStr(StringTrimLeft($array2[$ii],StringInStr($array2[$ii], " ")), " "))&"|"
			    next
			endif
	        GUICtrlSetData($services, $message, "Sender")
	        ExitLoop
		Else
			$services = GUICtrlCreateCombo("Sender", 287, 316, 220, 20, $CBS_DROPDOWNLIST+$WS_VSCROLL)
	    endif
	next
endfunc
func _zap()
	ControlFocus ( $gui, "", $a1 )
	_stop()
	GUICtrlSetState ($rezap, $GUI_DISABLE)
	GUICtrlSetState ($play, $GUI_DISABLE)
	for $ii = 0 to $count2[0]-1
		if $hardware = "enigma1" then
			$message = StringToBinary($array2[$ii])
	        $message = BinaryToString($message, 4)
			$message = StringTrimLeft($message, StringInStr($message, ";"))
			$message = Stringleft($message, StringInStr($message, ";"))
		elseif $hardware = "enigma2" then
		    $message = StringToBinary($array2[$ii])
	        $message = BinaryToString($message, 4)
	        $message = StringReplace($message, "&lt;", "<")
	        $message = StringReplace($message, "&gt;", ">")
	    elseif $hardware = "neutrino" then
		    $message = $array2[$ii]
		endif
		if StringInStr($message, GUICtrlRead ($services)) then
			if $hardware = "enigma1" then
				_INetGetSource ( "http://"&$ip&"/cgi-bin/zapTo?path="&Stringleft($array2[$ii], StringInStr($array2[$ii], ";")-1) )
			    sleep(2000);warten das die box umschalten kann
			    $vp = "";reset
	            $vp =_INetGetSource("http://"&$ip&"/video.m3u")
	            $ii = 0
	            while StringInStr($vp, "-")
		            $ii += 1
		            $vp =_INetGetSource("http://"&$ip&"/video.m3u")
		            sleep (1000)
		            if $ii > 6 then ExitLoop
			    wend
			elseif $hardware = "enigma2" then
			    _INetGetSource ( "http://"&$ip&"/web/zap?sRef="&Stringleft($array2[$ii], StringInStr($array2[$ii], "<e2servicename>")-1) )
			    sleep(2000);warten das die box umschalten kann
			    $vp = "";reset
	            $vp =_INetGetSource("http://"&$ip&"/web/getpid")
	            $ii = 0
	            while StringInStr($vp, "-")
		            $ii += 1
		            $vp =_INetGetSource("http://"&$ip&"/web/getpid")
		            sleep (1000)
		            if $ii > 6 then ExitLoop
			    wend
		    elseif $hardware = "neutrino" then
				$nch = StringLeft(StringTrimLeft($array2[$ii], StringInStr($array2[$ii], " ")),StringInStr( StringTrimLeft($array2[$ii], StringInStr($array2[$ii], " ")), " ")  )
			    _INetGetSource ( "http://"&$ip&"/control/zapto?"&$nch)
			    sleep(2000);warten das die box umschalten kann
			    $vp = "";reset
				$vp =StringTrimLeft(_INetGetSource("http://"&$ip&"/control/exec?Y_Live&url"), 4)
			endif
	        if StringInStr ($vp, $ip) = 0 then
				MsgBox(16, "Info", "Connect zum Receiver fehlgeschlagen.")
			Elseif $hardware = "enigma1" then
			    _play()
			Elseif $hardware = "enigma2" then
				$vp = StringTrimLeft($vp, 1)
				$vp = StringTrimright($vp, 1)
				$vp = StringReplace($vp, " ", "")
				_play()
			elseif $hardware = "neutrino" then
				_play()
			endif
            ExitLoop
	    endif
	next
endfunc
func _epg()
	if $epguser = 2 then
	    MsgBox(64, $CurrentService, $Event_Now_Name&@CRLF&@CRLF&$epgmsg)
	elseif $epguser = 1 then
		GUICtrlSetData ($a1, "                            Lade EPG-Daten...")
	    while _IsPressed(01)
			sleep(20)
		wend
		_epgupd($hardware)
	endif
endfunc
func _play()
	$vlc1.playlist.items.clear()
    $ii = 0
	While 1
		$ii += 1
		sleep(20)
		if $ii > 300 or $vlc1.playlist.items.count = 0 then ExitLoop
	WEnd
	GUICtrlSetData ($b1, "")
	$vlc1.playlist.playItem($vlc1.playlist.add($vp))
	GUICtrlSetState ($play, $GUI_DISABLE)
	GUICtrlSetState ($rezap, $GUI_ENABLE)
	GUICtrlSetState ($stop, $GUI_ENABLE)
	$ii = 0
	GUICtrlSetData ($a1, "                            Lade EPG-Daten...")
	While 1
		$ii += 1
		sleep(20)
		if $ii > 300 or $vlc1.input.state = 3 then ExitLoop
	WEnd
	$user_stop = False
	if $audio = 0 Then
		$vlc1.audio.volume = 0
	Else
		$vlc1.audio.volume = GUICtrlRead($volume)
	endif
	$epguser = 0
	_epgupd($hardware)
endfunc
func _stop()
	if $vlc1.playlist.items.count = 1 and $user_stop = False then
		$vlc1.playlist.stop()
		$ii = 0
		While 1
		    $ii += 1
		    sleep(20)
		    if $ii > 300 or $vlc1.input.state = 6 then ExitLoop
	    WEnd
	endif
	$user_stop = True
	$loopzap = 0
	GUICtrlSetState ($stop, $GUI_DISABLE)
	GUICtrlSetState ($play, $GUI_ENABLE)
	GUICtrlSetData($a1, "")
	GUICtrlSetData($a2, "")
	GUICtrlSetData($b1, "")
	GUICtrlSetData($b2, "")
	$epguser = 0
	GUICtrlSetData($pm, 0)
endfunc
func _mute()
	if $audio = 1 then
		if $vlc1.playlist.items.count = 1 and $user_stop = False then $vlc1.audio.volume = 0
		$audio = 0
		GUICtrlSetImage($mute, @TempDir & "\tv-mute0.jpg")
	elseif GUICtrlRead($volume) > 0 then
		if $vlc1.playlist.items.count > 0 and $user_stop = False then $vlc1.audio.volume = GUICtrlRead($volume)
		$audio = 1
		GUICtrlSetImage($mute, @TempDir & "\tv-mute1.jpg")
	endif
endfunc
func _volume()
	ControlFocus ( $gui, "", $a1 )
	if  $vlc1.playlist.items.count = 1 and $user_stop = False then $vlc1.audio.volume = GUICtrlRead($volume)
	if GUICtrlRead($volume) = 0 then
		$audio = 0
	    GUICtrlSetImage($mute, @TempDir & "\tv-mute0.jpg")
	Else
		$audio = 1
		GUICtrlSetImage($mute, @TempDir & "\tv-mute1.jpg")
	endif
	GUICtrlSetData($vlp, GUICtrlRead($volume)& " %")
endfunc
