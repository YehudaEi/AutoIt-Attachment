#include-once
#include <GUIConstants.au3>
; version 2005/01/18 - 2
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Function to create a simple menu of items to choose from
;
; ==============================================================================
; VERSION       DATE       DESCRIPTION
; -----------------------------------------------------------------------------
; v1.0.00    01/18/2005   Initial release
; v1.0.01     09/26/2005  Added _MsgBox
;									  Some code tidy up
;									  Fixed bug in _menu where the menu GUI wasn't closed after selection was made
; v1.0.02		09/28/2005 Additional functionality added to _menu.au3
;                                       Will now accept a variable that contains all the meun items
;===============================================================================
;_menu
; Description:      Creates a simple menu from which a user can select one or more items
; Usage:             $x = _menu($iRtn,$str_Txt,$sItem0, $sItem1,,,$sItem19)
;                   or    $x  = _menu($iRtn,$str_Txt,$args)      where $args = $sItem0 & "," & $sItem1 & "," & etc
; Parameter(s):   $iRtn -  The maximum number of items you want the user to select  eg 1
;                          $str_Txt - Text to instruct user what to do
;                                         - This can be up to 20 lines long - just split lines up using @CRLF or @LF or @CR
;                         $sItem0, $sItem1,,,$sItem19 - These are the menu items - you can use up to 20 items
; Requirement(s):   None
; Return Value(s):  Returns an array eg $selected
;                          $selected[0] = number of items selected. This set to Zero if user just exits the GUI
;                          $selected[1] = 1st item selected
;                          $selected[2] = 2nd item selected  etc.
; Author(s):         Steve Hassall
; Note(s):           If a menu item or a line of text is greater that the width of the maximum GUI size then
;                        that line will not display at all.
;
; Examples of use - put menu.au3 in the includes directory in AutoIt directory
; #include <menu.au3>
; $x = _menu(1,"Choose a colour","red","blue","green","yellow")
;			Here, only 1 item is returned - if user chose "blue"
;  $x[1] = "blue"
;
; $x = _menu(3,"Choose 3 reasons why I use AutoIT", _
; 						"It makes my job easy",  _
; 						"It saves me loads of time",  _
;						"I learn more about windows systems",  _
; 						"because the help file makes learning easy",  _
; 						"The forums are great - so I can get most problems solved quickly",  _
; 						"The desktop wallpaper is quite good")
; $msg = ""
; For $y = 1 to $x[0]
;     $msg = $msg & @CRLF & $x[$y]
; Next
; MsgBox(0, "","You chose " & $x[0] & " replies"  & @CRLF & $msg)
;===============================================================================
Func _Menu($iRtn, $str_Txt, $sItem0 = "", $sItem1 = "", $sItem2 = "", $sItem3 = "", $sItem4 = "", $sItem5 = "", $sItem6 = "", $sItem7 = "", $sItem8 = "", $sItem9 = "", $sItem10 = "", $sItem11 = "", $sItem12 = "", $sItem13 = "", $sItem14 = "", $sItem15 = "", $sItem16 = "", $sItem17 = "", $sItem18 = "", $sItem19 = "")
    Local $int_btx = 0
    Local $iMenuItems = 0
    Local $int_tn = 1
    Local $menu[20]
    Local $text[20]
    Local $GUI_X
    Local $GUI_Y
    Local $chk
    Local $int_tx = 5.8
    Local $x, $y, $z
    If $iRtn = 0 Or $iRtn = "" Or IsNumber($iRtn) = 0 Or $iRtn > 20 Then $iRtn = 1
    If $iRtn = 1 Then
        Local $sTiptext = "Please select just 1 item"
    Else
        Local $sTiptext = "Please select up to  " & $iRtn & "  items"
    EndIf
    Local $selected[21]
    If $sItem1 = "" Then  ; if $sItem1does not exist - assume that $sItem0 contains menu item args.
        If $sItem0 <> "" Then
            Local $temp
            $temp = StringSplit($sItem0, ",")
            For $x = 1 To $temp[0]
                $menu[$x - 1] = $temp[$x]
            Next
        EndIf
    Else
        $menu[0] = $sItem0
        $menu[1] = $sItem1
        $menu[2] = $sItem2
        $menu[3] = $sItem3
        $menu[4] = $sItem4
        $menu[5] = $sItem5
        $menu[6] = $sItem6
        $menu[7] = $sItem7
        $menu[8] = $sItem8
        $menu[9] = $sItem9
        $menu[10] = $sItem10
        $menu[11] = $sItem11
        $menu[12] = $sItem12
        $menu[13] = $sItem13
        $menu[14] = $sItem14
        $menu[15] = $sItem15
        $menu[16] = $sItem16
        $menu[17] = $sItem17
        $menu[18] = $sItem18
        $menu[19] = $sItem19
    EndIf
    ;===============================================================================
    ;Get number of items for the menu and check for maximum length of text used
    For $x = 19 To 0 Step - 1
        If $iMenuItems = 0 Then
            If $menu[$x] <> "" Then
                $iMenuItems = $x + 1
            EndIf
        EndIf
        If StringLen($menu[$x]) > $int_btx Then $int_btx = StringLen($menu[$x])
    Next
    ;===============================================================================
    ;Size the GUI - part 1
    If @DesktopWidth > (($int_btx * $int_tx) + 60) Then
        $GUI_X = (($int_btx * $int_tx) + 60)
    Else
        $GUI_X = @DesktopWidth - 60
    EndIf
    ;===============================================================================
    ;check for number of lines of text used and the longest line of text
    $str_Txt = StringReplace($str_Txt, @CRLF, "*@@@@*")
    $str_Txt = StringReplace($str_Txt, @LF, "*@@@@*")
    $str_Txt = StringReplace($str_Txt, @CR, "*@@@@*")
    $int_btx = 0
    For $x = 0 To 19
        $y = StringInStr($str_Txt, "*@@@@*")
        If $y = 0 Then
            $text[$x] = $str_Txt
            If StringLen($text[$x]) > $int_btx Then $int_btx = StringLen($text[$x])
            $int_tn = $x + 1
            ExitLoop
        Else
            $text[$x] = StringLeft($str_Txt, $y - 1)
            If StringLen($text[$x]) > $int_btx Then $int_btx = StringLen($text[$x])
            $str_Txt = StringTrimLeft($str_Txt, $y + 5)
        EndIf
    Next
    ;===============================================================================
    ;Size the GUI - part 2 - make sure the GUI iwidth sn't too big or too small
    If $GUI_X < (($int_btx * $int_tx) + 60) Then $GUI_X = (($int_btx * $int_tx) + 60)
    If $GUI_X > @DesktopWidth - 20 Then $GUI_X = @DesktopWidth - 20
    If $GUI_X < 180 Then $GUI_X = 180
    ;===============================================================================
    ;Get height of GUI - I have limited the mumber of selectable items to 20
    ;Try to make sure GUI hight isn't too big or too small
    $GUI_Y = 115 + $int_tn * 13 + $iMenuItems * 20
    If $GUI_Y > @DesktopHeight - 60 Then
        $GUI_Y = @DesktopHeight - 60
        $int_tn = Int(($GUI_Y - 115 - ($iMenuItems * 20)) / 13)
    EndIf
    ;===============================================================================
    ;Write out the GUI
    GUICreate("Menu", $GUI_X, $GUI_Y, (@DesktopWidth - $GUI_X) / 2, (@DesktopHeight - $GUI_Y) / 2, (0x00CF0000 + 0x10000000 + 0x04000000))
    $Button_1 = GUICtrlCreateButton("OK", (($GUI_X - 150) * 2) / 3 + 75, $GUI_Y - 45, 75, 25)
    $Button_2 = GUICtrlCreateButton("Quit", ($GUI_X - 150) / 3, $GUI_Y - 45, 75, 25)
    For $x = 0 To $int_tn - 1
        GUICtrlCreateLabel($text[$x], 30, ($x + 1) * 13 + 20, $GUI_X - 60, 13)
    Next
    If $iMenuItems > 0 Then
        $Checkbox_0 = GUICtrlCreateCheckbox($menu[0], 40, 45 + $int_tn * 13, $GUI_X + 80, 20)
        GUICtrlSetTip($Checkbox_0, $sTiptext)
    EndIf
    For $x = 1 To $iMenuItems - 1
        GUICtrlCreateCheckbox($menu[$x], 40, 45 + $int_tn * 13 + $x * 20, $GUI_X + 80, 20)
        GUICtrlSetTip(-1, $sTiptext)
    Next
    GUISetState()
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $Button_1
                ;===============================================================================
                ;check if correct number of items has been selected - rem max number of items is 20
                $chk = 0
                $selected = 0
                Local $selected[21]
                For $x = 0 To 19
                    If $iMenuItems > $x Then
                        If GUICtrlRead($Checkbox_0 + $x) = 1 Then
                            $chk = $chk + 1
                            $selected[$chk] = $menu[$x]
                            $selected[0] = $chk
                        EndIf
                    EndIf
                Next
                If $chk = 0 Then $selected[0] = 0
                If $chk > $iRtn Then
                    If $iRtn = 1 Then
                        MsgBox(0, "Error", "You are required to select only 1 item" & @CRLF & @CRLF & "Please deselect some item(s)")
                    Else
                        MsgBox(0, "Error", "You are required to select up to  " & $iRtn & "  items" & @CRLF & @CRLF & "Please deselect some items")
                    EndIf
                Else
                    ExitLoop
                EndIf
            Case $msg = $Button_2
                $selected[0] = 0
                $selected[1] = ""
                ExitLoop
            Case $msg = -3
                $selected[0] = 0
                $selected[1] = ""
                ExitLoop
            Case Else
        EndSelect
    WEnd
    GUIDelete()
    Return $selected
EndFunc   ;==>_Menu
;===============================================================================
;_msgbox
; Description:        Creates a replacement msgbox - allowing users to choose text in msgbox buttons
; Usage:               $x =  _msgbox($str_Title,$str_Txt,$str_btn1,..,$str_btn4)
; Parameter(s):     $str_Title -  The title of the message box
;                             $str_Txt -  The text of the message box.
;                             $str_btn1, $str_btn2,,$str_btn4 - Text to be displayed on Buttons - up to 4 buttons can be used
; Requirement(s):  None
; Return Value(s):  Returns the text of the button that was clicked
; Author(s):            Steve Hassall
; Note(s):               If no text entered for any buttons - one button will be created  - "OK"
;                             If text overflows into a second line - this script is not as clever as the
;                             Windows api in dividing the lines up. It just uses a crude "letters per line"
;                             measurement.
;
; Examples of use - put menu.au3 in the includes directory in AutoIt directory
;  #include <menu.au3>
;	$x = _msgbox("A question","Can you see this OK","Yes","No","More options")
;			Here, if you selected more options - the the value "More options" is returned
;   MsgBox(3,"",You clicked  _ " & $x)
;
;===============================================================================
Func _MsgBox($str_Title, $str_Txt, $str_btn1 = "OK", $str_btn2 = "", $str_btn3 = "", $str_btn4 = "")
    Local $int_btx = 0 ;$int_btx - Button text length (pixels)
    Local $int_bn = 0  ; $int_bn - number of buttons to be displayed
    Local $int_bu = 7  ; $int_bv - gap between buttons in pixels
    Local $int_bv = 15  ; $int_bv - distance between last line of text and button
    Local $int_bw = 16   ; $int_bw - minimum gap between left edge of msgbox and first button
    Local $int_by = 22 ; $int_by  - button height
    Local $int_bz = 13  ; $int_bz - distance between button and bottom of msgbox
    Local $arr_bt[4]  ; $arr_bt[]  - array containing text written on each button
    Local $arr_b[4]  ; $arr_b - array containing gui reference for buttons
    Local $int_tn = 1   ; $int_tn  - number of lines of lext in msgbox
    Local $int_tw = 12 ; $int_tw ; minimum gap between left edge of msgbox and beginning of text
    Local $int_tx  ; $int_tx - msgbox per line text length
    Local $int_ty = 13 ; $int_ty ; height of text - actually the hieght of the GUI label containing the text
    Local $arr_t  ; $arr_t[]  - array containing each line of text to be displayed in the msgbox
    Local $GUI_X  ; width of msgbox in pixels
    Local $GUI_Y ; height of msgbox in pixels
    Local $int_gx = 40  ; $int_gx - minimum gap between left side of msgbox and left edge of desktop
    Local $int_gy = 40 ; $int_gy - minimum gap between ltop of msgbox and top of desktop
    Local $int_scale = 6.3 ; $int_scale $int_tx  - this is a scaling factor for integers to try and match pixels per text charactor
    Local $int_scale_t = 5.1 ;  $int_scale_t  - this is a scaling factor for text
    Local $v, $w, $x, $y, $z ; working variables
    Local $int_arb = 0  ; $int_arb  ; an arbitrary setting to allow for errors in judging length of text in pixels
    $arr_bt[0] = $str_btn1
    $arr_bt[1] = $str_btn2
    $arr_bt[2] = $str_btn3
    $arr_bt[3] = $str_btn4
    ;check out all the line break options
    $str_Txt = StringReplace($str_Txt, @CRLF, "*@@@@*")
    $str_Txt = StringReplace($str_Txt, @LF, "*@@@@*")
    $str_Txt = StringReplace($str_Txt, @CR, "*@@@@*")
    $str_Txt = StringReplace($str_Txt, "*@@@@*", @CRLF)
    ;======Format text to be diplayed=================================================================
    While 1
        $int_tx = 0
        $arr_t = StringSplit($str_Txt, @CRLF, 1) ; create array of text lines
        For $x = 1 To $arr_t[0] ; ;Find the longest text string
            ;do some clever stuff here to distinguish between letters and numbers to help with resizing of msgbox
            If StringLen($arr_t[$x]) > 20 Then
                $w = 0
                $v = 0
                $y = StringSplit($arr_t[$x], "")
                For $z = 1 To $y[0]
                    If Asc($y[$z]) > 46 And Asc($y[$z]) < 91 Then
                        $w = $w + 1
                    Else
                        $v = $v + 1
                    EndIf
                Next
                $int_scale = $int_scale_t + ($w/ ($w + $v)) * ($int_scale - $int_scale_t)
            EndIf
            If StringLen($arr_t[$x]) > $int_tx Then $int_tx = StringLen($arr_t[$x])
        Next
        ;next check if max length is greater than desktop
        If @DesktopWidth > (($int_tx * $int_scale) + 2 * $int_gx + 2 * $int_tw + $int_arb) Then ; no lines need to be resized
            $GUI_X = (($int_tx * $int_scale) + 2 * $int_tw + $int_arb)
            ExitLoop
        Else ;  ;look again at each of the lines
            $GUI_X = @DesktopWidth - 2 * $int_gx
            Local $inLetters_per_line = ($GUI_X - (2 * $int_tw) - $int_arb) / $int_scale ; try and determine how many letters will fit on the line for a given size of desktop
            $str_Txt = ""
            For $x = 1 To $arr_t[0] ; check length of each line to see if more than max letters per line
                If StringLen($arr_t[$x]) > $inLetters_per_line Then ; if longer split line up
                    $y = Int(StringLen($arr_t[$x]) / $inLetters_per_line)
                    $w = $arr_t[$x]
                    $arr_t[$x] = ""
                    For $z = 1 To $y + 1
                        $arr_t[$x] = $arr_t[$x] & StringLeft($w, $inLetters_per_line) & @CRLF
                        $w = StringTrimLeft($w, $inLetters_per_line)
                    Next
                    $arr_t[$x] = StringTrimRight($arr_t[$x], 2)
                EndIf
                $str_Txt = $str_Txt & $arr_t[$x] & @CRLF ; create text string from array
            Next
            $str_Txt = StringTrimRight($str_Txt, 2)
        EndIf
    WEnd ; We have now resized each line acording to desktop size - and we have $arr_t[0] lines of text to display
    ;=========Format buttons to be displayed======================================================================
    ;Get number of ibuttons to be displayed and get the max length of each button text
    For $x = 3 To 0 Step - 1
        If $arr_bt[$x] <> "" Then
            $int_bn = $int_bn + 1
        EndIf
        If StringLen($arr_bt[$x]) > $int_btx Then $int_btx = StringLen($arr_bt[$x])
    Next
    Local $button_width = $int_btx * $int_scale + 10
    If $button_width < 75 Then $button_width = 75
    If ($button_width + $int_bu) * $int_bn + (2 * $int_bw - $int_bu) > $GUI_X Then ;check that these buttons can be displayed
        If ($button_width + $int_bu) * $int_bn + (2 * $int_bw - $int_bu) < @DesktopWidth - 2 * $int_gx Then
            $GUI_X = ((($button_width + $int_bu) * $int_bn) - $int_bu) + (2 * $int_bw)
        Else
            $GUI_X = @DesktopWidth - 2 * $int_gx
        EndIf
    EndIf
    $GUI_Y = $int_tw + $int_bv + $int_by + $int_bz + $arr_t[0] * $int_ty ; add up components for height of msgbox GUI
    If $GUI_Y > @DesktopHeight - 2 * $int_gy Then ;If GUI is taller than desktop
        $GUI_Y = @DesktopHeight - 2 * $int_gy          ; Resize GUI and pop in error message saying some of msgbox text cannot be displayed
        $arr_t[Int(($GUI_Y - ($int_tw + $int_bv + $int_by + $int_bz)) / $int_ty) ] = "***** ERROR ******* -  There are some items in this message box that cannot be displayed"
    EndIf
    ;======Create GUI=================================================================
    GUICreate($str_Title, $GUI_X - 10, $GUI_Y, (@DesktopWidth - $GUI_X) / 2, (@DesktopHeight - $GUI_Y - 40) / 2, BitOR(0x00C00000, 0x80000000, 0x10000000))
    For $x = 1 To $arr_t[0] ; write out text
        GUICtrlCreateLabel($arr_t[$x], $int_tw, $int_tw + ($x - 1) * $int_ty, $GUI_X - $int_tw, $int_ty)
    Next
    For $x = 1 To $int_bn ; create buttons
        $arr_b[$x - 1] = GUICtrlCreateButton($arr_bt[$x - 1], ($GUI_X - ($button_width + $int_bu) * $int_bn - $int_bu) * 0.5 + (($x - 1) * ($int_bu + $button_width)), $GUI_Y - ($int_by + $int_bz), $button_width, 22)
    Next
    GUISetState()
    ;======Get selected button=================================================================
    While 1
        $msg = GUIGetMsg()
        For $x = 1 To $int_bn
            If $msg = $arr_b[$x - 1] Then
                GUIDelete()
                Return $arr_bt[$x - 1]
            EndIf
        Next
    WEnd
EndFunc   ;==>_MsgBox