#AutoIt3Wrapper_UseX64=y
#NoTrayIcon

Global $ret = _RefreshNotificationAreaIcons(0);User Promoted Notification Area/Notification Area - Win7-2008R2/Vista
ConsoleWrite("+User Promoted Notification Area/Notification Area: " & $ret & @LF)
$ret = _RefreshNotificationAreaIcons(1);Overflow Notification Area - Win7-2008R2
ConsoleWrite("+Overflow Notification Area: " & $ret & @LF)
$ret = _RefreshNotificationAreaIcons(2);System Promoted Notification Area - Win7-2008R2
;(system clears these after 30 seconds anyway)
ConsoleWrite("+System Promoted Notification Area: " & $ret & @LF)


; #FUNCTION# ====================================================================================================
; Name...........: _RefreshNotificationAreaIcons
; Description ...: Remove Notification Area toolbar buttons (icons) orphaned after an application crash or process close
;                  Removes icons from all three Notification areas in Win 7/Server 2008R2 32/64 bit versions
; Syntax.........: _RefreshNotificationAreaIcons(0) - User Promoted Notification Area/Notification Area - Win7-2008R2/Vista
;                  _RefreshNotificationAreaIcons(1) - Overflow Notification Area - Win7-2008R2
;                  _RefreshNotificationAreaIcons(2) - System Promoted Notification Area (system clears these after 30 seconds anyway) - Win7-2008R2
; Return values .: Success      Removed icon count
;                  Failure      0 sets error
; Author ........: rover 28/11/2011 - update of _RefreshTrayIcon()
; Modified.......:
; Remarks .......: Cannot be called from a service.
;                  Synopsis: Each taskbar Notification Area toolbar button/icon has an applications
;                  window handle associated with it that receives notification messages from user interaction with the icon.
;                  This toolbar button removal method tests if the handle is no longer valid,
;                  and uses the MS recommended API Shell_NotifyIcon to remove them.
;                  The Shell_NotifyIcon API requires a matching window handle and application identifier to allow icon deletion.
;
;                  Minimum Operating Systems: Vista, Win 2008, Win 7, Win 2008R2
;                  64 bit OS support. Tested on: Win 7, Win 2008R2
; Related .......: _RefreshTrayIcon() (for 32 bit Win2k, XP and Vista), _RefreshSystemTray()
; Link ..........; @@MsdnLink@@ Shell_NotifyIcon
; Example .......; Yes
;
; ===============================================================================================================
Func _RefreshNotificationAreaIcons($iTbar = 0)
	Switch @OSVersion
		Case "WIN_2000", "WIN_XP", "WIN_2003", "WIN_XPe"
			Return SetError(1, 1, 0)
	EndSwitch
	Local $hOwnerWin, $i_uID, $aRet, $iRet, $hTrayNotifyWnd, $iButtonCount = 0, _
			$hToolbar, $iCount, $iDLLUser32, $iDLLKrnl32, $iDLLShll32, _
			$tTBBUTTON, $pTBBUTTON, $iTBBUTTON, $tTRAYDATA, $pTRAYDATA, $iTRAYDATA, _
			$tNOTIFYICONDATA, $pNOTIFYICONDATA, $iProcessID, $hProcess, $pAddress
	$hTrayNotifyWnd = ControlGetHandle(WinGetHandle("[CLASS:Shell_TrayWnd]"), "", "[CLASS:TrayNotifyWnd]")
	Switch $iTbar
		Case 0
			$hToolbar = ControlGetHandle(ControlGetHandle($hTrayNotifyWnd, "", "[CLASS:SysPager]"), "", "[CLASS:ToolbarWindow32; INSTANCE:1]")
		Case 1
			$hToolbar = ControlGetHandle(WinGetHandle("[CLASS:NotifyIconOverflowWindow]"), "", "[CLASS:ToolbarWindow32; INSTANCE:1]")
		Case 2
			$hToolbar = ControlGetHandle($hTrayNotifyWnd, "", "[CLASS:ToolbarWindow32; INSTANCE:2]")
	EndSwitch
	$aRet = DllCall("user32.dll", "lparam", "SendMessageW", "hwnd", $hToolbar, "int", 0x418, "wparam", 0, "lparam", 0)
	If @error Or $aRet[0] < 1 Then Return SetError(2, @error, 0)
	$iCount = $aRet[0] - 1
	$iProcessID = WinGetProcess($hToolbar)
	If @error Or $iProcessID = -1 Then Return SetError(3, @error, 0)
	$aRet = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", 0x00000018, "int", 0, "int", $iProcessID)
	If @error Or $aRet[0] = 0 Then Return SetError(4, @error, 0)
	$hProcess = $aRet[0]
	$tTBBUTTON = DllStructCreate("int;int;byte;byte;align;dword_ptr;int_ptr")
	$pTBBUTTON = DllStructGetPtr($tTBBUTTON)
	$iTBBUTTON = DllStructGetSize($tTBBUTTON)
	If @error Or $iTBBUTTON = 0 Then Return SetError(5, @error, 0)
	$aRet = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "ptr", $hProcess, "ptr", 0, "int", $iTBBUTTON, "dword", 0x00001000, "dword", 0x00000004)
	If @error Or $aRet[0] = 0 Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProcess)
		Return SetError(6, @error, 0)
	EndIf
	$pAddress = $aRet[0]
	$iDLLUser32 = DllOpen("user32.dll")
	$iDLLKrnl32 = DllOpen("kernel32.dll")
	$iDLLShll32 = DllOpen("shell32.dll")
	$tTRAYDATA = DllStructCreate("hwnd;uint;uint;dword[2];ptr")
	$pTRAYDATA = DllStructGetPtr($tTRAYDATA)
	$iTRAYDATA = DllStructGetSize($tTRAYDATA)
	$tNOTIFYICONDATA = DllStructCreate("dword;hwnd;uint;uint;uint;ptr;wchar[128];dword;dword;wchar[256];uint;wchar[64];dword;int;short;short;byte[8];ptr")
	$pNOTIFYICONDATA = DllStructGetPtr($tNOTIFYICONDATA)
	DllStructSetData($tNOTIFYICONDATA, 1, DllStructGetSize($tNOTIFYICONDATA))
	For $iID = $iCount To 0 Step -1
		If IsHWnd($hToolbar) = False Then ExitLoop
		$aRet = DllCall($iDLLUser32, "lparam", "SendMessageW", "hwnd", $hToolbar, "int", 0x417, "wparam", $iID, "lparam", $pAddress)
		If @error Or $aRet[0] <> 1 Then ContinueLoop
		$aRet = DllCall($iDLLKrnl32, "int", "ReadProcessMemory", "ptr", $hProcess, "ptr", $pAddress, "ptr", $pTBBUTTON, "int", $iTBBUTTON, "int*", -1)
		If @error Or $aRet[5] <> $iTBBUTTON Then ContinueLoop
		$aRet = DllCall($iDLLKrnl32, "int", "ReadProcessMemory", "ptr", $hProcess, "dword_ptr", DllStructGetData($tTBBUTTON, 5), "ptr", $pTRAYDATA, "int", $iTRAYDATA, "int*", -1)
		If @error Or $aRet[5] <> $iTRAYDATA Then ContinueLoop
		$hOwnerWin = DllStructGetData($tTRAYDATA, 1)
		If @error Or $hOwnerWin = 0 Then ContinueLoop
		If IsPtr($hOwnerWin) = 0 Or IsHWnd($hOwnerWin) = True Then ContinueLoop
		$i_uID = DllStructGetData($tTRAYDATA, 2)
		If @error Or $i_uID < 0 Then ContinueLoop
		$iRet = WinGetProcess($hOwnerWin)
		If @error Or $iRet <> -1 Then ContinueLoop
		DllStructSetData($tNOTIFYICONDATA, 2, $hOwnerWin)
		DllStructSetData($tNOTIFYICONDATA, 3, $i_uID)
		$aRet = DllCall($iDLLShll32, "int", "Shell_NotifyIconW", "dword", 0x2, "ptr", $pNOTIFYICONDATA)
		If @error Or $aRet[0] <> 1 Then ContinueLoop
		$iButtonCount += $aRet[0]
	Next
	DllCall($iDLLKrnl32, "int", "VirtualFreeEx", "ptr", $hProcess, "ptr", $pAddress, "int", 0, "dword", 0x00008000)
	DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hProcess)
	DllClose($iDLLShll32)
	DllClose($iDLLUser32)
	DllClose($iDLLKrnl32)
	Return SetError(0, 0, $iButtonCount)
EndFunc   ;==>_RefreshNotificationAreaIcons