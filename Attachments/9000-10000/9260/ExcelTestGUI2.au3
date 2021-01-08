#include <GUIConstants.au3>
#include "ExcelUDF.au3"
Dim $Step = 0

; == GUI generated with Koda ==
### Koda GUI section start ###
$Form1 = GUICreate("AForm1", 500, 215, @DesktopWidth - 500, 0, -1, $WS_EX_TOPMOST)
GUICtrlCreateLabel("Function", 16, 24, 45, 17)
$Edit1 = GUICtrlCreateEdit("Press Continue please...", 16, 52, 470, 121, Bitor($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
GUICtrlSetData($Edit1, "")
$Button1 = GUICtrlCreateButton("Continue", 16, 180, 117, 25, 0)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
GUICtrlSetState(-1, $GUI_FOCUS)
$Label1 = GUICtrlCreateLabel("", 76, 24, 407, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)

### Koda GUI section end   ###
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			$Step += 1
			if $Step = 30 Then
				Exit
			EndIf
			ExecFunc()
	EndSwitch
WEnd


Func ExecFunc()
	DoStep()
EndFunc

Func DoStep()
	Switch $Step
		Case 1
			SetTopic("_XLApp($XL_OPEN, False)", "Let open Excel in mode not visible")
			_XLApp($XL_OPEN, false)
		Case 2
			SetDescr("Now Excel is opened but not visible")
			SetTopic("_XLApp($XL_VISIBLE, True)", "So let we make it visible")
		Case 3
			;Fade()
			_XLApp($XL_VISIBLE, True)
			;Fade(False)
			SetTopic("_XLWBook($XP_NEW)", "Now let create a New workbook")
		Case 4
			;Fade()
			_XLWBook($XL_NEW)
			;Fade(False)
			SetTopic('_XLWBook($XP_OPEN, @ScripDir & "\WorldCup.xls")', "and let open an existing workbook")
		Case 5
			;Fade()
			_XLWBook($XL_OPEN, @ScriptDir & "\WorldCup.xls")
			;Fade(False)
			SetTopic("_XLWBook($XL_ACTIVATE,1)", "We now activate the first Workbook")
		Case 6
			;Fade()
			_XLWBook($XL_ACTIVATE,1)
			;Fade(False)
			SetTopic('_XLRange($XL_WRITEVALUE,"C5","","", $Value)', "We write some cells values from cell C5")
		Case 7
			Dim $Values [3][3] = [["One",2,"Three"],[4,"Five",6],["Seven", 8, "Nine"]]
			;Fade()
			_XLRange($XL_WRITEVALUE, "C5", "", "", $Values)
			;Fade(False)
			SetTopic('$Result = _XLRange($XL_READVALUE, "C5:E5")','And read the values from Row Range C5:E5')
		Case 8
			$Result = _XLRange($XL_READVALUE, "C5:E5")
			$Values = ArrayToStr($Result)
			SetDescr("and the Result is : " & @CR & $Values)
			SetTopic('$Result = _XLRange($XL_READVALUE, "C5:C7")',"we can read a Column Range C5:C7")
		Case 9
			$Result = _XLRange($XL_READVALUE, "C5:C7")
			$Values = ArrayToStr($Result)
			SetDescr("and the Result is : " & @CR & $Values)
			SetTopic('$Result = _XLRange($XL_READVALUE, "C5:C7")',"we can also read a Block Range C5:E7")
		Case 10
			$Result = _XLRange($XL_READVALUE, "C5:E7")
			$Values = ArrayToStr($Result)
			SetDescr("and the Result is : " & @CR & $Values)
		Case 11
			SetDescr("you can read a Range from a nonactive Worksheet")
			SetTopic('$Result = _XLRange($XL_READVALUE, "D1:D3",1,2)',"let's read Range D1:D3 from first Worksheet in Workbook WoldCup.xls")
		Case 12
			$Result = _XLRange($XL_READVALUE, "D1:D3",1,2)
			$Values = ArrayToStr($Result)
			SetDescr("and the Result is : " & @CR & $Values)
			SetTopic('_XLWBook($XL_ACTIVATE,"WorldCup.xls")', "let's activate the WorldCup.xls Worksheet")
		Case 13
			;Fade()
			_XLWBook($XL_ACTIVATE,"WorldCup.xls")
			;Fade(False)
		Case 14
			SetTopic("$Result = _XLWBook($XL_GETNAME)", "Getting the name of the Active Workbook")
			$Result = _XLWBook($XL_GETNAME)
			SetDescr('The active Workbook name is "' & $Result & '"')
		Case 15
			SetTopic('_XLRange($XL_AUTOFILTER,"A1")', "You can Autofilter a range")
			_XLRange($XL_AUTOFILTER,"A1")
		Case 16 
			SetDescr( "Restore it back with the same function")
			_XLRange($XL_AUTOFILTER,"A1")
			SetTopic("_XLWBook($XL_CLOSE)", "Now we close the active Workbook")
		Case 17
			_XLWBook($XL_CLOSE)
			SetTopic('_XLRange($XL_SELECT,"C5:E7")', "Let's select Range C5:E7")
			_XLRange($XL_SELECT, "C5:E7")
		Case 18
			SetTopic('_XLRange($XL_COPYTO, "F10")', "and copy to F10")
			_XLRange($XL_COPYTO, "F10")
		case 19
			SetTopic('_XLCell($XL_LASTROW,"A1")', "Let's go to Last Row from Range A1")
			_XLCell($XL_LASTROW,"A1")
		Case 20
			SetTopic('_XLCell($XL_LASTCOL,"A1")', "Let's go to Last Column from Range A1")
			_XLCell($XL_LASTCOL,"A1")
		Case 21
			SetTopic('_XLCell($XL_LASTCELL,"A1")', "Let's go to Last Cell")
			_XLCell($XL_LASTCELL,"A1")
		Case 22
			SetTopic('_XLWBook($XL_SAVE, "Sample1.xls")', "And save the new Workbook")
			_XLWBook($XL_SAVE, "", "Sample1.xls")
		Case Else
			SetDescr("Closing Excel")
			_XLApp($XL_CLOSE)
			SetDescr("Bye ...")
			Fade()
			Exit
	EndSwitch
EndFunc

Func ArrayToStr($array)
	$Values = ""
	if IsArray($array) Then
		For $i = 0 to UBound($array,1) - 1
			if UBound($array,0) = 2 Then
				$Values &= $array[$i][0]
				For $j = 1 to UBound($array,2) - 1
					$Values &= ", " & $array[$i][$j]
				Next
				$Values &= @CR
			Else
				If $i = 0 Then
					$Values &= $array[$i]
				Else
					$Values &= "," & $array[$i]
				EndIf
			EndIf
		Next
	Else
		$Values = $array
	EndIf
	Return $Values
EndFunc


Func SetTopic($FuncName, $Descr)
	GUICtrlSetData($Label1, $FuncName)
	SetDescr($Descr)
EndFunc

Func SetDescr($Descr)
	ControlSend("AForm1", "", $Edit1, $Descr & @CR)
EndFunc

Func Fade($in = True)
	$wtmmPrevious = AutoItSetOption("WinTitleMatchMode", 3)
	if $in Then
		For $i = 254 to 60 Step -5
			WinSetTrans("AForm1","",$i)
			sleep(5)
		Next
	Else
		For $i = 61 to 255 Step 5
			WinSetTrans("AForm1","",$i)
			Sleep(5)
		Next
	EndIf
	AutoItSetOption("WinTitleMatchMode", $wtmmPrevious)
EndFunc