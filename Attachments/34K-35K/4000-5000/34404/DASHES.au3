
#include "MPDF_UDF.au3"
#Region GLOBAL VARIABLES

_CreatePDF()

Func _CreatePDF()
	Local $buffer, $i, $j, $s, $temp, $p
	;set the properties for the pdf





	_SetTitle("Demo PDF in AutoIt")
	_SetSubject("Demo PDF in AutoIt, without any ActiveX or DLL...")
	_SetKeywords("pdf, demo, AutoIt")
	_OpenAfter(True);open after generation
	_SetUnit($PDF_UNIT_PT)
	_SetPaperSize($PDF_PAGE_LETTER)
	_SetZoomMode($PDF_ZOOM_FULLPAGE)
	_SetOrientation($PDF_ORIENTATION_PORTRAIT)
	_SetLayoutMode($PDF_LAYOUT_CONTINOUS)

	;initialize the pdf
	_InitPDF(@ScriptDir & "\Demo.pdf")

	;fonts:
	_LoadFontTT("_Courier", $PDF_FONT_COURIER)
	_LoadFontTT("_Arial", $PDF_FONT_ARIAL)
	_LoadFontTT("_TimesT", $PDF_FONT_TIMES)

	_StartObject("Antet", $PDF_OBJECT_NOTFIRSTPAGE)
	_EndObject()

	_BeginPage()
	Local $i, $j, $k, $l
	For $l = 2 To 5
			_DrawText(100, 770, " Dash off to Dash on ratio = "&$l, $PDF_FONT_ARIAL, 8, $PDF_ALIGN_LEFT, 0)
		For $i = 50 To 500 Step 5
			_DrawLine($i, 710, $i, 200, $PDF_STYLE_STROKED, 1, .5, 0x000000, 0, 0)
		Next
		$j = 700
		For $k = 1 To 25
			_DrawText(100, $j + 2, StringFormat("Dash on = %.2d , Dash off = %.2d", 5 * $k, 5*$l * $k), $PDF_FONT_ARIAL, 8, $PDF_ALIGN_LEFT, 0)
			_DrawLine(50, $j, 500, $j, $PDF_STYLE_STROKED, 0, 2, 0xff0000, 5 * $k, 5*$l * $k)
			$j -= 20
		Next

		_EndPage()
		_BeginPage()
			_DrawText(100, 770, " Dash off to Dash on ratio = "&$l, $PDF_FONT_ARIAL, 8, $PDF_ALIGN_LEFT, 0)
		For $i = 50 To 750 Step 5
			_DrawLine(50, $i, 550, $i, $PDF_STYLE_STROKED, 1, .5, 0x000000, 0, 0)
		Next
		$j = 70
		For $k = 1 To 25
			_DrawText($j - 2, 400, StringFormat("Dash on = %.2d , Dash off = %.2d", 5 * $k, 5*$l * $k), $PDF_FONT_ARIAL, 8, $PDF_ALIGN_LEFT, 90)
			_DrawLine($j, 50, $j, 750, $PDF_STYLE_STROKED, 0, 2, 0xff0000, 5 * $k, 5*$l * $k)
			$j += 20
		Next
		_EndPage()
		_BeginPage()
	Next
	_EndPage()
	_ClosePDFFile()

EndFunc   ;==>_CreatePDF