#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <Process.au3>
#Include <Misc.au3>
#include <Constants.au3>
#include <GuiSlider.au3>
Opt("WinTitleMatchMode", 2)

$vorher = FileGetShortName(@TempDir) & "\09876org.jpg"
$nachher = FileGetShortName(@TempDir) & "\09876.jpg"
$typ = StringRight ( $vorher, 4 )
FileInstall("irf0.jpg", FileGetShortName(@TempDir) & "\irf0.jpg", 1)
FileInstall("i_view32.exe", FileGetShortName(@TempDir) & "\i_view32.exe", 1)
FileInstall("i_view32.ini", FileGetShortName(@TempDir) & "\i_view32.ini", 1)
DirCreate(FileGetShortName(@TempDir) & "\plugins")
FileInstall("Effects.dll", FileGetShortName(@TempDir) & "\plugins\Effects.dll", 1)
FileInstall("dummy", FileGetShortName(@TempDir) & "\_curlrc", 1)
FileInstall("curl.exe", FileGetShortName(@TempDir) & "\curl.exe", 1)

Opt ( "TrayIconHide", 1 )
Opt("GuiOnEventMode", 1)
Global $irfan, $gui2, $charslab, $preurl, $posturl, $datei5
Global $shack, $size, $precurl, $newcurl, $ig7, $ig8, $ig9, $ig10
Global $vorher, $skb, $file, $chars, $result, $res2, $show, $typ4, $irfanig, $ig5, $ig6, $irfil, $ig11, $ig12
Global $datei4pre, $datei4cnt, $4c1, $ig1, $ig2, $ig3, $ig4, $GUI_2

$maingui = GUICreate("pic2web 6.22 by andygo", 280, 575)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUISetBkColor(0xC8E6F7)
GuiCtrlCreateButton("upload", 225, 348, 50, 20);3
GUICtrlSetOnEvent(-1, "_upload")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel ( "Schärfe: 1", 5, 185, 75, 15);4
GUICtrlCreateSlider(85, 185, 105, 15);5
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 99, 1)
GUICtrlSetData(-1, 1)
GUICtrlCreateLabel ( "Kontrast: 0", 5, 210, 75, 15);6
GUICtrlCreateSlider(85, 210, 190, 15);7
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 127, -127)
GUICtrlSetData(-1, 0)
GUICtrlCreateLabel ( "Helligkeit: 0", 5, 230, 75, 15);8
GUICtrlCreateSlider(85, 230, 190, 15);9
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
GUICtrlCreateLabel ( "Gamma: 1", 5, 250, 75, 15);10
GUICtrlCreateSlider(85, 250, 190, 15);11
GUICtrlSetOnEvent(-1, "_irf1")
GUICtrlSetLimit(-1, 699, 1)
GUICtrlSetData(-1, 100)
GuiCtrlCreateButton("reset", 5, 348, 40, 20);12
GUICtrlSetOnEvent(-1, "_reset")
GUICtrlCreatePic ( FileGetShortName(@TempDir) & "\irf0.jpg", 7, 17, 265, 134);13
GUICtrlCreatePic ( FileGetShortName(@TempDir) & "\irf0.jpg", 7, 385, 265, 134);14
$shack = GuiCtrlCreateButton("Datei", 50, 348, 50, 20);15
GUICtrlSetOnEvent(-1, "_quelldatei")
GUICtrlCreateGroup("Original-Bild", 3, 1, 274, 155)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", "", "wstr", "")
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateGroup("Ausgabe-Bild", 3, 369, 274, 155)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", "", "wstr", "")
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateCheckbox("Negativ", 200, 160, 55, 20);18
GUICtrlSetOnEvent(-1, "_preview")
GUICtrlCreateCheckbox("Graustufen", 200, 185, 75, 20);19
GUICtrlSetOnEvent(-1, "_preview")
GUICtrlCreateLabel ( "Sättigung: 0", 5, 270, 75, 15);20
GUICtrlCreateSlider(85, 270, 190, 15);21
GUICtrlSetOnEvent(-1, "newini")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
GUICtrlCreateLabel ( "Rot: 0", 5, 290, 75, 15);22
GUICtrlSetColor(-1, 0xc00000)
GUICtrlCreateSlider(85, 290, 190, 15);23
GUICtrlSetOnEvent(-1, "newini")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
GUICtrlCreateLabel ( "Grün: 0", 5, 310, 75, 15);24
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateSlider(85, 310, 190, 15);25
GUICtrlSetOnEvent(-1, "newini")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
GUICtrlCreateLabel ( "Blau: 0", 5, 330, 75, 15);26
GUICtrlSetColor(-1, 0x0000c0)
GUICtrlCreateSlider(85, 330, 190, 15);27
GUICtrlSetOnEvent(-1, "newini")
GUICtrlSetLimit(-1, 255, -255)
GUICtrlSetData(-1, 0)
GUICtrlCreateCheckbox("horizontal", 5, 160, 60, 20);28
GUICtrlSetOnEvent(-1, "_preview")
GUICtrlCreateCheckbox("vertikal", 100, 160, 52, 20);29
GUICtrlSetOnEvent(-1, "_preview")
GUICtrlCreatelabel ( "", 5, 526, 271, 20, $SS_SUNKEN+$SS_CENTER);30
GUICtrlSetbkColor(-1,0xe0e0e0)
GUICtrlSetOnEvent(-1, "_www")
GUICtrlCreateCombo ("nur die URL", 5, 550, 130, 17, $CBS_DROPDOWNLIST);31
GUICtrlSetData(-1,"[img]URL[/img]|HTML", "nur die URL")
GUICtrlCreateCombo ("abload.de", 143, 550, 130, 17, $CBS_DROPDOWNLIST);32
GUICtrlSetData(-1,"bayimg.com|imagebanana.com|imageshack.us|img-teufel.de|pic.leech.it|pic-upload.de", "abload.de")
GUICtrlCreateSlider(105, 350, 115, 15);33
GUICtrlSetOnEvent(-1, "_preview")
GUICtrlSetLimit(-1, 2500, 10)
GUICtrlSetData(-1, 320)
_GUICtrlSlider_SetLineSize(-1, 20)

$dialog = @WindowsDir & "\"
GuiSetState(@sw_show, $maingui)

While 1
	Sleep(20)
	If GUICtrlRead(3) = "Cancel" Then
		_preview()
		GUISetState ( @SW_DISABLE, $maingui )
	    $precurl = FileOpen(@TempDir & "\_curlrc", 2)
	    if guictrlread(32) = "imageshack.us" then
		    $newcurl = "-F fileupload=@" & $nachher & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--location-trusted" & @CRLF & "--url ""http://ufo.imageshack.us/"""
        elseif guictrlread(32) = "abload.de" then
            $newcurl = "-F img0=@" & $nachher & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""http://www.abload.de/upload.php"""
        elseif guictrlread(32) = "imagebanana.com" then
		    $newcurl = "-F img=@" & $nachher & @CRLF & "-F send=Hochladen!" & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--location-trusted" & @CRLF & "--url ""http://www.imagebanana.com/"""
	    elseif guictrlread(32) = "pic-upload.de" then
	       $newcurl = "-F file=@" & $nachher & @CRLF & "-F Submit= Bild Hochladen " & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""http://www.pic-upload.de/index.php?to=upload"""
        elseif guictrlread(32) = "pic.leech.it" then
	       $newcurl = "-F userfile=@" & $nachher & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""http://pic.leech.it/upload.php"""
	    elseif guictrlread(32) = "bayimg.com" then
	       $newcurl = "-F file=@" & $nachher & @CRLF & "-F code=2346574" & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""http://upload.bayimg.com/upload"""
	    elseif guictrlread(32) = "img-teufel.de" then
	       $newcurl = "-F upload_image=@" & $nachher & @CRLF & "-H ""Expect:""" & @CRLF & "-o curl.txt" & @CRLF & "--url ""http://www.img-teufel.de/upload.html"""
	    elseif guictrlread(32) = "OFFLINE - MODUS" then
	        ;
	    else
	        MsgBox(16, "Fehler!", "curl Speicherüberlauf! pic2web wird jetzt beendet!")
	        Exit
	    endif
        FileWrite($precurl, $newcurl)
        FileClose($precurl)
	    FileDelete ( FileGetShortName(@TempDir) & "\curl.txt" )
	    FileDelete (FileGetShortName(@TempDir) & "\test.txt")
	    $charslab = ""
	    $x = ""
	    $y = ""
        ClipPut ( "" )
	    GUICtrlSetData ( 30, "")
        If FileExists($nachher) Then
			$typ = ".jpg"
			$skb = (FileGetSize ( $nachher ) / 1024)
    		local $foo = Run(FileGetShortName(@TempDir) & "\curl.exe", FileGetShortName(@TempDir) & "\", @SW_HIDE, $STDERR_CHILD ), $line
	    	While ProcessExists ( "curl.exe")
				$line = StderrRead($foo)
         	    $line = StringRegExp($line, '\d+', 3)
			    if NOT @error then
					if $line[0] = 100 then $line[0] = 99
			        GUICtrlSetData ( 30, "uploading " & $line[0] & " %")
			    endif
	            sleep(50)
            Wend
		    Processclose ( "curl.exe")
		    GUICtrlSetData ( 30, "uploading 100 %")
	        if FileExists ( @TempDir & "\curl.txt" ) = 0 Then FileInstall("dummy", @TempDir & "\curl.txt", 1)
			If FileExists (@TempDir & "\curl.txt") Then
				$file = FileOpen(@TempDir & "\curl.txt", 0)
                $chars = FileRead($file)
                FileClose($file)
                if guictrlread(32) = "imageshack.us" then
					$result = StringInStr($chars, "url_image_path"" value=""")
                    $chars = StringTrimLeft($chars, $result + 22)
		            $result = StringInStr($chars, """")
                    $res2 = StringLen ( $chars )
                    $chars = StringTrimRight($chars, $res2 - $result + 1)
		            $result = StringInStr($chars, "/")
                    $res2 = StringLeft ( $chars, $result -1 )
                    $chars = $preurl & "http://" & $res2 & ".imageshack.us/" & $chars
	            elseif guictrlread(32) = "abload.de" then
					$result = StringInStr($chars, "&quot;;}}")
	                $res2 = StringLen ( $chars )
	                $chars = StringTrimRight($chars, $res2 - $result + 1)
		            while StringInStr($chars, ":&quot;") > 0
						$res2 = StringInStr($chars, ":&quot;")
			            $chars = StringTrimLeft($chars, $res2 + 6)
		            wend
		            $chars = $preurl & "http://www.abload.de/img/" & $chars
				elseif guictrlread(32) = "imagebanana.com" then
					$result = StringInStr($chars, "/][IMG]")
		            $chars = StringTrimLeft($chars, $result + 6)
                    $result = StringInStr($chars, "[")
		            $res2 = StringLen ( $chars )
                    $chars = $preurl & StringTrimRight($chars, $res2 - $result + 1)
				elseif guictrlread(32) = "pic-upload.de" then
					$result = StringInStr($chars, "[IMG]")
                    $chars = StringTrimLeft($chars, $result + 4)
                    $result = StringInStr($chars, "[/IMG]")
		            $res2 = StringLen ( $chars )
		            $chars = $preurl & StringTrimRight($chars, $res2 - $result + 1)
		            $chars = StringReplace ( $chars, "/thumb", "")
				elseif guictrlread(32) = "pic.leech.it" then
				    $result = StringInStr($chars, "[IMG]http://pic.leech.it/i/")
                    $chars = StringTrimLeft($chars, $result + 4)
                    $result = StringInStr($chars, "[/IMG]")
		            $res2 = StringLen ( $chars )
                    $chars = $preurl & StringTrimRight($chars, $res2 - $result + 1)
				elseif guictrlread(32) = "bayimg.com" then
					$result = StringInStr($chars, "http://bayimg.com/thumb/")
                    $chars = StringTrimLeft($chars, $result - 1)
                    $result = StringInStr($chars, """")
		            $res2 = StringLen ( $chars )
                    $chars = $preurl & StringReplace (StringTrimRight($chars, $res2 - $result + 1), "thumb", "image")
				elseif guictrlread(32) = "img-teufel.de" then
					$result = StringInStr($chars, "[IMG]http://www.img-teufel.de/uploads/")
                    $chars = StringTrimLeft($chars, $result + 4)
                    $result = StringInStr($chars, "[/IMG]")
		            $res2 = StringLen ( $chars )
                    $chars = $preurl & StringTrimRight($chars, $res2 - $result + 1)
				Else
					MsgBox(16, "Fehler!", "filter Speicherüberlauf! pic2web wird jetzt beendet!")
	                Exit
	            EndIf
				if stringlen ($chars) > 100 then $chars = "Uploadfehler"
				$show = $chars
		        if $preurl = "[img]" then $show = StringTrimLeft ( $chars, 5)
	            $chars = $chars & $posturl
		        if stringinstr ($show, ".jpg") > 0 or stringinstr ($show, ".gif") > 0 then
					GUICtrlSetColor(30,0x000000)
			        GUICtrlSetData ( 30, $show)
			        if guictrlread(31) = "nur die URL" then ClipPut($show & @CRLF)
                    if guictrlread(31) = "HTML" then ClipPut("<img src=""" & $show & """>" & @CRLF)
                    if stringinstr(guictrlread(31), "[img]") > 0 then ClipPut("[img]" & $show & "[/img]" & @CRLF)
				else
					GUICtrlSetData ( 30, "Uploadfehler!!")
				endif
			else
				GUICtrlSetData ( 30, "Uploadfehler!!")
			endif
		else
			$dialog = @WindowsDir & "\"
        EndIf
		$typ = StringRight ( $vorher, 4 )
		GUISetState ( @SW_ENABLE, $maingui )
		$typ4 = ""
    	GUICtrlSetData(3, "upload")
    endif
WEnd

Func _Quit()
	if msgbox(68,"pic2web 6.22","Wirklich beenden?") = 6 then Exit
EndFunc

func _quelldatei()
    GUISetState ( @SW_DISABLE, $maingui )
	$datei4pre = FileOpenDialog("Browse...", $dialog, "Images (*.jpg;*.png;*.gif;*.bmp;*.tif)", 1 + 2 + 4)
    $4c2 = StringLeft ( $datei4pre, stringinstr ($datei4pre, "|") - 1 ) & "\"
	$datei4pre = StringTrimLeft ( $datei4pre, stringinstr ($datei4pre, "|") )
   	$datei4 = $4c2 & $datei4pre
    if stringleft ($datei4, 1) = "\" then $datei4 = stringtrimleft ($datei4, 1)
    $dialog = StringLeft($datei4, StringInStr ( $datei4, "\", 0, -1))
	$typ4 = StringRight ( $datei4, 3 )
	If @error Then
		$fehler = 0
    elseif $typ4 <> "bmp" AND $typ4 <> "tif" AND $typ4 <> "jpg" AND $typ4 <> "png" AND $typ4 <> "gif" AND $typ4 <> "" then
        MsgBox(16,"Fehler:", "Unzulässige Datei!")
        _reset()
	elseif StringLen ($datei4) > 0 then
		GUICtrlSetData ( 30, $datei4)
		Runwait(FileGetShortName(@TempDir) & "\i_view32.exe " & $datei4 & " /silent /resample /convert=" & $vorher & " /info=" & FileGetShortName(@TempDir) & "\test.txt", FileGetShortName(@TempDir) & "\", @SW_HIDE)
		$chars = FileRead(@TempDir & "\test.txt")
	    $result = StringInStr($chars, "dimensions")
	    $charslab = StringTrimleft ($chars, $result + 12)
	    $result = StringInStr($charslab, "Pixels")
	    $res2 = StringLen ( $charslab )
	    $charslab = StringTrimRight($charslab, $res2 - $result - 4)
	    $x = Stringleft ($charslab, StringInStr($charslab, " ") -1)
        $y = Stringtrimleft ($charslab, StringInStr($charslab, " x") +2)
 	    $y = Stringleft ($y, StringInStr($y, "  Pixel")-1)
		GUICtrlSetData(16, "Original-Bild:  " & $x & " * " & $y & "  Pixel")
		GUICtrlSetData(33, Round(int($x), -1))
		$typ4 = "jpg"
		GUICtrlSetState(3, $GUI_ENABLE)
        GUICtrlSetImage ( 13, $vorher)
        newini()
        if StringLen (GUICtrlRead(30)) = 0 then
			_reset()
			MsgBox(16,"Fehler!", "Dateiname unzulässig!")
            $datei4 = ""
        endif
	else
		_reset()
	EndIf
	GUISetState ( @SW_ENABLE, $maingui )
endfunc

Func _upload()
	Switch GUICtrlRead(3)
		Case "upload"
		    if int(guictrlread(33)) > 2500 then msgbox(16,"Fehler", "Skalierung max. 2500!")
			if int(guictrlread(33)) <= 2500 Then GUICtrlSetData(3, "cancel")
		#cs;Case else
			Processclose ( "curl.exe")
	        FileDelete ( @TempDir & "\curl.txt" )
	        GUISetState ( @SW_ENABLE, $maingui )
	        _reset()
			#ce;GUICtrlSetData(3, "upload")
	EndSwitch
EndFunc

Func _www()
   if StringInStr ( guictrlread (30), "http://") then Run(@ComSpec & " /c " & "start " & guictrlread (30), "", @SW_HIDE)
EndFunc

func _irfanslide($irf1, $irf2, $irf3)
	GUICtrlSetData($irf1, $irf2 & GUICtrlRead($irf1+1) / $irf3)
endfunc

func _irf1()
	_irfanslide(4, "Schärfe: ", 1)
	_irfanslide(6, "Kontrast: ", 1)
	_irfanslide(8, "Helligkeit: ", 1)
	_irfanslide(10, "Gamma: ", 100)
	_irfanslide(20, "Sättigung: ", 1)
	_irfanslide(22, "Rot: ", 1)
	_irfanslide(24, "Grün: ", 1)
	_irfanslide(26, "Blau: ", 1)
	_preview()
endfunc

func _reset()
	$datei4cnt = 0
	GUICtrlSetData(16, "Original-Bild")
	GUICtrlSetData(17, "Ausgabe-Bild")
	GUICtrlSetData ( 30, "")
	GUICtrlSetData ( 33, 320)
	GUICtrlSetState(3, $GUI_DISABLE)
	GUICtrlSetData(5, 1)
	GUICtrlSetData(7, 0)
	GUICtrlSetData(9, 0)
	GUICtrlSetData(11, 100)
	GUICtrlSetData(21, 0)
	GUICtrlSetData(23, 0)
	GUICtrlSetData(25, 0)
	GUICtrlSetData(27, 0)
	_irfanslide(4, "Schärfe: ", 1)
	_irfanslide(6, "Kontrast: ", 1)
	_irfanslide(8, "Helligkeit: ", 1)
	_irfanslide(10, "Gamma: ", 100)
	_irfanslide(20, "Sättigung: ", 1)
	_irfanslide(22, "Rot: ", 1)
	_irfanslide(24, "Grün: ", 1)
	_irfanslide(26, "Blau: ", 1)
	GUICtrlSetState ( 18, $GUI_UNCHECKED)
	GUICtrlSetState ( 19, $GUI_UNCHECKED)
	GUICtrlSetState ( 28, $GUI_UNCHECKED)
	GUICtrlSetState ( 29, $GUI_UNCHECKED)
	$irfil = 0
	$irfanig = " "
	FileInstall("i_view32.ini", @TempDir & "\i_view32.ini", 1)
	GUICtrlSetImage ( 13, FileGetShortName(@TempDir) & "\irf0.jpg")
	GUICtrlSetImage ( 14, FileGetShortName(@TempDir) & "\irf0.jpg")
	FileDelete ($vorher)
	FileDelete ($nachher)
endfunc

func newini()
	$irfanbatch = FileOpen(@TempDir & "\i_view32.ini", 2)
    FileWriteLine($irfanbatch,"[Batch]")
    FileWriteLine($irfanbatch,"AdvSaturationVal="&guictrlread (21))
	FileWriteLine($irfanbatch,"AdvColRVal="&guictrlread (23))
	FileWriteLine($irfanbatch,"AdvColGVal="&guictrlread (25))
	FileWriteLine($irfanbatch,"AdvColBVal="&guictrlread (27))
	if guictrlread (21) <> 0 then
	    FileWriteLine($irfanbatch,"AdvSaturation=1")
	else
		FileWriteLine($irfanbatch,"AdvSaturation=0")
	endif
	if guictrlread (23) <> 0 then
	    FileWriteLine($irfanbatch,"AdvColR=1")
	else
		FileWriteLine($irfanbatch,"AdvColR=0")
	endif
	if guictrlread (25) <> 0 then
	    FileWriteLine($irfanbatch,"AdvColG=1")
	else
		FileWriteLine($irfanbatch,"AdvColG=0")
	endif
	if guictrlread (27) <> 0 then
	    FileWriteLine($irfanbatch,"AdvColB=1")
	else
		FileWriteLine($irfanbatch,"AdvColB=0")
	endif
    FileClose($irfanbatch)
	_irf1()
EndFunc

func _preview()
	$irfil = 0
	if GUICtrlRead(5) > 1 or GUICtrlRead(7) <> 0 or GUICtrlRead(9) <> 0 or GUICtrlRead(11)/100 <> 1  or GUICtrlRead (18) = 1 or GUICtrlRead (19) = 1 or GUICtrlRead(21) <> 0 or GUICtrlRead(23) <> 0 or GUICtrlRead(25) <> 0 or GUICtrlRead(27) <> 0 or GUICtrlRead (28) = 1 or GUICtrlRead (29) = 1 then $irfil = 1
	FileDelete ($nachher)
	$irfanig = " "
	if GUICtrlRead (18) = 1 then $irfanig &= "/invert "
	if GUICtrlRead (19) = 1 then $irfanig &= "/gray "
	if GUICtrlRead (28) = 1 then $irfanig &= "/hflip "
	if GUICtrlRead (29) = 1 then $irfanig &= "/vflip "
	GUICtrlSetData(33, Round(guictrlread(33), -1))
	$irfanig &= "/resize=("& guictrlread(33) &",0) /aspectratio "
	if GUICtrlGetState(3) = 80 then
	    Runwait(FileGetShortName(@TempDir) & "\i_view32.exe " & $vorher & " /silent /advancedbatch"&$irfanig&"/sharpen="&GUICtrlRead(5)&" /contrast="&GUICtrlRead(7)&" /bright="&GUICtrlRead(9)&" /gamma="&GUICtrlRead(11)/100&" /resample /convert=" & $nachher & " /info=" & FileGetShortName(@TempDir) & "\test.txt", FileGetShortName(@TempDir) & "\", @SW_HIDE)
		$chars = FileRead(@TempDir & "\test.txt")
	    $result = StringInStr($chars, "dimensions")
	    $charslab = StringTrimleft ($chars, $result + 12)
	    $result = StringInStr($charslab, "Pixels")
	    $res2 = StringLen ( $charslab )
	    $charslab = StringTrimRight($charslab, $res2 - $result - 4)
	    $x = Stringleft ($charslab, StringInStr($charslab, " ") -1)
        $y = Stringtrimleft ($charslab, StringInStr($charslab, " x") +2)
 	    $y = Stringleft ($y, StringInStr($y, "  Pixel")-1)
		GUICtrlSetData(17, "Ausgabe-Bild:  " & $x & " * " & $y & "  Pixel")
	Else
		Runwait(FileGetShortName(@TempDir) & "\i_view32.exe " & FileGetShortName(@TempDir) & "\irf0.jpg" & " /silent /advancedbatch"&$irfanig&"/sharpen="&GUICtrlRead(5)&" /contrast="&GUICtrlRead(7)&" /bright="&GUICtrlRead(9)&" /gamma="&GUICtrlRead(11)/100&" /resample /convert=" & $nachher, FileGetShortName(@TempDir) & "\", @SW_HIDE)
	endif
	GUICtrlSetImage ( 14, $nachher)
EndFunc



