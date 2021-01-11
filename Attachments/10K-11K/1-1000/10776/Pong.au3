#include <GuiConstants.au3>

$Size = 300 ; Size of field (in px)
$Speed = 5 ; Milleseconds between each ball update (bigger=slower, smaller=faster)
$Win = 11 ; Number of points you need to win
$Difficulty = 2 ; The average speed of CPU paddle (in px per ms)
$Percentage = 100 ; The % chance CPU paddle will move (greater control over speed)
$HorizontalSpeed = 2 ; The original horizontal speed of the ball
$VerticalSpeed = 1 ; The original vertical speed of the ball
$NeverClick = 0 ; Set this to 1 if you don't want to click to continue the game 0 if you do
$RandomStart = 1 ; Set this to 1 if you want the ball to go in a random direction at serves 0 otherwise
$DisplayFPS = 0 ; Set this to 1 if you want to see the game's FPS rate 0 otherwise
$SmoothPaddle = 1 ; Set this to 1 to try and make the CPU paddle move smoother (lowers perfomance slightly)

$gui = GUICreate ( "Pong in AutoIt!!", $Size, $Size )
GUISetBkColor ( 0x333333 ) ; Set the base color to really dark grey


For $n = 5 To $Size Step +30								; Create a dashed line down the middle
	GUICtrlCreateLabel ( "", ($Size-5)/2, $n, 5, 20 )		; that is below everything and barely visible
	GUICtrlSetBkColor ( -1, 0x404040 )
	GUICtrlSetState ( -1, $GUI_DISABLE )
Next

$Score_User = GUICtrlCreateLabel ( 0, $Size/2-41, 5, 35, 30, $SS_RIGHT )	; Create the user's score
GUICtrlSetFont ( -1, 24, 'bold' )										; Make the score big & bold
GUICtrlSetColor ( -1, 0x996000 )										; Set the score's color to dark orange

$Score_CPU = GUICtrlCreateLabel ( 0, $Size/2+5, 5, 35, 30 )		; Create the CPU's score
GUICtrlSetFont ( -1, 24, 'bold' )									; Make the score big & bold
GUICtrlSetColor ( -1, 0x996000 )									; Set the score's color to dark orange

$Paddle = GUICtrlCreateLabel ( "", 5, 5, 10, 50 )	; Create the user's paddle
GUICtrlSetBkColor ( -1, 0x009900 )					; Make the paddle a dark green color

$Ball = GUICtrlCreateLabel ( "", ($Size-10)/2, ($Size-10)/2, 10, 10 )	; Create the ball (square)
GUICtrlSetBkColor ( -1, 0x990000 )									; Make the ball a dark red color

$CPU = GUICtrlCreateLabel ( "", $Size - 15, 5, 10, 50 )	; Create the CPU's paddle
GUICtrlSetBkColor ( -1, 0x009900 )					; Make the paddle a dark green color

$Paused = GUICtrlCreateLabel ( "Paused", ($Size-105)/2, 105, ($Size-30)/2, 30 )	; Create the Paused label
GUICtrlSetFont ( -1, 24, 'bold' )											; Make the label big & bold
GUICtrlSetColor ( -1, 0x996000 )											; Set the label's color to dark orange
GUICtrlSetState ( -1, $GUI_HIDE )											; Set the label's default state to hidden

$Won = GUICtrlCreateLabel ( "You Won!", ($Size-105)/2, 105, ($Size-30)/2, 30 )	; Create the Win label
GUICtrlSetFont ( -1, 24, 'bold' )												; Make the label big & bold
GUICtrlSetColor ( -1, 0xbb0099 )												; Set the label's color to pink
GUICtrlSetState ( -1, $GUI_HIDE )												; Set the label's default state to hidden

$Lost = GUICtrlCreateLabel ( "You Lost!", ($Size-105)/2, 105, ($Size-30)/2, 30 )	; Create the Lose label
GUICtrlSetFont ( -1, 24, 'bold' )													; Make the label big & bold
GUICtrlSetColor ( -1, 0xbb0000 )													; Set the label's color to red
GUICtrlSetState ( -1, $GUI_HIDE )													; Set the label's default state to hidden

$FPS = GUICtrlCreateLabel ( "Calculating FPS", 0, 0, 300, 300 )				
GUICtrlSetColor ( -1, 0xFFFFFF )
If Not $DisplayFPS Then GUICtrlSetState ( -1, $GUI_HIDE )

GUISetState ( )	; Show the window
Sleep ( 1000 )	; Wait a minute for the player to get ready
$p = WinGetPos ( $gui )	; Find out the window's geometry and save it

Global $GoX = $HorizontalSpeed * (-1)	; Setup the initial ball speed and direction horizontally
Global $GoY = $VerticalSpeed * (-1)		; set it up vertically

$Pause_State = 0	; Tell the game we aren't paused
$Over = 0		; Tell the game no one won yet
$BALLFPST = TimerInit ( )
$BALLFPS = 0
$CBALLFPS = 0
$PADDLEFPST = TimerInit ( )
$PADDLEFPS = 0
$CPADDLEFPS = 0
BallManager ( )	; Update the ball's position once
While 1
	GUI()
	If TimerDiff ( $PADDLEFPST ) >= 1000 And $DisplayFPS Then
		$PADDLEFPS = $CPADDLEFPS
		GUICtrlSetData ( $FPS, "FPS: " & Round ( ($BALLFPS + $PADDLEFPS) / 2 ) & @CRLF & "Ball FPS: " & $BALLFPS & @CRLF & "Paddle FPS: " & $PADDLEFPS )
		$PADDLEFPST = TimerInit ( )
		$CPADDLEFPS=0
	ElseIf $DisplayFPS Then
		$CPADDLEFPS = $CPADDLEFPS + 1
	EndIf
	If Round ( Random ( 0, 99 ) ) > 100-$Percentage Then ; Do the following some percent of the time
		If $c_pos[1]+30 > $ctl_pos[1] And $SmoothPaddle Then	; move the paddle down
			For $n = 1 To $Difficulty	; move the paddle slower so it looks smooth
				GUICtrlSetPos ( $CPU, $Size - 15, $c_pos[1] - $n )	; Move the CPU's paddle
				;Sleep ( 1 )
			Next
		ElseIf $c_pos[1]+30 < $ctl_pos[1] And $SmoothPaddle Then	; move the paddle up
			For $n = 1 To $Difficulty	; Move the paddle slower so it looks smooth
				GUICtrlSetPos ( $CPU, $Size - 15, $c_pos[1] + $n )	; Move the CPU's paddle
				;Sleep ( 1 )
			Next
		ElseIf $c_pos[1]+30 > $ctl_pos[1] Then	; move the paddle down
			GUICtrlSetPos ( $CPU, $Size - 15, $c_pos[1] - $Difficulty )
		ElseIf $c_pos[1]+30 < $ctl_pos[1] Then	; move the paddle up
			GUICtrlSetPos ( $CPU, $Size - 15, $c_pos[1] + $Difficulty )
		EndIf
	EndIf
	Sleep ( 1 ) ; This line makes the script not use up tons of the Processor
WEnd

Func BallManager ( )
	If TimerDiff ( $BALLFPST ) >= 1000 And $DisplayFPS Then
		$BALLFPS = $CBALLFPS
		GUICtrlSetData ( $FPS, "FPS: " & Round ( ($BALLFPS + $PADDLEFPS) / 2 ) & @CRLF & "Ball FPS: " & $BALLFPS & @CRLF & "Paddle FPS: " & $PADDLEFPS )
		$BALLFPST = TimerInit ( )
		$CBALLFPS=0
	ElseIf $DisplayFPS Then
		$CBALLFPS = $CBALLFPS + 1
	EndIf
	Global $ctl_pos = ControlGetPos ( $gui, '', $Ball )		; Find the ball's position and save it
	Global $p_pos = ControlGetPos ( $gui, '', $Paddle )		; Find the player's paddle position and save it
	Global $c_pos = ControlGetPos ( $gui, '', $CPU )		; Find the CPU's paddle position and save it
	
	If $ctl_pos[0] <=5 Then		; If the ball gets real close to the left side score on the player
		GUICtrlSetPos ( $Ball, ($Size-10)/2, ($Size-10)/2 )	; put the ball back in the middle
		$cpu_score = GUICtrlRead ( $Score_CPU )	; get the CPU's score and save it
		GUICtrlSetData ( $Score_CPU, $cpu_score + 1 )	; add 1 to the CPU's score
		Global $ctl_pos = ControlGetPos ( $gui, '', $Ball )	; reload the ball's position
		Global $GoX = $HorizontalSpeed * (-1)	; make the ball go it's original horizontal speed
		Global $GoY = $VerticalSpeed * (-1)		; make the ball go it's original vertical speed
		If $RandomStart Then RandomServe ( $HorizontalSpeed, $VerticalSpeed )	; serve in a random direction
		If $cpu_score + 1 < $Win Then ClickMe()	; if the CPU didn't win wait for the player to click and resume the game
		If $cpu_score + 1 = $Win Then Win ( 1 ) ; if the CPU won, display the message
	EndIf
	
	If $ctl_pos[0] >=$Size-5 Then		; If the ball gets real close the the right side score on the CPU
		GUICtrlSetPos ( $Ball, ($Size-10)/2, ($Size-10)/2 )	; put the ball back in the middle
		$player_score = GUICtrlRead ( $Score_User )	; get the player's score and save it
		GUICtrlSetData ( $Score_User, $player_score + 1 ) ; add 1 to the player's score
		Global $ctl_pos = ControlGetPos ( $gui, '', $Ball ) ; reload the ball's position
		Global $GoX = $HorizontalSpeed * (-1)	; make the ball go it's original horizontal speed
		Global $GoY = $VerticalSpeed * (-1)		; make the ball go it's original vertical speed
		If $RandomStart Then RandomServe ( $HorizontalSpeed, $VerticalSpeed )	; serve in a random direction
		If $player_score + 1 < $Win Then ClickMe()	; if the player didn't win wait for a click to resume the game
		If $player_score + 1 = $Win Then Win ( 0 )	; if the player won, display a message
	EndIf
	
	If $ctl_pos[1] <= 5 Then	; If the ball hits the top reverse it's vertical direction
		$GoY = $GoY * (-1)

	ElseIf $ctl_pos[1] >= $Size - 15 Then	; If the ball hits the bottom reverse it's vertical direction
		$GoY = $GoY * (-1)

	ElseIf $ctl_pos[0] >= $Size - 25 And $ctl_pos[1] >= $c_pos[1] And $ctl_pos[1] <= $c_pos[1]+25 Then	; If the ball hits the top half of the CPU's
		$GoX = $GoX * (-1)																				; paddle reverse its horizontal direction
		If $GoY > 0 Then $GoY = $GoY * (-1)	; if the ball has vertical speed reverse that too
		If $ctl_pos[1] >=$c_pos[1]-10 And $ctl_pos[1] <= $c_pos[1]+10 Then $GoX = $GoX + 1	; if the ball hits the paddle's very top increase its speed
		If $ctl_pos[1] >=$c_pos[1]-10 And $ctl_pos[1] <= $c_pos[1]+10 Then $GoY = $GoY - 1	; ''
			
		If $ctl_pos[1] >=$c_pos[1]+20 And $ctl_pos[1] <= $c_pos[1]+30 Then $GoX = $GoX - 1	; if the ball hits the middle of the paddle slow it down
		If $ctl_pos[1] >=$c_pos[1]+20 And $ctl_pos[1] <= $c_pos[1]+30 Then $GoY = $GoY + 1	; ''
			
	ElseIf $ctl_pos[0] >= $Size - 25 And $ctl_pos[1] >= $c_pos[1]-10+25 And $ctl_pos[1] <= $c_pos[1]+50+10 Then	; If the ball hits the bottom half of the CPU's
		$GoX = $GoX * (-1)																						; paddle reverse it's horizontal direction
		If $GoY < 0 Then $GoY = $GoY * (-1) ; if the ball has vertical speed reverse that too
		If $ctl_pos[1] >=$c_pos[1]+40 And $ctl_pos[1] <= $c_pos[1]+50 Then $GoX = $GoX + 1	; if the ball hits the paddle's very bottom increase it's speed
		If $ctl_pos[1] >=$c_pos[1]+40 And $ctl_pos[1] <= $c_pos[1]+50 Then $GoY = $GoY + 1	; ''
			
		If $ctl_pos[1] >=$c_pos[1]+20 And $ctl_pos[1] <= $c_pos[1]+30 Then $GoX = $GoX - 1	; if the ball hits the middle of the paddle slow it down
		If $ctl_pos[1] >=$c_pos[1]+20 And $ctl_pos[1] <= $c_pos[1]+30 Then $GoY = $GoY + 1	; ''
			
	ElseIf $ctl_pos[0] <= 15 And $ctl_pos[1] >= $p_pos[1]-10 And $ctl_pos[1] <= $p_pos[1]+25+10 Then	; If the ball hits the top half of the
		$GoX = $GoX * (-1)																				; player's paddle reverse it's horizontal direction
		If $GoY > 0 Then $GoY = $GoY * (-1) ; if the ball has vertical speed reverse that too
		If $ctl_pos[1] >=$p_pos[1]-10 And $ctl_pos[1] <= $p_pos[1]+10 Then $GoX = $GoX + 1	; if the ball hits the paddle's very top increase it's speed
		If $ctl_pos[1] >=$p_pos[1]-10 And $ctl_pos[1] <= $p_pos[1]+10 Then $GoY = $GoY - 1	; ''
			
		If $ctl_pos[1] >=$p_pos[1]+20 And $ctl_pos[1] <= $p_pos[1]+30 Then $GoX = $GoX - 1	; if the ball hits the middle of the paddle slow it down
		If $ctl_pos[1] >=$p_pos[1]+20 And $ctl_pos[1] <= $p_pos[1]+30 Then $GoY = $GoY + 1	; ''

	ElseIf $ctl_pos[0] <= 15 And $ctl_pos[1] >= $p_pos[1]-10+25 And $ctl_pos[1] <= $p_pos[1]+50+10 Then	; If the ball hits the bottom half of the
		$GoX = $GoX * (-1)																				; player's paddle reverse it's horizontal direction
		If $GoY < 0 Then $GoY = $GoY * (-1)	; if the ball has vertical speed reverse that too
		If $ctl_pos[1] >=$p_pos[1]+40 And $ctl_pos[1] <= $p_pos[1]+50 Then $GoX = $GoX + 1	; if the ball hits the paddle's very bottom increase it's speed
		If $ctl_pos[1] >=$p_pos[1]+40 And $ctl_pos[1] <= $p_pos[1]+50 Then $GoY = $GoY + 1	; ''
			
		If $ctl_pos[1] >=$p_pos[1]+20 And $ctl_pos[1] <= $p_pos[1]+30 Then $GoX = $GoX - 1	; if the ball hits the middle of the paddle slow it down
		If $ctl_pos[1] >=$p_pos[1]+20 And $ctl_pos[1] <= $p_pos[1]+30 Then $GoY = $GoY + 1	; ''

	EndIf
		
	GUICtrlSetPos ( $Ball, $ctl_pos[0] + $GoX, $ctl_pos[1] + $GoY )	; this is the line that ACTUALLY moves the ball
EndFunc

Func ShowCursor ( )
	Do 
		$ret = DllCall ( "User32.dll", "long", "ShowCursor", "long", 1 ) ; call user32.dll and tell it to show the mouse
	Until $ret[0] > 0 ; if the call returns more than 0 it worked
EndFunc

Func HideCursor ( )
	Do 
		$ret = DllCall ( "User32.dll", "long", "ShowCursor", "long", 0 ) ; call user32.dll and tell it to hide the mouse
	Until $ret[0] < 0 ; if the call returns less than 0 it worked
EndFunc

Func Win ( $Player )
	AdlibDisable ( ) ; stop updating the ball's position
	$Over = 1 ; tell the rest of the script the game is over
	If $Player = 0 Then
		GUICtrlSetState ( $Won, $GUI_SHOW )	; if the cpu lost show the message saying "You Won!"
	ElseIf $Player = 1 Then
		GUICtrlSetState ( $Lost, $GUI_SHOW )	; if you lost show the message saying "You Lost!"
	EndIf
	ClickMe ( 1 )	; Force the user to click if they want to play again
	GUICtrlSetData ( $Score_CPU, 0 )	; Reset the scores
	GUICtrlSetData ( $Score_User, 0 )	; ''
	If $Player = 0 Then
		GUICtrlSetState ( $Won, $GUI_HIDE )	; hide the message saying "You Won!"
	ElseIf $Player = 1 Then
		GUICtrlSetState ( $Lost, $GUI_HIDE )	; Hide the message saying "You Lost!"
	EndIf
	$Over = 0	; tell the rest of the script the game has started again
EndFunc

Func GUI()
	$msg = GUIGetMsg ( )
	$crs = GUIGetCursorInfo ( )
	Opt ( "MouseCoordMode", 0 )
	$crs2 = MouseGetPos ( )	; this tells different mouse coordinates than $crs that we
							; need to use if we want to know if the user has their mouse on the title bar
							
	If $msg = -3 Then Exit	; If the close button was clicked exit the program
	If $crs[1] < $Size - 65 And $crs[1] > 0 And WinActive ( $gui ) Then
		GUICtrlSetPos ( $Paddle, 5, 5 + $crs[1] )	; Move the player's paddle
	EndIf
	If $crs[1] > $Size - 60 And WinActive ( $gui ) Then
		GUICtrlSetPos ( $Paddle, 5, $Size - 60 )	; if the player moved the mouse out of the bottom too quickly just skip down there
	EndIf
	If $crs2[1] < ( $p[3] - $Size ) Then ; Calculate the height of the title bar
		ShowCursor ( )				   ; If the cursor is on the title bar show it
	Else
		HideCursor ( )				   ; If the cursor isn't on the title bar hide it
	EndIf
	If WinActive ( $gui ) And $Pause_State = 0 And $Over = 0 Then	; Un pause the game
		AdlibEnable ( "BallManager", $Speed ) ; restart the ball's movement
		GUICtrlSetState ( $Paused, $GUI_HIDE ) ; hide the paused message
		$Pause_State = 1 ; tell everyone we have resumed the game
	ElseIf Not ( WinActive ( $GUI ) ) And  $Pause_State = 1 And $Over = 0 Then	; Auto pause the game
		$Pause_State = 0 ; tell everyone we're paused
		AdlibDisable ( )	; stop the ball from moving
		GUICtrlSetState ( $Paused, $GUI_SHOW ) ; show the paused message
	EndIf
EndFunc

Func ClickMe( $stayhere = 0 )
	AdlibDisable ( ) ; stop moving the ball
	While 1
		$cur = GUIGetCursorInfo ( )
		if $cur[2] = 1 then ExitLoop ; exit the loop if the user clicks
		if $NeverClick And $stayhere = 0 then ExitLoop ; if the user doesn't want to click don't make him/her
		GUI()
		Sleep ( 1 ) ; we don't like to eat cpu power
	WEnd
	AdlibEnable ( "BallManager", $Speed ) ; start moving the ball again
EndFunc

Func RandomServe ( $x, $y )
	$how = Round ( Random ( 1, 12 ) ) ; choose a random number between 1 & 12
	Select	; depending on the number send the ball in a direction
	Case $how = 1
		$GoX = $x
		$GoY = $y
	Case $how = 2
		$GoX = $x * (-1)
		$GoY = $y
	Case $how = 3
		$GoX = $x
		$GoY = $y * (-1)
	Case $how = 4
		$GoX = $x * (-1)
		$GoY = $y * (-1)
	Case $how = 5
		$GoX = $y
		$GoY = $x
	Case $how = 6
		$GoX = $y * (-1)
		$GoY = $x
	Case $how = 7
		$GoX = $y
		$GoY = $x * (-1)
	Case $how = 8
		$GoX = $y * (-1)
		$GoY = $x * (-1)
	Case $how = 9
		$GoX = $y
		$GoY = $y
	Case $how = 10
		$GoX = $x
		$GoY = $x
	Case $how = 11
		$GoX = 1
		$GoY = 1
	Case $how = 12
		$GoX = -1
		$GoY = -1
	EndSelect
	If $GoX = 0 Then $GoX = 1
EndFunc