;================================================================================
;#  Title .........: AVICapture.au3												#
;#  Description ...: Capture screen as .avi file								#
;#  Date ..........: 30.12.08													#
;#  Version .......: 1.3.5														#
;#  Author ........: FireFox													#
;#  Special thanks.: Monoceres for AVIWritter source code						#
;#  Copyright......: d3mon Corporation. All rights reserved						#
;#      (only functions from other authors are not in my copyright)				#
;================================================================================

#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ScreenCapture.au3>
#include <AVIWriter.au3>
;-----------------------


#Region Variables
Local $AVI, $Ext, $timer, $OutAvi, $frame
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
TraySetToolTip("Avi Capture v1.2")
#EndRegion Tray
;--------------


#Region GUI
Opt("GuiOnEventMode", 1)
$win = GUICreate("AVICapture  v1.3.5", 305, 180, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU), $WS_EX_CONTEXTHELP)
GUIRegisterMsg($WM_SYSCOMMAND, "_WM_SYSCOMMAND")
GUISetOnEvent($GUI_EVENT_CLOSE, "_HIDE")
$Dummy = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_Help")
GUISetBkColor(0xFFFFFF, $win)

GUICtrlCreateGroup("Capture", 5, 5, 90, 120)
$fullscreen = GUICtrlCreateRadio("full screen", 15, 20)
GUICtrlSetState($fullscreen, $GUI_CHECKED)
$noicon = GUICtrlCreateRadio("window", 15, 40)
$notaskbar = GUICtrlCreateRadio("no taskbar", 15, 60)
$nodesktop = GUICtrlCreateRadio("no desktop", 15, 80)
$region = GUICtrlCreateRadio("region", 15, 100)

GUICtrlCreateGroup("timer", 100, 5, 200, 37)
GUICtrlCreateLabel("Stop video  after :", 110, 20, 95, 15)
$Edittime = GUICtrlCreateEdit("0", 200, 19, 30, 17, $ES_NUMBER)
GUICtrlCreateLabel("sec(s)", 235, 20, 30, 15)

GUICtrlCreateGroup("State", 5, 130, 90, 45)
$Play = GUICtrlCreateButton("Play", 12, 147, 75, 20)
GUICtrlSetOnEvent(-1, "_Start")

GUICtrlCreateGroup("Config", 100, 50, 200, 125)
$ShowCursor = GUICtrlCreateCheckbox("Show Cursor", 110, 65)
$CompressAvi = GUICtrlCreateCheckbox("Compress Avi", 110, 90)

$comboframe = GUICtrlCreateCombo('FRAME', 210, 65, 80, 17, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, '5|10|12|15|24|25|30|50|60|---', 'FRAME')

GUICtrlCreateLabel("Output Avi :", 210, 94)
GUICtrlCreateButton("...", 270, 92, 20, 17)
GUICtrlSetOnEvent(-1, "_OutAvi")
$EditAvi = GUICtrlCreateEdit(@ScriptDir, 110, 115, 180, 17, _
		$ES_READONLY + $ES_AUTOHSCROLL)

GUICtrlCreateLabel("Record :", 110, 138, 45, 15)
$RecordAvi = GUICtrlCreateLabel("0 sec(s)", 155, 138, 50, 15)
GUICtrlCreateLabel("Size :", 110, 156, 45, 15)
$AviSize = GUICtrlCreateLabel("0 Mo", 140, 156, 100, 15)
GUISetState(@SW_SHOW, $win)

$capturewnd = GUICreate("Get Handle", 70, 14, 50, 50, $WS_BORDER + $WS_POPUP, $WS_EX_TOPMOST, $win)
$handle = GUICtrlCreateLabel('', 5, 0, 65, 15)
GUISetState(@SW_HIDE, $capturewnd)
#EndRegion GUI
;-------------


#Region Check
If Not FileExists(@ScriptDir & "\ffmpeg.exe") Then
	MsgBox(48, "AVICapture", "Compression files not found !")
	GUICtrlSetState($CompressAvi, $GUI_DISABLE)
EndIf
#EndRegion Check
;---------------


#Region While
While 1
	Sleep(200)
	If _IsPressed("11") And _IsPressed("70") Then
		_Start()
	ElseIf _IsPressed("11") And _IsPressed("71") Then
		_Stop()
	ElseIf _IsPressed("11") And _IsPressed("72") Then
		_HIDE()
	ElseIf _IsPressed("11") And _IsPressed("73") Then
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
			@CRLF & "• Ctrl + F1 = Play         • Ctrl + F3 = Hide" & @CRLF & "• Ctrl + F2 = Stop   -    • Ctrl + F4 = Show")
EndFunc   ;==>_Help

Func _Start()
	If GUICtrlRead($comboframe) = 'FRAME' Then
		GUICtrlSetData($comboframe, 24, 'FRAME')
	ElseIf GUICtrlRead($comboframe) = '---' Then
		GUICtrlSetData($comboframe, 24, 'FRAME')
	EndIf
	
	Global $frame = GUICtrlRead($comboframe)
	Global $timer = GUICtrlRead($Edittime)
	Global $OutAvi = GUICtrlRead($EditAvi)
	
	If (GUICtrlRead($region) == $GUI_CHECKED) Then
		Global $CUR = True
	EndIf
	
	If (GUICtrlRead($CompressAvi) == $GUI_CHECKED) Then
		Global $comp = True
	EndIf
	
	If (GUICtrlRead($fullscreen) == $GUI_CHECKED) Then
		_Capture('full screen')
	ElseIf (GUICtrlRead($noicon) == $GUI_CHECKED) Then
		_Capture('window')
	ElseIf (GUICtrlRead($notaskbar) == $GUI_CHECKED) Then
		_Capture('no taskbar')
	ElseIf (GUICtrlRead($nodesktop) == $GUI_CHECKED) Then
		_Capture('no desktop')
	ElseIf (GUICtrlRead($region) == $GUI_CHECKED) Then
		_Capture('region')
	EndIf
EndFunc   ;==>_Start


Func _Capture($param = 'full screen')
	GUICtrlSetState($Play, $GUI_DISABLE)
	FileDelete(@ScriptDir & "\temp.avi")
	_StartAviLibrary()

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
		
		_ScreenCapture_Capture(@TempDir & "\frame.bmp", $MH, $MW, $MW1, $MH1, $CUR)
		$AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @TempDir & "\frame.bmp")
		FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
		Global $Capture = True
		$Init = TimerInit()
		$BitmapSize = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			$BitmapSize = $BitmapSize + (54 + 3 * ($MW1 * $MH1))
			GUICtrlSetData($AviSize, "~" & $BitmapSize / 1000000 & " Mo")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf

			If _IsPressed("11") And _IsPressed("70") Then
				_Start()
			ElseIf _IsPressed("11") And _IsPressed("71") Then
				_Stop()
			ElseIf _IsPressed("11") And _IsPressed("72") Then
				GUISetState(@SW_HIDE, $win)
			ElseIf _IsPressed("11") And _IsPressed("73") Then
				GUISetState(@SW_SHOW, $win)
			EndIf
			Sleep(1000 / $frame)
			_ScreenCapture_Capture(@TempDir & "\frame.bmp", $MH, $MW, $MW1, $MH1, $CUR)
			_AddBitmapToAvi($AVI, @TempDir & "\frame.bmp")
		WEnd

	ElseIf $param = 'full screen' Then
		_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
		$AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @TempDir & "\frame.bmp")
		FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
		Global $Capture = True
		$Init = TimerInit()
		$BitmapSize = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			$BitmapSize = $BitmapSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
			GUICtrlSetData($AviSize, "~" & $BitmapSize / 1000000 & " Mo")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf

			If _IsPressed("11") And _IsPressed("70") Then
				_Start()
			ElseIf _IsPressed("11") And _IsPressed("71") Then
				_Stop()
			ElseIf _IsPressed("11") And _IsPressed("72") Then
				GUISetState(@SW_HIDE, $win)
			ElseIf _IsPressed("11") And _IsPressed("73") Then
				GUISetState(@SW_SHOW, $win)
			EndIf
			Sleep(1000 / $frame)
			_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			_AddBitmapToAvi($AVI, @TempDir & "\frame.bmp")
		WEnd

	ElseIf $param = 'no taskbar' Then
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
		_StartAviLibrary()
		_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
		$AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @TempDir & "\frame.bmp")
		FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
		Global $Capture = True
		$Init = TimerInit()
		$BitmapSize = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			$BitmapSize = $BitmapSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
			GUICtrlSetData($AviSize, "~" & $BitmapSize / 1000000 & " Mo")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsPressed("11") And _IsPressed("70") Then
				_Start()
			ElseIf _IsPressed("11") And _IsPressed("71") Then
				_Stop()
			ElseIf _IsPressed("11") And _IsPressed("72") Then
				GUISetState(@SW_HIDE, $win)
			ElseIf _IsPressed("11") And _IsPressed("73") Then
				GUISetState(@SW_SHOW, $win)
			EndIf
			Sleep(1000 / $frame)
			_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			_AddBitmapToAvi($AVI, @TempDir & "\frame.bmp")
		WEnd
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)

	ElseIf $param = 'no icon' Then
		WinSetState("Program Manager", "", @SW_HIDE)
		_StartAviLibrary()
		_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
		$AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @TempDir & "\frame.bmp")
		FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
		Global $Capture = True
		$Init = TimerInit()
		$BitmapSize = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			$BitmapSize = $BitmapSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
			GUICtrlSetData($AviSize, "~" & $BitmapSize / 1000000 & " Mo")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsPressed("11") And _IsPressed("70") Then
				_Start()
			ElseIf _IsPressed("11") And _IsPressed("71") Then
				_Stop()
			ElseIf _IsPressed("11") And _IsPressed("72") Then
				GUISetState(@SW_HIDE, $win)
			ElseIf _IsPressed("11") And _IsPressed("73") Then
				GUISetState(@SW_SHOW, $win)
			EndIf
			Sleep(1000 / $frame)
			_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			_AddBitmapToAvi($AVI, @TempDir & "\frame.bmp")
		WEnd
		WinSetState("Program Manager", "", @SW_SHOW)

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
		_StartAviLibrary()
		_ScreenCapture_CaptureWnd(@TempDir & "\frame.bmp", $wgh, 0, 0, -1, -1, $CUR)
		$AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @TempDir & "\frame.bmp")
		FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
		Global $Capture = True
		$Init = TimerInit()
		$BitmapSize = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			$BitmapSize = $BitmapSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
			GUICtrlSetData($AviSize, "~" & $BitmapSize / 1000000 & " Mo")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsPressed("11") And _IsPressed("70") Then
				_Start()
			ElseIf _IsPressed("11") And _IsPressed("71") Then
				_Stop()
			ElseIf _IsPressed("11") And _IsPressed("72") Then
				GUISetState(@SW_HIDE, $win)
			ElseIf _IsPressed("11") And _IsPressed("73") Then
				GUISetState(@SW_SHOW, $win)
			EndIf
			Sleep(1000 / $frame)
			_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			_AddBitmapToAvi($AVI, @TempDir & "\frame.bmp")
		WEnd
		WinSetState("Program Manager", "", @SW_SHOW)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
	ElseIf $param = 'no desktop' Then
		WinSetState("Program Manager", "", @SW_HIDE)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
		_StartAviLibrary()
		_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
		$AVI = _CreateAvi(@ScriptDir & "\temp.avi", $frame, @TempDir & "\frame.bmp")
		FileSetAttrib(@ScriptDir & "\temp.avi", "+H")
		Global $Capture = True
		$Init = TimerInit()
		$BitmapSize = 0
		
		While $Capture = True
			$timerDiff = StringSplit(StringLeft(TimerDiff($Init) / 1000, 6), ".")
			GUICtrlSetData($RecordAvi, $timerDiff[1] & " sec(s)")
			$BitmapSize = $BitmapSize + (54 + 3 * (@DesktopWidth * @DesktopHeight))
			GUICtrlSetData($AviSize, "~" & $BitmapSize / 1000000 & " Mo")
			If $timer <> 0 Then
				If TimerDiff($Init) >= $timer Then
					Global $Capture = False
				EndIf
			EndIf
			
			If _IsPressed("11") And _IsPressed("70") Then
				_Start()
			ElseIf _IsPressed("11") And _IsPressed("71") Then
				_Stop()
			ElseIf _IsPressed("11") And _IsPressed("72") Then
				GUISetState(@SW_HIDE, $win)
			ElseIf _IsPressed("11") And _IsPressed("73") Then
				GUISetState(@SW_SHOW, $win)
			EndIf
			Sleep(1000 / $frame)
			_ScreenCapture_Capture(@TempDir & "\frame.bmp", 0, 0, @DesktopWidth, @DesktopHeight, $CUR)
			_AddBitmapToAvi($AVI, @TempDir & "\frame.bmp")
		WEnd
		WinSetState("Program Manager", "", @SW_SHOW)
		WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
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
	GUICtrlSetState($Play, $GUI_ENABLE)
	GUICtrlSetData($RecordAvi, "0 sec(s)")
	GUICtrlSetData($AviSize, "0 Mo")
	
	Global $Capture = False
	TrayTip("AVICapture", "Capture stopped !", 1, 1)
	Sleep(250) ;end capture loop
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
EndFunc   ;==>_Stop
#EndRegion Script func
;---------


#Region Compression
Func _CompressAVI()
	TrayTip("AVICapture", "Compressing avi...", 2, 1)
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
#EndRegion Compression
;---------------------


#Region include
; Author(s):	ezzetabi and Jon
Func _IsPressed($sHexKey, $vDLL = 'user32.dll')
	Local $a_R = DllCall($vDLL, "int", "GetAsyncKeyState", "int", '0x' & $sHexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Return 0
EndFunc   ;==>_IsPressed

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
#EndRegion include