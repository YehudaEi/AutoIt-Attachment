; this program controls if a removable device is forgotten when you lock a session with ctrl alt suppr

while 1
sleep(100)
If _IsPressed("a5")<>1 Then  ; test if the AltGR key is not pressed. This test avoids that the program executes the function detect() when this key is pressed because AltGR => ctrl +alt (it's not always true but in our case it is)
	if _IsPressed("11") Then ; test if the Ctrl key is pressed
		if _IsPressed("12") Then detect() ;test if the alt key is pressed
	EndIf
EndIf
WEnd


func detect() ; detect if CD or other removable devices  are forgotten 
$alarme=0
$listsupport=""
$tab_cd=DriveGetDrive ( "CDROM" ) ; list all cd rom drives
If @error<>1 Then
	For $cpt=1 To $tab_cd[0] ; test the status for each drive
		$status= DriveStatus($tab_cd[$cpt])
		If $status="READY" Then 
			Run(@ComSpec & " /c "&chr(7),"",@SW_HIDE) ; use the bell to alert (the intern speaker must be connected ...)
			$alarme=1
			$listsupport=$listsupport&$tab_cd[$cpt]&@CRLF ; store the drive where the CD is present
		EndIf
	Next
EndIf
$tab_remov=DriveGetDrive ( "REMOVABLE" ) ; list all removable devices
If @error<>1 Then
	For $cpt=1 To $tab_remov[0]
		$status=DriveStatus($tab_remov[$cpt])
		If $status="READY" Then 
			Run(@ComSpec & " /c "&chr(7),"",@SW_HIDE)
			$alarme=1
			$listsupport=$listsupport&$tab_remov[$cpt]&@CRLF; store the drive where the device is present
		EndIf
	Next
EndIf
if $alarme=1 Then MsgBox(16,"Support(s) oublié(s) !!","Attention au moins support a été oublié:"&@CRLF&$listsupport) ; generally the message is coming too late, but the "beep" is played even if the session is locked
EndFunc


Func _IsPressed($hexKey) ; thanks to the person who has written this function ;-)
  Local $aR, $bO
  $hexKey = '0x' & $hexKey
  $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
  If Not @error And BitAND($aR[0], 0x8000) = 0x8000 Then
     $bO = 1
  Else
     $bO = 0
  EndIf
  Return $bO
EndFunc