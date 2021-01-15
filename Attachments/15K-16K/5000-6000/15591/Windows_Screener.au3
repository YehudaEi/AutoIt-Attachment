#Include<GUIConstants.au3>
#include<misc.au3>
#include<string.au3>
#include <A3LScreenCap.au3>

If _Singleton("Windows Screener", 1) = 0 Then
	Exit
EndIf

Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode", 2)
Opt("TrayMenuMode", 3)
Opt("GUICloseOnEsc", 0)
Opt("GUIResizeMode", 802)

Global $Pos1, $Pos2, $l, $t, $b, $r
Global $SaveDir, $FileType = ".jpg", $AutoIncBool = True, $Mode = "FS", $FileName, $Count = 0, $Reciving, $Hex = "7B", $Hwd, $Title, $Bool = 0, $Cursor = True, $Edit = True
Global $ActiveHwd

$gui = GUICreate("Windows Screener", 600, 136, -1, -1, -1) ;New Width: 825
$savelabel = GUICtrlCreateLabel("Choose Dictionary:", 1, 5, 120, 20, $SS_CENTER)
$saveinput = GUICtrlCreateInput("", 123, 5, 322, 20, $ES_READONLY)
$browse = GUICtrlCreateButton("Browse..", 450, 3, 120, 25, $BS_CENTER)
$typelabel = GUICtrlCreateLabel("Choose File Type :", 1, 30, 120, 20, $SS_CENTER)
GUICtrlCreateGroup("", 120, 25, 450, 30)
$jpgradio = GUICtrlCreateRadio("JPG", 125, 32, 60, 20)
$bmpradio = GUICtrlCreateRadio("BMP", 190, 32, 60, 20)
$gifradio = GUICtrlCreateRadio("GIF", 255, 32, 60, 20)
$pngradio = GUICtrlCreateRadio("PNG", 320, 32, 60, 20)
$tifradio = GUICtrlCreateRadio("TIF", 385, 32, 60, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$filelabel = GUICtrlCreateLabel("Insert File Name : ", 1, 60, 120, 20, $SS_CENTER)
$fileinput = GUICtrlCreateInput("ScreenShot", 123, 60, 200, 20)
$autoinc = GUICtrlCreateCheckbox("Auto Increase", 327, 60, 103, 20, -1)
$editcheck = GUICtrlCreateCheckbox("Edit", 430, 60, 50, 20, -1)
$cursorcheck = GUICtrlCreateCheckbox("Cursor", 483, 60, 90, 20, -1)
$usermode = GUICtrlCreateLabel("Usable Mode: ", 1, 85, 150, 20, $SS_CENTER)
GUICtrlCreateGroup("", 120, 78, 450, 30)
$fsradio = GUICtrlCreateRadio("Full Screen", 125, 85, 90, 20)
$drawradio = GUICtrlCreateRadio("Drawn Region", 220, 85, 105, 20)
$programradio = GUICtrlCreateRadio("Program Title", 335, 85, 100, 20)
$activeradio = GUICtrlCreateRadio("Active Windows", 438, 85, 120, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$keybutton = GUICtrlCreateButton("Set Hotkey", 2, 108, 118, 25)
$keyinput = GUICtrlCreateInput("{F12}", 125, 110, 120, 20, $ES_READONLY + $ES_CENTER)
$drawbutton = GUICtrlCreateButton("Draw Region", 250, 108, 118, 25)
$WindowsInput = GUICtrlCreateInput("Your Windows Title", 370, 110, 200, 20)
$Expand = GUICtrlCreateButton(">", 575, 1, 20, 134)
$QualityLabel = GUICtrlCreateLabel("Control Panel", 600, 5, 240, 30, $SS_CENTER)
$jpglabel = GUICtrlCreateLabel("JPG: ", 600, 30, 40, 20)
$bmplabel = GUICtrlCreateLabel("BMP: ", 600, 60, 40, 20)
$Tiflabel = GUICtrlCreateLabel("TIF: ", 600, 85, 40, 20)
$jpgslider = GUICtrlCreateSlider(645, 30, 170, 20)
$bmpslider = GUICtrlCreateSlider(645, 60, 170, 20)
$tifslider1 = GUICtrlCreateSlider(645, 85, 170, 20)
$tifslider2 = GUICtrlCreateSlider(645, 108, 170, 20)



GUICtrlSetFont($savelabel, 11, 400, 0, "Tahoma")
GUICtrlSetFont($browse, 11, 400, 0, "Tahoma")
GUICtrlSetFont($typelabel, 11, 400, 0, "Tahoma")
GUICtrlSetFont($jpgradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($bmpradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($filelabel, 11, 400, 0, "Tahoma")
GUICtrlSetFont($autoinc, 11, 400, 0, "Tahoma")
GUICtrlSetFont($fileinput, 9, 400, 0, "Tahoma")
GUICtrlSetFont($saveinput, 9, 400, 0, "Tahoma")
GUICtrlSetFont($usermode, 11, 400, 0, "Tahoma")
GUICtrlSetFont($fsradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($drawradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($programradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($activeradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($keybutton, 11, 400, 0, "Tahoma")
GUICtrlSetFont($drawbutton, 11, 400, 0, "Tahoma")
GUICtrlSetFont($WindowsInput, 9, 400, 0, "Tahoma")
GUICtrlSetFont($editcheck, 11, 400, 0, "Tahoma")
GUICtrlSetFont($cursorcheck, 11, 400, 0, "Tahoma")
GUICtrlSetFont($keyinput, 9, 400, 0, "Tahoma")
GUICtrlSetFont($Expand, 11, 400, 0, "Tahoma")
GUICtrlSetFont($gifradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($pngradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($tifradio, 11, 400, 0, "Tahoma")
GUICtrlSetFont($QualityLabel, 12, 400, 0, "Tahoma")
GUICtrlSetFont($jpglabel, 11, 400, 0, "Tahoma")
GUICtrlSetFont($bmplabel, 11, 400, 0, "Tahoma")
GUICtrlSetFont($Tiflabel, 11, 400, 0, "Tahoma")
GUISetFont(9, 400, 0, "Tahoma")
GUICtrlSetData($saveinput, @DesktopDir)
GUICtrlSetLimit($fileinput, 40, 0)
GUICtrlSetLimit($jpgslider, 10, 0)
GUICtrlSetLimit($bmpslider, 4, 0)
GUICtrlSetLimit($tifslider1, 2, 0)
GUICtrlSetLimit($tifslider2, 2, 0)
GUICtrlSetTip($saveinput, "Click Browse to select save dictionary", "Help", 1, 1)
GUICtrlSetTip($WindowsInput, "Ctrl+Left Click to get Windows Title", "Help", 1, 1)
GUICtrlSetTip($fileinput, "Enter the name of the image", "Help", 1, 1)

GUICtrlSetState($autoinc, $GUI_CHECKED)
GUICtrlSetState($editcheck, $GUI_CHECKED)
GUICtrlSetState($cursorcheck, $GUI_CHECKED)
GUICtrlSetState($jpgradio, $GUI_CHECKED)
GUICtrlSetState($fsradio, $GUI_CHECKED)
GUICtrlSetState($drawradio, $GUI_DISABLE)

GUICtrlSetOnEvent($Expand, "_Sliding")
GUICtrlSetOnEvent($jpgslider, "_JPGSlide")
GUICtrlSetOnEvent($bmpslider, "_BMPSlide")
GUICtrlSetOnEvent($tifslider1, "_TifSlide1")
GUICtrlSetOnEvent($tifslider2, "_TifSlide2")
GUICtrlSetOnEvent($keybutton, "_SetHotkey")
GUICtrlSetOnEvent($drawbutton, "_DrawRegion")
GUICtrlSetOnEvent($fsradio, "_FSMode")
GUICtrlSetOnEvent($drawradio, "_DRMode")
GUICtrlSetOnEvent($programradio, "_PTMode")
GUICtrlSetOnEvent($activeradio, "_AWMode")
GUICtrlSetOnEvent($jpgradio, "_FileToJpg")
GUICtrlSetOnEvent($bmpradio, "_FileToBmp")
GUICtrlSetOnEvent($gifradio, "_FileToGif")
GUICtrlSetOnEvent($tifradio, "_FileToTif")
GUICtrlSetOnEvent($pngradio, "_FileToPng")
GUICtrlSetOnEvent($autoinc, "_AutoInc")
GUICtrlSetOnEvent($browse, "_Browse")
GUICtrlSetOnEvent($editcheck, "_EditCheck")
GUICtrlSetOnEvent($cursorcheck, "_CursorCheck")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

_Hide()
WinSetTrans($gui, "", 0)
_FadeIn()

While 1
	_Check()
	_Setting()
	_ActiveHwd()
	If _IsPressed("01") And _IsPressed("A2") Then
		$Winlist = WinList()
		For $list = 1 To $Winlist[0][0]
			If WinActive($Winlist[$list][1]) Then
				$WinTitle = $Winlist[$list][0]
				$Hwd = $Winlist[$list][1]
			EndIf
		Next
		ControlSetText($gui, "", "Edit4", $WinTitle)
	EndIf
	If _IsPressed($Hex) Then
		If $AutoIncBool Then
			If $Mode = "FS" Then
				_ScreenCap_Capture ($SaveDir & "\" & $FileName & " - " & $Count & $FileType, 0, 0, -1, -1, $Cursor)
				_TrayTip()
				_ShellExecute()
				$Count = $Count + 1
			ElseIf $Mode = "DR" Then
				_ScreenCap_Capture ($SaveDir & "\" & $FileName & " - " & $Count & $FileType, $l, $t, $r, $b, $Cursor)
				_TrayTip()
				_ShellExecute()
				$Count = $Count + 1
			ElseIf $Mode = "PT" Then
				If Not WinExists($Title, "") Then
					_ToolTip()
				Else
					_ScreenCap_CaptureWnd ($SaveDir & "\" & $FileName & " - " & $Count & $FileType, $Hwd, 0, 0, -1, -1, $Cursor)
					_TrayTip()
					_ShellExecute()
					$Count = $Count + 1
				EndIf
			ElseIf $Mode = "AW" Then
				_ScreenCap_CaptureWnd ($SaveDir & "\" & $FileName & " - " & $Count & $FileType, $ActiveHwd, 0, 0, -1, -1, $Cursor)
				_TrayTip()
				_ShellExecute()
				$Count = $Count + 1
			EndIf
		Else
			If $Mode = "FS" Then
				_ScreenCap_Capture ($SaveDir & "\" & $FileName & $FileType, 0, 0, -1, -1, $Cursor)
				_TrayTip()
				_ShellExecute()
			ElseIf $Mode = "DR" Then
				_ScreenCap_Capture ($SaveDir & "\" & $FileName & $FileType, $l, $t, $r, $b, $Cursor)
				_TrayTip()
				_ShellExecute()
			ElseIf $Mode = "PT" Then
				If Not WinExists($Title, "") Then
					_ToolTip()
				Else
					_ScreenCap_CaptureWnd ($SaveDir & "\" & $FileName & $FileType, $Hwd, 0, 0, -1, -1, $Cursor)
					_TrayTip()
					_ShellExecute()
				EndIf
			ElseIf $Mode = "AW" Then
				_ScreenCap_CaptureWnd ($SaveDir & "\" & $FileName & $FileType, $ActiveHwd, 0, 0, -1, -1, $Cursor)
				_TrayTip()
				_ShellExecute()
			EndIf
		EndIf
		While _IsPressed($Hex)
			Sleep(1)
		WEnd
	EndIf
	Sleep(1)
WEnd
Func _Exit()
	_FadeOut()
	Exit
EndFunc   ;==>_Exit
Func _Browse()
	$Dir = FileSelectFolder("", "", 1)
	If @error = 1 Then
		Return
	Else
		GUICtrlSetData($saveinput, $Dir)
	EndIf
EndFunc   ;==>_Browse
Func _AutoInc()
	$AutoIncBool = Not $AutoIncBool
EndFunc   ;==>_AutoInc
Func _FileToJpg()
	$FileType = ".jpg"
EndFunc   ;==>_FileToJpg
Func _FileToTif()
	$FileType = ".tif"
EndFunc   ;==>_FileToTif
Func _FileToPng()
	$FileType = ".png"
EndFunc   ;==>_FileToPng
Func _FileToGif()
	$FileType = ".gif"
EndFunc   ;==>_FileToGif
Func _FileToBmp()
	$FileType = ".bmp"
EndFunc   ;==>_FileToBmp
Func _FSMode()
	$Mode = "FS"
EndFunc   ;==>_FSMode
Func _DRMode()
	$Mode = "DR"
EndFunc   ;==>_DRMode
Func _PTMode()
	$Mode = "PT"
EndFunc   ;==>_PTMode
Func _AWMode()
	$Mode = "AW"
EndFunc   ;==>_AWMode
Func _Check()
	$Title = GUICtrlRead($WindowsInput)
	$SaveDir = GUICtrlRead($saveinput)
	$FileName = GUICtrlRead($fileinput)
	Return $Title And $SaveDir And $fileinput
EndFunc   ;==>_Check
Func _Setting()
	_ScreenCap_SetJPGQuality (GUICtrlRead($jpgslider) * 10)
	_ScreenCap_SetBMPFormat (GUICtrlRead($bmpslider))
	_ScreenCap_SetTIFColorDepth (_TifColorDepth())
	_ScreenCap_SetTIFCompression (GUICtrlRead($tifslider2))
EndFunc   ;==>_Setting
Func _DrawRegion()
	_FadeOut()
	Do
		Local $Pos = MouseGetPos()
		ToolTip("Draw Region" & @CRLF & "Mouse Coord: " & $Pos[0] & "," & $Pos[1])
	Until _IsPressed("01")
	If _IsPressed("01") Then
		$Pos1 = MouseGetPos()
		Do
			$Pos2 = MouseGetPos()
			_Compare()
			ToolTip("Drawing Region" & @CRLF & "Left: " & $l & @CRLF & "Top: " & $t & @CRLF & "Bottom: " & $b & @CRLF & "Right: " & $r & @CRLF & "Image Size:" & $r - $l & "x" & $b - $t)
		Until Not _IsPressed("01")
		ToolTip("")
		If Not _Compare() Then TrayTip("Windows Screener", "Invaild Coord", "", 1)
	EndIf
	GUICtrlSetState($drawradio, $GUI_ENABLE)
	_FadeIn()
EndFunc   ;==>_DrawRegion
Func _SetHotkey()
	_FadeOut()
	$Reciving = True
	Do
		For $i = 8 To 165
			If _IsPressed(Hex($i, 2)) Then
				$Hex = Hex($i, 2)
				If $Hex = "08" Then GUICtrlSetData($keyinput, "{" & "BACKSPACE" & "}")
				If $Hex = "09" Then GUICtrlSetData($keyinput, "{" & "TAB" & "}")
				If $Hex = "0C" Then GUICtrlSetData($keyinput, "{" & "ClEAR" & "}")
				If $Hex = "0D" Then GUICtrlSetData($keyinput, "{" & "ENTER" & "}")
				If $Hex = "10" Then GUICtrlSetData($keyinput, "{" & "SHIFT" & "}")
				If $Hex = "11" Then GUICtrlSetData($keyinput, "{" & "CTRL" & "}")
				If $Hex = "12" Then GUICtrlSetData($keyinput, "{" & "ALT" & "}")
				If $Hex = "13" Then GUICtrlSetData($keyinput, "{" & "PAUSE" & "}")
				If $Hex = "14" Then GUICtrlSetData($keyinput, "{" & "CAPS LOCK" & "}")
				If $Hex = "1B" Then GUICtrlSetData($keyinput, "{" & "ESC" & "}")
				If $Hex = "20" Then GUICtrlSetData($keyinput, "{" & "SPACEBAR" & "}")
				If $Hex = "21" Then GUICtrlSetData($keyinput, "{" & "PAGE UP" & "}")
				If $Hex = "22" Then GUICtrlSetData($keyinput, "{" & "PAGE DOWN" & "}")
				If $Hex = "23" Then GUICtrlSetData($keyinput, "{" & "END" & "}")
				If $Hex = "24" Then GUICtrlSetData($keyinput, "{" & "HOME" & "}")
				If $Hex = "25" Then GUICtrlSetData($keyinput, "{" & "LEFT ARROW" & "}")
				If $Hex = "26" Then GUICtrlSetData($keyinput, "{" & "UP ARROW" & "}")
				If $Hex = "27" Then GUICtrlSetData($keyinput, "{" & "RIGHT ARROW" & "}")
				If $Hex = "28" Then GUICtrlSetData($keyinput, "{" & "DOWN ARROW" & "}")
				If $Hex = "29" Then GUICtrlSetData($keyinput, "{" & "SELECT" & "}")
				If $Hex = "2A" Then GUICtrlSetData($keyinput, "{" & "PRINT" & "}")
				If $Hex = "2B" Then GUICtrlSetData($keyinput, "{" & "EXECUTE" & "}")
				If $Hex = "2C" Then GUICtrlSetData($keyinput, "{" & "PRINT SCREEN" & "}")
				If $Hex = "2D" Then GUICtrlSetData($keyinput, "{" & "INS" & "}")
				If $Hex = "2E" Then GUICtrlSetData($keyinput, "{" & "DEL" & "}")
				If $Hex = "30" Then GUICtrlSetData($keyinput, "{" & "0" & "}")
				If $Hex = "31" Then GUICtrlSetData($keyinput, "{" & "1" & "}")
				If $Hex = "32" Then GUICtrlSetData($keyinput, "{" & "2" & "}")
				If $Hex = "33" Then GUICtrlSetData($keyinput, "{" & "3" & "}")
				If $Hex = "34" Then GUICtrlSetData($keyinput, "{" & "4" & "}")
				If $Hex = "35" Then GUICtrlSetData($keyinput, "{" & "5" & "}")
				If $Hex = "36" Then GUICtrlSetData($keyinput, "{" & "6" & "}")
				If $Hex = "37" Then GUICtrlSetData($keyinput, "{" & "7" & "}")
				If $Hex = "38" Then GUICtrlSetData($keyinput, "{" & "8" & "}")
				If $Hex = "39" Then GUICtrlSetData($keyinput, "{" & "9" & "}")
				If $Hex = "41" Then GUICtrlSetData($keyinput, "{" & "A" & "}")
				If $Hex = "42" Then GUICtrlSetData($keyinput, "{" & "B" & "}")
				If $Hex = "43" Then GUICtrlSetData($keyinput, "{" & "C" & "}")
				If $Hex = "44" Then GUICtrlSetData($keyinput, "{" & "D" & "}")
				If $Hex = "45" Then GUICtrlSetData($keyinput, "{" & "E" & "}")
				If $Hex = "46" Then GUICtrlSetData($keyinput, "{" & "F" & "}")
				If $Hex = "47" Then GUICtrlSetData($keyinput, "{" & "G" & "}")
				If $Hex = "48" Then GUICtrlSetData($keyinput, "{" & "H" & "}")
				If $Hex = "49" Then GUICtrlSetData($keyinput, "{" & "I" & "}")
				If $Hex = "4A" Then GUICtrlSetData($keyinput, "{" & "J" & "}")
				If $Hex = "4B" Then GUICtrlSetData($keyinput, "{" & "K" & "}")
				If $Hex = "4C" Then GUICtrlSetData($keyinput, "{" & "L" & "}")
				If $Hex = "4D" Then GUICtrlSetData($keyinput, "{" & "M" & "}")
				If $Hex = "4E" Then GUICtrlSetData($keyinput, "{" & "N" & "}")
				If $Hex = "4F" Then GUICtrlSetData($keyinput, "{" & "O" & "}")
				If $Hex = "50" Then GUICtrlSetData($keyinput, "{" & "P" & "}")
				If $Hex = "51" Then GUICtrlSetData($keyinput, "{" & "Q" & "}")
				If $Hex = "52" Then GUICtrlSetData($keyinput, "{" & "R" & "}")
				If $Hex = "53" Then GUICtrlSetData($keyinput, "{" & "S" & "}")
				If $Hex = "54" Then GUICtrlSetData($keyinput, "{" & "T" & "}")
				If $Hex = "55" Then GUICtrlSetData($keyinput, "{" & "U" & "}")
				If $Hex = "56" Then GUICtrlSetData($keyinput, "{" & "V" & "}")
				If $Hex = "57" Then GUICtrlSetData($keyinput, "{" & "W" & "}")
				If $Hex = "58" Then GUICtrlSetData($keyinput, "{" & "X" & "}")
				If $Hex = "59" Then GUICtrlSetData($keyinput, "{" & "Y" & "}")
				If $Hex = "5A" Then GUICtrlSetData($keyinput, "{" & "Z" & "}")
				If $Hex = "5B" Then GUICtrlSetData($keyinput, "{" & "Left Windows" & "}")
				If $Hex = "5C" Then GUICtrlSetData($keyinput, "{" & "Right Windows" & "}")
				If $Hex = "60" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 0" & "}")
				If $Hex = "61" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 1" & "}")
				If $Hex = "62" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 2" & "}")
				If $Hex = "63" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 3" & "}")
				If $Hex = "64" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 4" & "}")
				If $Hex = "65" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 5" & "}")
				If $Hex = "66" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 6" & "}")
				If $Hex = "67" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 7" & "}")
				If $Hex = "68" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 8" & "}")
				If $Hex = "69" Then GUICtrlSetData($keyinput, "{" & "NUMPAD 9" & "}")
				If $Hex = "6A" Then GUICtrlSetData($keyinput, "{" & "NUMPAD *" & "}")
				If $Hex = "6B" Then GUICtrlSetData($keyinput, "{" & "NUMPAD +" & "}")
				If $Hex = "6C" Then GUICtrlSetData($keyinput, "{" & "NUMPAD Separator" & "}")
				If $Hex = "6D" Then GUICtrlSetData($keyinput, "{" & "NUMPAD -" & "}")
				If $Hex = "6E" Then GUICtrlSetData($keyinput, "{" & "NUMPAD ." & "}")
				If $Hex = "6F" Then GUICtrlSetData($keyinput, "{" & "NUMPAD /" & "}")
				If $Hex = "70" Then GUICtrlSetData($keyinput, "{" & "F1" & "}")
				If $Hex = "71" Then GUICtrlSetData($keyinput, "{" & "F2" & "}")
				If $Hex = "72" Then GUICtrlSetData($keyinput, "{" & "F3" & "}")
				If $Hex = "73" Then GUICtrlSetData($keyinput, "{" & "F4" & "}")
				If $Hex = "74" Then GUICtrlSetData($keyinput, "{" & "F5" & "}")
				If $Hex = "75" Then GUICtrlSetData($keyinput, "{" & "F6" & "}")
				If $Hex = "76" Then GUICtrlSetData($keyinput, "{" & "F7" & "}")
				If $Hex = "77" Then GUICtrlSetData($keyinput, "{" & "F8" & "}")
				If $Hex = "78" Then GUICtrlSetData($keyinput, "{" & "F9" & "}")
				If $Hex = "79" Then GUICtrlSetData($keyinput, "{" & "F10" & "}")
				If $Hex = "7A" Then GUICtrlSetData($keyinput, "{" & "F11" & "}")
				If $Hex = "7B" Then GUICtrlSetData($keyinput, "{" & "F12" & "}")
				If $Hex = "90" Then GUICtrlSetData($keyinput, "{" & "NUM LOCK" & "}")
				If $Hex = "91" Then GUICtrlSetData($keyinput, "{" & "SCROLL LOCK" & "}")
				If $Hex = "A4" Then GUICtrlSetData($keyinput, "{" & "LEFT MENU" & "}")
				If $Hex = "A5" Then GUICtrlSetData($keyinput, "{" & "RIGHT MENU" & "}")
				$Reciving = False
			EndIf
		Next
	Until $Reciving = False
	_FadeIn()
EndFunc   ;==>_SetHotkey
Func _FadeOut()
	For $i = 255 To 0 Step - 1
		WinSetTrans($gui, "", $i)
	Next
	GUISetState(@SW_HIDE, $gui)
EndFunc   ;==>_FadeOut
Func _FadeIn()
	GUISetState(@SW_SHOW, $gui)
	For $i = 0 To 255
		WinSetTrans($gui, "", $i)
	Next
EndFunc   ;==>_FadeIn
Func _ToolTip()
	TrayTip("Windows Screener", $Title & " was not found", "", 1)
EndFunc   ;==>_ToolTip
Func _TrayTip()
	If $AutoIncBool Then
		TrayTip("Screenshot has been successfully saved", "Saved Dir: " & $SaveDir & @CRLF & "FileName: " & $FileName & " - " & $Count & $FileType, "", 1)
	Else
		TrayTip("Screenshot has been successfully saved", "Saved Dir: " & $SaveDir & @CRLF & "FileName: " & $FileName & $FileType, "", 1)
	EndIf
EndFunc   ;==>_TrayTip
Func _Compare()
	If $Pos2[0] < $Pos1[0] And $Pos2[1] < $Pos1[1] Then
		$l = $Pos2[0]
		$t = $Pos2[1]
		$b = $Pos1[1]
		$r = $Pos1[0]
		Return 1
	ElseIf $Pos2[0] > $Pos1[0] And $Pos2[1] < $Pos1[1] Then
		$l = $Pos1[0]
		$t = $Pos2[1]
		$b = $Pos1[1]
		$r = $Pos2[0]
		Return 1
	ElseIf $Pos2[0] > $Pos1[0] And $Pos2[1] > $Pos1[1] Then
		$l = $Pos1[0]
		$t = $Pos1[1]
		$b = $Pos2[1]
		$r = $Pos2[0]
		Return 1
	ElseIf $Pos2[0] < $Pos1[0] And $Pos2[1] > $Pos1[1] Then
		$l = $Pos2[0]
		$t = $Pos1[1]
		$b = $Pos2[1]
		$r = $Pos1[0]
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_Compare
Func _JPGSlide()
	TrayTip("Windows Resizer", "You have set the quality for jpg to " & GUICtrlRead($jpgslider) * 10, "", 1)
EndFunc   ;==>_JPGSlide
Func _BMPSlide()
	If GUICtrlRead($bmpslider) = 0 Then
		TrayTip("Windows Resizer", "You have set the BMP format to 16 bpp; 5 bits for each RGB component", "", 1)
	ElseIf GUICtrlRead($bmpslider) = 1 Then
		TrayTip("Windows Resizer", "You have set the BMP format to 16 bpp; 5 bits for red, 6 bits for green and 5 bits blue", "", 1)
	ElseIf GUICtrlRead($bmpslider) = 2 Then
		TrayTip("Windows Resizer", "You have set the BMP format to 24 bpp; 8 bits for each RGB component", "", 1)
	ElseIf GUICtrlRead($bmpslider) = 3 Then
		TrayTip("Windows Resizer", "You have set the BMP format to 32 bpp; 8 bits for each RGB component. No alpha component", "", 1)
	ElseIf GUICtrlRead($bmpslider) = 4 Then
		TrayTip("Windows Resizer", "You have set the BMP format to 8 bits for each RGB and alpha component", "", 1)
	EndIf
EndFunc   ;==>_BMPSlide
Func _TifSlide1()
	If GUICtrlRead($tifslider1) = 0 Then
		TrayTip("Windows Resizer", "You have set the color depth to Default encoder color depth", "", 1)
	ElseIf GUICtrlRead($tifslider1) = 1 Then
		TrayTip("Windows Resizer", "You have set the color depth to 24 bit", "", 1)
	ElseIf GUICtrlRead($tifslider1) = 2 Then
		TrayTip("Windows Resizer", "You have set the color depth to 32 bit", "", 1)
	EndIf
EndFunc   ;==>_TifSlide1
Func _TifSlide2()
	If GUICtrlRead($tifslider2) = 0 Then
		TrayTip("Windows Resizer", "You have set the compression used for TIFF to Default encoder compression", "", 1)
	ElseIf GUICtrlRead($tifslider2) = 1 Then
		TrayTip("Windows Resizer", "You have set the compression used for TIFF to No compression", "", 1)
	ElseIf GUICtrlRead($tifslider2) = 2 Then
		TrayTip("Windows Resizer", "You have set the compression used for TIFF to LZW compression", "", 1)
	EndIf
EndFunc   ;==>_TifSlide2
Func _TifColorDepth()
	If GUICtrlRead($tifslider1) = 0 Then
		Return 0
	ElseIf GUICtrlRead($tifslider1) = 1 Then
		Return 24
	ElseIf GUICtrlRead($tifslider1) = 2 Then
		Return 32
	EndIf
EndFunc   ;==>_TifColorDepth
Func _Sliding()
	$Bool = Not $Bool
	If $Bool Then
		GUICtrlSetData($Expand, "<")
		_SlideOut()
	Else
		GUICtrlSetData($Expand, ">")
		_SlideIn()
	EndIf
EndFunc   ;==>_Sliding
Func _SlideOut()
	Local $WinPos = WinGetPos($gui, "")
	_Show()
	_FadeOut()
	WinMove($gui, "", $WinPos[0], $WinPos[1], 825, 160)
	_FadeIn()
EndFunc   ;==>_SlideOut
Func _SlideIn()
	Local $WinPos = WinGetPos($gui, "")
	_FadeOut()
	WinMove($gui, "", $WinPos[0], $WinPos[1], 603, 160)
	_FadeIn()
	_Hide()
EndFunc   ;==>_SlideIn
Func _Show()
	GUICtrlSetState($jpglabel, $GUI_SHOW)
	GUICtrlSetState($bmplabel, $GUI_SHOW)
	GUICtrlSetState($Tiflabel, $GUI_SHOW)
	GUICtrlSetState($jpgslider, $GUI_SHOW)
	GUICtrlSetState($bmpslider, $GUI_SHOW)
	GUICtrlSetState($tifslider1, $GUI_SHOW)
	GUICtrlSetState($tifslider2, $GUI_SHOW)
	GUICtrlSetState($QualityLabel, $GUI_SHOW)
EndFunc   ;==>_Show
Func _Hide()
	GUICtrlSetState($jpglabel, $GUI_HIDE)
	GUICtrlSetState($bmplabel, $GUI_HIDE)
	GUICtrlSetState($Tiflabel, $GUI_HIDE)
	GUICtrlSetState($jpgslider, $GUI_HIDE)
	GUICtrlSetState($bmpslider, $GUI_HIDE)
	GUICtrlSetState($tifslider1, $GUI_HIDE)
	GUICtrlSetState($tifslider2, $GUI_HIDE)
	GUICtrlSetState($QualityLabel, $GUI_HIDE)
EndFunc   ;==>_Hide
Func _EditCheck()
	$Edit = Not $Edit
EndFunc   ;==>_EditCheck
Func _CursorCheck()
	$Cursor = Not $Cursor
EndFunc   ;==>_CursorCheck
Func _ActiveHwd()
	$Winlist = WinList()
	For $list = 1 To $Winlist[0][0]
		If WinActive($Winlist[$list][1]) Then
			$WinTitle = $Winlist[$list][0]
			$ActiveHwd = $Winlist[$list][1]
		EndIf
	Next
EndFunc   ;==>_ActiveHwd
Func _ShellExecute()
	If $Edit And $AutoIncBool Then
		ShellExecute($SaveDir & "\" & $FileName & " - " & $Count & $FileType)
	ElseIf $Edit And Not $AutoIncBool Then
		ShellExecute($SaveDir & "\" & $FileName & $FileType)
	EndIf
EndFunc   ;==>_ShellExecute