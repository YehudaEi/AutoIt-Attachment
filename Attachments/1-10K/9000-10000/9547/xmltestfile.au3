;------------------------------------------------------------------------------
;
; Test Script
;
;------------------------------------------------------------------------------
#include <GUIConstants.au3>
#include <_XMLDomWrapper.au3>
#include <Array.au3>

Global $ret, $testvar1
Local $sFile = "C:\cookbook" & ".xml"
Local $ns = ""
If FileExists($sFile) Then
		While @error = 0
			$ret = _XMLFileOpen ($sFile, $ns)
			if $ret = 0 then Exit
			MsgBox(4096, "File Found", "File Found")
			 $testvar1 = _XMLGetNodeCount("//DATAPACKET/ROWDATA" & "/*")
			 MsgBox(4096, "node count", $testvar1)
			Return
		WEnd
		MsgBox(4096, "Error", _XMLError ())
	EndIf