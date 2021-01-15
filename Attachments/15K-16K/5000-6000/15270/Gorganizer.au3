;§+++++++++ The Gorganizer +++++++++§;
;§   A GUI-Organizer                §;
;§   Author: Kurt a.k.a. _Kurt      §;
;§++++++++++++++++++++++++++++++++++§;

#Include <GUIConstants.au3>
#Include <String.au3>

Local $guivar = "", $NewFile = "", $Controls = "", $MoreFunc = "", $FirstGo = 0
$GUI = GuiCreate("Gorganizer", 309, 115)
GuiCtrlCreateLabel("           Gorganizer                  ", 0, 10, 310, 20)
GUICtrlSetFont(-1,14,1000,6,"Lucida Handwriting")
GuiCtrlCreateLabel("Load File:", 6, 52, 54, 20)
GUICtrlSetFont(-1,9,1000,0,"Arial Bold")
$sFile = GuiCtrlCreateInput("", 62, 50, 170, 20)
$sBrowse = GuiCtrlCreateButton("Browse..", 235, 50, 70, 20)
GUICtrlSetFont(-1,8,300,0,"Arial Bold")
$Gorganize = GuiCtrlCreateButton("Gorganize", 50, 75, 190, 25)
GUICtrlSetFont(-1,10,1000,0,"Arial Bold")
GuiSetState()

While 1
	Sleep(10)
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $Gorganize
			GUICtrlSetData($Gorganize, "..Please Wait..")
			GUICtrlSetState($Gorganize, $GUI_DISABLE)
			GUICtrlSetState($sBrowse, $GUI_DISABLE)
			GUICtrlSetState($sFile, $GUI_DISABLE)
			$File = GUICtrlRead($sFile)
			$check = Check($File)
			If $check = 1 Then
				$New = @ScriptDir & "\output.au3"
				BeginGorganization($File, $New)
			Else
				MsgBox(0,"","There was an error gorganizing this script." & @CRLF & "Error Msg: " & @CRLF & $check)
			EndIf
			$FirstGo = 1
			GUICtrlSetData($Gorganize, "Gorganize")
			GUICtrlSetState($Gorganize, $GUI_ENABLE)
			GUICtrlSetState($sBrowse, $GUI_ENABLE)
			GUICtrlSetState($sFile, $GUI_ENABLE)
		Case $msg = $sBrowse
			$cFile = FileOpenDialog("Choose File..", @ScriptDir, "All (*.au3)")
			If $cFile <> "" Then GUICtrlSetData($sFile, $cFile)
	EndSelect
WEnd

Func Check($File)
	If $File= "" Then Return "Please choose a file"
	If NOT FileExists($File) Then Return "Please enter a valid filename"
	$aFile = FileRead($File)
	If NOT StringInStr($aFile, "GUICreate") Then Return "-GUICreate not found."
	$sbetween = _StringBetween($aFile, "GUICreate", "GUISetState")
	If NOT IsArray($sbetween) Then Return "-No String found between GUICreate & GUISetState."
	Return 1
EndFunc
Func BeginGorganization($File, $OutputFile)
	$aFile = FileRead($File)
	$CheckBetween = _StringBetween($aFile, "#region Gorganize", "#endregion Gorganize")
	If IsArray($CheckBetween) Then $aFile = $CheckBetween[0]
	$NewFile &= ";" & $File & @CRLF & _
				"#Include <GUIConstants.au3>" & @CRLF & _
				"#Include <String.au3>" & @CRLF
	$GrabVars = StringSplit($aFile, @CRLF)
	For $i = 1 To UBound($GrabVars)-1
		If StringLeft($GrabVars[$i],1) = ";" Then
		Else
			If StringInStr($GrabVars[$i], "#include") OR StringInStr($GrabVars[$i], "Local") OR StringInStr($GrabVars[$i], "Const") OR StringInStr($GrabVars[$i], "Global") OR StringInStr($GrabVars[$i], "Dim") Then
				$NewFile &= @CRLF & $GrabVars[$i]
			EndIf
		EndIf
	Next
	$test1 = StringRegExp($aFile, "(?i)(.*?) = GUICreate", 3)
	If NOT IsArray($test1) Then
		$aFile = StringReplace($aFile, "GUICreate(", "$GUI = GUICreate(", 1)
		$guivar = "$GUI"
	Else
		$guivar = $test1[0]
	EndIf
	Local $Line = 0
	For $i = 1 To UBound($GrabVars)-1
		If StringInStr($GrabVars[$i], $guivar & " = GUICreate(") Then
			$Line = $i
			ExitLoop
		EndIf
	Next
	$NewFile &= @CRLF & $GrabVars[$Line]
	$Rest = _StringBetween($aFile, $GrabVars[$Line], "GuiSetState(")
	$Rest = $Rest[0]
	$split = StringSplit($Rest, @CRLF)
	$GrabVars = StringSplit($aFile, @CRLF)
	For $i = 1 To UBound($GrabVars)-1
		If StringInStr($GrabVars[$i], "Local") OR StringInStr($GrabVars[$i], "Global") OR StringInStr($GrabVars[$i], "Dim") Then
			$NewFile &= @CRLF & $GrabVars[$i]
		EndIf
	Next
	For $i = 1 To UBound($split)-1
		If StringLeft($split[$i],1) = ";" Then
		Else
			If StringInStr($split[$i], "GUICtrlCreate") Then
				If NOT StringInStr($split[$i], "GUICtrlCreateMenu") Then
					If NOT StringInStr($split[$i], "GUICtrlCreateObj") Then
						$NewFile &= @CRLF & $split[$i]
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	$AllControls = StringRegExp($Rest, "(?i)(.*?) = GUICtrlCreate", 3)
	If $FirstGo = 0 Then
		$FunctionBetween = _StringBetween(FileRead(@ScriptFullPath), "#cs", "#ce")
		$Functions = StringReplace($FunctionBetween[1], "$sGUI", $guivar)
	Else
		$Functions = ""
	EndIf
	Local $ExitFunc = '					$oFile = FileRead(StringTrimLeft(FileReadLine(@ScriptFullPath,1),1))'
	For $i = 0 To UBound($AllControls)-1
		$ExitFunc &= @CRLF & _
			'					$pos1 = ControlGetPos(' & $guivar & ', "", ' & $AllControls[$i] & ')' & @CRLF & _
			'					$bet2 = _StringBetween($oFile, "' & $AllControls[$i] & ' = GUICtrlCreate", ")")' & @CRLF & _
			'					$bet0 = _StringBetween($bet2[0] & ")", ' & "'" & '",' & "'" & ', ")")' & @CRLF & _
			'					If NOT IsArray($bet0) Then $bet0 = _StringBetween($bet2[0] & ")", "' & "'" & ',", ")")' & @CRLF & _
			'					$new  = StringReplace("' & $AllControls[$i] & ' = GUICtrlCreate" & $bet2[0] & ")", $bet0[0], $pos1[0] & ", " & $pos1[1] & ", " & $pos1[2] & ", " & $pos1[3])' & @CRLF & _
			'					$oFile = StringReplace($oFile, "' & $AllControls[$i] & ' = GUICtrlCreate" & $bet2[0] & ")", $new)'
	Next
	$WhileWEnd = 'While 1' & @CRLF & _
				'	Sleep(10)' & @CRLF & _
				'	$msg = GUIGetMsg()' & @CRLF & _
				'	Select' & @CRLF & _
				'		Case $msg = $GUI_EVENT_CLOSE' & @CRLF & _
				'			If MsgBox(4, "", "Are you sure you have finished arranging your GUI?") = 6 Then' & @CRLF & _
				'				$oFile = StringTrimLeft(FileReadLine(@ScriptFullPath),1)' & @CRLF & _
				'				$Splitter = StringSplit($oFile, "\")' & @CRLF & _
				'				$cFile = StringReplace($oFile, $Splitter[UBound($Splitter)-1], "")' & @CRLF & _
				'				$Save = FileSaveDialog("Save..", $cFile, "All (*.au3)", 16, StringTrimRight($Splitter[UBound($Splitter)-1], 4) & " - Gorganized.au3")' & @CRLF & _
				'				If $Save <> "" Then' & @CRLF & _
				''&	 				$ExitFunc & @CRLF & _
				'					$Output = StringTrimRight(StringTrimLeft(FileReadLine(@ScriptFullPath,1),1), 4) & " - Gorganized.au3"' & @CRLF & _
				'					FileDelete($Output)' & @CRLF & _
				'					FileWrite($Output, $oFile)' & @CRLF & _
				'					While NOT FileExists($Output)' & @CRLF & _
				'						Sleep(5)' & @CRLF & _
				'					WEnd' & @CRLF & _
				'					FileDelete("' & $OutputFile & '")' & @CRLF & _
				'					_SelfDelete()' & @CRLF & _
				'					Exit' & @CRLF & _
				'				EndIf' & @CRLF & _
				'			EndIf' & @CRLF & _
				'		Case $msg = $Exit' & @CRLF & _
				'			If MsgBox(4,"","Are you sure you want to exit?") = 6 Then' & @CRLF & _
				'				_SelfDelete()' & @CRLF & _
				'				Exit' & @CRLF & _
				'			EndIf' & @CRLF & _
				'		Case $msg = $Drag' & @CRLF & _
				'			If BitAnd(GUICtrlRead($Drag),$GUI_CHECKED) = $GUI_CHECKED Then' & @CRLF & _
				'				GUICtrlSetState($Drag, $GUI_UNCHECKED)' & @CRLF & _
				'				For $i = 0 To UBound($SquareResizers)-1' & @CRLF & _
				'					GUICtrlSetPos($SquareResizers[$i], -88, -88, 5, 5)' & @CRLF & _
				'				Next' & @CRLF & _
				'				GUICtrlSetPos($DragOverlay, -99, -99, 1, 1)' & @CRLF & _
				'				$DragON = 0' & @CRLF & _
				'			Else' & @CRLF & _
				'				GUICtrlSetState($Drag, $GUI_CHECKED)' & @CRLF & _
				'				$DragON = 1' & @CRLF & _
				'			EndIf' & @CRLF & _
				'		Case $msg = $ToolTip' & @CRLF & _
				'			If BitAnd(GUICtrlRead($ToolTip),$GUI_CHECKED) = $GUI_CHECKED Then' & @CRLF & _
				'				GUICtrlSetState($ToolTip, $GUI_UNCHECKED)' & @CRLF & _
				'				$ToolTipON = 0' & @CRLF & _
				'			Else' & @CRLF & _
				'				GUICtrlSetState($ToolTip, $GUI_CHECKED)' & @CRLF & _
				'				$ToolTipON = 1' & @CRLF & _
				'			EndIf' & @CRLF & _
				'		Case $msg = $SquareResizers[1]' & @CRLF & _
				'			_GUICtrlResizeNE()' & @CRLF & _
				'		Case $msg = $SquareResizers[2]' & @CRLF & _
				'			_GUICtrlResizeNW()' & @CRLF & _
				'		Case $msg = $SquareResizers[3]' & @CRLF & _
				'			_GUICtrlResizeSE()' & @CRLF & _
				'		Case $msg = $SquareResizers[4]' & @CRLF & _
				'			_GUICtrlResizeSW()' & @CRLF & _
				'		Case $msg = $SquareResizers[5]' & @CRLF & _
				'			_GUICtrlResizeN()' & @CRLF & _
				'		Case $msg = $SquareResizers[6]' & @CRLF & _
				'			_GUICtrlResizeS()' & @CRLF & _
				'	EndSelect' & @CRLF & _
				'	If $DragON = 1 Then' & @CRLF & _
				'		_GUICtrlDrag($Hover)' & @CRLF & _
				'		_GUICtrlDragOverlay()' & @CRLF & _
				'	EndIf' & @CRLF & _
				'WEnd'
	$AddControls = 'Local $LastClick, $SquareResizers[7], $Hover = -1337, $DragON = 1, $ToolTipON = 1' & @CRLF & _
				'$DragOverlay = GUICtrlCreateLabel("", -99, -99, 1, 1, $SS_BLACKFRAME)' & @CRLF & _
				'$SquareResizers[1] = GUICtrlCreateLabel("", 0, 0, 5, 5)' & @CRLF & _
				'GUICtrlSetCursor(-1, 12)' & @CRLF & _
				'GUICtrlSetBkColor(-1, 0x000000)' & @CRLF & _
				'GUICtrlSetState(-1,$GUI_HIDE)' & @CRLF & _
				'$SquareResizers[2] = GUICtrlCreateLabel("", 0, 0, 5, 5)' & @CRLF & _
				'GUICtrlSetCursor(-1, 10)' & @CRLF & _
				'GUICtrlSetBkColor(-1, 0x000000)' & @CRLF & _
				'GUICtrlSetState(-1,$GUI_HIDE)' & @CRLF & _
				'$SquareResizers[3] = GUICtrlCreateLabel("", 0, 0, 5, 5)' & @CRLF & _
				'GUICtrlSetCursor(-1, 10)' & @CRLF & _
				'GUICtrlSetBkColor(-1, 0x000000)' & @CRLF & _
				'GUICtrlSetState(-1,$GUI_HIDE)' & @CRLF & _
				'$SquareResizers[4] = GUICtrlCreateLabel("", 0, 0, 5, 5)' & @CRLF & _
				'GUICtrlSetCursor(-1, 12)' & @CRLF & _
				'GUICtrlSetBkColor(-1, 0x000000)' & @CRLF & _
				'GUICtrlSetState(-1,$GUI_HIDE)' & @CRLF & _
				'$SquareResizers[5] = GUICtrlCreateLabel("", 0, 0, 5, 5)' & @CRLF & _
				'GUICtrlSetCursor(-1, 11)' & @CRLF & _
				'GUICtrlSetBkColor(-1, 0x000000)' & @CRLF & _
				'GUICtrlSetState(-1,$GUI_HIDE)' & @CRLF & _
				'$SquareResizers[6] = GUICtrlCreateLabel("", 0, 0, 5, 5)' & @CRLF & _
				'GUICtrlSetCursor(-1, 11)' & @CRLF & _
				'GUICtrlSetBkColor(-1, 0x000000)' & @CRLF & _
				'GUICtrlSetState(-1,$GUI_HIDE)' & @CRLF & _
				'$Config = GUICtrlCreateMenu("Config")' & @CRLF & _
				'$Drag = GUICtrlCreateMenuItem("Drag Controls", $Config)' & @CRLF & _
				'GUICtrlSetState(-1, $GUI_CHECKED)' & @CRLF & _
				'$ToolTip = GUICtrlCreateMenuItem("ToolTip Coordinates", $Config)' & @CRLF & _
				'GUICtrlSetState(-1, $GUI_CHECKED)' & @CRLF & _
				'$Exit = GUICtrlCreateMenuItem("Exit", $Config)' & @CRLF & _
				"GuiSetState()"
	Local $AddFuncLines = ""
	$AddFuncs = _StringBetween($aFile, "Func ", "EndFunc")
	If IsArray($AddFuncs) Then
		For $i = 0 To UBound($AddFuncs)-1
			$AddFuncLines &= @CRLF & "Func " & $AddFuncs[$i] & "EndFunc" & @CRLF
		Next
	EndIf
	$NewFile &= @CRLF & $AddControls & @CRLF & $WhileWEnd & @CRLF & $AddFuncLines & @CRLF & $Functions
	FileDelete($OutputFile)
	FileWrite($OutputFile, $NewFile)
	While FileExists($OutputFile) = 0
		Sleep(50)
	WEnd
	Run(@AutoItExe & ' /AutoIt3ExecuteScript ' & FileGetShortName($OutputFile))
	Exit
EndFunc

#cs
Func _GUICtrlDragOverlay()
	$cursor = GUIGetCursorInfo()
	If IsArray($cursor) Then
		If $cursor[4] <> 0 Then
			If $cursor[4] <> $SquareResizers[1] AND $cursor[4] <> $SquareResizers[2] AND $cursor[4] <> $SquareResizers[3] AND $cursor[4] <> $SquareResizers[4] AND $cursor[4] <> $SquareResizers[5] AND $cursor[4] <> $SquareResizers[6] Then
				$pos = ControlGetPos($sGUI, "", $cursor[4])
				$pos2 = ControlGetPos($sGUI, "", $DragOverlay)
				If $pos[0] <> $pos2[0] AND $pos[1] <> $pos2[1] AND $pos[2] <> $pos2[2] AND $pos[3] <> $pos2[3] Then
					GUICtrlSetPos($DragOverlay, $pos[0], $pos[1], $pos[2], $pos[3])
					GUICtrlSetState($DragOverlay, $GUI_SHOW)
					GUICtrlSetState($cursor[4], $GUI_DISABLE)
					$Hover = $cursor[4]
				EndIf
			EndIf
		Else
			GUICtrlSetState($Hover, $GUI_ENABLE)
			$Hover = -1337
			GUICtrlSetPos($DragOverlay, -99, -99, 1, 1)
		EndIf
	EndIf
EndFunc

Func _GUICtrlResizeS()
	GUISetCursor(11)
	GUICtrlSetCursor($LastClick, 11)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($sGUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1], $pos[2], ($cursor[1]-$pos[1]))
		If $ToolTipON = 1 Then ToolTip($pos[0] & "," & $pos[1] & "," & $pos[2] & "," & $cursor[1]-$pos[1])
		$pos = ControlGetPos($sGUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0
	ToolTip("")
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeN()
	GUISetCursor(11)
	GUICtrlSetCursor($LastClick, 11)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($sGUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1]-($pos[1]-$cursor[1]), $pos[2], $pos[3]+($pos[1]-$cursor[1]))
		If $ToolTipON = 1 Then ToolTip($pos[0] & "," & $pos[1]-($pos[1]-$cursor[1]) & "," & $pos[2] & "," & $pos[3]+($pos[1]-$cursor[1]))
		$pos = ControlGetPos($sGUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
	Until $cursor[2] = 0
	ToolTip("")
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeSE()
	GUISetCursor(10)
	GUICtrlSetCursor($LastClick, 10)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($sGUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0]-($pos[0]-$cursor[0]), $pos[1], ($pos[0]-$cursor[0])+$pos[2], ($cursor[1]-$pos[1]))
		If $ToolTipON = 1 Then ToolTip($pos[0]-($pos[0]-$cursor[0]) & "," & $pos[1] & "," & ($pos[0]-$cursor[0])+$pos[2] & "," & ($cursor[1]-$pos[1]))
		$pos = ControlGetPos($sGUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0
	ToolTip("")
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeNW()
	GUISetCursor(10)
	GUICtrlSetCursor($LastClick, 10)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($sGUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1]-($pos[1]-$cursor[1]), $cursor[0]-$pos[0], $pos[3]+($pos[1]-$cursor[1]))
		If $ToolTipON = 1 Then ToolTip($pos[0] & "," & $pos[1]-($pos[1]-$cursor[1]) & "," & $cursor[0]-$pos[0] & "," & $pos[3]+($pos[1]-$cursor[1]))
		$pos = ControlGetPos($sGUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0 
	ToolTip("")
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeNE()
	GUISetCursor(12)
	GUICtrlSetCursor($LastClick, 12)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($sGUI, "", $LastClick)
	$XStayPos = $pos[0]+$pos[2]
	$YStayPos = $pos[1]+$pos[3]
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		If $cursor[0] > $XStayPos Then $cursor[0] = $XStayPos
		If $cursor[1] > $YStayPos Then $cursor[1] = $YStayPos
		GUICtrlSetPos($LastClick, $cursor[0], $cursor[1], $XStayPos-$cursor[0], $YStayPos-$cursor[1])
		If $ToolTipON = 1 Then ToolTip($cursor[0] & "," & $cursor[1] & "," & $XStayPos-$cursor[0] & "," & $YStayPos-$cursor[1])
		$pos = ControlGetPos($sGUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[1], $pos[0]-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0
	ToolTip("")
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlResizeSW()
	GUISetCursor(12)
	GUICtrlSetCursor($LastClick, 12)
	GUICtrlSetState($DragOverlay, $GUI_HIDE)
	$pos = ControlGetPos($sGUI, "", $LastClick)
	Do
		Sleep(5)
		$cursor = GUIGetCursorInfo()
		GUICtrlSetPos($LastClick, $pos[0], $pos[1], $cursor[0]-$pos[0], $cursor[1]-$pos[1])
		If $ToolTipON = 1 Then ToolTip($pos[0] & "," & $pos[1] & "," & $cursor[0]-$pos[0] & "," & $cursor[1]-$pos[1])
		$pos = ControlGetPos($sGUI, "", $LastClick)
		GUICtrlSetPos($SquareResizers[4], ($pos[0]+$pos[2])-2, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[2], ($pos[0]+$pos[2])-2, $pos[1]-5)
		GUICtrlSetPos($SquareResizers[3], $pos[0]-3, $pos[1]+$pos[3])
		GUICtrlSetPos($SquareResizers[5], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]-5)
		GUICtrlSetPos($SquareResizers[6], (($pos[0]+$pos[2])-($pos[2]/2)), $pos[1]+$pos[3])
	Until $cursor[2] = 0
	ToolTip("")
	GUICtrlSetCursor($LastClick, 2)
	GUISetCursor(2)
EndFunc

Func _GUICtrlDrag($Control, $GridScale = 0)
	Select
		Case $msg = $DragOverlay
			For $i = 0 To UBound($SquareResizers)-1
				GUICtrlSetState($SquareResizers[$i], $GUI_HIDE)
			Next
			GUICtrlSetState($DragOverlay, $GUI_HIDE)
			GUISetCursor(9)
			$pos = ControlGetPos($sGUI, "", $Control)
			$cursor = GUIGetCursorInfo()
			$XStayPos = $cursor[0]-$pos[0]
			$YStayPos = $cursor[1]-$pos[1]
			Do
				Sleep(5)
				$cursor = GUIGetCursorInfo()
				$sX = $cursor[0]-$XStayPos
				$sY = $cursor[1]-$YStayPos
				If $GridScale <> 0 Then
					$sX = Round($sX/$GridScale)*$GridScale
					$sY = Round($sY/$GridScale)*$GridScale
				EndIf
				GUICtrlSetPos($Control, $sX, $sY)
				If $ToolTipON = 1 Then ToolTip($sX & "," & $sY & "," & $pos[2] & "," & $pos[3])
			Until $cursor[2] = 0
			ToolTip("")
			GUISetCursor(2)
			GUICtrlSetPos($SquareResizers[1], $sX-3, $sY-5)
			GUICtrlSetPos($SquareResizers[2], ($sX+$pos[2])-2, $sY-5)
			GUICtrlSetPos($SquareResizers[3], $sX-3, $sY+$pos[3])
			GUICtrlSetPos($SquareResizers[4], ($sX+$pos[2])-2, $sY+$pos[3])
			GUICtrlSetPos($SquareResizers[5], (($sX+$pos[2])-($pos[2]/2)), $sY-5)
			GUICtrlSetPos($SquareResizers[6], (($sX+$pos[2])-($pos[2]/2)), $sY+$pos[3])
			For $i = 0 To UBound($SquareResizers)-1
				GUICtrlSetState($SquareResizers[$i], $GUI_SHOW)
			Next
			$pos = ControlGetPos($sGUI, "", $cursor[4])
			GUICtrlSetPos($DragOverlay, $pos[0]-1, $pos[1]-1, $pos[2]+2, $pos[3]+2)
			GUICtrlSetState($DragOverlay, $GUI_SHOW)
			$LastClick = $Control
	EndSelect
EndFunc

Func _SelfDelete($iDelay = 0)
    Local $sCmdFile
    FileDelete(@TempDir & "\scratch.bat")
    $sCmdFile = 'ping -n ' & $iDelay & '127.0.0.1 > nul' & @CRLF _
            & ':loop' & @CRLF _
            & 'del "' & @ScriptFullPath & '"' & @CRLF _
            & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
            & 'del ' & @TempDir & '\scratch.bat'
    FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
    Run(@TempDir & "\scratch.bat", @TempDir, @SW_HIDE)
EndFunc
#ce