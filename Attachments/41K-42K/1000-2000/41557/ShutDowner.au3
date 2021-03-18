#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=shutdown.ico
#AutoIt3Wrapper_outfile=..\ShutDowner.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <Date.au3>
#Include <ScreenCapture.au3>
#include <ListviewConstants.au3>
#Include <Array.au3>
#include <Process.au3>

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1+2)
AutoItSetOption ("WinTitleMatchMode",3) ;3 stands for exact match for a window name
TraySetToolTip ("ShutDowner")
;v1.2
Global $option

$ReadLastDay = IniRead("ShutDowner.ini", "Time", "LastDays", "")
$ReadLastHour = IniRead("ShutDowner.ini", "Time", "LastHours", "")
$ReadLastMinute = IniRead("ShutDowner.ini", "Time", "LastMinute", "")
$ReadLastAction = IniRead("ShutDowner.ini", "Options", "LastAction", "")
$ReadLastScreenshot = IniRead("ShutDowner.ini", "Options", "TakeScreenshot", "")
$ReadLastMouseMove = IniRead("ShutDowner.ini", "Options", "MouseMove", "")

TrayCreateItem("Terminate and EXIT")
TrayItemSetOnEvent(-1,"ExitFunction") ;function name

$Form1 = GUICreate("ShutDowner", 460, 460)
GUICtrlCreateGroup("How long to wait ?", 5, 3, 150, 180)

GUICtrlCreateLabel("Day's", 30, 23)
$Days = GUICtrlCreateInput($ReadLastDay, 10, 20, 20, 20)
If GUICtrlRead ($Days) = "" Then GUICtrlSetData ($Days ,"0")

GUICtrlCreateLabel("Hr's", 80, 23)
$Hours = GUICtrlCreateInput($ReadLastHour, 60, 20, 20, 20)
If GUICtrlRead ($Hours) = "" Then GUICtrlSetData ($Hours ,"0")
GUICtrlSetLimit($Hours, 2)

GUICtrlCreateLabel("Min's", 125, 23, 25)
$Minutes = GUICtrlCreateInput($ReadLastMinute, 105, 20, 20, 20)
If GUICtrlRead ($Minutes) = "" Then GUICtrlSetData ($Minutes ,"10")
GUICtrlSetLimit($Minutes, 2)

$optionInput = GUICtrlCreateInput("Please select desired action", 10, 40, 140)
GUICtrlSetState (-1,$GUI_DISABLE)
$reasonInput = GUICtrlCreateEdit("No reason specified", 10, 60, 140, 115)

GUICtrlCreateGroup("Action's:", 160, 3, 90, 120)
$optionLogoff = GUICtrlCreateRadio("LogOff", 170, 20)
If $ReadLastAction = "LogOff" Then
	GUICtrlSetState (-1,$GUI_CHECKED)
	GUICtrlSetData ($optionInput,"LogOff")
	Assign ("option",0)
EndIf
$optionShutDown = GUICtrlCreateRadio("ShutDown", 170, 40)
If $ReadLastAction = "ShutDown" Then
	GUICtrlSetState (-1,$GUI_CHECKED)
	GUICtrlSetData ($optionInput,"ShutDown")
	Assign ("option",1)
EndIf
$optionReboot = GUICtrlCreateRadio("Reboot", 170, 60)
If $ReadLastAction = "Reboot" Then
	GUICtrlSetState (-1,$GUI_CHECKED)
	GUICtrlSetData ($optionInput,"Reboot")
	Assign ("option",2)
EndIf
$optionStandby = GUICtrlCreateRadio("Standby", 170, 80)
If $ReadLastAction = "Standby" Then
	GUICtrlSetState (-1,$GUI_CHECKED)
	GUICtrlSetData ($optionInput,"Standby")
	Assign ("option",32)
EndIf
$optionHibernate = GUICtrlCreateRadio("Hibernate", 170, 100)
If $ReadLastAction = "Hibernate" Then
	GUICtrlSetState (-1,$GUI_CHECKED)
	GUICtrlSetData ($optionInput,"Hibernate")
	Assign ("option",64)
EndIf
GUICtrlCreateGroup("Optional:", 160, 123, 90, 60)
$optionForceCloseApps = GUICtrlCreateCheckbox("Force", 165, 140)
GUICtrlSetState (-1,$GUI_CHECKED)
$optionForceAll = GUICtrlCreateCheckbox("Force if hung", 165, 160)
GUICtrlSetState (-1,$GUI_CHECKED)
$Screenshot = GUICtrlCreateCheckbox ("Take Screenshot's before selected action.",10,190,220,15)
GUICtrlSetTip (-1,"This option will save screenshots to:" & @CRLF & @DesktopDir & "\SD Date and Time.jpg")
If $ReadLastScreenshot = "Yes" Then GUICtrlSetState (-1,$GUI_CHECKED)

$MouseMove = GUICtrlCreateCheckbox ("Cancel if mouse moved.",10,210,220,15) ;Mouse option
GUICtrlSetTip (-1,"This option will terminate LogOff/ShutDown etc if you move mouse when time reaches 0 Day's 0 Hr's 0 Min's")
If $ReadLastMouseMove = "Yes" Then GUICtrlSetState (-1,$GUI_CHECKED)

GUICtrlCreateGroup ("Process",5,230,245,40)
$ProcessName = GUICtrlCreateInput ("",10,245,100,20)
GUICtrlSetTip (-1,"Process name")
$ProcessClose = GUICtrlCreateRadio ("Close",115,245)
$WaitProcess = GUICtrlCreateRadio ("Wait till closed",160,245)

$RefreshProcess = GUICtrlCreateButton ("Refresh list",255,375,100)
$SelectProcess = GUICtrlCreateButton ("Select",255,400,100)
$ProcessList = GUICtrlCreateListView ("Process                                ",255,10,100,365,$LVS_SORTASCENDING)
$ProcessList1st = ProcessList()
for $i = 1 to $ProcessList1st[0][0]
	If ($ProcessList1st[$i][1]) = "" Then
	Else
		GUICtrlCreateListViewItem($ProcessList1st[$i][0],$ProcessList)
	EndIf
next
GUICtrlCreateGroup ("Windows",5,270,245,60)
;$WindowName = GUICtrlCreateInput ("",10,285,236,20)
$WindowName = GUICtrlCreateCombo("",10,285,236,20)
GUICtrlSetTip ($WindowName,"Window name")
GUICtrlSetData ($WindowName,"No|presset|available|yet") ;Window name presset go here
$WinClose = GUICtrlCreateRadio ("Close",10,305)
GUICtrlSetTip (-1,"Will close specified window")
$WinWaitClose = GUICtrlCreateRadio ("Wait Closed",80,305)
GUICtrlSetTip (-1,"Will wait untill specified window is closed")
$WinWaitExist =  GUICtrlCreateRadio ("Wait Exist",165,305)
GUICtrlSetTip (-1,"Will wait untill specified window exists/appears")
$WinList = GUICtrlCreateListView ("Window                                                       ",355,10,100,365,$LVS_SORTASCENDING)
$Win1st = WinList()
For $W1st = 1 to $Win1st[0][0]
	If $Win1st[$W1st][0] <> "" AND IsVisible($Win1st[$W1st][1]) Then
		GUICtrlCreateListViewItem ($Win1st[$W1st][0] & @LF,$WinList)
	EndIf
Next
$RefreshWindows = GUICtrlCreateButton ("Refresh Windows",355,375,100)
$SelectWindow = GUICtrlCreateButton ("Select",355,400,100)

GUICtrlCreateGroup ("Commands",5,330,245,130)
$CommandLine1 = GUICtrlCreateEdit ("",10,345,190,110)
GUICtrlSetTip (-1,"This can be one line command or a whole script." & @CRLF & "Generated Command.bat will be executed" & @CRLF & "Dont forget to add EXIT at the end of your script")
$CommandTest = GUICtrlCreateButton ("TEST",205,345,40,110)
GUICtrlSetTip (-1,"Test this command to see if it will work.")

$button = GUICtrlCreateButton("Start Count Down", 255, 425, 200, 30)
GUISetState(@SW_SHOW)
GuiFunc()
Func GuiFunc()
    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                Exit
            Case $optionLogoff
                GUICtrlSetData($optionInput, "Logoff")
				IniWrite ("ShutDowner.ini", "Options", "LastAction", "Logoff")
                Assign ("option",0)
            Case $optionShutDown
                GUICtrlSetData($optionInput, "ShutDown") ;logs off :(
				IniWrite ("ShutDowner.ini", "Options", "LastAction", "ShutDown")
                Assign ("option",1)
            Case $optionReboot
                GUICtrlSetData($optionInput, "Reboot") ;works
				IniWrite ("ShutDowner.ini", "Options", "LastAction", "Reboot")
                Assign ("option",2)
            Case $optionStandby
                GUICtrlSetData($optionInput, "Standby")
				IniWrite ("ShutDowner.ini", "Options", "LastAction", "Standby")
                Assign ("option",32)
            Case $optionHibernate
                GUICtrlSetData($optionInput, "Hibernate")
				IniWrite ("ShutDowner.ini", "Options", "LastAction", "Hibernate")
                Assign ("option",64)
           ;create case for checkboxes to write them to ini so they are saved each time
			Case $optionForceCloseApps
                If GUICtrlRead($optionForceCloseApps) = $GUI_CHECKED Then
                ElseIf GUICtrlRead($optionForceCloseApps) = $GUI_UNCHECKED Then
                EndIf
            Case $optionForceAll
                If GUICtrlRead($optionForceAll) = $GUI_CHECKED Then
                ElseIf GUICtrlRead($optionForceAll) = $GUI_UNCHECKED Then
                EndIf
			Case $RefreshProcess
				GUICtrlDelete ($ProcessList)
				$ProcessList = GUICtrlCreateListView ("Process                                ",255,10,100,365,$LVS_SORTASCENDING)
				$list = ProcessList()
				for $i = 1 to $list[0][0]
					If ($list[$i][1]) = "" Then
						;empty
					Else
						GUICtrlCreateListViewItem($list[$i][0],$ProcessList)
					EndIf
				next
			Case $SelectProcess
				$ReadSelected = GUICtrlRead ($ProcessList,"ListView")
				$FixedName = StringTrimRight(GUICtrlRead ($ReadSelected),1)
				GUICtrlSetData ($ProcessName,$FixedName)
			Case $RefreshWindows
				GUICtrlDelete ($WinList)
				$WinList = GUICtrlCreateListView ("Window                                                       ",355,10,100,365,$LVS_SORTASCENDING)
				$Win = WinList()
				For $W = 1 to $Win[0][0]
					; Only display visble windows that have a title
					If $Win[$W][0] <> "" AND IsVisible($Win[$W][1]) Then
						GUICtrlCreateListViewItem ($Win[$W][0] & @LF,$WinList)
					EndIf
				Next
			Case $SelectWindow
				$ReadSelectedWindow = GUICtrlRead ($WinList,"ListView")
				$FixedName = StringTrimRight(GUICtrlRead ($ReadSelectedWindow),2)
				GUICtrlSetData ($WindowName,$FixedName)
			Case $CommandTest
				$ReadCommand = GUICtrlRead ($CommandLine1)
				FileDelete (@ScriptDir & "\Command.bat")
				FileWrite (@ScriptDir & "\Command.bat",$ReadCommand)
				RunWait (@ScriptDir & "\Command.bat",@ScriptDir)
				FileDelete (@ScriptDir & "\Command.bat")
			Case $Screenshot
				If GUICtrlRead ($Screenshot) = $GUI_CHECKED Then
					IniWrite ("ShutDowner.ini", "Options", "TakeScreenshot", "Yes")
				Else
					IniWrite ("ShutDowner.ini", "Options", "TakeScreenshot", "No")
				EndIf
			Case $MouseMove
				If GUICtrlRead ($MouseMove) = $GUI_CHECKED Then
					IniWrite ("ShutDowner.ini", "Options", "MouseMove", "Yes")
				Else
					IniWrite ("ShutDowner.ini", "Options", "MouseMove", "No")
				EndIf
			Case $button
				If GUICtrlRead ($optionInput) = "Please select desired action" Then
					MsgBox(64,"Information","Please select desired action frst.")
				Else
					GUISetState(@SW_HIDE)
					_StartCountDown()
				EndIf
		EndSwitch
	WEnd
EndFunc ;==>GuiFunc

Func _StartCountDown()
    Local $ActionRead = GUICtrlRead($optionInput)
    Local $ReadDays = GUICtrlRead($Days)
    Local $ReadHours = GUICtrlRead($Hours)
    Local $ReadMinutes = GUICtrlRead($Minutes)
    Local $ForceCloseRead = GUICtrlRead($optionForceCloseApps)
    Local $ForceFrozeRead = GUICtrlRead($optionForceAll)
    Local $reason = GUICtrlRead($reasonInput)

    If $ReadDays >= 365 Then
        MsgBox(64, "Days Error", "Please set from 0-364 days only")
        GUISetState(@SW_SHOW)
        Return
    EndIf
    If $ReadHours >= 24 Then
        MsgBox(64, "Hours Error", "Please set from 0-23 hours only")
        GUISetState(@SW_SHOW)
        Return
    EndIf
    If $ReadMinutes >= 60 Then
        MsgBox(64, "Minutes Error", "Please set from 0-59 minutes only")
        GUISetState(@SW_SHOW)
        Return
    EndIf
    If $ActionRead = "What to do" Then
        MsgBox(16, 'Error', 'Please select action first')
        GUISetState(@SW_SHOW)
        Return
    EndIf
    IniWrite("ShutDowner.ini", "Time", "LastDays", $ReadDays)
    IniWrite("ShutDowner.ini", "Time", "LastHours", $ReadHours)
    IniWrite("ShutDowner.ini", "Time", "LastMinute", $ReadMinutes)
    If $ForceCloseRead = 1 Then Assign ("option",$option+4)
    If $ForceFrozeRead = 1 Then Assign ("option",$option+16)

    $timer = TimerInit()
    $ShutDowntime = (((($ReadDays*24)+$ReadHours)*60)+$ReadMinutes)*60*1000
    While 1
        Local $ms = $ShutDowntime - TimerDiff($timer)
        If $ms < 0 Then
			If GUICtrlRead ($Screenshot) = $GUI_CHECKED Then _ScreenCapture_Capture (@DesktopDir & "\SD SCRN1 D" & @MDAY & "M" & @MON & "Y"& @YEAR & " " & @HOUR & @MIN & @SEC & ".jpg" )
			If GUICtrlRead ($ProcessName) > "" And ProcessExists (GUICtrlRead ($ProcessName)) > 0 Then ;0=not found
				If GUICtrlRead ($ProcessClose) = $GUI_CHECKED Then
					TraySetToolTip ("Closing process " & GUICtrlRead ($ProcessName))
					ProcessClose (GUICtrlRead ($ProcessName))
				EndIf
				If GUICtrlRead ($WaitProcess) = $GUI_CHECKED Then
					TraySetToolTip ("Waiting for process " & GUICtrlRead ($ProcessName) & " to be closed.")
					ProcessWaitClose (GUICtrlRead ($ProcessName))
				EndIf
				If GUICtrlRead ($Screenshot) = $GUI_CHECKED Then _ScreenCapture_Capture (@DesktopDir & "\SD PROC D" & @MDAY & "M" & @MON & "Y"& @YEAR & " " & @HOUR & @MIN & @SEC & ".jpg" )
			EndIf
			If GUICtrlRead ($WindowName) > "" And WinExists (GUICtrlRead ($WindowName)) = 1 Then ;1=exist
				If GUICtrlRead ($WinClose) = $GUI_CHECKED Then
					TraySetToolTip ("Closing window named " & GUICtrlRead ($WindowName))
					WinClose (GUICtrlRead ($WindowName))
				EndIf
				If GUICtrlRead ($WinWaitClose) = $GUI_CHECKED Then
					TraySetToolTip ("Waiting for window " & GUICtrlRead ($WindowName) & " to be closed.")
					WinWaitClose (GUICtrlRead ($WindowName))
				EndIf
				If GUICtrlRead ($Screenshot) = $GUI_CHECKED Then _ScreenCapture_Capture (@DesktopDir & "\SD WND D" & @MDAY & "M" & @MON & "Y"& @YEAR & " " & @HOUR & @MIN & @SEC & ".jpg" )
			Else
				If GUICtrlRead ($WinWaitExist) = $GUI_CHECKED Then
					TraySetToolTip ("Waiting for window " & GUICtrlRead ($WindowName) & " to appear.")
					WinWait (GUICtrlRead ($WindowName))
				EndIf
				If GUICtrlRead ($Screenshot) = $GUI_CHECKED Then _ScreenCapture_Capture (@DesktopDir & "\SD WND D" & @MDAY & "M" & @MON & "Y"& @YEAR & " " & @HOUR & @MIN & @SEC & ".jpg" )
			EndIf
			If GUICtrlRead ($CommandLine1) > "" Then
				TraySetToolTip ("Executing command")
				$ReadCommandWait = GUICtrlRead ($CommandLine1) ;read whole command script
				FileDelete (@ScriptDir & "\Command.bat") ;delete command file
				FileWrite (@ScriptDir & "\Command.bat",$ReadCommandWait) ;write read command to file
				RunWait (@ScriptDir & "\Command.bat",@ScriptDir) ;execute command file
				FileDelete (@ScriptDir & "\Command.bat") ;delete command file
				If GUICtrlRead ($Screenshot) = $GUI_CHECKED Then _ScreenCapture_Capture (@DesktopDir & "\SD CMD D" & @MDAY & "M" & @MON & "Y"& @YEAR & " " & @HOUR & @MIN & @SEC & ".jpg" )
			EndIf
			If GUICtrlRead ($Screenshot) = $GUI_CHECKED Then _ScreenCapture_Capture (@DesktopDir & "\SD SCRN2 D" & @MDAY & "M" & @MON & "Y"& @YEAR & " " & @HOUR & @MIN & @SEC & ".jpg" )
			$LastMousePos = ""
			$GetPos1 = MouseGetPos()
			Assign ("LastMousePos",$GetPos1[0] & "," & $GetPos1[1])
			Sleep (1000)
			If GUICtrlRead ($MouseMove) = $GUI_CHECKED Then ;Check if mousecheckbox is checked
				While 1
					$GetPos2 = MouseGetPos()
					If $LastMousePos = ($GetPos2[0] & "," & $GetPos2[1]) Then
						;Mouse not moved
						ExitLoop ; then go to shutdown
					Else
						;Mouse moved
						MsgBox(16,'Information','  Mouse moved' & @CRLF & "Action canceled")
						Exit
					EndIf
				WEnd
			EndIf
			;MsgBox(0,'',$option)
			;Exit
			Shutdown($option,$reason)
			Exit
        Else
            ToolTip(GUICtrlRead ($optionInput) & " in " & StringFormat("%d days and \n%02d:%02d:%02d", Int($ms / 86400000), Mod(Int($ms / 3600000),24), Mod(Int($ms / 60000),60), Mod(Int($ms / 1000),60)),@DesktopWidth/2-70,@DesktopHeight/2-60,"ShutDowner CountDown")
        EndIf
		Sleep(1000) ;to prevent timeout window to be flashing during loop
    WEnd
EndFunc

Func ExitFunction()
	Exit
EndFunc

Func IsVisible($handle)
	If BitAnd( WinGetState($handle), 2 ) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc