#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\..\Program Files\AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_outfile=Config Helper.exe
#AutoIt3Wrapper_Res_Fileversion=1.1.1.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>


#Region ### START Koda GUI section ### Form=

$Form1 = GUICreate("Form1", 626, 795, 193, 125)
$Label1 = GUICtrlCreateLabel("How many physical offices do you have?", 8, 24, 197, 17)
$Combo1 = GUICtrlCreateCombo("", 208, 21, 60, 25)
GUICtrlSetData(-1, "1|2-5|6-10|10+")
$Label2 = GUICtrlCreateLabel("Do you have offices in multiple cities or states?", 8, 68, 224, 17)
$Combo2 = GUICtrlCreateCombo("", 232, 65, 60, 25)
GUICtrlSetData(-1, "Yes|No")
$Label3 = GUICtrlCreateLabel("Do you have different departments?", 8, 112, 224, 17)
$Combo3 = GUICtrlCreateCombo("", 190, 109, 60, 25)
GUICtrlSetData(-1, "Yes|No")
$Label4 = GUICtrlCreateLabel("Do you have people that only work on specific areas?", 8, 156, 300, 17)
$Combo4 = GUICtrlCreateCombo("", 315, 153, 60, 25)
GUICtrlSetData(-1, "Yes|No")
$Label5 = GUICtrlCreateLabel("Do you need to limit access for any of your employees?", 8, 200, 265, 17)
$Combo5 = GUICtrlCreateCombo("", 285, 198, 60, 25)
GUICtrlSetData(-1, "Yes|No")

$Reset = GUICtrlCreateButton("Reset", 552, 435, 60, 25)

$Summary = GUICtrlCreateButton("Summary", 490, 435, 60, 25)



GUISetState(@SW_SHOW, $Form1)

$Edit1 = GUICtrlCreateEdit("",8, 472, 601, 305)

GUISetState(@SW_SHOW)



#EndRegion ### END Koda GUI section ###

$output = "Recomendations:"





While 1
	$nMsg = GUIGetMsg()
	
Switch $nMsg
		Case $Combo1
			;MsgBox(0,"Selection","You chose " & GuiCtrlRead($Combo1) & " for Combo1")
			$output = $output & @CRLF & "You chose " & GuiCtrlRead($Combo1) & "   for Question #1: "
			Switch GuiCtrlRead($Combo1)
				Case "1"
					$output = $output & @CRLF & "Since you only have one office, you do not need to set up multiple offices."
					GuiCtrlSetData($Edit1,$output)
					
				Case "2-5"
					$output = $output & @CRLF & "You should consider setting up an office for each location."
					GuiCtrlSetData($Edit1,$output)
					
				Case "6-10"
					$output = $output & @CRLF & "You should consider setting up an office for each location."
					GuiCtrlSetData($Edit1,$output)
					
				Case "10+"
					$output = $output & @CRLF & "You should consider setting up an office for each location."
					GuiCtrlSetData($Edit1,$output)
			EndSwitch
		
		    Case $Combo2
			;MsgBox(0,"Selection","You chose " & GuiCtrlRead($Combo1) & " for Combo2")
			$output = $output & @CRLF & "You chose " & GuiCtrlRead($Combo2) & "   for Question #2: "
			Switch GuiCtrlRead($Combo2)
				Case "Yes"
					$output = $output & @CRLF & "Since you have offices in more than one city or state, you should consider using regions in your organization."
					GuiCtrlSetData($Edit1,$output)
					
				Case "No"
					$output = $output & @CRLF & "You do not need to use regions in your organizational structure."
					GuiCtrlSetData($Edit1,$output)
			EndSwitch
			
			Case $Combo3
			;MsgBox(0,"Selection","You chose " & GuiCtrlRead($Combo1) & " for Combo3")
			$output = $output & @CRLF & "You chose " & GuiCtrlRead($Combo3) & "   for Question #3: "
			Switch GuiCtrlRead($Combo3)
				Case "Yes"
					$output = $output & @CRLF & "Since you have different departments setup in your firm, you should consider using multiple business units in your orginization."
					GuiCtrlSetData($Edit1,$output)
			EndSwitch
			
			Case $Combo4
			;MsgBox(0,"Selection","You chose " & GuiCtrlRead($Combo1) & " for Combo4")
			$output = $output & @CRLF & "You chose " & GuiCtrlRead($Combo4) & "   for Question #4: "
			Switch GuiCtrlRead($Combo4)
				Case "Yes"
					$output = $output & @CRLF & "Since you have people that work on specific types of returns, you should consider using business units in your orginization."
					GuiCtrlSetData($Edit1,$output)
			EndSwitch			
			
			Case $Combo5
			;MsgBox(0,"Selection","You chose " & GuiCtrlRead($Combo1) & " for Combo5")
			$output = $output & @CRLF & "You chose " & GuiCtrlRead($Combo5) & "   for Question #4: "
			Switch GuiCtrlRead($Combo5)
				Case "Yes"
					$output = $output & @CRLF & "If you need to limit access for some of your employees you should consider using security groups or client access groups. ."
					GuiCtrlSetData($Edit1,$output)
			EndSwitch	
		;reset form	
		Case $Reset
		If $nMsg = $Reset Then Resetform()
			$output = "Recomendations"
		
			
		
		Case $GUI_EVENT_CLOSE
			Exit

		EndSwitch
	WEnd


;reset form function
Func Resetform()
GuiCtrlSetData($Edit1,"")
GuiCtrlSetData($Combo1, "")
GuiCtrlSetData($Combo1,"1|2-5|6-10|10+")
GuiCtrlSetData($Combo2, "")
GuiCtrlSetData($Combo2,"Yes|No")
GuiCtrlSetData($Combo3, "")
GuiCtrlSetData($Combo3,"Yes|No")
GuiCtrlSetData($Combo4, "")
GuiCtrlSetData($Combo4,"Yes|No")
GuiCtrlSetData($Combo5, "")
GuiCtrlSetData($Combo5,"Yes|No")

EndFunc
Func Terminate()
    Exit 0
EndFunc

