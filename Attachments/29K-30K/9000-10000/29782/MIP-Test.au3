Opt("WinTitleMatchMode", 4)
AutoItSetOption("SendKeyDelay", 60)
	
	$CustNo = "0"
	$accNo = "1234567890"	
	$CustName = "WILLIAM WONG"
	$HKID = "K298953"
	$CurBal = 123.45
	$CycleDue = 6
	$Block = "Z"
	$Remark = "W"
	$BankRuptcy = "B123/2012"
	$Status = "BB"
	$McclSup = " "
	$Pdate = "12/31/2010"
	$Hdate = "01/05/2012"
	$text = "{TAB}" & $CustName & "{TAB}" & $HKID & "{TAB}" & $CurBal & "{TAB}" & $CycleDue & "{TAB}" & $Block & "{TAB 2}" & $Remark & "{TAB}" & $BankRuptcy & "{TAB}" & $Status & "{TAB}" & $Pdate & "{TAB}" & $McclSup & "{TAB}" & $Hdate & "^{HOME}"

WinWait("MIP Front End Application System","Bankruptcy/IVA")
ControlClick("MIP Front End Application System","Bankruptcy/IVA","Button4")		
WinWait("Add new account","Please enter New account Numbe")
ControlSend("Add new account", "Please enter New account Numbe", "Edit1", $accNo)
Sleep(1000)
ControlClick("Add new account","Please enter New account Numbe","Button3")		

			WinWait("System Message", "Account Not found in Collectio", 5) Then
			ControlClick("System Message", "Account Not found in Collectio", "Button1")
					
			ControlSend("MIP Front End Application System", "Bankruptcy/IVA", "pbdw902", $text)
			Sleep(1000)