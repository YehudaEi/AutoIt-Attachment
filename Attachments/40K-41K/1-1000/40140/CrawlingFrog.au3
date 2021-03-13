#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=frog3.ico
#AutoIt3Wrapper_Res_Description=Crwaling Frog
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=GreenCan
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;.......original script written by trancexx (trancexx at yahoo dot com)
; small changes by GreenCan.....

#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include "GIFAnimation.au3"

Opt("GUICloseOnESC", 1); ESC to exit
Opt("MustDeclareVars", 1)
Opt("TrayMenuMode", 3)
TraySetToolTip("Crawling Frog")
Global $iExit = TrayCreateItem("Exit")
TraySetState()
TrayTip("Exit", "Exit via tray menu", 5, 1)
Global $sTempFolder = @TempDir & "\GIFS"
DirCreate($sTempFolder)
Global $Images[2] = [ _
	"Frog_crawling_L2R.gif", _
	"Frog_crawling_R2L.gif" _
	]
For $i = 0 to UBound($Images) -1
;~ 	ConsoleWrite($sTempFolder & @CR)
;~ 	Exit
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

; Make GUI transparent
GUISetBkColor(345) ; some random color
_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
_WinAPI_SetParent($hGui, 0)

; Show it
GUISetState()

Global $fh = -500, $iHoldFL = 0, $bDown = 1, $iImage = 0, $fv = Random(-200,@DesktopHeight - 100,1)
; Loop till end
While 1
    If TrayGetMsg() = $iExit Then Exit
;~ 	If GUIGetMsg() = - 3 Then Exit
	If $iImage = 0 Then
		$fh += 1.5
	Else
		$fh -= 1.5
	EndIf

	$fv += 0.2

	If ($iImage = 0 And $fh > $VirtualDesktopWidth+50 Or $fv >@DesktopHeight+50) Or ($iImage = 1 And $fh < -500 Or $fv >@DesktopHeight+50) Then
		$iImage += 1
		If $iImage > UBound($Images)-1 Then $iImage = 0

		If $iImage = 0 Then
			$fh = - 500
		Else
			$fh = $VirtualDesktopWidth + 500
		EndIf
		$fv = Random(-200,@DesktopHeight - 100,1)

		$sFile = $sTempFolder & "\" & $Images[$iImage]
		; delete current gif
		_GIF_DeleteGIF($hGIF)
		; Get dimension of the GIF
		$aGIFDimension = _GIF_GetDimension($sFile)
		; New GIF
		$hGIF = _GUICtrlCreateGIF($sFile, "", 0, 0)

		; Make GUI transparent
		GUISetBkColor(345) ; some random color
		_WinAPI_SetLayeredWindowAttributes($hGui, 345, 255) ; making the GUI transparent
		_WinAPI_SetParent($hGui, 0)

		; Show it
		GUISetState()

	EndIf
	WinMove($hGUI,"", $fh, $fv)
WEnd

Func _Exit()
	Exit
EndFunc ;==>_Exit