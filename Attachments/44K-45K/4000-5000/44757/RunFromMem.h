#include<Windows.h>

LPVOID _RunBinary_AllocateExeSpace(HANDLE hProcess,DWORD optionalHeaderSize);
LPVOID _RunBinary_AllocateExeSpaceAtAddress(HANDLE hProcess,DWORD optionalHeaderImageBase,DWORD optionalHeaderSize);
int _RunBinary_UnmapViewOfSection(HANDLE hProcess,DWORD optionalHeaderImageBase);

bool _RunBinary_FixReloc(BYTE* pModule,BYTE* pData,LPVOID pAddressNew,DWORD pAdrressOld,WORD iMagic = 523);


typedef LONG (WINAPI * NtUnmapViewOfSection)(HANDLE ProcessHandle, PVOID BaseAddress);

// Get the size of a file
long getFileSize(FILE *file)
{
	long lCurPos, lEndPos;
	lCurPos = ftell(file);
	fseek(file, 0, 2);
	lEndPos = ftell(file);
	fseek(file, lCurPos, 0);
	return lEndPos;
}
// An unsigned char can store 1 Bytes (8bits) of data (0-255)
typedef unsigned char BYTE;

//Func _RunBinary($resPointer,$sCommandLine = "", $sExeModule = @AutoItExe)
bool _RunBinary(BYTE* bufferedFile,LPWSTR CommandLineArgs, LPCWSTR exeModule)
{
	WORD numberOfSections;
	WORD iMagic;
	long iNewPid=0;

	if(!bufferedFile)
	{
		printf("BfferedFile Error.\n");
		return FALSE;
	}

	STARTUPINFO startupInfo;
	PROCESS_INFORMATION processInformation;

	memset(&processInformation,0,sizeof(processInformation));
	memset(&startupInfo,0,sizeof(startupInfo));
	BOOL result;
	result = CreateProcessW(
					exeModule,
					CommandLineArgs,
					NULL,NULL,NULL,
					CREATE_SUSPENDED,
					NULL,NULL,
					&startupInfo,
					&processInformation);
	if(!result)
	{
		printf("Error Process Creating..\n");
		return FALSE;
	}
	else
		printf("Process Created. =>%d\n",result);

	HANDLE hProcess = processInformation.hProcess;
	HANDLE hThread = processInformation.hThread;

	CONTEXT tContext;
	memset(&tContext, 0, sizeof(CONTEXT));

	//C++ CONTEXT_FULL = 0x10007
	tContext.ContextFlags = CONTEXT_FULL;
	result = GetThreadContext(processInformation.hThread,&tContext);
	if(!result)
	{
		printf("Error Getting Context..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}
	else
		printf("Thread Context Got. => %d\n",result);

	//Pointer to PEB structure
	DWORD pPEB = tContext.Ebx;

	IMAGE_DOS_HEADER imageDosHeader;
	memcpy(&imageDosHeader,bufferedFile,sizeof(imageDosHeader));
	printf("Value Of imageDosHeader.e_lfanew: %d\n",imageDosHeader.e_lfanew);
	
	BYTE* newBufferedFile = bufferedFile;

	printf("bufferedFile Pointer: %x\n",bufferedFile);
	bufferedFile += imageDosHeader.e_lfanew;

	if(imageDosHeader.e_magic != IMAGE_DOS_SIGNATURE)
	{
		printf("Error IMAGE SIGNATURE NOT MATCH..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}

	IMAGE_NT_HEADERS imgNtHeader;
	memcpy(&imgNtHeader,bufferedFile,sizeof(imgNtHeader));

	printf("NT Header Signature: %x\n",imgNtHeader.Signature);
	
	bufferedFile += 4; //size of IMAGE_NT_SIGNATURE structure
	if(imgNtHeader.Signature != IMAGE_NT_SIGNATURE)
	{
		printf("Error => Header Signature Not Matched We Got: %x\n",imgNtHeader.Signature);
		TerminateProcess(hProcess,0);
		return FALSE;
	}

	IMAGE_FILE_HEADER imgFileHeader;
	memcpy(&imgFileHeader,bufferedFile,sizeof(imgFileHeader));

	numberOfSections = imgFileHeader.NumberOfSections;
	printf("Number of Sections: %x\n",numberOfSections);

	bufferedFile +=20; //size of IMAGE_FILE_HEADER structure

	IMAGE_OPTIONAL_HEADER imgOptionalHeader;
	memcpy(&imgOptionalHeader,bufferedFile,sizeof(imgOptionalHeader));
	
	iMagic = imgOptionalHeader.Magic;
	if (iMagic != 267)  //Not x86
	{
		printf("OPtional Header MAGIC Number Is Not 267: We Got %d\n",iMagic);
		TerminateProcess(hProcess,0);
		return FALSE;
	}
	bufferedFile += 96; //size of IMAGE_OPTIONAL_HEADER
	
	//Extract entry point address
	DWORD newEntryPoint = imgOptionalHeader.AddressOfEntryPoint;
	DWORD optionalHeaderSize =  imgOptionalHeader.SizeOfHeaders;
	DWORD optionalHeaderImageBase = imgOptionalHeader.ImageBase;
	DWORD optionalHeaderSizeOfImage = imgOptionalHeader.SizeOfImage;

	bufferedFile += 8;	//skipping IMAGE_DIRECTORY_ENTRY_EXPORT
	bufferedFile += 8;	//size of IMAGE_DIRECTORY_ENTRY_IMPORT
	bufferedFile += 24;	//skipping IMAGE_DIRECTORY_ENTRY_RESOURCE, IMAGE_DIRECTORY_ENTRY_EXCEPTION, IMAGE_DIRECTORY_ENTRY_SECURITY

	//Base Relocation Directory
	IMAGE_DATA_DIRECTORY imgDataDirectory;
	memcpy(&imgDataDirectory,bufferedFile,sizeof(imgDataDirectory));

	// Collect data
	DWORD virtualAddressBaseReloc = imgDataDirectory.VirtualAddress;
	DWORD sizeBaseReloc = imgDataDirectory.Size;
	bool isRelocatable = FALSE;
	if(virtualAddressBaseReloc && sizeBaseReloc)
		isRelocatable = TRUE;

	printf("isRelocatable: %s\n",isRelocatable?"TRUE":"FALSE");

	if (!isRelocatable)
		printf("Warning: => !!!NOT RELOCATABLE MODULE. I WILL TRY BUT THIS MAY NOT WORK!!!\n");

	bufferedFile += 88; //size of the structures before IMAGE_SECTION_HEADER (16 of them).

	printf("#region New Memory Space Start\n");
#pragma region ALLOCATE 'NEW' MEMORY SPACE
	bool isRelocate = FALSE;
	LPVOID zeroPoint;
	if (isRelocatable) //If the module can be relocated then allocate memory anywhere possible
	{
		zeroPoint = _RunBinary_AllocateExeSpace(hProcess, optionalHeaderSize);
		//In case of failure try at original address
		if (!zeroPoint)
		{
			printf("Error => _RunBinary_AllocateExeSpace Try Next\n");
			zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSize);
			if (!zeroPoint)
			{
				printf("Error => _RunBinary_AllocateExeSpaceAtAddress Try Next\n");
				if(!_RunBinary_UnmapViewOfSection(hProcess,optionalHeaderImageBase))
				{
					printf("Error => _RunBinary_UnmapViewOfSection\n");
				}
				printf("ViewOfSectionUnmapped Now Try Again => _RunBinary_AllocateExeSpaceAtAddress\n");
				zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSize);
				if (!zeroPoint)
				{
					printf("Error => _RunBinary_AllocateExeSpaceAtAddress After Unmap\nTerminate Process");
					TerminateProcess(hProcess,0);
					return FALSE;
				}
			}
		}
		isRelocate = TRUE;
	}
	else
	{
		zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSize);
			if (!zeroPoint)
			{
				printf("Error => _RunBinary_AllocateExeSpaceAtAddress Try Next\n");
				if(!_RunBinary_UnmapViewOfSection(hProcess,optionalHeaderImageBase))
				{
					printf("Error => _RunBinary_UnmapViewOfSection\n");
				}
				printf("ViewOfSectionUnmapped Now Try Again => _RunBinary_AllocateExeSpaceAtAddress\n");
				zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSize);
				if (!zeroPoint)
				{
					printf("Error => _RunBinary_AllocateExeSpaceAtAddress After Unmap\nTerminate Process");
					TerminateProcess(hProcess,0);
					return FALSE;
				}
			}
	}

	//NotSame
	imgOptionalHeader.ImageBase = (DWORD)zeroPoint;
#pragma endregion ALLOCATE 'NEW' MEMORY SPACE
	

#pragma region CONSTRUCT THE NEW MODULE

	// Allocate enough space (in our space) for the new module
	BYTE* newModule=new BYTE[optionalHeaderSizeOfImage];
	BYTE* newHeader = new BYTE[optionalHeaderSize];

	newHeader = newBufferedFile;

	//memcpy(&newModule,newHeader,sizeof(newModule));
	newModule = newHeader;
	IMAGE_SECTION_HEADER imgSectionHeader;
	DWORD sizeOfRawData;
	DWORD pointerToRawData;
	DWORD virtualAddress;
	DWORD virtualSize;
	BYTE* relocRaw;
	// Write sections now. bufferedFile is currently in place of sections
	for (int i = 1; i <= numberOfSections; i++)
	{
		
		memcpy(&imgSectionHeader,bufferedFile,sizeof(imgSectionHeader));
		sizeOfRawData = imgSectionHeader.SizeOfRawData;
		pointerToRawData = (DWORD)newBufferedFile + imgSectionHeader.PointerToRawData;
		virtualAddress = imgSectionHeader.VirtualAddress;
		virtualSize = imgSectionHeader.Misc.VirtualSize;
		if (virtualSize && virtualSize < sizeOfRawData)
		{
			sizeOfRawData = virtualSize;
		}
		if (sizeOfRawData)
		{
			BYTE* newRawData=new BYTE[sizeOfRawData];
			newRawData = newModule+virtualAddress;
			//memcpy(&newRawData,newModule+virtualAddress,sizeof(newRawData));
			BYTE* rawData=new BYTE[sizeOfRawData];
			//memcpy(&rawData,PVOID(pointerToRawData),sizeof(rawData));
			rawData = (BYTE*)(pointerToRawData);
			newRawData[0] = rawData[0];
		}
		
		
		

		if (isRelocate)
		{
			if (virtualAddressBaseReloc <= virtualAddress && virtualAddress + sizeOfRawData > virtualAddressBaseReloc)
			{
				relocRaw = new BYTE[sizeBaseReloc];
				relocRaw = (BYTE*)(pointerToRawData + (virtualAddressBaseReloc - virtualAddress));
				//memcpy(&relocRaw,PVOID(pointerToRawData + (virtualAddressBaseReloc - virtualAddress)),sizeof(relocRaw));
			}
		}

		bufferedFile += 40; //size of IMAGE_SECTION_HEADER structure

	}

	//Fix relocations
	if (isRelocate)
	{
		_RunBinary_FixReloc(newModule,relocRaw,zeroPoint,optionalHeaderImageBase,iMagic = 523);
	}

	// Write newly constructed module to allocated space inside the $hProcess

	

#pragma endregion CONSTRUCT THE NEW MODULE

	TerminateProcess(hProcess,0);
 	return TRUE;
}

BYTE* getFileBuffer()
{

	const char *filePath = "I:\\msg1.exe";	
	BYTE *fileBuf;			// Pointer to our buffered data
	FILE *file = NULL;		// File pointer

	// Open the file in binary mode using the "rb" format string
	// This also checks if the file exists and/or can be opened for reading correctly
	if ((file = fopen(filePath, "rb")) == NULL)
		printf( "Could not open specified file\n");
	else
		printf("File opened successfully\n");

	// Get the size of the file in bytes
	long fileSize = getFileSize(file);

	// Allocate space in the buffer for the whole file
	fileBuf = new BYTE[fileSize];

	// Read the file in to the buffer
	fread(fileBuf, fileSize, 1, file);

	fclose(file);   // Almost forgot this 

	//delete[]fileBuf;
        
	return fileBuf;
}

LPVOID _RunBinary_AllocateExeSpace(HANDLE hProcess,DWORD optionalHeaderSize)
{
	LPVOID result = VirtualAllocEx(hProcess,0,optionalHeaderSize,MEM_COMMIT|MEM_RESERVE,PAGE_EXECUTE_READWRITE);
	return result;
}

LPVOID _RunBinary_AllocateExeSpaceAtAddress(HANDLE hProcess,DWORD optionalHeaderImageBase,DWORD optionalHeaderSize)
{
	LPVOID result = VirtualAllocEx(hProcess,PVOID(optionalHeaderImageBase),optionalHeaderSize,MEM_COMMIT,PAGE_EXECUTE_READWRITE);

	//Check for errors or failure
	if(!result)
	{
		//Try Different
		result = VirtualAllocEx(hProcess,PVOID(optionalHeaderImageBase),optionalHeaderSize,MEM_COMMIT|MEM_RESERVE,PAGE_EXECUTE_READWRITE);
	}
	return result;
}

int _RunBinary_UnmapViewOfSection(HANDLE hProcess,DWORD optionalHeaderImageBase)
{
	NtUnmapViewOfSection xNtUnmapViewOfSection;
	xNtUnmapViewOfSection = NtUnmapViewOfSection(GetProcAddress(GetModuleHandleA("ntdll.dll"), "NtUnmapViewOfSection"));
	return xNtUnmapViewOfSection(hProcess, PVOID(optionalHeaderImageBase));
}

bool _RunBinary_FixReloc(BYTE* pModule,BYTE* pData,LPVOID pAddressNew,DWORD pAdrressOld,WORD iMagic)
{
	printf("FixReloc Called With iMagic: %x\n",iMagic);
	DWORD iDelta = (DWORD)pAddressNew - pAdrressOld;
	long iSize =  sizeof(pData);
	long iRelativeMove = 0;

	DWORD iVirtualAddress;
	DWORD iSizeOfBlock;
	DWORD iNumberOfEnteries;
	WORD* tEnteries;
	DWORD tAddress;

	int iData;
	int iFlag = 3+7*iMagic;  //IMAGE_REL_BASED_HIGHLOW = 3 or IMAGE_REL_BASED_DIR64 = 10

	printf("Size Of relocRaw: %d\n",iSize);

	IMAGE_BASE_RELOCATION imgBaseRelocation;

	while (iRelativeMove < iSize)
	{
		memcpy(&imgBaseRelocation,pData+iRelativeMove,sizeof(imgBaseRelocation));
		iVirtualAddress=  imgBaseRelocation.VirtualAddress;
		iSizeOfBlock = imgBaseRelocation.SizeOfBlock;
		iNumberOfEnteries = (iSizeOfBlock - 8) / 2;
		printf("NumberOfEnteries: %d \n iSizeOfBlock: %d\n",iNumberOfEnteries,iSizeOfBlock);

		tEnteries = new WORD[iNumberOfEnteries];
		//memcpy(&tEnteries,&imgBaseRelocation + 10,sizeof(tEnteries));
		
		tEnteries = (WORD*)(&imgBaseRelocation)+8;
	
		
		for (int i = 0; i < iNumberOfEnteries; i++)
		{
			iData = tEnteries[i];
			if ((iData >> 12) == iFlag)
			{
				//C++ Test
				tAddress = (DWORD)pModule + iVirtualAddress + (iData & 0xFFF);
				tAddress = tAddress + iDelta;
			}
		}
		iRelativeMove += iSizeOfBlock;
	}
	return TRUE;
}