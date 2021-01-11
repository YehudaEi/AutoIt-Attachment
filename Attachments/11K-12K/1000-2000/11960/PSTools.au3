;~ A fromt end for PStools FROM Mark Russinovich 
;~  (or whatever else it is you want to add)
;	it expects the pstools programs and dll to eb in the same directory as the script
;~  
;~ What you see as the command line is executed this means that 
;~ if you wish to change the command sent then simply edit it and hit 'Go'
;  
;~  
;~ Uses Event mode to keep the command line updated 
;~ (Well all except the last control changed)  
;~ this is why there is the Click Here in the header
;~  
;~ It is easy to add your own tools to this
;~ Simply add another TAB with required parameters on it
;~ Add a tabname change function that sets the $PSCommandLine input box to the required value
;~ That it
;
;~ Known issues
;~ 	Event mode works well except for changes in the last field
;~ 	Not all parameters for all tools are catered for (Only those I use regularly) (but you can add them manually)
;~ 	Validation is still a little loose so you need to know a little about PStools
;~ 	Does not handle things very well when the progrm being run wants an enter keypress
;~ 	PSloglist has not been completed (OK, not even started)
;~ 	
;~ Does not save previously entered values

#include <Constants.au3>
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)

Global $prog = ""			; The program to run
Global $start = ""			; Normally The Where and the Who UID & PWD (from the header)
Global $progparms = ""		; the other parameters for the program

#Region ### START Koda GUI section ### Form=c:\program files\autoit3\koda\forms\pstools.kxf
$PSTools = GUICreate("PSTools", 666, 492, 193, 115)
$Tab1 = GUICtrlCreateTab(8, 112, 649, 225)
GUICtrlSetOnEvent(-1, "Tab1Click")
#Region Execute
$TabSheet1 = GUICtrlCreateTabItem("Exec")
$Group1 = GUICtrlCreateGroup("Program", 16, 136, 409, 193)
$LabelProgram = GUICtrlCreateLabel("Program : ", 64, 160, 52, 17, $SS_RIGHT)
$LabelArgs= GUICtrlCreateLabel("Arguments :", 56, 184, 60, 17, $SS_RIGHT)
$LabelWorking = GUICtrlCreateLabel("Remote Work Dir. :", 24, 208, 95, 17, $SS_RIGHT)
$CheckboxRunAsSystem = GUICtrlCreateCheckbox("Run as System", 24, 240, 97, 17)
GUICtrlSetOnEvent(-1, "ExecChange")
$CheckboxInteractWithDeskTop = GUICtrlCreateCheckbox("Interact with Remote Desktop", 200, 240, 170, 17)
GUICtrlSetOnEvent(-1, "ExecChange")
$CheckboxLoadAccountProfile = GUICtrlCreateCheckbox("Load Account Profile", 24, 264, 137, 17)
GUICtrlSetOnEvent(-1, "ExecChange")
$InputAccountProfile = GUICtrlCreateInput("", 24, 288, 385, 21)
GUICtrlSetOnEvent(-1, "ExecChange")
$InputProgram = GUICtrlCreateInput("", 120, 160, 273, 21)
GUICtrlSetOnEvent(-1, "ExecChange")
$InputArgs = GUICtrlCreateInput("", 120, 184, 297, 21)
GUICtrlSetOnEvent(-1, "ExecChange")
$InputWorking = GUICtrlCreateInput("", 120, 208, 297, 21)
GUICtrlSetOnEvent(-1, "ExecChange")
$Button1 = GUICtrlCreateButton("...", 400, 160, 17, 21, 0)
GUICtrlSetOnEvent(-1, "FindProg")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Copy", 432, 136, 217, 73)
$CheckboxCopyProgram = GUICtrlCreateCheckbox("Copy Program", 440, 152, 97, 17)
GUICtrlSetOnEvent(-1, "ExecChange")
$CheckboxOverWrite = GUICtrlCreateCheckbox("Overwrite", 440, 176, 73, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ExecChange")
$CheckboxOnlyIfNewer = GUICtrlCreateCheckbox("Only if newer", 544, 176, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ExecChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Process", 432, 216, 217, 113)
$InputProcessors = GUICtrlCreateInput("", 512, 232, 129, 21)
GUICtrlSetOnEvent(-1, "ExecChange")
$CheckboxDontWait = GUICtrlCreateCheckbox("Don't wait", 512, 296, 105, 17)
GUICtrlSetOnEvent(-1, "ExecChange")
$ComboPriority = GUICtrlCreateCombo("", 512, 264, 129, 25)
GUICtrlSetData(-1,"|-low|-belownormal|-abovenormal|-high|-realtime","")
GUICtrlSetOnEvent(-1, "ExecChange")
$Label1 = GUICtrlCreateLabel("Processors :", 448, 232, 62, 17)
$Label5 = GUICtrlCreateLabel("Priority :", 472, 264, 41, 17)

GUICtrlCreateGroup("", -99, -99, 1, 1)
#EndRegion 
#region File
$TabSheet2 = GUICtrlCreateTabItem("File")
$Group12 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$Label26 = GUICtrlCreateLabel("ID/Path :", 24, 164, 52, 17)
$InputPath = GUICtrlCreateInput("", 76, 164, 547, 21)
GUICtrlSetOnEvent(-1, "FileChange")
$CheckboxCloseFiles = GUICtrlCreateCheckbox("Close files", 76, 196, 73, 17)
GUICtrlSetOnEvent(-1, "FileChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region GetSid
$TabSheet3 = GUICtrlCreateTabItem("GetSID")
$Group11 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$Label24 = GUICtrlCreateLabel("Account :", 24, 152, 50, 17, $SS_RIGHT)
$InputAccount = GUICtrlCreateInput("", 80, 152, 225, 21)
GUICtrlSetOnEvent(-1, "GetSidChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region Info
$TabSheet4 = GUICtrlCreateTabItem("Info")
$Group13 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$CheckboxShowHotfixes = GUICtrlCreateCheckbox("Show HotFixes", 32, 152, 97, 17)
GUICtrlSetOnEvent(-1, "InfoChange")
$CheckboxShowSoftware = GUICtrlCreateCheckbox("Show Software", 32, 176, 97, 17)
GUICtrlSetOnEvent(-1, "InfoChange")
$CheckboxShowDiskVolInfo = GUICtrlCreateCheckbox("Show Disk Volume Information", 32, 200, 209, 17)
GUICtrlSetOnEvent(-1, "InfoChange")
$CheckboxDumpinCSV = GUICtrlCreateCheckbox("Dump in CSV format", 32, 224, 121, 17)
GUICtrlSetOnEvent(-1, "InfoChange")
$Label27 = GUICtrlCreateLabel("Delimiter", 56, 248, 44, 17)
GUICtrlSetOnEvent(-1, "InfoChange")
$InputInfoDelimiter = GUICtrlCreateInput(",", 104, 248, 49, 21)
GUICtrlSetOnEvent(-1, "InfoChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region Kill / Suspend
$TabSheet5 = GUICtrlCreateTabItem("Kill/Suspend")
$Group10 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$RadioKill = GUICtrlCreateRadio("Kill", 150, 152, 40, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "KillChange")
$CheckboxDecendants = GUICtrlCreateCheckbox("and all Decendants", 220, 152, 120, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "KillChange")
$RadioSuspend = GUICtrlCreateRadio("Suspend", 150, 176, 113, 17)
GUICtrlSetOnEvent(-1, "KillChange")
$RadioResume = GUICtrlCreateRadio("Resume", 150, 200, 113, 17)
GUICtrlSetOnEvent(-1, "KillChange")
$Label23 = GUICtrlCreateLabel("Process ID/Name :", 24, 235, 120, 17, $SS_RIGHT)
$InputProcessIDName = GUICtrlCreateInput("", 150, 235, 150, 21)
GUICtrlSetOnEvent(-1, "KillChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region List
$TabSheet6 = GUICtrlCreateTabItem("List")
$Group9 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$Label18 = GUICtrlCreateLabel("Process ID/Name :", 12, 152, 110, 17, $SS_RIGHT)
$InputListProcessIDName = GUICtrlCreateInput("", 124, 152, 225, 21)
GUICtrlSetOnEvent(-1, "ListChange")
$CheckboxUseTaskMgr = GUICtrlCreateCheckbox("Use Task Manager Mode", 376, 152, 193, 17)
GUICtrlSetOnEvent(-1, "ListChange")
$CheckboxShowAllActive = GUICtrlCreateCheckbox("Show all Active Threads", 376, 176, 185, 17)
GUICtrlSetOnEvent(-1, "ListChange")
$CheckboxShowMemInfo = GUICtrlCreateCheckbox("Show Memory Information", 376, 200, 145, 17)
GUICtrlSetOnEvent(-1, "ListChange")
$CheckboxShowCPU = GUICtrlCreateCheckbox("Show CPU, Memory and Thread Information", 376, 224, 241, 17)
GUICtrlSetOnEvent(-1, "ListChange")
$CheckboxShowProcessTree = GUICtrlCreateCheckbox("Show Process Tree", 376, 248, 121, 17)
GUICtrlSetOnEvent(-1, "ListChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region Logged on THIS MUST REMAIN TAB 6 otherwise edit HeaderChange appropriately
$TabSheet7 = GUICtrlCreateTabItem("Logged on")
$Group15 = GUICtrlCreateGroup("", 18, 136, 633, 193)
$Label269 =GUICtrlCreateLabel("\\Computer or UserName :", 35, 150, 120, 17)
$InputcomputerorUser = GUICtrlCreateInput("\\", 34, 168, 273, 21)
GUICtrlSetOnEvent(-1, "LoggedOnChange")
$CheckboxOnlyLocal = GUICtrlCreateCheckbox("Show Only Local Logons", 34, 200, 145, 17)
GUICtrlSetOnEvent(-1, "LoggedOnChange")
$CheckboxNoLogonTimes = GUICtrlCreateCheckbox("Don't Show Logon times", 34, 224, 137, 17)
GUICtrlSetOnEvent(-1, "LoggedOnChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region loglist
$TabSheet8 = GUICtrlCreateTabItem("Log List *")
$Group14 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$Label28 = GUICtrlCreateLabel("", 56, 160, 4, 4)
$Group16 = GUICtrlCreateGroup("Filter", 416, 144, 225, 177)
$Group17 = GUICtrlCreateGroup("", 472, 144, 169, 49)
$RadioBefore = GUICtrlCreateRadio("Before", 480, 152, 57, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Radioafter = GUICtrlCreateRadio("After", 552, 152, 49, 17)
$DateFilter = GUICtrlCreateDate("", 480, 168, 129, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group18 = GUICtrlCreateGroup("", 472, 192, 169, 49)
$RadioLastNum = GUICtrlCreateRadio("Last Num", 480, 200, 73, 17)
$RadioLastDays = GUICtrlCreateRadio("Last Days", 480, 216, 73, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$InputLogLast = GUICtrlCreateInput("1", 552, 208, 41, 21)
GUICtrlCreateUpdown($InputLogLast,-1)
GUICtrlSetLimit(-1,999,0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label30 = GUICtrlCreateLabel("ID's :", 440, 248, 28, 17)
$Label31 = GUICtrlCreateLabel("Type :", 432, 272, 34, 17)
$Label32 = GUICtrlCreateLabel("Source :", 424, 296, 44, 17)
$InputLogID = GUICtrlCreateInput("", 472, 248, 161, 21)
$InputLogType = GUICtrlCreateInput("", 472, 272, 161, 21)
$InputLogSource = GUICtrlCreateInput("", 472, 296, 161, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label33 = GUICtrlCreateLabel("Event Log :", 24, 152, 59, 17)
$Label34 = GUICtrlCreateLabel("", 240, 184, 4, 4)
$Label35 = GUICtrlCreateLabel("Sort :", 256, 152, 29, 17)
$Label36 = GUICtrlCreateLabel("Delimiter :", 24, 256, 50, 17)
$Label37 = GUICtrlCreateLabel("Log File :", 24, 296, 47, 17)
$InputLogfile = GUICtrlCreateInput("", 72, 296, 313, 21)
$ButtonLogFile = GUICtrlCreateButton("...", 392, 296, 17, 21, 0)
GUICtrlSetOnEvent(-1, "A")
$ComboEventlog = GUICtrlCreateCombo("", 88, 152, 121, 25)
GUICtrlSetData(-1,"Application|System|Security","") 
$ComboSort = GUICtrlCreateCombo("", 296, 152, 97, 25)
GUICtrlSetData(-1,"Ascending|Descending","") 
$InputLogDelimiter = GUICtrlCreateInput("|", 88, 256, 33, 21)
$CheckboxOneRecordPerLine = GUICtrlCreateCheckbox("One Record per line", 88, 184, 161, 17)
$CheckboxExtendedData = GUICtrlCreateCheckbox("Extended Data", 88, 208, 97, 17)
$CheckboxClearEventLog = GUICtrlCreateCheckbox("Clear Event Log", 88, 232, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region Passwd
$TabSheet9 = GUICtrlCreateTabItem("Passwd")
$Group8 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$Label16 = GUICtrlCreateLabel("User Name :", 32, 168, 63, 17, $SS_RIGHT)
$Label17 = GUICtrlCreateLabel("New Password :", 24, 192, 81, 17, $SS_RIGHT)
$InputUserName = GUICtrlCreateInput("", 112, 168, 217, 21)
GUICtrlSetOnEvent(-1, "PasswdChange")
$InputNewPassword = GUICtrlCreateInput("", 112, 192, 217, 21)
GUICtrlSetOnEvent(-1, "PasswdChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region Service
$TabSheet10 = GUICtrlCreateTabItem("Service")
$Group4 = GUICtrlCreateGroup("", 16, 136, 385, 193)
$Label9 = GUICtrlCreateLabel("Service Name :", 21, 159, 77, 17, $SS_RIGHT)
$Label10 = GUICtrlCreateLabel("Command :", 32, 192, 57, 17, $SS_RIGHT)
$Label11 = GUICtrlCreateLabel("Startup Type :", 24, 224, 71, 17, $SS_RIGHT)
$InputServiceName = GUICtrlCreateInput("", 104, 160, 289, 21)
GUICtrlSetOnEvent(-1, "ServiceChange")
$ComboCommand = GUICtrlCreateCombo("", 104, 192, 120, 25)
GUICtrlSetData(-1,"Stop|Start|Restart|Pause|Resume|Find|Show Status|Show Config|Show Depends|Show Security|Set Startup Type","") 
GUICtrlSetOnEvent(-1, "ServiceChange")
$ComboStartupType = GUICtrlCreateCombo("", 104, 224, 120, 25)
GUICtrlSetData(-1,"Automatic|Manual|Disabled","") 
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ServiceChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group5 = GUICtrlCreateGroup("Status", 408, 136, 241, 193)
$Label12 = GUICtrlCreateLabel("Group :", 416, 160, 39, 17, $SS_RIGHT)
$Label13 = GUICtrlCreateLabel("Type :", 424, 192, 34, 17, $SS_RIGHT)
$Label14 = GUICtrlCreateLabel("State :", 424, 224, 35, 17, $SS_RIGHT)
$InputGroup = GUICtrlCreateInput("", 464, 160, 177, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ServiceChange")
$ComboType = GUICtrlCreateCombo("", 464, 192, 75, 25)
GUICtrlSetData(-1,"Driver|Service|All","")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ServiceChange")
$ComboState = GUICtrlCreateCombo("", 464, 224, 75, 25)
GUICtrlSetData(-1,"Active|Inactive|All","") 
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ServiceChange")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion
#region Shutdown
$TabSheet11 = GUICtrlCreateTabItem("Shutdown")
$Group6 = GUICtrlCreateGroup("", 16, 136, 633, 193)
$Message = GUICtrlCreateInput("", 24, 280, 609, 21)
GUICtrlSetOnEvent(-1, "ShutDownChange")
$Label15 = GUICtrlCreateLabel("Action :", 56, 168, 40, 17)
$ComboAction = GUICtrlCreateCombo("", 96, 168, 100, 25)
GUICtrlSetData(-1,"Abort|Shutdown|Reboot|Hibernate|Power off|Logoff|Lock","") 
GUICtrlSetOnEvent(-1, "ShutDownChange")
$CheckboxforcedShutdown = GUICtrlCreateCheckbox("Forced Shutdown", 96, 200, 113, 17)
GUICtrlSetOnEvent(-1, "ShutDownChange")
$CheckboxAllowAbort = GUICtrlCreateCheckbox("Allow Abort", 96, 232, 129, 17)
GUICtrlSetOnEvent(-1, "ShutDownChange")
$Group7 = GUICtrlCreateGroup("Countdown", 264, 160, 209, 89)
$RadioSeconds = GUICtrlCreateRadio("Seconds", 272, 184, 73, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "ShutDownChange")
$RadioTime = GUICtrlCreateRadio("Time", 272, 216, 49, 17)
GUICtrlSetOnEvent(-1, "ShutDownChange")
$InputSeconds = GUICtrlCreateInput("0", 344, 184, 65, 21)
GUICtrlSetOnEvent(-1, "ShutDownChange")
GUICtrlCreateUpdown($InputSeconds,-1)
GUICtrlSetOnEvent(-1, "ShutDownChange")
GUICtrlSetLimit(-1,500,0)
$InputTime = GUICtrlCreateInput("", 344, 216, 81, 21)
GUICtrlSetOnEvent(-1, "ShutDownChange")

#endregion
#region Header
;~ Header
GUICtrlCreateTabItem("")
$PSComputer = GUICtrlCreateInput("", 512, 32, 137, 21)
GUICtrlSetOnEvent(-1, "HeaderChange")
$PSUser = GUICtrlCreateInput("", 512, 56, 137, 21)
GUICtrlSetOnEvent(-1, "HeaderChange")
$PSPassword = GUICtrlCreateInput("", 512, 80, 137, 21)
GUICtrlSetOnEvent(-1, "HeaderChange")
$PSComputerList = GUICtrlCreateInput("", 8, 56, 441, 21)
GUICtrlSetOnEvent(-1, "HeaderChange")
GUICtrlSetState(-1, $GUI_DISABLE)
$PSUseList = GUICtrlCreateCheckbox("Use Computer List", 96, 88, 113, 17)
GUICtrlSetOnEvent(-1, "HeaderChange")
$BTNBrowse = GUICtrlCreateButton("Browse", 8, 80, 73, 25, 0)
GUICtrlSetOnEvent(-1, "LoadFile")
GUICtrlSetState(-1, $GUI_DISABLE)
$PSCommandLine = GUICtrlCreateInput("", 56, 8, 593, 21)
$PSGo = GUICtrlCreateButton("Go", 8, 8, 41, 21, 0)
GUICtrlSetOnEvent(-1, "ExecuteCmd")
$BTNDirty = GUICtrlCreateLabel("Click Here to refresh Command Line!", 56, 33, 255, 21)
GUICtrlSetOnEvent(-1, "HeaderChange")
$Label2 = GUICtrlCreateLabel("Computer :", 456, 32, 55, 17)
$Label3 = GUICtrlCreateLabel("User :", 480, 56, 32, 17)
$Label4 = GUICtrlCreateLabel("Password :", 456, 80, 56, 17)
$InputCommandResult = GUICtrlCreateEdit("", 8, 344, 649, 140,$ES_AUTOVSCROLL+$WS_VSCROLL)
#endregion
GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

InitialiseMe()

While 1
	Sleep(100)
WEnd

Func A()
;~  a placeholder function
MsgBox (0,"Error", "You should never get here")
EndFunc


Func InitialiseMe()
	Tab1Click()
EndFunc

Func HeaderChange()
		
	$readval = GUICtrlRead($PSComputer)
	If StringLen($readval) > 0 Then
		$start = "\\" & $readval
	EndIf
	
	If GUICtrlRead($PSUseList) = 1 Then		; Checked
		GUICtrlSetState($BTNBrowse, $GUI_ENABLE)
		GUICtrlSetState($PSComputerList, $GUI_ENABLE)
		$readval = GUICtrlRead($PSComputerList); override the computer name with the file
		$start = "@""" &  $readval & """ "
	Else
		GUICtrlSetState($BTNBrowse, $GUI_DISABLE)
		GUICtrlSetState($PSComputerList, $GUI_DISABLE)
	EndIf
	
	$readval = GUICtrlRead($PSUser)
	If StringLen($readval) > 0 Then
		$start = $start & " -u " & $readval
	EndIf
	
	$readval = GUICtrlRead($PSPassword)
	If StringLen($readval) > 0 Then
		$start = $start & " -p " & $readval
	EndIf
	If StringRight($start,1) <> " " Then
		$start = $start & " "
	EndIf
;~ 	If GUICtrlRead($Tab1) = 6 Then
;~ 		GUICtrlSetData ($PSCommandLine,$prog & $progparms)
;~ 	Else
;~ 		GUICtrlSetData ($PSCommandLine,$prog & $start & $progparms)
;~ 	EndIf

	Tab1Click()
	
	GUICtrlSetState($BTNDirty , $GUI_ENABLE)	; Just something to solve the event issues

EndFunc

Func LoadFile()
	GUICtrlSetData($PSComputerList,FileOpenDialog("Browse for computer list", @ScriptDir, "Text files (*.txt)", 1))
	HeaderChange()
EndFunc

Func FindProg()
	GUICtrlSetData($InputProgram,FileOpenDialog("Browse for Program", @ScriptDir, "Program files (*.*)", 1))
	ExecChange()
EndFunc

Func Tab1Click()
	$currtab = GUICtrlread ($Tab1) 
	Select 
		Case $currtab = 0
			ExecChange()
			
		Case $currtab = 1
			FileChange()
			
		Case $currtab = 2
			GetSidChange()
			
		Case $currtab = 3
			InfoChange()
			
		Case $currtab = 4
			KillChange()
			
		Case $currtab = 5
			ListChange()
			
		Case $currtab = 6
			LoggedOnChange()
			
		Case $currtab = 7
			LogListChange()
			
		Case $currtab = 8
			PasswdChange()
			
		Case $currtab = 9
			ServiceChange()
			
		Case $currtab = 10
			ShutDownChange()
			
		EndSelect
		
		GUICtrlSetState($BTNDirty , $GUI_ENABLE)	; Just something to solve the event issues
	
EndFunc

Func ExecChange() 
	
	$prog = "psexec.exe "
	$progparms = ""
	$runcmd = ""
	$runargs = ""
	
	GUICtrlSetState($PSUseList, $GUI_ENABLE) ; CAN run this on a list of computers
	If StringLen(GUICtrlRead($InputProgram)) > 0 then
		$runcmd = """" & GUICtrlRead($InputProgram) & """ "
	EndIf

	If StringLen(GUICtrlRead($InputArgs)) > 0 then 	$runargs = """" & GUICtrlRead($InputArgs) & """ "
	If StringLen(GUICtrlRead($InputWorking)) > 0 Then $progparms = $progparms & "-w """ & GUICtrlRead($InputWorking) & """ "
	If GUICtrlRead($CheckboxDontWait) = 1 Then $progparms = $progparms & "-d "
	If StringLen(GUICtrlRead($ComboPriority)) > 0 Then $progparms = $progparms & GUICtrlRead($ComboPriority) & " "
	If StringLen(GUICtrlRead($InputProcessors)) > 0 Then $progparms = $progparms & GUICtrlRead($InputProcessors) & " "
	
	If GUICtrlRead($CheckboxRunAsSystem) = 1 Then
		GUICtrlSetState($CheckboxLoadAccountProfile, $GUI_DISABLE)
		GUICtrlSetState($CheckboxLoadAccountProfile,$GUI_UNCHECKED)
		GUICtrlSetState($InputAccountProfile, $GUI_DISABLE)
		$progparms = $progparms & "-s "
	Else
		GUICtrlSetState($CheckboxLoadAccountProfile, $GUI_ENABLE)
		GUICtrlSetState($InputAccountProfile, $GUI_ENABLE)
	EndIf
	
	If GUICtrlRead($CheckboxLoadAccountProfile) = 1 Then 
		$progparms = $progparms & "-e "
		$progparms = $progparms & GUICtrlRead($InputAccountProfile) & " "
	EndIf
	
	If GUICtrlRead($CheckboxInteractWithDeskTop) = 1 Then $progparms = $progparms & "-i "
	
	If GUICtrlRead($CheckboxCopyProgram) = 1 	Then
		$tmpp = ""
		$progparms = $progparms & "-c "
		GUICtrlSetState($CheckboxOverWrite,$GUI_ENABLE) 
		GUICtrlSetState($CheckboxOnlyIfNewer,$GUI_ENABLE) 
		if GUICtrlRead($CheckboxOverWrite) = 1 Then $tmpp = "-f "
		if GUICtrlRead($CheckboxOnlyIfNewer) = 1 Then $tmpp = "-v "
		$progparms = $progparms & $tmpp
	EndIf
		
	GUICtrlSetData ($PSCommandLine, $prog & $start & $progparms & $runcmd & $runargs)
	
EndFunc

Func FileChange()
	$prog = "psfile.exe "
	$progparms = ""
	GUICtrlSetState($PSUseList, $GUI_DISABLE + $GUI_UNCHECKED) ; Can't run this on a list of computers
	
	$progparms = GUICtrlRead($InputPath)
	If GUICtrlRead($CheckboxCloseFiles) = 1 Then
		$progparms = $progparms & " -c"
	EndIf
	GUICtrlSetData ($PSCommandLine,$prog & $Start & $progparms)
EndFunc

Func GetSidChange()
	$prog = "psgetsid.exe "
	GUICtrlSetState($PSUseList, $GUI_ENABLE) ; CAN run this on a list of computers
	$progparms = GUICtrlRead($InputAccount)
	GUICtrlSetData ($PSCommandLine,$prog & $start & $progparms)
EndFunc

Func InfoChange() 
	$prog = "psinfo.exe "
	GUICtrlSetState($PSUseList, $GUI_ENABLE) ; CAN run this on a list of computers
	
	$progparms = ""
	If GUICtrlRead($CheckboxShowHotfixes) = 1 Then
		$progparms = $progparms & "-h "
	EndIf
	If GUICtrlRead($CheckboxShowSoftware) = 1 Then
		$progparms = $progparms & "-s "
	EndIf
	If GUICtrlRead($CheckboxShowDiskVolInfo) = 1 Then
		$progparms = $progparms & "-d "
	EndIf
	If GUICtrlRead($CheckboxDumpinCSV) = 1 Then
		$progparms = $progparms & "-c -t "
		$progparms = $progparms & GUICtrlRead($InputInfoDelimiter)
	EndIf

	GUICtrlSetData ($PSCommandLine,$prog & $start & $progparms)
EndFunc

Func KillChange()
	$prog = "pskill.exe "
	GUICtrlSetState($PSUseList, $GUI_DISABLE + $GUI_UNCHECKED) ; Can't run this on a list of computers	
	
	$progparms = ""
	
	If GUICtrlRead($RadioKill) = 1 Then
		$prog = "pskill.exe "
		If GUICtrlRead($CheckboxDecendants) = 1 Then
			$appnd = "-t "
		EndIf
	EndIf
	If GUICtrlRead($RadioSuspend) = 1 Then
		$prog = "pssuspend.exe "
	EndIf
	If GUICtrlRead($RadioResume) = 1 Then
		$prog = "pssuspend.exe "
		$appnd = "-r "
	EndIf
	$progparms = GUICtrlRead($InputProcessIDName)
	GUICtrlSetData ($PSCommandLine,$prog & $appnd & $start & $progparms)
EndFunc

Func ListChange()
	$prog = "pslist.exe "
	GUICtrlSetState($PSUseList, $GUI_DISABLE + $GUI_UNCHECKED) ; Can't run this on a list of computers	
	$progparms = ""
 

	If GUICtrlRead($CheckboxShowAllActive ) = 1 Then
		$progparms = $progparms & "-d "
	EndIf
	If GUICtrlRead($CheckboxShowMemInfo ) = 1 Then
		$progparms = $progparms & "-m "
	EndIf
	If GUICtrlRead($CheckboxShowCPU ) = 1 Then
		$progparms = $progparms & "-x "
	EndIf	
	If GUICtrlRead($CheckboxShowProcessTree) = 1 Then
		$progparms = $progparms & "-t "
	EndIf
	
	If GUICtrlRead($CheckboxUseTaskMgr ) = 1 Then
		$progparms = $progparms & "-s 1 "
	EndIf

	$appnd = GUICtrlRead($InputListProcessIDName)
	
	GUICtrlSetData ($PSCommandLine,$prog  & $progparms & $start & $appnd)
EndFunc

Func LoggedOnChange() 
	$prog = "psloggedon.exe "
	GUICtrlSetState($PSUseList, $GUI_DISABLE + $GUI_UNCHECKED) ; Can't run this on a list of computers	
	
	$progparms = GUICtrlRead($InputcomputerorUser)
	
	If GUICtrlRead($CheckboxOnlyLocal) = 1 Then
		$progparms = " -l " & $progparms
	EndIf
	If GUICtrlRead($CheckboxNoLogonTimes) = 1 Then
		$progparms = " -x " & $progparms
	EndIf

	GUICtrlSetData ($PSCommandLine,$prog & $progparms)
EndFunc

Func LogListChange()  
	$prog = "psloglist.exe "
	GUICtrlSetState($PSUseList, $GUI_ENABLE) ; CAN run this on a list of computers
	
	GUICtrlSetData ($PSCommandLine,$prog & $start & $progparms)
EndFunc

Func PasswdChange()
	$prog = "pspasswd.exe "
	GUICtrlSetState($PSUseList, $GUI_ENABLE) ; CAN run this on a list of computers
	$progparms = ""
	$progparms = $progparms & GUICtrlRead($InputUserName) & " " 
	$progparms = $progparms & GUICtrlRead($InputNewPassword) & " " 
	GUICtrlSetData ($PSCommandLine,$prog & $start & $progparms)
	
EndFunc

Func ServiceChange() 
	$prog = "psservice.exe "
	GUICtrlSetState($PSUseList, $GUI_DISABLE + $GUI_UNCHECKED) ; Can't run this on a list of computers
;~ 	"Stop|Start|Restart|Pause|Resume|Find|Show Status|Show Config|Show Depends|Show Security|Set Startup Type"
	$cmd = ""
	$progparms = ""
	
	$sda = GUICtrlRead($ComboCommand)
	$svc = GUICtrlRead($InputServiceName)
	If $sda = "Show Status" Then
		GUICtrlSetState($InputGroup,$GUI_ENABLE)
		GUICtrlSetState($ComboType,$GUI_ENABLE)
		GUICtrlSetState($ComboState,$GUI_ENABLE)
		$cmd = "query "
		$progparms = $svc & " "
		If StringLen(GUICtrlRead($InputGroup)) > 0 Then $progparms = $progparms & " -g " & StringLower(GUICtrlRead($InputGroup))
		If StringLen(GUICtrlRead($ComboType)) > 0 Then $progparms = $progparms & " -t " & StringLower(GUICtrlRead($ComboType))
		If StringLen(GUICtrlRead($ComboState)) > 0 Then $progparms = $progparms & " -s " & StringLower(GUICtrlRead($ComboState))		
	Else
		GUICtrlSetState($InputGroup,$GUI_DISABLE)
		GUICtrlSetState($ComboType,$GUI_DISABLE)
		GUICtrlSetState($ComboState,$GUI_DISABLE)
	EndIf
	
	If $sda = "Set Startup Type" Then
		GUICtrlSetState($ComboStartupType,$GUI_ENABLE)
		$cmd = "setconfig "
		$progparms = GUICtrlRead($ComboStartupType)
		If $progparms = "Automatic" Then $progparms = "auto "
		If $progparms = "Manual" Then $progparms = "demand "
		If $progparms = "Disabled" Then $progparms = "disabled "
		$progparms = $svc & " " & $progparms
	Else
		GUICtrlSetState($ComboStartupType,$GUI_DISABLE)
	EndIf
	
	If $sda = "Stop" Then
		$cmd = "stop "
		$progparms = $svc
	EndIf
	
	If $sda = "Start" Then
		$cmd = "start "
		$progparms = $svc
	EndIf
		
	If $sda = "Restart" Then
		$cmd = "restart "
		$progparms = $svc
	EndIf
	
	If $sda = "Resume" Then
		$cmd = "cont "
		$progparms = $svc
	EndIf
	
	If $sda = "Find" Then
		$cmd = "find "
		$progparms = $svc
	EndIf
	
	If $sda = "Show Config" Then
		$cmd = "config "
	EndIf	

	If $sda = "Show Depends" Then
		$cmd = "depend "
		$progparms = $svc
	EndIf	
	
	If $sda = "Show Security" Then
		$cmd = "security "
		$progparms = $svc
	EndIf	

	GUICtrlSetData ($PSCommandLine,$prog & $start & $cmd & $progparms)
EndFunc

Func ShutDownChange()  
	
	$prog = "psshutdown.exe "
	GUICtrlSetState($PSUseList, $GUI_ENABLE) ; Can run this on a list of computers
	
	$progparms = ""
	
	$sda = GUICtrlRead($ComboAction)
	Select
;~ 		"Abort|Shutdown|Reboot|Hibernate|Power off|Logoff|Lock"
		case $sda = "Abort"
			$progparms = "-a "
		case $sda = "Shutdown"
			$progparms = "-s "
		case $sda = "Reboot"
			$progparms = "-r "
		case $sda = "Hibernate"
			$progparms = "-h "
		case $sda = "Power off"
			$progparms = "-k "
		case $sda = "Logoff"
			$progparms = "-o "
		case $sda = "Lock"
			$progparms = "-l "
		EndSelect
		
		If GUICtrlRead($CheckboxforcedShutdown) = 1 Then
			$progparms = $progparms & "-f "
		EndIf
		If GUICtrlRead($CheckboxAllowAbort) = 1 Then
			$progparms = $progparms & "-c "
		EndIf
		
		$appnd = ""
		If GUICtrlRead($RadioSeconds) = 1 Then
			If GUICtrlRead($InputSeconds) > 0 Then
				$appnd = $appnd & "-t " & GUICtrlRead($InputSeconds) & " "
			EndIf
		EndIf
		If GUICtrlRead($RadioTime) = 1 Then
			If StringLen(GUICtrlRead($InputTime)) = 5 Then
				$appnd = $appnd & "-t " & GUICtrlRead($InputTime) & " "
			EndIf
		EndIf
		
		If StringLen(GUICtrlRead($Message)) > 0 Then
			$appnd = $appnd & " -m """ & GUICtrlRead($Message) & """ "
		EndIf
		
		If ($sda = "Abort" Or $sda = "Lock" Or $sda = "Logoff")Then
			$appnd = ""
		EndIf

	GUICtrlSetData ($PSCommandLine,$prog & $progparms & $appnd & $start)
EndFunc

Func ExecuteCmd()
	
	GUICtrlSetData($InputCommandResult,"")	; clear the command reult
	$foo = Run(@ComSpec & " /c " & GUICtrlRead($PSCommandLine), @ScriptDir, @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		
	While 1									; send STDERR to the result area
		$line = StderrRead($foo)
		If @error Then ExitLoop
		GUICtrlSetData($InputCommandResult,GUICtrlRead($InputCommandResult) & $line & @CRLF)
	Wend
	
	GUICtrlSetData($InputCommandResult,GUICtrlRead($InputCommandResult) & @CRLF)
	
	While 1									; send STDOUT to the result area
		$line = StdoutRead($foo)
		If @error Then ExitLoop
		GUICtrlSetData($InputCommandResult,GUICtrlRead($InputCommandResult) & $line & @CRLF)
	Wend

EndFunc	

Func onExit()
	GUIDelete()
	Exit
EndFunc