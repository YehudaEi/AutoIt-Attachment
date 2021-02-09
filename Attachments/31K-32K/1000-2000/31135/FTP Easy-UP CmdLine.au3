#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.4.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>
Opt("GUIOnEventMode", 1)

GUICreate("FTP Easy-UP", 300, 130)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUICtrlCreateButton("Create ContextMenu", 5, 5, 290, 30)
GUICtrlSetOnEvent(-1, "_CmCreate")

GUICtrlCreateButton("Remove ContextMenu", 5, 50, 290, 30)
GUICtrlSetOnEvent(-1, "_CmRemove")

GUICtrlCreateButton("Show Settings", 5, 95, 290, 30)
GUICtrlSetOnEvent(-1, "_ShowSettings")

GUISetState(@SW_SHOW)

while 1

WEnd

Func _Exit()
	Exit
EndFunc

Func _CmCreate()
	ShellExecute("FTP Easy-UP.exe", "/Cm-Create")
EndFunc

Func _CmRemove()
	ShellExecute("FTP Easy-UP.exe", "/Cm-Remove")
EndFunc

Func _ShowSettings()
	ShellExecute("FTP Easy-UP.exe", "/Settings")
EndFunc
