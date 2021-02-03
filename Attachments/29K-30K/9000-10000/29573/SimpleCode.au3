#include-once
;#include <ButtonConstants.au3>
;#include <GUIConstantsEx.au3>
;#include <GUIListView.au3>
;#include <WindowsConstants.au3>
#include <_EIPListView_my.au3>
;#include <staticconstants.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=C:\Program Files\AutoIt3\koda\Templates\Test.kxf
Global $Paused  = False
Global $Started = False
Global $LVcolControl[5] = [1, 1, 2, 2, 2] ;left click actions
;0 = ignore, 1= use context callback
Global $LVcolRControl[5] = [256, 256, 0, 0, 0] ; right click actions

Local $DualListDlg = GUICreate("Test", 921, 550, 202, 141, BitOR($WS_MAXIMIZEBOX,$WS_MINIMIZEBOX,$WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_TABSTOP,$WS_BORDER,$WS_CLIPSIBLINGS))
$Gui = $DualListDlg
GUISetIcon("D:\007.ico")
GUISetOnEvent($GUI_EVENT_CLOSE, "DualListDlgClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "DualListDlgMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "DualListDlgMaximize")

;Local $ListView1 = GUICtrlCreateList("", 24, 32, 257, 227, BitOR($LBS_SORT,$LBS_STANDARD,$WS_VSCROLL,$WS_BORDER))
Local $ListView1 = GUICtrlCreateListView("Test Number|Test Name                            |Device|Protocol|Port", 16, 32, 418, 230 )
	GUICtrlSetOnEvent($ListView1, "ListView1Click")
	GUICtrlSendMsg($ListView1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)   ; NEW!!!
Local $ListViewItems1[10]	
Local $GUICTRL_RIGHTARROW_BTN = GUICtrlCreateButton(">", 448, 48, 30, 25, $WS_GROUP)
	GUICtrlSetOnEvent($GUICTRL_RIGHTARROW_BTN, "RightArrowClick")
Local $GUICTRL_RUNTESTSUIT__BTN = GUICtrlCreateButton("Run", 424, 424, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($GUICTRL_RUNTESTSUIT__BTN, "RunSuitClick")
Local $ListView2 = GUICtrlCreateListView("Test Number|Test Name                            |Device|Protocol|Port", 488, 32, 418, 230)
	GUICtrlSetOnEvent($ListView2, "ListView2Click")
	GUICtrlSendMsg($ListView2, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)   ; NEW!!!
	$__LISTVIEWCTRL = $ListView2         ; NEW!!!
Local $ListViewItems2[1]	
Local $GUICTRL_SAVESUIT_BTN = GUICtrlCreateButton("&Save", 688, 416, 75, 25,  $WS_GROUP)
	GUICtrlSetOnEvent($GUICTRL_SAVESUIT_BTN, "SaveSuitClick")
Local $GUICTRL_EXIT_BTN = GUICtrlCreateButton("&Exit", 424, 488, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($GUICTRL_EXIT_BTN, "ExitClick")
Local $GUICTRL_OPENSUIT__BTN = GUICtrlCreateButton("Open", 184, 416, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($GUICTRL_OPENSUIT__BTN, "OpenSuitClick")
	GUISetState(@SW_SHOW)
	_InitEditLib ("", "", "", "Whatever", $Gui);
	Local $c  														; NEW!!!
	For $i = 1 To 18															; NEW!!!
		$c = $c & Chr($i + 66) & "|"										; NEW!!!
	Next																	; NEW!!!
	ConsoleWrite("!!!!!!!!!!!!$c:"&  $c&@CRLF)										; NEW!!!
	$c = StringTrimRight($c, 1)													; NEW!!!
	GUICtrlSetData($lvCombo, $c)

#EndRegion ### END Koda GUI section ###

Func RightArrowClick()

	Local $currentItem = GUICtrlRead(GUICtrlRead($ListView1))
	If UBound($ListViewItems2) ==1  Then
		$ListViewItems2[0] = GUICtrlCreateListViewItem($currentItem, $ListView2)
	Else
		_ArrayAdd($ListViewItems2, GUICtrlCreateListViewItem($currentItem, $ListView2))
	EndIf
	$__LISTVIEWCTRL = $ListView2   	    ; NEW!!!
EndFunc

Func SaveSuitClick()

EndFunc
Func ExitClick()
	Exit
EndFunc


Func RunSuitClick()
	;CALLTIP: This function executed after pressing 'Run' button. Start to executing Test Suit
	$Started = NOT $Started													; Set flag TRUE  and start executing Test Suit
	GUICtrlSetState($GUICTRL_RUNTESTSUIT__BTN, $GUI_DISABLE)        		;  Disable 'Run' button	
EndFunc

Func ContinueClick()
	;CALLTIP: This function executed after pressing 'Continue' button
	$Paused = NOT $Paused											 		; Set flag False  and continue executing Test Suit	
EndFunc

Func OpenSuitClick()
 	For $index=0 To 9										; Cycle goes over 
		$ListViewItems1[$index] = GUICtrlCreateListViewItem("Test"&$index&"|"&"Test"&$index&"|||"&"Test"&$index, $ListView1)
	Next	
EndFunc

Func DualListDlgClose()
	
	Exit
EndFunc

Func DualListDlgMaximize()

EndFunc
Func DualListDlgMinimize()

EndFunc
Func DualListDlgRestore()

EndFunc
Func ListView1Click()


EndFunc
Func ListView2Click()
  Local $result=   _GUICtrlListView_EditLabel($ListView2, 0)
EndFunc


While Not($Started)
		_MonitorEditState ($editCtrl, $editFlag, $__LISTVIEWCTRL, $LVINFO);<<<======  add this in your message loop<<<======
		
		If $bCALLBACK_EVENT = True Then
			$bCALLBACK_EVENT = False
			
			Call($LVCALLBACK, $LVINFO)
		EndIf
	
		Sleep(25)

WEnd
