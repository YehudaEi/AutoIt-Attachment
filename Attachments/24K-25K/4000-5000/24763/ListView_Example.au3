#include <ListView UDF.au3>
Opt('GuiOnEventMode', 1)

GUICreate('ListView UDF Example', 300, 170)
GUISetOnEvent(-3, '_Exit')

$lv = GUICtrlCreateListView('Item', 5, 5, 290, 125) ; _GUICtrlListView_Create
For $i = 1 To 5
	GUICtrlCreateListViewItem('Item ' & $i, $lv) ; _GUICtrlListView_AddItem
Next
GUICtrlSendMsg($lv, 0x101E, 0, 280)

GUICtrlCreateButton('Move item Up', 5, 135, 90, 20)
GUICtrlSetOnEvent(-1, '_Up')

GUICtrlCreateButton('Move item Down', 100, 135, 90, 20)
GUICtrlSetOnEvent(-1, '_Down')

GUICtrlCreateButton('Replace item', 210, 135, 80, 20)
GUICtrlSetOnEvent(-1, '_Delete')
GUISetState(@SW_SHOW)

Func _Up()
	_GuiCtrlListView_SwitchItemSelectedUp($lv)
EndFunc   ;==>_Up

Func _Down()
	_GuiCtrlListView_SwitchItemSelectedDown($lv)
EndFunc   ;==>_Down

Func _Delete()
	_GUICtrlListView_ReplaceItemSelected($lv, 'Item Replaced')
EndFunc   ;==>_Delete

While 1
	Sleep(250)
WEnd

Func _Exit()
	Exit
EndFunc   ;==>_Exit