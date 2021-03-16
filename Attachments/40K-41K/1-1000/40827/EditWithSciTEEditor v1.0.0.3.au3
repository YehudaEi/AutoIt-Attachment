#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\SciTE.ico
#AutoIt3Wrapper_Outfile=EditWithSciTE.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Description=Add Contextual Menu for Edit some file type with SciTE Editor.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.3
#AutoIt3Wrapper_Res_LegalCopyright=wakillon 2013
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt ( 'GuiOnEventMode', 1 )
Opt ( 'GuiCloseOnESC', 0 )
Opt ( 'MustDeclareVars', 1 )
Opt ( 'TrayMenuMode', 1 )

If Not _Singleton ( @ScriptName, 1 ) Then Exit

Global $sCommandName = 'Edit with SciTE Editor' ; if you change it, remove previous context menu added first.
Global $sRegKey = 'HKLM' & StringReplace ( StringReplace ( @OSArch, 'x64', '64' ), 'x86', '' ) & '\Software\Classes'
Global $aType[22]=['inifile', 'inffile', 'JSFile', 'WSFFile', 'MSInfoFile', 'regfile', 'txtfile', 'LuaFile', 'Python.File', 'AutoHotkeyScript', 'VBSFile', 'batfile', 'cmdfile', 'SHCmdFile', 'xslfile', 'IE.AssocFile.URL', _
	'SystemFileAssociations\.m3u', 'SystemFileAssociations\.properties', 'SystemFileAssociations\.xml', 'SystemFileAssociations\.xhtml', 'SystemFileAssociations\.html', 'SystemFileAssociations\.htm']
Global $sSciTEPath = _SciTEGetPath ()
If @error Then
	For $i = 0 To UBound ( $aType ) -1
		RegDelete ( $sRegKey & '\' & $aType[$i] & '\shell\' & $sCommandName ) ; remove previous registry entries if SciTE was uninstalled.
	Next
	Exit MsgBox ( 262144+4096+16, 'Exiting on Error', 'SciTE.exe was not Found !', 5 )
EndIf
OnAutoItExitRegister ( '_OnAutoItExit' )
Global $sRegTitleKey = $sCommandName
Global $sRegKeySettings = 'HKCU' & StringReplace ( StringReplace ( @OSArch, 'x64', '64' ), 'x86', '' ) & '\Software\' & $sRegTitleKey & '\Settings'
Global $sVersion = _ScriptGetVersion ()
Global $sSoftTitle = $sRegTitleKey & ' v' & $sVersion & ' by wakillon'
Global $hNew_ControlProc = 0, $pOriginal_ButtonProc
Global $aExt[22]=['.ini', '.inf', '.js', '.wsf', '.nfo', '.reg', '.txt', '.lua', '.py', '.ahk', '.vbs', '.bat', '.cmd', '.scf', '.xsl', '.url', '.m3u', '.properties', '.xml', '.xhtml', '.html', '.htm']
Global $aTips[22]=['Configuration Settings File', 'Setup Information File', 'Java Script File', 'Windows Script File', 'MSInfoFile Configuration', 'Registry entries File', 'Text Document File' & @CRLF & '(also .log .scp .wtx)', _
	'Lua Script File', 'Python File', 'AutoHotkey Script File', 'VBScript File', 'Windows Batch File', 'Windows Command File', 'Windows Explorer Command', 'Extensible Stylesheet Language File', 'Internet Shortcut File', _
	'Multimedia Playlists File', 'Configuration Parameters File', 'Extensible Markup Language File', 'Extensible HyperText Markup Language File', 'HyperText Markup Language File', 'HyperText Markup Language File']
Global $hGui, $idCheckBox[UBound($aType)], $idButtonSelect, $idButtonApply
Global $sSciTEIconPath = 'C:\SciTE.ico'
Global $hUser32DLL = DllOpen ( 'user32.dll' )
Global $sChangesOld = _GetChanges ()

_ControlGlobalSubclass ()
_Gui ()
_TrayMenuSet ()
_BalloonTipsEnable ()

While 1
	Sleep ( 250 )
WEnd

Func _Apply ()
	For $i = 0 To UBound ( $aType ) -1
		If _IsChecked ( $idCheckBox[$i] ) Then
			RegWrite ( $sRegKey & '\' & $aType[$i] & '\shell\' & $sCommandName, '', 'REG_SZ', $sCommandName )
			RegWrite ( $sRegKey & '\' & $aType[$i] & '\shell\' & $sCommandName, 'icon', 'REG_EXPAND_SZ', $sSciTEIconPath )
			RegWrite ( $sRegKey & '\' & $aType[$i] & '\shell\' & $sCommandName & '\command', '', 'REG_SZ', $sSciTEPath & ' "%1"' )
		Else
			RegDelete ( $sRegKey & '\' & $aType[$i] & '\shell\' & $sCommandName )
		EndIf
	Next
	Local $sChanges = _GetChanges ()
	If $sChanges <> $sChangesOld Then
		_TrayTip ( $sSoftTitle, 'Changes were Applied !', 1, 3000 )
	Else
		_TrayTip ( $sSoftTitle, 'No Changes were Applied !', 2, 3000 )
	EndIf
	$sChangesOld = $sChanges
EndFunc ;==> _Apply ()

Func _AreAllChecked ()
	For $i = 0 To UBound ( $aType ) -1
		If Not _IsChecked (  $idCheckBox[$i] ) Then Return 0
	Next
	Return 1
EndFunc ;==> _AreAllChecked ()

Func _BalloonTipsEnable () ; Enable Balloon Tips.
	Local $iTips = RegRead ( 'HKCU\Software\Microsoft\WINDOWS\CurrentVersion\Explorer\Advanced', 'EnableBalloonTips' )
	If @error Or Not $iTips Then
		Local $iWrite =    RegWrite ( 'HKCU\Software\Microsoft\WINDOWS\CurrentVersion\Explorer\Advanced', 'EnableBalloonTips', 'REG_DWORD', 0x00000001 )
		Return SetError ( @error, 0, $iWrite )
	Else
		Return SetError ( 0, 0, $iTips )
	EndIf
EndFunc ;==> _BalloonTipsEnable ()

Func _Base64Decode ( $input_string ) ; by trancexx
	Local $struct = DllStructCreate ( 'int' )
	Local $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', 0, 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $a = DllStructCreate ( 'byte[' & DllStructGetData ( $struct, 1) & ']' )
	$a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', DllStructGetPtr ( $a ), 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 2, 0, '' )
	Return DllStructGetData ( $a, 1 )
EndFunc ;==> _Base64Decode ()

Func _ControlGlobalSubclass () ; by rover
	If $hNew_ControlProc <> 0 Then Return SetError ( 1, 0, 0 )
	Local $hGUITemp = GUICreate ( '', 1, 1, -10, -10 )
	Local $hButtonTemp = GUICtrlGetHandle ( GUICtrlCreateButton ( '', -10, -10, 1, 1 ) )
	$hNew_ControlProc = DllCallbackRegister ( '_WndProc', 'int', 'hwnd;uint;wparam;lparam' )
	Local $pCallbackPtr = DllCallbackGetPtr ( $hNew_ControlProc )
	$pOriginal_ButtonProc = DllCall ( $hUser32DLL, 'dword', 'SetClassLongW', 'hwnd', $hButtonTemp, 'int', -24, 'ptr', $pCallbackPtr ) ; $GCL_WNDPROC
	$pOriginal_ButtonProc = $pOriginal_ButtonProc[0]
	GUIDelete ( $hGUITemp )
	Return SetError ( 0, 0, 1 )
EndFunc ;==> _ControlGlobalSubclass ()

Func _Exit ()
	Exit
EndFunc ;==> _Exit ()

Func _GetChanges ()
	Local $sString
	For $i = 0 To UBound ( $aType ) -1
		$sString &= ( RegRead ( $sRegKey & '\' & $aType[$i] & '\shell\' & $sCommandName, '' ) <> '' )
	Next
	Return $sString
EndFunc ;==> _GetChanges ()

Func _Gui ()
	$hGui = GUICreate ( $sSoftTitle, 520, 300, -1, -1, -1, 0x00000008 ) ; $WS_EX_TOPMOST
	If Not FileExists ( $sSciTEIconPath ) Then _SciTEIcon ( 'SciTE.ico', 'C:\' )
	GUISetIcon ( $sSciTEIconPath )
	GUISetOnEvent ( -3, '_Exit' ) ; $GUI_EVENT_CLOSE
	GUICtrlSetColor ( -1, 0x0000FF )
	GUICtrlCreateLabel ( 'Select Which FileType Extension you want to add a Contextual Menu "' & $sCommandName & '"', 30, 20, 460, 40, 0x01 ) ; $SS_CENTER
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetFont ( -1, 12, 700 )
	GUICtrlCreateGroup ( '', 20, 70, 480, 150 )
	Local $x, $y, $iTop = 60, $iSpacing = 45
	For $i = 0 To UBound ( $aType ) -1
		Switch $i
			Case 0 To 5
				$x=$i*70 +$iSpacing
				$y = 30
			Case 6 To 11
				$x=($i-6)*70 +$iSpacing
				$y = 60
			Case 12 To 17
				$x=($i-12)*70 +$iSpacing
				$y = 90
			Case 18 To UBound ( $aType ) -1
				$x=($i-18)*70 +$iSpacing
				$y = 120
		EndSwitch
		$idCheckBox[$i] = GUICtrlCreateCheckbox ( $aExt[$i], $x, $iTop+$y, 68 + 20*( StringLen ( $aExt[$i] )> 10 ), -1, 0x0003 ) ; $BS_AUTOCHECKBOX
		GUICtrlSetState ( $idCheckBox[$i], 1 + 3 * ( RegRead ( $sRegKey & '\' & $aType[$i] & '\shell\' & $sCommandName, '' ) = '' ) )
		DllCall ( 'UxTheme.dll', 'int', 'SetWindowTheme', 'hwnd', GUICtrlGetHandle ( -1 ), 'wstr', '', 'wstr', '' )
		GUICtrlSetColor ( -1, 0x0000FF )
		GUICtrlSetTip ( -1,  $aTips[$i], 'Extension ' & $aExt[$i], 1, 1 )
		GUICtrlSetFont ( -1, 9, 600 )
		GUICtrlSetOnEvent ( -1, '_SetButtonText' )
	Next
	$idButtonSelect = GUICtrlCreateButton ( 'Select All', $x+70, $iTop+$y, 120, 18 )
	GUICtrlSetFont ( -1, 8, 600 )
	GUICtrlSetOnEvent ( -1, '_SelectAll' )
	If Not _AreAllChecked () Then
		GUICtrlSetData ( $idButtonSelect, 'Select All' )
	Else
		GUICtrlSetData ( $idButtonSelect, 'UnSelect All' )
	EndIf
	$idButtonApply = GUICtrlCreateButton ( 'Apply', 30, 250, 460, 30 )
	GUICtrlSetOnEvent ( -1, '_Apply' )
	GUICtrlSetFont ( -1, 13, 800 )
	GUISetState ()
EndFunc ;==> _Gui ()

Func _IsChecked ( $idCtrl )
	Return BitAND ( GUICtrlRead ( $idCtrl ), 1 ) = 1 ; $GUI_CHECKED
EndFunc ;==> _IsChecked ()

Func _LzntDecompress ( $bBinary ); by trancexx
	$bBinary = Binary ( $bBinary )
	Local $tInput = DllStructCreate ( 'byte[' & BinaryLen ( $bBinary ) & ']' )
	DllStructSetData ( $tInput, 1, $bBinary )
	Local $tBuffer = DllStructCreate ( 'byte[' & 16 * DllStructGetSize ( $tInput ) & ']' )
	Local $a_Call = DllCall ( 'ntdll.dll', 'int', 'RtlDecompressBuffer', 'ushort', 2, 'ptr', DllStructGetPtr ( $tBuffer ), 'dword', DllStructGetSize ( $tBuffer ), 'ptr', DllStructGetPtr ( $tInput ), 'dword', DllStructGetSize ( $tInput ), 'dword*', 0 )
	If @error Or $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $tOutput = DllStructCreate ( 'byte[' & $a_Call[6] & ']', DllStructGetPtr ( $tBuffer ) )
	Return SetError ( 0, 0, DllStructGetData ( $tOutput, 1 ) )
EndFunc ;==> _LzntDecompress ()

Func _OnAutoItExit ()
	GUISetState ( 32, $hGui ) ; $GUI_HIDE
	DllCallbackFree ( $hNew_ControlProc )
	DllClose ( $hUser32DLL )
EndFunc ;==> _OnAutoItExit ()

Func _SciTEGetPath ()
	Local $sScitePath = @ProgramFilesDir & '\AutoIt3\SciTE\SciTE.exe'
	If Not FileExists ( $sScitePath ) Then $sScitePath = RegRead ( 'HKLM\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir' ) & '\SciTE\scite.exe'
	If Not FileExists ( $sScitePath ) Then
		$sScitePath = RegRead ( $sRegKeySettings, 'SciTEPath' )
		If @error Or Not FileExists ( $sScitePath ) Then
			$sScitePath = FileOpenDialog ( 'SciTE Path', @ProgramFilesDir, '(*.exe)', 1 + 2, 'SciTE.exe' )
			If StringRight ( $sScitePath, 9 ) <> 'SciTE.exe' Then
				$sScitePath = ''
			Else
				RegWrite ( $sRegKeySettings, 'SciTEPath', 'REG_SZ', $sScitePath )
			EndIf
		EndIf
	EndIf
	Return SetError ( Not FileExists ( $sScitePath ), 0, $sScitePath )
EndFunc ;==> _SciTEGetPath ()

Func _SciTEIcon ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin &= '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LzntDecompress ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> _SciTEIcon ()

Func _ScriptGetVersion ()
	Local $sFileVersion
	If @Compiled Then
		$sFileVersion = FileGetVersion ( @ScriptFullPath, 'FileVersion' )
	Else
		$sFileVersion = _StringBetween ( FileRead ( @ScriptFullPath ), '#AutoIt3Wrapper_Res_Fileversion=', @CR )
		If Not @error Then
			$sFileVersion = $sFileVersion[0]
		Else
			$sFileVersion = '0.0.0.0'
		EndIf
	EndIf
	Return $sFileVersion
EndFunc ;==> _ScriptGetVersion ()

Func _SelectAll ()
	Local $j = Not ( GUICtrlRead ( $idButtonSelect ) = 'Select All' )
	For $i = 0 To UBound ( $aType ) -1
		GUICtrlSetState ( $idCheckBox[$i], 1 + 3 * $j ) ; $GUI_CHECKED / $GUI_UNCHECKED
	Next
	If $j Then
		GUICtrlSetData ( $idButtonSelect, 'Select All' )
	Else
		GUICtrlSetData ( $idButtonSelect, 'UnSelect All' )
	EndIf
EndFunc ;==> _SelectAll ()

Func _SetButtonText ()
	If Not _AreAllChecked () Then
		If GUICtrlRead ( $idButtonSelect ) <> 'Select All' Then GUICtrlSetData ( $idButtonSelect, 'Select All' )
	Else
		If GUICtrlRead ( $idButtonSelect ) <> 'UnSelect All' Then GUICtrlSetData ( $idButtonSelect, 'UnSelect All' )
	EndIf
EndFunc ;==> _SetButtonText ()

Func _Singleton ( $sOccurenceName, $iFlag = 0 )
	Local Const $ERROR_ALREADY_EXISTS = 183
	Local Const $SECURITY_DESCRIPTOR_REVISION = 1
	Local $tSecurityAttributes = 0
	If BitAND ( $iFlag, 2 ) Then
		Local $tSecurityDescriptor = DllStructCreate ( 'byte;byte;word;ptr[4]' )
		Local $aRet = DllCall ( 'advapi32.dll', 'bool', 'InitializeSecurityDescriptor', 'struct*', $tSecurityDescriptor, 'dword', $SECURITY_DESCRIPTOR_REVISION )
		If @error Then Return SetError ( @error, @extended, 0 )
		If $aRet[0] Then
			$aRet = DllCall ( 'advapi32.dll', 'bool', 'SetSecurityDescriptorDacl', 'struct*', $tSecurityDescriptor, 'bool', 1, 'ptr', 0, 'bool', 0 )
			If @error Then Return SetError ( @error, @extended, 0 )
			If $aRet[0] Then
				$tSecurityAttributes = DllStructCreate ( 'dword Length;ptr Descriptor;bool InheritHandle' ) ; $tagSECURITY_ATTRIBUTES
				DllStructSetData ( $tSecurityAttributes, 1, DllStructGetSize ( $tSecurityAttributes ) )
				DllStructSetData ( $tSecurityAttributes, 2, DllStructGetPtr ( $tSecurityDescriptor ) )
				DllStructSetData ( $tSecurityAttributes, 3, 0 )
			EndIf
		EndIf
	EndIf
	Local $handle = DllCall ( 'kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $tSecurityAttributes, 'bool', 1, 'wstr', $sOccurenceName )
	If @error Then Return SetError ( @error, @extended, 0 )
	Local $lastError = DllCall ( 'kernel32.dll', 'dword', 'GetLastError' )
	If @error Then Return SetError ( @error, @extended, 0 )
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		If BitAND ( $iFlag, 1 ) Then
			Return SetError ( $lastError[0], $lastError[0], 0 )
		Else
			Exit -1
		EndIf
	EndIf
	Return $handle[0]
EndFunc ;==> _Singleton ()

Func _StringBetween ( $s_String, $s_Start, $s_End, $v_Case = -1 )
	Local $s_case = ''
	If $v_Case = Default Or $v_Case = -1 Then $s_case = '(?i)'
	Local $s_pattern_escape = '(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)'
	$s_Start = StringRegExpReplace ( $s_Start, $s_pattern_escape, '\\$1' )
	$s_End = StringRegExpReplace ( $s_End, $s_pattern_escape, '\\$1' )
	If $s_Start = '' Then $s_Start = '\A'
	If $s_End = '' Then $s_End = '\z'
	Local $a_ret = StringRegExp ( $s_String, '(?s)' & $s_case & $s_Start & '(.*?)' & $s_End, 3 )
	If @error Then Return SetError ( 1, 0, 0 )
	Return $a_ret
EndFunc ;==> _StringBetween ()

Func _TrayMenuSet ()
	TraySetIcon ( $sSciTEIconPath )
	TraySetClick ( 16 )
	TraySetState ( 4 )
	TraySetToolTip ( $sSoftTitle )
EndFunc ;==> _TrayMenuSet ()

Func _TrayTip ( $sTitle= ' ', $sTexte= '...', $iIcon=0, $iTimeout=3000 )
	TrayTip ( $sTitle, $sTexte, $iTimeout, $iIcon )
	AdlibRegister ( '_TrayTipTimer', $iTimeout )
EndFunc ;==> _TrayTip ()

Func _TrayTipTimer ()
	TrayTip ( '', '', 1, 1 )
	AdlibUnRegister ( '_TrayTipTimer' )
EndFunc ;==> TrayTipTimer ()

Func _WinAPI_CallWindowProc ( $lpPrevWndFunc, $hWnd, $Msg, $wParam, $lParam )
	Local $aResult = DllCall ( $hUser32DLL, 'lresult', 'CallWindowProc', 'ptr', $lpPrevWndFunc, 'hwnd', $hWnd, 'uint', $Msg, 'wparam', $wParam, 'lparam', $lParam )
	If @error Then Return SetError ( @error, @extended, -1 )
	Return $aResult[0]
EndFunc ;==> _WinAPI_CallWindowProc ()

Func _WinAPI_GetClassName ( $hWnd )
	If Not IsHWnd ( $hWnd ) Then $hWnd = GUICtrlGetHandle ( $hWnd )
	Local $aResult = DllCall ( $hUser32DLL, 'int', 'GetClassNameW', 'hwnd', $hWnd, 'wstr', '', 'int', 4096 )
	If @error Then Return SetError ( @error, @extended, False )
	Return SetExtended ( $aResult[0], $aResult[2] )
EndFunc ;==> _WinAPI_GetClassName ()

Func _WndProc ( $hWnd, $iMsg, $wParam, $lParam )
	If $iMsg = 0x0007 Then Return 0 ; $WM_SETFOCUS
	Switch _WinAPI_GetClassName ( $hWnd )
		Case 'Button'
			Return _WinAPI_CallWindowProc ( $pOriginal_ButtonProc, $hWnd, $iMsg, $wParam, $lParam )
		Case Else
			Return 0
	EndSwitch
EndFunc ;==> _WndProc ()