#include <StringFix.au3>
Local $String = "Å×½ºÆ®, TEST!"

MsgBox(16, "String To Binary", _
"Str To More Binary  " & @TAB & Binary($String & Chr(0) & $String) & @CRLF & _
"Str To Fixed Binary  " & @TAB & _StringFix($String, 1) & @CRLF & _
"Str To Normal Binary" & @TAB & Binary($String) & @CRLF & _
"")