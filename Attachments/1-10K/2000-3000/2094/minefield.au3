;------------------
; M I N E F I E L D 4.0
;
; Tested only on WXp
; with 21th April 2005 - v3.1.1.12 (beta) COM25 merge
;------------------

;----------------
; Global Settings
;----------------
#include "GUIConstants.au3"
Opt ("GUIOnEventMode", 1); Allow for OnEvent mode notification
Opt ("MouseCoordMode", 2); relative coords to the active window

;----------
; VARIABLES
;----------
$title = "Minefield v4.0"
$nbmines = 25
$nbminestot = $nbmines
$nbrow = 10
$nbcol = 20
$easyfill = true
$displayhints = true
$clock = 0
$timerclock = 0
$countdown = false
$initcountdown = 1000
$started = false
$win = false
$kaboom = false
$reinit = false
Dim $array_fields[$nbrow][$nbcol]
Dim $array_buttons[$nbrow][$nbcol]
Dim $array_labels[$nbrow][$nbcol]
Dim $array_explore[$nbrow][$nbcol][2]
Dim $array_mines[$nbrow][$nbcol][2]
$nbflags = $nbmines
$nbfields = ($nbrow*$nbcol)-$nbmines
$ToolTip_Error = 0
$CurrentToolTip_Error = 0
$CurrentToolTip_Error_Timer = -1

; ---
; GUI 
; ---

; grid
$gui_minefied = GUICreate($title, $nbcol*21+20, $nbrow*21+140, -1, -1, $WS_SIZEBOX)
GUISetIcon("winmine.exe", 0)
GUISetBkColor( 0xF0E68C, $gui_minefied)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exitminefields")
GUISetOnEvent($GUI_EVENT_SECONDARYUP, "_setflag")

; labels and progress to know how many field (cases) are left
$Label_nbf = GUICtrlCreateLabel("Nb Fields:", 10, 10, 80, 20)
GUICtrlSetResizing($Label_nbf, $GUI_DOCKALL)
$Label_nbfields = GUICtrlCreateLabel(string($nbfields), 70, 10, 30, 20)
GUICtrlSetResizing($Label_nbfields, $GUI_DOCKALL)
ControlFocus ( $title, "", $Label_nbf )
$Label_nbfieldstot = GUICtrlCreateLabel("/" & string($nbfields), 90, 10, 40, 20)
GUICtrlSetResizing($Label_nbfieldstot, $GUI_DOCKALL)
$Progress_nbfields = GUICtrlCreateProgress(130, 10, 210, 20, $PBS_SMOOTH)
GUICtrlSetResizing($Progress_nbfields, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)

; labels and progress to know how many mines are left
$Label_nbm = GUICtrlCreateLabel("Nb Mines:", 10, 30, 80, 20)
GUICtrlSetResizing($Label_nbm, $GUI_DOCKALL)
$Label_nbmines = GUICtrlCreateLabel(string($nbmines), 70, 30, 30, 20)
GUICtrlSetResizing($Label_nbmines, $GUI_DOCKALL)
$Label_nbminestot = GUICtrlCreateLabel("/" & string($nbmines), 90, 30, 30, 20)
GUICtrlSetResizing($Label_nbminestot, $GUI_DOCKALL)
$Progress_nbmines = GUICtrlCreateProgress(130, 30, 210, 20, $PBS_SMOOTH)
GUICtrlSetResizing($Progress_nbmines, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)

; easy fill mode
$Checkbox_easyfill = GUICtrlCreateCheckbox("easy fill", 10, 50, 80, 20,$BS_AUTO3STATE)
GUICtrlSetResizing($Checkbox_easyfill, $GUI_DOCKALL)
GUICtrlSetState($Checkbox_easyfill, $GUI_CHECKED)
GUICtrlSetOnEvent($Checkbox_easyfill, "_inverteasyfill")
GUICtrlSetTip($Checkbox_easyfill,	"easy fill mode: (3 states)" & @LF & _
									"click on an explored field" & @LF & "(that is a button with a number on it) " & @LF & _
									"and it will flag or explore *if possible*" & @LF & "the remaining unexplored fields around it" & @LF & _
									"CHECKED: easy fill AND display hints" & @LF & "   (where can you click in order to explore or flag automatically)" & @LF & _
									"INDETERMINATE: easy fill without any hints" & @LF & "   (you have to find the fields where to click)" & @LF & _
									"UNCHECKED: no easy fill" & @LF & "   (you have to flag manually all mines, even in obvious cases)" _
								  )
; message board
$Label_msg = GUICtrlCreateLabel("", 100, 66, 200, 40)
GUICtrlSetFont ($Label_msg,24, 800)
GUICtrlSetResizing($Label_msg, $GUI_DOCKALL)

; clock ready to tick up or down
$Label_clock = GUICtrlCreateLabel("0000", 10, 68, 60, 30, $ES_RIGHT + $SS_SUNKEN)
GUICtrlSetFont ($Label_clock,18, 800)
GUICtrlSetBkColor($Label_Clock, 0xFFFF66)
GUICtrlSetColor($Label_Clock, 0x0000FF)
GUICtrlSetResizing($Label_clock, $GUI_DOCKALL)
$Input_clock = GUICtrlCreateInput("0000", 10, 68, 60, 30, $ES_NUMBER + $ES_RIGHT + $SS_SUNKEN)
GUICtrlSetState ($Input_clock,$GUI_HIDE)
GUICtrlSetFont ($Input_clock,14, 800)
GUICtrlSetBkColor($Input_clock, 0xFFCC99)
GUICtrlSetColor($Input_clock, 0x0000FF)
GUICtrlSetResizing($Input_clock, $GUI_DOCKALL)
$Checkbox_countdown = GUICtrlCreateCheckbox("", 75, 78, 10, 10)
GUICtrlSetResizing($Checkbox_countdown, $GUI_DOCKALL)
GUICtrlSetOnEvent($Checkbox_countdown, "_setcountdow")
GUICtrlSetTip($Checkbox_countdown, "countdown switch mode:" & @LF & "switch beetween:" & @LF & _
									"- clock (count time from 0 to 9999 seconds);" & @LF & _
									"- countdown (count from a time set by the user to 0)." & @LF & _
									"if the countdown reach 0... KABOOM")

;reset button to reinitialize a game
$Button_reset = GUICtrlCreateButton("Reset", 380, 10, 50,20)
GUICtrlSetOnEvent($Button_reset, "_reset")
GUICtrlSetResizing($Button_reset, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

; fields allowing for settings modifications
$Lbl_nbmines = GUICtrlCreateLabel("nb Mines", 350,43, 50, 20)
GUICtrlSetResizing($Lbl_nbmines, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Input_nbmines = GUICtrlCreateInput ( string($nbmines), 400, 40, 30, 20, $ES_NUMBER+$ES_RIGHT)
GUICtrlSetResizing($Input_nbmines, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Lbl_rowcol = GUICtrlCreateLabel("lig x col", 320,73, 50, 20)
GUICtrlSetResizing($Lbl_rowcol, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Input_row = GUICtrlCreateInput ( string($nbrow), 360, 70, 30, 20, $ES_NUMBER+$ES_RIGHT)
GUICtrlSetResizing($Input_row, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Input_col = GUICtrlCreateInput ( string($nbcol), 400, 70, 30, 20, $ES_NUMBER+$ES_RIGHT)
GUICtrlSetResizing($Input_col, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

; ---------------------
; Main program and Loop
; ---------------------
_reset()

GUISetState ()

While 1
    
	$_c_=1; manage tooltip timer and destruction
    if($ToolTip_Error <> 0 and $ToolTip_Error <> $CurrentToolTip_Error) Then
		$_c_=1; a tootip has just been created: start a timer
        $CurrentToolTip_Error_Timer = 0
        $CurrentToolTip_Error = $ToolTip_Error
    EndIf
    Sleep(20)
    if $started and Not($win) and WinActive($title) Then
        $timerclock = $timerclock + 20
        if mod($timerclock,1000) == 0 Then
            $clock = $clock + 1
            $mclock = StringFormat("%04d",$clock)
            GUICtrlSetData($Label_clock, $mclock)
			$cd = Number(GUICtrlRead($Input_clock))
			If $cd > 0 Then
				$cd = $cd -1
			EndIf
			_countdownSetBkd($cd, $initcountdown)
			$scd = StringFormat("%04d",$cd)
			GUICtrlSetData($Input_clock, $scd)
			if $countdown Then
				If $cd == 0 Then
					_revealall()
					$scd = StringFormat("%04d",$initcountdown)
					GUICtrlSetData($Input_clock, $scd)
					GUICtrlSetData($Label_msg, "Timeout!...")
				EndIf
			EndIf
            $timerclock = 0
		ElseIf $countdown Then
			$cd = Number(GUICtrlRead($Input_clock))
			if $cd <= 10 Then
				If mod($timerclock,300) == 0 Then
					_countdownSetBkd($cd, 0)
				ElseIf mod($timerclock,100) == 0 Then
					_countdownSetBkd($cd, $initcountdown)
				EndIf
			EndIf
        EndIf
    EndIf
    If $CurrentToolTip_Error_Timer >= 0 Then
        $CurrentToolTip_Error_Timer = $CurrentToolTip_Error_Timer + 20
        If $CurrentToolTip_Error_Timer > 2000 Then
			$_c_=1; MsgBox(0,"ttip",string($CurrentToolTip_Error))
			$_c_=1; erase current tooltip, for it does not respond to mouse event... why ?
            ToolTip("")
            $CurrentToolTip_Error = 0
            $ToolTip_Error = 0
            $CurrentToolTip_Error_Timer = -1
        EndIf
    EndIf
	$_c_=1; manage win message
    if $win == false Then
        if $nbfields == 0 And $nbflags == 0 Then
            $win = true
            $amsg = "You win!"
            if $nbmines < 2 Then
                $amsg = "Win! (right...)"
            EndIf
            $started = false
			$initcountdown = $clock
            $mclock = StringFormat("%04d",$clock)
			GUICtrlSetData($Input_clock, $mclock)
            GUICtrlSetData($Label_msg, $amsg)
            GUICtrlSetData($Label_msg, $amsg)
        ElseIf $clock > 9998 Then
            _revealall()
            GUICtrlSetData($Label_msg, "Time's up!...")
        EndIf
    EndIf
WEnd
Exit

;----------
; Functions
;----------
Func _exitminefields()
    Exit
EndFunc

;----------------
; Initialisations
;----------------
func _reset()
	$acursor = MouseGetCursor()
	GUISetCursor(15)
	$reinit = true
    GUICtrlSetData($Label_msg, "")
    $started = false
    GUICtrlSetData($Label_clock,"0000")
	GUICtrlSetBkColor($Input_clock, 0xFFCC99)
	$mclock = StringFormat("%04d",$initcountdown)
	$currentclock = GUICtrlRead($Input_clock)
	if ($win or not($kaboom)) And $currentclock > 0 And $currentclock <> $initcountdown Then
		$mclock = StringFormat("%04d",$currentclock)
	EndIf
	$kaboom = false
    GUICtrlSetData($Input_clock,$mclock)
    $clock = 0
    $timerclock = 0
    For $r = 0 to UBound($array_fields,1) - 1
        For $c = 0 to UBound($array_fields,2) - 1
            $afield = $array_fields[$r][$c]
            if $afield > 0 Then
				GUICtrlSetState($afield, $GUI_HIDE)
                ;GUICtrlDeelete($afield)
            EndIf
        Next
    Next
    For $r = 0 to UBound($array_mines,1) - 1
        For $c = 0 to UBound($array_mines,2) - 1
            $array_mines[$r][$c][0] = 0
            $array_mines[$r][$c][1] = 0
        Next
    Next
    $valid = true
    $anbcol = GUICtrlRead($Input_col)    
	$_c_=1; MsgBox(0, "nbcol", string($anbcol))
    If $anbcol <=0 or $anbcol > 50 Then
        $valid = false
        $ToolTip_Error = _tooltiperror($title, $Input_col, "nb col range", ">0 and <50")
    EndIf
    $anbrow = GUICtrlRead($Input_row)
    If $anbrow <=0 or $anbrow > 50 Then
        $valid = false
        $ToolTip_Error = _tooltiperror($title, $Input_row, "nb row range", ">0 and <50")
    EndIf
    $anbmin = GUICtrlRead($Input_nbmines)
    If $anbmin <0 or $anbmin > ($anbcol*$anbrow) Then
        $valid = false
        $ToolTip_Error = _tooltiperror($title, $Input_nbmines, "nb mines range", ">0 and < nbcol*nbrow")
    EndIf
    $nbmines = $anbmin
    $nbminestot = $nbmines
    $nbrow = $anbrow
    $nbcol = $anbcol
    if $valid Then
        GUICtrlSetData($Label_nbmines, string($nbmines))
        GUICtrlSetData($Label_nbminestot, "/"&string($nbminestot))
        $nbflags = $nbmines
        $nbfields = ($nbrow*$nbcol)-$nbmines
        $win = false
        GUICtrlSetData($Label_nbfields, string($nbfields))
        GUICtrlSetData($Label_nbfieldstot, "/"&string($nbfields))
        GUICtrlSetData($Progress_nbfields, 100)
        GUICtrlSetData($Progress_nbmines, 100)
        $aguipos = WinGetPos($title)
		$_c_=1; MsgBox(0,"res", string($aguipos[0]) & ", " & string($aguipos[1]) & ", " & string($aguipos[2]) & ", " & string($aguipos[3]) & ", " & string(@error))
        $ares = WinMove($title, "", $aguipos[0], $aguipos[1], $nbcol*21+28, ($nbrow*21)+140) 
		$_c_=1; MsgBox(0,"res", string($aguipos[0]) & ", " & string($aguipos[1]) & ", " & string($aguipos[2]) & ", " & string($aguipos[3]) & ", " & string(@error) & string($ares))
        GUISetState(@SW_SHOW, $gui_minefied)
		$array_buttons = $array_fields
		$array_labels = _buildlabels($array_labels)
        Dim $array_fields[$nbrow][$nbcol]
        $array_fields = _buildButtons($array_fields)
        Dim $array_mines[$nbrow][$nbcol][2]
        $array_mines = _fillsMines($array_mines)
    EndIf
	$reinit = false
	GUISetCursor($acursor)
EndFunc


Func _buildButtons($anarray_buttons)
    For $r = 0 to UBound($anarray_buttons,1) - 1
        For $c = 0 to UBound($anarray_buttons,2) - 1
			$afield = $anarray_buttons[$r][$c]
			if $afield == 0 Then
				$afield = GUICtrlCreateButton("",10+(21*$c),100+(21*$r), 20, 20)
				GUICtrlSetFont ($afield,9, 800)   ; Bold
				GUICtrlSetColor($afield,0x00ffff); Green
				GUICtrlSetResizing($afield, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
				GUICtrlSetOnEvent($afield, "_checkfield")
				$anarray_buttons[$r][$c] = $afield;
			Else
				GUICtrlSetData($afield,"")
				GUICtrlSetState($afield, $GUI_SHOW)
			EndIf
        Next
    Next
    Return $anarray_buttons
EndFunc
Func _buildLabels($anarray_labels)
    For $r = 0 to UBound($anarray_labels,1) - 1
        For $c = 0 to UBound($anarray_labels,2) - 1
			$label_0 = $anarray_labels[$r][$c]
			if $label_0 == 0 Then
			$label_0 = GUICtrlCreateLabel(" ",10+(21*$c),100+(21*$r), 20, 20, $SS_CENTER + $SS_SUNKEN)
				GUICtrlSetState( $label_0, $GUI_HIDE)
				GUICtrlSetResizing($label_0, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
				GUICtrlSetBkColor($label_0, 0x98FB98)
				$anarray_labels[$r][$c] = $label_0
			Else
				GUICtrlSetData($label_0,"")
				GUICtrlSetState($label_0, $GUI_HIDE)
			EndIf
        Next
    Next
    Return $anarray_labels
EndFunc

Func _fillsMines($anarray_mines)
    For $r = 0 to UBound($anarray_mines,1) - 1
        For $c = 0 to UBound($anarray_mines,2) - 1
            $anarray_mines[$r][$c][0] = 0;
            $anarray_mines[$r][$c][1] = 0;
        Next
    Next
    For $i = 1 to $nbmines
        $ir = Random(0, UBound($anarray_mines,1) - 1, 1)
        $ic = Random(0, UBound($anarray_mines,2) - 1, 1)
        While $anarray_mines[$ir][$ic][0] == 1
            $ir = Random(0, UBound($anarray_mines,1) - 1, 1)
            $ic = Random(0, UBound($anarray_mines,2) - 1, 1)
        WEnd
        $anarray_mines[$ir][$ic][0] = 1;
        $anarray_mines[$ir][$ic][1] = -1;
		for $iir = $ir -1 to $ir + 1
			for $iic = $ic -1 to $ic + 1
				if $iir >= 0 and $iir < UBound($anarray_mines,1) Then
					if $iic >= 0 and $iic < UBound($anarray_mines,2) Then
						if $iir <> $ir Or $iic <> $ic Then
							$anarray_mines[$iir][$iic][1] = $anarray_mines[$iir][$iic][1] + 1;
						EndIf
					EndIf
				EndIf
			Next
		Next
    Next
    Return $anarray_mines
EndFunc

Func _tooltiperror($aguititle, $actrl, $atitle, $amsg)
    $aposgui = WinGetPos($aguititle)
    $aposctrl = ControlGetPos($aguititle,"",$actrl)
    $_c_=1; $atooltiperror = GUICreate($atitle, 200,50, $aposgui[0]+$aposctrl[0]+$aposctrl[2], $aposgui[1]+40+$aposctrl[1],$WS_CAPTION + $WS_POPUP)
    ToolTip($amsg, $aposgui[0]+$aposctrl[0]+$aposctrl[2], $aposgui[1]+40+$aposctrl[1], $atitle, 3, 1)
    Return $CurrentToolTip_Error + 1
EndFunc

; if kaboom, then...
func _revealall()
    $started = false
	$kaboom = true
    GUICtrlSetData($Label_msg, "KABOOM !")
    For $r = 0 to UBound($array_fields,1) - 1
        For $c = 0 to UBound($array_fields,2) - 1
            $afield = $array_fields[$r][$c]
            if StringLen(GUICtrlRead($afield)) == 0 Then
                ;GUICtrlDeelete($afield)
				GUICtrlSetState($afield, $GUI_HIDE)
				$afield = $array_labels[$r][$c]
                $label_field = $afield ;GUICtrlCreeateLabel("",10+(21*$c),100+(21*$r), 20, 20, $SS_CENTER + $SS_SUNKEN)
				GUICtrlSetState($afield, $GUI_SHOW)
				;GUICtrlSetReesizing($label_field, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
                $array_fields[$r][$c] = $label_field
                if $array_mines[$r][$c][0] == 1 Then
                    GUICtrlSetData( $label_field, "X")
                    GUICtrlSetBkColor($label_field, 0xFF0000)
                    GUICtrlSetColor ($label_field, 0x000000)
                Else
                    $anbm = _getnbmines($r,$c)
                    if $anbm > 0 then
                        GUICtrlSetData( $label_field, string($anbm))
                        GUICtrlSetBkColor($label_field, 0xA9A9A9)
                        GUICtrlSetColor ($label_field, 0xFFFFFF)
                    Else
                        GUICtrlSetBkColor($label_field, 0x32CD32)
                        GUICtrlSetColor ($label_field, 0xFFFFFF)
                    EndIf
                EndIf
            ElseIf GUICtrlRead($afield) == "?" and $array_mines[$r][$c][0] == 0 Then
                ;GUICtrlDeelete($afield)
                $anbm = _getnbmines($r,$c)
				GUICtrlSetStyle($label_field, $SS_CENTER + $SS_SUNKEN)
				GUICtrlSetData($label_field, string($anbm))
                ;$label_field = GUICtrlCreeateLabel(string($anbm),10+(21*$c),100+(21*$r), 20, 20, $SS_CENTER + $SS_SUNKEN)
				;GUICtrlSetReesizing($label_field, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
                ;$array_fields[$r][$c] = $label_field
                GUICtrlSetBkColor($label_field, 0xA9A9A9)
                GUICtrlSetColor ($label_field, 0xFF0000)
            EndIf
        Next
    Next
EndFunc

;----------------------
; exploration of fields
;----------------------

; on left click on a field (button)
func _checkfield()
	if not($win) and not($kaboom) and not($reinit) Then
		if Not($started) Then
			$initcountdown = Number(GUICtrlRead( $Input_clock ))
		EndIf
		$started = true
		For $r = 0 to UBound($array_fields,1) - 1
			For $c = 0 to UBound($array_fields,2) - 1
				if @GUI_CTRLID == $array_fields[$r][$c] Then
					$afield = $array_fields[$r][$c]
					if Stringlen(GUICtrlRead($afield)) == 0 Then
						_displayfield($r, $c)
					Else
						GUICtrlSetFont($afield, 9, 800) ; bold normal
						If $easyfill Then
							$anbmines = _getnbmines($r,$c)
							if $anbmines > 0 Then
								$anbnotexplored = _getnbnotexploredfields($r,$c)
								$_c_=1; MsgBox(0, "nb empty fields", string($anbnotexplored))
								if $anbnotexplored > 0 Then
									$anbflags = _getnbflags($r,$c)
									if $anbmines == $anbflags Then
										_setall($r,$c,true)
									ElseIf ($anbmines - $anbflags) == $anbnotexplored Then
										_setall($r,$c,false)
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					ExitLoop 2
				EndIf
			Next
		Next
	EndIf
EndFunc

; on right click on a unexplored field (button with no number) or flag
Func _setflag()
	if not($win) and not($kaboom) and not($reinit) Then
		if Not($started) Then
			$initcountdown = Number(GUICtrlRead( $Input_clock ))
		EndIf
		$started = true
		$pos = MouseGetPos()
		$ir = Int(($pos[1]-100)/21)
		$irm = Mod($pos[1]-100, 21)
		$_c_=1; MsgBox(0,"ctrlhandle", $pos[0] & "," & $pos[1] & ": " & $ir & ", " & $irm)
		if $irm <> 2 and $irm <>3 Then
			if $irm <= 1 Then
				$ir = $ir - 1
			EndIf
		EndIf
		$ic = Int(($pos[0]-10)/21)
		$icm = Mod($pos[0]-10, 21)
		if $icm <> 2 and $icm <>3 Then
			if $icm <= 1 Then
				$ic = $ic - 1
			EndIf
		EndIf
		If $ir >= 0 and $ir < UBound($array_fields,1) Then
			if $ic >= 0 and $ic < UBound($array_fields,2) Then
				$_c_=1; MsgBox(0, "ok", $ir & "-" & $ic)
				_displayflag($ir, $ic, true)
			EndIf
		EndIf
	EndIf
EndFunc

;---------
; displays
;---------

Func _displayfield($r, $c)
    $afield = $array_fields[$r][$c]
    if $array_mines[$r][$c][0] == 1 Then
        ;GUICtrlDeelete($afield)
		GUICtrlSetState($afield, $GUI_HIDE)
		$afield = $array_labels[$r][$c]
		$label_bomb = $afield
		GUICtrlSetData( $afield, "X")
		GUICtrlSetState($afield, $GUI_SHOW)
        ;$label_bomb = GUICtrlCreeateLabel("X",10+(21*$c),100+(21*$r), 20, 20, $SS_CENTER + $SS_SUNKEN)
		;GUICtrlSetReesizing($label_bomb, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
        $array_fields[$r][$c] = $label_bomb
        GUICtrlSetBkColor($label_bomb, 0x000000)
        GUICtrlSetColor ($label_bomb, 0xFF0000)
        _revealall()
    Else
        if Stringlen(GUICtrlRead($afield)) == 0 Then
            $anbmines = _getnbmines($r, $c)
            GUICtrlSetData($afield, String($anbmines))
            $nbfields = $nbfields - 1
            GUICtrlSetData($Label_nbfields, $nbfields)
            $val = 100 * $nbfields / (($nbrow*$nbcol)-$nbminestot)
            GUICtrlSetData($Progress_nbfields, $val)
            if $anbmines == 0 Then
                dim $tobedisplayedres[1]
                $tobedisplayedres[0] = _displayaround($r, $c)
				dim $borders[1][2]
				$borders[0][0]=-1
				$borders[0][1]=-1
				;$tmpmsg = $tmpmsg + "[" + String($borders[0][0])+"-"+String($borders[0][1]) + "]"
				;MsgBox(0,"empty  borders",$tmpmsg)
				$borders = _getnonemptyfields($r,$c)
				if $borders <> 0 Then
					$tmpmsg = ""
					for $i = 0 to UBound($borders,1) - 1
						if $i > 0 Then
							$tmpmsg = $tmpmsg & ", "
						EndIf
						$tmpmsg = $tmpmsg & "[" & String($borders[$i][0])&"-"&String($borders[$i][1]) & "]"
					Next
					;MsgBox(0,"init borders",$tmpmsg)
				EndIf
                dim $stillemptyfields = false
                if UBound($tobedisplayedres[0],1) > 1 then 
                    $stillemptyfields = true
                EndIf
                While $stillemptyfields
                    $stillemptyfields = false
                    $tbdmax = UBound($tobedisplayedres,1)-1
					$_c_=1; MsgBox(0,"$tbdmax",$tbdmax)
                    For $idisplayaround = 0 to $tbdmax
                        if($tobedisplayedres[$idisplayaround] <> 0) Then
                            $tobedisplayed = $tobedisplayedres[$idisplayaround]
                            $tobedisplayedres[$idisplayaround] = 0
                            for $itbd = 1 to UBound($tobedisplayed,1)-1
                                $atobd = _displayaround($tobedisplayed[$itbd][0], $tobedisplayed[$itbd][1])
                                $someborders = _getnonemptyfields($tobedisplayed[$itbd][0], $tobedisplayed[$itbd][1])
								if $someborders <> 0 Then
									if $borders == 0 Then
										$borders = $someborders
									Else
										$isomeborders = UBound($someborders,1)
										$iborders = UBound($borders,1)
										ReDim $borders[$iborders+$isomeborders][2]
										$nbfound = 0
										For $i = $iborders to $iborders+$isomeborders - 1
											$found = false
											for $j = 0 to $iborders
												if $borders[$j][0] == $someborders[$i-$iborders][0] and $borders[$j][1] == $someborders[$i-$iborders][1] Then
													$found = true
													ExitLoop
												EndIf
											Next
											if Not($found) Then
												$borders[$i-$nbfound][0] = $someborders[$i-$iborders][0]
												$borders[$i-$nbfound][1] = $someborders[$i-$iborders][1]
												$msg = "[" & String($borders[$i-$nbfound][0]) & "-" & String($borders[$i-$nbfound][1]) & "], nb found" & String($nbfound)
												;MsgBox(0,"add borders:",$msg)
											Else
												$nbfound = $nbfound + 1
											EndIf
										Next
										if $nbfound > 0 Then
											ReDim $borders[UBound($borders)-$nbfound][2]
										EndIf
									EndIf
									$tmpmsg = ""
									for $i = 0 to UBound($borders,1) - 1
										if $i > 0 Then
											$tmpmsg = $tmpmsg & ", "
										EndIf
										$tmpmsg = $tmpmsg & "[" & String($borders[$i][0])&"-"&String($borders[$i][1]) & "]"
									Next
									;MsgBox(0,"add MODIF borders",$tmpmsg)
								EndIf
                                if UBound($atobd,1) > 1 Then
                                    $stillemptyfields = true
                                    ReDim $tobedisplayedres[UBound($tobedisplayedres,1)+1]
                                    $tobedisplayedres[UBound($tobedisplayedres,1)-1] = $atobd
                                EndIf
                            Next
                        EndIf
                    Next
                WEnd
				if $borders <> 0 Then
					;MsgBox(0,"borders", UBound($borders,1))
					_displayhints($borders)
				EndIf
            EndIf
        EndIf
    EndIf
EndFunc

func _displayflag($ir, $ic, $unset)
    $afield = $array_fields[$ir][$ic]
    if Stringlen(GUICtrlRead($afield)) == 0 Then
        ;GUICtrlDeelete($afield)
		GUICtrlSetState($afield, $GUI_HIDE)
        $label_B = $array_labels[$ir][$ic];GUICtrlCreeateLabel("?",10+(21*$ic),100+(21*$ir), 20, 20, $SS_CENTER + $SS_SUNKEN)
		$afield = $label_B
		GUICtrlSetData($label_B,"?")
		;GUICtrlSetReesizing($label_B, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
        $array_fields[$ir][$ic] = $label_B
		GUICtrlSetBkColor($label_B, 0xFFD700)
		GUICtrlSetState($afield, $GUI_SHOW)
        $nbflags = $nbflags -1
        GUICtrlSetData($Label_nbmines, $nbflags)
        $val = 100 * $nbflags / $nbminestot
        GUICtrlSetData($Progress_nbmines, $val)
    ElseIf $unset and GUICtrlRead($afield) == "?" Then
        ;GUICtrlDeelete($afield)		
		GUICtrlSetState($afield, $GUI_HIDE)
        $afield = $array_buttons[$ir][$ic];GUICtrlCreeateButton("",10+(21*$ic),100+(21*$ir), 20, 20)
		GUICtrlSetData($afield,"")
        ;GUICtrlSetReesizing($afield, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
        ;GUICtrlSetOnEevent($afield, "_checkfield")		
		GUICtrlSetState($afield, $GUI_SWOW)
        $array_fields[$ir][$ic] = $afield;
        $nbflags = $nbflags + 1
        GUICtrlSetData($Label_nbmines, $nbflags)
        $val = 100 * $nbflags / $nbminestot
        GUICtrlSetData($Progress_nbmines, $val)
    endif
	_displayahintsround($ir, $ic)
EndFunc

func _displayaround($r, $c)
    $afield0 = $array_fields[$r][$c]
    ;GUICtrlDeelete($afield0)
    GUICtrlSetState($afield0,$GUI_HIDE)
    $label_0 = $array_labels[$r][$c] ;GUICtrlCreeateLabel(" ",10+(21*$c),100+(21*$r), 20, 20, $SS_CENTER + $SS_SUNKEN)
	$afield0 = $label_0
	GUICtrlSetData($label_0," ")
	;GUICtrlSetReesizing($label_0, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
    $array_fields[$r][$c] = $label_0
    GUICtrlSetBkColor($label_0, 0x98FB98)
    GUICtrlSetState($label_0,$GUI_SHOW)
	$_c_=1; GUICtrlSetColor ($label_bomb, 0xFF0000)
    Dim $tobedisplayed[1][2]
    for $rr = $r-1 to $r+1
        for $cc = $c-1 to $c+1
            if $rr >= 0 and $rr < UBound($array_mines,1) Then
                if $cc >= 0 and $cc < UBound($array_mines,2) Then
                    if $rr <> $r Or $cc <> $c Then
                        $afield = $array_fields[$rr][$cc]
                        if Stringlen(GUICtrlRead($afield)) == 0 Then
                            $anbmines = _getnbmines($rr, $cc)
                            if $anbmines > 0 Then 
                                GUICtrlSetData($afield, String($anbmines))
                            EndIf
                            $nbfields = $nbfields - 1
                            $val = 100 * $nbfields / (($nbrow*$nbcol)-$nbminestot)
                            GUICtrlSetData($Progress_nbfields, $val)
                            GUICtrlSetData($Label_nbfields, $nbfields)
                            if $anbmines == 0 Then
                                GUICtrlSetData($afield, " ")
                                ReDim $tobedisplayed[UBound($tobedisplayed,1)+1][2]
                                $tobedisplayed[UBound($tobedisplayed,1)-1][0] = $rr
                                $tobedisplayed[UBound($tobedisplayed,1)-1][1] = $cc
								$_c_=1; _displayaround($rr, $cc) NO MORE RECURSIVE CALL...
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf
        Next
    Next
    Return $tobedisplayed
EndFunc

func _displayahintsround($r, $c)
	if $displayhints Then
		Dim $borders[8][2]
		$nbborders = 0
		for $rr = $r-1 to $r+1
			for $cc = $c-1 to $c+1
				if $rr >= 0 and $rr < UBound($array_mines,1) Then
					if $cc >= 0 and $cc < UBound($array_mines,2) Then
						if $rr <> $r Or $cc <> $c Then
							$afield = $array_fields[$rr][$cc]
							if Stringlen(GUICtrlRead($afield)) > 0 And GUICtrlRead($afield) <> " " And GUICtrlRead($afield) <> "?" Then
								$borders[$nbborders][0] = $rr
								$borders[$nbborders][1] = $cc
								$nbborders = $nbborders + 1
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		Next
		if $nbborders > 0 Then
			;MsgBox(0,"nbborders",$nbborders & ": [" & $r & "-" & $c & "]")
			ReDim $borders[$nbborders][2]
			_displayhints($borders)
		EndIf
	EndIf
EndFunc

Func _displayhints($borders)
	if $displayhints Then
		$msg = "Displaying hints for:" & @LF;
		For $i = 0 to UBound($borders, 1)-1
			$r = $borders[$i][0]
			$c = $borders[$i][1]
			$msg = $msg & "[" & $r & "-" & $c & "]"
			$anbmines = _getnbmines($r,$c)
			$msg = $msg & ", nbmines " & $anbmines
			;MsgBox(0, "_displayhints", $r & "-" & $c & ", " & $anbmines)
			if $anbmines > 0 Then
				$anbnotexplored = _getnbnotexploredfields($r,$c)
				$msg = $msg & ", nbnotexplored " & $anbnotexplored
				$_c_=1; MsgBox(0, "nb empty fields", string($anbnotexplored))
				$anbflags = _getnbflags($r,$c)
				$msg = $msg & ", nbflags " & $anbflags
				$afield = $array_fields[$r][$c]
				$nbexplored = _getnbexploredfields($r, $c)
				$msg = $msg & ", nbexplored " & $nbexplored
				if $anbnotexplored > 0 and ($anbmines == $anbflags or ($anbmines - $anbflags) == $anbnotexplored) Then
					GUICtrlSetFont($afield, 9, 800, 2+4) ; bold, italic + underlined
				EndIf
				if $anbnotexplored == 0 Then
					GUICtrlSetFont($afield, 9, 800) ; bold, normal
				EndIf
			EndIf
			$msg = $msg & @LF
		Next
		;MsgBox(0,"_displayhints",$msg)	
	EndIf
EndFunc

;------------------
; utility functions
;------------------

Func _getnbmines($r, $c)
    Return $array_mines[$r][$c][1]
EndFunc

Func _getnbflags($r, $c)
    $anbflag = 0
    for $rr = $r-1 to $r+1
        for $cc = $c-1 to $c+1
            if $rr >= 0 and $rr < UBound($array_fields,1) Then
                if $cc >= 0 and $cc < UBound($array_fields,2) Then
                    if $rr <> $r Or $cc <> $c Then
                        $afield = $array_fields[$rr][$cc]
                        if GUICtrlRead($afield) == "?" Then
                            $anbflag = $anbflag + 1
                        EndIf
                    EndIf
                EndIf
            EndIf
        Next
    Next
    Return $anbflag
EndFunc

Func _getnbnotexploredfields($r, $c)
    $anbemptyfields = 0
    for $rr = $r-1 to $r+1
        for $cc = $c-1 to $c+1
            if $rr >= 0 and $rr < UBound($array_fields,1) Then
                if $cc >= 0 and $cc < UBound($array_fields,2) Then
                    if $rr <> $r Or $cc <> $c Then
						$_c_=1; MsgBox(0, "e f", $rr & "-" $cc)
                        $afield = $array_fields[$rr][$cc]
                        if StringLen(GUICtrlRead($afield)) == 0 Then
                            $anbemptyfields = $anbemptyfields + 1
                        EndIf
                    EndIf
                EndIf
            EndIf
        Next
    Next
    Return $anbemptyfields
EndFunc

Func _getnbexploredfields($r, $c)
    $anbexploredfields = 0
    for $rr = $r-1 to $r+1
        for $cc = $c-1 to $c+1
            if $rr >= 0 and $rr < UBound($array_fields,1) Then
                if $cc >= 0 and $cc < UBound($array_fields,2) Then
                    if $rr <> $r Or $cc <> $c Then
						$_c_=1; MsgBox(0, "e f", $rr & "-" $cc)
                        $afield = $array_fields[$rr][$cc]
                        if StringLen(GUICtrlRead($afield)) <> 0 and GUICtrlRead($afield) <> "?" Then
                            $anbexploredfields = $anbexploredfields + 1
                        EndIf
                    EndIf
                EndIf
            EndIf
        Next
    Next
    Return $anbexploredfields
EndFunc

Func _getnonemptyfields($r, $c)
    $anonbemptyfields = 0
	dim $nonemptyfields[1][2]
    for $rr = $r-1 to $r+1
        for $cc = $c-1 to $c+1
            if $rr >= 0 and $rr < UBound($array_fields,1) Then
                if $cc >= 0 and $cc < UBound($array_fields,2) Then
                    if $rr <> $r Or $cc <> $c Then
						$_c_=1; MsgBox(0, "e f", $rr & "-" $cc)
                        $afield = $array_fields[$rr][$cc]
                        if StringLen(GUICtrlRead($afield)) <> 0 and GUICtrlRead($afield) <> " " Then
							;MsgBox(0,"non empty", GUICtrlRead($afield))
							$anonbemptyfields = $anonbemptyfields + 1
							ReDim $nonemptyfields[$anonbemptyfields][2]
							$nonemptyfields[$anonbemptyfields-1][0] = $rr
							$nonemptyfields[$anonbemptyfields-1][1] = $cc
							;MsgBox(0,"res dim borders",UBound($nonemptyfields,0))
							$tmpmsg = "[" & String($nonemptyfields[$anonbemptyfields-1][0])&"-"&String($nonemptyfields[$anonbemptyfields-1][1]) & "]"
							;MsgBox(0,"res add borders 0",String($nonemptyfields[$anonbemptyfields-1][0]))
							;MsgBox(0,"res add borders 1",String($nonemptyfields[$anonbemptyfields-1][1]))
							;MsgBox(0,"res add borders",$tmpmsg)
                        EndIf
                    EndIf
                EndIf
            EndIf
        Next
    Next
	if $anonbemptyfields == 0 Then
		$nonemptyfields = 0
	EndIf
	if $nonemptyfields <> 0 Then
		$tmpmsg = ""
		for $i = 0 to UBound($nonemptyfields,1) - 1
			if $i > 0 Then
				$tmpmsg = $tmpmsg & ", "
			EndIf
			$tmpmsg = $tmpmsg & "[" & String($nonemptyfields[$i][0])&"-"&String($nonemptyfields[$i][1]) & "]"
		Next
		;MsgBox(0,"res borders",$tmpmsg)
	EndIf
	;MsgBox(0,"res borders",String($nonemptyfields))
    Return $nonemptyfields
EndFunc

;--------------------
; easy fill functions
;--------------------
Func _inverteasyfill()
    $aneasyfill = GUICtrlRead($Checkbox_easyfill)
    if $aneasyfill == $GUI_CHECKED Then
        $easyfill = true
		$displayhints = true
    EndIf
    if $aneasyfill == $GUI_UNCHECKED Then
        $easyfill = false
		$displayhints = false
    EndIf
    if $aneasyfill == $GUI_INDETERMINATE Then
        $easyfill = true
		$displayhints = false
    EndIf
EndFunc

func _setall($r, $c, $field)
    for $rr = $r-1 to $r+1
        for $cc = $c-1 to $c+1
            if $rr >= 0 and $rr < UBound($array_fields,1) Then
                if $cc >= 0 and $cc < UBound($array_fields,2) Then
                    if $rr <> $r Or $cc <> $c Then
                        $afield = $array_fields[$rr][$cc]
                        if Stringlen(GUICtrlRead($afield)) == 0 Then
                            if $field Then
                                _displayfield($rr, $cc)
								dim $borders[1][2]
								$borders[0][0] = $rr
								$borders[0][1] = $cc
								_displayhints($borders)
								_displayhints($borders)
								_displayahintsround($rr, $cc)
                            Else
                                _displayflag($rr, $cc, false)
                            EndIf
                        EndIf
                    EndIf
                EndIf
            EndIf
        Next
    Next
EndFunc

;--------------------
; countdown functions
;--------------------

Func _setcountdow()
	$countdown = (GUICtrlRead($Checkbox_countdown) == $GUI_CHECKED)
	$_c_=1; MsgBox(0,"countdown", $countdown)
	if $countdown Then
		GUICtrlSetState ($Label_clock,$GUI_HIDE)
		GUICtrlSetState ($Input_clock,$GUI_SHOW)
		if Not($started) Then
			$snbsec = GUICtrlRead($Label_clock)
			$nbsec = Number( $snbsec )
			if $nbsec > 0 Then
				GUICtrlSetData( $Input_clock, $snbsec)
				$initcountdown = $nbsec
			EndIf
		EndIf
	Else
		GUICtrlSetState ($Input_clock,$GUI_HIDE)
		GUICtrlSetState ($Label_clock,$GUI_SHOW)
		$_c_=1; GUICtrlSetData( $Label_clock, "0000")
	EndIf
EndFunc

Func _countdownSetBkd($cd, $cdtot)
	if($cdtot > 0) Then
		$pourcent = Int((($cd/$initcountdown)*100)/10)
		Select
		Case $pourcent == 9
			GUICtrlSetBkColor($Input_clock, 0x00FF00)
		Case $pourcent == 8
			GUICtrlSetBkColor($Input_clock, 0x00FF66)
		Case $pourcent == 7
			GUICtrlSetBkColor($Input_clock, 0x33FF00)
		Case $pourcent == 6
			GUICtrlSetBkColor($Input_clock, 0x66FF66)
		Case $pourcent == 5
			GUICtrlSetBkColor($Input_clock, 0x99FF99)
		Case $pourcent == 4
			GUICtrlSetBkColor($Input_clock, 0xFFFFCC)
		Case $pourcent == 3
			GUICtrlSetBkColor($Input_clock, 0xFFCC99)
		Case $pourcent == 2
			GUICtrlSetBkColor($Input_clock, 0xFF9900)
		Case $pourcent == 1
			GUICtrlSetBkColor($Input_clock, 0xFF6600)
		Case $pourcent == 0
			GUICtrlSetBkColor($Input_clock, 0xFF0000)
		EndSelect
	Else
		GUICtrlSetBkColor($Input_clock, 0xFFFFFF)
	EndIf
EndFunc