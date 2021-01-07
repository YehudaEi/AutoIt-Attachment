#NoTrayIcon 
#include <GUIConstants.au3>

$gui = GUICreate("MSTSC",230,130,-1,-1,BitOr($WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_SYSMENU))
$label1 = GUICtrlCreateLabel ("Company:",10,10,50) 
$company = GUICtrlCreateCombo ("", 60,10,150)
$label2 = GUICtrlCreateLabel ("PC:",10,35,50) 
$pc = GUICtrlCreateCombo ("", 60,35,150)
$connect = GUICtrlCreateButton ("Connect",60,70,70)
GUISetState (@SW_SHOW)

$tmp = ""
$a_company = IniReadSectionNames(@ScriptDir & "\mstsc.ini")
If @error Then 
;~     MsgBox(48, "Error", "Error occured, probably no INI file.")
Else
    For $i = 1 To $a_company[0]
        $tmp &= $a_company[$i] & "|"
    Next
    $tmp = StringTrimRight($tmp,1)
EndIf
GUICtrlSetData($company,$tmp)

While 1
    $msg = GUIGetMsg()
    
    If $msg = $company Then 
		GUICtrlSetData($pc,"") ; delete previous values
		$tmp = ""
		$a_pc = IniReadSection(@ScriptDir & "\mstsc.ini", GUICtrlRead($company))
		If @error Then 
			MsgBox(48, "", "Error occured, probably no INI file.")
		Else
			For $i = 1 To $a_pc[0][0]
				$tmp &= $a_pc[$i][0] & "=" & $a_pc[$i][1] & "|"
			Next
			$tmp = StringTrimRight($tmp,1)
		EndIf
		GUICtrlSetData($pc,$tmp)
	EndIf

    If $msg = $connect Then 
		$tmp = GUICtrlRead($pc)
		If $tmp = "" Then
			MsgBox(48,"Error","No PC selected")
		Else
			$tmp = StringSplit($tmp,"=") ; obtain text after =
			$tmp = $tmp[2]
			MsgBox(64,"Command","c:\windows\system32\mstsc.exe -v:" & $tmp & " /console /f")
;~ 			Run("c:\windows\system32\mstsc.exe -v:" & $tmp & " /console /f")
		EndIf
	EndIf

	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend
