#include "GUIConstants.au3"

HotKeySet("{esc}","die")
HotKeySet("\","restart")
Func die()
	Exit
EndFunc

Global $pi = 3.14159265358979,$degToRad = $pi / 180, $grav_const = .1, $repul_const = 0, $restart = 0, $start_size = .50, $Draw_Field, $jiggle, $barrior
Global $Num_Particles, $Particle_Pic[1],$Particle_X[1],$Particle_Y[1],$Particle_dX[1],$Particle_dY[1],$Particle_Mass[1],$Particle_Radius[1], $Particle_Color[1], $z_particle_color = 0xffffff
;$particles x,y,dx,dy,mass,radius,pic
;gravity effects
Global $test_label, $iterations =0
func initialize()
	Local $a, $b
	$Num_Particles = InputBox("Number of Particles","How many particles","10")
	$barrior = InputBox("Barrior Type","What type of barrior" & @LF & "1: Respawn" & @LF & "2: Opposite Side" & @LF & "3: None",1)
	;$grav_const = $Num_Particles/10
	;$repul_const = $Num_Particles/1000
	ReDim $Particle_Pic[$Num_Particles]
	ReDim $Particle_X[$Num_Particles]
	ReDim $Particle_Y[$Num_Particles]
	ReDim $Particle_dX[$Num_Particles]
	ReDim $Particle_dY[$Num_Particles]
	ReDim $Particle_Mass[$Num_Particles]
	ReDim $Particle_Radius[$Num_Particles]
	ReDim $Particle_Color[$Num_Particles]
	GUICreate("Space",@DesktopWidth,@DesktopHeight)
	GUISetBkColor(0x000000)
	$Draw_Field = GUICtrlCreateGraphic ( 0, 0 , @DesktopWidth,@DesktopHeight)
	GUICtrlSetBkColor( $Draw_Field , 0x000000)
	$jiggle = GUICtrlCreateLabel("",0,0,1,1)
	for $a = 0 to $Num_Particles - 1
		$b = Random()
		$Particle_X[$a] = @DesktopHeight * $start_size * Random() * Cos( $degToRad * $b * 360) + @DesktopWidth/2
		$Particle_Y[$a] = @DesktopHeight * $start_size * Random() * Sin( $degToRad * $b * 360) + @DesktopHeight/2
		$Particle_dX[$a] = Random(-1,1)
   		$Particle_dY[$a] = Random(-1,1)
		$Particle_Radius[$a] = Random(1,5)
		$Particle_Mass[$a] = $pi * $Particle_Radius[$a]^2
		color_shift($a)
		draw($a,$Particle_Color[$a])
	Next
	
	GUISetState ()
	;ProgressOn("","")
EndFunc

Func calculate()
	Local $a, $b, $c, $distance, $grav_effect, $repulsion = 0, $force , $degree, $dx, $dy , $marked_men[1][2], $marked = 0             ;dont forget to add repulsion
	for $a = 0 to $Num_Particles -1
		for $b = $a + 1 to $Num_Particles -1
			$dx = ($Particle_X[$a] - $Particle_X[$b])
			$dy = ($Particle_Y[$a] - $Particle_Y[$b])
			$distance = Sqrt( $dx^2 + $dy^2 ) + .01
			if $distance > $Particle_Radius[$a] + $Particle_Radius[$b] then 
				$grav_effect = $grav_const * $Particle_Mass[$a] * $Particle_Mass[$b] * ($distance)^(-2)
				;$repulsion = ($Particle_Mass[$a] * $Particle_Mass[$b]) ^ 2 * $repul_const / $distance
				$force = $grav_effect - $repulsion
				if $dx <> 0 then 
					$degree = ATan($dy/$dx)
					if $dx > 0 then $degree = $pi + $degree
					if $dy = 0 then
						$degree = 0
						if $dx <0 Then $degree =$pi
					EndIf
						
				Else
					$degree = 90 * $degToRad
					if $dy > 0 then $degree = $degToRad * 270
				EndIf
				
				$Particle_dX[$a] = $Particle_dX[$a] + ($Particle_Mass[$b] / ( $Particle_Mass[$a] + $Particle_Mass[$b])) * $force * Cos($degree)
				$Particle_dY[$a] = $Particle_dY[$a] + ($Particle_Mass[$b] / ( $Particle_Mass[$a] + $Particle_Mass[$b])) * $force * Sin($degree)
				$degree = $degree - $pi
				$Particle_dX[$b] = $Particle_dX[$b] + ($Particle_Mass[$a] / ( $Particle_Mass[$a] + $Particle_Mass[$b])) * $force * Cos($degree)
				$Particle_dY[$b] = $Particle_dY[$b] + ($Particle_Mass[$a] / ( $Particle_Mass[$a] + $Particle_Mass[$b])) * $force * Sin($degree)
				
			Else
				$marked = $marked +1
				redim $marked_men[$marked][2]
				$marked_men[$marked-1][0] = $a
				$marked_men[$marked-1][1] = $b
			EndIf
		Next
	Next
	;MsgBox(0,"1","")
	GUICtrlDelete($Draw_Field)
	$Draw_Field = GUICtrlCreateGraphic ( 0 , 0 , @DesktopWidth , @DesktopHeight )
	GUICtrlSetBkColor( $Draw_Field , 0x000000 )


 For $a = 1 to $marked
   		$b = $marked_men[$marked-1][0]
   		$c = $marked_men[$marked-1][1]
		;draw($b,0x010101)
		;draw($c,0x010101)
   		$Particle_X[$b] = ($Particle_X[$b] * $Particle_Mass[$b] + $Particle_X[$c] * $Particle_Mass[$c])/( $Particle_Mass[$b] + $Particle_Mass[$c])
   		$Particle_Y[$b] = ($Particle_Y[$b] * $Particle_Mass[$b] + $Particle_Y[$c] * $Particle_Mass[$c])/( $Particle_Mass[$b] + $Particle_Mass[$c])
   		;$Particle_X[$b] = ($Particle_X[$b] + $Particle_X[$c])/(2)
   		;$Particle_Y[$b] = ($Particle_Y[$b] + $Particle_Y[$c])/(2)
		$Particle_dX[$b] = ($Particle_dX[$b] * $Particle_Mass[$b] + $Particle_dX[$c] * $Particle_Mass[$c])/( $Particle_Mass[$b] + $Particle_Mass[$c])
   		$Particle_dY[$b] = ($Particle_dY[$b] * $Particle_Mass[$b] + $Particle_dY[$c] * $Particle_Mass[$c])/( $Particle_Mass[$b] + $Particle_Mass[$c])
   		$Particle_Mass[$b] = $Particle_Mass[$b] + $Particle_Mass[$c]
		$Particle_Radius[$b] = Sqrt(.5 * $Particle_Mass[$b])
		color_shift($b)
		$Particle_Radius[$c] = Random(1,4)
		$Particle_Mass[$c] = $pi * $Particle_Radius[$c]^2
   		color_shift($c)
		$Particle_X[$c] = @DesktopWidth * Random()
		$Particle_Y[$c] = @DesktopHeight * Random()
		$Particle_dX[$c] = Random(-3,3)
   		$Particle_dY[$c] = Random(-3,3)
		
		

   	Next
	
	For $a = 0 to $Num_Particles -1
		;draw($a,0x010101)
		$Particle_X[$a] = $Particle_dX[$a] + $Particle_X[$a]
		$Particle_Y[$a] = $Particle_dY[$a] + $Particle_Y[$a]
		if $barrior <>3 then
			if $Particle_X[$a] < 0 or $Particle_X[$a] > @DesktopWidth or $Particle_Y[$a] < 0 or $Particle_Y[$a] > @DesktopHeight Then
				if $barrior = 2 then
					if $Particle_X[$a] < 0 then $Particle_X[$a] = @DesktopWidth -2
					if $Particle_X[$a] > @DesktopWidth then $Particle_X[$a] = 2	
					if $Particle_Y[$a] < 0 then $Particle_Y[$a] = @DesktopHeight -2
					if $Particle_Y[$a] > @DesktopHeight then $Particle_Y[$a] = 2	
				Else
					$Particle_X[$a] = @DesktopHeight* $start_size * Random() * Cos( $degToRad * $b * 360) + @DesktopWidth/2
					$Particle_Y[$a] = @DesktopHeight* $start_size * Random() * Sin( $degToRad * $b * 360) + @DesktopHeight/2
					$Particle_dX[$a] = 0
					$Particle_dY[$a] = 0
				EndIf
			EndIf
		EndIf
		draw($a,0xffffff)
	Next
	$iterations = $iterations+1
	;ProgressSet($iterations,"",$iterations)
	;MsgBox(0,"2","")
EndFunc
initialize()

While 1
	calculate()
	Sleep(0)
	if $restart Then
		$restart = 0
		GUIDelete()
		initialize()
	EndIf
	GUICtrlSetState($Draw_Field,0x000F)
WEnd
Func restart()
	$restart = 1
EndFunc

Func Max($a,$b)
	if $a > $b then Return $a
	Return $b
EndFunc

Func color_shift($a)
	;grey
	$Particle_Color[$a] = "0x" & hex(Max(255 - 5*$Particle_Mass[$a],0),2) & hex(Max(255 - 5*$Particle_Mass[$a],0),2) & hex(Max(255 - 5*$Particle_Mass[$a],0),2) 
	;red
	;GUICtrlSetGraphic($Particle_Pic[$a],$GUI_GR_COLOR, "0x" & "ff" & hex(Max(255 - 20*$Particle_Mass[$a],0),2) & hex(Max(255 - 20*$Particle_Mass[$a],0),2)   )
	;multi
	;GUICtrlSetGraphic($Particle_Pic[$a],$GUI_GR_COLOR, "0x" & hex(Max(255 - 10*$Particle_Mass[$a],0),2) & hex(Max(255 - 5*$Particle_Mass[$a],0),2) & hex(Max(255 - 2.5*$Particle_Mass[$a],0),2) )
EndFunc

Func draw($a,$b)
	GUICtrlSetGraphic ( $Draw_Field, $GUI_GR_COLOR, $b)
	GUICtrlSetGraphic ( $Draw_Field, $GUI_GR_ELLIPSE, $Particle_X[$a],$Particle_Y[$a],$Particle_Radius[$a],$Particle_Radius[$a])
EndFunc


;WM_NCPAINT 0x0085
;WM_PAINT 0x000F 
;WM_SYNCPAINT 0x0088 
;WM_SYSCOLORCHANGE 0x0015 
;WM_UPDATEUISTATE 0x0128 
;WM_SETREDRAW 0x000B 
	