#include <Register.au3>
#include <GUIConstants.au3>

$RegisterWindow = GUICreate("Register Example", 420, 215, -1, -1)
$RegisterOK = GUICtrlCreateButton("OK", 90, 175, 100, 30)
$RegisterCancel = GUICtrlCreateButton("Cancel", 210, 175, 100, 30)
$RegisterTab = GUICtrlCreateTab(10, 10, 400, 160)

GUICtrlCreateTabItem("Order")
GUICtrlCreateLabel("Name:", 30, 63, 80, 15)
$NameInput = GUICtrlCreateInput("", 140, 60, 250, 20)
GUICtrlCreateLabel("E-mail:", 30, 93, 100, 15)
$EmailInput = GUICtrlCreateInput("", 140, 90, 250, 20)
GUICtrlCreateLabel("Verification number:", 30, 123, 100, 15)
$NumberInput = GUICtrlCreateInput("", 140, 120, 250, 20, $ES_READONLY)

GUICtrlCreateTabItem("Enter the code")
GUICtrlCreateLabel("Name:", 30, 63, 80, 15)
$NameInput2 = GUICtrlCreateInput("", 140, 60, 250, 20)
GUICtrlCreateLabel("E-mail:", 30, 93, 100, 15)
$EmailInput2 = GUICtrlCreateInput("", 140, 90, 250, 20)
GUICtrlCreateLabel("Register code:", 30, 123, 100, 15)
$NumberImput2 = GUICtrlCreateInput("", 140, 120, 250, 20, BitOR($ES_NOHIDESEL, $ES_NUMBER))
GUICtrlSetLimit($NumberImput2, 23, 0)

GUICtrlCreateTabItem("Code generator(HIDE THIS ONE)")
GuiCtrlCreateLabel("Name:", 20, 43, 100, 20)
$NameInput3 = GuiCtrlCreateInput("", 130, 40, 270, 20)
GuiCtrlCreateLabel("E-mail:", 20, 73, 100, 20)
$EmailInput3 = GuiCtrlCreateInput("", 130, 70, 270, 20)
GuiCtrlCreateLabel("Verification number:", 20, 103, 100, 20)
$NumberInput3 = GuiCtrlCreateInput("", 130, 100, 200, 20)
GuiCtrlCreateLabel("Register code:", 20, 133, 100, 20, $ES_READONLY)
$FinalInput = GuiCtrlCreateInput("", 130, 130, 200, 20)
$OK = GuiCtrlCreateButton("Generate", 340, 100, 60, 30)
$Copy = GuiCtrlCreateButton("Copy", 340, 130, 60, 20)

GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $RegisterCancel
			ExitLoop
		Case $msg = $RegisterOK
			If GUICtrlRead($RegisterTab) = 0 Then
				$Name = GUICtrlRead($NameInput)
				$Mail = GUICtrlRead($EmailInput)
				GUICtrlSetData($NumberInput, OrderRegister($Name, $Mail))
			ElseIf GUICtrlRead($RegisterTab) = 1 Then
				$Name = GUICtrlRead($NameInput2)
				$Mail = GUICtrlRead($EmailInput2)
				$Number = GUICtrlRead($NumberImput2)
				$Check = RegisterProduct("Register Example", $Name, $Mail, $Number)
				If $Check = True Then
					MsgBox(0, "Register Example", "The register was successful!")
				Else
					If @error = 1 Then
						MsgBox(0, "Register Example", "Please fill all the fields.")
					Else
						MsgBox(0, "Register Example", "Invalid register code.")
					EndIf
				EndIf	
			ElseIf GUICtrlRead($RegisterTab) = 2 Then
				MsgBox(0, "Register Example", "This button is deactivated for maintenance")
			EndIf
		Case $msg = $OK
			$Name = GUICtrlRead($NameInput3)
			$Mail = GUICtrlRead($EmailInput3)
			$Number = GUICtrlRead($NumberInput3)
			GUICtrlSetData($FinalInput, RegisterGenerate($Name, $Mail, $Number))
		Case $msg = $Copy
			ClipPut(GUICtrlRead($FinalInput))
	EndSelect
WEnd

RegDelete("HKEY_CURRENT_USER\Software\Register Example")

Exit
