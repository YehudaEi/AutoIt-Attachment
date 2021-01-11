; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Author(s):      Steve Podhajecki [eltorro] gehossafats@netmdc.com
; Description:    Save PrtScr from clipboard as bmp file using AutoIt3 and API
;				  No extra dll's required.
;				  Works on XP  should work on OS >= Win2k
; ------------------------------------------------------------------------------
;
#Compiler_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7 ;Au3Check parameters
; ------------------------------------------------------------------------------
;http://www.autoitscript.com/forum/index.php?act=Attach&type=post&id=5084
#include <APIFileReadWrite.au3>
; ------------------------------------------------------------------------------
Global Const $SRCCOPY			= 0x00CC0020

Global Const $CF_BITMAP = 2
Global Const $tagBITS = "byte[255]"
Global Const $tagBITMAP = "int;int;int;int;ushort;ushort;ptr"; 24bytes ptr is to BITS
Global Const $tagBITMAPINFOHEADER = "dword;int;int;ushort;ushort;dword;dword;int;int;dword;dword";
Global Const $tagQUAD = "byte[4]"
Global Const $tagBITMAPFILEHEADER = "ushort;dword;ushort;ushort;dword"
Global Const $tagBITMAPINFO = "prt;ptr"; has BITMAPINFOHEADER and RGBQUAD
;----------------------------------------------------------
Global $StructError[5]=["No error","Variable passed to DllStructCreate was not a string. ","There is an unknown Data Type in the string passed.", _
"Failed to allocate the memory needed for the struct, or Pointer = 0.","Error allocating memory for the passed string."]
;----------------------------------------------------------
Global $DEBUG = True
Global $LOG= @ScriptDir&"\screenprint.log"
;If FileExists($LOG) then FileDelete($LOG)
;----------------------------------------------------------
;~ ClipPut("")

If $DEBUG Then
	_FileWriteLog($LOG,";----------------------------------------------------------" & @LF)
	_FileWriteLog($LOG,"Begin Process: "&@error &@LF)
EndIf
Send("!{printscreen}"); active window
if $DEBUG then _FileWriteLog($LOG,"Captured Screen>"&@error &@LF)

;Send("{printscreen}") ;full screen
Sleep(100)

Local $clipbmp = GetClipBoard()
if $DEBUG then _FileWriteLog($LOG,"Getting Clipboard>"&@error &@LF)

if $clipbmp  then
	if $DEBUG then _FileWriteLog($LOG,"Calling SaveDib>"&@error &@LF)
	SaveDib($clipbmp,@DesktopCommonDir&"\clipboardtest.bmp")
	;SaveDib($clipbmp,@DesktopCommonDir&"\errormsg.bmp")
	if $DEBUG then _FileWriteLog($LOG,"Return Error Status: "&@error &@LF)
EndIf
If $DEBUG Then
	_FileWriteLog($LOG,"Exiting Now.  Bye." & @LF)
	_FileWriteLog($LOG,";----------------------------------------------------------" & @LF&@LF)
EndIf
sleep(3000)
Exit

Func GetClipBoard()
	Local $hBitmap
	Local $hMyDC
	Local $BMP = DllStructCreate($tagBITMAP);InfoHeader&";byte[4]")
	if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
	Local $Me = DllCall("user32.dll","hwnd","GetDesktopWindow")
	if IsArray($Me) Then
	OpenClipboard ($Me[0])
	If (IsClipboardFormatAvailable ($CF_BITMAP)) Then
		$hMyDC = CreateCompatibleDC (0)
		If ($hMyDC) Then
			$hBitmap = GetClipboardData ($CF_BITMAP)
			CloseClipboard()
			If ($hBitmap) Then
				GetObject ($hBitmap, DllStructGetSize($BMP), DllStructGetPtr($BMP))
				For $x = 1 To 7
					If $DEBUG Then _FileWriteLog($LOG,"$BMP " & $x & ">" & DllStructGetData($BMP, $x) & @LF)
				Next
			Else
				If $DEBUG Then _FileWriteLog($LOG,"Error retrieving Bitmap" & @LF)
			EndIf
			$BMP = 0 ; Release struct.

			DeleteDC ($hMyDC)

			If $DEBUG Then _FileWriteLog($LOG,"Back from Save Routine" & @LF)
		Else
			If $DEBUG Then _FileWriteLog($LOG,"Error creating DC" & @LF)
		EndIf
		Return $hBitmap
	Else
		If $DEBUG Then _FileWriteLog($LOG,"No bitmap's in clipboard" & @LF)
	EndIf
	EndIf

EndFunc   ;==>GetClipBoard


Func SaveDib($inDib, $sFile="")

	If $inDib =0 then
		if $DEBUG Then _FileWriteLog($LOG,"No bitmap to process." & @LF)
		Seterror(1)
		Return 0
	EndIf
if $sFile ="" Then $sFile = @DesktopCommonDir&"\"&@MON & @MDAY & @YEAR & @HOUR & @MIN & @SEC & ".bmp"
	if $DEBUG Then _FileWriteLog($LOG,"Filename is: "& $sFile & @LF)
	Local $vret, $biWidth , $biHeight ,  $biBitCount, $biCompression, $biSizeImage,$biClrUsed,$size
	;Local $biSize,$biPlanes, $biXPelsPerMeter, $biYPelsPerMeter,$biClrImportant ;unused

	;----------------------------------------------------------
	;Structs
	;----------------------------------------------------------
	Local $DIBHead,$bmInfoHeader,$bmColors,$bmBitmap,$bmBits,$pbuf,$FileHead
	$bmbits = DllStructCreate($tagBITS)
	if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
;----------------------------------------------------------
	$bmBitmap = DllStructCreate($tagBITMAP)
	if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
	DllStructSetData($bmBitmap, 7, DllStructGetPtr($bmbits))
;----------------------------------------------------------
	$DIBHead = DllStructCreate($tagBITMAPINFOHEADER & ";" & $tagQUAD)
	if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
	$bmInfoHeader = DllStructCreate($tagBITMAPINFOHEADER, DllStructGetPtr($DIBHead, 1))
	if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
	$bmColors = DllStructCreate($tagBITMAPINFOHEADER, DllStructGetPtr($DIBHead, 12))
	if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
				If $DEBUG Then
					Local $ptr1 = DllStructGetPtr($bmInfoHeader)
					Local $ptr2 = DllStructGetPtr($bmColors)
					_FileWriteLog($LOG,"$ptr1 " & $ptr1 & @LF)
					_FileWriteLog($LOG,"$ptr2 " & $ptr2 & @LF)
				EndIf
;----------------------------------------------------------
	Local $NumCols, $DeskDC
	If (GetObject ($inDib, DllStructGetSize($bmBitmap), DllStructGetPtr($bmBitmap)) = 0) Then
		If $DEBUG Then _FileWriteLog($LOG,"GetObject Failed" & @LF)
			Return 0
		EndIf
	If $DEBUG Then
		For $x = 1 To 7
			_FileWriteLog($LOG,"$bmBitmap>>" & DllStructGetData($bmBitmap, $x) & @LF)
		Next
	EndIf
;----------------------------------------------------------
	; Get a reference DC to work with
	$DeskDC = GetDC (0)
	; Set Bitmap info header size
	DllStructSetData($bmInfoHeader, 1, DllStructGetSize($bmInfoHeader)); 40 bytes??
	; Attempt to read DIBSection header
	If $DEBUG Then _FileWriteLog($LOG,"---------------" & @LF)
	$vret = GetDIBits ($DeskDC, $inDib, 0, 0, 0, DllStructGetPtr($DIBHead), 0)
	If ($vret) Then
	If $DEBUG Then
		For $x = 1 To 11
			_FileWriteLog($LOG,"$bmInfoHeader>" & $x & ">" & DllStructGetData($bmInfoHeader, $x) & @LF)
		Next
	EndIf
	;----------------------------------------------------------
	;set some easy to remember vars.
		;	$biSize = DllStructGetData($bmInfoHeader, 1)
		$biWidth = DllStructGetData($bmInfoHeader, 2)
		$biHeight = DllStructGetData($bmInfoHeader, 3)
		;	$biPlanes = DllStructGetData($bmInfoHeader, 4)
		$biBitCount = DllStructGetData($bmInfoHeader, 5)
		$biCompression = DllStructGetData($bmInfoHeader, 6)
		$biSizeImage = DllStructGetData($bmInfoHeader, 7)
		;	$biXPelsPerMeter = DllStructGetData($bmInfoHeader, 8)
		;	$biYPelsPerMeter = DllStructGetData($bmInfoHeader, 9)
		$biClrUsed = DllStructGetData($bmInfoHeader, 10)
		;	$biClrImportant = DllStructGetData($bmInfoHeader, 11)
	;----------------------------------------------------------
		If $biBitCount <= 8 Then
			If $DEBUG Then _FileWriteLog($LOG,"Bitcount 8 or less" & @LF)
			$NumCols = $biClrUsed
			If ($NumCols = 0) Then $NumCols = 2 ^ $biBitCount
			$vret = GetDIBits ($DeskDC, $inDib, 0, 0, 0, DllStructGetPtr($DIBHead), 0)
				If $vret =0 Then
					If $DEBUG Then _FileWriteLog($LOG,"GetDIBits Error" & @LF)
					ReleaseDC(Default,$DeskDC)
					Return SetError(1)
				EndIf
		ElseIf ($biCompression) Then
			If ($biCompression = 3) Then
				$NumCols = 3
			Else ; Don't support RLE compressed images
				If $DEBUG Then _FileWriteLog($LOG,"RLE Compressed image not supported" & @LF)
				ReleaseDC (0, $DeskDC)
				Return 0
			EndIf
		EndIf
		If $DEBUG Then _FileWriteLog($LOG,"Calculating size: ")
		$size = $biSizeImage
		If $biSizeImage <= 0 Then
			$size = ($biWidth * Abs($biHeight) * $biBitCount + 7) / 8
			DllStructSetData($bmInfoHeader, 7, $size)
		EndIf
		If $DEBUG Then _FileWriteLog($LOG,"Size is " & $size & @LF)
		If $DEBUG Then _FileWriteLog($LOG,"Creating buffer" & @LF)
		$pbuf = DllStructCreate("byte[" & $size & "]")
		if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
		If $DEBUG Then _FileWriteLog($LOG,"Buffer Created" & @LF)
		If $DEBUG Then _FileWriteLog($LOG,"Moving image data to buffer" & @LF)
		; Read image data
		$vret = GetDIBits($DeskDC, $inDib, 0, $biHeight, DllStructGetPtr($pbuf), DllStructGetPtr($DIBHead), 0)
			If $vret = 0 Then
				If $DEBUG Then _FileWriteLog($LOG,"GetDIBits Error" & @LF)
				ReleaseDC (0, $DeskDC)
				Return SetError(1)
			EndIf
		If $DEBUG Then _FileWriteLog($LOG,"Success." & @LF)
		For $x = 1 To 11
			If $DEBUG Then _FileWriteLog($LOG,"$bmInfoHeader>" & $x & ">" & DllStructGetData($bmInfoHeader, $x) & @LF)
		Next

;----------------------------------------------------------
;Write out bmp to file
;----------------------------------------------------------
		If $DEBUG Then _FileWriteLog($LOG,"Setting up file header" & @LF)
		$FileHead = DllStructCreate($tagBITMAPFILEHEADER)
		if $DEBUG Then _FileWriteLog($LOG,"DllStructCreate Error>" &$StructError[@error]& @LF)
		DllStructSetData($FileHead, 1, 0x04d42)
		DllStructSetData($FileHead, 5, DllStructGetSize($FileHead) + DllStructGetSize($bmInfoHeader) + $NumCols * 4)
		If $DEBUG Then _FileWriteLog($LOG,"Setting up file header> 'Type Set'" & @LF)
		If $DEBUG Then _FileWriteLog($LOG,"Setting up file header> Size Set" & @LF)


		If $DEBUG Then _FileWriteLog($LOG,"Attempting to save file" & @LF)
		Sleep(100)
		Local $hFile = _APIFileOpen( $sFile )
		_FileWriteLog($LOG,"Error Status: "&@error &@LF)
		_BinaryFileWrite($hFile, $FileHead)
		If $DEBUG Then
			_FileWriteLog($LOG,"Error Status: "&@error &@LF)
			_FileWriteLog($LOG,"File header written" & @LF)
		EndIf
		Sleep(100)
				;bmp info
				_BinaryFileWrite($hFile,$bmInfoHeader) 
		If $DEBUG Then
			_FileWriteLog($LOG,"Error Status: "&@error &@LF)
			_FileWriteLog($LOG,"BITMAPINFO written" & @LF)
		EndIf
		Sleep(100)
		; palette
		_BinaryFileWrite($hFile,$bmColors)
		If $DEBUG Then
			_FileWriteLog($LOG,"Error Status: "&@error &@LF)
			_FileWriteLog($LOG,"PALETTE written" & @LF)
		EndIf
		Sleep(100)
		; image data
		_BinaryFileWrite($hFile,$pbuf)
		If $DEBUG Then
			_FileWriteLog($LOG,"Error Status: "&@error &@LF)
			_FileWriteLog($LOG,"Image data written" & @LF)
		EndIf
		_APIFileClose($hFile)
;----------------------------------------------------------
;clean Up
;----------------------------------------------------------
		Sleep(1000)
		If $DEBUG Then _FileWriteLog($LOG,"Release DC" & @LF)
		ReleaseDC (0, $DeskDC)
		If $DEBUG Then _FileWriteLog($LOG,"De-alloclating structs" & @LF)
		$FileHead = 0
		$DIBHead = 0
		$bmInfoHeader = 0
		$bmColors = 0
		$bmBitmap = 0
		$bmBits = 0
		$pbuf = 0
		$DeskDC = 0

		If $DEBUG Then _FileWriteLog($LOG,"done." & @LF)
	EndIf
EndFunc   ;==>SaveDib

;----------------------------------------------------------
;UDF Helper Functions
;WinUser.au3
;----------------------------------------------------------

Func GetDC($hWnd)
	Local $hDC = DllCall('user32.dll', 'int', 'GetDC', _
											'hwnd', $hWnd)
	Return $hDC[0]
EndFunc


Func ReleaseDC($hWnd, $hDC)
	Local $bResult = DllCall('user32.dll', 'int', 'ReleaseDC', _
												'hwnd', $hWnd, _
												'hwnd', $hDC)
	Return $bResult[0]
EndFunc
;----------------------------------------------------------
;UDF Helper Functions
;Additional user32.dll functions
;----------------------------------------------------------
Func OpenClipboard($hWnd)
	Local $v_ret = DllCall("user32.dll","int","OpenClipboard","hwnd",$hWnd)
	Return $v_ret[0]
EndFunc

Func CloseClipboard()
	Local $v_ret = DllCall("user32.dll","int","CloseClipboard")
	Return $v_ret[0]
EndFunc

Func IsClipboardFormatAvailable($CB_Format)
	Local $v_ret = DllCall("user32.dll","int","IsClipboardFormatAvailable","int",$CB_Format)
	Return $v_ret[0]
EndFunc

Func GetClipboardData($CB_Format)
	Local $v_ret = DllCall("user32.dll","int","GetClipboardData","int",$CB_Format)
	Return $v_ret[0]
EndFunc
;----------------------------------------------------------
;UDF Helper Functions
;WinGDI.au3
;----------------------------------------------------------

Func GetObject($hObj,$nCount,$ptrObj)
;	Private Declare Function GetObject Lib "GDI32.dll" Alias "GetObjectA" ( ByVal hObject As Long, ByVal nCount As Long, ByRef lpObject As Any) As Long
	Local $v_ret = DllCall('gdi32.dll', 'int','GetObject', _
												'hwnd',$hObj, _
												'int',$nCount, _
												'ptr',$ptrObj)
	Return $v_ret[0]
EndFunc


Func GetDIBits($aHdc,$hBitmap,$nStartScan,$nNumScans,$ptrBits,$ptrBI,$wUsage)
	Local $v_ret =  DLLCall("gdi32.dll","int","GetDIBits", _
									   "int",$aHDC, _
									   "hwnd",$hBitmap, _
									   "int",$nStartScan, _
									   "int",$nNumScans, _
									   "ptr",$ptrBits, _
									   "ptr",$ptrBI, _
									   "int",$wUsage)

	Return $v_ret[0]
EndFunc

Func SelectObject($hDC, $hObj)
	Local $hOldObj = DllCall('gdi32.dll', 'int', 'SelectObject', _
												'hwnd', $hDC, _
												'hwnd', $hObj)
	Return $hOldObj[0]
EndFunc


Func DeleteObject($hObj)
	Local $bResult = DllCall('gdi32.dll', 'int', 'DeleteObject', _
												'hwnd', $hObj)
	Return $bResult[0]
EndFunc

Func CreateCompatibleDC($hDC)
	Local $hCompDC = DllCall('gdi32.dll', 'hwnd', 'CreateCompatibleDC', _
												'hwnd', $hDC)
	Return $hCompDC[0]
EndFunc


Func DeleteDC($hDC)
	Local $bResult = DllCall('gdi32.dll', 'int', 'DeleteDC', _
												'hwnd', $hDC)
	Return $bResult[0]
EndFunc
;----------------------------------------------------------
;UDF Helper Functions
;File.au3
;----------------------------------------------------------
;===============================================================================
;
; Description:      Writes the specified text to a log file.
; Syntax:           _FileWriteLog( $sLogPath, $sLogMsg )
; Parameter(s):     $sLogPath - Path and filename to the log file
;                   $sLogMsg  - Message to be written to the log file
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets:
;                                @error = 1: Error opening specified file
;                                @error = 2: File could not be written to
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          If the text to be appended does NOT end in @CR or @LF then
;                   a DOS linefeed (@CRLF) will be automatically added.
;
;===============================================================================
Func _FileWriteLog($sLogPath, $sLogMsg)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $sDateNow
	Local $sTimeNow
	Local $sMsg
	Local $hOpenFile
	Local $hWriteFile

	$sDateNow = @YEAR & "-" & @MON & "-" & @MDAY
	$sTimeNow = @HOUR & ":" & @MIN & ":" & @SEC
	$sMsg = $sDateNow & " " & $sTimeNow & " : " & $sLogMsg

	$hOpenFile = FileOpen($sLogPath, 1)

	If $hOpenFile = -1 Then
		SetError(1)
		Return 0
	EndIf

	$hWriteFile = FileWriteLine($hOpenFile, $sMsg)

	If $hWriteFile = -1 Then
		SetError(2)
		Return 0
	EndIf

	FileClose($hOpenFile)
	Return 1
EndFunc   ;==>_FileWriteLog
