#include<guiconstants.au3>
#include<WindowsConstants.au3>

$temp=cadre_select()
$st  = ""
$st &= "   X (horizontal) :     "&$temp[0] & @CRLF
$st &= "   Y (vertical) :          "&$temp[1] & @CRLF & @CRLF
$st &= "   Largeur/width :    "&$temp[2] & @CRLF
$st &= "   Hauteur/width :   "&$temp[3] & @CRLF
MsgBox(0,"Position & taille(size)",$st)
ConsoleWrite($temp[0] &" "& $temp[1] &" "& $temp[2] &" "& $temp[3])  ;for console work...
Exit

Func cadre_select($glarg=600,$ghaut=300)
	Local $x,$y,$gui,$msg,$st
	Local $bt0,$btleft,$btright,$bthaut,$btbas,$btlplus,$btlmoins,$bthplus,$bthmoins,$btlplus2,$btlmoins2,$bthplus2,$bthmoins2
	Local $aret[4],$pos

	$x=80
	$y=70

	$gui = GUICreate("cadre_select",$glarg,$ghaut,$x,$y,$WS_POPUP)
	GUISetBkColor(0xFF8888,$gui)

	$btaide = GUICtrlCreateButton("Echap", 0, -400, 50, 20)
	$bt0 = GUICtrlCreateButton("Echap", 0, -400, 50, 20)

	$btleft = GUICtrlCreateButton("<=", 0, -300, 50, 20)
	$btright = GUICtrlCreateButton("=>", 100, -300, 50, 20)
	$bthaut = GUICtrlCreateButton("haut", 200, -300, 50, 20)
	$btbas = GUICtrlCreateButton("bas", 300, -300, 50, 20)

	$btlplus= GUICtrlCreateButton("l+", 0, -200, 50, 20)
	$btlmoins= GUICtrlCreateButton("l-", 100, -200, 50, 20)
	$bthplus= GUICtrlCreateButton("h+", 200, -200, 50, 20)
	$bthmoins= GUICtrlCreateButton("h-", 300, -200, 50, 20)

	$btlplus2= GUICtrlCreateButton("l+2", 0, -100, 50, 20)
	$btlmoins2= GUICtrlCreateButton("l-2", 100, -100, 50, 20)
	$bthplus2= GUICtrlCreateButton("h+2", 200, -100, 50, 20)
	$bthmoins2= GUICtrlCreateButton("h-2", 300, -100, 50, 20)

	Local $AccelKeys[14][2] = [["{F1}", $btaide],["{ESC}", $bt0],["{left}", $btleft],["{right}", $btright],["{up}", $bthaut],["{down}", $btbas] ,["^{left}", $btlmoins],["^{right}", $btlplus],["^{up}", $bthmoins],["^{down}", $bthplus] ,["!{left}", $btlmoins2],["!{right}", $btlplus2],["!{up}", $bthmoins2],["!{down}", $bthplus2]]
	GUISetAccelerators($AccelKeys)

	GUISetState(@SW_SHOW,$gui)
	WinSetTrans($gui,"",128)
	WinActivate($gui)
	$pos=MouseGetPos()
	$x=$pos[0] 
	$y=$pos[1]
	WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)

	While 1
		$msg = GUIGetMsg(1)
		Switch $msg[0]
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $bt0
				ExitLoop
			Case $btaide
				$st=""
				$st &= " Déplacer le cadre avec la souris, ou avec les quatre flèches ;" & @CRLF
				$st &= " {Ctrl} + quatre flèches change la taille du cadre ;" & @CRLF
				$st &= " {Alt} + quatre flèches change doucement la taille du cadre ;" & @CRLF
				$st &= " {Echap} termine."
				$st=""
				$st &= " Move the box with mouse, or four arrows_keys ;" & @CRLF
				$st &= " {Ctrl} + four arrows_keys change the size of the box ;" & @CRLF
				$st &= " {Alt} + four arrows_keys change, slowly, the size of the box ;" & @CRLF
				$st &= " {ESC} exit."
				MsgBox(0,"Cadre(Box)_Select",$st)
				$st=""
			Case $btleft
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$x-=1
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $btright
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$x+=1
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $bthaut
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$y-=1
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $btbas
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$y+=1
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)

			Case $btlplus
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$glarg+=16
				$x+=8
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $btlmoins
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$glarg-=16
				$x-=8
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $bthplus
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$ghaut+=16
				$y+=8
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $bthmoins
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$ghaut-=16
				$y-=8
				MouseMove($x,$y)
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)

			Case $btlplus2
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$glarg+=1
				If Int($glarg/2)*2=$glarg Then
					$x+=1
					MouseMove($x,$y)
				EndIf
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $btlmoins2
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$glarg-=1
				If Int($glarg/2)*2=$glarg Then
					$x-=1
					MouseMove($x,$y)
				EndIf
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $bthplus2
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$ghaut+=1
				If Int($ghaut/2)*2=$ghaut Then
					$y+=1
					MouseMove($x,$y)
				EndIf
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
			Case $bthmoins2
				$pos=MouseGetPos()
				$x=$pos[0]
				$y=$pos[1]
				$ghaut-=1
				If Int($ghaut/2)*2=$ghaut Then
					$y-=1
					MouseMove($x,$y)
				EndIf
				WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)

		EndSwitch

		If Not WinActive($gui) Then
			WinActivate($gui)
		EndIf
		$pos=MouseGetPos()
		If $x<>$pos[0] Or $y<>$pos[1] Then
			$x=$pos[0]
			$y=$pos[1]
			WinMove($gui, "", $x-($glarg/2), $y-($ghaut/2), $glarg, $ghaut)
		EndIf
		sleep(10)
	WEnd
	GUISetAccelerators(0)
	GUIDelete($gui)
	$aret[0]=$x
	$aret[1]=$y
	$aret[2]=$glarg
	$aret[3]=$ghaut
	Return $aret
EndFunc
