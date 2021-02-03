$userou = "cn=Computers,DC=usr,DC=mydomain,DC=loc"
$user = "testuservl"
$fname = "firstname"
$lname = "lastname"
$description = "mydescription"
$UsrPassword = "mypassword**"

$oMyError = ObjEvent("AutoIt.Error", "_ADDoError") ; Install a custom error handler

Call ("CreateUser")

Func CreateUser($userou, $user, $fname, $lname, $description = "User")
;If ObjectExists($user) Then Return 0

Dim $objConnection, $objRootDSE

$objConnection = ObjCreate("ADODB.Connection") ; Create COM object to AD
$objConnection.Provider = "ADsDSOObject"
$objConnection.Open ("Active Directory Provider") ; Open connection to AD
$objRootDSE = ObjGet("LDAP://frsnadctl2.usr.ingenico.com")

$ObjOU = ObjGet("LDAP://frsnadctl2.usr.ingenico.com/" & $userou)
$cnname = "CN=" & $lname & "\, " & $fname
$ObjUser = $ObjOU.Create ("User", $cnname)

$ObjUser.Put ("sAMAccountName", $user)
$ObjUser.Put ("description", $description)
$objUser.SetPassword $UsrPassword
$ObjUser.SetInfo
Return 1
EndFunc ;==>CreateUser

Func _ADDoError()
	$HexNumber = Hex($oMyError.number, 8)

	If $HexNumber = 80020009 Then
		SetError(3)
		Return
	EndIf

	If $HexNumber = "8007203A" Then
		SetError(4)
		Return
	EndIf

	If $HexNumber = 80005000 Then
		SetError(5)
		Return
	EndIf

	MsgBox(262144, "", "We intercepted a COM Error !" & @CRLF & _
			"Number is: " & $HexNumber & @CRLF & _
			"Windescription is: " & $oMyError.windescription & @CRLF & _
			"Script Line number is: " & $oMyError.scriptline)

	Select
		Case $oMyError.windescription = "Access is denied."
			$objConnection.Close
			$objConnection.Open("Active Directory Provider")
			SetError(2)
		Case 1
			SetError(1)
	EndSelect

EndFunc   ;==>_ADDoError
