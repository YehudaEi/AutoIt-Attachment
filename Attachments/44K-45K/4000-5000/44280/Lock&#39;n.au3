#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#pragma compile(UPX, False)
#pragma compile(icon, "Lock'n.ico")
#pragma compile(CompanyName, "d3monCorp")
#pragma compile(FileVersion, 1.3)
#pragma compile(LegalCopyright, "d3mon Corporation. All rights reserved.")

;CONFIG VARS
Global Const $__ENCRYPTPASSWORD = "1234", $__DEFAULTPW = "toto"

#NoTrayIcon
#RequireAdmin

#include <File.au3>
#include <String.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <EditConstants.au3>

Opt("GUIOnEventMode", 1)

Global $iObjType = -1
Global Enum $__OBJTYPE_FILE, $__OBJTYPE_FOLDER

Global Const $__PWFILE = "lockn.txt"

If FileExists(@SystemDir & "\" & $__PWFILE) = 0 Then
	FileWrite(@SystemDir & "\" & $__PWFILE, _StringEncrypt(1, $__DEFAULTPW, $__ENCRYPTPASSWORD, 3))
	FileSetAttrib(@SystemDir & "\" & $__PWFILE, "+H")
EndIf

If $CmdLine[0] = 0 Then
	ConsoleWrite('!>Command line' & @CRLF)
	Exit 1
EndIf

#Region GUI
Global $hGUI = GUICreate("Lock'n", 200, 130)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUICtrlCreateLabel("Password :", 5, 7, 85)
GUICtrlSetFont(-1, 12, 400, 1, "Arial")

Global $iInputPw = GUICtrlCreateInput("", 90, 7, 105, 20, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))

GUICtrlCreateGroup("Apply to...", 5, 30, 190, 60)
Global $iCbFile = GUICtrlCreateCheckbox("File", 15, 45)
Global $iCbSubFiles = GUICtrlCreateCheckbox("Sub files", 95, 45)

Global $iCbFolder = GUICtrlCreateCheckbox("Folder", 15, 65)
Global $iCbSubFolders = GUICtrlCreateCheckbox("Sub folders", 95, 65)

Global $iBtnToggleLock = GUICtrlCreateButton("", 60, 100, 80, 22)
GUICtrlSetOnEvent($iBtnToggleLock, "_Lock")

Global $iLabelCurrFile = GUICtrlCreateLabel("Current file :", 5, 105, 60, 17)
GUICtrlSetState($iLabelCurrFile, $GUI_HIDE)

Global $iLabelObj = GUICtrlCreateLabel("", 65, 105, 125, 17)
GUICtrlSetState($iLabelObj, $GUI_HIDE)

;~ GUISetState(@SW_SHOW, $hGUI)
#EndRegion GUI

#Region GUI_2
Global $hGUI_2 = GUICreate("Lock'n - Password", 255, 100)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUICtrlCreateLabel("Current password :", 5, 7, 135)
GUICtrlSetFont(-1, 12, 400, 1, "Arial")

Global $iInputCurrPw = GUICtrlCreateInput("", 145, 7, 105, 20, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))

GUICtrlCreateLabel("New password :", 5, 35, 135)
GUICtrlSetFont(-1, 12, 400, 1, "Arial")

Global $iInputNewPw = GUICtrlCreateInput("", 145, 35, 105, 20, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))

GUICtrlCreateButton("Apply", 88, 70, 80, 22)
GUICtrlSetOnEvent(-1, "_Apply")
#EndRegion GUI_2

If StringInStr($CmdLine[1], "/cm-Create") > 0 Then
	RegWrite("HKEY_CLASSES_ROOT\AllFilesystemObjects\shell") ;Create ContextMenu for files/folders
	RegWrite("HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\Un/Lock'n !")
	RegWrite("HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\Un/Lock'n !\command")
	RegWrite("HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\Un/Lock'n !\command", "", "REG_SZ", @ScriptFullPath & " %1")
	_Exit()
ElseIf StringInStr($CmdLine[1], "/cm-Remove") > 0 Then
	RegDelete("HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\Un/Lock'n !")
	_Exit()
ElseIf StringInStr($CmdLine[1], "/password") > 0 Then
	GUISetState(@SW_SHOW, $hGUI_2)
ElseIf StringInStr($CmdLine[1], "/st-Restore") > 0 Then
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")
ElseIf StringInStr($CmdLine[1], "/st-Remove") > 0 Then
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoSecurityTab", "REG_DWORD", '1')
Else ;ContextMenu event
	Local $fLocked = _IsLocked($CmdLine[1])

	If @extended Then
		GUICtrlSetState($iCbFolder, $GUI_CHECKED)
		GUICtrlSetState($iCbFile, $GUI_DISABLE)

		If Not $fLocked Then
			GUICtrlSetData($iBtnToggleLock, "Lock")
		Else
			GUICtrlSetState($iCbFolder, $GUI_DISABLE)
			GUICtrlSetData($iBtnToggleLock, "Unlock")
		EndIf

		$iObjType = $__OBJTYPE_FOLDER
	Else
		GUICtrlSetState($iCbFolder, $GUI_DISABLE)
		GUICtrlSetState($iCbSubFolders, $GUI_DISABLE)
		GUICtrlSetState($iCbSubFiles, $GUI_DISABLE)
		GUICtrlSetState($iCbFile, $GUI_CHECKED)
		GUICtrlSetState($iCbFile, $GUI_DISABLE)

		If Not $fLocked Then
			GUICtrlSetData($iBtnToggleLock, "Lock")
		Else
			GUICtrlSetData($iBtnToggleLock, "Unlock")
		EndIf

		$iObjType = $__OBJTYPE_FILE
	EndIf

	GUISetState(@SW_SHOW, $hGUI)
EndIf

While 1
	Sleep(250)
WEnd

Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func _Lock()
	Local $sCurrPw = _StringEncrypt(0, FileRead(@SystemDir & "\" & $__PWFILE), $__ENCRYPTPASSWORD, 3)
	If GUICtrlRead($iInputPw) <> $sCurrPw Then
		MsgBox($MB_ICONWARNING, "Lock'n", "Wrong password !")
		Return 0
	EndIf

	GUICtrlSetState($iBtnToggleLock, $GUI_HIDE)
	GUICtrlSetState($iLabelObj, $GUI_SHOW)
	GUICtrlSetState($iLabelCurrFile, $GUI_SHOW)

	GUISetState(@SW_DISABLE, $hGUI)

	Local $fLocked = _IsLocked($CmdLine[1])

	If $iObjType = $__OBJTYPE_FOLDER Then
		Local $iSubFilesRead = GUICtrlRead($iCbSubFiles)
		Local $iSubFoldersRead = GUICtrlRead($iCbSubFolders)

		Local $aFiles = 0

		If $fLocked Then
			;unlock the target folder
			GUICtrlSetData($iLabelObj, $CmdLine[1])
			_UnlockObject($CmdLine[1])

			If $iSubFilesRead = $GUI_CHECKED Or $iSubFoldersRead = $GUI_CHECKED Then
				$aFiles = _FileListToArray($CmdLine[1], "*", (($iSubFoldersRead = $GUI_CHECKED) ? (($iSubFilesRead = $GUI_CHECKED) ? 0 : 2) : 1))
				For $i = 1 To $aFiles[0]
					GUICtrlSetData($iLabelObj, $aFiles[$i])
					_UnlockObject($CmdLine[1] & "\" & $aFiles[$i])
				Next
			EndIf

			ShellExecute("explorer.exe", $CmdLine[1])
		Else
			Local $iFolderRead = GUICtrlRead($iCbFolder)

			If $iFolderRead = $GUI_CHECKED Then
				;lock the target folder
				GUICtrlSetData($iLabelObj, $CmdLine[1])
				_LockObject($CmdLine[1])
			EndIf

			If $iSubFilesRead = $GUI_CHECKED Or $iSubFoldersRead = $GUI_CHECKED Then
				$aFiles = _FileListToArray($CmdLine[1], "*", (($iSubFoldersRead = $GUI_CHECKED) ? (($iSubFilesRead = $GUI_CHECKED) ? 0 : 2) : 1))
				For $i = 1 To $aFiles[0]
					GUICtrlSetData($iLabelObj, $aFiles[$i])
					_LockObject($CmdLine[1] & "\" & $aFiles[$i])
				Next
			EndIf
		EndIf
	ElseIf $iObjType = $__OBJTYPE_FILE Then
		If $fLocked Then
			_UnlockObject($CmdLine[1])
		Else
			_LockObject($CmdLine[1])
		EndIf
	EndIf

	GUIDelete($hGUI)
	_Exit()
EndFunc   ;==>_Lock

Func _Apply()
	Local $sCurrPw = _StringEncrypt(0, FileRead(@SystemDir & "\" & $__PWFILE), $__ENCRYPTPASSWORD, 3)

	If GUICtrlRead($iInputCurrPw) <> $sCurrPw Then
		MsgBox($MB_ICONWARNING, "Lock'n", "Wrong password !")
		Return 0
	EndIf

	Local $sNewPw = _StringEncrypt(1, GUICtrlRead($iInputNewPw), $__ENCRYPTPASSWORD, 3)
	FileDelete(@SystemDir & "\" & $__PWFILE)
	FileWrite(@SystemDir & "\" & $__PWFILE, $sNewPw)
;~ 	_FileWriteToLine(@SystemDir & "\" & $__PWFILE, 1, $sNewPw, 1)

	MsgBox($MB_ICONINFORMATION, "Lock'n", "New password saved !")

	GUIDelete($hGUI_2)
	_Exit()
EndFunc   ;==>_Apply

Func _LockObject($sObj)
	If FileExists($sObj) = 0 Then Return SetError(1, 0, -1)
	RunWait('"' & @ComSpec & '" /c cacls.exe "' & $sObj & '" /E /P "' & @UserName & '":N', '', @SW_HIDE)
EndFunc   ;==>_LockObject

Func _UnlockObject($sObj)
	If FileExists($sObj) = 0 Then Return SetError(1, 0, -1)
	RunWait('"' & @ComSpec & '" /c cacls.exe "' & $sObj & '" /E /P "' & @UserName & '":F', '', @SW_HIDE)
EndFunc   ;==>_UnlockObject

Func _IsLocked($sObj)
	Local $hFile = 0

	If StringInStr(FileGetAttrib($sObj), 'D') > 0 Then
		$hFile = FileFindFirstFile($sObj & "\*.*")
		If $hFile = -1 Then Return SetExtended(1, True)
		FileClose($hFile)

		Return SetExtended(1, False)
	EndIf

	$hFile = FileOpen($sObj, $FO_READ)
	If $hFile = -1 Then Return True
	FileClose($hFile)

	Return False
EndFunc