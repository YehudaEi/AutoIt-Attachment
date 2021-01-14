#cs ===============================================================================

IP Table Tool ver 1.0 - 01.17.2006
Autor: Sulfurious
Language: English
OSystem: Windows Xp

Features: Manage IP Routing Tables persistent routes

-limited to bogus gateway of static ip at x.x.x.250
-limited to one IP per registry key
-no support for net blocks
-add or delete everything
-no error code yet, no saving of pre-existing routes

Requirements: Legal copy of Microsoft Windows Xp
Construction: Autoit 3.1+, SciTE 1.63

#ce ===============================================================================
#region - CHECK PREVIOUS INSTANCE AND HOT-KEY EXIT -
$IPTTversion = "IPTT v1.0"
If WinExists($IPTTversion) Then Exit 
AutoItWinSetTitle($IPTTversion)
HotKeySet("^!x", "_fCAX");exit hotkeys are Ctrl + Alt + X
#endregion

#include <GUIConstants.au3>
#include <file.au3>
Global $filein, $fileout, $line, $line2, $iprange, $ip1, $ip2, $foundADDRESS, $guiIPrange, $myIP, $ips
$myIP = @IPAddress1
$myip = StringTrimRight($myip,StringLen(StringInStr($myip,".",0,3)))

#region - GUI ----- MASTER -
Opt("GUIOnEventMode", 1)
$guiMaster = GUICreate("IP Table Tool", 500, 350, 100, 100, -1, $WS_EX_TOPMOST)
$filemenu = GUICtrlCreateMenu ("&Warning")
$fileitem = GUICtrlCreateMenuitem ("ReadMe!",$filemenu)
GUICtrlSetOnEvent(-1,"_fWARNING")
$fileitem2 = GUICtrlCreateMenuitem("Usage",$filemenu)
GUICtrlSetOnEvent(-1,"_fUSAGE")
$fileitem3 = GUICtrlCreateMenuitem("Ctrl + Alt + X exits!",$filemenu)
GUICtrlCreateLabel("DNS name: ( ie. google.com )",10,10,200,20)
$guiDNS = GUICtrlCreateInput("",10,30,400,20)
$guiGO = GUICtrlCreateButton("Get IP Info",10, 60, 100, 40, $BS_MULTILINE)
GUICtrlSetOnEvent(-1,"_fLOOKUP")
$guiADDIP = GUICtrlCreateButton("Add to list",180,160,100,40,$BS_MULTILINE)
GUICtrlSetOnEvent(-1,"_fADDIP")
GUICtrlCreateLabel("IP(s)",10,120,50,20)
$guiDELIP = GUICtrlCreateButton("Delete list",180,210,100,40,$BS_MULTILINE)
GUICtrlSetOnEvent(-1,"_fDELINI")
$lstURLS = GUICtrlCreateList("",10,160,150,160)
GUICtrlSetLimit(-1,200)
_fLIST()
$guiDELSIP = GUICtrlCreateButton("Delete single name",180,260,100,40,$BS_MULTILINE)
GUICtrlSetOnEvent(-1,"_fDELCHOICE")
$guiREF = GUICtrlCreateButton("Refresh  List",180,60,100,40)
GUICtrlSetOnEvent(-1,"_fREF")
GUICtrlCreateLabel("List",10,145)
$guiAddRTS = GUICtrlCreateButton("Add Routes",290,160,100,40)
GUICtrlSetOnEvent(-1,"_fADDR")
$guiDelRTS = GUICtrlCreateButton("Delete ALL Routes",290,210,100,40)
GUICtrlSetOnEvent(-1,"_fDELR")
$guiEXIT = GUICtrlCreateButton("EXIT",290,260,100,40)
GUICtrlSetOnEvent(-1,"_fCAX")
GUISetOnEvent($GUI_EVENT_CLOSE, "_fCAX")
GUISetState(@SW_SHOW)
GUICtrlSetState($guiDNS,$gui_focus)
#endregion

#region - GUI ----- IDLE AROUND -
Sleep(2000)
While 1
    Sleep(1000)  ; Idle around
WEnd
#endregion

#region - FUNCTIONS ----- REGISTRY READ/WRITE FUNCTIONS
Func _fADDR()
    $regX = 1
    Do
        $regR = RegEnumVal("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes",$regX)
        RegDelete("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes",$regR)
    until $regR = ""
    $iniR = IniReadSection("c:\myIPlist.ini","iplist")
    for $b = 1 to UBound($iniR) - 1
        RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes",$iniR[$b][1] & ",255.255.255.255," _
        & $myIP & "250,1","REG_SZ",$iniR[$b][0])
    Next
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Adds all domain names in list (ip addresses) to be persistent routes to your local ip x.x.x.250 octet
Func _fDELR()
    $regY = 1
    Do
        $regRE = RegEnumVal("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes",$regY)
        RegDelete("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes",$regRE)
    until $regRE = ""
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Deletes ALL persistent routes in IP routing table
#endregion

#region - FUNCTIONS ----- LIST BOX FUNCTIONS
Func _fREF()
    GUICtrlSetData($lstURLS,"")
    _fLIST()
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Refresh the list box (after changes 
Func _fLIST()
    $arrURLS = IniReadSection("C:\myIPlist.ini", "iplist")
    For $i = 1 to UBound($arrURLS) - 1
        GUICtrlSetData($lstURLS, $arrURLS[$i][0] & "|")
    Next
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Fill the list box with Domain Name/IP entries from .ini file
Func _fADDIP()
    if $ip1 <> "" Then IniWrite("C:\myIPlist.ini", "iplist", GUICtrlRead($guiDNS), $ip1)
    if UBound($ips) > 0 Then
        for $i = 1 to UBound($ips) - 1
            IniWrite("c:\myIPlist.ini","iplist",GUICtrlRead($guiDNS) & " #" & $i, $ips[$i])
        Next
    EndIf
    _fREF()
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Add the IP found to the .ini file (list)
Func _fDELCHOICE()
    $lstREAD = GUICtrlRead($lstURLS)
    IniDelete("c:\myIPlist.ini","iplist",$lstREAD)
    _fREF()
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Delete the highlighted list item (Domain Name/IP)
Func _fDELINI()
    FileDelete("c:\myIPlist.ini")
    _fREF()
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Delete the entire .ini file (start new next ADD)
#endregion

#region - FUNCTIONS ----- NSLOOKUP 
Func _fLOOKUP()
$ip1 = ""
$ip2 = ""
$foundADDRESS = ""
$ips = ""
GUICtrlDelete($guiIPrange)
RunWait(@ComSpec & " /c" & "nslookup " & GUICtrlRead($guiDNS) & " >c:\IPPT.log")
$filein = FileOpen("c:\IPPT.log",0)
while 1
    $line = FileReadLine($filein,5)
        if @error then ExitLoop
            if StringInStr($line,"Addresses:") Then
                $line = StringStripWS($line,8)
                $line = StringTrimLeft($line,StringInStr($line,":"))
                $ips = StringSplit($line,",")
                for $x = 1 to UBound($ips) -1
                    $foundADDRESS = $foundADDRESS & $ips[$x] & " ^ "
                Next
                ExitLoop
            ElseIf StringInStr($line,"Address:") Then
                $line = StringStripWS($line,8)
                $ip1 = StringTrimLeft($line,StringInStr($line,":"))
                $foundADDRESS = $ip1
                ExitLoop
            Else
                $foundADDRESS = "Some kind of error"
                ExitLoop
            EndIf
WEnd
FileClose($filein)
FileDelete("c:\IPPT.log")
$guiIPrange = GUICtrlCreateLabel($foundADDRESS,80,120,400,20,$ss_sunken)
GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Use NSLOOKUP to find the IP for the Domain Name, and display the results
#endregion

#region - FUNCTIONS ----- GENERAL PROGRAM FUNCTIONS
Func _fCAX()
    Exit 
EndFunc ;===> close app with hotkeys CTRL + ALT + X and generic EXIT
Func _fWARNING()
    MsgBox(4096,"W A R N I N G ! ", "WARNING! This application is intended to manage other applications requests " & @CRLF _
        & "to 'phone home'. Rather than use resources or make rules in a firewall, " & @CRLF _
        & "I choose to manage them from the IP Routing Table. This may be good " & @CRLF _
        & "or bad. Don't know. This requires you to be on a network " & @CRLF _
        & "with a fixed IP for your computer. If you already have persistent " & @CRLF _
        & "routes, this will delete them! Beware!" & @CRLF _
        & "PS. There is no error control. Maybe in the future ")
        GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Display WARNING message
Func _fUSAGE()
    MsgBox(4096,"Usage","Usage is quite simple. Type in a domain name to look up. " & @CRLF _
    & "Then click Get IP Info. The IP numbers will then be displayed. If you " & @CRLF _
    & "wish to add that to the IP Routing Table, click Add to List. A file named " & @CRLF _
    & "myIPlist.ini will be made in the root of c:\. You can add as many as you like. " & @CRLF _
    & "You can also delete it entirely, or just hightlight one entry in the list box " & @CRLF _
    & "and delete it only. Use the Add Routes button to add all the entries in the list " & @CRLF _
    & "to the registry. Or, you can delete them all. The only restrictions are that " & @CRLF _
    & "you need to have a static IP, and that the ip x.x.x.250 (your range) needs " & @CRLF _
    & "to be unused. I route traffic to the IP's in the list to .250, which effectively " & @CRLF _
    & "goes nowhere. You need to reboot after adding routes. Have fun.")
    GUICtrlSetState($guiDNS,$gui_focus)
EndFunc ;===> Generic usage. not too complicated
#endregion