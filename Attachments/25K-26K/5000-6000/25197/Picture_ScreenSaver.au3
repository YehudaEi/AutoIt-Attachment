#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=d3mon Corporation\Autoit\ICON\SHELL32\016_shell32.ico
#AutoIt3Wrapper_outfile=Picture ScreenSaver.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Pictures ScreenSaver
#AutoIt3Wrapper_Res_Description=d3mon Corporation
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=d3mon Corporation. All rights reserved.
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Local $sav = @TempDir & '\ScreenSaver.cfg', $lticks
Local $w = @DesktopWidth, $h = @DesktopHeight, $sPath = FileReadLine($sav, 1)
Opt('GUIOnEventMode', 1)

#Region Check cfg
If Not FileExists($sav) Then
	FileWrite($sav, RegRead('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'My Pictures') & '\')
	FileWrite($sav, @CRLF & '2000')
	FileWrite($sav, @CRLF & '.bmp|.jpg|.gif')
EndIf
#EndRegion Check cfg
;

#Region Pref GUI
$PGUI = GUICreate('Picture Screen Saver - d3monCorp', 260, 150, -1, -1, BitOR(0x00040000, 0x00000080))
GUISetOnEvent(-3, '_PrefClose')

GUICtrlCreateGroup('Pictures folder', 5, 5, 245, 42)
$p_pic = GUICtrlCreateEdit(FileReadLine($sav, 1), 10, 20, 170, 20, 2048 + 128)
GUICtrlCreateButton('Browse', 190, 20, 50, 20)
GUICtrlSetOnEvent(-1, '_Browse')

GUICtrlCreateGroup('Display picture extension...', 5, 50, 155, 40)
$bmp = GUICtrlCreateCheckbox('.bmp', 15, 65)
$jpg = GUICtrlCreateCheckbox('.jpg', 70, 65)
$gif = GUICtrlCreateCheckbox('.gif', 120, 65)

GUICtrlCreateGroup('Display time', 170, 50, 80, 40)
$tdisp = GUICtrlCreateEdit(FileReadLine($sav, 2), 180, 67, 60, 17, 8192 + 128)

GUICtrlCreateButton('Apply', 80, 100, 80, 20)
GUICtrlSetOnEvent(-1, '_PrefApply')
GUISetState(@SW_HIDE, $PGUI)
#EndRegion Pref GUI
;

If Not @Compiled Then ;Run ScreenSaver if not compiled
	_WinAPI_ShowCursor(0)
	_ScreenSaverPicture($w, $h)
Else
	If Not $CmdLine[0] Then Exit ConsoleWrite('!> $CmdLine[0]' & @CRLF) ;Exit if no CmdLine
	
	If StringInStr($CmdLine[1], '/p') Then
		If $CmdLine[0] < 2 Then Exit MsgBox(48, 'Picture scr', 'Invalid preview window information supplied.')
		$parent_PID = _ProcessGetParent(@AutoItPID)
		_ScreenSaverPicture(152, 112, HWnd($CmdLine[2]))
	ElseIf StringInStr($CmdLine[1], '/s') Then
		_WinAPI_ShowCursor(0)
		_ScreenSaverPicture($w, $h)
	Else
		_PrefOpen()
	EndIf
EndIf

#Region Pref Func
Func _Browse()
	$path = FileSelectFolder('Select picture folder', @MyDocumentsDir, 1 + 2)
	If @error Then Exit ConsoleWrite('!> FileSelectFolder' & @CRLF)
	GUICtrlSetData($p_pic, $path & '\')
EndFunc   ;==>_Browse

Func _PrefApply()
	FileDelete($sav)
	FileWrite($sav, GUICtrlRead($p_pic))
	If (GUICtrlRead($tdisp) <> '') Then FileWrite($sav, @CRLF & GUICtrlRead($tdisp) & @CRLF)
	If (GUICtrlRead($tdisp) = '') Then FileWrite($sav, @CRLF & '2000' & @CRLF)
	If (GUICtrlRead($bmp) = 1) Then FileWrite($sav, '.bmp|')
	If (GUICtrlRead($jpg) = 1) Then FileWrite($sav, '.jpg|')
	If (GUICtrlRead($gif) = 1) Then FileWrite($sav, '.gif|')
	Return Call('_PrefClose')
EndFunc   ;==>_PrefApply

Func _PrefOpen()
	GUICtrlSetData($p_pic, FileReadLine($sav, 1))
	GUICtrlSetData($tdisp, FileReadLine($sav, 2))
	$sExt = StringSplit(FileReadLine($sav, 3), '|')
	
	#Region Reset checkbox
	GUICtrlSetState($bmp, 4)
	GUICtrlSetState($jpg, 4)
	GUICtrlSetState($gif, 4)
	#EndRegion Reset checkbox
	
	For $i = 1 To UBound($sExt) - 1
		If ($sExt[$i] = '.bmp') Then
			GUICtrlSetState($bmp, 1)
		ElseIf ($sExt[$i] = '.jpg') Then
			GUICtrlSetState($jpg, 1)
		ElseIf ($sExt[$i] = '.gif') Then
			GUICtrlSetState($gif, 1)
		EndIf
	Next
	GUISetState(@SW_SHOW, $PGUI)
EndFunc   ;==>_PrefOpen

Func _PrefClose()
	Exit GUISetState(@SW_HIDE, $PGUI)
EndFunc   ;==>_PrefClose
#EndRegion Pref Func
;

While 1
	Sleep(250)
WEnd

Func OnAutoItExit()
	_WinAPI_ShowCursor(1)
EndFunc   ;==>OnAutoItExit


; #FUNCTION# ====================================================================================================================
; Name...........: _ScreenSaverPicture
; Author ........: FireFox
; ===============================================================================================================================
Func _ScreenSaverPicture($width, $height, $hwnd = 'Screen Saver')
	If ($hwnd = 'Screen Saver') Then
		$GUI = GUICreate('Screen Saver', @DesktopWidth, @DesktopHeight, 0, 0, 0x80000000)
		GUISetBkColor(0x000000, $GUI)
		GUISetState(@SW_SHOW, $GUI)
		WinSetOnTop($GUI, '', 1)
	EndIf
	$CGUI = GUICreate('Screen Saver', $width, $height, 0, 0, 0x80000000, 0x00000008, $hwnd)
	_WinAPI_SetParent($CGUI, $hwnd)
	$PIC = GUICtrlCreatePic('', 0, 0, $width, $height)
	GUISetBkColor(0x000000, $CGUI)
	GUISetState(@SW_SHOW, $CGUI)
	
	Local $s_path = FileReadLine($sav, 1)
	Local $n_disp = FileReadLine($sav, 2)
	Local $bmp = False, $jpg = False, $gif = False
	$sExt = StringSplit(FileReadLine($sav, 3), '|')
	
	For $i = 1 To UBound($sExt) - 1
		If ($sExt[$i] = '.bmp') Then
			$bmp = True
		ElseIf ($sExt[$i] = '.jpg') Then
			$jpg = True
		ElseIf ($sExt[$i] = '.gif') Then
			$gif = True
		EndIf
	Next
	
	While 1
		$check = FileFindFirstFile($s_path & '*.*')
		If $check = -1 Then Exit ConsoleWrite('!> FileFindFirstFile' & Chr(13))
		While 1
			Sleep(300)
			$sNext = FileFindNextFile($check)
			If @error Then ExitLoop ;Go to the first file
			$s_Ext = StringRegExpReplace($sNext, '^.*\.', '')
			
			If ($hwnd = 'Screen Saver') Then
				If _IdleTicks() Then Exit ;Mouse/Keyboard event
			Else
				$child_PID = _ProcessGetChildren($parent_PID)
				If $child_PID[0] > 1 Then Exit ;Another ss selected
				If Not WinExists($hwnd) Then Exit
			EndIf
			
			If ($s_Ext = 'bmp') And $bmp = True Then
				__SetPicture($CGUI, $PIC, $s_path & $sNext, $n_disp, $hwnd)
			ElseIf ($s_Ext = 'jpg') And $jpg = True Then
				__SetPicture($CGUI, $PIC, $s_path & $sNext, $n_disp, $hwnd)
			ElseIf ($s_Ext = 'gif') And $gif = True Then
				__SetPicture($CGUI, $PIC, $s_path & $sNext, $n_disp, $hwnd)
			EndIf
		WEnd
		ConsoleWrite('!> FileFindNextFile' & Chr(13))
	WEnd
EndFunc   ;==>_ScreenSaverPicture

Func __SetPicture($hGUI, $ID, $p_path, $idisp, $hwnd)
	GUICtrlSetImage($ID, $p_path)
	_WinAnimate($hGUI, Random(1, 10, 1), 1, 700)
	$Init = TimerInit()
	While 1
		Sleep(300)
		If ($hwnd = 'Screen Saver') Then
			If _IdleTicks() Then Exit ;Mouse/Keyboard event
		Else
			$child_PID = _ProcessGetChildren($parent_PID)
			If $child_PID[0] > 1 Then Exit ;Another ss selected
			If Not WinExists($hwnd) Then Exit
		EndIf
		If TimerDiff($Init) > $idisp Then ExitLoop
	WEnd
	_WinAnimate($hGUI, Random(1, 10, 1), 2, 500)
EndFunc   ;==>__SetPicture

; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_SetParent
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Func _WinAPI_SetParent($hWndChild, $hWndParent)
	Local $aResult

	$aResult = DllCall("User32.dll", "hwnd", "SetParent", "hwnd", $hWndChild, "hwnd", $hWndParent)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_SetParent
; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_ShowCursor
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================
Func _WinAPI_ShowCursor($fShow)
	Local $aResult
	$aResult = DllCall('User32.dll', 'int', 'ShowCursor', 'int', $fShow)
	If @error Then Return SetError(@error, 0, 0)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_ShowCursor

; #FUNCTION# ====================================================================================================================
; Name...........: _WinAnimate
; Author ........: FireFox
; ===============================================================================================================================
Func _WinAnimate($hGUI, $Style = 1, $Ani = 1, $n_speed = 250)
	Local $sIN = StringSplit('80000,40001,40002,40004,40008,40005,40006,40009,4000A,40010', ',')
	Local $sOUT = StringSplit('90000,50002,50001,50008,50004,5000A,50009,50006,50005,50010', ',')
	If $Ani = 1 Then
		DllCall('user32.dll', 'int', 'AnimateWindow', 'hwnd', $hGUI, 'int', $n_speed, 'long', '0x000' & $sIN[$Style])
	ElseIf $Ani = 2 Then
		DllCall('user32.dll', 'int', 'AnimateWindow', 'hwnd', $hGUI, 'int', $n_speed, 'long', '0x000' & $sOUT[$Style])
	EndIf
EndFunc   ;==>_WinAnimate

; #FUNCTION# ====================================================================================================================
; Name...........: _IdleTicks
; Author ........: erifash, FireFox
; ===============================================================================================================================
Func _IdleTicks()
	Local $aTSB = DllCall('kernel32.dll', 'long', 'GetTickCount')
	Local $ticksSinceBoot = $aTSB[0]
	Local $struct = DllStructCreate('uint;dword')
	DllStructSetData($struct, 1, DllStructGetSize($struct))
	DllCall('user32.dll', 'int', 'GetLastInputInfo', 'ptr', DllStructGetPtr($struct))
	Local $ticksSinceIdle = DllStructGetData($struct, 2)
	If ($ticksSinceBoot - $ticksSinceIdle) < $lticks Then Return 1
	$lticks = ($ticksSinceBoot - $ticksSinceIdle)
EndFunc   ;==>_IdleTicks

; #FUNCTION# ====================================================================================================================
; Name...........: _ProcessGetParent
; Author ........: SmOke_N
; ===============================================================================================================================
Func _ProcessGetParent($i_pid)
	Local $TH32CS_SNAPPROCESS = 0x00000002
	
	Local $a_tool_help = DllCall('Kernel32.dll', 'long', 'CreateToolhelp32Snapshot', 'int', $TH32CS_SNAPPROCESS, 'int', 0)
	If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_pid)
	
	Local $tagPROCESSENTRY32 = _
			DllStructCreate( _
			'dword dwsize;' & _
			'dword cntUsage;' & _
			'dword th32ProcessID;' & _
			'uint th32DefaultHeapID;' & _
			'dword th32ModuleID;' & _
			'dword cntThreads;' & _
			'dword th32ParentProcessID;' & _
			'long pcPriClassBase;' & _
			'dword dwFlags;' & _
			'char szExeFile[260]' _
			)
	DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))
	
	Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
	
	Local $a_pfirst = DllCall('Kernel32.dll', 'int', 'Process32First', 'long', $a_tool_help[0], 'ptr', $p_PROCESSENTRY32)
	If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_pid)
	
	Local $a_pnext, $i_return = 0
	If DllStructGetData($tagPROCESSENTRY32, 'th32ProcessID') = $i_pid Then
		$i_return = DllStructGetData($tagPROCESSENTRY32, 'th32ParentProcessID')
		DllCall('Kernel32.dll', 'int', 'CloseHandle', 'long', $a_tool_help[0])
		If $i_return Then Return $i_return
		Return $i_pid
	EndIf
	
	While @error = 0
		$a_pnext = DllCall('Kernel32.dll', 'int', 'Process32Next', 'long', $a_tool_help[0], 'ptr', $p_PROCESSENTRY32)
		If DllStructGetData($tagPROCESSENTRY32, 'th32ProcessID') = $i_pid Then
			$i_return = DllStructGetData($tagPROCESSENTRY32, 'th32ParentProcessID')
			If $i_return Then ExitLoop
			$i_return = $i_pid
			ExitLoop
		EndIf
	WEnd
	DllCall('Kernel32.dll', 'int', 'CloseHandle', 'long', $a_tool_help[0])
	Return $i_return
EndFunc   ;==>_ProcessGetParent

; #FUNCTION# ====================================================================================================================
; Name...........: _ProcessGetChildren
; Author ........: SmOke_N
; ===============================================================================================================================
Func _ProcessGetChildren($i_pid)
	Local Const $TH32CS_SNAPPROCESS = 0x00000002
	
	Local $a_tool_help = DllCall('Kernel32.dll', 'long', 'CreateToolhelp32Snapshot', 'int', $TH32CS_SNAPPROCESS, 'int', 0)
	If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_pid)
	
	Local $tagPROCESSENTRY32 = _
			DllStructCreate _
			( _
			'dword dwsize;' & _
			'dword cntUsage;' & _
			'dword th32ProcessID;' & _
			'uint th32DefaultHeapID;' & _
			'dword th32ModuleID;' & _
			'dword cntThreads;' & _
			'dword th32ParentProcessID;' & _
			'long pcPriClassBase;' & _
			'dword dwFlags;' & _
			'char szExeFile[260]' _
			)
	DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))
	
	Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
	
	Local $a_pfirst = DllCall('Kernel32.dll', 'int', 'Process32First', 'long', $a_tool_help[0], 'ptr', $p_PROCESSENTRY32)
	If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_pid)
	
	Local $a_pnext, $a_children[11] = [10], $i_child_pid, $i_parent_pid, $i_add = 0
	$i_child_pid = DllStructGetData($tagPROCESSENTRY32, 'th32ProcessID')
	If $i_child_pid <> $i_pid Then
		$i_parent_pid = DllStructGetData($tagPROCESSENTRY32, 'th32ParentProcessID')
		If $i_parent_pid = $i_pid Then
			$i_add += 1
			$a_children[$i_add] = $i_child_pid
		EndIf
	EndIf
	
	While 1
		$a_pnext = DllCall('Kernel32.dll', 'int', 'Process32Next', 'long', $a_tool_help[0], 'ptr', $p_PROCESSENTRY32)
		If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop
		$i_child_pid = DllStructGetData($tagPROCESSENTRY32, 'th32ProcessID')
		If $i_child_pid <> $i_pid Then
			$i_parent_pid = DllStructGetData($tagPROCESSENTRY32, 'th32ParentProcessID')
			If $i_parent_pid = $i_pid Then
				If $i_add = $a_children[0] Then
					ReDim $a_children[$a_children[0] + 10]
					$a_children[0] = $a_children[0] + 10
				EndIf
				$i_add += 1
				$a_children[$i_add] = $i_child_pid
			EndIf
		EndIf
	WEnd
	
	If $i_add <> 0 Then
		ReDim $a_children[$i_add + 1]
		$a_children[0] = $i_add
	EndIf
	
	DllCall('Kernel32.dll', 'int', 'CloseHandle', 'long', $a_tool_help[0])
	If $i_add Then Return $a_children
	Return SetError(3, 0, 0)
EndFunc   ;==>_ProcessGetChildren