;Script Title:  Admit01.au3
;Author:  SNess 11/01/2007
;Purpose:  To ADMIT a Patient (NEW inpatient) into the VA hospital system "VistA"

Opt("MustDeclareVars",1)

Dim $PatientNam, $DOB, $SSN, $Zip, $City, $ST, $Env
$PatientNam = "UFBCS,PATIENT U"
$DOB = "03161947"
$SSN = "666661240"
$Zip = "35201"
$City = "BIRMINGHAM"
$ST = "AL"
$Env = "v-qatest-red"

Opt("WinWaitDelay",1000)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
WinWait($Env & "  NTI - Cache Telnet","")
If Not WinActive($Env & "  NTI - Cache Telnet","") Then WinActivate($Env & "  NTI - Cache Telnet","")
WinWaitActive($Env & "  NTI - Cache Telnet","")
MouseMove(151,65)
MouseDown("left")
MouseUp("left")
Send("D{SPACE}{SHIFTDOWN}6{SHIFTUP}XUP{ENTER}")
send("dss1234.{ENTER}")
Send("admit{SPACE}a{SPACE}patient{ENTER}")
send("1{ENTER}")
Send($PatientNam & "{ENTER}")
Send("Y{ENTER}")
send("M{ENTER}")
Send($DOB & "{ENTER}")
send($SSN & "{ENTER}")
Send("mil{ENTER}")
send("Y{ENTER}")
send("Y{ENTER}")
send("N{ENTER}")
send("Y{ENTER}")
send("{ENTER}")
send("{ENTER}")
send("{ENTER}")
send("{ENTER}")
send("{ENTER}")
send("{ENTER}")
send("cprsphys{ENTER}")
send("{ENTER}")
send("not{ENTER}")
send("D{SPACE}{SHIFTDOWN}6{SHIFTUP}XUP{ENTER}")
send("admit{SPACE}a{SPACE}pat{ENTER}")
send("1{ENTER}")
Send($PatientNam & "{ENTER}")
Send("{ENTER}")
send("{ENTER}")
send("{ENTER}")
send("{ENTER}")
send("y{ENTER}")
send("n{ENTER}")
send("pre{ENTER}")
send("y{ENTER}")
send("dir{ENTER}")
send("mumps{ENTER}")
send("7a{ENTER}")
send("1{ENTER}")
send("726-d{ENTER}")
send("car{ENTER}")
send("cprsphys{ENTER}")
send("cprsattend{ENTER}")
send("1{ENTER}")
send("{ENTER}")
send("1e{ENTER}")

