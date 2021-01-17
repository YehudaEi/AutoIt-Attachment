; #FUNCTION# ====================================================================================================
; Name...........: _RefreshTrayIcons
; Description ...: Remove Notification Area tray toolbar buttons (icons)
;                  orphaned after an application crash or process close
; Syntax.........: _RefreshTrayIcons()
; Return values .: Success      - deleted button count
;                  Failure      - depending on error -1, 0 or deleted button count, @error and @extended set (see table)
; Author ........: rover 05/04/2009, thanks to Valik's _RefreshSystemTray(), Tuape's SysTray UDF and wraithdu's Shell_NotifyIcon code
; Modified.......:
; Remarks .......: use _RefreshSystemTray() mouse over method in an enterprise environment as it is fail-safe
;                  i.e. no explorer memory access: http://www.autoitscript.com/forum/index.php?showtopic=7404
;                  Not recommended for use in a service.
;                  Disclaimer: accesses the explorer memspace so it will inherently have a risk of an access violation explorer crash
;                  under unforeseen error conditions or third party shell modifications. Personal use only recommended.
;
;                  Synopsis: Each taskbar Notification Area toolbar button/icon has an application
;                  window handle associated with it that receives the notification messages.
;                  This toolbar button removal method is dependent on testing if the handle is invalid.
;                  If the window handle owner process no longer exists the orphaned button can be deleted.
;                  The window handle and application identifier of the icon must match to allow deletion.
;+
;                  Minimum Operating Systems: Windows 2000 - Tested on Win 2000/Win XP/Vista
;                  No 64 bit OS support. Untested on: Win 2003, Win 2008 and Win 7
; Related .......: _RefreshSystemTray()
; Link ..........; @@MsdnLink@@ Shell_NotifyIcon
; Example .......; Yes
;
;Initialization errors
;@error, @extended, Return
;--------------------------------------------------------------------------------
;1, 0, -1 				= 64 bit OS untested
;1, 1, -1 				= OS not supported or untested
;2, 1, -1 To 2, 10, -1	= constant not assigned
;3, 1, -1 To 3, 4,  -1	= invalid taskbar/tray handles
;4, 1, -1 To 4, 10, -1	= error in struct creation
;5, 1, -1 To 5, 3,  -1	= error opening DLL handles
;6, 1, -1 To 6, 6,  -1	= error or invalid data in DLLCall
;183, 183, -1			= Mutex error - instance exists: $ERROR_ALREADY_EXISTS = 183
;
;--------------------------------------------------------------------------------
;
;one or more of these non-critical errors may occur while testing icons in loop
;on error, loop continues to next item  - common errors to see are 2 and 256
;(if UDF called from a loop then icons closed by process or user can generate these errors)
;
;Loop @error BitOR table:
;2						= SendMessage GETBUTTON (error or no icon for given index - closed by other process)
;4						= ReadProcessMemory TBBUTTON (error or invalid data)
;8						= ReadProcessMemory TRAYDATA (error or invalid data)
;16						= DllStructGetData TRAYDATA get hWnd (error or no valid data returned)
;32						= DllStructGetData TRAYDATA get uID  (error or no valid data returned)
;64						= DllStructSetData NOTIFYICONDATA set hWnd (error or struct not set with data)
;128					= DllStructSetData NOTIFYICONDATA set huID (error or struct not set with data)
;256					= Shell_NotifyIconW (error or icon already deleted by other process)
;Cleanup @error BitOR table:
;512					= VirtualFreeEx - error deallocating memory
;1024					= CloseHandle - error closing process handle
;2048					= CloseHandle - error closing mutex handle
;
;Return errors
;@error, @extended, Return
; 0,  0, >=0				= 0 or more buttons deleted, no errors
; 0, -1, >=0				= 0 or more buttons deleted, button count error (icon added or removed from tray by other process)
; 0, -2, >=0				= 0 or more buttons deleted, cannot verify button count (SendMessage error or no tray icons)
; 2 To 4094, 0 To -2, >=0	= 0 or more buttons deleted, OR'ed non-critical loop and cleanup errors
;-1, -1, >=0				= explorer access violation or externally caused crash (tray toolbar no longer exists)
; ===============================================================================================================
Func _RefreshTrayIcons()
	
	#Region - OS check
	;64 bit OS currently untested ;StringCompare(@OSArch, "X86", 0) <> 0
	If @OSArch <> "X86" Then Return SetError(1, 0, -1)

	Select
		Case @OSVersion = "WIN_2000" ; StringCompare(@OSVersion, "WIN_2000", 0) = 0
		Case @OSVersion = "WIN_XP" ; StringCompare(@OSVersion, "WIN_XP", 0) = 0
		Case @OSVersion = "WIN_VISTA" ; StringCompare(@OSVersion, "WIN_VISTA", 0) = 0
			;Case @OSVersion = "WIN_2003"	; StringCompare(@OSVersion, "WIN_2003", 0) = 0
			;Case @OSVersion = "WIN_2008"	; StringCompare(@OSVersion, "WIN_2008", 0) = 0
		Case Else
			Return SetError(1, 1, -1)
	EndSelect

;~ 	Switch @OSVersion
;~ 		Case "WIN_2000", "WIN_XP", "WIN_VISTA";, "WIN_2003", "WIN_2008"
;~ 		Case Else
;~ 			Return SetError(1, 1, -1)
;~ 	EndSwitch
	#EndRegion - OS check

	#Region - Declare constants
	#cs
		#include-once
		#include <ToolbarConstants.au3>
		#include <Constants.au3>
		#include <MemoryConstants.au3>
		
		;remove RefreshTray_ from all constants except these:
		Local Const $RefreshTray_PROCESS_ACCESS = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ)
		;not declared in AutoIt includes as of v3.3.0.0
		Local Const $RefreshTray_ERROR_ALREADY_EXISTS = 183
		Local Const $RefreshTray_NIM_DELETE = 0x2
	#ce
	
	;#cs
	;use include global constants or local constant magic numbers if includes not available
	If Not IsDeclared("TB_GETBUTTON") Then Assign("TB_GETBUTTON", 0x417, 1)
	If Not IsDeclared("TB_BUTTONCOUNT") Then Assign("TB_BUTTONCOUNT", 0x418, 1)
	If Not IsDeclared("PROCESS_VM_OPERATION") Then Assign("PROCESS_VM_OPERATION", 0x00000008, 1)
	If Not IsDeclared("PROCESS_VM_READ") Then Assign("PROCESS_VM_READ", 0x00000010, 1)
	If Not IsDeclared("MEM_COMMIT") Then Assign("MEM_COMMIT", 0x00001000, 1)
	If Not IsDeclared("MEM_RELEASE") Then Assign("MEM_RELEASE", 0x00008000, 1)
	If Not IsDeclared("PAGE_READWRITE") Then Assign("PAGE_READWRITE", 0x00000004, 1)
	If Not IsDeclared("ERROR_ALREADY_EXISTS") Then Assign("ERROR_ALREADY_EXISTS", 183, 1);winerror.h
	If Not IsDeclared("NIM_DELETE") Then Assign("NIM_DELETE", 0x2, 1) ;shellapi.h

	;we are told 'Eval() is Evil', so is Execute() NOT Cute?
	Local Const $RefreshTray_TB_GETBUTTON = Execute("$TB_GETBUTTON")
	If @error Or IsInt($RefreshTray_TB_GETBUTTON) = 0 Or _
			StringLen($RefreshTray_TB_GETBUTTON) = 0 Then Return SetError(2, 1, -1)
	Local Const $RefreshTray_TB_BUTTONCOUNT = Execute("$TB_BUTTONCOUNT")
	If @error Or IsInt($RefreshTray_TB_BUTTONCOUNT) = 0 Or _
			StringLen($RefreshTray_TB_BUTTONCOUNT) = 0 Then Return SetError(2, 2, -1)
	
	Local $iTemp1 = Execute("$PROCESS_VM_OPERATION")
	If @error Or IsInt($iTemp1) = 0 Or StringLen($iTemp1) = 0 Then Return SetError(2, 3, -1)
	Local $iTemp2 = Execute("$PROCESS_VM_READ")
	If @error Or IsInt($iTemp2) = 0 Or StringLen($iTemp2) = 0 Then Return SetError(2, 4, -1)
	Local Const $RefreshTray_PROCESS_ACCESS = BitOR($iTemp1, $iTemp2)
	If @error Or StringLen($RefreshTray_PROCESS_ACCESS) = 0 Then Return SetError(2, 5, -1)
	
	Local Const $RefreshTray_MEM_COMMIT = Execute("$MEM_COMMIT")
	If @error Or IsInt($RefreshTray_MEM_COMMIT) = 0 Or _
			StringLen($RefreshTray_MEM_COMMIT) = 0 Then Return SetError(2, 6, -1)
	Local Const $RefreshTray_MEM_RELEASE = Execute("$MEM_RELEASE")
	If @error Or IsInt($RefreshTray_MEM_RELEASE) = 0 Or _
			StringLen($RefreshTray_MEM_RELEASE) = 0 Then Return SetError(2, 7, -1)
	Local Const $RefreshTray_PAGE_READWRITE = Execute("$PAGE_READWRITE")
	If @error Or IsInt($RefreshTray_PAGE_READWRITE) = 0 Or _
			StringLen($RefreshTray_PAGE_READWRITE) = 0 Then Return SetError(2, 8, -1)
	
	;not declared in AutoIt includes as of v3.3.0.0
	Local Const $RefreshTray_ERROR_ALREADY_EXISTS = Execute("$ERROR_ALREADY_EXISTS")
	If @error Or IsInt($RefreshTray_ERROR_ALREADY_EXISTS) = 0 Or _
			StringLen($RefreshTray_ERROR_ALREADY_EXISTS) = 0 Then Return SetError(2, 9, -1)
	Local Const $RefreshTray_NIM_DELETE = Execute("$NIM_DELETE")
	If @error Or IsInt($RefreshTray_NIM_DELETE) = 0 Or _
			StringLen($RefreshTray_NIM_DELETE) = 0 Then Return SetError(2, 10, -1)
	;#ce
	
	#cs
		;for the magic numbers users
		Local Const $RefreshTray_TB_GETBUTTON = 0x417
		Local Const $RefreshTray_TB_BUTTONCOUNT = 0x418
		Local Const $RefreshTray_PROCESS_ACCESS = BitOR(0x00000008, 0x00000010)
		Local Const $RefreshTray_MEM_COMMIT = 0x00001000
		Local Const $RefreshTray_MEM_RELEASE = 0x00008000
		Local Const $RefreshTray_PAGE_READWRITE = 0x00000004
		;not declared in AutoIt includes as of v3.3.0.0
		Local Const $RefreshTray_ERROR_ALREADY_EXISTS = 183
		Local Const $RefreshTray_NIM_DELETE = 0x2
	#ce
	
	#EndRegion - Declare constants

	#Region - Declare variables
	Local $hOwnerWin, $i_uID, $aRet, $iRet, $iButtonCount = 0, $hTrayWnd, $hTrayNotifyWnd, _
			$hSysPager, $hToolbar, $iCount, $sRes, $iDLLUser32, $iDLLKrnl32, $iDLLShll32, _
			$tTBBUTTON, $pTBBUTTON, $iTBBUTTON, $tTRAYDATA, $pTRAYDATA, $iTRAYDATA, _
			$iProcessID, $hProcess, $pAddress, $iReturnError = 0, $iExtended = 0, $iLastError, $hMutex
	#EndRegion - Declare variables

	#Region - Get tray window handles - Shell_TrayWnd/TrayNotifyWnd/SysPager/ToolbarWindow32
	;get Shell_TrayWnd handle
	$hTrayWnd = WinGetHandle("[CLASS:Shell_TrayWnd]") ; FindWindow
	If @error Or IsHWnd($hTrayWnd) = 0 Then Return SetError(3, 1, -1)
	
	;get TrayNotifyWnd handle
	$hTrayNotifyWnd = ControlGetHandle($hTrayWnd, "", "[CLASS:TrayNotifyWnd]") ;FindWindowEx
	If @error Or IsHWnd($hTrayNotifyWnd) = 0 Then Return SetError(3, 2, -1)

	;get SysPager handle
	If @OSVersion == "WIN_2000" Then
		$hSysPager = $hTrayNotifyWnd
	Else
		$hSysPager = ControlGetHandle($hTrayNotifyWnd, "", "[CLASS:SysPager]");FindWindowEx
		If @error Or IsHWnd($hSysPager) = 0 Then Return SetError(3, 3, -1)
	EndIf
	
	;get tray notification area toolbar handle
	;tray buttons split into two toolbars in Vista :
	;Notification Area (ToolbarWindow321) and System Control Area (ToolbarWindow322)
	$hToolbar = ControlGetHandle($hSysPager, "", "[CLASS:ToolbarWindow32; INSTANCE:1]");FindWindowEx
	If @error Or IsHWnd($hToolbar) = 0 Then Return SetError(3, 4, -1)
	#EndRegion - Get tray window handles - Shell_TrayWnd/TrayNotifyWnd/SysPager/ToolbarWindow32

	#Region - Create Notification Area toolbar button structs TBBUTTON, TRAYDATA and NOTIFYICONDATA
	$sRes = "byte bReserved[2]"
	;64 bit OS support (unfinished, unresearched and untested)
	If Number(StringRight(@OSArch, 2)) = 64 Then $sRes = "byte bReserved[6]"
	;TBBUTTON struct
	Local Const $tag_TBBUTTON = "int iBitmap;int idCommand;byte fsState;byte fsStyle;" & _
			$sRes & ";ulong_ptr dwData;int_ptr iString"
	$tTBBUTTON = DllStructCreate($tag_TBBUTTON)
	If @error Or IsDllStruct($tTBBUTTON) = 0 Then Return SetError(4, 1, -1)
	$pTBBUTTON = DllStructGetPtr($tTBBUTTON)
	If @error Or IsPtr($pTBBUTTON) = 0 Then Return SetError(4, 2, -1)
	$iTBBUTTON = DllStructGetSize($tTBBUTTON)
	If @error Or $iTBBUTTON = 0 Then Return SetError(4, 3, -1)

	;TRAYDATA struct (undocumented)
	Local Const $tag_TRAYDATA = "hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];ptr hIcon"
	$tTRAYDATA = DllStructCreate($tag_TRAYDATA)
	If @error Or IsDllStruct($tTRAYDATA) = 0 Then Return SetError(4, 4, -1)
	$pTRAYDATA = DllStructGetPtr($tTRAYDATA)
	If @error Or IsPtr($pTRAYDATA) = 0 Then Return SetError(4, 5, -1)
	$iTRAYDATA = DllStructGetSize($tTRAYDATA)
	If @error Or $iTRAYDATA = 0 Then Return SetError(4, 6, -1)
	
	;NOTIFYICONDATA struct
	Local $tagNOTIFYICONDATA = "dword cbSize;hwnd hWnd;uint uID;uint uFlags;" & _
			"uint uCallbackMessage;ptr hIcon;wchar szTip[128];dword dwState;dword dwStateMask;" & _
			"wchar szInfo[256];uint uTimeout;wchar szInfoTitle[64];dword dwInfoFlags"
	Switch @OSVersion
		Case "WIN_XP" ;GUID
			$tagNOTIFYICONDATA &= ";int Data1;short Data2;short Data3;byte Data4[8]"
		Case "WIN_VISTA" ;GUID and balloon tip icon
			$tagNOTIFYICONDATA &= ";int Data1;short Data2;short Data3;byte Data4[8];ptr hBalloonIcon"
	EndSwitch

	Local $tNOTIFYICONDATA = DllStructCreate($tagNOTIFYICONDATA)
	If @error Or IsDllStruct($tNOTIFYICONDATA) = 0 Then Return SetError(4, 7, -1)
	Local $pNOTIFYICONDATA = DllStructGetPtr($tNOTIFYICONDATA)
	If @error Or IsPtr($pNOTIFYICONDATA) = 0 Then Return SetError(4, 8, -1)
	Local $iNOTIFYICONDATA = DllStructGetSize($tNOTIFYICONDATA)
	If @error Or $iNOTIFYICONDATA = 0 Then Return SetError(4, 9, -1)
	$iRet = DllStructSetData($tNOTIFYICONDATA, "cbSize", $iNOTIFYICONDATA)
	If @error Or $iRet <> $iNOTIFYICONDATA Then Return SetError(4, 10, -1)
	
	#EndRegion - Create Notification Area toolbar button structs TBBUTTON, TRAYDATA and NOTIFYICONDATA

	#Region - Open handles to user32.dll and kernel32.dll
	$iDLLUser32 = DllOpen("user32.dll")
	If @error Or $iDLLUser32 = -1 Then Return SetError(5, 1, -1)
	$iDLLKrnl32 = DllOpen("kernel32.dll")
	If @error Or $iDLLKrnl32 = -1 Then Return SetError(5, 2, -1)
	#EndRegion - Open handles to user32.dll and kernel32.dll

	#Region - Single instance check - (_Singleton)
	;this function could be called from a script, and we need to close the mutex handle on return
	;so by placing instance check here, fewer close mutex handle calls are needed on return from error
	$aRet = DllCall($iDLLKrnl32, "ptr", "CreateMutexW", "int", 0, "long", 1, "wstr", "RefreshTrayIcons2357")
	If @error Or UBound($aRet) <> 4 Or $aRet[0] = 0 Then
		DllClose($iDLLUser32)
		DllClose($iDLLKrnl32)
		Return SetError(6, 1, -1)
	EndIf
	$hMutex = $aRet[0]
	
	$aRet = DllCall($iDLLKrnl32, "int", "GetLastError")
	If @error Or UBound($aRet) <> 1 Then
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hMutex)
		DllClose($iDLLUser32)
		DllClose($iDLLKrnl32)
		Return SetError(6, 2, -1)
	EndIf
	$iLastError = $aRet[0]
	
	;instance of program already running
	If $iLastError = $RefreshTray_ERROR_ALREADY_EXISTS Then
		ConsoleWrite("! CreateMutex - GetLastError: " & $iLastError & @CRLF)
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hMutex)
		DllClose($iDLLUser32)
		DllClose($iDLLKrnl32)
		Return SetError($iLastError, $iLastError, -1)
	EndIf

	#EndRegion - Single instance check - (_Singleton)

	#Region - Get explorer.exe process ID/handle, allocate memory, get toolbar button count
	;get explorer.exe process ID
	$aRet = DllCall($iDLLUser32, "int", "GetWindowThreadProcessId", "hwnd", $hToolbar, "int*", -1)
	If @error Or UBound($aRet) <> 3 Or $aRet[2] <= 0 Then
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hMutex)
		DllClose($iDLLUser32)
		DllClose($iDLLKrnl32)
		Return SetError(6, 3, -1)
	EndIf
	$iProcessID = $aRet[2]

	;get handle to explorer process
	$aRet = DllCall($iDLLKrnl32, "ptr", "OpenProcess", "dword", _
			$RefreshTray_PROCESS_ACCESS, "int", 0, "int", $iProcessID)
	If @error Or UBound($aRet) <> 4 Or $aRet[0] = 0 Then
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hMutex)
		DllClose($iDLLUser32)
		DllClose($iDLLKrnl32)
		Return SetError(6, 4, -1)
	EndIf
	$hProcess = $aRet[0]
	
	;get tray toolbar button count (visible and hidden inactive)
	$aRet = DllCall($iDLLUser32, "lparam", "SendMessage", "hwnd", _
			$hToolbar, "int", $RefreshTray_TB_BUTTONCOUNT, "wparam", 0, "lparam", 0)
	If @error Or UBound($aRet) <> 5 Or $aRet[0] < 1 Then
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hProcess)
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hMutex)
		DllClose($iDLLUser32)
		DllClose($iDLLKrnl32)
		Return SetError(6, 5, -1)
	EndIf
	$iCount = $aRet[0] - 1
	
	;allocate memory in explorer memspace
	$aRet = DllCall($iDLLKrnl32, "ptr", "VirtualAllocEx", "ptr", $hProcess, "ptr", 0, "int", _
			$iTBBUTTON, "dword", $RefreshTray_MEM_COMMIT, "dword", $RefreshTray_PAGE_READWRITE)
	If @error Or UBound($aRet) <> 6 Or $aRet[0] = 0 Then
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hProcess)
		DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hMutex)
		DllClose($iDLLUser32)
		DllClose($iDLLKrnl32)
		Return SetError(6, 6, -1)
	EndIf
	$pAddress = $aRet[0]
	
	;open shell32 dll handle for Shell_NotifyIconW API in loop
	$iDLLShll32 = DllOpen("shell32.dll")
	If @error Or $iDLLShll32 = -1 Then Return SetError(5, 3, -1)
	
	#EndRegion - Get explorer.exe process ID/handle, allocate memory, get toolbar button count

	#Region - Loop through toolbar buttons and check if owner window/process exists
	For $iID = $iCount To 0 Step -1
		
		;check if toolbar exists (explorer crash)
		If IsHWnd($hToolbar) = 0 Then
			$iReturnError = -1
			ExitLoop
		EndIf

		;fill explorer process allocated memory with TBBUTTON struct data
		;for zero-based toolbar button index
		$aRet = DllCall($iDLLUser32, "lparam", "SendMessage", "hwnd", $hToolbar, _
				"int", $RefreshTray_TB_GETBUTTON, "wparam", $iID, "lparam", $pAddress)
		If @error Or UBound($aRet) <> 5 Or $aRet[0] <> 1 Then
			$iReturnError = BitOR($iReturnError, 2)
			ContinueLoop
		EndIf

		;read TBBUTTON struct data from explorer process memory into TBBUTTON struct
		$aRet = DllCall($iDLLKrnl32, "int", "ReadProcessMemory", "ptr", $hProcess, _
				"ptr", $pAddress, "ptr", $pTBBUTTON, "int", $iTBBUTTON, "int*", -1)
		If @error Or UBound($aRet) <> 6 Or $aRet[5] <> $iTBBUTTON Then
			$iReturnError = BitOR($iReturnError, 4)
			ContinueLoop
		EndIf
		
		;use extra data pointer to read TRAYDATA struct in explorer process memory
		;into TRAYDATA struct
		$aRet = DllCall($iDLLKrnl32, "int", "ReadProcessMemory", "ptr", $hProcess, _
				"ulong_ptr", DllStructGetData($tTBBUTTON, "dwData"), _
				"ptr", $pTRAYDATA, "int", $iTRAYDATA, "int*", -1)
		If @error Or UBound($aRet) <> 6 Or $aRet[5] <> $iTRAYDATA Then
			$iReturnError = BitOR($iReturnError, 8)
			ContinueLoop
		EndIf

		;get button/icon owner window handle from TRAYDATA struct
		$hOwnerWin = DllStructGetData($tTRAYDATA, 1)
		If @error Or $hOwnerWin = 0 Then
			$iReturnError = BitOR($iReturnError, 16)
			ContinueLoop
		EndIf
		
		;get button/icon owner window application defined identifier from TRAYDATA struct
		$i_uID = DllStructGetData($tTRAYDATA, 2)
		If @error Or $i_uID < 0 Then
			$iReturnError = BitOR($iReturnError, 32)
			ContinueLoop
		EndIf

		;ConsoleWrite('+$i_uID = ' & $i_uID & @crlf) ;debug only, Consolewrites() slow loops
		
		;get owner process PID for associated tray button/icon handle, continue loop if process exists
		$aRet = DllCall($iDLLUser32, "int", "GetWindowThreadProcessId", "hwnd", $hOwnerWin, "int*", -1)
		If @error Or UBound($aRet) <> 3 Or $aRet[2] = -1 Then
			;second check: continue loop if data is not pointer or is pointer and a valid window handle
			If IsPtr($hOwnerWin) = 0 Or IsHWnd($hOwnerWin) = 1 Then ContinueLoop
		Else
			ContinueLoop
		EndIf
		
		;set NOTIFYICONDATA struct hWnd element to button/icon owner window
		$iRet = DllStructSetData($tNOTIFYICONDATA, "hWnd", $hOwnerWin)
		If @error Or IsPtr($iRet) = 0 Then
			$iReturnError = BitOR($iReturnError, 64)
			ContinueLoop
		EndIf
		
		;set NOTIFYICONDATA struct uID element to button/icon application identifier
		$iRet = DllStructSetData($tNOTIFYICONDATA, "uID", $i_uID)
		If @error Or $iRet <> $i_uID Then
			$iReturnError = BitOR($iReturnError, 128)
			ContinueLoop
		EndIf

		;remove orphaned button/icon from toolbar
		;requires matching handle and application defined identifier set to delete button
		;Note: some icons have a uID value of 0 or 1.
		;The value set depends on app developer, view $i_uID with ConsoleWrite()
		;e.g. 4 hidden explorer icons in XP have uID range 4294967292-4294967295
		$aRet = DllCall($iDLLShll32, "int", "Shell_NotifyIconW", "dword", _
				$RefreshTray_NIM_DELETE, "ptr", $pNOTIFYICONDATA)
		If @error Or UBound($aRet) <> 3 Or $aRet[0] <> 1 Then
			$iReturnError = BitOR($iReturnError, 256)
		Else
			$iButtonCount += $aRet[0]
		EndIf
		
	Next
	#EndRegion - Loop through toolbar buttons and check if owner window/process exists

	#Region - Cleanup: check button count, free memory, close process/mutex/DLL handles
	;set @extended to button count verify error
	;get tray toolbar button count (visible and hidden inactive)
	;can only report number of buttons deleted, not if orphaned buttons missed in loop due to errors
	If $iReturnError <> -1 Then ; bypass button count if explorer tray toolbar handle invalid
		$aRet = DllCall($iDLLUser32, "lparam", "SendMessage", "hwnd", _
				$hToolbar, "int", $RefreshTray_TB_BUTTONCOUNT, "wparam", 0, "lparam", 0)
		If @error = 0 And UBound($aRet) = 5 And $aRet[0] >= 1 Then
			If ($iCount + 1) = ($aRet[0] + $iButtonCount) Then
				;current button count + deleted count equal to previous button count
				$iExtended = 0
			Else
				;current button count and deleted count not equal to previous button count
				;either returned deleted button count incorrect due to loop error or
				;buttons added or deleted by other processes before function returned
				$iExtended = -1
			EndIf
		Else
			;cannot verify deleted button count
			$iExtended = -2
		EndIf
	Else
		$iExtended = -1
	EndIf

	;deallocate the memory and close process/mutex handles
	$aRet = DllCall($iDLLKrnl32, "int", "VirtualFreeEx", "ptr", $hProcess, "ptr", _
			$pAddress, "int", 0, "dword", $RefreshTray_MEM_RELEASE)
	If @error Or UBound($aRet) <> 5 Or $aRet[0] = 0 Then $iReturnError = BitOR($iReturnError, 512)

	$aRet = DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hProcess)
	If @error Or UBound($aRet) <> 2 Or $aRet[0] = 0 Then $iReturnError = BitOR($iReturnError, 1024)

	$aRet = DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hMutex)
	If @error Or UBound($aRet) <> 2 Or $aRet[0] <> 1 Then $iReturnError = BitOR($iReturnError, 2048)
	
	;close open DLL handles
	DllClose($iDLLShll32)
	DllClose($iDLLUser32)
	DllClose($iDLLKrnl32)
	#EndRegion - Cleanup: check button count, free memory, close process/mutex/DLL handles

	Return SetError($iReturnError, $iExtended, $iButtonCount)

EndFunc   ;==>_RefreshTrayIcons
