;#include <GuiConstants.au3>
#include-once
#include <GuiConstants.au3>
;Dont remove this line !
Dim $maxpb[100]
; _CreateProcessBar()
; - Creates a ProcessBar with Color !
;    -  Input :
;        $Process     - Starts with?
;        $x , $y         - Positions  of the Progress
;        $wight,$heigh- Size of the bar
;        $color         - Color of the Bar (% got a different 1)
;        $style         - 2 selfmade styles xD, choose from 1 or 2 both look cool^^
;    - Return Values :
;        $aVaR[0]      - returns the current proces number (1-100)
;        $aVaR[1]      - x pos
;        $aVaR[2]      - y pos
;        $aVaR[3]      - containes the mainbarID
;        $aVaR[4]      - containes the wight
;        $aVaR[5]      - containes the height
;        $aVaR[6]      - returns the backround label^^
;    - Contact :
;        email : Busti_ownz@yahoo.de
;        icq : 269-424-176
;
; - Function by Busti (c)
Func _CreateProcessBar($Process = 1, $x = 30, $y = 30, $widht = 100, $height = 20, $color = 0xFFFFF,$style=1)
    Local $FirstStart, $sZMaxLabel
    Dim $aVaR[7]
    If $Process <= 1 Then $FirstStart = 1
    If $Process > 100 Then Return 0
    If $FirstStart <> 0 Then
        If $style = 1 Then
            $sZMaxLabel = GUICtrlCreateLabel("", $x - 1, $y - 1, $widht, $height + 2,$SS_SUNKEN+$SS_CENTER)
        ElseIf $style = 2 Then
            $sZMaxLabel = GUICtrlCreateLabel("", $x - 1, $y - 1, $widht, $height + 2,$SS_CENTER)
        Else
            $sZMaxLabel = GUICtrlCreateLabel("", $x - 1, $y - 1, $widht, $height + 2,$SS_SUNKEN+$SS_CENTER)
        EndIf
        GUICtrlSetBkColor($sZMaxLabel, 0x00000)
        GUICtrlSetColor($sZMaxLabel, Dec($color)*2)
    Else
        GUICtrlSetData($sZMaxLabel, $Process)
    EndIf
    $MainBar = GUICtrlCreateLabel("", $x, $y, $widht - 1, $height,$SS_CENTER)
    GUICtrlSetBkColor($MainBar, $color)
    GUICtrlSetColor($MainBar, Dec(Random((($color)*2)+100*100,(($color)*2)*2,1)))
    $aVaR[0] = $Process - 1
    $aVaR[1] = $x
    $aVaR[2] = $y
    $aVaR[3] = $MainBar
    $aVaR[4] = $widht - 1
    $aVaR[5] = $height
    $aVaR[6] = $sZMaxLabel
    Return $aVaR
EndFunc ;==>_CreateProcess
; _UpdateProcessBar()
; - Updates a ProcessBar and its possible to change color of it^^ !
;    -  Input :
;        $Bar    - The ID of the bar youve createt^^
;        $update    - incrase current amount + ((( 12 + 50 = 62 )))
;        $color    - bg color! (text color changes automaticle)
;    - Return Values :
;        none
;    - Contact :
;        email : Busti_ownz@yahoo.de
;        icq : 269-424-176
;
; - Function by Busti (c)
; - Special ThanX to :
; - Jaenster for : $Bar[4]/100*$update
; wich is not 100% correct but enough for now^^
Func _UpdateProcessBar(ByRef $Bar,$update,$color=-1)
	$nupdate = $update
	$update += ($Bar[4] / 100 * $update)

    If $update >= $Bar[4] Then
		GUICtrlSetData( $Bar[3] , "100 %" )
		Return 0
    EndIf
    If IsArray($Bar) = 1 Then
        GUICtrlSetPos($Bar[3], $Bar[2], $Bar[1], $update, $Bar[5])
        If $color = -1 Then
        Else
            GUICtrlSetBkColor($Bar[3],$color)
            GUICtrlSetColor($Bar[3],Dec(Random((($color)*2)+100*100,(($color)*2)*2,1)))
        EndIf        
		GUICtrlSetData( $Bar[3] , $nupdate & " %" )
EndIf
	If $update <= $Bar[4] Then 
		Return 0
	Else
		Return 1
	EndIf
EndFunc ;==>_UpdateProcess

; _DeleteProcessBar()
; - Deletes a ProcessBar !
;    -  Input :
;        $Bar    - The ID of the bar you wanna kill!
;    - Return Values :
;        Succes = 1
;        Failure = 0
;    - Contact :
;        email : Busti_ownz@yahoo.de
;        icq : 269-424-176
;
; - Function by Busti (c)
Func _DeleteProcessBar($Bar)
    If IsArray($Bar) = 1 Then
        GUICtrlDelete($Bar[3])
        GUICtrlDelete($Bar[6])
        Return 1
    EndIf
    Return 0
EndFunc ;==>_DeleteProcessBar

; _OnMouseOver()
; - Checks if the mouse is over a Control !
;    -  Input :
;        $CheckFor    - The Control you want to Check!
;		 $Window	  - The window, youre searching in!
;    - Return Values :
;        Succes = 1
;        Failure = 0
;    - Contact :
;        email : Busti_ownz@yahoo.de
;        icq : 269-424-176
;
; - Function by Busti (c)
Func _OnMouseOver($CheckFor,$window="")
	$mp = GUIGetCursorInfo($window)
	If IsArray($mp) Then
		If $mp[4] = $CheckFor Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
	Return 0
EndFunc