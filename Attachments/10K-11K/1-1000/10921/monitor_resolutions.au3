
; function monitor_resolutions()
; -John Taylor
; Sept-9-2006
;
; returns an array of monitors with their corresponding resolutions
; array[0][0] contains the number of monitors
; array[1][0] is the width of the 1st monitor
; array[1][1] is the height of the 1st monitor

Opt("MustDeclareVars", 1)

Func monitor_resolutions()
	local $wmi_svc, $slots, $monitor
	local $h, $v
	local $i
	local $results[16][2]

	local $debug = 0

	$wmi_svc = ObjGet("winmgmts:\\.\root\CIMV2")
	if "" == $wmi_svc then
		if 1 == $debug then MsgBox(0,"WMI Error", "Can connect to WMI service")
		return -1
	endif

	$slots = $wmi_svc.ExecQuery("SELECT CurrentHorizontalResolution,CurrentVerticalResolution FROM Win32_VideoController", "WQL", (0x10 + 0x20) )

	if Not IsObj( $slots ) then 
		if 1 == $debug then MsgBox(0, "WMI Error", "No WMI objects found")
		return -2
	endif

	; count the number of monitors and
	; iterate through each monitor and populate the $results array
	$i = 0
	for $monitor in $slots
		$h = int($monitor.CurrentHorizontalResolution)
		$v = int($monitor.CurrentVerticalResolution)
		if $h <= 1 or $v <= 1 then ContinueLoop

		$i += 1
		if 1 = $debug then MsgBox(0, "Monitor " & $i, "Resolution : " & $h & "x" & $v)

		$results[$i][0] = $h
		$results[$i][1] = $v
	next
	$results[0][0] = $i

	return $results
EndFunc


; testing
Dim $mon = monitor_resolutions()
Dim $j

for $j = 1 to $mon[0][0]
	MsgBox(0, "Monitor " & $j, $mon[$j][0] & "x" & $mon[$j][1])
next
