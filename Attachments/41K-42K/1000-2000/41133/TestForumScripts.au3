$server = ObjGet("WinNT://servername/LanmanServer")
$aSessions = $server.Resources

For $element in $aSessions
	If $element.Path <> "" Then MsgBox(0, "", "Path: " & $element.Path & @CRLF & "User: " & $element.User)
Next
