#cs
~~~~~~Current Errors~~~~~
1) Drag and drop, doesn't work at all, I don't know why it shows the filename, I didn't code that...
2) $CanSave needs to be specific to EACH tab
3) Once a tab is deleted (not coded yet) it will throw off the tab names...
4) Would like window title to change to the name of the selected tab...
5) Need to code the context menu for the tabs
6) Probably about 15 more I haven't noticed yet...
~~~~~~Current Errors~~~~~
I really just need help on 1-4, I can do most of the other errors myself, I'm just stuck on 1-4. Thanks!
#ce

#include <GUIConstants.au3>
#include <GuiEdit.au3>
#include <Misc.au3>
#include <File.au3>
#include <GUITab.au3>

$file = "Untitled"
$OpenSaveDir = @DocumentsCommonDir
$CanSave = 0
$SearchCompare = ""
$TextToFind = ""
$occurrence = 1
$CanFindNext = 0

If Not FileExists("settings.txt") Then
	If MsgBox(4, "No settings found!", "Namepad could not locate a settings file," & @LF & "would you like to create one?") = 6 Then
		FileWrite("settings.txt", "Courier New|")
		FileWrite("settings.txt", "11|")
		FileWrite("settings.txt", "black")
		$settings = FileRead("settings.txt")
		$settings = StringSplit($settings, "|")
		$FontName = $settings[1]
		$FontSize = $settings[2]
		$fontColor = $settings[3]
	Else
		MsgBox(0, "Namepad", "No settings file will be created, you cannot save settings " & @LF & _
							"without one. You can create one at any point in the 'Format' menu.")
		$FontName = "Courier New"
		$FontSize = "11"
		$FontColor = "black"
	EndIf
Else
	$settings = FileRead("settings.txt")
	$settings = StringSplit($settings, "|")
	If IsArray($settings) Then
		If $settings[0] >= 3 Then
			$FontName = $settings[1]
			$FontSize = $settings[2]
			$FontColor = $settings[3]
		Else
			MsgBox(48, "Corrupt file!", "The settings file is corrupt and will be rebuilt!")
			RebuildSettings()
		EndIf
	Else
		MsgBox(48, "Corrupt file!", "The settings file is corrupt and will be rebuilt!")
		RebuildSettings()
	EndIf
EndIf	

#region GUI build
$title = "Untitled"
$MainWnd = GUICreate($title & " - Namepad by Magic Soft Inc.", 700, 500, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SYSMENU, $WS_SIZEBOX, $WS_MAXIMIZEBOX), $WS_EX_ACCEPTFILES)
; Create the top menu
$FileMenu = GUICtrlCreateMenu("File")
	$new = GUICtrlCreateMenuitem("New", $FileMenu)
	$open = GUICtrlCreateMenuitem("Open", $FileMenu)
	$save = GUICtrlCreateMenuitem("Save", $FileMenu)
	$SaveAs = GUICtrlCreateMenuitem("Save As", $FileMenu)
	$SaveAll = GUICtrlCreateMenuitem("Save All", $FileMenu)
	GUICtrlCreateMenuitem("", $FileMenu)
	$print = GUICtrlCreateMenuitem("Print", $FileMenu)
	GUICtrlCreateMenuitem("", $FileMenu)
	$exit = GUICtrlCreateMenuitem("Exit", $FileMenu)
$edit = GUICtrlCreateMenu("Edit")
	$undo = GUICtrlCreateMenuitem("Undo", $edit)
	GUICtrlCreateMenuitem("", $edit)
	$copy = GUICtrlCreateMenuitem("Copy", $edit)
	$cut = GUICtrlCreateMenuitem("Cut", $edit)
	$paste = GUICtrlCreateMenuitem("Paste", $edit)
	$SelectAll = GUICtrlCreateMenuitem("Select All", $edit)
	GUICtrlCreateMenuitem("", $edit)
	$find = GUICtrlCreateMenuitem("Find", $edit)
	$next = GUICtrlCreateMenuitem("Find next", $edit)
	GUICtrlCreateMenuitem("", $edit)
$format = GUICtrlCreateMenu("Format")
	$WordWrap = GUICtrlCreateMenuitem("Word wrap", $format, -1, 1)
	$CapCheck = GUICtrlCreateMenuitem("Fix capitilization", $format)
	$font = GUICtrlCreateMenuitem("Choose font", $format)
	GUICtrlCreateMenuitem("", $format)
	$MakeSettingsFile = GUICtrlCreateMenuitem("Make a settings file", $format)
$help = GUICtrlCreateMenu("Help")
	$about = GUICtrlCreateMenuitem("About", $help)
; Create the tabs and edit window
Dim $tab[100], $TextBox[100]
$tab[0] = 1
$TextBox[0] = 1
$tabs = GUICtrlCreateTab(0, 440, 700, 20, 0x0002, -1)
$TabMenu = GUICtrlCreateContextMenu($tabs)
	$SaveMenu = GUICtrlCreateMenu("Save", $TabMenu)
		$SaveMenuSave = GUICtrlCreateMenuitem("Save", $SaveMenu)
		$SaveMenuSaveAs = GUICtrlCreateMenuitem("Save As", $SaveMenu)
		$SaveMenuSaveAll = GUICtrlCreateMenuitem("Save All", $SaveMenu)
	$TabMenuFixCaps = GUICtrlCreateMenuitem("Fix Capitilization", $TabMenu)
	$TabMenuClose = GUICtrlCreateMenuitem("Close", $TabMenu)
GUICtrlSetResizing($tabs, 576)
$tab[1] = GUICtrlCreateTabItem($title)
$TextBox[1] = GUICtrlCreateEdit("", 0, 0, 700, 440, BitOr($WS_VSCROLL, $WS_HSCROLL, $ES_MULTILINE))
GUICtrlCreateTabItem("")
GUICtrlSetFont($TextBox[1], $FontSize, 400, "", $FontName)
GUICtrlSetColor($TextBox[1], $FontColor)
GUICtrlSetState($TextBox[1], $GUI_DROPACCEPTED)
GUICtrlSetResizing($TextBox[1], 102)
$stats = GUICtrlCreateLabel("", 0, 462, 700, 19, 0x1000)
GUICtrlSetResizing($stats, 576)
UpdateStats()
GUISetState(@SW_SHOW)
#endregion GUI build

#region main loop
while 1
	$line = ControlCommand($MainWnd, "", $TextBox[1], "GetCurrentLine")
	$col = ControlCommand($MainWnd, "", $TextBox[1], "GetCurrentCol")
	
    $msg = GUIGetMsg()
	If _IsPressed(72) Then
		Send("{F3 UP}")
		If $CanFindNext = 1 Then FindNext()
	EndIf
    If $msg = $GUI_EVENT_CLOSE Then close()
	If $msg = $GUI_EVENT_DROPPED Then MsgBox(0, "", "hi there")
	If $msg = $exit Then close()	
	If $msg = $new Then new()	
	If $msg = $open Then open()
	If $msg = $SaveAs Then SaveAs()		
	If $msg = $save Then save()		
	If $msg = $print Then print()		
	If $msg = $undo Then undo()	
	If $msg = $copy Then copy()	
	If $msg = $cut Then cut()	
	If $msg = $paste Then paste()	
	If $msg = $SelectAll Then SelectAll()		
	If $msg = $find Then find()
	If $msg = $next Then FindNext()
	If $msg = $CapCheck Then CapCheck()
	If $msg = $font Then ChangeFont()
	If $msg = $MakeSettingsFile Then RebuildSettings()
	If _IsPressed("74") and WinActive($MainWnd, "") Then InsertDate()
	While _IsPressed("11") and WinActive($MainWnd, "")
		GUIGetMsg()
		If _IsPressed("53") Then
			save()
		ElseIf _IsPressed("41") Then
			SelectAll()
		EndIf
	WEnd
	If 	ControlCommand($MainWnd, "", $TextBox[1], "GetCurrentLine") <> $line or ControlCommand($MainWnd, "", $TextBox[1], "GetCurrentCol") <> $col Then UpdateStats()
WEnd
#endregion main loop

#region functions
Func CapCheck()
	$SentenceStart = 1
	$text = StringSplit(ControlGetText($mainWnd, "", $TextBox[1]), "")
	For $i = 1 to $text[0]
		If $text[$i] = "i" Then
			If $text[$i-1] = " " or $text[$i-1] = "" Then
				If $text[$i+1] = " " or $text[$i+1]= "" Then
					_GUICtrlEditSetSel($TextBox[1], $i-1, $i)
					Send("I")
				EndIf
			EndIf
		EndIf
		If $text[$i] = '.' or $text[$i] = '!' or $text[$i] = '?' Then $SentenceStart = 1
		If $text[$i] <> " " and $text[$i] <> "." and $text[$i] <> "!" and $text[$i] <> "?" Then
			If $SentenceStart = 1 Then
				$SentenceStart = 0
				If StringIsLower($text[$i]) Then
					_GUICtrlEditSetSel($TextBox[1], $i-1, $i)
					Send(StringUpper($text[$i]))
				EndIf
			EndIf
		EndIf
	Next
	_GUICtrlEditSetSel($TextBox[1], $i, $i)
EndFunc

Func New()
	$tab[0]+=1
	$tab[$tab[0]] = GUICtrlCreateTabItem("Untitled")
	$TextBox[0]+=1
	$TextBox[$TextBox[0]] = GUICtrlCreateEdit("", 0, 0, 700, 440, BitOr($WS_VSCROLL, $WS_HSCROLL, $ES_MULTILINE))
	GUICtrlCreateTabItem("")
EndFunc

Func open()
	$message = "Select a file to open"
	$file = FileOpenDialog($message, $OpenSaveDir, "Text Files (*.txt)|All Files (*.*)", 5 )
	If $file <> "" Then
		$FileName = StringSplit($file, "\")
		$tab[0]+=1
		$tab[$tab[0]] = GUICtrlCreateTabItem($FileName[$FileName[0]])
		$TextBox[0]+=1
		$TextBox[$TextBox[0]] = GUICtrlCreateEdit("", 0, 0, 700, 440, BitOr($WS_VSCROLL, $WS_HSCROLL, $ES_MULTILINE))
		GUICtrlCreateTabItem("")
		GUICtrlSetData($TextBox[$TextBox[0]], FileRead($file))
		WinSetTitle($MainWnd, "", $FileName[$FileName[0]] & " - Namepad by Magic Soft Inc.")
	EndIf
	$CanSave = 1
	$OpenSaveDir = $file
EndFunc

Func drop()
	MsgBox(0, "", "")
	if ControlGetText($MainWnd, "", $TextBox[1]) <> FileRead($file) Then
		$prompt = MsgBox(0x40024, "Save your file?", "If you do not save now, changes will be lost.")
		if $prompt = 6 Then save()
	EndIf
	$file = @GUI_DragFile
	GUICtrlSetData($TextBox[1], FileRead($file))
	$FileName = StringSplit($file, "\")
	If $file <> "" Then WinSetTitle($MainWnd, "", $FileName[$FileName[0]] & " - Namepad by Magic Soft Inc.")
	$CanSave = 1
EndFunc

func save()
	if $CanSave = 0 Then
		SaveAs()
	Else
		FileDelete($file)
		$TabNumber =  _GUICtrlTabGetCurSel($tabs)
		FileWrite($file, ControlGetText($MainWnd, "", $TextBox[$TabNumber+1]))
		$FileName = StringSplit($file, "\")
		If $file <> "" Then WinSetTitle($MainWnd, "", $FileName[$FileName[0]] & " - Namepad by Magic Soft Inc.")
		$OpenSaveDir = $file
	EndIf
EndFunc

func SaveAs()
	$TabNumber =  _GUICtrlTabGetCurSel($tabs)
	$RecommendedName = StringSplit(GUICtrlRead($TextBox[$TabNumber+1]), " ")
	$file = FileSaveDialog("Select a filename", $OpenSaveDir, "Text Files (*.txt)|All Files (*.*)", 16, $RecommendedName[1] & ".txt")
	FileDelete($file)
	FileWrite($file, ControlGetText($MainWnd, "", $TextBox[$TabNumber+1]))
	If $file <> "" Then
		$FileName = StringSplit($file, "\")
		WinSetTitle($MainWnd, "", $FileName[$FileName[0]] & " - Namepad by Magic Soft Inc.")
		GUICtrlSetData($tab[$TabNumber+1], $FileName[$FileName[0]])
		$CanSave = 1
	EndIf
EndFunc

func print()
	FileDelete(@TempDir & "\namepadprintjob.txt")
	$FileToPrint = FileWrite(@TempDir & "\namepadprintjob.txt", ControlGetText($MainWnd, "", $TextBox[1]))
	_FilePrint($FileToPrint, @SW_SHOW)
	FileDelete(@TempDir & "\namepadprintjob.txt")
EndFunc

Func undo()
	Send("^z") ; Is this really the best way to copy, cut, paste, ect.?
EndFunc

Func copy()
	Send("^c")
EndFunc

Func cut()
	Send("^x")
EndFunc

Func paste()
	Send("^v")
EndFunc

Func SelectAll()
	$chars = 0
	for $i = 1 to _GUICtrlEditGetLineCount($TextBox[1])
		$chars+=_GUICtrlEditLineLength($TextBox[1], $i)
	Next
	_GUICtrlEditSetSel($TextBox[1], 0, $chars+_GUICtrlEditGetLineCount($TextBox[1])*9999999999) ; Select all still needs work
EndFunc

Func find()
	$MatchCase = 0
	$SearchWnd = GUICreate("Find", 450, 115, 100, 100, "", "", $MainWnd)
	$SearchString = GUICtrlCreateInput($TextToFind, 5, 10, 375)
	GUICtrlCreateLabel("Find what?", 385, 13)
	$CaseButton = GUICtrlCreateCheckbox("Match case?", 5, 50)
	$GoButton = GUICtrlCreateButton(" Search ", 295, 50)
	$NoButton = GUICtrlCreateButton(" Cancel ", 350, 50)
	GUISetState()
	While 1
		$SearchMsg = GUIGetMsg()
		if $SearchMsg = $GoButton and ControlGetText($SearchWnd, "", $SearchString) <> "" Then
			$CanFindNext = 1
			Global $SearchLength = _GUICtrlEditLineLength($SearchString)
			Global $TextToFind = ControlGetText($SearchWnd, "", $SearchString)
			if $SearchCompare <> $TextToFind Then
				Global $occurrence = 1
				$SearchCompare = $TextToFind
			Else
				$occurrence+=1
			EndIf
			$search = StringInStr(ControlGetText($MainWnd, "", $TextBox[1]), $TextToFind, 0, $occurrence)
			If $search = 0 Then
				$occurrence = 1
				GUISetState(@SW_HIDE, $SearchWnd)
				MsgBox(0, "No results", "Could not find '" & $TextToFind & "'.")
			Else
				GUISetState(@SW_HIDE, $SearchWnd)
				_GUICtrlEditSetSel($TextBox[1], $search-1, $search+$SearchLength-1)
			EndIf
			ExitLoop
		EndIf
		if $SearchMsg = $NoButton Then
			$CanFindNext = 0
			$occurrence = 1
			$TextToFind = ""
			GUISetState(@SW_HIDE, $SearchWnd)
			ExitLoop
		EndIf
		if $SearchMsg = $CaseButton Then
			If $MatchCase = 0 Then
				$MatchCase = 1
			Else
				$MatchCase = 0
			EndIf
		EndIf
	WEnd
EndFunc

Func FindNext()
	If $CanFindNext = 1 Then
		$occurrence+=1
		$search = StringInStr(ControlGetText($MainWnd, "", $TextBox[1]), $TextToFind, 0, $occurrence)
		If $search = 0 Then
			Global $occurrence = 1
			$search = StringInStr(ControlGetText($MainWnd, "", $TextBox[1]), $TextToFind, 0, $occurrence)
			_GUICtrlEditSetSel($TextBox[1], $search-1, $search+$SearchLength-1)
		Else
			_GUICtrlEditSetSel($TextBox[1], $search-1, $search+$SearchLength-1)
		EndIf
	Else
		find()
	EndIf
EndFunc

func InsertDate()
	Send("{F5 UP}")
	If @HOUR > 12 Then
		$HOUR = @HOUR-12
		$time = " PM "
	Else
		$time = " AM "
	EndIf
	Send($HOUR & ":" & @MIN & $time & @Mon & "/" & @MDAY & "/" & @YEAR)
EndFunc

Func ChangeFont()
	$NewFont = _ChooseFont($FontName, $FontSize, $FontColor)
	If Not @error Then
		$FontName = $NewFont[2]
		$FontSize = $NewFont[3]
		$fontColor =$NewFont[7]
		GUICtrlSetFont($TextBox[1], $NewFont[3], $NewFont[4], $NewFont[1], $NewFont[2])
		GUICtrlSetColor($TextBox[1],$NewFont[7])
		FileDelete("settings.txt")
		FileWrite("settings.txt", $NewFont[2] & "|")
		FileWrite("settings.txt", $NewFont[3] & "|")
		FileWrite("settings.txt", $NewFont[7])
		$settings = FileRead("settings.txt")
		$settings = StringSplit($settings, "|")
		$FontName = $settings[1]
		$FontSize = $settings[2]
		$fontColor = $settings[3]
	EndIf
EndFunc

Func RebuildSettings()
	If FileExists("settings.txt") Then
		If MsgBox(4, "Namepad", "This will erase your current settings. Continue?") = 6 Then
			FileDelete("settings.txt")
			FileWrite("settings.txt", "Courier New|")
			FileWrite("settings.txt", "11|")
			FileWrite("settings.txt", "black")
			$settings = FileRead("settings.txt")
			$settings = StringSplit($settings, "|")
			$FontName = $settings[1]
			$FontSize = $settings[2]
			$FontColor = $settings[3]
		EndIf
	Else
		FileDelete("settings.txt")
		FileWrite("settings.txt", "Courier New|")
		FileWrite("settings.txt", "11|")
		FileWrite("settings.txt", "black")
		$settings = FileRead("settings.txt")
		$settings = StringSplit($settings, "|")
		$FontName = $settings[1]
		$FontSize = $settings[2]
		$FontColor = $settings[3]
	EndIf
EndFunc

Func UpdateStats()
	$lines = _GUICtrlEditGetLineCount($TextBox[1])
	If $lines = 1 Then
		$pl2 = ""
	Else
		$pl2 = "s"
	EndIf
	$characters = 0
	for $i = 1 to $lines
		$CharStart = _GUICtrlEditLineIndex($TextBox[1], $i-1)
		$characters+=_GUICtrlEditLineLength($TextBox[1], $CharStart)
	Next
	If $characters = 1 Then
		$pl1 = ""
	Else
		$pl1 = "s"
	EndIf
	$line = ControlCommand($MainWnd, "", $TextBox[1], "GetCurrentLine")
	$col = ControlCommand($MainWnd, "", $TextBox[1], "GetCurrentCol")
	GUICtrlSetData($stats, $characters & " character" & $pl1 & " in " & $lines & " line" & $pl2 & " of text. " & _
					"Line: " & $line & " Row: " & $col)
EndFunc

Func close()
	If ControlGetText($MainWnd, "", $TextBox[1]) <> FileRead($file) Then
		$FileName = StringSplit($file, "\")
		If IsArray($FileName) Then $FileName = $FileName[$FileName[0]]
		$prompt = MsgBox(0x40023, "Save before closing?", "Would you like to save " & $FileName &"?")
		if $prompt = 6 Then save()
		if $prompt <> 2 Then Exit
	Else
		Opt("TrayIconHide", 1)
		Exit
		;$prompt = MsgBox(40004, "Close Namepad?", "Are you sure you want to exit?")
		;if $prompt <> 7 Then Exit	
	EndIf
EndFunc
#endregion functions