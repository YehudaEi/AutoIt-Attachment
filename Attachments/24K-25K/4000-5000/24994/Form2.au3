#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <file.au3>


#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 427, 284, 289, 124)
$Tab1 = GUICtrlCreateTab(24, 24, 369, 209)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Tab1")
$Input1 = GUICtrlCreateInput("Input1", 64, 104, 121, 21)

$TabSheet2 = GUICtrlCreateTabItem("Tab2")
$Input2 = GUICtrlCreateInput("Input2", 64, 104, 121, 21)

$TabSheet3 = GUICtrlCreateTabItem("Tab3")
GUICtrlSetState(-1, $GUI_SHOW)
$Input3 = GUICtrlCreateInput("Input3", 72, 112, 121, 21)

$Combo = GUICtrlCreateCombo("",72, 150, 121, 21)
GUICtrlSetData(-1,"john|smith")



GUICtrlCreateTabItem("")
$B_Ok = GUICtrlCreateButton("OK", 144, 240, 75, 25, 0)
$B_Cancel = GUICtrlCreateButton("Cancel", 224, 240, 75, 25, 0)
$B_Apply = GUICtrlCreateButton("Apply", 304, 240, 75, 25, 0)
GUISetState(@SW_SHOW)

If FileExists(@ScriptDir & "\data.ini") Then
GUICtrlSetData($Input1, IniRead(@ScriptDir & "\data.ini","Text","Input1","input1"))
GUICtrlSetData($Input2, IniRead(@ScriptDir & "\data.ini","Text","Input2","input2"))
GUICtrlSetData($Input3, IniRead(@ScriptDir & "\data.ini","Text","Input3","input3"))
EndIf
;msgBox(0,"",GUICtrlRead($Tab1))

#EndRegion ### END Koda GUI section ###

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $B_Ok
		    Switch GUICtrlRead($Tab1)
			    Case 0
                    ConsoleWrite(GUICtrlRead($Input1) & @CRLF)
                    IniWrite(@ScriptDir & "\data.ini","Text","Input1",GUICtrlRead($Input1))
					exit
                Case 1
                    ConsoleWrite(GUICtrlRead($Input2) & @CRLF)
                    $f = FileOpen(@ScriptDir & "\data.ini", 2)
                     IniWrite(@ScriptDir & "\data.ini","Text","Input2",GUICtrlRead($Input2))
                Case 2
                    ConsoleWrite(GUICtrlRead($Input3) & @CRLF)
                    IniWrite(@ScriptDir & "\data.ini","Text","Input3",GUICtrlRead($Input3))
					
					$read = GUICtrlRead($Combo)
					Select
						Case $read = "john"
							MsgBox(0,"hello","hello John")
						Case $read = "smith"
							MsgBox(0,"hello","hello Smith")
					EndSelect
					
            EndSwitch
        Case $B_Cancel
           ;something
        Case $B_Apply
           ;something else
            
    EndSwitch
WEnd