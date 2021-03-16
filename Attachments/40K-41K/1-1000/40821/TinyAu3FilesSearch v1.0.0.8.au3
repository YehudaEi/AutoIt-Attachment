#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Loupe2.ico
#AutoIt3Wrapper_Outfile=TinyAu3FilesSearch.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Description=Au3SearchEngine Search AutoIt Script files.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Res_LegalCopyright=wakillon 2013
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#Include <GuiStatusBar.au3>
#Include <GuiListView.au3>
#Include <GDIPlus.au3>
#EndRegion ;************ Includes ************

Opt ( 'GuiCloseOnESC', 0 )
Opt ( 'MustDeclareVars', 1 )
If Not _Singleton ( @ScriptName, 1 ) Then Exit
OnAutoItExitRegister ( '_Exit' )

#Region ------ Global Variables ------------------------------
Global Const $SC_CLOSE = 0xF060
Global Const $EN_CHANGE = 0x300
Global Const $CBS_SIMPLE = 0x1
Global Const $CBS_DROPDOWN = 0x2
Global Const $CBS_SORT = 0x100
Global Const $CBN_SELENDOK = 9
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $WM_PAINT = 0x000F
Global Const $WM_NCPAINT = 0x0085
Global Const $WM_COMMAND = 0x0111
Global Const $WM_SYSCOMMAND = 0x0112
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_SETCURSOR = 0x0020
Global Const $WM_CTLCOLORLISTBOX = 0x0134
Global Const $NM_FIRST = 0
Global Const $NM_CLICK = $NM_FIRST - 2
Global Const $NM_DBLCLK = $NM_FIRST - 3
Global Const $RDW_VALIDATE = 0x0008
Global Const $RDW_UPDATENOW = 0x0100
Global $aArray[1], $hListView, $iSearch, $iCancel, $sTempDir = @TempDir & '\TAFS'
Global $hGui, $idInput1, $idInput2, $idInput3, $idInput4, $idInput5
Global $idButtonSearch, $idProgressBar, $idLabelState, $idComboRoot, $sComboRead, $hStatusBar, $sStatusBarText
Global $sRegTitleKey = 'TinyAu3FilesSearch'
Global $sRegKeySettings = 'HKCU' & StringReplace ( StringReplace ( @OSArch, 'x64', '64' ), 'x86', '' ) & '\Software\' & $sRegTitleKey & '\Settings'

ConsoleWrite ( StringFormat ( '%03i', @ScriptLineNumber ) & ' $sRegKeySettings : ' & $sRegKeySettings & @Crlf )

Global $idLabel[5], $iLabelColor[5], $hImage1, $hGraphic1, $sVersion = _ScriptGetVersion ()
Global $sSoftTitle = $sRegTitleKey & ' v' & $sVersion
Global $iGuiBkColor = 0x1D3652, $iOverColor=0xFF0000, $iBaseColor=0xFFAA00, $hBrush
Global $sLastSelectDir = _GetLastRootDir (), $sSearchDir, $sSciTEPath, $iSelectDir
#EndRegion --- Global Variables ------------------------------

If _FileMissing () Then _FileInstall ()
_Gui ()
$sSciTEPath = _SciTEGetPath ()
If @error Then Exit MsgBox ( 262144+4096+16, 'Exiting on Error', 'SciTE Editor was not found !' & @CRLF & @CRLF & $sRegTitleKey & ' will now be closed.', 5, $hGui )

#Region ------ Main Loop ------------------------------
While 1
	If $iSearch Then
		GUICtrlSetState ( $idComboRoot, $GUI_DISABLE )
		_Au3Search ()
		$iSearch = 0
		$iCancel =0
		GUICtrlSetData ( $idButtonSearch, 'Search' )
		GUICtrlSetState ( $idComboRoot, $GUI_ENABLE )
	ElseIf $iSelectDir = 1 Then
		$sSearchDir = FileSelectFolder ( 'Choose Directory For Search Au3 Scripts.', '', 2, $sLastSelectDir )
		If Not FileExists ( $sSearchDir ) Then $sSearchDir = @DesktopDir
		$sLastSelectDir = $sSearchDir
		_GUICtrlStatusBar_SetText ( $hStatusBar, 'Root Search : ' & _GetCompactPath ( $sSearchDir, 460 ) )
		ConsoleWrite ( StringFormat ( '%03i', @ScriptLineNumber ) & ' $sLastSelectDir : ' & $sLastSelectDir & @Crlf )
		If FileExists ( $sLastSelectDir ) Then
			_SaveLastRoot ( $sLastSelectDir )
			_GuiCtrlComboSetData ()
		EndIf
		_GUICtrlListView_DeleteAllItems ( $hListView )
		GUICtrlSetData ( $idLabelState, '' )
		$iSelectDir = 0
	EndIf
	Sleep ( 10 )
WEnd
#EndRegion --- Main Loop ------------------------------

Func __FileSearch ( $sPath, $sMask='*', $Include=True, $iDepth=125, $Full=1, $Array=1, $iTypeMask=1 )
	Local $sFileList, $i
	If $sMask = '|' Then Return SetError ( 2, 0, '' )
	If Not FileExists ( $sPath ) Then Return SetError ( 1, 0, '' )
	If StringRight ( $sPath, 1 ) <> '\' Then $sPath &= '\'
	If $sMask = '*' Or $sMask = '' Then
		$sFileList = StringTrimRight ( __FileSearchAll ( $sPath, $iDepth ), 2 )
	Else
		Switch $iTypeMask
			Case 0
				If StringInStr ( $sMask, '*' ) Or StringInStr ( $sMask, '?' ) Or StringInStr ( $sMask, '.' ) Then
					__FileSearchGetListMask ( $sPath, $sMask, $Include, $iDepth, $sFileList )
				Else
					$sFileList = StringTrimRight ( __FileSearchType ( $sPath, '|' & $sMask & '|', $Include, $iDepth ), 2 )
				EndIf
			Case 1
				Local $hTimerInit1 = TimerInit ()
				__FileSearchGetListMask ( $sPath, $sMask, $Include, $iDepth, $sFileList )
				ConsoleWrite ( @ScriptLineNumber & ' TimerDiff1 : ' & TimerDiff ( $hTimerInit1 ) & @Crlf )
			Case Else
				If StringInStr ( $sMask, '*' ) Or StringInStr ( $sMask, '?' ) Or StringInStr ( $sMask, '.' ) Then Return SetError ( 2, 0, '' )
				$sFileList = StringTrimRight ( __FileSearchType ( $sPath, '|' & $sMask & '|', $Include, $iDepth ), 2 )
		EndSwitch
	EndIf
	If Not $sFileList Then Return SetError ( 3, 0, '' )
	Switch $Full
		Case 0
			$sFileList = StringRegExpReplace ( $sFileList, '(?m)^(?:.{' & StringLen ( $sPath ) & '})(.*)$', '\1' )
		Case 2
			$sFileList = StringRegExpReplace ( $sFileList, '(?m)^(?:.*\\)(.*)$', '\1' )
		Case 3
			$sFileList = StringRegExpReplace ( $sFileList, '(?m)^(?:.*\\)([^\\]*?)(?:\.[^.]+)?$', '\1' & @CR )
			$sFileList = StringTrimRight ( $sFileList, 1 )
	EndSwitch
	Switch $Array
		Case 1
			$sFileList = StringSplit ( $sFileList, @CRLF, 1 )
		Case 2
			$sFileList = StringSplit ( $sFileList, @CRLF, 3 )
	EndSwitch
	Return $sFileList
EndFunc ;==> __FileSearch ()

Func __FileSearchAll ( $sPath, $iDepth, $LD=0 )
	Local $sFileList = '', $sFile, $s = FileFindFirstFile ( $sPath & '*' )
	If $s = -1 Then Return ''
	While 1
		$sFile = FileFindNextFile ( $s )
		If @error Or $iCancel Then ExitLoop
		If @extended Then
			If $LD >= $iDepth Then ContinueLoop
			$sFileList &= __FileSearchAll ( $sPath & $sFile & '\', $iDepth, $LD + 1 )
		Else
			$sFileList &= $sPath & $sFile & @CRLF
		EndIf
	WEnd
	FileClose ( $s )
	Return $sFileList
EndFunc ;==> __FileSearchAll ()

Func __FileSearchGetListMask ( $sPath, $sMask, $Include, $iDepth, ByRef $sFileList )
	Local $aFileList
	$sFileList = StringTrimRight ( __FileSearchMask ( $sPath, $iDepth ), 2 )
	$sMask = StringReplace ( StringReplace ( StringRegExpReplace ( $sMask, '[][$^.{}()+]', '\\$0' ), '?', '.' ), '*', '.*?' )
	If $Include Then
		$aFileList = StringRegExp ( $sFileList, '(?mi)^(.+\|(?:' & $sMask & '))(?:\r|\z)', 3 )
		$sFileList = ''
		For $i = 0 To UBound ( $aFileList ) - 1
			$sFileList &= $aFileList[$i] & @CRLF
		Next
	Else
		$sFileList = StringRegExpReplace ( $sFileList & @CRLF, '(?mi)^.+\|(' & $sMask & ')\r\n', '' )
	EndIf
	$sFileList = StringReplace ( StringTrimRight ( $sFileList, 2 ), '|', '' )
EndFunc ;==> __FileSearchGetListMask ()

Func __FileSearchMask ( $sPath, $iDepth, $LD=0 )
	Local $sFileList = '', $sFile, $s = FileFindFirstFile ( $sPath & '*' )
	If $s = -1 Then Return ''
	While 1
		$sFile = FileFindNextFile ( $s )
		If @error Or $iCancel Then ExitLoop
		If @extended Then
			If $LD >= $iDepth Then ContinueLoop
			$sFileList &= __FileSearchMask ( $sPath & $sFile & '\', $iDepth, $LD + 1 )
		Else
			$sFileList &= $sPath & '|' & $sFile & @CRLF
		EndIf
	WEnd
	FileClose ( $s )
	Return $sFileList
EndFunc ;==> __FileSearchMask ()

Func __FileSearchType ( $sPath, $sMask, $Include, $iDepth, $LD=0 )
	Local $tmp, $sFileList = '', $sFile, $s = FileFindFirstFile ( $sPath & '*' )
	If $s = -1 Then Return ''
	While 1
		$sFile = FileFindNextFile ( $s )
		If @error Or $iCancel Then ExitLoop
		If @extended Then
			If $LD >= $iDepth Then ContinueLoop
			$sFileList &= __FileSearchType ( $sPath & $sFile & '\', $sMask, $Include, $iDepth, $LD + 1 )
		Else
			$tmp = StringInStr ( $sFile, '.', 0, -1 )
			If $tmp And StringInStr ( $sMask, '|' & StringTrimLeft ( $sFile, $tmp ) & '|' ) = $Include Then
				$sFileList &= $sPath & $sFile & @CRLF
			ElseIf Not $tmp And Not $Include Then
				$sFileList &= $sPath & $sFile & @CRLF
			EndIf
		EndIf
	WEnd
	FileClose ( $s )
	Return $sFileList
EndFunc ;==> __FileSearchType ()

Func _Au3Search ()
	Local $iIsStringsInFileName
	Local $sStringToFind1, $sStringToFind2, $sStringToExclude1, $sStringToExclude2, $sStringInName
	_GUICtrlListView_DeleteAllItems ( $hListView )
	$sComboRead = GUICtrlRead ( $idComboRoot )
	Local $sRegValue, $i
	If Not StringInStr ( $sComboRead, '...\' ) Then
		$sSearchDir = $sComboRead
	Else
		While 1
			$i += 1
			Local $sRegValues = RegEnumVal ( $sRegKeySettings, $i )
			If @error <> 0 Then ExitLoop
			If StringInStr ( $sRegValues, 'LastSelectDir' ) Then
				$sRegValue = RegRead ( $sRegKeySettings, $sRegValues )
				If FileExists ( $sRegValue ) And $sComboRead == _GetCompactPath ( $sRegValue, 460 ) Then
					$sSearchDir = $sRegValue
					ExitLoop
				EndIf
			EndIf
		WEnd
	EndIf
	Local $iSearchTimerInit, $iUbound
	If FileExists ( $sSearchDir ) Then
		Local $sStringToFind1 = GUICtrlRead ( $idInput2 )
		Local $sStringToFind2 = GUICtrlRead ( $idInput3 )
		Local $sStringToExclude1 = GUICtrlRead ( $idInput4 )
		Local $sStringToExclude2 = GUICtrlRead ( $idInput5 )
		Local $sStringInName = GUICtrlRead ( $idInput1 )
		If Not $sStringInName Then $iIsStringsInFileName = 1
		If Not $sStringToFind1 And Not $sStringToFind2 And Not $sStringInName Then
			GUICtrlSetState ( $idProgressBar, $GUI_HIDE )
			GUICtrlSetData ( $idProgressBar, 0 )
			$sStatusBarText = _GUICtrlStatusBar_GetText ( $hStatusBar, 0 )
			_GUICtrlStatusBar_SetText ( $hStatusBar, 'No String found, Search Canceled' )
			AdlibRegister ( '_GuiStatusBarTextTimer', 3000 )
			Return
		EndIf
		$sLastSelectDir = $sSearchDir
		_GUICtrlStatusBar_SetText ( $hStatusBar, 'Root Search : ' & _GetCompactPath ( $sSearchDir, 460 ) )
		If FileExists ( $sLastSelectDir ) Then _SaveLastRoot ( $sLastSelectDir )
		_GuiCtrlComboSetData ()
		$iSearchTimerInit = TimerInit ()
		GUICtrlSetData ( $idLabelState, 'Wait when creating au3 files list...' )
		GUICtrlSetState( $idLabelState, $GUI_SHOW )
		Local $aFileList = __FileSearch ( $sSearchDir, '*.au3' )
		GUICtrlSetState ( $idLabelState, $GUI_HIDE )
		GUICtrlSetState ( $idProgressBar, $GUI_SHOW )
		Local $iPercent, $sFullName, $iAreStringsInFile, $sParentFolderPath
		Redim $aArray[1]
		For $i = 1 To UBound ( $aFileList ) -1
			If $iCancel Then
				$iUbound = UBound ( $aArray )-1
				If Not $iUbound Then $iUbound = 'no'
				ConsoleWrite ( StringFormat ( '%03i', @ScriptLineNumber ) & ' $iUbound : ' & $iUbound & @Crlf )
				GUICtrlSetState ( $idProgressBar, $GUI_HIDE )
				GUICtrlSetData ( $idLabelState, $iUbound & _Iif ( $iUbound = 1, ' file was found', ' files were found' ) & _
					_Iif ( $iUbound > 0, ' in ' & _TimeToString ( TimerDiff ( $iSearchTimerInit ) ), '' ) )
				GUICtrlSetState( $idLabelState, $GUI_SHOW )
				GUICtrlSetData ( $idProgressBar, 0 )
				Return
			EndIf
			$iPercent = ( $i *100/ ( UBound ( $aFileList ) -1 ) )
			GUICtrlSetData ( $idProgressBar, $iPercent )
			$sFullName = _GetFullNameByFullPath ( $aFileList[$i] )
			$iAreStringsInFile = _StringsInFile ( $aFileList[$i], $sStringToFind1, $sStringToFind2, $sStringToExclude1, $sStringToExclude2 )
			If $sStringToFind1 & $sStringToFind2 & $sStringToExclude1 & $sStringToExclude2 = '' Then $iAreStringsInFile = 1
			If $sStringInName Then
				If StringInStr ( $sFullName, $sStringInName ) = 0 Then
					$iIsStringsInFileName = 0
				Else
					$iIsStringsInFileName = 1
				EndIf
			EndIf
			If $iAreStringsInFile And $iIsStringsInFileName Then
				_ArrayAdd ( $aArray, $aFileList[$i] )
				$sParentFolderPath = _GetParentFolderPathByFullPath ( $aFileList[$i] )
				_GuiListView_AddItems ( $sFullName, $sParentFolderPath )
			EndIf
		Next
	EndIf
	GUICtrlSetState ( $idProgressBar, $GUI_HIDE )
	$iUbound = UBound ( $aArray )-1
	If Not $iUbound Then $iUbound = 'no'
	ConsoleWrite ( StringFormat ( '%03i', @ScriptLineNumber ) & ' $iUbound : ' & $iUbound & @Crlf )
	GUICtrlSetData ( $idLabelState, $iUbound & _Iif ( $iUbound = 1, ' file was found', ' files were found' ) & _
		_Iif ( $iUbound > 0, ' in ' & _TimeToString ( TimerDiff ( $iSearchTimerInit ) ), '' ) )
	GUICtrlSetState( $idLabelState, $GUI_SHOW )
	GUICtrlSetData ( $idProgressBar, 0 )
EndFunc ;==> _Au3Search ()

Func _Base64Decode ( $input_string ) ; by trancexx
	Local $struct = DllStructCreate ( 'int' )
	Local $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', 0, 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $a = DllStructCreate ( 'byte[' & DllStructGetData ( $struct, 1) & ']' )
	$a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', DllStructGetPtr ( $a ), 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 2, 0, '' )
	Return DllStructGetData ( $a, 1 )
EndFunc ;==> _Base64Decode ()

Func _Exit ()
	DllCall ( 'gdi32.dll', 'int', 'DeleteObject', 'hwnd', $hBrush )
	_GDIPlus_GraphicsDispose ( $hGraphic1 )
	_GDIPlus_ImageDispose ( $hImage1 )
	_GDIPlus_Shutdown ()
	Exit
EndFunc ;==> _Exit ()

Func _FileInstall ()
	Local $sUrl = 'http://tinyurl.com/bu7lnrn'
	If Not FileExists ( $sTempDir ) Then Dircreate ( $sTempDir )
	If Not FileExists ( 'C:\Loupe2.ico' ) Then Loupe2Ico ( 'Loupe2.ico', 'C:\' )
	If Not FileExists ( $sTempDir & '\TinyAu3FilesSearch1.png' ) Then Tinyau3Filessearch1Png ( 'TinyAu3FilesSearch1.png', $sTempDir )
EndFunc ;==> _FileInstall ()

Func _FileMissing ()
	If Not FileExists ( $sTempDir ) Then Return True
	If Not FileExists ( 'C:\Loupe2.ico' ) Then Return True
	If Not FileExists ( $sTempDir & '\PreLoader1.gif' ) Then Return True
EndFunc ;==> _FileMissing ()

Func _GetCompactPath ( $sPath, $iSize=0 )
	Local $tPath, $pPath
	$tPath = DllStructCreate ( 'char[260]' )
	$pPath = DllStructGetPtr ( $tPath )
	DllStructSetData ( $tPath, 1, $sPath )
	DllCall ( 'Shlwapi.dll', 'BOOL', 'PathCompactPath', 'handle', '', 'ptr', $pPath, 'int', $iSize )
	Return DllStructGetData ( $tPath, 1 )
EndFunc ;==> _GetCompactPath ()

Func _GetFullNameByFullPath ( $sFullPath )
	Local $sFileName = StringSplit ( $sFullPath, '\' )
	If Not @error Then Return $sFileName[$sFileName[0]]
EndFunc ;==> _GetFullNameByFullPath ()

Func _GetLastRootDir ()
	Local $sRegValues, $sRegValue
	For $i = 1 To 100
		$sRegValues = RegEnumVal ( $sRegKeySettings, $i )
		If @error <> 0 Then ExitLoop
		If StringInStr ( $sRegValues, 'LastSelectDir' ) Then $sRegValue = RegRead ( $sRegKeySettings, $sRegValues )
	Next
	If FileExists ( $sRegValue ) Then Return $sRegValue
EndFunc ;==> _GetLastRootDir ()

Func _GetParentFolderPathByFullPath ( $sFullPath=@ScriptFullPath )
	Local $sFilePath = StringLeft ( $sFullPath, StringInStr ( $sFullPath, '\', 0, -1 ) - 1 )
	If Not @error Then Return $sFilePath
EndFunc ;==> _GetParentFolderPathByFullPath ()

Func _Gui ()
	$hGui = GUICreate ( $sSoftTitle & ' by wakillon', 500, 650 )
;~ 	GUISetFont ( 8, 600 )
	GUISetBkColor ( $iGuiBkColor )
	$idButtonSearch = GUICtrlCreateButton ( 'Search', 30, 595, 440, 20 )
	GUICtrlCreateGroup ( '', 30, 60, 440, 230 )
	GUICtrlSetDefColor ( $iBaseColor, $hGui )
	$idLabel[0] = GUICtrlCreateLabel ( 'String To Find in Name : ', 60, 128 )
	$iLabelColor[0] = $iBaseColor
	$idInput1 = GUICtrlCreateInput ( '', 190, 125, 250, 20 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetFont ( -1, 9, 600 )
	$idLabel[1] = GUICtrlCreateLabel ( '1° String To Find in file : ', 60, 158 )
	$iLabelColor[1] = $iBaseColor
	$idInput2 = GUICtrlCreateInput ( '', 190, 155, 250, 20 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetFont ( -1, 9, 600 )
	$idLabel[2] = GUICtrlCreateLabel ( '2° String To Find in file : ', 60, 188 )
	$iLabelColor[2] = $iBaseColor
	$idInput3 = GUICtrlCreateInput ( '', 190, 185, 250, 20 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetFont ( -1, 9, 600 )
	GUICtrlSetState ( -1, $GUI_DISABLE )
	$idLabel[3] = GUICtrlCreateLabel ( '1° Excluded String in file : ', 60, 218 )
	$iLabelColor[3] = $iBaseColor
	$idInput4 = GUICtrlCreateInput ( '', 190, 215, 250, 20 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetFont ( -1, 9, 600 )
	GUICtrlSetState ( -1, $GUI_DISABLE )
	$idLabel[4] = GUICtrlCreateLabel ( '2° Excluded String in file : ', 60, 248 )
	$iLabelColor[4] = $iBaseColor
	$idInput5 = GUICtrlCreateInput ( '', 190, 245, 250, 20 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetFont ( -1, 9, 600 )
	GUICtrlSetState ( -1, $GUI_DISABLE )
	$idProgressBar = GUICtrlCreateProgress ( 30, 306, 440, 14 )
	GUICtrlSetState ( -1, $GUI_HIDE )
	$idLabelState = GUICtrlCreateLabel ( '', 30, 305, 440, 25, 0x01 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetState ( -1, $GUI_HIDE )
	$hListView = _GUICtrlListView_Create ( $hGui, '', 30, 335, 440, 250, BitOr ( $LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS ) )
	_GUICtrlListView_AddColumn ( $hListView, 'Name', 240 )
	_GUICtrlListView_AddColumn ( $hListView, 'Directory', 500 )
	_GUICtrlListView_AddColumn ( $hListView, 'Size', 40 )
	_GUICtrlListView_JustifyColumn ( $hListView, 2, 1 )
	_GUICtrlListView_SetColumnOrder ( $hListView, '0|2|1' )
	_GUICtrlListView_SetExtendedListViewStyle ( $hListView, BitOR ( $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP, $LVS_EX_DOUBLEBUFFER ) )
	_GUICtrlListView_RegisterSortCallBack ( $hListView )
	_GUICtrlListView_SetBkColor ( $hListView, 0x000000 )
	_GUICtrlListView_SetTextColor ( $hListView, 0x55BBFF )
	_GUICtrlListView_SetTextBkColor ( $hListView, 0x000000 )
	_GDIPlus_StartUp ()
	GUISetIcon ( 'C:\Loupe2.ico' )
	$hImage1 = _GDIPlus_ImageLoadFromFile ( $sTempDir & '\TinyAu3FilesSearch1.png' )
	$hGraphic1 = _GDIPlus_GraphicsCreateFromHWND ( $hGui )
	$hStatusBar = _GUICtrlStatusBar_Create ( $hGui )
	_GUICtrlStatusBar_SetMinHeight ( $hStatusBar, 25 )
	Local $sComboText
	If Not $sLastSelectDir Then
		$sComboText = '*Choose search root'
		_GUICtrlStatusBar_SetText ( $hStatusBar, 'Next Search Root will be choosen manually.' )
	Else
		_GUICtrlStatusBar_SetText ( $hStatusBar, 'Root Search : ' & _GetCompactPath ( $sLastSelectDir, 460 ) )
	EndIf
	If Not FileExists ( $sLastSelectDir ) Then $sLastSelectDir = @DesktopDir
	$idComboRoot = GUICtrlCreateCombo ( $sComboText, 60, 90, 380, 20, BitOR ( $CBS_SIMPLE, $CBS_DROPDOWN, $CBS_SORT ) )
	$sComboRead = GUICtrlRead ( $idComboRoot )
	_GuiCtrlComboSetData ()
	GUIRegisterMsg ( $WM_PAINT, '_WM_PAINT' )
	GUIRegisterMsg ( $WM_NCPAINT, '_WM_PAINT' )
	GUIRegisterMsg ( $WM_COMMAND, '_WM_COMMAND' )
	GUIRegisterMsg ( $WM_SYSCOMMAND, '_WM_SYSCOMMAND' )
	GUIRegisterMsg ( $WM_NOTIFY, '_WM_NOTIFY' )
	GUIRegisterMsg ( $WM_SETCURSOR, '_WM_SETCURSOR' )
	GUIRegisterMsg ($WM_CTLCOLORLISTBOX, '_WM_CTLCOLORLISTBOX' )
	GUISetState ()
EndFunc ;==> _Gui ()

Func _GuiCtrlComboSetData ()
	Local $sRegValues, $sRegValue, $sCombo = ''
	If Not _IsRootAlreadySaved ( @DesktopDir ) Then $sCombo = @DesktopDir
	For $i = 1 To 100
		$sRegValues = RegEnumVal ( $sRegKeySettings, $i )
		If @error <> 0 Then ExitLoop
		If StringInStr ( $sRegValues, 'LastSelectDir' ) Then
			$sRegValue = RegRead ( $sRegKeySettings, $sRegValues )
			If FileExists ( $sRegValue ) Then $sCombo &= '|' & _GetCompactPath ( $sRegValue, 460 )
		EndIf
	Next
	If StringLeft ( $sCombo, 1 ) = '|' Then $sCombo = StringTrimLeft ( $sCombo, 1 )
	GUICtrlSetData ( $idComboRoot, '', '' )
	GUICtrlSetData ( $idComboRoot, '*Choose search root|' & $sCombo, $sLastSelectDir )
EndFunc ;==> _GuiCtrlComboSetData ()

Func _GuiListView_AddItems ( $sName, $sPath )
	Local $iIndex = _GUICtrlListView_AddItem ( $hListView, $sName, -1, _GUICtrlListView_GetItemCount ( $hListView ) )
	_GUICtrlListView_AddSubItem ( $hListView, $iIndex, $sPath, 1 )
	_GUICtrlListView_AddSubItem ( $hListView, $iIndex, Ceiling ( FileGetSize ( $sPath & '\' & $sName )/1024 ), 2 )
EndFunc ;==> _GuiListView_AddItems ()

Func _GuiResetLabelColor ()
	Local $aCursorInfo = GUIGetCursorInfo ( $hGui )
	For $i = 0 To UBound ( $iLabelColor ) -1
		If $idLabel[$i] <> $aCursorInfo[4] And $iLabelColor[$i] <> $iBaseColor Then
			GUICtrlSetColor ( $idLabel[$i], $iBaseColor )
			$iLabelColor[$i] = $iBaseColor
		EndIf
	Next
	AdlibUnRegister ( '_GuiResetLabelColor' )
EndFunc ;==> _GuiResetLabelColor ()

Func _GuiStatusBarTextTimer ()
	_GUICtrlStatusBar_SetText ( $hStatusBar, $sStatusBarText )
	AdlibUnRegister ( '_GuiStatusBarTextTimer' )
EndFunc ;==> _GuiStatusBarTextTimer ()

Func _Iif ( $fTest, $vTrueVal, $vFalseVal )
	If $fTest Then
		Return $vTrueVal
	Else
		Return $vFalseVal
	EndIf
EndFunc ;==> _Iif ()

Func _IsPressed ( $sHexKey, $vDLL = 'user32.dll' )
	Local $aRet = DllCall ( $vDLL, 'short', 'GetAsyncKeyState', 'int', '0x' & $sHexKey )
	If @error Then Return SetError ( @error, @extended, False )
	Return BitAND ( $aRet[0], 0x8000 ) <> 0
EndFunc ;==> _IsPressed ()

Func _IsRootAlreadySaved ( $sDir )
	Local $sRegValues
	For $i = 1 To 100
		$sRegValues = RegEnumVal ( $sRegKeySettings, $i )
		If @error <> 0 Then ExitLoop
		If StringInStr ( $sRegValues, 'LastSelectDir' ) And RegRead ( $sRegKeySettings, $sRegValues ) = $sDir Then Return 1
	Next
EndFunc ;==> _IsRootAlreadySaved ()

Func _LzmaDec ( $Source ) ; by Ward
	Local $sLzmadll = @TempDir & '\LZMA.DLL'
	If Not FileExists ( $sLzmadll ) Then Lzmadll ( 'LZMA.DLL', @TempDir )
	If @error Then Return SetError ( 1, 0, $Source )
	If BinaryLen ( $Source ) < 9 Then Return SetError ( 2, 0, $Source )
	Local $Src = DllStructCreate ( 'byte[' & BinaryLen ( $Source ) & ']' ), $aRet
	DllStructSetData ( $Src, 1, $Source )
	$aRet = DllCall ( $sLzmadll, 'uint:cdecl', 'LzmaDecGetSize', 'ptr', DllStructGetPtr ( $Src ) )
	If @Error Then Return SetError ( 3, 0, $Source )
	Local $DestSize = $aRet[0]
	If $DestSize = 0 Then Return SetError ( 4, 0, $Source )
	Local $Dest = DllStructCreate ( 'byte[' & $DestSize & ']' )
	$aRet = DllCall ( $sLzmadll, 'int:cdecl', 'LzmaDec', 'ptr', DllStructGetPtr ( $Dest ), 'uint*', $DestSize, 'ptr', DllStructGetPtr ( $Src ), 'uint', BinaryLen ( $Source ) )
	If Not @Error Then
		Return SetExtended ( $aRet[0], DllStructGetData ( $Dest, 1 ) )
	Else
		Return SetError ( 5, 0, $Source )
	EndIf
EndFunc ;==> _LzmaDec ()

Func _OnTop ()
	Local $sHandle = WinGetHandle ( AutoItWinGetTitle () )
	WinSetOnTop ( $sHandle, '', 1 )
	Return $sHandle
EndFunc ;==> _OnTop ()

Func _SaveLastRoot ( $sDir )
	Local $sRegValues, $i
	While 1
		$i+=1
		$sRegValues = RegEnumVal ( $sRegKeySettings, $i )
		If @error <> 0 Then ExitLoop
		If RegRead ( $sRegKeySettings, $sRegValues ) = $sDir Then RegDelete ( $sRegKeySettings, $sRegValues )
	WEnd
	RegWrite ( $sRegKeySettings, @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & '|LastSelectDir', 'REG_SZ', $sLastSelectDir )
EndFunc ;==> _SaveLastRoot ()

Func _SciTEGetPath ()
	Local $sScitePath = @ProgramFilesDir & '\AutoIt3\SciTE\SciTE.exe'
	If Not FileExists ( $sScitePath ) Then $sScitePath = RegRead ( 'HKLM\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir' ) & '\SciTE\scite.exe'
	If Not FileExists ( $sScitePath ) Then
		$sScitePath = RegRead ( $sRegKeySettings, 'SciTEPath' )
		If @error Or Not FileExists ( $sScitePath ) Then
			$sScitePath = FileOpenDialog ( 'SciTE Path', @ScriptDir, '(*.exe)', 1 + 2, 'SciTE.exe', _OnTop () )
			If StringRight ( $sScitePath, 9 ) <> 'SciTE.exe' Then
				$sScitePath = ''
			Else
				RegWrite ( $sRegKeySettings, 'SciTEPath', 'REG_SZ', $sScitePath )
			EndIf
		EndIf
	EndIf
	Return SetError ( Not FileExists ( $sScitePath ), 0, $sScitePath )
EndFunc ;==> _SciTEGetPath ()

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

Func _Singleton ( $sOccurenceName, $iFlag=0 )
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
				$tSecurityAttributes = DllStructCreate ( $tagSECURITY_ATTRIBUTES )
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
	Local $aRet = StringRegExp ( $s_String, '(?s)' & $s_case & $s_Start & '(.*?)' & $s_End, 3 )
	If @error Then Return SetError ( 1, 0, 0 )
	Return $aRet
EndFunc ;==> _StringBetween ()

Func _StringsInFile ( $sFilePath, $sString1, $sString2='', $sExcludeString1='', $sExcludeString2='', $iCase=0 )
	Local $sFileString
	Local $hFileOpen = FileOpen ( $sFilePath, 0 )
	If Not @error Then
		$sFileString = FileRead ( $hFileOpen )
		If Not @error Then
			FileClose ( $hFileOpen )
			If $sExcludeString1 <> '' And StringInStr ( $sFileString, $sExcludeString1, $iCase ) <> 0 Then Return 0
			If $sExcludeString2 <> '' And StringInStr ( $sFileString, $sExcludeString2, $iCase ) <> 0 Then Return 0
			If StringInStr ( $sFileString, $sString1, $iCase ) <> 0 Then
				If $sString2 Then
					If StringInStr ( $sFileString, $sString2, $iCase ) <> 0 Then Return 1
				Else
					Return 1
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc ;==> _StringsInFile ()

Func _TicksToTime ( $iTicks, ByRef $iHours, ByRef $iMins, ByRef $iSecs )
	If Number ( $iTicks ) > 0 Then
		$iTicks = Int ( $iTicks / 1000 )
		$iHours = Int ( $iTicks / 3600 )
		$iTicks = Mod ( $iTicks, 3600 )
		$iMins = Int ( $iTicks / 60 )
		$iSecs = Mod ( $iTicks, 60 )
		Return 1
	ElseIf Number ( $iTicks ) = 0 Then
		$iHours = 0
		$iTicks = 0
		$iMins = 0
		$iSecs = 0
		Return 1
	Else
		Return SetError ( 1, 0, 0 )
	EndIf
EndFunc ;==> _TicksToTime ()

Func _TimeToString ( $iTimer, $iLeaveZero=0 )
	Local $iSecs, $iMins, $iHours
	_TicksToTime ( $iTimer, $iHours, $iMins, $iSecs )
	$iMins = StringFormat ( '%02d ', $iMins ) & 'min'
	If Not $iLeaveZero And $iMins = 0 Then $iMins = ''
	$iSecs = StringFormat ( '%02d ', $iSecs ) & 'sec'
	If Not $iLeaveZero And $iSecs = 0 Then $iSecs = ''
	Return StringStripWS ( $iMins & ' ' & $iSecs, 7 )
EndFunc ;==> _TimeToString ()

Func _WM_COMMAND ( $hWnd, $msg, $wParam, $lParam )
	Local $nNotifyCode = BitShift ( $wParam, 16 )
	Switch $hWnd
		Case $hGui
			Local $nID = BitAND ( $wParam, 0x0000FFFF )
			Switch $nID
				Case $idButtonSearch
					Switch GUICtrlRead ( $idButtonSearch )
						Case 'Search'
							$iSearch = 1
							GUICtrlSetData ( $idButtonSearch, 'Cancel' )
						Case 'Cancel'
							$iCancel = 1
							GUICtrlSetData ( $idButtonSearch, 'Search' )
					EndSwitch
				Case $idInput1
					Switch $nNotifyCode
						Case $EN_CHANGE
							If GUICtrlRead ( $idInput1 ) <> '' Then GUICtrlSetState ( $idInput4, $GUI_ENABLE )
					EndSwitch
				Case $idInput2
					Switch $nNotifyCode
						Case $EN_CHANGE
							If GUICtrlRead ( $idInput2 ) <> '' Then
								GUICtrlSetState ( $idInput3, $GUI_ENABLE )
								GUICtrlSetState ( $idInput4, $GUI_ENABLE )
							Else
								GUICtrlSetState ( $idInput3, $GUI_DISABLE )
								GUICtrlSetState ( $idInput4, $GUI_DISABLE )
							EndIf
					EndSwitch
				Case $idInput4
					Switch $nNotifyCode
						Case $EN_CHANGE
							If GUICtrlRead ( $idInput4 ) <> '' Then
								GUICtrlSetState ( $idInput5, $GUI_ENABLE )
							Else
								GUICtrlSetState ( $idInput5, $GUI_DISABLE )
							EndIf
					EndSwitch
				Case $idComboRoot
					Switch $nNotifyCode
						Case $CBN_SELENDOK
							If Not FileExists ( $sLastSelectDir ) Then $sLastSelectDir = @DesktopDir
							$sComboRead = GUICtrlRead ( $idComboRoot )
							Switch $sComboRead
								Case '*Choose search root'
									$iSelectDir = 1
									_GUICtrlStatusBar_SetText ( $hStatusBar, 'Next Search Root will be choosen manually.' )
									Return $GUI_RUNDEFMSG
								Case Else
									If Not StringInStr ( $sComboRead, '...\' ) Then
										$sSearchDir = $sComboRead
									Else
										For $i = 1 To 100
											Local $sRegValues = RegEnumVal ( $sRegKeySettings, $i )
											If @error <> 0 Then ExitLoop
											If StringInStr ( $sRegValues, 'LastSelectDir' ) Then
												Local $sRegValue = RegRead ( $sRegKeySettings, $sRegValues )
												If FileExists ( $sRegValue ) And $sComboRead == _GetCompactPath ( $sRegValue, 460 ) Then
													$sSearchDir = $sRegValue
													ExitLoop
												EndIf
											EndIf
										Next
									EndIf
							EndSwitch
							If Not FileExists ( $sSearchDir ) Then $sSearchDir = @DesktopDir
							_GUICtrlStatusBar_SetText ( $hStatusBar, 'Root Search : ' & _GetCompactPath ( $sSearchDir, 460 ) )
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_COMMAND ()

Func _WM_CTLCOLORLISTBOX ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $hGui
			DllCall ( 'gdi32.dll', 'int', 'SetTextColor', 'hwnd', $wParam, 'int', 0x00AAFF )
			DllCall ( 'gdi32.dll', 'int', 'SetBkColor', 'hwnd', $wParam, 'int', 0x000000 )
			If Not $hBrush Then
				$hBrush = DllCall ( 'gdi32.dll', 'hwnd', 'CreateSolidBrush', 'int', 0x000000 )
				$hBrush = $hBrush[0]
			EndIf
			Return $hBrush
	EndSwitch
EndFunc ;==> _WM_CTLCOLORLISTBOX ()

Func _WM_NOTIFY ( $hWnd, $Msg, $wParam, $lParam )
	Local $hWndFrom, $iCode, $tNMHDR
	$tNMHDR = DllStructCreate ( $tagNMHDR, $lParam )
	$hWndFrom = HWnd ( DllStructGetData ( $tNMHDR, 'hWndFrom' ) )
	$iCode = DllStructGetData ( $tNMHDR, 'Code' )
	Local $iItem, $sSelectedItem1, $sSelectedItem2, $sSelectedItem
	Switch $hWndFrom
		Case $hListView
			Local $tInfo = DllStructCreate ( $tagNMLISTVIEW, $lParam )
			$iItem = DllStructGetData ( $tInfo, 'Item' )
			Switch $iCode
				Case $NM_DBLCLK
					If $iItem >= 0 Then
						$sSelectedItem1 = _GUICtrlListView_GetItemText ( $hWndFrom, _GUICtrlListView_GetSelectedIndices ( $hWndFrom ), 0 )
						$sSelectedItem2 = _GUICtrlListView_GetItemText ( $hWndFrom, _GUICtrlListView_GetSelectedIndices ( $hWndFrom ), 1 )
						If FileExists ( $sSelectedItem2 & '\' & $sSelectedItem1 ) Then Run ( $sSciTEPath & ' -import:mono "' & $sSelectedItem2 & '\' & $sSelectedItem1 & '"' )
					EndIf
				Case $LVN_COLUMNCLICK
					_GUICtrlListView_SortItems ( $hWndFrom, DllStructGetData ( DllStructCreate ( $tagNMLISTVIEW, $lParam ), 'SubItem' ) )
				Case $LVN_ENDSCROLL
					_GUICtrlListView_RedrawItems ( $hWndFrom, 0, _GUICtrlListView_GetItemCount ( $hWndFrom )-1 )
				Case $NM_CLICK
					If $iItem >= 0 And _IsPressed ( '10' ) Then ; 10 Left SHIFT key
						$sSelectedItem = _GUICtrlListView_GetItemText ( $hWndFrom, _GUICtrlListView_GetSelectedIndices ( $hWndFrom ), 1 )
						If FileExists ( $sSelectedItem ) Then Run ( @WindowsDir & '\explorer.exe "' & $sSelectedItem & '"' )
					EndIf
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_NOTIFY ()

Func _WM_PAINT ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $hGui
			_WinAPI_RedrawWindow ( $hGui, 0, 0, $RDW_UPDATENOW )
			_GUICtrlListView_RedrawItems ( $hListView, 0, UBound ( $aArray ) -1 )
			_GDIPlus_GraphicsDrawImageRect ( $hGraphic1, $hImage1, 75, 10, 350, 40 )
			_WinAPI_RedrawWindow ( $hGui, 0, 0, $RDW_VALIDATE )
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_PAINT ()

Func _WM_SETCURSOR ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $hGui
			Switch _WinAPI_GetDlgCtrlID ( $wParam )
				Case $idLabel[0]
					If  $iLabelColor[0] <> $iOverColor Then
						GUICtrlSetColor ( $idLabel[0], 0xFF0000 )
						$iLabelColor[0] = 0xFF0000
						AdlibRegister ( '_GuiResetLabelColor', 500 )
					EndIf
				Case $idLabel[1]
					If  $iLabelColor[1] <> $iOverColor Then
						GUICtrlSetColor ( $idLabel[1], 0xFF0000 )
						$iLabelColor[1] = 0xFF0000
						AdlibRegister ( '_GuiResetLabelColor', 500 )
					EndIf
				Case $idLabel[2]
					If  $iLabelColor[2] <> $iOverColor Then
						GUICtrlSetColor ( $idLabel[2], 0xFF0000 )
						$iLabelColor[2] = 0xFF0000
						AdlibRegister ( '_GuiResetLabelColor', 500 )
					EndIf
				Case $idLabel[3]
					If  $iLabelColor[3] <> $iOverColor Then
						GUICtrlSetColor ( $idLabel[3], 0xFF0000 )
						$iLabelColor[3] = 0xFF0000
						AdlibRegister ( '_GuiResetLabelColor', 500 )
					EndIf
				Case $idLabel[4]
					If  $iLabelColor[4] <> $iOverColor Then
						GUICtrlSetColor ( $idLabel[4], $iOverColor )
						$iLabelColor[4] = 0xFF0000
						AdlibRegister ( '_GuiResetLabelColor', 500 )
					EndIf
				Case Else
					For $i = 0 To UBound ( $iLabelColor ) -1
						If $iLabelColor[$i] <> $iBaseColor Then
							GUICtrlSetColor ( $idLabel[$i], $iBaseColor )
							$iLabelColor[$i] = $iBaseColor
						EndIf
					Next
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_SETCURSOR ()

Func _WM_SYSCOMMAND ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $hGui
			If $wParam = $SC_CLOSE Then _Exit ()
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_SYSCOMMAND ()

Func Loupe2Ico ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = "XQAAAAS+CAAAuwAAYASQLCQLm5KaOc5lAZKuizO2HrryLpcnZgHEfexA1C2bFhJa6jjyEpZxnzk4Cmod6gySVliQxKyi/AwOUOfg75Q5nZayWZU+php73N9Ppry1SL43guEvI8nUWOeU3fYIqRqHUiM6W/IeIFPM2ATYsTzDXUEIn+LPqbWmbVbjN+UEMYeeOPtb6qJ7g71LRNOKHKd3hI+ktZrTeuCNprhQWAGxl9v3qy50AnDk+Tzz8nYdx/QOS5C/W/RO4jaE9a8oZlOmQZPZezy3pN48kz7ZThnHX/GEklwUil1Y76aZTnfLah+LCWd5wOYGhZPjc0gtL0ckg1cmPv/zAPTO5KZ9IhRdymFdFu5RBR+04e8X2zQn7RxjKm6oqQjKZ8jOmOakJKEIJfnTnEMN8LDn/HsRFOndLJcMdqw3he6gPt0QGyx1tFFVVbKBS45sqCUpjFsTf/aSeJUwouVpU+mgME9+HmFwYCVjxnQwJvIkHA/UItwNQr49Um5DhqdRsaFATqD+Mv9Udv5LGGu6VStDbjHeiAhainXunv5nCu1CrH7g0b1klGLAVPvU+T0XucGeeqUp809nHSKlncEyWKVU1oQQXu/hVbcdhXaDt5XFVHar0WPuGYAW2MA6zJ2fr2RSXnxqVq77LQC8VSNaSRFTHk+9R3/ILW0JSJqkUpSWPkIE4oiaIY2+JIf4S7OtLKWxsfrHHgHxSNJwAMErBzj7t6PCkMaXEhPjaqPwtpfQMB2in1FX8QUd5uUeEPoVfILqB+Eawjq212JdFUpXviNCqCerVGoIhUIB8HchzENJkQhrov3NBJRIed8o89cPZT3NHDMns1Q9hmgqIdc13/qsDj77RLY6kjvwZMyKj8g1YpXJ9PGqhzbxaNdZ+4YC4RroTtRL2boTyhO3STy7NwhhSxaf9KETLMSrADAQXuhehNH7J6NzpSL9rfKFrwr3axrtaU76nKvPCBxSC36W2wzgKDKjrCq+GOT89L4dqGCG7a9nI6+9nRuqcZnKtww6dKet3zxwzC7duGk590P3owePxvByHmypSZGTp2lvQU4HqrAHDDpCvFAiCAOrTLFqGqsP1GNZT0k+ZmvBKIWnCT8Bdsz1oZlNdCxQv/YTiwvHQw0UysmFDjzyDtFNIMbKU2YcqlCo28fscaz3tZmyRvXSHhjmGo5BI6015hdeDUAxj+FY+di3ZeoMWp1VffM7OA6QuXivWYd89mYITm8QXDu16YTeQBr01QfuOxbBJJ/WdShkLZyIFm1ROrcV96IR1NEexuoloiKHAbPuZjZD46Qxk7+PFsRWEQSLeuyFBHMlKiYgRN0elP4o7xBCU4rhp1zCxkT/5odXdto922LXwy7HClFjWjph9rEeUtOZ6QGMx9xDyAau+4lGaq+mdiQEw4fw3VbTlhyAXmNvL0TgW1gbX0d0+x4gYveNc+Fm4mAOzq9+PMAuv/vpT+AqPbztBHLiVJOzNyVOGkm8sxTQIbTogZ+mHGJPYWCHdW3cXcH0aQFp1w3nDnkA"
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
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
EndFunc ;==> Loupe2Ico ()

Func Lzmadll ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = "0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000D00000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000A343B8DAE722D689E722D689E722D689643ED889E622D689883DD289E522D689E722D789F422D689693DC289E622D689E722D689EF22D689693DC589E322D68952696368E722D6890000000000000000504500004C010300448DAF4B0000000000000000E0000E210B01050C00600000001000000080000090E100000090000000F000000000001000100000000200000400000000000000040000000000000000000100001000000000000002000000000010000010000000001000001000000000000010000000C8F000007000000000F00000C800000000000000000000000000000000000000000000000000000038F100000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555058300000000000800000001000000000000000040000000000000000000000000000800000E0555058310000000000600000009000000054000000040000000000000000000000000000400000E055505832000000000010000000F000000002000000580000000000000000000000000000400000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000332E303300555058210D090208106E62B27EE4412138C300008351000000A4000026030030FFFF77FFC800010053B28CB9060088C82C01516A0859D0E8730230D0E2F85988FFFFFFFF840DFFFEFFFFE2E68B5D088B4D0C8A451085DB7413E3118A1330C20FB6D23284FFFFFFDB15001DFF43E2EF5BC9C20C005589E5FF750CE80300974283C4045DC3FDEDC8650F48C81062536A058F45F8DDFEFFBF4E0C833B0A73088323006A0758EB5A832B0AC745F01D004BDBDB6DB306F45B8D0D50503C1C6A0009F8EDCBB275080802181410538B4536DB7FFFEEC00A505647FC8945FC83030A9C45148943052D6A6BDB76F70953E82A92884309722C15FC9876FD9C6C65145DECF0836D14DD6EFFBF344D108B550C8B0239410573058B04890269EC509EEDB6BB03F45045055108145069105273FF67E77E6D670CC424837DF4027505B659F2CC7D5D5FC9E553817BAEFE777BDBCA381F8B8DEB0F686B016EFFFDFFC2CD3C31C05B02435243204572726F720D0A00CCAE61738F0055B80192435D4090008CBDBB734EE1C7000515C74024000604C9C9D69D2CD9FF06201CC9C9C9C91814100C0FDFDEC908283E7C908D7426A4567F2F2C6CAF55311ACA0F88EE7B1A8B423DF6EEFF0485C0752583FB050F8F8C118D4C1B0E96D3E089B2BD5FBB1A8DB43514BC27062B08E7F97CB73815010A0CFE0010963FCB9FE7721485F6CB4A1885C9A9ED32F67D5A1C6F8E2B207867746DFBB79B240ED1F9178D41107502D1F86B241B1582B59B2C2B5B5EAD7636E81EBABF96060F95C048250CFE150493E977EB885D54022CCF90096FB8021880B50905754B433FDE601FDAC76D3DEB900FBB426B7763EF3E01FE8DB65FDBAD95C3899F536BFF72F66E906F9F83E0E08D484089C217D76E98ED631404F3F089DE100AE57BDB585710730B4DBBC22097C10B420803376F1BDF7F23A4E583EC3C8975F8B9248B4B8985EEDFF87DFC8D7DC860C8F3A5890424E88AECF125CC2EB7CC18F88B89ECB86FB7FB6EEF55BA664357BFDB563F53BB110D0BFFEDC606024601019089D989F84349A9C1C2DBFF6FBAEB0690881C32404239C872F743B2157EE109F962C7DC5F51E98DBF4F8E18BDF1B799897310895DF48B460F1F39D87BBBD02EF589C30A5F5C241A44240495DBE51D6F0CA0BF60295E08015E1A1F6B7C97B98B2DAA764F575052351ECE7D1CBB4848A73A5CC1F76F6FBF210881C280C33C05102C0489142481C718BD0877AF8B39575125B9312A894C2492452E772BC80B04587425B9BBBF93B000528248191B870897C9EDEFB680CF8FF042C1E3058D343B0190A37DB7B74EB583AC25288D930589CCDBB22C4BB789410508080C0CCBB22CCB101014141818BFB6B92D1C2F8C27411C3E088D8E17027BDDE401CD8605413BDBE9B75AFFAD1D"
	$sFileBin &= "F00B0F8E67760C03427BF709F08D9F640981C60C2906AF77EBBBDB74DAB8801883EE80891C4DEB80EC7B6BFD4808FF4DF079E0972F97640538C8C8F7B7812C918784010B3088C8C8C8C8348C3890C8C8C8C83C944098C8C8C8C8449C48A0C8C8C8C84CA450A8C8C8C8C854AC58B0C8C8C8C85CB460B8C8C8C8C864BC68C0C8C8C8C86CC470C8C8C8C8C874CC78D0C8C8C8C87CD480D8C3C8C8C884DC88E09C384EC7F8C8050C2B2DB9E42144EF4663605CCF31F02B2C1919D9CA48060BF44CF81C19191950FC54002C323232F258045C0839323232600C643819C8C8C8F3F8963CFC40979F91E7009744048AA0BCB8009D8E3F743AD3E68B91A825ED1C913608B2BA54291CB373226958AF5F102CD353026480C35A05649E4E03A45F5665892A7D84745F0301FB179636687056DC14531486454A81F40B5F50BD91DA3B5F08476E86058C2C43255F5DB7C329765B80E4BEE4F25832B29DDAEF640B8830323232328C34903832323232943C9840323232329C44A04832323232A44CA85032323232AC54B05832323232B45CB86032323232BC64C06832323232C46CC87032323232CC74D07832323232D47CD88033323232DC84E0884C96CCD65587875874A719416A416E5E56C791CE7824D5896B8B9AD191EE34D28B6589710B5091919191F854FC58232323CF002C5C0460089F232323640CF8963819798E8C3CFC3C009740D3E91919044417675C891348A56A5E89F65FC2C4480C9F4C048D4874749F6EB81B83189038895DA8B8A54D8FC142B71BF90822C991C483FAFD347FB6040BBD75C883FEB145BC3D6BF9CCCD062587A30A40989FFE7DC9F483009EB5DC89BB040845D083F857B6F8DD33868F251101BC76060D2FE1B62630BE6B8993984ABA6FB85FBF04398B9427B39C05FECC000FDB75BFB7941D83A4BC43D4850AEC36740F50BAC4ED65D8017E4C04037FC6C289E776044E6FBB7145E056E0BC9CCD456B3F16C70EF80989435F2FB80FD43A16BF7811BF0B8B7AEBB472F421CC0E2F8B5020ADA391ED395B0D060C007D767DC606011314C6406A5018CEC9168C7D062C30E8B2782F384F8F5D856EB150FD93758E70308E521BD9B674795D8C759011FC3C8E75A3F18B53B329C68DF587FE7783FF1239F07407C7433009C2D2017328D1B2ADBE932011532C04183B05BAD896EF6110D970058E5AE1BBFEA6FE76308B48DFB97EFF568BB52942C05F6E4B1483C20183D176B56CED00C1E6610E8989A0C4106F15728F4B2FFAF48845F76DBBDBDCEB09182A0C21004DF7741817876D77FF55F788104039431C7B7441C622FF4CFF36EC1B2CFFA509D075CC6550236B93FD89F0C1E8186788536A1D1078C789D86B0C7CEBB6FF89D7365A0BF3C20C4C8086F051ABFF1723890B74458B034E89F1D1E8960DBFF0AD94F255F0D3E8E401F7D821D00F43FDAEC085080C0C812BEE0077CEC165F083EDAC2BA725035CDC3E755F61241B246F0C2DF091E9C60D89C613213835BCFD37FF0FB71A89F9C1E90B89660FAFCB382B2BB4DD2C5F08CA29D8CF05775D4B18FFB781F96C66891876328916508FFB7EF7AD4EF8D811560C2B89FA29C329CA8DD13103DBD025A1E119890E36D3E163BFE9A96690FFC75689D60194B765386081CBA93F5789DA36DDDA6D5607FAC1EAB11456AC01DBB7B6D0150FE70E00FB5FE376DC9B188C210F573B56BEC1634BB9A13C4A084231C9BA851768EF4B1FDE63C9EB0356B4B7F6DF413D3C77F64A79EC619C83C31060D82DD76D80C85307326A76C853B7B3C5B64FD15198C97FC6536887BD5652489FC89D5B68EF6D3E144608A65DA325438742DBFA31C2C1418B483D0812D2AC75A7D488A66F86D79EC55F5C31FFB6070AD6150AAF049F441FECC89FE90CDBEE21F26501D0FF30596D50EECE5400CE70033C90EF330A07FBC8F7D021C676BD5A2E02381763081F6DD26008F0C6035185C655EC746F9460578B064FEC4FC118F8666B106E06D3EB83E30169326E1722722809D82E75D9560EDC72584F1C0C45313CECBB12B82910753955E85F7D34ED7FB624CF5F1C89FE83E601D1EF60AD8DB91BB23424635BFF38BA8009ECDC09F0423B7CD6CA1D8EC3482F2F31B45684FF80C231F6E0C6E309C3EB2856F80BBBC22BADD1EA230457F7DB81E30B1B5B701AD931C6F8521C19AF6DFF8101DE89D383FB01BF5BC85B7FE4DA77807AC4081DB347032FD88585D2511D2ACADB4BC3F6F183E153EE777801FFF7A4CFAD50480873E4A62E69214BEE4B75D4D96F081D6D81025B6166176A0405ED0DB6BF000444500406425D7F76F31B986B4DDB90B90B00238C1484155C1630CAED5F1F025AB660D881FAD1D2EA5FA34BF34D3FBC2055800415F686AD90CF944DDFEC8D0413B6BD6DEEFF17C1E00689CE8D8438044B14E811C281F26F8E8DEDC008D24604F7C1818B0C6DCE6CB7910E57021EE4151286C2B6DD96242101C819E0139673FA49E2A588894DDC5F3B75EC0F8307228D706BC80867CAB1B1F0F18D443B0407CCCEE4B88BD1DB4BDC0C04B246460776CE040F773D03EC1CCE76A3163F736514B5B5D26C46F83BDFA83A01E6DCC122F1414DE03F80418F3DFC3D0F76CC33318D9F11903AF0BA08E49BB9262D3577DCF0E862973072D63F480C0964C3BDCE848F08095F2081522B021FA8E524C12E18F8D639F32360731B26B75FEF536FDA436A8311DC1F72EC1BD813020DEB0D90004FC9391E18286AC32C4B7734F8D8DE589A106B4548A3DD602A6438967756C756C3B70D4C3A8911F5897CCFC1E2F13BDD0B29541A041D031B100CFBDD5DC06BA77416"
	$sFileBin &= "228B8493CF488907A44B5837157A915501156CA10D7080286ACFB6972DE7026B8D4797446E941A5DC2DE0F82EB8C903C27100803EFB03D472E938131CB21D8366913CE7F96E87928198703AED887EA28AF6EBAE930C111617504C97F0190342FB7A00141548E4018FF51140242C06816FF3F1568AF1D365726AA2A4D77F7F62B53628398068C839C10444443714325227439C67419B45B28B6FE85940D942039BBC64A6C3A7C15741ABB76F81896101E61322D41DB5DB864103D48FF5C13983A8B9367B5E950E9407FC423772A6EB1E1B6092B0639D7B773B224040733DCB6975C0F75A9CF471273A2041262C2EF0774EFEB94BA33EBCF1FAB52A9B94ECA53D051DBA506C74D6D016FE9041284BE4FEDCF538C948B9C0E06818483095B78181835C6CF0F0CCD420B060541892E7CD79CDB26039C0675465594485BAE0E4A6D3E0CAAF5EACEEFF47C574635CB559C860D5C17DB5C9606408B4CA4C8EED00CAC46003048447607DB0A93013374344C4E5C3D45E440949E292561761B9ED3814E74004DBE37ECEB96336A7F8C170B4BF274CBDF9FCB51814AFC9F37C73E931BE3C396E3A54307CB348DF40D469D487803F2F0EE15C16118BD54330C1A304E136D205F4B5210EA8D023BE4045B0EE08430A0CBE17EFCE078144F9E880B178F36B6E1991E01F0D7059015E4216A6078D31453568D0C7F58B2D310C8DD79829C18A00DF3BD1BA60E9082B4512F18BBBB2957267BE7840E741581C17005B3DD04EFC273034431140610BD91BA5B184F7F89E3EC74321FB58D56BC3B8B7A1897EBEC08DEDD8E1B395A142E85656A8B86B83E5782D73AB1020A6B5F05D096C5235856EF6FA8016E9480FCB2E5C6418B82D8ED4EA5730B0939AD980BB8BF5716E0B1A7BC051418B995B0309F018AF49F0FA193752F092EEBBAAF8DB09FDF17B8A80FB7014D98F488E08B574B3DC976BBD84F38FBA1D7ADE84B79F6097CB7AE5998D68F1517E1B0A417B4D714CD9F4DB79C362A1C2C7021D68678F83BEB29161370E8D8A397214CF0B0DA0CBC9457DE14E30BCE1A87D9975BAD579CFDF5A060891287A0604F0DF01604D283BF57003D8901B700B3DE446EC21CD4F06DBA9D46137C1406B83F5E977D8D3D5C717A7E10FA1A9A5DC3184FBA8D032F0D9C04DD811C790FF02B5CE118BF1F2B83720F8F8D802B538D193538BDBEAFD00A56030F68A7CB0B18FAC8F0C283632F849E4C04B95D1B14F1FCDFF9BE8C0D7F236C08815F585381EC5ADE0E8634F48DB585DCFD90EDAA6BDC97941EBEA6D05995D481AD16D8128D780CE2B0CAE0A946C77EF9D3E28B8D120456580B68F3FD5A0C32050AD54CD92973075B5A7B0C70FA949DE81D947B3BBC85B2AA8D862ACD4C1D0368DF16A9A6D8B870B71910E4DD4BB98FFDBD90B589898DE00D83D8B7458BF8C504955F8B10DCE183D88B3507BA8067674BEF24C5951CE6933E42B35FFDB1890F39D077C3BA0EDDF80E1195B664DBEB2440E04CDA83BDFB3DDB3AC66D416F398E3E77DA7F71F86F6D8B134E8F4183F90376F4B91802A76121FF1F0E1FAD366BDF8DDE03792DE49750E8A9BFADA28081C3A381CC26C75FC15929DA0F891F10EC70D261C786F05E81C47392761F1D31189F40C783E58DCFF712EAB39C01FA2000ED346C8EF858F0BC8D43208C8E8C89B3834FEAF1EC8D75C81B018CB4850AFC90EED96B49A22A039C0D0EC7CF35F70EEC8667EB0718BD275B9404CA400F6F2830BCE8CA54049314CB70D3D94F3CEE2FC37408441BA44541CA5514AC1F513055F34FFC5DD989B92D3159D70427040F18BDC61A1A03C7E49E238EC12349F019B0DF7B08C3600FF4108910F483C5E0D016D4FEECE00EB27B0BD701006D6C60750FD2A17940161C3C8B383C89D70A9D75571C0CDECACEC1902D6FF84DBC8223DC60C85C69365BEDDD88321C0F4B04A5942964B073AE3BFFE13F490DFC3E51008008EB55B0511BB07089D78B96F486743B02FC4163C48BF8227E861A6663F1F2464A1628158E580674F13DF9CFDF60EB0A1C15074FC045E876F5457B059669A4ACE845A89DEC06CF1309C1019E00505608C08E6DD02E1508AC3C184C787787527B8D55C41476271A14BC8984402BC49DA0135337C05960836B055732B659C09C3A86341CA1200CA1D51BA1189E12E85C4B876DD8740896D420C0BEBF57720E6D573E9CFF8E31FF3D7B2DD7B0280179A389BD305CB7EA2236845A0B7FCC7C07DA5F8215786DDB499CDF0D9806719C08949C4F6C23BC72986A45C0F44BE12E76A0BAE724A0010F8673B1F614ED84095B0721081463DB61AA0C0F986CBE763BD2F66DC90E94E258FFBD40FF98444BDDCDB08885AB0590E78EFE5803F8E6DA29F1128D7AFF3A42FF5418ABDC91820426DC69E0F67EB4639E613995397BEF08D076A399AC879F766F1CBCDCFE5FA221907C93FC763F8B4493F0403BBF75354BD02059CFEBA83B146FEB6F17F476218D42FEAF02D52BF18DADC530836D4D9C760BAF352845F7658339C874D45002FDE2D4FE3BA7FF7F0F97C285D07411B903D72EDB120F74945A8BD067D2EFCEF50F831A6A0C83C0020E93C2F5ECEDE6DA81A0313EC085D085FB011E66920119037FDCD9FE42063FD40F96C08AA0DE85087F96C209D0A801730ED3098686A5183BFBA48B1C63ACCB1AB66F972521C72CA401750A05C035F12D0A1286F8C25458688B1926E333AF3F8CDA25D9721A2B030F4689D9B0479A312ED6D865BB645645A8C0A603292CC9810C00441E3D723B5AE0DC01F26BF36CEFC2F8980F95AF0C1451058C192FE3F8A0E0F290573AECED8BE429D0"
	$sFileBin &= "890A01688317E2F1C1425EBEBD001A83C4A1ED81BEEB7FC4D7827A42BA8D910F0CBE06A474638B2E015F6A165DC54DB029D82A84066E54821BAE052C1136C77346EBB2F9DDB2C8BC72C0BC4D0899033719D9DC5D0B1396D4050BB8BCFF0DA0BB05002065D2CD39DA770E0F82B6FC86335B07D2C807AE62313296A9858DA87F4011ADB5ED227B1DD67A980DC1EFDCD7AD94D6C04A0E8C0B18204C8B8EA312AE47394117FAB254B91D55849B28031C490B50EA739C501C1F6CC02CC46847D029CF6CFE7D81E0F88246550F9590914B68968696930119398686BEB42108957C8D7583EA11A1B3B02A14B7959AD04A75D50A838DF82F0845289FB8694402AB9C06E61B697BB1B39681171C10A4C532F06A6D07860A35EBB44C4610D50410FB2E165CB1D7445B38C02D0B152016FFED00295898DDB6D71A0D46B5048F101B66AD16AE748D1E3D14A143A5C30EDE455FD562DFE00D86919191CD950B3C4038BCB1709D3CBF1A891474F1483F3A212B3D8686EDFA38D20C261426B8AABA108E6F66435F1D67E347013843B0DBCE35D571FB1390DE4FA039097356686FB6201B42027517FF0D3113DF5003CA55B5E2043A38041AC77AD6DB74E9DB9039BDB1231B0839C7C746CB6D0A284879187D0A28E4C3E11F3A9B8E5874277C03523CA0D2250F9C9214427AE3D6AC1C21BD99FFD2843605FF5C4C0BB38021FA0255E55B92E91A74CD49039670259C107D9E83D8B11FF8A10E46968C2A0D22FDAFBEF5FFC0B92E29C1C1E91FF7D983E1C4C106D3E8F16D45365784B44828E002274E2C54BC694E450EBD5ABB111EBA071BF16052AB9D3E07111E0783D3DCC797048EC48D7C15E70D1C84CAB88B9EF2DC60A97C8C80BDDE00808386821C803BFFC12DD52D31B87837483B74E44212C2E90F5F84BE4BBC466F9517ED05A4BD70B7068DD89E5D08855433FFA235EC15FF385D7225734CBDC8476DEF8D064FEDC68BBD519530DEAEF1F63E5C1539C30FF7AD3B85A1C36F43380642955C4186264FD5BD0BB15CFAD88B83560960E2FDBBA083BD2B01888D5B264B0ABC25762338C14A5A0E6848EC76D011567416E47711B4193C1C285B454B2D360BAEAD92AC763F4821C30F7E3FDA13A0279D74999E944DBDDA041B70BE0588D98C66DB019F7841FFB9B229D922A83D186EADD3E8ED0C520259F81FB8E04FE7D0C1E109E86001DC9AEC82D9B4FF062A15043B528DF795B2E62A85A457BDEF76813BC8E8203C8D3C03BBAB1F5E8783519EE8BDE53FBECCE616720FC5D865BED40A6B609710B368048455E442BCD8684305275E2C85B37D068C01CA878D6711BA9FBB642B388D5A84FD166F959DFC6EFB182D8B5495C821700939CA7306898DC80D5EE17905B887B10C1C38BCA25A900F0C3546048DCF838260D25D21F6DD83E70F28C001633DA9CD9675070B09690D04F386BFC9EE18BB44235CE8198C0B216E74B155CFEC61F84AA8FC7C10735B4A046F194E9CD2E5308A57E30433A3908412F278AC2596274A14E1F9E5BF5DB88D5B0DE52991B60740BF2B60C0F5780C00F288185FE295F21452DB0901DA833B1B83E7C606AAB8FE05089D401DE0EF341A517FFFB8A418B985474C98B41C7FF536E277950C01FF798D095F6B850B5721FA975EAF4F8D6171B2505AD8DB37C50A75636931D8564C2021754679B23AB3C04947048B9D8343B5412E3D10657BFCCF3BF5732A5DE04907B0B93842B61B431A98BDF61415873116BA0BFCD14C5F1374E589A01812395C8D74919A4BE8833989C06526BB214348755C2324F2D9FA06069910E6C6B8ABF13B0DF249258512A5B2756AD81780A3F80AAE49FDC176563B4D872CF6DE187D8C3B39FB0F9237FD7533048D17FB4239D1BC6C0786517BB487E9A6F26747EA6B8CCB970E0D0239D82A0D586D22C6C20C5AAB9D54908E888B37ECFD5A52AF8C0991D34588833CA94997946613D9DB39783C478B99C9285226ED1656A6BF9C19295A63FBE52823B0F28D531EDFB991C38A159114BEACD70791BDF4B6CF1F2DDBE3B744272016C5F80F0D1C9A74D5BA49D944484D87C282FCBE511C4A1D076211082C69D7051A385B57E4AC89C3CCC608B8BC0A96EF307048C19285785B9F1E58FA0DC704404BD63055F19ECB05068B6A2807B370A1BEFAC8DC01F03A9031D8CD3DE326A37D115EED06ABC598A182339A46E12D0974BDC2C801D1F40B85CD966860760397C59D2CBC6A7BBA4703951A4CDF023F7EA1BD5C8E1FEBDF850F02BD7EEC6BF3108B0C391C8272E87FB79A9DEE25148DACED8F04E7DB5E73A8185D6348188DC8C06E7BBABFD8850C301BADF9606B7804694433037787F72CCDD67BFEF5487FAB950C6C36B0F0C1E7072C17504C1D8D44F08162273C8B38B98D88B658E1FB4339B80576B60789487536B381AB41180608E16E36FBC9411CBECAC4740643B08E950EB02C6C502E1C75EC88BDC72877859CFE290580C8021193A36C1864C9D0CB6F5EB4397223D19D632F3C4B881BA94B1616A084E76C9C60DF57173A4B5953181761DE4366FB36C10C4A09970F0B102940613BB1F4837B14031006114F38931522D41D3F101F3C762EFDF56CF6128B059E3CBD8A4839D06C7E939A1BD662BE027B0C80D9D95AA90AB334CE96ECBDCA344D7752B8C55A946270A470690EBCD162FCB68F20F4EDE0D8771B5FFE6F06DF18971C894495D84276F383FAEA225DAB039D11200D761E9A22D685B5F61C31435996AD35073E0520DC24BF5E9665E028E42C8B1B1A9D2C1F8B3378252CBE2F4D848D50ACD7360D691421F9B50735A0858BEF1B29D09F96A4F79A9FD58D34"
	$sFileBin &= "FF1AD6741DC13286C4ACEE40B6D89E6601D33984782860F0E2417776792E62C48373EB6C2E8C70175F01C1832006D2960132566C2C511B6A3644CEC313321A01852897BDA7C77E16F77F3C308B143987CCE78E19B1BF9F057628890D596AB5C6B3455B43891C09D99BACE18CFB1CD68BE8DC2C6561B60A2C8FE78B91B6D2D35138722491614BD93956241E2052ECC8581C8D1B911A940C8F1462F498FF8EBB677661160AC431409485409DE14E4640E6A38040295293363E2D466F5BAFB320356906B8641AED94D446790F6D0C48025A7290810FFD33DF96E954680EF2E244D893789B63E3E0A91C966C649CF07B934E0A04060C232E2D7428158295816E973376860E30E11B2F77D9C0344B484DB32D090A26D8D3D84A77E9884B86ACC560E07CC41BC4C6528BFE578039C7642C19784D3516801268847787AC4894C038954F950E2CC4864D85D0440B8636F1DFF63024142A7DD84129F8083B8D072956F850762A07697322A2FB676C3600F2384701751442120F94EA07EB221A13043A74EC4A9E2A94966D903DB12FADA4EDAE7738BA094121D9BD100D3219318E8BF80BBCB273C676FB57102A7E1EC7469B102B240254D0468D31F85C100139BA73D39BE0A17623DC7F890852E71CA3C2E9C83704BAC0301DC5B319C52F72E9B08B0F750362945231D231F0748D352E16AC295B0CFD5B1681C809CC90D2E68F8F7DEF2B0C53868911C7421C0079A0B2049D8D9901BDAA5493AC40957404DAA99B2D57AF853035E4E948A7850C47852786757B4213FCFEFC4EAC251B99843880EF7188153B8D3B8F86164C6D3D748D82DACA18007D1706017E07EA6305AB0C682DF02225050BC4E8318363D02F1476521CE707852041399C45B482137143650A73219951E258474F9D5CE78D526F5BD802DE6E7C93F8722BB4E6803CE17D0E3E890C82AB119DDC624E068F41748255F917952458BD1610D3131F91690C16185AE4D66CC9628988F0FA3B28418D42C248CE9549D2E1B516CF2F77E9E0597F036BF1636FE04DB4393BEB1D902B10CDB138EC02E93031E0FE0C6CAC592CE22D278B39600EF9D84F8B5C9F04DC5612182A8C7DA1F0D832BC33B2C2D876B688DD9CB888EB7A8B375F07186B67712AD177E3F871CA1859EAAC406176221E275E9B57293DB1566A34982C2D5A9F7083507A8D913D8F99852CF0CABF98CC3C9374750AA4346887AF85738D63791B3A55B0EA1B72FF040D9E4D17E447DCFE867EC1B63A7B74CB0689188633D0EAC09C9611911BC98FA6C26625D8010C9E071F082CAB54434D9C62D65481A648D4A378F15A8D28761F910BAD6F59ECC250ADDA685850DB8EC562370FC373594BD4F675AB271163443AC2443B7B0706B076420FFF4F3716597826D021BAD4198B2C5B6F05A4149DC6D16C6B7674CB14E8488DF408C3D86B775B18F63B5DB44AF0F9B831A1F6B35C7C9FC18271E1B94EDB17A3FE238C11C6AD4929F907040283C0C317670996068CD5AD487485CC64841B8B352C842105C8AF129D0B91CBB2852AE2DA945667C0C8A5EA1D9C96D9AE8D82859387C4188D14888E615DECC6B6C01521C833E01B8EDFB1E05C39AB2B8D1BD3FB7EF86D8F07886D34A85CE009BA8109AE913290B60C1F9E0517AFEB2F5AC8BD593B76F66BBC21A801C7D0AAA4664160D7D040DAC99444FF8CCF94819434F123F94ECE130287E7ACD7B6CE2B93F469A48B4305086690EF83422C046215C9A10EBC09BC92CF6BCA40040ACC50D0DBBC401688D5CF38F8FD92C06C08C98DCF904A6F9078016B7308F534D240D901108C425D9E6003A73695694790FA3CE4095C38697D14FF96D1389F473B7DBEDFE0F41285B0401F74E5E5B2CD6AF5D6F2F9FD80A77B011BFB130684C1C61366290877DBA408167BCC924CFE7CFE0A6CF508CC0C9EF1206AD6DC8A9F04FF09E2AC17635B133938FC5A1620D620946A54172DD19DD6F726431FB1710C9D2D95CE5A9A4F3358A525EACDA01EA1967BDF36830B077506F805F86A8E142830569CC2F9BB9E4B2F587307CC95F8468375C2D93E082ABD0A1976D8BB341F29FF422A1B244BC3B2B1509D2A551939E9F5668D74556B8490F14A469F9E7DCCE8F8C88725B495803508C604A7AFF37DA5F43985B0F00D48C3849186C22C269CF2D4C8D98B2ABDD9EED03B102906FF1A1E4DA7D8D2C3ECFDB9C307E9D4226D17F0BD11E1C1644A3A5B1FE8C7E8690C1E31883509D581F4260DC9FEC7D3398BB59069B98EC13699A4BFAA4221CABEF470CD5656BC0854BD9034E121BC01DFF5E37081188426CFBE9D948E21238D36F8CC03CE70408692843972DB13F1DA530BF0BC959524BD5284E3C8DCCBD27B4B4E10F78AAFD1844E115A02CAA5D0A78FB4CB5A10897AC833791A10A3876641FCFD6526956403481C7D01AE7E84FC394318730B0D904B7AD8D656F36A3472386F0718798C8B95D06BA0822CF36287D1330B2F439A4C200601614B020842BB07A76C30363F01ACBE271C607E2741F77E8657EE9B504389061188D7B1E032F7FA89FA11645B067182AA9864309B215A07B346501280C749538C9AD9EF8511FE5A241E0311396C7610334F96630731D2B4B8B80DDD19F166A44B83E90428C8C12B598D71E4F68B9514957295C4805FC06ADCD93D562996B5C6A547CCC17830CD31AA407B8AEC8CA3DCDB59818C0C0F83F71582C60C1B056345701A55D6B53D6DDCECDE88438C111009C59775D48C8FDC3B8238EC49386120442DDA235D76D4908CB0E1E886CC30BFA7E0EE64E8F0BED4DD3181A698A44A9F8D55C053948A5946AF75012BCC809161D4A1"
	$sFileBin &= "6291ADB4AE3C34A2AAFF0B189E763C24EBBD894DC06710805640452D901DA080148FCF40ADE254A620F55126E285E46843D10CC15D54F18D86021CB9887607EC2C89D92E34EE584842BFE811CF0F66C7B59FDF93EE0004098C2776E3B8048A009D00F1BAF69BF96C2C45B80C8C5E440794EE4CE5CE5E5C1C0B750B7697DA946BB3C535478A86986EB1E0FF74C1D3E239D37311C36604581D8076DB46431072F5202C0B2C9DC3B866174240A03F09E1BEDB76F44AEA80C3E6DADF80477EB37B6B0C2B7176ED16AB9E1DBAE1117C380A5A39992C2AF00F625590EADD989C252C29541829222750C2792002DF5C04A689D1498928872814598C98CDA4401308D05B5E4F1802BA8227475DF4428F5FC4837F93C9745A8B87DA908DD5C61B81B71E8F7C574858C4630BE9BC6887147412F7DEA760FC132C2413C70A2EB88238DAD3E37AB38AD64335BC23E8B343357809068CEB968751BCACDF31C9612C896037417F9000BD83E50274835C26AC1A77091F5DD0B7D339C277F25510040953F0201C46D1AB2B7805871742D2AE2B5E812C08CF43790A36008DEC0137F85B406B41496F571CB00B2605466385D2DDCE3A585F7405C24E1EBE9883078FF6F8CA2616BA84100DA8C50D2FFE7E6F38932D0C39BEA051849B5D4D08BB61A870A25013CC832D22025E0EE3E07BED411C450821A145113D1B65194D0C599685BD2E80CFC9537464482D010F08D24444C86ABC820BAA89D09E22EE0D7B85901C541FC61488BD151174D9051C951CB663377141BB899D8B56CA8E50880DB011B8F9340F97FFD04498651981483B45F072772A042C10817FEBEAA0FB895F8D5E205E10B9149E0972B3F30D2AD591DB4DAA8A978F7C7249227E6DC763035E185A337EB8DC968CBC65DB3F4C2173E609DB40CC8BE8A39EECCDCBBBB90DD41329C8FC5C75817E55F620269EB281906D78E56D9CFB7FDEFE841A06B4E1824C01432C2FBA204323BF2E2F88ADB5E6203F0E2B11059B905D9714085D9F415CB934B56F837203F011102B5522446C36B3350C0F14C390689388937F451482BB15E90BDAEE1C8B105778FF280CA0C143EC8D833B2341AFAB72837AD0754DA04AA70C1E7EC7F80D24EA81EFAC501C162D6283E603766E8803C7DA205AA7912C06D00238B24F109C8058BC059A09C74611CA109D2DA1562DB905B0ACC9A189D8067659444DB66F24C2B5AD234820EDB834815A368F4E357E4D12D893755929925B729715BF2CFD9DD8301CA88560444A141C446FEB1AAFE90214E447DDA1EA68FD00876607F47C5AA222A787B6756E2A5A311C3D2A46797BF0F8C99F3001564D1C8DF1B59845D27C1B01B534D69BFF8C4F1D69C26D8677AFB9302B29D88901DAAEE00132F4AC270BE4B8F154C71B46A902437A6DA045E573EDEB88BF8DC181F881D1D0437595140F888428E82F7703ADD9E00F7EF3E37765C71E0ECA5E868F451C903B20C3893FCE2581C4A559157B506E671551BCB314AB5CB5F8EE50DA31755F9E0A9E5585FF74D66105012BD1CE2CA2695A200C10F13F8A500CCA7FFF17EC211577808ABB0A19446C8DCD4848D440EF0381E151CE02F0F1EB8DE2085647538B9A3283390F7C542F5168C701FF82E28BE00D8DD4B298C1806604C00282013D7C7A1ABE83BA0B2807101B069EAF88D1AB9032D16E62ECA50A27B11E7EE5FD47DFC0F9E60CD5D0E8884417019BD86042E17EEB8396ACDBA3F038A9EF3070524A703696F475104F61E870B271EB7C118B065BF4F0666DA7EA85C3082825BECA572A9D0610D10C416A5F93893D8D4315D104B05043C2BF06A24CC8D22906F43099463AA4BF38D72CEC20D8CE30F83C1C81C68AE70C4F57742A65AC5503F055BC5E0B260AB4E76401CD3008FCC57DB191545F3AA10892E6F3ECC24146DC75BE1CA49B6C6F20D9D618DD14839C6CE710420C084749AA76B56C403348361FAA2E44971040488F483D0675A3EE8777788B3A4B245F1B61F8873F43388B73145422C8B6D6C1F639D0726310308E17065B7B5503BAD0F83229F834D5BA9BA1343B18EB031329377794A35A47787E48EB20FDB6B51955DA42C82C3B4DEC73054BD4D8A00B69F82C848888DA97E804314169FF75E089719FAC0B41707CEB993F688B702406AA89788730EC94201CB80DDF523078216DFBA05E92855E0A7B29185191B5A5D8B6597DDA8E76E3161CD916DABB915DB4301C9FB836F00AED585788B08B4934F1BB6E893AD0A880044D1BF6DB76AF3C9724494017D83640441AA120D4F5D48B4AAFD0554F36B46CDD194917CC044C8B0ADB5608D81CC86E3D2813C4772B7000A0D07DAC4F49AAEDC25996791C80A8CFC476CBB575348FED21F30AE4B726477D5F818B374639A40FDB856FFFB7107714C165A8083CACC1E7081A014152AC54FB26E00945A8E40B0FAFC2390AED553DB1FEE904C7424C5BD52B144A4946D095BA7DF481C66C0E22035F900B8A6D6BADBDEFA474414292249E5574DEDAB6F675C021DABC59B80FBC518D44330C259A5B070D089183CD54DB098F19C4998C42BF4D82028992837DE0060FD7F68D858BBDFDBB75EBD38388B5C6C7AC7875BD00A5EA5B72044A01C910856AB675585C68A4D3D1B2ED64B04ECE7506E475CEEDD7DD1E72B4290429C734894F29C24C047AD66E358D4C7A4E76B11F7189AE0D6CBDC0721A426D6BBBEE6B0C555BE0FFEC49B85E015A087629A1604439BBE219D55A1508178586D30261E603925DE5C0B0BDB9059A897B1C51B0141C85F6044373181447FCAD5158004953E8120B354C868E34F3395C1A18BC6DDBB2202CD01A3C0E"
	$sFileBin &= "400B44720348558372FED872D443F5E348BC407224C37F7AB606779A7A183BF90B7E4297A5705167D2A52E3D122DB17510A90A4BF0A74822046BE90B0468F51DA1150C111AE61D5A5C1668C030E690E02F56964A701765918031687784606CEEFE0458C90C3BBF029ADE1648813FA705D6D1863D3160DE8E115619503900CA05111786F1B259E3041CCB1304657A006C63022B7966636123BA1F8242B049367ED35101CBB0395DB0734F42B09241AE9271B1B073AF5DE0713D3601294E1E0471331B5BDE98CCB03386D38AC1B747C40CF80376058653CD5AE4E4CB711DB2A1746299600D5A5A6203037330015C1BD3D239C281BEF95B620311B003205D70E082064DC307C114E2A7047301F695C9CFA604195D4A0343895D9B90964CA7AF724A1900B9AC5D9573401420AF00D90561E329E4720583EE40F303EF04D0E263A899F27A56F9ADA2148CCE0283FA0DD468C73AC6DAB89401F8E4D31D03DCADB5813644055E17627F807DD30BEB1DD16594AA5A01DB497493B10F8451D9587713AD4591C03244B3EA06D4E182A43AA75833CCB7BEFB8D5C1B016509D64975AF69D48D5E01960C38D8F4DC73C913D4725B9BD8F6D8F25DDCC9119A8B3B5ED94FB408CD1319C0D7C9540962FD6740DAD5ADBE71B002A4B83975E8F5F204F0128D582BF81239C3766E57CB5599CED729C1070DBE09032B7D45BC01C1018B2DA8356DF2191E3B0D3075B7AD18AAFBCE7EC0019FB82CABAD2D0B1A2133C67FE212F0466F1688022975F5B675CDED3F52AC247258DC6689E2652A07B75F73065C5B54838EB0C9B95746140D42F817D1E59C2A55A0EB244C6D02FF61C9AB03F7D621759CEF85DBB6D0A219690DA0479C5C9CF82D362CA06E21DE2601C88D1C424C254C5865136E6A99B0DB83814E6613EB14DD22B295F7913E0B558332BD521EFCEF16EE2A299862F53E2C5B024DBCBECC0EF04E430517CBC1315511456E954DBA5858E0BB57168ADBAE013D29D654C1EEF1168632D2196054E0B86A74948706DFC05D25C0A1A1A34C0FE800DD88CB47DB6162410B1707890D1AC7B230CBFE0B7F1331094709320025129FE2252263F7C34BA68DE0615C724D11E05102212307C00CAB0008456CAE1C8CC8554286C140D8554D2690D70148071183D5B05264CAE07372CDB0407938DCCC750275D80E0BFD64577E30E8680AED4CCE608F4F37B210D0BBA7F9E83355B7F081C1D5A92B6402D9FD15582CB4499FB0A66402E4C83BC8D839DA46D48AD86F655397617D66C8ABE017A043E95D916E3B912555D0EBBFBAE2C6269703A611410D1646801C2DD5446ABCF8D8B841D03DDBC14BE7FA453A94B96E2475BADBB23B7165AC70541B4E6D6C23E3154F99411B71850C64874E370378272E794EB8BEB01DAD0A7C919A1C221001889421D782EF3635A432217D0CC648FB6690CA55FA87426BBE2990D1EF297DA8ABB7B619F7541FF6697001218DDE82055A0D83CB15C1E60421070B0E12FE44F30E0029F7398993460FA12F96031953E4B90E49383708EA83431530023900724BE300ECC0C0D47682484A2D01D8A9737D4691524B8C909372FF711AA306E635F98FCA6D820362357159CFE30E6109735D8704E64BE4C076079F2256C61E02D3E432A67F05B9CBC877163628015390413403EC921C081A570F90317BEA694148F643F0430A890F1819CF6F3430B14075506D70A2207540894D004B081079436D22684B74531B8259B050DC0057D53C4B2C3982C6AE418821CA088D3C74061C40658B9A4B0C388142B42BAB7BEC6118695939F028EAF05A41B0CFA06500F009C78678361EA14662C139C74410C6804BD002E76C81C22D157061DA04FEC2A7DE0C8A1FBF4B04637DC00560037F0BBF43249E60096E9C4DC49903BD14B441800D1848DA2B17B8E50702D8DC837DE46B4BD0D4E1533EEB109F82C60A168E4405775424DC9A87FD9DF1C553771EBEE5045D5FE61E491CBFB872BB8D6785168554F7348648767B0B4BA8B79F0AE06C5717CA213C770F19556D731244A31A048A22C10E2A607F95C43404D34B425F565160840FF07357FB8C58804663013D3758E12E32D85CC62FD860653A7902E3DCDCC84E080F0B7721A1738ADE70C8C836598FCCDCE1B0DD115B5C020412D0674C051E260CCF4F3B970F63B0C3734243F51D089B039003612548C2C68781DD4172BEEBF0CC88C2109586B9034F5E896A941EE8AD48BDDA443527958410BB6D6BEDCCE0870D7E82253F234A5E209C40D113033B84DF1BBA848CEBB4295D3AA695B9665D5C4E3A58369423C2598AAF996B90FDA201712C5D587589D63E4B374B39C205404B28D2C056D1688DA516AA66569A70D0182208C7BDA5DE363A189008D4C1F7D2210F6A0CCEE8817DD41FB9C0D8049B30517E2B3121DA09933D2AC8D5D9486195E022793902A0C3E5D8C4EBDB6177EB9725E198CD885966523CBC91FDE266957725FF8C160F4C642DC4F965729835D78E2A4DE826EC55DD908CECB950E05C070F3DA0216B462839EE3A3C3CD76A12A1625C3CEF61AFE9CF5BDCB2594B02A88B0C33613AB3D6A21CC8C8A901089C4C1E48CF765A07795B75D919B05FF37676ED8229B21793BDEBE943A293CE41C6991F7779E3D08C9AC40CB9B6DA420E19DFFBB588D3FB47D8901D5D0075A9295CEFC2F782440CED8601EB87372A4C5F588283EA407101A600D70F42E18A8ED1D248588E3A88D9745094DED683C80270A0E8499A010B68414B8D60980D9D0B83FDFAB141C6603D5077197A8BAD381B4DD2C186BBAFCCA8E12C45F734D0FEC39266DBC1AD5A0E96FB5DE5"
	$sFileBin &= "A164AFE02D135D057B57A0DD5ED1EED2621F4821F0418B37B750FAC9B940639000FB24824FC36D4D5E24EFEDFD48B52F85C9C7404CD4068C88CFC84800587415AA55AAB32524505D2C82605B46070D8F8782070425742605B8082259BB3002BE289154B289E251705EECB6CF562253255FFD609C81E0B9F15FE23C8A1B1A2976759D1C817E5588CE66492001A03A824F7C7690CB484CD99C2BE256C696F00A6702912D24E0725058773C0FF1835017F675E5108844165C1405F702F08946587D5AC0E7D94A103B9F5676D3FBF76E2F59807A5C6B855A14840883C65C3C5E60E97656010346024F18A01009C2B04164EB0B030808344191118E45E6414C4441BB5FB46A1A7A7531F6D739507A1325FA24722C89C19BD60B8B7920667BAC236241601885F60A26BBD3354155DDEBBE758B595A823680508C5BA6106B100F14A0DC49ED9D6854F786970536070E4AA7882DE0D08C4F9F516EEE02252E9072F5378644014E4ECE4640063C383477B02ACEA25052425877CAF048C08A467DF0132B091C408DAF11FD36E806501409DA5AECAA0FB1DA21599E478956FBFD286705D4E3495C3F2E01B209E0823B7D20CF4118677033DC62069D1029CE63817A869F638BC32544CC25412005957B17800950C7069440E2102A4E16F6316C5BA18DFD13BB87C0933BB00434A0DFB72A9C0158C04BE10346872F340537EF43473688D383FB13DC26EA7DB1C0297A75E0C9C1B9CAC5136B7F5D8C84EB00BE59588D715C886116073BDB462F71C534C3756EB98D6A1F5570B9F703C452DBEE36A37FA412013E01D4295A1AADC7F769976158C3512D34AD3AB4D7CEFD04C8A0EC8FA8A37E1E83909CF2E05BB72DD557CCA56ACD0283857B748B90B9B584702B0202F7F1C35C430DFDCA6C317C857A9042D8756CFC5424968CDD7889A1EB8A6C02AE7DB3114504990D14B009373828DC623B4D272A83C05CDE90280CAFFDBCB6B5179E761C01580130458E033D7BA6574A6F966D6046000329E2750F6D816233FF38180D12839B196A0255C90B2E0A9F11B163D85FD089D34772D4DD178539F87206688D1C3EFECE51A5ADCB8DAAD70A8E6010B80C83612267EA0815525F6C946060A3B58D36011E843EEC26E06F0FB7AD582429F301D6FEB8DFE9DC29DF36320CCF015D4B084A9B7676E80149753F32ED53406BEEFF04977525298DB7B17A430624492839D6867CA559A75DAB9F9CB64CC3260B2805B0E80A8B602001AF0A930057EF5D773D736350B4D2FF52F90C4014A65AD8815B0F2F8B432D39B0142B140F118C248AFFC40720217CD6641CF690001793D1EBA396776372816FB804990456925B9FE25753DD8692D942029A4ACBF7EA9E01C10C03AC080418BD89A5289D0FEC6F894E0CD0D8FEEE422E1A80FBE0775B6608D3F62CD48003B4063C01DE622B2AC088089688C8C0B6AD7DD70D1DD100C828C306E2062695E2063079012889C2FA25778374C0EA7663460888D0C05CB4759BA1D02873C10E04FE848623D8ECB986BA1FACD305B1AF18D9A91E4244F18B328C786D347101F1794B2BB0E548C37F2984053973547427897C111CA01D613B3C2478365617891C95023EA41F107402E5C89545D056D0DF28334270F28D5DE8443F1C49089ABE57AC790A3BD743221EA16D656C22E14C7454E3AE068AD934B76CCEA3EE05F40C33E8B1322414BF386F02BB8CA0D8681475B50612C5F4FF2AD064CEDF7976E27F637FC119B4270A5E28741989FA1B64BB66708F4C252B04201D29899191672BA1D8DCE011869D91E4F4614C201CA49334B8EB667E9F72EF7B7C81ECB862B914AF9F8886446772C23EAD0CC58B589989925BAC42F1D91306763501189CED04F0288DAC0F88219F8D01BF1CFD18891485A4A0E665DC104FB38876B23D08894DF621010FD645A0223C893E1D304940D720100C210896F58E059B8D853AF2BEE904B45569BB24833A03749625FBBAC49CCB02A38EBF33F73A5AD8898F8CBBD6EBCDC09DBBB090008B2DB70333C0B58DE24D7F683CFF152310117B6427107CC31F8B4CFD89C8D09A8CD4055AFD8BB57651520301341A1C508901ECC93AD87B682C0DC35F6AFF5021275D617614C30F765F06508C2DBB7C2E8C04C38F13CCD63DD09A13F9068212446DC25F77183B07203C5EC3A99A860E2C6B09CF8FA9D84D446B149629C050519FC9205B371C1A049F02045BBEBB2D5E4C186A015119FC0C4DDB7D832DBF0091693408C32F37394A2E005CEFB6646C6C08518120EC4C2FC20A996C1F2425C5DC48481F0FEF590239CC73E8284F64ECBF770C1F33508B0251507900BFF796AD2FEFD3EF6A1CD9F91C20016A4CAF4BC0C647558BEC0E6816808FF4877704977064A1C15064892587EC085349140BF1565789651BFC7C141EB9B39F2C1096D58D7FB652332C0D5F5E5B8BE5D6C55E2C18A633220F8041B29425AFCF8D9841C74C5406C2D088250706DC3061108D316F5DB27FA338B429A60C5DB4AF8A30112B844DC13650F4FE29C83FA42985152CDB500802040CCFBAADE3B28F38D96089680659B6BF6E0D343F53043F0329D1093053DB680B5043FCD050FF169B8B7845F874395D11348463130AD7F819AF391FE6DAD66D6DF8D71E330C2E4215077E89AD1EC1083B434476B4CF8423D566D5E242EBF10F278813312F14A2EED5DA53406439827AD07BDBC92F374330720A408C16B19DEC6C034766EF4A30F23C29476F0B370A3D3B4244EE04E16BB397FF1F1BDC0D15C119DC0E392173065F5D002D017E306BACCF9E6C119E6DC7468606202C2023B70344B01B48044C1C817827"
	$sFileBin &= "5406CFDAB94049C04015FFFEFF02B076E2644AF7D281E22083B8ED31C24979EB96A58017339E6C43D300CE2F524227D51FEFE2203990202008B42F5C790374B8F6F084C06C915DED6D3C198B2C01E86780E61C908F1DBC8F1CC9D38186D0186337C452817F78F9D1E9128023C3036D0F2F98146F454194EDADF0C58D8C087A08DE5D68AD8838A38C01F21B53448D34C2AF231ABD4CD70D41733CC82DD68AF8488D7701B63FBDE04BC5915CF9026D74328D576C835CBD2B47B80206EEF7E5E40408D1EA81CA3781FA83E9EEFE96010B515328423D7607814904A149F3EC030B00010418A5D61C819E097C7BB12D50A97B8FFD603860B811B4A1B904735006020140ABD8BAD764AB02F5048E9A3A2755F1DCC1019AEA71F291C716F11EC1B73D8D0CB5B583E0BB01DDC8A639DA96008A205B28E696B8595B363B825314019A6B2493246F099BCA05D6C96DCDA6D90F3D8817773C741C5BE81D0C878622AF10016EAF237C89247FC6FE00B1EC97C5D06D6C31C95B82BBC2EF5FFA740723616E51BA37D929E6CF098E4CC212302E8C8AFF0C212816C045AD9904E8AD36E5BF4FF3F75BC239DA04DD78A9A7D38B790E414444B7412C4DF2CD0BE2094DB66123A102201D1C22DA96C00C8E10F91E78C29D61605E8B56E3667A48C5A31F014B60E132963A731AB120DFC730D4854854D14077F348D17698C62309681CF06B89CE38AD18394304DAB9229E30AC5A1ED76F8CC409D1C8EF1F100389762F855339F275731D2F4FB7CDFD049139D8770E9508421F72EF6E2979A870BFD80DEBF096FF18DA58DAD1D483786D7440466DBF5DCE2D465E042B394644742F0C183D723CB407145FF84F9F96D5599A8EFB14568F2650CC166172FE818EB5451BC2EBBCFF58588B5660F0B316167C647A4BE681E300FC5E562FD9F74620706CB46B8C25D483EC5070C02CEBB19F01682C22AF08E170D8000D5E3C8205A276D45F494E29F9828490DE535CEAAC4DE68387280C29DD5E60098FCB0F8D1487181476CC06BBD64118930C8B3A33248F5D468A4C2475B70E023803F70D76C675AD18135F452502221EB5B7FF06423B55F075EE393073898904536EB476A839073B0141FFA339FA8F26F083C204397310EE0B16D07361FF20C14F900986359F55450DE843D9724F808256FCE9B76DD18D58049EA08D98D07B0673247FE30D1AD375DFF3837DFD746E3B5D2073FB5670A66945CBBA0C1C8D3CC2D8EE9A6BB04D201B090757E429D91C758BD8A8E8E076034B77A65E2217B60C329BC73238C16DEBA8DB7465037349C775634F6CE5DCAEDC4DECE2077F04676DC8B9932DB80C6D759224D4B20D12CC07C728D114D6B5F7600F6131B27D02366CAAF6338B07B9FB726C2B0874C20BAD1D3A79883D0A74453785A5CAF62C73512E2C4B432CE0D6B9ED1683C67C06042889127449F175BB86405DA40C02351A44BFBFDD73CEBFB740474475BB5675EB9E6D10764A72B59F5D35751AC2042DF6233584C856DFD6D0A18F47620113FDAF513C2B064F4D101E4C90E35923AC7A506A51C150378A131B06638CBADC614F0629F1C78E8556C57E6A607365598E051CCB55C8546EC25741C3E1965DD809746E3BCE0E4B1B3B7BB619578845DADD9A80DB7A3806746C04733F0DB70005646B4FA64139C25D808D7D7604756A91A83DAC666975960F7BD03262C276377A02D7ED8043C05B75E8E416C7ED3D0E3BE473EE8FC66B787BA51CED751D4187AFDC49D837AC0BAA01AB02441B7691916D74E4A01C5D44743CB6A2A6846FC29640D6E2522BFDD304407AA33D8BD6E04204693E5770AC4B07F2153F387715FE61C027E80177168C74EC4E5775036A674F206427D78136031314C0D52A62D40CA9085B966E1BD9BF2420152C061C18C91F60691814CB4724895C49D107B83526F023BB7BD73D723CFF27C341FF0729C321C1FB02B74280966547470F704BE8E6DEA2C315EBE81F68854C60CF02A917BBB551025302CCD8CDA290DB6087D6CAE51000201376E7DF02141F1A63FF4C4B4610E6E0E34F40E80F86E5E83E0EC18BC834DB07C4578673103F0C71E1FF74CA4702D44D206A90C6EC310CF1776FFD56282104202B1C8A8B8C82B7B1B716B9B9A02DE4899C0F76BCDF05561C828B4E18BBF87176122E754B1CAB66C26638E7848E586A6A1EEF5C5D890C839A0F261A45F58AEFF21CC920CBC98B46467C4670885FB863135DE8E81176CBF3F5467D062229FBF5C846599646461DF44C72115AD4668BC5102D1F040B64BD70DA059468674F3B51D16F4DC3681C0F173BA9750743EBDC73BB421975F1FFCAC5AF4812DE26F7B4891A1008E30E774EBB6C72F2C5B0BE100CB7F740B8E846DF94E4B67158736673BC13B4AC0A5A16EC8B234BB29910CDD2B0045FBF7D4703B1B69A23F5011708E075282C978512C2415C97D813978D23947FC25DD8A551E208D8721B9731B7F2D7DC23A34FD32CDC584244AE89CED00557C2DB87CB57349AC675F0172BB49AC811B1ED21CF04448C06118ADBCB38A9225DE436500582DF8CB22531F63D0FA99ABA6239576BB581741BCF43ECA539C076168B9CFA015DE8A2184596D1BFA29DA0417725E72259784368A2037FCF820B4BFCE52EEE041E5CB0F862854E4EC67A212414100C0F001F742EE07447B55C1B0975251320432CB6601882EDE365786FE7607A84393629CA79AA07314696C835F0C4EC080DAF44480E09ADBE9A388C6F3C7929836E7705BB03CE4D8397C8EACBB1C1AABA1E3DAC57C8C475E4C067062CE7A4AAC775221903560990C71BD12717C66B95CFF8DC0907C50C7C"
	$sFileBin &= "9087E45AA9C46D4863B2046DC3DD12E0C3FAB04CFAF0EBB56FC8858C115F3CCB32944C059333170F915C9D7567FF931C87860E2A57D1E4AEDEC864343836971F39E99531AB857F3CC33D989047C9577B891C13198F1109B22FDA4D8E17932C4C552B35A3E102C9716CA43835C983900B3C7BAC0A89B32B8F7C132F6A16FA9696178B5F20E64800AEB5152C7BAC5485AF12EDC483317034F32EA38473C88B1C0E25B420B807050D9E096104B20807FFD283EDCC1C3BEB0AC64E74750ECBC1363101CC76EBC342010A086CE62261B3A3D8032CC7118975978B0CAA133C4E75900FDF63C860239F0E89AD3CDF6181B6A302E79C2797D050E002645CD957654B70BC67B3839223EC248090AF2CA29D01B9B1EC96949066E97E0252872C0C75B0530FAE0254795BBCAAE75794B26A8121912D27F081C9F5D100B96C4CC9ECCC362C1617CD0D5E04B285A40FDF2C3AB31C72D103E8C21138DA062498C2EE2822671B904F9B55F0CAEEECC39148129D9B21D8B42B532436F28386ED3A6BEF32B68C93F8550C932A1512E40A84581F05E8C09B900B3F380D6D8EB0203FFF0CEB7FB26C9B0A5FDF7728E81040BD9535CD4CC80FE7DF7021C9B6EBDAE220D50421F8101BBBE8B481E29406D59499D3916847E614811F3934906C129FBEDD17B44042B017D123FF724BC4A58A287F1027798DD81D66BD851575EA6116064D58E3D41FA45E99CBBF4C9FD252276D8F438915743BF2D56F60A60E3491CF918F0B98A77B8E8C1F1205B04047326088EED80DB04093BF45B850E5701A311600BE6B59059BADD9080880060C50757E506D2868077AE02F811097823E292F8B52482E741839566805A60421788023C79C19805F1275107D44478E95E00F76C07F30411503827F5FC9C9D9907B1006141881CEC9C91C2024DFA8C8570B5E10FB150DEAD96E4B495E1809EA9C6C6F0422060C08F2CDE24FBF69AC8D461CF80A1459BECD0D8C1D383015CC24C5D99E3D6A7C3397545A2CE622552F8D8D65F89F2D1D62EED70E5AFF781946202669010CC0CE3D6C48501D80907F9616006E27E07EDC5E489D74E5B6AAA5F4041D6DCF7425800F13562CA35D20C161CB0C7E6BD5CCB0A27EBB5D433B9174298D7E24EF9E2D3B1B3C898B332875E52A21C5D957040FD9649BB0FF46EC04E32DB04DBCC19A841DBFB614DBCE353E46108214B854094DB667DD28067D8269DC4D18C9205CF20A1C20388C482B6B718CC48C557136778AC786BC08604F168E0375349510689C0764B9ECD8BC7C7483C24E2821E9C106CF968CEBC2AFE06A5950BF71A22BC0CB9058F94E11C23F96B9A7930F4330BE0CFC217BD65D9C24178284AC2CBAC318E1C743286F437D7CBAD3409601D90E18C41C0EB03968B56F1220DEA2C569CE16EC9EF5A10DD876391C24188563D367B3C01472B823109D119427685C730308D98FE02672859BFF8480D88932466F180474B07C1C7585F875A3F1EB2EB489CF6280569789433BC641C72B9A8037F72B3C905138B475CD1140C70A7F4E930D56BC799775D0A3664F0CCDD1B33C4D5D40CA319EF80F9420BF0133148789DF8E4161BB131786EC43905C142161B0618D0CECBEFB5FDE480EE404485D6CEE1FC45826418B04874D680514D09682202B52EBDA12DD570783C74089091E4367B294141CB6588FCF6CD902B94971D8316400E410B58F5F35240F3C95080552C4224CC481C257AF6EC63A13A2164010DC83C25C0931762B75055810E45F10CCEA80B71436AF5E41C0A00C36C283805BC17A08B4858D3CDB3DA8E50C85D66FB078459AA321D19AB2598C86E8F547E239ECA4C548F4DC0D0A7E4CDDB013353AC37B11A029B0DE7705DD291A299A18516399C3C65A1742140DF0106C089E8C84734C65F402AE8020C8A5622AEE3A1B8E8C093DFFDF44CD229A70994E746B512D8F5EA4058AF814A96FFFF6E707C1E70F7701CFC707F7DFB6686B0C3248DB4F138D5B0181C06B00E0FBFE1FF5BB06135F6D2D2514386C138D728D18790869285C904713C251B46BBB019B1BDC068A1DFF9074011F586DA95CF4EE1EA3CDF70CDA746C65887C4F5E58B1E801B144299A588D076FD6BDA05C40505D92766E16BD60C9653E894316800F39108A424811C085A4EFB0238C595BBF93F06C40BE04285B830187871B9B8370C48B0A2ED085124B0BE00D7983FC425D24000A1A0300177AE5EF8993088D5002173881045246C36C1B04F47F40538029DF1D4060300238CAB786B5F619F1A9C301C0291F11B45534E23FC20539CB5EAB6A773E61AF7D67407432FC3D867C39BEBD6FA108ECAAA9964AC6D88BBE14D1A2D771D6964A93ABF8ADC0BB48FB8B8E1C014F4AC018F1770397895EDEE66E85221A73031F4E203F2C59EBA8F3D4161585B6A02F1AE6F9E4F7FF4E76F3DC6ED90018EB2090150E0102DC6BC39C684AA25D19A219B8DB7C0986280D34454D485E24F3016FFB07201124264ED4AAB3353E7C4C481708DCB3456CE1F947721055F0BD08B61F8B2B0C90B7406C0A42BCE26CD29FA2B2D55699EDC1BD01E0BA919A92862A13C240C361667ACCBC100F824A1AA22148803B3C8B9E30AB4F106DED843EF84946F03D8A98DBEEDC399D28E987ADCB44A02755AA964E8133B709205465FEEBAC05235C9C0A8164B64EBAA54AEB9E808A90BEC2E157C418B901F8F2FB555C88303B2872FBFD028F5A3063618B10575D9D1D888B4C41914A18D9B316DB9575DE772081D08C3F2F407504606F16BEEE377DF402470F3E3083E33FC1E31098A2D70ED201C3648A9C6AB1A29ADDB641BF87775E2B86A243C2492F"
	$sFileBin &= "580F59685991B747EBA89366C266861F5A00753D2161492989D36DC097553322D8029F292037A8083F2F8D63EA5B26487F7B408D5F2C17A66A3B3C474405288FE021874004B6ECEB2A81461385FAFC32881598C5522CEA46E1DD96ACD6AC17892908F7CF01EB8750E973488D8726E0B02D8BEC7E568F0F472B580F1F5116B19533FAAC5783C32C78822212AFAB1920E90ADF09C1BB8C9F833086205601227B80328A0987876F6F3BB4ACE7080CB74390A2DAA159674E1B08921D10F2EB943FAA428F3D8825881CC9172EA20D8C8F0E4143C133456B6F5F430E966478FE368DFC4BC01B087FC1188700EF5BAC7889A45720BA05CFA20D16782440026F3F0086D736846920D3566DD98A32366D20C603825CC48311460B442457E157FFF7050F0E7C6904C9E6706B3859577422ADBA078F30151C5E9D90BEBCC50061F86CFE857437B56C20279397441C8A3FD8007774D6A6E347398FB9F2DD7014A2A7BB40505C8DE0C5BE6450554F36008784046F2F1D8EC1E16190198BB3004E01C4C0172D3B24F192FA06088E6FFCECCE02B680792096402313502A0596E0138DC041D8B951EDD4458D89AC830E08195946961C0C481004D946B6671406101814081C0365641918202C67503029809E03DA63E12FC52C7EB3EF842209C40FE3F1501D5A7E28682039D3C1546BF081A74859C1E3A08A3FC42692F1ED793C43746696260A5A363F0EFBF44D14825C30817B10FEBF243ED110F70C345308316958C15BFC770A59661C839871A45B913CEF8F0E8260296F06125BA968587F405A6F31D8B35A4B917C159057865506BFBBB51B811CB9254932502F8DB65F7D308B5818C75024360E96DC101D9746048A8625388B0C83D0880D6E8E833BD872175DFD12B07BCA6E29DA380416EFF8132A352429EF3F17A92E531A904823232480993928254F6CCFB972148F89988948B354B76D11789140891E20561E550A5C9890234A80213EA9FC149925083D3B294C4388BC063C990EDCCDD5FB39FEBC720DAE50182AD3DB29F9AC0E7449AFF5F625CC5482B52455D1216A80CCFA37102102BA43105A2BF096EAAA6A6AC710022B0451E0005810F3FDCF41D797D01848C79B38440E0274199DDBDC8B3BFC693E086C4172A15850899003B899728D2CFA08EB84EF4A1A86165D518B57EF292A01B0F025F18B31FF4F6FC17B296A6F25320189173B178B010FCDED169A7F040309C3040C095E7829700771E5FF47C6F0FF07A126A400BF0C3F6D0168DB02574401132AB889566E4C44101147D6754F1B0FD58D398D42CD478E0F660DAB60414A84E46A84A17E8B1D1B45A22A1F94E2C6B7FD9873291D2A29C65BC1FE8FF031F2B987B9AE3453043734D0C24B081DC2CFB549FB172BB8064B0907EE0275E795102CEB74EBA29F5DA5B67DC9D733EB1BFF4B5C43498B5AA02EB4FFFB1B01CA114EA44B4B44649F3B5975E0027A81B537272F2A75D5C0215E412F175F58962D259F705D463791A569038856050F47579C0AC056105E08055D17C45B8D13FF4610D4062C8B7E03BAC53C82CB404BBC742F3B460C0AD4842E315658B4C85CF71658B6294C04342E7A76487175D18D34BEEBC427CD944DFF8F554657273D014D0B880AD1055641051C9310A502D98A469BAD21F2B68801B20C99AD0CC8612F25CF02982EAD0A12C95A9FCC95EE3855B3DCFE9080C71555D100B8069220FD5DA266FBD091F0060CE06B74342068D0AE0B98942097DB881DDCCE4954AB87B0C70508210CB0C07283250AA3B86C5D3FD0291495E0D00BB23BC49B2286901B591238F694E04C93D04F3965B625DF4028E0445064EC56F1FFFF88A050054C64646464480C0804766C2C7640CC000B3405380000005B5104031162A62007322403C80A00082403C8400B00ADB24032093FD334CD950B010203042FB0254D0506330203419EB3ED0405060207000A0040A0BB99FF056AF103F7540564290811A00A1905FEFF97675CA00152656C6561736553656D6170686F7265DBF67F5B4C0F7665437269746963616C1763076FEBA6E4B76E15456E746572443D742C00DAB62B47144C5474F66DBB3DF20D57611E460853696E672DDAB737F74F626A2514436C6F7548616E64126D6BDBE60C776146457664413D96EC8B95530A9C730B236E6E976CA727496E7675697AF634DBC880DE694866296BDBB6B95F336C6E630770274AB1FFE76C661E345F6578636570745F6888EEAEDDDC72332A606D6F711A6265672D673CD6BA6876642518637079B28F6FDBFFFF0757076DF09A17F03505F0F902F06901F0D402050B7204196DEDFFFF35F0B90261BBF00705D1F0D302ECF0B101C2181C193DFDFFFFB61F6228FE03F0B31C3522453982204733730528F08B170709FDF6DFDD011B070C05F0340D65F03F06070A0D0D090D070F4BFF63BF0210050D0D06000C06F00C0A040050453D4CCDFF43FE010300448DAF4BE0000E210B01050C0098081B699A27801110B0100B6E166C19020433070CC0CEDC92D01E341007CB66E9D906A0B3D66E8CB15040B21C24C0F01706B26EA7581E2EF9787436B0C176077C979098C40267DBF87220602E726424611B0E7317D27DFB06279C40022763939B636510B32A01FCA2CDED376527421B34B2103EC1B7000000700400240000FF00000000000000000000000000807C2408010F85B901000060BE009000108DBE0080FFFF57EB109090909090908A064688074701DB75078B1E83EEFC11DB72EDB80100000001DB75078B1E83EEFC11DB11C001DB73EF75098B1E83EEFC11DB73E431C983E803720DC1E0088A"
	$sFileBin &= "064683F0FF747489C501DB75078B1E83EEFC11DB11C901DB75078B1E83EEFC11DB11C975204101DB75078B1E83EEFC11DB11C901DB73EF75098B1E83EEFC11DB73E483C10281FD00F3FFFF83D1018D142F83FDFC760F8A02428807474975F7E963FFFFFF908B0283C204890783C70483E90477F101CFE94CFFFFFF5E89F7B9D40100008A07472CE83C0177F7803F0375F28B078A5F0466C1E808C1C01086C429F880EBE801F0890783C70588D8E2D98DBE00C000008B0709C0743C8B5F048D843000E0000001F35083C708FF963CE00000958A074708C074DC89F95748F2AE55FF9640E0000009C07407890383C304EBE16131C0C20C0083C7048D5EFC31C08A074709C074223CEF771101C38B0386C4C1C01086C401F08903EBE2240FC1E010668B0783C702EBE28BAE44E000008DBE00F0FFFFBB0010000050546A045357FFD58D87EF01000080207F8060287F585054505357FFD558618D4424806A0039C475FA83EC80E9272EFFFF00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005CF000003CF0000000000000000000000000000069F0000054F00000000000000000000000000000000000000000000074F0000082F0000092F00000A2F00000B0F0000000000000BEF00000000000004B45524E454C33322E444C4C006D73766372742E646C6C0000004C6F61644C69627261727941000047657450726F634164647265737300005669727475616C50726F7465637400005669727475616C416C6C6F6300005669727475616C46726565000000667265650000000000000000448DAF4B000000000EF10000010000000300000003000000F0F00000FCF0000008F10000E2100000411100006B10000017F100001FF100002EF100000000010002006C7A6D612E646C6C004C7A6D61446563004C7A6D6144656347657453697A65004C7A6D61456E6300000000E000000C0000009D3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 1, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 2, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Lzmadll ()

Func Tinyau3Filessearch1Png ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = "iVBORw0KGgoAAAANSUhEUgAAAfQAAAA8CAYAAAHnHXhxAAAACXBIWXMAAAsSAAALEgHS3X78AAAc2ElEQVR42u2dCZRVxZnHv9fd7ILS43rEoDAM4uAKuPSchJwIilFcQJ0ZAUeNAhNERVAZEYwR4y5qUGmiokbPZNIuHEGDoh6XYYlCRkWCJoOKoqNRQAEBm+5+0//73tddt17VrbrLW7pf/c7p0+/dd2/d2r76qr6q+iqVTqdJZODAgem1a9dSe2TWrFmpG264oeV7ihM/ePDgdF3dk8WOX0E45JCDU77E185/KN3U1ESVKe86NeHH7GeRCXQx1dKDkV9s+3zc9xjDH/+zlJf45kR6OYDEymIgk64lemkd0bABzfdPaP5/KNHSKZnP+I3h7/jPz+Hz7vuJJv0n0W2jifbskvlNDI/vBXWric4Z5A9P/Dz/daLxP8r9zYarr746VREmt/gFiCiDhIuJYwb9QP18VWVzLRtLdPMfWq/37Oq/r++MzH9OuJjpIpxwZvUGfwEEcdttt6W9xM+YMSNl94j/ZWKC5ZJfNSP42VtfEDKqt/++9Tf5M4GfFTP9w69a38nvHfwr21QQaniqRebFqp/90T6kNogv8WIGtHeQcC+9cgm35wzgRPsSjgR/+OFHxY5b3unT55DW6o5Ez6t90JNvtHw63R4X6OylNJE+pMGB93WkHXQa3UVP03V5SfzECRdTS8Jt9Tojt+i667KO//14v9pCS91nn9Z7+T1QZefOJ9o8Rx+fpuboVqRy329Di143lfDSK/yRZaY/rU60eF3MNDHRgBMtUj0lo8bkRIuJwmckmq9VT7FLcE7C0Y01JZ5f0ve61oSIulksWfG6HGkTnODhUsJVNQzXBt8UXDOUaVHp83LQ5S0l/uyzi1LZi8WOV94Tjf8pXUJRA7Zu3UodOnQodlwdEamrq6Pzzz/f138BOYW+5IWlvguNjY0t7V5FRajxnaOEePjhh+j3//W7XEn/5Y03p7lgs92bWC+6bp/pLZ9nf3WL8T7be3T3i+8TeXDLZPqi4UCr9+gY0GkNje7xhO9alHBs8ivpcH3vmHFN7gA9+9n7H0fHca9jy3dEPbv5fxP7qDCnyNaJIFR9Y/mdDHo4bCVh2xf/B7B+sCVEFT8Rtr+p4jHh8Yy5CaC/jf65Kd5yunVjAfTmXno/cjEoUbbXcSVcjLxY4NwdFc1ISHiYri3GD6b78Tv+Vn/Seo0Levjdrdc+/Nr/DGCbnjhO8d4rjQvENM5/Q0ivYFuEMVUXP7mii+GhYvI4ZGnI8YiJq6++Rm+NQjOvk/T23sstJrIxO/HwZRMkaM9WuHJGaYFU8c4779BRRx3lKkEbo1evXvTpp59qdbSy0Lt27ZreuXMn4c/RdunSpUvOGB0om/dymHMoJ3h+hb/ndOT+sOTFlu8NDQ0+g4wzzrRdThlxUq4ZlifYGL7OxdyU/R9mOIfJtPU0mF6iiUVJKN4PklqEk3R4Bc+P8T/zCq9KvPjVV5mBK8+spmOM10/o8hrRHkR9aVXz38VaK9NPui2hmq6vep9195y350PUp+Nfvc/Ld/xYe7/OIod0xbV2iWFz4SdpOSuENa6mpia9fPlyvUUu7lhcti6pVnqpEGeXGUzQ3jIKlRFxyw1Xfqe84sz0bvkajCOiEUcMC0YTzGPqwumzt9rKZ4LTKJP0mN03vcgkobdhsowCzKaqmXVYybwMSOXer0xYrb5Sqa5vvsv/XS5w371zMqZWMY28agBhqwp81+7s7wFyJFoH801OCbPOjmOKVZkOVcskvfeIyxo/8V/nzJRt3qr74yDPDejWwzCwrYtx0kkoP9M5OzudSvmvi/eJJtt8WuRATqFjKjUOOgkTl4farFfFPZyZw8MuC5lgzjhkMq+t5aWlkGBdXFRNuepz0DO2YeebxCdceKKAM15cMIXV2kFAgsRFWIxulkk1m+VLxwT9NSzYaplty65/0oUnL7yW4UJDpdFVnFJC2ZHLflcn0E225I1CTLbgv3HNd7ksgC8HynKtezkjmmErgn50tH0GDRpkXhhpw8knn5x+8cVWG/2FF15Io0ePpiOPPNKb2Sl1vvjiC9p///2L8m7MZ1RVVcUPqA2mPS7lmndI97vvvkv3338/LVy40LvWs2dPWrZseWrAADujmJWgz507lyZPnpyurKykzz7/vOAJdTgcevbfbz/vf1DPLFDQhwwZkl61ahWdccaZdN11M4udHofDEcCKFcvpsssm262VavkhO1ive/Jp5e/Y46l4xuqaIxnO3pSZmVjTbRx90PmsYkfHUSKMHXMe7dq10zxGh5B36NCRfnXzbb7rvIEbIdiIbzr7lw0zsYTsmdpE+1V+Sqd3eSTntzu23R06vJGdH6H+Hd5u+b6hoT/V7fz30OFM635FzjXEJ0r4qrCCEMOUn42SJ3G4uNts2qtCvTggat4Wmn+oepuO7LCCeld9UPD8S4JHH3mI1qx5V7/PoaKiIq0SfnGHU7HnXYKmnm0mqOS9j1jbofIEJa6Ykvcuqt55zclEN51JVJm1ayObKiYSTRpKNPe84PCD4hi0Qkzlzuuta1vvr28g6jQp83n9bPWiJMx8y940ZLBwycZzlfzs7ub3d5DsZ1jshLUvQavK5HK0WYHG+anawyqvtVGFx+/8Zk6zMhG2I97zMtHlJ5rjWIqEml+TtzEWU9Bt1pfoliuqwrh1SbOAjtCHhfU6tntGxU3RQXHRxcs2nfKST/E6Ght54Za4iToI3aZtBktb+hqcPenijbhhL++WHa33fY9GyGBEN+Wf793ZhjXoflN5433Yqyy66zPFr5Tp3bs3ffzxx3aOIktlnK0qwL4zwocjgkKfrjBD7Pg+W+iSkOMar/eSN56rVkZCc6jCh5eGqJUkqCLLccA7bIQcmDSmScjl/JHjjCXEXs8oO7IwCTnYqFj/z2vw5LLXVVNoetyPPJeF/KJHW8PzlmHvre5l6RZcLg03wio4GzZk1pBbCbrsd6YYgq+r3KrKWTvGvPhSBN1W2fNc107qe1ERJjyRKXTZC54K3KMKX15ubYIrWtAKX8RNRrfkPOg90HoqUAbIWx3Q2LiHPfXiT17gunSKvbY0YbtHgAW3+src3xYs939XNdYAPSUgN9pJpSXfWAk6W9iLIeyoqLKQszbUVSZUtAl+/08ty8rlsPhZ7lKKQPvIS+3RsOiWqKs0AVcEXfhJoqr4GJuaVm4zyMtV1wZ3bXX7SqDZRG+VnEcqm4BtTwYau5diV6KuLG2QFYAYFoZd3HjL93EDIHsALXV4jG69HLJYwo6KJWszuWVWGYmgXeQtFjJe90/ojspdcVR4bK/AfUF7a0Qty7vtGLHFV4UfB5XAoBGUQQOk61ID3tejy0vxfaL/LNU7goZS1VP8bvGDBB73csMVlP9ielVlLTdy3BtTbaUBvEVFVhQieM/wOXb7p4qJlXch06L3ID9jwouKnVaHoyy57LLLUvfcc0/L98CVcW6Hi8PR9pg4cWLqgQce8F2zWuuOxfSTJk1yQu9wlDCR17prH3Ka3uEoOjxHbnNvJEFnxowZS6+//lp648aNxU6zw9HuqampoWXLlkWygIcW9HXr3qfDDhvgcyw4f/58Oumkk6hbt5CTw0WgXPc0l0La41KueYd0v/fee3TJJZfQtm3bvGt33nlX6sor7Y/5CCXo3GXv16+ftxHe4XAUhx49etDu3bs9Ry87duwwankrQWcBf+3116l///7FTqPD4chSX19PPzjoIKM7MKOgs5BPnTqVJk26tNjpcjgcEmvWrKEzzjidVq9enTrmmGOU91jNo7/11mpyOBylzZAhg7Sa3bgyTjyoSQRLYlscUSiWwrpDnByOwiMewCWiNCMOHDjQE/LjTziBtm/fnvO7cyNVfI7ffgf1+j6z9erJv3s6ZmiO9sLMmdd7StrK3TNu/NfzxtLQoT/O+Y21ONDp7Kbc8BJP0N60gUbTjd7nxTSVPqM2sl8w"
	$sFileBin &= "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"
	$sFileBin &= "i/kMBY73V1/pvy8feeQ9V9taDlGR341O1CsfZD5zHWgK2Qn5bEtGcSJ+6BSGHUyIdU9XlnGafbQbLMOOaNTV1flqhdPCeQI9dlNjjMZqsEWvnhWPSaFXVYaPZ1iFvn0X0Yh7Mg0mRkBBc+QADQFMnn/6xP4dCBPmQZv7vHyxNF97965rHcnB7FdoVlvkg1gmPbsG38t1wlQOaMzR8eG09zWYstHYio21jbJDWVdPsUujLRh5h+2weSNwhYUgH3n03KXm+EBOkC+6cFVTQpDlPTplPnMdsF13w+y26OBj/luMm2jhEOuhqe1hIOscDj6bKJQVp1wInEMXt6qZqKys9ObJg8Irh3l0CN/mOcmHy/O9pnlc1byw6Rlxns1mHhwNAEbQpnDFOX3MA6KBwAI/NA6Y8w56DxpBxMnU4RDjHjb+YYk7hy6WTVBY4oIo0zvRaGJaJu4IURf2LTEWz0fNZx1h54AB5zk62PnIIxNiWcqYFn6y/NjUuyhyD4veaXOJXvizXVpMa3hU8TDFIan1FuWMOI+e2AidlXXQXvBS3ieeBFBa+VDmIrY95TCIChErcE3YjJ6B2IBiFD39mcxqYdtV+7bmVpEk458kYRbgcSNvM8ePvMyXomJrhk05qIAsDIuxPR7PshkdnTTUnbDWFVYoxVDmJkydHZNFgQm7uJNZ/5W9Mgc2UyhynTVZV5DGfKxlKVcSV+igvStuFRglRV2JaoPtYjG5RxxWWKDctxh83rDCMQkrGmHER5wnw2ebBVNoPGwUv2ySDhP/fKBbDBcFG9M1b18KAr/DkoHyMuWN6v3igrOw8+JR1ylgNCjKE88F4zrKHPFAfGymrDgP8pFHpvxAXVPtEsD8u0kG4tZTU9z675+7CBPwQl78wbLB2GzdkzvLNs84s3t0evf2j2gCTe577713etOmTaYwW2CzOygn07vtdi2MHtFw4F4Iq20PnMHcG3r1SVsB5L3uEGhTQ8zPYKFR2HSYYDOczbYllUkzTPzDENX0GSWsMFMsSW6XUuVLnG1TQSZnFXHeVYw8ytcUmxh3Ux3Q1eWk4iaGb+MfQpYB03SHt8bgSnJE4NVXX0sNHdq6KjlwhP7iiy+msHndFvhsZ8rF9G7T0wYwEcLkDNMz5sXEUY/tyAfvgUK3HZXYgH3RcmNgGxcQZdFSEHg3z6mFXUAWJf7FYvWG5MJA+VUnpAR5QRmUARpvbythjLDDLjyEfEQ18SvDW5ffPII8JhVuVHQdU8QtqnVIF76NbMnTLKZRuriTx2EPdLOozEEo169h4G1s5TRSj4PNyETuycYZHeuc0DCmBTCqxSxxHMvoRnJRR8VR4m8iyRG6KTybEboqz+KORGWHH1FHzKb6ZYPJYZAJ3cg16TxibCxDYTGN0G0tILZOenRxEDHJAfJG7MgFvRttGrYZOg9y4aipqaFly5bljIytFPrixYtp5MiReVHqNr+XIxACzEfJpnl5VTfASAGNX1BjwtvHbM3McmPKDQePSkyYPIxBkCH0pi1nQSY+KGU0BKoRQNz4FwK5YUSeID+S3E5nWhmOfIFrU5t6YSrTfHr/sqnjYdKSrzyyCdO27jNBndMoHSeTC19T/Exm97DTLI7w6E5ci3x8aliC3MLGTFjiYTocDofDUYokcnwqGDhwYHrt2rWxIiN7lIuqkJ0idzgcDkc5EaTMQSiF3vJQhDl1h8PhcDgc0TApcxBJoTNvvfUWHXvssU65OxwOh8ORMG+++WZqyJAh1vfHciyDFw0aNKj97EFzOBwOh6MEePvtt0MpcxBrhJ4TmDPFOxwOh8MRieOOO45WrlwZeZCcqEIXee755+m0U091Ct7hcDgcDgWjR49OXXjRRXTqT3+aSHh5U+gyp5xyCi1ZssQpeIfD4XCUJdXV1TRr1qzU5Zdfnpfw/x+Gm8WqDY8zQAAAAABJRU5ErkJggg=="
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
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
EndFunc ;==> Tinyau3Filessearch1Png ()