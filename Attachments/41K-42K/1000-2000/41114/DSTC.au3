;~ #RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ file check

dim $file[12] = ["gamestart.png","gamestart2.png","Gameoption.png","Gameoption2.png","UpdateClient.PNG","UpdateClient2.PNG","EXIT.PNG","EXIT2.PNG","Nathan_Whitehead_-_Infiltrate.mp3","Main.png","Logo.PNG"]
dim $url = "                                         "

DirCreate("skins")

ProgressOn("file downloading","wait plis...")
For $down = 0 to  UBound($file)-1


	if not FileExists(@ScriptDir&"\skins\"&$file[$down]) Then

		$Download = inetget($url&$file[$down], @ScriptDir&"\skins\"&$file[$down],1,1)
		$SizeLink = InetGetSize($url&$file[$down],0)

		Do
			$Dow = InetGetInfo($Download, 0)
			$PerCento = Round($Dow*100/$SizeLink)
			ProgressSet( $PerCento, $PerCento & "%","-> "&$file[$down])
			Until InetGetInfo($Download, 2) = True


	EndIf
	ProgressSet(100 , "End", "well!")

Next
ProgressOff()

#include "WinMovButton.au3"
#include <GDIPlus.au3>
#include <GuiConstantsex.au3>
#include <WindowsConstants.au3>

Dim $Image_OneButton = @ScriptDir&"\skins\gamestart.png"
Dim $Image_TwoButton = @ScriptDir&"\skins\gamestart2.png"

Dim $Image_OneButton2 = @ScriptDir&"\skins\Gameoption.png"
Dim $Image_TwoButton2 = @ScriptDir&"\skins\Gameoption2.png"

Dim $Image_OneButton3 = @ScriptDir&"\skins\UpdateClient.png"
Dim $Image_TwoButton3 = @ScriptDir&"\skins\UpdateClient2.png"

Dim $Image_OneButton4 = @ScriptDir&"\skins\EXIT.png"
Dim $Image_TwoButton4 = @ScriptDir&"\skins\EXIT2.png"


_GDIPlus_Startup()


$MainLogo = GUICreate("DRAGON SLAYER - THE CHALENG",400,185,-1,-1,$WS_POPUP) ;Create Gui
$ShowLogo = _GuiCtrlCreatePNG(@ScriptDir&"\skins\logo.png",0 , 0, $MainLogo)

Sleep(4000)
SoundPlay(@ScriptDir&"\skins\Nathan_Whitehead_-_Infiltrate.mp3")
GUIDelete($MainLogo)
Sleep(1500)

$hWNDMain = GUICreate("DRAGON SLAYER - THE CHALENG",985,648,-1,-1,$WS_POPUP) ;Create Gui
GUISetState()
WinSettrans($hWNDMain,"",0)

$Button1 = _GuiCtrlCreatePNG(@ScriptDir&"\skins\main.png",0 , 0, $hWNDMain)

$Button = _GuiCtrlCreateButton($Image_OneButton,$Image_TwoButton,150,150,300,100, $Button1[0])
$Button2 = _GuiCtrlCreateButton($Image_OneButton2,$Image_TwoButton2,150,250,300,100, $Button1[0])
$Button3 = _GuiCtrlCreateButton($Image_OneButton3,$Image_TwoButton3,150,350,300,100, $Button1[0])
$Button4 = _GuiCtrlCreateButton($Image_OneButton4,$Image_TwoButton4,500,425,200,35, $Button1[0])

Dim $GO = False
while 1
_BMove($hWNDMain)
    Switch GUIGetMsg()
		case $Button
;~ 			Run(@ScriptDir&"\DSTA.exe")
			Exit
		case $Button2
;~ 			Run(@ScriptDir&"\config.exe")
		case $Button3
;~ 			Run(@ScriptDir&"\update.exe")
			exit
		case $Button4
			_GDIPlus_Shutdown()
            exit
        case -3 ; $GUI_EVENT_CLOSE
			   _GDIPlus_Shutdown()
            exit
	EndSwitch
WEnd



Func _SetGraphicToControl($hControl,$sImage)
    Local $hImage

    If NOT FileExists($sImage) then Return 0
    $hImage = _GDIPlus_ImageLoadFromFile($sImage)
    SetBitmap($hControl,$hImage)
    _GDIPlus_ImageDispose($hImage)

    Return $sImage

EndFunc

Func _GuiCtrlCreatePNG($sImage,$iPosX, $iPosY, $hMainGUI)
    Local $hImage, $iw,$iH, $ret[3],$retto

    $hImage = _GDIPlus_ImageLoadFromFile($sImage)
    $iW = _GDIPlus_ImageGetWidth($hImage)
    $iH = _GDIPlus_ImageGetHeight($hImage)
	ConsoleWrite($iPosX)
    $Ret[0] = GUICreate("", $iW-60,$iH-60, $iPosX, $iPosY,$WS_POPUP,BitOR($WS_EX_LAYERED,$WS_EX_MDICHILD),$hMainGUI)
    $Ret[1] = GUICtrlCreateLabel("",0,0,$iW,$iH)
    $Ret[2] = SetBitmap($Ret[0],$hImage)
    GUISetState(@SW_SHOW,$Ret[0])
    _GDIPlus_ImageDispose($hImage)

    Return $Ret

EndFunc

Func SetBitmap($hGUI, $hImage, $iOpacity = 255)
    Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", 1)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)

Return $hGUI

EndFunc