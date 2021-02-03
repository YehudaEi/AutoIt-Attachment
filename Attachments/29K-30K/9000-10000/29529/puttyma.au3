Opt('MustDeclareVars', 1)
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <String.au3>
#include <Process.au3>

#cs
	putty switch             puttyma.exe
	lists all putty sessions (appears with 5 empthy buttons if none)
	switches to the one you like
	keeps them alive except the one just in foreground
	sends them all back
	updates GUI if you open more .... as soon as you put it in foreground
	
	PAUSE -KEY  while pressed in an active putty session    excludes single putty windows from keepalive by renaming to PUDDY and back
	
	best regards to the autoit community                        doj
	
	Version 0.2 premiere, functional
	missing: nothing
	Version 0.3 uploaded to forum with a little flaw (finds itself)
	Version 0.4 polished
	
#ce

Local $oldslid, $kalv, $phan, $ptxt, $pbtn, $guix, $knbx, $guiy, $knby, $var, $found, $foundnew, $i, $x, $n, $m, $y
Local $gui, $stopb, $kpa, $kpat, $kpahx, $slider, $newguiy, $text, $message, $pbhan, $cexit, $sallb, $shall, $endit
Local $palered, $pale, $white, $minguiy, $Version, $keepali, $hexcheck, $kpaltxt, $winpos, $myprog, $me

$Version = "0.4"
$me = " puttyma.exe"
$myprog = $me & "           Kurzwahl und keepalive                   J.Schoormann    Version: "

Global $brand = "PuTTY"

$keepali = 0 ;keepalive isn't checked
$hexcheck = 0 ;and no hex stuff is entered
$kpaltxt = "{ENTER}" ;keep alive sequence
$oldslid = 180 ;initial keepalive counter at 3:00 min
$kalv = $oldslid ;and exactly that it's the initial keepalivetime

Dim $parr[300][5] ;manage up to 300 putty sessions -> turn this knob if you'd like more
$phan = 1 ; index handle putty window
$ptxt = 2
$pbtn = 3 ; corresponding btn in window !not! the handle  (this might stay longer)
$pbhan = 4 ; button handle (this might be renewed)
; latter has been deviced to keep the button for a putty session always on the same
; location in the GUI .. helps orientating while configuring

Dim $winpos[4] = [400, 250, 870, 99] ; the the first two are needed to locate the position of the own gui for renewal
; means if anyone moved it, the new  GUI will be placed at the new position

$guix = 870 ; GUI <-------->
$knbx = 167 ; button with

$guiy = 0 ; vertical dimension of the GUI to begin with
$knby = 20 ; button hight
$minguiy = 99 ;minimal dimension needed for slide and keepalive stuff and end button

$palered = 0xff7fff
$pale = 0xbfbf7f
$white = 0xFFFFFF

HotKeySet("{PAUSE}", "toggleDD")


$var = ProcessList($me) ;check if theres more than one instance of this program
If $var[0][0] > 1 Then ;highlander principle  "there can be but one"
	Exit
EndIf

While 1
	If dran() Then
		; are all putty windows known ?  and kill all inactive or any containing error messages
		$var = WinList()
		$found = 0 ;any putty alife ?
		$foundnew = 0 ;new among them
		For $i = 1 To $var[0][0]
			If StringInStr($var[$i][0], $brand) And IsVisible($var[$i][1]) And isputty($var[$i][1]) Then
				If StringInStr($var[$i][0], "atal") Or StringInStr($var[$i][0], "inactive") Then ; inaktive win or one cntn error message
					WinKill($var[$i][1])
					For $x = 1 To $parr[0][0]
						If $var[$i][1] = $parr[$x][$phan] Then ; remove all we knew about
							GUICtrlSetData($parr[$x][$pbhan], " ")
							$parr[$x][$ptxt] = " "
							$parr[$x][$phan] = 0
							ExitLoop
						EndIf
					Next
				Else ;aktive putty win found
					$found = $found + 1
					$foundnew = 1
					For $x = 1 To $parr[0][0]
						If $var[$i][1] = $parr[$x][$phan] Then ; if its allready known
							$foundnew = 0
							ExitLoop
						EndIf
					Next
					If $foundnew Then ;new one   look for an empty place
						$y = 0 ;none found
						For $n = 1 To $parr[0][0]
							If $parr[$n][$phan] = 0 Then
								$parr[$n][$ptxt] = $var[$i][0]
								$parr[$n][$phan] = $var[$i][1]
								GUICtrlSetData($parr[$n][$pbhan], $var[$i][0])
								$y = 1
								ExitLoop
							EndIf
						Next
						If not ($y) Then
							$parr[0][0] = $parr[0][0] + 1
							$parr[$parr[0][0]][$ptxt] = $var[$i][0]
							$parr[$parr[0][0]][$phan] = $var[$i][1]
							$guiy = 0 ;better check  gui capacity
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		If not ($found) And $guiy <> $minguiy Then
			; no putty window left, remove gui and wait
			$parr[0][0] = 5 ; with 5 empty buttons
			$guiy = 0
		Else
			For $i = 1 To $parr[0][0] ;single putties gone stealthily ?
				If $parr[$i][$phan] Then
					$found = 0
					For $x = 1 To $var[0][0]
						If $var[$x][1] = $parr[$i][$phan] Then
							$found = 1
							ExitLoop
						EndIf
					Next
					If Not $found Then
						GUICtrlSetData($parr[$i][$pbhan], " ")
						$parr[$i][$ptxt] = " "
						$parr[$i][$phan] = 0
					EndIf
				EndIf
			Next
		EndIf

		$newguiy = Int(($parr[0][0] - 1) / 5) * ($knby + 2) + $minguiy
		;if $parr[0][0] > 0 and $guiy <  $newguiy  then   ; ______________________________a new gui is neccessary_________________________________
		If $guiy < $newguiy Then
			If $gui Then
				$winpos = WinGetPos($myprog) ;set the new gui exactly at the old position
				GUIDelete($gui)
			EndIf
			$guiy = $newguiy
			$gui = GUICreate($myprog & $Version, 850, $guiy, $winpos[0], $winpos[1])
			;don't make it PuTTY .. it counts itself and will be included

			$kpa = GUICtrlCreateCheckbox("am Leben erhalten mit", 10, 15) ;English : keep alive with
			If $keepali Then GUICtrlSetState(-1, $GUI_CHECKED)
			$kpat = GUICtrlCreateInput($kpaltxt, 140, 15, 150)
			$kpahx = GUICtrlCreateCheckbox("hexadezimal", 310, 15)
			If $hexcheck Then GUICtrlSetState(-1, $GUI_CHECKED)
			$slider = GUICtrlCreateSlider(500, 22, 300, 22)
			GUICtrlSetLimit(-1, 600, 5) ;
			GUICtrlSetData($slider, $oldslid)
			GUICtrlCreateLabel(Int($oldslid / 60) & ":" & Mod($oldslid, 60), 650, 1)
			GUICtrlCreateLabel("10min", 805, 22)
			GUICtrlCreateLabel("5sek", 470, 22)
			$n = 1
			$y = 50
			$x = 5
			For $i = 1 To $parr[0][0]
				If $n = 6 Then
					$n = 1
					$x = 5
					$y = $y + $knby + 2
				EndIf
				;old btn context ought to be the same in the new gui look for previous context
				$text = " "
				$found = 0
				For $z = 1 To $parr[0][0]
					If $parr[$z][$pbtn] = $i Then
						$parr[$z][$pbhan] = GUICtrlCreateButton($parr[$i][$ptxt], $x, $y, $knbx, $knby)
						$found = 1
						ExitLoop
					EndIf
				Next
				If not ($found) Then
					For $z = 1 To $parr[0][0]
						If $parr[$z][$pbtn] = 0 Then
							$parr[$z][$pbhan] = GUICtrlCreateButton($parr[$i][$ptxt], $x, $y, $knbx, $knby)
							$parr[$z][$pbtn] = $z
							ExitLoop
						EndIf
					Next
				EndIf
				$x = $x + $knbx + 1
				$n = $n + 1
			Next
			$sallb = GUICtrlCreateButton("minimiere alle", 174, $newguiy - 22, $knbx, $knby)
			GUICtrlSetBkColor(-1, $pale)
			$shall = GUICtrlCreateButton("schliesse alle", 343, $newguiy - 22, $knbx, $knby)
			GUICtrlSetBkColor(-1, $pale)
			$endit = GUICtrlCreateButton("E N D E", 710, $newguiy - 22, 100, $knby)
			GUICtrlSetColor(-1, $white)
			GUICtrlSetBkColor(-1, $palered)
			GUISetState()
		EndIf

		$message = GUIGetMsg()

		If $message = $GUI_EVENT_CLOSE Or $message = $endit Then ;_____________________________end it ______________________________________________
			GUIDelete($gui)
			Exit
		EndIf

		For $i = 1 To $parr[0][0] ;__________________________________switch________________________________________________
			If $message = $parr[$i][$pbhan] Then
				WinActivate($parr[$i][$phan])
			EndIf
		Next

		If $message = $sallb Then ;_________________________________minimize all___________________________________________
			For $n = 1 To $parr[0][0]
				If $parr[$n][$phan] And not (BitAND(16, WinGetState($parr[$n][$phan]))) Then WinSetState($parr[$n][$phan], "", @SW_MINIMIZE)
			Next
		EndIf

		If $message = $shall Then ;_________________________________kill all___________________________________________
			For $n = 1 To $parr[0][0]
				If $parr[$n][$phan] Then
					WinKill($parr[$n][$phan])
					$parr[$n][$phan] = 0
					$parr[$n][$ptxt] = " " ;be aware...my User might just open a new putty session while I close all..
					GUICtrlSetData($parr[$n][$pbhan], " ")
				EndIf
			Next
		EndIf
	EndIf
	;                                                    ___________________________________keepalives___________________________________________
	If GUICtrlRead($kpa) = $GUI_CHECKED Then
		$keepali = 1
	Else ;we need this info while renewing the gui
		$keepali = 0
	EndIf
	If GUICtrlRead($kpahx) = $GUI_CHECKED Then
		$hexcheck = 1
	Else ;we need this info while renewing the gui
		$hexcheck = 0
	EndIf
	$kpaltxt = GUICtrlRead($kpat) ;ditto

	$x = GUICtrlRead($slider) - $oldslid ;changes?
	$kalv = $kalv + $x ; new keepalive delta time
	$oldslid = GUICtrlRead($slider)
	If $x Then GUICtrlCreateLabel(Int($oldslid / 60) & ":" & StringRight("0" & String(Mod($oldslid, 60)), 2), 650, 1) ;show keepalive pause (min:sec)
	If $keepali And secs() > $kalv Then
		$y = WinGetHandle("[active]", "")
		$var = WinList()
		For $i = 1 To $var[0][0]
			If StringInStr($var[$i][0], $brand) And IsVisible($var[$i][1]) Then
				If StringInStr($var[$i][0], "atal") Or StringInStr($var[$i][0], "inactive") Then
					WinKill($var[$i][1])
				Else
					If not ($var[$i][1] = $y) Then
						If $hexcheck Then
							ControlSend($var[$i][0], "", $var[$i][1], _HexToString($kpaltxt))
						Else
							ControlSend($var[$i][0], "", $var[$i][1], $kpaltxt)
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		$kalv = secs() + GUICtrlRead($slider)
	EndIf
WEnd
;======================================================================================================================================================
Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible

Func isputty($handle)
	If StringInStr(_ProcessGetName(WinGetProcess($handle)), $brand & ".exe") Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>isputty

Func secs()
	return (@HOUR * 3600 + @MIN * 60 + @SEC)
EndFunc   ;==>secs

Func dran()
	If Not WinExists($myprog) Then Return 1
	return (BitAND(WinGetState($myprog), 8))
EndFunc   ;==>dran

Func toggleDD()
	Local $n

	$n = WinGetTitle("[active]")
	If StringInStr($n, $brand) Then
		WinSetTitle("[active]", "", StringRegExpReplace($n, "(T{2})", "DD"))
	Else
		If StringInStr($n, "PuDDY") Then
			WinSetTitle("[active]", "", StringRegExpReplace($n, "(D{2})", "TT"))
		EndIf
	EndIf

	Return 0
EndFunc   ;==>toggleDD