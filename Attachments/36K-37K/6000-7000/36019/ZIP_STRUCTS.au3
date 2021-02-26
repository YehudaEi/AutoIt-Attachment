#include <FileConstants.au3>
#include <winapi.au3>
#include <Array.au3>
#Include <String.au3>
#Include <Date.au3>
;
; Attempt at creating a base for a zip udf from scratch
; by Joakim Schicht
;
Global $file_header = "504b0304"
Global $data_descripor = "504b0708"
Global $central_dir_start = "504b0102"
Global $central_dir_end_sig = "504b0506"
Global $cdeSize = 22
Global $cdeCDOffset, $iFile, $SrcFile, $cdeCDRecords, $CentralDirectoryStart;, $NewDeflate
Global $LFH_Array[21][1]
Global $CDE[9][2]
Global $CDS_Array[24][2]

$iFile = FileOpenDialog("Select zip file:",@ScriptDir,"All (*.*)")
If @error Then Exit
ConsoleWrite("Selected zip: " & $iFile & @CRLF)
$CDEprocess = _CDE($iFile)
If NOT @error Then
	_ArrayDisplay($CDE,"Central Directory End:")
Else
	ConsoleWrite("Error: Processing CDE failed and returned: " & @error & @CRLF)
	Exit
EndIf
$LFHprocess = _ProcessLFH()
If NOT @error Then
	_ArrayDisplay($LFH_Array,"Local File Headers:")
Else
	ConsoleWrite("Error: Processing LFH's failed and returned error code: " & @error & @CRLF)
	Exit
EndIf
$CDSprocess = _ProcessCDS()
If NOT @error Then
	_ArrayDisplay($CDS_Array,"Central Directory File Headers:")
Else
	ConsoleWrite("Error: Processing CDS's failed and returned error code: " & @error & @CRLF)
	Exit
EndIf
Exit


Func _CDE($inFile)
Local $nBytes, $tBuffer ,$cdeBytes
$hFile0 = _WinAPI_CreateFile("\\.\" & $inFile,2,6,7)
If $hFile0 = 0 then
	ConsoleWrite("CDE Error: CreateFile failed" & @CRLF)
	Return SetError(1, 0, 0)
EndIf
$fSize = _WinAPI_GetFileSizeEx($hFile0)
$tBuffer=DllStructCreate("byte[" & $fSize & "]")
$read = _WinAPI_ReadFile($hFile0, DllStructGetPtr($tBuffer), $fSize, $nBytes)
If $read = 0 then
	ConsoleWrite("CDE Error: ReadFile failed" & @CRLF)
	Return SetError(2, 0, 0)
EndIf
$bRaw = DllStructGetData($tBuffer,1)
If $bRaw = "" Then
	ConsoleWrite("CDE Error: DllStructGetData failed" & @CRLF)
	Return SetError(4, 0, 0)
EndIf
$total_tmp_cde = StringReplace($bRaw, $central_dir_end_sig, $central_dir_end_sig)
$total_hits_cde = @extended
ConsoleWrite("CDE: Number of Central Directory End signatures (50 4b 05 06) found: " & $total_hits_cde & @CRLF)
If $total_hits_cde = 0 Then
	ConsoleWrite("Error: No Central Directory End signatures found" & @CRLF)
	Return SetError(3, 0, 0)
EndIf
$stringpos_cde = 1
$stringpos_cde = (StringInStr($bRaw, $central_dir_end_sig, 0, 1, $stringpos_cde)-3)/2
ConsoleWrite("CDE: Central Directory End found at offset: 0x" & Hex($stringpos_cde) & @CRLF)
$cdeCommentLength = StringMid($bRaw,($stringpos_cde*2)+43,4)
$cdeCommentLength = Dec(StringMid($cdeCommentLength,3,2) & StringMid($cdeCommentLength,1,2))
$cdeCommentTest = StringMid($bRaw,($stringpos_cde*2)+47,$cdeCommentLength)
$cdeBuffer=DllStructCreate("byte[" & $cdeSize & "]")
$hFile = _WinAPI_CreateFile("\\.\" & $inFile,2,6,7)
If $hFile = 0 then
	ConsoleWrite("CDE Error: CreateFile failed" & @CRLF)
	Return SetError(1, 0, 0)
EndIf
_WinAPI_SetFilePointer($hFile, $stringpos_cde)
$tBuffer=DllStructCreate("byte[" & $cdeSize & "]")

$read = _WinAPI_ReadFile($hFile, DllStructGetPtr($tBuffer), $cdeSize, $nBytes)
If $read = 0 then
	ConsoleWrite("CDE Error: ReadFile failed" & @CRLF)
	Return SetError(2, 0, 0)
EndIf
$cdeRaw = DllStructGetData($tBuffer,1)
If $cdeRaw = "" Then
	ConsoleWrite("CDE Error: DllStructGetData failed" & @CRLF)
	Return SetError(4, 0, 0)
EndIf

If $cdeCommentLength > 0 And StringMid($bRaw,($stringpos_cde*2)+47,$cdeCommentLength) <> "" Then
	$structZIPFileComment = ';char ZIPFileComment[" & $cdeCommentLength & "]'
Else
	$structZIPFileComment = ""
EndIf
$cdestruct = "dword cdeSignature;word NumberOfDisk;word DiskCDEStart;word CDRecords;dword CDSize;dword CDOffset;word ZIPCommentLength" & $structZIPFileComment
$CentralDirectoryEnd = DllStructCreate($cdestruct,DllStructGetPtr($tBuffer))
#cs
ConsoleWrite("cdeSignature:  " & Hex(DllStructGetData($CentralDirectoryEnd, "cdeSignature")) & @CRLF)
ConsoleWrite("NumberOfDisk:  " & DllStructGetData($CentralDirectoryEnd, "NumberOfDisk") & @CRLF)
ConsoleWrite("DiskCDEStart:  " & DllStructGetData($CentralDirectoryEnd, "DiskCDEStart") & @CRLF)
ConsoleWrite("CDRecords:  " & DllStructGetData($CentralDirectoryEnd, "CDRecords") & @CRLF)
ConsoleWrite("CDSize:  " & DllStructGetData($CentralDirectoryEnd, "CDSize") & @CRLF)
ConsoleWrite("CDOffset:  " & DllStructGetData($CentralDirectoryEnd, "CDOffset") & @CRLF)
ConsoleWrite("ZIPCommentLength:  " & DllStructGetData($CentralDirectoryEnd, "ZIPCommentLength") & @CRLF)
ConsoleWrite("ZIPFileComment:  " & DllStructGetData($CentralDirectoryEnd, "ZIPFileComment") & @CRLF)
#ce
$cdeSignature = Hex(DllStructGetData($CentralDirectoryEnd, "cdeSignature"))
$cdeNumberOfDisk = DllStructGetData($CentralDirectoryEnd, "NumberOfDisk")
$cdeDiskCDEStart = DllStructGetData($CentralDirectoryEnd, "DiskCDEStart")
Global $cdeCDRecords = DllStructGetData($CentralDirectoryEnd, "CDRecords")
Global $cdeCDSize = DllStructGetData($CentralDirectoryEnd, "CDSize")
Global $cdeCDOffset = DllStructGetData($CentralDirectoryEnd, "CDOffset")
$cdeZIPCommentLength = DllStructGetData($CentralDirectoryEnd, "ZIPCommentLength")
$cdeZIPFileComment = DllStructGetData($CentralDirectoryEnd, "ZIPFileComment")
ConsoleWrite("CDE: Central Directory Records: " & $cdeCDRecords & @CRLF)
ConsoleWrite("CDE: Central Directory Size: " & $cdeCDSize & " bytes" & @CRLF)
ConsoleWrite("CDE: Central Directory Position (byte): " & $cdeCDOffset & @CRLF)
ConsoleWrite("CDE: Central Directory Offset: 0x" & Hex($cdeCDOffset) & @CRLF)

$CDE[0][0] = "cdeSignature"
$CDE[1][0] = "cdeNumberOfDisk"
$CDE[2][0] = "cdeDiskCDEStart"
$CDE[3][0] = "cdeCDRecords"
$CDE[4][0] = "cdeCDSize"
$CDE[5][0] = "cdeCDOffset"
$CDE[6][0] = "cdeZIPCommentLength"
$CDE[7][0] = "cdeZIPFileComment"
$CDE[8][0] = "cdeOffset"
$CDE[0][1] = $cdeSignature
$CDE[1][1] = $cdeNumberOfDisk
$CDE[2][1] = $cdeDiskCDEStart
$CDE[3][1] = $cdeCDRecords
$CDE[4][1] = $cdeCDSize
$CDE[5][1] = $cdeCDOffset
$CDE[6][1] = $cdeZIPCommentLength
$CDE[7][1] = $cdeZIPFileComment
$CDE[8][1] = $stringpos_cde
_WinAPI_CloseHandle($hFile0)
_WinAPI_CloseHandle($hFile)
Return
;Return $CDE
EndFunc

Func _ProcessLFH()
Local $nBytes, $tBuffer2
$hFile2 = _WinAPI_CreateFile("\\.\" & $iFile,2,6,7)
If $hFile2 = 0 then
	ConsoleWrite("ProcessLFH Error: CreateFile failed" & @CRLF)
	Return SetError(1, 0, 0)
EndIf
$fSize = _WinAPI_GetFileSizeEx($hFile2)
$tBuffer2=DllStructCreate("byte[" & $fSize-($fSize-$cdeCDOffset) & "]")

$read2 = _WinAPI_ReadFile($hFile2, DllStructGetPtr($tBuffer2), $fSize-($fSize-$cdeCDOffset), $nBytes)
If $read2 = 0 then
	ConsoleWrite("ProcessLFH Error: ReadFile failed" & @CRLF)
	Return SetError(2, 0, 0)
EndIf
$lfhRaw = DllStructGetData($tBuffer2,1)
If $lfhRaw = "" Then
	ConsoleWrite("ProcessLFH Error: DllStructGetData failed" & @CRLF)
	Return SetError(4, 0, 0)
EndIf
$total_tmp_lfh = StringReplace($lfhRaw, $file_header, $file_header)
$total_hits_lfh = @extended
If $total_hits_lfh = 0 Then
	ConsoleWrite("ProcessLFH: Error - no matching LFH signatures." & @CRLF)
	Return SetError(3, 0, 0)
Else
	ConsoleWrite("ProcessLFH: Number of Local File Header signatures (50 4b 03 04) found: " & $total_hits_lfh & @CRLF)
EndIf
If $cdeCDRecords <> $total_hits_lfh Then
	ConsoleWrite("ProcessLFH: Warning - Mismatch in signature detection:  $cdeCDRecords = " & $cdeCDRecords & " $total_hits_lfh = " & $total_hits_lfh & @CRLF)
	Return SetError(4, 0, 0)
EndIf
ReDim $LFH_Array[22][$total_hits_lfh+1]
$LFH_Array[0][0] = "Hex(lfhSignature)"
$LFH_Array[1][0] = "lfhVersionNeeded"
$LFH_Array[2][0] = "lfhGeneralPurposeFlag"
$LFH_Array[3][0] = "lfhCompressionMethod"
$LFH_Array[4][0] = "lfhDOSTime"
$LFH_Array[5][0] = "Hex(lfhDOSTime)"
$LFH_Array[6][0] = "lfhDOSDate"
$LFH_Array[7][0] = "Hex(lfhDOSDate)"
$LFH_Array[8][0] = "lfhConvertedDateTime"
$LFH_Array[9][0] = "lfhCRC32"
$LFH_Array[10][0] = "Hex(lfhCRC32)"
$LFH_Array[11][0] = "lfhCompressedSize"
$LFH_Array[12][0] = "Hex(lfhCompressedSize)"
$LFH_Array[13][0] = "lfhUncompressedSize"
$LFH_Array[14][0] = "Hex(lfhUncompressedSize)"
$LFH_Array[15][0] = "lfhFileNameLength"
$LFH_Array[16][0] = "lfhExtraFieldLength"
$LFH_Array[17][0] = "lfhFileName"
$LFH_Array[18][0] = "lfhExtraField" ; Removed
$LFH_Array[19][0] = "lfhCompressedData" ; Removed
$LFH_Array[20][0] = "lfhOffset"
$LFH_Array[21][0] = "lfhDataOffset"

$stringpos_lfh = 1
$stringpos_lfh = StringInStr($lfhRaw, $file_header, 0, 1, $stringpos_lfh)
If $stringpos_lfh > 0 Then
	$lfh = 1
	$pos_base_lfh = $stringpos_lfh
	$pos_hexbase_lfh = ($stringpos_lfh-3)/2
;	ConsoleWrite("ProcessLFH: $pos_base_lfh = " & $pos_base_lfh & @CRLF)
	$lfhunknowns = _determine_unknowns_lfh($lfhRaw, $pos_base_lfh)
	$lfhstruct = _Generate_lfh_Structure($pos_hexbase_lfh,$lfhunknowns[6],$lfhunknowns[0],$lfhunknowns[1],$lfhunknowns[2],$lfhunknowns[7])
	For $g = 0 To 21
		$LFH_Array[$g][1] = $lfhstruct[$g]
	Next
EndIf
$g = 1
$i = 1
For $i = 1 To $total_hits_lfh
	$stringpos_lfh = StringInStr($lfhRaw, $file_header, 0, 1, $stringpos_lfh+1)
	If $stringpos_lfh > 0 Then
		$lfh = $i+1
		$pos_base_lfh = $stringpos_lfh
		$pos_hexbase_lfh = ($stringpos_lfh-3)/2
		$lfhunknowns = _determine_unknowns_lfh($lfhRaw, $pos_base_lfh)
		$lfhstruct = _Generate_lfh_Structure($pos_hexbase_lfh,$lfhunknowns[6],$lfhunknowns[0],$lfhunknowns[1],$lfhunknowns[2],$lfhunknowns[7])
		For $g = 0 To 21
			$LFH_Array[$g][$i+1] = $lfhstruct[$g]
		Next
	EndIf
Next
_WinAPI_CloseHandle($hFile2)
EndFunc

Func _determine_unknowns_lfh($rawfile, $pos_base_lfh)
Local $LFHunknowns[8]
Local $name_lfh = "", $extra_field_lfh = "", $lfhLength_lfh = "", $lfhLengthBytes_lfh = "", $size_compressed = "", $namelength_lfh = "", $size_extra_field_lfh = ""

$size_compressed = StringMid($rawfile,($pos_base_lfh)+36,8)
$size_compressed = StringMid($size_compressed,7,2) & StringMid($size_compressed,5,2) & StringMid($size_compressed,3,2) & StringMid($size_compressed,1,2)
$size_compressed = (Dec($size_compressed))*2
$namelength_lfh = StringMid($rawfile,($pos_base_lfh)+52,4)
$namelength_lfh = StringMid($namelength_lfh,3,2) & StringMid($namelength_lfh,1,2)
$namelength_lfh = Dec($namelength_lfh)
$namelength_lfh = $namelength_lfh*2
$size_extra_field_lfh = StringMid($rawfile,($pos_base_lfh)+56,4)
$size_extra_field_lfh = StringMid($size_extra_field_lfh,3,2) & StringMid($size_extra_field_lfh,1,2)
$size_extra_field_lfh = (Dec($size_extra_field_lfh))*2
$name_lfh = StringMid($rawfile,($pos_base_lfh)+60,$namelength_lfh)
$name_lfh = _HexToString($name_lfh)
$lfh_extra_field = StringMid($rawfile,($pos_base_lfh)+60+$namelength_lfh,$size_extra_field_lfh)
$lfhLength_lfh = $pos_base_lfh+60+$namelength_lfh+$size_extra_field_lfh+$size_compressed
$lfhLengthBytes_lfh = (60+$namelength_lfh+$size_extra_field_lfh+$size_compressed)/2
$compressed_data = StringMid($rawfile,($pos_base_lfh)+60+$namelength_lfh+$size_extra_field_lfh,$size_compressed)
$LFHunknowns[0] = $size_compressed
$LFHunknowns[1] = $namelength_lfh
$LFHunknowns[2] = $size_extra_field_lfh
$LFHunknowns[3] = $name_lfh
$LFHunknowns[4] = $lfh_extra_field
$LFHunknowns[5] = $lfhLength_lfh
$LFHunknowns[6] = $lfhLengthBytes_lfh
$LFHunknowns[7] = $pos_base_lfh+($lfhLengthBytes_lfh-$size_compressed)
#cs
ConsoleWrite("$LFHunknowns[0] " & $LFHunknowns[0] & @CRLF)
ConsoleWrite("$LFHunknowns[1] " & $LFHunknowns[1] & @CRLF)
ConsoleWrite("$LFHunknowns[2] " & $LFHunknowns[2] & @CRLF)
ConsoleWrite("$LFHunknowns[3] " & $LFHunknowns[3] & @CRLF)
;ConsoleWrite("$LFHunknowns[4] " & $LFHunknowns[4] & @CRLF)
ConsoleWrite("$LFHunknowns[5] " & $LFHunknowns[5] & @CRLF)
ConsoleWrite("$LFHunknowns[6] " & $LFHunknowns[6] & @CRLF)
ConsoleWrite("$LFHunknowns[7] " & $LFHunknowns[7] & @CRLF)
#ce
Return $LFHunknowns
EndFunc

Func _Generate_LFH_Structure($pos_hexbase_lfh,$lfhLengthBytes_lfh,$size_compressed,$namelength_lfh,$size_extra_field_lfh,$lfh_offset_compdata)
Local $tBuffer3 = 0, $jBytes, $LFHStruct[23]

$tBuffer3=DllStructCreate("byte[" & $lfhLengthBytes_lfh & "]")
$hFile3 = _WinAPI_CreateFile("\\.\" & $iFile,2,6,7)
If $hFile3 = 0 then
	ConsoleWrite("LFH_Structure Error: CreateFile failed" & @CRLF)
	Return SetError(1, 0, 0)
EndIf
_WinAPI_SetFilePointer($hFile3, $pos_hexbase_lfh)

$read3 = 0
$read3 = _WinAPI_ReadFile($hFile3, DllStructGetPtr($tBuffer3), $lfhLengthBytes_lfh, $jBytes)
If $read3 = 0 then
	ConsoleWrite("LFH_Structure Error: ReadFile failed" & @CRLF)
	Return SetError(2, 0, 0)
EndIf
$lfhRaw3 = 0
$lfhRaw3 = DllStructGetData($tBuffer3,1)
If $lfhRaw3 = "" Then
	ConsoleWrite("LFH_Structure Error: DllStructGetData failed" & @CRLF)
	Return SetError(4, 0, 0)
EndIf

Global $LocalFileHeader = DllStructCreate("align 1;dword lfhSignature;" & _
        "word lfhVersionNeeded;" & _
        "word lfhGeneralPurposeFlag;" & _
        "word lfhCompressionMethod;" & _
        "word lfhDOSTime;" & _
        "word lfhDOSDate;" & _
        "dword lfhCRC32;" & _
        "dword lfhCompressedSize;" & _
        "dword lfhUncompressedSize;" & _
		"word lfhFileNameLength;" & _
		"word lfhExtraFieldLength;" & _
		_Struct_Correct_LFH($size_compressed,$namelength_lfh,$size_extra_field_lfh) , _
		DllStructGetPtr($tBuffer3))
;If $LocalFileHeader = 0 Then ConsoleWrite("LFH_Structure Error in $LocalFileHeader DllStructCreate: " & @error & @CRLF)
#cs
ConsoleWrite("lfhSignature:  " & Hex(DllStructGetData($LocalFileHeader, "lfhSignature")) & @CRLF)
ConsoleWrite("lfhVersionNeeded:  " & DllStructGetData($LocalFileHeader, "lfhVersionNeeded") & @CRLF)
ConsoleWrite("lfhGeneralPurposeFlag:  " & DllStructGetData($LocalFileHeader, "lfhGeneralPurposeFlag") & @CRLF)
ConsoleWrite("lfhCompressionMethod:  " & DllStructGetData($LocalFileHeader, "lfhCompressionMethod") & @CRLF)
ConsoleWrite("lfhDOSTime:  " & DllStructGetData($LocalFileHeader, "lfhDOSTime") & @CRLF)
ConsoleWrite("lfhDOSTime hex:  " & Hex(DllStructGetData($LocalFileHeader, "lfhDOSTime"),4) & @CRLF)
ConsoleWrite("lfhDOSDate:  " & DllStructGetData($LocalFileHeader, "lfhDOSDate") & @CRLF)
ConsoleWrite("lfhDOSDate hex:  " & Hex(DllStructGetData($LocalFileHeader, "lfhDOSDate"),4) & @CRLF)
ConsoleWrite("lfhConverted DOS Timestamp:  " & _Fix_DOSDateTime() & @CRLF)
ConsoleWrite("lfhCRC32:  " & DllStructGetData($LocalFileHeader, "lfhCRC32") & @CRLF)
ConsoleWrite("lfhCRC32 hex:  " & Hex(DllStructGetData($LocalFileHeader, "lfhCRC32")) & @CRLF)
ConsoleWrite("lfhCompressedSize:  " & DllStructGetData($LocalFileHeader, "lfhCompressedSize") & @CRLF)
ConsoleWrite("lfhCompressedSize hex:  " & Hex(DllStructGetData($LocalFileHeader, "lfhCompressedSize")) & @CRLF)
ConsoleWrite("lfhUncompressedSize:  " & DllStructGetData($LocalFileHeader, "lfhUncompressedSize") & @CRLF)
ConsoleWrite("lfhUncompressedSize hex:  " & Hex(DllStructGetData($LocalFileHeader, "lfhUncompressedSize")) & @CRLF)
ConsoleWrite("lfhFileNameLength:  " & DllStructGetData($LocalFileHeader, "lfhFileNameLength") & @CRLF)
ConsoleWrite("lfhExtraFieldLength:  " & DllStructGetData($LocalFileHeader, "lfhExtraFieldLength") & @CRLF)
ConsoleWrite("lfhFileName:  " & DllStructGetData($LocalFileHeader, "lfhFileName") & @CRLF)
;ConsoleWrite("lfhExtraField:  " & DllStructGetData($LocalFileHeader, "lfhExtraField") & @CRLF)
;ConsoleWrite("lfhCompressedData:  " & DllStructGetData($LocalFileHeader, "lfhCompressedData") & @CRLF)
#ce
$LFHStruct[0] = Hex(DllStructGetData($LocalFileHeader, "lfhSignature"))
$LFHStruct[1] = DllStructGetData($LocalFileHeader, "lfhVersionNeeded")
$LFHStruct[2] = DllStructGetData($LocalFileHeader, "lfhGeneralPurposeFlag")
$LFHStruct[3] = DllStructGetData($LocalFileHeader, "lfhCompressionMethod")
$LFHStruct[4] = DllStructGetData($LocalFileHeader, "lfhDOSTime")
$LFHStruct[5] = Hex(DllStructGetData($LocalFileHeader, "lfhDOSTime"),4)
$LFHStruct[6] = DllStructGetData($LocalFileHeader, "lfhDOSDate")
$LFHStruct[7] = Hex(DllStructGetData($LocalFileHeader, "lfhDOSDate"),4)
$LFHStruct[8] = _Fix_DOSDateTime()
$LFHStruct[9] = DllStructGetData($LocalFileHeader, "lfhCRC32")
$LFHStruct[10] = Hex(DllStructGetData($LocalFileHeader, "lfhCRC32"))
$LFHStruct[11] = DllStructGetData($LocalFileHeader, "lfhCompressedSize")
$LFHStruct[12] = Hex(DllStructGetData($LocalFileHeader, "lfhCompressedSize"))
$LFHStruct[13] = DllStructGetData($LocalFileHeader, "lfhUncompressedSize")
$LFHStruct[14] = Hex(DllStructGetData($LocalFileHeader, "lfhUncompressedSize"))
$LFHStruct[15] = DllStructGetData($LocalFileHeader, "lfhFileNameLength")
$LFHStruct[16] = DllStructGetData($LocalFileHeader, "lfhExtraFieldLength")
$LFHStruct[17] = DllStructGetData($LocalFileHeader, "lfhFileName")
;$LFHStruct[18] = DllStructGetData($LocalFileHeader, "lfhExtraField") ; Removed to save space
$LFHStruct[18] = ""
;$LFHStruct[19] = DllStructGetData($LocalFileHeader, "lfhCompressedData") ; Removed to save space
$LFHStruct[19] = ""
$LFHStruct[20] = $pos_hexbase_lfh
$LFHStruct[21] = $pos_hexbase_lfh+($lfhLengthBytes_lfh-$LFHStruct[11])
_WinAPI_CloseHandle($hFile3)
Return $LFHStruct
EndFunc

Func _config_FileName_LFH($namelength_lfh)
Return "char lfhFileName[" & $namelength_lfh/2 & "];"
EndFunc

Func _config_Extra_Field_LFH($size_extra_field_lfh)
If $size_extra_field_lfh/2 = 0 Then
	Return ""
Else
	Return "byte lfhExtraField[" & $size_extra_field_lfh/2 & "];"
EndIf
EndFunc

Func _config_Compressed_Data_LFH($size_compressed)
If $size_compressed/2 = 0 Then
	Return ""
Else
	Return "byte lfhCompressedData[" & $size_compressed/2 & "]"
EndIf
EndFunc

Func _Struct_Correct_LFH($size_compressed,$namelength_lfh,$size_extra_field_lfh)
$concat_lfh = ""
$concat_lfh = _config_FileName_LFH($namelength_lfh) & _config_Extra_Field_LFH($size_extra_field_lfh) & _config_Compressed_Data_LFH($size_compressed)
;ConsoleWrite("_Struct_Correct_LFH() : " & $concat_lfh & @CRLF)
Return $concat_lfh
EndFunc


Func _LittleBigEndian($iHex)
Local $iHexLen = StringLen($iHex)
Local $iHexTmp = "", $iHexTmp1 = "", $iH
For $iH = 0 To $iHexLen
	$iHexTmp = StringMid($iHex,$iHexLen-$iH+1,2)
	$iHexTmp1 &= $iHexTmp
	$iH += 1
Next
Local $iHexLen1 = StringLen($iHexTmp1)
$iHexTmp2 = StringMid($iHexTmp1,1,$iHexLen1/2)
Return $iHexTmp2
EndFunc

Func _Fix_DOSDateTime()
Local $cdsDOSTime, $cdsDOSDate, $sDate
$cdsDOSTime = "0x" & Hex(DllStructGetData($CentralDirectoryStart, "DOSTime"),4)
$cdsDOSDate = "0x" & Hex(DllStructGetData($CentralDirectoryStart, "DOSDate"),4)
$sDate = _Date_Time_DOSDateTimeToStr($cdsDOSDate, $cdsDOSTime)
Return $sDate
EndFunc

Func _ProcessCDS()
Local $nBytes, $tBuffer5
$hFile = _WinAPI_CreateFile("\\.\" & $iFile,2,6,7)
If $hFile = 0 then
	ConsoleWrite("ProcessCDS Error: CreateFile failed" & @CRLF)
	Return SetError(1, 0, 0)
EndIf
$fSize = _WinAPI_GetFileSizeEx($hFile)
_WinAPI_SetFilePointer($hFile, $cdeCDOffset)
$tBuffer5=DllStructCreate("byte[" & $CDE[8][1]-$CDE[5][1] & "]")
$read = _WinAPI_ReadFile($hFile, DllStructGetPtr($tBuffer5), $CDE[8][1]-$CDE[5][1], $nBytes)
If $read = 0 then
	ConsoleWrite("ProcessCDS Error: ReadFile failed" & @CRLF)
	Return SetError(2, 0, 0)
EndIf
$cdsRaw = DllStructGetData($tBuffer5,1)
If $cdsRaw = "" Then
	ConsoleWrite("ProcessCDS Error: DllStructGetData failed" & @CRLF)
	Return SetError(4, 0, 0)
EndIf
$total_tmp_cds = StringReplace($cdsRaw, $central_dir_start, $central_dir_start)
$total_hits_cds = @extended
If $total_hits_cds = 0 Then
	ConsoleWrite("ProcessCDS: Error - no matching CDS signatures." & @CRLF)
	Return SetError(3, 0, 0)
Else
	ConsoleWrite("ProcessCDS: Number of CDS signatures (50 4b 01 02) found: " & $total_hits_cds & @CRLF)
EndIf
If $cdeCDRecords <> $total_hits_cds Then
	ConsoleWrite("ProcessCDS: Warning - Mismatch in signature detection:  $cdeCDRecords = " & $cdeCDRecords & " $total_hits_cds = " & $total_hits_cds & @CRLF)
	Return SetError(4, 0, 0)
EndIf
ReDim $CDS_Array[24][$total_hits_cds+1]
$CDS_Array[0][0] = "cdsOffset"
$CDS_Array[1][0] = "Hex(cdsSignature)"
$CDS_Array[2][0] = "VersionMadeBy"
$CDS_Array[3][0] = "VersionNeeded"
$CDS_Array[4][0] = "GeneralPurposeFlag"
$CDS_Array[5][0] = "CompressionMethod"
$CDS_Array[6][0] = "DOSTime"
$CDS_Array[7][0] = "DOSDate"
$CDS_Array[8][0] = "ConvertedDateTime"
$CDS_Array[9][0] = "CRC32"
$CDS_Array[10][0] = "CompressedSize"
$CDS_Array[11][0] = "UncompressedSize"
$CDS_Array[12][0] = "FileNameLength"
$CDS_Array[13][0] = "ExtraFieldLength"
$CDS_Array[14][0] = "FileCommentLength"
$CDS_Array[15][0] = "DiskNoFileStart"
$CDS_Array[16][0] = "IntFileAttribute"
$CDS_Array[17][0] = "ExtFileAttribute"
$CDS_Array[18][0] = "RelOffsetLFH"
$CDS_Array[19][0] = "FileName"
$CDS_Array[20][0] = "ExtraField"
$CDS_Array[21][0] = "FileComment"
$CDS_Array[22][0] = "cdsSize"
$CDS_Array[23][0] = "cdsOffsetRelative"
$stringpos_cds = 1
$stringpos_cds = StringInStr($cdsRaw, $central_dir_start, 0, 1, $stringpos_cds)
If $stringpos_cds > 0 Then
	$pos_base_cds = $stringpos_cds
	$pos_hexbase_cds = ($stringpos_cds-3)/2
;	ConsoleWrite("ProcessCDS: $pos_base_cds = " & $pos_base_cds & @CRLF)
	$cdsunknowns = _determine_unknowns($cdsRaw, $pos_base_cds)
	$cdsstruct = _generate_cds_structure($pos_hexbase_cds,$cdsunknowns[7],$cdsunknowns[1],$cdsunknowns[2],$cdsunknowns[5])
	For $g = 0 To 23
		$CDS_Array[$g][1] = $cdsstruct[$g]
	Next
EndIf
$g = 1
$i = 1
For $i = 1 To $total_hits_cds
	$stringpos_cds = StringInStr($cdsRaw, $central_dir_start, 0, 1, $stringpos_cds+1)
	If $stringpos_cds > 0 Then
		$pos_base_cds = $stringpos_cds
		$pos_hexbase_cds = ($stringpos_cds-3)/2
		$cdsunknowns = _determine_unknowns($cdsRaw, $pos_base_cds)
		$cdsstruct = _generate_cds_structure($pos_hexbase_cds,$cdsunknowns[7],$cdsunknowns[1],$cdsunknowns[2],$cdsunknowns[5])
		For $g = 0 To 23
			$CDS_Array[$g][$i+1] = $cdsstruct[$g]
		Next
	EndIf
Next
_WinAPI_CloseHandle($hFile)
EndFunc

Func _determine_unknowns($cdsRaw, $pos_base)
Local $CDSunknowns[8]
Local $extra_field = "", $name = "", $extra_field = "", $cdsLength = "", $cdsLengthBytes = ""
Local $namelength = "", $size_extra_field = "",  $cdsFileCommentLength = ""
$namelength = StringMid($cdsRaw,($pos_base)+56,4)
$namelength = StringMid($namelength,3,2) & StringMid($namelength,1,2)
$namelength = Dec($namelength)
$namelength = $namelength*2
$size_extra_field = StringMid($cdsRaw,($pos_base)+62,4)
$size_extra_field = StringMid($size_extra_field,3,2) & StringMid($size_extra_field,1,2)
$size_extra_field = (Dec($size_extra_field))*2
$name = StringMid($cdsRaw,($pos_base)+92,$namelength);94??
$name = _HexToString($name)
$cds_extra_field = StringMid($cdsRaw,($pos_base)+92+$namelength,$size_extra_field)
$cdsFileCommentLength = StringMid($cdsRaw,($pos_base)+66,4)
$cdsFileCommentLength = StringMid($cdsFileCommentLength,3,2) & StringMid($cdsFileCommentLength,1,2)
$cdsFileCommentLength = (Dec($cdsFileCommentLength))*2
$cdsLength = $pos_base+92+$namelength+$size_extra_field+$cdsFileCommentLength
$cdsLengthBytes = (92+$namelength+$size_extra_field+$cdsFileCommentLength)/2
$CDSunknowns[1] = $namelength
$CDSunknowns[2] = $size_extra_field
$CDSunknowns[3] = $name
$CDSunknowns[4] = $cds_extra_field
$CDSunknowns[5] = $cdsFileCommentLength
$CDSunknowns[6] = $cdsLength
$CDSunknowns[7] = $cdsLengthBytes
Return $CDSunknowns
EndFunc

Func _generate_cds_structure($pos_hexbase,$cdsLengthBytes,$namelength,$size_extra_field,$cdsFileCommentLength)
Local $tBuffer1 = 0, $nBytes, $CDSStruct[24]
$tBuffer1=DllStructCreate("byte[" & $cdsLengthBytes & "]")
$hFile1 = _WinAPI_CreateFile("\\.\" & $iFile,2,6,7)
If $hFile1 = 0 then
	ConsoleWrite("CDS_structure Error: CreateFile failed" & @CRLF)
	Return SetError(1, 0, 0)
EndIf
_WinAPI_SetFilePointer($hFile1, $cdeCDOffset+$pos_hexbase)
$read1 = 0
$read1 = _WinAPI_ReadFile($hFile1, DllStructGetPtr($tBuffer1), $cdsLengthBytes, $nBytes)
If $read1 = 0 then
	ConsoleWrite("CDS_structure Error: ReadFile failed" & @CRLF)
	Return SetError(2, 0, 0)
EndIf
$cdsRaw1 = 0
$cdsRaw1 = DllStructGetData($tBuffer1,1)
If $cdsRaw1 = "" Then
	ConsoleWrite("CDS_structure Error: DllStructGetData failed" & @CRLF)
	Return SetError(4, 0, 0)
EndIf
Global $CentralDirectoryStart = DllStructCreate("align 1;dword cdsSignature;" & _
        "word VersionMadeBy;" & _
        "word VersionNeeded;" & _
        "word GeneralPurposeFlag;" & _
        "word CompressionMethod;" & _
        "word DOSTime;" & _
        "word DOSDate;" & _
        "dword CRC32;" & _
        "dword CompressedSize;" & _
        "dword UncompressedSize;" & _
		"word FileNameLength;" & _
		"word ExtraFieldLength;" & _
		"word FileCommentLength;" & _
		"word DiskNoFileStart;" & _
		"word IntFileAttribute;" & _
		"dword ExtFileAttribute;" & _
		"dword RelOffsetLFH;" & _
		_struct_correct($namelength,$size_extra_field,$cdsFileCommentLength) , _
		DllStructGetPtr($tBuffer1))

#cs
ConsoleWrite("cdsSignature:  " & Hex(DllStructGetData($CentralDirectoryStart, "cdsSignature")) & @CRLF)
ConsoleWrite("VersionMadeBy:  " & DllStructGetData($CentralDirectoryStart, "VersionMadeBy") & @CRLF)
ConsoleWrite("VersionNeeded:  " & DllStructGetData($CentralDirectoryStart, "VersionNeeded") & @CRLF)
ConsoleWrite("GeneralPurposeFlag:  " & DllStructGetData($CentralDirectoryStart, "GeneralPurposeFlag") & @CRLF)
ConsoleWrite("CompressionMethod:  " & DllStructGetData($CentralDirectoryStart, "CompressionMethod") & @CRLF)
ConsoleWrite("DOSTime:  " & DllStructGetData($CentralDirectoryStart, "DOSTime") & @CRLF)
ConsoleWrite("DOSDate:  " & DllStructGetData($CentralDirectoryStart, "DOSDate") & @CRLF)
ConsoleWrite("Converted DOS Timestamp:  " & _Fix_DOSDateTime() & @CRLF)
ConsoleWrite("CRC32:  " & DllStructGetData($CentralDirectoryStart, "CRC32") & @CRLF)
ConsoleWrite("CompressedSize:  " & DllStructGetData($CentralDirectoryStart, "CompressedSize") & @CRLF)
ConsoleWrite("UncompressedSize:  " & DllStructGetData($CentralDirectoryStart, "UncompressedSize") & @CRLF)
ConsoleWrite("FileNameLength:  " & DllStructGetData($CentralDirectoryStart, "FileNameLength") & @CRLF)
ConsoleWrite("ExtraFieldLength:  " & DllStructGetData($CentralDirectoryStart, "ExtraFieldLength") & @CRLF)
ConsoleWrite("FileCommentLength:  " & DllStructGetData($CentralDirectoryStart, "FileCommentLength") & @CRLF)
ConsoleWrite("DiskNoFileStart:  " & DllStructGetData($CentralDirectoryStart, "DiskNoFileStart") & @CRLF)
ConsoleWrite("IntFileAttribute:  " & DllStructGetData($CentralDirectoryStart, "IntFileAttribute") & @CRLF)
ConsoleWrite("ExtFileAttribute:  " & DllStructGetData($CentralDirectoryStart, "ExtFileAttribute") & @CRLF)
ConsoleWrite("RelOffsetLFH:  " & DllStructGetData($CentralDirectoryStart, "RelOffsetLFH") & @CRLF)
ConsoleWrite("FileName:  " & DllStructGetData($CentralDirectoryStart, "FileName") & @CRLF)
ConsoleWrite("ExtraField:  " & DllStructGetData($CentralDirectoryStart, "ExtraField") & @CRLF)
ConsoleWrite("FileComment:  " & DllStructGetData($CentralDirectoryStart, "FileComment") & @CRLF)
#ce
$CDSStruct[0] = $CDE[5][1]+$pos_hexbase
$CDSStruct[1] = Hex(DllStructGetData($CentralDirectoryStart, "cdsSignature"))
$CDSStruct[2] = DllStructGetData($CentralDirectoryStart, "VersionMadeBy")
$CDSStruct[3] = DllStructGetData($CentralDirectoryStart, "VersionNeeded")
$CDSStruct[4] = DllStructGetData($CentralDirectoryStart, "GeneralPurposeFlag")
$CDSStruct[5] = DllStructGetData($CentralDirectoryStart, "CompressionMethod")
$CDSStruct[6] = DllStructGetData($CentralDirectoryStart, "DOSTime")
$CDSStruct[7] = DllStructGetData($CentralDirectoryStart, "DOSDate")
$CDSStruct[8] = _Fix_DOSDateTime()
$CDSStruct[9] = DllStructGetData($CentralDirectoryStart, "CRC32")
$CDSStruct[10] = DllStructGetData($CentralDirectoryStart, "CompressedSize")
$CDSStruct[11] = DllStructGetData($CentralDirectoryStart, "UncompressedSize")
$CDSStruct[12] = DllStructGetData($CentralDirectoryStart, "FileNameLength")
$CDSStruct[13] = DllStructGetData($CentralDirectoryStart, "ExtraFieldLength")
$CDSStruct[14] = DllStructGetData($CentralDirectoryStart, "FileCommentLength")
$CDSStruct[15] = DllStructGetData($CentralDirectoryStart, "DiskNoFileStart")
$CDSStruct[16] = DllStructGetData($CentralDirectoryStart, "IntFileAttribute")
$CDSStruct[17] = DllStructGetData($CentralDirectoryStart, "ExtFileAttribute")
$CDSStruct[18] = DllStructGetData($CentralDirectoryStart, "RelOffsetLFH")
$CDSStruct[19] = DllStructGetData($CentralDirectoryStart, "FileName")
$CDSStruct[20] = DllStructGetData($CentralDirectoryStart, "ExtraField")
$CDSStruct[21] = DllStructGetData($CentralDirectoryStart, "FileComment")
$CDSStruct[22] = $cdsLengthBytes
$CDSStruct[23] = $pos_hexbase
_WinAPI_CloseHandle($hFile1)
Return $CDSStruct
EndFunc

Func _config_extra_field($size_extra_field)
If $size_extra_field/2 = 0 Then
	Return ""
Else
	Return "byte ExtraField[" & $size_extra_field/2 & "];"
EndIf
EndFunc

Func _config_FileComment($cdsFileCommentLength)
If $cdsFileCommentLength/2 = 0 Then
	Return ""
Else
	Return "byte FileComment[" & $cdsFileCommentLength/2 & "]"
EndIf
EndFunc

Func _config_FileName($namelength)
Return "char FileName[" & $namelength/2 & "];"
EndFunc

Func _struct_correct($namelength,$size_extra_field,$cdsFileCommentLength)
Local $concat = ""
$concat = _config_FileName($namelength) & _config_extra_field($size_extra_field) & _config_FileComment($cdsFileCommentLength)
Return $concat
EndFunc
