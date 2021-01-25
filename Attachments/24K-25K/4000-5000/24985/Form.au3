#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <file.au3>


#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 427, 284, 289, 124)
$Tab1 = GUICtrlCreateTab(24, 24, 369, 209)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Tab1")
$Input1 = GUICtrlCreateInput("Input1", 64, 104, 121, 21)

If Not _FileCreate(@ScriptDir & "\data1.ini") Then
EndIf
FileOpen(@ScriptDir & "\data1.ini",2)
FileWrite(@ScriptDir & "\data1.ini",GUICtrlRead($Input1))


$TabSheet2 = GUICtrlCreateTabItem("Tab2")
$Input2 = GUICtrlCreateInput("Input2", 64, 104, 121, 21)

If Not _FileCreate(@ScriptDir & "\data2.ini") Then
EndIf
FileOpen(@ScriptDir & "\data2.ini",2)
FileWrite(@ScriptDir & "\data2.ini",GUICtrlRead($Input2))

$TabSheet3 = GUICtrlCreateTabItem("Tab3")
GUICtrlSetState(-1,$GUI_SHOW)
$Input3 = GUICtrlCreateInput("Input3", 72, 112, 121, 21)

If Not _FileCreate(@ScriptDir & "\data3.ini") Then
EndIf
FileOpen(@ScriptDir & "\data3.ini",2)
FileWrite(@ScriptDir & "\data3.ini",GUICtrlRead($Input3))

GUICtrlCreateTabItem("")
$B_Ok = GUICtrlCreateButton("OK", 144, 240, 75, 25, 0)
$B_Cancel = GUICtrlCreateButton("Cancel", 224, 240, 75, 25, 0)
$B_Apply = GUICtrlCreateButton("Apply", 304, 240, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Tab1
	EndSwitch
WEnd
