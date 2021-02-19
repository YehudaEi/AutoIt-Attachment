#include <String.au3>
#include <array.au3>

Run("cmd.exe","",@SW_ENABLE)

Sleep(1000)
Send("net view > netlist.txt")
Send("{ENTER}")
Sleep(3000)
ProcessClose("cmd.exe")

$file=FileOpen("netlist.txt",0)
$file=FileRead("netlist.txt")
FileClose($file)

$array1 = _StringExplode($file, "\\",0)


$ping1=StringMid($array1[1],1,15)
$ping2=StringMid($array1[2],1,15)
$ping3=StringMid($array1[3],1,15)
$ping4=StringMid($array1[4],1,15)
$ping5=StringMid($array1[5],1,15)
$ping6=StringMid($array1[6],1,15) ;WHY IS THIS CAUSE AN ERROR?


;CAN'T FIGURE OUT HOW TO DELETE THE NETLIST.TXT FILE FROM THE DESKTOP

TCPStartup()

$IPAddress=TCPNameToIP($ping1)
$final1=$ping1&@TAB&@TAB&$IPAddress

$IPAddress=TCPNameToIP($ping2)
$final2=$ping2&@TAB&@TAB&$IPAddress

$IPAddress=TCPNameToIP($ping3)
$final3=$ping3&@TAB&@TAB&$IPAddress

$IPAddress=TCPNameToIP($ping4)
$final4=$ping4&@TAB&@TAB&$IPAddress

$IPAddress=TCPNameToIP($ping5)
$final5=$ping5&@TAB&@TAB&$IPAddress

$IPAddress=TCPNameToIP($ping6)
$final6=$ping6&@TAB&@TAB&$IPAddress

$full_listing=$final1&@CR&$final2&@CR&$final3&@CR&$final4&@CR&$final5&@CR&$final6

MsgBox(0,"IP Addresses In Use",$full_listing)


;$attrib = FileGetAttrib("netlist.txt")
;MsgBox(0,"Full file attributes:", $attrib)
;FileSetAttrib("netlist.txt","-A")
FileDelete($file)
FileDelete("netlist.txt")