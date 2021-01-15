#include <GUIConstants.au3>
#include <Array.au3>
AutoItSetOption("GUIOnEventMode",1)
HotKeySet("{esc}","die")



Func die()
	Exit
EndFunc


;Atomic Constants
Const $Mass_Electron = 9.1093897 * 10^(-31), $Mass_Neutron = 1.6749286 * 10^(-27), $Mass_Proton = 1.6726231 * 10^(-27), $Universal_Gravity_Constant = 6.67259 * 10^(-11)

;Program Constants
Const $dim_max_particles = 256,$dim_particle_stats = 10, $pi = 3.14159265358979, $degToRad = $pi / 180, $View = 1000,$pan_const = 100
Global $Window_Size[2], $Graphic, $pan[6],$Redraw = True, $enter,$restart= False
$Window_Size[0] = @DesktopWidth
$Window_Size[1] = @DesktopHeight
$pan[2] = -1000
;Particle_Arrays
Global $Particle[$dim_max_particles][$dim_particle_stats]
;Particle_X, Particle_Y, Particle_Z,
;Particle_dX, Particle_dY, Particle_dZ
;Particle_Mass, Particle_Radius, Particle_Color, Particle_Type

;Run Related
Global $Num_Particle_Min = 20, $Num_Particle_Current = 0, $Dist_Max = 1000, $Dist_Start = 1000, $Size_Particle_Min = 10 , $Size_Particle_Max = 20
Global $Filled , $empty, $atomic = False, $Speed_Max = .4, $Gravity = .1,$axis[3][2][20],$select[3]



Get_Data()
Initialize()
Main()


;the Bulk
Func Get_Data()	
	Local $a, $b, $c
	Local $up_down_changer=5, $spacing =5, $item = 0, $height = 20, $buff =5
	$go_now = 1
	GUICreate("Settings",$buff * 2 + 160, $buff*2 + 9 * ($height + $spacing))
	$Gravity =  GUICtrlCreateInput($Gravity * 100,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	GUICtrlCreateUpdown($Gravity)
	GUICtrlCreateLabel("Gravity Constant",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	$item = $item + 1
	;$repul_const = GUICtrlCreateInput($repul_const*100,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	;GUICtrlCreateUpdown($repul_const)
	;GUICtrlCreateLabel("Repulsion Constant",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	;$item = $item + 1
	$Speed_Max =  GUICtrlCreateInput($Speed_Max*50,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	GUICtrlCreateUpdown($Speed_Max)
	GUICtrlCreateLabel("Max Init. Speed",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	$item = $item + 1
	$Size_Particle_Min  =  GUICtrlCreateInput($Size_Particle_Min,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	GUICtrlCreateUpdown($Size_Particle_Min)
	GUICtrlCreateLabel("Minimum Mass",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	$item = $item + 1
	$Size_Particle_Max  =  GUICtrlCreateInput($Size_Particle_Max,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	GUICtrlCreateUpdown($Size_Particle_Max)
	GUICtrlCreateLabel("Maximum Mass",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	$item = $item + 1
	$Dist_Start  =  GUICtrlCreateInput($Dist_Start,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	GUICtrlCreateUpdown($Dist_Start)
	GUICtrlCreateLabel("Starting Distance",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	$item = $item + 1
	;$Dist_Max  =  GUICtrlCreateInput($Dist_Max,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	;GUICtrlCreateUpdown($Dist_Max)
	;GUICtrlCreateLabel("Maximum Distance",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	;$item = $item + 1
	$Num_Particle_Current  =  GUICtrlCreateInput($Num_Particle_Min - $Num_Particle_Min,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	GUICtrlCreateUpdown($Num_Particle_Current)
	GUICtrlCreateLabel("Extra Initial Particles",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	$item = $item + 1
	$Num_Particle_Min  =  GUICtrlCreateInput($Num_Particle_Min,100 + $buff,($height + $spacing) * $item + $buff,60,$height)
	GUICtrlCreateUpdown($Num_Particle_Min)
	GUICtrlCreateLabel("Minimum Particles",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,100,$height)
	$item = $item + 1
	HotKeySet("{numpadsub}")
	HotKeySet("{numpadadd}")
	HotKeySet("{numpad0}")
	HotKeySet("{numpad1}")
	HotKeySet("{numpad2}")
	HotKeySet("{numpad3}")
	HotKeySet("{numpad4}")
	HotKeySet("{numpad5}")
	HotKeySet("{numpad6}")
	HotKeySet("{numpad7}")
	HotKeySet("{numpad8}")
	HotKeySet("{numpad9}")
	GUICtrlSetOnEvent(GUICtrlCreateButton("Build My Universe!",$buff,$up_down_changer + ($height + $spacing) * $item + $buff,160,45),"enter")
	GUISetState()
	HotKeySet("{enter}","enter")
	GUISetOnEvent($GUI_EVENT_CLOSE, "die")
	$enter = False
	While Not $enter
		Sleep  (100)
	WEnd
	HotKeySet("{enter}")
	$Gravity = GUICtrlRead($Gravity)/100
	$Speed_Max = GUICtrlRead($Speed_Max)/50
	$Size_Particle_Min = GUICtrlRead($Size_Particle_Min);^3 * (4/3) * $pi
	$Size_Particle_Max = GUICtrlRead($Size_Particle_Max);^3 * (4/3) * $pi
	$Dist_Start = GUICtrlRead($Dist_Start)
	;$Dist_Max = GUICtrlRead($Dist_Max)
	$Num_Particle_Current = GUICtrlRead($Num_Particle_Current)
	$Num_Particle_Min = min(GUICtrlRead($Num_Particle_Min),$dim_max_particles)
	GUIDelete()
	For $a = 0 to 4
		$pan[$a] = 0
	Next
	$pan[5] = -$Dist_Start * 2
	$select[1] = -1
	$select[2] = -1
EndFunc
Func Initialize()
	Local $a,$b,$c,$d,$e
	dim $Filled[1]
	dim $empty[$dim_max_particles+1]
	dim $Particle[$dim_max_particles][$dim_particle_stats]
	for $a = 1 to $dim_max_particles
		$empty[$a] = $a
	Next
	$empty[0] = $dim_max_particles
	$b = $Num_Particle_Current
	$Num_Particle_Current = 0 
	for $a = 0 to $Num_Particle_Min + $b
		add_particle()
	Next
	GUICreate(@ScriptName,$Window_Size[0],$Window_Size[1])
	GUISetBkColor(0x000000)
	$Graphic = GUICtrlCreateGraphic(0,0,$Window_Size[0],$Window_Size[1])
	GUISetState()
	HotKeySet("\","restart")
	HotKeySet("{numpadsub}","zoom_out")
	HotKeySet("{numpadadd}","zoom_in")
	HotKeySet("{numpad4}","left")
	HotKeySet("{numpad8}","up")
	HotKeySet("{numpad6}","right")
	HotKeySet("{numpad2}","down")
	HotKeySet("{numpaddiv}","select_inc")
	HotKeySet("{numpadmult}","select_dec")
	HotKeySet("{numpad5}","select_mode")
	HotKeySet("{numpad7}","color_mode")
EndFunc
Func Main()
	While 1
		if $Num_Particle_Current < $Num_Particle_Min then add_particle()
		Calculate()
		Render()
		if $restart then 
			GUIDelete()
			Get_Data()
			Initialize()
			$restart = False
		EndIf
	WEnd
EndFunc
Func Calculate()
	Local $a,$b,$c,$d,$e,$f,$g,$Dotted =0,$Marked_Men[1][2]
	Local $dx, $dy, $dz, $dxyz
	For $f1 = 1 to $Filled[0]
		$a = $Filled[$f1]
		for $f2 = $f1 + 1 to $Filled[0]
			$b = $Filled[$f2]
			$dx = $Particle[$a][1] - $Particle[$b][1]
			$dy = $Particle[$a][2] - $Particle[$b][2]
			$dz = $Particle[$a][3] - $Particle[$b][3]
			$dxyz = Sqrt( $dx^2 + $dy^2 + $dz^2) + .0001
			if $dxyz > $Particle[$a][8] + $Particle[$b][8] then 
				$g = $Gravity * $Particle[$a][7] * $Particle[$b][7] * $dxyz^-2
				$f = $g * ($Particle[$b][7]/($Particle[$a][7]+$Particle[$b][7]))
				$Particle[$a][4] -= $f * $dx
				$Particle[$a][5] -= $f * $dy
				$Particle[$a][6] -= $f * $dz
				$f = $g * ($Particle[$a][7]/($Particle[$a][7]+$Particle[$b][7]))
				$Particle[$b][4] += $f * $dx
				$Particle[$b][5] += $f * $dy
				$Particle[$b][6] += $f * $dz
			Else
				$Dotted += 1
				ReDim $Marked_Men[$Dotted][2]
				$Marked_Men[$Dotted -1][0] = $f1
				$Marked_Men[$Dotted -1][1] = $f2
			EndIf
		Next
	Next
	
	for $a = 0 to $Dotted - 1
		$b = Int($Filled[$Marked_Men[$Dotted - $a-1][0]])
		$c = Int($Filled[$Marked_Men[$Dotted - $a-1][1]])
		if $Particle[$b][7] < $Particle[$c][7] Then $Particle[$b][9] = $Particle[$c][9]

		$Particle[$b][1] = ($Particle[$b][1] * $Particle[$b][7] + $Particle[$c][1] * $Particle[$c][7])/($Particle[$c][7] + $Particle[$b][7])
		$Particle[$b][2] = ($Particle[$b][2] * $Particle[$b][7] + $Particle[$c][2] * $Particle[$c][7])/($Particle[$c][7] + $Particle[$b][7])
		$Particle[$b][3] = ($Particle[$b][3] * $Particle[$b][7] + $Particle[$c][3] * $Particle[$c][7])/($Particle[$c][7] + $Particle[$b][7])
		
		$Particle[$b][4] = ($Particle[$b][4] * $Particle[$b][7] + $Particle[$c][4] * $Particle[$c][7])/($Particle[$c][7] + $Particle[$b][7])
		$Particle[$b][5] = ($Particle[$b][5] * $Particle[$b][7] + $Particle[$c][5] * $Particle[$c][7])/($Particle[$c][7] + $Particle[$b][7])
		$Particle[$b][6] = ($Particle[$b][6] * $Particle[$b][7] + $Particle[$c][6] * $Particle[$c][7])/($Particle[$c][7] + $Particle[$b][7])
		
		$Particle[$b][7] += $Particle[$c][7]
		$Particle[$b][8] = ((3/4) * $Particle[$b][7])^(1/3)
		
		$Particle[$c][7] = 0
		
		
		if $select[0] = $c then $select[0] = $b
		
		if $select[2] = 1 then Color_Shift($b)
		
		$Filled[$Marked_Men[$Dotted - $a-1][1]] += .001
	Next
	$a = 0
	While ($a < UBound($Filled)-1) and ($Dotted > 0)
		$a += 1
		if $Filled[$a] > Int($Filled[$a]) Then
			_ArrayAdd($empty,Int($Filled[$a]))
			_ArrayDelete($Filled,$a)
			$Filled[0] -= 1
			$Dotted -= 1
			$Num_Particle_Current -= 1
		EndIf
	WEnd
	
	For $f1 = 1 to $Filled[0]
		$a = $Filled[$f1]
		$Particle[$a][1] += $Particle[$a][4]
		$Particle[$a][2] += $Particle[$a][5]
		$Particle[$a][3] += $Particle[$a][6]
	Next
	
	
EndFunc
Func Render()
	Local $Pre_Render[$Filled[0]][3], $a,$b,$c,$d
	if $select[1] = 1 Then
		$pan[0] = ($pan[0] + $Particle[$select[0]][1])/2 + $pan[3]
		$pan[1] = ($pan[1] + $Particle[$select[0]][2])/2 + $pan[4]
		$pan[2] = ($pan[2] + $Particle[$select[0]][3])/2 + $pan[5]
	Else
		$pan[0] = $pan[3]
		$pan[1] = $pan[4]
		$pan[2] = $pan[5]
	EndIf
	
	
	For $a = 1 to $Filled[0]
		$b = Calc_Render($Particle[$Filled[$a]][1],$Particle[$Filled[$a]][2],$Particle[$Filled[$a]][3],$Particle[$Filled[$a]][8])
		$Pre_Render[$a -1][0] = $b[0]
		$Pre_Render[$a -1][1] = $b[1]
		$Pre_Render[$a -1][2] = $b[2]
	Next
	GUICtrlDelete($Graphic)
	GUICtrlCreateGraphic(0,0,$Window_Size[0],$Window_Size[1])
	GUICtrlSetBkColor($Graphic,0x000000)
	for $a =  0 to $Filled[0] -1 
		GUICtrlSetGraphic($Graphic,$GUI_GR_COLOR,$Particle[$Filled[$a+1]][9],$Particle[$Filled[$a+1]][9])
		GUICtrlSetGraphic($Graphic,$GUI_GR_ELLIPSE,$Pre_Render[$a][0],$Pre_Render[$a][1],$Pre_Render[$a][2],$Pre_Render[$a][2])
	Next
	#cs
	if $Redraw then 
		for $a = 0 to UBound($axis,3) -1
			$b = Calc_Render(($a-.5*UBound($axis,3))*$Dist_Max,0,0,0)
			$axis[0][0][$a] = $b[0]
			$axis[0][1][$a] = $b[1]
			$b = Calc_Render(0,($a-.5*UBound($axis,3))*$Dist_Max,0,0)
			$axis[1][0][$a] = $b[0]
			$axis[1][1][$a] = $b[1]
			$b = Calc_Render(0,0,Max(($a-.5*UBound($axis,3))*$Dist_Max,$pan[2]+.01),0)
			$axis[2][0][$a] = $b[0]
			$axis[2][1][$a] = $b[1]
		Next
	EndIf
	GUICtrlSetGraphic($Graphic,$GUI_GR_COLOR,0x222222)
	GUICtrlSetGraphic($Graphic,$GUI_GR_MOVE,$axis[0][0][0],$axis[0][1][0])
	for $a = 1 to UBound($axis,3) -1
		GUICtrlSetGraphic($Graphic,$GUI_GR_LINE,$axis[0][0][$a],$axis[0][1][$a])
	Next
	GUICtrlSetGraphic($Graphic,$GUI_GR_MOVE,$axis[1][0][0],$axis[1][1][0])
	for $a = 1 to UBound($axis,3) -1
		GUICtrlSetGraphic($Graphic,$GUI_GR_LINE,$axis[1][0][$a],$axis[1][1][$a])
	Next
	GUICtrlSetGraphic($Graphic,$GUI_GR_MOVE,$axis[2][0][0],$axis[2][1][0])
	for $a = 1 to UBound($axis,3) -1
		GUICtrlSetGraphic($Graphic,$GUI_GR_LINE,$axis[2][0][$a],$axis[2][1][$a])
	Next
	
	#ce
	GUICtrlSetGraphic($Graphic,$GUI_GR_REFRESH)
EndFunc
Func Calc_Render($x,$y,$z,$r)
	Local $d
	local $return[3]
	$z = $z - $pan[2]
	if $z > 0 then 
		$x = $x - $pan[0]
		$y = $y - $pan[1]
		$d = Sqrt($x^2+$y^2+$z^2) + .001
		$r = Max((2 * $View * $r)/($d),1)
		
		$x = ($x*$View)/$d + .5 * $Window_Size[0] - .5 * $r
		$y = ($y*$View)/$d + .5 * $Window_Size[1] - .5 * $r
		
	Else
		$x = -100
		$y = -100
	EndIf
	$return[0] = $x
	$return[1] = $y
	$return[2] = $r
	Return $return
EndFunc
Func add_particle()
	Local $a = $empty[1],$b,$c,$d
	$Num_Particle_Current = $Num_Particle_Current + 1
	if $atomic Then
	Else
		$Particle[$a][0] = -1
		$b = Random(0,2*$pi)
		$Particle[$a][1] = cos($b) * $Dist_Start * Random(0,1)
		$Particle[$a][2] = Sin($b) * $Dist_Start * Random(0,1)
		$Particle[$a][3] = Sin($b) * $Dist_Start * (Random(0,1) * 2 - 1 )
		$Particle[$a][4] = $Speed_Max * Random(-1,1)
		$Particle[$a][5] = $Speed_Max * Random(-1,1)
		$Particle[$a][6] = $Speed_Max * Random(-1,1)
		$Particle[$a][7] = Random($Size_Particle_Min,$Size_Particle_Max)
		$Particle[$a][8] = ((3/4) * $Particle[$a][7])^(1/3)
		Color_Shift($a)
	EndIf
	$Filled[0] = UBound($Filled) - 1
	$empty[0] = $empty[0] - 1
	_ArrayAdd($Filled,$a)
	_ArrayDelete($empty,1)
EndFunc
Func Color_Shift($a)
	;$Particle[$a][9] = 0xffffff
	if $select[2] = 1 then
		$Particle[$a][9] = "0x" & hex(Max(255 - .09*$Particle[$a][7]*($Size_Particle_Max/$Size_Particle_Min),0),2) & hex(Max(255 - 1*$Particle[$a][7]*($Size_Particle_Max/$Size_Particle_Min) _
		,0),2) & hex(Max(255 - 2*$Particle[$a][7]*($Size_Particle_Max/$Size_Particle_Min),0),2)	
	Else
		$Particle[$a][9] = randcolor()
	EndIf	
EndFunc
Func restart()	
	$restart = True
EndFunc

;select
Func select_inc()
	Local $a = $select[0]
	if $a < $dim_max_particles then
		$a += 1
	Else
		$a = 1
	EndIf
	While $Particle[$a][7] = 0
		if $a < $dim_max_particles - 1  then
			$a += 1
		Else
			$a = 0
		EndIf
	WEnd
	$select[0] = $a
EndFunc
Func select_dec()
	Local $a = $select[0]
	if $a > 0 then
		$a -= 1
	Else
		$a = $dim_max_particles -1
	EndIf
	While $Particle[$a][7] = 0
		if $a > 0  then
			$a -= 1
		Else
			$a = $dim_max_particles -1
		EndIf
	WEnd
	$select[0] = $a
EndFunc
Func select_mode()
	$select[1] = -$select[1]
	if $select[1] = 1 Then
		if $Particle[$select[0]][7] = 0 Then select_inc()
		$pan[3] = 0
		$pan[4] = 0
		$pan[5] = $pan[5] - $Particle[$select[0]][3]
		
	Else
		$pan[3] = $pan[0]
		$pan[4] = $pan[1]
		$pan[5] = $pan[5] + $Particle[$select[0]][3]
	EndIf
EndFunc
Func color_mode()
	$select[2] *= -1
	for $a = 1 to UBound($Filled) - 1
		Color_Shift($a)
	Next
EndFunc




;Zoom
func zoom_in() 
	$pan[5] = $pan[5] + $pan_const
	$Redraw = True
EndFunc
func zoom_out()
	$Redraw = True
	$pan[5] = $pan[5] - $pan_const
EndFunc
Func left()
	$Redraw = True
	$pan[3]= $pan[3] - $pan_const
EndFunc
Func right()
	$Redraw = True
	$pan[3]= $pan[3] + $pan_const
EndFunc
Func up()
	$Redraw = True
	$pan[4]= $pan[4] - $pan_const
EndFunc
Func down()
	$Redraw = True
	$pan[4]= $pan[4] + $pan_const
EndFunc




;Defaults
Func randcolor()
	local $number = "0x", $a
	For $a = 1 to 3
		$number = $number & String(Hex(Random(40,255,1),2))
	Next
	Return $number
EndFunc
func enter()
	$enter = True
EndFunc
Func test_box()
	MsgBox(0,0,0)
EndFunc
Func Max($a,$b)
	if $a > $b then Return $a
	Return $b
EndFunc
Func Min($a,$b)
	if $a < $b then Return $a
	Return $b
EndFunc