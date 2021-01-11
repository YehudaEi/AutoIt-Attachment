; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Brad Reddicopp (A.K.A. Spyrorocks) <brad_sp@hotmail.com>
;
; Script Function:
;	Gives msn messenger control to AutoIt
;
; ----------------------------------------------------------------------------

#include <Array.au3>

func _msncreate()
$msn = ObjCreate('messenger.msgrobject')
$msn2 = ObjCreate('Messenger.MessengerApp')
$functions = ObjEvent($msn,"_msn_")
Dim $val
$val = _ArrayCreate("", $msn, $msn2)
if IsObj($val[1]) and IsObj($val[2]) then
	return $val
	else
	return 0
endif
endfunc

func _msngetname($object)
if IsObj($object[1]) then 
	$name = $object[1].LocalFriendlyName
	else
	$name = 0
endif
return $name
endfunc

func _msngetemailaddress($object)
if IsObj($object[1]) then 
	$name = $object[1].LocalLogonName
	else
	$name = 0
endif
return $name
endfunc

func _msnsetstate($object, $state)
	if not IsObj($object[1]) then return 0
	if $state = "offline" then $state = 1
	if $state = "online" then $state = 2
	if $state = "invisible" then $state = 6
	if $state = "out to lunch" then $state = 66
	if $state = "on the phone" then $state = 50
	if $state = "idle" then $state = 18
	if $state = "away" then $state = 34
	if $state = "brb" then $state = 14
	if not StringIsDigit($state) then return -1
$object[1].LocalState = $state
return $state
endfunc

func _msnlogoff($object)
if IsObj($object[1]) then
$object[1].Logoff
return 1
else
return 0
endif
endfunc

func _msngetstate($object)
if not IsObj($object[1]) then return 0
$state = $object[1].LocalState
	if $state = 1 then $state = "offline"
	if $state = 2 then $state = "online"
	if $state = 6 then $state = "invisible"
	if $state = 66 then $state = "out to lunch"
	if $state = 50 then $state = "on the phone"
	if $state = 18 then $state = "idle"
	if $state = 34 then $state = "away"
	if $state = 14 then $state = "brb"
	if $state = 512 then $state = "Connecting to Server"
	if $state = 1024 then $state = "Disconnecting from Server"
	if $state = 256 then $state = "Finding Server"
	if $state = 768 then $state = "Synchronizing with Server"
if not StringIsDigit($state) then
return $state
else
return 0
endif
endfunc

func _msnlogin($object)
if not IsObj($object[2]) then return 0
$object[2].autologin
return 1
endfunc

func _msnopenchatwindow($object, $email)
if not IsObj($object[2]) then return 0
$object = $object[2]
$win = $object.LaunchIMUI($email)
return $win
endfunc

func _msnclosechatwindow($win)
if not IsObj($win) then return 0
$win.Close
return 1
endfunc


func _msnsendtext($win, $msg)
if not IsObj($win) then return 0
$win.SendText($msg)
return 1
endfunc

func _msnwindowmembers($win)
if not IsObj($win) then return 0
$mem = $win.Members.Count
return $mem
endfunc

func _msngetchattext($win)
if not IsObj($win) then return 0
$his = $win.History
return $his
endfunc

