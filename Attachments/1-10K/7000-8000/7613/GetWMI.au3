#include <GUIConstants.au3>
#include <File.au3>
#Include <Array.au3>
#include <GuiList.au3>
Opt("RunErrorsFatal", 1)   ;1=fatal, 0=silent set @error
Opt("GUICoordMode",1)
Opt("GUIOnEventMode",1)
Opt("GUIResizeMode", 0)
Opt("WinTitleMatchMode", 1) ;1=start, 2=subStr, 3=exact, 4=advanced


Global $GUI0,$GUI1,$Gui_OS, $GUI_AdminGroup, $GUI_NetworkAdapters
Global $GUI_LoggedOnUsers, $GUI_LogicalDisks
Global $objWMI, $Input0, $objOS, $strCompName

$GUI0 = GuiCreate("Get WMI Infos", 600, 500,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetFont($GUI0,10,-1,"MS Sans Serif")

$Group0=GUICtrlCreateGroup("Ping Status",3,3,590,490,-1,-1)
$Input0 = GuiCtrlCreateInput(String(@ComputerName), 40, 50, 150, 20)
$start = GUICtrlCreateButton ("Start", 200,50,75,25)
GUICtrlSetOnEvent($start, "funcPing")
$button_more = GUICtrlCreateButton ("Get more...", 285,50,75,25)
GUICtrlSetOnEvent($button_more, "funcStart")
GUICtrlSetState($button_more,$GUI_DISABLE)

$listview = GUICtrlCreateListView("Name                             |Value                        ", _
   40,100,500,350,$LVS_SHOWSELALWAYS,$LVS_EX_FULLROWSELECT+$LVS_EX_TRACKSELECT)
;+$LVS_REPORT

$Button_StartIE = GUICtrlCreateButton ("Start Explorer", 370,50,100,25)
GUICtrlSetOnEvent($Button_StartIE, "funcStartIE")
GUICtrlSetState($Button_StartIE,$GUI_DISABLE)

GUISetOnEvent($GUI_EVENT_CLOSE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "funcWindowEvents")

GUISetState(@SW_SHOW)
; Run the GUI until the dialog is closed
While 1
   Sleep(10)
Wend

Exit
; End of script
;///////////////////////////////////////////////////////////////////////////////
Func funcPing()

   $compname = String(GUICtrlRead($Input0))
   $objWMILocalService = ObjGet("winmgmts:\\.\root\CIMV2")
   $objPing = $objWMILocalService.ExecQuery("select * from Win32_PingStatus where address = '" & $compname & "'")

   for $objItem in $objPing
      GuiCtrlCreateListViewItem("Address|" & $objItem.Address, $listview)
      if ($objItem.ProtocolAddress = "") or ($objItem.StatusCode <> 0) then
         GuiCtrlCreateListViewItem("Protocol Address|" & $compname & " is not reachable.", $listview)
      else
         GuiCtrlCreateListViewItem("Protocol Address|" & $objItem.ProtocolAddress, $listview)
         GUICtrlSetState($button_more,$GUI_ENABLE)
         GUICtrlSetState($Button_StartIE,$GUI_ENABLE)
      endif
      GuiCtrlCreateListViewItem("Protocol Address Resolved| " & $objItem.ProtocolAddressResolved, $listview)
      GuiCtrlCreateListViewItem("Resolved Address Names", $objItem.ResolveAddressNames & "|")
      GuiCtrlCreateListViewItem("Time|" & $objItem.ResponseTime, $listview)
      GuiCtrlCreateListViewItem("TTL|" & $objItem.ResponseTimeToLive, $listview)
      GuiCtrlCreateListViewItem("Status|" & $objItem.StatusCode, $listview)
      GuiCtrlCreateListViewItem("Timeout|" & $objItem.Timeout, $listview)

   next

Endfunc
;///////////////////////////////////////////////////////////////////////////////
Func funcStart()

   $tempname = GUICtrlRead($Input0)
   funcMessageWindow("Please wait ...","Getting WMI Data ...",FALSE)
   funcOS()
   funcGetAdminAccounts()
   funcNetworkAdapters()
   funcLoggedOnUsers()
   funcLogicalDisks()
   WinMove("Get WMI Infos","",0,0)
   WINACTIVATE("Get","")
   WinMove("OS Settings","",20,20)
   WINACTIVATE("OS Settings","")
   WinMove("Network Adapter","",40,40)
   WINACTIVATE("Network","")
   WinMove("Local Admins","",60,60)
   WINACTIVATE("Local","")
   WinMove("LoggedOn Users and Shares","",80,80)
   WINACTIVATE("LoggedOn","")
   WinMove("Logical Disks","",100,100)
   WINACTIVATE("Logical","")
   
   ;funcMessageWindow("Please wait ...","Getting WMI Data ...",TRUE)
   
EndFunc
;///////////////////////////////////////////////////////////////////////////////
Func funcStartIE()

$strTempIE = String(GUICtrlRead($Input0))
Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe \\" & $strTempIE & _
  "\c$", @ProgramFilesDir, @SW_SHOW)
;Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe", @ProgramFilesDir, @SW_SHOW)

Endfunc
;///////////////////////////////////////////////////////////////////////////////
Func funcLogicalDisks()

$GUI_LogicalDisks = GuiCreate("Logical Disks", 600, 500,-1, -1 , _
   BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetFont($GUI_LogicalDisks,10,-1,"MS Sans Serif")

$Group_LogicalDisks=GUICtrlCreateGroup("Logical Disks",3,3,590,490,-1,-1)
$Input_LogicalDisks = GuiCtrlCreateInput(GUICtrlRead($Input0), 40, 50, 150, 20)
;$Button_OS = GUICtrlCreateButton ("Refresh...", 200,50,75,25)
;GUICtrlSetOnEvent($Button_OS, "func")
$Listview_LogicalDisks = GUICtrlCreateListView("Name                             |Value                        ", _
   40,100,500,350,$LVS_SHOWSELALWAYS,$LVS_EX_FULLROWSELECT+$LVS_EX_TRACKSELECT)

GUISetOnEvent($GUI_EVENT_CLOSE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "funcWindowEvents")
GUISwitch($GUI_LogicalDisks)
GUISetState(@SW_SHOW)

$objLogicalDisks = $objWMI.ExecQuery("SELECT * FROM Win32_LogicalDisk")
;(FileSystem = 'NTFS')
if @error then msgbox(0,"Error", "Code " & @error)

For $objLogicaldisk in $objLogicalDisks
   GUICtrlCreateListViewItem("Description|" & $objLogicaldisk.Description,$Listview_LogicalDisks)
   GUICtrlCreateListViewItem("Device ID|" & $objLogicaldisk.DeviceID,$Listview_LogicalDisks)
   GUICtrlCreateListViewItem("File System|" & $objLogicaldisk.FileSystem,$Listview_LogicalDisks)
   GUICtrlCreateListViewItem("Free Space|" & Int($objLogicaldisk.FreeSpace/1024/1024) & " MB",$Listview_LogicalDisks)
   ;GUICtrlCreateListViewItem("Name|" & $objLogicaldisk.Name,$Listview_LogicalDisks)
   GUICtrlCreateListViewItem("Size|" & Int($objLogicaldisk.Size/1024/1024) & " MB",$Listview_LogicalDisks)
   GUICtrlCreateListViewItem("--------------------|--------------------",$Listview_LogicalDisks)
Next

funcMessageWindow("Please wait ...","Getting WMI Data ...",TRUE)
;funcDebug(@ScriptLineNumber)

EndFunc
;///////////////////////////////////////////////////////////////////////////////
Func funcLoggedOnUsers()

$GUI_LoggedOnUsers = GuiCreate("LoggedOn Users and Shares", 600, 500,-1, -1 , _
   BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetFont($GUI_LoggedOnUsers,10,-1,"MS Sans Serif")

$Group_LoggedOnUsers=GUICtrlCreateGroup("LoggedOn Users and Shares",3,3,590,490,-1,-1)
$Input_LoggedOnUsers = GuiCtrlCreateInput(GUICtrlRead($Input0), 40, 50, 150, 20)
;$Button_OS = GUICtrlCreateButton ("Refresh...", 200,50,75,25)
;GUICtrlSetOnEvent($Button_OS, "func")
$Listview_LoggedOnUsers = GUICtrlCreateListView("Name                             |Value                        ", _
   40,100,500,350,$LVS_SHOWSELALWAYS,$LVS_EX_FULLROWSELECT+$LVS_EX_TRACKSELECT)

GUISetOnEvent($GUI_EVENT_CLOSE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "funcWindowEvents")
GUISwitch($GUI_LoggedOnUsers)
GUISetState(@SW_SHOW)

$objLoggedOnUsers = $objWMI.ExecQuery("SELECT Antecedent FROM Win32_LoggedOnUser")
if @error then msgbox(0,"Error", "Code " & @error)
$CounterX = 1

For $objUser in $objLoggedOnUsers
   $arrUser = StringSplit($objUser.Antecedent,",")
   $strUser = StringSplit($arrUser[$arrUser[0]], "=")
   GUICtrlCreateListViewItem("Antecedent " & $CounterX & "|" & $strUser[$strUser[0]], _
   $Listview_LoggedOnUsers)
   $CounterX = $CounterX + 1
Next

$objShares = $objWMI.ExecQuery("Select * from Win32_Share")
if @error then msgbox(0,"Error", "Code " & @error)

GUICtrlCreateListViewItem("--------------------|--------------------",$Listview_LoggedOnUsers)

For $objShare in $objShares
   GUICtrlCreateListViewItem("Sharename|" & $objShare.Name,$Listview_LoggedOnUsers)
   if IsString($objShare.Path) AND ($objShare.Path<>"") then
      $strPath = String($objShare.Path)
   else
      $strPath = "n/a"
   endif
   GUICtrlCreateListViewItem("SharePath|" & $strPath,$Listview_LoggedOnUsers)
   GUICtrlCreateListViewItem("--------------------|--------------------",$Listview_LoggedOnUsers)
Next

Endfunc
;///////////////////////////////////////////////////////////////////////////////
Func funcGetAdminAccounts()

   $GUI_AdminGroup = GuiCreate("Local Admins", 600, 500,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
   GUISetFont($GUI_OS,10,-1,"MS Sans Serif")

   $Group_AdminGroup=GUICtrlCreateGroup("Local Admins",3,3,590,490,-1,-1)
   $Input_AdminGroup = GuiCtrlCreateInput(GUICtrlRead($Input0), 40, 50, 150, 20)
   $Listview_AdminGroup = GUICtrlCreateListView("Name                             |Value                        ", _
      40,100,500,350,$LVS_SHOWSELALWAYS,$LVS_EX_FULLROWSELECT+$LVS_EX_TRACKSELECT)
   $strTempInput = String(GUICtrlRead($Input_AdminGroup))
   GUISetOnEvent($GUI_EVENT_CLOSE, "funcWindowEvents")
   GUISetOnEvent($GUI_EVENT_MINIMIZE, "funcWindowEvents")
   GUISetOnEvent($GUI_EVENT_MAXIMIZE, "funcWindowEvents")
   GUISetOnEvent($GUI_EVENT_RESTORE, "funcWindowEvents")
   GUISwitch($GUI_AdminGroup)
   GUISetState(@SW_SHOW)

   $objGroups = ObjGet("WinNT://" & $strTempInput & "/Administrators")
   if @error then msgbox(0,"Error", "Code " & @error)
   $intNr = 1
   for $objUser in $objGroups.Members
      GUICtrlCreateListViewItem("Account " & $intNr & "|" & $objUser.Name,$Listview_AdminGroup)
      $intNr = $intNr + 1
   next
   
EndFunc
;///////////////////////////////////////////////////////////////////////////////
Func funcMessageWindow($strTitle, $strText, $constDelete)

   if $constDelete = TRUE then
      GUISetState($GUI1,@SW_HIDE)
      GUIDelete($GUI1)
      WinKill($strTitle,$strText)
   else
      $GUI1 = GUICreate($strTitle,300,200,-1,-1,$WS_SIZEBOX+$WS_SYSMENU,$WS_EX_TOPMOST)
      $Label1 = GUICtrlCreateLabel($strText,10,10,200,24)
      GUICtrlSetFont($Label1,12,800,-1,"MS Sans Serif")
      GUISetOnEvent($GUI_EVENT_CLOSE, "funcWindowEvents")
      GUISetOnEvent($GUI_EVENT_MINIMIZE, "funcWindowEvents")
      GUISetOnEvent($GUI_EVENT_MAXIMIZE, "funcWindowEvents")
      GUISetOnEvent($GUI_EVENT_RESTORE, "funcWindowEvents")
      GUISwitch($GUI1)
      GUISetState(@SW_SHOW)
   endif
   
Endfunc
;///////////////////////////////////////////////////////////////////////////////
Func funcOS()

$GUI_OS = GuiCreate("OS Settings", 600, 550,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetFont($GUI_OS,10,-1,"MS Sans Serif")

$Group_OS=GUICtrlCreateGroup("OS Settings",3,3,590,540,-1,-1)
$Input_OS = GuiCtrlCreateInput(GUICtrlRead($Input0), 40, 50, 150, 20)
;$Button_OS = GUICtrlCreateButton ("Refresh...", 200,50,75,25)
;GUICtrlSetOnEvent($Button_OS, "func")
$Listview_OS = GUICtrlCreateListView("Name                             |Value                        ", _
   40,100,500,400,$LVS_SHOWSELALWAYS,$LVS_EX_FULLROWSELECT+$LVS_EX_TRACKSELECT)

GUISetOnEvent($GUI_EVENT_CLOSE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "funcWindowEvents")
GUISwitch($GUI_OS)
GUISetState(@SW_SHOW)

$strTempCompname = String(GUICtrlRead($Input_OS))
$objConvertDate = ObjCreate("WbemScripting.SWbemDateTime")
$objWMI = ObjGet("winmgmts:\\" & $strTempCompname & "\root\CIMV2")
if @error then msgbox(0,"Error", "Code " & @error)
$objOS = $objWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")
if @error then msgbox(0,"Error", "Code " & @error)
$objMem = $objWMI.ExecQuery("SELECT BankLabel, Capacity FROM Win32_PhysicalMemory")
if @error then msgbox(0,"Error", "Code " & @error)
$objPageFile = $objWMI.ExecQuery("SELECT Name, FileSize FROM Win32_PageFile")
if @error then msgbox(0,"Error", "Code " & @error)

For $objXOS in $objOS
   GuiCtrlCreateListViewItem("BootDevice|" & $objXOS.BootDevice,$Listview_OS)
   GuiCtrlCreateListViewItem("CSD Version|" & $objXOS.CSDVersion,$Listview_OS)
   GuiCtrlCreateListViewItem("CS Name|" & $objXOS.CSName,$Listview_OS)

   if $objXOS.CSDVersion = "Service Pack 2" then
      GuiCtrlCreateListViewItem("DEP 32bit App|" & $objXOS.DataExecutionPrevention_32BitApplications,$Listview_OS)
      GuiCtrlCreateListViewItem("DEP Available|" & $objXOS.DataExecutionPrevention_32BitApplications,$Listview_OS)
      GuiCtrlCreateListViewItem("DEP Drivers|" & $objXOS.DataExecutionPrevention_Drivers,$Listview_OS)
      GuiCtrlCreateListViewItem("DEP Support Policy|" & $objXOS.DataExecutionPrevention_SupportPolicy,$Listview_OS)
   endif
   
   GuiCtrlCreateListViewItem("Description|" & $objXOS.Description,$Listview_OS)

   $objConvertDate.Value = $objXOS.InstallDate
   $strInstalldate = $objConvertDate.GetVarDate
   $strInstalldate = StringMid($strInstalldate,7,2) & "." & _
      StringMid($strInstalldate,5,2) & "." & StringLeft($strInstalldate,4) & " - " & _
      StringMid($strInstalldate,9,2) & ":" & _
      StringMid($strInstalldate,11,2) & ":" & StringRight($strInstalldate,2)
   
   GuiCtrlCreateListViewItem("Install Date|" & $strInstalldate,$Listview_OS)
   
   $objConvertDate.Value = $objXOS.LastBootUpTime
   $strLastBootTime = $objConvertDate.GetVarDate
   $strLastBootTime = StringMid($strLastBootTime,7,2) & "." & _
      StringMid($strLastBootTime,5,2) & "." & StringLeft($strLastBootTime,4) & " - " & _
      StringMid($strLastBootTime,9,2) & ":" & _
      StringMid($strLastBootTime,11,2) & ":" & StringRight($strLastBootTime,2)

   $objConvertDate.Value = $objXOS.LocalDateTime
   $strLocalTime = $objConvertDate.GetVarDate
   $strLocalTime = StringMid($strLocalTime,7,2) & "." & _
      StringMid($strLocalTime,5,2) & "." & StringLeft($strLocalTime,4) & " - " & _
      StringMid($strLocalTime,9,2) & ":" & _
      StringMid($strLocalTime,11,2) & ":" & StringRight($strLocalTime,2)

   GuiCtrlCreateListViewItem("Last Boot Time|" & $strLastBootTime,$Listview_OS)
   GuiCtrlCreateListViewItem("Local Time|" & $strLocalTime,$Listview_OS)

   GuiCtrlCreateListViewItem("Organization|" & $objXOS.Organization,$Listview_OS)
   GuiCtrlCreateListViewItem("System Directory|" & $objXOS.SystemDirectory,$Listview_OS)
   GuiCtrlCreateListViewItem("System Drive|" & $objXOS.SystemDrive,$Listview_OS)
   GuiCtrlCreateListViewItem("Version|" & $objXOS.Version,$Listview_OS)
   GuiCtrlCreateListViewItem("Windows Directory|" & $objXOS.WindowsDirectory,$Listview_OS)
   
Next

GUICtrlCreateListViewItem("--------------------|--------------------",$Listview_OS)

For $objMemX in $objMem
   GuiCtrlCreateListViewItem("Memory Bank Label|" & $objMemX.BankLabel,$Listview_OS)
   GuiCtrlCreateListViewItem("Memory Bank Capacity|" & ($objMemX.Capacity/1024/1024) & " MB",$Listview_OS)
Next

GUICtrlCreateListViewItem("--------------------|--------------------",$Listview_OS)

For $objPageX in $objPageFile
   GuiCtrlCreateListViewItem("Pagefilename|" & $objPageX.Name,$Listview_OS)
   GuiCtrlCreateListViewItem("Pagefilesize|" & ($objPageX.FileSize/1024/1024) & " MB",$Listview_OS)
Next

Endfunc
;///////////////////////////////////////////////////////////////////////////////
Func funcNetworkAdapters()

Local $strArrayGateway, $strArrayDNSSearchOrder, $strNetIP, $strSubnet

$GUI_NetworkAdapters = GuiCreate("Network Adapter", 600, 500,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
GUISetFont($GUI_OS,10,-1,"MS Sans Serif")

$Group_NetworkAdapters=GUICtrlCreateGroup("Network Adapter",3,3,590,490,-1,-1)
$Input_NetworksAdapters = GuiCtrlCreateInput(GUICtrlRead($Input0), 40, 50, 150, 20)
;$Button_OS = GUICtrlCreateButton ("Refresh...", 200,50,75,25)
;GUICtrlSetOnEvent($Button_OS, "func")
$Listview_NetworkAdapters = GUICtrlCreateListView("Name                             |Value                        ", _
   40,100,500,350,$LVS_SHOWSELALWAYS,$LVS_EX_FULLROWSELECT+$LVS_EX_TRACKSELECT)

GUISetOnEvent($GUI_EVENT_CLOSE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "funcWindowEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "funcWindowEvents")
GUISwitch($GUI_NetworkAdapters)
GUISetState(@SW_SHOW)

$objNetworkAdapter = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration where (IPEnabled = 'true')")
if @error then msgbox(0,"Error", "Code " & @error)

For $objNetwork in $objNetworkAdapter

   GuiCtrlCreateListViewItem("Description|" & $objNetwork.Description,$Listview_NetworkAdapters)

   if $objNetwork.IPAddress = 0 then
      GuiCtrlCreateListViewItem("IP Address|n/a",$Listview_NetworkAdapters)
   elseif IsArray($objNetwork.IPAddress) then
      For $xZ in $objNetwork.IPAddress
         $strNetIP = String($xZ) & ";" & $strNetIP
      Next
      GuiCtrlCreateListViewItem("IP Address|" & $strNetIP,$Listview_NetworkAdapters)
   endif

   if $objNetwork.IPSubnet = 0 then
      GuiCtrlCreateListViewItem("IP Subnet|n/a",$Listview_NetworkAdapters)
   elseif IsArray($objNetwork.IPSubnet) then
      For $xC in $objNetwork.IPSubnet
         $strSubnet = String($xC) & ";" & $strSubnet
      Next
      GuiCtrlCreateListViewItem("IP Subnet|" & $strSubnet,$Listview_NetworkAdapters)
   endif

   if $objNetwork.DefaultIPGateway = 0 then
      GuiCtrlCreateListViewItem("Default IP Gateway|n/a",$Listview_NetworkAdapters)
   elseif IsArray($objNetwork.DefaultIPGateway) then
         For $xI in $objNetwork.DefaultIPGateway
            $strArrayGateway = String($xI) & ";" & $strArrayGateway
         Next
      GuiCtrlCreateListViewItem("Default IP Gateway|" & $strArrayGateway,$Listview_NetworkAdapters)
   endif

   if $objNetwork.DHCPEnabled = TRUE then GuiCtrlCreateListViewItem("DHCP Enabled|True",$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("DHCP Server|" & $objNetwork.DHCPServer,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("DNS Domain|" & $objNetwork.DNSDomain,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("DNS HostName|" & $objNetwork.DNSHostName,$Listview_NetworkAdapters)

   if $objNetwork.DNSServerSearchOrder = 0 then
      GuiCtrlCreateListViewItem("DNS Server SearchOrder|n/a",$Listview_NetworkAdapters)
   elseif IsArray($objNetwork.DNSServerSearchOrder) then
      For $xY in $objNetwork.DNSServerSearchOrder
         $strArrayDNSSearchOrder = String($xY) & ";" & $strArrayDNSSearchOrder
      Next
      GuiCtrlCreateListViewItem("DNS Server SearchOrder|" & $strArrayDNSSearchOrder,$Listview_NetworkAdapters)
   endif

   GuiCtrlCreateListViewItem("MAC Address|" & $objNetwork.MACAddress,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("MTU|" & $objNetwork.MTU,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("Service Name|" & $objNetwork.ServiceName,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("Tcp WindowSize|" & $objNetwork.TcpWindowSize,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("WINS Enable LMHosts Lookup|" & $objNetwork.WINSEnableLMHostsLookup,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("WINS Primary Server|" & $objNetwork.WINSPrimaryServer,$Listview_NetworkAdapters)
   GuiCtrlCreateListViewItem("WINS Secondary Server|" & $objNetwork.WINSSecondaryServer,$Listview_NetworkAdapters)
   
   GUICtrlCreateListViewItem("--------------------|--------------------",$Listview_NetworkAdapters)
   
Next

EndFunc
;///////////////////////////////////////////////////////////////////////////////
Func funcWindowEvents()

   Select

      Case @GUI_CTRLID = $GUI_EVENT_CLOSE AND @GUI_WINHANDLE = $GUI0
         GUIDelete()
         Exit
      Case @GUI_CTRLID = $GUI_EVENT_CLOSE AND @GUI_WINHANDLE = $Gui_OS
         GUISetState($GUI_OS,@SW_HIDE)
         GUIDelete($GUI_OS)
         WinKill("OS Settings","")
      Case @GUI_CTRLID = $GUI_EVENT_CLOSE AND @GUI_WINHANDLE = $GUI_AdminGroup
         GUISetState($GUI_AdminGroup,@SW_HIDE)
         GUIDelete($GUI_AdminGroup)
         WinKill("Local Admins","")
      Case @GUI_CTRLID = $GUI_EVENT_CLOSE AND @GUI_WINHANDLE = $GUI_NetworkAdapters
         GUISetState($GUI_NetworkAdapters,@SW_HIDE)
         GUIDelete($GUI_NetworkAdapters)
         WinKill("Network Adapters","")
      Case @GUI_CTRLID = $GUI_EVENT_CLOSE AND @GUI_WINHANDLE = $GUI_LoggedOnUsers
         GUISetState($GUI_LoggedOnUsers,@SW_HIDE)
         GUIDelete($GUI_LoggedOnUsers)
         WinKill("LoggedOn Users and Shares","")
      Case @GUI_CTRLID = $GUI_EVENT_CLOSE AND @GUI_WINHANDLE = $GUI_LogicalDisks
         GUISetState($GUI_LogicalDisks,@SW_HIDE)
         GUIDelete($GUI_LogicalDisks)
         WinKill("Logical Disks","")

      Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE
         ;MsgBox(0, "Window Minimized", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)
      Case @GUI_CTRLID = $GUI_EVENT_MAXIMIZE

      Case @GUI_CTRLID = $GUI_EVENT_RESTORE

   EndSelect

EndFunc
;///////////////////////////////////////////////////////////////////////////////
Func funcDebug($Linenr)

msgbox(0,"Debug","Line " & $Linenr)

Endfunc
