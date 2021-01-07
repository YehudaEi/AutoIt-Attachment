#include <GuiConstants.au3>

Global Const $Mount_Dir = 'C:\Test_Dir\'
#region Func-Defs
	Func ListDrives()
		Local $drives = DriveGetDrive('ALL')
		Local $Output
		For $x = 1 To $drives[0]
			$Output &= StringUpper($drives[$x]) & ' ' & DriveGetLabel($drives[$x]) & '|'
		Next
		StringLeft($Output, StringLen($Output) - 1)
		Return $Output
	EndFunc
	Func SelectVolume()
		GuiCreate('Select Drive', 150, 100,(@DesktopWidth-150)/2, (@DesktopHeight-100)/2, $WS_CAPTION)
		Local $Drive_List = GuiCtrlCreateCombo('', (150/2)- (110/2), 20, 110, 20)
			GUICtrlSetData($Drive_List, ListDrives())
		Local $Continue_Button = GuiCtrlCreateButton("OK", (150/4) - (60/4), 60, 40, 20)
		Local $Cancel_Button = GuiCtrlCreateButton("Cancel", 2*(150/4) + (60/4), 60, 40, 20)
		GuiSetState()
		While 1
			Switch(GuiGetMsg())
				Case $GUI_EVENT_CLOSE
					ContinueLoop
				Case $Cancel_Button
					Return 0
				Case $Continue_Button
					Local $Return = StringLeft(GUICtrlRead($Drive_List), StringInStr(GUICtrlRead($Drive_List), ':'))
					If Not StringLen($Return) Then $Return = -1
					If $Return = -1 Or DriveStatus($Return) = 'READY' Then
						GUIDelete()
						Return $Return
					EndIf
			EndSwitch
		WEnd
	EndFunc
	Func FindGUID($Drive)
		Local Const $DevList = 'HKLM\SYSTEM\MountedDevices'
		Local $i
		Do
			If RegRead($DevList, '\DosDevices\' & $Drive) = RegRead($DevList, RegEnumVal($DevList, $i)) Then Return StringReplace(RegEnumVal($DevList, $i), '\??\', '\\?\', 1)
			$i += 1
		Until 0
	EndFunc
#endregion
;;Mount Point MUST be empty Folder
If Not FileFindFirstFile($Mount_Dir & '\*') Then
	MsgBox(0, $Mount_Dir, 'Directory Not Empty')
	Exit
EndIf
;;Let's just make sure there is a folder by making one
DirCreate($Mount_Dir)
;;Select new volume to mount
$Drive_Letter = SelectVolume()
If Not $Drive_Letter And Not $Drive_Letter = -1 Then Exit
;;Unmount any existing devices from folder
$TestHandle = Run('mountvol ' & $Mount_Dir & ' /L', @SystemDir & '\', @SW_HIDE, 2)
If StdOutRead($TestHandle) <> 'The file or directory is not a reparse point.' Then
	$TestHandle = Run('mountvol ' & $Mount_Dir & ' /D', @SystemDir & '\', @SW_HIDE, 2)
	StdoutRead($TestHandle)
EndIf
If $Drive_Letter = -1 Then Exit ;;Just unmount drive
;;Select Device and mount selected device to folder
$TestHandle = Run('mountvol ' & $Mount_Dir & ' ' & FindGUID($Drive_Letter) & '\', @SystemDir & '\', @SW_HIDE, 2)
;;Waits to kill script until mountvol returns
StdOutRead($TestHandle)