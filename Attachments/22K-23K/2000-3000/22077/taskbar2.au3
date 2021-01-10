#include <GUIConstants.au3>
#include <guilistview.au3>
$var = WinList()
;~ GUICtrlCreatePic ("",left,top,wi,he,)
;~ GUICreate("",with,height,left,top)
;~ #Region ### START Koda GUI section ### Form=
;~ $Form0 = GUICreate("title",20 + 75 * 4 +20 + 15, @DesktopHeight - 50, @DesktopWidth - 20 - 75 * 4 -15 -10,0,$WS_POPUP)
;~ GUISetBkColor(0x1f1f1f)
;~ $Pic = GUICtrlCreatePic("Z:\My Documents\vista.bmp", 0, 0,20 + 75 * 4 +20 + 20,15)
;~ $Pic2 = GUICtrlCreatePic("Z:\My Documents\vistaborder.bmp", 0, 15,10,@DesktopHeight - 55)
;~ WinSetTrans("title","",160)
;~ $Task = GUICtrlCreateLabel("Taskbar",50,0,100,15)
;~ GUICtrlSetFont(-1, 10, 400, 2, "Comic Sans MS")
;~ GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
;~ GUICtrlSetColor(-1,0xFFFFFF)
;~ GUISetState(@SW_SHOW)
$Form1 = GUICreate("taskbar", 20 + 75 * 4 +20, @DesktopHeight - 75, @DesktopWidth - 20 - 75 * 4 -20, 15)
GUISetState(@SW_SHOW)
$List1 = GUICtrlCreateListView("windows                                  ", 10, 10, 75 * 4 + 20, @DesktopHeight - 85 - 40 -40)
Dim $list2[$var[0][0] + 1]
For $i = 1 To $var[0][0]
    If $var[$i][0] <> "" And IsVisible($var[$i][1]) Then
        $list2[$i] = GUICtrlCreateListViewItem($var[$i][0], $List1)
        GUISetState(@SW_SHOW)
    EndIf
Next
$edit1 = GUICtrlCreateEdit('',20,@DesktopHeight - 85 - 40 -25, 75 * 4 + 20,40)
GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")
$button1 = GUICtrlCreateButton ("minimize",20, @DesktopHeight - 100,75,15)
$button2 = GUICtrlCreateButton ("restore",20 + 75,@DesktopHeight - 100,75,15)
$button3 = GUICtrlCreateButton ("refresh",20 + 75 * 2,@DesktopHeight - 100,75,15)
$button4 = GUICtrlCreateButton (">",0, (@DesktopHeight - 75) /2 ,10,30)
GUICtrlSetColor(-1 ,0x0000ff)
GUICtrlSetFont(-1,16,500,1,"terminal")
GUICtrlSetBkColor (-1,0xFFFFE1)
Func IsVisible($handle)
    If BitAND(WinGetState($handle), 2) Then
        Return 1
    Else
        Return 0
    EndIf

EndFunc  ;==>IsVisible

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $List1
            ConsoleWrite("list1 clicked" & @CRLF)
        Case $button1
			minimize ()
		Case $button2
			restore ()
		Case $button3
			refresh ()
		Case $button4
			Exit
;~ 		case $Pic	
;~ 			WinActivate ("taskbar")
    EndSwitch
WEnd

Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
    If ControlGetFocus('Testing') <> 'Edit1' Then
        #forceref $hWndGUI, $MsgID, $wParam
        Local $tagNMHDR, $event
        $tagNMHDR = DllStructCreate("int;int;int", $lParam);NMHDR (hwndFrom, idFrom, code)
        If @error Then Return
        $event = DllStructGetData($tagNMHDR, 3)
        Select
            Case $wParam = $List1

                Select
                    Case $event = $NM_CLICK
                        Local $tagNMITEMACTIVATE = DllStructCreate("int;int;int;int;int;int;int;int;int", $lParam)
                        $selected = DllStructGetData($tagNMITEMACTIVATE, 4)
                        $selcol = DllStructGetData($tagNMITEMACTIVATE, 5)
            
                        $seltxt = StringSplit(GUICtrlRead(GUICtrlRead($List1)),'|')
                        
                        GUICtrlSetData($Edit1, $seltxt[1 + $selcol])
                EndSelect
        EndSelect
        
        Return $GUI_RUNDEFMSG
    EndIF
EndFunc  ;==>WM_Notify_Events


func minimize ()
	$windowToMinimize = GUICtrlRead ($edit1)
	$winminimize = $windowToMinimize
	WinSetState($winminimize ,"",@SW_MINIMIZE)
EndFunc	

func restore ()
	$windowToRestore = GUICtrlRead ($edit1)
	$winrestore = $windowToRestore
	WinSetState($winrestore ,"",@SW_RESTORE)
EndFunc	

func refresh ()
Run (@ScriptDir & "\refresh.exe")
exit
EndFunc