#Region == Anchors --[ Do not change any thing ]----
;0x6D958EEB6204EF535A2BA9A163AA79BB|sfsfsf|fsfsfsf
#EndRegion == Anchors --[ Do not change any thing ]----

;=======================================================
;SciTE Hopper  for test 3
;now you can jump to any line by 1 click !!
;By : Ashalshaikh : Ahmad Alshaikh"
;Thanks to :
;          CodeWizard Author : for SciTE Control Functions"
;          Koda(form designer) Authors
;          Melba23  :: now it's faster !!
;          wakillon
;          guinness
;tested with Autoit v3.3.6.1
;link : http://www.autoitscript.com/forum/index.php?showtopic=119544
;=======================================================
#include <GuiStatusBar.au3>
#include <SendMessage.au3>
#include <Array.au3>
#include <file.au3>
#include <GuiTreeView.au3>
#include <Crypt.au3>
#include <GUIConstantsEx.au3>

If Not ProcessExists('SciTE.exe') Then
	MsgBox(16, '', 'Run SciTE First')
	Exit
EndIf

$Pos = WinGetPos(WinGetHandle("[CLASS:SciTEWindow]"))
;Global $t_Pos = $Pos ;;; For Auto Move
$MainGUI = GUICreate("SciTE Hopper By : Ashalshaikh", 216, 447)
$MGStatus = _GUICtrlStatusBar_Create($MainGUI)
$about = GUICtrlCreateButton("About", 20, 2, 135, 25)
$searchbox = GUICtrlCreateInput('', 7, 47, 170, 20)
$refreshbtn = GUICtrlCreateButton("R", 188, 47, 20, 20)
;~ GUIRegisterMsg(0x004E, '_GUI_Notifly_WunPos')

If BitAND(WinGetState(WinGetHandle("[CLASS:SciTEWindow]"), ""), 16) = 0 And IsArray($Pos) Then
	WinMove($MainGUI, '', $Pos[0] + $Pos[2] - 250, $Pos[1] + 100)
EndIf

WinSetOnTop($MainGUI, '', 1)

$TreeView = _GUICtrlTreeView_Create($MainGUI, 8, 72, 200, 297)
_TreeViewWrite()
$GoThere = GUICtrlCreateButton("Go there", 17, 376, 135, 25)
$InsertAnchor = GUICtrlCreateButton("Insert Anchor", 17, 400, 135, 25)
GUISetState(@SW_SHOW)
;~ MsgBox(0, '', '')
Global $tmpFile, $tmpSize, $tmpCode, $tmpsearch, $tmp1search
Global $UserItem, $Funcitem, $Regionitem, $TVImage, $SearchNameArr
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $about
			MsgBox(64, "About", "SciTE Hopper  for test 2" & @CRLF & "now you can jump to any line by 1 click !!" & @CRLF & @CRLF & "By : Ashalshaikh : Ahmad Alshaikh" & @CRLF & @CRLF & "Thanks to :" & @CRLF & "          CodeWizard Author" & @CRLF & "          Koda(form designer) Authors" & @CRLF & "          Melba23  :: now it's faster !!" & @CRLF & "          wakillon" & @CRLF)


		Case $refreshbtn
			GUISetState(@SW_DISABLE, $MainGUI)
			_GUICtrlStatusBar_SetText($MGStatus, "Checking your file...please wait")
			_TreeViewWrite(1)
			GUISetState(@SW_ENABLE, $MainGUI)
			_GUICtrlStatusBar_SetText($MGStatus, "Done")
		Case -3
			Exit
		Case $GoThere
			$Code = _TreeViewGetSelectedCode($TreeView)
			If @error Then ContinueLoop
			_AnchorsMoveToAnc($tmpFile, $Code, @extended)
		Case $InsertAnchor
			Local $Code, $Name, $Des
			If _GetInfo($Code, $Name, $Des) = 0 Then ContinueLoop
			_AnchorsUserAncInsert($tmpFile, $Code, $Name, $Des)
	EndSwitch
	_Refresh()
	;----------------- check search box
	$tmp1search = $tmpsearch
	$tmpsearch = GUICtrlRead($searchbox)
	If $tmp1search <> $tmpsearch And StringLen($tmpsearch) > 1 Then
		_SearchforAnchor($tmpsearch)
		ContinueLoop
	EndIf
	;------------------- check select anchor
	$Code = _TreeViewGetSelectedCode($TreeView)
	If @error Then ContinueLoop
	If $Code = $tmpCode Then ContinueLoop
	$tmpCode = $Code
	_AnchorsMoveToAnc($tmpFile, $Code, @extended)
WEnd
Func _SearchforAnchor($searchfor)
	Local $itemicn = "shell32.dll"
	Local $itemicnidx = 221
	_GUIImageList_Destroy($TVImage)
	_GUICtrlTreeView_BeginUpdate($TreeView)
	_GUICtrlTreeView_DeleteAll($TreeView)
	$TVImage = _GUIImageList_Create(16, 16)
	_GUIImageList_AddIcon($TVImage, $itemicn, $itemicnidx)
	_GUIImageList_AddIcon($TVImage, "shell32.dll", 1) ; Results item
	_GUICtrlTreeView_SetNormalImageList($TreeView, $TVImage)
	$UserItem = _GUICtrlTreeView_Add($TreeView, 0, 'Results', 1, 1)
	For $i = 1 To $SearchNameArr[0]
		If StringInStr($SearchNameArr[$i], $searchfor) Then _GUICtrlTreeView_Add($TreeView, 0, $SearchNameArr[$i], 0, 0)
	Next
	_GUICtrlTreeView_EndUpdate($TreeView)
EndFunc   ;==>_SearchforAnchor
;~ Func _GUI_Notifly_WunPos($s, $SS, $rer, $er)
;~ 	Local $h = WinGetHandle("[CLASS:SciTEWindow]")
;~ 	Local $r_Pos = WinGetPos($h)
;~ 	If IsArray($r_Pos) And $r_Pos <> $t_Pos Then
;~ 		WinMove($MainGUI, '', $r_Pos[0] + $r_Pos[2] - 250, $r_Pos[1] + 100)
;~ 	EndIf
;~ 	$r_Pos = $t_Pos
;~ EndFunc   ;==>_GUI_Notifly_WunPos


Func _GetInfo(ByRef $Code, ByRef $Name, ByRef $Des)
	#Region ### START Koda GUI section ### Form=
	GUISetState(@SW_DISABLE, $MainGUI)
	$GetInfo = GUICreate("", 303, 115, Default, Default, Default, Default, $MainGUI)
	GUICtrlCreateLabel("Name : ", 8, 8, 41, 17)
	$NameInp = GUICtrlCreateInput("", 56, 8, 241, 21)
	GUICtrlCreateLabel("Description : ", 8, 36, 70, 17)
	$DesInp = GUICtrlCreateInput("", 80, 36, 217, 21)
	GUICtrlCreateLabel("Code :", 8, 64, 35, 17)
	$CodeInp = GUICtrlCreateInput("", 48, 64, 249, 21, 0x0800)
	$OkBut = GUICtrlCreateButton('Ok', 126.5, 90, 70, 20)

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case -3
				GUISetState(@SW_ENABLE, $MainGUI)
				GUIDelete($GetInfo)
				Return 0
			Case $OkBut

				$Code = GUICtrlRead($CodeInp)
				$Name = GUICtrlRead($NameInp)
				$Des = GUICtrlRead($DesInp)
				GUISetState(@SW_ENABLE, $MainGUI)
				GUIDelete($GetInfo)
				Return 1

		EndSwitch
		GUICtrlSetData($CodeInp, _CodeGen(GUICtrlRead($NameInp), GUICtrlRead($DesInp)))
	WEnd
EndFunc   ;==>_GetInfo

Func _CodeGen($Name, $Des)
	Return _Crypt_HashData($Name & $Des, $CALG_MD5)
EndFunc   ;==>_CodeGen



Func _Refresh($Flag = 0) ;  0 = Func Refresh :: 1 = Manual Refresh
	#Region ____ Reading File ----------------------
	$File = _SciTEGetFilePath()
	If @error Then
		_TreeViewWrite()
	EndIf
	If $tmpFile == $File And $tmpSize == FileGetSize($File) Then Return
	GUISetState(@SW_DISABLE, $MainGUI)
	_GUICtrlStatusBar_SetText($MGStatus, "Checking your file...please wait")
;~ 	Switch @error
;~ 		Case 1
;~ 			MsgBox(16, '', 'SciTE windows missing')
;~ 			ContinueLoop
;~ 		Case 2
;~ 			MsgBox(16, '', 'Please Save your file first')
;~ 			ContinueLoop
;~ 		Case 3
;~ 			MsgBox(16, '', 'Your file is messing')
;~ 			ContinueLoop
;~ 	EndSwitch
	$tmpFile = $File
	$tmpSize = FileGetSize($File)

	_TreeViewWrite(1)
	$SearchNameArr = _GetsearchNamesArr()
	GUISetState(@SW_ENABLE, $MainGUI)
	_GUICtrlStatusBar_SetText($MGStatus, "Done")
EndFunc   ;==>_Refresh

Func _GetsearchNamesArr()
	Local $res, $tmphdl, $tmptxt
	$tmphdl = _GUICtrlTreeView_GetFirstChild($TreeView, $UserItem)
	$tmptxt = _GUICtrlTreeView_GetText($TreeView, $tmphdl)
	$res = $tmptxt & '+'
	While 1
		$tmphdl = _GUICtrlTreeView_GetNextChild($TreeView, $tmphdl)
		If $tmphdl = 0 Then ExitLoop
		$tmptxt = _GUICtrlTreeView_GetText($TreeView, $tmphdl)
		$res &= $tmptxt & '+'
	WEnd
	$tmphdl = _GUICtrlTreeView_GetFirstChild($TreeView, $Funcitem)
	$tmptxt = _GUICtrlTreeView_GetText($TreeView, $tmphdl)
	$res &= $tmptxt & '+'

	While 1
		$tmphdl = _GUICtrlTreeView_GetNextChild($TreeView, $tmphdl)
		If $tmphdl = 0 Then ExitLoop
		$tmptxt = _GUICtrlTreeView_GetText($TreeView, $tmphdl)
		$res &= $tmptxt & '+'
	WEnd

	$tmphdl = _GUICtrlTreeView_GetFirstChild($TreeView, $Regionitem)
	$tmptxt = _GUICtrlTreeView_GetText($TreeView, $tmphdl)
	$res &= $tmptxt & '+'
	While 1
		$tmphdl = _GUICtrlTreeView_GetNextChild($TreeView, $tmphdl)
		If $tmphdl = 0 Then ExitLoop
		$tmptxt = _GUICtrlTreeView_GetText($TreeView, $tmphdl)
		$res &= $tmptxt
	WEnd
	Return StringSplit($res, '+')
EndFunc   ;==>_GetsearchNamesArr
Func _TreeViewWrite($emp = 0)
	_GUICtrlTreeView_BeginUpdate($TreeView)
	_GUICtrlTreeView_DeleteAll($TreeView)
	Local $usericn = "shell32.dll"
	Local $usericnidx = 170
	Local $funcicn = "shell32.dll"
	Local $funcicnidx = 214
	Local $regain = "shell32.dll"
	Local $regainidx = 36
	Local $itemicn = "shell32.dll"
	Local $itemicnidx = 221
	$TVImage = _GUIImageList_Create(16, 16)
	If $emp = 0 Then
		_GUIImageList_AddIcon($TVImage, $usericn, $usericnidx)
		_GUIImageList_AddIcon($TVImage, $funcicn, $funcicnidx)
		_GUIImageList_AddIcon($TVImage, $regain, $regainidx)

		_GUICtrlTreeView_SetNormalImageList($TreeView, $TVImage)
		$UserItem = _GUICtrlTreeView_Add($TreeView, 0, 'User (Custom)', 0, 0)
		$Funcitem = _GUICtrlTreeView_Add($TreeView, 0, "Functions", 1, 1)
		$Regionitem = _GUICtrlTreeView_Add($TreeView, 0, "#Regions", 2, 2)
		_GUICtrlTreeView_EndUpdate($TreeView)
		Return 0

	EndIf
	_GUIImageList_Destroy($TVImage)
	$TVImage = _GUIImageList_Create(16, 16)
	Local $FileLines
	_FileReadToArray(_SciTEGetFilePath(), $FileLines)

	Local $user = _AnchorsGetUserAnc($FileLines), $lasticonNum = 0
	_GUIImageList_AddIcon($TVImage, $usericn, $usericnidx)
	_GUICtrlTreeView_SetNormalImageList($TreeView, $TVImage)
	$UserItem = _GUICtrlTreeView_Add($TreeView, 0, 'User (Custom)', 0, 0)
	If Not @error And IsArray($user) Then
		For $i = 1 To $user[0][0]
			_GUIImageList_AddIcon($TVImage, $itemicn, $itemicnidx)
			$lasticonNum += 1
			_GUICtrlTreeView_AddChild($TreeView, $UserItem, $user[$i][1] & ' | ' & $user[$i][2] & ' | ' & $user[$i][0], $lasticonNum, $lasticonNum)
		Next
	EndIf
	;----------------------------------------------------------------
	$lasticonNum += 1
	_GUIImageList_AddIcon($TVImage, $funcicn, $funcicnidx)
	$Funcitem = _GUICtrlTreeView_Add($TreeView, 0, "Functions", $lasticonNum, $lasticonNum)
	Local $FuncAnchors = _AnchorsGetFuncAnc($FileLines)
	If IsArray($FuncAnchors) Then
		For $i = 1 To $FuncAnchors[0]
			$lasticonNum += 1
			_GUIImageList_AddIcon($TVImage, $itemicn, $itemicnidx)
			_GUICtrlTreeView_AddChild($TreeView, $Funcitem, $FuncAnchors[$i], $lasticonNum, $lasticonNum)
		Next
	EndIf
	;---------------------------------------------------------------
	$lasticonNum += 1
	_GUIImageList_AddIcon($TVImage, $regain, $regainidx)
	$Regionitem = _GUICtrlTreeView_Add($TreeView, 0, "#Regions", $lasticonNum, $lasticonNum)
	Local $RegionAnchors = _AnchorsGetRegionAnc($FileLines)
	If IsArray($RegionAnchors) Then
		For $i = 1 To $RegionAnchors[0]
			$lasticonNum += 1
			_GUIImageList_AddIcon($TVImage, $itemicn, $itemicnidx)
			_GUICtrlTreeView_AddChild($TreeView, $Regionitem, $RegionAnchors[$i], $lasticonNum, $lasticonNum)
		Next
	EndIf
	_GUICtrlTreeView_EndUpdate($TreeView)
EndFunc   ;==>_TreeViewWrite


Func _TreeViewGetSelectedCode($TreeView)
	Local $Text = _GUICtrlTreeView_GetText($TreeView, _GUICtrlTreeView_GetSelection($TreeView))
	If $Text = '' Then Return SetError(1)
	If $Text = 'User (Custom)' Then Return SetError(1)
	If $Text = 'Functions' Then Return SetError(1)
	If $Text = '#Regions' Then Return SetError(1)
	If $Text = 'Results' Then Return SetError(1)

	If StringRight($Text, 3) = ' #R' Then ;#Region Anchor
		Return SetExtended(2, StringTrimRight($Text, 3))
	ElseIf StringInStr($Text, ' | ') Then ;User Anchor
		Local $SS = StringSplit($Text, '|') ; ' | ' Space Between Info
;~ 		_ArrayDisplay ($SS)
		Return SetExtended(0, StringStripWS($SS[3], 4))
	Else ;Functions
		Return SetExtended(1, $Text)
	EndIf
EndFunc   ;==>_TreeViewGetSelectedCode



Func _AnchorsMoveToAnc($File, $Code, $Flag = 0) ;$Flag = 0 : User Anchor .. $Flag = 1 : Func Anchor .. $Flag = 2 : #Region Anchor
	If $Flag = 0 Then

		_SciTEFind('Anchor (' & StringStripWS($Code, 3) & ')') ; Good !!
	ElseIf $Flag = 1 Then
		Local $OP = FileOpen($File, 0)
		Local $FR = FileRead($OP), $sp
		If StringInStr($FR, 'Func ') And StringInStr($FR, ' ' & $Code) Then
			While 1
				$sp &= ' '
				If StringInStr($FR, 'Func' & $sp & $Code) Then
					_SciTEFind('Func' & $sp & $Code)
					FileClose($OP)
					ExitLoop
				EndIf
				If StringLen($sp) > 100 Then ExitLoop
			WEnd
		Else
			Return SetError(1, 0, 0) ;Not found anchor
		EndIf
;~ 		Local $OP = FileOpen($File, 0), $tLineCount = _FileCountLines($File), $ReturnArray, $tmpReturn = ''
;~ 		For $x = 1 To $tLineCount
;~ 			If StringInStr( FileReadLine($OP, $x) , $Code) And StringLeft(FileReadLine($tmpFile, $x), 5) = 'Func ' Then
;~ 				Local $x
;~ 				ExitLoop
;~ 			EndIf
;~ 		Next
;~ 		If $x - 1 = $tLineCount Then Return SetError(1, 0, 0) ;Not found anchor
;~ 		_SciTEGoToLine($x)
	ElseIf $Flag = 2 Then
		_SciTEFind('#Region ' & $Code) ; Good !!
	EndIf
	_GUICtrlStatusBar_SetText($MGStatus, 'jumped')
EndFunc   ;==>_AnchorsMoveToAnc


Func _AnchorsUserAncInsert($File, $Code, $Name, $Des)
	_SciTEInsertText(@CRLF & ';#---- Anchor (' & $Code & ') -----------------' & @CRLF)
	_SciTESave()
	If StringInStr(FileRead($File), '#Region == Anchors --[ Do not change any thing ]----' & @CRLF) Then ;Exist Old Anchors
		Local $OP = FileOpen($File, 0)
		Local $tLineCount = _FileCountLines($File)
		For $x = 1 To $tLineCount
			If FileReadLine($OP, $x) = '#Region == Anchors --[ Do not change any thing ]----' Then
				Local $tStartLine = $x
				ExitLoop
			EndIf
		Next
		If $x - 1 = $tLineCount Then
			FileClose($OP)
			Return SetError(1, 0, 0) ;There is Some Problem
		EndIf
		_SciTEGoToLine($tStartLine + 1)
		_SciTEInsertText(';' & $Code & '|' & $Name & '|' & $Des & @CRLF)
		_SciTESave()
		_AnchorsMoveToAnc($File, $Code, 0)
	Else
		Local $OP = FileOpen($File, 0), $tArray = ''
		_SciTEGoToLine(1)
		_SciTEInsertText('#Region == Anchors --[ Do not change any thing ]----' & @CRLF & ';' & $Code & '|' & $Name & '|' & $Des & @CRLF & '#EndRegion == Anchors --[ Do not change any thing ]----' & @CRLF)
		_SciTESave()
		_AnchorsMoveToAnc($File, $Code, 0)
	EndIf
EndFunc   ;==>_AnchorsUserAncInsert


;#---- Anchor (0x6D958EEB6204EF535A2BA9A163AA79BB) -----------------


Func _AnchorsGetRegionAnc($FileLines)
	Local $ReturnArray, $tmpReturn = '', $TmpLine

	For $x = 1 To $FileLines[0]
		$TmpLine = StringStripWS($FileLines[$x], 3)
		If $TmpLine = '#Region == Anchors --[ Do not change any thing ]----' Then ContinueLoop
		If StringLeft($TmpLine, 8) = '#Region ' Then
			$tmpReturn &= '|' & StringTrimLeft($TmpLine, 8) & ' #R'
		EndIf
	Next

	$ReturnArray = StringSplit(StringTrimLeft($tmpReturn, 1), '|')
;~ 	_ArrayDisplay ($ReturnArray)
	_ArrayDelete($ReturnArray, 0)
;~ 		_ArrayDisplay ($ReturnArray)
	_ArraySort($ReturnArray)
;~ 		_ArrayDisplay ($ReturnArray)
	_ArrayInsert($ReturnArray, 0, UBound($ReturnArray))
;~ 		_ArrayDisplay ($ReturnArray)
	If $ReturnArray[0] = 1 And $ReturnArray[1] = '' Then $ReturnArray[0] = 0
	Return $ReturnArray
EndFunc   ;==>_AnchorsGetRegionAnc

Func _AnchorsGetFuncAnc($FileLines)
	Local $ReturnArray, $tmpReturn = ''
	For $x = 1 To $FileLines[0]
		If StringLeft($FileLines[$x], 4) = 'Func' Then
			Local $SS = StringSplit(StringTrimLeft(StringStripWS($FileLines[$x], 4), 5), '(')
			If $SS[0] >= 1 Then $tmpReturn &= '|' & $SS[1]
		EndIf
	Next
	$ReturnArray = StringSplit(StringTrimLeft($tmpReturn, 1), '|')
	_ArrayDelete($ReturnArray, 0)
	_ArraySort($ReturnArray)
	_ArrayInsert($ReturnArray, 0, UBound($ReturnArray))
	If $ReturnArray[0] = 1 And $ReturnArray[1] = '' Then $ReturnArray[0] = 0
	Return $ReturnArray
EndFunc   ;==>_AnchorsGetFuncAnc

Func _AnchorsGetUserAnc($FileLines)
	Local $tArray = ''
	For $x = 1 To $FileLines[0]
		If $FileLines[$x] = '#Region == Anchors --[ Do not change any thing ]----' Then
			Local $tStartLine = $x
			ExitLoop
		EndIf
	Next
	If $x - 1 = $FileLines[0] Then
		Return SetError(1, 0, 0) ;There is no Anchors
	EndIf
	For $x = $tStartLine To $FileLines[0]
		If $FileLines[$x] = '#EndRegion == Anchors --[ Do not change any thing ]----' Then
			Local $tEndLine = $x
			ExitLoop
		EndIf
	Next
	If $x - 1 = $FileLines[0] Then
		Return SetError(2, 0, 0) ;There is no End  (Error)
	EndIf
	Local $ReturnArray[($tEndLine) - ($tStartLine)][3]
	Local $t = 1
	For $x = $tStartLine + 1 To $tEndLine - 1
		Local $SS = StringSplit($FileLines[$x], '|')
		$ReturnArray[$t][0] = StringStripWS(StringTrimLeft($SS[1], 1), 3)
		$ReturnArray[$t][1] = $SS[2]
		$ReturnArray[$t][2] = $SS[3]
		$t += 1
	Next
	$ReturnArray[0][0] = UBound($ReturnArray) - 1
	Return $ReturnArray
EndFunc   ;==>_AnchorsGetUserAnc



Func _SciTESave()
	_SciTEWinActivate()
	Send('^s')
EndFunc   ;==>_SciTESave

Func _SciTEWinActivate()
	Local $Scite_hwnd = WinGetHandle("[CLASS:SciTEWindow]")
	Do
		WinActivate($Scite_hwnd, '')
	Until WinActive($Scite_hwnd) <> 0
EndFunc   ;==>_SciTEWinActivate

Func _SciTEGetFilePath()
	Local $tTitle = WinGetTitle("[CLASS:SciTEWindow]"), $tSplitBy = '*'
	If @error Then Return SetError(1, 0, 0) ; Window Not Exists
	If StringInStr($tTitle, 'Untitled') Then Return SetError(2, 0, 0) ; Not File
	If StringInStr($tTitle, '- SciTE') Then $tSplitBy = '-'
	Local $SS = StringSplit($tTitle, $tSplitBy)
	If StringRight($SS[1], 1) = ' ' Then $SS[1] = StringTrimRight($SS[1], 1)
	If FileExists($SS[1]) Then Return $SS[1]
	Return SetError(3, 0, 0)
EndFunc   ;==>_SciTEGetFilePath

Func _SciTEFind($String)
	Local $Scite_hwnd = WinGetHandle("DirectorExtension")
	_SciTE_Send_Command(0, $Scite_hwnd, "find:" & $String)
EndFunc   ;==>_SciTEFind

Func _SciTEGoToLine($LineName)
	Local $Scite_hwnd = WinGetHandle("DirectorExtension")
	_SciTE_Send_Command(0, $Scite_hwnd, "goto:" & $LineName)
EndFunc   ;==>_SciTEGoToLine

Func _SciTEInsertText($DataToInsert)
	Opt("WinSearchChildren", 1)
	Local $Scite_hwnd = WinGetHandle("DirectorExtension")
	$DataToInsert = StringReplace($DataToInsert, "\", "\\")
	$DataToInsert = StringReplace($DataToInsert, @TAB, "\t")
	$DataToInsert = StringReplace($DataToInsert, @CRLF, "\r\n")
	_SciTE_Send_Command(0, $Scite_hwnd, "insert:" & $DataToInsert)
EndFunc   ;==>_SciTEInsertText

Func _SciTE_Send_Command($My_Hwnd, $Scite_hwnd, $sCmd)
	Local $CmdStruct = DllStructCreate('Char[' & StringLen($sCmd) + 1 & ']')
	If @error Then Return
	DllStructSetData($CmdStruct, 1, $sCmd)
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr')
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, StringLen($sCmd) + 1)
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($CmdStruct))
	$sss = _SendMessage($Scite_hwnd, 0x004A, $My_Hwnd, DllStructGetPtr($COPYDATA), 0, "hwnd", "ptr")
	$CmdStruct = 0
	Return $sss
EndFunc   ;==>_SciTE_Send_Command