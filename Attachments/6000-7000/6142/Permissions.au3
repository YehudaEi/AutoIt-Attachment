#include <GUIConstants.au3>
#Include <process.au3>

;Generated with Form Designer preview
$Form1 = GUICreate("Permissions", 405, 117, 190, 119)
GUICtrlCreateLabel("Folder Permissions Setter!", 16, 8, 305, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Lock = GUICtrlCreateButton("&Lock", 40, 80, 81, 25)
$Unlock = GUICtrlCreateButton("&Unlock", 200, 80, 81, 25)
GUICtrlCreateLabel("Path:", 8, 48, 29, 17)
$path_name = GUICtrlCreateInput("", 40, 48, 241, 21, -1, $WS_EX_CLIENTEDGE)
$Browse = GUICtrlCreateButton("&Browse", 296, 48, 81, 25)
GUISetState(@SW_SHOW)
$path=""

While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Unlock
			$path = guictrlread($path_name)
			if $path == "" Then
				MsgBox(16,"Error","No Path Name set, Please Retry.")
			ElseIf Not FileExists($path)Then
				MsgBox(16,"Error","Path name invalid!")
			Else
				;MsgBox(0,"","ECHO Y| CACLS """& $path &""" /g  "& @UserName &":F") for debuging
				$cmd=_RunDOS("ECHO Y| CACLS """& $path &""" /g  "& @UserName &":F")
				MsgBox(0,"","UNLOCKED")
			EndIf
		Case $msg = $Browse
			$path=FileSelectFolder("Please Choose a Folder","C:\",1)
			GUICtrlSetdata($path_name,$path)
			
		Case $msg = $Lock
			$path = guictrlread($path_name)
			if $path == "" Then
				MsgBox(16,"Error","No Path Name set, Please Retry.")
			ElseIf Not FileExists($path)Then
				MsgBox(16,"Error","Path name invalid!")
			Else
				;MsgBox(0,"","ECHO Y| CACLS """& $path &""" /d  "& @UserName ) for debuging
				$cmd=_RunDOS("ECHO Y| CACLS """& $path &""" /d  "& @UserName)
				MsgBox(0,"","Locked")
			EndIf
		Case Else
			;;;;;;;
	EndSelect
WEnd
Exit