#include <Constants.au3>
#include <WinAPI.au3>
#OnAutoItStartRegister "_WinSplitStartUp"

Global Const $WS_HALF = 0
Global Const $WS_VERTICAL = 0
Global Const $WS_HORIZONTAL = 1
Global $WinSplitStartUp = True

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinSplit
; Description ...: Split a window in 2 Windows.
; Syntax ........: _WinSplit($hwnd, $PxToCut, $Mode[, $ParrentIng = False])
; Parameters ....: $hwnd                - A window Handle
;                  $PxToCut             - From what pixel to split the window ($WS_HALF)
;                  $Mode                - Vertical($WS_VERTICAL) or Horizontal($WS_HORIZONTAL)
;                  $ParrentIng          - Make second window child to main window. Default is False.
; Return values .:  Succes : Second window Hwnd
;					Fail :  -1 -> $PxToCut < 0 ($PxToCut need to be positive ($PxToCut = 0 <=> $PxToCut = $WS_HALF)
;							-2 -> $Mode <> $WS_VERTICAL And $Mode <> $WS_HORIZONTAL
;							-3 -> $hwnd is not HWnd
;							-4 -> Other Error
; Author ........: PlayHD
; Modified ......: -
; Remarks .......: Thanks to Authenticity for WinListChildren function
; Related .......: -
; Link ..........: -
; Example .......: Yes
; ===============================================================================================================================
Func _WinSplit($hwnd, $PxToCut, $Mode, $ParrentIng = False)
	If $PxToCut < 0 Then Return -1
	If $Mode <> $WS_VERTICAL And $Mode <> $WS_HORIZONTAL Then Return -2
	If Not IsHWnd($hwnd) Then $hwnd = HWnd($hwnd)
	If Not IsHWnd($hwnd) Then Return -3
	Local $WinControls
	Local $WinPos = _WinAPI_GetWindowPlacement($hwnd)
	WinListChildren($hwnd,$WinControls)
	Local $WinWidth = _WinAPI_GetWindowWidth($hwnd)
	Local $WinHeight = _WinAPI_GetWindowHeight($hwnd)
	Local $WinX = DllStructGetData($WinPos, "rcNormalPosition", 1)
	Local $WinY = DllStructGetData($WinPos, "rcNormalPosition", 2)
	Local $Parrent = Default
	If $ParrentIng Then $Parrent = $hwnd
	Local $Style = GUIGetStyle($hwnd)
	If Not IsArray($Style) Then
		Local $Style[2] = [-1,-1]
	EndIf
	Switch $Mode
		Case $WS_VERTICAL
			If $PxToCut = $WS_HALF Then $PxToCut = $WinWidth/2
			$PxToCut = $WinWidth - $PxToCut
			WinMove($hwnd,"",$WinX,$WinY,$WinWidth-$PxToCut)
			$SForm = GUICreate(WinGetTitle($hwnd),-1,-1,-1,-1,$Style[0],$Style[1],$Parrent)
			WinMove($SForm,"",$WinX+($WinWidth-$PxToCut)+10,$WinY,$WinWidth-_WinAPI_GetWindowWidth($hwnd),$WinHeight)
			$WinWidth = _WinAPI_GetWindowWidth($hwnd)
			For $i = 1 To $WinControls[0][0]
				$CtrlPos = ControlGetPos($SForm,"",$WinControls[$i][0])
				If Not IsArray($CtrlPos) Then Return -4
				If $CtrlPos[0] > $WinWidth Then
					_WinAPI_SetParent($WinControls[$i][0],$SForm)
					ControlMove($SForm,"",$WinControls[$i][0],$CtrlPos[0]-$WinWidth,$CtrlPos[1])
				EndIf
			Next
		Case $WS_HORIZONTAL
			If $PxToCut = $WS_HALF Then $PxToCut = $WinHeight/2
			$PxToCut = $WinHeight - $PxToCut
			WinMove($hwnd,"",$WinX,$WinY,$WinWidth,$WinHeight-$PxToCut)
			$SForm = GUICreate(WinGetTitle($hwnd),-1,-1,-1,-1,$Style[0],$Style[1],$Parrent)
			WinMove($SForm,"",$WinX,$WinY+($WinHeight-$PxToCut)+10,$WinWidth,$WinHeight-_WinAPI_GetWindowHeight($hwnd))
			$WinHeight = _WinAPI_GetWindowHeight($hwnd)
			For $i = 1 To $WinControls[0][0]
				$CtrlPos = ControlGetPos($SForm,"",$WinControls[$i][0])
				If Not IsArray($CtrlPos) Then Return -4
				If $CtrlPos[1] > $WinHeight Then
					_WinAPI_SetParent($WinControls[$i][0],$SForm)
					ControlMove($SForm,"",$WinControls[$i][0],$CtrlPos[0],$CtrlPos[1]-$WinHeight)
				EndIf
			Next
	EndSwitch
	GUISetState(@SW_SHOW,$SForm)
	Return $SForm
EndFunc

Func _WinSplitStartUp()
	Opt("GUIResizeMode",802)
	$WinCutStartUp = True
EndFunc

Func WinListChildren($hWnd, ByRef $avArr)
    If UBound($avArr, 0) <> 2 Then
        Local $avTmp[10][2] = [[0]]
        $avArr = $avTmp
    EndIf

    Local $hChild = _WinAPI_GetWindow($hWnd, $GW_CHILD)

    While $hChild
        If $avArr[0][0]+1 > UBound($avArr, 1)-1 Then ReDim $avArr[$avArr[0][0]+10][2]
        $avArr[$avArr[0][0]+1][0] = $hChild
        $avArr[$avArr[0][0]+1][1] = _WinAPI_GetWindowText($hChild)
        $avArr[0][0] += 1
        WinListChildren($hChild, $avArr)
        $hChild = _WinAPI_GetWindow($hChild, $GW_HWNDNEXT)
    WEnd

    ReDim $avArr[$avArr[0][0]+1][2]
EndFunc
