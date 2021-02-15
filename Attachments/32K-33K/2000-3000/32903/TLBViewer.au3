#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; TYPELIB VIEWER
;.......script written by trancexx (trancexx at yahoo dot com)

Opt("WinWaitDelay", 0) ; 0 ms

HotKeySet("{ESC}", "_TLB_Quit")
Func _TLB_Quit()
	Exit
EndFunc   ;==>_TLB_Quit

; DLLs to use
Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hSHELL32 = DllOpen("shell32.dll")

Global $aTypelib[1]

; GUI
Global $hGUI = GUICreate("TLB Viewer ", 500, 500, -1, -1, 0xCF0000, 16) ; WS_OVERLAPPEDWINDOW, $WS_EX_ACCEPTFILES
;GUISetIcon(@SystemDir & "\msdxm.tlb")
Global $hEditViewTLB = GUICtrlCreateEdit("", 10, 10, 480, 420, 0x3018C0) ; $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY   ;0x804) ; ES_READONLY|ES_MULTILINE
GUICtrlSetResizing(-1, 102)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 9, 400, 0, "Tahoma", 5)
Global $hButtonBrowse = GUICtrlCreateButton("&Open", 20, 455, 70, 25)
GUICtrlSetResizing(-1, 834)
GUICtrlSetTip(-1, "Browse for TLB")
Global $hButtonNew = GUICtrlCreateButton("O&ther", 95, 455, 70, 25)
GUICtrlSetResizing(-1, 834)
GUICtrlSetState(-1, 128) ; $GUI_DISABLE
GUICtrlSetTip(-1, "Select different TLB found inside loaded file")
Global $hButtonClose = GUICtrlCreateButton("Cl&ose", 365, 455, 90, 25)
GUICtrlSetResizing(-1, 836)
GUICtrlSetTip(-1, "Close this window")

Global $hDots = _TLB_CreateDragDots($hGUI)
; Additional win message processing
GUIRegisterMsg(5, "_TLB_WM_SIZE") ; WM_SIZE
GUIRegisterMsg(36, "_TLB_WM_GETMINMAXINFO") ; WM_GETMINMAXINFO
GUIRegisterMsg(563, "_TLB_WM_DROPFILES") ; WM_DROPFILES
; Show the GUI
GUISetState()

Global $sTLB ; file to load
Global $sTLBLoaded ; loaded file
Global $sTypeLibString
Global $aNameLang, $iIndex

If @Compiled Then $sTLB = StringReplace($CmdLineRaw, '"', "")

While 1
	Switch GUIGetMsg()
		Case -3, $hButtonClose
			Exit
		Case $hButtonBrowse
			$sTLB = FileOpenDialog("TLB Viewer ", "", "TLB(*.tlb;*.exe;*.dll;*.ocx)|(*.tlb)|(*.ocx)|All files(*)", 1, "", $hGUI)
		Case $hButtonNew
			$sTLB = $sTLBLoaded
	EndSwitch
	If $sTLB Then
		GUISetCursor(15, 1)
		GUISetState(@SW_LOCK, $hGUI)
		$sTLBLoaded = _TLB_GetTYPELIBS($sTLB)
		If @error Then
			$sTypeLibString = _TLB_TypelibMSFT(FileRead($sTLBLoaded), 0, 0, 0, True)
			If @error Then MsgBox(64, "No Typelib", "No MSFT Typelib inside this file!", 0, $hGUI)
			GUICtrlSetData($hEditViewTLB, $sTypeLibString)
			GUICtrlSetState($hButtonNew, 128) ; $GUI_DISABLE
		Else
			$iIndex = _TLB_ChooseTLB($aTypelib)
			$aNameLang = _TLB_GetNameLang($aTypelib, $iIndex)
			$sTypeLibString = _TLB_TypelibMSFT($sTLBLoaded, "TYPELIB", $aNameLang[0], $aNameLang[1])
			GUICtrlSetData($hEditViewTLB, $sTypeLibString)
			If UBound($aTypelib) > 1 Then
				GUICtrlSetState($hButtonNew, 64) ; $GUI_ENABLE
			Else
				GUICtrlSetState($hButtonNew, 128) ; $GUI_DISABLE
			EndIf
		EndIf
		GUISetState(@SW_UNLOCK, $hGUI)
		GUISetCursor(-1)
		GUICtrlSetData($hButtonBrowse, "&New")
		WinActivate($hGUI)
		WinSetTitle($hGUI, 0, "TLB Viewer - " & StringRegExpReplace($sTLBLoaded, ".*\\", ""))
		$sTLB = ""
	EndIf
WEnd


; GUI related functions...
Func _TLB_ChooseTLB($aArray)
	Local $iUbound = UBound($aArray)
	If $iUbound = 1 Then Return 0
	Local $iOut = 0
	Local $hGUIOther = GUICreate("Multiple TYPELIBs", 400, 200 + 30 * $iUbound, -1, -1, 0x80000, -1, $hGUI) ; WS_SYSMENU
	GUICtrlCreateLabel("-TYPELIBs found inside (select one to view):", 20, 20, 360, 20)
	GUICtrlSetColor(-1, 0x0000CC)
	GUICtrlSetFont(-1, 11, 600, 0, "Trebuchet MS", 5)
	Local $hClose = GUICtrlCreateButton("&OK", 300, 120 + 30 * $iUbound, 80, 25)
	GUICtrlSetTip(-1, "Load choosen Typelib")
	Local $aCheckBox[$iUbound]
	For $i = 0 To $iUbound - 1
		$aNameLang = _TLB_GetNameLang($aArray, $i)
		If $i = 0 Then
			$aCheckBox[$i] = GUICtrlCreateCheckbox(" TLB Name: " & $aNameLang[0] & "    Lang: " & $aNameLang[1] & "   (default)", 30, 60 + 30 * $i, 340, 20)
			GUICtrlSetState(-1, 1)
			GUICtrlSetFont($aCheckBox[$i], 9, 600, 2, "Trebuchet MS", 5)
		Else
			$aCheckBox[$i] = GUICtrlCreateCheckbox(" TLB Name: " & $aNameLang[0] & "    Lang: " & $aNameLang[1], 30, 60 + 30 * $i, 340, 20)
			GUICtrlSetFont($aCheckBox[$i], 9, 400, 2, "Trebuchet MS", 5)
		EndIf
	Next
	GUISetState(@SW_DISABLE, $hGUI)
	GUISetState(@SW_SHOW, $hGUIOther)
	Local $iMsg
	While 1
		$iMsg = GUIGetMsg()
		Switch $iMsg
			Case -3, $hClose
				ExitLoop
		EndSwitch
		For $i = 0 To $iUbound - 1
			If $iMsg = $aCheckBox[$i] Then
				$iOut = $i
				GUICtrlSetFont($aCheckBox[$i], 9, 600, 2, "Trebuchet MS", 5)
				For $j = 0 To $iUbound - 1
					If $j <> $i Then
						GUICtrlSetState($aCheckBox[$j], 4)
						GUICtrlSetFont($aCheckBox[$j], 9, 400, 2, "Trebuchet MS", 5)
					EndIf
				Next
			EndIf
		Next
	WEnd
	GUISetState(@SW_ENABLE, $hGUI)
	GUIDelete($hGUIOther)
	Return $iOut
EndFunc   ;==>_TLB_ChooseTLB

Func _TLB_GetNameLang($aArray, $iIndex = 0)
	Local $aOut = StringSplit($aArray[$iIndex], ";", 2)
	If UBound($aOut) <> 2 Then
		$aOut = StringSplit("  ", "", 2)
		MsgBox(64, "No Typelib", "No MSFT Typelib inside this file!", 0, $hGUI)
		Return $aOut
	EndIf
	If Number($aOut[0]) = $aOut[0] Then $aOut[0] = Number($aOut[0])
	If Number($aOut[1]) = $aOut[1] Then $aOut[1] = Number($aOut[1])
	Return $aOut
EndFunc   ;==>_TLB_GetNameLang

Func _TLB_GetTYPELIBS($sModule)
	ReDim $aTypelib[1]
	$aTypelib[0] = ""
	Local $aShortcut = FileGetShortcut($sModule)
	If Not @error Then $sModule = $aShortcut[0]
	DllCall($hKERNEL32, "boolean", "Wow64EnableWow64FsRedirection", "boolean", 0)
	_TLB_EnumTypelibs($sModule)
	If @error Then
		DllCall($hKERNEL32, "boolean", "Wow64EnableWow64FsRedirection", "boolean", 1)
		Return SetError(1, 0, $sModule)
	EndIf
	DllCall($hKERNEL32, "boolean", "Wow64EnableWow64FsRedirection", "boolean", 1)
	Local $iUbound = UBound($aTypelib) - 1 ; the last element is leftover. Ditching it...
	If $iUbound Then ReDim $aTypelib[$iUbound]
	Return $sModule
EndFunc   ;==>_TLB_GetTYPELIBS



; Heart-beat functions...
Func _TLB_TypelibMSFT($vModule, $vResType, $vResName, $iResLang, $fBinary = False)
	Local $bBinary
	If $fBinary Then
		$bBinary = $vModule
	Else
		$bBinary = _TLB_ResourceGetAsRaw($vModule, $vResType, $vResName, $iResLang)
	EndIf
	If Not $bBinary Then Return SetError(1, 0, "")
	If BinaryMid($bBinary, 1, 4) <> Binary("MSFT") Then Return SetError(2, 0, "")
	Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tBinary, 1, $bBinary)
	Local $pTypeLib = DllStructGetPtr($tBinary)
	Local $pPointer = $pTypeLib
	Local $tTypeLib = DllStructCreate("char Magic[4];" & _
			"int VersionNum;" & _
			"int GUIDOffset;" & _
			"int LocaleID;" & _
			"int Unknown;" & _
			"int VarFlags;" & _
			"int Version;" & _
			"int Flags;" & _
			"int TypeInfoCount;" & _
			"int HelpStringOffset;" & _
			"int HelpStringContext;" & _
			"int HelpContext;" & _
			"int NameTableCount;" & _
			"int NameTableChars;" & _
			"int TypeLibNameOffset;" & _
			"int HelpFileNameOffset;" & _
			"int CustomDataOffset;" & _
			"int Reserved1;" & _
			"int Reserved2;" & _
			"int DispatchPosition;" & _
			"int ImportInfoCount;", _
			$pPointer)
	$pPointer += DllStructGetSize($tTypeLib) ; 84
	; Possible correction
	If BitAND(BitShift(DllStructGetData($tTypeLib, "VarFlags"), 8), 1) Then $pPointer += 4
	Local $tTypeInfos = DllStructCreate("int Offset[" & DllStructGetData($tTypeLib, "TypeInfoCount") & "]", $pPointer)
	$pPointer += DllStructGetSize($tTypeInfos)
	Local $pSegDesc = $pPointer
	Local $iValidTypeInfoOffset = _TLB_SegDesc($pSegDesc, 1, True)
	Local $iValidRefOffset = _TLB_SegDesc($pSegDesc, 4, True)
	Local $iValidGUIDOffset = _TLB_SegDesc($pSegDesc, 6, True)
	Local $iValidNameOffset = _TLB_SegDesc($pSegDesc, 8, True)
	Local $iValidStringOffset = _TLB_SegDesc($pSegDesc, 9, True)
	Local $iValidCustomDataOffset = _TLB_SegDesc($pSegDesc, 12, True)
	Local $sData = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" & @CRLF
	$sData &= _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tTypeLib, "TypeLibNameOffset")) & ";" & _
			_TLB_String($iValidStringOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 9), DllStructGetData($tTypeLib, "HelpStringOffset"), " // ") & @CRLF & _
			"UUID " & _TLB_GUID($iValidGUIDOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 6), DllStructGetData($tTypeLib, "GUIDOffset")) & ";" & @CRLF
	$sData &= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" & @CRLF & @CRLF & @CRLF & @CRLF
	$sData &= "==================================================================================" & @CRLF & @CRLF
	For $i = 1 To DllStructGetData($tTypeLib, "TypeInfoCount")
		; 1. TypeInfo Table
		$sData &= _TLB_TypeInfo($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, DllStructGetData($tTypeInfos, "Offset", $i))
		; 2. ImportInfo Table +
		; 3. Imported TypeLib Table
		; 4. References Table +
		; 5. Lib Table
		; 6. GUID Table
		; 7. Unknown 01
		; 8. Name Table +
		; 9. String Table +
		; 10. Type Descriptors +
		; 11. Array Descriptors
		; 12. Custom Data +
		; 13. GUID Offsets +
		; 14. Unknown 02
		; 15. Unknown 03
		$sData &= "==================================================================================" & @CRLF & @CRLF
	Next
	Return $sData
EndFunc   ;==>_TLB_TypelibMSFT

Func _TLB_ImportInfo($iValidGUIDOffset, $iValidStringOffset, $pTypeLib, $pSegDesc, $iTypeKind)
	Local $sData
	Local $tImportInfo = DllStructCreate("short Count;" & _
			"byte Flags;" & _
			"byte TypeKind;" & _
			"int ImportFile;" & _
			"int GUID;", _
			$pTypeLib + _TLB_SegDesc($pSegDesc, 2))
	If DllStructGetData($tImportInfo, "ImportFile") Then $sData &= _TLB_String($iValidStringOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 9), DllStructGetData($tImportInfo, "ImportFile"), "Import File: ") & @CRLF
	If BitAND(DllStructGetData($tImportInfo, "Flags"), 1) Then; indicates GUID
		Switch $iTypeKind
			Case 4
				Local $sGUIDParent = _TLB_GUID($iValidGUIDOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 6), DllStructGetData($tImportInfo, "GUID"))
				$sData &= "// Inherits from:" & _TLB_InterfaceName($sGUIDParent) & @CRLF
			Case Else
				; Something else
		EndSwitch
	Else
		; FIXME ; "GUID" is a TypeInfo index
	EndIf
	Return $sData
EndFunc   ;==>_TLB_ImportInfo

Func _TLB_TypeInfo($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, $iOffset, $fRetName = False)
	If $iOffset < 0 Or $iOffset > $iValidTypeInfoOffset Then Return @CRLF
	Local $sData
	Local $tTypeInfo = DllStructCreate("int TypeKind;" & _
			"int FunctionRecords;" & _
			"int MemoryAllocation;" & _
			"int ReconstitutedSize;" & _
			"int Reserved1;" & _
			"int Reserved2;" & _
			"short FunctionCount;" & _
			"short PropertyCount;" & _
			"int Reserved3;" & _
			"int Reserved4;" & _
			"int Reserved5;" & _
			"int Reserved6;" & _
			"int GUID;" & _
			"int TypeFlags;" & _
			"int Name;" & _
			"int Version;" & _
			"int DocString;" & _
			"int HelpStringContext;" & _
			"int HelpContext;" & _
			"int CustomData;" & _
			"short ImplementedInterfaces;" & _
			"short VirtualTableSize;" & _
			"int Unknown3;" & _
			"int DataType1;" & _
			"int DataType2;" & _
			"int Reserved7;" & _
			"int Reserved8;", _
			$pTypeLib + _TLB_SegDesc($pSegDesc, 1) + $iOffset)
	If $fRetName Then Return "<" & _TLB_TypeKind(BitAND(DllStructGetData($tTypeInfo, "TypeKind"), 0xF)) & "> " & _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tTypeInfo, "Name"))
	$sData &= _TLB_TypeKind(BitAND(DllStructGetData($tTypeInfo, "TypeKind"), 0xF)) & " "
	$sData &= _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tTypeInfo, "Name")) & ";"
	$sData &= _TLB_String($iValidStringOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 9), DllStructGetData($tTypeInfo, "DocString"), " // ")
	$sData &= @CRLF
	Local $iTypeKind = BitAND(DllStructGetData($tTypeInfo, "TypeKind"), 0xF)
	Switch $iTypeKind
		Case 0, 1, 7 ; enum, struct, union
			; nothing
		Case 6 ; alias
			If BitShift(DllStructGetData($tTypeInfo, "DataType1"), 31) Then
				$sData &= _TLB_GetType(BitAND(DllStructGetData($tTypeInfo, "DataType1"), 0xFFFF)) & "; " & @CRLF & @CRLF
			Else
				$sData &= _TLB_CustomType($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, DllStructGetData($tTypeInfo, "DataType1")) & "; " & @CRLF & @CRLF
			EndIf
		Case 3 ; Interface
			; DataType1 is a reference to inherited interface
			$sData &= "IID = " & _TLB_GUID($iValidGUIDOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 6), DllStructGetData($tTypeInfo, "GUID")) & "; " & @CRLF
			If DllStructGetData($tTypeInfo, "DataType1") <> -1 Then $sData &= "// Inherits from: IUnknown {00000000-0000-0000-C000-000000000046}" & @CRLF ; <-!!!
			$sData &= _TLB_ImportInfo($iValidGUIDOffset, $iValidStringOffset, $pTypeLib, $pSegDesc, $iTypeKind) & @CRLF
		Case 4 ; IDispatch
			$sData &= "IID = " & _TLB_GUID($iValidGUIDOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 6), DllStructGetData($tTypeInfo, "GUID")) & "; " & @CRLF
			$sData &= _TLB_ImportInfo($iValidGUIDOffset, $iValidStringOffset, $pTypeLib, $pSegDesc, $iTypeKind) & @CRLF
		Case 2 ; Module
			; DataType1 is an offset into the Name Table of the DllName
			;Local $sDLLName = _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tTypeInfo, "DataType1"))
			;If $sDLLName Then $sData &= $sDLLName & ";"
			$sData &= @CRLF
		Case 5 ; coclass
			$sData &= "CLSID = " & _TLB_GUID($iValidGUIDOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 6), DllStructGetData($tTypeInfo, "GUID")) & "; " & @CRLF & @CRLF
			; DataType1 is an offset into RefTable
			Local $aRef = _TLB_Ref($iValidRefOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 4), DllStructGetData($tTypeInfo, "DataType1"))
			For $i = 0 To UBound($aRef) - 1
				$aRef[$i] = Number($aRef[$i])
				If $aRef[$i] >= 0 Then $sData &= "// Implemented interface: " & _TLB_TypeInfo($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, $aRef[$i], True) & @CRLF
			Next
		Case Else
			$sData &= "GUID = " & _TLB_GUID($iValidGUIDOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 6), DllStructGetData($tTypeInfo, "GUID")) & "; " & @CRLF & @CRLF
	EndSwitch
	$sData &= _TLB_FuncProp($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, DllStructGetData($tTypeInfo, "FunctionRecords"), DllStructGetData($tTypeInfo, "FunctionCount"), DllStructGetData($tTypeInfo, "PropertyCount"), BitAND(DllStructGetData($tTypeInfo, "TypeKind"), 0xF))
	Return $sData
EndFunc   ;==>_TLB_TypeInfo

Func _TLB_FuncProp($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, $iOffset, $iNumFunc = 0, $iNumProp = 0, $iTypeKind = 0)
	Local $pPointer = $pTypeLib + $iOffset
	$pPointer += 4 ; first int value is the size of FuncPropRec structure. Skipping that.
	Local $aString[$iNumFunc + $iNumProp + 1]
	Local $iMinSize, $sParamName
	Local $tFuncRecord
	Local $tParameterInfo, $pParameterInfo
	For $i = 1 To $iNumFunc
		$tFuncRecord = DllStructCreate("word RecordSize;" & _
				"word VTableEntry;" & _
				"short DataType;" & _
				"short Flags;" & _
				"int Reserved1;" & _
				"short VirtualTable;" & _
				"short FuncDescSize;" & _
				"int FKCCIC;" & _
				"short ParameterCount;" & _
				"short Unknown2;" & _
				"int HelpContext;" & _
				"int HelpString;" & _
				"int Entry;" & _
				"int Reserved2;" & _
				"int Reserved3;" & _
				"int HelpStringContext;" & _
				"int CustomData;", _
				$pPointer)
		$pPointer += DllStructGetData($tFuncRecord, "RecordSize")
		$iMinSize = DllStructGetData($tFuncRecord, "RecordSize") - 12 * DllStructGetData($tFuncRecord, "ParameterCount")
		If BitAND(BitShift(DllStructGetData($tFuncRecord, "FKCCIC"), 7), 1) Then
			$aString[$i - 1] = _TLB_CustomType($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, _TLB_SegDesc($pSegDesc, 10), DllStructGetData($tFuncRecord, "DataType")) & " "
		Else
			$aString[$i - 1] = _TLB_GetType(DllStructGetData($tFuncRecord, "DataType")) & " "
		EndIf
		$aString[$i - 1] = _TLB_FuncType(BitAND(DllStructGetData($tFuncRecord, "FKCCIC"), 0x7)) & ";" & @CRLF & "        " & $aString[$i - 1]
		$aString[$i - 1] = _TLB_InvocationKind(BitAND(BitShift(DllStructGetData($tFuncRecord, "FKCCIC"), 3), 0xF)) & $aString[$i - 1]
		$aString[$i - 1] = _TLB_CallingConvention(BitAND(BitShift(DllStructGetData($tFuncRecord, "FKCCIC"), 8), 0xF)) & $aString[$i - 1]
		If $iMinSize > 28 Then
			$aString[$i - 1] = _TLB_String($iValidStringOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 9), DllStructGetData($tFuncRecord, "HelpString")) & @CRLF & $aString[$i - 1]
		Else
			$aString[$i - 1] = @CRLF & $aString[$i - 1]
		EndIf
		$aString[$i - 1] &= "(" & @CRLF
		$pParameterInfo = DllStructGetPtr($tFuncRecord) + $iMinSize
		For $j = 1 To DllStructGetData($tFuncRecord, "ParameterCount")
			$tParameterInfo = DllStructCreate("short DataType;" & _
					"short Flags;" & _
					"int Name;" & _
					"int ParamFlags;", _
					$pParameterInfo)
			$aString[$i - 1] &= _TLB_GetFlagString(DllStructGetData($tParameterInfo, "ParamFlags"))
			If DllStructGetData($tParameterInfo, "Flags") Then
				$aString[$i - 1] &= _TLB_GetType(DllStructGetData($tParameterInfo, "DataType"))
			Else
				$aString[$i - 1] &= _TLB_CustomType($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, DllStructGetData($tParameterInfo, "DataType"))
			EndIf
			If DllStructGetData($tParameterInfo, "Name") <> -1 Then $sParamName = _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tParameterInfo, "Name"))
			$aString[$i - 1] &= " " & $sParamName
			If $j = DllStructGetData($tFuncRecord, "ParameterCount") Then
				$aString[$i - 1] &= @CRLF
			Else
				$aString[$i - 1] &= ", " & @CRLF
			EndIf
			$pParameterInfo += 12 ; size of $tParameterInfo
		Next
		$aString[$i - 1] &= "         );" & @CRLF
	Next
	For $i = 1 To $iNumProp
		Local $tPropRecord = DllStructCreate("word RecordSize;" & _
				"word PropNum;" & _
				"short DataType;" & _
				"short Flags;" & _
				"int VarKind;" & _
				"int VarDescSize;" & _
				"int OffsValue;" & _
				"int Unknown;" & _
				"int HelpContext;" & _
				"int HelpString;" & _
				"int Reserved;" & _
				"int CustomData;" & _
				"int HelpStringContext;", _
				$pPointer)
		If DllStructGetData($tPropRecord, "RecordSize") > 24 Then $aString[$i + $iNumFunc - 1] = _TLB_String($iValidStringOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 9), DllStructGetData($tPropRecord, "HelpString")) & @CRLF
		If BitShift(DllStructGetData($tPropRecord, "OffsValue"), 31) Then ; If MSB set
			$aString[$iNumFunc + $i - 1] = " = " & BitAND(DllStructGetData($tPropRecord, "OffsValue"), 0xFFFF)
		Else
			Switch $iTypeKind
				Case 1, 7
					Local $sTypeParam
					Switch DllStructGetData($tPropRecord, "DataType")
						Case 30
							$aString[$iNumFunc + $i - 1] = "   ptr[str]@S@"
						Case 31
							$aString[$iNumFunc + $i - 1] = "   ptr[wstr]@S@"
						Case Else
							If BitShift(DllStructGetData($tPropRecord, "DataType"), 7) Then
								$aString[$iNumFunc + $i - 1] = "  " & _TLB_CustomType($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, DllStructGetData($tPropRecord, "DataType")) & "@S@"
							Else
								$sTypeParam = _TLB_GetType(DllStructGetData($tPropRecord, "DataType"))
								If @extended Then $sTypeParam = _TLB_CustomType($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, DllStructGetData($tPropRecord, "DataType"))
								$aString[$iNumFunc + $i - 1] = "  " & $sTypeParam & "@S@"
							EndIf
					EndSwitch
				Case Else
					$aString[$iNumFunc + $i - 1] = " = " & _TLB_CustomData($iValidCustomDataOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 12), BitAND(DllStructGetData($tPropRecord, "OffsValue"), 0xFFFF))
			EndSwitch
		EndIf
		$pPointer += DllStructGetData($tPropRecord, "RecordSize")
	Next
	Local $tMethodPropertyID = DllStructCreate("dword[" & $iNumFunc + $iNumProp & "]", $pPointer)
	$pPointer += DllStructGetSize($tMethodPropertyID)
	Local $tNameOffsets = DllStructCreate("dword[" & $iNumFunc + $iNumProp & "]", $pPointer)
	$pPointer += DllStructGetSize($tNameOffsets)
	For $i = 1 To $iNumFunc + $iNumProp
		$aString[$i - 1] = StringReplace($aString[$i - 1], "(", _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tNameOffsets, 1, $i)) & "(")
		If $i > $iNumFunc Then
			If StringRight($aString[$i - 1], 3) = "@S@" Then
				$aString[$i - 1] = StringTrimRight($aString[$i - 1], 3) & " " & _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tNameOffsets, 1, $i)) & ";"
			Else
				$aString[$i - 1] = "  " & _TLB_Name($iValidNameOffset, $pTypeLib + _TLB_SegDesc($pSegDesc, 8), DllStructGetData($tNameOffsets, 1, $i)) & $aString[$i - 1] & ","
			EndIf
		EndIf
	Next
	If $iNumProp Then
		$aString[$iNumFunc] = "{" & @CRLF & $aString[$iNumFunc]
		$aString[$iNumProp + $iNumFunc - 1] = StringReplace($aString[$iNumProp + $iNumFunc - 1], ",", "") & @CRLF & "};" & @CRLF
	EndIf
	Local $sString
	For $i = 1 To $iNumFunc + $iNumProp + 1
		If $i > $iNumFunc Then
			$sString &= $aString[$i - 1] & @CRLF
		Else
			$sString &= "    " & $i & ". " & $aString[$i - 1] & @CRLF
		EndIf
	Next
	Return $sString
EndFunc   ;==>_TLB_FuncProp

Func _TLB_CustomType($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, $iOffset, $sData = "")
	Local $sOut, $fRet, $iTypeDescTableOffset
	Local $iPrimaryDataType, $iBaseDataType, $iVector, $iArray, $iPointer, $iRound
	While 1
		$iRound += 1
		If $iRound = 12 Then ExitLoop ; if something goes wrong
		Local $tTypeDesc = DllStructCreate("short Val1;" & _
				"short Val2;" & _
				"short Val3;" & _
				"short Val4;", _
				$pTypeLib + _TLB_SegDesc($pSegDesc, 10) + $iOffset)
		$iPrimaryDataType = BitAND(DllStructGetData($tTypeDesc, "Val1"), 0x7FF)
		$iBaseDataType = BitAND(DllStructGetData($tTypeDesc, "Val2"), 0x7FF)
		$iVector = BitAND(BitShift(DllStructGetData($tTypeDesc, "Val2"), 12), 1)
		$iArray = BitAND(BitShift(DllStructGetData($tTypeDesc, "Val2"), 13), 1)
		$iPointer = BitAND(BitShift(DllStructGetData($tTypeDesc, "Val2"), 14), 1)
		If BitAND(DllStructGetData($tTypeDesc, "Val2"), 0x7FFE) = 0x7FFE Then
			If $iPrimaryDataType = 26 Then
				$sOut &= "*"
			Else
				$fRet = True
			EndIf
		Else
			If $iPointer Then
				$sOut &= _TLB_GetType($iBaseDataType) & "*"
			Else
				If $iVector Then
					$sOut &= "(VectorOf " & _TLB_GetType($iPrimaryDataType) & ")" ; <-!!!
				ElseIf $iArray Then
					$sOut &= _TLB_GetType($iPrimaryDataType)
				EndIf
			EndIf
			$fRet = True
		EndIf
		Switch $iPrimaryDataType
			Case 26, 27 ; VT_PTR, VT_SAFEARRAY
				If BitShift(DllStructGetData($tTypeDesc, "Val4"), 31) Then ; If MSB is set
					$iTypeDescTableOffset = BitAND(DllStructGetData($tTypeDesc, "Val3"), 0x7FF8)
					;ConsoleWrite("-" & $iTypeDescTableOffset & "    " & $iBaseDataType & @CRLF)
				Else
					$iTypeDescTableOffset = BitAND(BitOR(BitShift(DllStructGetData($tTypeDesc, "Val2"), -16), DllStructGetData($tTypeDesc, "Val3")), DllStructGetData($tTypeDesc, "Val3"))
				EndIf
			Case 28 ; VT_CARRAY
				Local $iArrayDescTableOffset = BitOR(BitShift(DllStructGetData($tTypeDesc, "Val4"), -16), DllStructGetData($tTypeDesc, "Val3"))
				#forceref $iArrayDescTableOffset
				$sOut &= "VT_CARRAY" ; <-!!!
			Case 29 ; VT_USERDEFINED
				Local $iTypeInfoOffset = BitOR(BitShift(DllStructGetData($tTypeDesc, "Val4"), -16), DllStructGetData($tTypeDesc, "Val3")) ; And with 0xFFFFFFF8 ? (gives wrong)
				$sOut = " " & _TLB_TypeInfo($iValidTypeInfoOffset, $iValidRefOffset, $iValidGUIDOffset, $iValidNameOffset, $iValidStringOffset, $iValidCustomDataOffset, $pTypeLib, $pSegDesc, $iTypeInfoOffset, True) & $sOut
		EndSwitch
		If $fRet Then Return $sOut & $sData
		$iOffset = $iTypeDescTableOffset
	WEnd
	Return ""
EndFunc   ;==>_TLB_CustomType

Func _TLB_SegDesc($pPointer, $iTable, $fLength = False)
	Local $tSegDesc = DllStructCreate("int Offset;" & _
			"int Length;" & _
			"int Reserved1;" & _
			"int Reserved2;", _
			$pPointer + ($iTable - 1) * 16)
	If $fLength Then Return DllStructGetData($tSegDesc, "Length")
	Return DllStructGetData($tSegDesc, "Offset")
EndFunc   ;==>_TLB_SegDesc

Func _TLB_Ref($iValidRefOffset, $pPointer, $iOffset)
	If $iOffset < 0 Or $iOffset > $iValidRefOffset Then Return ""
	Local $tRefRecord, $sOut
	For $i = 1 To 10 ; force limit of 10 to avoid possible problems
		$tRefRecord = DllStructCreate("int RefType;" & _
				"int Flags;" & _
				"int CustData;" & _
				"int Next;", _
				$pPointer + $iOffset)
		$iOffset = DllStructGetData($tRefRecord, "Next")
		If Mod(DllStructGetData($tRefRecord, "RefType"), 4) Then
			$sOut &= -DllStructGetData($tRefRecord, "RefType") & ";"
		Else
			$sOut &= DllStructGetData($tRefRecord, "RefType") & ";"
		EndIf
		If $iOffset < 0 Or $iOffset > $iValidRefOffset Then ExitLoop
	Next
	Return StringSplit(StringTrimRight($sOut, 1), ";", 2)
EndFunc   ;==>_TLB_Ref

Func _TLB_CustomData($iValidCustomDataOffset, $pPointer, $iOffset, $fType = False)
	If $iOffset < 0 Or $iOffset > $iValidCustomDataOffset Then Return ""
	Local $tCustom = DllStructCreate("short DataType;" & _
			"short Value1;" & _
			"short Value2;", _
			$pPointer + $iOffset)
	Local $iTye = DllStructGetData($tCustom, "DataType")
	If $fType Then Return $iTye
	If $iTye = 8 Then Return '"' & DllStructGetData(DllStructCreate("char[" & DllStructGetData($tCustom, "Value1") & "]", $pPointer + $iOffset + 6), 1) & '"'
	Return BitOR(BitShift(DllStructGetData($tCustom, "Value2"), -16), DllStructGetData($tCustom, "Value1"))
EndFunc   ;==>_TLB_CustomData

Func _TLB_Name($iValidNameOffset, $pPointer, $iOffset)
	If $iOffset < 0 Or $iOffset > $iValidNameOffset Then Return ""
	Local $tTlbNameModified = DllStructCreate("int RefType;" & _
			"int NextHash;" & _
			"byte Length;", _
			$pPointer + $iOffset)
	Return DllStructGetData(DllStructCreate("char[" & DllStructGetData($tTlbNameModified, "Length") & "]", $pPointer + $iOffset + 12), 1)
EndFunc   ;==>_TLB_Name

Func _TLB_String($iValidStringOffset, $pPointer, $iOffset, $sDefault = "")
	If $iOffset < 0 Or $iOffset > $iValidStringOffset Then Return ""
	Local $tTlbStringModified = DllStructCreate("word Length", $pPointer + $iOffset)
	Return $sDefault & DllStructGetData(DllStructCreate("char[" & DllStructGetData($tTlbStringModified, "Length") & "]", $pPointer + $iOffset + 2), 1)
EndFunc   ;==>_TLB_String

Func _TLB_GUID($iValidGUIDOffset, $pGUID, $iOffset = 0)
	If $iOffset < 0 Or $iOffset > $iValidGUIDOffset Then Return ""
	Local $tGUID = DllStructCreate("dword;word;word;byte[2];byte[6]", $pGUID + $iOffset)
	Return "{" & Hex(DllStructGetData($tGUID, 1), 8) & "-" & Hex(DllStructGetData($tGUID, 2), 4) & "-" & Hex(DllStructGetData($tGUID, 3), 4) & "-" & Hex(DllStructGetData($tGUID, 4)) & "-" & Hex(DllStructGetData($tGUID, 5)) & "}"
EndFunc   ;==>_TLB_GUID

Func _TLB_InterfaceName($sGUID)
	Local $sName
	Switch $sGUID
		Case "{00000000-0000-0000-C000-000000000046}"
			$sName = "IUnknown"
		Case "{00020400-0000-0000-C000-000000000046}"
			$sName = "IDispatch"
		Case Else
			$sName = ""
	EndSwitch
	Return "  " & $sName & "  " & $sGUID
EndFunc   ;==>_TLB_InterfaceName

Func _TLB_GetFlagString($iFlag)
	If $iFlag = 0 Then Return "            "
	Local $sFlag
	If BitAND($iFlag, 1) Then $sFlag &= ",in"
	If BitAND(BitShift($iFlag, 1), 1) Then $sFlag &= ",out"
	If BitAND(BitShift($iFlag, 2), 1) Then $sFlag &= ",LCID"
	If BitAND(BitShift($iFlag, 3), 1) Then $sFlag &= ",retval"
	If BitAND(BitShift($iFlag, 4), 1) Then $sFlag &= ",optional"
	If BitAND(BitShift($iFlag, 5), 1) Then $sFlag &= ",hasdefault"
	If BitAND(BitShift($iFlag, 6), 1) Then $sFlag &= ",hascustom"
	Return "            [" & StringRegExpReplace($sFlag, "\A,(.*?)", "$1") & "]"
EndFunc   ;==>_TLB_GetFlagString

Func _TLB_TypeKind($iKind)
	Local $sKind
	Switch $iKind
		Case 0
			$sKind = "enum"
		Case 1
			$sKind = "struct"
		Case 2
			$sKind = "module"
		Case 3
			$sKind = "Interface"
		Case 4
			$sKind = "IDispatch"
		Case 5
			$sKind = "coclass"
		Case 6
			$sKind = "alias"
		Case 7
			$sKind = "union"
		Case 8
			$sKind = "MAX"
	EndSwitch
	Return $sKind
EndFunc   ;==>_TLB_TypeKind

Func _TLB_CallingConvention($iCallCode)
	Local $sCall
	Switch $iCallCode
		Case 0
			$sCall = "FASTCALL "
		Case 1
			$sCall = "CDECL "
		Case 2
			$sCall = "PASCAL "
		Case 3
			$sCall = "MACPASCAL "
		Case 4
			$sCall = "STDCALL "
		Case 5
			$sCall = "FPFASTCALL "
		Case 6
			$sCall = "SYSCALL "
		Case 7
			$sCall = "MPWCDECL "
		Case 8
			$sCall = "MPWPASCAL "
		Case 9
			$sCall = "MAX "
	EndSwitch
	Return $sCall
EndFunc   ;==>_TLB_CallingConvention

Func _TLB_InvocationKind($iKind)
	Local $sKind
	Switch $iKind
		Case 1
			$sKind = "FUNC "
		Case 2
			$sKind = "PROPERTYGET "
		Case 3
			$sKind = "PROPERTYPUT "
		Case 4
			$sKind = "PROPERTYPUTREF "
	EndSwitch
	Return $sKind
EndFunc   ;==>_TLB_InvocationKind

Func _TLB_FuncType($iType)
	Local $sType
	Switch $iType
		Case 0
			$sType = "VIRTUAL"
		Case 1
			$sType = "PUREVIRTUAL"
		Case 2
			$sType = "NONVIRTUAL"
		Case 3
			$sType = "STATIC"
		Case 4
			$sType = "DISPATCH"
	EndSwitch
	Return $sType
EndFunc   ;==>_TLB_FuncType

Func _TLB_GetType($iType)
	If $iType = 0 Then Return " none"
	Local $aArrayOfTypes[44][2] = [[0, "none"], _
			[1, "NULL"], _
			[2, "short"], _
			[3, "int"], _
			[4, "float"], _
			[5, "double"], _
			[6, "CY"], _
			[7, "DATE"], _
			[8, "BSTR"], _
			[9, "idispatch"], _
			[10, "ERROR"], _
			[11, "bool"], _
			[12, "VARIANT"], _
			[13, "IUnknown"], _
			[14, "DECIMAL"], _
			[16, "byte"], _
			[17, "ubyte"], _
			[18, "word"], _
			[19, "dword"], _
			[20, "int64"], _
			[21, "uint64"], _
			[22, "int"], _
			[23, "dword"], _
			[24, "VOID"], _
			[25, "HRESULT"], _
			[26, "ptr"], _
			[27, "SAFEARRAY"], _
			[28, "CARRAY"], _
			[29, "USERDEFINED"], _
			[30, "str"], _
			[31, "wstr"], _
			[36, "RECORD"], _
			[37, "int_ptr"], _
			[38, "dword_ptr"], _
			[64, "FILETIME"], _
			[65, "BLOB"], _
			[66, "STREAM"], _
			[67, "STORAGE"], _
			[68, "STREAMED_OBJECT"], _
			[69, "STORED_OBJECT"], _
			[70, "BLOB_OBJECT"], _
			[71, "CF"], _
			[72, "CLSID"], _
			[73, "VERSIONED_STREAM"]]
	Local $sType, $iStep = -1
	For $i = 43 To 1 Step -1
		If $iType - $aArrayOfTypes[$i][0] >= 0 Then
			$sType &= " " & $aArrayOfTypes[$i][1] & " |"
			$iType -= $aArrayOfTypes[$i][0]
			If $iType = $aArrayOfTypes[$i][0] Then ExitLoop
			$iStep += 1
		EndIf
	Next
	Return SetExtended($iStep, StringTrimRight($sType, 2))
EndFunc   ;==>_TLB_GetType



; Resource extracting functions...
Func _TLB_FindResourceEx($hModule, $vResType, $vResName, $iResLang = 0)
	Local $sTypeType = "wstr"
	If IsNumber($vResType) Then $sTypeType = "int"
	Local $sNameType = "wstr"
	If IsNumber($vResName) Then $sNameType = "int"
	Local $aCall = DllCall($hKERNEL32, "handle", "FindResourceExW", _
			"handle", $hModule, _
			$sTypeType, $vResType, _
			$sNameType, $vResName, _
			"int", $iResLang)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_FindResourceEx

Func _TLB_SizeofResource($hModule, $hResource)
	Local $aCall = DllCall($hKERNEL32, "int", "SizeofResource", "handle", $hModule, "handle", $hResource)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_SizeofResource

Func _TLB_LoadResource($hModule, $hResource)
	Local $aCall = DllCall($hKERNEL32, "handle", "LoadResource", "handle", $hModule, "handle", $hResource)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_LoadResource

Func _TLB_LockResource($hResource)
	Local $aCall = DllCall($hKERNEL32, "ptr", "LockResource", "handle", $hResource)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_LockResource

Func _TLB_LoadLibraryEx($sModule, $iFlag = 0)
	Local $aCall = DllCall($hKERNEL32, "handle", "LoadLibraryExW", "wstr", $sModule, "handle", 0, "dword", $iFlag)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_LoadLibraryEx

Func _TLB_FreeLibrary($hModule)
	Local $aCall = DllCall($hKERNEL32, "bool", "FreeLibrary", "handle", $hModule)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_FreeLibrary

Func _TLB_ResourceGetAsRaw($sModule, $vResType, $vResName, $iResLang = 0)
	; Load the module
	Local $hModule = _TLB_LoadLibraryEx($sModule, 2) ; LOAD_LIBRARY_AS_DATAFILE
	If @error Then Return SetError(1, 0, "")
	; Find specified resource inside it
	Local $hResource = _TLB_FindResourceEx($hModule, $vResType, $vResName, $iResLang)
	If @error Then
		_TLB_FreeLibrary($hModule)
		Return SetError(2, 0, "")
	EndIf
	; Determine the size of the resource
	Local $iSizeOfResource = _TLB_SizeofResource($hModule, $hResource)
	If @error Then
		_TLB_FreeLibrary($hModule)
		Return SetError(3, 0, "")
	EndIf
	; Load it
	$hResource = _TLB_LoadResource($hModule, $hResource)
	If @error Then
		_TLB_FreeLibrary($hModule)
		Return SetError(4, 0, "")
	EndIf
	; Get pointer
	Local $pResource = _TLB_LockResource($hResource)
	If @error Then
		_TLB_FreeLibrary($hModule)
		Return SetError(5, 0, "")
	EndIf
	; Make structure at that address
	Local $tBinary = DllStructCreate("byte[" & $iSizeOfResource & "]", $pResource)
	; Collect data (this should be done before freeing the module)
	Local $bBinary = DllStructGetData($tBinary, 1)
	; Free
	_TLB_FreeLibrary($hModule)
	; Return data
	Return $bBinary
EndFunc   ;==>_TLB_ResourceGetAsRaw



; Res enumeration functions
Func _TLB_EnumTypelibs($sModule)
	Local $hModule = _TLB_LoadLibraryEx($sModule, 2) ; LOAD_LIBRARY_AS_DATAFILE
	If @error Then Return SetError(1) ; Couldn't load the module
	Local Static $pEnumResName = DllCallbackGetPtr(DllCallbackRegister("_TLB_EnumResNameProc", "bool", "handle;ptr;ptr;ptr"))
	Local Static $pEnumResLang = DllCallbackGetPtr(DllCallbackRegister("_TLB_EnumResLangProc", "bool", "handle;ptr;ptr;word;ptr"))
	DllCall($hKERNEL32, "bool", "EnumResourceNamesW", _
			"handle", $hModule, _
			"wstr", "TYPELIB", _
			"ptr", $pEnumResName, _ ; pointer to _TLB_EnumResNameProc
			"ptr", $pEnumResLang) ; passing pointer to _TLB_EnumResLangProc
	_TLB_FreeLibrary($hModule)
EndFunc   ;==>_TLB_EnumTypelibs

Func _TLB_EnumResNameProc($hModule, $pType, $pName, $lParam)
	DllCall($hKERNEL32, "bool", "EnumResourceLanguagesW", _
			"handle", $hModule, _
			"ptr", $pType, _
			"ptr", $pName, _
			"ptr", $lParam, _ ; pointer to _TLB_EnumResLangProc
			"int_ptr", 0)
	Return 1
EndFunc   ;==>_TLB_EnumResNameProc

Func _TLB_EnumResLangProc($hModule, $pType, $pName, $iLang, $lParam)
	#forceref $hModule, $pType, $lParam
	Local $vName = Number($pName)
	If $vName > 65535 Then $vName = DllStructGetData(DllStructCreate("wchar[" & _TLB_PtrStringLenW($pName) + 1 & "]", $pName), 1)
	Local $iUbound = UBound($aTypelib)
	ReDim $aTypelib[$iUbound + 1]
	$aTypelib[$iUbound - 1] = $vName & ";" & $iLang
	Return 1
EndFunc   ;==>_TLB_EnumResLangProc



; Additional win messages processing functions...
Func _TLB_WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg
	Local $aClientSize[2] = [BitAND($lParam, 65535), BitShift($lParam, 16)]
	If $hWnd = $hGUI Then
		Switch $wParam
			Case 0
				WinMove($hDots, 0, $aClientSize[0] - 17, $aClientSize[1] - 17)
				WinSetState($hDots, 0, @SW_RESTORE)
			Case 2; SIZE_MAXIMIZED
				WinSetState($hDots, 0, @SW_HIDE)
		EndSwitch
	EndIf
EndFunc   ;==>_TLB_WM_SIZE

Func _TLB_WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $wParam
	If $hWnd = $hGUI Then
		Local $tMINMAXINFO = DllStructCreate("int;int;" & _
				"int MaxSizeX; int MaxSizeY;" & _
				"int MaxPositionX;int MaxPositionY;" & _
				"int MinTrackSizeX; int MinTrackSizeY;" & _
				"int MaxTrackSizeX; int MaxTrackSizeY", _
				$lParam)
		DllStructSetData($tMINMAXINFO, "MinTrackSizeX", 325)
		DllStructSetData($tMINMAXINFO, "MinTrackSizeY", 350)
	EndIf
EndFunc   ;==>_TLB_WM_GETMINMAXINFO

Func _TLB_WM_DROPFILES($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $lParam
	If $hWnd = $hGUI Then
		$sTLB = _TLB_DragQueryFile($wParam)
		If @error Then
			_TLB_MessageBeep(48)
			Return 1
		EndIf
		If StringInStr(FileGetAttrib($sTLB), "D") Then
			_TLB_MessageBeep(48)
			$sTLB = ""
		EndIf
		_TLB_DragFinish($wParam)
		Return 1
	EndIf
	_TLB_MessageBeep(48)
	Return 1
EndFunc   ;==>_TLB_WM_DROPFILES



; Misc...
Func _TLB_PtrStringLenW($pString)
	Local $aCall = DllCall($hKERNEL32, "dword", "lstrlenW", "ptr", $pString)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_PtrStringLenW

Func _TLB_SetErrorMode($iMode)
	Local $aCall = DllCall($hKERNEL32, "dword", "SetErrorMode", "dword", $iMode)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_SetErrorMode

Func _TLB_MessageBeep($iType)
	DllCall($hUSER32, "int", "MessageBeep", "dword", $iType)
EndFunc   ;==>_TLB_MessageBeep

Func _TLB_DragQueryFile($hDrop, $iIndex = 0)
	Local $aCall = DllCall($hSHELL32, "dword", "DragQueryFileW", _
			"handle", $hDrop, _
			"dword", $iIndex, _
			"wstr", "", _
			"dword", 32767)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Return $aCall[3]
EndFunc   ;==>_TLB_DragQueryFile

Func _TLB_DragFinish($hDrop)
	DllCall($hSHELL32, "none", "DragFinish", "handle", $hDrop)
EndFunc   ;==>_TLB_DragFinish

Func _TLB_CreateDragDots($hGUI)
	Local $aCall = DllCall($hUSER32, "hwnd", "CreateWindowExW", _
			"dword", 0, _
			"wstr", "Scrollbar", _
			"ptr", 0, _
			"dword", 0x50000018, _ ; $WS_CHILD|$WS_VISIBLE|$SBS_SIZEBOX|$SBS_SIZEBOXOWNERDRAWFIXED
			"int", 0, _
			"int", 0, _
			"int", 17, _ ; Width
			"int", 17, _ ; Height
			"hwnd", $hGUI, _
			"hwnd", 0, _
			"hwnd", 0, _
			"int", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_TLB_CreateDragDots