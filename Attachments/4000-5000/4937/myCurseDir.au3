#include<Constants.au3>

;Uses dos command to recurse a folder indicated by $source_path
;Note: filtes can be added (ie searching for .mp3 change $source_path to
;$source_path	="C:\Program Files\AutoIt3\*.mp3"


$source_path	="C:\Program Files\AutoIt3"

$dir = RecurseDir($source_path)

MsgBox(0, "$dir", $dir)


func RecurseDir($source_path)
	
	Local $output, $var, $foo, $line_out, $line_stderr
	$var = @ComSpec&' /C dir "'&$source_path&'" /s /b /a-d'
	ConsoleWrite($var&@lf)
	
	
	$foo = run($var, $source_path, @SW_ENABLE, $STDERR_CHILD + $STDOUT_CHILD)
	
	$output=""
		While 1
		$line_out = StdoutRead($foo)
		If @error = -1 Then ExitLoop
			$output = $output&$line_out
		Wend
		
		While 1
			$line_stderr = StderrRead($foo)
			If @error = -1 Then ExitLoop
						
			MsgBox(0, "ERROR of Greatest Proportions", "CodeSuck: "&$line_stderr)
			Exit
		Wend
		
		return $output
EndFunc


