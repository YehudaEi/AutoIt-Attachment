Const $blend_in = 0x00080000
Const $blend_out = 0x00090000
Const $roll_up = 0x00020008
Const $roll_down = 0x00020004
Const $roll_left = 0x00020002
Const $roll_right = 0x00020001
Const $slide_up = 0x00040008
Const $slide_down = 0x00040004
Const $slide_left = 0x00040002
Const $slide_right = 0x00040001
Const $roll_ddl = BitOR($roll_down, $roll_left)
Const $roll_ddr = BitOR($roll_down, $roll_right)
Const $roll_dul = BitOR($roll_up, $roll_left)
Const $roll_dur = BitOR($roll_up, $roll_right)
Const $slide_ddl = BitOR($slide_down, $slide_left)
Const $slide_ddr = BitOR($slide_down, $slide_right)
Const $slide_dul = BitOR($slide_up, $slide_left)
Const $slide_dur = BitOR($slide_up, $slide_right)
Const $explode = 0x00020010
Const $implode = 0x00010010
Const $anim_hide = 0x00010000


; #Function ;================================================================================================
; Name.................; _Animate_Window
; Description..........; Animates the gui that you create and sets the state.
; Syntax...............; _Animate_Window($hHwnd, $iTime, $sAction, [$iHide])
; Paramaters...........; $hHwnd    - The handle of the GUI
;                        $iTime    - The time to run in Milliseconds
;                        $sAction  - The way you want GUI to be animated:
;                        |$blend_in     = Fades in
;						 |$blend_out    = Fades out
;						 |$roll_up      = Rolls upward
;						 |$roll_down    = Rolls downward
;						 |$roll_left    = Rolls in leftward
;						 |$roll_right   = Rolls in rightward
;                        |$roll_ddl     = Rolls diagonally down left
;                        |$roll_ddr     = Rolls diagonally down right
;                        |$roll_dul     = Rolls diagonally up left
;                        |$roll_dur     = Rolls diagonally up right
;                        |$slide_up     = Slides upward
;                        |$slide_down   = Slides downward
;                        |$slide_left   = Slides leftward
;                        |$slide_right  = Slides rightward
;                        |$slide_ddl    = Slides diagonally down left
;                        |$slide_ddr    = Slides diagonally down right
;                        |$slide_dul    = Slides diagonally up left
;                        |$slide_dur    = Slides diagonally up right
;                        |$explode      = Expands outward
;                        |$implode      = Collapses inward
;                        
;                        $iHide    - [Optional]Specifies if it will hide the window:
;                        |0 = shows the window, the Default
;                        |1 = Does the opposite and Hides the window on all but $blend, $explode and $implode
; Return Values........; None
; Author...............; Daniel Fielding (dansxmods)
; Modified.............;
; Remarks..............; Don't set the hide paramater on $blend_in, $blend_out, $explode and $implode. 
;                        Ensure you use GUISetState() after using this function or the controls on the GUI will not respond.
; Related..............;
; Link.................; http://msdn.microsoft.com/en-us/library/ms632669.aspx
; Example..............; Yes
;
; ;==========================================================================================================


Func _Animate_Window($hHwnd, $iTime, $sAction, $iHide = 0)
If $iHide = 1 Then
	$sAction = BitOR($sAction, $anim_hide)
EndIf
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hHwnd, "int", $iTime, "long", $sAction)

EndFunc ;==> _Animate_Window()

