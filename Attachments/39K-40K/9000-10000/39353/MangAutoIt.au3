#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <SliderConstants.au3>
#include <EditConstants.au3>
#Include <File.au3>
#include <IE.au3>
#include <Misc.au3>
#Include <Array.au3>
;-
FileInstall("nullCover.gif", @ScriptDir & "\", 0)
FileInstall("hello.gif", @ScriptDir & "\", 0)
;-
Dim $rHTML,$c
Global $fldchsd,$wmpnFile,$lastPlg,$lastFld,$langFile
Global $oIE_M = ObjCreate("shell.Explorer.2")
Global $config = @ScriptDir & "\setting.cfg"
Global $plugDir = @ScriptDir & "\Plugins\"
Global $langDir = @ScriptDir & "\Lang\"
Global $noCvr = @ScriptDir & "\nullCover.gif"
Global $GUIheight = @DesktopHeight-60
$img = @ScriptDir & "\hello.gif"
LoadLanguage()
$lang = IniReadSection($langDir & $langFile,"MangAutoIt")
;-
$mainGUI = GUICreate("MangAutoit BETA", 800, $GUIheight,-1,-1,$WS_OVERLAPPEDWINDOW)
$Bwmp = GUICtrlCreateCheckbox("Wmp",0,0,36,36,BitOR($BS_PUSHLIKE,$BS_ICON))
GUICtrlSetImage(-1,"wmploc.dll",-1)
GUICtrlSetCursor(-1, 0)
$Lib = GUICtrlCreateCheckbox($lang[1][0],36,0,36,36,BitOR($BS_PUSHLIKE,$BS_ICON))
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Reader\bookshelf.ico")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[1][1])
$Opt = GUICtrlCreateCheckbox($lang[2][0],72,0,36,36,BitOR($BS_PUSHLIKE,$BS_ICON))
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Reader\option.ico")
GUICtrlSetCursor (-1, 0)
GUICtrlSetTip(-1, $lang[2][1])
$BtColor = GUICtrlCreateCheckbox($lang[3][0],108,0,36,36,BitOR($BS_PUSHLIKE,$BS_ICON))
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Reader\color.ico")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[3][1])
$BtAbout = GUICtrlCreateCheckbox("About",144,0,36,36,BitOR($BS_PUSHLIKE,$BS_ICON))
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Reader\about.ico")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "About MangAutoit")
$LblTitle = GUICtrlCreateLabel("",250,1,300,42,$SS_CENTER)
GUICtrlSetColor(-1, 0x0080FF)
$LblChapter = GUICtrlCreateLabel("",200,50,400,24,$SS_CENTER)
GUICtrlSetFont(-1,14)
GUICtrlSetColor(-1, 0xC00080)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
$LblIndex = GUICtrlCreateLabel("",50,69,100,20)
GUICtrlSetFont(-1,12)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
$Cmb1 = GUICtrlCreateCombo("-none-",50,42,88,22,BitOR($CBS_DROPDOWNLIST,$CBS_DISABLENOSCROLL))
GUICtrlSetCursor(-1, 0)
GUICtrlSetBkColor(-1, 0x303030)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
$pgLbl = GUICtrlCreateLabel("",142,47,43,17)
GUICtrlSetFont(-1,10)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
$lumSldr = GUICtrlCreateSlider(624, 10, 100, 30, BitOR($TBS_BOTH, $TBS_NOTICKS))
GUICtrlSetCursor(-1, 0)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
GUICtrlSetLimit(-1, 6, 0)
GUICtrlSetData(-1,6)
GUICtrlSetState(-1,$GUI_DISABLE)
$lumSldrPos_Last = GUICtrlRead($lumSldr)
$iLum = ($lumSldrPos_Last*10)+40
GUICtrlSetTip(-1, $lang[54][1] & ": "&$iLum&"%")
$zoomSldr = GUICtrlCreateSlider(624, 40, 100, 30, BitOR($TBS_BOTH, $TBS_NOTICKS))
GUICtrlSetCursor(-1, 0)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
GUICtrlSetLimit(-1, 16, 1)
GUICtrlSetData(-1,6)
GUICtrlSetState(-1,$GUI_DISABLE)
$zoomSldrPos_Last = GUICtrlRead($zoomSldr)
$iZoom = ($zoomSldrPos_Last*10)+40
GUICtrlSetTip(-1, $lang[54][0] & ": "&$iZoom&"%")
$BtL = GUICtrlCreateButton($lang[4][0],0,40,40,30,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Reader\back.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[4][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$BtR = GUICtrlCreateButton($lang[5][0],760,40,40,30,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Reader\forward.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetResizing(-1,$GUI_DOCKTOP)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[5][1])
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateObj($oIE_M, 1, 90, 798, $GUIheight-90)
GUICtrlSetResizing(-1,$GUI_DOCKBORDERS)
;Dim $AccelKeys[2][2] = [["{LEFT}", $BtL], ["{RIGHT}", $BtR]]
;GUISetAccelerators($AccelKeys)
;-
;HotKeySet("{LEFT}","PrevPage")
;HotKeySet("{RIGHT}","NextPage")
$oIE_M.navigate("about:blank")
_buildHTML()
GUISetState()
;-
$LibGUI = GUICreate($lang[1][1], 640, 480,80,70,$WS_CAPTION,$WS_EX_MDICHILD,$mainGUI)
$LibClose = GUICtrlCreateButton($lang[6][0],535,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[6][1])
GUICtrlCreateTab(1, 0, 638, 22)
GUICtrlCreateTabItem($lang[7][1])
$LibBox = GUICtrlCreateList("",2,27,200,460)
GUICtrlCreateLabel($lang[8][1] & " :",220,30,50,15)
$nfoAlt = GUICtrlCreateLabel("",280,30,190,52)
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateLabel($lang[9][1] & " :",220,95,50,15)
$nfoSts = GUICtrlCreateLabel("",280,95,50,15)
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateLabel($lang[10][1] & " :",340,95,70,15)
$nfoRls = GUICtrlCreateLabel("",420,95,50,15)
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateLabel($lang[11][1] & " :",220,120,50,15)
$nfoAut = GUICtrlCreateLabel("",280,120,190,15)
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateLabel($lang[12][1] & " :",220,145,50,15)
$nfoArt = GUICtrlCreateLabel("",280,145,190,15)
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateLabel($lang[13][1] & " :",220,170,260,15)
$nfoGen = GUICtrlCreateLabel("",280,170,190,45)
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateLabel($lang[14][1] & " :",220,225,50,15)
$nfoRvw = GUICtrlCreateEdit("",220,245,408,146,BitOr($ES_MULTILINE,$ES_READONLY,$WS_VSCROLL))
GUICtrlSetColor(-1, 0x000080)
GUICtrlCreateLabel($lang[15][1] & " :",220,415,78,15)
$nfoLtc = GUICtrlCreateLabel("",300,415,56,17,BitOr($SS_SUNKEN,$SS_CENTER))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x303030)
$CvrImg = GUICtrlCreatePic("",478,27,150,213)
GuiCtrlSetState(-1,$GUI_DISABLE)
$nfoRefBtn = GUICtrlCreateButton($lang[16][0],360,413,50,20)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[16][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$nfoLink = GUICtrlCreateLabel("",220,393,363,20)
GUICtrlSetFont(-1, 9, 400, 4)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[17][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$nfoClipBtn = GUICtrlCreateButton($lang[18][0],588,393,40,20)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[18][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$LibRead = GUICtrlCreateButton($lang[19][0],220,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[19][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$LibDel = GUICtrlCreateButton($lang[20][0],320,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[20][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$LibNfoChp = GUICtrlCreateButton($lang[21][0],420,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[21][1])
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateTabItem($lang[22][0])
$Cmb2 = GUICtrlCreateCombo("-none-",2,30,110,22,$CBS_DROPDOWNLIST)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[23][1])
$input = GUICtrlCreateInput($lang[52][1],126,30,470,22)
$search = GUICtrlCreateButton($lang[22][1],598,30,40,22,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Reader\go.bmp")
GUICtrlSetCursor(-1, 0)
$linkBox = GUICtrlCreateList("",1,60,336,370)
GUICtrlCreateGroup($lang[24][1],339,80,298,350)
$dPrgr = GUICtrlCreateProgress(343,60,290,15)
$DlBox = GUICtrlCreateList("",343,100,290,320)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$LibDownload = GUICtrlCreateButton($lang[25][0],10,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[25][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$LibClip = GUICtrlCreateButton($lang[26][0],110,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[26][1])
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateTabItem($lang[27][1])
$LibLV = GUICtrlCreateListView("",1,22,638,404,$LVS_NOSORTHEADER,$LVS_EX_FULLROWSELECT)
_GUICtrlListView_AddColumn(-1,$lang[28][1],60)
_GUICtrlListView_AddColumn(-1,$lang[29][1],175)
_GUICtrlListView_AddColumn(-1,$lang[30][1],220)
_GUICtrlListView_AddColumn(-1,$lang[31][1],100)
_GUICtrlListView_AddColumn(-1,$lang[32][1],80)
$LibStart = GUICtrlCreateButton($lang[33][0],5,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[33][1])
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateGroup($lang[34][1] & " :",110,430,210,45)
$LibAddAll = GUICtrlCreateButton($lang[35][0],115,445,100,28)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[35][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$LibAddOne = GUICtrlCreateButton($lang[36][0],215,445,100,28)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[36][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$LibRemAll = GUICtrlCreateButton($lang[37][0],325,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[37][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$LibRemOne = GUICtrlCreateButton($lang[38][0],425,440,100,33)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[38][1])
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;-
$ChpGUI = GUICreate("", 300, 240,270,60,$WS_CAPTION,$WS_EX_MDICHILD,$LibGUI)
$ChpBox = GUICtrlCreateList("",0,0,300,201)
$ChpOK = GUICtrlCreateButton($lang[39][0],22,208,65,25)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[39][1])
GUICtrlSetState(-1,$GUI_DISABLE)
$ChpCancel = GUICtrlCreateButton($lang[40][0],216,208,65,25)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, $lang[40][1])
;-
$OptGUI = GUICreate($lang[2][1], 400, 277,200,100,$WS_CAPTION,$WS_EX_MDICHILD,$mainGUI)
GUICtrlCreatePic(@ScriptDir&"\about.jpg",0,0,90,277)
GuiCtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateLabel($lang[41][0] & " :",234,8,60,17)
GUICtrlCreateLabel($lang[41][1],94,8,130,17);,$SS_RIGHT)
GUICtrlSetColor(-1, 0xFF0000)
$cmbLang = GUICtrlCreateCombo("",294,5,100,22)
GUICtrlCreateLabel($lang[42][1],94,48,198,17)
$FldSet = GUICtrlCreateInput("",93,65,268,22)
$OptBrw = GUICtrlCreateButton("...",364,65,30,22)
GUICtrlSetCursor(-1, 0)
GUICtrlCreateLabel($lang[43][1] & " :",93,145,80,17)
$plgBox = GUICtrlCreateListView("",93,165,303,68,$LVS_NOSORTHEADER)
_GUICtrlListView_AddColumn($plgBox,$lang[44][1],120)
_GUICtrlListView_AddColumn($plgBox,$lang[45][1],175)
$OptApply = GUICtrlCreateButton($lang[46][1],110,237,100,33)
GUICtrlSetCursor(-1, 0)
$OptCancel = GUICtrlCreateButton($lang[40][0],278,237,100,33)
GUICtrlSetCursor(-1, 0)
LoadSettings($config)
_LibCount()
;-
$colGUI = GUICreate("Color",160,158,92,36,$WS_CAPTION,$WS_EX_MDICHILD,$mainGUI)
GUICtrlCreateLabel("Background color :", 4, 10, 100, 17)
$bgCol = GUICtrlCreateLabel("", 135, 9, 17, 17, $SS_SUNKEN)
GUICtrlSetCursor(-1, 0)
$bgclr = 0xECE9D8
$ttlLbl = GUICtrlCreateLabel("Title color :", 4, 40, 100, 17)
$ttlclr = 0x0080FF
GUICtrlSetColor(-1, $ttlclr)
$ttlCol = GUICtrlCreateLabel("", 135, 39, 17, 17, $SS_SUNKEN)
GUICtrlSetBkColor(-1, $ttlclr)
GUICtrlSetCursor(-1, 0)
$sttlLbl = GUICtrlCreateLabel("Sub Title color :", 4, 70, 100, 17)
$sttlclr = 0xC00080
GUICtrlSetColor(-1, $sttlclr)
$sttlCol = GUICtrlCreateLabel("", 135, 69, 17, 17, $SS_SUNKEN)
GUICtrlSetBkColor(-1, $sttlclr)
GUICtrlSetCursor(-1, 0)
$indxLbl = GUICtrlCreateLabel("Index color :", 4, 100, 100, 17)
$indxclr = 0x000000
GUICtrlSetColor(-1, $indxclr)
$indxCol = GUICtrlCreateLabel("", 135, 99, 17, 17, $SS_SUNKEN)
GUICtrlSetBkColor(-1, $indxclr)
GUICtrlSetCursor(-1, 0)
$colApply = GUICtrlCreateButton("Apply",5,130,70,20)
$colCancel = GUICtrlCreateButton("Cancel",85,130,70,20)
;-
$wmpGUI = GUICreate("Media Player",160,188,2,66,$WS_CAPTION,$WS_EX_MDICHILD,$mainGUI)
GUISetBkColor(0x000000)
$wmp = _wmpcreate(1, 0, 0, 164, 164)
$wmpShuffle = GUICtrlCreateCheckbox("<>",0,165,20,22,BitOr($BS_PUSHLIKE,$BS_BITMAP))
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Player\shuffleOff.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Shuffle")
$wmpRepeat = GUICtrlCreateCheckbox("@",20,165,20,22,BitOr($BS_PUSHLIKE,$BS_BITMAP))
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Player\repeatOff.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Repeat")
$wmpPrev = GUICtrlCreateButton("|<",60,165,20,22,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Player\prev.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Previous")
$wmpNext = GUICtrlCreateButton(">|",80,165,20,22,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Player\next.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Next")
$wmpOpen = GUICtrlCreateButton("...",140,165,20,22,$BS_BITMAP)
GUICtrlSetImage(-1,@ScriptDir & "\Skins\Player\open.bmp")
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Open Media file")
;-
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit
	Switch $msg
		Case $BtR
			If BitAND(GUICtrlGetState($BtL),$GUI_DISABLE) = $GUI_DISABLE Then
				GUICtrlSetState($BtL,$GUI_ENABLE)
			EndIf
			$p = $p + 1
			If $p = Ubound($imgList)-1 Then
				If $c = Ubound($chpList)-1 Then
					GUICtrlSetState($BtR,$GUI_DISABLE)
				Else
					GUICtrlSetState($BtR,$GUI_ENABLE)
				EndIf
			ElseIf $p > Ubound($imgList)-1 Then
				$c = $c + 1
				_PageCountRefresh()
				$p = 1
			EndIf
			_Refresh()
		Case $BtL
			If BitAND(GUICtrlGetState($BtR), $GUI_DISABLE) = $GUI_DISABLE Then
				GUICtrlSetState($BtR,$GUI_ENABLE)
			EndIf
			$p = $p - 1
			If $p = 1 Then
				If $c > 1 Then
					GUICtrlSetState($BtL,$GUI_ENABLE)
				Else
					GUICtrlSetState($BtL,$GUI_DISABLE)
				EndIf
			ElseIf $p < 1 Then
				$c = $c - 1
				_PageCountRefresh()
				$p = Ubound($imgList)-1
			EndIf
			_Refresh()
		Case $Cmb1
			$p = StringTrimLeft(GUICtrlRead($Cmb1),StringLen($lang[55][0])+2)
			$img = $FldDir &"\"& $lastFld &"\"& $chpList[$c] &"\"& $imgList[$p]
			If $p = Ubound($imgList)-1 Then
				If $c < Ubound($chpList)-1 Then
					GUICtrlSetState($BtR,$GUI_ENABLE)
				ElseIf $c = Ubound($chpList)-1 Then
					GUICtrlSetState($BtR,$GUI_DISABLE)
				EndIf
			ElseIf $p = 1 Then
				If $c > 1 Then
					GUICtrlSetState($BtL,$GUI_ENABLE)
				ElseIf $c = 1 Then
					GUICtrlSetState($BtL,$GUI_DISABLE)
				EndIf
			Else
				GUICtrlSetState($BtR,$GUI_ENABLE)
				GUICtrlSetState($BtL,$GUI_ENABLE)
			EndIf
			_updateHTML()
		Case $zoomSldr
			$zoomSldrPos = GUICtrlRead($zoomSldr)
			$zoomSldrPos_Last = $zoomSldrPos
			$iZoom = ($zoomSldrPos*10)+40
			GUICtrlSetTip($zoomSldr, $lang[54][0] & ": "&$iZoom&"%")
			_updateHTML()
		Case $lumSldr
			$lumSldrPos = GUICtrlRead($lumSldr)
			$lumSldrPos_Last = $lumSldrPos
			$iLum = ($lumSldrPos*10)+40
			GUICtrlSetTip($lumSldr, $lang[54][1] & ": "&$iLum&"%")
			_updateHTML()
		Case $Lib
			GUISetState(@SW_SHOW,$LibGUI)
			GUISetState(@SW_DISABLE,$mainGUI)
		Case $LibClose
			GUICtrlSetState($Lib,$GUI_UNCHECKED)
			GUISetState(@SW_HIDE,$LibGUI)
			GUISetState(@SW_ENABLE,$mainGUI)
			WinActivate($mainGUI)			
		Case $LibBox
			$fldSlct = GUICtrlRead($LibBox)
			If FileExists($FldDir &"\"& $fldSlct &"\Cover\Cover.jpg") Then
				GUICtrlSetImage($CvrImg,$FldDir &"\"& $fldSlct &"\Cover\Cover.jpg")
			Else
				GUICtrlSetImage($CvrImg,$noCvr)
			EndIf
			$info = IniReadSection($FldDir &"\"& $fldSlct &"\Cover\info.ini", "Info")
			If @error Then
				_nullInfo()
				MsgBox(48, "info.ini File", $lang[49][0] & " " & $lang[49][1],0,$LibGUI)
			Else
				_ReadInfo()
			EndIf
			GUICtrlSetState($nfoRefBtn,$GUI_ENABLE)
			GUICtrlSetState($nfoLink,$GUI_ENABLE)
			GUICtrlSetState($nfoClipBtn,$GUI_ENABLE)
			GUICtrlSetState($LibRead,$GUI_ENABLE)
			GUICtrlSetState($LibDel,$GUI_ENABLE)
			GUICtrlSetState($LibNfoChp,$GUI_ENABLE)			
		Case $nfoRefBtn
			$fldSlct = GUICtrlRead($LibBox)
			$nfoltstChp = IniRead($FldDir &"\"& $fldSlct &"\Cover\info.ini","Info","LatestChapter","")
			$plgUsed = IniRead($FldDir &"\"& $fldSlct &"\Cover\info.ini","Info","Plugin","")
			$nfoUrl = IniRead($FldDir &"\"& $fldSlct &"\Cover\info.ini","Info","Url","")
			$rgxStts = IniRead($plugDir &"\"& $plgUsed,"InfoRegExp","Status","")
			$rgxChpt = IniRead($plugDir &"\"& $plgUsed,"DataRegExp","ChapterLink","")
			GUICtrlSetState($nfoRefBtn,$GUI_DISABLE)
			Ping("www.google.com")
			If Not @error Then
				$cSrc = BinaryToString(InetRead($nfoUrl))
				$ChpStrlst = StringRegExp($cSrc, $rgxChpt,1)
				If $ChpStrlst[1] > $nfoltstChp Then
					$newStts = StringRegExp($cSrc, $rgxStts,1)
					IniWrite($FldDir &"\"& $fldSlct &"\Cover\info.ini","Info","LatestChapter",$ChpStrlst[1])
					MsgBox(48,$lang[47][0],$lang[47][1] & " = " & $ChpStrlst[1] & @CRLF & "Status = " & $newStts[0],5,$LibGUI)
					GUICtrlSetData($nfoLtc,$ChpStrlst[1])
					If Not StringCompare($newStts[0],$rgxStts) = 0 Then
						IniWrite($FldDir &"\"& $fldSlct &"\Cover\info.ini","Info","Status",$newStts[0])
					EndIf
				ElseIf $ChpStrlst[1] = $nfoltstChp Then
					MsgBox(0,$lang[48][0],$lang[48][1],3,$LibGUI)
				EndIf
			Else
				MsgBox(48,$lang[50][0],$lang[50][1],0,$LibGUI)
			EndIf
			GUICtrlSetState($nfoRefBtn,$GUI_ENABLE)
		Case $nfoLink
			ShellExecute(GUICtrlRead($nfoLink))
		Case $nfoClipBtn
			ClipPut(GUICtrlRead($nfoLink))
		Case $LibRead
			WinSetTitle($ChpGUI,"",$fldSlct & " " & $lang[24][0] & ":")
			GUISetState(@SW_SHOW,$ChpGUI)
			GUISetState(@SW_DISABLE,$LibGUI)
			GUICtrlSetState($zoomSldr,$GUI_ENABLE)
			GUICtrlSetState($lumSldr,$GUI_ENABLE)
			_ChpCount()
		Case $LibDel
			$fldSlct = GUICtrlRead($LibBox)
			$delMsg = MsgBox(4,$lang[20][0] & "?",'"' & $fldSlct & '"' & @LF & @LF & $lang[51][0] & @LF & $lang[51][1],0,$LibGUI)
			If $delMsg = 6 Then
				FileRecycle($FldDir &"\"& $fldSlct)
				GUICtrlSetData($LibBox,"")
				_LibCount()
			EndIf
		Case $LibNfoChp
			MsgBox(48,"Coming Soon!","To Do List")
		Case $Cmb2
			$siteSlct = GUICtrlRead($Cmb2)
			If StringCompare($siteSlct,$lastPlg) Then
				$lastPlg = $siteSlct
				GUICtrlSetData($linkBox,"")
			EndIf
		Case $search
			$mString = GUICtrlRead($input)
			If StringLen($mString) = 0 Then
				GUICtrlSetData($input,$lang[52][1])
				GUICtrlSetState($input,$GUI_FOCUS)	
			ElseIf $mString = $lang[52][1] Then	
				GUICtrlSetState($input,$GUI_FOCUS)
			Else
				$mUrl = StringReplace($mString, " ", "+")
				$mName = StringReplace($mString, " ", "\S+")
				$nameSite = IniRead($plugDir & $lastPlg,"PluginProperty","Site","")
				$sUrl = IniRead($plugDir & $lastPlg,"PluginProperty","SearchUrl","")
				$bUrl = IniRead($plugDir & $lastPlg,"PluginProperty","DataUrl","")
				$eUrl = IniRead($plugDir & $lastPlg,"PluginProperty","UrlEnd","")
				If $sUrl = "" Then
					msgbox(48,$lang[49][0],"Search Url not found")
				Else
					GUICtrlSetState($search,$GUI_DISABLE)
					Ping($nameSite)
					If NOT @Error Then
						GUICtrlSetData($dPrgr, 30)
						GUICtrlSetData($linkBox, "")
						$sSrc = BinaryToString(InetRead($sUrl & $mUrl))
						$aValidLinks = StringRegExp($sSrc, '"('&$bUrl&'?\S+'&$mName&'?\S+'&$eUrl&'|'&$bUrl&$mName&'?\S+'&$eUrl&')"',3)
						If NOT @Error Then
							GUICtrlSetData($dPrgr, 65)
							For $i = 0 To Ubound($aValidLinks) -1
								GUICtrlSetData($linkBox,$aValidLinks[$i])
							Next
							Set_progress()
						EndIf						
					Else
						MsgBox(0,$lang[50][0],$lang[50][1],0,$LibGUI)
					EndIf
					GUICtrlSetState($search,$GUI_ENABLE)
				EndIf
			EndIf
		Case $linkBox
			GUICtrlSetState($LibDownload,$GUI_ENABLE)
			GUICtrlSetState($LibClip,$GUI_ENABLE)
		Case $LibDownload
			GUICtrlSetState($LibDownload,$GUI_DISABLE)
			$linkSlctd = GUICtrlRead($linkBox)
			If Not StringInStr($linkSlctd,$nameSite) Then
				$linkSlctd = "http://" & $nameSite & $linkSlctd
			EndIf
			Ping($nameSite)
			If NOT @Error Then
				Process()				
				_LibCount()			
			Else
				MsgBox(0,$lang[50][0],$lang[50][1],0,$LibGUI)
			EndIf
			GUICtrlSetState($LibStart,$GUI_ENABLE)
			GUICtrlSetState($LibAddOne,$GUI_ENABLE)
			GUICtrlSetState($LibAddAll,$GUI_ENABLE)
			GUICtrlSetState($LibRemOne,$GUI_ENABLE)
			GUICtrlSetState($LibRemAll,$GUI_ENABLE)
		Case $LibClip
			$linkSlctd = GUICtrlRead($linkBox)
			If Not StringInStr($linkSlctd,$nameSite) Then
				$linkSlctd = "http://" & $nameSite & $linkSlctd
			EndIf
			ClipPut ($linkSlctd)
			MsgBox(0,$lang[53][0],$linkSlctd &@LF&$lang[53][1],1,$LibGUI)
		Case $LibStart
			If FileExists(@ScriptDir&"\MADownloader.exe") Then
				Run(@ScriptDir&"\MADownloader.exe")
				GUICtrlSetState($LibAddOne,$GUI_ENABLE)
				GUICtrlSetState($LibAddAll,$GUI_ENABLE)
			Else
				MsgBox(4096, "MADownloader.exe File", $lang[49][0] & " " & $lang[49][1])
			EndIf
		Case $LibAddOne
			$sItemLV = _GUICtrlListView_GetItemTextString($LibLV,-1)
			FileWrite(@ScriptDir&"\temp.tmp",$sItemLV)
			ControlClick("MangAutoIt Downloader","",5)
		Case $LibAddAll
			$cn = _GUICtrlListView_GetItemCount($LibLV) - 1
			For $ia = 0 To $cn
				$sLVItems = _GUICtrlListView_GetItemTextString($LibLV, $ia)
				FileWrite(@ScriptDir&"\temp.tmp",$sLVItems & @LF)
			Next
			ControlClick("MangAutoIt Downloader","",6)
		Case $LibRemOne
			_GUICtrlListView_DeleteItemsSelected($LibLV)
		Case $LibRemAll
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($LibLV))
		Case $ChpCancel
			$fldSlct = $lastFld
			$chpList = _FileListToArray($FldDir &"\"& $fldSlct,"*",2)
			$cvrCheck = _ArraySearch($chpList,"Cover")
			If Not @error Then
				_ArrayDelete($chpList,$cvrCheck)
			EndIf
			GUISetState(@SW_HIDE,$ChpGUI)
			GUISetState(@SW_ENABLE,$LibGUI)
			WinActivate($LibGUI)
		Case $ChpOK
			$c = _GUICtrlListBox_GetCurSel($ChpBox) + 1
			If $c = 1 Then
				GUICtrlSetState($BtL,$GUI_DISABLE)
			Else
				GUICtrlSetState($BtL,$GUI_ENABLE)
			EndIf
			GUICtrlSetState($BtR,$GUI_ENABLE)
			If StringLen($fldSlct) > 19 Then
				GUICtrlSetFont($LblTitle,14)
			Else
				GUICtrlSetFont($LblTitle,24)
			EndIf
			GUICtrlSetData($LblTitle,$fldSlct)
			$lastFld = $fldSlct
			GUICtrlSetData($zoomSldr,6)
			$iZoom = 100
			GUICtrlSetTip($zoomSldr, $lang[54][0]&": "&$iZoom&"%")
			$p = 1
			_PageCountRefresh()
			_Refresh()
			GUICtrlSetState($Lib,$GUI_UNCHECKED)
			GUISetState(@SW_HIDE,$ChpGUI)
			GUISetState(@SW_ENABLE,$LibGUI)
			GUISetState(@SW_HIDE,$LibGUI)
			GUISetState(@SW_ENABLE,$mainGUI)
			WinActivate($mainGUI)
		Case $Opt
			$lastDir = IniRead($config, "settings","LibDir","")			
			GUICtrlSetData($FldSet,$lastDir)
			GUISetState(@SW_SHOW,$OptGUI)
			GUISetState(@SW_DISABLE,$mainGUI)
		Case $OptBrw
			$fldchsd = FileSelectFolder("Select Folder", @ScriptDir,1,@ScriptDir&"\Books",$OptGUI)
			If Not @error Then
				GUICtrlSetState($OptApply,$GUI_ENABLE)
				GUICtrlSetData($FldSet,$fldchsd)
			Else
				GUICtrlSetState($OptApply,$GUI_DISABLE)
			EndIf
		Case $OptApply
			$langSet = GUICtrlRead($cmbLang) & ".lang"
			$dirSet = GUICtrlRead($FldSet)
			IniWrite($config, "settings","LangFile",$langSet)
			IniWrite($config, "settings","LibDir",$dirSet)
			_LibCount()
			GUICtrlSetState($Opt,$GUI_UNCHECKED)
			GUISetState(@SW_HIDE,$OptGUI)
			GUISetState(@SW_ENABLE,$mainGUI)
			WinActivate($mainGUI)
		Case $OptCancel
			GUICtrlSetState($Opt,$GUI_UNCHECKED)
			GUISetState(@SW_HIDE,$OptGUI)
			GUISetState(@SW_ENABLE,$mainGUI)
			WinActivate($mainGUI)
		Case $BtColor
			GUISetState(@SW_SHOW,$colGUI)
			GUISetState(@SW_DISABLE,$mainGUI)
		Case $bgCol
			$bgclr = _ChooseColor(2 ,0xECE9D8, 2, $colGUI);0xECE9D8
			GUISetBkColor($bgclr,$colGUI)
			GUICtrlSetBkColor($bgCol,$bgclr)
		Case $ttlCol
			$ttlclr = _ChooseColor(2 ,0x0080FF, 2, $colGUI);0x0080FF
			GUICtrlSetColor($ttlLbl,$ttlclr)
			GUICtrlSetBkColor($ttlCol,$ttlclr)
		Case $sttlCol
			$sttlclr = _ChooseColor(2 ,0xC00080, 2, $colGUI);0xC00080
			GUICtrlSetColor($sttlLbl,$sttlclr)
			GUICtrlSetBkColor($sttlCol,$sttlclr)
		Case $indxCol
			$indxclr = _ChooseColor(2 ,0x000000, 2, $colGUI)
			GUICtrlSetColor($indxlbl,$indxclr)
			GUICtrlSetBkColor($indxCol,$indxclr)
		Case $colApply
			GUISetBkColor($bgclr,$mainGUI)
			GUICtrlSetBkColor($zoomSldr,$bgclr)
			GUICtrlSetBkColor($lumSldr,$bgclr)
			GUICtrlSetColor($LblTitle,$ttlclr)
			GUICtrlSetColor($LblChapter,$sttlclr)
			GUICtrlSetColor($pgLbl,$indxclr)
			GUICtrlSetColor($LblIndex,$indxclr)
			GUICtrlSetState($BtColor,$GUI_UNCHECKED)
			GUISetState(@SW_HIDE,$colGUI)
			GUISetState(@SW_ENABLE,$mainGUI)
			WinActivate($mainGUI)
			_IEAction($oIE_M,"refresh")
		Case $colCancel
			GUICtrlSetState($BtColor,$GUI_UNCHECKED)
			GUISetState(@SW_HIDE,$colGUI)
			GUISetState(@SW_ENABLE,$mainGUI)
			WinActivate($mainGUI)
		Case $BtAbout
			MsgBox(0,"About MangAutoIt","I don't know ABOUT this!",0,$mainGUI)
			GUICtrlSetState($BtAbout,$GUI_UNCHECKED)
		Case $Bwmp
			If BitAND(GUICtrlRead($Bwmp), $GUI_CHECKED) = $GUI_CHECKED Then
				GUISetState(@SW_SHOW,$wmpGUI)
				GUICtrlSetImage($Bwmp,"wmploc.dll",-9)
			ElseIf BitAND(GUICtrlRead($Bwmp), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
				GUISetState(@SW_HIDE,$wmpGUI)
				GUICtrlSetImage($Bwmp,"wmploc.dll",-1)
			EndIf
		Case $wmpOpen
			$wmpnFile = FileOpenDialog("",@MyDocumentsDir & "\My Music","Music files (*.wav;*.mp3;*.ogg;*.wma;*.wpl)",1)
			If Not @error Then
				_wmploadmedia($wmp,$wmpnFile)
			EndIf
		Case $wmpShuffle
			If BitAND(GUICtrlRead($wmpShuffle), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetImage($wmpShuffle,@ScriptDir & "\Skins\Player\shuffleOn.bmp")
				$wmp.settings.setMode("shuffle","true")
			ElseIf BitAND(GUICtrlRead($wmpShuffle), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
				GUICtrlSetImage($wmpShuffle,@ScriptDir & "\Skins\Player\shuffleOff.bmp")
				$wmp.settings.setMode("shuffle","false")
			EndIf
		Case $wmpRepeat
			If BitAND(GUICtrlRead($wmpRepeat), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetImage($wmpRepeat,@ScriptDir & "\Skins\Player\repeatOn.bmp")
				$wmp.settings.setMode("loop","true")
			ElseIf BitAND(GUICtrlRead($wmpRepeat), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
				GUICtrlSetImage($wmpRepeat,@ScriptDir & "\Skins\Player\repeatOff.bmp")
				$wmp.settings.setMode("loop","false")
			EndIf
		Case $wmpPrev
			$wmp.controls.previous()
		Case $wmpNext
			$wmp.controls.next()
	EndSwitch
WEnd
;-
Func _ReadInfo()
$cvrtInfo = BinaryToString($info[2][1],2)
GUICtrlSetData($nfoAlt,$cvrtInfo)
GUICtrlSetData($nfoSts,$info[3][1])
GUICtrlSetData($nfoRls,$info[4][1])
GUICtrlSetData($nfoAut,$info[5][1])
GUICtrlSetData($nfoArt,$info[6][1])
GUICtrlSetData($nfoGen,$info[7][1])
GUICtrlSetData($nfoRvw,$info[8][1])
GUICtrlSetData($nfoLtc,$info[9][1])
GUICtrlSetData($nfoLink,$info[10][1])
EndFunc
;-
Func _nullInfo()
GUICtrlSetData($nfoAlt,"")
GUICtrlSetData($nfoSts,"")
GUICtrlSetData($nfoRls,"")
GUICtrlSetData($nfoAut,"")
GUICtrlSetData($nfoArt,"")
GUICtrlSetData($nfoGen,"")
GUICtrlSetData($nfoRvw,"")
GUICtrlSetData($nfoLtc,"")
GUICtrlSetData($nfoLink,"")
EndFunc
;-
Func _LibCount()
GUICtrlSetData($LibBox,"")
Global $FldDir = GUICtrlRead($FldSet)
Global $fldList = _FileListToArray($FldDir,"*",2)
If @Error Then
	Return
EndIf
;_ArrayDisplay($fldList)
For $f = 1 To $fldList[0]
GUICtrlSetData($LibBox,$fldList[$f])
Next
EndFunc
;-
Func _ChpCount()
GUICtrlSetData($ChpBox,"")
Global $chpList = _FileListToArray($FldDir &"\"& $fldSlct,"*",2)
If $chpList[0] = 1 Then
	GUICtrlSetState($ChpOK,$GUI_DISABLE)
Else
	$cvrCheck = _ArraySearch($chpList,"Cover")
	If Not @error Then
		_ArrayDelete($chpList,$cvrCheck)
	EndIf
	For $c = 1 To Ubound($chpList)-1
		$chpTitle = IniRead($FldDir &"\"& $fldSlct &"\"& $chpList[$c] &"\chapter.ini","chapter","Title","")
		GUICtrlSetData($ChpBox,$chpList[$c]&" "&$chpTitle,$chpList[Ubound($chpList)-1]&" "&$chpTitle)
	Next
	GUICtrlSetState($ChpOK,$GUI_ENABLE)
EndIf
;_ArrayDisplay($chpList)
EndFunc
;-
Func _PageCountRefresh()
Global $imgList = _FileListToArray($FldDir &"\"& $lastFld &"\"& $chpList[$c],"*.jpg",1)
If Not @Error Then
	GUICtrlSetData($Cmb1,"")
	For $p = 1 To Ubound($imgList)-1
		GUICtrlSetData($Cmb1,$lang[55][0] & ": "&$p,$lang[55][0] &": "&1)
	Next
EndIf
Local $chptrIni = $FldDir &"\"& $lastFld &"\"& $chpList[$c] &"\chapter.ini"
If FileExists($chptrIni) Then
	$chpIndex = IniRead($chptrIni,"chapter","Index","")
	$chpTitle = IniRead($chptrIni,"chapter","Title","")
	GUICtrlSetData($LblChapter,"[ "& $chpTitle &" ]")
	GUICtrlSetData($pgLbl,$lang[55][1] & " " & Ubound($imgList)-1)
	GUICtrlSetData($LblIndex,$chpIndex)
Else
	GUICtrlSetData($LblChapter,"[ "& $chpList[$c] &" ]")
	GUICtrlSetData($pgLbl,$lang[55][1] & " " & Ubound($imgList)-1)
EndIf
EndFunc
;-
Func _Refresh()
$img = $FldDir &"\"& $lastFld &"\"& $chpList[$c] &"\"& $imgList[$p]
_buildHTML()
GUICtrlSetData($Cmb1,$lang[55][0] & ": "&$p)
EndFunc
;-
Func Process()
GUICtrlSetData($dPrgr, 0)
ProgressOn("",$lang[56][0] & " ...")
Sleep(500)
$bSrc = BinaryToString(InetRead($linkSlctd),4)
$nfoRegxList = IniReadSection($plugDir & $lastPlg,"InfoRegExp")
$titleStr = StringRegExp($bSrc, $nfoRegxList[2][1],1)
If Not @error Then
	$titleTrim = StringRegExpReplace($titleStr[0],'\sManga|\sManhwa|\sManhua|\s\(Original\sWork\)|\-',"")
	$title = $titleTrim
Else
	$title = ""
EndIf
ProgressSet(10,$lang[56][1] & " ...")
Sleep(500)
$stsStr = StringRegExp($bSrc, $nfoRegxList[3][1],1)
If Not @error Then
	$status = $stsStr[0]
Else
	$status = ""
EndIf
$altStr = StringRegExp($bSrc, $nfoRegxList[4][1],1)
If Not @error Then
	$altTrim = StringRegExpReplace($altStr[0],'\sstyle=\S+\s\S+">|<h3>\S+|<a|</a>|<b>|</b>|</h3>|\sclass=\S+',"")
	$alt = StringToBinary($altTrim,2)
Else
	$alt = ""
EndIf
ProgressSet(20,$lang[57][1] & " ...")
Sleep(500)
$relStr = StringRegExp($bSrc, $nfoRegxList[5][1],1)
If Not @error Then
	$rel = $relStr[0]
Else
	$rel = ""
EndIf
$autStr = StringRegExp($bSrc, $nfoRegxList[6][1],1)
If Not @error Then
	$aut = $autStr[0]
Else
	$aut = ""
EndIf
$artStr = StringRegExp($bSrc, $nfoRegxList[7][1],1)
If Not @error Then
	$art = $artStr[0]
Else
	$art = ""
EndIf
ProgressSet(30,$lang[58][1] & " ...")
Sleep(500)
$genStr = StringRegExp($bSrc, $nfoRegxList[8][1],3)
If Not @error Then
	$gens = ""
	For $g = 1 To Ubound($genStr)-1
		$gens &= ", " & $genStr[$g]
	Next
	$gen = $genStr[0] & $gens
Else
	$gen = ""
EndIf
ProgressSet(40,$lang[59][1] & " ...")
Sleep(500)
$sumStr1 = StringRegExp($bSrc, $nfoRegxList[9][1],1)
If Not @error Then
	$sumStr1[0] = StringRegExpReplace($sumStr1[0],'&quot;','"')
	$sumStr1[0] = StringRegExpReplace($sumStr1[0],'&#39;',"\'")
	$sumStr2 = StringRegExp($bSrc, $nfoRegxList[10][1],1)
	If Not @error Then
		$sumStr2[0] = StringRegExpReplace($sumStr2[0],'&quot;','"')
		$sumStr2[0] = StringRegExpReplace($sumStr2[0],'&#39;',"\'")
		$sum = $sumStr1[0] & ". " & $sumStr2[0]
	Else
		$sum = $sumStr1[0]
	EndIf
Else
	$sum = ""
EndIf
ProgressSet(50,$lang[60][1] & " ...")
Sleep(500)
$dtaRegxList = IniReadSection($plugDir & $lastPlg,"DataRegExp")
$ChpStrlst = StringRegExp($bSrc, $dtaRegxList[1][1],3)
If Not @error Then
	$ltstChp = $ChpStrlst[1]
Else
	$ltstChp = ""
EndIf
ProgressSet(60,$lang[61][1] & " ...")
Sleep(500)
GUICtrlSetData($DlBox,"")
Dim $adressNumArr[1]
Dim $adressArr[1]
for $a = 0 to ubound($chpStrlst)-2 step 2
	If Not StringInStr($chpStrlst[$a],$nameSite) Then
		_ArrayAdd($adressArr,"http://" & $nameSite & $chpStrlst[$a])
	Else
		_ArrayAdd($adressArr,$chpStrlst[$a])
	EndIf
	If StringInStr($chpStrlst[$a+1],"One Shot") Then
		_ArrayAdd($adressNumArr,"1")
	Else
		_ArrayAdd($adressNumArr,$chpStrlst[$a+1])
	EndIf
Next
Set_progress()
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
	_ArrayAdd($numArr,$jPfx&$adressNumArr[$j])
Next
$chpNamelst = StringRegExp($bSrc, $dtaRegxList[2][1],3)
If IsArray($chpNamelst) = 0 Then
	Dim $chpNamelst[1]
	$chpNamelst[0] = "1"
	_ArrayAdd($chpNamelst,"")
EndIf
If StringCompare($chpNamelst[Ubound($chpNamelst)-2],"1") Then
	_ArrayAdd($chpNamelst,"1")
	_ArrayAdd($chpNamelst,"")
EndIf
Set_progress()
ProgressSet(70,$lang[62][1] & " ...")
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
Set_progress()
ProgressSet(80)
;_ArrayDisplay($nameArr)
For $t = 1 to ubound($numArr)-1
	If StringLen($numArr[$t]) > 3 Then
		$comp = StringCompare($numArr[$t],StringLeft($nameArr[$t],5))
		If Not $comp=0 Then
			_ArrayInsert($nameArr,$t,$numArr[$t])
		EndIf
		GUICtrlCreateListViewItem("c" & $numArr[$t]&"|"&StringTrimLeft($nameArr[$t],6)&"|"&$adressArr[$t]&"|"&$title&"|"&$lastPlg,$LibLV)
	Else
		$comp = StringCompare($numArr[$t],StringLeft($nameArr[$t],3))
		If Not $comp=0 Then
			_ArrayInsert($nameArr,$t,$numArr[$t])
		EndIf
		GUICtrlCreateListViewItem("c" & $numArr[$t]&"|"&StringTrimLeft($nameArr[$t],4)&"|"&$adressArr[$t]&"|"&$title&"|"&$lastPlg,$LibLV)
	EndIf
	GUICtrlSetData($dPrgr, Round(($t*100)/ubound($numArr)-1))
	GUICtrlSetData($DlBox, "c" & $nameArr[$t])
Next
Set_progress()
ProgressSet(90)
$iniDir = IniRead($config,"settings","LibDir","")
$titleDir = $iniDir & "\" & $title
$coverDir = $titleDir & "\Cover"
If Not FileExists($coverDir&"\info.ini") Then
	If Not FileExists($coverDir) Then
		If Not FileExists($titleDir) Then
			DirCreate($titleDir)
			Sleep(250)
		EndIf
		DirCreate($coverDir)
		Sleep(10)
		$coverLink = StringRegExp($bSrc, $nfoRegxList[1][1],1)
		If Not @error Then
			InetGet($coverLink[0], $coverDir & "\Cover.jpg",1)
		EndIf
	EndIf
	$iData = "CoverTitle=" & $title & @LF & "AltTitle=" & $alt & @LF & "Status=" & $status & @LF & "Release=" & $rel & @LF & "Author=" & $aut & @LF & "Artist=" & $art & @LF & "Genres=" & $gen & @LF & "Review=" & $sum & @LF & "LatestChapter=" & $ltstChp & @LF & "Url=" & $linkSlctd & @LF & "Plugin=" & $lastPlg
	IniWriteSection($coverDir & "\info.ini", "Info", $iData)
EndIf
ProgressSet(100,"",$lang[63][1])
Sleep(500)
ProgressOff()
MsgBox(0,$lang[64][0], "Title : " & $title & @LF & "Status : " & $status & @LF & "Latest Chapter : " & $ltstChp &@LF&@LF& $lang[64][1],5)
EndFunc
;-
Func Set_progress()
	For $pg = 0 To 100 Step 5
		GUICtrlSetData($dPrgr, $pg)
		Sleep(2)
	Next
EndFunc
;-
Func _buildHTML()
$bkgC = @ScriptDir&"\Skins\bg.bmp"
$rHtml = ""
Out('<body oncontextmenu="return false" scroll="auto" background="'&$bkgC&'" bgcolor="#000000"></body>')
Out('<div align="center" style="zoom:' & $iZoom & '%">')
Out('<img src="' & $img & '" style=filter:alpha(opacity=' & $iLum & ')"></div>')
_IEDocWriteHTML ($oIE_M, $rHtml)
EndFunc
;-
Func _updateHTML()
$rHtml = ""
Out('<div align="center" style="zoom:' & $iZoom & '%">')
Out('<img src="' & $img & '" style="filter:alpha(opacity=' & $iLum & ')"</div>')
_IEPropertySet ($oIE_M, "innerhtml", $rHtml)
EndFunc
;-
Func Out($temp)
	$rHtml &= $temp & @CRLF
EndFunc
;-
Func _wmpcreate($show, $left, $top, $width = 100, $height = 100)
$oWMP = ObjCreate("WMPlayer.OCX")
If $oWMP = 0 Then Return 0
$oWMP.settings.autoStart = "False"
If $show = 1 Then
	GUICtrlCreateObj($oWMP, $left, $top, $width, $height)
	$oWMP.uiMode = "mini" ;full,none
	$oWMP.enableContextMenu = false
	;$oWMP.windowlessVideo = "true"
EndIf
Return $oWMP
EndFunc
Func _wmploadmedia( $object, $URL, $autostart = 1 )
	$object.URL = $URL
	While Not $object.controls.isAvailable("play")
		Sleep(10)
	WEnd
	If $autostart = 1 Then $object.controls.play()
EndFunc
;-
Func LoadSettings($config)
Local $defaultDir = @ScriptDir & "\Books"
Local $skinDir = @ScriptDir & "\Skins"
Local $defaultLang = "default.lang"
Local $langini = IniRead($config,"settings","LangFile",$defaultLang)
Local $ini = IniRead($config,"settings","LibDir",$defaultDir)
Local $bgHex = "0x424d72000000000000005a000000280000000600000006000000010004000000000018000000c40e0000c40e00000900000000000000000000001b1b1b001eeedd001eeedd001eeedd001eeedd001b1b1b001b1b1b001b1b1b00000111000011100001110000111000001100010010001100"
If Not FileExists($skinDir & "\bg.bmp") Then
	If Not FileExists($skinDir) Then
		DirCreate($skinDir)
		Sleep(10)
	EndIf
	FileWrite($skinDir & "\bg.bmp", Binary($bgHex))
EndIf
$langList = _FileListToArray($langDir,"*.lang",1)
GUICtrlSetData($cmbLang,"")
For $l = 1 To UBound($langList)-1
	GUICtrlSetData($cmbLang,StringTrimRight($langList[$l],5),StringTrimRight($langini,5))
Next
If FileExists($ini) Then
	GUICtrlSetData($FldSet,$ini)
Else
	IniWrite($config, "settings","LibDir",$defaultDir)
	DirCreate($defaultDir)
	Sleep(10)
EndIf
If FileExists($plugDir) Then
	$plugList = _FileListToArray($plugDir,"*.rgx",1)
	If Not @error Then
		GUICtrlSetData($Cmb2,"")
		For $i = 1 To UBound($plugList)-1
			$plgName = IniRead($plugDir&"\"&$plugList[$i],"PluginProperty","Name","")
			$plgAuth = IniRead($plugDir&"\"&$plugList[$i],"PluginProperty","AuthoredBy","")
			GUICtrlCreateListViewItem($plgName&"|"&$plgAuth,$plgBox)
			GUICtrlSetData($Cmb2,$plugList[$i],$plugList[1])
		Next
		$lastPlg = $plugList[1]
	Else
		GUICtrlSetState($search,$GUI_DISABLE)
	EndIf
Else
	Dim $arrPlugin1[6][2] = [["Name","MangaFox"],["AuthoredBy","HenSa@Indonesia"],["Site","mangafox.me"],["SearchUrl","http://mangafox.me/search.php?name_method=cw&name="],["DataUrl","http://mangafox.me/manga/"],["UrlEnd","/"]]
	Dim $arrPlugin2[10][2] = [["Cover",'\"http://\S+/cover.jpg\S+\"'],["CoverTitle",'og:title.+=\"(?<TITLE>.+?)\sManga'],["Status",'Ongoing|Complete'],["AltTitle",'<h3>.+</h3>'],["Release",'/released/.+\>(?<REL>[^<]+)</a>'],["Author",'/author.+\>(?<AUTH>[^<]+)</a>'],["Artist",'/artist.+\>(?<ART>[^<]+)</a>'],["Genre",'/genres/[^>]+>(?<GENRES>[^<]+)</a>'],["Review",'<p\sclass="summary">(?<SUM1>[^<]+)<'],["Review2",'<br\s/>\r\n(?<SUM2>[^<].+)</p>']]
	Dim $arrPlugin3[4][2] = [["ChapterLink",'(http://.+/1.html).+\s(?<CNUMS>[?.\d]+)</a>'],["ChapterTitle",'(?<nums>[?.\d]+)</a>\r\n.+<span\sclass=\"title\snowrap\">(?<CHAPTERS>[^<]+)</span>'],["ImageSrc",'<img\ssrc=\"(?<PATH>[^\"]+)\"\sonerror'],["SrcTotal",'total_pages=(\d+)']]
	DirCreate($plugDir)
	Sleep(10)
	IniWriteSection($plugDir&"mangafox.rgx","PluginProperty",$arrPlugin1,0)
	IniWriteSection($plugDir&"mangafox.rgx","InfoRegExp",$arrPlugin2,0)
	IniWriteSection($plugDir&"mangafox.rgx","DataRegExp",$arrPlugin3,0)
	MsgBox(0,"Files created!","This is only happen once at first time run"&@LF&@LF&"Please restart the application!",0,$OptGUI)
	Exit
EndIf
EndFunc
;-
Func LoadLanguage()
If FileExists($langDir) Then
	If FileExists($config) Then
		$langini = IniRead($config,"settings","LangFile","")
		If FileExists($langDir & $langini) Then
			$langFile = $langini
		Else
			LangCreate()
		EndIf
	Else
		$langList = _FileListToArray($langDir,"*.lang",1)
		$langFile = $langList[1]
	EndIf
Else
	DirCreate($langDir)
	Sleep(10)
	LangCreate()
EndIf
EndFunc
;-
Func LangCreate()
$lang1Arr = ""
For $n = 1 To 64
	$lang1Arr &= $n & "=" & $n & " #" & @LF
Next
$lang2Arr = ""
For $m = 1 To 25
	$lang2Arr &= $m & "=" & $m & " #" & @LF
Next
IniWriteSection($langDir & "default.lang","MangAutoIt",$lang1Arr,0)
Sleep(10)
IniWriteSection($langDir & "default.lang","MADownloader",$lang2Arr,0)
Sleep(10)
IniWrite($config, "settings","LangFile","default.lang")
$langFile = "default.lang"
EndFunc