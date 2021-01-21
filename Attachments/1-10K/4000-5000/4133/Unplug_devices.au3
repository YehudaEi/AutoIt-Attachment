; Unplug devices.au3
; Requires DevEject

#include <Constants.au3>
;#include <Array.au3>
$devejectpath = "C:\Program Files\deveject2.exe"

;$drives = DriveGetDrive ("FIXED")
;_ArrayDisplay ($drives, "Drives")

$foo = Run('"' & $devejectpath & '" -EjectName:"USB Mass Storage Device"', @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)

$output = ""
While 1
    $output = $output & StdoutRead($foo)
    If @error = -1 Then ExitLoop
Wend
If $output <> "" Then SplashTextOn ("", $output, -1, 100, -1, -1, 1)

$error = ""
While 1
    $error = $error & StdoutRead($foo)
    If @error = -1 Then ExitLoop
Wend
If $error <> "" Then SplashTextOn ("", $error)

;$drivesnow = DriveGetDrive ("REMOVABLE")
;_ArrayDisplay ($drives, "Drives")

Sleep (2000)