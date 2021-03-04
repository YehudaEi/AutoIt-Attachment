#include <file.au3>


; Writing INI for Printer Information
$ini = inputBox("Printer INI","What is the name of the ini you want to create","printer.ini")
    IF @error = 1 then
        MsgBox(0, "Closing", "Good Bye")
        Exit
    Endif
_FileCreate($ini)
;Ask for the Printer Que name
$printer = InputBox("Print Que","What is the Printer queue IP name?","")
    IF @error = 1 then
        MsgBox(0, "Closing", "Good Bye")
        Exit
    Endif
;Ask for Printer IP
$ip = InputBox("Printer IP","What is the Printer IP?","")
    IF @error = 1 then
        MsgBox(0, "Closing", "Good Bye")
        Exit
    Endif
;Ask for Drive location
$driver = InputBox("Printer Drivers","Name of printer to install?" & @CR & _
"Press 1 for Toshiba B&W" & @CR & "Press 2 for Toshiba Colour" & @CR & "Press 3 for HP 3005" & @CR _
& "Press 4 for HP 400" & @CR & "Press 5 for HP 3015","")
    IF @error = 1 then
        MsgBox(0, "Closing", "Good Bye")
        Exit
    Endif
;Carry out task
IF $driver = "1" Then;Toshiba
    $drv = "\\Share\Printer drivers\Toshiba351-451 B&W Driver\eB4dx2.inf";put the network path to the drivers here.
    $dis = "TOSHIBA eS451c/453cSeries PCL6"
ElseIf $driver = "2" Then; Toshiba
    $drv = "\\Share\Printer drivers\Toshiba351 - 451 Colour Driver\eB4dc2.INF"
    $dis = "TOSHIBA eS451c/453cSeries PCL5c"
ElseIf $driver = "3" Then;HP3005
    $drv = "\\Share\Printer drivers\HP 3005 LJ\hpc300xc.inf"
    $dis = "HP LaserJet P3005 PCL 6"
ElseIf $driver = "4" Then;HP400
    $drv = "\\Share\Printer drivers\HP_LaserJet_400_M401\autorun.inf"
    $dis = "HHP LaserJet 400 M401 PCL 6"
ElseIf $driver = "5" Then;HP3015
    $drv = "\\Share\Printer drivers\HP 3015\PCL6\hpc3010c.inf"
    $dis = "hHP LaserJet P3010 Series PCL 6"
EndIf


IniWrite ( $ini, "Printer QUE", "Printer", $printer )
IniWrite ( $ini, "Printer IP", "IP", $ip)
IniWrite ( $ini, "Printer DRIVERS", "Driver", $drv )
IniWrite ( $ini, "Printer DISCRIPTION", "Discription", $dis )
MsgBox( 64, "Ini Creation", $ini & " has been created successfully")
