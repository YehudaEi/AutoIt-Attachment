#include <GUIConstants.au3>
GUICreate("Choose Application", 85, 450,0,1, $WS_popup,$WS_EX_TOPMOST) ; will create a dialog box that when displayed is centered
Opt("GUICoordMode", 2)
$Button_1 = GUICtrlCreateButton ("Explorer",  5, 5, 80)
$Button_2 = GUICtrlCreateButton ("Internet", -80, 5, 80)
$Button_3 = GUICtrlCreateButton ("Web Mail", -80, 5, 80)
$Button_4 = GUICtrlCreateButton ("Notes Mail", -80, 5, 80)
$Button_5 = GUICtrlCreateButton ("EventVwr", -80, 5, 80)
$Button_6 = GUICtrlCreateButton ("TaskMgr", -80, 5, 80)
$Button_7 = GUICtrlCreateButton ("Dos Box", -80, 5, 80)
$Button_8 = GUICtrlCreateButton ("Remedy User", -80, 5, 80)
$Button_9 = GUICtrlCreateButton ("Augeo", -80, 5, 80)
$Button_10 = GUICtrlCreateButton ("R Controle", -80, 5, 80)
$Button_11 = GUICtrlCreateButton ("AutoIT", -80, 5, 80)
$Button_12 = GUICtrlCreateButton ("My Documents", -80, 5, 80)
$Button_13 = GUICtrlCreateButton ("Comp Mgr",-80, 5, 80)
$Button_14 = GUICtrlCreateButton ("SMS Console",-80, 5, 80)
$Button_15 = GUICtrlCreateButton ("AD User Comp",-80, 5, 80)

GUISetState ()      

; Run the GUI until the dialog is closed
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
		case $msg = $Button_1
			Send("{LWINDOWN}")
			Send("{e down}") 
			Send("{LWINUP}")
        Case $msg = $Button_2
			Run('C:\Program Files\Internet Explorer\IEXPLORE.EXE www.google.be')
		Case $msg = $Button_3
			Run('C:\Program Files\Internet Explorer\IEXPLORE.EXE www.zita.be/?webmail.be')
		Case $msg = $Button_4
			Run('C:\Program Files\Lotus\Notes\notes.exe =C:\data\notes\notes.ini')
		Case $msg = $Button_5
			Run('C:\WINDOWS\system32\eventvwr.exe')
		Case $msg = $Button_6
			Run('Taskmgr')
		Case $msg = $Button_7
			Run('cmd', 'c:\')
		case $msg = $Button_8
			Run('C:\Program Files\AR System\User\aruser.exe')
		Case $msg = $Button_9
			Run('C:\Program Files\Internet Explorer\IEXPLORE.EXE                                                  ')
		case $msg = $Button_10
			Run('C:\SMSADMIN\RemoteControl.exe')
		case $msg = $Button_11
			Run('C:\Program Files\AutoIt3\SciTE\SciTE.exe')
		Case $msg = $Button_12
            Run('explorer') 
		Case $msg = $Button_13
			Run('mmc.exe C:\WINDOWS\system32\CompMgr.msc')
		Case $msg = $Button_14
			Run('mmc.exe C:\SMSADMIN\bin\i386\sms.msc')
		Case $msg = $Button_15
			Run('mmc.exe C:\WINDOWS\system32\AD.msc')
	EndSelect

Wend
#include <GUIConstants.au3>
GUICreate( "Get date", 210,190)


