#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <adfunctions.au3>
#include <Array.au3>
#include <File.au3>
Dim $strComputer, $CPU, $objUser, $Wscript, $adminLocal ;, $wsh

Global $Computers
$ou = "OU=Servers,DC=test,DC=local"; Root of your AD, e.g. DC=microsoft,DC=com
_ADGetObjectsInOU($Computers, $ou, "(&(objectCategory=computer))", 2)

Dim $Array1Size = UBound($Computers) - 1
;~ _ArrayDisplay($Sizes)
For $i = 0 To $Array1Size
	$Computers[$i] = StringReplace($Computers[$i], '$', '');removes money sign from end of each computer
	$Computers[$i] = StringLower($Computers[$i]);makes all computers lowercase
Next

_ArraySort($Computers, 0, 1)
_ArrayDelete($Computers, 0);removes the first row of array to get rid of count
;_ArrayDisplay($Computers)
_FileWriteFromArray("C:\Change.txt", $Computers);output OU to text file
FileOpen("c:\Change Complete.txt", 1)

$Array1Size = $Array1Size - 1
For $i = 0 To $Array1Size
	;Get the local administrator name in case it is not already set to the standard
	$adminLocal = GetAdministratorName($Computers[$i])
	$strComputer = $Computers[$i]
	$CPU = ObjGet("WinNT://" & $strComputer & ",Computer")
	$objUser = $CPU.GetObject("User", $adminLocal)

	;$wsh = ObjCreate("Wscript.Shell")
	$objUser.SetPassword("<N3w P@$$w0rd>")
	$objUser.SetInfo

	MsgBox(0, "Computer", $Computers[$i] & " Password Changed", 1)
	FileWriteLine("c:\Change Complete.txt", $Computers[$i] & " Password Changed")

Next

FileClose("c:\Change Complete.txt")

Func GetAdministratorName($ComputerName)
	Dim $UserSID, $oWshNetwork, $oUserAccount
	$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!//" & $ComputerName & "/root/cimv2")
	$oUserAccounts = $objWMIService.ExecQuery("Select Name, SID from Win32_UserAccount WHERE Domain = '" & $ComputerName & "'")
	For $oUserAccount In $oUserAccounts
		If StringLeft($oUserAccount.SID, 9) = "S-1-5-21-" And _
				StringRight($oUserAccount.SID, 4) = "-500" Then
			Return $oUserAccount.Name
		EndIf
	Next
EndFunc   ;==>GetAdministratorName