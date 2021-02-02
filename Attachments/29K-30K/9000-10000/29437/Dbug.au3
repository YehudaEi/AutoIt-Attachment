;~ #include-once
#include <WinAPI.au3>
#include <Array.au3>
#include <GUIButton.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <ListViewConstants.au3>
#include <GUIEdit.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

;Opt('MustDeclareVars', 1)
HotKeySet('{F6}', 'DBGShow')	;activate DBUG GUI
HotKeySet('^q', 'DBGExit')	;exit

;global variables declaration
Global $DBGuser32 = DllOpen("user32.dll")
Global $DBGBlock, $DBGOnEventMode, $DBGCurrentGUI, $DBGScriptFullPath, $DBGident, $DBGnotifyFun, $DBGcommandFun, $DBGhSci, $DBGstepMode, $DBGBreakFun, $DBGBreakLine, $DBGtimer
Global $DBGLineFun[1], $DBGlnr
Global $DBGFunVars[1][2], $DBGFunVarsOrg[1][2]
Global $DBGLastFun, $DBGStack, $DBGPrevVar
Global $frmDBUG, $DBGtxtCommand, $DBGbtnRun, $DBGbtnRunCursor, $DBGbtnStep, $DBGbtnStepOver, $DBGtxtResult, $DBGtxtBreakPoint, $DBGbtnClear, $DBGListView, $DBGlblStat, $DBGbtnEdit, $DBGchkSetOnTop

;if called for the first time (no arguments) then create shadow script, start it and exit (if the original script contains a 'Execute(dbug())' statement then continue (debug line mode)
;else (called second time) get the original script name and run it (debug script mode)
$DBGScriptFullPath = @ScriptFullPath
If $CmdLine[0] = 0 Then
	_CreateAndRun()
Else
	$DBGScriptFullPath = $CmdLine[2] & '\' & $CmdLine[1]
EndIf

_Analyse($DBGScriptFullPath)	;get variables for each function

$DBGstepMode = True	;default mode
Opt('WinTitleMatchMode', 1)
$DBGhSci = ControlGetHandle($DBGScriptFullPath,"","[CLASS:Scintilla;INSTANCE:1]")	;Scintilla handle
ConsoleWrite('DBUG started with ' & $CmdLine[0] & ' arguments.')

;DBUG GUI
#Region ### START Koda GUI section ### Form=d:\nlrgo\my documents\my autoit scripts\dbug\frmdbug.kxf
$frmDBUG = GUICreate("DBUG", 670, 602, 381, 154, BitOR($WS_MAXIMIZEBOX,$WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_OVERLAPPEDWINDOW,$WS_TILEDWINDOW,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_TABSTOP,$WS_BORDER,$WS_CLIPSIBLINGS))
GUISetIcon("")
$DBGtxtCommand = GUICtrlCreateEdit("", 16, 248, 600, 105)
GUICtrlSetData(-1, "<command>")
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT)
GUICtrlSetTip(-1, "Command to execute (Ctrl-Enter)")
$DBGtxtResult = GUICtrlCreateEdit("", 16, 352, 600, 209)
GUICtrlSetData(-1, "<result>")
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM)
GUICtrlSetTip(-1, "Display results")
$DBGtxtBreakPoint = GUICtrlCreateInput("", 224, 8, 389, 23)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Conditional breakpoint expression")
$DBGListView = GUICtrlCreateListView("var|scope|type|value", 16, 40, 600, 209, BitOR($LVS_REPORT,$LVS_EDITLABELS,$LVS_SHOWSELALWAYS), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 50)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP)
GUICtrlSetTip(-1, "Display expressions")
$DBGbtnStep = GUICtrlCreateButton("Step", 16, 8, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\StepInto.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Step Into (F7)")
$DBGbtnStepOver = GUICtrlCreateButton("Over", 48, 8, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\StepOver.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Step Over (F8)")
$DBGbtnRunCursor = GUICtrlCreateButton("Curs", 80, 8, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\RunToCursor.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Run To Cursor")
$btnBreak = GUICtrlCreateButton("Brk", 112, 8, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Pause.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Pause")
$DBGbtnRun = GUICtrlCreateButton("Run", 144, 8, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Resume.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Resume (F5)")
$btnExit = GUICtrlCreateButton("Exit", 624, 536, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Stop.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Exit (Ctrl-Q)")
$btnToggle = GUICtrlCreateButton("Set", 176, 8, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\BreakPoints.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Set/Reset Breakpoint Line (Ctrl-F2)")
$DBGbtnClear = GUICtrlCreateButton("X", 624, 8, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Erase.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Clear")
$btnDelete = GUICtrlCreateButton("Del", 624, 64, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Cut.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Delete selected expression (Ctrl-X)")
$btnInsert = GUICtrlCreateButton("Ins", 624, 88, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Add.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Insert new expression (Ins)")
$DBGbtnEdit = GUICtrlCreateButton("Edit", 624, 112, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Edit.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Edit expression (F2)")
$btnOriginal = GUICtrlCreateButton("Org", 624, 168, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Refresh.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Restore original list")
$btnLoad = GUICtrlCreateButton("Load", 624, 192, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Open.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Restore saved list (Ctrl-O)")
$btnStore = GUICtrlCreateButton("Store", 624, 216, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Save.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Save list (Ctrl-S)")
$btnClearCmd = GUICtrlCreateButton("Clear", 624, 248, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Erase.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Clear")
$btnExecute = GUICtrlCreateButton("Exe", 624, 320, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Execute.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Execute command (Ctrl-Enter)")
$btnClearResults = GUICtrlCreateButton("Clear", 624, 352, 32, 24, BitOR($BS_BITMAP,$WS_GROUP))
GUICtrlSetImage(-1, "D:\nlrgo\My Documents\My AutoIt Scripts\Dbug\IMAGES\Erase.bmp", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Clear Results")
$DBGchkSetOnTop = GUICtrlCreateCheckbox("Top", 624, 40, 32, 24, BitOR($BS_CHECKBOX,$BS_PUSHLIKE,$WS_TABSTOP))
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Set On Top")
$DBGlblStat = GUICtrlCreateLabel("<status>", 15, 580, 604, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Courier New")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Currently executing Function(line)")
#EndRegion ### END Koda GUI section ###

;after koda save GUISetState and GUISetAccelerators lines in Koda GUI section
Dim $frmDBUG_AccelTable[11][2] = [["{F5}", $DBGbtnRun],["{F7}", $DBGbtnStep],["{F2}", $DBGbtnEdit],["{F8}", $DBGbtnStepOver],["^q", $btnExit],["^x", $btnDelete],["^s", $btnStore],["^o", $btnLoad],["^{F2}", $btnToggle],["{INS}", $btnInsert],["^{ENTER}", $btnExecute]]
GUISetAccelerators($frmDBUG_AccelTable)

$DBGImagePath = StringReplace(@AutoItExe, "AutoIt3.exe", "IMAGES\")
If Not FileExists($DBGImagePath) Then GUICtrlSetData($DBGtxtResult, "No button images found in " & $DBGImagePath)
GUISetIcon($DBGImagePath & "Dbug.ico", -1, $frmDBUG)
GUICtrlSetStyle($DBGchkSetOnTop, BitOR($WS_GROUP, $BS_PUSHLIKE, $BS_AUTOCHECKBOX, $BS_BITMAP))
GUICtrlSetImage($DBGchkSetOnTop, $DBGImagePath & "OnTop.bmp", -1)
GUICtrlSetImage($DBGbtnRun, $DBGImagePath & "Resume.bmp", -1)
GUICtrlSetImage($DBGbtnClear, $DBGImagePath & "Erase.bmp", -1)
GUICtrlSetImage($DBGbtnStep, $DBGImagePath & "StepInto.bmp", -1)
GUICtrlSetImage($DBGbtnRunCursor, $DBGImagePath & "RunToCursor.bmp", -1)
GUICtrlSetImage($DBGbtnEdit, $DBGImagePath & "Edit.bmp", -1)
GUICtrlSetImage($DBGbtnStepOver, $DBGImagePath & "StepOver.bmp", -1)
GUICtrlSetImage($btnBreak, $DBGImagePath & "Pause.bmp", -1)
GUICtrlSetImage($btnExit, $DBGImagePath & "Exit.bmp", -1)
GUICtrlSetImage($btnDelete, $DBGImagePath & "Cut.bmp", -1)
GUICtrlSetImage($btnStore, $DBGImagePath & "Save.bmp", -1)
GUICtrlSetImage($btnLoad, $DBGImagePath & "Open.bmp", -1)
GUICtrlSetImage($btnToggle, $DBGImagePath & "BreakPoints.bmp", -1)
GUICtrlSetImage($btnClearCmd, $DBGImagePath & "Erase.bmp", -1)
GUICtrlSetImage($btnClearResults, $DBGImagePath & "Erase.bmp", -1)
GUICtrlSetImage($btnInsert, $DBGImagePath & "Add.bmp", -1)
GUICtrlSetImage($btnOriginal, $DBGImagePath & "Refresh.bmp", -1)
GUICtrlSetImage($btnExecute, $DBGImagePath & "Execute.bmp", -1)

DBGShow()

WinSetOnTop($frmDBUG, '', 1)


Func Dbug($lnr = @ScriptLineNumber, $case = -5, $exp = 0, $exp2 = 0)	;main function
	;ConsoleWrite('DBUG(' & $lnr & ') case: ' & $case & ' exp: ' & $exp & ' exp2: ' & $exp2 & @CRLF)

	Local $Msg, $brk, $sel, $editActive, $in, $out, $var, $val, $hEdit, $items, $fx, $CurExpr, $max, $item, $scope, $vname, $breaknow

	Switch $case
		Case -9 ;loop

		While True
			Opt('GUIOnEventMode', 0)
			$DBGBlock = True

			$Msg = GUIGetMsg()
			Switch $Msg

				Case $DBGbtnClear	;clear conditional breakpoint
					GUICtrlSetData($DBGtxtBreakPoint, "")
					ControlFocus($frmDBUG, "", $DBGtxtBreakPoint)

				Case $btnClearCmd
					GUICtrlSetData($DBGtxtCommand, "")
					ControlFocus($frmDBUG, "", $DBGtxtCommand)

				Case $btnClearResults
					GUICtrlSetData($DBGtxtResult, "")
					ControlFocus($frmDBUG, "", $DBGtxtResult)

				Case $DBGchkSetOnTop	;set on top
					WinSetOnTop($frmDBUG, '', 0)
					If GUICtrlRead($DBGchkSetOnTop) = $GUI_CHECKED Then WinSetOnTop($frmDBUG, '', 1)

				Case $DBGbtnRun, $DBGbtnStep, $DBGbtnRunCursor, $DBGbtnStepOver	;handle debug command
					$sel = _SCISendMessage($DBGhSci, 2009)	;get anchor
					$sel = _SCISendMessage($DBGhSci, 2166, $sel)+1	;linefromposition

					$DBGstepMode = False	;set run/step mode things
					$DBGBreakFun = ''
					$DBGBreakLine = 0
					$DBGLineFun[0] = 0
					If $msg = $DBGbtnStep Then $DBGstepMode = True
					If $msg = $DBGbtnStepOver Then $DBGBreakFun = $DBGLineFun[$lnr]
					If $msg = $DBGbtnRunCursor Then $DBGBreakLine = $sel

					WinSetTitle($frmDBUG, 0, 'DBUG - Running script')	;set GUI things
					For $val = 1 To 20 ;disable buttons
						$text = ControlGetText($frmDBUG, "", "[CLASS:Button;INSTANCE:" & $val & "]")
						If $text <> "Brk" And $text <> "Exit" Then ControlDisable($frmDBUG, "", "[CLASS:Button;INSTANCE:" & $val & "]")
					Next
					_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($DBGListView))

					_SCISendMessage($DBGhSci, 2045, 3)	;delete markers
					Opt('GUIOnEventMode', $DBGOnEventMode)	;restore previous OnEventMode
					GUISwitch($DBGCurrentGUI)	;restore previous GUI
					$DBGBlock = False	;release just before return

					Return

				Case $btnToggle ;set/reset breakpoint line
					$sel = _SCISendMessage($DBGhSci, 2009)	;get anchor
					$sel = _SCISendMessage($DBGhSci, 2166, $sel)+1	;linefromposition

					$val = _SCISendMessage($DBGhSci, 2046, $sel-1)		;markerget
					If BitAND($val, 0x0002) Then
						_SCISendMessage($DBGhSci, 2044, $sel-1, 1)		;delete marker
					Else
						_SCISendMessage($DBGhSci, 2043, $sel-1, 1)		;add marker
					EndIf

				Case $DBGbtnEdit	;edit listview item
					$sel = _GUICtrlListView_GetSelectedIndices($DBGListView)
					_GUICtrlListView_EditLabel($DBGListView, Int($sel))

				Case $btnInsert	;insert listview item
					$sel = _GUICtrlListView_GetNextItem($DBGListView, -1, 0, 8)
					If $sel = -1 Then $sel = 0
					_GUICtrlListView_InsertItem($DBGListView, "<expression>", Int($sel))
					_GUICtrlListView_SetItemSelected(GUICtrlGetHandle($DBGListView), $sel, True)
					_GUICtrlListView_EditLabel($DBGListView, Int($sel))

				Case $btnDelete ;delete selected listview items
					$val = _GUICtrlListView_GetSelectedIndices($DBGListView, True)
					For $sel = UBound($val)-1 To 1 Step -1
						_GUICtrlListView_DeleteItem(GUICtrlGetHandle($DBGListView), $val[$sel])
					Next
					_GUICtrlListView_SetItemSelected(GUICtrlGetHandle($DBGListView), $val[1], True)
					;_GUICtrlListView_EnsureVisible($DBGListView, $val[1])
					ControlFocus($frmDBUG, "", $DBGListView)
					SaveListItems($lnr)

				Case $btnOriginal ;retsore original list
					$fx = _ArraySearch($DBGFunVars, $DBGLineFun[$lnr])
					$DBGFunVars[$fx][1] = $DBGFunVarsOrg[$fx][1]
					PopulateListView($lnr)
					Return StringFormat('Execute(Dbug(%s,-1))', $lnr)	;do refresh

				Case $btnStore ;save list
					$fx = _ArraySearch($DBGFunVars, $DBGLineFun[$lnr])
					IniWrite("dbug.ini", "ListView", $DBGLineFun[$lnr], $DBGFunVars[$fx][1])
					IniWrite("dbug.ini", "Command", "Text", StringToBinary(GUICtrlRead($DBGtxtCommand)))
					IniWrite("dbug.ini", "Result", "Text", StringToBinary(GUICtrlRead($DBGtxtResult)))

				Case $btnLoad ;restore list
					$fx = _ArraySearch($DBGFunVars, $DBGLineFun[$lnr])
					$val = IniRead("dbug.ini", "ListView", $DBGLineFun[$lnr], "")
					If $val <> "" Then $DBGFunVars[$fx][1] = $val
					PopulateListView($lnr)
					GUICtrlSetData($DBGtxtCommand, BinaryToString(IniRead("dbug.ini", "Command", "Text", "")))
					GUICtrlSetData($DBGtxtResult, BinaryToString(IniRead("dbug.ini", "Result", "Text", "")))

					Return StringFormat('Execute(Dbug(%s,-1))', $lnr)	;do refresh

				Case $btnExecute	;execute expression
					$sel = _GUICtrlEdit_GetSel($DBGtxtCommand)
					$sel = _GUICtrlEdit_LineFromChar($DBGtxtCommand, $sel[0])
					$in = _GUICtrlEdit_GetLine($DBGtxtCommand, $sel)
					$in = _StringEscape($in)	;deal with escaping quotes

					If StringInStr($in, "=") > 0 Then	;do assignment
						$var = StringRegExp($in, "(.*?)=", 1)
						$val = StringRegExp($in, "=(.*)", 1)
						Return StringFormat('Execute(Dbug(%s, -3, Execute("_Set(%s, %s)"), @error))', $lnr, $var[0], $val[0])
					Else								;do expression
						Return StringFormat('Execute(Dbug(%s, -6, Execute("%s"), @error))', $lnr, $in)
					EndIf

				Case $btnExit
					Exit

			EndSwitch	;$Msg

			;check for edit label end
			$hEdit = _GUICtrlListView_GetEditControl($DBGListView)
			If $hEdit Then	;store text during editing
				$item =  _GUICtrlEdit_GetText(HWnd($hEdit))
				$editActive = True
			Else
				If $editActive Then	;EDIT END
					_GUICtrlListView_SetItemText($DBGListView, _GUICtrlListView_GetNextItem($DBGListView, -1, 0, 4), $item)	;set text
					SaveListItems($lnr)

					Return StringFormat('Execute(Dbug(%s,-1))', $lnr)	;do refresh
				EndIf
				$editActive = False
			EndIf

			;dynamic variable display
			If TimerDiff($DBGtimer) > 250 Then	;update calling function display every 250ms
				$DBGtimer = TimerInit()

				$var = _SCIGetCurWord()
				If $var <> $DBGPrevVar Then
					$DBGPrevVar = $var
					If StringLeft($var, 1) = "$" Then ;display variable
						Return StringFormat('Execute(Dbug(%s, -7, Execute("%s"), IsDeclared("%s")))', $lnr, $var, StringTrimLeft($var,1))
					ElseIf StringLeft($var, 1) = "@" Then ;display macro
						Return StringFormat('Execute(Dbug(%s, -7, Execute("%s"), -2))', $lnr, $var)
					ElseIf StringRegExp($var, "^[-+x0-9a-fA-F]+$") Then ;display number
						$val = Number($var)
						If VarGetType($val) = "Int32" Then ToolTip(StringFormat("Int\t%s\r\nHex\t0x%s", Int($val), Hex($val, 4)))
						If VarGetType($val) = "Int64" Then ToolTip(StringFormat("Int\t%s\r\nHex\t0x%s", Int($val), Hex($val, 8)))
					Else
						ToolTip("")
					EndIf
				EndIf
			EndIf
		WEnd	;loop

	Case -7	;dynamic variable display
		ToolTip(_Scope($exp2) & " " & _Type($exp) & ' = ' & _Value($exp, True))
		Return StringFormat('Execute(Dbug(%s, -9))', $lnr)	;do loop

	Case -6	;get expression result
		$Msg = StringFormat('-@%s ', $exp2)
		$out = $Msg & _Type($exp) & ' = ' & _Value($exp, True)
		GUICtrlSetData($DBGtxtResult, $out)
		If $exp = "" And $exp2 <> 0 Then GUICtrlSetData($DBGtxtResult, "Error: " & $exp2)
		Return StringFormat('Execute(Dbug(%s,-1))', $lnr)	;do refresh

	Case -5	;set breakpoint check
		$DBGlnr = $lnr
		Static $LastFun
		If $DBGLineFun[$lnr] <> $LastFun Then
			$LastFun = $DBGLineFun[$lnr]
			;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $DBGLineFun[$lnr] = ' & $DBGLineFun[$lnr] & "(" & $lnr & ")" & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
		EndIf

		$DBGLineFun[0] += 1		;counter
		If TimerDiff($DBGtimer) > 250 Then	;update calling function display every 250ms
			GUICtrlSetData($DBGlblStat, StringFormat('%s calls, last from %s(%s)', $DBGLineFun[0], $DBGLineFun[$lnr], $lnr))
			$DBGtimer = TimerInit()

			If BitAND(_GUICtrlButton_GetState($btnBreak), $BST_PUSHED) Then $breaknow = True
			If BitAND(_GUICtrlButton_GetState($btnExit), $BST_PUSHED) Then Exit
		EndIf

		If $DBGBlock Then Return	;no re-entry

		$val = _SCISendMessage($DBGhSci, 2046, $lnr-1)		;markerget
		If $CmdLine[0] = 0 Or BitAND($val, 0x0002) = 2 Or $DBGstepMode Or $DBGLineFun[$lnr] = $DBGBreakFun Or $lnr = $DBGBreakLine Or $breaknow Then
			$brk = True	;(debug line mode) or (breakpoint) or (STEP) or (STEP OVER) or (RUN to CURSOR)
		Else
			$brk = GUICtrlRead($DBGtxtBreakPoint)	;test conditional breakpoint
		EndIf

		Return 'Execute(Dbug(' & $lnr & ', -2, Execute("' & $brk & '"), 0))'	;do init
		;'Execute(Dbug($lnr, -2, Execute("$brk"), 0))'

	Case -3	;get assignment result
		$Msg = StringFormat('=@%s ', $exp2)
		$out = $Msg & _Type($exp) & ' = ' & _Value($exp, True)
		GUICtrlSetData($DBGtxtResult, $out)

		If $exp <> '' Or $exp2 = 0 Then Return StringFormat('Execute(Dbug(%s,-1))', $lnr)	;assignment succesfull -> do refresh

		$in = GUICtrlRead($DBGtxtCommand)
		$in = _StringEscape($in)	;deal with escaping quotes

		Return StringFormat('Execute(Dbug(%s, -6, Execute("%s"), @error))', $lnr, $in)	;assignment failed -> do expression

	Case -2	;init
		If Not $exp Then Return	;no breakpoint

		$DBGBlock = True	;prevent re-entry
		$DBGOnEventMode = Opt('GUIOnEventMode')	;save GUIOnEventMode
		$DBGCurrentGUI = GUISwitch($frmDBUG)	;save current GUI
		$DBGPrevVar = "" ;reset dynamic variable display
		_SCISendMessage($DBGhSci, 2024, $lnr-1)		;gotoline
		_SCISendMessage($DBGhSci, 2045, 3)			;delete markers
		_SCISendMessage($DBGhSci, 2043, $lnr-1, 3)	;add marker

		GUICtrlSetData($DBGlblStat, '')		;set GUI things
		For $val = 1 To 20 ;enable buttons
			ControlEnable($frmDBUG, "", "[CLASS:Button;INSTANCE:" & $val & "]")
		Next
 		If Not WinActive($frmDBUG) Then WinActivate($frmDBUG)
		WinSetTitle($frmDBUG, 0, StringFormat('DBUG - Break in %s(%s)', $DBGLineFun[$lnr], $lnr))

		PopulateListView($lnr)

		Return StringFormat('Execute(Dbug(%s, -1))', $lnr)	;do refresh

	Case -1 To 1000		;read

		_GUICtrlListView_SetItemText($DBGListView, $case, _Scope($exp2), 1)
		If	$case >= 0 Then		;read expression
			If _GUICtrlListView_GetItemText($DBGListView, $case) <> '' And $exp2 Then
				_GUICtrlListView_SetItemText($DBGListView, $case, _Type($exp), 2)
				_GUICtrlListView_SetItemText($DBGListView, $case, _Value($exp), 3)
			Else
				_GUICtrlListView_SetItemText($DBGListView, $case, '', 2)
				_GUICtrlListView_SetItemText($DBGListView, $case, '', 3)
			EndIf
		EndIf

		If $case >= _GUICtrlListView_GetItemCount($DBGListView) Then	;all expressions read
			For $c = 0 To _GUICtrlListView_GetColumnCount($DBGListView)-1
				_GUICtrlListView_SetColumnWidth($DBGListView, $c, $LVSCW_AUTOSIZE_USEHEADER)
			Next
			_GUICtrlListView_EndUpdate($DBGListView)
			Return StringFormat('Execute(Dbug(%s, -9))', $lnr)	;do loop

		EndIf

		;prepare next expression read
		$case += 1
		$var = _GUICtrlListView_GetItemText($DBGListView, $case)
		$var = StringReplace($var, '"', '''')	;escape "

		$scope = -2
		$vname = StringRegExp($var, '\$(\w{1,50})', 1)
		If IsArray($vname) Then	$scope = StringFormat('IsDeclared("%s")', $vname[0])
		$exp = StringFormat('Execute("%s")', $var)
		Return 'Execute(Dbug(' & $lnr & ', ' & $case & ', ' & $exp & ', ' & $scope & '))'	;do read
		;'Execute(Dbug($lnr, $case, $exp, $scope))'

	EndSwitch	;$Case

EndFunc	;Dbug()


Func _Set(ByRef $x, $y)	;variable assignment
	$x = $y
	Return $x
EndFunc


Func _Analyse($script)	;scan source script and assign global arrays (functions/line and variables/function)
	Local $code, $aCode, $f, $line, $funcheader, $var
	Local $func = "Global"
	Local $gVars[1], $fVars[1]

	$code = FileRead($script)

	$aCode = StringSplit($code, @CRLF, 1)

	ReDim $DBGLineFun[$aCode[0]+1]

	$f = 0
	For $l = 1 to $aCode[0]
		$line = StringRegExpReplace($aCode[$l], ";.*", "")	;strip comment from line

		$funcheader = StringRegExp($line, "(?i)^ *func +(\w+)", 1)
		If IsArray($funcheader) Then $func = $funcheader[0]		;get function header

		$DBGLineFun[$l] = $func

		If StringRegExp($line, "(?i)^\s*EndFunc") Then		;function end
			$DBGFunVars[$f][0] = $func
			$DBGFunVars[$f][1] = _ArrayToArgs($fVars)
			$f += 1
			ReDim $DBGFunVars[$f+1][2]	;save function variables
			$func = "Global"
			Local $fVars[1]
		EndIf

		$var = StringRegExp($line, "(?i)([\$\@]\w{1,50})", 3)	;get variables
		If IsArray($var) Then
			If $func = "Global" Then
				_ArrayConcatenate($gVars, $var)
			Else
				_ArrayConcatenate($fVars, $var)
			EndIf
		EndIf
	Next
	$DBGFunVars[$f][0] = "Global"	;save global variables
	$DBGFunVars[$f][1] = _ArrayToArgs($gVars)
	$DBGFunVarsOrg = $DBGFunVars

EndFunc ;_Analyse

Func _ArrayToArgs(ByRef $arr)	;make $arr unique and add dummy parameters ($0) if nessecary

	If Not IsArray($arr) Then Dim $arr[20]

	_ArrayDelete($arr, 0)
	$arr = _ArrayUnique($arr)
	_ArrayDelete($arr, 0)

	Return _ArrayToString($arr, ",")

EndFunc


Func _Scope($res)	;return scope indication
	Switch $res
		Case -1
			Return "L" ;local
		Case 0
			Return "N/D" ;not defined
		Case 1
			Return "G" ;global
		Case -2
			Return "F" ;fixed (macro or literal)
	EndSwitch
EndFunc


Func _Type($var)		;return type of $var
	Local $type, $size

	$type = VarGetType($var)

	Switch $type
		Case 'String'
			$type &= '[' & StringLen($var) & ']'

		Case 'Binary'
			$type &= '[' & BinaryLen($var) & ']'

		Case 'Array'
			For $i = 1 To UBound($var, 0)
				$size &= "[" & UBound($var, $i) & "]"
			Next
			$type &= $size

		Case 'DllStruct'
			$type &= '[' & DllStructGetSize($var) & ']'

		Case 'Ptr'
			If IsHWnd($var) Then $type = 'hWnd'
	EndSwitch

	Return $type
EndFunc	;_Type


Func _Value($var, $ext = False)		;return value of $var ($ext=true gives extended information)
	Local $val, $res

	If $ext And (IsArray($var) Or IsDllStruct($var) Or IsObj($var)) Then $DBGident &= '    '

	Select
	Case IsString($var)
		$val = "'" & $var & "'"

	Case IsArray($var)
		If Not $ext Then Return $var

		_DispArr($var, $val)

	Case IsDllStruct($var)
		$val = '*' & DllStructGetPtr($var)
		If Not $ext Then Return $val

		For $e = 1 To 200	;max elements, should be enough
			$res = DllStructGetData($var, $e)
			If @error Then ExitLoop

			$val &= @CRLF & StringTrimLeft($DBGident, 4) & '[' & $e & '] '
			If IsString($res) Or IsBinary($res) Then
				$val &= _Type($res) & @TAB & _Value($res)
			Else
				For $i = 1 To 1000	;max indexes, should be enough
					$res = DllStructGetData($var, $e, $i)
					If @error Then
						ExitLoop
					ElseIf $i = 1 Then
						$val &= _Type($res) & ' = ' & @TAB & _Value($res)
					Else
						$val &= ', ' & _Value($res)
					EndIf
				next
			EndIf
		Next

	Case IsObj($var)
		If ObjName($var,1) Then $val &= ObjName($var,1)
		If Not $ext Then Return $val

		If ObjName($var,2) Then $val &= @CRLF & StringTrimLeft($DBGident, 4) & "Desc: " & ObjName($var,2)
		If ObjName($var,3) Then $val &= @CRLF & StringTrimLeft($DBGident, 4) & "ID  : " & ObjName($var,3)
		If ObjName($var,4) Then $val &= @CRLF & StringTrimLeft($DBGident, 4) & "DLL : " & ObjName($var,4)
		If ObjName($var,5) Then $val &= @CRLF & StringTrimLeft($DBGident, 4) & "Icon: " & ObjName($var,5)

	Case IsHWnd($var) Or IsPtr($var)
		$val = '*' & $var

	Case Else
		$val = $var
	EndSelect

	If $ext And (IsArray($var) Or IsDllStruct($var) Or IsObj($var)) Then $DBGident = StringTrimLeft($DBGident, 4)

	Return $val

EndFunc	;_Value


Func _DispArr(ByRef $ar, ByRef $out, $d=0, $cnt=0)		;display values of n-dimension array
	Local $res

	If $cnt = 0 Then Dim $cnt[UBound($ar, 0)]

	For $i = 0 to UBound($ar, $d+1)
		if $i = UBound($ar, $d+1) Then Return $d-1
		$cnt[$d] = $i
		if $d < UBound($ar, 0) - 1 Then $d = _DispArr($ar, $out, $d+1, $cnt)	;recursive call
		if $d = UBound($ar, 0) - 1 Then
			$res = Execute("$ar[" & _ArrayToString($cnt,"][") & "]")
			$out &= @CRLF & StringTrimLeft($DBGident, 4) & "[" & _ArrayToString($cnt,"][") & "] " & _Type($res) & ' = ' & @TAB & _Value($res, true)
		EndIf
	Next
EndFunc

Func _SCISendMessage($h_hWnd, $i_msg, $wParam = 0, $lParam = 0, $s_t1 = "int", $s_t2 = "int")	;function and idea stolen from Martin
	Local $ret
	$ret = DllCall($DBGuser32, "long", "SendMessageA", "long", $h_hWnd, "int", $i_msg, $s_t1, $wParam, $s_t2, $lParam)
	Return $ret[0]
EndFunc   ;==>_SCISendMessage

Func _SCIGetCurWord() ;get current word under cursor from Scite
	Local $pos[2], $line, $sta, $end, $text
	Local $tpoint ;= DllStructCreate("int X;int Y")

	$tpoint = _WinAPI_GetMousePos()
	If _WinAPI_WindowFromPoint($tpoint) <> $DBGhSci Then Return ""

	$tpoint = _WinAPI_GetMousePos(True, $DBGhSci)
	$pos[0] = DllStructGetData($tpoint, "X")
	$pos[1] = DllStructGetData($tpoint, "Y")

	$pos = _SCISendMessage($DBGhSci, 2022, $pos[0], $pos[1])
	$line = _SCISendMessage($DBGhSci, 2166, $pos)
	$sta = _SCISendMessage($DBGhSci, 2167, $line)
	$end = _SCISendMessage($DBGhSci, 2136, $line)

	$text = ""
	For $c = $pos To $sta step -1
		$char = chr(_SCISendMessage($DBGhSci, 2007, $c, 0))
		If not StringRegExp($char, "[-@$_a-zA-Z0-9\[\]]") Then ExitLoop
		$text = $char & $text
	Next
	For $c = $pos+1 To $end
		$char = chr(_SCISendMessage($DBGhSci, 2007, $c, 0))
		If not StringRegExp($char, "[-@$_a-zA-Z0-9\[\]]") Then ExitLoop
		$text &= $char
	Next

	Return $text
EndFunc	;_SCSIGetCurWord


Func SaveListItems($lnr) ;save expression list for current line
		$items = ''
		For $i = 0 To _GUICtrlListView_GetItemCount($DBGListView)-1
			$items &= _GUICtrlListView_GetItemText($DBGListView, $i) & ","
		Next
		$fx = _ArraySearch($DBGFunVars, $DBGLineFun[$lnr])
		$DBGFunVars[$fx][1] = StringTrimRight($items, 1)
EndFunc

Func PopulateListView($lnr) ;populate listview
	Local $fx, $CurExpr, $i
		_GUICtrlListView_BeginUpdate($DBGListView)
		$fx = _ArraySearch($DBGFunVars, $DBGLineFun[$lnr])
		$CurExpr = StringSplit($DBGFunVars[$fx][1], ',', 2)
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($DBGListView))
		For $i = 0 To UBound($CurExpr)-1
			_GUICtrlListView_AddItem($DBGListView, $CurExpr[$i])
		Next
EndFunc


Func _StringEscape($in)	;try to get the quotes right
	Local $res
	$res = StringRegExp($in, '"|''', 2)
	If IsArray($res) Then
		If $res[0] = '"' Then
			$in = StringReplace($in, "'", "''")
			$in = StringReplace($in, '"', "'")
		Else
			$in = StringReplace($in, '"', "''")
		EndIf
	EndIf
	Return $in
EndFunc

Func _NotifyHook($hWnd, $Msg, $wParam, $lParam)	;check if WM_NOTIFY not from dbug GUI
	Local $func
	ConsoleWrite('@@ DBUG._NotifyHook(' & @ScriptLineNumber & ') : $hWnd = ' & $hWnd & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

	If $hWnd = $frmDBUG Then Return $GUI_RUNDEFMSG	;notify from Dbug -> ignore

	$func = $CmdLine[3]
	Call($func, $hWnd, $Msg, $wParam, $lParam)		;re-post notify message
	If @error<>0xDEAD or @extended<>0xBEEF Then Return

	ConsoleWrite('@@ DBUG._NotifyHook(' & @ScriptLineNumber & ') : Function: ' & $func & ' not found or wrong number of parameters' & @crlf) ;### Debug Console
EndFunc

Func _CommandHook($hWnd, $Msg, $wParam, $lParam) ;check if WM_COMMAND not from dbug GUI
	Local $func
	ConsoleWrite('@@ DBUG._CommandHook(' & @ScriptLineNumber & ') : $hWnd = ' & $hWnd & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

	If $hWnd = $frmDBUG Then Return $GUI_RUNDEFMSG	;notify from Dbug -> ignore

	$func = $CmdLine[4]
	Call($func, $hWnd, $Msg, $wParam, $lParam)		;re-post notify message
	If @error<>0xDEAD or @extended<>0xBEEF Then Return

	ConsoleWrite('@@ DBUG._CommandHook(' & @ScriptLineNumber & ') : Function: ' & $func & ' not found or wrong number of parameters' & @crlf) ;### Debug Console
EndFunc


Func _CreateAndRun() ;generate DbugScript.au3
	Local $lnr, $line, $res, $continued, $SKIPDBUG, $SKIPCASE, $fHnd, $fOut, $AutoItDir, $run
	Local $REG_WM_NOTIFY = '(?i)^\s*GUIRegisterMsG\(.*\$WM_NOTIFY.*,.*?(\w+)'	; GUIRegisterMsg($WM_NOTIFY,( "function"  ))
	Local $REG_WM_COMMAND = '(?i)^\s*GUIRegisterMsG\(.*\$WM_COMMAND.*,.*?(\w+)'	; GUIRegisterMsg($WM_COMMAND,( "function"  ))

	$fHnd = FileOpen(@ScriptFullPath, 0)	;open source script
	$fOut = FileOpen(@ScriptDir & '\DbugScript.au3', 2)	;open shadow script

	While True
		$line = FileReadLine($fHnd)
		$lnr += 1

		If @error = -1 Then ExitLoop

		If StringInStr($line, 'STOP DBUG') Then $SKIPDBUG = True	;exclude debugging
		If StringInStr($line, 'START DBUG') Then $SKIPDBUG = False

		$res = StringRegExpReplace($line, '\s*;.*', '')	;strip comment and whitespace
		If StringRegExp($res, '(?i)Execute\(.*dbug\(.*\).*\)') Then Return	;Execute(dbug()) statement found -> debug line mode

		If StringRegExp($res, '(?i)^\s*select\s*$|^\s*switch ') Then $SKIPCASE = True	;no statements allowed between 'Select|Switch' and 'Case'

		If $res = '' Or StringRegExp($res, '^\s*#') Or $continued Or StringInStr($line, '@error') Or $SKIPDBUG Or $SKIPCASE Then	;empty, include, line-continued, @error, exclude or Case

		Else
			FileWriteLine($fOut, 'Execute(Dbug(' & $lnr & '))') ;write debug line
		EndIf

		If StringRegExp($res, '(?i)case ') Then $SKIPCASE = False	;statement allowed after Case
		$continued = StringRegExp($res, '.* _$')	;line is contineud

		$res = StringRegExp($line, $REG_WM_NOTIFY, 1)
		If IsArray($res) Then	;if WM_NOTIFY messages are registered, replace by NotifyHook and save original function name
			$DBGnotifyFun = $res[0]
			$line = 'GUIRegisterMsg($WM_NOTIFY, "_NotifyHook")'
		EndIf
		$res = StringRegExp($line, $REG_WM_COMMAND, 1)
		If IsArray($res) Then	;if WM_COMMAND messages are registered, replace by CommandHook and save original function name
			$DBGcommandFun = $res[0]
			$line = 'GUIRegisterMsg($WM_COMMAND, "_CommandHook")'
		EndIf

		FileWriteLine($fOut, $line)	;write original line
	Wend
	FileClose($fHnd)
	FileClose($fOut)

	$AutoItDir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt","InstallDir")
	$run = StringFormat('%s\\AutoIt3.exe DbugScript.au3 "%s" "%s" "%s" "%s"', $AutoItDir, @ScriptName, @ScriptDir, $DBGnotifyFun, $DBGcommandFun)

	$res = Run($run, @ScriptDir, default, 0x4)	;run the shadow script (with scriptname and -directory passed as arguments)
	Exit

EndFunc	;_CreateAndRun()

Func DBGShow()	;let's show the thing
	Local $res
	$res = WinGetClientSize($frmDBUG)
	WinMove($frmDBUG, '', @DesktopWidth - $res[0]-24, 24)
	WinActivate($frmDBUG)
	GUISetState(@SW_SHOW)
EndFunc

Func DBGExit()	;seen enough now
	_SCISendMessage($DBGhSci, 2045, 3)	;delete markers
	Exit
EndFunc

Execute(dbug(1))	;break at line 1, outcomment if it annoys you


