#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Windows\joystick.ico
#AutoIt3Wrapper_Outfile=CanYouRunIt.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Tested on Xp SP3 32bit.
#AutoIt3Wrapper_Res_Description=Test Computer performances needed for Game.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.8
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=Copyright ? 2011 wakillon
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Res_Icon_Add=C:\Windows\joystick.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===================================================================================================
;
; Program Name : Can You Run It ?
; Description  : Uses systemrequirementslab.com for Test Computer performances needed for Game.
; Author       : wakillon
;
;===================================================================================================
#Region    ;************ Includes ************
#Include <WindowsConstants.au3>
#Include <GUIConstantsEx.au3>
#Include <ComboConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Misc.au3>
#Include <Date.au3>
#include <IE.au3>
#EndRegion ;************ Includes ************

#NoTrayIcon
Opt ( 'GuiOnEventMode', 1 )
If Not _Singleton ( @ScriptName, 1 ) Then Exit

Global $oIE, $_Gui, $_TestButton, $_CoverPic, $_GraphGifUrl, $_ComboBox, $_ComboBoxItems
Global $_ImageUrl, $_ArrayGameImage, $_ArrayGameTitle, $_GraphFilePath1
Global $_TempDir = @TempDir & '\CYRI'
Global $_LogoFilePath = $_TempDir & '\Skin\Logo3.BMP', $_TestMeter_Gif, $_Animated_Gif2, $_Animated_Gif3
Global $_Version = _GetScriptVersion ( )
Global $_PreLoaderPath = $_TempDir & '\skin\PreLoader1.gif', $oGifArray, $_Color, $_GraphFileName
Global $_DefaultBrowser = _GetDefaultBrowser ( )
Global $_RegKey = 'HKCU\SOFTWARE\CanYouRunIt', $_RegPreviousSound, $_Flash, $_TimerInit, $_SplashTitle
Global $_IEVisible = 0 ; set to 1 for debug help.

If Not _IsConnected ( ) Then Exit MsgBox ( 262144, 'Error', 'You are not Connected to Internet !', 4, $_Gui )
OnAutoItExitRegister ( '_OnAutoItExit' )

If _FileMissing ( ) Then _FileInstall ( )
_UpdateGamesList ( )
_Gui ( )

While 1
	Sleep ( 30 )
WEnd

Func _Test ( )
	GUICtrlSetState ( $_TestButton, $GUI_DISABLE )
	GUICtrlSetState ( $_ComboBox, $GUI_DISABLE )
    If $_TestMeter_Gif Then GUICtrlSetState ( $_TestMeter_Gif, $GUI_HIDE )
    GUICtrlSetState ( $_Animated_Gif2, $GUI_SHOW )
    GUICtrlSetState ( $_Animated_Gif3, $GUI_SHOW )
    GUICtrlSetState ( $_CoverPic, $GUI_ENABLE )
	GUICtrlSetState ( $_CoverPic, $GUI_SHOW )
	$_SelectedGame = StringMid ( GUICtrlRead ( $_ComboBox ), 7 )
	$_TimerInit = TimerInit ( )
	AdlibRegister ( '_HangTime', 1000 )
	$oForm = _IEFormGetObjByName ( $oIE, 'aspnetForm' )
	$oSelect = _IEFormElementGetObjByName ( $oForm, 'ctl00$body$itemList' )
	_IEFormElementOptionSelect ( $oSelect, $_SelectedGame, 1, 'byText' )
	$oQuery = _IEFormElementGetObjByName ( $oForm, 'txtSearch' )
	_IEFormElementSetValue ( $oQuery, '' )
	Sleep ( 500 )
	$oButton = _IEGetObjById ( $oIE, 'ctl00_body_btnSubmit' )
	_IEAction ( $oButton, 'Click' )
	_IELoadWait ( $oIE )
	While 1
		Sleep ( 500 )
		$oImgs = _IEImgGetCollection ( $oIE )
		If $oImgs <> 0 Then
			For $oImg In $oImgs
				If StringInStr ( $oImg.src, 'cloudfront.net/global/assets/images/graphs/' ) <> 0 Then
					$_GraphGifUrl = $oImg.src
					Exitloop 2
				EndIf
			Next
		EndIf
	WEnd
	AdlibUNRegister ( '_HangTime' )
	$_GraphFileName = _GetFullNameByUrl ( $_GraphGifUrl )
	AdlibRegister ( '_InvertColor', 1200 )
	$_GraphFilePath1 = $_TempDir & '\Skin\' & $_GraphFileName
	If Not FileExists ( $_GraphFilePath1 ) Then InetGet ( $_GraphGifUrl, $_GraphFilePath1, 9, 0 )
	GUICtrlSetState ( $_CoverPic, $GUI_HIDE )
	GUICtrlSetState ( $_Animated_Gif2, $GUI_HIDE )
	GUICtrlSetState ( $_Animated_Gif3, $GUI_HIDE )
	If $_TestMeter_Gif Then
		_GuiCtrlAnimatedGif_SetPic ( $oGifArray[3], $_GraphFilePath1 )
	Else
		$_TestMeter_Gif = _GuiCreateAnimatedGif ( $_Gui, $_GraphFilePath1, 390, 101, 15, 200, 1 )
		If Not @error Then _GuiCtrlAnimatedGif_SetPic ( $oGifArray[3], $_GraphFilePath1 )
	EndIf
	GUICtrlSetState ( $_TestMeter_Gif, $GUI_SHOW )
    _IENavigate ( $oIE, 'http://www.systemrequirementslab.com/CYRI/intro.aspx', 1 )
	GUICtrlSetState ( $_ComboBox, $GUI_ENABLE )
	GUICtrlSetState ( $_ComboBox, $GUI_NOFOCUS )
EndFunc ;==> _Test ( )

Func _Read ( )
	AdlibUnRegister ( '_InvertColor' )
	$_Flash = 0
	Sleep ( 500 )
	GUISetBkColor ( 0xB5FFAD, $_Gui )
	GUICtrlSetState ( $_TestButton, $GUI_DISABLE )
	$_SelectedGame = GUICtrlRead ( $_ComboBox )
	$_CurrentSelect = Number ( StringLeft ( $_SelectedGame, 3 ) )
	$_ImageUrl = 'http://content.systemrequirementslab.com.s3.amazonaws.com/global/assets/images/boxshots/ref_default/box_' & $_ArrayGameImage[$_CurrentSelect] & '.jpg'
	$_ImagePath = $_TempDir & '\Skin\' & _GetFullNameByUrl ( $_ImageUrl )
	If Not FileExists ( $_ImagePath ) Then InetGet ( $_ImageUrl, $_ImagePath, 9, 0 )
    If $_TestMeter_Gif Then	GUICtrlSetState ( $_TestMeter_Gif, $GUI_HIDE )
	If Not $_CoverPic Then
		$_CoverPic = GUICtrlCreatePic ( $_ImagePath, 150, 180, 115, 141 )
	Else
		GUICtrlSetImage ( $_CoverPic, $_ImagePath )
	EndIf
	GUICtrlSetState ( $_CoverPic, $GUI_ENABLE )
	GUICtrlSetState ( $_CoverPic, $GUI_SHOW )
	GUICtrlSetState ( $_TestButton, $GUI_ENABLE )
EndFunc ;==> _Read ( )

#Region ------ Gui Management ------------------------------
Func _Gui ( )
    $_Gui = GUICreate ( '  ' & $_Version, 420, 365, -1, -1, -1, $WS_EX_TOPMOST )
	GUISetIcon ( @WindowsDir & '\joystick.ico', $_Gui )
	GUISetBkColor ( 0xB5FFAD, $_Gui )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_Exit', $_Gui )
	$_Pic = GUICtrlCreatePic ( $_LogoFilePath, 15, 0, 390 )
	GUICtrlSetTip ( $_Pic, 'Open CanYouRunIt?.com' )
	GUICtrlSetOnEvent ( $_Pic, '_OpenCanYouRunIt' )
	GUICtrlCreateLabel ( 'Select Game : ', 15, 156 )
	GUICtrlSetFont ( -1, 9, 800 )
	$_ComboBox = GUICtrlCreateCombo ( '', 95, 153, 310, -1, BitOR ( $GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST ) )
	GUICtrlSetOnEvent ( $_ComboBox, '_Read' )
	$_RandomSelect = Random ( 1, UBound ( $_ArrayGameTitle )-1, 1 )
	GUICtrlSetData ( $_ComboBox, $_ComboBoxItems, StringFormat ( '%03d', $_RandomSelect ) & ' - ' & $_ArrayGameTitle[$_RandomSelect] )
	$_TestButton = GUICtrlCreateButton ( 'Test your Computer', 15, 330, 390, 28 )
	GUICtrlSetOnEvent ( $_TestButton, '_Test' )
	GUICtrlSetFont ( -1, 14, 800 )
    $_Animated_Gif2 = _GuiCreateAnimatedGif ( $_Gui, $_PreLoaderPath, 150, 150, 1, 180, 1 )
	If Not @error Then _GuiCtrlAnimatedGif_SetPic ( $oGifArray[1], $_PreLoaderPath )
	GUICtrlSetState ( $_Animated_Gif2, $GUI_HIDE )
    $_Animated_Gif3 = _GuiCreateAnimatedGif ( $_Gui, $_PreLoaderPath, 150, 150, 270, 180, 1 )
	If Not @error Then _GuiCtrlAnimatedGif_SetPic ( $oGifArray[2], $_PreLoaderPath )
	GUICtrlSetState ( $_Animated_Gif3, $GUI_HIDE )
	_Read ( )
	SplashOff ( )
	GUISetState ( )
	WinActivate ( $_Gui )
	WinSetTrans ( $_Gui, '', 210 )
EndFunc ;==> _Gui ( )

Func _GuiCreateAnimatedGif ( $hwnd, $_GifPath, $_Width, $_Height, $_Left=0, $_Top=0, $_Glass=1 )
	GUISwitch ( $hwnd )
	If Not FileExists ( $_GifPath ) Then Return SetError ( 1 )
	If Not IsArray ( $oGifArray ) Then Dim $oGifArray[1]
	_ArrayAdd ( $oGifArray, ObjCreate ( "Gif89.Gif89.1" ) )
	If @error Then Return SetError ( 2 )
    $oGifCtrl = GUICtrlCreateObj ( $oGifArray[UBound ( $oGifArray ) -1], $_Left, $_Top, $_Width, $_Height )
	If Not $oGifCtrl Then Return SetError ( 3 )
	If $_Glass Then $oGifArray[UBound ( $oGifArray ) -1].glass = True
	Return $oGifCtrl
EndFunc ;==> _GuiCreateAnimatedGif ( )

Func _GuiCtrlAnimatedGif_SetPic ( $_GifObj, $_GifPath )
	If IsObj ( $_GifObj ) Then $_GifObj.filename = $_GifPath
EndFunc ;==> _GuiCtrlAnimatedGif_SetPic ( )

Func _InvertColor ( )
	$_Flash += 1
	If $_Flash > 6 Then
		$_Flash = 0
		AdlibUnRegister ( '_InvertColor' )
		GUISetBkColor ( 0xB5FFAD, $_Gui )
		Return
	EndIf
	$_Color = Not $_Color
	If $_Color Then
		Switch $_GraphFileName
			Case 'mf_2.gif'
				GUISetBkColor ( 0xFF0000, $_Gui )
			Case 'mp_rf_3.gif'
				GUISetBkColor ( 0xFEAD0A, $_Gui )
			Case 'mp_7.gif', 'mp_rp_7.gif'
				GUISetBkColor ( 0x1F98F8, $_Gui )
			Case Else ; 'm_r_unk.gif', 'mp_rp_of_6.gif'
				$_Flash = 0
				AdlibUnRegister ( '_InvertColor' )
		EndSwitch
	Else
		GUISetBkColor ( 0xB5FFAD, $_Gui )
	EndIf
EndFunc ;==> _InvertColor ( )
#EndRegion --- Gui Management ------------------------------

#Region ------ Update ------------------------------
Func _UpdateGamesList ( )
	_IEClickSound ( 0 )
	$_RegUpdateDate = RegRead ( $_RegKey, 'UpdateDate' )
	$_SplashTitle = ' Please Wait While Loading Games List...'
	SplashImageOn ( $_SplashTitle, $_LogoFilePath, 423, 100, Default, @DesktopHeight/4, 16+2 )
	WinWait ( $_SplashTitle, '' )
	WinActivate ( $_SplashTitle, '' )
    $oIE= _IECreate ( 'http://www.systemrequirementslab.com/CYRI/intro.aspx', 0, $_IEVisible, 0 )
	_IEWaitWhileBusy ( )
    $oArray = _IEGetObjById ( $oIE, 'ctl00_body_itemList' )
    Dim $_ArrayGameTitle[1], $_ArrayGameImage[1], $_ComboBoxItems
    For $element In $oArray
	    If $element.value <> 0 Then _ArrayAdd ( $_ArrayGameImage, $element.value )
	    If StringLen ( $element.text ) > 1 Then
	        _ArrayAdd ( $_ArrayGameTitle, $element.text )
	        $_ComboBoxItems = $_ComboBoxItems & StringFormat ( '%03d', UBound ( $_ArrayGameTitle ) -1 ) & ' - ' & $element.text & '|'
	    EndIf
    Next
	If Not $_RegUpdateDate Or _DateDiff ( 'd', $_RegUpdateDate, _NowCalc ( ) ) > 6 Then _CheckActiveXUpdate ( ) ; check for update each week.
EndFunc ;==> _UpdateGamesList ( )

Func _CheckActiveXUpdate ( )
	WinSetTitle ( $_SplashTitle, '', ' Please Wait While Checking Update for ActiveX...' )
    Local $_Instance
	$_TimerInit = TimerInit ( )
	AdlibRegister ( '_HangTime', 1000 )
	_IENavigate ( $oIE, 'http://www.systemrequirementslab.com/CYRI/intro.aspx#', 0 )
	_IEWaitWhileBusy ( )
    _IELinkClickByText ( $oIE, 'Troubleshooting', 0, 0 )
	_IEWaitWhileBusy ( )
	$_Ielist = WinList ( '[CLASS:IEFrame]' )
	For $_I = 1 To UBound ( $_Ielist ) -1
		If StringInStr ( $_Ielist[$_I][0], 'requirements' ) Then
			$_Instance = 0
			Do
				$_Instance =+ 1
				$oIE1 = _IEAttach ( $_Ielist[$_I][1], 'embedded', $_Instance )
			Until Not @error
			If IsObj ( $oIE1 ) Then
			    $oLinks = _IELinkGetCollection ( $oIE1 )
				For $oLink in $oLinks
					If StringInStr ( $oLink.innertext, 'download' ) Then
						$_DownloadLink = $oLink.href
						If StringInStr ( $_DownloadLink, 'SystemRequirementsLab' ) And _GetExtByFullPath ( $_DownloadLink ) = 'msi' Then ExitLoop 2
					EndIf
				Next
			EndIf
		EndIf
	Next
	AdlibUNRegister ( '_HangTime' )
    $_MsiFileName = _GetFullNameByUrl ( $_DownloadLink )
    $_MsiFileArray = _FileListToArray ( $_TempDir, '*.msi', 1 )
    If Not _AlreadyInArray ( $_MsiFileArray, $_MsiFileName ) Then
	    $_InetGet = InetGet ( $_DownloadLink, $_TempDir & '\' & $_MsiFileName, 9, 0 )
	    RunWait ( 'msiexec /i "' & $_TempDir & '\' & $_MsiFileName & '" /QN' )
		If Not @error And $_InetGet Then RegWrite ( $_RegKey, 'UpdateDate', 'REG_SZ', @YEAR & '/' & @MON & '/' & @MDAY )
		MsgBox ( 262144+4160, 'Success', 'ActiveX Updated !', 4, $_Gui )
    EndIf
EndFunc ;==> _CheckActiveXUpdate ( )
#EndRegion --- Update ------------------------------

#Region ------ Miscellaneous ------------------------------
Func _OpenCanYouRunIt ( )
    _OpenInDefaultBrowser ( 'http://www.systemrequirementslab.com/CYRI/intro.aspx#' )
EndFunc ;==> _OpenCanYouRunIt ( )

Func _GetDefaultBrowser ( )
    $_DefautBrowser = StringRegExp ( RegRead ( 'HKEY_CLASSES_ROOT\http\shell\open\command', '' ), '(?s)(?i)"(.*?)"', 3 )
    If Not @error Then Return $_DefautBrowser[0]
	Return 'iexplore.exe'
EndFunc ;==> _GetDefaultBrowser ( )

Func _OpenInDefaultBrowser ( $_Url )
	If FileExists ( $_DefaultBrowser ) Then
	    ShellExecute ( $_Url )
	Else
		ShellExecute ( 'iexplore.exe', $_Url )
	EndIf
EndFunc ;==> _OpenInDefaultBrowser ( )

Func _IEClickSound ( $_ClickSound=1 )
	If Not $_RegPreviousSound Then $_RegPreviousSound = RegRead ( $_RegKey, 'PreviousSound' )
	If Not $_RegPreviousSound Then
		$_RegPreviousSound = RegRead ( 'HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current', '' )
		RegWrite ( $_RegKey, 'PreviousSound', 'REG_EXPAND_SZ', $_RegPreviousSound )
	EndIf
    If $_ClickSound Then
        If $_RegPreviousSound Then RegWrite ( 'HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current', '', 'REG_EXPAND_SZ', $_RegPreviousSound )
    Else
		If $_RegPreviousSound Then RegWrite ( 'HKCU\AppEvents\Schemes\Apps\Explorer\Navigating\.Current', '', 'REG_EXPAND_SZ', 'Disable' )
    EndIf
EndFunc ;==> _IEClickSound ( )

Func _IEWaitWhileBusy ( )
	$_TimerInit = TimerInit ( )
    Do
        Sleep ( 500 )
    Until Not $oIE.Busy Or TimerDiff ( $_TimerInit ) > 6000 ; if IE Lag...
EndFunc ;==> _IEWaitWhileBusy ( )

Func _HangTime ( )
	$_TimerDiff = TimerDiff ( $_TimerInit )
	If $_TimerDiff > 20000 Then
		AdlibUnRegister ( '_HangTime' )
		MsgBox ( 262144+4160, 'Exiting on Error', 'Sorry, Script or IE Seems to be Hanging !', 5, $_Gui )
		Exit
	EndIf
EndFunc ;==> _HangTime ( )

Func __StringRepeat ( $_String=' ', $_NB=2 )
	Local $_StringReturn=''
    Do
        $_StringReturn &= $_String
    Until StringLen ( $_StringReturn ) = $_NB
    Return $_StringReturn
EndFunc ;==> __StringRepeat ( )

Func _GetFullNameByUrl ( $_FileUrl )
    $_FileName = StringSplit ( $_FileUrl, '/' )
    If Not @error Then Return $_FileName[$_FileName[0]]
EndFunc ;==> _GetFullNameByUrl ( )

Func _GetExtByFullPath ( $_FullPath )
	$_FileName = StringSplit ( $_FullPath, '.' )
	If Not @error Then Return $_FileName[$_FileName[0]]
EndFunc ;==> _GetExtByFullPath ( )

Func _GetFullNameByFullPath ( $_FullPath )
	$_FileName = StringSplit ( $_FullPath, '\' )
	If Not @error Then Return $_FileName[$_FileName[0]]
EndFunc ;==> _GetFullNameByFullPath ( )

Func _AlreadyInArray ( $_SearchArray, $_Item, $_Start=0, $_Partial=0 )
	$_Index = _ArraySearch ( $_SearchArray, $_Item, $_Start, 0, 0, $_Partial )
    If Not @error Then Return 1
EndFunc ;==> _AlreadyInArray ( )

Func _GetScriptVersion ( )
    If Not @Compiled Then
        Return StringTrimRight ( @ScriptName, 4 ) & ' © wakillon 2010 - ' & @YEAR
    Else
		Return StringTrimRight ( @ScriptName, 4 ) & ' v' & FileGetVersion ( @ScriptFullPath ) & ' © wakillon 2010 - ' & @YEAR
    EndIf
EndFunc ;==> _GetScriptVersion ( )

Func _IsConnected ( )
    If Ping ( 'www.bing.com' ) Or _
    InetGet ( 'http://www.google.com/humans.txt', @TempDir & '\TPCU\humans.txt', 1+2+8, 0 ) Then Return True
EndFunc ;==> _IsConnected ( )
#EndRegion --- Miscellaneous ------------------------------

#Region ------ Init ------------------------------
Func _FileMissing ( )
	If Not FileExists ( $_TempDir & '\Skin' )  Then Return True
	If Not FileExists ( $_LogoFilePath ) Then Return True
	If Not FileExists ( @WindowsDir & '\joystick.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\skin\PreLoader1.gif' ) Then Return True
	If Not FileExists ( @SystemDir & '\GIF89.DLL' ) Then Return True
EndFunc ;==> _FileMissing ( )

Func _FileInstall ( )
	ToolTip ( __StringRepeat ( ' ', 9 ) & 'Please Wait while downloading externals files' & @Crlf, @DesktopWidth/2-152, 0, $_Version, 1, 4 )
	Local $_DownloadUrl = 'http://tinyurl.com/d28w68l'
	If Not FileExists ( $_TempDir & '\Skin' ) Then DirCreate ( $_TempDir & '\Skin' )
	If Not FileExists ( $_LogoFilePath ) Then InetGet ( $_DownloadUrl & '/Logo3.BMP', $_LogoFilePath, 9, 0 )
	If Not FileExists ( @WindowsDir & '\joystick.ico' ) Then InetGet ( $_DownloadUrl & '/joystick.ico', @WindowsDir & '\joystick.ico', 9, 0 )
	If Not FileExists ( $_PreLoaderPath ) Then InetGet ( $_DownloadUrl & '/PreLoader1.gif', $_PreLoaderPath, 9, 0 )
	If Not FileExists ( @SystemDir & '\GIF89.DLL' ) Then
	    InetGet ( $_DownloadUrl & '/GIF89.DLL', @SystemDir & '\GIF89.DLL', 9, 0 )
	    RunWait ( @Systemdir & '\regsvr32.exe GIF89.DLL /s', '', @SW_HIDE )
    EndIf
	ToolTip ( '' )
	If FileExists ( @ProgramFilesDir & '\SystemRequirementsLab' ) Then Return
	; Allow ActiveX
    RegWrite ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{E6F480FC-BD44-4CBA-B74A-89AF7842937D}\iexplore', 'Type', 'REG_DWORD', 0x00000001 )
    RegWrite ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{E6F480FC-BD44-4CBA-B74A-89AF7842937D}\iexplore', 'Flags', 'REG_DWORD', 0x00000004 )
    RegWrite ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{E6F480FC-BD44-4CBA-B74A-89AF7842937D}\iexplore', 'Count', 'REG_DWORD', 0x00000002 )
    RegWrite ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{E6F480FC-BD44-4CBA-B74A-89AF7842937D}\iexplore', 'Blocked', 'REG_DWORD', 0x00000002 )
    RegWrite ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{E6F480FC-BD44-4CBA-B74A-89AF7842937D}\iexplore\AllowedDomains\systemrequirementslab.com' )
EndFunc ;==> _FileInstall ( )
#EndRegion --- Init ------------------------------

Func _Exit ( )
	$_MsgBox = MsgBox ( 262144+1, 'Confirm', 'Are you sure to Exit ?', 0, $_Gui )
	If $_MsgBox = 1 Then Exit
EndFunc ;==> _Exit ( )

Func _OnAutoItExit ( )
	Opt ( 'TrayIconHide', 0 )
	$_Split = StringSplit ( $_Version, '©' )
	If Not @error Then TrayTip ( $_Split[1], $_Split[2], 1, 1 )
	GUISetState ( @SW_HIDE, $_Gui )
	$oGifArray = 0
	_IEQuit ( $oIE )
	_IEClickSound ( 1 )
	Sleep ( 2000 )
	TrayTip ( '', '', 1, 1 )
EndFunc ;==> _OnAutoItExit ( )