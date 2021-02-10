Global $DeleteAfterCompress,$UT2004IsPlaying, $UT2004MusicOption, $UT2004MusicFunction,$UT2004SystemPathEdit,$UT2004SystemDir,$UT2004IsPlaying,$MsgTitle,$UT2004List,$UT2004OutputPathEdit,$MainGUI
Func CompressUT2004Function()
	Local $UT2004MusicOnItem,$UT2004MusicOFFItem,$UT2004IsPlaying,$UT2004compressor,$GetUT2004FilesToCompress
	Local $ReplaceNextLineWithSpace,$UT2004FilesToCompress,$Count,$DeleteLock,$UT2004ResultPath,$UT2004Exist,$UT2004SystemDir,$SearchIn
	Local $UT2004search,$UT2004searchreturn,$Line,$Extention
	Local $fSearch,$sSearchReturn,$sExtension,$dirNextAgain,$fSearchAgain,$sSearchReturnAgain,$sExtensionAgain
FileDelete (@ScriptDir & "\UT2004Command.txt")
$UT2004MusicOnItem = TrayCreateItem("Turn music ON")
TrayItemSetOnEvent(-1,"StartUT2004MusicFunction") ;function name
$UT2004MusicOFFItem = TrayCreateItem("Turn music OFF")
TrayItemSetOnEvent(-1,"StopUT2004MusicFunction") ;function name
TraySetState(1)

SoundPlay (@TempDir & '/MMLetsRockB.wav',1) ;play sound lets rock
$UT2004IsPlaying = "No" ;$UT2004IsPlaying is set to "NO" but changes by "assign"
$UT2004compressor = GUICtrlRead ($UT2004SystemPathEdit) ;read $UT2004SystemPathEdit value
If StringInStr ($UT2004compressor," ") > 0 Then
	MsgBox(16,"Error" "Pathname cannot contain spaces. Due to UCC.exe limitations its best install the game into folder which name has no spaces." & @CRLF & "Compressor will not work unless pathname to ucc.exe has no spaces. Compressor will now EXIT")
	Exit
EndIf
$GetUT2004FilesToCompress = GUICtrlRead ($UT2004List) ;read $UT2004List value

$ReplaceNextLineWithSpace = StringReplace ($GetUT2004FilesToCompress,@CRLF," ")
FileWrite (@ScriptDir & "\UT2004Command.txt",$ReplaceNextLineWithSpace)
$UT2004FilesToCompress = FileRead (@ScriptDir & "\UT2004Command.txt")
$Count = StringLen ($UT2004FilesToCompress)
$DeleteLock = "Unlocked"
If $Count > 1001 Then
	MsgBox (0,'WARNING',"UCC is limited to 1001 character in the command line and you have " & $Count & @CRLF & "If UCC will crush, try to remove some files from the list and try again." & @CRLF & "You can also try to copy files needed to compress to simple directory such as C:\Files and compress them from there.")
	Assign ("DeteleLock","Locked")
EndIf
$UT2004ResultPath = GUICtrlRead ($UT2004OutputPathEdit) ;read $UT2004OutputPathEdit value
GUISetState (@SW_DISABLE,$MainGUI)
TraySetState(4)


Run ($UT2004compressor & " compress " & $UT2004FilesToCompress)

While 1 ;loop
	$UT2004Exist = ProcessExists ("UCC.exe") ;check for UCC.exe process
If $UT2004Exist > "" And $UT2004IsPlaying = "No" Then ;if UCC.exe is running and $UT2004IsPlaying is "NO" then
	SoundPlay (@TempDir & '/ut200401.wav') ;play ut200401.wav
	Assign ("UT2004IsPlaying", "Yes") ;and change $UT2004IsPlaying "NO" to "YES"
ElseIf $UT2004Exist > "" And $UT2004IsPlaying = "Yes" Then
	ContinueLoop
ElseIf $UT2004Exist = "" And $UT2004IsPlaying = "Yes" Then
	ExitLoop
ElseIf $UT2004Exist = "" And $UT2004IsPlaying = "NO" Then
	ExitLoop
EndIf
WEnd

TrayTip ($MsgTitle, "Moving compressed files to Output" & @CRLF & "Please wait..........",99)

;move files from -nohomedir to output folder.
$UT2004SystemDir = GUICtrlRead ($UT2004SystemPathEdit)
$SearchIn = StringReplace ($UT2004SystemDir,"System","")

$UT2004search = FileFindFirstFile ($SearchIn & "*")
;=======================================
DirCreate ($UT2004ResultPath)
While 1
    $UT2004searchreturn = FileFindNextFile ($UT2004search)
    If  $UT2004searchreturn = "" Then
	ExitLoop
ElseIf  $UT2004searchreturn > "" Then
FileMove ($SearchIn & $UT2004searchreturn & "\*.uz2", $UT2004ResultPath, 1)
EndIf
WEnd

;This section moves files that are found in those folders from which files to compress were added.
;For example file in C:\Folder\File.ut2 will endup compressed in that same folder instead of system folder.
Local $Line,$Extention,$dirNext,$fSearch,$sSearchReturn,$sExtension
Local $dirNextAgain,$fSearchAgain,$sSearchReturnAgain,$sExtensionAgain
$Line = '1' ;this changes in order to search next line instead of same one again.
$Extention = ".uz2"
	While 1
		$dirNext = FileReadLine (@ScriptDir & "\UT2004CompressPaths.txt",$Line)
		If $dirNext = "" Then
			ExitLoop
		Else
			$fSearch = FileFindFirstFile ($dirNext & "\*.uz2")
			$sSearchReturn = FileFindNextFile ($fSearch)
			$sExtension = StringRight ($sSearchReturn,3)
			If $sExtension = "" Then
				;MsgBox(0,'',@ScriptLineNumber & " "& $dirNext)
				Assign ("Line",Number ($Line+1)) ;changed to search next line of the text file which gives path to search for extension.
			ElseIf $sExtension = "uz2" Then
				While 1
					;$Readcheckbox = GUICtrlRead ($DeleteAfterCompress)
				;If $DeleteLock = "Unlocked" And $Readcheckbox = $GUI_CHECKED Then
					;MsgBox(0,'','both checked')
					;FileRecycle ($sSearchReturn)
				;Endif
					$dirNextAgain = FileReadLine (@ScriptDir & "\UT2004CompressPaths.txt",$Line)
					$fSearchAgain = FileFindFirstFile ($dirNextAgain & "\*.uz2")
					$sSearchReturnAgain = FileFindNextFile ($fSearchAgain)
					$sExtensionAgain = StringRight ($sSearchReturnAgain,3)
					If $sExtensionAgain = "uz2" Then
						FileMove ($dirNextAgain & "\" & $sSearchReturnAgain, $UT2004ResultPath, 1)
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
TrayTip ($MsgTitle, "Finished moving compressed files",1)
;end moving files

	TraySetState(8) ;Stop flashing icon
	TrayItemDelete ($UT2004MusicOnItem) ; Erase $UT2004MusicOnItem from tray
	TrayItemDelete ($UT2004MusicOFFItem) ;$UT2004MusicOFFItem from tray
GUISetState (@SW_ENABLE,$MainGUI) ;enable main GUI
SoundPlay (@TempDir & '/MMFinally.wav') ;play sound Finaly
MsgBox(64,$MsgTitle,"Finished !"); display message all done

EndFunc