#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;JobUrl
Global $JobUrl = ""
Global $Company = ""
;Company vars
Global $Address1 = ""
Global $Address2 = " "
Global $City = " "
Global $Comment = " "
Global $Company = " "
Global $MainEmail = " "
Global $MainPhone = " "
Global $Mobile = " "
Global $State = " "
Global $Website = " "
Global $Zip = " "

;Person Vars
Global $FirstName = " "
Global $LastName = " "
Global $Title = " "
Global $PersonComment = " "
Global $PersMobile = " "
Global $PersMain = " "
Global $PersEmail = " "





	#region ### START Koda GUI section ### Form=C:\Users\Lars\Documents\Programming\JobTab\JTEmployee.kxf
	$Form1_1 = GUICreate("JobTab new Company", 581, 409, 401, 155)
	;Company set
	$Label1 = GUICtrlCreateLabel("Crtl 1 Company", 29, 35, 75, 17)
	HotKeySet("^1", "companyCp")
	;Address set
	$Label2 = GUICtrlCreateLabel("Crtl 2 Address 1", 26, 72, 78, 17)
	$Label3 = GUICtrlCreateLabel("Crlt 3 Address 2", 26, 99, 78, 17)
	$Label4 = GUICtrlCreateLabel("Crtl 4 City", 56, 137, 48, 17)
	HotKeySet("^2", "address1Cp")
	HotKeySet("^3", "address2Cp")
	HotKeySet("^4", "cityCp")

	;Rest set
	$Label5 = GUICtrlCreateLabel("Crtl 7 Website", 34, 169, 70, 17)
	$Label6 = GUICtrlCreateLabel("Crtl 8 Comment", 29, 207, 75, 17)
	$Label1 = GUICtrlCreateLabel("Crtl 5 State", 248, 137, 56, 17)
	$Label7 = GUICtrlCreateLabel("Crtl 6 Zip", 445, 137, 46, 17)
	$Label8 = GUICtrlCreateLabel("Crtl 9 Email", 48, 313, 56, 17)
	$Label9 = GUICtrlCreateLabel("Crtl q Main", 44, 346, 60, 17)
	$Label10 = GUICtrlCreateLabel("Crtl w Mobile", 36, 379, 68, 17)
	HotKeySet("^7", "websiteCp")
	;HotKeySet ("^8" , "commentCp") OPRET FUNC
	;HotKeySet ("^5" , "stateCp") OPRET FUNC
	;HotKeySet ("^6" , "zipCp") OPRET FUNC
	;HotKeySet ("^9" , "emailCp") OPRET FUNC
	;HotKeySet ("^q" , "mainCp") OPRET FUNC
	;HotKeySet ("^w" , "mobileCp") OPRET FUNC


	$Input1 = GUICtrlCreateInput($Company, 117, 31, 193, 21)
	$Input2 = GUICtrlCreateInput($Address1, 117, 68, 193, 21)
	$Input3 = GUICtrlCreateInput($Address2, 117, 102, 193, 21)
	$Input4 = GUICtrlCreateInput($City, 117, 133, 121, 21)
	$Input5 = GUICtrlCreateInput($Website, 117, 167, 193, 21)
	$Input6 = GUICtrlCreateInput($MainEmail, 117, 308, 193, 21)
	$Input7 = GUICtrlCreateInput($State, 309, 133, 121, 21)
	$Input8 = GUICtrlCreateInput($Zip, 498, 133, 73, 21)
	$Edit1 = GUICtrlCreateEdit("", 117, 208, 449, 89)
	GUICtrlSetData(-1, $Comment)
	$Input9 = GUICtrlCreateInput($MainPhone, 117, 341, 193, 21)
	$Input10 = GUICtrlCreateInput($Mobile, 117, 374, 193, 21)

	$ButtonNextEmploy = GUICtrlCreateButton("Next", 496, 376, 75, 25)
	$ButtonCanselEmploy = GUICtrlCreateButton("Cancel", 408, 376, 75, 25)
	$Group1 = GUICtrlCreateGroup("Address", 8, 8, 569, 193)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

#region ## Functions
	WinSetOnTop($Form1_1, "", 1)
	Func companyCp()
		Send("^c")
		$Company = ClipGet()
		GUICtrlSetData($Input1, $Company)

	EndFunc   ;==>companyCp

	Func address1Cp()
		Send("^c")
		$Address1 = ClipGet()
		GUICtrlSetData($Input2, $Address1)

	EndFunc   ;==>address1Cp
	Func address2Cp()
		Send("^c")
		$Address2 = ClipGet()
		GUICtrlSetData($Input3, $Address2)

	EndFunc   ;==>address2Cp
	Func cityCp()
		Send("^c")
		$City = ClipGet()
		GUICtrlSetData($Input4, $City)

	EndFunc   ;==>cityCp
	Func websiteCp()
		Send("^c")
		$Website = ClipGet()
		GUICtrlSetData($Input5, $Website)

	EndFunc   ;==>websiteCp


	#endregion ## Functions
	OpenForm()
Func OpenForm()
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $ButtonCanselEmploy
				Exit

		EndSwitch
	WEnd
EndFunc
