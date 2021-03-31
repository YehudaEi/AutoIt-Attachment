#AutoIt3Wrapper_Add_Constants=n
;for thread where this udf posted see
;http://www.autoitscript.com/forum/topic/71811-functions-with-parameters-in-onevent-and-hotkeys/page__p__525175__hl__oneventfunc__fromsearch__1
;opt("mustdeclarevars",1) ;for testing
#include <array.au3>
#include <GUIConstantsEx.au3>
;OnEventFunc
;UDF to allow onevent or HotKeys to be used to call functions with parameters.
;Version 2 - allowed for variables to be used as parameters to the event function
;        3 - added GetCtrlID and GetCtrlHandle. Added Const $MAX_NUM_PARAMS
;        4 - added function _GUIGetLastCtrlID(). Thanks to MsCreatoR
;        5 - removed check for handle in SetOnEvent because some controls do not have handles.
;        6 - tidied up a bit, added @error = param number if SetOnEvent returns error because
;				parameter for a variable was not a string.
;        7 - added HotKey set
;        8 - set Fn to '' if error in SetOnEvent.
;        9 - 10th June 2008 removed parameter for number of parameters to be passed from SetOnEvent
;            NB Breaks scripts using previous version so made new function SetOnEventA which
;            is called by SetOnEvent. Then old scripts will still work, new scripts can use SetOnEventA.
;       10 - Added Gui Events. Thanks to GaRydelaMer for the nudge and the suggested approach.
;       11  - corrected error in position of endif and setting hotkey
;       12 - Added TraySetOnEventA
;       13 - Corrected failing to declare $oParCount in 2 functions as pointed out by ovideo 13th Oct 2011
;Author Martin Gibson (martin)



;Functions for use in scripts
; SetOnEventA - set the function to be called by a hotkey or event with the parameters to be passed
; TraySetOnEventA set the function to be called by a tray menu item with the parameters to be passed
; GetCtrlID - get the ID of the control which caused the event
; GetCtrlHandle - get the handle of the control which caused the event
; EventGetDragIDs for relevant IDs if the event was a drag operation.

#include-once

Const $PARAMBYVAL = 0
Const $PARAMBYREF = 1
Const $PARAMWINDOW = 3
Const $ParamArray = 2
Const $OE_HOTKEY = 1
Const $OE_CONTROL = 0
Const $OE_GUI = 2
Const $MAX_NUM_PARAMS = 5; if this is increased because you need more parameters for your functions then you must
; add extra parameter types and parameters in pairs to the function SetOnEvent.
;NB to pass any number of parameters you can simply write the function to receive an array and set the array as
; a variable to be passed to the function.

Global $CtrlLib[6][2][$MAX_NUM_PARAMS + 3]
;create an array to hold the list of controls, the functions they will call
;and the data they will use for parameters
; initially allow for 5 controls each with $MAX_NUM_PARAMS + 2 items of data.
;      $EventsData[0][0][0] = the number of controls stored with functions
;      $EventsData[1][1][0] = the CtrlID for item 1 (CtrlID1)
;                 [1][1][1] = the function to be called by CtrlID1 event
;                 [1][1][2] = the number of parametrs passed
;                 [1][1][3] = param 1 for the function called
;                 [1][1][4] = param 2 for the function to be called
;              ....[1][1][$MAX_NUM_PARAMS + 2] last param
;                 [1][0][3] to [1][0][$MAX_NUM_PARAMS + 2] the parameter types either $ParamBtVal or $ParamBtRef
;				  [1][0][0] the type. = 0 if GuiCrtlOnEvent, 1 if HotKey, 2 if gui event
;                 [1][0][1] if GuiOnEvent either 0 or hWnd if the window handle is passed


;SetOnEvent=====================================================================
;Description:  sets the function and parameters to be called.
;Parameters
;	$iCtrl			The control ID which creates the event. This can be -1 for the last ocntrol created
;
;	$sFunc			The name of the function to call
;	$par1 to $par5	The parameters to be passed to the function
;	$parType1 to
;	$parType5		Must be $ParamByVal or $ParamByRef	or $ParamArray
;					if $ParamByVal the val of the parameter is saved and
;						passed to the function when it is called.
;                   if $ParamByRef the name of the varaible	is saved, and
;						the current value of that variable is passed to
;						the function
;Note: If setting a Gui event then the first parameter must be passed by value and must
;       be the gui handle for the event to be dealt with,
;       or pass 0 if you are not concerned (because you only have one window for example).
;       You need not pass any parameters but then this udf is of no benifit.
;Returns          1 on success
;                -1 if illegal parameter type, with @error = parameter number
;                -2 if a parameter used for a variable is not a string
;                -3 if AutoIt mode is not OnEvent
;                -4 if wrong parameter for a gui event
;                -5 invalid window handle
;                -6 invalid hotkey
;Notes           Opt("GUIOnEventMode", 1) required in main script.
;===============================================================================

Func SetOnEventA($iCtrl, $sFunc, $ParType1 = 0, $Par1 = '', $ParType2 = 0, $par2 = '', $ParType3 = 0, $Par3 = '', $ParType4 = 0, $Par4 = '', $ParType5 = 0, $Par5 = '')
	Local $iParCount = (@NumParams - 2) / 2
	Return SetOnEventAT(0, $iParCount, $iCtrl, $sFunc, $ParType1, $Par1, $ParType2, $par2, $ParType3, $Par3, $ParType4, $Par4, $ParType5, $Par5)
EndFunc   ;==>SetOnEventA

;TraySetOnEvent=====================================================================
;Description:  sets the function and parameters to be called.
;Parameters
;	$iCtrl			The menu item ID which creates the event. This can be -1 for the last menuitem created
;
;	$sFunc			The name of the function to call
;	$par1 to $par5	The parameters to be passed to the function
;	$parType1 to
;	$parType5		Must be $ParamByVal or $ParamByRef	or $ParamArray
;					if $ParamByVal the val of the parameter is saved and
;						passed to the function when it is called.
;                   if $ParamByRef the name of the varaible	is saved, and
;						the current value of that variable is passed to
;						the function
;Note: If setting a Gui event then the first parameter must be passed by value and must
;       be the gui handle for the event to be dealt with,
;       or pass 0 if you are not concerned (because you only have one window for example).
;       You need not pass any parameters but then this udf is of no benifit.
;Returns          1 on success
;                -1 if illegal parameter type, with @error = parameter number
;                -2 if a parameter used for a variable is not a string
;                -3 if AutoIt mode is not OnEvent
;                -4 if wrong parameter for a gui event
;                -5 invalid window handle
;                -6 invalid hotkey
; Notes           opt("TrayOnEventMode",1) required in main script
;===============================================================================
Func TraySetOnEventA($iCtrl, $sFunc, $ParType1 = 0, $Par1 = '', $ParType2 = 0, $par2 = '', $ParType3 = 0, $Par3 = '', $ParType4 = 0, $Par4 = '', $ParType5 = 0, $Par5 = '')
	Local $tt, $iParCount
	If $iCtrl = -1 Then
		$tt = TrayCreateItem("")
		$iCtrl = $tt - 1
		TrayItemDelete($tt)
	EndIf

	$iParCount = (@NumParams - 2) / 2
	Return SetOnEventAT(1, $iParCount, $iCtrl, $sFunc, $ParType1, $Par1, $ParType2, $par2, $ParType3, $Par3, $ParType4, $Par4, $ParType5, $Par5)
EndFunc   ;==>TraySetOnEventA

Func SetOnEventAT($CtrlType, $iParCount, $iCtrl, $sFunc, $ParType1 = 0, $Par1 = '', $ParType2 = 0, $par2 = '', $ParType3 = 0, $Par3 = '', $ParType4 = 0, $Par4 = '', $ParType5 = 0, $Par5 = '');$CtrlType,

	Local $n, $aval, $item = 0


	If $iCtrl = -1 Then $iCtrl = _GUIGetLastCtrlID()



	For $n = 1 To $CtrlLib[0][0][0]
		If $CtrlLib[$n][1][0] = $iCtrl Then
			$item = $n;we are replacing previous settings
			ExitLoop
		EndIf
	Next

	If $item = 0 Then;Control has not been set before
		$CtrlLib[0][0][0] += 1
		$item = $CtrlLib[0][0][0]
		If UBound($CtrlLib) < $item + 1 Then ReDim $CtrlLib[$item + 2][2][$MAX_NUM_PARAMS + 3]
	EndIf
	If $CtrlType = 0 Then
		If IsString($iCtrl) Then;it's a hotkey
			If Not IsString($iCtrl) Or $iCtrl = '' Then Return -6;invalid hotkey
			HotKeySet($iCtrl, "HK_EventFunc")
			$CtrlLib[$item][0][0] = $OE_HOTKEY
		Else
			If Opt("GUIOnEventMode") = 0 Then
				Return -3;not using event mode
			EndIf
			If $iCtrl < -2 And $iCtrl > -14 Then;;;; <<<< Gui events added by GaRydelaMer
				If $ParType1 <> $PARAMBYVAL Then Return -4;can only pass the Window handle by Value
				If IsHWnd($Par1) Then
					$CtrlLib[$item][0][1] = $Par1
				ElseIf Number($Par1) = 0 Then
					$CtrlLib[$item][0][1] = 0
				Else
					Return -5;invalid parameter for window handle
				EndIf

				If $sFunc = '' Then
					GUISetOnEvent($iCtrl, "")
				Else
					GUISetOnEvent($iCtrl, "EventGuiFunc");;;all Gui events call this function..
				EndIf


				$CtrlLib[$item][0][0] = $OE_GUI;the type of event
			Else;it is a GuiCtrl event
				$CtrlLib[$item][0][0] = $OE_CONTROL

				If $sFunc = '' Then
					GUICtrlSetOnEvent($iCtrl, "")
				Else
					GUICtrlSetOnEvent($iCtrl, "EventCtrlFunc");all controls call this function
				EndIf
			EndIf


		EndIf
	Else
		TrayItemSetOnEvent($iCtrl, "TrayEventCtrlFunc")
		$CtrlLib[$item][0][0] = $OE_CONTROL
	EndIf

	Switch $CtrlLib[$item][0][0]
		Case $OE_HOTKEY
			$CtrlLib[$item][1][0] = $iCtrl;the hotkey keys
		Case $OE_CONTROL
			$CtrlLib[$item][1][0] = $iCtrl;the control ID

		Case $OE_GUI
			$CtrlLib[$item][1][0] = $iCtrl;the event ID
	EndSwitch

	$CtrlLib[$item][1][1] = $sFunc;the function to call
	$CtrlLib[$item][1][2] = $iParCount;the number of parameters to pass to the function

	For $n = 1 To $iParCount
		$CtrlLib[$item][0][$n + 2] = Eval("ParType" & $n)
		If $CtrlLib[$item][0][$n + 2] = $PARAMBYVAL Then
			$CtrlLib[$item][1][$n + 2] = Eval("Par" & $n)
		ElseIf ($CtrlLib[$item][0][$n + 2] = $PARAMBYREF) Then; Or ($CtrlLib[$item][0][$n + 2] = $PARAMBYEXPR) Then
			$aval = Eval("Par" & $n)
			If Not IsString($aval) Then
				$CtrlLib[$item][1][1] = ""
				SetError($n)
				Return -2;parambyref must be a string
			EndIf

			If StringLeft($aval, 1) = '$' Then
				$aval = StringRight($aval, StringLen($aval) - 1)
			EndIf

			$CtrlLib[$item][1][$n + 2] = $aval
		Else
			$CtrlLib[$item][1][1] = ""

			Return -1;illegal paramtype
		EndIf

	Next

	;In case guiEvent and window handle not passed
	If $CtrlLib[$item][0][0] = $OE_GUI And $iParCount = 0 Then
		$CtrlLib[$item][1][1 + 2] = 0;set window handle to 0
	EndIf





	Return 1;success
EndFunc   ;==>SetOnEventAT

;=========; _GUIGetLastCtrlID ==============================================
;returns the last ctrlID referenced
;From MrCreaTor
;Internal Use
;===========================================================================
Func _GUIGetLastCtrlID()

	Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", GUICtrlGetHandle(-1))
	Return $aRet[0]

EndFunc   ;==>_GUIGetLastCtrlID

;=============EventFunc ====================================================
;Description: 	All controls using SetOnEvent call this function.
;				Depending on the control which called this function another
;				function will be called with the required parameters.
;Internal Use only
;===========================================================================
Func EventCtrlFunc()
	Local $item; The index of the Ctrl in the EventsData array
	$item = GetItem(@GUI_CtrlId)
	If $item = -1 Then $item = GetItem(@TRAY_ID)
	If $item = -1 Then Return

	$CtrlLib[0][1][1] = $item; in case it's needed by the called function
	$CtrlLib[0][1][2] = @GUI_CtrlId;ditto. Can be retrieved with GetCtrlID()
	BuildFnCall($item)
EndFunc   ;==>EventCtrlFunc

Func TrayEventCtrlFunc()
	Local $item; The index of the Ctrl in the EventsData array

$item = GetItem(@TRAY_ID)
	If $item = -1 Then Return

	$CtrlLib[0][1][1] = $item; in case it's needed by the called function
	$CtrlLib[0][1][2] = @TRAY_ID;ditto. Can be retrieved with GetCtrlID()
	BuildFnCall($item)
EndFunc   ;==>TrayEventCtrlFunc

;=============EventFunc ====================================================
;Description: 	All controls using SetOnEvent call this function.
;				Depending on the control which called this function another
;				function will be called with the required parameters.
;Internal Use only
;===========================================================================
Func EventGuiFunc()
	Local $item; The index of the Ctrl in the EventsData array
	$item = GetItem(@GUI_CtrlId, @GUI_WinHandle)
	If $item = -1 Then Return

	$CtrlLib[0][1][1] = $item; in case it's needed by the called function
	$CtrlLib[0][1][2] = @GUI_CtrlId;ditto. Can be retrieved with GetCtrlID()
	If @GUI_CtrlId = $GUI_EVENT_DROPPED Then
		$CtrlLib[0][1][3] = @GUI_DragId; -*- can be retrieved with EventGetDragIDs
		$CtrlLib[0][1][4] = @GUI_DragFile; -*- ditto
		$CtrlLib[0][1][5] = @GUI_DropId ; -*- ditto
	EndIf

	BuildFnCall($item)
EndFunc   ;==>EventGuiFunc

;====== EventGetDragIDs =======================================================
;Parameters - none.
;Returns an array with 3 elements giving the IDs involved in the drag operation
;if this is not called in response to a gui event the ID could be meaningless.
;==============================================================================
Func EventGetDragIDs()
	Local $aDrag[3]
	$aDrag[0] = $CtrlLib[0][1][3]; the @GUI_DRAGID
	$aDrag[1] = $CtrlLib[0][1][4]; the @GUI_DRAGFILE
	$aDrag[2] = $CtrlLib[0][1][5]; the @GUI_DROPID
	Return $aDrag
EndFunc   ;==>EventGetDragIDs

;=============EventFunc ====================================================
;Description: 	All HotKeys using SetOnEvent call this function.
;				Depending on the control which called this function another
;				function will be called with the required parameters.
;Internal Use only
;===========================================================================
Func HK_EventFunc()
	Local $item; The index of the Ctrl in the EventsData array
	$item = GetItem(@HotKeyPressed)
	If $item = -1 Then Return
	$CtrlLib[0][1][1] = $item; in case it's needed by the called function
	$CtrlLib[0][1][2] = @HotKeyPressed;ditto. Can be retrieved with GetCtrlID()
	BuildFnCall($item)
EndFunc   ;==>HK_EventFunc

;===; BuilFnCall ============================================================
;Description; Calls the required function with the parameters as stored in
;				the Global arra $iCtrlLib
;Parameters;  $index - the index in the array
;Internal use
;===========================================================================

Func BuildFnCall($index)
	Local $Arrayset[$CtrlLib[$index][1][2] + 1]
	$Arrayset[0] = "CallArgArray"
	For $n = 1 To $CtrlLib[$index][1][2]
		If $CtrlLib[$index][0][$n + 2] = $PARAMBYVAL Then
			$Arrayset[$n] = $CtrlLib[$index][1][$n + 2]
		Else;it's $ParamByRef
			$Arrayset[$n] = Eval($CtrlLib[$index][1][$n + 2])
		EndIf
	Next


	If $CtrlLib[$index][1][2] = 0 Then
		Call($CtrlLib[$index][1][1])
	Else
		Call($CtrlLib[$index][1][1], $Arrayset)
	EndIf


EndFunc   ;==>BuildFnCall

;=============GetCtrlID ========================================================
;=Description: returns the Control ID of the last control , or the last
;=             	HotKey sequence which caused an	event and which was registered
;=				with SetOnEvent
;===============================================================================
Func GetCtrlID()

	Return $CtrlLib[0][1][2]

EndFunc   ;==>GetCtrlID

;Description: Returns the handle of the last control which caused an event and which was registered with SetOnEvent
;=========== GetCtrlHandle ======================================================
;Description: returns the handle of the last control which caused an
;				event and which was registered with SetOnEvent
; NOTE for controls which done't have a handle this function will return 0
;			;
;===============================================================================
Func GetCtrlHandle()
	If IsString($CtrlLib[0][1][2]) Or $CtrlLib[0][1][2] = 0 Then;Hotkey sequence
		Return 0
	Else
		Return GUICtrlGetHandle($CtrlLib[0][1][2])
	EndIf

EndFunc   ;==>GetCtrlHandle

;========= GetItem =============================================================
;Description: find the index in the array $CtrlLIb for the Control $id
;Parameter   $id the Control ID or Event IDto find in the array
;Internal Use
;===============================================================================
Func GetItem($id, $hWnd = 0)
	For $n = 0 To UBound($CtrlLib) - 1
		If $CtrlLib[$n][1][0] = $id Then
			If $CtrlLib[$n][0][0] = $OE_GUI Then
				If $CtrlLib[$n][0][1] = $hWnd Or $CtrlLib[$n][0][1] = 0 Then
					Return $n
				EndIf
			Else
				Return $n

			EndIf
		EndIf
	Next
	Return -1;failed
EndFunc   ;==>GetItem

;allows compatibility with earlier version (< Version 9)
;newer version should call SetOnEventA and omit the $iParCount parameter.
;The parameter $iParCount gives the number of parameters used by the function to be called
;See OnSetEvent for details of the other parameters and an explanation odf the function.
Func SetOnEvent($iCtrl, $sFunc, $iParCount = 0, $ParType1 = 0, $Par1 = '', $ParType2 = 0, $par2 = '', $ParType3 = 0, $Par3 = '', $ParType4 = 0, $Par4 = '', $ParType5 = 0, $Par5 = '')
	SetOnEventA($iCtrl, $sFunc, $ParType1, $Par1, $ParType2, $par2, $ParType3, $Par3, $ParType4, $Par4, $ParType5, $Par5)
EndFunc   ;==>SetOnEvent




