#include-once
#Include <Array.au3>
#Include <File.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <WinAPI.au3>
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiComboBox.au3>
#Include <GuiListBox.au3>



#EndRegion Header
#Region Global Variables and Constants
Global $last_capture
Global $tesseract_temp_path = "C:\"
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_TesseractTempPathSet()
; Description ...:	Sets the location where Tesseract functions temporary store their files.
;						You must have read and write access to this location.
;						The default location is "C:\".
; Syntax.........:	_TesseractTempPathSet($temp_path)
; Parameters ....:	$temp_path	- The path to use for temporary file storage.
;									This path must not contain any spaces (see "Remarks" below).
; Return values .: 	On Success	- Returns 1. 
;                 	On Failure	- Returns 0.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	The current version of Tesseract doesn't support paths with spaces.
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _TesseractTempPathSet($temp_path)

	$tesseract_temp_path = $temp_path
	
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_TesseractScreenCapture()
; Description ...:	Captures text from the screen.
; Syntax.........:	_TesseractScreenCapture($get_last_capture = 0, $delimiter = "", $cleanup = 1, $scale = 2, $left_indent = 0, $top_indent = 0, $right_indent = 0, $bottom_indent = 0, $show_capture = 0)
; Parameters ....:	$get_last_capture	- Retrieve the text of the last capture, rather than
;											performing another capture.  Useful if the text in
;											the window or control hasn't changed since the last capture.
;											0 = do not retrieve the last capture (default)
;											1 = retrieve the last capture
;					$delimiter			- Optional: The string that delimits elements in the text.
;											A string of text will be returned if this isn't provided.
;											An array of delimited text will be returned if this is provided.
;											Eg. Use @CRLF to return the items of a listbox as an array.
;					$cleanup			- Optional: Remove invalid text recognised
;											0 = do not remove invalid text
;											1 = remove invalid text (default)
;					$scale				- Optional: The scaling factor of the screenshot prior to text recognition.
;											Increase this number to improve accuracy.
;											The default is 2.
;					$iLeft		 		- x-Left coordinate
;					$iTop				- y-Top coordinate
;					$iRight				- x-Right coordinate
;					$iBottom			- y-Bottom coordinate
;					$show_capture		- Display screenshot and text captures
;											(for debugging purposes).
;											0 = do not display the screenshot taken (default)
;											1 = display the screenshot taken and exit
; Return values .: 	On Success	- Returns an array of text that was captured. 
;                 	On Failure	- Returns an empty array.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	Use the default values for first time use.  If the text recognition accuracy is low,
;					I suggest setting $show_capture to 1 and rerunning.  If the screenshot of the
;					window or control includes borders or erroneous pixels that may interfere with
;					the text recognition process, then use $left_indent, $top_indent, $right_indent and
;					$bottom_indent to adjust the portion of the screen being captured, to
;					exclude these non-textural elements.
;					If text accuracy is still low, increase the $scale parameter.  In general, the higher
;					the scale the clearer the font and the more accurate the text recognition.
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _TesseractScreenCapture($get_last_capture = 0, $delimiter = "", $cleanup = 1, $scale = 2, $iLeft = 0, $iTop = 0, $iRight = 1, $iBottom = 1, $show_capture = 0)

	Local $tInfo
	dim $aArray, $final_ocr[1], $xyPos_old = -1, $capture_scale = 3
	Local $tSCROLLINFO = DllStructCreate($tagSCROLLINFO)
	DllStructSetData($tSCROLLINFO, "cbSize", DllStructGetSize($tSCROLLINFO))
	DllStructSetData($tSCROLLINFO, "fMask", $SIF_ALL)

	if $last_capture = "" Then

		$last_capture = ObjCreate("Scripting.Dictionary")
	EndIf

	; if last capture is requested, and one exists.
	if $get_last_capture = 1 and $last_capture.item(0) <> "" Then
		
		return $last_capture.item(0)
	EndIf

	$capture_filename = _TempFile($tesseract_temp_path, "~", ".tif")
	$ocr_filename = StringLeft($capture_filename, StringLen($capture_filename) - 4)
	$ocr_filename_and_ext = $ocr_filename & ".txt"

	CaptureToTIFF("", "", "", $capture_filename, $scale, $iLeft , $iTop , $iRight , $iBottom )
	
	ShellExecuteWait(@ProgramFilesDir & "\tesseract\tesseract.exe", $capture_filename & " " & $ocr_filename)

	; If no delimter specified, then return a string
	if StringCompare($delimiter, "") = 0 Then
		
		$final_ocr = FileRead($ocr_filename_and_ext)
	Else
	
		_FileReadToArray($ocr_filename_and_ext, $aArray)
		_ArrayDelete($aArray, 0)

		; Append the recognised text to a final array
		_ArrayConcatenate($final_ocr, $aArray)
	EndIf

	; If the captures are to be displayed
	if $show_capture = 1 Then
	
		GUICreate("Tesseract Screen Capture.  Note: image displayed is not to scale", 640, 480, 0, 0, $WS_SIZEBOX + $WS_SYSMENU)  ; will create a dialog box that when displayed is centered

		GUISetBkColor(0xE0FFFF)

		$Obj1 = ObjCreate("Preview.Preview.1")  
		$Obj1_ctrl = GUICtrlCreateObj($Obj1, 0, 0, 640, 480)
		$Obj1.ShowFile ($capture_filename, 1)

		GUISetState()

		if IsArray($final_ocr) Then
		
			_ArrayDisplay($aArray, "Tesseract Text Capture")
		Else
			
			MsgBox(0, "Tesseract Text Capture", $final_ocr)
		EndIf

		GUIDelete()
	EndIf

	FileDelete($ocr_filename & ".*")

	; Cleanup
	if IsArray($final_ocr) And $cleanup = 1 Then

		; Cleanup the items
		for $final_ocr_num = 1 to (UBound($final_ocr)-1)

			; Remove erroneous characters
			$final_ocr[$final_ocr_num] = StringReplace($final_ocr[$final_ocr_num], ".", "")
			$final_ocr[$final_ocr_num] = StringReplace($final_ocr[$final_ocr_num], "'", "")
			$final_ocr[$final_ocr_num] = StringReplace($final_ocr[$final_ocr_num], ",", "")
			$final_ocr[$final_ocr_num] = StringStripWS($final_ocr[$final_ocr_num], 3)
		Next

		; Remove duplicate and blank items
		for $each in $final_ocr
		
			$found_item = _ArrayFindAll($final_ocr, $each)
			
			; Remove blank items
			if IsArray($found_item) Then
				if StringCompare($final_ocr[$found_item[0]], "") = 0 Then
					
					_ArrayDelete($final_ocr, $found_item[0])
				EndIf
			EndIf

			; Remove duplicate items
			for $found_item_num = 2 to UBound($found_item)
				
				_ArrayDelete($final_ocr, $found_item[$found_item_num-1])
			Next
		Next
	EndIf

	; Store a copy of the capture
	if $last_capture.item(0) = "" Then
			
		$last_capture.item(0) = $final_ocr
	EndIf

	Return $final_ocr
EndFunc


; #FUNCTION# ;===============================================================================
;
; Name...........:	CaptureToTIFF()
; Description ...:	Captures an image of the screen, a window or a control, and saves it to a TIFF file.
; Syntax.........:	CaptureToTIFF($win_title = "", $win_text = "", $ctrl_id = "", $sOutImage = "", $scale = 1, $left_indent = 0, $top_indent = 0, $right_indent = 0, $bottom_indent = 0)
; Parameters ....:	$win_title		- The title of the window to capture an image of.
;					$win_text		- Optional: The text of the window to capture an image of.
;					$ctrl_id		- Optional: The ID of the control to capture an image of.
;										An image of the window will be returned if one isn't provided.
;					$sOutImage		- The filename to store the image in.
;					$scale			- Optional: The scaling factor of the capture.
;					$iLeft		 	- x-Left coordinate
;					$iTop			- y-Top coordinate
;					$iRight			- x-Right coordinate
;					$iBottom		- y-Bottom coordinate
;					$bottom_indent	- A number of pixels to indent the screen capture from the
;										bottom of the window or control.
; Return values .: 	None
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
Func CaptureToTIFF($win_title = "", $win_text = "", $ctrl_id = "", $sOutImage = "", $scale = 1, $iLeft = 0, $iTop = 0, $iRight = 1, $iBottom = 1)

	Local $hWnd, $hwnd2, $hDC, $hBMP, $hImage1, $hGraphic, $CLSID, $tParams, $pParams, $tData, $i = 0, $hImage2, $pos[4]
    Local $Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))
	Local $giTIFColorDepth = 24
	Local $giTIFCompression = $GDIP_EVTCOMPRESSIONNONE

	; If capturing a control
	if StringCompare($ctrl_id, "") <> 0 Then

		$hwnd2 = ControlGetHandle($win_title, $win_text, $ctrl_id)
		$pos[0] = 0
		$pos[1] = 0
		$pos[2] = $iRight - $iLeft
		$pos[3] = $iBottom - $iTop
	Else
		
		; If capturing a window
		if StringCompare($win_title, "") <> 0 Then

			$hwnd2 = WinGetHandle($win_title, $win_text)
			$pos[0] = 0
			$pos[1] = 0
			$pos[2] = $iRight - $iLeft
			$pos[3] = $iBottom - $iTop
		Else
			
			; If capturing the desktop
			$hwnd2 = ""
			$pos[0] = 0
			$pos[1] = 0
			$pos[2] = $iRight - $iLeft
			$pos[3] = $iBottom - $iTop
		EndIf
	EndIf
	
	; Capture an image of the window / control
	if IsHWnd($hwnd2) Then
	
		WinActivate($win_title, $win_text)
		$hBitmap2 = _ScreenCapture_CaptureWnd("", $hwnd2, $iLeft, $iTop, $iRight, $iBottom, False)
	Else
		
		$hBitmap2 = _ScreenCapture_Capture("", $iLeft, $iTop, $iRight, $iBottom, False)
	EndIf

	_GDIPlus_Startup ()
	
	; Convert the image to a bitmap
	$hImage2 = _GDIPlus_BitmapCreateFromHBITMAP ($hBitmap2)

	$hWnd = _WinAPI_GetDesktopWindow()
    $hDC = _WinAPI_GetDC($hWnd)
    $hBMP = _WinAPI_CreateCompatibleBitmap($hDC, $pos[2] * $scale , $pos[3] * $scale)

	_WinAPI_ReleaseDC($hWnd, $hDC)
    $hImage1 = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)
    _GDIPLus_GraphicsDrawImageRect($hGraphic, $hImage2, 0 , 0 , $pos[2] * $scale, $pos[3] * $scale)
	$CLSID = _GDIPlus_EncodersGetCLSID($Ext)

	; Set TIFF parameters
	$tParams = _GDIPlus_ParamInit(2)
	$tData = DllStructCreate("int ColorDepth;int Compression")
	DllStructSetData($tData, "ColorDepth", $giTIFColorDepth)
	DllStructSetData($tData, "Compression", $giTIFCompression)
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "ColorDepth"))
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "Compression"))
	If IsDllStruct($tParams) Then $pParams = DllStructGetPtr($tParams)

	; Save TIFF and cleanup
	_GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID, $pParams)
    _GDIPlus_ImageDispose($hImage1)
    _GDIPlus_ImageDispose($hImage2)
    _GDIPlus_GraphicsDispose ($hGraphic)
    _WinAPI_DeleteObject($hBMP)
    _GDIPlus_Shutdown()
EndFunc
