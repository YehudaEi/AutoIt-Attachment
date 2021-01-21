;
;Middle button to select
;
;
;

#include <GUIConstants.au3>
Global $Pause = 1
Dim $pro_name[12]
Dim $pro_path[12]
Dim $pro_proc[12]
;
;
For $i = 0 to 10
$pro_name[$i] = IniRead("prog.ini", "prog_id", $i, "NotFound")
$pro_path[$i] = IniRead("prog.ini", "prog_path", $i, "NotFound")
$pro_proc[$i] = IniRead("prog.ini", "prog_proc", $i, "NotFound")
Next

;
GUICreate("Jog",100,220, 920,500)
GUISetBkColor (0x00E0FFFF)  ; will change background color
$button = GuiCtrlCreateButton ("",15,70,80,20)
$slider1 = GuiCtrlCreateSlider (10,10,10,200,$WS_BORDER+$CBS_AUTOHSCROLL+0x02,0x00000020)
GUICtrlSetLimit(-1,9,0)    ; change min/max value

GuiSetState()
GUICtrlSetData($slider1,1)    ; set cursor
ControlFocus ("Jog", "", "msctls_trackbar321" )

$display=""
  WinSetOnTop ( "Jog", "", 1 )

Do

  $n = GuiGetMsg ()
	$Run_Pro=GuiRead($slider1)
	$display=$pro_name[$Run_Pro]
		GUICtrlSetData ($button, $display )
	  If _IsPressed('04') = 1 Then 
		Call ("_pro")
	
	  endif
	
   If $n = $button Then
	Call ("_pro")
	
   EndIf
   	
Until $n = $GUI_EVENT_CLOSE


Func _IsPressed($hexKey)

 Local $aR, $bRv;$hexKey
 $hexKey = '0x' & $hexKey
 $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
;If $aR[0] = -32767 Then
 If $aR[0] <> 0 Then
    $bRv = 1
 Else
    $bRv = 0
 EndIf

 Return $bRv
EndFunc ;==>_IsPres

Func _pro()
	ControlFocus ("Jog", "", "msctls_trackbar321" )
	$Process= $pro_proc[$Run_Pro]
	$Prog_Path = $pro_path[$Run_Pro]
	
	If not Stringlen ($pro_path[$Run_Pro])=0 then
		If not ProcessExists($Process) Then run ($Prog_Path)
	Endif
	
Endfunc

