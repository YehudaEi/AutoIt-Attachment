;Coded by UEZ
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_UseUpx=n

Global $ip = "localhost"
If $CmdLine[0] > 0 Then $ip = $CmdLine[1]

$objWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & $ip & "\root\cimv2")

GetWMI($ip)

Func GetWMI($srv)
    Local $Description, $NetConnectionID, $colItems, $colItem, $ping, $msg
    $ping = Ping($srv)
    If $ping Then
    If $objWMIService.ExecQuery("SELECT Description FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True", "WQL", 0x00).Count > 1 Then
    $colItems = $objWMIService.ExecQuery("SELECT Description, NetConnectionID FROM Win32_NetworkAdapter WHERE NetConnectionStatus >= 0", "WQL", 0x30)
    If IsObj($colItems) Then
    For $objItem In $colItems
    $NetConnectionID &= $objItem.NetConnectionID & @CRLF
                    $Description &= $objItem.Description & @CRLF
    Next
    SetError(0)
    $msg = "More than one enabled network adapter found: " & @CRLF & @CRLF & $NetConnectionID & @CRLF
	If (StringInStr($NetConnectionID, "Local Area Connection") > 0) AND (StringInStr($NetConnectionID, "Wireless Network Connection")> 0)  Then
	MsgBox(0, "Network Adapter Information", $msg & "Wireless Network Connection can be disabled")
; Disable and Enable a Network card using 'Shell.Application'
;
; See also: http://blog.mvpcn.net/icuc88/articles/244.aspx
;
; To do: Rewrite this into a UDF. Parameters: $oLanConnection and $bEnabled


$oLanConnection = "Wireless Network Connection"; Change this to the name of the adapter to be disabled !
$bEnable = False             ; Change this to 'false' to DISABLE the network adapter

if @OSType<>"WIN32_NT" then
    Msgbox(0,"","This script requires Windows 2000 or higher.")
    exit
endif


if @OSVersion="WIN_2000" then
    $strFolderName = "Network and Dial-up Connections"
else
    $strFolderName = "Network Connections"; Windows XP
endif

Select 
    Case StringInStr("0409,0809,0c09,1009,1409,1809,1c09,2009,2409,2809,2c09,3009,3409", @OSLang) ; English (United States)
       $strEnableVerb  = "En&able"
       $strDisableVerb = "Disa&ble"

; Add here the correct Verbs for your Operating System Language
EndSelect


;Virtual folder containing icons for the Control Panel applications. (value = 3)
Const $ssfCONTROLS = 3 

$ShellApp = ObjCreate("Shell.Application")
$oControlPanel = $shellApp.Namespace($ssfCONTROLS)


; Find 'Network connections' control panel item
$oNetConnections=""

For $FolderItem in $oControlPanel.Items
    If $FolderItem.Name = $strFolderName then
        $oNetConnections = $FolderItem.GetFolder
        Exitloop
    Endif
Next

      
If not IsObj($oNetConnections) Then
    MsgBox(0,"Error","Couldn't find " & $strFolderName & " folder." )
    Exit
EndIf
        

For $FolderItem In $oNetConnections.Items
    If StringLower($FolderItem.Name) = StringLower($oLanConnection) Then
        $oLanConnection = $FolderItem
        Exitloop
    EndIf
Next

If not IsObj($oLanConnection) Then
     MsgBox(0,"Error","Couldn't find " & $oLanConnection & " Item." )
     Exit
EndIf

$oEnableVerb=""
$oDisableVerb=""

For $Verb In $oLanConnection.Verbs
 If $Verb.Name = $strEnableVerb Then
   $oEnableVerb = $Verb
 EndIf
 If $Verb.Name = $strDisableVerb Then
   $oDisableVerb = $Verb
 EndIf
Next

If $bEnable then
 If IsObj($oEnableVerb) Then $oEnableVerb.DoIt  ; Enable network card
Endif

If not $bEnable then
 If IsObj($oDisableVerb) Then $oDisableVerb.DoIt; Disable network card
EndIf

Msgbox(0,"Wireless Disconnected, By default you'll be connected to LAN","You've been disconnected from Wireless Network Connection because you had more than 1 Network interface connected. If you want to use WLAN, please disconnect LAN cable and then connect WLan")

;Sleep(1000)

    Else
    MsgBox(0, "Network Adapter Information", $msg)

EndIf
    Return $NetConnectionID
    Else
    SetError(1)
    Return "Error!"
    EndIf
    Else
    ;MsgBox(0, "Information", "Only one network adapter found")
    EndIf
    Else
    SetError(1)
    Return "Host not reachable"
    EndIf
EndFunc
 