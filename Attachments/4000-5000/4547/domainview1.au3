#include <GuiConstants.au3>
#include <File.au3>
#include <Date.au3>
#Include "services-net.au3"
#Include "subnet.au3"
FileInstall("AU3XtraTest.dll", @TempDir & "\AU3XtraTest.dll")

Global $run = 0
Global $loc
Dim $ipaddressloc[14]
Dim $subnetmaskloc[14]
Dim $compnameloc[14]
Global $pingdelay = "1000"
AutoItSetOption("WinTitleMatchMode", 4)
Opt ("GuiOnEventMode", 1)

$oslang = @OSLang
If $oslang = "0406" Then
   $loc = 13
ElseIf $oslang = "0413" Or $oslang = "0813" Then
   $loc = 11
ElseIf $oslang = "0409" Or $oslang = "0809" Or $oslang = "0c09" Or $oslang = "1009" Or $oslang = "1409" Or _
      $oslang = "1809" Or $oslang = "1c09" Or $oslang = "2009" Or $oslang = "2409" Or $oslang = "2809" Or _
      $oslang = "2c09" Or $oslang = "3009" Or $oslang = "3409" Then
   $loc = 1
ElseIf $oslang = "040b" Then
   $loc = 7
ElseIf $oslang = "040c" Or $oslang = "080c" Or $oslang = "0c0c" Or $oslang = "100c" Or $oslang = "140c" Or _
      $oslang = "180c" Then
   $loc = 2
ElseIf $oslang = "0407" Or $oslang = "0807" Or $oslang = "0c07" Or $oslang = "1007" Or $oslang = "1407" Then
   $loc = 3
ElseIf $oslang = "040e" Then
   $loc = 10
ElseIf $oslang = "0410" Or $oslang = "0810" Then
   $loc = 9
ElseIf $oslang = "0414" Or $oslang = "0814" Then
   $loc = 6
ElseIf $oslang = "0415" Then
   $loc = 12
ElseIf $oslang = "0416" Or $oslang = "0816" Then
   $loc = 8
ElseIf $oslang = "040a" Or $oslang = "080a" Or $oslang = "0c0a" Or $oslang = "100a" Or $oslang = "140a" Or _
      $oslang = "180a" Or $oslang = "1c0a" Or $oslang = "200a" Or $oslang = "240a" Or $oslang = "280a" Or _
      $oslang = "2c0a" Or $oslang = "300a" Or $oslang = "340a" Or $oslang = "380a" Or $oslang = "3c0a" Or _
      $oslang = "400a" Or $oslang = "440a" Or $oslang = "480a" Or $oslang = "4c0a" Or $oslang = "500a" Then
   $loc = 4
ElseIf $oslang = "041d" Or $oslang = "081d" Then
   $loc = 5
Else
   MsgBox(0, "Error", "Unsupported language, defaulting to English")
   $loc = 1
EndIf

; Localization Variables

; 1 = English
; 2 = French
; 3 = German
; 4 = Spanish
; 5 = Swedish
; 6 = Norwegian
; 7 = Finnish
; 8 = Portugese
; 9 = Italian
; 10 = Hungarian
; 11 = Dutch
; 12 = Polish
; 13 = Danish

$ipaddressloc[1] = "IP Address"
$ipaddressloc[2] = "Adresse IP"
$ipaddressloc[3] = "IP-Adresse"
$ipaddressloc[4] = "Dirección IP"
$ipaddressloc[5] = "IP-adress"
$ipaddressloc[6] = "IP-adresse"
$ipaddressloc[7] = "IP-osoite"
$ipaddressloc[8] = "Endereço IP"
$ipaddressloc[9] = "Indirizzo IP"
$ipaddressloc[10] = "IP-cím"
$ipaddressloc[11] = "IP-adres"
$ipaddressloc[12] = "Adres IP"
$ipaddressloc[13] = "IP-adresse"

$subnetmaskloc[1] = "Subnet Mask"
$subnetmaskloc[2] = "Masque de sous-réseau"
$subnetmaskloc[3] = "Subnetzmaske"
$subnetmaskloc[4] = "Máscara de subred"
$subnetmaskloc[5] = "Nätmask"
$subnetmaskloc[6] = "Nettverksmaske"
$subnetmaskloc[7] = "Aliverkon peite"
$subnetmaskloc[8] = "Máscara de sub-rede"
$subnetmaskloc[9] = "Subnet mask"
$subnetmaskloc[10] = "Alhálózati maszk"
$subnetmaskloc[11] = "Subnetmasker"
$subnetmaskloc[12] = "Maska podsieci"
$subnetmaskloc[13] = "Undernetmaske"

$compnameloc[1] = "Computer"
$compnameloc[2] = "Ordinateur"
$compnameloc[3] = "Computer"
$compnameloc[4] = "Computadora"
$compnameloc[5] = "Dator"
$compnameloc[6] = "Datamaskin"
$compnameloc[7] = "Tietokone"
$compnameloc[8] = "Computador"
$compnameloc[9] = "Calcolatore"
$compnameloc[10] = "Számítógép"
$compnameloc[11] = "Computer"
$compnameloc[12] = "Komputer"
$compnameloc[13] = "Computer"

If _ServiceRunning ("", "lanmanworkstation") Then
   _Main()
Else
   MsgBox(0, "Error", "The Workstation Service is not running, this needs to be" & @CRLF & "running to display the machines in your domain.")
   Exit
EndIf

Func _Main()
   _FileCleanUp()
   _CreatePCInfoScript()
   _GetIPSub()
   _FileCleanUp()
   _CreatePCInfoScript()
   _CreateDomainPCsGUI()
   _Vars()
   
   GUICtrlSetOnEvent($listpcbutton, "_ListPCs")
   GUICtrlSetOnEvent($subnetcheckbox, "_SubnetCheckbox")
   GUICtrlSetOnEvent($pcinfobutton, "_PCInfo")
   GUISetOnEvent($GUI_EVENT_CLOSE, "_DomainViewExit")
EndFunc

While 1
   Sleep(60000)
WEnd

; Global Variable Definitions
Func _Vars()
   Global $progress = Number($lines[0])
   Global $compname[$lines[0] + 2]
   Global $os[$lines[0] + 2]
   Global $comp[$lines[0] + 2]
   Global $service_pack[$lines[0] + 2]
   Global $ip[$lines[0] + 2]
   Global $ipaddr[$lines[0] + 2]
   Global $username[$lines[0] + 2]
   Global $install_date[$lines[0] + 2]
   Global $ips[$lines[0] + 2]
   Global $item[$lines[0] + 2]
   Global $service[$lines[0] + 2]
   Global $mac[$lines[0] + 2]
   Global $pcs = 0
   Global $timerstart[$lines[0] + 1 ]
   Global $pctimer[$lines[0] + 1 ]
   Global $pctime = 0
   Global $cpumhz[$lines[0] + 2]
   Global $cpuname[$lines[0] + 2]
   Global $cdkey[$lines[0] + 2]
   Global $notesdb[$lines[0] + 2]
   Global $boot_date[$lines[0] + 2]
   Global $pcvendor[$lines[0] + 2]
   Global $pcmodel[$lines[0] + 2]
   Global $pcserial[$lines[0] + 2]
   Global $ram[$lines[0] + 2]
   Global $drvcsize[$lines[0] + 2]
   Global $drvcfree[$lines[0] + 2]
   Global $drvcused[$lines[0] + 2]
   Global $drvdsize[$lines[0] + 2]
   Global $drvdfree[$lines[0] + 2]
   Global $drvdused[$lines[0] + 2]
   Global $drvesize[$lines[0] + 2]
   Global $drvefree[$lines[0] + 2]
   Global $drveused[$lines[0] + 2]
   Global $drvfsize[$lines[0] + 2]
   Global $drvffree[$lines[0] + 2]
   Global $drvfused[$lines[0] + 2]
EndFunc

; End Global Variable Definitions
; GUI Display Functions

Func _CreateDomainPCsGUI()
   Global $lines = _NetView(@LogonDomain, "Workstation")
   Global $domaingui = GUICreate(@LogonDomain & " (" & @ComputerName & ")", 250, 320, (@DesktopWidth - 250) / 2, (@DesktopHeight - 320) / 2, $WS_OVERLAPPED + $WS_SYSMENU + $WS_CAPTION + $WS_MINIMIZEBOX + $WS_VISIBLE)
   GUICtrlSetLimit(-1, 20000)
   Global $listview = GUICtrlCreateListView($compnameloc[$loc] & " | " & $ipaddressloc[$loc], 10, 10, 230, 230, $LVS_NOSORTHEADER + $LVS_SINGLESEL)
   Global $progressbar = GUICtrlCreateProgress(10, 297, 231, 15)
   Global $subnetcheckbox = GUICtrlCreateCheckbox("Only Show /" & $subnetinfo[6], 10, 250)
   Global $ipcheckbox = GUICtrlCreateCheckbox("Show IP Addresses", 10, 271)
   Global $remainlabel = GUICtrlCreateLabel("Time Remaining: ", 125, 275, 110)
   Global $pcinfobutton = GUICtrlCreateButton("PC Info", 114, 250, 60, 20)
   GUICtrlSetState($pcinfobutton, $GUI_DISABLE)
   Global $listpcbutton = GUICtrlCreateButton("List PCs", 180, 250, 60, 20)
   GUISetState()
EndFunc

Func _DisplayServicesGUI()
   HotKeySet( "{F5}", "_RefreshServices")
   Global $servicesgui = GUICreate($comp[$pcnumber], 300, 355, (@DesktopWidth - 300) / 2, (@DesktopHeight - 355) / 2, $WS_POPUP + $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_MINIMIZEBOX + $WS_VISIBLE)
   GUICtrlCreateLabel("Tip: F5 Key Refreshes Service List", 4, 338, 200)
   GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
   Global $startbutton = GUICtrlCreateButton("Start", 245, 192, 54, 30)
   Global $stopbutton = GUICtrlCreateButton("Stop", 188, 192, 54, 30)
   
   _CreateServiceScript()
   _CheckServices()
   _ServicesListView()
   
   $tab = GUICtrlCreateTab(0, 202, 300, 136, $TCS_HOTTRACK)
   $ostab = GUICtrlCreateTabItem("OS Info")
   Global $osheader = GUICtrlCreateLabel("Operating System:", 5, 230, 185)
   GUICtrlSetFont($osheader, 8, 800, 0, "MS Sans Serif")
   If $service_pack[$pcnumber] > 0 Then
      $oslabel = GUICtrlCreateLabel($os[$pcnumber] & " SP" & $service_pack[$pcnumber], 5, 245, 250)
   Else
      $oslabel = GUICtrlCreateLabel($os[$pcnumber], 5, 245, 185)
   EndIf
   Global $userheader = GUICtrlCreateLabel("Current User:", 5, 265, 80)
   GUICtrlSetFont($userheader, 8, 800, 0, "MS Sans Serif")
   $userlabel = GUICtrlCreateLabel($username[$pcnumber], 5, 280, 100)
   Global $installheader = GUICtrlCreateLabel("Install Date:", 5, 300, 80)
   GUICtrlSetFont($installheader, 8, 800, 0, "MS Sans Serif")
   $installdatelabel = GUICtrlCreateLabel($install_date[$pcnumber], 5, 315, 80)
   Global $bootdateheader = GUICtrlCreateLabel("Last Reboot:", 100, 300, 80)
   GUICtrlSetFont($bootdateheader, 8, 800, 0, "MS Sans Serif")
   $bootdatelabel = GUICtrlCreateLabel($boot_date[$pcnumber], 100, 315, 150)
   Global $cdkeyheader = GUICtrlCreateLabel("Windows Product Key:", 100, 265, 130)
   GUICtrlSetFont($cdkeyheader, 8, 800, 0, "MS Sans Serif")
   $cdkeylabel = GUICtrlCreateLabel($cdkey[$pcnumber], 100, 280, 200)
   $hwtab = GUICtrlCreateTabItem("Hardware")
   Global $ipheader = GUICtrlCreateLabel($ipaddressloc[$loc] & ":", 105, 265, 75)
   GUICtrlSetFont($ipheader, 8, 800, 0, "MS Sans Serif")
   $iplabel = GUICtrlCreateLabel($ip[$pcnumber], 105, 280, 75)
   Global $modelheader = GUICtrlCreateLabel($pcvendor[$pcnumber] & " Model:", 5, 230, 250)
   GUICtrlSetFont($modelheader, 8, 800, 0, "MS Sans Serif")
   $modellabel = GUICtrlCreateLabel($pcmodel[$pcnumber], 5, 245, 120)
   Global $serialheader = GUICtrlCreateLabel("Serial Number:", 5, 265, 120)
   GUICtrlSetFont($serialheader, 8, 800, 0, "MS Sans Serif")
   $seriallabel = GUICtrlCreateLabel($pcserial[$pcnumber], 5, 280, 80)
   Global $ramheader = GUICtrlCreateLabel("RAM:", 205, 230, 50)
   GUICtrlSetFont($ramheader, 8, 800, 0, "MS Sans Serif")
   $ramlabel = GUICtrlCreateLabel($ram[$pcnumber] /1024 / 1024 & " MB", 205, 245, 80)
   Global $macheader = GUICtrlCreateLabel("MAC Address:", 195, 265, 80)
   GUICtrlSetFont($macheader, 8, 800, 0, "MS Sans Serif")
   $macaddress = GUICtrlCreateLabel($mac[$pcnumber], 195, 280, 100)
   Global $cpunameheader = GUICtrlCreateLabel("CPU Type:", 5, 300, 80)
   GUICtrlSetFont($cpunameheader, 8, 800, 0, "MS Sans Serif")
   $cpunamelabel = GUICtrlCreateLabel($cpuname[$pcnumber], 5, 315, 210)
   Global $cpumhzheader = GUICtrlCreateLabel("CPU Speed:", 220, 300, 80)
   GUICtrlSetFont($cpumhzheader, 8, 800, 0, "MS Sans Serif")
   $cpumhzlabel = GUICtrlCreateLabel($cpumhz[$pcnumber] & " MHz", 220, 315, 80)
   $hdtab = GUICtrlCreateTabItem("Drives")
   Global $drvcheader = GUICtrlCreateLabel("Drive C:", 5, 230, 90)
   GUICtrlSetFont($drvcheader, 8, 800, 0, "MS Sans Serif")
   $drvclabel = GUICtrlCreateLabel("Size: " & Round($drvcfree[$pcnumber] / 1024, 2) & " GB / " & Round($drvcsize[$pcnumber] / 1024, 2) & " GB", 5, 245, 150)
   Global $drvdheader = GUICtrlCreateLabel("Drive D:", 150, 230, 90)
   GUICtrlSetFont($drvdheader, 8, 800, 0, "MS Sans Serif")
   $drvdlabel = GUICtrlCreateLabel("Size: " & Round($drvdfree[$pcnumber] / 1024, 2) & " GB / " & Round($drvdsize[$pcnumber] / 1024, 2) & " GB", 150, 245, 150)
   Global $drveheader = GUICtrlCreateLabel("Drive E:", 5, 265, 90)
   GUICtrlSetFont($drveheader, 8, 800, 0, "MS Sans Serif")
   $drvelabel = GUICtrlCreateLabel("Size: " & Round($drvefree[$pcnumber] / 1024, 2) & " GB / " & Round($drvesize[$pcnumber] / 1024, 2) & " GB", 5, 280, 150)
   Global $drvfheader = GUICtrlCreateLabel("Drive F:", 150, 265, 90)
   GUICtrlSetFont($drvfheader, 8, 800, 0, "MS Sans Serif")
   $drvflabel = GUICtrlCreateLabel("Size: " & Round($drvffree[$pcnumber] / 1024, 2) & " GB / " & Round($drvffree[$pcnumber] / 1024, 2) & " GB", 150, 280, 150)
   Global $notesdbheader = GUICtrlCreateLabel("Notes DB Size:", 5, 300, 95)
   GUICtrlSetFont($notesdbheader, 8, 800, 0, "MS Sans Serif")
   $notesdblabel = GUICtrlCreateLabel($notesdb[$pcnumber], 5, 315, 80)
   
   
   GUISetState(@SW_DISABLE, $domaingui)
   GUISwitch($servicesgui)
   GUISetState(@SW_ENABLE, $servicesgui)
   GUISetState(@SW_SHOW, $servicesgui)
   
   GUISetOnEvent($GUI_EVENT_CLOSE, "_SvcExit")
   GUICtrlSetOnEvent($startbutton, "_StartPCService")
   GUICtrlSetOnEvent($stopbutton, "_StopPCService")
EndFunc

; End GUI Display Functions
; GUI Update Functions

Func _ListPCs()
   Global $subcheckboxstatus = GUICtrlRead($subnetcheckbox)
   Global $ipcheckboxstatus = GUICtrlRead($ipcheckbox)
   GUICtrlSetState($listpcbutton, $GUI_DISABLE)
   GUICtrlSetState($subnetcheckbox, $GUI_DISABLE)
   GUICtrlSetState($ipcheckbox, $GUI_DISABLE)
   Global $listpcstart = TimerInit()
   For $i = 1 To $lines[0]
      $timerstart[$i] = TimerInit()
         $compname[$i] = StringStripWS($lines[$i], 7)
         If $ipcheckboxstatus = 1 Then
            RunWait(@ComSpec & " /c ping -n 1 -l 1 -w " & $pingdelay & " " & $compname[$i] & " > " & @TempDir & "\tempip.txt", "", @SW_HIDE)
            $parse = FileRead(@TempDir & "\tempip.txt", 5000)
            $ipaddr[$i] = StringTrimLeft($parse, StringInStr($parse, "["))
            $ipaddr[$i] = StringLeft($ipaddr[$i], StringInStr($ipaddr[$i], "]") - 1)
         Else
            $pcs = $pcs + 1
            $comp[$pcs] = $compname[$i]
            $item[$i] = GUICtrlCreateListViewItem($compname[$i] & "|" & "", $listview)
         EndIf
         
         If $subcheckboxstatus = 1 Then
            If $ipaddr[$i] <> "" Then
               $samesub = _SameSub ($ipaddr[$i], $subnetinfo[1], $subnetinfo[2])
               If $samesub = 1 Then
                  $item[$i] = GUICtrlCreateListViewItem($compname[$i] & "|" & $ipaddr[$i], $listview)
                  $pcs = $pcs + 1
                  $comp[$pcs] = $compname[$i]
                  $ips[$pcs] = $ipaddr[$i]
               EndIf
            EndIf
         EndIf
         
         If $ipcheckboxstatus = 1 And $subcheckboxstatus = 4 Then
            If $ipaddr[$i] <> "" Then
               $item[$i] = GUICtrlCreateListViewItem($compname[$i] & "|" & $ipaddr[$i], $listview)
               $pcs = $pcs + 1
               $comp[$pcs] = $compname[$i]
               $ips[$pcs] = $ipaddr[$i]
            EndIf
         EndIf
         
         FileDelete(@TempDir & "\tempip.txt")
		 
      GUICtrlSetData($progressbar, ($i * (100 / $progress)))
      $pctimer[$i] = TimerDiff($timerstart[$i]) / 1000
      $pctime = $pctime + $pctimer[$i]
      $pcavg = $pctime / $i
      $remain = Int( ($pcavg * $lines[0]) - ($pcavg * $i))
      GUICtrlSetData($remainlabel, "Time Remaining: " & $remain & "s")
   Next
   $totallisttime = Int(TimerDiff($listpcstart) / 1000)
   GUICtrlSetData($remainlabel, "Total Scan Time: " & $totallisttime & "s")
   GUISetState()
   GUICtrlSetState($pcinfobutton, $GUI_ENABLE)
EndFunc

Func _PCInfo()
   Global $pcnumber = GUICtrlRead($listview) - 9
   If $pcnumber = -9 Then
      Return
   EndIf
   If _ServiceRunning ($comp[$pcnumber], "RemoteRegistry") And _ServiceRunning ($comp[$pcnumber], "winmgmt") And _ServiceRunning ($comp[$pcnumber], "lanmanserver") Then
      GUICtrlSetData($pcinfobutton, "Wait")
      GUICtrlSetState($pcinfobutton, $GUI_DISABLE)
      If $ipcheckboxstatus = 4 Then
         TrayTip("Checking IP Address", $comp[$pcnumber], 5000)
         RunWait(@ComSpec & " /c ping -n 1 -l 1 -w " & $pingdelay & " " & $comp[$pcnumber] & " > " & @TempDir & "\tempip.txt", "", @SW_HIDE)
         $parse = FileRead(@TempDir & "\tempip.txt", 5000)
         $ipadd = StringTrimLeft($parse, StringInStr($parse, "["))
         $ipadd = StringLeft($ipadd, StringInStr($ipadd, "]") - 1)
         $ip[$pcnumber] = $ipadd
      Else
         $ip[$pcnumber] = $ips[$pcnumber]
      EndIf
      TrayTip("Checking PC Info", $comp[$pcnumber], 30)
      RunWait(@ComSpec & " /c " & "cscript //T:10 //nologo " & @TempDir & "\pcinfo.vbs " & $comp[$pcnumber] & " > " & @TempDir & "\pcinfo.txt", "", @SW_HIDE)
      $os[$pcnumber] = StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 1), 4)
      If $os[$pcnumber] = "" Then
         MsgBox(0, $comp[$pcnumber], "Cannot display computer information.")
         TrayTip("", "", 0)
         GUICtrlSetData($pcinfobutton, "PC Info")
         GUICtrlSetState($pcinfobutton, $GUI_ENABLE)
         Return
      Else
         $service_pack[$pcnumber] = StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 2), 14)
         $tempinstalldate = StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 3), 9)
         $installdateyear = StringLeft($tempinstalldate, 4)
         $installdatemonth = _DateMonthOfYear (StringMid($tempinstalldate, 5, 2), 1)
         $installdateday = StringMid($tempinstalldate, 7, 2)
         $install_date[$pcnumber] = $installdatemonth & " " & $installdateday & ", " & $installdateyear
         $tempbootdate = StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 4), 11)
         If $tempbootdate = "" Then
            $boot_date[$pcnumber] = "N/A"
         Else
            $bootdateyear = StringLeft($tempbootdate, 4)
            $bootdatemonth = _DateMonthOfYear (StringMid($tempbootdate, 5, 2), 1)
            $bootdateday = StringMid($tempbootdate, 7, 2)
            $bootdatehour = StringMid($tempbootdate, 9, 2)
            If $bootdatehour > 12 Then
               $bootdatehour = $bootdatehour - 12
               $meridian = "PM"
            Else
               $meridian = "AM"
            EndIf
            If $bootdatehour = 0 Then
               $bootdatehour = 12
               $meridian = "AM"
            EndIf
            $bootdatemin = StringMid($tempbootdate, 11, 2)
            $bootdatesec = StringMid($tempbootdate, 13, 2)
            $boot_date[$pcnumber] = $bootdatemonth & " " & $bootdateday & ", " & $bootdateyear & " " & $bootdatehour & ":" & $bootdatemin & " " & $meridian
         EndIf
         $pcvendor[$pcnumber] = StringStripWS(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 5), 8), 7)
         If $pcvendor[$pcnumber] = "" Then
            $pcvendor[$pcnumber] = "N/A"
         EndIf
         $pcmodel[$pcnumber] = StringStripWS(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 6), 7), 7)
         If $pcmodel[$pcnumber] = "" Then
            $pcmodel[$pcnumber] = "N/A"
         EndIf
         $pcserial[$pcnumber] = StringStripWS(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 7), 8), 7)
         If $pcserial[$pcnumber] = "" Then
            $pcserial[$pcnumber] = "N/A"
         EndIf
         Dim $ramtemp
		 For $i = 14 To 30
            If StringInStr(FileReadLine(@TempDir & "\pcinfo.txt", $i), "RAM:") Then
               $ramtemp = $ramtemp + Number(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", $i), 4))
            EndIf
         Next
         $ram[$pcnumber] = $ramtemp
         $mac[$pcnumber] = StringStripWS(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 9), 5), 7)
		 If $mac[$pcnumber] = "" Then
			 $mac[$pcnumber] = "N/A"
		 EndIf
		 $invusercheck = StringInStr(FileReadLine(@TempDir & "\pcinfo.txt", 13), "\", "", 2)
      If $invusercheck > 0 Then
         $username[$pcnumber] = "Error"
      Else
         $username[$pcnumber] = StringStripWS(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 13), StringInStr(FileReadLine(@TempDir & "\pcinfo.txt", 13), "\")), 2)
      EndIf
      EndIf
      TrayTip("Checking CPU Type", $comp[$pcnumber], 30)
      $cpumhz[$pcnumber] = RegRead("\\" & $comp[$pcnumber] & "\HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz")
      $cpuname[$pcnumber] = StringStripWS(RegRead("\\" & $comp[$pcnumber] & "\HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString"), 7)
      If $cpuname[$pcnumber] = "" Then
         $cpuname[$pcnumber] = StringStripWS(RegRead("\\" & $comp[$pcnumber] & "\HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "Identifier"), 3)
      EndIf
      TrayTip("Checking CD Key", $comp[$pcnumber], 30)
      $dpid = RegRead("\\" & $comp[$pcnumber] & "\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")
      $cdkey[$pcnumber] = _DecodeProductKey($dpid)
      TrayTip("Checking Notes Size", $comp[$pcnumber], 30)
      $notesdb[$pcnumber] = _CheckNotes($comp[$pcnumber])
      TrayTip("Checking Hard Drive Space", $comp[$pcnumber], 30)
      $drvcsize[$pcnumber] = DriveSpaceTotal("\\" & $comp[$pcnumber] & "\c$")
      $drvcfree[$pcnumber] = DriveSpaceFree("\\" & $comp[$pcnumber] & "\c$")
      $drvcused[$pcnumber] = $drvcsize - $drvcfree
      $drvdsize[$pcnumber] = DriveSpaceTotal("\\" & $comp[$pcnumber] & "\d$")
      $drvdfree[$pcnumber] = DriveSpaceFree("\\" & $comp[$pcnumber] & "\d$")
      $drvdused[$pcnumber] = $drvdsize - $drvdfree
      $drvesize[$pcnumber] = DriveSpaceTotal("\\" & $comp[$pcnumber] & "\e$")
      $drvefree[$pcnumber] = DriveSpaceFree("\\" & $comp[$pcnumber] & "\e$")
      $drveused[$pcnumber] = $drvesize - $drvefree
      TrayTip("", "", 0)
      _DisplayServicesGUI()
      GUICtrlSetData($pcinfobutton, "PC Info")
      GUICtrlSetState($pcinfobutton, $GUI_ENABLE)
   EndIf
EndFunc

Func _ServicesListView()
   Global $servicerealname[$slines[0]]
   Global $servicename[$slines[0]]
   Global $servicestatus[$slines[0]]
   Global $service1occur[$slines[0]]
   Global $service2occur[$slines[0]]
   Global $service[$slines[0]]
   Global $combos = GUICtrlCreateListView("Service Name | Status", 0, 0, 300, 186, $LVS_NOSORTHEADER + $LVS_SINGLESEL)
   
   For $i = 1 to ($slines[0] - 1)
      $service1occur[$i] = StringInStr($slines[$i], " : ", "", 1)
      $service2occur[$i] = StringInStr($slines[$i], " : ", "", 2)
      $servicerealname[$i] = StringLeft($slines[$i], ($service1occur[$i] - 1))
      $servicename[$i] = StringMid($slines[$i], ($service1occur[$i] + 3) , ($service2occur[$i] - $service1occur[$i] - 3))
      $servicestatus[$i] = StringTrimLeft($slines[$i], $service2occur[$i] + 2)
      $service[$i] = GUICtrlCreateListViewItem($servicerealname[$i] & "|" & $servicestatus[$i], $combos)
   Next
EndFunc

Func _RefreshServices()
   Global $svcupstatus[$slines[0]]
   If $noservices = $slines[0] Then
      For $i = 1 to ($slines[0] - 1)
         $svcup2occur = StringInStr($slines[$i], " : ", "", 2)
         $svcupstatus[$i] = StringStripWS(StringTrimLeft($slines[$i], $svcup2occur + 2), 2)
         GUICtrlSetData($service[$i], "|" & $svcupstatus[$i])
      Next
   EndIf
EndFunc

Func _UpdateService()
   RunWait(@ComSpec & " /c cscript //T:10 //nologo " & @TempDir & "\serviceupdate.vbs " & $comp[$pcnumber] & " > " & @TempDir & "\serviceupdate.txt", "", @SW_HIDE)
   $serviceupdate = @TempDir & "\serviceupdate.txt"
   $svcupdtext = FileRead($serviceupdate, FileGetSize($serviceupdate))
   $svcup2occur = StringInStr($svcupdtext, " : ", "", 2)
   $svcupstatus = StringStripWS(StringTrimLeft($svcupdtext, $svcup2occur + 2), 2)
   GUICtrlSetData($service[$linenumber], "|" & $svcupstatus)
EndFunc

Func _GetIPSub()
   RunWait(@ComSpec & " /c " & "cscript //T:10 //nologo " & @TempDir & "\pcinfo.vbs " & @ComputerName & " > " & @TempDir & "\pcinfo.txt", "", @SW_HIDE)
   Global $netmask = StringStripWS(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 11), 8), 7)
   Global $localip = StringStripWS(StringTrimLeft(FileReadLine(@TempDir & "\pcinfo.txt", 8), 4), 7)
   Global $subnetinfo = _Subnet ($localip, $netmask)
   If $subnetinfo = 0 Then
      MsgBox(0, "Error", "Invalid Subnet Mask")
      Exit
   EndIf
   If $subnetinfo = -1 Then
      MsgBox(0, "Error", "Invalid IP Address")
      Exit
   EndIf
EndFunc

Func _SubnetCheckbox()
   If GUICtrlRead($subnetcheckbox) = 1 Then
      GUICtrlSetState($ipcheckbox, $GUI_CHECKED)
      GUICtrlSetState($ipcheckbox, $GUI_DISABLE)
   Else
      GUICtrlSetState($ipcheckbox, $GUI_ENABLE)
   EndIf
EndFunc

; End GUI Update Functions
; Service Functions

Func _CheckServices()
   Global $slines[500]
   If FileExists(@TempDir & "\services.txt") Then
      FileDelete(@TempDir & "\services.txt")
   EndIf
   RunWait(@ComSpec & " /c cscript //T:10 //nologo " & @TempDir & "\services.vbs " & $comp[$pcnumber] & " | sort > " & @TempDir & "\services.txt", "", @SW_HIDE)
   $services = @TempDir & "\services.txt"
   $slines = StringReplace(FileRead($services, FileGetSize($services)), @LF, "|")
   $slines = StringReplace($slines, Chr(9), "")
   $slines = StringReplace($slines, @CR, "")
   $slines = StringSplit($slines, "|")
   $run = $run + 1
   If $run = 1 Then
      Global $noservices = $slines[0]
   EndIf
EndFunc

Func _StartPCService()
   Global $linenumber = GUICtrlRead($combos) - 6
   If Not _ServiceRunning ($comp[$pcnumber], $servicename[$linenumber]) Then
      _StartService ($comp[$pcnumber], $servicename[$linenumber])
      _CreateUpdateServiceScript()
      _UpdateService()
   EndIf
EndFunc
Func _StopPCService()
   Global $linenumber = GUICtrlRead($combos) - 6
   If _ServiceRunning ($comp[$pcnumber], $servicename[$linenumber]) Then
      _StopService ($comp[$pcnumber], $servicename[$linenumber])
      _CreateUpdateServiceScript()
      _UpdateService()
   EndIf
EndFunc
Func _RefreshPCService()
   Global $linenumber = GUICtrlRead($combos) - 6
   _CheckServices()
   _RefreshServices()
EndFunc

; End Service Functions

Func _SvcExit()
   $run = 0
   HotKeySet( "{F5}")
   GUIDelete($servicesgui)
   GUISetState(@SW_RESTORE, $domaingui)
   GUISetState(@SW_ENABLE, $domaingui)
   GUISwitch($domaingui)
   Return
EndFunc

Func _DomainViewExit()
   _FileCleanUp()
   Exit
EndFunc

Func _FileCleanUp()
   If FileExists(@TempDir & "\pcinfo.vbs") Then
      FileDelete(@TempDir & "\pcinfo.vbs")
   EndIf
   If FileExists(@TempDir & "\pcinfo.txt") Then
      FileDelete(@TempDir & "\pcinfo.txt")
   EndIf
   If FileExists(@TempDir & "\tempip.txt") Then
      FileDelete(@TempDir & "\tempip.txt")
   EndIf
   If FileExists(@TempDir & "\services.txt") Then
      FileDelete(@TempDir & "\services.txt")
   EndIf
   If FileExists(@TempDir & "\services.vbs") Then
      FileDelete(@TempDir & "\services.vbs")
   EndIf
   If FileExists(@TempDir & "\serviceupdate.vbs") Then
      FileDelete(@TempDir & "\serviceupdate.vbs")
   EndIf
   If FileExists(@TempDir & "\serviceupdate.txt") Then
      FileDelete(@TempDir & "\serviceupdate.txt")
   EndIf
EndFunc

; Script Creation
Func _CreatePCInfoScript()
   $pcinfoscript = FileOpen(@TempDir & "\pcinfo.vbs", 2)
   If $pcinfoscript = -1 Then
      Exit
   EndIf
;   FileWriteLine($pcinfoscript, 'On Error Resume Next' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set oShell = CreateObject("wscript.Shell")' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set env = oShell.environment("Process")' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set objArgs = WScript.Arguments' & @CRLF)
   FileWriteLine($pcinfoscript, 'For Each strArg in objArgs' & @CRLF)
   FileWriteLine($pcinfoscript, 'strComputer = strArg' & @CRLF)
   FileWriteLine($pcinfoscript, 'Next' & @CRLF)
   FileWriteLine($pcinfoscript, 'Const HKEY_LOCAL_MACHINE = &H80000002' & @CRLF)
   FileWriteLine($pcinfoscript, 'Const UnInstPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" &_' & @CRLF)
   FileWriteLine($pcinfoscript, '".\root\default:StdRegProv")' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set colItems = objWMIService.ExecQuery("Select Caption, ServicePackMajorVersion, InstallDate, LastBootUpTime from Win32_OperatingSystem",,48)' & @CRLF)
   FileWriteLine($pcinfoscript, 'For Each objItem in colItems' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "OS: " & objItem.Caption' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "Service Pack: " & objItem.ServicePackMajorVersion' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "Install: " & objItem.InstallDate' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "Last Boot: " & objItem.LastBootUpTime' & @CRLF)
   FileWriteLine($pcinfoscript, 'Next' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set objWbem = GetObject("winmgmts:\\" & strComputer)' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set objWbemObjectSet = objWbem.ExecQuery("Select Vendor, Name, IdentifyingNumber From Win32_ComputerSystemProduct")' & @CRLF)
   FileWriteLine($pcinfoscript, 'For Each objWbemObject In objWbemObjectSet' & @CRLF)
   FileWriteLine($pcinfoscript, 'WScript.Echo "Vendor: " & objWbemObject.Properties_("Vendor")' & @CRLF)
   FileWriteLine($pcinfoscript, 'WScript.Echo "Model: " & objWbemObject.Properties_("Name")' & @CRLF)
   FileWriteLine($pcinfoscript, 'WScript.Echo "Serial: " & objWbemObject.Properties_("IdentifyingNumber")' & @CRLF)
   FileWriteLine($pcinfoscript, 'Next' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set colAdapters = objWMIService.ExecQuery _' & @CRLF)
   FileWriteLine($pcinfoscript, '("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled = True")' & @CRLF)
   FileWriteLine($pcinfoscript, 'For Each objAdapter in colAdapters' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "IP: " & objAdapter.IPAddress(i)' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "MAC: " & objAdapter.MACAddress' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "DHCP: " & objAdapter.DHCPEnabled' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "Subnet: " & objAdapter.IPSubnet(i)' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "Gateway: " & objAdapter.DefaultIPGateway(i)' & @CRLF)
   FileWriteLine($pcinfoscript, 'Next' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set Service = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _' & @CRLF)
   FileWriteLine($pcinfoscript, 'strComputer & "\root\cimv2")' & @CRLF)
   FileWriteLine($pcinfoscript, 'Set ObjectSet = Service.InstancesOf("Win32_ComputerSystem")' & @CRLF)
   FileWriteLine($pcinfoscript, 'For Each Object In ObjectSet' & @CRLF)
   FileWriteLine($pcinfoscript, 'If IsNull(Object.Username) Then' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "Not Logged In"' & @CRLF)
   FileWriteLine($pcinfoscript, 'Else' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "Username: " & Object.Username' & @CRLF)
   FileWriteLine($pcinfoscript, 'End If' & @CRLF)
   FileWriteLine($pcinfoscript, 'Next' & @CRLF)
   FileWriteLine($pcinfoscript, 'for each memory in objWMIService.InstancesOf("Win32_PhysicalMemory")' & @CRLF)
   FileWriteLine($pcinfoscript, 'wscript.echo "RAM: " & memory.capacity' & @CRLF)
   FileWriteLine($pcinfoscript, 'next' & @CRLF)
   FileClose($pcinfoscript)
EndFunc

Func _CreateServiceScript()
   $vbservice = FileOpen(@TempDir & "\services.vbs", 2)
   If $vbservice = -1 Then
      Exit
   EndIf
   FileWriteLine($vbservice, 'On Error Resume Next' & @CRLF)
   FileWriteLine($vbservice, 'Set oShell = CreateObject("wscript.Shell")' & @CRLF)
   FileWriteLine($vbservice, 'Set env = oShell.environment("Process")' & @CRLF)
   FileWriteLine($vbservice, 'Set objArgs = WScript.Arguments' & @CRLF)
   FileWriteLine($vbservice, 'For Each strArg in objArgs' & @CRLF)
   FileWriteLine($vbservice, 'strComputer = strArg' & @CRLF)
   FileWriteLine($vbservice, 'Next' & @CRLF)
   FileWriteLine($vbservice, 'Set objWMIService = GetObject("winmgmts:" _' & @CRLF)
   FileWriteLine($vbservice, '& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")' & @CRLF)
   FileWriteLine($vbservice, 'Set colRunningServices = objWMIService.ExecQuery _' & @CRLF)
   FileWriteLine($vbservice, '("Select * from Win32_Service")' & @CRLF)
   FileWriteLine($vbservice, 'For Each objService in colRunningServices' & @CRLF)
   FileWriteLine($vbservice, 'Wscript.Echo objService.DisplayName & " : " & objService.Name & " : " & objService.State' & @CRLF)
   FileWriteLine($vbservice, 'Next' & @CRLF)
   FileClose($vbservice)
EndFunc

Func _CreateUpdateServiceScript()
   $vbserviceupdate = FileOpen(@TempDir & "\serviceupdate.vbs", 2)
   If $vbserviceupdate = -1 Then
      Exit
   EndIf
   FileWriteLine($vbserviceupdate, 'On Error Resume Next' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Set oShell = CreateObject("wscript.Shell")' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Set env = oShell.environment("Process")' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Set objArgs = WScript.Arguments' & @CRLF)
   FileWriteLine($vbserviceupdate, 'For Each strArg in objArgs' & @CRLF)
   FileWriteLine($vbserviceupdate, 'strComputer = strArg' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Next' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Set objWMIService = GetObject("winmgmts:" _' & @CRLF)
   FileWriteLine($vbserviceupdate, '& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Set colListOfServices = objWMIService.ExecQuery _' & @CRLF)
   FileWriteLine($vbserviceupdate, '("Select * from Win32_Service Where Name =' & "'" & $servicename[$linenumber] & "'" & '")' & @CRLF)
   FileWriteLine($vbserviceupdate, 'For Each objService in colListOfServices' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Wscript.echo objService.DisplayName & " : " & objService.Name & " : " & objService.State' & @CRLF)
   FileWriteLine($vbserviceupdate, 'Next' & @CRLF)
   FileClose($vbserviceupdate)
EndFunc

; End Script Creation

; Windows Product Key Function from Wb-FreeKill
Func _DecodeProductKey($BinaryDPID)
   Local $bKey[15]
   Local $sKey[29]
   Local $Digits[24]
   Local $Value = 0
   Local $hi = 0
   Local $n = 0
   Local $i = 0
   Local $dlen = 29
   Local $slen = 15
   Local $Result
   
   $Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789", "")
   
   $BinaryDPID = StringMid($BinaryDPID, 105, 30)
   
   For $i = 1 To 29 Step 2
      $bKey[Int($i / 2) ] = Dec(StringMid($BinaryDPID, $i, 2))
   Next
   
   For $i = $dlen - 1 To 0 Step - 1
      If Mod( ($i + 1), 6) = 0 Then
         $sKey[$i] = "-"
      Else
         $hi = 0
         For $n = $slen - 1 To 0 Step - 1
            $Value = BitOR(BitShift($hi, -8), $bKey[$n])
            $bKey[$n] = Int($Value / 24)
            $hi = Mod($Value, 24)
         Next
         $sKey[$i] = $Digits[$hi + 1]
      EndIf
      
   Next
   For $i = 0 To 28
      $Result = $Result & $sKey[$i]
   Next
   
   Return $Result
EndFunc

Func _CheckNotes($computer)
   $notesdata = RegRead("\\" & $computer & "\HKEY_LOCAL_MACHINE\SOFTWARE\Lotus\Notes", "DataPath")
   If @error Then
      $mailsize = "N/A"
      Return $mailsize
   Else
      $notesdatadrive = StringLeft($notesdata, 1)
      $notesdata = StringTrimLeft($notesdata, 2)
      $mailsize = DirGetSize("\\" & $computer & "\" & $notesdatadrive & "$\" & $notesdata & "\mail")
      If $mailsize = -1 Then
         $mailsize = "N/A"
         Return $mailsize
      Else
         Return Round($mailsize / 1024 / 1024, 2) & " MB"
      EndIf
   EndIf
EndFunc

Func _NetView($sDomain, $sSvrWrk)
   Global Const $SV_TYPE_WORKSTATION = 0x00000001
   Global Const $SV_TYPE_SERVER = 0x00000002
   Global Const $SV_TYPE_SQLSERVER = 0x00000004
   Global Const $SV_TYPE_DOMAIN_CTRL = 0x00000008
   Global Const $SV_TYPE_DOMAIN_BAKCTRL = 0x00000010
   Global Const $SV_TYPE_TIME_SOURCE = 0x00000020
   Global Const $SV_TYPE_AFP = 0x00000040
   Global Const $SV_TYPE_NOVELL = 0x00000080
   Global Const $SV_TYPE_DOMAIN_MEMBER = 0x00000100
   Global Const $SV_TYPE_PRINTQ_SERVER = 0x00000200
   Global Const $SV_TYPE_DIALIN_SERVER = 0x00000400
   Global Const $SV_TYPE_XENIX_SERVER = 0x00000800
   Global Const $SV_TYPE_SERVER_UNIX = $SV_TYPE_XENIX_SERVER
   Global Const $SV_TYPE_NT = 0x00001000
   Global Const $SV_TYPE_WFW = 0x00002000
   Global Const $SV_TYPE_SERVER_MFPN = 0x00004000
   Global Const $SV_TYPE_SERVER_NT = 0x00008000
   Global Const $SV_TYPE_POTENTIAL_BROWSER = 0x00010000
   Global Const $SV_TYPE_BACKUP_BROWSER = 0x00020000
   Global Const $SV_TYPE_MASTER_BROWSER = 0x00040000
   Global Const $SV_TYPE_DOMAIN_MASTER = 0x00080000
   Global Const $SV_TYPE_SERVER_OSF = 0x00100000
   Global Const $SV_TYPE_SERVER_VMS = 0x00200000
   ; Windows95 and above
   Global Const $SV_TYPE_WINDOWS = 0x00400000
   ; Root of a DFS tree
   Global Const $SV_TYPE_DFS = 0x00800000
   ; NT Cluster
   Global Const $SV_TYPE_CLUSTER_NT = 0x01000000
   ; Terminal Server(Hydra)
   Global Const $SV_TYPE_TERMINALSERVER = 0x02000000
   ; NT Cluster Virtual Server Name
   Global Const $SV_TYPE_CLUSTER_VS_NT = 0x04000000
   ; Return local list only
   Global Const $SV_TYPE_LOCAL_LIST_ONLY = 0x40000000
   Global Const $SV_TYPE_DOMAIN_ENUM = 0x80000000
   Global Const $SV_TYPE_ALL = 0xFFFFFFFF
   
   Dim $aDllRet, $i
   Dim $hAU3Xtra
   Dim $netview[2000]
   
   If $sSvrWrk = "Workstation" Then
      $sSvrWrk = $SV_TYPE_WORKSTATION
   ElseIf $sSvrWrk = "Server" Then
      $sSvrWrk = $SV_TYPE_SERVER_NT
   EndIf
   $hAU3Xtra = DllOpen(@TempDir & "\AU3XtraTest.dll")
   If $hAU3Xtra > - 1 Then
      $aDllRet = DllCall($hAU3Xtra, "long", "NetViewFind", _
            "long", $sSvrWrk, _ 
      "int", $sDomain)
      If Not @error And $aDllRet[0] > 0 Then
         $i = 0
         While $aDllRet[0] > 0
            $aDllRet = DllCall($hAU3Xtra, "long", "NetViewEnum", _
                  "str", "", _ 
            "str", "", _
                  "long_ptr", 0)
            If @error Then
               MsgBox(262144, 'debug line ~826', '@error:' & @LF & @error) ;### Debug MSGBOX
               ExitLoop
            EndIf
            $i = $i + 1
			$netview[$i] = ($aDllRet[1] & @LF)
		 WEnd
		 $netview[0] = $i
      EndIf
      DllCall($hAU3Xtra, "none", "NetViewClose")
      DllClose($hAU3Xtra)
   EndIf
   Return ($netview)
EndFunc