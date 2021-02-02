#include-once
Global Const $OLE32 = DllOpen("ole32.dll")

; Prog@ndy
Func MAKE_HRESULT($sev, $fac, $code)
	Return BitOR(BitShift($sev, -31), BitOR(BitShift($fac, -16), $code))
EndFunc   ;==>MAKE_HRESULT

Global Const $CLSCTX_INPROC_SERVER = 1
Global Const $CLSCTX_LOCAL_SERVER = 4
Global Const $CLSCTX_SERVER = BitOR($CLSCTX_INPROC_SERVER, $CLSCTX_LOCAL_SERVER)
Global Const $HRESULT = "lresult"
Global Const $S_OK = 0
Global Const $E_NOINTERFACE = 0x80004002
Global Const $E_ABORT = 0x80004004
Global Const $E_ACCESSDENIED = 0x80070005
Global Const $E_FAIL = 0x80004005
Global Const $E_INVALIDARG = 0x80070057
Global Const $E_HANDLE = 0x80070006
Global Const $E_NOTIMPL = 0x80004001
Global Const $E_OUTOFMEMORY = 0x8007000E
Global Const $E_PENDING = 0x8000000A
Global Const $E_POINTER = 0x80004003
Global Const $E_UNEXPECTED = 0x8000FFFF

Global Const $OLE_E_ADVF = 0x80040001
Global Const $OLE_E_ADVISENOTSUPPORTED = 0x80040003
Global Const $OLE_E_BLANK = 0x80040007
Global Const $OLE_E_CANT_BINDTOSOURCE = 0x8004000A
Global Const $OLE_E_CANT_GETMONIKER = 0x80040009
Global Const $OLE_E_CANTCONVERT = 0x80040011
Global Const $OLE_E_CLASSDIFF = 0x80040008
Global Const $OLE_E_ENUM_NOMORE = 0x80040002
Global Const $OLE_E_FIRST = 0x80040000
Global Const $OLE_E_INVALIDHWND = 0x8004000F
Global Const $OLE_E_INVALIDRECT = 0x8004000D
Global Const $OLE_E_LAST = 0x800400FF
Global Const $OLE_E_NOCACHE = 0x80040006
Global Const $OLE_E_NOCONNECTION = 0x80040004
Global Const $OLE_E_NOSTORAGE = 0x80040012
Global Const $OLE_E_NOT_INPLACEACTIVE = 0x80040010
Global Const $OLE_E_NOTRUNNING = 0x80040005
Global Const $OLE_E_OLEVERB = 0x80040000
Global Const $OLE_E_PROMPTSAVECANCELLED = 0x8004000C
Global Const $OLE_E_STATIC = 0x8004000B
Global Const $OLE_E_WRONGCOMPOBJ = 0x8004000E

Global Const $IID_IUnknown = _GUID("{00000000-0000-0000-C000-000000000046}")

Global Const $tagIID = "DWORD Data1;  ushort Data2;  ushort Data3;  BYTE Data4[8];"
; Prog@ndy
Func _GUID($IID)
	$IID = StringRegExpReplace($IID, "([}{])", "")
	$IID = StringSplit($IID, "-")
	Local $_GUID = "DWORD Data1;  ushort Data2;  ushort Data3;  BYTE Data4[8];"
	Local $GUID = DllStructCreate($_GUID)
	If $IID[0] = 5 Then $IID[4] &= $IID[5]
	If $IID[0] > 5 Or $IID[0] < 4 Then Return SetError(1, 0, 0)
	DllStructSetData($GUID, 1, Dec($IID[1]))
	DllStructSetData($GUID, 2, Dec($IID[2]))
	DllStructSetData($GUID, 3, Dec($IID[3]))
	DllStructSetData($GUID, 4, Binary("0x" & $IID[4]))
	Return $GUID
EndFunc   ;==>_GUID

; Prog@ndy
; compares two GUID / IID DLLStructs
Func _GUID_Compare(Const ByRef $IID1, Const ByRef $IID2)
	Local $a, $b
	For $i = 1 To 4
		$a = DllStructGetData($IID1, $i)
		If @error Then Return SetError(1, 0, 0)
		$b = DllStructGetData($IID2, $i)
		If @error Then Return SetError(1, 0, 0)
		If $a <> $b Then Return 0
	Next
	Return 1
EndFunc   ;==>_GUID_Compare

; The IUnknown-Interface
; description: http://www.reactos.org/generated/doxygen/d8/de9/interfaceIUnknown.html
Global Const $IUnknown = "ptr IUnknown;"
Global Const $IUnknown_vTable = "ptr QueryInterface; ptr AddRef; ptr Release;"
;~ 	/*** IUnknown methods ***/
;~ 	STDMETHOD_(HRESULT,QueryInterface)(THIS_ REFIID riid, void** ppvObject) PURE;
; Prog@ndy
Func _IUnknown_QueryInterface(Const ByRef $ObjArr, Const ByRef $REFIID)
	Local $ret = _ObjFuncCall($HRESULT, $ObjArr, "QueryInterface", "ptr", DllStructGetPtr($REFIID), "ptr*", 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetError($ret[0], 0, $ret[3])
EndFunc   ;==>_IUnknown_QueryInterface

; Prog@ndy
Func _IUnknown_AddRef(Const ByRef $ObjArr)
	Local $ret = _ObjFuncCall("ULONG", $ObjArr, "AddRef")
	If @error Then Return SetError(1, 0, 0)
	Return SetError($ret[0] < 1, 0, $ret[0])
EndFunc   ;==>_IUnknown_AddRef

; Prog@ndy
Func _IUnknown_Release(Const ByRef $ObjArr)
	Local $ret = _ObjFuncCall("ULONG", $ObjArr, "Release")
	If @error Then Return SetError(1, 0, 0)
	Return SetError($ret[0], 0, $ret[0] = 0)
EndFunc   ;==>_IUnknown_Release

; -- #Region MemoryCalls -----------------------------------
#Region Call ObjectFuncs
; _ObjFunc.. are the MemoryFunc... functions from http://www.autoitscript.com/forum/index.php?showtopic=77463
;~ Global $__COMFN_HookPtr, $__COMFN_HookBak, $__COMFN_HookApi = "LocalFlags", $__COMFN_Kernel32Dll = DllOpen("kernel32.dll")
Global $__COMFN_HookPtr, $__COMFN_HookBak, $__COMFN_HookApi = "WinExec", $__COMFN_Kernel32Dll = DllOpen("kernel32.dll")
; by Ward
Func _ObjFuncInit()
	Local $KernelHandle = DllCall($__COMFN_Kernel32Dll, "ptr", "LoadLibrary", "str", "kernel32.dll")
	Local $HookPtr = DllCall($__COMFN_Kernel32Dll, "ptr", "GetProcAddress", "ptr", $KernelHandle[0], "str", $__COMFN_HookApi)
	$__COMFN_HookPtr = $HookPtr[0]

	$__COMFN_HookBak = DllStructCreate("ubyte[7]")
	DllCall($__COMFN_Kernel32Dll, "int", "WriteProcessMemory", "ptr", -1, "ptr", DllStructGetPtr($__COMFN_HookBak), "ptr", $__COMFN_HookPtr, "uint", 7, "uint*", 0)

	DllCall($__COMFN_Kernel32Dll, "int", "WriteProcessMemory", "ptr", -1, "ptr", $__COMFN_HookPtr, "byte*", 0xB8, "uint", 1, "uint*", 0)
	DllCall($__COMFN_Kernel32Dll, "int", "WriteProcessMemory", "ptr", -1, "ptr", $__COMFN_HookPtr + 5, "ushort*", 0xE0FF, "uint", 2, "uint*", 0)
EndFunc   ;==>_ObjFuncInit

; by Ward
; modified by Prog@ndy
; Return array: [0] - result
;               [1] - Object Pointer
;               [2] - first parameter
;               [n+1] - n-th Parameter
Func _ObjFuncCall($RetType, Const ByRef $ObjArr, $sFuncName, $Type1 = "", $Param1 = 0, $Type2 = "", $Param2 = 0, $Type3 = "", $Param3 = 0, $Type4 = "", $Param4 = 0, $Type5 = "", $Param5 = 0, $Type6 = "", $Param6 = 0, $Type7 = "", $Param7 = 0, $Type8 = "", $Param8 = 0, $Type9 = "", $Param9 = 0, $Type10 = "", $Param10 = 0, $Type11 = "", $Param11 = 0, $Type12 = "", $Param12 = 0, $Type13 = "", $Param13 = 0, $Type14 = "", $Param14 = 0, $Type15 = "", $Param15 = 0, $Type16 = "", $Param16 = 0, $Type17 = "", $Param17 = 0, $Type18 = "", $Param18 = 0, $Type19 = "", $Param19 = 0, $Type20 = "", $Param20 = 0)
	If Not IsDllStruct($__COMFN_HookBak) Then _ObjFuncInit()

	Local $Address = _ObjGetFuncPtr($ObjArr, $sFuncName)
	If @error Then Return SetError(1, -1, 0)
	If $Address = 0 Then Return SetError(3, -1, 0)

	_ObjFuncSet($Address)
	Local $ret
	Switch @NumParams
		Case 3
			$ret = DllCall($__COMFN_Kernel32Dll, $RetType, $__COMFN_HookApi, "ptr", $ObjArr[0])
		Case 5
			$ret = DllCall($__COMFN_Kernel32Dll, $RetType, $__COMFN_HookApi, "ptr", $ObjArr[0], $Type1, $Param1)
		Case 7
			$ret = DllCall($__COMFN_Kernel32Dll, $RetType, $__COMFN_HookApi, "ptr", $ObjArr[0], $Type1, $Param1, $Type2, $Param2)
		Case 9
			$ret = DllCall($__COMFN_Kernel32Dll, $RetType, $__COMFN_HookApi, "ptr", $ObjArr[0], $Type1, $Param1, $Type2, $Param2, $Type3, $Param3)
		Case 11
			$ret = DllCall($__COMFN_Kernel32Dll, $RetType, $__COMFN_HookApi, "ptr", $ObjArr[0], $Type1, $Param1, $Type2, $Param2, $Type3, $Param3, $Type4, $Param4)
		Case 13
			$ret = DllCall($__COMFN_Kernel32Dll, $RetType, $__COMFN_HookApi, "ptr", $ObjArr[0], $Type1, $Param1, $Type2, $Param2, $Type3, $Param3, $Type4, $Param4, $Type5, $Param5)
		Case Else
			If Mod(@NumParams, 2) = 0 Then Return SetError(2, -1, 0)
			Local $DllCallStr = 'DllCall($__COMFN_Kernel32Dll, $RetType, $__COMFN_HookApi, "ptr", $ObjArr[0]', $n, $i
			For $i = 5 To @NumParams Step 2
				$n = ($i - 3) / 2
				$DllCallStr &= ', $Type' & $n & ', $Param' & $n
			Next
			$DllCallStr &= ')'

			$ret = Execute($DllCallStr)
	EndSwitch
	SetError(@error, @extended)
	Return $ret
EndFunc   ;==>_ObjFuncCall
; by Ward
Func _ObjFuncSet($Address)
	DllCall($__COMFN_Kernel32Dll, "int", "WriteProcessMemory", "ptr", -1, "ptr", $__COMFN_HookPtr + 1, "uint*", $Address, "uint", 4, "uint*", 0)
EndFunc   ;==>_ObjFuncSet
; by Ward
Func _ObjFuncExit()
	DllCall($__COMFN_Kernel32Dll, "int", "WriteProcessMemory", "ptr", -1, "ptr", $__COMFN_HookPtr, "ptr", DllStructGetPtr($__COMFN_HookBak), "uint", 7, "uint*", 0)
	$__COMFN_HookBak = 0
EndFunc   ;==>_ObjFuncExit
#EndRegion Call ObjectFuncs
; -- #EndRedion MemoryCalls -----------------------------------

; Prog@ndy
Func _ObjCreateFromPtr($ObjPointer, $vTable)
	If Not $ObjPointer Then Return SetError(1, 0, 0)
	Local $object[3] = [$ObjPointer]
	$object[1] = DllStructCreate("ptr lpvTable", Ptr($object[0]))
	If @error Then Return SetError(2, 0, 0)
	$object[2] = DllStructCreate($vTable, DllStructGetData($object[1], 1))
	If @error Then Return SetError(3, 0, 0)
	Return $object
EndFunc   ;==>_ObjCreateFromPtr

; Prog@ndy
Func _ObjCoCreateInstance(Const ByRef $CLSID, Const ByRef $IID, $ObjvTable, $clsctx = $CLSCTX_INPROC_SERVER)

;~ 	Local $ret = DllCall($OLE32,"long_ptr","CoCreateInstance","ptr",DllStructGetPtr($CLSID),"ptr",0,"dword",$CLSCTX_SERVER, "ptr",DllStructGetPtr($IID),"ptr*",0)
	Local $ret = DllCall($OLE32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($CLSID), "ptr", 0, "dword", $clsctx, "ptr", DllStructGetPtr($IID), "ptr*", 0)
	Local $object[3] = [$ret[5], 0, 0]
	; get the interface
	$object[1] = DllStructCreate("ptr lpvTable", $object[0])
	$object[2] = DllStructCreate($ObjvTable, DllStructGetData($object[1], 1))
	SetExtended($ret[0])
	Return $object
EndFunc   ;==>_ObjCoCreateInstance

; Prog@ndy
Func _ObjCoInitialize()
	Local $result = DllCall($OLE32, $HRESULT, "CoInitialize", "ptr", 0)
	Return $result[0]
EndFunc   ;==>_ObjCoInitialize

; Prog@ndy
Func _ObjCoUninitialize()
	Local $result = DllCall($OLE32, $HRESULT, "CoUninitialize")
	Return $result[0]
EndFunc   ;==>_ObjCoUninitialize

; Prog@ndy
Func _ObjGetFuncPtr(Const ByRef $ObjArr, $FuncName)
	If UBound($ObjArr) <> 3 Then Return SetError(1, 0, 0)
	Return DllStructGetData($ObjArr[2], $FuncName)
EndFunc   ;==>_ObjGetFuncPtr
; Prog@ndy
Func _ObjGetObjPtr(Const ByRef $ObjArr)
	If UBound($ObjArr) <> 3 Then Return SetError(1, 0, 0)
	If DllStructGetData($ObjArr[1], 1) = 0 Then Return SetError(2, 0, 0)
	Return $ObjArr[0]
EndFunc   ;==>_ObjGetObjPtr
; Prog@ndy
Func _OLEInitialize()
	Local $result = DllCall($OLE32, $HRESULT, "OleInitialize", "ptr", 0)
	Return $result[0]
EndFunc   ;==>_OLEInitialize
; Prog@ndy
Func _OLEUnInitialize()
	Local $result = DllCall($OLE32, $HRESULT, "OleUninitialize")
	Return $result[0]
EndFunc   ;==>_OLEUnInitialize

Func _CoTaskMemAlloc($iSize)
	Local $result = DllCall($OLE32, "ptr", "CoTaskMemAlloc", "ulong", $iSize)
	Return $result[0]
EndFunc   ;==>_CoTaskMemAlloc

Func _CoTaskMemFree($pMem)
	DllCall($OLE32, "none", "CoTaskMemFree", "ptr", $pMem)
EndFunc   ;==>_CoTaskMemFree
Func _CoTaskMemRealloc($pMem, $iSize)
	Local $result = DllCall($OLE32, "ptr", "CoTaskMemRealloc", "ptr", $pMem, "ulong", $iSize)
	Return $result[0]
EndFunc   ;==>_CoTaskMemRealloc
