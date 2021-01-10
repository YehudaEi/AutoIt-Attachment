#include <WinAPI.au3>
#include <Constants.au3>
#include <Array.au3>
Global $ICL_DEBUG = 0

; UDF by Prog@ndy
; information source: http://en.wikipedia.org/wiki/ICO_(icon_image_file_format)#cite_note-2
;                     http://www.codeproject.com/KB/cs/IconLib.aspx
;                     http://www.codeguru.com/csharp/.net/net_general/graphics/article.php/c12787__2/

Global Const $tagIMAGE_DOS_HEADER = "ushort eHmagic; ushort eHcblp; ushort eHcp; ushort eHcrlc; ushort eHcparhdr; ushort eHminalloc; ushort eHmaxalloc;" & _
		"ushort eHss; ushort eHsp; ushort eHcsum; ushort eHip; ushort eHcs; ushort eHlfarlc; ushort eHovno; ushort eHres[4]; ushort eHoemid; ushort eHoeminfo;" & _
		"ushort eHres2[10]; LONG eHlfanew"
Global Const $tagIMAGE_OS2_HEADER = _      ;// OS/2 .EXE header
		"USHORT   neHmagic;" & _             ;// Magic number
		"CHAR   neHver;" & _               ;// Version number
		"CHAR   neHrev;" & _               ;// Revision number
		"USHORT   neHenttab;" & _            ;// Offset of Entry Table
		"USHORT   neHcbenttab;" & _          ;// Number of bytes in Entry Table
		"LONG   neHcrc;" & _               ;// Checksum of whole file
		"USHORT   neHflags;" & _             ;// Flag word
		"USHORT   neHautodata;" & _          ;// Automatic data segment number
		"USHORT   neHheap;" & _              ;// Initial heap allocation
		"USHORT   neHstack;" & _             ;// Initial stack allocation
		"LONG   neHcsip;" & _              ;// Initial CS:IP setting
		"LONG   neHsssp;" & _              ;// Initial SS:SP setting
		"USHORT   neHcseg;" & _              ;// Count of file segments
		"USHORT   neHcmod;" & _              ;// Entries in Module Reference Table
		"USHORT   neHcbnrestab;" & _         ;// Size of non-resident name table
		"USHORT   neHsegtab;" & _            ;// Offset of Segment Table
		"USHORT   neHrsrctab;" & _           ;// Offset of Resource Table
		"USHORT   neHrestab;" & _            ;// Offset of resident name table
		"USHORT   neHmodtab;" & _            ;// Offset of Module Reference Table
		"USHORT   neHimptab;" & _            ;// Offset of Imported Names Table
		"LONG   neHnrestab;" & _           ;// Offset of Non-resident Names Table
		"USHORT   neHcmovent;" & _           ;// Count of movable entries
		"USHORT   neHalign;" & _             ;// Segment alignment shift count
		"USHORT   neHcres;" & _              ;// Count of resource segments
		"BYTE   neHexetyp;" & _            ;// Target Operating system
		"BYTE   neHflagsothers;" & _       ;// Other .EXE flags
		"USHORT   neHpretthunks;" & _        ;// offset to return thunks
		"USHORT   neHpsegrefbytes;" & _      ;// offset to segment ref. bytes
		"USHORT   neHswaparea;" & _          ;// Minimum code swap area size
		"USHORT   neHexpver" ;// Expected Windows version number

Global Const $IMAGE_DOS_SIGNATURE = 0x5A4D;0x4D5A      ;// MZ
Global Const $IMAGE_OS2_SIGNATURE = 0x454E;0x4E45      ;// NE

; This struct is read part for pasrt, so no $tag constants needed
#cs
	;RESOURCE_TABLE :
	ushort  		rscAlignShift;
	TYPEINFO[]		rscTypes;
	ushort  		rscEndTypes;
	byte[]  		rscResourceNames;
	byte    		rscEndNames
#ce

Global Const $tagTYPEINFO_ = "ushort rtTypeID;ushort rtResourceCount; uint RESERVED"
#cs
	TYPEINFO:
	ushort   		rtTypeID
	ushort   		rtResourceCount
	uint    		RESERVED
	TNAMEINFO[]		rtNameInfo ( count is rtResourceCount )
#ce
Global Const $tagTNAMEINFO = "ushort rnOffset; ushort rnLength; ushort rnFlags; ushort rnID; ushort rnHandle; ushort rnUsage"
#cs
	TNAMEINFO
	ushort   		rnOffset
	ushort   		rnLength
	ushort   		rnFlags
	ushort   		rnID
	ushort   		rnHandle
	ushort   		rnUsage
#ce
Global Const $tagGRPICONDIR = _
		"ushort            idReserved;" & _ ;  // Reserved (must be 0)
		"ushort            idType;" & _ ;       // Resource type (1 for icons)
		"ushort            idCount;" ;      // How many images?
;~ 	GRPICONDIRENTRY   idEntries[1]; // The entries for each image

Global Const $tagGRPICONDIRENTRY = _
		"BYTE   bWidth;" & _               ;// Width, in pixels, of the image
		"BYTE   bHeight;" & _              ;// Height, in pixels, of the image
		"BYTE   bColorCount;" & _          ;// Number of colors in image (0 if >=8bpp)
		"BYTE   bReserved;" & _            ;// Reserved
		"ushort   wPlanes;" & _              ;// Color Planes
		"ushort   wBitCount;" & _            ;// Bits per pixel
		"DWORD  dwBytesInRes;" & _         ;// how many bytes in this resource?
		"ushort   nID;" ;// the ID


Global Const $_ICL_RT_GROUP_ICON = 14
Global Const $_ICL_RT_ICON = 3

;===============================================================================
;
; Function Name:   _ICL_ReadNEHeaders()
; ONLY INTERNAL USE
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_ReadNEHeaders($FileHandle)
	_ICL_WinAPI_SetFilePointer($FileHandle, 0, 0) ; Return to beginning of file
	$tIMAGE_DOS_HEADER = DllStructCreate($tagIMAGE_DOS_HEADER)

	Local $ReadBytes
	If _WinAPI_ReadFile($FileHandle, DllStructGetPtr($tIMAGE_DOS_HEADER), DllStructGetSize($tIMAGE_DOS_HEADER), $ReadBytes) Then ; REad File
		If DllStructGetData($tIMAGE_DOS_HEADER, "eHmagic") <> $IMAGE_DOS_SIGNATURE Then Return SetError(2, 0, 0) ; If no NE-Exe return error

		Local $e_lfanew = DllStructGetData($tIMAGE_DOS_HEADER, "eHlfanew") ; read os2 header pointer
		_ICL_WinAPI_SetFilePointer($FileHandle, $e_lfanew) ; jump to os2 header
		
		Local $tIMAGE_OS2_HEADER = DllStructCreate($tagIMAGE_OS2_HEADER) ;create os2 header Struct
		$ReadBytes = 0
		If _WinAPI_ReadFile($FileHandle, DllStructGetPtr($tIMAGE_OS2_HEADER), DllStructGetSize($tIMAGE_OS2_HEADER), $ReadBytes) Then ;Successful read

			If DllStructGetData($tIMAGE_OS2_HEADER, 1) <> $IMAGE_OS2_SIGNATURE Then Return SetError(2, 0, 0) ; If no NE-Exe return error
			Local $ne_restab = DllStructGetData($tIMAGE_OS2_HEADER, "neHrestab")
			Local $ne_rsrctab = DllStructGetData($tIMAGE_OS2_HEADER, "neHrsrctab")
			If $ne_restab = $ne_rsrctab Then Return SetError(3, 0, 0)
			
			_ICL_WinAPI_SetFilePointer($FileHandle, $ne_rsrctab + $e_lfanew)
		Else
			Return SetError(1, 0, 0)
		EndIf
		Return StringSplit($e_lfanew & "|" & $ne_rsrctab, "|") ; success: return offset of OS2Header and Offset of Resource Table
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_ICL_ReadNEHeaders

;===============================================================================
;
; Function Name:   _ICL_ReadResourceTable()
; ONLY INTERNAL USE
; Author(s):       Prog@ndy
;
;===============================================================================
;
; Returns rscAlignShift
Func _ICL_ReadResourceTable($FileHandle, ByRef $aICON_GROUPS, ByRef $aICONS, ByRef $aRESOURCE_NAMES)
	Local $sUshort = DllStructCreate("ushort")
	Local $rscAlignShift
	Local $ReadBytes
	Local $Icon_Groups = 0, $Icons = 0, $typeInfoStructs = 0
	
	If _WinAPI_ReadFile($FileHandle, DllStructGetPtr($sUshort), DllStructGetSize($sUshort), $ReadBytes) Then
		$rscAlignShift = DllStructGetData($sUshort, 1)
		$tTYPEINFO_ = DllStructCreate($tagTYPEINFO_)
		If $ICL_DEBUG Then ConsoleWrite("rscAlignShift: " & $rscAlignShift & @CRLF)
		Local $TotlalResID = 0
		While _WinAPI_ReadFile($FileHandle, DllStructGetPtr($tTYPEINFO_), DllStructGetSize($tTYPEINFO_), $ReadBytes) _
				And DllStructGetData($tTYPEINFO_, 1) > 0
			$typeInfoStructs += 1
			$tNAMEINFO = DllStructCreate($tagTNAMEINFO)
			For $i = 1 To DllStructGetData($tTYPEINFO_, 2)
				_WinAPI_ReadFile($FileHandle, DllStructGetPtr($tNAMEINFO), DllStructGetSize($tNAMEINFO), $ReadBytes)
				Switch Number(Binary(DllStructGetData($tTYPEINFO_, 1)))
					Case $_ICL_RT_GROUP_ICON
						$Icon_Groups += 1
						If $ICL_DEBUG Then ConsoleWrite("rnID: " & Number(Binary(DllStructGetData($tNAMEINFO, "rnID"))) & @CRLF)
						_ICL_ArrayAdd($aICON_GROUPS, DllStructGetData($tNAMEINFO, "rnOffset"), DllStructGetData($tNAMEINFO, "rnLength"), _
								DllStructGetData($tNAMEINFO, "rnFlags"), Number(Binary(DllStructGetData($tNAMEINFO, "rnID"))), _
								DllStructGetData($tNAMEINFO, "rnHandle"), DllStructGetData($tNAMEINFO, "rnUsage"), $TotlalResID)
					Case $_ICL_RT_ICON
						$Icons += 1
						_ICL_ArrayAdd($aICONS, DllStructGetData($tNAMEINFO, "rnOffset"), DllStructGetData($tNAMEINFO, "rnLength"), _
								DllStructGetData($tNAMEINFO, "rnFlags"), Number(Binary(DllStructGetData($tNAMEINFO, "rnID"))), _
								DllStructGetData($tNAMEINFO, "rnHandle"), DllStructGetData($tNAMEINFO, "rnUsage"))
				EndSwitch
				$TotlalResID += 1
			Next
		WEnd
		_ICL_WinAPI_SetFilePointer($FileHandle, -6, 1) ; We read 6 bytes too much, after the double 0 -Byte
		$aRESOURCE_NAMES = _ICL_ReadResourceNames($FileHandle)
	Else
		Return SetError(1, 0, -1)
	EndIf
	If $ICL_DEBUG Then MsgBox(0, "DEBUG", "TypeInfo Structs: " & $typeInfoStructs & @CRLF & _
			"Icon Groups: " & $Icon_Groups & @CRLF & _
			"Icons: " & $Icons)
	Return $rscAlignShift
EndFunc   ;==>_ICL_ReadResourceTable

;===============================================================================
;
; Function Name:   _ICL_ReadResourceNames()
; ONLY INTERNAL USE
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_ReadResourceNames($FileHandle)
	Local $Count = 0, $namesarray
	If $ICL_DEBUG Then ConsoleWrite("==RESNAMES=================================" & @CRLF)
	While 1
		$name = _ICL_ReadCharsFirstByteIsCount($FileHandle)
		If @error <> 0 Then ExitLoop
		$Count += 1
		If $ICL_DEBUG Then ConsoleWrite("resname " & $Count & ":" & $name & @CRLF)
		_ICL_ArrayAdd($namesarray, $name)
	WEnd
	If $ICL_DEBUG Then ConsoleWrite("ResourceName Count: " & $Count & @CRLF & "==========================================" & @CRLF)
	Return $namesarray
EndFunc   ;==>_ICL_ReadResourceNames

;===============================================================================
;
; Function Name:   _ICL_ReadCharsFirstByteIsCount()
; ONLY INTERNAL USE
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_ReadCharsFirstByteIsCount($FileHandle)
	Local $ReadBytes
	Local $Count = DllStructCreate("byte")
	_WinAPI_ReadFile($FileHandle, DllStructGetPtr($Count), DllStructGetSize($Count), $ReadBytes)
	If DllStructGetData($Count, 1) = 0 Then Return SetError(-1, 0, "") ; End of strings
	Local $string = DllStructCreate("char[" & DllStructGetData($Count, 1) & "]")
	_WinAPI_ReadFile($FileHandle, DllStructGetPtr($string), DllStructGetSize($string), $ReadBytes)
	Return DllStructGetData($string, 1)
EndFunc   ;==>_ICL_ReadCharsFirstByteIsCount


;===============================================================================
;
; Function Name:   _ICL_SaveIconGroup()
; ONLY INTERNAL USE
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_SaveIconGroup($FileHandle, $ICOPath, $Icon_Group, $aICONS, $aICON_GROUPS, $rscAlignShift)
	Local $rscShifted = BitShift(1, -1 * $rscAlignShift)
	Local $ReadBytes
	Local $ICOHandle = _WinAPI_CreateFile($ICOPath, 1, 4)

	Local $realOffset = $aICON_GROUPS[$Icon_Group][0] * $rscShifted

	_ICL_WinAPI_SetFilePointer($FileHandle, $realOffset, 0)
	$header = DllStructCreate($tagGRPICONDIR)

	_WinAPI_ReadFile($FileHandle, DllStructGetPtr($header), DllStructGetSize($header), $ReadBytes)
	If DllStructGetData($header, 2) > 2 Then DllStructSetData($header, 2, 1)
	If $ICL_DEBUG Then MsgBox(0, 'icon group', "Reserved: " & DllStructGetData($header, 1) & @CRLF & _
			"Type: " & DllStructGetData($header, 2) & @CRLF & "IconCount: " & DllStructGetData($header, 3))

	_WinAPI_WriteFile($ICOHandle, DllStructGetPtr($header), DllStructGetSize($header), $ReadBytes)
	Local $IconPointerforOffset_ID

	For $icon = 1 To DllStructGetData($header, 3)
		$tGRPICONDIRENTRY__ = DllStructCreate($tagGRPICONDIRENTRY & "ushort")
		_WinAPI_ReadFile($FileHandle, DllStructGetPtr($tGRPICONDIRENTRY__), DllStructGetSize($tGRPICONDIRENTRY__) - 2, $ReadBytes)
;~ 		If $ICL_DEBUG Then ConsoleWrite(DllStructGetSize($tGRPICONDIRENTRY__) & @CRLF)
;~ 		If $ICL_DEBUG Then ConsoleWrite($ReadBytes & @CRLF)
;~ 		If $ICL_DEBUG Then ConsoleWrite(DllStructGetData($tGRPICONDIRENTRY__, 7) & @CRLF)
		
		_WinAPI_WriteFile($ICOHandle, DllStructGetPtr($tGRPICONDIRENTRY__), DllStructGetSize($tGRPICONDIRENTRY__), $ReadBytes)
		_ICL_ArrayAdd($IconPointerforOffset_ID, _ICL_WinAPI_SetFilePointer($ICOHandle, 0, 1) - 4, DllStructGetData($tGRPICONDIRENTRY__, 8), DllStructGetData($tGRPICONDIRENTRY__, 7))
	Next
	Local $Icon_Index
	For $IconInGroup = 0 To UBound($IconPointerforOffset_ID) - 1
		$Icon_Index = $Icon_Index
		If $aICONS[$Icon_Index][3] <> $IconPointerforOffset_ID[$IconInGroup][1] Then
			For $Temp = 0 To UBound($aICONS) - 1
				If $aICONS[$Temp][3] = $IconPointerforOffset_ID[$IconInGroup][1] Then
					$Icon_Index = $Temp
					ExitLoop
				EndIf
			Next
		EndIf
		If $aICONS[$Icon_Index][3] = $IconPointerforOffset_ID[$IconInGroup][1] Then
			If $ICL_DEBUG Then MsgBox(0, '', $IconPointerforOffset_ID[$IconInGroup][2])
			_ICL_WinAPI_SetFilePointer($FileHandle, $aICONS[$Icon_Index][0] * $rscShifted, 0)
			$Temp = DllStructCreate("byte[" & $IconPointerforOffset_ID[$IconInGroup][2] & "]")
			$sOffset = DllStructCreate("byte[4]")
			_WinAPI_ReadFile($FileHandle, DllStructGetPtr($Temp), DllStructGetSize($Temp), $ReadBytes)
			DllStructSetData($sOffset, 1, _ICL_GetCurrentFilePointer($ICOHandle))
			_WinAPI_WriteFile($ICOHandle, DllStructGetPtr($Temp), DllStructGetSize($Temp), $ReadBytes)
			$oldPtr = _ICL_GetCurrentFilePointer($ICOHandle)
			_ICL_WinAPI_SetFilePointer($ICOHandle, $IconPointerforOffset_ID[$IconInGroup][0], 0)
			_WinAPI_WriteFile($ICOHandle, DllStructGetPtr($sOffset), DllStructGetSize($sOffset), $ReadBytes)
			_ICL_WinAPI_SetFilePointer($ICOHandle, $oldPtr, 0)
		EndIf
	Next
	_WinAPI_CloseHandle($ICOHandle)
EndFunc   ;==>_ICL_SaveIconGroup

;===============================================================================
;
; Function Name:   _ICL_GetCurrentFilePointer()
; Description::    Gets the current position in the file
; Parameter(s):    FileHandle from _WinAPI_CreateFile
; Requirement(s):  WinAPI
; Return Value(s): Current pointer-position
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_GetCurrentFilePointer($FileHandle)
	Return _ICL_WinAPI_SetFilePointer($FileHandle, 0, 1)
EndFunc   ;==>_ICL_GetCurrentFilePointer


;===============================================================================
;
; Function Name:   _ICL_ArrayAdd()
; ONLY INTERNAL USE
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_ArrayAdd(ByRef $array, $value1, $value2 = Default, $value3 = Default, $value4 = Default, $value5 = Default, $value6 = Default, $value7 = Default)
	Switch @NumParams
		Case 2
			If Not IsArray($array) Then
				Dim $array[1] = [$value1]
			Else
				ReDim $array[UBound($array) + 1]
				$array[UBound($array) - 1] = $value1
			EndIf
			Return 1
		Case 3
			If Not IsArray($array) Then
				Dim $array[1][2] = [[$value1, $value2]]
			Else
				ReDim $array[UBound($array) + 1][2]
				$array[UBound($array) - 1][0] = $value1
				$array[UBound($array) - 1][1] = $value2
			EndIf
			Return 1
		Case 4 To @NumParams
			If Not IsArray($array) Then
				Dim $array[1][@NumParams - 1]
			Else
				ReDim $array[UBound($array) + 1][@NumParams - 1]
			EndIf
			For $i = 1 To @NumParams - 1
				$array[UBound($array) - 1][$i - 1] = Eval("value" & $i)
			Next
	EndSwitch
	Return 0
EndFunc   ;==>_ICL_ArrayAdd

; Author ........: Zedna
Func _ICL_WinAPI_SetFilePointer($hFile, $iPos, $iMethod = 0)
	Local $aResult
	Local Const $INVALID_SET_FILE_POINTER = -1

	$aResult = DllCall("kernel32.dll", "long", "SetFilePointer", "hwnd", $hFile, "long", $iPos, "long_ptr", 0, "long", $iMethod)
	If @error Then Return SetError(1, 0, -1)
	If $aResult[0] = $INVALID_SET_FILE_POINTER Then Return SetError(2, 0, -1)
	Return $aResult[0]
EndFunc   ;==>_ICL_WinAPI_SetFilePointer

;===============================================================================
;
; Function Name:   _ICL_FileIsPEFormat()
; ONLY INTERNAL USE
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_FileIsPEFormat($FileHandle)
	Local $OldPTR = _ICL_GetCurrentFilePointer($FileHandle)
	_ICL_WinAPI_SetFilePointer($FileHandle,0x3C,0)
	Local $PTRStruct = DllStructCreate("ptr"),$ReadBytes
	_WinAPI_ReadFile($FileHandle,DllStructGetPtr($PTRStruct),DllStructGetSize($PTRStruct),$ReadBytes)
	_ICL_WinAPI_SetFilePointer($FileHandle,DllStructGetData($PTRStruct,1),0)
	Local $PTRStruct = DllStructCreate("char[4]"),$ReadBytes
	_WinAPI_ReadFile($FileHandle,DllStructGetPtr($PTRStruct),DllStructGetSize($PTRStruct),$ReadBytes)
	_ICL_WinAPI_SetFilePointer($FileHandle,$OldPTR,0)
	If DllStructGetData($PTRStruct,1) = ("PE" & Chr(0) & Chr(0)) Then Return 1
	Return 0
EndFunc

;===============================================================================
;
; Function Name:   _ICL_ExtractIcon
; Description::    Extracts an Icon Group Resource from an ICL-File
; Parameter(s):    $ICLFile    : File to extract Icon from
;                  $Icon_Group : Icon Group Resource to extract
;                            positive: 0 based group index
;                            negative: Icon Index starting with -1
;                            string  : name of resource
;                  $ICOFile    : Icon File to create
; Requirement(s):  _WinAPI.au3
; Return Value(s): Success: 1, Error: 0, @error > 0
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_ExtractIcon($ICLFile, $Icon_Group, $ICOFile)
	Local $FileHandle = _WinAPI_CreateFile($ICLFile, 3, 2, 2)
	If Not @error And Not _ICL_FileIsPEFormat($FileHandle) Then
		Local $Pointers = _ICL_ReadNEHeaders($FileHandle)
		If @error Then Return SetError(1, 0, _WinAPI_CloseHandle($FileHandle) * 0)

		Local $aICON_GROUPS, $aICONS, $ReadBytes, $ResNames

		Local $rscAlignShift = _ICL_ReadResourceTable($FileHandle, $aICON_GROUPS, $aICONS, $ResNames)
		Select
			Case IsString($Icon_Group)
				If IsArray($ResNames) Then Local $firstICL = ($ResNames[0] = "ICL") * 1
				For $i = $firstICL To UBound($ResNames) - 1
					If $ResNames[$i] = $Icon_Group Then
						$Icon_Group = $i - $firstICL
						ExitLoop
					EndIf
				Next
				If Not IsNumber($Icon_Group) Then Return SetError(1, 0, 0)
			Case $Icon_Group < 0
				$Icon_Group = -$Icon_Group - 1
			Case Else
				$Icon_Group = Number($Icon_Group)
		EndSelect
		If $Icon_Group >= UBound($aICON_GROUPS) Then Return SetError(1, 0, 0)
		_ICL_SaveIconGroup($FileHandle, $ICOFile, $Icon_Group, $aICONS, $aICON_GROUPS, $rscAlignShift)
		Local $Error = @error
		_WinAPI_CloseHandle($FileHandle)
		If $ICL_DEBUG Then
			Call("_ArrayDisplay", $Pointers, "Array: e_lfanew  ne_rsrctab")
			Call("_ArrayDisplay", $aICON_GROUPS, "Array: ICON_GROUP ResourceTbale entries")
			Call("_ArrayDisplay", $aICONS, "Array: ICON ResourceTbale entries")
		EndIf
		If $Error Then Return SetError(2, 0, 0)
		Return 1
	EndIf
	Return SetError(3, 0, 0)
EndFunc   ;==>_ICL_ExtractIcon


;===============================================================================
;
; Function Name:   _ICL_ExtractMultipleIcons
; Description::    Extracts an Icon Group Resource from an ICL-File
; Parameter(s):    $ICLFile    : File to extract Icon from
;                  $Icon_Group : 1-Dimensional Array of Icon Group Resources to extract
;                            positive: 0 based group index
;                            negative: Icon Index starting with -1
;                            string  : name of resource
;                  $ICOFile    : Icon File to create
; Requirement(s):  _WinAPI.au3
; Return Value(s): Success: 1, Error: 0, @error > 0
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_ExtractMultipleIcons($ICLFile, $Array_Icon_Group, $ICOFilesPath)
	Local $FileHandle = _WinAPI_CreateFile($ICLFile, 3, 2, 2)
	If Not @error And Not _ICL_FileIsPEFormat($FileHandle) Then
		Local $Pointers = _ICL_ReadNEHeaders($FileHandle)

		Local $aICON_GROUPS, $aICONS, $ReadBytes
		Local $ResNames
		$ICLFile = StringReplace($ICLFile, "/", "\")
		$ICOFilesPath = StringReplace($ICOFilesPath, "/", "\")
		DirCreate($ICOFilesPath)
		If Not (StringRight($ICOFilesPath, 1) = "\") Then $ICOFilesPath &= "\"
		
		Local $FileName = StringTrimLeft($ICLFile, StringInStr($ICLFile, "\", 1, -1))
		$FileName = StringLeft($FileName, StringInStr($FileName, ".", 1, -1) - 1)
		Local $rscAlignShift = _ICL_ReadResourceTable($FileHandle, $aICON_GROUPS, $aICONS, $ResNames)
;~ 		Local $ResNames = _ICL_ReadResourceNames($FileHandle)
		Local $Icon_Group, $icg, $i
		Local $Errors[UBound($Array_Icon_Group)], $ErrorCount
		For $icg = 0 To UBound($Array_Icon_Group) - 1
			$Icon_Group = $Array_Icon_Group[$icg]
			
			Select
				Case IsString($Icon_Group)
					If IsArray($ResNames) Then Local $firstICL = ($ResNames[0] = "ICL") * 1
					For $i = $firstICL To UBound($ResNames) - 1
						If $ResNames[$i] = $Icon_Group Then
							$Icon_Group = $i - $firstICL
							For $j = 0 To UBound($aICON_GROUPS) - 1
								If $Icon_Group = $aICON_GROUPS[$j][6] Then
									$Icon_Group = $aICON_GROUPS[$j][6]
									ExitLoop 2
								EndIf
							Next
							$Icon_Group = "$Ä_NOTFOUND%"
							ExitLoop
						EndIf
					Next
					If Not IsNumber($Icon_Group) Then
						$Errors[$icg] = 1
						$ErrorCount += 1
						ContinueLoop
					EndIf
				Case $Icon_Group < 0
					$Icon_Group = -$Icon_Group - 1
				Case Else
					$Icon_Group = Number($Icon_Group)
			EndSelect
			$ICOFile = $ICOFilesPath & $FileName & "_" & StringFormat("%05s", $Icon_Group) & ".ico"
			If $Icon_Group >= UBound($aICON_GROUPS) Then
				$Errors[$icg] = 1
				$ErrorCount += 1
				ContinueLoop
			EndIf
			_ICL_SaveIconGroup($FileHandle, $ICOFile, $Icon_Group, $aICONS, $aICON_GROUPS, $rscAlignShift)
			Local $Error = @error
			If $ICL_DEBUG Then
				Call("_ArrayDisplay", $Pointers, "Array: e_lfanew  ne_rsrctab")
				Call("_ArrayDisplay", $aICON_GROUPS, "Array: ICON_GROUP ResourceTbale entries")
				Call("_ArrayDisplay", $aICONS, "Array: ICON ResourceTbale entries")
			EndIf
			If $Error Then
				$Errors[$icg] = 2
				$ErrorCount += 1
				ContinueLoop
			EndIf
		Next
		_WinAPI_CloseHandle($FileHandle)
		Return SetError($ErrorCount > 0, $ErrorCount, 1)
	EndIf
	Return SetError(3, 0, 0)
EndFunc   ;==>_ICL_ExtractMultipleIcons


;===============================================================================
;
; Function Name:   _ICL_ListIcons
; Description::    Lists all Icons of an ICL-File
; Parameter(s):    $ICLFile    : File to list Icons
; Requirement(s):  _WinAPI.au3
; Return Value(s): Success: Array with all possible IDS to get, Error: 0, @error > 0
;                     [0] -> the 0-based Index
;                     [1] -> the negative index, starting with -1
;                     [0] -> if available, the name of the resource
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _ICL_ListIcons($ICLFile)
	Local $FileHandle = _WinAPI_CreateFile($ICLFile, 3, 2, 2)
	If Not @error Then
		Local $Pointers = _ICL_ReadNEHeaders($FileHandle)
		If @error Then Return SetError(1, 0, _WinAPI_CloseHandle($FileHandle) * 0)

		Local $aICON_GROUPS, $aICONS, $ReadBytes, $ResNames

		Local $rscAlignShift = _ICL_ReadResourceTable($FileHandle, $aICON_GROUPS, $aICONS, $ResNames)

		_WinAPI_CloseHandle($FileHandle)
		If Not IsArray($aICON_GROUPS) Then Return SetError(2, 0, 0)
		Local $Icons_Array[UBound($aICON_GROUPS)][3], $firstICL = ($ResNames[0] = "ICL") * 1
		
		For $i = 0 To UBound($aICON_GROUPS) - 1
			$Icons_Array[$i][0] = $i
			$Icons_Array[$i][1] = -($i + 1)
			If UBound($ResNames) > ($i + $firstICL) Then $Icons_Array[$i][2] = $ResNames[$i + $firstICL]
		Next
;~ 		If $ICL_DEBUG Then
;~ 			Call("_ArrayDisplay",$Pointers, "Array: e_lfanew  ne_rsrctab")
;~ 			Call("_ArrayDisplay",$aICON_GROUPS, "Array: ICON_GROUP ResourceTbale entries")
;~ 			Call("_ArrayDisplay",$aICONS, "Array: ICON ResourceTbale entries")
;~ 			Call("_ArrayDisplay",$ResNames, "Array: Resource Names")
;~ 		EndIf
		Return $Icons_Array
	EndIf
	Return SetError(3, 0, 0)
EndFunc   ;==>_ICL_ListIcons

;~ $ICLFile = "C:\Dokumente und Einstellungen\Andy\Lokale Einstellungen\Temp\free_icon_library\dog.icl"
;~ $ICLFile = "C:\Dokumente und Einstellungen\Andy\Lokale Einstellungen\Temp\free_icon_library\key.icl"
;~ Dim $Ressources[2] = ["CRYPTUI_3424","IEXPLORE_32546"]
;~ _ICL_ExtractMultipleIcons("C:\Dokumente und Einstellungen\Andy\Lokale Einstellungen\Temp\free_icon_library\key.icl", $Ressources,@DesktopDir & "\au3test")
;~ $ICL_DEBUG = 1
;~ _ICL_ExtractIcon("C:\Dokumente und Einstellungen\Andy\Lokale Einstellungen\Temp\free_icon_library\key.icl", "IEXPLORE_32546",@DesktopDir & "\au3test.ico")
;~ $Icons = _ICL_ListIcons(@DesktopDir & "\twunk_16.exe")
;~ _ICL_ListIcons("D:\Dokumente\Dateien von Andreas\AutoIt3\library.icl")