#Include <File.au3>
#Include <Array.au3>
;#Include <Sound.au3>
#Include <Constants.au3>
#Include <GUIConstants.au3>
#Include <WindowsConstants.au3>
#Include "ModernMenuRaw.au3"
#Include "ReduceMemory.au3"
#Include <GDIPlus.au3>
#Include <ScreenCapture.au3>
#Include "Audio.au3"
#Include <GuiSlider.au3>
#Include <INet.au3>
#Include <Misc.au3>
#Include <AVIConstants.au3>
#Include "_RefreshSystemTray.au3"
#NoTrayIcon

if _Singleton("IMP.exe", 1) = 0 then
	If $CmdLine[0] <> 0 Then
		ProcessClose("IMP.exe")
	Else
		Exit
	EndIf
EndIf

_RefreshSystemTray()

Global $List, $dir, $x, $l, $m, $Current, $Latest, $Size, $UpdateGui, $NowItem, $NowText
Global $NowLen, $FireAnim, $hBitmap, $Download
Global $split, $szDrive, $szDir, $szFName, $szExt, $Status1 = "", $Check = 1, $Bytes, $Max
Local $List[10000], $CreateItem[10000], $ImageList[10000], $CreateImage[10000]
Global $Settings = @TempDir & "\Settings.ini"


Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
Opt("GUIOnEventMode", 1)


$Location = _PathSplit(@AutoitExe, $szDrive, $szDir, $szFName, $szExt)
If not FileExists($szDrive & $szDir & "IMP.dll") Then
FileInstall("IMP.dll", $szDrive & $szDir & "IMP.dll")
EndIf


$nTrayIcon1 = _TrayIconCreate("Inferno Media Project", "IMP.dll", 10, "TrayEvent")
_TrayIconSetState()

_SetTrayIconBkColor(0xC0C0C0)
_SetTrayIconBkGrdColor(0xFFFFFF)

_TrayIconSetClick($nTrayIcon1, 1)

$nTrayMenu1 = _TrayCreateContextMenu()
$nSideItem3 = _CreateSideMenu($nTrayMenu1)

_SetSideMenuText($nSideItem3, "Inferno Media Project")
_SetSideMenuColor($nSideItem3, 0x5E68D1)

_SetSideMenuBkColor($nSideItem3, 0x000000)
_SetSideMenuBkGradColor($nSideItem3, 0x0000ff)

_SetSideMenuImage($nSideItem3, "IMP.dll", Random(23, 26, 1))
;GuiCtrlSetState($ImageList[2], $TRAY_DEFAULT)


$NowItem = 	_TrayCreateItem("Welcome to the Inferno Media Project")

		_TrayCreateItem("")
	_TrayItemSetIcon(-1, "", 0)

$PlayItem =	_TrayCreateItem("Play")
	GuiCtrlSetOnEvent(-1,"PlayFunc")

$PauseItem =	_TrayCreateItem("Pause")
	GuiCtrlSetOnEvent(-1,"PauseFunc")

		_TrayCreateItem("")
	_TrayItemSetIcon(-1, "", 0)

$PreviousItem =	_TrayCreateItem("Previous")
	GuiCtrlSetOnEvent(-1,"PreviousFunc")

$NextItem =	_TrayCreateItem("Next")
	GuiCtrlSetOnEvent(-1,"NextFunc")

		_TrayCreateItem("")
	_TrayItemSetIcon(-1, "", 0)

$SelectItemMenu=_TrayCreateItem("Select Folder")
	GuiCtrlSetOnEvent(-1,"SelectFunc")

$ChooseItem =	_TrayCreateMenu("Choose Song")
	

$ShuffleItem =	_TrayCreateItem("Shuffle", -1, -1, -1)
	GuiCtrlSetOnEvent(-1,"ShuffleFunc")

		_TrayCreateItem("")
	_TrayItemSetIcon(-1, "", 0)

$Options =	_TrayCreateMenu("Options")

$About = 	_TrayCreateItem("About", $Options)
	GuiCtrlSetOnEvent(-1,"AboutFunc")

		_TrayCreateItem("", $Options)

$QuicklaunchOn =_TrayCreateItem("Add Quick Launch Icon", $Options)
	GuiCtrlSetOnEvent(-1,"QuickLaunchOnFunc")

$QuicklaunchOff=_TrayCreateItem("Remove Quick Launch Icon", $Options)
	GuiCtrlSetOnEvent(-1,"QuickLaunchOffFunc")

		_TrayCreateItem("", $Options)

$Images = 	_TrayCreateMenu("Set Image", $Options)

		_TrayCreateItem("Default 1", $Images)
	GuiCtrlSetOnEvent(-1,"Default1")

		_TrayCreateItem("Default 2", $Images)
	GuiCtrlSetOnEvent(-1,"Default2")

		_TrayCreateItem("Default 3", $Images)
	GuiCtrlSetOnEvent(-1,"Default3")

		_TrayCreateItem("Default 4", $Images)
	GuiCtrlSetOnEvent(-1,"Default4")

		_TrayCreateItem("", $Options)

	 	_TrayCreateItem("Update", $Options)
	GuiCtrlSetOnEvent(-1,"InternetConnection")

$VolumeItem =	_TrayCreateItem("Volume")
	GuiCtrlSetOnEvent(-1,"VolumeFunc")

		_TrayCreateItem("")
	_TrayItemSetIcon(-1, "", 0)

$ExitItem =	_TrayCreateItem("Exit")
	GuiCtrlSetOnEvent(-1,"ExitFunc")


_TrayItemSetIcon($NowItem, "shell32.dll", -50)
_TrayItemSetIcon($PlayItem, "IMP.dll", -11)
_TrayItemSetIcon($PauseItem, "IMP.dll", -12)

_TrayItemSetIcon($PreviousItem, "IMP.dll", -13)
_TrayItemSetIcon($NextItem, "IMP.dll", -14)
_TrayItemSetIcon($SelectItemMenu, "IMP.dll", -15)
_TrayItemSetIcon($ChooseItem, "IMP.dll", -16)

_TrayItemSetIcon($ShuffleItem, "IMP.dll", -17)
_TrayItemSetIcon($Options, "IMP.dll", -18)
_TrayItemSetIcon($VolumeItem, "IMP.dll", -19)
_TrayItemSetIcon($ExitItem, "IMP.dll", -20)


_TrayItemSetSelIcon($PlayItem, "IMP.dll", -1)
_TrayItemSetSelIcon($PauseItem, "IMP.dll", -2)
_TrayItemSetSelIcon($PreviousItem, "IMP.dll", -3)
_TrayItemSetSelIcon($NextItem, "IMP.dll", -4)
_TrayItemSetSelIcon($SelectItemMenu, "IMP.dll", -5)
_TrayItemSetSelIcon($ChooseItem, "IMP.dll", -6)
_TrayItemSetSelIcon($ShuffleItem, "IMP.dll", -7)
_TrayItemSetSelIcon($Options, "IMP.dll", -8)
_TrayItemSetSelIcon($VolumeItem, "IMP.dll", -9)
_TrayItemSetSelIcon($ExitItem, "IMP.dll", -10)


GuiCtrlSetState($NowItem, $TRAY_DISABLE)
GuiCtrlSetState($PlayItem, $TRAY_DISABLE)
GuiCtrlSetState($PauseItem, $TRAY_DISABLE)
GuiCtrlSetState($PreviousItem, $TRAY_DISABLE)
GuiCtrlSetState($NextItem, $TRAY_DISABLE)
GuiCtrlSetState($ShuffleItem, $TRAY_DISABLE + $TRAY_UNCHECKED)
GuiCtrlSetState($ChooseItem, $TRAY_DISABLE)
GuiCtrlSetState($SelectItemMenu, $TRAY_DEFAULT)
GuiCtrlSetState($Options, $TRAY_DISABLE)
GuiCtrlSetState($VolumeItem, $TRAY_DISABLE)
GUISetState()


$Width = @DesktopWidth - 200
$Height = @DesktopHeight - 50
$noGUI = GUICreate("", 0, 0, 0, 0)

$Gui = GUICreate("Volume", 198, 18, $Width, $Height, BitOR($WS_POPUPWINDOW, $WS_BORDER, $GUI_ONTOP), $WS_EX_STATICEDGE + $WS_EX_TOPMOST,$noGUI)
$slider1 = GUICtrlCreateSlider(-1,-1,200,20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))

GUICtrlSetCursor(-1,0)
GUICtrlSetBkColor(-1,0x000000)
GUICtrlSetLimit(-1,100,0)
GUISetState(@SW_HIDE, $Gui)
$Vol = _SoundGetWaveVolume()
GUICtrlSetData($slider1, $vol)


$ico = 0
AdlibEnable("FireFunc", 150)


If $CmdLine[0] <> 0 Then
CmdFunc()
EndIf


While 1
sleep(2000)

If $x <> ""  Then

	$Status1 = _SoundStatus($dir & "\" & $List[$x])

		If $Status1 = "Stopped" Then
			_SoundClose($dir & "\" & $List[$x])

			If $Check = 1 Then
				$x = $x + 1
			ElseIf $Check = 0 Then
				$x = Random(1, $List[0], 1)
			EndIf

		If $x > $List[0] Then
			$x = 1
		EndIf

		PlaySong()
	EndIf

EndIf

WEnd


Func PlayFunc()
	_SoundResume($dir & "\" & $List[$x])
	_ReduceMemory()
EndFunc


Func PauseFunc()
	_SoundPause($dir & "\" & $List[$x])
	_ReduceMemory()
EndFunc


Func PreviousFunc()
	If $x = 1 Then
		_SoundClose($dir & "\" & $List[$x])
		$x = $List[0]
	Else
		_SoundClose($dir & "\" & $List[$x])
		$x = $x - 1
	EndIf

	If $Check = 0 Then
		$x = Random(1, $List[0], 1)
	EndIf
PlaySong()
EndFunc


Func NextFunc()
	If $x = $List[0] Then
		_SoundClose($dir & "\" & $List[$x])
		$x = 1
	Else
		_SoundClose($dir & "\" & $List[$x])
		$x = $x + 1
	EndIf

	If $Check = 0 Then
		$x = Random(1, $List[0], 1)
	EndIf
PlaySong()
EndFunc


Func SelectFunc()

If $x <> 0 Then
	_SoundClose($dir & "\" & $List[$x])

	For $i = 1 to $List[0]
	_TrayDeleteItem($CreateItem[$i])
	Next

	For $i = 1 to $ImageList[0]
	_TrayDeleteItem($CreateImage[$i])
	Next

	$dir = FileSelectFolder("Choose a folder to play music from.", "")
	$List = _MultiFileListToArray($dir & "\", "*.mp3|*.wma|*.wav")

Else

	$OldDir = IniRead($Settings, "Directory", "Dir", "")
	If $OldDir <> "" Then
	$message = MsgBox(4, "Directory", "Resume from last time?  Last folder used was -" & @CRLF & $OldDir)

	If $message = 6 Then
	$dir = $OldDir
	ElseIf $Message = 7 Then
	$dir = FileSelectFolder("Choose a folder to play music from.", "")
	EndIf
	EndIf

	If $OldDir = "" Then
	$dir = FileSelectFolder("Choose a folder to play music from.", "")
	EndIf
	$List = _MultiFileListToArray($dir & "\", "*.mp3|*.wma|*.wav")
EndIf

While $List[0] = 0
   	$msg1 = MsgBox(4,"","No Music Files Found." & @CRLF & "Select Another Folder?")
	If $msg1 = 6 Then
		$dir = FileSelectFolder("Choose a folder to play music from.", "")
		$List = _MultiFileListToArray($dir & "\", "*.mp3|*.wma|*.wav")
	ElseIf $msg1 = 7 Then
		_TrayIconDelete($nTrayIcon1)
		Exit
	EndIf
WEnd


	GuiCtrlSetState($NowItem, $TRAY_ENABLE + $TRAY_DEFAULT)
	GuiCtrlSetState($PlayItem, $TRAY_ENABLE)
	GuiCtrlSetState($PauseItem, $TRAY_ENABLE)
	GuiCtrlSetState($PreviousItem, $TRAY_ENABLE)
	GuiCtrlSetState($NextItem, $TRAY_ENABLE)
	GuiCtrlSetState($ShuffleItem, $TRAY_ENABLE)
	GuiCtrlSetState($ChooseItem, $TRAY_ENABLE)
	GuiCtrlSetState($Options, $TRAY_ENABLE)
	GuiCtrlSetState($VolumeItem, $TRAY_ENABLE)

	If $x = 0 Then
	$FoundItem = _TrayCreateItem("Songs Found", $ChooseItem)
	_TrayCreateItem("", $ChooseItem)
	GuiCtrlSetState($FoundItem, $TRAY_DEFAULT)
	EndIf


		For $l = 1 to $List[0]
		_TrayTip($nTrayIcon1, "", "Adding " & $List[$l] & " to Media")
		$CreateItem[$l] = _TrayCreateItem(StringTrimRight($List[$l], 4), $ChooseItem)
		GuiCtrlSetOnEvent($CreateItem[$l], "ChooseFunc")
		sleep(50)
		Next

	IniWrite($Settings, "Directory", "Dir", $Dir)

	CreateImages()
EndFunc


Func CmdFunc()

	If StringInStr($CmdLine[1], ".mp3") or StringInStr($CmdLine[1], ".wav") or StringInStr($CmdLine[1], ".wma") then

		For $i = 1 to $CmdLine[0]
		If StringInStr($CmdLine[$i], ".mp3") or StringInStr($CmdLine[$i], ".wav") or StringInStr($CmdLine[$i], ".wma") then
		$split = _PathSplit($CmdLine[$i], $szDrive, $szDir, $szFName, $szExt)
		$List[$i] = $szFName & $szExt
		$Dir = $szDrive & $szDir
		$List[0] = $List[0] + 1
		EndIf
		Next

	Else
		$Dir = $CmdLine[1]
		$List = _MultiFileListToArray($dir & "\", "*.mp3|*.wma|*.wav")
	EndIf


	GuiCtrlSetState($NowItem, $TRAY_ENABLE + $TRAY_DEFAULT)
	GuiCtrlSetState($PlayItem, $TRAY_ENABLE)
	GuiCtrlSetState($PauseItem, $TRAY_ENABLE)
	GuiCtrlSetState($PreviousItem, $TRAY_ENABLE)
	GuiCtrlSetState($NextItem, $TRAY_ENABLE)
	GuiCtrlSetState($ShuffleItem, $TRAY_ENABLE)
	GuiCtrlSetState($ChooseItem, $TRAY_ENABLE)
	GuiCtrlSetState($Options, $TRAY_ENABLE)
	GuiCtrlSetState($VolumeItem, $TRAY_ENABLE)

	If $x = 0 Then
	$FoundItem = _TrayCreateItem("Songs Found", $ChooseItem)
	_TrayCreateItem("", $ChooseItem)
	GuiCtrlSetState($FoundItem, $TRAY_DEFAULT)
	EndIf


		For $l = 1 to $List[0]
		_TrayTip($nTrayIcon1, "", "Adding " & $List[$l] & " to Media")
		If $List[$l] <> "" Then
		$CreateItem[$l] = _TrayCreateItem(StringTrimRight($List[$l], 4), $ChooseItem)
		GuiCtrlSetOnEvent($CreateItem[$l], "ChooseFunc")
		EndIf
		sleep(50)
		Next

	IniWrite($Settings, "Directory", "Dir", $Dir)

	CreateImages()
EndFunc


Func CreateImages()
	$ImageList = _MultiFileListToArray($dir & "\", "*.jpg|*.bmp")

	If $ImageList[0] <> 0 Then

	$hGUI = GUICreate("", 150, 240, -1, -1, BitOR($WS_POPUPWINDOW, $WS_BORDER, $GUI_ONTOP), $WS_EX_STATICEDGE + $WS_EX_TOPMOST,$noGUI)
	GUISetState()

	If FileExists(@TempDir & "\Images") Then
		sleep(10)
	Else
		DirCreate(@TempDir & "\Images")
	EndIf
		
	For $m = 1 to $ImageList[0]

	_TrayTip($nTrayIcon1, "", "Converting and Resizing Image " & $m & " of " & $ImageList[0], 1)

	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_ImageLoadFromFile($dir & "\" & $ImageList[$m])
	$sCLSID = _GDIPlus_EncodersGetCLSID("bmp")

	$hGraphic2 = _GDIPlus_GraphicsCreateFromHWND($hGUI)
	$iX = _GDIPlus_ImageGetWidth ($hBitmap)
	$iY = _GDIPlus_ImageGetHeight ($hBitmap)

	GuiCtrlCreateIcon("IMP.dll", 21, 0, 0, 150, 45)
	GuiCtrlCreateIcon("IMP.dll", 22, 0, 195, 150, 45)

	_GDIPlus_GraphicsDrawImageRectRect($hGraphic2, $hBitmap, 0, 0, $iX, $iY,0,45, 150,150)

	_ScreenCapture_CaptureWnd(@TempDir & "\images\" & StringTrimRight($ImageList[$m], 4) & ".bmp", $hGUI, 2, 2, 152, 247, 0)

	_GDIPlus_GraphicsDispose($hGraphic2)
	_GDIPlus_ImageDispose($hBitmap)
	_GDIPlus_Shutdown()

	$CreateImage[$m] = _TrayCreateItem(StringTrimRight($ImageList[$m], 4), $Images)
	GuiCtrlSetOnEvent($CreateImage[$m], "ImageFunc")

	sleep(100)
	Next

	GuiDelete($hGUI)

	If $ImageList[0] > 1 then
		_SetSideMenuImage($nSideItem3, @TempDir & "\images\" & StringTrimRight($ImageList[2], 4) & ".bmp")
	else
		_SetSideMenuImage($nSideItem3, @TempDir & "\images\" & StringTrimRight($ImageList[1], 4) & ".bmp")
	EndIf

	Else
		_SetSideMenuImage($nSideItem3, "IMP.dll", Random(23, 26, 1))
	EndIf

	$x = 1

	PlaySong()	
EndFunc


Func ChooseFunc()
	_SoundClose($dir & "\" & $List[$x])
	For $l = 1 to $List[0]
		Select
		Case @GUI_CtrlId = $CreateItem[$l]
		$x = $l
		EndSelect
	Next

	PlaySong()

EndFunc


Func ImageFunc()
	for $l = 1 to $ImageList[0]
		Select
		Case @GUI_CtrlId = $CreateImage[$l]
		_SetSideMenuImage($nSideItem3, @TempDir & "\images\" & StringTrimRight($ImageList[$l], 4) & ".bmp")
		EndSelect
	Next
	_ReduceMemory()
EndFunc


Func ShuffleFunc()
	$check = $check + 1

	If $Check = 2 Then
		GuiCtrlSetState($ShuffleItem, $TRAY_CHECKED)
		$Check = 0
	ElseIf $Check = 1 Then
		GuiCtrlSetState($ShuffleItem, $TRAY_UNCHECKED)
	EndIf
	_ReduceMemory()
EndFunc


Func ExitFunc()
	_TrayIconDelete($nTrayIcon1)
	Exit
EndFunc


Func PlaySong()
	$Status = _SoundStatus($dir & "\" & $List[$x])
	If $Status = "Stopped" Then
	$NowText = StringTrimRight($List[$x], 4)

	$Max = 50
	$NowLen = StringLen($NowText)
	If $NowLen > $Max Then $NowText = StringLeft($NowText, $Max)

	If $NowLen < $Max Then
	$NowLen = $Max - $NowLen
	For $i = 1 to $Nowlen
	$NowText = $NowText & " "
	Next
	EndIf

	_TrayItemSetText($NowItem, $NowText)
	_SoundOpen($dir & "\" & $List[$x])
	_SoundPlay($dir & "\" & $List[$x], 0)
	$Pos = _SoundPos($dir & "\" & $List[$x], 1)
	$len = _SoundLength($dir & "\" & $List[$x], 1)
	_TrayIconSetToolTip($nTrayIcon1, "Inferno Media Project" & @CRLF & StringTrimRight($List[$x], 4))
	_TrayTip($nTrayIcon1, "", "I.M.P. - Inferno Media Project" & @CRLF & "Now Playing - " & $List[$x] & @CRLF & $Pos & " - " & $len, 1)
	sleep(3500)
	_TrayTip($nTrayIcon1, "", "", 1)
	EndIf
	_ReduceMemory()
EndFunc


Func _MultiFileListToArray($sPath, $sFilter = "*", $iFlag = 0)
    Local $hSearch, $sFile, $asFileList[1], $sCount
    If Not FileExists($sPath) Then Return SetError(1, 1, "")
    If (StringInStr($sFilter, "\")) Or (StringInStr($sFilter, "/")) Or (StringInStr($sFilter, ":")) Or (StringInStr($sFilter, ">")) Or (StringInStr($sFilter, "<")) Or (StringStripWS($sFilter, 8) = "") Then Return SetError(2, 2, "")
    $sFilter = (StringSplit($sFilter, "|"))
    If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, "")
    For $sCount = 1 To $sFilter[0]
        $hSearch = FileFindFirstFile($sPath & "\" & $sFilter[$sCount])
        If $hSearch = -1 Then
            If $sCount = $sFilter[0] Then Return SetError(4, 4, $asFileList)
            ContinueLoop
        EndIf
        While 1
            $sFile = FileFindNextFile($hSearch)
            If @error Then
                SetError(0)
                ExitLoop
            EndIf
            If $iFlag = 1 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop
            If $iFlag = 2 And StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") = 0 Then ContinueLoop
            ReDim $asFileList[UBound($asFileList) + 1]
            $asFileList[0] = $asFileList[0] + 1
            $asFileList[UBound($asFileList) - 1] = $sFile
        WEnd
        FileClose($hSearch)
    Next
    Return $asFileList
EndFunc


Func VolumeFunc()
	GuiSetState(@SW_SHOW, $Gui)

	While 1
		sleep(100)
		$pos = MouseGetPos()
		$WinPos = WinGetPos("Volume")
	
		If $Pos[0] > $WinPos[0] and $Pos[1] > $WinPos[1] Then
		ExitLoop

		EndIf
	WEnd

	While 1
		sleep(100)
		SoundSetWaveVolume(GUICtrlRead($slider1))

		$pos = MouseGetPos()
		$WinPos = WinGetPos("Volume")

		If $Pos[0] < $WinPos[0] - 20 Then
		ExitLoop

		ElseIf $Pos[0] > $WinPos[0] + 200 Then
		ExitLoop

		ElseIf $Pos[1] < $WinPos[1] - 20 Then
		ExitLoop

		ElseIf $Pos[1] > $WinPos[0] + 20 Then
		ExitLoop

		EndIf
	WEnd

	GUISetState(@SW_HIDE, $Gui)
	_ReduceMemory()
EndFunc


Func FireFunc()
	$ico = $ico + 1
		If $ico > 10 Then
		$ico = 1
		EndIf
        _TrayIconSetIcon($nTrayIcon1, "IMP.dll", "-" & $ico)
EndFunc


Func AboutFunc()
	MsgBox(0, "About", "I.M.P." & @CRLF & "Inferno Media Project" & @CRLF & "by: John")
EndFunc


Func QuickLaunchOnFunc()
	$userQuickLaunchPath = @AppDataDir & "\Microsoft\Internet Explorer\Quick Launch"
	$shortcutTarget = @AutoitExe
	FileCreateshortcut($shortcutTarget, $userQuickLaunchPath & "\Inferno Media Project.lnk")
EndFunc


Func QuickLaunchOffFunc()
	$userQuickLaunchPath = @AppDataDir & "\Microsoft\Internet Explorer\Quick Launch"
	$shortcutTarget = @AutoitExe
	FileDelete($userQuickLaunchPath & "\Inferno Media Project.lnk")
EndFunc


Func TrayEvent($nID, $nMsg)
	Switch $nID
			
	Case $nTrayIcon1

		Switch $nMsg


			case $WM_RBUTTONUP
				If $x <> 0 Then
				$Status = _SoundStatus($dir & "\" & $List[$x])
					If $Status = "Paused" Then
						PlayFunc()
						ElseIf $Status = "Playing" Then
						PauseFunc()
					EndIf
				EndIf
				
			case $WM_LBUTTONDBLCLK
				If $x <> 0 Then
				PreviousFunc()
				EndIf

			case $WM_RBUTTONDBLCLK
				If $x <> 0 Then
				NextFunc()
				EndIf

		EndSwitch
	EndSwitch
EndFunc


Func _SoundGetWaveVolume()
    Local $WaveVol = -1, $p, $ret
    Const $MMSYSERR_NOERROR = 0
    $p = DllStructCreate("dword")
    If @error Then
	SetError(2)
	Return -2
    EndIf
    $ret = DllCall("winmm.dll", "long", "waveOutGetVolume", "long", -1, "long", DllStructGetPtr($p))
    If($ret[0] == $MMSYSERR_NOERROR) Then
        $WaveVol = Round(Dec(StringRight(Hex(DllStructGetData($p, 1), 8), 4)) / 0xFFFF * 100)
    Else
	SetError(1)
    EndIf
    $Struct = 0
    Return $WaveVol
EndFunc


Func InternetConnection()
	If Ping("www.google.com",250) <> 0 Then
		$Current = FileGetVersion("IMP.exe")
		$Latest = _INetGetSource("http://h1.ripway.com/Tomb/Version.txt")
		$Size = INetGetSize("http://h1.ripway.com/Tomb/IMP.exe")

			UpdateFunc()
	Else
		MsgBox(0, "", "Internet connection not found")
	EndIf
EndFunc


Func UpdateFunc()
	If Not WinExists("Update") Then
	Opt("GUIOnEventMode", 1)
	$UpdateGui = GuiCreate("Update", 400, 115, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ExitUpdateFunc")
	GuiSetState(@SW_SHOW)
	GuiCtrlCreateIcon("IMP.dll", 21, -20, 30, 150, 45)
	GuiSetBkColor(0xffffff)

	GUICtrlCreateGroup("", 110, 3, 280, 105)

	If $Current = $Latest Then
		GuICtrlCreateLabel("You have the latest version of IMP", 130, 15)
		GUICtrlSetColor(-1, 0xff0000)
	ElseIf $Current <> $Latest Then
		GuICtrlCreateLabel("An Update is Available for IMP.", 130, 15)
		GUICtrlSetColor(-1, 0xff0000)
	EndIf

	GuICtrlCreateLabel("Current Version : " & $Current, 130, 30)
	GUICtrlSetColor(-1, 0xff0000)

	GuICtrlCreateLabel("Latest Version : " & $Latest, 130, 45)
	GUICtrlSetColor(-1, 0xff0000)

	GuICtrlCreateLabel("Download Size : " & $Size & " Bytes", 130, 60)
	GUICtrlSetColor(-1, 0xff0000)

	GuiCtrlCreateButton("Update Now", 130, 80, 100, 20)
	GuiCtrlSetOnEvent(-1, "DownloadFunc")

	GuiCtrlCreateButton("Update Later", 270, 80, 100, 20)
	GuiCtrlSetOnEvent(-1, "ExitUpdateFunc")

	$FireAnim = GUICtrlCreateAvi("IMP.dll", 23, 305, 20, 49, 49)
	GUICtrlSetState($FireAnim, 1)
	EndIf
EndFunc


Func DownloadFunc()

	If $Current = $Latest Then MsgBox(0, "", "You already have the latest version.")

	If $Current <> $Latest Then $download = MsgBox(4, "", "Download Latest Version?")
	If $Download = 6 Then

	$Location = _PathSplit(@AutoitExe, $szDrive, $szDir, $szFName, $szExt)

	FileMove($szDrive & $szDir & "IMP.exe", $szDrive & $szDir & "old version(" & $Current & ").exe")

	$size = InetGetSize("http://h1.ripway.com/Tomb/IMP.exe")
	InetGet("http://h1.ripway.com/Tomb/IMP.exe", $szDrive & $szDir & "IMP.exe", 1, 1)

	ProgressOn("Inferno Media Project", "Update", "0 percent", -1, -1, 16)

	While @InetGetActive
		$Bytes = Round(@InetGetBytesRead * 100 / $size)
		ProgressSet(($Bytes), @InetGetBytesRead & " Bytes - " & $Bytes & " %")
		Sleep(10)
	Wend

	ProgressSet(100 , "Done", "Complete")
	sleep(500)
	ProgressOff()

	MsgBox(0, "", "Download Complete")
	_TrayIconDelete($nTrayIcon1)
	FileDelete($szDrive & $szDir & "IMP.dll")
	Run($szDrive & $szDir & "IMP.exe")
	Exit
	EndIf
EndFunc


Func ExitUpdateFunc()
	GuiDelete($UpdateGui)
	_ReduceMemory()
EndFunc


Func Default1()
	_SetSideMenuImage($nSideItem3, "IMP.dll", 23)
	_ReduceMemory()
EndFunc


Func Default2()
	_SetSideMenuImage($nSideItem3, "IMP.dll", 24)
	_ReduceMemory()
EndFunc


Func Default3()
	_SetSideMenuImage($nSideItem3, "IMP.dll", 25)
	_ReduceMemory()
EndFunc


Func Default4()
	_SetSideMenuImage($nSideItem3, "IMP.dll", 26)
	_ReduceMemory()
EndFunc