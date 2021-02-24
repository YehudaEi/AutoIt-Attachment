#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=form1.kxf
$Form1_1 = GUICreate("Form1", 615, 631, 192, 124)
GUICtrlCreateInput("", 224, 32, 257, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlCreateInput("", 224, 88, 257, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Label1 = GUICtrlCreateLabel("Client Name", 128, 34, 84, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlCreateInput("", 224, 144, 257, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Label2 = GUICtrlCreateLabel("Address Line 1", 121, 90, 91, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Label3 = GUICtrlCreateLabel("Address Line 2", 121, 146, 91, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlCreateInput("", 224, 200, 257, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
GUICtrlCreateInput("", 224, 256, 257, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Label4 = GUICtrlCreateLabel("City", 185, 202, 27, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Label5 = GUICtrlCreateLabel("County", 167, 258, 45, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Input6 = GUICtrlCreateInput("", 224, 312, 129, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Label6 = GUICtrlCreateLabel("Postcode", 153, 314, 59, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Label7 = GUICtrlCreateLabel("Project Reference", 105, 361, 107, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Input1 = GUICtrlCreateInput("", 224, 359, 313, 24)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$Button1 = GUICtrlCreateButton("Copy to Word", 424, 464, 113, 65)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit


		Case $Button1
			$ClientName = GUICtrlRead($Input1)
			$AddressLine1 = GUICtrlRead($Input2)
			$AddressLine2 = GUICtrlRead($Input3)
			$City = GUICtrlRead($Input4)
			$County = GUICtrlRead($Input5)
			$Postcode = GUICtrlRead($Input6)
			$ProjectReference = GUICtrlRead($Input7)
			ShellExecute("winword")
			WinWaitActive("Microsoft Word")
			Opt("WinTitleMatchMode" , 2)
			Sleep(250)
			Send($ClientName & @CR &  $AddressLine1 & @CR &  $AddressLine2 & @CR &  $City & @CR &  $County & @CR &   $Postcode & @CR &   $ProjectReference)

	EndSwitch
WEnd
