#include-once
#include <Clipboard.au3>
#include <FF.au3>
#include <ScreenCapture.au3>

; Tue Apr 28 22:19:57 CEST 2009 @888 /Internet Time/
; by thorsten.willert Chr(64) gmx.de ;)
; Requirement(s).: FF.au3 > V0.5.3.x / MozRepl / Screengrab!
;
; modified version GerardJ 26/04/2010
; compatible with last version of ScreenGrab (tested with version 0.96.3)
; note: returns 0 if error, else returns the filename (to help knowing the filename when not specified as input)
;===============================================================================
Func _FF_Screengrab_SaveCompleteDocument($sFileName="")
	If Not _FF_ScreenGrab_CopyCompleteDocument() Then Return 0
	Sleep(500)
	Return __FF_ScreenGrab_SaveClipboard($sFileName)
EndFunc   ;==>_FF_Screengrab_SaveCompleteDocument
;===============================================================================
Func _FF_Screengrab_SaveVisibleDocument($sFileName="")
	If Not _FF_ScreenGrab_CopyVisibleDocument() Then Return 0
	Sleep(500)
	Return __FF_ScreenGrab_SaveClipboard($sFileName)
EndFunc   ;==>_FF_Screengrab_SaveCompleteDocument

;===============================================================================
Func _FF_ScreenGrab_CopyCompleteDocument()
	; old screengrab version syntax (prior to 
	;_FFCmd("Screengrab.copyCompleteDocument();")
	_FFCmd("sg.Grab(new sg.FrameTarget(), sg.CaptureViewPort, new sg.CopyAction());")
	If @error Then Return 0
	Return 1
EndFunc   ;==>_FF_ScreenGrab_CopyCompleteDocument
;===============================================================================
Func _FF_ScreenGrab_CopyVisibleDocument()
	;_FFCmd("Screengrab.copyVisibleDocument();")
	_FFCmd("sg.Grab(new sg.VisibleTarget(), sg.CaptureViewPort, new sg.CopyAction());")
	If @error Then Return 0
	Return 1
EndFunc   ;==>_FF_ScreenGrab_CopyCompleteDocument
;===============================================================================
Func __FF_ScreenGrab_SaveClipboard($sFileName)
	Local $hBMP = _ClipBoard_GetData($CF_BITMAP)
	
	If $sFileName = "" Then
		$sFileName = @MyDocumentsDir & "\"
		$sFileName &= StringRegExpReplace(_FFCmd("sg.prefs.defaultFileName() + '.' + sg.prefs.format();"),"[^\s\w\.]","")
	EndIf
	
	_ScreenCapture_SaveImage($sFileName, $hBMP)
	If Not @error Then Return $sFileName
	Return 0
EndFunc   ;==>__FF_ScreenGrab_SaveClipboard

; examples of use:
;	$result =  _FF_ScreenGrab_SaveCompleteDocument("d:\\tmp\\capture_full_page.jpg")
;	;or "d:/tmp/capture_full_page.jpg"
;
;	if ($result == 0) Then
;		MsgBox(64, "", "Error detected!") 
;	Else
;		MsgBox(64, "", "OK, page captured in "&$result) 
;	EndIf
;
;	$result =  _FF_ScreenGrab_SaveCompleteDocument("")
;	if ($result == 0) Then
;		MsgBox(64, "", "Error detected!") 
;	Else
;		MsgBox(64, "", "OK, page captured in "&$result) 
;	EndIf
