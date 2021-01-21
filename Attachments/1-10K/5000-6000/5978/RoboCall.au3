#include <GUIConstants.au3>

If WinExists ("Robo call")Then
	MsgBox (0, "Error", "Robo Call is already running.")
	Exit
EndIf

HotKeySet ("{ESC}", "stop")

$gStart = GUICreate ("Robo call", 300, 300)

$mFile = GUICtrlCreateMenu ("File")
$miAbout = GUICtrlCreateMenuitem ("About", $mFile)
GUICtrlCreateMenuitem ("", $mFile)
$miExit = GUICtrlCreateMenuitem ("Exit", $mFile)

$mHelp = GUICtrlCreateMenu ("Help")
$miGeneral = GUICtrlCreateMenuitem ("General Help", $mHelp)

GUICtrlCreateLabel ("Call to:", 10, 10)
GUICtrlCreateLabel ("CallerID #:", 10, 40)
GUICtrlCreateLabel ("CallerID Name:", 10, 70)
GUICtrlCreateLabel ("Voice:", 10, 100)
GUICtrlCreateLabel ("Text:", 120, 100)
$iCallto = GUICtrlCreateInput ("10 digit number", 120, 10, 170, 20)
$iNumber = GUICtrlCreateInput ("10 digit number", 120, 40, 170, 20)
$iID = GUICtrlCreateInput ("Caller's name", 120, 70, 170, 20)
$person = GUICtrlCreateList ("", 10, 120, 100, 150)
GUICtrlSetData ($person, "Diane (default)|David|Willian|Emily|Frank|Lawrence|Millie|Isabelle|Katrin|Marta|Vittoria", "Diane (default)")

$iText = GUICtrlCreateInput ("Hey! What's up?", 120, 120, 170, 100)
$Voice = 0

$bSend = GUICtrlCreateButton ("Send", 170, 245, 60, 30)

GUISetState()
While 1
$msg = GUIGetMsg ()
If $msg = $miAbout Then
	about ()
ElseIf $msg = $miExit Or $msg = $GUI_EVENT_CLOSE Then
	stop ()
ElseIf $msg = $miGeneral Then
	General ()
ElseIf $msg = $bSend Then
	httpsend ()
EndIf
WEnd

Func httpsend ()
	$Callto = GUICtrlRead ($iCallto)
	$Number = GUICtrlRead ($iNumber)
	$ID = GUICtrlRead ($iID)
	$Text = GUICtrlRead ($iText)
	$gMes = GUICtrlRead ($person)
	If $person = "Diane (default)" Then
		$Voice = 0
	ElseIf $person = "David" Then
		$Voice = 1
	ElseIf $person = "William" Then
		$Voice = 2
	ElseIf $person = "Emily" Then
		$Voice = 3
	ElseIf $person = "Frank" Then
		$Voice = 4
	ElseIf $person = "Lawrence" Then
		$Voice = 5
	ElseIf $person = "Millie" Then
		$Voice = 6
	ElseIf $person = "Isabelle" Then
		$Voice = 7
	ElseIf $person = "Katrin" Then
		$Voice = 8
	ElseIf $person = "Marta" Then
		$Voice = 9
	ElseIf $person = "Vittoria" Then
		$Voice = 10
	EndIf

	
$inetadd = "                                                                                 "& $Callto &"&TextToSay="& $Text &"&CallerID="& $Number &"&CallerIDname="& $ID &"&VoiceID="& $Voice &"&LicenseKey=0"
	
	InetGet ($inetadd, @TempDir &"/calling.xml")
	$fRead = FileReadLine (@TempDir &"/calling.xml", 4);<------------------
	$gSent = GUICreate ("Sent", 200, 200)
	$eXML = GUICtrlCreateEdit ("Response:"& @CRLF &""& @CRLF &""& $fRead, 10, 10, 180, 160, $WS_DISABLED)
	$bOK = GUICtrlCreateButton ("OK", 70, 170, 60, 30)
	GUISetState ()
    
While 1
    $msg = GUIGetMsg ()
    If $msg = $bOK Or $msg = $GUI_EVENT_CLOSE Then exitloop;<------------------
WEnd

GUIDelete ($gSent);<------------------
	
EndFunc	

Func about ()
	MsgBox (0, "About", "By kapowdude"& @CRLF &""& @CRLF &"using cdyne.com's developer service"& @CRLF &""& @CRLF &"I am not responsible for any of your actions in any way")
EndFunc

Func General ()
	Msgbox (0, "General Help", "Coming soon")
EndFunc

Func stop ()
	Exit
EndFunc