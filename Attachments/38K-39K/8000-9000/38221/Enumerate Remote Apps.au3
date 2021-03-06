#include <Array.au3>
#include <File.au3>

AutoItSetOption("WinTitleMatchMode", 2)
$Timer = TimerInit()
$Computer = InputBox("Enumerate Remote Applications", "Please enter the computer you'd like to connect to.")
$Timer = TimerInit()

$addremove = _SoftwareInfo()
_ArraySort($addremove, 0, 1)
$Diff = TimerDiff($Timer)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Diff = ' & $Diff & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
_ArrayDisplay($addremove, 'Add/Remove Entries for ' & $Computer & '.')

Func _SoftwareInfo($s_RemoteComputer = $Computer)
    Local $Count = 1, $Count1 = 1
    If $s_RemoteComputer <> '' Then $s_RemoteComputer = '\\' & StringReplace($s_RemoteComputer, '\', '') & '\'
    Local Const $regkey = $s_RemoteComputer & 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    While 1
        $key = RegEnumKey($regkey, $Count1)
        If @error <> 0 Then ExitLoop
        $line = RegRead($regkey & '\' & $key, 'Displayname')

        If $line <> '' Then
            If StringMid($line, 1, 19) <> "Security Update for" And StringMid($line, 1, 10) <> "Hotfix for" And StringMid($line, 1, 14) <> "Microsoft .Net" And StringMid($line, 1, 16) <> "Microsoft Office" And StringMid($line, 1, 7) <> "Altiris" And StringMid($line, 1, 10) <> "Update for" And StringMid($line, 1, 13) <> "Windows Media" Then
                If Not IsDeclared('avArray') Then Dim $avArray[100]
                If UBound($avArray) - $Count <= 1 Then ReDim $avArray[UBound($avArray) + 100]
                $avArray[$Count] = $line
                $Count = $Count + 1
            EndIf
        EndIf
        $Count1 += 1
    WEnd
    If Not IsDeclared('avArray') Or Not IsArray($avArray) Then
        Return (SetError(1, 0, ''))
    Else
        ReDim $avArray[$Count - 1]
        $avArray[0] = UBound($avArray) - 1
		_FileWriteFromArray("C:\Apps.txt", $avArray)
        Return (SetError(0, 0, $avArray))
    EndIf
EndFunc   ;==>_SoftwareInfo
