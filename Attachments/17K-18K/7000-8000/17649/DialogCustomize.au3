#include <GUIConstants.au3>
#NoTrayIcon
;Default values (only if it was customized before!!)
Dim $Def[6]
Dim $Def_1[6]
Dim $PlaceInput[6]
Global $Tested=False

$DefDisable=RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32","NoPlacesBar")
$Def[1]=RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place0")
$Def[2]=RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place1")
$Def[3]=RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place2")
$Def[4]=RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place3")
$Def[5]=RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place4")

For $a=1 To 5
	$Def_1[$a]=_CheckFolder($Def[$a])
Next

$hMain=GUICreate("FileOpen/FileSave customizer", 395, 420, 210, 56)

$PlaceInput[1] = GUICtrlCreateInput($Def_1[1], 26, 66, 171, 21)
$PlaceInput[2] = GUICtrlCreateInput($Def_1[2], 26, 111, 171, 21)
$PlaceInput[3] = GUICtrlCreateInput($Def_1[3], 26, 156, 171, 21)
$PlaceInput[4] = GUICtrlCreateInput($Def_1[4], 26, 201, 171, 21)
$PlaceInput[5] = GUICtrlCreateInput($Def_1[5], 26, 246, 171, 21)

$Browse1 = GUICtrlCreateButton("Browse", 222, 62, 133, 31, 0)
$Browse2 = GUICtrlCreateButton("Browse", 222, 106, 133, 31, 0)
$Browse3 = GUICtrlCreateButton("Browse", 222, 151, 133, 31, 0)
$Browse4 = GUICtrlCreateButton("Browse", 222, 196, 133, 31, 0)
$Browse5 = GUICtrlCreateButton("Browse", 222, 240, 133, 31, 0)
GUICtrlCreateGroup(" New Places ", 16, 34, 357, 251)

$Apply = GUICtrlCreateButton("Apply Changes", 264, 366, 117, 37, $BS_DEFPUSHBUTTON)
$Reset = GUICtrlCreateButton("Reset To Default", 10, 366, 117, 37)
$Preview = GUICtrlCreateButton("Test", 136, 366, 117, 37, 0)

$Disable = GUICtrlCreateCheckbox("Disable Places bar (It will not show)", 86, 312, 197, 29)
If $DefDisable=1 Then GUICtrlSetState(-1,$GUI_CHECKED)
_CheckBoxState()

GUICtrlCreateLabel("Choose the new places you wish to display in your File Save or File Open dialogs", 6, 10, 383, 17)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Browse1
			$NewPath=FileSelectFolder("Select the new place",@HomePath)
			If Not @error Then GUICtrlSetData($PlaceInput[1],$NewPath)
		Case $Browse2
			$NewPath=FileSelectFolder("Select the new place",@HomePath)
			If Not @error Then GUICtrlSetData($PlaceInput[2],$NewPath)
		Case $Browse3
			$NewPath=FileSelectFolder("Select the new place",@HomePath)
			If Not @error Then GUICtrlSetData($PlaceInput[3],$NewPath)
		Case $Browse4
			$NewPath=FileSelectFolder("Select the new place",@HomePath)
			If Not @error Then GUICtrlSetData($PlaceInput[4],$NewPath)
		Case $Browse5
			$NewPath=FileSelectFolder("Select the new place",@HomePath)
			If Not @error Then GUICtrlSetData($PlaceInput[5],$NewPath)
		Case $Apply
			_HitIt()
		Case $Reset
			RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32")
			_MsgBox(64,":-)","Your places bar was restored to default",$hMain)
		Case $Disable
			_CheckBoxState()
		Case $Preview
			If Not $Tested Then
				FileOpenDialog("Preview",@DesktopDir,"")
				$Tested=True
			Else
				_MsgBox(64,":-(","The 'Test' button can only be used once. New values have been written to the registry. You'll need to restart this application for the new changes to be seen",$hMain)
			EndIf
	EndSwitch
WEnd

Func _HitIt()
	Dim $err[6]
	If GUICtrlRead($Disable)=$GUI_CHECKED Then
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32","NoPlacesBar","REG_DWORD",1)
		$err[5]=@error
	Else
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32","NoPlacesBar","REG_DWORD",0)
		For $i=1 To 5
			$NewPathCheck=GUICtrlRead($PlaceInput[$i])
			If $NewPathCheck="" Then ContinueLoop
			Switch $NewPathCheck
				;DO YOUR CHANGES HERE!
				Case @MyDocumentsDir
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_DWORD",5)
					$err[$i-1]=@error	
				Case @DesktopDir
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_DWORD",Hex(0))
					$err[$i-1]=@error
				Case @FavoritesDir
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_DWORD",6)
					$err[$i-1]=@error
				Case "My Network Places"
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_DWORD",19)
					$err[$i-1]=@error
				Case "My Computer"
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_DWORD", 17)
					$err[$i-1]=@error
				Case "Internet Explorer"
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_DWORD",1)
					$err[$i-1]=@error
				Case "Recycle Bin"
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_DWORD",10)
					$err[$i-1]=@error
				Case Else
					RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar","Place" & $i-1,"REG_SZ",GUICtrlRead($PlaceInput[$i]))
					$err[$i-1]=@error
			EndSwitch
		Next
	EndIf
	For $i=0 To 4
		If $err[$i]<>0 Then
			Switch $err[$i]
				Case 1
					_MsgBox(48,"Error","Unable to open requested key",$hMain)
					Return
				Case 2
					_MsgBox(48,"Error","Unable to open requested main key",$hMain)
					Return
				Case 3
					_MsgBox(48,"Error","Unable to remote connect to the registry",$hMain)
					Return
				Case -1
					_MsgBox(48,"Error","Unable to open requested value",$hMain)
					Return
				Case -2
					_MsgBox(48,"Error","Value type not supported",$hMain)
					Return
			EndSwitch
		EndIf
	Next
	_MsgBox(64,":-)","Your places bar was succesfully customized!",$hMain)
	Return
EndFunc

Func _CheckBoxState()
	If GUICtrlRead($Disable)=$GUI_CHECKED Then
		GUICtrlSetState($PlaceInput[1],$GUI_DISABLE)
		GUICtrlSetState($PlaceInput[2],$GUI_DISABLE)
		GUICtrlSetState($PlaceInput[3],$GUI_DISABLE)
		GUICtrlSetState($PlaceInput[4],$GUI_DISABLE)
		GUICtrlSetState($PlaceInput[5],$GUI_DISABLE)
	Else
		GUICtrlSetState($PlaceInput[1],$GUI_ENABLE)
		GUICtrlSetState($PlaceInput[2],$GUI_ENABLE)
		GUICtrlSetState($PlaceInput[3],$GUI_ENABLE)
		GUICtrlSetState($PlaceInput[4],$GUI_ENABLE)
		GUICtrlSetState($PlaceInput[5],$GUI_ENABLE)
	EndIf
EndFunc

Func _CheckFolder($hexDir)
	Switch $hexDir
		;REPLACE HERE TOO!!!
		Case 5
			Return @MyDocumentsDir
		Case 1
			Return "Internet Explorer"
		Case 10
			Return "Recycle Bin"
		Case Hex(0)
			Return @DesktopDir
		Case 17
			Return "My Computer"
		Case 6
			Return @FavoritesDir
		Case 19
			Return "My Network Places"
		Case Else
			Return $hexDir
	EndSwitch
EndFunc

Func _MsgBox($iFlags, $sTitle, $sText, $hWnd)
	Local $aRet = DllCall('user32.dll', 'int', 'MessageBox', 'hwnd', $hWnd, 'str', $sText, 'str', $sTitle, 'uint', $iFlags)
	Return $aRet[0]
EndFunc   ;==>_MsgBox