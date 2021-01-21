#cs
get_exif_data.au3 1.0
Ben Shepherd (bjashepherd@gmail.com), 3 September 2005
Uses JHead (http://www.sentex.net/~mwandel/jhead/) to retrieve the EXIF data
from a specified JPG file.

Usage: _GetEXIFData ($file)
Returns: a 2D array of strings
First column is the parameter, second is the value
First element is the number of parameters returned

On failure:
return value 1 (and @error = 1): File does not exist
@error = 2: JHead returned an error, output to the return value

#ce

#include <Constants.au3>
#include <Array.au3>

Func _GetEXIFData ($file)
	$jheadpath = "C:\Program Files\jhead.exe"
	
	$handle = Run('"' & $jheadpath & '" "' & $file & '"', @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	
	$output = StdoutRead($handle)
	$n = 0
	$stamp = TimerInit ()
	While 1
		$output = $output & StdoutRead($handle)
		If @error = -1 Then ExitLoop
	Wend
	;MsgBox (0, "output", $output)
	$output = StringSplit ($output, @CRLF, 1)
	;MsgBox (0, "lines in output", $output[0])
	
	Dim $table [$output[0] + 1][2]
	$table[0][0] = $output[0]
	For $i = 1 To $output[0]
		$p = StringInStr ($output[$i], ":")
		$param = StringStripWS (StringLeft ($output[$i], $p - 1), 3) ; leading + trailing whitespace
		$value = StringStripWS (StringTrimLeft ($output[$i], $p), 3)
		$table[$i][0] = $param
		$table[$i][1] = $value
		;MsgBox (0, "", $param & @CRLF & $value)
	Next
	
	$errout = ""
	While 1
		$errout = $errout & StderrRead($handle)
		If @error = -1 Then ExitLoop
		;MsgBox(0, "STDERR read:", $line)
	Wend
	
	ProcessWaitClose ("jhead.exe", 2)
	
	If $errout = "" Then
		Return $table
	Else
		SetError (2)
		Return $errout
	EndIf

EndFunc

