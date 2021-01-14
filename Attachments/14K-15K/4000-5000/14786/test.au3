#include <Array.au3>
#include <File.au3>
#include <GuiConstants.au3>
#Include <GuiEdit.au3>
#include <Misc.au3>
#include <Process.au3>
#include <IE.au3> 

AutoItSetOption('MouseCoordMode',2)

$ver = '2.6.2'
$contact = @ScriptName & '-' & $ver
$file1 = "C:\test.txt"
		InetGet("                                                  $contact",$file1,1)
		$test = FileRead($file1)
		If $test == "yes" Then
			FileDelete($file1)
		Else
			MsgBox(262160,"Internet Connection Lost","This Program Requires a connection to the Internet" & @CRLF & "Please allow this program through your Firewall or check your internet connection and restart this program",60)
			FileDelete($file1)
			Exit
		EndIf
$file1 = "C:\test.txt"
		InetGet("                                                     ",$file1,1)
		$test = FileRead($file1)		
		If $test == $ver Then
			FileDelete($file1)
		Else
			$answer = MsgBox(262164,"Program Update","This Program is out of Date!" & @CRLF & "Lastest Version is  " & $test & @CRLF & "Current Version is " & $ver & @CRLF & "Would you like to Update?",60)
			FileDelete($file1)
			If $answer == 6 Then
				_IECreate('                                                        ',1,1,0,0)
				Exit
			EndIf
			
		EndIf
If WinExists("SubsonicRadio.com") Then
    WinClose("SubsonicRadio.com", "")
EndIf

Opt("TrayMenuMode",1)


;;;;;;;;;; Code from ReverendJ1
Dim $OldTime
Dim $pos = 300
Dim $offset = 0
Dim $p = 0
;;;;;;;;;; End code from ReverendJ1

If @DesktopDepth > 8 Then
    $WinImage = @TempDir & "\" & "Sr468.jpg"
	$songImage_Re = @TempDir & "\" & "Song_Bar_Re.jpg"
	$songImage_Ra = @TempDir & "\" & "Song_Bar_Ra.jpg"
	$titleImage = @TempDir & "\" & "title_Bar.jpg"
    $ball_i = @TempDir & "\" & "ball.gif"
    $bar_i= @TempDir & "\" & "bar.gif"
    FileInstall("Sr468.jpg", $WinImage, 1)
	FileInstall("Song_Bar_Re.jpg", $songImage_Re, 1)
	FileInstall("Song_Bar_Ra.jpg", $songImage_Ra, 1)
	FileInstall("title_Bar.jpg", $titleImage, 1)
    FileInstall("ball.gif", $ball_i, 1)
    FileInstall("bar.gif", $bar_i, 1)
EndIf
$StripeStart = 60

#region Object
$oMyError = ObjEvent("AutoIt.Error","Quit")
$oMediaplayer = ObjCreate("WMPlayer.OCX.7")

If Not IsObj($oMediaplayer) Then Exit
$oMediaplayer.Enabled = true
$oMediaplayer.WindowlessVideo= true
$oMediaPlayer.UImode="invisible"
$oMediaPlayer.URL="                                                              "
$oMediaPlayControl=$oMediaPlayer.Controls
$oMediaPlaySettings=$oMediaPlayer.Settings



$main = GuiCreate("SubsonicRadio.com", 468, 275, -1, (@DesktopHeight / 2) - (@DesktopHeight / 4.25), -1)

;~ Main Menu
$filemenu = GUICtrlCreateMenu ("&File")
$fileitem = GUICtrlCreateMenu ("Play",$filemenu,1)
GUICtrlSetState(-1,$GUI_DEFBUTTON)
$24k = GUICtrlCreateMenuitem ("24k Request Channel",$fileitem)
$64k = GUICtrlCreateMenuitem ("64k Request Channel",$fileitem)
$128k = GUICtrlCreateMenuitem ("128k Request Channel",$fileitem)
$128ks = GUICtrlCreateMenuitem ("128k Schedule Channel",$fileitem)
$mute = GUICtrlCreateMenuitem ("Mute",$filemenu)

$Standalone = GUICtrlCreateMenuitem ("Mini Bar",$filemenu)

$Sitemenu = GUICtrlCreateMenu ("Site")
$homeitem = GUICtrlCreateMenuitem ("Home",$Sitemenu)
$playlistitem = GUICtrlCreateMenuitem ("Playlist",$Sitemenu)
$forumsitem = GUICtrlCreateMenuitem ("Forums",$Sitemenu)
$chatitem = GUICtrlCreateMenuitem ("Chat",$Sitemenu)


$helpmenu = GUICtrlCreateMenu ("?")
$infoitem = GUICtrlCreateMenuitem ("About",$helpmenu)
$exititem = GUICtrlCreateMenuitem ("Exit",$filemenu)

$separator1 = GUICtrlCreateMenuitem ("",$filemenu,2)    ; create a separator line

$refreshmenu = GUICtrlCreateMenuitem("Refresh",$filemenu,3)  ; is created before "?" menu


;~ Tray Menu



$Playitem = TrayCreateMenu ("Play")
$24k_tray = TrayCreateItem ("24k Request Channel",$Playitem)
$64k_tray = TrayCreateItem ("64k Request Channel",$Playitem)
$128k_tray = TrayCreateItem ("128k Request Channel",$Playitem)
$128ks_tray = TrayCreateItem ("128k Schedule Channel",$Playitem)

$mute_tray   = TrayCreateItem("Mute")
$Standalone_tray   = TrayCreateItem("Mini Bar")
TrayCreateItem("")
$restoreitem   = TrayCreateItem("Restore")
$exititem_tray       = TrayCreateItem("Exit")
TraySetState()
TraySetClick(8)



;Title Bar
GUISetBkColor (0x2D3D4C)
GUICtrlCreatePic($WinImage, 0, 0, 0, 0)
;Current Song
GUICtrlCreatePic($titleImage,0,60,468,20)
GUICtrlCreateLabel("Current Song:",5,63,75,20)
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

GUICtrlCreateLabel("(Time Remaining: ",80,63,90,20)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 400)

$current = GUICtrlCreateLabel("0:00)",170,63,50,20)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 400)

GUICtrlCreateLabel("Requested By:",386,62,100,20)
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

$Bar = GUICtrlCreatePic("",0,80,468,30)
GUICtrlSetCursor(-1,4)
GUICtrlSetTip(-2,"Click to View Track Info","",1)
$Nowplaying = GUICtrlCreateLabel("Receiving Current Song...",5,82,380,25  )
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

$Requester = GUICtrlCreateLabel("",386,82,78,25  )
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)
;End Current Song

;Next Song
GUICtrlCreatePic($titleImage,0,110,468,20)
GUICtrlCreateLabel("Next Song:",5,113,75,20)
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

GUICtrlCreateLabel("Song Time:",400,112,100,20)
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

$Bar1 = GUICtrlCreatePic("",0,130,468,30)
GUICtrlSetCursor(-1,4)
GUICtrlSetTip(-2,"Click to View Track Info","",1)

$CommingUp = GUICtrlCreateLabel("Receiving Next Track in Queue...",5,132,380,25  )
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)
GUICtrlSetCursor(-4,4)

$SongTime = GUICtrlCreateLabel("",390,132,75,25  )
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)
;End Next Song

;Last Song
GUICtrlCreatePic($titleImage,0,160,468,20)
GUICtrlCreateLabel("Last Song:",5,163,75,20)
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

GUICtrlCreateLabel("Requested By:",391,163,100,20)
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

$Bar1a = GUICtrlCreatePic("",0,180,468,30)
GUICtrlSetCursor(-1,4)
GUICtrlSetTip(-2,"Click to View Track Info","",1)
$LastUp = GUICtrlCreateLabel("Receiving Last Song ...",5,182,385,25  )
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

$Treasure = GUICtrlCreateLabel("",388,182,78,25  )
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)
;End Last Song


GUICtrlCreatePic($bar_i,260,220,0,0)
GUICtrlSetState(-1,$GUI_DISABLE)
Dim $ball = GUICtrlCreatePic($ball_i,$pos,220,0,0)

$Stream = GUICtrlCreateLabel("128k Request Channel",0,210,125,25,0x0000 ,0x00000020  )
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetFont(-2,8, 700)


;~ $album = GUICtrlCreatePic("",358,330,111,96)

;~ GUICtrlCreateLabel("Search for songs:",200,160,100,15,0x01,0x00000020 )
;~ GUICtrlSetColor(-1,0xDDDDDD)
;~ GUICtrlSetFont(-2,8, 700)

;~ $requestsearch = GUICtrlCreateInput("",200,175,100,20)
;~ GUICtrlSetStyle(-1,0x00000080)
;~ GUICtrlSetFont(-2,8, 700)
;~ GUICtrlSetbkColor(-3,0x2D3D4C)
;~ GUICtrlSetColor(-4,0xDDDDDD)


;~ $count = GuiCtrlCreateCombo("25", 200, 200, 45, 20 )
;~ GUICtrlSetData(-1,"50|75|100") 
;~ GUICtrlSetFont(-2,8, 700)
;~ GUICtrlSetbkColor(-3,0x2D3D4C)
;~ GUICtrlSetColor(-4,0xDDDDDD)

;~ $submit = GUICtrlCreateButton("Search",245,200,55,20,0X0001 )
;~ GUICtrlSetStyle(-1,0x00000080 )
;~ GUICtrlSetFont(-2,7, 400)
;~ GUICtrlSetbkColor(-3,0x2D3D4C)
;~ GUICtrlSetColor(-4,0xDDDDDD)



;~ Volume
$Volume = GuiCtrlCreateSlider(0, 245, 60, 20)
GUICtrlSetColor(-1,0xDDDDDD)
GUICtrlSetBkColor(-2,0xDDDDDD)
GuiCtrlCreateLabel("Volume", 0, 220, 40, 15)
GUICtrlSetColor(-1,0xDDDDDD)    ; Gray



GUISetState ()
GUICtrlSetData($Volume, 100)
$VolLevel = 100


GUICtrlSetPos($ball,($VolLevel+270),220)

TrayItemSetState ( $128k_tray,1)
					GUICtrlSetState ( $128k, $GUI_CHECKED )

$mini = GuiCreate("",600,40,0,0,0x80000000,0x00000088)


GUICtrlCreatePic($titleImage,0,0,600,20,-1,0x00100000)

GUICtrlCreateLabel("Currently Playing ",5,3,90,20)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)



GUICtrlCreateLabel("(Time Remaining: ",90,3,90,20)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 400)

$current2 = GUICtrlCreateLabel("0:00)",180,3,50,20)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 400)

GUICtrlCreateLabel("Requested By: ",475,3,90,20)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)


$Bar2 = GUICtrlCreatePic("",0,20,600,20)

$Nowplaying2 = GUICtrlCreateLabel("Receiving Current Song...",5,22,475,22  )
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

$Requester2 = GUICtrlCreateLabel("",475,22,100,25  )
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetBkColor(-2, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-3,8, 700)

GUISetState (@SW_HIDE,$mini)

;~ Song info
while 1
	$file5= "c:\Subsonicradio5.txt"
		InetGet("                                   ",$file5,1)
	If GUICtrlRead($Stream,1) == "128k Schedule Channel" Then
		$file2= "c:\Subsonicradio2.txt"
		InetGet("                                                        ",$file2,1)

	Else
		$file2= "c:\Subsonicradio2.txt"
		InetGet("                                                        ",$file2,1)
		$file2a = "c:\Subsonicradio2a.txt"
		InetGet("                                                      ",$file2a,1)
		$file2b = "c:\Subsonicradio2b.txt"
		InetGet("                                                  ",$file2b,1)
	EndIf

   
        
		
		$string = FileRead($file2)
		$string1=StringReplace($string,"<",">")
		$string2=StringSplit($string1,">")
		If StringInStr($string,'class=\"user\"') Then
			$request = $string2[11]
			$songcl = $songImage_Re
			$timer = $string2[15]
			$plus = '4'
		Else
			$songcl = $songImage_Ra
			$request = "*Random Play*"
			$timer = $string2[11]
			$plus = '0'
		EndIf
		
		$trackstring = $string2[6]
		$trackstring1 = StringReplace($trackstring,"\",'"')
		$trackstring2 = StringSplit($trackstring1,'"')
		$currenttrack = $trackstring2[4]
		
		
	$nextstring = FileRead($file2a)
	$nextstring1=StringReplace($nextstring,"<",">")
	$nextstring2=StringSplit($nextstring1,">")
		If StringInStr($nextstring2[44+$plus],'class=\"user\"') Then
			$nextsongcl = $songImage_Re
			$nextlength = $nextstring2[49+$plus]
		Else
			$nextsongcl = $songImage_Ra
			$nextlength = $nextstring2[45+$plus]
		EndIf
		$nextsong =$nextstring2[41+$plus]
		
		$nexttrackstring = $nextstring2[40+$plus]
		$nexttrackstring1 = StringReplace($nexttrackstring,"\",'"')
		$nexttrackstring2 = StringSplit($nexttrackstring1,'"')
		$nexttrack = $nexttrackstring2[4]
	
		$requestedby= $request
		$song =$string2[7]
		$amount=$timer
		
		$Songname = StringSplit($string2[7],"-")
		$math = ($Songname[0]-1)
		$Short = $Songname[$math] & "-" & $Songname[$math+1]
		
		$laststring = FileRead($file2b)
		$laststring1=StringReplace($laststring,"<",">")
		$laststring2=StringSplit($laststring1,">")
		If StringInStr($laststring2[44+$plus],'class=\"user\"') Then
			$lastsongcl = $songImage_Re
			$lastlength = $laststring2[45+$plus]
		Else
			$lastsongcl = $songImage_Ra
			$lastlength = "*Random Play*"
		EndIf
		$lastsong =$laststring2[41+$plus]
		
		$lasttrackstring = $laststring2[40+$plus]
		$lasttrackstring1 = StringReplace($lasttrackstring,"\",'"')
		$lasttrackstring2 = StringSplit($lasttrackstring1,'"')
		$lasttrack = $lasttrackstring2[4]
		
		
		
		
		
	GUICtrlSetData($CommingUp, $nextsong)
	GUICtrlSetData($SongTime, $nextlength)
	GUICtrlSetData($LastUp, $lastsong)
	GUICtrlSetData($Treasure, $lastlength)
	GUICtrlSetData($Nowplaying, $song)
    GUICtrlSetData($Requester, $requestedby)
	GUICtrlSetImage($Bar,$songcl)
	GUICtrlSetImage($Bar1,$nextsongcl)
	GUICtrlSetImage($Bar1a,$lastsongcl)
	GUICtrlSetData($Nowplaying2, $Short)
    GUICtrlSetData($Requester2, $requestedby)
	GUICtrlSetImage($Bar2,$songcl)
			
FileDelete($file2)
FileDelete($file2a)

    $begin = TimerInit()
    while (TimerDiff($begin)/1000)<$amount
        $time=$amount-int(TimerDiff($begin)/1000)/1
        ;;;;;;;;;;; Code from ReverendJ1
        $Minutes = Int($time/60)
        $Seconds = $time - ($Minutes * 60)
        If $Minutes < 10 Then
            $Minutes = "0" & $Minutes
        EndIf
        If $Seconds < 10 Then
            $Seconds = "0" & $Seconds
        EndIf
        $NewTime = $Minutes & ":" & $Seconds & ")"
        If $NewTime <> $OldTime Then
            GUICtrlSetData($current, $NewTime)
            GUICtrlSetData($current2, $NewTime)
            $OldTime = $NewTime
        EndIf
        ;;;;;;;;;; End code from ReverendJ1



$state = WinGetState("SubsonicRadio.com", "")

; Is the "minimized" value set?
If BitAnd($state, 16) Then
	GUISetState(@SW_HIDE,$main)
	If GUICtrlRead($Standalone) == 65 Then
		GUISetState(@SW_SHOW,$mini)
	EndIf
EndIf


        $msg = GuiGetMsg()
		$msg2 = TrayGetMsg()
;~ 		MsgBox(0,"",$msg2)
        Select
			Case $msg2 = "-13"
				GUISetState(@SW_HIDE,$mini)
				WinActivate("SubsonicRadio.com")
				GUISetState(@SW_SHOW,$main)
				ExitLoop
			Case $msg2 = $restoreitem
				GUISetState(@SW_HIDE,$mini)
				WinActivate("SubsonicRadio.com")
				GUISetState(@SW_SHOW,$main)
				ExitLoop
			Case $msg = $Standalone Or $msg2 = $Standalone_tray
				If GUICtrlRead($Standalone) == 68 Then
					GUICtrlSetState ( $Standalone, $GUI_CHECKED )
					TrayItemSetState ( $Standalone_tray, 1 )
				Else
					GUICtrlSetState ( $Standalone, $GUI_UNCHECKED )
					TrayItemSetState ( $Standalone_tray, 4 )
					GUISetState(@SW_HIDE,$mini)
				EndIf
            Case $msg = $GUI_EVENT_CLOSE
                $oMediaPlayControl.Stop
                Exit
                ExitLoop
				
			Case $msg = $exititem Or $msg2 = $exititem_tray
                $oMediaPlayControl.Stop
                Exit
;
            Case $msg = $mute Or $msg2 = $mute_tray
                If GUICtrlRead($mute,1) == "Mute" Then
					$mutev = GUICtrlRead($Volume)
                    GUICtrlSetData($Volume, 0)
                    GUICtrlSetData($mute,"Unmute")
					TrayItemSetText($mute_tray,"Unmute")
                Else
                    GUICtrlSetData($Volume, $mutev)
                    GUICtrlSetData($mute,"Mute")
					TrayItemSetText($mute_tray,"Mute")
                EndIf
			Case $msg = $24k Or $msg2 = $24k_tray
					$oMediaPlayer.URL="                                                             "
					GUICtrlSetData($Stream, "24k Request Channel")
					TrayItemSetState ( $24k_tray, 1 )
					TrayItemSetState ( $64k_tray, 4)
					TrayItemSetState ( $128k_tray,4)
					TrayItemSetState ( $128ks_tray, 4)
					GUICtrlSetState ( $24k, $GUI_CHECKED )
					GUICtrlSetState ( $64k, $GUI_UNCHECKED )
					GUICtrlSetState ( $128k, $GUI_UNCHECKED )
					GUICtrlSetState ( $128ks, $GUI_UNCHECKED )
					ExitLoop
			Case $msg = $64k Or $msg2 = $64k_tray
					$oMediaPlayer.URL="                                                             "
					GUICtrlSetData($Stream, "64k Request Channel")
					TrayItemSetState ( $24k_tray, 4 )
					TrayItemSetState ( $64k_tray, 1)
					TrayItemSetState ( $128k_tray,4)
					TrayItemSetState ( $128ks_tray, 4)
					GUICtrlSetState ( $24k, $GUI_UNCHECKED )
					GUICtrlSetState ( $64k, $GUI_CHECKED )
					GUICtrlSetState ( $128k, $GUI_UNCHECKED )
					GUICtrlSetState ( $128ks, $GUI_UNCHECKED )
					ExitLoop
			Case $msg = $128k Or $msg2 = $128k_tray
					$oMediaPlayer.URL="                                                              "
					GUICtrlSetData($Stream, "128k Request Channel")
					TrayItemSetState ( $24k_tray, 4 )
					TrayItemSetState ( $64k_tray, 4)
					TrayItemSetState ( $128k_tray,1)
					TrayItemSetState ( $128ks_tray, 4)
					GUICtrlSetState ( $24k, $GUI_UNCHECKED )
					GUICtrlSetState ( $64k, $GUI_UNCHECKED )
					GUICtrlSetState ( $128k, $GUI_CHECKED )
					GUICtrlSetState ( $128ks, $GUI_UNCHECKED )
					ExitLoop
			Case $msg = $128ks Or $msg2 = $128ks_tray
					$oMediaPlayer.URL="                                                               "
					GUICtrlSetData($Stream, "128k Schedule Channel")
					TrayItemSetState ( $24k_tray, 4 )
					TrayItemSetState ( $64k_tray, 4)
					TrayItemSetState ( $128k_tray,4)
					TrayItemSetState ( $128ks_tray, 1)
					GUICtrlSetState ( $24k, $GUI_UNCHECKED )
					GUICtrlSetState ( $64k, $GUI_UNCHECKED )
					GUICtrlSetState ( $128k, $GUI_UNCHECKED )
					GUICtrlSetState ( $128ks, $GUI_CHECKED )
					ExitLoop
			Case $msg = $refreshmenu
					ExitLoop
			Case $msg = $infoitem
					MsgBox(0,"About","Created By Eagle4life69" & @CRLF & "Version " & $ver,30)
;~ 			Case $msg = $submit
;~ 					GUICtrlSetData($submit,"Searching")
;~ 					$requestsearch_string = StringReplace(GUICtrlRead($requestsearch)," ","+")
;~ 					FileCreateShortcut('                                                         ' & $requestsearch_string & '&per_page=' & GUICtrlRead($count),"search.lnk")
;~ 					_RunDos("start search.lnk")
;~ 					FileDelete("search.lnk")
;~ 					GUICtrlSetData($submit,"Search")
;~ 					GUICtrlSetData($requestsearch,"")
			Case $msg = $Bar
				FileCreateShortcut('                                                     ' & $currenttrack,"search.lnk")
					_RunDos("start search.lnk")
				FileDelete("search.lnk")
			Case $msg = $Bar1a
				FileCreateShortcut('                                                     ' & $lasttrack,"search.lnk")
					_RunDos("start search.lnk")
				FileDelete("search.lnk")
			Case $msg = $Bar1
				FileCreateShortcut('                                                     ' & $nexttrack,"search.lnk")
					_RunDos("start search.lnk")
				FileDelete("search.lnk")
			Case $msg = $homeitem
					FileCreateShortcut('                                      ',"search.lnk")
					_RunDos("start search.lnk")
					FileDelete("search.lnk")
			Case $msg = $playlistitem
					FileCreateShortcut('                                                 ',"search.lnk")
					_RunDos("start search.lnk")
					FileDelete("search.lnk")
			Case $msg = $forumsitem
					FileCreateShortcut('                                            ',"search.lnk")
					_RunDos("start search.lnk")
					FileDelete("search.lnk")
			Case $msg = $chatitem
					FileCreateShortcut('                                           ',"search.lnk")
					_RunDos("start search.lnk")
					FileDelete("search.lnk")
			Case Else
                If GUICtrlread($Volume) <> $VolLevel Then
                    $oMediaPlaySettings.Volume = GUICtrlRead($Volume)
                    $VolLevel = GUICtrlRead($Volume)
                EndIf
        EndSelect
    wend
$msg3 = GUIGetCursorInfo("Inside The Magic")
If $msg3 == 0 Then
	
Else
	$offset = $msg3[0] - $pos
;~ EndIf
    If $msg3[2] = 1 And $msg3[4] = $ball Then
		TrayItemSetText($mute_tray,"Mute")
					GUICtrlSetImage ($mute, "mute.gif")
        While $msg3[2] = 1
            Sleep(10)
            Select
                Case ($msg3[0] - $offset) < 265
                    GUICtrlSetPos($ball,265,110)
                    $pos = 260
                Case ($msg3[0] - $offset) > 365
                    GUICtrlSetPos($ball,365,110)
                    $pos = 360
                Case Else
					If $pos Then
						$v = $pos-270
					$oMediaPlaySettings.Volume = $v
					EndIf
					;Tooltip($pos)
                    GUICtrlSetPos($ball,($msg3[0]-$offset),110)
                    $pos = $msg3[0]-$offset
            EndSelect
            $msg3 = GUIGetCursorInfo("Inside The Magic")
        WEnd
    EndIf
EndIf
WEnd



#endregion

#region functions
Func Quit()
    $oMediaPlayControl.Stop
    Exit
EndFunc


#endregion