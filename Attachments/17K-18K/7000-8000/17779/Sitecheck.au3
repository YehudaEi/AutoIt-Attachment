#comments-start
Sitecheck 

Will poll a list of sites (actually URL's) at a set interval
If is has a problem it will pop a warning in the system tray as well as 
send an e-mail to a specified list pf people.

Only a specified number of e-mails will be sent to avoid inbox overcrowding
This is reset once all sites are back up again an e-mail will be sent
if any site is found to be down again.

uses an ini file for configuration to make it easy to use and configure
CheckInterval = minutes between checks (default = 20 minutes)
NumberofMessagestoSend = Number of Messages to Send before waiting for a reset
MailServer = the ip address of the mail serever to use to relay
MailFrom = The address of the person the mail originates from

[Siteurls] is a list of url's to check
[MailTo] is a list of people to alert.

#comments-end

Opt("GuiOnEventMode",1)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1); 

#NoTrayIcon
#include <GUIConstants.au3>
#include <array.au3>
#include <INet.au3>

$g_szVersion = "SiteCheck v1.0"
If WinExists($g_szVersion) Then 
	WinActivate ( $g_szVersion )
	Exit ; It's already running
EndIf

Global $MailSent = 0
Global $NumberofMessagestoSend = 2
Global $sleepTime
Global $pause = 1
Global $TrayTip = ""
Global $MailH[4]
Global $MailT[5]
;---------------Tray event values----------------

Global $TRAY_EVENT_SHOWICON            = -3
Global $TRAY_EVENT_HIDEICON            = -4
Global $TRAY_EVENT_FLASHICON        = -5
Global $TRAY_EVENT_NOFLASHICON        = -6
Global $TRAY_EVENT_PRIMARYDOWN        = -7
Global $TRAY_EVENT_PRIMARYUP        = -8
Global $TRAY_EVENT_SECONDARYDOWN    = -9
Global $TRAY_EVENT_SECONDARYUP        = -10
Global $TRAY_EVENT_MOUSEOVER        = -11
Global $TRAY_EVENT_MOUSEOUT            = -12
Global $TRAY_EVENT_PRIMARYDOUBLE    = -13
Global $TRAY_EVENT_SECONDARYDOUBLE    = -14
    
;---------------Build UI----------------
TraySetClick(16)

$runitem = TrayCreateItem("Check Now")
TrayItemSetOnEvent(-1,"CheckSiteNow")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitEvent")

;~ TraySetIcon(@AutoItExe)

TraySetState()
TraySetToolTip($g_szVersion)

;---------------Set initial variables----------------
FileInstall( "C:\Program Files\AutoIt3\Examples\Mine\sitecheck\sitecheck.ini", @ScriptDir & "\sitecheck.ini")

$sleepTime = IniRead("sitecheck.ini","Defaults","CheckInterval","20")
$sleepTime = $sleepTime * 1000 * 60
$URLList = IniReadSection("sitecheck.ini","Siteurls")
$MailTo =	IniReadSection("sitecheck.ini","MailTo")
$MailServer = IniRead("sitecheck.ini","Defaults","MailServer","")
$NumberofMessagestoSend = IniRead("sitecheck.ini","Defaults","NumberofMessagestoSend","2") + 1
$MailH[0] = "HELO" & @CRLF
$MailH[1] = "MAIL FROM:" & IniRead("sitecheck.ini","Defaults","MailFrom","") & @CRLF
$MailH[2] = "RCPT TO:" ; the rest of this gets populated later
$MailH[3] = "DATA" & @CRLF

$MailT[0] = "From: " & IniRead("sitecheck.ini","Defaults","MailFrom","") & @CRLF
$MailT[1] = "To: " 
$MailT[2] = "Subject: " & $g_szVersion & " Alert!" & @CRLF
$MailT[3] = "Reply-To: " & IniRead("sitecheck.ini","Defaults","MailFrom","") & @CRLF & @CRLF

;---------------Main loop----------------

While 1    
    CheckSite()
    Sleep($sleepTime)
WEnd

Exit

;---------------Functions----------------

Func CheckSite()
	$TrayTip = ""
	$SiteError=0
	For $loop = 1 To $URLList[0][0]	; for each site
		If $URLList[$loop][1] <> "" Then
			If InetGet($URLList[$loop][1], @TempDir & "\SiteCheck.htm", 1) = 0 then
				$TrayTip &= $URLList[$loop][1] & " is DOWN!" & @CRLF
				$SiteError=1
			Else
				$TrayTip &= $URLList[$loop][1] & " is up.!" & @CRLF
			EndIf
		EndIf			
	Next
	If $SiteError = 1 Then	; only show an error is there is one
		TrayTip($g_szVersion, $TrayTip, 30, 3)	; disappear after 30 seconds
		If $MailSent < $NumberofMessagestoSend Then	; only send a few e-mails
			If IsArray($MailTo) Then
				SendtheMail()	; there is an error so send the mail
			EndIf
			$MailSent += 1
		EndIf
	Else
		$MailSent = 0
	EndIf
EndFunc

Func CheckSiteNow()
	CheckSite()
	TrayTip($g_szVersion, $TrayTip, 30, 3)	; disappear after 30 seconds
EndFunc

;Function for exiting the app
Func ExitEvent()
    Exit
EndFunc

Func SendtheMail()
	Local $MailError=0
	
	TCPStartup()    ; To start TCP services
	$socket = TCPConnect( $MailServer, 25 )
	If $socket = -1 Then 
		TrayTip($g_szVersion, "Problem Opening Mail Socket.", 30, 3)
	EndIf
	$recv = TCPRecv( $socket, 512 )
	If  @error Then
		TrayTip($g_szVersion, "Problem Opening Mail Socket." & @error, 30, 3)
	EndIf
	
	$MailT[4] = $TrayTip & @CRLF ; add the error to the content
	
	For $loop = 1 To $MailTo[0][0]	; for each recipient
		$MailH[2] = "RCPT TO:" &  & $MailTo[$loop][1] & @CRLF
		$MailT[1] = "To:" & $MailTo[$loop][1] & @CRLF
		If $MailError = 0 Then
			For $loop1 = 0 To 3					; Send Mail Header
				$ret = TCPSend( $socket, $MailH[$loop1])
				If @ERROR Or $ret < 0 Then
					TrayTip($g_szVersion, "Problem Sending Header." & @ERROR & "-" & $ret, 30, 3)
					$MailError = 1
					ExitLoop
				EndIf
				$recv = TCPRecv( $socket, 512 ) 	;read server response
;~ 				ConsoleWrite($recv)
				
				If  @ERROR Then
					TrayTip($g_szVersion, "Problem sending Header" & @ERROR & "-" & $recv, 30, 3)
					$MailError = 1
					ExitLoop
				EndIf
			Next
			If $MailError = 0 Then
				For $loop1 = 0 To 4					; Send Message Content
					$ret = TCPSend( $socket, $MailT[$loop1])
					If @ERROR Or $ret < 0 Then
						TrayTip($g_szVersion, "Problem SendingMessage Content" & @ERROR & "-" & $ret, 30, 3)
						$MailError = 1
						ExitLoop
					EndIf
				Next
				$ret = TCPSend( $socket, @CRLF & "." & @CRLF)	; the end of the message
				If @ERROR Or $ret < 0 Then
						TrayTip($g_szVersion, "Problem SendingMessage Content" & @ERROR & "-" & $ret, 30, 3)
						$MailError = 1
						ExitLoop
				EndIf
				$recv = TCPRecv( $socket, 512 )
;~ 								ConsoleWrite($recv)
				If  @ERROR Then
					TrayTip($g_szVersion, "Problem SendingMessage Content" & @ERROR & "-" & $recv, 30, 3)
					$MailError = 1
					ExitLoop
				EndIf
			EndIf
		EndIf
		Sleep(1000)
	Next
	$ret = TCPSend( $socket,"QUIT" & @CRLF)	; the end the mail session
	If @ERROR Or $ret < 0 Then
		TrayTip($g_szVersion, "Problem SendingMessage Content" & @ERROR & "-" & $ret, 30, 3)
	EndIf
	$recv = TCPRecv( $socket, 512 )
	If  @ERROR Then
		TrayTip($g_szVersion, "Problem SendingMessage Content" & @ERROR & "-" & $recv, 30, 3)
	EndIf
	TCPCloseSocket( $socket )
	TCPShutdown ( ) ; To stop TCP services
EndFunc

;Close last GUI window
Func OnClose()
    GUIDelete()
EndFunc