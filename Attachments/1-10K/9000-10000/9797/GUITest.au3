#include <GuiConstants.au3>

;Declarations Here ===========================================================================

Global $Agency, $OCFS, $OFT
Global $Farmname, $8837, $M8837
Global $MetaframeFarm, $Prod, $Test
Global $ReImageY, $ReImageN
Global $Input_ServerName
Global $Input_DomainName
Global $Input_AdminName
Global $Input_AdminPassword
Global $BackupYes, $BackupNo
Global $Input_PrimaryIPOct1, $Input_PrimaryIPOct2, $Input_PrimaryIPOct3, $Input_PrimaryIPOct4
Global $Input_PMaskOct1, $Input_PMaskOct2, $Input_PMaskOct3, $Input_PMaskOct4
Global $Input_PrimaryGWOct1, $Input_PrimaryGWOct2, $Input_PrimaryGWOct3, $Input_PrimaryGWOct4
Global $Input_AdminIPOct1, $Input_AdminIPOct2, $Input_AdminIPOct3, $Input_AdminIPOct4
Global $Input_BackupIPOct1, $Input_BackupIPOct2, $Input_BackupIPOct3, $Input_BackupIPOct4
Global $OKtoContinue

;==============================================================================================
; Note:  I had to declare all my variables explicitly as global so that they would pass from
; one function to another.
;
;==============================================================================================

;Main Body=====================================================================================

$OKtoContinue = 1	; Set this tag variable for later.

While $OKtoContinue > 0
	MakeWindow()		; Run the function that creates the window.
Wend

CheckDataEntries()

If $OKtoContinue = 0 Then
	WriteDatatoReg()
EndIf



;==============================================================================================

Func MakeWindow()

	GuiCreate("Citrix Server System Setup GUI",500, 700)

	$ServerName = GuiCtrlCreateLabel("Server Name", 5, 5, 175, 18)
	$Input_ServerName = GuiCtrlCreateInput("", 95, 5, 100, 18, $ES_UPPERCASE)

	$DomainName = GuiCtrlCreateLabel("Domain Name", 5, 35, 175, 18)
	$Input_DomainName = GuiCtrlCreateInput("", 95, 35, 100, 18, $ES_UPPERCASE)

	$AdminName = GUICtrlCreateLabel("Admin Name", 5, 65, 175, 18)
	$Input_AdminName = GUICtrlCreateInput("", 95, 65, 100, 18, $ES_UPPERCASE)

	$AdminPassword = GUICtrlCreateLabel("Admin Password", 5, 95, 175, 18)
	$Input_AdminPassword = GUICtrlCreateInput("", 95, 95, 100, 18, $ES_PASSWORD)

	$PrimaryIP = GUICtrlCreateLabel("Primary IP", 5, 125, 175, 18)
	$Input_PrimaryIPOct1 = GUICtrlCreateInput("", 95, 125, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot1 = GUICtrlCreateLabel(".", 130, 125, 10, 18)
	$Input_PrimaryIPOct2 = GUICtrlCreateInput("", 135, 125, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot2 = GUICtrlCreateLabel(".", 170, 125, 10, 18)
	$Input_PrimaryIPOct3 = GUICtrlCreateInput("", 175, 125, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot3 = GUICtrlCreateLabel(".", 210, 125, 10, 18)
	$Input_PrimaryIPOct4 = GUICtrlCreateInput("", 215, 125, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)

	$PrimaryMask = GUICtrlCreateLabel("Subnet Mask", 5, 155, 175, 18)
	$Input_PMaskOct1 = GUICtrlCreateInput("", 95, 155, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot1 = GUICtrlCreateLabel(".", 130, 155, 10, 18)
	$Input_PMaskOct2 = GUICtrlCreateInput("", 135, 155, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot2 = GUICtrlCreateLabel(".", 170, 155, 10, 18)
	$Input_PMaskOct3 = GUICtrlCreateInput("", 175, 155, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot3 = GUICtrlCreateLabel(".", 210, 155, 10, 18)
	$Input_PMaskOct4 = GUICtrlCreateInput("", 215, 155, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)

	$PrimaryGW = GUICtrlCreateLabel("Primary Gateway", 5, 185, 175, 18)
	$Input_PrimaryGWOct1 = GUICtrlCreateInput("", 95, 185, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot1 = GUICtrlCreateLabel(".", 130, 185, 10, 18)
	$Input_PrimaryGWOct2 = GUICtrlCreateInput("", 135, 185, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot2 = GUICtrlCreateLabel(".", 170, 185, 10, 18)
	$Input_PrimaryGWOct3 = GUICtrlCreateInput("", 175, 185, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot3 = GUICtrlCreateLabel(".", 210, 185, 10, 18)
	$Input_PrimaryGWOct4 = GUICtrlCreateInput("", 215, 185, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)

	$AdminIP = GUICtrlCreateLabel("Admin LAN IP", 5, 215, 175, 18)
	$Input_AdminIPOct1 = GUICtrlCreateInput("", 95, 215, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot1 = GUICtrlCreateLabel(".", 130, 215, 10, 18)
	$Input_AdminIPOct2 = GUICtrlCreateInput("", 135, 215, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot2 = GUICtrlCreateLabel(".", 170, 215, 10, 18)
	$Input_AdminIPOct3 = GUICtrlCreateInput("", 175, 215, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot3 = GUICtrlCreateLabel(".", 210, 215, 10, 18)
	$Input_AdminIPOct4 = GUICtrlCreateInput("", 215, 215, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)

	$AdminIP = GUICtrlCreateLabel("Backup LAN IP", 5, 245, 175, 18)
	$Input_BackupIPOct1 = GUICtrlCreateInput("", 95, 245, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot1 = GUICtrlCreateLabel(".", 130, 245, 10, 18)
	$Input_BackupIPOct2 = GUICtrlCreateInput("", 135, 245, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot2 = GUICtrlCreateLabel(".", 170, 245, 10, 18)
	$Input_BackupIPOct3 = GUICtrlCreateInput("", 175, 245, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)
	$Dot3 = GUICtrlCreateLabel(".", 210, 245, 10, 18)
	$Input_BackupIPOct4 = GUICtrlCreateInput("", 215, 245, 30, 18, $ES_NUMBER)
	GUICtrlSetLimit(-1,3)

	GuiCtrlCreateGroup("Backup LAN Connected?", 5, 275, 150, 50)
	$BackupYes = GUICtrlCreateRadio("Yes", 10, 300)
	$BackupNo = GUICtrlCreateRadio("No", 75, 300)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GuiCtrlCreateGroup("Agency", 5, 420, 100, 100)
	$OCFS = GuiCtrlCreateRadio("OCFS", 10, 460)
	$OFT = GuiCtrlCreateRadio("OFT", 10, 490)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GuiCtrlCreateGroup("Prod/Test", 105, 420, 100, 100)
	$Prod = GuiCtrlCreateRadio("Prod", 110, 460)
	$Test = GuiCtrlCreateRadio("Test", 110, 490)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GuiCtrlCreateGroup("Model Type", 205, 420, 100, 100)
	$8837 = GuiCtrlCreateRadio("8837", 210, 460)
	$M8837 = GuiCtrlCreateRadio("M8837", 210, 490)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GuiCtrlCreateGroup("Re-Image?", 305, 420, 100, 100)
	$ReimageY = GuiCtrlCreateRadio("Yes", 310, 460)
	$ReimageN = GuiCtrlCreateRadio("No", 310, 490)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	$SubmitButton = GUICtrlCreateButton ("Submit", 25, 660, 70,20)

	GuiSetState()
		While 1
    		$msg = GuiGetMsg()
		If $msg = $Submitbutton Then ExitLoop
;    		Select
;			Case $msg = $SubmitButton
;				ExitLoop
;    			Case Else
;    		;;;
;    		EndSelect
		WEnd
			
EndFunc

;==============================================================================================

Func CheckDataEntries()

	;Check for Entries for server name, admin name, and domain.

	$OKtoContinue = 0

	If GUICtrlRead($Input_ServerName) = "" Then $OKtoContinue = 1
	If GUICtrlRead($Input_DomainName) = "" Then $OKtoContinue = 1
	If GUICtrlRead($Input_AdminName) = "" Then $OKtoContinue = 1

	;Check IP Address Validity.

	If GUICtrlRead($Input_PrimaryIPOct1) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct1) < 1 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct1) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PrimaryIPOct2) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct2) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct2) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PrimaryIPOct3) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct3) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct3) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PrimaryIPOct4) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct4) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryIPOct4) > 255 Then $OKtoContinue = 2



	If GUICtrlRead($Input_PrimaryGWOct1) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct1) < 1 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct1) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PrimaryGWOct2) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct2) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct2) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PrimaryGWOct3) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct3) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct3) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PrimaryGWOct4) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct4) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PrimaryGWOct4) > 255 Then $OKtoContinue = 2



	If GUICtrlRead($Input_PMaskOct1) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct1) < 1 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct1) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PMaskOct2) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct2) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct2) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PMaskOct3) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct3) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct3) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_PMaskOct4) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct4) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_PMaskOct4) > 255 Then $OKtoContinue = 2



	If GUICtrlRead($Input_AdminIPOct1) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct1) < 1 Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct1) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_AdminIPOct2) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct2) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct2) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_AdminIPOct3) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct3) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct3) > 255 Then $OKtoContinue = 2

	If GUICtrlRead($Input_AdminIPOct4) = "" Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct4) < 0 Then $OKtoContinue = 2
	If GUICtrlRead($Input_AdminIPOct4) > 255 Then $OKtoContinue = 2


	If GUICtrlRead($BackupYes) = $GUI_CHECKED Then
		If GUICtrlRead($Input_BackupIPOct1) = "" Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct1) < 1 Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct1) > 255 Then $OKtoContinue = 2

		If GUICtrlRead($Input_BackupIPOct2) = "" Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct2) < 0 Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct2) > 255 Then $OKtoContinue = 2

		If GUICtrlRead($Input_BackupIPOct3) = "" Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct3) < 0 Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct3) > 255 Then $OKtoContinue = 2

		If GUICtrlRead($Input_BackupIPOct4) = "" Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct4) < 0 Then $OKtoContinue = 2
		If GUICtrlRead($Input_BackupIPOct4) > 255 Then $OKtoContinue = 2
	EndIf
	

	Select
		Case $OKtoContinue = 0 
			WriteDatatoReg()
		Case $OKtoContinue = 1
			SplashTextOn("Wups!", "You must enter something for Server Name, Domain, and Admin Account.", 500, 50)
			Sleep(5000)
			SplashOff()
		Case $OKtoContinue = 2
			SplashTextOn("Wups!", "There's a bogus IP in there!", 200, 50)
			Sleep(5000)
			SplashOff()
	EndSelect
	
	
EndFunc
	
;==============================================================================================

Func WriteDatatoReg()

	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CCS", "Servername", "REG_SZ", GUICtrlRead($Input_ServerName))
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\CCS", "Domain", "REG_SZ", GUICtrlRead($Input_DomainName))
	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "AdminName", "REG_SZ", GUICtrlRead($Input_AdminName))
	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "AdminPW", "REG_SZ", GUICtrlRead($Input_AdminPassword))

	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "PrimaryIP", "REG_SZ", GUICtrlRead($Input_PrimaryIPOct1) & "." & GUICtrlRead($Input_PrimaryIPOct2) & "." & GUICtrlRead($Input_PrimaryIPOct3) & "." & GUICtrlRead($Input_PrimaryIPOct4))
	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "SubnetMask", "REG_SZ", GUICtrlRead($Input_PMaskOct1) & "." & GUICtrlRead($Input_PMaskOct2) & "." & GUICtrlRead($Input_PMaskOct3) & "." & GUICtrlRead($Input_PMaskOct4))
	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "GatewayIP", "REG_SZ", GUICtrlRead($Input_PrimaryGWOct1) & "." & GUICtrlRead($Input_PrimaryGWOct2) & "." & GUICtrlRead($Input_PrimaryGWOct3) & "." & GUICtrlRead($Input_PrimaryGWOct4))
	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "AdminLAN", "REG_SZ", GUICtrlRead($Input_AdminIPOct1) & "." & GUICtrlRead($Input_AdminIPOct2) & "." & GUICtrlRead($Input_AdminIPOct3) & "." & GUICtrlRead($Input_AdminIPOct4))
	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "AdminSM", "REG_SZ", "255.255.252.0")
		
	Select 
		Case GUICtrlRead($BackupYes) = $GUI_CHECKED
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "BackupYesNo", "REG_SZ", "Yes")
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "BackupLAN", "REG_SZ", GUICtrlRead($Input_BackupIPOct1) & "." & GUICtrlRead($Input_BackupIPOct2) & "." & GUICtrlRead($Input_BackupIPOct3) & "." & GUICtrlRead($Input_BackupIPOct4))
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "BackupSubnetMask", "REG_SZ", "255.255.252.0")
		Case GUICtrlRead($BackupNo) = $GUI_CHECKED
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "BackupYesNo", "REG_SZ", "No")
	EndSelect

	;Agency
	Select
		Case GUICtrlRead($OCFS) = $GUI_CHECKED
			$Agency = "OCFS"
		Case GUICtrlRead($OFT) = $GUI_CHECKED
			$Agency = "OFT"
	EndSelect

	;Prod or Test
	Select
		Case GUICtrlRead($Prod) = $GUI_CHECKED
			$Farmname = "PROD"
		Case GUICtrlRead($TEST) = $GUI_CHECKED
			$Farmname = "TEST"
	EndSelect 
	
	$MetaframeFarm = $Agency & $Farmname
	RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "Metaframe Farm", "REG_SZ", $MetaframeFarm)

	;Model Type
	Select
		Case GUICtrlRead($8837) = $GUI_CHECKED
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "ModelType", "REG_SZ", "8837")
		Case GUICtrlRead($M8837) = $GUI_CHECKED
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "ModelType", "REG_SZ", "M8837")
	EndSelect

	;Re-Imaged Box
	Select
		Case GUICtrlRead($ReimageY) = $GUI_CHECKED
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "ReImage", "REG_SZ", "Yes")
		Case GUICtrlRead($ReimageN) = $GUI_CHECKED
			RegWrite("HKEY_LOCAL_MACHINE\Software\CCS", "ReImage", "REG_SZ", "No")
	EndSelect

EndFunc

