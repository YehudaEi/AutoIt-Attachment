#include <GUIConstants.au3>

;TCP starten
TCPStartup ()

;GUI Creation
GuiCreate("Telnet Client", 500, 390,-1, -1 )

;----------> GUI Control Creation Anfang <----------
	
	;Edit Control für Chat Text
	$Edit = GuiCtrlCreateEdit("", 10, 10, 480, 330)
	
	;Input Control für Chat Text Eingabe
	$Input = GuiCtrlCreateInput("", 10, 360, 480, 20)
	
;-----------> GUI Control Creation Ende <-----------

;user input for host and port

$HostI = InputBox ( "Telnet Client", "Please enter the name of the host you want to connect to" )
$PortI = InputBox ( "Telnet Client", "Please enter the port of the host" )


;GUI sichtbar machen

GUISetState ()
ControlSend ( "Telnet Client","", $Edit, "{TAB}")
;Client Hostname auflösen
$Host = TCPNameToIP ( $HostI )

;Mit Host Connecten
$Conection = TCPConnect ( $Host, $PortI )
If @error Then Exit

While 1
	$msg = GuiGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit
	$recv = TCPRecv ( $Conection,2048 )
	If $recv <> "" Then
	$text = GUICtrlRead ( $Edit )
	GUICtrlSetData ( $Edit,$text & $recv )
	ControlSend ( "Telnet Client","", $Edit, "{ENTER}")
	EndIf

	
	If $msg = $Input Then 
		$text = GUICtrlRead ( $Edit )
		$eingabe = GUICtrlRead ( $Input )
		GUICtrlSetData ( $Edit, $text & $eingabe )
		GUICtrlSetData ( $Input, "" )
 		ControlSend ( "Telnet Client","", $Edit, "{ENTER}")
		TCPSend ( $Conection, $eingabe & Chr ( 10 ) )
		

		If @error Then 
			MsgBox (0,"","Error")
			Exit
			EndIf
		EndIf
	WEnd
