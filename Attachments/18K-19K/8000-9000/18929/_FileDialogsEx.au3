#include-once

;=
; Customizable File Open/Save dialogs
; by Siao
;=

#Region OFN Constants

Global Const $OFN_ALLOWMULTISELECT = 0x200
Global Const $OFN_CREATEPROMPT = 0x2000
Global Const $OFN_DONTADDTORECENT = 0x2000000
Global Const $OFN_ENABLEHOOK = 0x20
Global Const $OFN_ENABLEINCLUDENOTIFY = 0x400000
Global Const $OFN_ENABLESIZING = 0x800000
Global Const $OFN_ENABLETEMPLATE = 0x40
Global Const $OFN_ENABLETEMPLATEHANDLE = 0x80
Global Const $OFN_EXPLORER = 0x80000
Global Const $OFN_EXTENSIONDIFFERENT = 0x400
Global Const $OFN_EX_NOPLACESBAR = 0x1
Global Const $OFN_FILEMUSTEXIST = 0x1000
Global Const $OFN_FORCESHOWHIDDEN = 0x10000000
Global Const $OFN_HIDEREADONLY = 0x4
Global Const $OFN_LONGNAMES = 0x200000
Global Const $OFN_NOCHANGEDIR = 0x8
Global Const $OFN_NODEREFERENCELINKS = 0x100000
Global Const $OFN_NOLONGNAMES = 0x40000
Global Const $OFN_NONETWORKBUTTON = 0x20000
Global Const $OFN_NOREADONLYRETURN = 0x8000
Global Const $OFN_NOTESTFILECREATE = 0x10000
Global Const $OFN_NOVALIDATE = 0x100
Global Const $OFN_OVERWRITEPROMPT = 0x2
Global Const $OFN_PATHMUSTEXIST = 0x800
Global Const $OFN_READONLY = 0x1
Global Const $OFN_SHAREAWARE = 0x4000
Global Const $OFN_SHAREFALLTHROUGH = 2
Global Const $OFN_SHARENOWARN = 1
Global Const $OFN_SHAREWARN = 0
Global Const $OFN_SHOWHELP = 0x10
Global Const $OFN_USEMONIKERS = 0x1000000
Global Const $OFS_MAXPATHNAME = 128

Global Const $CDM_FIRST = 1124
Global Const $CDM_GETFILEPATH = $CDM_FIRST + 0x1
Global Const $CDM_GETFOLDERIDLIST = $CDM_FIRST + 0x3
Global Const $CDM_GETFOLDERPATH = $CDM_FIRST + 0x2
Global Const $CDM_GETSPEC = $CDM_FIRST + 0x0
Global Const $CDM_HIDECONTROL = $CDM_FIRST + 0x5
Global Const $CDM_SETCONTROLTEXT = $CDM_FIRST + 0x4
Global Const $CDM_SETDEFEXT = $CDM_FIRST + 0x6
Global Const $CDM_LAST = 1224


Global Const $CDN_FIRST = -601
Global Const $CDN_INITDONE = $CDN_FIRST - 0x0
Global Const $CDN_INCLUDEITEM = $CDN_FIRST - 0x7
Global Const $CDN_FOLDERCHANGE = $CDN_FIRST - 0x2
Global Const $CDN_HELP = $CDN_FIRST - 0x4
Global Const $CDN_SELCHANGE = $CDN_FIRST - 0x1
Global Const $CDN_TYPECHANGE = $CDN_FIRST - 0x6
Global Const $CDN_SHAREVIOLATION = $CDN_FIRST - 0x3
Global Const $CDN_FILEOK = $CDN_FIRST - 0x5
Global Const $CDN_LAST = -699

;;explorer style dialog control indentifiers
Global Const $chx1 = 0x410 ;The read-only check box
Global Const $cmb1 = 0x470 ;Drop-down combo box that displays the list of file type filters
Global Const $stc2 = 0x441 ;Label for the cmb1 combo box
Global Const $cmb2 = 0x471 ;Drop-down combo box that displays the current drive or folder, and that allows the user to select a drive or folder to open
Global Const $stc4 = 0x443 ;Label for the cmb2 combo box
Global Const $edt1 = 0x480;Edit control that displays the name of the current file, or allows the user to type the name of the file to open. Compare with cmb13.
Global Const $stc3 = 0x442 ;Label for the cmb13 combo box and the edt1 edit control
Global Const $lst1 = 0x460 ;List box that displays the contents of the current drive or folder
Global Const $stc1 = 0x440 ;Label for the lst1 list box
;~ Global Const $IDOK = 1 ;The OK command button (push button)
;~ Global Const $IDCANCEL = 2 ;The Cancel command button (push button)
Global Const $pshHelp = 0x040e ;The Help command button (push button)

;; reverse-engineered command codes for SHELLDLL_DefView (Paul DiLascia, MSDN Magazine — March 2004)
Global Const $ODM_VIEW_ICONS = 0x7029
Global Const $ODM_VIEW_LIST = 0x702b
Global Const $ODM_VIEW_DETAIL = 0x702c
Global Const $ODM_VIEW_THUMBS = 0x702d
Global Const $ODM_VIEW_TILES = 0x702e

#EndRegion

;#
;	_FileOpenDialogEx()
;			Initiates a customizable Open File Dialog.
;	Parameters:
;			$sTitle - dialog title, see FileOpenDialog()
;			$sInitDir - initial folder, see FileOpenDialog()
;			$sFilter - file type filter, see FileOpenDialog()
;			$iOptions - can be one or combination of the following:
;						$OFN_FILEMUSTEXIST
;						$OFN_PATHMUSTEXIST
;						$OFN_ALLOWMULTISELECT
;						$OFN_CREATEPROMPT
;						$OFN_ENABLESIZING
;						$OFN_DONTADDTORECENT
;						$OFN_FORCESHOWHIDDEN
;						$OFN_NONETWORKBUTTON
;						$OFN_EX_NOPLACESBAR
;
;			$sDefaultName - default filename, see FileOpenDialog()
;			$hParent - handle of dialog's parent window (0 if none)
;			$sHookName - name of user defined dialog hook procedure ("" if none). See examples.
;			$hTemplate - handle to a file or memory object containing custom dialog template (0 if none). See examples.
;			$sTemplateName - name of a dialog template resource in the module identified by the $hTemplate ("" if none or if $hTemplate is memory object handle). See examples.
;	Return values:
;			Success: string value of chosen filename(s), see FileOpenDialog()
;			Failure: Sets @error to 1
;	Remarks:
;			Using hook function you can customize dialog to greater extent - hide/show controls, change text of controls, and do other neat things.
;			Hook function should have 4 params ($hWnd, $Msg, $wParam, $lParam) and works similar to GuiRegisterMsg() functions. For more information refer http://msdn2.microsoft.com/en-us/library/ms646960(VS.85).aspx
;			Using custom templates you can add controls to a common dialog. To handle these custom controls, use hook function.
;#
Func _FileOpenDialogEx($sTitle = "", $sInitDir = "", $sFilter = "All Files (*.*)", $iOptions = 0, $sDefaultName = "", $hParent=0, $sHookName="", $hTemplate=0, $sTemplateName="")

	Local $sRet = _GetOpenSaveFileName('GetOpenFileName', $sHookName, $hTemplate, $sTemplateName, $hParent, $sTitle, $sInitDir, $sFilter, $iOptions, $sDefaultName)
	If @error Then SetError(@error)
	Return $sRet
	
EndFunc
;#
;	_FileSaveDialogEx()
;			Initiates a customizable Save File Dialog.
;	Parameters:
;			$sTitle - dialog title, see FileSaveDialog()
;			$sInitDir - initial folder, see FileSaveDialog()
;			$sFilter - file type filter, see FileSaveDialog()
;			$iOptions - can be one or combination of the following:
;						$OFN_PATHMUSTEXIST
;						$OFN_OVERWRITEPROMPT
;						$OFN_ENABLESIZING
;						$OFN_DONTADDTORECENT
;						$OFN_FORCESHOWHIDDEN
;						$OFN_NONETWORKBUTTON
;						$OFN_EX_NOPLACESBAR
;
;			$sDefaultName - default filename, see FileSaveDialog()
;			$hParent - handle of dialog's parent window (0 if none)
;			$sHookName - name of user defined dialog hook procedure ("" if none). See examples.
;			$hTemplate - handle to a file or memory object containing custom dialog template (0 if none). See examples.
;			$sTemplateName - name of a dialog template resource in the module identified by the $hTemplate ("" if none or if $hTemplate is memory object handle). See examples.
;	Return values:
;			Success: string value of chosen filename, see FileSaveDialog()
;			Failure: Sets @error to 1
;	Remarks:
;			Using hook function you can customize dialog to greater extent - hide/show controls, change text of controls, and do other neat things.
;			Hook function should have 4 params ($hWnd, $Msg, $wParam, $lParam) and works similar to GuiRegisterMsg() functions. For more information refer http://msdn2.microsoft.com/en-us/library/ms646960(VS.85).aspx
;			Using custom templates you can add controls to a common dialog. To handle these custom controls, use hook function.
;#
Func _FileSaveDialogEx($sTitle = "", $sInitDir = "", $sFilter = "All Files (*.*)", $iOptions = 0, $sDefaultName = "", $hParent=0, $sHookName="", $hTemplate=0, $sTemplateName="")

	Local $sRet = _GetOpenSaveFileName('GetSaveFileName', $sHookName, $hTemplate, $sTemplateName, $hParent, $sTitle, $sInitDir, $sFilter, $iOptions, $sDefaultName)
	If @error Then SetError(@error)
	Return $sRet
	
EndFunc
;###################################
;#
;	_GetOpenSaveFileName()
;			Internal
;#
Func _GetOpenSaveFileName($sFunction, $sHookProc, $hTemplate, $sTemplateName, $hParent, $sTitle, $sInitDir, $sFilter, $iOptions, $sDefaultName)
	Local $taFilters, $tFile, $_OFN_HookProc = 0, $fUnicode = @Unicode, $iFlagsEx = 0, $iFlagsForced = BitOR($OFN_EXPLORER,$OFN_HIDEREADONLY,$OFN_NODEREFERENCELINKS)
	$iOptions = BitOR($iFlagsForced, $iOptions)
	If BitAND($iOptions, $OFN_EX_NOPLACESBAR) Then
		$iOptions = BitXOR($iOptions, $OFN_EX_NOPLACESBAR)
		$iFlagsEx = $OFN_EX_NOPLACESBAR
	EndIf
	Local $tagBuffer = "char[4096]", $iBufferSize = 4095
	If $fUnicode Then $tagBuffer = "w" & $tagBuffer
	Local $aFilters = StringSplit($sFilter, "|"), $saFilters = "", $tagFilters = "", $aFiltSplit, $i
	For $i = 1 To $aFilters[0]
		$aFiltSplit = StringRegExp($aFilters[$i], "(?U)\A\h*(.+)\h*\((.*)\)", 1)
		$saFilters &= $aFilters[$i] & Chr(0) & $aFiltSplit[1] & Chr(0)
	Next
	$tagFilters = "char[" & StringLen($saFilters)+3 & "]"
	If $fUnicode Then $tagFilters = "w" & $tagFilters
	$taFilters = DllStructCreate($tagFilters)
	DllStructSetData($taFilters, 1, $saFilters)
	Local $tagFileBuffer = "char[32768]", $iFileBufferSize = 32767
	If $fUnicode Then $tagFileBuffer = "w" & $tagFileBuffer
	$tFile = DllStructCreate($tagFileBuffer) ;Win2000/XP: should be 32k for ansi, unlimited for unicode
	If $sDefaultName <> "" Then DllStructSetData($tFile, 1, $sDefaultName)
	$tOFN = DllStructCreate('dword lStructSize;hwnd hwndOwner;hwnd hInstance;' & _
									'ptr lpstrFilter;ptr lpstrCustomFilter;dword nMaxCustFilter;dword nFilterIndex;' & _
									'ptr lpstrFile;dword nMaxFile;ptr lpstrFileTitle;dword nMaxFileTitle;ptr lpstrInitialDir;ptr lpstrTitle;' & _
									'dword Flags;short nFileOffset;short nFileExtension;ptr lpstrDefExt;dword lCustData;ptr lpfnHook;ptr lpTemplateName;' & _
									'dword Reserved[2];dword FlagsEx')
	DllStructSetData($tOFN, 'lStructSize', DllStructGetSize($tOFN))
	If IsHWnd($hParent) Then DllStructSetData($tOFN, 'hwndOwner', $hParent)
	DllStructSetData($tOFN, 'lpstrFilter', DllStructGetPtr($taFilters))
	DllStructSetData($tOFN, 'nFilterIndex', 1)
	DllStructSetData($tOFN, 'lpstrFile', DllStructGetPtr($tFile))
	DllStructSetData($tOFN, 'nMaxFile', $iFileBufferSize)
	DllStructSetData($tOFN, 'FlagsEx', $iFlagsEx)
	If $hTemplate <> 0 Then
		If $sTemplateName <> "" Then
			$iOptions = BitOr($iOptions, $OFN_ENABLETEMPLATE)
			DllStructSetData($tOFN, 'hInstance', $hTemplate)
			Local $tTemplateName = DllStructCreate($tagBuffer);'char[256]')
			DllStructSetData($tTemplateName, 1, $sTemplateName)
			DllStructSetData($tOFN, 'lpTemplateName', DllStructGetPtr($tTemplateName))
		Else
			$iOptions = BitOr($iOptions, $OFN_ENABLETEMPLATEHANDLE)
			DllStructSetData($tOFN, 'hInstance', $hTemplate)
		EndIf
	EndIf
	If $sHookProc <> "" Then
		$iOptions = BitOr($iOptions, $OFN_ENABLEHOOK, $OFN_ENABLEINCLUDENOTIFY)
		$_OFN_HookProc = DllCallbackRegister($sHookProc, "int", "hwnd;uint;wparam;lparam")
		DllStructSetData($tOFN, 'lpfnHook', DllCallbackGetPtr($_OFN_HookProc))
	EndIf	
	If $sTitle <> "" Then
		Local $tTitle = DllStructCreate($tagBuffer)
		DllStructSetData($tTitle, 1, String($sTitle))
		DllStructSetData($tOFN, "lpstrTitle", DllStructGetPtr($tTitle))
	EndIf
	If $sInitDir <> "" Then
		Local $tInitDir = DllStructCreate($tagBuffer)
		DllStructSetData($tInitDir, 1, String($sInitDir))
		DllStructSetData($tOFN, "lpstrInitialDir", DllStructGetPtr($tInitDir))
	EndIf
	DllStructSetData($tOFN, 'Flags', $iOptions)
	If $fUnicode Then $sFunction &= 'W'
	Local $aRet = DllCall('comdlg32.dll','int',$sFunction, 'ptr',DllStructGetPtr($tOFN)), $iError = @error
	If $_OFN_HookProc <> 0 Then DllCallbackFree($_OFN_HookProc)
	If $iError Then 
		Return SetError(2,$iError,"")
	ElseIf $aRet[0] Then
		Local $iChar = 1
		While $iChar < $iFileBufferSize+1
			If DllStructGetData($tFile, 1, $iChar) = "" Then
				If DllStructGetData($tFile, 1, $iChar+1) = "" Then ExitLoop
				DllStructSetData($tFile, 1, "|", $iChar)
			EndIf
			$iChar += 1
		WEnd
		Return SetError(0,0,DllStructGetData($tFile, 1))
	Else
		Return SetError(1,0,"")
	EndIf
EndFunc
