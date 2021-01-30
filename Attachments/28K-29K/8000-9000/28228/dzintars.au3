#include <inet.au3>
#include <string.au3>

Global $menu1, $message, $trayitem, $trayitem2, $msg, $source

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

$trayitem2 = TrayCreateItem("Parbaudit")
$trayitem = TrayCreateItem("Iziet")
$trayitem3 = TrayCreateItem("Iztirit huinju")



$Source = _InetGetSource ("                                                      ")
$Between = FileReadLine("C:\test.txt", 90)

Func cleancache()

	$fileis = FileExists("C:\test.txt")

	If $fileis = 1 Then
		FileDelete("C:\test.txt")
		MsgBox (64, "Paldies", "Huinja iztirita")
	Else
		MsgBox (16, "It's OK", "Nav huinjas paslaik.")
	EndIF
EndFunc


Func tellme()
	$file = FileOpen("C:\test.txt", 1)

; Check if file opened for writing OK
If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf
$source2 = String($source)
FileWrite($file, $source2)
FileClose($file)
TrayTip("Pedejais sludinajums:", $Between, "", 1)

EndFunc



While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $trayitem3
			cleancache()
		Case $msg = $trayitem2
			tellme()
		Case $msg = $trayitem
			ExitLoop
EndSelect
WEnd
