#include-once
#RequireAdmin
#include <guiconstants.au3>
#include <windowsconstants.au3>
#include <GuiListView.au3>
#include <guidisable.au3>
#include <EditConstants.au3>

MsgBox(0 + 48, "Startup Manager - Warning", "WARNING:" & @LF & "Modifiying startup programs may cause your operating system or other programs to stop working - use at your own risk")
If IsAdmin() = 0 Then
	MsgBox(0 + 16, "Startup Manager - Error", "This script is NOT running as administrator and will not be able to operate as normal. If you are to continue, please be aware that errors may occur ")
EndIf

$gui = GUICreate("Startup Manager", 800, 600, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX), $WS_EX_ACCEPTFILES)
$listview = GUICtrlCreateListView("Name|Program Location|Location|Users|Once/Always", 10, 10, 780, 500)
$remove = GUICtrlCreateButton("Remove", 10, 520, 260, 70)
$add = GUICtrlCreateButton("Add", 275, 520, 260, 70)
$Refresh = GUICtrlCreateButton("Refresh", 540, 520, 250, 70)
GUICtrlSetResizing($remove, 1)
GUICtrlSetResizing($add, 1)
GUICtrlSetResizing($Refresh, 1)
_refresh()
_GUICtrlListView_RegisterSortCallBack($listview)

GUISetState(@SW_SHOW)

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit 0
		Case $listview
			_GUICtrlListView_SortItems($listview, GUICtrlGetState($listview))
		Case $add
			_add()
		Case $Refresh
			_refresh()
		Case $remove
			$selecteditem = _GUICtrlListView_GetItemTextString($listview, Int(_GUICtrlListView_GetSelectedIndices($listview)))
			$selecteditemarray = StringSplit($selecteditem, "|")
			_remove($selecteditemarray[1], $selecteditemarray[3], $selecteditemarray[4], $selecteditemarray[5])
	EndSwitch
WEnd

Func _refresh()
	_GUICtrlListView_DeleteAllItems($listview)
	ProgressOn("Startup Manager", "Loading...", "0%")

	$r_hash = 0
	While 1
		$r_hash += 1
		$r_var = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $r_hash)
		If @error <> 0 Then
			ExitLoop
		Else
			GUICtrlCreateListViewItem($r_var & "|" & RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $r_var) & "|Registry|All Users|Always", $listview)
		EndIf
	WEnd

	ProgressSet(17, "17%")

	$r_hash = 0
	While 1
		$r_hash += 1
		$r_var = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $r_hash)
		If @error <> 0 Then
			ExitLoop
		Else
			GUICtrlCreateListViewItem($r_var & "|" & RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $r_var) & "|Registry|All Users|Once", $listview)
		EndIf
	WEnd

	ProgressSet(33, "33%")

	$r_hash = 0
	While 1
		$r_hash += 1
		$r_var = RegEnumVal("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $r_hash)
		If @error <> 0 Then
			ExitLoop
		Else
			GUICtrlCreateListViewItem($r_var & "|" & RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $r_var) & "|Registry|Current User|Always", $listview)
		EndIf
	WEnd

	ProgressSet(50, "50")

	$r_hash = 0
	While 1
		$r_hash += 1
		$r_var = RegEnumVal("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $r_hash)
		If @error <> 0 Then
			ExitLoop
		Else
			GUICtrlCreateListViewItem($r_var & "|" & RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $r_var) & "|Registry|Current User|Once", $listview)
		EndIf
	WEnd

	ProgressSet(67, "67%")

	FileChangeDir(@StartupCommonDir)
	Local $r_search = FileFindFirstFile("*.*")

	If $r_search <> -1 Then
		While 1
			Local $r_file = FileFindNextFile($r_search)
			If @error Then ExitLoop
			If Not StringRegExp(FileGetAttrib($r_file), "D") Then
				GUICtrlCreateListViewItem($r_file & "|" & @StartupCommonDir & "\" & $r_file & "|Startup Folder|All Users|Always", $listview)
			EndIf
		WEnd
	EndIf

	FileClose($r_search)

	ProgressSet(83, "83%")

	FileChangeDir(@StartupDir)
	Local $r_search = FileFindFirstFile("*.*")

	If $r_search <> -1 Then
		While 1
			Local $r_file = FileFindNextFile($r_search)
			If @error Then ExitLoop
			If Not StringRegExp(FileGetAttrib($r_file), "D") Then
				GUICtrlCreateListViewItem($r_file & "|" & @StartupDir & "\" & $r_file & "|Startup Folder|Current User|Always", $listview)
			EndIf
		WEnd
	EndIf

	FileClose($r_search)

	ProgressSet(100, "100%")
	ProgressOff()
EndFunc   ;==>_refresh

Func _remove($re_name, $re_location, $re_users, $re_occurence)
	If $re_location = "Startup Folder" Then

		If $re_users = "All Users" Then
			FileSetAttrib(@StartupCommonDir & "\" & $re_name, "-RSH")
			$re_delete = FileDelete(@StartupCommonDir & "\" & $re_name)
			If $re_delete = 0 Then
				MsgBox(0 + 48, "Startup Manager - Error", "An error occured while deleting the file" & @LF & "Location: " & @StartupCommonDir & "\" & $re_name, "", $gui)
			EndIf
		EndIf

		If $re_users = "Current User" Then
			FileSetAttrib(@StartupDir & "\" & $re_name, "-RSH")
			$re_delete = FileDelete(@StartupDir & "\" & $re_name)
			If $re_delete = 0 Then
				MsgBox(0 + 48, "Startup Manager - Error", "An error occured while deleting the file" & @LF & "Location: " & @StartupDir & "\" & $re_name, "", $gui)
			EndIf
		EndIf

	EndIf

	If $re_location = "Registry" Then

		If $re_users = "All Users" Then
			If $re_occurence = "Once" Then
				$re_delete = RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $re_name)
				If $re_delete <> 1 Then
					MsgBox(0 + 48, "Startup Manager - Error", "An error occured while deleting the registry value" & @LF & "Key: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" & @LF & "Value:" & $re_name, "", $gui)
				EndIf
			EndIf

			If $re_occurence = "Always" Then
				$re_delete = RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $re_name)
				If $re_delete <> 1 Then
					MsgBox(0 + 48, "Startup Manager - Error", "An error occured while deleting the registry value" & @LF & "Key: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & @LF & "Value:" & $re_name, "", $gui)
				EndIf
			EndIf
		EndIf

		If $re_users = "Current User" Then
			If $re_occurence = "Once" Then
				$re_delete = RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $re_name)
				If $re_delete <> 1 Then
					MsgBox(0 + 48, "Startup Manager - Error", "An error occured while deleting the registry value" & @LF & "Key: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" & @LF & "Value:" & $re_name, "", $gui)
				EndIf
			EndIf

			If $re_occurence = "Always" Then
				$re_delete = RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $re_name)
				If $re_delete <> 1 Then
					MsgBox(0 + 48, "Startup Manager - Error", "An error occured while deleting the registry value" & @LF & "Key: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & @LF & "Value:" & $re_name, "", $gui)
				EndIf
			EndIf
		EndIf

	EndIf

	_refresh()
EndFunc   ;==>_remove

Func _add()
	GUISetState(@SW_DISABLE, $gui)
	_guidisable($gui, 0, 50)
	Global $addgui = GUICreate("Startup Manager - Add", 500, 260, -1, -1, -1, $WS_EX_ACCEPTFILES, $gui)
	Global $addnamelabel = GUICtrlCreateLabel("Custom name to display:", 10, 10, 480, 20)
	Global $addnameinput = GUICtrlCreateInput("", 10, 30, 480, 20)
	Global $addlocationlabel = GUICtrlCreateLabel("File location:", 10, 60, 480, 20)
	Global $addlocationinput = GUICtrlCreateInput("", 10, 80, 480, 20)
	GUICtrlSetState($addlocationinput, $GUI_DROPACCEPTED)

	GUIStartGroup($addgui)
	Global $addlocationstorelabel = GUICtrlCreateLabel("Startup data location:", 10, 110, 480, 20)
	Global $addlocationstoreradio1 = GUICtrlCreateRadio("Registry", 10, 130, 70, 20)
	Global $addlocationstoreradio2 = GUICtrlCreateRadio("Startup Folder", 80, 130, 200, 20)

	GUIStartGroup($addgui)
	Global $adduserslabel = GUICtrlCreateLabel("All Users/Current User:", 10, 160, 480, 20)
	Global $addusersradio1 = GUICtrlCreateRadio("All Users", 10, 180, 70, 20)
	Global $addusersradio2 = GUICtrlCreateRadio("Current User", 80, 180, 200, 20)

	GUIStartGroup($addgui)
	Global $addoccurencelabel = GUICtrlCreateLabel("Occurence (Always/Once): (This option is only available for the registry)", 10, 210, 480, 20)
	Global $addoccurenceradio1 = GUICtrlCreateRadio("Always", 10, 230, 70, 20)
	Global $addoccurenceradio2 = GUICtrlCreateRadio("Once", 80, 230, 80, 20)

	Global $addbutton = GUICtrlCreateButton("ADD", 350, 210, 140, 40)

	GUISetState(@SW_SHOW, $addgui)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $addbutton
				If _addcheck() = 1 Then
					If _addstartup(GUICtrlRead($addnameinput), GUICtrlRead($addlocationinput), GUICtrlRead($addlocationstoreradio1), GUICtrlRead($addusersradio1), GUICtrlRead($addoccurenceradio1)) = 1 Then
						MsgBox(0 + 64, "Startup Manager - Add", "The application has been added to startup", "", $addgui)
						GUICtrlSetData($addnameinput, "")
						GUICtrlSetData($addlocationinput, "")
					EndIf
				EndIf
		EndSwitch
	WEnd

	GUISetState(@SW_ENABLE, $gui)
	_guidisable($gui, 0, 0)
	GUIDelete($addgui)
EndFunc   ;==>_add

Func _addcheck()
	If GUICtrlRead($addnameinput) = "" Then
		MsgBox(0 + 48, "Startup Manager - Add - Error", "Error: The name field was empty", "", $addgui)
		Return -1
	EndIf

	If GUICtrlRead($addlocationinput) = "" Then
		MsgBox(0 + 48, "Startup Manager - Add - Error", "Error: The location field was empty", "", $addgui)
		Return -1
	EndIf

	If GUICtrlRead($addlocationstoreradio1) <> 1 And GUICtrlRead($addlocationstoreradio2) <> 1 Then
		MsgBox(0 + 48, "Startup Manager - Add - Error", "Error: The startup data location field was empty", "", $addgui)
		Return -1
	EndIf

	If GUICtrlRead($addusersradio1) <> 1 And GUICtrlRead($addusersradio2) <> 1 Then
		MsgBox(0 + 48, "Startup Manager - Add - Error", "Error: The Users field was empty", "", $addgui)
		Return -1
	EndIf

	If GUICtrlRead($addoccurenceradio1) <> 1 And GUICtrlRead($addoccurenceradio2) <> 1 Then
		MsgBox(0 + 48, "Startup Manager - Add - Error", "Error: The Occurence field was empty", "", $addgui)
		Return -1
	EndIf

	Return 1
EndFunc   ;==>_addcheck

Func _addstartup($as_name, $as_location, $as_storage, $as_users, $as_occurence)
	If $as_storage = 1 Then
		;registry
		If $as_users = 1 Then
			;all users
			If $as_occurence = 1 Then
				;always
				$as_errorcheck = RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $as_name, "REG_SZ", $as_location)
				If $as_errorcheck = 0 Then
					MsgBox(0 + 48, "Startup Manager - Add - Error", "Error:" & @LF & "KEY: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & @LF & "Data: " & $as_location, "", $addgui)
					Return -1
				EndIf
			Else
				;once
				$as_errorcheck = RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $as_name, "REG_SZ", $as_location)
				If $as_errorcheck = 0 Then
					MsgBox(0 + 48, "Startup Manager - Add - Error", "Error:" & @LF & "KEY: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" & @LF & "Data: " & $as_location, "", $addgui)
					Return -1
				EndIf
			EndIf
		Else
			;current user
			If $as_occurence = 1 Then
				;always
				$as_errorcheck = RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $as_name, "REG_SZ", $as_location)
				If $as_errorcheck = 0 Then
					MsgBox(0 + 48, "Startup Manager - Add - Error", "Error:" & @LF & "KEY: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & @LF & "Data: " & $as_location, "", $addgui)
					Return -1
				EndIf
			Else
				;once
				$as_errorcheck = RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $as_name, "REG_SZ", $as_location)
				If $as_errorcheck = 0 Then
					MsgBox(0 + 48, "Startup Manager - Add - Error", "Error:" & @LF & "KEY: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" & @LF & "Data: " & $as_location, "", $addgui)
					Return -1
				EndIf
			EndIf
		EndIf
	Else
		;startup folder
		If $as_users = 1 Then
			;all users
			$as_errorcheck = FileCreateShortcut($as_location, @StartupCommonDir & "\" & $as_name & ".lnk")
			If $as_errorcheck = 0 Then
				MsgBox(0 + 48, "Startup Manager - Add - Error", "Error:" & @LF & "File: " & $as_location & @LF & "Startup shortcut location: " & @StartupCommonDir & "\" & $as_name & ".lnk", "", $addgui)
				Return -1
			EndIf
		Else
			;current user
			$as_errorcheck = FileCreateShortcut($as_location, @StartupDir & "\" & $as_name & ".lnk")
			If $as_errorcheck = 0 Then
				MsgBox(0 + 48, "Startup Manager - Add - Error", "Error:" & @LF & "File: " & $as_location & @LF & "Startup shortcut location: " & @StartupDir & "\" & $as_name & ".lnk", "", $addgui)
				Return -1
			EndIf
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_addstartup
