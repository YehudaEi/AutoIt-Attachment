#include <ExcelCOM_UDF.au3>

Send("#r")
WinWaitActive("Run")
Send("cmd")
Send("{enter}")
WinWaitActive("C:\WINDOWS\system32\cmd.exe")
Send("net use x: /delete")
Send("{Enter}")
Sleep(350)
WinClose("C:\WINDOWS\system32\cmd.exe")

$sFilePath = @WorkingDir & "\book1.xls"	;Location of Excel spreadsheet

;Remember to make Excel spreadsheet hidden when going live.
$oExcel = _ExcelBookOpen($sFilePath, 0, False, "", "") ;Open the Excel document

$sRangeOrRowStart = "A2:A5";This is the field I want the search to start at.
;$whatever = _ExcelFindInRange($oExcel, $username, $sRangeOrRowStart, 1, 800, 800, 0, 2, False, "")

$field = 1 		;Set to something different than $password to make sure the loop executes at least once.
$password = 2	;Set to something different than $field    to make sure the loop executes at least once.
While $field <> $password ;as long as these are NOT equal keep looping

	$username = InputBox("Username", "Enter your username:", "", "", @DesktopWidth-50, @DesktopHeight-150, Default, Default)
	$password = InputBox("Password", "Enter your password:", "", "", @DesktopWidth-50, @DesktopHeight-150, Default, Default)

	$whatever = _ExcelFindInRange($oExcel, $username, $sRangeOrRowStart, 1, 800, 800, 0, 2, False, "") ;Searches to see if the username is on the list
	
	
	If $whatever[0][0] = 1 then	;If the username is found on the list execute the following
	
		For $x = 1 to $whatever[0][0]
			
			$excelPassword = "B" & $whatever[$x][3]	 ;Setting this equal to the password cell that corresponds with the username entered.
			$field =_ExcelReadCell($oExcel, $excelPassword, 1)		;reads that password cell.
			$driveMapPath = "C" & $whatever[$x][3]	 ;Setting this equal to the path-to-be-mapped cell that corresponds with the username entered.
			If $field = $password Then 	;checking to make sure the password entered matches the password in the cell
				
				;use this if they need the same username and password to map the drive
				;comment out or delete if not used
				DriveMapAdd("X:", "\\PC3\" & $username) ;maps the drive based on the info attained above.
				
				;If the drive mapping doesn't require a username and password just use this one
				;comment out or delete if not used
				;DriveMapAdd("X:", $driveMapPath)

				Sleep(3000)
				
				;Uncomment below if you want the mapped drive to automatically open
				;Run('c:\windows\explorer.exe X:\')


			Else ;If the password entered does NOT matches the password in the cell execute the following
				MsgBox(0,"Error","Password is incorrect.")
			EndIf
	
		Next
	else	;If the username is NOT found on the list execute the following
		MsgBox(0,"Error","Username is incorrect.")
	EndIf	
	

Wend ;End the loop


_ExcelBookClose($oExcel)