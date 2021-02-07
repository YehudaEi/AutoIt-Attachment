#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#include <Word.au3>
#Include <GuiButton.au3>
#include <IE.au3>


AutoItSetOption("GUICloseOnESC", 0)

$Form = GUICreate("Record Time", 400, 310,-1,-1)
Local $oIE = _IECreateEmbedded()
$oDoc = "Server have a problem."

Global $iMemo = GUICtrlCreateObj($oIE, 10, 110, 380,180, 0)
GUICtrlSetFont(-1, 11.5, 600)

$Checkbox1 = GUICtrlCreateCheckbox("Incident", 10, 10)
GUICtrlSetTip(-1,"Server have a problem")

$Checkbox2 = GUICtrlCreateCheckbox("Troubleshooting", 90, 10)
GUICtrlSetTip(-1,"SE is troubleshooting an incident")

$Checkbox3 = GUICtrlCreateCheckbox("Resolved", 200, 10)
GUICtrlSetTip(-1,"Incident is resovled by SE")

$record = GUICtrlCreateButton("Record",10,60,80,40)

GUICtrlSetFont(-1, 11.5, 600)

$server = GUICtrlCreateCombo("",330,5,60,20)
GUICtrlSetData($server,"Server1|Server2|Server3|Server4")

GUISetState(@SW_SHOW)

$Checked_State = False

While 1
  	If BitAnd(GUICtrlRead($Checkbox1),$GUI_CHECKED) <> $Checked_State Then
       	$Checked_State = Not $Checked_State
			If BitAnd(GUICtrlRead($Checkbox1),$GUI_CHECKED) = $GUI_CHECKED  Then
				_filewritelog("D:/Server1/Time_Log.htm",$oDoc)
				_IENavigate($oIE, "file:///D:/Server1/Time_Log.htm")
	
			EndIf
	EndIf
				
 $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE

        Exit
    EndSwitch
WEnd
	

