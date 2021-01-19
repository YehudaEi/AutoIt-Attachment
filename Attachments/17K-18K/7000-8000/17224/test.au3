
; *******************************************************
; Example - Create an ownerdrawn/colored button
; *******************************************************

#include <GUIConstants.au3>
#include <array.au3>


Global Const $WM_DRAWITEM           = 0x002B
Global Const $WM_COMMAND            = 0x0111

Global Const $WM_TIMER = 0x0113

Global Const $WM_NOTIFY = 0x004E
Global Const $WM_LBUTTONDBLCLK = 0x0203
Global Const $WM_LBUTTONUP = 0x0202
Global Const $WM_RBUTTONDOWN = 0x0204
Global Const $WM_SETCURSOR = 0x0020
Global Const $WM_CONTEXTMENU = 0x007B

Global Const $HTCAPTION = 2
Global Const $WM_NCLBUTTONDOWN = 0xA1
Global Const $WM_NCMOUSEMOVE =0x00A0

Global Const $GWL_STYLE             = -16

Global Const $BS_OWNERDRAW          = 0x0000000B

Global Const $COLOR_BTNTEXT         = 18
Global Const $COLOR_BTNFACE         = 15
Global Const $COLOR_BTNSHADOW       = 16
Global Const $COLOR_HIGHLIGHTTEXT   = 14
Global Const $COLOR_GRAYTEXT        = 17

Global Const $DT_CENTER             = 0x00000001
Global Const $DT_RIGHT              = 0x00000002
Global Const $DT_VCENTER            = 0x00000004
Global Const $DT_BOTTOM             = 0x00000008
Global Const $DT_WORDBREAK          = 0x00000010
Global Const $DT_SINGLELINE         = 0x00000020
Global Const $DT_EXPANDTABS         = 0x00000040
Global Const $DT_TABSTOP            = 0x00000080
Global Const $DT_NOCLIP             = 0x00000100
Global Const $DT_EXTERNALLEADING    = 0x00000200
Global Const $DT_CALCRECT           = 0x00000400
Global Const $DT_NOPREFIX           = 0x00000800
Global Const $DT_INTERNAL           = 0x00001000

Global Const $ODS_SELECTED          = 0x0001
Global Const $ODS_GRAYED            = 0x0002
Global Const $ODS_DISABLED          = 0x0004
Global Const $ODS_CHECKED           = 0x0008
Global Const $ODS_FOCUS             = 0x0010
Global Const $ODS_HOTLIGHT          = 0x0040
Global Const $ODS_INACTIVE          = 0x0080
Global Const $ODS_NOACCEL           = 0x0100
Global Const $ODS_NOFOCUSRECT       = 0x0200

Global Const $ODT_BUTTON            = 4

Global Const $DFC_BUTTON            = 4
Global Const $DFCS_BUTTONPUSH       = 0x0010

Global Const $HWND_BOTTOM = 1
Global Const $HWND_BROADCAST = 0xFFFF
Global Const $HWND_DESKTOP = 0
Global Const $HWND_MESSAGE = -3
Global Const $HWND_NOTOPMOST = -2
Global Const $HWND_TOP = 0
Global Const $HWND_TOPMOST = -1
Global Const $SW_SHOWNORMAL = 1
Global Const $SW_SMOOTHSCROLL = 0x10
Global Const $SWP_ASYNCWINDOWPOS = 0x4000
Global Const $SWP_DEFERERASE = 0x2000
Global Const $SWP_FRAMECHANGED = 0x20
Global Const $SWP_DRAWFRAME = $SWP_FRAMECHANGED
Global Const $SWP_HIDEWINDOW = 0x80
Global Const $SWP_NOACTIVATE = 0x10
Global Const $SWP_NOCOPYBITS = 0x100
Global Const $SWP_NOMOVE = 0x2
Global Const $SWP_NOOWNERZORDER = 0x200
Global Const $SWP_NOREDRAW = 0x8
Global Const $SWP_NOREPOSITION = $SWP_NOOWNERZORDER
Global Const $SWP_NOSENDCHANGING = 0x400
Global Const $SWP_NOSIZE = 0x1
Global Const $SWP_NOZORDER = 0x4
Global Const $SWP_SHOWWINDOW = 0x40

Global Const $GWL_ID = -12

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Global $bClicked = 0, $timer, $bExpanded[100],$expid[100], $downinfo[2],$xy[2]

$hGUI       = GUICreate("My draggable Ownerdrawn Created Button", 600, 400, -1, -1, $WS_OVERLAPPEDWINDOW)

GUICtrlCreateLabel("Try to drag the yellow button. But the blue one below will follow the mouse."& @CRLF& "How can I make the upmost control receive the mouse message always?", 5, 5)


$nButton    = GUICtrlCreateButton("", 90, 70, 120, 30)
;~ GUICtrlSetStyle($nButton, BitOr($WS_TABSTOP, $BS_NOTIFY, $BS_OWNERDRAW)) ; Set the ownerdrawn flag
GUICtrlSetStyle($nButton, BitOr($WS_CLIPSIBLINGS, $BS_NOTIFY, $BS_OWNERDRAW)) ; Set the ownerdrawn flag

$nButton2   = GUICtrlCreateButton("Normal Button", 90, 200, 120, 30) ;get double click notification for normal button control
GUICtrlSetStyle($nButton2, BitOr($WS_CLIPSIBLINGS, $BS_NOTIFY)) ; Set the ownerdrawn flag
;~ GUICtrlSetStyle($nButton2, $BS_NOTIFY) ; Set the ownerdrawn flag

$nButton3 = GUICtrlCreateButton("www", 90, 50, 90, 90)
;~ GUICtrlSetStyle($nButton3, BitOr($WS_TABSTOP, $BS_NOTIFY, $BS_OWNERDRAW)) ; Set the ownerdrawn flag
GUICtrlSetStyle($nButton3, BitOr($BS_NOTIFY, $BS_OWNERDRAW,$WS_CLIPSIBLINGS)) ; Set the ownerdrawn flag
;~ WinSetOnTop($nButton3,"",1)

$nButton4   = GUICtrlCreateButton("bt4", 100, 215, 120, 30) ;get double click notification for normal button control
;~ GUICtrlSetStyle($nButton4, BitOr($WS_TABSTOP, $BS_NOTIFY, $BS_OWNERDRAW)) ; Set the ownerdrawn flag
GUICtrlSetStyle($nButton4, BitOr($WS_CLIPSIBLINGS, $BS_NOTIFY, $BS_OWNERDRAW)) ; Set the ownerdrawn flag

GUICtrlCreateLabel("The gray button is behind. Try to hover your mouse over the ownerdraw one, the gray button will come to the top."&@CRLF&"Why does the normal button go above the ownerdrawn button automatically when mouse is hovering?", 5, 145)



; WM_DRAWITEM has to registered before showing GUI otherwise the initial drawing isn't done
GUIRegisterMsg($WM_DRAWITEM, "MY_WM_DRAWITEM")
GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")
;~ GUIRegisterMsg($WM_TIMER, "MY_TIMER")
GUIRegisterMsg($WM_NCMOUSEMOVE, "MY_NCMOUSE_MOVE")

GUISetState()

	DllCall ("user32.dll", "int", "SetTimer", "hwnd", WinGetHandle(""), "int", 1, "int", 3000, "int", 0)	
;~ 	DllCall ("user32.dll", "hwnd", "SetCapture","hwnd",WinGetHandle(""))

;~ SetWindowPos($nButton3, $HWND_TOPMOST + $HWND_TOP, 0, 0, 0, 0, BitOR($SWP_NOMOVE,$SWP_NOSIZE))


While 1
    $GUIMsg = GUIGetMsg(1)
;~ 	if $GUIMsg[0]<>0 then ConsoleWrite($GUIMsg[0])
    
    Switch $GUIMsg[0]
	Case $GUI_EVENT_CLOSE
		DllCall ("user32.dll", "int", "KillTimer", "hwnd", WinGetHandle(""), "int", 1)
            ExitLoop
			
		Case $GUI_EVENT_PRIMARYDOWN
			
;~ 			ConsoleWrite("down..")
			$downinfo[0]=1
;~ 			_ArrayDisplay($GUIMsg)

$h = DllCall("user32.dll", "hwnd", "WindowFromPoint", "uint", MouseGetPos(0), "uint", MouseGetPos(1))
ConsoleWrite($h[0])
$id = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", $h[0], "int", $GWL_ID)
ConsoleWrite("|"&$id) ;why empty here?

			$rt = GUIGetCursorInfo()
			if $rt <> 0 Then
			if $rt[4] <> 0 Then ;$array[4] = ID of the control that the mouse cursor is hovering over (or 0 if none)
				
				$downinfo[1]=$rt[4]
				
				$pos = ControlGetPos("","",$rt[4])
				$xy[0] = -$pos[0]+ $GUIMsg[3]
				$xy[1] = -$pos[1]+ $GUIMsg[4]
				
				if $bExpanded[$rt[4]] Then
					GUICtrlSetPos($expid[$rt[4]],$pos[0]+$pos[2]+5, $pos[1])
				EndIf
				
;~ 				Beep(5000,10)
;~ SetWindowPos($nButton3, $HWND_TOPMOST + $HWND_TOP, 0, 0, 0, 0, BitOR($SWP_NOMOVE,$SWP_NOSIZE,$SWP_SHOWWINDOW))
;~ 				WinSetOnTop($rt[4],"",1)
DllCall("user32.dll", "int", "BringWindowToTop", 'hwnd', GUICtrlGetHandle($rt[4]))

			Else
				DllCall ("user32.dll", "int", "SendMessage", "hwnd", WinGetHandle(""), "int", $WM_NCLBUTTONDOWN, "int", $HTCAPTION, "int", 0)	
			EndIf
			EndIf
		Case $GUI_EVENT_PRIMARYUP
;~ 			ConsoleWrite("up..")
			$downinfo[0]=0
			$downinfo[1]=0

		Case $GUI_EVENT_MOUSEMOVE
;~ 			ConsoleWrite("moving..")
			if $downinfo[0]=1 and $downinfo[1]<>0 Then
				;move the control, current x,y are in $nMsg[3],[4]
;~ 				$xy = RelativeCenter($downinfo[1])
;~ 				$xy[0] = 5
;~ 				$xy[1] = 5

				GUICtrlSetPos($downinfo[1],$GUIMsg[3]-$xy[0],$GUIMsg[4]-$xy[1])
				$pos = ControlGetPos("","",$downinfo[1])
				GUICtrlSetPos($expid[$downinfo[1]],$pos[0]+$pos[2]+5, $pos[1])
;~ 				WinSetOnTop($downinfo[1],"",1)
DllCall("user32.dll", "int", "BringWindowToTop", 'hwnd', GUICtrlGetHandle($downinfo[1]))
			EndIf
       Case $nButton
            ; Normally should not run through cause of our MY_WM_COMMAND function
            Msgbox(0, "Info", "Button pressed") 
            
        Case $nButton2
            ; Normally should not run through cause of our MY_WM_COMMAND function
           Msgbox(0, "Info", "Button2 pressed")
    EndSwitch
WEnd

Exit




Func SetWindowPos($hwnd, $InsertHwnd, $X, $Y, $cX, $cY, $uFlags)
    $ret = DllCall("user32.dll", "long", "SetWindowPos", "hwnd", $hwnd, "hwnd", $InsertHwnd, _
                    "int", $X, "int", $Y, "int", $cX, "int", $cY, "long", $uFlags)
    Return $ret[0]
EndFunc 

Func MY_TIMER($hWnd, $Msg, $wParam, $lParam)
	Beep(1500,500)
	Return $GUI_RUNDEFMSG
EndFunc

Func MY_NCMOUSE_MOVE($hWnd, $Msg, $wParam, $lParam)
;~ 	ConsoleWrite("nc_move..")
	Return $GUI_RUNDEFMSG
EndFunc


; React on a button click
Func MY_WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    $nNotifyCode    = BitShift($wParam, 16)
    $nID            = BitAnd($wParam, 0x0000FFFF)
    $hCtrl          = $lParam
	
	;if $nID=3 and $nNotifyCode = 5 Then ;double click
	if $nNotifyCode = 5 Then; BN_DOUBLECLICKED message
;~ 		MsgBox(0,"","control "&$nID&" was double clicked!")
		$bExpanded[$nID] = Not $bExpanded[$nID]
		;draw expanded contents
		if $bExpanded[$nID] Then
			$pos = ControlGetPos("","",$nID)
;~ 		_ArrayDisplay($pos)
;~ 			$expid[$nID]=GUICtrlCreateLabel("exp1",$pos[0]+$pos[2]+5, $pos[1],40,20,$SS_SUNKEN ) ;no handle cannot be moved
			$expid[$nID]=GUICtrlCreateInput("exp:"&$nID,$pos[0]+$pos[2]+5, $pos[1],40,20,$SS_SUNKEN ) ;no handle cannot be moved
			GUICtrlSetBkColor($expid[$nID],0xffff00)
		Else
			GUICtrlDelete($expid[$nID])
;~ 			MsgBox(0,"","control "&$nID&" was double clicked!")
		endif 
		
	EndIf
	return 0

    ; Proceed the default Autoit3 internal message commands.
    ; You also can complete let the line out.
    ; !!! But only 'Return' (without any value) will not proceed
    ; the default Autoit3-message in the future !!!
;~     Return $GUI_RUNDEFMSG
EndFunc


; RePost a WM_COMMAND message to a ctrl in a gui window
Func PostButtonClick($hWnd, $nCtrlID)
    DllCall("user32.dll", "int", "PostMessage", _
                                    "hwnd", $hGUI, _
                                    "int", $WM_COMMAND, _
                                    "int", BitAnd($nCtrlID, 0x0000FFFF), _
                                    "hwnd", GUICtrlGetHandle($nCtrlid))
EndFunc


; Draw the button
Func MY_WM_DRAWITEM($hWnd, $Msg, $wParam, $lParam) ;wParam contains the control ID
    Local $stDrawItem = DllStructCreate("uint;uint;uint;uint;uint;uint;uint;int[4];dword", $lParam)
    
    $nCtlType = DllStructGetData($stDrawItem, 1)
    If $nCtlType = $ODT_BUTTON Then
;~ 		ConsoleWrite("re-drawing..")
        $nCtrlID    = DllStructGetData($stDrawItem, 2)
        $nItemState = DllStructGetData($stDrawItem, 5)
        $hCtrl      = DllStructGetData($stDrawItem, 6)
        $hDC        = DllStructGetData($stDrawItem, 7)
        $nLeft      = DllStructGetData($stDrawItem, 8, 1)
        $nTop       = DllStructGetData($stDrawItem, 8, 2)
        $nRight     = DllStructGetData($stDrawItem, 8, 3)
        $nBottom    = DllStructGetData($stDrawItem, 8, 4)
		if $wParam <> 6 Then
			$sText      = "Ownerdrawn"
			$nTextColor = 0x5555DD
			$nBackColor = 0xFFEEDD
		Else
			$sText      = "MD"
			$nTextColor = 0xFF55DD
			$nBackColor = 0x33EEDD
		EndIf
		
        DrawButton($hWnd, $hCtrl, $hDC, $nLeft, $nTop, $nRight, $nBottom, $nItemState, $sText, $nTextColor, $nBackColor)
		
;~ 		SetWindowPos($nButton2, $HWND_TOPMOST + $HWND_TOP, 0, 0, 0, 0, BitOR($SWP_NOMOVE,$SWP_NOSIZE,$SWP_SHOWWINDOW))
;~ WinSetOnTop($nButton3,"",1)

        $stDrawItem = 0
        Return 1
	EndIf

    $stDrawItem = 0
    Return $GUI_RUNDEFMSG ; Proceed the default Autoit3 internal message commands
EndFunc


; The main drawing procedure
Func DrawButton($hWnd, $hCtrl, $hDC, $nLeft, $nTop, $nRight, $nBottom, $nItemState, $sText, $nTextColor, $nBackColor)
    ;Local $bDefault    = FALSE
    Local $bChecked = BitAnd($nItemState, $ODS_CHECKED)
    Local $bFocused = BitAnd($nItemState, $ODS_FOCUS)
    Local $bGrayed  = BitAnd($nItemState, BitOr($ODS_GRAYED, $ODS_DISABLED))
    Local $bSelected= BitAnd($nItemState, $ODS_SELECTED)

    $stRect = DllStructCreate("int;int;int;int")
    DllStructSetData($stRect, 1, $nLeft)
    DllStructSetData($stRect, 2, $nTop)
    DllStructSetData($stRect, 3, $nRight)
    DllStructSetData($stRect, 4, $nBottom)
    
    If $bGrayed Then
        $nClrTxt    = SetTextColor($hDC, GetSysColor($COLOR_HIGHLIGHTTEXT))
    ElseIf $nTextColor = -1 Then
        $nClrTxt    = SetTextColor($hDC, GetSysColor($COLOR_BTNTEXT))
    Else
        $nClrTxt    = SetTextColor($hDC, $nTextColor)
    EndIf
    
    If $nBackColor = -1 Then
        $hBrush     = GetSysColorBrush($COLOR_BTNFACE)
        $nClrSel    = GetSysColor($COLOR_BTNFACE)
    Else
        $hBrush     = CreateSolidBrush($nBackColor)
        $nClrSel    = $nBackColor;
    EndIf

    $nClrBk         = SetBkColor($hDC, $nClrSel)
    $hOldBrush      = SelectObject($hDC, $hBrush)

    $nTmpLeft   = $nLeft
    $nTmpTop    = $nTop
    $nTmpRight  = $nRight
    $nTmpBottom = $nBottom
    
    If $bSelected Then
        InflateRect($nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, -1, -1)
        $hBrushSel = CreateSolidBrush(GetSysColor($COLOR_BTNSHADOW))
        FrameRect($hDC, $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, $hBrushSel)
        DeleteObject($hBrushSel)
    Else
        If $bFocused And Not $bSelected Then InflateRect($nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, -1, -1)
        DrawFrameControl($hDC, $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, $DFC_BUTTON, $DFCS_BUTTONPUSH)
    EndIf
    
    $nTmpLeft   = $nLeft
    $nTmpTop    = $nTop
    $nTmpRight  = $nRight
    $nTmpBottom = $nBottom
    
    If $bSelected Then
        InflateRect($nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, -2, -2)
    Else
        If $bFocused And Not $bSelected Then
            InflateRect($nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, -3, -3)
            $nTmpLeft -= 1
            $nTmpTop -= 1
        Else
            InflateRect($nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, -2, -2)
            $nTmpLeft -= 1
            $nTmpTop -= 1
        EndIf
    EndIf
    
    FillRect($hDC, $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, $hBrush)
    
    If $bSelected Or $bGrayed Then
        $nTmpLeft = $nTmpLeft + 2
        $nTmpTop = $nTmpTop +2
    EndIf
    
    $uFlags = BitOr($DT_NOCLIP, $DT_CENTER, $DT_VCENTER)

    If Not BitAnd(GetWindowLong($hCtrl, $GWL_STYLE), $BS_MULTILINE) Then $uFlags = BitOr($uFlags, $DT_SINGLELINE)
    
    DrawText($hDC, $sText, $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, $uFlags)

    If $bGrayed Then
        $nTmpLeft   = $nLeft
        $nTmpTop    = $nTop
        $nTmpRight  = $nRight
        $nTmpBottom = $nBottom
        
        $nTmpLeft -= 1
        
        $nClrTxt    = SetTextColor($hDC, GetSysColor($COLOR_GRAYTEXT))
        DrawText($hDC, $sText, $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, BitOr($DT_NOCLIP, $DT_CENTER, $DT_VCENTER, $DT_SINGLELINE))
    EndIf

    $nTmpLeft   = $nLeft
    $nTmpTop    = $nTop
    $nTmpRight  = $nRight
    $nTmpBottom = $nBottom
        
    If $bFocused Then
        $hBrush = CreateSolidBrush(0)
        FrameRect($hDC, $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, $hBrush)
        
        $nTmpLeft   = $nLeft
        $nTmpTop    = $nTop
        $nTmpRight  = $nRight
        $nTmpBottom = $nBottom
        
        InflateRect($nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom, -4, -4)
        DrawFocusRect($hDC, $nTmpLeft, $nTmpTop, $nTmpRight, $nTmpBottom)
    EndIf

    SelectObject($hDC, $hOldBrush)
    DeleteObject($hBrush)
    SetTextColor($hDC, $nClrTxt)
    SetBkColor($hDC, $nClrBk)
         
    Return 1
EndFunc


; Some graphic / windows functions
Func CreateSolidBrush($nColor)
    Local $hBrush = DllCall("gdi32.dll", "hwnd", "CreateSolidBrush", "int", $nColor)
    Return $hBrush[0]
EndFunc


Func GetSysColor($nIndex)
    Local $nColor = DllCall("user32.dll", "int", "GetSysColor", "int", $nIndex)
    Return $nColor[0]
EndFunc


Func GetSysColorBrush($nIndex)
    Local $hBrush = DllCall("user32.dll", "hwnd", "GetSysColorBrush", "int", $nIndex)
    Return $hBrush[0]
EndFunc


Func DrawFrameControl($hDC, $nLeft, $nTop, $nRight, $nBottom, $nType, $nState)
    Local   $stRect = DllStructCreate("int;int;int;int")
    
    DllStructSetData($stRect, 1, $nLeft)
    DllStructSetData($stRect, 2, $nTop)
    DllStructSetData($stRect, 3, $nRight)
    DllStructSetData($stRect, 4, $nBottom)
    
    DllCall("user32.dll", "int", "DrawFrameControl", "hwnd", $hDC, "ptr", DllStructGetPtr($stRect), "int", $nType, "int", $nState)

    $stRect = 0
EndFunc


Func DrawFocusRect($hDC, $nLeft, $nTop, $nRight, $nBottom)
    Local   $stRect = DllStructCreate("int;int;int;int")
    
    DllStructSetData($stRect, 1, $nLeft)
    DllStructSetData($stRect, 2, $nTop)
    DllStructSetData($stRect, 3, $nRight)
    DllStructSetData($stRect, 4, $nBottom)
    
    DllCall("user32.dll", "int", "DrawFocusRect", "hwnd", $hDC, "ptr", DllStructGetPtr($stRect))
    
    $stRect = 0
EndFunc


Func DrawText($hDC, $sText, $nLeft, $nTop, $nRight, $nBottom, $nFormat)
    Local $nLen = StringLen($sText)
    
    Local $stRect = DllStructCreate("int;int;int;int")
    DllStructSetData($stRect, 1, $nLeft)
    DllStructSetData($stRect, 2, $nTop)
    DllStructSetData($stRect, 3, $nRight)
    DllStructSetData($stRect, 4, $nBottom)
    
    Local $stText = DllStructCreate("char[260]")
    DllStructSetData($stText, 1, $sText)
    
    DllCall("user32.dll", "int", "DrawText", "hwnd", $hDC, "ptr", DllStructGetPtr($stText), "int", $nLen, "ptr", DllStructGetPtr($stRect), "int", $nFormat)
    
    $stRect = 0
    $stText = 0
EndFunc


Func FillRect($hDC, $nLeft, $nTop, $nRight, $nBottom, $hBrush)
    Local   $stRect = DllStructCreate("int;int;int;int")
    
    DllStructSetData($stRect, 1, $nLeft)
    DllStructSetData($stRect, 2, $nTop)
    DllStructSetData($stRect, 3, $nRight)
    DllStructSetData($stRect, 4, $nBottom)
    
    DllCall("user32.dll", "int", "FillRect", "hwnd", $hDC, "ptr", DllStructGetPtr($stRect), "hwnd", $hBrush)
    
    $stRect = 0
EndFunc


Func FrameRect($hDC, $nLeft, $nTop, $nRight, $nBottom, $hBrush)
    Local   $stRect = DllStructCreate("int;int;int;int")
    
    DllStructSetData($stRect, 1, $nLeft)
    DllStructSetData($stRect, 2, $nTop)
    DllStructSetData($stRect, 3, $nRight)
    DllStructSetData($stRect, 4, $nBottom)
    
    DllCall("user32.dll", "int", "FrameRect", "hwnd", $hDC, "ptr", DllStructGetPtr($stRect), "hwnd", $hBrush)
    
    $stRect = 0
EndFunc


Func InflateRect(ByRef $nLeft, ByRef $nTop, ByRef $nRight, ByRef $nBottom, $nX, $nY)
    Local   $stRect = DllStructCreate("int;int;int;int")
    
    DllStructSetData($stRect, 1, $nLeft)
    DllStructSetData($stRect, 2, $nTop)
    DllStructSetData($stRect, 3, $nRight)
    DllStructSetData($stRect, 4, $nBottom)
    
    DllCall("user32.dll", "int", "InflateRect", "ptr", DllStructGetPtr($stRect), "int", $nX, "int", $nY)
    
    $nLeft      = DllStructGetData($stRect, 1)
    $nTop       = DllStructGetData($stRect, 2)
    $nRight     = DllStructGetData($stRect, 3)
    $nBottom    = DllStructGetData($stRect, 4)
    
    $stRect = 0
EndFunc


Func SetBkColor($hDC, $nColor)
    Local $nOldColor = DllCall("gdi32.dll", "int", "SetBkColor", "hwnd", $hDC, "int", $nColor)
    Return $nOldColor[0]
EndFunc


Func SetTextColor($hDC, $nColor)
    Local $nOldColor = DllCall("gdi32.dll", "int", "SetTextColor", "hwnd", $hDC, "int", $nColor)
    Return $nOldColor[0]
EndFunc


Func SelectObject($hDC, $hObj)
    Local $hOldObj = DllCall("gdi32.dll", "hwnd", "SelectObject", "hwnd", $hDC, "hwnd", $hObj)
    Return $hOldObj[0]
EndFunc


Func DeleteObject($hObj)
    Local $nResult = DllCall("gdi32.dll", "hwnd", "DeleteObject", "hwnd", $hObj)
EndFunc


Func GetWindowLong($hWnd, $nIndex)
    Local $nVal = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", $hWnd, "int", $nIndex)
    Return $nVal[0]
EndFunc
