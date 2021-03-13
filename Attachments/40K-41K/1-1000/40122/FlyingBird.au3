#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=flying_bird.ico
#AutoIt3Wrapper_Res_Description=Flying Birds
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=trancexx & GreenCan
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;.......script written by trancexx (trancexx at yahoo dot com)
; small changes by GreenCan.....
; bug fixed by mesale0077

#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include "GIFAnimation.au3"

Opt("GUICloseOnESC", 1); ESC to exit
Opt("MustDeclareVars", 1)
Opt("TrayMenuMode", 3)
TraySetToolTip("Flying Birds")
Global $iExit = TrayCreateItem("Exit")
TraySetState()
TrayTip("Exit", "Exit via tray menu", 5, 1)
Global $sTempFolder = @TempDir & "\GIFS"
DirCreate($sTempFolder)
Global $Images[9] = [ _
	"eagle2.gif", _
	"eagle1.gif", _
	"eagle2.gif", _
	"swan-flying.gif", _
	"swan-flying1.gif", _
	"goose_flying.gif",  _
	"gooses_flying.gif", _
	"flamingo.gif", _
	"Crow_Right.gif" _
	]
For $i = 0 to UBound($Images) -1
	If Not FileExists($sTempFolder & "\" & $Images[$i]) Then
	    TrayTip("Download " & $Images[$i], "Please wait...", 0)
	    InetGet("http://users.telenet.be/GreenCan/AutoIt/Images/" & $Images[$i], $sTempFolder & "\" & $Images[$i])
	    TrayTip("", "", 0)
	EndIf
	If Not FileExists($sTempFolder & "\" & $Images[$i]) Then MsgBox(262192, "Download",  $Images[$i] & " Download failed!")
Next

Global $SM_VIRTUALWIDTH = 78
Global $VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
$VirtualDesktopWidth = $VirtualDesktopWidth[0]

Global $sFile = $sTempFolder & "\" & $Images[0]
; Get dimension of the GIF
Global $aGIFDimension = _GIF_GetDimension($sFile)
; Make GUI
Global $hGui = GUICreate("GIF Animation", $aGIFDimension[0], $aGIFDimension[1], -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))

; GIF job
Global $hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
GUICtrlSetTip(-1, "ESC to exit")

; Make GUI transparent
GUISetBkColor(345) ; some random color
_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
_WinAPI_SetParent($hGui, 0)

; Show it
GUISetState()

Global $fh = -50, $fv = 0, $iHoldFL = 0, $bDown = 1, $iImage = 0, $ilevel = Random(50,150,1), $ilevelIncrement
If $ilevel > 75 Then
	$ilevelIncrement = 6
Else
	$ilevelIncrement = 3
EndIf
; Loop till end
While 1
    If TrayGetMsg() = $iExit Then Exit

	$fh += $ilevelIncrement

	If $iHoldFL < 50 Then
		$iHoldFL += 1
		sleep(1)
	Else
		If $bDown Then
			$fv += $ilevelIncrement/5 ;0.2
			sleep(1)
		Else
			$fv -= $ilevelIncrement/5 ;0.2
			sleep(2)
		EndIf
	EndIf
	If $fv <0 Or $fv > $ilevel Then
		If $bDown Then
			$bDown = False
			$fv = $ilevel
			$iHoldFL = 0
		Else
			$bDown = True
			$fv = 0
			$iHoldFL = 0
		EndIf
	EndIf

	If $fh > $VirtualDesktopWidth+50 Then
		$fh = -500
		$iImage += 1
		If $iImage > UBound($Images)-1 Then $iImage = 0
		$sFile = $sTempFolder & "\" & $Images[$iImage]

		; delete current gif
		_GIF_DeleteGIF($hGIF)
		; delete GUI
		GUIDelete($hGui)
		; Get dimension of the GIF
		$aGIFDimension = _GIF_GetDimension($sFile)

		; Make NEW GUI
		$hGui = GUICreate("GIF Animation", $aGIFDimension[0], $aGIFDimension[1], -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))

		; New GIF
		$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)
		GUICtrlSetTip(-1, "ESC to exit")

		; Make GUI transparent
		GUISetBkColor(345) ; some random color
		_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
		_WinAPI_SetParent($hGui, 0)

		; Show it
		GUISetState()
		$ilevel = Random(50,150,1)
		If $ilevel > 75 Then
			$ilevelIncrement = 6
		Else
			$ilevelIncrement = 3
		EndIf
	EndIf
	WinMove($hGUI,"", $fh, $fv)
WEnd

Func _Exit()
	Exit
EndFunc ;==>_Exit