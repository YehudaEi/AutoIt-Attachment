#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#NoTrayIcon

AutoItSetOption("GUICloseOnESC", 0)
Global $x = 640, $y = 480, $size = 0, $dir = @DesktopDir, $dir1, $dir2, $out
Global Const $GUIname = "Simple Image Resizer"
$Form1 = GUICreate("Form1", 400, 350, -1, -1)
$lbl = GUICtrlCreateLabel($GUIname, 8, 8, 384, 41, BitOR($SS_CENTER,$SS_CENTERIMAGE,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetFont(-1, 24, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0x800000)
GUICtrlCreateGroup("Target Options", 10, 60, 247, 120)
GUICtrlCreateLabel("Target Destination:", 25, 80, 150, 20)
$Input1 = GUICtrlCreateInput("", 25, 98, 150, 20)
$Button1 = GUICtrlCreateButton("&Browse...", 180, 97, 65, 22)
GUICtrlCreateLabel("Save to next Destination:", 25, 126, 150, 20)
$Input2 = GUICtrlCreateInput("", 25, 144, 150, 20)
$Button2 = GUICtrlCreateButton("B&rowse...", 180, 143, 65, 22)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Picture Preview", 270, 60, 120, 120, -1, $WS_EX_TRANSPARENT)
$Edit1 = GUICtrlCreateEdit("", 281,78, 98, 92, 0)
GUICtrlSetBkColor($Edit1, 0xFFFFFF)
GUICtrlSetState(-1, $GUI_DISABLE)
$Pic1 = GUICtrlCreatePic("", 285, 79, 90, 90)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Size Options", 10, 187, 380, 125)
GUICtrlCreateLabel("Select a size:", 25, 208, 260, 20)
$Radio1 = GUICtrlCreateRadio("&Small (640 by 480 pixels)", 27, 225, 265, 17)
$Radio2 = GUICtrlCreateRadio("&Medium (800 by 600 pixels)", 27, 245, 265, 17)
$Radio3 = GUICtrlCreateRadio("&Large (1024 by 768 pixels)", 27, 265, 265, 17)
$Radio4 = GUICtrlCreateRadio("&Custom (", 27, 285, 60, 17)
GUICtrlCreateLabel("    by", 130, 287, 25, 17)
GUICtrlCreateLabel("pixels)", 213, 287, 100, 17)
$Input3 = GUICtrlCreateInput("", 87, 285, 50, 17, BitOR($ES_CENTER,$ES_AUTOHSCROLL,$ES_NUMBER))
GUICtrlSetLimit(-1, 4)
GUICtrlSetState(-1, $GUI_DISABLE)
$Input4 = GUICtrlCreateInput("", 159, 285, 50, 17, BitOR($ES_CENTER,$ES_AUTOHSCROLL,$ES_NUMBER))
GUICtrlSetLimit(-1, 4)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState($Radio1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$status = GUICtrlCreateLabel($GUIname & " by n3nE", 15, 325, 220, 17)
$Button3 = GUICtrlCreateButton("&Resize", 236, 320, 75, 23, 1)
$Button4 = GUICtrlCreateButton("Clos&e", 317, 320, 75, 23)
GUISetState(@SW_SHOW)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $Button4
			Exit
	EndSwitch
WEnd

Func _Open($dest)
	Local $open
	If $dest = 1 Then
		$open = FileOpenDialog("Open", $dir, "Bitmap (*.bmp;*.dib)|JPEG (*.jpg;*.jpeg;*.jpe;*.jfif)|GIF (*.gif)|TIFF (*.tif;*.tiff)|PNG (*.png)|All Files (*.*)", 1+2, "", $Form1)
		If $open <> "" Then
			$out = StringTrimRight($open ,StringLen(StringMid($open, StringInStr($open, ".", 0, -1)))) & " copy"
			If FileExists($open) Then
				$dir1 = $open
				GUICtrlSetData($Input1, $open)
				GUICtrlSetColor($status, 0x008000)
				GUICtrlSetData($status, "Picture for resizing successfully loaded.")
				GUICtrlSetImage($Pic1, $open)
			Else
				GUICtrlSetColor($status, 0xFF0000)
				GUICtrlSetData($status, "Failed loading picture for resizing.")
			EndIf
			AdlibEnable("_Byn3nE", 3000)
		EndIf
	Else
		$open = _FileSaveDialog("Save As", $dir, "Bitmap (*.bmp;*.dib)|JPEG (*.jpg;*.jpeg;*.jpe;*.jfif)|GIF (*.gif)|TIFF (*.tif;*.tiff)|PNG (*.png)|All Files (*.*)", 16, $out, "", $Form1)
		If $open <> "" Then
				GUICtrlSetData($Input2, $open)
				$dir2 = $open
		EndIf
	EndIf 
	$dir = $open
EndFunc

Func _ImageResize($sInImage, $sOutImage, $iW, $iH)
    Local $hWnd, $hDC, $hBMP, $hImage1, $hImage2, $hGraphic, $CLSID, $i = 0
    Local $sOF = StringMid($sOutImage, StringInStr($sOutImage, "\", 0, -1) + 1)
    Local $Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))
    $hWnd = _WinAPI_GetDesktopWindow()
    $hDC = _WinAPI_GetDC($hWnd)
    $hBMP = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
    _WinAPI_ReleaseDC($hWnd, $hDC)
    _GDIPlus_Startup()
    $hImage1 = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
    $hImage2 = _GDIPlus_ImageLoadFromFile($sInImage)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)
    _GDIPLus_GraphicsDrawImageRect($hGraphic, $hImage2, 0, 0, $iW, $iH)
    $CLSID = _GDIPlus_EncodersGetCLSID($Ext)
    _GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID)
    _GDIPlus_ImageDispose($hImage1)
    _GDIPlus_ImageDispose($hImage2)
    _GDIPlus_GraphicsDispose ($hGraphic)
    _WinAPI_DeleteObject($hBMP)
    _GDIPlus_Shutdown()
		GUICtrlSetColor($status, 0x008000)
		GUICtrlSetData($status, "Picture has been resized successfully.")
		AdlibEnable("_Byn3nE", 3000)
EndFunc

Func _Byn3nE()
	GUICtrlSetColor($status, 0x000000)
	GUICtrlSetData($status, "Image Resizer by n3nE")
	AdlibDisable()
EndFunc

Func WM_COMMAND($hWndGUI, $iMsg, $iwParam, $ilParam)
	$msg = BitAND($iwParam, 0x0000FFFF)
	Switch $msg
		Case 2
			_Clean()
			Return 0
		Case $Button1
			_Open(1)
		Case $Button2
			_Open(2)
		Case $Button3
			If $size <> 0 Then
				$x = GUICtrlRead($Input3)
				$y = GUICtrlRead($Input4)
			EndIf
			$dir1 = GUICtrlRead($Input1)
			If $dir1 <> "" Then
				$dir2 = GUICtrlRead($Input2)
				If $dir2 <> "" Then
					If $x > 0 And $y > 0 Then
						_ImageResize($dir1, $dir2, $x, $y)
					Else
						GUICtrlSetColor($status, 0xFF0000)
						GUICtrlSetData($status, "Please enter desired image resolution.")
					EndIf
				Else
					GUICtrlSetColor($status, 0xFF0000)
					GUICtrlSetData($status, "Please select target destination.")
				EndIf
			Else
				GUICtrlSetColor($status, 0xFF0000)
				GUICtrlSetData($status, "Please select save destination...")
			EndIf
			AdlibEnable("_Byn3nE", 3000)
		Case $Radio1, $Radio2, $Radio3
			GUICtrlSetState($Input3, $GUI_DISABLE)
			GUICtrlSetState($Input4, $GUI_DISABLE)
			If $msg = $Radio1 Then
				$x = 640
				$y = 480
				$size = 0
			ElseIf $msg = $Radio2 Then
				$x = 800
				$y = 600
				$size = 0
			ElseIf $msg = $Radio3 Then
				$x = 1024
				$y = 768
				$size = 0
			EndIf
		Case $Radio4
			GUICtrlSetState($Input3, $GUI_ENABLE)
			GUICtrlSetState($Input4, $GUI_ENABLE)
			$size = 1
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func _FileSaveDialog ($sTitle, $sInitDir, $sFilter = 'All (*.*)', $iOpt = 0, $sDefaultFile = "", $sDefaultExt = "", $mainGUI = 0)
    Local $iFileLen = 65536
    Local $iFlag = BitOR (BitShift (BitAND ($iOpt, 2),-10), BitShift (BitAND ($iOpt,16), 3 ))
    Local $asFLines = StringSplit ( $sFilter, '|'), $asFilter [$asFLines [0] *2+1]
    Local $i, $iStart, $iFinal, $suFilter = ''
    $asFilter [0] = $asFLines [0] *2
    For $i=1 To $asFLines [0]
        $iStart = StringInStr ($asFLines [$i], '(', 0, -1)
        $iFinal = StringInStr ($asFLines [$i], ')', 0,-1)
        $asFilter [$i*2] = StringStripWS (StringTrimRight (StringTrimLeft ($asFLines [$i], $iStart), StringLen ($asFLines [$i]) -$iFinal+1), 3)
		$asFilter [$i*2-1] = StringStripWS (StringLeft ($asFLines [$i], $iStart-1), 3) & " (" & $asFilter [$i*2] & ")"
        $suFilter = $suFilter & 'char[' & StringLen ($asFilter [$i*2-1])+1 & '];char[' & StringLen ($asFilter [$i*2])+1 & '];'
    Next
    Local $uOFN = DllStructCreate ('dword;int;int;ptr;ptr;dword;dword;ptr;dword' & _
        ';ptr;int;ptr;ptr;dword;short;short;ptr;ptr;ptr;ptr;ptr;dword;dword' )
    Local $usTitle  = DllStructCreate ('char[' & StringLen ($sTitle) +1 & ']')
    Local $usInitDir= DllStructCreate ('char[' & StringLen ($sInitDir) +1 & ']')
    Local $usFilter = DllStructCreate ($suFilter & 'char')
    Local $usFile   = DllStructCreate ('char[' & $iFileLen & ']')
    Local $usExtn   = DllStructCreate ('char[' & StringLen ($sDefaultExt) +1 & ']')
    For $i=1 To $asFilter [0]
        DllStructSetData ($usFilter, $i, $asFilter [$i])
    Next
    DllStructSetData ($usTitle, 1, $sTitle)
    DllStructSetData ($usInitDir, 1, $sInitDir)
    DllStructSetData ($usFile, 1, $sDefaultFile)
    DllStructSetData ($usExtn, 1, $sDefaultExt)
    DllStructSetData ($uOFN,  1, DllStructGetSize($uOFN))
    DllStructSetData ($uOFN,  2, $mainGUI)
    DllStructSetData ($uOFN,  4, DllStructGetPtr ($usFilter))
    DllStructSetData ($uOFN,  7, 1)
    DllStructSetData ($uOFN,  8, DllStructGetPtr ($usFile))
    DllStructSetData ($uOFN,  9, $iFileLen)
    DllStructSetData ($uOFN, 12, DllStructGetPtr ($usInitDir))
    DllStructSetData ($uOFN, 13, DllStructGetPtr ($usTitle))
    DllStructSetData ($uOFN, 14, $iFlag)
    DllStructSetData ($uOFN, 17, DllStructGetPtr ($usExtn))
    DllStructSetData ($uOFN, 23, BitShift (BitAND ($iOpt, 32), 5))
    $ret = DllCall ('comdlg32.dll', 'int', 'GetSaveFileName', _
            'ptr', DllStructGetPtr ($uOFN) )
    If $ret [0] Then
        Return DllStructGetData ($usFile, 1)
    Else
        SetError (1)
        Return ""
    EndIf
EndFunc

Func _Clean()
$x = 640
	$y = 480
	$size = 0
	$dir1 = ""
	$dir2 = ""
	GUICtrlSetData($Input1, "")
	GUICtrlSetData($Input2, "")
	GUICtrlSetImage($Pic1, "")
	GUICtrlSetData($Input3, "")
	GUICtrlSetData($Input4, "")
	GUICtrlSetState($Radio1, $GUI_CHECKED)
	GUICtrlSetState($Input3, $GUI_DISABLE)
	GUICtrlSetState($Input4, $GUI_DISABLE)
	GUICtrlSetColor($status, 0x008000)
	GUICtrlSetData($status, "New resize project has been started.")
	AdlibEnable("_Byn3nE", 3000)
EndFunc