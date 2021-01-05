#include <GuiConstants.au3>

;******MainWin and Control Creation******

Global $MainWin=GUICreate("Main Window","200","200");
GUISetState(@SW_SHOW,$MainWin)

Global $NumberList=GUICtrlCreateListView("Type|Number",5,5,190,150,$LVS_NOSORTHEADER+$LVS_SHOWSELALWAYS)
Global $Button=GUICtrlCreateButton("Button",5,160)

;******SubWin and Control Creation******

Global $SubWin=GUICreate("Sub Window","200","100",-1,-1,-1,$WS_EX_TOOLWINDOW,$MainWin);

Global $SubButton=GUICtrlCreateButton("Button2",5,5)

;****Event Control Section****

While 1
	$msg=GUIGetMsg(1)

	Select
		Case $msg[0]=$GUI_EVENT_CLOSE AND $msg[1]=$MainWin
		ExitLoop

		Case $msg[0]=$GUI_EVENT_CLOSE AND $msg[1]=$SubWin
		GUISetState(@SW_HIDE,$SubWin)

		Case $msg[0]=$Button
		GUISetState(@SW_SHOW,$SubWin)

		Case $msg[0]=$SubButton
		$StatusVar=GUICtrlCreateListViewItem("New|Data",$NumberList)
		MsgBox(0,"Data",$StatusVar)

	EndSelect
Wend