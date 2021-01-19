#include-once

Global Const $RT_CURSOR = 1
Global Const $RT_BITMAP = 2
Global Const $RT_ICON = 3
Global Const $RT_MENU = 4
Global Const $RT_DIALOG = 5
Global Const $RT_STRING = 6
Global Const $RT_FONTDIR = 7
Global Const $RT_FONT = 8
Global Const $RT_ACCELERATORS = 9
Global Const $RT_RCDATA = 10
Global Const $RT_MESSAGETABLE = 11
Global Const $RT_GROUP_CURSOR = 12
Global Const $RT_GROUP_ICON = 14
Global Const $RT_VERSION = 16

Global Const $RT_ANICURSOR = 21
Global Const $RT_ANIICON = 22
Global Const $RT_HTML = 23
Global Const $RT_MANIFEST = 24

Global Const $SND_RESOURCE = 0x00040004
Global Const $SND_SYNC = 0x0
Global Const $SND_ASYNC = 0x1
Global Const $SND_LOOP = 0x8
Global Const $SND_NOSTOP = 0x10
Global Const $SND_NOWAIT = 0x2000
Global Const $SND_PURGE = 0x40

Func _ResourceGet($ResName, $ResType = 10, $ResLang = 0) ; $RT_RCDATA = 10
	Local Const $IMAGE_BITMAP = 0
	Local $hInstance, $hBitmap, $InfoBlock, $GlobalMemoryBlock, $MemoryPointer, $ResSize
	
	$hInstance = DllCall("kernel32.dll", "int", "GetModuleHandleA", "int", 0)
	$hInstance = $hInstance[0]

	If $ResType = $RT_BITMAP Then
		$hBitmap = DllCall("user32.dll", "hwnd", "LoadImage", "hwnd", $hInstance, "str", $ResName, _
				"int", $IMAGE_BITMAP, "int", 0, "int", 0, "int", 0)
		If @error Then Return SetError(1, 0, 0)
		$hBitmap = $hBitmap[0]
		Return $hBitmap ; returns handle to Bitmap
	EndIf

	If $ResLang <> 0 Then
		$InfoBlock = DllCall("kernel32.dll", "int", "FindResourceExA", "int", $hInstance, "str", $ResName, "long", $ResType, "short", $ResLang)
	Else
		$InfoBlock = DllCall("kernel32.dll", "int", "FindResourceA", "int", $hInstance, "str", $ResName, "long", $ResType)
	EndIf
	
	If @error Then Return SetError(2, 0, 0)
	$InfoBlock = $InfoBlock[0]
	If $InfoBlock = 0 Then Return SetError(3, 0, 0)
	
	$ResSize = DllCall("kernel32.dll", "dword", "SizeofResource", "int", $hInstance, "int", $InfoBlock)
	If @error Then Return SetError(4, 0, 0)
	$ResSize = $ResSize[0]
	If $ResSize = 0 Then Return SetError(5, 0, 0)
	
	$GlobalMemoryBlock = DllCall("kernel32.dll", "int", "LoadResource", "int", $hInstance, "int", $InfoBlock)
	If @error Then Return SetError(6, 0, 0)
	$GlobalMemoryBlock = $GlobalMemoryBlock[0]
	If $GlobalMemoryBlock = 0 Then Return SetError(7, 0, 0)
	
	$MemoryPointer = DllCall("kernel32.dll", "int", "LockResource", "int", $GlobalMemoryBlock)
	If @error Then Return SetError(8, 0, 0)
	$MemoryPointer = $MemoryPointer[0]
	If $MemoryPointer = 0 Then Return SetError(9, 0, 0)
	
	SetExtended($ResSize)
	Return $MemoryPointer
EndFunc

Func _ResourceGetAsString($ResName, $ResType = 10, $ResLang = 0) ; $RT_RCDATA = 10
	Local $ResPointer, $ResSize, $struct

	$ResPointer = _ResourceGet($ResName, $ResType, $ResLang)
	If @error Then
		SetError(1, 0, 0)
		Return ''
	EndIf
	$ResSize = @extended
	$struct = DllStructCreate("char[" & $ResSize & "]", $ResPointer)
	Return DllStructGetData($struct, 1) ; returns string
EndFunc

Func _ResourceGetAsBytes($ResName, $ResType = 10, $ResLang = 0) ; $RT_RCDATA = 10
	Local $ResPointer, $ResSize

	$ResPointer = _ResourceGet($ResName, $ResType, $ResLang)
	If @error Then Return SetError(1, 0, 0)
	$ResSize = @extended
	Return DllStructCreate("byte[" & $ResSize & "]", $ResPointer) ; returns struct with bytes
EndFunc

Func _ResourceSaveToFile($FileName, $ResName, $ResType = 10, $ResLang = 0, $CreatePath = 0) ; $RT_RCDATA = 10
	Local $ResStruct, $ResSize, $FileHandle

	$ResStruct = _ResourceGetAsBytes($ResName, $ResType, $ResLang)
	If @error Then Return SetError(1, 0, 0)
	$ResSize = DllStructGetSize($ResStruct)
	
	If $CreatePath Then $CreatePath = 8 ; mode 8 = Create directory structure if it doesn't exist
	$FileHandle = FileOpen($FileName, 2+16+$CreatePath)
	If @error Then Return SetError(2, 0, 0)
	FileWrite($FileHandle, DllStructGetData($ResStruct, 1))
	If @error Then Return SetError(3, 0, 0)
	FileClose($FileHandle)
	If @error Then Return SetError(4, 0, 0)

	Return $ResSize
EndFunc

Func _ResourceSetImageToCtrl($CtrlId, $ResName, $ResType = 10) ; $RT_RCDATA = 10
	Local $ResData = _ResourceGet($ResName, $ResType)
	If @error Then Return SetError(1, 0, 0)
	
	If $ResType = $RT_BITMAP Then
		_SetBitmapToCtrl($CtrlId, $ResData)
		If @error Then Return SetError(2, 0, 0)
		Return 1
	EndIf
	
	; for other types then BITMAP not implemented yet (must be used GDI+) ...
	; ...
	Return SetError(-1, 0, 0)
EndFunc

; internal helper function
Func _SetBitmapToCtrl($CtrlId, $hBitmap)
    Local Const $STM_SETIMAGE = 0x0172
    Local Const $IMAGE_BITMAP = 0

    Local $hWnd = GUICtrlGetHandle($CtrlId)
	If $hWnd = 0 Then Return SetError(1, 0, 0)
    DllCall("user32.dll", "hwnd", "SendMessage", "hwnd", $hWnd, "int", $STM_SETIMAGE, "int", $IMAGE_BITMAP, "int", $hBitmap)
	If @error Then Return SetError(2, 0, 0)
	Return 1
EndFunc

; thanks Larry
; MSDN: http://msdn2.microsoft.com/en-us/library/ms712879.aspx
; default flag is $SND_SYNC = 0
Func _ResourcePlaySound($ResName, $Flag = 0)
	Local $ret = DllCall("winmm.dll", "int", "PlaySound", "str", $ResName, "hwnd", 0, "int", BitOr($SND_RESOURCE,$Flag))
	If @error Then Return SetError(1, 0, 0)
	Return $ret[0]
EndFunc
