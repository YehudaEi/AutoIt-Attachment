#include <winapi.au3>

; © 2008 Andreas Karlsson, you are free to use this code as long as you credit me alongside your name in your application

Global $IMAGE_DIRECTORY_ENTRY_IMPORT = 1
Global $PAGE_READWRITE = 0x04

; DUMMYUNIONNAME has the following members: Characteristics,OriginalFirstThunk
Global $IMAGE_IMPORT_DESCRIPTOR = "dword DUMMYUNIONNAME;dword TimeDateStamp;dword ForwarderChain;dword Name;dword FirstThunk"
; u1 has the following members: ForwarderString,Function,Ordinal,AddressOfData
Global $IMAGE_THUNK_DATA = "dword u1"

Global $MEMORY_BASIC_INFORMATION = "ptr BaseAddress;ptr AllocationBase;ptr AllocationProtect;ulong RegionSize;dword State;dword Protect;dword Type;"

Func _AddHookApi($ModuleName, $FunctionName, $NewProcAddress)
	; Get base address of our app
	$hInstance = _WinAPI_GetModuleHandle(0)
	
	;; Get module of the module that the function resides in
	$Module = _WinAPI_GetModuleHandle($ModuleName)
	
	; Get the original function address
	$call = DllCall("Kernel32.dll", "ptr", "GetProcAddress", "ptr", $Module, "str", $FunctionName)
	$OrigAddress = $call[0]

	;; Get the address of the Import directory
	$call = DllCall("Dbghelp.dll", "ptr", "ImageDirectoryEntryToData", "ptr", $hInstance, "int", 1, "ushort", $IMAGE_DIRECTORY_ENTRY_IMPORT, "ulong*", "")
	$ptrtoiid = $call[0]
	
	; Create a struct from the pointer
	$iid = DllStructCreate($IMAGE_IMPORT_DESCRIPTOR, $ptrtoiid)
	
	;; Loop through all loaded modules.
	While DllStructGetData($iid, "Name")
		
		; get the name...
		$str = DllStructCreate("char[255]", $hInstance + DllStructGetData($iid, "Name"))
		
		; If the name matches, we've found what we're looking for.
		If DllStructGetData($str, 1) = $ModuleName Then ExitLoop
		
		; Move to the next directory item
		$ptrtoiid += DllStructGetSize($iid)
		$iid = DllStructCreate($IMAGE_IMPORT_DESCRIPTOR, $ptrtoiid)
	WEnd
	
	
	$ptrtoitd = $hInstance + DllStructGetData($iid, "FirstThunk")
	$itd = DllStructCreate($IMAGE_THUNK_DATA, $ptrtoitd)

	While DllStructGetData($itd, 1)
		
		; We have found where the original address is stored
		If DllStructGetData($itd, 1) = $OrigAddress Then
			
			
			;; Prepare the memory for writing
			$mbi = DllStructCreate($MEMORY_BASIC_INFORMATION)
			DllCall("Kernel32.dll", "ulong", "VirtualQuery", "ptr", DllStructGetPtr($itd, 1), "ptr", DllStructGetPtr($mbi), "ulong", DllStructGetSize($mbi))
			DllCall("Kernel32.dll", "int", "VirtualProtect", "ptr", DllStructGetData($mbi, "BaseAddress"), "ulong", DllStructGetData($mbi, "RegionSize"), "dword", $PAGE_READWRITE, "ptr", DllStructGetPtr($mbi, "Protect"))
			
			;; Here's where the magic happens
			DllStructSetData($itd, 1, $NewProcAddress)

			
			
			$randomdword = DllStructCreate("dword")
			DllCall("Kernel32.dll", "int", "VirtualProtect", "ptr", DllStructGetData($mbi, "BaseAddress"), "ulong", DllStructGetData($mbi, "RegionSize"), _
					"dword", DllStructGetPtr($mbi, "Protect"), "ptr", DllStructGetPtr($randomdword, 1))
			
			
			ExitLoop
		EndIf
		$ptrtoitd += DllStructGetSize($itd)
		$itd = DllStructCreate($IMAGE_THUNK_DATA, $ptrtoitd)
	WEnd
	
	Return $itd
EndFunc   ;==>_AddHookApi

Func _GetProcAddress($hModule, $FunctionName)
	$call = DllCall("Kernel32.dll", "ptr", "GetProcAddress", "ptr", $hModule, "str", $FunctionName)
	Return $call[0]
	

EndFunc   ;==>_GetProcAddress

Func _ChangeHookApi($ITDSTRUCT, $NewProc)
	;; Prepare the memory for writing
	$mbi = DllStructCreate($MEMORY_BASIC_INFORMATION)
	DllCall("Kernel32.dll", "ulong", "VirtualQuery", "ptr", DllStructGetPtr($ITDSTRUCT, 1), "ptr", DllStructGetPtr($mbi), "ulong", DllStructGetSize($mbi))
	DllCall("Kernel32.dll", "int", "VirtualProtect", "ptr", DllStructGetData($mbi, "BaseAddress"), "ulong", DllStructGetData($mbi, "RegionSize"), "dword", $PAGE_READWRITE, "ptr", DllStructGetPtr($mbi, "Protect"))
	
	;; Here's where the magic happens
	DllStructSetData($ITDSTRUCT, 1, $NewProc)

	
	
	$randomdword = DllStructCreate("dword")
	DllCall("Kernel32.dll", "int", "VirtualProtect", "ptr", DllStructGetData($mbi, "BaseAddress"), "ulong", DllStructGetData($mbi, "RegionSize"), _
			"dword", DllStructGetData($mbi, "Protect"), "ptr", DllStructGetPtr($randomdword, 1))
	
EndFunc   ;==>_ChangeHookApi







;;;;; ShellExecuteExW returns an int and has one param - a pointer to a SHELLEXECUTEINFO struct
$MyTest = DllCallbackRegister("MyTest", "int", "ptr")
$MyTestAddress = DllCallbackGetPtr($MyTest)


;; We need to get the original ShellExecuteExW adress so we can revert to it sometime in the future
$orig = _GetProcAddress(_WinAPI_GetModuleHandle("shell32.dll"), "ShellExecuteExW")

; Add the hook and save the "handle" to the hook, we need this to change the hook later on
$hook = _AddHookApi("Shell32.dll", "ShellExecuteExW", $MyTestAddress)

;; Lets try ShellExecute something
ShellExecute(FileOpenDialog("All files", "", "All files (*.*)"))

; Change back to the original ShellExecute
_ChangeHookApi($hook, $orig)


DllCallbackFree($MyTest)


Func MyTest($ptr)
	; SHELLEXECUTEINFO struct
	$SHELLEXECUTEINFO = DllStructCreate("dword;ulong;hwnd;ptr;ptr;ptr;ptr;int;ptr;ptr;ptr;ptr;dword;ptr;ptr;", $ptr)
	$wstring = DllStructCreate("wchar[255]", DllStructGetData($SHELLEXECUTEINFO, 5))
	MsgBox(0, "Shellexecute hook", "AutoIt tried to shellexecute: " & DllStructGetData($wstring, 1) & @CRLF & "However we put a stop to that, didn't we?")
	Return 0
EndFunc   ;==>MyTest