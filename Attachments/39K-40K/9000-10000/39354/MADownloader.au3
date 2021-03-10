#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#Include <File.au3>
#include <Constants.au3>
#include <Array.au3>

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
Global $config = @ScriptDir & "\setting.cfg"
Global $dlDir = IniRead($config,"settings","LibDir",@ScriptDir & "\Books")
Global $plugDir = @ScriptDir & "\Plugins\"
Global $langDir = @ScriptDir & "\Lang\"
Global $langFile = IniRead($config,"settings","LangFile","default.lang")
$lang = IniReadSection($langDir & $langFile,"MADownloader")
;-
$hGUI = GUICreate("MangAutoIt Downloader", 640, 460)
;GUISetBkColor(0x303030)
$bOpenUrl = GUICtrlCreateButton($lang[1][0],1,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\add.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[1][1])
$lblHwnd = GUICtrlCreateLabel("<- space reserve for taskbar buttons ->",35,4,315,15,$SS_CENTER)
GUICtrlSetState(-1,$GUI_DISABLE)
$bGetOne = GUICtrlCreateButton($lang[2][0],355,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\open.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[2][1])
$bGetAll = GUICtrlCreateButton($lang[3][0],385,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\saveto.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[3][1])
$bSched = GUICtrlCreateButton($lang[4][0],415,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\schedule.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[4][1])
GUICtrlCreateLabel("",451,0,2,30,$SS_SUNKEN)
GUICtrlSetState(-1,$GUI_DISABLE)
$bStart = GUICtrlCreateButton($lang[5][0],460,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\start.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[5][1])
$bPause = GUICtrlCreateCheckBox($lang[6][0],490,0,28,28,BitOr($BS_BITMAP,$BS_PUSHLIKE))
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\pauseOff.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[6][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$bStop = GUICtrlCreateButton($lang[7][0],520,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\stop.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[7][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$bRem = GUICtrlCreateButton($lang[8][0],550,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\cut.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[8][1])
$bClear = GUICtrlCreateButton($lang[9][0],580,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\refresh.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[9][1])
$bAbout = GUICtrlCreateButton($lang[10][0],610,0,28,28,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Downloader\Info.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[10][0] & " MADownloader")
$LV = GUICtrlCreateListView("",1,31,638,404,$LVS_NOSORTHEADER,$LVS_EX_FULLROWSELECT)
_GUICtrlListView_AddColumn(-1,$lang[11][1],60)
_GUICtrlListView_AddColumn(-1,$lang[12][1],100)
_GUICtrlListView_AddColumn(-1,$lang[13][1],180)
_GUICtrlListView_AddColumn(-1,$lang[14][1],100)
_GUICtrlListView_AddColumn(-1,$lang[15][1],80)
_GUICtrlListView_AddColumn(-1,$lang[16][1],60)
$StatusBar1 = _GUICtrlStatusBar_Create($hGUI)
Dim $StatusBar1_PartsWidth[2] = [120]
_GUICtrlStatusBar_SetParts($StatusBar1, $StatusBar1_PartsWidth)
_GUICtrlStatusBar_SetText($StatusBar1, $lang[19][0], 0)
_GUICtrlStatusBar_SetText($StatusBar1, "", 1)
GUISetState()
;-
$urlGUI = GUICreate($lang[23][1],415,55,10,10,$WS_CAPTION,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$hGUI)
GUICtrlCreateLabel($lang[17][0]&":",8,10,40,15)
$urlInput = GUICtrlCreateInput("",51,5,358,20)
GUICtrlCreateLabel($lang[17][1]&":",128,33,160,15)
$pluginCmb = GuiCtrlCreateCombo("",288,28,120,20)
$urlApply = GUICtrlCreateButton($lang[18][0],5,30,50,20)
GUICtrlSetState(-1,$GUI_DISABLE)
$urlCancel = GUICtrlCreateButton($lang[18][1],60,30,50,20)
$plugList = _FileListToArray($plugDir,"*.rgx",1)
If Not @error Then
	For $i = 1 To UBound($plugList)-1
		GUICtrlSetData($pluginCmb,$plugList[$i],$plugList[1])
	Next
Else
	MsgBox(16,$lang[23][0], "plugin file(s) not found" &@LF& "please check Plugins folder",0,$hGUI)
	Exit
EndIf
;-
While 1
	Switch GuiGetMsg()
		Case -3;$GUI_EVENT_CLOSE
			Exit
		Case -4;$GUI_EVENT_MINIMIZE
			TraySetState(1)
			TraySetToolTip("MangAutoIt Downloader")
			WinSetState($hGUI,"",@SW_HIDE)
		Case $bOpenUrl
			GUICtrlSetData($urlInput,"")
			GUICtrlSetState($urlInput,$GUI_FOCUS)
			GUISetState(@SW_SHOW,$urlGUI)
			GUISetState(@SW_DISABLE,$hGUI)
		Case $pluginCmb
			If StringLen(GUICtrlRead($urlInput)) > 0 Then
				GUICtrlSetState($urlApply,$GUI_ENABLE)
			EndIf
		Case $urlCancel
			GUISetState(@SW_HIDE,$urlGUI)
			GUISetState(@SW_ENABLE,$hGUI)
			WinActivate($hGUI)
		Case $urlApply
			$address = GUICtrlRead($urlInput)
			If StringLen($address) = 0 Then
				MsgBox(0, $lang[23][0] & "!",$lang[23][1],3,$urlGUI)
				GUICtrlSetState($urlInput,$GUI_FOCUS)
				GUICtrlSetState($urlApply,$GUI_DISABLE)
			Else
				GUICtrlSetState($bOpenUrl,$GUI_DISABLE)
				GUISetState(@SW_HIDE,$urlGUI)
				GUISetState(@SW_ENABLE,$hGUI)
				WinActivate($hGUI)
				$iPlg = GUICtrlRead($pluginCmb)
				$iSite = IniRead($plugDir & $iPlg,"PluginProperty","Site","")
				Ping($iSite)
				If Not @error Then
					_GUICtrlStatusBar_SetText($StatusBar1, $lang[19][1]&"...", 0)
					Process()
				Else
					MsgBox(0,$lang[24][0] & "!",$lang[24][1],5,$hGUI)
				EndIf
				_GUICtrlStatusBar_SetText($StatusBar1, $lang[19][0], 0)
				GUICtrlSetState($bOpenUrl,$GUI_ENABLE)
			EndIf
		Case $bGetOne
			If FileExists(@ScriptDir&"\temp.tmp") Then
				$sItemLV = FileRead(@ScriptDir&"\temp.tmp")
				GUICtrlCreateListViewItem($sItemLV,$LV)
				FileDelete(@ScriptDir&"\temp.tmp")
			Else
				MsgBox(0,$lang[25][0] & "!",$lang[25][1] & "!",0,$hGUI)
			EndIf
		Case $bGetAll
			If FileExists(@ScriptDir&"\temp.tmp") Then
				$max = _FileCountLines(@ScriptDir&"\temp.tmp")
				For $i = 1 To $max
					$sLVItems = FileReadLine(@ScriptDir&"\temp.tmp", $i)
					GUICtrlCreateListViewItem($sLVItems,$LV)
				Next
				FileDelete(@ScriptDir&"\temp.tmp")
			Else
				MsgBox(0,$lang[25][0] & "!",$lang[25][1] & "!",0,$hGUI)
			EndIf	
		Case $bSched
			MsgBox(0,$lang[4][0],"Not available yet!",0,$hGUI)
		Case $bStart			
			$iPlg = _GUICtrlListView_GetItemText($LV,0,4)
			$iSite = IniRead($plugDir & $iPlg,"PluginProperty","Site","")
			Ping($iSite)
			If Not @error Then
				GUICtrlSetState($bStart,$GUI_DISABLE)
				GUICtrlSetState($bRem,$GUI_DISABLE)
				GUICtrlSetState($bClear,$GUI_DISABLE)
				GUICtrlSetState($bPause,$GUI_ENABLE)
				GUICtrlSetState($bStop,$GUI_ENABLE)
				$lvId = 0
				Downloading()
			Else
				MsgBox(0,$lang[24][0] & "!",$lang[24][1],5,$hGUI)
			EndIf						
		Case $bRem
			_GUICtrlListView_DeleteItemsSelected($LV)
		Case $bClear
			$Clrs = MsgBox(1,$lang[9][0],$lang[9][1]&"?")
			If $Clrs = 1 Then
				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($LV))
				_GUICtrlStatusBar_SetText($StatusBar1, $lang[19][0], 0)
			EndIf
		Case $bAbout
			MsgBox(0,$lang[10][0] & " MADownloader","     = MangAutoIt Downloader =" & @LF & @LF & "Download manager " & $lang[10][1] & " MangAutoIt",0,$hGUI)
	EndSwitch
	Switch TrayGetMsg()
		Case $TRAY_EVENT_PRIMARYDOUBLE
			TraySetState(2)
			GUISetState(@SW_RESTORE,$hGUI)
	EndSwitch
Wend
;-
Func Downloading()
_GUICtrlStatusBar_SetText($StatusBar1, $lang[19][1]&"...", 0)	
_GUICtrlListView_SetItem($LV,"0%",$lvId,5)
$chDir = _GUICtrlListView_GetItemText($LV,$lvId,0)
$chName = _GUICtrlListView_GetItemText($LV,$lvId,1)
$iUrl = _GUICtrlListView_GetItemText($LV,$lvId,2)
$titleDir = _GUICtrlListView_GetItemText($LV,$lvId,3)
_GUICtrlStatusBar_SetText($StatusBar1, $lang[21][0]&" " & $titleDir, 1)
$nPlg = _GUICtrlListView_GetItemText($LV,$lvId,4)
Local $uDrv, $uDir, $uFName, $uExt
$urlPath = _PathSplit($iUrl, $uDrv, $uDir, $uFName, $uExt)
$DlImgsRegx = IniRead($plugDir & $nPlg,"DataRegExp","ImageSrc","")
$DlTotRegx = IniRead($plugDir & $nPlg,"DataRegExp","SrcTotal","")
$imgSrc = BinaryToString(InetRead($iUrl))
$totSrc = StringRegExp($imgSrc,$DlTotRegx,1)
Dim $imgsUrlArr[1]
For $n = 1 To $totSrc[0]
	$nextSrc = BinaryToString(InetRead($uDir & $n & $uExt))
	Do
		Sleep(500)
	Until $nextSrc
	$dlImgGet = StringRegExp($nextSrc,$DlImgsRegx,1)	
	_ArrayAdd($imgsUrlArr,$dlImgGet[0])
Next
_GUICtrlStatusBar_SetText($StatusBar1, $lang[20][0]&"...", 0)
_GUICtrlStatusBar_SetText($StatusBar1, Ubound($imgsUrlArr)-1 & " " & $lang[21][0] & " " & $titleDir & " " & $lang[21][1] & " " &$chDir, 1)
If Not FileExists($dlDir&"\"&$titleDir) Then
	DirCreate($dlDir&"\"&$titleDir)
	Sleep(10)
EndIf
DirCreate($dlDir&"\"&$titleDir&"\"&$chDir)
Sleep(10)
IniWriteSection($dlDir&"\"&$titleDir&"\"&$chDir&"\chapter.ini","chapter","Index="&$chDir  & @LF & "Title="&$chName)
Local $szDrive, $szDir, $szFName, $szExt
For $s = 1 To Ubound($imgsUrlArr)-1
	_PathSplit($imgsUrlArr[$s], $szDrive, $szDir, $szFName, $szExt)
	If StringLen($szFName) < 2 Then
		$szFName = "00" & $szFName
	ElseIf StringLen($szFName) < 3 Then
		$szFName = "0" & $szFName		
	EndIf
	$Download = InetGet($imgsUrlArr[$s],$dlDir&"\"&$titleDir&"\"&$chDir&"\"&$szFName&$szExt,0,1)
	While $Download;Do
		Sleep(500)
		If InetGetInfo($Download,2) Then
			ExitLoop
		Else
			Switch GuiGetMsg()
				Case -3
					$s = Ubound($imgsUrlArr)-1
					InetClose($Download)
					$lvId = -2
					ExitLoop
					Exit
				Case -4
					TraySetState(1)
					WinSetState($hGUI,"",@SW_HIDE)
				Case $bStop
					$s = Ubound($imgsUrlArr)-1
					InetClose($Download)
					$lvId = -2
					Stop()
					_GUICtrlStatusBar_SetText($StatusBar1, $lang[22][0], 0)
					ExitLoop
				Case $bPause
					If BitAnd(GUICtrlRead($bPause),$GUI_CHECKED) = $GUI_CHECKED Then
						GUICtrlSetImage($bPause,@ScriptDir & "\Skins\Downloader\pauseOn.bmp")
						_GUICtrlStatusBar_SetText($StatusBar1, $lang[22][1], 0)
						Pause()
					EndIf
			EndSwitch
			Switch TrayGetMsg()
				Case $TRAY_EVENT_PRIMARYDOUBLE
				TraySetState(2)
				GUISetState(@SW_RESTORE,$hGUI)
			EndSwitch
		EndIf
	WEnd;Until InetGetInfo($Download,2)
	_GUICtrlListView_SetItem($LV,Round(($s*100)/Ubound($imgsUrlArr)-1)&"%",$lvId,5)
	TraySetToolTip($lang[20][0] & "... " & @LF & $chDir &" - "& Round(($s*100)/Ubound($imgsUrlArr)-1)&"%" & @LF & $titleDir)
Next
_GUICtrlListView_SetItem($LV,"100%",$lvId,5)
TraySetToolTip($titleDir & @LF & $chDir & " "& $lang[20][1])
$lvId = ($lvId + 1)
$aInfo = _GUICtrlListView_GetItemText($LV,$lvId,0)
If StringLen($aInfo) > 0 Then	
	Downloading()
Else
	InetClose($Download)
	Stop()
	_GUICtrlStatusBar_SetText($StatusBar1, $lang[19][0], 0)
	_GUICtrlStatusBar_SetText($StatusBar1, $lang[20][1], 1)
EndIf
EndFunc
;-
Func Stop()
GUICtrlSetState($bStart,$GUI_ENABLE)
GUICtrlSetState($bRem,$GUI_ENABLE)
GUICtrlSetState($bClear,$GUI_ENABLE)
GUICtrlSetState($bPause,$GUI_DISABLE)
GUICtrlSetState($bStop,$GUI_DISABLE)
EndFunc
;-
Func Pause()
MsgBox(0,$lang[22][1],"Download paused...",0,$hGUI)
GUICtrlSetState($bPause,$GUI_UNCHECKED)
GUICtrlSetImage($bPause,@ScriptDir & "\Skins\Downloader\pauseOff.bmp")
_GUICtrlStatusBar_SetText($StatusBar1, $lang[20][0] & "...", 0)
EndFunc
;-
Func Process()
$TitleRegx = IniRead($plugDir & $iPlg,"InfoRegExp","CoverTitle","")
$ChpLinkRegx = IniRead($plugDir & $iPlg,"DataRegExp","ChapterLink","")
$ChpNameRegx = IniRead($plugDir & $iPlg,"DataRegExp","ChapterTitle","")
$bSrc = BinaryToString(InetRead($address),4)
$titleStr = StringRegExp($bSrc, $TitleRegx,1)
If Not @error Then
	$title = StringRegExpReplace($titleStr[0],'\sManga|\sManhwa|\sManhua|\s\(Original\sWork\)|\-',"")
Else
	$title = ""
EndIf
$ChpStrlst = StringRegExp($bSrc, $ChpLinkRegx,3)
Dim $adressNumArr[1]
Dim $adressArr[1]
for $a = 0 to ubound($chpStrlst)-2 step 2
	If Not StringInStr($chpStrlst[$a],$iSite) Then
		_ArrayAdd($adressArr,"http://" & $iSite & $chpStrlst[$a])
	Else
		_ArrayAdd($adressArr,$chpStrlst[$a])
	EndIf
	If StringInStr($chpStrlst[$a+1],"One Shot") Then
		_ArrayAdd($adressNumArr,"1")
	Else
		_ArrayAdd($adressNumArr,$chpStrlst[$a+1])
	EndIf
Next
Dim $numArr[1]
$jPfx = ""
for $j = 1 to ubound($adressNumArr)-1
	If $adressNumArr[$j] < 10 Then
		$jPfx = "00"
	ElseIf $adressNumArr[$j] < 100 Then
		$jPfx = "0"
	Else
		$jPfx = ""
	EndIf
	_ArrayAdd($numArr,$jPfx & $adressNumArr[$j])
Next
$chpNamelst = StringRegExp($bSrc, $ChpNameRegx,3)
If IsArray($chpNamelst) = 0 Then
	Dim $chpNamelst[1]
	$chpNamelst[0] = "1"
	_ArrayAdd($chpNamelst,"")
EndIf
If StringCompare($chpNamelst[Ubound($chpNamelst)-2],"1") Then
	_ArrayAdd($chpNamelst,"1")
	_ArrayAdd($chpNamelst,"")
EndIf
Dim $nameArr[1]
$nPfx = ""
for $n = 0 to ubound($chpNamelst)-2 step 2
	If StringInStr($chpNamelst[$n],"One Shot") Then
		$nPfx = "001 "
	ElseIf $chpNamelst[$n] < 10 Then
		$nPfx = "00"
	ElseIf $chpNamelst[$n] < 100 Then
		$nPfx = "0"
	Else
		$nPfx = ""
	EndIf
	$chpNamelst[$n+1] = StringRegExpReplace($chpNamelst[$n+1],'&quot;','"')
	$chpNamelst[$n+1] = StringRegExpReplace($chpNamelst[$n+1],'&amp;','&')
	$nData = $nPfx & $chpNamelst[$n]&" "&$chpNamelst[$n+1]
	_ArrayAdd($nameArr,$nData)
Next
For $t = 1 to ubound($numArr)-1
	If StringLen($numArr[$t]) > 3 Then
		$comp = StringCompare($numArr[$t],StringLeft($nameArr[$t],5))
		If Not $comp=0 Then
			_ArrayInsert($nameArr,$t,$numArr[$t])
		EndIf
		GUICtrlCreateListViewItem("c" & $numArr[$t]&"|"&StringTrimLeft($nameArr[$t],6)&"|"&$adressArr[$t]&"|"&$title&"|"&$iPlg,$LV)
	Else
		$comp = StringCompare($numArr[$t],StringLeft($nameArr[$t],3))
		If Not $comp=0 Then
			_ArrayInsert($nameArr,$t,$numArr[$t])
		EndIf
		GUICtrlCreateListViewItem("c" & $numArr[$t]&"|"&StringTrimLeft($nameArr[$t],4)&"|"&$adressArr[$t]&"|"&$title&"|"&$iPlg,$LV)
	EndIf
Next
EndFunc