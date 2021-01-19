#include-once

;===============================================================================
; Function Name:   _ControlTab()
; Description:     Sends a command to a SysTab32 Control.
; Syntax:          _ControlTab ( $hWnd, $sText, $sCommand  [, $sParam1 [, $sParam2 [, $sParam3]]] )
;
; Parameter(s):    $hWnd       = Window Handle/Title.
;                  $sText      = Window Text.
;                  $sCommand   = Command to send to the control (See "Return Value(s)").
;                  $sParam1, $sParam2, $sParam3 = Additional parameters required by some commands.
;
; Requirement(s):  AutoIt 3.2.8.1.
;
; Return Value(s): Depends on command as shown below. In case an invalid command or window/control, @error set to 1 and return ""
;                       If $sCommand Equel...
;                          "GetItemState" - State of the tab item returned.
;                            ($sParam1 defines what tab item (zero-based) will be used - 0 is the default).
;                            On failure return "" and set @error to 1.
;
;                          "GetItemText" - Text of the tab item returned.
;                            ($sParam1 defines what tab item (zero-based) will be used - 0 is the default).
;                            On failure return "" and set @error to 1.
;
;                          "GetItemImage" - Image Index of the tab item returned.
;                            ($sParam1 defines what tab item (zero-based) will be used - 0 is the default).
;                            On failure return "" and set @error to 1.
;
;                          "CurrentTab" - Returns the current Tab shown of a SysTabControl32.
;                            On failure return -1 and set @error to 1.
;
;                          "TabRight" - Moves to the next tab to the right of a SysTabControl32.
;                            ($sParam1 defines how many times move to the right tab - 1 is the default).
;                            On failure return -1 and set @error to 1.
;
;                          "TabLeft" - Moves to the next tab to the left of a SysTabControl32.
;                            ($sParam1 defines how many times move to the left tab - 1 is the default).
;                            On failure return -1 and set @error to 1.
;
;                          "TabSelect" - Select specific tab item (base on given zero-based index) of a SysTabControl32.
;                            On failure return -1 and set @error to 1.
;
;                          "GetTabsCount" - Returns the number of total tab items of a SysTabControl32.
;                            On failure return -1 and set @error to 1.
;
;                          "FindTab" - Search For tab item with specific text..
;                          In this case used all three additional parameters:
;                               $sParam1 - defines what text to find.
;                               $sParam2 - defines from what tab item the search will start (zero-based).
;                               $sParam3 - defines search type...
;                               If $sParam3 = True Then will be performed a partial search of the string in the tab item text.
;                           On seccess: return the tab item index taht contain founded text.
;                           On failure:
;                               If $sParam2 >= total tabs count, return -1 and set @error to 1.
;                               If could not find tab, return -1.
;
; Author(s):       G.Sandler a.k.a CreatoR
;
; Example(s):
;     $TabText = _ControlTab("Properties", "", "GetItemText", 1) ;Will return the text of second tab from the left side.
;===============================================================================
Func _ControlTab($hWnd, $sText, $sCommand, $sParam1="", $sParam2="", $sParam3="")
	Local Const $TCM_FIRST = 0x1300
	Local $hTab = ControlGetHandle($hWnd, $sText, "SysTabControl321")
	
	Switch $sCommand
		Case "GetItemState", "GetItemText", "GetItemImage"
			Local Const $TagTCITEM = "int Mask;int State;int StateMask;ptr Text;int TextMax;int Image;int Param"
			Local Const $TCIF_ALLDATA = 0x0000001B
			Local Const $TCM_GETITEM = $TCM_FIRST + 5
			
			Local $tBuffer 	= DllStructCreate("char Text[4096]")
			Local $pBuffer 	= DllStructGetPtr($tBuffer)
			Local $tItem   	= DllStructCreate($tagTCITEM)
			Local $pItem  	= DllStructGetPtr($tItem)
			
			DllStructSetData($tItem, "Mask", $TCIF_ALLDATA)
			DllStructSetData($tItem, "TextMax", 4096)
			DllStructSetData($tItem, "Text", $pBuffer)
			
			If $sParam1 = -1 Or $sParam1 = "" Then
				$sParam1 = _ControlTab($hWnd, $sText, "CurrentTab")
				If @error Then Return SetError(1, 0, "")
			EndIf
			
			DllCall("user32.dll", "long", "SendMessage", "hwnd", $hTab, "int", $TCM_GETITEM, "int", $sParam1, "int", $pItem)
			If @error Then Return SetError(1, 0, "")
			
			If $sCommand = "GetItemState" Then Return DllStructGetData($tItem, "State")
			If $sCommand = "GetItemText" Then Return DllStructGetData($tBuffer, "Text")
			If $sCommand = "GetItemImage" Then Return DllStructGetData($tItem, "Image")
		Case "CurrentTab"
			Local $iRet = ControlCommand($hWnd, $sText, "SysTabControl321", $sCommand, "")
			If @error Then Return SetError(1, 0, -1)
			Return $iRet - 1
		Case "TabRight", "TabLeft"
			Local $iRet = 0
			
			If Not IsNumber($sParam1) Or $sParam1 <= 0 Then $sParam1 = 1
			For $i = 1 To $sParam1
				$iRet = ControlCommand($hWnd, $sText, "SysTabControl321", $sCommand, "")
				If @error Then Return SetError(1, 0, -1)
			Next
			Return $iRet
		Case "TabSelect"
			Local Const $TCM_SETCURFOCUS = $TCM_FIRST + 48
			Local $iRet = DllCall("user32.dll", "long", "SendMessage", _
				"hwnd", $hTab, "int", $TCM_SETCURFOCUS, "int", $sParam1, "int", 0)
			If @error Then Return SetError(1, 0, -1)
			Return $iRet[0]
		Case "GetTabsCount"
			Local Const $TCM_GETITEMCOUNT = $TCM_FIRST + 4
			Local $iRet = DllCall("user32.dll", "long", "SendMessage", "hwnd", $hTab, "int", $TCM_GETITEMCOUNT, "int", 0, "int", 0)
			If @error Then Return SetError(1, 0, -1)
			Return $iRet[0]
		Case "FindTab"
			If Not IsNumber($sParam2) Or $sParam2 < 0 Then $sParam2 = 0
			
			Local $sTabText
			Local $iCnt = _ControlTab($hWnd, $sText, "GetTabsCount")
			
			If $sParam2 >= $iCnt Then Return SetError(1, 0, -1)
			
			For $i = $sParam2 To $iCnt
				$sTabText = _ControlTab($hWnd, $sText, "GetItemText", $i)
				If $sParam3 = True And StringInStr($sTabText, $sParam1) Then Return $i
				If $sTabText = $sParam1 Then Return $i
			Next
			Return -1
		Case Else
			Return SetError(1, 0, "")
	EndSwitch
EndFunc   ;==> _ControlTab
