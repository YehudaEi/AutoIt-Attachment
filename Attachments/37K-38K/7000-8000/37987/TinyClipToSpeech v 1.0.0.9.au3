#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Windows\Text-to-speech.ico
#AutoIt3Wrapper_Outfile=TinyClipToSpeech.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Tested on Xp sp3
#AutoIt3Wrapper_Res_Description=Read Clipboard's Text using Microsoft Speech API Voice.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.9
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=P
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © wakillon 2010 - 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#include <GUIConstantsEx.au3>
#Include <APIConstants.au3>
#include <GuiSlider.au3>
#include <ClipBoard.au3>
#Include <WinAPIEx.au3>
#include <String.au3>
#include <File.au3>
#Include <Date.au3>
#Include <Misc.au3>
#Include <Array.au3>
#EndRegion ;************ Includes ************

#Region ------ Global Variables ------------------------------
; SpVoice Flags http://msdn.microsoft.com/en-us/library/ms720892(v=vs.85).aspx  http://msdn.microsoft.com/en-us/library/ee125223(v=vs.85).aspx
Global Const $SVSFDefault = 0
Global Const $SVSFlagsAsync = 1
Global Const $SVSFPurgeBeforeSpeak = 2
Global Const $SVSFIsFilename = 4
Global Const $SVSFIsXML = 8
Global Const $SVSFIsNotXML = 16
Global Const $SVSFPersistXML = 32
; Normalizer Flags
Global Const $SVSFNLPSpeakPunc = 64
; TTS Format
Global Const $SVSFParseSapi = 128
Global Const $SVSFParseSsml = 256
Global Const $SVSFParseAutoDetect = 0
; Masks
Global Const $SVSFNLPMask = 64
;Global Const $SVSFParseMask = 384
Global Const $SVSFVoiceMask = 127
Global Const $SVSFUnusedFlags = -128
; SpeechAudioFormatType
Global Const $SAFTDefault = -1
Global Const $SAFTNoAssignedFormat = 0
Global Const $SAFTText = 1
Global Const $SAFTNonStandardFormat = 2
Global Const $SAFTExtendedAudioFormat = 3
; SpeechStreamFileMode   http://msdn.microsoft.com/en-us/library/ms720858(v=VS.85).aspx
Global Const $SSFMOpenForRead = 0
Global Const $SSFMOpenReadWrite = 1
Global Const $SSFMCreate = 2
Global Const $SSFMCreateForWrite = 3
; Standard PCM wave formats   http://msdn.microsoft.com/en-us/library/ms720595(v=vs.85).aspx
Global Const $SAFT32kHz16BitMono = 30
Global Const $SAFT32kHz16BitStereo = 31
Global Const $SAFT44kHz8BitMono = 32
Global Const $SAFT44kHz8BitStereo = 33
Global Const $SAFT44kHz16BitMono = 34
Global Const $SAFT44kHz16BitStereo = 35
Global Const $SAFT48kHz8BitMono = 36
Global Const $SAFT48kHz8BitStereo = 37
Global Const $SAFT48kHz16BitMono = 38
Global Const $SAFT48kHz16BitStereo = 39
; SpeechRunState    http://msdn.microsoft.com/en-us/library/ms720850(v=VS.85).aspx
Global Const $SRSEDone = 1
Global Const $SRSEIsSpeaking = 2
Global $_SpeechVoiceSpeakFlags = $SVSFlagsAsync + $SVSFPurgeBeforeSpeak + $SVSFNLPSpeakPunc
Global $oSpeech, $oStream, $oSpVoiceEvent, $oErrorHandler
Global $_Gui, $_VoicesCombo, $_RateSlider, $_VolumeSlider, $_Label1, $_ScreenTextLabel, $_ScreenGui
Global $_TempDir = @TempDir & '\TCTS'
Global $_RegKeySettings = "HKEY_CURRENT_USER\Software\TinyClipToSpeech\Settings", $_RegTitleKey = 'TinyClipToSpeech'
Global $_Version = _GetScriptVersion ( ), $_DefaultBrowser = _GetDefaultBrowser ( ), $_Timer = _NowCalc ( )
Global $_ExitItem, $_ShowText, $_TrayTipItem, $_PauseItem, $_TitleItem, $_StartItem
Global $_SpeakItem, $_SettingsItem, $_SaveToMp3Item, $_AboutItem, $_SpeechItem
Global $_ClipboardText, $_Pause, $_Play, $_TrayState, $_ToolTipText2, $_ToolTipTextArray[1]
Global $_Redim, $_TextPos, $_CharacterPositionOld, $_CharacterPos, $_SLength, $_EndText
#EndRegion --- Global Variables ------------------------------

If Not _Singleton ( @ScriptName, 1 ) Then Exit
HotkeySet ( '{F12}', '_Text2Speak' )
OnAutoItExitRegister ( '_OnAutoItExit' )
Opt ( 'TrayOnEventMode', 1 )
Opt ( 'TrayMenuMode', 1 )
Opt ( 'GUIOnEventMode', 1 )

#Region ------ Init ------------------------------
If _FileMissing ( ) Then _FileInstall ( )
_CheckSapiInstall ( )
_SetTrayMenu ( )
_Gui ( )
_ScreenGui ( )
#EndRegion --- Init ------------------------------

#region ------ Main loop -----------------
While 1
	$_NowCalc = _NowCalc ( )
	If _DateDiff ( 's', $_Timer, $_NowCalc ) >= 0.5 Then
		If IsObj ( $ospeech ) Then
			If $ospeech.Status.RunningState = $SRSEIsSpeaking Then ; http://msdn.microsoft.com/en-us/library/ee125527(v=vs.85).aspx
				If $_TrayState = 0 Then
					If $_ShowText Then GUISetState ( @SW_SHOW, $_ScreenGui )
				    TraySetIcon ( $_TempDir & '\Play.ico' )
				    TraySetState ( 4 )
					TrayItemSetState ( $_SaveToMp3Item, $TRAY_DISABLE )
					$_TrayState = 1
				EndIf
			Else
				If $_TrayState = 1 Then
					If Not $_Pause Then
					    TraySetIcon ( 'C:\Windows\Text-to-speech.ico' )
						TrayItemSetText ( $_SpeakItem, 'Speak Text in ClipBoard' )
						TrayItemSetState ( $_PauseItem, $TRAY_DISABLE )
						TrayItemSetState ( $_SaveToMp3Item, $TRAY_ENABLE )
						$_Play = False
		                TraySetState ( 1+8 )
						AdlibRegister ( '_TrayTipTimer', 2000 )
						$_CharacterPos = 0
						$_SLength = 0
						$_CharacterPositionOld = 0
						$_EndText = ''
						$_Redim = 1
					EndIf
					$_TrayState = 0
				EndIf
			EndIf
		EndIf
		$_Timer = $_NowCalc
	EndIf
	Sleep ( 20 )
WEnd
#endregion --- Main loop -----------------

#Region ------ Text2Speak Management ------------------------------
Func _Text2Speak ( )
	TrayItemSetState ( $_SpeakItem, $TRAY_UNCHECKED )
	GUICtrlSetState ( $_VoicesCombo, $GUI_ENABLE )
    $_ClipboardText = _ClipGet ( )
    If @error Then Return MsgBox ( 262144+4096+16, 'Error', 'There is no Text in ClipBoard !', 5 )
	Local $_VolumeRead = GUICtrlRead ( $_VolumeSlider )
	Local $_RateRead = GUICtrlRead ( $_RateSlider )
	$_Play = Not $_Play
	If $_Play Then
		TrayItemSetState ( $_PauseItem, $TRAY_ENABLE )
		TrayItemSetText ( $_PauseItem, 'Pause' )
		With $oSpeech
            .Volume = $_VolumeRead
            .Rate = $_RateRead ; Values for the Rate property range from -10 to 10, which represent the slowest and the fastest speaking rates.
            .voice = .getvoices.item ( 0 ) ; get default voice
		Endwith
		Sleep ( 1000 )
        $oSpeech.Speak ( $_ClipboardText, $_SpeechVoiceSpeakFlags )
	    TrayItemSetText ( $_SpeakItem, 'Stop' )
	Else
		TrayItemSetText ( $_PauseItem, 'Pause' )
		TrayItemSetState ( $_PauseItem, $TRAY_DISABLE )
		If $_Pause Then $oSpeech.resume
		$_Pause = False
        $oSpeech.Speak ( '', $SVSFPurgeBeforeSpeak )
	    TrayItemSetText ( $_SpeakItem, 'Speak Text in ClipBoard' )
		TraySetIcon ( 'C:\Windows\Text-to-speech.ico' )
		TraySetState ( 1+8 )
		AdlibRegister ( '_TrayTipTimer', 2000 )
	EndIf
EndFunc ;==> _Text2Speak ( )

Func _SpVoiceEvent_Word ( $_StreamNumber, $_StreamPosition, $_CharacterPosition, $_Length ) ; http://msdn.microsoft.com/en-us/library/ee125631(v=VS.85).aspx
	$_CharacterPos = $_CharacterPosition
	$_SLength = $_Length
	If $_EndText = '' Then $_EndText = $_ClipboardText
    Local $_ToolTipText = StringMid ( $_EndText, $_CharacterPos+1, $_Length )
	$_TextPos = $_CharacterPos + $_Length +1 + $_CharacterPositionOld
	Local $_ToolTipText2 = ''
	If $_Redim Then ReDim $_ToolTipTextArray[1]
	_ArrayAdd ( $_ToolTipTextArray, $_ToolTipText )
	For $_I = 1 To UBound ( $_ToolTipTextArray ) -1
    	$_ToolTipText2 = $_ToolTipText2 & ' ' & $_ToolTipTextArray[$_I]
	Next
	If StringLen ( $_ToolTipText2 ) > 150 And StringRight ( $_ToolTipText, 1 ) = '.' Then
		$_Redim = 1
	Else
		$_Redim = 0
		If StringLen ( $_ToolTipText2 ) > 220 Then $_Redim = 1
	EndIf
	If $_ShowText Then GUICtrlSetData ( $_ScreenTextLabel, $_ToolTipText2 )
EndFunc ;==> _SpVoiceEvent_Word ( )

Func _SetRate ( )
    Local $_RateRead = GUICtrlRead ( $_RateSlider ), $_NoSound = 0
	$oSpeech.Rate = $_RateRead
	RegWrite ( $_RegKeySettings, 'Rate', 'REG_SZ', $_RateRead )
	If $ospeech.Status.RunningState = $SRSEIsSpeaking Then $_NoSound = 16
	TrayTip ( 'Speaking Rate', 'Set to : ' & $_RateRead, 2, 1 + $_NoSound )
	AdlibRegister ( '_TrayTipTimer', 2000 )
EndFunc ;==> _SetRate ( )

Func _SetVolume ( )
    Local $_VolumeRead = GUICtrlRead ( $_VolumeSlider ), $_NoSound = 0
	$oSpeech.Volume = $_VolumeRead
	RegWrite ( $_RegKeySettings, 'Volume', 'REG_SZ', $_VolumeRead )
	If $ospeech.Status.RunningState = $SRSEIsSpeaking Then $_NoSound = 16
	TrayTip ( 'Speaking Volume', 'Set to : ' & $_VolumeRead & '%', 2, 1 + $_NoSound )
	AdlibRegister ( '_TrayTipTimer', 2000 )
EndFunc ;==> _SetVolume ( )

Func _SetDefaultVoice ( )
	TrayTip ( '', '', 0, 0 )
    Local $_ComboRead = GUICtrlRead ( $_VoicesCombo ), $i = 1
    While 1
        Local $_VoiceKeyName = RegEnumKey ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices\Tokens', $i )
        If @error <> 0 Then ExitLoop
	    $_VoiceDisplayName = RegRead ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices\Tokens\' & $_VoiceKeyName, '' )
		If $_VoiceDisplayName = $_ComboRead Then
		    RegWrite ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices\Tokens\' & $_VoiceKeyName, '', 'REG_SZ', $_VoiceDisplayName )
			RegWrite ( 'HKEY_CURRENT_USER\Software\Microsoft\Speech\Voices', 'DefaultTokenId', 'REG_SZ', 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\Voices\Tokens\' & $_VoiceKeyName )
			If $ospeech.Status.RunningState = $SRSEIsSpeaking Then
                $_EndText = StringMid ( $_ClipboardText, $_TextPos )
				$_CharacterPositionOld = $_CharacterPositionOld + $_CharacterPos + $_SLength +1
				$oSpeech.Speak ( '', $SVSFPurgeBeforeSpeak )
			    $oSpeech.voice = $oSpeech.getvoices.item ( 0 )
		    	$oSpeech.Speak ( $_EndText, $_SpeechVoiceSpeakFlags )
			Else
			    TrayTip ( 'Default Speaking Voice', 'Set to : ' & $_VoiceDisplayName, 2, 1+16 )
			    AdlibRegister ( '_TrayTipTimer', 2000 )
			    Return 1
			EndIf
		EndIf
	    $i = $i +1
    WEnd
EndFunc ;==> _SetDefaultVoice ( )

Func _Pause ( )
	TrayItemSetState ( $_PauseItem, $TRAY_UNCHECKED )
	$_Pause = Not $_Pause
	If $_Pause Then
        $oSpeech.pause
		GUICtrlSetState ( $_VoicesCombo, $GUI_DISABLE )
	    TrayItemSetText ( $_PauseItem, 'Resume' )
		TraySetIcon ( $_TempDir & '\Pause.ico' )
	Else
	    Local $_VolumeRead = GUICtrlRead ( $_VolumeSlider )
	    Local $_RateRead = GUICtrlRead ( $_RateSlider )
	    With $oSpeech
		    .Volume = $_VolumeRead
		    .Rate = $_RateRead
			.resume
	    Endwith
	    TrayItemSetText ( $_PauseItem, 'Pause' )
		GUICtrlSetState ( $_VoicesCombo, $GUI_ENABLE )
	EndIf
EndFunc ;==> _Pause ( )

Func _SaveToMp3 ( )
	TrayItemSetState ( $_SaveToMp3Item, $TRAY_UNCHECKED )
	$_ClipboardText = _ClipGet ( )
	If @error Then Return MsgBox ( 262144+4096+16, 'Error', 'There is no Text in ClipBoard !', 5 )
	If Not IsObj ( $oStream ) Then $oStream = ObjCreate ( "SAPI.SpFileStream" )
	If @error Then Return MsgBox ( 262144+4096+16, 'Error', "Mp3 can't be created !" & @CRLF, 3 )
	ToolTip ( _StringRepeat ( ' ', 20 ) & 'Please wait while creating file' & @CRLF, @DesktopWidth/2-152, 0, $_Version, 1, 4 )
	$oSpeech.AllowAudioOutputFormatChangesOnNextSet = True ; http://msdn.microsoft.com/en-us/library/ee125633(v=VS.85).aspx
    $oStream.Format.Type = $SAFT48kHz16BitMono
	$_AudioFileName = @YEAR & @MON & @MDAY & '-' & @HOUR & @MIN & @SEC & '-' & $oSpeech.getvoices.item ( 0 ).GetDescription
    $oStream.Open ( $_TempDir & '\' & $_AudioFileName & '.wav', $SSFMCreateForWrite, True ) ; When FileMode is SSFMCreateForWrite, DoEvents specifies whether playback of the resulting sound file will generate voice events. Default value is False.
    $oSpeech.AudioOutputStream = $oStream ; http://msdn.microsoft.com/en-us/library/ee125635(v=VS.85).aspx
	Local $_RateRead = GUICtrlRead ( $_RateSlider )
	With $oSpeech
		.voice = .getvoices.item ( 0 )
		.Volume = 100
		.Rate = $_RateRead
	Endwith
	$oSpeech.Speak ( $_ClipboardText, $SVSFPurgeBeforeSpeak + $SVSFNLPSpeakPunc )
	$oStream.Close ( )
	$oSpeech.AudioOutput = $oSpeech.GetAudioOutputs ( '' ).Item ( 0 ) ; http://msdn.microsoft.com/en-us/library/ee125248(v=vs.85).aspx
	ToolTip ( '' )
	$_Mp3FilePath = FileSaveDialog ( 'Choose a Name.', @DesktopDir, 'Audio (*.mp3)', 2 + 16, $_AudioFileName, $_Gui )
    If @error Then Return MsgBox ( 262144+4096+64, 'SaveToMp3', 'Save Cancelled.', 3 )
	If StringRight ( $_Mp3FilePath, 4 ) <> '.mp3' Then $_Mp3FilePath = $_Mp3FilePath & '.mp3'
	ToolTip ( _StringRepeat ( ' ', 20 ) & 'Please wait while Converting to Mp3' & @CRLF, @DesktopWidth/2-152, 0, $_Version, 1, 4 )
	RunWait ( '"' & $_TempDir & '\lame.exe" -q0 "' & $_TempDir & '\' & $_AudioFileName  & '.wav" "' & $_TempDir & '\temp.mp3"', '', @SW_HIDE ) ; -q0 : highest quality
	FileMove ( $_TempDir & '\temp.mp3', $_Mp3FilePath )
	ToolTip ( '' )
	FileDelete ( $_TempDir & '\' & $_AudioFileName & '.wav' )
EndFunc ;==> _SaveToMp3 ( )

Func _CheckSapiInstall ( )
	If Not IsObj ( $oErrorHandler ) Then
	    $oErrorHandler = ObjEvent ( 'AutoIt.Error', '_ErrFunc' )
		RegWrite ( 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced', 'EnableBalloonTips', 'REG_DWORD', '00000001' )
	EndIf
	$oSpeech = ObjCreate ( 'SAPI.SpVoice' )
	If IsObj ( $oSpeech ) Then
		If Not IsObj ( $oSpVoiceEvent ) Then $oSpVoiceEvent = ObjEvent ( $oSpeech, '_SpVoiceEvent_' )
	    Return 1
	Else
		$_MsgBox = MsgBox ( 262144+4096+32+4, 'Exiting on Error', 'You need to install Microsoft Speech API first !' & @CRLF & @CRLF & 'Do you want Download Sapi5_Installer.exe ?' & @CRLF )
		If $_MsgBox = 6 Then
			If Not _IsConnected ( ) Then Exit MsgBox ( 262144+4112+16, "Error", 'You are Not Connected !' & @CRLF & @CRLF & 'Retry later', 5 )
			Local $_DownloadUrl = 'http://my-autoit-tiny-tools-collection.googlecode.com/files/Sapi5_Installer.exe'
			$_Size = InetGetSize ( $_DownloadUrl, 11 )
			If Not @error And $_Size Then
		        _DownloadWithProgress ( $_DownloadUrl, 'Sapi5_Installer.exe', @DesktopDir )
		        $_MsgBox = MsgBox ( 262144+4096+64+4, 'Finish', 'Sapi5_Installer.exe Installer is now on your Desktop !' & @CRLF & @CRLF & 'Do you want to Run it now ?' & @CRLF, 7 )
				If $_MsgBox = 6 Then
					RunWait ( @DesktopDir & '\Sapi5_Installer.exe' )
					MsgBox ( 262144+4096+64, 'Finish', 'Sapi5 Voice is now installed.' & @CRLF & @CRLF & 'You need to Restart TinyClipToSpeech.' & @CRLF, 7 )
					Exit
				EndIf
	        Else
				MsgBox ( 262144+4096+16, 'Error', 'Sapi5_Installer.exe Download WebSite is not reachable !', 5 )
	        EndIf
        EndIf
	EndIf
	Exit
EndFunc ;==> _CheckSapiInstall ( )
#EndRegion --- Text2Speak Management ------------------------------

#Region ------ Guis Management ------------------------------
Func _Gui ( )
    $_Gui = GUICreate ( $_Version, 400, 280, @DesktopWidth - 400 -10, @DesktopHeight - 280 - _GetTaskbarHeight ( ) -35, -1, $WS_EX_TOPMOST, WinGetHandle ( AutoItWinGetTitle ( ) ) )
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_SetGuiSettingsState')
	GUISetOnEvent ( $GUI_EVENT_MINIMIZE, '_SetGuiSettingsState')
    GUISetBkColor ( 0x000000 )
    GUISetIcon ( 'C:\Windows\Text-to-speech.ico', $_Gui )
	$_Label1 = GUICtrlCreateLabel ( 'Voice Settings', 20, 10, 360, 25, 0x01 )
	GUICtrlSetColor ( -1, 0xFFFF00 )
    GUICtrlSetFont ( -1, 16, 800 )
    GUICtrlCreateGroup ( '', 20, 40, 360, 60 )
	GUICtrlCreateLabel ( ' Select Default Voice ', 35, 40, 125, 13, 0x01 )
	GUICtrlSetColor ( -1, 0xFFFFFF )
	GUICtrlSetFont ( -1, 9, 800 )
    $_VoicesCombo = GUICtrlCreateCombo ( $oSpeech.getvoices.item ( 0 ).GetDescription , 40, 65, 320, 25 )
	GUICtrlSetOnEvent ( $_VoicesCombo, '_SetDefaultVoice' )
	Local $_ComboVoices = ''
	For $_I = 1 To $oSpeech.getVoices.count -1
		$_ComboVoices &= $oSpeech.getVoices.item ( $_I ).GetDescription & '|'
	Next
    GUICtrlSetData ( $_VoicesCombo, $_ComboVoices )
    $_RateValue = 0
    $_RegRead = RegRead ( $_RegKeySettings, 'Rate' )
	If $_RegRead <> '' Then $_RateValue = $_RegRead
    GUICtrlCreateGroup ( '', 20, 120, 360, 60 )
	GUICtrlCreateLabel ( ' Set Speaking Speed ', 35, 120, 125, 13, 0x01 )
	GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetFont ( -1, 9, 800 )
    $_RateSlider = GUICtrlCreateSlider ( 40, 145, 320, 25, BitOR ( $TBS_TOOLTIPS, $TBS_AUTOTICKS ) )
	GUICtrlSetbkColor ( -1, 0x000000 )
    GUICtrlSetLimit ( -1, 10, -10 )
	GUICtrlSetData ( -1, $_RateValue )
    GUICtrlSetOnEvent ( -1, '_SetRate')
    _GUICtrlSlider_SetTipSide ( $_RateSlider, $TBTS_TOP )
    $_VolumeValue = 100
    $_RegRead = RegRead ( $_RegKeySettings, 'Volume' )
	If $_RegRead <> '' Then $_VolumeValue = $_RegRead
    GUICtrlCreateGroup ( '', 20, 200, 360, 60 )
	GUICtrlCreateLabel ( ' Set Volume ', 35, 200, 80, 13, 0x01 )
	GUICtrlSetColor ( -1, 0xFFFF00 )
	GUICtrlSetFont ( -1, 9, 800 )
    $_VolumeSlider = GUICtrlCreateSlider ( 40, 225, 320, 25, BitOR ( $TBS_TOOLTIPS, $TBS_AUTOTICKS ) )
	GUICtrlSetbkColor ( -1, 0x000000 )
    GUICtrlSetData ( -1, $_VolumeValue )
    GUICtrlSetOnEvent ( -1, '_SetVolume' )
    _GUICtrlSlider_SetTipSide ( $_VolumeSlider, $TBTS_TOP )
	GUICtrlCreateLabel ( 'All setting changes are instantly applied and saved.', 20, 263, 360, 18, 0x01 )
	GUICtrlSetColor ( -1, 0xFF0000 )
    GUICtrlSetFont ( -1, 8, 400 )
    GUISetState ( @SW_HIDE, $_Gui )
EndFunc ;==> _Gui ( )

Func _ScreenGui ( )
    $_ScreenGui = GUICreate ( '', 1000, 600, -1, -1, $WS_POPUP, $WS_EX_LAYERED, WinGetHandle ( AutoItWinGetTitle ( ) ) )
    GUISetBkColor ( 0xABCDEF, $_ScreenGui )
    _WinAPI_SetLayeredWindowAttributes ( $_ScreenGui, 0xABCDEF )
    $_ScreenTextLabel = GUICtrlCreateLabel ( '', 0, 0, 1000, 600 )
    GUICtrlSetColor ( -1, 0xFF0000 )
    GUICtrlSetFont ( -1, 48, 600 )
    GUISetState ( @SW_HIDE, $_ScreenGui )
    WinSetOnTop ( $_ScreenGui, '', 1 )
EndFunc ;==> _ScreenGui ( )
#EndRegion --- Guis Management ------------------------------

#Region ------ Tray Management ------------------------------
Func _SetTrayMenu ( )
                 TraySetIcon ( 'C:\Windows\Text-to-speech.ico' )
$_TitleItem    = TrayCreateItem ( 'TinyClipToSpeech Topic' )
                 TrayItemSetOnEvent ( -1, '_OpenTopic' )
                 TrayCreateItem ( '' )
$_StartItem    = TrayCreateItem ( 'Start Minimized With Windows' )
                 TrayItemSetOnEvent ( -1, '_StartWithWindows' )
				 Local $_RegRead = RegRead ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Run', $_RegTitleKey )
				 If $_RegRead <> '' Then TrayItemSetState ( $_StartItem, $TRAY_CHECKED )
                 TrayCreateItem ( '' )
$_TrayTipItem  = TrayCreateItem ( 'Show Sentences Read on the Screen' )
                 TrayItemSetOnEvent ( -1, '_ShowText' )
                 $_RegRead = RegRead ( $_RegKeySettings, 'ShowText' )
				 If $_RegRead = '' Or $_RegRead = 1 Then
					$_ShowText=1
					TrayItemSetState ( $_TrayTipItem, $TRAY_CHECKED )
				 Else
					$_ShowText=0
					TrayItemSetState ( $_TrayTipItem, $TRAY_UNCHECKED )
				 EndIf
                 TrayCreateItem ( '' )
$_SpeechItem   = TrayCreateItem ( 'Open Speech Properties Panel' )
                 TrayItemSetOnEvent ( -1, '_OpenSpeechProperties' )
                 TrayCreateItem ( '' )
$_SettingsItem = TrayCreateItem ( 'Settings' )
                 TrayItemSetOnEvent ( -1, '_SetGuiSettingsState' )
				 TrayCreateItem ( '' )
$_SaveToMp3Item= TrayCreateItem ( 'Save Clipboard Text To Mp3' )
                 TrayItemSetOnEvent ( -1, '_SaveToMp3' )
				 TrayCreateItem ( '' )
$_PauseItem    = TrayCreateItem ( 'Pause' )
                 TrayItemSetOnEvent ( -1, '_Pause' )
                 TrayItemSetState ( -1, $TRAY_DISABLE )
                 TrayCreateItem ( '' )
$_SpeakItem    = TrayCreateItem ( 'Speak Clipboard Text' )
                 TrayItemSetOnEvent ( -1, '_Text2Speak' )
                 TrayCreateItem ( '' )
$_AboutItem    = TrayCreateItem ( 'About' )
                 TrayItemSetOnEvent ( -1, '_About' )
				 TrayCreateItem ( '' )
$_ExitItem     = TrayCreateItem ( 'Exit' )
                 TrayItemSetOnEvent ( -1, '_Exit' )
				 TraySetClick ( 16 )
	             TraySetOnEvent ( $TRAY_EVENT_PRIMARYDOUBLE, '_Minimize' )
	             TraySetToolTip ( $_Version )
EndFunc ;==> _SetTrayMenu ( )

Func _TrayTipTimer ( )
	TrayTip ( '', '', 0, 0 )
	If Not $_EndText Then
	    GUICtrlSetData ( $_ScreenTextLabel, '' )
	    GUISetState ( @SW_HIDE, $_ScreenGui )
	EndIf
	AdlibUnRegister ( '_TrayTipTimer' )
EndFunc ;==> _TrayTipTimer ( )

Func _SetGuiSettingsState ( )
	TrayItemSetState ( $_SettingsItem, $TRAY_UNCHECKED )
	If _IsVisible ( $_Gui ) Then
	    GUISetState ( @SW_HIDE, $_Gui )
		Return 1
    Else
        GUISetState ( @SW_SHOW, $_Gui )
    EndIf
EndFunc ;==> _SetGuiSettingsState ( )

Func _OpenTopic ( )
	TrayItemSetState ( $_TitleItem, $TRAY_UNCHECKED )
    If FileExists ( $_DefaultBrowser ) Then
		ShellExecute ( 'http://www.autoitscript.com/forum/topic/137037-tinycliptospeech' )
	Else
		ShellExecute ( 'iexplore.exe', 'http://www.autoitscript.com/forum/topic/137037-tinycliptospeech' )
	EndIf
EndFunc ;==> _OpenTopic ( )

Func _ShowText ( )
	Local $_RegRead = RegRead ( $_RegKeySettings, 'ShowText' )
	If $_ShowText=1 Then
		$_ShowText=0
		TrayItemSetState ( $_TrayTipItem, $TRAY_UNCHECKED )
		RegWrite ( $_RegKeySettings, 'ShowText', 'REG_SZ', 0 )
		GUISetState ( @SW_HIDE, $_ScreenGui )
	Else
		$_ShowText=1
		TrayItemSetState ( $_TrayTipItem, $TRAY_CHECKED )
		RegWrite ( $_RegKeySettings, 'ShowText', 'REG_SZ', 1 )
		GUISetState ( @SW_SHOWNORMAL , $_ScreenGui )
	EndIf
EndFunc ;==> _ShowText ( )

Func _StartWithWindows ( )
	If Not @Compiled Then
		TrayItemSetState ( $_StartItem, $TRAY_UNCHECKED )
		MsgBox ( 262144+4096+16, '', 'Script must be Compiled !' & @CRLF, 3 )
	    Return
	EndIf
	$_ItemGetState = TrayItemGetState ( $_StartItem )
	If $_ItemGetState = $TRAY_CHECKED + $TRAY_ENABLE Then
		RegWrite ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Run', $_RegTitleKey, 'REG_SZ', @ScriptFullPath )
	Else
		RegDelete ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Run', $_RegTitleKey )
	EndIf
EndFunc ;==> _StartWithWindows ( )

Func _OpenSpeechProperties ( )
	TrayItemSetState ( $_SpeechItem, $TRAY_UNCHECKED )
	$_SapiCplPath = RegRead ( 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Cpls', 'Speech' )
	If FileExists ( $_SapiCplPath ) Then ShellExecute ( $_SapiCplPath )
EndFunc ;==> _OpenSpeechProperties ( )

Func _Minimize ( )
	If _IsVisible ( $_Gui ) Then
		GUISetState ( @SW_HIDE, $_Gui )
	Else
        GUISetState ( @SW_SHOW, $_Gui )
    EndIf
EndFunc ;==> _Minimize ( )
#EndRegion --- Tray Management ------------------------------

#Region ------ Miscellaneous ------------------------------
Func _ClipGet ( )
	_ClipBoard_Open ( 0 )
	$_ClipboardContent = ''
	If _ClipBoard_IsFormatAvailable ( $CF_TEXT ) Then $_ClipboardContent = _ClipBoard_GetData ( $CF_TEXT )
	_ClipBoard_Close ( )
    If Not $_ClipboardContent Then Return SetError ( 1, 0, 0 )
	Return $_ClipboardContent
EndFunc ;==> _ClipGet ( )

Func _IsConnected ( )
	If Ping ( 'www.bing.com', 1 ) _
	Or InetRead ( 'http://www.google.com/humans.txt', 19 ) Then Return True
EndFunc ;==> _IsConnected ( )

Func _IsVisible ( $_Hwnd )
    If BitAnd ( WinGetState ( $_Hwnd ), 2 ) Then Return 1
EndFunc ;==> _IsVisible ( )

Func _GetTaskbarHeight ( )
    $_OptOld = Opt ( 'WinTitleMatchMode', 4 )
    $_WinPos = WinGetPos ( 'classname=Shell_TrayWnd' )
    Opt ( 'WinTitleMatchMode', $_OptOld )
    Return $_WinPos[3]
EndFunc ;==> _GetTaskbarHeight ( )

Func _GetScriptVersion ( )
    If Not @Compiled Then
        Return StringTrimRight ( @ScriptName, 4 ) & ' © wakillon 2010 - ' & @YEAR
    Else
		Return StringTrimRight ( @ScriptName, 4 ) & ' v' & FileGetVersion ( @ScriptFullPath ) & ' © wakillon 2010 - ' & @YEAR
    EndIf
EndFunc ;==> _GetScriptVersion ( )

Func _GetDefaultBrowser ( )
    $_DefautBrowser = _WinAPI_AssocQueryString ( '.html', $ASSOCSTR_EXECUTABLE )
    If Not @error Then Return $_DefautBrowser
EndFunc ;==> _GetDefaultBrowser ( )
#EndRegion --- Miscellaneous ------------------------------

Func _FileMissing ( )
	If Not FileExists ( $_TempDir ) Then Return True
	If Not FileExists ( 'C:\windows\Text-to-speech.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\lame.exe' ) Then Return True
	If Not FileExists ( $_TempDir & '\Play.ico' ) Then Return True
	If Not FileExists ( $_TempDir & '\Pause.ico' ) Then Return True
EndFunc ;==> _FileMissing ( )

Func _FileInstall ( )
	If Not FileExists ( $_TempDir ) Then
	    If Not _IsConnected ( ) Then Exit MsgBox ( 262144+4112+16, "Error", 'You are Not Connected !' & @CRLF & @CRLF & _
		'Sorry but' & @CRLF & 'Some externals files need to be downloaded at first execution !', 5 )
	    DirCreate ( $_TempDir )
	EndIf
	; lame.exe
	If Not FileExists ( $_TempDir & '\lame.exe' ) Then InetGet ( 'http://tinyurl.com/7drowtx', $_TempDir & '\lame.exe', 27, 1 )
	; Icons
	If Not FileExists ( $_TempDir & '\Play.ico' ) Then InetGet ( 'http://tinyurl.com/7wnl3ht', $_TempDir & '\Play.ico', 27, 1 )
	If Not FileExists ( $_TempDir & '\Pause.ico' ) Then InetGet ( 'http://tinyurl.com/7yt5anp', $_TempDir & '\Pause.ico', 27, 1 )
    If Not FileExists ( 'C:\windows\Text-to-speech.ico' ) Then InetGet ( 'http://tinyurl.com/7lhkpnj', 'C:\windows\Text-to-speech.ico', 27, 0 )
EndFunc ;==> _FileInstall ( )

Func _DownloadWithProgress ( $_DownloadURL, $_FileName, $_DestinationDir )
    $_FileSize = InetGetSize ( $_DownloadURL )
    $_DownloadHwnd = InetGet ( $_DownloadURL, $_DestinationDir & '\' & $_FileName, 27, 1 )
    ProgressOn ( '', '', '', Default, 10, 16+1 )
    Do
        $_Percent = InetGetInfo ( $_DownloadHwnd, 0 ) * 100 / $_FileSize
        ProgressSet ( $_Percent, 'Download Progress : ' & Round ( $_Percent, 2 ) & '%' & @CRLF & _
		Round ( InetGetInfo ( $_DownloadHwnd, 0 ) / ( 1024*1024 ), 2 ) & '/' & Round ( $_FileSize / ( 1024*1024 ), 2 ) & ' MB', $_FileName )
        Sleep ( 100 )
    Until InetGetInfo ( $_DownloadHwnd, 2 )
	ProgressSet ( 100, 'Done', 'Complete' )
	InetClose ( $_DownloadHwnd )
	Sleep ( 1000 )
	ProgressOff ( )
EndFunc ;==> _DownloadWithProgress ( )

Func _About ( )
	TrayItemSetState ( $_AboutItem, $TRAY_UNCHECKED )
	Local $_GuiShow
	If _IsVisible ( $_Gui ) Then $_GuiShow = _SetGuiSettingsState ( )
	Opt ( 'TrayIconHide', 1 )
	MsgBox ( 262144+64+8192, 'About', 'Informations : ' & @CRLF & @CRLF & $_Version & @CRLF & @CRLF _
	& 'I hope this soft will be usefull to you for read your text !' & @CRLF _
	& 'Just copy text to clipboard' & @CRLF _
	& 'and click "Speak Text in ClipBoard" in Tray menu for start Reading.' & @CRLF _
	& 'Settings are automatically saved.' & @CRLF _
	& 'Mp3 quality is set by default to 64kbps 48kHz Mono.' & @CRLF _
	& 'By default your Desktop is the output directory.' & @CRLF _
	& 'Thanks to use TinyClipToSpeech !' & @CRLF & @CRLF _
	& 'Thanks to AutoIt Community.' & @CRLF & @CRLF _
	& 'wakillon.' )
	Opt ( 'TrayIconHide', 0 )
	If $_GuiShow Then _SetGuiSettingsState ( )
EndFunc ;==> _About ( )

Func _ErrFunc ( $oError ) ; http://www.autoitscript.com/autoit3/docs/intro/ComRef.htm
    Local $_ErrorMsg = @CRLF & '!->-- [' & @ScriptLineNumber & '][' & @HOUR & @MIN & @SEC & '] err.number is : ' & Hex ( $oError.number, 8 ) & @CRLF & _
                 '!     err.windescription : ' & $oError.windescription & _
                 '!     err.description is : ' & $oError.description & @CRLF & _
                 '!     err.retcode is : '     & $oError.retcode
	$_LineRead = '!     err.scriptline is : '  & $oError.scriptline & ' :==> ' & StringStripWS ( FileReadLine ( @ScriptFullPath, $oError.scriptline ), 7 )
    If @Compiled Then _FileWriteLog ( $_TempDir & '\' & @ScriptName & '.log', @CRLF & $_ErrorMsg  & @CRLF )
	$oSpeech = ''
	_CheckSapiInstall ( )
EndFunc ;==> _ErrFunc ( )

Func _Exit ( )
	If IsObj ( $oSpeech ) Then $oSpeech.Speak ( '', $SVSFPurgeBeforeSpeak )
	GUISetState ( @SW_HIDE, $_Gui )
	Exit
EndFunc ;==> _Exit ( )

Func _OnAutoItExit ( )
	TrayTip ( ' ', $_Version, 2, 1 )
	$oSpeech = ''
	GUIDelete ( $_Gui )
	Sleep ( 2000 )
	TrayTip ( '', '', 0, 0 )
EndFunc ;==> _OnAutoItExit ( )