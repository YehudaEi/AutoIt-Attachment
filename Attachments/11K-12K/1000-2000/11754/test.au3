#include <GUIConstants.au3>
#include <array.au3>

GUI1()
Func GUI1()
	$Form1 = GUICreate("AForm1", 633, 447, 193, 115)
	$Combo1 = GUICtrlCreateCombo("ACombo1", 56, 32, 385, 25)
	$Button1 = GUICtrlCreateButton("Close", 56, 64, 177, 49, 0)
	$Button2 = GUICtrlCreateButton("Edit", 248, 64, 193, 49, 0)
	$GameListData = IniReadSectionNames("Setting.ini")
	If @error Then
		MsgBox(16,"setting.ini file missing/empty!","Your setting.ini file is missing/empty! One will be created/filled for you for this test")
		IniWrite("setting.ini","List one","","")
		IniWrite("setting.ini","List two","","")
		IniWrite("setting.ini","List three","","")
		GUI1()
	EndIf
	For $i = 1 To $GameListData[0]
		_ArraySort($GameListData)
		GUICtrlSetData($Combo1, $GameListData[$i])
	Next
	GUISetState(@SW_SHOW)

	While 1
		$Msg = GUIGetMsg()
		Select
			Case $Msg = $GUI_EVENT_CLOSE
				MsgBox(0,"Deleting ini file","When you close this, the INI file created for this test will be deleted")
				FileDelete("setting.ini")
				Exit
			Case $Msg = $Button2
				GUIDelete("AForm1")
				GUI2()
				Exit
			Case $Msg = $Button1
				MsgBox(0,"Deleting ini file","When you close this, the INI file created for this test will be deleted")
				FileDelete("setting.ini")
				Exit
		EndSelect
	WEnd
EndFunc ; <--End of GUI1

GUI2()
Func GUI2()
	$Form1 = GUICreate("AForm2", 550, 300, 193, 115)
	$Combo1 = GUICtrlCreateCombo("ACombo1", 88, 48, 409, 25)
	$Button1 = GUICtrlCreateButton("Done", 88, 96, 185, 33, 0)
	$Button2 = GUICtrlCreateButton("Delete", 296, 96, 201, 33, 0)
	$GameListData = IniReadSectionNames("Setting.ini")
	For $i = 1 To $GameListData[0]
		_ArraySort($GameListData)
		GUICtrlSetData($Combo1, $GameListData[$i])
	Next
	GUISetState(@SW_SHOW)

	While 1
		$Msg = GUIGetMsg()
		Select
			Case $Msg = $GUI_EVENT_CLOSE
				Exit
			Case $Msg = $Button1
				GUIDelete("AForm2")
				GUI1()
				Exit
			Case $Msg = $Button2
				$test1 = GUICtrlRead($Combo1)
				IniDelete("setting.ini",$test1)
				GUIDelete("Aform2")
				GUI1()
				Exit
		EndSelect
	WEnd
EndFunc ; <--End of GUI2
