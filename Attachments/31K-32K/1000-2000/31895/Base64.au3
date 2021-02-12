; #FUNCTION# ;===============================================================================
;
; Name...........: _Base64Encode
; Description ...: Returns the given strinng encoded as a Base64 string.
; Syntax.........: _Base64Encode($sData)
; Parameters ....: $sData
; Return values .: Success - Base64 encoded string.
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Could not create DOMDocument
;                  |2 - Could not create Element
;                  |3 - No string to return
; Author ........: turbov21
; Modified.......:
; Remarks .......:
; Related .......: _Base64Decode
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Base64Encode($sData)
    Local $oXml = ObjCreate("Msxml2.DOMDocument")
    If Not IsObj($oXml) Then
        SetError(1, 1, 0)
    EndIf
    
    Local $oElement = $oXml.createElement("b64")
    If Not IsObj($oElement) Then
        SetError(2, 2, 0)
    EndIf

    $oElement.dataType = "bin.base64"
    $oElement.nodeTypedValue = Binary($sData)
    Local $sReturn = $oElement.Text
	
    If StringLen($sReturn) = 0 Then
        SetError(3, 3, 0)
    EndIf

    Return $sReturn
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _Base64Decode
; Description ...: Returns the strinng decoded from the provided Base64 string.
; Syntax.........: _Base64Decode($sData)
; Parameters ....: $sData
; Return values .: Success - String decoded from Base64.
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Could not create DOMDocument
;                  |2 - Could not create Element
;                  |3 - No string to return
; Author ........: turbov21
; Modified.......:
; Remarks .......:
; Related .......: _Base64Encode
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Base64Decode($sData)
    Local $oXml = ObjCreate("Msxml2.DOMDocument")
    If Not IsObj($oXml) Then
        SetError(1, 1, 0)
    EndIf

    Local $oElement = $oXml.createElement("b64")
    If Not IsObj($oElement) Then
        SetError(2, 2, 0)
    EndIf

    $oElement.dataType = "bin.base64"
    $oElement.Text = $sData
    Local $sReturn = BinaryToString($oElement.nodeTypedValue, 4)
    
    If StringLen($sReturn) = 0 Then
        SetError(3, 3, 0)
    EndIf
    
    Return $sReturn
EndFunc