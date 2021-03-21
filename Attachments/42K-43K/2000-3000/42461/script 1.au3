#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Script1
#include "MessageHandler.au3"

$Local_ReceiverID_Name = "Script1sReceiverID";This is the ID that the other script will use to send data
$Remote_ReceiverID_Name = "Script2sReceiverID";This is the ID of the script we want to send data too

$hwnd = _SetAsReceiver($Local_ReceiverID_Name)
ConsoleWrite("hwnd of the Local_ReceiverID_Name is " & $hwnd & @crlf)
$myFunc = _SetReceiverFunction("_MyFunc2")
ConsoleWrite("My data receiver function is " & $myFunc & @crlf)


While 1
    Sleep(10000)
WEnd

Func _MyFunc2($vText)
    Msgbox(0,@ScriptName,"I am " & @ScriptName & " I have received some data" & @crlf & @crlf & $vText & @crlf & @crlf & "And now I'm sending the data back")
    $iSent = _SendData($vText,$Remote_ReceiverID_Name)
    Exit
EndFunc