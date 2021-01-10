#Include <Constants.au3>
#NoTrayIcon

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

$DRIVE1  = TrayCreateItem("C:\")
$DRIVE2  = TrayCreateItem("D:\")
$DRIVE3  = TrayCreateItem("E:\")
$DRIVE4  = TrayCreateItem("F:\")
TrayCreateItem("")
$aboutitem  = TrayCreateItem("About")
TrayCreateItem("")
$exititem   = TrayCreateItem("Exit")

TraySetState()

While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
		Case $msg = $DRIVE1
			Run("explorer C:\")			
		Case $msg = $DRIVE2
			Run("explorer D:\")
		Case $msg = $DRIVE3
			Run("explorer E:\")
		Case $msg = $DRIVE4		
			Run("explorer F:\")			
        Case $msg = $aboutitem
            Msgbox(64, "About:", "AutoIt3-Tray-sample.")
        Case $msg = $exititem
            ExitLoop
    EndSelect
WEnd

Exit
