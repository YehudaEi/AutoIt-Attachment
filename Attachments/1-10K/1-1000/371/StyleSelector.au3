; NOTES:
;  In order for SS_WHITERECT and SS_BLACKFRAME to successfully be applied at the same time
;  I must call GuiCtrlSetState(-1, SS_WHITERECT)  then call GuiCtrlSetState(-1, BitOr(SS_WHITERECT,SS_BLACKFRAME))
;
;  Code relies upon the _GuiLB_SetItemData feature....
;
;  I also try to prevent mutually exclusive items (e.g., SS_LEFT and SS_RIGHT) from being simultaneously selected 


GuiCreate("Rough Prototype of a Style Selector")

$reset = GuiCtrlCreateButton("Reset Style to Default", 250, 10, 150, 50)
$go = GuiCtrlCreateButton("ChangeStyle", 250, 100, 150, 150)
$label = GuiCtrlCreateLabel("Example Label", 250, 300, 150, 50)

$list = GuiCtrlCreateList("", 1, 10, 230, 400, 0x200008) ;$LBS_MULTIPLESEL + $WS_VSCROLL
GuiCtrlSetFont(-1, 9, 400, 0, "Courier New")

$ss = StringSplit("LEFT            ,CENTER          ,RIGHT           ,ICON            ,BLACKRECT       ,GRAYRECT        ,WHITERECT       ,BLACKFRAME      ,GRAYFRAME       ,WHITEFRAME      ,USERITEM        ,SIMPLE          ,LEFTNOWORDWRAP  ,OWNERDRAW       ,BITMAP          ,ENHMETAFILE     ,ETCHEDHORZ      ,ETCHEDVERT      ,ETCHEDFRAME     ,TYPEMASK        ,NOPREFIX        ,NOTIFY          ,CENTERIMAGE     ,RIGHTJUST       ,REALSIZEIMAGE   ,SUNKEN          ,ENDELLIPSIS     ,PATHELLIPSIS    ,WORDELLIPSIS    ,ELLIPSISMASK    " , ',')
$0x = StringSplit("0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,000A,000B,000C,000D,000E,000F,0010,0011,0012,001F,0080,0100,0200,0400,0800,1000,4000,8000,C000,C000" , ',')
$defaultStyle = 256 ;LEFT and NOTIFY

For $i = 1 to 30
   GuiCtrlSetData($list, "SS_" & $ss[$i] & "(0x" & $0x[$i] & ")")
   _GuiLB_SetItemData($list, $i-1, Dec($0x[$i]))
Next

; Pre-select SS_LEFT and SS_NOTIFY since they are part of the default style
_GuiLB_SetSel($list, 1, 21)
_GuiLB_SetSel($list, 1, 0)

$recentA = 0  ;which one of SS_LEFT and SS_CENTER and SS_NOTIFY is selected
$recentB = -99 ;BLACKRECT, GRAYRECT, WHITERECT
$recentC = -99 ;BLACKFRAME, GRAYFRAME, WHITEFRAME

GuiSetState()
While 1
   $msg = GuiGetMsg()
   If $msg = -3 Then
      ExitLoop
   ElseIf $msg = $reset Then
      _GuiLB_SetSel($list, 0, -1) ;un-select all
      _GuiLB_SetSel($list, 1, 21)
      _GuiLB_SetSel($list, 1, 0)
      GuiCtrlSetStyle($label, $defaultStyle)
      ToolTip("Style Debug: " & $defaultStyle, 0 , 0)
   ElseIf $msg = $go Then
      GuiCtrlSetStyle($label, $defaultStyle) ;resetting to default before applying new style helps...
      $s = _GetSelectedData($list)  ;also apply the settings along the way
      ;;;GuiCtrlSetStyle($label, $s)
      ToolTip("Style Debug: " & $s, 0 , 0)
   EndIf
      
   ; Do not allow conflicting styles to be selected simultaneously
   ;  For example, SS_LEFT and SS_CENTER and SS_RIGHT
   If _GuiLB_GetSelState($list, 0) And $recentA <> 0 Then
      _GuiLB_SetSel($list, 0, 1)
      _GuiLB_SetSel($list, 0, 2)
      $recentA = 0
   ElseIf _GuiLB_GetSelState($list, 1) And $recentA <> 1 Then
      _GuiLB_SetSel($list, 0, 0)
      _GuiLB_SetSel($list, 0, 2)
      $recentA = 1
   ElseIf _GuiLB_GetSelState($list, 2) And $recentA <> 2 Then
      _GuiLB_SetSel($list, 0, 0)
      _GuiLB_SetSel($list, 0, 1)
      $recentA = 2
   EndIf
   
   If _GuiLB_GetSelState($list, 4) And $recentB <> 4 Then
      _GuiLB_SetSel($list, 0, 5)
      _GuiLB_SetSel($list, 0, 6)
      $recentB = 4
   ElseIf _GuiLB_GetSelState($list, 5) And $recentB <> 5 Then
      _GuiLB_SetSel($list, 0, 4)
      _GuiLB_SetSel($list, 0, 6)
      $recentB = 5
   ElseIf _GuiLB_GetSelState($list, 6) And $recentB <> 6 Then
      _GuiLB_SetSel($list, 0, 4)
      _GuiLB_SetSel($list, 0, 5)
      $recentB = 6
   EndIf

   If _GuiLB_GetSelState($list, 7) And $recentC <> 7 Then
      _GuiLB_SetSel($list, 0, 8)
      _GuiLB_SetSel($list, 0, 9)
      $recentC = 7
   ElseIf _GuiLB_GetSelState($list, 8) And $recentC <> 8 Then
      _GuiLB_SetSel($list, 0, 7)
      _GuiLB_SetSel($list, 0, 9)
      $recentC = 8
   ElseIf _GuiLB_GetSelState($list, 9) And $recentC <> 9 Then
      _GuiLB_SetSel($list, 0, 7)
      _GuiLB_SetSel($list, 0, 8)
      $recentC = 9
   EndIf

Wend

 

; Returns the selection state of an item at the specified index; 1 == selected, 0 == not , -1 == invalid index
Func _GuiLB_GetSelState($ref, $index)
    Return GuiSendMsg($ref, 0x0187, $index, 0) ;LB_GETSEL
EndFunc


; An application sends an LB_SETITEMDATA message to set a 32-bit value associated
; with the specified item in a list box. 
Func _GuiLB_SetItemData($ref, $index, $value)
   GuiSendMsg($ref, 0x19A, $index, $value) ;LB_SETITEMDATA
EndFunc


; Returns the sum of the selected styles
Func _GetSelectedData($ref)
    ; Note:  The GuiSendMsg($ref,$LB_GETSELITEMS,...) will not work since it returns an array pointer
   Local $i, $style = 0
   For $i = 0 To GuiSendMsg($ref,0x018B,0,0) - 1  ;zero to GetCount-1
      If GuiSendMsg($ref,0x0187,$i,0) Then $style = BitOr(GuiSendMsg($ref,0x199,$i,0) , $style)
      GuiCtrlSetStyle($label, $style)
   Next
   Return $style ;note this contains a trailing comma!
EndFunc
 
 
 ; Set's the selection set of the specified index; $flag == 0 means unselect, $flag == 1 means select
; Perhaps I could also have $flag == 2 to mean toggle.....
; An index of -1 means to apply $flag to all items.
Func _GuiLB_SetSel($ref, $flag, $index)
    If $flag == 2 Then
        If $index == -1 Then
            For $index = 0 To GuiSendMsg($ref, 0x018B, 0, 0) ;0 to LB_GETCOUNT
                If GuiSendMsg($ref, 0x0187, $index, 0) Then ; If LB_GETSEL (state)...
                    GuiSendMsg($ref, 0x0185, 0, $index) ;LB_SETSEL
                Else
                    GuiSendMsg($ref, 0x0185, 1, $index) ;LB_SETSEL
                EndIf
            Next
        Else
            If GuiSendMsg($ref, 0x0187, $index, 0) Then ;If Selected Then
                Return GuiSendMsg($ref, 0x0185, 0, $index) ;LB_SETSEL
            Else
                Return GuiSendMsg($ref, 0x0185, 1, $index) ;LB_SETSEL
            EndIf
        EndIf
    Else
        Return GuiSendMsg($ref, 0x0185, $flag, $index) ;LB_SETSEL -- Then main function
    EndIf
EndFunc