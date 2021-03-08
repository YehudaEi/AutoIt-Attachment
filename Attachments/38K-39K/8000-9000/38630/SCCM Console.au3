#Region START Includes ###
#RequireAdmin
#include <AD.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Excel.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <GuiMenu.au3>
#include <Constants.au3>
#EndRegion END Includes ###



#Region START Globals ###
Global $ini = @ProgramFilesDir & "\SCCM Console\bin\config.ini"
Global $sServer = IniRead($ini, "Server", "SName", "")
Global $SCode = IniRead($ini, "Server", "SCode", "")
Global $logfile = IniRead($ini, "Server", "Logfile", "") & @MON & "_" & @MDAY & "_" & @YEAR & ".log"
Global $oErrorHandler = ObjEvent("AutoIt.Error", "_ErrFunc")
Global $ErrLevel
Global $Assts
Global $ColID
Global $machine
Global $image
Global $merge
#EndRegion END Globals ###




If StringInStr($cmdlineRaw, "/Extract") Then
    FileInstall("C:\New SCCM GUI.au3", @TempDir & "\Source.au3", 1)
EndIf

_InGroup()

Func _InGroup()

_AD_Open()

$sFQDN_User = _AD_SamAccountNameToFQDN()
$sFQDN_Group1 = IniRead($ini, "Security", "Group1", "")
$sFQDN_Group2 = IniRead($ini, "Security", "Group2", "")

$ingroup1 = _AD_IsMemberOf($sFQDN_Group1, $sFQDN_User, False)
$ingroup2 = _AD_IsMemberOf($sFQDN_Group2, $sFQDN_User, False)

_AD_Close()

_pullCols($ingroup1, $ingroup2)
_main($ingroup1, $ingroup2)

EndFunc

Func _pullCols($ingroup1, $ingroup2)

Local $oResults

$oLocator = ObjCreate("WbemScripting.SWbemLocator")
$oSMS = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
If @error Then Exit MsgBox(0, "SCCM Console", "Can't Connect")
$oSMS.Security_.ImpersonationLevel = 3
$oSMS.Security_.AuthenticationLevel = 6

	If $ingroup2 = 1 Then
		$oResults = $oSMS.ExecQuery("SELECT * FROM SMS_Collection WHERE Comment LIKE '%License%' ORDER by Name")
	Else
		$oResults = $oSMS.ExecQuery("SELECT * FROM SMS_Collection WHERE Comment LIKE '%Site License%' ORDER by Name")
	EndIf

Global $aArray[$oResults.Count][2]
Global $iIndex = 0

For $element In $oResults
   $aArray[$iIndex][0] = $element.Name
   $aArray[$iIndex][1] = $element.CollectionID
   $iIndex = $iIndex + 1
Next


EndFunc

Func _main($ingroup1, $ingroup2)


	$sGui = GUICreate("SCCM Console", 915, 420)
	GUISetBkColor(0xE0FFFF)

	;Labels
	$Software = GUICtrlCreateLabel("Software Delivery Actions", 96, 8, 262, 28)
	GUICtrlSetFont(-1, 16, 800, 0, "Arial")
	$RClick = GUICtrlCreateLabel("Client Actions", 650, 8, 144, 28)
	GUICtrlSetFont(-1, 16, 800, 0, "Arial")
	$Packages = GUICtrlCreateLabel("Packages", 130, 40, 72, 17)
	GUICtrlSetFont(-1, 11, 800, 0, "Arial")
	$Tag = GUICtrlCreateLabel("Asset Tag", 450, 40, 72, 17)
	GUICtrlSetFont(-1, 11, 800, 0, "Arial")

	;ListView
	$listview = GUICtrlCreateListView("listview items", 8, 60, 350, 350)
	_GUICtrlListView_SetColumn($listview, 0, "", 330, 0)


	;Inputs
	$Assts = GUICtrlCreateInput("", 430, 60, 121, 24)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, "Asset Tag");<===Thanks to Melba23

	;Buttons
	$AddPCs = GUICtrlCreateButton("Add PC to Collection", 360, 250, 155, 41)
	$RemovePCs = GUICtrlCreateButton("Remove PC from Collection", 360, 300, 155, 41)
	$Browse = GUICtrlCreateButton("Add PCs from file", 360, 350, 155, 41)
	$Go = GUICtrlCreateButton("Launch Client Action", 500, 160, 155, 41)
	$Exit = GUICtrlCreateButton("Exit", 812, 375, 100, 40)
	$Search = GUICtrlCreateButton("Search", 475, 90, 121, 24)

	;Radio Buttons
	$C_Share = GUICtrlCreateRadio("Open C: Drive", 675, 50, 145, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$CCM = GUICtrlCreateRadio("Open CCM Directory", 675, 75, 161, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$Logs = GUICtrlCreateRadio("Open Client Logs Directory", 675, 100, 191, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$EvtVwr = GUICtrlCreateRadio("Open Event Viewer", 675, 125, 161, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$listing = GUICtrlCreateRadio("Collection Listing", 675, 150, 161, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")

	$Chk = GUICtrlCreateRadio("Force Check-In", 675, 190, 201, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$Svcs = GUICtrlCreateRadio("Restart SCCM Services", 675, 215, 201, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$Repair = GUICtrlCreateRadio("Repair SCCM Client", 675, 240, 201, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$Reboot = GUICtrlCreateRadio("Reboot Asset", 675, 265, 201, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")

	$Remote = GUICtrlCreateRadio("Remote Control", 675, 305, 201, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")

	If $ingroup1 = 1 Then
		$image = GUICtrlCreateRadio("Image Hardware", 675, 330, 201, 17)
			GUICtrlSetFont(-1, 10, 800, 0, "Arial")
		$merge = GUICtrlCreateRadio("Merge Conflicting Records", 675, 355, 201, 17)
			GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	EndIf

	For $i = 0 To UBound($aArray) - 1
		GUICtrlCreateListViewItem($aArray[$i][0], $listview)
	Next

	GUISetState(@SW_SHOW, $sGui)

	While 1
		Local $msg
		$msg = GUIGetMsg()

		Select
			Case $msg = $Exit
				Exit
			Case $msg = $GUI_EVENT_CLOSE
				Exit
			Case $msg = $AddPCs
				If _GUICtrlListView_GetItemTextString($listview, -1) = "" Then
					MsgBox(0, "SCCM Console", "Please select a collection first.")
				ElseIf GUICtrlRead($Assts) = "" Then
					MsgBox(0, "SCCM Console", "Please enter an asset first.")
				Else
					_addtocoll($listview)
					If $ErrLevel <> '' Then
						MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($Assts)) & "] not found in database. Please check asset tag or use the Search feature.")
						$ErrLevel = ''
						$machine = ''
					Else
						MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($Assts)) & "] has been added to collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "].")
						GUICtrlSetData($Assts, "")
						$machine = ''
					EndIf
				EndIf
			Case $msg = $RemovePCs
				If _GUICtrlListView_GetItemTextString($listview, -1) = "" Then
					MsgBox(0, "SCCM Console", "Please select a collection first.")
				ElseIf GUICtrlRead($Assts) = "" Then
					MsgBox(0, "SCCM Console", "Please enter an asset first.")
				Else
					_removefromcoll($listview)
					If $ErrLevel = 1 Then
						MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($Assts)) & "] not found in database. Please check asset tag or use the Search feature.")
						$ErrLevel = ''
						$machine = ''
					ElseIf $ErrLevel = 2 Then
						MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($Assts)) & "] is not a member of collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "].")
						$ErrLevel = ''
						$machine = ''
					Else
						MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($Assts)) & "] has been removed from collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "].")
						GUICtrlSetData($Assts, "")
						$ErrLevel = ''
						$machine = ''
						GUICtrlSetData($Assts, "")
					EndIf
				EndIf
			Case $msg = $Browse
				_addfromfile($listview)
			Case $msg = $Search
				_Search()
			Case $msg = $Go
					Select
						Case GUICtrlRead($image) = $GUI_CHECKED
							_image()
						Case GUICtrlRead($merge) = $GUI_CHECKED
							_merge()
						Case GUICtrlRead($Assts) = ""
							MsgBox(0, "SCCM Console", "Please enter an asset first.")
						Case GUICtrlRead($C_Share) = $GUI_CHECKED
							If Ping(GUICtrlRead($Assts)) Then
								ShellExecute("explorer.exe", "\\" & GUICtrlRead($Assts) & "\C$")
							Else
								MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
							EndIf
						Case GUICtrlRead($CCM) = $GUI_CHECKED
							If Ping(GUICtrlRead($Assts)) Then
								If FileExists("\\" & GUICtrlRead($Assts) & "\C$\Program Files (x86)") Then
									ShellExecute("explorer.exe", "\\" & GUICtrlRead($Assts) & "\C$\Windows\SysWOW64\CCM")
								Else
									ShellExecute("explorer.exe", "\\" & GUICtrlRead($Assts) & "\C$\Windows\System32\CCM")
								EndIf
							Else
								MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
							EndIf
						Case GUICtrlRead($Logs) = $GUI_CHECKED
							_checkLogs()
						Case GUICtrlRead($Repair) = $GUI_CHECKED
							If Ping(GUICtrlRead($Assts)) Then
								_repair()
							Else
								MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
							EndIf
						Case GUICtrlRead($Svcs) = $GUI_CHECKED
							If Ping(GUICtrlRead($Assts)) Then
								_restartSvcs()
							Else
								MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
							EndIf
						Case GUICtrlRead($Chk) = $GUI_CHECKED
							If Ping(GUICtrlRead($Assts)) Then
								_force()
							Else
								MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
							EndIf
							GUICtrlSetData($Assts, "")
						Case GUICtrlRead($EvtVwr) = $GUI_CHECKED
							If Ping(GUICtrlRead($Assts)) Then
								If @OSArch = "X64" Then
									ShellExecute("eventvwr", GUICtrlRead($Assts))
								Else
									ShellExecute("eventvwr.msc", "/computer=" & GUICtrlRead($Assts))
								EndIf
							Else
								MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
							EndIf
						Case GUICtrlRead($Remote) = $GUI_CHECKED
							_remote()
							GUICtrlSetData($Assts, "")
						Case GUICtrlRead($Reboot) = $GUI_CHECKED
							If Ping(GUICtrlRead($Assts)) Then
								ShellExecuteWait("Shutdown.exe", "-r -f -m " & GUICtrlRead($Assts) & " -t 0", "", "", @SW_HIDE)
								MsgBox(0, "SCCM Console", "Remote reboot process started on [" & StringUpper(GUICtrlRead($Assts)) & "].")
								FileWriteLine($logfile, "Technician [" & @UserName & "] performed a remote restart of  [" & GUICtrlRead($Assts) & "] - " & @HOUR & ":" & @MIN)
							Else
								MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
							EndIf
							GUICtrlSetData($Assts, "")
						Case GUICtrlRead($listing) = $GUI_CHECKED
							_CollList()
					EndSelect
		EndSelect

	WEnd

EndFunc

Func _addtocoll($listview)

	$pc = GUICtrlRead($Assts)
	$var = _GUICtrlListView_GetItemTextString($listview, -1)

	For $i = 1 To UBound($aArray) - 1
		If $aArray[$i][0] = $var Then
			$ColID = $aArray[$i][1]
			$wshell = ObjCreate("WScript.Shell")
			_add($pc, $listview)
		EndIf
	Next

EndFunc

Func _removefromcoll($listview)

	$pc = GUICtrlRead($Assts)
	$var = _GUICtrlListView_GetItemTextString($listview, -1)

	For $i = 1 To UBound($aArray) - 1
		If $aArray[$i][0] = $var Then
			$ColID = $aArray[$i][1]
			$wshell = ObjCreate("WScript.Shell")
			_remove($pc, $listview)
		EndIf
	Next

EndFunc

Func _add($pc, $listview)

	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oSMSAdd = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
	If @error Then MsgBox(0, "SCCM Console", "Can't Connect to Database. If this problem persists, please contact an Administrator.")
	$oSMSAdd.Security_.ImpersonationLevel = 3
	$oSMSAdd.Security_.AuthenticationLevel = 6

	$oResults = $oSMSAdd.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & $pc & "'")
	If @error Then Return

	For $element In $oResults
		$machine = $element.ResourceID
	Next


	If StringLen($machine) < 1 Then
		$ErrLevel = 1
		FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to add asset [" & $pc & _
			"] to Collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "]. Asset not found in database. - " & @HOUR & ":" & @MIN)
	Else
		$collection = $oSMSAdd.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
		$rule = $oSMSAdd.Get("SMS_CollectionRuleDirect").SpawnInstance_()

		$rule.ResourceClassName = "SMS_R_System"
		$rule.ResourceID = $machine
		$collection.AddMembershipRule($rule)
		FileWriteLine($logfile, "Technician [" & @UserName & "] added asset [" & $pc & _
			"] to Collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "] - " & @HOUR & ":" & @MIN)
	EndIf

EndFunc

Func _force()

	If Ping(GUICtrlRead($Assts)) Then
		$sScheduleID = "{00000000-0000-0000-0000-000000000021}"
		$oCCMNamespace = ObjGet("winmgmts://" & GUICtrlRead($Assts) & "/root/ccm")
		$oInstance = $oCCMNamespace.Get("SMS_Client")
		$oParams = $oInstance.Methods_("TriggerSchedule").inParameters.SpawnInstance_()
			$oParams.sScheduleID = $sScheduleID
			$oCCMNamespace.ExecMethod("SMS_Client", "TriggerSchedule", $oParams)
					If @error Then
						MsgBox(0, "SCCM Console", "Failed to Update Agent on [" & StringUpper(GUICtrlRead($Assts)) & "]." & @CRLF & "If this problem persists, please contact" & _
							" an Administrator")
						FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to force Agent check-in on  [" & GUICtrlRead($Assts) & "]. Process Failed - " & @HOUR & ":" & @MIN)
					Else
						MsgBox(0, "SCCM Console", "Successfully Updated Agent on [" & StringUpper(GUICtrlRead($Assts)) & "].")
						FileWriteLine($logfile, "Technician [" & @UserName & "] forced Agent check-in on  [" & GUICtrlRead($Assts) & "] - " & @HOUR & ":" & @MIN)
					EndIf
	EndIf

EndFunc

Func _remove($pc, $listview)

	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oSMSRemove = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
	If @error Then MsgBox(0, "SCCM Console", "Can't Connect to Database. If this problem persists, please contact an Administrator.")
	$oSMSRemove.Security_.ImpersonationLevel = 3
	$oSMSRemove.Security_.AuthenticationLevel = 6

	$oResults = $oSMSRemove.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & $pc & "'")
	If @error Then Return

	For $element In $oResults
		$machine = $element.ResourceID
	Next

	If StringLen($machine) < 1 Then
		$ErrLevel = 1
		FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to remove asset [" & $pc & _
			"] from Collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "]. Asset not found in database. - " & @HOUR & ":" & @MIN)
	Else
		$collection = $oSMSRemove.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
		$rule = $oSMSRemove.Get("SMS_CollectionRuleDirect").SpawnInstance_()
		$collection = $oSMSRemove.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
		$rule = $oSMSRemove.Get("SMS_CollectionRuleDirect").SpawnInstance_()
		$rule.ResourceClassName = "SMS_R_System"
		$rule.ResourceID = $machine
		$collection.DeleteMembershipRule($rule)
			If @error Then
				Return
			Else
				FileWriteLine($logfile, "Technician [" & @UserName & "] removed asset [" & $pc & _
					"] from Collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "] - " & @HOUR & ":" & @MIN)
			EndIf
	EndIf

EndFunc

Func _remote()

	If Ping(GUICtrlRead($Assts)) Then
		ShellExecute(@ProgramFilesDir & "\SCCM Console\bin\rc.exe", "1 " & GUICtrlRead($Assts) & " \\" & $sServer)
		FileWriteLine($logfile, "Technician [" & @UserName & "] initiated remote control of [" & GUICtrlRead($Assts) & "] - " & _
		              @HOUR & ":" & @MIN)
	Else
		MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
	EndIf

EndFunc

Func _addfromfile($listview)
	Local $aText

	If _GUICtrlListView_GetItemTextString($listview, -1) = "" Then
		MsgBox(0, "SCCM Console", "Please select a collection first.")
	Else
		$text = FileOpenDialog("SCCM Console", "C:\", "Text Files (*.txt)")
			If Not @error Then
				_FileReadToArray($text, $aText)
				_ArrayDelete($aText, 0)
				If UBound($aText, 1) > 10 And @UserName <> "LoganJ1" Then
					MsgBox(0, "SCCM Console", "You may only deploy software to 10 assets at one time.")
					FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to add more than 10 assets to Collection [" & _
						_GUICtrlListView_GetItemTextString($listview, -1) & "]. Access Denied. - " & @HOUR & ":" & @MIN)
				Else
					$txt = _ArrayToString($aText, @CRLF)
					$confirm = MsgBox(1, "SCCM Console", "Will add the following assets to [" & _GUICtrlListView_GetItemTextString($listview, -1) & "]:" & @CRLF & @CRLF & $txt)
						If $confirm = "1" Then
							_addfromtext($aText, $listview)
							MsgBox(0, "SCCM Console", "Added " & UBound($aText, 1) & " assets to [" & _GUICtrlListView_GetItemTextString($listview, -1) & "].")
						Else
							MsgBox(0, "SCCM Console", "Action cancelled.")
						EndIf
				EndIf
			EndIf
	EndIf

EndFunc

Func _addfromtext($aText, $listview)

$var = _GUICtrlListView_GetItemTextString($listview, -1)

	For $element In $aText
		$index = $element
		$var = _GUICtrlListView_GetItemTextString($listview, -1)
			For $i = 1 To UBound($aArray) - 1
				If $aArray[$i][0] = $var Then
					Global $ColID = $aArray[$i][1]
						$wshell = ObjCreate("WScript.Shell")
						$oLocator = ObjCreate("WbemScripting.SWbemLocator")
						$oSMSFromText = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
							If @error Then MsgBox(0, "SCCM Console", "Can't Connect")
						$oSMSFromText.Security_.ImpersonationLevel = 3
						$oSMSFromText.Security_.AuthenticationLevel = 6
						$oResults = $oSMSFromText.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & $index & "'")
							For $element In $oResults
								$machine = $element.ResourceID
							Next
					If StringLen($machine) < 1 Then
						$ErrLevel = 1
						FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to add asset [" & $index & _
							"] to Collection [" & $aArray[$i][0] & "]. Asset not found in database. - " & @HOUR & ":" & @MIN)
					Else
						$collection = $oSMSFromText.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
						$rule = $oSMSFromText.Get("SMS_CollectionRuleDirect").SpawnInstance_()
						$rule.ResourceClassName = "SMS_R_System"
						$rule.ResourceID = $machine
						$collection.AddMembershipRule($rule)
						FileWriteLine($logfile, "Technician [" & @UserName & "] added asset [" & $index & _
							"] to Collection [" & _GUICtrlListView_GetItemTextString($listview, -1) & "] - " & @HOUR & ":" & @MIN)
					EndIf

				EndIf
		Next
	Next

EndFunc

Func _Search()

	Local $aArray2[1]
		$aArray2[0] = ""
	If GUICtrlRead($Assts) = "" Then
		MsgBox(0, "SCCM Console", "Please enter at least three digits to search for the asset.")
	Else
		$oLocator = ObjCreate("WbemScripting.SWbemLocator")
		$oSMS = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
			If @error Then Exit MsgBox(0, "SCCM Console", "Can't Connect")
		$oSMS.Security_.ImpersonationLevel = 3
		$oSMS.Security_.AuthenticationLevel = 6

		$oResults = $oSMS.ExecQuery("SELECT * from SMS_R_System where Name LIKE '" & GUICtrlRead($Assts) & "%'")

		For $element In $oResults
			_ArrayAdd($aArray2, $element.Name)
		Next


		_ArrayDelete($aArray2, 0)
		_ArraySort($aArray2)

			If Not IsArray($aArray2) Then
				MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($Assts)) & "] was not found in the database. Please double check the asset tag.")
			Else
				$mychild = GUICreate("Search for machine", 275, 300)
				$listview2 = GUICtrlCreateListView("Assets", 10, 10, 250, 200)
				_GUICtrlListView_SetColumnWidth($listview2, 0, $LVSCW_AUTOSIZE_USEHEADER)
				GUISetBkColor(0xE0FFFF)

				$button = GUICtrlCreateButton("Add", 20, 220, 100, 50)
				$close = GUICtrlCreateButton("Close", 150, 220, 100, 50)

					For $r = 0 To UBound($aArray2, 1) - 1
						GUICtrlCreateListViewItem($aArray2[$r], $listview2)
					Next

				GUISetState(@SW_SHOW, $mychild)

					While 1
						Local $msg2
						$msg2 = GUIGetMsg()
							Select
								Case $msg2 = $GUI_EVENT_CLOSE
									GUIDelete($mychild)
									ExitLoop
								Case $msg2 = $close
									GUIDelete($mychild)
									ExitLoop
								Case $msg2 = $button
									GUICtrlSetData($Assts, _GUICtrlListView_GetItemTextString($listview2, -1), "")
									GUIDelete($mychild)
									ExitLoop
							EndSelect
					WEnd
			EndIf
	EndIf

EndFunc

Func _restartSvcs()

$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = GUICtrlRead($Assts)

Local $var

$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

MsgBox(0, "SCCM Console", "Restarting Services on asset [" & StringUpper($strComputer) & "], please wait.....", 2)

	If IsObj($colItems) then
		For $objItem In $colItems
			If $objItem.Name = "ccmexec" Then
				$objItem.StopService
				Sleep(5000)
				$objItem.StartService
				$var = 1
				FileWriteLine($logfile, "Technician [" & @UserName & "] restarted the SMS Agent Host service on  [" & _
					GUICtrlRead($Assts) & "] - " & @HOUR & ":" & @MIN)
				MsgBox(0, "SCCM Console", "Services have been restarted on asset [" & StringUpper($strComputer) & "].", 2)
				GUICtrlSetData($Assts, "")
			EndIf
		Next

		If $var <> "1" Then
			MsgBox(0, "SCCM Console", "SMS Agent Host Service was not found on asset [" & StringUpper($strComputer) & "]. The SCCM Agent may not be installed.")
		EndIf

	Endif

EndFunc

Func _repair()

	If FileExists("\\" & GUICtrlRead($Assts) & "\C$\Windows\System32\CCM\ccmrepair.exe") Or _
		FileExists("\\" & GUICtrlRead($Assts) & "\C$\Windows\SysWOW64\CCM\ccmrepair.exe") Then
			$SmsClient = ObjGet("winmgmts://" & GUICtrlRead($Assts) & "/Root/Ccm:SMS_Client")
			$SmsClient.RepairClient
			MsgBox(0, "SCCM Console", "This task may take several minutes to complete.")
			FileWriteLine($logfile, "Technician [" & @UserName & "] performed a repair of the SCCM agent on  [" & _
				GUICtrlRead($Assts) & "] - " & @HOUR & ":" & @MIN)
			GUICtrlSetData($Assts, "")
	Else
		MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($Assts)) & "] does not appear to have the agent installed." & @CRLF & @CRLF & _
				  "Please contact an Administrator")
	EndIf

EndFunc

Func _image()

$oLocator = ObjCreate("WbemScripting.SWbemLocator")
$oSMSImage = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
If @error Then Exit MsgBox(0, "SCCM Console", "Can't Connect")
$oSMSImage.Security_.ImpersonationLevel = 3
$oSMSImage.Security_.AuthenticationLevel = 6

$oResults = $oSMSImage.ExecQuery("SELECT * FROM SMS_Collection WHERE Comment LIKE '%Image Collection%' ORDER by Name")

Global $aArrayImage[$oResults.Count][2]
Global $iIndex = 0

For $element In $oResults
   $aArrayImage[$iIndex][0] = $element.Name
   $aArrayImage[$iIndex][1] = $element.CollectionID
   $iIndex = $iIndex + 1
Next

	$imagechild = GUICreate("Hardware Imaging", 450, 380)
	GUISetBkColor(0xE0FFFF)

	;Buttons
	$ReimageSearch = GUICtrlCreateButton("Search", 330, 78, 100, 30)
	$beginReimage = GUICtrlCreateButton("Start Reimage", 170, 120, 100, 30)
	$removeReimage = GUICtrlCreateButton("Remove from Collection", 300, 120, 120, 30)
	$beginUSMT = GUICtrlCreateButton("Create PC Association", 315, 230, 125, 35)
	$deleteUSMT = GUICtrlCreateButton("Remove PC Association", 315, 280, 125, 35)
	$close = GUICtrlCreateButton("Close", 255, 340, 100, 30)


	;Inputs
	$ReimagePC = GUICtrlCreateInput("", 165, 80, 120, 30)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$srcInput = GUICtrlCreateInput("", 165, 220, 125, 30)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$dstInput = GUICtrlCreateInput("", 165, 290, 125, 30)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial")

	;Labels
	$imagelabel = GUICtrlCreateLabel("Imaging Collections", 15, 10, 150, 17)
		GUICtrlSetFont(-1, 10, 600, 0, "Arial")
	$ReimageLabel = GUICtrlCreateLabel("====Reimage Machine====", 195, 30, 200, 17)
		GUICtrlSetFont(-1, 10, 600, 0, "Arial")
	$SrcLabel = GUICtrlCreateLabel("PC to Reimage", 175, 60, 150, 17)
		GUICtrlSetFont(-1, 10, 500, 0, "Arial")
	$USMTLabel = GUICtrlCreateLabel("====User State Migration====", 195, 180, 250, 17)
		GUICtrlSetFont(-1, 10, 600, 0, "Arial")
	$USMTSrcLabel = GUICtrlCreateLabel("Source PC", 190, 200, 100, 17)
		GUICtrlSetFont(-1, 10, 500, 0, "Arial")
	$USMTDstLabel = GUICtrlCreateLabel("Destination PC", 180, 270, 100, 17)
		GUICtrlSetFont(-1, 10, 500, 0, "Arial")

	;ListViews
	$imageview = GUICtrlCreateListView("Imaging Collections", 10, 30, 150, 310)
		_GUICtrlListView_SetColumn($imageview, 0, "", 146, 0)

	For $i = 0 To UBound($aArrayImage) - 1
		GUICtrlCreateListViewItem($aArrayImage[$i][0], $imageview)
	Next

	GUISetState(@SW_SHOW, $imagechild)

		While 1
			Local $msg
				$msg = GUIGetMsg()
					Select
						Case $msg = $GUI_EVENT_CLOSE
							GUIDelete($imagechild)
							ExitLoop
						Case $msg = $close
							GUIDelete($imagechild)
							ExitLoop
						Case $msg = $ReimageSearch
							If GUICtrlRead($ReimagePC) = "" Then
								MsgBox(0, "SCCM Console", "Please enter at least three digits to use the Search function.")
							Else
								_ImageSearch($ReimagePC)
							EndIf
						Case $msg = $beginReimage
							If GUICtrlRead($ReimagePC) = "" Then
								MsgBox(0, "SCCM Console", "Please enter a Source PC first.")
							ElseIf _GUICtrlListView_GetItemTextString($imageview, -1) = "" Then
								MsgBox(0, "SCCM Console", "Please select an Imaging Collection first.")
							Else
								_HII($imageview, $ReimagePC)
								GUICtrlSetData($ReimagePC, "")
							EndIf
						Case $msg = $removeReimage
							If _GUICtrlListView_GetItemTextString($imageview, -1) = "" Then
								MsgBox(0, "SCCM Console", "Please select an Imaging Collection first.")
							Else
								_RemoveFromImageCollection($imageview, $ReimagePC)
									If $ErrLevel = 1 Then
										MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($ReimagePC)) & "] not found in database. Please check asset tag or use the Search feature.")
										$ErrLevel = ''
									ElseIf $ErrLevel = 2 Then
										MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($ReimagePC)) & "] is not a member of collection [" & _GUICtrlListView_GetItemTextString($imageview, -1) & "].")
										$ErrLevel = ''
									Else
										MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($ReimagePC)) & "] has been removed from collection [" & _GUICtrlListView_GetItemTextString($imageview, -1) & "].")
										GUICtrlSetData($ReimagePC, "")
										$ErrLevel = ''
										GUICtrlSetData($ReimagePC, "")
									EndIf
							EndIf
						Case $msg = $beginUSMT
							If _GUICtrlListView_GetItemTextString($imageview, -1) = "" Then
								MsgBox(0, "SCCM Console", "Please select an Imaging Collection first.")
							Else
								$type = "AddAssociation"
								_USMT($imageview, $srcInput, $dstInput, $type)
							EndIf
						Case $msg = $deleteUSMT
							If _GUICtrlListView_GetItemTextString($imageview, -1) = "" Then
								MsgBox(0, "SCCM Console", "Please select an Imaging Collection first.")
							Else
								$type = "DeleteAssociation"
								_USMT($imageview, $srcInput, $dstInput, $type)
							EndIf
					EndSelect
		WEnd

EndFunc

Func _HII($imageview, $ReimagePC)

	Local $oResults

	$var = _GUICtrlListView_GetItemTextString($imageview, -1)

	For $i = 0 To UBound($aArrayImage) - 1
		If $aArrayImage[$i][0] = $var Then
			$ColID = $aArrayImage[$i][1]
			$wshell = ObjCreate("WScript.Shell")
		EndIf
	Next

	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oSMSImage = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
	If @error Then MsgBox(0, "SCCM Console", "Can't Connect to Database. If this problem persists, please contact an Administrator.")
	$oSMSImage.Security_.ImpersonationLevel = 3
	$oSMSImage.Security_.AuthenticationLevel = 6

	$oResults = $oSMSImage.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & GUICtrlRead($ReimagePC) & "'")
	If @error Then Return

	For $element In $oResults
		$machine = $element.ResourceID
	Next

	If StringLen($machine) < 1 Then
		$ErrLevel = 1
		FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to add asset [" & GUICtrlRead($ReimagePC) & _
			"] to the XP HII Collection. Asset not found in database. - " & @HOUR & ":" & @MIN)
		MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($ReimagePC)) & "] not found in database. Please check asset tag or use the Search feature.")
		$ErrLevel = ''
		$machine = ''
	Else
		$collection = $oSMSImage.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
		$rule = $oSMSImage.Get("SMS_CollectionRuleDirect").SpawnInstance_()

		$rule.ResourceClassName = "SMS_R_System"
		$rule.ResourceID = $machine
		$collection.AddMembershipRule($rule)
		FileWriteLine($logfile, "Technician [" & @UserName & "] added asset [" & GUICtrlRead($ReimagePC) & _
			"] to the " & _GUICtrlListView_GetItemTextString($imageview, -1) & "  Collection - " & @HOUR & ":" & @MIN)
		MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($ReimagePC)) & "] successfully added to the " & _GUICtrlListView_GetItemTextString($imageview, -1) & " collection.")
	EndIf

EndFunc

Func _RemoveFromImageCollection($imageview, $ReimagePC)

	Local $oResults

	$var = _GUICtrlListView_GetItemTextString($imageview, -1)

	For $i = 0 To UBound($aArrayImage) - 1
		If $aArrayImage[$i][0] = $var Then
			$ColID = $aArrayImage[$i][1]
			$wshell = ObjCreate("WScript.Shell")
		EndIf
	Next

	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oSMSRemove = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
		If @error Then MsgBox(0, "SCCM Console", "Can't Connect to Database. If this problem persists, please contact an Administrator.")
	$oSMSRemove.Security_.ImpersonationLevel = 3
	$oSMSRemove.Security_.AuthenticationLevel = 6

	$oResults = $oSMSRemove.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & GUICtrlRead($ReimagePC) & "'")
		If @error Then _ErrFunc1($imageview, $ReimagePC)

	For $element In $oResults
		$machine = $element.ResourceID
	Next

	If StringLen($machine) < 1 Then
		FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to add asset [" & GUICtrlRead($ReimagePC) & _
			"] to the XP HII Collection. Asset not found in database. - " & @HOUR & ":" & @MIN)
		MsgBox(0, "SCCM Console", "Asset [" & StringUpper($ReimagePC) & "] not found in database. Please check asset tag or use the Search feature.")
		$ErrLevel = ''
		$machine = ''
	Else
		$collection = $oSMSRemove.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
		$rule = $oSMSRemove.Get("SMS_CollectionRuleDirect").SpawnInstance_()
		$rule.ResourceClassName = "SMS_R_System"
		$rule.ResourceID = $machine
		$collection.DeleteMembershipRule($rule)

			If @error Then
				_ErrFunc1($imageview, $ReimagePC)
			Else
				FileWriteLine($logfile, "Technician [" & @UserName & "] removed asset [" & GUICtrlRead($ReimagePC) & _
					"] from the " & _GUICtrlListView_GetItemTextString($imageview, -1) & "  Collection - " & @HOUR & ":" & @MIN)
			EndIf
	EndIf

EndFunc

Func _USMT($imageview, $srcInput, $dstInput, $type)

Local $machinesrc
Local $machinedst
Local $var

	If GUICtrlRead($srcInput) = "" Or GUICtrlRead($dstInput) = "" Then
		MsgBox(0, "SCCM Console", "Please enter an asset for both the Source and Destination PC.")
	Else
		$var = _GUICtrlListView_GetItemTextString($imageview, -1)
		For $i = 0 To UBound($aArrayImage) - 1
			If $aArrayImage[$i][0] = $var Then
				$ColID = $aArrayImage[$i][1]
			EndIf
		Next

		$wshell = ObjCreate("WScript.Shell")
		$oLocator = ObjCreate("WbemScripting.SWbemLocator")
		$oSMSUSMT = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
			If @error Then MsgBox(0, "SCCM Console", "Can't Connect to Database. If this problem persists, please contact an Administrator.")
		$oSMSUSMT.Security_.ImpersonationLevel = 3
		$oSMSUSMT.Security_.AuthenticationLevel = 6

		Switch $type
			Case $type = "DeleteAssociation"
				$oCheck = $oSMSUSMT.ExecQuery("SELECT * FROM SMS_StateMigration")

				For $element in $oCheck
					If $element.SourceName = GUICtrlRead($srcInput) And $element.RestoreName = GUICtrlRead($dstInput) Then
						$oResults1 = $oSMSUSMT.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & GUICtrlRead($srcInput) & "'")
							For $element In $oResults1
								$machinesrc = $element.ResourceID
							Next

						$oResults2 = $oSMSUSMT.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & GUICtrlRead($dstInput) & "'")
							For $element In $oResults2
								$machinedst = $element.ResourceID
							Next

						If StringLen($machinesrc) < 1 Then
							MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($srcInput)) & "] not found in database. Please check asset tag.")
							FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to remove an association between assets [" & GUICtrlRead($srcInput) & _
							"] and [" & GUICtrlRead($dstInput) & "]. " & GUICtrlRead($srcInput) & " not found in database. - " & @HOUR & ":" & @MIN)
						ElseIf StringLen($machinedst) < 1 Then
							MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($dstInput)) & "] not found in database. Please check asset tag.")
							FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to remove an association between assets [" & GUICtrlRead($srcInput) & _
							"] and [" & GUICtrlRead($dstInput) & "]. " & GUICtrlRead($dstInput) & " not found in database. - " & @HOUR & ":" & @MIN)
						Else
							$stateMigrationClass = $oSMSUSMT.Get("sms_StateMigration")
							$inParams = $stateMigrationClass.Methods_("DeleteAssociation").InParameters.SpawnInstance_
							$inParams.SourceClientResourceID = $machinesrc
							$inParams.RestoreClientResourceID = $machinedst
							$outParams = _
								$oSMSUSMT.ExecMethod( "SMS_StateMigration", "DeleteAssociation", $inParams)
							$collection = $oSMSUSMT.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
							$rule = $oSMSUSMT.Get("SMS_CollectionRuleDirect").SpawnInstance_()
							$rule.ResourceClassName = "SMS_R_System"
							$rule.ResourceID = $machinedst
							$collection.DeleteMembershipRule($rule)

							MsgBox(0, "SCCM Console", "Computer Association Successfully Removed.")
							$var += 1
						EndIf
					EndIf
				Next
				If $var <> 1 Then
					MsgBox(0, "SCCM Console", "Could not find Association in database.")
					$var = 0
				EndIf
			Case $type = "AddAssociation"
				$oResults1 = $oSMSUSMT.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & GUICtrlRead($srcInput) & "'")
					For $element In $oResults1
						$machinesrc = $element.ResourceID
					Next

				$oResults2 = $oSMSUSMT.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & GUICtrlRead($dstInput) & "'")
					For $element In $oResults2
						$machinedst = $element.ResourceID
					Next

				If StringLen($machinesrc) < 1 Then
					MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($srcInput)) & "] not found in database. Please check asset tag.")
					FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to create an association between assets [" & GUICtrlRead($srcInput) & _
					"] and [" & GUICtrlRead($dstInput) & "]. " & GUICtrlRead($srcInput) & " not found in database. - " & @HOUR & ":" & @MIN)
				ElseIf StringLen($machinedst) < 1 Then
					MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($dstInput)) & "] not found in database. Please check asset tag.")
					FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to create an association between assets [" & GUICtrlRead($srcInput) & _
					"] and [" & GUICtrlRead($dstInput) & "]. " & GUICtrlRead($dstInput) & " not found in database. - " & @HOUR & ":" & @MIN)
				Else
					$stateMigrationClass = $oSMSUSMT.Get("sms_StateMigration")
					$inParams = $stateMigrationClass.Methods_("AddAssociation").InParameters.SpawnInstance_
					$inParams.SourceClientResourceID = $machinesrc
					$inParams.RestoreClientResourceID = $machinedst
					$outParams = _
						$oSMSUSMT.ExecMethod( "SMS_StateMigration", "AddAssociation", $inParams)
					$collection = $oSMSUSMT.Get("SMS_Collection.CollectionID=" & """" & $ColID & """")
					$rule = $oSMSUSMT.Get("SMS_CollectionRuleDirect").SpawnInstance_()
					$rule.ResourceClassName = "SMS_R_System"
					$rule.ResourceID = $machinedst
					$collection.AddMembershipRule($rule)
				EndIf

				$oCheck = $oSMSUSMT.ExecQuery("SELECT * FROM SMS_StateMigration")
					For $element in $oCheck
						If $element.SourceName = GUICtrlRead($srcInput) And $element.RestoreName = GUICtrlRead($dstInput) Then
							$var += 1
							MsgBox(0, "SCCM Console", "Computer Association Successfully Created.")
						EndIf
					Next

				If $var <> 1 Then
					MsgBox(0, "SCCM Console", "Computer Association Failed, please try again." & @CRLF & @CRLF & "If you continue to receive this message, please contact an SCCM Administrator.")
					$var = 0
				EndIf

		EndSwitch
	EndIf
EndFunc

Func _ImageSearch($ReimagePC)


	Local $aArraySearch[1]
		$aArraySearch[0] = ""

	If GUICtrlRead($ReimagePC) = "" Then
		MsgBox(0, "SCCM Console", "Please enter at least three digits to search for the asset.")
	Else
		$oLocator = ObjCreate("WbemScripting.SWbemLocator")
		$oSMS = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
			If @error Then Exit MsgBox(0, "SCCM Console", "Can't Connect")
		$oSMS.Security_.ImpersonationLevel = 3
		$oSMS.Security_.AuthenticationLevel = 6

		$oResults = $oSMS.ExecQuery("SELECT * from SMS_R_System where Name LIKE '" & GUICtrlRead($ReimagePC) & "%'")

		For $element In $oResults
			_ArrayAdd($aArraySearch, $element.Name)
		Next

		_ArrayDelete($aArraySearch, 0)
		_ArraySort($aArraySearch)


	EndIf

		If Not IsArray($aArraySearch) Then
			MsgBox(0, "SCCM Console", "Asset [" & StringUpper(GUICtrlRead($ReimagePC)) & "] was not found in the database. Please double check the asset tag.")
		Else
			$searchchild = GUICreate("Search for machine", 275, 300)
			$searchlistview = GUICtrlCreateListView("Assets", 10, 10, 250, 200)
			_GUICtrlListView_SetColumnWidth($searchlistview, 0, $LVSCW_AUTOSIZE_USEHEADER)
			GUISetBkColor(0xE0FFFF)

			$button = GUICtrlCreateButton("Add", 20, 220, 100, 50)
			$close = GUICtrlCreateButton("Close", 150, 220, 100, 50)

				For $r = 0 To UBound($aArraySearch, 1) - 1
					GUICtrlCreateListViewItem($aArraySearch[$r], $searchlistview)
				Next

			GUISetState(@SW_SHOW, $searchchild)

				While 1
					Local $msg2
					$msg2 = GUIGetMsg()
						Select
							Case $msg2 = $GUI_EVENT_CLOSE
								GUIDelete($searchchild)
								ExitLoop
							Case $msg2 = $close
								GUIDelete($searchchild)
								ExitLoop
							Case $msg2 = $button
								GUICtrlSetData($ReimagePC, _GUICtrlListView_GetItemTextString($searchlistview, -1), "")
								GUIDelete($searchchild)
								ExitLoop
						EndSelect
				WEnd
		EndIf
EndFunc

Func _CollList()

	$oLocator = ObjCreate("WbemScripting.SWbemLocator")
	$oSMS = $oLocator.ConnectServer($sServer, "root\sms\site_" & $SCode)
	If @error Then MsgBox(0, "SCCM Console", "Can't Connect to Database. If this problem persists, please contact an Administrator.")
	$oSMS.Security_.ImpersonationLevel = 3
	$oSMS.Security_.AuthenticationLevel = 6
	Local $aCollection[1]
		$aCollection[0] = "Testing"
	Local $aMainWindow
	Local $CollectionArray
	Local $MainWindowArray
    Local $count = 0


	$sShell = ObjCreate("Wscript.Shell")
	$oFSO = ObjCreate("Scripting.FileSystemObject")
	$SWbemLocator = ObjCreate("WbemScripting.SWbemLocator")
	$SWbemServices = $SWbemLocator.ConnectServer($sServer,"root\SMS\site_" & $SCode)
	$connection= $swbemServices

	$oResults = $oSMS.ExecQuery("SELECT * FROM SMS_R_System WHERE Name = '" & GUICtrlRead($Assts) & "'")
	If @error Then Return

	For $element In $oResults
		$machine = $element.ResourceID
	Next

	If StringLen($machine) < 1 Then
		$ErrLevel = 1
		MsgBox(0, "SCCM Console", "Could not retrieve Collection List for asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
	Else
		$strQuery = "select * from SMS_CollectionMember_a where ResourceID='" & $machine &"'"
		$aCollections = $SWbemServices.ExecQuery($strQuery)

			For $element in $aCollections
				$Collectionfound = $SWbemServices.Get("SMS_Collection='" & $element.CollectionID & "'" )
				_ArrayAdd($aCollection, $Collectionfound.Name)
			Next
			_ArraySort($aCollection)

			$colchild = GUICreate("Collection listing for " & GUICtrlRead($Assts), 275, 300)
			GUISetBkColor(0xE0FFFF)
			$collistview = GUICtrlCreateListView("Collections", 10, 10, 250, 200)
			_GUICtrlListView_SetColumnWidth($collistview, 0, $LVSCW_AUTOSIZE_USEHEADER)
			$close = GUICtrlCreateButton("Close", 150, 220, 100, 50)

			For $r = 1 To UBound($aCollection, 1) - 1
				GUICtrlCreateListViewItem($aCollection[$r], $collistview)
			Next

			GUISetState(@SW_SHOW, $colchild)

			While 1
				Local $msg
					$msg = GUIGetMsg()
						Select
							Case $msg = $GUI_EVENT_CLOSE
								GUIDelete($colchild)
								ExitLoop
							Case $msg = $close
								GUIDelete($colchild)
								ExitLoop
						EndSelect
			WEnd
	EndIf
EndFunc

Func _checkLogs()

	If Ping(GUICtrlRead($Assts)) Then
		If FileExists("\\" & GUICtrlRead($Assts) & "\C$\Windows\SysWOW64\CCM\Logs") Then
			$log = FileOpenDialog("SCCM Console", "\\" & GUICtrlRead($Assts) & "\C$\Windows\SysWOW64\CCM\Logs", "Logs (*.log)")
			If Not @error Then ShellExecute(@ProgramFilesDir & "\SCCM Console\bin\trace32.exe", $log)
			FileWriteLine($logfile, "Technician [" & @UserName & "] opened log files on asset [" & GUICtrlRead($Assts) & "] - " & @HOUR & ":" & @MIN)
		ElseIf FileExists("\\" & GUICtrlRead($Assts) & "\C$\Windows\System32\CCM\Logs") Then
			$log = FileOpenDialog("SCCM Console", "\\" & GUICtrlRead($Assts) & "\C$\Windows\System32\CCM\Logs", "Logs (*.log)")
			If Not @error Then ShellExecute(@ProgramFilesDir & "\SCCM Console\bin\trace32.exe", $log)
			FileWriteLine($logfile, "Technician [" & @UserName & "] opened log files on asset [" & GUICtrlRead($Assts) & "] - " & @HOUR & ":" & @MIN)
		Else
			MsgBox(0, "SCCM Console", "The Logs directory does not exist on this machine.")
		EndIf
	Else
		MsgBox(0, "SCCM Console", "Could not ping asset [" & StringUpper(GUICtrlRead($Assts)) & "].")
		FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to open log files on asset [" & GUICtrlRead($Assts) & "]. Asset is unreachable - " & @HOUR & ":" & @MIN)
	EndIf

EndFunc

Func _merge()

	$swbemLocator = ObjCreate("WbemScripting.SWbemLocator")
	$swbemServices = $swbemLocator.ConnectServer($sServer, "root\SMS\site_" & $SCode)
	$oProviderLocation = $swbemServices.InstancesOf("SMS_ProviderLocation")
	$oPendingRegs = $swbemServices.ExecQuery("SELECT * FROM SMS_PendingRegistrationRecord")

	For $oReg In $oPendingRegs
		$InParams = $swbemServices.Get("SMS_PendingRegistrationRecord").Methods_("ResolvePendingRegistrationRecord").InParameters.SpawnInstance_
		$InParams.Action = "1"
		$InParams.SMSID = $oReg.SMSID
		$swbemServices.ExecMethod("SMS_PendingRegistrationRecord","ResolvePendingRegistrationRecord", $InParams)
    Next

	MsgBox(0, "SCCM Console", "Merged all conflicting records in database." & @CRLF & "Please wait 60 seconds for database refresh.")
	FileWriteLine($logfile, "Technician [" & @UserName & "] merged all conflicting records in SCCM database - " & @HOUR & ":" & @MIN)

EndFunc

Func _ErrFunc($pc, $listview)
	$ErrLevel = 2
	FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to remove asset [" & $pc &	"] from Collection [" & _
		_GUICtrlListView_GetItemTextString($listview, -1) & "]. Asset not a member of the collection. - " & @HOUR & ":" & @MIN)
EndFunc

Func _ErrFunc1($imageview, $ReimagePC)
	$ErrLevel = 2
	FileWriteLine($logfile, "Technician [" & @UserName & "] attempted to remove asset [" & GUICtrlRead($ReimagePC) & "] from Collection [" & _
		_GUICtrlListView_GetItemTextString($imageview, -1) & "]. Asset not a member of the collection. - " & @HOUR & ":" & @MIN)
EndFunc