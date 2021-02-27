#NoTrayIcon
$useradm2 = IniRead("c:\copy.ini","ID","useradm","")
$old = IniRead("c:\copy.ini","ID","rand","")

$sig = FileExists("c:\documents and settings\"&$old&"."&$useradm2&"\Application Data\Microsoft\Signatures\")
$nk2 = FileExists("c:\documents and settings\"&$old&"."&$useradm2&"\Application Data\Microsoft\Outlook\")

while 1
	Select
		Case $sig = 0 and $nk2 = 0
			DirCopy("c:\documents and settings\"&$old&"."&$useradm2&"\Desktop","c:\documents and settings\"&$useradm2&"\Desktop",9)
		Case $sig = 0
			DirCopy("c:\documents and settings\"&$old&"."&$useradm2&"\Application Data\Microsoft\Outlook","c:\documents and settings\"&$useradm2&"\Application Data\Microsoft\Outlook",9)
			DirCopy("c:\documents and settings\"&$old&"."&$useradm2&"\Desktop","c:\documents and settings\"&$useradm2&"\Desktop",9)
		case Else
			DirCopy("c:\documents and settings\"&$old&"."&$useradm2&"\Application Data\Microsoft\Signatures","c:\documents and settings\"&$useradm2&"\Application Data\Microsoft\Signatures",9)
			DirCopy("c:\documents and settings\"&$old&"."&$useradm2&"\Application Data\Microsoft\Outlook","c:\documents and settings\"&$useradm2&"\Application Data\Microsoft\Outlook",9)
			DirCopy("c:\documents and settings\"&$old&"."&$useradm2&"\Desktop","c:\documents and settings\"&$useradm2&"\Desktop",9)
	EndSelect
	Exit
WEnd
Exit