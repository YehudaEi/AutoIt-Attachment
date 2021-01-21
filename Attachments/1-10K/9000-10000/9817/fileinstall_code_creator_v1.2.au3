Opt("TrayIconDebug", 1)         ;0=no info, 1=debug line info
Opt("TrayIconHide", 0)          ;0=show, 1=hide tray icon
Opt("MustDeclareVars", 1)       ;0=no, 1=require pre-declare

Global $PROGRAM_NAME = "Multiple FileInstall() creator"

CREATE_LIST()

Func CREATE_LIST()
	
	Local $SOURCE_FOLDER = ""
	Local $DESTINATION_FOLDER = ""
	Local $SUB
	Local $FLAG
	Local $SOURCE_LOCATION = ""
	Local $DESTINATION_LOCATION = ""
	Local $CODE = ""
	Local $CODE_FILENAME = _SWWUniqueFilename(@TempDir, ".txt")
	
	;--- Source Folder -------------------------------------------------------------------------------------------
	
	;Prompt for the source directory
	$SOURCE_FOLDER = FileSelectFolder("Please select your source directory", "")
	
	;Exit if FileSelectFolder is cancelled
	If $SOURCE_FOLDER = "" Then	Exit
	
	;If the source folder doesn't have a trailing "\" then add a "\"
	If StringRight($SOURCE_FOLDER, 1) <> "\" Then $SOURCE_FOLDER = $SOURCE_FOLDER & "\"
	;-------------------------------------------------------------------------------------------------------------

	;--- Destination Folder --------------------------------------------------------------------------------------
	
	;Prompt for the destination directory
	$DESTINATION_FOLDER = InputBox($PROGRAM_NAME, "Please complete the destination path (e.g. C:\temp\new_location)")
	
	;Exit if the above InputBox is cancelled or left blank
	If $DESTINATION_FOLDER = "" Then Exit

	;If the destination folder doesn't have a trailing "\" then add a "\"
	If StringRight($DESTINATION_FOLDER, 1) <> "\" Then $DESTINATION_FOLDER = $DESTINATION_FOLDER & "\"
	;-------------------------------------------------------------------------------------------------------------

	;--- Set the value of $SUB so that it can be used as a switch in the dir command -----------------------------
	
	If MsgBox(262144+32+4, $PROGRAM_NAME, "Would you like all sub-directories to be included?") = 6 Then
		$SUB = " /s"
	Else
		$SUB = ""
	EndIf
	;-------------------------------------------------------------------------------------------------------------
	
	;--- Set the value of $FLAG that is used in the FileInstall code ---------------------------------------------
	
	If MsgBox(262144+32+4, $PROGRAM_NAME, "In the FileInstall code, do you want the 'overwrite existing files' flag on?") = 6 Then
		$FLAG = 1
	Else
		$FLAG = 0
	EndIf
	;-------------------------------------------------------------------------------------------------------------
	
	;Get a file structure report and pipe it to a temporary file
	RunWait(@ComSpec & ' /c dir "' & $SOURCE_FOLDER & '" /b' & $SUB & " > " & @TempDir & "\dirdump.txt", "", @SW_HIDE)
	
	Local $X = 0
	
	While 1
		
		$X = $X + 1
		$SOURCE_LOCATION = FileReadLine(@TempDir & "\dirdump.txt", $X)
		If @error <> 0 Then ExitLoop
			
		;When the dir command is run without the subdirectory (/s) switch, the full path isn't outputed, therefore:
		If $SUB <> " /s" Then $SOURCE_LOCATION = $SOURCE_FOLDER & $SOURCE_LOCATION
		
		;If the path entry is a directory then:
		If StringInStr(FileGetAttrib($SOURCE_LOCATION), "D") > 0 Then
			ContinueLoop
		Else
			
			$DESTINATION_LOCATION = $DESTINATION_FOLDER & StringReplace($SOURCE_LOCATION, $SOURCE_FOLDER, "")
				
			$CODE = $CODE & 'FileInstall("' & $SOURCE_LOCATION & '", "' & $DESTINATION_LOCATION & '", ' & $FLAG & ")" & @CRLF
			
		EndIf
	
	WEnd

	FileDelete(@TempDir & "\dirdump.txt")
	
	FileWrite(@TempDir & "\" & $CODE_FILENAME, $CODE)

	Run("C:\WINDOWS\system32\notepad.exe " & @TempDir & "\" & $CODE_FILENAME)
	
EndFunc

Func _SWWUniqueFilename($LOCATION, $EXTENSION)
	
	Local $UNIQUE_FILENAME
	
	;Ensure that there is a trailing "\" on the end of the path
	If StringRight($LOCATION, 1) <> "\" Then $LOCATION = $LOCATION & "\"
	
	;Ensure that there is a leading "." at the start of the extension
	If StringLeft($EXTENSION, 1) <> "." Then $EXTENSION = "." & $EXTENSION
	
	;If the extension isn't valid return @error 1
	If StringLen($EXTENSION) <> 4 Then
		SetError(1)
		Return
	EndIf
		
	While 1
		;Create a filename using a random number between 10000000 and 99999999
		$UNIQUE_FILENAME = Random(10000000, 99999999, 1) & $EXTENSION
		
		;If the random filename isn't unique, the loop again, otherwise, exit the loop
		If FileExists($LOCATION & $UNIQUE_FILENAME) = 1 Then
			ContinueLoop
		Else
			Return $UNIQUE_FILENAME
		EndIf
		
	WEnd

EndFunc