;===============================================================================
;
; Function Name:    _cwebpage( $cwebpage )
; Description:      Dllcalling/opening from cwebpage.dll
; Parameter(s):     $cwebpage = cwebpage.dll
; Requirement(s):   cwebpage.dll
; Author(s):        NegativeNrG
;Important Notes: Must have Child(internetGui) renamed to $NetGui Main Form to $Form1
;===============================================================================


Global $dll1 = "cwebpage.dll"

Func _cwebpage($cwebpage)
	$dll = DllOpen($cwebpage)
	DllCall($dll, "long", "EmbedBrowserObject", "hwnd", $NetGui)
	DllCall($dll, "long", "DisplayHTMLPage", "hwnd", $NetGui, "str", "www.autoitscript.com")
	;DLLCall($dll,"none","ResizeBrowser","hwnd", $Form1 ,"int", 800, "int", 500 )
EndFunc   ;==>_cwebpage

;===============================================================================
;
; Function Name:    _NavigateGo( $cwebpage )
; Description:      Go to webaddress in ComboBox
; Parameter(s):     $cwebpage
; Requirement(s):   Internet Access
; Author(s):        NegativeNrG
;Important Notes: Web Address Box renamed to $Combo1
;===============================================================================


Func _Navigatego($cwebpage)
	$dll = DllOpen($cwebpage)
	DllCall($dll, "long", "DisplayHTMLPage", "hwnd", $NetGui, "str", GUICtrlRead($Combo1))
EndFunc   ;==>_Navigatego

;===============================================================================
;
; Function Name:    _Navigateback( $cwebpage )
; Description:      Back to Previous Site
; Parameter(s):     $cwebpage
; Requirement(s):   Internet Access
; Author(s):        NegativeNrG
;Important Notes:
;===============================================================================

Func _Navigateback($cwebpage)
	$dll = DllOpen($cwebpage)
	DllCall($dll, "none", "DoPageAction", "hwnd", $NetGui, "int", 0)
EndFunc   ;==>_Navigateback

;===============================================================================
;
; Function Name:    _Navigateforward( $cwebpage )
; Description:      Go to Previous Site
; Parameter(s):     $cwebpage
; Requirement(s):   Internet Access
; Author(s):        NegativeNrG
;Important Notes:
;===============================================================================

Func _Navigateforward($cwebpage)
	$dll = DllOpen($cwebpage)
	DllCall($dll, "none", "DoPageAction", "hwnd", $NetGui, "int", 1)
EndFunc   ;==>_Navigateforward

;===============================================================================
;
; Function Name:    _refresh( $cwebpage )
; Description:      Refresh Current Site
; Parameter(s):     $cwebpage
; Requirement(s):   Internet Access
; Author(s):        NegativeNrG
;Important Notes:
;===============================================================================

Func _refresh($cwebpage)
	$dll = DllOpen($cwebpage)
	DllCall($dll, "none", "DoPageAction", "hwnd", $NetGui, "int", 4)
EndFunc   ;==>_refresh 
