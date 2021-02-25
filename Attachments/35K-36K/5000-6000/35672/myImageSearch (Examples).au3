#include <array.au3>
#include <myImageSearch.au3>

;Opt('MustDeclareVars', 1)

;########## test 1 Desktop ##########

Global $pozycja1
Global $time1

Global $ImageSearch = @ScriptDir & "\recycle.bmp"
Global $x = 0
Global $y = 0
Global $w = @DesktopWidth
Global $h = @DesktopHeight
Global $ColorTrans = ''
Global $mOnlyFirst = True

Sleep(10)
$time1 = TimerInit()

$pozycja1 = myImageSearch_Desktop($ImageSearch, $x, $y, $w, $h, $ColorTrans, $mOnlyFirst)
If @error Then ConsoleWrite("sorry image not exist" & @CRLF)

ConsoleWrite("time 1: " & TimerDiff($time1) / 1000 & ' sek.' & @CRLF)

If IsArray($pozycja1) Then
	_ArrayDisplay($pozycja1)
EndIf

;##################################

;########## test 2 Scren ##########

Global $pozycja2
Global $time2

Global $ImageBazowe = @ScriptDir & "\where is wally.bmp"
Global $ImageSearch = @ScriptDir & "\wanted wally.bmp"
Global $x = 0
Global $y = 0
Global $w = 0
Global $h = 0
Global $ColorTrans = "0x00ffff"
Global $mOnlyFirst = False ;False = search more image, but not all..,
;                           ;If u use "False" max area for search must be 800x600 pixels,
;                           ;or equivalent maximal 480.000 pixels!!!
;                           ;No more.
;                           ;Recommended is "True"
Sleep(10)
$time2 = TimerInit()

$pozycja2 = myImageSearch_Picture($ImageBazowe, $ImageSearch, $x, $y, $w, $h, $ColorTrans, $mOnlyFirst)
If @error Then ConsoleWrite("sorry image not exist" & @CRLF)

ConsoleWrite("time 2: " & TimerDiff($time2) / 1000 & ' sek.' & @CRLF)

If IsArray($pozycja2) Then
	_ArrayDisplay($pozycja2)
EndIf

;##################################
