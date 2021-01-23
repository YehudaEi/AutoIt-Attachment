#include <GUIConstants.au3>
#NoTrayIcon
;~Scriped by MrBloody send all feed back (good or bad) tothis post ^_^

#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Bloody's AD CALC", 276, 256, 293, 189)
$Label1 = GUICtrlCreateLabel("AD Calc", 40, 8, 192, 36)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
$a = 0
$OK = GUICtrlCreateButton("Calc", 176, 216, 75, 25)
$ADLVL = GUICtrlCreateInput("10", 80, 48, 65, 21)
$Label2 = GUICtrlCreateLabel("AD LVL", 8, 48, 52, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Player INT", 8, 88, 68, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$PLYINT = GUICtrlCreateInput("103", 80, 88, 65, 21)
$Group1 = GUICtrlCreateGroup("AD DMG", 160, 40, 97, 57)
$Label4 = GUICtrlCreateLabel("0", 168, 56, 86, 36)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("AD to KILL MOB", 160, 104, 97, 65)
$Label5 = GUICtrlCreateLabel("0", 168, 120, 86, 36)
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$MOBVIT = GUICtrlCreateInput("12", 80, 128, 65, 21)
$Label6 = GUICtrlCreateLabel("MOB VIT", 8, 128, 59, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$MOBHP = GUICtrlCreateInput("7472", 80, 184, 185, 21)
$M = GUICtrlCreateLabel("MOB HP", 8, 184, 56, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Button2 = GUICtrlCreateButton("CLOSE\EXIT", 16, 216, 75, 25)
$reset = GUICtrlCreateButton("RESET", 96, 216, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;~

;(0.7 + Monster vit * Player int ^ 2)/(monster vit+ player int))*(AD-LVL)

While 1
    Switch GUIGetMsg()
					
        Case $OK
			$AD = GUICtrlRead($ADLVL)
			$PLINT = GUICtrlRead($PLYINT) 
			$MBVIT = GUICtrlRead($MOBVIT) 
			$MHP = GUICtrlRead($MOBHP) 
			
			
			$t = _Dtotal()
			$tt = _total()
			
			Sleep(200)
			While 2
				If $AD <= 0  Or $PLINT <= 0 Or $MBVIT <= 0 Or $MHP <= 0  or $AD >= 11 Then
					MsgBox(1,"ERROR","Please enter an number  in all input boxes & not only 10 LVL's in AD ^_^")
					ExitLoop
				Else
					$t = _Dtotal()
					GUICtrlSetData($Label4, $t)
					$tt = _total()
					if $tt <= 1 Then $tt = 1
					GUICtrlSetData($Label5, $tt)
					ExitLoop
					
				EndIf
			WEnd
		Case $reset
			$xxx = 0
			GUICtrlSetData ($ADLVL, $xxx)
			GUICtrlSetData ($PLYINT, $xxx)
			GUICtrlSetData ($MOBVIT, $xxx)
			GUICtrlSetData ($MOBHP, $xxx)
								
				
        Case $GUI_EVENT_CLOSE, $Button2
            ExitLoop
    EndSwitch
Wend

Func _Dtotal()
	$1total = (0.7 * $MBVIT * ($PLINT * $PLINT))
	$2total = ($MBVIT + $PLINT)
	$3total = ($1total / $2total)
	$4total = $3total * $AD
	$t = $4total
	Return 	$t
EndFunc

Func _total()
	$total6 = ($MHP / $t) 
	$x=0
	If $MHP <= $t  Then
		$tt = 1
	Else
		If $total6 > Round($total6, 0) Or Round($total6, 0) = 0 Then
		$x = Round($total6, 0) + 1
		
		EndIf	
	EndIf
		$tt = $x
		Return $tt
EndFunc
	

	







