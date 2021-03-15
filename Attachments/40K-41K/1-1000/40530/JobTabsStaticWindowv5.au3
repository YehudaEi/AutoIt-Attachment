#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#region VARS

$JobUrl = ""
Global $TitleOfForm = "[CLASS:ThunderRT6FormDC]"
;Company vars
Global $Address1 = ""
Global $Address2 = ""
Global $City = ""
Global $Comment = ""
Global $Company = "Company Name"
Global $MainEmail = ""
Global $MainPhone = ""
Global $Mobile = ""
Global $State = ""
Global $Website = ""
Global $Zip = ""


#endregion VARS


#region MAIN WINDOW ### START Koda GUI section ### Form=C:\Users\Lars\Documents\Programming\JobTab\MainWindow.kxf
HotKeySet("^u", "CopyUrl")
$Form1 = GUICreate("JobTabs Automation", 584, 191, 0, 0)
$LabelUrl = GUICtrlCreateLabel("Ctrl U: Jobsite Url", 16, 10, 85, 17)
$UrlInput = GUICtrlCreateInput($JobUrl, 112, 8, 345, 21)
$Button1 = GUICtrlCreateButton("Input Employer data", 40, 48, 123, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Button2 = GUICtrlCreateButton("Input Person data", 165, 48, 123, 25)
$Button3 = GUICtrlCreateButton("Input Recruiter data", 290, 48, 123, 25)
$Button4 = GUICtrlCreateButton("Input Network Person data", 415, 48, 155, 25)
$Button6 = GUICtrlCreateButton("Fill Person form", 164, 108, 123, 25)
$Button7 = GUICtrlCreateButton("Fill Recruiter form", 289, 108, 123, 25)
$Button8 = GUICtrlCreateButton("Fill Network Person form", 414, 108, 155, 25)
$Button5 = GUICtrlCreateButton("Fill Employer form", 36, 108, 123, 25)
$Button9 = GUICtrlCreateButton("Paste Url to JT", 464, 6, 107, 25)
$Button10 = GUICtrlCreateButton("DONE", 424, 152, 75, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Button11 = GUICtrlCreateButton("CANCEL", 504, 152, 75, 25)
;GUI set
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Group1 = GUICtrlCreateGroup("Retrieve data", 32, 32, 545, 49)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Fill JobTabs forms", 32, 88, 545, 57)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
WinSetOnTop($Form1, "", 1); Mainwindow is always on top


While 1

	WinSetState($Form1, "", @SW_SHOW)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			;INPUT BUTTONS
		Case $Button1 ; Input Employer data
			WinSetState($Form1, "", @SW_HIDE)
			EmployerInput()

		Case $Button2 ; Input Person data
			InputPerson()

		Case $Button3 ; Input Recruiter data
			InputRecruiter()

		Case $Button4 ; Input Network Person data
			InputNetwork()

			;RETRIEVE BUTTONS
		Case $Button6 ; Fill Person form
			FillPerson()

		Case $Button7 ; Fill Recruiter form
			FillRecruiter()

		Case $Button8 ; Fill Network Person form
			FillNetwork()

		Case $Button5 ; Fill Employer form
			FillEmployer()

			;Url
		Case $Button9 ; Paste JobUrl
			PasteJobUrl($JobUrl)

			;Winform controls
		Case $Button10
			Exit
		Case $Button11
			Exit
	EndSwitch
WEnd

Exit
; Functions area**************************************************************

;Copy JobUrl to input
Func CopyUrl()
	Send("^c")
	$JobUrl = ClipGet()
	GUICtrlSetData($UrlInput, $JobUrl)
EndFunc   ;==>CopyUrl

Func PasteJobUrl($JobUrl)
	ControlSetText($TitleOfForm, "", "RichEdit20W1", $JobUrl) ; Send txt to form
	ControlFocus($TitleOfForm, "", "RichEdit20W1") ; Bring field to focus
	ControlSend($TitleOfForm, "", "RichEdit20W1", "{ENTER}") ; Send Press enter

EndFunc   ;==>PasteJobUrl

;Input functions ***************************************************************
Func InputEmployer()
	MsgBox(0, "EMP", "Inp", 1)
EndFunc   ;==>InputEmployer

Func InputPerson()
	MsgBox(0, "EMP", "PER", 1)
EndFunc   ;==>InputPerson

Func InputRecruiter()
	MsgBox(0, "EMP", "REC", 1)
EndFunc   ;==>InputRecruiter

Func InputNetwork()
	MsgBox(0, "EMP", "NET", 1)
EndFunc   ;==>InputNetwork

;Fill functions
Func FillEmployer()
	MsgBox(0, "Fill", "Emp", 1)
EndFunc   ;==>FillEmployer

Func FillPerson()
	MsgBox(0, "Fill", "Per", 1)
EndFunc   ;==>FillPerson

Func FillRecruiter()
	MsgBox(0, "Fill", "Rec", 1)
EndFunc   ;==>FillRecruiter

Func FillNetwork()
	MsgBox(0, "Fill", "NET", 1)
EndFunc   ;==>FillNetwork
#endregion MAIN WINDOW ### END Koda GUI section ###


#region EMPLOYER INPUT
#cs Vars
	;Global $Input1 = ""
	;Global $Input2 = ""
	Global $Input3 = ""
	Global $Input4 = ""
	Global $Input5 = ""
	Global $Input6 = ""
	Global $Input7 = ""
	Global $Input8 = ""
	Global $Edit1 = ""
	Global $Input9 = ""
	Global $Input10 = ""
	Global $ButtonNextEmp = ""
	Global $ButtonCancelEmp = ""
#ce

Func EmployerInput()
	;New GUI form ************************************************
	;Employer input area*******************************************
	#region ### START Koda GUI section ### Form=C:\Users\Lars\Documents\Programming\JobTab\JTEmployee.kxf
	$Form1_1 = GUICreate("JobTab new Company", 581, 509, 0, 0, "", "", "JobTabs Automation") ; The window opens in top left
	;Company set
	$Label1 = GUICtrlCreateLabel("Crtl 1 Company", 29, 35, 75, 17)

	;Address set
	$Label2 = GUICtrlCreateLabel("Crtl 2 Address 1", 26, 72, 78, 17)
	$Label3 = GUICtrlCreateLabel("Crlt 3 Address 2", 26, 99, 78, 17)
	$Label4 = GUICtrlCreateLabel("Crtl 4 City", 56, 137, 48, 17)
	$Label5 = GUICtrlCreateLabel("Crtl 7 Website", 34, 169, 70, 17)
	$Label6 = GUICtrlCreateLabel("Crtl 8 Comment", 29, 207, 75, 17)
	$Label1 = GUICtrlCreateLabel("Crtl 5 State", 248, 137, 56, 17)
	$Label7 = GUICtrlCreateLabel("Crtl 6 Zip", 445, 137, 46, 17)
	$Label8 = GUICtrlCreateLabel("Crtl 9 Email", 48, 313, 56, 17)
	$Label9 = GUICtrlCreateLabel("Crtl q Main", 44, 346, 60, 17)
	$Label10 = GUICtrlCreateLabel("Crtl w Mobile", 36, 379, 68, 17)


	;HotKey set area
	Local $HotKeyCompany = HotKeySet("^1")
	Local $HotKeyAddr1 = HotKeySet("^2")
	Local $HotKeyAddr2 = HotKeySet("^3")
	Local $HotKeyCity = HotKeySet("^4")
	Local $HotKeyWeb = HotKeySet("^7")
	Local $HotKeyComment = HotKeySet("^8")
	Local $HotKeyState = HotKeySet("^5")
	Local $HotKeyZip = HotKeySet("^6")
	Local $HotKeyEmailCp = HotKeySet("^9")
	Local $HotKeyMainCp = HotKeySet("^q")
	Local $HotKeyMobileCp = HotKeySet("^w")

	;Inputs Employer form
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
	$ButtonNextEmp = GUICtrlCreateButton("Next", 496, 376, 75, 25)
	$ButtonCancelEmp = GUICtrlCreateButton("Cancel", 408, 376, 75, 25)
	$Group1 = GUICtrlCreateGroup("Address", 8, 8, 569, 193)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

	;Employer form creation and control
	WinSetOnTop($Form1_1, "", 1)

	While 1
		$nMsg2 = GUIGetMsg()
		Switch $nMsg2
			Case $GUI_EVENT_CLOSE; ReSE
			Return

			Case $ButtonCancelEmp
				GUIDelete("JobTab new Company")
				Return
			Case $ButtonNextEmp
				GUISetState(@SW_HIDE)
				Return ; Return to Main Window

			Case $HotKeyAddr1
				Send("^c")
				$Address1 = ClipGet()
				GUICtrlSetData($Input2, $Address1)
			Case $HotKeyAddr2
				Send("^c")
				$Address2 = ClipGet()
				GUICtrlSetData($Input3, $Address2)

			Case $HotKeyCity
				Send("^c")
				$City = ClipGet()
				GUICtrlSetData($Input4, $City)

			Case $HotKeyWeb
				Send("^c")
				$Website = ClipGet()
				GUICtrlSetData($Input5, $Website)

			Case $HotKeyCompany
				Send("^c")
				$Company = ClipGet()
				GUICtrlSetData($Input1, $Company)


		EndSwitch
	WEnd

EndFunc   ;==>EmployerInput

Exit


#endregion EMPLOYER INPUT