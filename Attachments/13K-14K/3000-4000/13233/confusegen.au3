;	ConfuseGen
;	     V1.0
;           By Spyrorocks
;----------------------------------------------------
;Confuse gen will allow you to make it even 
;more difficult for reverse-engineers to get
;A string of text just by looking at the code!
;----------------------------------------------------

#include <GUIConstants.au3>
$Form1 = GUICreate("ConfuseGen - Spyrorocks", 383, 62, 193, 115)
$Group1 = GUICtrlCreateGroup("Generate", 0, 0, 381, 59)
$Label1 = GUICtrlCreateLabel("String:", 8, 26, 34, 17)
$thestring = GUICtrlCreateInput("", 44, 24, 269, 21)
$do_confuse = GUICtrlCreateButton("Confuse!", 318, 15, 59, 18, 0)
$thelen = GUICtrlCreateLabel("Len: 0", 320, 34, 40, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
$oldlen = 0
While 1
	$nMsg = GUIGetMsg()
	if $nMsg = $GUI_EVENT_CLOSE then exit
	if $nmsg = $do_confuse then
	if stringlen(guictrlread($thestring)) < 1 then
	msgbox(0, "ConfuseGen", "You must enter a sting to be confused!")
	else
	SplashTextOn ( "generating", "Generating Confused Code...", 200, 50, -1,-1, 33, -1, 9)
	$time = timerinit()
	$str = confuse(guictrlread($thestring))
	$time = timerdiff($time)
	splashoff()
	codewindow($str, $time)
	endif
	endif
	if stringlen(guictrlread($thestring)) <> $OLDLEN then
	guictrlsetdata($thelen, "Len: " & stringlen(guictrlread($thestring)))
	$oldlen = stringlen(guictrlread($thestring))
	endif
WEnd

func Confuse($string)
;Confuse() By Spyrorocks.
dim $Out
$out &= "func OutConfusedWord()" & @crlf
$out &= "Dim $sWord" & @crlf & @crlf
$Len = stringlen($string)

	for $i = 1 to $Len
	
	if random(1,2,1) = 2 then
	$num2 = random(4, 20, 1)
	$dat = stringmid($string, $i, $i)
	$out &= 'if Number(' & tochr(asc($dat)) & ') > Number(' & tochr(asc($dat) - random(0, asc($dat) - random(4, 20, 1), 1)) & ') Then' & @crlf
	$Num = random(0, asc($dat) - 1, 1)
	$Devide = $Num / 2
	$out &= '$sWord &= Chr(' & asc($dat) - $num & ' + ' & $devide - $num2 & ' + ' & $devide + $num2 & ')' & @crlf
	$out &= "Else" & @crlf
	$Num = random(0, asc($dat) + random(20, 500, 1), 1)
	$out &= '$sWord &= Chr(' & asc($dat) - $num & ' + ' & $Num / random(2, 5, 1) & ' + ' & random(20, 100, 1)&')' & @crlf
	$out &= "EndIf" & @crlf & @crlf

	else
	$num2 = random(4, 20, 1)
	$dat = stringmid($string, $i, $i)
	$out &= 'if Number(' & tochr(asc($dat)) & ') < Number(' & tochr(asc($dat) - random(0, asc($dat) - random(4, 20, 1), 1)) & ') Then' & @crlf
	$Num = random(0, asc($dat) + random(20, 500, 1), 1)
	$out &= '$sWord &= Chr(' & asc($dat) - $num & ' + ' & $Num / random(2, 5, 1) & '+ '&random(20, 100, 1)&')' & @crlf
	$out &= "Else" & @crlf
	$Num = random(0, asc($dat) - 1, 1)
	$Devide = $Num / 2
	$out &= '$sWord &= Chr(' & asc($dat) - $num & ' + ' & $devide - $num2 & ' + ' & $devide + $num2 & ')' & @crlf
	$out &= "EndIf" & @crlf & @crlf

	endif

	next


$out &= "Return $sWord" & @crlf
$out &= "EndFunc" & @crlf
return $out
endfunc

func ToChr($data)
dim $out

for $i = 1 to stringlen($data)
if stringlen($out) > 0 then
$out &= "&Chr(" & asc(stringmid($data, $i, $i)) & ")"
else
$out &= "Chr(" & asc(stringmid($data, $i, $i)) & ")"
endif
next

return $out
endfunc


func CodeWindow($thecode, $gentime)
GUISetState (@SW_DISABLE, $form1)
$Form2 = GUICreate("ConfuseGen - Spyrorocks - Generated Code", 460, 322, 256, 199)
$code = GUICtrlCreateEdit(";Confused Word Code Generated By ConfuseGen" & @crlf & ";Created By Spyrorocks" & @crlf & @crlf & $thecode, 0, 0, 459, 293)
$close = GUICtrlCreateButton("Close", 382, 296, 75, 25, 0)
$cpy = GUICtrlCreateButton("Copy To Clipboard", 280, 296, 99, 25, 0)
$time = GUICtrlCreateLabel("Generation Time: " & round($gentime, 4) & " Milliseconds", 0, 300, 277, 17, $SS_CENTER)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	if $nMsg = $GUI_EVENT_CLOSE then
	guidelete($form2)
	exitloop
	endif
	if $nMsg = $cpy then
	clipput(guictrlread($code))
	msgbox(0, "ConfuseGen", "Code Copied To Clipboard")
	endif
	if $nMsg = $close then
	guidelete($form2)
	exitloop
	endif
WEnd
GUISetState (@SW_ENABLE, $form1)
endfunc
