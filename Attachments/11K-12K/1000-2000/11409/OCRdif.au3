
#cs

// This difinition creator was created by ROYAL MIAH, all rights reserved OCT 2006
// If you wish to make any modification please do so, just keep my name
// All cridits got to Royal Miah
// Ntl_cable_guy (@T) hotmail.com

#ce

#include <GUIConstants.au3>





$Form1 = GUICreate("NumCR Definition Creator by Royal Miah (c) 2006 v1.0", 757, 525, 269, 178)
$CharName = GUICtrlCreateInput("", 560, 59, 161, 21)
GUICtrlCreateLabel("Name of the character i.e. number", 559, 35, 165, 17)
$DifRow = GUICtrlCreateCombo("1", 560, 106, 121, 21)
GUICtrlSetData(-1,"2|3|4|5|6|7|8|9|10","11") ;
GUICtrlCreateLabel("What is the width of the character", 560, 86, 164, 17)
$Define = GUICtrlCreateButton("Define", 560, 136, 81, 25, 0)
$ASource = GUICtrlCreateEdit("", 48, 184, 665, 145)
GUICtrlSetData($ASource, "")
GUICtrlCreateLabel("Autoit Source", 48, 160, 68, 17)
$Edit1 = GUICtrlCreateEdit("", 48, 360, 665, 129)
GUICtrlCreateLabel("Java Source", 48, 336, 64, 17)
$Edit2 = GUICtrlCreateEdit("", 32, 16, 481, 129, 0, 0)
GUICtrlSetData($Edit2, "Instruction on how to use this program"&@CRLF&""&@CRLF&"Select the number of width of the character you want to create a difinition for"&@CRLF&"then type the name of the character i.e. "&Chr(34)&"1"&Chr(34)&" without "&Chr(34)&""&Chr(34)&" once you have done"&@CRLF&"that all you have to do next is enter the values of each black pixels of your"&@CRLF&"character manually, where it says #."&@CRLF&""&@CRLF&"Each black pixel per row.")
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState(@SW_SHOW)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
		
	Case $msg = $Define
		
	$som = GUICtrlRead($DifRow)
	$somels = GUICtrlRead($CharName)
	$rox = _CreateDiffAu($som,$somels)
	$pox = _CreateDiffJava($som, $somels)
	
	GUICtrlSetData($ASource,$rox)
	GUICtrlSetData($Edit1,$pox)
	
	
	
	Case Else
		;;;;;;;
EndSelect

WEnd
			Func _CreateDiffAu($rows, $charaname)
    
						$STRINGVERIABLE = ""
		
				For $xwidth = 0 To $rows -1
			
						$STRINGVERIABLE &= " $row[$xwidth+"&$xwidth&"] = # And"
			
				Next

							$presult = "If "&StringTrimRight($STRINGVERIABLE, 4)
							$presult &= " Then $result &= """&$somels&""" EndIf"
							$result = $presult
	
				Return $result

			EndFunc
			
Func _CreateDiffJava($rows, $charaname)
    
						$STRINGVERIABLE = ""
		
				For $xwidth = 0 To $rows -1
			
						$STRINGVERIABLE &= " row[xwidth+"&$xwidth&"] == # &&"
			
				Next

							$presult = "If ("&StringTrimRight($STRINGVERIABLE, 2)
							$presult &= ") { result &= """&$somels&"""   }"
							$result = $presult
	
	
				Return $result

			EndFunc




Exit
