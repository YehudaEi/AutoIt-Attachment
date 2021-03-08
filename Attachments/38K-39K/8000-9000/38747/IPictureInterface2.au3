#include <WinAPI.au3>

Opt( "MustDeclareVars", 1 )

; IPicture Interface
Global Const $sIID_IPicture = "{7BF80980-BF32-101A-8BBB-00AA00300CAB}"
Global Const $tRIID_IPicture = CLSIDFromString( $sIID_IPicture )
Global Const $dtagIPicture = _
	"get_Handle hresult(handle*);" & _																				; Returns the Windows GDI handle of the picture managed within this picture object.
	"get_hPal hresult(handle*);" & _																					; Returns a copy of the palette currently used by the picture object.
	"get_Type hresult(short*);" & _																						; Returns the current type of the picture.
	"get_Width hresult(long*);" & _																						; Returns the current width of the picture in the picture object.
	"get_Height hresult(long*);" & _																					; Returns the current height of the picture in the picture object.
	"Render hresult(handle;long;long;long;long;long;long;long;long;ptr);" & _	; Draws the specified portion of the picture onto the specified device context, positioned at the specified location.
	"set_hPal hresult(handle);" & _																						; Sets the current palette of the picture.
	"get_CurDC hresult(handle*);" & _																					; Returns the current device context into which this picture is selected.
	"SelectPicture hresult(handle;handle*;handle*);" & _											; Selects a bitmap picture into a given device context, returning the device context in which the picture was previously selected as well as the picture's GDI handle.
	"get_KeepOriginalFormat hresult(int*);" & _																; Returns the current value of the picture object's KeepOriginalFormat property.
	"put_KeepOriginalFormat hresult(int);" & _																; Sets the picture object's KeepOriginalFormat property.
	"PictureChanged hresult();" & _																						; Notifies the picture object that its picture resource changed.
	"SaveAsFile hresult(ptr*;int;long*);" & _																	; Saves the picture's data into a stream in the same format that it would save itself into a file.
	"get_Attributes hresult(dword*);"																					; Returns the current set of the picture's bit attributes.

GetPictureProps( "Image.jpg" )

Func GetPictureProps( $ImageFileName )

	Local $iFileSize, $tBuffer, $pBuffer, $hFile, $nBytes
	Local $hMem, $hLock, $lpStream, $aRet
	Local $IPicture, $pIPicture
	Local $props, $handle, $type, $width, $height

	$iFileSize = FileGetSize( $ImageFileName ) + 1
	$tBuffer = DllStructCreate( "byte[" & $iFileSize & "]" )
	$pBuffer = DllStructGetPtr( $tBuffer )
	$hFile = _WinAPI_CreateFile( $ImageFileName, 2, 2 )
	_WinAPI_ReadFile( $hFile, $pBuffer, $iFileSize, $nBytes )
	_WinAPI_CloseHandle( $hFile )

	$hMem = GlobalAlloc( 0x0042, $iFileSize )	; $GHND = 0x0042
	$hLock = GlobalLock( $hMem )
	MoveMemory( $pBuffer, $hLock, $iFileSize )
	$lpStream = CreateStreamOnHGlobal( $hLock, True )

	$aRet = DllCall( "OleAut32.dll", "long", "OleLoadPicture", "ptr", $lpStream, "long", _
		$iFileSize, "bool", True, "ptr", DllStructGetPtr( $tRIID_IPicture ), "ptr*", 0 )
	GlobalUnlock($hMem)
	GlobalFree($hMem)

	$pIPicture = $aRet[5]
	$IPicture = ObjCreateInterface( $pIPicture, $sIID_IPicture, $dtagIPicture )

	$IPicture.get_Handle( $handle )
	$IPicture.get_Type( $type )
	$IPicture.get_Width( $width )
	$IPicture.get_Height( $height )
	$props = "Image name   = " & $ImageFileName & @CRLF & _
					 "Image handle = " & Ptr( $handle ) & @CRLF & _
					 "Image type   = " & $type & @CRLF & _
					 "Image width  = " & MulDiv( $width, GetDeviceCaps( GetDC(0), 88 ), 2540 ) & @CRLF & _	; 88 => LOGPIXELSX
					 "Image height = " & MulDiv( $height, GetDeviceCaps( GetDC(0), 90 ), 2540 )							; 90 => LOGPIXELSY
	MsgBox( 0, "ObjCreateInterface", $props )

EndFunc
	
; Copied from AutoItObject.au3 by
; the AutoItObject team / Prog@ndy.
Func CLSIDFromString($sString)
	Local $tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Local $aRet = DllCall("Ole32.dll", "long", "CLSIDFromString", "wstr", $sString, "ptr", DllStructGetPtr($tCLSID))
	If @error Then Return SetError(1, @error, 0)
	If $aRet[0] <> 0 Then Return SetError(2, $aRet[0], 0)
	Return $tCLSID
EndFunc

; The functions below are copied from the original example

Func GlobalAlloc($uFlags,$dwBytes)
Local $HGLOBAL = DllCall("Kernel32.dll","ptr","GlobalAlloc","UINT",$uFlags,"ULONG_PTR",$dwBytes)
if @error Or $HGLOBAL[0] = 0 Then Return SetError(1,0,0)
Return SetError(0,0,$HGLOBAL[0])
EndFunc

Func GlobalLock($hMem)
Local $LPVOID = DllCall("Kernel32.dll","ptr","GlobalLock","ptr",$hMem)
if @error Or $LPVOID[0] = 0 Then Return SetError(1,0,0)
Return SetError(0,0,$LPVOID[0])
EndFunc

Func GlobalUnlock($hMem)
Local $BOOL = DllCall("Kernel32.dll","BOOL","GlobalUnlock","ptr",$hMem)
if @error Or $BOOL[0] = 0 Then Return SetError(1,0,0)
Return SetError(0,$BOOL[0])
EndFunc

Func GlobalFree($hMem)
Local $HGLOBAL = DllCall("Kernel32.dll","ULONG_PTR","GlobalFree","ptr",$hMem)
if (@error Or ($HGLOBAL[0])) Then Return SetError(1,0,$HGLOBAL[0])
Return SetError(0,0,0)
EndFunc

Func CreateStreamOnHGlobal($hGlobal,$fDeleteOnRelease)
Local $WINOLE = DllCall("Ole32.dll","PTR","CreateStreamOnHGlobal","ptr",$hGlobal,"BOOL",$fDeleteOnRelease,"PTR*",0)
if @error Or $WINOLE[0] <> 0 Then Return SetError(1,0,0)
Return SetError(0,0,$WINOLE[3])
EndFunc

Func MoveMemory($Source,$Destination,$Length)
DllCall("Kernel32.dll","none","RtlMoveMemory","PTR",$Destination,"PTR",$Source,"INT",$Length)
EndFunc

Func MulDiv($nNumber,$nNumerator,$nDenominator)
Local $Rt = DllCall("Kernel32.dll","int","MulDiv","int",$nNumber,"int",$nNumerator,"int",$nDenominator)
Return $Rt[0]
EndFunc

Func GetDeviceCaps($hdc,$nIndex)
Local $Rt = DllCall("Gdi32.dll","int","GetDeviceCaps","ptr",$hdc,"int",$nIndex)
Return $Rt[0]
EndFunc

Func GetDC($hWnd)
Local $HDC = DllCall("User32.dll","ptr","GetDC","ptr",$hWnd)
if @error Or $HDC[0] = 0 Then Return SetError(1,0,0)
Return SetError(0,0,$HDC[0])
EndFunc
