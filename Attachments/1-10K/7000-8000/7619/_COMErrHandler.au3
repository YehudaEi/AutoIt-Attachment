#include-once
#include <Constants.au3>

Global $oCOMErrHndlr = ObjEvent("AutoIt.Error","COMErrMsg") ; Install a custom error handler

Func COMErrMsg ( $iMsgBoxFlags = 4112, $iMsgBoxTimeout = 60 )
	; Default $iMsgBoxFlags = $MB_OK + $MB_ICONHAND + $MB_SYSTEMMODAL
	Local $sComErrMsg, $aSplitMsg
	
	If $oCOMErrHndlr.description <> '' Then
		$sComErrMsg = $sComErrMsg & 'Description: '
		$aSplitMsg = StringSplit ( $oCOMErrHndlr.description, ',' )
		For $i = 1 To $aSplitMsg[0]
			If $i <> 1 Then $sComErrMsg = $sComErrMsg & @TAB & '   '
			$sComErrMsg = $sComErrMsg & $aSplitMsg[$i]
			If $i <> $aSplitMsg[0] Then
				$sComErrMsg = $sComErrMsg & ',' & @CRLF
			ElseIf StringRight($aSplitMsg[$i],1) <> @CR AND StringRight($aSplitMsg[$i],1) <> @LF Then
				$sComErrMsg = $sComErrMsg & @CRLF
			EndIf
		Next
	EndIf
	
	If $oCOMErrHndlr.windescription <> '' Then
		$sComErrMsg = $sComErrMsg & 'Message: '
		$aSplitMsg = StringSplit ( $oCOMErrHndlr.windescription, ',' )
		For $i = 1 To $aSplitMsg[0]
			If $i <> 1 Then $sComErrMsg = $sComErrMsg & @TAB
			$sComErrMsg = $sComErrMsg & $aSplitMsg[$i]
			If $i <> $aSplitMsg[0] Then
				$sComErrMsg = $sComErrMsg & ',' & @CRLF
			ElseIf StringRight($aSplitMsg[$i],1) <> @CR AND StringRight($aSplitMsg[$i],1) <> @LF Then
				$sComErrMsg = $sComErrMsg & @CRLF
			EndIf
		Next
	EndIf
		
	$sComErrMsg = $sComErrMsg & 'Error #: 0x' & hex($oCOMErrHndlr.number,8) & ' (' & $oCOMErrHndlr.number & ')' & @CRLF
	If $oCOMErrHndlr.lastdllerror <> 0 Then $sComErrMsg = $sComErrMsg & 'Last DLL Error: ' & $oCOMErrHndlr.lastdllerror & @CRLF
	If $oCOMErrHndlr.scriptline <> 0 Then $sComErrMsg = $sComErrMsg & 'Script Line#: ' & $oCOMErrHndlr.scriptline & @CRLF
	If $oCOMErrHndlr.source <> '' Then $sComErrMsg = $sComErrMsg & $oCOMErrHndlr.source & @CRLF
	If $oCOMErrHndlr.helpfile <> '' Then $sComErrMsg = $sComErrMsg & $oCOMErrHndlr.helpfile & @CRLF
	If $oCOMErrHndlr.helpfile <> '' Then $sComErrMsg = $sComErrMsg & $oCOMErrHndlr.helpfile & @CRLF
	If $oCOMErrHndlr.helpcontext <> '' Then $sComErrMsg = $sComErrMsg & $oCOMErrHndlr.helpcontext & @CRLF
	ClipPut ( $sComErrMsg )
	MsgBox ( $iMsgBoxFlags, 'COM Error intercepted!', $sComErrMsg, $iMsgBoxTimeout )
	SetError ( 1 )
	SetExtended ( $oCOMErrHndlr.number )
	Return
Endfunc
