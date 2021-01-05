;;Comments below are the VBScript coding for enumerating all users on a local machine.
;;Currently the AutoIt Script works perfectly, except for that Filter statement (line 18).
;;It prints all devices in the "Wscript.Network" object, instead of filtering it by user
;;Your help would be greatly appreciated!

#Region Enumerating Accounts
#cs
Set objNetwork = CreateObject("Wscript.Network")
strComputer = objNetwork.ComputerName
Set colAccounts = GetObject("WinNT://" & strComputer & "")
colAccounts.Filter = Array("user")
For Each objUser In colAccounts
    Wscript.Echo objUser.Name 
Next
#ce

$colAccounts = ObjGet("WinNT://" & @ComputerName)
$colAccounts.Filter "user"
MsgBox(0, "", IsArray($colAccounts))
For $objUser In $colAccounts
	MsgBox(0, "test", $objUser.Name)
Next
#endregion

#Region Reset Account Password
$objUser = ObjGet("WinNT://" & @ComputerName & "/Administrator, user")
$objUser.SetPassword "testpassword"
$objUser.SetInfo
#EndRegion

#Region Configure No Expiration Account
;;Test the $objUserFlags ObjGet() function

Const $ADS_UF_DONT_EXPIRE_PASSWD = &h10000

$objUser = ObjGet("WinNT:// " & @ComputerName & "/Administrator ")
$objUserFlags = ObjGet("",$objUser & ".UserFlags")
$objPasswordExpirationFlag = $objUserFlags OR $ADS_UF_DONT_EXPIRE_PASSWD
$objUser.Put "userFlags", $objPasswordExpirationFlag 
$objUser.SetInfo
#endregion

#Region Configure No Expiration Password
Const $ADS_UF_DONT_EXPIRE_PASSWD = &h10000
$strUser = "KenMeyer"
 
$objUser = ObjGet("WinNT://" & @LogonDomain & "/" & @ComputerName & "/" & $strUser & ",User")
 
$objUserFlags = ObjGet($objUser & ".UserFlags")
$objPasswordExpirationFlag = $objUserFlags OR $ADS_UF_DONT_EXPIRE_PASSWD
$objUser.Put "userFlags", $objPasswordExpirationFlag 
$objUser.SetInfo
#endregion

#Region Create Local Account
$colAccounts = ObjGet("WinNT://" & @ComputerName)
$objUser = $colAccounts.Create("user", "Admin2")
$objUser.SetPassword "test"
$objUser.SetInfo
#endregion

#Region Delete Local Account
$strUser = "Admin2"
$objComputer = ObjGet("WinNT://" & @ComputerName)
$objComputer.Delete "user", $strUser
#endregion

#region disable local user account
$objUser = ObjGet("WinNT://" & @ComputerName & "/Guest")
$objUser.AccountDisabled = True
$objUser.SetInfo
#endregion

#region Force Password Change
$objUser = ObjGet("WinNT:// " & @ComputerName & "/kenmyer ")
$objUser.Put "PasswordExpired", 1
$objUser.SetInfo
#endregion