
#cs
dhcp_reservation_copy.au3
-John Taylor
Mar-7-2006

This program is used to copy DHCP reservations from one DHCP server
to another.  You run it for each scope.  Set $total to the number
of reservations in the current scope.
#ce


; change this to the number of reservations in the scope you want to copy
$total=4



Global $n[$total+1], $ip[$total+1], $m[$total+1], $d[$total+1]
MsgBox(0,"Instructions...", "Go to DHCP on the old server, expand the Reservations tree of the scope you want to copy, and single-click on the first reservation." & @CRLF & "You will have 7 seconds after clicking OK.")
sleep(7000)

Func One_Entry($j)
	Global $n, $i, $m, $d
	; source reservation
	send("!{enter}")
	$name = ControlGetText("","","Edit1")
	$ip1 = ControlGetText("","", "Edit2")
	$ip2 = ControlGetText("","", "Edit3")
	$ip3 = ControlGetText("","", "Edit4")
	$ip4 = ControlGetText("","", "Edit5")
	$mac = ControlGetText("","","Edit6")
	$desc = ControlGetText("","","Edit7")
	;MsgBox(0,"Name", $name)
	;MsgBox(0, "IP", $ip1 & "." & $ip2 & "." & $ip3 & "." & $ip4)
	;MsgBox(0,"Mac", $mac)
	;MsgBox(0,"Desc", $desc)

	$n[$j] = $name
	$ip[$j] = $ip4
	$m[$j] = $mac
	$d[$j] = $desc

	sleep(1200)
	; Cancel is "Button6"
	ControlClick("","","Button6")
EndFunc

for $j=1 to $total
	One_Entry($j)
	sleep(1200)
	send("{DOWN}")
	sleep(1200)
Next


MsgBox(0,"Instructions...", "Go to Reservations on the new server, then right-click to activate the New Reservation sub-window." & @CRLF & "You will have 7 seconds after clicking OK.")
sleep(7000)

for $j=1 to $total
	ControlSetText("","","Edit1",$n[$j])
	ControlSetText("","","Edit5",$ip[$j])
	ControlSetText("","","Edit6",$m[$j])
	ControlSetText("","","Edit7",$d[$j])
	sleep(1000)
	; Add is "Button5"
	ControlClick("","","Button5")
	sleep(2000)
next



; Cancel is "Button6"
ControlClick("","","Button6")
sleep(333)
MsgBox(0,"Finished", "Added " & $j-1 & " entries into DHCP!")


