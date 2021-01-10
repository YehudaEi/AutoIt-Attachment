#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:       Dale Massey

 Script Function:
	To Help me kkep up with what I spend

#ce ----------------------------------------------------------------------------

#include <GUIConstants.au3>
#include <File.au3>

Dim $tUser= @UserName
Dim $font   = "Comic Sans MS"
Dim $Amt
Dim $Where
Dim $What
Dim $Log = "AcctLog.txt"
Dim $Cash
Dim $Debit
Dim $Charge
Dim $Currency
Dim $msg
Dim $RadioMSG

Opt("GUIOnEventMode", 1)		; Change to OnEvent mode


Func CLOSEClicked ()
		Exit
EndFunc



GUICreate("What I spent",215, 250,350,90)  ; will create a dialog box that when displayed is centered
GUISetBkColor (0x5CACEE);sets the background color of the window
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState (@SW_SHOW)       ; will display an empty dialog box

;---------------------------------------------------------------------------------------------------------
GUICtrlCreateLabel("Amount spent",20,30,650,20)
GUICtrlSetFont(-1,12,17,4,$font)
$Amt = GUICtrlCreateInput("$", 30,60,50,20)

;---------------------------------------------------------------------------------------------------------
GUICtrlCreateGroup("Currency",140,25,60,100 )
$Cash = GUICtrlCreateRadio("Cash", 140,45,50,20)
$Debit = GUICtrlCreateRadio("Debit", 140,65,50,20)
$Charge = GUICtrlCreateRadio("Charge", 140,85,55,20)
GUICtrlSetState($Debit, $Gui_CHECKED)
;---------------------------------------------------------------------------------------------------------
GUICtrlCreateLabel("Where",20,90,50,20)
GUICtrlSetFont(-1,12,17,4,$font)
$Where = GUICtrlCreateInput("", 30,110,100,20)
;---------------------------------------------------------------------------------------------------------
GUICtrlCreateLabel("What did you buy?", 20, 140, 50,20)
GUICtrlSetFont(-1,12,17,4,$font)
$What = GUICtrlCreateInput("", 30,160,100,20)
;---------------------------------------------------------------------------------------------------------

;---------------------------------------------------------------------------------------------------------

$Addto = GUICtrlCreateButton("Add to Log", 65, 220, 70)
GuiCtrlSetOnEvent($Addto, "WRITElog")

GUISetState(@SW_SHOW)




;---------------------------------------------------------------------------------------------------------
Func WRITElog() 
	
;Read the radio boxes to see which one is checked		
If	 GUICtrlRead ($Cash) = $Gui_CHECKED Then
		$RadioMSG = "Cash"
		 
	ElseIf GUICtrlRead ($Debit) = $Gui_CHECKED Then
		$RadioMSG = "Debit"
	
	ElseIf GUICtrlRead ($Charge) = $Gui_CHECKED Then
		$RadioMSG = "Credit Card"	
EndIf


	$rAmt = GUICtrlRead ($Amt)
	$rWhere = GUICtrlRead ($Where)
	$rWhat = GUICtrlRead ($What)
	_FileWriteLog(@DesktopDir & "\" & $Log, $rAmt & "      " & $rWhere & "    " & $rWhat  & "                 " & $RadioMSG) 
	ControlSetText("What I spent", "", "Edit1" ,"$")
	ControlSetText("What I spent", "", "Edit2" ,"")
	ControlSetText("What I spent", "", "Edit3" ,"")
	
EndFunc
	



While 1
	Sleep(1000)		; Mainline will just idle around until an event happens.
WEnd
