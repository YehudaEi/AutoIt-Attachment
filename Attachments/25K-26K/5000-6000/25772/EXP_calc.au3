;===============================================================================
; Name...........: Exp Calc
; Description ...: Tool to calculate:

;					1) how many monsters you still need to kill to lvl up
;					2) How long will it take non stop playing or if you play spesific hours a day

; AutoIt Version.: 3.3.0.0

; http://www.autoitscript.com/forum/index.php?showtopic=93713
;===============================================================================

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <StatusBarConstants.au3>
#include <WindowsConstants.au3>
#include <INet.au3>

Global $GUI_NAME = 'Exp Calc 0.2'

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate($GUI_NAME, 371, 187, 406, 324)
$Button1 = GUICtrlCreateButton("Load Sample Data", 264, 117, 99, 20, 0)
$Button2 = GUICtrlCreateButton("Update", 288, 145, 75, 19, 0)

$Label1 = GUICtrlCreateLabel("Exp Before Mob Kill", 4, 15, 96, 17)
$Label2 = GUICtrlCreateLabel("Exp After Mob Kill", 4, 40, 87, 17)

$Label4_1 = GUICtrlCreateLabel("1 Monster Kill time:", 4, 75, 92, 17)
$Label4_2 = GUICtrlCreateLabel("Min", 157, 76, 21, 17)
$Label3 = GUICtrlCreateLabel("Playing h. a day", 4, 139, 79, 17)
$Label5 = GUICtrlCreateLabel("Sec", 157, 108, 23, 17)

$Label7_1 = GUICtrlCreateLabel("Monsters to kill", 207, 15, 74, 17)
$Label7_2 = GUICtrlCreateLabel("0", 290, 15, 74, 17)
$Label8_1 = GUICtrlCreateLabel("Exp:per Mob:", 207, 40, 67, 17) 
$Label8_2 = GUICtrlCreateLabel("0", 290, 40, 74, 17)
$Label9_1 = GUICtrlCreateLabel("Time to spend:", 207, 64, 71, 17)
$Label9_2 = GUICtrlCreateLabel("0", 207, 88, 162, 17)

$Input1_exp_before = GUICtrlCreateInput("", 100, 12, 97, 21)
$Input2_exp_after = GUICtrlCreateInput("", 100, 38, 97, 21)
$Input3_playing_hours = GUICtrlCreateInput("", 100, 136, 49, 21)
$Input4_mobkilltime_min = GUICtrlCreateInput("", 101, 72, 49, 21)
$Input5_mobkilltime_sec = GUICtrlCreateInput("", 100, 104, 49, 21)

$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

WinSetOnTop($GUI_NAME, "", 1)

AdlibEnable("_perform_calculations",600)

While 1
	$nMsg = GUIGetMsg()
	Sleep(20)
	Switch $nMsg
		
		Case $GUI_EVENT_CLOSE
		AdlibDisable()
		Exit
	
		Case $Button2
			_update_Check()
		
		Case $Button1
			GUICtrlSetData($Input1_exp_before,'21,3854')
			GUICtrlSetData($Input2_exp_after,'21,4084')			
			GUICtrlSetData($Input4_mobkilltime_min,'1')
			GUICtrlSetData($Input5_mobkilltime_sec,'60')
			GUICtrlSetData($Input3_playing_hours,'3')
EndSwitch
WEnd


Func _perform_calculations()
	
	$days		= 0
	$hours		= 0
	$minutes	= 0	
	
	$exp_before = GUICtrlRead($Input1_exp_before)
		$exp_before	= StringReplace($exp_before,',','.')
	
	$exp_after	= GUICtrlRead($Input2_exp_after)
		$exp_after	= StringReplace($exp_after,',','.')

	;## return if before & after fields are blank
	If $exp_before = '' then Return
	If $exp_after = '' then Return
		
	;## how many Exp to gain more:
;~ 	------------------------------------------------------------
	$exp_to_gain	= 100 - $exp_after
;~ 	------------------------------------------------------------

	;## how many mobbs to kill
;~ 	------------------------------------------------------------
	$exp_per_1_mob	= $exp_after - $exp_before
		
	$Mobs_to_kill	= $exp_to_gain / $exp_per_1_mob
;~ 	------------------------------------------------------------

	GUICtrlSetData($Label7_2,Round($Mobs_to_kill,0)) ; mobs to kill
	
	GUICtrlSetData($Label8_2,Round($exp_per_1_mob,4) & ' %') ; exp per mob, but we need to round it up

	
	;## how many time to spend nonstop in seconds
;~ 	------------------------------------------------------------
	$mobkilltime_min	= GUICtrlRead($Input4_mobkilltime_min)
	$mobkilltime_min	= StringReplace($mobkilltime_min,',','.')
	
	$mobkilltime_sec	= GUICtrlRead($Input5_mobkilltime_sec)
	$mobkilltime_sec	= StringReplace($mobkilltime_sec,',','.')
	
	;convert all to seconds
	$timetospend_in_sec = $mobkilltime_min * 60 + $mobkilltime_sec
	$timetospend_in_sec = $timetospend_in_sec * $Mobs_to_kill
	
	;~ convert to Days
	$timetospend_in_days	= $timetospend_in_sec / 86400
	
	;~ convert to hours ; we need this lather
	$timetospend_in_hours	= $timetospend_in_sec / 3600
	
;~ 	------------------------------------------------------
	; time nonstop playing required is:
	$playing_hours = GUICtrlRead($Input3_playing_hours)
	
	If $playing_hours <> '' Then ; progression formula An=a1+(n-1)*d    n=(An-a1/d) +1 
		
		$a1 = $playing_hours
		$d 	= $playing_hours
		$An = $timetospend_in_days
;~ 		
		$n = $An - $a1
		$n = $n / $d
		$n = $n	+1 ; value in hours 

		$days = $n * 24 ; value in hours
		
		_playinghours($days)
		
;~ 		GUICtrlSetData($Label9_2,$days & ' Days ' & $hours & ' Hours ' & $minutes & ' Min' ) ; mobs to kill		


	Else
		_playinghours($timetospend_in_days); if field is empty display non stop playing time
	EndIf

		
;~ 	Global $days	= $timetospend_in_days
;~ 	Global $hours	= 0
;~ 	Global $minutes	= 0
	
;~ 	------------------------------------------------------------



EndFunc

Func _playinghours($days)
	
	$days		= $days
	$hours		= 0
	$minutes	= 0	
	
	If StringInStr($days,'.') Then ; if we have decimal values first
		$split = StringSplit($days,'.')
		$days = $split[1]								; <---- Days final value
		
;~ 		_ArrayDisplay($split,'')

		$split_d_2 	=  '0.' & $split[2] 
		$hours		=  $split_d_2 * 24 					; hours 0,* or full value
			
		If StringInStr($hours,'.') Then 				; if we have decimal values in hours
			$split = StringSplit($hours,'.')
			$hours = $split[1]							; <---- hours final value
			
;~ 			_ArrayDisplay($split,'')

			$minutes 	=  '0.' & $split[2] 
			$minutes	=  $minutes * 60				; get minutes 0,*	
			
			If StringInStr($minutes,'.') Then
				$split = StringSplit($minutes,'.')
				$minutes = $split[1]					; <---- minutes final value
			EndIf		
		EndIf
	EndIf
	
	GUICtrlSetData($Label9_2,$days & ' Days ' & $hours & ' Hours ' & $minutes & ' Min' ) ; mobs to kill		

EndFunc

Func _update_Check()
	
	$URL = 'http://www.autoitscript.com/forum/index.php?showtopic=93713'

	$HTMLSource = _INetGetSource($URL)

	$_Arrayline = StringSplit($HTMLSource, @LF) ; this is the Array $_Arrayline
;~ 	
		for $i = 1 to $_Arrayline[0] 
			If StringInStr($_Arrayline[$i],'/Latest Ver') Then 
				
				If StringInStr($_Arrayline[$i],'Latest Ver') And StringInStr($_Arrayline[$i], $GUI_NAME) Then
					
					_GUICtrlStatusBar_SetText ($StatusBar1, "You are using the latest Version!")			
				Else
					
					$msgbox = MsgBox(1,'Update','New Version is Avalible Go get it?')
						If $msgbox = 1 Then
							ShellExecute($URL) ; yes get it
						EndIf
				EndIf
				
				ExitLoop
			EndIf
			
		Next

EndFunc
















