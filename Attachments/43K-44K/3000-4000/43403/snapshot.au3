;coded by Dolik



#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=snapshot.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#Include <ScreenCapture.au3>
#Include <Misc.au3>
#include <GDIPlus.au3>

Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 3)

;~ ; Create tray menu
;~ TrayCreateItem("Exit")

;~ TrayItemSetOnEvent(TrayCreateItem("Inverzní uložení"), "On_Inverzni")
;~ TrayCreateItem("")
TrayItemSetOnEvent(TrayCreateItem("Exit"), "On_Exit")



Global $iX1, $iY1, $iX2, $iY2, $aPos, $sMsg, $picture_name, $picture_extension, $picture_path, $picture_counter
Global $script = True
Global $picture_name = "File0001"
Global $picture_extension = "jpg"



; Get total monitors resolution
$FW = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 78)[0]
$FH = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 79)[0]


TraySetState(1)
TraySetToolTip("SnapShot - Fast screen to picture saver")
; Tray context menu only opened by right click
TraySetClick(16)

TraySetOnEvent(-8, "SnapShot")
HotKeySet("^q" , "SnapShot")


While 1
Sleep(500)
WEnd



Func On_Exit()
    Exit
EndFunc

Func SnapShot()

	Mark_Rect()
	File_Counter()
;~ 	_ScreenCapture_Capture($picture_path, $iX1, $iY1, $iX2, $iY2, False)


_Invert()
;~ _GDIPlus_ImageSaveToFile ( $hImage, $picture_path )

Sleep(2000)


EndFunc


Func File_Counter()


		While FileExists(@scriptdir & "\" & $picture_name & "." & $picture_extension) = 1
			$picture_counter = StringTrimLeft($picture_name,4)
			$picture_counter = Number($picture_counter)

            $picture_counter = $picture_counter + 1
			  While StringLen( $picture_counter)<4
				$picture_counter = "0" & $picture_counter
		      WEnd
			$picture_name = "File" & $picture_counter
			ConsoleWrite(@crlf & $picture_counter)
		WEnd

$picture_path = @scriptdir & "\" & $picture_name & "." & $picture_extension

EndFunc


Func Mark_Rect()

    Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp
    Local $UserDLL = DllOpen("user32.dll")

    ; Create transparent GUI with Cross cursor
    $hCross_GUI = GUICreate("Test", $FW, $FH, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)

   WinSetTrans($hCross_GUI, "", 1)
    GUISetState(@SW_SHOW, $hCross_GUI)
    GUISetCursor(3, 1, $hCross_GUI)

    Global $hRectangle_GUI = GUICreate("", $FW, $FH, 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
    GUISetBkColor(0x000000,$hRectangle_GUI)

    ; Wait until mouse button pressed
    While Not _IsPressed("01", $UserDLL)
        Sleep(10)
    WEnd

    ; Get first mouse position
    $aMouse_Pos = MouseGetPos()
    $iX1 = $aMouse_Pos[0]
    $iY1 = $aMouse_Pos[1]

    ; Draw rectangle while mouse button pressed
    While _IsPressed("01", $UserDLL)

        $aMouse_Pos = MouseGetPos()

        $hMaster_Mask = _WinAPI_CreateRectRgn(0, 0, 0, 0)
        $hMask = _WinAPI_CreateRectRgn($iX1,  $aMouse_Pos[1], $aMouse_Pos[0],  $aMouse_Pos[1] + 1) ; Bottom of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        $hMask = _WinAPI_CreateRectRgn($iX1, $iY1, $iX1 + 1, $aMouse_Pos[1]) ; Left of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        $hMask = _WinAPI_CreateRectRgn($iX1 + 1, $iY1 + 1, $aMouse_Pos[0], $iY1) ; Top of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        $hMask = _WinAPI_CreateRectRgn($aMouse_Pos[0], $iY1, $aMouse_Pos[0] + 1,  $aMouse_Pos[1]) ; Right of rectangle
        _WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
        _WinAPI_DeleteObject($hMask)
        ; Set overall region
        _WinAPI_SetWindowRgn($hRectangle_GUI, $hMaster_Mask)

		_WinAPI_DeleteObject($hMaster_Mask)

        If WinGetState($hRectangle_GUI) < 15 Then GUISetState()
		GUISetBkColor(0x000000,$hRectangle_GUI)
        Sleep(10)
		GUISetBkColor(0xFFFFFF,$hRectangle_GUI)
    WEnd

    ; Get second mouse position
    $iX2 = $aMouse_Pos[0]
    $iY2 = $aMouse_Pos[1]

    ; Set in correct order if required
    If $iX2 < $iX1 Then
        $iTemp = $iX1
        $iX1 = $iX2
        $iX2 = $iTemp
    EndIf
    If $iY2 < $iY1 Then
        $iTemp = $iY1
        $iY1 = $iY2
        $iY2 = $iTemp
    EndIf

    GUIDelete($hRectangle_GUI)
    GUIDelete($hCross_GUI)
    DllClose($UserDLL)

EndFunc   ;==>Mark_Rect

Func _Invert()
    _GDIPlus_Startup() ;initialize GDI+

	Local $hHBmp = _ScreenCapture_Capture("", $iX1, $iY1, $iX2, $iY2) ;create a GDI bitmap by capturing an area on desktop
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBmp) ;convert GDI to GDI+ bitmap

    Local $hIA = _GDIPlus_ImageAttributesCreate() ;create an ImageAttribute object

    Local $tColorMatrix = _GDIPlus_ColorMatrixCreateNegative() ;create negative color matrix


    _GDIPlus_ImageAttributesSetColorMatrix($hIA, 0, True, $tColorMatrix) ;set negative color matrix



   _WinAPI_DeleteObject($hHBmp) ;release GDI bitmap resource because not needed anymore

    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)

    _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hBitmap, 0, 0, $iX2-$iX1, $iY2-$iY1,0, 0,$iX2-$iX1, $iY2-$iY1, $hIA) ;draw the bitmap while applying the color adjustment

    consolewrite(@crlf & "GDI Save: " & _GDIPlus_ImageSaveToFile($hBitmap,"testa1.jpg"))
	consolewrite(@crlf & "Error: " & @error)

    ;cleanup GDI+ resources
    _GDIPlus_ImageAttributesDispose($hIA)
    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_Shutdown()
EndFunc   ;==>Example


