
HotKeySet("{ESC}", "Terminate")

Dim $Title = "Snow"

GUICreate($Title, @DesktopWidth, @DesktopHeight, 0, 0, 0x80000000)
GUISetBkColor(0)
GUISetFont(12, 400, "", "Terminal")
GUISetState()


Dim $w = 5
Dim $h = 0
Dim $Snow[18]
Dim $i
Dim $Pos
Dim $Speed = 20
Dim $n
Dim $r2


$Snow[0] = GUICtrlCreateLabel("*",5,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[1] = GUICtrlCreateLabel("*",20,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[2] = GUICtrlCreateLabel("*",35,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[3] = GUICtrlCreateLabel("*",50,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[4] = GUICtrlCreateLabel("*",65,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[5] = GUICtrlCreateLabel("*",80,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[6] = GUICtrlCreateLabel("*",95,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[7] = GUICtrlCreateLabel("*",110,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[8] = GUICtrlCreateLabel("*",125,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[9] = GUICtrlCreateLabel("*",140,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[10] = GUICtrlCreateLabel("*",155,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[11] = GUICtrlCreateLabel("*",170,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[12] = GUICtrlCreateLabel("*",185,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[13] = GUICtrlCreateLabel("*",200,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[14] = GUICtrlCreateLabel("*",215,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[15] = GUICtrlCreateLabel("*",230,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[16] = GUICtrlCreateLabel("*",245,4,12,15)
GUICtrlSetColor(-1, 0xFFFFFF)
$Snow[17] = GUICtrlCreateLabel("*",260,4,12,15) 
GUICtrlSetColor(-1, 0xFFFFFF)




While 1	

$r2 = 2
;$i = 0
	;For $i = 0 to 18

		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[$i])
			
		ControlMove($Title, "", $Snow[$i], 5, $pos[1]+$n)
		
	;Next
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[1])
			
		ControlMove($Title, "", $Snow[1], 20, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[2])
			
		ControlMove($Title, "", $Snow[2], 35, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[3])
			
		ControlMove($Title, "", $Snow[3], 50, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[4])
			
		ControlMove($Title, "", $Snow[4], 65, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[5])
			
		ControlMove($Title, "", $Snow[5], 80, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[6])
			
		ControlMove($Title, "", $Snow[6], 95, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[7])
			
		ControlMove($Title, "", $Snow[7], 110, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[8])
			
		ControlMove($Title, "", $Snow[8], 125, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[9])
			
		ControlMove($Title, "", $Snow[9], 140, $pos[1]+$n)			
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[10])
			
		ControlMove($Title, "", $Snow[10], 155, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[11])
			
		ControlMove($Title, "", $Snow[11], 170, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[12])
			
		ControlMove($Title, "", $Snow[12], 185, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[13])
			
		ControlMove($Title, "", $Snow[13], 200, $pos[1]+$n)		
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[14])
			
		ControlMove($Title, "", $Snow[14], 215, $pos[1]+$n)	
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[15])
			
		ControlMove($Title, "", $Snow[15], 230, $pos[1]+$n)														
		
				
		$n = Random( 0, $r2, 1)
				
			
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[16])
			
		ControlMove($Title, "", $Snow[16], 245, $pos[1]+$n)
		
		
		$n = Random( 0, $r2, 1)
		
		
        Sleep($Speed)
			
		$Pos = ControlGetPos($Title, "", $Snow[17])
			
		ControlMove($Title, "", $Snow[17], 260, $pos[1]+$n)
		
		
		
		If $h = @DesktopHeight Then $h = 0
		
		
WEnd







Func Terminate()
    Exit
EndFunc ;==>Terminate

