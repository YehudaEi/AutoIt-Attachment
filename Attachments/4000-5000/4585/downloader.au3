; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1
; Author:         Felix N. <felixix@gmail.com>
;
; Script Function:
;	(Small) Download script with GUI!
;
; ----------------------------------------------------------------------------

#include <GuiConstants.au3>
#include "Progress.au3"

HotKeySet("{Esc}","_StopDownloading")

If Not IsDeclared('Dark_Green') Then Dim $Dark_Green = 0x006400
If Not IsDeclared('Red') Then Dim $Red = 0xff0000
If Not IsDeclared('Yellow') Then Dim $Yellow = 0xffff00

GuiCreate("Downloader 1.0b", 380, 230)

;~ $Progress_1 = GuiCtrlCreateProgress(20, 140, 340, 20)
$Progress_1 = _Progress_Create (20, 140, 340, 20, -1, -1, $Dark_Green, -1, $Yellow)
$Button_ok = GuiCtrlCreateButton("Download", 20, 180, 160, 30)
$Button_exit = GuiCtrlCreateButton("Exit", 200, 180, 160, 30)
$Input_from = GuiCtrlCreateInput("", 70, 20, 291, 20)
$Input_to = GuiCtrlCreateInput("", 70, 50, 230, 20)
$Label_6 = GuiCtrlCreateLabel("File:", 10, 20, 50, 20)
$Label_7 = GuiCtrlCreateLabel("Save to:", 10, 50, 50, 20)
$Button_browse = GuiCtrlCreateButton("Browse", 310, 50, 50, 20)
$Label_9 = GuiCtrlCreateLabel("Filesize:", 40, 80, 50, 20)
$Input_size = GuiCtrlCreateInput("", 100, 80, 110, 20)
$file_found = 0

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Button_ok
		$Path_from = GUICtrlRead($Input_from)
		If $Path_from = "" Then
			MsgBox (16, "Please specify a file to download", "No file to download specified!")
			ContinueLoop
		EndIf
		$Path_to = GUICtrlRead($Input_to)
		If $Path_to = "" Then
			MsgBox (16, "Please specify a local path", "No local path specified!")
			ContinueLoop
		EndIf
		$rmtfile_size = InetGetSize ($Path_from)
			If $rmtfile_size = 0 Then
				MsgBox (16, "File not found!", "File not found or" & @CRLF & "connection error!" & @CRLF & "Please check link and try again!")
				GUICtrlSetData($Input_size, " - file not found - ")
			Else
				GUICtrlSetData($Input_size, $rmtfile_size)
				$file_found = 1
			EndIf
		If $file_found = 1 Then
			$filename = StringTrimLeft($Path_from,StringInStr($Path_from,"/",0,-1))
			$localfile = $Path_to & "\" & $filename
			$dl = InetGet ($Path_from, $localfile, 0, 1)
			If $dl = 0 Then
				$file_found = 0
				MsgBox(16,"Error while downloading","An error occurred!" & @CRLF & "Please try again!")
				ContinueLoop
			Else
				$tmp_percent = 0
				$Download = 1
				_Progress_Update ($Progress_1, 0)
				While @InetGetBytesRead < $rmtfile_size
					$percent_done = Int((@InetGetBytesRead / $rmtfile_size) * 100)
					If $percent_done <> $tmp_percent Then 
						_Progress_Update ($Progress_1, $percent_done)
						$tmp_percent = $percent_done
					EndIf
;~ 					GUICtrlSetData($Progress_1,$percent_done
					If Not $Download Then ExitLoop
					Sleep ( 250 )
				WEnd
				If $Download Then
					_Progress_Update ($Progress_1, 100)
					MsgBox(64,"Download finished!","Download finished!" & @CRLF & "File can be found at:" & @CRLF & $localfile)
				Else
					_Progress_Update ($Progress_1, 0)
					MsgBox(64,"Download Canceled!","User canceled the Download")
				EndIf
			EndIf
		Else
			MsgBox(16,"Error while downloading","An error occurred!" & @CRLF & "Please try again!")
		EndIf
			
	Case $msg = $Button_browse ;browse button pressed
            $Input_to_tmp = FileSelectFolder ( "Save to:", "" , 7) ;select folder dialog
            If @error Then ContinueLoop
			GUICtrlSetData($Input_to, $Input_to_tmp) ;put path into input field
	Case $msg = $Button_exit ;exit button pressed
		ExitLoop ;exit program
	EndSelect
WEnd
Exit

Func _StopDownloading()
	$Download = 0
	InetGet("abort")
EndFunc