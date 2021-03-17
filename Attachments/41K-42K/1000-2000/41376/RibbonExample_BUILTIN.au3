
#NoTrayIcon
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinApi.au3>

Global Const $tagVARIANT = "word vt;word r1;word r2;word r3;ptr data; ptr"
Global Const $sUI_PKEY_Color = "{00000190-7363-696e-8441-798acf5aebb7} 19"
Global Const $sUI_PKEY_FontProperties_Size = "{0000012E-7363-696e-8441-798acf5aebb7} 14"
Global Const $sUI_PKEY_FontProperties_Bold = "{0000012F-7363-696e-8441-798acf5aebb7} 19"
Global Const $sUI_PKEY_FontProperties_Italic = "{00000130-7363-696e-8441-798acf5aebb7} 19"
Global Const $sUI_PKEY_FontProperties_Underline = "{00000131-7363-696e-8441-798acf5aebb7} 19"
Global Const $sUI_PKEY_FontProperties_Strikethrough = "{00000132-7363-696e-8441-798acf5aebb7} 19"
Global Const $sUI_PKEY_FontProperties_Family = "{0000012D-7363-696e-8441-798acf5aebb7} 31"
Global Const $sUI_PKEY_GlobalBackgroundColor = "{000007D0-7363-696e-8441-798acf5aebb7} 19"

; RIBBON COMMAND BAR
;.......script written by trancexx (trancexx at yahoo dot com)
; Based on Michael Chourdakis's work. Find him at http://www.turboirc.com/vrc

;******************************************************************************************
;****   Interfaces   **********************************************************************
;******************************************************************************************
;===============================================================================
#interface "IUnknown"
Global Const $sIID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
Global $tagIUnknown = "QueryInterface hresult(ptr;ptr*);" & _
		"AddRef dword();" & _
		"Release dword();"
;===============================================================================

;===============================================================================
#interface "IUIFramework"
Global Const $sCLSID_UIRibbonFramework = "{926749fa-2615-4987-8845-c33e65f2b957}"
Global Const $sIID_IUIFramework = "{F4F0385D-6872-43a8-AD09-4C339CB3F5C5}"
Global Const $tagIUIFramework = _
		"Initialize hresult(hwnd;ptr);" & _
		"Destroy hresult();" & _
		"LoadUI hresult(handle;wstr);" & _
		"GetView hresult(dword;ptr;ptr*);" & _
		"GetUICommandProperty hresult(dword;struct*;variant*);" & _
		"SetUICommandProperty hresult(dword;ptr;variant);" & _
		"InvalidateUICommand hresult(dword;dword;ptr);" & _
		"FlushPendingInvalidations hresult();" & _
		"SetModes hresult(int);"
;===============================================================================

;===============================================================================
#interface "IUIApplication"
Global Const $sIID_IUIApplication = "{D428903C-729A-491d-910D-682A08FF2522}"
Global Const $tagIUIApplication = _
		"OnViewChanged hresult(dword;dword;ptr;dword;int);" & _
		"OnCreateUICommand hresult(dword;dword;ptr);" & _
		"OnDestroyUICommand hresult(dword;dword;ptr);"
;===============================================================================

;===============================================================================
#interface "IUIRibbon"
Global Const $sIID_IUIRibbon = "{803982ab-370a-4f7e-a9e7-8784036a6e26}"
Global Const $tagIUIRibbon = _
		"GetHeight hresult(dword*);" & _
		"LoadSettingsFromStream hresult(ptr);" & _
		"SaveSettingsToStream hresult(ptr);"
;===============================================================================

;===============================================================================
#interface "IUICommandHandler"
Global Const $sIID_IUICommandHandler = "{75ae0a2d-dc03-4c9f-8883-069660d0beb6}"
Global Const $tagIUICommandHandler = _
		"Execute hresult(dword;dword;ptr;variant*;ptr);" & _
		"UpdateProperty hresult(dword;ptr;variant*;variant*);"
;===============================================================================

;===============================================================================
#interface "IPropertyStore"
Global Const $sIID_IPropertyStore = "{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}"
Global Const $tagIPropertyStore = _
		"GetCount hresult(dword*);" & _
		"GetAt hresult(dword;ptr*);" & _
		"GetValue hresult(struct*;variant*);" & _
		"SetValue hresult(struct*;variant*);" & _
		"Commit hresult();"
;===============================================================================
;******************************************************************************************

; Error monitoring
Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")
Func _ErrFunc($oErr)
	ConsoleWrite("COM Error, ScriptLine(" & $oErr.scriptline & ") : Number 0x" & Hex($oErr.number, 8) & " - " & $oErr.windescription & @CRLF)
EndFunc   ;==>_ErrFunc




Global $hGUI = GUICreate("Ribbon Test", 640, 480, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, 0))
Global $hButton = GUICtrlCreateButton("Click", 150, 150, 100, 30)
Global $hEdit = GUICtrlCreateEdit("Ribbons are the modern way to help users find, understand, and use commands efficiently and directly—with a minimum number of clicks, " & @CRLF & "with less need to resort to trial-and-error, and without having to refer to Help.", 0, 200, 640, 200)

; Ribbon is inside convinient resource dll for this demo
Global $hRibInstance = _WinAPI_LoadLibraryEx("RibRes.dll", 2)
Global $sResName = "TEST_RIBBON"

; Two objects...
Global $oRibbFramework, $oApp
; ... plus array of few more
Global $oHandlers[1][2] ; Array of handlers (objects)

; Create Ribbon controls
_Ribbon_Create($hGUI, $hRibInstance, $sResName, $oRibbFramework, $oApp, $oHandlers)

GUIRegisterMsg(0x0005, "MY_WM_SIZE"); Register WM_SIZE event

Func MY_WM_SIZE($hWnd, $msg, $wParam, $lParam)
	Return 0
EndFunc   ;==>MY_PAINT



; Show GUI
GUISetState()
; Handle usual events
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			_Ribbon_Destroy($oRibbFramework, $oApp, $oHandlers)
			Exit
		Case $hButton
			MsgBox(0, '', "Button")
	EndSwitch
WEnd

; The End




Func PSPropertyKeyFromString($sPropKey)
	Local $tProp = DllStructCreate("byte fmtid[16]; dword pid;")
	Local $aCall = DllCall("propsys.dll", "long", "PSPropertyKeyFromString", "wstr", $sPropKey, "struct*", $tProp)
	If @error Or $aCall[0] Then Return SetError(1, 0, $tProp)
	Return $tProp
EndFunc   ;==>PSPropertyKeyFromString

Func ObjectFromTag($sFunctionPrefix, $tagInterface, ByRef $tInterface)
	Local Const $tagIUnknown = "QueryInterface hresult(ptr;ptr*);" & _
			"AddRef dword();" & _
			"Release dword();"
	; Adding IUnknown methods
	$tagInterface = $tagIUnknown & $tagInterface
	Local Const $PTR_SIZE = DllStructGetSize(DllStructCreate("ptr"))
	; Below line really simple even though it looks super complex. It's just written weird to fit one line, not to steal your eyes
	Local $aMethods = StringSplit(StringReplace(StringReplace(StringReplace(StringReplace(StringTrimRight(StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(\w+\*?)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF), 1), "object", "idispatch"), "variant*", "ptr"), "hresult", "long"), "bstr", "ptr"), @LF, 3)
	Local $iUbound = UBound($aMethods)
	Local $sMethod, $aSplit, $sNamePart, $aTagPart, $sTagPart, $sRet, $sParams
	; Allocation. Read http://msdn.microsoft.com/en-us/library/ms810466.aspx to see why like this (object + methods):
	$tInterface = DllStructCreate("ptr[" & $iUbound + 1 & "]")
	If @error Then Return SetError(1, 0, 0)
	For $i = 0 To $iUbound - 1
		$aSplit = StringSplit($aMethods[$i], "|", 2)
		If UBound($aSplit) <> 2 Then ReDim $aSplit[2]
		$sNamePart = $aSplit[0]
		$sTagPart = $aSplit[1]
		$sMethod = $sFunctionPrefix & $sNamePart
		$aTagPart = StringSplit($sTagPart, ";", 2)
		$sRet = $aTagPart[0]
		$sParams = StringReplace($sTagPart, $sRet, "", 1)
		$sParams = "ptr" & $sParams
		DllStructSetData($tInterface, 1, DllCallbackGetPtr(DllCallbackRegister($sMethod, $sRet, $sParams)), $i + 2) ; Freeing is left to AutoIt.
	Next
	DllStructSetData($tInterface, 1, DllStructGetPtr($tInterface) + $PTR_SIZE) ; Interface method pointers are actually pointer size away
	Return ObjCreateInterface(DllStructGetPtr($tInterface), "", $tagInterface, False) ; and first pointer is object pointer that's wrapped
EndFunc   ;==>ObjectFromTag

Func _Ribbon_Create($hWnd, $hRibInstance, $sResName, ByRef $oRibbFramework, ByRef $oApp, ByRef $oHandlers)
	#forceref $oHandlers
	; Win7 and above
	$oRibbFramework = ObjCreateInterface($sCLSID_UIRibbonFramework, $sIID_IUIFramework, $tagIUIFramework)
	If Not IsObj($oRibbFramework) Then Return False
	Local Static $tObj
	$oApp = ObjectFromTag("_MyUIApp_", $tagIUIApplication, $tObj)
	$oRibbFramework.Initialize($hWnd, $oApp())
	$oRibbFramework.LoadUI($hRibInstance, $sResName)
EndFunc   ;==>_Ribbon_Create

Func _Ribbon_Destroy(ByRef $oRibbFramework, ByRef $oApp, ByRef $oHandlers)
	; Release all created objects
	$oRibbFramework.Destroy()
	$oRibbFramework = 0
	$oApp = 0
	For $i = 0 To UBound($oHandlers) - 1
		$oHandlers[$i][0] = 0
		$oHandlers[$i][1] = 0
	Next
EndFunc   ;==>_Ribbon_Destroy

;********************************************************************************************;
; Define UIApplication methods
Func _MyUIApp_QueryInterface($pSelf, $pRIID, $pObj)
	ConsoleWrite("_MyUIApp_QueryInterface called" & @CRLF)
	Local $tStruct = DllStructCreate("ptr", $pObj)
	Switch _WinAPI_StringFromGUID($pRIID)
		Case $sIID_IUnknown, $sIID_IUIApplication
			DllStructSetData($tStruct, 1, $pSelf)
			ConsoleWrite("IUnknown" & @CRLF)
			Return 0 ; S_OK
	EndSwitch
	ConsoleWrite(@CRLF)
	Return 0x80004002 ; E_NOINTERFACE
EndFunc   ;==>_MyUIApp_QueryInterface

Func _MyUIApp_AddRef($pSelf)
	#forceref $pSelf
;~ 	ConsoleWrite("_MyUIApp_AddRef called" & @CRLF)
	Return 0
EndFunc   ;==>_MyUIApp_AddRef

Func _MyUIApp_Release($pSelf)
	#forceref $pSelf
;~ 	ConsoleWrite("_MyUIApp_Release called" & @CRLF)
	Return 0
EndFunc   ;==>_MyUIApp_Release

Func _MyUIApp_OnCreateUICommand($pSelf, $iCommandId, $iCommandType, $pHandler)
	#forceref $pSelf, $iCommandId, $iCommandType
;~ 	ConsoleWrite("_MyUIApp_OnCreateUICommand called" & @CRLF)
	$tHandler = DllStructCreate("ptr", $pHandler)
	If Not $pHandler Then Return 0x80004003 ; E_POINTER
	Local Static $i = 0
	ReDim $oHandlers[$i + 1][2] ; resize the array
	Local $oNewHandler = ObjectFromTag("_MyHandler_", $tagIUICommandHandler, $oHandlers[$i][1])
	$oHandlers[$i][0] = $oNewHandler ; save new object
	$i += 1
	DllStructSetData($tHandler, 1, $oNewHandler())
	Return 0 ; S_OK
EndFunc   ;==>_MyUIApp_OnCreateUICommand

Func _MyUIApp_OnDestroyUICommand($pSelf, $iCommandId, $iCommandType, $pHandler)
	#forceref $pSelf, $iCommandId, $iCommandType, $pHandler
;~ 	ConsoleWrite("_MyUIApp_OnDestroyUICommand called" & @CRLF)
	Return 0 ; S_OK
EndFunc   ;==>_MyUIApp_OnDestroyUICommand

Func _MyUIApp_OnViewChanged($pSelf, $iViewId, $iTypeId, $pView, $iVerb, $iReason)
	#forceref $pSelf, $iViewId, $iTypeId, $pView, $iVerb, $iReason
;~ 	ConsoleWrite("_MyUIApp_OnViewChanged called" & @CRLF)
	Return 0 ; S_OK
EndFunc   ;==>_MyUIApp_OnViewChanged
;********************************************************************************************;


;********************************************************************************************;
; Define UICommandHandler methods
Func _MyHandler_QueryInterface($pSelf, $pRIID, $pObj)
;~ 	ConsoleWrite("_MyHandler_QueryInterface called" & @CRLF)
	Local $tStruct = DllStructCreate("ptr", $pObj)
	Switch _WinAPI_StringFromGUID($pRIID)
		Case $sIID_IUnknown, $sIID_IUICommandHandler
			DllStructSetData($tStruct, 1, $pSelf)
			Return 0 ; S_OK
	EndSwitch
	Return 0x80004002 ; E_NOINTERFACE
EndFunc   ;==>_MyHandler_QueryInterface

Func _MyHandler_AddRef($pSelf)
	#forceref $pSelf
;~ 	ConsoleWrite("_MyHandler_AddRef called" & @CRLF)
	Return 0
EndFunc   ;==>_MyHandler_AddRef

Func _MyHandler_Release($pSelf)
	#forceref $pSelf
;~ 	ConsoleWrite("_MyHandler_Release called" & @CRLF)
	Return 0
EndFunc   ;==>_MyHandler_Release

Func _MyHandler_Execute($pSelf, $iCommandId, $iVerb, $pKey, $vCurVal, $pProps)
	#forceref $pSelf, $iVerb, $pKey, $vCurVal, $pProps
;~ 	ConsoleWrite("_MyHandler_Execute called " & $iCommandId & "    $vCurVal = " & $vCurVal & @CRLF)
	Switch $iCommandId
		Case 101
			MsgBox(64, "Action Add", "Something", 0, $hGUI)
		Case 102
			MsgBox(64, "Action Add", "Something Else", 0, $hGUI)
		Case 10010
			MsgBox(32, "Options", "What options?", 0, $hGUI)
		Case 10011
			_Ribbon_Destroy($oRibbFramework, $oApp, $oHandlers)
			Exit
		Case 10012
			MsgBox(64, "About", "AutoItObject Ribbon Example", 0, $hGUI)
		Case 10013
			MsgBox(48, "Help", "...To help you with something here.", 0, $hGUI)
		Case 10015
			GUICtrlSetFont($hEdit, _ReadFontSize($vCurVal), _ReadFontWeight($vCurVal), _ReadFontAttrib($vCurVal), _ReadFontFamily($vCurVal))
		Case 10017
			GUICtrlSetColor($hEdit, _ReadColor($iCommandId))
		Case 10018
			GUICtrlSetBkColor($hEdit, _ReadColor($iCommandId))
		Case 10022
			MsgBox(64, "Action Browser", "Start Browser or something", 0, $hGUI)
		Case 10025
			ConsoleWrite(">>>GlobalColor = " & Hex(_GetGlobalColor()) & @CRLF)
			_PlayMusic(False)
		Case 10026
			_PlayMusic()
		Case 10027
			_PlayMusic(False)
	EndSwitch
	Return 0 ; S_OK
EndFunc   ;==>_MyHandler_Execute

Func _MyHandler_UpdateProperty($pSelf, $iCommandId, $pKey, $vCurVal, $vNewVal)
	#forceref $pSelf, $iCommandId, $pKey, $vCurVal, $vNewVal
;~ 	ConsoleWrite("_MyHandler_UpdateProperty called" & $iCommandId & "    $vCurVal = " & $vCurVal & "    $vNewVal = " & $vNewVal & @CRLF)
	Return 0 ; S_OK
EndFunc   ;==>_MyHandler_UpdateProperty
;********************************************************************************************;


; Helper functions:
Func _ReadColor($iCommandId)
	Local $tPKEY = PSPropertyKeyFromString($sUI_PKEY_Color)
	Local $iColor
	$oRibbFramework.GetUICommandProperty($iCommandId, $tPKEY, $iColor)
	Return Dec(Hex(BinaryMid($iColor, 1, 3))) ; AGBR to RGB
EndFunc   ;==>_ReadColor

Func _ReadFontSize($vVar)
	Local $iSize = 9
	Local $tVARUnk = DllStructCreate($tagVARIANT, $vVar)

	Local $oPropertyStore = ObjCreateInterface(DllStructGetData($tVARUnk, "data"), $sIID_IPropertyStore, $tagIPropertyStore)
	If @error Then Return $iSize
	$oPropertyStore.AddRef()

	Local $tPKEY = PSPropertyKeyFromString($sUI_PKEY_FontProperties_Size)

	$oPropertyStore.GetValue($tPKEY, $iSize)

	Return $iSize
EndFunc   ;==>_ReadFontSize

Func _ReadFontWeight($vVar)
	Local $iWeight = 400
	Local $tVARUnk = DllStructCreate($tagVARIANT, $vVar)

	Local $oPropertyStore = ObjCreateInterface(DllStructGetData($tVARUnk, "data"), $sIID_IPropertyStore, $tagIPropertyStore)
	If @error Then Return $iWeight
	$oPropertyStore.AddRef()

	Local $tPKEY = PSPropertyKeyFromString($sUI_PKEY_FontProperties_Bold)

	$oPropertyStore.GetValue($tPKEY, $iWeight)

	Return $iWeight * 400
EndFunc   ;==>_ReadFontWeight

Func _ReadFontAttrib($vVar)
	Local $iAttrib = 0
	Local $tVARUnk = DllStructCreate($tagVARIANT, $vVar)

	Local $oPropertyStore = ObjCreateInterface(DllStructGetData($tVARUnk, "data"), $sIID_IPropertyStore, $tagIPropertyStore)
	If @error Then Return $iAttrib
	$oPropertyStore.AddRef()

	Local $tPKEY, $iItalic, $iUnderline, $iStrikethrough

	$tPKEY = PSPropertyKeyFromString($sUI_PKEY_FontProperties_Italic)
	$oPropertyStore.GetValue($tPKEY, $iItalic)
	If $iItalic = 2 Then $iAttrib += 2
	$tPKEY = PSPropertyKeyFromString($sUI_PKEY_FontProperties_Underline)
	$oPropertyStore.GetValue($tPKEY, $iUnderline)
	If $iUnderline = 2 Then $iAttrib += 4
	$tPKEY = PSPropertyKeyFromString($sUI_PKEY_FontProperties_Strikethrough)
	$oPropertyStore.GetValue($tPKEY, $iStrikethrough)
	If $iStrikethrough = 2 Then $iAttrib += 8

	Return $iAttrib
EndFunc   ;==>_ReadFontAttrib

Func _ReadFontFamily($vVar)
	Local $sFamily = ""
	Local $tVARUnk = DllStructCreate($tagVARIANT, $vVar)

	Local $oPropertyStore = ObjCreateInterface(DllStructGetData($tVARUnk, "data"), $sIID_IPropertyStore, $tagIPropertyStore)
	If @error Then Return $sFamily
	$oPropertyStore.AddRef()

	Local $tPKEY = PSPropertyKeyFromString($sUI_PKEY_FontProperties_Family)

	$oPropertyStore.GetValue($tPKEY, $sFamily)

	Return $sFamily
EndFunc   ;==>_ReadFontFamily

Func _GetGlobalColor()
	Local $oPropertyStore = ObjCreateInterface($oRibbFramework(), $sIID_IPropertyStore, $tagIPropertyStore)
	If @error Then Return SetError(1, 0, 0)
	$oPropertyStore.AddRef()
	Local $tPKEY = PSPropertyKeyFromString($sUI_PKEY_GlobalBackgroundColor)
	Local $iColor
	If $oPropertyStore.GetValue($tPKEY, $iColor) Then Return SetError(2, 0, 0)
	Return $iColor
EndFunc   ;==>_GetGlobalColor





Func _PlayMusic($fPlay = True)
	If Not $fPlay Then Return SoundPlay("")
	Local $sMusicFile = @SystemDir & "\oobe\images\title.wma"
	If FileExists($sMusicFile) Then ; XP
		SoundPlay($sMusicFile) ; (No way this will play, lol)
	Else
		$sMusicFile = @HomeDrive & "\Users\Public\Music\Sample Music\One Step Beyond.wma"
		If FileExists($sMusicFile) Then ; Vista
			SoundPlay($sMusicFile) ; (Maybe, who knows)
		Else
			$sMusicFile = @HomeDrive & "\Users\Public\Music\Sample Music\Kalimba.mp3"
			If FileExists($sMusicFile) Then ; Windows 7
				SoundPlay($sMusicFile) ; Play Lola Play
			Else
				;nothing
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_PlayMusic