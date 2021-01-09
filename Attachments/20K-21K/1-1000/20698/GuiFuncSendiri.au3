;#NoTrayIcon
#include <GuiConstants.au3>


$CloseDefault = 'close0.bmp'
$CloseHoover = 'close1.bmp'
$CloseClick = 'close2.bmp'
$MinDefault = 'min0.bmp'
$MinHoover = 'min1.bmp'
$MinClick = 'min2.bmp'

$ico = @ScriptDir & "\Folder Blue Documents.ico"
Opt("GUIEventOptions",1)
$TopImage = "Top.gif"
Global $Parent

ZAguicreate("Sendiri Cuba cuba",470,400,$TopImage,30,$ico,12)
ZAguicreateBg(430,330,20,20,0xFFFFFF,$Parent)



While 1
	Sleep(10)
WEnd

; =========================================================================================================================
; Function: 	ZAguicreate($title,$x,$y,$GuiImage,$GIy,$ico,$titleFontSize)
;
; Description:	Creates a Gui using your own image as a top bar
;
; Requirements: #include <GuiConstants.au3>
;
; Parameters:	$title			- your title
;				$x 				- x Coordinate for Creation
;				$y				- y Coordinate for Creation
;				$GuiImage		- your image(.gif;.bmp)
;				$ico			- your icon file
;				$titleFontSize	- your title size
;
; Usage: 		$ZAguicreate("Sendiri Cuba cuba",473,400,$TopImage,30,$ico,12)
; Author(s):    Z.A.Z.A
; =========================================================================================================================

Func ZAguicreate($title,$x,$y,$GuiImage,$GIy,$ico,$titleFontSize)
	If $x < 250 Then $x = 250
	If $y < 50 Then $y = 50
	If $GIy < 25 Then $GIy = 25
	
$Main_GUI2 = GuiCreate($title, $x, $y, -1, -1, $WS_POPUP, $WS_EX_LAYERED); + $WS_CLIPCHILDREN)
GUICtrlCreatePic($GuiImage, 0, 0, $x, $GIy, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG); Graphic for window dragging
$Title_Label = GUICtrlCreateLabel($title, 0, (Ceiling($GIy/2)-8), (Ceiling($x/2)+110), 17, $SS_CENTER)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetResizing(-1, 512)
GUICtrlSetFont(-1,$titleFontSize, 700, 0, "Arial")
$Icon1 = GUICtrlCreateIcon($ico, 0, 70,10, 16, 16)
$winmin_sett = GUICtrlCreatePic ($MinDefault,$x-72,0,26,17, BitOR($SS_NOTIFY,$WS_GROUP))
$winclose_sett = GUICtrlCreatePic ($CloseDefault,$x-47,0,43,17, BitOR($SS_NOTIFY,$WS_GROUP))
_GuiRoundCorners($Main_GUI2, 0, 0, 15, 15)
GUISetState(@SW_SHOW, $Main_GUI2)
$Parent = GUICreate("", $x, (Ceiling($y-$GIy)), 0, 30, $WS_CHILD, -1, $Main_GUI2)
GUISetBkColor(0xe1e1e1)
GUISetState(@SW_SHOW, $Parent)
EndFunc

; =========================================================================================================================
; Function: 	ZAguicreateBg($bgw,$bgh,$x,$y,$bgc,$Hwnd)
;
; Description:	Creates a a background color for your ZAgui
;
; Requirements: 
;
; Parameters:	$bgw			- your background width
;				$bgh			- your background height
;				$x				- x background coordinate from your ZAgui
;				$y				- y background coordinate from your ZAgui
;				$bgc			- Background color
;				$Hwnd			- window handle($Parent)
;
; Usage: 		ZAguicreateBg(430,330,20,20,0xFFFFFF,$Parent)
; Author(s):    Z.A.Z.A
; =========================================================================================================================

Func ZAguicreateBg($bgw,$bgh,$x,$y,$bgc,$Hwnd)
$Child = GUICreate("",$bgw,$bgh,$x,$y, $WS_CHILD, -1, $Hwnd)
GUISetBkColor($bgc)
GUISetState(@SW_SHOW, $Child)
EndFunc

;;---FUNCTION UNTUK BUAT ROUND CORNER KT GUI---------->
Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3);==>_GuiRoundCorners
   Dim $pos, $ret, $ret2
   $pos = WinGetPos($h_win)
    $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long",  $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3,  "long", $i_y3)
   If $ret[0] Then
      $ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $ret[0], "int", 1)
      If $ret2[0] Then
         Return 1
      Else
         Return 0
      EndIf
   Else
      Return 0
   EndIf
EndFunc ;==>_GuiRoundCorners




#cs
CreateDynamicMenuBar(0,0,473,20,1,$Master_GUI)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $BTN_EXIT
			ExitLoop
		Case $msg = $BTN_EXIT2
			Minimize()
			
	EndSelect
WEnd
#ce



#cs
Func Minimize()
	Traytip ("My App", "click here to restore", 5)
	GUISetState(@SW_MINIMIZE, $Main_GUI2)
	GUISetState(@SW_MINIMIZE, $Master_GUI)
	GUISetState(@SW_MINIMIZE, $Child)
	GuiSetState(@SW_HIDE, $Main_GUI2)
	GuiSetState(@SW_HIDE, $Master_GUI)
	GuiSetState(@SW_HIDE, $Child)
	
	TraySetState(1)
	
EndFunc   ;==>Minimize

Func Restore()
	
	GUISetState(@SW_RESTORE, $Main_GUI2)
	GUISetState(@SW_RESTORE, $Master_GUI)
	GUISetState(@SW_RESTORE, $Child)
	GuiSetState(@SW_Show,$Main_GUI2)
	GuiSetState(@SW_Show,$Master_GUI)
	GuiSetState(@SW_Show, $Child)
    TraySetState(2)

EndFunc   ;==>Minimize


Func CreateDynamicMenuBar($DMB_x, $DMB_y, $DMB_width, $DMB_height, $DMB_Opt, $DBM_hWin)
	
	If $DMB_Opt = 0 Then
		$_hWIN = GUICreate("", $DMB_width, $DMB_height, $DMB_x, $DMB_y, BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOOLWINDOW, $DBM_hWin)
		GUISetBkColor($MenuInactiveColor)
		GUISetState(@SW_ENABLE, $_hWIN)
		GUISetState(@SW_SHOW, $_hWIN)
		$_MenuDecoration = 0
	ElseIf $DMB_Opt = 1 Then
		$_hWIN = GUICreate("", $DMB_width, $DMB_height + 2, $DMB_x, $DMB_y, BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOOLWINDOW, $DBM_hWin)
		GUICtrlCreateLabel("", 0, $DMB_height, $DMB_width, 2, $SS_ETCHEDFRAME)
		GUISetBkColor($MenuInactiveColor)
		GUISetState(@SW_ENABLE, $_hWIN)
		GUISetState(@SW_SHOW, $_hWIN)
		$_MenuDecoration = 1
	EndIf
	
	$_MainGUI = $DBM_hWin
	
EndFunc   ;==>CreateDynamicMenuBar
#ce
