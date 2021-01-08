#include <GUIConstants.au3>
#include <GuiList.au3>
#include <Array.au3>
#include <excelcom.au3>
#include<excelcom.au3>
#include <Date.au3>
$z = 1
$y = 1
Global $list_array = 1
Global $path_array = 1
Global $q = 0
Global $ret
Global $delet_array = 1
Global $num
Global $w
Global $w2
Global $i_Row
Global $FilePath
Global $dom
Global $total
$A_F = "mvms|ef|otis|maint|Sky|evhs|evms|twd|trent|admin|d81|scc||101i|101r"

Global $firt_array
$firt_array = _ArrayCreate(0)
Global $MESSAGE = "The following buttons have been clicked"
GUICreate("My Milage Calculator", 470, 300); will create a dialog box that when displayed is centered
$listbox_1 = GUICtrlCreateList("", 20, 40, 180, 215, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY));$LBS_MULTIPLESEL
$Date_1 = GUICtrlCreateDate("Date1", 230, 10, 130, 20);
$DTM_SETFORMAT = 0x1005
$style = "MM/dd/yyyy"
GUICtrlSendMsg($Date_1, $DTM_SETFORMAT, 0, $style)
GUICtrlSetData($listbox_1, $A_F)

$add_list = GUICtrlCreateList("", 200, 40, 180, 215, BitOR($WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY));$LBS_MULTIPLESEL $LBS_SORT

$clear = GUICtrlCreateButton("Clear", 210, 265, 75, 25)
$done = GUICtrlCreateButton("Calculate", 305, 265, 75, 25)
$delete = GUICtrlCreateButton("Delete", 390, 85, 75, 25)
$Nextd = GUICtrlCreateButton("=>", 360, 10, 20, 20)
$Prevd = GUICtrlCreateButton("<=", 210, 10, 20, 20)
$ExptoExc = GUICtrlCreateButton("Exp. to .XLS", 390, 125, 75, 25)
GUICtrlSetLimit(-1, 200)
Dim $msg_set_data_1
GUISetState()
$msg = 0

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $listbox_1
			$ret = _GUICtrlListGetSelItemsText($listbox_1)
			add()

			GUICtrlSetData($add_list, "")
			For $i = 1 To UBound($firt_array) - 1
				GUICtrlSetData($add_list, $firt_array[$i])
			Next
		Case $msg = $delete
			$del = 0
			$ret = _GUICtrlListGetSelItemsText($add_list)
			If IsArray($ret) Then
				$del = $ret[1]
			EndIf
			GUICtrlSetData($add_list, "")
			If $del = 0 Then
				MsgBox(0, "Assistence", "If a location exists in the right column, please select it before pressing delete")
			Else
				$numb = StringSplit($del, "-")
				$numb1 = $numb[1]
				_ArrayDelete($firt_array, $numb[1])
				For $c = $numb1 To UBound($firt_array) - 1
					$p = StringSplit($firt_array[$c], "-")
					$p[1] = $p[1] - 1
					$firt_array[$c] = $p[1] & " - " & $p[2]
				Next
				For $i = 1 To UBound($firt_array) - 1
					GUICtrlSetData($add_list, $firt_array[$i])
				Next
			EndIf
		Case $msg = $clear
			GUICtrlSetData($add_list, "")
			$z = 1
			For $i = 0 To UBound($firt_array) - 1
				_ArrayDelete($firt_array, $i)
			Next
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $done
			tot()
			MsgBox(0, "total", $total)
		Case $msg = $ExptoExc
			writetoexcel()
		Case $msg = $Nextd
			$setdate=guictrlread($Date_1)
			$setdate=stringsplit($setdate,"/")
			$newdate=$setdate[3]&"/"&$setdate[1]&"/"&$setdate[2]
			$NewDate = _DateAdd( 'd',1, $newdate)
			guictrlsetdata($Date_1,$newdate)
		Case $msg = $Prevd
			$setdate=guictrlread($Date_1)
			$setdate=stringsplit($setdate,"/")
			$newdate=$setdate[3]&"/"&$setdate[1]&"/"&$setdate[2]
			$NewDate = _DateAdd( 'd',-1, $newdate)
			guictrlsetdata($Date_1,$newdate)
			Case $msg = $Prevd
	EndSelect
WEnd


Func calc ()
	For $i = 1 To UBound($list_array) - 1
		$list_array[$i] = StringReplace($list_array[$i], "admin", 1)
		$list_array[$i] = StringReplace($list_array[$i], "trent", 2)
		$list_array[$i] = StringReplace($list_array[$i], "twd", 3)
		$list_array[$i] = StringReplace($list_array[$i], "otis", 4)
		$list_array[$i] = StringReplace($list_array[$i], "ef", 5)
		$list_array[$i] = StringReplace($list_array[$i], "sky", 6)
		$list_array[$i] = StringReplace($list_array[$i], "evms", 7)
		$list_array[$i] = StringReplace($list_array[$i], "mvms", 8)
		$list_array[$i] = StringReplace($list_array[$i], "evhs", 9)
		$list_array[$i] = StringReplace($list_array[$i], "maint", 10)
		$list_array[$i] = StringReplace($list_array[$i], "d81", 11)
		$list_array[$i] = StringReplace($list_array[$i], "scc", 12)
		$list_array[$i] = StringReplace($list_array[$i], "101i", 13)
		$list_array[$i] = StringReplace($list_array[$i], "101r", 14)
	Next
	$path_array = $list_array
	For $i = 1 To UBound($list_array) - 2
		$path_array[$i] = $list_array[$i] & ":" & $list_array[$i + 1]
		$path_array[$i] = StringReplace($path_array[$i], " ", "")
	Next
	crossref($path_array)
EndFunc   ;==>calc

Func crossref($path_array)
	For $i = 1 To UBound($path_array) - 1
		$q = $path_array[$i]
		If $q = "0:0" Then $a = 0
		If $q = "0:1" Then $a = 0
		If $q = "0:2" Then $a = 0
		If $q = "0:3" Then $a = 0
		If $q = "0:4" Then $a = 0
		If $q = "0:5" Then $a = 0
		If $q = "0:6" Then $a = 0
		If $q = "0:7" Then $a = 0
		If $q = "0:8" Then $a = 0
		If $q = "0:9" Then $a = 0
		If $q = "0:10" Then $a = 0
		If $q = "0:11" Then $a = 0
		If $q = "0:12" Then $a = 0
		If $q = "0:13" Then $a = 0
		If $q = "0:14" Then $a = 0
		If $q = "1:0" Then $a = 0
		If $q = "2:0" Then $a = 0
		If $q = "3:0" Then $a = 0
		If $q = "4:0" Then $a = 0
		If $q = "5:0" Then $a = 0
		If $q = "6:0" Then $a = 0
		If $q = "7:0" Then $a = 0
		If $q = "8:0" Then $a = 0
		If $q = "9:0" Then $a = 0
		If $q = "10:0" Then $a = 0
		If $q = "11:0" Then $a = 0
		If $q = "12:0" Then $a = 0
		If $q = "13:0" Then $a = 0
		If $q = "14:0" Then $a = 0
		If $q = "1:1"Then $a = 0
		If $q = "1:2"Then $a = 0.3
		If $q = "1:3"Then $a = 2.5
		If $q = "1:4"Then $a = 6.9
		If $q = "1:5"Then $a = 10.7
		If $q = "1:6"Then $a = 3.9
		If $q = "1:7"Then $a = 2.8
		If $q = "1:8"Then $a = 11
		If $q = "1:9"Then $a = 3.4
		If $q = "1:10"Then $a = 4.8
		If $q = "1:11"Then $a = 9.9
		If $q = "1:12"Then $a = 8.2
		If $q = "1:13"Then $a = 12
		If $q = "1:14"Then $a = 10
		If $q = "2:1"Then $a = 0.3
		If $q = "2:2"Then $a = 0
		If $q = "2:3"Then $a = 2.2
		If $q = "2:4"Then $a = 6.6
		If $q = "2:5"Then $a = 10.4
		If $q = "2:6"Then $a = 3.6
		If $q = "2:7"Then $a = 2.6
		If $q = "2:8"Then $a = 10.7
		If $q = "2:9"Then $a = 3.1
		If $q = "2:10"Then $a = 4.6
		If $q = "2:11"Then $a = 10.2
		If $q = "2:12"Then $a = 8
		If $q = "2:13"Then $a = 12
		If $q = "2:14"Then $a = 10
		If $q = "3:1"Then $a = 2.5
		If $q = "3:2"Then $a = 2.2
		If $q = "3:3"Then $a = 0
		If $q = "3:4"Then $a = 5
		If $q = "3:5"Then $a = 8.9
		If $q = "3:6"Then $a = 1.5
		If $q = "3:7"Then $a = 0.4
		If $q = "3:8"Then $a = 9.3
		If $q = "3:9"Then $a = 1
		If $q = "3:10"Then $a = 3.1
		If $q = "3:11"Then $a = 10
		If $q = "3:12"Then $a = 10
		If $q = "3:13"Then $a = 16.3
		If $q = "3:14"Then $a = 12.1
		If $q = "4:1"Then $a = 6.9
		If $q = "4:2"Then $a = 6.6
		If $q = "4:3"Then $a = 5
		If $q = "4:4"Then $a = 0
		If $q = "4:5"Then $a = 3.1
		If $q = "4:6"Then $a = 3.6
		If $q = "4:7"Then $a = 5
		If $q = "4:8"Then $a = 3.4
		If $q = "4:9"Then $a = 4.4
		If $q = "4:10"Then $a = 3.4
		If $q = "4:11"Then $a = 17.9
		If $q = "4:12"Then $a = 14.5
		If $q = "4:13"Then $a = 19.4
		If $q = "4:14"Then $a = 17.4
		If $q = "5:1"Then $a = 10.7
		If $q = "5:2"Then $a = 10.4
		If $q = "5:3"Then $a = 8.9
		If $q = "5:4"Then $a = 3.1
		If $q = "5:5"Then $a = 0
		If $q = "5:6"Then $a = 7.5
		If $q = "5:7"Then $a = 8.8
		If $q = "5:8"Then $a = 0.3
		If $q = "5:9"Then $a = 8.4
		If $q = "5:10"Then $a = 6.4
		If $q = "5:11"Then $a = 21
		If $q = "5:12"Then $a = 18.3
		If $q = "5:13"Then $a = 22.3
		If $q = "5:14"Then $a = 20.4
		If $q = "6:1"Then $a = 3.9
		If $q = "6:2"Then $a = 3.6
		If $q = "6:3"Then $a = 1.5
		If $q = "6:4"Then $a = 3.6
		If $q = "6:5"Then $a = 7.5
		If $q = "6:6"Then $a = 0
		If $q = "6:7"Then $a = 1.3
		If $q = "6:8"Then $a = 7.8
		If $q = "6:9"Then $a = 0.9
		If $q = "6:10"Then $a = 1.7
		If $q = "6:11"Then $a = 13.8
		If $q = "6:12"Then $a = 11.5
		If $q = "6:13"Then $a = 16.8
		If $q = "6:14"Then $a = 13.6
		If $q = "7:1"Then $a = 2.8
		If $q = "7:2"Then $a = 2.6
		If $q = "7:3"Then $a = 0.4
		If $q = "7:4"Then $a = 5
		If $q = "7:5"Then $a = 8.8
		If $q = "7:6"Then $a = 1.3
		If $q = "7:7"Then $a = 0
		If $q = "7:8"Then $a = 9.1
		If $q = "7:9"Then $a = 0.4
		If $q = "7:10"Then $a = 2.9
		If $q = "7:11"Then $a = 12.9
		If $q = "7:12"Then $a = 10.5
		If $q = "7:13"Then $a = 16.2
		If $q = "7:14"Then $a = 12.3
		If $q = "8:1"Then $a = 11
		If $q = "8:2"Then $a = 10.7
		If $q = "8:3"Then $a = 9.3
		If $q = "8:4"Then $a = 3.4
		If $q = "8:5"Then $a = 0.3
		If $q = "8:6"Then $a = 7.8
		If $q = "8:7"Then $a = 9.1
		If $q = "8:8"Then $a = 0
		If $q = "8:9"Then $a = 8.7
		If $q = "8:10"Then $a = 6.7
		If $q = "8:11"Then $a = 21
		If $q = "8:12"Then $a = 18.6
		If $q = "8:13"Then $a = 22.8
		If $q = "8:14"Then $a = 20.7
		If $q = "9:1"Then $a = 3.4
		If $q = "9:2"Then $a = 3.1
		If $q = "9:3"Then $a = 1
		If $q = "9:4"Then $a = 4.4
		If $q = "9:5"Then $a = 8.4
		If $q = "9:6"Then $a = 0.9
		If $q = "9:7"Then $a = 0.4
		If $q = "9:8"Then $a = 8.7
		If $q = "9:9"Then $a = 0
		If $q = "9:10"Then $a = 2.5
		If $q = "9:11"Then $a = 13.8
		If $q = "9:12"Then $a = 11
		If $q = "9:13"Then $a = 15.8
		If $q = "9:14"Then $a = 12.7
		If $q = "10:1"Then $a = 4.8
		If $q = "10:2"Then $a = 4.6
		If $q = "10:3"Then $a = 3.1
		If $q = "10:4"Then $a = 3.4
		If $q = "10:5"Then $a = 6.4
		If $q = "10:6"Then $a = 1.7
		If $q = "10:7"Then $a = 2.9
		If $q = "10:8"Then $a = 6.7
		If $q = "10:9"Then $a = 2.5
		If $q = "10:10"Then $a = 0
		If $q = "10:11"Then $a = 12.9
		If $q = "10:12"Then $a = 13.4
		If $q = "10:13"Then $a = 16.6
		If $q = "10:14"Then $a = 15
		If $q = "11:1"Then $a = 9.9
		If $q = "11:2"Then $a = 10.2
		If $q = "11:3"Then $a = 10
		If $q = "11:4"Then $a = 17.9
		If $q = "11:5"Then $a = 21
		If $q = "11:6"Then $a = 13
		If $q = "11:7"Then $a = 12.9
		If $q = "11:8"Then $a = 21.2
		If $q = "11:9"Then $a = 13.8
		If $q = "11:10"Then $a = 15
		If $q = "11:11"Then $a = 0
		If $q = "11:12"Then $a = 9999999
		If $q = "11:13"Then $a = 9999999
		If $q = "11:14"Then $a = 9999999
		If $q = "12:1"Then $a = 8.2
		If $q = "12:2"Then $a = 8
		If $q = "12:3"Then $a = 10
		If $q = "12:4"Then $a = 14.5
		If $q = "12:5"Then $a = 18.3
		If $q = "12:6"Then $a = 11.5
		If $q = "12:7"Then $a = 10.5
		If $q = "12:8"Then $a = 18.6
		If $q = "12:9"Then $a = 11
		If $q = "12:10"Then $a = 13.4
		If $q = "12:11"Then $a = 21.2
		If $q = "12:12"Then $a = 0
		If $q = "12:13"Then $a = 9999999
		If $q = "12:14"Then $a = 9999999
		If $q = "13:1"Then $a = 12
		If $q = "13:2"Then $a = 12
		If $q = "13:3"Then $a = 16.3
		If $q = "13:4"Then $a = 19.4
		If $q = "13:5"Then $a = 22.3
		If $q = "13:6"Then $a = 16.8
		If $q = "13:7"Then $a = 16.2
		If $q = "13:8"Then $a = 22.8
		If $q = "13:9"Then $a = 15.8
		If $q = "13:10"Then $a = 16.6
		If $q = "13:11"Then $a = 9999999
		If $q = "13:12"Then $a = 9999999
		If $q = "13:13"Then $a = 0
		If $q = "13:14"Then $a = 9999999
		If $q = "14:1"Then $a = 10
		If $q = "14:2"Then $a = 10
		If $q = "14:3"Then $a = 12.1
		If $q = "14:4"Then $a = 17.4
		If $q = "14:5"Then $a = 20.4
		If $q = "14:6"Then $a = 13.6
		If $q = "14:7"Then $a = 12.3
		If $q = "14:8"Then $a = 20.7
		If $q = "14:9"Then $a = 12.7
		If $q = "14:10"Then $a = 15
		If $q = "14:11"Then $a = 9999999
		If $q = "14:12"Then $a = 9999999
		If $q = "14:13"Then $a = 9999999
		If $q = "14:14"Then $a = 0
		If IsDeclared("a") Then $path_array[$i] = $a
		If Not IsDeclared("a") Then MsgBox(0, "Critical Error", "problem with index " & $q)
	Next
	$total = 0
	For $i = 1 To UBound($path_array) - 2
		$total = $total + $path_array[$i]
	Next
	If $total < 9999999 Then
		Return ($total)
	Else
		MsgBox(0, "total", "the internal index is not complete due to lack of information, this is a critical error")
	EndIf
EndFunc  

Func add()
	If IsArray($ret) Then
		For $i = 1 To $ret[0]
			
			$z = UBound($firt_array)
			If Not $ret[$i] = 0 then	_ArrayAdd ($firt_array, $z & " - " & $ret[$i])
		Next
	EndIf
EndFunc   ;==>add

Func writetoexcel()
	$s_FilePath = @TempDir&"\books1.xls"
	$s_i_Visible = 1
	$Column1 = 1
	$Column2 = 1
	$Direction2 = 1
	$Direction1 = 1
	$s_i_Column = 1
	$i_Row = 1
	$dom = StringSplit(GUICtrlRead($Date_1), "/")
	$s_i_ExcelValue = GUICtrlRead($Date_1)
	$i_Row = $dom[2]
	$s_i_Sheet = 1
	$WorkbookPropArray = _XLSheetProps ($s_FilePath, $s_i_Visible)
	_xlrowdel($s_FilePath, $s_i_Sheet, $i_Row ,$s_i_Visible)
	_XLWrite ($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $s_i_ExcelValue, $s_i_Visible)
	tot()
	$s_i_Column = 2
	$s_i_ExcelValue = $total
	_XLWrite ($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $s_i_ExcelValue, $s_i_Visible)
	_XLCalc ($s_FilePath, $s_i_Visible)
	For $i = 1 To UBound($firt_array) - 1
		$cheezo = StringSplit($firt_array[$i], "-")
		$theclown = $cheezo[2]
		$s_i_Column = $i + 2
		$s_i_ExcelValue = $theclown
		_XLWrite ($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $s_i_ExcelValue, $s_i_Visible)
	Next
	sleep(250)
	WinActivate("My Milage Calculator")
EndFunc   ;==>writetoexcel

Func tot()
	Dim $list_array[1] = [0]
	For $x = 0 To _GUICtrlListCount($add_list) - 1
		ReDim $list_array[UBound($list_array) + 1]
		$list_array[0] = $list_array[0] + 1
		$list_array[UBound($list_array) - 1] = _GUICtrlListGetText($add_list, $x)
	Next
	For $i = 1 To UBound($list_array) - 1
		$monkey = StringInStr($list_array[$i], "-")
		$list_array[$i] = StringTrimLeft($list_array[$i], $monkey + 1)
	Next
	calc()
EndFunc   ;==>tot 

