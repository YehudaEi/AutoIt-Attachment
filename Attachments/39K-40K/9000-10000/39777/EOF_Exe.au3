#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPI.au3>

Local $CertOf_ntdll_dll = READEOF(@SystemDir & "\dpinst.exe")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $CertOf_ntdll_dll = ' & $CertOf_ntdll_dll & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

Func READEOF($sModule)
	;
	; ==== Load Get Module Base ===
	;
	Local $iLoaded
	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "GetModuleHandleW", "wstr", $sModule)
	If @error Then
		Return SetError(1, 0, "")
  EndIf

	; LOAD_LIBRARY_AS_DATAFILE 0x00000002
	;If this value is used, the system maps the file into the calling process's virtual address space as if it were a data file. Nothing is done to execute or prepare to execute the mapped file.
	;
	;LOAD_LIBRARY_AS_IMAGE_RESOURCE 0x00000020 (supported since Vista)
	;the loader does not load the static imports or perform the other usual initialization steps.
	;The article says that LOAD_LIBRARY_AS_IMAGE_RESOURCE is not supported on Windows 2003/Windows XP. The weird thing is that "not supported" means something different on Windows XP (the flag is ignored; proper handle is returned) than on Windows 2003 (zero handle is returned).
	Global $pPointer = $a_hCall[0]
	If Not $a_hCall[0] Then
		$a_hCall = DllCall("kernel32.dll", _
				"hwnd", "LoadLibraryExW", _
				"wstr", $sModule, _
				"hwnd", 0, _
				"int", 0x02)
		If @error Or Not $a_hCall[0] Then
			Return SetError(2, 0, "")
		EndIf
		$iLoaded = 1
		$pPointer = BitAND($a_hCall[0], 0xFFFF0000) ; Align to 0x10000
	EndIf
	$pPointer = Ptr($pPointer)

   ;Well beside LoadLibraryExW consider the use of 'FileMapping' like this:
   ; $pPointer= MapFile($sModule)
   ; ^^... so we've also have already the overlay in mem.

	;
	; ==== MZ-Header ===
	;
	Local $hModule = $a_hCall[0] ;Note that $hModule can be something like 0x01C40001 !
	Local $tIMAGE_DOS_HEADER = DllStructCreate( _
			"char Magic[2];" & _
			"ushort BytesOnLastPage;" & _
			"ushort Pages;" & _
			"ushort Relocations;" & _
			"ushort SizeofHeader;" & _
			"ushort MinimumExtra;" & _
			"ushort MaximumExtra;" & _
			"ushort SS;" & _
			"ushort SP;" & _
			"ushort Checksum;" & _
			"ushort IP;" & _
			"ushort CS;" & _
			"ushort Relocation;" & _
			"ushort Overlay;" & _
			"char Reserved[8];" & _
			"ushort OEMIdentifier;" & _
			"ushort OEMInformation;" & _
			"char Reserved2[20];" & _
			"dword AddressOfNewExeHeader", _
			$pPointer)

	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader")

	;
	; ==== PE-Header ===
	;
	Local $tIMAGE_NT_SIGNATURE = DllStructCreate("dword Signature", $pPointer)
	If Not (DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature") = 0x4550) Then ; "PE"
		If $iLoaded Then
			Local $a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
		EndIf
		Return SetError(3, 0, "")
	EndIf
	$pPointer += DllStructGetSize($tIMAGE_NT_SIGNATURE) ;4

	Local $tIMAGE_FILE_HEADER = DllStructCreate("ushort Machine;" & _
			"ushort NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"ushort SizeOfOptionalHeader;" & _
			"ushort Characteristics", _
			$pPointer)
	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	$pPointer += DllStructGetSize($tIMAGE_FILE_HEADER) ;20

	Local $tIMAGE_OPTIONAL_HEADER = DllStructCreate("ushort Magic;" & _
			"ubyte MajorLinkerVersion;" & _
			"ubyte MinorLinkerVersion;" & _
			"dword SizeOfCode;" & _
			"dword SizeOfInitializedData;" & _
			"dword SizeOfUninitializedData;" & _
			"dword AddressOfEntryPoint;" & _
			"dword BaseOfCode;" & _
			"dword BaseOfData;" & _
			"dword ImageBase;" & _
			"dword SectionAlignment;" & _
			"dword FileAlignment;" & _
			"ushort MajorOperatingSystemVersion;" & _
			"ushort MinorOperatingSystemVersion;" & _
			"ushort MajorImageVersion;" & _
			"ushort MinorImageVersion;" & _
			"ushort MajorSubsystemVersion;" & _
			"ushort MinorSubsystemVersion;" & _
			"dword Win32VersionValue;" & _
			"dword SizeOfImage;" & _
			"dword SizeOfHeaders;" & _
			"dword CheckSum;" & _
			"ushort Subsystem;" & _
			"ushort DllCharacteristics;" & _
			"dword SizeOfStackReserve;" & _
			"dword SizeOfStackCommit;" & _
			"dword SizeOfHeapReserve;" & _
			"dword SizeOfHeapCommit;" & _
			"dword LoaderFlags;" & _
			"dword NumberOfRvaAndSizes", _
			$pPointer)
	$pPointer += DllStructGetSize($tIMAGE_OPTIONAL_HEADER); 96

	;
	; ==== PE-Directory ====
	;
 	Local $tIMAGE_DIRECTORY_ENTRY_EXPORT = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_IMPORT = MakeIMAGE_DIRECTORY_ENTRY()
   Local $tIMAGE_DIRECTORY_ENTRY_RESOURCE = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_EXCEPTION = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_SECURITY = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_BASERELOC = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_DEBUG = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_COPYRIGHT = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_GLOBALPTR = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_TLS = MakeIMAGE_DIRECTORY_ENTRY()
	Local $tIMAGE_DIRECTORY_ENTRY_LOAD_CONFIG = MakeIMAGE_DIRECTORY_ENTRY()
	$pPointer += 8 * 5 ;40

   ;
	; ==== PE-Sections ====
	;
	Local $tIMAGE_SECTION_HEADER
	For $i = 1 To $iNumberOfSections
		$tIMAGE_SECTION_HEADER = DllStructCreate( _
            "char Name[8];" & _
				"dword VirtualSize;" & _  ;  "dword UnionOfData;" ?! *lol* who put that in there?
				"dword VirtualAddress;" & _
				"dword SizeOfRawData;" & _
				"dword PointerToRawData;" & _
				"dword PointerToRelocations;" & _
				"dword PointerToLinenumbers;" & _
				"ushort NumberOfRelocations;" & _
				"ushort NumberOfLinenumbers;" & _
				"dword Characteristics", _
				$pPointer)

      ; Is this the last Section?
		If $i = $iNumberOfSections Then

        ;CalcEOF
			$PointerToRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
			$SizeOfRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")

			$FilePath = $sModule
			$EOF_PE_File = $PointerToRawData + $SizeOfRawData

        ;Get Overlaydata
         const $FileMode_Binary=0x10
         local $hFile= FileOpen($FilePath,$FileMode_Binary)
         If $hFile=0 Then Return SetError(1, @error, 0)

         if FileSetPos($hFile, $EOF_PE_File,$FILE_BEGIN) = false Then _
            Return SetError(2, @error, 0)

         $OverlayData = FileRead($hFile)
         FileClose($hFile)

     Else
       ;Seek to next Section header
        $pPointer += 40

     EndIf

	Next

   DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)

   Return $OverlayData


EndFunc   ;==>READEOF

Func MakeIMAGE_DIRECTORY_ENTRY()
    local $myStruct = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
    $pPointer += 8
    Return ($myStruct)
EndFunc

Func MapFile($Filename)

    const $PAGE_READONLY = 2
    const $FILE_MAP_READ = 4
    $hDll = DllOpen("kernel32.dll")
    If $hDll <> -1 Then
      $hFile = DllCall($hDll, "hwnd", "CreateFile", _
       "str", $Filename, _
       "dword", $GENERIC_READ, _
       "dword", $FILE_SHARE_READ, _
       "dword", "", _
       "dword", $OPEN_EXISTING, _
       "dword", $FILE_ATTRIBUTE_NORMAL, _
       "hwnd", 0)

      If Not @error Then
       $hFile = $hFile[0]
       ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hFile = ' & $hFile & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

       $hFileMapping = DllCall($hDll, "hwnd", "CreateFileMapping", _
         "hwnd", $hFile, _
         "dword", "", _
         "dword", $PAGE_READONLY, _
         "dword", 0, _
         "dword", 0, _
         "str", "")
        $hFileMapping=$hFileMapping[0]
        ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hFileMapping = ' & $hFileMapping & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

       If Not @error Then
         $pBaseAddress = DllCall($hDll, "hwnd", "MapViewOfFile", _
          "hwnd", $hFileMapping, _
          "dword", $FILE_MAP_READ, _
          "dword", 0, _
          "dword", 0, _
          "uint", 0)
         If Not @error Then
          $pBaseAddress = $pBaseAddress[0]
         Else
          MsgBox(16, "Error", "Error retreaving base address.")
         EndIf
       Else
         MsgBox(16, "Error", "Error creating file mapping.")
       EndIf
      Else
       MsgBox(16, "Error", "Error retreaving file.")
      EndIf
      DllClose($hDll)
    Else
      MsgBox(16, "Error", "Error opening Dll")
    EndIf

    Return ($pBaseAddress)
EndFunc

