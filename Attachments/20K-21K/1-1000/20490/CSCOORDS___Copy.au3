;~~~ Set these parameters
$walk = 1;If 1 it will walk to a location, if 0 it will aim and shoot at a location. ;~walkbot/aimbot base..
$test = 0;If walk = 0 and test = 1 then this will aim at an enemy (not really tested but only works if theres 2 people total in server or theres only one person with a certain model or something idk...) ;~ aimbot base..
$modifier = 1.3 ;Modify this until it aims very quickly, but doesn't overshoot or vibrate (for me it finds the target in less than half a second)
$accuracy = 0.15 ;the minimum acceptable deviation of rotation (warning: if this is set too low the target may never be found)
$accuracy2 = 40;the minimum acceptable deviation of position (warning: if this is set too low the target may never be found)
$windowname = "Counter-Strike"
HotKeySet("f","review") ;review = aim/walk
HotKeySet("{UP}","setpos") ;set the pos to aim/walk too
HotKeySet("{DOWN}","quiti") ;quit
$x = 0x019F2460 ;the memory location for x value
$y = 0x019F2464 ;the memory location for y value
$z = 0x019F2468 ;the memory location for z value
$rY = 0x02DDB6E4 ;the memory location for Vertical rotation value ;(89 - -89)
$rX = 0x02DDB6E8; the memory location for Horizontal rotationi value ;(0 - 360)
;~~~
$randya = 0
$1 = 0
$2 = 0
$3 = 0
$aka = False
#include<NomadMemory.au3>
#include<Math.au3>
Opt("WinTitleMatchMode", 4)
SetPrivilege("SeDebugPrivilege", 1)
$ProcessID = WinGetProcess($windowname,"")
$DllInformation = _MemoryOpen($ProcessID)
If @Error Then
    MsgBox(4096, "ERROR", "Failed to open memory for process;" & $ProcessID)
    Exit
EndIf

$hp = 0x060FFF64
$pX = 0x01EF2A28
$pY = 0x01EF2A2C
$pZ = 0x01EF2A30

$posxa = ""
$posya = ""
$posza = ""

$posx = floor(_MemoryRead($X , $DllInformation, 'float'))
$posy = floor(_MemoryRead($Y , $DllInformation, 'float'))
$posz = floor(_MemoryRead($Z , $DllInformation, 'float'))
$rotx = floor(_MemoryRead($rY , $DllInformation, 'float'))
$roty = floor(_MemoryRead($rX , $DllInformation, 'float'))
while 1
	sleep(10)
WEnd

Func setpos($randya = 0)
	If $randya = 0 Then
		$posx = floor(_MemoryRead($X , $DllInformation, 'float'))
		$posy = floor(_MemoryRead($Y , $DllInformation, 'float'))
		$posz = floor(_MemoryRead($Z , $DllInformation, 'float'))
		;$rotx = floor(_MemoryRead($rotY , $DllInformation, 'float'))
		;$roty = floor(_MemoryRead($rotX , $DllInformation, 'float'))
	ElseIf $randya = 2 Then
		$posxa = floor(_MemoryRead($X , $DllInformation, 'float'))
		$posya = floor(_MemoryRead($Y , $DllInformation, 'float'))
		$posza = floor(_MemoryRead($Z , $DllInformation, 'float'))
	Else
		$posx = floor(_MemoryRead($pX , $DllInformation, 'float'))
		$posy = floor(_MemoryRead($pY , $DllInformation, 'float'))
		$posz = floor(_MemoryRead($pZ , $DllInformation, 'float'))
	EndIf
EndFunc
Func quiti()
	Exit
EndFunc

Func review()
	If $test = 1 Then
		setpos(1)
	EndIf
	
	
	$currentposx = floor(_MemoryRead($X , $DllInformation, 'float'))
	$currentposy = floor(_MemoryRead($Y , $DllInformation, 'float'))
	$currentposz = floor(_MemoryRead($Z , $DllInformation, 'float'))
	$currentrotx = floor(_MemoryRead($rX , $DllInformation, 'float'))
	$currentroty = floor(_MemoryRead($rY , $DllInformation, 'float'))
	#cs
	;Finding a point in the direction of aiming:
	
	$WTF = (6/Sin(_Radian((90-$currentrotx))))
	$MK = sqrt((6^2)+($WTF^2))
	;msgbox(0,"",$mk)
	$secondarypointx = $currentposx + 6
	$secondarypointy = $currentposy + $mk
	Dim $linex[2]
	Dim $liney[2]
	Dim $linez[2]
	$linex[0] = $currentposx
	$liney[0] = $currentposy
	$linez[0] = 0;$currentposz
	$linex[1] = $secondarypointx
	$liney[1] = $secondarypointy
	$linez[1] = 0

	
	$checkx = $posx
	$checky = $posy
	$checkz = 0
	
	Dim $AB[3] = [$linex[1]-$linex[1], $liney[1]-$liney[0], 0]
	Dim $AP[3] = [$checkx-$linex[0], $checky-$liney[0], 0]
	
	$ABAP = cross($AB,$AP)
	
	$a = Sqrt($ABAP[0]^2 + $ABAP[1]^2 + $ABAP[2]^2 )

	;Distance AB can be found using the distance formula as, AB = square root of (x3^2 + y3^2 + z3^2)
	$dAB = Sqrt($AB[0]^2 + $AB[1]^2 + $AB[2]^2)

	;Thus the distance we are looking for is a/AB.
	$answer = $a/$dAB

	MsgBox(0,"","Distance from point " & $checkx & "," & $checky & "," & $checkz & " to line from " & $linex[0] & "," & $liney[0] & "," & "0" & " to " & $linex[1] & "," & $liney[1] & "," & "0" & @CRLF & "= " & $answer)
	
	#ce
	$xchange = $posx - $currentposx 
	;msgbox(0,"",$xchange) ; good
	$ychange = $posy - $currentposy 
	$zchange = $posz - $currentposz
	;msgbox(0,"",$ychange) ; good
	$distance = sqrt($xchange^2 + $ychange^2)
	$heightdistance = sqrt($distance^2 + $zchange^2)
	$heightangle = -(($zchange)/$heightdistance)
	$heightangleofrotation = _Degree(Asin($Heightangle))
	;msgbox(0,"",$distance) ; good
	$angle = (($ychange)/$distance)
	$angleofrotation = _degree(Asin($angle))
	$angleofrotation = -$angleofrotation
	If $xchange < 0 and $angleofrotation > 0 Then ; 0-90
		$Finalrotation = $angleofrotation
		$oppositeangle = (180 + $angleofrotation) ;TICK
	EndIf
	
	If $xchange > 0 and $angleofrotation > 0 Then ;90 - 180
		$Finalrotation = (180 - $angleofrotation)
		$oppositeangle = (360 - $angleofrotation) ;TICK
	EndIf


	If $xchange > 0 and $angleofrotation < 0 Then ;180-270
		$Finalrotation = (180 - $angleofrotation)
		$oppositeangle = -$angleofrotation ;TICK
	EndIf

	If $xchange < 0 and $angleofrotation < 0 Then ;270-360
		$Finalrotation = (360 + $angleofrotation)
		$oppositeangle = (180 + $angleofrotation)
	EndIf
	;msgbox(0,"","You moved "&round($distance)&" at an angle of "&Round($Finalrotation) & @CRLF & "In order to face your original position ur rotation horizontally must be: "&$oppositeangle)
	$test = (floor(_MemoryRead($rY , $DllInformation, 'float')) - $heightangleofrotation)
	If $test > 0 Then
		$multiply = 1	
	ElseIf $test < 0 Then
		$multiply = -1
	Else
		$multiply = 1
	EndIf
	$k = 0
	$p = 0

	
	Do 
		sleep(1)
		$af = _MemoryRead($rX , $DllInformation, 'float')
		$test = ($af - $oppositeangle)
		$magnitude = $test*$modifier
 		If $test > -$accuracy and $test < $accuracy Then $k = 1	
		$testver = (_MemoryRead($rY , $DllInformation, 'float') - $heightangleofrotation)
		If $testver > -$accuracy and $testver < $accuracy Then 
				$p = 1
				$ver = 0
			Else
				$magnitude2 = $testver*$modifier;/2)
				If $magnitude2 > 0 and $magnitude2 < 1 Then $magnitude2 = 1
				If $magnitude2 < 0 and $magnitude2 > -1 Then $magnitude2 = -1
				$ver = -$magnitude2
				;_MouseMovePlus(0,-($magnitude))
		EndIf
			
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
			
		;/2)
			If $magnitude > 0 and $magnitude < 1 Then $magnitude = 1
				
			If $magnitude < 0 and $magnitude > -1 Then $magnitude = -1
			If $k = 0 or $p = 0 Then _MouseMovePlus($magnitude,$ver)
	Until $k = 1 and $p = 1
	;msgbox(0,"","Now will aim at old position",2)
	If $walk = 0 Then 
		MouseClick("left")
	Else
		Do
			Send("{w down}")
			sleep(100)
			Send("{w up}")
			setpos(2)
			$kx = $posxa - $posx
			$ky = $posya - $posy
			$kz = $posza - $posz
			If $kx > -$accuracy2 and $kx < $accuracy Then $1 = 1
			If $ky > -$accuracy2 and $ky < $accuracy Then $2 = 1
			If $kz > -$accuracy2 and $kz < $accuracy Then $3 = 1
			If $1 = 1 and $2 = 1 and $3 = 1 Then $aka = True
		Until $aka = True
		$aka = False
		$1 = 0
		$2 = 0
		$3 = 0
	EndIf
EndFunc

Func _MouseMovePlus($X, $Y,$absolute = 0)
	Local $MOUSEEVENTF_MOVE = 1
    Local $MOUSEEVENTF_ABSOLUTE = 32768
    DllCall("user32.dll", "none", "mouse_event", _
            "long",  $MOUSEEVENTF_MOVE + ($absolute*$MOUSEEVENTF_ABSOLUTE), _
            "long",  $X, _
            "long",  $Y, _
            "long",  0, _
        "long",  0)
EndFunc
Func onautoitexit()
	_MemoryClose($DllInformation)
EndFunc
;floor(_MemoryRead($X , $DllInformation, 'float'))
;floor(_MemoryRead($Y , $DllInformation, 'float'))
;floor(_MemoryRead($Z , $DllInformation, 'float'))