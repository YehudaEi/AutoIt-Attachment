; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         AlexV <alexandre.vincent@righthemisphere.com>
;
; Script Function:
;	A Script that compute the pixel checksum of a control
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>

;Setting options
AutoItSetOption("PixelCoordMode",0)

;global variable
dim $ckstring, $ctrlPos[4], $mousePos[2]
$exitrequest=0

HotKeySet("{F1}","ComputeCKSum")
Func ComputeCKSum()
	BlockInput(1)
	$cksum = PixelChecksum($ctrlPos[0],$ctrlPos[1],$ctrlPos[0]+$ctrlPos[2],$ctrlPos[1]+$ctrlPos[3])
	;TODO : 
	; - add a progress bar ?
	$ckstring="CKSUM = " & string($cksum)
	;GUICtrlSetData($editID,$xystring& @CRLF &$whstring & @CRLF & $ckstring)
	BlockInput(0)
EndFunc

HotKeySet("{ESC}","Terminate")
Func Terminate()
	$exitrequest=1
EndFunc

;GUI dialog Creation
GUICreate("Control Pixel Checksum",230,130,0,0,$WS_OVERLAPPEDWINDOW,$WS_EX_TOPMOST)
GUICtrlCreateLabel("- Press F1 to compute Checksum " &@CRLF&"  for the control under the mouse," & @CRLF &"- Or press Esc to close.",5,5,225,50)
$editID=GUICtrlCreateEdit("",5,60,220,60,$ES_READONLY)
GUISetState (@SW_SHOW)

; Run the GUI until the dialog is closed
; and detect string changes
$mousestring="Mouse ( X , Y ) = "
$xystring="( X , Y ) = "
$whstring="( W , H ) = "
$ckstring="CKSUM = ???"
dim $old[4]
$old[0]=""
$old[1]=""
$old[2]=""
$old[3]=""
$lastcontrol=0
do

	;getting the Control under the mouse
	;TODO : improve control detection...
	do
		$hoverControl = GUIGetCursorInfo();
		;always control on the foreground window, but need the active one, same way than in the AutoIT Windows Info
		;TODO !!!!!
		$mousePos[0] = $hoverControl[0]
		$mousePos[1] = $hoverControl[1]
		;Creation of the strings to display the checksum
		$mousestring="Mouse ( X , Y ) = " & "( " & string($mousePos[0]) & " , " & string($mousePos[1]) & " )"
		if $hoverControl[4]=0 Then ; no control hovered
			$ckstring="CKSUM = No control hovered..."
			$xystring="( X , Y ) = "
			$whstring="( W , H ) = "
		Else
			Do
				$ctrlPos = ControlGetPos("","",$hoverControl[4])
			until @error=0
			;Creation of the strings to display the checksum
			$xystring="( X , Y ) = " & "( " & string($ctrlPos[0]) & " , " & string($ctrlPos[1]) & " )"
			$whstring="( W , H ) = " & "( " & string($ctrlPos[2]) & " , " & string($ctrlPos[3]) & " )"
			if $hoverControl[4]<>$lastcontrol then ; not the last computed control 
				$ckstring="CKSUM = ???"
			EndIf
		EndIf
		$lastcontrol=$hoverControl[4]
	Until $old[0]<>$mousestring or $old[1]<>$xystring or $old[2]<>$whstring or $old[3]<>$ckstring
	
	GUICtrlSetData($editID,$mousestring& @CRLF &$xystring& @CRLF &$whstring & @CRLF & $ckstring)
	;to detect string update
	$old[0]=$mousestring
	$old[1]=$xystring
	$old[2]=$whstring
	$old[3]=$ckstring
	$msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then Terminate()
until $exitrequest=1

