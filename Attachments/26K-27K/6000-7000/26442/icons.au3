#Region Header

#cs

	Title:			Support of Icons UDF Library for AutoIt3
	Filename:		Icons.au3
	Description:	Additional and corrected functions for working with icons
	Author:			Yashied
	Version:		1.4
	Requirements:	AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
	Uses:			Constants.au3, GDIPlus.au3, SendMessage.au3, StaticConstants.au3, WinAPI.au3, WindowsConstants.au3
	Notes:			-

	Available functions:

	_SetCombineBkIcon
	_SetIcon
	_SetImage
	
	Added for Handles (HIcon, HBitmap):

	_SetHIcon
	_SetHImage

	Example1:

		#Include <Icons.au3>
		#Include <WinAPI.au3>

		local $Form, $Icon

		$Form = GUICreate('Test', 128, 128)
		$Icon = GUICtrlCreateIcon('', 0, 48, 48, 32, 32)
		GUISetState()

		_SetCombineBkIcon($Icon, _WinAPI_GetBkColor($Form), 'shell32.dll', 0, 'shell32.dll', 28, 32, 32)

		do
		until GUIGetMsg() = -3

		func _WinAPI_GetBkColor($hWnd)

			local $Ret, $hDC = _WinAPI_GetDC($hWnd)

			if $hDC = 0 then
				return SetError(1, 0, -1)
			endif
			$Ret = DllCall('gdi32.dll', 'int', 'GetBkColor', 'hwnd', $hDC)
			if (@error) or ($Ret[0] < 0) then
				$Ret = -1
			endif 

			_WinAPI_ReleaseDC($hWnd, $hDC)

			if $Ret = -1 then
				return SetError(1, 0, -1)
			endif
			return BitAND($Ret[0], 0x00FF00) + BitShift(BitAND($Ret[0], 0x0000FF), -16) + BitShift(BitAND($Ret[0], 0xFF0000), 16)
		endfunc; _WinAPI_GetBkColor

	Example2:

		#Include <Icons.au3>

		local $Icon

		GUICreate('Test', 176, 88)
		$Icon = GUICtrlCreateIcon('', 0, 20, 20, 48, 48)
		GUICtrlCreateIcon(@WindowsDir & '\explorer.exe', 0, 108, 20, 48, 48)
		GUISetState()

		_SetIcon($Icon, @WindowsDir & '\explorer.exe', 0, 48, 48)

		do
		until GUIGetMsg() = -3

	Example3:

		#Include <Icons.au3>

		local $Pic

		GUICreate('Test', 400, 400)
		$Pic = GUICtrlCreatePic('', 75, 75, 250, 250)
		GUISetState()

		_SetImage($Pic, 'Test.png')

		do
		until GUIGetMsg() = -3

#ce

#Include-once

#Include <Constants.au3>
#Include <GDIPlus.au3>
#Include <SendMessage.au3>
#Include <StaticConstants.au3>
#Include <WinAPI.au3>
#Include <WindowsConstants.au3>

#EndRegion Header

#Region Public Functions

func _SetCombineBkIcon($hWnd, $iBackground, $sIconBack, $iIndexBack, $sIconFront, $iIndexFront, $iWidth, $iHeight)
	
	const $STM_SETIMAGE = 0x0172
	
	local $hDC, $hBackDC, $hBackSv, $hBitmap, $hImage, $hBackIcon, $hFrontIcon, $hResultIcon, $Style, $Error = false
	
	if not IsHWnd($hWnd) then
		$hWnd = GUICtrlGetHandle($hWnd)
		if $hWnd = 0 then
			return SetError(1, 0, 0)
		endif
	endif
	
	$hDC = _WinAPI_GetDC(0)
	$hBackDC = _WinAPI_CreateCompatibleDC($hDC)
	$hBitmap = _WinAPI_CreateSolidBitmap(0, $iBackground, $iWidth, $iHeight)
	$hBackSv = _WinAPI_SelectObject($hBackDC, $hBitmap)
	$hBackIcon = _WinAPI_PrivateExtractIcon($sIconBack, $iIndexBack, $iWidth, $iHeight)
	if not @error then
		_WinAPI_DrawIconEx($hBackDC, 0, 0, $hBackIcon, 0, 0, 0, 0, $DI_NORMAL)
	endif
	$hFrontIcon = _WinAPI_PrivateExtractIcon($sIconFront, $iIndexFront, $iWidth, $iHeight)
	if not @error then
		_WinAPI_DrawIconEx($hBackDC, 0, 0, $hFrontIcon, 0, 0, 0, 0, $DI_NORMAL)
	endif
	
	_GDIPlus_Startup()
	
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
	$hResultIcon = DllCall($ghGDIPDll, 'int', 'GdipCreateHICONFromBitmap', 'hWnd', $hImage, 'int*', 0)
	_GDIPlus_ImageDispose($hImage)
	
	_GDIPlus_Shutdown()
	
	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
	if @error then
		$Error = 1
	else
		_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, $SS_ICON))
		if @error then
			$Error = 1
		else
			_WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, 0))
			_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, _WinAPI_CopyIcon($hResultIcon[2]))
			if @error then
				$Error = 1
			endif
		endif
	endif
	
	_WinAPI_SelectObject($hBackDC, $hBackSv)
	_WinAPI_ReleaseDC(0, $hDC)
	_WinAPI_DeleteDC($hBackDC)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteObject($hResultIcon[2])
	_WinAPI_DeleteObject($hFrontIcon)
	_WinAPI_DeleteObject($hBackIcon)
	
	return SetError($Error, 0, not $Error)
endfunc; _SetCombineBkIcon

func _SetIcon($hWnd, $sIcon, $iIndex, $iWidth, $iHeight)
	
	const $STM_SETIMAGE = 0x0172
	
	local $hIcon, $Style, $Error = false

	if not IsHWnd($hWnd) then
		$hWnd = GUICtrlGetHandle($hWnd)
		if $hWnd = 0 then
			return SetError(1, 0, 0)
		endif
	endif
	
	$hIcon = _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
	if @error then
		return SetError(1, 0, 0)
	endif
	
	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
	if @error then
		$Error = 1
	else
		_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, Hex($SS_ICON)))
		if @error then
			$Error = 1
		else
			_WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, 0))
			_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, _WinAPI_CopyIcon($hIcon))
			if @error then
				$Error = 1
			endif
		endif
	endif
	
	_WinAPI_DeleteObject($hIcon)
	
	return SetError($Error, 0, not $Error)
endfunc; _SetIcon

func _SetImage($hWnd, $sImage)
	
	const $STM_SETIMAGE = 0x0172
	
	local $hImage, $hBitmap, $Style, $Error = false

	if not IsHWnd($hWnd) then
		$hWnd = GUICtrlGetHandle($hWnd)
		if $hWnd = 0 then
			return SetError(1, 0, 0)
		endif
	endif
	
	_GDIPlus_Startup()
	
	$hImage = _GDIPlus_BitmapCreateFromFile($sImage)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	if $hBitmap = 0 then
		return SetError(1, 0, 0)
	endif
	
	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
	if @error then
		$Error = 1
	else
		_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, Hex($SS_BITMAP)))
		if @error then
			$Error = 1
		else
			_WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_BITMAP, 0))
			_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap)
			if @error then
				$Error = 1
			endif
		endif
	endif
	
	if $Error then
		_WinAPI_DeleteObject($hBitmap)
	endif
	
	_GDIPlus_BitmapDispose($hImage)
	_GDIPlus_Shutdown()
	
	return SetError($Error, 0, not $Error)
endfunc; _SetImage

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

#EndRegion Public Functions

#Region Internal Functions

func _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
	
	local $hIcon, $tIcon = DllStructCreate('hwnd'), $tID = DllStructCreate('hwnd')
	local $ret = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)
	
	if (@error) or ($ret[0] = 0)then
		return SetError(1, 0, 0)
	endif
	
	$hIcon = DllStructGetData($tIcon, 1)
	
	if ($hIcon = Ptr(0)) or (not IsPtr($hIcon)) then
		return SetError(1, 0, 0)
	endif
	return SetError(0, 0, $hIcon)
endfunc; _WinAPI_PrivateExtractIcon

#EndRegion Internal Functions
