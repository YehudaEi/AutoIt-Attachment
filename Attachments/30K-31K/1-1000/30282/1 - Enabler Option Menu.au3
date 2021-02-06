#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=sd.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>

Opt('MustDeclareVars', 1)
_Main()
Func _Main()
Local $YesID, $NoID, $ExitID, $msg, $Shid1ID, $Shid2ID, $manID, $modID, $hiditID
GUICreate("Created By Willem Kleynhans", 500, 240)
GUICtrlCreateLabel("Willem.kleynhans@gijima.com", 10, 10)
$YesID = GUICtrlCreateButton("Enabler_1.0.0.14", 10, 70, 100, 40)
$NoID = GUICtrlCreateButton("Enabler_1.0.0.15", 140, 70, 100, 40)
$ExitID = GUICtrlCreateButton("Windows Enabler", 270, 70, 100, 40)
$Shid1ID = GUICtrlCreateButton("ShidefWindow - 1.0", 10, 170, 100, 40)
$Shid2ID = GUICtrlCreateButton("ShideWindow - 1.2", 140, 170, 100, 40)
$manID = GUICtrlCreateButton("WindowMan - 1.0", 270, 170, 100, 40)
$modID = GUICtrlCreateButton("WindowMan - 1.0", 400, 70, 100, 40)
$hiditID = GUICtrlCreateButton("HideIT", 400, 170, 100, 40)

FileInstall("1.ico",@TempDir & "\$1.tmp")
FileMove (@TempDir & "\$1.tmp", @TempDir & "1.ico" ,1 )

FileInstall("2.ico",@TempDir & "\$2.tmp")
FileMove (@TempDir & "\$2.tmp", @TempDir & "2.ico" ,1 )

FileInstall("3.ico",@TempDir & "\$3.tmp")
FileMove (@TempDir & "\$3.tmp", @TempDir & "3.ico" ,1 )

FileInstall("4.ico",@TempDir & "\$4.tmp")
FileMove (@TempDir & "\$4.tmp", @TempDir & "4.ico" ,1 )

FileInstall("5.ico",@TempDir & "\$5.tmp")
FileMove (@TempDir & "\$5.tmp", @TempDir & "5.ico" ,1 )

FileInstall("6.ico",@TempDir & "\$6.tmp")
FileMove (@TempDir & "\$6.tmp", @TempDir & "6.ico" ,1 )

FileInstall("7.ico",@TempDir & "\$7.tmp")
FileMove (@TempDir & "\$7.tmp", @TempDir & "7.ico" ,1 )



$YESID = GUICtrlCreateButton("1", 40, 30, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "1.ico", 0)

$NoID = GUICtrlCreateButton("1", 170, 30, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "1.ico", 0)

$ExitID = GUICtrlCreateButton("6", 300, 30, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "6.ico", 0)

$Shid1ID = GUICtrlCreateButton("2", 40, 130, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "2.ico", 0)

$Shid2ID = GUICtrlCreateButton("3", 170, 130, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "3.ico", 0)

$manID = GUICtrlCreateButton("5", 300, 130, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "5.ico", 0)

$modID = GUICtrlCreateButton("4", 430, 30, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "4.ico", 0)

$hiditID = GUICtrlCreateButton("7", 430, 130, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, @TempDir & "7.ico", 0)


GUISetState() ; display the GUI1 password

Do
$msg = GUIGetMsg()
Select
	Case $msg = $YesID
		;run("Enabler_1.0.0.14\Enabler_1.0.0.14.exe")
		FileInstall("Enabler_1.0.0.14\Enabler_1.0.0.14.exe",@TempDir & "\$$2.tmp")
		FileMove (@TempDir & "\$$2.tmp", @TempDir & "Enabler_1.0.0.14.exe" ,1 )
		Run(@TempDir & "Enabler_1.0.0.14.exe")
		;FileDelete(@TempDir & "Enabler_1.0.0.14.exe")



Case $msg = $NoID
	;run("Enabler_1.0.0.15\Enabler_1.0.0.15.exe")
	;Opt("TrayIconHide", 1)
	FileInstall("Enabler_1.0.0.15\Enabler_1.0.0.15.exe",@TempDir & "\$$1.tmp")
	FileMove ( @TempDir & "\$$1.tmp", @TempDir & "Enabler_1.0.0.15.exe" ,1 )
	Run(@TempDir & "Enabler_1.0.0.15.exe")
	;FileDelete("C:\Enabler_1.0.0.15.exe")

	;MsgBox(0, "You clicked on", "No")
;FileDelete(@UserProfileDir & "\SendTo\SendToCommandPrompt.exe")
;MsgBox(4096, "SendToCommand Removed ", "Shortcut Removed", 10)

Case $msg = $ExitID
	FileInstall("Enabler Window\Enabler Window.exe",@TempDir & "\$$3.tmp")
	FileMove ( @TempDir & "\$$3.tmp", @TempDir & "Enabler Window.exe" ,1 )
	Run(@TempDir & "Enabler Window.exe")
	;FileDelete("C:\Enabler Window.exe")
	;MsgBox(0, "Windows Enabler", "Windows Enabler")

Case $msg = $Shid1ID
	;run("ShideWindow - 1.0\ShideWindow - 1.0.exe")
	FileInstall("ShideWindow - 1.0\ShideWindow - 1.0.exe",@TempDir & "\$$4.tmp")
	FileMove ( @TempDir & "\$$4.tmp", @TempDir & "ShideWindow - 1.0.exe" ,1 )
	Run(@TempDir & "shideWindow - 1.0.exe")

Case $msg = $Shid2ID
	FileInstall("ShideWindow - 1.2\ShideWindow - 1.2.exe",@TempDir & "\$$5.tmp")
	FileMove ( @TempDir & "\$$5.tmp", @TempDir & "ShideWindow - 1.2.exe" ,1 )
	Run(@TempDir & "ShideWindow - 1.2.exe")

	;run("ShideWindow - 1.2\ShideWindow - 1.2.exe")

Case $msg = $manID
	FileInstall("WindowsMan\WindowsMan.exe",@TempDir & "\$$6.tmp")
	FileMove ( @TempDir & "\$$6.tmp", @TempDir & "WindowsMan.exe" ,1 )
	Run(@TempDir & "WindowsMan.exe")
	;run("WindowsMan\WindowsMan.exe")


Case $msg = $modID
	FileInstall("Windows Modifier\Windows Modifier.exe",@TempDir & "\$$7.tmp")
	FileMove ( @TempDir & "\$$7.tmp", @TempDir & "Windows Modifier.exe" ,1 )
	Run(@TempDir & "Windows Modifier.exe")
	;run("Windows Modifier\Windows Modifier.exe")

Case $msg = $hiditID
		;run("Enabler_1.0.0.14\Enabler_1.0.0.14.exe")
		FileInstall("HideIT\HideIT.exe",@TempDir & "\$$8.tmp")
		FileMove (@TempDir & "\$$8.tmp", @TempDir & "HideIT.exe" ,1 )
		Run(@TempDir & "HideIT.exe")



Case $msg = $GUI_EVENT_CLOSE
	FileDelete (@TempDir & "Enabler_1.0.0.14.exe")
	FileDelete (@TempDir & "Enabler_1.0.0.15.exe")
	FileDelete (@TempDir & "Enabler Window.exe")
	FileDelete (@TempDir & "shideWindow - 1.0.exe")
	FileDelete (@TempDir & "ShideWindow - 1.2.exe")
	FileDelete (@TempDir & "WindowsMan.exe")
	FileDelete (@TempDir & "Windows Modifier.exe")
	FileDelete (@TempDir & "HideIT.exe")


;MsgBox(0, "Application Will Exit", "Close")
EndSelect
Until $msg = $GUI_EVENT_CLOSE
EndFunc ;==>_Main
