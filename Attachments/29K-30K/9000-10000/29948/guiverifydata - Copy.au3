#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)

Global $button, $msg, $TECHID, $USERID, $DATAP
Dim $aArray[3]

GUICreate("gui_test", 200, 200)
GUISetState()

Global $TLable = GUICtrlCreateLabel("Tech ID", 30, 15)
Global $TID = GUICtrlCreateInput("", 30, 30, 75, 20)
GUICtrlSetState(-1, $GUI_FOCUS)

Global $ULable = GUICtrlCreateLabel("User ID", 30, 65)
Global $UID = GUICtrlCreateInput("", 30, 80, 75, 20)

Global $DLable = GUICtrlCreateLabel("Datapath", 30, 115)
Global $DID = GUICtrlCreateInput("", 30, 130, 75, 20)

$button = GUICtrlCreateButton("start", 85, 170)


While 1
	$msg = GUIGetMsg()

	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $msg = $button Then
		$TECHID = GUICtrlRead($TID)
		$USERID = GUICtrlRead($UID)
		$DATAP = GUICtrlRead($DID)

		;if data input is blank open gui or msgbox stating the fields that are missing - after close continueloop
		$aArray[0] = $TECHID
		$aArray[1] = $USERID
		$aArray[2] = $DATAP
		Global $string = ""

		For $element In $aArray

			If $aArray = "" Then
				Select
					Case $aArray = $TECHID
						$string = "Tech ID"
					Case $aArray = $USERID
						$string = "User ID"
					Case $aArray = $DATAP
						$string = "User Datapath"
				EndSelect
			EndIf
			$string = $string & $element & @CRLF & "________________" & @CRLF
		Next


		MsgBox(4096, "Missing Info", $string)
		ExitLoop
	EndIf
WEnd
GUIDelete()