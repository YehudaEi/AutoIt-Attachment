#include <Date.AU3>
#include <Crypt.au3>
#include <WinAPI.au3>
#include <GuiConstants.au3>

$GUI = GUICreate("Image VHD Tool", 400, 65)
GUISetBkColor(0xb2ccff, $GUI)
$Message = GUICtrlCreateLabel("", 10, 10, 380, 15)
$Progress = GUICtrlCreateProgress(10, 35, 380, 20)
GUISetState(@SW_HIDE, $GUI)

$ChooseImage = FileOpenDialog("Choose the disk image", @DesktopDir, "All (*.*)")
$Size = FileGetSize($ChooseImage)
$CreateNew = MsgBox(4, "Create new file?", "Create a new file for the VHD image? (HIGHLY suggested to preserve the forensic integrity of the original file!)")
If $CreateNew == 6 Then ;yes
	$VHDImage = FileOpenDialog("Choose where to save the image and the new file name", -1, "All (*.*)")
	GUISetState(@SW_SHOW, $GUI)
	GUICtrlSetData($Message, "Copying VHD image")
	_LargeFileCopy($ChooseImage, $VHDImage)
Else
	$VHDImage = $ChooseImage
	GUISetState(@SW_SHOW, $GUI)
EndIf

GUICtrlSetData($Message, "Creating footer")
GUICtrlSetData($Progress, 0)

$Cookie = "636F6E6563746978" ;																								"cookie", 8 bytes
$Features = "00000002" ;																									features, 4 bytes
$Format = "00010000" ;																										format, 4 bytes
$Offset = "FFFFFFFFFFFFFFFF" ;																								data offset, 8 bytes
$Stamp = Hex(String(_DateDiff("s", "2000/01/01 00:00:00", _NowCalc())), 8) ;												timestamp, 4 bytes
$CreatorApp = "49616E4D" ;																									creator application, 4 bytes
$CreatorVer = "0D976CD0" ;																									creator version, 4 bytes
$CreatorOS = "5769326B" ;																									creator host os, 4 bytes
$SizeOrig = Hex($Size, 16) ;																								original size, 8 bytes
$SizeCurr = $SizeOrig ;																										current size, 8 bytes
$Geometry = _GetGeometry($Size) ;																							disk geometry, 4 bytes
$DiskType = "00000002" ;																									disk type, 4 bytes
$UUID = _MakeUUID() ;																										unique id, 16 bytes
$SavedState = "00" ;																										saved state, 1 byte
$Reserved = _MakeReserved() ;																								reserved, 427 bytes

$Checksum = _MakeChecksum($Cookie & $Features & $Format & $Offset & $Stamp & $CreatorApp & $CreatorVer & $CreatorOS & $SizeOrig & $SizeCurr & $Geometry & $DiskType & $UUID & $SavedState & $Reserved) ;		checksum, 4 bytes
$Footer = $Cookie & $Features & $Format & $Offset & $Stamp & $CreatorApp & $CreatorVer & $CreatorOS & $SizeOrig & $SizeCurr & $Geometry & $DiskType & $Checksum & $UUID & $SavedState & $Reserved

FileOpen($VHDImage, 1)
For $a = 1 To StringLen($Footer) / 2
	FileWrite($VHDImage, Chr(Dec(StringMid($Footer, $a * 2 - 1, 2))))
Next
GUICtrlSetData($Message, "Finished writing footer, the file is ready for use")
GUICtrlSetData($Progress, 100)
Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit
Until True == False
Exit


Func _GetGeometry($sSize)
	$TotalSectors = FileGetSize($ChooseImage) / 512
	If $TotalSectors > (65535 * 16 * 255) Then
		$TotalSectors = (65535 * 16 * 255)
	EndIf
	If $TotalSectors >= (65535 * 16 * 63) Then
		$SectorsPerTrack = 255
		$Heads = 16
		$CylinderTimesHeads = $TotalSectors / $SectorsPerTrack
	Else
		$SectorsPerTrack = 17
		$CylinderTimesHeads = $TotalSectors / $SectorsPerTrack
		$Heads = ($CylinderTimesHeads + 1023) / 1024
		If $Heads < 4 Then $Heads = 4
		If $CylinderTimesHeads >= ($Heads * 1024) Or $Heads > 16 Then
			$SectorsPerTrack = 31
			$Heads = 16
			$CylinderTimesHeads = $TotalSectors / $SectorsPerTrack
		EndIf
		If $CylinderTimesHeads >= ($Heads * 1024) Then
			$SectorsPerTrack = 63
			$Heads = 16
			$CylinderTimesHeads = $TotalSectors / $SectorsPerTrack
		EndIf
	EndIf
	$Cylinders = $CylinderTimesHeads / $Heads
	Return Hex(Ceiling($Cylinders), 4) & Hex($Heads, 2) & Hex($SectorsPerTrack, 2)
EndFunc   ;==>_GetGeometry


Func _MakeUUID()
	Local $Rand
	For $a = 1 To 10
		$Rand &= Hex(Random(97, 122, 1), 2)
	Next
	Return "766469736b2d" & $Rand
EndFunc   ;==>_MakeUUID


Func _MakeReserved()
	Local $sReserved
	For $a = 1 To 427
		$sReserved &= "00"
	Next
	Return $sReserved
EndFunc   ;==>_MakeReserved


Func _MakeChecksum($WSOGMM)
	Local $ChecksumTally
	For $a = 1 To StringLen($WSOGMM) / 2
		$ChecksumTally += Dec(StringMid($WSOGMM, $a * 2 - 1, 2))
	Next
	$ChecksumTallyBin = BitNOT($ChecksumTally)
	$ChecksumTally = Hex($ChecksumTallyBin)
	Return $ChecksumTally
EndFunc   ;==>_MakeChecksum


; #FUNCTION# ====================================================================================================
; Name...........:  _LargeFileCopy
; Description....:  Copy large files in such a way as to keep AutoIt GUIs responsive
; Syntax.........:  _LargeFileCopy($sSrc, $sDest[, $iFlags = 0[, $iToRead = 2097152[, $iAlg = $CALG_MD5[, $sFunction = ""[, $vUserVar = Default]]]]])
; Parameters.....:  $sSrc       - Source file name
;                   $sDest      - Destination: may be a file name or directory
;                   $iFlags     - [Optional] Combine flags with BitOR
;                               |   1 - Overwrite existing file
;                               |   2 - Create destination directory structure
;                               |   4 - Flush the destination file buffer before returning
;                               |   8 - Verify source and destination are identical via bit by bit comparison
;                               |  16 - Verify source and destination are identical via MD5 hash
;                               |  32 - Verify source and destination file size only
;                               |  64 - Copy source file attributes (NOT including Compression or Encryption)
;                               | 128 - Copy source file Creation time
;                               | 256 - Copy source file Last Accessed time
;                               | 512 - Copy source file Modified time
;                               |1024 - Copy source file Security Descriptors and Ownership
;                               |2048 - Copy source compression state
;                               |4096 - Copy source encryption state
;                               + If more than one verify flag is set, the smallest flag will take precedence
;                   $iToRead    - [Optional] Size of the read/write buffer (Default = 2 MB)
;                   $iAlg       - [Optional] Algorithm to use for file verification (Default = $CALG_MD5)
;                               + Available algorithms: $CALG_MD2, $CALG_MD4, $CALG_MD5, $CALG_SHA1
;                   $sFunction  - [Optional] Function to be called after each write operation (Default = "")
;                               + Function will be called with the following parameters:
;                               | 1 - Total bytes written
;                               | 2 - Total file size in bytes
;                               | 3 - Optional user variable
;                   $vUserVar   - [Optional] User variable to pass to function (Default = Default)
;
; Return values..:  Success     - 1
;                   Failure     - 0 and sets @error
;                               | 1 - Failed to open source file, or source was a directory
;                               | 2 - Destination file exists and overwrite flag not set
;                               | 3 - Failed to create destination file
;                               | 4 - Read error during copy
;                               | 5 - Write error during copy
;                               | 6 - Verify failed
; Author.........:  Erik Pilsits
; Modified.......:	Ian Maxwell (llewxamnai @ AutoIt frums)
; Remarks........:	Modified for this app, this is not the original, please do not reuse!
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _LargeFileCopy($sSrc, $sDest, $iFlags = 0, $iToRead = 2097152, $iAlg = $CALG_MD5, $sFunction = "", $vUserVar = Default)
	Local $CurrentFileProg
	; open file for reading, fail if it doesn't exist or directory
;~ 	Local $hSrc = _FileEx_CreateFile($sSrc, $GENERIC_READ, $FILE_SHARE_READ, $OPEN_EXISTING, 0)
	Local $hSrc = _WinAPI_CreateFile($sSrc, 2, 2)
	If Not $hSrc Then Return SetError(1, 0, 0)

	; create destination file
	$hDest = _WinAPI_CreateFile($sDest, 1, 4)
	If Not $hDest Then
		_WinAPI_CloseHandle($hSrc)
		Return SetError(3, 0, 0)
	EndIf

	; perform copy
	Local $iRead, $iWritten, $bytesRead = 0, $iTotal = 0, $mSrc = 0, $iReadError = 0, $iWriteError = 0, $iVerifyError = 0
	; allocate buffers
	Local $apBuffers = _LFC_CreateBuffers($iToRead)
	; read buffer
	Local $pBuffer = $apBuffers[0]
	; verify buffer
	Local $pvBuffer = $apBuffers[1]

	While $bytesRead < $Size
		If $iToRead > ($Size - $bytesRead) Then $iToRead = $Size - $bytesRead
		If Not _WinAPI_ReadFile($hSrc, $pBuffer, $iToRead, $iRead) Or ($iToRead <> $iRead) Then
			$iReadError = 1
			ExitLoop
		EndIf
		If Not _WinAPI_WriteFile($hDest, $pBuffer, $iRead, $iWritten) Or ($iRead <> $iWritten) Then
			$iWriteError = 1
			ExitLoop
		EndIf
		$CurrentFileProg += $iRead
		$FileProgCalc = $CurrentFileProg / $Size * 100
		GUICtrlSetData($Progress, $FileProgCalc)
		$bytesRead += $iToRead
	WEnd

	; close handles
	_WinAPI_CloseHandle($hDest)
	_WinAPI_CloseHandle($hSrc)

	If $iReadError Then
		Return SetError(4, 0, 0)
	ElseIf $iWriteError Then
		Return SetError(5, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>_LargeFileCopy
Func _LFC_CreateBuffers($iBuffSize)
	Return _LFC_ControlBuffers($iBuffSize)
EndFunc   ;==>_LFC_CreateBuffers
Func _LFC_ControlBuffers($iBuffSize, $fCreate = True)
	Static Local $iPrevSize = 0, $apBuffers = 0

	If $fCreate Then
		If (Not IsArray($apBuffers)) Or ($iBuffSize > $iPrevSize) Then
			_LFC_FreeBuffers()
			$iPrevSize = $iBuffSize
			_LFC_AllocBuffers($apBuffers, $iBuffSize)
			; init crypt library, only once
			If Not __Crypt_RefCount() Then _Crypt_Startup()
		EndIf

		Return $apBuffers
	Else
		If IsArray($apBuffers) Then
			_MemVirtualFree($apBuffers[0], 0, $MEM_RELEASE)
			_MemVirtualFree($apBuffers[1], 0, $MEM_RELEASE)
		EndIf
		$iPrevSize = 0
		$apBuffers = 0
	EndIf
EndFunc   ;==>_LFC_ControlBuffers
Func _LFC_FreeBuffers()
	_LFC_ControlBuffers(0, False)
EndFunc   ;==>_LFC_FreeBuffers
Func _LFC_AllocBuffers(ByRef $apBuffers, $iBuffSize)
	Dim $apBuffers[2] = [ _
			_MemVirtualAlloc(0, $iBuffSize, $MEM_COMMIT, $PAGE_READWRITE), _
			_MemVirtualAlloc(0, $iBuffSize, $MEM_COMMIT, $PAGE_READWRITE) _
			]
EndFunc   ;==>_LFC_AllocBuffers
