#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)
;GUISetBkColor(0x00E0FFFF)
OSD()

;-------------------------------------------------------------------------------------
; 
; The script also detects state changes (closed , If no OS selected , a core Image will be installed according SCCM TS).
Func OSD()
	Local $button_1, $group_1, $radio_1, $radio_2, $radio_3,$radio_4,$group_2
	Local $radioval1, $radioval2, $msg
	Local $radio_5, $radio_6, $radio_7, $radio_8, $radio_9, $radio_10, $radio_11, $radio_12, $radio_13, $radio_14,$radio_15,$radio_16,$radio_17,$radio_18,$radio_19,$radio_20

	Opt("GUICoordMode", 1)
	GUICreate(" OS Deployment", 500, 380)

	; Create the controls OS
	$button_1 = GUICtrlCreateButton("Start OS Deployment", 180, 320, 120, 40)
	$group_1 = GUICtrlCreateGroup("Select OS", 30, 100, 170, 180)
	GUIStartGroup()
	$radio_1 = GUICtrlCreateRadio("&OS1", 40, 120, 150, 50)
	$radio_2 = GUICtrlCreateRadio("&OS2", 40, 150, 150, 50)
	$radio_3 = GUICtrlCreateRadio("OS3", 40, 180, 150, 50)
	$radio_4 = GUICtrlCreateRadio("OS4", 40, 210, 150, 50)
	
	
	
	;Create the controls Languages (location)
	$group_2 = GUICtrlCreateGroup("Select Location", 310, 100, 170, 180)
	
	
	GUIStartGroup()
	$radio_10 = GUICtrlCreateRadio("GE", 320, 120, 70, 20)
	$radio_11 = GUICtrlCreateRadio("UK", 320, 150, 60, 20)
	$radio_12 = GUICtrlCreateRadio("AT", 320, 180, 60, 20)
	
	$radio_13 = GUICtrlCreateRadio("CH", 380, 120, 70, 20)
	$radio_14 = GUICtrlCreateRadio("CZ", 380, 150, 60, 20)
	$radio_15 = GUICtrlCreateRadio("SK", 380, 180, 60, 20)
	
	$radio_16 = GUICtrlCreateRadio("POL", 320, 210, 60, 20)
	$radio_17 = GUICtrlCreateRadio("FR", 380, 210, 60, 20)
	
	
	
	
	
	
	
GUISetBkColor(0xFFBF80)
	

	; Show the GUI
	GUISetState()

	
	; way would be to use GUICtrlRead() at the end to read in the state of each control
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				MsgBox(0, "", "No OS will be installed")
				Exit
			;Case $msg = $GUI_EVENT_MINIMIZE
				;MsgBox(0, "", "Dialog minimized", 2)
			;Case $msg = $GUI_EVENT_MAXIMIZE
				;MsgBox(0, "", "Dialog restored", 2)

			Case $msg = $button_1
				;MsgBox(0, "OS Deployment", "The selected OS will be installed " & $radioval1)
				
			Case $msg = $radio_1 And $msg = $radio_10
				;Case $msg = $button_1
				
			  
			  RunWait(@ComSpec & " /c " & "lang1>> C:\temp\Lang1.txt")
				MsgBox(0, "OS Deployment", "OS1 OS will be installed ")
				RunWait(@ComSpec & " /c " & "os1 >> C:\temp\OS1.txt")
				Exit
				
			Case $msg = $radio_2
				
				MsgBox(0, "OS Deployment", "OS2 OS will be installed " )
				RunWait(@ComSpec & " /c " & "OS2 >> C:\temp\OS2.txt")
				Exit
				
			Case $msg = $radio_3
				
				MsgBox(0, "OS Deployment", "OS3 OS will be installed " )
				RunWait(@ComSpec & " /c " & "OS3 >> C:\temp\OS3.txt")
				Exit
				
			Case $msg = $radio_4
				
				MsgBox(0, "OS Deployment", "XXXX OS will be installed ")
				RunWait(@ComSpec & " /c " & " XXXX >> C:\temp\XXXX.txt")
				
								Exit

;~               ; Languages selected
;~ 			  
			  GUISetState()
			  
			  Case $msg = $button_1
			  
		  ;Case $msg = $radio_10
			  
			  ;RunWait(@ComSpec & " /c " & "lang1>> C:\temp\Lang1.txt")
			  
			  
		  Case $msg = $radio_11
			   RunWait(@ComSpec & " /c " & "lang2 >> C:\temp\Lang2.txt")
			  
		  Case $msg = $radio_12
			   RunWait(@ComSpec & " /c " & "lang3>> C:\temp\Lang3.txt")
;~ 			  
;~ 		  Case $msg = $radio_13
;~ 			  
;~ 			   RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang4.txt")
;~ 		  Case $msg = $radio_14
;~ 			 RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang5.txt")  
;~ 			  
;~ 		  Case $msg = $radio_15
;~ 			   RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang6.txt")
;~ 			  
;~ 		  Case $msg = $radio_16
;~ 			   RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang7.txt")
;~ 			  
;~ 		  Case $msg = $radio_17
;~ 			   RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang8.txt")
;~ 			  
;~ 		  Case $msg = $radio_18
;~ 			  
;~ 			   RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang9.txt")
;~ 		  Case $msg = $radio_19
;~ 			  
;~ 			   RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang10.txt")
;~ 		  Case $msg = $radio_20
;~ 			  
;~ 			   RunWait(@ComSpec & " /c " & "WEBPC >> C:\temp\Lang11.txt")

;~ 			;Case $msg >= $radio_1 And $msg <= $radio_3
;~ 				;$radioval1 = $msg - $radio_1

		EndSelect
	WEnd
EndFunc   ;==>Example