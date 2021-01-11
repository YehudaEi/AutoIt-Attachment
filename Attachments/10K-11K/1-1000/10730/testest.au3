#include <GUIConstants.au3>
AutoItSetOption ( "GUICloseOnESC",0)
#Include <Misc.au3>

$loop = 1

;*************GUI Input Box******************
while $loop = 1
GUICreate("Ping", 135,80) 
$Machine = GUICtrlCreateInput ( "", 10,  5, 110, 20)
$button_1 = GUICtrlCreateButton ("Ok", 15,  55, 40, 20,0x0001)
$button_2 = GUICtrlCreateButton ("Exit", 80,  55, 40, 20)
$Check1 = GUICtrlCreateCheckbox (" -T ", 25, 30)
$Check2 = GUICtrlCreateCheckbox (" -A ", 80, 30)

GUISetState () 
 
$msg = 0
While $msg <> $GUI_EVENT_CLOSE
       $msg = GUIGetMsg()
       Select
		Case $msg = $GUI_EVENT_CLOSE
            Exit   
		Case $msg = $button_1
			exitloop
		Case $msg = $button_2 
			Exit
       EndSelect
   Wend
   
$var = Ping(GUICtrlRead($Machine))
		if $var = 1 Then
			$var2 = "UP!"
		Else 
			$var2 = "DOWN!!"
		EndIf
		
TCPStartup()
$New = TCPNameToIP(GUICtrlRead($Machine))

$ip = (GUICtrlRead($Machine))

$isip = StringRegExp ( $ip, "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}",0) 

if $isip then
    $array1 =  stringsplit($ip,'.')
    $ipcheck = 0
    For $count1 = 1 to $array1[0]
        if int($array1[$count1]) > 255 then $ipcheck += 1
    Next

    if $ipcheck < 1 then
        msgbox(0,"Status ",GUICtrlRead($Machine) & " is " & $var2 )
		;call ("pingmachine")
			
    else
        msgbox(0,"","Invalid ip address(not 4 bytes in size)")
    endif
else
    msgbox(0,GUICtrlRead($Machine) & "'s IP is", $New & " and it is " & $var2 )
	;msgbox(0,GUICtrlRead($Machine),"IP is " & $New)
	;Call ("nametoip")

endif
WEnd