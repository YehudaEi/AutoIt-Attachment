#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_icon=notebook.ico
#AutoIt3Wrapper_outfile=Journal.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#region *** SETUP ***
#noTrayIcon
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <GuiTab.au3>
#include <Misc.au3>
#include <String.au3>
#Include <File.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

_Singleton('Journal')

Opt('GUIOnEventMode', 1)

Global $chkPasswordEntrance, $txtPassword, $txtPasswordConfirm ;Entrance
Global $txtOld, $txtNew, $txtNewConfirm, $chkPasswordProtection ;Options
Global $gui, $guiDate, $txtEdit, $tab ;Main GUI

$lastDate = ''
$lastTab = 'Entry 1'
$numTabs = 1
$instructions = 'When switching computer your password will be forced to create a new passwordon the new computer.' & _
	'If you intend to use your old entries your new password MUST be the same as it was on your old computer in order to read your old entries.' & _
	@CRLF & @CRLF & 'To setup this application on new computer simply copy the "Journal.exe" file and the "Entries" folder and place them anywhere (in the same directory) on your new computer.'
	
$passwordEnabled = RegRead('HKEY_CURRENT_USER\Software\Journal', 'Password Protected')
$password = _StringEncrypt(0, RegRead('HKEY_CURRENT_USER\Software\Journal', 'Password'), 'confidential')

If Not FileExists(@ScriptDir & '\Entries') then 
	DirCreate(@ScriptDir & '\Entries')
EndIf

If $password = '' and $passwordEnabled = '' then 
	_Entrance() 
	$showGUI = False
Else 
	$passwordEnabled = ($passwordEnabled = 'True')
	$showGUI = True
EndIf 

If $passwordEnabled then 
	$try = InputBox('Journal', 'Welcome!' & @CRLF & 'Please verify your password:', '', '*', 200, 135) 
	If @error then Exit
	If $try <> $password then 
		Msgbox(16, 'Access Denied!', 'Incorrect password entered.')
		Exit
	EndIf
	
	If @error or ($password = '' and $passwordEnabled = True) then Exit
EndIf 

If $showGUI then 
	_MainGUI()
EndIf

While 1
	Sleep(100)
WEnd
#endregion 
#region *** ACTION EVENTS ***
Func _AddEntry() 
	If _IsEmpty() then 
		Msgbox(48, 'Error', 'You must write something in the open entry before adding a new entry.')
		Return
	EndIf 
	
	_SaveOpen()
	$numTabs += 1	
	GuiCtrlCreateTabItem('Entry ' & $numTabs)
	_GUICtrlTab_SetCurSel($tab, $numTabs - 1)
	GuiCtrlSetData($txtEdit, '')
	GuiCtrlSetState($txtEdit, $GUI_FOCUS)
	$lastTab = 'Entry ' & $numTabs
EndFunc 	
	
Func _ChangeDate()
	If _IsEmpty() then 
		_Delete()
	Else
		_SaveOpen()
	EndIf
	
	$lastDate = _GetDate()
	
	$index = 1

	While FileExists(@ScriptDir & '\Entries\' & $lastDate & '-Entry ' & $index & '.txt')
		If _GUICtrlTab_FindTab($tab, 'Entry ' & $index) = -1 then 
			GuiCtrlCreateTabItem('Entry ' & $index) 
		EndIf
		$index += 1
	WEnd

	For $i = 1 to $numTabs - $index + 1
		$size =  _GuiCtrlTab_GetItemCount($tab)
		If $size > 1 then _GUICtrlTab_DeleteItem($tab, _GuiCtrlTab_GetItemCount($tab) -1)
	Next
	
	_GUICtrlTab_SetCurSel($tab, 0)
	$lastTab = 'Entry 1'
	$numTabs = _GuiCtrlTab_GetItemCount($tab)
	
	GuiCtrlSetData($txtEdit, _Load($lastDate & '-Entry 1'))
	GuiCtrlSetState($txtEdit, $GUI_FOCUS)
EndFunc

Func _ChangeTab()
	If _IsEmpty() then 
		_Delete() 
	Else 
		_SaveOpen()
	EndIf
	$temp = _Load($lastDate & '-' & _GetCurTab())
	GuiCtrlSetData($txtEdit, $temp)
	GuiCtrlSetState($txtEdit, $GUI_FOCUS)
	$lastTab = _GetCurTab()
EndFunc

Func _Exit()
	If _IsEmpty() then 
		_Delete()
	Else 
		_SaveOpen()
	EndIf 
	
	Exit 
EndFunc

Func _Options()
	GuiSetState(@SW_DISABLE, $gui)
	GUICreate('Options', 320, 338)
		GuiSetOnEvent($GUI_EVENT_CLOSE, '_Close')
		
	GUICtrlCreateGroup('Change Password', 5, 10, 310, 130)
		$chkPasswordProtection = GUICtrlCreateCheckbox('Enable password protection', 20, 30, 200, 20)
			If $passwordEnabled then GUICtrlSetState(-1, $GUI_CHECKED)
		
		GUICtrlCreateLabel('Enter old password:', 20, 55, 120, 20, $SS_CENTERIMAGE)
			$txtOld = GUICtrlCreateInput('', 150, 55, 150, 21, $ES_PASSWORD)
				If Not $passwordEnabled then GuiCtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel('Enter new  password:', 20, 80, 120, 20, $SS_CENTERIMAGE)
			$txtNew = GUICtrlCreateInput('', 150, 80, 150, 21, $ES_PASSWORD)
				If Not $passwordEnabled then GuiCtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel('Confirm new password:', 20, 105, 120, 20, $SS_CENTERIMAGE)
			$txtNewConfirm = GUICtrlCreateInput('', 150, 105, 150, 21, $ES_PASSWORD)	
				If Not $passwordEnabled then GuiCtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup('Switching Computers', 5, 150, 310, 150)
		GUICtrlCreateLabel($instructions, 15, 170, 290, 121)
		
	$btnOk = GUICtrlCreateButton('OK', 104, 305, 100, 24)
		GuiCtrlSetOnEvent(-1, '_SetPassword')
	$btnCancel = GUICtrlCreateButton('Cancel', 214, 305, 100, 24)
		GUICtrlSetOnEvent(-1, '_Close')
		
	GUIRegisterMsg($WM_COMMAND, 'MY_WM_COMMAND')		
	GUISetState()
EndFunc

Func _Close()
	GuiDelete()
	GuiSetState(@SW_ENABLE, $gui)
EndFunc

Func _SetPassword()
	$tempPasswordEnabled = $passwordEnabled
	
	If GuiCtrlRead($chkPasswordProtection) <> $GUI_CHECKED then 
		If GuiCtrlRead($txtOld) <> $password and $tempPasswordEnabled then 
			Msgbox(48, 'Warning', 'You must know the old password in order to disable password protection.')
			GuiCtrlSetState($txtOld, $GUI_FOCUS)
			Return 
		EndIf
		
		$tempPasswordEnabled = False 
		RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password Protected', 'REG_SZ', 'False')
		RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password', 'REG_SZ', '')
	Else 	
		$tempPasswordEnabled = True 
		RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password Protected', 'REG_SZ', 'True')
		
		If GuiCtrlRead($txtOld) <> $password then 
			Msgbox(48, 'Warning', 'You entered the incorrect password.')
			GuiCtrlSetState($txtOld, $GUI_FOCUS)
			Return
		EndIf 
		
		If GuiCtrlRead($txtNew) <> GuiCtrlRead($txtNewConfirm) then 
			Msgbox(48, 'Warning', 'Your two entries of your new password do not match.')
			Return
		EndIf 
		
		If GuiCtrlRead($txtNew) = $password then 
			Return 
		EndIf
		
		If GuiCtrlRead($txtNew) = '' then 
			Msgbox(48, 'Warning', 'You must enter a new password.')
		EndIf
	EndIf 
	
	$newPassword = GuiCtrlRead($txtNew)
	
	$files = _FileListToArray(@ScriptDir & '\Entries', '*.txt', 1)
	
	$progress = $files[0] > 50
	
	If $progress then ProgressOn('Journal - Changing Password', 'Re-encoding your files...')
	
	For $i = 1 to $files[0]
		$data = _Load(StringTrimRight($files[$i], 4)) 
		
;~ 		Msgbox(0, $passwordEnabled, $newPassword & @CRLF & $data)
		If $tempPasswordEnabled then 
			$data = _StringEncrypt(1, $data, $newPassword)
		EndIf 
		
		$file = FileOpen(@ScriptDir & '\Entries\' & $files[$i], 2) 
		FileWriteLine($file, $data)
		FileClose($file)
		
		If $progress then ProgressSet($i * (100 / $files[0]))
	Next
	
	RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password', 'REG_SZ', _StringEncrypt(1, $newPassword, 'confidential'))
	$password = $newPassword 
	$passwordEnabled = $tempPasswordEnabled
	
	If $progress then ProgressOff()
	
	GUIDelete()
	GuiSetState(@SW_SHOW, $gui)
	GuiSetState(@SW_ENABLE, $gui)
EndFunc

Func _Entrance()
	GUICreate('Welcome', 265, 165)
		GuiSetOnEvent($GUI_EVENT_CLOSE, '_ExitI')
		
	GUICtrlCreateLabel('It appears as if you are a first time user.' & @CRLF & 'Would you like you entries to be password protected?', 5, 5, 270, 30)
	$chkPasswordEntrance = GUICtrlCreateCheckbox('Enable password protection', 5, 40, 160, 20)
		GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateLabel('Enter your password:', 15, 67, 116, 20, $SS_CENTERIMAGE)
		$txtPassword = GUICtrlCreateInput('', 135, 67, 120, 21, $ES_PASSWORD)
	GUICtrlCreateLabel('Confirm your password:', 15, 95, 116, 20, $SS_CENTERIMAGE)
		$txtPasswordConfirm = GUICtrlCreateInput('', 135, 95, 120, 21, $ES_PASSWORD)
		
	$btnOkEntrance = GUICtrlCreateButton('OK', 45, 130, 100, 25)
		GuiCtrlSetOnEvent(-1, '_EntranceOK')
	$btnCancelEntrance = GUICtrlCreateButton('Cancel', 155, 130, 100, 25)
		GuiCtrlSetOnEvent(-1, '_ExitI')
	GUIRegisterMsg($WM_COMMAND, 'MY_WM_COMMAND')
	GUISetState()
EndFunc 

Func _EntranceOK()
	If GuiCtrlRead($chkPasswordEntrance) = $GUI_CHECKED then 
		If GuiCtrlRead($txtPassword) <> GuiCtrlRead($txtPasswordConfirm) then 
			Msgbox(48, 'Warning', 'The passwords you entered do not match.')
			Return 
		EndIf 
		
		If GuiCtrlRead($txtPassword) = '' then 
			Msgbox(48, 'Warning', 'You must enter a password or disable password protection')
			Return 
		EndIf
		
		RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password', 'REG_SZ', _StringEncrypt(1, GuiCtrlRead($txtPassword), 'confidential'))
		RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password Protected', 'REG_SZ', 'True')
		$password = GuiCtrlRead($txtPassword) 
		$passwordEnabled = True 
	Else 
		$passwordEnabled = False 
		RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password Protected', 'REG_SZ', 'False')
		RegWrite('HKEY_CURRENT_USER\Software\Journal', 'Password', 'REG_SZ', '')
	EndIf 
	GuiDelete() 
	
	_MainGUI()
EndFunc

Func _ExitI()
	Exit 
EndFunc

Func _MainGUI()
	$gui = GUICreate('Journal', 590, 365, 228, 214)
		GuiSetOnEvent($GUI_EVENT_CLOSE, '_Exit')
		
	GUICtrlCreateLabel('Select a date:', 10, 10, 78, 21, $SS_CENTERIMAGE)
	$guiDate = GUICtrlCreateDate(@YEAR & '/' & @MON & '/' & @MDAY, 96, 8, 210, 21)
		GUICtrlSetOnEvent(-1, '_ChangeDate')
	GuiCtrlCreateButton('Add Entry', 369, 7, 100, 23) 
		GUICtrlSetOnEvent(-1, '_AddEntry')
	GuiCtrlCreateButton('Options', 479, 7, 100, 23) 
		GUICtrlSetOnEvent(-1, '_Options')

	$txtEdit = GUICtrlCreateEdit('', 20, 65, 550, 280)

	$tab = GUICtrlCreateTab(10, 35, 570, 320)
		GUICtrlSetOnEvent(-1, '_ChangeTab')
	GUICtrlCreateTabItem('Entry 1')

	GuiCtrlSetState($txtEdit, $GUI_ONTOP)

	_ChangeDate()
	GUIRegisterMsg($WM_COMMAND, '')
	GUISetState()
EndFunc
#endregion
#region *** HELPER FUNCTIONS ***
Func MY_WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    $nNotifyCode = BitShift($wParam, 16)
    $nID = BitAND($wParam, 0x0000FFFF)
    $hCtrl = $lParam
    
	If $nNotifyCode = 0 Then 
		If $nID = $chkPasswordEntrance Then
			If GuiCtrlRead($chkPasswordEntrance) = $GUI_CHECKED then 
				GuiCtrlSetState($txtPassword, $GUI_ENABLE)
				GuiCtrlSetState($txtPasswordConfirm, $GUI_ENABLE)
			Else
				GuiCtrlSetState($txtPassword, $GUI_DISABLE)
				GuiCtrlSetState($txtPasswordConfirm, $GUI_DISABLE)
				GuiCtrlSetData($txtPassword, '')
				GuiCtrlSetData($txtPasswordConfirm, '')
			EndIf
			
			Return 0 
		ElseIf $nID = $chkPasswordProtection Then 
			If GuiCtrlRead($chkPasswordProtection) = $GUI_CHECKED then 
				GuiCtrlSetState($txtNew, $GUI_ENABLE)
				GuiCtrlSetState($txtNewConfirm, $GUI_ENABLE)
			Else
				GuiCtrlSetState($txtNew, $GUI_DISABLE)
				GuiCtrlSetState($txtNewConfirm, $GUI_DISABLE)
				GuiCtrlSetData($txtNew, '')
				GuiCtrlSetData($txtNewConfirm, '')
			EndIf
			
			Return 0 			
		EndIf 
	EndIf

    Return $GUI_RUNDEFMSG
EndFunc

Func _SaveOpen()
	If $lastDate <> '' then 
		$fileName = $lastDate & '-' & $lastTab & '.txt'
		$file = FileOpen(@ScriptDir & '\Entries\' & $fileName, 2)
		$text = GuiCtrlRead($txtEdit)

		$text = _Trim($text)
		
		If $passwordEnabled then 
			$text = _StringEncrypt(1, $text, $password)
		EndIf

		FileWriteLine($file, $text)
		FileClose($file)
	EndIf
EndFunc

Func _Load($file) 
	Local $text = ''
	$data = FileOpen(@ScriptDir & '\Entries\' & $file & '.txt', 0)
	
	While Not @error 
		$text &= FileReadLine($data) & @CRLF 
	WEnd
	
	$text = _Trim($text)
	
	If $passwordEnabled then 
		$text = _StringEncrypt(0, $text, $password)
	EndIf 
	
	FileClose($data)
	
	Return $text 
EndFunc

Func _Delete()
	If FileExists(@ScriptDir & '\Entries\' & $lastDate & '-' & $lastTab & '.txt') then 
		FileDelete(@ScriptDir & '\Entries\' & $lastDate & '-' & $lastTab & '.txt')
	EndIf
	
	If $numTabs = 1 then Return 
	
	$temp = StringSplit($lastTab, ' ')
	_GuiCtrlTab_DeleteItem($tab, $temp[2] - 1)
	$numTabs -= 1
	
	If $lastTab <> 'Entry ' & ($numTabs + 1) then 
		$index = $temp[2]
		
		_Resave($index)
	EndIf
EndFunc

Func _Resave($i) 
	If Not FileExists(@ScriptDir & '\Entries\' & $lastDate & '-Entry ' & ($i + 1) & '.txt') then 
		Return 
	Else 
		$i += 1
		$source = @ScriptDir & '\Entries\' & $lastDate & '-Entry ' & $i & '.txt'
		$dest = @ScriptDir & '\Entries\' & $lastDate & '-Entry ' & ($i - 1) & '.txt'
		
		FileMove($source, $dest)
		
		_GuiCtrlTab_SetItemText($tab, $i - 2, 'Entry ' & $i - 1)
		
		_Resave($i)
	EndIf
EndFunc

Func _IsEmpty() 
	$temp = _Trim(GuiCtrlRead($txtEdit))
	
If $temp = '' then 
		Return True 
	Else 
		Return False 
	EndIf 
EndFunc

Func _Trim($data) 
	While StringRight($data, 2) = @CRLF 
		$data = StringTrimRight($data, 2) 
	WEnd 
	
	While StringLeft($data, 2) = @CRLF 
		$data = StringTrimLeft($data, 2) 
	WEnd 
	
	Return $data
EndFunc 

Func _GetDate() 
	If @OSVersion = 'WIN_VISTA' then 
		$temp = GuiCtrlRead($guiDate)
		$temp = StringSplit($temp, ',')
		
		$year = StringTrimLeft($temp[3], 1)
		$temp = StringSplit($temp[2], ' ') 
		
		$date = _GetMonthIndex($temp[2]) & $temp[3] & $year 
	Else 
		$temp = GuiCtrlRead($guiDate)
		$temp = StringSplit($temp, ' ')
		$year = StringTrimLeft($temp[3], 1)
		$date = _GetMonthIndex($temp[2]) & $temp[1] & $year
	EndIf
	
	Return $date 
EndFunc

Func _GetCurTab()
	Return _GUICtrlTab_GetItemText($tab, _GUICtrlTab_GetCurSel($tab))
EndFunc

Func _GetMonthIndex($month)
	Switch $month 
		Case 'January' 
			Return '01'
		Case 'February'
			Return '02'
		Case 'March'
			Return '03'
		Case 'April'
			Return '04'
		Case 'May'
			Return '05'
		Case 'June'
			Return '06'
		Case 'July'
			Return '07'
		Case 'August'
			Return '08'
		Case 'September'
			Return '09'
		Case 'October'
			Return '10'
		Case 'November'
			Return '11'
		Case 'December'
			Return '12'
	EndSwitch 
EndFunc
#endregion