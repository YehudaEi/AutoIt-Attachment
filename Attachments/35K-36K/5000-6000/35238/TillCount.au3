$pos = ""

$file = FileOpen("TotalPos.txt",2)
For $ping = 1 To 2 Step 1
	
$result = Ping("POS" & $ping)
MsgBox(1,"ping",$result & "-------------"         & $ping )

if $result = 0 Then
FileWrite($file,"Pos num    " & $ping)
	MsgBox(1,"KE", "pos num is  " & $ping)
	FileClose($file)
	
EndIf
Next
Exit
