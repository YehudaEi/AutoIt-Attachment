#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>

;#FUNCTIONS# ====================================================================================================================
;_MsgBoxCreate
;_MsgBoxCuStyle
; ===============================================================================================================================
Global $mcolour2 = 0x191919, $mcolour1 = 0x8C8C8C
; #FUNCTION# ====================================================================================================================
; Name...........: _MsgBoxCreate
; Description ...: Better looking message boxes with custom styles
; Syntax.........:  _MsgBoxCreate($mflag = 1,$mtitle = "title",$mline1 = "line 1",$mline2 = "line 2",$mline3 = "line 3")
; Parameters ....: $mflag       - Flag for message box 1 = ok 2 = yes/no 3 = retry/ignore/Cancel
;                  $mtitle      - Title of message box
;                  $mline1      - The first line of the message box
;                  $mline2      - The second line of the message box
;                  $mline3      - The third line of the message box
; Output.........: $output      - if $output = 0 then, clicked on the X 1 then, clicked on ok 2 then, clicked on yes 3 then, clicked on no
;                                 4 then, clicked on retry 5 then, clicked on abort 6 then, clicked on ignore
;
; styles.........:                global $mcolour1 = <colour code 1>, $mcolour2 = <colour code 2> to set the colour
; Author ........: Sycam inc (sean campbell)
; Remarks .......: none
; Related .......: 
; ===============================================================================================================================
Func _MsgBoxCreate($mflag,$mtitle,$mline1,$mline2,$mline3)
$1 = @DesktopWidth/2
$width = $1-300
$2 = @DesktopHeight/2
$hight = $2-200
global $msgboxgui = GUICreate($mtitle, 600, 400,$hight,$hight, BitOR($WS_POPUP, $WS_SYSMENU, $WS_EX_LAYERED))
GUISetBkColor($mcolour1)
$exit = GUICtrlCreateLabel("",585,0,15,15,$GUI_GR_RECT)
$Graphic1 = GUICtrlCreateGraphic(0, 0, 600, 75)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $mcolour2, $mcolour2)
GUICtrlSetGraphic(-1, $GUI_GR_RECT, 0, 0, 600, 75)
GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 4)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $mcolour1, $GUI_GR_NOBKCOLOR)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 600, 0)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 585, 15)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 585, 0)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 600, 15)
$Graphic2 = GUICtrlCreateGraphic(0, 325, 605, 80)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $mColour2, $mcolour2)
GUICtrlSetGraphic(-1, $GUI_GR_RECT, 0, 0, 600, 75)
if $mflag = 1 Then
$ok = GUICtrlCreateLabel("              ok", 200, 200, 200, 35)
GUICtrlSetFont(-1, 20, 400, 0, "Myriad Web Pro")
GUICtrlSetBkColor(-1, $mColour2)
guictrlsetcolor(-1,$mcolour1)
Else
   if $mflag = 2 Then
	  $yes = GUICtrlCreateLabel("             yes", 90, 200, 200, 35)
GUICtrlSetFont(-1, 20, 400, 0, "Myriad Web Pro")
GUICtrlSetBkColor(-1, $mColour2)
guictrlsetcolor(-1,$mColour1)
$no = GUICtrlCreateLabel("              no", 310, 200, 200, 35)
GUICtrlSetFont(-1, 20, 400, 0, "Myriad Web Pro")
GUICtrlSetBkColor(-1, $mColour2)
GUICtrlSetColor(-1, $mColour1)
Else
  If $mflag = 3 Then
	 $retry = GUICtrlCreateLabel("           retry", 10, 200, 180, 35)
GUICtrlSetFont(-1, 20, 400, 0, "Myriad Web Pro")
GUICtrlSetBkColor(-1, $mColour2)
guictrlsetcolor(-1,$mColour1)
$abort = GUICtrlCreateLabel("          abort", 210, 200, 180, 35)
GUICtrlSetFont(-1, 20, 400, 0, "Myriad Web Pro")
GUICtrlSetBkColor(-1, $mColour2)
guictrlsetcolor(-1,$mColour1)
$ignore = GUICtrlCreateLabel("         ignore", 410, 200, 180, 35)
GUICtrlSetFont(-1, 20, 400, 0, "Myriad Web Pro")
GUICtrlSetBkColor(-1, $mColour2)
guictrlsetcolor(-1,$mColour1)
EndIf
EndIf
EndIf
$Label2 = GUICtrlCreateLabel($mtitle, 20, 15, 560, 50)
GUICtrlSetFont(-1, 28, 400, 0, "Impact")
GUICtrlSetColor(-1, $mColour1)
GUICtrlSetBkColor(-1,$mColour2)
$Label3 = GUICtrlCreateLabel($mline1, 100, 100, 400, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $mColour2)
$Label4 = GUICtrlCreateLabel($mline2, 100, 125, 400, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $mColour2)
$Label5 = GUICtrlCreateLabel($mline3, 100, 150, 600, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $mColour2)
GUISetState(@SW_SHOW)

if $mflag = 1 Then
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			Case $GUI_EVENT_PRIMARYDOWN
                Drag()
		 Case $exit
			GUIDelete($msgboxgui)
			Global $output = 0
			ExitLoop
		 Case $ok
			Global $output = 1
			GUIDelete($msgboxgui)
			ExitLoop
		;Case $msgboxgui
	EndSwitch
WEnd
Else
if $mflag = 2 Then
   While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			Case $GUI_EVENT_PRIMARYDOWN
                Drag()
		 Case $exit
			GUIDelete($msgboxgui)
			Global $output = 0
			ExitLoop
   	 Case $yes
			Global $output = 2
			GUIDelete($msgboxgui)
			ExitLoop
		 Case $no
			Global $output = 3
			GUIDelete($msgboxgui)
			ExitLoop
		; Case $msgboxgui
	EndSwitch
WEnd
Else
if $mflag = 3 then
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			Case $GUI_EVENT_PRIMARYDOWN
                Drag()
			
		 Case $exit
			GUIDelete($msgboxgui)
			Global $output = 0
			ExitLoop
		 Case $retry
			Global $output = 4
			GUIDelete($msgboxgui)
			ExitLoop
		 Case $ignore
			Global $output = 6
			GUIDelete($msgboxgui)
			ExitLoop
		 case $abort
			Global $output = 5
			GUIDelete($msgboxgui)
			ExitLoop
					;Case $msgboxgui
	EndSwitch
WEnd
EndIf
EndIf
EndIf
EndFunc

Func Drag()
        dllcall("user32.dll","int","ReleaseCapture")
        dllcall("user32.dll","int","SendMessage","hWnd", $msgboxgui,"int",$WM_NCLBUTTONDOWN,"int", $HTCAPTION,"int", 0)
EndFunc
