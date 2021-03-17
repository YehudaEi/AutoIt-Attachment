; ========================================================================================================
; <FilePEOverlayExtract.au3>
;
; UDF and Example of getting Overlay info and optionally extracting that info to a file.
;
; NOTE that this isn't intended to be used to hack or decompile AutoIt executables!!
;  It's main purpose is to find Overlays and Certificates and extract/save or just report the info
;
; Functions:
;	_PEFileGetOverlayInfo()	; Returns a file offset for overlay data (if found), and the size
;
; Author: Ascend4nt
; ========================================================================================================

; Arry indexing
Global Enum $PEI_OVL_START = 0, $PEI_OVL_SIZE, $PEI_CERT_START, $PEI_CERT_SIZE, $PEI_FILE_SIZE

; ---------------------- MAIN CODE -------------------------------

Local $sFile, $sLastDir, $sLastFile, $aOverlayInfo
$sLastDir = @ScriptDir
While 1
	$sFile=FileOpenDialog("Select PE File To Find Overlay Data In",$sLastDir,"PE Files (*.exe;*.dll;*.drv;*.scr;*.cpl;*.sys;*.ocx;*.tlb;*.olb)|All Files (*.*)",3,$sLastFile)
	If @error Or $sFile="" Then Exit
	$sLastFile=StringMid($sFile,StringInStr($sFile,'\',1,-1)+1)
	$sLastDir=StringLeft($sFile,StringInStr($sFile,'\',1,-1)-1)

	$aOverlayInfo = _PEFileGetOverlayInfo($sFile)

	If $aOverlayInfo[$PEI_OVL_START] = 0 Then
		ConsoleWrite("Failed Return from _PEGetOverlayOffset(), @error = " & @error & ", @extended = " & @extended & @CRLF)
		MsgBox(64, "No Overlay Found", "No overlay found in " & $sLastFile)
		ContinueLoop
	EndIf
	ConsoleWrite("Return from _PEFileGetOverlayInfo() = " & $aOverlayInfo[$PEI_OVL_START] & ", @extended = " & $aOverlayInfo[$PEI_OVL_SIZE] & @CRLF)

	If $aOverlayInfo[$PEI_OVL_START] Then
		Local $hFileIn = -1, $hFileOut = -1, $sOutFile, $iMsgBox, $bBuffer, $bSuccess = 0
		$iMsgBox = MsgBox(35, "Overlay found in " & $sLastFile, "Overlay Found. File size: " & $aOverlayInfo[$PEI_FILE_SIZE] & ", Overlay size: " & $aOverlayInfo[$PEI_OVL_SIZE] & @CRLF & @CRLF & _
			"Would you like to:" & @CRLF & _
			"[Yes]: extract and save Overlay" & @CRLF & _
			"[No]: extract Exe without Overlay" & @CRLF & _
			"[Cancel]: Do Nothing")

		If $iMsgBox = 6 Then
			If $aOverlayInfo[$PEI_OVL_SIZE] > 134217728 Then
				MsgBox(48, "Overlay is too huge", "Overlay is > 128MB, skipping..")
				ContinueLoop
			EndIf
			$sOutFile = FileSaveDialog("Overlay - SAVE: Choose a file to write Overlay data to (from " & $sLastFile&")", $sLastDir, "All (*.*)", 2 + 16)
			If Not @error Then

				While 1
					$hFileOut = FileOpen($sOutFile, 16 + 2)
					If $hFileOut = -1 Then ExitLoop
					$hFileIn = FileOpen($sFile, 16)
					If $hFileIn = -1 Then ExitLoop
					If Not FileSetPos($hFileIn, $aOverlayInfo[$PEI_OVL_START], 0) Then ExitLoop
					; AutoIt 2/3 Signature check requires 32 bytes min.
					If $aOverlayInfo[$PEI_FILE_SIZE] > 32 Then
						$bBuffer = FileRead($hFileIn, 32)
						If @error Then ExitLoop
						; AutoIt2 & AutoIt3 signatures
						If BinaryMid($bBuffer, 1, 16) = "0xA3484BBE986C4AA9994C530A86D6487D" Or _
							BinaryMid($bBuffer, 1 + 16, 4) = "0x41553321" Then	; "AU3!"
							ConsoleWrite("AutoIt overlay file found" & @CRLF)
						EndIf
						FileWrite($hFileOut, $bBuffer)
						; subtract amount we read in above
						$bSuccess = FileWrite($hFileOut, FileRead($hFileIn, $aOverlayInfo[$PEI_OVL_SIZE] - 32))
					Else
						$bSuccess = FileWrite($hFileOut, FileRead($hFileIn, $aOverlayInfo[$PEI_OVL_SIZE]))
					EndIf
					ExitLoop
				WEnd
				If $hFileOut <> -1 Then FileClose($hFileOut)
				If $hFileIn <> -1 Then FileClose($hFileIn)

			EndIf
		ElseIf $iMsgBox = 7 Then
			If $aOverlayInfo[$PEI_FILE_SIZE] - $aOverlayInfo[$PEI_OVL_SIZE] > 134217728 Then
				MsgBox(48, "EXE is too huge", "EXE (minus overlay) is > 128MB, skipping..")
				ContinueLoop
			EndIf
			$sOutFile = FileSaveDialog("EXE {STRIPPED} - SAVE: Choose a file to write EXE (minus Overlay) to. (from " & $sLastFile&")", $sLastDir, "All (*.*)", 2 + 16)
			If Not @error Then
				$bSuccess = FileWrite($sOutFile, FileRead($sFile, $aOverlayInfo[$PEI_OVL_START]))
			EndIf
		Else
			ContinueLoop
		EndIf
		If $bSuccess Then
			ShellExecute(StringLeft($sOutFile,StringInStr($sOutFile,'\',1,-1)-1))
		Else
			MsgBox(64, "Error Opening or writing to file", "Error opening, reading or writing overlay info")
		EndIf
	EndIf
WEnd
Exit


; ------------------------  UDF Function ----------------------------


; ===================================================================================================================
; Func _PEFileGetOverlayInfo($sPEFile)
;
; Returns information on Overlays present in a Windows PE file (.EXE, .DLL etc files), as well as Certificate Info.
;
; Only certain executables contain Overlays, and these are always located after the last PE Section,
; and most times before any Certificate info. Setup/install programs typically package their data in Overlays,
; and AutoIt compiled executables (at least up to v3.3.8.1) contain an overlay in .A3X tokenized format.
;
; Certificate info is available with or without an overlay, and comes after the last section and typically after
; an Overlay. Certificates are included with signed executables (such as Authenticode-signed)
;
; The returned info can be used to examine or extract the Overlay or Certificate, or just to examine the data
; (for example, to see if its an AutoIt tokenized script).
;
; NOTE: Any Overlays packaged into Certificate blocks are ignored, and the methods to extract this info may
; fail if the Certificate Table entries have their sizes modified to include the embedded Overlay.
;
; The returned information can be useful in preventing executable 'optimizers' from stripping the Overlay info,
;  which was the primary intent in creating this UDF.
;
;
; Returns:
;  Success: A 5-element array, @error = 0
;	[0] = Overlay Start (if any)
;	[1] = Overlay Size
;	[2] = Certificate Start (if any)
;	[3] = Certificate Size
;	[4] = File Size
;
;  Failure: Same 5-element array as above (with all 0's), and @error set:
;	@error = -1 = Could not open file
;	@error = -2 = FileRead error (most likely an invalid PE file). @extended = FileRead() @error
;	@error = -3 = FileSetPos error (most likely an invalid PE file)
;	@error =  1 = File does not exist
;	@error =  2 = 'MZ' signature could not be found (not a PE file)
;	@error =  3 = 'PE' signature could not be found (not a PE file)
;	@error =  4 = 'Magic' number not recognized (not PE32, PE32+, could be 'ROM (0x107), or unk.) @extended=number
;
; Author: Ascend4nt
; ===================================================================================================================

Func _PEFileGetOverlayInfo($sPEFile)
;~ 	If Not FileExists($sPEFile) Then Return SetError(1,0,0)
	Local $hFile, $nFileSize, $bBuffer, $iOffset, $iErr, $iExit, $aRet[5] = [0, 0, 0, 0]
	Local $nTemp, $nSections, $nDataDirectories, $nLastSectionOffset, $nLastSectionSz
	Local $iSucces=0, $iCertificateAddress = 0, $nCertificateSz = 0, $stEndian = DllStructCreate("int")

	$nFileSize = FileGetSize($sPEFile)
	$hFile = FileOpen($sPEFile, 16)
	If $hFile = -1 Then Return SetError(-1,0,$aRet)

	; A once-only loop helps where "goto's" would be helpful
	Do
		; We keep different exit codes for different operations in case of failure (easier to track down what failed)
		;	The function can be altered to remove these assignments of course
		$iExit = -2
		$bBuffer = FileRead($hFile, 2)
		If @error Then ExitLoop

		$iExit = 2
;~ 	'MZ' in hex (endian-swapped):
		If $bBuffer <> 0x5A4D Then ExitLoop
		;ConsoleWrite("MZ Signature found:"&BinaryToString($bBuffer)&@CRLF)

		$iExit = -3
;~ 	Move to Windows PE Signature Offset location
		If Not FileSetPos($hFile, 0x3C, 0) Then ExitLoop

		$iExit = -2
		$bBuffer = FileRead($hFile, 4)
		If @error Then ExitLoop

		$iOffset = Number($bBuffer)	; Though the data is in little-endian, because its a binary variant, the conversion works
	 	;ConsoleWrite("Offset to Windows PE Header="&$iOffset&@CRLF)

		$iExit = -3
;~ 	Move to Windows PE Header Offset
		If Not FileSetPos($hFile, $iOffset, 0) Then ExitLoop

		$iExit = -2
;~ 	Read in IMAGE_FILE_HEADER + Magic Number
		$bBuffer = FileRead($hFile, 26)
		If @error Then ExitLoop

		$iExit = 3
		; "PE/0/0" in hex (endian swapped)
		If BinaryMid($bBuffer, 1, 4) <> 0x00004550 Then ExitLoop

		; Get NumberOfSections (need to use endian conversion)
		DllStructSetData($stEndian, 1, BinaryMid($bBuffer, 6 + 1, 2))
		$nSections = DllStructGetData($stEndian, 1)
		; Sanity check
		If $nSections * 40 > $nFileSize Then ExitLoop
;~ 		ConsoleWrite("# of Sections: " & $nSections & @CRLF)

		$bBuffer = BinaryMid($bBuffer, 24 + 1, 2)

		; Magic Number check (0x10B = PE32, 0x107 = ROM image, 0x20B = PE32+ (x64)
		If $bBuffer = 0x10B Then
			; Adjust offset to where "NumberOfRvaAndSizes" is on PE32 (offset from IMAGE_FILE_HEADER)
			$iOffset += 116
		ElseIf $bBuffer = 0x20B Then
			; Adjust offset to where "NumberOfRvaAndSizes" is on PE32+ (offset from IMAGE_FILE_HEADER)
			$iOffset += 132
		Else
			$iExit = 4
			SetError(Number($bBuffer))		; Set the error (picked up below and set in @extended) to the unrecognized Number found
			ExitLoop
		EndIf

;~ 	'Optional' Header Windows-Specific fields

		$iExit = -3
;~ 	-> Move to "NumberOfRvaAndSizes" at the end of IMAGE_OPTIONAL_HEADER
		If Not FileSetPos($hFile, $iOffset, 0) Then ExitLoop

		$iExit = -2
;~ 	Read in NumberOfRvaAndSizes
		$nDataDirectories = Number(FileRead($hFile, 4))
		; Sanity and error check
		If $nDataDirectories <= 0 Or $nDataDirectories > 16 Then ExitLoop

;~ 		ConsoleWrite("# of IMAGE_DATA_DIRECTORY's: " & $nDataDirectories & @CRLF)

;~ 	Read in IMAGE_DATA_DIRECTORY's (also moves file position to IMAGE_SECTION_HEADER)
		$bBuffer = FileRead($hFile, $nDataDirectories * 8)
		If @error Then ExitLoop

;~ 	IMAGE_DIRECTORY_ENTRY_SECURITY entry is special - it's "VirtualAddress" is actually a file offset
		If $nDataDirectories >= 5 Then
			DllStructSetData($stEndian, 1, BinaryMid($bBuffer, 4 * 8 + 1, 4))
			$iCertificateAddress = DllStructGetData($stEndian, 1)
			DllStructSetData($stEndian, 1, BinaryMid($bBuffer, 4 * 8 + 4 + 1, 4))
			$nCertificateSz = DllStructGetData($stEndian, 1)
			If $iCertificateAddress Then ConsoleWrite("Certificate Table address found, offset = " & $iCertificateAddress & ", size = " & $nCertificateSz & @CRLF)
		EndIf

		; Read in ALL sections
		$bBuffer = FileRead($hFile, $nSections * 40)
		If @error Then ExitLoop

;~ 	DONE Reading File info..

		; Now to traverse the sections..

		; $iOffset Now refers to the location within the binary data
		$iOffset = 1
		$nLastSectionOffset = 0
		$nLastSectionSz = 0
		For $i = 1 To $nSections
			; Within IMAGE_SECTION_HEADER: RawDataPtr = offset 20, SizeOfRawData = offset 16
			DllStructSetData($stEndian, 1, BinaryMid($bBuffer, $iOffset + 20, 4))
			$nTemp = DllStructGetData($stEndian, 1)
			;ConsoleWrite("RawDataPtr, iteration #"&$i&" = " & $nTemp & @CRLF)
			; Is it further than last section offset?
			;  AND - check here for rare situation where section Offset may be outside Filesize bounds
			If $nTemp > $nLastSectionOffset And $nTemp < $nFileSize Then
				$nLastSectionOffset = $nTemp
				DllStructSetData($stEndian, 1, BinaryMid($bBuffer, $iOffset + 16, 4))
				$nLastSectionSz = DllStructGetData($stEndian, 1)
			EndIf
			; Next IMAGE_SECTION_HEADER
			$iOffset += 40
		Next
;~ 		ConsoleWrite("$nLastSectionOffset = " & $nLastSectionOffset & ", $nLastSectionSz = " & $nLastSectionSz & @CRLF)

		$iSucces = 1	; Everything was read in correctly
	Until 1
	$iErr = @error
	FileClose($hFile)
	; No Success?
	If Not $iSucces Then Return SetError($iExit, $iErr, $aRet)

;~ 	Now to calculate the last section offset and size to get the 'real' Executable end-of-file
	; [0] = Overlay Start
	$aRet[0] = $nLastSectionOffset + $nLastSectionSz

	; Less than FileSize means there's Overlay info
	If $aRet[0] And $aRet[0] < $nFileSize Then
		; Certificate start after last section? It should
		If $iCertificateAddress >= $aRet[0]  Then
			; Get size of overlay IF Certificate doesn't start right after last section
			; 'squeezed-in overlay'
			$aRet[1] = $iCertificateAddress - $aRet[0]
		Else
			; No certificate, or < last section - overlay will be end of last section -> end of file
			$aRet[1] = $nFileSize - $aRet[0]
		EndIf
		; Size of Overlay = 0 ?  Reset overlay start to 0
		If Not $aRet[1] Then $aRet[0] = 0
	EndIf
	$aRet[2] = $iCertificateAddress
	$aRet[3] = $nCertificateSz
	$aRet[4] = $nFileSize
	Return $aRet
EndFunc

