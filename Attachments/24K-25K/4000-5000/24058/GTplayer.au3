#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.10 (beta)
 Author:         Emanuel "Datenshi" Lindgren
 Credits : "Nobbe" for his mplayer gui base and thread at the autoit forum. 
 Licence: GPLv3
 Script Function:
	Frontend for Mplayer used to easily watch and stay updated on Gametrailers, hosted on gametrailers.com.

#ce ----------------------------------------------------------------------------
#include <GUIConstants.au3>
#include <String.au3>
#include <Array.au3>
#include <Constants.au3>
#include <inet.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <SliderConstants.au3>
#Include <GuiTreeView.au3>
#include <EditConstants.au3>
#Include <Misc.au3>
#NoTrayIcon
Opt("GUICloseOnESC",0)
Opt("OnExitFunc","ExitFunc")
FileInstall("mplayer.exe","mplayer.exe")
FileInstall("splash.jpg",@TempDir&"\splash.jpg")
FileInstall("Pc.jpg",@TempDir&"\Pc.jpg")
FileInstall("Wii.jpg",@TempDir&"\Wii.jpg")
FileInstall("xbox.jpg",@TempDir&"\xbox.jpg")
Dim $GameList[1]
Dim $GameNameAlreadyInTree[1]
$urlserver = "                                               "
$trailerlinkstart = "                                          "
Global $GamelistNr = -1
Global $pause = 0
Global $muted = 0
Global $RSSFeed = "                                                        [xb360]=xb360&favplats[pc]=pc&vidformat[flv]=on&vidformat[mov]=on&vidformat[wmv]=on&type[review]=on&type[preview]=on&type[interview]=on&type[gameplay]=on&type[trailer]=on&type[feature]=on&quality[either]=on&agegate[yes]=on&agegate[no]=on&orderby=newest&limit=100"
$fson = 0
$adlibtimer = 1000
$mplayerpid = ""
$PlatformLabel = "N/A"
$Description = "N/A"
$PubDate = "N/A"
$dll = DllOpen("user32.dll")
$tamanhox=@DesktopWidth*0.2000
$tamanhoy=$tamanhox/2
$posicaox=(@DesktopWidth/2)-($tamanhox/2)
$posicaoy=(@DesktopHeight/2)-($tamanhoy)
SplashImageOn("",@TempDir&"\splash.jpg",$tamanhox,$tamanhoy,$posicaox,$posicaoy,17)
$GUI = GUICreate("GTPlayer BETA", 900, 650, 193, 315)
GUISetBkColor(0x020202)
GUICtrlSetDefColor("0xFFFFFF")
GUICtrlSetDefBkColor("0x020202")
$GameNameLabel = GUICtrlCreateLabel("Game Name", 196, 14, 442, 20)
GUICtrlSetFont(-1, 14, 400, 0, "Arial Bold")
$TrailerTitelLabel = GUICtrlCreateLabel("Video Title", 196, 44, 436, 20)
GUICtrlSetFont(-1, 14, 400, 0, "Arial Bold")
$InfoLabel = GUICtrlCreateLabel("", 196, 80, 362, 25)
$Button_Pause = GUICtrlCreateButton("Pause", 92, 558, 75, 25)
$DesCtrl = GUICtrlCreateEdit("", 5, 112, 633, 70,$ES_READONLY)
GUICtrlSetFont(-1, 14, 400, 0, "Arial Bold")
$fullscreen = GUICtrlCreateButton("Fullscreen", 244, 558, 75, 25)
$BackVid = GUICtrlCreateButton("PREV", 332, 574, 75, 25)
$NewVid = GUICtrlCreateButton("NEXT", 332, 550, 75, 25)
$Forward = GUICtrlCreateButton(">>", 164, 558, 75, 25)
$Rewind = GUICtrlCreateButton("<<", 16, 558, 75, 25, 0)
$Pic1 = GUICtrlCreatePic("", 5, 5, 188, 100,$SS_SUNKEN)
$IconXbox = GUICtrlCreatePic(@TempDir&"\xbox.jpg",440, 70, 35, 35)
	GuiCtrlSetState($IconXbox,$GUI_Hide)
$IconPC = GUICtrlCreatePic(@TempDir&"\pc.jpg",475, 70, 35, 35)
	GuiCtrlSetState($IconPC,$GUI_Hide)
$IconWii = GUICtrlCreatePic(@TempDir&"\Wii.jpg",510, 70, 35, 35)
GuiCtrlSetState($IconWii,$GUI_Hide)
$VideoWindow = GUICtrlCreateLabel("",5, 188, 633, 339)
GUICtrlSetBkColor($VideoWindow,"0x020202")
$GameListTreeView = GUICtrlCreateTreeView(655, 0, 245, 575,BitOR($TVS_DISABLEDRAGDROP,$TVS_HASBUTTONS),$WS_EX_OVERLAPPEDWINDOW)
$CustomRss = GUICtrlCreateButton("RSS Feed", 656, 584, 49, 25, 0)
$InputSearch = GUICtrlCreateInput("Search..", 712, 585, 81, 21)
$SearchButton = GUICtrlCreateButton("Lookup", 800, 583, 43, 25, 0)
$PosSlider = GUICtrlCreateSlider(5, 514, 635, 30, BitOR($TBS_AUTOTICKS,$TBS_BOTH))
$Volume = GUICtrlCreateSlider(478, 545, 113, 30, BitOR($TBS_AUTOTICKS,$TBS_BOTH))
$Mute = GUICtrlCreateIcon("shell32.dll", 277, 591, 544, 41, 33)
GUICtrlSetLimit($Volume,"100","0")
GUICtrlSetLimit($PosSlider,"100","0")
GUICtrlSetData($Volume,"50")
GUICtrlSetData($PosSlider,"0")
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
MainFunc($RSSFeed)
GUISetState(@SW_SHOW)
SplashOff()
$HandleAVI = GUICtrlGetHandle($VideoWindow)
AdlibEnable("adlib", $adlibtimer)
NewVid("1")
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
		Case $NewVid
		  NewVid("1")
	  Case $BackVid
		  NewVid("0")
		 Case $Volume
			  If $mplayerpid Then
			 StdinWrite($mplayerpid, "volume "& GUICtrlRead($Volume) &" 1"& @LF)
			 If $muted = 1 Then
			 StdinWrite($mplayerpid,"mute 0" & @LF)
			 GUICtrlSetImage($Mute, "shell32.dll", 277)
			 $muted = 0
			 Endif
			 Endif
		 Case $PosSlider
			 StdinWrite($mplayerpid,"seek "& GUICtrlRead($PosSlider) &" 1" & @LF)
			 StdinWrite($mplayerpid,"get_property percent_pos" & @LF)
			 $c = StdoutRead($mplayerpid)
			If StringInStr($c,"ANS_percent_pos=") AND _IsPressed(01,$dll)=0 then
			$tmp = _StringBetween($c,"ANS_percent_pos=", @CRLF)
            $percpos = StringStripWS($tmp[0], 7)
			GUICtrlSetData($PosSlider,$percpos)
			Endif
		Case $CustomRss
			$RSSFeed = InputBox("Custom Rss Feed","Specify link to custom GameTrailers.com RSS Feed",$RSSFeed)
			If NOT @Error Then
			_GUICtrlTreeView_DeleteAll($GameListTreeView)
			MainFunc($RSSFeed)
			NewVid(3)
		Else
			$RSSFeed = "                                                        [xb360]=xb360&favplats[pc]=pc&vidformat[flv]=on&vidformat[mov]=on&vidformat[wmv]=on&type[review]=on&type[preview]=on&type[interview]=on&type[gameplay]=on&type[trailer]=on&type[feature]=on&quality[either]=on&agegate[yes]=on&agegate[no]=on&orderby=newest&limit=100"
			Endif
		Case $SearchButton
			$ReadInput = GUICtrlRead($InputSearch)
			;$bugWaround = StringRegExp($ReadInput,"Search..")
			If StringRegExp($ReadInput,"Search..") = 0 Then
			;		Else
			$RSSFeed = Search("                                         "&$ReadInput)
			If Not @Error Then
			_GUICtrlTreeView_DeleteAll($GameListTreeView)
			MainFunc($RssFeed)
			NewVid(3)
			Endif
			Endif
	
		 Case $Mute
			  If $mplayerpid Then
				  If $muted = 0 then
			 StdinWrite($mplayerpid,"mute 1" & @LF)
			 GUICtrlSetImage($Mute, "shell32.dll", 240)
			 $muted = 1
		 Else 
			 StdinWrite($mplayerpid,"mute 0" & @LF)
			 GUICtrlSetImage($Mute, "shell32.dll", 277)
			 $muted = 0
			 Endif
			 Endif		 
        Case $Forward 
                StdinWrite($mplayerpid, "seek +5" & @LF) 
				$pause = 0
        Case $Rewind 
            StdinWrite($mplayerpid, "seek -5" & @LF) 
			$pause = 0
        Case $fullscreen
			If $mplayerpid Then
			StdinWrite($mplayerpid, "vo_fullscreen" & @LF)
			$pause = 0
			$fson = 1
			$adlibtimer = 250
		   Endif
        Case $Button_Pause
            If $pause = 0 Then
                StdinWrite($mplayerpid, "pause" & @LF) 
                $pause = 1
            ElseIf $pause = 1 Then 
                StdinWrite($mplayerpid, "pause" & @LF) 
                $pause = 0
            EndIf
        Case $GUI_EVENT_CLOSE
            ProcessClose($mplayerpid)
		 Exit
    EndSwitch
WEnd
Func Adlib()
	If NOT ProcessExists($mplayerpid) then
		If  $fson = 1 Then
			 $fson = 0
			 $adlibtimer = 1000
			   Endif
		   Else
	   If $fson = 1 AND $mplayerpid <> "" Then
		  StdinWrite($mplayerpid, "get_vo_fullscreen" & @LF)
		 $c = StdoutRead($mplayerpid)
		 ConsoleWrite($c)
		   If StringInStr($c, "ANS_VO_FULLSCREEN=0") Then
			   $fson = 0
			   $adlibtimer = 1000
			   Endif
		   EndIf
		   
        $pos = 0
        $max = 0
		$cachefill = "N/A"

    If $mplayerpid And $pause = 0 AND $Fson = 0 Then
		StdinWrite($mplayerpid,"get_property percent_pos" & @LF)
        StdinWrite($mplayerpid, "get_time_pos" & @LF)
        StdinWrite($mplayerpid, "get_time_length" & @LF)
		$c = StdoutRead($mplayerpid)
		ConsoleWrite($c)
        If StringInStr($c, "Cache fill: ") > 0 Then
			$tmp = _StringBetween($c, "Cache fill: "," (")
			$nr = Ubound($tmp) -1
            $cachefill = StringStripWS($tmp[$nr], 7)
			Endif
		If StringInStr($c,"ANS_percent_pos=") AND _IsPressed(01,$dll)=0 then
			$tmp = _StringBetween($c,"ANS_percent_pos=", @CRLF)
            $percpos = StringStripWS($tmp[0], 7)
			GUICtrlSetData($PosSlider,$percpos)
			Endif
        If StringInStr($c, "ANS_TIME_POSITION") > 0 Then
            $tmp = _StringBetween($c, "ANS_TIME_POSITION=", @CRLF)
            $pos = StringStripWS($tmp[0], 7)
        EndIf
        If StringInStr($c, "ANS_LENGTH=") > 0 Then
            $tmp = _StringBetween($c, "ANS_LENGTH=", @CRLF)
            $max = StringStripWS($tmp[0], 7)
	   EndIf
	   If $max = 0 And $pos = 0 Then
		   $vid_duration = "N/A"
		   Else
$vid_duration = Int($max-$pos)
$sec2time_hour = Int($vid_duration / 3600)
$sec2time_min = Int(($vid_duration - $sec2time_hour * 3600) / 60)
$sec2time_sec = $vid_duration - $sec2time_hour * 3600 - $sec2time_min * 60
$vid_duration = StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
	 Endif
	 If StringInStr($PlatformLabel,"xb360") Then
		GuiCtrlSetState($IconXbox,$GUI_SHOW)
	Else
		GuiCtrlSetState($IconXbox,$GUI_Hide)
	Endif
	 If StringInStr($PlatformLabel,"pc") Then
		GuiCtrlSetState($IconPC,$GUI_SHOW)
	Else
		GuiCtrlSetState($IconPC,$GUI_Hide)
	Endif
		 If StringInStr($PlatformLabel,"wii") Then
		GuiCtrlSetState($IconWii,$GUI_SHOW)
	Else
		GuiCtrlSetState($IconWii,$GUI_Hide)
	Endif
		 
    GUICtrlSetData($InfoLabel,"Timeleft: "& $vid_duration &"   Cache: "&$cachefill&@CRLF&" Pub.Date: "&$PubDate)
	EndIf
Endif
EndFunc
Func MainFunc($PageUrl)
GUICtrlSetState($NewVid,$GUI_DISABLE)
$GameNamePos = 0
$source1 = _InetGetSource($PageUrl)
$GameList = _StringBetween($source1,"<item>","</item>")
_GUICtrlTreeView_BeginUpdate($GameListTreeView)
For $x = 0 To Ubound($GameList) -1
			$GameName = _StringBetween($Gamelist[$x],"<exInfo:gameName>","</exInfo:gameName>")
			$GameName =  _HTMLToText(StringStripWS($GameName[0], 7))
			
		$CurrentPos = _GUICtrlTreeView_FindItem($GameListTreeView,$GameName)
		If $CurrentPos <> 0 Then
		   $TrailerName = _StringBetween($Gamelist[$x],"<exInfo:movieTitle>","</exInfo:movieTitle>")
		   $TrailerName =  _HTMLToText(StringStripWS($TrailerName[0], 7))
			$itemHandle = _GUICtrlTreeView_AddChild($GameListTreeView,$CurrentPos,$TrailerName)
			_GUICtrlTreeView_SetItemParam($GameListTreeView,$itemHandle,$x)
		  Else
			$GameNamePos = _GUICtrlTreeView_Add($GameListTreeView,$GameNamePos,$GameName)
			_GUICtrlTreeView_SetBold($GameListTreeView,$GameNamePos,True)
			  $TrailerName = _StringBetween($Gamelist[$x],"<exInfo:movieTitle>","</exInfo:movieTitle>")
			  $TrailerName =  _HTMLToText(StringStripWS($TrailerName[0], 7))
               $itemHandle =  _GUICtrlTreeView_AddChild($GameListTreeView,$GameNamePos,$TrailerName)
				_GUICtrlTreeView_SetItemParam($GameListTreeView,$itemHandle,$x)
		Endif
	Next
	_GUICtrlTreeView_EndUpdate($GameListTreeView)
GUICtrlSetState($NewVid,$GUI_ENABLE)
Endfunc

Func _HTMLToText($sString)
	Local $aReplace[6] = ['', '"', '&','<', '>',"'"]
	Local $aEntity[6] = ['', '&quot;', '&amp;', '&lt;', '&gt;',"&apos;"]
	For $iCC = 1 To UBound($aReplace) - 1
		$sString = StringReplace($sString, $aEntity[$iCC], $aReplace[$iCC])
	Next
	Return $sString
EndFunc
Func NewVid($Direction,$staticpos = 0)
$PlatformLabel = "N/A"
$Description = "N/A"
$PubDate = "N/A"
	GUICtrlSetData($InfoLabel,"Timeleft: N/A   Cache: N/A")
	If $Direction = 0 Then
	   If $GamelistNr > 0 Then
		$GamelistNr -= 1
		Endif
		ElseIF $Direction = 1 Then
	  $GamelistNr += 1
     ElseIF $Direction = 3 Then
	  $GamelistNr = 0
	   ElseIF $Direction = 4 Then
	    $GamelistNr = $staticpos
	 Endif
			If $Gamelistnr > Ubound($Gamelist) -1 Then
			$GamelistNr = 0
				Endif
			 ProcessClose($mplayerpid)
	$PlayerPageLink =_StringBetween($Gamelist[$GamelistNr],'<guid isPermaLink="false">','</guid>')
	$TrailerPic = _StringBetween($Gamelist[$GamelistNr],"<exInfo:image>","</exInfo:image>")
	InetGet($TrailerPic[0],@TempDir&"\GTplayerTrailerpic.jpg")
	GUICtrlSetImage($Pic1,@TempDir&"\GTplayerTrailerpic.jpg")
	$PlatformParse = _StringBetween($Gamelist[$GamelistNr],"<exInfo:platform>","</exInfo:platform>")
	$PlatformLabel = _HTMLToText($PlatformParse[0])
	$PubDateParse = _StringBetween($Gamelist[$GamelistNr],"<pubDate>","</pubDate>")
	$PubDate = _HTMLToText($PubDateParse[0])
	$DescriptionParse = _StringBetween($Gamelist[$GamelistNr],"<description>","</description>")
	$Description = _HTMLToText($DescriptionParse[0])
	GUICtrlSetData($DesCtrl,$Description)
	$Type = _StringBetween($Gamelist[$GamelistNr],'<type>','</type>')
	$GameName = _StringBetween($Gamelist[$GamelistNr],"<exInfo:gameName>","</exInfo:gameName>")
	$TrailerName = _StringBetween($Gamelist[$GamelistNr],"<exInfo:movieTitle>","</exInfo:movieTitle>")
	$GameName[0] = _HTMLToText($GameName[0])
	$TrailerName[0] = _HTMLToText($TrailerName[0])
	$GameVIDLink = GetLink($PlayerPageLink[0],$TrailerName[0],$Type[0])
	If @Error Then
		    GUICtrlSetData($GameNameLabel,"Game Name: "&$GameName[0])
		    GUICtrlSetData($TrailerTitelLabel,"Trailer Title: !! NOT AVAILABLE ATM !!")
		    GUICtrlSetColor($TrailerTitelLabel,0xFF0000)
			$FocusHandleG = _GUICtrlTreeView_FindItem($GameListTreeView,$GameName[0])
			$FocusHandleT = _GUICtrlTreeView_FindItem($FocusHandleG,$TrailerName[0])
			_GUICtrlTreeView_Expand($GameListTreeView,$FocusHandleG,True)
			$TIndex = _GUICtrlTreeView_Index($GameListTreeView,$FocusHandleT)
			_GUICtrlTreeView_SelectItemByIndex($GameListTreeView,$FocusHandleG,$TIndex)
	Else
		    GUICtrlSetColor($TrailerTitelLabel,0xFFFFFF)
			ProcessClose($mplayerpid)
			$mplayerpid = Run('mplayer.exe -quiet -slave -vo directx -nokeepaspect -double -wid '&$HandleAVI&' -colorkey 0x020202 -identify -cache 32000 -cache-min 10 -monitorpixelaspect 1 -volume 50 -osdlevel 0 -prefer-ipv4 -nocorrect-pts -slices -channels 2 '&$GameVIDLink, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)	
			GUICtrlSetData($GameNameLabel,"Game Name: "&$GameName[0])
			GUICtrlSetData($TrailerTitelLabel,"Trailer Title: "&$TrailerName[0])
			$FocusHandleG = _GUICtrlTreeView_FindItem($GameListTreeView,$GameName[0])
			$FocusHandleT = _GUICtrlTreeView_FindItem($FocusHandleG,$TrailerName[0])
			_GUICtrlTreeView_Expand($GameListTreeView,$FocusHandleG,True)
			$TIndex = _GUICtrlTreeView_Index($GameListTreeView,$FocusHandleT)
			_GUICtrlTreeView_SelectItemByIndex($GameListTreeView,$FocusHandleG,$TIndex)
			Endif
		EndFunc
		Func Search($SearchString)
			$SearchString = StringReplace($SearchString," ","+")
			$SearchSource = _InetGetSource($SearchString)
			$GamePageIDFilter = _StringBetween($SearchSource,'<div class="search_content_row_info_top_left">','<div class="gamepage_content_row_text">')
			If @Error Then
			 Return SetError(1)
			 Else
			$GamePageID = _StringBetween($GamePageIDFilter[0],'<a href="game/','.html" class="gamepage_content_row_title">')
			$RssFeed ='                                                    '&$GamePageID[0]&'&orderby=newest&limit=100'
	Return $RssFeed
	EndIf
EndFunc

		 
Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $tNMHDR, $hWndFrom, $iCode
   $hTreeView = GUICtrlGetHandle($GameListTreeView)
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = DllStructGetData($tNMHDR, "hWndFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hTreeView
            Switch $iCode
                Case $NM_DBLCLK
                    Local $tPOINT = DllStructCreate("int X;int Y")
                 
                   $tPoint = WinAPI_GetMousePos(True, $hTreeView)
                 
                    Local $iX = DllStructGetData($tPOINT, "X")
                    Local $iY = DllStructGetData($tPOINT, "Y")
					
                    Local $iItem = _GUICtrlTreeView_HitTestItem($hTreeView, $iX, $iY)
                    If $iItem <> 0 And _GUICtrlTreeView_Level($hTreeView, $iItem) = 1 Then 
                $index = _GUICtrlTreeView_GetItemParam($hTreeView, $iItem)
              NewVid(4,$index)
             EndIf
            EndSwitch
	EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc
Func WinAPI_GetMousePos($fToClient = False, $hWnd = 0)
	Local $iMode, $aPos, $tPoint

	$iMode = Opt("MouseCoordMode", 1)
	$aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)
	$tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	If $fToClient Then WinAPI_ScreenToClient($hWnd, $tPoint)
	Return $tPoint
EndFunc   ;==>_WinAPI_GetMousePos
Func WinAPI_ScreenToClient($hWnd, ByRef $tPoint)
	Local $aResult

	$aResult = DllCall("User32.dll", "int", "ScreenToClient", "hwnd", $hWnd, "ptr", DllStructGetPtr($tPoint))
	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_ScreenToClient
		   Func ExitFunc()
			DllClose($dll)
		EndFunc
		

Func _INetGetSourcePost($sURL, $sPost,$Referer) ; Author(s):        GtaSpider
    Local $iSocket, $sHeader, $sRecv, $iIP, $sHost, $aRegExp, $sHttp1,$iErr,$iSend,$aReturn[2]
   
    If $sURL = '' Or $sPost = '' Then Return SetError(1, 0, 0)
   
    If StringLeft($sURL, 7) <> 'http://' And StringLeft($sURL, 8) <> 'https://' Then $sURL = "http://" & $sURL
    If StringRight($sURL, 1) <> "/" Then $sURL &= "/"
   
    $aRegExp = StringRegExp($sURL, "http?://(.*?)/", 3)
    If @error Then Return SetError(2, 0, 0)
   
    $sHost = $aRegExp[0]
    If $sHost = '' Then Return SetError(3, 0, 0)
   
    $sHttp1 = StringTrimLeft($sURL,StringInStr($sURL,"/",-1,3)-1)
    If $sHttp1 = '' Then Return SetError(3, 0, 0)
   
    $sHeader = "POST " & $sHttp1 & " HTTP/1.1" & @CRLF & _
            "Host: " & $sHost & @CRLF & _
			"Referer: "&$Referer & @CRLF & _
			"Content-type: application/x-www-form-urlencoded"& @CRLF & _
            "Content-Length: " & StringLen($sPost) & @CRLF & @CRLF & $sPost
    TCPStartup() ;If not already done
    $iIP = TCPNameToIP($sHost)
    If $iIP = '' Or StringInStr($iIP, ".") = 0 Then Return SetError(4, 0, 0)
    $iSocket = TCPConnect($iIP, 80)
    If @error Or $iSocket < 0 Then Return SetError(5, 0, 0)
   
    $iSend = TCPSend($iSocket, $sHeader)
    If @error Or $iSend < 1 Then Return SetError(6, 0, 0)
   
   
    While 1
        $sRecv = TCPRecv($iSocket, 1024)
        $iErr = @error
        If $sRecv <> '' Then
            While 1
                $sRecv &= TCPRecv($iSocket, 1024)
                If @error Then ExitLoop 2
            WEnd
        EndIf
        If $iErr Then Return SetError(7,0,0)
    WEnd
   
    $aReturn[0] = StringLeft($sRecv,StringInStr($sRecv,@CRLF&@CRLF)-1)
    $aReturn[1] = StringTrimLeft($sRecv,StringLen($aReturn[0])+4)
	TCPShutdown()
    Return $aReturn
EndFunc   ;==>_INetGetSourcePost

Func GetLink($uid,$TrailerNchkHD,$typeExt = "flv")
	If StringinStr($TrailerNchkHD," HD ") Then
     $post = "hd=1&mid="&$uid
	 $Referer = "                                                     "
 Else
	 $post = "mid="&$uid
	 $Referer = "                                                   "
	Endif
	
$return = _INetGetSourcePost($urlserver,$post,$Referer)
$urlmid = _StringBetween($return[1],"filename=","&hasHD")
$urlmid[0] = StringReplace($urlmid[0],"%2F","/")
;$filename = StringSplit($urlmid[0],"/")

Return $trailerlinkstart&$urlmid[0]&"."&$typeExt
EndFunc