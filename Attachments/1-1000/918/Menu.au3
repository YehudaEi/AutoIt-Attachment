#include-once
; version 2005/01/18 - 1
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Function to create a simple menu of items to choose from
;
; ==============================================================================
; VERSION       DATE       DESCRIPTION
; -----------------------------------------------------------------------------
; v1.0.00    01/18/20045   Initial release
; ------------------------------------------------------------------------------
;===============================================================================
;
; Description:      Creates a simple menu from which a user can select one or more items
; Parameter(s):     $iRtn -  The maximum number of items you want the user to select  eg 1   D = Add number of days to the given date
;                          $sTxt - Text to instruct user what to do
;                                      This can be up to 20 lines long - just split lines up using @CRLF or @LF or @CR
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
;  #include <menu.au3>
;	$x = _menu(1,"Choose a colour","red","blue","green","yellow")
;			Here, only 1 item is returned - if user chose "blue"
;   $x[1] = "blue"
;
;   $x = _menu(1,"This computer cannot be migrated to the domain"  & @CRLF & "This could be due to"  & @CRLF & _
;         "1 - you are not logged on with an account with appropriate permissions"  & @CRLF & _
;         "2 - the computer account has been disabled"  & @CRLF & _
;         "3 - the computer account has not been created"  & @CRLF & @CRLF &_
;         "Please choose form the following options","Pause script and add create conputer account in domain",_
;         "Rename computer then continue script","Exit script and remove all script files","Try migrating again")
;===============================================================================


If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000
If Not IsDeclared('$WS_OVERLAPPEDWINDOW') Then Global $WS_OVERLAPPEDWINDOW = 0x00CF0000
If Not IsDeclared('$WS_VISIBLE') Then Global $WS_VISIBLE = 0x10000000
If Not IsDeclared('$GUI_EVENT_CLOSE') Then Global $GUI_EVENT_CLOSE = -3
Func _Menu($iRtn, $sTxt, $sItem0 = "", $sItem1 = "", $sItem2 = "", $sItem3 = "", $sItem4 = "", $sItem5 = "", $sItem6 = "", $sItem7 = "", $sItem8 = "", $sItem9 = "", $sItem10 = "", $sItem11 = "", $sItem12 = "", $sItem13 = "", $sItem14 = "", $sItem15 = "", $sItem16 = "", $sItem17 = "", $sItem18 = "", $sItem19 = "")
   Local $Max_item_lgth = 0
   Local $iMenuItems = 0
   Local $iTextItems = 1
   Local $menu[20]
   Local $text[20]
   Local $GUI_X
   Local $GUI_Y
   Local $chk
   Local $scaler = 5.8
   If $iRtn = 0 Or $iRtn = "" Or IsNumber($iRtn) = 0 Or $iRtn > 20 Then $iRtn = 1
   If $iRtn = 1 Then
      Local $sTiptext = "Please select just 1 item"
   Else
      Local $sTiptext = "Please select up to  " & $iRtn & "  items"
   EndIf
   Local $selected[21]
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
   ;===============================================================================
   ;Get number of items for the menu and check for maximum length of text used
   For $x = 19 To 0 Step - 1
      If $iMenuItems = 0 Then
         If $menu[$x] <> "" Then
            $iMenuItems = $x + 1
         EndIf
      EndIf
      If StringLen($menu[$x]) > $Max_item_lgth Then $Max_item_lgth = StringLen($menu[$x])
   Next
   ;===============================================================================
   ;Size the GUI - part 1
   If @DesktopWidth > ( ($Max_item_lgth * $scaler) + 60) Then
      $GUI_X = ( ($Max_item_lgth * $scaler) + 60)
   Else
      $GUI_X =
   EndIf
   ;===============================================================================
   ;check for number of lines of text used and the lonest line of text
   $sTxt = StringReplace($sTxt, @CRLF, "*@@@@*")
   $sTxt = StringReplace($sTxt, @LF, "*@@@@*")
   $sTxt = StringReplace($sTxt, @CR, "*@@@@*")
   $Max_item_lgth = 0
   For $x = 0 To 19
      $y = StringInStr($sTxt, "*@@@@*")
      If $y = 0 Then
         $text[$x] = $sTxt
         If StringLen($text[$x]) > $Max_item_lgth Then $Max_item_lgth = StringLen($text[$x])
         $iTextItems = $x + 1
         ExitLoop
      Else
         $text[$x] = StringLeft($sTxt, $y - 1)
         If StringLen($text[$x]) > $Max_item_lgth Then $Max_item_lgth = StringLen($text[$x])
         $sTxt = StringTrimLeft($sTxt, $y + 5)
      EndIf
   Next
   ;===============================================================================
   ;Size the GUI - part 2
   If $GUI_X < ( ($Max_item_lgth * $scaler) + 60) Then $GUI_X = ( ($Max_item_lgth * $scaler) + 60)
   If $GUI_X > @DesktopWidth - 20 Then $GUI_X = @DesktopWidth - 20
   If $GUI_X < 180 Then $GUI_X = 180
   ;===============================================================================
   ;Get height of GUI
   $GUI_Y = 115 + $iTextItems * 13 + $iMenuItems * 20
   If $GUI_Y > @DesktopHeight - 60 Then
      $GUI_Y = @DesktopHeight - 60
      $iTextItems = INT( ($GUI_Y - 115 - ($iMenuItems * 20)) / 13)
   EndIf
   ;===============================================================================
   ;Write out the GUI
   GUICreate("MyGUI", $GUI_X, $GUI_Y, (@DesktopWidth - $GUI_X) / 2, (@DesktopHeight - $GUI_Y) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
   $Button_1 = GUICtrlCreateButton("OK", ( ($GUI_X - 150) * 2) / 3 + 75, $GUI_Y - 45, 75, 25)
   $Button_2 = GUICtrlCreateButton("Quit", ($GUI_X - 150) / 3, $GUI_Y - 45, 75, 25)
   For $x = 0 To $iTextItems - 1
      GUICtrlCreateLabel($text[$x], 30, ($x + 1) * 13 + 20, $GUI_X - 60, 13)
   Next
   If $iMenuItems > 0 Then
      $Checkbox_0 = GUICtrlCreateCheckbox($menu[0], 40, 45 + $iTextItems * 13, $GUI_X + 80, 20)
      GUICtrlSetTip($Checkbox_0, $stiptext)
   EndIf
   For $x = 1 To $iMenuItems - 1
      GUICtrlCreateCheckbox($menu[$x], 40, 45 + $iTextItems * 13 + $x * 20, $GUI_X + 80, 20)
      GUICtrlSetTip(-1, $stiptext)
   Next
   GUISetState()
   While 1
      $msg = GUIGetMsg()
      Select
         Case $msg = $Button_1
            ;===============================================================================
            ;check if correct number of items has been selected
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
            ExitLoop
         Case $msg = $GUI_EVENT_CLOSE
            $selected[0] = 0
            ExitLoop
         Case Else
      EndSelect
   WEnd
   Return $selected
EndFunc   ;==>_Menu
