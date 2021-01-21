; <AUT2EXE VERSION: 3.1.1.0>

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Documents and Settings\branden\Desktop\Client config\ClientConfig_test.au3>
; ----------------------------------------------------------------------------

; <AUT2EXE VERSION: 3.0.103.0>

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\ClientConfig.au3>
; ----------------------------------------------------------------------------


; Events and messages
Global $GUI_EVENT_CLOSE			= -3
Global $GUI_EVENT_MINIMIZE		= -4
Global $GUI_EVENT_RESTORE		= -5
Global $GUI_EVENT_MAXIMIZE		= -6
Global $GUI_EVENT_PRIMARYDOWN	= -7
Global $GUI_EVENT_PRIMARYUP		= -8
Global $GUI_EVENT_SECONDARYDOWN	= -9
Global $GUI_EVENT_SECONDARYUP	= -10
Global $GUI_EVENT_MOUSEMOVE		= -11


; State
Global $GUI_AVISTOP			= 0
Global $GUI_AVISTART		= 1
Global $GUI_AVICLOSE		= 2

Global $GUI_CHECKED			= 1
Global $GUI_INDETERMINATE	= 2
Global $GUI_UNCHECKED		= 4

Global $GUI_ACCEPTFILES		= 8

Global $GUI_SHOW			= 16
Global $GUI_HIDE 			= 32
Global $GUI_ENABLE			= 64
Global $GUI_DISABLE			= 128

Global $GUI_FOCUS			= 256
Global $GUI_DEFBUTTON		= 512

Global $GUI_EXPAND			= 1024


; Font
Global $GUI_FONTITALIC		= 2
Global $GUI_FONTUNDER		= 4
Global $GUI_FONTSTRIKE		= 8


; Resizing
Global $GUI_DOCKAUTO		= 1
Global $GUI_DOCKLEFT		= 2
Global $GUI_DOCKRIGHT		= 4
Global $GUI_DOCKHCENTER		= 8
Global $GUI_DOCKTOP			= 32
Global $GUI_DOCKBOTTOM		= 64
Global $GUI_DOCKVCENTER		= 128
Global $GUI_DOCKWIDTH		= 256
Global $GUI_DOCKHEIGHT		= 512

Global $GUI_DOCKSIZE		= 768	; width+height
Global $GUI_DOCKMENUBAR		= 544	; top+height
Global $GUI_DOCKSTATEBAR	= 576	; bottom+height
Global $GUI_DOCKALL			= 802	; left+top+width+height


; Window Styles
Global $WS_BORDER			= 0x00800000
Global $WS_POPUP			= 0x80000000
Global $WS_CAPTION			= 0x00C00000
Global $WS_DISABLED 		= 0x08000000
Global $WS_DLGFRAME 		= 0x00400000
Global $WS_HSCROLL			= 0x00100000
Global $WS_MAXIMIZE			= 0x01000000
Global $WS_MAXIMIZEBOX		= 0x00010000
Global $WS_MINIMIZE			= 0x20000000
Global $WS_MINIMIZEBOX		= 0x00020000
Global $WS_OVERLAPPED 		= 0
Global $WS_OVERLAPPEDWINDOW = 0x00CF0000
Global $WS_POPUPWINDOW		= 0x80880000
Global $WS_SIZEBOX			= 0x00040000
Global $WS_SYSMENU			= 0x00080000
Global $WS_THICKFRAME		= 0x00040000
Global $WS_TILED			= 0
Global $WS_TILEDWINDOW		= 0x00CF0000
Global $WS_VSCROLL			= 0x00200000
Global $WS_VISIBLE			= 0x10000000
Global $WS_CHILD			= 0x40000000
Global $WS_GROUP			= 0x00020000
Global $WS_TABSTOP			= 0x00010000

Global $DS_MODALFRAME 		= 0x80


; Window Extended Styles
Global $WS_EX_ACCEPTFILES		= 0x00000010
Global $WS_EX_APPWINDOW			= 0x00040000
Global $WS_EX_CLIENTEDGE		= 0x00000200
Global $WS_EX_CONTEXTHELP		= 0x00000400
Global $WS_EX_DLGMODALFRAME 	= 0x00000001
Global $WS_EX_LEFTSCROLLBAR 	= 0x00004000
Global $WS_EX_OVERLAPPEDWINDOW	= 0x00000300
Global $WS_EX_RIGHT				= 0x00001000
Global $WS_EX_STATICEDGE		= 0x00020000
Global $WS_EX_TOOLWINDOW		= 0x00000080
Global $WS_EX_TOPMOST			= 0x00000008
Global $WS_EX_TRANSPARENT		= 0x00000020
Global $WS_EX_WINDOWEDGE		= 0x00000100
Global $WS_EX_LAYERED			= 0x00080000


; Label
Global $SS_NOTIFY			= 0x0100
Global $SS_BLACKFRAME		= 7
Global $SS_BLACKRECT		= 4
Global $SS_CENTER			= 1
Global $SS_ETCHEDFRAME		= 18
Global $SS_ETCHEDHORZ		= 16
Global $SS_ETCHEDVERT		= 17
Global $SS_GRAYFRAME		= 8
Global $SS_GRAYRECT			= 5
Global $SS_LEFTNOWORDWRAP	= 12
Global $SS_NOPREFIX			= 0x0080
Global $SS_RIGHT			= 2
Global $SS_RIGHTJUST		= 0x0400
Global $SS_SIMPLE			= 11
Global $SS_SUNKEN			= 0x1000
Global $SS_WHITEFRAME		= 9
Global $SS_WHITERECT		= 6


; Button
Global $BS_BOTTOM			= 0x0800
Global $BS_CENTER			= 0x0300
Global $BS_DEFPUSHBUTTON	= 0x0001
Global $BS_LEFT				= 0x0100
Global $BS_MULTILINE		= 0x2000
Global $BS_PUSHBOX			= 0x000A
Global $BS_PUSHLIKE			= 0x1000
Global $BS_RIGHT			= 0x0200
Global $BS_RIGHTBUTTON		= 0x0020
Global $BS_TOP				= 0x0400
Global $BS_VCENTER			= 0x0C00
Global $BS_FLAT				= 0x8000
Global $BS_ICON				= 0x0040
Global $BS_BITMAP			= 0x0080


; Combo
Global $CBS_AUTOHSCROLL		= 64
Global $CBS_DISABLENOSCROLL	= 2048
Global $CBS_DROPDOWN		= 2
Global $CBS_DROPDOWNLIST	= 3
Global $CBS_LOWERCASE		= 16384
Global $CBS_NOINTEGRALHEIGHT = 1024
Global $CBS_OEMCONVERT		= 128
Global $CBS_SIMPLE			= 1
Global $CBS_SORT			= 256
Global $CBS_UPPERCASE		= 8192


; Listbox
Global $LBS_DISABLENOSCROLL	= 4096
Global $LBS_NOINTEGRALHEIGHT= 256
Global $LBS_NOSEL			= 16384
Global $LBS_SORT			= 2
Global $LBS_STANDARD		= 10485763
Global $LBS_USETABSTOPS		= 128


; Edit/Input
Global $ES_MULTILINE		= 4
Global $ES_AUTOHSCROLL		= 128
;Global $ES_DISABLENOSCROLL = 8192
Global $ES_AUTOVSCROLL		= 64
Global $ES_CENTER			= 1
;Global $ES_SUNKEN = 16384
Global $ES_LOWERCASE		= 16
Global $ES_NOHIDESEL		= 256
Global $ES_NUMBER			= 8192
Global $ES_OEMCONVERT		= 1024
;Global $ES_VERTICAL = 4194304
;Global $ES_SELECTIONBAR = 16777216
Global $ES_PASSWORD			= 32
Global $ES_READONLY			= 2048
Global $ES_RIGHT			= 2
Global $ES_UPPERCASE		= 8
Global $ES_WANTRETURN		= 4096


; Date
Global $DTS_UPDOWN			= 1
Global $DTS_SHOWNONE		= 2
Global $DTS_LONGDATEFORMAT	= 4
Global $DTS_TIMEFORMAT		= 9
Global $DTS_RIGHTALIGN		= 32


; Progress bar
Global $PBS_SMOOTH			= 1
Global $PBS_VERTICAL		= 4


; AVI clip
Global $ACS_CENTER			= 1
Global $ACS_AUTOPLAY		= 4
Global $ACS_TIMER			= 8
Global $ACS_NONTRANSPARENT	= 16


; Tab
Global $TCS_SCROLLOPPOSITE	= 0x0001
Global $TCS_BOTTOM			= 0x0002
Global $TCS_RIGHT			= 0x0002
Global $TCS_MULTISELECT		= 0x0004
Global $TCS_FLATBUTTONS		= 0x0008
Global $TCS_FORCEICONLEFT	= 0x0010
Global $TCS_FORCELABELLEFT	= 0x0020
Global $TCS_HOTTRACK		= 0x0040
Global $TCS_VERTICAL		= 0x0080
Global $TCS_TABS			= 0x0000
Global $TCS_BUTTONS			= 0x0100
Global $TCS_SINGLELINE		= 0x0000
Global $TCS_MULTILINE		= 0x0200
Global $TCS_RIGHTJUSTIFY	= 0x0000
Global $TCS_FIXEDWIDTH		= 0x0400
Global $TCS_RAGGEDRIGHT		= 0x0800
Global $TCS_FOCUSONBUTTONDOWN = 0x1000
Global $TCS_OWNERDRAWFIXED	= 0x2000
Global $TCS_TOOLTIPS		= 0x4000
Global $TCS_FOCUSNEVER		= 0x8000


; TreeView
Global $TVS_HASBUTTONS     =     0x0001
Global $TVS_HASLINES       =     0x0002
Global $TVS_LINESATROOT    =     0x0004
;Global $TVS_EDITLABELS      =    0x0008
Global $TVS_DISABLEDRAGDROP  =   0x0010
Global $TVS_SHOWSELALWAYS   =    0x0020
;Global $TVS_RTLREADING     =     0x0040
Global $TVS_NOTOOLTIPS     =     0x0080
Global $TVS_CHECKBOXES     =     0x0100
Global $TVS_TRACKSELECT    =     0x0200
Global $TVS_SINGLEEXPAND   =     0x0400
;Global $TVS_INFOTIP        =     0x0800
Global $TVS_FULLROWSELECT   =    0x1000
Global $TVS_NOSCROLL         =   0x2000
Global $TVS_NONEVENHEIGHT   =    0x4000
;Global BPB Variables
Global $ReadUSA
Global $ReadCanada
Global $ReadSiteCombo
Global $ReadUsername
Global $ReadComputername
Global $Context
Opt("GuiOnEventMode", 1)
$Part2 = RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\", "Reboot")
If $Part2 = "Yes" Then
	Call ("RegistryTweak")
Else
;Create GUI
$parent = GUICreate("BPB Client Configuration Utility", 400, 200)
GUISetIcon ("bpb.ico")
GuiSetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUICtrlCreateGroup ("Country", 10, 10, 90, 100)

;Create Radio Button
$USA = GUICtrlCreateRadio ("USA", 15, 30, 70, 20)
$CANADA = GUICtrlCreateRadio ("CANADA", 15, 70, 70, 20)

;Set Control Events for Radio Buttons
GuiCtrlSetOnEvent($USA, "USA")
GuiCTRLSetOnEvent($CANADA, "CANADA")

;Create Combo Site List
GUICtrlCreateLabel ("Site",  120, 10, 50)
$SiteCombo = GUICtrlCreateCombo ("", 120, 30, 90)

;Create Input Fields
GUICtrlCreateGroup ("Enter Username", 250, 10, 120, 60)
GUICtrlCreateGroup ("Enter Computername", 250, 80, 120, 60)
$Username = GUICtrlCreateInput ("", 260, 30, 100, 20)
$Computername = GUICtrlCreateInput ("", 260, 100, 100, 20)

;Create OK and Cancel
$OKButton = GUICtrlCreateButton ("OK",  10, 120, 90)
$CancelButton = GUICtrlCreateButton ("Cancel",  10, 150, 90)
GuiCtrlSetOnEvent($OKButton, "OKBUTTON")
GuiCTRLSetOnEvent($CancelButton, "CANCELBUTTON")
GuiSetState (); End of GUI Interface
EndIf
; Run the GUI until the dialog is closed
While 1
    $msg = GUIGetMsg()

    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend


Func USA();For Radio Button USA Selected
GUICtrlSetData ($SiteCombo,"|Apex|Carrollton|Clearwater|Cody|FoothillRanch|FortDodge|Jacksonville|JunctionCity|Kent|Lanse|LasVegas|Meridian|MobileUS|Napa|Nashville|Plymouth|Seattle|StGeorge|Tampa", "Apex")
EndFunc

Func CANADA();For Radio Button CANADA Selected
GUICtrlSetData ($SiteCombo,"|Calgary|CalgaryFP|Invermere|McAdam|Mississauga|MobileCA|Montreal|Oakville|OakvilleFP|Toronto|Vancouver|Windsor|Winnipeg", "Calgary")
EndFunc

Func OKBUTTON()
$ReadUSA = GUICtrlRead($USA)
$ReadCanada = GUICtrlRead($Canada)
$ReadSiteCombo = GUICtrlRead($SiteCombo)
$ReadUsername = GUICtrlRead($Username)
$ReadComputername = GUICtrlRead($Computername)
If $ReadUSA = 1 Then
	$Context = $ReadSiteCombo & ".us.bpb"
		ElseIf	$ReadCanada = 1 Then
	$Context = $ReadSiteCombo & ".ca.bpb"
EndIF

If $ReadUSA = 4 AND $ReadCanada = 4 Then
	MsgBox (16, "Error", "You are missing information")
ElseIf $ReadUsername = "" Then
	MsgBox (16, "Error", "You are missing information")
Else
	If $ReadComputername = "" OR $ReadSiteCombo = "" Then
	MsgBox (16, "Error", "You are missing information")
	Else
	Call ("UpdateUserInfo")
	EndIf
EndIf
EndFunc

Func UpdateUserInfo()

RunWait (@comspec & " /c net user administrator *edited out :)*")
RunWait (@comspec & " /c net user " & $ReadUsername & " /add")
RunWait (@comspec & " /c net localgroup administrators /add " & $ReadUsername)
RunWait (@comspec & " /c net user install /DELETE")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\NWGINA\Login Screen", "DefaultNDSContext", "REG_SZ", $Context)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\NWGINA\Login Screen", "DefaultNetWareUserName", "REG_SZ", $ReadUsername)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName", "Computername", "REG_SZ", $ReadComputername)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName", "Computername", "REG_SZ", $ReadComputername)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nm\Parameters", "Computername", "REG_SZ", $ReadComputername)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "Hostname", "REG_SZ", $ReadComputername)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "NV Hostname", "REG_SZ", $ReadComputername)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName", "REG_SZ", $Readusername)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AltDefaultUserName", "REG_SZ", $Readusername)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword", "REG_SZ", "")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon", "REG_SZ", "1")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon", "REG_SZ", "1")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "AutoAdminLogon", "REG_SZ", "1")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "DefaultUserName", "REG_SZ", $ReadUsername)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "Local Login", "REG_DWORD", "1")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "DefaultPassword", "REG_SZ", "")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", "ClientConfig", "REG_SZ", @ScriptDir & "\ClientConfig.exe")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Location Profiles\Services\{1E6CEEA1-FB73-11CF-BD76-00001B27DA23}\Default\tab3", "DefaultUserName", "REG_SZ", $ReadUsername)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Location Profiles\Services\{1E6CEEA1-FB73-11CF-BD76-00001B27DA23}\Default\tab1", "Context", "REG_SZ", $Context)
RegDelete ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "dla")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\", "Reboot", "REG_SZ", "Yes")
Shutdown (0)
WinClose ("BPB Client Configuration Utility")
EndFunc

Func CANCELBUTTON()
$PressCancel = MsgBox (52, "Cancel", "Are you sure you would like to cancel?")
If $PressCancel = 6 Then
Exit
	Else
WinClose ("Close")
EndIf
EndFunc

;Close Event
Func SpecialEvents()
    Select
        Case @GUI_CTRLID = $GUI_EVENT_CLOSE
            Exit
  EndSelect
EndFunc


Func RegistryTweak()
If FileExists (@ProgramFilesDir & "\IBM\IBM Rapid Restore Ultra\rrucmd.exe") Then
RunWait (@comspec &  ' /c AT 12:00 /EVERY:w,f cmd /c C:\\"""Program Files"""\IBM\\"""IBM Rapid Restore Ultra"""\rrucmd backup location=L name=RRUBackup silent"')
EndIf
ProgressOn ("Registry Tweak", "Now Modifying registry", "", -1, -1, 2)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main", "IEWatsonEnabled", "REG_DWORD", "0")
RegWrite ("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "AutoConfigURL", "REG_SZ", "                                 ")
ProgressSet (10)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main", "Window Title", "REG_SZ", "Internet Explorer Provided By BPB In North America")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RasMan\Parameters", "DisableSavePassword", "REG_DWORD", "1")
ProgressSet (20)
Sleep (1000)
RegWrite ("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "EnableBalloonTips", "REG_DWORD", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation", "MaxCmds", "REG_DWORD", "0x0000001e")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation", "MaxThreads", "REG_DWORD", "0x0000001e")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation", "MaxCollectionCount", "REG_DWORD", "0x00000020")
ProgressSet (30)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BridgeMP", "DisableForwarding", "REG_DWORD", "0x00000001")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BridgeMP", "DisableSTA", "REG_DWORD", "0x00000001")
ProgressSet (40)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "AllowTSConnections", "REG_DWORD", "0x00000000")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fDenyTSConnections", "REG_DWORD", "0x00000001")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server", "fAllowToGetHelp", "REG_DWORD", "0x00000000")
ProgressSet (50)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "EnableDeadGWDetect", "REG_DWORD", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "EnableICMPRedirect", "REG_DWORD", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "EnablePMTUDiscovery", "REG_DWORD", "0")
ProgressSet (60)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "KeepAliveTime", "REG_DWORD", "300000")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "NoNameReleaseOnDemand", "REG_DWORD", "1")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "PerformRouteDiscovery", "REG_DWORD", "0")
ProgressSet (70)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "SynAttackProtect", "REG_DWORD", "0x00000002")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "EnablePMTUDiscovery", "REG_DWORD", "1")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole", "SecurityLevel", "REG_DWORD", "1")
ProgressSet (80)
Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management", "ClearPageFileAtShutdown", "REG_DWORD", "1")
RegWrite ("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Messenger", "Start", "REG_DWORD", "0x00000004")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole", "SecurityLevel", "REG_DWORD", "0")
RegDelete ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "ibmmessages")
RegDelete ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Mouse Suite 98 Daemon")
RegDelete ("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "ibmmessages")
RegDelete ("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "msmsgs")
ProgressSet (90)

Sleep (1000)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "BGInfo", "REG_SZ", @WindowsDir & "\Options\BGInfo.exe " & @WindowsDir & "\Options\ClientINFO.bgi /timer:0")
RegWrite ("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "CaptionHeight", "REG_SZ", "-300")
RegWrite ("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "CaptionWidth", "REG_SZ", "-270")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "Local Login", "REG_DWORD", "0")
RegWrite ("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "MinAnimate", "REG_SZ", "0")
RegWrite ("HKEY_CURRENT_USER\Control Panel\Desktop", "SmoothScroll", "REG_DWORD", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "Local Login", "REG_DWORD", "0")
ProgressSet (100)
Sleep (2000)
ProgressOff()
If FileExists (@ProgramFilesDir & "\IBM\IBM Rapid Restore Ultra\tvt.txt") Then
IniWrite (@ProgramFilesDir & "\IBM\IBM Rapid Restore Ultra\tvt.txt", "RapidRestoreUltra", "MaxNumberOfIncrementalBackups", "2")
EndIf
Call ("CitrixInstall")
EndFunc
;-------------------------------------------------------------------------------------------------------
Func CitrixInstall()
SplashTextOn ("Citrix Install", "Please wait as Citrix is now installed and configured", 400, 25)
Sleep (5000)
SplashOff ()
Run (@WindowsDir & "\Options\ICA32.exe")
WinWaitActive ("Citrix ICA 32-bit Windows Client - InstallShield Wizard")
Send ("!n")
WinWaitActive ("Welcome")
Send ("!n")
WinWaitActive ("Citrix License Agreement")
Send ("!y")
WinWaitActive ("Choose Destination Location")
Send ("!n")
WinWaitActive ("Select Program Folder")
Send ("!n")
WinWaitActive ("Select Client Name")
Send ("!n")
WinWaitActive ("Select Desired Features")
Send ("!n")
WinWaitActive ("Information")
Send ("{ENTER}")
WinWaitClose ("Information")
$r = @AppDataDir & "\ICAClient\*.*"
FileCopy (@WindowsDir & "\Options\pn.ini", $r, 1)
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName", "REG_SZ", "")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword", "REG_SZ", "")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon", "REG_SZ", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon", "REG_SZ", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "Default WS Only", "REG_DWORD", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "AutoAdminLogin", "REG_SZ", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Novell\Login", "Local Login", "REG_DWORD", "0")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", "InstallRemove", "REG_SZ", "CMD /c rd /S /Q C:\Docume~1\Install")
RegWrite ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "ANewUser", "REG_SZ", @WindowsDir & "\Options\NewUser.exe")
SplashTextOn ("Citrix Install", "Citirx install complete. Now Rebooting.", 400, 25)
RegDelete ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\", "Reboot")

Sleep (5000)
SplashOff ()
Shutdown (2)
      Exit

      EndFunc

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\ClientConfig.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Documents and Settings\branden\Desktop\Client config\ClientConfig_test.au3>
; ----------------------------------------------------------------------------

