

#include <date.au3>

Global $RightDir = "C:\Program Files"

_Aapjuh_CheckDate()

;Check Date*
Func _Aapjuh_CheckDate()
Global $ToDay = _DateToDayValue(@YEAR,@MON,@MDAY)
Global $ToDayDate = @YEAR & "/" & @MON & "/" & @MDAY
Global $ToDayTime = @HOUR & ":" & @MIN & ":" & @SEC
If FileExists($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt") Then
Dim $Year, $Month, $Day
Global $WeekAgo = _DayValueToDate($ToDay-7, $Year, $Month, $Day)
Global $LogDate = FileGetTime($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt", 0)
Global $LogDateValue = $LogDate[0] & "/" & $LogDate[1] & "/" & $LogDate[2]
If @WDAY = 01 Then
If $ToDayDate = $LogDateValue Then
Exit 0
Else
_Aapjuh_CheckFiles()
Endif
ElseIf @WDAY > 01 Then
If $LogDateValue < $WeekAgo Then
_Aapjuh_CheckFiles()
Else
Exit 0
EndIf
EndIf
ElseIf not FileExists($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt") Then
_Aapjuh_MakeLog()
EndIf
EndFunc

;Making log file*
Func _Aapjuh_MakeLog()
If not FileExists($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt") Then
If FileExists("C:\Aapjuh-Log.txt") Then
FileMove("C:\Aapjuh-Log.txt", $RightDir & "\Aapjuh Prog\Aapjuh-Log.txt", 9)
Else
FileWriteLine($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt", "***Aapjuh-Prog***" & @CRLF & @CRLF & "Created by: 'Aapjuh' and 'Tigo_007'" & @CRLF & @CRLF & _
"Special Thanks To: 'The creators of AutoIt' and 'The AutoIt community'" & @CRLF & @CRLF & @CRLF & "***Log:***")
FileClose($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt")
FileSetTime($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt", "20031101" ,0)
FileSetTime($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt", "20031101" ,1)
FileSetTime($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt", "20031101" ,2)
EndIf
_Aapjuh_CheckDate() ;-----------------------------------------------------------------------------------it calls the above function here again
ElseIf FileExists($RightDir & "\Aapjuh Prog\Aapjuh-Log.txt") Then
Sleep(100)
Else
msgbox(0,"error", "some error")
EndIf
EndFunc