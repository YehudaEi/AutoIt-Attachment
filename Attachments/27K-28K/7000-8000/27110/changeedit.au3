#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <GuiEdit.au3>

Global $oMyError
Global $switchte=0
Example()


Func Example()
	Local $myedit, $msg

	GUICreate("My GUI edit")  ; will create a dialog box that when displayed is centered

	$myedit = GUICtrlCreateEdit("First line" & @CRLF, 176, 32, 121, 97, $ES_AUTOVSCROLL + $WS_VSCROLL)
	$button=GUICtrlCreateButton("Switch Text",176,155,100,50)
	GUISetState()



	; will be append dont' forget 3rd parameter
	GUICtrlSetData($myedit, "Second line", 1)

	; Run the GUI until the dialog is closed
	While 1
		$msg = GUIGetMsg()
		
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
		If $msg =$button Then
			if $switchte=0 Then
				 _GUICtrlEdit_SetText($myedit, "First line" & @CRLF&"Second line")
				$switchte=1
			ElseIf $switchte=1 Then
				$switchte=0
				_GUICtrlEdit_SetText($myedit, "New text" & @CRLF&"and some more text")
			EndIf
			
		EndIf
	WEnd
	GUIDelete()
EndFunc   ;==>Example

