#include-once
#include <Constants.au3>
#Include <File.au3>
#Include <Array.au3>
#Include <Services.au3>
#Region Header
#cs
	Title:   		ZapSPF
	Filename:  		ZapSPF.au3
	Description: 	A tool for disabling and killing services, processes and files
	Author:   		seangriffin
	Version:  		V0.4
	Last Update: 	14/02/12
	Requirements: 	AutoIt3 3.2 or higher
	Changelog:
					---------14/02/12---------- v0.4
					Added a service shutdown feature.
					Renamed the script to ZapSPF.
					Added a log file "ZapSPF.log".

					---------26/03/10---------- v0.3
					Moved directory scanning to occur after process deletion.

					---------28/02/10---------- v0.2
					Added TrayTips to report progress during startup.

					---------12/02/10---------- v0.1
					Initial release.
#ce
#EndRegion Header
#Region Global Variables and Constants
Global $num_files, $num_files_recycled, $num_files_left, $num_bytes_left

#EndRegion Global Variables and Constants
#Region Local Variables and Constants
Dim $szDrive, $szDir, $szFName, $szExt
dim $process, $kill_count, $line, $processes_start_index, $processes_end_index
dim $services_dict = ObjCreate("Scripting.Dictionary")
dim $processes_dict = ObjCreate("Scripting.Dictionary")
dim $file_folders_dict = ObjCreate("Scripting.Dictionary")
#EndRegion Local Variables and Constants


TrayTip("ZapSPF", "Starting up...", 30)

; Hotkey definition

TrayTip("ZapSPF", "Defining hotkeys...", 30)
HotKeySet("{Esc}", "captureEsc")
HotKeySet("{F2}", "captureF2")

; Read the processes to kill, and files to delete

TrayTip("ZapSPF", "Reading config...", 30)
$res = _FileReadToArray(@ScriptDir & "\ZapSPF.ini", $line)

; Determine how many processes will be killed

$zap_type = ""
$num_files = 0
for $i = 1 to (UBound($line) - 1)

	Switch $line[$i]

		Case "[Services]"

			$zap_type = "services"

		case "[Processes]"

			$zap_type = "processes"

		case "[File Folders]"

			$zap_type = "file folders"

		case Else

			Switch $zap_type

				Case "services"

					$services_part = StringSplit($line[$i], "|")
					$services_dict.item($services_part[1]) = $services_part[2]

				Case "processes"

					$processes_part = StringSplit($line[$i], "|")
					$processes_dict.item($processes_part[1]) = $processes_part[2]

				Case "file folders"

					$file_folders_dict.item($line[$i]) = ""
			EndSwitch
	EndSwitch
Next

TrayTip("ZapSPF", "", 0)

; Disable and stop services

$services_keys = $services_dict.keys
$service_count = 0

ProgressOn("ZapSPF", "disabling services | ESC=abort | F2=config", $service_count & " of " & UBound($services_keys))

for $each in $services_keys

	$service_disabled_stopped = False
	$arr = _Service_QueryConfig($services_dict.item($each))
	;_ArrayDisplay($arr)

	; if the service is not disabled
	if $arr[1] <> 4 Then

		; Disable the service
		_Service_SetStartType($services_dict.item($each),$SERVICE_DISABLED)
;		ShellExecute("sc", "config " & $services_dict.item($each) & " start= disabled", "", "", @SW_HIDE)
		$service_disabled_stopped = True
	EndIf

	$arr = _Service_QueryStatus($services_dict.item($each))
	;_ArrayDisplay($arr)

	; if the service is not stopped
	if $arr[1] <> 1 Then

		; Stop the service
		_Service_Stop($services_dict.item($each))
;		ShellExecute("sc", "stop " & $services_dict.item($each), "", "", @SW_HIDE)
		$service_disabled_stopped = True
	EndIf

	; if the service got stopped by ZapSPF
	if $service_disabled_stopped = True Then

		$log_msg = "Stopped and disabled service " & $services_dict.item($each)
		ConsoleWrite($log_msg & @CRLF)
		_FileWriteLog(@ScriptDir & "\ZapSPF.log", $log_msg)
	EndIf

	$service_count = $service_count + 1
	$pcnt_complete = Int($service_count / UBound($services_keys) * 100)
	ProgressSet($pcnt_complete, $service_count & " of " & UBound($services_keys) & " - " & $each)
Next

ProgressOff()

; Kill Processes

$processes_keys = $processes_dict.keys
$process_count = 0

ProgressOn("ZapSPF", "killing processes | ESC=abort | F2=config", $process_count & " of " & UBound($processes_keys))

for $each in $processes_keys

	while ProcessExists($processes_dict.item($each))

		ProcessClose($processes_dict.item($each))

		$log_msg = "Killed process " & $processes_dict.item($each)
		ConsoleWrite($log_msg & @CRLF)
		_FileWriteLog(@ScriptDir & "\ZapSPF.log", $log_msg)

		Sleep(100)
	WEnd

	$process_count = $process_count + 1
	$pcnt_complete = Int($process_count / UBound($processes_keys) * 100)
	ProgressSet($pcnt_complete, $process_count & " of " & UBound($processes_keys) & " - " & $each)
Next

ProgressOff()

; Determine how many files will be deleted

$num_files = 0
$num_bytes = 0
$file_folders_keys = $file_folders_dict.keys
$file_folders_count = 0

for $each in $file_folders_keys

	$file_folders_count = $file_folders_count + 1

	TrayTip("ZapSPF", "Scanning folder #" & $file_folders_count & " of " & UBound($file_folders_keys) & "...", 30)

	$num_items = _CountFiles($each)
;	ConsoleWrite("$line[$i]=" & $line[$i] & ", $num_items[0]=" & $num_items[0] & "$num_items[1]=" & $num_items[1] & @CRLF)
	$num_files = $num_files + $num_items[0]
	$num_bytes = $num_bytes + $num_items[1]
Next

; Delete Files

$num_files_left = $num_files
$num_bytes_left = $num_bytes
$num_files_recycled = 0

;ProgressOn("ZapSPF", "recycling files | ESC=abort | F2=config", $process_count & " of " & UBound($processes_keys))
ProgressOn("ZapSPF", "recycling files | ESC=abort | F2=config", "")

for $each in $file_folders_keys

	_RecycleFiles($each)
Next

ProgressOff()


Func _CountFiles($sPath = @ScriptDir)
	#cs
	$files = ""

	Local $pip = Run(@ComSpec &" /c dir /s /b """ & $sPath & """ | find /c "":""","", @SW_HIDE, $STDOUT_CHILD)
    While 1
        $files = $files & StdoutRead($pip)
        If @error Then ExitLoop
    Wend

	Return int($files)
	#ce

	dim $num_items[2]
	$files = ""

	Local $pip = Run(@ComSpec &" /c dir /s """ & $sPath & """ | find ""File(s)""","", @SW_HIDE, $STDOUT_CHILD)
    While 1
        $files = $files & StdoutRead($pip)
        If @error Then ExitLoop
    Wend

	$files = StringRight($files, 45)
	$num_items[0] = StringStripWS(StringLeft($files, StringInStr($files, "File(s)")-1), 8)
	$num_items[1] = StringStripWS(StringReplace(StringReplace(StringMid($files, StringInStr($files, "File(s)") + 8), "bytes", ""), ",", ""), 8)

	Return $num_items

EndFunc

Func _RecycleFiles($sPath = @ScriptDir)

	$files = ""

	Local $pip=Run(@ComSpec &" /c dir /s /b """ & $sPath & """","", @SW_HIDE, $STDOUT_CHILD)
    While 1
        $files = $files & StdoutRead($pip)
        If @error Then ExitLoop
    Wend

	$file = StringSplit($files, @CRLF)

	if @error <> 1 Then

		for $j = 1 to (UBound($file) - 1)

			$filename_recycled = StringMid($file[$j], StringInStr($file[$j], "\", 0, -1) + 1)

			if StringCompare($filename_recycled, "index.dat") <> 0 Then

				if StringCompare($file[$j], "") <> 0 Then

					$filesize = FileGetSize($file[$j])
					FileRecycle($file[$j])

					$log_msg = "Recycled file " & $file[$j]
					ConsoleWrite($log_msg & @CRLF)
					_FileWriteLog(@ScriptDir & "\ZapSPF.log", $log_msg)

					$num_files_recycled = $num_files_recycled + 1
					$num_files_left = $num_files_left - 1
					$num_bytes_left = $num_bytes_left - $filesize

					$progress_pcnt = Int($num_files_recycled / $num_files * 100)

;					$msg = $num_files_recycled & " of " & $num_files & " - " & $filename_recycled
					$msg = $num_files_left & " files (" & Round($num_bytes_left / 1000000, 1) & " Mb) left" & " - " & $filename_recycled
					ProgressSet($progress_pcnt, $msg)
				EndIf
			EndIf
		Next
	EndIf
EndFunc

Func captureEsc()

	HotKeySet("{Esc}")
	HotKeySet("{F2}")
	Exit
EndFunc

Func captureF2()

	ShellExecuteWait(@ScriptDir & "\ZapSPF.ini")
	HotKeySet("{Esc}")
	HotKeySet("{F2}")
	Exit
EndFunc
