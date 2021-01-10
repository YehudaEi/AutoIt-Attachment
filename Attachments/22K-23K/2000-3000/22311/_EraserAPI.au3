#include-once

#cs -----------------------------------------------------------------------------------------------

Title......: _EraserAPI
Author.....: Erik Pilsits
Description: Eraser API Function Header
Date.......: September 17, 2008

#ce -----------------------------------------------------------------------------------------------

Global Const $BUILTIN_METHOD_ID = 0x80
Global Const $GUTMANN_METHOD_ID = BitOR(BitShift(1, 0), $BUILTIN_METHOD_ID)
Global Const $DOD_METHOD_ID = BitOR(BitShift(1, -1), $BUILTIN_METHOD_ID)
Global Const $DOD_E_METHOD_ID = BitOR(BitShift(1, -2), $BUILTIN_METHOD_ID)
Global Const $RANDOM_METHOD_ID = BitOR(BitShift(1, -3), $BUILTIN_METHOD_ID)
Global Const $SCHNEIER_METHOD_ID = BitOR(BitShift(1, -5), $BUILTIN_METHOD_ID)

Global Const $PASSES_GUTMANN = 35
Global Const $PASSES_DOD = 7
Global Const $PASSES_DOD_E = 3
Global Const $PASSES_RND = 1
Global Const $PASSES_SCHNEIER = 7

Global Const $diskClusterTips = 64
Global Const $diskDirEntries = 128
Global Const $diskFreeSpace = 32
Global Const $ERASER_ERROR = -1
Global Const $ERASER_ERROR_CONTEXT = -11
Global Const $ERASER_ERROR_DENIED = -15
Global Const $ERASER_ERROR_EXCEPTION = -10
Global Const $ERASER_ERROR_INIT = -12
Global Const $ERASER_ERROR_MEMORY = -8
Global Const $ERASER_ERROR_NOTIMPLEMENTED = -32
Global Const $ERASER_ERROR_NOTRUNNING = -14
Global Const $ERASER_ERROR_PARAM1 = -2
Global Const $ERASER_ERROR_PARAM2 = -3
Global Const $ERASER_ERROR_PARAM3 = -4
Global Const $ERASER_ERROR_PARAM4 = -5
Global Const $ERASER_ERROR_PARAM5 = -6
Global Const $ERASER_ERROR_PARAM6 = -7
Global Const $ERASER_ERROR_RUNNING = -13
Global Const $ERASER_ERROR_THREAD = -9
Global Const $ERASER_OK = 0
Global Const $ERASER_REMOVE_FOLDERONLY = 0
Global Const $ERASER_REMOVE_RECURSIVELY = 1
Global Const $ERASER_TEST_PAUSED = 3
Global Const $ERASER_WIPE_BEGIN = 0
Global Const $ERASER_WIPE_UPDATE = 1
Global Const $ERASER_WIPE_DONE = 2
Global Const $eraserDispInit = 64
Global Const $eraserDispItem = 32
Global Const $eraserDispMessage = 4
Global Const $eraserDispPass = 1
Global Const $eraserDispProgress = 8
Global Const $eraserDispReserved = 128
Global Const $eraserDispStop = 16
Global Const $eraserDispTime = 2
Global Const $fileAlternateStreams = 4
Global Const $fileClusterTips = 1
Global Const $fileNames = 2

Global Const $ERASER_DATA_DRIVES = 0
Global Const $ERASER_DATA_FILES = 1

Global Const $MAX_PATH = 260
Global $EraserDll
Global $Dll_path = @ScriptDir & "\Eraser.dll"

; =================================================================================================
; LIBRARY
; =================================================================================================

Func _EraserInit($path = $Dll_path)
	Local $ret
	
	$EraserDll = DllOpen($path)
	If $EraserDll == -1 Then
		$EraserDll = ""
		Return SetError(1, 0, -1)
	EndIf
	$ret = DllCall($EraserDll, "int", "_eraserInit@0")
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		DllClose($EraserDll)
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserInit

Func _EraserEnd()
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserEnd@0")
	DllClose($EraserDll)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserEnd

; =================================================================================================
; CONTEXT
; =================================================================================================

Func _EraserCreateContextEx($method = $RANDOM_METHOD_ID, $passes = -1)
	Local $ret
	
	$passes = _ConvertIdToPasses($method, $passes)
	
	$ret = DllCall($EraserDll, "int", "_eraserCreateContextEx@16", "ptr*", "", "ubyte", $method, "ushort", $passes, "ubyte", Chr(0))
	If $ret[0] == $ERASER_OK Then
		Return $ret[1]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserCreateContextEx

Func _EraserDestroyContext($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserDestroyContext@4", "ptr", $context)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserDestroyContext

Func _EraserIsValidContext($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserIsValidContext@4", "ptr", $context)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserIsValidContext

; =================================================================================================
; DATA TYPE
; =================================================================================================

Func _EraserSetDataType($context, $type = $ERASER_DATA_FILES)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserSetDataType@8", "ptr", $context, "int", $type)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserSetDataType

Func _EraserGetDataType($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserGetDataType@8", "ptr", $context, "int*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserGetDataType

; =================================================================================================
; DATA
; =================================================================================================

Func _EraserAddItem($context, $item)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserAddItem@12", "ptr", $context, "str", $item, "ushort", StringLen($item))
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserAddItem

Func _EraserClearItems($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserClearItems@4", "ptr", $context)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserClearItems

; =================================================================================================
; NOTIFICATION
; =================================================================================================

Func _EraserSetWindow($context, $hwnd)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserSetWindow@8", "ptr", $context, "hwnd", $hwnd)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserSetWindow

Func _EraserGetWindow($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserGetWindow@8", "ptr", $context, "hwnd*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserGetWindow

Func _EraserSetWindowMessage($context, $msg)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserSetWindowMessage@8", "ptr", $context, "uint", $msg)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserSetWindowMessage

Func _EraserGetWindowMessage($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserGetWindowMessage@8", "ptr", $context, "uint*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserGetWindowMessage

; =================================================================================================
; STATISTICS
; =================================================================================================

Func _EraserStatGetArea($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserStatGetArea@8", "ptr", $context, "uint64*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserStatGetArea

Func _EraserStatGetWiped($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserStatGetWiped@8", "ptr", $context, "uint64*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserStatGetWiped

Func _EraserStatGetTime($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserStatGetTime@8", "ptr", $context, "uint64*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserStatGetTime

; =================================================================================================
; DISPLAY
; =================================================================================================

Func _EraserDispFlags($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserDispFlags@8", "ptr", $context, "ubyte*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserDispFlags

; =================================================================================================
; PROGRESS
; =================================================================================================

Func _EraserProgGetTimeLeft($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserProgGetTimeLeft@8", "ptr", $context, "uint*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserProgGetTimeLeft

Func _EraserProgGetPercent($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserProgGetPercent@8", "ptr", $context, "ubyte*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserProgGetPercent

Func _EraserProgGetTotalPercent($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserProgGetTotalPercent@8", "ptr", $context, "ubyte*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserProgGetTotalPercent

Func _EraserProgGetCurrentPass($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserProgGetCurrentPass@8", "ptr", $context, "ushort*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserProgGetCurrentPass

Func _EraserProgGetPasses($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserProgGetPasses@8", "ptr", $context, "ushort*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserProgGetPasses

Func _EraserProgGetMessage($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserProgGetMessage@12", "ptr", $context, "str", "", "ushort*", $MAX_PATH)
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserProgGetMessage

Func _EraserProgGetCurrentDataString($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserProgGetCurrentDataString@12", "ptr", $context, "str", "", "ushort*", $MAX_PATH)
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserProgGetCurrentDataString

; =================================================================================================
; CONTROL
; =================================================================================================

Func _EraserStart($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserStart@4", "ptr", $context)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserStart

Func _EraserIsRunning($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserIsRunning@8", "ptr", $context, "ubyte*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserIsRunning || 0 = false, 1 = true

; =================================================================================================
; RESULT
; =================================================================================================

Func _EraserCompleted($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserCompleted@8", "ptr", $context, "ubyte*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserCompleted || 0 = false, 1 = true

Func _EraserFailed($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserFailed@8", "ptr", $context, "ubyte*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; == _EraserFailed || 0 = false, 1 = true

Func _EraserTerminated($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserTerminated@8", "ptr", $context, "ubyte*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; == _EraserTerminated || 0 = false, 1 = true

Func _EraserErrorStringCount($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserErrorStringCount@8", "ptr", $context, "ushort*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserErrorStringCount

Func _EraserErrorString($context, $index)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserErrorString@16", "ptr", $context, "ushort", $index, "str", "", "ushort*", $MAX_PATH)
	If $ret[0] == $ERASER_OK Then
		Return $ret[3]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserErrorString

Func _EraserFailedCount($context)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserFailedCount@8", "ptr", $context, "ushort*", "")
	If $ret[0] == $ERASER_OK Then
		Return $ret[2]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserFailedCount

Func _EraserFailedString($context, $index)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserFailedString@16", "ptr", $context, "uint", $index, "str", "", "ushort*", $MAX_PATH)
	If $ret[0] == $ERASER_OK Then
		Return $ret[3]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserFailedString

; =================================================================================================
; REPORT
; =================================================================================================

Func _EraserShowReport($context, $hwnd)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserShowReport@8", "ptr", $context, "hwnd", $hwnd)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserShowReport

; =================================================================================================
; FILE / DIR DELETION
; =================================================================================================

Func _EraserRemoveFile($file)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserRemoveFile@8", "str", $file, "ushort", StringLen($file))
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserRemoveFile

Func _EraserRemoveFolder($folder, $mode = $ERASER_REMOVE_FOLDERONLY)
	Local $ret
	
	$ret = DllCall($EraserDll, "int", "_eraserRemoveFolder@12", "str", $folder, "ushort", StringLen($folder), "ubyte", $mode)
	If $ret[0] == $ERASER_OK Then
		Return $ret[0]
	Else
		Return SetError($ret[0], 0, $ret[0])
	EndIf
EndFunc ; ==> _EraserRemoveFolder

; =================================================================================================
; MISC
; =================================================================================================

Func _EraserOK($value)
	Return $value >= $ERASER_OK
EndFunc ; ==> _EraserOK

Func _ConvertIdToPasses($method, $passes)
	If $method == $RANDOM_METHOD_ID And $passes <> -1 Then Return $passes
	
	Switch $method
		Case $GUTMANN_METHOD_ID
			Return $PASSES_GUTMANN
		Case $DOD_METHOD_ID, $SCHNEIER_METHOD_ID
			Return $PASSES_DOD
		Case $DOD_E_METHOD_ID
			Return $PASSES_DOD_E
		Case $RANDOM_METHOD_ID
			Return $PASSES_RND
	EndSwitch
EndFunc ; ==> _ConvertIdToPasses