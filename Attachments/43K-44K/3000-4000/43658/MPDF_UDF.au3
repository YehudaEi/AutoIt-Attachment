#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <GDIPlus.au3>
#include <Misc.au3>
#include <File.au3>
#include <String.au3>

; #INDEX# =======================================================================================================================
; Title .........: MIPDF
; AutoIt Version : 3.3.6.1
; Description ...: Generate pdf using just AutoIt functions.
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Version .......: 1.0.3
; Last Rev. .....: August 10, 2011
; ===============================================================================================================================

; #CHANGES# =====================================================================================================================
; 1.0.3		Rewrote _LoadResImage function - optimize for speed (GDI+ stuff)
;			Thanks to xavierh for finding a missing space in the _LoadFontTT function (even it looks insignificant, that solved
;			an issue with text justification when using Adobe Reader)
; -------------------------------------------------------------------------------------------------------------------------------
; 1.0.2		Fixed a bug (a big one) related with objects. Foxit Reader worked well, but Adobe Reader gave some errors. Now both
;			work fine.
;			Added individual page rotation
;			Dennis Sandstrom (aka StuffByDennis) added two more functions (_Draw_Path and _Draw_Polygon)
; -------------------------------------------------------------------------------------------------------------------------------
; 1.0.1		Added more page formats
;			Added two more fonts (Calibri and Garamond)
;			Changed $PDF_PAGE_A4/~ to "a4","letter" etc (it's not case-sensitive)
;			Fixed Txt2PDF function from the example.
;			Added another function for table.
; -------------------------------------------------------------------------------------------------------------------------------
; 1.0.0		Fixed the name af the saved pdf
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _BeginPage
; _ClosePDFFile
; _DrawArc
; _DrawCircle
; _DrawCurve
; _DrawLine
; _DrawText
; _Draw_Path
; _Draw_Polygon
; _Draw_Rectangle
; _EndObject
; _EndPage
; _GetMargin
; _GetPageHeight
; _GetPageWidth
; _GetTextLength
; _GetUnit
; _InitPDF
; _InsertDCube
; _InsertDPie
; _InsertImage
; _InsertRenderedText
; _LineTo
; _LoadFontStandard
; _LoadFontTT
; _LoadResImage
; _MoveTo
; _OpenAfter
; _Pages
; _Paragraph
; _Path
; _Rectangle
; _SetCharSpacing
; _SetColourFill
; _SetColourStroke
; _SetDash
; _SetKeywords
; _SetLayoutMode
; _SetLineCap
; _SetLineJoin
; _SetLineWidth
; _SetMargin
; _SetMiterLimit
; _SetOrientation
; _SetPageHeight
; _SetPageWidth
; _SetPaperSize
; _SetSubject
; _SetTextHorizontalScaling
; _SetTextRenderingMode
; _SetTextRiseMode
; _SetTitle
; _SetUnit
; _SetWordSpacing
; _SetZoomMode
; _StartObject
; ===============================================================================================================================
#region CONSTANTS
Global $PDF_VERSION = "%PDF-1.5" & chr(10) & "%" & ChrW(226) & ChrW(227) & ChrW(207) & ChrW(211)
;Global $PDF_AUTHOR = "Mihai Iancu"
;Global $PDF_CREATOR = "MIPDF"
;Global $PDF_COPYRIGHT = "© 1973-" & @YEAR & " Mihai Iancu"
Global $PDF_AUTHOR = ""
Global $PDF_CREATOR = ""
Global $PDF_COPYRIGHT = ""
Global $PDF_TITLE = ""
Global $PDF_SUBJECT = ""
Global $PDF_KEYWORDS = ""
Global $PDF_NAME = ""

Global Const $PDF_STYLE_NONE = 0x0
Global Const $PDF_STYLE_STROKED = 0x1
Global Const $PDF_STYLE_CLOSED = 0x2
Global Const $PDF_STYLE_FILLED = 0x4

Global Const $PDF_FONT_NORMAL = ""
Global Const $PDF_FONT_BOLD = ",Bold"
Global Const $PDF_FONT_ITALIC = ",Italic"
Global Const $PDF_FONT_BOLDITALIC = ",BoldItalic"

Global $PDF_FONT_STD_HELVETICA = "Helvetica"
Global $PDF_FONT_STD_COURIER = "Courier"
Global $PDF_FONT_STD_SYMBOL = "Symbol"
Global $PDF_FONT_STD_ZAPFDINGBATS = "ZapfDingbats"
Global $PDF_FONT_STD_ARIAL = "Helvetica";looks the same
Global $PDF_FONT_STD_TIMES = "Times Roman"

Global $PDF_FONT_COURIER = $PDF_FONT_STD_COURIER & " New"
Global $PDF_FONT_ARIAL = $PDF_FONT_STD_ARIAL
Global $PDF_FONT_TIMES = "Times New Roman"
Global $PDF_FONT_SYMBOL = $PDF_FONT_STD_SYMBOL
Global $PDF_FONT_CALIBRI = "Calibri"
Global $PDF_FONT_GARAMOND = "Garamond"

Global Const $PDF_ALIGN_LEFT = 1
Global Const $PDF_ALIGN_RIGHT = 2
Global Const $PDF_ALIGN_CENTER = 3

Global Const $PDF_UNIT_PT = 1
Global Const $PDF_UNIT_INCH = 2
Global Const $PDF_UNIT_MM = 4
Global Const $PDF_UNIT_CM = 8

Global Const $PDF_ZOOM_FULLPAGE = 0
Global Const $PDF_ZOOM_FULLWIDTH = 1
Global Const $PDF_ZOOM_REAL = 2
Global Const $PDF_ZOOM_DEFAULT = 4
Global Const $PDF_ZOOM_CUSTOM = 8

Global Const $PDF_LAYOUT_SINGLE = 0
Global Const $PDF_LAYOUT_CONTINOUS = 1
Global Const $PDF_LAYOUT_TWO = 2
Global Const $PDF_LAYOUT_DEFAULT = 4

Global Const $PDF_ORIENTATION_PORTRAIT = 0
Global Const $PDF_ORIENTATION_LANDSCAPE = 1

Global $PDF_OBJECT_NAME = ""
Global $PDF_OBJECT_OPTIONS = ""
Global Const $PDF_OBJECT_NONE = 0
Global Const $PDF_OBJECT_FIRSTPAGE = 0x1
Global Const $PDF_OBJECT_EVENPAGES = 0x2
Global Const $PDF_OBJECT_ODDPAGES = 0x4
Global Const $PDF_OBJECT_NOTFIRSTPAGE = 0x8
Global Const $PDF_OBJECT_ALLPAGES = BitAND($PDF_OBJECT_EVENPAGES, $PDF_OBJECT_ODDPAGES, $PDF_OBJECT_FIRSTPAGE)

Global $BaseFont
Global $FirstChar
Global $LastChar
Global $Param
Global $MissingWidth
Global $Widths[256]
Global $__SetUnit
Global $_PaperSize = "A4"
Global $_Orientation = $PDF_ORIENTATION_PORTRAIT
Global $__SetMargin = 0
Global $_Pages = 0
Global $_CharSpacing
Global $_WordSpacing
Global $_TextScaling
Global $_PageWidth
Global $_PageHeight
Global $_FileName
Global $_Offset = 0
Global $_Font = ""
Global $_ZoomMode
Global $_LayoutMode
Global $_sPage=" "
Global $_sFONT
Global $_sFONTNAME
Global $_Image=""
Global $_sObject
Global $_iResource
Global $_iPages
Global $_iObject = 0
Global $_iMaxObject
Global $_iTmpOffset
Global $_iImageW
Global $_iImageH
Global $_Buffer = ""
Global $_bOpen = False

Global $aXREF[1000]
Global $aOBJECTS[2] = [$PDF_OBJECT_NAME, $PDF_OBJECT_OPTIONS]
#endregion CONSTANTS
#region FUNCTIONS
; #FUNCTION# ====================================================================================================================
; Name ..........: _BeginPage
; Description ...: Begin a new page
; Syntax ........: _BeginPage( [ $iRotate ] )
; Parameters ....: $iRotate             - [optional]  multiple of 90 (default = 0).
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......: July 05, 2011
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _BeginPage($iRotate=0)
	Local $intPage
	If BitAND($iRotate<>0, Mod($iRotate,90)<>0, $iRotate<>"") Then
		MsgBox(48, "Error", "When seting rotation of the page, it has to be multiple of 90 or 0!"&chr(10)&"Try again.",3)
		Exit
	EndIf
	$_Pages += 1
	$intPage = __InitObj()
	__ToBuffer("<</Type /Page /Parent 3 0 R /Contents " & $intPage + 1 & " 0 R /Rotate "&$iRotate&">>")
	__EndObj()
	$_sPage &= $intPage & " 0 R "
	__InitObj($intPage + 1)
	__ToBuffer("<<"&chr(10)&"/Length >>stream")
	$_iTmpOffset = $_Offset
	__InsertObjectOnPage()
	$_CharSpacing = 0
	$_WordSpacing = 0
	$_TextScaling = 100
	Return $_Pages
EndFunc   ;==>_BeginPage

; #FUNCTION# ====================================================================================================================
; Name ..........: _ClosePDFFile
; Description ...: Write the buffer to the pdf
; Syntax ........: _ClosePDFFile(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......: _InitPDF()
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _ClosePDFFile()
	$_iResource = __InitObj(4)
	__ToBuffer("<<" & _
			_Iif($_sFONT <> "", "/Font<<" & $_sFONT & ">>", "") & _
			"/ProcSet [/PDF/Text" & _Iif($_Image <> "", "/ImageB/ImageC/ImageI", "") & "]" & _
			_Iif(($_Image <> "") Or ($_sObject <> ""), "/XObject <<" & $_Image & $_sObject & ">>", "") & ">>")
	__EndObj()
	$_iPages = __InitObj(3)
	__ToBuffer("<</Type /Pages /Count " & $_Pages & " /MediaBox [0 0 " & __ToStr($_PageWidth,1) & " " & __ToStr($_PageHeight,1) & "] " & _
			"/CropBox [" & __ToStr($__SetMargin) & " " & __ToStr($__SetMargin) & " " & __ToStr($_PageWidth - $__SetMargin,1) & " " & __ToStr($_PageHeight - $__SetMargin,1) & "] " & _
			_Iif($_Orientation = $PDF_ORIENTATION_LANDSCAPE, "/Rotate -90", "") & "/Kids [" & $_sPage & "] " & "/Resources " & $_iResource & " 0 R>>")
	__EndObj()
	dim $position_xref=stringlen($_Buffer)
	__ToBuffer("xref")
	__ToBuffer("0 " & $_iMaxObject+1)
	__ToBuffer("0000000000 65535 f"&chr(13))
	For $i = 1 To $_iMaxObject
		__ToBuffer($aXREF[$i]&chr(13))
	Next
	__ToBuffer("trailer" & chr(10) & _
			"<<	/Size " & $_iMaxObject + 1 & "/Info 1 0 R" & "/Root 2 0 R" & ">>")
	__ToBuffer("startxref" & chr(10) & $position_xref & chr(10) & "%%EOF")
	$_FileName = FileOpen($PDF_NAME,18)
	FileWrite($_FileName, $_Buffer)
	FileClose($_FileName)
	$_Pages = ""
	$_sPage = ""
	$_sFONT = ""
	$_Image = ""
	$_sObject = ""
	$_iResource = ""
	$_Buffer = ""	
	If $_bOpen Then ShellExecute($PDF_NAME)
EndFunc   ;==>_ClosePDFFile

; #FUNCTION# ====================================================================================================================
; Name ..........: _Draw_Path
; Description ...: Draws a N segmented line, each line segment is expressed as N repeating sub segments.
;					Each sub segment has its own "PEN DOWN" length, color and cap type followed by a "PEN UP" length
; Syntax ........: _Draw_Path( ByRef Const $iXY, ByRef Const $iDU )
; Parameters ....: $iXY is a 2 dimensional array where:
;						$iXY[0][0] contains the number of points in the path
;						$iXY[0][1] contains the coordinate type 0 = absolute to 0,0 of page, 1=relative to previous coordinate
;						$iXY[N][0] X or distance from left of page or previous point
;						$iXY[N][1] Y or distance from bottom of page or previous point
;                : $iDU is a 1 or 2 dimensional array where:
;						for a solid line $iDU[0]= Line width
;                                        $iDU[1]= Line cap type
;                                        $iDU[2]= Line color
;						for a "DASHED" line $iDU[0][0]= number of sub segments before repeating
;						                    $iDU[N][0]= Number of "PEN DOWN" units for the Nth sub segment
;						                    $iDU[N][1]= Line width for the Nth sub segment
;						                    $iDU[N][2]= Line cap type for the Nth sub segment
;						                    $iDU[N][3]= Line color for the Nth sub segment
;						                    $iDU[N][4]= Number of "PEN UP" units for the Nth sub segment
; Return values .: None
; Author(s) .....: StuffByDennis
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Draw_Path(ByRef Const $iXY, ByRef Const $iDU)
	Local $i, $j, $X, $Y, $X0, $X1, $Y0, $Y1, $ODX, $ODY, $DX, $DY, $Theta, $SIN, $COS
	_SetDash(0)
	$X0 = 0
	$Y0 = 0
	If UBound($iDU, 0) = 1 Then
		_SetLineCap($iDU[1])
		_SetLineWidth($iDU[0])
		_SetColourStroke($iDU[2])
		For $i = 1 To $iXY[0][0] - 1
			If $iXY[0][1] = 0 Then
				$X0 = $iXY[$i][0]
				$Y0 = $iXY[$i][1]
				$X1 = $iXY[$i + 1][0]
				$Y1 = $iXY[$i + 1][1]
			Else
				$X0 += $iXY[$i][0]
				$Y0 += $iXY[$i][1]
				$X1 = $X0 + $iXY[$i + 1][0]
				$Y1 = $Y0 + $iXY[$i + 1][1]
			EndIf
			_MoveTo($X0, $Y0)
			_LineTo($X1, $Y1, $PDF_STYLE_STROKED)
		Next
	Else
		For $i = 1 To $iXY[0][0] - 1
			If $iXY[0][1] = 0 Then
				$X0 = $iXY[$i][0]
				$Y0 = $iXY[$i][1]
				$X1 = $iXY[$i + 1][0]
				$Y1 = $iXY[$i + 1][1]
			Else
				$X0 += $iXY[$i][0]
				$Y0 += $iXY[$i][1]
				$X1 = $X0 + $iXY[$i + 1][0]
				$Y1 = $Y0 + $iXY[$i + 1][1]
			EndIf

			$ODX = $X1 - $X0
			$ODY = $Y1 - $Y0
			$X = $X0
			$Y = $Y0
			If $ODX <> 0 And $ODY <> 0 Then
				$Theta = ATan($ODY / $ODX)
				$SIN = -Sin($Theta)
				$COS = -Cos($Theta)
			EndIf
			$j = 1
			Select
				Case $ODY = 0 ; Horizontal
					Select
						Case $ODX < 0;Due-West
							While $X > $X1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y0)
								$X -= $iDU[$j][0]
								If $X < $X1 Then $X = $X1
								_LineTo($X, $Y1, $PDF_STYLE_STROKED)
								$X -= $iDU[$j][4]
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
						Case Else ;Due-East
							While $X < $X1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y0)
								$X += $iDU[$j][0]
								If $X > $X1 Then $X = $X1
								_LineTo($X, $Y1, $PDF_STYLE_STROKED)
								$X += $iDU[$j][4]
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
					EndSelect
				Case $ODY > 0 ; North
					Select
						Case $ODX = 0 ;Due North
							While $Y < $Y1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y)
								$Y += $iDU[$j][0]
								If $Y > $Y1 Then $Y = $Y1
								_LineTo($X, $Y, $PDF_STYLE_STROKED)
								$Y += $iDU[$j][4]
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
						Case $ODX < 0;North-West
							While $Y < $Y1 And $X > $X1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y)
								$DX = -$iDU[$j][0] * $COS
								If $X - $DX < $X1 Then $X = $X1 + $DX
								$DY = $iDU[$j][0] * $SIN
								If $Y + $DY > $Y1 Then $Y = $Y1 - $DY
								_LineTo($X - $DX, $Y + $DY, $PDF_STYLE_STROKED)
								$X = $X - $DX + $iDU[$j][4] * $COS
								$Y = $Y + $DY + $iDU[$j][4] * $SIN
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
						Case Else;North-East
							While $Y < $Y1 And $X < $X1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y)
								$DX = -$iDU[$j][0] * $COS
								If $X + $DX > $X1 Then $X = $X1 - $DX
								$DY = -$iDU[$j][0] * $SIN
								If $Y + $DY > $Y1 Then $Y = $Y1 - $DY
								_LineTo($X + $DX, $Y + $DY, $PDF_STYLE_STROKED)
								$X += $DX - $iDU[$j][4] * $COS
								$Y += $DY - $iDU[$j][4] * $SIN
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
					EndSelect
				Case Else ; South
					Select
						Case $ODX = 0;Due South
							While $Y > $Y1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y)
								$Y -= $iDU[$j][0]
								If $Y < $Y1 Then $Y = $Y1
								_LineTo($X, $Y, $PDF_STYLE_STROKED)
								$Y -= $iDU[$j][4]
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
						Case $ODX > 0;South-East
							While $Y > $Y1 And $X < $X1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y)
								$DX = -$iDU[$j][0] * $COS
								If $X + $DX > $X1 Then $X = $X1 - $DX
								$DY = $iDU[$j][0] * $SIN
								If $Y - $DY < $Y1 Then $Y = $Y1 + $DY
								_LineTo($X + $DX, $Y - $DY, $PDF_STYLE_STROKED)
								$X = $X + $DX - $iDU[$j][4] * $COS
								$Y = $Y - $DY - $iDU[$j][4] * $SIN
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
						Case Else ; South-West
							While $Y > $Y1 And $X > $X1
								_SetLineCap($iDU[$j][2])
								_SetLineWidth($iDU[$j][1])
								_SetColourStroke($iDU[$j][3])
								_MoveTo($X, $Y)
								$DX = -$iDU[$j][0] * $COS
								If $X - $DX < $X1 Then $X = $X1 + $DX
								$DY = -$iDU[$j][0] * $SIN
								If $Y - $DY < $Y1 Then $Y = $Y1 + $DY
								_LineTo($X - $DX, $Y - $DY, $PDF_STYLE_STROKED)
								$X = $X - $DX + $iDU[$j][4] * $COS
								$Y = $Y - $DY + $iDU[$j][4] * $SIN
								$j += 1
								If $j > $iDU[0][0] Then $j = 1
							WEnd
					EndSelect
			EndSelect
		Next
	EndIf
	_SetLineCap(0)
	_SetLineWidth(0)
	_SetColourStroke(0)
EndFunc   ;==>_Draw_Path
; #FUNCTION# ====================================================================================================================
; Name ..........: _Draw_Polygon
; Description ...: Draws a N sided filled polygon
;                  The perimiter is drawn by the _Draw_Path function.
; Syntax ........: _Draw_Polygon( ByRef Const $iXY, $iFC, ByRef Const $iDU )
; Parameters ....: $iXY (See _Draw_Path for description)
;                : $iFC polygon fill color
;                : $iDU (See _Draw_Path for description)
; Return values .: None
; Author(s) .....: StuffByDennis
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Draw_Polygon(ByRef Const $iXY, $fillColor, $iDU)
	Local $i, $X0, $Y0
	_SetLineWidth(0)
	_SetColourFill($fillColor)
	__ToBuffer("n")
	$X0 = $iXY[1][0]
	$Y0 = $iXY[1][1]
	_MoveTo($X0, $Y0)
	For $i = 2 To $iXY[0][0]
		If $iXY[0][1] = 0 Then
			$X0 = $iXY[$i][0]
			$Y0 = $iXY[$i][1]
		Else
			$X0 += $iXY[$i][0]
			$Y0 += $iXY[$i][1]
		EndIf
		_LineTo($X0, $Y0, $PDF_STYLE_NONE)
	Next
	_Path($PDF_STYLE_STROKED)
	_SetLineWidth(0)
	If $iDU[1][0] = 0 Then Return
	_Draw_Path($iXY, $iDU)
EndFunc   ;==>_Draw_Polygon

; #FUNCTION# ====================================================================================================================
; Name ..........: _Draw_Rectangle
; Description ...: Draw _Rectangle
; Syntax ........: _Draw_Rectangle( $iX , $iY , $iW , $iH [, $sStyle [, $iRadius [, $lFillColour [,
;                  $iBorderWidth ]]]] )
; Parameters ....: $iX                  -  integer value.
;                  $iY                  -  integer value.
;                  $iW                  -  integer value.
;                  $iH                  -  integer value.
;                  $sStyle              - [optional]  string value.
;                  $iRadius                - [optional]  integer value.
;                  $iFillColour         - [optional]  RGB value.
;                  $iBorderWidth        - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _Draw_Rectangle($iX, $iY, $iW, $iH, $sStyle = $PDF_STYLE_STROKED, $iRadius = 0, $iFillColour = 0, $iBorderWidth = 0.05)
	_SetLineWidth($iBorderWidth)
	_SetColourFill($iFillColour)
	_Rectangle($iX, $iY, $iW, $iH, $sStyle, $iRadius)
	_SetColourFill(0)
	_SetLineWidth(0)
EndFunc   ;==>_Draw_Rectangle

; #FUNCTION# ====================================================================================================================
; Name ..........: _DrawCircle
; Description ...: Draw circle
; Syntax ........: _DrawCircle( $x , $y , $iRadius [, $sStyle = $PDF_STYLE_STROKED ] )
; Parameters ....: $x                   -  unknown value.
;                  $y                   -  unknown value.
;                  $iRadius                 -  unknown value.
;                  $sStyle              - [optional]  string value.
;                  $PDF_STYLE_STROKED   -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _DrawCircle($x, $y, $iRadius, $sStyle = $PDF_STYLE_STROKED)
	_MoveTo($x, $y - $iRadius)
	__Curve($x + 0.55 * $iRadius, $y - $iRadius, $x + $iRadius, $y - 0.55 * $iRadius, $x + $iRadius, $y, $PDF_STYLE_NONE)
	__Curve($x + $iRadius, $y + 0.55 * $iRadius, $x + 0.55 * $iRadius, $y + $iRadius, $x, $y + $iRadius, $PDF_STYLE_NONE)
	__Curve($x - 0.55 * $iRadius, $y + $iRadius, $x - $iRadius, $y + 0.55 * $iRadius, $x - $iRadius, $y, $PDF_STYLE_NONE)
	__Curve($x - $iRadius, $y - 0.55 * $iRadius, $x - 0.55 * $iRadius, $y - $iRadius, $x, $y - $iRadius, $PDF_STYLE_NONE)
	_Path($sStyle)
EndFunc   ;==>_DrawCircle

; #FUNCTION# ====================================================================================================================
; Name ..........: _DrawCurve
; Description ...: Draw a curved line
; Syntax ........: _DrawCurve( $iX , $iY , $iX1 , $iY1 , $iX2 , $iY2 , $iX3 , $iY3 [, $lStyle , $PDF_STYLE_STROKED [, $iDash1 [,
;                  $iDash2 ]]] )
; Parameters ....: $iX1                 -  X value of the first point.
;                  $iY1                 -  Y value of the first point.
;                  $iX2                 -  X value of the second point.
;                  $iY2                 -  Y value of the second point.
;                  $iX3                 -  X value of the third point.
;                  $iY3                 -  Y value of the third point.
;                  $iX4                 -  X value of the fourth point.
;                  $iY4                 -  Y value of the fourth point.
;                  $lStyle              - [optional]  style of the line (default = STROKED)
;                  $iDash1              - [optional]  integer value.
;                  $iDash2              - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _DrawCurve($iX1, $iY1, $iX2, $iY2, $iX3, $iY3, $iX4, $iY4, $lStyle = $PDF_STYLE_STROKED, $iDash1 = 0, $iDash2 = 0)
	If $iDash1 = 0 And $iDash2 = 0 Then
		_SetDash(0)
	Else
		_SetDash($iDash1, $iDash2)
	EndIf
	_MoveTo($iX1, $iY1)
	__Curve($iX2, $iY2, $iX3, $iY3, $iX4, $iY4, $lStyle)
	_SetDash(0)
EndFunc   ;==>_DrawCurve

; #FUNCTION# ====================================================================================================================
; Name ..........: _DrawLine
; Description ...: Draw a line
; Syntax ........: _DrawLine( $iXStart , $iYStart , $iXEnd , $iYEnd [, $sStyle , $PDF_STYLE_STROKED [, $iLineCap [,
;                  $iLineWidth [, $lColourStroke [, $iDash1 [, $iDash2 ]]]]]] )
; Parameters ....: $iXStart             -  integer value.
;                  $iYStart             -  integer value.
;                  $iXEnd               -  integer value.
;                  $iYEnd               -  integer value.
;                  $sStyle              - [optional]  string value (default = STROKED).
;                  $iLineCap            - [optional]  integer value.
;                  $iLineWidth          - [optional]  integer value.
;                  $lColourStroke       - [optional]  unknown value.
;                  $iDash1              - [optional]  integer value.
;                  $iDash2              - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _DrawLine($iXStart, $iYStart, $iXEnd, $iYEnd, $sStyle = $PDF_STYLE_STROKED, $iLineCap = 1, $iLineWidth = 0.05, $lColourStroke = 0x000000, $iDash1 = 0, $iDash2 = 0)
	If $iDash1 = 0 And $iDash2 = 0 Then
		_SetDash(0)
	Else
		_SetDash($iDash1, $iDash2)
	EndIf
	_SetLineCap($iLineCap)
	_SetLineWidth($iLineWidth)
	_SetColourStroke($lColourStroke)
	_MoveTo($iXStart, $iYStart)
	_LineTo($iXEnd, $iYEnd, $sStyle)
	_SetLineCap(0)
	_SetLineWidth(0)
	_SetColourStroke(0)
	_SetDash(0)
EndFunc   ;==>_DrawLine

; #FUNCTION# ====================================================================================================================
; Name ..........: _DrawText
; Description ...: Write text
; Syntax ........: _DrawText( $iX , $iY , $sText , $sFontAlias , $iFontSize [, $iAlign , $PDF_ALIGN_LEFT [, $iRotate ]] )
; Parameters ....: $iX                  -  integer value.
;                  $iY                  -  integer value.
;                  $sText               -  string value.
;                  $sFontAlias          -  string value.
;                  $iFontSize           -  integer value.
;                  $iAlign              - [optional]  integer value.
;                  $PDF_ALIGN_LEFT      -  unknown value.
;                  $iRotate             - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _DrawText($iX, $iY, $sText, $sFontAlias, $iFontSize, $iAlign = $PDF_ALIGN_LEFT, $iRotate = 0)
	Local $PI
	Local $sTeta
	Local $cTeta
	Local $C
	Local $l
	Switch $iAlign
		Case $PDF_ALIGN_LEFT
		Case $PDF_ALIGN_RIGHT
			$l = _GetTextLength($sText, $sFontAlias, $iFontSize)
			$iX -= $l
		Case $PDF_ALIGN_CENTER
			$l = _GetTextLength($sText, $sFontAlias, $iFontSize)
			$iX -= $l / 2
	EndSwitch
	__ToBuffer("BT")
	__ToBuffer("/" & $sFontAlias & " " & __ToStr($iFontSize) & " Tf")
	If $iRotate <> 0 Then
		$PI = 3.141592
		$C = $PI / 180
		$sTeta = Sin($C * $iRotate)
		$cTeta = Cos($C * $iRotate)
		__ToBuffer(__ToStr($cTeta) & " " & __ToStr($sTeta) & " " & __ToStr(-$sTeta) & " " & __ToStr($cTeta) & " " & __ToStr(__ToSpace($iX)) & " " & __ToStr(__ToSpace($iY)) & " Tm")
	Else
		__ToBuffer(__ToStr(__ToSpace($iX)) & " " & __ToStr(__ToSpace($iY)) & " Td")
	EndIf
	__ToBuffer("(" & __ToPdfStr($sText) & ") Tj")
	__ToBuffer("ET")
EndFunc   ;==>_DrawText

; #FUNCTION# ====================================================================================================================
; Name ..........: _EndObject
; Description ...: End editing the current object
; Syntax ........: _EndObject(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......: _StartObject()
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _EndObject()
	$_iTmpOffset = $_Offset - $_iTmpOffset
	__ToBuffer("endstream")
	__EndObj()
	dim $aArray1=_StringBetween($_Buffer,"/Length >>stream","endstream")
	dim $stringlen
	for $i=0 to ubound($aArray1)-1
		$stringlen=$stringlen+stringlen($aArray1[$i])
	next
	$_Buffer=StringReplace($_Buffer,"/Length >>stream","/Length "&$stringlen-1&">>stream")	
	__InitObj()
	__ToBuffer($_iTmpOffset)
	__EndObj()
EndFunc   ;==>_EndObject

; #FUNCTION# ====================================================================================================================
; Name ..........: _EndPage
; Description ...: End the currend page
; Syntax ........: _EndPage(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......: _BeginPage()
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _EndPage()
	$_iTmpOffset = $_Offset - $_iTmpOffset
	__ToBuffer("endstream")
	__EndObj()
	dim $aArray1=_StringBetween($_Buffer,"/Length >>stream","endstream")
	dim $stringlen
	for $i=0 to ubound($aArray1)-1
		$stringlen=$stringlen+stringlen($aArray1[$i])
	next
	$_Buffer=StringReplace($_Buffer,"/Length >>stream","/Length "&$stringlen-1&">>stream")
; Scrie dimensiunea
	__InitObj()
	__ToBuffer($_iTmpOffset)
	__EndObj()
EndFunc   ;==>_EndPage

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetMargin
; Description ...: Get the working area's margin
; Syntax ........: _GetMargin(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _GetMargin()
	Return $__SetMargin
EndFunc   ;==>_GetMargin

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetPageHeight
; Description ...: Get the height of the page
; Syntax ........: _GetPageHeight(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _GetPageHeight()
	Return $_PageHeight
EndFunc   ;==>_GetPageHeight

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetPageWidth
; Description ...: Get the width of the page
; Syntax ........: _GetPageWidth(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _GetPageWidth()
	Return $_PageWidth
EndFunc   ;==>_GetPageWidth

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetTextLength
; Description ...: Get the length of a string
; Syntax ........: _GetTextLength( $sText , $sFontAlias , $iFontSize  )
; Parameters ....: $sText               -  string value.
;                  $sFontAlias          -  string value.
;                  $iFontSize           -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _GetTextLength($sText, $sFontAlias, $iFontSize)
	Local $k = StringInStr($_sFONTNAME, "<" & $sFontAlias & ">")
	Local $C
	Local $l = StringLen($sText)
	Local $j = 0
	If $k > 0 Then
		$k += StringLen($sFontAlias) + 2
		For $i = 1 To $l
			$C = Asc(StringMid($sText, $i, 1))
			$k += _Iif(($C >= $FirstChar) And ($C <= $LastChar), $Widths[$C], $MissingWidth)
			If $C = 32 Then $j += 1
		Next
	EndIf
	Return __ToUser((($k * $iFontSize / 1000) + ($j * $_WordSpacing) + ($l * $_CharSpacing)) * ($_TextScaling / 100))
EndFunc   ;==>_GetTextLength

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetUnit
; Description ...: Get the unit used
; Syntax ........: _GetUnit(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _GetUnit()
	Local $lRet
	Switch $__SetUnit
		Case $PDF_UNIT_PT
			$lRet = 1
		Case $PDF_UNIT_INCH
			$lRet = 72
		Case $PDF_UNIT_CM
			$lRet = 72 / 2.54
		Case $PDF_UNIT_MM
			$lRet = 72 / 25.4
	EndSwitch
	Return $lRet
EndFunc   ;==>_GetUnit

; #FUNCTION# ====================================================================================================================
; Name ..........: _InitPDF
; Description ...: Initialize the pdf
; Syntax ........: _InitPDF( [$sFileName] )
; Parameters ....: $sFileName           - [optional]  string value.
;                  $PDF_NAME            -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _InitPDF($sFileName = "")
	__ToBuffer($PDF_VERSION)
	$_iMaxObject = 0
	__InitObj(1)
	__ToBuffer("<</Title(" & __ToPdfStr($PDF_TITLE) & ")/Author(" & __ToPdfStr($PDF_AUTHOR) & ")/Creator(" & __ToPdfStr($PDF_CREATOR) & ")/Producer(" & __ToPdfStr($PDF_COPYRIGHT) & ") /Keywords(" & __ToPdfStr($PDF_KEYWORDS) & ")/Subject(" & __ToPdfStr($PDF_SUBJECT) & ")/CreationDate(D:" & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & "+02'00')/ModDate()>>")
	__EndObj()
	__InitObj(2)
	__ToBuffer("<</Type/Catalog/Pages 3 0 R")
	Switch $_LayoutMode
		Case $PDF_LAYOUT_SINGLE
			__ToBuffer("/PageLayout /SinglePage")
		Case $PDF_LAYOUT_CONTINOUS
			__ToBuffer("/PageLayout /OneColumn")
		Case $PDF_LAYOUT_TWO
			__ToBuffer("/PageLayout /TwoColumnLeft")
	EndSwitch
	Switch $_ZoomMode
		Case $PDF_ZOOM_FULLPAGE
			__ToBuffer("/OpenAction [1 0 R /Fit]")
		Case $PDF_ZOOM_FULLWIDTH
			__ToBuffer("/OpenAction [1 0 R null /FitH]")
		Case $PDF_ZOOM_REAL
			__ToBuffer("/OpenAction [1 0 R /XYZ null " & $_PageHeight & " 1]")
		Case Int($_ZoomMode)
			__ToBuffer("/OpenAction [1 0 R /XYZ null " & $_PageHeight & " " & StringReplace(StringFormat($_ZoomMode, "###0." & 2), ",", ".") / 100 & "]")
	EndSwitch
	__ToBuffer("/PageMode/UseNone/Lang (en) >>")
	__EndObj()
	$_iMaxObject = 4;4;VERIFICA AICIIIIIIIIIIIIIIIIIIIII
	$PDF_NAME = $sFileName
EndFunc   ;==>_InitPDF

; #FUNCTION# ====================================================================================================================
; Name ..........: _Insert3DCube
; Description ...: Insert a 3D shape
; Syntax ........: _Insert3DCube( $iX , $iY , $iW , $iH [, $iEndColour [, $fDepth [, $iRadius [, $iBorderWidth ]]]] )
; Parameters ....: $iX                  -  integer value.
;                  $iY                  -  integer value.
;                  $iW                  -  integer value.
;                  $iH                  -  integer value.
;                  $iEndColour          - [optional]  integer value.
;                  $fDepth              - [optional]  boolean value.
;                  $iRadius                - [optional]  integer value.
;                  $iBorderWidth        - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _Insert3DCube($iX, $iY, $iW, $iH, $iEndColour = 0x0000ff, $fDepth = 0.5, $iRadius = 0.1, $iBorderWidth = 0.02)
	Local $Ri, $Rf, $Rs, $Gi, $Gf, $Gs, $Bi, $Bf, $Bs, $m = $fDepth
	Local $lFillColour = 0x000000
	$Bi = Mod($lFillColour, 256)
	$Gi = BitAND($lFillColour / 256, 255)
	$Ri = BitAND($lFillColour / 65536, 255)
	$Bf = Mod($iEndColour, 256)
	$Gf = BitAND($iEndColour / 256, 255)
	$Rf = BitAND($iEndColour / 65536, 255)
	$Bs = Abs($Ri - $Rf) / $m
	$Gs = Abs($Gi - $Gf) / $m
	$Rs = Abs($Bi - $Bf) / $m
	If $Rf < $Ri Then $Rs = -$Rs
	If $Gf < $Gi Then $Gs = -$Gs
	If $Bf < $Bi Then $Bs = -$Bs
	For $i = 0 To $fDepth Step 0.02
		$Rf = $Ri + $Rs * $i
		$Gf = $Gi + $Gs * $i
		$Bf = $Bi + $Bs * $i
		Local $lFillColour2 = Dec(Hex($Bf, 2) & Hex($Gf, 2) & Hex($Rf, 2))
		_SetColourStroke($lFillColour2)
		_SetColourFill($lFillColour2)
		_SetLineWidth($iBorderWidth)
		_Rectangle($iX + $fDepth - $i, $iY + $fDepth - $i, $iW, $iH, $PDF_STYLE_FILLED, $iRadius)
		_SetColourFill(0)
		_SetColourStroke(0)
		_SetLineWidth(0)
	Next
EndFunc   ;==>_Insert3DCube

; #FUNCTION# ====================================================================================================================
; Name ..........: _Insert3DPie
; Description ...: Draw a pie
; Syntax ........: _Insert3DPie( $iX , $iY [, $iRadius [, $iStartAngle [, $iEndAngle [, $iEndColour [, $fDepth [, $iRatio [,
;                  $bPie [, $iRotate [, $iQuality [, $sStyle , $PDF_STYLE_FILLED [, $iBorderWidth ]]]]]]]]]]] )
; Parameters ....: $iX                  -  integer value.
;                  $iY                  -  integer value.
;                  $iRadius                - [optional]  integer value.
;                  $iStartAngle         - [optional]  integer value.
;                  $iEndAngle           - [optional]  integer value.
;                  $iEndColour          - [optional]  integer value.
;                  $fDepth              - [optional]  boolean value.
;                  $iRatio              - [optional]  integer value.
;                  $bPie                - [optional]  binary value.
;                  $iRotate             - [optional]  integer value.
;                  $iQuality            - [optional]  integer value.
;                  $sStyle              - [optional]  string value.
;                  $iBorderWidth        - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _Insert3DPie($iX, $iY, $iRadius = 2.5, $iStartAngle = 0, $iEndAngle = 360, $iEndColour = 0x888888, $fDepth = 0.2, $iRatio = 1, $bPie = True, $iRotate = 0, $iQuality = 1, $sStyle = $PDF_STYLE_FILLED, $iBorderWidth = 0.02)
	Local $Ri, $Rf, $Rs, $Gi, $Gf, $Gs, $Bi, $Bf, $Bs, $m = $fDepth
	Local $lFillColour = 0x000000
	$Bi = Mod($lFillColour, 256)
	$Gi = BitAND($lFillColour / 256, 255)
	$Ri = BitAND($lFillColour / 65536, 255)
	$Bf = Mod($iEndColour, 256)
	$Gf = BitAND($iEndColour / 256, 255)
	$Rf = BitAND($iEndColour / 65536, 255)
	$Bs = Abs($Ri - $Rf) / $m
	$Gs = Abs($Gi - $Gf) / $m
	$Rs = Abs($Bi - $Bf) / $m
	If $Rf < $Ri Then $Rs = -$Rs
	If $Gf < $Gi Then $Gs = -$Gs
	If $Bf < $Bi Then $Bs = -$Bs
	_SetLineWidth($iBorderWidth)
	Local $lFillColour2
	For $i = 0 To $fDepth Step 0.02
		$Rf = $Ri + $Rs * $i
		$Gf = $Gi + $Gs * $i
		$Bf = $Bi + $Bs * $i
		$lFillColour2 = Dec(Hex($Bf, 2) & Hex($Gf, 2) & Hex($Rf, 2))
		_SetColourStroke($lFillColour2)
		_SetColourFill($lFillColour2)
		_SetLineWidth($iBorderWidth)
		_DrawArc($iX - $i, $iY - $i, $iRadius, $iStartAngle, $iEndAngle, $iRatio, $bPie, $iRotate, $iQuality, $sStyle)
	Next
	_SetColourStroke(0)
	_SetColourFill(0)
	_SetLineWidth(0)
EndFunc   ;==>_Insert3DPie

; #FUNCTION# ====================================================================================================================
; Name ..........: _InsertImage
; Description ...: Insert a image in the pdf
; Syntax ........: _InsertImage( $sAlias , $iX , $iY [, $iW [, $iH ]] )
; Parameters ....: $sAlias              -  string value.
;                  $iX                  -  integer value.
;                  $iY                  -  integer value.
;                  $iW                  - [optional]  integer value.
;                  $iH                  - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _InsertImage($sAlias, $iX, $iY, $iW = 0, $iH = 0)
	If $iW = 0 And $iH = 0 Then
		$iW = $_iImageW/_GetUnit()
		$iH = $_iImageH/_GetUnit()
	EndIf
	__ToBuffer("q" & chr(10) & __ToStr(__ToSpace($iW)) & " " & " 0 0 " & __ToStr(__ToSpace($iH)) & " " & __ToStr(__ToSpace($iX)) & " " & __ToStr(__ToSpace($iY)) & " cm" & _
	chr(10) & "/" & $sAlias & " Do" & chr(10) & "Q")
EndFunc   ;==>_InsertImage

; #FUNCTION# ====================================================================================================================
; Name ..........: _InsertRenderedText
; Description ...: Insert rendered text
; Syntax ........: _InsertRenderedText( $iX , $iY , $sText , $sAlias [, $_FontSize [, $iScale [, $sAlign = $PDF_ALIGN_LEFT [,
;                  $iFillColour [, $iOutlineColour ]]]]] )
; Parameters ....: $iX                  -  integer value.
;                  $iY                  -  integer value.
;                  $sText               -  string value.
;                  $sAlias              -  string value.
;                  $_FontSize           - [optional]  unknown value.
;                  $iScale              - [optional]  integer value.
;                  $sAlign              - [optional]  string value.
;                  $iFillColour         - [optional]  RGB value.
;                  $iOutlineColour      - [optional]  RGB value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _InsertRenderedText($iX, $iY, $sText, $sAlias, $_FontSize = 64, $iScale = 100, $sAlign = $PDF_ALIGN_LEFT, $iFillColour = 0x996600, $iOutlineColour = 0x111111)
	_SetColourFill($iFillColour)
	_SetColourStroke($iOutlineColour)
	_SetTextRenderingMode(2)
	_SetTextHorizontalScaling($iScale)
	_DrawText($iX, $iY, $sText, $sAlias, $_FontSize, $sAlign)
	_SetTextRenderingMode(0)
	_SetTextHorizontalScaling(100)
	_SetColourFill(0)
	_SetColourStroke(0)
EndFunc   ;==>_InsertRenderedText

; #FUNCTION# ====================================================================================================================
; Name ..........: _LineTo
; Description ...: Append straight line segment to path
; Syntax ........: _LineTo( $iX , $iY [, $sStyle = $PDF_STYLE_STROKED ] )
; Parameters ....: $iX                   -  integer value.
;                  $iY                   -  integer value.
;                  $sStyle              - [optional]  string value.
;                  |$PDF_STYLE_STROKED
;                  $PDF_STYLE_FILLED
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _LineTo($iX, $iY, $sStyle = $PDF_STYLE_STROKED)
	__ToBuffer(__ToStr(__ToSpace($iX)) & " " & __ToStr(__ToSpace($iY)) & " l")
	_Path($sStyle)
EndFunc   ;==>_LineTo

; #FUNCTION# ====================================================================================================================
; Name ..........: _LoadFontStandard
; Description ...: Load standard font (Type 1)
;					Courier					Helvetica					Times-Roman			Symbol
;					Courier-Bold			Helvetica-Bold				Times-Bold			ZapfDingbats
;					Courier-Oblique			Helvetica-Oblique			Times-Italic
;					Courier-BoldOblique		Helvetica-BoldOblique		Times-BoldItalic
; Syntax ........: _LoadFontStandard( $sAlias , $BaseFont [, $sOptions ] )
; Parameters ....: $sAlias            -  an alias for the font, to use in the script.
;                  $BaseFont            -  one of the following
;					|$PDF_FONT_STD_HELVETICA
;					|$PDF_FONT_STD_COURIER
;					|$PDF_FONT_STD_SYMBOL
;					|$PDF_FONT_STD_ZAPFDINGBATS
;					|$PDF_FONT_STD_ARIAL
;					|$PDF_FONT_STD_TIMES
;                  $sOptions            - [optional]  style value.
;					|$PDF_FONT_NORMAL = 0
;					|$PDF_FONT_BOLD = 1
;					|$PDF_FONT_ITALIC = 2
;					|$PDF_FONT_BOLDITALIC = 4
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _LoadFontStandard($sAlias, $BaseFont, $sOptions = $PDF_FONT_NORMAL)
	Local $sTemp
	$BaseFont = StringReplace($BaseFont, " ", "")
	Switch $sOptions
		Case $PDF_FONT_BOLD
			$sTemp = ",Bold"
		Case $PDF_FONT_BOLDITALIC
			$sTemp = ",BoldItalic"
		Case $PDF_FONT_ITALIC
			$sTemp = ",Italic"
	EndSwitch
	Local $i = __InitObj()
	__ToBuffer("<< /Type/Font/Subtype/Type1/Name/" & $sAlias & "/BaseFont/" & $BaseFont & $sTemp & "/Encoding/WinAnsiEncoding >>")
	__EndObj()
	$_sFONT = $_sFONT & "/" & $sAlias & " " & $i & " 0 R " & chr(10)
EndFunc   ;==>_LoadFontStandard

; #FUNCTION# ====================================================================================================================
; Name ..........: _LoadFontTT
; Description ...: Load one of the True Type Fonts included
; Syntax ........: _LoadFontTT( $sAlias , $BaseFont [, $sOptions] )
; Parameters ....: $sAlias            -  string value.
;                  $BaseFont            -  one of the following:
;					|$PDF_FONT_COURIER
;					|$PDF_FONT_ARIAL
;					|$PDF_FONT_TIMES
;					|$PDF_FONT_SYMBOL
;                  $sOptions            - [optional]  font style (normal, bold, bold-italic).
;					|$PDF_FONT_NORMAL = 0
;					|$PDF_FONT_BOLD = 1
;					|$PDF_FONT_ITALIC = 2
;					|$PDF_FONT_BOLDITALIC = 4
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _LoadFontTT($sAlias, $BaseFont, $sOptions = $PDF_FONT_NORMAL)
	Local $sTemp = ""
	$_Font = $_Font + 1
	$BaseFont = StringReplace($BaseFont, " ", "")
	Switch $BaseFont
		Case "TimesNewRoman"
			__FontTimes($sOptions)
		Case "CourierNew"
			__FontCourier($sOptions)
		Case "Symbol"
			__FontSymbol($sOptions)
		Case "Calibri"
			__FontCalibri($sOptions)
		Case "Garamond"
			__FontGaramond($sOptions)
		Case Else
			__FontArial($sOptions)
	EndSwitch
	Local $i = __InitObj()
	__ToBuffer("<< /Type/Font/Subtype/TrueType/Name/" & $sAlias & "/BaseFont/" & $BaseFont & $sOptions & "/FirstChar " & $FirstChar & "/LastChar " & $LastChar & "/FontDescriptor " & $i + 1 & " 0 R/Encoding/WinAnsiEncoding/Widths [")
	For $j = $FirstChar To $LastChar
		If $Widths[$j - $FirstChar] <> 0 Then
			$sTemp &= __ToStr($Widths[$j - $FirstChar]) & " "
			If Mod($j - $FirstChar + 1, 16) = 0 Or $j = $LastChar Then
				__ToBuffer($sTemp)
				$sTemp = ""
			EndIf
		EndIf
	Next
	__ToBuffer("] >>")
	__EndObj()
	$_sFONT = $_sFONT & "/" & $sAlias & " " & $i & " 0 R " & chr(10)
	$_sFONTNAME = $_sFONTNAME & "<" & $sAlias & ">" & StringRight("0000" & $_Font, 4) & ";"
	;$i =
	__InitObj()
	__ToBuffer("<< /Type/FontDescriptor/FontName/" & $BaseFont & $Param & ">>")
	__EndObj()
EndFunc   ;==>_LoadFontTT

; #FUNCTION# ====================================================================================================================
; Name ..........: _LoadResImage
; Description ...: Load a image in the pdf (if you use it multiple times it decreases the size of the pdf)
; Syntax ........: _LoadResImage( $sImgAlias , $sImage  )
; Parameters ....: $sImgAlias           -  an alias to identify the image in the pdf (e.g. "Cheese").
;                  $sImage              -  image path.
; Return values .: Success      - True
;                  Failure      - False
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......: Image types accepted: BMP, GIF, TIF, TIFF, PNG, JPG, JPEG (those are tested)
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _LoadResImage($sImgAlias, $sImage)
	Local $iW, $iH, $ImgBuf, $hImage, $hImageExt, $newImg, $hClone, $hGraphics, $iObj
	If $sImgAlias = "" Then __Error("You don't have an alias for the image", @ScriptLineNumber)
	If $sImage = ""  Then
		__Error("You don't have any images to insert or the path is invalid",@ScriptLineNumber)
	Else
		$hImageExt = StringUpper(StringRight($sImage, 3))
		$newImg = _TempFile(@ScriptDir, "~", ".jpg")
		Switch $hImageExt
			Case "BMP", "GIF", "TIF", "TIFF", "PNG", "JPG", "JPEG", "ICO"
				_GDIPlus_Startup()
				$hImage = _GDIPlus_ImageLoadFromFile($sImage)
				$iW = _GDIPlus_ImageGetWidth($hImage)
				$iH = _GDIPlus_ImageGetHeight($hImage)
				$hClone = _GDIPlus_BitmapCloneArea($hImage, 0, 0, $iW, $iH, $GDIP_PXF24RGB)
				$hGraphics = _GDIPlus_ImageGetGraphicsContext($hClone)
				_GDIPlus_GraphicsSetSmoothingMode($hGraphics, 2)
				_GDIPlus_GraphicsClear($hGraphics, 0xFFFFFFFF)
				_GDIPlus_GraphicsDrawImage($hGraphics, $hImage, 0, 0)
				_GDIPlus_ImageSaveToFile($hClone, $newImg)
				$ImgBuf = __ToBinary($newImg)
				$_iImageW = $iW
				$_iImageH = $iH
				$iObj = __InitObj()
				__ToBuffer("<</Type /XObject /Subtype /Image /Name /" & $sImgAlias & " /Width " & $_iImageW & " /Height " & $_iImageH & " /Filter /DCTDecode /ColorSpace /DeviceRGB /BitsPerComponent 8"&chr(10)&"/Length "&stringlen($ImgBuf)&">>stream")
				__ToBuffer($ImgBuf)
				__ToBuffer("endstream")
				__EndObj()
				$_Image &= "/" & $sImgAlias & " " & $iObj & " 0 R " & chr(10)
				__InitObj()
				__ToBuffer(StringLen($ImgBuf))
				__EndObj()
				_GDIPlus_ImageDispose($hImage)
				_GDIPlus_GraphicsDispose($hGraphics)
				_GDIPlus_BitmapDispose($hClone)
				_GDIPlus_Shutdown()
				FileDelete($newImg)
			Case Else
				__Error("The image is invalid",@ScriptLineNumber)
				Exit
		EndSwitch
	EndIf
	Return $_Image
EndFunc   ;==>_LoadResImage

; #FUNCTION# ====================================================================================================================
; Name ..........: _OpenAfter
; Description ...: Choose to open or not the pdf after generating
; Syntax ........: _OpenAfter( [ $bO ] )
; Parameters ....: $bO                  - [optional]  True/False.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _OpenAfter($bO = True)
	$_bOpen = $bO
EndFunc   ;==>_OpenAfter

; #FUNCTION# ====================================================================================================================
; Name ..........: _Paragraph
; Description ...: Insert paragraph on page
; Syntax ........: _Paragraph( $sText , $iX , $iY [, $iWidth [, $sFontAlias [, $iFontSize [, $iRotate ]]]] )
; Parameters ....: $sText               -  text string.
;                  $iX                  -  left value.
;                  $iY                  -  top value.
;                  $iWidth              - [optional]  width.
;                  $sFontAlias          - [optional]  font alias.
;                  $iFontSize           - [optional]  font size.
;                  $iRotate             - [optional]  angle.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _Paragraph($sText, $iX, $iY, $iWidth = 0, $sFontAlias = "", $iFontSize = 12, $iRotate = 0)
	_SetColourFill(0)
	_SetColourStroke(0)
	_SetTextRenderingMode(0)
	Local $iUnit = Round(_GetUnit())
	Local $iPagina = Round(_GetPageWidth() / $iUnit)

	If $iWidth = 0 Then $iWidth = Round($iPagina - 1.75 * $iX, 2)

	Local $lScale = 100
	Local $sRand = ""
	Local $r = 0

	Local $iCuvinte = StringSplit($sText, " ", 3)

	For $i = 0 To UBound($iCuvinte) - 1
		$sRand &= $iCuvinte[$i] & " "
		Local $ssr = Round(_GetTextLength($sRand, $sFontAlias, $iFontSize) * $iUnit)
		Switch $ssr
			Case 1 To Round($iWidth * $iUnit, 2)
				If $i = UBound($iCuvinte) - 1 Then
					_DrawText($iX, $iY - Round($r * (($iFontSize * 1.2) / $iUnit), 2), $sRand, $sFontAlias, $iFontSize, $PDF_ALIGN_LEFT, $iRotate)
				EndIf
				ContinueLoop
			Case Else
				$lScale = Round($iWidth * 100 * $iUnit / $ssr, 1)
				_SetTextHorizontalScaling($lScale)
				_DrawText($iX, $iY - Round($r * ($iFontSize * 1.2) / $iUnit, 2), $sRand, $sFontAlias, $iFontSize, $PDF_ALIGN_LEFT, $iRotate)
				_SetTextHorizontalScaling(100)
		EndSwitch
		$sRand = ""
		$r += 1
	Next
EndFunc   ;==>_Paragraph

; #FUNCTION# ====================================================================================================================
; Name ..........: _Rectangle
; Description ...: Draw a _Rectangle
; Syntax ........: _Rectangle( $iX , $iY , $iW , $iH [, $sStyle [, $iRadius ]] )
; Parameters ....: $iX                  -  Left value.
;                  $iY                  -  Top value.
;                  $iW                  -  Width.
;                  $iH                  -  Height.
;                  $sStyle              - [optional]  string value.
;                  |$PDF_STYLE_STROKED
;                  |$PDF_STYLE_FILLED
;                  $iRadius             - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _Rectangle($iX, $iY, $iW, $iH, $sStyle = $PDF_STYLE_STROKED, $iRadius = 0)
	Local $iR
	__ToBuffer("n")
	If $iRadius > 0 Then
		If $iRadius > ($iW / 2) Then $iRadius = $iW / 2
		If $iRadius > ($iH / 2) Then $iRadius = $iH / 2
		$iR = 0.55 * $iRadius
		_MoveTo($iX + $iRadius, $iY)
		_LineTo($iX + $iW - $iRadius, $iY, $PDF_STYLE_NONE)
		__Curve(($iX + $iW - $iRadius + $iR), $iY, $iX + $iW, $iY + $iRadius - $iR, $iX + $iW, $iY + $iRadius, $PDF_STYLE_NONE)
		_LineTo($iX + $iW, $iY + $iH - $iRadius, $PDF_STYLE_NONE)
		__Curve($iX + $iW, $iY + $iH - $iRadius + $iR, $iX + $iW - $iRadius + $iR, $iY + $iH, $iX + $iW - $iRadius, $iY + $iH, $PDF_STYLE_NONE)
		_LineTo($iX + $iRadius, $iY + $iH, $PDF_STYLE_NONE)
		__Curve($iX + $iRadius - $iR, $iY + $iH, $iX, $iY + $iH - $iRadius + $iR, $iX, $iY + $iH - $iRadius, $PDF_STYLE_NONE)
		_LineTo($iX, $iY + $iRadius, $PDF_STYLE_NONE)
		__Curve($iX, $iY + $iRadius - $iR, $iX + $iRadius - $iR, $iY, $iX + $iRadius, $iY, $PDF_STYLE_NONE)
	Else
		__ToBuffer(__ToStr(__ToSpace($iX)) & " " & __ToStr(__ToSpace($iY)) & " " & __ToStr(__ToSpace($iW)) & " " & __ToStr(__ToSpace($iH)) & " re")
	EndIf
	_Path($sStyle)
EndFunc   ;==>_Rectangle

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetCharSpacing
; Description ...: Set the space between characters
; Syntax ........: _SetCharSpacing( $iW  )
; Parameters ....: $iW                   -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetCharSpacing($iW)
	$_CharSpacing = $iW
	__ToBuffer(__ToStr($_CharSpacing) & " Tc")
EndFunc   ;==>_SetCharSpacing

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetColourFill
; Description ...: Set the fill colour
; Syntax ........: _SetColourFill( $rgb  )
; Parameters ....: $rgb                 -  RGB value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetColourFill($rgb)
	Local $r, $G, $B
	If ($rgb <= 0) And ($rgb >= -255) Then
		__ToBuffer(__ToStr(-$rgb / 255) & " g")
	Else
		$B = Mod($rgb, 256)
		$G = Mod(($rgb / 256), 256)
		$r = Mod(($rgb / 65536), 256)
		__ToBuffer(__ToStr($r / 255) & " " & __ToStr($G / 255) & " " & __ToStr($B / 255) & " rg")
	EndIf
EndFunc   ;==>_SetColourFill

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetColourStroke
; Description ...: Set the stroke colour
; Syntax ........: _SetColourStroke( $rgb  )
; Parameters ....: $rgb                 -  RGB value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetColourStroke($rgb)
	Local $r, $G, $B
	If ($rgb <= 0) And ($rgb >= -255) Then
		__ToBuffer(__ToStr(-$rgb / 255) & " G")
	Else
		$B = Mod($rgb, 256)
		$G = Mod(($rgb / 256), 256)
		$r = Mod(($rgb / 65536), 256)
		__ToBuffer(__ToStr($r / 255) & " " & __ToStr($G / 255) & " " & __ToStr($B / 255) & " RG")
	EndIf
EndFunc   ;==>_SetColourStroke

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetDash
; Description ...: The line dash pattern controls the pattern of dashes and gaps used to stroke paths.
; Syntax ........: _SetDash( $dash_on [, $dash_off ] )
; Parameters ....: $dash_on             -  unknown value.
;                  $dash_off            - [optional]  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetDash($dash_on, $dash_off = 0)
	If ($dash_on = 0) And ($dash_off = 0) Then
		__ToBuffer("[ ] 0 d")
	Else
		__ToBuffer("[" & __ToStr(__ToSpace($dash_on)) & " " & __ToStr(__ToSpace($dash_off)) & "] 0 d")
	EndIf
EndFunc   ;==>_SetDash

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetKeywords
; Description ...: Sets the keywords property of the pdf
; Syntax ........: _SetKeywords( [ $sKeywords ] )
; Parameters ....: $sKeywords           - [optional]  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetKeywords($sKeywords = "")
	$PDF_KEYWORDS = $sKeywords
EndFunc   ;==>_SetKeywords

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetLayoutMode
; Description ...: Sets the layout mode when pdf is displayed
; Syntax ........: _SetLayoutMode( $sL  )
; Parameters ....: $sL                  -  string value.
;					|$PDF_LAYOUT_SINGLE = 0
;					|$PDF_LAYOUT_CONTINOUS = 1
;					|$PDF_LAYOUT_TWO = 2
;					|$PDF_LAYOUT_DEFAULT = 4
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetLayoutMode($sL)
	Switch $sL
		Case $PDF_LAYOUT_SINGLE, $PDF_LAYOUT_CONTINOUS, $PDF_LAYOUT_TWO, $PDF_LAYOUT_DEFAULT
			$_LayoutMode = $sL
		Case Else
			$_LayoutMode = $PDF_LAYOUT_SINGLE
	EndSwitch
EndFunc   ;==>_SetLayoutMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetLineCap
; Description ...: The line cap style specifies the shape to be used at the ends of open subpaths (and dashes, if any) when they are stroked.
; Syntax ........: _SetLineCap( $iW  )
; Parameters ....: $iW                   -  integer value.
;					|0	=	Butt cap.
;					|1	=	Round cap.
;					|2	=	Projecting square cap.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetLineCap($iW)
	If ($iW >= 0) And ($iW <= 2) Then __ToBuffer(__ToStr($iW) & " J")
EndFunc   ;==>_SetLineCap

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetLineJoin
; Description ...: The  line join style specifies the shape to be used at the corners of paths that are stroked.
; Syntax ........: _SetLineJoin( $iW  )
; Parameters ....: $iW                   -  integer value.
;					|0	=	Miter join.
;					|1	=	Round join.
;					|2	=	Bevel join.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetLineJoin($iW)
	If ($iW >= 0) And ($iW <= 2) Then __ToBuffer(__ToStr($iW) & " j")
EndFunc   ;==>_SetLineJoin

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetMargin
; Description ...: Set the interior margin of the working area.
; Syntax ........: _SetMargin( $iValue  )
; Parameters ....: $iValue              -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetMargin($iValue)
	$__SetMargin = __ToSpace($iValue)
EndFunc   ;==>_SetMargin

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetMiterLimit
; Description ...: When two line segments meet at a sharp angle and mitered joins have been specified as the line join style,
;					it is possible for the miter to extend far beyond the thickness of the line stroking the path.
;					The miter limit imposes a maximum on the ratio of the miter length to the line width.
; Syntax ........: _SetMiterLimit($iW)
; Parameters ....: $iW                   -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetMiterLimit($iW)
	If ($iW >= 1) Then __ToBuffer(__ToStr($iW) & " M")
EndFunc   ;==>_SetMiterLimit

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetOrientation
; Description ...: Set the orientation of the pages in pdf
; Syntax ........: _SetOrientation( [ $iOrientation = $PDF_ORIENTATION_PORTRAIT ] )
; Parameters ....: $iOrientation        - [optional]  integer value.
;                  |$PDF_ORIENTATION_PORTRAIT
; 				   |$PDF_ORIENTATION_LANDSCAPE
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetOrientation($iOrientation = $PDF_ORIENTATION_PORTRAIT)
	$_Orientation = $iOrientation
EndFunc   ;==>_SetOrientation

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetPageHeight
; Description ...: Set the height of the page
; Syntax ........: _SetPageHeight( $iH  )
; Parameters ....: $iH                  -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetPageHeight($iH)
	If $_PaperSize <> "CUSTOM" Then $_PaperSize = "CUSTOM"
	$_PageHeight = __ToSpace($iH)
EndFunc   ;==>_SetPageHeight

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetPageWidth
; Description ...: Set the width of the page
; Syntax ........: _SetPageWidth( $iW  )
; Parameters ....: $iW                  -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetPageWidth($iW)
	If $_PaperSize <> "CUSTOM" Then $_PaperSize = "CUSTOM"
	$_PageWidth = __ToSpace($iW)
EndFunc   ;==>_SetPageWidth

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetPaperSize
; Description ...: Sets the paper size of the pdf
; Syntax ........: _SetPaperSize( $sPage [, $iWidth [, $iHeight ]] )
; Parameters ....: $sPage        -  string value ("A0","LETTER", "CUSTOM" etc)
;					|if "CUSTOM" set the width and height
;                  $iWidth              - [optional]  integer value.
;                  $iHeight             - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetPaperSize($sPage, $iWidth = -1, $iHeight = -1)
	$_PaperSize = StringUpper($sPage)
	Switch $sPage
		Case "A0"
			$_PageWidth = 2383.937
			$_PageHeight = 3370.394
		Case "A1"
			$_PageWidth = 1683.780
			$_PageHeight = 2383.937
		Case "A2"
			$_PageWidth = 1190.551
			$_PageHeight = 1683.780
		Case "A3"
			$_PageWidth = 841.890
			$_PageHeight = 1190.551
		Case "A4"
			$_PageWidth = 595.276
			$_PageHeight = 841.890
		Case "A5"
			$_PageWidth = 419.528
			$_PageHeight = 595.276
		Case "A6"
			$_PageWidth = 297.638
			$_PageHeight = 419.528
		Case "A7"
			$_PageWidth = 209.764
			$_PageHeight = 297.638
		Case "A8"
			$_PageWidth = 147.402
			$_PageHeight = 209.764
		Case "A9"
			$_PageWidth = 104.882
			$_PageHeight = 147.402
		Case "A10"
			$_PageWidth = 73.701
			$_PageHeight = 104.882
		Case "A11"
			$_PageWidth = 51.024
			$_PageHeight = 73.701
		Case "A12"
			$_PageWidth = 36.850
			$_PageHeight = 51.024
		Case "B0"
			$_PageWidth = 2834.646
			$_PageHeight = 4008.189
		Case "B1"
			$_PageWidth = 2004.094
			$_PageHeight = 2834.646
		Case "B2"
			$_PageWidth = 1417.323
			$_PageHeight = 2004.094
		Case "B3"
			$_PageWidth = 1000.630
			$_PageHeight = 1417.323
		Case "B4"
			$_PageWidth = 708.661
			$_PageHeight = 1000.630
		Case "B5"
			$_PageWidth = 498.898
			$_PageHeight = 708.661
		Case "B6"
			$_PageWidth = 354.331
			$_PageHeight = 498.898
		Case "B7"
			$_PageWidth = 249.449
			$_PageHeight = 354.331
		Case "B8"
			$_PageWidth = 175.748
			$_PageHeight = 249.449
		Case "B9"
			$_PageWidth = 124.724
			$_PageHeight = 175.748
		Case "B10"
			$_PageWidth = 87.874
			$_PageHeight = 124.724
		Case "B11"
			$_PageWidth = 62.362
			$_PageHeight = 87.874
		Case "B12"
			$_PageWidth = 42.520
			$_PageHeight = 62.362
		Case "C0"
			$_PageWidth = 2599.370
			$_PageHeight = 3676.535
		Case "C1"
			$_PageWidth = 1836.850
			$_PageHeight = 2599.370
		Case "C2"
			$_PageWidth = 1298.268
			$_PageHeight = 1836.850
		Case "C3"
			$_PageWidth = 918.425
			$_PageHeight = 1298.268
		Case "C4"
			$_PageWidth = 649.134
			$_PageHeight = 918.425
		Case "C5"
			$_PageWidth = 459.213
			$_PageHeight = 649.134
		Case "C6"
			$_PageWidth = 323.150
			$_PageHeight = 459.213
		Case "C7"
			$_PageWidth = 229.606
			$_PageHeight = 323.150
		Case "C8"
			$_PageWidth = 161.575
			$_PageHeight = 229.606
		Case "C9"
			$_PageWidth = 113.386
			$_PageHeight = 161.575
		Case "C10"
			$_PageWidth = 79.370
			$_PageHeight = 113.386
		Case "C11"
			$_PageWidth = 56.693
			$_PageHeight = 79.370
		Case "C12"
			$_PageWidth = 39.685
			$_PageHeight = 56.693
		Case "C76"
			$_PageWidth = 229.606
			$_PageHeight = 459.213
		Case "DL"
			$_PageWidth = 311.811
			$_PageHeight = 623.622
		Case "E0"
			$_PageWidth = 2491.654
			$_PageHeight = 3517.795
		Case "E1"
			$_PageWidth = 1757.480
			$_PageHeight = 2491.654
		Case "E2"
			$_PageWidth = 1247.244
			$_PageHeight = 1757.480
		Case "E3"
			$_PageWidth = 878.740
			$_PageHeight = 1247.244
		Case "E4"
			$_PageWidth = 623.622
			$_PageHeight = 878.740
		Case "E5"
			$_PageWidth = 439.370
			$_PageHeight = 623.622
		Case "E6"
			$_PageWidth = 311.811
			$_PageHeight = 439.370
		Case "E7"
			$_PageWidth = 221.102
			$_PageHeight = 311.811
		Case "E8"
			$_PageWidth = 155.906
			$_PageHeight = 221.102
		Case "E9"
			$_PageWidth = 110.551
			$_PageHeight = 155.906
		Case "E10"
			$_PageWidth = 76.535
			$_PageHeight = 110.551
		Case "E11"
			$_PageWidth = 53.858
			$_PageHeight = 76.535
		Case "E12"
			$_PageWidth = 36.850
			$_PageHeight = 53.858
		Case "G0"
			$_PageWidth = 2715.591
			$_PageHeight = 3838.110
		Case "G1"
			$_PageWidth = 1919.055
			$_PageHeight = 2715.591
		Case "G2"
			$_PageWidth = 1357.795
			$_PageHeight = 1919.055
		Case "G3"
			$_PageWidth = 958.110
			$_PageHeight = 1357.795
		Case "G4"
			$_PageWidth = 677.480
			$_PageHeight = 958.110
		Case "G5"
			$_PageWidth = 479.055
			$_PageHeight = 677.480
		Case "G6"
			$_PageWidth = 337.323
			$_PageHeight = 479.055
		Case "G7"
			$_PageWidth = 238.110
			$_PageHeight = 337.323
		Case "G8"
			$_PageWidth = 167.244
			$_PageHeight = 238.110
		Case "G9"
			$_PageWidth = 119.055
			$_PageHeight = 167.244
		Case "G10"
			$_PageWidth = 82.205
			$_PageHeight = 119.055
		Case "G11"
			$_PageWidth = 59.528
			$_PageHeight = 82.205
		Case "G12"
			$_PageWidth = 39.685
			$_PageHeight = 59.528
		Case "RA0"
			$_PageWidth = 2437.795
			$_PageHeight = 3458.268
		Case "RA1"
			$_PageWidth = 1729.134
			$_PageHeight = 2437.795
		Case "RA2"
			$_PageWidth = 1218.898
			$_PageHeight = 1729.134
		Case "RA3"
			$_PageWidth = 864.567
			$_PageHeight = 1218.898
		Case "RA4"
			$_PageWidth = 609.449
			$_PageHeight = 864.567
		Case "SRA0"
			$_PageWidth = 2551.181
			$_PageHeight = 3628.346
		Case "SRA1"
			$_PageWidth = 1814.173
			$_PageHeight = 2551.181
		Case "SRA2"
			$_PageWidth = 1275.591
			$_PageHeight = 1814.173
		Case "SRA3"
			$_PageWidth = 907.087
			$_PageHeight = 1275.591
		Case "SRA4"
			$_PageWidth = 637.795
			$_PageHeight = 907.087
		Case "4A0"
			$_PageWidth = 4767.874
			$_PageHeight = 6740.787
		Case "2A0"
			$_PageWidth = 3370.394
			$_PageHeight = 4767.874
		Case "A2_EXTRA"
			$_PageWidth = 1261.417
			$_PageHeight = 1754.646
		Case "A3+"
			$_PageWidth = 932.598
			$_PageHeight = 1369.134
		Case "A3_EXTRA"
			$_PageWidth = 912.756
			$_PageHeight = 1261.417
		Case "A3_SUPER"
			$_PageWidth = 864.567
			$_PageHeight = 1440
		Case "SUPER_A3"
			$_PageWidth = 864.567
			$_PageHeight = 1380.472
		Case "A4_EXTRA"
			$_PageWidth = 666.142
			$_PageHeight = 912.756
		Case "A4_SUPER"
			$_PageWidth = 649.134
			$_PageHeight = 912.756
		Case "SUPER_A4"
			$_PageWidth = 643.465
			$_PageHeight = 1009.134
		Case "A4_LONG"
			$_PageWidth = 595.276
			$_PageHeight = 986.457
		Case "F4"
			$_PageWidth = 595.276
			$_PageHeight = 935.433
		Case "SO_B5_EXTRA"
			$_PageWidth = 572.598
			$_PageHeight = 782.362
		Case "A5_EXTRA"
			$_PageWidth = 490.394
			$_PageHeight = 666.142
		Case "ANSI_E"
			$_PageWidth = 2448
			$_PageHeight = 3168
		Case "ANSI_D"
			$_PageWidth = 1584
			$_PageHeight = 2448
		Case "ANSI_C"
			$_PageWidth = 1224
			$_PageHeight = 1584
		Case "ANSI_B"
			$_PageWidth = 792
			$_PageHeight = 1224
		Case "ANSI_A"
			$_PageWidth = 612
			$_PageHeight = 792
		Case "LEDGER"
			$_PageWidth = 1224
			$_PageHeight = 792
		Case "TABLOID"
			$_PageWidth = 792
			$_PageHeight = 1224
		Case "LETTER"
			$_PageWidth = 612
			$_PageHeight = 792
		Case "LEGAL"
			$_PageWidth = 612
			$_PageHeight = 1008
		Case "GLETTER"
			$_PageWidth = 576
			$_PageHeight = 756
		Case "JLEGAL"
			$_PageWidth = 576
			$_PageHeight = 360
		Case "QUADDEMY"
			$_PageWidth = 2520
			$_PageHeight = 3240
		Case "SUPER_B"
			$_PageWidth = 936
			$_PageHeight = 1368
		Case "QUARTO"
			$_PageWidth = 648
			$_PageHeight = 792
		Case "FOLIO"
			$_PageWidth = 612
			$_PageHeight = 936
		Case "EXECUTIVE"
			$_PageWidth = 522
			$_PageHeight = 756
		Case "MEMO"
			$_PageWidth = 396
			$_PageHeight = 612
		Case "FOOLSCAP"
			$_PageWidth = 595.440
			$_PageHeight = 936
		Case "COMPACT"
			$_PageWidth = 306
			$_PageHeight = 486
		Case "ORGANIZERJ"
			$_PageWidth = 198
			$_PageHeight = 360
		Case "P1"
			$_PageWidth = 1587.402
			$_PageHeight = 2437.795
		Case "P2"
			$_PageWidth = 1218.898
			$_PageHeight = 1587.402
		Case "P3"
			$_PageWidth = 793.701
			$_PageHeight = 1218.898
		Case "P4"
			$_PageWidth = 609.449
			$_PageHeight = 793.701
		Case "P5"
			$_PageWidth = 396.850
			$_PageHeight = 609.449
		Case "P6"
			$_PageWidth = 303.307
			$_PageHeight = 396.850
		Case "ARCH_E"
			$_PageWidth = 2592
			$_PageHeight = 3456
		Case "ARCH_E1"
			$_PageWidth = 2160
			$_PageHeight = 3024
		Case "ARCH_D"
			$_PageWidth = 1728
			$_PageHeight = 2592
		Case "ARCH_C"
			$_PageWidth = 1296
			$_PageHeight = 1728
		Case "ARCH_B"
			$_PageWidth = 864
			$_PageHeight = 1296
		Case "ARCH_A"
			$_PageWidth = 648
			$_PageHeight = 864
		Case "ANNENV_A2"
			$_PageWidth = 314.640
			$_PageHeight = 414
		Case "ANNENV_A6"
			$_PageWidth = 342
			$_PageHeight = 468
		Case "ANNENV_A7"
			$_PageWidth = 378
			$_PageHeight = 522
		Case "ANNENV_A8"
			$_PageWidth = 396
			$_PageHeight = 584.640
		Case "ANNENV_A10"
			$_PageWidth = 450
			$_PageHeight = 692.640
		Case "ANNENV_SLIM"
			$_PageWidth = 278.640
			$_PageHeight = 638.640
		Case "COMMENV_N6_1/4"
			$_PageWidth = 252
			$_PageHeight = 432
		Case "COMMENV_N6_3/4"
			$_PageWidth = 260.640
			$_PageHeight = 468
		Case "COMMENV_N8"
			$_PageWidth = 278.640
			$_PageHeight = 540
		Case "COMMENV_N9"
			$_PageWidth = 278.640
			$_PageHeight = 638.640
		Case "COMMENV_N10"
			$_PageWidth = 296.640
			$_PageHeight = 684
		Case "COMMENV_N11"
			$_PageWidth = 324
			$_PageHeight = 746.640
		Case "COMMENV_N12"
			$_PageWidth = 342
			$_PageHeight = 792
		Case "COMMENV_N14"
			$_PageWidth = 360
			$_PageHeight = 828
		Case "CATENV_N1"
			$_PageWidth = 432
			$_PageHeight = 648
		Case "CATENV_N1_3/4"
			$_PageWidth = 468
			$_PageHeight = 684
		Case "CATENV_N2"
			$_PageWidth = 468
			$_PageHeight = 720
		Case "CATENV_N3"
			$_PageWidth = 504
			$_PageHeight = 720
		Case "CATENV_N6"
			$_PageWidth = 540
			$_PageHeight = 756
		Case "CATENV_N7"
			$_PageWidth = 576
			$_PageHeight = 792
		Case "CATENV_N8"
			$_PageWidth = 594
			$_PageHeight = 810
		Case "CATENV_N9_1/2"
			$_PageWidth = 612
			$_PageHeight = 756
		Case "CATENV_N9_3/4"
			$_PageWidth = 630
			$_PageHeight = 810
		Case "CATENV_N10_1/2"
			$_PageWidth = 648
			$_PageHeight = 864
		Case "CATENV_N12_1/2"
			$_PageWidth = 684
			$_PageHeight = 900
		Case "CATENV_N13_1/2"
			$_PageWidth = 720
			$_PageHeight = 936
		Case "CATENV_N14_1/4"
			$_PageWidth = 810
			$_PageHeight = 882
		Case "CATENV_N14_1/2"
			$_PageWidth = 828
			$_PageHeight = 1044
		Case "JIS_B0"
			$_PageWidth = 2919.685
			$_PageHeight = 4127.244
		Case "JIS_B1"
			$_PageWidth = 2063.622
			$_PageHeight = 2919.685
		Case "JIS_B2"
			$_PageWidth = 1459.843
			$_PageHeight = 2063.622
		Case "JIS_B3"
			$_PageWidth = 1031.811
			$_PageHeight = 1459.843
		Case "JIS_B4"
			$_PageWidth = 728.504
			$_PageHeight = 1031.811
		Case "JIS_B5"
			$_PageWidth = 515.906
			$_PageHeight = 728.504
		Case "JIS_B6"
			$_PageWidth = 362.835
			$_PageHeight = 515.906
		Case "JIS_B7"
			$_PageWidth = 257.953
			$_PageHeight = 362.835
		Case "JIS_B8"
			$_PageWidth = 181.417
			$_PageHeight = 257.953
		Case "JIS_B9"
			$_PageWidth = 127.559
			$_PageHeight = 181.417
		Case "JIS_B10"
			$_PageWidth = 90.709
			$_PageHeight = 127.559
		Case "JIS_B11"
			$_PageWidth = 62.362
			$_PageHeight = 90.709
		Case "JIS_B12"
			$_PageWidth = 45.354
			$_PageHeight = 62.362
		Case "PA0"
			$_PageWidth = 2381.102
			$_PageHeight = 3174.803
		Case "PA1"
			$_PageWidth = 1587.402
			$_PageHeight = 2381.102
		Case "PA2"
			$_PageWidth = 1190.551
			$_PageHeight = 1587.402
		Case "PA3"
			$_PageWidth = 793.701
			$_PageHeight = 1190.551
		Case "PA4"
			$_PageWidth = 595.276
			$_PageHeight = 793.701
		Case "PA5"
			$_PageWidth = 396.850
			$_PageHeight = 595.276
		Case "PA6"
			$_PageWidth = 297.638
			$_PageHeight = 396.850
		Case "PA7"
			$_PageWidth = 198.425
			$_PageHeight = 297.638
		Case "PA8"
			$_PageWidth = 147.402
			$_PageHeight = 198.425
		Case "PA9"
			$_PageWidth = 99.213
			$_PageHeight = 147.402
		Case "PA10"
			$_PageWidth = 73.701
			$_PageHeight = 99.213
		Case "PASSPORT_PHOTO"
			$_PageWidth = 99.213
			$_PageHeight = 127.559
		Case "E"
			$_PageWidth = 233.858
			$_PageHeight = 340.157
		Case "3R"
			$_PageWidth = 252.283
			$_PageHeight = 360
		Case "4R"
			$_PageWidth = 289.134
			$_PageHeight = 430.866
		Case "4D"
			$_PageWidth = 340.157
			$_PageHeight = 430.866
		Case "5R"
			$_PageWidth = 360
			$_PageHeight = 504.567
		Case "6R"
			$_PageWidth = 430.866
			$_PageHeight = 575.433
		Case "8R"
			$_PageWidth = 575.433
			$_PageHeight = 720
		Case "S8R"
			$_PageWidth = 575.433
			$_PageHeight = 864.567
		Case "10R"
			$_PageWidth = 720
			$_PageHeight = 864.567
		Case "S10R"
			$_PageWidth = 720
			$_PageHeight = 1080
		Case "11R"
			$_PageWidth = 790.866
			$_PageHeight = 1009.134
		Case "S11R"
			$_PageWidth = 790.866
			$_PageHeight = 1224.567
		Case "12R"
			$_PageWidth = 864.567
			$_PageHeight = 1080
		Case "S12R"
			$_PageWidth = 864.567
			$_PageHeight = 1292.598
		Case "NEWSPAPER_BROADSHEET"
			$_PageWidth = 2125.984
			$_PageHeight = 1700.787
		Case "NEWSPAPER_BERLINER"
			$_PageWidth = 1332.283
			$_PageHeight = 892.913
		Case "NEWSPAPER_COMPACT"
			$_PageWidth = 1218.898
			$_PageHeight = 793.701
		Case "BUSINESS_CARD_ISO7810"
			$_PageWidth = 153.014
			$_PageHeight = 242.646
		Case "BUSINESS_CARD_ISO216"
			$_PageWidth = 147.402
			$_PageHeight = 209.764
		Case "BUSINESS_CARD_ES"
			$_PageWidth = 155.906
			$_PageHeight = 240.945
		Case "BUSINESS_CARD_US"
			$_PageWidth = 144.567
			$_PageHeight = 252.283
		Case "BUSINESS_CARD_JP"
			$_PageWidth = 155.906
			$_PageHeight = 257.953
		Case "BUSINESS_CARD_HK"
			$_PageWidth = 153.071
			$_PageHeight = 255.118
		Case "BUSINESS_CARD_SE"
			$_PageWidth = 155.906
			$_PageHeight = 255.118
		Case "BUSINESS_CARD_IL"
			$_PageWidth = 141.732
			$_PageHeight = 255.118
		Case "4SHEET"
			$_PageWidth = 2880
			$_PageHeight = 4320
		Case "6SHEET"
			$_PageWidth = 3401.575
			$_PageHeight = 5102.362
		Case "12SHEET"
			$_PageWidth = 8640
			$_PageHeight = 4320
		Case "16SHEET"
			$_PageWidth = 5760
			$_PageHeight = 8640
		Case "32SHEET"
			$_PageWidth = 11520
			$_PageHeight = 8640
		Case "48SHEET"
			$_PageWidth = 17280
			$_PageHeight = 8640
		Case "64SHEET"
			$_PageWidth = 23040
			$_PageHeight = 8640
		Case "96SHEET"
			$_PageWidth = 34560
			$_PageHeight = 8640
		Case "EN_EMPEROR"
			$_PageWidth = 3456
			$_PageHeight = 5184
		Case "EN_ANTIQUARIAN"
			$_PageWidth = 2232
			$_PageHeight = 3816
		Case "EN_GRAND_EAGLE"
			$_PageWidth = 2070
			$_PageHeight = 3024
		Case "EN_DOUBLE_ELEPHANT"
			$_PageWidth = 1926
			$_PageHeight = 2880
		Case "EN_ATLAS"
			$_PageWidth = 1872
			$_PageHeight = 2448
		Case "EN_COLOMBIER"
			$_PageWidth = 1692
			$_PageHeight = 2484
		Case "EN_ELEPHANT"
			$_PageWidth = 1656
			$_PageHeight = 2016
		Case "EN_DOUBLE_DEMY"
			$_PageWidth = 1620
			$_PageHeight = 2556
		Case "EN_IMPERIAL"
			$_PageWidth = 1584
			$_PageHeight = 2160
		Case "EN_PRINCESS"
			$_PageWidth = 1548
			$_PageHeight = 2016
		Case "EN_CARTRIDGE"
			$_PageWidth = 1512
			$_PageHeight = 1872
		Case "EN_DOUBLE_LARGE_POST"
			$_PageWidth = 1512
			$_PageHeight = 2376
		Case "EN_ROYAL"
			$_PageWidth = 1440
			$_PageHeight = 1800
		Case "EN_HALF_POST"
			$_PageWidth = 1404
			$_PageHeight = 1692
		Case "EN_SUPER_ROYAL"
			$_PageWidth = 1368
			$_PageHeight = 1944
		Case "EN_DOUBLE_POST"
			$_PageWidth = 1368
			$_PageHeight = 2196
		Case "EN_MEDIUM"
			$_PageWidth = 1260
			$_PageHeight = 1656
		Case "EN_DEMY"
			$_PageWidth = 1260
			$_PageHeight = 1620
		Case "EN_LARGE_POST"
			$_PageWidth = 1188
			$_PageHeight = 1512
		Case "EN_COPY_DRAUGHT"
			$_PageWidth = 1152
			$_PageHeight = 1440
		Case "EN_POST"
			$_PageWidth = 1116
			$_PageHeight = 1386
		Case "EN_CROWN"
			$_PageWidth = 1080
			$_PageHeight = 1440
		Case "EN_PINCHED_POST"
			$_PageWidth = 1062
			$_PageHeight = 1332
		Case "EN_BRIEF"
			$_PageWidth = 972
			$_PageHeight = 1152
		Case "EN_FOOLSCAP"
			$_PageWidth = 972
			$_PageHeight = 1224
		Case "EN_SMALL_FOOLSCAP"
			$_PageWidth = 954
			$_PageHeight = 1188
		Case "EN_POTT"
			$_PageWidth = 900
			$_PageHeight = 1080
		Case "BE_GRAND_AIGLE"
			$_PageWidth = 1984.252
			$_PageHeight = 2948.031
		Case "BE_COLOMBIER"
			$_PageWidth = 1757.480
			$_PageHeight = 2409.449
		Case "BE_DOUBLE_CARRE"
			$_PageWidth = 1757.480
			$_PageHeight = 2607.874
		Case "BE_ELEPHANT"
			$_PageWidth = 1746.142
			$_PageHeight = 2182.677
		Case "BE_PETIT_AIGLE"
			$_PageWidth = 1700.787
			$_PageHeight = 2381.102
		Case "BE_GRAND_JESUS"
			$_PageWidth = 1559.055
			$_PageHeight = 2069.291
		Case "BE_JESUS"
			$_PageWidth = 1530.709
			$_PageHeight = 2069.291
		Case "BE_RAISIN"
			$_PageWidth = 1417.323
			$_PageHeight = 1842.520
		Case "BE_GRAND_MEDIAN"
			$_PageWidth = 1303.937
			$_PageHeight = 1714.961
		Case "BE_DOUBLE_POSTE"
			$_PageWidth = 1233.071
			$_PageHeight = 1601.575
		Case "BE_COQUILLE"
			$_PageWidth = 1218.898
			$_PageHeight = 1587.402
		Case "BE_PETIT_MEDIAN"
			$_PageWidth = 1176.378
			$_PageHeight = 1502.362
		Case "BE_RUCHE"
			$_PageWidth = 1020.472
			$_PageHeight = 1303.937
		Case "BE_PROPATRIA"
			$_PageWidth = 977.953
			$_PageHeight = 1218.898
		Case "BE_LYS"
			$_PageWidth = 898.583
			$_PageHeight = 1125.354
		Case "BE_POT"
			$_PageWidth = 870.236
			$_PageHeight = 1088.504
		Case "BE_ROSETTE"
			$_PageWidth = 765.354
			$_PageHeight = 983.622
		Case "FR_UNIVERS"
			$_PageWidth = 2834.646
			$_PageHeight = 3685.039
		Case "FR_DOUBLE_COLOMBIER"
			$_PageWidth = 2551.181
			$_PageHeight = 3571.654
		Case "FR_GRANDE_MONDE"
			$_PageWidth = 2551.181
			$_PageHeight = 3571.654
		Case "FR_DOUBLE_SOLEIL"
			$_PageWidth = 2267.717
			$_PageHeight = 3401.575
		Case "FR_DOUBLE_JESUS"
			$_PageWidth = 2154.331
			$_PageHeight = 3174.803
		Case "FR_GRAND_AIGLE"
			$_PageWidth = 2125.984
			$_PageHeight = 3004.724
		Case "FR_PETIT_AIGLE"
			$_PageWidth = 1984.252
			$_PageHeight = 2664.567
		Case "FR_DOUBLE_RAISIN"
			$_PageWidth = 1842.520
			$_PageHeight = 2834.646
		Case "FR_JOURNAL"
			$_PageWidth = 1842.520
			$_PageHeight = 2664.567
		Case "FR_COLOMBIER_AFFICHE"
			$_PageWidth = 1785.827
			$_PageHeight = 2551.181
		Case "FR_DOUBLE_CAVALIER"
			$_PageWidth = 1757.480
			$_PageHeight = 2607.874
		Case "FR_CLOCHE"
			$_PageWidth = 1700.787
			$_PageHeight = 2267.717
		Case "FR_SOLEIL"
			$_PageWidth = 1700.787
			$_PageHeight = 2267.717
		Case "FR_DOUBLE_CARRE"
			$_PageWidth = 1587.402
			$_PageHeight = 2551.181
		Case "FR_DOUBLE_COQUILLE"
			$_PageWidth = 1587.402
			$_PageHeight = 2494.488
		Case "FR_JESUS"
			$_PageWidth = 1587.402
			$_PageHeight = 2154.331
		Case "FR_RAISIN"
			$_PageWidth = 1417.323
			$_PageHeight = 1842.520
		Case "FR_CAVALIER"
			$_PageWidth = 1303.937
			$_PageHeight = 1757.480
		Case "FR_DOUBLE_COURONNE"
			$_PageWidth = 1303.937
			$_PageHeight = 2040.945
		Case "FR_CARRE"
			$_PageWidth = 1275.591
			$_PageHeight = 1587.402
		Case "FR_COQUILLE"
			$_PageWidth = 1247.244
			$_PageHeight = 1587.402
		Case "FR_DOUBLE_TELLIERE"
			$_PageWidth = 1247.244
			$_PageHeight = 1927.559
		Case "FR_DOUBLE_CLOCHE"
			$_PageWidth = 1133.858
			$_PageHeight = 1700.787
		Case "FR_DOUBLE_POT"
			$_PageWidth = 1133.858
			$_PageHeight = 1757.480
		Case "FR_ECU"
			$_PageWidth = 1133.858
			$_PageHeight = 1474.016
		Case "FR_COURONNE"
			$_PageWidth = 1020.472
			$_PageHeight = 1303.937
		Case "FR_TELLIERE"
			$_PageWidth = 963.780
			$_PageHeight = 1247.244
		Case "FR_POT"
			$_PageWidth = 878.740
			$_PageHeight = 1133.858
		Case "CUSTOM"
			If $iWidth = -1 Or $iHeight = -1 Then
				$_PageWidth = 595.276
				$_PageHeight = 841.890
			Else
				$_PageWidth = $iWidth
				$_PageHeight = $iHeight
			EndIf
		Case Else
			$_PageWidth = 595.2
			$_PageHeight = 842
	EndSwitch
EndFunc   ;==>_SetPaperSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetSubject
; Description ...: Set the subject of the pdf
; Syntax ........: _SetSubject( [ $sSubject ] )
; Parameters ....: $sSubject            - [optional]  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......: See the properties of the pdf
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetSubject($sSubject = "")
	$PDF_SUBJECT = $sSubject
EndFunc   ;==>_SetSubject

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetTextHorizontalScaling
; Description ...: The horizontal scaling parameter adjusts the width of glyphs by stretching or
;					shrinking them in the horizontal direction. Its value is specified as a percentage of
;					the normal width of the glyphs, with 100 being the normal width. The scaling
;					always applies to the  x coordinate in text space, independently of the writing mode.
; Syntax ........: _SetTextHorizontalScaling($iW)
; Parameters ....: $iW                   -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetTextHorizontalScaling($iW)
	$_TextScaling = $iW
	__ToBuffer(__ToStr($_TextScaling) & " Tz")
	Return $_TextScaling
EndFunc   ;==>_SetTextHorizontalScaling

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetTextRenderingMode
; Description ...: The text rendering mode determines whether showing text causes glyph
;					outlines to be stroked, filled, used as a clipping path, or some combination of
;					these operations.
; Syntax ........: _SetTextRenderingMode( [ $iW ] )
; Parameters ....: $iW                   - [optional]  integer value.
;					|0	-	Fill text.
;					|1	-	Stroke text.
;					|2	-	Fill, then stroke, text.
;					|3	-	Neither fill nor stroke text (invisible).
;					|4	-	Fill text and add to path for clipping (see above).
;					|5	-	Stroke text and add to path for clipping.
;					|6	-	Fill, then stroke, text and add to path for clipping.
;					|7	-	Add text to path for clipping.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetTextRenderingMode($iW = 0)
	If ($iW >= 0) And ($iW <= 7) Then __ToBuffer(__ToStr($iW) & " Tr")
EndFunc   ;==>_SetTextRenderingMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetTextRiseMode
; Description ...: Specifies the distance, in unscaled text space units, to move the
; 					baseline up or down from its default location. Positive values of text rise move the
;					baseline up. Adjustments to the baseline are useful for drawing superscripts or
;					subscripts. The default location of the baseline can be restored by setting the text
;					rise to 0. Text rise always applies to the y coordinate in text space, regardless of the writing mode.
; Syntax ........: _SetTextRiseMode($iW)
; Parameters ....: $iW                   -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetTextRiseMode($iW)
	__ToBuffer(__ToStr($iW) & " Ts")
EndFunc   ;==>_SetTextRiseMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetTitle
; Description ...: Set the title property of the pdf
; Syntax ........: _SetTitle( [ $sTitle ] )
; Parameters ....: $sTitle              - [optional]  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetTitle($sTitle = "")
	$PDF_TITLE = $sTitle
EndFunc   ;==>_SetTitle

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetUnit
; Description ...: Set the unit used in pdf
; Syntax ........: _SetUnit( [ $sUnit = $PDF_UNIT_CM ] )
; Parameters ....: $sUnit
;					|$PDF_UNIT_PT or 1
;					|$PDF_UNIT_INCH or 2
;					|$PDF_UNIT_MM or 4
;					|$PDF_UNIT_CM or 8
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetUnit($sUnit = $PDF_UNIT_CM)
	$__SetUnit = $sUnit
EndFunc   ;==>_SetUnit

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetWordSpacing
; Description ...: Set the space between words
; Syntax ........: _SetWordSpacing($iW)
; Parameters ....: $iW                   -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetWordSpacing($iW)
	$_WordSpacing = $iW
	__ToBuffer(__ToStr($_WordSpacing) & " Tw")
EndFunc   ;==>_SetWordSpacing

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetZoomMode
; Description ...: Set the zoom when the pdf is opened
; Syntax ........: _SetZoomMode( $sZmd [, $iZoom ] )
; Parameters ....: $sZmd                -  zoom mode
;					|$PDF_ZOOM_FULLPAGE
;					|$PDF_ZOOM_FULLWIDTH
;					|$PDF_ZOOM_REAL
;					|$PDF_ZOOM_DEFAULT
;					|$PDF_ZOOM_CUSTOM - in that case put the percentage on $iZoom
;                  $iZoom               - [optional]  integer value.
; Return values .: $_ZoomMode
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetZoomMode($sZmd, $iZoom = 100)
	Switch $sZmd
		Case $PDF_ZOOM_FULLPAGE, $PDF_ZOOM_FULLWIDTH, $PDF_ZOOM_REAL, $PDF_ZOOM_DEFAULT
			$_ZoomMode = $sZmd
		Case $PDF_ZOOM_CUSTOM
			$_ZoomMode = $iZoom
		Case Else
			$_ZoomMode = $PDF_ZOOM_FULLPAGE
	EndSwitch
EndFunc   ;==>_SetZoomMode

; #FUNCTION# ====================================================================================================================
; Name ..........: _StartObject
; Description ...: Initialize an object (e.g. image, header, text...) to be inserted on the pdf.
; Syntax ........: _StartObject( $sAlias [, $Opt ] )
; Parameters ....: $sName               -  string value.
;                  $Opt                 - [optional]  .
;					|$PDF_OBJECT_FIRSTPAGE
;					|$PDF_OBJECT_ALLPAGES
;					|$PDF_OBJECT_EVENPAGES
;					|$PDF_OBJECT_ODDPAGES
;					|$PDF_OBJECT_NOTFIRSTPAGE
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......: Always close it with _EndObject()
; Related .......: _EndObject()
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _StartObject($sAlias, $Opt = $PDF_OBJECT_NONE)
	Local $i = __InitObj()
	__ToBuffer("<< /Type /XObject /Subtype /Form /FormType 1 /Name /" & $sAlias & " /BBox [" & __ToStr($__SetMargin) & " " & __ToStr($__SetMargin) & " " & __ToStr($_PageWidth - $__SetMargin) & " " & __ToStr($_PageHeight - $__SetMargin) & "] /Matrix [1 0 0 1 0 0]"&chr(10)&"/Length >>stream")
	$_iTmpOffset = $_Offset
	$_sObject = $_sObject & "/" & $sAlias & " " & $i & " 0 R " & chr(10)
	$_iObject = $_iObject + 1
	ReDim $aOBJECTS[$_iObject]
	For $_iObject In $aOBJECTS
		$PDF_OBJECT_NAME = $sAlias
		$PDF_OBJECT_OPTIONS = $Opt
	Next
EndFunc   ;==>_StartObject

; #FUNCTION# ====================================================================================================================
; Name ..........: _DrawArc
; Description ...: Draw arc
; Syntax ........: _DrawArc( $iX , $iY , $iRadius [, $iStartAngle [, $iEndAngle [, $iRatio [, $bPie [, $iRotate [, $iQuality [,
;                  $sOptions = $PDF_STYLE_STROKED ]]]]]]] )
; Parameters ....: $iX                  -  integer value.
;                  $iY                  -  integer value.
;                  $iRadius             -  integer value.
;                  $iStartAngle         - [optional]  integer value.
;                  $iEndAngle           - [optional]  integer value.
;                  $iRatio              - [optional]  integer value.
;                  $bPie                - [optional]  bool value.
;                  $iRotate             - [optional]  integer value.
;                  $iQuality            - [optional]  integer value.
;                  $sOptions            - [optional]  string value.
;                  $PDF_STYLE_STROKED   -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _DrawArc($iX, $iY, $iRadius, $iStartAngle = 0, $iEndAngle = 360, $iRatio = 1, $bPie = False, $iRotate = 0, $iQuality = 1, $sOptions = $PDF_STYLE_STROKED)
	Local $i
	Local $rad
	Local $PI
	Local $sTeta
	Local $cTeta
	Local $C
	Local $iX1, $iX2
	Local $iY1, $iY2
	__ToBuffer("n")
	_MoveTo($iX, $iY)
	If ($sOptions And $PDF_STYLE_FILLED) <> 0 Then $bPie = True
	$PI = 3.141592
	$C = $PI / 180
	$sTeta = Sin(-$C * $iRotate)
	$cTeta = Cos(-$C * $iRotate)
	For $i = $iStartAngle To $iEndAngle Step $iQuality
		$rad = $C * $i
		$iX2 = $iRadius * Cos($rad)
		$iY2 = ($iRadius * $iRatio) * Sin($rad)
		$iX1 = $iX2 * $cTeta + $iY2 * $sTeta
		$iY1 = -$iX2 * $sTeta + $iY2 * $cTeta
		If ($i = $iStartAngle) And (Not $bPie) Then _MoveTo($iX + $iX1, $iY + $iY1)
		_LineTo($iX + $iX1, $iY + $iY1, $PDF_STYLE_NONE)
	Next
	If $bPie Then _LineTo($iX, $iY, $PDF_STYLE_NONE)
	_Path($sOptions)
EndFunc   ;==>_DrawArc

; ===============================================================================================================================
; ===============================================================================================================================
; ===============================================================================================================================
Func __Curve($iX1, $iY1, $iX2, $iY2, $iX3, $iY3, $sOptions = $PDF_STYLE_STROKED)
	__ToBuffer(__ToStr(__ToSpace($iX1)) & " " & __ToStr(__ToSpace($iY1)) & " " & __ToStr(__ToSpace($iX2)) & " " & __ToStr(__ToSpace($iY2)) & " " & __ToStr(__ToSpace($iX3)) & " " & __ToStr(__ToSpace($iY3)) & " c")
	_Path($sOptions)
EndFunc   ;==>__Curve

; #FUNCTION# ====================================================================================================================
; Name ..........: _MoveTo
; Description ...: Begin new subpath
; Syntax ........: _MoveTo( $x , $y  )
; Parameters ....: $x                   -  unknown value.
;                  $y                   -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _MoveTo($x, $y)
	__ToBuffer(__ToStr(__ToSpace($x)) & " " & __ToStr(__ToSpace($y)) & " m")
EndFunc   ;==>_MoveTo

; #FUNCTION# ====================================================================================================================
; Name ..........: _Pages
; Description ...: Return number of pages
; Syntax ........: _Pages(  )
; Parameters ....: None
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _Pages()
	Return $_Pages
EndFunc   ;==>_Pages

; #FUNCTION# ====================================================================================================================
; Name ..........: _Path
; Description ...: Paths define shapes, trajectories, and regions of all sorts. They are used to draw
;					lines, define the shapes of filled areas, and specify boundaries for clipping other
;					graphics.
; Syntax ........: _Path( [ $sStyle = $PDF_STYLE_NONE ] )
; Parameters ....: $sStyle              - [optional]  string value.
;                  |See the $PDF_STYLE_~ constants
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _Path($sStyle = $PDF_STYLE_NONE)
	If ($sStyle And ($PDF_STYLE_FILLED Or $PDF_STYLE_STROKED Or $PDF_STYLE_CLOSED)) = ($PDF_STYLE_FILLED Or $PDF_STYLE_STROKED Or $PDF_STYLE_CLOSED) Then
		__ToBuffer("b")
	ElseIf ($sStyle And ($PDF_STYLE_FILLED Or $PDF_STYLE_STROKED)) = ($PDF_STYLE_FILLED Or $PDF_STYLE_STROKED) Then
		__ToBuffer("B")
	ElseIf ($sStyle And $PDF_STYLE_FILLED) = $PDF_STYLE_FILLED Then
		__ToBuffer("f")
	Else
		If ($sStyle And $PDF_STYLE_CLOSED) <> 0 Then __ToBuffer("h")
		If ($sStyle And $PDF_STYLE_STROKED) <> 0 Then __ToBuffer("S")
	EndIf
EndFunc   ;==>_Path

; #FUNCTION# ====================================================================================================================
; Name ..........: _SetLineWidth
; Description ...: Set the line width
; Syntax ........: _SetLineWidth( $iW  )
; Parameters ....: $iW                   -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/118827-create-pdf-from-your-application/
; Example .......: No
; ===============================================================================================================================
Func _SetLineWidth($iW)
	__ToBuffer(__ToStr(__ToSpace($iW)) & " w")
EndFunc   ;==>_SetLineWidth
#region FUNCTIONS
#region #INTERNAL_USE_ONLY#
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __DrawObject
; Description ...:
; Syntax ........: __DrawObject( $sName  )
; Parameters ....: $sName               -  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __DrawObject($sName)
	If $sName<>"" Then __ToBuffer("/" & $sName & " Do")
EndFunc   ;==>__DrawObject

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __EndObj
; Description ...:
; Syntax ........: __EndObj(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __EndObj()
	$_Buffer &= "endobj" & chr(10)
EndFunc   ;==>__EndObj

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __Error
; Description ...:
; Syntax ........: __Error( $sErr , $iLne  )
; Parameters ....: $sErr                -  string value.
;                  $iLne                -  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __Error($sErr, $iLne)
	MsgBox(16, "PDF Error", "You have an error on line " & $iLne & "." & chr(10) & "Reason: " & $sErr & chr(10) & "Press OK to exit.")
	Exit
EndFunc   ;==>__Error

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __FontArial
; Description ...:
; Syntax ........: __FontArial( [ $Style , $PDF_FONT_NORMAL ] )
; Parameters ....: $Style               - [optional]  unknown value.
;                  $PDF_FONT_NORMAL     -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __FontArial($Style = $PDF_FONT_NORMAL)
	$BaseFont = "Arial"
	$FirstChar = 32
	$LastChar = 255
	$MissingWidth = 272
	Local $aTemp[$LastChar - $FirstChar]; + 1]
	Switch $Style
		Case $PDF_FONT_NORMAL
			$aTemp = StringSplit("278, 278, 355, 556, 556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, " & _
			"556, 556, 556, 556, 556, 556, 278, 278, 584, 584, 584, 556, 1015, 667, 667, 722, 722, 667, 611, 778, 722, 278, 500, 667, " & _
			"556, 833, 722, 778, 667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 278, 278, 278, 469, 556, 333, 556, 556, 500, " & _
			"556, 556, 278, 556, 556, 222, 222, 500, 222, 833, 556, 556, 556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, " & _
			"260, 334, 584, 750, 556, 750, 222, 556, 333, 1000, 556, 556, 333, 1000, 667, 333, 1000, 750, 611, 750, 750, 222, 222, 333, " & _
			"333, 350, 556, 1000, 333, 1000, 500, 333, 944, 750, 500, 667, 278, 333, 556, 556, 556, 556, 260, 556, 333, 737, 370, 556, 584, " & _
			"333, 737, 552, 400, 549, 333, 333, 333, 576, 537, 278, 333, 333, 365, 556, 834, 834, 834, 611, 667, 667, 667, 667, 667, 667, " & _
			"1000, 722, 667, 667, 667, 667, 278, 278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584, 778, 722, 722, 722, 722, 667, 667, " & _
			"611, 556, 556, 556, 556, 556, 556, 889, 500, 556, 556, 556, 556, 278, 278, 278, 278, 556, 556, 556, 556, 556, 556, 556, 549, " & _
			"611, 556, 556, 556, 556, 500, 556, 500", ", ", 3)
			$Param = "/Flags 32 /FontBBox [-250 -221 1190 1000] " & _
					"/MissingWidth 272 /StemV 80 " & _
					"/StemH 80 /ItalicAngle 0 /CapHeight 905 /XHeight 453 " & _
					"/Ascent 905 /Descent -212 /Leading 150 " & _
					"/MaxWidth 992 /AvgWidth 441"
		Case $PDF_FONT_BOLD
			$BaseFont = $BaseFont & ",Bold"
			$aTemp = StringSplit("278, 333, 474, 556, 556, 889, 722, 238, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, " & _
			"556, 556, 556, 556, 556, 333, 333, 584, 584, 584, 611, 975, 722, 722, 722, 722, 667, 611, 778, 722, 278, 556, 722, 611, 833, " & _
			"722, 778, 667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 333, 278, 333, 584, 556, 333, 556, 611, 556, 611, 556, 333, " & _
			"611, 611, 278, 278, 556, 278, 889, 611, 611, 611, 611, 389, 556, 333, 611, 556, 778, 556, 556, 500, 389, 280, 389, 584, 750, " & _
			"556, 750, 278, 556, 500, 1000, 556, 556, 333, 1000, 667, 333, 1000, 750, 611, 750, 750, 278, 278, 500, 500, 350, 556, 1000, 333, " & _
			"1000, 556, 333, 944, 750, 500, 667, 278, 333, 556, 556, 556, 556, 280, 556, 333, 737, 370, 556, 584, 333, 737, 552, 400, 549, 333, " & _
			"333, 333, 576, 556, 278, 333, 333, 365, 556, 834, 834, 834, 611, 722, 722, 722, 722, 722, 722, 1000, 722, 667, 667, 667, 667, 278, " & _
			"278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584, 778, 722, 722, 722, 722, 667, 667, 611, 556, 556, 556, 556, 556, 556, 889, 556, " & _
			"556, 556, 556, 556, 278, 278, 278, 278, 611, 611, 611, 611, 611, 611, 611, 549, 611, 611, 611, 611, 611, 556, 611, 556", ", ", 3)
			$Param = "/Flags 16416 /FontBBox [-250 -212 1120 1000] " & _
					"/MissingWidth 311 /StemV 153 " & _
					"/StemH 153 /ItalicAngle 0 /CapHeight 905 /XHeight 453 " & _
					"/Ascent 905 /Descent -212 /Leading 150 " & _
					"/MaxWidth 933 /AvgWidth 479"
			$MissingWidth = 311
		Case $PDF_FONT_ITALIC
			$BaseFont = $BaseFont & ",Italic"
			$aTemp = StringSplit("278, 278, 355, 556, 556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, 556, 556, " & _
			"556, 556, 556, 278, 278, 584, 584, 584, 556, 1015, 667, 667, 722, 722, 667, 611, 778, 722, 278, 500, 667, 556, 833, 722, 778, 667, 778, " & _
			"722, 667, 611, 722, 667, 944, 667, 667, 611, 278, 278, 278, 469, 556, 333, 556, 556, 500, 556, 556, 278, 556, 556, 222, 222, 500, 222, 833, " & _
			"556, 556, 556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, 260, 334, 584, 750, 556, 750, 222, 556, 333, 1000, 556, 556, 333, 1000, " & _
			"667, 333, 1000, 750, 611, 750, 750, 222, 222, 333, 333, 350, 556, 1000, 333, 1000, 500, 333, 944, 750, 500, 667, 278, 333, 556, 556, 556, 556, " & _
			"260, 556, 333, 737, 370, 556, 584, 333, 737, 552, 400, 549, 333, 333, 333, 576, 537, 278, 333, 333, 365, 556, 834, 834, 834, 611, 667, 667, 667, " & _
			"667, 667, 667, 1000, 722, 667, 667, 667, 667, 278, 278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584, 778, 722, 722, 722, 722, 667, 667, 611, " & _
			"556, 556, 556, 556, 556, 556, 889, 500, 556, 556, 556, 556, 278, 278, 278, 278, 556, 556, 556, 556, 556, 556, 556, 549, 611, 556, 556, 556, 556, " & _
			"500, 556, 500", ", ", 3)
			$Param = "/Flags 96 /FontBBox [-250 -212 1134 1000] " & _
					"/MissingWidth 259 /StemV 80 " & _
					"/StemH 80 /ItalicAngle -11 /CapHeight 905 /XHeight 453 " & _
					"/Ascent 905 /Descent -212 /Leading 150 " & _
					"/MaxWidth 945 /AvgWidth 441"
			$MissingWidth = 259
		Case $PDF_FONT_BOLDITALIC
			$BaseFont = $BaseFont & ",BoldItalic"
			$aTemp = StringSplit("278, 333, 474, 556, 556, 889, 722, 238, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, 556, 556, 556, 556, " & _
			"556, 333, 333, 584, 584, 584, 611, 975, 722, 722, 722, 722, 667, 611, 778, 722, 278, 556, 722, 611, 833, 722, 778, 667, 778, 722, 667, 611, 722, " & _
			"667, 944, 667, 667, 611, 333, 278, 333, 584, 556, 333, 556, 611, 556, 611, 556, 333, 611, 611, 278, 278, 556, 278, 889, 611, 611, 611, 611, 389, " & _
			"556, 333, 611, 556, 778, 556, 556, 500, 389, 280, 389, 584, 750, 556, 750, 278, 556, 500, 1000, 556, 556, 333, 1000, 667, 333, 1000, 750, 611, 750, " & _
			"750, 278, 278, 500, 500, 350, 556, 1000, 333, 1000, 556, 333, 944, 750, 500, 667, 278, 333, 556, 556, 556, 556, 280, 556, 333, 737, 370, 556, 584, " & _
			"333, 737, 552, 400, 549, 333, 333, 333, 576, 556, 278, 333, 333, 365, 556, 834, 834, 834, 611, 722, 722, 722, 722, 722, 722, 1000, 722, 667, 667, " & _
			"667, 667, 278, 278, 278, 278, 722, 722, 778, 778, 778, 778, 778, 584, 778, 722, 722, 722, 722, 667, 667, 611, 556, 556, 556, 556, 556, 556, 889, " & _
			"556, 556, 556, 556, 556, 278, 278, 278, 278, 611, 611, 611, 611, 611, 611, 611, 549, 611, 611, 611, 611, 611, 556, 611, 556", ", ", 3)
			$Param = "/Flags 16480 /FontBBox [-250 -212 1120 1000] " & _
					"/MissingWidth 311 /StemV 153 " & _
					"/StemH 153 /ItalicAngle -11 /CapHeight 905 /XHeight 453 " & _
					"/Ascent 905 /Descent -212 /Leading 150 " & _
					"/MaxWidth 933 /AvgWidth 479"
			$MissingWidth = 311
	EndSwitch
	For $i = $FirstChar To $LastChar
		$Widths[$i] = $aTemp[$i - $FirstChar]
	Next
	Local $aRetTmp[6] = [$BaseFont, $FirstChar, $LastChar, $Param, $Widths, $MissingWidth]
	Return $aRetTmp
EndFunc   ;==>__FontArial

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __FontCalibri
; Description ...:
; Syntax ........: __FontCalibri( [ $Style , $PDF_FONT_NORMAL ] )
; Parameters ....: $Style               - [optional]  unknown value.
;                  $PDF_FONT_NORMAL     -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __FontCalibri($Style = $PDF_FONT_NORMAL)
	$BaseFont = "Calibri"
	$FirstChar = 32
	$LastChar = 255
	$MissingWidth = 333
	Local $aTemp[$LastChar - $FirstChar]; + 1]
	Switch $Style
		Case $PDF_FONT_NORMAL
			$aTemp = StringSplit("226, 326, 401, 498, 507, 715, 682, 221, 303, 303, 498, 498, 250, 306, 252, 386, 507, 507, 507, 507, 507, 507, 507, 507, " & _
			"507, 507, 268, 268, 498, 498, 498, 463, 894, 579, 544, 533, 615, 488, 459, 631, 623, 252, 319, 520, 420, 855, 646, 662, 517, 673, 543, 459, " & _
			"487, 642, 567, 890, 519, 487, 468, 307, 386, 307, 498, 498, 291, 479, 525, 423, 525, 498, 305, 471, 525, 230, 239, 455, 230, 799, 525, 527, " & _
			"525, 525, 349, 391, 335, 525, 452, 715, 433, 453, 395, 314, 460, 314, 498, 507, 507, 507, 250, 305, 418, 690, 498, 498, 395, 1038, 459, 339, " & _
			"867, 507, 507, 507, 507, 250, 250, 418, 418, 498, 498, 905, 450, 705, 391, 339, 850, 507, 507, 487, 226, 326, 498, 507, 498, 507, 498, 498, " & _
			"393, 834, 402, 512, 498, 306, 507, 394, 339, 498, 336, 334, 292, 550, 586, 252, 307, 246, 422, 512, 636, 671, 675, 463, 579, 579, 579, 579, " & _
			"579, 579, 763, 533, 488, 488, 488, 488, 252, 252, 252, 252, 631, 646, 662, 662, 662, 662, 662, 498, 664, 642, 642, 642, 642, 252, 459, 527, " & _
			"479, 479, 479, 479, 479, 479, 773, 423, 498, 498, 498, 498, 230, 230, 230, 230, 471, 525, 527, 527, 527, 527, 527, 498, 529, 525, 525, 525, " & _
			"525, 230, 391, 453", ", ", 3)
			$Param = "/Flags 32/FontBBox[ -503 -307 1240 964] " & _
					"/MissingWidth 333/StemV 80/StemH 80/ItalicAngle 0/CapHeight 500" & _
					"/Ascent 964/Descent -307/MaxWidth 1000/AvgWidth 401"
		Case $PDF_FONT_BOLD
			$BaseFont = $BaseFont & ",Bold"
			$aTemp = StringSplit("226, 326, 401, 498, 507, 715, 682, 221, 303, 303, 498, 498, 250, 306, 252, 386, 507, 507, 507, 507, 507, 507, 507, 507, " & _
			"507, 507, 268, 268, 498, 498, 498, 463, 894, 579, 544, 533, 615, 488, 459, 631, 623, 252, 319, 520, 420, 855, 646, 662, 517, 673, 543, 459, " & _
			"487, 642, 567, 890, 519, 487, 468, 307, 386, 307, 498, 498, 291, 479, 525, 423, 525, 498, 305, 471, 525, 230, 239, 455, 230, 799, 525, 527, " & _
			"525, 525, 349, 391, 335, 525, 452, 715, 433, 453, 395, 314, 460, 314, 498, 507, 507, 507, 250, 305, 418, 690, 498, 498, 395, 1038, 459, 339, " & _
			"867, 507, 507, 507, 507, 250, 250, 418, 418, 498, 498, 905, 450, 705, 391, 339, 850, 507, 507, 487, 226, 326, 498, 507, 498, 507, 498, 498, " & _
			"393, 834, 402, 512, 498, 306, 507, 394, 339, 498, 336, 334, 292, 550, 586, 252, 307, 246, 422, 512, 636, 671, 675, 463, 579, 579, 579, 579, " & _
			"579, 579, 763, 533, 488, 488, 488, 488, 252, 252, 252, 252, 631, 646, 662, 662, 662, 662, 662, 498, 664, 642, 642, 642, 642, 252, 459, 527, " & _
			"479, 479, 479, 479, 479, 479, 773, 423, 498, 498, 498, 498, 230, 230, 230, 230, 471, 525, 527, 527, 527, 527, 527, 498, 529, 525, 525, 525, " & _
			"525, 230, 391, 453", ", ", 3)
			$Param = "/Flags 16418/FontBBox[ -503 -307 1240 964] " & _
					"/MissingWidth 333/StemV 136/StemH 136/ItalicAngle 0/CapHeight 891" & _
					"/Ascent 964/Descent -307/Leading 149/MaxWidth 1001/AvgWidth 401"
		Case $PDF_FONT_ITALIC
			$BaseFont = $BaseFont & ",Italic"
			$aTemp = StringSplit("226, 326, 401, 498, 507, 715, 682, 221, 303, 303, 498, 498, 250, 306, 252, 386, 507, 507, 507, 507, 507, 507, 507, 507, " & _
			"507, 507, 268, 268, 498, 498, 498, 463, 894, 579, 544, 533, 615, 488, 459, 631, 623, 252, 319, 520, 420, 855, 646, 662, 517, 673, 543, 459, " & _
			"487, 642, 567, 890, 519, 487, 468, 307, 386, 307, 498, 498, 291, 479, 525, 423, 525, 498, 305, 471, 525, 230, 239, 455, 230, 799, 525, 527, " & _
			"525, 525, 349, 391, 335, 525, 452, 715, 433, 453, 395, 314, 460, 314, 498, 507, 507, 507, 250, 305, 418, 690, 498, 498, 395, 1038, 459, 339, " & _
			"867, 507, 507, 507, 507, 250, 250, 418, 418, 498, 498, 905, 450, 705, 391, 339, 850, 507, 507, 487, 226, 326, 498, 507, 498, 507, 498, 498, " & _
			"393, 834, 402, 512, 498, 306, 507, 394, 339, 498, 336, 334, 292, 550, 586, 252, 307, 246, 422, 512, 636, 671, 675, 463, 579, 579, 579, 579, " & _
			"579, 579, 763, 533, 488, 488, 488, 488, 252, 252, 252, 252, 631, 646, 662, 662, 662, 662, 662, 498, 664, 642, 642, 642, 642, 252, 459, 527, " & _
			"479, 479, 479, 479, 479, 479, 773, 423, 498, 498, 498, 498, 230, 230, 230, 230, 471, 525, 527, 527, 527, 527, 527, 498, 529, 525, 525, 525, " & _
			"525, 230, 391, 453", ", ", 3)
			$Param = "/Flags 98 /FontBBox[ -503 -307 1240 964] " & _
					"/MissingWidth 333/StemV 73/StemH 73/ItalicAngle -11/CapHeight 891" & _
					"/Ascent 964/Descent -307/Leading 149/MaxWidth 1000/AvgWidth 402"
		Case $PDF_FONT_BOLDITALIC
			$BaseFont = $BaseFont & ",BoldItalic"
			$aTemp = StringSplit("226, 326, 401, 498, 507, 715, 682, 221, 303, 303, 498, 498, 250, 306, 252, 386, 507, 507, 507, 507, 507, 507, 507, 507, " & _
			"507, 507, 268, 268, 498, 498, 498, 463, 894, 579, 544, 533, 615, 488, 459, 631, 623, 252, 319, 520, 420, 855, 646, 662, 517, 673, 543, 459, " & _
			"487, 642, 567, 890, 519, 487, 468, 307, 386, 307, 498, 498, 291, 479, 525, 423, 525, 498, 305, 471, 525, 230, 239, 455, 230, 799, 525, 527, " & _
			"525, 525, 349, 391, 335, 525, 452, 715, 433, 453, 395, 314, 460, 314, 498, 507, 507, 507, 250, 305, 418, 690, 498, 498, 395, 1038, 459, 339, " & _
			"867, 507, 507, 507, 507, 250, 250, 418, 418, 498, 498, 905, 450, 705, 391, 339, 850, 507, 507, 487, 226, 326, 498, 507, 498, 507, 498, 498, " & _
			"393, 834, 402, 512, 498, 306, 507, 394, 339, 498, 336, 334, 292, 550, 586, 252, 307, 246, 422, 512, 636, 671, 675, 463, 579, 579, 579, 579, " & _
			"579, 579, 763, 533, 488, 488, 488, 488, 252, 252, 252, 252, 631, 646, 662, 662, 662, 662, 662, 498, 664, 642, 642, 642, 642, 252, 459, 527, " & _
			"479, 479, 479, 479, 479, 479, 773, 423, 498, 498, 498, 498, 230, 230, 230, 230, 471, 525, 527, 527, 527, 527, 527, 498, 529, 525, 525, 525, " & _
			"525, 230, 391, 453", ", ", 3)
			$Param = "/Flags 16482 /FontBBox[ -503 -307 1240 964] " & _
					"/MissingWidth 333 /StemV 131/StemH 131 /ItalicAngle -11 /CapHeight 891 " & _
					"/Ascent 964 /Descent -307/Leading 149/MaxWidth 1000/AvgWidth 412"
	EndSwitch
	For $i = $FirstChar To $LastChar
		$Widths[$i] = $aTemp[$i - $FirstChar]
	Next
	Local $aRetTmp[6] = [$BaseFont, $FirstChar, $LastChar, $Param, $Widths, $MissingWidth]
	Return $aRetTmp
EndFunc   ;==>__FontCalibri

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __FontGaramond
; Description ...:
; Syntax ........: __FontGaramond( [ $Style , $PDF_FONT_NORMAL ] )
; Parameters ....: $Style               - [optional]  unknown value.
;                  $PDF_FONT_NORMAL     -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __FontGaramond($sOptions = $PDF_FONT_NORMAL)
	$BaseFont = "Garamond"
	$FirstChar = 32
	$LastChar = 255
	$MissingWidth = 333
	Local $aTemp[$LastChar - $FirstChar]; + 1]
	Switch $sOptions
		Case $PDF_FONT_NORMAL
			$aTemp = StringSplit("250, 219, 406, 667, 448, 823, 729, 177, 292, 292, 427, 667, 219, 313, 219, 500, 469, 469, 469, 469, 469, 469, 469, 469, 469, " & _
			"469, 219, 219, 667, 667, 667, 365, 917, 677, 615, 635, 771, 656, 563, 771, 760, 354, 333, 740, 573, 833, 771, 781, 563, 771, 625, 479, 615, 708, " & _
			"677, 885, 698, 656, 656, 271, 500, 271, 500, 500, 333, 406, 510, 417, 500, 417, 323, 448, 510, 229, 229, 469, 229, 771, 510, 510, 510, 490, 333, " & _
			"365, 292, 490, 469, 667, 458, 417, 427, 479, 500, 479, 667, 750, 469, 750, 219, 615, 448, 1000, 427, 427, 333, 1021, 479, 198, 938, 750, 750, 750, " & _
			"750, 219, 219, 448, 448, 354, 500, 1000, 333, 979, 365, 198, 698, 750, 750, 656, 250, 219, 417, 573, 677, 656, 500, 427, 333, 760, 260, 365, 667, " & _
			"313, 760, 500, 396, 667, 313, 313, 333, 500, 448, 333, 333, 313, 333, 365, 813, 813, 823, 365, 677, 677, 677, 677, 677, 677, 854, 635, 656, 656, " & _
			"656, 656, 354, 354, 354, 354, 771, 771, 781, 781, 781, 781, 781, 667, 781, 708, 708, 708, 708, 354, 479, 500, 406, 406, 406, 406, 406, 406, 583, " & _
			"417, 417, 417, 417, 417, 229, 229, 229, 229, 448, 510, 510, 510, 510, 510, 510, 549, 510, 490, 490, 490, 490, 229, 365, 417", ", ", 3)
			$Param = "/Flags 34/FontBBox[ -139 -307 1063 986]" & _
					"/MissingWidth 333/StemV 80" & _
					"/StemH 80/ItalicAngle 0/CapHeight 500" & _
					"/Ascent 986/Descent -307" & _
					"/MaxWidth 1000 /AvgWidth 401"
		Case $PDF_FONT_BOLD
			$BaseFont = $BaseFont & ",Bold"
			$aTemp = StringSplit("250, 219, 406, 667, 448, 823, 729, 177, 292, 292, 427, 667, 219, 313, 219, 500, 469, 469, 469, 469, 469, 469, 469, 469, 469, " & _
			"469, 219, 219, 667, 667, 667, 365, 917, 677, 615, 635, 771, 656, 563, 771, 760, 354, 333, 740, 573, 833, 771, 781, 563, 771, 625, 479, 615, 708, " & _
			"677, 885, 698, 656, 656, 271, 500, 271, 500, 500, 333, 406, 510, 417, 500, 417, 323, 448, 510, 229, 229, 469, 229, 771, 510, 510, 510, 490, 333, " & _
			"365, 292, 490, 469, 667, 458, 417, 427, 479, 500, 479, 667, 750, 469, 750, 219, 615, 448, 1000, 427, 427, 333, 1021, 479, 198, 938, 750, 750, 750, " & _
			"750, 219, 219, 448, 448, 354, 500, 1000, 333, 979, 365, 198, 698, 750, 750, 656, 250, 219, 417, 573, 677, 656, 500, 427, 333, 760, 260, 365, 667, " & _
			"313, 760, 500, 396, 667, 313, 313, 333, 500, 448, 333, 333, 313, 333, 365, 813, 813, 823, 365, 677, 677, 677, 677, 677, 677, 854, 635, 656, 656, " & _
			"656, 656, 354, 354, 354, 354, 771, 771, 781, 781, 781, 781, 781, 667, 781, 708, 708, 708, 708, 354, 479, 500, 406, 406, 406, 406, 406, 406, 583, " & _
			"417, 417, 417, 417, 417, 229, 229, 229, 229, 448, 510, 510, 510, 510, 510, 510, 549, 510, 490, 490, 490, 490, 229, 365, 417", ", ", 3)
			$Param = "/Flags 16418 /FontBBox[ -139 -307 1063 986]" & _
					"/MissingWidth 333 /StemV 136" & _
					"/StemH 136/ItalicAngle 0/CapHeight 891" & _
					"/Ascent 986/Descent -307/Leading 149" & _
					"/MaxWidth 1001 /AvgWidth 401"
		Case $PDF_FONT_ITALIC
			$BaseFont = $BaseFont & ",Italic"
			$aTemp = StringSplit("250, 219, 406, 667, 448, 823, 729, 177, 292, 292, 427, 667, 219, 313, 219, 500, 469, 469, 469, 469, 469, 469, 469, 469, 469, " & _
			"469, 219, 219, 667, 667, 667, 365, 917, 677, 615, 635, 771, 656, 563, 771, 760, 354, 333, 740, 573, 833, 771, 781, 563, 771, 625, 479, 615, 708, " & _
			"677, 885, 698, 656, 656, 271, 500, 271, 500, 500, 333, 406, 510, 417, 500, 417, 323, 448, 510, 229, 229, 469, 229, 771, 510, 510, 510, 490, 333, " & _
			"365, 292, 490, 469, 667, 458, 417, 427, 479, 500, 479, 667, 750, 469, 750, 219, 615, 448, 1000, 427, 427, 333, 1021, 479, 198, 938, 750, 750, 750, " & _
			"750, 219, 219, 448, 448, 354, 500, 1000, 333, 979, 365, 198, 698, 750, 750, 656, 250, 219, 417, 573, 677, 656, 500, 427, 333, 760, 260, 365, 667, " & _
			"313, 760, 500, 396, 667, 313, 313, 333, 500, 448, 333, 333, 313, 333, 365, 813, 813, 823, 365, 677, 677, 677, 677, 677, 677, 854, 635, 656, 656, " & _
			"656, 656, 354, 354, 354, 354, 771, 771, 781, 781, 781, 781, 781, 667, 781, 708, 708, 708, 708, 354, 479, 500, 406, 406, 406, 406, 406, 406, 583, " & _
			"417, 417, 417, 417, 417, 229, 229, 229, 229, 448, 510, 510, 510, 510, 510, 510, 549, 510, 490, 490, 490, 490, 229, 365, 417", ", ", 3)
			$Param = "/Flags 98/FontBBox[ -139 -307 1063 986] " & _
					"/MissingWidth 333/StemV 73" & _
					"/StemH 73/ItalicAngle -11/CapHeight 891" & _
					"/Ascent 986/Descent -307/Leading 149" & _
					"/MaxWidth 1000/AvgWidth 402"
		Case $PDF_FONT_BOLDITALIC
			$BaseFont = $BaseFont & ",BoldItalic"
			$aTemp = StringSplit("250, 219, 406, 667, 448, 823, 729, 177, 292, 292, 427, 667, 219, 313, 219, 500, 469, 469, 469, 469, 469, 469, 469, 469, 469, " & _
			"469, 219, 219, 667, 667, 667, 365, 917, 677, 615, 635, 771, 656, 563, 771, 760, 354, 333, 740, 573, 833, 771, 781, 563, 771, 625, 479, 615, 708, " & _
			"677, 885, 698, 656, 656, 271, 500, 271, 500, 500, 333, 406, 510, 417, 500, 417, 323, 448, 510, 229, 229, 469, 229, 771, 510, 510, 510, 490, 333, " & _
			"365, 292, 490, 469, 667, 458, 417, 427, 479, 500, 479, 667, 750, 469, 750, 219, 615, 448, 1000, 427, 427, 333, 1021, 479, 198, 938, 750, 750, 750, " & _
			"750, 219, 219, 448, 448, 354, 500, 1000, 333, 979, 365, 198, 698, 750, 750, 656, 250, 219, 417, 573, 677, 656, 500, 427, 333, 760, 260, 365, 667, " & _
			"313, 760, 500, 396, 667, 313, 313, 333, 500, 448, 333, 333, 313, 333, 365, 813, 813, 823, 365, 677, 677, 677, 677, 677, 677, 854, 635, 656, 656, " & _
			"656, 656, 354, 354, 354, 354, 771, 771, 781, 781, 781, 781, 781, 667, 781, 708, 708, 708, 708, 354, 479, 500, 406, 406, 406, 406, 406, 406, 583, " & _
			"417, 417, 417, 417, 417, 229, 229, 229, 229, 448, 510, 510, 510, 510, 510, 510, 549, 510, 490, 490, 490, 490, 229, 365, 417", ", ", 3)
			$Param = "/Flags 16482/FontBBox[ -139 -307 1063 986]" & _
					"/MissingWidth 333 /StemV 131" & _
					"/StemH 131/ItalicAngle -11/CapHeight 891" & _
					"/Ascent 986/Descent -307/Leading 149" & _
					"/MaxWidth 1000/AvgWidth 412"
	EndSwitch
	For $i = $FirstChar To $LastChar
		$Widths[$i] = $aTemp[$i - $FirstChar]
	Next
	Local $aRetTmp[6] = [$BaseFont, $FirstChar, $LastChar, $Param, $Widths, $MissingWidth]
	Return $aRetTmp
EndFunc   ;==>__FontGaramond

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __FontCourier
; Description ...:
; Syntax ........: __FontCourier( [ $Style , $PDF_FONT_NORMAL ] )
; Parameters ....: $Style               - [optional]  unknown value.
;                  $PDF_FONT_NORMAL     -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __FontCourier($Style = $PDF_FONT_NORMAL)
	$BaseFont = "CourierNew"
	$FirstChar = 32
	$LastChar = 255
	$MissingWidth = 600
	Local $aTemp[$LastChar - $FirstChar]; + 1]
	Switch $Style
		Case $PDF_FONT_NORMAL
			$aTemp = StringSplit("600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600", ", ", 3)
			$Param = "/Flags 34 /FontBBox [-250 -300 720 1000] " & _
					"/MissingWidth 600 /StemV 109 " & _
					"/StemH 109 /ItalicAngle 0 /CapHeight 833 /XHeight 417 " & _
					"/Ascent 833 /Descent -300 /Leading 133 " & _
					"/MaxWidth 600 /AvgWidth 600"
		Case $PDF_FONT_BOLD
			$BaseFont = $BaseFont & ",Bold"
			$aTemp = StringSplit("600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600", ", ", 3)
			$Param = "/Flags 16418 /FontBBox [-250 -300 720 1000] " & _
					"/MissingWidth 600 /StemV 191 " & _
					"/StemH 191 /ItalicAngle 0 /CapHeight 833 /XHeight 417 " & _
					"/Ascent 833 /Descent -300 /Leading 133 " & _
					"/MaxWidth 600 /AvgWidth 600"
		Case $PDF_FONT_ITALIC
			$BaseFont = $BaseFont & ",Italic"
			$aTemp = StringSplit("600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600", ", ", 3)
			$Param = "/Flags 98 /FontBBox [-250 -300 720 1000] " & _
					"/MissingWidth 600 /StemV 109 " & _
					"/StemH 109 /ItalicAngle -11 /CapHeight 833 /XHeight 417 " & _
					"/Ascent 833 /Descent -300 /Leading 133 " & _
					"/MaxWidth 600 /AvgWidth 600"
		Case $PDF_FONT_BOLDITALIC
			$BaseFont = $BaseFont & ",BoldItalic"
			$aTemp = StringSplit("600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600", ", ", 3)
			$Param = "/Flags 16482 /FontBBox [-250 -300 720 1000] " & _
					"/MissingWidth 600 /StemV 191 " & _
					"/StemH 191 /ItalicAngle -11 /CapHeight 833 /XHeight 417 " & _
					"/Ascent 833 /Descent -300 /Leading 133 " & _
					"/MaxWidth 600 /AvgWidth 600"
	EndSwitch
	For $i = $FirstChar To $LastChar
		$Widths[$i] = $aTemp[$i - $FirstChar]
	Next
	Local $aRetTmp[6] = [$BaseFont, $FirstChar, $LastChar, $Param, $Widths, $MissingWidth]
	Return $aRetTmp
EndFunc   ;==>__FontCourier

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __FontSymbol
; Description ...:
; Syntax ........: __FontSymbol( [ $Style , $PDF_FONT_NORMAL ] )
; Parameters ....: $Style               - [optional]  unknown value.
;                  $PDF_FONT_NORMAL     -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __FontSymbol($Style = $PDF_FONT_NORMAL)
	$BaseFont = "Symbol"
	$FirstChar = 30
	$LastChar = 255
	$MissingWidth = 332
	Local $aTemp[$LastChar - $FirstChar + 1]
	Switch $Style
		Case $PDF_FONT_NORMAL
			$aTemp = StringSplit("600, 600, 250, 333, 713, 500, 549, 833, 778, 439, 333, 333, 500, 549, 250, 549, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, " & _
			"500, 500, 278, 278, 549, 549, 549, 444, 549, 722, 667, 722, 612, 611, 763, 603, 722, 333, 631, 722, 686, 889, 722, 722, 768, 741, 556, 592, 611, 690, " & _
			"439, 768, 645, 795, 611, 333, 863, 333, 658, 500, 500, 631, 549, 549, 494, 439, 521, 411, 603, 329, 603, 549, 549, 576, 521, 549, 549, 521, 549, 603, " & _
			"439, 576, 713, 686, 493, 686, 494, 480, 200, 480, 549, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 620, 247, 549, 167, 713, 500, 753, 753, 753, 753, 1042, 987, 603, 987, 603, " & _
			"400, 549, 411, 549, 549, 713, 494, 460, 549, 549, 549, 549, 1000, 603, 1000, 658, 823, 686, 795, 987, 768, 768, 823, 768, 768, 713, 713, 713, 713, 713, " & _
			"713, 713, 768, 713, 790, 790, 890, 823, 549, 250, 713, 603, 603, 1042, 987, 603, 987, 603, 494, 329, 790, 790, 786, 713, 384, 384, 384, 384, 384, 384, " & _
			"494, 494, 494, 494, 600, 329, 274, 686, 686, 686, 384, 384, 384, 384, 384, 384, 494, 494, 494, 600", ", ", 3)
			$Param = "/Flags 6 /FontBBox [-250 -220 1246 1005] " & _
					"/MissingWidth 332 /StemV 109 " & _
					"/StemH 109 /ItalicAngle 0 /CapHeight 1005 /XHeight 503 " & _
					"/Ascent 1005 /Descent -220 /Leading 225 " & _
					"/MaxWidth 1038 /AvgWidth 601"
		Case $PDF_FONT_BOLD
			$BaseFont = $BaseFont & ",Bold"
			$aTemp = StringSplit("600, 600, 250, 333, 713, 500, 549, 833, 778, 439, 333, 333, 500, 549, 250, 549, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, " & _
			"500, 500, 278, 278, 549, 549, 549, 444, 549, 722, 667, 722, 612, 611, 763, 603, 722, 333, 631, 722, 686, 889, 722, 722, 768, 741, 556, 592, 611, 690, " & _
			"439, 768, 645, 795, 611, 333, 863, 333, 658, 500, 500, 631, 549, 549, 494, 439, 521, 411, 603, 329, 603, 549, 549, 576, 521, 549, 549, 521, 549, 603, " & _
			"439, 576, 713, 686, 493, 686, 494, 480, 200, 480, 549, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 620, 247, 549, 167, 713, 500, 753, 753, 753, 753, 1042, 987, 603, 987, 603, " & _
			"400, 549, 411, 549, 549, 713, 494, 460, 549, 549, 549, 549, 1000, 603, 1000, 658, 823, 686, 795, 987, 768, 768, 823, 768, 768, 713, 713, 713, 713, 713, " & _
			"713, 713, 768, 713, 790, 790, 890, 823, 549, 250, 713, 603, 603, 1042, 987, 603, 987, 603, 494, 329, 790, 790, 786, 713, 384, 384, 384, 384, 384, 384, 494, " & _
			"494, 494, 494, 600, 329, 274, 686, 686, 686, 384, 384, 384, 384, 384, 384, 494, 494, 494, 600", ", ", 3)
			$Param = "/Flags 16390 /FontBBox [-250 -220 1246 1005] " & _
					"/MissingWidth 332 /StemV 191 " & _
					"/StemH 191 /ItalicAngle 0 /CapHeight 1005 /XHeight 503 " & _
					"/Ascent 1005 /Descent -220 /Leading 225 " & _
					"/MaxWidth 1038 /AvgWidth 600"
		Case $PDF_FONT_ITALIC
			$BaseFont = $BaseFont & ",Italic"
			$aTemp = StringSplit("600, 600, 250, 333, 713, 500, 549, 833, 778, 439, 333, 333, 500, 549, 250, 549, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, 500, " & _
			"500, 278, 278, 549, 549, 549, 444, 549, 722, 667, 722, 612, 611, 763, 603, 722, 333, 631, 722, 686, 889, 722, 722, 768, 741, 556, 592, 611, 690, 439, 768, 645, " & _
			"795, 611, 333, 863, 333, 658, 500, 500, 631, 549, 549, 494, 439, 521, 411, 603, 329, 603, 549, 549, 576, 521, 549, 549, 521, 549, 603, 439, 576, 713, 686, 493, " & _
			"686, 494, 480, 200, 480, 549, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 620, 247, 549, 167, 713, 500, 753, 753, 753, 753, 1042, 987, 603, 987, 603, 400, 549, 411, 549, 549, 713, 494, 460, 549, " & _
			"549, 549, 549, 1000, 603, 1000, 658, 823, 686, 795, 987, 768, 768, 823, 768, 768, 713, 713, 713, 713, 713, 713, 713, 768, 713, 790, 790, 890, 823, 549, 250, 713, " & _
			"603, 603, 1042, 987, 603, 987, 603, 494, 329, 790, 790, 786, 713, 384, 384, 384, 384, 384, 384, 494, 494, 494, 494, 600, 329, 274, 686, 686, 686, 384, " & _
			"384, 384, 384, 384, 384, 494, 494, 494, 600", ", ", 3)
			$Param = "/Flags 70 /FontBBox [-250 -220 1246 1005] " & _
					"/MissingWidth 332 /StemV 109 " & _
					"/StemH 109 /ItalicAngle -11 /CapHeight 1005 /XHeight 503 " & _
					"/Ascent 1005 /Descent -220 /Leading 225 " & _
					"/MaxWidth 1038 /AvgWidth 600"
		Case $PDF_FONT_BOLDITALIC
			$BaseFont = $BaseFont & ",BoldItalic"
			$aTemp = StringSplit("600, 600, 250, 333, 713, 500, 549, 833, 778, 439, 333, 333, 500, 549, 250, 549, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, 500, " & _
			"500, 278, 278, 549, 549, 549, 444, 549, 722, 667, 722, 612, 611, 763, 603, 722, 333, 631, 722, 686, 889, 722, 722, 768, 741, 556, 592, 611, 690, 439, 768, 645, " & _
			"795, 611, 333, 863, 333, 658, 500, 500, 631, 549, 549, 494, 439, 521, 411, 603, 329, 603, 549, 549, 576, 521, 549, 549, 521, 549, 603, 439, 576, 713, 686, 493, " & _
			"686, 494, 480, 200, 480, 549, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, " & _
			"600, 600, 600, 600, 600, 600, 600, 600, 620, 247, 549, 167, 713, 500, 753, 753, 753, 753, 1042, 987, 603, 987, 603, 400, 549, 411, 549, 549, 713, 494, 460, 549, " & _
			"549, 549, 549, 1000, 603, 1000, 658, 823, 686, 795, 987, 768, 768, 823, 768, 768, 713, 713, 713, 713, 713, 713, 713, 768, 713, 790, 790, 890, 823, 549, 250, 713, " & _
			"603, 603, 1042, 987, 603, 987, 603, 494, 329, 790, 790, 786, 713, 384, 384, 384, 384, 384, 384, 494, 494, 494, 494, 600, 329, 274, 686, 686, 686, 384, " & _
			"384, 384, 384, 384, 384, 494, 494, 494, 600", ", ", 3)
			$Param = "/Flags 16454 /FontBBox [-250 -220 1246 1005] " & _
					"/MissingWidth 332 /StemV 191 " & _
					"/StemH 191 /ItalicAngle -11 /CapHeight 1005 /XHeight 503 " & _
					"/Ascent 1005 /Descent -220 /Leading 225 " & _
					"/MaxWidth 1038 /AvgWidth 600"
	EndSwitch
	For $i = $FirstChar To $LastChar
		$Widths[$i] = $aTemp[$i - $FirstChar]
	Next
	Local $aRetTmp[6] = [$BaseFont, $FirstChar, $LastChar, $Param, $Widths, $MissingWidth]
	Return $aRetTmp
EndFunc   ;==>__FontSymbol

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __FontTimes
; Description ...:
; Syntax ........: __FontTimes( [ $Style , $PDF_FONT_NORMAL ] )
; Parameters ....: $Style               - [optional]  unknown value.
;                  $PDF_FONT_NORMAL     -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __FontTimes($Style = $PDF_FONT_NORMAL)
	$BaseFont = "TimesNewRoman"
	$FirstChar = 32
	$LastChar = 255
	$MissingWidth = 333
	Local $aTemp[$LastChar - $FirstChar]; + 1]
	Switch $Style
		Case $PDF_FONT_NORMAL
			$aTemp = StringSplit("250, 333, 408, 500, 500, 833, 778, 180, 333, 333, 500, 564, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 278, " & _
			"278, 564, 564, 564, 444, 921, 722, 667, 667, 722, 611, 556, 722, 722, 333, 389, 722, 611, 889, 722, 722, 556, 722, 667, 556, 611, 722, 722, 944, 722, 722, " & _
			"611, 333, 278, 333, 469, 500, 333, 444, 500, 444, 500, 444, 333, 500, 500, 278, 278, 500, 278, 778, 500, 500, 500, 500, 333, 389, 278, 500, 500, 722, 500, " & _
			"500, 444, 480, 200, 480, 541, 778, 500, 778, 333, 500, 444, 1000, 500, 500, 333, 1000, 556, 333, 889, 778, 611, 778, 778, 333, 333, 444, 444, 350, 500, 1000, " & _
			"333, 980, 389, 333, 722, 778, 444, 722, 250, 333, 500, 500, 500, 500, 200, 500, 333, 760, 276, 500, 564, 333, 760, 500, 400, 549, 300, 300, 333, 576, 453, 250, " & _
			"333, 300, 310, 500, 750, 750, 750, 444, 722, 722, 722, 722, 722, 722, 889, 667, 611, 611, 611, 611, 333, 333, 333, 333, 722, 722, 722, 722, 722, 722, 722, 564, " & _
			"722, 722, 722, 722, 722, 722, 556, 500, 444, 444, 444, 444, 444, 444, 667, 444, 444, 444, 444, 444, 278, 278, 278, 278, 500, 500, 500, 500, 500, 500, 500, 549, " & _
			"500, 500, 500, 500, 500, 500, 500, 500", ", ", 3)
			$Param = "/Flags 34 /FontBBox [-250 -216 1200 1000] " & _
					"/MissingWidth 333 /StemV 73 " & _
					"/StemH 73 /ItalicAngle 0 /CapHeight 891 /XHeight 446 " & _
					"/Ascent 891 /Descent -216 /Leading 149 " & _
					"/MaxWidth 1000 /AvgWidth 401"
		Case $PDF_FONT_BOLD
			$BaseFont = $BaseFont & ",Bold"
			$aTemp = StringSplit("250, 333, 555, 500, 500, 1000, 833, 278, 333, 333, 500, 570, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 333, 333, 570, 570, 570, 500, 930, 722, 667, 722, 722, 667, 611, 778, 778, 389, 500, 778, 667, 944, 722, 778, 611, 778, 722, 556, 667, 722, 722, 1000, 722, 722, 667, 333, 278, 333, 581, 500, 333, 500, 556, 444, 556, 444, 333, 500, 556, 278, 333, 556, 278, 833, 556, 500, 556, 556, 444, 389, 333, 556, 500, 722, 500, 500, 444, 394, 220, 394, 520, 778, 500, 778, 333, 500, 500, 1000, 500, 500, 333, 1000, 556, 333, 1000, 778, 667, 778, 778, 333, 333, 500, 500, 350, 500, 1000, 333, 1000, 389, 333, 722, 778, 444, 722, 250, 333, 500, 500, 500, 500, 220, 500, 333, 747, 300, 500, 570, 333, 747, 500, 400, 549, 300, 300, 333, 576, 540, 250, 333, 300, 330, 500, 750, 750, 750, 500, 722, 722, 722, 722, 722, 722, 1000, 722, 667, 667, 667, 667, 389, 389, 389, 389, 722, 722, 778, 778, 778, 778, 778, 570, 778, 722, 722, 722, 722, 722, 611, 556, 500, 500, 500, 500, 500, 500, 722, 444, 444, 444, 444, 444, 278, 278, 278, 278, 500, 556, 500, 500, 500, 500, 500, 549, 500, 556, 556, 556, 556, 500, 556, 500", ", ", 3)
			$Param = "/Flags 16418 /FontBBox [-250 -216 1201 1000] " & _
					"/MissingWidth 333 /StemV 136 " & _
					"/StemH 136 /ItalicAngle 0 /CapHeight 891 /XHeight 446 " & _
					"/Ascent 891 /Descent -216 /Leading 149 " & _
					"/MaxWidth 1001 /AvgWidth 401"
		Case $PDF_FONT_ITALIC
			$BaseFont = $BaseFont & ",Italic"
			$aTemp = StringSplit("250, 333, 420, 500, 500, 833, 778, 214, 333, 333, 500, 675, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, " & _
			"333, 333, 675, 675, 675, 500, 920, 611, 611, 667, 722, 611, 611, 722, 722, 333, 444, 667, 556, 833, 667, 722, 611, 722, 611, 500, 556, 722, 611, 833, 611, " & _
			"556, 556, 389, 278, 389, 422, 500, 333, 500, 500, 444, 500, 444, 278, 500, 500, 278, 278, 444, 278, 722, 500, 500, 500, 500, 389, 389, 278, 500, 444, 667, " & _
			"444, 444, 389, 400, 275, 400, 541, 778, 500, 778, 333, 500, 556, 889, 500, 500, 333, 1000, 500, 333, 944, 778, 556, 778, 778, 333, 333, 556, 556, 350, 500, " & _
			"889, 333, 980, 389, 333, 667, 778, 389, 556, 250, 389, 500, 500, 500, 500, 275, 500, 333, 760, 276, 500, 675, 333, 760, 500, 400, 549, 300, 300, 333, 576, " & _
			"523, 250, 333, 300, 310, 500, 750, 750, 750, 500, 611, 611, 611, 611, 611, 611, 889, 667, 611, 611, 611, 611, 333, 333, 333, 333, 722, 667, 722, 722, 722, 722, " & _
			"722, 675, 722, 722, 722, 722, 722, 556, 611, 500, 500, 500, 500, 500, 500, 500, 667, 444, 444, 444, 444, 444, 278, 278, 278, 278, 500, 500, 500, 500, 500, 500, " & _
			"500, 549, 500, 500, 500, 500, 500, 444, 500, 444", ", ", 3)
			$Param = "/Flags 98 /FontBBox [-250 -216 1200 1000] " & _
					"/MissingWidth 333 /StemV 73 " & _
					"/StemH 73 /ItalicAngle -11 /CapHeight 891 /XHeight 446 " & _
					"/Ascent 891 /Descent -216 /Leading 149 " & _
					"/MaxWidth 1000 /AvgWidth 402"
		Case $PDF_FONT_BOLDITALIC
			$BaseFont = $BaseFont & ",BoldItalic"
			$aTemp = StringSplit("250, 389, 555, 500, 500, 833, 778, 278, 333, 333, 500, 570, 250, 333, 250, 278, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 333, 333, " & _
			"570, 570, 570, 500, 832, 667, 667, 667, 722, 667, 667, 722, 778, 389, 500, 667, 611, 889, 722, 722, 611, 722, 667, 556, 611, 722, 667, 889, 667, 611, 611, 333, " & _
			"278, 333, 570, 500, 333, 500, 500, 444, 500, 444, 333, 500, 556, 278, 278, 500, 278, 778, 556, 500, 500, 500, 389, 389, 278, 556, 444, 667, 500, 444, 389, 348, " & _
			"220, 348, 570, 778, 500, 778, 333, 500, 500, 1000, 500, 500, 333, 1000, 556, 333, 944, 778, 611, 778, 778, 333, 333, 500, 500, 350, 500, 1000, 333, 1000, 389, " & _
			"333, 722, 778, 389, 611, 250, 389, 500, 500, 500, 500, 220, 500, 333, 747, 266, 500, 606, 333, 747, 500, 400, 549, 300, 300, 333, 576, 500, 250, 333, 300, 300, " & _
			"500, 750, 750, 750, 500, 667, 667, 667, 667, 667, 667, 944, 667, 667, 667, 667, 667, 389, 389, 389, 389, 722, 722, 722, 722, 722, 722, 722, 570, 722, 722, 722, " & _
			"722, 722, 611, 611, 500, 500, 500, 500, 500, 500, 500, 722, 444, 444, 444, 444, 444, 278, 278, 278, 278, 500, 556, 500, 500, 500, 500, 500, 549, 500, 556, 556, " & _
			"556, 556, 444, 500, 444", ", ", 3)
			$Param = "/Flags 16482 /FontBBox [-250 -216 1200 1000] " & _
					"/MissingWidth 333 /StemV 131 " & _
					"/StemH 131 /ItalicAngle -11 /CapHeight 891 /XHeight 446 " & _
					"/Ascent 891 /Descent -216 /Leading 149 " & _
					"/MaxWidth 1000 /AvgWidth 412"
	EndSwitch
	For $i = $FirstChar To $LastChar
		$Widths[$i] = $aTemp[$i - $FirstChar]
	Next
	Local $aRetTmp[6] = [$BaseFont, $FirstChar, $LastChar, $Param, $Widths, $MissingWidth]
	Return $aRetTmp
EndFunc   ;==>__FontTimes

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __InitObj
; Description ...:
; Syntax ........: __InitObj( [ $iObj ] )
; Parameters ....: $iObj                - [optional]  integer value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __InitObj($iObj = 0)
	If $iObj = 0 Then $iObj = $_iMaxObject + 1
	If $iObj > $_iMaxObject Then $_iMaxObject = $iObj
	ReDim $aXREF[$_iMaxObject + 1]
	$aXREF[$iObj] = StringRight("0000000000" & StringLen($_Buffer), 10) & " 00000 n"
	__ToBuffer($iObj & " 0 obj")
	Return $iObj
EndFunc   ;==>__InitObj

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __InsertObjectOnPage
; Description ...:
; Syntax ........: __InsertObjectOnPage(  )
; Parameters ....:
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __InsertObjectOnPage()
	If $_iObject >= 0 Then
		For $_iObject In $aOBJECTS
			If ((($PDF_OBJECT_OPTIONS And $PDF_OBJECT_ALLPAGES) = $PDF_OBJECT_ALLPAGES) Or _
					((($PDF_OBJECT_OPTIONS And $PDF_OBJECT_EVENPAGES) <> 0) And (Mod($_Pages, 2) = 0)) Or _
					((($PDF_OBJECT_OPTIONS And $PDF_OBJECT_ODDPAGES) <> 0) And (Mod($_Pages, 2) <> 0)) And (Not _
					((($PDF_OBJECT_OPTIONS And $PDF_OBJECT_NOTFIRSTPAGE) <> 0) And ($_Pages = 1)))) Then
				__DrawObject($PDF_OBJECT_NAME)
			EndIf
		Next
	EndIf
EndFunc   ;==>__InsertObjectOnPage

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __Test
; Description ...:
; Syntax ........: __Test( $sText  )
; Parameters ....: $sText               -  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __Test($sText)
	ConsoleWrite($sText & chr(10))
EndFunc   ;==>__Test

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __ToBinary
; Description ...:
; Syntax ........: __ToBinary( $sImage  )
; Parameters ....: $sImage              -  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __ToBinary($sImage)
	Local $hFile, $Bin
	$hFile = FileOpen($sImage, 16)
	$Bin = FileRead($hFile)
	FileClose($hFile)
	Return BinaryToString($Bin)
EndFunc   ;==>__ToBinary

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __ToBuffer
; Description ...:
; Syntax ........: __ToBuffer( $sT  )
; Parameters ....: $sT                  -  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __ToBuffer($sT)
	$_Buffer &= $sT & chr(10)
EndFunc   ;==>__ToBuffer

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __ToPdfStr
; Description ...:
; Syntax ........: __ToPdfStr( $Temp  )
; Parameters ....: $Temp                -  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __ToPdfStr($Temp)
	Return StringReplace(StringReplace(StringReplace($Temp, "\", "\\"), "(", "\("), ")", "\)")
EndFunc   ;==>__ToPdfStr

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __ToSpace
; Description ...:
; Syntax ........: __ToSpace( $sValue  )
; Parameters ....: $sValue              -  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __ToSpace($sValue)
	Local $lRet
	Switch $__SetUnit
		Case $PDF_UNIT_PT
			$lRet = $sValue
		Case $PDF_UNIT_INCH
			$lRet = $sValue * 72
		Case $PDF_UNIT_CM
			$lRet = $sValue * 72 / 2.54
		Case $PDF_UNIT_MM
			$lRet = $sValue * 72 / 25.4
	EndSwitch
	Return $lRet
EndFunc   ;==>__ToSpace

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __ToStr
; Description ...:
; Syntax ........: __ToStr( $sValue [, $Dec ] )
; Parameters ....: $sValue              -  string value.
;                  $Dec                 - [optional]  unknown value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __ToStr($sValue, $Dec = 2)
	Return StringReplace(Round($sValue, $Dec), ",", ".")
EndFunc   ;==>__ToStr

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __ToUser
; Description ...:
; Syntax ........: __ToUser( $sValue  )
; Parameters ....: $sValue              -  string value.
; Return values .: None
; Author(s) .....: Mihai Iancu (taietel at yahoo dot com)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __ToUser($sValue)
	Local $lRet
	Switch $__SetUnit
		Case $PDF_UNIT_PT
			$lRet = $sValue
		Case $PDF_UNIT_INCH
			$lRet = $sValue / 72
		Case $PDF_UNIT_CM
			$lRet = ($sValue / 72) * 2.54
		Case $PDF_UNIT_MM
			$lRet = ($sValue / 72) * 25.4
	EndSwitch
	Return $lRet
EndFunc   ;==>__ToUser
#endregion #INTERNAL_USE_ONLY#