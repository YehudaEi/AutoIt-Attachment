#Region - TimeStamp
; 2012-04-20 13:25:33
#EndRegion - TimeStamp
#Include <Array.au3>
#Include <File.au3>
#Include <GUIConstantsEx.au3>
#Include <WindowsConstants.au3>

;===============================================================================
; Script Name......: Install_VarGetTip.au3
; Description......: Installation or Update "VarGetTip.lua"
; .................: Inserts required entries in SciTEUser.properties
; Requirement(s)...: in script folder:    - VarGetTip.lua
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================

ConsoleWrite('+> Start: Install VarGetTip    ' & @HOUR & ':' & @MIN & ':' &  @SEC & @CRLF & @CRLF)
Global $sPathAutoIt = StringLeft(@AutoItExe, StringInStr(@AutoItExe, '\', 1, -1))
Global $sPathLua = $sPathAutoIt & 'SciTE\Lua\'

; ==== install Lua-Script ====
If Not FileExists(@ScriptDir & '\VarGetTip.lua') Then Exit MsgBox(262192, 'Error', 'The file "VarGetTip.lua" is not included in script directory!')

If Not FileExists($sPathLua & 'VarGetTip.lua') Then
	FileCopy(@ScriptDir & '\VarGetTip.lua', $sPathLua & 'VarGetTip.lua')
	ConsoleWrite('-> Install: VarGetTip.lua' & @CRLF)
Else
	FileCopy(@ScriptDir & '\VarGetTip.lua', $sPathLua & 'VarGetTip.lua', 1)
	ConsoleWrite('-> Update: VarGetTip.lua' & @CRLF)
EndIf

; ==== Entries in User settings: ====
; search free command number
Global $sPathProps = @UserProfileDir & '\SciTEUser.properties'
Global $aCommandNum = _GetUsed($sPathProps)


; Check if VarGetTip always installed, get command number
Global $iNr = -1, $aRet = StringRegExp(FileRead($sPathProps), '[^#]command\.(\d+)\.\*\.au3=dofile\s+\$\(SciteDefaultHome\)/LUA/VarGetTip\.lua', 3)
If IsArray($aRet) Then
	$iNr = $aRet[0]
	ConsoleWrite('>> Found: entry for VarGetTip (command number: ' & $iNr & ')' & @CRLF)
EndIf

Global $sFree = '', $aFree[2] = [0,-1], $sCmdFound

If $iNr = -1 Then
	; search first in user scope (Cmd-No 35 bis 49)
	If $aCommandNum[0] > 0 Then
		For $i = 35 To 49
			$fFound = False
			For $j = 1 To $aCommandNum[0]
				If $aCommandNum[$j] = $i Then
					$fFound = True
					ExitLoop
				EndIf
			Next
			If Not $fFound Then $sFree &= $i & ' '
		Next
		If $sFree <> '' Then $aFree = StringSplit(StringTrimRight($sFree, 1), ' ')
	EndIf

	; if no free numbers in user scope: check for unused numbers from tools in au3.properties (Cmd-No 0 bis 34)
	If $aFree[0] = 0 Then
		$aCommandNum = _GetUsed($sPathAutoIt & 'SciTE\properties\au3.properties')
		If $aCommandNum[0] > 0 Then
			For $i = 0 To 34
				$fFound = False
				For $j = 1 To $aCommandNum[0]
					If $aCommandNum[$j] = $i Then
						$fFound = True
						ExitLoop
					EndIf
				Next
				If Not $fFound Then $sFree &= $i & ' '
			Next
			If $sFree <> '' Then
				$aFree = StringSplit(StringTrimRight($sFree, 1), ' ')
				MsgBox(262208, 'Note', 'There are only free command numbers from currently unused tools.' & @CRLF & _
							 'When installing a new AutoIt version you must consider this.')
			EndIf
		EndIf
		If $aFree[0] = 0 Then
			$aFree[1] = 99
			$sCmdFound = '!> No free command numbers available! Installation is continued with number "99". User interaction required!'
		Else
			$sCmdFound = '>> Found: free command number in Program scope (' & $aFree[1] & ')'
		EndIf
	Else
		$sCmdFound = '>> Found: free command number in User scope (' & $aFree[1] & ')'
	EndIf
EndIf

; search for user context menu entry, if VarGetTip exists - get position
; search CallTip option
Global $StringHotKey = '', $InsIndex, $f1 = False, $aVGT[5][2], $fContext = False, $fAddContext = False
Global $sContext, $IndxContext = -1, $iCallTip, $aFile, $sOutCon, $fContextBreak = False, $fContextInBreak = False
_FileReadToArray($sPathProps, $aFile)

For $i = 1 To $aFile[0]
	If Not $f1 And StringInStr($aFile[$i], '# END => DO NOT CHANGE ANYTHING BEFORE THIS LINE  #-#-#-#-#-#') Then
		$InsIndex = $i +1
		$f1 = True
	EndIf
	If StringLeft($aFile[$i], 1) <> '#' Then
		If $iNr > 0 Then
			If StringInStr($aFile[$i], 'command.' & $iNr) Then
				$aVGT[0][0] = $i
				$aVGT[0][1] = $aFile[$i]
			ElseIf StringInStr($aFile[$i], 'command.name.' & $iNr) Then
				$aVGT[1][0] = $i
				$aVGT[1][1] = $aFile[$i]
			ElseIf StringInStr($aFile[$i], 'command.mode.' & $iNr) Then
				$aVGT[2][0] = $i
				$aVGT[2][1] = $aFile[$i]
			ElseIf StringInStr($aFile[$i], 'command.shortcut.' & $iNr) Then
				$aVGT[3][0] = $i
				$aVGT[3][1] = $aFile[$i]
			ElseIf StringInStr($aFile[$i], 'Variables.Tip.CallTip.*.au3') Then
				$aVGT[4][0] = $i
				$aVGT[4][1] = $aFile[$i]
			EndIf
		EndIf
		If StringInStr($aFile[$i], 'user.context.menu') Then
			$sContext = $aFile[$i]
			$IndxContext = $i
			$sOutCon = '>> Found: user.context.menu'
			If StringRight($aFile[$i], 1) = '\' Then
				$fContextBreak = True
				$j = $i
				Do
					If StringInStr($aFile[$j], '11' & $iNr) Then
						$fContext = True
						$fContextInBreak = True
						$sContext = $aFile[$j]
						$IndxContext = $j
						$sOutCon &= ' (with entry for VarGetTip)'
						ExitLoop
					EndIf
					$j += 1
				Until $j > $aFile[0] Or StringRight($aFile[$j-1], 1) <> '\'
				If Not $fContextInBreak Then $sOutCon &= ' (without entry for VarGetTip)'
			Else
				If StringInStr($sContext, '11' & $iNr) Then
					$fContext = True
					$sOutCon &= ' (with entry for VarGetTip)'
				Else
					$sOutCon &= ' (without entry for VarGetTip)'
				EndIf
			EndIf
			ConsoleWrite($sOutCon & @CRLF)
		EndIf
	EndIf
Next

If $aVGT[0][1] = '' Then
	ConsoleWrite($sCmdFound & @CRLF)
	If $aFree[1] = 99 Then
		MsgBox(262192, 'Error', 'There are no free command numbers available.' & @CRLF & _
				'The installation is continued with number "99".' & @CRLF & _
				'But this number is not usually. Valid are numbers up to "49".' & @CRLF & _
				'Please make corrections by hand in "' & $sPathProps & '"!')
	EndIf
EndIf

; GUI for installation settings
$hGui = GUICreate("SciTEUser.properties - Entries", 520, 330, -1, -1, $WS_CAPTION)

GUICtrlCreateGroup("  Install parameter  ", 15, 15, 490, 255)
GUICtrlCreateGroup("  CallTip option  ", 32, 37, 450, 57)
$cbCallTip = GUICtrlCreateCheckbox("   Show Variables Tip as CallTip  ( unchecked: Output to console )", 48, 61, 400, 17)
If $aVGT[4][1] <> '' Then
	If StringRight($aVGT[4][1], 1) = '1' Then
		GUICtrlSetState($cbCallTip, $GUI_CHECKED)
	Else
		GUICtrlSetState($cbCallTip, $GUI_UNCHECKED)
	EndIf
EndIf
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("  Context menu  ", 32, 111, 450, 65)
$cbContext = GUICtrlCreateCheckbox("   Call Variables Tip also from context menu", 48, 135, 300, 24)
If $fContext Then GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("  HotKey  ", 32, 193, 450, 57)
$cbCtrl = GUICtrlCreateCheckbox(" Ctrl", 48, 217, 49, 17)
$cbAlt = GUICtrlCreateCheckbox(" Alt", 113, 217, 49, 17)
$cbShift = GUICtrlCreateCheckbox(" Shift", 176, 217, 65, 17)
$cbWin = GUICtrlCreateCheckbox(" Win", 240, 217, 57, 17)
GUICtrlCreateLabel("Char/Number", 304, 220, 90, 17)
$inChar = GUICtrlCreateInput("", 400, 214, 41, 24)
If $aVGT[3][1] <> '' Then
	If StringInStr($aVGT[3][1], 'Ctrl')  Then GUICtrlSetState($cbCtrl,  $GUI_CHECKED)
	If StringInStr($aVGT[3][1], 'Alt')   Then GUICtrlSetState($cbAlt,   $GUI_CHECKED)
	If StringInStr($aVGT[3][1], 'Shift') Then GUICtrlSetState($cbShift, $GUI_CHECKED)
	If StringInStr($aVGT[3][1], 'Win')   Then GUICtrlSetState($cbWin,   $GUI_CHECKED)
	GUICtrlSetData($inChar, StringRight($aVGT[3][1], 1))
EndIf
$btOK = GUICtrlCreateButton("OK", 440, 290, 65, 25)
GUISetState(@SW_SHOW)

While 1
	Switch GUIGetMsg()
		Case $btOK
			If BitAND(GUICtrlRead($cbCtrl),  $GUI_CHECKED) Then $StringHotKey &= '+Ctrl'
			If BitAND(GUICtrlRead($cbAlt),   $GUI_CHECKED) Then $StringHotKey &= '+Alt'
			If BitAND(GUICtrlRead($cbShift), $GUI_CHECKED) Then $StringHotKey &= '+Shift'
			If BitAND(GUICtrlRead($cbWin),   $GUI_CHECKED) Then $StringHotKey &= '+Win'
			$StringHotKey = StringTrimLeft($StringHotKey, 1)
			$StringHotKey &= '+' & GUICtrlRead($inChar)
			$iCallTip = 0
			If BitAND(GUICtrlRead($cbCallTip),$GUI_CHECKED) Then $iCallTip = 1
			If BitAND(GUICtrlRead($cbContext),$GUI_CHECKED) Then $fAddContext = True
			If $iNr > 0 Then $aFree[1] = $iNr
			If $sContext = '' And $fAddContext And $iNr = -1 Then
				$aVGT[4][1] &= @CRLF & 'user.context.menu=||Variables Tip|11' & $aFree[1] & '|'
				ConsoleWrite('-> Create: User.Context.Menu (Entry: VarGetTip)'& @CRLF)
			ElseIf $sContext <> '' And Not $fAddContext And $fContext Then
				If $fContextInBreak Then
					$aFile[$IndxContext] = StringReplace($sContext, 'Variables Tip|11' & $aFree[1] & '|', '')
				Else
					$aFile[$IndxContext] = StringReplace($sContext, '||Variables Tip|11' & $aFree[1] & '|', '')
				EndIf
				ConsoleWrite('-> Delete Entry: User.Context.Menu (Entry: VarGetTip)'& @CRLF)
			ElseIf $sContext <> '' And $fAddContext And Not $fContext Then
				If $fContextBreak Then
					Local $sReplace = 'Variables Tip|11' & $aFree[1] & '|'
					If StringRight($aFile[$IndxContext], 4) = '=||\' Then
						$sReplace &= '\'
					ElseIf StringRight($aFile[$IndxContext], 2) = '=\' Then
						$sReplace = '||' & $sReplace & '\'
					ElseIf StringRight($aFile[$IndxContext], 1) = '\' Then
						$sReplace &= '\'
					EndIf
					$aFile[$IndxContext] = StringReplace($aFile[$IndxContext], '\', $sReplace)
				Else
					$aFile[$IndxContext] &= '||Variables Tip|11' & $aFree[1] & '|'
				EndIf
				ConsoleWrite('-> Add Entry: User.Context.Menu (Entry: VarGetTip)'& @CRLF)
			EndIf
			If $aVGT[0][1] <> '' Then
				$aVGT[3][1] = 'command.shortcut.' & $aFree[1] & '.*.au3=' & $StringHotKey
				$aVGT[4][1] = 'Variables.Tip.CallTip.*.au3=' & $iCallTip
				For $i = 0 To 4
					$aFile[$aVGT[$i][0]] = $aVGT[$i][1]
				Next
				ConsoleWrite('-> Update: HotKey (' & $StringHotKey & ')' & @CRLF)
				ConsoleWrite('-> Update: Variables.Tip.CallTip (' & $iCallTip & ')' & @CRLF)
			EndIf
			ExitLoop
	EndSwitch
WEnd
GUIDelete($hGui)

; create string with command-entries
Global $sCmdWrite = _
'# Variables Tip by BugFix' & @CRLF & _
'command.name.' & $aFree[1] & '.*.au3=Variables Tip' & @CRLF & _
'command.' & $aFree[1] & '.*.au3=dofile $(SciteDefaultHome)/LUA/VarGetTip.lua' & @CRLF & _
'command.mode.' & $aFree[1] & '.*.au3=subsystem:lua,savebefore:no' & @CRLF & _
'command.shortcut.' & $aFree[1] & '.*.au3=' & $StringHotKey & @CRLF & _
'Variables.Tip.CallTip.*.au3=' & $iCallTip
If $sContext = '' And $fAddContext Then $sCmdWrite &= @CRLF & 'user.context.menu=||Variables Tip|11' & $aFree[1] & '|'
$sCmdWrite &= @CRLF
If $aVGT[0][1] = '' Then
	_ArrayInsert($aFile, $InsIndex, $sCmdWrite)
	ConsoleWrite('-> Insert: command settings' & @CRLF)
EndIf

_FileWriteFromArray($sPathProps, $aFile, 1)
ConsoleWrite('-> Write: "SciTEUser.properties"' & @CRLF & @CRLF)
ConsoleWrite('!> CHANGES IN THE PROPERTIES FILE REQUIRES A RESTART OF SCITE!' & @CRLF & @CRLF)
ConsoleWrite('+> End: Install VarGetTip    ' & @HOUR &  ':' & @MIN &  ':' & @SEC & @CRLF)

; == function to get used command numbers
Func _GetUsed($_path)
	Local $aFile, $aMatch, $sUsed = '', $aRet[1] = [0]
	_FileReadToArray($_path, $aFile)
	For $i = 1 To $aFile[0]
		If StringRegExp($aFile[$i], '^b?command\.\d{1,2}.+') Then
			$aMatch = StringRegExp($aFile[$i], '^b?command\.(\d{1,2}).+', 3)
			$sUsed &= $aMatch[0] & ' '
		EndIf
	Next
	If $sUsed <> '' Then $aRet = StringSplit(StringTrimRight($sUsed, 1), ' ')
	Return $aRet
EndFunc