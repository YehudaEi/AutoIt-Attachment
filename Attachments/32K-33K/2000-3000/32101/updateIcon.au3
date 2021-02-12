#include <winapi.au3>
Global Const $RT_ICON = 3, $RT_GROUP_ICON = 14
Global $GroupIconStruct

_UpdateIcon(@ScriptDir&"\au3.exe", @ScriptDir&"\update.ico")
ConsoleWrite("! Final E = "&@error&@CRLF)

Func _UpdateIcon($sExe, $sIco)
	Local $fo, $fr, $ico_buffer, $ico_ptr, $hBegin
	Local $ICONS_ARRAY, $icon_counter = 0
	$fo = FileOpen($sIco, 16)
	If @error Then Return SetError(1)
	$ico_buffer = DllStructCreate("byte[" & FileGetSize($sIco) & "]")
	DllStructSetData($ico_buffer, 1, FileRead($fo))
	$ico_ptr = DllStructGetPtr($ico_buffer)
	FileClose($fo)

	__ReadIcon($ICONS_ARRAY, $ico_ptr,$ico_ptr)
	If Not @error Then
		$icon_counter = $ICONS_ARRAY[0][0]
	Else
		Return SetError(2)
	EndIf

	$hBegin = _BeginUpdate($sExe)
	If @error Then Return SetError(3, @error)
	Local $idata, $isize
	Local $rec_ico_id[6] = [4,5,6,7,8,9],$REC_LIMIT = 6

	If $icon_counter < 6 Then
		Local $REC_LIMIT = $icon_counter
	EndIf

	For $i = 1 To $REC_LIMIT
		$isize = BinaryLen($ICONS_ARRAY[$i][7])
		ConsoleWrite("raw size: "&$isize&@CRLF)
		$idata = DllStructCreate("byte[" & $isize & "]")
		DllStructSetData($idata, 1, $ICONS_ARRAY[$i][7])
		_UpdateRec($hBegin,$RT_ICON, $rec_ico_id[$i-1], 2057, DllStructGetPtr($idata), $isize)
	Next
 	__GR_STRUCTURE($REC_LIMIT)
 	If Not @error Then
		; Fill the Header
		DllStructSetData($GroupIconStruct, "Reserved", 0); reserved, must be 0
		DllStructSetData($GroupIconStruct, "ResourceType", 1); type is 1 for icons
		DllStructSetData($GroupIconStruct, "ImageCount", $REC_LIMIT)
		DllStructSetData($GroupIconStruct, "idEntries", $REC_LIMIT * 16); totalDirEntries * Size = ????????

		Local $elementIndexS = 4, $elementIndexE = 11, $indexCounter = 0,$TempIconStruct[$REC_LIMIT]
		For $d = 1 To $REC_LIMIT ; Dirs
			$TempIconStruct[$d-1] = DllStructCreate("BYTE;BYTE;BYTE;BYTE;ushort;ushort;DWORD;ushort")
			ConsoleWrite("Dir[" & $d & "]" & @CRLF)
			For $e = $elementIndexS To $elementIndexE ;Data
				Switch $indexCounter
					Case 7 ; Data of icon
						DllStructSetData($GroupIconStruct, $e, $rec_ico_id[$d-1])
						ConsoleWrite("		DllStructSetData($GroupIconStruct," & $e & "," & $rec_ico_id[$d-1] & ")" & @CRLF)
					Case Else
						DllStructSetData($GroupIconStruct, $e, $ICONS_ARRAY[$d][$indexCounter])
						ConsoleWrite("		DllStructSetData($GroupIconStruct," & $e & "," & $ICONS_ARRAY[$d][$indexCounter]&")" & @CRLF)
				EndSwitch
				$indexCounter += 1
			Next
			$indexCounter = 0
			$elementIndexS += 8
			$elementIndexE += 8
		Next
		_UpdateRec($hBegin, $RT_GROUP_ICON, 99, 2057, DllStructGetPtr($GroupIconStruct), DllStructGetSize($GroupIconStruct) + (16 * $REC_LIMIT) )
		EndUpdate($hBegin)
	Else
		Return SetError(3, @error)
	EndIf
EndFunc   ;==>_UpdateIcon

Func _BeginUpdate($sFile);, $delExists = False)
	Local $res = DllCall("kernel32.dll", "ptr", "BeginUpdateResourceW", "wstr", $sFile, "int", 0)
	If @error Or Not $res[0] Then
		Return SetError(1)
	Else
		Return SetError(0,0,$res[0])
	EndIf
EndFunc   ;==>_BeginUpdate

Func _UpdateRec($hUpdate, $Type, $Name, $Language, $pData, $cbData)
	$res = DllCall("kernel32.dll", "int", "UpdateResourceW", "ptr", $hUpdate, "int", $Type, "int", $Name, "int", $Language, "ptr", $pData, "dword", $cbData)
	If Not $res[0] Then
		ConsoleWrite("! UpdateResource Fails: "&_WinAPI_GetLastErrorMessage()&@CRLF)
		Return SetError(1)
	Else
		ConsoleWrite("> UpdateResource: "&_WinAPI_GetLastErrorMessage()&@CRLF)
		Return SetError(0)
	EndIf
EndFunc   ;==>_UpdateRec
Func EndUpdate($hUpdate,$fDiscard = 0)
	$res = DllCall ("kernel32.dll", "int","EndUpdateResource","hwnd",$hUpdate,"int",$fDiscard)
	If Not $res[0] Then
		ConsoleWrite("! EndUpdateResource Fails."&_WinAPI_GetLastErrorMessage()&@CRLF)
		Return SetError(1)
	Else
		ConsoleWrite("> EndUpdateResource:"&_WinAPI_GetLastErrorMessage()&@CRLF)
		Return SetError(0)
	EndIf
EndFunc

Func __GR_STRUCTURE($iMax)
	Local $HEADER = "ushort Reserved1;ushort ResourceType;ushort ImageCount;ptr idEntries" ;idEntries = Fucked Up
	;$Dirs = "BYTE Width;BYTE Height;BYTE Colors;BYTE Reserved2;ushort Planes;ushort BitsPerPixel;DWORD ImageSize;ushort ResourceID"
	Local $Dirs = "byte;byte;byte;byte;ushort;ushort;DWORD;ushort" ; Size 16
	Local $GroupIcon = ""

	$GroupIconStruct = DllStructCreate($HEADER)
	Return 0

	For $i = 1 To $iMax
		If $i = 1 Then
			$GroupIcon = $HEADER & ";" & $Dirs & ";"
		ElseIf $i = $iMax Then
			$GroupIcon &= $Dirs
		Else
			$GroupIcon &= $Dirs & ";"
		EndIf
	Next
	ConsoleWrite($GroupIcon & @CRLF)

	$GroupIconStruct = DllStructCreate($GroupIcon)
	If $GroupIconStruct = 0 Then
		ConsoleWrite("!" & @error & @CRLF)
		Return SetError(1)
	Else
		ConsoleWrite("> " & DllStructGetSize($GroupIconStruct) & @CRLF)
		Return SetError(0)
	EndIf
EndFunc   ;==>__GR_STRUCTURE
Func __ReadIcon(ByRef $sIco_Dirs,$ico_ptr,$ico_pt_orignal)
	;$ico_header = "ushort Reserved;ushort Type;ushort ImageCount"
	Local $ico_header = "ushort Reserved;ushort Type;ushort ImageCount"
	;$ICON_DIR_ENTRY = "byte Width;byte Height;byte Colors;Byte Reserved;ushort Planes;ushort BitsPerPixel;dword ImageSize;dword ImageOffset"
	Local $ICON_DIR_ENTRY = "byte Width;byte Height;byte Colors;Byte Reserved;ushort Planes;ushort BitsPerPixel;dword ImageSize;dword ImageOffset"

	Local $sIco_Head = DllStructCreate($ico_header, $ico_ptr)
	Local $image_counter = DllStructGetData($sIco_Head, 3)

	$ico_ptr += 6
	Dim $sIco_Dirs[$image_counter + 1][8]
	$sIco_Dirs[0][0] = $image_counter

	$debug = StringSplit($ICON_DIR_ENTRY, ";")
	Local $tempStruc
	For $i = 1 To $image_counter
		$tempStruc = DllStructCreate($ICON_DIR_ENTRY, $ico_ptr)
		ConsoleWrite(">++++++++++DirReading[" & $i & "]Start" & @CRLF)
		For $d = 1 To 8
			ConsoleWrite($d-1&" :")
		Switch $d
			Case 7
				$imageSize = DllStructGetData($tempStruc,$d)
				$sIco_Dirs[$i][$d-1] = $imageSize
				ConsoleWrite("ImageSize: "&$sIco_Dirs[$i][$d-1] & @CRLF)
			Case 8
				$ImageOffset = DllStructGetData($tempStruc,$d)
				$imageStructure = DllStructCreate("byte["&$imageSize&"]",$ico_pt_orignal + $ImageOffset)
				$sIco_Dirs[$i][$d-1] = DllStructGetData($imageStructure, 1)
				ConsoleWrite("Data :: "&$sIco_Dirs[$i][$d-1]&@CRLF)
			Case Else
				$sIco_Dirs[$i][$d-1] = DllStructGetData($tempStruc, $d)
				ConsoleWrite($sIco_Dirs[$i][$d-1] & @CRLF)
		EndSwitch
		Next
		ConsoleWrite("-++++++++++DirReading Ends" & @CRLF & @CRLF)
		$ico_ptr += 16
		$tempStruc = 0
	Next
	Return SetError(0)
EndFunc   ;==>__ReadIcon