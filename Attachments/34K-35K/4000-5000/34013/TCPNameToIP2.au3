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


$array1 = _StringExplode($file, "\\",0)
FileClose($file)
;$numsubs=UBound($array1)-1
;MsgBox(0,"Number of subarrays","Number of subarrays is "&$numsubs)
;Dim $array1[1] To $array1[$numsubs]

$ping1=StringMid($array1[1],1,15)
$ping2=StringMid($array1[2],1,15)
$ping3=StringMid($array1[3],1,15)
$ping4=StringMid($array1[4],1,15)
$ping5=StringMid($array1[5],1,15)
;$ping6=StringMid($array1[6],1,15) ;WHEN THERE ARE ONLY 5 PCs ONLINE THERE IS NO DATA FOR THE ARRAY


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

$full_listing=$final1&@CR&$final2&@CR&$final3&@CR&$final4&@CR&$final5
MsgBox(0,"IP Addresses In Use",$full_listing)




FileDelete("C:\Documents and Settings\Administrator\Desktop\netlist.txt")