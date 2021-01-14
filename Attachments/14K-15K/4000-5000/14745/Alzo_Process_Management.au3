#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <Process.au3>
#include <_GetExtProperty.au3>
#include <Constants.au3>
#include <Date.au3>
#include <ExcelCOM.au3>


#region Options
Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode", 4)
Opt("WinDetectHiddenText", 1)
Opt("RunErrorsFatal", 0)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
#endregion

#region Global Variables
Global $Delay_Update = 10000, $EN_UPDATE = 0x0400, $WM_COMMAND = 0x0111, $Timer_Refresh, $WM_NOTIFY = 0x004E, $Timer_Active = 1
Global $liOldIdleTime = 0, $liOldSystemTime = 0, $Array_Process_Old, $Array_Windows_Old, $Timer_ArrayClean = TimerInit(), $Temp
Dim $Array_Process_Priority[6] = ["Idle/Low", "Below Normal", "Normal", "Above Normal", "High", "Realtime"]
Dim $Array_Export[3] = ["APM Process List ", "APM Window List ", "APM Lists "]
Dim $Array_Alphabet[26] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", _
	"r", "s", "t", "u", "v", "w", "x", "y", "z"]
#endregion

;~ AdlibEnable("_ArrayClean", 45000)

#region Windows
$Window_Main = GUICreate("Alzo Process Management", 1000, 700, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX))
#endregion

#region Menus
$Menu_File = GUICtrlCreateMenu("&File")
$Menu_File_Export = GUICtrlCreateMenu("Export List To File", $Menu_File)
$Menu_File_Export_Process = GUICtrlCreateMenuItem("Export Process List To File", $Menu_File_Export)
GUICtrlSetOnEvent(-1, "_EventHandler")
$Menu_File_Export_Windows = GUICtrlCreateMenuItem("Export Windows List To File", $Menu_File_Export)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUICtrlCreateMenuItem("", $Menu_File_Export)
$Menu_File_Export_All = GUICtrlCreateMenuItem("Export Both Lists To File", $Menu_File_Export)
GUICtrlSetOnEvent(-1, "_EventHandler")
#endregion

#region Static Labels
GUICtrlCreateLabel("Running Processes:", 200, 3, -1, 17)
GUICtrlCreateLabel("Process Windows:", 700, 3, -1, 17)
GUICtrlCreateLabel("Refresh Delay (minimum 5 sec.):", 465, 365- 100, 90, 40)
GUICtrlCreateLabel("second(s)", 500, 403- 100)
GUICtrlCreateGroup("Refresh", 460, 350- 100, 100, 120)
#endregion

#region ListViews
$List_Process = GUICtrlCreateListView("Process Name|Process ID|Process Priority|Process Path", 8, 20, 450, 630, _
		BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
GUICtrlSetOnEvent(-1, "_EventHandler")
_GUICtrlListViewSetColumnWidth($List_Process, 1, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListViewSetColumnWidth($List_Process, 2, $LVSCW_AUTOSIZE_USEHEADER)
$List_Windows = GUICtrlCreateListView("Window Title|Window Status|Parent Process|Process ID|Window Handle", 562, 20, 435, 507, _
		BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
GUICtrlSetOnEvent(-1, "_EventHandler")
_GUICtrlListViewSetColumnWidth($List_Windows, 0, 182)
_GUICtrlListViewSetColumnWidth($List_Windows, 3, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListViewSetColumnWidth($List_Windows, 4, $LVSCW_AUTOSIZE_USEHEADER)
#endregion

#region Edits/Inputs
$Edit_Info = GUICtrlCreateEdit("Alzo Process Management" & @CRLF & "Brought to you by Marvin Ostermann" _
	& @CRLF & @CRLF & "Rotterdam, The Netherlands", 562, 530, 435, 120)
$Input_Refresh = GUICtrlCreateInput("10", 462, 400- 100, 35, 20, 0)
GUICtrlCreateUpdown($Input_Refresh)
GUICtrlSetLimit(-1, 99, 4)
#endregion

#region Checkboxes
$Checkbox_Update = GUICtrlCreateCheckbox("Auto Refresh On", 463, 430- 100, 93)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "_EventHandler")
#endregion

#region Buttons
$Button_Refresh = GUICtrlCreateButton("Refresh", 462, 20, 95, -1)
GUICtrlSetOnEvent($Button_Refresh, "_EventHandler")
$Button_Processes = GUICtrlCreateButton("Processes", 462, 90, 95, 25, -1)
GUICtrlSetOnEvent($Button_Processes, "_EventHandler")
$Button_Windows = GUICtrlCreateButton("Windows", 462, 160, 95, 25, -1)
GUICtrlSetOnEvent($Button_Windows, "_EventHandler")
#endregion

#region Context Menus
$CTMenu_Refresh = GUICtrlCreateContextMenu($Button_Refresh)
$CTMenu_Refresh_Process = GUICtrlCreateMenuItem("Refresh Processes", $CTMenu_Refresh)
GUICtrlSetOnEvent(-1, "_EventHandler")
$CTMenu_Refresh_Windows = GUICtrlCreateMenuItem("Refresh Windows", $CTMenu_Refresh)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUICtrlCreateMenuItem("", $CTMenu_Refresh)
$CTMenu_Refresh_All = GUICtrlCreateMenuItem("Refresh All", $CTMenu_Refresh)
GUICtrlSetOnEvent(-1, "_EventHandler")

$CTMenu_Processes = GUICtrlCreateContextMenu($Button_Processes)
$CTMenu_Processes_Close = GUICtrlCreateMenuItem("End Selected Process", $CTMenu_Processes)
$CTMenu_Processes_Priority = GUICtrlCreateMenu("Set Process Priority", $CTMenu_Processes)
$CTMenu_Processes_Priority_Low = GUICtrlCreateMenuItem("Low/Idle", $CTMenu_Processes_Priority)
$CTMenu_Processes_Priority_Below = GUICtrlCreateMenuItem("Below Normal", $CTMenu_Processes_Priority)
$CTMenu_Processes_Priority_Norm = GUICtrlCreateMenuItem("Normal", $CTMenu_Processes_Priority)
$CTMenu_Processes_Priority_Above = GUICtrlCreateMenuItem("Above Normal", $CTMenu_Processes_Priority)
$CTMenu_Processes_Priority_High = GUICtrlCreateMenuItem("High", $CTMenu_Processes_Priority)
$CTMenu_Processes_Priority_Real = GUICtrlCreateMenuItem("Realtime (NOT Recommended)", $CTMenu_Processes_Priority)
$CTMenu_Processes_Status = GUICtrlCreateMenu("Process Status", $CTMenu_Processes)
$CTMenu_Processes_Status_Suspend = GUICtrlCreateMenuItem("Suspend Process", $CTMenu_Processes_Status)
$CTMenu_Processes_Status_Resume = GUICtrlCreateMenuItem("Resume Process", $CTMenu_Processes_Status)
$CTMenu_Processes_Free = GUICtrlCreateMenuItem("Free This Process' Memory", $CTMenu_Processes)
GUICtrlCreateMenuItem("", $CTMenu_Processes)
$CTMenu_Processes_OpenFolder = GUICtrlCreateMenuItem("Open Application Folder", $CTMenu_Processes)
$CTMenu_Processes_Delete = GUICtrlCreateMenuItem("Delete Process Executable", $CTMenu_Processes)
GUICtrlCreateMenuItem("", $CTMenu_Processes)
$CTMenu_Processes_Google = GUICtrlCreateMenuItem("Google Selected Process", $CTMenu_Processes)
For $i = $CTMenu_Processes_Close To $CTMenu_Processes_Google
	GUICtrlSetOnEvent($i, "_EventHandler")
Next

$CTMenu_Windows = GUICtrlCreateContextMenu($Button_Windows)
$CTMenu_Windows_Close = GUICtrlCreateMenuItem("Close Window", $CTMenu_Windows)
$CTMenu_Windows_Terminate = GUICtrlCreateMenuItem("Force Close Window", $CTMenu_Windows)
GUICtrlCreateMenuItem("", $CTMenu_Windows)
$CTMenu_Windows_Status = GUICtrlCreateMenu("Window Status", $CTMenu_Windows)
$CTMenu_Windows_Status_Visibility = GUICtrlCreateMenu("Visibility", $CTMenu_Windows_Status)
$CTMenu_Windows_Status_Visibility_Show = GUICtrlCreateMenuItem("Show Window", $CTMenu_Windows_Status_Visibility)
$CTMenu_Windows_Status_Visibility_Hide = GUICtrlCreateMenuItem("Hide Window", $CTMenu_Windows_Status_Visibility)
$CTMenu_Windows_Status_Enable = GUICtrlCreateMenu("Enable", $CTMenu_Windows_Status)
$CTMenu_Windows_Status_Enable_Enable = GUICtrlCreateMenuItem("Enable Window", $CTMenu_Windows_Status_Enable)
$CTMenu_Windows_Status_Enable_Disable = GUICtrlCreateMenuItem("Disable Window", $CTMenu_Windows_Status_Enable)
$CTMenu_Windows_Status_Size = GUICtrlCreateMenu("Size", $CTMenu_Windows_Status)
$CTMenu_Windows_Status_Size_Min = GUICtrlCreateMenuItem("Minimize Window", $CTMenu_Windows_Status_Size)
$CTMenu_Windows_Status_Size_Max = GUICtrlCreateMenuItem("Maximize Window", $CTMenu_Windows_Status_Size)
$CTMenu_Windows_Status_Top = GUICtrlCreateMenu("Window On Top", $CTMenu_Windows_Status)
$CTMenu_Windows_Status_Top_On = GUICtrlCreateMenuItem("On", $CTMenu_Windows_Status_Top)
$CTMenu_Windows_Status_Top_Off = GUICtrlCreateMenuItem("Off", $CTMenu_Windows_Status_Top)
Dim $Array_Windows_Status[$CTMenu_Windows_Status_Size_Max + 1]
$Array_Windows_Status[$CTMenu_Windows_Status_Visibility_Show] = @SW_SHOW
$Array_Windows_Status[$CTMenu_Windows_Status_Visibility_Hide] = @SW_HIDE
$Array_Windows_Status[$CTMenu_Windows_Status_Enable_Enable] = @SW_ENABLE
$Array_Windows_Status[$CTMenu_Windows_Status_Enable_Disable] = @SW_DISABLE
$Array_Windows_Status[$CTMenu_Windows_Status_Size_Min] = @SW_MINIMIZE
$Array_Windows_Status[$CTMenu_Windows_Status_Size_Max] = @SW_MAXIMIZE
$CTMenu_Windows_Activate = GUICtrlCreateMenuItem("Activate Window", $CTMenu_Windows_Status)
$CTMenu_Windows_Miscellaneous = GUICtrlCreateMenu("Miscellaneous", $CTMenu_Windows)
$CTMenu_Windows_Miscellaneous_Title = GUICtrlCreateMenuItem("Change Window Title", $CTMenu_Windows_Miscellaneous)
$CTMenu_Windows_Miscellaneous_Trans = GUICtrlCreateMenuItem("Set Window Transparency", $CTMenu_Windows_Miscellaneous)
For $i = $CTMenu_Windows_Close To $CTMenu_Windows_Miscellaneous_Trans
	GUICtrlSetOnEvent($i, "_EventHandler")
Next
#endregion

#region StatusBar
Dim $MemStats = MemGetStats(), $Array_StatusBar_Width[4] = [150, 280, 855, -1], $Array_StatusBar_Text[4] = _
		["0 Processes, 0 Windows", "Last Update At " & @HOUR & ":" & @MIN & ":" & @SEC, StringFormat("CPU Usage: %s%%, Total RAM: %s MB," _
		 & " Available RAM: %s MB, Memory Load: %s%%", Round(CurrentCPU()), Round($MemStats[1] / 1024), Round($MemStats[2] / 1024), _
		$MemStats[0]), "Alzo Process Management ©"]
$StatusBar = _GUICtrlStatusBarCreate($Window_Main, $Array_StatusBar_Width, $Array_StatusBar_Text)
#endregion

#region GUI Events
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit", $Window_Main)
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "_Resized", $Window_Main)
GUISetOnEvent($GUI_EVENT_RESTORE, "_Resized", $Window_Main)
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_Minimized")
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "_Tray_DoubleClick")
#endregion

#region GUIRegisterMsg
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
#endregion

#region OnStartup
GUISetState(@SW_SHOW, $Window_Main)
GUISetState(@SW_MAXIMIZE, $Window_Main)
_GUICtrlStatusBarResize($StatusBar)
_Process_Init()
_Window_Init()
#endregion

While 1
	If $Timer_Active And TimerDiff($Timer_Refresh) > $Delay_Update Then
		$Timer_Refresh = TimerInit()
		_Process_Enum(0)
		_Windows_Enum(0)
	EndIf
	If TimerDiff($Timer_ArrayClean) > 45000 Then
		_ArrayClean()
		$Timer_ArrayClean = TimerInit()
	EndIf
	_GUICtrlStatusBarSetText($StatusBar, StringFormat("CPU Usage: %s%%, Total RAM: %s MB, Available RAM: %s MB, Memory Load: %s%%", _
			Round(CurrentCPU()), Round($MemStats[1] / 1024), Round($MemStats[2] / 1024), $MemStats[0]), 2)
	Sleep(750)
WEnd

Func _Process_Init($Timer_Reset = 1)
	Local $_Priority, $_Path
	$_Array = ProcessList()
	Dim $Array_Process_Old[$_Array[0][0] + 1][3]
	$Array_Process_Old[0][0] = $_Array[0][0]
	For $i = 1 To UBound($_Array, 1) - 1
		If $_Array[$i][0] = "[System Process]" Then $_Array[$i][0] = "System Idle Process"
		$_Priority = _ProcessGetPriority($_Array[$i][1])
		$Array_Process_Old[$i][2] = $_Priority
		_PriorConvert($_Priority)
		$_Path = StringReplace(StringReplace(_GetProcessPath($_Array[$i][1]), "\??\", ""), "\SystemRoot", @WindowsDir)
		If Not StringInStr($_Path, "\") Then $_Path = "Unknown"
		$Array_Process_Old[$i][1] = GUICtrlCreateListViewItem($_Array[$i][0] & "|" & $_Array[$i][1] & "|" _
				 & $_Priority & "|" & $_Path, $List_Process)
		$Array_Process_Old[$i][0] = $_Array[$i][1]
		GUICtrlSetImage(-1, "shell32.dll", 2)
		GUICtrlSetImage(-1, $_Path, 0)
		GUICtrlSetOnEvent(-1, "_SelectedProcess")
	Next
	For $i = 0 To 3
		If $i <> 1 And $i <> 2 Then _GUICtrlListViewSetColumnWidth($List_Process, $i, $LVSCW_AUTOSIZE)
	Next
	_GUICtrlStatusBarSetText($StatusBar, $_Array[0][0] & " Processes, " & _GUICtrlListViewGetItemCount($List_Windows) _
			 & " Windows", 0)
	_GUICtrlStatusBarSetText($StatusBar, "Last Update At " & @HOUR & ":" & @MIN & ":" & @SEC, 1)
	If $Timer_Reset Then $Timer_Refresh = TimerInit()
EndFunc   ;==>_Process_Init

Func _Window_Init($Timer_Reset = 1)
	Local $_Status1, $_Status2, $_Path
	$Array_Windows = WinList()
	Dim $Array_Windows_Old[2][3]
	For $i = 1 To UBound($Array_Windows, 1) - 1
		If $Array_Windows[$i][0] = "" Or $Array_Windows[$i][0] = "Default IME" Or $Array_Windows[$i][0] == "M" Then ContinueLoop
		If $Array_Windows_Old[UBound($Array_Windows_Old, 1) - 1][0] <> "" Then ReDim $Array_Windows_Old[UBound($Array_Windows_Old, 1) + 1][3]
		$_Status1 = WinGetState($Array_Windows[$i][1])
		$_Status2 = _StatusConvert($_Status1)
		$_Path = _GetProcessPath(WinGetProcess($Array_Windows[$i][1]))
		$Array_Windows_Old[UBound($Array_Windows_Old, 1) - 1][1] = GUICtrlCreateListViewItem($Array_Windows[$i][0] & "|" & $_Status2 & "|" & $_Path & "|" & _
				WinGetProcess($Array_Windows[$i][1]) & "|" & $Array_Windows[$i][1], $List_Windows)
		$Array_Windows_Old[UBound($Array_Windows_Old, 1) - 1][0] = $Array_Windows[$i][1]
		$Array_Windows_Old[UBound($Array_Windows_Old, 1) - 1][2] = $_Status1
		GUICtrlSetImage(-1, "shell32.dll", 2)
		GUICtrlSetImage(-1, $_Path, 0)
		GUICtrlSetOnEvent(-1, "_SelectedWindow")
	Next
	_GUICtrlStatusBarSetText($StatusBar, _GUICtrlListViewGetItemCount($List_Process) & " Processes, " & _
			_GUICtrlListViewGetItemCount($List_Windows) & " Windows", 0)
	_GUICtrlStatusBarSetText($StatusBar, "Last Update At " & @HOUR & ":" & @MIN & ":" & @SEC, 1)
	_GUICtrlListViewSetColumnWidth($List_Windows, 2, $LVSCW_AUTOSIZE)
	If $Timer_Reset Then $Timer_Refresh = TimerInit()
EndFunc   ;==>_Window_Init

Func _Process_Enum($Timer_Reset = 1)
	Local $_Priority, $_Path, $Mod = 0
	$Array_Process = ProcessList()
	For $i = 1 To UBound($Array_Process, 1) - 1
		
		For $j = 1 To UBound($Array_Process_Old, 1) - 1
			If $Array_Process[$i][1] = $Array_Process_Old[$j][0] Then $Mod = 1
		Next
		
		If Not $Mod Then
			If $Array_Process[$i][0] = "[System Process]" Then $Array_Process[$i][0] = "System Idle Process"
			If _ProcessGetPriority($Array_Process[$i][1]) < 0 Then
				$_Priority = "Not Applicable"
			Else
				$_Priority = $Array_Process_Priority[_ProcessGetPriority($Array_Process[$i][1]) ]
			EndIf
			$_Path = StringReplace(StringReplace(_GetProcessPath($Array_Process[$i][1]), "\??\", ""), "\SystemRoot", @WindowsDir)
			If Not StringInStr($_Path, "\") Then $_Path = "Unknown"
			$Number = UBound($Array_Process_Old, 1) + 1
			ReDim $Array_Process_Old[$Number][3]
			$Array_Process_Old[$Number - 1][1] = GUICtrlCreateListViewItem($Array_Process[$i][0] & "|" & $Array_Process[$i][1] & "|" _
					 & $_Priority & "|" & $_Path, $List_Process)
			$Array_Process_Old[$Number - 1][0] = $Array_Process[$i][1]
			GUICtrlSetImage(-1, "shell32.dll", 2)
			GUICtrlSetImage(-1, $_Path, 0)
			GUICtrlSetOnEvent(-1, "_SelectedProcess")
		EndIf
		$Mod = 0
	Next
	For $i = 1 To UBound($Array_Process_Old, 1) - 1
		
		For $j = 1 To UBound($Array_Process, 1) - 1
			If $Array_Process_Old[$i][0] = $Array_Process[$j][1] Then $Mod = 1
		Next
		
		If Not $Mod Then
			GUICtrlDelete($Array_Process_Old[$i][1])
			$Array_Process_Old[$i][0] = ""
			$Array_Process_Old[$i][1] = ""
		Else
			$_Priority = _ProcessGetPriority($Array_Process_Old[$i][0])
			If $_Priority <> $Array_Process_Old[$i][2] Then
				$Array_Process_Old[$i][2] = $_Priority
				GUICtrlSetData($Array_Process_Old[$i][1], "||" & _PriorConvert($_Priority))
			EndIf
		EndIf
		$Mod = 0
	Next
	
	For $i = 0 To 3
		If $i <> 1 And $i <> 2 Then _GUICtrlListViewSetColumnWidth($List_Process, $i, $LVSCW_AUTOSIZE)
	Next
	
	_GUICtrlStatusBarSetText($StatusBar, $Array_Process[0][0] & " Processes, " & _GUICtrlListViewGetItemCount($List_Windows) _
			 & " Windows", 0)
	_GUICtrlStatusBarSetText($StatusBar, "Last Update At " & @HOUR & ":" & @MIN & ":" & @SEC, 1)
	If $Timer_Reset Then $Timer_Refresh = TimerInit()
EndFunc   ;==>_Process_Enum

Func _Windows_Enum($Timer_Reset = 1)
	Local $_Status1, $_Status2, $_Path, $Mod = 0
	$Array_Windows = WinList()
	
	For $i = 1 To UBound($Array_Windows, 1) - 1
		
		If $Array_Windows[$i][0] = "" Or $Array_Windows[$i][0] = "Default IME" Or $Array_Windows[$i][0] == "M" Then ContinueLoop
		
		For $j = 1 To UBound($Array_Windows_Old, 1) - 1
			If $Array_Windows[$i][1] = $Array_Windows_Old[$j][0] Then $Mod = 1
		Next
		
		If Not $Mod Then
			$_Status2 = ""
			$_Status1 = WinGetState($Array_Windows[$i][1])
			If BitAND($_Status1, 2) Then
				$_Status2 &= ", Visbl."
			Else
				$_Status2 &= ", Hidden"
			EndIf
			If BitAND($_Status1, 4) Then
				$_Status2 &= ", Enabld."
			Else
				$_Status2 &= ", Disabld."
			EndIf
			If BitAND($_Status1, 8) Then $_Status2 &= ", Active"
			If BitAND($_Status1, 16) Then $_Status2 &= ", Minimzd."
			If BitAND($_Status1, 32) Then $_Status2 &= ", Maximzd."
			$_Status2 = StringTrimLeft($_Status2, 2)
			$_Path = _GetProcessPath(WinGetProcess($Array_Windows[$i][1]))
			$Number = UBound($Array_Windows_Old, 1) + 1
			ReDim $Array_Windows_Old[$Number][3]
			$Array_Windows_Old[$Number - 1][0] = $Array_Windows[$i][1]
			$Array_Windows_Old[$Number - 1][1] = GUICtrlCreateListViewItem($Array_Windows[$i][0] & "|" & $_Status2 & "|" & $_Path & "|" & WinGetProcess($Array_Windows[$i][1]) _
					 & "|" & $Array_Windows[$i][1], $List_Windows)
			GUICtrlSetImage(-1, "shell32.dll", 2)
			GUICtrlSetImage(-1, $_Path, 0)
			GUICtrlSetOnEvent(-1, "_SelectedWindow")
		EndIf
		$Mod = 0
	Next
	
	For $i = 1 To UBound($Array_Windows_Old, 1) - 1
		
		For $j = 1 To UBound($Array_Windows, 1) - 1
			If $Array_Windows_Old[$i][0] = $Array_Windows[$j][1] Then $Mod = 1
		Next
		
		If Not $Mod Then
			GUICtrlDelete($Array_Windows_Old[$i][1])
			$Array_Windows_Old[$i][0] = ""
			$Array_Windows_Old[$i][1] = ""
		Else
			$Status = WinGetState($Array_Windows_Old[$i][0])
			If $Status <> $Array_Windows_Old[$i][2] Then
				$Array_Windows_Old[$i][2] = $Status
				GUICtrlSetData($Array_Windows_Old[$i][1], "|" & _StatusConvert($Status))
			EndIf
		EndIf
		$Mod = 0
	Next
	
	_GUICtrlStatusBarSetText($StatusBar, _GUICtrlListViewGetItemCount($List_Process) & " Processes, " & _
			_GUICtrlListViewGetItemCount($List_Windows) & " Windows", 0)
	_GUICtrlStatusBarSetText($StatusBar, "Last Update At " & @HOUR & ":" & @MIN & ":" & @SEC, 1)
	_GUICtrlListViewSetColumnWidth($List_Windows, 2, $LVSCW_AUTOSIZE)
	If $Timer_Reset Then $Timer_Refresh = TimerInit()
EndFunc   ;==>_Windows_Enum

Func _GetProcessPath($PID2)
	Local $Process, $Modules, $Ret
	Const $PROCESS_QUERY_INFORMATION = 0x0400
	Const $PROCESS_VM_READ = 0x0010
	$Process = DllCall("kernel32.dll", "hwnd", "OpenProcess", "int", _
			BitOR($PROCESS_QUERY_INFORMATION, $PROCESS_VM_READ), "int", 0, "int", $PID2)
	If $Process[0] = 0 Then Return SetError(1)

	$Modules = DllStructCreate("int[1024]")
	DllCall("psapi.dll", "int", "EnumProcessModules", "hwnd", $Process[0], "ptr", DllStructGetPtr($Modules), _
			"int", DllStructGetSize($Modules), "int_ptr", 0)

	$Ret = DllCall("psapi.dll", "int", "GetModuleFileNameEx", "hwnd", $Process[0], "int", DllStructGetData($Modules, 1), _
			"str", "", "int", 2048)
	$Modules = 0
	If StringLen($Ret[3]) = 0 Then Return SetError(1)
	Return $Ret[3]
EndFunc   ;==>_GetProcessPath

Func _SelectedProcess()
	Local $_Array = StringSplit(GUICtrlRead(GUICtrlRead($List_Process)), "|")
	If @error Then Return
	GUICtrlSetData($Edit_Info, StringFormat("Executable Name: %sProcess ID: %sExecutable Path: %sProcess Priority: %sExecutable " _
		& "Size: %sCompany Name: %sProduct Name: %sFile Description: %sFile Version: %sUser: %s", $_Array[1] & @CRLF, $_Array[2] & _
		@CRLF, $_Array[4] & @CRLF, $_Array[3] & @CRLF, _GetExtProperty ($_Array[4], 1) & @CRLF, FileGetVersion($_Array[4], _
		"CompanyName") & @CRLF, FileGetVersion($_Array[4], "ProductName") & @CRLF, _
		FileGetVersion($_Array[4], "FileDescription") & @CRLF, FileGetVersion($_Array[4]) & @CRLF, _GetExtProperty($_Array[4], 8)))
EndFunc   ;==>_SelectedProcess

Func _SelectedWindow()
	Local $_Array = StringSplit(GUICtrlRead(GUICtrlRead($List_Windows)), "|")
	If @error Then Return
	GUICtrlSetData($Edit_Info, StringFormat("Window Title: %sParent Process: %sProcess ID: %sStatus: %sHandle: %sWindow Text: %s", _
		$_Array[1] & @CRLF, $_Array[3] & @CRLF, $_Array[4] & @CRLF, $_Array[2] & @CRLF, $_Array[5] & @CRLF, _
		StringReplace(WinGetText($_Array[1]), @LF, @CRLF)))
EndFunc   ;==>_SelectedWindow

Func _ReduceMemory($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func _EventHandler()
	ConsoleWrite(StringFormat("Control ID: %s%s", @GUI_CtrlId, @CRLF))
	Local $Process = StringSplit(GUICtrlRead(GUICtrlRead($List_Process)), "|")
	Local $Window = StringSplit(GUICtrlRead(GUICtrlRead($List_Windows)), "|")
	Switch @GUI_CtrlId
		Case $List_Process
			Dim $A_DESCENDING[_GUICtrlListViewGetSubItemsCount($List_Process)]
			_GUICtrlListViewSort($List_Process, $A_DESCENDING, GUICtrlGetState($List_Process))
		Case $List_Windows
			Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount($List_Windows)]
			_GUICtrlListViewSort($List_Windows, $B_DESCENDING, GUICtrlGetState($List_Windows))
		Case $Button_Refresh
			ControlClick(@GUI_WinHandle, "", @GUI_CtrlId, "right")
		Case $Button_Processes
			ControlClick(@GUI_WinHandle, "", @GUI_CtrlId, "right")
		Case $Button_Windows
			ControlClick(@GUI_WinHandle, "", @GUI_CtrlId, "right")
		Case $CTMenu_Refresh_All
			_Process_Enum()
			_Windows_Enum()
		Case $CTMenu_Refresh_Process
			_Process_Enum()
		Case $CTMenu_Refresh_Windows
			_Windows_Enum()
		Case $CTMenu_Processes_Close
			_Process_Close()
		Case $CTMenu_Processes_Priority_Low To $CTMenu_Processes_Priority_Real
			_Process_Prior(@GUI_CtrlId)
		Case $CTMenu_Processes_Status_Suspend
			_ProcessNT($Process[2], True)
		Case $CTMenu_Processes_Status_Resume
			_ProcessNT($Process[2], False)
		Case $CTMenu_Processes_Free
			_Process_Free()
		Case $CTMenu_Processes_Delete
			_Process_Delete($Process[2], $Process[4])
		Case $CTMenu_Processes_OpenFolder
			_Process_FolderOpen($Process[4])
		Case $CTMenu_Windows_Status_Visibility_Show To $CTMenu_Windows_Status_Size_Max
			_Window_Status(@GUI_CtrlId)
		Case $CTMenu_Windows_Activate
			WinActivate(HWnd(StringRight(GUICtrlRead(GUICtrlRead($List_Windows)), 10)))
			_Windows_Enum()
		Case $CTMenu_Windows_Status_Top_Off
			WinSetOnTop(HWnd($Window[5]), "", 0)
		Case $CTMenu_Windows_Status_Top_On
			WinSetOnTop(HWnd($Window[5]), "", 1)
		Case $CTMenu_Windows_Close
			WinClose(HWnd($Window[5]))
			_Windows_Enum()
		Case $CTMenu_Windows_Terminate
			WinKill(HWnd($Window[5]))
			_Windows_Enum()
		Case $CTMenu_Windows_Miscellaneous_Title
			$Title = InputBox("Change Window Title", "New Title: ", $Window[1], "", 300, 120)
			If Not @error And $Title <> "" Then
				WinSetTitle(HWnd($Window[5]), "", $Title)
				_Windows_Enum()
			EndIf
		Case $CTMenu_Processes_Google
			If $Process[1] Then
				If FileExists(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe") Then
					If Not ProcessExists("firefox.exe") Then ShellExecute(@ProgramFilesDir & "\Mozilla Firefox\firefox.exe")
				EndIf
				ShellExecute("http://www.google.com/search?hl=en&q=%22" & $Process[1] & "%22&btnG=Search")
			EndIf
		Case $Checkbox_Update
			If GUICtrlRead($Checkbox_Update) = $GUI_CHECKED Then
				$Timer_Refresh = TimerInit()
				$Timer_Active = 1
				GUICtrlSetData($Checkbox_Update, "Auto Refresh On")
			Else
				$Timer_Active = 0
				GUICtrlSetData($Checkbox_Update, "Auto Refresh Off")
			EndIf
		Case $Menu_File_Export_Process To $Menu_File_Export_All
			Switch @GUI_CtrlId
				Case $Menu_File_Export_Process
					$Temp = $Array_Export[0]
					$Number = 1
				Case $Menu_File_Export_Windows
					$Temp = $Array_Export[1]
					$Number = 2
				Case $Menu_File_Export_All
					$Temp = $Array_Export[2]
					$Number = 3
			EndSwitch
			$File = FileSaveDialog("Save List(s) As", @DesktopDir, "Excel Documents (*.xls)", 18, _
				$Temp & StringReplace(_NowDate(), "/", "-") & ".xls")
			If Not @error Then _ProcessList_Export($File, $Number)
	EndSwitch
EndFunc   ;==>_EventHandler

Func _Process_Close()
	Local $_Array = StringSplit(GUICtrlRead(GUICtrlRead($List_Process)), "|")
	ProcessClose($_Array[1])
	Sleep(100)
	_Process_Enum()
	_Windows_Enum()
EndFunc   ;==>_Process_Close

Func _Process_Prior($_CtrlId)
	Local $_Array = StringSplit(GUICtrlRead(GUICtrlRead($List_Process)), "|")
	Switch $_CtrlId
		Case $CTMenu_Processes_Priority_Above
			ProcessSetPriority($_Array[1], 3)
		Case $CTMenu_Processes_Priority_Below
			ProcessSetPriority($_Array[1], 1)
		Case $CTMenu_Processes_Priority_High
			ProcessSetPriority($_Array[1], 4)
		Case $CTMenu_Processes_Priority_Real
			ProcessSetPriority($_Array[1], 5)
		Case $CTMenu_Processes_Priority_Norm
			ProcessSetPriority($_Array[1], 2)
		Case $CTMenu_Processes_Priority_Low
			ProcessSetPriority($_Array[1], 0)
	EndSwitch
	_Process_Enum()
EndFunc   ;==>_Process_Prior

Func _Process_Free()
	Local $_Array = StringSplit(GUICtrlRead(GUICtrlRead($List_Process)), "|")
	_ReduceMemory($_Array[2])
EndFunc   ;==>_Process_Free

Func _Window_Status($_CtrlId)
	Local $_Array = StringSplit(GUICtrlRead(GUICtrlRead($List_Windows)), "|")
	WinSetState(HWnd($_Array[5]), "", $Array_Windows_Status[$_CtrlId])
	_Windows_Enum()
EndFunc   ;==>_Window_Status

Func WM_COMMAND($hWndGUI, $MsgID, $WParam, $LParam)
	ConsoleWrite(StringFormat("-==WM_COMMAND hWndGUI: %s, MsgID: %s, WParam: %s, LParam: %s Time: %s:%s:%s==-%s", _
			$hWndGUI, $MsgID, $WParam, $LParam, @HOUR, @MIN, @SEC, @CRLF))
	$Number = Number(GUICtrlRead($Input_Refresh))
	If StringLeft($WParam, 6) = $EN_UPDATE And $Number > 0 Then
		If $Number < 5 Then
			GUICtrlSetData($Input_Refresh, 5)
			$Number = 5
		EndIf
		$Delay_Update = $Number * 1000
		$Timer_Refresh = TimerInit()
	EndIf
EndFunc   ;==>WM_COMMAND

Func WM_NOTIFY($hWndGUI, $MsgID, $WParam, $LParam)
	Local $tagNMHDR, $Event, $HwndFrom, $IDFrom
	Local $tagNMHDR = DllStructCreate("int;int;int", $LParam)
	If @error Then Return $GUI_RUNDEFMSG
	$IDFrom = DllStructGetData($tagNMHDR, 2)
	$Event = DllStructGetData($tagNMHDR, 3)
	$tagNMHDR = 0
	If $Event = -101 And $IDFrom = $List_Process Then
		_SelectedProcess()
		Return $GUI_RUNDEFMSG
	EndIf
	If $Event = -101 And $IDFrom = $List_Windows Then
		_SelectedWindow()
		Return $GUI_RUNDEFMSG
	EndIf
	If $IDFrom = $List_Process Or $IDFrom = $List_Windows And $Event = -5 Then
		Switch $IDFrom
			Case $List_Process
				ControlClick($Window_Main, "", $Button_Processes, "right")
			Case $List_Windows
				ControlClick($Window_Main, "", $Button_Windows, "right")
		EndSwitch
	EndIf
EndFunc   ;==>WM_NOTIFY

Func _ReduceOwnMemory()
	_ReduceMemory(@AutoItPID)
EndFunc   ;==>_ReduceOwnMemory

Func CurrentCPU($init = 0)
	Local $SYS_BASIC_INFO = 0
	Local $SYS_PERFORMANCE_INFO = 2
	Local $SYS_TIME_INFO = 3

	$SYSTEM_BASIC_INFORMATION = DllStructCreate("int;uint;uint;uint;uint;uint;uint;ptr;ptr;uint;byte;byte;short")
	$Status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", $SYS_BASIC_INFO, _
			"ptr", DllStructGetPtr($SYSTEM_BASIC_INFORMATION), _
			"int", DllStructGetSize($SYSTEM_BASIC_INFORMATION), _
			"int", 0)

	If $Status[0] Then Return -1

	While 1
		$SYSTEM_PERFORMANCE_INFORMATION = DllStructCreate("int64;int[76]")
		$SYSTEM_TIME_INFORMATION = DllStructCreate("int64;int64;int64;uint;int")

		$Status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", $SYS_TIME_INFO, _
				"ptr", DllStructGetPtr($SYSTEM_TIME_INFORMATION), _
				"int", DllStructGetSize($SYSTEM_TIME_INFORMATION), _
				"int", 0)

		If $Status[0] Then Return -2

		$Status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", $SYS_PERFORMANCE_INFO, _
				"ptr", DllStructGetPtr($SYSTEM_PERFORMANCE_INFORMATION), _
				"int", DllStructGetSize($SYSTEM_PERFORMANCE_INFORMATION), _
				"int", 0)

		If $Status[0] Then Return -3

		If $init = 1 Or $liOldIdleTime = 0 Then
			$liOldIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1)
			$liOldSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2)
			Sleep(1000)
			If $init = 1 Then Return -99
		Else
			$dbIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1) - $liOldIdleTime
			$dbSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2) - $liOldSystemTime
			$liOldIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1)
			$liOldSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2)

			$dbIdleTime = $dbIdleTime / $dbSystemTime

			$dbIdleTime = 100.0 - $dbIdleTime * 100.0 / DllStructGetData($SYSTEM_BASIC_INFORMATION, 11) + 0.5

			Return $dbIdleTime
		EndIf
		$SYSTEM_PERFORMANCE_INFORMATION = 0
		$SYSTEM_TIME_INFORMATION = 0
	WEnd
EndFunc   ;==>CurrentCPU

Func _Process_Delete($PID, $Path)
	If MsgBox(305, "Warning", "Deleting this file is irreversible. Once deleted you can no longer access it." _
			 & @CRLF & "Deleting system files may result in system instability and/or cause damage to your Windows installation." & @CRLF & "Are you sure you wish to terminate the process and lose the executable file?") = 1 Then
		If Not ($Path = @WindowsDir & "\explorer.exe") And Not ($Path = @SystemDir & "\svchost.exe") And Not ($Path = @SystemDir & "\services.exe") _
				And Not ($Path = @SystemDir & "\smss.exe") And Not ($Path = @SystemDir & "\winlogon.exe") And Not ($Path = @SystemDir & "\lsass.exe") Then
			ProcessClose($PID)
			Sleep(200)
			FileDelete($Path)
			If ProcessExists($PID) Or FileExists($Path) Then
				MsgBox(64, "Failed", "Unable to remove the process. Please try again.")
			Else
				MsgBox(64, "Succeeded", "Process executable was succesfully removed.")
			EndIf
		EndIf
	EndIf
	_Process_Enum()
	_Windows_Enum()
EndFunc   ;==>_Process_Delete

Func _Process_FolderOpen($Process)
	Local $_Path
	If $Process = "Unknown" Then Return
	$Process = StringSplit($Process, "\")
	For $i = 1 To $Process[0] - 1
		$_Path &= ("\" & $Process[$i])
	Next
	$_Path = StringTrimLeft($_Path, 1)
	ShellExecute($_Path)
EndFunc   ;==>_Process_FolderOpen

Func _ProcessList_Export($Path, $Mode)
	$Window_Progress = GUICreate("Saving...", 409, 96, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_GROUP, $WS_BORDER, _
		$WS_CLIPSIBLINGS), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $Window_Main)
	GUICtrlCreateLabel("Please wait as AMP processes and saves the requested list...", 16, 16, 369, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Temp = GUICtrlCreateLabel("<Initiating...>", 16, 56, 200, 17)
	GUISetState(@SW_DISABLE, $Window_Main)
	GUISetState(@SW_SHOW, $Window_Progress)
	
	$oExcel = _ExcelBookNew(0)

	If $Mode = 3 Or $Mode = 2 Then
		GUICtrlSetData($Temp, "<Saving Process List>")
		_ExcelSheetNameSet($oExcel, "APM Window List")
		_ExcelWriteCell($oExcel, "Snapshot of WINDOWS, Taken At " & _Now(), "C1")
		_ExcelWriteCell($oExcel, "User: " & @ComputerName & "\" & @UserName, "C2")
		_ExcelWriteCell($oExcel, "Window Title:", "A4")
		_ExcelWriteCell($oExcel, "Window Status:", "B4")
		_ExcelWriteCell($oExcel, "Parent Process:", "C4")
		_ExcelWriteCell($oExcel, "Process ID:", "D4")
		_ExcelWriteCell($oExcel, "Window Handle:", "E4")
		
		For $i = 0 To _GUICtrlListViewGetItemCount($List_Windows)-1
			$_Array = StringSplit(_GUICtrlListViewGetItemText($List_Windows, $i), "|")
			For $j = 1 To $_Array[0]
				_ExcelWriteCell($oExcel, $_Array[$j], $Array_Alphabet[$j-1] & $i+6)
			Next
		Next
		
		For $i = 1 To 8
			_ExcelColWidthSet($oExcel, $Array_Alphabet[$i], "autofit")
		Next
		_ExcelColWidthSet($oExcel, "A", 40)
	EndIf
	
	If $Mode = 1 Or $Mode = 3 Then
		GUICtrlSetData($Temp, "<Saving Window List>")
		If $Mode = 3 Then
			_ExcelSheetAddNew($oExcel, "APM Process List")
		Else
			_ExcelSheetNameSet($oExcel, "APM Process List")
		EndIf
		_ExcelWriteCell($oExcel, "Snapshot of Processes, Taken At " & _Now(), "D1")
		_ExcelWriteCell($oExcel, "User: " & @ComputerName & "\" & @UserName, "D2")
		_ExcelWriteCell($oExcel, "Process Name:", "A4")
		_ExcelWriteCell($oExcel, "Process ID:", "B4")
		_ExcelWriteCell($oExcel, "Process Priority:", "C4")
		_ExcelWriteCell($oExcel, "Process Path:", "D4")
		
		For $i = 0 To _GUICtrlListViewGetItemCount($List_Process)-1
			$_Array = StringSplit(_GUICtrlListViewGetItemText($List_Process, $i), "|")
			For $j = 1 To $_Array[0]
				_ExcelWriteCell($oExcel, $_Array[$j], $Array_Alphabet[$j-1] & $i+6)
			Next
		Next
		
		For $i = 0 To 8
			_ExcelColWidthSet($oExcel, $Array_Alphabet[$i], "autofit")
		Next
	EndIf
	
	GUICtrlSetData($Temp, "<Finished>")
	Sleep(50)
	_ExcelBookSaveAs($oExcel, $Path, "xls", 0, 1)
	_ExcelBookClose($oExcel)
	GUISetState(@SW_ENABLE, $Window_Main)
	GUIDelete($Window_Progress)
	_ReduceMemory()
EndFunc   ;==>_ProcessList_Export

Func _StringFixName($String)
	Local $Length = StringLen($String)
	If $Length < 8 Then
		$String &= @TAB & @TAB
	ElseIf $Length < 16 Then
		$String &= @TAB
	EndIf
	Return $String
EndFunc   ;==>_StringFixName

Func _StringFixPrior($String)
	Local $Length = StringLen($String)
	If $Length < 7 Then $String &= @TAB
	Return $String
EndFunc   ;==>_StringFixPrior

Func _Resized()
	_GUICtrlStatusBarResize($StatusBar)
EndFunc   ;==>_Resized

Func _Minimized()
	GUISetState(@SW_HIDE, $Window_Main)
EndFunc   ;==>_Minimized

Func _Tray_DoubleClick()
	GUISetState(@SW_SHOW, $Window_Main)
EndFunc   ;==>_Tray_DoubleClick

Func __ArrayDisplay($aArray, $Title = "Array Display")
	Local $sOutput
	Switch UBound($aArray, 0)
		Case 1
			For $iI = 0 To UBound($aArray) - 1
				$sOutput &= $aArray[$iI] & @CRLF
			Next
		Case 2
			For $iI = 0 To UBound($aArray, 1) - 1
				For $iJ = 0 To UBound($aArray, 2) - 1
					$sOutput &= $iI & ", subvalue " & $iJ & ": " & $aArray[$iI][$iJ] & @CRLF
				Next
			Next
		Case Else
			Return SetError(1, 0, -1)
	EndSwitch
	MsgBox(64, $Title, $sOutput)
EndFunc   ;==>__ArrayDisplay

Func _ArrayClean()
	$Timer = TimerInit()
	Dim $Array_Process_New[1][3], $Array_Windows_New[1][3]
	For $i = 1 To UBound($Array_Process_Old, 1) - 1
		If $Array_Process_Old[$i][1] <> "" Then
			$Number = UBound($Array_Process_New, 1) + 1
			ReDim $Array_Process_New[$Number][3]
			$Array_Process_New[$Number - 1][0] = $Array_Process_Old[$i][0]
			$Array_Process_New[$Number - 1][1] = $Array_Process_Old[$i][1]
			$Array_Process_New[$Number - 1][2] = $Array_Process_Old[$i][2]
		EndIf
	Next
	For $i = 1 To UBound($Array_Windows_Old, 1) - 1
		If $Array_Windows_Old[$i][0] <> "" Then
			$Number = UBound($Array_Windows_New, 1) + 1
			ReDim $Array_Windows_New[$Number][3]
			$Array_Windows_New[$Number - 1][0] = $Array_Windows_Old[$i][0]
			$Array_Windows_New[$Number - 1][1] = $Array_Windows_Old[$i][1]
			$Array_Windows_New[$Number - 1][2] = $Array_Windows_Old[$i][2]
		EndIf
	Next
	$Array_Process_Old = $Array_Process_New
	$Array_Windows_Old = $Array_Windows_New
EndFunc   ;==>_ArrayClean

Func _PriorConvert(ByRef $Prior)
	If $Prior < 0 Then
		$Prior = "Not Applicable"
	Else
		$Prior = $Array_Process_Priority[$Prior]
	EndIf
	Return $Prior
EndFunc   ;==>_PriorConvert

Func _StatusConvert($Status)
	Local $Return = ""
	If BitAND($Status, 2) Then
		$Return &= ", Visbl."
	Else
		$Return &= ", Hidden"
	EndIf
	If BitAND($Status, 4) Then
		$Return &= ", Enabld."
	Else
		$Return &= ", Disabld."
	EndIf
	If BitAND($Status, 8) Then $Return &= ", Active"
	If BitAND($Status, 16) Then $Return &= ", Minimzd."
	If BitAND($Status, 32) Then $Return &= ", Maximzd."
	Return StringTrimLeft($Return, 2)
EndFunc   ;==>_StatusConvert

Func _ProcessNT($iPID, $iSuspend = True)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)
    If Not $iPID Then Return SetError(2, 0, 0)
    Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPID)
    If $iSuspend Then
        Local $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
    Else
        Local $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
    EndIf
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then Return 1
    Return SetError(1, 0, 0)
EndFunc

Func _Exit()
	Exit
EndFunc   ;==>_Exit

;~ Func _HiWord($x)
;~     Return BitShift($x, 16)
;~ EndFunc   ;==>_HiWord

;~ Func _LoWord($x)
;~     Return BitAND($x, 0xFFFF)
;~ EndFunc   ;==>_LoWord