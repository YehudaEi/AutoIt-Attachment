#cs
vi:ts=4 sw=4:

_GetIPFromMAC
Ejoc
Apr 10, 2005
#ce
#include <file.au3>
#include-once


;	_GetIPFromMAC
;	Arguments:
;		$mac 		The MAC Address "00-00-00-00-00-00" or "00:00:00:00:00:00"
;		$IP_Start	Starting IP address
;		$IP_Stop	Ending IP address
;
;	Return Codes:
;		MAC Address / Not "" = Success
;		"" Failure
Func _GetIPFromMAC($mac, $IP_Start = "192.168.1.100", $IP_Stop = "192.168.1.150", $Last_Known_IP = "")
	Local $i,$szBaseAddr,$lpStart,$lpStop,$iA,$iB,$iC,$iBStart,$iBStop
	Local $iCStart,$iCStop,$lpArp,$szMAC,$lpIP,$szIP

	If $Last_Known_IP <> "" Then
		$szIP	= _GetIPFromMAC($mac,$Last_Known_IP,$Last_Known_IP)
		if $szIP <> "" Then Return $szIP
	Endif

	$lpStart	= StringSplit($IP_Start,".")
	$lpStop		= StringSplit($IP_Stop,".")
	$szMAC		= StringReplace($mac,":","-")

	; Mac sure the MAC is the right length
	if StringLen($szMAC) <> 17 Then Return ""

	; Make sure the Start and Stop IP's are valid IP's
	If $lpStart[0] <> 4 Or $lpStop[0] <> 4 Then Return "" 

	For $i = 1 To 3
		if $lpStart[$i] < 0 Or $lpStart[$i] > 255 Then Return ""
		if $lpStop[$i] < 0 Or $lpStop[$i] > 255 Then Return ""
	Next

	if $lpStart[4] < 1 Or $lpStart[4] > 255 Then Return ""
	if $lpStop[4] < 1 Or $lpStop[4] > 255 Then Return ""

	;Start looping thru the IP address'
	For $iA = $lpStart[2] To $lpStop[2]		; 192.0.x.x -> 192.255.x.x
		if $iA <> $lpStart[2] Then			; When you roll over to 192.1
			$iBStart	= 0					; you need to start a 192.1.0.x
		Else
			$iBStart	= $lpStart[3]
		EndIf

		if $iA <> $lpStop[2] Then			; if you are on 192.0.x.x
			$iBStop		= 255				; you need to go all the way to
		Else								; 192.0.255.x
			$iBStop		= $lpStop[3]
		Endif
			
		For $iB = $iBStart To $iBStop		; 192.0.0.x -> 192.0.255.x
			if $iB <> $iBStart Then
				$iCStart	= 1
			Else
				$iCStart	= $lpStart[4]
			Endif

			if $iB <> $iBStop Then
				$iCStop		= 255
			Else
				$iCStop		= $lpStop[4]
			Endif

			For $iC = $iCStart To $iCStop
				$szBaseAddr	= $lpStart[1] & "." & $iA & "." & $iB & "." & $iC
				Ping($szBaseAddr,50)

				;Check arp every 10 pings or when you are done
				if (Not Mod($iC,10)) Or ($iC = $iCStop) Then
					RunWait(@Comspec & ' /c arp -a > "' & @TempDir & '\~arp.tmp"',"",@SW_HIDE)
					_FileReadToArray(@TempDir & '\~arp.tmp',$lpArp)
					For $i = 1 To $lpArp[0]
						If StringinStr($lpArp[$i],$szMAC) Then ; Found it
							$szIP	= StringLeft($lpArp[$i],StringinStr($lpArp[$i],$szMAC)-1)
							$szIP	= StringStripWS($szIP,8)
							Return $szIP
						Endif
					Next
				Endif ; Check Arp
			Next ; 192.168.1.X
		Next ; 192.168.x.x
	Next ; 192.x.x.x
	
	return "" ; Didn't find it
EndFunc

