#include <Array.au3>

$ClipGet = ClipGet()
If StringLeft($ClipGet,12) = "<CheatTable>" Then
    Local $ClipText = "Func _Read"
    Local $Name
    Local $NameOffset
    Local $InterpretableModule


    $_SRE = StringRegExp($ClipGet, "<Description>(.*?)\<", 1)
    $_SRE = StringRegExp($_SRE[0], "(?i)[a-z]*", 1)
    $ClipText &= StringStripWS($_SRE[0], 8) & "($pid)" & @CRLF & @CRLF & @TAB

    $Name = StringStripWS($_SRE[0], 8)

    $ClipText &= "Global $" & $Name & "Offset"
    $NameOffset = "$" & $Name & "Offset"
    $_SRE = StringRegExp($ClipGet, "<Offset>(.*?)<", 3)
    $ClipText &= "[" & UBound($_SRE) + 1 & "]" & @CRLF & @TAB & $NameOffset & "[0] = 0" & @CRLF & @TAB

    _ArrayReverse($_SRE)
    For $I = 0 To UBound($_SRE) - 1
        $ClipText &= $NameOffset & "[" & $I + 1 & '] = Dec("' & $_SRE[$I] & '")' & @CRLF & @TAB
    Next

    $_SRE = StringRegExp($ClipGet, "<InterpretableAddress>(.*?)\<", 1)
    If Not @error Then
        $_SS = StringSplit($_SRE[0], "+")
        If $_SS[0] = 1 Then
            MsgBox(16, "Error", "This address is not static. Please make sure you're ending with a 'green address'" & @CRLF & "(Game.exe+Offset)")
        Else
            $InterpretableModule = $_SS[1]
            $ClipText &= '$StaticOffset = Dec("' & $_SS[2] & '")' & @CRLF & @TAB
        EndIf
    EndIf

    $ClipText &= '$openmem = _MemoryOpen($pid)' & @CRLF & @TAB

    If StringRight($InterpretableModule, 3) = "exe" Then
        $ClipText &= '$baseADDR = _MemoryGetBaseAddress($openmem, 1)' & @CRLF & @TAB
    Else
        $ClipText &= '$baseADDR = _MemoryModuleGetBaseAddress($pid, "' & $InterpretableModule & '")' & @CRLF & @TAB
    EndIf

    $ClipText &= '$finalADDR = "0x" & Hex($baseADDR + $StaticOffset)' & @CRLF & @TAB
    $ClipText &= '$MemPointer = _MemoryPointerRead($finalADDR, $openmem, ' & $NameOffset & ')' & @CRLF & @TAB
    $ClipText &= '_MemoryClose($openmem)' & @CRLF  & @CRLF & @TAB
    $ClipText &= 'Return $MemPointer' & @CRLF & 'EndFunc'

    ; Finished, return
    ClipPut($ClipText)
Else
    MsgBox(16, "Error", "No Cheat Table data in your clipboard")
EndIf
