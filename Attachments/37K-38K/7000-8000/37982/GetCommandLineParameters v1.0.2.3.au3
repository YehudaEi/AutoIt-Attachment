#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\windows\GCLP.ico
#AutoIt3Wrapper_Outfile=GetCommandLineParameters.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Tested on Xp sp3 and windows 7 32 bit
#AutoIt3Wrapper_Res_Description=Display and save command line parameters to a text file by trying switches.
#AutoIt3Wrapper_Res_Fileversion=1.0.2.3
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=P
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © wakillon 2010 - 2012
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <Constants.au3>
#Include <WinAPIEx.au3>
#include <GuiEdit.au3>
#include <String.au3>
#include <Array.au3>
#include <File.au3>
#include <Misc.au3>

If Not _Singleton ( @ScriptName, 1 ) Then Exit

Opt ( "WinWaitDelay", 0 )
Opt ( "TrayMenuMode", 1 )

Global Const $SS_CENTER = 0x1
Global $_BassModDll, $_Volume, $_VolumeOld, $_VolumeStep = 0.5
Global $_AboutGui, $_Width = 450, $_Height = 370, $_Label1, $_Label2, $_FontSize, $_Pic1
Global $_TempDir = @TempDir & '\GCLP'
Global $_LogFilePath, $_WindowText, $_ExePath
Global $_Switch[11] = [10, ' ', ' /?',' -?',' --?',' /h',' -h',' --h',' /help',' -help',' --help']
Global $_Encoding[5]=[0,32,64,128,256]
Global $_Ratio = 2 * ( UBound ( $_Switch ) -1 ) /100
Global $_Version = _GetVersion ( )
Global $_TxtFileLocItem1, $_TxtFileLocItem2, $_AboutItem, $_ExitItem, $_TxtFileLoc, $_AskNotepadItem, $_AskNotepad, $_TitleItem, $_OverWriteItem, $_OverWrite, $_UninstallItem

#Region ; Install contextual menu for first execution.
If @Compiled Then
    $_RegRead = RegRead ( 'HKCR\exefile\shell\Get Command Line Parameters\Command', '' )
    If Not StringInStr ( $_RegRead, @ScriptFullPath ) Then
		RegWrite ( 'HKCR\exefile\shell\Get Command Line Parameters\Command', '', 'REG_SZ', '"' & @ScriptFullPath & '" "%1"' )
		RegWrite ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\exefile\shell\Get Command Line Parameters\Command', '', 'REG_SZ', '"' & @ScriptFullPath & '" "%1"')
	    Exit MsgBox ( 262144, 'Get Command Line Parameters', _
        _StringRepeat ( ' ', 30 ) & 'Contextual menu installed !' & _StringRepeat ( ' ', 60 ) & @CRLF & _
		_StringRepeat ( ' ', 30 ) & 'Now you can Right click on exe file' & @CRLF & _
		_StringRepeat ( ' ', 30 ) & 'and Select Get Command Line Parameters !' & @CRLF & @CRLF & _
		_StringRepeat ( ' ', 30 ) & "( Don't Move the executable )" & @CRLF & @CRLF & _
		_StringRepeat ( ' ', 30 ) & 'Type ESC at anytime for Quit', 10 )
        RegWrite ( 'HKCU\Software\GetCommandLineParameters', 'AskNotepad', 'REG_SZ', True )
		RegWrite ( 'HKCU\Software\GetCommandLineParameters', 'TxtFileLoc', 'REG_SZ', @DesktopDir )
		RegWrite ( 'HKCU\Software\GetCommandLineParameters', 'OverWrite', 'REG_SZ', True )
	EndIf
EndIf
#EndRegion

If $CMDLine[0] > 0 Then
	If StringInStr ( $CmdLine[1], '/Uninstall' ) Then _Uninstall ( )
    $_ExePath = FileGetLongName ( $CmdLine[1] )
Else
	If Not @Compiled Then Exit MsgBox ( 262144, 'Get Command Line Parameters', 'Use me Compiled !', 10 )
	Exit MsgBox ( 262144, 'Get Command Line Parameters', 'Right click on an cmd-line tool executable file' & @CRLF & 'and Select Get Command Line Parameters for find them.' & @CRLF & @CRLF & 'Type ESC for Quit', 10 )
EndIf

If _IsSupportedApp ( $_ExePath ) <> True Then Exit MsgBox ( 262144, 'Error', 'Application Type Not Supported !', 5 )
OnAutoItExitRegister ( '_OnAutoItExit' )
HotKeySet ( '{ESC}', '_Exit' )

Global $_ProcessName = _GetNameWithoutExtByFullPath ( $_ExePath )
Global $_TextFileName = $_ProcessName & '.txt'
Global $_ProcessFullName = $_ProcessName & '.exe'
Global $_TxtFile = $_TxtFileLoc & '\' & $_TextFileName
Global $_StderrRead='', $_StdReadAll='', $_Usage
Global $_WindowTitle='  Get command line parameters of ' & $_ProcessFullName
Global $_W=710, $_H=440, $_XPos=-1, $_YPos=-1, $_Opt=4+16, $_FontName='Arial', $_FontSize=11, $_FontWeight=800
Global $_StdRead, $_StdReadAll, $_I, $Hwnd, $_Pid1, $_Pid2, $_PidArray[1]
Global $_Gui, $_Edit, $_CreateButton, $_TryButton, $_FileRead, $_ExitButton, $_Progress, $_P
Global $_PromptButton, $_ChildWin, $_Invert=True, $_Label0, $_Input, $_InDosBoxOld, $_LabelHeight
Global $_Radio[UBound ( $_Switch )+1]
Global $_CmdPath = FileGetShortName ( $_ExePath )
If @error Then $_CmdPath = '"' & $_ExePath & '"'

_FileInstall ( )
_Tray ( )
_Gui ( )
_SetButtonsState ( )
$_Find = _FindByLog ( )

If $_Find Then
	_GUICtrlEdit_SetText ( $_Edit, '' )
	If Not $_WindowText Then
		_GUICtrlEdit_AppendText ( $_Edit, _StringStripSquares ( _OEMToChar ( _FileReadWithGoodEncoding ( ) ) ) & @CRLF )
	Else
	    _GUICtrlEdit_AppendText ( $_Edit, _StringStripSquares ( $_WindowText ) & @CRLF )
	EndIf
Else
    $_Usage = _FindByStd ( )
	_GUICtrlEdit_SetText ( $_Edit, '' )
    If $_Usage Then _GUICtrlEdit_AppendText ( $_Edit, _StringStripSquares ( _OEMToChar ( $_StdReadAll ) ) & @CRLF )
EndIf

_SetButtonsState ( )
If Not $_Usage And Not $_Find Then
    _GUICtrlEdit_SetText ( $_Edit, '' )
    _GUICtrlEdit_AppendText ( $_Edit, 'Nothing Found !' & @CRLF & 'You can now try switches manually...' & @CRLF )
EndIf
_ShowRadioButtons ( )

#Region ; Main Loop
While 1
	$_Msg = GUIGetMsg ( )
	Switch $_Msg
		Case $GUI_EVENT_CLOSE, $_ExitButton
			_Exit ( )
		Case $_CreateButton
			$_TxtFile = $_TxtFileLoc & '\' & $_TextFileName
			If $_OverWrite Then
			    FileDelete ( $_TxtFile )
			Else
			    $_TxtFile = _GetFreePath ( $_TxtFile )
			EndIf
			If $_Invert Then
			    $_ClipGet = ClipGet ( )
			    If $_ClipGet Then
			    	FileWrite ( $_TxtFile, $_ClipGet )
			    Else
	                FileWrite ( $_TxtFile, StringReplace ( _GUICtrlEdit_GetText ( $_Edit ), 'Wait while Trying Switch...', '' ) )
			    EndIf
		    Else
				WinSetState ( $_ChildWin, '', @SW_ENABLE )
				BlockInput ( 1 )
				_CopyDosWindow ( $_ChildWin )
				BlockInput ( 0 )
				WinSetState ( $_ChildWin, '', @SW_DISABLE )
				FileWrite ( $_TxtFile, ClipGet ( ) )
			EndIf
			ClipPut ( '' )
			If $_AskNotepad Then
                If MsgBox ( 262144+4, 'Success', 'The Text File ' & $_TxtFile & ' was created' & @CRLF & @CRLF & 'Do you want to open it in notepad ?', 6 ) = 6 Then Run ( 'notepad ' & $_TxtFile )
			Else
				_TrayTip ( 'Success', 'The Text File ' & $_TxtFile & ' was created', 1, 3000 )
			EndIf
		Case $_TryButton
			_GUICtrlEdit_SetText ( $_Edit, '' )
			_SetButtonsState ( )
			For $_I = 1 To UBound ( $_Radio ) -1
				If GUICtrlRead ( $_Radio[$_I] ) = 1 Then
					If $_I = UBound ( $_Radio ) -1 Then
						If GUICtrlRead ( $_Input ) <> '' Then
						     $_Parameters = ' ' & GUICtrlRead ( $_Input )
						Else
						    ContinueLoop
						EndIf
					Else
						$_Parameters = $_Switch[$_I]
                    EndIf
				    If $_Invert Then
						_TrySwitch ( $_Parameters )
				    Else
				        _SendCommand ( $_CmdPath & $_Parameters )
				    EndIf
				EndIf
			Next
			_SetButtonsState ( )
		Case $_PromptButton
            GUISetState ( @SW_LOCK, $_Gui )
			If $_Invert Then
				GUICtrlSetData ( $_PromptButton, 'Use Edit Box' )
				GUIRegisterMsg ( $WM_PAINT, '_WM_PAINT' )
                GUICtrlSetState ( $_Edit, $GUI_HIDE )
				Sleep ( 10 )
				WinSetState ( $_ChildWin, '', @SW_SHOW )
				GUICtrlSetState ( $_Label0, $GUI_SHOW )
				GUICtrlSetTip ( -1, 'Use Edit Box Instead of Dos Prompt', 'Infos : ', 1 )
				GUISetBkColor ( 0x008000, $_Gui )
		    Else
				GUICtrlSetData ( $_PromptButton, 'Use Dos Prompt' )
			    WinSetState ( $_ChildWin, '', @SW_HIDE )
                GUICtrlSetState ( $_Edit, $GUI_SHOW )
				GUIRegisterMsg ( $WM_PAINT, '' )
				GUICtrlSetState ( $_Label0, $GUI_HIDE )
				GUICtrlSetTip ( -1, 'Use Dos Prompt Instead of Edit Box', 'Infos : ', 1 )
				GUISetBkColor ( 0xFEAD0A, $_Gui )
			EndIf
			$_Invert = Not $_Invert
			GUISetState ( @SW_UNLOCK, $_Gui )
	EndSwitch
	$_CursorInfo = GUIGetCursorInfo ( $_Gui )
	If Not @error Then
	    If ( $_CursorInfo[2] Or $_CursorInfo[3] ) And $_CursorInfo[4] = $_Input Then
	        GUICtrlSetData ( $_Input, '' )
	        GUICtrlSetState ( $_Radio[UBound ( $_Switch )], $GUI_CHECKED )
		EndIf
		If Not $_Invert Then
			If $_CursorInfo[0] > $_LabelHeight And $_CursorInfo[0]  < 681 And $_CursorInfo[1] > $_LabelHeight And $_CursorInfo[1] < 323 Then
				$_InDosBox = True
		    Else
				$_InDosBox = False
		    EndIf
			If $_InDosBox <> $_InDosBoxOld Then
				If $_InDosBox Then
					WinSetState ( $_ChildWin, '', @SW_ENABLE )
				Else
					WinSetState ( $_ChildWin, '', @SW_DISABLE )
					If _IsActived ( $_ChildWin ) Then WinActivate ( $_Gui )
				EndIf
				$_InDosBoxOld = $_InDosBox
			EndIf
		EndIf
	EndIf
    $_TrayMsg = TrayGetMsg ( )
    Switch $_TrayMsg
		Case $_TitleItem
			TrayItemSetState ( $_TitleItem, $TRAY_UNCHECKED )
			If FileExists ( _GetDefaultBrowser ( ) ) Then
		        ShellExecute ( 'http://www.autoitscript.com/forum/topic/118856-get-command-line-parameters-utility' )
		    Else
		        ShellExecute ( 'iexplore.exe', 'http://www.autoitscript.com/forum/topic/118856-get-command-line-parameters-utility' )
		    EndIf
		Case $_AskNotepadItem
			$_AskNotepad = Not $_AskNotepad
			RegWrite ( 'HKCU\Software\GetCommandLineParameters', 'AskNotepad', 'REG_SZ', $_AskNotepad )
			If $_AskNotepad = True Then
				TrayItemSetState ( $_AskNotepadItem, $TRAY_CHECKED )
			Else
				TrayItemSetState ( $_AskNotepadItem, $TRAY_UNCHECKED )
			EndIf
        Case $_TxtFileLocItem1
			$_TxtFileLoc = @DesktopDir
			TrayItemSetState ( $_TxtFileLocItem1, $TRAY_CHECKED )
			TrayItemSetState ( $_TxtFileLocItem2, $TRAY_UNCHECKED )
			RegWrite ( 'HKCU\Software\GetCommandLineParameters', 'TxtFileLoc', 'REG_SZ', $_TxtFileLoc )
			$_TxtFile = $_TxtFileLoc & '\' & $_TextFileName
		Case $_TxtFileLocItem2
			$_TxtFileLoc = _GetParentFolderPathByFullPath ( $_ExePath )
			TrayItemSetState ( $_TxtFileLocItem2, $TRAY_CHECKED )
			TrayItemSetState ( $_TxtFileLocItem1, $TRAY_UNCHECKED )
			RegWrite ( 'HKCU\Software\GetCommandLineParameters', 'TxtFileLoc', 'REG_SZ', $_TxtFileLoc )
			$_TxtFile = $_TxtFileLoc & '\' & $_TextFileName
        Case $_OverWriteItem
            $_OverWrite = Not $_OverWrite
			RegWrite ( 'HKCU\Software\GetCommandLineParameters', 'OverWrite', 'REG_SZ', $_OverWrite )
			If $_OverWrite Then
				TrayItemSetState ( $_OverWriteItem, $TRAY_CHECKED )
			Else
				TrayItemSetState ( $_OverWriteItem, $TRAY_UNCHECKED )
			EndIf
        Case $_AboutItem
			_AboutGui ( )
			GUIRegisterMsg ( $WM_PAINT, '' )
			GUISetState ( @SW_HIDE, $_Gui )
			Opt ( 'TrayIconHide', 1 )
            _Play ( )
            _About ( )
			If FileExists ( @TempDir & '\About\BASSMOD.dll' ) And $_BassModDll Then
				DllCall ( $_BassModDll, 'int', 'BASSMOD_MusicStop' )
				DllCall ( $_BassModDll, 'int', 'BASSMOD_SetVolume', 'int', $_VolumeOld )
				DllCall ( $_BassModDll, 'int:cdecl', 'BASSMOD_MusicFree' )
		        DllCall ( $_BassModDll, 'int', 'BASSMOD_Free' )
                DllClose ( $_BassModDll )
            EndIf
            GUIDelete ( $_AboutGui )
			GUISetState ( @SW_SHOW, $_Gui )
			GUIRegisterMsg ( $WM_PAINT, '_WM_PAINT' )
			TrayItemSetState ( $_AboutItem, $TRAY_UNCHECKED )
			WinActivate ( $_ChildWin )
			WinActivate ( $_Gui )
			Opt ( 'TrayIconHide', 0 )
		Case $_UninstallItem
			_Uninstall ( )
        Case $_ExitItem
            _Exit ( )
    EndSwitch
WEnd
#EndRegion ; Main Loop

Func _TrySwitch ( $_Param )
	_GUICtrlEdit_AppendText ( $_Edit, @CRLF & 'Wait while Trying Switch...' & @CRLF & @CRLF )
	For $_I = 1 To UBound ( $_Switch ) -1
		If GUICtrlRead ( $_Radio[$_I] ) = $GUI_CHECKED Then $_Param = $_Switch[$_I]
	Next
    Local $_Run = @ComSpec & ' /c ' & $_CmdPath & $_Param
	$_Pid = Run ( $_Run, '', @SW_HIDE, $STDERR_MERGED )
	_ArrayAdd ( $_PidArray, $_Pid )
	Local $_ProcessTimerInit = TimerInit ( )
	$_StdReadAll =''
	$_WindowText =''
	$_Pid2 = ProcessExists ( $_ProcessFullName )
	_ArrayAdd ( $_PidArray, $_Pid2 )
	While $_StdReadAll='' Or ProcessExists ( $_Pid )
		$_StdoutRead = StdoutRead ( $_Pid )
		If $_StdoutRead Then $_StdReadAll = $_StdReadAll & $_StdoutRead & @CRLF
		If Not $_WindowText Then $_WindowText = _ProcessWindow ( $_ProcessFullName )
		If $_WindowText Or TimerDiff ( $_ProcessTimerInit ) / 1000 > 2 Then ExitLoop
	WEnd
	If ProcessExists ( $_Pid ) Then _CloseProcess ( $_Pid )
	If ProcessExists ( $_Pid2 ) Then _CloseProcess ( $_Pid2 )
	If StringLen ( _GUICtrlEdit_GetText ( $_Edit ) ) >= _GUICtrlEdit_GetLimitText ( $_Edit )/3 Then _GUICtrlEdit_SetText ( $_Edit, '' )
	If $_StdReadAll = '' Then $_StdReadAll = 'No return...'
	If Not $_WindowText Then
		_GUICtrlEdit_AppendText ( $_Edit, _StringStripSquares ( _OEMToChar ( $_StdReadAll ) ) & @CRLF )
	Else
		_GUICtrlEdit_AppendText ( $_Edit, _StringStripSquares ( $_WindowText ) & @CRLF )
	EndIf
EndFunc ;==> _TrySwitch ( )

Func _FindByStd ( )
    For $_I = 1 To UBound ( $_Switch ) -1
	    $_Run = @ComSpec & ' /c ' & $_CmdPath & $_Switch[$_I]
		$_P = $_P +1
		GUICtrlSetData ( $_Progress, $_P/$_Ratio )
	    $_Pid1 = Run ( $_Run, '', @SW_HIDE, $STDERR_MERGED )
		_ArrayAdd ( $_PidArray, $_Pid1 )
	    Local $_ProcessTimerInit = TimerInit ( )
	    $_StdReadAll =''
	    While $_StdReadAll='' Or ProcessExists ( $_Pid1 )
		    $_StdoutRead = StdoutRead ( $_Pid1 )
	    	If $_StdoutRead Then
			    $_StdReadAll = $_StdReadAll & $_StdoutRead & @CRLF
				If _OneOfThisStringInStr ( $_StdReadAll, 'Incorrect DOS version|Runtime error|run-time error' ) <> 0 Then
					GUISetState ( @SW_HIDE, $_Gui )
				    Exit MsgBox ( 262144, 'Command line parameters of ' & $_ProcessFullName & '        ', 'Incorrect DOS version Or Runtime error !' )
				EndIf
			EndIf
			_ProcessWindow ( $_ProcessFullName )
	      	If TimerDiff ( $_ProcessTimerInit ) / 1000 > 0.5 Then ExitLoop
		WEnd
		If ProcessExists ( $_Pid1 ) Then _CloseProcess ( $_Pid1 )
		If ProcessExists ( $_Pid2 ) Then _CloseProcess ( $_Pid2 )
		ClipPut ( '' )
		If StringInStr ( $_StdReadAll, '[' ) And StringInStr ( $_StdReadAll, ']' ) Then Return 1
		If Not _OneOfThisStringInStr ( $_StdReadAll, 'missing|failed|wrong|invalid|unrecognized' ) And _
		    _OneOfThisStringInStr ( $_StdReadAll, 'usage|display|syntax|parameter|option|commands|ErrorLevel' ) Then Return 1
    Next
EndFunc ;==> _FindByStd ( )

Func _FindByLog ( )
	For $_I = 1 To UBound ( $_Switch ) -1
        $_LogFilePath = _TempFile ( $_TempDir, '', '.log', 7 )
    	$_CmdPath = FileGetShortName ( $_ExePath )
	    If @error Then $_CmdPath = '"' & $_ExePath & '"'
		$_P = $_P +1
		$_WindowText=''
		GUICtrlSetData ( $_Progress, $_P/$_Ratio )
	    $_Run = @ComSpec & ' /c ' & $_CmdPath & $_Switch[$_I] & ' > ' & $_LogFilePath
	    $_Pid1 = Run ( $_Run, '', @SW_HIDE )
		_ArrayAdd ( $_PidArray, $_Pid1 )
	    Local $_ProcessTimerInit = TimerInit ( )
	    While ProcessExists ( $_Pid1 )
	        If Not $_WindowText Then $_WindowText = _ProcessWindow ( $_ProcessFullName )
			If $_WindowText <> '' Or TimerDiff ( $_ProcessTimerInit ) / 1000 > 1 Then ExitLoop
		WEnd
		If ProcessExists ( $_Pid1 ) Then _CloseProcess ( $_Pid1 )
		If ProcessExists ( $_Pid2 ) Then _CloseProcess ( $_Pid2 )
		ClipPut ( '' )
		If Not $_WindowText Then
		    $_StdReadAll = _FileReadWithGoodEncoding ( )
		Else
		    $_StdReadAll = $_WindowText
		EndIf
		If StringInStr ( $_StdReadAll, '[' ) And StringInStr ( $_StdReadAll, ']' ) Then Return 1
		If Not _OneOfThisStringInStr ( $_StdReadAll, 'missing|failed|wrong|invalid|unrecognized' ) And _
			_OneOfThisStringInStr ( $_StdReadAll, 'usage|display|syntax|parameter|option|commands|ErrorLevel' ) Then Return 1
    Next
EndFunc ;==> _FindByLog ( )

Func _ProcessWindow ( $_ProcName )
	$_Pid2 = ProcessExists ( $_ProcName )
	_ArrayAdd ( $_PidArray, $_Pid2 )
	Local $_ProcessWinList = _WinAPI_EnumProcessWindows ( $_Pid2 )
	If IsArray ( $_ProcessWinList ) Then
		For $_J = 1 To UBound ( $_ProcessWinList ) -1
			If _IsVisible ( $_ProcessWinList[$_J][0] ) And $_ProcessWinList[$_J][0] <> $_Gui Then
				$_Text = WinGetText ( $_ProcessWinList[$_J][0] )
				If $_Text Then
					If StringInStr ( $_Text, 'license' ) Then
						WinWaitClose ( $_ProcessWinList[$_J][0] )
					Else
						WinClose ( $_ProcessWinList[$_J][0] )
						Return $_Text
					EndIf
				EndIf
			EndIf
		Next
	EndIf
EndFunc ;==> _ProcessWindow ( )

Func _FileReadWithGoodEncoding ( )
	For $_E = 0 To UBound ( $_Encoding ) -1
		$_FileOpen = FileOpen ( $_LogFilePath, $_Encoding[$_E] )
		If @error Then ContinueLoop
		$_FileRead = FileRead ( $_FileOpen )
		FileClose ( $_FileOpen )
		If StringInStr ( $_FileRead, $_ProcessName ) Then Return $_FileRead
	Next
EndFunc ;==> _FileReadWithGoodEncoding ( )

Func _Gui ( )
    $_Gui = GUICreate ( $_WindowTitle, $_W, $_H, $_XPos, $_YPos )
	GUISetBkColor ( 0xFEAD0A, $_Gui )
	GUISetIcon ( 'cmd.exe' )
	$_Progress = GUICtrlCreateProgress ( 29, 353, 650, 20 )
    $_Edit = GUICtrlCreateEdit ( '', 20, 20, 669, 312, $ES_AUTOVSCROLL + $WS_VSCROLL )
    GUICtrlSetFont ( -1, $_FontSize, $_FontWeight, Default, $_FontName )
    GUICtrlSetBkColor ( -1, 0x000000 )
    GUICtrlSetColor ( -1, 0xFEAD0A )
	GUICtrlSetState ( -1, $GUI_FOCUS )
    _GUICtrlEdit_AppendText ( $_Edit, 'Wait while searching parameters...' & @CRLF & @CRLF )
    $_CreateButton = GUICtrlCreateButton ( 'Create Txt File', 364, 400, 150, Default )
	GUICtrlSetTip ( -1, 'Create a text file with the process name on your desktop.' & @CRLF & _
	                    'With the Edit Box : ' & @CRLF & _
	                    'You can select and copy text in Edit Box before clicking this button for create it,' & @CRLF & _
						'otherwise all edit Box is copied.' & @CRLF & _
						'With Dos Prompt : ' & @CRLF & _
						'all content is copied.', 'Infos : ', 1 )
	GUICtrlSetFont ( -1, 11, 900, 1 )
    $_TryButton = GUICtrlCreateButton ( 'Try Switch', 20, 400, 150, Default )
	GUICtrlSetFont ( -1, 11, 900, 1 )
	GUICtrlSetTip ( -1, 'Select a switch before trying it', 'Infos : ', 1 )
	$_PromptButton = GUICtrlCreateButton ( 'Use Dos Prompt', 192, 400, 150, Default )
	GUICtrlSetTip ( -1, 'Use Dos Prompt Instead of Edit Box', 'Infos : ', 1 )
	GUICtrlSetFont ( -1, 11, 900, 1 )
	$_ExitButton = GUICtrlCreateButton ( 'Exit', 537, 400, 150, Default )
	GUICtrlSetFont ( -1, 11, 900, 1 )
    For $_I = 1 To UBound ( $_Switch ) -1
        $_Radio[$_I] = GUICtrlCreateRadio ( $_Switch[$_I], 30 + ( $_I-1 )*53, 353, 50 )
		GUICtrlSetState ( $_Radio[$_I], $GUI_HIDE )
	Next
	GUICtrlSetData ( $_Radio[1], 'none' )
	GUICtrlSetState ( $_Radio[1], $GUI_CHECKED )
	$_Radio[UBound ( $_Switch )] = GUICtrlCreateRadio ( 'custom', 30 + ( UBound ( $_Switch )-1 )*53, 353, 50 )
	GUICtrlSetState ( $_Radio[UBound ( $_Switch )], $GUI_HIDE )
	$_Input = GUICtrlCreateInput ( '', 615, 353, 65, 20 )
	GUICtrlSetState ( $_Input, $GUI_HIDE )
	GUICtrlCreateGroup ( '', 20, 335, 667, 45 )
    Local $_PidCmd = Run ( @SystemDir & '\cmd.exe', @SystemDir, @SW_HIDE )
	_ArrayAdd ( $_PidArray, $_PidCmd )
	ProcessWait ( $_PidCmd )
	Do
        $_ChildWin = _GetWinProcessHandle ( $_PidCmd )
	Until $_ChildWin
	WinSetState ( $_ChildWin, "", @SW_DISABLE )
    _SetParent ( $_ChildWin, $_Gui )
    WinMove ( $_ChildWin, '', 20, 00, 669, 332 )
    Sleep ( 100 )
	$_Label0 = GUICtrlCreateLabel ( '', 20, 00, 669, 30 )
	GUICtrlSetState ( -1, $GUI_HIDE )
	GUICtrlSetState ( -1, $GUI_ONTOP )
	WinSetTrans ( $_Gui, '', 210 )
    GUISetState ( @SW_SHOW, $_Gui )
EndFunc	;==> _Gui ( )

Func _Uninstall ( )
	RegDelete ( 'HKCU\Software\GetCommandLineParameters' )
	RegDelete ( 'HKCR\exefile\shell\Get Command Line Parameters' )
	RegDelete ( 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\exefile\shell\Get Command Line Parameters' )
	Exit MsgBox ( 262144, 'Uninstall', 'Get Command Line Parameters was uninstalled !', 5 )
EndFunc	;==> _Uninstall ( )

Func _Tray ( )
    TraySetIcon ( 'cmd.exe' )
	TraySetToolTip ( $_Version & @CRLF & 'Type Esc for Quit' )
	$_TitleItem = TrayCreateItem ( $_Version )
    TrayCreateItem ( '' )
	$_AskNotepadItem = TrayCreateItem ( 'Ask for Open Txt File in Notepad' )
	$_RegRead = RegRead ( 'HKCU\Software\GetCommandLineParameters', 'AskNotepad' )
    If @error Or $_RegRead = 'True' Then
		$_AskNotepad = True
		TrayItemSetState ( $_AskNotepadItem, $TRAY_CHECKED )
	Else
		$_AskNotepad = False
		TrayItemSetState ( $_AskNotepadItem, $TRAY_UNCHECKED )
	EndIf
    TrayCreateItem ( '' )
	$_TxtFileLocItem1 = TrayCreateItem ( 'Txt File location : on Desktop' )
	$_TxtFileLocItem2 = TrayCreateItem ( 'Txt File location : in exe Directory' )
	$_RegRead = RegRead ( 'HKCU\Software\GetCommandLineParameters', 'TxtFileLoc' )
    If @error Or $_RegRead = @DesktopDir Then
		$_TxtFileLoc = @DesktopDir
		TrayItemSetState ( $_TxtFileLocItem1, $TRAY_CHECKED )
	Else
		$_TxtFileLoc = _GetParentFolderPathByFullPath ( $_ExePath )
		TrayItemSetState ( $_TxtFileLocItem2, $TRAY_CHECKED )
	EndIf
    TrayCreateItem ( '' )
    $_OverWriteItem = TrayCreateItem ( 'OverWrite previous Text file' )
	$_RegRead = RegRead ( 'HKCU\Software\GetCommandLineParameters', 'OverWrite' )
    If @error Or $_RegRead = 'True' Then
		$_OverWrite = True
		TrayItemSetState ( $_OverWriteItem, $TRAY_CHECKED )
	Else
		$_OverWrite = False
		TrayItemSetState ( $_OverWriteItem, $TRAY_UNCHECKED )
	EndIf
	TrayCreateItem ( '' )
    $_AboutItem = TrayCreateItem ( 'About' )
    TrayItemSetState ( -1, $TRAY_UNCHECKED )
	TrayCreateItem ( '' )
    $_UninstallItem = TrayCreateItem ( 'Uninstall Context menu' )
	TrayCreateItem ( '' )
	$_ExitItem = TrayCreateItem ( 'Exit' )
    TrayItemSetState ( -1, $TRAY_UNCHECKED )
	TraySetState ( 4 )
EndFunc ;==> _Tray ( )

Func _IsVisible ( $_Hwnd )
    If BitAnd ( WinGetState ( $_Hwnd ), 2 ) Then Return 1
EndFunc ;==> _IsVisible ( )

Func _IsActived ( $_Hwnd )
    If BitAnd ( WinGetState ( $_Hwnd ), 8 ) Then Return 1
EndFunc ;==> _IsActived ( )

Func _OneOfThisStringInStr ( $_InStr, $_String )
    $_StringArray = StringSplit ( $_String, '|', 1+2 )
	If @error Then Return
    For $_I = 0 To UBound ( $_StringArray ) -1
        If StringInStr ( $_InStr, $_StringArray[$_I] ) Then Return 1
    Next
EndFunc ;==> _OneOfThisStringInStr ( )

Func _OEMToChar ( $_OEMStream )
    Local $_Ret = DllCall ( 'user32.dll', 'Int', 'OemToChar', 'str', $_OEMStream, 'str', '' )
    If Not @error Then Return $_Ret[2]
EndFunc ;==> _OEMToChar ( )

Func _StringCountLines ( $_String )
	Local $_StringReplace = StringReplace ( $_String, @CR, @CR )
	Return @extended
EndFunc ;==> _StringCountLines ( )

Func _GetNameWithoutExtByFullPath ( $_FullPath )
	Local $_FileName = StringSplit ( $_FullPath, '\' )
	If Not @error Then Return StringLeft ( $_FileName[$_FileName[0]], StringInStr ( $_FileName[$_FileName[0]], '.', 0, -1 ) - 1 )
EndFunc ;==> _GetNameWithoutExtByFullPath ( )

Func _GetParentFolderPathByFullPath ( $_FullPath )
	$_FilePath = StringLeft ( $_FullPath, StringInStr ( $_FullPath, '\', 0, -1 ) - 1 )
	If Not @error Then Return $_FilePath
EndFunc ;==> _GetParentFolderPathByFullPath ( )

Func _GetFreePath ( $_FilePath )
	Local $_N='', $_NewPath
	Do
		$_NewPath = _InsertStringBeetweenNameAndExt ( $_FilePath, $_N )
		$_N = $_N + 1
	Until Not FileExists ( $_NewPath )
	Return $_NewPath
EndFunc ;==> _GetFreePath ( )

Func _InsertStringBeetweenNameAndExt ( $_FullPath, $_InsertString )
	Local $szDrive, $szDir, $szFName, $szExt
    $TestPath = _PathSplit ( $_FullPath, $szDrive, $szDir, $szFName, $szExt )
	Return $szDrive & $szDir & $szFName & $_InsertString & $szExt
EndFunc ;==> _InsertStringBeetweenNameAndExt ( )

Func _CopyDosWindow ( $_Title, $_Text='' )
	SendKeepActive ( $_Title, $_Text='' )
	Send ( '!{SPACE}{DOWN 6}{RIGHT}{DOWN 3}{ENTER 2}' )
	Return ClipGet ( )
EndFunc ;==> _CopyDosWindow ( )

Func _SendCommand ( $_Command )
    ControlSend ( $_ChildWin, '', '', $_Command & '{ENTER}' )
EndFunc ;==> _SendCommand ( )

Func _SetParent ( $hWndChild, $hWndParent )
    Local $_Ret = DllCall ( 'User32.dll', 'hwnd', 'SetParent', 'hwnd', $hWndChild, 'hwnd', $hWndParent )
    If Not @error Then Return $_Ret[0]
EndFunc ;==> _SetParent ( )

Func _GetWinProcessHandle ( $_Pid )
	Local $_WinList = WinList ( '[REGEXPCLASS:ConsoleWindow]' )
	For $_W = 1 To UBound ( $_WinList ) -1
		If WinGetProcess ( $_WinList[$_W][1] ) = $_Pid Then Return $_WinList[$_W][1]
	Next
EndFunc ;==> _GetWinProcessHandle ( )

Func _GetVersion ( )
    If Not @Compiled Then
        Return StringTrimRight ( @ScriptName, 4 ) & ' © wakillon 2010 - ' & @YEAR
    Else
		Return StringTrimRight ( @ScriptName, 4 ) & ' v' & FileGetVersion ( @ScriptFullPath ) & ' © wakillon 2010 - ' & @YEAR
    EndIf
EndFunc ;==> _GetVersion ( )

Func _WM_PAINT ( $hWnd, $Msg, $wParam, $lParam )
	Sleep ( 10 )
    DllCall ( 'user32.dll', 'int', 'InvalidateRect', 'hwnd', $hWnd, 'ptr', 0, 'int', 0 )
	GUICtrlSetState ( $_Label0, $GUI_ONTOP )
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_PAINT ( )

Func _CloseProcess ( $_Process )
	Do
		ProcessClose ( $_Process )
	Until Not ProcessExists ( $_Process )
EndFunc ;==> _CloseProcess ( )

Func _IsSupportedApp ( $_FilePath )
    Local $aRes = DllCall ( 'kernel32.dll', 'bool', 'GetBinaryTypeW', 'wstr', $_FilePath, 'dword*', 0 )
    If Not @error And $aRes[0] Then
		Switch @OSArch
			Case "IA64", "X64"
				Return $aRes[2] < 7
			Case "X86"
	            Return $aRes[2] < 2
		EndSwitch
	EndIf
EndFunc ;==> _IsSupportedApp ( )

Func _ShowRadioButtons ( )
    GUICtrlSetState ( $_Progress, $GUI_HIDE )
    For $_I = 1 To UBound ( $_Switch ) -1
	    GUICtrlSetState ( $_Radio[$_I], $GUI_SHOW )
    Next
    GUICtrlSetState ( $_Radio[UBound ( $_Switch )], $GUI_SHOW )
    GUICtrlSetState ( $_Input, $GUI_SHOW )
EndFunc ;==> _ShowRadioButtons ( )

Func _SetButtonsState ( )
    Local $_State = $GUI_ENABLE
	If GUICtrlGetState ( $_TryButton ) = $GUI_ENABLE + $GUI_SHOW Then $_State = $GUI_DISABLE
    GUICtrlSetState ( $_TryButton, $_State )
    GUICtrlSetState ( $_PromptButton, $_State )
    GUICtrlSetState ( $_CreateButton, $_State )
    GUICtrlSetState ( $_ExitButton, $_State )
EndFunc ;==> _SetButtonsState ( )

Func _StringStripSquares ( $_Txt )
    ; remove Line Feed, Carriage Return or Back Spaces who appears as squares.
	For $_I = 1 To StringLen ( $_Txt )
	    If StringMid ( $_Txt, $_I, 1 ) = Chr ( 8 ) And $_I > 1 Then $_Txt = StringMid ( $_Txt, 1, $_I-2 ) & StringMid ( $_Txt, $_I+1, StringLen ( $_Txt ) )
	Next
	$_Txt = StringReplace ( $_Txt, Chr ( 13 ), '|*|' )
	$_Txt = StringReplace ( $_Txt, Chr ( 10 ), '|*|' )
	$_Txt = StringReplace ( $_Txt, '|*|', @CRLF )
    Return StringReplace ( StringReplace ( $_Txt, @CRLF & @CRLF, @CRLF ), @CRLF & @CRLF, @CRLF )
EndFunc ;==> _StringStripSquares ( )

Func _About ( )
    GUISetState ( @SW_SHOW, $_AboutGui )
    Local $_Label1YCoord = $_Height, $_Step = 1, $_FontSize=11
    While 1
		Local $_CursorInfoArray = GUIGetCursorInfo ( $_AboutGui )
		If Not @error And $_CursorInfoArray[4] = $_Label2 And $_CursorInfoArray[2] Then
			If FileExists ( _GetDefaultBrowser ( ) ) Then
		        ShellExecute ( 'http://www.autoitscript.com/site/donate/' )
		    Else
		        ShellExecute ( 'iexplore.exe', 'http://www.autoitscript.com/site/donate/' )
		    EndIf
		EndIf
        $_Count = 0
        $_Label1YCoord -= $_Step
		$_Label1Pos = ControlGetPos ($_AboutGui, '', $_Label1 )
        If $_Label1Pos[1] > - ( $_Height-120 ) Then ControlMove ( $_AboutGui, '', $_Label1, 0, $_Label1YCoord )
		$_Label2State = GUICtrlGetState ( $_Label2 )
		If $_Label2State = $GUI_SHOW + $GUI_ENABLE Then
			$_Label2Pos = ControlGetPos ( $_AboutGui, '', $_Label2 )
            If $_Label2Pos[1] > 80 Then
				ControlMove ( $_AboutGui, '', $_Label2, 0, $_Label2Pos[1]-1 )
			Else
				If $_Label1Pos[1] <= - ( $_Height-120 ) Then
					$_FontSize+= 0.5
					If $_FontSize > 70 Then
						$_Volume -= $_VolumeStep
						If $_Volume >= 0 Then
						    DllCall ( $_BassModDll, 'int', 'BASSMOD_SetVolume', 'int', $_Volume )
							$_TransLevel = 255 - ( $_FontSize - 70 ) * 8
							If $_TransLevel >= 0 Then WinSetTrans ( $_AboutGui, '', $_TransLevel )
						Else
					        Return
						EndIf
					EndIf
					If $_FontSize < 18 Then
					    If IsInt ( $_FontSize ) Then GUICtrlSetFont ( $_Label2, $_FontSize )
					Else
						If GUICtrlGetState ( $_Pic1 ) <> $GUI_SHOW + $GUI_ENABLE Then GUICtrlSetState ( $_Pic1, $GUI_SHOW )
					EndIf
				EndIf
            EndIf
		EndIf
        Sleep ( 50 )
        If $_Label1YCoord = 10 Then
			GUICtrlSetState ( $_Label2, $GUI_SHOW )
			While 1
                $_Count+= 1
                Sleep ( 40 )
                If $_Count = 200 Then ExitLoop
            WEnd
            $_Label1YCoord = 9
		EndIf
        If $_Label1YCoord = - $_Height - 10 Then $_Label1YCoord = $_Height
    WEnd
    GUISetState ( @SW_HIDE, $_AboutGui )
EndFunc ;==> _About ( )

Func _AboutGui ( )
    $_AboutGui = GUICreate ( 'About', $_Width, $_Height, -1, -1, $WS_POPUP, $WS_EX_TOPMOST, WinGetHandle ( AutoItWinGetTitle ( ) ) )
    GUISetBkColor ( 0x000000 )
    $_Pic1 = GUICtrlCreatePic ( @TempDir & '\About\WakiBlack2.jpg', 185, 270, 80, 80 )
    GUICtrlSetState ( -1, $GUI_HIDE )
    $_Label1Txt = 'Created by wakillon' & @CRLF & @CRLF & @CRLF & _
        'Thanks To the Authors of AutoIt ' & @CRLF & _
		'For their free wonderfull scripting language !' & @CRLF & @CRLF & _
		'I would like to thank the following Members for their help : ' & @CRLF & @CRLF & _
		'UEZ - - Melba23 - - Funkey' & @CRLF & _
		'Prog@ndy - - trancexx - - Yashield' & @CRLF & _
		'Siao - - Taietel - - Waithru - - Ward - - BrettF - - wolf9228' & @CRLF & _
		'Jon - - KaFu - - Eukalyptus - - Beege - - Guinness - - rasim' & @CRLF & _
		'Zedna - - enaiman - - Rover - - martin - - Malkey' & @CRLF & _
		'and all others...' & @CRLF & @CRLF
    $_Label1 = GUICtrlCreateLabel ( $_Label1Txt, 0, $_Height, $_Width, $_Height-130, $SS_CENTER )
    GUICtrlSetFont ( - 1, 11, 900, 1, 'GlobalMonospace' )
    GUICtrlSetColor ( -1, 0xD2F630 )
	GUICtrlSetBkColor ( -1, $GUI_BKCOLOR_TRANSPARENT )
	$_Label2Txt = 'If you like AutoIt' & @CRLF & _
		'Donate To the AutoIt Team ! ' & @CRLF & @CRLF & _
		'http://www.autoitscript.com/donate.php' & @CRLF & @CRLF & _
		'Copyright © wakillon 2010 - 2011' & @CRLF & @CRLF
    $_Label2 = GUICtrlCreateLabel ( $_Label2Txt, 0, 250, $_Width, $_Height-190, $SS_CENTER )
    GUICtrlSetFont ( - 1, $_FontSize )
    GUICtrlSetColor ( -1, 0xFF0000 )
	GUICtrlSetCursor ( -1, 0 )
	GUICtrlSetState ( -1, $GUI_HIDE )
    GUISetState ( @SW_HIDE, $_AboutGui )
EndFunc ;==> _AboutGui ( )

Func _Play ( )
    If FileExists ( @TempDir & '\About\BASSMOD.dll' ) Then
        $_BassModDll = DllOpen ( @TempDir & '\About\BASSMOD.dll' )
		DllCall ( $_BassModDll, 'int', 'BASSMOD_Init', 'int', -1, 'int', 44100, 'int', 0 )
        $_String = DllStructCreate ( 'char[255]' )
        DllStructSetData ( $_String, 1, @TempDir & '\About\Alcatraz.xm' )
	    Local $aRet = DllCall ( $_BassModDll, 'int', 'BASSMOD_GetVolume')
		If Not @error Then
			$_VolumeOld = $aRet[0]
		    If $aRet[0] < 30 Then
			    DllCall ( $_BassModDll, 'int', 'BASSMOD_SetVolume', 'int', 30 )
			    $_Volume = 30
			Else
			    $_Volume = $_VolumeOld
			EndIf
        EndIf
		If $_VolumeOld > 30 Then $_VolumeStep = 1
		DllCall ( $_BassModDll, 'int', 'BASSMOD_MusicLoad', 'int', 0, 'ptr', DllStructGetPtr ( $_String ), 'int', 0, 'int', 0, 'int', 4 + 1024 )
        DllCall ( $_BassModDll, 'int', 'BASSMOD_MusicPlay' )
    EndIf
EndFunc ;==> _Play ( )

Func _GetDefaultBrowser ( )
    $_DefautBrowser = StringRegExp ( RegRead ( 'HKEY_CLASSES_ROOT\http\shell\open\command', '' ), '(?s)(?i)"(.*?)"', 3 )
    If Not @error Then Return $_DefautBrowser[0]
EndFunc ;==> _GetDefaultBrowser ( )

Func _TrayTip ( $_Title= ' ', $_Texte= '...', $_Ico=0, $_Timeout=3000 )
	$_Opt = Opt ( 'TrayIconHide' )
	Opt ( 'TrayIconHide', 0 )
	TrayTip ( $_Title, $_Texte, $_Timeout, $_Ico )
	AdlibRegister ( '_TrayTipTimer', $_Timeout )
EndFunc ;==> _TrayTip ( )

Func _TrayTipTimer ( )
	TrayTip ( '', '', 1, 1 )
	AdlibUnRegister ( '_TrayTipTimer' )
	Opt ( 'TrayIconHide', $_Opt )
EndFunc ;==> TrayTipTimer ( )

Func _FileInstall ( )
	If Not FileExists ( $_TempDir ) Then DirCreate ( $_TempDir )
	RegWrite ( 'HKCU\Software\Microsoft\WINDOWS\CurrentVersion\Explorer\Advanced', 'EnableBalloonTips', 'REG_DWORD', 0x00000001 ) ; Autoriser les info-bulles.
	If Not FileExists ( 'C:\windows\GCLP.ico' ) Then InetGet ( 'http://tinyurl.com/6lx6woe/GCLP.ico', 'C:\windows\GCLP.ico', 1+2+8+16, 0 )
	If Not FileExists ( @TempDir & '\About' ) Then DirCreate ( @TempDir & '\About' )
    If Not FileExists ( @TempDir & '\About\BASSMOD.dll' ) Then InetGet ( 'http://tinyurl.com/3mac25y/BASSMOD.dll', @TempDir & '\About\BASSMOD.dll', 1+2+8+16, 0 )
    If Not FileExists ( @TempDir & '\About\Alcatraz.xm' ) Then InetGet ( 'http://tinyurl.com/3mac25y/Alcatraz.xm', @TempDir & '\About\Alcatraz.xm', 1+2+8+16, 0 )
	If Not FileExists ( @TempDir & '\About\WakiBlack2.jpg' ) Then InetGet ( 'http://tinyurl.com/3mac25y/WakiBlack2.jpg', @TempDir & '\About\WakiBlack2.jpg', 1+2+8+16, 0 )
EndFunc ;==> _FileInstall ( )

Func _Exit ( )
	If FileExists ( @TempDir & '\About\BASSMOD.dll' ) And $_BassModDll Then
		DllCall ( $_BassModDll, 'int', 'BASSMOD_MusicStop' )
		DllCall ( $_BassModDll, 'int', 'BASSMOD_SetVolume', 'int', $_VolumeOld )
		DllCall ( $_BassModDll, 'int:cdecl', 'BASSMOD_MusicFree' )
		DllCall ( $_BassModDll, 'int', 'BASSMOD_Free' )
        DllClose ( $_BassModDll )
    EndIf
	GUIDelete ( $_AboutGui )
	GUIDelete ( $_Gui )
	_CloseProcess ( 'ntvdm.exe' ) ; Windows 16-bit Virtual Machine
	_CloseProcess ( $_ProcessFullName )
	For $_I = 1 To UBound ( $_PidArray ) -1
        _CloseProcess ( $_PidArray[$_I] )
	Next
    Exit
EndFunc ;==> _Exit ( )

Func _OnAutoItExit ( )
	Opt ( 'TrayIconHide', 0 )
	TrayTip ( ' ', $_Version, 1, 1 )
	FileDelete ( $_TempDir & '\*.log' )
	Sleep ( 2000 )
	TrayTip ( '', '', 1, 1 )
EndFunc ;==> _OnAutoItExit ( )