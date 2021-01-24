;================================================================================
;#  Title .........: AVICapture.au3												#
;#  Description ...: Capture screen as .avi file								#
;#  Date ..........: 31.12.08													#
;#  Version .......: 1.4.0														#
;#  Author ........: FireFox													#
;#  Special thanks.: Monoceres for AVIWritter source code						#
;#	Notes..........: Happy New year 2009 !
;#  Copyright......: d3mon Corporation. All rights reserved						#
;#      (only functions from other authors are not in my copyright)				#
;================================================================================

#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ScreenCapture.au3>
#include <AVIWriter.au3>
#include <IsPressed_UDF.au3>
;-----------------------


#Region Variables
Local $AVI, $Ext, $timer, $OutAvi
Local $frame, $Outframe, $what
Global $CUR = False, $Capture = False
Global Const $SC_CONTEXTHELP = 0xF180
Global $comp = False
#EndRegion Variables
;-------------------


#Region Tray
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
$Menu = TrayCreateMenu("AVICapture")
TrayCreateItem("SHOW", $Menu)
TrayItemSetOnEvent(-1, "_SHOW")
TrayCreateItem("HIDE", $Menu)
TrayItemSetOnEvent(-1, "_HIDE")
TrayCreateItem('', $Menu)
TrayCreateItem("Stop", $Menu)
TrayItemSetOnEvent(-1, "_Stop")

TrayCreateItem("help/About...")
TrayItemSetOnEvent(-1, "_Help")
TrayCreateItem('')
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Exit")

TraySetOnEvent(-13, "_SHOW")
TraySetToolTip("Avi Capture v1.4")
#EndRegion Tray
;--------------


#Region GUI
Opt("GuiOnEventMode", 1)
$win = GUICreate("AVICapture  v1.4", 325, 220, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU), $WS_EX_CONTEXTHELP)
GUIRegisterMsg($WM_SYSCOMMAND, "_WM_SYSCOMMAND")
GUISetOnEvent($GUI_EVENT_CLOSE, "_HIDE")
$Dummy = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_Help")

GUICtrlCreateTab(5, 5, 315, 210)
GUICtrlCreateTabItem("AVI")

GUICtrlCreateGroup("Capture", 15, 35, 90, 170)
$fullscreen = GUICtrlCreateRadio("full screen", 25, 50)
GUICtrlSetState($fullscreen, $GUI_CHECKED)
$window = GUICtrlCreateRadio("window", 25, 90)
$noicon = GUICtrlCreateRadio("no icon", 25, 70)
$notaskbar = GUICtrlCreateRadio("no taskbar", 25, 110)
$nodesktop = GUICtrlCreateRadio("no desktop", 25, 130)
$region = GUICtrlCreateRadio("region", 25, 150)

$Play = GUICtrlCreateButton("Play", 35, 175, 50, 20)
GUICtrlSetOnEvent(-1, "_Start")

GUICtrlCreateGroup("timer", 110, 35, 200, 37)
GUICtrlCreateLabel("Stop video after :", 120, 50, 95, 15)
$Edittime = GUICtrlCreateEdit("0", 208, 49, 30, 17, $ES_NUMBER)
GUICtrlCreateLabel("sec(s)", 243, 50, 30, 15)


GUICtrlCreateGroup("Config", 110, 80, 200, 125)
$ShowCursor = GUICtrlCreateCheckbox("Show Cursor", 120, 95)
$CompressAvi = GUICtrlCreateCheckbox("Compress Avi", 120, 120)

$comboframe = GUICtrlCreateCombo('FRAME', 220, 95, 80, 17, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, '3|5|10|12|15|24|25|30|50|60|---', 'FRAME')

GUICtrlCreateLabel("Output Avi :", 220, 124)
GUICtrlCreateButton("...", 280, 122, 20, 17)
GUICtrlSetOnEvent(-1, "_OutAvi")
$EditAvi = GUICtrlCreateEdit(@ScriptDir, 120, 145, 180, 17, _
		$ES_READONLY + $ES_AUTOHSCROLL)

GUICtrlCreateLabel("Record :", 120, 168, 45, 15)
$RecordAvi = GUICtrlCreateLabel("0 sec(s)", 165, 168, 50, 15)
GUICtrlCreateLabel("Size :", 120, 186, 45, 15)
$AviSize = GUICtrlCreateLabel("~0 Mo", 150, 186, 100, 15)

GUICtrlCreateTabItem("BMP")
GUICtrlCreateGroup("Config", 15, 35, 295, 170)
GUICtrlCreateLabel("Output frame(s) :", 25, 55)
GUICtrlCreateButton("...", 110, 54, 20, 17)
GUICtrlSetOnEvent(-1, "_OutFrame")
$Editframe = GUICtrlCreateEdit(@ScriptDir, 25, 75, 180, 17, _
		$ES_READONLY + $ES_AUTOHSCROLL)

$enableframe = GUICtrlCreateCheckbox("Enable output frame(s)", 25, 95)
$enableavi = GUICtrlCreateCheckbox("Enable output avi", 25, 115)
GUICtrlSetState(-1, $GUI_CHECKED)

$comboext = GUICtrlCreateCombo('EXT', 150, 52, 50, 17, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, 'BMP|JPG|PNG|GIF|TIF', 'EXT')

$autohide = GUICtrlCreateCheckbox("Hide window when play", 25, 135)
GUISetState(@SW_HIDE, $win)

;-------------Get Handle---------------
$capturewnd = GUICreate("Get Handle", 70, 14, 50, 50, $WS_BORDER + $WS_POPUP, $WS_EX_TOPMOST, $win)
$handle = GUICtrlCreateLabel('', 5, 0, 65, 15)
GUISetState(@SW_HIDE, $capturewnd)
#EndRegion GUI
;-------------


#Region Check
If _CheckRun(@ScriptName, 1) Then Exit
_CheckRun(@ScriptName, 0)
GUISetState(@SW_SHOW, $win)

If Not FileExists(@ScriptDir & "\ffmpeg.exe") Then
	MsgBox(48, "AVICapture", "Compression files not found !")
	GUICtrlSetState($CompressAvi, $GUI_DISABLE)
EndIf
#EndRegion Check
;---------------


#Region While
While 1
	Sleep(200)
	If _IsAndKeyPressed("11|12|70") Then
		_Start()
	ElseIf _IsAndKeyPressed("11|12|71") Then
		_Stop()
	ElseIf _IsAndKeyPressed("11|12|72") Then
		_HIDE()
	ElseIf _IsAndKeyPressed("11|12|73") Then
		_SHOW()
	EndIf
	
	If (GUICtrlRead($comboframe) = '---') Then
		$manualframe = InputBox("AVICapture - frame", "Enter number of frames for avi capture :", "24", '', 230, 75)
		If Not @error Then
			GUICtrlSetData($comboframe, $manualframe, 'FRAME')
		EndIf
	EndIf
WEnd
#EndRegion While
;---------------


#Region Script func
Func _HIDE()
	GUISetState(@SW_HIDE, $win)
EndFunc   ;==>_HIDE

Func _SHOW()
	GUISetState(@SW_SHOW, $win)
EndFunc   ;==>_SHOW

Func _Help()
	MsgBox(64, "AVICapture help/About...", "Author(s) : • monoceres for AVIWritter code" & _
			@CRLF & "--                • FireFox for program" & _
			@CRLF & "--                • Special thanks to AutoIt forum" & @CRLF & @CRLF & "Hotkey(s) :" & _
			@CRLF & "• Ctrl + Alt + F1 = Play         • Ctrl + Alt + F3 = Hide" & @CRLF & "• Ctrl + Alt + F2 = Stop   -    • Ctrl + Alt + F4 = Show")
EndFunc   ;==>_Help

Func _Start()
	Global $frame = GUICtrlRead($comboframe)
	Global $timer = GUICtrlRead($Edittime)
	
	If (GUICtrlRead($enableavi) == $GUI_CHECKED) Then
		Global $OutAvi = GUICtrlRead($EditAvi)
		Global $what = 'avi'
		
		If GUICtrlRead($comboframe) = 'FRAME' Then
			GUICtrlSetData($comboframe, 24, 'FRAME')
		ElseIf GUICtrlRead($comboframe) = '---' Then
			GUICtrlSetData($comboframe, 24, 'FRAME')
		EndIf
		
		If (GUICtrlRead($CompressAvi) == $GUI_CHECKED) Then
			Global $comp = True
		EndIf
		
		If (GUICtrlRead($region) == $GUI_CHECKED) Then
			Global $CUR = True
		EndIf
		
	ElseIf (GUICtrlRead($enableframe) == $GUI_CHECKED) Then
		If GUICtrlRead($comboext) = 'EXT' Then
			GUICtrlSetData($comboext, 'JPG', 'EXT')
		EndIf
		
		Global $Ext = GUICtrlRead($comboext)
		Global $Outframe = GUICtrlRead($Editframe)
		Global $what = 'frame'
	EndIf
	
	If (GUICtrlRead($fullscreen) == $GUI_CHECKED) Then
		_Capture('full screen', $what)
	ElseIf (GUICtrlRead($window) == $GUI_CHECKED) Then
		_Capture('window', $what)
	ElseIf (GUICtrlRead($noicon) == $GUI_CHECKED) Then
		_Capture('no icon', $what)
	ElseIf (GUICtrlRead($notaskbar) == $GUI_CHECKED) Then
		_Capture('no taskbar', $what)
	ElseIf (GUICtrlRead($nodesktop) == $GUI_CHECKED) Then
		_Capture('no desktop', $what)
	ElseIf (GUICtrlRead($region) == $GUI_CHECKED) Then
		_Capture('region', $what)
	EndIf
EndFunc   ;==>_Start


Func _Capture($param = 'full screen', $param2 = 'avi')
	GUICtrlSetState($Play, $GUI_DISABLE)
	If (GUICtrlRead($autohide) == $GUI_CHECKED) Then
		_HIDE()
	EndIf
	
	If $param2 = 'avi' Then
		FileDelete(@ScriptDir & "\temp.avi")
		_StartAviLibrary()
	EndIf
	
	If $param = 'region' Then
		TrayTip("Capture region", "press Left click to create region...", 1, 1)
		Do
			Sleep(10)
			$M = MouseGetPos()
		Until _IsPressed("01")
		$MW = $M[0]
		$MH = $M[1]
		$win2 = GUICreate("Capture Region", 10, 10, $MW, $MH, $WS_POPUP + $WS_BORDER)
		GUISetBkColor(0xFFFFFF, $win2)
		WinSetTrans($win2, '', 100)
		GUISetState(@SW_SHOW, $win2)
		TrayTip("Capture region", "press Left click to extend region...", 1, 1)
		Sleep(200)
		Do ;---
			Sleep(10)
			$M1 = MouseGetPos()
			WinMove($win2, '', $MW, $MH, $M1[0] - $MW, $M1[1] - $MH)
		Until _IsPressed("01")
		WinSetState($win2, '', @SW_HIDE)
		TrayTip('', '', 0)
		$MW1 = $M1[0]
		$MH1 = $M1[1]
		
		If $param2 = 'avi' Then
			$bmp = _ScreenCapture_Capture("", $MH, $MW, $MW1, $MH1, $CUR)
			Global $AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, $MW1, $MH1)
			FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
			_AddHBitmapToAvi($AVI, $bmp)
			_WinAPI_DeleteObject($bmp)
		EndIf
		Global $Capture = True
		$Init = TimerInit()
		$bmpSize = 0
		$nb = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsAndKeyPressed("11|12|71") Then
				_Stop()
			ElseIf _IsAndKeyPressed("11|12|72") Then
				_HIDE()
			ElseIf _IsAndKeyPressed("11|12|73") Then
				_SHOW()
			EndIf
			
			Sleep(1000 / $frame)
			If $param2 = 'avi' Then
				$bmp = _ScreenCapture_Capture("", $MH, $MW, $MW1, $MH1, $CUR)
				_AddHBitmapToAvi($AVI, $bmp)
				_WinAPI_DeleteObject($bmp)
				$bmpSize = $bmpSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
				GUICtrlSetData($AviSize, "~" & $bmpSize / 1000000 & " Mo")
			ElseIf $param2 = 'frame' Then
				_ScreenCapture_Capture($Outframe & '\frame' & $nb & '.' & $Ext, $MH, $MW, $MW1, $MH1, $CUR)
				$frameSize = DirGetSize($Outframe)
				GUICtrlSetData($AviSize, "~" & $bmpSize / 1000000 & " Mo")
				$nb = $nb + 1
			EndIf
		WEnd

	ElseIf $param = 'full screen' Then
		If $param2 = 'avi' Then
			$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			Global $AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @DesktopWidth, @DesktopHeight, 24)
			FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
			_AddHBitmapToAvi($AVI, $bmp)
			_WinAPI_DeleteObject($bmp)
		EndIf
		Global $Capture = True
		$Init = TimerInit()
		$bmpSize = 0
		$nb = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsAndKeyPressed("11|12|71") Then
				_Stop()
			ElseIf _IsAndKeyPressed("11|12|72") Then
				_HIDE()
			ElseIf _IsAndKeyPressed("11|12|73") Then
				_SHOW()
			EndIf
			
			Sleep(1000 / $frame)
			If $param2 = 'avi' Then
				$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				_AddHBitmapToAvi($AVI, $bmp)
				_WinAPI_DeleteObject($bmp)
				$bmpSize = $bmpSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
			ElseIf $param2 = 'frame' Then
				_ScreenCapture_Capture($Outframe & '\frame' & $nb & '.' & $Ext, 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				$frameSize = DirGetSize($Outframe)
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
				$nb = $nb + 1
			EndIf
		WEnd

	ElseIf $param = 'no taskbar' Then
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
		If $param2 = 'avi' Then
			$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			Global $AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @DesktopWidth, @DesktopHeight, 24)
			FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
			_AddHBitmapToAvi($AVI, $bmp)
			_WinAPI_DeleteObject($bmp)
			Global $Capture = True
		EndIf
		$Init = TimerInit()
		$bmpSize = 0
		$nb = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsAndKeyPressed("11|12|71") Then
				_Stop()
			ElseIf _IsAndKeyPressed("11|12|72") Then
				_HIDE()
			ElseIf _IsAndKeyPressed("11|12|73") Then
				_SHOW()
			EndIf
			
			Sleep(1000 / $frame)
			If $param2 = 'avi' Then
				$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				_AddHBitmapToAvi($AVI, $bmp)
				_WinAPI_DeleteObject($bmp)
				$bmpSize = $bmpSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
			ElseIf $param2 = 'frame' Then
				_ScreenCapture_Capture($Outframe & '\frame' & $nb & '.' & $Ext, 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				$frameSize = DirGetSize($Outframe)
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
				$nb = $nb + 1
			EndIf
		WEnd

	ElseIf $param = 'no icon' Then
		WinSetState("Program Manager", "", @SW_HIDE)
		If $param2 = 'avi' Then
			_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			Global $AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @DesktopWidth, @DesktopHeight, 24)
			FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
			_AddHBitmapToAvi($AVI, $bmp)
			_WinAPI_DeleteObject($bmp)
		EndIf
		Global $Capture = True
		$Init = TimerInit()
		$bmpSize = 0
		$nb = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsAndKeyPressed("11|12|71") Then
				_Stop()
			ElseIf _IsAndKeyPressed("11|12|72") Then
				_HIDE()
			ElseIf _IsAndKeyPressed("11|12|73") Then
				_SHOW()
			EndIf
			
			Sleep(1000 / $frame)
			If $param2 = 'avi' Then
				$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				_AddHBitmapToAvi($AVI, $bmp)
				_WinAPI_DeleteObject($bmp)
				$bmpSize = $bmpSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
			ElseIf $param2 = 'frame' Then
				_ScreenCapture_Capture($Outframe & '\frame' & $nb & '.' & $Ext, 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				$frameSize = DirGetSize($Outframe)
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
				$nb = $nb + 1
			EndIf
		WEnd

	ElseIf $param = 'window' Then
		GUISetState(@SW_SHOW, $capturewnd)
		TrayTip("Capture window", "press Left click on window to capture..." & _
				@CRLF & "then press esc to continue...", 1, 1)
		Do ;---
			Sleep(10)
			$wgh = WinGetHandle('', '')
			GUICtrlSetData($handle, $wgh)
		Until _IsPressed("1B")
		GUISetState(@SW_HIDE, $capturewnd)
		If $param2 = 'avi' Then
			$bmp = _ScreenCapture_CaptureWnd("", $wgh, 0, 0, -1, -1, $CUR)
			Global $AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @DesktopWidth, @DesktopHeight, 24)
			FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
			_AddHBitmapToAvi($AVI, $bmp)
			_WinAPI_DeleteObject($bmp)
		EndIf
		Global $Capture = True
		$Init = TimerInit()
		$bmpSize = 0
		$nb = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsPressed("11") And _IsPressed("71") Then
				_Stop()
			ElseIf _IsPressed("11") And _IsPressed("72") Then
				GUISetState(@SW_HIDE, $win)
			ElseIf _IsPressed("11") And _IsPressed("73") Then
				GUISetState(@SW_SHOW, $win)
			EndIf
			Sleep(1000 / $frame)
			If $param2 = 'avi' Then
				$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				_AddHBitmapToAvi($AVI, $bmp)
				_WinAPI_DeleteObject($bmp)
				$bmpSize = $bmpSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
			ElseIf $param2 = 'frame' Then
				_ScreenCapture_Capture($Outframe & '\frame' & $nb & '.' & $Ext, 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				$frameSize = DirGetSize($Outframe)
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
				$nb = $nb + 1
			EndIf
		WEnd

	ElseIf $param = 'no desktop' Then
		WinSetState("Program Manager", "", @SW_HIDE)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
		If $param2 = 'avi' Then
			$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			Global $AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @DesktopWidth, @DesktopHeight, 24)
			FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
			_AddHBitmapToAvi($AVI, $bmp)
			_WinAPI_DeleteObject($bmp)
			Global $Capture = True
		EndIf
		$Init = TimerInit()
		$bmpSize = 0
		$nb = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsAndKeyPressed("11|12|71") Then
				_Stop()
			ElseIf _IsAndKeyPressed("11|12|72") Then
				_HIDE()
			ElseIf _IsAndKeyPressed("11|12|73") Then
				_SHOW()
			EndIf
			
			Sleep(1000 / $frame)
			If $param2 = 'avi' Then
				$bmp = _ScreenCapture_Capture("", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				_AddHBitmapToAvi($AVI, $bmp)
				_WinAPI_DeleteObject($bmp)
				$bmpSize = $bmpSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
			ElseIf $param2 = 'frame' Then
				_ScreenCapture_Capture($Outframe & '\frame' & $nb & '.' & $Ext, 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
				$frameSize = DirGetSize($Outframe)
				GUICtrlSetData($AviSize, "~" & StringLeft($bmpSize / 1000000, 7) & " Mo")
				$nb = $nb + 1
			EndIf
		WEnd
	EndIf
EndFunc   ;==>_Capture


Func _Exit()
	If $AVI <> '' Then
		_CloseAvi($AVI)
		_StopAviLibrary()
	EndIf
	Exit
EndFunc   ;==>_Exit


Func _Stop()
	WinSetState("Program Manager", "", @SW_SHOW)
	WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
	GUICtrlSetState($Play, $GUI_ENABLE)
	GUICtrlSetData($RecordAvi, "0 sec(s)")
	GUICtrlSetData($AviSize, "~0 Mo")
	GUISetState(@SW_SHOW, $win)
	
	Global $Capture = False
	TrayTip("AVICapture", "Capture stopped !", 1, 1)
	Sleep(250) ;end capture loop
	If $what = 'avi' Then
		If $comp = True Then
			If $AVI <> '' Then
				_CloseAvi($AVI)
				_StopAviLibrary()
			EndIf
			_CompressAVI()
		Else
			If $AVI <> '' Then
				_CloseAvi($AVI)
				_StopAviLibrary()
			EndIf
			FileMove(@ScriptDir & "\temp.avi", $OutAvi & "\OutCapture.avi")
			FileSetAttrib($OutAvi & "\OutCapture.avi", "-H")
		EndIf
	Else
		ShellExecute($Outframe)
		TrayTip('', '', 0)
	EndIf
EndFunc   ;==>_Stop
#EndRegion Script func
;---------


#Region Compression
Func _CompressAVI()
	TrayTip("AVICapture", "Compressing avi...", 60, 1)
	FileDelete(@ScriptDir & '\OutCapture.avi')
	_RunDOS('ffmpeg -i temp.avi -b 512k -vcodec msmpeg4v2 OutCapture.avi')
	TrayTip("AVICapture", "Compression finished !", 1, 1)
	FileDelete(@ScriptDir & '\temp.avi')
EndFunc   ;==>_CompressAVI

Func _OutAvi()
	$out = FileSelectFolder("Browse Output for avi...", '', 6, @ScriptDir)
	
	If Not @error Then
		GUICtrlSetData($EditAvi, $out)
	EndIf
EndFunc   ;==>_OutAvi

Func _OutFrame()
	$out = FileSelectFolder("Browse Output for frame..." & @CRLF & "Note : select empty folder", '', 6, @ScriptDir)
	
	If Not @error Then
		GUICtrlSetData($Editframe, $out)
	EndIf
EndFunc   ;==>_OutFrame
#EndRegion Compression
;---------------------


#Region include
; Author(s):	Jeremy Landes
Func _RunDOS($sCommand)
	Local $nResult = RunWait(@ComSpec & ' /C ' & $sCommand, '', @SW_HIDE)
	Return SetError(@error, @extended, $nResult)
EndFunc   ;==>_RunDOS

; Author(s):	Unkown
Func _WM_SYSCOMMAND($hwnd, $msg, $wParam, $lParam)
	$wParam = Number($wParam)
	If $wParam = $SC_CONTEXTHELP Then
		GUICtrlSendToDummy($Dummy, $wParam)
		Return ""
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_SYSCOMMAND

Func _CheckRun($sUnicName, $run = 1)
	If $run = 1 Then
		Local Const $MUTEX_ALL_ACCESS = 0x1F0001
		Local $aRet = DllCall("kernel32.dll", "hwnd", "OpenMutex", _
				"int", $MUTEX_ALL_ACCESS, _
				"int", False, _
				"str", $sUnicName)
		Return $aRet[0]
	ElseIf $run = 0 Then
		DllCall("kernel32.dll", "hwnd", "CreateMutex", _
				"int", 0, _
				"int", False, _
				"str", $sUnicName)
	EndIf
EndFunc   ;==>_CheckRun
#EndRegion include;### Tidy Error -> func is never closed in your script.;### Tidy Error -> func is never closed in your script.