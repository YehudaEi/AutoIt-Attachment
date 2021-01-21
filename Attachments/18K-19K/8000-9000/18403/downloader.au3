#include <GuiConstants.au3>

;$fileLocation = "                                                                                        "
$fileLocation = "http://www.autoitscript.com/cgi-bin/getfile.pl?../autoit3/scite/download/SciTE4AutoIt3.exe"
$fileName = "SciTE4AutoIt3.exe"

;file save
$MyDocsFolder = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"

; GUI
GUICreate("Downloader", 400, 400)
;GuiSetIcon(@SystemDir & "\mspaint.exe", 0)

; Label
GUICtrlCreateLabel("Made by PS", 80, 2)
GUICtrlSetColor(-1, 0xff0CCC)

; size
$totalsize = InetGetSize($fileLocation)
$size = Round($totalsize / 1024 / 1024, 2)

; GROUP
GUICtrlCreateGroup("News", 10, 10, 380, 170)
GUICtrlCreateLabel("* This is a test. Let's see if this works", 20, 30)
GUICtrlSetColor(-2, 0xff0000)

; GROUP
GUICtrlCreateGroup("Download Status", 10, 190, 380, 70)
; PROGRESS
$progress = GUICtrlCreateProgress(20, 210, 360, 15)

; BUTTON
$button1 = GuiCtrlCreateButton("Download", 10, 270, 70, 25)
If $size = 0 Then
	GuiCtrlSetState($button1, $GUI_DISABLE)
EndIf

$button2 = GuiCtrlCreateButton("Abort", 311, 230, 70, 25)
GuiCtrlSetState($button2, $GUI_DISABLE)
; GUI MESSAGE LOOP
GUISetState()

$flag1 = True
$prevDLED = 0
$wait = 20; wait 20ms for next progressstep
$percentage = 0; progressbar-saveposition

; For counter use 
; ConsoleWrite(_INetGetSource('www.autoitscript.com'))
; Use PHP to create a counter that only displays number in its source code

While True
	$msg = GUIGetMsg()
    Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
        Case $msg = $button1
			$var = FileSaveDialog( "Select a location", $MyDocsFolder, "Executable files (*.exe) |Movie Clips (*.avi)", 2, $fileName)
			If @error <> 1 Then
				;MsgBox(4096,"","You chose " & $var)
				InetGet($fileLocation, $var, 1, 1)
				GuiCtrlSetState($button1, $GUI_DISABLE)
				GuiCtrlSetState($button2, $GUI_ENABLE)
				While @InetGetActive
					GUICtrlSetData ($progress,$percentage)
					$m = GUIGetMsg()
					Select
						Case $m = $GUI_EVENT_CLOSE
							ExitLoop
						Case $m = $button2 
							InetGet("abort")
							FileDelete($fileName)
							$flag1 = False
							ExitLoop
						Case Else
							;TrayTip("Downloading", "Bytes = " & @InetGetBytesRead, 10, 16)
							Sleep(250)
							$downloadedSize = @InetGetBytesRead
							$percentage = Round($downloadedSize / $totalsize, 2) * 100
							$label1 = GUICtrlCreateLabel("Downloaded : "& Round($downloadedSize / 1024 / 1024, 2) & "MB / File Size : "& $size & "MB [" & $percentage & "%]", 20, 243, 260, 13)
							GUICtrlSetColor(-1, 0xff0CCC); speed
							$speed = Round(4 * ($downloadedSize - $prevDLED) / 1024 / 1024, 2)
							$label2 = GUICtrlCreateLabel("Download speed : "& $speed & "MB/sec", 20, 228, 260, 13)
							GUICtrlSetColor(-1, 0xff0CCC)
							$prevDLED = $downloadedSize
					EndSelect
					If @InetGetActive <> 1 Then
						ExitLoop
					EndIf
				WEnd
				If $flag1 = True Then
					MsgBox(0, "Success", "Download successful")
				Else
					MsgBox(0, "Abort", "Download aborted")
				EndIf
				GUICtrlSetData ($progress, 0)
				GUICtrlSetData ($label1, "")
				GUICtrlSetData ($label2, "")
				GuiCtrlSetState($button1, $GUI_ENABLE)
				GuiCtrlSetState($button2, $GUI_DISABLE)
				$flag1 = True
			EndIf
    EndSelect
WEnd