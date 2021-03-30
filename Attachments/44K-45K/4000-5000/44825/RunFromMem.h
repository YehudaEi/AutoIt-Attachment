//RunFromMem.h
#include<Windows.h>

LPVOID _RunBinary_AllocateExeSpace(HANDLE hProcess,DWORD optionalHeaderSize);
LPVOID _RunBinary_AllocateExeSpaceAtAddress(HANDLE hProcess,DWORD optionalHeaderImageBase,DWORD optionalHeaderSize);
int _RunBinary_UnmapViewOfSection(HANDLE hProcess,DWORD optionalHeaderImageBase);

bool _RunBinary_FixReloc(LPVOID pModule,LPVOID tData,LPVOID pAddressNew,DWORD pAdrressOld,WORD iMagic,DWORD iSize);


typedef LONG (WINAPI * NtUnmapViewOfSection)(HANDLE ProcessHandle, PVOID BaseAddress);

// An unsigned char can store 1 Bytes (8bits) of data (0-255)
//typedef unsigned char byte;

//Func _RunBinary($resPointer,$sCommandLine = "", $sExeModule = @AutoItExe)
bool _RunBinary(LPVOID pPointer,LPWSTR CommandLineArgs, LPCWSTR exeModule)
{
	WORD numberOfSections;
	WORD iMagic;
	
		std::cout<<"sizeof(pPointer) => "<<sizeof(pPointer)<<"\tSizeOf((byte*)pPointer)"<<sizeof((byte*)pPointer)<<std::endl;

	

	if(!pPointer)
	{
		printf("BfferedFile Error.\n");
		return FALSE;
	}

	STARTUPINFO startupInfo;
	PROCESS_INFORMATION processInformation;

	memset(&processInformation,0,sizeof(PROCESS_INFORMATION));
	memset(&startupInfo,0,sizeof(STARTUPINFO));
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

	//CONTEXT structure is what's really important here. It's processor specific.
	CONTEXT tContext;
	memset(&tContext, 0, sizeof(CONTEXT));

	
	//Set desired access
	//tContext.ContextFlags = CONTEXT_FULL;
	tContext.ContextFlags =  0x10007;

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

	//Start processing passed binary data. 'Reading' PE format follows.
	//IMAGE_DOS_HEADER imageDosHeader;
	//memcpy(&imageDosHeader,pPointer,sizeof(imageDosHeader));
	auto imageDosHeader = reinterpret_cast<IMAGE_DOS_HEADER*>(pPointer);
	
	//imageDosHeader.e_lfanew = (LONG)pPointer;
	std::cout<<"pPointer: "<<pPointer<<"\t imageDosHeader.e_lfanew(AddressOfNewHeader): "<<imageDosHeader->e_lfanew<<std::endl;
	
	//Save this pointer value (it's starting address of binary image headers)
	LPVOID pHEADERS_NEW = pPointer;

	std::cout<<"Pointer Before Increment: "<<pPointer<<std::endl;

	//memcpy(&INH,(void*)((DWORD)pImage+IDH.e_lfanew),sizeof(INH));
	pPointer = (void*)((LONG)pPointer + imageDosHeader->e_lfanew);

	std::cout<<"Pointer After Increment: "<<pPointer<<std::endl;

	//Check if it's valid format
	//if(imageDosHeader.e_magic != IMAGE_DOS_SIGNATURE)
	if(imageDosHeader->e_magic != IMAGE_DOS_SIGNATURE)
	{
		printf("Error IMAGE SIGNATURE NOT MATCH..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}

	//IMAGE_NT_HEADERS imgNtHeader;
	//memcpy(&imgNtHeader,pPointer,sizeof(imgNtHeader));
	auto imgNtHeader = reinterpret_cast<IMAGE_NT_HEADERS*>(pPointer);

	//DWORD tIMAGE_NT_SIGNATURE = (DWORD)pPointer;
	typedef struct MY_SIGNATURE
	{
		DWORD Signature;
	};	
	//In place of IMAGE_NT_SIGNATURE
	//memcpy(&tIMAGE_NT_SIGNATURE,pPointer,sizeof(tIMAGE_NT_SIGNATURE));
	MY_SIGNATURE* tIMAGE_NT_SIGNATURE = reinterpret_cast<MY_SIGNATURE*>(pPointer);
	std::cout<<"*IMAGE_NT_SIGNATURE = "<<tIMAGE_NT_SIGNATURE->Signature<<std::endl;


	
	pPointer = (LPVOID)((DWORD)pPointer + 4); //size of IMAGE_NT_SIGNATURE structure

	if ((tIMAGE_NT_SIGNATURE->Signature != 17744))
	{
		printf("Error IMAGE_NT_SIGNATURE != 17744..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}

	//IMAGE_FILE_HEADER imgFileHeader;
	//In place of IMAGE_FILE_HEADER
	//memcpy(&imgFileHeader,pPointer,sizeof(imgFileHeader));

	IMAGE_FILE_HEADER* imgFileHeader = reinterpret_cast<IMAGE_FILE_HEADER*>(pPointer);

	//Get number of sections
	numberOfSections = imgFileHeader->NumberOfSections;
	printf("Number of Sections: %x\n",numberOfSections);

	pPointer = (LPVOID)((int)pPointer + 20); //size of IMAGE_FILE_HEADER structure

	struct MY_MAGIC
	{
		WORD Magic;
	};

	//MY_MAGIC tMagic;
	//memcpy(&tMagic,pPointer,sizeof(tMagic));
	MY_MAGIC* tMagic = reinterpret_cast<MY_MAGIC*>(pPointer);

	iMagic = tMagic->Magic;
	std::cout<<"iMagic Must(267): "<<iMagic<<std::endl;

	if (iMagic != 267)
	{
		printf("Error iMagic != 17744: => %d..\n",iMagic);
		TerminateProcess(hProcess,0);
		return FALSE;
	}

	//IMAGE_OPTIONAL_HEADER imgOptionalHeader;

	//In place of IMAGE_OPTIONAL_HEADER
	//memcpy(&imgOptionalHeader,pPointer,sizeof(imgOptionalHeader));
	IMAGE_OPTIONAL_HEADER* imgOptionalHeader = reinterpret_cast<IMAGE_OPTIONAL_HEADER*>(pPointer);

	pPointer = (LPVOID)((int)pPointer +  96); //size of IMAGE_OPTIONAL_HEADER
	
	//Extract entry point address
	DWORD newEntryPoint = imgOptionalHeader->AddressOfEntryPoint;
	DWORD optionalHeaderSizeOfHeaders =  imgOptionalHeader->SizeOfHeaders;
	DWORD optionalHeaderImageBase = imgOptionalHeader->ImageBase;
	DWORD optionalHeaderSizeOfImage = imgOptionalHeader->SizeOfImage;

	pPointer = (LPVOID)((int)pPointer +  8);	//skipping IMAGE_DIRECTORY_ENTRY_EXPORT
	pPointer = (LPVOID)((int)pPointer +  8);	//size of IMAGE_DIRECTORY_ENTRY_IMPORT
	pPointer = (LPVOID)((int)pPointer +  24);	//skipping IMAGE_DIRECTORY_ENTRY_RESOURCE, IMAGE_DIRECTORY_ENTRY_EXCEPTION, IMAGE_DIRECTORY_ENTRY_SECURITY

	//Base Relocation Directory
	//IMAGE_DATA_DIRECTORY imgDataDirectory;
	//memcpy(&imgDataDirectory,pPointer,sizeof(imgDataDirectory));
	IMAGE_DATA_DIRECTORY* imgDataDirectory = reinterpret_cast<IMAGE_DATA_DIRECTORY*>(pPointer);

	// Collect data
	DWORD virtualAddressBaseReloc = imgDataDirectory->VirtualAddress;
	DWORD sizeBaseReloc = imgDataDirectory->Size;
	bool isRelocatable = FALSE;
	if(virtualAddressBaseReloc && sizeBaseReloc)
		isRelocatable = TRUE;

	printf("isRelocatable: %s\n",isRelocatable?"TRUE":"FALSE");

	if (!isRelocatable)
		printf("Warning: => !!!NOT RELOCATABLE MODULE. I WILL TRY BUT THIS MAY NOT WORK!!!\n");

	pPointer = (LPVOID)((int)pPointer +  88); //size of the structures before IMAGE_SECTION_HEADER (16 of them).

	printf("#region New Memory Space Start\n");

#pragma region ALLOCATE 'NEW' MEMORY SPACE
	bool isRelocate = FALSE;
	LPVOID zeroPoint;
	if (isRelocatable) //If the module can be relocated then allocate memory anywhere possible
	{
		zeroPoint = _RunBinary_AllocateExeSpace(hProcess, optionalHeaderSizeOfImage);
		//In case of failure try at original address
		if (!zeroPoint)
		{
			printf("Error => _RunBinary_AllocateExeSpace Try Next\n");
			zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSizeOfImage);
			if (!zeroPoint)
			{
				printf("Error => _RunBinary_AllocateExeSpaceAtAddress Try Next\n");
				if(!_RunBinary_UnmapViewOfSection(hProcess,optionalHeaderImageBase))
				{
					printf("Error => _RunBinary_UnmapViewOfSection\n");
				}
				printf("ViewOfSectionUnmapped Now Try Again => _RunBinary_AllocateExeSpaceAtAddress\n");
				zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSizeOfImage);
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
		zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSizeOfImage);
			if (!zeroPoint)
			{
				printf("Error => _RunBinary_AllocateExeSpaceAtAddress Try Next\n");
				if(!_RunBinary_UnmapViewOfSection(hProcess,optionalHeaderImageBase))
				{
					printf("Error => _RunBinary_UnmapViewOfSection\n");
				}
				printf("ViewOfSectionUnmapped Now Try Again => _RunBinary_AllocateExeSpaceAtAddress\n");
				zeroPoint = _RunBinary_AllocateExeSpaceAtAddress(hProcess,optionalHeaderImageBase,optionalHeaderSizeOfImage);
				if (!zeroPoint)
				{
					printf("Error => _RunBinary_AllocateExeSpaceAtAddress After Unmap\nTerminate Process");
					TerminateProcess(hProcess,0);
					return FALSE;
				}
			}
	}

	//NotSame
	imgOptionalHeader->ImageBase = (DWORD)zeroPoint;
#pragma endregion ALLOCATE 'NEW' MEMORY SPACE
	

#pragma region CONSTRUCT THE NEW MODULE

	// Allocate enough space (in our space) for the new module
	//byte* tModule=new byte[optionalHeaderSizeOfImage];

	//Get pointer
	//LPVOID pModule = &tModule;

	//byte* tHeader = new byte[optionalHeaderSizeOfHeaders];

	auto tModule = new byte[optionalHeaderSizeOfImage];
	auto pModule = &tModule;
	auto tHeader = new byte[optionalHeaderSizeOfHeaders];
	tHeader = reinterpret_cast<byte*>(pHEADERS_NEW);
	//tHeader = pHEADERS_NEW;
	//memcpy(tHeader,&pHEADERS_NEW,sizeof(tHeader));
	//Write headers to $tModule
	
	//Alternate: 
	tModule = tHeader;

	/*
	printf("*MemCpy tHeader To tModule \n");
	for (int i = 0; i < optionalHeaderSizeOfHeaders; i++)
	{
		tModule[i] = tHeader[i];
	}
	*/
	//memcpy(&tModule,&tHeader,sizeof(tModule));
	//tModule = reinterpret_cast<byte*>(tHeader);

	IMAGE_SECTION_HEADER* imgSectionHeader;
	DWORD sizeOfRawData;
	DWORD pointerToRawData;
	DWORD virtualAddress;
	DWORD virtualSize;
	byte* relocRaw;
	// Write sections now. pPointer is currently in place of sections
	for (int i = 1; i <= numberOfSections; i++)
	{
		
		//memcpy(&imgSectionHeader,pPointer,sizeof(imgSectionHeader));
		imgSectionHeader = reinterpret_cast<IMAGE_SECTION_HEADER*>(pPointer);
		sizeOfRawData = imgSectionHeader->SizeOfRawData;
		pointerToRawData = (DWORD)pHEADERS_NEW + imgSectionHeader->PointerToRawData;
		virtualAddress = imgSectionHeader->VirtualAddress;
		virtualSize = imgSectionHeader->Misc.VirtualSize;
		if (virtualSize && virtualSize < sizeOfRawData)
		{
			sizeOfRawData = virtualSize;
		}
		if (sizeOfRawData)
		{
			//std::cout<<"pModule: "<<pModule<<"\t VirtualAddress: "<<virtualAddress<<"\t pModule+virtualAddress: "<<(LPVOID)((DWORD)pModule+virtualAddress)<<std::endl;
			auto $tempStruct=new byte[sizeOfRawData];
			//newRawData = (byte*)((DWORD)pModule+virtualAddress);
			//memcpy(&newRawData,(LPVOID)((DWORD)pModule+virtualAddress),sizeof(newRawData));
			LPVOID newAddr = (*pModule)+virtualAddress;
			$tempStruct = reinterpret_cast<byte*>(newAddr);
			auto $tempStruct1=new byte[sizeOfRawData];
			//memcpy(rawData,(LPVOID)pointerToRawData,sizeof(rawData));
			$tempStruct1 = reinterpret_cast<byte*>(pointerToRawData);
			//rawData = (byte*)(pointerToRawData);
			//
			//Alternate
			$tempStruct=$tempStruct1;
			//for (int i = 0; i < sizeOfRawData; i++)
			//{
				//$tempStruct[i] = $tempStruct1[i];
			//}
		}
		
		
		

		if (isRelocate)
		{
			if (virtualAddressBaseReloc <= virtualAddress && virtualAddress + sizeOfRawData > virtualAddressBaseReloc)
			{
				relocRaw = new byte[sizeBaseReloc];
				//relocRaw = (byte*)(pointerToRawData + (virtualAddressBaseReloc - virtualAddress));
				//memcpy(&relocRaw,(char*)(pointerToRawData + (virtualAddressBaseReloc - virtualAddress)),sizeof(relocRaw));
				relocRaw = reinterpret_cast<byte*>(pointerToRawData + (virtualAddressBaseReloc - virtualAddress));
			}
		}

		pPointer = (void*)((int)pPointer +  40); //size of IMAGE_SECTION_HEADER structure

	}

	//Fix relocations
	if (isRelocate)
	{
		_RunBinary_FixReloc(*pModule,relocRaw,zeroPoint,optionalHeaderImageBase,iMagic = 523,sizeBaseReloc);
	}

	// Write newly constructed module to allocated space inside the $hProcess
	
	BOOL boolResult = WriteProcessMemory(hProcess,zeroPoint,*pModule,optionalHeaderSizeOfImage,0);
	if(!boolResult)
	{
		printf("Error WriteProcessMemory..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}
	

#pragma endregion CONSTRUCT THE NEW MODULE


#pragma region PEB ImageBaseAddress MANIPULATION

	// PEB structure definition
	typedef struct _PEB
	{
		byte InheritedAddressSpace;
		byte ReadImageFileExecOptions;
		byte BeingDebugged;
		byte Spare;
		PVOID Mutant;
		PVOID ImageBaseAddress;
		PVOID LoaderData;
		PVOID ProcessParameters;
		PVOID SubSystemData;
		PVOID ProcessHeap;
		PVOID FastPebLock;
		PVOID FastPebLockRoutine;
		PVOID FastPebUnlockRoutine;
		DWORD EnvironmentUpdateCount;
		PVOID KernelCallbackTable;
		PVOID EventLogSection;
		PVOID EventLog;
		PVOID FreeList;
		DWORD TlsExpansionCounter;
		PVOID TlsBitmap;
		DWORD TlsBitmapBits[2];
		PVOID ReadOnlySharedMemoryBase;
		PVOID ReadOnlySharedMemoryHeap;
		PVOID ReadOnlyStaticServerData;
		PVOID AnsiCodePageData;
		PVOID OemCodePageData;
		PVOID UnicodeCaseTableData;
		DWORD NumberOfProcessors;
		DWORD NtGlobalFlag;
		byte Spare2[4];
		INT64 CriticalSectionTimeout;
		DWORD HeapSegmentReserve;
		DWORD HeapSegmentCommit;
		DWORD HeapDeCommitTotalFreeThreshold;
		DWORD HeapDeCommitFreeBlockThreshold;
		DWORD NumberOfHeaps;
		DWORD MaximumNumberOfHeaps;
		PVOID ProcessHeaps;
		PVOID GdiSharedHandleTable;
		PVOID ProcessStarterHelper;
		PVOID GdiDCAttributeList;
		PVOID LoaderLock;
		DWORD OSMajorVersion;
		DWORD OSMinorVersion;
		DWORD OSBuildNumber;
		DWORD OSPlatformId;
		DWORD ImageSubSystem;
		DWORD ImageSubSystemMajorVersion;
		DWORD ImageSubSystemMinorVersion;
		DWORD GdiHandleBuffer[34];
		DWORD PostProcessInitRoutine;
		DWORD TlsExpansionBitmap;
		byte TlsExpansionBitmapBits[128];
		DWORD SessionId;
	} PEB;

	PEB tPEB;
	
	printf("*Size Of tPEB: %d\n",sizeof(tPEB));
	boolResult = ReadProcessMemory(hProcess,(LPVOID)pPEB,&tPEB,sizeof(tPEB),0);
	if(!boolResult)
	{
		printf("Error ReadProcessMemory..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}

	//Change base address within PEB
	tPEB.ImageBaseAddress = zeroPoint;

	//Write the changes
	boolResult = WriteProcessMemory(hProcess,(LPVOID)pPEB,&tPEB,sizeof(tPEB),0);
	if(!boolResult)
	{
		printf("Error WriteProcessMemory => Write Changes..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}

#pragma endregion PEB ImageBaseAddress MANIPULATION
	
#pragma region NEW ENTRY POINT
	//Entry point manipulation
	printf("*Manualy RunFlag Set To 1\n");
	tContext.Eax = (DWORD)zeroPoint + newEntryPoint;
#pragma endregion NEW ENTRY POINT

#pragma region	SET NEW CONTEXT

	boolResult =  SetThreadContext(hThread,&tContext);
	if(!boolResult)
	{
		printf("Error SetThreadContext..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}
	#pragma endregion SET NEW CONTEXT

#pragma region RESUME THREAD
	//And that's it!. Continue execution:
	DWORD dwordResult = ResumeThread(hThread);
	printf("*ResumeThread Returned: %d\n",dwordResult);

	if (!dwordResult || dwordResult == -1)
	{
		printf("Error ResumeThread..\n");
		TerminateProcess(hProcess,0);
		return FALSE;
	}


	#pragma endregion RESUME THREAD

#pragma region CLOSE OPEN HANDLES AND RETURN PID

	CloseHandle(hProcess);
	CloseHandle(hThread);

	// All went well. Return new PID:
	return processInformation.dwProcessId;
	#pragma endregion CLOSE OPEN HANDLES AND RETURN PID
}


LPVOID _RunBinary_AllocateExeSpace(HANDLE hProcess,DWORD optionalHeaderSize)
{
	std::cout<<"=Func =>\n\thProcess: "<<hProcess<<" -iSize: "<<optionalHeaderSize<<std::endl;
	LPVOID result = VirtualAllocEx(hProcess,0,optionalHeaderSize,MEM_COMMIT|MEM_RESERVE,PAGE_EXECUTE_READWRITE);
	return result;
}

LPVOID _RunBinary_AllocateExeSpaceAtAddress(HANDLE hProcess,DWORD optionalHeaderImageBase,DWORD optionalHeaderSize)
{
	std::cout<<"=Func _RunBinary_AllocateExeSpaceAtAddress =>\n\thProcess: "<<hProcess<<" -pAddress: "<<optionalHeaderImageBase<<" -iSize: "<<optionalHeaderSize<<std::endl;
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
	std::cout<<"=Func _RunBinary_UnmapViewOfSection =>\n\thProcess: "<<hProcess<<" -pAddress: "<<optionalHeaderImageBase<<std::endl;
	NtUnmapViewOfSection xNtUnmapViewOfSection;
	xNtUnmapViewOfSection = NtUnmapViewOfSection(GetProcAddress(GetModuleHandleA("ntdll.dll"), "NtUnmapViewOfSection"));
	return xNtUnmapViewOfSection(hProcess, PVOID(optionalHeaderImageBase));
}

bool _RunBinary_FixReloc(LPVOID pModule,LPVOID tData,LPVOID pAddressNew,DWORD pAdrressOld,WORD iMagic,DWORD iSize)
{
	std::cout<<"=Func _RunBinary_FixReloc =>\n\tpModule: "<<pModule<<" -tData: "<<tData<<" -pAddressnew: "<<pAddressNew<<" -pAddressold: "<<pAdrressOld<<std::endl;
	DWORD iDelta = (DWORD)pAddressNew - pAdrressOld;
	//long iSize =  sizeof tData;
	
	long iRelativeMove = 0;

	DWORD iVirtualAddress;
	DWORD iSizeOfBlock;
	DWORD iNumberOfEnteries;
	WORD* tEnteries;
	LPVOID tAddress;

	int iData;
	iMagic = 0;
	printf("FixReloc Called With Manual Set iMagic: %x\n",iMagic);
	int iFlag = 3+7*iMagic;  //IMAGE_REL_BASED_HIGHLOW = 3 or IMAGE_REL_BASED_DIR64 = 10

	printf("Size Of relocRaw: %d\n",iSize);
	struct tIMAGE_BASE_RELOCATION
	{
		DWORD VirtualAddress;
		DWORD SizeOfBlock;
	};
	tIMAGE_BASE_RELOCATION* imgBaseRelocation;
//	printf("*iDelta: %x\n",iDelta);
	
	while (iRelativeMove < iSize)
	{
		//memcpy(&imgBaseRelocation,(LPVOID)((long)tData+iRelativeMove),sizeof(imgBaseRelocation));
		imgBaseRelocation = reinterpret_cast<tIMAGE_BASE_RELOCATION*>((long)tData+iRelativeMove);
		iVirtualAddress=  imgBaseRelocation->VirtualAddress;
		iSizeOfBlock = imgBaseRelocation->SizeOfBlock;
		iNumberOfEnteries = (iSizeOfBlock - 8) / 2;
		

		tEnteries = new WORD[iNumberOfEnteries];
		//memcpy(&tEnteries,&imgBaseRelocation + 8,sizeof(tEnteries));
		tEnteries= reinterpret_cast<WORD*>(imgBaseRelocation + 8);
		
		//tEnteries = (WORD*)(&imgBaseRelocation)+8;
		
//		printf("%d: NumberOfEnteries: %d \t iSizeOfBlock: %d\n",iRelativeMove,iNumberOfEnteries,iSizeOfBlock);
		for (DWORD i = 0;i < iNumberOfEnteries;i++)
		{
			iData = tEnteries[i];
			printf("iData: %d\n",iData);
			//getch();
			if ((iData >> 12) == iFlag)
			{
				//std::cout<<"\tBitShift($iData, 12) = $iFlag => is true"<<std::endl;

				//tAddress = (DWORD)pModule + iVirtualAddress + (iData & 0xFFF);
				//memcpy(&tAddress,(LPVOID)((*pModule + iVirtualAddress + (iData & 0xFFF)),sizeof(tAddress));

//				printf("iRelativeMove: %d i:%d 1taddress: %x\t",iRelativeMove,i,tAddress);
				tAddress = reinterpret_cast<LPVOID>((DWORD)pModule+iVirtualAddress+(iData & 0xFFF));
			//	printf("iRelativeMove: %d -i:%d -iData(%d)=>2taddress: %x -",iRelativeMove,i,iData,tAddress);
				tAddress = (LPVOID)((DWORD)tAddress + iDelta);
			//	printf(" -3taddress: %x\n",tAddress);
				//getch();
			}
		}
		iRelativeMove += iSizeOfBlock;
	}
	return TRUE;
}
