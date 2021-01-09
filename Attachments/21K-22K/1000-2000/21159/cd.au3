#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=lcdb.ico
#AutoIt3Wrapper_outfile=cd.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=L|M|TER CD/DVD Burner
#AutoIt3Wrapper_Res_Fileversion=1.0.2.0
#AutoIt3Wrapper_Res_LegalCopyright=© 2008 - L|M|TER
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <GDIPlus.au3>
#Include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#Include <GuiListBox.au3>
#include <Array.au3>
#include <Hover.au3>
#Include <GuiListBox.au3>
#include "IMAPI2.au3"
$cver = "1.0.2"
$already = 0
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("GUIOnEventMode", 1)
TraySetClick(8)
TraySetToolTip("L|M|TER CD/DVD Burner " & $cver)

$CloseBtn0 = @TempDir & "\dvd-close0.bmp"
FileInstall("C:\close0.bmp",$CloseBtn0,1)
$CloseBtn1 = @TempDir & "\dvd-close1.bmp"
FileInstall("C:\close1.bmp",$CloseBtn1,1)
$CloseBtn2 = @TempDir & "\dvd-close2.bmp"
FileInstall("C:\close2.bmp",$CloseBtn2,1)

$pngSrc = @TempDir & "\dvd-background.png"
FileInstall("C:\back.png",$pngSrc,1)

$grey = @TempDir & "\dvd-grey.gif"
FileInstall("C:\grey.gif",$grey,1)

;~ $addimg0 = @TempDir & "\dvd-add0.bmp"
;~ FileInstall("C:\dvd-add0.bmp",$addimg0,1)
;~ $addimg1 = @TempDir & "\dvd-add1.bmp"
;~ FileInstall("C:\dvd-add1.bmp",$addimg1,1)
;~ $addimg2 = @TempDir & "\dvd-add2.bmp"
;~ FileInstall("C:\dvd-add2.bmp",$addimg2,1)
$addfimg0 = @TempDir & "\dvd-addf0.bmp"
FileInstall("C:\dvd-addf0.bmp",$addfimg0,1)
$addfimg1 = @TempDir & "\dvd-addf1.bmp"
FileInstall("C:\dvd-addf1.bmp",$addfimg1,1)
$addfimg2 = @TempDir & "\dvd-addf2.bmp"
FileInstall("C:\dvd-addf2.bmp",$addfimg2,1)
$burnimg0 = @TempDir & "\dvd-burn0.bmp"
FileInstall("C:\dvd-burn0.bmp",$burnimg0,1)
$burnimg1 = @TempDir & "\dvd-burn1.bmp"
FileInstall("C:\dvd-burn1.bmp",$burnimg1,1)
$burnimg2 = @TempDir & "\dvd-burn2.bmp"
FileInstall("C:\dvd-burn2.bmp",$burnimg2,1)

Global Const $AC_SRC_ALPHA = 1
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
Dim $CloseBtn

_GDIPlus_Startup()
$hImage = _GDIPlus_ImageLoadFromFile($pngSrc)
$width = _GDIPlus_ImageGetWidth($hImage)
$height = _GDIPlus_ImageGetHeight($hImage)
Dim $fs,$drive

$Splash = GUICreate("L|M|TER Media Player", $width, $height, -1, -1,$WS_POPUP,BitOR($WS_EX_LAYERED, $DS_MODALFRAME))
SetBitmap($Splash, $hImage, 0)

GUISetState()
WinSetOnTop($Splash, "", 1)

For $i = 0 To 255 Step 8
    SetBitmap($Splash, $hImage, $i)
Next

GUISetState()
WinSetOnTop($Splash, "", 1)

If @OSVersion = "WIN_XP" Then
$controlGui = GUICreate("ControlGUI", $width, $height, 0,-26,$WS_POPUP,BitOR($WS_EX_LAYERED,$WS_EX_MDICHILD),$Splash)
Else
$controlGui = GUICreate("ControlGUI", $width, $height, 0,-20,$WS_POPUP,BitOR($WS_EX_LAYERED,$WS_EX_MDICHILD),$Splash)
EndIf
GUICtrlCreatePic($grey,0,-20,$width,$height+20)
GuiCtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateLabel("L|M|TER CD/DVD Burner " & $cver & " - © 2008 L|M|TER",10,7,300)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0x00FF55)
GUICtrlSetFont(-1, 8, 700, 0, "MS Sans Serif")
$status = GUICtrlCreateLabel("Welcome To L|M|TER CD/DVD Burner © 2008 L|M|TER", 15, 200, 300, 15)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1, 8, 500, 0, "MS Sans Serif")
$list = GUICtrlCreateList("",10,200,780,263)
_GuiCtrlMakeTrans($list,130)
$cm = GUICtrlCreateContextMenu($list)
$rem = GUICtrlCreateMenuItem("Remove item",$cm)
GUICtrlSetOnEvent(-1,"remove")
;~ $addbtn = GUICtrlCreatePic($addimg0,665,180,40,40)
;~ GUICtrlSetTip(-1,"Add file")
;~ GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
;~ GUICtrlSetOnEvent(-1,"add")
$addfbtn = GUICtrlCreatePic($addfimg0,710,180,40,40)
GUICtrlSetTip(-1,"Add folder")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
GUICtrlSetOnEvent(-1,"addf")
$burnbtn = GUICtrlCreatePic($burnimg0,750,180,40,40)
GUICtrlSetTip(-1,"Burn disc")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
GUICtrlSetOnEvent(-1,"burn")
$status0 = GUICtrlCreateLabel("Current action :       Idle ...", 550, 50, 250, 15)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1, 8, 500, 0, "MS Sans Serif")
$status1 = GUICtrlCreateLabel("Remaining time :     00:00:00", 550, 70, 250, 15)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1, 8, 500, 0, "MS Sans Serif")
$status2 = GUICtrlCreateLabel("Elapsed time :         00:00:00", 550, 90, 250, 15)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1, 8, 500, 0, "MS Sans Serif")
$status3 = GUICtrlCreateLabel("Total time :              00:00:00", 550, 110, 250, 15)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1, 8, 500, 0, "MS Sans Serif")
$status4 = GUICtrlCreateLabel("Space used :          0 MB", 550, 130, 250, 15)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1, 8, 500, 0, "MS Sans Serif")
$CloseBtn = GUICtrlCreatePic($CloseBtn0,$width - 55,0,42,18)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
GUICtrlSetOnEvent(-1,"close")
$texit = TrayCreateItem("Exit")
TrayItemSetOnEvent($texit,"close")

GUISetState()

While 1
	Sleep(10)
WEnd

Func SetBitmap($hGUI, $hImage, $iOpacity)
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
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap

Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
  if ($hWnd = $Splash) and ($iMsg = $WM_NCHITTEST) then Return $HTCAPTION
EndFunc


Func Hover_Func($CtrlID)
	Switch $CtrlID
		Case $CloseBtn
			GUICtrlSetImage($CtrlID, $CloseBtn1)
;~ 		Case $addbtn
;~ 			GUICtrlSetImage($CtrlID, $addimg1)
		Case $addfbtn
			GUICtrlSetImage($CtrlID, $addfimg1)
		Case $burnbtn
			GUICtrlSetImage($CtrlID, $burnimg1)
	EndSwitch
EndFunc

Func Leave_Hover_Func($CtrlID)
	Switch $CtrlID
		Case $CloseBtn
			GUICtrlSetImage($CtrlID, $CloseBtn0)
;~ 		Case $addbtn
;~ 			GUICtrlSetImage($CtrlID, $addimg0)
		Case $addfbtn
			GUICtrlSetImage($CtrlID, $addfimg0)
		Case $burnbtn
			GUICtrlSetImage($CtrlID, $burnimg0)
	EndSwitch
EndFunc

Func close()
GUICtrlSetImage($CloseBtn, $CloseBtn2)
For $i = 255 To 0 Step - 10
    SetBitmap($Splash, $hImage, $i)
Next

_GDIPlus_ImageDispose($hImage)
GUIDelete($controlGui)
_GDIPlus_Shutdown()
Exit
EndFunc

Func _GuiCtrlMakeTrans($iCtrlID,$iTrans=255)
    Local $pHwnd, $nHwnd, $aPos, $a
    
    $hWnd = GUICtrlGetHandle($iCtrlID);Get the control handle
    If $hWnd = 0 then Return SetError(1,1,0) 
    $pHwnd = DllCall("User32.dll", "hwnd", "GetParent", "hwnd", $hWnd);Get the parent Gui Handle
    If $pHwnd[0] = 0 then Return SetError(1,2,0)
    $aPos = ControlGetPos($pHwnd[0],"",$hWnd);Get the current pos of the control
    If @error then Return SetError(1,3,0)
    $nHwnd = GUICreate("", $aPos[2], $aPos[3], $aPos[0], $aPos[1], 0x80000000, 0x00080000 + 0x00000040, $pHwnd[0]);greate a gui in the position of the control
    If $nHwnd = 0 then Return SetError(1,4,0)
    $a = DllCall("User32.dll", "hwnd", "SetParent", "hwnd", $hWnd, "hwnd", $nHwnd);change the parent of the control to the new gui
    If $a[0] = 0 then Return SetError(1,5,0)
    If NOT ControlMove($nHwnd,'',$hWnd,0,0) then Return SetError(1,6,-1);Move the control to 0,0 of the newly created child gui
    GUISetState(@SW_Show,$nHwnd);show the new child gui
    WinSetTrans($nHwnd,"",$iTrans);set the transparency
    If @error then Return SetError(1,7,0)
    GUISwitch($pHwnd[0]);switch back to the parent Gui
    
    Return $nHwnd;Return the handle for the new Child gui
EndFunc

;~ Func add()
;~ 	GUICtrlSetImage($addbtn, $addimg2)
;~ EndFunc

Func addf()
	GUICtrlSetImage($addfbtn, $addfimg2)
If $already = 1 Then
	$folder = FileSelectFolder("Select folder to add", "")
	If $folder = "" Then
	Else
	GUICtrlSetData($status0,"Current action :       Adding folder...")
	_IMAPI2_AddFolderToFS($fs,$folder)
	GUICtrlSetData($list, $folder)
	GUICtrlSetData($status4,"Space used :          " & StringTrimRight(StringTrimLeft(GUICtrlRead($status4),22),3) + Round(DirGetSize($folder) / 1024 / 1024,1) & " MB")
	GUICtrlSetData($status0,"Current action :       Folder added...")
	$already = 1
EndIf
EndIf
If $already = 0 Then
	$folder = FileSelectFolder("Select folder to add", "")
	If $folder = "" Then
	Else
Do
	GUICtrlSetData($status0,"Current action :       Checking disc...")
	$ids = _IMAPI2_DrivesGetID()
	$drive = _IMAPI2_DriveGetObj($ids[1])
	_IMAPI2_DriveEject($drive)
	MsgBox(64, "L|M|TER CD/DVD Burner", "Please insert a CD-R/DVD-R or CD-RW/DVD-RW/DVD-DL in drive " & _IMAPI2_DriveGetLetter($drive) & @CRLF & "After inserting the disc,close the tray and press OK")
Until DriveSpaceTotal(_IMAPI2_DriveGetLetter($drive) & ":\") = 0 And DriveStatus(_IMAPI2_DriveGetLetter($drive) & ":\") = "UNKNOWN"
Do
	Do
		Sleep(500)
		$code = _IMAPI2_DriveGetMedia($drive)
	Until $code <> -1 ; Wait until the drive is ready
Until $code = $IMAPI_MEDIA_TYPE_CDR Or $code = $IMAPI_MEDIA_TYPE_CDRW Or $code = $IMAPI_MEDIA_TYPE_DVDPLUSR Or $code = $IMAPI_MEDIA_TYPE_DVDPLUSRW Or $code = $IMAPI_MEDIA_TYPE_DVDPLUSR_DUALLAYER Or $code = $IMAPI_MEDIA_TYPE_DVDRAM Or $code = $IMAPI_MEDIA_TYPE_DVDDASHR Or $code = $IMAPI_MEDIA_TYPE_DVDDASHRW OR $code = $IMAPI_MEDIA_TYPE_DVDDASHR_DUALLAYER
	$fs=_IMAPI2_CreateFSForDrive($drive,InputBox("L|M|TER CD/DVD Burner","Please insert a title","My Disc")) ; Create a filesystem
	GUICtrlSetData($status0,"Current action :       Adding folder...")
	_IMAPI2_AddFolderToFS($fs,$folder)
	GUICtrlSetData($list, $folder)
	GUICtrlSetData($status4,"Space used :          " & Round(DirGetSize($folder) / 1024 / 1024,1) & " MB")
	GUICtrlSetData($status0,"Current action :       Folder added...")
	$already = 1
EndIf
EndIf
EndFunc

Func burn()
	GUICtrlSetImage($burnbtn, $burnimg2)
_IMAPI2_BurnFSToDrive($fs,$drive,"_Progress")
EndFunc

Func _Progress($array)
	GUICtrlSetData($status0,"Current action :       " & $array[0])
	GUICtrlSetData($status1,"Remaining time :     " & $array[1])
	GUICtrlSetData($status2,"Elapsed time :         " & $array[2])
	GUICtrlSetData($status3,"Total time :              " & $array[3])
EndFunc

Func remove()
$index = _GUICtrlListBox_GetCurSel($list)
$remtext = _GUICtrlListBox_GetText($list,$index)
GUICtrlSetData($status0,"Current action :       Removing item...")
_IMAPI2_RemoveFolderFromFS($fs,$remtext)
GUICtrlSetData($status4,"Space used :          " & StringTrimRight(StringTrimLeft(GUICtrlRead($status4),22),3) - Round(DirGetSize($remtext) / 1024 / 1024,1) & " MB")
_GUICtrlListBox_DeleteString($list, $index)
GUICtrlSetData($status0,"Current action :       Item removed...")
EndFunc