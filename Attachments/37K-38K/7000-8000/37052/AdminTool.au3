#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=wrench.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Tool to Aid Admins.
#AutoIt3Wrapper_Res_Description=Software tool to aid Admins
#AutoIt3Wrapper_Res_Fileversion=1.9.1.4
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=Email|custompcs@charter.net
#AutoIt3Wrapper_Res_Field=Release Date|09/28/2005
#AutoIt3Wrapper_Res_Field=Update Date|10/26/2005
#AutoIt3Wrapper_Res_Field=Internal Name|AdminTool.exe
#AutoIt3Wrapper_Res_Field=Status|Beta
#AutoIt3Wrapper_Run_After=move "%out%" "%scriptdir%"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#region Compiler directives section
;** This is a list of compiler directives used by CompileAU3.exe.
;** comment the lines you don't need or else it will override the default settings
;#AutoIt3Wrapper_Prompt=y              					;y=show compile menu
;** AUT2EXE settings
;#AutoIt3Wrapper_AUT2EXE=
;#AutoIt3Wrapper_OutFile=              					;Target exe filename.
#AutoIt3Wrapper_Allow_Decompile=y      					;y= allow decompile
;#AutoIt3Wrapper_PassPhrase=           					;Password to use for compilation
;** Target program Resource info
; free form resource fields ... max 15
; The following directives can contain:
;   %in% , %out%, %icon% which will be replaced by the fullpath\filename.
;   %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
#endregion Compiler directives section
#region --- Includes ---
#include <GuiConstants.au3>
#include <GuiListView.au3>
#include <Misc.au3>
#include <Inet.au3>
#include <File.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#endregion --- Includes ---

#region --- Option Code Wizard generated code Start ---
;==============================================================================================
;If this option is used then all variables must be pre-declared with Dim, Local or Global
;before they can be used - removes the chance for misspelled variables causing bugs.
;1 = Variables must be pre-declared
;0 = Variables don't need to be pre-declared (default)
;==============================================================================================
#endregion --- Option Code Wizard generated code Start ---
#region --- Global constants and options ---
Global Const $Cursor_WAIT = 15
Global Const $Cursor_ARROW = 2
Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20
Opt('MustDeclareVars', 1)
Opt("GUIResizeMode", 1)
#endregion --- Global constants and options ---

;~ #region **** install files if needed ****
;~ If @Compiled Then
;~ 	If Not FileExists(@ScriptDir & '\OnLine.ico') Then FileInstall("c:\Autoit\projects\AdminTool\OnLine.ico", @ScriptDir & '\OnLine.ico')
;~ 	If Not FileExists(@ScriptDir & '\OffLine.ico') Then FileInstall("c:\Autoit\projects\AdminTool\OffLine.ico", @ScriptDir & '\OffLine.ico')
;~ 	If Not FileExists(@ScriptDir & '\autoit.jpg') Then FileInstall("c:\Autoit\projects\AdminTool\autoit.jpg", @ScriptDir & '\autoit.jpg')
;~ 	If Not FileExists(@ScriptDir & '\psexec.exe') Then FileInstall("c:\Autoit\projects\AdminTool\psexec.exe", @ScriptDir & '\psexec.exe')
;~ 	If Not FileExists(@ScriptDir & '\psloggedon.exe') Then FileInstall("c:\Autoit\projects\AdminTool\psloggedon.exe", @ScriptDir & '\psloggedon.exe')
;~ 	If Not FileExists(@ScriptDir & '\psinfo.exe') Then FileInstall("c:\Autoit\projects\AdminTool\psinfo.exe", @ScriptDir & '\psinfo.exe')
;~ 	If Not FileExists(@ScriptDir & '\pslist.exe') Then FileInstall("c:\Autoit\projects\AdminTool\pslist.exe", @ScriptDir & '\pslist.exe')
;~ 	If Not FileExists(@ScriptDir & '\AdminTool.ini') Then FileInstall("c:\Autoit\projects\AdminTool\AdminTool.ini", @ScriptDir & '\AdminTool.ini')
;~ EndIf
;~ #endregion **** end install files if needed ****

_Main()

Func _Main()
	#region **** variable declares *****
	Local $s_Machine, $t_input = "", $num_pcs = 0, $item_num = 0
	Local $Title = "Admin Tool", $MAIN_WINDOW
	Local $Domain, $filter, $filters, $win_state, $Retrieve_Method
	Local $filemenu, $exititem
	Local $configmenu, $Domainitem, $Filtermenu, $Filteritem, $PingTimeOutitem, $FilterIPitem
	Local $infomenu, $Aboutitem
	Local $ib_search, $Btn_Search, $Btn_Exit, $i_TimeOut
	Local $lv_pcs, $lv_pcs_contextmenu, $lv_pcs_contextRefresh, $lv_pcs_contextPopulate
	Local $lv_pcs_pslist_taskmodetree, $lv_pcs_pslist_taskmode, $lv_pcs_pslist
	Local $tabs, $tab_software, $tab_pids, $tab_hotfixes
	Local $lv_software, $lv_software_contextmenu, $lv_software_contextRemove, $lv_software_contextmenu, $lv_software_contextRefresh
	Local $tab_allsoftware, $lv_allsoftware, $lv_allsoftware_contextmenu, $lv_allsoftware_contextRefresh
	Local $lv_pid, $lv_pid_contextmenu, $lv_pid_contextKill, $lv_pid_contextRefresh
	Local $Status, $dll, $msg, $MOUSE_POS, $explore_with, $eb_system
	Local $tab_loggedin, $lv_loggedin, $tab_drives, $lv_drives, $lv_drives_contextmenu, $lv_drives_contextExplore
	Local $tab_services, $lv_services, $lv_services_contextmenu, $lv_service_stop, $lv_service_contextRefresh, $lv_service_start
	Local $lv_service_pause, $lv_service_resume, $lv_service_delete
	Local $lv_service_startmode, $lv_service_startmodeBoot, $lv_service_startmodeSystem, $lv_service_startmodeAutomatic
	Local $lv_service_startmodeManual, $lv_service_startmodeDisabled
	Local $configmenuRetrieveMethods, $ldapitem, $netvitem, $IP_Range = "", $Use_IPRange
	#endregion **** variable declares *****

	TCPStartup()

	#region *** read ini information ****
	$Domain = IniRead(@ScriptDir & '\AdminTool.ini', "domain", "name", "your-domain")
	$filter = IniRead(@ScriptDir & '\AdminTool.ini', "Workstations", "filter", "*")
	$Retrieve_Method = StringUpper(IniRead(@ScriptDir & '\AdminTool.ini', "RetrievePcs", "Method", "LDAP"))
	$explore_with = IniRead(@ScriptDir & '\AdminTool.ini', "Drive", "Explore", "iexplore")
	$i_TimeOut = Int(IniRead(@ScriptDir & '\AdminTool.ini', "Ping", "TimeOut", 4))
	$Use_IPRange = Int(IniRead(@ScriptDir & '\AdminTool.ini', "IP-Filter", "Use", 0))
	If $Use_IPRange Then
		_GetIPRanges(@ScriptDir & '\AdminTool.ini', $IP_Range)
	EndIf
	$filters = StringSplit($filter, "|")
	#endregion *** read ini information ****

	$MAIN_WINDOW = GUICreate($Title, 785, 560, -1, -1, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU))

	#region **** menus *****
	$filemenu = GUICtrlCreateMenu("&File")
	$exititem = GUICtrlCreateMenuItem("Exit", $filemenu)

	$configmenu = GUICtrlCreateMenu("&Config")
	$Domainitem = GUICtrlCreateMenuItem("Domain", $configmenu)
	GUICtrlCreateMenuItem("", $configmenu)
	$Filtermenu = GUICtrlCreateMenu("Filter(s)", $configmenu)
	$Filteritem = GUICtrlCreateMenuItem("Filter by Name", $Filtermenu)
	$FilterIPitem = GUICtrlCreateMenuItem("Filter by IP Range(s)", $Filtermenu)
	GUICtrlCreateMenuItem("", $configmenu)
	$configmenuRetrieveMethods = GUICtrlCreateMenu("&Retrieve Computers Using", $configmenu)
	$ldapitem = GUICtrlCreateMenuItem("LDAP (Slower)", $configmenuRetrieveMethods, -1, 1)
	$netvitem = GUICtrlCreateMenuItem("Net View (Browser Info)", $configmenuRetrieveMethods, -1, 1)
	If $Retrieve_Method = "LDAP" Then
		GUICtrlSetState($ldapitem, $GUI_CHECKED)
	Else
		GUICtrlSetState($netvitem, $GUI_CHECKED)
	EndIf
	GUICtrlCreateMenuItem("", $configmenu)
	$PingTimeOutitem = GUICtrlCreateMenuItem("Ping Time Out", $configmenu)

	$infomenu = GUICtrlCreateMenu("&Info")
	$Aboutitem = GUICtrlCreateMenuItem("About", $infomenu)
	#endregion **** menus *****
	#region **** create controls ****
	$ib_search = GUICtrlCreateInput("", 10, 3, 160, 20)
	$Btn_Search = GUICtrlCreateButton("Fuzzy Search", 30, 28, 120, 20)
	GUICtrlSetState($Btn_Search, $GUI_DISABLE)

	$lv_pcs = GUICtrlCreateListView("Machine|IP Address|ID", 10, 50, 245, 460, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_pcs, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	_GUICtrlListView_SetColumnWidth($lv_pcs, 0, 100)
	_GUICtrlListView_SetColumnWidth($lv_pcs, 1, 120)
	_GUICtrlListView_HideColumn($lv_pcs, 2)
	$lv_pcs_contextmenu = GUICtrlCreateContextMenu($lv_pcs)
	$lv_pcs_contextRefresh = GUICtrlCreateMenuItem("Refresh Machine List", $lv_pcs_contextmenu)
	GUICtrlCreateMenuItem("", $lv_pcs_contextmenu)
	$lv_pcs_contextPopulate = GUICtrlCreateMenuItem("Populate Info", $lv_pcs_contextmenu)
	GUICtrlCreateMenuItem("", $lv_pcs_contextmenu)
	$lv_pcs_pslist = GUICtrlCreateMenu("Process List (Real Time)", $lv_pcs_contextmenu)
	$lv_pcs_pslist_taskmode = GUICtrlCreateMenuItem("Process List (task-manager mode)", $lv_pcs_pslist)
	$lv_pcs_pslist_taskmodetree = GUICtrlCreateMenuItem("Process List (task-manager mode, tree)", $lv_pcs_pslist)

	$tabs = GUICtrlCreateTab(270, 3, 500, 512, $TCS_MULTILINE)

	$tab_software = GUICtrlCreateTabItem("Software (msiexec removable)")

	$lv_software = GUICtrlCreateListView("Caption|Version|Identifier", 275, 70, 490, 440, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_software, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	_GUICtrlListView_SetColumnWidth($lv_software, 0, 350)
	_GUICtrlListView_SetColumnWidth($lv_software, 1, 120)
	_GUICtrlListView_HideColumn($lv_software, 2)
	$lv_software_contextmenu = GUICtrlCreateContextMenu($lv_software)
	$lv_software_contextRemove = GUICtrlCreateMenuItem("Uninstall Software", $lv_software_contextmenu)
	GUICtrlCreateMenuItem("", $lv_software_contextmenu)
	$lv_software_contextRefresh = GUICtrlCreateMenuItem("Refresh List", $lv_software_contextmenu)

	GUICtrlCreateTabItem("")

	$tab_pids = GUICtrlCreateTabItem("Process List")

	$lv_pid = GUICtrlCreateListView("PID|Name|Path", 275, 70, 490, 440, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_pid, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	_GUICtrlListView_SetColumnWidth($lv_pid, 0, 40)
	_GUICtrlListView_SetColumnWidth($lv_pid, 1, 60)
	_GUICtrlListView_SetColumnWidth($lv_pid, 2, 280)
	$lv_pid_contextmenu = GUICtrlCreateContextMenu($lv_pid)
	$lv_pid_contextKill = GUICtrlCreateMenuItem("Kill Process(s)", $lv_pid_contextmenu)
	GUICtrlCreateMenuItem("", $lv_pid_contextmenu)
	$lv_pid_contextRefresh = GUICtrlCreateMenuItem("Refresh List", $lv_pid_contextmenu)

	GUICtrlCreateTabItem("")

	$tab_services = GUICtrlCreateTabItem("Services")

	$lv_services = GUICtrlCreateListView("Display Name|Name|PID|Start Name|Start Mode|State|Path|Accept Stop", 275, 70, 490, 440, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_services, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	_GUICtrlListView_HideColumn($lv_software, 7)
	$lv_services_contextmenu = GUICtrlCreateContextMenu($lv_services)
	$lv_service_stop = GUICtrlCreateMenuItem("Stop Service", $lv_services_contextmenu)
	$lv_service_start = GUICtrlCreateMenuItem("Start Service", $lv_services_contextmenu)
	GUICtrlCreateMenuItem("", $lv_services_contextmenu)
	$lv_service_pause = GUICtrlCreateMenuItem("Pause Service", $lv_services_contextmenu)
	$lv_service_resume = GUICtrlCreateMenuItem("Resume Service", $lv_services_contextmenu)
	GUICtrlCreateMenuItem("", $lv_services_contextmenu)
	$lv_service_startmode = GUICtrlCreateMenu("Change Start Mode", $lv_services_contextmenu)
	$lv_service_startmodeBoot = GUICtrlCreateMenuItem("Boot", $lv_service_startmode)
	$lv_service_startmodeSystem = GUICtrlCreateMenuItem("System", $lv_service_startmode)
	$lv_service_startmodeAutomatic = GUICtrlCreateMenuItem("Automatic", $lv_service_startmode)
	$lv_service_startmodeManual = GUICtrlCreateMenuItem("Manual", $lv_service_startmode)
	$lv_service_startmodeDisabled = GUICtrlCreateMenuItem("Disabled", $lv_service_startmode)
	GUICtrlCreateMenuItem("", $lv_services_contextmenu)
	$lv_service_delete = GUICtrlCreateMenuItem("Delete Service", $lv_services_contextmenu)
	GUICtrlCreateMenuItem("", $lv_services_contextmenu)
	$lv_service_contextRefresh = GUICtrlCreateMenuItem("Refresh List", $lv_services_contextmenu)

	GUICtrlCreateTabItem("")

	$tab_loggedin = GUICtrlCreateTabItem("System")

	GUICtrlCreatePic(@ScriptDir & "\autoit.jpg", 275, 60, 280, 200, $SS_SUNKEN)

	$eb_system = GUICtrlCreateEdit("", 555, 60, 210, 200, BitOR($ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_MULTILINE, $SS_SUNKEN))

	$lv_loggedin = GUICtrlCreateListView("Last Logon|User", 275, 270, 490, 100, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_loggedin, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($lv_loggedin, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	_GUICtrlListView_SetColumnWidth($lv_loggedin, 0, 235)
	_GUICtrlListView_SetColumnWidth($lv_loggedin, 1, 235)

	$lv_drives = GUICtrlCreateListView("Name|Type|Total Size|Free Space|File System", 275, 390, 490, 100, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_drives, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($lv_drives, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	_GUICtrlListView_SetColumnWidth($lv_drives, 0, 50)
	_GUICtrlListView_SetColumnWidth($lv_drives, 1, 110)
	_GUICtrlListView_SetColumnWidth($lv_drives, 2, 100)
	_GUICtrlListView_SetColumnWidth($lv_drives, 3, 100)
	_GUICtrlListView_SetColumnWidth($lv_drives, 4, 110)
	$lv_drives_contextmenu = GUICtrlCreateContextMenu($lv_drives)
	$lv_drives_contextExplore = GUICtrlCreateMenuItem("Explore", $lv_drives_contextmenu)

	GUICtrlCreateTabItem("")

	$tab_allsoftware = GUICtrlCreateTabItem("All Applications")

	$lv_allsoftware = GUICtrlCreateListView("Applications", 275, 70, 490, 440, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_allsoftware, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	_GUICtrlListView_SetColumnWidth($lv_allsoftware, 0, 470)
	$lv_allsoftware_contextmenu = GUICtrlCreateContextMenu($lv_allsoftware)
	$lv_allsoftware_contextRefresh = GUICtrlCreateMenuItem("Refresh List", $lv_allsoftware_contextmenu)

	GUICtrlCreateTabItem("")

	$Status = GUICtrlCreateLabel("", 0, 520, 785, 20, BitOR($SS_SUNKEN, $SS_CENTER))
	#endregion **** create controls ****
	#region --- Show gui and process events ---
	GUISetState()

	If StringInStr($Domain, "YOUR-DOMAIN") Then _ConfigDomain($Domain, $MAIN_WINDOW)

	If Not StringInStr($Domain, "YOUR-DOMAIN") Then
		If $Retrieve_Method = "LDAP" Then
			_RetrieveComputersLdap($lv_pcs, $Domain, $filters, $Status, $i_TimeOut, _
					$lv_software, $lv_allsoftware, $lv_pid, $lv_drives, $lv_loggedin, $eb_system, $IP_Range)
		Else
			_RetrieveComputersNetView($lv_pcs, $Domain, $filters, $Status, $i_TimeOut, _
					$lv_software, $lv_allsoftware, $lv_pid, $lv_drives, $lv_loggedin, $eb_system, $IP_Range)
		EndIf
	EndIf

	GUICtrlSetState($ib_search, $GUI_FOCUS)

	$dll = DllOpen("user32.dll")

	While 1
		$msg = GUIGetMsg()

		$win_state = WinGetState($MAIN_WINDOW)
		If BitAND($win_state, 8) And BitAND($win_state, 2) Then _Monitor_InputBox($Title, $ib_search, $t_input, $dll, $Btn_Search, $msg)

		Select
			Case $msg = $GUI_EVENT_CLOSE Or $msg = $exititem
				ExitLoop

			Case $msg = $Btn_Search
				_LocateMachine($lv_pcs, $t_input, $Status)

			Case $msg = $lv_pcs_contextPopulate
				_PopulateMachineInfoLists($lv_pcs, $lv_software, $lv_allsoftware, $lv_pid, _
						$lv_services, $lv_loggedin, $lv_drives, $i_TimeOut, $eb_system, $Status)

			Case $msg = $lv_pcs_pslist_taskmode
				$s_Machine = _GUICtrlListView_GetItemText($lv_pcs, -1, 0)
				If ($s_Machine <> $LV_ERR) Then
					If _SetStatus($lv_pcs, Int(_GUICtrlListView_GetSelectedIndices($lv_pcs)), $Status, $i_TimeOut) Then
						Run('pslist.exe -s \\' & $s_Machine, @ScriptDir)
					EndIf
				EndIf

			Case $msg = $lv_pcs_pslist_taskmodetree
				$s_Machine = _GUICtrlListView_GetItemText($lv_pcs, -1, 0)
				If ($s_Machine <> $LV_ERR) Then
					If _SetStatus($lv_pcs, Int(_GUICtrlListView_GetSelectedIndices($lv_pcs)), $Status, $i_TimeOut) Then
						Run('pslist.exe -t -s \\' & $s_Machine, @ScriptDir)
					EndIf
				EndIf

			Case $msg = $lv_pcs_contextRefresh
				If $Retrieve_Method = "LDAP" Then
					_RetrieveComputersLdap($lv_pcs, $Domain, $filters, $Status, $i_TimeOut, _
							$lv_software, $lv_allsoftware, $lv_pid, $lv_drives, $lv_loggedin, $eb_system, $IP_Range)
				Else
					_RetrieveComputersNetView($lv_pcs, $Domain, $filters, $Status, $i_TimeOut, _
							$lv_software, $lv_allsoftware, $lv_pid, $lv_drives, $lv_loggedin, $eb_system, $IP_Range)
				EndIf

			Case $msg = $lv_software_contextRefresh
				$s_Machine = _GUICtrlListView_GetItemText($lv_pcs, -1, 0)
				If ($s_Machine <> $LV_ERR) Then
					If Ping($s_Machine) Then
						GUISetCursor($Cursor_WAIT, 1)
						_RetrieveSoftware($lv_software, $s_Machine)
						GUISetCursor($Cursor_ARROW, 1)
					EndIf
				EndIf

			Case $msg = $lv_service_contextRefresh
				$s_Machine = _GUICtrlListView_GetItemText($lv_pcs, -1, 0)
				If ($s_Machine <> $LV_ERR) Then
					If Ping($s_Machine) Then
						GUISetCursor($Cursor_WAIT, 1)
						_RetrieveServices($lv_services, $s_Machine)
						GUISetCursor($Cursor_ARROW, 1)
					EndIf
				EndIf

			Case $msg = $lv_service_stop
				_SetServiceState($lv_pcs, $lv_services, "Stop", $Status)
			Case $msg = $lv_service_start
				_SetServiceState($lv_pcs, $lv_services, "Start", $Status)
			Case $msg = $lv_service_pause
				_SetServiceState($lv_pcs, $lv_services, "Pause", $Status)
			Case $msg = $lv_service_resume
				_SetServiceState($lv_pcs, $lv_services, "Resume", $Status)
			Case $msg = $lv_service_startmodeBoot
				_SetServiceState($lv_pcs, $lv_services, "Boot", $Status)
			Case $msg = $lv_service_startmodeSystem
				_SetServiceState($lv_pcs, $lv_services, "System", $Status)
			Case $msg = $lv_service_startmodeAutomatic
				_SetServiceState($lv_pcs, $lv_services, "Automatic", $Status)
			Case $msg = $lv_service_startmodeManual
				_SetServiceState($lv_pcs, $lv_services, "Manual", $Status)
			Case $msg = $lv_service_startmodeDisabled
				_SetServiceState($lv_pcs, $lv_services, "Disabled", $Status)
			Case $msg = $lv_service_delete
				_SetServiceState($lv_pcs, $lv_services, "Delete", $Status)

			Case $msg = $lv_allsoftware_contextRefresh
				$s_Machine = _GUICtrlListView_GetItemText($lv_pcs, -1, 0)
				If ($s_Machine <> $LV_ERR) Then
					If Ping($s_Machine) Then
						GUISetCursor($Cursor_WAIT, 1)
						_RetrieveAllSoftware($lv_allsoftware, $s_Machine)
						GUISetCursor($Cursor_ARROW, 1)
					EndIf
				EndIf

			Case $msg = $lv_drives_contextExplore
				$s_Machine = _GUICtrlListView_GetItemText($lv_pcs, -1, 0)
				If ($s_Machine <> $LV_ERR) Then
					If Ping($s_Machine) Then
						Local $drive = _GUICtrlListView_GetItemText($lv_drives, -1, 0)
						If ($drive <> $LV_ERR) Then
							Run(@ComSpec & " /c start " & $explore_with & " \\" & $s_Machine & "\" & StringMid($drive, 1, 1) & "$\", "", @SW_HIDE)
						EndIf
					EndIf
				EndIf

			Case $msg = $lv_software_contextRemove
				If Ping($s_Machine) Then
					Local $a_sw = _GUICtrlListView_GetSelectedIndices($lv_software, 1)
					If IsArray($a_sw) Then
						For $i = 1 To $a_sw[0]
							GUISetCursor($Cursor_WAIT, 1)
							RunWait('psexec.exe -s \\' & $s_Machine & " " & "msiexec.exe /x " & _GUICtrlListView_GetItemText($lv_software, $a_sw[$i], 2) & " /qn /norestart", @ScriptDir, @SW_HIDE)
							GUISetCursor($Cursor_ARROW, 1)
						Next
					EndIf
					_RetrieveSoftware($lv_software, $s_Machine)
					GUICtrlSetData($Status, "Software that can be removed: " & _GUICtrlListView_GetItemCount($lv_software))
				EndIf

			Case $msg = $lv_pid_contextKill
				_KillProcess($s_Machine, $lv_pid, $Status)

			Case $msg = $lv_pid_contextRefresh
				If Ping($s_Machine) Then
					_RetrieveProcessList($lv_pid, $s_Machine)
				EndIf

			Case $msg = $Domainitem
				_ConfigDomain($Domain, $MAIN_WINDOW)

			Case $msg = $Filteritem
				_ConfigFilters($filter, $MAIN_WINDOW)

			Case $msg = $FilterIPitem
				_ConfigIpRange($IP_Range, $Use_IPRange, $MAIN_WINDOW)

			Case $msg = $ldapitem
				If BitAND(GUICtrlRead($ldapitem), $GUI_CHECKED) Then
					$Retrieve_Method = "LDAP"
					GUICtrlSetState($netvitem, $GUI_UNCHECKED)
				Else
					$Retrieve_Method = "NET VIEW"
					GUICtrlSetState($netvitem, $GUI_CHECKED)
				EndIf
				IniWrite(@ScriptDir & '\AdminTool.ini', "RetrievePcs", "Method", $Retrieve_Method)

			Case $msg = $netvitem
				If BitAND(GUICtrlRead($netvitem), $GUI_CHECKED) Then
					$Retrieve_Method = "NET VIEW"
					GUICtrlSetState($ldapitem, $GUI_UNCHECKED)
				Else
					$Retrieve_Method = "LDAP"
					GUICtrlSetState($ldapitem, $GUI_CHECKED)
				EndIf
				IniWrite(@ScriptDir & '\AdminTool.ini', "RetrievePcs", "Method", $Retrieve_Method)

			Case $msg = $PingTimeOutitem
				_ConfigPingTimeOut($i_TimeOut, $MAIN_WINDOW)

			Case $msg = $Aboutitem
				_About($Title, $MAIN_WINDOW)
		EndSelect
	WEnd
	DllClose($dll)
	#endregion --- Show gui and process events ---
EndFunc   ;==>_Main

#region --- Helper functions ---
Func _LocateMachine(ByRef $lv_pcs, ByRef $t_input, ByRef $Status)
	Local $found_pc = 0, $x
	GUISetCursor($Cursor_WAIT, 1)
	If _GUICtrlListView_GetSelectedIndices($lv_pcs) <> $LV_ERR And _
			_GUICtrlListView_GetSelectedIndices($lv_pcs) <> _GUICtrlListView_GetItemCount($lv_pcs) - 1 Then
		For $x = _GUICtrlListView_GetSelectedIndices($lv_pcs) + 1 To _GUICtrlListView_GetItemCount($lv_pcs) - 1
			If StringInStr(StringUpper(_GUICtrlListView_GetItemText($lv_pcs, $x, 0)), StringUpper($t_input)) Then
				GUICtrlSetState($lv_pcs, $GUI_FOCUS)
				_GUICtrlListView_Scroll($lv_pcs, 0, (_GUICtrlListView_GetItemCount($lv_pcs) * 17) * - 1)
				_GUICtrlListView_Scroll($lv_pcs, 0, $x * 17)
				_GUICtrlListView_SetItemState($lv_pcs, $x, $LVIS_FOCUSED, $LVIS_FOCUSED)
				$found_pc = 1
				ExitLoop
			EndIf
		Next
		If Not $found_pc Then
			For $x = 0 To _GUICtrlListView_GetSelectedIndices($lv_pcs)
				If StringInStr(StringUpper(_GUICtrlListView_GetItemText($lv_pcs, $x, 0)), StringUpper($t_input)) Then
					GUICtrlSetState($lv_pcs, $GUI_FOCUS)
					_GUICtrlListView_Scroll($lv_pcs, 0, (_GUICtrlListView_GetItemCount($lv_pcs) * 17) * - 1)
					_GUICtrlListView_Scroll($lv_pcs, 0, $x * 17)
					_GUICtrlListView_SetItemState($lv_pcs, $x, $LVIS_FOCUSED, $LVIS_FOCUSED)
					$found_pc = 1
					ExitLoop
				EndIf
			Next
		EndIf
	Else
		For $x = 0 To _GUICtrlListView_GetItemCount($lv_pcs) - 1
			If StringInStr(StringUpper(_GUICtrlListView_GetItemText($lv_pcs, $x, 0)), StringUpper($t_input)) Then
				GUICtrlSetState($lv_pcs, $GUI_FOCUS)
				_GUICtrlListView_Scroll($lv_pcs, 0, (_GUICtrlListView_GetItemCount($lv_pcs) * 17) * - 1)
				_GUICtrlListView_Scroll($lv_pcs, 0, $x * 17)
				_GUICtrlListView_SetItemState($lv_pcs, $x, $LVIS_FOCUSED, $LVIS_FOCUSED)
				$found_pc = 1
				ExitLoop
			EndIf
		Next
	EndIf
	GUISetCursor($Cursor_ARROW, 1)
	If Not $found_pc Then
		GUICtrlSetData($Status, $t_input & ' "NOT FOUND"')
	Else
		GUICtrlSetData($Status, '')
	EndIf
EndFunc   ;==>_LocateMachine

Func _PopulateMachineInfoLists(ByRef $lv_pcs, ByRef $lv_software, ByRef $lv_allsoftware, _
		ByRef $lv_pid, ByRef $lv_services, ByRef $lv_loggedin, ByRef $lv_drives, ByRef $i_TimeOut, _
		ByRef $eb_system, ByRef $Status)
	Local $s_Machine
	$s_Machine = _GUICtrlListView_GetItemText($lv_pcs, -1, 0)
	If ($s_Machine <> $LV_ERR) Then
		If _SetStatus($lv_pcs, Int(_GUICtrlListView_GetSelectedIndices($lv_pcs)), $Status, $i_TimeOut) Then
			_GetRole($s_Machine, $Status)
			_RetrieveSoftware($lv_software, $s_Machine)
			_RetrieveAllSoftware($lv_allsoftware, $s_Machine)
			_RetieveOSInfo($eb_system, $s_Machine)
			_RetrieveProcessList($lv_pid, $s_Machine)
			_RetrieveServices($lv_services, $s_Machine)
			_RetrieveLoggedInUsers($lv_loggedin, $s_Machine)
			_DriveInfo($lv_drives, $s_Machine)
		EndIf
	EndIf
EndFunc   ;==>_PopulateMachineInfoLists

Func _RetrieveComputersNetView(ByRef $h_listview, ByRef $Domain, ByRef $filters, ByRef $pc_status, ByRef $ping_timeout, _
		ByRef $lv_software, ByRef $lv_allsoftware, ByRef $lv_pid, ByRef $lv_drives, ByRef $lv_loggedin, ByRef $eb_system, $IP_Range = "")
	Local $lv_item, $num_pcs = 1, $Workstations, $inFilter, $return_code
	_LockAndWait()
	GUICtrlSetData($eb_system, "")
	_GUICtrlListView_DeleteAllItems($lv_software)
	_GUICtrlListView_DeleteAllItems($lv_allsoftware)
	_GUICtrlListView_DeleteAllItems($lv_pid)
	_GUICtrlListView_DeleteAllItems($lv_drives)
	_GUICtrlListView_DeleteAllItems($lv_loggedin)
	_GUICtrlListView_DeleteAllItems($h_listview)
	_ResetLockWait()
	_GUICtrlListView_SetColumnWidth($h_listview, 1, 140)
	_GUICtrlListView_HideColumn($h_listview, 2)
	GUISetCursor($Cursor_WAIT, 1)
	$return_code = RunWait(@ComSpec & " /c net view /domain:" & $Domain & ' > "' & @ScriptDir & '\pcs.txt"', "", @SW_HIDE)
	If $return_code Then
		GUICtrlSetData($pc_status, "The list of servers for this workgroup is not currently available: " & $Domain)
		Return 0
	EndIf

	If Not _FileReadToArray(@ScriptDir & "\pcs.txt", $Workstations) Then Return 0

	For $i = 4 To $Workstations[0] - 3
		$Workstations[$i] = StringMid($Workstations[$i], 3, 20)
		$Workstations[$i] = StringStripWS($Workstations[$i], 8)
		If $Workstations[$i] <> "" Then
			$inFilter = 0
			If $filters[0] = 1 And $filters[1] = "*" Then
				$inFilter = 1
			Else
				For $x = 1 To $filters[0]
					If StringUpper(StringMid($Workstations[$i], 1, StringLen($filters[$x]))) = StringUpper($filters[$x]) Then
						$inFilter = 1
						ExitLoop
					EndIf
				Next
			EndIf

			If $inFilter Then
				If IsArray($IP_Range) Then
					For $x = 1 To $IP_Range[0]
						Local $strIP = StringSplit(TCPNameToIP($Workstations[$i]), ".")
						Local $low_r = StringSplit($IP_Range[$x], "-")
						Local $high_r = $low_r[2]
						$low_r = StringSplit($low_r[1], ".")
						If (Int($strIP[1]) = Int($low_r[1]) And Int($strIP[2]) = Int($low_r[2]) And Int($strIP[3]) = Int($low_r[3])) And _
								(Int($strIP[4]) >= Int($low_r[4]) And Int($strIP[4]) <= Int($high_r)) Then
							$lv_item = GUICtrlCreateListViewItem($Workstations[$i] & "| | ", $h_listview)
							GUICtrlSetData($lv_item, $Workstations[$i] & "| |" & $lv_item)
							_SetStatus($h_listview, _GUICtrlListView_GetItemCount($h_listview) - 1, $pc_status, $ping_timeout)
							_ReduceMemory()
							GUICtrlSetData($pc_status, "Machines: " & $num_pcs)
							$num_pcs += 1
							ExitLoop
						EndIf
					Next
				Else
					$lv_item = GUICtrlCreateListViewItem($Workstations[$i] & "| | ", $h_listview)
					GUICtrlSetData($lv_item, $Workstations[$i] & "| |" & $lv_item)
					_SetStatus($h_listview, _GUICtrlListView_GetItemCount($h_listview) - 1, $pc_status, $ping_timeout)
					_ReduceMemory()
					GUICtrlSetData($pc_status, "Machines: " & $num_pcs)
					$num_pcs += 1
				EndIf
			EndIf
		EndIf
	Next
	FileDelete(@ScriptDir & "\pcs.txt")
	_GUICtrlListView_SetColumnWidth($h_listview, 0, 140)
	_GUICtrlListView_SetColumnWidth($h_listview, 1, 100)
	_GUICtrlListView_HideColumn($h_listview, 2)
	GUISetCursor($Cursor_ARROW, 1)
EndFunc   ;==>_RetrieveComputersNetView

Func _RetrieveComputersLdap(ByRef $h_listview, ByRef $Domain, ByRef $filters, ByRef $pc_status, ByRef $ping_timeout, _
		ByRef $lv_software, ByRef $lv_allsoftware, ByRef $lv_pid, ByRef $lv_drives, ByRef $lv_loggedin, ByRef $eb_system, $IP_Range = "")
	Local $lv_item, $num_pcs = 1, $inFilter
	_LockAndWait()
	GUICtrlSetData($eb_system, "")
	_GUICtrlListView_DeleteAllItems($lv_software)
	_GUICtrlListView_DeleteAllItems($lv_allsoftware)
	_GUICtrlListView_DeleteAllItems($lv_pid)
	_GUICtrlListView_DeleteAllItems($lv_drives)
	_GUICtrlListView_DeleteAllItems($lv_loggedin)
	_GUICtrlListView_DeleteAllItems($h_listview)
	_GUICtrlListView_DeleteAllItems($h_listview)
	_ResetLockWait()
	_GUICtrlListView_SetColumnWidth($h_listview, 1, 140)
	_GUICtrlListView_HideColumn($h_listview, 2)
	GUISetCursor($Cursor_WAIT, 1)
	Local $ObjDomain = ObjGet("WinNT://" & $Domain)
	Local $ip_address, $pc_name
	For $Object In $ObjDomain
		$ip_address = ""
		If $Object.class = "Computer" Then
			$pc_name = $Object.Name
			$inFilter = 0
			If $filters[0] = 1 And $filters[1] = "*" Then
				$inFilter = 1
			Else
				For $x = 1 To $filters[0]
					If StringUpper(StringMid($pc_name, 1, StringLen($filters[$x]))) = StringUpper($filters[$x]) Then
						$inFilter = 1
						ExitLoop
					EndIf
				Next
			EndIf

			If $inFilter Then
				If IsArray($IP_Range) Then
					For $x = 1 To $IP_Range[0]
						Local $strIP = StringSplit(TCPNameToIP($pc_name), ".")
						Local $low_r = StringSplit($IP_Range[$x], "-")
						Local $high_r = $low_r[2]
						$low_r = StringSplit($low_r[1], ".")
						If (Int($strIP[1]) = Int($low_r[1]) And Int($strIP[2]) = Int($low_r[2]) And Int($strIP[3]) = Int($low_r[3])) And _
								(Int($strIP[4]) >= Int($low_r[4]) And Int($strIP[4]) <= Int($high_r)) Then
							$lv_item = GUICtrlCreateListViewItem($pc_name & "| | ", $h_listview)
							GUICtrlSetData($lv_item, $pc_name & "| |" & $lv_item)
							_SetStatus($h_listview, _GUICtrlListView_GetItemCount($h_listview) - 1, $pc_status, $ping_timeout)
							_ReduceMemory()
							GUICtrlSetData($pc_status, "Machines: " & $num_pcs)
							$num_pcs += 1
							ExitLoop
						EndIf
					Next
				Else
					$lv_item = GUICtrlCreateListViewItem($pc_name & "| | ", $h_listview)
					GUICtrlSetData($lv_item, $pc_name & "| |" & $lv_item)
					_SetStatus($h_listview, _GUICtrlListView_GetItemCount($h_listview) - 1, $pc_status, $ping_timeout)
					_ReduceMemory()
					GUICtrlSetData($pc_status, "Machines: " & $num_pcs)
					$num_pcs += 1
				EndIf
			EndIf
		EndIf
	Next
	_GUICtrlListView_SetColumnWidth($h_listview, 0, 140)
	_GUICtrlListView_SetColumnWidth($h_listview, 1, 100)
	_GUICtrlListView_HideColumn($h_listview, 2)
	GUISetCursor($Cursor_ARROW, 1)
EndFunc   ;==>_RetrieveComputersLdap

Func _SetStatus(ByRef $lv_listview, $index, ByRef $Status, ByRef $ping_length)
	Local $pc_name = _GUICtrlListView_GetItemText($lv_listview, $index, 0)
	Local $ip_address = '', $ping_time
	If $ping_length Then
		$ping_time = Ping($pc_name, $ping_length)
		If $ping_time Then
			Local $lv_item = _GUICtrlListView_GetItemText($lv_listview, $index, 2)
			$ip_address = TCPNameToIP($pc_name)
			GUICtrlSetData($lv_item, $pc_name & "|" & $ip_address & "|" & $lv_item)
			GUICtrlSetImage($lv_item, @ScriptDir & "\OnLine.ico")
			_ReduceMemory()
			Return 1
		Else
			Local $lv_item = _GUICtrlListView_GetItemText($lv_listview, $index, 2)
			GUICtrlSetImage($lv_item, @ScriptDir & "\OffLine.ico")
		EndIf
	Else
		Local $lv_item = _GUICtrlListView_GetItemText($lv_listview, $index, 2)
		$ip_address = TCPNameToIP($pc_name)
		If $ip_address = "" Then $ip_address = " "
		GUICtrlSetData($lv_item, $pc_name & "|" & $ip_address & "|" & $lv_item)
		GUICtrlSetImage($lv_item, @ScriptDir & "\OnLine.ico")
		_ReduceMemory()
		Return 1
	EndIf
	_ReduceMemory()
	Return 0
EndFunc   ;==>_SetStatus

Func _GetRole(ByRef $s_pc, ByRef $Status)
	Local $objWMIService, $colComputer, $objComputer
	$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $s_pc & "\root\cimv2")
	If @error Then
		GUICtrlSetData($Status, "Unable to retrieve Role:" & $s_pc)
		Return
	EndIf
	$colComputer = $objWMIService.ExecQuery("Select * from Win32_ComputerSystem", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		GUICtrlSetData($Status, "Unable to retrieve Role:" & $s_pc)
		Return
	EndIf
	For $objComputer In $colComputer
		If Int($objComputer.DomainRole) = 1 Then
			GUICtrlSetData($Status, $s_pc & " is WorkStation")
		ElseIf Int($objComputer.DomainRole) = 3 Then
			GUICtrlSetData($Status, $s_pc & " is Server")
		ElseIf Int($objComputer.DomainRole) = 4 Then
			GUICtrlSetData($Status, $s_pc & " is Backup Domain Controller")
		ElseIf Int($objComputer.DomainRole) = 5 Then
			GUICtrlSetData($Status, $s_pc & " is Primary Domain Controller")
		Else
			GUICtrlSetData($Status, "Unable to retrieve Role:" & $s_pc)
		EndIf
		Return $objComputer.DomainRole
	Next
EndFunc   ;==>_GetRole

Func _RetrieveSoftware(ByRef $h_listview, ByRef $s_Machine)
	_LockAndWait()
	_GUICtrlListView_DeleteAllItems($h_listview)
	Local $even = 1, $i, $x, $items, $objWMIService, $colSoftware, $objSoftware
	$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $s_Machine & "\root\cimv2")
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_RetrieveSoftware", "ObjGet Error: winmgmts")
		Return
	EndIf
	$colSoftware = $objWMIService.ExecQuery("Select * from Win32_Product", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_RetrieveSoftware", "ExecQuery Error: Select * from Win32_Product")
		Return
	EndIf
;~ ********************************************************************
;~  no errors be it either hangs or takes forever to leave this loop
;~ ********************************************************************
;~ testing using the wbemtest.exe eventually comes back with error
;~ 0x80041013 Provider Load Failure, use SWbemLastError ?
;~ ********************************************************************
	For $objSoftware In $colSoftware
		If $objSoftware.Caption <> "0" Then
			If IsArray($items) Then
				ReDim $items[UBound($items) + 1]
			Else
				Dim $items[1]
			EndIf
			$items[UBound($items) - 1] = $objSoftware.Caption & "|" & $objSoftware.Version & "|" & $objSoftware.IdentifyingNumber
		EndIf
	Next
	_ArraySort($items)
	For $i = 0 To UBound($items) - 1
		Local $lv_item = GUICtrlCreateListViewItem($items[$i], $h_listview)
		If $even Then
			$even = 0
			GUICtrlSetBkColor($lv_item, 0xD1EEEE)
		Else
			$even = 1
		EndIf
	Next
	_GUICtrlListView_HideColumn($h_listview, 2)
	_ResetLockWait()
EndFunc   ;==>_RetrieveSoftware

Func _RetrieveAllSoftware(ByRef $h_listview, ByRef $s_Machine)
	_LockAndWait()
	_GUICtrlListView_DeleteAllItems($h_listview)
	Local $i, $Apps, $even = 1, $lv_item
	RunWait(@ComSpec & ' /c psinfo.exe -s \\' & $s_Machine & ' > "' & @ScriptDir & '\sw_info.txt"', @ScriptDir, @SW_HIDE)

	If Not _FileReadToArray(@ScriptDir & "\sw_info.txt", $Apps) Then Return 0

	For $i = 1 To $Apps[0]
		If StringInStr($Apps[$i], "Applications") Then ExitLoop
	Next

	GUISetState(@SW_LOCK)
	For $i = 20 To $Apps[0]
		If StringLen($Apps[$i]) == 0 Then ExitLoop
		$lv_item = GUICtrlCreateListViewItem($Apps[$i], $h_listview)
		If $even Then
			$even = 0
			GUICtrlSetBkColor($lv_item, 0xD1EEEE)
		Else
			$even = 1
		EndIf
	Next
	_ResetLockWait()
	FileDelete(@ScriptDir & "\sw_info.txt")
EndFunc   ;==>_RetrieveAllSoftware

;~ Func _RetrieveHotFixes(ByRef $h_listview, ByRef $s_Machine)
;~ 	_LockAndWait()
;~ 	_GUICtrlListView_DeleteAllItems ($h_listview)
;~ 	Local $even = 1, $i, $x, $items, $String, $objWMIService, $colSoftware, $objSoftware, $objWbem, $LastError
;~ 	$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $s_Machine & "\root\cimv2")
;~ 	If @error Then
;~ 		MsgBox(16, "_RetrieveHotFixes", "ObjGet Error: winmgmts")
;~ 		Return
;~ 	EndIf
;~ 	$colSoftware = $objWMIService.ExecQuery ("Select * from Win32_QuickFixEngineering", "WQL", _
;~ 			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
;~ 	If @error Then
;~ 		MsgBox(16, "_RetrieveHotFixes", "ExecQuery Error: Select * from Win32_QuickFixEngineering")
;~ 		Return
;~ 	EndIf
;~ 	For $objSoftware In $colSoftware
;~ 		$objWbem = ObjCreate("WbemScripting.SWbemLastError")
;~ 		For $LastError In $objWbem
;~ 			MsgBox(0, "Error?", "Operation: " & $LastError.Operation & @LF & _
;~ 					"ParameterInfo = " & $LastError.ParameterInfo & @LF & _
;~ 					"ProviderName = " & $LastError.ProviderName)
;~ 		Next
;~ 		If $objSoftware.HotFixID <> "File 1" Then
;~ 			If IsArray($items) Then
;~ 				ReDim $items[UBound($items) + 1]
;~ 			Else
;~ 				Dim $items[1]
;~ 			EndIf
;~ 			$items[UBound($items) - 1] = $objSoftware.HotFixID & "|" & $objSoftware.Description
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 To UBound($items) - 1
;~ 		Local $lv_item = GUICtrlCreateListViewItem($items[$i], $h_listview)
;~ 		If $even Then
;~ 			$even = 0
;~ 			GUICtrlSetBkColor($lv_item, 0xD1EEEE)
;~ 		Else
;~ 			$even = 1
;~ 		EndIf
;~ 	Next
;~ 	_ResetLockWait()
;~ EndFunc   ;==>_RetrieveHotFixes

Func _RetrieveProcessList(ByRef $h_listview, ByRef $s_Machine)
	_LockAndWait()
	_GUICtrlListView_DeleteAllItems($h_listview)
	Local $colItems = "", $even = 1, $objItem, $lv_item
	Local $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_RetrieveProcessList", "ObjGet Error: winmgmts")
		Return
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_RetrieveProcessList", "ExecQuery Error: Select * from Win32_Process")
		Return
	EndIf
	If IsObj($colItems) Then
		For $objItem In $colItems
			If $objItem.ExecutablePath Then
				$lv_item = GUICtrlCreateListViewItem(Int($objItem.ProcessId) & "|" & $objItem.Caption & "|" & $objItem.ExecutablePath, $h_listview)
			Else
				$lv_item = GUICtrlCreateListViewItem(Int($objItem.ProcessId) & "|" & $objItem.Caption & "| ", $h_listview)
			EndIf
			If $even Then
				$even = 0
				GUICtrlSetBkColor($lv_item, 0xD1EEEE)
			Else
				$even = 1
			EndIf
		Next
	EndIf
	_ResetLockWait()
EndFunc   ;==>_RetrieveProcessList

Func _KillProcess(ByRef $s_Machine, ByRef $lv_pid, ByRef $Status)
	Local $colItems = "", $even = 1, $objItem, $ret_status

	If Ping($s_Machine) Then
		Local $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
		If @error Then
			MsgBox(16, "_RetrieveProcessList", "ObjGet Error: winmgmts")
			Return
		EndIf
		Local $a_pid = _GUICtrlListView_GetSelectedIndices($lv_pid, 1)
		If IsArray($a_pid) Then
			For $i = 1 To $a_pid[0]
				Local $pid = _GUICtrlListView_GetItemText($lv_pid, $a_pid[$i], 0)
				Local $pname = _GUICtrlListView_GetItemText($lv_pid, $a_pid[$i], 1)
				GUISetCursor($Cursor_WAIT, 1)
				$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process", "WQL", _
						$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
				If @error Then
					MsgBox(16, "_RetrieveProcessList", "ExecQuery Error: Select * from Win32_Process")
					Return
				EndIf
				If IsObj($colItems) Then
					For $objItem In $colItems
						If $objItem.ProcessId = $pid Then
							$ret_status = $objItem.Terminate()
							Select
								Case $ret_status = 0
									GUICtrlSetData($Status, "Kill " & $pname & " Successful completion")
								Case $ret_status = 2
									GUICtrlSetData($Status, "Kill " & $pname & " Access denied")
								Case $ret_status = 3
									GUICtrlSetData($Status, "Kill " & $pname & " Insufficient privilege")
								Case $ret_status = 8
									GUICtrlSetData($Status, "Kill " & $pname & " Unknown failure")
								Case $ret_status = 9
									GUICtrlSetData($Status, "Kill " & $pname & " Path not found")
								Case $ret_status = 21
									GUICtrlSetData($Status, "Kill " & $pname & " Invalid parameter")
							EndSelect
						EndIf
					Next
				EndIf
			Next
			_RetrieveProcessList($lv_pid, $s_Machine)
		EndIf
	EndIf
EndFunc   ;==>_KillProcess

Func _RetrieveServices(ByRef $h_listview, ByRef $s_Machine)
	_LockAndWait()
	_GUICtrlListView_DeleteAllItems($h_listview)
	Local $colItems = "", $even = 1, $objItem, $lv_item
	Local $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_RetrieveServices", "ObjGet Error: winmgmts")
		Return
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_RetrieveServices", "ExecQuery Error: SELECT * FROM Win32_Service")
		Return
	EndIf
	If IsObj($colItems) Then
		For $objItem In $colItems
			Local $t_item = $objItem.DisplayName & "|" & $objItem.Name & "|" & _
					$objItem.ProcessId & "|" & $objItem.StartName & "|" & $objItem.StartMode & "|" & _
					$objItem.State & "|" & $objItem.PathName & "|" & $objItem.AcceptStop
			$lv_item = GUICtrlCreateListViewItem($t_item, $h_listview)
			If $even Then
				$even = 0
				GUICtrlSetBkColor($lv_item, 0xD1EEEE)
			Else
				$even = 1
			EndIf

		Next
		_GUICtrlListView_HideColumn($h_listview, 7)
	EndIf
	_ResetLockWait()
EndFunc   ;==>_RetrieveServices

Func _SetServiceState(ByRef $h_pcs, ByRef $h_services, $State, ByRef $Status)
	Local $colItems = "", $even = 1, $objItem, $ret_status = -1, $s_pc
	Local $a_status[25] = ["Success", "Not supported", "Access denied", "Dependent services running", _
			"Invalid service control", "Service cannot accept control", "Service not active", "Service request timeout", _
			"Unknown failure", "Path not found", "Service already stopped", "Service database locked", "Service dependency deleted", _
			"Service dependency failure", "Service disabled", "Service logon failed", "Service marked for deletion", "Service no thread", _
			"Status circular dependency", "Status duplicate name", "Status - invalid name", "Status - invalid parameter", _
			"Status - invalid service account", "Status - service exists", "Service already paused"]
	$s_pc = _GUICtrlListView_GetItemText($h_pcs, -1, 0)
	If ($s_pc <> $LV_ERR) Then
		If Ping($s_pc) Then
			Local $service = _GUICtrlListView_GetItemText($h_services, -1, 1)
			If ($service <> $LV_ERR) Then
				_LockAndWait()
				Local $objWMIService = ObjGet("winmgmts:\\" & $s_pc & "\root\CIMV2")
				If @error Then
					_ResetLockWait()
					MsgBox(16, "_SetServiceState", "ObjGet Error: winmgmts")
					Return
				EndIf
				$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service", "WQL", _
						$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
				If @error Then
					_ResetLockWait()
					MsgBox(16, "_SetServiceState", "ExecQuery Error: SELECT * FROM Win32_Service")
					Return
				EndIf
				If IsObj($colItems) Then
					For $objItem In $colItems
						If $objItem.Name = $service Then
							Select
								Case $State = "Boot" Or $State = "System" Or $State = "Automatic" Or $State = "Manual" Or $State = "Disabled"
									$ret_status = $objItem.ChangeStartMode($State)
								Case $State = "Stop"
									$ret_status = $objItem.StopService()
								Case $State = "Start"
									$ret_status = $objItem.StartService()
								Case $State = "Pause"
									$ret_status = $objItem.PauseService()
								Case $State = "Resume"
									$ret_status = $objItem.ResumeService()
								Case $State = "Delete"
									$ret_status = $objItem.Delete()
							EndSelect
							ExitLoop
						EndIf
					Next
				EndIf
				_RetrieveServices($h_services, $s_pc)
			EndIf
		EndIf
	EndIf
	If $ret_status <> -1 Then GUICtrlSetData($Status, $State & " " & $service & ": " & $a_status[$ret_status])
EndFunc   ;==>_SetServiceState

Func _RetrieveLoggedInUsers(ByRef $h_listview, ByRef $s_Machine)
	_LockAndWait()
	_GUICtrlListView_DeleteAllItems($h_listview)
	Local $line, $foo, $x, $Users, $even = 1, $lv_item
	$foo = Run('psloggedon.exe \\' & $s_Machine, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)

	While 1
		$line = StdoutRead($foo)
		If @error = -1 Then ExitLoop
		$Users = $line
	WEnd
	$Users = StringSplit($Users, @CRLF, 1)
	If Not StringInStr($Users[1], "Error") Then
		For $x = 2 To $Users[0]
			If StringLen($Users[$x]) == 0 Then ExitLoop
			$Users[$x] = StringTrimLeft($Users[$x], 5)
			If StringMid($Users[$x], 1, 9) = "<Unknown>" Then
				$Users[$x] = StringReplace($Users[$x], " ", "|", 1)
			Else
				$Users[$x] = StringReplace($Users[$x], "    ", "|", 1)
			EndIf
			$lv_item = GUICtrlCreateListViewItem($Users[$x], $h_listview)
			If $even Then
				$even = 0
				GUICtrlSetBkColor($lv_item, 0xD1EEEE)
			Else
				$even = 1
			EndIf
		Next
	EndIf
	_ResetLockWait()
EndFunc   ;==>_RetrieveLoggedInUsers

Func _RetieveOSInfo(ByRef $h_editbox, ByRef $s_Machine)
	Local $colItems = "", $objItem, $s_info
	Local $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
	If @error Then
		MsgBox(16, "_RetieveOSInfo", "ObjGet Error: winmgmts")
		Return
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		MsgBox(16, "_RetieveOSInfo", "ExecQuery Error: SELECT * FROM Win32_OperatingSystem")
		Return
	EndIf
	$s_info = "System:" & @CRLF & @TAB
	If IsObj($colItems) Then
		For $objItem In $colItems
			Local $name = StringSplit($objItem.Name, "|")
			$s_info = $s_info & $name[1] & @CRLF & @TAB
			$s_info = $s_info & "Version " & $objItem.Version & @CRLF & @TAB
			$s_info = $s_info & "Service Pack " & $objItem.ServicePackMajorVersion & @CRLF & @CRLF
			$s_info = $s_info & "Registered to:" & @CRLF & @TAB
			$s_info = $s_info & $objItem.RegisteredUser & @CRLF & @TAB
			$s_info = $s_info & $objItem.Organization & @CRLF & @TAB
			$s_info = $s_info & $objItem.SerialNumber & @CRLF & @CRLF
		Next
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		MsgBox(16, "_RetieveOSInfo", "ExecQuery Error: SELECT * FROM Win32_Processor")
		Return
	EndIf

	$s_info = $s_info & "Computer:" & @CRLF & @TAB
	If IsObj($colItems) Then
		For $objItem In $colItems
			$s_info = $s_info & StringStripWS($objItem.Name, 1) & @CRLF & @TAB
			If $objItem.MaxClockSpeed > 999 Then
				$s_info = $s_info & StringFormat("%1.2f", $objItem.MaxClockSpeed / 1000) & "GHz, "
			Else
				$s_info = $s_info & $objItem.MaxClockSpeed & "MHz, "
			EndIf
		Next
	EndIf

	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PhysicalMemory", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		MsgBox(16, "_RetieveOSInfo", "ExecQuery Error: SELECT * FROM Win32_PhysicalMemory")
		Return
	EndIf
	Local $t_ram = 0
	If IsObj($colItems) Then
		For $objItem In $colItems
			$t_ram += ((Int($objItem.Capacity) / 1024) / 1024)
		Next
	EndIf
	If $t_ram > 1024 Then
		$s_info = $s_info & StringFormat("%1.2f", Round($t_ram / 1000, 1)) & " GB of RAM" & @CRLF & @CRLF
	Else
		$s_info = $s_info & $t_ram & " MB of RAM" & @CRLF & @CRLF
	EndIf

	Local $ChassisType[25] = [24, 'Other', 'Unknown', 'Desktop', 'Low Profile Desktop', 'Pizza Box', 'Mini Tower', _
			'Tower', 'Portable', 'Laptop', 'Notebook', 'Hand Held', 'Docking Station', 'All in One', _
			'Sub Notebook', 'Space-Saving', 'Lunch Box', 'Main System Chassis', 'Expansion Chassis', _
			'SubChassis', 'Bus Expansion Chassis', 'Peripheral Chassis', 'Storage Chassis', _
			'Rack Mount Chassis', 'Sealed-Case PC']

	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_SystemEnclosure", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		MsgBox(16, "_RetieveOSInfo", "ExecQuery Error: SELECT * FROM Win32_SystemEnclosure")
		Return
	EndIf

	$s_info = $s_info & "Chassis Type: "
	If IsObj($colItems) Then
		For $objItem In $colItems
			$s_info = $s_info & @CRLF & @TAB & $ChassisType[$objItem.ChassisTypes(0)]
		Next
	EndIf

	GUICtrlSetData($h_editbox, $s_info)

EndFunc   ;==>_RetieveOSInfo

Func _DriveInfo(ByRef $h_listview, ByRef $s_Machine)
	_LockAndWait()
	_GUICtrlListView_DeleteAllItems($h_listview)
	Local $colItems = "", $objWMIService, $objItem, $SpaceTotal, $FreeSpace
	Local $strComputer = "localhost", $lv_item, $even = 1
	Local $DriveType[7] = ["Unknown", "No Root Directory", "Removable Disk", "Local Disk", "Network Drive", "Compact Disc", "RAM Disk"]

	Local $Output = ""
	$objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_DriveInfo", "ObjGet Error: winmgmts")
		Return
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If @error Then
		_ResetLockWait()
		MsgBox(16, "_DriveInfo", "ExecQuery Error: SELECT * FROM Win32_LogicalDisk")
		Return
	EndIf
	If IsObj($colItems) Then
		For $objItem In $colItems
			$SpaceTotal = ($objItem.Size / 1024) / 1024
			If ($SpaceTotal > 1024) Then
				$SpaceTotal = Round($SpaceTotal / 1024, 0) & " GB"
			ElseIf ($SpaceTotal > 0) Then
				$SpaceTotal = Round($SpaceTotal, 0) & " MB"
			EndIf
			$FreeSpace = ($objItem.FreeSpace / 1024) / 1024
			If ($FreeSpace > 1024) Then
				$FreeSpace = Round($FreeSpace / 1024, 0) & " GB"
			ElseIf ($FreeSpace > 0) Then
				$FreeSpace = Round($FreeSpace, 0) & " MB"
			EndIf
			$lv_item = GUICtrlCreateListViewItem($objItem.Caption & "|" & $DriveType[$objItem.DriveType] & "|" & $SpaceTotal & "|" & $FreeSpace & "|" & $objItem.FileSystem, $h_listview)
			If $even Then
				$even = 0
				GUICtrlSetBkColor($lv_item, 0xD1EEEE)
			Else
				$even = 1
			EndIf
		Next
	EndIf
	_ResetLockWait()
EndFunc   ;==>_DriveInfo

Func _Monitor_InputBox(ByRef $Title, ByRef $ib_search, ByRef $t_input, ByRef $dll, ByRef $Btn_Search, ByRef $msg)
	Local $WIN_SIZE
	If $t_input <> GUICtrlRead($ib_search) Then
		$t_input = GUICtrlRead($ib_search)
		If StringLen($t_input) = 0 Then
			GUICtrlSetState($Btn_Search, $GUI_DISABLE)
		Else
			GUICtrlSetState($Btn_Search, $GUI_ENABLE)
		EndIf
	EndIf
	$WIN_SIZE = WinGetClientSize($Title)
	If $WIN_SIZE[0] And $WIN_SIZE[1] Then
		If (ControlGetFocus($Title) = "Edit1" And StringLen($t_input) > 0) Then
			If _IsPressed("0D", $dll) Then $msg = $Btn_Search ; user pressed enter key
		EndIf
	EndIf
EndFunc   ;==>_Monitor_InputBox

#region --- Config functions ---
Func _ConfigDomain(ByRef $s_Domain, ByRef $MAIN_WINDOW)
	GUISetState(@SW_DISABLE, $MAIN_WINDOW)
	Local $Save, $LABEL, $CLOSE, $domain_msg, $Domain_Window
	$Domain_Window = GUICreate("Domain Config", 300, 140, -1, -1, -1, -1, $MAIN_WINDOW)
	#region --- CodeWizard generated code Start ---
	If Not IsDeclared('Cadet_Blue_3') Then Dim $Cadet_Blue_3 = 0x7AC5CD
	GUISetBkColor($Cadet_Blue_3)
	#endregion --- CodeWizard generated code Start ---
	GUICtrlCreateLabel("Domain to Search", 20, 10, 120, 20)
	Local $domain_input = GUICtrlCreateInput($s_Domain, 20, 40, 250, 20)
	$Save = GUICtrlCreateButton("Save", 20, 100, 120, 25)
	$CLOSE = GUICtrlCreateButton("Close", 160, 100, 120, 25)
	GUISetState()
	Do
		$domain_msg = GUIGetMsg()
		Select
			Case $domain_msg = $Save
				$s_Domain = GUICtrlRead($domain_input)
				IniWrite(@ScriptDir & '\AdminTool.ini', "domain", "name", $s_Domain)
			Case $domain_msg = $CLOSE
				ExitLoop
		EndSelect
	Until $domain_msg = $GUI_EVENT_CLOSE
	GUIDelete($Domain_Window)
	GUISetState(@SW_ENABLE, $MAIN_WINDOW)
	GUISetState(@SW_SHOW, $MAIN_WINDOW)
EndFunc   ;==>_ConfigDomain

Func _ConfigPingTimeOut(ByRef $i_TimeOut, ByRef $MAIN_WINDOW)
	GUISetState(@SW_DISABLE, $MAIN_WINDOW)
	Local $Save, $LABEL, $CLOSE, $TimeOut_msg, $TimeOut_Window
	$TimeOut_Window = GUICreate("Ping Time Out Config", 340, 140, -1, -1, -1, -1, $MAIN_WINDOW)
	#region --- CodeWizard generated code Start ---
	If Not IsDeclared('Cadet_Blue_3') Then Dim $Cadet_Blue_3 = 0x7AC5CD
	GUISetBkColor($Cadet_Blue_3)
	#endregion --- CodeWizard generated code Start ---
	GUICtrlCreateLabel("Ping Time Out (Milliseconds, 0 = no ping)", 10, 10, 320, 20, $ES_CENTER)
	Local $TimeOut_input = GUICtrlCreateInput($i_TimeOut, 90, 40, 150, 20, $ES_NUMBER)
	$Save = GUICtrlCreateButton("Save", 40, 100, 120, 25)
	$CLOSE = GUICtrlCreateButton("Close", 180, 100, 120, 25)
	GUISetState()
	Do
		$TimeOut_msg = GUIGetMsg()
		Select
			Case $TimeOut_msg = $Save
				$i_TimeOut = Int(GUICtrlRead($TimeOut_input))
				IniWrite(@ScriptDir & '\AdminTool.ini', "Ping", "TimeOut", $i_TimeOut)
			Case $TimeOut_msg = $CLOSE
				ExitLoop
		EndSelect
	Until $TimeOut_msg = $GUI_EVENT_CLOSE
	GUIDelete($TimeOut_Window)
	GUISetState(@SW_ENABLE, $MAIN_WINDOW)
	GUISetState(@SW_SHOW, $MAIN_WINDOW)
EndFunc   ;==>_ConfigPingTimeOut

Func _ConfigFilters(ByRef $s_filter, ByRef $MAIN_WINDOW)
	GUISetState(@SW_DISABLE, $MAIN_WINDOW)
	Local $Save, $LABEL, $CLOSE, $filter_msg, $Filter_Window, $win_state
	Local $lv_filters, $a_filter, $x, $filter_input, $Add, $Delete
	$Filter_Window = GUICreate("Filter Config", 300, 220, -1, -1, -1, -1, $MAIN_WINDOW)
	#region --- CodeWizard generated code Start ---
	If Not IsDeclared('Cadet_Blue_3') Then Dim $Cadet_Blue_3 = 0x7AC5CD
	GUISetBkColor($Cadet_Blue_3)
	#endregion --- CodeWizard generated code Start ---
	GUICtrlCreateLabel('PC Name Filter', 20, 10, 250, 20)
	GUICtrlCreateLabel("All Example: *", 20, 25, 250, 20)
	GUICtrlCreateLabel("Example: Z", 20, 40, 250, 20)
	$lv_filters = GUICtrlCreateListView("Filters", 20, 70, 100, 100, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_filters, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($lv_filters, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	_GUICtrlListView_SetColumnWidth($lv_filters, 0, 90)
	$a_filter = StringSplit($s_filter, "|")
	For $x = 1 To $a_filter[0]
		GUICtrlCreateListViewItem($a_filter[$x], $lv_filters)
	Next
	$filter_input = GUICtrlCreateInput("", 140, 70, 120, 20)
	$Add = GUICtrlCreateButton("Add", 140, 100, 120, 25)
	$Delete = GUICtrlCreateButton("Delete", 140, 130, 120, 25)
	GUICtrlSetState($Delete, $GUI_DISABLE)
	$Save = GUICtrlCreateButton("Save", 20, 190, 120, 25)
	$CLOSE = GUICtrlCreateButton("Close", 160, 190, 120, 25)
	GUISetState()
	Do
		$filter_msg = GUIGetMsg()
		Select
			Case $filter_msg = $Save
				If _GUICtrlListView_GetItemCount($lv_filters) > 0 Then
					$s_filter = ""
					For $x = 0 To _GUICtrlListView_GetItemCount($lv_filters) - 1
						$s_filter = $s_filter & "|" & _GUICtrlListView_GetItemText($lv_filters, $x, 0)
					Next
					$s_filter = StringTrimLeft($s_filter, 1)
					IniWrite(@ScriptDir & '\AdminTool.ini', "Workstations", "filter", $s_filter)
				EndIf
			Case $filter_msg = $Delete
				_GUICtrlListView_DeleteItemsSelected($lv_filters)
				GUICtrlSetState($Delete, $GUI_DISABLE)
			Case $filter_msg = $Add
				If StringLen(GUICtrlRead($filter_input)) Then GUICtrlCreateListViewItem(GUICtrlRead($filter_input), $lv_filters)
			Case $filter_msg = $CLOSE
				ExitLoop
			Case $filter_msg = $GUI_EVENT_PRIMARYDOWN
				$win_state = WinGetState($Filter_Window)
				If BitAND($win_state, 8) And BitAND($win_state, 2) Then
					If _GUICtrlListView_GetSelectedIndices($lv_filters) <> $LV_ERR Then
						GUICtrlSetState($Delete, $GUI_ENABLE)
					EndIf
				EndIf
		EndSelect
	Until $filter_msg = $GUI_EVENT_CLOSE
	GUIDelete($Filter_Window)
	GUISetState(@SW_ENABLE, $MAIN_WINDOW)
	GUISetState(@SW_SHOW, $MAIN_WINDOW)
EndFunc   ;==>_ConfigFilters

Func _ConfigIpRange(ByRef $a_IPRange, ByRef $Use_IPRange, ByRef $MAIN_WINDOW)
	GUISetState(@SW_DISABLE, $MAIN_WINDOW)
	Local $Save, $LABEL, $CLOSE, $filter_msg, $Filter_Window, $win_state, $ip, $nCurEdit = 0, $ip_tmp
	Local $lv_filters, $s_filter, $x, $filter_input[5], $filter_use, $Add, $Delete, $ip_len, $current_control
	$Filter_Window = GUICreate("IP Range Config", 360, 220, -1, -1, -1, -1, $MAIN_WINDOW)
	#region --- CodeWizard generated code Start ---
	If Not IsDeclared('Cadet_Blue_3') Then Dim $Cadet_Blue_3 = 0x7AC5CD
	GUISetBkColor($Cadet_Blue_3)
	#endregion --- CodeWizard generated code Start ---
	GUICtrlCreateLabel('Range(s) of IP Filter', 20, 10, 250, 20)
	$lv_filters = GUICtrlCreateListView("Start|End", 20, 40, 140, 140, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
	GUICtrlSendMsg($lv_filters, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($lv_filters, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	_GUICtrlListView_SetColumnWidth($lv_filters, 0, 90)
	If IsArray($a_IPRange) Then
		For $x = 1 To $a_IPRange[0]
			$s_filter = StringReplace($a_IPRange[$x], "-", "|")
			GUICtrlCreateListViewItem($s_filter, $lv_filters)
		Next
	EndIf
	$filter_use = GUICtrlCreateCheckbox("Use IP Range Inclusion Filter(s)", 170, 40)
	If $Use_IPRange Then GUICtrlSetState($filter_use, $GUI_CHECKED)

	$filter_input[0] = GUICtrlCreateInput("", 170, 70, 30, 20, $ES_NUMBER)
	GUICtrlSetLimit($filter_input[0], 3, 1)
	$filter_input[1] = GUICtrlCreateInput("", 205, 70, 30, 20, $ES_NUMBER)
	GUICtrlSetLimit($filter_input[1], 3, 1)
	$filter_input[2] = GUICtrlCreateInput("", 240, 70, 30, 20, $ES_NUMBER)
	GUICtrlSetLimit($filter_input[2], 3, 1)
	$filter_input[3] = GUICtrlCreateInput("", 275, 70, 30, 20, $ES_NUMBER)
	GUICtrlSetLimit($filter_input[3], 3, 1)
	GUICtrlCreateLabel("-", 310, 70, 10, 20)
	$filter_input[4] = GUICtrlCreateInput("", 320, 70, 30, 20, $ES_NUMBER)
	GUICtrlSetLimit($filter_input[4], 3, 1)
	$Add = GUICtrlCreateButton("Add", 170, 100, 120, 25)
	GUICtrlSetState($Add, $GUI_DISABLE)
	$Delete = GUICtrlCreateButton("Delete", 170, 130, 120, 25)
	GUICtrlSetState($Delete, $GUI_DISABLE)
	$Save = GUICtrlCreateButton("Save", 50, 190, 120, 25)
	$CLOSE = GUICtrlCreateButton("Close", 190, 190, 120, 25)
	GUISetState()
	GUICtrlSetState($filter_input[0], $GUI_FOCUS)
	Do
		$filter_msg = GUIGetMsg()
		$ip = _IsPressedMod()
		If $ip > 0 Then
			$ip_tmp = GUICtrlRead($filter_input[$nCurEdit])
			If (StringLen($ip_tmp) = 3) And Not ($ip = 8) Then
				If $nCurEdit = UBound($filter_input) - 1 Then ContinueLoop
				$nCurEdit = $nCurEdit + 1
				GUICtrlSetState($filter_input[$nCurEdit], $GUI_FOCUS)
			ElseIf (StringLen($ip_tmp) = 0) And ($ip = 8) Then
				If $nCurEdit = 0 Then ContinueLoop
				$nCurEdit = $nCurEdit - 1
				Sleep(200) ; make sure buffer clears
				GUICtrlSetState($filter_input[$nCurEdit], $GUI_FOCUS)
				GUICtrlSetData($filter_input[$nCurEdit], GUICtrlRead($filter_input[$nCurEdit]))
			EndIf
		EndIf
		; set current selection in case user hit tab key or used mouse to select input
		$current_control = ControlGetFocus($Filter_Window)
		Select
			Case $current_control = "Edit1" And $nCurEdit > 0
				$nCurEdit = 0
			Case $current_control = "Edit2" And $nCurEdit <> 1
				$nCurEdit = 1
			Case $current_control = "Edit3" And $nCurEdit <> 2
				$nCurEdit = 2
			Case $current_control = "Edit4" And $nCurEdit <> 3
				$nCurEdit = 3
			Case $current_control = "Edit5" And $nCurEdit < 4
				$nCurEdit = 4
		EndSelect

		Select
			Case $filter_msg = $Save
				If BitAND(GUICtrlRead($filter_use), $GUI_CHECKED) Then
					$Use_IPRange = 1
				Else
					$Use_IPRange = 0
				EndIf
				IniWrite(@ScriptDir & '\AdminTool.ini', "IP-Filter", "Use", $Use_IPRange)
				IniDelete(@ScriptDir & '\AdminTool.ini', "IP-Ranges")
				If _GUICtrlListView_GetItemCount($lv_filters) > 0 Then
					ReDim $a_IPRange[_GUICtrlListView_GetItemCount($lv_filters) + 1]
					$a_IPRange[0] = _GUICtrlListView_GetItemCount($lv_filters)
					For $x = 0 To _GUICtrlListView_GetItemCount($lv_filters) - 1
						$a_IPRange[$x + 1] = StringReplace(_GUICtrlListView_GetItemText($lv_filters, $x), "|", "-")
						IniWrite(@ScriptDir & '\AdminTool.ini', "IP-Ranges", "Range" & $x + 1, $a_IPRange[$x + 1])
					Next
				Else
					$a_IPRange = ""
				EndIf
			Case $filter_msg = $Delete
				_GUICtrlListView_DeleteItemsSelected($lv_filters)
				GUICtrlSetState($Delete, $GUI_DISABLE)
			Case $filter_msg = $Add
				$ip = ""
				For $x = 0 To 3
					$ip = $ip & GUICtrlRead($filter_input[$x]) & "."
				Next
				$ip = StringTrimRight($ip, 1)
				GUICtrlCreateListViewItem($ip & "|" & GUICtrlRead($filter_input[4]), $lv_filters)
				For $x = 0 To 4
					GUICtrlSetData($filter_input[$x], "")
				Next
				;***********************************
				$nCurEdit = 0
				;***********************************
			Case $filter_msg = $CLOSE
				ExitLoop
			Case $filter_msg = $GUI_EVENT_PRIMARYDOWN
				$win_state = WinGetState($Filter_Window)
				If BitAND($win_state, 8) And BitAND($win_state, 2) Then
					If _GUICtrlListView_GetSelectedIndices($lv_filters) <> $LV_ERR Then
						GUICtrlSetState($Delete, $GUI_ENABLE)
					EndIf
				EndIf
		EndSelect
		$ip_len = True
		For $x = 0 To 4
			If StringLen(GUICtrlRead($filter_input[$x])) == 0 Then
				$ip_len = False
				If ControlCommand($Filter_Window, "", $Add, "IsEnabled", "") Then GUICtrlSetState($Add, $GUI_DISABLE)
				ExitLoop
			EndIf
		Next
		If $ip_len And Not ControlCommand($Filter_Window, "", $Add, "IsEnabled", "") Then GUICtrlSetState($Add, $GUI_ENABLE)
	Until $filter_msg = $GUI_EVENT_CLOSE
	GUIDelete($Filter_Window)
	GUISetState(@SW_ENABLE, $MAIN_WINDOW)
	GUISetState(@SW_SHOW, $MAIN_WINDOW)
EndFunc   ;==>_ConfigIpRange
#endregion --- Config functions ---

Func _IsPressedMod()
	Local $aR, $bRv, $hexKey, $i
	For $i = 8 To 128
		$hexKey = '0x' & Hex($i, 2)
		$aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
		If $aR[0] <> 0 Then Return $i
	Next
	Return 0
EndFunc   ;==>_IsPressedMod

Func _GetIPRanges($IniFile, ByRef $IP_Range)
	Local $Ranges = IniReadSection($IniFile, "IP-Ranges"), $x
	If Not @error Then
		Dim $IP_Range[$Ranges[0][0] + 1]
		$IP_Range[0] = $Ranges[0][0]
		For $x = 1 To $Ranges[0][0]
			$IP_Range[$x] = $Ranges[$x][1]
		Next
	EndIf
EndFunc   ;==>_GetIPRanges

Func _ReduceMemory()
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func _LockAndWait()
	GUISetState(@SW_LOCK)
	GUISetCursor($Cursor_WAIT, 1)
EndFunc   ;==>_LockAndWait

Func _ResetLockWait()
	GUISetState(@SW_UNLOCK)
	GUISetCursor($Cursor_ARROW, 1)
	_ReduceMemory()
EndFunc   ;==>_ResetLockWait
#endregion --- Helper functions ---

#region --- About ---
Func _About(ByRef $Title, ByRef $MAIN_WINDOW)
	GUISetState(@SW_DISABLE, $MAIN_WINDOW)
	Local $CLOSE, $LABEL, $LABEL2, $about_msg, $ABOUT_WINDOW
	Local $ABOUT_TEXT = "Admin Tool" & @CRLF & _
			"Purpose / Logic:" & @CRLF & _
			"   Aid Admin Tasks" & @CRLF & @CRLF & _
			"Modifications:" & @CRLF & _
			"      09/28/05 - Started program" & @CRLF & _
			"      Last Modified date: 10/26/05" & @CRLF & @CRLF & _
			"Devolopment Team:"
	Local $ABOUT_AUTHOR = "Gary Frost"
	Local $MAILTO = "custompcs@charter.net"
	$ABOUT_WINDOW = GUICreate($Title, 600, 250, -1, -1, -1, -1, $MAIN_WINDOW)
	#region --- CodeWizard generated code Start ---
	If Not IsDeclared('Cadet_Blue_3') Then Dim $Cadet_Blue_3 = 0x7AC5CD
	GUISetBkColor($Cadet_Blue_3)
	#endregion --- CodeWizard generated code Start ---
	$LABEL = GUICtrlCreateLabel($ABOUT_TEXT, 10, 10, 450, 125)
	$LABEL2 = _GuiCtrlCreateHyperlink($ABOUT_AUTHOR, 27, 130, StringLen($ABOUT_AUTHOR) * 8, Default, 0x0000ff, 'E-Mail ' & $MAILTO & " (comments/questions)")
	$CLOSE = GUICtrlCreateButton("Close", 260, 190, 85, 20)
	GUISetState()
	Do
		$about_msg = GUIGetMsg()
		Select
			Case $about_msg = $CLOSE
				ExitLoop
			Case $about_msg = $LABEL2
				_INetMail($MAILTO, "Regarding " & $Title, "")
		EndSelect
	Until $about_msg = $GUI_EVENT_CLOSE
	GUIDelete($ABOUT_WINDOW)
	GUISetState(@SW_ENABLE, $MAIN_WINDOW)
	GUISetState(@SW_SHOW, $MAIN_WINDOW)
EndFunc   ;==>_About

Func _GuiCtrlCreateHyperlink($S_TEXT, $I_LEFT, $I_TOP, $I_WIDTH = -1, $I_HEIGHT = -1, $I_COLOR = 0x0000ff, $S_TOOLTIP = '', $I_STYLE = -1, $I_EXSTYLE = -1)
	Local $I_CTRLID
	$I_CTRLID = GUICtrlCreateLabel($S_TEXT, $I_LEFT, $I_TOP, $I_WIDTH, $I_HEIGHT, $I_STYLE, $I_EXSTYLE)
	If $I_CTRLID <> 0 Then
		GUICtrlSetFont($I_CTRLID, -1, -1, 4)
		GUICtrlSetColor($I_CTRLID, $I_COLOR)
		GUICtrlSetCursor($I_CTRLID, 0)
		If $S_TOOLTIP <> '' Then
			GUICtrlSetTip($I_CTRLID, $S_TOOLTIP)
		EndIf
	EndIf
	Return $I_CTRLID
EndFunc   ;==>_GuiCtrlCreateHyperlink
#endregion --- About ---
