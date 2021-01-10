
$file = @ScriptDir & "\dummyfile.log"

$openfile = FileOpen($file,1)
$line_number = Inputbox("Random dummy file creator", "enter the amount of lines you would like", 10)
for $x = 0 to $line_number
FileWriteLine($openfile, "test" & chr(Random(0,255)) & @CRLF)
Next
fileclose($openfile)