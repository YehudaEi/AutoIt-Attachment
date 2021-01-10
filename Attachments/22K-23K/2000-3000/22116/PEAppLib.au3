#cs
	TITLE: Win/PE Application Data Library
	AUTHOR: Crash Daemonicus
	VERSION: 3.3
		(Upgraded Replacement for my "Application Headers.au3")
	INFORMATION:
		Retrieves Information on Windows PE (Windows NT) Applications
		(Will get data on regular MZ applications, but not alot)
	NOTES:
		You MUST define the following function in your program!
		
		Func _PEAppLib_OnStatusChange($NewStatusText)
			...
		EndFunc
		
		PS: for the sake of "PseudoTagStruct" and possible DLLStructCreate compatibility,
     		use USHORT or BYTE[2] in place of WORD, etc.
	CREDIT:
		Iczelion's PE Tutorials
			http://win32assembly.online.fr/pe-tut1.html
			...
			http://win32assembly.online.fr/pe-tut6.html
			MSDN
#ce





Global Const $DataTypeSizes=StringSplit('byte,ubyte,char,wchar,short,ushort,int,uint,long,ulong,dword,ptr,hwnd,float,double,int64,uint64,int_ptr,uint_ptr,long_ptr,ulong_ptr',',')
;^---------------this last Constant here is just for the PseudoTagStruct() function so it can get data field lengths
Global Const $DataDirNames=StringSplit('Export|Import|Resource|Exception|Security|Base Relocation|Debug|Copyright|Global Ptr|Thread Local Storage|Load Configuration','|')
Global $PSOldPos=0
Global $_Data_Cache=''
Global $PseudoTagStruct_DESCR=PseudoTagStruct($tagIMAGE_IMPORT_DESCRIPTOR)
Global $PseudoTagStruct_IMPOR=PseudoTagStruct($tagIMAGE_IMPORT_BY_NAME)

Global $IMAGE_Signatures[5][2]
$IMAGE_Signatures[0][0]=$IMAGE_DOS_SIGNATURE
$IMAGE_Signatures[1][0]=$IMAGE_OS2_SIGNATURE
$IMAGE_Signatures[2][0]=$IMAGE_OS2_SIGNATURE_LE
$IMAGE_Signatures[3][0]=$IMAGE_VXD_SIGNATURE
$IMAGE_Signatures[4][0]=$IMAGE_NT_SIGNATURE
$IMAGE_Signatures[0][1]='MS-DOS/Windows'
$IMAGE_Signatures[1][1]='OS/2'
$IMAGE_Signatures[2][1]='OS/2 LE'
$IMAGE_Signatures[3][1]='VXD'
$IMAGE_Signatures[4][1]='Portable Exectuable/WinNT'

Global $IMAGE_FILE_Machines[3][2]
$IMAGE_FILE_Machines[0][0]=$IMAGE_FILE_MACHINE_I386
$IMAGE_FILE_Machines[1][0]=$IMAGE_FILE_MACHINE_IA64
$IMAGE_FILE_Machines[2][0]=$IMAGE_FILE_MACHINE_AMD64
$IMAGE_FILE_Machines[0][1]='x86/I386'
$IMAGE_FILE_Machines[1][1]='Intel IPF/IA64'
$IMAGE_FILE_Machines[2][1]='x64/AMD64'

Global $IMAGE_FILE_Characteristics[15][2]
$IMAGE_FILE_Characteristics[00][0]=$IMAGE_FILE_RELOCS_STRIPPED
$IMAGE_FILE_Characteristics[01][0]=$IMAGE_FILE_EXECUTABLE_IMAGE
$IMAGE_FILE_Characteristics[02][0]=$IMAGE_FILE_LINE_NUMS_STRIPPED
$IMAGE_FILE_Characteristics[03][0]=$IMAGE_FILE_LOCAL_SYMS_STRIPPED
$IMAGE_FILE_Characteristics[04][0]=$IMAGE_FILE_AGGRESIVE_WS_TRIM
$IMAGE_FILE_Characteristics[05][0]=$IMAGE_FILE_LARGE_ADDRESS_AWARE
$IMAGE_FILE_Characteristics[06][0]=$IMAGE_FILE_BYTES_REVERSED_LO
$IMAGE_FILE_Characteristics[07][0]=$IMAGE_FILE_32BIT_MACHINE
$IMAGE_FILE_Characteristics[08][0]=$IMAGE_FILE_DEBUG_STRIPPED
$IMAGE_FILE_Characteristics[09][0]=$IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP
$IMAGE_FILE_Characteristics[10][0]=$IMAGE_FILE_NET_RUN_FROM_SWAP
$IMAGE_FILE_Characteristics[11][0]=$IMAGE_FILE_SYSTEM
$IMAGE_FILE_Characteristics[12][0]=$IMAGE_FILE_DLL
$IMAGE_FILE_Characteristics[13][0]=$IMAGE_FILE_UP_SYSTEM_ONLY
$IMAGE_FILE_Characteristics[14][0]=$IMAGE_FILE_BYTES_REVERSED_HI
$IMAGE_FILE_Characteristics[00][1]='Relocs Stripped'
$IMAGE_FILE_Characteristics[01][1]='Executable'
$IMAGE_FILE_Characteristics[02][1]='Coff Linenums Stripped'
$IMAGE_FILE_Characteristics[03][1]='Coff Symbols Stripped'
$IMAGE_FILE_Characteristics[04][1]='Aggressively trim working set'
$IMAGE_FILE_Characteristics[05][1]='Addresses can be 2GB+'
$IMAGE_FILE_Characteristics[06][1]='Word Bytes Reversed,Lo'
$IMAGE_FILE_Characteristics[07][1]='Supports 32-bit Words'
$IMAGE_FILE_Characteristics[08][1]='Debug Info Stripped'
$IMAGE_FILE_Characteristics[09][1]='Removable, Run From Swap'
$IMAGE_FILE_Characteristics[10][1]='Network, Run From Swap'
$IMAGE_FILE_Characteristics[11][1]='System File'
$IMAGE_FILE_Characteristics[12][1]='DLL'
$IMAGE_FILE_Characteristics[13][1]='UniProcessors Only'
$IMAGE_FILE_Characteristics[14][1]='Word Bytes Reversed,Hi'


Global $IMAGE_OPTIONAL_Magics[3][2]
$IMAGE_OPTIONAL_Magics[0][0]=$IMAGE_NT_OPTIONAL_HDR32_MAGIC
$IMAGE_OPTIONAL_Magics[1][0]=$IMAGE_NT_OPTIONAL_HDR64_MAGIC
$IMAGE_OPTIONAL_Magics[2][0]=$IMAGE_ROM_OPTIONAL_HDR_MAGIC
$IMAGE_OPTIONAL_Magics[0][1]='32-Bit Executable'
$IMAGE_OPTIONAL_Magics[1][1]='64-Bit Executable'
$IMAGE_OPTIONAL_Magics[2][1]='ROM Image'

Global $IMAGE_OPTIONAL_Subsystems[13][2]
$IMAGE_OPTIONAL_Subsystems[00][0]=$IMAGE_SUBSYSTEM_UNKNOWN
$IMAGE_OPTIONAL_Subsystems[01][0]=$IMAGE_SUBSYSTEM_NATIVE
$IMAGE_OPTIONAL_Subsystems[02][0]=$IMAGE_SUBSYSTEM_WINDOWS_GUI
$IMAGE_OPTIONAL_Subsystems[03][0]=$IMAGE_SUBSYSTEM_WINDOWS_CUI
$IMAGE_OPTIONAL_Subsystems[04][0]=$IMAGE_SUBSYSTEM_OS2_CUI
$IMAGE_OPTIONAL_Subsystems[05][0]=$IMAGE_SUBSYSTEM_POSIX_CUI
$IMAGE_OPTIONAL_Subsystems[06][0]=$IMAGE_SUBSYSTEM_WINDOWS_CE_GUI
$IMAGE_OPTIONAL_Subsystems[07][0]=$IMAGE_SUBSYSTEM_EFI_APPLICATION
$IMAGE_OPTIONAL_Subsystems[08][0]=$IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER
$IMAGE_OPTIONAL_Subsystems[09][0]=$IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER
$IMAGE_OPTIONAL_Subsystems[10][0]=$IMAGE_SUBSYSTEM_EFI_ROM
$IMAGE_OPTIONAL_Subsystems[11][0]=$IMAGE_SUBSYSTEM_XBOX
$IMAGE_OPTIONAL_Subsystems[12][0]=$IMAGE_SUBSYSTEM_WINDOWS_BOOT_APPLICATION
$IMAGE_OPTIONAL_Subsystems[00][1]='Unknown'
$IMAGE_OPTIONAL_Subsystems[01][1]='N/A - Native'
$IMAGE_OPTIONAL_Subsystems[02][1]='Windows GUI'
$IMAGE_OPTIONAL_Subsystems[03][1]='Windows CUI'
$IMAGE_OPTIONAL_Subsystems[04][1]='OS/2 CUI'
$IMAGE_OPTIONAL_Subsystems[05][1]='POSIX CUI'
$IMAGE_OPTIONAL_Subsystems[06][1]='Windows CE GUI'
$IMAGE_OPTIONAL_Subsystems[07][1]='EFI Application'
$IMAGE_OPTIONAL_Subsystems[08][1]='EFI Driver + Boot Services'
$IMAGE_OPTIONAL_Subsystems[09][1]='EFI Driver + RunTime Services'
$IMAGE_OPTIONAL_Subsystems[10][1]='EFI ROM Image'
$IMAGE_OPTIONAL_Subsystems[11][1]='Xbox'
$IMAGE_OPTIONAL_Subsystems[12][1]='Boot Application'

Global $IMAGE_SCN_Characteristics[35][2]
$IMAGE_SCN_Characteristics[00][0]=$IMAGE_SCN_TYPE_NO_PAD
$IMAGE_SCN_Characteristics[01][0]=$IMAGE_SCN_CNT_CODE
$IMAGE_SCN_Characteristics[02][0]=$IMAGE_SCN_CNT_INITIALIZED_DATA
$IMAGE_SCN_Characteristics[03][0]=$IMAGE_SCN_CNT_UNINITIALIZED_DATA
$IMAGE_SCN_Characteristics[04][0]=$IMAGE_SCN_LNK_OTHER
$IMAGE_SCN_Characteristics[05][0]=$IMAGE_SCN_LNK_INFO
$IMAGE_SCN_Characteristics[06][0]=$IMAGE_SCN_LNK_REMOVE
$IMAGE_SCN_Characteristics[07][0]=$IMAGE_SCN_LNK_COMDAT
$IMAGE_SCN_Characteristics[08][0]=$IMAGE_SCN_NO_DEFER_SPEC_EXC
$IMAGE_SCN_Characteristics[09][0]=$IMAGE_SCN_GPREL
$IMAGE_SCN_Characteristics[10][0]=$IMAGE_SCN_MEM_PURGEABLE
$IMAGE_SCN_Characteristics[11][0]=$IMAGE_SCN_MEM_LOCKED
$IMAGE_SCN_Characteristics[12][0]=$IMAGE_SCN_MEM_PRELOAD
$IMAGE_SCN_Characteristics[13][0]=$IMAGE_SCN_ALIGN_1BYTES
$IMAGE_SCN_Characteristics[14][0]=$IMAGE_SCN_ALIGN_2BYTES
$IMAGE_SCN_Characteristics[15][0]=$IMAGE_SCN_ALIGN_4BYTES
$IMAGE_SCN_Characteristics[16][0]=$IMAGE_SCN_ALIGN_8BYTES
$IMAGE_SCN_Characteristics[17][0]=$IMAGE_SCN_ALIGN_16BYTES
$IMAGE_SCN_Characteristics[18][0]=$IMAGE_SCN_ALIGN_32BYTES
$IMAGE_SCN_Characteristics[19][0]=$IMAGE_SCN_ALIGN_64BYTES
$IMAGE_SCN_Characteristics[20][0]=$IMAGE_SCN_ALIGN_128BYTES
$IMAGE_SCN_Characteristics[21][0]=$IMAGE_SCN_ALIGN_256BYTES
$IMAGE_SCN_Characteristics[22][0]=$IMAGE_SCN_ALIGN_512BYTES
$IMAGE_SCN_Characteristics[23][0]=$IMAGE_SCN_ALIGN_1024BYTES
$IMAGE_SCN_Characteristics[24][0]=$IMAGE_SCN_ALIGN_2048BYTES
$IMAGE_SCN_Characteristics[25][0]=$IMAGE_SCN_ALIGN_4096BYTES
$IMAGE_SCN_Characteristics[26][0]=$IMAGE_SCN_ALIGN_8192BYTES
$IMAGE_SCN_Characteristics[27][0]=$IMAGE_SCN_LNK_NRELOC_OVFL
$IMAGE_SCN_Characteristics[28][0]=$IMAGE_SCN_MEM_DISCARDABLE
$IMAGE_SCN_Characteristics[29][0]=$IMAGE_SCN_MEM_NOT_CACHED
$IMAGE_SCN_Characteristics[30][0]=$IMAGE_SCN_MEM_NOT_PAGED
$IMAGE_SCN_Characteristics[31][0]=$IMAGE_SCN_MEM_SHARED
$IMAGE_SCN_Characteristics[32][0]=$IMAGE_SCN_MEM_EXECUTE
$IMAGE_SCN_Characteristics[33][0]=$IMAGE_SCN_MEM_READ
$IMAGE_SCN_Characteristics[34][0]=$IMAGE_SCN_MEM_WRITE
$IMAGE_SCN_Characteristics[00][1]='Not Padded'
$IMAGE_SCN_Characteristics[01][1]='Exec. Code'
$IMAGE_SCN_Characteristics[02][1]='Initialized'
$IMAGE_SCN_Characteristics[03][1]='Uninitialized'
$IMAGE_SCN_Characteristics[04][1]='LNK_OTHER'; reserved?
$IMAGE_SCN_Characteristics[05][1]='Comments&Etc.'
$IMAGE_SCN_Characteristics[06][1]='Not an Image Part'
$IMAGE_SCN_Characteristics[07][1]='COMDAT'
$IMAGE_SCN_Characteristics[08][1]='Reset Speculative Bits'
$IMAGE_SCN_Characteristics[09][1]='Referenced by Global Pointer'
$IMAGE_SCN_Characteristics[10][1]='MEM_PURGEABLE'
$IMAGE_SCN_Characteristics[11][1]='MEM_LOCKED'
$IMAGE_SCN_Characteristics[12][1]='MEM_PRELOAD'
$IMAGE_SCN_Characteristics[13][1]='Aligned 1-Byte Boundary'
$IMAGE_SCN_Characteristics[14][1]='Aligned 2-Byte Boundary'
$IMAGE_SCN_Characteristics[15][1]='Aligned 4-Byte Boundary'
$IMAGE_SCN_Characteristics[16][1]='Aligned 8-Byte Boundary'
$IMAGE_SCN_Characteristics[17][1]='Aligned 16-Byte Boundary'
$IMAGE_SCN_Characteristics[18][1]='Aligned 32-Byte Boundary'
$IMAGE_SCN_Characteristics[19][1]='Aligned 64-Byte Boundary'
$IMAGE_SCN_Characteristics[20][1]='Aligned 128-Byte Boundary'
$IMAGE_SCN_Characteristics[21][1]='Aligned 256-Byte Boundary'
$IMAGE_SCN_Characteristics[22][1]='Aligned 512-Byte Boundary'
$IMAGE_SCN_Characteristics[23][1]='Aligned 1024-Byte Boundary'
$IMAGE_SCN_Characteristics[24][1]='Aligned 2048-Byte Boundary'
$IMAGE_SCN_Characteristics[25][1]='Aligned 4096-Byte Boundary'
$IMAGE_SCN_Characteristics[26][1]='Aligned 8192-Byte Boundary'
$IMAGE_SCN_Characteristics[27][1]='Extended Relocs'
$IMAGE_SCN_Characteristics[28][1]='Discardable'
$IMAGE_SCN_Characteristics[29][1]='Not Cached'
$IMAGE_SCN_Characteristics[30][1]='Not Paged'
$IMAGE_SCN_Characteristics[31][1]='Shared'
$IMAGE_SCN_Characteristics[32][1]='Executable'
$IMAGE_SCN_Characteristics[33][1]='Readable'
$IMAGE_SCN_Characteristics[34][1]='Writeable'






Func _PEAppLib_ConstNameFromVal($Const_Array,$Val)
	Local $Last=UBound($Const_Array)-1
	For $i=0 To $Last
		If $Val==$Const_Array[$i][0] Then Return $Const_Array[$i][1]
	Next
	Return ""
EndFunc
Func _PEAppLib_ConstNamesFromVal($Const_Array,$Val)
	Local $Last=UBound($Const_Array)-1
	Local $Const_Val
	Local $Const_Names=""
	Local $Consts=0
	For $i=0 To $Last
		$Const_Val=$Const_Array[$i][0]
		If BitAND($Val, $Const_Val) = $Const_Val Then
			If $Consts>0 Then $Const_Names&="; "
			$Consts+=1
			$Const_Names&=$Const_Array[$i][1]
		EndIf
	Next
	Return $Const_Names
EndFunc


Func _LoadExecutableInfo($data)
	Global $_Pseudo_HexArray=True
	_Data_ClearCache($data)
	Local $maxchr=StringLen($data)-1
	Local $FileInfo[8]
	_PEAppLib_OnStatusChange('Loading DOS Headers...')
	$hdos=PseudoStruct(PseudoTagStruct($tagIMAGE_DOS_HEADER),$data)
	$FileInfo[0]=$hdos
	$e_magic=Dec($hdos[0])
	If $e_magic<>$IMAGE_DOS_SIGNATURE Then
		SetError(1,$e_magic)
		Return ''
	EndIf
	$e_lfanew=Dec($hdos[18])
	If $e_lfanew<$PSOldPos Or $e_lfanew>$maxchr Then
		SetError(2,$e_lfanew)
		Return $FileInfo
	EndIf
	_PEAppLib_OnStatusChange('Loading NT Headers...')
	$hnt=PseudoStruct(PseudoTagStruct($tagIMAGE_NT_HEADER),$data,$e_lfanew)
	$FileInfo[1]=$hnt
	$en_magic=Dec($hnt[0])
	If $en_magic<>$IMAGE_NT_SIGNATURE Then
		SetError(3,$en_magic)
		Return $FileInfo
	EndIf

	_PEAppLib_OnStatusChange('Loading FILE Headers...')
	$hfile=PseudoStruct(PseudoTagStruct($tagIMAGE_FILE_HEADER),$data,$PSOldPos)
	$FileInfo[2]=$hfile
		;$Machine=$hfile[0]
		$NumberOfSections=Dec($hfile[1])
		;$Characteristics=$hfile[6]
	_PEAppLib_OnStatusChange('Loading OPTIONAL Headers...')
	$hopti=PseudoStruct(PseudoTagStruct($tagIMAGE_OPTIONAL_HEADER),$data,$PSOldPos)
	$FileInfo[3]=$hopti
		;$AddressOfEntryPoint=Dec($hopti[6])
		;$SizeOfHeaders=Dec($hopti[20])
	_PEAppLib_OnStatusChange('Loading Data Directories...')
	Local $DataDirectories[16]
	For $i=1 To 16
		$DataDir=PseudoStruct(PseudoTagStruct($tagIMAGE_DATA_DIRECTORY),$data,$PSOldPos)
		$DataDirectories[$i-1]=$DataDir
	Next
	$FileInfo[4]=$DataDirectories
	_PEAppLib_OnStatusChange('Loading Section Headers...')
	ConsoleWrite('Sect '&$NumberOfSections&@CRLF)
	Local $Sections[$NumberOfSections]
	For $i=1 To $NumberOfSections
		$Section=PseudoStruct(PseudoTagStruct($tagIMAGE_SECTION_HEADER),$data,$PSOldPos)
			;$VirtualAddress=Dec($Section[2])
			;$SizeOfRawData=Dec($Section[3])
			;$PointerToRawData=Dec($Section[4])
			;$SCharacteristics=Dec($Section[9])
			;$SectionData=StringMid($data,$PointerToRawData+1,$SizeOfRawData)
		$Sections[$i-1]=$Section
	Next
	$FileInfo[5]=$Sections
	
	
	
	
	
	
	;;;IMPORTS
	_PEAppLib_OnStatusChange('Loading Imports...')
	$ImportInfo=$DataDirectories[1]
	If Dec($ImportInfo[1]) > 0 Then
	Global $ImportMax=Stringlen($data)
	Global $NextDescriptor=-1
	Local $ImportData=''
	While 1
		$ImportDesc=_DataDirectory_GetDescriptor($data,$ImportInfo,$Sections,$NextDescriptor)
		If IsArray($ImportDesc)=0 Then ExitLoop
		$ImportName=_Descriptor_GetName($data,$ImportDesc,$Sections)
		If StringLen($ImportName)<1 Then ExitLoop
		$ImportData&=$ImportName&','
		Global $NextThunk=-1
		Local $FirstRun=True
		_PEAppLib_OnStatusChange('Loading '&$ImportName&' Imports...')
		For $ii=1 To 50
			$ImportByName=_Descriptor_GetImportByName($data,$ImportDesc,$Sections,$NextThunk)
			If IsArray($ImportByName)=0 Then
				ExitLoop
			EndIf
			If $ImportByName[0]=='00000000' And $ImportByName[1]=='' Then ExitLoop
			$ImportByName[1]=_UnHexEntry($ImportByName[1])
			_PEAppLib_OnStatusChange('Loading '&$ImportName&' Imports... '&$ImportByName[1])
			$ImportData&=$ImportByName[0]&'|'&$ImportByName[1]&','
			$FirstRun=False
		Next
		$ImportData&=Chr(0)
		If $FirstRun=True Then
			ConsoleWrite('>Invalid'&@CRLF)
			ExitLoop
		EndIf
	WEnd
	$FileInfo[6]=$ImportData
	
	EndIf
	
	
	;;EXPORTS
	_PEAppLib_OnStatusChange('Loading Exports...')
	$ExportData=""
	$ExportInfo=$DataDirectories[0]
	If Dec($ExportInfo[1]) > 0 Then
	$_Pseudo_HexArray=True
	$ExportDirectory=PseudoStruct(PseudoTagStruct($tagIMAGE_EXPORT_DIRECTORY),$data,RVA2Offset(Dec($ExportInfo[0]),$Sections))
	$ExportDirectory[04]=RVA2Offset(Dec($ExportDirectory[04]),$Sections)
	$ExportDirectory[08]=RVA2Offset(Dec($ExportDirectory[08]),$Sections)
	$ExportDirectory[09]=RVA2Offset(Dec($ExportDirectory[09]),$Sections)
	$ExportDirectory[10]=RVA2Offset(Dec($ExportDirectory[10]),$Sections)
	$nBase=Dec($ExportDirectory[5])
	$numFuncs=Dec($ExportDirectory[6])
	$numNames=Dec($ExportDirectory[7])
	$ExportFileName=PseudoStruct('*',$data,$ExportDirectory[4])
	$ExportFileName=_UnHexEntry($ExportFileName[0])
	$nul=Chr(0)
	$ExportData=$ExportFileName&$nul
	_PEAppLib_OnStatusChange('Loading '&$ExportFileName&' Exports...')
	For $i=1 To $numNames
		$_Pseudo_HexArray=True
		$Name_Addr=RVA2Offset(Dec(_StringToHex(_StringReverse(_Data_ReadCache($data,$ExportDirectory[9]+1,4)))),$Sections)
		$ExportDirectory[9]+=4
		$ExportName=PseudoStruct('*',$data,$Name_Addr)
		$ExportName=_UnHexEntry($ExportName[0])
		$ExportData&=$nBase&'|'&$ExportName&$nul
		_PEAppLib_OnStatusChange('Loading '&$ExportFileName&' Exports... '&$ExportName)
		$nBase+=1;for the next loop
	Next
	_PEAppLib_OnStatusChange('Loading '&$ExportFileName&' Exports...')
	If $numFuncs>$numNames Then
		For $i=1 To ($NumFuncs-$numNames)
			$ExportData&=$nBase&'|'&$nul
			$nBase+=1
		Next
	EndIf
	$FileInfo[7]=$ExportData
	EndIf
	
	
	_PEAppLib_OnStatusChange('Loading...')
	Return $FileInfo
EndFunc







Func _DataDirectory_GetDescriptor($data,$DataDirectory,$aSections,$pos=-1); - for IMPORT Descriptors only!
	;ConsoleWrite('>GetDesc'&@CRLF)
	Global $PSOldPos, $NextDescriptor
	Global $ImportMax
	If $pos=-1 THen $pos=RVA2Offset(Dec($DataDirectory[0]),$aSections)
	If $pos<1 Or $pos>$ImportMax Then Return ''
	$_Pseudo_HexArray=True
	$Descriptor=PseudoStruct($PseudoTagStruct_DESCR,$data,$pos)
	$NextDescriptor=$PSOldPos
	Return $Descriptor
EndFunc
Func _Descriptor_GetName($data,$Descriptor,$aSections)
	;ConsoleWrite('>GetName'&@CRLF)
	Global $ImportMax
	$pos=RVA2Offset(Dec($Descriptor[3]),$aSections)
	If $pos<1 Or $pos>$ImportMax Then Return ''
	$_Pseudo_HexArray=True
	$NameData=PseudoStruct('*',$data,$pos)
	Return _UnHexEntry($NameData[0])
EndFunc
Func _Descriptor_GetImportByName(ByRef $data,Byref $Descriptor,Byref $aSections,$pos=-1)
	;ConsoleWrite('>GetImport'&@CRLF)
	Global $PSOldPos,$NextThunk,$ImportMax
	Local $Info[2]
	If $pos=-1 Then
		$pos=Dec($Descriptor[0])
		If $pos=0 Then $pos=Dec($Descriptor[4])
		$pos=RVA2Offset($pos,$aSections)
	EndIf
	$_Pseudo_HexArray=True
	Local $ThunkData[1]
	$ThunkData[0]=_StringToHex(_StringReverse(_Data_ReadCache($data,$pos+1,4)))
	$PSOldPos=($pos+1+4)-1
	;ThunkData=PseudoStruct($PseudoTagStruct_THUNK,$data,$pos); using the _Data_ReadCache function directly is faster
	$NextThunk=$PSOldPos
	$pos=Dec($ThunkData[0])
	$pos=RVA2Offset($pos,$aSections)
	$Info[0]=$ThunkData[0]
	$Info[1]=''
	;If $pos=0 Then Return ''
	If $pos<1  Then Return $Info
	$ImportByName=PseudoStruct($PseudoTagStruct_IMPOR,$data,$pos)
	Return $ImportByName
EndFunc



Func RVA2Offset($RVA, Byref $aSections); I think this is right...
	$Max=UBound($aSections)-1
	For $i=0 To $Max
		$Section=$aSections[$i]
		$VirtualAddress=Dec($Section[2])
		$SizeOfRawData=Dec($Section[3])
		$PointerToRawData=Dec($Section[4])
		$SCharacteristics=Dec($Section[9])
		If $i=0 And $RVA<$PointerToRawData Then Return $RVA
		If $RVA>=$VirtualAddress And $RVA<($VirtualAddress+$SizeOfRawData) Then Return ($RVA - $VirtualAddress + $PointerToRawData)
	Next
	Return 0
EndFunc




Func _UnHexEntry($t)
	Return _StringReverse(_HexToString($t))
EndFunc

Func _HexArray(ByRef $a);Simulate LittleEndian Hex strings
	For $i=0 To UBound($a)-1
		$a[$i]=Hex(StringToBinary(_StringReverse($a[$i])),StringLen($a[$i])*2)
	Next
EndFunc
Func PseudoTagStruct($tagStruct);change struct strings into a list of string lengths for elements
	Local $StructFormat=''
	$tagStruct=StringReplace($tagStruct,'; ',';')
	$tagStruct=StringReplace($tagStruct,' ;',';')
	Local $aEle=StringSplit($tagStruct,';')
	Local $iMax=UBound($aEle)-1
	Local $iiMax=UBound($DataTypeSizes)-1
	For $i=1 To $iMax
		Local $aPar=StringSplit($aEle[$i]&' ',' ')
		Local $iLen=0
		Local $sTyp=$aPar[1]
		Local $iMult=_expand($aEle[$i])
		For $ii=1 To $iiMax
			If $sTyp=$DataTypeSizes[$ii] Then
				Switch $ii
					Case 1 To 3
						$iLen=1
					Case 4 To 6
						$iLen=2
					Case 7 To 14
						$iLen=4
					Case 15 To 17
						$iLen=8
					Case 18 To 21
						Switch @ProcessorArch
							Case 'X86'
								$iLen=4
							Case 'X64','IA64'
								$iLen=8
						EndSwitch
				EndSwitch
				ExitLoop
			EndIf
		Next
		If $iMult=='*' Then
			$StructFormat&='*'
		Else
			$StructFormat&=($iLen*Int($iMult))
		EndIf
		If $i<$iMax Then $StructFormat&=';'
	Next
	Return $StructFormat
EndFunc
Func _expand($s)
	$st=$s
	$sta=StringInStr($s,'[')+1
	$end=StringInStr($s,']')
	If $sta<2 Then Return 1
	$lnl=($end-$sta)
	$len=StringMid($s,$sta,$lnl)
	Return $len
EndFunc








Func _TagStruct_GetElementName($tagStruct,$element)
	$tagStruct=StringReplace($tagStruct,'; ',';')
	$tagStruct=StringReplace($tagStruct,' ;',';')
	Local $aEle=StringSplit($tagStruct,';')
	Local $iMax=UBound($aEle)-1
	For $i=1 To $iMax
		If ($i-1)<>$element Then ContinueLoop
		Local $aPar=StringSplit($aEle[$i]&' ',' ')
		Return $aPar[2]
	Next
	Return ''
EndFunc



Func _Data_LoadCache(Byref $data)
	Local $max=_Data_GetCacheKey(StringLen($data),Ceiling(StringLen($data)/1000))
	Global $_Data_Cache[$max+1]
	For $i=1 To $max
		$_Data_Cache[$i]=''
	Next
EndFunc




Func _Data_GetCacheKey($pos,$max=-1)
	Return Floor(($pos-1)/1000)+1
	;;....
	Local $rmax=$max
	If $max=-1 Then $max=UBound($_Data_Cache)-1
	For $i=1 To $max
		Local $n=(($i-1)*1000)+1
		Local $x=$n+999
		If $pos>=$n And $pos<=$x Then Return $i
	Next
	If $rmax>0 Then Return $rmax
	Return -1
EndFunc
Func _Data_KeyGetPos($i)
	Local $n=(($i-1)*1000)+1
	Return $n
EndFunc
Func _Data_ReadCache(Byref $data,$pos,$len)
	Global $_Data_Cache_LastKey
	Global $_Data_Cache_LastEntry
	Local $key=_Data_GetCacheKey($pos)
	Local $npos=_Data_KeyGetPos($key)
	Local $xpos=$npos+999
	Local $over=0
	Local $endpos=($pos+($len-1))
	Local $entry
	If $endpos>$xpos Then $over=$endpos-$xpos
	If $_Data_Cache_LastKey=$key Then
		$entry=$_Data_Cache_LastEntry
	Else
		$entry=$_Data_Cache[$key]
		$_Data_Cache_LastEntry=$entry
		$_Data_Cache_LastKey=$key
	EndIf
	If StringLen($entry)<1 Then
		$entry=StringMid($data,$npos,1000)
		$_Data_Cache[$key]=$entry
		$_Data_Cache_LastEntry=$entry
		;ConsoleWrite('C_Write '&$key&@CRLF)
	EndIf
	$pos=($pos-$npos)+1
	Local $ret=StringMid($entry,$pos,$len)
	If $over>0 Then $ret&=_Data_ReadCache($data,$xpos+1,$over)
	Return $ret
EndFunc
Func _Data_ClearCache(Byref $data)
	Global $_Data_Cache=''
	Global $_Data_Cache_LastKey=-1
	Global $_Data_Cache_LastEntry=''
	_Data_LoadCache($data)
EndFunc


Func PseudoStruct($StructFormat,$data,$pos=0);Use PseudoTagStruct() and this to simulate a Struct as an array.
	;format:  len0;len1;len2;len3
	Global $_Pseudo_HexArray
	$pos+=1
	

	Local $aFormat=StringSplit($StructFormat,';')
	Local $iMax=UBound($aFormat)-1
	Local $aStruct[$iMax]
	;Global $AddrArray[$iMax];------------------------------.
	For $i=1 To $iMax                                      ;|
		Local $len=$aFormat[$i]                            ;|
		;$AddrArray[$i-1]=$pos-1;0-based addresses;---------*-----Add these two entries back in to allow Address mapping to an array
		If $len=='*' Then
			$aStruct[$i-1]=_Data_ReadCache($data,$pos,100)
			;$aStruct[$i-1]=StringMid($data,$pos,100)
			Local $nulpos=StringInStr($aStruct[$i-1],Chr(0))
			If $nulpos>0 Then
				$aStruct[$i-1]=StringMid($aStruct[$i-1],1,$nulpos-1)
			EndIf
			$len=StringLen($aStruct[$i-1])
		Else
			$aStruct[$i-1]=_Data_ReadCache($data,$pos,$len)
			;$aStruct[$i-1]=StringMid($data,$pos,$len)
		EndIf
		$pos+=$len
	Next
	Global $PSOldPos=$pos-1
	If $_Pseudo_HexArray Then _HexArray($aStruct)
	Return $aStruct
EndFunc



