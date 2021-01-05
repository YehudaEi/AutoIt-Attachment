If MsgBox(4,"AU3 Editor changer","This will change the editor used in the " & @CR & "'Open' and 'Edit' popup menus." & @CR & "Do you want to continue?") == 7 Then Exit 0

$neweditor = FileOpenDialog("Select the editor","","All (*.*)",3)

RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AutoIt3Script\Shell\Edit\Command","","REG_SZ",$neweditor & " " & Chr(34) & "%1" & Chr(34) )
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AutoIt3Script\Shell\Open\Command","","REG_SZ",$neweditor & " " & Chr(34) & "%1" & Chr(34) )
