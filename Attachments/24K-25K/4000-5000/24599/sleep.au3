#include<Misc.au3>

$Run = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$reg= "HKLM\SOFTWARE\Program Name"
$date = regread($reg,"Future Date")
$name = "MyProgram"
$check = RegRead($run,$name )

if $check = "" Then
    RegWrite($run, $name, "REG_SZ", @ScriptFullPath)
EndIf

if $date <>1 Then
    $input =    InputBox("Future Running", "When would you like to program to run next?", "MM/DD/HR/MIN")
    $NDate = StringSplit($input, "/")
    Regwrite($reg,"Month","REG_SZ", $NDate[0]
    Regwrite($reg,"Day","REG_SZ", $NDate[1]
    Regwrite($reg,"Hour","REG_SZ", $NDate[2]
    Regwrite($reg,"Minute","REG_SZ", $NDate[3]
    Regwrite($reg,"Month","REG_SZ", "Future Date", 1)    
EndIf

Global $Month = RegRead($Reg, "Month")
Global $Day = RegRead($Reg, "Day")
Global $Hour = RegRead($Reg, "Hour")
Global $Minute = RegRead($Reg, "Minute")

_Sleep($Month, $Day, $Hour, $Minute)

Func _Sleep($Month = @MON, $Day = @MDAY, $Hour = @HOUR, $Minute = @MIN)
    Do
sleep(50)
        If _IsPressed('10') And _IsPressed('be') Then; Shift + >>
            MsgBox(0, "", "Working!")
            ExitLoop
        EndIf
    Until $Month = @MON And $Day = @MDAY And $Hour = @HOUR And $Minute = @MIN
    RegWrite($Reg, "Future Date", "REG_SZ", 0)
EndFunc;==>_Sleep

;Script starts here

    MsgBox(0, "", "Works")