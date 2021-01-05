;===============================================================================
;
; Function Name:    _INetGetSource()
; Description:      Gets the source from an URL without writing a temp file.
; Parameter(s):     $s_URL = The URL of the site.
; Requirement(s):   A beta version w/ COM
; Return Value(s):  On Success - Returns the source code.
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        KIX: Lonkero.
;					BASE CONVERSION: SvenP.
;					UDF: Wouter van Kesteren.
;
;===============================================================================

Func _INetGetSource($s_URL)
	
	;locals.
	Local $o_HTTP, $i_ERR
	
	;com err handler.
	$oMyError = ObjEvent("AutoIt.Error","_INetGetSourceError")
	
	;object.
	$o_HTTP = ObjCreate ("winhttp.winhttprequest.5.1")
	
	;more com err handeling.
	If @error Then
		SetError(1)
		Return 0
	EndIf
	
	;send the request.
	$o_HTTP.open ("GET", $s_URL)
	$o_HTTP.send ()
	
	;even more com err handeling.
	If @error Then
		SetError(1)
		Return 0
	EndIf
	
	;return the response.
	Return $o_HTTP.Responsetext
	
EndFunc   ;==>_GetSource

Func _INetGetSourceError()
	;dummy func to set @error on com err.
	SetError(1)
Endfunc