#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Windows\music.ico
#AutoIt3Wrapper_Outfile=TinyMp3Player.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Tested on Xp 32bit and Seven 64 bit.
#AutoIt3Wrapper_Res_Description=TinyMp3Player Listen music like Jukebox.
#AutoIt3Wrapper_Res_Fileversion=1.0.1.7
;#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © wakillon 2010 - 2012
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#Include <APIConstants.au3>
#include <GuiConstantsEx.au3>
#Include <GuiToolTip.au3>
#include <GuiButton.au3>
#include <GuiSlider.au3>
#Include <WinAPIEx.au3>
#include <GDIPlus.au3>
#Include <String.au3>
#Include <Array.au3>
#Include <Math.au3>
#Include <Bass.au3>
#include <File.au3>
#Include <Date.au3>
#EndRegion ;************ Includes ************

Global $_Version = _GetScriptVersion ( ), $_File, $_Mp3Array, $_Mp3Dir, $Cmdline0, $_MainGuiHwnd

$Cmdline0 = $Cmdline[0]
$CmdlineRaw2 = $CmdlineRaw

#Region ------ Cmd line Part ------------------------------
If $Cmdline[0] <> 0 Then
	$CmdlineRaw2 = StringReplace ( $CmdlineRaw2, '"', '' )
	If Not _IsDirectory ( $CmdlineRaw2 ) Then
		$_Ext = _GetExtByFullPath ( $CmdlineRaw2 )
		Switch $_Ext
			Case 'mp3'
				Dim $_Mp3Array[2]
				$_Mp3Array[1] = $CmdlineRaw2
			Case 'm3u'
				Dim $_Mp3Array[1], $_FileRead
				_FileReadToArray ( $CmdlineRaw2, $_FileRead )
				$_M3uParentFolder = _GetParentFolderPathByFullPath ( $CmdlineRaw2 )
				For $_I = 1 To UBound ( $_FileRead ) -1
					If FileExists ( $_M3uParentFolder & '\' & $_FileRead[$_I] ) Then $_FileRead[$_I] = $_M3uParentFolder & '\' & $_FileRead[$_I]
					If FileExists ( $_FileRead[$_I] ) And _GetExtByFullPath ( $_FileRead[$_I] ) = 'mp3' Then _ArrayAdd ( $_Mp3Array, $_FileRead[$_I] )
				Next
				$_Mp3Array[0] = UBound ( $_Mp3Array ) -1
				If $_Mp3Array[0] = 0 Then Exit MsgBox ( 262144, 'Error', 'No mp3 files Found !', 5 )
		EndSwitch
	Else
		$_Mp3Dir = $CmdlineRaw2
		$_Mp3Array = _FileListToArray ( $_Mp3Dir, '*.mp3' )
		If @error Or UBound ( $_Mp3Array ) < 2 Then
			Exit MsgBox ( 262144, 'Error', 'No mp3 files Found !', 5 )
		Else
			For $_I = 1 To UBound ( $_Mp3Array ) -1
				$_Mp3Array[$_I] = $_Mp3Dir & '\' & $_Mp3Array[$_I]
			Next
			$_File = $_Mp3Array[1]
		EndIf
	EndIf
	If WinExists ( ' ' & $_Version ) Then
		; send message to existing occurence.
		$_MainGuiHwnd = WinGetHandle ( ' ' & $_Version )
		$_Mp3Array[0] = UBound ( $_Mp3Array ) -1
		$_Data = _ArrayToString ( $_Mp3Array, '|', 0 )
		_WM_SendData ( $_MainGuiHwnd, $_Data )
		Exit
	EndIf
EndIf
#EndRegion --- Cmd line Part ------------------------------

Opt ( 'GuiOnEventMode', 1 )
Opt ( 'GUICloseOnESC', 0 )
Opt ( 'TrayOnEventMode', 1 )
Opt ( 'TrayMenuMode', 1 )

#Region ------ Global Variables ------------------------------
Global $_ghBassDll = -1
Global $_gbBASSULONGLONGFIXED = _VersionCompare ( @AutoItVersion, '3.3.0.0' ) = 1
Global $BASS_DWORD_ERR = 2
Global $BASS_DLL_UDF_VER = '2.4.5.0'
Global $BASS_ERR_DLL_NO_EXIST = -1
GLOBAL $BASS_STARTUP_BYPASS_VERSIONCHECK = 0
Global $_ghBassEXTDll = -1
Global $tBASS_EXT_FILEPROCS = DllStructCreate ( 'ptr;ptr;ptr;ptr' )
Global $BASS_EXT_DspPeakProc = 0
Global $hGraphics, $hGfxBuffer, $hBmpBuffer, $hBmpBk, $hBrushFFT, $aFFT, $aPeak, $hContext
Global $_User32Dll = DllOpen ( 'user32.dll' ), $_SkinDll
Global $_Gui, $_ButtonWidht=80, $_ButtonHeight=18, $_GuiWidth=680, $_GuiHeight=250
Global $_LoadButton, $_PlayButton, $_StopButton, $_RandomCheckBox, $_NextButton, $_PreviousButton, $_BkPic
Global $_ScrollLabel, $_ScollLabelText, $_XScrollLabelPos=700, $_StringSize, $_TempDir = @TempDir & '\TMP'
Global $_Slider, $_VolSlider, $hWndVolSlider, $hWndSlider, $hWndToolTip, $_VolOld, $_DurationDisplay
Global $_Duration, $_Time, $_Time1Label, $_Time2Label, $_TimerInit = TimerInit ( )
Global $_AutoModeSelection=0, $_AudioMeterColor, $_AudioMeterColorOld, $_LineOrPoint, $_ColonneNb, $_ColonneNbOld, $_Play=1, $_Stop
Global $_MusicHandle, $iWidth=680, $iHeight=182, $_AlreadyListen[1], $_TopicItem
Global $_AddMenuItem, $_RemoveMenuItem, $_Timer = _NowCalc ( ), $_NowCalc, $_Load
Global $_RegKeySettings = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCU64\', 'HKCU\' ) & 'Software\TinyMp3Player'
#EndRegion --- Global Variables ------------------------------

#Region ------ Init ------------------------------
If _FileMissing ( ) Then _FileInstall ( )
_BASS_Startup ( @TempDir & '\TMP\bass.dll' )
_BASS_EXT_Startup ( @TempDir & '\TMP\bassExt.dll' )
_BASS_Init ( 0, -1, 44100, 0, '' )
_Gui ( )
_SetRandomConfig ( )
 AdlibRegister ( '_ScrollLabel', 30 )
 OnAutoItExitRegister ( '_OnAutoItExit' )
_SetScrollLabelText ( 0 )
_SetTrayMenu ( )
If $Cmdline0 <> 0 Then _Load ( )
#EndRegion --- Init ------------------------------

#Region ------ Main Loop ------------------------------
While 1
	If _EachXseconds ( 0.2 ) Then
		If $_MusicHandle <> '' Then
		    $_SliderPos = _GUICtrlSlider_GetPos ( $_Slider )
		    $_CURRENTPosition = _Bass_StreamGetFilePosition ( $_MusicHandle, $BASS_FILEPOS_CURRENT )
		    $_EndPosition = _Bass_StreamGetFilePosition ( $_MusicHandle, $BASS_FILEPOS_END )
		    $_PercentPosition =  100 * $_CURRENTPosition / $_EndPosition
		    If Not _IsPressed ( '01', $_User32Dll ) Then
		        _GUICtrlSlider_SetPos ( $_Slider, $_PercentPosition )
		    	If $_Duration Then
			        $_Time = $_Duration*$_PercentPosition/100
			        $_Time2 = StringFormat ( '%02d:%02d', Int ( $_Time / 60 ), $_Time - Int ( $_Time / 60 ) * 60 )
			        GUICtrlSetData ( $_Time1Label, $_Time2 )
			        $_Time3 = $_Duration-$_Time
			        $_Time3 = StringFormat ( '%02d:%02d', Int ( $_Time3 / 60 ), $_Time3 - Int ( $_Time3 / 60 ) * 60 )
			        GUICtrlSetData ( $_Time2Label, $_Time3 )
			    EndIf
		    EndIf
		    If GUICtrlRead ( $_RandomCheckBox ) = 1 Then
		    	GUICtrlSetState ( $_PreviousButton, $GUI_DISABLE )
		    Else
				If UBound ( $_Mp3Array ) -1 > 1 Then GUICtrlSetState ( $_PreviousButton, $GUI_ENABLE )
	    	EndIf
		    If $_CURRENTPosition = $_EndPosition Then
				$_RandomMode = GUICtrlRead ( $_RandomCheckBox )
				If $_RandomMode <> 1 And UBound ( $_Mp3Array ) -1 > 1 Then _ArrayAdd ( $_AlreadyListen, $_Mp3Array[$_AutoModeSelection] )
		    	If $_AutoModeSelection And UBound ( $_Mp3Array ) -1 > 1 Then ;And UBound ( $_AlreadyListen ) -1 <> UBound ( $_Mp3Array ) -1 Then
                    _Bass_ChannelStop ( $_MusicHandle )
		            $_AutoModeSelection = $_AutoModeSelection + 1
			    	If $_AutoModeSelection > UBound ( $_Mp3Array ) -1 Then $_AutoModeSelection = 1
				    If $_RandomMode =1 Then _GetRandomSelect ( )
			    	$_File = $_Mp3Array[$_AutoModeSelection]
					Sleep ( 1000 )
	                $_MusicHandle = _BASS_StreamCreateFile ( False, $_File, 0, 0, 0 )
					_SetVolume ( )
	                $aPeak = _BASS_EXT_ChannelSetMaxPeakDsp ( $_MusicHandle )
                    _BASS_ChannelPlay ( $_MusicHandle, True )
					_SetScrollLabelText ( 1 )
			    Else
				    $_MusicHandle = ''
	                _GUICtrlSlider_SetPos ( $_Slider, 0 )
			        GUICtrlSetState ( $_LoadButton, $GUI_ENABLE )
				    _SetScrollLabelText ( 0 )
			    	_GUICtrlButton_SetImage ( $_PlayButton, $_TempDir & '\Skin\Forward.ico', 0, True )
			    	$_Play = 1
			    	GUICtrlSetState ( $_BkPic, $GUI_SHOW )
			    	GUICtrlSetData ( $_Time1Label, '' )
			    	GUICtrlSetData ( $_Time2Label, '' )
			    EndIf
		    EndIf
		EndIf
		If $_Stop Then
			If $_Stop < 4 Then
				$_Stop=$_Stop+1
				If $_Stop=4 Then GUICtrlSetState ( $_BkPic, $GUI_SHOW )
			Else
			    $_Stop=0
			EndIf
		EndIf
	EndIf
	If _BASS_ChannelIsActive ( $_MusicHandle ) And $_MusicHandle <> '' Then
		_GDIPLus_GraphicsDrawImageRect ( $hGfxBuffer, $hBmpBk, 20, 20, 640, 157 )
		_DrawFFT ( )
		_GDIPlus_GraphicsDrawImage ( $hGraphics, $hBmpBuffer, 0, 0 )
		$_Vol = _BASS_ChannelGetAttribute ( $_MusicHandle, $BASS_ATTRIB_VOL )
		If $_Vol <> $_VolOld Then $_VolOld = $_Vol
	Else
		_GUICtrlSlider_SetPos ( $_Slider, 0 )
	EndIf
	$_NowCalc = _NowCalc ( )
	If _DateDiff ( 'n', $_Timer, $_NowCalc ) >= 3 Then  ; 3 min
		If @Compiled Then _ReduceMemory ( @AutoItPid )
		$_Timer = $_NowCalc
	EndIf
	If $_Load = 1 Then
		$_Load = 0
		_Load ( )
	EndIf
	Sleep ( 10 )
WEnd
#EndRegion --- Main Loop ------------------------------

Func _Load ( )
	Redim $_AlreadyListen[1]
	WinActivate ( $_Gui )
	If $Cmdline0 <> 0 Then
		$Cmdline0 = 0
		If Not IsArray ( $_Mp3Array ) Then
			MsgBox ( 262144, 'Error', 'No mp3 files Found !', 3 )
			$_AutoModeSelection = 0
			Return
		Else
			If UBound ( $_Mp3Array ) -1 = 1 Then
				GUICtrlSetState ( $_NextButton, $GUI_DISABLE )
				GUICtrlSetState ( $_PreviousButton, $GUI_DISABLE )
				$_File = $_Mp3Array[1]
			Else
				GUICtrlSetState ( $_NextButton, $GUI_ENABLE )
				;GUICtrlSetState ( $_PreviousButton, $GUI_ENABLE )
			EndIf
			$_AutoModeSelection = 1
			$_RandomMode = GUICtrlRead ( $_RandomCheckBox )
			$_File = $_Mp3Array[1]
		EndIf
	Else
		If _IsPressed ( '10', $_User32Dll ) Then ; Left SHIFT key
			GUICtrlSetState ( $_RandomCheckBox, $GUI_ENABLE )
			$_LastDir = RegRead ( $_RegKeySettings, 'LastDir' )
			If Not FileExists ( $_LastDir ) Then $_LastDir = ''
			$_Mp3Dir = FileSelectFolder ( 'Select Mp3 directory', '', 2, $_LastDir, $_Gui )
			If Not @error Then
				$_Mp3Array = _FileListToArray ( $_Mp3Dir, '*.mp3' )
				If @error Then
					MsgBox ( 262144, 'Error', 'No mp3 files Found !', 5 )
					$_AutoModeSelection = 0
					Return
				Else
					For $_I = 1 To UBound ( $_Mp3Array ) -1
						$_Mp3Array[$_I] = $_Mp3Dir & '\' & $_Mp3Array[$_I]
					Next
					GUICtrlSetState ( $_NextButton, $GUI_ENABLE )
					$_AutoModeSelection=1
					$_RandomMode = GUICtrlRead ( $_RandomCheckBox )
					$_File = $_Mp3Array[1]
				EndIf
				If FileExists ( $_Mp3Dir ) Then RegWrite ( $_RegKeySettings, 'LastDir', 'REG_SZ', $_Mp3Dir )
			EndIf
		Else
			GUICtrlSetState ( $_RandomCheckBox, $GUI_UNCHECKED )
			GUICtrlSetState ( $_RandomCheckBox, $GUI_DISABLE )
			$_File = FileOpenDialog ( 'Open...', '', 'MP3 Files (*.mp3)' )
			If Not @error And FileExists ( $_File ) Then $_AutoModeSelection=0
			$_Mp3Array = ''
		EndIf
	EndIf
	$_Stop=0
	_Play ( )
EndFunc	;==> _Load ( )

Func _Play ( )
	$_Stop=0
	If $_Play = 1 Then
		If _BASS_ChannelIsActive ( $_MusicHandle ) Then
			_BASS_ChannelPlay ( $_MusicHandle, False )
		Else
			$_RandomMode = GUICtrlRead ( $_RandomCheckBox )
			If $_RandomMode =1 Then _GetRandomSelect ( )
			If StringInStr ( $_File, '.mp3' ) = 0 Then Return
			If FileExists ( $_File ) Then
	        	_SetRandomConfig ( )
			    $_MusicHandle = _BASS_StreamCreateFile ( False, $_File, 0, 0, 0 )
				_SetVolume ( )
				RegWrite ( $_RegKeySettings, 'LastVolume', 'REG_SZ', GUICtrlRead ( $_VolSlider ) / 100 )

			    $aPeak = _BASS_EXT_ChannelSetMaxPeakDsp ( $_MusicHandle )
			    _GetAudioDuration ( $_File )
			    _BASS_ChannelPlay ( $_MusicHandle, True )
				Sleep ( 500 )
				GUICtrlSetState ( $_BkPic, $GUI_HIDE )
			EndIf
		EndIf
		$_Play = 0
		_GUICtrlButton_SetImage ( $_PlayButton, $_TempDir & '\Skin\pause.ico', 0, True )
	Else
		_GUICtrlButton_SetImage ( $_PlayButton, $_TempDir & '\Skin\Forward.ico', 0, True )
		_Bass_ChannelPause ( $_MusicHandle )
		$_Play = 1
	EndIf
    GUICtrlSetState ( $_LoadButton, $GUI_DISABLE )
	_SetScrollLabelText ( 1 )
	If $_Duration Then
		GUICtrlSetState ( $_Time1Label, $GUI_ENABLE )
		GUICtrlSetState ( $_Time2Label, $GUI_ENABLE )
	EndIf
	$_Vol = _BASS_ChannelGetAttribute ( $_MusicHandle, $BASS_ATTRIB_VOL )
EndFunc	;==> _Play ( )

Func _Stop ( )
	If $_MusicHandle <> '' Then
		$_Length= _BASS_ChannelGetLength ( $_MusicHandle, $BASS_POS_BYTE )
		_BASS_ChannelSetPosition ( $_MusicHandle, $_Length, $BASS_POS_BYTE )
		_Bass_ChannelStop ( $_MusicHandle )
		$_MusicHandle = ''
		_GUICtrlButton_SetImage ( $_PlayButton, $_TempDir & '\Skin\Forward.ico', 0, True )
		$_Play = 1
		GUICtrlSetState ( $_LoadButton, $GUI_ENABLE )
		GUICtrlSetState ( $_PreviousButton, $GUI_ENABLE )
		GUICtrlSetState ( $_RandomCheckBox, $GUI_ENABLE )
		_GUICtrlSlider_SetPos ( $_Slider, 0 )
		_SetScrollLabelText ( 0 )
		GUICtrlSetData ( $_Time1Label, '' )
		GUICtrlSetData ( $_Time2Label, '' )
		GUICtrlSetState ( $_BkPic, $GUI_SHOW )
		$_Stop = 1
	EndIf
EndFunc	;==> _Stop ( )

Func _Next ( )
	If $_AutoModeSelection And $_Play = 0 Then
        _Bass_ChannelStop ( $_MusicHandle )
		$_AutoModeSelection = $_AutoModeSelection+1
		If $_AutoModeSelection > UBound ( $_Mp3Array ) -1 Then $_AutoModeSelection = 1
		$_AutoModeSelection = _Min ( $_AutoModeSelection, UBound ( $_Mp3Array ) -1 )
		$_RandomMode = GUICtrlRead ( $_RandomCheckBox )
		$_File = $_Mp3Array[$_AutoModeSelection]
		If $_RandomMode = 1 Then _GetRandomSelect ( )
		If FileExists ( $_File ) Then
		    _GetAudioDuration ( $_File )
	        $_MusicHandle = _BASS_StreamCreateFile ( False, $_File, 0, 0, 0 )
			_SetVolume ( )
	        $aPeak = _BASS_EXT_ChannelSetMaxPeakDsp ( $_MusicHandle )
            _BASS_ChannelPlay ( $_MusicHandle, True )
		    _SetScrollLabelText ( 1 )
		    _GUICtrlButton_SetImage ( $_PlayButton, $_TempDir & '\Skin\pause.ico', 0, True )
		    GUICtrlSetState ( $_BkPic, $GUI_HIDE )
		EndIf
	EndIf
	_SetRandomConfig ( )
	$hBrushFFT = _BrushCreateFFT ( 20, 20, 640, 155, $iWidth, $iHeight, $hGraphics )
EndFunc ;==> _Next ( )

Func _Previous ( )
	If $_AutoModeSelection And $_Play = 0 Then
        _Bass_ChannelStop ( $_MusicHandle )
		$_AutoModeSelection = $_AutoModeSelection-1
		$_AutoModeSelection = _Min ( _Max ( $_AutoModeSelection, 1 ), UBound ( $_Mp3Array ) -1 )
	    $_File = $_Mp3Array[$_AutoModeSelection]
		_GetAudioDuration ( $_File )
	    $_MusicHandle = _BASS_StreamCreateFile ( False, $_File, 0, 0, 0 )
		_SetVolume ( )
	    $aPeak = _BASS_EXT_ChannelSetMaxPeakDsp ( $_MusicHandle )
        _BASS_ChannelPlay ( $_MusicHandle, True )
		_SetScrollLabelText ( 1 )
		_GUICtrlButton_SetImage ( $_PlayButton, $_TempDir & '\Skin\pause.ico', 0, True )
		GUICtrlSetState ( $_BkPic, $GUI_HIDE )
	EndIf
	_SetRandomConfig ( )
	$hBrushFFT = _BrushCreateFFT ( 20, 20, 640, 155, $iWidth, $iHeight, $hGraphics )
EndFunc ;==> _Previous ( )

Func _GetRandomSelect ( )
	If Not IsArray ( $_Mp3Array ) Then Return
	If UBound ( $_AlreadyListen ) = UBound ( $_Mp3Array ) Then Redim $_AlreadyListen[1]
	If UBound ( $_Mp3Array ) -1 > 1 Then
		Do
			$_AutoModeSelection = Random ( 1, UBound ( $_Mp3Array ) -1, 1 )
		Until Not _AlreadyInArray ( $_AlreadyListen, $_Mp3Array[$_AutoModeSelection] )
		_ArrayAdd ( $_AlreadyListen, $_Mp3Array[$_AutoModeSelection] )
	Else
		$_AutoModeSelection = 1
		_ArrayAdd ( $_AlreadyListen, $_Mp3Array[$_AutoModeSelection] )
	EndIf
	$_File = $_Mp3Array[$_AutoModeSelection]
EndFunc ;==> _GetRandomSelect ( )

Func _AlreadyInArray ( $_SearchArray, $_Item, $_Start=0, $_Partial=0 )
	_ArraySearch ( $_SearchArray, $_Item, $_Start, 0, 0, $_Partial )
    If Not @error Then Return 1
EndFunc ;==> _AlreadyInArray ( )

Func _EachXseconds ( $_Interval )
	$_TimerDiff = Round ( TimerDiff ( $_TimerInit )/ 1000 )
	If $_TimerDiff >= $_Interval Then
		$_TimerInit = TimerInit ( )
	    Return 1
	EndIf
EndFunc	;==> _EachXseconds ( )

#Region ------ Messages  Management ------------------------------
Func _WM_NOTIFY ( $hWnd, $iMsg, $wParam, $lParam )
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndSlider=$_Slider
    $tNMHDR = DllStructCreate ( $tagNMHDR, $lParam )
    $hWndFrom = HWnd ( DllStructGetData ( $tNMHDR, 'hWndFrom' ) )
    $iIDFrom = DllStructGetData ( $tNMHDR, 'IDFrom' )
    $iCode = DllStructGetData ( $tNMHDR, 'Code' )
    Switch $hWndFrom
        Case $hWndSlider
            Switch $iCode
                Case $NM_RELEASEDCAPTURE
                    If $_MusicHandle <> '' Then
					    _GDIPlus_GraphicsDrawImage ( $hGraphics, $hBmpBuffer, 0, 0 )
					    $_SliderPos = _GUICtrlSlider_GetPos ( $_Slider )
					    $_Length= _BASS_ChannelGetLength ( $_MusicHandle, $BASS_POS_BYTE )
						$_Pos = ( $_SliderPos * $_Length ) / 100
					   _BASS_ChannelSetPosition ( $_MusicHandle, $_Pos, $BASS_POS_BYTE )
					EndIf
			EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_NOTIFY ( )

Func _WM_HSCROLL ( $hWnd, $iMsg, $wParam, $lParam )
	Switch $iMsg
		Case $WM_HSCROLL, $WM_VSCROLL
			Switch $lParam
				Case $hWndVolSlider
					If $_MusicHandle <> '' Then _SetVolume ( )
                    _GUIToolTip_SetTitle ( $hWndToolTip, 'Volume : ', 1 )
				Case $hWndSlider
					If $_MusicHandle <> '' Then
						$_SliderPos = _GUICtrlSlider_GetPos ( $_Slider )
						$_Length= _BASS_ChannelGetLength ( $_MusicHandle, $BASS_POS_BYTE )
						$_Pos = ( $_SliderPos * $_Length ) / 100
						_BASS_ChannelSetPosition ( $_MusicHandle, $_Pos, $BASS_POS_BYTE )
					EndIf
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_HSCROLL ( )

Func _WM_PAINT ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $_Gui
			_WinAPI_RedrawWindow ( $_Gui, 0, 0, $RDW_UPDATENOW )
			_WinAPI_RedrawWindow ( $_Gui, 0, 0, $RDW_VALIDATE )
	EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_PAINT ( )

Func _WM_ReceivedData ( $hWnd, $msgID, $wParam, $lParam )
	Switch $hWnd
		Case $_Gui
			Local $tCOPYDATA = DllStructCreate ( 'ulong_ptr;dword;ptr', $lParam )
			Local $tMsg = DllStructCreate ( 'char[' & DllStructGetData ( $tCOPYDATA, 2 ) & ']', DllStructGetData ( $tCOPYDATA, 3 ) )
			$_MsgFromSearch = DllStructGetData ( $tMsg, 1 )
			$_Datas = StringSplit ( $_MsgFromSearch, '|', 2 )
			$_Mp3Array = $_Datas
			$_Mp3Array[0] = UBound ( $_Datas ) -1
			_Stop ( )
			$Cmdline0 = 1
			$_Load = 1
			Return $GUI_RUNDEFMSG
	EndSwitch
EndFunc ;==> _WM_ReceivedData ( )

Func _WM_SendData ( $hWnd, $sData )
	Local $tCOPYDATA, $tMsg, $Ret
	$tMsg = DllStructCreate ( 'char[' & StringLen ( $sData ) + 1 & ']' )
	DllStructSetData ( $tMsg, 1, $sData )
	$tCOPYDATA = DllStructCreate ( 'ulong_ptr;dword;ptr' )
	DllStructSetData ( $tCOPYDATA, 2, StringLen ( $sData ) + 1 )
	DllStructSetData ( $tCOPYDATA, 3, DllStructGetPtr ( $tMsg ) )
	While 1
		$_Ret = DllCall ( 'user32.dll', 'int', 'IsHungAppWindow', 'hwnd', $_MainGuiHwnd )
		If Not @error And Not $_Ret[0] Then ExitLoop
		Sleep ( 100 )
	WEnd
	$Ret = DllCall ( 'user32.dll', 'lparam', 'SendMessageTimeout', 'hwnd', $hWnd, 'int', $WM_COPYDATA, 'wparam', 0, 'lparam', DllStructGetPtr ( $tCOPYDATA ), 'uint', BitOR ( $SMTO_ABORTIFHUNG, $SMTO_NOTIMEOUTIFNOTHUNG ), 'uint', 1000, 'dword_ptr*', 0 ) ; ok
	If @error Or $Ret[0] = -1 Then Return 0
	Return 1
EndFunc ;==> _WM_SendData ( )
#EndRegion --- Messages  Management ------------------------------

Func _DrawFFT ( )
	_BASS_EXT_ChannelGetFFT ( $_MusicHandle, $aFFT, 6 )
	If Not @error Then DllCall ( $ghGDIPDll, 'int', 'GdipFillPolygonI', 'handle', $hGfxBuffer, 'handle', $hBrushFFT, 'ptr', $aFFT[0], 'int', $aFFT[1], 'int', 'FillModeAlternate' )
EndFunc ;==> _DrawFFT ( )

Func _BMPCreateBackGround ( $iW, $iH, $hGraphics )
	Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics ( $iW, $iH, $hGraphics )
	Local $hContext = _GDIPlus_ImageGetGraphicsContext ( $hBitmap )
	_GDIPlus_GraphicsSetSmoothingMode ( $hContext, 2 )
	_GDIPlus_GraphicsClear ( $hContext, 0xFF000000 )
	Return $hBitmap
EndFunc ;==> _BMPCreateBackGround ( )

Func _BrushCreateFFT ( $iX, $iY, $iW, $iH, $iWidth, $iHeight, $hGraphics )
	Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics ( $iWidth, $iHeight, $hGraphics )
	Local $hContext = _GDIPlus_ImageGetGraphicsContext ( $hBitmap )
	_GDIPlus_GraphicsClear ( $hContext, 0xFF000000 )
	Local $hBrush[5]
	$hBrush[0] = _GDIPlus_BrushCreateSolid ( 0xFFFF0000 )
	$hBrush[1] = _GDIPlus_LineBrushCreate ( 0, 0, 0, 20, 0xFFFF0000, 0xFFFFC900, 1 )
	$hBrush[2] = _GDIPlus_LineBrushCreate ( 0, 20, 0, 40, 0xFFFFC900, $_AudioMeterColor, 1 )
	$hBrush[3] = _GDIPlus_BrushCreateSolid ( $_AudioMeterColor )
	If $_LineOrPoint Then $hBrush[4] = _GDIPlus_LineBrushCreate ( 0, 0, 0, 4, 0x00000000, 0xAA000000, 0 )
	_GDIPlus_GraphicsFillRect ( $hContext, $iX, $iY, $iW, 20, $hBrush[0] )
	_GDIPlus_GraphicsFillRect ( $hContext, $iX, $iY + 20, $iW, 20, $hBrush[1] )
	_GDIPlus_GraphicsFillRect ( $hContext, $iX, $iY + 40, $iW, 20, $hBrush[2] )
	_GDIPlus_GraphicsFillRect ( $hContext, $iX, $iY + 60, $iW, $iH - 60, $hBrush[3] )
	If $_LineOrPoint Then _GDIPlus_GraphicsFillRect ( $hContext, $iX, $iY, $iW, $iH, $hBrush[4] )
	For $i = 0 To 4
		_GDIPlus_BrushDispose ( $hBrush[$i] )
	Next
	_GDIPlus_GraphicsDispose ( $hContext )
	Local $aRet = DllCall ( $ghGDIPDll, 'uint', 'GdipCreateTexture', 'hwnd', $hBitmap, 'int', 0, 'int*', 0 )
	_GDIPlus_BitmapDispose ( $hBitmap )
	Return $aRet[3]
EndFunc ;==> _BrushCreateFFT ( )

Func _GDIPlus_LineBrushCreate ( $nX1, $nY1, $nX2, $nY2, $iARGBClr1, $iARGBClr2, $iWrapMode = 0 )
	Local $tPointF1, $pPointF1, $tPointF2, $pPointF2, $aResult
	$tPointF1 = DllStructCreate ( 'float;float' )
	$pPointF1 = DllStructGetPtr ( $tPointF1 )
	$tPointF2 = DllStructCreate ( 'float;float' )
	$pPointF2 = DllStructGetPtr ( $tPointF2 )
	DllStructSetData ( $tPointF1, 1, $nX1 )
	DllStructSetData ( $tPointF1, 2, $nY1 )
	DllStructSetData ( $tPointF2, 1, $nX2 )
	DllStructSetData ( $tPointF2, 2, $nY2 )
	$aResult = DllCall ( $ghGDIPDll, 'uint', 'GdipCreateLineBrush', 'ptr', $pPointF1, 'ptr', $pPointF2, 'uint', $iARGBClr1, 'uint', $iARGBClr2, 'int', $iWrapMode, 'int*', 0 )
	If @error Then Return SetError ( @error, @extended, 0 )
	Return $aResult[6]
EndFunc ;==> _GDIPlus_LineBrushCreate ( )

Func _SetRandomConfig ( )
	;  0xFFFF0000 = red  0xFFFFFF00 = yellow  0xFF00FF00 = green  0xFFFF9E29 = orange 0xFF00AAFF = blue
    Local $_RndArray[6] = [5, 0xFFFF0000, 0xFFFFFF00, 0xFF00FF00, 0xFFFF9E29, 0xFF00AAFF]
	Do
		$_AudioMeterColor = $_RndArray[Random ( 1, UBound ( $_RndArray ) -1, 1 )]
	Until $_AudioMeterColor <> $_AudioMeterColorOld
	$_LineOrPoint = Random ( 0, 1, 1 )
	Local $_RndArray[8] = [7, 30, 40, 60, 80, 100, 120, 140]
	Do
		$_ColonneNb = $_RndArray[Random ( 1, UBound ( $_RndArray ) -1, 1 )]
	Until $_ColonneNb <> $_ColonneNbOld
	ConsoleWrite ( '-->-- [' & @ScriptLineNumber & '][' & @HOUR & @MIN & @SEC & '] $_ColonneNb : ' & $_ColonneNb & @Crlf )
	If $hBrushFFT Then _GDIPlus_BrushDispose ( $hBrushFFT )
	If $hBmpBk Then _GDIPlus_BitmapDispose ( $hBmpBk )
	If $hGfxBuffer Then _GDIPlus_GraphicsDispose ( $hGfxBuffer )
	If $hBmpBuffer Then _GDIPlus_BitmapDispose ( $hBmpBuffer )
	If $hGraphics Then _GDIPlus_GraphicsDispose ( $hGraphics )
	$hBrushFFT = 0
	$hBmpBk = 0
	$hGfxBuffer = 0
	$hBmpBuffer = 0
	$hGraphics = 0
	$hGraphics = _GDIPlus_GraphicsCreateFromHWND ( $_Gui )
	$hBmpBuffer = _GDIPlus_BitmapCreateFromGraphics ( $iWidth, $iHeight, $hGraphics )
	$hGfxBuffer = _GDIPlus_ImageGetGraphicsContext ( $hBmpBuffer )
	_GDIPlus_GraphicsSetSmoothingMode ( $hGfxBuffer, 2 )
	$hBrushFFT = _BrushCreateFFT ( 20, 20, 640, 155, $iWidth, $iHeight, $hGraphics )
	$aFFT = _BASS_EXT_CreateFFT ( $_ColonneNb, 20, 20, 640, 155, 2, 60, True )
	$hBmpBk = _BMPCreateBackGround ( $iWidth, $iHeight, $hGraphics )
	$_ColonneNbOld = $_ColonneNb
	$_AudioMeterColorOld = $_AudioMeterColor
	If @Compiled Then _ReduceMemory ( @AutoItPid )
	$_Timer = $_NowCalc
EndFunc ;==> _SetRandomConfig ( )

Func _SkinGui ( $_Hwnd, $_SkinDllPath, $_SkinFilePath )
	$_SkinDll = DllOpen ( $_SkinDllPath )
	DllCall ( $_SkinDll, 'int:cdecl', 'InitLicenKeys', 'wstr', 'SKINCRAFTER', 'wstr', 'SKINCRAFTER.COM', 'wstr', 'support@skincrafter.com', 'wstr', 'DEMOSKINCRAFTERLICENCE' )
	DllCall ( $_SkinDll, 'int:cdecl', 'InitDecoration', 'int', 1 )
	DllCall ( $_SkinDll, 'int:cdecl', 'LoadSkinFromFile', 'wstr', $_SkinFilePath )
	DllCall ( $_SkinDll, 'int:cdecl', 'DecorateAs', 'int', $_Hwnd, 'int', 25 )
	DllCall ( $_SkinDll, 'int:cdecl', 'ApplySkin' )
EndFunc ;==> _SkinGui ( )

Func _Gui ( )
	$_Gui = GUICreate ( ' ' & $_Version, $_GuiWidth, $_GuiHeight, -1, @DesktopHeight - _GetTaskbarHeight ( ) -70 -$_GuiHeight, -1, $WS_EX_APPWINDOW )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_Exit' )
	GUISetIcon ( @WindowsDir & '\music.ico' )

	$_LoadButton = GUICtrlCreateButton ( '', 20, 210, $_ButtonWidht, $_ButtonHeight, $BS_ICON )
	_GUICtrlButton_SetImage ( -1, @WindowsDir & '\music.ico', 0, True )
	GUICtrlSetOnEvent ( -1, '_Load' )
	GUICtrlSetTip ( -1, 'Load a mp3 file' & @CRLF & 'Or Hold Left SHIFT key and Click' & @CRLF & 'for Select a mp3 directory' )
	$_PlayButton = GUICtrlCreateButton ( '', 120, 210, $_ButtonWidht, $_ButtonHeight, $BS_ICON )
	_GUICtrlButton_SetImage ( -1, $_TempDir & '\Skin\Forward.ico', 0, True )
	GUICtrlSetOnEvent ( -1, '_Play' )
	GUICtrlSetTip ( -1, 'Play Mp3' )
	$_StopButton = GUICtrlCreateButton ( '', 220, 210, $_ButtonWidht, $_ButtonHeight, $BS_ICON )
	_GUICtrlButton_SetImage ( -1, $_TempDir & '\Skin\stop.ico', 0, True )
	GUICtrlSetOnEvent ( -1, '_Stop' )
	GUICtrlSetTip ( -1, 'Stop Playing' )
	$_PreviousButton = GUICtrlCreateButton ( '', 320, 210, $_ButtonWidht, $_ButtonHeight, $BS_ICON )
	_GUICtrlButton_SetImage ( -1, $_TempDir & '\Skin\Backward_01.ico', 0, True )
	GUICtrlSetOnEvent ( -1, '_Previous' )
	GUICtrlSetTip ( -1, 'Play the Previous mp3' )
	$_NextButton = GUICtrlCreateButton ( '', 420, 210, $_ButtonWidht, $_ButtonHeight, $BS_ICON )
	_GUICtrlButton_SetImage ( -1, $_TempDir & '\Skin\Forward_01.ico', 0, True )
	GUICtrlSetOnEvent ( -1, '_Next' )
	GUICtrlSetTip ( -1, 'Play the Next mp3' )
	;If StringInStr ( @OsVersion, 'WIN_XP' ) Then
		_SkinGui ( $_Gui, $_TempDir & '\skin\SkinCrafterDll.dll', $_TempDir & '\skin\Machine_gun.skf' )
		; Escalate.skf, Ultraviolet.skf, Strange.skf, Deka.skf, Konel.skf, X-skin.skf, Yello.skf, Accent.skf, Machine_gun.skf, Blaster_ST.skf
	;EndIf
	$_Slider = GUICtrlCreateSlider ( 75, 182, 535, 20, $TBS_NOTICKS )
	$hWndSlider = GUICtrlGetHandle ( $_Slider )
	$_ScrollLabel = GUICtrlCreateLabel ( $_Version, 700, 235, 630, 20 )
	GUICtrlSetFont ( -1, 10, 800, 2, 'verdana' )
	$_Time1Label = GUICtrlCreateLabel ( '', 30, 182, 40, 20 )
	GUICtrlSetFont ( -1, 10, 800, 0 )
	$_Time2Label = GUICtrlCreateLabel ( '', 615, 182, 40, 20 )
	GUICtrlSetFont ( -1, 10, 800, 0 )

	$_LastVolume = RegRead ( $_RegKeySettings, 'LastVolume' ) * 100
	If $_LastVolume = 0 Then $_LastVolume = 100
	$_VolSlider = GUICtrlCreateSlider ( 510, 210, 80, 20, BitOr ( $TBS_NOTICKS, $TBS_TOOLTIPS  ) )
	GUICtrlSetData ( -1, $_LastVolume )
	GUICtrlSetOnEvent ( -1, '_SetVolume' )
	GUICtrlSetTip ( -1, 'Adjust Volume' )
	$hWndVolSlider = GUICtrlGetHandle ( $_VolSlider )
	$hWndToolTip = _GUICtrlSlider_GetToolTips ( $hWndVolSlider )
	_GUIToolTip_SetTitle ( $hWndToolTip, 'Volume : ', 1 )
	$_RandomMode = RegRead ( $_RegKeySettings, 'RandomMode' )
	$_RandomCheckBox = GUICtrlCreateCheckbox ( 'Random', 600, 208, -1, -1, BitOR ( $BS_AUTOCHECKBOX, $BS_RIGHTBUTTON ) )
	GUICtrlSetTip ( -1, 'Play Mp3 in random Order' )
	If $_RandomMode = 'True' Then GUICtrlSetState ( -1, $GUI_CHECKED )
	$_BkPic = GUICtrlCreatePic ( $_TempDir & '\Skin\Bk6.jpg', 0, 0, 680, 182 )
	GUIRegisterMsg ( $WM_NOTIFY, '_WM_NOTIFY' )
	GUIRegisterMsg ( $WM_HSCROLL, '_WM_HSCROLL' )
	GUIRegisterMsg ( $WM_COPYDATA, '_WM_ReceivedData' )
	GUIRegisterMsg ( $WM_PAINT, '_WM_PAINT' )
	GUIRegisterMsg ( $WM_NCPAINT, '_WM_PAINT' )
	_GDIPlus_Startup ( )
	_GUISetState ( )
EndFunc ;==> _Gui ( )

Func _GUISetState ( )
	GUISetState ( @SW_SHOW, $_Gui )
	$_ProcessWindows = _WinAPI_EnumProcessWindows ( @AutoItPID )
	For $_I = 1 To UBound ( $_ProcessWindows ) -1
		If $_ProcessWindows[$_I][1] = '#32770' Then
			WinKill ( $_ProcessWindows[$_I][0] )
			ExitLoop
		EndIf
	Next
EndFunc ;==> _GUISetState ( )

Func _SetVolume ( )
    _BASS_ChannelSetAttribute ( $_MusicHandle, $BASS_ATTRIB_VOL, GUICtrlRead ( $_VolSlider ) / 100 )
EndFunc   ;==>_Vol

Func _GetTaskbarHeight ( )
	Local Const $SPI_GETWORKAREA = 48
	Local $WorkArea, $stRect = DllStructCreate ( 'long left;long top;long right;long bottom' )
	Local $iResult = _WinAPI_SystemParametersInfo ( $SPI_GETWORKAREA, 0, DllStructGetPtr ( $stRect ), 0 )
	If $iResult = True Then
		$WorkArea = DllStructGetData ( $stRect, 'bottom' ) - DllStructGetData ( $stRect, 'top' )
		If Not @error Then Return @DesktopHeight - $WorkArea
	EndIf
EndFunc ;==> _GetTaskbarHeight ( )

Func _IsMinimized ( $_Hwnd )
    If BitAnd ( WinGetState ( $_Hwnd ), 16 ) Then Return 1
EndFunc ;==> _IsMinimized ( )

Func _ScrollLabel ( )
    If $_XScrollLabelPos <= -$_StringSize Then $_XScrollLabelPos = $_GuiWidth
	If Not _IsMinimized ( $_Gui ) Then
		GUICtrlSetPos ( $_ScrollLabel, $_XScrollLabelPos, $_GuiHeight-15 )
		$_XScrollLabelPos -= 1
	EndIf
EndFunc ;==> _ScrollLabel ( )

Func _SetScrollLabelText ( $_Choice )
	If $_Choice Then
		Local $_Selection = ''
		If $_AutoModeSelection Then $_Selection = '[' & $_AutoModeSelection & '/' & UBound ( $_Mp3Array ) -1 & ']'
		$_Name = _GetNameWithoutExtByFullPath ( $_File )
		If $_Name Then $_ScollLabelText = $_Selection & ' ' & $_Name & ' [' & $_DurationDisplay & ']'
	Else
		$_ScollLabelText = $_Version
	EndIf
	GUICtrlSetData ( $_ScrollLabel, $_ScollLabelText )
	$aSize = _StringSize ( $_ScollLabelText, 10, 800, 2, 'Verdana' )
	$_StringSize = $aSize[2]
EndFunc ;==> _SetScrollLabelText ( )

Func _GetAudioDuration ( $_MediaFilePath )
    $_MediaInfoDll = DllOpen ( $_TempDir & '\MediaInfo.dll' )
    $_Handle = DllCall ( $_MediaInfoDll, 'ptr', 'MediaInfo_New' )
    DllCall ( $_MediaInfoDll, 'int', 'MediaInfo_Open', 'ptr', $_Handle[0], 'wstr', $_MediaFilePath )
    DllCall ( $_MediaInfoDll, 'wstr', 'MediaInfo_Option', 'ptr', 0, 'wstr', 'Inform', 'wstr', 'Audio;%Duration%' )
    $_Inform = DllCall ( $_MediaInfoDll, 'wstr', 'MediaInfo_Inform', 'ptr', $_Handle[0], 'int', 0 )
	$_Duration = Round ( $_Inform[0]/1000 )
    If $_Duration = 0 Then
        DllCall ( $_MediaInfoDll, 'wstr', 'MediaInfo_Option', 'ptr', 0, 'wstr', 'Inform', 'wstr', 'Audio;%BitRate%' )
        $_Inform = DllCall ( $_MediaInfoDll, 'wstr', 'MediaInfo_Inform', 'ptr', $_Handle[0], 'int', 0 )
	    $_Bitrate = Number ( $_Inform[0] )
        If $_Bitrate <> 0 Then
	        $_FileSize = FileGetSize ( $_MediaFilePath )
	        $_Duration = Round ( $_FileSize*8/$_Bitrate )
		EndIf
	EndIf
    $_Handle = DllCall ( $_MediaInfoDll, 'none', 'MediaInfoList_Delete', 'ptr', $_Handle[0] )
    DllClose ( $_MediaInfoDll )
	If Not $_Duration Then
		GUICtrlSetState ( $_Time1Label, $GUI_HIDE )
		GUICtrlSetState ( $_Time2Label, $GUI_HIDE )
	Else
		GUICtrlSetState ( $_Time1Label, $GUI_SHOW )
		GUICtrlSetState ( $_Time2Label, $GUI_SHOW )
	EndIf
	$_DurationDisplay = StringFormat ( '%02d:%02d', Int ( $_Duration / 60 ), $_Duration - Int ( $_Duration / 60 ) * 60 )
EndFunc ;==> _GetAudioDuration ( )

Func _BASS_EXT_Startup ( $sBassEXTDLL='BassExt.dll' )
	If $_ghBassEXTDll <> -1 Then Return True
	If Not FileExists ( $sBassEXTDLL ) Then Return SetError ( $BASS_ERR_DLL_NO_EXIST, 0, False )
	$_ghBassEXTDll = DllOpen ( $sBassEXTDLL )
	If Not @error Then
		$BASS_EXT_StreamProc = __BASS_EXT_GetCallBackPointer ( 1 )
		If @error Then Return SetError ( 1, 1, 0 )
		$BASS_EXT_RecordProc = __BASS_EXT_GetCallBackPointer ( 2 )
		If @error Then Return SetError ( 1 , 2, 0 )
		$BASS_EXT_EncodeProc = __BASS_EXT_GetCallBackPointer ( 3 )
		If @error Then Return SetError ( 1, 3, 0 )
		$BASS_EXT_DSPProc = __BASS_EXT_GetCallBackPointer ( 4 )
		If @error Then Return SetError ( 1, 4, 0 )
		$BASS_EXT_DownloadProc = __BASS_EXT_GetCallBackPointer ( 5 )
		If @error Then Return SetError ( 1, 5, 0 )
		$BASS_EXT_AsioProc = __BASS_EXT_GetCallBackPointer ( 6 )
		If @error Then Return SetError ( 1, 6, 0 )
		$BASS_EXT_DspPeakProc = __BASS_EXT_GetCallBackPointer ( 7 )
		If @error Then Return SetError ( 1, 7, 0 )
		$BASS_EXT_FileCloseProc = __BASS_EXT_GetCallBackPointer ( 8 )
		If @error Then Return SetError ( 1, 8, 0 )
		$BASS_EXT_FileLenProc = __BASS_EXT_GetCallBackPointer ( 9 )
		If @error Then Return SetError ( 1, 9, 0 )
		$BASS_EXT_FileReadProc = __BASS_EXT_GetCallBackPointer ( 10 )
		If @error Then Return SetError ( 1, 10, 0 )
		$BASS_EXT_FileSeekProc = __BASS_EXT_GetCallBackPointer ( 11 )
		If @error Then Return SetError ( 1, 11, 0 )
		DllStructSetData ( $tBASS_EXT_FILEPROCS, 1, $BASS_EXT_FileCloseProc )
		DllStructSetData ( $tBASS_EXT_FILEPROCS, 2, $BASS_EXT_FileLenProc )
		DllStructSetData ( $tBASS_EXT_FILEPROCS, 3, $BASS_EXT_FileReadProc )
		DllStructSetData ( $tBASS_EXT_FILEPROCS, 4, $BASS_EXT_FileSeekProc )
	EndIf
	Return $_ghBassEXTDll <> -1
EndFunc ;==> _BASS_EXT_Startup ( )

Func _BASS_EXT_CreateFFT ( $iCnt, $iX, $iY, $iW, $iH, $iDistance=1, $iLogMin=90, $bMode=False )
	Local $aReturn[8]
	Local $iXPos, $nBarW = ( $iW / $iCnt ) - $iDistance
	Local $tStruct = DllStructCreate ( 'long[' & $iCnt * 8 & ']' )
	For $i = 1 To $iCnt
		$iXPos = Round ( ( $nBarW * ( $i - 1 ) ) + ( $iDistance * ( $i - 1 ) ) + $iX )
		DllStructSetData ( $tStruct, 1, $iXPos, ( $i - 1 ) * 8 + 1 )
		DllStructSetData ( $tStruct, 1, $iY + $iH, ( $i - 1 ) * 8 + 2 )
		DllStructSetData ( $tStruct, 1, $iXPos, ( $i - 1 ) * 8 + 3 )
		DllStructSetData ( $tStruct, 1, $iY, ( $i - 1 ) * 8 + 4 )
		DllStructSetData ( $tStruct, 1, Round ( $iXPos + $nBarW ), ( $i - 1 ) * 8 + 5 )
		DllStructSetData ( $tStruct, 1, $iY, ( $i - 1 ) * 8 + 6 )
		DllStructSetData ( $tStruct, 1, Round ( $iXPos + $nBarW ), ( $i - 1 ) * 8 + 7 )
		DllStructSetData ( $tStruct, 1, $iY + $iH, ( $i - 1 ) * 8 + 8 )
	Next
	$aReturn[0] = DllStructGetPtr ( $tStruct )
	$aReturn[1] = $iCnt * 4
	$aReturn[2] = $tStruct
	$aReturn[3] = $iCnt
	$aReturn[4] = $iY
	$aReturn[5] = $iH
	$aReturn[6] = $iLogMin
	$aReturn[7] = $bMode
	Return $aReturn
EndFunc ;==> _BASS_EXT_CreateFFT ( )

Func __BASS_EXT_GetCallBackPointer ( $iCBFunc=0 )
	Switch $iCBFunc
		Case 1 To 11
			Local $aResult = DllCall ( $_ghBassEXTDll, 'ptr', '_BASS_EXT_GetCallBackPointer', 'dword', $iCBFunc )
			If @error Then Return SetError ( 1, 0, 0 )
			Return $aResult[0]
	EndSwitch
	Return 0
EndFunc ;==> __BASS_EXT_GetCallBackPointer ( )

Func _BASS_EXT_ChannelGetFFT ( $hHandle, $aFFT, $iFallOff=6 )
	If Not IsArray ( $aFFT ) Or UBound ( $aFFT ) <> 8 Or Not IsDllStruct ( $aFFT[2] ) Or Not $hHandle Then Return SetError ( 1, 0, 0 )
	Local $bass_ext_ret = DllCall ( $_ghBassEXTDll, 'bool', '_BASS_EXT_ChannelGetFFT', 'dword', $hHandle, 'dword', $aFFT[3], _
	'dword', $aFFT[4], 'dword', $aFFT[5], 'dword', $aFFT[6], 'dword', $iFallOff, 'bool', $aFFT[7], 'ptr', $aFFT[0] )
	If @error Then Return SetError ( @error, 0, 0 )
	Return $bass_ext_ret[0]
EndFunc ;==> _BASS_EXT_ChannelGetFFT ( )

Func _BASS_EXT_ChannelRemoveMaxPeakDsp ( $aPeak, $handle=0 )
	If Not IsArray ( $aPeak ) Then Return SetError ( 1, 0, 0 )
	$aPeak[0] = 0
	Local $hHandle = $handle
	If Not $hHandle Then $hHandle = $aPeak[2]
	Local $aRet = _BASS_ChannelRemoveDSP ( $hHandle, $aPeak[1] )
	Switch @error
		Case True
			Return SetError ( 1, 1, 0 )
		Case Else
			Return SetError ( 0, 0, $aRet )
	EndSwitch
EndFunc ;==> _BASS_EXT_ChannelRemoveMaxPeakDsp ( )

Func _BASS_EXT_ChannelSetMaxPeakDsp ( $handle, $priority=10 )
	Local $tStruct = DllStructCreate ( 'double;double;double;double' )
	Local $hDsp = _BASS_ChannelSetDSP ( $handle, $BASS_EXT_DspPeakProc, DllStructGetPtr ( $tStruct ), $priority )
	Switch @error
		Case True
			Return SetError ( 1, 0, 0 )
		Case Else
			Local $aReturn[3]
			$aReturn[0] = $tStruct
			$aReturn[1] = $hDsp
			$aReturn[2] = $handle
			Return SetError ( 0, 0, $aReturn )
	EndSwitch
EndFunc ;==> _BASS_EXT_ChannelSetMaxPeakDsp ( )

Func _StringSize ( $sText, $iSize = Default, $iWeight=Default, $iAttrib=Default, $sName='', $iWidth=0 )
    Local $avSize_Info[4], $aRet, $iLine_Width = 0, $iLast_Word, $iWrap_Count
    Local $hLabel_Handle, $hFont, $hDC, $oFont, $tSize = DllStructCreate ( 'int X;int Y' )
    If Not IsString ( $sText ) Then Return SetError ( 1, 1, 0 )
    If Not IsNumber ( $iSize ) And $iSize <> Default Then Return SetError ( 1, 2, 0 )
    If Not IsInt ( $iWeight ) And $iWeight <> Default Then Return SetError ( 1, 3, 0 )
    If Not IsInt ( $iAttrib ) And $iAttrib <> Default Then Return SetError ( 1, 4, 0 )
    If Not IsString ( $sName ) Then Return SetError ( 1, 5, 0 )
    If Not IsNumber ( $iWidth ) Then Return SetError ( 1, 6, 0 )
    Local $hGUI = GUICreate ( '', 1200, 500, 10, 10 )
	If $hGUI = 0 Then Return SetError ( 2, 0, 0 )
	GUISetFont ( $iSize, $iWeight, $iAttrib, $sName )
    $avSize_Info[0] = $sText
    If StringInStr ( $sText, @CRLF ) = 0 Then $sText = StringRegExpReplace ( $sText, '[\x0a|\x0d]', @CRLF )
    Local $asLines = StringSplit ( $sText, @CRLF, 1 )
    Local $hText_Label = GUICtrlCreateLabel ( $sText, 10, 10 )
    Local $aiPos = ControlGetPos ( $hGUI, '', $hText_Label )
    GUISetState ( @SW_HIDE )
    GUICtrlDelete ( $hText_Label )
    $avSize_Info[1] = ( $aiPos[3] - 8 )/ $asLines[0]
    $avSize_Info[2] = $aiPos[2]
    $avSize_Info[3] = $aiPos[3] - 4
    If $aiPos[2] > $iWidth And $iWidth > 0 Then
        $avSize_Info[0] = ''
        $avSize_Info[2] = $iWidth
        Local $iLine_Count = 0
        For $j = 1 To $asLines[0]
            $hText_Label = GUICtrlCreateLabel ( $asLines[$j], 10, 10 )
            $aiPos = ControlGetPos ( $hGUI, '', $hText_Label )
            GUICtrlDelete ( $hText_Label )
            If $aiPos[2] < $iWidth Then
                $iLine_Count += 1
                $avSize_Info[0] &= $asLines[$j] & @CRLF
            Else
                $hText_Label = GUICtrlCreateLabel ( '', 0, 0 )
                $hLabel_Handle = ControlGetHandle ( $hGui, '', $hText_Label )
                $aRet = DllCall ( 'User32.dll', 'hwnd', 'GetDC', 'hwnd', $hLabel_Handle )
                If @error Or $aRet[0] = 0 Then Return SetError ( 3, 1, 0 )
                $hDC = $aRet[0]
                $aRet = DllCall ( 'user32.dll', 'lparam', 'SendMessage', 'hwnd', $hLabel_Handle, 'int', 0x0031, 'wparam', 0, 'lparam', 0 )
                If @error Or $aRet[0] = 0 Then Return SetError ( 3, _StringSize_Error ( 2, $hLabel_Handle, $hDC, $hGUI ), 0 )
                $hFont = $aRet[0]
                $aRet = DllCall ( 'GDI32.dll', 'hwnd', 'SelectObject', 'hwnd', $hDC, 'hwnd', $hFont )
                If @error Or $aRet[0] = 0 Then Return SetError ( 3, _StringSize_Error ( 3, $hLabel_Handle, $hDC, $hGUI ), 0 )
                $oFont = $aRet[0]
                $iWrap_Count = 0
                While 1
                    $iLine_Width = 0
                    $iLast_Word = 0
                    For $i = 1 To StringLen ( $asLines[$j] )
                        If StringMid ( $asLines[$j], $i, 1 ) = ' ' Then $iLast_Word = $i - 1
                        Local $sTest_Line = StringMid ( $asLines[$j], 1, $i )
                        GUICtrlSetData ( $hText_Label, $sTest_Line )
                        $iSize = StringLen ( $sTest_Line )
                        DllCall ( 'GDI32.dll', 'int', 'GetTextExtentPoint32', 'hwnd', $hDC, 'str', $sTest_Line, 'int', $iSize, 'ptr', DllStructGetPtr ( $tSize ) )
                        If @error Then Return SetError ( 3, _StringSize_Error(4, $hLabel_Handle, $hDC, $hGUI ), 0 )
                        $iLine_Width = DllStructGetData ( $tSize, 'X' )
                        If $iLine_Width >= $iWidth - Int ( $iSize / 2 ) Then ExitLoop
                    Next
                    If $i > StringLen ( $asLines[$j] ) Then
                        $iWrap_Count += 1
                        $avSize_Info[0] &= $sTest_Line & @CRLF
                        ExitLoop
                    Else
                        $iWrap_Count += 1
                        If $iLast_Word = 0 Then Return SetError ( 4, _StringSize_Error ( 0, $hLabel_Handle, $hDC, $hGUI ), 0 )
                        $avSize_Info[0] &= StringLeft ( $sTest_Line, $iLast_Word ) & @CRLF
                        $asLines[$j] = StringTrimLeft ( $asLines[$j], $iLast_Word )
                        $asLines[$j] = StringStripWS ( $asLines[$j], 1 )
                    EndIf
                WEnd
                $iLine_Count += $iWrap_Count
                DllCall ( 'User32.dll', 'int', 'ReleaseDC', 'hwnd', $hLabel_Handle, 'hwnd', $hDC )
                If @error Then Return SetError ( 3, _StringSize_Error ( 5, $hLabel_Handle, $hDC, $hGUI ), 0 )
                GUICtrlDelete ( $hText_Label )
            EndIf
        Next
        $avSize_Info[3] = ( $iLine_Count * $avSize_Info[1] ) + 4
    EndIf
    GUIDelete ( $hGUI )
    Return $avSize_Info
EndFunc ;==> _StringSize ( )

Func _StringSize_Error ( $iExtended, $hLabel_Handle, $hDC, $hGUI )
    DllCall ( 'User32.dll', 'int', 'ReleaseDC', 'hwnd', $hLabel_Handle, 'hwnd', $hDC )
    GUIDelete ( $hGUI )
    Return $iExtended
EndFunc ;==> _StringSize_Error ( )

Func _FileContextMenuInstall ( $_MenuText, $_Extension, $_RegKeyName )
	_FileContextMenuUninstall ( $_Extension )
	; install Double Click action.
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCR64\', 'HKCR\' )
	$_RegKeyValue = RegRead ( $_RegKey & $_Extension, '' )
	RegWrite ( $_RegKey & $_Extension, 'TMP.Backup', 'REG_SZ', $_RegKeyValue )
	RegWrite ( $_RegKey & $_Extension, '', 'REG_SZ', $_RegKeyName )
	RegWrite ( $_RegKey & $_RegKeyName & '\shell\open\command', '', 'REG_SZ', '"' & @ScriptFullPath & '" "%1"' )
	RegWrite ( $_RegKey & $_RegKeyName & '\DefaultIcon', '', 'REG_EXPAND_SZ', '"' & @ScriptFullPath & '",0' )
	RegWrite ( $_RegKey & 'Applications\' & @ScriptName & '\shell\open\command', '', 'REG_SZ', '"' & @ScriptFullPath & '" "%1"' )
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCU64\', 'HKCU\' )
	If Not StringInStr ( @OsVersion, 'WIN_XP' ) Then
		$_RegKeyValue = RegRead ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension & '\UserChoice', 'Progid' )
		If Not @error Then
			RegDelete ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension )
			If $_RegKeyValue <> '' Then RegWrite ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension & '\UserChoice', 'TMP.Backup', 'REG_SZ', $_RegKeyValue )
			RegWrite ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension & '\UserChoice', 'Progid', 'REG_SZ', 'Applications\' & @ScriptName )
		Endif
	Else
		$_RegKeyValue = RegRead ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension, 'Application' )
		If Not @error Then
			If $_RegKeyValue <> '' Then RegWrite ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension, 'TMP.Backup', 'REG_SZ', $_RegKeyValue )
			RegWrite ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension, 'Application', 'REG_SZ', @ScriptName )
		EndIf
	EndIf
	; install Right Click Menu.
	RegWrite ( $_RegKey & 'Software\Classes\Applications\' & @ScriptName & '\shell\open\command', '', 'REG_SZ', '"' & @ScriptFullPath & '" "%1"' )
	; install application
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKLM64\SOFTWARE\Classes\', 'HKLM\SOFTWARE\Classes\' )
	RegWrite ( $_RegKey & '\Applications\' & @ScriptName, '', 'REG_SZ', '' )
	RegWrite ( $_RegKey & '\Applications\' & @ScriptName, 'FriendlyAppName', 'REG_SZ', _GetNameWithoutExtByFullPath ( @ScriptFullPath ) )
	RegWrite ( $_RegKey & '\Applications\' & @ScriptName & '\shell\Open', '', 'REG_SZ', $_MenuText )
	RegWrite ( $_RegKey & '\Applications\' & @ScriptName & '\shell\Open\command', '', 'REG_SZ', '"' & @ScriptFullPath & '" "%1"' )
	RegWrite ( $_RegKey & '\Applications\' & @ScriptName & '\SupportedTypes', $_Extension, 'REG_SZ', '' )
EndFunc ;==> _FileContextMenuInstall ( )

Func _FileContextMenuUninstall ( $_Extension )
    Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKLM64\SOFTWARE\Classes\', 'HKLM\SOFTWARE\Classes\' )
    $_RegKeyName = RegRead ( $_RegKey & $_Extension, '' )
    If Not @error Then RegDelete ( $_RegKey & $_RegKeyName )
	; restore previous assoc and file type icons (no default program icon)
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCR64\', 'HKCR\' )
	$_RegKeyValue = RegRead ( $_RegKey & $_Extension, 'TMP.Backup' )
	If Not @error And $_RegKeyValue <> '' Then
		RegWrite ( $_RegKey & $_Extension, '', 'REG_SZ', $_RegKeyValue )
		$_RegBackup = RegRead ( $_RegKey & $_RegKeyValue & '\shell\open\command', '' )
		$_IconPath = StringStripWS ( StringReplace ( StringReplace ( $_RegBackup, '"', '' ), '%1', '' ), 3 )
		If FileExists ( $_IconPath ) Then RegWrite ( $_RegKey & $_RegKeyValue & '\DefaultIcon', '', 'REG_EXPAND_SZ', $_IconPath & ',0' )
	EndIf
	; Restore Double Click action.
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCU64\', 'HKCU\' )
	If Not StringInStr ( @OsVersion, 'WIN_XP' ) Then
		$_RegKeyValue = RegRead ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension & '\UserChoice', 'TMP.Backup' )
		If @error Or $_RegKeyValue = '' Then Return
		RegDelete ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension )
		RegWrite ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension & '\UserChoice', 'Progid', 'REG_SZ', $_RegKeyValue )
	Else
		$_RegKeyValue = RegRead ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension, 'TMP.Backup' )
		If @error Or $_RegKeyValue = '' Then Return
		RegWrite ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' & $_Extension, 'Application', 'REG_SZ', $_RegKeyValue )
	EndIf
EndFunc ;==> _FileContextMenuUninstall ( )

Func _DirContextMenuInstall ( $_MenuText, $_RegKeyName )
	_DirContextMenuUninstall ( $_RegKeyName )
	; install Right Click Menu.
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKLM64\SOFTWARE\Classes\Folder\shell\', 'HKLM\SOFTWARE\Classes\Folder\shell\' )
    RegWrite ( $_RegKey & $_RegKeyName, '', 'REG_SZ', $_MenuText )
    RegWrite ( $_RegKey & $_RegKeyName, 'Icon', 'REG_EXPAND_SZ', '"' & @ScriptFullPath & '",0' )
    RegWrite ( $_RegKey & $_RegKeyName & '\command', '', 'REG_SZ', '"' & @ScriptFullPath & '" "%1"' )
EndFunc ;==> _DirContextMenuInstall ( )

Func _DirContextMenuUninstall ( $_RegKeyName )
    Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKLM64\SOFTWARE\Classes\Folder\shell\', 'HKLM\SOFTWARE\Classes\Folder\shell\' )
	RegDelete ( $_RegKey & $_RegKeyName )
EndFunc ;==> _DirContextMenuUninstall ( )

Func _IsChecked ( $_Ctrl )
	Return BitAND ( GUICtrlRead ( $_Ctrl ), $GUI_CHECKED ) = $GUI_CHECKED
EndFunc ;==> _IsChecked ( )

Func _IsDirectory ( $_FilePath )
    If StringInStr ( FileGetAttrib ( $_FilePath ), 'D' ) Then Return True
EndFunc ;==> _IsDirectory ( )

;~ Func _FileListToArray ( $sPath, $sFilter='*', $iFlag=0 )
;~ 	Local $hSearch, $sFile, $sFileList, $sDelim = '|'
;~ 	$sPath = StringRegExpReplace ( $sPath, '[\\/]+\z', '' ) & '\'
;~ 	If Not FileExists ( $sPath ) Then Return SetError ( 1, 1, '' )
;~ 	If StringRegExp ( $sFilter, '[\\/:><\|]|(?s)\A\s*\z' ) Then Return SetError ( 2, 2, '' )
;~ 	If Not ( $iFlag = 0 Or $iFlag = 1 Or $iFlag = 2 ) Then Return SetError ( 3, 3, '' )
;~ 	$hSearch = FileFindFirstFile ( $sPath & $sFilter )
;~ 	If @error Then Return SetError ( 4, 4, '' )
;~ 	While 1
;~ 		$sFile = FileFindNextFile ( $hSearch )
;~ 		If @error Then ExitLoop
;~ 		If ( $iFlag + @extended = 2 ) Then ContinueLoop
;~ 		$sFileList &= $sDelim & $sFile
;~ 	WEnd
;~ 	FileClose ( $hSearch )
;~ 	If Not $sFileList Then Return SetError ( 4, 4, '' )
;~ 	Return StringSplit ( StringTrimLeft ( $sFileList, 1 ), '|' )
;~ EndFunc ;==> _FileListToArray ( )

Func _GetParentFolderPathByFullPath ( $_FullPath=@ScriptFullPath )
	$_FilePath = StringLeft ( $_FullPath, StringInStr ( $_FullPath, "\", 0, -1 ) - 1 )
	If Not @error Then Return $_FilePath
EndFunc   ;==>  _GetParentFolderPathByFullPath ( )

Func _GetNameWithoutExtByFullPath ( $_FullPath )
	$_FileName = StringSplit ( $_FullPath, '\' )
	If Not @error Then Return StringLeft ( $_FileName[$_FileName[0]], StringInStr ( $_FileName[$_FileName[0]], '.', 0, -1 ) - 1 )
EndFunc ;==> _GetNameWithoutExtByFullPath ( )

Func _GetExtByFullPath ( $_FullPath=@ScriptFullPath )
	$_FileName = StringSplit ( $_FullPath, '.' )
	If Not @error Then Return $_FileName[$_FileName[0]]
EndFunc ;==> _GetExtByFullPath ( )

Func _GetScriptVersion ( )
    If Not @Compiled Then
        Return StringTrimRight ( @ScriptName, 4 ) & ' © wakillon 2010 - ' & @YEAR
    Else
		Return StringTrimRight ( @ScriptName, 4 ) & ' v' & FileGetVersion ( @ScriptFullPath ) & ' © wakillon 2010 - ' & @YEAR
    EndIf
EndFunc ;==> _GetScriptVersion ( )

Func _AddContextMenu ( )
	TrayItemSetState ( $_AddMenuItem, $TRAY_UNCHECKED )
	If @Compiled Then
		_FileContextMenuInstall ( 'Play with TinyMp3Player', '.mp3', 'mp3_file_ex' )
		_FileContextMenuInstall ( 'Play with TinyMp3Player', '.m3u', 'm3u_file_ex' )
		_DirContextMenuInstall ( 'Play with TinyMp3Player', 'mp3_file_ex' )
		DllCall ( 'shell32.dll', 'none', 'SHChangeNotify', 'long', $SHCNE_ASSOCCHANGED, 'uint', $SHCNF_IDLIST, 'ptr', 0, 'ptr', 0 )
		TrayTip ( $_Version, 'Context Menu was Added', 2, 1+16 )
		AdlibRegister ( '_TrayTipTimer', 3000 )
	EndIf
EndFunc ;==> _AddContextMenu ( )

Func _RemoveContextMenu ( )
	TrayItemSetState ( $_RemoveMenuItem, $TRAY_UNCHECKED )
	If @Compiled Then
		_FileContextMenuUninstall ( '.mp3' )
		_FileContextMenuUninstall ( '.m3u' )
		_DirContextMenuUninstall ( 'mp3_file_ex' )
		DllCall ( 'shell32.dll', 'none', 'SHChangeNotify', 'long', $SHCNE_ASSOCCHANGED, 'uint', $SHCNF_IDLIST, 'ptr', 0, 'ptr', 0 )
		TrayTip ( $_Version, 'Context Menu was Removed', 2, 1+16 )
		AdlibRegister ( '_TrayTipTimer', 3000 )
	EndIf
EndFunc ;==> _RemoveContextMenu ( )

Func _TrayTipTimer ( )
	TrayTip ( '', '', 0, 0 )
	AdlibUnRegister ( '_TrayTipTimer' )
EndFunc ;==> _TrayTipTimer ( )

Func _ReduceMemory ( $_PID )
	Local $hPsAPIdll = 'psapi.dll', $hKernel32dll = 'kernel32.dll'
    If $_PID <> -1 Then
        Local $aHandle = DllCall ( $hKernel32dll, 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $_PID )
        Local $aReturn = DllCall ( $hPsAPIdll, 'int', 'EmptyWorkingSet', 'long', $aHandle[0] )
        DllCall ( $hKernel32dll, 'int', 'CloseHandle', 'int', $aHandle[0] )
    Endif
EndFunc ;==> _ReduceMemory ( )

Func _OpenTopic ( )
	TrayItemSetState ( $_TopicItem, $TRAY_UNCHECKED )
	$_TopicUrl = 'http://www.autoitscript.com/forum/topic/123051-tinymp3player/'
	ShellExecute ( _GetDefaultBrowser ( ), $_TopicUrl )
EndFunc ;==> _OpenTopic ( )

Func _GetDefaultBrowser ( )
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCR64\', 'HKCR\' )
    $_DefautBrowser = StringRegExp ( RegRead ( $_RegKey & '\http\shell\open\command', '' ), '(?s)(?i)"(.*?)"', 3 )
    If Not @error Then Return $_DefautBrowser[0]
	Return 'iexplore.exe'
EndFunc ;==> _GetDefaultBrowser ( )

Func _SetTrayMenu ( )
    TraySetIcon ( @WindowsDir & '\music.ico' )
	$_TopicItem = TrayCreateItem ( 'TinyMp3Player Topic' )
	TrayItemSetOnEvent ( -1, '_OpenTopic' )
	If @Compiled Then
		TrayCreateItem ( '' )
		$_AddMenuItem = TrayCreateItem ( 'Add Context Menu' )
		TrayItemSetOnEvent ( -1, '_AddContextMenu' )
		TrayCreateItem ( '' )
		$_RemoveMenuItem = TrayCreateItem ( 'Remove Context Menu' )
		TrayItemSetOnEvent ( -1, '_RemoveContextMenu' )
	EndIf
	TrayCreateItem ( '' )
	TrayCreateItem ( 'Exit' )
	TrayItemSetOnEvent ( -1, '_Exit' )
	TraySetClick ( 16 )
	TraySetState ( 4 )
	TraySetToolTip ( $_Version )
EndFunc ;==> _SetTrayMenu ( )

Func _FileMissing ( )
	If Not FileExists ( $_TempDir & '\Skin' ) Then Return True
	;If StringInStr ( @OsVersion, 'WIN_XP' ) Then
		If Not FileExists ( $_TempDir & '\skin\SkinCrafterDll.dll' ) Then Return True
		If Not FileExists ( $_TempDir & '\skin\Machine_gun.skf' ) Then Return True
	;EndIf
	If Not FileExists ( $_TempDir & '\skin\Backward_01.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\skin\Forward.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\skin\Forward_01.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\skin\pause.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\skin\stop.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\skin\Bk6.jpg' ) Then Return True
	If Not FileExists ( @WindowsDir & '\music.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\BassExt.dll' ) Then Return True
	If Not FileExists ( $_TempDir & '\bass.dll' ) Then Return True
	If Not FileExists ( $_TempDir & '\MediaInfo.dll' ) Then Return True
EndFunc ;==> _FileMissing ( )

Func _FileInstall ( )
	ToolTip ( _StringRepeat ( ' ', 12 ) & @Crlf & 'Please Wait while downloading externals files' & @Crlf & @Crlf, @DesktopWidth/2-152, @DesktopHeight/3, $_Version, 1, 4 )
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCU64\', 'HKCU\' )
	RegWrite ( $_RegKey & 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced', 'EnableBalloonTips', 'REG_DWORD', '00000001' )
	If Not FileExists ( $_TempDir & '\Skin' ) Then DirCreate ( $_TempDir & '\Skin' )
	Local $_Url = 'http://tinyurl.com/d2p9ckg'
	;If StringInStr ( @OsVersion, 'WIN_XP' ) Then
		If Not FileExists ( $_TempDir & '\skin\SkinCrafterDll.dll' ) Then InetGet ( $_Url & '/SkinCrafterDll.dll', $_TempDir & '\skin\SkinCrafterDll.dll', 9, 0 )
		If Not FileExists ( $_TempDir & '\skin\Machine_gun.skf' ) Then InetGet ( $_Url & '/Machine_gun.skf', $_TempDir & '\skin\Machine_gun.skf', 9, 0 )
	;EndIf
	If Not FileExists ( $_TempDir & '\skin\Backward_01.ico' ) Then InetGet ( $_Url & '/Backward_01.ico', $_TempDir & '\skin\Backward_01.ico', 9, 0 )
	If Not FileExists ( $_TempDir & '\skin\Forward.ico' ) Then InetGet ( $_Url & '/Forward.ico', $_TempDir & '\skin\Forward.ico', 9, 0 )
	If Not FileExists ( $_TempDir & '\skin\Forward_01.ico' ) Then InetGet ( $_Url & '/Forward_01.ico', $_TempDir & '\skin\Forward_01.ico', 9, 0 )
	If Not FileExists ( $_TempDir & '\skin\pause.ico' ) Then InetGet ( $_Url & '/pause.ico', $_TempDir & '\skin\pause.ico', 9, 0 )
	If Not FileExists ( $_TempDir & '\skin\stop.ico' ) Then InetGet ( $_Url & '/stop.ico', $_TempDir & '\skin\stop.ico', 9, 0 )
	If Not FileExists ( $_TempDir & '\skin\Bk6.jpg' ) Then InetGet ( $_Url & '/Bk6.jpg', $_TempDir & '\skin\Bk6.jpg', 9, 0 )
	If Not FileExists ( @WindowsDir & '\music.ico' ) Then InetGet ( $_Url & '/music.ico', @WindowsDir & '\music.ico', 9, 0 )
	If Not FileExists ( $_TempDir & '\BassExt.dll' ) Then InetGet ( $_Url & '/BassExt.dll', $_TempDir & '\BassExt.dll', 9, 0 )
	If Not FileExists ( $_TempDir & '\bass.dll' ) Then InetGet ( $_Url & '/bass.dll', $_TempDir & '\bass.dll', 9, 0 )
	If Not FileExists ( $_TempDir & '\MediaInfo.dll' ) Then InetGet ( $_Url & '/MediaInfo.dll', $_TempDir & '\MediaInfo.dll', 9, 0 )
	ToolTip ( '' )
EndFunc ;==> _FileInstall ( )

Func _Exit ( )
	Exit
EndFunc ;==> _Exit ( )

Func _OnAutoItExit ( )
	_Stop ( )
	RegWrite ( $_RegKeySettings, 'LastVolume', 'REG_SZ', GUICtrlRead ( $_VolSlider ) / 100 )
	RegWrite ( $_RegKeySettings, 'RandomMode', 'REG_SZ', _IsChecked ( $_RandomCheckBox ) )
	GUICtrlSetState ( $_BkPic, $GUI_SHOW )
	AdlibUnRegister ( '_ScrollLabel' )
	_BASS_EXT_ChannelRemoveMaxPeakDsp ( $aPeak )
	_BASS_ChannelStop ( $_MusicHandle )
	_BASS_StreamFree ( $_MusicHandle )
	_BASS_Free ( )
	_GDIPlus_BrushDispose ( $hBrushFFT )
	_GDIPlus_BitmapDispose ( $hBmpBk )
	_GDIPlus_GraphicsDispose ( $hGfxBuffer )
	_GDIPlus_BitmapDispose ( $hBmpBuffer )
	_GDIPlus_GraphicsDispose ( $hGraphics )
	_GDIPlus_Shutdown ( )
	GUIDelete ( $_Gui )
	DllClose ( $_User32Dll )
	DllCall ( $_SkinDll, 'int:cdecl', 'DeInitDecoration' )
	DllCall ( $_SkinDll, 'int:cdecl', 'RemoveSkin' )
	DllClose ( $_SkinDll )
EndFunc ;==> _OnAutoItExit ( )