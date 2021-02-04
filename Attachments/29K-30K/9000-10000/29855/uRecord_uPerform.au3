#include <Date.au3>

$tCur = _Date_Time_GetSystemTime()
	
If FileExists("C:\Program Files\Rwd uPerform\Client\bin\uPerform1.exe")=0 Then
FileCopy(@ProgramFilesDir &"\Rwd uPerform\Client\bin\uPerform.exe",@ProgramFilesDir &"\Rwd uPerform\Client\bin\uPerform1" &_Date_Time_SystemTimeToDateTimeStr($tCur)& ".exe",0)


Run	(@ProgramFilesDir &"\Rwd uPerform\Client\bin\uPerform1.exe")

Else
	
 Run("C:\Program Files\Rwd uPerform\Client\bin\uPerform1.exe")

EndIf