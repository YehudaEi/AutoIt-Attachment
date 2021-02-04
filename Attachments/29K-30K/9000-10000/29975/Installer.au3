#include <GUIConstantsEx.au3>
; Autoit Organize Includes Installer

#region Compiler directives section
#AutoIt3Wrapper_res_language=1031
#AutoIt3Wrapper_icon =C:\Downloads\Icons\Agent.ico
#AutoIt3Wrapper_res_legalcopyright =Xenobiologist
#AutoIt3Wrapper_res_description=Organize Includes
#AutoIt3Wrapper_res_comment=Let Scite organize your Autoit includes
#AutoIt3Wrapper_outfile_type=exe
#AutoIt3Wrapper_compression=4                	  ;Compression parameter 0-4  0=Low 2=normal 4=High
#AutoIt3Wrapper_res_field=Developer|Xenobiologist
#AutoIt3Wrapper_res_field=Release Datum|%date% %time%
#AutoIt3Wrapper_res_field=Original filename|Installer.exe
#AutoIt3Wrapper_res_field=Version|4.3
#AutoIt3Wrapper_res_fileversion=1.0
#AutoIt3Wrapper_res_fileversion_autoincrement=N
#endregion Compiler directives section

$GUI = GUICreate("Organize Includes Installer", 169, 142, 193, 125)
GUICtrlCreateGroup("Menu", 5, 5, 160, 135)
GUICtrlCreateLabel("Autoit installed", 15, 30, 97, 17)
$autoit_CB = GUICtrlCreateCheckbox("", 130, 30, 20, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("SciTE installed", 15, 80, 98, 17)
$scite_CB = GUICtrlCreateCheckbox("", 130, 80, 20, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$start_B = GUICtrlCreateButton("Start", 10, 105, 145, 25, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

Global $installDir = 0

If _checkAutoit() = 1 Then GUICtrlSetState($autoit_CB, $GUI_CHECKED)
If _checkScite() = 1 Then GUICtrlSetState($scite_CB, $GUI_CHECKED)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $start_B
			If ProcessExists('SciTE.exe') Then ProcessClose('SciTE.exe')
			If _checkAutoit() = 1 Then GUICtrlSetState($autoit_CB, $GUI_CHECKED)
			If _checkScite() = 1 Then GUICtrlSetState($scite_CB, $GUI_CHECKED)
			If _getCheckboxState($autoit_CB) And _
					_getCheckboxState($scite_CB) Then
				GUIDelete($GUI)
				SplashTextOn('Information', 'Ready to Install', 300, 30, 0, 0, 32)
				Sleep(2000)
				SplashOff()
				_start()
				SplashTextOn('Information', 'Press CTRL+ALT+SHIFT+I in Scite', 300, 30, 0, 0, 32)
				Sleep(2000)
				SplashOff()
				ShellExecute('SciTE.exe')
			EndIf
			Exit (0)
	EndSwitch
WEnd

Func _getCheckboxState($controlID)
	Return BitAND(GUICtrlRead($controlID), $GUI_CHECKED)
EndFunc   ;==>_getCheckboxState

Func _checkAutoit()
	$installDir = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir')
	If $installDir = '' Then Return -1
	If @AutoItVersion < '3.2.12.0' Then Return -1
	Return 1
EndFunc   ;==>_checkAutoit

Func _checkScite()
	If Not FileExists($installDir & '\SciTE') Then Return -1
	Return 1
EndFunc   ;==>_checkScite

Func _start()
	If DirCreate($installDir & '\SciTE\OrganizeIncludes\') Then
		FileInstall('.\OrganizeIncludes\OI_1.0.0.50.au3', $installDir & '\SciTE\OrganizeIncludes\OI_1.0.0.50.au3', 1)
		FileInstall('.\OrganizeIncludes\OI_help.pdf', $installDir & '\SciTE\OrganizeIncludes\OI_help.pdf', 1)
		FileInstall('.\OrganizeIncludes\OI-Icons.dll', $installDir & '\SciTE\OrganizeIncludes\OI-Icons.dll', 1)
		If FileExists(@UserProfileDir & '\SciTEUser.properties') Then
			Switch MsgBox(35, 'Question', 'Do you want to install/overwrite SciTEUser.properties?', 15)
				Case 6 ; Yes
					FileInstall('.\OrganizeIncludes\SciTEUser.properties', @UserProfileDir & '\SciTEUser.properties', 1)
				Case 7 ; No
					Return
				Case 2 ; Cancel
					MsgBox(64, 'Information', 'Installation aborted', 10)
					Exit (0)
			EndSwitch
		Else
			FileInstall('.\OrganizeIncludes\SciTEUser.properties', @UserProfileDir & '\SciTEUser.properties', 1)
		EndIf
	EndIf
EndFunc   ;==>_start