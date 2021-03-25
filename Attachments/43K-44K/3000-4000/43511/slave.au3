
#include <WinAPIFiles.au3>
#include <date.au3>
#include <WinAPISys.au3>

if not isarray($cmdline) then
	l('PID = ' & @AutoItPID & ' Exiting...started without a parm...CMDLINERAW = ' & $cmdlineraw)
	exit
else
	l('PID = ' & @AutoItPID & ' started - Parm = ' & $cmdline[1])
endif

SRandom(_WinAPI_GetTickCount() * random(5,15,1))
Local $sleep_time = Random(1000, 15000, 1)
l('PID = ' & @AutoItPID & ' sleep time = ' & $sleep_time)

Sleep($sleep_time)

l('PID = ' & @AutoItPID & ' ended')

Func l($str)

	local $wstr = ''
	While _WinAPI_FileInUse(@ScriptDir & '\log for ip test.log')
		$wstr = _Now() & ' PID = ' & @AutoItPID & ' Waiting...log file in use ' & @CRLF
		Sleep(500)
	WEnd

	$hfl = FileOpen(@ScriptDir & '\log for ip test.log', 1)
	If $hfl = -1 Then
		MsgBox(0, 'log error', @AutoItPID)
		Exit
	EndIf

	if $wstr <> '' then filewrite($hfl,$wstr)
	FileWrite($hfl, _Now() & ' ' & $str & @CRLF)
	FileClose($hfl)
	$hfl = 0

EndFunc   ;==>l
