#include-once
;===============================================================================
;
; Description:      Functions for formatting given text into RTF format
; Requirement(s):   None
; Return Value(s):  On Success - string with Rich-formatted data
; Author(s):        YDY (Lazycat)
; Version:          0.1
; Date:             15.01.2005
;
;===============================================================================

;===============================================================================
;
; Description:      Create empty RTF data block
; Parameter(s):     Default font name
; Return Value(s):  On Success - string with Rich-formatted data
;
;===============================================================================
Func _RTFCreateDocument($sDefFont)
    Local $sDoc = "{\rtf1\ansi\deff0"
    $sDoc = $sDoc & "{\fonttbl{\f0\fnil " & $sDefFont & ";}{\fontplaceholder}}"
    $sDoc = $sDoc & "{\colortbl \red0\green0\blue0;{\colorplaceholder}}"
    $sDoc = $sDoc & "{\placeholder}}"
    Return($sDoc)
EndFunc

;===============================================================================
;
; Description:      Format string with given parameters
; Parameter(s):     
;                   $RTF - previously created RTF data
;                   $sText - text for formatting
;                   $nColor - text color
;                   $iSize - text size
;                   $iFontStyle - font style
;                      1 - Bold
;                      2 - Italic
;                      4 - Underline
;                      8 - Strikeout
;                   $sFont - text font
; Return Value(s):  On Success - string with Rich-formatted data
;
;===============================================================================
Func _RTFAppendString($RTF, $sText, $nColor, $iSize, $iFontStyle, $sFont)
    Local $iFSPos = StringInStr($RTF, "{\fonttbl")
    Local $iFEPos = StringInStr($RTF, "{\fontplaceholder}}")
    Local $sFontBlock = StringMid($RTF, $iFSPos, $iFEPos - $iFSPos)
    Local $iCSPos = StringInStr($RTF, "{\colortbl")  + 10
    Local $iCEPos = StringInStr($RTF, "{\colorplaceholder}}")
    Local $sColorBlock = StringMid($RTF, $iCSPos, $iCEPos - $iCSPos)
    Local $iFontIndex = -1, $iFPos, $sFontStyle = ""
    Local $asColor, $iColIndex, $sFormatted

    ; Lookup font table
    While 1
        $iFontIndex = $iFontIndex + 1
        $iFPos = StringInStr($sFontBlock, "\f" & $iFontIndex)
        If not $iFPos Then 
            $RTF = StringReplace($RTF, "{\fontplaceholder}", "{\f" & $iFontIndex & "\fnil " & $sFont & ";}{\fontplaceholder}")            
            Exitloop
        Endif
        $sFontBlock = StringTrimLeft($sFontBlock, $iFPos)
        While StringLeft($sFontBlock, 1) <> " "
            $sFontBlock = StringTrimLeft($sFontBlock, 1)  
        Wend
        $sFontBlock = StringTrimLeft($sFontBlock, 1)
        If StringLeft($sFontBlock, StringLen($sFont)) == $sFont Then Exitloop
    Wend

    ; Lookup color table
    $asColor = StringSplit($sColorBlock, ";")
    $iColIndex= $asColor[0]-1
    For $iCnt = 1 to $asColor[0] - 1
        If $asColor[$iCnt] = _RTFGetColor($nColor) Then 
            $iColIndex = $iCnt-1
            Exitloop
        Endif
    Next
    If $iColIndex =  $asColor[0]-1 Then
        $RTF = StringReplace($RTF, "{\colorplaceholder}", _RTFGetColor($nColor) & ";{\colorplaceholder}")
    Endif

    ; Construct font style
    If BitAnd($iFontStyle, 1) Then $sFontStyle = $sFontStyle & "\b"
    If BitAnd($iFontStyle, 2) Then $sFontStyle = $sFontStyle & "\i"
    If BitAnd($iFontStyle, 4) Then $sFontStyle = $sFontStyle & "\ul"
    If BitAnd($iFontStyle, 8) Then $sFontStyle = $sFontStyle & "\strike"

    ; Replace special symbols
    $sText = StringReplace($sText, "\", "\\")
    $sText = StringReplace($sText, @CR, "\par")

    ; Construct formatted block
    $sFormatted = "{\f" & $iFontIndex &_
                  "\cf" & $iColIndex &_
                  "\fs" & $iSize * 2 & $sFontStyle &_
                  " " & $sText & "}{\placeholder}"
    $RTF = StringReplace($RTF, "{\placeholder}", $sFormatted)
    Return($RTF)
EndFunc

;===============================================================================
;
; Description:      Return RTF-style formatted color
; Parameter(s):     Color numeric value
; Return Value(s):  RTF-style formatted color
;
;===============================================================================
Func _RTFGetColor($nColor)
    $sRed = BitAnd(BitShift($nColor, 16), 0xff)
    $sGreen = BitAnd(BitShift($nColor, 8), 0xff)
    $sBlue = BitAnd($nColor, 0xff)
    Return("\red" & $sRed & "\green" & $sGreen & "\blue" & $sBlue)
EndFunc