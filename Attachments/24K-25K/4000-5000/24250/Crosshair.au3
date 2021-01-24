#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ch.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Description=d3mon Corporation
#AutoIt3Wrapper_Res_Fileversion=1.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=d3mon Corporation. All rights reserved
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;===============================================================================
; Script Name: Crosshair
; Author(s): d3mon Corporation
; Copyright : All functions in this script written by me (without other autor)
; must be used or copied with my name on top
;===============================================================================

#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <IsPressed_UDF.au3>
Opt("GuiOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)

$CHMENU = TrayCreateMenu("CH >>")
TrayCreateItem("Global", $CHMENU)
TrayItemSetOnEvent(-1, "_Global")
$ON = TrayCreateItem("ON", $CHMENU)
TrayItemSetOnEvent(-1, "_ON")
$OFF = TrayCreateItem("OFF", $CHMENU)
TrayItemSetOnEvent(-1, "_OFF")
TrayItemSetState($OFF, $TRAY_CHECKED)
TrayCreateItem('')
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Exit")
TraySetToolTip("Crosshair <d3montools>" & @CRLF & "Initializing...")

Local $L, $T, $W, $H, $L2, $T2, $W2, $H2, $BK, $BK2
Global $CUR = True
Global $CH = False

#Region Global --------------------------------------------------------------------------
$win = GUICreate("Crosshair <d3montools>", 310, 130, -1, -1, -1, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
GUISetOnEvent($GUI_EVENT_CLOSE, "_HIDEWIN")

GUICtrlCreateGroup("Transparency", 5, 80, 165, 45)
$TRANS = GUICtrlCreateSlider(10, 94, 125, 25)
GUICtrlSetLimit(-1, 255, 0)
$TE = GUICtrlCreateEdit("", 135, 97, 25, 17, $ES_READONLY)

GUICtrlCreateGroup("Panel", 175, 5, 130, 120)
GUICtrlCreateButton("Go Auto !", 185, 20, 110, 20)
GUICtrlSetOnEvent(-1, "_Auto")

GUICtrlCreateLabel("Color I ", 185, 50)
$CI = GUICtrlCreateEdit("", 225, 48, 70, 17, $ES_WANTRETURN)
GUICtrlCreateLabel("Color II", 185, 72)
$CII = GUICtrlCreateEdit("", 225, 70, 70, 17, $ES_WANTRETURN)

GUICtrlCreateButton("SAVE", 185, 100, 110, 17)
GUICtrlSetOnEvent(-1, "_SAVE")


GUICtrlCreateTab(5, 5, 160, 75)
GUICtrlCreateTabItem("CH 1")
GUICtrlCreateLabel("Left :", 10, 37)
$LEFT = GUICtrlCreateEdit("", 40, 35, 30, 17, $ES_WANTRETURN + $ES_NUMBER)
GUICtrlCreateLabel("Top :", 10, 57)
$TOP = GUICtrlCreateEdit("", 40, 55, 30, 17, $ES_WANTRETURN + $ES_NUMBER)
GUICtrlCreateLabel("Width :", 90, 37)
$WIDTH = GUICtrlCreateEdit("", 130, 35, 30, 17, $ES_WANTRETURN + $ES_NUMBER)
GUICtrlCreateLabel("Height :", 90, 57)
$HEIGHT = GUICtrlCreateEdit("", 130, 55, 30, 17, $ES_WANTRETURN + $ES_NUMBER)

GUICtrlCreateTabItem("CH 2")
GUICtrlCreateLabel("Left :", 10, 37)
$LEFT2 = GUICtrlCreateEdit("", 40, 35, 30, 17, $ES_WANTRETURN + $ES_NUMBER)
GUICtrlCreateLabel("Top :", 10, 57)
$TOP2 = GUICtrlCreateEdit("", 40, 55, 30, 17, $ES_WANTRETURN + $ES_NUMBER)
GUICtrlCreateLabel("Width :", 90, 37)
$WIDTH2 = GUICtrlCreateEdit("", 130, 35, 30, 17, $ES_WANTRETURN + $ES_NUMBER)
GUICtrlCreateLabel("Height :", 90, 57)
$HEIGHT2 = GUICtrlCreateEdit("", 130, 55, 30, 17, $ES_WANTRETURN + $ES_NUMBER)
GUISetState(@SW_HIDE, $win)

Func _Global()
	GUISetState(@SW_SHOW, $win)
	GUICtrlSetData($LEFT, FileReadLine(@TempDir & "\CH.txt", 1))
	GUICtrlSetData($TOP, FileReadLine(@TempDir & "\CH.txt", 2))
	GUICtrlSetData($WIDTH, FileReadLine(@TempDir & "\CH.txt", 3))
	GUICtrlSetData($HEIGHT, FileReadLine(@TempDir & "\CH.txt", 4))
	GUICtrlSetData($CI, FileReadLine(@TempDir & "\CH.txt", 5))
	GUICtrlSetData($TE, FileReadLine(@TempDir & "\CH.txt", 6))
	GUICtrlSetData($TRANS, FileReadLine(@TempDir & "\CH.txt", 6))

	GUICtrlSetData($LEFT2, FileReadLine(@TempDir & "\CH2.txt", 1))
	GUICtrlSetData($TOP2, FileReadLine(@TempDir & "\CH2.txt", 2))
	GUICtrlSetData($WIDTH2, FileReadLine(@TempDir & "\CH2.txt", 3))
	GUICtrlSetData($HEIGHT2, FileReadLine(@TempDir & "\CH2.txt", 4))
	GUICtrlSetData($CII, FileReadLine(@TempDir & "\CH2.txt", 5))
EndFunc   ;==>_Global

If Not FileExists(@TempDir & "\CH.txt") Then
	_Global()
EndIf

Func _HIDEWIN()
	GUISetState(@SW_HIDE, $win)
EndFunc   ;==>_HIDEWIN

Func _SAVE()
	FileDelete(@TempDir & "\CH.txt")
	FileDelete(@TempDir & "\CH2.txt")
	FileWrite(@TempDir & "\CH.txt", GUICtrlRead($LEFT))
	FileWrite(@TempDir & "\CH.txt", @CRLF & GUICtrlRead($TOP))
	FileWrite(@TempDir & "\CH.txt", @CRLF & GUICtrlRead($WIDTH))
	FileWrite(@TempDir & "\CH.txt", @CRLF & GUICtrlRead($HEIGHT))
	FileWrite(@TempDir & "\CH.txt", @CRLF & GUICtrlRead($CI))
	FileWrite(@TempDir & "\CH.txt", @CRLF & GUICtrlRead($TE))

	FileWrite(@TempDir & "\CH2.txt", GUICtrlRead($LEFT2))
	FileWrite(@TempDir & "\CH2.txt", @CRLF & GUICtrlRead($TOP2))
	FileWrite(@TempDir & "\CH2.txt", @CRLF & GUICtrlRead($WIDTH2))
	FileWrite(@TempDir & "\CH2.txt", @CRLF & GUICtrlRead($HEIGHT2))
	FileWrite(@TempDir & "\CH2.txt", @CRLF & GUICtrlRead($CII))
EndFunc   ;==>_SAVE

Func _Auto()
	$AutoI = (@DesktopWidth / 2) - 17.5
	$AutoII = (@DesktopHeight / 2) - 17.5
	GUICtrlSetData($LEFT, StringLeft($AutoI, 3))
	GUICtrlSetData($TOP, StringLeft($AutoII, 3))
	GUICtrlSetData($WIDTH, 35)
	GUICtrlSetData($HEIGHT, 1)
	GUICtrlSetData($LEFT2, StringLeft($AutoI, 3))
	GUICtrlSetData($TOP2, StringLeft($AutoII, 3))
	GUICtrlSetData($WIDTH2, 1)
	GUICtrlSetData($HEIGHT2, 35)
	GUICtrlSetData($CI, "0xFF0000")
	GUICtrlSetData($CII, "0xFF0000")
	GUICtrlSetData($TRANS, 255)
EndFunc   ;==>_Auto
#EndRegion Global --------------------------------------------------------------------------

#Region CROSSHAIR ACTIVE --------------------------------------------------------------------------
Func _ON()
	TrayItemSetState($ON, $TRAY_CHECKED)
	TrayItemSetState($OFF, $TRAY_UNCHECKED)
	_ACTIVATE()
EndFunc   ;==>_ON

Func _ACTIVATE()
	Global $L = FileReadLine(@TempDir & "\CH.txt", 1)
	Global $T = FileReadLine(@TempDir & "\CH.txt", 2)
	Global $W = FileReadLine(@TempDir & "\CH.txt", 3)
	Global $H = FileReadLine(@TempDir & "\CH.txt", 4)
	Global $BK = FileReadLine(@TempDir & "\CH.txt", 5)

	Global $L2 = FileReadLine(@TempDir & "\CH2.txt", 1)
	Global $T2 = FileReadLine(@TempDir & "\CH2.txt", 2)
	Global $W2 = FileReadLine(@TempDir & "\CH2.txt", 3)
	Global $H2 = FileReadLine(@TempDir & "\CH2.txt", 4)
	Global $BK2 = FileReadLine(@TempDir & "\CH2.txt", 5)

	Global $CH = True
EndFunc   ;==>_ACTIVATE
#EndRegion CROSSHAIR ACTIVE --------------------------------------------------------------------------

#Region CROSSHAIR UNACTIVE ------------------------------------------------------------------------
Func _OFF()
	TrayItemSetState($ON, $TRAY_UNCHECKED)
	TrayItemSetState($OFF, $TRAY_CHECKED)
	_UNACTIVATE()
EndFunc   ;==>_OFF

Func _UNACTIVATE()
	Global $CUR = True
	Global $CH = False
	_WinAPI_ShowCursor(1)
EndFunc   ;==>_UNACTIVATE
#EndRegion CROSSHAIR UNACTIVE ------------------------------------------------------------------------

#Region While -------------------------------------------------------------------------------------
While 1
	Sleep(10)
	TraySetToolTip("Crosshair <d3montools>" & @CRLF & "CH : " & $CH & @CRLF & "CUR : " & $CUR)

	If $CH = True Then
		_CH($L, $T, $W, $H)
		_CH2($L2, $T2, $W2, $H2)
	EndIf

	If _IsAndKeyPressed("12|7B") Then
		If $CUR = True Then
			Global $CUR = False
			_WinAPI_ShowCursor(0)
		ElseIf $CUR = False Then
			Global $CUR = True
			_WinAPI_ShowCursor(1)
		EndIf
	EndIf

	If _IsAndKeyPressed("12|74") Then
		_ON()
	ElseIf _IsAndKeyPressed("12|75") Then
		_OFF()
	EndIf

	If WinActive($win) Then
		Sleep(250);----------------
		GUICtrlSetData($TE, GUICtrlRead($TRANS))
		GUICtrlSetColor($CI, GUICtrlRead($CI))
		GUICtrlSetColor($CII, GUICtrlRead($CII))
	EndIf
WEnd
#EndRegion While -------------------------------------------------------------------------------------


#Region Func --------------------------------------------------------------------------------------
Func _CH($L, $T, $W, $H)
	For $pixely = 0 To $H
		For $Pixelx = 0 To $W
			$dc = DllCall("user32.dll", "int", "GetDC", "hwnd", "")
			_drawpixel($dc, ($L + $Pixelx) - ($W / 2), $T - ($H / 2), $BK)
			_drawpixel($dc, ($L + $Pixelx) - ($W / 2), ($T + $pixely) - ($H / 2), $BK)
			DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "int", $dc[0])
		Next
	Next
EndFunc   ;==>_CH

Func _CH2($L2, $T2, $W2, $H2)
	For $pixely2 = 0 To $H2
		For $Pixelx2 = 0 To $W2
			$dc = DllCall("user32.dll", "int", "GetDC", "hwnd", "")
			_drawpixel($dc, ($L2 + $Pixelx2) - ($W2 / 2), $T2 - ($H2 / 2), $BK)
			_drawpixel($dc, ($L2 + $Pixelx2) - ($W2 / 2), ($T2 + $pixely2) - ($H2 / 2), $BK)
			DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "int", $dc[0])
		Next
	Next
EndFunc   ;==>_CH2

Func _drawpixel($dc, $L, $T, $C)
	DllCall("gdi32.dll", "long", "SetPixel", "long", $dc[0], "long", $L, "long", $T, "long", $C)
EndFunc   ;==>_drawpixel

Func _WinAPI_ShowCursor($fShow)
	Local $aResult

	$aResult = DllCall("User32.dll", "int", "ShowCursor", "int", $fShow)
	If @error Then Return SetError(@error, 0, 0)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_ShowCursor

Func _Exit()
	Exit
EndFunc   ;==>_Exit
#EndRegion Func --------------------------------------------------------------------------------------