#NoTrayIcon

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

$syncnow  = TrayCreateItem("Sync Now")
TrayCreateItem("")
$aboutitem  = TrayCreateItem("About")
$exititem   = TrayCreateItem("Exit")

TraySetState()
TraySetToolTip("AutoSync")
;TraySetIcon("C:\Program Files\SyncToy 2.1\SyncToyCmd.exe", 1)
While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
        Case $msg = $syncnow
            SyncNow()
        Case $msg = $aboutitem
            Msgbox(64, "About:", "Automatically Syncronises H Drive every 10 minutes")
        Case $msg = $exititem
           ExitLoop
		EndSelect
WEnd
	

Func SyncNow()
;Run('"C:\Program Files\SyncToy 2.1\SyncToyCmd.exe" -R "H Drive Sync"')
Run("notepad.exe")
EndFunc