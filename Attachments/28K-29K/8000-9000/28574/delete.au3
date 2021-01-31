if Not FileSetAttrib("C:\Programme\AutoIt3\Examples\eigen\*.*", "-R", 1) Then
    MsgBox(4096,"Error", "Problem setting attributes.")
EndIf

$ret = DirRemove("C:\Programme\AutoIt3\Examples\eigen",1)
if $ret = 0 then 
	MsgBox(0,"Error", "Delete not succesful!")
	Exit
EndIf
