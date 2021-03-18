#RequireAdmin
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <Misc.au3>;			needed for _Singleton

If Not _Singleton(@ScriptName) Then Exit

Global $ColNeeded
Global $Host = @ComputerName

$BannedList = StringSplit("Essentials|Silverlight|Malicious|Bing", "|")

$Gui = GUICreate("Automatic Updates Tool", 800, 520)
GUISetBkColor(0xb2ccff, $Gui)
$NeededListView = GUICtrlCreateListView("Title|Status", 10, 40, 780, 450, $LVS_SHOWSELALWAYS)
_GUICtrlListView_SetColumnWidth($NeededListView, 0, 657)
_GUICtrlListView_SetColumnWidth($NeededListView, 1, 100)
$UpdatesFound = GUICtrlCreateLabel("", 10, 10, 200, 20)
GUICtrlSetBkColor($UpdatesFound, "0xffffff")
$Start = GUICtrlCreateButton("Start", 580, 10, 100, 20)
$FullAuto = GUICtrlCreateButton("Full Auto", 690, 10, 100, 20)
$AutoRunCountdown = GUICtrlCreateLabel("20 Seconds Until Full Auto", 250, 10, 280, 20)
GUICtrlSetFont(-1, 13)

GUISetState()

$InitTime = TimerInit()
AdlibRegister("_AutoRunDelay", 500)
Do
	Sleep(50)
	$MSG = GUIGetMsg()
	if $MSG==$GUI_EVENT_CLOSE then Exit
	If $MSG == $Start Then
		AdlibUnRegister()
		GUICtrlSetData($AutoRunCountdown, "")
		_PopulateNeeded($Host)
	EndIf
	If $MSG == $FullAuto Then
		AdlibUnRegister()
		GUICtrlSetData($AutoRunCountdown, "")
		$LoginCheck = MsgBox(4, "IMPORTANT", "In order for this method to work properly, Windows MUST boot to the Desktop without needing a username or password entered." & @CR & @CR & "Does this computer require a username and password to be entered to reach the Desktop?")
		If $LoginCheck == 7 Then
			_CreateAutoRun()
		EndIf
		If $LoginCheck == 6 Then
			Run("control userpasswords2")
			MsgBox(0, "Login", "Choose a user with administrative permissions and set Windows to boot to that profile.  Once the Auto Update app is finished you will be brought back here to set the login back to the way it is now" & @CR & @CR & "Click OK only after you have set Windows to not require a login!")
			_CreateAutoRun()
		EndIf
	EndIf

Until True == False


Func _AutoRunDelay()
	$TimeLeft = 20 - (TimerDiff($InitTime) / 1000)
	GUICtrlSetData($AutoRunCountdown, Int($TimeLeft) & " Seconds Until Full Auto")
	If $TimeLeft < 0 Then
		GUICtrlSetData($AutoRunCountdown, "")
		_PopulateNeeded($Host)
	EndIf
EndFunc   ;==>_AutoRunDelay


Func _CreateAutoRun()
	FileCreateShortcut(@ScriptFullPath, @StartupCommonDir & "\Autorun.lnk")
	_PopulateNeeded($Host)
EndFunc   ;==>_CreateAutoRun


Func _RemoveAutoRun()
	FileDelete(@StartupCommonDir & "\Autorun.lnk")
EndFunc   ;==>_RemoveAutoRun


Func _CreateMSUpdateSession($strHost = @ComputerName)
	$objSession = ObjCreate("Microsoft.Update.Session", $strHost)
	If Not IsObj($objSession) Then Return 0
	Return $objSession
EndFunc   ;==>_CreateMSUpdateSession

Func _CreateSearcher($objSession)
	If Not IsObj($objSession) Then Return -1
	Return $objSession.CreateUpdateSearcher
EndFunc   ;==>_CreateSearcher


Func _FetchNeededData($Host)
	$objSearcher = _CreateSearcher(_CreateMSUpdateSession($Host))
	$ColNeeded = _GetNeededUpdates($objSearcher)
	$objSearcher = 0
	Dim $arrNeeded[1][2]
	For $i = 0 To $ColNeeded.Updates.Count - 1
		If $i < $ColNeeded.Updates.Count - 1 Then ReDim $arrNeeded[$i + 2][2]
		$update = $ColNeeded.Updates.Item($i)
		$arrNeeded[$i][0] = $update.Title
		$arrNeeded[$i][1] = $update.Description
	Next
	If Not IsArray($arrNeeded) Then
		MsgBox(16, "Failed to Fetch Needed Updates " & $Host, "", 5)
		Return 0
	EndIf
	Return $arrNeeded
EndFunc   ;==>_FetchNeededData

Func _GetNeededUpdates($objSearcher)
	If Not IsObj($objSearcher) Then Return -5
	$ColNeeded = $objSearcher.Search("IsInstalled=0 and Type='Software'")
	Return $ColNeeded
EndFunc   ;==>_GetNeededUpdates

Func _GetTotalHistoryCount($objSearcher)
	If Not IsObj($objSearcher) Then Return -2
	Return $objSearcher.GetTotalHistoryCount
EndFunc   ;==>_GetTotalHistoryCount


Func _PopulateNeeded($Host)
	AdlibUnRegister()
	_GUICtrlListView_DeleteAllItems(ControlGetHandle($Gui, "", $NeededListView))

	SplashTextOn("Please Wait", "Finding Needed Updates", 200, 30, -1, -1, 32)
	$arrNeeded = _FetchNeededData($Host)
	SplashOff()

	If IsArray($arrNeeded) And $arrNeeded[0][0] <> "" Then
		For $i = 0 To UBound($arrNeeded) - 1
			_GUICtrlListView_AddItem($NeededListView, $arrNeeded[$i][0])
			$Dirty = False
			For $Check = 1 To $BannedList[0]
				If StringInStr($arrNeeded[$i][0], $BannedList[$Check]) Then $Dirty = True
			Next
			If $Dirty == False Then _GUICtrlListView_SetItemSelected($NeededListView, $i, True)
		Next
	Else
		_GUICtrlListView_AddItem($NeededListView, "No Needed Updates Found")
	EndIf
	$objSearcher = 0
	$arrNeeded = 0

	AdlibRegister("_KillRestartWindow")
	_UpdatesDownloadAndInstall()
EndFunc   ;==>_PopulateNeeded


Func _KillRestartWindow()
	If WinExists("Automatic Updates", "Updating your computer is almost") Then
		WinActivate("Automatic Updates", "Updating your computer is almost")
		WinClose("Automatic Updates", "Updating your computer is almost")
	EndIf
EndFunc   ;==>_KillRestartWindow


Func _UpdatesDownloadAndInstall()
	GUICtrlSetData($AutoRunCountdown, "")
	$Selected = _GUICtrlListView_GetSelectedIndices($NeededListView, True)

	If $Selected[0] = 0 Then
		AdlibUnRegister()
		MsgBox(0, "Done", "There are no more updates to be installed.")
		_RemoveAutoRun()
		$RestoreLogonScreen = MsgBox(4, "Restore Logon Screen?", "Do you need to restore the logon screen for multiple user accounts, or remove the auto-password completion for a single user with a password?")
		If $RestoreLogonScreen == 6 Then
			Run("control userpasswords2")
		EndIf
		Exit
	EndIf
	$objSearcher = _CreateMSUpdateSession($Host)
	For $x = 1 To $Selected[0]
		$item = _GUICtrlListView_GetItemText($NeededListView, $Selected[$x])
		For $i = 0 To $ColNeeded.Updates.Count - 1
			$update = $ColNeeded.Updates.Item($i)
			If $item = $update.Title Then
				GUICtrlSetData($UpdatesFound, "Downloading " & $x & " of " & $Selected[0] & " Updates")
				_GUICtrlListView_SetItemText($NeededListView, $i, "Downloading...", 1)
				_GUICtrlListView_SetItemFocused($NeededListView, $i)
				_GUICtrlListView_EnsureVisible($NeededListView, $i)
				$updatesToDownload = ObjCreate("Microsoft.Update.UpdateColl")
				$updatesToDownload.Add($update)
				$DownloadSession = $objSearcher.CreateUpdateDownloader()
				$DownloadSession.Updates = $updatesToDownload
				$DownloadSession.Download
				_GUICtrlListView_SetItemText($NeededListView, $i, "Downloaded", 1)
			EndIf
		Next
	Next

	$RebootNeeded = False
	For $x = 1 To $Selected[0]
		$item = _GUICtrlListView_GetItemText($NeededListView, $Selected[$x])
		For $i = 0 To $ColNeeded.Updates.Count - 1
			$update = $ColNeeded.Updates.Item($i)
			If $item = $update.Title And $update.IsDownloaded Then
				GUICtrlSetData($UpdatesFound, "Installing " & $x & " of " & $Selected[0] & " Updates")
				_GUICtrlListView_SetItemText($NeededListView, $i, "Installing...", 1)
				_GUICtrlListView_SetItemFocused($NeededListView, $i)
				_GUICtrlListView_EnsureVisible($NeededListView, $i)
				$InstallSession = $objSearcher.CreateUpdateInstaller()
				$updatesToInstall = ObjCreate("Microsoft.Update.UpdateColl")
				$updatesToInstall.Add($update)
				$InstallSession.Updates = $updatesToInstall
				$installresult = $InstallSession.Install
				If $installresult.RebootRequired Then
					$RebootNeeded = True
				EndIf
				_GUICtrlListView_SetItemText($NeededListView, $i, "Complete", 1)
			EndIf
		Next
	Next

	If $RebootNeeded Then
		MsgBox(0, "Reboot required", "A reboot is required.  Rebooting in 5 seconds.", 5)
		Shutdown(2 + 4 + 16)
	Else
		_GUICtrlListView_DeleteAllItems($NeededListView)
		_PopulateNeeded($Host)
	EndIf

	$DownloadSession = 0
	$updatesToDownload = 0
	Return 0
EndFunc   ;==>_UpdatesDownloadAndInstall