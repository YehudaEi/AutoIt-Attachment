#include <GUIConstants.au3>
#include <guilist.au3>
;GUICtrlSetState(-1,$GUI_DROPACCEPTED)

Dim $SplitFileNameArray[1][2]

; == GUI generated with Koda ==
$MP3Renamer = GUICreate("MP3Renamer", 1069, 400, 188, 115, -1, 0x00000018)
$edtFileNames = GUICtrlCreateInput("", 8, 8, 121, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetState(-1,$GUI_DROPACCEPTED)
GUICtrlCreateLabel("<- Drag Files here", 136, 12, 87, 17)
$btnClearFileNames = GUICtrlCreateButton("Clear", 8, 32, 123, 25)
$lstFileNames = GUICtrlCreateList("", 240, 8, 817, 318, -1, BitOR($LBS_SORT,$WS_EX_CLIENTEDGE))
$btnTidyFileNames = GUICtrlCreateButton("Tidy", 8, 59, 123, 25)
GUISetState(@SW_SHOW)
; == GUI generated with Koda ==


While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $btnTidyFileNames
		btnTidyFileNamesOnClick()
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit

Func btnTidyFileNamesOnClick()
	$FileNameArray = StringSplit(GUICtrlRead($edtFileNames),'|')
	For $i = 1 To $FileNameArray[0]
		_GUICtrlListAddItem($lstFileNames,$FileNameArray[$i])
	Next
EndFunc
