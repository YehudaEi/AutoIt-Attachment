#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=e:\Documents\scripts\Powertools\power tools.kxf
$Form1_1 = GUICreate("Power Tools", 569, 453, 189, 128)
$PageControl1 = GUICtrlCreateTab(8, 8, 556, 440, $TCS_FIXEDWIDTH)
GUICtrlSetFont(-1, 10, 400, 0, "Berlin Sans FB")
$adminfuncs = GUICtrlCreateTabItem("Admin Functions")
$userid = GUICtrlCreateInput("", 160, 41, 81, 23)
GUICtrlSetFont(-1, 10, 400, 0, "Berlin Sans FB")
$Shadow = GUICtrlCreateButton("Shadow Machine", 368, 81, 179, 45)
GUICtrlSetFont(-1, 16, 400, 0, "Calibri")
$Compname = GUICtrlCreateLabel("Computer Name = ", 24, 73, 129, 22)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$compnme = GUICtrlCreateInput("", 160, 73, 121, 20)
GUICtrlSetFont(-1, 7, 400, 0, "Arial")
$IPaddy = GUICtrlCreateLabel("IP Address = ", 64, 105, 88, 22)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$ipadd = GUICtrlCreateInput("", 160, 105, 121, 20)
GUICtrlSetFont(-1, 7, 400, 0, "Arial")
$Search = GUICtrlCreateButton("Search", 72, 41, 83, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$Progress1 = GUICtrlCreateProgress(248, 41, 302, 25)
$currentlogon = GUICtrlCreateGroup("Current logons", 24, 144, 249, 241)
GUICtrlSetFont(-1, 10, 400, 0, "Berlin Sans FB")
$current = GUICtrlCreateList("", 32, 168, 233, 201)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$lastlogon = GUICtrlCreateGroup("Last logons", 288, 144, 257, 241)
GUICtrlSetFont(-1, 10, 400, 0, "Berlin Sans FB")
$last = GUICtrlCreateList("", 296, 168, 241, 201)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$compinfo = GUICtrlCreateTabItem("Computer Mgmt")
$gpupdate = GUICtrlCreateButton("GPUpdate", 24, 65, 115, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$Cachedel = GUICtrlCreateButton("Delete cache", 24, 97, 115, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$Pskillie = GUICtrlCreateButton("Pskill Internet Explore", 24, 129, 155, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$Pskillsales = GUICtrlCreateButton("Pskill Salesforce Cti", 24, 161, 155, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$DriveC = GUICtrlCreateButton("C$ Drive", 216, 65, 91, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$System = GUICtrlCreateButton("System Info", 216, 97, 91, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Berlin Sans FB")
$loggroups = GUICtrlCreateGroup("Logs & Profiles", 320, 40, 233, 161)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$computermgmt = GUICtrlCreateGroup("Computer Mgmt", 16, 40, 297, 161)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$useradmin = GUICtrlCreateTabItem("User Admin")
$acctunlock = GUICtrlCreateButton("Account Unlock", 24, 56, 131, 25)
$useradm = GUICtrlCreateGroup("User Admin", 16, 40, 209, 169)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$Close = GUICtrlCreateButton("&Close", 182, 416, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Berlin Sans FB")
$Help = GUICtrlCreateButton("&Help", 320, 416, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Berlin Sans FB")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Pskillie
			ShellExecuteWait("iekill.vbs")

		Case $System
			ShellExecuteWait("systeminfo.vbs")

		Case $Close
			Exit


	Case $Cachedel
		ShellExecuteWait("iecachedel.vbs")


		Case $gpupdate
			ShellExecuteWait("gpupdate.vbs")


		Case $acctunlock
			ShellExecuteWait ( "unlock.vbs" )


		Case $Help

			;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
			MsgBox(64,"Powerscript Help","This tool was created by John Bernard" & @CRLF & "Using Auto IT Script" & @CRLF & "http://www.autoitscript.com" & @CRLF & "Ver 0.01")

	EndSwitch
WEnd










