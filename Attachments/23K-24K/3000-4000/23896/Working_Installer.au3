#include <GUIConstants.au3>
#include <process.au3>
#include <file.au3>

$message = "Select Program to install."

$var = FileOpenDialog($message, "C:\", "all (*.exe;*.msi)", 7 )

If @error Then
	MsgBox(4096,"","No File(s) chosen")
Else
	$var = StringReplace($var, "|", @CRLF)
	MsgBox(4096,"","You chose " & $var)
EndIf

$one = 1
$ten = 300
 
$RandomPick1 = Random($one,$ten,1)
$RandomPick2 = Random($one,$ten,1)
$RandomPick3 = Random($one,$ten,1)
$RandomPick4 = Random($one,$ten,1)
$RandomPick5 = Random($one,$ten,1)
 
$msgRet = MsgBox(1,"Installation Code Generator","INSTALL CODE:   " & $RandomPick1 & "-" & $RandomPick2 & "-" & $RandomPick3 & "-" & $RandomPick4 & "-" & $RandomPick5)

If $msgRet = 2 then 
exit
Endif

$total = Number($RandomPick1+$RandomPick2+$RandomPick3+$RandomPick4+$RandomPick5)
$total1 = Number($total/1024)

Do
$passwd = InputBox("Install Code", "Enter Response Code.", "", "")

If $passwd <> $total1 Then
		$msgRet1 =  MsgBox(1,"", "INSTALL CODE RESPONSE INCORRECT")
	If $msgRet1 = 2 then
	exit
	Endif
Endif

Until $passwd == $total1

$msgRet2 =  MsgBox(1,"", "CONTINUE TO INSTALL SOFTWARE?")
If $msgRet2 = 2 then
exit
Else
	Local $sUserName = "Administrator"
    Local $sPassword = "secret"
;note: replace your administrator password for secret
; Run a command prompt as the admin user.
     Local $pid = RunAs($sUserName, @ComputerName, $sPassword,1,"")
		
$var2 = StringSplit($var, ".")
$var3 = $var2[1] & "." & $var2[2]

	If $var2[2] = "msi" Then
		ShellExecuteWait($var3)
	Else
		RunWait($var3)
	EndIf
Endif
