#include <File.au3>
#Include <GuiStatusBar.au3>
#include <GuiConstants.au3>
Opt("TrayOnEventMode",0)
Opt("GuiOnEventMode",1)
Opt("WinTitleMatchMode",2)
Dim $StatusBar,$Top,$Left,$FileIn,$FileOut,$InputVal_1,$InputVal_2,$InputVal_3,$InputVal_4,$ChkHeader,$Input_1,$Input_2,$Input_3,$Input_4,$Button,$Button1,$Button2,$Button_Browse1,$Button_Browse2,$Button_Cancel,$Button_Valid
Dim $GuiWidth, $GuiHeigh,$Replace,$find,$szDrive, $szDir, $szFName, $szExt, $Retval,$Counter,$Start,$SourceFileCopy,$DestFileCopy,$CountedLines,$FileOutCounter,$ProgBar,$ProgBarMin,$ProgBarMax,$Checked,$Pattern
Dim $HelpBrowse1, $HelpBrowse2, $HelpSearch, $HelpReplace,$HelpHeader, $HelpMsg,$Array,$Occurance,$ResVal,$PatternsNum
Local $StatusBarSize[3] = [90, 340, -1]
Local $StatusBarText[3] = ["Working...", "Reading line : ", "Writing Line :"]
$Title="String Replacer"
if _Singleton(@ScriptName,1) = 0 Then ; Call the test function which check if an other occurence of this program is already running
	MsgBox(48,$Title & " - WARNING !!!", "Application " & @ScriptName & " is already running... !",5); If Yes error message is returned and Exit
	Exit
EndIf
call ("MainGui")
;Main Loop 
;--------------
While 1
WEnd
;--------------

;---------FUNCTIONS BLOCK START----------------------------------------------
Func MainGui ()
	$Left=30
	$Top=10
	$Heigh = 20 
	$HeighValidBut = 30
	$Width = 380
	$WithBrowseBut = 50
	$WithValidBut = 90
	$GuiWidth = 550
	$GuiHeigh = 300
	$MainGui=GuiCreate("String Replacer", $GuiWidth, $GuiHeigh,-1, -1 ) ;BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	GUISetOnEvent($GUI_EVENT_CLOSE,"DelGui")
	$StatusBar=_GUICtrlStatusBarCreate($MainGui,$StatusBarSize,$StatusBarText)
	_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", 21)
	_GUICtrlStatusBarSetSimple($StatusBar)
	_GUICtrlStatusBarSetText ($StatusBar, "Ready", 255)
	$Label_1 = GuiCtrlCreateLabel("File to explore :", $Left,$Top, $Width, $Heigh)
	$Top=$Top+15
	$Input_1 = GuiCtrlCreateInput($InputVal_1, $Left, $Top, $Width, $Heigh)
	$Button_Browse1 = GuiCtrlCreateButton("Browse", $Left+$Width+$Heigh, $Top, $WithBrowseBut, $Heigh)
	$Button1=GUICtrlGetHandle( $Button_Browse1 )
	GUICtrlSetOnEvent(-1,"Browse")
	$HelpBrowse1 = GUICtrlCreateButton ("?",$GuiWidth-60,$Top,20,$Heigh)
	GUICtrlSetOnEvent(-1,"DisplayHelp")
	$Top=$Top+30
	$Label_2 = GuiCtrlCreateLabel("Destination file :", $Left, $Top, $Width, $Heigh)
	$Top=$Top+15
	$Input_2 = GuiCtrlCreateInput($InputVal_2, $Left, $Top, $Width, $Heigh)
	GUICtrlSetOnEvent(-1,"Input2Event")
	$Button_Browse2 = GuiCtrlCreateButton("Browse", $Left+$Width+$Heigh, $Top, $WithBrowseBut, $Heigh)
	$Button2=GUICtrlGetHandle( $Button_Browse2 )
	GUICtrlSetOnEvent(-1,"Browse")
	$HelpBrowse2 = GUICtrlCreateButton ("?",$GuiWidth-60,$Top,20,$Heigh)
	GUICtrlSetOnEvent(-1,"DisplayHelp")
	$Top=$Top+30
	$Label_3 = GuiCtrlCreateLabel("Search :", $Left, $Top, $Width-340, $Heigh)
	$Input_3 = GuiCtrlCreateInput($InputVal_3, $Left+($Width-310), $Top, $Width-360, $Heigh)
	$HelpSearch = GUICtrlCreateButton ("?",$Left+($Width-280),$Top,20,$Heigh)
	GUICtrlSetOnEvent(-1,"DisplayHelp")
	$Top=$Top+25
	$Label_4 = GuiCtrlCreateLabel("Replace by :", $Left, $Top, $Width-310,$Heigh)
	$Input_4 = GuiCtrlCreateInput($InputVal_4, $Left+($Width-310), $Top, $Width-360, $Heigh)
	$HelpReplace = GUICtrlCreateButton ("?",$Left+($Width-280),$Top,20,$Heigh)
	GUICtrlSetOnEvent(-1,"DisplayHelp")
	$Top=$Top+25
	$ChkHeader = GUICtrlCreateCheckbox("Include header line",$Left,$Top,)
	$HelpHeader = GUICtrlCreateButton ("?",$Left+($Width-260),$Top,20,$Heigh)
	GUICtrlSetOnEvent(-1,"DisplayHelp")
	GUICtrlSetState($ChkHeader,$GUI_HIDE)
	GUICtrlSetState($HelpHeader,$GUI_HIDE)
	$Button_Valid = GuiCtrlCreateButton("Validate",($GuiWidth/2)-105, $GuiHeigh-80, $WithValidBut, $HeighValidBut)
	GUICtrlSetOnEvent(-1,"ReplaceString")
	$Button_Cancel = GuiCtrlCreateButton("Quit", ($GuiWidth/2)-105+$WithValidBut+$Heigh, $GuiHeigh-80, $WithValidBut, $HeighValidBut)
	GUICtrlSetOnEvent(-1,"DelGui")
	GuiSetState()
EndFunc

Func DelGui () ; called by any GUI on exit
	GUIDelete(@GUI_WinHandle)
	Exit
EndFunc

Func TEST ()
	MsgBox ("Test","This is a test !","",2)
	GUIDelete(@GUI_WinHandle)
	Exit
EndFunc

Func Input2Event()
	$FileOut = GUICtrlRead($Input_2)
	If $fileOut <> "" Then 
		GUICtrlSetState($ChkHeader,$GUI_SHOW)
		GUICtrlSetState($HelpHeader,$GUI_SHOW)
	Else
		GUICtrlSetState($ChkHeader,$GUI_HIDE)
		GUICtrlSetState($HelpHeader,$GUI_HIDE)
	EndIf
EndFunc

Func Browse() ;Start - Gui Prefered Folders Menu Functions (Called each time a "Browse" button is clicked)
$Button = @GUI_CtrlHandle ; Gets the Handle of the last clicked button

	If $Button = $Button1 Then 
		$Flag = 3
		$var = FileOpenDialog ( "Choose a CSV file...", "C:\$user\web\sources\Warranty Owner\BOP\TNA", "CSV files (*.csv)" ,$Flag)
		GUICtrlSetData ( $Input_1, $var) ; Fill Input zone with complete path selected in the above Window
		$FileIn = GUICtrlRead($Input_1)
	EndIf
	If $Button = $Button2 Then 
		$Flag = 10
		$var = FileOpenDialog ( "Choose a CSV file...", "C:\$user\web\sources\Warranty Owner\BOP\TNA", "CSV files (*.csv)" ,$Flag)
		GUICtrlSetData ( $Input_2, $var)
		$FileOut = GUICtrlRead($Input_2)
		If $fileOut <> "" Then 
			GUICtrlSetState($ChkHeader,$GUI_SHOW)
			GUICtrlSetState($HelpHeader,$GUI_SHOW)
		Else
			GUICtrlSetState($ChkHeader,$GUI_HIDE)
			GUICtrlSetState($HelpHeader,$GUI_HIDE)
		EndIf
	EndIf
$FileOutCounter = _FileCountLines($var) ; Count the original lines in the destination file
EndFunc

Func ReplaceString()
; Read Gui controls and loads result in variables
$FileIn = GUICtrlRead($Input_1)
If $fileIn = "" Then
	MsgBox(32,$title & " - Error","You should, at least, provide a source file to handle...")
	ControlFocus ($title, "", $Input_1 )
	Return
EndIf
$FileOut = GUICtrlRead($Input_2)
$find = GUICtrlRead($Input_3)
$Replace = GUICtrlRead($Input_4)
$Checked = GuiCtrlRead($ChkHeader)
;-------------------------------------------------
$SourceFileCopy=_PathSplit($fileIn,$szDrive, $szDir, $szFName, $szExt); Split the source file path
;----- Check if Backup dir exists, delete contents if capacity is above 5Mb and puts a copy of the source file in it.
If FileExists ( $SourceFileCopy[1]&"\"&$SourceFileCopy[2]&"\"&"Backup\" ) = 1 Then ; Check if Backup directory exist
	$DirSize = DirGetSize($SourceFileCopy[1]&"\"&$SourceFileCopy[2]&"\"&"Backup",1) ; If existing, get it's size in Megabytes
	If Round($DirSize[0]/1024/1024,2) > 5 Then ; Test if Directory size is above 5 Mb
			FileDelete($SourceFileCopy[1]&"\"&$SourceFileCopy[2]&"\"&"Backup\*.*") ; If yes then delete contents
		EndIf
EndIf
FileCopy($FileIn,$SourceFileCopy[1]&"\"&$SourceFileCopy[2]&"\"&"Backup\"&$SourceFileCopy[3]&"_"&@MDAY&@MON&@YEAR&"_"&@HOUR&@MIN&@SEC&$SourceFileCopy[4],8);Make a security copy of the source file to work on

If $FileOut = "" Then
	_GUICtrlStatusBarSetSimple($StatusBar, False)
	_GUICtrlStatusBarSetText ($StatusBar, "Working...", 0)
	_GUICtrlStatusBarSetText ($StatusBar, "Checking if Pattern [" & $Replace & "] already exists. Please wait...", 1)
	_GUICtrlStatusBarSetText ($StatusBar, "", 2)
	Call ("Verify",$Replace) ; Check if $Replace pattern already exists
	If $Occurance > 0 Then ; If yes send a message and exit if pattern found
		_GUICtrlStatusBarSetSimple($StatusBar, True)
		_GUICtrlStatusBarSetText ($StatusBar, "Pattern [" & $Replace & "] already exists (" & $Occurance & " occurences found). Please correct and try again.", 255)
	Else ; Else if no "error" found... Do string replacement
		_GUICtrlStatusBarSetSimple($StatusBar, False)
		_GUICtrlStatusBarSetText ($StatusBar, "Working...", 0)
		_GUICtrlStatusBarSetText ($StatusBar, "Replacing process is on progress. Please wait...", 1)
		_GUICtrlStatusBarSetText ($StatusBar, "", 2)
		_ReplaceStringInFile($FileIn,$find,$Replace)
		Call ("Verify",$Replace) ; Count the number of replaced strings
		Call ("CountPatterns",$Replace) ; Count the number of replaced strings
		_GUICtrlStatusBarSetText ($StatusBar, "Done !", 0)
		_GUICtrlStatusBarSetText ($StatusBar, $Occurance & " occurence(s) found for pattern [" & $find & "]", 1)
		_GUICtrlStatusBarSetText ($StatusBar, "replaced by " & $Occurance  & " [" & $Replace & "] pattern", 2)
	EndIf	
Else
	$DestFileCopy=_PathSplit($FileOut,$szDrive, $szDir, $szFName, $szExt); Split the Destination file path
	If FileExists($FileOut) Then ; Make a security copy of the destination file (if existing)
		FileCopy($FileOut,$DestFileCopy[1]&"\"&$DestFileCopy[2]&"\"&"Backup\"&$DestFileCopy[3]&"_"&@MDAY&@MON&@YEAR&"_"&@HOUR&@MIN&@SEC&$DestFileCopy[4],8)
	EndIf
	_ReplaceStringInFile($FileIn,$find,$Replace); Do string replacement in original file
	Call ("VerifyEOF",$FileOut) ; Add @CRLF at EOF if necessary
	Call ("AppendFile")
EndIf
EndFunc

Func AppendFile()
	_GUICtrlStatusBarSetSimple($StatusBar, False)
	If FileExists($FileOut) Then ; Test if file exists and if yes...
		If $Checked=$GUI_CHECKED Then ; Read CheckBox state
			$Start= 1 ; header must be copied
		Else
			$Start= 2 ; header will not be copied
		EndIf
		$Counter=_FileCountLines($FileIn) ; Count line to be copyied from souce file
		$FileOutCounter = _FileCountLines($FileOut) ; Count the original lines in the destination file
	
		Select ; Initialize counted lines depending of the $Start Value
			Case $Start=1
				$CountedLines = $Counter 
			Case $Start=2
				$CountedLines = $Counter-1
		EndSelect
		$ProgBar = GUICtrlCreateProgress (2,$GuiHeigh-30,$GuiWidth-2,5,$PBS_SMOOTH)
		For $i = $Start To $Counter; $Counter
			$Retval=FileReadLine($FileIn,$i) ; Read source file lines
			_GUICtrlStatusBarSetText ($StatusBar, $StatusBarText[0], 0)
			_GUICtrlStatusBarSetText ($StatusBar, $StatusBarText[1] & $i & " of " & $CountedLines, 1)
			FileWriteLine($FileOut,$Retval) ; Write record to destination file
			_GUICtrlStatusBarSetText ($StatusBar, $StatusBarText[2] & $i & " of " & $CountedLines, 2)
			If $Counter > 0 Then GUICtrlSetData ($ProgBar,($i*100)/$Counter) ; Increment Progress value...
		Next
		GUICtrlSetState($ProgBar,$GUI_HIDE)
		
		$Counter=_FileCountLines($FileOut) ; Count lines in destination file (including new ones)
		_GUICtrlStatusBarSetText ($StatusBar, "Done !", 0)
		_GUICtrlStatusBarSetText ($StatusBar, "Original lines Qty in destination file : " & $FileOutCounter, 1)
		_GUICtrlStatusBarSetText ($StatusBar, "Actual lines Qty : " & $Counter, 2)
		_ReplaceStringInFile($FileIn,$Replace,$find); Put back orgininal delimiters in source file
	Else ; If file do not exist a simple copy is done
		_GUICtrlStatusBarSetText ($StatusBar, "Working...", 0)
		_GUICtrlStatusBarSetText ($StatusBar, "File is being created...", 1)
		_GUICtrlStatusBarSetText ($StatusBar, "", 2)
		FileCopy($FileIn,$FileOut,8)
		_GUICtrlStatusBarSetText ($StatusBar, "Done !", 0)
		_GUICtrlStatusBarSetText ($StatusBar, "Process successfully terminated.", 1)
		_GUICtrlStatusBarSetText ($StatusBar, "New file has been created", 2)
	EndIf	
EndFunc

Func CountPatterns($Pattern) ;----- Counts all new replaced patterns in the file
	_FileReadToArray($FileIn,$Array) ; Read the file and put the result in variable
	$Occurance = 1
	Do	; Loop until last $Replace occurance is found
		$Retval=StringInStr($Array[1],$Pattern,0,$Occurance)
		If $Retval = 0 then
			$Occurance=$Occurance-1
			ExitLoop
		EndIf
		$Occurance=$Occurance+1
	Until $Retval=0
	If String($Array[0])="" Then	; Check if last line is empty (contains @lf or @CRLF, etc...)
		$Occurance = ($Array[0]-1)*$Occurance	; If yes substract one to the number of lines found and multiply by the number of occurances
												;$Array[0] is adjusted to avoid including the last line of the file when it's a @LF pattern.
	Else
		$Occurance = ($Array[0])*$Occurance
	EndIf
Return $Occurance
EndFunc

Func Verify($Pattern) ;----- Counts all possible "$Replace" patterns in the file
	$Occurance = 1
	$ProgBarMin=0
	$ProgBarMax = 200
	$ProgBar = GUICtrlCreateProgress (2,$GuiHeigh-30,$GuiWidth-2,5,$PBS_SMOOTH)
	;_FileReadToArray($FileIn,$Array) ; Read the file and put the result in variable
	$ResVal= FileRead($FileIn,FileGetSize($FileIn))
		Do	
		$Retval=StringInStr($ResVal,$Pattern,0,$Occurance)
		If $Retval = 0 then ; This is the end of the line... nor more occurance found
			$Occurance = $Occurance-1
			ExitLoop ; and ... exit loop
		Else
			$ProgBarMin=$ProgBarMin+10
			GUICtrlSetData ($ProgBar,$ProgBarMin) ; Increment Progress value...
			If $ProgBarMin >= $ProgBarMax then $ProgBarMin=0 ; Reset ProgressBar value when reach the max value
			$Occurance=$Occurance+1 ; Increment $Occurance value for next possible occurance
		EndIf			
	Until $Retval=0

GUICtrlSetState($ProgBar,$GUI_HIDE)
Return $Occurance
EndFunc

Func VerifyEOF($szFileName) 
#cs
Verify if EOF contains any LineFeed pattern. If not append it to file.
This verification is mandatory cause when the destination file do not end with such pattern
the first appending (1rst line) is done at the end of the last line without any line feed.
#ce
Local $s_TotFile=FileRead($szFileName, FileGetSize($szFileName))
	If StringRight($s_TotFile,2) = @CRLF Then
	ElseIf StringRight($s_TotFile,1) = @CR Then
	ElseIf StringRight($s_TotFile,1) = @LF Then
	Else
		FileWrite ( $szFileName , @CRLF )
	EndIf
EndFunc

Func DisplayHelp()
	Select
		Case @GUI_CtrlId = 6
			$HelpMsg = "'File to Explore' imput box should contains the data source file complete path and name." & @LF & "(The file where string(s) to be replaced is(are) located)" & @LF & @LF & "Note : File must exist!" 
		Case @GUI_CtrlId = 10
			$HelpMsg = "'Destination File' input box is only used if you want to append data from the source file" & " to an other one." & @LF & @LF &  "Note : If destination file doesn't exist if will be created (source file will be copied)."
		Case @GUI_CtrlId = 13
			$HelpMsg = "Indicate the pattern/string to be found in source file."
		Case @GUI_CtrlId = 16
			$HelpMsg = "Indicate the pattern/string which will replace the pattern indicated in the 'Search' input box." & @LF & @LF & "Note : The replacement will occur in the source file before any other operation."
		Case @GUI_CtrlId = 18
			$HelpMsg = "Header must be included if :" & @LF & "- You create a new file ('Destination File' input box is filled with a non existing file name)"& @LF & "- You want to append data from a source file which do not contains any header (first line contains data)." & @LF & "- You realy want to include header in an existing destination file (should not happen)."
	EndSelect
	MsgBox(32,$title & " - Help",$HelpMsg)
EndFunc

;---------FUNCTIONS BLOCK END ----------------------------------------------