#include <GUIConstants.au3>

; Bounce Test by Hallman

; Change these variables to whatever you want
Global $Gravity = 1.4
; Has to be greater than 1 (1.4 = default)

Global $Bounce_Ratio = 0.7 ;
; Should be >0 and <1 (0.7 = default). If you set it to 1, then the ball will bounce to the same height that it was dropped from.

Global $TimePerTick = 30
; How long each tick is in miliseconds. Bigger number = slower ball movement (30 = default)


; -----------------------------------------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------------------

Dim $BallPos[4]
$BallPos[0] = 0
$BallPos[1] = 0
$BallPos[2] = 100
$BallPos[3] = 100

Dim $Current_Tick[6]
;~  $Current_Tick[0] = Active? (0 or 1)
;~  $Current_Tick[1] = Timer
;~  $Current_Tick[2] = Movement So Far
;~  $Current_Tick[3] = Total Movement

Global $Speed = 0

$Main_Window = GUICreate("Ball Test",$BallPos[2], $BallPos[3], (@DesktopWidth / 2) - ($BallPos[2] / 2), @DesktopHeight / 10, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOOLWINDOW)

$Ball_Ctrl = GUICtrlCreatePic("Golf Ball.gif", 0, 0, $BallPos[2], $BallPos[3])

GuiSetState()

WinSetOnTop($Main_Window, "", 1)

$Win_Pos = WinGetPos($Main_Window, "")

$BallPos[0] = $Win_Pos[0]
$BallPos[1] = $Win_Pos[1]

Sleep(2000)

$Loop_Timer = TimerInit()
$Time_Per_Loop = 1

$Speed = 1

$Current_Tick[0] = 0

While 1
	$Time_Per_Loop = TimerDiff($Loop_Timer)
	$Loop_Timer = TimerInit()
	
	If $Current_Tick[0] = 1 Then
		
		$Current_Tick_Time = TimerDiff($Current_Tick[1])
		
		If $Current_Tick_Time > $TimePerTick Then
			$BallPos[1] = $Current_Tick[3]
			WinMove($Main_Window, "", $BallPos[0], $BallPos[1], $BallPos[2], $BallPos[3])
			$Current_Tick[0] = 0
		Else
			If $Speed > 0 Then
				$int = ($TimePerTick - $Current_Tick_Time) / $Time_Per_Loop
				$Movement = ($Current_Tick[3] - $Current_Tick[2]) / $int
			
				$Current_Tick[2] += $Movement
				If $Current_Tick[2] >= $Current_Tick[3] Then
					$BallPos[1] = $Current_Tick[3]
					WinMove($Main_Window, "", $BallPos[0], $BallPos[1], $BallPos[2], $BallPos[3])
					$Current_Tick[0] = 0
				Else
					$BallPos[1] = $Current_Tick[2]
					WinMove($Main_Window, "", $BallPos[0], $BallPos[1], $BallPos[2], $BallPos[3])
				EndIf
			Else
				$int = ($TimePerTick - $Current_Tick_Time) / $Time_Per_Loop
				$Movement = ($Current_Tick[3] - $Current_Tick[2]) / $int
			
				$Current_Tick[2] += $Movement
				If $Current_Tick[2] <= $Current_Tick[3] Then
					$BallPos[1] = $Current_Tick[3]
					WinMove($Main_Window, "", $BallPos[0], $BallPos[1], $BallPos[2], $BallPos[3])
					$Current_Tick[0] = 0
				Else
					$BallPos[1] = $Current_Tick[2]
					WinMove($Main_Window, "", $BallPos[0], $BallPos[1], $BallPos[2], $BallPos[3])
				EndIf
			EndIf
		EndIf
	Else
		
		If $BallPos[1] = (@DesktopHeight - $BallPos[3]) Then
			$Speed = $Speed * -1
			$Speed = $Speed * $Bounce_Ratio
			If $Speed > -0.2 and $Speed < 0.2 Then
				Sleep(2000)
				Exit
			EndIf
		Else
			If $Speed > 0 Then
				$Speed = $Speed * $Gravity
			ElseIf $Speed < 0 Then
				$Speed = $Speed / $Gravity
				If $Speed > -2 Then $Speed = $Speed * -1
			EndIf
		EndIf
		
		$Current_Tick[2] = $BallPos[1]
		
		$Current_Tick[3] = $BallPos[1] + $Speed
		
		If $Current_Tick[3] > (@DesktopHeight - $BallPos[3]) Then
			$Current_Tick[3] = (@DesktopHeight - $BallPos[3])
		EndIf
		
		$Current_Tick[1] = TimerInit()
		
		$Current_Tick[0] = 1
	EndIf
WEnd
