#include <GUIConstants.au3>
#NoTrayIcon
AutoItSetOption("GUIOnEventMode", 1)

$GUITitle = "Download Firefox"
$GUIWidth = 302
$GUIHeight = 168
Dim $iDloadFinalSize = ""
Dim $iDloadCurrentSize = ""

$GUI = GUICreate($GUITitle, $GUIWidth, $GUIHeight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2)
$sFileURL1 = GUICtrlCreateInput("", 24, 24, 249, 21)
$Button1 = GUICtrlCreateButton("Download", 24, 72, 115, 17, 0)
$Button2 = GUICtrlCreateButton("Cancel / Close", 148, 72, 115, 17, 0)
$progressDownloadStatus = GUICtrlCreateProgress(24, 104, 246 - 10, 10)
$lb_Mn_Progress = GUICtrlCreateLabel('Download not Started yet', 40, 120, $GUIWidth, $GUIHeight)
GUISetState()
GUICtrlSetState($Button2,$GUI_DISABLE)

#Region Events list
GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitIt")
GUICtrlSetOnEvent($Button2,"_DownloadFF")
GUICtrlSetOnEvent($Button1,"_DownloadFF")
#EndRegion Events list

While 1
    Sleep(10)
    If $iDloadFinalSize <> "" Then _CheckActiveDownload()
WEnd

Func _ExitIt()
    Exit
EndFunc

Func _CheckActiveDownload()
		While @InetGetActive
            $oldspeed = @InetGetBytesRead
            Sleep(250)
            $newspeed = @InetGetBytesRead
            $speed = Int(($newspeed - $oldspeed) * 4 / 1024)
    If @InetGetBytesRead <> "-1" Then
		GUICtrlSetState($Button2,$GUI_ENABLE)
        $iDloadCurrentSize = @InetGetBytesRead
        $iPercentage = Round(($iDloadCurrentSize/$iDloadFinalSize)*100,1)
        GUICtrlSetData($progressDownloadStatus,$iPercentage)
		GUICtrlSetData($lb_Mn_Progress, 'Download Progress: ' & $iPercentage & " percent (%) with " & $speed & " KB/s")
    Else
        $iDloadFinalSize = ""
        GUICtrlSetData($progressDownloadStatus,"0")
        MsgBox(16,"Error","The download was cancelled, or did not complete successfully.")
		FileDelete($sFileDest)
		Exit
    EndIf
	Wend
    If $iDloadCurrentSize = $iDloadFinalSize Then
        $iDloadFinalSize = ""
        MsgBox(64,"Complete","Download complete!")
    EndIf
EndFunc

Func _DownloadFF()
	$file=GUICtrlRead($sFileURL1)
    If @InetGetActive Then
        InetGet("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        Global $file
		Global $file2 = StringTrimLeft($file,StringInStr($file,"/",0,-1))
        Global $sFileDest = @ScriptDir&"/"&$file2
        $iDloadFinalSize = InetGetSize($file)
        $iDloadCurrentSize = "0"
        InetGet($file, $sFileDest, 1, 1)
    EndIf
EndFunc