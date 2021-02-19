#Include <Array.au3>

Global $process_file, $t_diff2 = 0

$data_dir = @WorkingDir&"/Data"

$t_init2 = TimerInit()
$t_init = TimerInit()
$x = 1
While $t_diff2/1000/60/60 <= 24
	$processlist_ar = ProcessList()
	$tCur = String(@YEAR&"/"&@MON&"/"&@MDAY&" "&@HOUR&":"&@MIN&":"&@SEC)
	Sleep(10000)
	$t_diff2 = TimerDiff($t_init2)
	If TimerDiff($t_init) >= 60000 Then
		$t_init = TimerInit()
		$i = 1
		Do
			$processstats_ar = ProcessGetStats($processlist_ar[$i][1], 0)
			If IsArray($processstats_ar) Then
				$processstats_ar[0] = $processstats_ar[0]/1024
				$processstats_ar[1] = $processstats_ar[1]/1024
				If FileExists($data_dir&"/"&$processlist_ar[$i][0]&".log") = 0 Then
					$process_file = FileOpen($data_dir&"/"&$processlist_ar[$i][0]&".log", 2)
				Else
					$process_file = FileOpen($data_dir&"/"&$processlist_ar[$i][0]&".log", 1)
				EndIf
				FileWriteLine($process_file, $processlist_ar[$i][0]&"<>"&$processstats_ar[0]&"<>"&$tCur)
				FileClose($process_file)
			EndIf

			$i = $i + 1
		Until $i = $processlist_ar[0][0]
	EndIf
	$x = $x + 1
WEnd