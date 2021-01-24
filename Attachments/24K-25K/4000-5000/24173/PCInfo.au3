#cs ----------------------------------------------------------------------------

 AutoIt Version   : 3.2.10.0
 Author           : ErinC	
 Date             : 02/07/2008
 Script Function  : PCInfo Utility - Version 3

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <INet.au3>

; declaration of variables
$IP1 = @IPAddress1
$IP2 = @IPAddress2
$IP3 = @IPAddress3
$Office2000 = ""
$Office2003 = ""
$Office2007 = ""
$msg = ""
$Address = ""
$Subject = ""
$Body = ""

If @IPAddress1 = "0.0.0.0" then 
	$IP1 = "N/A"
Else
	; no action required
EndIf

If @IPAddress2 = "0.0.0.0" then 
	$IP2 = "N/A"
Else
	; no action required
EndIf

If @IPAddress3 = "0.0.0.0" then 
	$IP3 = "N/A"
Else
	; no action required
EndIf

; Office 2000 Check
If (RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{00000409-78E1-11D2-B60F-006097C998E7}", "DisplayName") = ("Microsoft Office 2000 SR-1 Premium")) OR (RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{00000409-78E1-11D2-B60F-006097C998E7}", "DisplayName" = "Microsoft Office 2000 Premium")) Then
	$Office2000 = "Yes"
Else
	$Office2000 = "Unknown"
EndIf

; Office 2003 Check
If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{90110409-6000-11D3-8CFE-0150048383C9}", "DisplayName") = "Microsoft Office Professional Edition 2003" Then
	$Office2003 = "Yes"
Else
	$Office2003 = "Unknown"
EndIf

; Office 2007 Check
If RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{90120000-0030-0000-0000-0000000FF1CE}", "DisplayName") = "Microsoft Office Enterprise 2007" Then
		$Office2007 = "Yes"
Else
		$Office2007 = "Unknown"
EndIf

; VScan DAT Checks
$VScan8 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Network Associates\TVD\VirusScan Enterprise\CurrentVersion", "szVirDefDate")
$VScan85 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\McAfee\AVEngine", "AVDatDate")

if ($VScan8 = "" AND $VScan85 = "") Then
	$VScan8 = "Not Found"
	$VScan85 = "Not Found"
Else
EndIf

; PCInfo Message Box
$msg = MsgBox(4,"DGC PC-Information Utility", "Logged on as         :  " & @Username & @CRLF & "PC Name                :  " & @ComputerName & @CRLF & "Domain                   :  " & @LogonDNSDomain & @CRLF & "1st IP Address       :  " & $IP1 & @CRLF & "2nd IP Address      :  " & $IP2 & @CRLF & "3rd IP Address       :  " & $IP3 & @CRLF & "Windows Version   :  " & @OSVersion & " " & @OSServicePack & @CRLF & "User Profile            : " & @UserProfileDir & @CRLF & "Office 2000           :  " & $Office2000 & @CRLF & "Office 2003           :  " & $Office2003 & @CRLF & "Office 2007           :  " & $Office2007 & @CRLF & "Screen Resolution : " & @DesktopWidth & "x" & @DesktopHeight & @CRLF & "Refresh Rate        : " & @DesktopRefresh & " Hz" & @CRLF & "VScan DAT            : " & $VScan8 & $VScan85 & @CRLF & @CRLF & "Information gathered at " & @HOUR & ":" & @MIN & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF & @CRLF & "Would you like to email this information to the servicedesk ?")

; Email Section
Opt('RunErrorsFatal', 0)

If $msg = 6 Then
   $Address = "Servicedesk@company.com"
   $Subject = String ("PC-Info for User " & @Username & " - PC Name : " & @Computername)
   $Body = String ("Logged on as          :  " & @Username & @CRLF & "PC Name                :  " & @ComputerName & @CRLF & "Domain                   :  " & @LogonDNSDomain & @CRLF & "1st IP Address         :  " & $IP1 & @CRLF & "2nd IP Address       :  " & $IP2 & @CRLF & "3rd IP Address       :  " & $IP3 & @CRLF & "Windows Version   :  " & @OSVersion & " " & @OSServicePack & @CRLF & "User Profile            : " & @UserProfileDir & @CRLF & "Office 2000           :  " & $Office2000 & @CRLF & "Office 2003           :  " & $Office2003 & @CRLF & "Office 2007           :  " & $Office2007 & @CRLF & "Screen Resolution : " & @DesktopWidth & "x" & @DesktopHeight & @CRLF & "Refresh Rate         : " & @DesktopRefresh & " Hz" & @CRLF & "VScan DAT            : " & $VScan8 & $VScan85 & @CRLF & @CRLF & "Information gathered at " & @HOUR & ":" & @MIN & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF & @CRLF & "Please enter any additional information under the line below, or simply click Send" & @LF & "--------------------------------------------------------------------------------" & @LF & @LF)
   _INetMail($Address, $Subject, $Body)
WinActivate("PC-Info")
Else
   Exit
EndIf
Exit