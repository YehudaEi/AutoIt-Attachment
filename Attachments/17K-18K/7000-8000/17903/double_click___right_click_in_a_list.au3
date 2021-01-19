#include <GuiConstants.au3>

;Global Const $WM_NOTIFY = 0x004E  ; removed to conform to Autoit build 3.2.10.0
Global $DoubleClicked   = False

GUICreate("Double Click/Right Click Demo", 400, 300)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

;create listboxt
$ListViewID = GuiCtrlCreateListView("List Column", 10, 20, 380, 250)


;******************Rightclick Menu*************
$menu1=GUICtrlCreateContextMenu ($ListViewID)
$delete=GUICtrlCreateMenuitem("Delete" , $menu1)
$play=GUICtrlCreateMenuitem("Play" , $menu1)
$info=GUICtrlCreateMenuitem("Info" ,$menu1)

;~~~~~~~~~~~~~~~Using Loop Method~~~~~~~~~~~~~~

;***************End Rightclick Menu************

;this builds the items in your list box
For $i = 1 To 10
    GuiCtrlCreateListViewItem("Item " & $i, $ListViewID)
Next

GUISetState()

While 1
	$hGui = GUIGetMsg()
	    Sleep(10)
			Switch $hGui
		Case $GUI_EVENT_CLOSE
			Exit
			EndSwitch
    If $DoubleClicked Then
        DoubleClickFunc()
        $DoubleClicked = False
    EndIf
	Select
	Case $hGui = $delete
	delete()
	Case $hGui = $play
	play()
	Case $hGui = $info
	info()
	EndSelect
WEnd

Func DoubleClickFunc()
    MsgBox(64, "OK ", "You Double Clicked: " & GUICtrlRead(GUICtrlRead($ListViewID)) & " ?")
EndFunc

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
    Local $tagNMHDR, $event, $hwndFrom, $code
    $tagNMHDR = DllStructCreate("int;int;int", $lParam)
    If @error Then Return 0
    $code = DllStructGetData($tagNMHDR, 3)
    If $wParam = $ListViewID And $code = -3 Then $DoubleClicked = True
    Return $GUI_RUNDEFMSG
EndFunc

Func play()
    MsgBox(64, "You Right Clicked ", "Play: " & GUICtrlRead(GUICtrlRead($ListViewID)) & " ?")
EndFunc

Func delete()
    MsgBox(64, "You Right Clicked ", "Delete: " & GUICtrlRead(GUICtrlRead($ListViewID)) & " ?")
EndFunc
   
Func info()
    MsgBox(64, "You Right Clicked ", "Info For: " & GUICtrlRead(GUICtrlRead($ListViewID)) & " ?")
EndFunc