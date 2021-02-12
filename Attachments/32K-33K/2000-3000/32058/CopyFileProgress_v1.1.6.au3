; Copies a file/directory using the native Windows copy command, but
; displays statistics while copying.
; The only dependency is 'copy.exe', which is available on every Windows system.
; Works especially good in a WinPE environment where no copy GUI is available.
;
;	v1.1.6:
;		- Fixed bug: Copying to/from the root directory of a drive (c:\, d:\, etc.)
;         was handled incorrectly.
;	v1.1.5:
;		- Fixed bug: Peak speed would display 0 bytes/s for small files
;	v1.1.4:
;		- Fixed bug: empty directories would report failure
;	v1.1.3:
;		- Add current file progress bar (above total progress bar)
;		- Add check for file/dir size after copy operation is complete
;		- Add 'Peak speed' on display after copy operation is complete
;	v1.1.2:
;		- Add internal byte decimal place ($bytedecimalplace) global var
;		  for displaying any byte measurement data
;   v1.1.1:
;		- Shorten path and file names on GUI display
;   v1.1.0:
;		- Adds copying directory support
;		- Re-write some code and better organized code
;   v1.0.0:
;		- Initial release
;

#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <ButtonConstants.au3>
#Include <GuiButton.au3>
#Include <File.au3>

Opt("GUICoordMode", 0)
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

; Debug Mode
;   If debug=1, then Debug Mode is turned on.  This produces a lot
;   of messages for debugging purposes.
;   NOTE: This setting should be 0 for production use.
Global $debug = 0

Global $invalidChars = "/ : * ? < > | " & chr(34)
Global $forceoverwrite = 0
Global $showcopytime = 0
Global $noerror = 0
Global $displayhelp = 0
Global $title = "Copying files..."
Global $source = ""
Global $destination = ""

Global $cmdopts = $CmdLine
Global $sourcetype = ""
Global $progress = 0
Global $fail = ""

If ($cmdopts[0] = 0) Then
	displayHelp()
	Exit
EndIf

; Loop through command args for switches
For $a = 1 to ($cmdopts[0])
	Select
	Case StringLower($cmdopts[$a]) = "/y"
		$forceoverwrite = 1
	Case StringLower($cmdopts[$a]) = "/noerror"
		$noerror = 1
	case StringLower(StringLeft($cmdopts[$a], 7)) = "/title:"
		$title = StringSplit($cmdopts[$a], ":")
		If ($title[2] <> "") Then
			$title = $title[2]
		Else
			; set to empty
			$title = ""
		EndIf		
	case StringLower($cmdopts[$a]) = "/title"
		; if no valid title is given, continue as normal
	case StringLower($cmdopts[$a]) = "/k"
		$showcopytime = 1
	case $cmdopts[$a] = "/?"
		$displayhelp = 1
	Case Else
		If ($a = ($cmdopts[0] - 1)) Then
			$source = $cmdopts[($cmdopts[0] -1)]
		ElseIf ($a = $cmdopts[0]) Then
			$destination = $cmdopts[($cmdopts[0])]		
		Else
			$displayhelp = 1
		EndIf
	EndSelect
Next

; If displayhelp = 1, display help message
If ($displayhelp = 1) Then
	displayHelp()
	Exit
EndIf

; Must specify both source and destination
If ($source = "" Or $destination = "") Then
	errorMsg ("You must specify both source and destination files")
	Exit
EndIf

; Check for illegal characters in source
If ( validPath(getDirectory($source)) = 0 Or _
	 validPath(getFilename($source)) = 0 ) Then
	errorMsg ("Source file name invalid.  File name cannot contain: " & @LF & $invalidChars)
	Exit
EndIf

; Convert any relative paths into absolute paths
$source = _PathFull($source)
$destination = _PathFull($destination)

; Check that source file exist
If (FileExists($source)) Then
	If (StringInStr(FileGetAttrib($source), "D", 0) = 0) Then		
		; if source is a file, (not directory)
		$sourcetype = "file"
		debugMsg ("Source is a file")
		; if destination is directory, append source filename
		If (StringInStr(FileGetAttrib($destination), "D", 0)) Then
			If (StringRight($destination, 1) = "\") Then
				; append only filename to destination, no \ required
				$destination = $destination & getFilename($source)
			Else
				; append \ + source filename to destination
				$destination = $destination & "\" & getFilename($source)
			EndIf
			debugMsg ("New destination " & $destination)
		EndIf
	Else
		; if source is a diretory
		$sourcetype = "dir"
		
		; if destination is <drive>:\  append full source directory
		If (getDirectory($destination) & getFilename($destination) = "\") Then
			$destination = getDrive($destination) & getDirectory($source) & getFilename($source)
		EndIf
		debugMsg ("Source is a directory")
	EndIf
Else
	; if source does not exist
	errorMsg ($source & " does not exist.")
	Exit
EndIf

; Check for illegal characters in destination
If ( validPath(getDirectory($destination)) = 0 Or _
	 validPath(getFilename($destination)) = 0 ) Then
	errorMsg ("Destination file name invalid.  File name cannot contain: " & @LF & $invalidChars)
	Exit
EndIf

; Check if source and destination are the same
If (StringUpper($source) = StringUpper($destination)) Then
	errorMsg ("Source and destination are the same!")
	Exit
EndIf

; If destination exist, ask if ok to overwrite
If (FileExists($destination)) Then
	If ($forceoverwrite = 0) Then
		; if response is No..
		If (MsgBox(4 + 32 + 256, "Overwrite", $destination & " already exists.  Overwrite?") = 7) Then
			Exit
		EndIf
	EndIf

	; remove destination
	; if destination is a directory, use DirRemove
	; if destination is a file, use FileDelete
	If (StringInStr(FileGetAttrib($destination), "D", 0)) Then
		; remove destination directory
		debugMsg ("Removing directory " & $destination)
		If (DirRemove ($destination, 1) = 0) Then
			errorMsg ("Could not replace " & $destination)
			Exit
		EndIf
	Else
		; remove destination file
		debugMsg ("Removing file " & $destination)
		If (FileDelete($destination) = 0) Then
			errorMsg ("Could not replace " & $destination)
			Exit
		EndIf
	EndIf
EndIf

; Global GUI controls
Global $guiwin, $cancelbtn, $progressbar, $currentprogressbar, $msg, $index, $lblbytes
Global $lbltransfer, $lblspin, $lblfiles, $lblcurrentfile, $lbltime, $lbltotalprogress
Global $spin = "|"
Global $progresssubstring = ""
Global $pid = 0
Global $sourcesize = 0
Global $destinationsize = 0
Global $copyfiletime			; total time for copy operation
Global $statusrefresh = 1300	; calulate time remain, speed, etc. interval
Global $progresstimer
Global $progressrefresh = 1000	; display stats (time est/remain, speed) interval
Global $spintimer
Global $spinrefresh = 170		; display top bar (bytes and spin) interval
Global $bytedecimalplace = 2
Global $peakspeed = 0

$guiwin = GUICreate($title, 300, 200)
$lblbytes = GUICtrlCreateLabel("Preparing...", 5, 5, 290)
$lblcurrentfile = GUICtrlCreateLabel("Cur. Source: " & $source & @LF & "Cur. Destination: " & $destination , -1, 21, 290, 26)
$currentprogressbar = GUICtrlCreateProgress(-1, 20, 290, 20, $PBS_SMOOTH)
$lbltotalprogress = GUICtrlCreateLabel("Total progress", -1, 21, 290, 26)
$progressbar = GUICtrlCreateProgress(-1, 20, 290, 20, $PBS_SMOOTH)
$lblfiles = GUICtrlCreateLabel("Source: " & $source & @LF & "Destination: " & $destination , -1, 21, 290, 30)
$lbltime = GUICtrlCreateLabel("", -1, 31, 290, 13)
$lbltransfer = GUICtrlCreateLabel("", -1, 14, 290, 13)
$cancelbtn = GUICtrlCreateButton("Cancel", 230, 15, 60)

GUICtrlSetOnEvent($cancelbtn, "cancelop")
GUISetOnEvent($GUI_EVENT_CLOSE, "cancelop")
GUISetState(@SW_SHOW)

; if source is file, copy file
; if source is directory, copy directory

; Get size of source
GUICtrlSetData($lblbytes, "Calculating size ...")	
If ($sourcetype = "file") Then
	$sourcesize = FileGetSize($source)
ElseIf ($sourcetype = "dir") Then
	$sourcesize = DirGetSize($source)	
EndIf
If ($sourcesize = -1) Then
	errorMsg ("Could not retrieve size of " & $source)
	Exit
EndIf
debugMsg ($source & " size: " & $sourcesize)

; Start the timer(s)
$copyfiletime = TimerInit()
$progresstimer = TimerInit()

; Start copying
If ($sourcetype = "file") Then
	If (copyFile($source, $destination)	= 0) Then
		$fail = $fail & @LF & $destination
	EndIf
ElseIf ($sourcetype = "dir") Then
	; if any file fails to copy, $fail is updated inside copyDir
	copyDir ($source, $destination)
EndIf

; Stop timer
$copyfiletime = TimerDiff($copyfiletime)

; Get size of destination
GUICtrlSetData($lblbytes, "Checking size ...")
If ($sourcetype = "file") Then
	$destinationsize = FileGetSize($destination)
ElseIf ($sourcetype = "dir") Then
	$destinationsize = DirGetSize($destination)
EndIf
If ($destinationsize = -1) Then
	errorMsg ("Could not retrieve size of " & $destination)
	Exit
EndIf
debugMsg ($destination & " size: " & $destinationsize)

; If destinationsize <> sourcesize, warn user
If ($destinationsize <> $sourcesize) Then
	errorMsg ("Source and destination sizes are different.")
EndIf

; If fail is not empty, warn user
If ($fail <> "") Then
	errorMsg ("Failed to copy:" & @LF & $fail)
EndIf

; If /k switch was given, leave dialog open
If ($showcopytime = 1) Then
	; rename and re-map the "Cancel" button to "Close"
	GUICtrlSetOnEvent($cancelbtn, "closeop")
	GUISetOnEvent($GUI_EVENT_CLOSE, "closeop")
	_GUICtrlButton_SetText ($cancelbtn, "Close")

	; Update display status
	Local $destbyteprefix = 0
	Local $destbytesuffix = ""
	Local $peakspeedprefix = 0
	Local $peakspeedsuffix = ""
	getByteSuffix($destinationsize, $destbyteprefix, $destbytesuffix)
	getByteSuffix($peakspeed, $peakspeedprefix, $peakspeedsuffix)

	GUICtrlSetData($lblbytes, "Total transfered: " & Round($destbyteprefix, $bytedecimalplace) & " " & $destbytesuffix)
	GUICtrlSetData ($lblcurrentfile, "Current file:")
	GUICtrlSetData($lblfiles, "Source: " & shortText($source) & @LF & "Destination: " & shortText($destination))
	GUICtrlSetData($lbltransfer, "Peak speed: " & Round($peakspeedprefix, $bytedecimalplace) & " " & $peakspeedsuffix & "/s")
	GUICtrlSetData($lbltime, "Total time: " & getTime($copyfiletime / 1000))

	while (1)
		Sleep (1000)
	WEnd
EndIf

; End program
Exit

Func killproc($pid)
	; kills a process
	While (ProcessExists($pid))
		ProcessClose($pid)
	WEnd
EndFunc

Func closeop()
	GUISetState(@SW_HIDE)
	Exit
EndFunc

Func cancelop()	
	; if copy is in progress, kill proccess and remove destination
	If (MsgBox(4 + 32 + 256, "Copy File Progress", "Are you sure you want to cancel file copy?") = 6) Then
		GUICtrlSetState($cancelbtn, $GUI_DISABLE)
		WinSetTitle($guiwin, "", $title & " canceling...")
		GUICtrlSetData($lblbytes, "Canceling.....")
		GUICtrlSetData($lbltransfer, "")
		GUICtrlSetData($lbltime, "")
		If ($pid > 0) Then killproc($pid)
		If (FileExists($destination)) Then
			GUICtrlSetData($lblbytes, "Removing " & $destination & " .....")			
			If ($sourcetype = "file") Then
				debugMsg ("Removing file " & $destination)
				FileDelete($destination)
			ElseIf ($sourcetype = "dir") Then
				debugMsg ("Removing directory " & $destination)
				DirRemove($destination, 1)
			EndIf
		EndIf
		Exit
	EndIf
EndFunc

Func progressUpdate($insourcesize, $indestsize, $intransferspeed, $intimeremaining)

	; Don't let progress bar above 100%
	If ($progress > 100) Then
		$progress = 100
	EndIf

	Local $sourceprefix = 0
	Local $sourcesuffix = ""
	getByteSuffix($insourcesize, $sourceprefix, $sourcesuffix)

	Local $byteprefix = 0
	Local $bytesuffix = ""
	getByteSuffix($indestsize, $byteprefix, $bytesuffix)
	
	Local $speedprefix = 0
	Local $speedsuffix = ""
	getByteSuffix($intransferspeed, $speedprefix, $speedsuffix)
	
	Local $speedstring = ""
	Local $timestring = ""

	; set current speed
	If ($intransferspeed > 0) Then
		$speedstring = "Speed: " & Round($speedprefix, $bytedecimalplace) & " " & $speedsuffix & "/s"		
	EndIf
	$progresssubstring = $speedstring

	; set elapsed time and time remaining
	$timestring = "Elapsed: " & getTime(timerdiff($copyfiletime) / 1000)
	If (Int($intimeremaining) > 0) Then
		$timestring = $timestring & " - Remaining: " & getTime($intimeremaining)
	EndIf
	
	; display spin at specified refresh time
	If (TimerDiff($spintimer) > $spinrefresh) Then
		$spintimer = TimerInit()
		; Display spin
		If (StringLen($spin) > 50) Then $spin = StringRight($spin, 1)
		Switch StringRight($spin, 1)
		Case "|"
			$spin = StringReplace($spin, "|", "/", 1, 2)
		Case "/"
			$spin = StringReplace($spin, "/", "-", 1, 2)
		Case "-"
			$spin = StringReplace($spin, "-", "\", 1, 2)
		Case "\"
			$spin = StringReplace($spin, "\", ".", 1, 2) & ".|"
		EndSwitch
		GUICtrlSetData($lblbytes, Round($byteprefix, $bytedecimalplace) & " " & $bytesuffix & " / " & Round($sourceprefix, $bytedecimalplace) & " " & $sourcesuffix & " " & $spin)
	EndIf
	
	; only refresh at specified interval. this should minimize any flickering
	If (TimerDiff($progresstimer) > $progressrefresh) Then
		; restart progress timer
		$progresstimer = TimerInit()
		GUICtrlSetData($progressbar, $progress)
		If ($intransferspeed > 0) Then
			GUICtrlSetData($lbltransfer, $progresssubstring)
		EndIf
		GUICtrlSetData($lbltime, $timestring)
		WinSetTitle($guiwin, "", $title & " " & $progress & " %")
	ElseIf ($progress = 100) Then
		; Always update status at progress of 100%
		GUICtrlSetData($progressbar, $progress)
		WinSetTitle($guiwin, "", $title & " " & $progress & " %")
	EndIf
EndFunc

Func getTime($secs)
	; Take time in seconds and convert to hours, mins, seconds, etc...
	Local $seconds = $secs
	Local $mins = 0
	Local $hours = 0
	Local $days = 0
	Local $weeks = 0
	Local $months = 0
	Local $timestring = Int($seconds) & " secs"

	If ($seconds > 60) Then
		$mins = Int($seconds / 60)
		$seconds = Int($seconds - ($mins * 60))
		If ($seconds <= 0) Then
			$timestring = $mins & " mins"
		Else
			$timestring = $mins & " mins " & $seconds & " secs"
		EndIf
		If ($mins > 60) Then
			$hours = Int($mins / 60)
			$mins = Int($mins - ($hours * 60))
			If ($mins <= 0) Then
				$timestring = $hours & " hours"
			Else
				$timestring = $hours & " hours " & $mins & " mins"
			EndIf
			If ($hours > 24) Then
				$days = Int($hours / 24)
				$hours = Int($hours - ($days * 24))				
				If ($hours <= 0) Then
					$timestring = $days & " days"
				Else
					$timestring = $days & " days " & $hours & " hours"
				EndIf
				If ($days > 7) Then
					$weeks = Int($days / 7)
					$days = Int($days - ($weeks * 7))
					If ($days <= 0) Then
						$timestring = $weeks & " weeks"
					Else
						$timestring = $weeks & " weeks " & $days & " days"
					EndIf
					If ($weeks > 4) Then
						$months = Int($weeks / 4)
						$weeks = Int($weeks - ($months * 4))
						If ($weeks <= 0) Then
							$timestring = $months & " months"
						Else
							$timestring = $months & " months " & $weeks & " weeks"
						EndIf
					EndIf
				EndIf
			EndIf			
		EndIf
	EndIf
	Return $timestring
EndFunc

Func getByteSuffix ($bytes, ByRef $byteprefix, ByRef $bytesuffix)
	Local $byte = 1
	Local $kilobyte = ($byte * 1024)
	Local $megabyte = ($kilobyte * 1024)
	Local $gigabyte = ($megabyte * 1024)
	Local $terabyte = ($gigabyte * 1024)
	Local $petabyte = ($terabyte * 1024)

	Select
	Case $bytes > $petabyte
		$byteprefix = ($bytes / $petabyte)
		$bytesuffix = "PB"	
	Case $bytes > $terabyte
		$byteprefix = ($bytes / $terabyte)
		$bytesuffix = "TB"
	Case $bytes > $gigabyte
		$byteprefix = ($bytes / $gigabyte)
		$bytesuffix = "GB"
	Case $bytes > $megabyte
		$byteprefix = ($bytes / $megabyte)
		$bytesuffix = "MB"
	Case $bytes > $kilobyte
		$byteprefix = ($bytes / $kilobyte)
		$bytesuffix = "KB"
	Case Else
		$byteprefix = $bytes
		$bytesuffix = "bytes"
	EndSelect	
EndFunc

Func validPath ($input)
	; search through invalidChars against input
	Local $invalidCharArray = StringSplit($invalidChars, " ")
	For $x = 1 to $invalidCharArray[0]
		If (StringInStr($input, $invalidCharArray[$x])) Then
			Return 0
		EndIf
	Next
	Return 1
EndFunc

Func debugMsg ($inmsg)
	; show debug message
	If ($debug = 1) Then
		MsgBox(0, "Debug", $inmsg)
	EndIf
EndFunc

Func errorMsg($inmsg)
	; displays error message
	If ($noerror = 0) Then
		MsgBox(16, "Error", $inmsg)
	EndIf
EndFunc

Func copyFile($insource, $indest)
	debugMsg ("Executing copyFile " & $insource & " -> " & $indest)
	Local $sourcefilesize = FileGetSize($insource)
	Local $destfilesize = 0
	Local $sourceprefix = 0
	Local $sourcesuffix = ""
	Local $bytestransfered = 0
	Local $transferspeed = 0
	Local $transfersize = 0
	Local $timeremaining = 0
	Local $index = 1
	Local $destsizeupdate = 0
	Local $runcmd = ""
	Local $procstats
	Local $starttime

	; set source size display
	getByteSuffix($sourcefilesize, $sourceprefix, $sourcesuffix)

	; update current file display
	GUICtrlSetData ($lblcurrentfile, "Current file: " & getFilename(shortText($indest)))

	; if destination's path doesn't exist, create it
	If (FileExists(getDirectory($indest)) = 0) Then
		debugMsg ("copyFile: Creating directory " & getDirectory($indest))
		If (DirCreate(getDirectory($indest)) = 0) Then
			Return 0
		EndIf
	EndIf

	$runcmd = @ComSpec & " /c copy /y " & chr(34) & $insource & chr(34) & " " & Chr(34) & $indest & Chr(34)
	debugMsg ("Command: " & $runcmd)
	$starttime = TimerInit()
	$pid = Run($runcmd, @ScriptDir, @SW_HIDE)
	If ($pid = 0) Then
		errorMsg ("Error running copy command")
		Return 0
	EndIf

	$destsizeupdate = 0
	While (ProcessExists($pid))
		$procstats = ProcessGetStats($pid, 1)
		If (IsArray($procstats) And UBound($procstats) > 4) Then
			If (Int(timerdiff($starttime)) > $statusrefresh) Then
				$transferspeed = Int($destinationsize / (TimerDiff($copyfiletime) / 1000))
				If ($transferspeed > 0) Then
					$timeremaining = (($sourcesize - $destinationsize) / $transferspeed)
				EndIf
				If ($transferspeed > $peakspeed) Then $peakspeed = $transferspeed
				$transfersize = $procstats[4]

				$starttime = TimerInit()				
			EndIf
								
			; set global destinationsize (current transfer size minus previous destfilesize) = bytestransfered
			$destinationsize = ($destinationsize + ($procstats[4] - $destfilesize))
			$destsizeupdate = ($destsizeupdate + ($procstats[4] - $destfilesize))

			$destfilesize = $procstats[4]
			
			If ($destfilesize > $sourcefilesize) Then
				$destfilesize = $sourcefilesize
			EndIf
		EndIf
		
		; Update current file's progress
		GUICtrlSetData($currentprogressbar, Int(($destfilesize / $sourcefilesize) * 100))
		
		; Update overall progress display
		$progress = Int(($destinationsize / $sourcesize) * 100)
		progressUpdate($sourcesize, $destinationsize, $transferspeed, $timeremaining)

		$index = ($index + 1)
	WEnd

	; After copy finished, display destination file size
	debugMsg ("Copy file finished")
	$destfilesize = FileGetSize($indest)
	
	; if file copy was too fast, update global destination size
	If ($destsizeupdate < $destfilesize) Then				
		$destinationsize = ($destinationsize + ($destfilesize - $destsizeupdate))
		debugMsg ("Adding to destinationsize: " & ($destfilesize - $destsizeupdate))
	EndIf
	
	; If destination file doesn't exist, display error
	If (FileExists($indest) = 0) Then
		errorMsg ("Could not create file " & $indest)
		Return 0
	EndIf

	; Compare source file size and destination file size
	debugMsg("Source file size: " & $sourcefilesize)
	debugMsg("Destination file size: " & $destfilesize)
	If ($sourcefilesize <> $destfilesize) Then
		FileDelete($indest)
		Return 0
	EndIf
	
	; Update current file's progress
	GUICtrlSetData($currentprogressbar, Int(($destfilesize / $sourcefilesize) * 100))

	; Update transfer speed (now that file copy is finished)
	$transferspeed = Int($destinationsize / (TimerDiff($copyfiletime) / 1000))
	If ($transferspeed > 0) Then
		$timeremaining = (($sourcesize - $destinationsize) / $transferspeed)
	EndIf
	If ($transferspeed > $peakspeed) Then $peakspeed = $transferspeed

	; Update overall progress
	$progress = Int(($destinationsize / $sourcesize) * 100)
	progressUpdate($sourcesize, $destinationsize, $transferspeed, $timeremaining)

	Return 1
EndFunc

Func copyDir($insource, $indest)
	Local $search
	Local $cursearchitem
	Local $sourcepath = ""
	Local $destpath = ""
	
	; if destination ($indest) doesn't exist, create it first
	If (FileExists($indest) = 0) Then
		debugMsg ("copyDir: Creating directory " & $indest)
		If (DirCreate($indest) = 0) Then
			errorMsg ("Failed to create directory " & $indest)
			Return 0
		EndIf
	EndIf

	; search through current directory
	; if @error = 1, directory is empty, return 1
	$search = FileFindFirstFile ($insource & "\*.*")
	If (@error = 1) Then Return 1
	If ($search = -1) Then
		errorMsg ("Error getting " & $insource & " contents")
		Exit
	EndIf
	While 1
		$cursearchitem = FileFindNextFile($search)
		If @error Then ExitLoop
		$sourcepath = $insource & "\" & $cursearchitem
		$destpath = $indest & "\" & $cursearchitem
		If (StringInStr(StringUpper(FileGetAttrib($sourcepath)), "D")) Then
			; if search is a directory, create it and search for files inside
			debugMsg("Creating directory " & $destpath)
			If (FileExists($destpath) = 0) Then
				If (DirCreate($destpath) = 0) Then
					debugMsg("Failed to create directory " & $destpath)					
					FileClose($search)
					Return 0
				EndIf
			EndIf
			
			debugMsg("Traversing " & $sourcepath)
			If (copyDir($sourcepath, $destpath) = 0) Then
				$fail = $fail & @LF & $destpath
			EndIf
		Else
			; if search is a file, copy it
			debugMsg("Copying file " & $sourcepath & " -> " & $destpath)
			If (copyFile($sourcepath, $destpath) = 0) Then
				$fail = $fail & @LF & $destpath
			EndIf
		EndIf
	WEnd
	FileClose($search)
	
	Return 1
EndFunc

Func displayHelp()
	; displays help message
	; if noerror <> 0, don't display help message

	Local $helpmsg
	
	If ($noerror = 0) Then
		$helpmsg = "CopyFileProgress.exe [options] source destination" & @CRLF _
					  & "  [options]:" & @CRLF _
					  & "   /noerror = disable error messages" & @CRLF _
					  & "   /? = display this help message" & @CRLF _
					  & "   /y = suppress prompt to overwrite destination" & @CRLF _
					  & "   /k = keep dialog open after file copy" & @CRLF _
					  & "   /title:<title> = set title of copy dialog box" & @CRLF _
					  & @CRLF _
					  & "  source = source file/directory" & @CRLF _
					  & "  destination = destination file/directory" & @CRLF
		MsgBox(64, "Help", $helpmsg)
	EndIf
EndFunc

Func getDrive ($inpath)
	; returns the drive for a given path
	Local $tmp
	Local $returnstring
	_PathSplit($inpath, $returnstring, $tmp, $tmp, $tmp)
	Return $returnstring
EndFunc

Func getDirectory ($inpath)
	; returns the directory for a given path
	Local $tmp
	Local $returnstring
	_PathSplit($inpath, $tmp, $returnstring, $tmp, $tmp)
	Return $returnstring
EndFunc

Func getFilename ($inpath)
	; returns the filename for a given path
	Local $tmp
	Local $tmpfilename
	Local $tmpfileext
	Local $returnstring
	_PathSplit($inpath, $tmp, $tmp, $tmpfilename, $tmpfileext)
	$returnstring = $tmpfilename & $tmpfileext
	Return $returnstring
EndFunc

Func shortText($instring)
	; shortens a line of text and places '...' in the middle
	; returns string result
	Local $maxlen = 35
	Local $resultstring = ""

	If (StringLen($instring) > $maxlen) Then
		$resultstring = StringLeft($instring, (Int($maxlen / 2) - 2))
		$resultstring = $resultstring & "..."
		$resultstring = $resultstring & StringRight($instring, (Int($maxlen / 2) - 1))
	Else
		$resultstring = $instring
	EndIf
	Return $resultstring
EndFunc