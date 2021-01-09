#cs ----------------------------------------------------------------------------
 AutoIt Version:	3.2.10.0
 Author:			Christophe Savard
 Requirements :		None
 Parameters :		None
 Script Function:	Performs a network connectivity test on a range of hosts
					The best way would be to install this script on two different machines located in two differents IP sub networks.
					This would allow a double check and avoid not receiving any alert if the local machine (where the script is installed)
					is down or if the entire sub network is not working...
#ce ----------------------------------------------------------------------------
#include <File.au3> 
;#include <Array.au3> ; Only in debug mode if you want to verify the $IpList or $a_IpList content
#include "C:\$user\Program Files\Scripts\Scripts\$Include\MyUDF.au3"
Dim $TestMyIp, $TestRemoteIPs
$MailReceiver = "xxxx@yyyy" ; Put here the mail adress where the message should be sent
$MailServer = "mailserver.com" ; Put here the mail server
$Sleep = 900000 ; Sleep time in milliseconds (default is 15 minutes = 900000 milliseconds)
#region HostArray
	$SophieT = "sophie.mlv.fr.ibm.com"
	$SophieP = "sophiep.its.mlv.fr.ibm.com"
	$IpList = $SophieT & "|" & $SophieP ; You also can put the hosts list in an ".ini" file and use it as data source
	If Not $IpList Then ; La liste des IP à tester est vide...
		MsgBox(262144+16,StringTrimRight(@ScriptName,4) & " - Error","No host to test !" & @crlf & "SCRIPT HALTS NOW !") ; It would be stupid to continue if the host list is empty...
		Exit
	EndIf
	
	$IpList = StringSplit($IpList,"|",1)
	
	Dim $a_IpList[$IpList[0]+1][2] ; Creates a new two dimentional array which will be used to include $IpList content plus the default state for each host
	$a_IpList[0][0] = $IpList[0]
	
	For $i=1 To $IpList[0]
		$a_IpList[$i][0] = $IpList[$i] ; Loads array element with host name
		$a_IpList[$i][1] = "ON" ; Load array element with the default state
	Next
#endregion HostArray


Func _TestMyIp ()
	Local $MyIp = @IPAddress1 ; Gets the local IP adress and loads it into a variable
	If $MyIp = "127.0.0.1" Then
		Return $MyIp ; Local machine is not connected
	Else
		Return "" ; Local machine is connected
	EndIf
EndFunc

Func _TestRemoteIPs () ; Test all hosts
	Local $RetVal = ""
	Local $PingResult
	
	For $i=1 To $a_IpList[0][0] ; loops and test all hosts in the array 
		$PingResult = ""
		$PringResult = Ping($a_IpList[$i][0],250)
		If @error = 0 And $a_IpList[$i][1] = "ON" Then ContinueLoop ; No error and not state change => Let's test next item
		If @error = 0 And $a_IpList[$i][1] = "OFF" Then ; No error but host state changed since last check (server is back to 'ON') 
			$a_IpList[$i][1] = "ON" ; Reset the host's state in the array and prepares the final message
			$RetVal = $RetVal & $a_IpList[$i][0] & " / State : " & '"' & $a_IpList[$i][1] & '"' & " (" & @MDAY & "/" & @MON & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC & ")" & @CRLF ; changement d'état
		EndIf
		
		If @error <> 0 And $a_IpList[$i][1] = "OFF" Then ContinueLoop ; Error and no state change (host still 'OFF')
		If @error <> 0 And $a_IpList[$i][1] = "ON" Then ; Erreur mais changement d'état (serveur 'OFF')
			$a_IpList[$i][1] = "OFF" ; Reset the host's state in the array and prepares the final message
			$RetVal = $RetVal & " - " &$a_IpList[$i][0] & " / State : " & '"' & $a_IpList[$i][1] & '"' & " (" & @MDAY & "/" & @MON & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC & ")" & @CRLF ; changement d'état
		EndIf
	Next

	If $RetVal = "" Then Return $RetVal ; No state change since last check => No alert needed.
	
	$RetVal = "Hello," & @crlf & "Please find below the hosts list for which a state change happened since last check : " & @CRLF & @CRLF & $RetVal& @CRLF & @CRLF & _
	"========================================" & @CRLF & _
	" This message was sent by a robot" & @CRLF & _
	" It's not necessary to try any answer..." & @CRLF & _
	"========================================"
	Return $RetVal	
EndFunc


While 1 ; Main loop
	Local $Mail = ""
	$TestMyIp = _TestMyIp () ; Test local machine network connection
	If $TestMyIp = "" Then ; Local machine is connected
		$TestRemoteIPs = _TestRemoteIPs () ; We can now test the hosts list
		If $TestRemoteIPs <> "" Then ; Network state changed for one or more hosts
			$Mail = _INetSmtpMailCom($MailServer,"C.H.A.S.T","C.H.A.S.T",$MailReceiver,"C.H.A.S.T - Rapport de changement d'état...",$TestRemoteIPs,"","","","","",25,0) ; Sends the alert mail
		EndIf
	Else ; Local machine is not connected
		TrayTip (StringTrimRight(@ScriptName,4) , "Local machine not connected !", 5, 1) ; just popups a message in the tray (mail is not possible)
	EndIf
	Sleep ($Sleep) ; Pause before performing next test (see top of the script to modify the sleep delay)
WEnd