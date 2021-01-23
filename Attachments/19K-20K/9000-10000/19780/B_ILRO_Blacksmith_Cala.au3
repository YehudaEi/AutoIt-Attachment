#include <GUIConstants.au3>
#Region ### START Koda GUI section ### Form=c:\documents and settings\matthew  bloodgood\my documents\test\b-ilro_blacksmith_cala.kxf
$dlgTabbed = GUICreate("Bloody's RevIllusion BlackSmithing Calc (Beta vs 2.0.0.2) ", 671, 148, 192, 119)
GUISetIcon("D:\005.ico")
$pr=0
$wl=0
$PageControl1 = GUICtrlCreateTab(103, 8, 400, 55)
$TabSheet1 = GUICtrlCreateTabItem("Dagger")
$Combo1 = GUICtrlCreateCombo("NONE", 136, 35, 330, 25)
GUICtrlSetData(-1," KNIFE | CUTTER | MAIN GAUCHE | DIRK | DAGGER | STILETTO | GLADIUS | DAMASCUS ") 
GUICtrlSetState(-1,$GUI_SHOW) ;~~  SHOW FIRST
;~~ End Tab 1 (0)
$TabSheet2 = GUICtrlCreateTabItem(" Sword ")
$Combo2 = GUICtrlCreateCombo("NONE", 136,  35, 330, 25)
GUICtrlSetData(-1," SWORD | FALCHION | BLADE | RAPIER | SCIMITAR | RING POMMEL SABER | SABER | HAEDONGGUM | TSURUGI | FLAMBERGE ")  
;~~ end tab 2 (1)
$TabSheet3 = GUICtrlCreateTabItem("Two-Handed Sword")
$Combo3 = GUICtrlCreateCombo("NONE", 136,  35, 330, 25)
GUICtrlSetData(-1," KATANA | SLAYER | BASTARD SWORD | TWO-HANDED SWORD | BROAD SWORD | CLAYMORE ") 
;~~ End tab 3 (2)
$TabSheet4 = GUICtrlCreateTabItem(" Axe")
$Combo4 = GUICtrlCreateCombo("NONE", 136,  35, 330, 25)
GUICtrlSetData(-1," AXE | BATTLE AXE | HAMMER | BUSTER | TWO-HANDED AXE ") 
;~~ Eand tab 4 (3)
$TabSheet5 = GUICtrlCreateTabItem("Brass Knuckle")
$Combo5 = GUICtrlCreateCombo("NONE", 136,  35, 330, 25)
GUICtrlSetData(-1," WAGHNAK | KNUCKLE DUSTER | STUDDED KNOKLES | FIST | CLAW | FINGER ") 
;~~ Eand tab 5 (4)
$TabSheet6 = GUICtrlCreateTabItem(" Spear")
$Combo9 = GUICtrlCreateCombo("NONE", 136,  35, 330, 25)
GUICtrlSetData(-1," JAVELIN | SPEAR | PIKE | GUISARME | GLAIVE | PARTIZAN | TRIDENT | HALBERD | LANCE ") 
;~~ Eand tab 6 (5)
$TabSheet7 = GUICtrlCreateTabItem(" Mace")
$Combo10 = GUICtrlCreateCombo("NONE", 136,  35, 330, 25)
GUICtrlSetData(-1," CLUB | MACE | SMASHER | FAIL | CHAIN | MORNING STAR | SWORD MACE | STUNNER ") 
;~~ Eand tab 6 (5)
GUICtrlCreateTabItem("")
;~End Tab items
$EXIT = GUICtrlCreateButton("&EXIT", 270, 104, 75, 25, 0)
$OK = GUICtrlCreateButton("&OK", 350, 104, 75, 25, 0)
$JOB = GUICtrlCreateInput("0", 56, 8, 33, 21)
$DEX = GUICtrlCreateInput("0", 56, 40, 33, 21)
$LUC = GUICtrlCreateInput("0", 56, 72, 33, 21)
$Label1 = GUICtrlCreateLabel("JOB LVL", 8, 13, 46, 17)
$Label2 = GUICtrlCreateLabel("DEX LVL", 8, 44, 48, 17)
$Label3 = GUICtrlCreateLabel("LUC LVL", 8, 76, 47, 17)
$SLVL = GUICtrlCreateInput("1", 56, 104, 33, 21)
$Label4 = GUICtrlCreateLabel("Skill LvL", 8, 109, 44, 17)
$Combo6 = GUICtrlCreateCombo("No ANVIL", 112, 72, 145, 25)
GUICtrlSetData(-1," Normal Anvil | Oridecon Anvil | Golden Anvil | Emperium ") 
$Combo7 = GUICtrlCreateCombo(" No Star Crumb ", 272, 72, 145, 25)
GUICtrlSetData(-1," 1 Star Crum | 2 Star Crum | 3 Star Crum ") 
;~~ -15% Per Star Crum
$Combo8 = GUICtrlCreateCombo("NO Ench. Stone", 112, 104, 145, 25)
GUICtrlSetData(-1," Flame Heart | Mystic Frozen | Grat Nature | Rought Wind ") 
;~~ Elem. Stone -20%
$Group1 = GUICtrlCreateGroup("Percentage", 520, 16, 137, 105)
$Label5 = GUICtrlCreateLabel($pr, 536, 48, 97, 52)
GUICtrlSetFont(-1, 30, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;~~End interface

While 1
    Switch GUIGetMsg()
        Case $OK
            $id = _getBOX()
			$LVL = _getLVL()
			$Avilt = _getANVIL()
			$Stone = _getESTONE()
			$Crum = _getSCRUM()
			$SKilvl = _getskill()
			Sleep(100)
			$SL = GUICtrlRead($SLVL)

			$J = GUICtrlRead($JOB) 
			$D = GUICtrlRead($DEX) 
			$L = GUICtrlRead($LUC) 
			$An = GUICtrlRead($Avilt) 
			$t = _total()
			
			Sleep(200)
			While 2
				If $J = 0  Or $D = 0 Or $L = 0 Or $LVL = 0 or $SL = 0 or $SL >= 4 Then
					MsgBox(1,"ERROR","Please enter an number from 1~999 in all input boxes & or select a weopon to make")
					ExitLoop
				Else
					If   $LVL > $SKilvl Then
						MsgBox(1,"Can Not Make","You can not make this item")
						ExitLoop
					Else
						If  $Crum = 3 & $Stone = 0.20  Then
							MsgBox(1,"Can Not Make","It is not posable to make this item")
						ExitLoop
						Else		
						$t = _total()
						GUICtrlSetData($Label5, $t)
						ExitLoop
						EndIf
					EndIf
				EndIf
			WEnd
        Case $GUI_EVENT_CLOSE, $EXIT
            ExitLoop
    EndSwitch
Wend


Func _total()
	If $LVL = 1 Then
		
			If $Avilt >= 0 & $Stone >= 0 & $LVL = 1 & $Crum >= 0  Then
				$crumy = $Crum
				$stoner = $Stone
				$any = $Avilt
				$totals1 = (5 * $SL) + ($J * 0.2) + ($D * 0.1) + ($L * 0.1) + 50
				$totals2 = $totals1 * (($crumy + $stoner) - $any)
				$total = $totals1 - $totals2
				Return $total
			EndIf;~Compleat
			
			
	EndIf
	;~~ 
	If $LVL = 2 Then
		
		$normbase2 = (5 * $SL) + ($J * 0.2) + ($D * 0.1) + ($L * 0.1) +50
		$basepercent = $normbase2-$normbase2*.2
		;~~
		If $Avilt >= 0 & $Stone >= 0 & $LVL = 2 & $Crum >= 0  Then
				$crumy = $Crum
				$stoner = $Stone
				$any = $Avilt
				$totals2 = $normbase2 * (($crumy + $stoner + .2) - $any)
				$total = $normbase2 - $totals2
				Return $total
			EndIf;~End stone test lvl 2 with out anvil
			EndIf
		

	If $LVL = 3 Then
		;~~
		$normbase3 = (5 * $SL) + ($J * 0.2) + ($D * 0.1) + ($L * 0.1) +50
		$basepercent = $normbase3-$normbase3*.3

		;~~
		If $Avilt >= 0 & $Stone >= 0 & $LVL = 3 & $Crum >= 0  Then
				$crumy = $Crum
				$stoner = $Stone
				$any = $Avilt
			
				$totals3 = $normbase3 * (($crumy + $Stone + .3) - $any)
				$total = $normbase3 - $totals3
				Return $total
			EndIf;~End stone test lvl 3  with out anvil
			EndIf
		
EndFunc




Func _getskill()
	Switch GUICtrlRead($SLVL)
		Case '1',' 1','1 '
			$s = 1
		Case '2',' 2','2 '
			$s = 2
		Case '3',' 3','3 '
			$s = 3
	EndSwitch
	Return $s
EndFunc

Func _getBOX()
    Switch GUICtrlRead($PageControl1)   ;get active tab page index
        Case 0  ;dagger
            $box = $Combo1
        Case 1  ;1h sword
            $box = $Combo2
        Case 2 ;2h sword
            $box = $Combo3
		Case 3 ;Axe
			$box = $Combo4
		Case 4 ;Brass Knuckle
			$box = $Combo5
		Case 5 ;Spear
			$box = $Combo9
		Case 6 ;club
			$box = $Combo10
    EndSwitch
    Return $box ;send value to $box
EndFunc  ;end _getBOX 

Func _getLVL()
	Switch GUICtrlRead($id) 
		Case 'NONE'
			$WL = 0
		Case ' SWORD ',' FALCHION ',' BLADE ',' KNIFE ',' CUTTER ',' MAIN GAUCHE ',' KATANA ',' AXE ',' BATTLE AXE ',' CLUB ',' MACE ',' WAGHNAK ',' JAVELIN ',' SPEAR ',' PIKE '
			$WL = 1
			;~END WL 1
		Case ' RAPIER ',' SCIMITAR ',' RING POMMEL SABER ',' DIRK ',' DAGGER ',' STILETTO ',' SLAYER ',' BASTARD SWORD ',' HAMMER ',' SMASHER ',' FAIL ',' CHAIN ',' KNUCKLE DUSTER ',' STUDDED KNOKLES','GUISARME','GLAIVE','PARTIZAN'
			$WL = 2
			;~END WL 2
		Case ' SABER ' ,' HAEDONGGUM ',' TSURUGI ',' FLAMBERGE ',' GLADIUS ',' DAMASCUS ',' TWO-HANDED SWORD ',' BROAD SWORD ',' CLAYMORE ',' BUSTER ',' TWO-HANDED AXE ',' MORNING STAR ',' SWORD MACE ',' STUNNER ',' FIST ',' CLAW ',' FINGER ',' TRIDENT ',' HALBERD ',' LANCE '
			$WL = 3
			;~END WL 3
	EndSwitch
	Return $WL
EndFunc ;~end _getlvl

Func _getANVIL() ;~haven't in tthe calc yet
	Switch GUICtrlRead($Combo6)
	Case 'No ANVIL'
		$Anvil = 0
	Case ' Normal Anvil '
		$Anvil = 0
	Case ' Oridecon Anvil '
		$Anvil = 0.03
	Case ' Golden Anvil '
		$Anvil =  0.05
	Case ' Emperium ' 
		$Anvil =  0.1
	EndSwitch
	Return $Anvil
EndFunc ;~end getANVIL "$Anvil"

Func _getESTONE() ;~haven't in tthe calc yet
	Switch GUICtrlRead($Combo8)
		Case 'NO Ench. Stone'
			$ESTONE = 0
		Case  ' Star Crum ',' Flame Heart ',' Mystic Frozen ',' Grat Nature ',' Rought Wind '
			$ESTONE = 0.20
	EndSwitch
	Return $ESTONE
EndFunc ;~end getSTONE "$ESTONE"

Func _getSCRUM() ;~ is all messed up
	Switch GUICtrlRead($Combo7)
		Case ' No Star Crumb '
			$SCrum = 0
		Case ' 1 Star Crum '
			$SCrum = 0.15
		Case ' 2 Star Crum ' 
			$SCrum = 0.30
		Case ' 3 Star Crum '
			$SCrum = 0.45
	EndSwitch
	Return $SCrum
EndFunc ;~~end getSCRUM "$SCrum"



