#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         FireFox

 Script Function:
	Avoids the return to the desktop window when clicking on the second screen

#ce ----------------------------------------------------------------------------
Global $blEnabled = False, $sWTitle, $hWnd, $iPId, $aMgp
Global $sWTitleAllowed = "Counter-Strike Source;Modern Warfare 2" ;add here the window title of your fs games

While Sleep(100)
	$aMgp = MouseGetPos()

	If ($aMgp[0] > @DesktopWidth) And ($blEnabled = False) Then
		;if the mouse cursor is on the second screen
		$sWTitle = WinGetTitle("[active]")

		If StringInStr($sWTitleAllowed, $sWTitle) Then
			;if the window title is one of the $sWTitleAllowed
			$hWnd = WinGetHandle($sWTitle)
			$iPId = WinGetProcess($hWnd)

			_ProcessSuspend($iPId)
			;suspend the process in order to avoid the return to the desktop window
			$blEnabled = True
		EndIf
	ElseIf ($aMgp[0] < @DesktopWidth) And ($blEnabled = True) Then
		;if the mouse cursor comes back to the first screen
		MouseClick("left")
		;reactivate the window (otherwise it would make a return to the desktop window :/)
		_ProcessResume($iPId)
		;then resume the process
		$blEnabled = False
	EndIf
WEnd


; #FUNCTION# ====================================================================================================================
; Name...........: _ProcessSuspend
; Description ...: Suspends a process
; Syntax.........: _ProcessSuspend($iPId)
; Parameters ....: $iPId		- Id of the process to suspend
; Return values .: Success      - 1
;				   Failure		- 0
; Author ........: The Kandie Man
; Modified.......: FireFox
; Remarks .......:
; Related .......: _ProcessResume
; Link ..........: http://www.autoitscript.com/forum/topic/32975-process-suspendprocess-resume-udf
; Example .......:
; ===============================================================================================================================
Func _ProcessSuspend($iPId)
	Local $aHandle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPId)
	Local $aSucess = DllCall("ntdll.dll", "int", "NtSuspendProcess", "int", $aHandle[0])
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $aHandle)

	If IsArray($aSucess) Then Return 1
	Return 0
EndFunc   ;==>_ProcessSuspend


; #FUNCTION# ====================================================================================================================
; Name...........: _ProcessResume
; Description ...: Resumes a process
; Syntax.........: _ProcessResume($iPId)
; Parameters ....: $iPId		- Id of the process to resume
; Return values .: Success      - 1
;				   Failure		- 0
; Author ........: The Kandie Man
; Modified.......: FireFox
; Remarks .......:
; Related .......: _ProcessSuspend
; Link ..........: http://www.autoitscript.com/forum/topic/32975-process-suspendprocess-resume-udf
; Example .......:
; ===============================================================================================================================
Func _ProcessResume($iPId)
	Local $aHandle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPId)
	Local $aSucess = DllCall("ntdll.dll", "int", "NtResumeProcess", "int", $aHandle[0])
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $aHandle)

	If IsArray($aSucess) Then Return 1
	Return 0
EndFunc   ;==>_ProcessResume
