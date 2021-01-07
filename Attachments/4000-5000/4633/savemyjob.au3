#NoTrayIcon
Opt("WinTitleMatchMode", 2)

hotkeyset("!+H", "hide")
HotKeySet("!+U", "unhide")

$ie = ObjCreate ("InternetExplorer.Application.1")
$lie=ObjEvent($ie,"IEEvent_","DWebBrowserEvents2") 
$ie.Visible=1
$ie.RegisterAsDropTarget = 1
$ie.RegisterAsBrowser = 1
$ie.Navigate( "http://www.google.com/" )
$ie.Visible=0

func hide()
	$a = WinList ("Microsoft Internet")
	for $i = 1 to $a[0][0] step 1
		If $a[$i][0] <> "" Then
			WinSetState ($a[$i][0], "", @SW_HIDE)
		EndIf
	Next

	$ie.Visible=1
	
EndFunc

func unhide()
	$a = WinList ("Microsoft Internet")
	for $i = 1 to $a[0][0] step 1
		If $a[$i][0] <> "" Then
			WinSetState ($a[$i][0], "", @SW_SHOW)
		EndIf
	Next
	
	$ie.Visible=0
		
EndFunc

while 1
	sleep (1000)
WEnd
