;;FeelRO Homunculus Feeder

;;=================================================================================
;;Variable Declarations
;;=================================================================================

Global $StartUp			;StartUp choice
Global $FeedNum			;Amount of feed
Global $Counter			;Feed counter
Global $BarColor		;Color of hunger bar
Global $BarRed			;Red color of hunger bar
Global $BarBlue			;Blue color of hunger bar
Global $BarPos			;Position of hunger bar
Global $FeedPos			;Position of feed button
Global $YesPos			;Position of yes button

;;=================================================================================
;;Variable Definitions
;;=================================================================================

$BarRed = 7798784	;Sets red color of hunger bar
$BarBlue = 4802912	;Sets blue color of hunger bar
					;BarColor = $BarRed OR $BarBlue

;;=================================================================================
;;Functions
;;=================================================================================
Func _StartUp ()		;StartUp 'tutorial' window
	$StartUp = MsgBox (1, "FeelRO Homunculus Feeder", "Thank you for using the FeelRO Homunculus Feeder. To view the readme, click OK. To skip to the program, click Cancel.")
	If $StartUp == 1 Then	;If OK is pressed
		Run ("notepad.exe readme.txt")	;Open readme file
	EndIf
EndFunc

Func _GetFeedNum ()		;Gets amount of feed
	$FeedNum = InputBox ("FeelRO Homunculus Feeder", "How much feed do you have?")
	TrayTip ("FeelRO Homunculus Feeder", "Feed amount: " & $FeedNum, 1)
	Return $FeedNum
EndFunc

Func _GetBarPos	()		;Gets hunger bar position
	;User points cursor to hunger bar
	$BarPos = MouseGetPos ()
	TrayTip ("FeelRO  Homunculus Feeder", "Hunger bar position: " & $BarPos[0] & ", " & $BarPos[1], 1)
	Return $BarPos
EndFunc

Func _GetBarColor ()	;Gets hunger bar color
	;Using position from _GetBarPos
	$BarColor = PixelGetColor ($BarPos[0], $BarPos[1])
	TrayTip ("FeelRO Homunculus Feeder", "Hunger bar color: " & $BarColor, 1)
	Return $BarColor
EndFunc

Func _CheckBarRed ()	;Checks hunger bar for red color
	;Using position from _GetBarPos
	$BarColor = PixelGetColor ($BarPos[0], $BarPos[1])
	If $BarColor == $BarRed	Then	;If hunger bar is Red
		TrayTip ("FeelRO Homunculus Feeder", "Hunger bar is red", 1)
	Else							;If hunger bar is not Red
		TrayTip ("FeelRO Homunculus Feeder", "Hunger is not red", 1)
	EndIf
EndFunc

Func _CheckBarBlue ()	;Checks hunger bar for red color
	;Using position from _GetBarPos
	$BarColor = PixelGetColor ($BarPos[0], $BarPos[1])
	If $BarColor == $BarBlue Then		;If hunger bar is Blue
		TrayTip ("FeelRO Homunculus Feeder", "Hunger bar is blue", 1)
	Else								;If hunger bar is not Blue
		TrayTip ("FeelRO Homunculus Feeder", "Hunger is not blue", 1)
	EndIf
EndFunc

Func _GetFeedPos ()		;Gets feed button position
	;User points cursor to feed button
	$FeedPos = MouseGetPos ()
	TrayTip ("FeelRO  Homunculus Feeder", "Feed button position: " & $FeedPos[0] & ", " & $FeedPos[1], 1)
	Return $FeedPos
EndFunc

Func _GetYesPos	()		;Gets yes button position
	;User points cursor to yes button
	$YesPos = MouseGetPos ()
	TrayTip ("FeelRO  Homunculus Feeder", "Yes button position: " & $YesPos[0] & ", " & $YesPos[1], 1)
	Return $YesPos
EndFunc

Func _FeedHom ($FeedNum, $Counter, $BarColor, $BarRed, $BarBlue, $BarPos, $FeedPos, $YesPos)		;Feeds homunculus
	$Counter = $FeedNum
	Do				;Do the following until feed runs out
		While 1		;While hunger bar color is not red
			$BarColor = PixelGetColor ($BarPos[0], $BarPos[1])
				If $BarColor == $BarRed Then	;If hunger bar color is red
					TrayTip ("FeelRO Homunculus Feeder", "Hunger bar is red, will feed in 3 seconds", 1)
					Sleep (3000)
					ExitLoop
				Else							;If hunger bar color is not red
					TrayTip ("FeelRO Homunculus Feeder", "Hunger bar is blue, will try again in 3 seconds", 1)
					Sleep (3000)
					ContinueLoop
				EndIf
		WEnd
		;Sleep (3000)
		MouseClick ("left", $FeedPos[0], $FeedPos[1], 1, 5)		;Click feed button
		MouseClick ("left", $YesPos[0], $YesPos[1], 1, 5)		;Click yes button
		$Counter = $Counter - 1		;Keep track of one feed used
	Until $Counter == 0
EndFunc

;;=================================================================================
;;Program Section
;;=================================================================================

Call ("_StartUp")

While 1
	AutoItSetOption ("MouseCoordMode", 1)	;Sets mouse coord mode to window
	HotKeySet ("{F2}", "_GetFeedNum")
	HotKeySet ("{F3}", "_GetBarPos")
	HotKeySet ("{F4}", "_GetBarColor")
	HotKeySet ("{F5}", "_CheckBarRed")
	HotKeySet ("{F6}", "_CheckBarBlue")
	HotKeySet ("{F7}", "_GetFeedPos")
	HotKeySet ("{F8}", "_GetYesPos")
	HotKeySet ("{F9}", "_FeedHom")
WEnd