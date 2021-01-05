#include-once
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1++
; Language:       English
; Description:    Functions that assist with Common Dialogs.
;
; ------------------------------------------------------------------------------
; Color Dialog constants
Global Const $CC_ANYCOLOR = 0x100
Global Const $CC_FULLOPEN = 0x2
Global Const $CC_RGBINIT = 0x1

; Font Dialog constants
Global Const $CF_EFFECTS = 0x100
Global Const $CF_PRINTERFONTS = 0x2
Global Const $CF_SCREENFONTS = 0x1
Global Const $CF_NOSCRIPTSEL = 0x800000
Global Const $CF_INITTOLOGFONTSTRUCT = 0x40
Global Const $DEFAULT_PITCH = 0
Global Const $FF_DONTCARE = 0
Global Const $LOGPIXELSX = 88


;===============================================================================
;
; Description:            _ChooseColor
; Parameter(s):        $i_ReturnType - Optional: determines return type
;                            $i_colorref - Optional: default selected Color
;                            $i_refType - Optional: Type of $i_colorref passed in
; Requirement:            None
; Return Value(s):    Returns COLORREF rgbcolor if $i_refType = 0 (default)
;                            Returns Hex RGB value if $i_refType = 1
;                            Returns Hex BGR Color if $i_refType = 2
;                            if error occurs, @error is set
; User CallTip:        _ChooseColor([$i_ReturnType = 0[, $i_colorref = 0[, $i_refType=0]]]) Creates a Color dialog box that enables the user to select a color. (required: <CommonDialog.au3>)
; Author(s):            Gary Frost (custompcs@charter.net)
; Note(s):                $i_ReturnType = 0 then COLORREF rgbcolor is returned (default)
;                            $i_ReturnType = 1 then Hex BGR Color is returned
;                            $i_ReturnType = 2 Hex RGB Color is returned
;
;                            $i_colorref = 0 (default)
;
;                            $i_refType = 0 then $i_colorref is COLORREF rgbcolor value (default)
;                            $i_refType = 1 then $i_colorref is BGR hex value
;                            $i_refType = 2 then $i_colorref is RGB hex value
;
;===============================================================================
Func _ChooseColor($i_ReturnType = 0, $i_colorref = 0, $i_refType = 0)
;~ typedef struct {
;~     DWORD lStructSize;
;~     HWND hwndOwner;
;~     HWND hInstance;
;~     COLORREF rgbResult;
;~     COLORREF *lpCustColors;
;~     DWORD Flags;
;~     LPARAM lCustData;
;~     LPCCHOOKPROC lpfnHook;
;~     LPCTSTR lpTemplateName;
;~ } CHOOSECOLOR, *LPCHOOSECOLOR;
    
    Local $custcolors = "int[16]"
    Local $struct = "dword;int;int;int;ptr;dword;int;ptr;ptr"
    Local $p = DllStructCreate ($struct)
    If @error Then
    ;MsgBox(0,"","Error in DllStructCreate " & @error);
        SetError(-1)
        Return -1
    EndIf
    Local $cc = DllStructCreate ($custcolors)
    If @error Then
    ; MsgBox(0,"","Error in DllStructCreate " & @error);
        DllStructDelete ($p)
        SetError(-2)
        Return -1
    EndIf
    If ($i_refType == 1) Then
        $i_colorref = Int($i_colorref)
    ElseIf ($i_refType == 2) Then
        $i_colorref = Hex(String($i_colorref), 6)
        $i_colorref = '0x' & StringMid($i_colorref, 5, 2) & StringMid($i_colorref, 3, 2) & StringMid($i_colorref, 1, 2)
    EndIf
    DllStructSetData ($p, 1, DllStructGetSize ($p))
    DllStructSetData ($p, 2, 0)
    DllStructSetData ($p, 4, $i_colorref)
    DllStructSetData ($p, 5, DllStructGetPtr ($cc))
    DllStructSetData ($p, 6, BitOR($CC_ANYCOLOR, $CC_FULLOPEN, $CC_RGBINIT))
    
    Local $ret = DllCall("comdlg32.dll", "long", "ChooseColor", "ptr", DllStructGetPtr ($p))
    If ($ret[0] == 0) Then
    ; user selected cancel or struct settings incorrect
        DllStructDelete ($p)
        DllStructDelete ($cc)
        SetError(-3)
        Return -1
    EndIf
    Local $color_picked = DllStructGetData ($p, 4)
    DllStructDelete ($p)
    DllStructDelete ($cc)
    If ($i_ReturnType == 1) Then
    ; return Hex BGR Color
        Return '0x' & Hex(String($color_picked), 6)
    ElseIf ($i_ReturnType == 2) Then
    ; return Hex RGB Color
        $color_picked = Hex(String($color_picked), 6)
        Return '0x' & StringMid($color_picked, 5, 2) & StringMid($color_picked, 3, 2) & StringMid($color_picked, 1, 2)
    ElseIf ($i_ReturnType == 0) Then
        Return $color_picked
    Else
        SetError(-4)
        Return -1
    EndIf
EndFunc  ;==>_ChooseColor

;===============================================================================
;
; Description:			_ChooseFont
; Parameter(s):		$s_FontName - Optional: Default font name
;							$i_size - Optional: pointsize of font
;							$i_colorref - Optional: COLORREF rgbColors
; Requirement:			None.
; Return Value(s):	Returns Array, $array[0] contains the number of elements
;							if error occurs, @error is set
; User CallTip:		_ChooseFont([$s_FontName = "Courier New"[, $i_size = 10[, $i_colorref = 0]]]) Creates a Font dialog box that enables the user to choose attributes for a logical font. (required: <CommonDialog.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				$array[1] - attributes = BitOr of italic:2, undeline:4, strikeout:8
;							$array[2] - fontname
;							$array[3] - font size = point size
;							$array[4] - font weight = = 0-1000
;							$array[5] - COLORREF rgbColors
;							$array[6] - Hex BGR Color
;							$array[7] - Hex RGB Color
;
;===============================================================================
Func _ChooseFont($s_FontName = "Courier New", $i_size = 10, $i_colorref = 0)
	;~ typedef struct {
	;~     DWORD lStructSize;
	;~     HWND hwndOwner;
	;~     HDC hDC;
	;~     LPLOGFONT lpLogFont;
	;~     INT iPointSize;
	;~     DWORD Flags;
	;~     COLORREF rgbColors;
	;~     LPARAM lCustData;
	;~     LPCFHOOKPROC lpfnHook;
	;~     LPCTSTR lpTemplateName;
	;~     HINSTANCE hInstance;
	;~     LPTSTR lpszStyle;
	;~     WORD nFontType;
	;~     INT nSizeMin;
	;~     INT nSizeMax;
	;~ } CHOOSEFONT, *LPCHOOSEFONT;
		
	;~ typedef struct tagLOGFONT {
	;~   LONG lfHeight;
	;~   LONG lfWidth;
	;~   LONG lfEscapement;
	;~   LONG lfOrientation;
	;~   LONG lfWeight;
	;~   BYTE lfItalic;
	;~   BYTE lfUnderline;
	;~   BYTE lfStrikeOut;
	;~   BYTE lfCharSet;
	;~   BYTE lfOutPrecision;
	;~   BYTE lfClipPrecision;
	;~   BYTE lfQuality;
	;~   BYTE lfPitchAndFamily;
	;~   TCHAR lfFaceName[LF_FACESIZE]; 32 chars max
	;~ } LOGFONT, *PLOGFONT;
	Local $ret = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", 0, "long", $LOGPIXELSX)
	If ($ret[0] == -1) Then
		SetError(-3)
		Return -1
	EndIf
	Local $lfHeight = Round(($i_size * $ret[2]) / 72, 0)
	Local $logfont = "int;int;int;int;int;byte;byte;byte;byte;byte;byte;byte;byte;char[32]"
	Local $struct = "dword;int;int;ptr;int;dword;int;int;ptr;ptr;int;ptr;dword;int;int"
	Local $p = DllStructCreate ($struct)
	If @error Then
		;MsgBox(0,"","Error in DllStructCreate " & @error);
		SetError(-1)
		Return -1
	EndIf
	Local $lf = DllStructCreate ($logfont)
	If @error Then
		; MsgBox(0,"","Error in DllStructCreate " & @error);
		DllStructDelete ($p)
		SetError(-2)
		Return -1
	EndIf
	DllStructSetData ($p, 1, DllStructGetSize ($p))
	DllStructSetData ($p, 2, 0)
	DllStructSetData ($p, 4, DllStructGetPtr ($lf))
	DllStructSetData ($p, 5, $i_size)
	DllStructSetData ($p, 6, BitOR($CF_SCREENFONTS, $CF_PRINTERFONTS, $CF_EFFECTS, $CF_INITTOLOGFONTSTRUCT, $CF_NOSCRIPTSEL))
	DllStructSetData ($p, 7, $i_colorref)
	DllStructSetData ($p, 13, 0)
	DllStructSetData ($lf, 1, $lfHeight + 1)
	DllStructSetData ($lf, 6, 0)
	DllStructSetData ($lf, 7, 0)
	DllStructSetData ($lf, 8, 0)
	DllStructSetData ($lf, 14, $s_FontName)
	$ret = DllCall("comdlg32.dll", "long", "ChooseFont", "ptr", DllStructGetPtr ($p))
	If ($ret[0] == 0) Then
		; user selected cancel or struct settings incorrect
		DllStructDelete ($p)
		DllStructDelete ($lf)
		SetError(-3)
		Return -1
	EndIf
	Local $fontname = DllStructGetData ($lf, 14)
	If (StringLen($fontname) == 0 And StringLen($s_FontName) > 0) Then
		$fontname = $s_FontName
	EndIf
	Local $italic = 0
	Local $underline = 0
	Local $strikeout = 0
	If (DllStructGetData ($lf, 6)) Then
		$italic = 2
	EndIf
	If (DllStructGetData ($lf, 7)) Then
		$underline = 4
	EndIf
	If (DllStructGetData ($lf, 8)) Then
		$strikeout = 8
	EndIf
	Local $attributes = BitOR($italic, $underline, $strikeout)
	Local $size = DllStructGetData ($p, 5) / 10
	Local $weight = DllStructGetData ($lf, 5)
	Local $colorref = DllStructGetData ($p, 7)
	DllStructDelete ($p)
	DllStructDelete ($lf)
	Local $color_picked = Hex(String($colorref), 6)
	Return StringSplit($attributes & "," & $fontname & "," & $size & "," & $weight & "," & $colorref & "," & '0x' & $color_picked & "," & '0x' & StringMid($color_picked, 5, 2) & StringMid($color_picked, 3, 2) & StringMid($color_picked, 1, 2), ",")
EndFunc   ;==>_ChooseFont

;===============================================================================
;
; Function Name:    _Iif()
; Description:      Perform a boolean test within an expression.
; Parameter(s):     $f_Test     - Boolean test.
;                   $v_TrueVal  - Value to return if $f_Test is true.
;                   $v_FalseVal - Value to return if $f_Test is false.
; Requirement(s):   None.
; Return Value(s):  One of $v_TrueVal or $v_FalseVal.
; Author(s):        Dale (Klaatu) Thompson
;
;===============================================================================
Func _Iif($f_Test, $v_TrueVal, $v_FalseVal)
   If $f_Test Then
      Return $v_TrueVal
   Else
      Return $v_FalseVal
   EndIf
EndFunc

