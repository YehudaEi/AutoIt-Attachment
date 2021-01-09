; Global vars
Global $PathFrom
Global $PathTo

; Check if rsync is run from command line
If $CmdLine[0] < 2 Then
	$PathFrom = FileSelectFolder("Select the source directory", "", 7)
	If @error == 1 Then
		MsgBox(0, "Error", "Unable to read the source directory.")
		Exit
	EndIf

	$PathTo = FileSelectFolder("Select the destination directory", "", 7)
	If @error == 1 Then
		MsgBox(0, "Error", "Unable to read the destination directory.")
		Exit
	EndIf
Else
	$PathFrom = $CmdLine[1]
	$PathTo = $CmdLine[2]
EndIf

; Ensure $PathFrom and $PathTo are readable
$PathFrom = StringStripWS($PathFrom, 3)
$PathTo = StringStripWS($PathTo, 3)
If StringRight($PathFrom, 1) = "\" Then
	$PathFrom = StringTrimRight($PathFrom, 1)
EndIf
If StringRight($PathTo, 1) = "\" Then
	$PathTo = StringTrimRight($PathTo, 1)
EndIf

; Basic check : $PathFrom and $PathTo MUST exist
If Not FileExists($PathFrom) Then
	MsgBox(0, "Error", "Invalid source :" & @LF & $PathFrom)
	Exit
EndIf

If Not FileExists($PathTo) Then
	MsgBox(0, "Error", "Invalid destination :" & @LF & $PathTo)
	Exit
EndIf

; Ask for a synchro...
; Synchro source to destination
_RSync("", $PathFrom, $PathTo)
; Synchro destination to source
_RSync("", $PathTo, $PathFrom)


Func _RSync($subpath, $from, $to)
; $subpath is built along the way, and passed recursively
; $from and $to are here because source and destination are to be swapped.
; I left som ConsoleWrite(), just see how they work
ConsoleWrite("Scanning " & $from & $subpath & @LF)
	; Building the logical source directory
	; Remember source dans dest are logical :)
	Local $FilesFrom = FileFindFirstFile($from & $subpath & "\*.*")

	While 1
		Local $file = FileFindNextFile($FilesFrom)
		If @error Then ExitLoop
		; Building the full path to source and destination file (or directory)
		Local $filename = FileGetLongName($from & $subpath & "\" & $file)
		Local $tofilename = FileGetLongName($to & $subpath & "\" & $file)
		; Getting the file (or dir) properties
		Local $fileprops = FileGetAttrib($filename)
		If StringInStr($fileprops, "D") Then
			; If it's a directory
			Local $subpath2 = $subpath & "\" & $file
			If Not FileExists($to & $subpath2) Then
				; Needed because of empty dirs, the 9 value to FileCopy can rebuild the dir tree, but only when a file is in.
				DirCreate($to & $subpath2)
			EndIf
			; The most interesting part : this func is recursive :)
			; Beware of the recursion level : 384.
			_RSync($subpath2, $from, $to)
		Else
			; Not a dir, mostly files and links
			; Getting the mod. time of source and dest file...
			Local $fromtime = FileGetTime($filename, 0, 1)
			Local $totime = FileGetTime($tofilename, 0, 1)
			
			; In case the destination file does not exists, $fromtime is always greater than $totime
			If $fromtime > $totime Then
				FileCopy($filename, $tofilename, 9)
ConsoleWrite("Synchro " & $filename & " And " & $tofilename & @LF)
			EndIf
		EndIf
	WEnd

	; Proper close of the file list
	FileClose($FilesFrom)
EndFunc