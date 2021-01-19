#include <GuiConstants.au3>

$hWnd = WinGetHandle(WinGetTitle(""))

$Ret = _InputBox("_InputBox demo", "Type password... " & @LF & "[Only Numbers are allowed]" & @LF & "[Maximum 8 Numbers]", _
	"", $hWnd, 1, 1, 8, -1, 220, -1, -1, 0, $WS_EX_TOPMOST, 40)

If Not @error And $Ret <> "" Then MsgBox(262144+64, "Returned value", "You type <" & $Ret & ">", 20)
If @error = 2 And $Ret <> "" Then MsgBox(262144+64, "Returned value", "Time is out, here is what are you typed <" & $Ret & ">", 20)


;===============================================================================
;
; Function Name:    _InputBox()
; Description:      Custom InputBox Function (GUI based).
; Parameter(s):     $Title - The title of the Input Box.
;                   $Prmt - A message to the user indicating what kind of input is expected.
;                   $sDef - [Optional] The value that the input box starts with.
;                   $hWnd - [Optional] Window handle of the parent.
;                   $IsPass - [optional] If <> 0 Then typed characters will be replaced with password characters (*).
;                   $IsDig - [optional] If <> 0 Then only numbers can by typed to the input.
;                   $Limit - [optional] Limit the input for accept N characters.
;                   $W - [optional] The width of the window. Use -1 for default width (200).
;                   $H - [optional] The height of the window. Use -1 for default height (150).
;                   $Left - [optional] The left side of the input box. By default (-1), the box is centered.
;                   $Top - [optional] The top of the input box. By default (-1), the box is centered.
;                   $Style - [optional] Defines the style of the GUI window (forced style(s): $WS_SIZEBOX).
;                   $exStyle - [optional] Defines the extended style of the GUI window. -1 is the default.
;                   $iTOut - [optional] How many seconds to wait before automatically cancelling the InputBox.
;
; Requirement(s):   #include <GuiConstants.au3>.
; Return Value(s):  String that was typed to the Input.
; Author(s):        G.Sandler (a.k.a CreatoR).
; Note(s):          None.
;
;===============================================================================
Func _InputBox($Title,$Prmt,$sDef="",$hWnd=0,$IsPass=0,$IsDig=0,$Limit=-1,$W=-1,$H=-1,$Left=-1,$Top=-1,$Style=0,$exStyle=0,$iTOut=0)
	Local $OldOpt_GOEM = Opt("GuiOnEventMode", 0)
	WinSetState($hWnd, "", @SW_DISABLE)
	If $W < 200 Then $W = 200
	If $H < 150 Then $H = 150
	
	Local $InputGui, $OKButton, $CancelButton, $InputBoxID
	Local $RetValue, $RetErr = 0, $InputMsg, $iTimerStart
	Local $InputStyle = 0
	
	If $IsPass <> 0 Then $InputStyle += $ES_PASSWORD
	If $IsDig <> 0 Then $InputStyle += $ES_NUMBER
	
	$InputGui = GUICreate($Title, $W, $H, $Left, $Top, $WS_SIZEBOX+$Style, $exStyle, $hWnd)
	
	GUICtrlCreateLabel($Prmt, 15, 5, $W, -1)
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUIRegisterMsg(0x24, "MY_WM_GETMINMAXINFO")
	
	$OKButton = GUICtrlCreateButton("OK", ($W/2)-70, $H-95, 60, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
	GUICtrlSetState(-1, $GUI_ONTOP)
	
	$CancelButton = GUICtrlCreateButton("Cancel", ($W/2)+10, $H-95, 60, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
	GUICtrlSetState(-1, $GUI_ONTOP)
	
	$InputBoxID = GUICtrlCreateInput($sDef, 20, $H-60, $W-40, 20, $ES_AUTOHSCROLL+$InputStyle, $WS_EX_DLGMODALFRAME)
	GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
	GUICtrlSetState(-1, $GUI_FOCUS)
	If $Limit > 0 Then GUICtrlSetLimit(-1, $Limit)
	
	GUISetState(@SW_SHOW, $InputGui)
	If $iTOut > 0 Then $iTimerStart = TimerInit()
	
	While 1
		$InputMsg = GUIGetMsg()
		Switch $InputMsg
			Case -12
				ControlFocus($InputGui, "", $OKButton)
				ControlFocus($InputGui, "", $CancelButton)
			Case -3, $CancelButton
				$RetValue = ""
				$RetErr = 1
				ExitLoop
			Case $OKButton
				$RetValue = GUICtrlRead($InputBoxID)
				$RetErr = 0
				ExitLoop
		EndSwitch
		
		If $iTOut > 0 And Round(TimerDiff($iTimerStart)/1000) = $iTOut Then
			$RetValue = GUICtrlRead($InputBoxID)
			$RetErr = 2
			ExitLoop
		EndIf
	WEnd
	WinSetState($hWnd, "", @SW_ENABLE)
	GUIDelete($InputGui)
	GUISwitch($hWnd)
	Opt("GuiOnEventMode", $OldOpt_GOEM)
	Return SetError($RetErr, 0, $RetValue)
EndFunc

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
	Local $MinMaxInfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int",$lParam)
	Local $MINGuiX = 200, $MINGuiY = 150, $MAXGuiX = 400, $MAXGuiY = 300
	DllStructSetData($MinMaxInfo, 7, $MINGuiX) ; Min X
	DllStructSetData($MinMaxInfo, 8, $MINGuiY) ; Min Y
	DllStructSetData($MinMaxInfo, 9, $MAXGuiX) ; Max X
	DllStructSetData($MinMaxInfo, 10, $MAXGuiY) ; Max Y
	Return 0
EndFunc
