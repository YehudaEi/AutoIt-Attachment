#include <Array.au3>
#include <ColorConstants.au3>
#include <EditConstants.au3>
#include <Excel.au3>
#include <ExcelConstants.au3>
#include <File.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GUIScrollbars_Ex.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#pragma compile(Icon, "C:\MyIcon.ico")
Opt("TrayIconDebug", 1)

Global $mode, $y = 0, $hGUI_Child, $hGUI_Main
Local $progress = 0, $questionInput, $questionPic,$aRdbtn, $bRdbtn, $cRdbtn, $dRdbtn, $eRdbtn, $fRdbtn, $gRdbtn, $albl, $blbl, $clbl, $dlbl, _
		 $elbl, $flbl, $glbl, $next, $exit, $sResults
_mode()

If FileExists(@TempDir & "\Pracitice.xls") Then FileDelete(@TempDir & "\Pracitice.xls")
FileInstall("C:\Practice.xls", @TempDir & "\Practice.xls", 1)
$oApp = _Excel_Open(False)
$oWorkBook = _Excel_BookOpen($oApp, @TempDir & "\Practice.xls")
$aArray = _Excel_RangeRead($oWorkBook, Default, Default, 1, True)
	;_ArrayDisplay($aArray)
_Excel_Close($oApp)


	If $mode = 1 Then
		For $i = 1 To 241 ;First group 1-71, Second group 72-172, Third group 173-241
			$progress += 1
			questions($aArray, $i)
  		Next
	Else
		_ArrayShuffle($aArray, 1)
		For $i = 1 To 90
			$progress += 1
			questions($aArray, $i)
		Next
	EndIf

score()
close()

Func questions($aArray, $i)
	Local $height
		Switch $i
			Case 90
				$height = 725
			Case 133
				$height = 830
			Case Else
				$height = 575
		EndSwitch

	Local $start = 135, $lblStart = $start + 4

	$hGUI_Main = GUICreate(($mode = 1) ? "Java SE7 Practice Exam                              Question " & $progress & " of 241"  : "Java SE7 Practice Exam                              Question " & $progress & " of 90", 800, $height)
		GUISetFont(11, 400, Default, "Arial")
	$questionlbl = GUICtrlCreateLabel(" Question " & $aArray[$i][0], 10, 5, 120, 20, Default, $WS_EX_STATICEDGE)
		GUICtrlSetFont(-1, 11, 600, Default, "Arial")
	$questionInput = GUICtrlCreateLabel($aArray[$i][1], 40, 60, 720, 50)
		GUICtrlSetFont($questionInput, 11, 600, Default, "Arial")

	Switch $i
		Case 90
			$ctrlHeight = 140
		Case 133
			$ctrlHeight = 160
		Case 194, 220
			$ctrlHeight = 70
		Case 72, 105, 106, 126
			$ctrlHeight = 100
		Case Else
			$ctrlHeight = 50
	EndSwitch

		$aRdbtn = (StringInStr($aArray[$i][4], ",") ? GUICtrlCreateCheckbox("A. ", 40, $start, 30, 25) : GUICtrlCreateRadio("A. ", 40, $start, 30, 25))
		$bRdbtn = (StringInStr($aArray[$i][4], ",") ? GUICtrlCreateCheckbox("B. ", 40, ($start + $ctrlHeight), 30, 25) : GUICtrlCreateRadio("B. ", 40, ($start + $ctrlHeight), 30, 25))
		$cRdbtn = (StringInStr($aArray[$i][4], ",") ? GUICtrlCreateCheckbox("C. ", 40, $start + ($ctrlHeight * 2), 30, 25) : GUICtrlCreateRadio("C. ", 40, $start + ($ctrlHeight * 2), 30, 25))
		$dRdbtn = (StringInStr($aArray[$i][4], ",") ? GUICtrlCreateCheckbox("D. ", 40, $start + ($ctrlHeight * 3), 30, 25) : GUICtrlCreateRadio("D. ", 40, $start + ($ctrlHeight * 3), 30, 25))
		$eRdbtn = (StringInStr($aArray[$i][4], ",") ? GUICtrlCreateCheckbox("E. ", 40, $start + ($ctrlHeight * 4), 30, 25) : GUICtrlCreateRadio("E. ", 40, $start + ($ctrlHeight * 4), 30, 25))
		$fRdbtn = (StringInStr($aArray[$i][4], ",") ? GUICtrlCreateCheckbox("F. ", 40, $start + ($ctrlHeight * 5), 30, 25) : GUICtrlCreateRadio("F. ", 40, $start + ($ctrlHeight * 5), 30, 25))
		$gRdbtn = (StringInStr($aArray[$i][4], ",") ? GUICtrlCreateCheckbox("G. ", 40, $start + ($ctrlHeight * 6), 30, 25) : GUICtrlCreateRadio("G. ", 40, $start + ($ctrlHeight * 6), 30, 25))

		$albl = GUICtrlCreateLabel($aArray[$i][7], 75, $lblStart, 600, $ctrlHeight)
		$blbl = GUICtrlCreateLabel($aArray[$i][8], 75, ($lblStart + $ctrlHeight), 600, $ctrlHeight)
		$clbl = GUICtrlCreateLabel($aArray[$i][9], 75, $lblStart + ($ctrlHeight * 2), 600, $ctrlHeight)
		$dlbl = GUICtrlCreateLabel($aArray[$i][10], 75, $lblStart + ($ctrlHeight * 3), 600, $ctrlHeight)
		$elbl = GUICtrlCreateLabel($aArray[$i][11], 75, $lblStart + ($ctrlHeight * 4), 600, ($i = 197) ? $ctrlHeight + 100 : $ctrlHeight)
		$flbl = GUICtrlCreateLabel($aArray[$i][12], 75, $lblStart + ($ctrlHeight * 5), 600, $ctrlHeight)
		$glbl = GUICtrlCreateLabel($aArray[$i][13], 75, $lblStart + ($ctrlHeight * 6), 600, $ctrlHeight)

			GUICtrlSetState($cRdbtn, ($aArray[$i][9] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($dRdbtn, ($aArray[$i][10] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($eRdbtn, ($aArray[$i][11] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($fRdbtn, ($aArray[$i][12] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($gRdbtn, ($aArray[$i][13] = "") ? $GUI_HIDE : $GUI_SHOW)

			GUICtrlSetState($clbl, ($aArray[$i][9] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($dlbl, ($aArray[$i][10] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($elbl, ($aArray[$i][11] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($flbl, ($aArray[$i][12] = "") ? $GUI_HIDE : $GUI_SHOW)
			GUICtrlSetState($glbl, ($aArray[$i][13] = "") ? $GUI_HIDE : $GUI_SHOW)

	$next = GUICtrlCreateButton("Next", 640, $height - 35, 60, 30)
		_GUICtrlButton_SetFocus($next)
	$exit = GUICtrlCreateButton("Exit", 720, $height - 35, 60, 30)
	$showCode = GUICtrlCreateButton("Show Code", 10, $height - 35, 100, 30)
		GUICtrlSetState(-1, ($aArray[$i][2] = "No") ? $GUI_HIDE : $GUI_SHOW)
	GUISetState(@SW_SHOW)

_Create_Child($hGUI_Main)
GUIRegisterMsg($WM_MOVE, "_Position_Child")

		While 1
			Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE, $exit
					close()
				Case $next
					recordAnswers($aArray, $i)
					GUIDelete($hGUI_Main)
					ExitLoop
				Case $showCode
					_SH_Child($hGUI_Main, $showCode)
			EndSwitch
		WEnd
EndFunc

Func recordAnswers($aArray, $i)
	Local $sFile =@TempDir & "\Answers.txt", $sString = "", $sResults = ""
		If GUICtrlRead($aRdbtn) = 1 Then $sString &= "A,"
		If GUICtrlRead($bRdbtn) = 1 Then $sString &= "B,"
		If GUICtrlRead($cRdbtn) = 1 Then $sString &= "C,"
		If GUICtrlRead($dRdbtn) = 1 Then $sString &= "D,"
		If GUICtrlRead($eRdbtn) = 1 Then $sString &= "E,"
		If GUICtrlRead($fRdbtn) = 1 Then $sString &= "F,"
		If GUICtrlRead($gRdbtn) = 1 Then $sString &= "G,"

	$finalAnswer = StringTrimRight($sString, 1)
	$sResults = (($finalAnswer == $aArray[$i][4]) ? $aArray[$i][5] : $aArray[$i][6])
	$answer = (($finalAnswer == $aArray[$i][4]) ? FileWrite($sFile, "Answer " & $aArray[$i][0] & ": " & "Correct! The answer is " & $aArray[$i][4] & "." & @CRLF & $sResults & @CRLF & @CRLF) : FileWrite($sFile, "Answer " & $aArray[$i][0] & ": " & "Incorrect! The answer is " & $aArray[$i][4] & "." & @CRLF & $sResults & @CRLF & @CRLF))
	If $finalAnswer == $aArray[$i][4] Then $y += 1
EndFunc

Func score()
	$aResults = FileReadToArray(@TempDir & "\Answers.txt")
	$sString = _ArrayToString($aResults, @CRLF)

	$finalScore = (($mode = 1) ? StringLeft(($y / 172) * 100, 4) :     StringLeft(($y / 90) * 100, 4))

		If $finalScore > 80 Then
			$mb = (($mode = 1) ? (MsgBox(4, "Practice Exam Results", "Your total score was " & $y & " out of a possible 172: " & $finalScore & "%. You passed!" & @CRLF & @CRLF & "Would you like to review the answers?")) : (MsgBox(4, "Practice Exam Results", "Your total score was " & $y & " out of a possible 90: " & $finalScore & "%. You passed!" & @CRLF & @CRLF & "Would you like to review the answers?")))
		Else
			$mb = (($mode = 1) ? (MsgBox(4, "Practice Exam Results", "Your total score was " & $y & " out of a possible 172: " & $finalScore & "%. You failed." & @CRLF & @CRLF & "Would you like to review the answers?")) : (MsgBox(4, "Practice Exam Results", "Your total score was " & $y & " out of a possible 90: " & $finalScore & "%. You failed." & @CRLF & @CRLF & "Would you like to review the answers?")))
		EndIf

		If $mb = 6 Then
			$hGUI = GUICreate("Practice Exam Results", 800, 800)
			$input = (($mode = 1) ? (GUICtrlCreateInput($sString, 5, 5, 790, 11340, $ES_MULTILINE)) : (GUICtrlCreateInput($sString, 5, 5, 790, 5490, $ES_MULTILINE)))
				GUICtrlSetFont(-1, 11, 400, Default, "Arial")
			$bars = (($mode = 1) ? (_GUIScrollbars_Generate($hGUI, 0, 11350)) : (_GUIScrollbars_Generate($hGUI, 0, 5500)))
			GUISetState(@SW_SHOW)


				While 1
					Switch GUIGetMsg()
						Case $GUI_EVENT_CLOSE
							ExitLoop
					EndSwitch
				WEnd

			GUIDelete()
		EndIf
EndFunc

Func _mode()
	GUICreate("Java SE7 Practice Exam - Select Test Mode", 500, 300)
	GUISetState(@SW_SHOW)

	$lblMode1 = GUICtrlCreateLabel("- Learning Mode - ", 170, 10, 150, 20)
	$mode1radio = GUICtrlCreateRadio("", 10, 35, 15, 20)
	$lblMode1b = GUICtrlCreateLabel("This format will provide you with all 170+ questions, without shuffling. " _
							   		& "This is an excellent 'flash card' style study tool.", 30, 35, 460, 100)
		GUICtrlSetFont($lblMode1, 11, 600, Default, "Arial")
		GUICtrlSetFont($lblMode1b, 10, 400, Default, "Arial")

	$lblMode2 = GUICtrlCreateLabel("- Exam Prep - ", 185, 100, 150, 20)
	$mode2radio = GUICtrlCreateRadio("", 10, 135, 15, 20)
	$lblMode2b = GUICtrlCreateLabel("This format mimics the actual exam, with 90 random questions pulled from the pool of " _
									& "more than 170. At the conclusion of the exam you will be shown correct and incorrect " _
									& "answers and will receive an evaluation based upon your score.", 30, 135, 460, 100)
		GUICtrlSetFont($lblMode2, 11, 600, Default, "Arial")
		GUICtrlSetFont($lblMode2b, 10, 400, Default, "Arial")

	$begin = GUICtrlCreateButton("Begin", 30, 220, 80, 60)
		GUICtrlSetFont($begin, 11, 600, Default, "Arial")

	$quit = GUICtrlCreateButton("Exit", 390, 220, 80, 60)
		GUICtrlSetFont($quit, 11, 600, Default, "Arial")

		While 1
			Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE, $quit
					Exit
				Case $begin
					If GUICtrlRead($mode1radio) = 1 Then
						$mode = 1
						ExitLoop
					ElseIf GUICtrlRead($mode2radio) = 1 Then
						$mode = 2
						ExitLoop
					Else
						MsgBox(0, "Java SE7 Practice Exam", "Please select the testing mode you would like to try")
					EndIf
			EndSwitch
		WEnd

	GUIDelete()
EndFunc

Func close()
	GUIDelete()
	FileDelete(@TempDir & "\Practice.xls")
	FileDelete(@TempDir & "\Answers.txt")
	FileDelete(@TempDir & "\Notify.exe")
	Exit
EndFunc

Func _Create_Child($hGUI_Main)
	Local $lnCount

	If $aArray[$i][2] <> "No" Then
		$aLines = StringSplit($aArray[$i][2], Chr(10))
		$lnCount = $aLines[0]
	EndIf

    $hGUI_Child = GUICreate("Follower", 400, $lnCount * 20, -1, -1, BitOR($WS_POPUP, $WS_BORDER), 0, $hGUI_Main)
    GUISetBkColor(0xCCFFCC)
	GUISetFont(11, 400, Default, "Arial")
	$text = GUICtrlCreateLabel($aArray[$i][2], 10, 10, 380, ($lnCount * 20) - 20)
    _Position_Child($hGUI_Main, 0, 0, 0)
    GUISetState(@SW_HIDE, $hGUI_Child)
EndFunc   ;==>_Create_Child

Func _Position_Child($hWnd, $iMsg, $wParam, $lParam)

 ;   #forceref $iMsg, $wParam, $lParam

    If $hWnd <> $hGUI_Main Then Return
    Local $aGUI_Main_Pos = WinGetPos($hGUI_Main)
    WinMove($hGUI_Child, "", $aGUI_Main_Pos[0] + $aGUI_Main_Pos[2] + 2, $aGUI_Main_Pos[1]) ; Removed speed, why slow it it all down? <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
EndFunc   ;==>_Position_Child

Func _SH_Child($hGUI_Main, $showCode)
    If GUICtrlRead($showCode) = "Show Code" Then
        GUISetState(@SW_SHOW, $hGUI_Child)
        GUICtrlSetData($showCode, "Hide Code")
        WinActivate($hGUI_Main)
    Else
        GUISetState(@SW_HIDE, $hGUI_Child)
        GUICtrlSetData($showCode, "Show Code")
    EndIf
EndFunc   ;==>_SH_Child