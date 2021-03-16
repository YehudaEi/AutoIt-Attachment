#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\LCheck.ico
#AutoIt3Wrapper_Outfile=TinyLinksChecker.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Description=Check Links and find broken.
#AutoIt3Wrapper_Res_Fileversion=1.0.1.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Res_LegalCopyright=wakillon 2013
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#include <WindowsConstants.au3>
#Include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#Include <GuiStatusBar.au3>
#include <GuiRichEdit.au3>
#include <WinHttp.au3>
#include <GuiMenu.au3>
#Include <String.au3>
#Include <Array.au3>
#EndRegion ;************ Includes ************

Opt ( 'GUICloseOnESC', 0 )
Opt ( 'GUIOnEventMode', 1 )
Opt ( 'WinWaitDelay', 0 )
Opt ( 'TrayMenuMode', 1 )

#Region ------ Global Variables ------------------------------
Global $sClipGet, $sClipGetOld, $sUrl, $aLinks, $iMemo, $hGui, $idButtonStart, $idButtonStop
Global $hRichEdit, $idContextMenu, $idContextMenuCopy, $hStatusBar, $idComboUrl, $idCheckHide1, $idCheckHide2, $idProgressBar
Global  $cpMin, $cpMax, $iDoubleClick, $iStart, $iStop, $iExit, $sUrlCookie, $aUrlSplitted
Global $sRegKeySettings = 'HKCU\Software\TinyLinksChecker\Settings'
Global $sSoftTitle = 'TinyLinksChecker  v' & _GetScriptVersion () & ' by wakillon'
Global $oMyError = ObjEvent ( 'AutoIt.Error', '_MyErrFunc' ), $aComboUrl[1]
#EndRegion --- Global Variables ------------------------------

#Region ------ Init ------------------------------
_Gui ()
_TrayMenu ()
#EndRegion --- Init ------------------------------

#Region ------ Main Loop ------------------------------
While 1
	If $iStart = 1 Then
		$sClipGet = ClipGet()
		$idComboUrlRead = GUICtrlRead ( $idComboUrl )
		If StringLeft ( $idComboUrlRead, 4 ) <> 'http' Then
			$sUrl = $sClipGet
		Else
			$sUrl = $idComboUrlRead
		EndIf
		$sUrl = StringStripWS ( $sUrl, 1+2+4 )
		ConsoleWrite ( @ScriptLineNumber & ' $sUrl : ' & $sUrl & @Crlf )
		If StringLeft ( $sUrl, 4 ) <> 'http' Then ContinueLoop
		If Not _AlreadyInArray ( $aComboUrl, $sUrl, 1 ) Then
			_ArrayAdd ( $aComboUrl, $sUrl )
			_ArraySort ( $aComboUrl, 0, 1 )
			$sData = _ArrayToString ( $aComboUrl, '|', 1 )
			GUICtrlSetData ( $idComboUrl, '', '' )
			GUICtrlSetData ( $idComboUrl, $sData, $sUrl )
		EndIf

		#Region ------ Checking Url Validity ------------------------------
		_GUICtrlStatusBar_SetText ( $hStatusBar, '      Please wait while Checking Url Validity' )
		$aResult = _WinHttpGetUrlInfos ( $sUrl )
		If @error Then ConsoleWrite ( '@error : ' & @error & ' : ' & $aResult & @Crlf )
		If IsArray ( $aResult ) Then
			If StringInStr ( $aResult[4], 'application' ) Then
				$iStop = 0
				$iStart = 0
				$sUrlCookie = ''
				_GUICtrlStatusBar_SetText ( $hStatusBar, '      Waiting for Url...' )
				GUICtrlSetData ( $idButtonStart, 'Start' )
				MsgBox ( 262144+16, 'Error', @CRLF & 'Url : ' & $sUrl & @CRLF & ' is not Valid !' & @CRLF, 5 )
				ContinueLoop
			EndIf
			$sFile = $aResult[8]
			$aResult = _WinHttpGetUrlInfos ( $aResult[8] )
			If @error Then ConsoleWrite ( '@error : ' & @error & ' : ' & $aResult & @Crlf )
			If IsArray ( $aResult ) Then
				If StringInStr ( $aResult[4], 'application' ) Then
					$iStop = 0
					$iStart = 0
					$sUrlCookie = ''
					GUICtrlSetData ( $idButtonStart, 'Start' )
					_GUICtrlStatusBar_SetText ( $hStatusBar, '      Waiting for Url...' )
					MsgBox ( 262144+16, 'Error', @CRLF & 'Url : ' & $sUrl & @CRLF & ' is not Valid !' & @CRLF & 'It is an Url for an application file : ' & $sFile, 5 )
					ContinueLoop
				EndIf
			EndIf
		EndIf
		#EndRegion --- Checking Url Validity ------------------------------

		_GuiCtrlRichEdit_SetText ( $hRichEdit, '' )
		_GUICtrlRichEdit_WriteLine ( $hRichEdit, 'Start Checking Links for Url : ' & $sUrl & @Crlf & @Crlf, 11, 0x00FF00 ) ; green
		_GUICtrlStatusBar_SetText ( $hStatusBar, '      Please wait while extracting Links' )

		#Region ------ Extracting Links ------------------------------
		$sSource = _WinHttpGetSource ( $sUrl )
		$sSource = StringReplace ( $sSource, "'", '"' )
		If Not StringInStr ( $sSource, '</frameset>' ) Then
			$aLinks = _ExtractLinks ( $sSource )
			$iUBound = UBound ( $aLinks ) -1
		Else
			$iUBound = 0
		EndIf
		ConsoleWrite ( @ScriptLineNumber & ' $iUBound : ' & $iUBound & @Crlf )
		If $iUBound < 2 Then
			$sSource = _IEGetSource ( $sUrl )
			$aLinks = _ExtractLinks ( $sSource )
			$iUBound = UBound ( $aLinks ) -1
		EndIf
		ConsoleWrite ( @ScriptLineNumber & ' $iUBound : ' & $iUBound & @Crlf )
		#EndRegion --- Extracting Links ------------------------------

		#Region ------ Checking Links ------------------------------
		If $iUBound > 1 Then
			GUICtrlSetState ( $idProgressBar, $GUI_SHOW )
			For $i = 1 To $iUBound
				$iPercent = Round ( ( 100 * $i ) / $iUBound )
				GUICtrlSetData ( $idProgressBar, $iPercent )
				If $iStop Then
					_GUICtrlRichEdit_WriteLine ( $hRichEdit, @Crlf & 'Operation of Checking Links for : ' & $sUrl & ' is Stopped' & @Crlf, 11, 0xFEAD0A ) ; Orange
					Sleep ( 500 )
					$iStart = 0
					ExitLoop
				EndIf
				$aLinks[$i] = StringStripWS ( $aLinks[$i], 1+2+4 )
				_GUICtrlStatusBar_SetText ( $hStatusBar, '     Checking : ' & $aLinks[$i] )
				ConsoleWrite ( '-->-- ' & @ScriptLineNumber & ' $aLinks1[' & $i & '] : ' & $aLinks[$i] & @Crlf )
				$aResult = _WinHttpGetUrlInfos ( $aLinks[$i] )
				If @error Then ConsoleWrite ( '@error : ' & @error & ' : ' & $aResult & @Crlf )
				$si = StringFormat ( '%0' & StringLen ( $iUBound ) & 'i', $i )
				If IsArray ( $aResult ) Then
					If StringInStr ( $aLinks[$i], ' ' ) Then $aLinks[$i] = StringReplace ( $aLinks[$i], ' ', '%20' )
					ConsoleWrite ( '!->-- ' & '[' & $i & ' / ' & $iUBound & ']' & ' : ' & $aResult[2] & ' ' & $aResult[3] & ' : ' & $aLinks[$i] & @Crlf )
					ConsoleWrite ( '>>>>>->-- ' & @ScriptLineNumber & ' $aResult[8] : ' & $aResult[8] & @Crlf )
					If _GetCheckState ( $hGui, $idCheckHide1 ) Then
						If StringInStr ( $aResult[3], 'ok' ) = 0 Then
							If StringInStr ( $aResult[2], '30' ) Then
								_GUICtrlRichEdit_WriteLine ( $hRichEdit, '[' & $si & ' / ' & $iUBound & ']' & ' : ' & $aResult[2] & ' ' & $aResult[3] & ' : ' & $aLinks[$i] & _
									_Iif ( ( $aResult[8] <> '' And $aLinks[$i] <> $aResult[8] ), @Crlf & ChrW ( 0x25BA ) & ChrW ( 0x25BA ) & ChrW ( 0x25BA ) & ' Location : ' & $aResult[8], '' ) & @CRLF, 8, 0xFFF242 )
							Else
								_GUICtrlRichEdit_WriteLine ( $hRichEdit, '[' & $si & ' / ' & $iUBound & ']' & ' : ' & $aResult[2] & ' ' & $aResult[3] & ' : ' & $aLinks[$i] & @Crlf, 8, _
									_Iif ( $aResult[2] > 399, 0xFF0000, 0xFFFFFF ) )
							EndIf
						EndIf
					Else
						If StringInStr ( $aResult[2], '30' ) Then
							_GUICtrlRichEdit_WriteLine ( $hRichEdit, '[' & $si & ' / ' & $iUBound & ']' & ' : ' & $aResult[2] & ' ' & $aResult[3] & ' : ' & $aLinks[$i] & _
								_Iif ( ( $aResult[8] <> '' And $aLinks[$i] <> $aResult[8] ), @Crlf & ChrW ( 0x25BA ) & ChrW ( 0x25BA ) & ChrW ( 0x25BA ) & ' Location : ' & $aResult[8], '' ) & @CRLF, 8, 0xFFF242 )
						Else
							_GUICtrlRichEdit_WriteLine ( $hRichEdit, '[' & $si & ' / ' & $iUBound & ']' & ' : ' & $aResult[2] & ' ' & $aResult[3] & ' : ' & $aLinks[$i] & @Crlf, 8, _
								_Iif ( $aResult[2] > 399, 0xFF0000, 0xFFFFFF ) )
						EndIf
					EndIf
				Else
					_GUICtrlRichEdit_WriteLine ( $hRichEdit, '[' & $si & ' / ' & $iUBound & ']' & ' : ' & $aResult & ' : ' & $aLinks[$i] & _
						_Iif ( StringInstr ( $aLinks[$i], '.com?' ), @Crlf & ChrW ( 0x25BA ) & ChrW ( 0x25BA ) & ChrW ( 0x25BA ) & ' Url Should be : ' & StringReplace ( $aLinks[$i], '.com?', '.com/?' ) & @CRLF, @Crlf ), 8, 0xFF0000 ) ; CONNECTION_TIMED_OUT
				EndIf
				Sleep ( 10 )
			Next
			GUICtrlSetState ( $idProgressBar, $GUI_HIDE )
			If Not $iStop Then
				_GUICtrlRichEdit_WriteLine ( $hRichEdit, @Crlf & 'End of Checking Links for : ' & $sUrl & @Crlf, 11, 0x00FF00 ) ;  green
				GUICtrlSetData ( $idButtonStart, 'Start' )
			EndIf
		Else
			_GUICtrlRichEdit_WriteLine ( $hRichEdit, @Crlf & 'End of Checking Links for : ' & $sUrl & @Crlf, 11, 0x00FF00 ) ;  green
			GUICtrlSetData ( $idButtonStart, 'Start' )
			MsgBox ( 262144+16, 'Error', @CRLF & 'No Links Found !' & @CRLF & @CRLF, 5 )
		EndIf
		$iStop = 0
		$iStart = 0
		$sUrlCookie = ''
		_GUICtrlStatusBar_SetText ( $hStatusBar, '      Waiting for Url...' )
		ConsoleWrite ( 'Search finish for : ' & $sUrl & @Crlf )
	EndIf
	#EndRegion --- Checking Links ------------------------------

	If $iExit Then _Exit ()
	Sleep ( 30 )
WEnd
#EndRegion --- Main Loop ------------------------------

_GUICtrlRichEdit_Destroy ( $hRichEdit )
Exit

Func _AlreadyInArray ( $aSearch, $iItem, $iStart=0, $iPartial=0 )
	_ArraySearch ( $aSearch, $iItem, $iStart, 0, 0, $iPartial )
	If Not @error Then Return 1
EndFunc ;==> _AlreadyInArray ()

Func _ArrayUniqueFast ( $aArray ) ; by Yashield ~ modified for empty array.
	Local $sData = '', $sSep = ChrW ( 160 )
	For $i = 0 To UBound ( $aArray ) - 1
		If Not IsDeclared ( $aArray[$i] & '$' ) Then
			Assign ( $aArray[$i] & '$', 0, 1 )
			$sData &= $aArray[$i] & $sSep
		EndIf
	Next
	If StringLen ( $sData ) > 1 Then Return StringSplit ( StringTrimRight ( $sData, 1 ), $sSep )
EndFunc ;==> _ArrayUniqueFast ()

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
	If $iStart Then
		_SendMessage ( GUICtrlGetHandle ( $idButtonStart ), $BM_CLICK )
		$iExit = 1
		Return
	EndIf
	Exit
EndFunc ;==> _Exit ()

Func _ExtractLinks ( $sSource )
	Local $sFullUrl
	Dim $aLinks1[1], $aLinks[1]
	StringReplace ( $sSource, 'src="', 'src="' )
	If @extended Then
		Local $aLinks2 = StringRegExp ( $sSource, '(?s)(?i)src="(.*?)"', 3 )
		If Not @error And IsArray ( $aLinks2 ) Then _ArrayConcatenate ( $aLinks1, $aLinks2 )
	EndIf
	StringReplace ( $sSource, 'href="', 'href="' )
	If @extended Then
		Local $aLinks2 = StringRegExp ( $sSource, '(?s)(?i)href="(.*?)"', 3 )
		If Not @error And IsArray ( $aLinks2 ) Then _ArrayConcatenate ( $aLinks1, $aLinks2 )
	EndIf
	$aLinks2 = ''
	$aLinks1 = _ArrayUniqueFast ( $aLinks1 );~
	$aUrlSplitted = _GetUrlSplitted ( $sUrl )
	For $i = 1 To UBound ( $aLinks1 ) -1
		$aLinks1[$i] = StringStripWS ( $aLinks1[$i], 1+2+4 )
		ConsoleWrite ( '!->-- ' & @ScriptLineNumber & ' $aLinks1[' & $i & '] : ' & $aLinks1[$i] & @Crlf )
		If StringLen ( $aLinks1[$i] ) > 1 And Not _OneOfThisStringInStr ( $aLinks1[$i], 'Array[|document.|javascript:|.href|file:|mailto:|news:|hcp:|ftp:|data:|webcal:|irc:' ) Then ; Gopher ? SSH ? FTP ? NNTP ? DNS ? SNMP ? XMPP ? Telnet ? SMTP ? POP3 ? IMAP ? IRC ? RTP? WebDAV ? SIMPLE ? HTTP ? Modbus ? IS-IS ? CLNP ? SIP ? DHCP? CANOpen? TCAP? RTSP
			ConsoleWrite ( '+->-- ' & @ScriptLineNumber & ' $aLinks1[' & $i & '] : ' & $aLinks1[$i] & @Crlf )
			If StringLeft ( $aLinks1[$i], 4 ) <> 'http' Then
				$sFullUrl =_WinINetResolveRelativeUrl ( $sUrl, $aLinks1[$i] )
				If $sFullUrl Then
					$aLinks1[$i] = $sFullUrl
					_ArrayAdd ( $aLinks, $sFullUrl )
				EndIf
			Else
				_ArrayAdd ( $aLinks, $aLinks1[$i] )
			EndIf
		EndIf
	Next
	$aLinks1=''
	_ArrayDelete ( $aLinks, 0 )
	Return _ArrayUniqueFast ( $aLinks )
EndFunc ;==> _ExtractLinks ()

Func _GetCheckState ( $sGuiTitle, $idCheckBox )
	Return ControlCommand ( $sGuiTitle, '', $idCheckBox, 'IsChecked', '' )
EndFunc ;==> _GetCheckState ()

Func _GetClickType ()
	Local $sLink = _GuiCtrlRichEdit_GetTextInRange ( $hRichEdit, $cpMin, $cpMax )
	If $iDoubleClick Then
		ConsoleWrite ( @ScriptLineNumber & ' $iDoubleClick : ' & @Crlf )
		ShellExecute ( $sLink )
		$iDoubleClick = 0
	Else
		ConsoleWrite ( @ScriptLineNumber & ' ClipPut : ' & @Crlf )
		ClipPut ( $sLink )
		TrayTip ( "Success", $sLink & @CRLF & "has been copied to the clipboard", 5, 1 )
	EndIf
	AdlibUnRegister ( '_GetClickType' )
	_GUICtrlRichEdit_Deselect ( $hRichEdit )
EndFunc ;==> _GetClickType ()

Func _GetScriptVersion ()
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
	RegWrite ( $sRegKeySettings, 'Version', 'REG_SZ', $sFileVersion )
	Return $sFileVersion
EndFunc ;==> _GetScriptVersion ()

Func _GetUrlSplitted ( $sUrl )
	Local $aSplitted, $aUrlSplit, $i
	$aUrlSplit = StringSplit ( _Iif ( StringRight ( $sUrl, 1 ) = '/', StringTrimRight ( $sUrl, 1 ), $sUrl ), '/' )
	Dim $aSplitted[UBound ( $aUrlSplit )]
	For $i = 1 To UBound ( $aSplitted ) -1
		$aSplitted[$i] = $aSplitted[$i-1] & $aUrlSplit[$i] & '/'
	Next
	_ArrayDelete ( $aSplitted, 1 )
	$aSplitted[0] = UBound ( $aSplitted ) -1
	Return $aSplitted
EndFunc ;==> _GetUrlSplitted ()

Func _Gui ()
	If Not FileExists ( 'C:\LCheck.ico' ) Then Lcheckico ( 'LCheck.ico', 'C:\' )
	$hGui = GUICreate ( $sSoftTitle, 800, 580 )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_Exit' )
	GUISetIcon ( 'C:\LCheck.ico' )
	$idComboUrl = GUICtrlCreateCombo ( 'Enter a Url', 10, 10, 650, 20 )
	GUICtrlSetFont ( -1, 9, 400, 0, 'Courier New' )
	GUICtrlSetTip ( -1, 'Enter a Url', ' ', 1, 1 )
	$hRichEdit = _GUICtrlRichEdit_Create ( $hGui, '', 10, 40, 780, 430, BitOR ( $ES_MULTILINE, $WS_HSCROLL, $WS_VSCROLL, $ES_READONLY ) )
	_GUICtrlRichEdit_SetBkColor ( $hRichEdit, 0x000000 )
	_GuiCtrlRichEdit_SetEventMask ( $hRichEdit, BitOR ( $ENM_MOUSEEVENTS, $ENM_LINK ) )
	_GuiCtrlRichEdit_AutoDetectURL ( $hRichEdit, True )
	$idContextMenu = GUICtrlCreateContextMenu ( GUICtrlCreateDummy () )
	$idContextMenuCopy = GUICtrlCreateMenuItem ( 'Copy', $idContextMenu )
	$idButtonStart = GUICtrlCreateButton ( 'Start', 670, 9, 120, 25 )
	$idCheckHide1 = GUICtrlCreateCheckbox ( 'Hide Links With Ok Status', 10, 490, 210, 20 )
	$idProgressBar = GUICtrlCreateProgress ( 10, 475, 780, 10 )
	GUICtrlSetState ( -1, $GUI_HIDE )
	$hStatusBar = _GUICtrlStatusBar_Create ( $hGui )
	_GUICtrlStatusBar_SetMinHeight ( $hStatusBar, 25 )
	_GUICtrlStatusBar_SetFont ( $hStatusBar, 16, 800 )
	_GUICtrlStatusBar_SetText ( $hStatusBar, '      Waiting for Url...' )
	GUIRegisterMsg ( $WM_NOTIFY, '_WM_NOTIFY' )
	GUIRegisterMsg ( $WM_Command, '_WM_Command' )
	GUISetState ()
EndFunc ;==> _Gui ()

Func _GUICtrlRichEdit_WriteLine ( $hCtrl, $sText=@CRLF, $iFontSize=9, $hColor=0xFFFFFF )
	_GUICtrlRichEdit_SetFont ( $hRichEdit, $iFontSize, "ARIAL" )
	$iAnchor = _GUICtrlRichEdit_FindText ( $hCtrl, @Cr, False )
	_GUICtrlRichEdit_AppendText ( $hCtrl, $sText )
	_GuiCtrlRichEdit_SetSel ( $hCtrl, $iAnchor, -1, False )
	_GuiCtrlRichEdit_SetCharColor ( $hCtrl, '0x' & Hex ( _Rgb2Bgr ( $hColor ), 6 ) )
	_GUICtrlRichEdit_Deselect ( $hCtrl )
EndFunc ;==> _GUICtrlRichEdit_WriteLine ()

Func _GUICtrlStatusBar_SetFont ( $hWnd, $iHeight=15, $iWeight=400, $iFontAtrributes=0, $sFontName='Arial' )
	If Not IsHWnd ( $hWnd ) Then $hWnd = GUICtrlGetHandle ( $hWnd )
	$hFont = _WinAPI_CreateFont ( $iHeight, 0, 0, 0, $iWeight, BitAND ( $iFontAtrributes, 2 ), BitAND ( $iFontAtrributes, 4 ), _
		BitAND ( $iFontAtrributes, 8 ), $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, $sFontName )
	_SendMessage ( $hWnd, $WM_SETFONT, $hFont, 1 )
EndFunc ;==> _GUICtrlStatusBar_SetFont ()

Func _IEGetSource ( $sUrl, $iTimeOut=6000 )
	Local $oIE, $iIETimerInit, $oFrame, $sSrc, $iNumFrames
	$oIE = ObjCreate ( 'InternetExplorer.Application' )
	If Not IsObj ( $oIE ) Then Return SetError ( 1, 0, 0 )
	$oIE.Visible = 0
	$oIE.silent = True
	$iIETimerInit = TimerInit ()
	$oIE.Navigate ( $sUrl )
	$hWnd = HWnd ( $oIE.HWnd () )
	While 1
		Sleep ( 250 )
		If TimerDiff ( $iIETimerInit ) > $iTimeOut Then
			$oIE.quit
			$oIE = 0
			If $hWnd And WinExists ( $hWnd ) Then WinClose ( $hWnd )
			Return SetError ( 2, 0, 0 )
		EndIf
		If Not IsObj ( $oIE ) Then
			$oIE = 0
			If $hWnd And WinExists ( $hWnd ) Then WinClose ( $hWnd )
			Return SetError ( 3, 0, 0 )
		Else
			If Not $oIE.Busy Then ExitLoop
		EndIf
	WEnd
	Sleep ( 500 )
	If String ( $oIE.document.body.tagName) = 'frameset' Then
		$iNumFrames = $oIE.document.parentwindow.frames.length
		For $i = 0 To $iNumFrames -1
			$oFrame = $oIE.document.parentwindow.frames ( $i )
			$sSrc &= $oFrame.document.body.innerHTML & @Crlf
		Next
		$oFrame = 0
	Else
		$sSrc = $oIE.document.body.innerHTML
	EndIf
	$oIE.quit
	$oIE = 0
	Return $sSrc
EndFunc ;==> _IEGetSource ()

Func _IsANoAlphabeticCharInString ( $sString )
	Return StringRegExp ( $sString, '(?i)[^a-z]', 0 )
EndFunc ;==> _IsANoAlphabeticCharInString ()

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

Func _MyErrFunc ()
	$HexNumber = hex ( $oMyError.number, 8 )
	GUICtrlSetData ( $idButtonStart, 'Start' )
	$iStop = 0
	$iStart = 0
Endfunc ;==> _MyErrFunc ()

Func _OneOfThisStringInStr ( $sInStr, $sString )
	Local $aString = StringSplit ( $sString, '|' )
	If @error Then Return
	For $i = 1 To UBound ( $aString ) -1
		If StringInStr ( $sInStr, $aString[$i] ) Then Return 1
	Next
EndFunc ;==> _OneOfThisStringInStr ()

Func _Rgb2Bgr ( $hDecColor )
	Return BitOR ( BitShift ( BitAND ( $hDecColor, 0xFF0000 ), 16 ), BitAND ( $hDecColor, 0xFF00 ), BitShift ( BitAND ( $hDecColor, 0xFF ), -16 ) )
EndFunc ;==> _Rgb2Bgr ()

Func _TrayMenu ()
	TraySetIcon ( 'C:\LCheck.ico' )
	TraySetClick ( 8 )
	TraySetState ( 4 )
	TraySetToolTip ( $sSoftTitle )
EndFunc ;==> _TrayMenu ()

Func _WinHttpGetSource ( $sUrl )
	Local $hOpen = _WinHttpOpen ()
	Local $aCrackedUrl = _WinHttpCrackUrl ( $sUrl, $ICU_DECODE )
	If @error Then Return SetError ( 0, 0, 'ERROR_INVALID_URL_FORM' )
	Local $sHostName = $aCrackedUrl[2], $sFileName = $aCrackedUrl[6], $sExtra = $aCrackedUrl[7]
	If $sExtra Then $sFileName &= $sExtra
	ConsoleWrite ( @ScriptLineNumber & ' $sHostName : ' & $sHostName & @Crlf )
	ConsoleWrite ( @ScriptLineNumber & ' $sFileName : ' & $sFileName & @Crlf )
	Local $hConnect = _WinHttpConnect ( $hOpen, $sHostName )
	Local $hRequest = _WinHttpSimpleSendRequest ( $hConnect, 'GET', $sFileName )
	_WinHttpAddRequestHeaders ( $hRequest, 'User-Agent:Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Accept:text/html, application/x-ms-application, application/xaml+xml  application/xhtml+xml, application/xml, application/x-ms-xbap, image/jpeg, image/gif, image/pjpeg, */*' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Accept-Encoding:gzip, deflate' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Host:' & $sHostName )
	_WinHttpAddRequestHeaders ( $hRequest, 'Connection:Keep-Alive' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Accept-Charset: ISO-8859-1,UTF-8;q=0.7,*;q=0.7' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Cache-Control: no-cache' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Referer:' & $sUrl )
	Local $sDatas = _WinHttpSimpleReadData ( $hRequest )
	_WinHttpCloseHandle ( $hRequest )
	_WinHttpCloseHandle ( $hConnect )
	_WinHttpCloseHandle ( $hOpen )
	$hRequest = 0
	$hConnect = 0
	$hOpen = 0
	Return $sDatas
EndFunc ;==> _WinHttpGetSource ()

Func _WinHttpGetUrlInfos ( $sUrl, $iTimeOut=5000, $iCookie='' )
	Local $hOpen = _WinHttpOpen ()
	Local $aCrackedUrl = _WinHttpCrackUrl ( $sUrl, $ICU_DECODE )
	If @error Then Return SetError ( 1, 0, 'ERROR_INVALID_URL_FORM' )
	Local $sSchemeName = $aCrackedUrl[0], $sHostName = $aCrackedUrl[2], $sFileName = $aCrackedUrl[6], $sExtra = $aCrackedUrl[7], $sErrorMsg
	ConsoleWrite ( '$sExtra : ' & $sExtra & @Crlf )
	If StringInStr ( $sExtra, '&' ) Then $sFileName &= $sExtra
	ConsoleWrite ( @ScriptLineNumber & ' $sHostName : ' & $sHostName & @Crlf )
	ConsoleWrite ( @ScriptLineNumber & ' $sFileName : ' & $sFileName & @Crlf )
	_WinHttpSetOption ( $hOpen, $WINHTTP_OPTION_REDIRECT_POLICY, $WINHTTP_OPTION_REDIRECT_POLICY_NEVER )
	If @error Then
		$sErrorMsg = _WinHttpRetrieveErrorMsg ( _WinAPI_GetLastError () )
		_WinHttpCloseHandle ( $hOpen )
		$hOpen = 0
		Return SetError ( 2, 0, $sErrorMsg )
	EndIf
	Local $hConnect = _WinHttpConnect ( $hOpen, $sHostName )
	If @error Then
		$sErrorMsg = _WinHttpRetrieveErrorMsg ( _WinAPI_GetLastError () )
		_WinHttpCloseHandle ( $hConnect )
		_WinHttpCloseHandle ( $hOpen )
		$hConnect = 0
		$hOpen = 0
		Return SetError ( 3, 0, $sErrorMsg )
	EndIf
	Local $hRequest = _WinHttpOpenRequest ( $hConnect, 'GET', $sFileName, 'HTTP/1.1' )
	If @error Then
		$sErrorMsg = _WinHttpRetrieveErrorMsg ( _WinAPI_GetLastError () )
		_WinHttpCloseHandle ( $hRequest )
		_WinHttpCloseHandle ( $hConnect )
		_WinHttpCloseHandle ( $hOpen )
		$hRequest = 0
		$hConnect = 0
		$hOpen = 0
		Return SetError ( 4, 0, $sErrorMsg )
	EndIf
	_WinHttpSetTimeouts ( $hRequest, $iTimeOut, $iTimeOut, $iTimeOut, $iTimeOut )
	If @error Then
		$sErrorMsg = _WinHttpRetrieveErrorMsg ( _WinAPI_GetLastError () )
		_WinHttpCloseHandle ( $hRequest )
		_WinHttpCloseHandle ( $hConnect )
		_WinHttpCloseHandle ( $hOpen )
		$hRequest = 0
		$hConnect = 0
		$hOpen = 0
		Return SetError ( 5, 0, $sErrorMsg )
	EndIf
	_WinHttpAddRequestHeaders ( $hRequest, 'Accept:text/html, application/x-ms-application, application/xaml+xml  application/xhtml+xml, application/xml, application/x-ms-xbap, image/jpeg, image/gif, image/pjpeg, */*' )
	_WinHttpAddRequestHeaders ( $hRequest, 'User-Agent:Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Accept-Encoding:gzip, deflate' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Host:' & $sHostName )
	_WinHttpAddRequestHeaders ( $hRequest, 'Connection:Keep-Alive' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Accept-Charset: ISO-8859-1,UTF-8;q=0.7,*;q=0.7' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Cache-Control: no-cache' )
	_WinHttpAddRequestHeaders ( $hRequest, 'Referer:' & $sUrl )
	If $iCookie And $sUrlCookie Then _WinHttpAddRequestHeaders ( $hRequest, 'Cookie:' & $sUrlCookie )
	_WinHttpSendRequest ( $hRequest )
	If @error Then
		$sErrorMsg = _WinHttpRetrieveErrorMsg ( _WinAPI_GetLastError () )
		_WinHttpCloseHandle ( $hRequest )
		_WinHttpCloseHandle ( $hConnect )
		_WinHttpCloseHandle ( $hOpen )
		$hRequest = 0
		$hConnect = 0
		$hOpen = 0
		Return SetError ( 6, 0, $sErrorMsg )
	EndIf
	$iResponse = _WinHttpReceiveResponse ( $hRequest )
	If @error Then
		$sErrorMsg = _WinHttpRetrieveErrorMsg ( _WinAPI_GetLastError () )
		_WinHttpCloseHandle ( $hRequest )
		_WinHttpCloseHandle ( $hConnect )
		_WinHttpCloseHandle ( $hOpen )
		$hRequest = 0
		$hConnect = 0
		$hOpen = 0
		Return SetError ( 7, 0, $sErrorMsg )
	EndIf
	If $iResponse Then
		Local $aResult[10]
		$aResult[0] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_REQUEST_METHOD )
		$aResult[1] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_VERSION )
		$aResult[2] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_STATUS_CODE )
		$aResult[3] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_STATUS_TEXT )
		If _IsANoAlphabeticCharInString ( $aResult[3] ) Then  ; sometimes status text is badly formed.
			Switch $aResult[2]
				Case 200
					$aResult[3] = 'OK'
				Case 301
					$aResult[3] = 'Moved Permanently'
				Case 302
					$aResult[3] = 'Moved Temporarily'
				Case 303
					$aResult[3] = 'See Other'
				Case 400
					$aResult[3] = 'Bad Request'
				Case 401
					$aResult[3] = 'Authorization Required'
				Case 403
					$aResult[3] = 'Forbidden'
				Case 404
					$aResult[3] = 'Not Found'
				Case 405
					$aResult[3] = 'Not Allowed'
				Case 406
					$aResult[3] = 'Not Acceptable'
				Case 410
					$aResult[3] = 'Gone'
				Case 500
					$aResult[3] = 'Internal Server Error'
				Case 501
					$aResult[3] = 'Not Implemented'
				Case 502
					$aResult[3] = 'Bad Gateway'
				Case 503
					$aResult[3] = 'Service Unavailable'
			EndSwitch
		EndIf
		$aResult[4] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_CONTENT_TYPE )
		$aResult[5] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_CONTENT_LENGTH )
		$aResult[6] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_CONTENT_DESCRIPTION )
		$aResult[7] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_LAST_MODIFIED )
		$aResult[8] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_LOCATION )
		If $aResult[8] And StringLeft ( $aResult[8], 4 ) <> 'http' Then    $aResult[8] = $sSchemeName & '://' & $sHostName & $aResult[8]
		$aResult[9] = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_SET_COOKIE )
		If $aResult[2] = 400 Then $sHeader = _WinHttpQueryHeaders ( $hRequest ) ; full header
	EndIf
	_WinHttpCloseHandle ( $hRequest )
	_WinHttpCloseHandle ( $hConnect )
	_WinHttpCloseHandle ( $hOpen )
	$hRequest = 0
	$hConnect = 0
	$hOpen = 0
	If $iResponse Then
		Return $aResult
	Else
		Return SetError ( -1, $iTimeOut, 'ERROR_WINHTTP_TIMEOUT' ) ; ~ Connection failure
	EndIf
EndFunc ;==> _WinHttpGetUrlInfos ()

Func _WinHttpRetrieveErrorMsg ( $iLastError )
	Local $sErrorMsg
	Switch $iLastError
		Case $WINHTTP_ERROR_BASE
			$sErrorMsg = 'ERROR BASE'
		Case $ERROR_WINHTTP_OUT_OF_HANDLES
			$sErrorMsg = 'OUT OF HANDLES'
		Case $ERROR_WINHTTP_TIMEOUT
			$sErrorMsg = 'TIMEOUT'
		Case $ERROR_WINHTTP_INTERNAL_ERROR
			$sErrorMsg = 'INTERNAL ERROR'
		Case $ERROR_WINHTTP_INVALID_URL
			$sErrorMsg = 'INVALID URL'
		Case $ERROR_WINHTTP_UNRECOGNIZED_SCHEME
			$sErrorMsg = 'UNRECOGNIZED SCHEME'
		Case $ERROR_WINHTTP_NAME_NOT_RESOLVED
			$sErrorMsg = 'NAME NOT RESOLVED'
		Case $ERROR_WINHTTP_INVALID_OPTION
			$sErrorMsg = 'INVALID OPTION'
		Case $ERROR_WINHTTP_OPTION_NOT_SETTABLE
			$sErrorMsg = 'OPTION NOT SETTABLE'
		Case $ERROR_WINHTTP_SHUTDOWN
			$sErrorMsg = 'SHUTDOWN'
		Case $ERROR_WINHTTP_LOGIN_FAILURE
			$sErrorMsg = 'LOGIN FAILURE'
		Case $ERROR_WINHTTP_OPERATION_CANCELLED
			$sErrorMsg = 'OPERATION CANCELLED'
		Case $ERROR_WINHTTP_INCORRECT_HANDLE_TYPE
			$sErrorMsg = 'INCORRECT HANDLE TYPE'
		Case $ERROR_WINHTTP_INCORRECT_HANDLE_STATE
			$sErrorMsg = 'INCORRECT HANDLE STATE'
		Case $ERROR_WINHTTP_CANNOT_CONNECT
			$sErrorMsg = 'CANNOT CONNECT'
		Case $ERROR_WINHTTP_CONNECTION_ERROR
			$sErrorMsg = 'CONNECTION ERROR'
		Case $ERROR_WINHTTP_RESEND_REQUEST
			$sErrorMsg = 'RESEND REQUEST'
		Case $ERROR_WINHTTP_SECURE_CERT_DATE_INVALID
			$sErrorMsg = 'SECURE CERT DATE INVALID'
		Case $ERROR_WINHTTP_SECURE_CERT_CN_INVALID
			$sErrorMsg = 'SECURE CERT CN INVALID'
		Case $ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED
			$sErrorMsg = 'CLIENT AUTH CERT NEEDED'
		Case $ERROR_WINHTTP_SECURE_INVALID_CA
			$sErrorMsg = 'SECURE INVALID CA'
		Case $ERROR_WINHTTP_SECURE_CERT_REV_FAILED
			$sErrorMsg = 'SECURE CERT REV FAILED'
		Case $ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN
			$sErrorMsg = 'CANNOT CALL BEFORE OPEN'
		Case $ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND
			$sErrorMsg = 'CANNOT CALL BEFORE SEND'
		Case $ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND
			$sErrorMsg = 'CANNOT CALL AFTER SEND'
		Case $ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN
			$sErrorMsg = 'CANNOT CALL AFTER OPEN'
		Case $ERROR_WINHTTP_HEADER_NOT_FOUND
			$sErrorMsg = 'HEADER NOT FOUND'
		Case $ERROR_WINHTTP_INVALID_SERVER_RESPONSE
			$sErrorMsg = 'INVALID SERVER RESPONSE'
		Case $ERROR_WINHTTP_INVALID_HEADER
			$sErrorMsg = 'INVALID HEADER'
		Case $ERROR_WINHTTP_INVALID_QUERY_REQUEST
			$sErrorMsg = 'INVALID QUERY REQUEST'
		Case $ERROR_WINHTTP_HEADER_ALREADY_EXISTS
			$sErrorMsg = 'HEADER ALREADY EXISTS'
		Case $ERROR_WINHTTP_REDIRECT_FAILED
			$sErrorMsg = 'REDIRECT FAILED'
		Case $ERROR_WINHTTP_SECURE_CHANNEL_ERROR
			$sErrorMsg = 'SECURE CHANNEL ERROR'
		Case $ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT
			$sErrorMsg = 'BAD AUTO PROXY SCRIPT'
		Case $ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT
			$sErrorMsg = 'UNABLE TO DOWNLOAD SCRIPT'
		Case $ERROR_WINHTTP_SECURE_INVALID_CERT
			$sErrorMsg = 'SECURE INVALID CERT'
		Case $ERROR_WINHTTP_SECURE_CERT_REVOKED
			$sErrorMsg = 'SECURE CERT REVOKED'
		Case $ERROR_WINHTTP_NOT_INITIALIZED
			$sErrorMsg = 'NOT INITIALIZED'
		Case $ERROR_WINHTTP_SECURE_FAILURE
			$sErrorMsg = 'SECURE FAILURE'
		Case $ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR
			$sErrorMsg = 'AUTO PROXY SERVICE ERROR'
		Case $ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE
			$sErrorMsg = 'SECURE CERT WRONG USAGE'
		Case $ERROR_WINHTTP_AUTODETECTION_FAILED
			$sErrorMsg = 'AUTODETECTION FAILED'
		Case $ERROR_WINHTTP_HEADER_COUNT_EXCEEDED
			$sErrorMsg = 'HEADER COUNT EXCEEDED'
		Case $ERROR_WINHTTP_HEADER_SIZE_OVERFLOW
			$sErrorMsg = 'HEADER SIZE OVERFLOW'
		Case $ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW
			$sErrorMsg = 'CHUNKED ENCODING HEADER SIZE OVERFLOW'
		Case $ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW
			$sErrorMsg = 'RESPONSE DRAIN OVERFLOW'
		Case $ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY
			$sErrorMsg = 'CLIENT CERT NO PRIVATE KEY'
		Case $ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY
			$sErrorMsg = 'CLIENT CERT NO ACCESS PRIVATE KEY'
		Case $WINHTTP_ERROR_LAST
			$sErrorMsg = 'LAST'
		Case Else
			$sErrorMsg = 'CONNECTION TIMED OUT'
	EndSwitch
	Return $sErrorMsg
EndFunc ;==> _WinHttpRetrieveErrorMsg ()

Func _WinINetResolveRelativeUrl ( $sBaseUrl, $sRelativeUrl ) ; http://msdn.microsoft.com/en-us/library/windows/desktop/aa384355(v=vs.85).aspx
	Local $iBufferLength, $tBuffer, $aResult
	$iBufferLength = ( StringLen ( $sBaseUrl ) + StringLen ( $sRelativeUrl ) ) *3 + 1
	$tBufferLength = DllStructCreate ( 'dword' )
	DllStructSetData ( $tBufferLength, 1, $iBufferLength )
	$tBuffer = DllStructCreate ( 'wchar[' & $iBufferLength & ']' )
	$aResult = DllCall ( 'wininet.dll', 'int', 'InternetCombineUrlW', 'wstr', $sBaseUrl, 'wstr', $sRelativeUrl, 'ptr', DllStructGetPtr ( $tBuffer ), 'ptr', DllStructGetPtr ( $tBufferLength ), 'dword', 0x10000000 )
	If Not @error And $aResult[0] Then Return DllStructGetData ( $tBuffer, 1 )
EndFunc ;==> _WinINetResolveRelativeUrl ()

Func _WM_Command ( $hWnd, $Msg, $wParam, $lParam )
	Local $nNotifyCode = BitShift ( $wParam, 16 )
	Local $nCtrlID = BitAND ( $wParam, 0x0000FFFF )
	Local $hCtrl = $lParam
	Switch $nNotifyCode
		Case $BN_CLICKED
			Switch $nCtrlID
				Case $idButtonStart, 1
					Switch GUICtrlRead ( $idButtonStart )
						Case 'stop'
							If $nCtrlID = 1 Then Return 0
							If $iStart Then $iStop = 1
							GUICtrlSetData ( $idButtonStart, 'Start' )
						Case 'start'
							$iStart = 1
							GUICtrlSetData ( $idButtonStart, 'Stop' )
					EndSwitch
				Case $idCheckHide1
				Case $idComboUrl
				Case $idContextMenuCopy
					_GuiCtrlRichEdit_Copy ( $hRichEdit )
					$sClipGet = StringStripWS ( ClipGet (), 7 )
					ClipPut ( $sClipGet )
;~                  Case 1 ; Enter key
;~                  If GUICtrlRead ( $idComboUrl ) = '' Then Return 0
;~                  ConsoleWrite ( '!->-- ' & @ScriptLineNumber & ' $idComboUrl : ' & $idComboUrl & @Crlf )
				Case 2 ; Esc key for reset all previous numbers typed.
					GUICtrlSetData ( $idComboUrl, '' )
					ReDim $aComboUrl[1]
				Case Else
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_Command ()

Func _WM_NOTIFY ( $hWnd, $iMsg, $iWparam, $iLparam )
	Local $hWndFrom, $iCode, $tNMHDR, $tMsgFilter
	$tNMHDR = DllStructCreate ( $tagNMHDR, $iLparam )
	$hWndFrom = HWnd ( DllStructGetData ( $tNMHDR, 'hWndFrom' ) )
	$iCode = DllStructGetData ( $tNMHDR, 'Code' )
	$tMsgFilter = DllStructCreate ( $tagNMHDR & ';uint msg;wparam wParam;lparam lParam', $iLparam )
	Switch $hWndFrom
		Case $hRichEdit
			Switch $iCode
				Case $EN_MSGFILTER
					If DllStructGetData ( $tMsgFilter, 'msg' ) = $WM_RBUTTONUP Then _GUICtrlMenu_TrackPopupMenu ( GUICtrlGetHandle ( $idContextMenu ), $hWnd )
				Case $EN_LINK
					$tEnLink = DllStructCreate ( $tagENLINK, $iLparam )
					$cpMin = DllStructGetData ( $tEnLink, 'cpMin' )
					$cpMax = DllStructGetData ( $tEnLink, 'cpMax' )
					Switch DllStructGetData ( $tMsgFilter, 'msg' )
						Case $WM_LBUTTONDBLCLK
							$iDoubleClick = 1
						Case $WM_LBUTTONUP
							AdlibRegister ( '_GetClickType', 500 )
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_NOTIFY ()

Func Lcheckico ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '4FVFwlQ/ANHOkn//5Me8AP/d5dT/5ujbEP/K4sZiAODn1hD/0OPKYgHR4soA/9fItP/NiXWg/71HMMJgHjM/DCEfAL9POgLgEEnAAFA6qcdoU+/UAIl5/9Cvm//SALik/+Cmmv/aAJuO/86Ugf/JAHFe6cNYQ57COFdDPb8KHwDyIVA7AAPBVD8pxWBMIE7IZlRe4AFbvgBLNknDWEQkxDhdSQIfAw8ACQD+AAAA//wAAD/4AAQAHzwAD/AAAAdZMAAB4HACMQDAOACAdTcAATgAA7ABNgAwAwe3MQAwBLEED3EFsQb/MAcA/4AD///wD/+qKDAEEDAAIDAAAVIAMAAAQAR/CgkADgAIAAQTYAAbCQkbAFtQTzG+uLhkAJSyj8IrcB/5ALnKtafZ1tZFWMDBvWACDwANswMvABkFA19ILSGDAKB+bL6XqILuAB5+Jf8Tskj/ACZ6J/2itJ/JgKylpV7HycWhCQEKABYGAQM5GAUAOZJLLMbjoHUA/KO5iv8dhS8A/xnMd/8n57MA/xjGbf8hgzEA/qnDqMD7+/sAQvH38g7q8+wB9i+eSB0dymM0ANnmiEz/w7B0AP8chzr/G9uWAP8iwYL/IZI7AP8jyIv/HNCCAP8ejDv/qMutAL3///9F7fbwAXIIbycYBMRPMgDL3WUz//B9OQD/9K92/06dWgD/HqZk/1GkYgD/49Gu/0ieWQD/LciS/y7hpQD/HJVI/53NrAq+MARI8QO4QClnANBSNP/pXjD/APpwNP/+jVD/AtAwalOpZv9vsQBn/+Suef/0twCS/02kZP8uyQCV/zTnsv8YniBT/o7LpfJ6wEQALczaTTH/81oBsANpO//+e0j/AHWWQf8yjyX/AEGPKP/OjlD/AOuTZP/TuJX/AEesbv8ty5r/ACTKlf83qGfqAGYjFwrFRSz9gOJPMv/5WTvwCwBa/6ePT/+nnABh/5mTUP/1iwJj8KtY/4+RSf8gOpQt/3XwdUSxAHH/NLBu/uLyAOl9aSQXHshGACz/5VI2/+p/AGH/TJM0/6qoAHP/v6By//eJBmywqPGoav/MlWsA/zyULP9PnEAA/5Wrcv+op38g/9vLyDHwAw/GAEUs/uZnTv+GQJ9c/0qcPjIAbgCjVP/snYH//wSRezIA/paB/4oQrGv/mrAVZJhFAP9/eDv6pY6DAgjyD0Mr2uCCbQD/fq5p/2OqWYE2AJWzeP/3p/CHAKCN//6gjv+lAXCfgrFv/0yeQCD/oGk+yrUfvEMALH6rn3T/fbgCdTIAtMCU/7HDAJf/vMCY/++5AKX/9rOh//uxAKH/37qh/52/wIr/m616/7A+NmsAijMjDrqBZOIAm8eT/6bKm/8Aqcuc/9TUuf8Awsuo/7vLpP8iujAAwM2pMG+t/wDNw6j/vX5j2BiMOCiyCwUAskg0ADPTl4Xuwti4AP/K2r7/z9vBAP/d3Mj/tdauAP+v1Kr/0tS7AP/ww7n/1IFxIOixRTEpHzQAAACqQy8nyXxoxKDTxrL/0zBg0fBXAMvhxv/G4MH/ANLDrf/JZ1W7MKg8KB+fAwsAr0cAMzzHZVKGzIsAeKrOd2aox2/AW4OxTTo2nwLwR7oH8BcD/0cxAAkAgJA2FzUA8QJxA/iQCA=='
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
EndFunc ;==> Lcheckico ()