#CS
	-- About ----------------------------
	SciTE UDF
	Control & Get Info
	20 September 2010
	By :
	Ashalshaikh --> Ahmad Alshaikh
	Two Functions By : Snippet Holder Authors

	-- Functions ------------------------
	## General :-
	_SciTEWinGetEditId
	_SciTEWinGetHandle
	_SciTESave
	_SciTE_Send_Command --> By : Snippet Holder Authors
	_SciTEGetEditPos
	_SciTEFind
	## File :-
	_SciTEIsFileSaved
	_SciTEIsFileOpened
	_SciTEGetCorrentFile
	## Tabs :-
	_SciTETabCommand
	_SciTETabsCount
	_SciTECorrentTabNum
	## Edit Control :-
	_SciTEEditSend
	_SciTEEditCommand
	_SciTEGoToLine
	_SciTEInsertText --> By : Snippet Holder Authors
	_SciTEEditGetCurrentLine
	_SciTEEditGetCurrentCol
#CE -------------------------------------
#include <SendMessage.au3>
;------------------------------------------------------------------
;### General ------------------------------------------------------
;------------------------------------------------------------------
Func _SciTEWinGetEditId()
	Return 'Scintilla1'
EndFunc   ;==>_SciTEWinGetEditId

Func _SciTEWinGetHandle()
	Return WinGetHandle("[CLASS:SciTEWindow]", "")
EndFunc   ;==>_SciTEWinGetHandle

#CS
	;~ _SciTE_Send_Command($sCmd)
	;~ $sCmd : http://www.scintilla.org/SciTEDirector.html
	;- Example:-
	;~ 	_SciTE_Send_Command(find:string)
	;~ By Snippet Holder
#CE
Func _SciTE_Send_Command($sCmd)
	Local $Scite_hwnd = WinGetHandle("DirectorExtension")
	Local $CmdStruct = DllStructCreate('Char[' & StringLen($sCmd) + 1 & ']')
	If @error Then Return
	DllStructSetData($CmdStruct, 1, $sCmd)
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr')
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, StringLen($sCmd) + 1)
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($CmdStruct))
	Local $sss = _SendMessage($Scite_hwnd, 0x004A, 0, DllStructGetPtr($COPYDATA), 0, "hwnd", "ptr")
	$CmdStruct = 0
	Return $sss
EndFunc   ;==>_SciTE_Send_Command

Func _SciTESave()
	Local $Scite_hwnd = _SciTEWinGetHandle()
	Do
		WinActivate($Scite_hwnd, '')
	Until WinActive($Scite_hwnd) <> 0
	Send('^s')
EndFunc   ;==>_SciTESave
;------------------------------------------------------------------
;### File ---------------------------------------------------------
;------------------------------------------------------------------
Func _SciTEGetCorrentFile()
	Local $tTitle = WinGetTitle(_SciTEWinGetHandle())
	Local $tSplitBy = '*'
	If StringInStr($tTitle, 'Untitled') Then
		SetError(2) ; No File
		Return ''
	EndIf
	If StringInStr($tTitle, '- SciTE') Then $tSplitBy = '-'
	Local $SS = StringSplit($tTitle, $tSplitBy)
	If StringRight($SS[1], 1) = ' ' Then $SS[1] = StringTrimRight($SS[1], 1)
	If FileExists($SS[1]) Then Return $SS[1]
	Return SetError(3, 0, 0)
EndFunc   ;==>_SciTEGetCorrentFile

Func _SciTEIsFileSaved()
	Local $tmp = StringInStr(WinGetTitle(_SciTEWinGetHandle()), '*')
	If Not @error Then $tmp = 1
	Return $tmp
EndFunc   ;==>_SciTEIsFileSaved

Func _SciTEIsFileOpened()
	Local $tmp = StringInStr(WinGetTitle(_SciTEWinGetHandle()), 'Untitled')
	If Not @error Then $tmp = 1
	Return $tmp
EndFunc   ;==>_SciTEIsFileOpened

;------------------------------------------------------------------
;### Tabs ---------------------------------------------------------
;------------------------------------------------------------------

#CS
	Sends a command to a Tab
	You can use :-
	"CurrentTab", ""           Returns the current Tab shown of a SysTabControl32
	"TabRight", ""             Moves to the next tab to the right of a SysTabControl32
	"TabLeft", ""              Moves to the next tab to the left of a SysTabControl32
#CE
Func _SciTETabCommand($command)
	Return ControlCommand(_SciTEWinGetHandle(), "", 'SciTeTabCtrl1', $command)
EndFunc   ;==>_SciTETabCommand

Func _SciTETabsCount()
	If StringInStr(WinGetTitle(_SciTEWinGetHandle()), ']') Then
		Local $SS = StringSplit(WinGetTitle(_SciTEWinGetHandle()), " ")
		Return StringTrimRight($SS[$SS[0]], 1)
	Else
		Return 1
	EndIf
EndFunc   ;==>_SciTETabsCount

Func _SciTECorrentTabNum()
	If StringInStr(WinGetTitle(_SciTEWinGetHandle()), '[') Then
		Local $SS = StringSplit(WinGetTitle(_SciTEWinGetHandle()), "[")
		Local $tSS = StringSplit($SS[2], ' ')
		Return $tSS[1]
	Else
		Return 1
	EndIf
EndFunc   ;==>_SciTECorrentTabNum

;------------------------------------------------------------------
;### Tabs ---------------------------------------------------------
;------------------------------------------------------------------

Func _SciTEGetEditPos()
	Local $PosSciTE = WinGetPos(_SciTEWinGetHandle())
	Local $PosSciTEEdt = ControlGetPos(_SciTEWinGetHandle(), "", _SciTEWinGetEditId())
	Local $returnArr[4]
	$returnArr[0] = $PosSciTEEdt[0] + $PosSciTE[0]
	$returnArr[1] = $PosSciTEEdt[1] + $PosSciTE[1] + 50
	$returnArr[2] = $PosSciTEEdt[2]
	$returnArr[3] = $PosSciTEEdt[3]
	Return $returnArr
EndFunc   ;==>_SciTEGetEditPos

Func _SciTEEditSend($String)
	Return ControlSend(_SciTEWinGetHandle(), "", _SciTEWinGetEditId(), $String)
EndFunc   ;==>_SciTEEditSend


#CS
	Sends a command to a Edit
	You Can use :-
	"GetCurrentLine", ""          Returns the line # where the caret is in an Edit
	"GetCurrentCol", ""           Returns the column # where the caret is in an Edit
	"GetCurrentSelection", ""     Returns name of the currently selected item in a ListBox or ComboBox
	"GetLineCount", ""            Returns # of lines in an Edit
	"GetLine", line#              Returns text at line # passed of an Edit
	"GetSelected", ""             Returns selected text of an Edit
#CE
Func _SciTEEditCommand($command, $opt = '')
	Return ControlCommand(_SciTEWinGetHandle(), "", _SciTEWinGetEditId(), $command, $opt)
EndFunc   ;==>_SciTEEditCommand

Func _SciTEFind($String)
	_SciTE_Send_Command("find:" & $String)
EndFunc   ;==>_SciTEFind

Func _SciTEGoToLine($LineN)
	_SciTE_Send_Command("goto:" & $LineN)
EndFunc   ;==>_SciTEGoToLine

Func _SciTEInsertText($DataToInsert)
	Opt("WinSearchChildren", 1)
	$DataToInsert = StringReplace($DataToInsert, "\", "\\")
	$DataToInsert = StringReplace($DataToInsert, @TAB, "\t")
	$DataToInsert = StringReplace($DataToInsert, @CRLF, "\r\n")
	_SciTE_Send_Command("insert:" & $DataToInsert)
EndFunc   ;==>_SciTEInsertText