Global $UT3OutputPathEdit,$MsgTitle,$UT3List,$MainGUI,$UT3ResultPath
Global $UT3comPathEdit,$OS
Func CompressUT3Function()
	Local $CheckUT3PathToUT3com,$CheckUT3Output,$CheckUT3List,$UT3MusicOnItem,$UT3MusicOFFItem,$UT3compressor
	Local $UT3FilesToCompress,$UT3IsPlaying

#Region ;Music starts
TrayTip ($MsgTitle, "Compressing files. Please wait......",99)
$UT3MusicOnItem = TrayCreateItem("Turn music ON")
TrayItemSetOnEvent(-1,"StartUT3MusicFunction") ;function name
$UT3MusicOFFItem = TrayCreateItem("Turn music OFF")
TrayItemSetOnEvent(-1,"StopUT3MusicFunction") ;function name
TraySetState(1)
SoundPlay (@TempDir & '/MMLetsRockB.wav',1) ;play sound lets rock
$UT3ResultPath = GUICtrlRead ($UT3OutputPathEdit) ;read $UT3OutputPathEdit value
$UT3IsPlaying = "No" ;$UT3IsPlaying is set to "NO" but changes by "assign"
GUISetState (@SW_DISABLE,$MainGUI)
TraySetState(4) ; blink tray icon
#EndRegion

$UT3compressor = GUICtrlRead ($UT3comPathEdit) ;read $UT3comPathEdit value
$UT3FilesToCompress = GUICtrlRead ($UT3List) ;read $UT3List value

FileDelete (@ScriptDir & "\UT3Command.txt")
$ReplaceNextLineWithSpaceUT3 = StringReplace ($UT3FilesToCompress,@CRLF," ")
FileWrite (@ScriptDir & "\UT3Command.txt",$ReplaceNextLineWithSpaceUT3)
$UT3FilesToCompress = FileRead (@ScriptDir & "\UT3Command.txt")

Run ($UT3compressor & " compress " & $UT3FilesToCompress)

; "Full path1\file1.ext" "Full path2\file2.ext" Outputs to "%userprofile%\Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\CookedPC"
While 1 ;loop
		$UT3Exist = ProcessExists ("UT3.com") ;check for ur3.com process
	If $UT3Exist > "" And $UT3IsPlaying = "No" Then ;if ut3.com is running and $UT3IsPlaying is "NO" then
		SoundPlay (@TempDir & '/ut301.wav') ;play ut301.wav
		Assign ("UT3IsPlaying", "Yes") ;and change $UT3IsPlaying "NO" to "YES"
	ElseIf $UT3Exist > "" And $UT3IsPlaying = "Yes" Then
		ContinueLoop
	ElseIf $UT3Exist = "" And $UT3IsPlaying = "Yes" Then
		ExitLoop
			ElseIf $UT3Exist = "" And $UT3IsPlaying = "NO" Then
		ExitLoop
	EndIf
WEnd

TrayTip ($MsgTitle, "Moving compressed files to Output" & @CRLF & "Please wait....... ...",99)
;=================
If $OS = "WIN_7" Then
_search(@UserProfileDir & "\Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\CookedPC\")
ElseIf $OS = "WIN_Vista" Then
_search(@UserProfileDir & "\Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\CookedPC\")
ElseIf $OS = "WIN_XP" Then
_search(@UserProfileDir & "\My Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\CookedPC\")
EndIf
GUISetState (@SW_ENABLE,$MainGUI) ;enable main GUI
TraySetState(8) ;return tray to normal state
TrayItemDelete ($UT3MusicOnItem) ; Erase $UT3MusicOnItem from tray
TrayItemDelete ($UT3MusicOFFItem) ;$UT3MusicOFFItem from tray


;This section moves files that are found in those folders from which files to compress were added.
;For example file in C:\Folder\File.ut2 will endup compressed in that same folder instead of system folder.
Local $Line,$Extention,$dirNext,$fSearch,$sSearchReturn,$sExtension
Local $dirNextAgain,$fSearchAgain,$sSearchReturnAgain,$sExtensionAgain
$Line = '1' ;this changes in order to search next line instead of same one again.
$Extention = ".uz3"
	While 1
		$dirNext = FileReadLine (@ScriptDir & "\UT3CompressPaths.txt",$Line)
		If $dirNext = "" Then
			ExitLoop
		Else
			$fSearch = FileFindFirstFile ($dirNext & "\*.uz3")
			$sSearchReturn = FileFindNextFile ($fSearch)
			$sExtension = StringRight ($sSearchReturn,3)
			If $sExtension = "" Then
				;MsgBox(0,'',@ScriptLineNumber & " "& $dirNext)
				Assign ("Line",Number ($Line+1)) ;changed to search next line of the text file which gives path to search for extension.
			ElseIf $sExtension = "uz3" Then
				While 1
					;$Readcheckbox = GUICtrlRead ($DeleteAfterCompress)
				;If $DeleteLock = "Unlocked" And $Readcheckbox = $GUI_CHECKED Then
					;MsgBox(0,'','both checked')
					;FileRecycle ($sSearchReturn)
				;Endif
					$dirNextAgain = FileReadLine (@ScriptDir & "\UT3CompressPaths.txt",$Line)
					$fSearchAgain = FileFindFirstFile ($dirNextAgain & "\*.uz3")
					$sSearchReturnAgain = FileFindNextFile ($fSearchAgain)
					$sExtensionAgain = StringRight ($sSearchReturnAgain,3)
					If $sExtensionAgain = "uz3" Then
						FileMove ($dirNextAgain & "\" & $sSearchReturnAgain, $UT3ResultPath, 1)
					ElseIf $sExtensionAgain = "" Then
						Exitloop
					EndIf
				WEnd
				;MsgBox(0,'',@ScriptLineNumber)
			Else
				;Nothing, continue search
			EndIf
		EndIf
	WEnd

;==========================================================


TrayTip ($MsgTitle, "Finished moving compressed files",2)
SoundPlay (@TempDir & '/MMFinally.wav') ;play sound Finaly
MsgBox(64,$MsgTitle,"Finished !"); display message all done
EndFunc

Func _search($dir)
DirCreate ($UT3ResultPath)
    Local $ArrTargetItems, $TargetItem
    If (StringRight($dir, 1) = "\") Then $dir = StringTrimRight($dir, 1)
    $ArrTargetItems = _FileListToArray($dir, "*", 0)
    If IsArray($ArrTargetItems) Then
        For $n = 1 To $ArrTargetItems[0]
            $TargetItem = $dir & '\' & $ArrTargetItems[$n]
            If StringInStr(FileGetAttrib($TargetItem), "D") Then ;This is a folder
                _search($TargetItem) ;Call recursively
            Else ;This is a file
				$getext = StringRight ($TargetItem,4)
				If $getext = ".uz3" Then
					FileMove ($TargetItem, $UT3ResultPath,1)
					Endif
            EndIf
        Next
    EndIf
EndFunc