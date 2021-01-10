#Include <SendMessage.au3>
#Include <Memory.au3>
#Include <WinAPI.au3>

#AutoIt3Wrapper_Run_Debug_Mode=n

Const $SMTO_NORMAL        	= 0x0000
Const $SMTO_BLOCK         	= 0x0001
Const $SMTO_ABORTIFHUNG   	= 0x0002

Const $PROCESS_VM_OPERATION = 0x8
Const $PROCESS_VM_READ 		= 0x10
Const $PROCESS_VM_WRITE 	= 0x20
Const $PROCESS_ALL_ACCESS 	= 0xFFFF


;===============================================================================
;
; Function Name:   	GetClassNameNNforWindow
; Description::    	Returns a dictionary that contains all classes and their 
;					total count for a given window
; Parameter(s):    	$WindowName	= Name of the .NET Window Form
;					$WindowText = Text of the Window to read ( Optional )
; Return Value(s): 	Dictionary ( key = CLASS; value = Total Count )
; Author(s):       	Zach Fisher
;
;===============================================================================
;
Func GetClassNameNNforWindow( $windowTitle, $WindowText = "" )
	Local $dctClassNameNN = ObjCreate( "Scripting.Dictionary" )
	Local $aClassList = StringSplit( WinGetClassList( $windowTitle, $WindowText ), @LF )

	for $i = 1 to $aClassList[0] - 1
		if ( $dctClassNameNN.Exists( $aClassList[$i] )) then
			$dctClassNameNN( $aClassList[$i] ) = $dctClassNameNN( $aClassList[$i] ) + 1
		else
			$dctClassNameNN.Add( $aClassList[$i], 1 )
		endif
	next	
	
	return $dctClassNameNN
EndFunc

;===============================================================================
;
; Function Name:   	NET_DumpAllControlNames
; Description::    	Dumps all .NET instances that have control names to Console
; Parameter(s):    	$WindowName	= Name of the .NET Window Form
;					$WindowText = Text of the Window to read ( Optional )
; Return Value(s): 	None
; Author(s):       	Zach Fisher 
;
;===============================================================================
;
Func NET_DumpAllControlNames( $WindowName, $WindowText )
	Local $retVal 		= 0
	Local $bufSize 		= 1024
	Local $processID 	= WinGetProcess( $WindowName, $WindowText );
	if $processID = -1 then return SetError( 1, 1 )
	Local $winHWnd 		= WinGetHandle( $WindowName, $WindowText )
	if @error = 1 then return SetError( 1, 2 )
	Local $tCtrlName 	= DllStructCreate( "wchar var1[" & $bufSize & "]" )
	Local $pCtrlName 	= DllStructGetPtr( $tCtrlName )		
		
	; Setup Inter-Process stuff
	Local $getName 		= _WinAPI_RegisterWindowMessage( "WM_GETCONTROLNAME" )
	Local $dwResult 	= _WinAPI_GetWindowThreadProcessId( $winHWnd, $processID )
	Local $hProcess 	= _WinAPI_OpenProcess( _
		BitOR( $PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE ), _
		False, $processID, False )	
	Local $otherMem 	= _MemVirtualAllocEx( $hProcess, 0, $bufSize, $MEM_COMMIT, $PAGE_READWRITE )

	; Obtain all descendent classes in specified window
	Local $dctClassNameNN = ObjCreate( "Scripting.Dictionary" )
	$dctClassNameNN = GetClassNameNNforWindow( $WindowName, $WindowText )

	; Iterate through all descendent classes in specified window
	Local $retVal, $keys = $dctClassNameNN.Keys	
	for $i = 0 to UBound( $keys ) - 1
		$className = $keys[$i]		
		$classCount = $dctClassNameNN( $className )
		For $j = 1 to $classCount
			$description = $className & $j				
			$controlHwnd = ControlGetHandle( $WindowName, $WindowText, $description )
			
			$result = DllCall( "User32", "lresult", "SendMessage", _
				"hwnd", $controlHwnd, "uint", $getName, "wparam", $bufSize, "lparam", $otherMem )

			Local $numRead = 0	
			$bResult = _WinAPI_ReadProcessMemory( $hProcess, $otherMem, $pCtrlName, $bufSize, $numRead )

			if ( $bResult ) then
				Local $tempName = DllStructGetData( $tCtrlName, "var1" )
				if ( $tempName <> "" ) then
					ConsoleWrite( StringFormat( "%-40s \t %-40s \n", $description, $tempName ))					
				endif
			endif
		Next	; $j
	Next 	; $i

	; clean up 
	$bResult = _WinAPI_CloseHandle( $hProcess )
	$bResult = _MemVirtualFreeEx( $hProcess, $otherMem, $bufSize, $MEM_RELEASE )
	$tCtrlName = 0
EndFunc


;===============================================================================
;
; Function Name:   	NET_ControlGetHandleByName
; Description:    	Provides a mechanism to obtain the persistent ID ( handle )
;					to a .NET control using the name given at compile/run time
; Parameter(s):		$WindowName	= Name of the .NET Window Form
;					$WindowText = Text of the Window to read
;					$ControlName = Name of the control to search for
; Return Value(s): 	Success	- Handle to the control
;					Failure - 0; @error = 1
; Author(s):       	Zach Fisher ( ported from Bill Rogers on:
;					http://www.pcreview.co.uk/forums/thread-1225106.php )
;
;===============================================================================
;
Func NET_ControlGetHandleByName( $WindowName, $WindowText, $ControlName )
#region C++ EXAMPLE
	;~ /*
	;~ given an hWnd, this code attempts to send a message to the window to get the
	;~ instance name of the control bound to the window
	;~ Steps:
	;~ 1. Get the Value of the WM_GETCONTROLNAME message (RegisterWindowMessage)
	;~ 2. Get the Process Info for this window (GetWindowThreadProcessId)
	;~ 3. Open the process and get a process handle (OpenProcess)
	;~ 4. Allocate memory within the target process (VirtualAllocEx)
	;~ 5. Send the target window a WM_GETCONTROLNAME message and a pointer to the
	;~ memory (SendMessageTimeout)
	;~ 6. Read the response from the allocated memory (ReadProcessMemory)
	;~ 7. Close process handle, release memory
	;~ */
	;~ //we enter this code with hwnd set to a specific window handle
	;~ //error checking omitted for brevity

	;~ const int bufsize = 1024;
	;~ wchar_t CtlName[bufsize];
	;~ DWORD ProcessId;
	;~ SIZE_T NumRead;

	;~ unsigned int GetName = RegisterWindowMessage(L"WM_GETCONTROLNAME");
	;~ DWORD dwResult = GetWindowThreadProcessId(hwnd, &ProcessId);
	;~ HANDLE hProcess = OpenProcess(PROCESS_ALL_ACCESS,false,ProcessId);
	;~ LPVOID OtherMem = VirtualAllocEx(hProcess, 0, bufsize, MEM_COMMIT,PAGE_READWRITE);
	;~ LPARAM lpOtherMem = reinterpret_cast<LPARAM>(OtherMem);
	;~ unsigned int SendFlags = SMTO_ABORTIFHUNG|SMTO_BLOCK;
	;~ LRESULT lResult = SendMessageTimeout(hwnd, GetName, bufsize, lpOtherMem, SendFlags, 5000, &NumRead);

	;~ //if lResult == 0 then failure or timeout, if GetLastError reports 0, then it is a timeout
	;~ //if successful NumRead contains the number of characters, if NumRead == 0 then the name is empty

	;~ BOOL bResult = ReadProcessMemory(hProcess, OtherMem, CtlName, bufsize,
	;~ &NumRead);

	;~ //CtlName now contains the instance name of the control, or is empty if there is no name
	;~ //clean up
	;~ bResult = CloseHandle(hProcess);
	;~ bResult = VirtualFreeEx(hProcess,OtherMem,1024,MEM_RELEASE);
#EndRegion

	Local $retVal 		= 0
	Local $bufSize 		= 1024
	Local $processID 	= WinGetProcess( $WindowName, $WindowText );
	if $processID = -1 then return SetError( 1, 1 )
	Local $winHWnd 		= WinGetHandle( $WindowName, $WindowText )
	if @error = 1 then return SetError( 1, 2 )
	Local $tCtrlName 	= DllStructCreate( "wchar var1[" & $bufSize & "]" )
	Local $pCtrlName 	= DllStructGetPtr( $tCtrlName )

	; Setup Inter-Process stuff
	Local $getName 		= _WinAPI_RegisterWindowMessage( "WM_GETCONTROLNAME" )						; Step 1
	Local $dwResult 	= _WinAPI_GetWindowThreadProcessId( $winHWnd, $processID )					; Step 2
	Local $hProcess 	= _WinAPI_OpenProcess( _
		BitOR( $PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE ), _
		False, $processID, False )																	; Step 3	
	Local $otherMem 	= _MemVirtualAllocEx( $hProcess, 0, $bufSize, $MEM_COMMIT, $PAGE_READWRITE ); Step 4

	; Obtain all descendent classes in specified window
	Local $dctClassNameNN = ObjCreate( "Scripting.Dictionary" )
	$dctClassNameNN = GetClassNameNNforWindow( $WindowName, $WindowText )

	; Iterate through all descendent classes in specified window
	Local $retVal, $keys = $dctClassNameNN.Keys	
	for $i = 0 to UBound( $keys ) - 1
		$className = $keys[$i]		
		$classCount = $dctClassNameNN( $className )
		For $j = 1 to $classCount
			$description = $className & $j				
			$controlHwnd = ControlGetHandle( $WindowName, $WindowText, $description )
			
			; Step 5
			$result = DllCall( "User32", "lresult", "SendMessage", _
				"hwnd", $controlHwnd, "uint", $getName, "wparam", $bufSize, "lparam", $otherMem )

			; Step 6
			Local $numRead = 0
			$bResult = _WinAPI_ReadProcessMemory( $hProcess, $otherMem, $pCtrlName, $bufSize, $numRead )

			if ( $bResult ) then
				Local $tempName = DllStructGetData( $tCtrlName, "var1" )
				if ( $tempName = $ControlName ) then					
					$retVal = $controlHwnd
					ExitLoop( 2 )
				endif
			endif
		Next	; $j
	Next 	; $i

	; Step 7 - clean up 
	$bResult = _WinAPI_CloseHandle( $hProcess )
	$bResult = _MemVirtualFreeEx( $hProcess, $otherMem, $bufSize, $MEM_RELEASE )
	$tCtrlName = 0

	if ( $retVal = 0 ) Then	SetError( 1, 0 )
	Return $retVal
EndFunc
