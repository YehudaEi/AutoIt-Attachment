#include-once
Func SearchForString ($SearchFile, $textString)
	$lineNumber = 0
	$foundText = ""
	$handle = 0
;consolewrite("Trying to open file " & $SearchFile )
;consolewrite("and find string " & $textString & @CRLF)
	if FileExists( $SearchFile ) Then
		$handle = FileOpen( $SearchFile, 0 )
;			consolewrite("File handle:  " & $handle & @CRLF)
		If $handle < 0 Then
			consolewrite( "Can't open file." & @CRLF )
		ElseIf $handle > 0 Then
			while 1
				$line = FileReadLine( $handle )
				$lineNumber = $lineNumber + 1
;				consolewrite(StringFormat('   Line:  %s - %s', $lineNumber, $line & @CRLF) )
				if @error = -1 Then ExitLoop ; end-of-file was reached.
				if StringInStr( $line, $textString ) Then
					$foundText = $line
					ExitLoop
				EndIf
			WEnd
			If $foundtext = True Then
;				consolewrite( "String found." & @CRLF )
			EndIf
			FileClose($handle)
		EndIf
	Else
		consolewrite( "File not found." & @CRLF )
	EndIf
	Return $foundText
EndFunc


