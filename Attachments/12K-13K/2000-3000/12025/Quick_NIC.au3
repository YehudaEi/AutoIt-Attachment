#include <GuiConstants.au3>
#include <Array.au3>
#include <Date.au3>
#include <Process.au3>
#include <string.au3>

AutoItSetOption ( "TrayIconHide", 1 )
AutoItSetOption('RunErrorsFatal', 0) 
Opt ("GUIOnEventMode", 1)

; INI File read section
; =====================
Global Const $iniFile = @ScriptDir & "\ships.ini"
Global Const $iniSectionNamesArray = IniReadSectionNames($iniFile)
Global Const $iniSectionNamesString = _ArrayToString($iniSectionNamesArray, "|", 1)
Global Const $iniFileProxy = @ScriptDir & "\proxy.ini"
Global Const $iniSectionNamesArrayProxy = IniReadSectionNames($iniFileProxy)
Global Const $iniSectionNamesStringProxy = _ArrayToString($iniSectionNamesArrayProxy, "|", 1)
Global Const $ED_iniFile = @ScriptDir & "\ships.ini"
Global Const $ED_iniSectionNamesArray = IniReadSectionNames($ED_iniFile)
Global Const $ED_iniSectionNamesString = _ArrayToString($ED_iniSectionNamesArray, "|", 1)
Global Const $EDP_iniFile = @ScriptDir & "\proxy.ini"
Global Const $EDP_iniSectionNamesArray = IniReadSectionNames($EDP_iniFile)
Global Const $EDP_iniSectionNamesString = _ArrayToString($EDP_iniSectionNamesArray, "|", 1)

Global Const $PW_iniFile = @SystemDir & "\QuickNIC.ini"
Global Const $PW_iniSectionNamesArray = IniReadSectionNames($PW_iniFile)
Global Const $PW_iniSectionNamesString = _ArrayToString($PW_iniSectionNamesArray, "|", 1)

Global Const $s_Title = 'Quick NIC Changer'
Global Const $s_TitleProxy = 'Quick Proxy Changer'
Global Const $s_Version = '3.2.0.1'

Global $Main_Form
Global $gui_About
Global $Proxy_Form
Global $pb_progress1, $pb_plbl1
Global $buttonChangeWiFi
Global $buttonChangeIP
Global $buttonDummy
Global $buttonDummyDHCP
Global $buttonresetIP
Global $buttonresetWiFi
Global $bt_Ab_Close
Global $buttonDummyProxy
Global $LANCard
Global $WiFiCard
Global $LANCardMessage 
Global $WiFiCardMessage
Global $IPAddressMessage
Global $SubNetMessage
Global $GatwayMessage
Global $DNS1Message
Global $DNS2Message
Global $mylist
Global $Available_Connections
Global $buttonDummyDHCP
Global $IPAddressDummy
Global $SubNetDummy
Global $GatwayDummy
Global $DNS1Dummy
Global $DNS2Dummy
Global $dns2Add
Global $mylistProxy
Global $PROXYADDMessage
Global $proxy_addressAdd
Global $proxy_portMessage
Global $ProxyMandP = $proxy_portMessage+$PROXYADDMessage
Global $objwmiservice = ObjGet('winmgmts:\\localhost\root\CIMV2')
Global $proxy_port1
Global $lb_Ab_VisitSite
Global $lb_Ab_ContactAuthor
Global $a_GMsg

Global $proxy_addressAdd
Global $Proxy_listDummy
Global $buttonChangeIP
Global $buttonDummyDHCP
Global $mylistProxy
Global $proxy_AutoDummy
Global $proxy_UseProxyDummy
Global $proxy_address
Global $proxy_port
Global $Proxy_Final

Global $ED_Edit_Form
Global $ED_mylist
Global $ED_Addmylist
Global $ED_buttonEdit
Global $ED_buttonDel
Global $ED_ED_buttonDone1
Global $ED_buttonAdd
Global $ED_mylistDel
Global $ED_ED_buttonChangeIP
Global $ED_buttonDummy
Global $ED_buttonDummyDHCP
Global $ED_buttonresetIP
Global $ED_buttonresetWiFi
Global $ED_buttonEdit
Global $ED_buttonDel
Global $ED_buttonAdd
Global $ED_Addmylist
Global $ED_mylist
Global $ED_mylistDel
Global $ED_IPAddress
Global $ED_SubNet
Global $ED_Gatway
Global $ED_DNS1
Global $ED_DNS2
Global $ED_proxy_address
Global $ED_proxy_port
Global $ED_mylistDummy
Global $ED_ip_Group
Global $ED_ship_Group
Global $ED_DNS_Group
Global $ED_proxy_Group
Global $ED_ED_buttonDone
Global $ED_mylistDummy
Global $ED_shipnameMessage
Global $ED_IPAddressMessage
Global $ED_SubNetMessage
Global $ED_GatwayMessage
Global $ED_DNS1Message
Global $ED_DNS2Message
Global $ED_PROXY1Message
Global $ED_PROXY2Message
Global $ED_shipnameMessageED
Global $ED_IPAddressMessageED
Global $ED_SubNetMessageED
Global $ED_GatwayMessageED
Global $ED_DNS1MessageED
Global $ED_DNS2MessageED
Global $ED_PROXY1MessageED
Global $ED_PROXY2MessageED
Global $ED_ED_buttonDone2
Global $lable_Progress
Global $IPAddress

Global $EDP_buttonAdd
Global $proxy_addressAdd
Global $Add_Proxy_Group
Global $proxy_portAdd
Global $EDP_edit_List_Proxy
Global $EDP_buttonEdit
Global $EDP_proxy_port
Global $DEL_buttonDel
Global $EDP_DEL_List_Proxy
Global $EDP_edit_Input_Proxy
Global $Address_edite
Global $Address_edite_Input
Global $proxy_port
Global $Address_edite_InputDummy
Global $radio_group
Global $Proxy_Reset
Global $proxy_addressDummy
Global $EDP_Proxy_Group
Global $EDP_buttonDummy
Global $proxy_portDummy
Global $EDP_edit_List_Proxy
Global $EDP_buttonEdit
Global $Lable_Port
Global $DEL_buttonDel
Global $EDP_DEL_List_Proxy
Global $Address_edite_Input
Global $Address_edite_InputDummy
Global $EDP_Proxy_Form
Global $EDP_Proxy_Radio
Global $EDP_Proxy_Radio2
Global $EDP_Proxy_Radio3
Global $radio_group

Global $iMsgBoxAnswer
Global $AdminName
Global $admin_Form
Global $AdminPass
Global $power_User
Global $power_PW
Global $UserString
Global $PassString

Global $help
;CHECK POWER
;===========

If Not IsAdmin() Then
    call("_setAdmin")
    Exit
EndIf

Func _setAdmin()
	$AdminName = IniRead (@SystemDir & "\QuickNIC.ini", "String225", "String200","")
	$AdminPass = IniRead (@SystemDir & "\QuickNIC.ini", "String225", "String100","")
	$UserString = _HexToString($AdminName)
	$PassString = _HexToString($AdminPass)
	
If @UserName <> $UserString Then
    Select
        Case @error = 0 
            RunAsSet($UserString, @ComputerName, $PassString)
            If StringInStr(@ScriptFullPath, '.au3') Then
                Run('"' & @AutoItExe & '" "' & @ScriptFullPath & '" ' & $PassString)
            Else
                Run('"' & @ScriptFullPath & '" ' & $PassString)
            EndIf
            If @error Then $iMsgBoxAnswer = MsgBox(49,"Quick NIC","Admin rights required for Quick NIC to run." & @CRLF & "You unfortunately do not have Admin rights on this computer." & @CRLF & @CRLF & "1) If you know the Administrator User Name and Password click Ok and follow the instructions." & @CRLF & "You will only need to supply this information once, unless you change the Admin Password." & @CRLF & @CRLF & "2) If you do not know the Administrator User Name and Password click Cancel" & @CRLF & "and contact your systems administrator for the information before continuing." & @CRLF & @CRLF)
		Select
			Case $iMsgBoxAnswer = 1 
			$StringUser = InputBox($s_Title, "Enter local Admin user name:", '', '', '280', '160', '-1', '-1')
			$StringPass = InputBox($s_Title, "Enter local Admin password:", '', '*', '280', '160', '-1', '-1')
			$HexUser = _StringToHex($StringUser)
			$HexPass = _StringToHex($StringPass)
			IniWrite(@SystemDir & "\QuickNIC.ini", "String225", "String200", $HexUser)
			IniWrite(@SystemDir & "\QuickNIC.ini", "String225", "String100", $HexPass)
			MsgBox(64,$s_Title,"You have successfully set Admin credentials." & @CRLF & "Please restart Quick NIC?")
		Case $iMsgBoxAnswer = 2 
			Exit
	EndSelect
EndSelect
Else
	Exit
EndIf

EndFunc

; GUI
; ===
$Main_Form = GUICreate($s_Title& " - v" &$s_Version, 297,489,-1,-1,$ws_sysmenu,$ws_ex_overlappedwindow)
GUISetState (@SW_SHOW)
GuiSetIcon(@ScriptDir & "\Icons\TarjetadeRed.ico", 0)

; TOP EXPLANATION GROUP
; ======================
$TopGroup = GuiCtrlCreatePic("Icons\QuickNICLogo.gif",28,5,0,0)

; TopMenu items
; =============
$filemenu = GUICtrlCreateMenu ("&File")
$exititem = GUICtrlCreateMenuitem ("Exit",$filemenu)
GUICtrlSetOnEvent ($exititem, "buttonDone")
$filemenu = GUICtrlCreateMenu ("&Proxy")
$Proxyitem = GUICtrlCreateMenuitem ("Change Proxy",$filemenu)
GUICtrlSetOnEvent ($Proxyitem, "_ProxyForm")
$addProxy = GUICtrlCreateMenuitem ("Mannage Proxy Settings",$filemenu)
GUICtrlSetOnEvent ($addProxy, "_EditProxyForm")
$filemenu = GUICtrlCreateMenu ("&SetUp")
$additem = GUICtrlCreateMenuitem ("Mannage Ship/Location",$filemenu)
GUICtrlSetOnEvent ($additem, "_EditForm")
$adminPassword = GUICtrlCreateMenuitem ("Set Local Admin Username and Password",$filemenu)
GUICtrlSetOnEvent ($adminPassword, "_AdminCredentials")
$helpmenu = GUICtrlCreateMenu ("Help")
$helpitem = GUICtrlCreateMenuitem ("Quick NIC Help",$helpmenu)
GUICtrlSetOnEvent ($helpitem, "_HelpFile")
$infoitem = GUICtrlCreateMenuitem ("About Quick NIC",$helpmenu)
GUICtrlSetOnEvent ($infoitem, "_About")

Func _HelpFile()
	 Run(@WindowsDir & "\HH.exe " & @ScriptDir & "\QuickNICHelp.chm")
EndFunc

; SHIP NAMES
;===========
GUICtrlCreateGroup("Select Ship", 145, 110, 140, 50)
$mylistDummy = GUICtrlCreateCombo ("Select profile ---", 155,130,120,20,$WS_DISABLED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; SELECT NETWORK CARD
; ===================
GUICtrlCreateGroup("Select Network connection", 5, 60, 280, 45)
Local $NIC_Conect = GUICtrlCreateCombo ("Select Network connection ---", 15,75,220)
GUICtrlSetOnEvent($NIC_Conect,"_radioEnable")
GUISetState()
	Local $conitems = $objWMIService.ExecQuery ('SELECT * FROM Win32_NetworkAdapter', 'WQL', 0x10 + 0x20)
	If IsObj($conitems) Then
		For $objitem In $conitems
			If $objitem.netconnectionstatus = 2 Then GUICtrlSetData($NIC_Conect, $objitem.netconnectionid)
		Next
	EndIf
GUICtrlCreateGroup("", -99, -99, 1, 1)

Func _radioEnable()
	GUICtrlDelete($LANCard)
	GUICtrlDelete($WiFiCard)
	$LANCard = GUICtrlCreateRadio ("Set to DHCP", 15, 121, -1, -1)
	GUICtrlSetOnEvent ($LANCard, "_DHCP")
	$WiFiCard = GUICtrlCreateRadio ("Set to Static", 15, 138, -1, -1)
	GUICtrlSetOnEvent ($WiFiCard, "_Static")
EndFunc


; RADIALS
; =======
GUICtrlCreateGroup("Set to...", 5, 110, 130, 50)
$LANCard = GUICtrlCreateRadio ("Set to DHCP", 15, 121, -1, -1,$WS_DISABLED)
$WiFiCard = GUICtrlCreateRadio ("Set to Static", 15, 138, -1, -1,$WS_DISABLED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; INPUT-IP
; ========
GUICtrlCreateGroup("Use the following IP address :", 5, 170, 280, 100)
$IPAddress = GUICtrlCreateInput('', 160, 190, 103, 20, $es_center+$WS_DISABLED)
GUICtrlCreateLabel("IP Address :", 20, 195,-1,20)
$SubNet = GUICtrlCreateInput("", 160, 215, 103, 20, $es_center+$WS_DISABLED)
GUICtrlCreateLabel("Subnet Mask :", 20, 220,-1,20)
$Gatway = GUICtrlCreateInput("", 160, 240, 103, 20, $es_center+$WS_DISABLED)
GUICtrlCreateLabel("Default Gatway :", 20, 245,-1,20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; INPUT-DNS
; =========
GUICtrlCreateGroup("Use the following DNS server addresses:", 5, 280, 280, 80)
$DNS1 = GUICtrlCreateInput("", 160, 300, 103, 20, $es_center+$WS_DISABLED)
GUICtrlCreateLabel("Preferred DNS Server :", 20, 305,-1,20)
$DNS2 = GUICtrlCreateInput("", 160, 325, 103, 20, $es_center+$WS_DISABLED)
GUICtrlCreateLabel("Alternate DNS Server :",20, 330,-1,20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; BUTTON 
; ======
$buttonDummy = GUICtrlCreateButton("Load Settings", 5, 370, 140, 30,$WS_DISABLED)
$buttonDummyDHCP = GUICtrlCreateButton("Reset to DHCP", 147, 370, 140, 30, $WS_DISABLED)
$buttonDone = GUICtrlCreateButton("Exit Application", 5, 405, 283, 30, "")
GUICtrlSetOnEvent($buttonChangeIP, "buttonChangeIP")
GUICtrlSetOnEvent($buttonDummy, "_SelectCard")
GUICtrlSetOnEvent($buttonDone, "buttonDone")
GUICtrlSetOnEvent($buttonDummyDHCP, "buttonSetDHCP")
Local $Available_Connections = GUICtrlRead($NIC_Conect)
GUISetState()
GUICtrlCreateGroup("", -99, -99, 1, 1)

; GUI MESSAGE LOOP
; ================
While 1
	$NIC_ConectMessage = GUICtrlRead($Available_Connections)
	$LANCardMessage = GUICtrlRead($LANCard)
	$WiFiCardMessage = GUICtrlRead($WiFiCard)
	$IPAddressMessage = GUICtrlRead($IPAddress)
    $SubNetMessage = GUICtrlRead($SubNet)
    $GatwayMessage = GUICtrlRead($Gatway)
	$DNS1Message = GUICtrlRead($DNS1)
	$DNS2Message = GUICtrlRead($DNS2)
	$ED_shipnameMessageED = GUICtrlRead($ED_mylist)
	$ED_shipnameMessage = GUICtrlRead($ED_Addmylist)
    $ED_IPAddressMessage = GUICtrlRead($ED_IPAddress)
    $ED_SubNetMessage = GUICtrlRead($ED_SubNet)
    $ED_GatwayMessage = GUICtrlRead($ED_Gatway)
	$ED_DNS1Message = GUICtrlRead($ED_DNS1)
	$ED_DNS2Message = GUICtrlRead($ED_DNS2)
	$ED_PROXY1Message = GUICtrlRead($ED_proxy_address)
	$ED_PROXY2Message = GUICtrlRead($ED_proxy_port)
	$PROXYADDMessage = GUICtrlRead($proxy_addressAdd)
	$proxy_portMessage = GUICtrlRead($proxy_port1)
	$Proxy_Final = ($PROXYADDMessage&":"&$proxy_portMessage)
	$EDP_shipnameMessageD = GUICtrlRead($EDP_DEL_List_Proxy)
	$EDP_shipnameMessageA = GUICtrlRead($proxy_addressAdd)
	$EDP_PROXY1MessageA = GUICtrlRead($proxy_addressAdd)
    $EDP_PROXY2MessageA = GUICtrlRead($proxy_portAdd)
	$EDP_shipnameMessageED = GUICtrlRead($EDP_edit_List_Proxy)
	$EDP_PROXY1MessageED = GUICtrlRead($Address_edite_Input)
	$EDP_PROXY2MessageED = GUICtrlRead($EDP_proxy_port)
	$power_Message = "String225"
	$power_UserMessage = GUICtrlRead($power_User)
	$power_PWMessage = GUICtrlRead($power_PW)
	
WEnd

; =======================
; GUI - ADMIN CREDENTIALS
; =======================
Func _AdminCredentials()
$admin_Form = GuiCreate($s_Title, 240, 205,-1, -1)
GUISetState(@SW_SHOW)
$Label1 = GUICtrlCreateLabel("User Name : ", 12, 103, 66, 17)
$Label2 = GUICtrlCreateLabel("Password :", 14, 132, 56, 17)
$power_User = GUICtrlCreateInput("", 100, 100, 121, 21)
$power_PW = GUICtrlCreateInput("", 100, 128, 121, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$Button1 = GUICtrlCreateButton("Set Password", 8, 166, 100, 30, 0)
GUICtrlSetOnEvent($Button1,"_AdminCredentials_Set")
$Button2 = GUICtrlCreateButton("Cancel", 133, 166, 100, 30, 0)
GUICtrlSetOnEvent($Button2,"_AdminCredentials_Close")
$Group1 = GUICtrlCreateGroup("Local Administrator credentials", 6, 81, 228, 78)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("", 7, 2, 228, 78)
$Label3 = GUICtrlCreateLabel("Please supply Local Administrator", 30,12, 161, 17)
$Label4 = GUICtrlCreateLabel("User name and Password, if you do not", 30, 28, 189, 17)
$Label5 = GUICtrlCreateLabel("know this information contact your", 30, 42, 165, 17)
$Label6 = GUICtrlCreateLabel("System Administrator", 30, 58, 101, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func _AdminCredentials_Close()
	GUISetState (@SW_HIDE,$admin_Form)
	GUISetState (@SW_SHOW,$Main_Form)
EndFunc

Func _AdminCredentials_Set()
		$HexUser = _StringToHex($power_UserMessage)
		$HexPass = _StringToHex($power_PWMessage)
		IniWrite(@SystemDir & "\QuickNIC.ini", $power_Message, "String200", $HexUser)
		IniWrite(@SystemDir & "\QuickNIC.ini", $power_Message, "String100", $HexPass)
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(8228,"Location Added","You have succesfully added a new location." & @CRLF & "To select the new location you need to reload IP-Changer." & @CRLF & "Do you want to reload IP-Changer now?")
Select
   Case $iMsgBoxAnswer = 6 
	Run ( "Quick NIC.exe", @ScriptDir)
	Exit
   Case $iMsgBoxAnswer = 7 
EndSelect
    
EndFunc
; ========================================
; GUI - About
; ========================================
Func _About()
$gui_About = GUICreate('About - '&$s_Title , 325, 255, -1, -1)
GUISetState (@SW_SHOW)
GuiSetIcon(@ScriptDir & "\Icons\TarjetadeRed.ico", 0)
GuiCtrlCreatePic("Icons\QuickNICLogoVert.gif",5,5, 49,241,$ws_sysmenu, $ws_ex_overlappedwindow)
GUICtrlCreateLabel('Quickly Update your TCP/IP settings with this Utility',65,10,250,20)
$lb_Ab_Title = GUICtrlCreateLabel($s_Title,75,40,240,20)
GUICtrlSetFont($lb_Ab_Title,12,700,0,"Arial")
GUICtrlCreateLabel('Version :' & $s_Version ,77,60,240,20)
GUICtrlCreateLabel('This application is a utility for easily changing your ' & _
		'TCP/IP settings of your Local Area Network and Wireless Network connections.' & @LF & _
		'It also includes a built in tool to change you Proxy setting.', 65, 100, 240, 110)
$lb_Ab_ContactAuthor = GUICtrlCreateLabel('Written by Craig Holohan.', 65, 220, 145, 15)
Global $bt_Ab_Close = GUICtrlCreateButton('&Close', 240, 215, 75, 25)
GUICtrlSetOnEvent($bt_Ab_Close,"_About_Close")

EndFunc

Func _ToolTipClose()
	Local $mouse = MouseGetPos()
	If Not IsDeclared("sToolTipAnswer") Then Dim $sToolTipAnswer
	$sToolTipAnswer = ToolTip("Now you need to select either" & @CRLF & "Set to DHCP or" & @CRLF & "Set to Static",$mouse[0] + 15, $mouse[1],"Now Select....",1,1)
	ToolTip("") 
EndFunc
	
Func _About_Close()
	GUISetState (@SW_HIDE,$gui_About)
	GUISetState (@SW_SHOW,$Main_Form)
EndFunc
; CHANGE IP NETWORK CARD SETTING
; ==============================

Func _DHCP()
	GUICtrlSetState ($buttonDummyDHCP,@SW_ENABLE)
	GUICtrlSetOnEvent($buttonDummyDHCP, "buttonSetDHCP")
	$buttonDummy = GUICtrlCreateButton("Load Settings", 5, 370, 140, 30,$WS_DISABLED)
	GUICtrlDelete ($mylist)
	GUICtrlDelete ($mylistDummy)
	GUICtrlDelete ($IPAddress)
	GUICtrlDelete ($SubNet)
	GUICtrlDelete ($Gatway)
	GUICtrlDelete ($DNS1)
	GUICtrlDelete ($DNS2)
	GUICtrlDelete ($buttonChangeIP)
	GUICtrlDelete ($buttonDummyProxy)
	$IPAddress = GUICtrlCreateInput('', 160, 190, 103, 20, $es_center+$WS_DISABLED)
	$SubNet = GUICtrlCreateInput("", 160, 215, 103, 20, $es_center+$WS_DISABLED)
	$Gatway = GUICtrlCreateInput("", 160, 240, 103, 20, $es_center+$WS_DISABLED)
	$DNS1 = GUICtrlCreateInput("", 160, 300, 103, 20, $es_center+$WS_DISABLED)
	$DNS2 = GUICtrlCreateInput("", 160, 325, 103, 20, $es_center+$WS_DISABLED)
	$mylistDummy = GUICtrlCreateCombo ("Select profile ---", 155,130,120,20,$WS_DISABLED)
EndFunc

Func _Static()
	GUICtrlDelete ($buttonDummy)
	$buttonChangeIP = GUICtrlCreateButton("Load Settings", 5, 370, 140, 30, "")
	GUICtrlSetOnEvent($buttonChangeIP, "buttonChangeIP")
	GUICtrlDelete ($mylistDummy)
	GUICtrlDelete ($mylist)
	$IPAddress = GUICtrlCreateInput('', 160, 190, 103, 20, $es_center)
	$SubNet = GUICtrlCreateInput("", 160, 215, 103, 20, $es_center)
	$Gatway = GUICtrlCreateInput("", 160, 240, 103, 20, $es_center)
	$DNS1 = GUICtrlCreateInput("", 160, 300, 103, 20, $es_center)
	$DNS2 = GUICtrlCreateInput("", 160, 325, 103, 20, $es_center)
	$mylist = GUICtrlCreateCombo ("Select profile ---", 155,130,120,20)
	GUICtrlSetData(-1, $iniSectionNamesString)
	GUICtrlSetOnEvent($mylist,"_ReadINI")
	GUICtrlDelete ($buttonDummyDHCP)
	GUICtrlDelete ($IPAddressDummy)
	GUICtrlDelete ($SubNetDummy)
	GUICtrlDelete ($GatwayDummy)
	GUICtrlDelete ($DNS1Dummy)
	GUICtrlDelete ($DNS2Dummy)
	$buttonDummyDHCP = GUICtrlCreateButton("Reset to DHCP", 147, 370, 140, 30, $WS_DISABLED)
	
EndFunc

Func _ReadINI()
	$ipAdd = IniRead($iniFile, GUICtrlRead($mylist), "IP", "")
    $subnetAdd = IniRead($iniFile, GUICtrlRead($mylist), "SUBNET", "")
    $gatwayAdd = IniRead($iniFile, GUICtrlRead($mylist), "GATWAY", "")
	$dnsAdd = IniRead($iniFile, GUICtrlRead($mylist), "DNS", "")
	$dns2Add = IniRead($iniFile, GUICtrlRead($mylist), "DNS2", "")
	GUICtrlSetData($IPAddress, $ipAdd)
	GUICtrlSetData($SubNet, $subnetAdd)
    GUICtrlSetData($Gatway, $gatwayAdd)
	GUICtrlSetData($DNS1, $dnsAdd)
	GUICtrlSetData($DNS2, $dns2Add)
	GUICtrlDelete($buttonDummy)
	
EndFunc

Func additemMenu()
	Run ( "ManageShip-Location.exe", @ScriptDir)
	Exit
EndFunc

; FUNCTION EXIT APPLICATION
; =========================
Func buttonDone()
	GUISetState ()      
	Exit
EndFunc

; FUNCTION START TO SET WAP DHCP
; ==============================

Func buttonSetDHCP()
	Local $Available_Connections = GUICtrlRead($NIC_Conect)
	GUICtrlDelete ($TopGroup)
	$lable_Progress = GUICtrlCreateLabel("Progress:", 50, 40)
	_Progress_Create(5,15,280,20)
	Local $mouse = MouseGetPos()
	If Not IsDeclared("sToolTipAnswer") Then Dim $sToolTipAnswer
	$sToolTipAnswer = ToolTip("Now updating your" & @CRLF &$Available_Connections & @CRLF & "back to DHCP" & @CRLF & $IPAddressMessage,$mouse[0] + 15, $mouse[1],"Please Wait ......",1,1)
	Local $percent = 0
	$percent = 10
    _Progress_Update($percent)
	$percent = 20
    _Progress_Update($percent)
; RUN NETSH AND SET DHCP
; ======================
	RunWait(@ComSpec & " /c " & 'netsh interface ip set address "'&$Available_Connections&'" dhcp', "", @SW_HIDE)
	$percent = 30
    _Progress_Update($percent)
	$percent = 40
    _Progress_Update($percent)
	$percent = 50
    _Progress_Update($percent)
    $percent = 60
    _Progress_Update($percent)
	$percent = 70
    _Progress_Update($percent)
; RUN NETSH AND SET DNS TO AUTO OBTAIN
; ====================================
	RunWait(@ComSpec & " /c " & 'netsh interface ip set dns "'&$Available_Connections&'" dhcp', "", @SW_HIDE)
	$percent = 80
    _Progress_Update($percent)
	$percent = 90
    _Progress_Update($percent)
	$percent = 100
    _Progress_Update($percent)
	ToolTip("")
Dim $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(36,"Quick NIC Changer -"&$Available_Connections,"Your" &$Available_Connections& "has succesfully been reset to" &@CRLF& "DHCP" & @CRLF & "Do you want to set your Proxy now?")
	Select
	Case $iMsgBoxAnswer = 6 
	GUICtrlDelete ($pb_progress1)
	GUICtrlDelete ($pb_plbl1)
	GUICtrlDelete ($lable_Progress)
	$TopGroup = GuiCtrlCreatePic("Icons\QuickNICLogo.gif",28,5,0,0)
	Call ("_ProxyForm")
	Case $iMsgBoxAnswer = 7 
	Exit
EndSelect

EndFunc

; RUN NETSH AND SET LAN IP INFO SUBMITTED
; =======================================
Func buttonChangeIP()
	Local $Available_Connections = GUICtrlRead($NIC_Conect)
	GUICtrlDelete ($TopGroup)
	$lable_Progress = GUICtrlCreateLabel("Progress:", 50, 40)
	_Progress_Create(5,15,280,20)
	Local $mouse = MouseGetPos()
	If Not IsDeclared("sToolTipAnswer") Then Dim $sToolTipAnswer
	$sToolTipAnswer = ToolTip("Now updating your" & @CRLF &$Available_Connections & @CRLF & "with IP address" & @CRLF & $IPAddressMessage,$mouse[0] + 15, $mouse[1],"Please Wait ......",1,1)
	Local $percent = 0
	$percent = 10
    _Progress_Update($percent)
	$percent = 20
    _Progress_Update($percent)
	$percent = 30
    _Progress_Update($percent)
	RunWait(@ComSpec & ' /c ' & 'netsh interface ip set address "'&$Available_Connections&'" static '& $IPAddressMessage &' '& $SubNetMessage &' '& $GatwayMessage &' 1' , "", @SW_HIDE)
	$percent = 40
    _Progress_Update($percent)
	$percent = 50
    _Progress_Update($percent)
	$percent = 60
	_Progress_Update($percent)
	RunWait(@ComSpec & " /c " & 'netsh interface ip set dns "'&$Available_Connections&'" static '& $DNS1Message &'', "", @SW_HIDE)
	$percent = 76
	_Progress_Update($percent)
	$percent = 82
    _Progress_Update($percent)
	$percent = 95
	_Progress_Update($percent)
	RunWait(@ComSpec & " /c " & 'netsh interface ip add dns "'&$Available_Connections&'" index=2 '& $DNS2Message & '', "", @SW_HIDE)
	$percent = 100
	_Progress_Update($percent)
	ToolTip("") 
	Dim $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(36,"Quick NIC Changer -"&$Available_Connections,"Your IP has sucsesfully been changed to" &@IPAddress1&  @CRLF &"on your" & $Available_Connections & @CRLF & "Do you want to set your Proxy now?")
	Select
	Case $iMsgBoxAnswer = 6
	GUICtrlDelete ($pb_progress1)
	GUICtrlDelete ($pb_plbl1)
	GUICtrlDelete ($lable_Progress)
	$TopGroup = GuiCtrlCreatePic("Icons\QuickNICLogo.gif",28,5,0,0)
	Call ("_ProxyForm")
	Case $iMsgBoxAnswer = 7
	Exit
EndSelect
	
EndFunc

Func _SelectCard()
	Local $Available_Connections = GUICtrlRead($NIC_Conect)
	MsgBox(64,"Quick NIC Changer", $Available_Connections)
EndFunc

Func _Progress_Create($i_x, $i_y, $i_width, $i_height)
    $pb_progress1 = GUICtrlCreateProgress($i_x, $i_y, $i_width, $i_height,$PBS_SMOOTH)
    $pb_plbl1 = GUICtrlCreateLabel("0%", ($i_width / 2) + ($i_x / 2), $i_y + 25, 35, $i_height - 4, -1, $WS_EX_TRANSPARENT)
    GUICtrlSetFont(-1, -1, 800)
EndFunc

Func _Progress_Update($i_percent)
    GUICtrlSetData($pb_progress1, $i_percent)
    GUICtrlSetData($pb_plbl1, $i_percent & "%")
EndFunc

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;EDIT FORM START HERE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func _EditForm()
$ED_Edit_Form = GUICreate($s_Title& " - v" &$s_Version, 297,489,-1,-1,$ws_sysmenu, $ws_ex_overlappedwindow)
GUISetState (@SW_SHOW)
GuiSetIcon(@ScriptDir & "\Icons\TarjetadeRed.ico", 0)

; RADIALS
; =======
GUICtrlCreateGroup("First select one", 5, 5, 280, 40)
$ED_Add_Loc = GUICtrlCreateRadio ("Add", 15, 20, -1, 20)
GUICtrlSetOnEvent ($ED_Add_Loc, "_Add")
$ED_Edit_Loc = GUICtrlCreateRadio ("Edit", 120, 20, -1, 20)
GUICtrlSetOnEvent ($ED_Edit_Loc, "_Edit")
$ED_Del_Loc = GUICtrlCreateRadio ("Delete", 200, 20, -1, 20)
GUICtrlSetOnEvent ($ED_Del_Loc, "_Delete")
GUICtrlCreateGroup("", -99, -99, 1, 1)

; SHIP NAMES
;===========
$ED_ship_Group = GUICtrlCreateGroup("Select Ship and click Refresh", 5, 50, 280, 50)
$ED_mylistDummy = GUICtrlCreateCombo ("Select profile ---", 15,70,120,20,$WS_DISABLED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; INPUT-IP
; ========
$ED_ip_Group = GUICtrlCreateGroup("Use the following IP address :", 5, 105, 280, 100)
$ED_IPAddress = GUICtrlCreateInput('', 160, 125, 103, 20,$WS_DISABLED)
GUICtrlCreateLabel("IP Address :", 20, 128,-1,20)
$ED_SubNet = GUICtrlCreateInput("", 160, 150, 103, 20,$WS_DISABLED)
GUICtrlCreateLabel("Subnet Mask :", 20, 153,-1,20)
$ED_Gatway = GUICtrlCreateInput("", 160, 175, 103, 20,$WS_DISABLED)
GUICtrlCreateLabel("Default Gatway :", 20, 178,-1,20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; INPUT-DNS
; =========
$ED_DNS_Group = GUICtrlCreateGroup("Use the following DNS server addresses:", 5, 210, 280, 80)
$ED_DNS1 = GUICtrlCreateInput("", 160, 235, 103, 20,$WS_DISABLED)
GUICtrlCreateLabel("Preferred DNS Server :", 20, 238,-1,20)
$ED_DNS2 = GUICtrlCreateInput("", 160, 260, 103, 20,$WS_DISABLED)
GUICtrlCreateLabel("Alternate DNS Server :",20, 263,-1,20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; BUTTON 
; ======
$ED_buttonDummy = GUICtrlCreateButton("Add / Edite / Del Location", 5, 300, 135, 30, $WS_DISABLED)
$ED_ED_buttonDone = GUICtrlCreateButton("Exit Application", 150, 300, 135, 30, "")
GUICtrlSetOnEvent($ED_ED_buttonDone, "ED_buttonDone")
GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

; FUNCTION EXIT APPLICATION
; =========================
Func ED_buttonDone()
	GUISetState (@SW_HIDE,$ED_Edit_Form)
	GUISetState (@SW_SHOW,$Main_Form)
EndFunc

Func _Add ()
	Global $ED_buttonAdd = GUICtrlCreateButton("Add Location", 5, 300, 135, 30, "")
	GUICtrlSetOnEvent($ED_buttonAdd, "buttonAddIP")
	$ED_ED_buttonDone2 = GUICtrlCreateButton("Exit Application", 150, 300, 135, 30, "")
	GUICtrlSetOnEvent($ED_ED_buttonDone,"ED_buttonDone")
	GUICtrlDelete ($ED_mylistDummy)
	GUICtrlDelete ($ED_mylist)
	GUICtrlDelete ($ED_Addmylist)
	GUICtrlDelete ($ED_buttonEdit)
	GUICtrlDelete ($ED_buttonDel)
	GUICtrlDelete ($ED_buttonDummy)
	GUICtrlDelete ($ED_ip_Group)
	GUICtrlDelete ($ED_ship_Group)
	GUICtrlDelete ($ED_DNS_Group)
	GUICtrlDelete ($ED_ED_buttonDone1)
	$ED_ip_Group = GUICtrlCreateGroup("Enter IP info -- Leave blank if info not known", 5, 105, 280, 100)
	$ED_ship_Group = GUICtrlCreateGroup("Enter Ship / Location name", 5, 50, 280, 50)
	$ED_DNS_Group = GUICtrlCreateGroup("Enter DNS server addresses", 5, 210, 280, 80)
	GUICtrlSetState($ED_IPAddress, $gui_enable)
	GUICtrlSetState($ED_SubNet, $gui_enable)
	GUICtrlSetState($ED_Gatway, $gui_enable)
	GUICtrlSetState($ED_DNS1, $gui_enable)
	GUICtrlSetState($ED_DNS2, $gui_enable)
	GUICtrlSetState($ED_proxy_port, $gui_enable)
	$ED_Addmylist = GUICtrlCreateInput ("",15,70,120,20)
	GUISetState ()
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func _Delete ()
	GUICtrlDelete ($ED_ED_buttonDone)
	GUICtrlDelete ($ED_ED_buttonDone1)
	GUICtrlDelete ($ED_ED_buttonDone2)
	GUICtrlDelete ($ED_buttonDummy)
	GUICtrlDelete ($ED_Addmylist)
	GUICtrlDelete ($ED_mylistDummy)
	GUICtrlDelete ($ED_buttonAdd)
	GUICtrlDelete ($ED_buttonEdit)
	GUICtrlDelete ($ED_buttonDummy)
	GUICtrlDelete ($ED_mylist)
	GUICtrlDelete ($ED_IPAddress)
	GUICtrlDelete ($ED_SubNet)
	GUICtrlDelete ($ED_Gatway)
	GUICtrlDelete ($ED_DNS1)
	GUICtrlDelete ($ED_DNS2)
	GUICtrlDelete ($ED_ip_Group)
	GUICtrlDelete ($ED_ship_Group)
	GUICtrlDelete ($ED_DNS_Group)
	GUICtrlDelete ($ED_proxy_Group)
	$ED_buttonDel = GUICtrlCreateButton ("Delete", 160,70,70,22)
	GUICtrlSetOnEvent($ED_buttonDel, "buttonDeleteShipLocation")
	$ED_ED_buttonDone1 = GUICtrlCreateButton("Exit Application", 5, 300, 283, 30, "")
	GUICtrlSetOnEvent($ED_ED_buttonDone1, "ED_buttonDone")
	$ED_ip_Group = GUICtrlCreateGroup("Disabled controles", 5, 105, 280, 100)
	$ED_ship_Group = GUICtrlCreateGroup("Select Ship / Location and click Delete", 5, 50, 280, 50)
	$ED_DNS_Group = GUICtrlCreateGroup("Disabled controles", 5, 210, 280, 80)
	$ED_IPAddress = GUICtrlCreateInput('', 160, 125, 103, 20,$WS_DISABLED)
	$ED_SubNet = GUICtrlCreateInput("", 160, 150, 103, 20,$WS_DISABLED)
	$ED_Gatway = GUICtrlCreateInput("", 160, 175, 103, 20,$WS_DISABLED)
	$ED_DNS1 = GUICtrlCreateInput("", 160, 235, 103, 20,$WS_DISABLED)
	$ED_DNS2 = GUICtrlCreateInput("", 160, 260, 103, 20,$WS_DISABLED)
	
	Global $ED_Addmylist = GUICtrlCreateCombo ("Select profile ---", 15,70,120)
	GUICtrlSetData(-1, $ED_iniSectionNamesString)
	GUISetState ()
GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func _Edit()
	GUICtrlDelete($ED_ED_buttonDone)
	$ED_buttonEdit = GUICtrlCreateButton("Edit Location", 5, 300, 135, 30, "")
	GUICtrlSetOnEvent($ED_buttonEdit, "ED_buttonChangeIP")
	$ED_ED_buttonDone = GUICtrlCreateButton("Exit Application", 150, 300, 135, 30, "")
	GUICtrlSetOnEvent($ED_ED_buttonDone,"ED_buttonDone")
	Global $ED_mylist = GUICtrlCreateCombo ("Select profile ---", 15,70,120)
	GUICtrlSetData(-1, $ED_iniSectionNamesString)
	GUICtrlSetOnEvent($ED_mylist,"buttonRefresh")
	GUISetState ()
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetState($ED_IPAddress, $gui_enable)
	GUICtrlSetState($ED_SubNet, $gui_enable)
	GUICtrlSetState($ED_Gatway, $gui_enable)
	GUICtrlSetState($ED_DNS1, $gui_enable)
	GUICtrlSetState($ED_DNS2, $gui_enable)
	GUICtrlDelete ($ED_mylistDel)
	GUICtrlDelete ($ED_buttonAdd)
	GUICtrlDelete ($ED_buttonDel)
	GUICtrlDelete ($ED_buttonDummy)
	GUICtrlDelete ($ED_mylistDummy)
	GUICtrlDelete ($ED_Addmylist)
	GUICtrlDelete ($ED_ip_Group)
	GUICtrlDelete ($ED_ship_Group)
	GUICtrlDelete ($ED_DNS_Group)
	GUICtrlDelete ($ED_ED_buttonDone1)
	$ED_ip_Group = GUICtrlCreateGroup("Edit IP info", 5, 105, 280, 100)
	$ED_ship_Group = GUICtrlCreateGroup("Select Ship / Location and click Refresh", 5, 50, 280, 50)
	$ED_DNS_Group = GUICtrlCreateGroup("Edit DNS server addresses", 5, 210, 280, 80)
	
EndFunc

; Populate Info from INI file
; ===========================
Func buttonRefresh()
	$ED_ipAdd = IniRead($ED_iniFile, GUICtrlRead($ED_mylist), "IP", "")
    $ED_subnetAdd = IniRead($ED_iniFile, GUICtrlRead($ED_mylist), "SUBNET", "")
    $ED_gatwayAdd = IniRead($ED_iniFile, GUICtrlRead($ED_mylist), "GATWAY", "")
	$ED_dnsAdd = IniRead($ED_iniFile, GUICtrlRead($ED_mylist), "DNS", "")
	$ED_dns2Add = IniRead($ED_iniFile, GUICtrlRead($ED_mylist), "DNS2", "")
	$ED_proxy_addressADD = IniRead($ED_iniFile, GUICtrlRead($ED_mylist), "proxy_address", "")
	$ED_proxy_portADD = IniRead($ED_iniFile, GUICtrlRead($ED_mylist), "proxy_port", "")
    GUICtrlSetData($ED_IPAddress, $ED_ipAdd)
	GUICtrlSetData($ED_SubNet, $ED_subnetAdd)
    GUICtrlSetData($ED_Gatway, $ED_gatwayAdd)
	GUICtrlSetData($ED_DNS1, $ED_dnsAdd)
	GUICtrlSetData($ED_DNS2, $ED_dns2Add)
	GUICtrlSetData($ED_proxy_address, $ED_proxy_addressAdd)
	GUICtrlSetData($ED_proxy_port, $ED_proxy_portADD)
EndFunc


; FUNCTION Add IP
; ===============
Func buttonAddIP()
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessage, "IP", $ED_IPAddressMessage)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessage, "SUBNET", $ED_SubNetMessage)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessage, "GATWAY", $ED_GatwayMessage)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessage, "DNS", $ED_DNS1Message)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessage, "DNS2", $ED_DNS2Message)
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(8228,"Location Added","You have succesfully added a new location." & @CRLF & "To select the new location you need to reload IP-Changer." & @CRLF & "Do you want to reload IP-Changer now?")
Select
   Case $iMsgBoxAnswer = 6
	Run ( "Quick NIC.exe", @ScriptDir)
	Exit
   Case $iMsgBoxAnswer = 7
	Call ("ED_buttonDone")
EndSelect
    
EndFunc

; FUNCTION DELETE SHIP/LOCATION
; ==========================
Func buttonDeleteShipLocation()
	IniDelete(@ScriptDir & "\ships.ini", $ED_shipnameMessage)	
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(8228,"Location Deleted","You have succesfully deleted the location location." & @CRLF & "For the deleted location to be removed from the list you need to reload IP-Changer." & @CRLF & "Do you want to reload IP-Changer now?")
Select
   Case $iMsgBoxAnswer = 6 
	Run ( "Quick NIC.exe", @ScriptDir)
	Exit
   Case $iMsgBoxAnswer = 7 
	Call ("ED_buttonDone")
EndSelect
EndFunc

; FUNCTION START Changing IP
; ==========================
Func ED_buttonChangeIP()
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessageED, "IP", $ED_IPAddressMessage)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessageED, "SUBNET", $ED_SubNetMessage)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessageED, "GATWAY", $ED_GatwayMessage)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessageED, "DNS", $ED_DNS1Message)
	IniWrite(@ScriptDir & "\ships.ini", $ED_shipnameMessageED, "DNS2", $ED_DNS2Message)
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(8228,"Location Edited","You have succesfully edited the location." & @CRLF & "To use the edited location you need to reload IP-Changer." & @CRLF & "Do you want to reload IP-Changer now?")
Select
   Case $iMsgBoxAnswer = 6 
	Run ( "Quick NIC.exe", @ScriptDir)
	Exit
   Case $iMsgBoxAnswer = 7 
	Call ("ED_buttonDone")
EndSelect
EndFunc


;PROXY FORM STARTS HERE
;======================
Func _ProxyForm()
	
; GUIPROXY
; ========
If Not IsAdmin() Then
    $AdminName = IniRead (@SystemDir & "\QuickNIC.ini", "String225", "String200","")
	$AdminPass = IniRead (@SystemDir & "\QuickNIC.ini", "String225", "String100","")
	$UserString = _HexToString($AdminName)
	$PassString = _HexToString($AdminPass)
    RunAsSet($UserString, @ComputerName, $PassString)
EndIf

$Proxy_Form = GUICreate($s_TitleProxy& " - v" &$s_Version, 297,180,-1,-1,$ws_sysmenu,$ws_ex_overlappedwindow)
GUISetState (@SW_SHOW)
GuiSetIcon(@ScriptDir & "\Icons\proxy.ico", 0)

; INPUT-PROXY 
; ===========
GUICtrlCreateGroup("Proxy Server", 5, 15, 280, 95)
	$proxy_AutoDummy = GUICtrlCreateCheckbox("Automatically Detect Settings",25,30,-1,-1)
	GUICtrlSetState($proxy_AutoDummy, $gui_unchecked)
	GUICtrlSetOnEvent ($proxy_AutoDummy, "_ProxyAuto")
	$proxy_UseProxyDummy = GUICtrlCreateCheckbox("Use a Proxy server for your LAN",25,50,-1,-1)
	GUICtrlSetState($proxy_UseProxyDummy, $gui_unchecked)
	GUICtrlSetOnEvent ($proxy_UseProxyDummy, "_ProxySet")

	$proxy_address = GUICtrlCreateInput("", 75, 80, 103, 20, $ES_AUTOHSCROLL+$WS_DISABLED)
	GUICtrlCreateLabel("Address :", 20, 83,-1,20)
	$proxy_port = GUICtrlCreateInput("", 235, 80, 40, 20,$WS_DISABLED)
	GUICtrlCreateLabel("Port :", 190, 83,-1,20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; BUTTON 
; ======
$buttonDummyProxy = GUICtrlCreateButton("Change Proxy", 5, 115, 137, 30, $WS_DISABLED)
$buttonDoneProxy = GUICtrlCreateButton("Exit Application", 147, 115, 137, 30, "")
GUICtrlSetOnEvent($buttonDoneProxy, "buttonDone_Proxy")
GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc

; CHANGE PROXY SETTINGS
; =====================
Func _ProxyAuto()
	$proxy_address = GUICtrlCreateInput("", 75, 80, 103, 20, $ES_AUTOHSCROLL+$WS_DISABLED)
	GUICtrlSetState ($buttonDummyProxy,@SW_ENABLE)
	GUICtrlSetOnEvent($buttonDummyProxy,"_SetProxyAuto")
	GUICtrlSetState($proxy_UseProxyDummy, $gui_unchecked)
	GUICtrlSetState($proxy_AutoDummy,$GUI_CHECKED)
	GUICtrlDelete ($mylistProxy)
	GUICtrlDelete ($proxy_addressAdd)
	GUICtrlSetState($proxy_address, $GUI_DISABLE)
	GUICtrlDelete($proxy_port1)
	$proxy_port = GUICtrlCreateInput("", 235, 80, 40, 20,$WS_DISABLED)
EndFunc

Func _ProxySet ()
	$mylistProxy = GUICtrlCreateCombo ("Select profile ---", 75, 80, 103, 20)
	GUICtrlSetData(-1, $iniSectionNamesStringProxy)
	GUICtrlSetOnEvent($mylistProxy,"_ProxyINIRead")
	GUICtrlSetState ($buttonDummyProxy,@SW_ENABLE)
	GUICtrlSetState($proxy_AutoDummy, $gui_unchecked)
	GUICtrlDelete($proxy_address)
	GUICtrlDelete ($Proxy_listDummy)
	GUICtrlDelete ($proxy_port)
	$proxy_port1 = GUICtrlCreateInput("", 235, 80, 40, 20)
			
EndFunc
	
Func _ProxyINIRead()
	$proxy_addressAdd = GUICtrlCreateInput("", 75, 80, 103, 20, $ES_AUTOHSCROLL)
	$proxy_address = IniRead($iniFileProxy, GUICtrlRead($mylistProxy), "proxy_address", "")
	GUICtrlSetData($proxy_addressAdd, $proxy_address)
	$proxy_port = IniRead($iniFileProxy, GUICtrlRead($mylistProxy), "proxy_port", "")
	GUICtrlSetData($proxy_port1,$proxy_port)
	GUICtrlDelete ($mylistProxy)
	GUICtrlSetOnEvent($buttonDummyProxy,"_SetProxy")
	
EndFunc

Func _SetProxyAuto()
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections","DefaultConnectionSettings")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections","DefaultConnectionSettings","REG_BINARY","3C000000020000000900000000000000090000006C6F63616C686F73740000000000000000000000000000000000000000000000000000000000000000")
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD", "0")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "MigrateProxy", "REG_DWORD", "1")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyHttp1.1", "REG_DWORD", "0")
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride")
	GUICtrlSetState($proxy_AutoDummy, $gui_unchecked)
	GUICtrlDelete($buttonDummyProxy)
	$buttonDummyProxy = GUICtrlCreateButton("Change Proxy", 5, 115, 137, 30, $WS_DISABLED)
	GUISetState (@SW_HIDE,$Proxy_Form)
	GUISetState (@SW_SHOW,$Main_Form)
EndFunc

Func _SetProxy()
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections","DefaultConnectionSettings")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections","DefaultConnectionSettings","REG_BINARY","3c00000003000000010000000000000000000000000000000000000000000000f0a436cbb4ffc6010100000002000000c0a8547e0000000000000000401e2c0848cc170548c31705e8cb170578c9170598c71705b8cb1705a8c61705700d3203300e3203d013320310133203500f320380c2300390be3003e0bc3003d0672c08c0622c0890622c0810672c08d0642c0840612c0800652c0870672c08d06a2c08406a2c0830622c0820632c080000000000000000")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer", "REG_SZ", $Proxy_Final)
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD", "1")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "MigrateProxy", "REG_DWORD", "1")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyHttp1.1", "REG_DWORD", "0")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride", "REG_SZ", "<local>")
	GUICtrlDelete($proxy_addressAdd)
	GUICtrlDelete($buttonDummyProxy)
	GUICtrlDelete ($proxy_port)
	$proxy_port = GUICtrlCreateInput("", 235, 80, 40, 20,$WS_DISABLED)
	$proxy_address = GUICtrlCreateInput("", 75, 80, 103, 20, $ES_AUTOHSCROLL+$WS_DISABLED)
	GUICtrlSetState($proxy_UseProxyDummy, $gui_unchecked)
	$buttonDummyProxy = GUICtrlCreateButton("Change Proxy", 5, 115, 137, 30, $WS_DISABLED)
	GUISetState (@SW_HIDE,$Proxy_Form)
	GUISetState (@SW_SHOW,$Main_Form)
EndFunc

; FUNCTION EXIT APPLICATION
; =========================
Func buttonDone_Proxy()
	GUISetState (@SW_HIDE,$Proxy_Form)
	GUISetState (@SW_SHOW,$Main_Form)
EndFunc

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;EDIT PROXY FORM START HERE
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func _EditProxyForm()
	
$EDP_Proxy_Form = GUICreate($s_Title& " - v" &$s_Version, 297,180,-1,-1,$ws_sysmenu, $ws_ex_overlappedwindow)
GUISetState (@SW_SHOW)
GuiSetIcon(@ScriptDir & "\Icons\TarjetadeRed.ico", 0)

; RADIALS
; =======
$radio_group = GUICtrlCreateGroup("First select one", 5, 5, 280, 40)
$EDP_Proxy_Radio = GUICtrlCreateRadio ("Add", 15, 20, -1, 20)
GUICtrlSetOnEvent ($EDP_Proxy_Radio, "_AddProxy")
$EDP_Proxy_Radio2 = GUICtrlCreateRadio ("Edit", 120, 20, -1, 20)
GUICtrlSetOnEvent ($EDP_Proxy_Radio2, "_EditProxy")
$EDP_Proxy_Radio3 = GUICtrlCreateRadio ("Delete", 200, 20, -1, 20)
GUICtrlSetOnEvent ($EDP_Proxy_Radio3, "_DeleteProxy")
GUICtrlCreateGroup("", -99, -99, 1, 1)

; SHIP NAMES
;===========
$EDP_Proxy_Group = GUICtrlCreateGroup("Proxy Settings", 5, 50, 280, 50)
$proxy_addressDummy = GUICtrlCreateInput("", 75, 70, 103, 20, $ES_AUTOHSCROLL+$WS_DISABLED)
$Lable_Address = GUICtrlCreateLabel("Address :", 20, 73,-1,20)
$Lable_Port = GUICtrlCreateLabel("Port :", 200, 73,-1,20)
$proxy_portDummy = GUICtrlCreateInput("", 235, 70, 40, 20,$WS_DISABLED)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; BUTTON 
; ======
$EDP_buttonDummy = GUICtrlCreateButton("Add / Edite / Del Proxy", 5, 110, 135, 30, $WS_DISABLED)
$EDP_ProxyButtoneDone = GUICtrlCreateButton("Exit Application", 150, 110, 135, 30, "")
GUICtrlSetOnEvent($EDP_ProxyButtoneDone, "EDp_buttonDone")
GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc

Func _AddProxy()
	GUICtrlDelete ($proxy_addressDummy)
	GUICtrlDelete ($EDP_Proxy_Group)
	GUICtrlDelete ($EDP_buttonDummy)
	GUICtrlDelete ($proxy_portDummy)
	GUICtrlDelete ($EDP_edit_List_Proxy)
	GUICtrlDelete ($EDP_buttonEdit)
	GUICtrlDelete ($Lable_Port)
	GUICtrlDelete ($DEL_buttonDel)
	GUICtrlDelete ($EDP_DEL_List_Proxy)
	GUICtrlDelete ($Address_edite_Input)
	GUICtrlDelete ($Address_edite_InputDummy)
	$Lable_Port = GUICtrlCreateLabel("Port :", 200, 73,-1,20)
	$Add_Proxy_Group = GUICtrlCreateGroup("Enter Proxy Server and Port number", 5, 50, 280, 50)
	$proxy_addressAdd = GUICtrlCreateInput("", 75, 70, 103, 20, $ES_AUTOHSCROLL)
	$proxy_portAdd = GUICtrlCreateInput("", 235, 70, 40, 20)
	$EDP_buttonAdd = GUICtrlCreateButton("Add Proxy", 5, 110, 135, 30, "")
	GUICtrlSetOnEvent($EDP_buttonAdd, "_buttonAddProxy")
EndFunc

; FUNCTION Add IP
; ===============
Func _buttonAddProxy()
	IniWrite(@ScriptDir & "\proxy.ini", $EDP_shipnameMessageA, "proxy_address", $EDP_PROXY1MessageA)
	IniWrite(@ScriptDir & "\proxy.ini", $EDP_shipnameMessageA, "proxy_port", $EDP_PROXY2MessageA)
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(8228,"Proxy Added","You have succesfully added a new Proxy Server Setting" & @CRLF & "To select the new Proxy you need to reload IP-Changer." & @CRLF & "Do you want to reload IP-Changer now?")
Select
   Case $iMsgBoxAnswer = 6 
	Run ( "Quick NIC.exe", @ScriptDir)
	Exit
   Case $iMsgBoxAnswer = 7 
	Call ("EDp_buttonDone")
EndSelect
EndFunc

Func _EditProxy()
	GUICtrlDelete ($proxy_addressDummy)
	GUICtrlDelete ($EDP_Proxy_Group)
	GUICtrlDelete ($EDP_buttonDummy)
	GUICtrlDelete ($proxy_portDummy)
	GUICtrlDelete ($Add_Proxy_Group)
	GUICtrlDelete ($proxy_addressAdd)
	GUICtrlDelete ($proxy_portAdd)
	GUICtrlDelete ($EDP_buttonAdd)
	GUICtrlDelete ($Lable_Port)
	GUICtrlDelete ($DEL_buttonDel)
	GUICtrlDelete ($EDP_DEL_List_Proxy)
	GUICtrlDelete ($Address_edite_Input)
	GUICtrlDelete ($Address_edite_InputDummy)
	GUICtrlDelete ($EDP_Proxy_Radio)
	GUICtrlDelete ($EDP_Proxy_Radio2)
	GUICtrlDelete ($EDP_Proxy_Radio3)
	GUICtrlDelete ($radio_group)
	$radio_group = GUICtrlCreateGroup("Select one to edit", 5, 5, 280, 40)
	$Proxy_Reset = GUICtrlCreateButton ("Go Back",185,17,90,25)
	GUICtrlSetOnEvent($Proxy_Reset,"_recreateRadio")
	$Lable_Port = GUICtrlCreateLabel("Port :", 200, 73,-1,20)
	$EDP_Proxy_Group = GUICtrlCreateGroup("Edit Proxy Server info", 5, 50, 280, 50)
	$EDP_edit_List_Proxy = GUICtrlCreateCombo ("Select Proxy to edit ---", 25,20,103)
	GUICtrlSetData(-1, $EDP_iniSectionNamesString)
	$EDP_proxy_port = GUICtrlCreateInput("", 235, 70, 40, 20)
	$EDP_buttonEdit = GUICtrlCreateButton("Edit Proxy", 5, 110, 135, 30, "")
	GUICtrlSetOnEvent($EDP_buttonEdit, "EDP_buttonChangeProxy")
	$Address_edite_InputDummy = GUICtrlCreateInput($Address_edite, 75, 70, 103, 20, $WS_DISABLED)
	GUICtrlSetOnEvent($EDP_edit_List_Proxy,"_ProxyRefresh")
EndFunc

; Populate Info from INI file
; ===========================
Func _ProxyRefresh()
	GUICtrlDelete ($Address_edite_Input)
	$Port_edite = IniRead($EDP_iniFile, GUICtrlRead($EDP_edit_List_Proxy), "proxy_port", "")
	GUICtrlSetData($EDP_proxy_port, $Port_edite)
	$Address_edite = IniRead($EDP_iniFile, GUICtrlRead($EDP_edit_List_Proxy), "proxy_address", "")
	$Address_edite_Input = GUICtrlCreateInput($Address_edite, 75, 70, 103, 20, $ES_AUTOHSCROLL)
EndFunc

; FUNCTION START Changing IP
; ==========================
Func EDP_buttonChangeProxy()
	IniWrite(@ScriptDir & "\proxy.ini", $EDP_shipnameMessageED, "proxy_port", $EDP_PROXY2MessageED)
	IniWrite(@ScriptDir & "\proxy.ini", $EDP_shipnameMessageED, "proxy_address", $EDP_PROXY1MessageED)
	IniRenameSection(@ScriptDir & "\proxy.ini", $EDP_shipnameMessageED, $EDP_PROXY1MessageED)
	Call ("_recreateRadio")	
	$iMsgBoxAnswer = MsgBox(8228,"Proxy Changed","You have succesfully changed the Proxy Server Setting" & @CRLF & "To select the Proxy you need to reload IP-Changer." & @CRLF & "Do you want to reload IP-Changer now?")
Select
   Case $iMsgBoxAnswer = 6 
	Run ( "Quick NIC.exe", @ScriptDir)
	Exit
   Case $iMsgBoxAnswer = 7 
	Call ("EDp_buttonDone")
EndSelect
EndFunc

Func _recreateRadio()
	$radio_group = GUICtrlCreateGroup("First select one", 5, 5, 280, 40)
	$EDP_Proxy_Radio = GUICtrlCreateRadio ("Add", 15, 20, -1, 20)
	GUICtrlSetOnEvent ($EDP_Proxy_Radio, "_AddProxy")
	$EDP_Proxy_Radio2 = GUICtrlCreateRadio ("Edit", 120, 20, -1, 20)
	GUICtrlSetOnEvent ($EDP_Proxy_Radio2, "_EditProxy")
	$EDP_Proxy_Radio3 = GUICtrlCreateRadio ("Delete", 200, 20, -1, 20)
	GUICtrlSetOnEvent ($EDP_Proxy_Radio3, "_DeleteProxy")
	GUICtrlDelete ($Address_edite_Input)
	GUICtrlDelete ($EDP_edit_List_Proxy)
	GUICtrlDelete ($Proxy_Reset)
	GUICtrlDelete ($radio_group)
	$proxy_addressDummy = GUICtrlCreateInput("", 75, 70, 103, 20, $ES_AUTOHSCROLL+$WS_DISABLED)
	$proxy_portDummy = GUICtrlCreateInput("", 235, 70, 40, 20,$WS_DISABLED)

EndFunc

Func _DeleteProxy()
	GUICtrlDelete ($proxy_addressDummy)
	GUICtrlDelete ($EDP_Proxy_Group)
	GUICtrlDelete ($EDP_buttonDummy)
	GUICtrlDelete ($proxy_portDummy)
	GUICtrlDelete ($Add_Proxy_Group)
	GUICtrlDelete ($proxy_addressAdd)
	GUICtrlDelete ($proxy_portAdd)
	GUICtrlDelete ($EDP_buttonAdd)
	GUICtrlDelete ($EDP_proxy_port)
	GUICtrlDelete ($Lable_Port)
	GUICtrlDelete ($EDP_buttonEdit)
	GUICtrlDelete ($EDP_proxy_port)
	GUICtrlDelete ($proxy_portAdd)
	GUICtrlDelete ($EDP_edit_List_Proxy)
	GUICtrlDelete ($Address_edite_Input)
	GUICtrlDelete ($Address_edite_InputDummy)
	$DEL_Proxy_Group = GUICtrlCreateGroup("Select Proxy Server to Delete", 5, 50, 280, 50)
	$EDP_DEL_List_Proxy = GUICtrlCreateCombo ("Select Proxy to Delete ---", 75,70,120)
	GUICtrlSetData(-1, $EDP_iniSectionNamesString)
	$DEL_buttonDel = GUICtrlCreateButton ("Delete", 5, 110, 135, 30)
	GUICtrlSetOnEvent($DEL_buttonDel, "_buttonDeleteProxy")
EndFunc

; FUNCTION DELETE SHIP/LOCATION
; ==========================
Func _buttonDeleteProxy()
	IniDelete(@ScriptDir & "\proxy.ini", $EDP_shipnameMessageD)	
$iMsgBoxAnswer = MsgBox(8228,"Proxy Deleted","You have succesfully Deleted the Proxy Server Setting" & @CRLF & "                                                                                " & @CRLF & "Do you want to reload IP-Changer now?")
Select
   Case $iMsgBoxAnswer = 6 
	Run ( "Quick NIC.exe", @ScriptDir)
	Exit
   Case $iMsgBoxAnswer = 7
	Call ("EDp_buttonDone")
EndSelect
EndFunc

Func EDp_buttonDone()
	GUISetState (@SW_HIDE,$EDP_Proxy_Form)
	GUISetState (@SW_SHOW,$Main_Form)
EndFunc
