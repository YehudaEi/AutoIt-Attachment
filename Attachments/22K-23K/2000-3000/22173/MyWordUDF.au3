#include <Word.au3>


;===============================================================================
;
; Function Name:    _WordMarginSet()
; Description:      Sets margins of a previously opened Word document
; Parameter(s):     $o_object	- Object variable of a Word.Application Object
;					$s_margin	- 1 (Left) 
;								- 2 (Right)
;								- 4 (Top)
;								- 8 (Bottom) or a combination 
;					$v_marginsize	- The new value to be set for the specified margin
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
;					
; Author(s):        Steven Bailey 
;
;===============================================================================
;
Func _WordMarginSet(ByRef $o_object, $s_margin = 15, $v_marginsize = ".5")
	If Not IsObj($o_object) Then
		__WordErrorNotify("Error", "_WordMarginSet", "$_WordStatus_InvalidDataType")
		SetError($_WordStatus_InvalidDataType, 1)
		Return 0
	EndIf
	;
	If Not __WordIsObjType($o_object, "wordobj") Then
		__WordErrorNotify("Error", "_WordMarginSet", "$_WordStatus_InvalidObjectType")
		SetError($_WordStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	
	Select
		Case $s_margin = 1
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
		Case $s_margin = 2
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
		Case $s_margin = 3
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
		Case $s_margin = 4
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
		Case $s_margin = 5
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
		Case $s_margin = 6
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
		Case $s_margin = 7
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
		Case $s_margin = 8
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
		Case $s_margin = 9
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
		Case $s_margin = 10
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
		Case $s_margin = 11
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
		Case $s_margin = 12
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
		Case $s_margin = 13
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
		Case $s_margin = 14
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
		Case $s_margin = 15
			$o_object.ActiveDocument.PageSetup.BottomMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.RightMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.TopMargin = $v_marginsize
			$o_object.ActiveDocument.PageSetup.LeftMargin = $v_marginsize
	EndSelect
	
EndFunc   ;==>__WordMarginSet


;===============================================================================
;
; Function Name:    _WordFontSet()
; Description:      Sets font size and type of a previously opened Word document
; Parameter(s):     $o_object	- Object variable of a Word.Application Object
;					$s_font		- Name of font to use (As it appears in Word)
;					$v_fontsize	- Point size of the font
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
;					
; Author(s):        Steven Bailey 
;
;===============================================================================
;
Func _WordFontSet(ByRef $o_object, $s_font = "", $v_fontsize = "")
	If Not IsObj($o_object) Then
		__WordErrorNotify("Error", "_WordFontSet", "$_WordStatus_InvalidDataType")
		SetError($_WordStatus_InvalidDataType, 1)
		Return 0
	EndIf
	;
	If Not __WordIsObjType($o_object, "wordobj") Then
		__WordErrorNotify("Error", "_WordFontSet", "$_WordStatus_InvalidObjectType")
		SetError($_WordStatus_InvalidObjectType, 1)
		Return 0
	EndIf

	If $s_font = "" Then
		If $v_fontsize = "" Then
			Return 0
		Else
			$o_object.ActiveDocument.Select
			$o_object.Selection.Font.Size = $v_fontsize
		EndIf
	Else
		$o_object.ActiveDocument.Select
		$o_object.Selection.Font.Name = $s_font
		If $v_fontsize <> "" Then
			$o_object.Selection.Font.Size = $v_fontsize
		EndIf
	EndIf
	
EndFunc   ;==>__WordFontSet


;===============================================================================
;
; Function Name:    _WordPageSetup()
; Description:      Sets page setup options of a previously opened Word document
; Parameter(s):     $o_object	- Object variable of a Word.Application Object
;					$p_Orientation	- 0 (Portrait)
;									- 1 (Landscape)
;					$p_Gutter	- Gutter distance
;					$p_HeaderDistance	- Header Distance
;					$p_FooterDistance	- Footer Distance
;					$p_OddAndEvenPagesHeaderFooter - Different odd/even 
;					$p_DifferentFirstPageHeaderFooter	- Different first page
;					$p_SuppressEndnotes	- Suppress end notes
;					$p_MirrorMargins	- Mirror Margins
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
;					
; Author(s):        Steven Bailey 
;
;===============================================================================
;
Func _WordPageSetup(ByRef $o_object, $p_Orientation = 0, $p_Gutter = "0", $p_HeaderDistance = "0", $p_FooterDistance = "0", $p_OddAndEvenPagesHeaderFooter = False, $p_DifferentFirstPageHeaderFooter = False, $p_SuppressEndnotes = False, $p_MirrorMargins = False)
	If Not IsObj($o_object) Then
		__WordErrorNotify("Error", "_WordPageSetup", "$_WordStatus_InvalidDataType")
		SetError($_WordStatus_InvalidDataType, 1)
		Return 0
	EndIf
	;
	If Not __WordIsObjType($o_object, "wordobj") Then
		__WordErrorNotify("Error", "_WordPageSetup", "$_WordStatus_InvalidObjectType")
		SetError($_WordStatus_InvalidObjectType, 1)
		Return 0
	EndIf

	$o_object.ActiveDocument.PageSetup.Orientation = $p_Orientation
	$o_object.ActiveDocument.PageSetup.Gutter = $p_Gutter
	$o_object.ActiveDocument.PageSetup.HeaderDistance = $p_HeaderDistance
	$o_object.ActiveDocument.PageSetup.FooterDistance = $p_FooterDistance
	$o_object.ActiveDocument.PageSetup.OddAndEvenPagesHeaderFooter = $p_OddAndEvenPagesHeaderFooter
	$o_object.ActiveDocument.PageSetup.DifferentFirstPageHeaderFooter = $p_DifferentFirstPageHeaderFooter
	$o_object.ActiveDocument.PageSetup.SuppressEndnotes = $p_SuppressEndnotes
	$o_object.ActiveDocument.PageSetup.MirrorMargins = $p_MirrorMargins
		
EndFunc   ;==>__WordPageSetup
