#include <File.au3>

Opt("GUIOnEventMode", 1)
HotKeySet("{ESC}", "quit")

#cs

	ASE - A small Engine
	Who needs Includes. Keep it fancy!

	Features
		- Fast backbuffered polygon drawing (200FPS @ 4GHz, 70-90FPS @ 1,7GHz)
		- Translation
		- Rotation
		- Zooming (also past z0)
		- Light-effected flat shading
		- CAD-like border-highlighting OR borderless shading
		- Back-Face Culling and Z-Odering algorithms
		- Variable shade-intensity (!)
		- Fog / View Distance emulation
		- OWN 3D model format: 3DA. A lot like Wavefronts OBJ, easy to use (pro: Doesn't need to be triangulated. Polys could contain up to 18 points!)
		- OWN model loader / parser
		- Scaling
		- <300 Lines of code
		- and what you're going to add ;-)
	EndFeatures

#ce

; Einfach ein wenig mit den Werten hier spielen (Besonders das ShadeFactor und Borders):

; StartUp(Width, Height, FullScreen, X, Y, Z, RX, RY, RZ, Zoom, FogDistance, ShadeFactor, Borders
; Width 		-> Width of the window
; Height 		-> Height of the window
; FullScreen	-> If window should be fullscreen. This ignores Width & Height
; X				-> Start x position
; Y				-> Start y position
; Z				-> Start z position
; RX			-> Start x rotation
; RY			-> Start y rotation
; RZ			-> Start z rotation
; Zoom			-> Z axis displacement (aka ... Zoom)
; FogDistance 	-> Just leave this alone (It's the fog)
; ShadeFactor	-> Most important for a good result. 0 = uniform color | 1 = extreme shading | 0.5 = most likely used
; Borders		-> Highlight the models borders white (like in a CAD)
StartUp(800, 600, False, 0, 0, 0, 0, 0, 0, 900, 999, 0.5, True)

LoadModelFromFile(".\Cube.3DA")
;LoadModelFromFile(".\Pyramid.3DA")
;LoadModelFromFile(".\Cone.3DA") ; Has no bottom
;LoadModelFromFile(".\Cylinder.3DA")



CalculateShadingFactors()
AdlibRegister("FPS", 2000)

$ZoomAnimator = 0.1

;~ f 7 0 1 2 3 4 5 6 0 0 255
;~ f 7 7 8 9 10 11 12 13 0 0 255

While 1
	#forcedef $hGraphics, $Width, $Height, $RotX, $RotY, $RotZ, $TransX, $TransY, $TransZ, $Zm, $iFPS
	$hBuffer = $hGraphics
    $hGraphics = GUICtrlCreateGraphic(0, 0, $Width, $Height)
	$RotX += 1
	$RotY += 1
	$RotZ += 1
	$Zm += $ZoomAnimator
	If $RotX > 360 Then $RotX = -355
	If $RotY > 360 Then $RotY = -355
	If $RotZ > 360 Then $RotZ = -355
	If $Zm > 960 Or $Zm < 900 Then $ZoomAnimator *= -1
	CreateVertexArray() 						; Create a safe-to-edit copy of all vertices
	Translate($TransX, $TransY, $TransZ) 		; Change the postion of all vertices
	Rotate($RotX, $RotY, $RotZ) 				; Rotate all vertices
	Zoom($Zm) 									; Zoom!
	ApplyPerpective() 							; Well...
	BackfaceCulling() 							; Leave behind what is behind!
	DrawToBuffer() 								; Display it
	$iFPS += 1
	GUICtrlDelete($hBuffer)
WEnd

Func StartUp($wi = 800, $he = 600, $Fs = False, $x = 0, $y = 0, $z = 0, $rx = 0, $ry = 0, $rz = 0, $zoom = 900, $dis = 1000, $shade = 0.5, $borders = True)
	If $Fs Then
		Global $Width = @DesktopWidth, $Height = @DesktopHeight
		$Style = 0x80000000
	Else
		Global $Width = $wi, $Height = $he
		$Style = -1
	EndIf
	Global $hGUI = GUICreate("ASE", $Width, $Height, 0, 0, $Style, 34078728)
	GUISetOnEvent(-3, "quit")
	Global $hLabel = GUICtrlCreateLabel("", 5, 5, 200, 100)
	GUICtrlSetColor(-1, 0xFFFFFF)
	Global $hGraphics = GUICtrlCreateGraphic(0, 0, $Width, $Height)
	GUISetBkColor(0x808080)
	GUISetState()
	Global $PIover180=((ATan(1)*4)/180),$Ver[5000][3],$_V[5000][3],$_Z[5000],$_Lin[5000],$Lin[5000][24],$Zcol[5000]
	Global $Zcent1,$Zcent2,$_Num,$LineNum,$VerNum,$Xa,$Ya,$Za,$iFPS,$Sa=$shade,$TransX=$x,$TransY=$y,$TransZ=$z,$RotX=$rx,$RotY=$ry,$RotZ=$rz,$Zm=$zoom,$ViewDis=$dis,$XOrigin=$Width/2,$YOrigin=$Height/2,$bLines=$borders
EndFunc

Func DrawToBuffer()
	$a = 0
	Do
		$Zmin = $_V[$Lin[$_Lin[$a]][1]][2]
		$Zmax = $_V[$Lin[$_Lin[$a]][1]][2]
		For $t = 1 To $Lin[$_Lin[$a]][0]
			If $Zmin > $_V[$Lin[$_Lin[$a]][$t]][2] Then $Zmin = $_V[$Lin[$_Lin[$a]][$t]][2]
			If $Zmax < $_V[$Lin[$_Lin[$a]][$t]][2] Then $Zmax = $_V[$Lin[$_Lin[$a]][$t]][2]
		Next
		$z = $Zmax - $Zmin
		If $z > $Zcol[$a] Then $z = $Zcol[$a]
		$Col = ("0x"&Hex(Int($Lin[$_Lin[$a]][21]-((($Lin[$_Lin[$a]][21]*$Sa)/$Zcol[$a])*$z)),2)&Hex(Int($Lin[$_Lin[$a]][22]-((($Lin[$_Lin[$a]][22]*$Sa)/$Zcol[$a])*$z)),2)&Hex(Int($Lin[$_Lin[$a]][23]-((($Lin[$_Lin[$a]][23]*$Sa)/$Zcol[$a])*$z)),2))
		If $bLines Then
			GUICtrlSetGraphic($hGraphics, 8, 0xFFFFFF, $Col)
		Else
			GUICtrlSetGraphic($hGraphics, 8, $Col, $Col)
		EndIf
		For $t = 1 To $Lin[$_Lin[$a]][0]
			If $t = 1 Then
				GUICtrlSetGraphic($hGraphics, 6, $_V[$Lin[$_Lin[$a]][$t]][0], $_V[$Lin[$_Lin[$a]][$t]][1])
			Else
				GUICtrlSetGraphic($hGraphics, 2, $_V[$Lin[$_Lin[$a]][$t]][0], $_V[$Lin[$_Lin[$a]][$t]][1])
			EndIf
		Next
		$a += 1
	Until $a > $_Num
EndFunc

Func BackfaceCulling()
	If $LineNum = 0 Then Return 0
	$_Num = -1
	$a = 0
	Do
		$Xmin1 = $_V[$Lin[$a][1]][0]
		$Xmax1 = $Xmin1
		$Ymin1 = $_V[$Lin[$a][1]][1]
		$Ymax1 = $Ymin1
		$Zmin1 = $_V[$Lin[$a][1]][2]
		$Zmax1 = $Zmin1
		For $b = 1 To $Lin[$a][0]
			If $Xmin1 > $_V[$Lin[$a][$b]][0] Then $Xmin1 = $_V[$Lin[$a][$b]][0]
			If $Xmax1 < $_V[$Lin[$a][$b]][0] Then $Xmax1 = $_V[$Lin[$a][$b]][0]
			If $Ymin1 > $_V[$Lin[$a][$b]][1] Then $Ymin1 = $_V[$Lin[$a][$b]][1]
			If $Ymax1 < $_V[$Lin[$a][$b]][1] Then $Ymax1 = $_V[$Lin[$a][$b]][1]
			If $Zmin1 > $_V[$Lin[$a][$b]][2] Then $Zmin1 = $_V[$Lin[$a][$b]][2]
			If $Zmax1 < $_V[$Lin[$a][$b]][2] Then $Zmax1 = $_V[$Lin[$a][$b]][2]
		Next
		Local $b=0,$DotProduct=($_V[$Lin[$a][3]][0]*(($_V[$Lin[$a][1]][2]*$_V[$Lin[$a][2]][1])-($_V[$Lin[$a][1]][1]*$_V[$Lin[$a][2]][2])))+($_V[$Lin[$a][3]][1]*(($_V[$Lin[$a][1]][0]*$_V[$Lin[$a][2]][2])-($_V[$Lin[$a][1]][2]*$_V[$Lin[$a][2]][0])))+($_V[$Lin[$a][3]][2]*(($_V[$Lin[$a][1]][1]*$_V[$Lin[$a][2]][0])-($_V[$Lin[$a][1]][0]*$_V[$Lin[$a][2]][1])))
		If $Xmin1 < 0 And $Xmax1 < 0 Then $b += 1
		If $Xmin1 > $Width And $Xmax1 > $Width Then $b += 1
		If $Ymin1 < 0 And $Ymax1 < 0 Then $b += 1
		If $Ymin1 > $Height And $Ymax1 > $Height Then $b += 1
		If $Zmin1 > $ViewDis Then $b += 1
		If $b <> 0 Then ContinueLoop
		If $DotProduct > 0 Then
			$_Num = $_Num + 1
			$_Lin[$_Num] = $a
			$_Z[$a] = ($Zmax1 - $Zmin1) / 2 + $Zmin1
		EndIf
		$a += 1
	Until $a > $LineNum
	If $_Num = 0 Then Return 0
	Do
		$Sw = False
		For $a = 0 To $_Num - 1
			If $_Z[$_Lin[$a]] <= $_Z[$_Lin[$a+1]] Then ContinueLoop
			$Dummy = $_Lin[$a]
			$_Lin[$a] = $_Lin[$a + 1]
			$_Lin[$a + 1] = $Dummy
			$Sw = True
		Next
	Until $Sw = False
EndFunc

Func ApplyPerpective()
	For $a = 0 To $VerNum
		$Xx = $_V[$a][0]
		$Yy = $_V[$a][1]
		$z = $_V[$a][2]
		If $z < -999 Then $z = -999
		If $z > 999 Then $z = 999
		$_V[$a][0] = $XOrigin + ($Xx / (1000-$z)) * 1000
		$_V[$a][1] = $YOrigin + ($Yy / (1000-$z)) * 1000
	Next
EndFunc

Func Zoom($z)
	For $a = 0 To $VerNum
		$_V[$a][2] += $z
	Next
EndFunc

Func Rotate($Xx, $Yy, $z)
	Local $Xn=$Xx*$PIover180,$Yn=$Yy*$PIover180,$Zn=$z*$PIover180
	For $a = 0 To $VerNum
		$Xx = $_V[$a][0]
		$Yy = $_V[$a][1]
		$z = $_V[$a][2]
		Local $X1 = $Xx * Cos($Zn) - $Yy * Sin($Zn),$Y1 = $Yy * Cos($Zn) + $Xx * Sin($Zn),$Z1 = $z
		$_V[$a][0] = $X1
		$_V[$a][1] = $Y1
		$_V[$a][2] = $Z1
		$Xx = $_V[$a][0]
		$Yy = $_V[$a][1]
		$z = $_V[$a][2]
		Local $Z1 = $z * Cos($Yn) - $Xx * Sin($Yn),$X1 = $z * Sin($Yn) + $Xx * Cos($Yn),$Y1 = $Yy
		$_V[$a][0] = $X1
		$_V[$a][1] = $Y1
		$_V[$a][2] = $Z1
		$Xx = $_V[$a][0]
		$Yy = $_V[$a][1]
		$z = $_V[$a][2]
		Local $Y1 = $Yy * Cos($Xn) - $z * Sin($Xn),$Z1 = $Yy * Sin($Xn) + $z * Cos($Xn),$X1 = $Xx
		$_V[$a][0] = $X1
		$_V[$a][1] = $Y1
		$_V[$a][2] = $Z1
	Next
EndFunc

Func Translate($x, $y, $z)
	For $a = 0 To $VerNum
		$_V[$a][0] += $x
		$_V[$a][1] += $y
		$_V[$a][2] += $z
	Next
EndFunc

Func Sca($S)
	For $a = 0 To $VerNum
		For $b = 0 To 2
			$_V[$a][$b] *= $S
		Next
	Next
EndFunc

Func CreateVertexArray()
	For $a = 0 To $VerNum
		For $b = 0 To 2
			$_V[$a][$b] = $Ver[$a][$b]
		Next
	Next
EndFunc

Func CalculateShadingFactors()
	For $a = 0 To $LineNum
		$Xmin1 = $Ver[$Lin[$a][1]][0]
		$Xmax1 = $Xmin1
		$Ymin1 = $Ver[$Lin[$a][1]][1]
		$Ymax1 = $Ymin1
		$Zmin1 = $Ver[$Lin[$a][1]][2]
		$Zmax1 = $Zmin1
			For $b = 1 To $Lin[$a][0]
				$Xmin2 = $Ver[$Lin[$a][$b]][0]
				$Ymin2 = $Ver[$Lin[$a][$b]][1]
				$Zmin2 = $Ver[$Lin[$a][$b]][2]
				If $Xmin1 > $Xmin2 Then $Xmin1 = $Xmin2
				If $Xmax1 < $Xmin2 Then $Xmax1 = $Xmin2
				If $Ymin1 > $Ymin2 Then $Ymin1 = $Ymin2
				If $Ymax1 < $Ymin2 Then $Ymax1 = $Ymin2
				If $Zmin1 > $Zmin2 Then $Zmin1 = $Zmin2
				If $Zmax1 < $Zmin2 Then $Zmax1 = $Zmin2
			Next
		$X1 = Abs($Xmax1 - $Xmin1)
		$Y1 = Abs($Ymax1 - $Ymin1)
		$Z1 = Abs($Zmax1 - $Zmin1)
		If $X1 >= $Y1 And $X1 >= $Z1 Then $Zcol[$a] = $X1
		If $Y1 >= $X1 And $Y1 >= $Z1 Then $Zcol[$a] = $Y1
		If $Z1 >= $X1 And $Z1 >= $Y1 Then $Zcol[$a] = $Z1
	Next
EndFunc

Func LoadModelFromFile($File)
	$Lines = _FileCountLines($File)
	$VerNum = FileReadLine($File, 1)
	For $i = 2 To $VerNum+2
		$sRead = FileReadLine($File, $i)
		$aTemp = StringSplit(StringTrimLeft($sRead, 2), " ", 3)
		For $n = 0 To 2
			$Ver[$i-2][$n] = $aTemp[$n]
		Next
	Next
	$LineN = $VerNum+3
	$LineNum = FileReadLine($File, $LineN)
	For $i = $VerNum+4 To $VerNum+4+$LineNum
		$sRead = FileReadLine($File, $i)
		$PCount = StringMid($sRead, 3, 1)
		If StringMid($sRead,4,1) <> " " Then $PCount = StringMid($sRead, 3, 2)
		$Cut = 4
		If StringMid($sRead,4,1) <> " " Then $Cut = 5
		$aTemp = StringSplit(StringTrimLeft($sRead,$Cut)," ",3)
		$Lin[$i-($VerNum+4)][0] = $PCount
		For $n = 1 To $PCount
			$Lin[$i-($VerNum+4)][$n] = $aTemp[$n-1]
		Next
		For $n = 21 To 23
			If Number($aTemp[$PCount+($n-21)]) <> 0 Then $Lin[$i-($VerNum+4)][$n] = Number($aTemp[$PCount+($n-21)])
		Next
	Next
EndFunc

Func FPS()
	GUICtrlSetData($hLabel, "ASE AutoIt-only 3D Engine" & @CRLF & "Shading: Flat " & $Sa & "x" & @CRLF & "Vertices: " & $VerNum+1 & @CRLF & "Faces: " & $LineNum-1 & @CRLF & "FPS: " & $iFPS/2)
	$iFPS = 0
EndFunc

Func quit()
	Exit
EndFunc