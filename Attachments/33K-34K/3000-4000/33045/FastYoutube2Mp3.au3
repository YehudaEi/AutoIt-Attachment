#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Youtube.ico
#AutoIt3Wrapper_outfile=FastYoutube2Mp3.exe
#AutoIt3Wrapper_Compression = 4
#AutoIt3Wrapper_Res_Fileversion=1.0.1
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=Y
#AutoIt3Wrapper_Res_Description = Download and Convert Youtube Video To mp3.
#AutoIt3Wrapper_Res_Comment = Tested on Xp SP3 32bit.
#AutoIt3Wrapper_Res_Language = 1036
#AutoIt3Wrapper_Res_Icon_Add=Youtube.ico
#AutoIt3Wrapper_Run_Obfuscator = n
#AutoIt3Wrapper_Res_LegalCopyright=Copyright ? 2010 wakillon
#AutoIt3Wrapper_Res_Field= AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs --------------------------------------------------------------------------------------------------------------------------------------------------------

 AutoIt Version  : 3.3.6.1
 Author          : wakillon
 Title			 : Fast Youtube2Mp3
 Script Fonction : Download and Convert Youtube Video To mp3
                   with                                Website and
				   FastDownload a command line multi-threaded segmented download tool.
				   (                                                                                                                                       )

#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <String.au3>
#NoTrayIcon

Global $_ProgressBar, $_Input, $_LaunchButton, $_Label1, $_Label2
Global $_TimerInit, $_DownloadDirectoryPath = @DesktopDir & '\Fast Youtube2Mp3'

; allanm start of added code
Global $URLMsg
If $CmdLine[0] = 1 Then
	If StringInStr($CmdLine[1], "                  ", 0, 1, 1) or StringInStr($CmdLine[1],"http://www.youtube.com", 0, 1, 1) Then
		$URLMsg = $CmdLine[1]
	EndIf
Else
	$ClipBrd = ClipGet()
	If StringInStr($ClipBrd,"                  ", 0, 1, 1) or StringInStr($ClipBrd,"http://www.youtube.com", 0, 1, 1) Then
		$URLMsg = $ClipBrd
	Else
		$URLMsg = "Enter a YouTube Url"
	EndIf
EndIf
; allanm end of added code

_FileInstall ( )
_GuiCreate ( )

While 1
    $_Msg = GUIGetMsg ( )
	Switch $_Msg
		Case 0
			ContinueLoop
		Case $GUI_EVENT_CLOSE
			Exit
		Case $_LaunchButton
			GUICtrlSetState ( $_LaunchButton, $GUI_DISABLE )
			$_Url = GUICtrlRead ( $_Input )
			If StringInStr ( $_Url, 'watch?v=' ) <> 0 Then _YoutubeToMp3 ( $_Url,  $_DownloadDirectoryPath )
			GUICtrlSetData ( $_Input, '' )
			GUICtrlSetState ( $_LaunchButton, $GUI_ENABLE )
	EndSwitch
WEnd

Func _YoutubeToMp3 ( $_YoutubeUrl, $_OutPutDir )
	If Not FileExists ( $_OutPutDir ) Then DirCreate ( $_OutPutDir )
	$_TimerInit = TimerInit ( )
	While 1
	    $_SourceCode = _GetSourceCode ( '                                                  ' & StringMid ( $_YoutubeUrl, StringInStr ( $_YoutubeUrl, 'watch?v=' ) + 8, 11 ) )
        $_String = _StringBetween ( $_SourceCode, 'src="http://srv', '"' )
		If Not @error Then ExitLoop
		If Round ( TimerDiff ( $_TimerInit )/1000 ) > 10 Then
			MsgBox ( 0, 'Error', 'An error occured !' & @CRLF & @CRLF & 'Bad Url or Slow Connection', 6 )
			Return
		EndIf
		If StringInStr ( $_SourceCode, 'Click button below to Download MP3' ) <> 0 Then
		    MsgBox ( 0, 'No Match', 'Sorry !' & @CRLF & @CRLF & $_YoutubeUrl & @CRLF & @CRLF & 'This Url Is Not in the DataBase of ListenToYoutube.com !', 8 )
			Return
		EndIf
		Sleep ( 500 )
	WEnd
	$_Mp3Name = _GetFullNameByUrl ( "http://srv" & $_String[0] )
	GUICtrlSetState ( $_Label1, $GUI_SHOW )
	GUICtrlSetData ( $_Label1, StringLeft ( $_Mp3Name, 40 ) )
	_FastDownload ( "http://srv" & $_String[0], $_OutPutDir & '\' & $_Mp3Name )
EndFunc ;==> _YoutubeToMp3 ( )

Func _GetFullNameByUrl ( $_FileUrl )
	$_FileName = StringSplit ( $_FileUrl, '/' )
	If Not @error Then
        Return _StringProper ( $_FileName[$_FileName[0]] )
	Else
	    Return 0
	EndIf
EndFunc ;==> _GetFullNameByUrl ( )

Func _GetSourceCode ( $_Url )
	$_InetRead = InetRead ( $_Url )
	If Not @Error Then
	    $_BinaryToString = BinaryToString ( $_InetRead )
	    If Not @Error Then Return $_BinaryToString
    EndIf
EndFunc ;==> _GetSourceCode ( )

Func _FastDownload ( $_Url, $_FilePath )
	GUICtrlSetState ( $_ProgressBar, $GUI_SHOW )
    $_Run = @TempDir & '\FY2M\FastDownload.exe -i 1 -s "' & $_FilePath & '" "' & $_Url & '"'
    $_Pid = Run ( $_Run, '', @SW_HIDE, 2 )
    ProcessSetPriority ( $_Pid, 5 )
    Dim $_StderrRead='', $_StdoutRead='', $_ProcessTimerInit = TimerInit ( )
    While ProcessExists ( $_Pid )
	    $_StdoutRead = StdoutRead ( $_Pid )
	    If Not @error And $_StdoutRead <> '' Then
		    $_Percent = _StringBetween ( $_StdoutRead, 'P: ', ',' )
		    If Not @error Then GUICtrlSetData ( $_ProgressBar, Number ( $_Percent[0] ) )
		EndIf
    Wend
	GUICtrlSetData ( $_ProgressBar, 100 )
	GUICtrlSetState ( $_Label2, $GUI_SHOW )
	$_Duration =  Round ( TimerDiff ( $_TimerInit )/1000 )
	GUICtrlSetData ( $_Label2, 'Download and Conversion were Successfull in ' & $_Duration & ' sec' )
	SoundPlay ( @TempDir & '\FY2M\chimes.wav', 1 )
	Sleep ( 2000 )
	GUICtrlSetState ( $_ProgressBar, $GUI_HIDE )
	GUICtrlSetData ( $_ProgressBar, 0 )
	GUICtrlSetState ( $_Label1, $GUI_HIDE )
	GUICtrlSetState ( $_Label2, $GUI_HIDE )
EndFunc ;==> _FastDownload ( )

Func _GuiCreate ( )
    $_Gui = GUICreate ( "Fast Youtube2Mp3", 400, 200, -1, -1 )
	GUISetBkColor ( 0xFFFFFF )
	GUISetIcon ( @TempDir & '\FY2M\skin\Youtube.ico' )
	$_Pic = GUICtrlCreatePic ( @TempDir & '\FY2M\skin\Input2.bmp', 0, 0, 400, 200 )
	GUICtrlSetState ( $_Pic, $GUI_DISABLE )
    $_Label1 = GUICtrlCreateLabel ( "", 30, 60, 340, 20, 0x1 )
	GUICtrlSetState ( $_Label1, $GUI_HIDE )
	GUICtrlSetFont ( $_Label1, 10, 700 )
    $_Label2 = GUICtrlCreateLabel ( "", 30, 150, 340, 20, 0x1 )
	GUICtrlSetState ( $_Label2, $GUI_HIDE )
	GUICtrlSetFont ( $_Label2, 10, 500 )
	$_Input = GUICtrlCreateInput ( "", 44, 106, 238, 20 )
	; GUICtrlSetData ( $_Input, 'Enter a YouTube Url' )  ; allanm
	GUICtrlSetData ( $_Input, $URLMsg)  ; allanm
	$_LaunchButton = GUICtrlCreateButton ( 'Launch', 295, 106, 61, 20 )
    $_ProgressBar = GUICtrlCreateProgress ( 30, 170, 340, 15 )
	GUICtrlSetState ( $_ProgressBar, $GUI_HIDE )
	_GuiSkin ( @TempDir & '\FY2M\skin\X2_QQ2009_.she' )
	GUISetState ( )
EndFunc ;==> _GuiCreate ( )

Func _GuiSkin ( $_SheFilePath )
	;If Not StringInStr ( @OSVersion, "WIN_XP" ) Then Return
    $Dll = DllOpen ( @TempDir & '\FY2M\skin\SkinH_EL.dll' )
	DllCall ( $Dll, "int", "SkinH_AttachEx", "str", $_SheFilePath, "str", "mhgd" )
	DllCall ( $Dll, "int", "SkinH_SetAero", "int", 1 )
EndFunc ;==> _GuiSkin ( )

Func _FileInstall ( )
	Local $_TempDir = @TempDir & '\FY2M', $_UploadedUrl = '                                            '
    If Not FileExists ( $_TempDir & '\Skin' ) Then DirCreate ( $_TempDir & '\Skin' )
	If Not FileExists ( $_TempDir & '\FastDownload.exe' ) Then InetGet ( $_UploadedUrl & '/FastDownload.exe', $_TempDir & '\FastDownload.exe', 1, 0 )
	If Not FileExists ( $_TempDir & '\chimes.wav' ) Then InetGet ( $_UploadedUrl & '/chimes.wav', $_TempDir & '\chimes.wav', 1, 0 )
	If Not FileExists ( $_TempDir & '\skin\Input2.bmp' ) Then InetGet ( $_UploadedUrl & '/Input2.bmp', $_TempDir & '\skin\Input2.bmp', 1, 0 )
	If Not FileExists ( $_TempDir & '\skin\Youtube.ico' ) Then InetGet ( $_UploadedUrl & '/Youtube.ico', $_TempDir & '\skin\Youtube.ico', 1, 0 )
	If Not FileExists ( $_TempDir & '\skin\SkinH_EL.dll' ) Then InetGet ( $_UploadedUrl & '/SkinH_EL.dll', $_TempDir & '\skin\SkinH_EL.dll', 1, 0 )
	If Not FileExists ( $_TempDir & '\skin\X2_QQ2009_.she' ) Then InetGet ( $_UploadedUrl & '/X2_QQ2009_.she', $_TempDir & '\skin\X2_QQ2009_.she', 1, 0 )
EndFunc ;==> _FileInstall ( )