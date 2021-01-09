#include <GuiConstants.au3>
#include <Hover.au3>
Opt("GUIOnEventMode", 1)

$Skin_Folder = @ScriptDir & "\images"
$width = 470
$height = 350
$title = "YouTube Download v1.0"	; title
Global $Close, $Minimize
Local $m_click
Local $m_last
$But_Folder = $Skin_Folder & "\button"
	Local $ZAbutton[6]
	For $Zb = 0 To 5
		$ZAbutton[$Zb] = $But_Folder & "\" & $Zb & ".bmp"
		If Not FileExists($ZAbutton[$Zb]) Then ZAerror("button not found")
	Next
$CloseDefault = $ZAbutton[3]
$CloseHoover = $ZAbutton[4]
$CloseClick = $ZAbutton[5]
$MinDefault = $ZAbutton[0]
$MinHoover = $ZAbutton[1]
$MinClick = $ZAbutton[2]	


ZAskinCreate($title,$width,$height,$Skin_Folder)

While 1
	CheckIfpressed()
	Sleep(10)
WEnd

; =========================================================================================================================
; Function: 	ZAskinCreate($title,$width,$height,$Skin_Folder)
;
; Description:	Advance skin GUI
;
; Requirements: #include <GuiConstants.au3>
;
; Parameters:	$title			- your title
;				$width = 473	- width Gui
;				$height = 400	- height Gui
;				$Ix = 51		- top image height
;				$Iw = 23		- top image width
;				$ITw = 340		- top image width @ Master image
;				$Ibx = 23		- bottom image height
;				$Ibw = 23		- botttom image width
;				$Skin_Folder	- your skin folder
;
; Usage: 		ZAskinCreate("Sendiri Function",473,400,$Skin_Folder)
; Author(s):    Z.A.Z.A
; =========================================================================================================================

Func ZAskinCreate($title,$width,$height,$Skin_Folder)
If Not FileExists($Skin_Folder) Then ZAerror("Skin folder not found")
$Ix = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Top Image Height", 51)
$Iw = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Top Image Width", 23)
$ITw = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Master Image Width", 340)
$Ibx = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Bottom Image Height", 23)
$Ibw = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Bottom Image Width", 23)
$bkgd = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Background", 0xd4d0c7)
$Dlbl = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Title Label Distance", 0)
$Clbl = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Title Label Color", 0x000000)
$Flbl = IniRead($Skin_Folder & "\ZAskin.ini", "settings", "Title Label Font", "Arial")

	If $width < $ITw Then $width = $ITw+70
	Local $ZAskin[9]
	For $Zs = 0 To 8
		$ZAskin[$Zs] = $Skin_Folder & "\" & $Zs & ".gif"
		If Not FileExists($ZAskin[$Zs]) Then ZAerror("no picture found")
	Next
	$Main_GUI2 = GUICreate($title,$width,$height, -1, -1, $WS_POPUP)
	GUISetBkColor($bkgd)
	_GuiRoundCorners($Main_GUI2, 0, 0, 15, 15)
	GUICtrlCreatePic($ZAskin[0], 0, 0, $Iw, $Ix, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($ZAskin[3],($width - $Iw), 0,$Iw, $Ix, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($ZAskin[6], 0,($height - $Ibx), $Ibw, $Ibx, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($ZAskin[8],($width - $Ibw),($height - $Ibx), $Ibw, $Ibx, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($ZAskin[1], $Iw, 0, $ITw, $Ix, $WS_CLIPSIBLINGS)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlCreatePic($ZAskin[2],($Iw+$ITw), 0,($width-(($Iw*2)+$ITw)), $Ix, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($ZAskin[7], $Ibw,($height - $Ibx), ($width -($Ibw *2 )), $Ibx, $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($ZAskin[4], 0, $Ix, $Ibw,($height - ($Ix + $Ibx)), $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreatePic($ZAskin[5],($width-$Ibw), $Ix, $Ibw,($height - ($Ix + $Ibx)), $WS_CLIPSIBLINGS)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel("", 0, 0, ($width-73), $Ix, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetCursor (-1, 9)
	GUICtrlCreateLabel($title, $Dlbl,(Ceiling($Ix/6)), 340, 17, $SS_CENTER)
	GUICtrlSetColor(-1,$Clbl)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetResizing(-1, 512)
	GUICtrlSetFont(-1, 12, 700, 0, $Flbl)
	$Minimize = GUICtrlCreatePic ($MinDefault,($width-72),0,26,17, BitOR($SS_NOTIFY,$WS_GROUP))
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
	GUICtrlSetOnEvent(-1,"_wmin")
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$Close = GUICtrlCreatePic ($CloseDefault,($width-46),0,43,17, BitOR($SS_NOTIFY,$WS_GROUP))
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	GUICtrlSetOnEvent(-1,"_Exit")
	GUISetState(@SW_SHOW)
EndFunc

;;---FUNCTION UNTUK BUAT RAOUND CORNER KT GUI---------->
Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3);==>thanks gafrost
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

Func Hover_Func($CtrlID)
	Switch $CtrlID
		Case $Close
			GUICtrlSetImage($CtrlID, $CloseHoover)
		Case $Minimize
			GUICtrlSetImage($CtrlID, $MinHoover)
	EndSwitch
EndFunc

Func Leave_Hover_Func($CtrlID)
	Switch $CtrlID
		Case $Close
			GUICtrlSetImage($CtrlID, $CloseDefault)
		Case $Minimize
			GUICtrlSetImage($CtrlID, $MinDefault)
	EndSwitch
EndFunc

Func SetClicked($CtrlID)
	Switch($CtrlID)
	   Case $Close
		   GUICtrlSetImage($CtrlID, $CloseClick)
		Case $Minimize
			GUICtrlSetImage($CtrlID, $MinClick)
	EndSwitch
EndFunc

Func CheckIfpressed()
	$exec_CtrlId=""
	$mouse = GUIGetCursorInfo()
        If Not (@error) And IsArray($mouse) Then
			If $mouse[2] <> $m_click Then
                If $mouse[2] Then
					SetClicked($m_last)
				Else
					Hover_Func($m_last)
				   ;set flag for exection of m_last
				   $exec_CtrlId = $m_last;
                EndIf
            EndIf
			$m_last = $mouse[4]
			$m_click = $mouse[2]
        EndIf
EndFunc

Func _Exit()
	Local $Main_GUI2
	Sleep (100)
	GUIDelete($Main_GUI2)
	Exit
EndFunc

Func _wmin()
Local $Main_GUI2
GUISetState(@SW_MINIMIZE,$Main_GUI2)
EndFunc

Func ZAerror($msg)
	MsgBox(0,"error",$msg)
	exit
EndFunc