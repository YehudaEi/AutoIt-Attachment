Dim $fnPN

;$fnPN = @ScriptDir & "\" & "taskcomp.dll"
;MsgBox(0, "Version Info", GetVer($fnPN))

$fnPN = @ScriptDir & "\" & "taskbarcpl.dll"
MsgBox(0, "Version Info", GetVer($fnPN))


Func GetVer($pn)
   Local $vProduct = FileGetVersion($pn, "ProductVersion")
   Local $vProduct = FileGetVersion($pn, "FileVersion")
   Local $sVer = $pn & @CRLF & "ProductVersion : " & $vProduct & @CRLF & "FileVersion : " & $vProduct
   Return $sVer
EndFunc
