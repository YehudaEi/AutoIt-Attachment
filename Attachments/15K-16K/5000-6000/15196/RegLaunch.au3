#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Reg.ico
#AutoIt3Wrapper_outfile=RegLaunch.exe
#AutoIt3Wrapper_Res_Comment=                                   
#AutoIt3Wrapper_Res_Description=RegLaunch
#AutoIt3Wrapper_Res_Fileversion=0.5.4.0
#AutoIt3Wrapper_Res_LegalCopyright=©2007 Michael Michta
#AutoIt3Wrapper_Run_cvsWrapper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("WinTitleMatchMode", 4)
#include <A3LTreeView.au3>
Dim $sKey = StringTrimLeft(RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit", "LastKey"), 12)
Switch $CmdLine[0]
	Case 0
		While 1
			$sKey = InputBox("RegLaunch", "Key?", $sKey)
			If @error Then Exit
			$sKey = ReplaceA($sKey)
			If Not KeyExists($sKey) Then
				MsgBox(0, "RegLaunch", "Error:Key Not Found")
				ContinueLoop
			EndIf
			ExitLoop
		WEnd
	Case 1
		$sKey = ReplaceA($CmdLine[1])
		If Not KeyExists($sKey) Then
			MsgBox(0, "RegLaunch", "Error:Key Not Found")
			Exit
		EndIf
	Case Else
		Exit
EndSwitch
ProcessClose(WinGetProcess("[CLASS:RegEdit_RegEdit]"))
ProcessWaitClose("RegEdit.exe")
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit", "LastKey", "REG_SZ", "My Computer\" & $sKey)
Run("RegEdit.exe")


Func ReplaceA($sString)
	$sLeft = StringLeft($sString, 4)
	$sRight = StringTrimLeft($sString, 4)
	If $sLeft = "HKLM" Then Return "HKEY_LOCAL_MACHINE" & $sRight
	If $sLeft = "HKCU" Then Return "HKEY_CURRENT_USER" & $sRight
	If $sLeft = "HKCR" Then Return "HKEY_CLASSES_ROOT" & $sRight
	If $sLeft = "HKCC" Then Return "HKEY_CURRENT_CONFIG" & $sRight
	Return $sString
EndFunc   ;==>ReplaceA

Func KeyExists($sKey)
	RegRead($sKey, "")
	If @error = 1 Or @error = 2 Or @error = 3 Then Return 0
	Return 1
EndFunc   ;==>KeyExists