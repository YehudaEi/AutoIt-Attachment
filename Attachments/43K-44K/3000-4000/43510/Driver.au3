
#include <array.au3>
#include <date.au3>
#include <string.au3>
#include <WinAPIFiles.au3>

;------------------------------------------------------------------------------
; create a test file - all you need is to set $fname
;------------------------------------------------------------------------------

Local $ip_out, $fname = @ScriptDir & '\ip.txt'
For $1 = 1 To 57
	$ip_out &= '99.' & Random(0, 255, 1) & '.' & Random(0, 255, 1) & '.' & Random(0, 255, 1) & @CRLF
Next
FileDelete($fname)
FileWrite($fname, $ip_out)

;------------------------------------------------------------------------------
; create and populate the array of items that we want action on
;------------------------------------------------------------------------------

l (_stringrepeat('=+=',5) & ' Start Multi Runner at ' & _now() & ' ' & _stringrepeat('=+=',5))

Local Enum $item, $start_time, $end_time, $pid, $end_enum ; array control enumerations
Local $aTMP = StringSplit(FileRead($fname), @CRLF, 3)
Local $aAction_Items[UBound($aTMP)][$end_enum]

For $1 = 0 To UBound($aTMP) - 1
	$aAction_Items[$1][$item] = $aTMP[$1]
Next

_arraydelete($aAction_Items,ubound($aAction_Items))	;	delete blank entry at end

;------------------------------------------------------------------------------
; start Multi Runner
;------------------------------------------------------------------------------


Local $MaxRunAllowed = 10 ; max # to run concurrently

local $console_out = true ; write control array to console for testing / verification
Local $NumberRunning = 0 ; # of currently running processes
Local $bKeepRunning = True ; switch to indicate end of processing
local $SlaveScript	=	@scriptdir & '\slave.au3' ; script to execute with parm (line from your file)

While $bKeepRunning

	$bKeepRunning = False

	; check for starts
	For $1 = 0 To UBound($aAction_Items) - 1

		If $aAction_Items[$1][$pid] = '' Then
			$bKeepRunning = True
			$aAction_Items[$1][$pid] = _start($aAction_Items[$1][$item])
			if $aAction_Items[$1][$pid] <> '' then
				$aAction_Items[$1][$start_time] = _Now()
				$NumberRunning += 1
			endif
			continueloop
		endif

		; check for ends
		If $aAction_Items[$1][$end_time] = '' Then
			$bKeepRunning = true
			If ProcessExists($aAction_Items[$1][$pid]) Then
				ContinueLoop
			else
				$aAction_Items[$1][$end_time] = _Now()
				$NumberRunning -= 1
			endif
		EndIf

	Next

WEnd

; used to compare start/end times from this script to actual times from log

if $console_out then
	ConsoleWrite('' & @LF)
	ConsoleWrite(stringformat('%-30s %-20s %-20s %5s','Item / Parm','Start','End','PID') & @LF)
	for $1 = 0 to ubound($aAction_Items) - 1
		ConsoleWrite(stringformat('%-30s %-20s %-20s %05i', _
			$aAction_Items[$1][$item],$aAction_Items[$1][$start_time],$aAction_Items[$1][$end_time],$aAction_Items[$1][$pid]) & @LF)
	Next
endif

Func _start($parm)

	if $NumberRunning < $MaxRunAllowed then
		return Run(@AutoItExe & ' /AutoIt3ExecuteScript "' & $SlaveScript & '" ' & $parm)
	Else
		return ''
	endif

EndFunc   ;==>_start

Func l($str)

	; This function is also in the test script.  For production use
	; it would be better to have this in some user include file
	; so that all updates can occur in one place

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
