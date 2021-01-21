; Panorama queue.au3
; Designed to work in conjunction with Panorama.au3
; adds the specified files to a queue of files to process

$queuefile = "C:\Documents\Pictures\Panorama queue.txt"

$params = $CmdLine[0]
If $params < 2 Then	
	MsgBox (0, "Panorama queue", "You must specify at least two images.")
	Exit 1
EndIf

$towrite = ""
$lastfolder = ""
For $i = 1 To $params
	$name = FileGetLongName ($CmdLine[$i])
	If Not FileExists ($name) Then
		MsgBox (0, "Panorama queue", "File not found: " & $name)
		Exit 1
	EndIf
	
	$p = StringInStr ($name, "\", 0, -1)
	$folder = StringLeft ($name, $p - 1)
	If $lastfolder = "" Then
		$lastfolder = $folder
		$towrite = $folder & @CRLF
	ElseIf $lastfolder <> $folder Then
		MsgBox (0, "Panorama queue", "All images must be in the same folder - sorry!")
		Exit 1
	EndIf
	
	$file = StringTrimLeft ($name, $p)
	$towrite = $towrite & $file & @CRLF
Next
$towrite = $towrite & "-" & @CRLF ; mark end of group of images

If FileWrite ($queuefile, $towrite) = 0 Then
	MsgBox (0, "Panorama queue", "Error writing to " & $queuefile)
	Exit 1
EndIf

