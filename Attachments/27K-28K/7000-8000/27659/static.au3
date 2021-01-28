#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.1.1 (beta)
 Author:         gseller

 Script Function:
	You can set your default gateway and dns servers for your floor or ip ranges.
	Users can simply change their static ip or reset back to dhcp. I am going forward
	to have autoit pull the current ip information and wish to create a means of
	pulling current settings and adding to ini to store in case a mistake is made you
	can reset back to default. This will come later..

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>

;Set initial settings here, these will be written to the initial ini file for later use
$netname = "Local Area Connection"
$newIp = "Put Your New Static IP Here"
$newSubnet = "255.255.252.0"
$newDG = "165.122.31.254"
$newDNSP = "166.33.193.132"
$newDNSS = "166.35.82.120"

;####################################################################################

;#cs~~~~~~~~~~~~~~~~~~Start INI Creation Section~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If Not FileExists(@ScriptDir & "\ip_Settings.ini") Then
_FileCreate(@ScriptDir & "\ip_Settings.ini")
IniWriteSection(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "")
IniWrite(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "netname", $netname)
IniWrite(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newIp", $newIp)
IniWrite(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newSubnet", $newSubnet)
IniWrite(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newDG", $newDG)
IniWrite(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newDNSP", $newDNSP)
IniWrite(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newDNSS", $newDNSS)
 SplashTextOn( "FYI", "IP Settings file Generated", 300, 65, -1, -1,17 )
 Sleep(2000)
 SplashOff()
Else
 SplashTextOn( "", "Network IP Management Tool" & @CRLF & "Pay Attention Before Submiting" & @CRLF & "IP Setting", 300, 85, -1, -1,17 )
 Sleep(2000)
 SplashOff()
EndIf

;#ce~~~~~~~~~~~~~~~~~~~~~~End Of INI Creation Section~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;####################################################################################

;#cs~~~~~~~~~~~~~~~~~~Start INI Reading Section~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$varNetName = IniRead(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "netname", "NotFound")
$varNewIP = IniRead(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newIp", "NotFound")
$varNewSubnet = IniRead(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newSubnet", "NotFound")
$varNewDG = IniRead(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newDG", "NotFound")
$varNewDNSP = IniRead(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newDNSP", "NotFound")
$varNewDNSS = IniRead(@ScriptDir & "\ip_Settings.ini", "IP_Settings", "newDNSS", "NotFound")

;MsgBox(4096, "Result", $varNetName & @CRLF & $varNewIP & @CRLF & $varNewSubnet & @CRLF & $varNewDG & @CRLF & $varNewDNSP & @CRLF & $varNewDNSS); This will show what is being pulled from the ini

;#ce~~~~~~~~~~~~~~~~~~~~~~End INI Reading Section~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#Region ### START Koda GUI section ### Form=C:\Users\Jim\Desktop\My Dropbox\Autoit\Autoit Tools\koda_2008-10-03\Forms\Static IP.kxf
$Form1 = GUICreate("Network IP Manager - By Jim Dillon", 351, 384, 492, 355)
$Group1 = GUICtrlCreateGroup("IP Config", 8, 8, 225, 217)
$IPtoChange = GUICtrlCreateInput($varNewIP, 16, 48, 201, 25)
;$d = GUICtrlRead($IPtoChange)
$SubmasktoChange = GUICtrlCreateInput($varNewSubnet, 16, 104, 201, 25)
$DefaultGatewaytoChange = GUICtrlCreateInput($varNewDG, 16, 160, 201, 25)
$Label1 = GUICtrlCreateLabel("Static IP  Address To Add:", 16, 28, 129, 17)
$Label2 = GUICtrlCreateLabel("Submask:", 16, 84, 51, 17)
$Label3 = GUICtrlCreateLabel("Default Gateway:", 16, 142, 86, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("DNS", 8, 240, 225, 129)
$PrimaryDNStoChange = GUICtrlCreateInput($varNewDNSP, 16, 272, 209, 25)
$SecondaryDNStoChange = GUICtrlCreateInput($varNewDNSS, 16, 328, 209, 25)
$Label4 = GUICtrlCreateLabel("Primary DNS:", 16, 256, 67, 15)
$Label5 = GUICtrlCreateLabel("Secondary DNS:", 16, 310, 84, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$SetStaticIP = GUICtrlCreateButton("Set Static IP", 240, 16, 73, 97, 0)
$SetDHCP = GUICtrlCreateButton("DHCP", 240, 128, 75, 97, 0)
$Close = GUICtrlCreateButton("Exit", 240, 246, 75, 121, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Exit
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Set Network To Static IP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Case $SetStaticIP
If Not $IPtoChange = 0 Then
			$d = GUICtrlRead($IPtoChange)
			GUICtrlSetData($IPtoChange, ($d))
			$e = GUICtrlRead($SubmasktoChange)
			GUICtrlSetData($SubmasktoChange, ($e))
			$f = GUICtrlRead($DefaultGatewaytoChange)
			GUICtrlSetData($DefaultGatewaytoChange, ($f))
			$g = GUICtrlRead($PrimaryDNStoChange)
			GUICtrlSetData($PrimaryDNStoChange, ($g))
			$h = GUICtrlRead($SecondaryDNStoChange)
			GUICtrlSetData($SecondaryDNStoChange, ($h))

runwait ('netsh interface ip set address name=' & '"' & $netname & '" static ' & $d & ' '& $e & ' ' & $f & ' 1',"",@SW_Hide)

runwait ('netsh interface ip set dns name=' & '"' & $netname & '" static ' & $g & ' primary',"",@SW_Hide)

runwait ('netsh interface ip add dns name=' & '"' & $netname & '" addr=' & $g & ' index=2')

MsgBox(64,"Static IP Setup as follows:", "Your Static IP has been set and Configured to:" &@CRLF & @CRLF & "Static IP: " & $d & @CRLF & "Submask: " &  $e & @CRLF & "Defauly Gateway: " & $f & @CRLF &@CRLF & "Primary DNS: " & $g & @CRLF & "Secondary DNS: " & $h & @CRLF &@CRLF & "Thanks! " & @CRLF & "Jim",3)
			Else
MsgBox(64,"DHCP Set!",$e & "Please enter your IP you need changed?" & @CRLF & "Thanks! " & @CRLF & "Jim",3)

			EndIf
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~Set Network To DHCP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Case $SetDHCP
			If WinActivate("dalmn240amcilinkcom - Citrix Presentation Server Client", "") Then
			MouseMove(165, 140, 0)
			MouseClick("right")
;~~~~~~~~~~~~~~~~~~~~

		Else
$netname = "Local Area Connection"
runwait ('netsh interface ip set address name=' & '"' & $netname & '" dhcp', "", @SW_HIDE)

Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(64,"DHCP Set!","Your PC has been set back to DHCP.. " & @CRLF & "Thanks! " & @CRLF & "Jim",3)
Select
   Case $iMsgBoxAnswer = -1 ;Timeout

   Case Else                ;OK

EndSelect
			EndIf
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Case $Close
	Exit
EndSwitch
WEnd
