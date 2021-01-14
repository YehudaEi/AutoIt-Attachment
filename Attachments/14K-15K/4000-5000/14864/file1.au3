$file2 = run("file2.exe","","",7)
StdinWrite($file2,'mbox 0 hi hi')
$data = ""
Do
	$data = StdoutRead($file2)
until $data <> ""
stdinwrite($file2,'exit2')