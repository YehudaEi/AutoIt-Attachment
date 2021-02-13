#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt('TrayIconDebug', 1)
Global $dirTgtSel, $dirTgTmp[10], $dirTgt[10], $msgIcn
$fnScript = 'Recent Folders (example script)' ;full script name
$script = StringLeft(@ScriptName, StringInStr(@ScriptName, '.', 0, -1) - 1)
If $script <> 'RecentFolders' Then $script = 'RecentFolders' ;proper script name (if user changed it)
$sVer = 0.4
$title = $fnScript & ' ' & $sVer
$ini = @ScriptDir & '\' & $script & '.ini'
$brk = 0
$posDir = ''
OnAutoItExitRegister('OnExit')
IniFRead()

Const $wi = 338, $he = 63
#region ### START Koda GUI section ### Form=DirTgt.kxf
$frmDirTgt = GUICreate($title, $wi, $he, -1, -1)
$cboDirTgt = GUICtrlCreateCombo('', 4, 8, 265, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
DirRcntVfy()
DirRcntDisp()
$btnDirTgt = GUICtrlCreateButton('C&hange...', 272, 6, 59, 25)
GUICtrlSetTip(-1, 'Select (output) folder')
$btnCv = GUICtrlCreateButton('Convert some files...', 112, 32, 107, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetTip(-1, 'Example of some file operation. After this, the folder list will be saved')
Dim $frmDirTgt_AccelTable[1][2] = [['^h', $btnDirTgt]]
GUISetAccelerators($frmDirTgt_AccelTable)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnDirTgt
			DirRcntChkLst()
			DirTgtChng()
			If StringLen($dirTgtSel) > 0 Then
				$posDir = ''
				DirRcntShift()
			EndIf
			DirRcntDisp()
		Case $cboDirTgt
			$dirTgtSel = GUICtrlRead($cboDirTgt)
			DirFull()
			DirRcntChkLst()
			If StringLen($dirTgtSel) > 0 Then DirRcntShift()
			DirRcntDisp()
		Case $btnCv
			Convert()
			$posDir = ''
			DirRcntChkLst()
			If StringLen($dirTgtSel) > 0 Then
				$posDir = ''
				DirRcntShift()
			EndIf
			DirRcntSav()
			DirRcntDisp()
			$msgIcn = ''
	EndSwitch
WEnd

Func DirRcntVfy() ;checking folders - if doesn't exist anymore, the item is cleared and moved up
	$dirLenSum = 0
	For $i = 1 To 9
		If StringLen($dirTgTmp[$i]) > 0 And Not FileExists($dirTgTmp[$i]) Then $dirTgTmp[$i] = ''
		$dirLenSum = $dirLenSum + StringLen($dirTgTmp[$i])
	Next
	If $dirLenSum = 0 Then $dirTgTmp[1] = @AppDataDir ;if none exist - set @AppDataDir
	For $i = 1 To 9
		For $k = 9 To 2 Step -1
			If $dirTgTmp[$k - 1] = '' Then
				$dirTgTmp[$k - 1] = $dirTgTmp[$k]
				$dirTgTmp[$k] = ''
			EndIf
		Next
	Next
EndFunc   ;==>DirRcntVfy

Func DirTgtChng()
	$dirTgtSel = ''
	For $i = 0 To 9
		If $i = 0 Then
			$dirTgtSel = FileSelectFolder('Select output folder for (e.g.) converted files. (' & $i + 1 & '/10)', '', '', GUICtrlRead($cboDirTgt))
		Else
			$dirTgtSel = FileSelectFolder('Select output folder for (e.g.) converted files. (' & $i + 1 & '/10)', '', '', $dirTgTmp[$i])
		EndIf
		If StringLen($dirTgtSel) > 0 Then
			$dirAcc = DirAccess($dirTgtSel)
			If StringLen($dirAcc) > 1 Then
				MsgBox(48, $title, $dirAcc & @CRLF & @CRLF & 'Contact with Administrator or choose different target folder.', 30)
				$dirTgtSel = ''
				ContinueLoop
			EndIf
			$dirTgTmp[0] = $dirTgtSel
			ExitLoop
		EndIf
		If $i = 2 Then ExitQuery()
		If $brk = 1 Then
			$brk = 0
			ExitLoop
		EndIf
	Next
	If Not FileExists($dirTgtSel) Then $dirTgtSel = ''
EndFunc   ;==>DirTgtChng

Func DirAccess($sDir) ; checking directory access
	$errAcc = 0
	$fTmp = @TempDir & '\' & $script & '.tmp'
	$hFil = FileOpen($fTmp, 2)
	FileWrite($hFil, 'Dir write/delete access test - delete this file.')
	FileClose($hFil)
	$asDir = StringSplit($sDir, '|')
	For $i = 1 To $asDir[0]
		If Not FileExists($asDir[$i]) Then
			$errAcc = SetError(2, 0, $asDir[$i] & ' is not a valid folder.')
			ContinueLoop
		EndIf
		FileCopy($fTmp, $asDir[$i] & '\', 1)
		If Not FileExists($asDir[$i] & '\' & StringTrimLeft($fTmp, StringInStr($fTmp, '\', 0, -1))) Then
			$errAcc = SetError(1, 0, 'No write access to ' & @CRLF & $asDir[$i])
		Else
			FileDelete($asDir[$i] & '\' & StringTrimLeft($fTmp, StringInStr($fTmp, '\', 0, -1)))
			If @error Then $errAcc = SetError(2, 0, 'No delete access to ' & @CRLF & $asDir[$i])
		EndIf
	Next
	FileDelete($fTmp)
	Return $errAcc
EndFunc   ;==>DirAccess

Func DirRcntChkLst()
	If $posDir <> '' Then
		For $i = 1 To $posDir
			$dirTgTmp[$i - 1] = $dirTgTmp[$i]
		Next
		$dirTgTmp[$posDir] = $dirTgTmp[0]
		$dirTgTmp[0] = ''
	EndIf
EndFunc   ;==>DirRcntChkLst

Func DirRcntShift()
	For $i = 1 To 9
		If $dirTgtSel = $dirTgTmp[$i] Then
			$posDir = $i
			ExitLoop
		EndIf
	Next
	$dirTgTmp[0] = $dirTgtSel
	If $posDir <> '' Then
		For $i = $posDir To 1 Step -1
			$dirTgTmp[$i] = $dirTgTmp[$i - 1]
		Next
		$dirTgTmp[0] = ''
	EndIf
EndFunc   ;==>DirRcntShift

Func DirRcntSav()
	$posDif = 0
	If $dirTgTmp[0] <> '' Then $posDif = 1
	For $i = 1 To 9
		$dirTgt[$i] = $dirTgTmp[$i - $posDif]
	Next
	For $i = 1 To 9
		$dirTgTmp[$i] = $dirTgt[$i]
	Next
	$dirTgTmp[0] = ''
EndFunc   ;==>DirRcntSav

Func DirRcntDisp()
	$cboDirTgtData = ''
	$iFrom = 1
	If $dirTgtSel <> '' Then
		If $dirTgTmp[0] <> '' Then
			$dirTgTmp[0] = $dirTgtSel
			$iFrom = 0
		Else
			$dirTgTmp[1] = $dirTgtSel
		EndIf
	Else
		$dirTgtSel = $dirTgTmp[1]
	EndIf
	DirShort()
	For $i = $iFrom To 9
		If $dirTgTmp[$i] <> '' Then $cboDirTgtData = $cboDirTgtData & '|' & $dirTgTmp[$i]
	Next
	$cboDirTgtData = StringTrimLeft($cboDirTgtData, 1)
	GUICtrlSetData($cboDirTgt, '')
	GUICtrlSetData($cboDirTgt, $cboDirTgtData, $dirTgtSel)
	DirFull()
	GUICtrlSetTip($cboDirTgt, $dirTgtSel)
	$dirTgTmp[0] = ''
EndFunc   ;==>DirRcntDisp

Func Convert() ;you can insert here an action related with file/folder operation, e.g. conversion
	$msgIcn = 1
	msg('Converting done.' & @CRLF & 'Saving current recent folders order.', -2000, -1, Int(@DesktopHeight / 2) + $he + 4, $msgIcn)
EndFunc   ;==>Convert

Func DirShort()
	Dim $dirShort[11]
	For $i = 0 To 10
		If $i < 10 Then
			$dirShort[$i] = $dirTgTmp[$i]
		Else
			$dirShort[$i] = $dirTgtSel
		EndIf
		If StringLen($dirShort[$i]) > 0 Then
			If StringLeft($dirShort[$i], StringLen(@UserProfileDir)) = @UserProfileDir Then
				$dirShort[$i] = StringTrimLeft($dirShort[$i], StringLen(@UserProfileDir) + 1) ;shortened path to @UserProfileDir subdirs
				If $dirShort[$i] = '' Then $dirShort[$i] = @UserName
			EndIf
		EndIf
	Next
	For $i = 0 To 10
		If $i < 10 Then
			$dirTgTmp[$i] = $dirShort[$i]
		Else
			$dirTgtSel = $dirShort[$i]
		EndIf
	Next
EndFunc   ;==>DirShort

Func DirFull()
	Dim $dirFull[11]
	For $i = 0 To 10
		If $i < 10 Then
			$dirFull[$i] = $dirTgTmp[$i]
		Else
			$dirFull[$i] = $dirTgtSel
		EndIf
		If StringLen($dirFull[$i]) > 0 Then
			If $dirFull[$i] = @UserName Then $dirFull[$i] = @UserProfileDir
			If StringLeft($dirFull[$i], 2) <> '\\' And StringMid($dirFull[$i], 2, 2) <> ':\' Then $dirFull[$i] = @UserProfileDir & '\' & $dirFull[$i] ;restoring shortened paths
		EndIf
	Next
	For $i = 0 To 10
		If $i < 10 Then
			$dirTgTmp[$i] = $dirFull[$i]
		Else
			$dirTgtSel = $dirFull[$i]
		EndIf
	Next
EndFunc   ;==>DirFull

Func IniFRead()
	$sct = IniReadSection($ini, 'DirsTgtRcnt')
	If @error Then
		msg("Missing [DirsTgtRcnt] section or ini file doesn't exist!", -1500, -1, -1, 2)
	Else
		For $i = 1 To $sct[0][0]
			If $sct[$i][1] = '' Then IniDelete($ini, 'Main', $sct[$i][0])
		Next
	EndIf
	For $i = 1 To 9
		$dirTgt[$i] = IniRead($ini, 'DirsTgtRcnt', 'dirTgt' & $i, '')
		$dirTgTmp[$i] = $dirTgt[$i]
	Next
	If $dirTgt[1] = '' Then $dirTgTmp[1] = @AppDataDir
EndFunc   ;==>IniFRead

Func ExitQuery()
	$exitQry = MsgBox(292, $title, 'Quit with selecting output folders?', 8)
	If $exitQry = 6 Then $brk = 1
EndFunc   ;==>ExitQuery

Func OnExit()
	BlockInput(0)
	DirRcntVfy()
	For $i = 1 To 9
		IniWrite($ini, 'DirsTgtRcnt', 'dirTgt' & $i, $dirTgt[$i])
	Next
EndFunc   ;==>OnExit

Func msg($txt = '', $ms = 1500, $ttX = -1, $ttY = -2, $icn = 1, $tray = -1, $sTit = -1)
	If $ms >= 0 And $ms < 250 Then $ms = 250
	If $ms = -1 Then $ms = 1500
	$clr = 0
	If $ms < -1 Then
		$ms = Abs($ms)
		$clr = 1
	EndIf
	If $sTit = -1 Then
		$sTit = StringLeft(@ScriptName, StringInStr(@ScriptName, '.', 0, -1) - 1)
		If IsDeclared('fnScript') And IsDeclared('sVer') Then $sTit = $fnScript & ' ' & $sVer
	EndIf
	If $ttX = -1 Then $ttX = Int(@DesktopWidth / 2)
	If $ttY = -1 Then $ttY = Int(@DesktopHeight / 2)
	If $ttY = -2 Then $ttY = @DesktopHeight - 64
	If $icn = 2 Then $txt = 'Warning!' & @CRLF & $txt
	If $icn = 3 Then $txt = 'ERROR!' & @CRLF & $txt
	If $tray = -1 Then ToolTip($txt, $ttX, $ttY, $sTit, $icn, 2)
	If $tray = 1 Then TrayTip($sTit, $txt, $ms, $icn)
	Sleep($ms)
	If $clr = 1 Then ToolTip('')
EndFunc   ;==>msg
