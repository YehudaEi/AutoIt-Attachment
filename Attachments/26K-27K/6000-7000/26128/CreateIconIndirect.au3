#Include <Constants.au3>
#Include <GDIPlus.au3>
#Include <StaticConstants.au3>
#Include <WindowsConstants.au3>
#Include <WinAPI.au3>

GUICreate('Test', 180, 260)

GUICtrlCreateLabel(' - Back Icon', 80, 18, 100, 16)
GUICtrlCreateLabel(' - Front Icon', 80, 70, 100, 16)
GUICtrlCreateLabel(' - Result Bitmap', 80, 122, 100, 16)
GUICtrlCreateLabel(' - Result Mask', 80, 174, 100, 16)
GUICtrlCreateLabel(' - Result Icon ???', 80, 226, 100, 16)

$Back = GUICtrlCreateIcon('shell32.dll', -42, 34, 10, 32, 32)
$Front = GUICtrlCreateIcon('shell32.dll', -29, 34, 62, 32, 32)
$Bmp = GUICtrlCreatePic('', 34, 114, 32, 32)
$Mask = GUICtrlCreatePic('', 34, 166, 32, 32)
$Result = GUICtrlCreateIcon('', 0, 34, 218, 32, 32)

_SetHIcon($Result, _CombineIcon('shell32.dll', -42, 'shell32.dll', -29, 32, 32))

GUISetState()

do
until GUIGetMsg() = -3

func _CombineIcon($sIconBack, $iIndexBack, $sIconFront, $iIndexFront, $iWidth, $iHeight)
	
	const $STM_SETIMAGE = 0x0172
	
	local $hDC, $hBackDC, $hFrontDC, $hBackSv, $hFrontSv, $sBackInfo, $sFrontInfo, $hBackIcon, $hFrontIcon, $hResultIcon, $hBitmap, $hImage
	
	$hBackIcon = _WinAPI_PrivateExtractIcon($sIconBack, $iIndexBack, $iWidth, $iHeight)
	$hFrontIcon = _WinAPI_PrivateExtractIcon($sIconFront, $iIndexFront, $iWidth, $iHeight)
	
	$sBackInfo = DllStructCreate('byte fIcon;dword xHotspot;dword yHotspot;ptr hbmMask;ptr hbmColor')
	DllCall('user32.dll', 'int', 'GetIconInfo', 'hwnd', $hBackIcon, 'ptr', DllStructGetPtr($sBackInfo))
	$sFrontInfo = DllStructCreate('byte fIcon;dword xHotspot;dword yHotspot;ptr hbmMask;ptr hbmColor')
	DllCall('user32.dll', 'int', 'GetIconInfo', 'hwnd', $hFrontIcon, 'ptr', DllStructGetPtr($sFrontInfo))
	
	$hDC = _WinAPI_GetDC(0)
	$hBackDC = _WinAPI_CreateCompatibleDC($hDC)
	$hBackSv = _WinAPI_SelectObject($hBackDC, DllStructGetData($sBackInfo, 'hbmColor'))
	_WinAPI_DrawIconEx($hBackDC, 0, 0, $hFrontIcon, 0, 0, 0, 0, $DI_NORMAL)
	_WinAPI_SelectObject($hBackDC, DllStructGetData($sBackInfo, 'hbmMask'))
	$hFrontDC = _WinAPI_CreateCompatibleDC($hDC)
	$hFrontSv = _WinAPI_SelectObject($hFrontDC, DllStructGetData($sFrontInfo, 'hbmMask'))
	_WinAPI_BitBlt($hBackDC, 0, 0, $iWidth, $iHeight, $hFrontDC, 0, 0, $SRCAND)

	_GDIPlus_Startup()

	$hImage = _GDIPlus_BitmapCreateFromHBITMAP(DllStructGetData($sBackInfo, 'hbmColor'))
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	_WinAPI_DeleteObject($hImage)
	_WinAPI_DeleteObject(DllStructGetData($sBackInfo, 'hbmColor'))
	DllStructSetData($sBackInfo, 'hbmColor', $hBitmap)
	
	_SetHImage($Bmp, $hBitmap) ; For test only

	$hImage = _GDIPlus_BitmapCreateFromHBITMAP(DllStructGetData($sBackInfo, 'hbmMask'))
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	_WinAPI_DeleteObject($hImage)
	_WinAPI_DeleteObject(DllStructGetData($sBackInfo, 'hbmMask'))
	DllStructSetData($sBackInfo, 'hbmMask', $hBitmap)
	
	_SetHImage($Mask, $hBitmap) ; For test only
	
	_GDIPlus_Shutdown()

	$hResultIcon = _WinAPI_CreateIconIndirect($sBackInfo)

	_WinAPI_SelectObject($hFrontDC, $hFrontSv)
	_WinAPI_SelectObject($hBackDC, $hBackSv)
	_WinAPI_ReleaseDC(0, $hDC)
	_WinAPI_DeleteDC($hFrontDC)
	_WinAPI_DeleteDC($hBackDC)
	_WinAPI_DeleteObject($hFrontIcon)
	_WinAPI_DeleteObject($hBackIcon)
	
	return $hResultIcon
endfunc; _SetCombineBkIcon

#Region Additional Function (Do not pay attention to this)

func _SetHIcon($hWnd, $hIcon)
	
	const $STM_SETIMAGE = 0x0172
	
	local $Style

	if not IsHWnd($hWnd) then
		$hWnd = GUICtrlGetHandle($hWnd)
	endif
	
	if $hWnd = 0 then
		return SetError(1, 0, 0)
	endif
	
	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
	if @error then
		return SetError(1, 0, 0)
	endif
	_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, Hex($SS_ICON)))
	if @error then
		return SetError(1, 0, 0)
	endif
	_WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, 0))
	_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, $hIcon)
	if @error then
		return SetError(1, 0, 0)
	endif
	return 1
endfunc; _SetHIcon

func _SetHImage($hWnd, $hBitmap)
	
	const $STM_SETIMAGE = 0x0172
	
	local $Style

	if not IsHWnd($hWnd) then
		$hWnd = GUICtrlGetHandle($hWnd)
	endif
	
	if $hWnd = 0 then
		return SetError(1, 0, 0)
	endif
	
	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
	if @error then
		return SetError(1, 0, 0)
	endif
	_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, Hex($SS_BITMAP)))
	if @error then
		return SetError(1, 0, 0)
	endif
	_WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_BITMAP, 0))
	_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap)
	if @error then
		return SetError(1, 0, 0)
	endif
	return 1
endfunc; _SetHImage

func _WinAPI_CreateIconIndirect($tICONINFO)
	
	local $Ret = DllCall('user32.dll', 'int', 'CreateIconIndirect', 'ptr', DllStructGetPtr($tICONINFO))
	
	if (@error) or ($Ret[0] = 0) or ($Ret[0] = Ptr(0)) then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, $Ret[0])
endfunc; _WinAPI_CreateIconIndirect

func _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
	
	local $hIcon, $tIcon = DllStructCreate('hwnd'), $tID = DllStructCreate('hwnd')
	local $Ret = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)
	
	if (@error) or ($Ret[0] = 0)then
		return SetError(1, 0, 0)
	endif
	
	$hIcon = DllStructGetData($tIcon, 1)
	
	if ($hIcon = Ptr(0)) or (not IsPtr($hIcon)) then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, $hIcon)
endfunc; _WinAPI_PrivateExtractIcon

#EndRegion Additional Function (Do not pay attention to this)
