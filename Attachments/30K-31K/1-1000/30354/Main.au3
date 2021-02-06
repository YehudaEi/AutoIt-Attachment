#NoTrayIcon
#RequireAdmin
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#include <BackupMaterialLibrary.au3>

$OS = @OSVersion
$OSbit = @OSArch

$Form1 = GUICreate("Max Loader",260,400)
$MaterialLibrary = GUICtrlCreateCheckbox ("Material library",160,15)
GUICtrlSetState ($MaterialLibrary,$GUI_CHECKED)
$Backup = GUICtrlCreateButton ("Backup",10,140,60,20)
$progress = GUICtrlCreateProgress(70,140,120,20)

GUICtrlCreateGroup ("Log",5,230,250,160) ;Group
$Edit = GUICtrlCreateEdit ("",10,250,240,130)

GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		case $Backup
			BackupMaterialLibrary()
			MsgBox(0,'','backup function completed.')
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd
