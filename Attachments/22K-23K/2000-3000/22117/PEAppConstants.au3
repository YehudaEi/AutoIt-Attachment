#cs
	TITLE: Win/PE Application Constants
	AUTHOR: Crash Daemonicus
	VERSION: 1.1
	INFORMATION:
		Retrieves Information on Windows PE (Windows NT) Applications
		(Will get data on regular MZ applications, but not alot)
	CREDIT:
		Iczelion's PE Tutorials
			http://win32assembly.online.fr/pe-tut1.html
			...
			http://win32assembly.online.fr/pe-tut6.html
#ce


;Signature values (both DOS and PE/COFF)
Global Const $IMAGE_DOS_SIGNATURE=0x5A4D; 		Mark Zbikowski rulez! ;P
Global Const $IMAGE_OS2_SIGNATURE=0x454E; 		- Not Used
Global Const $IMAGE_OS2_SIGNATURE_LE=0x454C; 	- Not Supported
Global Const $IMAGE_VXD_SIGNATURE=0x454C; 		- Don't Care
Global Const $IMAGE_NT_SIGNATURE=0x4550; 		Portable Executable baibei!
;File{Machine} values
Global Const $IMAGE_FILE_MACHINE_I386=0x014c
Global Const $IMAGE_FILE_MACHINE_IA64=0x0200
Global Const $IMAGE_FILE_MACHINE_AMD64=0x8664
;File{Characteristics} values - http://msdn.microsoft.com/en-us/library/ms680313(VS.85).aspx
Global Const $IMAGE_FILE_RELOCS_STRIPPED=0x0001
Global Const $IMAGE_FILE_EXECUTABLE_IMAGE=0x0002
Global Const $IMAGE_FILE_LINE_NUMS_STRIPPED=0x0004
Global Const $IMAGE_FILE_LOCAL_SYMS_STRIPPED=0x0008
Global Const $IMAGE_FILE_AGGRESIVE_WS_TRIM=0x0010
Global Const $IMAGE_FILE_LARGE_ADDRESS_AWARE=0x0020
Global Const $IMAGE_FILE_BYTES_REVERSED_LO=0x0080
Global Const $IMAGE_FILE_32BIT_MACHINE=0x0100
Global Const $IMAGE_FILE_DEBUG_STRIPPED=0x0200
Global Const $IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP=0x0400
Global Const $IMAGE_FILE_NET_RUN_FROM_SWAP=0x0800
Global Const $IMAGE_FILE_SYSTEM=0x1000
Global Const $IMAGE_FILE_DLL=0x2000
Global Const $IMAGE_FILE_UP_SYSTEM_ONLY=0x4000
Global Const $IMAGE_FILE_BYTES_REVERSED_HI=0x8000
;Section{Characteristics} values - http://msdn.microsoft.com/en-us/library/ms680341(VS.85).aspx
Global Const $IMAGE_SCN_TYPE_NO_PAD=0x00000008
Global Const $IMAGE_SCN_CNT_CODE=0x00000020
Global Const $IMAGE_SCN_CNT_INITIALIZED_DATA=0x00000040
Global Const $IMAGE_SCN_CNT_UNINITIALIZED_DATA=0x00000080
Global Const $IMAGE_SCN_LNK_OTHER=0x00000100
Global Const $IMAGE_SCN_LNK_INFO=0x00000200
Global Const $IMAGE_SCN_LNK_REMOVE=0x00000800
Global Const $IMAGE_SCN_LNK_COMDAT=0x00001000
Global Const $IMAGE_SCN_NO_DEFER_SPEC_EXC=0x00004000
Global Const $IMAGE_SCN_GPREL=0x00008000
Global Const $IMAGE_SCN_MEM_PURGEABLE=0x00020000
Global Const $IMAGE_SCN_MEM_LOCKED=0x00040000
Global Const $IMAGE_SCN_MEM_PRELOAD=0x00080000
Global Const $IMAGE_SCN_ALIGN_1BYTES=0x00100000
Global Const $IMAGE_SCN_ALIGN_2BYTES=0x00200000
Global Const $IMAGE_SCN_ALIGN_4BYTES=0x00300000
Global Const $IMAGE_SCN_ALIGN_8BYTES=0x00400000
Global Const $IMAGE_SCN_ALIGN_16BYTES=0x00500000
Global Const $IMAGE_SCN_ALIGN_32BYTES=0x00600000
Global Const $IMAGE_SCN_ALIGN_64BYTES=0x00700000
Global Const $IMAGE_SCN_ALIGN_128BYTES=0x00800000
Global Const $IMAGE_SCN_ALIGN_256BYTES=0x00900000
Global Const $IMAGE_SCN_ALIGN_512BYTES=0x00A00000
Global Const $IMAGE_SCN_ALIGN_1024BYTES=0x00B00000
Global Const $IMAGE_SCN_ALIGN_2048BYTES=0x00C00000
Global Const $IMAGE_SCN_ALIGN_4096BYTES=0x00D00000
Global Const $IMAGE_SCN_ALIGN_8192BYTES=0x00E00000
Global Const $IMAGE_SCN_LNK_NRELOC_OVFL=0x01000000
Global Const $IMAGE_SCN_MEM_DISCARDABLE=0x02000000
Global Const $IMAGE_SCN_MEM_NOT_CACHED=0x04000000
Global Const $IMAGE_SCN_MEM_NOT_PAGED=0x08000000
Global Const $IMAGE_SCN_MEM_SHARED=0x10000000
Global Const $IMAGE_SCN_MEM_EXECUTE=0x20000000
Global Const $IMAGE_SCN_MEM_READ=0x40000000
Global Const $IMAGE_SCN_MEM_WRITE=0x80000000
;Optional{Magic} values - http://msdn.microsoft.com/en-us/library/ms680339(VS.85).aspx
Global Const $IMAGE_NT_OPTIONAL_HDR32_MAGIC=0x10b
Global Const $IMAGE_NT_OPTIONAL_HDR64_MAGIC=0x20b
Global Const $IMAGE_ROM_OPTIONAL_HDR_MAGIC=0x107
;Optional{Subsystem}
Global Const $IMAGE_SUBSYSTEM_UNKNOWN=0
Global Const $IMAGE_SUBSYSTEM_NATIVE=1
Global Const $IMAGE_SUBSYSTEM_WINDOWS_GUI=2
Global Const $IMAGE_SUBSYSTEM_WINDOWS_CUI=3
Global Const $IMAGE_SUBSYSTEM_OS2_CUI=5
Global Const $IMAGE_SUBSYSTEM_POSIX_CUI=7
Global Const $IMAGE_SUBSYSTEM_WINDOWS_CE_GUI=9
Global Const $IMAGE_SUBSYSTEM_EFI_APPLICATION=10
Global Const $IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER=11
Global Const $IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER=12
Global Const $IMAGE_SUBSYSTEM_EFI_ROM=13
Global Const $IMAGE_SUBSYSTEM_XBOX=14
Global Const $IMAGE_SUBSYSTEM_WINDOWS_BOOT_APPLICATION=16


;Data Structures
Global Const $tagIMAGE_DOS_HEADER='ushort e_magic; ushort LastPageBytes; ushort PagesInFile; ushort Relocs; ushort HeaderSizep; ushort e_minalloc; ushort e_maxalloc; ushort e_ss; ushort e_sp; ushort Checksum; ushort e_ip; ushort e_cs; ushort RelocTableOffset; ushort Overlay; ushort ReservedWords[4]; ushort e_oemid; ushort e_oeminfo; ushort ReservedWords[10]; long CoffHeaderOffset'
Global Const $tagIMAGE_NT_HEADER='ULONG Signature'
Global Const $tagIMAGE_FILE_HEADER='USHORT Machine;USHORT NumberOfSections;ULONG TimeDateStamp;ULONG PointerToSymbolTable;ULONG NumberOfSymbols;USHORT SizeOfOptionalHeader;USHORT Characteristics'
Global Const $tagIMAGE_OPTIONAL_HEADER='USHORT Magic;CHAR MajorLinkerVersion;CHAR MinorLinkerVersion;ULONG SizeOfCode;ULONG SizeOfInitializedData;ULONG SizeOfUninitializedData;ULONG AddressOfEntryPoint;ULONG BaseOfCode;ULONG BaseOfData;ULONG ImageBase;ULONG SectionAlignment;ULONG FileAlignment;USHORT MajorOperatingSystemVersion;USHORT MinorOperatingSystemVersion;USHORT MajorImageVersion;USHORT MinorImageVersion;USHORT MajorSubsystemVersion;USHORT MinorSubsystemVersion;ULONG Win32VersionValue;ULONG SizeOfImage;ULONG SizeOfHeaders;ULONG CheckSum;USHORT Subsystem;USHORT DllCharacteristics;ULONG SizeOfStackReserve;ULONG SizeOfStackCommit;ULONG SizeOfHeapReserve;ULONG SizeOfHeapCommit;ULONG LoaderFlags;ULONG NumberOfRvaAndSizes'
Global Const $tagIMAGE_DATA_DIRECTORY='ulong VirtualAddress; ulong Size'
Global Const $tagIMAGE_SECTION_HEADER='CHAR Name[8];ULONG VirtualSize;ULONG VirtualAddress;ULONG SizeOfRawData;ULONG PointerToRawData;ULONG PointerToRelocations;ULONG PointerToLinenumbers;USHORT NumberOfRelocations;USHORT NumberOfLinenumbers;ULONG Characteristics'
Global Const $tagIMAGE_DEBUG_DIRECTORY='ULONG Characteristics; ULONG TimeDateStamp; USHORT MajorVersion; USHORT MinorVersion;ULONG Type; ULONG SizeOfData; ULONG AddressOfRawData; ULONG PointerToRawData'
Global Const $tagIMAGE_IMPORT_DESCRIPTOR='DWORD OriginalFirstThunk;DWORD TimeDateStamp;dword ForwarderChain;dword Name;dword FirstThunk'
Global Const $tagIMAGE_THUNK_DATA='dword pointer'
Global Const $tagIMAGE_IMPORT_BY_NAME='ushort Hint;BYTE Name[*]';   <----- this is NOT compatible with DLLStructCreate, heh ;D
Global Const $tagIMAGE_EXPORT_DIRECTORY='dword Characteristics;dword TimeDateStamp;ushort MajorVersion;ushort MinorVersion;dword nName;dword nBase;dword NumberOfFunctions;dword NumberOfNames;dword AddressOfFunctions;dword AddressOfNames;dword AddressOfNameOrdinals';





