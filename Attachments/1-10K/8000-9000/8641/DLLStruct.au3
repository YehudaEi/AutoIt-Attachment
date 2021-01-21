#cs
vi:ts=4 sw=4:
DLLStruct.au3
Ejoc
Add easier support for structs within structs
#ce
#include-once

;=====================================================
;	_DllStructGetSizeFromStr($szStruct)
;	$string		The string you would use in DllStructCreate
;	Returns		The size of the struct
;				0 on error and sets @Error To the DllStructCreate Error
;=====================================================
Func _DllStructGetSizeFromStr($szStruct)
	Local $a
	SetError(0)

	$a	= DllStructCreate($szStruct,1);dont allocate memory
	If @Error Then Return 0
	Return $a[0][1]
EndFunc

;=====================================================
;	_DllStructSubStruct(ByRef $p, $iElement, $szStruct)
;	$p			The return from DllStructCreate()
;	$iElement	The element where the sub struct is located
;	$szStruct	The String representing the Sub Struct
;	Returns a new struct for use in DllStructGet/DllStructSet
;	Sets @Error to -1 if $iElement is outside, -2 sub struct
;		would go outside the bounds of the struct
;	$p's elements are decreased as the substruct elements are removed
;
;	$RECT_STR	= "int;int;int;int"
;	$POINT_STR	= "int;int"
;	$p			= DllStructCreate("ptr;" & $RECT_STR & ";" & $POINT_STR)
;	$rect		= _DllStructSubStruct($p,2,$RECT_STR)
;	$point		= _DllStructSubStruct($p,3,$POINT_STR)
;	DllCall("some.dll","int","func","ptr",DllStructPtr($p))
;	$point_x	= DllStructGet($point,1)
;	$point_y	= DllStructGet($point,2)
;	$left		= DllStructGet($rect,1)
;	$top		= DllStructGet($rect,2)
;	$right		= DllStructGet($rect,3)
;	$bottom		= DllStructGet($rect,4)
;	DllStructFree($p)
;=====================================================
Func _DllStructSubStruct(ByRef $p,$iElement,$szStruct)
	local $array,$iSubSize,$szSplit,$i,$iSubOffset=0

	SetError(0)
	$szSplit	= StringSplit($szStruct,";");count the semicolons
	$iSubSize	= $szSplit[0]
	if StringRight($szStruct,1) = ";" Then $iSubSize -= 1;ingnore a trail ';'

	;check if it is a valid element
	if $iElement > $p[0][2] Or $iElement < 1 Then
		SetError(-1)
		return
	Endif

	;check if the substruct would go beyond the struct
	if $iElement + $iSubSize > $p[0][2] Then
		SetError(-2)
		return
	EndIf

	Dim $array[$iSubSize+1][3]
	For $i = 1 To $iSubSize
		$array[$i][0]	= $iSubOffset;new offset
		$array[$i][1]	= $p[$iElement + $i - 1][1];sizeof(datatype)
		$array[$i][2]	= $p[$iElement + $i - 1][2];flags
		If $iElement + $i <= $p[0][2] Then ;isnt the last element of the struct
			$iSubOffset		= $p[$iElement + $i][0] - $p[$iElement][0]
		Else;this is the last element of the struct
			$iSubOffset		= $p[0][1] - $p[$iElement][0]
		EndIf
	Next
	$array[0][0]	= $p[0][0] + $p[$iElement][0];ptr to the substruct
	$array[0][1]	= $iSubOffset	;substruct size in bytes
	$array[0][2]	= $iSubSize		;elements in substruct

	$p[$iElement][1]	= 1 ;set the datatype size for the sub struct to 1
	;shift the elements down
	For $i = $iElement + 1 To $p[0][2] - ($iSubSize - 1)
		$p[$i][0]	= $p[$i + $iSubSize - 1][0]
		$p[$i][1]	= $p[$i + $iSubSize - 1][1]
		$p[$i][2]	= $p[$i + $iSubSize - 1][2]
	Next
	;decrease the number of elements
	$p[0][2]	-= $iSubSize - 1

	ReDim $p[$p[0][2]+1][3]

	Return $array
EndFunc

;===============================================
;	_FileReadToDLLStruct($szFileName)
;	Read a file into a DllStruct, which you must delete
;	$szFileName		Name of the file to read
;	Return			DllStruct which element 1 is an
;					array of bytes = file size
;					element 2  is the number of bytes
;					read.  Access the data with:
;					$n = DllStructGetData($p,2)
;					DllStructGetData($p,1,1..$n)
;	On Error		@Error is set to
;					-1 File does not exist
;					-2 DllStructCreate Failed
;					-3 Could not open File
;					-4 DllCall Failed
;					-5 ReadFile Failed
;===============================================
Func _FileReadToDLLStruct($szFileName)
	Local $p,$ilen=0,$ret,$file

	SetError(0)
	If Not FileExists($szFileName) Then ; File doesn't exist
		SetError(-1)
		return
	EndIf

	$iLen	= FileGetSize($szFileName)
	$p		= DllStructCreate("byte[" & $iLen & "];int")
	if @error Then ; DllStructCreate Failed
		SetError(-2)
		return
	EndIf

	; Open the file for reading
	$ret	= DllCall("kernel32.dll","int","CreateFile", _
						"str",$szFileName, _
						"int",0x80000000, _
						"int",0, _
						"ptr",0, _
						"int",3, _
						"int",0x80, _
						"ptr",0)
						
	if @error OR Not $ret[0] Then ; CreateFile or DllCall failed
		SetError(-3)
		$p = 0
		return
	EndIf

	$file	= $ret[0]
	$ret	= DllCall("kernel32.dll","int","ReadFile", _
					"int",$file, _
					"ptr",DllStructGetPtr($p), _
					"int",$iLen, _
					"ptr",DllStructGetPtr($p,2), _
					"ptr",0)
	if @error Then ; DllCall failed
		SetError(-4)
		$p = 0
		DllCall("kernel32.dll","int","CloseHandle","int",$file)
		return
	EndIf
	If Not $ret[0] Then ; ReadFile failed
		SetError(-5)
		$p = 0
		DllCall("kernel32.dll","int","CloseHandle","int",$file)
		return
	EndIf

	DllCall("kernel32.dll","int","CloseHandle","int",$file)
	Return $p
EndFunc

;===============================================
;	_FileWriteFromDLLStruct($p,$szFileName)
;	Write a Struct to a file
;	$p				Struct to write
;	$szFileName		Name of the file to write
;	Return			Bytes Written
;	On Error		@Error is set to
;					-1 invalid Struct
;					-2 DllStructGetSize Failed
;					-3 Could not open File
;					-4 DllCall Failed
;					-5 WriteFile Failed
;===============================================
Func _FileWriteFromDLLStruct($p,$szFileName)
	Local $ilen=0,$ret,$file

	SetError(0)

	If Not IsArray($p) Then
		SetError(-1)
		return
	EndIf

	$iLen	= DllStructGetSize($p)
	If @error Then
		SetError(-2)
		return
	EndIf

	;if the struct passed is the struct created from _FileReadToStruct,
	;Dont write the int
	If $p[0][2] = 2 AND $p[2][0] = DllStructGetData($p,2) Then ;
		$iLen	-= 4
	EndIf

	; Open the file for writing
	$ret	= DllCall("kernel32.dll","int","CreateFile", _
						"str",$szFileName, _
						"int",0x40000000, _
						"int",1, _
						"ptr",0, _
						"int",4, _
						"int",0x80, _
						"ptr",0)
						
	if @error OR Not $ret[0] Then ; CreateFile or DllCall failed
		SetError(-3)
		return
	EndIf

	$file	= $ret[0]
	$ret	= DllCall("kernel32.dll","int","WriteFile", _
					"int",$file, _
					"ptr",DllStructGetPtr($p), _
					"int",$iLen, _
					"int_ptr",0, _
					"ptr",0)
	if @error Then ; DllCall failed
		SetError(-4)
		DllCall("kernel32.dll","int","CloseHandle","int",$file)
		return
	EndIf
	If Not $ret[0] Then ; WriteFile failed
		SetError(-5)
		DllCall("kernel32.dll","int","CloseHandle","int",$file)
		return
	EndIf

	DllCall("kernel32.dll","int","CloseHandle","int",$file)
	Return $ret[4]
EndFunc

;===============================================
;	_DllStructCreateFromString($szString)
;	Create a DllStruct That is a string, and copy $szString into it
;	$szString		String to be in the new struct
;	Return			Success a new struct, Failure @error = -1
;===============================================
Func _DllStructCreateFromString($szString)
	Local $p

	SetError(0)

	$p	= DllStructCreate("char[" & StringLen($szString) + 1 & "]")
	If @Error Then
		SetError(-1)
		Return
	EndIf
	DllStructSetData($p,1,$szString)

	Return $p
EndFunc

;===============================================
;	_GetLastErrorMessage($DisplayMsgBox="")
;	Format the last windows error as a string and return it
;	if $DisplayMsgBox <> "" Then it will display a message box w/ the error
;	Return		Window's error as a string
;===============================================
Func _GetLastErrorMessage($DisplayMsgBox="")
	Local $ret,$s
	Local $p	= DllStructCreate("char[4096]")
	Local Const $FORMAT_MESSAGE_FROM_SYSTEM		= 0x00001000

	If @error Then Return ""

	$ret	= DllCall("Kernel32.dll","int","GetLastError")

	$ret	= DllCall("kernel32.dll","int","FormatMessage", _
						"int",$FORMAT_MESSAGE_FROM_SYSTEM, _
						"ptr",0, _
						"int",$ret[0], _
						"int",0, _
						"ptr",DllStructGetPtr($p), _
						"int",4096, _
						"ptr",0)
	$s	= DllStructGetData($p,1)
	$p = 0
	If $DisplayMsgBox <> "" Then MsgBox(0,"_GetLastErrorMessage",$DisplayMsgBox & @CRLF & $s)
	return $s
EndFunc
