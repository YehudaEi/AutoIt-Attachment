#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
#Include <Misc.au3>
global $Width2 = 640, $Height2 = 360, $Width3 = 0, $Height3 = 0, $hClonea, $hCloneb, $hBitmapa, $hBitmapb
$hGUI = GUICreate("Picture Slider", 660, 440)
$d2 = GUICtrlCreateSlider(10, 412, 640, 20)
GUICtrlSetLimit(-1, 639, 1)
GUICtrlSetData(-1, 320)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUISetbkColor(0xe0e0e0)
GUISetState()
Opt("GuiOnEventMode", 1)
_GDIPlus_Startup ()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hgui)

GUICtrlCreateLabel("Image 1:", 50, 20, 40, 15)
GUICtrlCreateLabel("Image 2:", 200, 20, 40, 15)
$pica = GUICtrlCreateGraphic(90, 10, 45, 30)
GUICtrlSetOnEvent(-1, "_sela")
$picb = GUICtrlCreateGraphic(240, 10, 45, 30)
GUICtrlSetOnEvent(-1, "_selb")
bkg("a", 0xff000000)
bkg("b", 0xffff0000)
_slider()
$mylo = @WindowsDir & "\"
func bkg($side, $col)
	$hBitmap1 = _WinAPI_CreateBitmap(640,360,1,32)
	$pen = _GDIPlus_BrushCreateSolid($col)
	if $side = "a" then
        $hBitmapa = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap1)
        $hGraphic1 = _GDIPlus_ImageGetGraphicsContext($hBitmapa)
		_GDIPlus_GraphicsFillRect($hGraphic1, 0, 0, 640,360, $Pen)
		_GDIPlus_GraphicsFillRect($hGraphic, 90, 10, 45, 30, $Pen)
	Else
	    $hBitmapb = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap1)
        $hGraphic1 = _GDIPlus_ImageGetGraphicsContext($hBitmapb)
		_GDIPlus_GraphicsFillRect($hGraphic1, 0, 0, 640,360, $Pen)
		_GDIPlus_GraphicsFillRect($hGraphic, 240, 10, 45, 30, $Pen)
	endif
	_GDIPlus_GraphicsDispose($hGraphic1)
	_WinAPI_DeleteObject ($hBitmap1)
    _GDIPlus_BrushDispose($pen)
endfunc

func _slider()
	$hand = GUICtrlRead($d2)
	_GDIPlus_ImageDispose ($hClonea)
	_GDIPlus_ImageDispose ($hCloneb)
	$hClonea = _GDIPlus_BitmapCloneArea ($hbitmapa, 0, 0, $hand, 360)
    $hCloneb = _GDIPlus_BitmapCloneArea ($hbitmapb, $hand, 0, 640-$hand, 360)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hclonea, 10, 50, $hand, 360)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hcloneb, 10+$hand, 50, 640-$hand, 360)
endfunc

func _quit()
	_GDIPlus_GraphicsDispose ($hGraphic)
	_GDIPlus_ImageDispose ($hClonea)
	_GDIPlus_ImageDispose ($hCloneb)
	 _GDIPlus_BitmapDispose  ($hBitmapa)
	 _GDIPlus_BitmapDispose  ($hBitmapb)
	_GDIPlus_Shutdown ()
	Exit
EndFunc

While 1
    sleep(20)
	while _IsPressed(01)
		sleep(20)
		_slider()
	wend
WEnd

func _sela()
	 _GDIPlus_BitmapDispose  ($hBitmapa)
	_select("a", 0xff000000)
	_slider()
endfunc
func _selb()
	 _GDIPlus_BitmapDispose  ($hBitmapb)
	_select("b", 0xffff0000)
	_slider()
endfunc
func _select($temp, $rc)
	$cstm2pre = FileOpenDialog("Browse...", $mylo, "Images (*.jpg;*.png;*.gif;*.bmp;*.tif)", 1 + 2 + 4)
	$cstm22 = StringLeft ($cstm2pre, stringinstr ($cstm2pre, "|") - 1) & "\"
	$cstm2pre = StringTrimLeft ($cstm2pre, stringinstr ($cstm2pre, "|"))
	if stringinstr ($cstm2pre, "|", 0, 1, 1) > 0 then
		$user = $cstm22 & StringLeft ($cstm2pre, stringinstr ($cstm2pre, "|") - 1)
	Else
		$user = $cstm22 & $cstm2pre
		if stringleft ($user, 1) = "\" then $user = stringtrimleft ($user, 1)
	endif
	$mylo = StringLeft($user, StringInStr ($user, "\", 0, -1))
	if StringInStr("jpg|png|gif|bmp|tif", StringRight($user, 3)) = 0 then
	    bkg($temp, $rc)
	else
		bkg($temp, 0xff000000);without this line the previewpicture will show old content through a selected png-file when it has transparency
		$tp =  _GDIPlus_BitmapCreateFromFile($user)
	    $Width = _GDIPlus_ImageGetWidth($tp)
        $Height = _GDIPlus_ImageGetHeight($tp)
	    _GDIPlus_BitmapDispose ($tp)
        $i = 640
	    $xa = $Width / 640
	    while $Height / $xa > 360
 		    $i -= 1
		    $xa = $Width / $i
	    wend
	    $Width2 = $Width
	    $Height2 = $Height
	    if $Width > 640 or $Height > 360 then
	        $Width2 = int($Width / $xa)
	        $Height2 = int($Height / $xa)
	    endif
	    $Width3 = 0
	    $Height3 = 0
	    if int((640 - $Width2) / 2) > 1 then $Width3 = int((640 - $Width2) / 2)
	    if int((360 - $Height2) / 2) > 1 then $Height3 = int((360 - $Height2) / 2)
	    $hBitmap1 = _WinAPI_CreateBitmap(640,360,1,32)
	    $hImage = _GDIPlus_ImageLoadFromFile($user)
	    $hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap1)
	    if $temp = "a" then
		    $hBitmapa = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap1)
	        $hGraphic1 = _GDIPlus_ImageGetGraphicsContext($hBitmapa)
		    _GDIPlus_GraphicsDrawImageRectRect($hGraphic, $hImage, 0, 0, $Width2, $Height2, 90, 10, 45, 30)
	    Elseif $temp = "b" then
	        $hBitmapb = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap1)
	        $hGraphic1 = _GDIPlus_ImageGetGraphicsContext($hBitmapb)
		    _GDIPlus_GraphicsDrawImageRectRect($hGraphic, $hImage, 0, 0, $Width2, $Height2, 240, 10, 45, 30)
	    endif
	    _GDIPlus_GraphicsDrawImageRect($hGraphic1, $hImage, $Width3, $Height3, $Width2, $Height2)
	    _GDIPlus_GraphicsDispose($hGraphic1)
	    _GDIPlus_BitmapDispose($hImage)
	    _GDIPlus_BitmapDispose($hImage1)
	    _WinAPI_DeleteObject ($hBitmap1)
	endif
endfunc
