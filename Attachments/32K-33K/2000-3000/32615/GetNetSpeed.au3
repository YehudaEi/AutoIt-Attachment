; UDF: GetNetSpeed()
; Date Released: October 30, 2010
; Last Modified: December 10, 2010
; AutoIt3 v3.3.6
;
Global $DnStartBytes, $UpStartBytes, $GNSInit = 0, $tGNS = 0
; #FUNCTION# =======================================================================
; Name...........: GetNetSpeed
; Description ...: Obtains the current pc network speed
; Syntax.........: $var = GetNetSpeed()
; Return values .: Success: Returns an array
;                           [0] = Number of items in array
;                           [1] = Download Speed
;                           [2] = Upload Speed
;                  Sets @error -1 if ObjGet fails
;                  Sets @error -2 if not object
; Author ........: ripdad
; Modified.......: December 10, 2010 - (1) Changed the way script works
;                                      (2) Added code for unforseen WMI returns
;                                      (3) Added bps
; Remarks .......: Download/Upload speed in mb's/sec
;                  Example1: 9,217.000 = 9.2mbps
;                  Example2: 0,175.000 = 175kbps
;                  Example3: 0,004.000 = 4kbps
;                  Example4: 0,000.007 = 7bps
; Link ..........: http://www.autoitscript.com/forum/index.php?showtopic=121508
; Example .......: Yes
; ==================================================================================
Func GetNetSpeed()
    Local $DnBytes, $UpBytes, $p, $ss, $dTemp, $uTemp, $Name1
	$Name1 = "WAN [PPP_SLIP] Interface"
    Local $objWMIService = ObjGet("winmgmts:\\.\root\cimv2")
    If @error Then Return SetError(-1)

    Local $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_Tcpip_NetworkInterface WHERE Name='"& $Name1 &"'", "WQL", 0x10 + 0x20)
    If Not IsObj($colItems) Then Return SetError(-2)
    For $objItem In $colItems
        If $GNSInit = 1 Then
            $DnBytes = $objItem.BytesReceivedPerSec
            $UpBytes = $objItem.BytesSentPerSec
			$p = TimerDiff($tGNS)
            ExitLoop
        Else
            ; We have to get our starting point .. otherwise, none of this will work.
            ; Both sets will start off with the same byte counts.
            $DnStartBytes = $objItem.BytesReceivedPerSec
            $UpStartBytes = $objItem.BytesSentPerSec
            $DnBytes = $DnStartBytes
            $UpBytes = $UpStartBytes
            $GNSInit = 1		
            ExitLoop
        EndIf
    Next

    ; If strange returns occur .. this will take care of negative numbers and blank or other strings
    If Not StringIsDigit($DnBytes) Then
	    ;ConsoleWrite("not return a D number" & "--" & $DnBytes & @CRLF)                                        
		$DnBytes = 0
	;Else
 	    ;ConsoleWrite($p & "--" & $DnBytes - $DnStartBytes & @CRLF)
	EndIf	
    If Not StringIsDigit($UpBytes) Then $UpBytes = 0
	
    ; Do some math
    $dTemp = $DnBytes
    $uTemp = $UpBytes
    $DnBytes = ($DnBytes - $DnStartBytes) / 1024 / 1024
    $DnBytes = StringLeft($DnBytes / ($p / 1000), 8)
    $UpBytes = ($UpBytes - $UpStartBytes) / 1024 / 1024
    $UpBytes = StringLeft($UpBytes / ($p / 1000), 8)
    $DnStartBytes = $dTemp
    $UpStartBytes = $uTemp

    ; You can change the way it displays by changing these sections below:
    ; $ss[1] = mbps | StringLeft($ss[2], 3) = kbps | StringRight($ss[2], 3) = bps
    ; example below will omit bps and use a decimal point instead of a comma:
    ; $DnBytes = $ss[1] & '.' & StringLeft($ss[2], 3)
    If $DnBytes > 0 Then
        $ss = StringSplit($DnBytes, '.')
        $DnBytes = $ss[1] & ',' & StringLeft($ss[2], 3) & '.' & StringRight($ss[2], 3)
    EndIf
    If $UpBytes > 0 Then
        $ss = StringSplit($UpBytes, '.')
        $UpBytes = $ss[1] & ',' & StringLeft($ss[2], 3) & '.' & StringRight($ss[2], 3)
    EndIf

    $tGNS = TimerInit(); Reset timer
    Return StringSplit($DnBytes & '|' & $UpBytes, '|'); Return speeds
EndFunc
