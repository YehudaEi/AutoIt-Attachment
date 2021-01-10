#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>

$form_num = 1

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Sqlite GUI test", 223, 359, 267, 119)
$count = GUICtrlCreateInput($form_num, 144, 10, 33, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$b_right = GUICtrlCreateButton(">", 176, 8, 27, 25, 0)
$b_left = GUICtrlCreateButton("<", 120, 8, 27, 25, 0)
$lname = GUICtrlCreateLabel("Name:", 8, 48, 48, 17)
$iname = GUICtrlCreateInput("", 64, 48, 145, 21)
$ladress = GUICtrlCreateLabel("Adress:", 8, 88, 45, 17)
$iadress = GUICtrlCreateInput("", 64, 88, 145, 21)
$iemail = GUICtrlCreateInput("", 64, 128, 145, 21)
$lemail = GUICtrlCreateLabel("E-mail:", 8, 128, 46, 17)
$lother = GUICtrlCreateLabel("Other:", 8, 168, 46, 17)
$eother = GUICtrlCreateEdit("", 64, 168, 145, 121)
$badd = GUICtrlCreateButton("Add", 48, 312, 75, 25, 0)
$bdel = GUICtrlCreateButton("Delete", 128, 312, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_SQLite_Startup()
If NOT FileExists("database.db") Then
	$dbn=_SQLite_Open("database.db")
	_SQLite_Exec($dbn,"CREATE TABLE datas (id,name,adress,email,other);")
Else
	$dbn=_SQLite_Open("database.db")
EndIf

dataquery($form_num)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			progend()
		Case $b_right
			$form_num = $form_num + 1
			GUICtrlSetData($count,$form_num)
			dataquery($form_num)
		Case $b_left
			If $form_num == 1 Then
				$form_num = 1
				GUICtrlSetData($count,$form_num)
			Else
 				$form_num = $form_num - 1
				GUICtrlSetData($count,$form_num)
				dataquery($form_num)
			EndIf
		Case $badd
			IF GUICtrlRead($iname) == "" Then
				MsgBox(0,"ERORR","Empty name!")
			Else
				dataadd($form_num)
			EndIf
		Case $bdel
			datadel($form_num)
	EndSwitch
WEnd

Func progend()
	_SQLite_Close()
	_SQLite_Shutdown()
	Exit
EndFunc



Func dataadd($id)
	Local $retarr
	$str1 = GUICtrlRead($iname)
	$str2 = GUICtrlRead($iadress)
	$str3 = GUICtrlRead($iemail)
	$str4 = GUICtrlRead($eother)
	_SQLite_QuerySingleRow($dbn,"SELECT id FROM datas WHERE id='"&$id&"'",$retarr)
	If $retarr[0] <> "" Then
		_SQLite_Exec($dbn,"UPDATE datas SET name='"&$str1&"', adress='"&$str2&"',email='"&$str3&"',other='"&$str4&"' WHERE id='"&$id&"'")
	Else
		_SQLite_Exec($dbn,"INSERT INTO datas (id,name,adress,email,other) VALUES ('"&$form_num&"','"&$str1&"','"&$str2&"','"&$str3&"','"&$str4&"');")
	EndIf
EndFunc


Func dataquery($id)
	GUICtrlSetData($iname,"")
	GUICtrlSetData($iadress,"")
	GUICtrlSetData($iemail,"")
	GUICtrlSetData($eother,"")
	Local $retarr
	If _SQLite_QuerySingleRow($dbn,"SELECT * FROM datas WHERE id='"&$id&"'",$retarr) == $SQLITE_OK Then
		If $retarr[0] == "" Then
			;MsgBox(0,"ERROR","Query error!")
		Else
			GUICtrlSetData($iname,$retarr[1])
			GUICtrlSetData($iadress,$retarr[2])
			GUICtrlSetData($iemail,$retarr[3])
			GUICtrlSetData($eother,$retarr[4])
		EndIf
	EndIf
EndFunc

Func datadel($id)
	Local $retarr
	GUICtrlSetData($iname,"")
	GUICtrlSetData($iadress,"")
	GUICtrlSetData($iemail,"")
	GUICtrlSetData($eother,"")
	_SQLite_QuerySingleRow($dbn,"SELECT id FROM datas WHERE id='"&$id&"'",$retarr)
	If $retarr[0] <> "" Then
		_SQLite_Exec($dbn,"DELETE FROM datas WHERE id='"&$id&"'")
	EndIf		
EndFunc