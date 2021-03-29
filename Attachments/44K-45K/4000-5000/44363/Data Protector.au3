;~ Author:	Ian Maxwell (llewxam @ AutoIt forum)
;~ Build:	1.08 June 2014

;~ *******Change $FacingPassword to a value only known to yourself prior to first use!  DO NOT LEAVE IT AS "crypt" FOR PROPER SECURITY!
;~ Once you have set this value and created a data file, DO NOT CHANGE $FacingPassword AGAIN, or your data will become permanently unreadable and the
;~ script could even crash.  Reusing the same value and re-compiling if you make changes to this script is strongly recommended to preserve your data.

#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
#include <Crypt.au3>
#include <String.au3>
#include <GuiListView.au3>
#include <EditConstants.au3>
#include <GuiConstantsEx.au3>

Global Const $FacingPassword = "crypt"
Global $IniFile = @ScriptDir & "\data.prot"

Local $GUI = GUICreate("Data Protector", 500, 250)
GUISetBkColor(0xb2ccff, $GUI)
Local $List = GUICtrlCreateList("", 10, 10, 480, 200)
Local $AddItem = GUICtrlCreateButton("Add Item", 10, 210, 100, 30)
Local $OpenItem = GUICtrlCreateButton("Open Item", 200, 210, 100, 30)
Local $DelItem = GUICtrlCreateButton("Delete Item", 390, 210, 100, 30)
GUISetState(@SW_SHOW, $GUI)

_FillList()
Do
	Local $MSG = GUIGetMsg()
	Switch $MSG
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $AddItem
			_AddItem()
		Case $OpenItem
			_OpenItem()
		Case $DelItem
			_DeleteItemFromMain()
	EndSwitch
Until True == False
Exit


Func _FillList()
	GUICtrlSetData($List, "")
	Local $GetNames = IniReadSectionNames($IniFile)
	If IsArray($GetNames) Then
		For $a = 1 To $GetNames[0]
			Local $Grab = IniReadSection($IniFile, $GetNames[$a])
			GUICtrlSetData($List, BinaryToString(_Crypt_DecryptData($Grab[1][1], $FacingPassword, $CALG_RC4)))
		Next
	EndIf
EndFunc   ;==>_FillList


Func _AddItem()
	Local $AddGUI = GUICreate("Add Item", 400, 475)
	GUISetBkColor(0xb2ccff, $AddGUI)
	GUICtrlCreateLabel("Enter an item description", 10, 10, 380, 20)
	Local $AddDescription = GUICtrlCreateInput("", 10, 25, 380, 20)
	GUICtrlCreateLabel("Enter the item text", 10, 60, 380, 20)
	Local $AddText = GUICtrlCreateEdit("", 10, 75, 380, 250)
	GUICtrlCreateLabel("Enter the item password", 10, 345, 380, 20)
	Local $AddPassword = GUICtrlCreateInput("", 10, 360, 380, 15, $ES_PASSWORD)
	GUICtrlCreateLabel("Confirm the password", 10, 385, 380, 20)
	Local $ConfirmPassword = GUICtrlCreateInput("", 10, 400, 380, 15, $ES_PASSWORD)
	Local $Save = GUICtrlCreateButton("Save", 150, 435, 100, 30)
	GUISetState(@SW_SHOW, $AddGUI)

	Do
		$MSG = GUIGetMsg()
		Switch $MSG
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $Save
				Local $GetDescription = GUICtrlRead($AddDescription)
				If $GetDescription == "" Then
					MsgBox(48, "ERROR", "You must enter a description.")
				Else
					Local $Used = False
					Local $GetNames = IniReadSectionNames($IniFile)
					If IsArray($GetNames) Then
						For $a = 1 To $GetNames[0]
							Local $Grab = IniReadSection($IniFile, $GetNames[$a])
							If $GetDescription == BinaryToString(_Crypt_DecryptData($Grab[1][1], $FacingPassword, $CALG_RC4)) Then $Used = True
						Next
					EndIf
					If $Used == True Then
						MsgBox(48, "ERROR", "There is already an item with that description.")
					Else
						Local $GetData = GUICtrlRead($AddText)
						If $GetData == "" Then
							MsgBox(48, "ERROR", "You have not entered any data yet.")
						Else
							Local $GetPassword = GUICtrlRead($AddPassword)
							Local $GetPasswordConfirmation = GUICtrlRead($ConfirmPassword)
							If $GetPassword <> $GetPasswordConfirmation Then
								MsgBox(48, "ERROR", "Your passwords do not match!")
							Else
								If $GetPassword == "" Then
									MsgBox(48, "ERROR", "You can not use a blank password.")
								Else
									$GetNames = IniReadSectionNames($IniFile)
									If IsArray($GetNames) Then
										Do
											Local $SectionName = Random(100000, 999999, 1)
											Local $SearchForDuplicate = _ArraySearch($GetNames, $SectionName, 0, 0, 0, 0, 1, 1)
										Until $SearchForDuplicate == -1
									Else
										$SectionName = Random(100000, 999999, 1)
									EndIf
									_Update($GetData, $GetPassword, $SectionName, $GetDescription)
									ExitLoop
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
		EndSwitch
	Until True == False
	GUIDelete($AddGUI)
	_FillList()
EndFunc   ;==>_AddItem


Func _Update($uGetData, $uGetPassword, $uSectionName, $uGetDescription)
	Local $uData = _Crypt_EncryptData($uGetData, $uGetPassword, $CALG_RC4)
	Local $uHash = _Crypt_HashData($uGetPassword, $CALG_MD5)
	Local $uDataWrite = _Crypt_EncryptData($uHash & Chr(230) & $uData, $FacingPassword, $CALG_RC4)
	IniWrite($IniFile, $uSectionName, "Description", _Crypt_EncryptData($uGetDescription, $FacingPassword, $CALG_RC4))
	IniWrite($IniFile, $uSectionName, "Data", $uDataWrite)
EndFunc   ;==>_Update


Func _OpenItem()
	Local $oListText = GUICtrlRead($List)
	If $oListText == "" Then
		MsgBox(48, "ERROR", "Please select an item.")
	Else
		Local $oGetPassword = InputBox("Password", "Enter the item's password", "", "*", 350)
		Local $oSectionName
		Local $oGetNames = IniReadSectionNames($IniFile)
		For $a = 1 To $oGetNames[0]
			Local $oGetDescription = IniReadSection($IniFile, $oGetNames[$a])
			If $oListText == BinaryToString(_Crypt_DecryptData($oGetDescription[1][1], $FacingPassword, $CALG_RC4)) Then $oSectionName = $oGetNames[$a]
		Next
		Local $oGetSection = IniReadSection($IniFile, $oSectionName)
		Local $oGetData = $oGetSection[2][1]
		Local $oInitialDecrypt = BinaryToString(_Crypt_DecryptData($oGetData, $FacingPassword, $CALG_RC4))
		Local $oBreak = StringSplit($oInitialDecrypt, Chr(230))
		Local $oHash = _Crypt_HashData($oGetPassword, $CALG_MD5)

		If $oHash == $oBreak[1] Then
			Local $OpenGUI = GUICreate("Data", 400, 310)
			GUISetBkColor(0xb2ccff, $OpenGUI)
			Local $oDecryptData = BinaryToString(_Crypt_DecryptData($oBreak[2], $oGetPassword, $CALG_RC4))
			Local $ShowData = GUICtrlCreateEdit($oDecryptData, 10, 10, 380, 250)
			Local $UpdateItem = GUICtrlCreateButton("Update Item", 10, 270, 100, 30)
			Local $ChangePassword = GUICtrlCreateButton("Change Password", 150, 270, 100, 30)
			Local $DeleteItem = GUICtrlCreateButton("Delete Item", 290, 270, 100, 30)
			GUISetState(@SW_SHOW, $OpenGUI)
			Send("{DOWN}")

			Do
				$MSG = GUIGetMsg()
				Switch $MSG
					Case $GUI_EVENT_CLOSE
						GUIDelete($OpenGUI)
						ExitLoop
					Case $UpdateItem
						Local $VerifyPassword = InputBox("Password", "Enter the item's password", "", "*", 350)
						If $VerifyPassword == $oGetPassword Then
							_Update(GUICtrlRead($ShowData), $oGetPassword, $oSectionName, $oListText)
							MsgBox(64, "Item Updated", "The item has been updated.")
						Else
							MsgBox(48, "ERROR", "The passwords do not match")
						EndIf
					Case $ChangePassword
						$VerifyPassword = InputBox("Password", "Enter the item's current password", "", "*", 350)
						If $VerifyPassword == $oGetPassword Then
							Local $GetNewPassword1 = InputBox("Password", "Enter the new password", "", "*", 350)
							Local $GetNewPassword2 = InputBox("Password", "Confirm the new password", "", "*", 350)
							If $GetNewPassword1 == $GetNewPassword2 Then
								$oGetPassword = $GetNewPassword1
								_Update($oDecryptData, $oGetPassword, $oSectionName, $oListText)
								MsgBox(64, "Password Changed", "Your password for this item has been changed.")
							Else
								MsgBox(48, "ERROR", "The passwords do not match")
							EndIf
						Else
							MsgBox(48, "ERROR", "You have not provided the correct password!")
						EndIf
					Case $DeleteItem
						$VerifyPassword = InputBox("Password", "Enter the item's password", "", "*", 350)
						If $VerifyPassword == $oGetPassword Then
							Local $YesOrNo = MsgBox(4, "Confirm Delete", "Are you sure you want to delete this item?")
							If $YesOrNo == 6 Then
								GUIDelete($OpenGUI)
								IniDelete($IniFile, $oSectionName)
								_FillList()
								ExitLoop
							EndIf
						Else
							MsgBox(48, "ERROR", "You have not provided the correct password!")
						EndIf
				EndSwitch
			Until True == False
		Else
			MsgBox(48, "ERROR", "You have not provided the correct password!")
		EndIf
	EndIf
EndFunc   ;==>_OpenItem


Func _DeleteItemFromMain()
	Local $oGetPassword = InputBox("Password", "Enter the item's password", "", "*", 350)
	Local $oSectionName
	Local $oListText = GUICtrlRead($List)
	Local $oGetNames = IniReadSectionNames($IniFile)
	For $a = 1 To $oGetNames[0]
		Local $oGetDescription = IniReadSection($IniFile, $oGetNames[$a])
		If $oListText == BinaryToString(_Crypt_DecryptData($oGetDescription[1][1], $FacingPassword, $CALG_RC4)) Then $oSectionName = $oGetNames[$a]
	Next
	Local $oGetSection = IniReadSection($IniFile, $oSectionName)
	Local $oGetData = $oGetSection[2][1]
	Local $oInitialDecrypt = BinaryToString(_Crypt_DecryptData($oGetData, $FacingPassword, $CALG_RC4))
	Local $oBreak = StringSplit($oInitialDecrypt, Chr(230))
	Local $oHash = _Crypt_HashData($oGetPassword, $CALG_MD5)

	If $oHash == $oBreak[1] Then
		Local $YesOrNo = MsgBox(4, "Confirm Delete", "Are you sure you want to delete this item?")
		If $YesOrNo == 6 Then
			IniDelete($IniFile, $oSectionName)
			_FillList()
		EndIf
	Else
		MsgBox(48, "ERROR", "You have not provided the correct password!")
	EndIf
EndFunc   ;==>_DeleteItemFromMain
