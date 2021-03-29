#include "UrlDownloadEx.au3"


HotKeySet("{ESC}","_exit")
Global $t1 = TimerInit()
ProgressOn("Exit with {ESC}", "Download 50mb","Start download...")
AdlibRegister("_update",250)



Global $vResult = UrlDownloadEx("                                           ", @ScriptDir & "\[temp]50MB.zip", 1, BytesReceived);Quite the same speed over the complete download
ConsoleWrite(StringFormat("Result:\t%s\nSize:\t%u\nError:\t%u\nTimer:\t%u\n", $vResult, @extended, @error, TimerDiff($t1)))
AdlibRegister("_update",1000)

If Not BytesReceived(0,0,0,0) Then Exit;if abborted, exit

Global $vResult = UrlDownloadEx("                                           ", @ScriptDir & "\[temp]50MB2.zip", Default, BytesReceived);speed differ from time to time. you have to but an higher amout of MS in the AdlibRegister (like 1000 instead of 250)
ConsoleWrite(StringFormat("Result:\t%s\nSize:\t%u\nError:\t%u\nTimer:\t%u\n", $vResult, @extended, @error, TimerDiff($t1)))

Func BytesReceived($iReceivedBytes, $iTotalReceivedBytes, $iDownloadSize, $vParam)
	Local Static $hTimer = TimerInit(), $iBytes, $iKbS, $sKbS, $iDownloadSize2, $iTotalReceivedBytes2, $fExit = False
	If $vParam = 1 Then
		ProgressSet($iTotalReceivedBytes2 / $iDownloadSize2 * 100, StringFormat("%.1f%%\r\n%.2f %s",$iTotalReceivedBytes2 / $iDownloadSize2 * 100,$iKbS,$sKbS))
		Local $iTime = 0
		$iKbS = 1000 / TimerDiff($hTimer) * $iBytes
		While $iKbS > 1000
			$iTime += 1
			$iKbS /= 1024
		WEnd
		Switch $iTime
			Case 0
				$sKbS = "Bytes/s"
			Case 1
				$sKbS = "KB/s"
			Case 2
				$sKbS = "MB/s"
			Case 3
				$sKbS = "GB/s"
		EndSwitch

		$iKbS = $iKbS
		$hTimer = TimerInit()
		$iBytes = 0
	ElseIf $vParam = 2 Then
		$fExit = True
	Else
		$iBytes += $iReceivedBytes
		$iDownloadSize2 = $iDownloadSize
		$iTotalReceivedBytes2 = $iTotalReceivedBytes
	EndIf
	Return Not $fExit
EndFunc   ;==>BytesReceived


Func _update()
	BytesReceived(0, 0, 0, 1)
EndFunc   ;==>speed

Func _exit()
	BytesReceived(0, 0, 0, 2)
EndFunc
