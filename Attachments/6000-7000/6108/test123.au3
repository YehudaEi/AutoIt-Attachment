#include <GUIConstants.au3>
#include <file.au3>
#include <date.au3>

$punkt = (".")
;################################## GUI ###############################################

GUICreate("Active-Host Pinger V2.0" , 300, 400)
GUISetState()

GUICtrlCreateLabel ("1st-IP", 25, 75)
$input_startip_1 = GuiCtrlCreateInput("xxx", 20, 95, 50)
$input_startip_2 = GuiCtrlCreateInput("xxx", 90, 95, 50)
$input_startip_3 = GuiCtrlCreateInput("xxx", 160, 95, 50)
$input_startip_4 = GuiCtrlCreateInput("xxx", 230, 95, 50)

GUICtrlCreateLabel ("Last-IP", 25, 125)
$input_zielip_1 = GuiCtrlCreateInput("xxx", 20, 145, 50)
$input_zielip_2 = GuiCtrlCreateInput("xxx", 90, 145, 50)
$input_zielip_3 = GuiCtrlCreateInput("xxx", 160, 145, 50)
$input_zielip_4 = GuiCtrlCreateInput("xxx", 230, 145, 50)


GUICtrlCreateLabel ("Scantime", 25, 200)
$input_scanzeit = GUICtrlCreateInput("hh:mm:ss", 20, 220, 120)


$execute = GUICtrlCreateButton("Run", 45, 350, 100, 25)
$cancel = GUICtrlCreateButton("Cancel",155 , 350, 100, 25)



;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

while 1											
	$run = GUIGetMsg() 							
	IF $run = $cancel Then ExitLoop 			
	IF $run = $GUI_EVENT_CLOSE Then ExitLoop	
		IF $run = $execute Then
			$runtime = GUICtrlRead($input_scanzeit)
			$nowtime = _NowTime()
			time()								
			ExitLoop							
		EndIf								
WEnd
Exit

;##################################### Program ###########################################

Func time()
	GUISetCursor(15)
		while ($runtime < $nowtime)
			$nowtime = _NowTime()
		WEnd
	exec_ping()
EndFunc
;------------------------------------- Ping-Function ---------------------------------------
Func exec_ping()
	Local $startip1, $startip2,$startip3,$startip4,$endIP01,$endIP02,$endIP03,$endIP04
	$startip1 = GUICtrlRead($input_startip_1)										
	$startip2 = GUICtrlRead($input_startip_2)										
	$startip3 = GUICtrlRead($input_startip_3)										
	$startip4 = GUICtrlRead($input_startip_4)										
	$endIP01 = GUICtrlRead($input_zielip_1)											
	$endIP02 = GUICtrlRead($input_zielip_2)											
	$endIP03 = GUICtrlRead($input_zielip_3)											
	$endIP04 = GUICtrlRead($input_zielip_4)											
	

		$datei = FileOpen("hostpinger-v2_log.txt", 1)		
			While ($startip4 < $endIP04)	
								
				$pingIP = ($startip1&$punkt&$startip2&$punkt&$startip3&$punkt&$startip4)
				$endIP = ($endIP01&$punkt&$endIP02&$punkt&$endIP03&$punkt&$endIP04)		
;----------------------------------------------------------------------------------------------------------------------------------			
				$report = Ping($pingIP, 2000)						
;----------------------------------------------------------------------------------------------------------------------------------
					If $report > 0 Then
						filewrite($datei, $pingIP & @CRLF)			
					EndIf				
					
				$startip4 = ($startip4+1)
			WEnd
		FileClose($datei)
EndFunc