;===============================================================================
;
; Description:      AutoIt implementation of Sam Loyd's classic puzzle "Fifteen"
;
; Note(s):			The purpose of this game is to get the original ordering of 
;					the buttons. The only allowed moves are sliding buttons into 
;					the empty square. 
;
; Author(s):		odklizec
;
;===============================================================================
#NoTrayIcon
#include <GUIConstants.au3>
#include <Array.au3>
#include <Date.au3>
Global $StartArray[15], $button[16], $RNDArray[16]
Global $InvNum, $Turns, $Randomized
Global $Secs, $Mins, $Hour, $Time
$HWND=GUICreate("Sam Loyd's Fifteen", 135, 190, -1, -1,$WS_SYSMENU ,$WS_EX_TOPMOST + $WS_EX_TOOLWINDOW)
; create menu 
$filemenu = GuiCtrlCreateMenu ("New game")
$fileitem = GuiCtrlCreateMenuitem ("Start game",$filemenu)
$separator1 = GuiCtrlCreateMenuitem ("",$filemenu)
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)
; create game buttons
$button[0]= GUICtrlCreateButton("1", 5, 5, 30, 30)
$button[1]= GUICtrlCreateButton("2", 35, 5, 30, 30)
$button[2]= GUICtrlCreateButton("3", 65, 5, 30, 30)
$button[3]= GUICtrlCreateButton("4", 95, 5, 30, 30)
$button[4]= GUICtrlCreateButton("5", 5, 35, 30, 30)
$button[5]= GUICtrlCreateButton("6", 35, 35, 30, 30)
$button[6]= GUICtrlCreateButton("7", 65, 35, 30, 30)
$button[7]= GUICtrlCreateButton("8", 95, 35, 30, 30)
$button[8]= GUICtrlCreateButton("9", 5, 65, 30, 30)
$button[9]= GUICtrlCreateButton("10", 35, 65, 30, 30)
$button[10]= GUICtrlCreateButton("11", 65, 65, 30, 30)
$button[11]= GUICtrlCreateButton("12", 95, 65, 30, 30)
$button[12]= GUICtrlCreateButton("13", 5, 95, 30, 30)
$button[13]= GUICtrlCreateButton("14", 35, 95, 30, 30)
$button[14]= GUICtrlCreateButton("15", 65, 95, 30, 30)
; create empty square
$button[15]=GUICtrlCreateLabel ("",  95, 95, 30, 30,$SS_SUNKEN)
GUICtrlSetBkColor($button[15],0x000000)
; create turns label
GUICtrlCreateLabel ("Turns: ", 1, 130)
GUICtrlSetFont (-1,8,800)
$TurnsLabel=GUICtrlCreateLabel ("0", 31, 130,20,"", $SS_RIGHT)
GUICtrlSetFont (-1,8)
; create time label
GUICtrlCreateLabel ("Time: ", 57, 130)
GUICtrlSetFont (-1,8,800)
$TimeLabel=GUICtrlCreateLabel ("00:00:00", 86, 130)
GUICtrlSetFont (-1,8)
; set the gui..
GuiSetState()

; set onESC event
HotKeySet("{ESC}", "ExitOnESC")

; run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	Select
	; Menu items...
		Case $msg = $fileitem
			ResetGame()
			Randomize()
		; Start timer
			$timer = TimerInit()
			AdlibEnable("Timer", 50)
		Case $msg = $exititem
			ExitLoop
		Case $msg = $aboutitem
			Msgbox(8192+262144,"About","AutoIt implementation of classic" & @CRLF & "Sam Lloyd's game 'Fifteen'" _
			& @CRLF & @CRLF & "The purpose of this game is to get " & @CRLF & "the original ordering of the buttons." _ 
			& @CRLF & "The only allowed moves are sliding " & @CRLF & "buttons into the empty square." & @CRLF & "Good Luck! ;)" & @CRLF & @CRLF & "© Odklizec 2006")
	; "Fifteen" buttons
		Case $msg = $button[0]
			MoveStone($msg)
		Case $msg = $button[1]
			MoveStone($msg)
		Case $msg = $button[2]
			MoveStone($msg)
		Case $msg = $button[3]
			MoveStone($msg)
		Case $msg = $button[4]
			MoveStone($msg)			
		Case $msg = $button[5]
			MoveStone($msg)
		Case $msg = $button[6]
			MoveStone($msg)
		Case $msg = $button[7]
			MoveStone($msg)
		Case $msg = $button[8]
			MoveStone($msg)
		Case $msg = $button[9]
			MoveStone($msg)
		Case $msg = $button[10]
			MoveStone($msg)
		Case $msg = $button[11]
			MoveStone($msg)
		Case $msg = $button[12]
			MoveStone($msg)
		Case $msg = $button[13]
			MoveStone($msg)
		Case $msg = $button[14]
			MoveStone($msg)
	EndSelect
	If $msg = $GUI_EVENT_CLOSE Then 
		$IfExit = MsgBox(4+32+8192+262144,"Exit?", "Are you sure you wish to exit this lovely game?")
		If $IfExit =6 Then
			ExitLoop
		EndIf
	EndIf	
; short pause..just for lower CPU usage..
Sleep(15)
Wend

GUIDelete()
Exit

; reset game (array/UI/vars)
Func ResetGame()
Redim $StartArray[15]
	For $i = 0 to 14
		$StartArray[$i]=$i+1
		If $i<>14 Then
			GUICtrlSetData($button[$i],$i+1)
		EndIf
	Next
	$RNDArray=0
	$InvNum = 0
	$Turns=0
	$Randomized=0
	$sTime="00:00:00"
	GUICtrlSetData($TimeLabel,$sTime)
	GUICtrlSetData($TurnsLabel,"0")	
Return $StartArray
EndFunc

; randomize array and fill buttons with that randomized array
Func Randomize()
Dim $RNDArray[15],$rndStartArray[15], $ArrayLen, $rNum, $Inv_A, $Inv_B, $InvNumRes, $iKey, $iKeyIndexA, $iKeyIndexA 
	$rndStartArray=$StartArray
	$ArrayLen = UBound($rndStartArray)
	For $i=0 to 14
		$rNum=Random(0,$ArrayLen-1,1)
        $RNDArray[$i]=$rndStartArray[$rNum]
		_ArrayDelete($rndStartArray,$rNum)
		$ArrayLen = UBound($rndStartArray)
	Next	
; get number of inversions in randomized array
	For $m=0 To 13
		$Inv_A = $RNDArray[$m]
		For $n=$m+1 To 14
			$Inv_B = $RNDArray[$n]
			If ($Inv_A>$Inv_B) Then
				$InvNum = $InvNum + 1
			EndIf
		Next
	Next	
	$InvNumRes=IsFloat($InvNum/2)
; if the result of division is a floating value then swap 14 and 15
; this will make the game always solvable ;)
	If $InvNumRes = 1 Then
		For $i=0 To 14
			$iKey=$RNDArray[$i]
			If $iKey=14 Then
				$iKeyIndexA=$i
			EndIf	
			If $iKey=15 Then
				$iKeyIndexB=$i
			EndIf	
		Next	
		_ArraySwap( $RNDArray[$iKeyIndexA], $RNDArray[$iKeyIndexB] )
	EndIf	

; fill the buttons with randomized numbers
	For $i = 0 to 14
		GUICtrlSetData($button[$i],$RNDArray[$i])
	Next
	
; attach # 16 at the end of "start" and "randomized" array (as an empty square)
	ReDim $RNDArray[16]
	$RNDArray[15]=16
	ReDim $StartArray[16]
	$StartArray[15]=16

; array is randomized, allow moving with stones
	$Randomized=1
EndFunc	

; move the clicked stone, but only if neighbouring stone is black (16)..
Func MoveStone($btn_n)
	If $Randomized=1 Then
	; get pos. of clicked stone
		$pos = ControlGetPos($HWND, "", $btn_n)
	; get pos. of black stone
		$pos_black = ControlGetPos($HWND, "", $button[15])
		If 	($pos[0]+$pos[2]=$pos_black[0] AND $pos[1]=$pos_black[1]) OR ($pos[1]+$pos[3]=$pos_black[1] AND $pos[0]=$pos_black[0]) _
		OR ($pos[0]=$pos_black[0]+$pos_black[2] AND $pos[1]=$pos_black[1]) OR ($pos[1]=$pos_black[1]+$pos_black[3] AND $pos[0]=$pos_black[0]) Then
		; increase number of turns..
			$Turns=$Turns+1 
		; set turns label
			GUICtrlSetData($TurnsLabel,$Turns)	
		; set new pos of clicked stone
			GUICtrlSetPos ($btn_n, $pos_black[0],$pos_black[1])
		; set new pos of black stone
			GUICtrlSetPos ($button[15], $pos[0],$pos[1])
			RebuildArray($btn_n)
		EndIf
	EndIf
EndFunc	

; rebuild array after move
Func RebuildArray($btn_n)
; get but. text
	$ButText= GUICtrlRead($btn_n)
; get pos. of button in array
	$ButPosInArray = _ArraySearch ($RNDArray, $ButText)
; get pos. of black button in array
	$BlackButPosInArray = _ArraySearch ($RNDArray, "16")
; swap pos. of clicked button and black button in array
	_ArraySwap( $RNDArray[$ButPosInArray], $RNDArray[$BlackButPosInArray] )
; check if win
	CheckWinState()
EndFunc	

; check win state
Func CheckWinState()
	$StartArrayString = _ArrayToString( $StartArray,",")
	$RNDArrayString = _ArrayToString( $RNDArray,",")
; if the randomized array (now sorted by user's moves) = initial (non-randomized) array then user wins 
	If $StartArrayString = $RNDArrayString Then
	; stop game timer
		AdlibDisable()
	; disable next moves
		$Randomized=0
	; show results and congratulation (according number of moves)
		Select
		Case $Turns <= 70 
			MsgBox(8192+262144,"Congratulation!", "You win in.. " & $Turns & " turns!" & @CRLF & "Time of completion: " & $Time & @CRLF & @CRLF & "You are the KING!")
		Case $Turns > 70 AND $Turns <= 120
			MsgBox(8192+262144,"Congratulation!", "You win in.. " & $Turns & " turns!" & @CRLF & "Time of completion: " & $Time & @CRLF & @CRLF & "Well done!")
		Case $Turns > 120 AND $Turns <= 170
			MsgBox(8192+262144,"Congratulation!", "You win in.. " & $Turns & " turns!" & @CRLF & "Time of completion: " & $Time & @CRLF & @CRLF & "Nice! But I'm sure, you can do it better!")
		Case $Turns > 170 AND $Turns <= 220
			MsgBox(8192+262144,"Congratulation!", "You win in.. " & $Turns & " turns!" & @CRLF & "Time of completion: " & $Time & @CRLF & @CRLF & "Hmm..Hmmm..Maybe you should try it again?")
		Case $Turns > 220 
			MsgBox(8192+262144,"Congratulation!", "You win in.. " & $Turns & " turns!" & @CRLF & "Time of completion: " & $Time & @CRLF & @CRLF & "Oh c'mon!..You don't mean that, do you?!")
		EndSelect 
	EndIf
EndFunc	

; game stopwatch
Func Timer()
	_TicksToTime(Int(TimerDiff($timer)), $Hour, $Mins, $Secs )
; save current time to be able to test and avoid flicker..
	Local $sTime = $Time 
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	If $sTime <> $Time Then 
	GUICtrlSetData($TimeLabel,$Time)
	EndIf
EndFunc 

; On ESC..
Func ExitOnESC()
	$IfExit = MsgBox(4+32+8192+262144,"Exit?", "Are you sure you wish to exit this lovely game?")
	If $IfExit =6 Then
		Exit
	EndIf	
EndFunc
