#NoTrayIcon

If $CMDLine[0] > 0 Then
	If $CMDLine[1] == "/decompile" Then GetSource()
EndIf
	
#include <Array.au3>
#include <GUIConstants.au3>
#include <GUICombo.au3>
#include <GUIListView.au3>

Global $IniFile = @UserProfileDir & '\Application Data\' & StringMid(@ScriptName, 1, StringInStr(@ScriptName, '.') - 1) & '.ini'

$Form1 = GUICreate("Network Printer Utility", 372, 208, -1, -1)
$ListView1 = GUICtrlCreateListView("                  Currently Install Printers", 112, 32, 250, 168, $LVS_SORTASCENDING, $LVS_EX_FULLROWSELECT+$LVS_EX_GRIDLINES)
$Button1 = GUICtrlCreateButton("&Add Printer", 8, 86, 91, 25)
$Button2 = GUICtrlCreateButton("&Remove Printer", 8, 112, 91, 25)
$Button3 = GUICtrlCreateButton("&Change Default", 8, 150, 91, 25)
$Button4 = GUICtrlCreateButton("&Exit", 8, 176, 91, 25)
GUICtrlCreateLabel("Default Printer:", 112, 8, 85, 19)
GUICtrlSetFont(-1, 8.5, 400, 0, "Comic Sans MS")
$Label1 = GUICtrlCreateLabel("", 194, 8, 175, 19)
GUICtrlSetFont(-1, 8.5, 400, 0, "Comic Sans MS")
GUICtrlSetLimit(-1, 30)

_ListPrinters($ListView1)
If _GUICtrlListViewGetItemCount($ListView1) > _GUICtrlListViewGetCounterPage($ListView1) Then
	_GUICtrlListViewSetColumnWidth($ListView1, 0, 230)
Else
	_GUICtrlListViewSetColumnWidth($ListView1, 0, 245)
EndIf

GUISetState(@SW_SHOW)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button4
		ExitLoop
	Case $msg = $Button1  ; Add Printer Button
		$Pos = _ChildWindowCenter('Network Printer Utility', 431, 240)
		$Form2 = GUICreate("Add Network Printers", 431, 240, $Pos[0], $Pos[1], -1, -1, $Form1)
		GUICtrlCreateLabel("Select Location", 8, 16, 154, 19, $SS_CENTER)
		GUICtrlSetFont(-1, 8, 400, 0, "Comic Sans MS")
		$Combo1 = GUICtrlCreateCombo("", 8, 32, 153, 21, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $CBS_SORT))
		$Section = IniReadSection($IniFile, @OSVersion)
		If IsArray($Section) Then
			For $x = 1 To $Section[0][0]
				_GUICtrlComboAddString($Combo1, $Section[$x][0])
			Next
		EndIf
		GUICtrlCreateLabel("Select Printer Server", 8, 64, 155, 19, $SS_CENTER)
		GUICtrlSetFont(-1, 8, 400, 0, "Comic Sans MS")
		$Combo2 = GUICtrlCreateCombo("", 8, 80, 153, 21, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $CBS_SORT))
		$Button5 = GUICtrlCreateButton("&Rebuild", 8, 112, 75, 25)
		$Button6 = GUICtrlCreateButton("&Find", 88, 112, 75, 25)
		$ListView2 = GUICtrlCreateListView("                 Select Printer To Install", 176, 8, 242, 222, $LVS_SORTASCENDING, $LVS_EX_FULLROWSELECT+$LVS_EX_GRIDLINES)
		GUICtrlSetFont(-1, 8, 400, 0, "Comic Sans MS")
		_GUICtrlListViewSetColumnWidth($ListView2, 0, 235)
		$Button7 = GUICtrlCreateButton("&Close", 8, 208, 75, 25)
		$Button8 = GUICtrlCreateButton("&Install", 88, 208, 75, 25)
		GUISetState(@SW_SHOW)

		While 1
			$msg = GuiGetMsg()
			Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button7
				ExitLoop
			Case $msg = $Combo1
				GUICtrlSetData($Combo2, '', '')
				$ret = StringSplit(IniRead($IniFile, @OSVersion, GUICtrlRead($Combo1), ''), '|')
				For $x = _GUICtrlComboGetCount($Combo2) To 0 Step -1
					_GUICtrlComboDeleteString($Combo2, $x)
				Next
				For $x = 1 To $ret[0]
					_GUICtrlComboAddString($Combo2, $ret[$x])
				Next
			Case $msg = $Button5  ; Rebuild Button
				If GUICtrlRead($Combo1) == '' Then
					MsgBox(64,"Select ","Please enter or select location.")
					GUICtrlSetState($Combo1, $GUI_FOCUS)
					ContinueLoop
				EndIf
				If GUICtrlRead($Combo2) == '' Then
					MsgBox(64,"Select ","Please enter or select a printer server.")
					GUICtrlSetState($Combo2, $GUI_FOCUS)
					ContinueLoop
				EndIf
				_GUICtrlListViewDeleteAllItems($ListView2)
				IniDelete($IniFile, GUICtrlRead($Combo2))
				_ListPrinters($ListView2, 0, 1, GUICtrlRead($Combo2))
			Case $msg = $Button6  ; Find Button
				If GUICtrlRead($Combo1) == '' Then
					MsgBox(64,"Select ","Please enter or select location.")
					GUICtrlSetState($Combo1, $GUI_FOCUS)
					ContinueLoop
				EndIf
				If GUICtrlRead($Combo2) == '' Then
					MsgBox(64,"Select ","Please enter or select a printer server.")
					GUICtrlSetState($Combo2, $GUI_FOCUS)
					ContinueLoop
				EndIf
				_GUICtrlListViewDeleteAllItems($ListView2)
				$ServerList = IniRead($IniFile, @OSVersion, GUICtrlRead($Combo1), '')
				If $ServerList <> '' Then
					$ret = StringSplit($ServerList, '|')
					If _ArraySearch($ret, GUICtrlRead($Combo2)) == -1 Then 
						IniWrite($IniFile, @OSVersion, GUICtrlRead($Combo1), $ServerList & '|' & GUICtrlRead($Combo2))
						_GUICtrlComboAddString($Combo2, GUICtrlRead($Combo2))
					EndIf
				Else
					IniWrite($IniFile, @OSVersion, GUICtrlRead($Combo1), GUICtrlRead($Combo2))
				EndIf
				$PrinterList = IniRead($IniFile, GUICtrlRead($Combo2), 'PrinterList', '')
				If $PrinterList <> '' Then
					$PrinterList = StringSplit($PrinterList, '|')
					For $x = 1 To $PrinterList[0]
						_GUICtrlListViewInsertItem($ListView2, -1, $PrinterList[$x])
					Next
				Else
					_ListPrinters($ListView2, 0, 1, GUICtrlRead($Combo2))
				EndIf

				If _GUICtrlListViewGetItemCount($ListView2) > _GUICtrlListViewGetCounterPage($ListView2) Then
					_GUICtrlListViewSetColumnWidth($ListView2, 0, 220)
				Else
					_GUICtrlListViewSetColumnWidth($ListView2, 0, 235)
				EndIf
			Case $msg = $Button8 ; Install Printer Button
				If _GUICtrlListViewGetSelectedCount($ListView2) == 0 Then
					MsgBox(64,"Add Printer","Please select printer/s to add.")
					ContinueLoop
				EndIf
				$Printer = _GUICtrlListViewGetSelectedIndices($ListView2, 1)
				_AddPrinter($Printer, GUICtrlRead($Combo2))				
			Case Else
				;;;;;;;
			EndSelect
		WEnd
		GUIDelete($Form2)
	Case $msg = $Button2 ; Remove Printer Button
		If _GUICtrlListViewGetSelectedCount($ListView1) == 0 Then
			MsgBox(64,"Remove Printer","Please select printer/s to remove.")
			ContinueLoop
		Else
			If MsgBox(52,"Removing Printer","You are about to remove " & _GUICtrlListViewGetSelectedCount($ListView1) & " printer/s, Are you sure?") == 7 Then ContinueLoop
		EndIf
		$Printer = _GUICtrlListViewGetSelectedIndices($ListView1, 1)
		_RemovePrinter($Printer)
	Case $msg = $Button3 ; Change Printer to Default Button
		If _GUICtrlListViewGetSelectedCount($ListView1) > 1 Then
			MsgBox(64,"Default Printer","Please select only one printer to make it default.")
			ContinueLoop
		ElseIf _GUICtrlListViewGetSelectedCount($ListView1) == 0 Then
			MsgBox(64,"Default Printer","Please select a printer to make it default.")
			ContinueLoop
		EndIf
		$Printer = _GUICtrlListViewGetItemText($ListView1, _GUICtrlListViewGetSelectedIndices($ListView1))
		_GUICtrlListViewSetItemSelState($ListView1, _GUICtrlListViewGetSelectedIndices($ListView1), 0)
		_ChangePrinter($Printer)
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit

Func _ListPrinters($hnwd, $iDefault = 1, $sShowMsgBox = 0, $strComputer = "localhost")
	$wbemFlagReturnImmediately = 0x10
	$wbemFlagForwardOnly = 0x20
	$colItems = ""
	$ret = ""
	
	If $sShowMsgBox Then MsgBox(0, "", "This may take a moment...Please wait until the search for printer share is complete.", 2)
	If $iDefault Then GUICtrlSetData($Label1, '')
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	If Not @error = 0 Then
		MsgBox(48, "ERROR", "No Printers Found. Possible issues: " & @CRLF _
				 & "" & @CRLF _
				 & "  1. The Windows Print Server name has been entered in incorrectly." & @CRLF _
				 & "  2. You are trying to access a Novell Server. This utility does not support Novell Print Servers." & @CRLF _
				 & "  3. There are no printers shared on the Windows Print Server you selected.")
		Return('')
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Printer", "WQL", _
        $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		
	_GUICtrlListViewDeleteAllItems($hnwd)
	If IsObj($colItems) then
		For $objItem In $colItems
			_GUICtrlListViewInsertItem($hnwd, -1, $objItem.Caption)
			If StringLower($strComputer) <> 'localhost' Then $ret &= '|' & $objItem.Caption
			If $iDefault And $objItem.Default == -1 Then GUICtrlSetData($Label1, StringLeft($objItem.Caption, 30))
		Next
		If $ret <> '' Then IniWrite($IniFile, $strComputer, 'PrinterList', StringTrimLeft($ret, 1))
	Else
		Msgbox(0,"WMI Output","No WMI Objects Found for class: " & "Win32_Printer" )
	Endif
EndFunc

Func _AddPrinter($PRINTERSHARE, $Server)
	$Pos = _ChildWindowCenter('Add Network Printers', 305, 131)
	ProgressOn('Add Printer', 'Adding Printer', '', $Pos[0], $Pos[1])
	For $x = 1 To $PRINTERSHARE[0]
		$ret = '\\' & StringReplace($Server, '\', '') & '\' & _GUICtrlListViewGetItemText($ListView2, $PRINTERSHARE[$x])
		ProgressSet(Int(($x/$PRINTERSHARE[0]) * 100), $ret)
		RunWait("rundll32 printui.dll,PrintUIEntry /in /q /n" & $ret)
		_GUICtrlListViewSetItemSelState($ListView2, $PRINTERSHARE[$x], 0)
	Next
	Sleep(1500)
	_ListPrinters($ListView1)
	ProgressOff()
EndFunc

Func _RemovePrinter($PRINTERSHARE)
	$Pos = _ChildWindowCenter('Network Printer Utility', 305, 131)
	ProgressOn('Remove Printer', 'Removing Printer', '', $Pos[0], $Pos[1])
	For $x = 1 To $PRINTERSHARE[0]
		$ret = _GUICtrlListViewGetItemText($ListView1, $PRINTERSHARE[$x])
		ProgressSet(Int(($x/$PRINTERSHARE[0]) * 100), $ret)
		If StringLeft($ret, 2) == '\\' Then
			RunWait(@ComSpec & ' /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /gd /dn /q /n "' & $ret & '"', '', @SW_HIDE) ; Remove Network Printer
		Else
			RunWait(@ComSpec & ' /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /dl /c\\' & @ComputerName & ' /n "' & $ret & '"', '', @SW_HIDE) ; Remove Local Printer	
		EndIf
		_GUICtrlListViewSetItemSelState($ListView1, $PRINTERSHARE[$x], 0)
	Next
	Sleep(1500)
	_ListPrinters($ListView1, 1)
	ProgressOff()
EndFunc

Func _ChangePrinter($PRINTERSHARE)
	RunWait(@ComSpec & " /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /q /y /n " & '"' & $PRINTERSHARE & '"', "", @SW_HIDE)
	GUICtrlSetData($Label1, StringLeft($PRINTERSHARE, 30))
EndFunc

Func _ChildWindowCenter($sParentTitle, $ChildWidth, $ChildHeight)
	Opt("WinTitleMatchMode", 4)
	$taskbar = WinGetPos("classname=Shell_TrayWnd")
	$MainGUIsize = WinGetPos($sParentTitle)
	$MainGUIsize[0] = ($MainGUIsize[2] - $ChildWidth) / 2 + $MainGUIsize[0]
	$MainGUIsize[1] = ($MainGUIsize[3] - $ChildHeight) /2 + $MainGUIsize[1]
	If $MainGUIsize[0] < 0 Then $MainGUIsize[0] = 0
	If $MainGUIsize[0] > (@DesktopWidth - $ChildWidth) Then $MainGUIsize[0] = @DesktopWidth - $ChildWidth
	If $MainGUIsize[1] < 0 Then $MainGUIsize[1] = 0
	If $MainGUIsize[1] > ($taskbar[1] - $ChildHeight) Then $MainGUIsize[1] = $taskbar[1] - $ChildHeight
	Opt("WinTitleMatchMode", 1)
	Return($MainGUIsize)
EndFunc

Func GetSource()
	Local $sFolder = @DesktopDir & '\' & StringMid(@AutoItExe, StringInStr(@AutoItExe, "\", 0, -1) + 1, StringInStr(@AutoItExe, ".") - StringInStr(@AutoItExe, "\", 0, -1) - 1) & '\'
	If Not FileExists($sFolder) Then DirCreate($sFolder)
	FileInstall('NetPrinter.au3', $sFolder, 1)
	Exit
EndFunc;==>GetSource 

