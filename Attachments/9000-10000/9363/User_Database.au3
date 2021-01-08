opt("RunErrorsFatal", 0)
$oMyError = ObjEvent("AutoIt.Error", "COMErrFunc")


$sqlCon = ObjCreate("ADODB.Connection")
$sqlCon.Open("Provider=SQLOLEDB;Server=QAHDCOMM;Trusted_Connection=yes;")
;~ _UpdateUser("UserName", "10", "Everyone, Technical") ;This is used to modify the information on a current user
;~ _ViewAllUsers() ;This will display all users/groups one at a time in a message box
;~ _DeleteUser("UserName") ;This will delete a user/group from the database
;~ _AddUser("UserName", "10", "") ;This will add the specified user/group to the database
$sqlCon.close

Func _DeleteUser($DelUser)
$sqlCon.Execute("Delete From HDcommUsers where UserName = '" & $DelUser & "'")
if not @error Then
	MsgBox(0, "Finished", $DelUser & " Was successfully deleted")
	return 1
Else
	MsgBox(0, "Error", "Unable to delete " & $DelUser)
	Return 0
EndIf
EndFunc


Func _ViewAllUsers()
$sqlRs = ObjCreate ("ADODB.Recordset")
if not @error Then
	$sqlRS.open("Select * From HDcommUsers", $sqlCon)
	if not @error Then
		With $sqlRS
			;If there are records found then continue
			If .RecordCount Then
				;Loop until the end of file
				While Not .EOF
					;Retrieve data from the following fields
					$UserName = .Fields('UserName').Value
					$DisplayCount = .Fields('DisplayCount').Value
					$Groups = .Fields('Groups').Value
					MsgBox(0, "Data", "UserName:  " & $UserName & @CRLF & "Messages to Display:  " & $DisplayCount & @CRLF & "Assigned Groups:  " & $Groups)
					.MoveNext
				WEnd
				return 1
			EndIf
		EndWith
	EndIf
EndIf
return 0
EndFunc

Func _AddUser($NewUser, $NewDisplay, $NewGroup)
$sqlCon.Execute ("INSERT INTO HDcommUsers Values ('" & $NewUser & "', '" & $NewDisplay & "', '" & $NewGroup & "')")
If Not @error Then
	MsgBox(0, "Finished", $NewUser & " successfully added to the database")
	return 1
Else
	MsgBox(0, "Error", "Unable to add " & $NewUser)
	Return 0
EndIf
EndFunc

Func _UpdateUser($UpdUser, $UpdDisplay, $UpdGroup)
$sqlCon.execute("Update HDcommUsers SET DisplayCount = '" & $UpdDisplay & "', Groups = '" & $UpdGroup & "' Where UserName = '" & $UpdUser & "'")
if not @error Then
	MsgBox(0, "Finished", $UpdUser & " Successfully updated")
	return 1
Else
	MsgBox(0, "Error", "Unable to update " & $UpdUser)
	Return 0
EndIf
EndFunc