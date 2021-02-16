#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
Opt('MustDeclareVars', 1)
; #FileCustodian#===============================================================================================================
; Name...........: FileCustodian
; Description ...: Extracts, organizes, manages, and renames media collections as downloaded through various torrent and IRC
; networks. This script should be run with the expectation that it will destroy your entire file structure and as such you are
; responsible for the proper testing of this script on your local machine. By design, there is nothing malicious here, however
; distribution over the internet can allow for all sorts of terrible things to happen to this code.
;
; With all those unpleasantries asside, this code is simple in concept. It takes all the files you download via torrents or IRC
; from the 'done' directories ($wDir) and attempts to sort them out into categories (porn, movies, os, games, televised series...)
; and moves them into a directory respectively. Just below this header you can set those values corresponding to the location you
; want.
; The naming scheme includes spaces (I know, eww) intentionally. It has been designed for optimal compatibility with the MediaBrowser
; extension available for Windows Media Center. I highly recommend this extension.
;
; Should you need to contact me for any reason, you may refer to any email address associated to the account on the site you
; downloaded this from.
;
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: DoubleMcLovin
; Remarks .......: The change log readout has several characters before text. They are explained below:
;					| @ = Indicates a soft warning. Eg. An error that has already handled itself
;					| ! = Indicates an error that could not be automatically solved.
;					| # = Indicates a notice for a file displacement
;					| ^ = Indicates a file deletion
; A step-by-step message for diagnosis is available in the misc.log file.
; Enjoy, modify and release, but please keep my name attached.
; Warnings ......: This should _only_ be used in a native windows environment!
;					| This script will not directly delete any files, but will move many to the recycle bin for various reasons.
;					| This script will delete all files with the words 'german' or 'sample' in them.
; ===============================================================================================================================

;Header
Global $ini = @ScriptDir & '\' & 'local.ini'
Global $delay = 300000 ;Delay time in minutes
Global $cLog = FileOpen(@ScriptDir & "\logs\changes.log", 41)
Global $dLog = FileOpen(@ScriptDir & "\logs\debug.log", 41)
Global $mLog = FileOpen(@ScriptDir & "\logs\misc.log", 41)
Global $wDir, $other_dir, $movie_dir, $series_dir, $porn_dir, $os_dir, $game_dir, $target, $videos, $video, $files, $target_tmp, $msgb, $error, $file, $subfile, $subfiles, $exit, $move_target, $fType, $ed_root, $gc_dir
Global $time = @MON & "/" & @MDAY & "/" & @YEAR & " " & @HOUR & ":" & @MIN & " || "
Global $footer = @TAB & "LINE: "
Global $ver = '1.3.0.4'

;Read globals from ini
;If the .ini file already exists
If FileExists ($ini) Then
	;Sets the values of critical locations
	 $wDir = _IniRead ($ini,'Directories','wDir')
	 $other_dir = _IniRead ($ini,'Directories','other_dir')
	 $movie_dir = _IniRead ($ini,'Directories','movie_dir')
	 $series_dir = _IniRead ($ini,'Directories','series_dir')
	 $porn_dir = _IniRead ($ini,'Directories','porn_dir')
	 $os_dir = _IniRead ($ini,'Directories','os_dir')
	 $game_dir = _IniRead ($ini,'Directories','game_dir')
;If the .ini file does not exist
Else
	;Determine necessary variables
	 $wDir = _InputBox ('wDir','FileCustodian - wDir','Please enter the full path to where your finished downloads are sent. This should be the directory with unsorted downloads immediately after download, for more help see the wiki.','c:\system66\downloads\done')
	 $other_dir = _InputBox ('other_dir','FileCustodian - Other Files','Please enter the full path to where files can be moved if their type cannot be determined. For more help see the wiki.','c:\system66\downloads\extracted')
	 $movie_dir = _InputBox ('movie_dir','FileCustodian - Movies','Please enter the full path to where your movies are stored locally. For more help see the wiki.','c:\system66\media\movies')
	 $series_dir = _InputBox ('series_dir','FileCustodian - ','Please enter the full path to where your series files are stored locally. For more help see the wiki.','c:\system66\media\series')
	 $porn_dir = _InputBox ('porn_dir','FileCustodian - XXX','Please enter the full path to where your... explicit files are stored locally. For more help see the wiki.','c:\system66\media\other')
	 $os_dir = _InputBox ('os_dir','FileCustodian - OS','Please enter the full path to where operating systems are stored locally. For more help see the wiki.','c:\system66\useful\os')
	 $game_dir = _InputBox ('game_dir','FileCustodian - Games','Please enter the full path to where your games are stored locally. For more help see the wiki.','c:\system66\media\games')
EndIf
Global $mDir = $movie_dir & '|' & $series_dir
Global $mDirs = StringSplit($mDir, "|")
;Logs the directories chosen.
FileWrite ($mLog,'Setting key variables to...' & @CRLF & '$wDir = ' & $wDir & @CRLF & '$movie_dir = ' & $movie_dir & @CRLF & '$series_dir = ' & $series_dir & @CRLF & '$porn_dir = ' & $porn_dir & @CRLF & '$other_dir = ' & $other_dir & @CRLF & '$game_dir = ' & $game_dir & @CRLF & '$os_dir = ' & $os_dir & @CRLF)

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: Main
; Description ...:
; Author ........: DoubleMcLovin
; Remarks .......:
; ===============================================================================================================================
;~ FileCopy(@ScriptFullPath, @ScriptDir & '\' & $ver & "\" & 'File.Custodian-' & $ver & '.au3', 9) ;backs up script every time it runs
;Header messages
FileWrite ($cLog, '########################################################################' & @CRLF & '# Beginning script... ' & StringTrimRight ($time,3) & @CRLF & '########################################################################' & @CRLF)
FileWrite ($dLog, '########################################################################' & @CRLF & '# Beginning script... ' & StringTrimRight ($time,3) & @CRLF & '########################################################################' & @CRLF)
FileWrite ($mLog, '########################################################################' & @CRLF & '# Beginning script... ' & StringTrimRight ($time,3) & @CRLF & '########################################################################' & @CRLF)
While 1
	;Don't know if this works...
	FileSetAttrib($wDir & "\*", "-R", 1) ;Removes the Read-Only attribute.
	_ChangeDir ($wDir,@ScriptLineNumber)
	$files = FileFindFirstFile("*")
	If @error Then ;empty dir
	ElseIf $files = -1 Then ;Error in search string
		FileWrite($dLog, $time & '! Script encountered an error, closing.' & $footer & @ScriptLineNumber & @CRLF)
	Else
		While 1
			$exit = 0 ; Resets exit code
			$fType = 0 ; Resets file type
			$target = FileFindNextFile($files) ;Cycles through files in watched dirs
			If @error Then ExitLoop ;empty
			If @extended = 1 Then $fType = 2 ;directory check
			FileWrite($mLog, $time & 'Working on target: ' & $target & $footer & 'i' & @ScriptLineNumber & @CRLF)
			$error = FileExists(@WorkingDir & '\' & $target)
			;Determine type for $fType
			If $error = 1 And $fType = 0 Then ;exists and is not a directory
				$fType = _GetType($target)
			ElseIf $error = 0 Then ;DNE
				$fType = 0
			ElseIf $fType = 2 Then ;directory
			Else ;bizzarre unexplainable error
				FileWrite($dLog, $time & '! Script encountered an error, closing. Current dir\file: "' & @WorkingDir & '\' & $target & '".' & $footer & @ScriptLineNumber & @CRLF)
				Exit
			EndIf
			;Perform actions based on $fType (archive, directory, file)
			Switch $fType
				Case 0 ;File does not exist
					FileWrite($dLog, $time & '@ File "' & @WorkingDir & '\' & $target & '" does not exist.' & $footer & @ScriptLineNumber & @CRLF)
				Case 1 ;Archive
					_Extract($target, $wDir, @ScriptLineNumber)
				Case 2 ;Directory
					_ExploreDir($target, @ScriptLineNumber)
					_GetCategory($target, @ScriptLineNumber, @WorkingDir)
				Case 3 ;File
					_PutFile($target, @ScriptLineNumber)
			EndSwitch
			FileWriteLine($mLog, '------------------------------------------------------------------------------')
;~ 				If $exit = 1 Then ExitLoop	;I left this here to remind myself not to do this cause it would just be silly.
		WEnd
	EndIf
	;Cycles through watched dirs
	For $i2 = 1 To $mDirs[0]
		;Removes the Read-Only attribute.
		FileSetAttrib($mDirs[$i2] & "\*", "-R", 1)
		_ChangeDir ($mDirs[$i2],@ScriptLineNumber)
		$videos = FileFindFirstFile("*")
		While 1
			$video = FileFindNextFile($videos)
			If @error Then ExitLoop ;empty
			;Directory
			If @extended Then
				$video = _RenameTarget ($video, 2, @ScriptLineNumber)
				_ExploreDir ($video, @ScriptLineNumber)
			;File
			Else
				$video = _RenameTarget ($video, 1, @ScriptLineNumber)
			EndIf
			;Clears the exit code
			$exit = 0
		WEnd
	Next
	;This adds to readability of the $mLog
	FileWriteLine ($mLog,'########################################################################')
	FileWrite ($mLog, $time & 'Sleeping...' & @CRLF)
	;Clean up FileFindFirst
	FileClose($videos)
	FileClose($files)
	;Flush files so they can be read during sleep
	FileFlush($cLog)
	FileFlush($dLog)
	FileFlush($mLog)
	;Enable exit for testing purposes.
;~ 	Exit
	Sleep($delay)
WEnd ;==>Main

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _IniRead()
; Description ...: Attempts to read the given variable from an ini file, if the value is not there then it will be asked and added.
; Syntax ........: _IniRead ($irFile, $irSection, $irKey, $irDefault = 0)
; Parameters ....: $irFile - The .ini file to read
; ...............: $irSection - The section in the ini file to look for
; ...............: $irKey - The key inside the section to look for
; ...............: $irDefault (optional) - The default value for the string
; Return values .: Returns the path entered into the inputbox
;				   |Success: Returns the value of the key
;				   |Failure: Exits
; Author ........: DoubleMcLovin
; Remarks .......: Sets all the variables based on ini values. Defaults to 0, if any of them come up 0 then it will invoke a _InputBox to get it and then write it to file.
; ===============================================================================================================================

Func _IniRead ($irFile, $irSection, $irKey, $irDefault = 'NoKey')
	;Read the ini
	Local $irResult = IniRead ($irFile,$irSection,$irKey,$irDefault)
	;If the value could not be found
	If $irResult = 'NoKey' Then
		;Asks the user for the value to the section
		$irResult = _InputBox ($irKey, 'FileCustodian - Warning','Please enter the full path to ' & $irKey & '. For more help see the wiki.','')
	EndIf
	Return $irResult
EndFunc	;==>IniRead

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _InputBox()
; Description ...: Opens a prompt with the given text and default value to return a value specified by the user.
; Syntax ........: _InputBox ($ibKey, $ibTitle, $ibText, $ibDefault)
; Parameters ....: $ibTitle = The title of the window
; ...............: $ibText = The text in the window
; ...............: $ibKey = The key being used to add this string to the local .ini file
; ...............: $ibDefault = The default answer for the input box
; Return values .: Returns the path entered into the inputbox
;				   |Success: Returns the path specified
;				   |Failure: Exits
; Author ........: DoubleMcLovin
; Remarks .......: None
; ===============================================================================================================================

Func _InputBox($ibKey, $ibTitle, $ibText, $ibDefault)
	If $exit = 1 Then Exit
	Local $ibAnswer = InputBox($ibTitle,$ibText,$ibDefault," M")
	Switch @error
	;OK - The string returned is valid
	Case 0
		If Not FileExists ($ibAnswer) Then
			$msgb = MsgBox (4,'Warning!', 'The directory you specified does not exist. Would you like to create it now?')
			;Yes was pressed
			If $msgb = 6 Then
				;Create the directory
				$error = DirCreate ($ibAnswer)
				;Failed to create dir
				If $error = 0 Then
					;Try again
					$error = _InputBox ($ibKey, $ibTitle,$ibText,$ibDefault)
					;Returns the value of return from the function call above
					Return $error
				EndIf
			;No was pressed
			Else
				;Try again
				$error = _InputBox ($ibKey, $ibTitle,$ibText,$ibDefault)
				;Returns the value of return from the function call above
				Return $error
			EndIf
		EndIf
	;Problems
	Case 1 To 5
		;Can't continue without these values, so exit after confirming. This also gives another shot at launching the prompt if it failed.
		$msgb = MsgBox (4, 'Warning!', 'The program requires this value to continue. Are you sure you want to cancel setting this value? (program will exit if you hit yes)')
		If $msgb = 6 Then Exit
		;Flags $exit so that we can't get stuck in a perpetually failing prompt
		$exit = 1
		;If we don't want to exit, then let's try again!
		$error = _InputBox ($ibKey, $ibTitle,$ibText,$ibDefault)
		;Returns the value of return from the function call above
		Return $error
	EndSwitch
	IniWrite ($ini,'Directories', $ibKey,$ibAnswer)
	Return $ibAnswer
EndFunc	;==>_InputBox

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ExploreDir()
; Description ...: Opens directories to interact with files therein
; Syntax ........: _ExploreDir ($fDir, $line_num)
; Parameters ....: $fDir - Initial directory working in
; ...............: $line_num - Line number from where this func was called
; Return values .: Result of explore
;				   |1 - Success
;				   |0 - Failure
; Author ........: DoubleMcLovin
; Remarks .......: None
; ===============================================================================================================================

Func _ExploreDir($fDir, $line_num)
	If $exit = 1 Then Return
	FileWrite($mLog, $time & 'Exploring dir: ' & $fDir & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	$ed_root = @WorkingDir & '\'
	_ChangeDir ($fDir,@ScriptLineNumber)
	$subfiles = FileFindFirstFile("*")
	;If the dir is empty
	If @error Then
		_ChangeDir ($ed_root,@ScriptLineNumber)
		_RemoveTarget($fDir, 2, @ScriptLineNumber, 'Dir is empty.')
		;Clears the dir we just deleted, we don't return because we need to change dirs again
		$fDir = ""
	;error matcing
	ElseIf $subfiles = -1 Then
		FileWrite($dLog, $time & '@ Error, no files matched the search string.' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
		_ChangeDir ($ed_root,@ScriptLineNumber)
		Return 0
	Else
		While 1
			;reset exit code
			$exit = 0
			;reset fType
			$fType = 0
			$subfile = FileFindNextFile($subfiles)
			;No more files
			If @error Then ExitLoop
			;directory check
			If @extended = 1 Then $fType = 2
			FileWrite($mLog, $time & 'Looking at the subfile: ' & $subfile & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
			$error = FileExists(@WorkingDir & '\' & $subfile)
			;exists and is not a dir
			If $error = 1 And $fType = 0 Then
				$fType = _GetType($subfile)
				;DNE
			ElseIf $error = 0 Then
				$fType = 0
				;Dirs are already set to '2' so we don't need to _GetType
			EndIf
			Switch $fType
			;File does not exist
			Case 0
				FileWrite($dLog, $time & '@ File "' & @WorkingDir & '\' & $subfile & '" does not exist.' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
			;Archive
			Case 1
				_Extract($subfile, @WorkingDir, @ScriptLineNumber)
				;Reloads files to prevent loading removed archive parts
				$subfiles = FileFindFirstFile('*')
			;Directory
			Case 2
				_UnloadDir($subfile, @ScriptLineNumber)
			;File
			Case 3
				_RenameTarget($subfile, 1, @ScriptLineNumber)
				;Puts the file into season directory if it matches post-rename season filter
				If StringRegExp ($subfile,"(?i).+\sS\d{2}\sE\d{2}.+") Then _PutFile ($subfile, @ScriptLineNumber, 1)
			EndSwitch
		WEnd
	EndIf
	FileClose($subfiles)
	_ChangeDir ($ed_root,@ScriptLineNumber)
	Return 1
EndFunc   ;==>_ExploreDir

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ChangeDir()
; Description ...: Changes the current directory
; Syntax ........: _ChangeDir ($cd_target, $line_num)
; Parameters ....: $cd_target - Where we are cd'ing into
; ...............: $line_num - The line number where this call was referenced. Used for debugging purposes.
; Return values .: result of cd
;				   |1 - Success
;				   |0 - Failure
; Author ........: DoubleMcLovin
; Remarks .......: None
; ===============================================================================================================================

Func _ChangeDir (ByRef $cd_target, $line_num)
	$error = FileChangeDir($cd_target)
	If $error = 0 Then ;failed to change Dir
		If FileExists($cd_target) Then
			FileWrite($dLog, $time & '! Could not change dir from "' & @WorkingDir & '\' & '" to "' & $cd_target & '". Unknown reason.' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
		Else
			FileWrite($dLog, $time & '@ Could not change dir from "' & @WorkingDir & '\' & '" to "' & $cd_target & '". Directory does not exist.' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
		EndIf
		;sets exit to skip this operation
		$exit = 1
		Return 0
	Else
		FileWrite($mLog, $time & 'CD to ' & $cd_target & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	EndIf
	Return 1
EndFunc	;==>_ChangeDir

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _MoveTarget()
; Description ...: Moves a file or folder
; Syntax ........: _MoveTarget ($mt_file, $destination, $type, $line_num)
; Parameters ....: $mt_file - File/Dir to be moved ($target)
; ...............: $destination - Where the file/folder is being moved
; ...............: $type - Determines file or folder
; 					| $type = 1 File
;					| $type = 2 Directory
; ...............: $line_num - The line number where this call was referenced. Used for debugging purposes.
; Return values .: Result of move
;				   |0 = Failure or Error
;				   |Success = new name/location of $mt_file
; Author ........: DoubleMcLovin
; Remarks .......: $mt_file and $destination must be full path to file
; ===============================================================================================================================

Func _MoveTarget($mt_file, $destination, $type, $line_num)
	If $exit = 1 Then Return 0
	;Make sure there are no trailing backslashes, this causes problems with DirMove()
	If StringRight ($mt_file,1) = '\' Then $mt_file = StringTrimRight ($mt_file,1)
	If StringRight ($destination,1) = '\' Then $destination = StringTrimRight ($destination,1)
	;First make sure our file exists
	If FileExists($mt_file) Then
		;Next make sure the destination doesn't exist or if it does overwrite it
		If FileExists($destination) Then
			Switch $type
			;File
			Case 1
				;If the target is smaller than or equal to the destination copy
				If FileGetSize($mt_file) <= FileGetSize($destination) Then
					;If the names are the _exact_ same
					If StringToBinary($mt_file) = StringToBinary($destination) Then
						;Return 0 for failure
						Return 0
					Else
						FileWrite($mLog, $time & 'File "' & $mt_file & '" flagged for deletion. The file "' & $destination & '" already exists. ' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
						;$mt_file is smaller than the copy and they don't have the same name thus are not the same file. So delete $mt_file.
						_RemoveTarget($mt_file, $type, @ScriptLineNumber, 'Copy in destination is larger than original.')
						;Returns blank to reset $mt_file
						Return
					EndIf
				;If the current is larger than the destination
				ElseIf FileGetSize($mt_file) > FileGetSize($destination) Then
					FileWrite($mLog, $time & 'File "' & $destination & '" flagged for deletion. The file "' & $mt_file & '" is larger. ' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
					_RemoveTarget($destination, $type, @ScriptLineNumber, 'Old file is smaller than a new file with the same name.')
				EndIf
			;Dir
			Case 2
				;If the newer is smaller than or equal to the older
				If DirGetSize($mt_file) <= DirGetSize($destination) Then
					;If the names are the exact same do nothing
					If StringToBinary($mt_file) = StringToBinary($destination) Then
					Else
						FileWrite($mLog, $time & 'Dir "' & $mt_file & '" flagged for deletion. The dir "' & $destination & '" already exists. ' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
						_RemoveTarget($mt_file, $type, @ScriptLineNumber, 'Copy in destination is larger than original.')
						;Returns blank to reset $mt_file
						Return
					EndIf
				;If the current is larger than the destination
				ElseIf DirGetSize($mt_file) > DirGetSize($destination) Then
					FileWrite($mLog, $time & 'Dir "' & $destination & '" flagged for deletion. The dir "' & $mt_file & '" is larger. ' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
					_RemoveTarget($destination, $type, @ScriptLineNumber, 'Old dir is smaller than a new dir with the same name.')
				EndIf
			EndSwitch
		EndIf
		Switch $type
			;File
			Case 1
				$error = FileMove($mt_file, $destination, 8)
				If $error = 1 Then ;success
					FileWrite($cLog, $time & '# File "' & $mt_file & '" was moved to "' & $destination & '". ' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
				Else
					FileWrite($dLog, $time & '! File "' & $mt_file & '" cannot be moved to "' & $destination & '". Unknown reason, skipping.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
					$exit = 1
					Return 0
				EndIf
			Case 2 ;Dir
				$error = DirMove($mt_file, $destination, 0)
				If $error = 1 Then ;success
					FileWrite($cLog, $time & '# Directory "' & $mt_file & '" was moved to "' & $destination & '". ' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
				Else
					FileWrite($dLog, $time & '! Directory "' & $mt_file & '" cannot be moved to "' & $destination & '". Unknown reason, skipping.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
					$exit = 1
					Return 0
				EndIf
		EndSwitch
	EndIf
	FileWrite($mLog, $time & $mt_file & ' is now located at ' & $destination & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	Return $destination
EndFunc   ;==>_MoveTarget

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RenameTarget()
; Description ...: Renames file to remove bad syntax and put all files into a standard format
; Syntax ........: _RenameTarget (ByRef $rt_file, $type, $line_num, $rt_root)
; Parameters ....: $rt_file - Dir/File being renamed ($target)
; ...............: $type - Determines file or folder
; 				   | $type = 1 File
;				   | $type = 2 Directory
; ...............: $line_num - The line number where this call was referenced. Used for debugging purposes.
; ...............: $rt_root (optional) - The root directory. Used for subdirs.
; Return values .: Result of rename
;				   |Failure: 0
;				   |Success: new name of $rt_file
; Author ........: DoubleMcLovin
; Remarks .......: Currently only works for files, not directories.
; ===============================================================================================================================
Func _RenameTarget($rt_file, $type, $line_num, $rt_root = @WorkingDir)
	;exit check used for files that encounter an error
	If $exit = 1 Then Return 0
	FileWrite($mLog, $time & 'Passing "' & $rt_file & '" through the SRE filter.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	;Language check. Return is blank because file is deleted
	If StringInStr($rt_file, "german") Then
		_RemoveTarget($rt_file, $type, @ScriptLineNumber, "File was German.")
		Return 1
	;Kill off .txt,.nfo, and .sfv files and those annoying Thumbs.db files
	ElseIf StringRegExp($rt_file, "(?i)(.*\.(sfv|txt|nfo)|Thumbs.db)") Then
		_RemoveTarget($rt_file, $type, @ScriptLineNumber, "File was a leftover info file.")
		Return 1
	EndIf
	;SRE filter - ', become blank, & becomes 'and', spaces and other characters become decimals, and multiple decimals become a single decimal.
	$move_target = StringRegExpReplace(StringRegExpReplace(StringReplace(StringReplace(StringRegExpReplace ($rt_file,"(?i)[',]",""),'&','and'),' ','.'),"(?i)[\Q/.>[]{};:|!@#$%^*()-_=+<\E]", "."), "\.{2,}", ".")
	;Trim trailing decimal
	If StringRight($move_target, 1) = "." Then $move_target = StringTrimRight($move_target, 1)
	;Fix the multiple decimals problem
	$move_target = StringRegExpReplace ($move_target, "\.{2,}", ".")
	;Only perform garbage remove filter on directories to avoid accidently removing extension or season text.
	If $type = 2 Then
		;Garbage remover, gets rid of group text, year, and quality text in file names.
		While 1
			;Try and grab as much of the name as it can, leaving behind all the grouptext and file info.
			Local $rm_file_tmp = StringRegExp($move_target, '(?i)(.+)\.(?:HDTV|repack|rerip|nuked|DC|proper|pdtv|dvdscr|DTS|extended|WS|hd|xvid|pdtv|ppv|eng|p|limited|unrated|(?:19|20)\d{2}|CHD|uncut|(?:dvd|bd|br|bluray)rip|r5|(?:720|1080|480)(?:p|i)|bluray)(?:\..*)?\b', 1)
			;Actually removes the garbage above
			If IsArray($rm_file_tmp) Then
			;Only keeps text before the garbage filter
			$move_target = $rm_file_tmp[0]
			Else
				;Fix the multiple decimals problem
				$move_target = StringRegExpReplace ($move_target, "\.{2,}", ".")
				;Since were done removing garbage, move on.
				ExitLoop
			EndIf
			;kill the trailing dot
			If StringRight ($move_target,1) = '.' Then $move_target = StringTrimRight ($move_target,1)
		WEnd
	EndIf
	;Writes the SRE filterd file to console. Useful for debugging.
	ConsoleWrite ($move_target & @CRLF)
	Switch $type
	;File
	Case 1
		;local vars used with the series check
		Local $move_target_tmp, $SeriesName, $SeasonNum, $EpisodeNum, $EpisodeTitle, $Extension
		;Series check: Checks for a file with no series #, then a file with a strange combination (s{1}e{2}-e{2} or s{1}e{2}-e{2} or s{1}\.?e{2})
		;Then checks for standard format (eg:s{2}\.?e{2})
		#Region ;e{2}
		;Checks for exactly 2 digits for when the series number is not included.
		$move_target_tmp = StringRegExp ($move_target,"(?=(?:\b\D*\d{2}\D{2}.*\b))(.+)\.(\d{2}(?!(?:\d+|.*\d+\D+\d+)))\.?(.*)(\..+)\b",1)
		If IsArray ($move_target_tmp) Then
			;Assign appropriate values
			$SeriesName = $move_target_tmp[0]
			;The season number was blank, assume season one
			$SeasonNum = '01'
			$EpisodeNum = $move_target_tmp[1]
			$EpisodeTitle = $move_target_tmp[2]
			$Extension = $move_target_tmp[3]
		#EndRegion ;e{2}
		Else
			#Region ;s{1}\D?e{2}-e{2}
			$move_target_tmp = StringRegExp ($move_target,"(.+)\.\D?(\d{1})\D{0,2}(\d{2})\.(\d{2})\.?(.*)(\..+)\b",1)
			If IsArray ($move_target_tmp) Then
				;Assign appropriate values
				$SeriesName = $move_target_tmp[0]
				;The season number was blank, assume season one
				$SeasonNum = '0' & $move_target_tmp[1]
				$EpisodeNum = $move_target_tmp[2] & '-' & $move_target_tmp[3]
				$EpisodeTitle = $move_target_tmp[4]
				$Extension = $move_target_tmp[5]
			#EndRegion ;s{1}e{2}-e{2}
			Else
				#Region ;\D?s{2}\D?e{2}-e{2}
				$move_target_tmp = StringRegExp ($move_target,"(.+)\.\D?(\d{2})\D{0,2}(\d{2})\.(\d{2})\.?(.*)(\..+)\b",1)
				If IsArray ($move_target_tmp) Then
					;Assign appropriate values
					$SeriesName = $move_target_tmp[0]
					$SeasonNum = $move_target_tmp[1]
					;Sets the episodes with a '-' between them
					$EpisodeNum = $move_target_tmp[2] & '-' & $move_target_tmp[3]
					$EpisodeTitle = $move_target_tmp[4]
					$Extension = $move_target_tmp[5]
				#EndRegion ;\D?s{2}\D?e{2}-e{2}
				Else
					#Region ;\D?s{1}.?e{2}
					$move_target_tmp = StringRegExp ($move_target,"(.+)\.\D?(\d{1})\D{0,2}(\d{2}(?!(?:\d+|.*\d+\D+\d+)))\.?(.*)(\..+)\b",1)
					If IsArray ($move_target_tmp) Then
						;Assign appropriate values
						$SeriesName = $move_target_tmp[0]
						;The season number was a single digit, add preceeding '0'
						$SeasonNum = '0' & $move_target_tmp[1]
						$EpisodeNum = $move_target_tmp[2]
						$EpisodeTitle = $move_target_tmp[3]
						$Extension = $move_target_tmp[4]
					#EndRegion ;\D?s{1}.?e{2}
					Else
						#Region ;\D?s{2}\D?e{2}
						$move_target_tmp = StringRegExp ($move_target,"(?=(?:\b\D*\d{2}\D*\d{2}\D*\b))(.+)(?<!(?:\d))\.\D?(\d{2})\D{0,2}(\d{2})(?!(?:.*\d+))\.?(.*)(\..+)\b",1)
						If IsArray ($move_target_tmp) Then
							;Assign appropriate values
							$SeriesName = $move_target_tmp[0]
							$SeasonNum = $move_target_tmp[1]
							$EpisodeNum = $move_target_tmp[2]
							$EpisodeTitle = $move_target_tmp[3]
							$Extension = $move_target_tmp[4]
						#EndRegion ;\D?s{2}\D?e{2}
						Else
							#Region ; \w*\d..\w*\d{1,2}
							$move_target_tmp = StringRegExp ($move_target,"(?=(?:\b.*\.\w*\.?\d{1}\.?\w*\.?\d{1,2}.*\b))(.+)(?<!(?:\d))\.(?:\w+\.?)(\d)\.?(?:\w*\.?)(\d{1,2})\.?(.*)(\..+)\b",1)
							If IsArray ($move_target_tmp) Then
								;Assign appropriate values
								$SeriesName = $move_target_tmp[0]
								;Adds a preceeding 0 since this was only 1 digit
								$SeasonNum = '0' & $move_target_tmp[1]
								;Checks for a double digit or single digit episode number
								If StringRegExp ($move_target_tmp[2],'\d{2}') Then
									$EpisodeNum = $move_target_tmp[2]
								Else
									;If we only have 1 digit, add a preceeding 0
									$EpisodeNum = '0' & $move_target_tmp[2]
								EndIf
								$EpisodeTitle = $move_target_tmp[3]
								$Extension = $move_target_tmp[4]
							#EndRegion ;\w*\d..\w*\d{1,2}
							;If all series filters fail then perform movie filter
							Else
								;checks for media extension
								If StringRegExp ($move_target,'(?i).*\.(avi|oog|mov|wmv|mkv)\b') Then
									;Checks for parts
									If StringRegExp ($move_target,'(?i).*(?:(?:cd|part)\D?(\d{1,2}))(\..{1,3}\b)') Then
										;catches part and extension
										$move_target_tmp = StringRegExp ($move_target,'(?i).*(?:(?:cd|part)\D?(\d{1,2}))(\..+\b)',1)
										;Adds cd ## and extension
										$move_target_tmp = ' CD ' & $move_target_tmp[0] & $move_target_tmp[1]
									Else
										;If this is not a part, then grab extension and decimal
										$move_target_tmp = StringRegExp ($move_target,'.*(\..+\b)',1)
										;This was easier than reordering the $move_target set below
										$move_target_tmp = $move_target_tmp[0]
									EndIf
									;Gets the name of the current directory by looking at everything after the most recent '\'
									Local $working_dir = StringRegExp (@WorkingDir,'.*\\(?!\\)(.*)',1)
									;Grab the name of the parent directory and add the extension (or CD #.ext)
									$move_target = @WorkingDir & '\' & $working_dir[0] & $move_target_tmp
								EndIf
								FileWrite($mLog, $time & 'Set moving name as ' & $move_target & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		;If it looks like we accidently named the file to be "Season #" then we goofed and need to quit
		If StringRegExp ($move_target,'(?i)\bSeason.\d{1,2}\b') Then
			FileWrite($dLog, $time & 'Error! Tried to name ' & $rt_file & ' to ' & $move_target & '. Skipping.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
			$exit = 1
			Return 0
		EndIf
		;Checks to see if we are working with a season file or not
		If $SeasonNum >= 1 Then
			$move_target = $SeriesName & ' S' & $SeasonNum & ' E' & $EpisodeNum & ' - ' & $EpisodeTitle
			;Checks to see if $EpisodeTitle is blank and kill trailing delineator if it is
			If StringRight ($move_target,3) = ' - ' Then $move_target = StringTrimRight ($move_target,3)
			;Strips decimals and adds extension
			$move_target = StringReplace ($move_target, '.',' ') & $Extension
			Local $root_check = StringReplace ($SeasonNum, '0','')
			;Checks to see if we are inside a directory to match the season# or not
			If StringInStr (@WorkingDir,'Season ' & $root_check,2,-1,1,StringLen ($root_check)) Then
				$move_target = @WorkingDir & '\' & $move_target
			;If we are in a season directory that doesn't match the season #
			ElseIf StringInStr (@WorkingDir,'Season') Then
				$move_target = $rt_root & '\' & 'Season ' & $root_check & '\' & $move_target
			;Put it into a season dir
			Else
				;Sets $move_target to include a season dir
				$move_target = @WorkingDir & '\' & 'Season ' & $root_check & '\' & $move_target
			EndIf
		;If we are not working with a season file (as determined by $SeasonNo >=\ 1)
		Else
			;Makes an array with 2 parts, the file name and the extension.
			Local $move_target_name = StringRegExp ($move_target,'(.*\\?)(?!\\)(.+)(\..{1,4}\b)',1)
			If IsArray ($move_target_name) Then
				;Replaces the '.' with a ' ' in the filename and then adds the extension (with its decimal)
				$move_target = $move_target_name[0] & StringReplace($move_target_name[1], ".", " ") & $move_target_name[2]
			;no extension
			Else
				;Flag exit code
				$exit = 1
		 		FileWrite($dLog, $time & $rt_file & ' has no extension.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
				;Return fail
				Return 0
			EndIf
		EndIf
		;Writes the name to log
		FileWrite($mLog, $time & 'Set moving name as ' & $move_target & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	;Directory
	Case 2
		;Replaces decimals with spaces
		$move_target = @WorkingDir & '\' & StringReplace($move_target, ".", " ")
	EndSwitch
	;If we aren't trying to change the name, no need to call another function
	If @WorkingDir & '\' & $rt_file = $move_target Then Return $rt_file
	_MoveTarget(@WorkingDir & '\' & $rt_file, $move_target, $type, @ScriptLineNumber)
	;Prevents using the $move_target name for $target
	If $exit = 1 Then Return 0
	FileWrite($mLog, $time & $rt_file & ' is now ' & $move_target & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	Return $move_target
EndFunc   ;==>_RenameTarget


; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RemoveTarget()
; Description ...: Deletes directory with error check
; Syntax ........: _RemoveTarget($type, $rm_file, $line_num, $reason)
; Parameters ....: $dir - Directory to be removed
; ...............: $type - Determines file or folder
; 				   | $type = 1 File
;				   | $type = 2 Directory
; ...............: $line_num - The line number where this call was referenced. Used for debugging purposes.
; ...............: $reason - A text string by user input for use in the log
; Return values .: Result of removal
;				   |0 = Failure or Error
;				   |1 = Success
; Author ........: DoubleMcLovin
; Remarks .......: Sends to recycle bin
; ===============================================================================================================================

Func _RemoveTarget($rm_file, $type, $line_num, $reason)
	If $exit = 1 Then Return 0
	FileWrite($mLog, $time & 'Removing ' & $rm_file & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	$error = FileRecycle($rm_file)
	Switch $type
		Case 1 ;File
			;success
			If $error = 1 Then
				FileWrite($cLog, $time & '^ File "' & $rm_file & '" was deleted. ' & $reason & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
			Else
				FileWrite($dLog, $time & '! File "' & $rm_file & '" cannot be deleted. Unknown reason. ' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
				Return 0
			EndIf
		Case 2 ;Dir
			;success
			If $error = 1 Then
				FileWrite($cLog, $time & '^ Directory "' & $rm_file & '" was deleted. ' & $reason & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
			Else
				FileWrite($dLog, $time & '! Directory "' & $rm_file & '" cannot be deleted. Unknown reason.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
				Return 0
			EndIf
	EndSwitch
	Return 1
EndFunc   ;==>_RemoveTarget

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _PutFile()
; Description ...: Organizes loose files
; Syntax ........: _PutFile($pf_file, $line_num, $series_check)
; Parameters ....: $pf_file - File to be extracted
; ...............: $line_num - line number that called this function
; ...............: $series_check (optional) - Indicates that we are to organize this file into a season directory
; 					| 0(default) = not a series, perform normal put
;					| 1 = Is a series, perform series put
; Return values .: Result of 'put'
;				   |0 = Failure or Error
;				   |1 = Success
; Author ........: DoubleMcLovin
; Remarks .......: This function attempts to place loose files in the download directory into a directory named after themselves.
; If two or more files have similar names, they will be grouped in the same folder. Similar name is determined by removing all
; numeric characters from the name (excluding extension) for analysis.
; ===============================================================================================================================

Func _PutFile($pf_file, $line_num, $series_check = 0)
	If $exit = 1 Then Return 0
	Switch $series_check
	;Do not perform series check
	Case 0
		FileWrite($mLog, $time & 'Putting the file ' & $pf_file & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		;Gets the name up until the extension
		$target_tmp = StringRegExp($pf_file, '(?i)(.+)\.(.{1,4}\b)', 1)
		_MoveTarget (@WorkingDir & '\' & $pf_file, @WorkingDir & '\' & $target_tmp[0] & '\' & $pf_file, 1, @ScriptLineNumber)
	EndSwitch
	Return 1
EndFunc   ;==>_PutFile

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GetType()
; Description ...: Gets the file type for future operations
; Syntax ........: _GetType ($gt_file)
; Parameters ....: $gt_file - File being analyzed
; Return values .: A number corresponding to type of file, directory, or archive.
;				   | 0 - $exit flagged
;				   | 1 - Archive
;				   | 2 - Directory (declared elsewhere)
;				   | 3 - File
;				   | 4 - Part of an archive
; Author ........: DoubleMcLovin
; Remarks .......: None
; ===============================================================================================================================

Func _GetType($gt_file)
	If $exit = 1 Then Return 0
	;If it is the first part of the archive
	If StringRegExp($gt_file, "(?i).*part.{0,4}(0{1,}1|1)\.((t|r)ar|zip)\b") Then Return 1
	;Archive part
	If StringRegExp($gt_file, "(?i).*(part.{0,2}\d{1,3}\.(t|r)ar|\.r\d\d)\b") Then Return 4
	;General archive
	If StringRegExp($gt_file, "(?i).*\.((t|r)ar|zip)\b") Then Return 1
	;If it failed all other checks, return 3 for general file
	Return 3
EndFunc   ;==>_GetType

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _Extract()
; Description ...: Extracts specified file
; Syntax ........: _Extract($ex_file, $fDir, $line_num)
; Parameters ....: $ex_file - File to be extracted
; ...............: $fDir - Directory working in
; ...............: $line_num - line number that called this function
; Return values .: Result of extraction
;				   |0 = Failure or Error
;				   |1 = Success
; Author ........: DoubleMcLovin
; Remarks .......: This function simply extracts the directed file into the done directory
; ===============================================================================================================================

Func _Extract($ex_file, $fDir, $line_num)
	If $exit = 1 Then Return 0
	FileWrite($mLog, $time & 'Extracting ' & $ex_file & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	;Checks to see if WinRar is installed
	If Not FileExists (@ProgramFilesDir & '\winrar\winrar.exe') Then
		MsgBox (0,'File Custodian - Critical Error!','Please install winrar into the default location. Program will now exit.')
		Exit
	EndIf
	;Path to install dir for winrar.
	Local $extract_code = RunWait('"' & @ProgramFilesDir & '\winrar\winrar.exe" x "' & @WorkingDir & '\' & $ex_file & '" "' & $fDir & '"')
	Switch $extract_code
	;extracted successfully
	Case 0
		FileWrite($cLog, $time & '# Extracted archive "' & @WorkingDir & '\' & $ex_file & '".' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		_RemoveTarget($ex_file, 1, @ScriptLineNumber, 'Successful extraction - deleting archive.')
		;Sets $target_tmp for later comparison to delete extracted archive parts
		Local $target_tmp = StringRegExpReplace($ex_file, "(?i)(part\d{1,}\.(rar|zip)|\.(\d{3}|(z|r)r\d{2}))\b", "")
		;if we have a zip or rar file check for parts and delete them too
		If StringRegExp($ex_file, "(?i).*\.(rar|zip)\b", 0) Then
			Local $rar_parts = FileFindFirstFile("*")
			While 1
				Local $rar_part = FileFindNextFile($rar_parts)
				;out of files
				If @error Then ExitLoop
				;Checks to see if each file matches the parts filter
				Switch StringRegExp($rar_part, "(?i).*(part\d{1,}\.rar|\.(\d{3}|r\d{2}))\b", 0)
					Case 1
						Local $rar_part_tmp = StringRegExpReplace($rar_part, "(?i)(part\d{1,}\.(rar|zip)|\.(\d{3}|(z|r)\d{2}))\b", "")
						If $rar_part_tmp = $target_tmp Then _RemoveTarget($rar_part, 1, @ScriptLineNumber, 'File is a part of an extracted archive.')
				EndSwitch
			WEnd
		EndIf
	Case 1
		FileWrite($dLog, $time & '! Failed to extract archive ' & @WorkingDir & '\' & $ex_file & '.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		Return 0
	Case Else
		FileWrite($dLog, $time & '@ Unknown result for extract of ' & @WorkingDir & '\' & $ex_file & '. Extract code = "' & $extract_code & '"' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		Return 0
	EndSwitch
	Return 1
EndFunc   ;==>_Extract

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _UnloadDir()
; Description ...: Pulls files out of a subdir and places them in current dir
; Syntax ........: _UnloadDir ($file, $line_num)
; Parameters ....: $file - subdir to unload
; ...............: $line_num - line number that called this func
; Return values .: Result of 'put'
;				   |0 = Failure or Error
;				   |1 = Success
; Author ........: DoubleMcLovin
; Remarks .......: Should never be called in watch dir
; ===============================================================================================================================

Func _UnloadDir($ud_dir, $line_num)
	If $exit = 1 Then Return 0
	;ignore subtitles directories
	If StringInStr($ud_dir, "sub") Then Return 1
	;Deletes sample dirs
	If StringInStr($ud_dir, "sample") Then
		_RemoveTarget($ud_dir, 2, @ScriptLineNumber, 'Sample dir.')
		;Takes all files/folders from dir and moves them to dir's root
		Return 1
	Else
		Local $ud_dir_root = @WorkingDir
		_ChangeDir ($ud_dir,@ScriptLineNumber)
		Local $subfiles = FileFindFirstFile('*')
		If @error Then
			_ChangeDir ($ud_dir_root,@ScriptLineNumber)
			_RemoveTarget($ud_dir, 2, @ScriptLineNumber, 'Empty dir.')
			Return 1
		ElseIf $subfiles = -1 Then
			_ChangeDir ($ud_dir_root,@ScriptLineNumber)
			FileWrite($dLog, $time & '! Error in search string. Working on "' & $ud_dir_root & '\' & $ud_dir & '".' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
			Return 0
		EndIf
		While 1
			Local $subfile = FileFindNextFile($subfiles)
			;No more files
			If @error Then ExitLoop
			;Dir check
			If @extended Then
				_MoveTarget(@WorkingDir & '\' & $subfile, $ud_dir_root & '\', 2, @ScriptLineNumber)
			;Season filter (goal is already formatted season folders)
			ElseIf StringRegExp($ud_dir, "(?i)Season\s\d{1,3}\b") Then
				_RenameTarget ($subfile,1,@ScriptLineNumber, $ud_dir_root)
			Else
				;This is where the file actually gets moved to the root
				_MoveTarget(@WorkingDir & '\' & $subfile, $ud_dir_root, 1, @ScriptLineNumber)
				FileWrite($mLog, $time & 'Moved "' & @WorkingDir & '\' & $subfile & '" to "' & $ud_dir_root & '\".' & $footer & 'o' & $line_num & ',' & 'i' & @ScriptLineNumber & @CRLF)
			EndIf
		WEnd
		_ChangeDir ($ud_dir_root,@ScriptLineNumber)
		FileClose($subfiles)
	EndIf
	Return 1
EndFunc   ;==>_UnloadDir

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GetCategory()
; Description ...: Determines category of folder for classification
; Syntax ........: _GetCategory ($file, $line_num, $gc_root)
; Parameters ....: $gc_file - Directory being reviewed
; ...............: $line_num - line number that called this function
; ...............: $gc_root - Directory started in
; Return values .: Result of categorization
;				   |0 = Failure or Error
;				   |1 = Success
; Return values .: $category
; Author ........: DoubleMcLovin
; Remarks .......: Values of $category are:
;				   | 0 - Exit
;				   | 1 - Movie
;				   | 2 - Game
;				   | 3 - Porn
;				   | 4 - OS
;				   | 5 - Other
;				   | 6 - Series
; ===============================================================================================================================

Func _GetCategory($gc_file, $line_num, $gc_root)
	If $exit = 1 Then Return 0
	FileWrite($mLog, $time & 'Getting category of ' & $gc_file & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	;Reset $category
	Local $category
	; The next three are done in this order because the Movie filter will pick up the Series and Porn
	If StringRegExp($gc_file, "(?i).*(season|s)\D{0,1}\d{1,2}.*", 0) Then ;Series filter
		FileWrite($mLog, $time & 'Found a series: ' & $gc_file & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		$category = 6
	ElseIf StringRegExp($gc_file, "(?i).*\.(xxx|p(or|r(o|0))n|ass|puss|tit|fuck).*", 0) Then ;Porn filter
		FileWrite($mLog, $time & 'Found some pr0n: ' & $gc_file & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		$category = 3
	ElseIf StringRegExp($gc_file, "(?i)(.+)\.(?:HDTV|repack|rerip|nuked|DC|proper|pdtv|dvdscr|extended|WS|hd|xvid|pdtv|ppv|eng|p|limited|unrated|(?:19|20)\d{2}|uncut|(?:dvd|bd|br|bluray)rip|r5|(?:720|1080|480)(?:p|i)|bluray)\.(?:.*)", 0) Then ;Movie filter
		FileWrite($mLog, $time & 'Found a movie: ' & $gc_file & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		$category = 1
		;general filter
	Else
		_ChangeDir ($gc_file,@ScriptLineNumber)
		$subfiles = FileFindFirstFile("*")
		;If the dir is empty
		If @error Then
			_ChangeDir ($gc_root,@ScriptLineNumber)
			_RemoveTarget($gc_file, 2, @ScriptLineNumber, 'Empty dir.')
			Return 1
		;error matcing
		ElseIf $subfiles = -1 Then
			FileWrite($dLog, $time & '@ Error, no files matched the search string.' & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
		Else
			While 1
				;Looks at subfiles to determine the category.
				$subfile = FileFindNextFile($subfiles)
				;Out of files
				If @error Then ExitLoop
				FileWrite($mLog, $time & 'Looking at ' & $subfile & $footer & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
				;iso check
				If StringRight($subfile, 3) = "iso" Then
					If FileGetSize($subfile) >= 5872025600 Then ;700MB+
						;Test for popular software brands. Looks at name of directory, not file.
						If StringRegExp($gc_file, "(?i).*(microsoft|windows|linux|ubuntu|x(86|64)|adobe|OS(X|.+X)).*", 0) Then
							$category = 4
						Else
							;size must be > 700MB, and not include major software names, must be .iso. Indicates game
							$category = 2
						EndIf
					EndIf
				EndIf
			WEnd
		EndIf
		FileClose($subfiles)
	EndIf
	;If all else fails, assign it to 'other'
	If $category = 0 Then $category = 5
	Switch $category
	Case 1
		$gc_dir = $movie_dir
	Case 2
		$gc_dir = $game_dir
	Case 3
		$gc_dir = $porn_dir
	Case 4
		$gc_dir = $os_dir
	Case 5
		$gc_dir = $other_dir
	Case 6
		$gc_dir = $series_dir
	EndSwitch
	;Ensures proper formatting for _MoveTarget by ensuring there is always a trailing backslash to $gc_dir and $gc_root
	While 1
		If StringRight($gc_dir, 1) = '\' Then
			$gc_dir = StringTrimRight($gc_dir, 1)
		ElseIf StringRight($gc_root, 1) = '\' Then
			$gc_root = StringTrimRight($gc_root, 1)
		Else
			ExitLoop
		EndIf
	WEnd
	$gc_dir = $gc_dir & "\"
	$gc_root = $gc_root & "\"
	FileWrite($mLog, $time & 'Set media dir to ' & $gc_dir & 'o' & $line_num & "," & 'i' & @ScriptLineNumber & @CRLF)
	Local $fail = _ChangeDir ($gc_root,@ScriptLineNumber)
	$fail = _MoveTarget($gc_root & $gc_file, $gc_dir & $gc_file, 2, @ScriptLineNumber)
	;If the _MoveTarget() function failed
	If $fail = 0 Then Return 0
	Return 1
EndFunc   ;==>_GetCategory