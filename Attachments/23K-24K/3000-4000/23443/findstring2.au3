;next line for testing code only
;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Add_Constants=n
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=FindStr.ico
#AutoIt3Wrapper_Outfile=C:\Program Files\AutoIt3\SciTE\findstr.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===============================================================================
;
; Script Name:   Findstr.au3
; Description::  Finds files or lines in files with a certain string
; Parameter(s):  EITHER fewer than 5, in which case a gui dialog is displayed to get the string to search for
;                   the file type or types, the path, include subfolder, give only file names or file names + line numbers
;                   and whether search should be case sensitive.
;                 OR the following 5 or 6 parameters
;           parameter 1:  /n or /N       for line numbers or anything else if no line numbers but just file names wanted
;                     2:  /s or /S       for sub folders to be searched, anything else if you do not want to search subfoilders
;                     3:  /i or /I       if search is not case sensitive (it is case Insensitive) otherwise anything else
;                     4:  sometext       the text to find. Enclose it in quotes if there are spaces included
;                     5: *.au3:*.txt     the file type to search in. Separate types with a semicolon
;                     6: Search Folder   The folder to start searching in.
;                        NB if this parameter is not given, but the other 5 are, then the current working directory is used.
; If fewer than 5 parameters are passed they will all be ignored and the gui dialog is used.
; Requirement(s):  findstr.exe in Windows\system32 folder
; Return Value(s): none
; Author(s):       martin
;Version          2.2  Date  8th December 2008
;History 2.1 - fixed '\\' in search path error. Improved text to output pane
;        2.2   fixed error not saving last search folder. Converted body of script into Main function.
;        2.3   turn regexp on or off
;        2.4   fix problem when files found not using RegExp but then not shown.
;              Redesigned gui
;        2.5   Correct error when search button clicked with empty fields
;        2.6   correct regexp for beginning of word and end of word ("\<" and "\>") matches
;===============================================================================

Global Const $version = "V2.6"
Global $debugging = True


Opt("mustdeclarevars", 1)

#include <File.au3>
#include <string.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <windowsconstants.au3>
#include <listviewconstants.au3>
#include <timers.au3>

Opt("TrayOnEventMode", 1)
Opt("TrayAutoPause", 0); Script will not be paused when clicking the tray icon.
Opt("TrayMenuMode", 1) ; Default tray menu items (Script Paused/Exit) will not be shown.

Global $MenuTrayQuit = TrayCreateItem("Exit (stop search)")
TrayItemSetOnEvent(-1, "QuitAll")

#Region Global Gui variables
Global $Form2, $Progress1 = 0, $Progress2 = 0
Global $RegHelpWind
#EndRegion Global Gui variables

Global $tf



Main()

Func Main()
	Local $tofind;the string to search for
	Local $FileTypes;the filetypes to search
	Local $SearchFolder;the folder to search in
	Local $subFolders;true if we should search subfolders
	Local $CaseSensitive;true if we care about the case
	Local $sCaseSensitive;case sensitive parameter used for windows findstr.exe
	Local $LineNumbers;true if we want line numbers
	Local $data
	Local $CaseFlag, $instr, $Text, $found
	Local $alltypes, $thistype, $foo, $filelines, $useRegExp = False
	Local $fields[6], $prefix, $ssflag

	If $debugging Then
		MsgBox(262144, "Commands", "raw = " & $cmdlineraw & @CR & _
				"working dir is" & $SearchFolder & @CR & _
				"Look for " & $tofind & @CR & _
				"File types = " & $FileTypes & @CR & _
				"Search subfolders = " & $subFolders & @CR & _
				"Case sensitive = " & $CaseSensitive)
	EndIf
	
	If $CmdLine[0] >= 5 Then; we have been run from SciTE? 	find.command=findstr /n /s /I $(find.what) $(find.files)
		$LineNumbers = $CmdLine[1] <> "/n"
		$subFolders = $CmdLine[2] = "/s"
		$CaseSensitive = $CmdLine[3] <> "/I"
		$tofind = $CmdLine[4]
		$FileTypes = $CmdLine[5]
		If $CmdLine[0] >= 6 Then
			$SearchFolder = $CmdLine[6]
		Else
			$SearchFolder = @WorkingDir
		EndIf
		
		
	EndIf

	While 1
		$fields = DataFromGui()
		If IsArray($fields) Then
			$tofind = $fields[0]
			$FileTypes = $fields[1]
			$SearchFolder = $fields[2]
			$CaseSensitive = $fields[3]
			$subFolders = $fields[4]
			$LineNumbers = $fields[5]
			$useRegExp = $fields[6]
			ExitLoop
		Else
			Exit
		EndIf
		
	WEnd

	If $subFolders Then
		$subFolders = "/s"
	Else
		$subFolders = ''
	EndIf

	If $Progress1 <> 0 Then
		GUICtrlSetState($Progress1, $GUI_SHOW)
		GUICtrlSetState($Progress2, $GUI_SHOW)
		AdlibEnable("setprogress", 80)
	EndIf



	$alltypes = StringSplit($FileTypes, ';')
	For $typenumber = 1 To $alltypes[0]
		
		$thistype = $alltypes[$typenumber]
		ConsoleWrite(">Findstr " & $version & "< Search files of type " & $thistype & " in " & $SearchFolder & ' for "' & $tofind & '"')
		
		#Region build command line
		$instr = 'findstr /m';only check for files containing the string to start with
		If $CaseSensitive Then
			$sCaseSensitive = ""
			ConsoleWrite(", Case sensitive" & $sCaseSensitive)
		Else
			$instr &= " /i"
			ConsoleWrite(", Not Case Sensitive")
		EndIf
		
		
		If $subFolders Then
			$instr &= ' /s'
			ConsoleWrite(", Search Subfolders")
		Else
			ConsoleWrite(", Subfolders Not searched")
		EndIf
		ConsoleWrite(@CRLF)
		If Not $useRegExp Then
			$instr &= ' /l'
		Else
			$instr &= ' /r';findstr doesn't seem to default to regexp if we use /m
		EndIf
		
		If StringRight($SearchFolder, 1) <> '\' Then $SearchFolder &= '\'
		
		$instr &= ' "' & $tofind & '" "' & $SearchFolder & $thistype & '" >' & '"' & @ScriptDir & '\findstrtmp.txt"'
		If $debugging Then MsgBox(262144, "instr = ", $instr)
		#EndRegion build command line
		
		;run command in systemdir so it will find windows findstr.exe first and not this script
		$foo = Run("cmd.exe", @SystemDir, @SW_HIDE, 9);$STDIN_CHILD + $STDOUT_CHILD
		StdinWrite($foo, $instr & @CRLF)
		; Calling with no 2nd arg closes stream
		StdinWrite($foo)

		; Read from child's STDOUT
		
		While True
			$data &= StdoutRead($foo)
			If @error Then ExitLoop
			Sleep(25)
		WEnd
		FileChangeDir(@ScriptDir)
		;read all the files which contain the string
		$Text = FileRead(@ScriptDir & "\findstrtmp.txt")
		If $Text = '' Then
			ConsoleWrite('-> no files found with "' & $tofind & '"' & @CRLF)
		Else
			;make sure all line ends are only @CR
			$Text = StringReplace($Text, @CRLF, @CR)
			$Text = StringReplace($Text, @LF, @CR)

			;make an array of the files
			$found = StringSplit($Text, @CR)
			If $LineNumbers Then
				For $files = 1 To $found[0]
					If $Progress2 <> 0 Then GUICtrlSetData($Progress2, $files * $typenumber * 100 / ($found[0] * $alltypes[0]) + ($typenumber - 1) * 100 / $alltypes[0])
					;in the same way split the file text into an array of lines
					$Text = FileRead($found[$files]);
					$Text = StringReplace($Text, @CRLF, @CR)
					$Text = StringReplace($Text, @LF, @CR)
					$filelines = StringSplit($Text, @CR)
					If $CaseSensitive Then
						$ssflag = 1
						$prefix = $tofind
					Else
						$ssflag = 1
						$prefix = '(?i)' & $tofind
						;if $debugging then ConsoleWrite("scan lines for " & $prefix & @CRLF)
					EndIf
					
					For $lines = 1 To $filelines[0]
						If $useRegExp Then
							$prefix = StringReplace($prefix,"\<","(\h|\A)")
							$prefix = StringReplace($prefix,"\>","(\h|\Z)")
							;ConsoleWrite("PREFIX CHANGED TO: " & $prefix & @CRLF)
							If StringRegExp($filelines[$lines], $prefix) Then;, $CaseFlag
								
								ConsoleWrite($found[$files] & ":" & $lines & ":" & $filelines[$lines] & @CR)
							EndIf
						Else
							If StringInStr($filelines[$lines], $tofind, $ssflag) Then;, $CaseFlag
								ConsoleWrite($found[$files] & ":" & $lines & ":" & $filelines[$lines] & @CR)
							EndIf
						EndIf
						
						
					Next
					
				Next
			Else
				For $lines = 1 To $found[0]
					If $Progress2 <> 0 Then GUICtrlSetData($Progress2, $lines * 100 / $found[0])
					ConsoleWrite($found[$lines] & @CR)
				Next
			EndIf
		EndIf
	Next
	If $debugging = False Then FileDelete(@ScriptDir & "findstrtmp.txt");remove temp file
	UpdateLast($tofind, $FileTypes, $SearchFolder)
EndFunc   ;==>Main

Func setprogress()
	If $Progress1 <> 0 Then GUICtrlSetData($Progress1, GUICtrlRead($Progress1) + 5)
EndFunc   ;==>setprogress


;===============================================================================
;
; Function Name:   DataFromGui
; Description::    Gui dialog to get search parameters
; Parameter(s):   none
;Return;         An array with the following elements
;                 1         the string to find
;                 2      the file types to search as a semicolon-separated list
;                 3      the folder to search
;                 4  true if the search should be case sensitive, otherwise false
;                 5    true if the search should include subfolders, otherwise false
;                 6    true if the results displayed should give all line numbers if file,
;                                          false if only the file names are to be shown
;                 7   true if RegExpression is used for the string to find
; Author(s):      martin
;
;===============================================================================
;

Func DataFromGui()
	
	Local $LblSeparation;, $Label2, $Label3
	Local $CmboFiles, $CmboFolders, $CmboString
	Local $ChkCase, $ChkSubFolders, $ChkRegExp, $ChkHelp
	Local $BtnSearch, $BtnCancel, $BtnBrowse
	Local $GrpFolder, $GrpFiles, $GrpString
	Local $RadioNoLines, $RadioWithLines
	Local $nMsg, $temp
	Local $IniFile = @ScriptDir & "\findinfiles.ini"
	Local $LastFiles = IniRead($IniFile, "Files", "lasttypes", "")
	Local $LastStrings = IniRead($IniFile, "Strings", "laststrings", "")
	Local $LastFolders = IniRead($IniFile, "Folders", "lastfolders", "")
	Local $result[7]
	#Region ### START Koda GUI section ### Form=G:\mgspecials\FindStr\FormFindStr.kxf
	$Form2 = GUICreate("Find in Files", 391, 342, 196, 125)
	GUISetFont(10, 400, 0, "MS Sans Serif")
	$BtnSearch = GUICtrlCreateButton("&Search", 47, 295, 75, 40, 0)
	$GrpFolder = GUICtrlCreateGroup("Folder to search", 24, 210, 336, 77)
	$ChkSubFolders = GUICtrlCreateCheckbox("Include &Subfolders", 32, 232, 129, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$BtnBrowse = GUICtrlCreateButton("&Browse", 295, 225, 57, 23, 0)
	$CmboFolders = GUICtrlCreateCombo("", 27, 254, 328, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Progress1 = GUICtrlCreateProgress(4, 10, 14, 306, BitOR($PBS_VERTICAL, $PBS_MARQUEE))
	GUICtrlSetState(-1, $GUI_HIDE)
	$Progress2 = GUICtrlCreateProgress(367, 10, 14, 301, $PBS_VERTICAL)
	GUICtrlSetState(-1, $GUI_HIDE)
	$GrpString = GUICtrlCreateGroup("String to find", 24, 3, 336, 97)
	$CmboString = GUICtrlCreateCombo("", 27, 22, 328, 25)
	$ChkCase = GUICtrlCreateCheckbox("Case &Dependant", 37, 52, 132, 17)
	$ChkRegExp = GUICtrlCreateCheckbox("Use &RegExpression", 177, 53, 147, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$ChkHelp = GUICtrlCreateCheckbox("Show RegExp. &Help", 177, 75, 169, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$GrpFiles = GUICtrlCreateGroup("Files to search", 24, 108, 336, 95)
	$LblSeparation = GUICtrlCreateLabel(" Separate types with ';' (semicolon)", 34, 128, 225, 17)
	$CmboFiles = GUICtrlCreateCombo("", 27, 147, 328, 25)
	$RadioNoLines = GUICtrlCreateRadio("File &Names Only", 40, 177, 121, 17)
	$RadioWithLines = GUICtrlCreateRadio("File Names + &Line numbers", 169, 177, 183, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$BtnCancel = GUICtrlCreateButton("&Cancel", 243, 295, 75, 40, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	
	
	GUICtrlSetData($CmboFiles, $LastFiles)
	GUICtrlSetData($CmboString, $LastStrings)
	GUICtrlSetData($CmboFolders, $LastFolders)

	
	
	
	$RegHelpWind = ShowRegHelp()
	SetRegHelp();set the help window in correct place. After this it's kept there by next line
	GUIRegisterMsg($WM_MOVE, "SetRegHelp")

	;set focus on string combobox
	ControlFocus($Form2, "", $CmboString)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $BtnCancel
				Exit
			Case $BtnSearch
				$result[0] = GUICtrlRead($CmboString)
				$result[1] = GUICtrlRead($CmboFiles)
				$result[2] = GUICtrlRead($CmboFolders)
				If $result[0] = '' Or $result[1] = '' Or $result[2] = '' Then
					$tf = _Timer_SetTimer($Form2, 80, "MoveErrorWIndow")
					GUISetState(@SW_DISABLE, $Form2)
					MsgBox(262144 + 48, "SEARCH ERROR", "You must give values for" & @CR & _
							" - the String to find" & @CR & _
							" - the File Types to search" & @CR & _
							" - the Folder to search.")
					_Timer_KillTimer($Form2, $tf)
					GUISetState(@SW_ENABLE,$Form2)
					WinActivate($Form2)
				Else
					ExitLoop
				EndIf
				
			Case $BtnBrowse
				$temp = FileSelectFolder("folder to search", "", 6, @ScriptDir)
				If $temp <> '' Then GUICtrlSetData($CmboFolders, $temp, $temp)
			Case $ChkHelp
				If BitAND(GUICtrlRead($ChkHelp), $GUI_CHECKED) Then
					GUISetState(@SW_SHOW, $RegHelpWind)
					WinActivate($Form2)
				Else
					GUISetState(@SW_HIDE, $RegHelpWind)
				EndIf
				
		EndSwitch
		
		;this seemed easier than using WM_SETFOCUS
		;stops help being shown while search gui is hidden
		If WinActive($RegHelpWind) Then
			WinActivate($Form2)
		EndIf
		
		
	WEnd
	
	$result[3] = BitAND(GUICtrlRead($ChkCase), $GUI_CHECKED) = $GUI_CHECKED
	$result[4] = BitAND(GUICtrlRead($ChkSubFolders), $GUI_CHECKED) = $GUI_CHECKED
	$result[5] = BitAND(GUICtrlRead($RadioWithLines), $GUI_CHECKED) = $GUI_CHECKED
	$result[6] = BitAND(GUICtrlRead($ChkRegExp), $GUI_CHECKED) = $GUI_CHECKED
	GUISetState(@SW_HIDE, $RegHelpWind)
	GUICtrlSetState($ChkHelp, $GUI_UNCHECKED)
	Return $result
EndFunc   ;==>DataFromGui



;===============================================================================
;
; Function Name:   UpdateLast
; Description::   Updates the ini file with the last used search parameters
; Parameter(s):    $UDtofind        the string last searched for
;                  $UDFileTypes     the files types last searched
;                  $UDSearchFolder  the folder last search
; Requirement(s):  none
; Return Value(s): none
;
;===============================================================================
;

Func UpdateLast($UDtofind, $UDFileTypes, $UDSearchFolder)
	Local $IniFile = @ScriptDir & "\findinfiles.ini"
	Local $LastFiles = IniRead($IniFile, "Files", "lasttypes", "")
	Local $LastStrings = IniRead($IniFile, "Strings", "laststrings", "")
	Local $LastFolders = IniRead($IniFile, "Folders", "lastfolders", "")
	;save strings searched for
	If Not StringInStr('|' & $LastStrings, '|' & $UDtofind & '|') Then
		$LastStrings = $UDtofind & '|' & $LastStrings
	EndIf
	While StringInStr($LastStrings, '|', 0, 10)
		$LastStrings = StringLeft($LastStrings, StringInStr($LastStrings, '|', 0, -1) - 1)
	WEnd
	IniWrite($IniFile, "Strings", "laststrings", $LastStrings)
	
	;save folders searched
	If Not StringInStr('|' & $LastFolders, '|' & $UDSearchFolder & '|') Then
		$LastFolders = $UDSearchFolder & '|' & $LastFolders
	EndIf
	While StringInStr($LastFolders, '|', 0, 10)
		$LastFolders = StringLeft($LastFolders, StringInStr($LastFolders, '|', 0, -1) - 1)
	WEnd
	IniWrite($IniFile, "Folders", "lastfolders", $LastFolders)
	
	;save filetypes
	If Not StringInStr('|' & $LastFiles, '|' & $UDFileTypes & '|') Then
		$LastFiles = $UDFileTypes & '|' & $LastFiles
	EndIf
	While StringInStr($LastFiles, '|', 0, 10)
		$LastFiles = StringLeft($LastFiles, StringInStr($LastFiles, '|', 0, -1) - 1)
	WEnd
	IniWrite($IniFile, "Files", "lasttypes", $LastFiles)
	
EndFunc   ;==>UpdateLast

Func QuitAll()
	Exit
EndFunc   ;==>QuitAll

;===============================================================================
;
; Function Name:   OnAutoItExit
; Description::    clean exit
; Parameter(s):    none
; Requirement(s):  none
; Return Value(s): none
; Author(s):       Jos
;
;===============================================================================
Func OnAutoItExit()
	Local $aP, $i
	ProgressOff()
	If @exitMethod Then
		ConsoleWrite(@CRLF & "! search cancelled." & @CRLF)
		$aP = ProcessList("findstr.exe")
		; Kill all FindStr.exe that are not this programs PID
		For $i = 1 To $aP[0][0]
			If $aP[$i][1] <> @AutoItPID Then ProcessClose($aP[$i][1])
		Next
	EndIf
	FileDelete(@ScriptDir & "findstrtmp.txt");remove temp file
EndFunc   ;==>OnAutoItExit

;===============================================================================
;
; Function Name:
; Description::
; Parameter(s):
; Requirement(s):
; Return Value(s): the window handle for the gui used to display the help
; Author(s):
;
;===============================================================================
;

Func ShowRegHelp()
	Local $Form1
	Local $ListView1, $Button1
	#Region ### START Koda GUI section ### Form=G:\mgspecials\FindStr\FindstrRegHelp.kxf
	$Form1 = GUICreate("Form1", 397, 181, 297, 484, $WS_POPUP)
	$ListView1 = GUICtrlCreateListView("Character|Action", 0, 0, 395, 178)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 70)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 320)
	#EndRegion ### END Koda GUI section ###
	Local $nMsg
	Local $ListView1_0 = GUICtrlCreateListViewItem(".|Wildcard: any character", $ListView1)
	Local $ListView1_1 = GUICtrlCreateListViewItem("*|Repeat: zero or more of previous character or class", $ListView1)
	Local $ListView1_2 = GUICtrlCreateListViewItem("^|Line position: beginning of line", $ListView1)
	Local $ListView1_3 = GUICtrlCreateListViewItem("$|ine position: end of line", $ListView1)
	Local $ListView1_4 = GUICtrlCreateListViewItem("[class]|Character class: any one character in set", $ListView1)
	Local $ListView1_5 = GUICtrlCreateListViewItem("[^class]|Inverse class: any one character not in set", $ListView1)
	Local $ListView1_6 = GUICtrlCreateListViewItem("[x-y] |Range: any characters within the specified range", $ListView1)
	Local $ListView1_7 = GUICtrlCreateListViewItem("\x|Escape: literal use of metacharacter x", $ListView1)
	Local $ListView1_8 = GUICtrlCreateListViewItem("\<xyz|Word position: beginning of word", $ListView1)
	Local $ListView1_9 = GUICtrlCreateListViewItem("xyz\>|Word position: end of word", $ListView1)
	Local $ListView1_10 = GUICtrlCreateListViewItem("", $ListView1)
	Return $Form1
EndFunc   ;==>ShowRegHelp

Func SetRegHelp()
	Local $rp = WinGetPos("Find in Files")
	WinMove($RegHelpWind, "", $rp[0] + $rp[2], $rp[1] + 30)
	
EndFunc   ;==>SetRegHelp

Func MoveErrorWIndow($hW, $a, $b, $c)
	Local $mp, $fpos
	If Not WinExists("SEARCH ERROR") Then
		Return
	EndIf

	$fpos = WinGetPos("SEARCH ERROR")
	$mp = WinGetPos($Form2)
	WinMove("SEARCH ERROR", "", $mp[0] + 100, $mp[1] + 200)
	;WinActivate("SEARCH ERROR")
	;_Timer_KillTimer($Form2, $tf)
	
EndFunc   ;==>MoveErrorWIndow