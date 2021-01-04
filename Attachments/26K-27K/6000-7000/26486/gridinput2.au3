#include-once
#include <GuiConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <GuiEdit.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <GUIScrollBars.au3>
#include <ScrollBarConstants.au3>

#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Timers.au3>
#include <Array.au3>
#include <file.au3>
#include <String.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <Constants.au3>


$GestionError = ObjEvent("AutoIt.Error", "GestionError")

Global $s_GuiFocus_LastClassName="",$s_FocusNew="",$llFocus=1,$ccFocus=1
Global $dossier,$utilisateur,$passe

Global $scroll_ylig=25
Global $scroll_ypage=10  ; (en nb lignes)
Global $scroll_win=0
Global $ytotal
Global $fillehaut


$dossier="defaut"
$utilisateur="u"
saiod1(True)
Exit

	

Func xGUIScrollBars_Init($hWnd)
	If Not IsHWnd($hWnd) Then Return SetError(-1, -1, 0)
	Local $hdc
	Local $tSCROLLINFO = DllStructCreate($tagSCROLLINFO)
	$tSCROLLINFO = DllStructCreate($tagSCROLLINFO)
	DllStructSetData($tSCROLLINFO, "fMask", 2)
	DllStructSetData($tSCROLLINFO, "nMin", -1)
	DllStructSetData($tSCROLLINFO, "nMax", -1)
	DllStructSetData($tSCROLLINFO, "nPage", 15)

	$hdc = DllCall("User32.dll", "hwnd", "GetDC", "hwnd", $hWnd)
	$hdc = $hdc[0]
	DllStructSetData($tSCROLLINFO, "cbSize", DllStructGetSize($tSCROLLINFO))
	DllCall("User32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "hwnd", $hdc)
	_GUIScrollBars_ShowScrollBar($hWnd, $_SCROLLBARCONSTANTS_SB_VERT, False)
	_GUIScrollBars_ShowScrollBar($hWnd, $_SCROLLBARCONSTANTS_SB_VERT)
	_GUIScrollBars_SetScrollInfo($hWnd, $_SCROLLBARCONSTANTS_SB_VERT, $tSCROLLINFO)
EndFunc   ;==>xGUIScrollBars_Init



Func saiod1($scroll=True)
	Local $AccelKeys, $gui, $atmp, $hListView, $clef, $tmp, $temp
	Local $contextmenu, $pmvoir, $pmgerer, $btnotes, $rpquit, $ligne, $xx, $yy

$gui = GUICreate("Gid inputs", 900, 400)
	GUISetBkColor(0xffffaa)

Local $nblig=150, $nbcol=6, $yligne=25  ;nb_lignes ; nb_cols ; hauteur_ligne_par defaut
	Dim $ligt[$nblig]  ;=[30,30,60,30,30,30,30,30,30,30]
	For $i=0 to $nblig-1
		$ligt[$i]=$yligne
	Next
$ligt[3]=50   ; exception de taille (ligne(s))
$ligt[23]=80   ; exception de taille (ligne(s))
	$ytotal=0
	For $i=0 to $nblig-1
		$ytotal+=$ligt[$i]
	Next

Dim $colt[$nbcol]=[80,100,320,90,90,90]			;size
Dim $coll[$nbcol]=["Compte","Tiers","Libellé","Référence","Débit","Crédit"]  ;label
Dim $cola[$nbcol]=["L","L","L","C","R","R"]	 ;align L C R
	$nbcellules=$nbcol*$nblig+1
	Dim $cel[$nblig][$nbcol]
	Dim $hcel[$nbcellules]

$fillehaut=300
$fillevertical=10

If $scroll=True Then
	;$fille = GUICreate("fille", 880, $fillehaut, 10, $fillevertical, $WS_CHILD, $WS_EX_CLIENTEDGE, $gui)
	$fille = GUICreate("fille", 880, $fillehaut, 10, $fillevertical, $WS_CHILD, $WS_EX_CONTROLPARENT, $gui)
	GUISetBkColor(0x88ffaa,$fille)
	xGUIScrollBars_Init($fille)
	GUIRegisterMsg($WM_VSCROLL, "WM_VSCROLL")
	GUISetState(@SW_SHOW,$fille)
endif

	;-----PopMenu-------
	$contextmenu = GUICtrlCreateContextMenu(-1)
	$pmenreg = GUICtrlCreateMenuItem('&Enregistrer', $contextmenu)
	$pmcompte = GUICtrlCreateMenuItem('&Compte (naviguer vers)', $contextmenu)
	$pmtiers = GUICtrlCreateMenuItem('&Tiers (naviguer vers)', $contextmenu)
	GUICtrlCreateMenuItem("", $contextmenu)
	$btnotes = GUICtrlCreateMenuItem('&Bloc-note(s)', $contextmenu)
	GUICtrlCreateMenuItem("", $contextmenu)
	$rpquit = GUICtrlCreateMenuItem('&Quitter (abandonner)', $contextmenu)
	;-----PopMenu-------

	$btpagedown=GUICtrlCreateButton("Down",10,-200,100,40)
	$btpageup=GUICtrlCreateButton("Up",110,-200,100,40)
	$btdown=GUICtrlCreateButton("Down",10,-100,100,40)
	$btup=GUICtrlCreateButton("Up",110,-100,100,40)
	$btins=GUICtrlCreateButton("Ins",210,-100,100,40)
	$btdel=GUICtrlCreateButton("Del",310,-100,100,40)
	$btenter=GUICtrlCreateButton("Enter",410,-100,100,40)
	$btesc = GUICtrlCreateButton("Echap", 510, -100, 100, 40)

	GUICtrlCreateLabel("  {Up}    {Down}    {PgUp}    {PgDown}    {Tab}    {Shift-Tab}    {Ctrl-Ins}    {Ctrl-Del}    {Enter}    {Esc}   etc.  ",30,10,600,30)

	GUISetFont(14,400,0,"Arial Narrow")


	$posh=50
	$posv=60
	For $l=0 To $nblig-1
		$posh=50
		GUICtrlCreateLabel(String($l+1), $posh-25, $posv+7, 20,20,$SS_RIGHT)
		GUICtrlSetFont(-1,9)
		GUICtrlSetColor(-1,0x888888)
		For $c=0 To $nbcol-1
			If $l=0 Then
				GUICtrlCreateLabel($coll[$c], $posh, $posv-20, $colt[$c],20,$SS_CENTER)
				GUICtrlSetFont(-1,10,600)
				GUICtrlSetColor(-1,0x444444)
			EndIf
			$index=$l*$nbcol+$c+1
			$cel[$l][$c]= GUICtrlCreateInput(String($index), $posh, $posv,$colt[$c],$ligt[$l],$ES_UPPERCASE)
			If int($l/2)*2=$l Then
				GUICtrlSetBkColor(-1, 0xeeeeff)
			Else
				GUICtrlSetBkColor(-1, 0xffeeee)
			EndIf
			Switch $cola[$c]
				Case "L"
					GUICtrlSetStyle(-1,$SS_LEFT)
				Case "C"
					GUICtrlSetStyle(-1,$SS_CENTER)
				Case "R"
					GUICtrlSetStyle(-1,$SS_RIGHT)
			EndSwitch
			$posh+=$colt[$c]
		Next
		$posv+=$ligt[$l]
	Next


	GUISetState(@SW_SHOW,$gui)
	;GUISwitch($gui)

	;-----------------------------Accel Keys + boutons--------------------------------------
	Dim $AccelKeys[8][2] = [["{ENTER}", $btenter],["{ESC}", $btesc],["{DOWN}", $btdown],["{UP}", $btup], ["{PGDN}", $btpagedown],["{PGUP}", $btpageup],["^{INS}", $btins],["^{DEL}", $btdel]]
	GUISetAccelerators($AccelKeys)
	;-----------------------------Accel Keys + boutons--------------------------------------


	Sleep(12)
	For $l=0 To $nblig-1
		For $c=0 To $nbcol-1
			$index=$l*$nbcol+$c+1
			$tmp=ControlGetHandle ( "", "",$cel[$l][$c])
			$hcel[$index]=$tmp
		Next
	Next
	GUICtrlSetState($cel[2][2],$GUI_FOCUS)

	$flagNOTIFY = False
	While 1

		$s_FocusNew=ControlGetFocus($gui)
		$tmp=ControlGetHandle ( "", "",$s_FocusNew) 
		If $s_GuiFocus_LastClassName<>$s_FocusNew Then
			If $s_GuiFocus_LastClassName<>"" Then
				;onBlur
				;$pd.msginfo("PONX: onBlur ",$s_GuiFocus_LastClassName) 
			EndIf
			;onFocus
			If Not @error Then
				;$pd.msginfo("PONX: onFocus",$s_FocusNew)
				$iIndex=_ArraySearch($hcel,$tmp)
				If @error<>6 Then
					$llFocus=Int($iIndex/$nbcol)
					$ccFocus=$iIndex-$llFocus*$nbcol
					$llFocus+=1
					If $ccFocus<=0 Then $ccFocus=1
					If $llFocus<1 Then $llFocus=1
					If $llFocus>=$nblig Then $llFocus=$nblig-1
					;$pd.msginfo(String($llFocus),String($ccFocus))					
				EndIf
			EndIf
			$s_GuiFocus_LastClassName = $s_FocusNew	
			$temp=ControlGetPos("","",$cel[$llFocus-1][$ccFocus-1])
			If $temp[1]<$fillevertical Then
				gui_VSCROLL($fille,$fillevertical-$temp[1])
			EndIf
			If $temp[1]>$fillehaut+$fillevertical-$ligt[$llFocus-1] Then
				;msgbox(0,$temp[1],($fillehaut+$fillevertical))
				gui_VSCROLL($fille,($fillehaut+$fillevertical-$ligt[$llFocus-1])-$temp[1])
			EndIf
		EndIf

		$msg = GUIGetMsg($gui)

		If $flagNOTIFY<>False Then
			If $flagNOTIFY = 'Echap' Then
				$msg = $btesc
			EndIf
			$flagNOTIFY = False
		EndIf

		If ($msg = $GUI_EVENT_CLOSE) Or ($msg = $rpquit) Then
			ExitLoop
		EndIf

		If $msg = 0 Then
			Sleep(12)
			ContinueLoop
		EndIf

		If $msg = $btesc Then
			ShowMenu($gui, $hListView, $contextmenu, $xx,$yy)
		EndIf

		If $msg = $btenter Then
			$temp=ControlGetPos("","",$cel[$llFocus-1][$ccFocus-1])
			MsgBox(0,String($temp[0]),String($temp[1]))
			$result ="Ligne   :  "& String($llFocus) &@CRLF
			$result&="Col      :  "& String($ccFocus) &@CRLF &@CRLF
			$result&="Content:  "& String(GUICtrlRead($cel[$llFocus-1][$ccFocus-1]))
			MsgBox(0,"Result",$result)
		EndIf
		If $msg = $btdown Then
			If $llFocus<$nblig Then
				$llFocus+=1
				GUICtrlSetState($cel[$llFocus-1][$ccFocus-1],$GUI_FOCUS)
			EndIf
		EndIf
		If $msg = $btup Then
			If $llFocus>1 Then
				$llFocus-=1
				GUICtrlSetState($cel[$llFocus-1][$ccFocus-1],$GUI_FOCUS)
			EndIf
		EndIf
		If $msg = $btpagedown Then
			If $llFocus<$nblig Then
				$llFocus+=10
				If $llFocus>=$nblig Then $llFocus=$nblig
				GUICtrlSetState($cel[$llFocus-1][$ccFocus-1],$GUI_FOCUS)
			EndIf
		EndIf
		If $msg = $btpageup Then
			If $llFocus>1 Then
				$llFocus-=10
				If $llFocus<1 Then $llFocus=1
				GUICtrlSetState($cel[$llFocus-1][$ccFocus-1],$GUI_FOCUS)
			EndIf
		EndIf

		If $msg = $btins Then
			For $l=$nblig-1 To $llFocus Step -1
				For $c=0 To $nbcol-1
					$tmp=GUICtrlRead($cel[$l-1][$c])
					GUICtrlSetData($cel[$l][$c],$tmp)
				Next
			Next
			For $c=0 To $nbcol-1
				GUICtrlSetData($cel[$llFocus-1][$c],"")
			Next
		EndIf

		If $msg = $btdel Then
			For $l=$llFocus-1 To $nblig-2
				For $c=0 To $nbcol-1
					$tmp=GUICtrlRead($cel[$l+1][$c])
					GUICtrlSetData($cel[$l][$c],$tmp)
				Next
			Next
			For $c=0 To $nbcol-1
				GUICtrlSetData($cel[$nblig-1][$c],"")
			Next
		EndIf

		Sleep(12)
	WEnd
	GUISetAccelerators(0)
	GUICtrlDelete($contextmenu)
	GUIDelete($gui)
EndFunc









Func ShowMenu($hWnd, $CtrlID, $nContextID, $x=250,$y=150)
	; la ligne validée du menu affecte la boucle d'évènements
	Local $hMenu = GUICtrlGetHandle($nContextID)
	;-----------------------------------
	;$pos = ControlGetPos($hWnd, "", $CtrlID)
	;$pos = _WinAPI_GetCursorInfo()  ; position de la souris 
    ;$x = $pos[0]+250
    ;$y = $pos[1]+150
	;MsgBox(0,$x,$y,1)
	ClientToScreen($hWnd, $x, $y)
	;------------------------------------
	TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu


Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	$Ret = DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu


; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y);
    Local $stPoint = DllStructCreate("int;int")

    DllStructSetData($stPoint, 1, $x)
    DllStructSetData($stPoint, 2, $y)

    DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))

    $x = DllStructGetData($stPoint, 1)
    $y = DllStructGetData($stPoint, 2)
    ; release Struct not really needed as it is a local
    $stPoint = 0
EndFunc   ;==>ClientToScreen



Func GestionError()
	$HexNumber = Hex($GestionError.number, 8)
	MsgBox(0, "COM Error", "COM Error " & @CRLF & @CRLF & _
			"description: " & @TAB & $GestionError.description & @CRLF & _
			"windescript:" & @TAB & $GestionError.windescription & @CRLF & _
			"number     : " & @TAB & $HexNumber & @CRLF & _
			"dll-error  : " & @TAB & $GestionError.lastdllerror & @CRLF & _
			"scriptline : " & @TAB & $GestionError.scriptline & @CRLF & _
			"source     : " & @TAB & $GestionError.source & @CRLF & _
			"helpfile   : " & @TAB & $GestionError.helpfile & @CRLF & _
			"helpcontext: " & @TAB & $GestionError.helpcontext _
			)
	SetError(1) ; to check for after this function returns
EndFunc   ;==>GestionError




Func WM_VSCROLL($hWnd, $Msg, $wParam, $lParam)
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $scroll_win_action=0
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)

    Switch $nScrollCode
		Case $SB_TOP ; user clicked the HOME keyboard key
			$scroll_win_action=-$scroll_win

        Case $SB_BOTTOM ; user clicked the END keyboard key
			$scroll_win_action=999  ;************** à définir

        Case $SB_LINEUP ; user clicked the top arrow
			$scroll_win_action=$scroll_ylig

        Case $SB_LINEDOWN ; user clicked the bottom arrow
			$scroll_win_action=-$scroll_ylig

        Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
			$scroll_win_action=$scroll_ylig*$scroll_ypage

        Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
			$scroll_win_action=-$scroll_ylig*$scroll_ypage

        ;Case $SB_THUMBTRACK ; user dragged the scroll box
        ;    DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
    EndSwitch


If ($scroll_win+$scroll_win_action)>0 Then 
	$scroll_win_action=-$scroll_win
EndIf
If ($scroll_win+$scroll_win_action)<-$ytotal Then 
	$scroll_win_action=0
EndIf
	_GUIScrollBars_ScrollWindow($hWnd, 0, $scroll_win_action)  ;fait bouger la fenêtre (en pixels)
	$scroll_win+=$scroll_win_action
	$ypourcentage= Int(-$scroll_win/($ytotal+$fillehaut*2)*100)
	DllStructSetData($tSCROLLINFO, "nPos", $ypourcentage)   ;en % 
    DllStructSetData($tSCROLLINFO, "fMask", 4)
    _GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)  ;fait bouger l'ascenceur (en pourcentage)
    Return $GUI_RUNDEFMSG
EndFunc




Func gui_VSCROLL($hWnd, $qte)
	Local $scroll_win_action=$qte
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)

If ($scroll_win+$scroll_win_action)>0 Then 
	$scroll_win_action=$scroll_win
EndIf
If ($scroll_win+$scroll_win_action) < -$ytotal Then 
	$scroll_win_action=0
EndIf
	_GUIScrollBars_ScrollWindow($hWnd, 0, $scroll_win_action)  ;fait bouger la fenêtre (en pixels)
	$scroll_win+=$scroll_win_action
	$ypourcentage= Int(-$scroll_win/($ytotal+$fillehaut*2)*100)
	DllStructSetData($tSCROLLINFO, "nPos", $ypourcentage)   ;en % 
    DllStructSetData($tSCROLLINFO, "fMask", 4)
    _GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)  ;fait bouger l'ascenceur (en pourcentage)
    Return $GUI_RUNDEFMSG
EndFunc

