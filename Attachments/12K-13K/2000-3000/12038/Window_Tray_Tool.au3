#comments-start

<=Window Tray Tool=>   by IsleOfTechno (korschenbroich@yahoo.de) 19.11.2006

This script can hide a window and show a Tray-symbol when you minimize the window.

You have to identify the window you want to use by a part of its Window-title AND a part of the 
Process-name of the application which has created this window, so you can be sure my tool
will hide the correct window ...

If your given iditifiers apply to two or more windows, the tool will hide them all and show 
them again with one click.

To save system performance i have included sleep(1000) so that it checks the windows every
second ... you can reduce this value if you have a fast CPU ^^

#comments-end


; Tray event values
Global Const $TRAY_EVENT_PRIMARYUP		= -8


Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)   
Opt("TrayIconHide", 1)
AutoItWinSetTitle(@ScriptName)
TraySetClick ( 16 )
TraySetOnEvent($TRAY_EVENT_PRIMARYUP,"make_visible")
$exititem = TrayCreateItem("Show")
TrayItemSetOnEvent(-1,"make_visible")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitScript")
TraySetState()
TraySetToolTip("Window Tray Tool")

Const $part_of_windowtitel =  "Editor"   ; the textpart of the window-title which you want to use to identify the correct window
Const $part_of_processname = "notepad"   ; the textpart of the processname of the process which has created the window as its in the task-manager 

Opt("TrayIconHide", 1) 

_Singleton("Window Tray Tool.exe")   ; allows only one inctance of this tool at the same time

While 1
	sleep(1000)   ; intervall to check the windows if the special one was just minimized by the user
	Opt( "WinTitleMatchMode", 2 )
	$window_array = WinList($part_of_windowtitel)
	Opt( "WinTitleMatchMode", 4 )
	for $i = 1 to $window_array[0][0]
		If StringInStr(_ProcessGetName(WinGetProcess ($window_array[$i][1])),$part_of_processname) <> 0 AND BitAnd(WinGetState ($window_array[$i][1]) , 16) = 16 AND BitAnd(WinGetState ($window_array[$i][1]) , 2)   Then
			WinSetState ( $window_array[$i][1] , "",@SW_HIDE)
			Opt("TrayIconHide", 0)
		EndIf
	Next
WEnd


Func make_visible()
	Opt( "WinTitleMatchMode", 2 )
	$window_array2 = WinList($part_of_windowtitel)
	Opt( "WinTitleMatchMode", 4 )
	For $i = 1 to $window_array2[0][0]
		If StringInStr(_ProcessGetName(WinGetProcess ($window_array2[$i][1])),$part_of_processname) <> 0 AND BitAnd(WinGetState ($window_array2[$i][1]) , 2) <> 2 Then
			WinSetState ( $window_array2[$i][1] , "",@SW_SHOW)
			WinSetState ( $window_array2[$i][1], "",@SW_RESTORE)
		EndIf
		Opt("TrayIconHide", 1) 
	Next
EndFunc   ;==>make_visible


Func _ProcessGetName( $i_PID )
	If Not ProcessExists($i_PID) Then
		SetError(1)
		Return ''
	EndIf
	Local $a_Processes = ProcessList()
	If Not @error Then
		For $i = 1 To $a_Processes[0][0]
			If $a_Processes[$i][1] = $i_PID Then Return $a_Processes[$i][0]
		Next
	EndIf
	SetError(1)
	Return ''
EndFunc   ;==>_ProcessGetName


Func _Singleton($occurenceName, $flag = 0)
	Local $ERROR_ALREADY_EXISTS = 183
	$occurenceName = StringReplace($occurenceName, "\", "") ; to avoid error
	;    Local $handle = DllCall("kernel32.dll", "int", "CreateSemaphore", "int", 0, "long", 1, "long", 1, "str", $occurenceName)
	Local $handle = DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", $occurenceName)
	Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		If $flag = 0 Then
			Exit -1
		Else
			SetError($lastError[0])
			Return 0
		EndIf
	EndIf
	Return $handle[0]
EndFunc   ;==>_Singleton


Func ExitScript()
	make_visible()
	WinClose(@ScriptName)
	Exit
EndFunc   ;==>ExitScript
 
 