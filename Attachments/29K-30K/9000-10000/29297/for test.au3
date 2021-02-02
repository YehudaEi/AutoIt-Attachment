#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#cs --------------------------------------------------
	Show a taskbar button with a variable text, a defined icon
	Show tray icon variable tool tip

#ce ------------------------------------------------


$mynumber=10
$mytext="Still " & $mynumber & " steps"
$mytxt=$mynumber & " steps"
$mygui =GUICreate ($mytxt,240,70,@DesktopWidth + 300, @DesktopHeight + 300, -1, -1)
GUISetIcon( "shell32.dll", 14,$mygui)
GUISetState(@SW_SHOW )
$thenumber=0
TraySetState()
TraySetIcon ( "shell32.dll", 14 )
TraySetToolTip($mytext)
for $i=1 to $mynumber
	$thenumber=$thenumber+1
	$mytext=$thenumber & " steps passed on " & $mynumber
	$mytxt=$thenumber & " / " & $mynumber
	WinSetTitle($mygui,"",$mytxt)
	TraySetToolTip($mytext)
	sleep (1000)
next

GUIDelete($mygui)

$mytext= "END : " & $mynumber & " steps passed."

TraySetToolTip($mytext)

$gui =GUICreate ("Finished",240,70,-1)
$mylabel=GUICtrlCreateLabel($mytext,10,10,220,50,1)
GUISetState(@SW_SHOW )

While 2
        $msg = GUIGetMsg()
        If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd

GUIDelete($gui)

exit
