;wua.au3
#include <GuiConstants.au3>
#include<menu.au3>
opt ("TrayIconDebug", 1)
Dim $CheckBox[100]
Dim $Update_Description[100]
Dim $Update_severity[100]
Dim $Update_number[100]
Dim $c = 0
Dim $GUI_BLUE = 0x0000FF
Dim $GUI_RED = 0xAA0000
Dim $GUI_BLACK = 0x000000
Dim $GUI_Orange = 0xE59930
Dim $GUI_GREEN = 0x009933
Global $Title
Global $GUI_Title = "Search for updates"
Global $Title_msg = "Search for updates ...."
Global $Button1
Global $Button2
Global $Button3
Global $Button1_msg = "Search"
Global $Button2_msg = "Download"
Global $Button3_msg = "Install"
Global $Button1_status = $GUI_ENABLE
Global $Button2_status = $GUI_DISABLE
Global $Button3_status = $GUI_DISABLE
Global $progress
Global $searchResultUpdates
Global $updateSession
Global $downloader
Global $reboot_status
Global $listed_updates
GUI($c, $GUI_Title)
#include <GuiConstants.au3>
Func GUI($c, $GUI_Title)
    GUICreate($GUI_Title, 661, 80 + 20 * $c, (@DesktopWidth - 661) / 2, 50, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
    $Title = GUICtrlCreateLabel($Title_msg, 30, 10, 280, 20)
    GUICtrlSetFont($Title, 14)
    $Button1 = GUICtrlCreateButton($Button1_msg, 320, 10, 80, 25)
    GUICtrlSetFont(-1, 11)
    GUICtrlSetState(-1, $Button1_status)
    $Button2 = GUICtrlCreateButton($Button2_msg, 430, 10, 80, 25)
    GUICtrlSetFont(-1, 11)
    GUICtrlSetState(-1, $Button2_status)
    $Button3 = GUICtrlCreateButton($Button3_msg, 540, 10, 80, 25)
    GUICtrlSetFont(-1, 11)
    GUICtrlSetState(-1, $Button3_status)
    $progress = GUICtrlCreateLabel("", 30, 40, 590, 15)
    GUICtrlSetColor($progress, $GUI_BLUE)
    If $c > 0 Then
        For $x = 0 To $c - 1
            $CheckBox[$x] = GUICtrlCreateCheckbox($Update_Description[$x] & $Update_severity[$x], 30, 60 + 20 * $x, 610, 13)
        Next
    EndIf
    GUISetState()
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg = $Button1
                If $Button1_msg = "Search" Then
                    ;Redraw()
                    Search()
                Else
                    For $x = 0 To $c - 1
                        GUICtrlSetState($CheckBox[$x], $GUI_CHECKED)
                        GUICtrlSetColor($CheckBox[$x], $GUI_RED)
                    Next
                EndIf
            Case $msg = $Button2
                Download ()
            Case $msg = $Button3
                Install ()
            Case Else
                For $x = 0 To $c - 1
                    If $msg = $CheckBox[$x] Then
                        If GUICtrlRead($CheckBox[$x]) = $GUI_CHECKED Then
                            GUICtrlSetColor($CheckBox[$x], $GUI_RED)
                        Else
                            GUICtrlSetColor($CheckBox[$x], $GUI_BLACK)
                        EndIf
                    EndIf
                Next
        EndSelect
    WEnd
    Exit
EndFunc   ;==>GUI
Func Redraw()
    $c = $c + 1
    GUIDelete($GUI_Title)
    $GUI_Title = "Updates found"
    GUI($c, $GUI_Title)
EndFunc   ;==>Redraw
Func Search()
    Local $x
    Local $y
    Local $arg1
    Local $arg2
    $y = _MsgBox ("Updates to search", "Select what updates you want to search for" & @CRLF & @CRLF & "Select ""ALL"" for all updates" & @CRLF & "Select ""Recommended"" for MS Recommended updates." & @CRLF & "Select ""CRITICAL"" for the highest priorty updates", "ALL", "Recommended","CRITICAL")
	If $y = "ALL" Then
        $arg1 = "IsInstalled = 0"
        $arg2 = ""
        $arg3 = ""
    ElseIf $y = "Recommended" Then
        $arg1 = "IsInstalled = 0 and Type ='Software'"
        $arg2 = "Critical,Moderate,Important,Low"
        $arg3 = "Windows Malicious Software"
    Else
        $arg1 = "IsInstalled = 0 and Type ='Software'"
        $arg2 = "Critical"
        $arg3 = ""
    EndIf
    GUICtrlSetData($progress, "Checking for updates ....")
    $updateSession = ObjCreate("Microsoft.Update.Session")
    $updateSearcher = $updateSession.CreateupdateSearcher ()
    ;$searchResult = $updateSearcher.Search ("IsInstalled = 0 and Type ='Software'")
    $searchResult = $updateSearcher.Search ($arg1)
    $searchResultUpdates = $searchResult.Updates
    $available_updates = ""
    $listed_updates = 0
    For $i = 0 To $searchResultUpdates.Count - 1
        $updates = $searchResultUpdates.Item ($i)
        GUICtrlSetData($progress, "Found ...." & $updates.Title)
        If $arg2 <> "" Then
            If $arg3 <> "" Then
                If StringInStr($arg2, $updates.MsrcSeverity) Or StringInStr($updates.Title, $arg3) Then
                    $Update_Description[$listed_updates] = $updates.Title
                    $Update_severity[$listed_updates] = " (Severity  : " & $updates.MsrcSeverity & " )"
					$Update_number[$listed_updates] = $i
                    $listed_updates = $listed_updates + 1
                EndIf
            Else ; $arg2 <> 0 , $arg3 = 0
                If StringInStr($arg2, $updates.MsrcSeverity) Then
                    $Update_Description[$listed_updates] = $updates.Title
                    $Update_severity[$listed_updates] = " (Severity  : " & $updates.MsrcSeverity & " )"
					$Update_number[$listed_updates] = $i
                    $listed_updates = $listed_updates + 1
                EndIf
            EndIf
        Else ; $arg2 = 0
            If $arg3 <> "" Then
                If StringInStr($updates.Title, $arg3) Then
                    $Update_Description[$listed_updates] = $updates.Title
                    $Update_severity[$listed_updates] = " (Severity  : " & $updates.MsrcSeverity & " )"
					$Update_number[$listed_updates] = $i
                    $listed_updates = $listed_updates + 1
                EndIf
            Else ; $arg2 = 0 , $arg3 = 0
                $Update_Description[$listed_updates] = $updates.Title
                $Update_severity[$listed_updates] = " (Severity  : " & $updates.MsrcSeverity & " )"
				$Update_number[$listed_updates] = $i
                $listed_updates = $listed_updates + 1
            EndIf
        EndIf
    Next

	If $listed_updates = 0 Then
		GUICtrlSetData($progress, "NO updates found")
	Else
	$Button1_msg = "Select ALL"
    $Button2_status = $GUI_ENABLE	
    $Title_msg = "Select updates to download ..."
    GUIDelete($GUI_Title)
    $GUI_Title = "Updates found"
    GUI($listed_updates, $GUI_Title)
	EndIf
EndFunc   ;==>Search
Func Download ()
    $updatesToDownload = ObjCreate("Microsoft.Update.UpdateColl")
    For $i = 0 To $searchResultUpdates.Count - 1
        If GUICtrlRead($CheckBox[$i]) = $GUI_CHECKED Then
            $update = $searchResultUpdates.Item ($i)
            If $update.IsDownloaded = False Then
                $updatesToDownload.Add ($update)
            Else
                GUICtrlSetColor($CheckBox[$i], $GUI_Orange)
                MsgBox(0, "", $update.Title)
            EndIf
        EndIf
    Next
    GUICtrlSetData($progress, "Downloading selected updates ...")
    $downloader = $updateSession.CreateUpdateDownloader ()
    $downloader.Updates = $updatesToDownload
    If $downloader.Updates.Count <> 0 Then
        $downloader.Download ()
        For $i = 0 To $searchResultUpdates.Count - 1
            If GUICtrlRead($CheckBox[$i]) = $GUI_CHECKED Then
                $update = $searchResultUpdates.Item ($i)
                If $update.IsDownloaded Then
                    GUICtrlSetColor($CheckBox[$i], $GUI_Orange)
                    MsgBox(0, "", $update.Title)
                EndIf
            EndIf
        Next
    EndIf
    GUICtrlSetData($progress, "Selected updates downloaded ...")
    GUICtrlSetState($Button3, $GUI_ENABLE)
    $Title_msg = "Select updates to install ..."
    GUICtrlSetData($Title, $Title_msg)
EndFunc   ;==>Download
Func Install ()
    GUICtrlSetData($progress, "Installing selected updates ...")
    $updatesToInstall = ObjCreate("Microsoft.Update.UpdateColl")
    For $i = 0 To $searchResultUpdates.Count - 1
        If GUICtrlRead($CheckBox[$i]) = $GUI_CHECKED Then
            $update = $searchResultUpdates.Item ($i)
            If $update.IsDownloaded = True Then
                $updatesToInstall.Add ($update)
            EndIf
        EndIf
    Next
    $installer = $updateSession.CreateUpdateInstaller ()
    $installer.Updates = $updatesToInstall
    If $updatesToInstall.Count > 0 Then
        $installationResult = $installer.Install ()
        For $i = 0 To $updatesToInstall.Count - 1
            For $x = 0 To $searchResultUpdates.Count - 1
                If $updatesToInstall.Item ($i).Title = $Update_Description[$x] Then
                    GUICtrlSetColor($CheckBox[$x], $GUI_GREEN)
                    GUICtrlSetData($CheckBox[$x], $Update_Description[$x] & "   *** " & $installationResult.GetUpdateResult ($i).ResultCode & "  ***")
                EndIf
            Next
        Next
        $reboot_status = $installationResult.RebootRequired
        GUICtrlSetData($progress, "Selected updates installed ...REBOOT required : " & $reboot_status)
    Else
        GUICtrlSetData($progress, "NO updates selected ")
    EndIf
EndFunc   ;==>Install
;$updatesToDownload = ObjCreate("Microsoft.Update.UpdateColl")