#include <GUIConstants.au3>

#include <process.au3>

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
 
$msgRet = MsgBox(1,"Petland Installation Code Generator","INSTALL CODE:   " & $RandomPick1 & "-" & $RandomPick2 & "-" & $RandomPick3 & "-" & $RandomPick4 & "-" & $RandomPick5)

If $msgRet = 2 then 
exit
Endif

$total = Number($RandomPick1+$RandomPick2+$RandomPick3+$RandomPick4+$RandomPick5)
$total1 = Number($total/1024)

Do
$passwd = InputBox("Install Code", "Enter Response Code.", "", )

if $passwd <> $total1 Then
$msgRet1 =  MsgBox(1,"", "INSTALL CODE RESPONSE INCORRECT")
  if $msgRet1 = 2 then
exit
Endif
Endif

Until $passwd == $total1

$msgRet2 =  MsgBox(1,"", "INSTALL SOFTWARE?")
  if $msgRet2 = 2 then
exit
Else
	RunAsSet("Administrator", @computername, "admin_password")
	; add your administrator password instead of admin_password
	ShellExecuteWait($var)
Endif
