#include <GUIConstants.au3>
Dim $s_URL2Download = '                                       '
Dim $s_Filename2Save2 = @HomeDrive & "\PAC2.zip"
ConsoleWrite(DriveSpaceFree(@HomeDrive) - 100 & ">" & (InetGetSize($s_URL2Download) / 1024 / 1024))
If DriveSpaceFree(@HomeDrive) - 100 > (InetGetSize($s_URL2Download) / 1024 / 1024) Then
	MsgBox(0, "Success", "You have sufficient disk space to download the file.  The download will now begin.", 10)
	DownloadFile($s_URL2Download, $s_Filename2Save2)
Else
	MsgBox(0, "Error", "You don't have sufficient disk space to download the file.")
EndIf


Func DownloadFile($s_URL, $s_Filename)
	$ProgressForm = GUICreate("Update Downloader by The Kandie Man", 350, 88, (@DesktopWidth - 350) / 2, (@DesktopHeight - 88) / 2) ;283, 278)
	$downloadprogress = GUICtrlCreateProgress(8, 64, 337, 17, $PBS_SMOOTH)
	GUICtrlSetColor(-1, 0x0A246A)
	$lbldownloadspeed = GUICtrlCreateLabel("", 8, 40, 76, 17)
	$lblprogresstext = GUICtrlCreateLabel("Download in progress.  Please wait...",20,10, 210, 20)
	$sizeinbytes = InetGetSize($s_URL)
	$intsuccess = InetGet($s_URL, $s_Filename, 0, 1)
	$lbldownloadedpercent = GUICtrlCreateLabel("0%", 312, 40, 32, 17, $SS_RIGHT)
	$lbldownloadedovertotal = GUICtrlCreateLabel("0 KB/" & Int($sizeinbytes / 1024) & " KB", 112, 40, 118, 17, $SS_CENTER)
	GUISetState(@SW_SHOW)
	$intsuccess = ""
	$lastbytes = 0
	$timestamp = TimerInit()
	$timestamp2 = TimerInit()
	While @InetGetActive = 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then
			$iMsgBoxAnswer = MsgBox(308, "Abort?", "Are you sure you want to abort this update?  All current download progress will be lost." & @CRLF & @CRLF & "Are you still sure you want to cancel this download and all its current progress?" & @CRLF & '(Clicking the "No" button will continue the download.)')
			Select
				Case $iMsgBoxAnswer = 6 ;Yes
					InetGet("abort")
					Close($s_Filename)
				Case $iMsgBoxAnswer = 7 ;No
					;Do nothing and continue downloading
			EndSelect
		EndIf
		If TimerDiff($timestamp) >= 1000 Then
			GUICtrlSetData($lbldownloadspeed, Int((@InetGetBytesRead - $lastbytes) / 1024) & " KB/s")
			$lastbytes = @InetGetBytesRead
			$timestamp = TimerInit()
		EndIf
		If TimerDiff($timestamp2) >= 50 Then
			GUICtrlSetData($lbldownloadedovertotal, Int(@InetGetBytesRead / 1024) & " KB/" & Int($sizeinbytes / 1024) & " KB")
			GUICtrlSetData($downloadprogress, (@InetGetBytesRead / $sizeinbytes) * 100)
			GUICtrlSetData($lbldownloadedpercent, Int(@InetGetBytesRead / $sizeinbytes * 100) & "%")
			$timestamp2 = TimerInit()
		EndIf
	WEnd
EndFunc   ;==>DownloadFile

Func Close($s_Filename)
	Sleep(100)
	FileDelete($s_Filename)
	Exit
EndFunc   ;==>Close