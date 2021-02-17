#include <GuiConstants.au3>
Dim $temp2 = ""
$GUI = GUICreate("Setup" , 205 , 100) ; Fenstername, Höhe und Breite
$N = GUICtrlCreateButton( "  Normales Setup  " , 3 , 20 , 200) ; $N = Name der Variable, wird in Zeile 12 benutzt, Name des Buttons, Ausrichrichtung, Höhe und Breite
$G = GUICtrlCreateButton( " Grafikwelt/TMS Setup "  , 3 , 60 , 200 ); $G = Name der Variable, wird in Zeile 15 benutzt, Name des Buttons, Ausrichrichtung, Höhe und Breite
GUISetState( @SW_SHOW )

While 1
    $MSG = GUIGetMsg()
    If $MSG = -3 Then ; -3 steht für das klicken des X's im Fenster
            Exit
    ElseIf $MSG = $N Then 
        setup(1) ; setup = Name der Funktion, 1 ist der übergebe Parameter an die Funktion, benutzt in Zeile 198, 245 249
		exit
	ElseIf $MSG = $G Then 
		setup(2)
		exit
    EndIf
WEnd

; Das folgende, bis Zeile 198, sollte nicht geändert werden

Func message( $title , $text , $parent , $flag = 0 , $disable = 1 , $timeOut = 0)
;##This will create a MSGBOX with or withOut input using GUICREATE with a parent windows
;## flags: 0 for OK button only
;##     4 for Yes and NO will return 7 for NO and 6 for yes
;########  10 for INPUT BOX will return "INPUT" for OK and -1 for Cancel
    GUISetState( @SW_RESTORE , $parent );;restoring the GUI.
    Local Const $char_width = 5 , $button_width = 70 , $button_hight =23  , $char_hight = 15
    Local $get_win_pos , $MSG_BAD = -123 ,$input = -124 ,$temp_read , $input_Width  , $line_count , $TEMP_char_perLine
    Local $lable_width , $lable_hight , $temp , $get_win_pos , $temp_time , $first_button_left , $second_button_left
    $line_count = StringSplit( $text , @LF , 1 )
    Dim $char_perLine[$line_count[0] + 1]
    If $disable = 1 Then
        GUISetState( @SW_DISABLE , $parent)
    ElseIf $disable = 2 Then 
        GUISetState( @SW_DISABLE , $parent)
        GUISetState( @SW_HIDE , $parent)
    EndIf
    
    Select
    Case $line_count[0] > 1
        $char_perLine[0] = $line_count[0]
        For $a = 1 to $line_count[0]
            $TEMP_char_perLine = StringSplit( $line_count[$a] , '' )
            $char_perLine[$a] = $TEMP_char_perLine[0]
        Next
    Case $line_count[0] = 1
        $char_perLine = StringSplit( $text , "")
        $char_perLine[1] = $char_perLine[0]
        $char_perLine[0] = 1
    EndSelect
    
;;Calculating the lable width...and Lable hight..
    Select
    Case $char_perLine[0] = 1
        $lable_hight = $char_hight
        $lable_width = ($char_perLine[1] * $char_width)
    Case $char_perLine[0] > 1
        $temp = $char_perLine[1]
        For $a = 2 to $char_perLine[0]
            If $temp < $char_perLine[$a] Then
                $temp = $char_perLine[$a]
            EndIf
        Next
    ;setting the width
        $lable_width = ($temp * $char_width)
    ;setting the hight
        $lable_hight = ($char_hight * $char_perLine[0])
    EndSelect
;;Calculating the GUI width...
    Select
    Case $flag = 0; The OK button and the LABLE
        $GUI_Width = $lable_width + 30 
        $GUI_hight = $lable_hight + 85
        
    Case $flag = 4 ; TWO BUTTONS and the LABLE
        $GUI_hight = $lable_hight + 85
        $GUI_Width = $lable_width + 30
        
    Case $flag = 10; TWO BUTTONS , INPUT and the LABLE
        $GUI_Width = $lable_width + 30
        $GUI_hight = $lable_hight + 85 + 30
    EndSelect
    
;;Calculating buffer space between yes and no buttons
    $first_button_left = (($GUI_Width/4) - ($button_width/2)) + ($GUI_Width/10)
    If $first_button_left < 5 Then
        $first_button_left = 5
    EndIf
    
    $second_button_left = ((($GUI_Width/4) * 3) -($button_width/2)) - ($GUI_Width/10)
    If ($second_button_left) < ($first_button_left + $button_width + 4) Then
        $second_button_left = ($first_button_left + $button_width + 4)
    EndIf
    
    If ($second_button_left - $first_button_left) > 150 Then
        $buf_adjus = ($second_button_left - $first_button_left) / 4
        $first_button_left = $first_button_left + $buf_adjus
        $second_button_left = $second_button_left - $buf_adjus
    EndIf
    
    If $second_button_left + $button_width + 5 > $GUI_Width Then
        $GUI_Width = $second_button_left + $button_width + 10
    EndIf
    
    $get_win_pos = WinGetPos ( $parent )
    $MSG_GUI = GUICreate( $title , $GUI_Width , $GUI_hight , ($get_win_pos[0] + ($get_win_pos[2]/2))-( $GUI_Width/2), ($get_win_pos[1] + ($get_win_pos[3]/2))-( $GUI_hight/2) , 0x00000001  , -1 , $parent )
    $MSG_lable = GUICtrlCreateLabel( $text , 10 , 10 , $lable_width , $lable_hight )
;GUICtrlSetBkColor( -1 , 0x00ff00 )
    Select
    Case $flag = 0
        $MSG_GOOD = GUICtrlCreateButton( "  OK   " , (($GUI_Width/2))-($button_width / 2 ) , ($GUI_hight - 30 )-($button_hight + 10 ) ,$button_width , $button_hight)
        GUICtrlSetState( -1, $GUI_DEFBUTTON )
    Case $flag = 4
        $MSG_GOOD = GUICtrlCreateButton( "  Yes   " , $first_button_left , ($GUI_hight - 30 )-($button_hight + 10 ) , $button_width , $button_hight)
        GUICtrlSetState( -1, $GUI_DEFBUTTON )
        $MSG_BAD = GUICtrlCreateButton( "  No   " , $second_button_left , ($GUI_hight - 30 )-($button_hight + 10 ) , $button_width , $button_hight)
    Case $flag = 10
        $MSG_GOOD = GUICtrlCreateButton( "  OK   " , $first_button_left, ($GUI_hight - 30 )-($button_hight + 10 ) , $button_width , $button_hight)
        GUICtrlSetState( -1, $GUI_DEFBUTTON )
        $MSG_BAD = GUICtrlCreateButton( "  Cancel   " , $second_button_left , ($GUI_hight - 30 )-($button_hight + 10 ) , $button_width , $button_hight)
    EndSelect
    If $flag = 10 Then
        If $GUI_Width > 400 Then
            $input_Width = 340
        Else
            $input_Width = $GUI_Width - 50
        EndIf
        $input = GUICtrlCreateInput("" , (($GUI_Width /2) - ($input_Width/2)) , ($GUI_hight - ($button_hight + 10 + 60)) , $input_Width , 20 )
        GUICtrlSetState( -1, $GUI_FOCUS )
    EndIf
    
    GUISetState( @SW_SHOW , $MSG_GUI )
    If $timeOut <> 0 Then
        $temp_time = TimerInit()
    EndIf
    While 1
        If $timeOut <> 0 Then
            If (TimerDiff( $temp_time ) = $timeOut) or (TimerDiff( $temp_time ) > $timeOut) Then
                GUIDelete( $MSG_GUI )
                If $disable = 2 Then
                    GUISetState( @SW_SHOW , $parent )
                    GUISetState( @SW_ENABLE , $parent )
                ElseIf $disable = 1 Then
                    GUISetState( @SW_ENABLE , $parent )
                EndIf
                WinActivate( $parent )
                GUISwitch ( $parent )
                Return -1
            EndIf
        EndIf
        
        $MSG_MSG = GUIGetMsg($MSG_GUI)
        Select
        Case ($MSG_MSG = $MSG_GOOD) And ($flag <>10)
            GUIDelete( $MSG_GUI )
            If $disable = 2 Then
                GUISetState( @SW_SHOW , $parent )
                GUISetState( @SW_ENABLE , $parent )
            ElseIf $disable = 1 Then
                GUISetState( @SW_ENABLE , $parent )
            EndIf
            WinActivate( $parent )
            GUISwitch ( $parent )
            If $flag = 0 Then Return 0
            If $flag = 4 Then Return 6
            
        Case ($MSG_MSG = $MSG_BAD) And ($flag <> 0)
            GUIDelete( $MSG_GUI )
            If $disable = 2 Then
                GUISetState( @SW_SHOW , $parent )
                GUISetState( @SW_ENABLE , $parent )
            ElseIf $disable = 1 Then
                GUISetState( @SW_ENABLE , $parent )
            EndIf
            WinActivate( $parent )
            GUISwitch ( $parent )
            SetError( 1 )
            Return 7
            
        Case ($MSG_MSG = $MSG_GOOD) And ($flag = 10)
            $temp2 = guictrlread( $input )
            GUIDelete($MSG_GUI)
            If $disable = 2 Then
                GUISetState( @SW_SHOW , $parent )
                GUISetState( @SW_ENABLE , $parent )
            ElseIf $disable = 1 Then
                GUISetState( @SW_ENABLE , $parent )
            EndIf
            WinActivate( $parent )
            GUISwitch ( $parent )
            Return $temp2
        EndSelect
    WEnd
EndFunc

Func setup($box) ; Funktion wird erstellt und braucht den Parameter $box, wird in Zeile 13 und 16 übergeben

	Send('{LWINDOWN}') ;Ordneroptionen öffnen
	Send('{E down}')
	Send('{LWINUP}')
	Send('{E up}')
	WinWaitActive("Computer") ; Es wird gewartet bis der Explorer (mit Titel "Computer") geöffnet ist
	Sleep(3000)
	Send('{DOWN}')
	Send('{UP}')
	Send('{ENTER}')
	Sleep(3000)
	Send('{TAB 4}')
	Sleep(500)
	Send('{DOWN}')
	Send('{DOWN 8}')
	Send('{ENTER}') ; Hier werden die Ordneroptionen geöffnet
	Send('{SHIFTDOWN}')
	Send('{TAB}')
	Send('{SHIFTUP}')
	Send('{RIGHT}')

	Send('{TAB 3}') ;Ordneroptionen abschließen
	Send('{DOWN 6}')
	Sleep(500)
	Send('{SPACE}')
	Send('{DOWN 2}')
	Send('{SPACE}')
	Sleep(500)
	Send('{LEFT}')
	Send('{ENTER}')
	Sleep(1000)
	Send('{DOWN 11}')
	Send('{SPACE}')
	Send('{TAB 4}')
	Send('{ENTER}')
	Sleep(500)
	Send('{ENTER}')
	Send('{ENTER}')
	Send('{ESC}')

	Sleep(500) ;Profilsicherung Teil 1
	Send('{TAB 2}')
	Sleep(500)
	Send('{DOWN}')
	Send('{ENTER}')
	Sleep(500)

	if $box == 1 Then ; 1 bedeutet Nein, also keine Grafikwelt
		Send('{DOWN 2}')
		Send('{ENTER}') ; Adminrechte werden entzogen
		Sleep(1000)
		Send('{DOWN 2}')
	elseif $box == 2 Then ; 2 bedeutet Ja, also eine Grafikwelt
		Send('{DOWN 4}')
	Endif

	Sleep(2000)
	Send('{ENTER}') ; Profilsicherung wird aktiviert
	Sleep(1500)
	Send('{ENTER}')
	Sleep(1500)
	Send('{ENTER}')
	Sleep(1000)
	Send('{BACKSPACE}')
	Sleep(500)
	Send('{DOWN}')
	Sleep(1000)
	Send('{ENTER}')
	Sleep(500)
	Send('{DOWN}')
	Sleep(500)
	Send('{DEL}')
	Sleep(500)
	Send('{ENTER}') ; C:\_Profiles\kktn wird gelöscht
	Sleep(6000)

	Run("explorer.exe " & "C:\") ;Profilsicherung Teil 2
	WinWaitActive("Lokaler Datenträger (C:)")
	Send('{B}')
	Send('{E}')
	Send('{ENTER}')
	WinWaitActive("Benutzer")
	Send('{K}')
	Send('{CTRLDOWN}')
	Send('{C down}')
	Sleep(500)
	Send('{CTRLUP}')
	Send('{C up}') ; C:\Benutzer\kktn wird kopiert
	Send('{BACKSPACE}')
	WinWaitActive("Lokaler Datenträger (C:)")
	Send('{_}')
	Send('{P}')
	Send('{ENTER}')
	Sleep(1000)
	Send('{CTRLDOWN}')
	Send('{V down}')
	Sleep(500)
	Send('{CTRLUP}')
	Send('{V up}') ; C:\Benutzer\kktn wird nach C:\_Profiles\ kopiert
	$handle = WinGetHandle("Kopieren von ") ; WinGetHandle holt sich die ID des Fensters 
	Sleep(2000)

	Run("explorer.exe " & "C:\") ; Es wird alles in C:\Benutzer\kktn gelöscht
	WinWaitActive("Lokaler Datenträger (C:)")
	Send('{B}')
	Send('{E}')
	Send('{ENTER}')
	WinWaitActive("Benutzer")
	Send('{K}')
	Send('{ENTER}')
	WinWaitActive("Benutzer")
	Send('{CTRLDOWN}')
	Send('{A down}')
	Sleep(500)
	Send('{CTRLUP}')
	Send('{A up}')
	Sleep(500)
	Send('{DEL}')
	
	$i = 0
	While $i <= 0
		if WinGetState($handle) == 0 Then
			Send('{DEL}')
			Sleep(1000)
			Send('{DEL}')
			Sleep(500)
			Send('{ENTER}')
			Sleep(5000)
			del()
			del()
			del()
			del()
			del()
			del()
			del()
			del()
			del()
			del()
			
			Send('{CTRLDOWN}')
			Send('{A down}')
			Sleep(500)
			Send('{CTRLUP}')
			Send('{A up}')
			Send('{DEL}')
			Sleep(500)
			Send('{ENTER}')
			Sleep(5000)
			$i = $i + 1
			
			#comments-start
			Send('{LWIN}')
			Send('{RIGHT 2}')
			Send('{UP 2}')
			Send('{ENTER}') ;Neu starten
			#comments-end
		EndIf
	WEnd
EndFunc

func del()
	Sleep(800)
	Send('{ENTER}')
endfunc