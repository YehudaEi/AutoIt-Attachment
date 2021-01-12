#cs - Trace.txt
###User Defined Function###
_Trace

###Description###
Display messages to user containing trace or debug information.

###Syntax###
#include <Trace.au3>
_Trace ( Const $s_Msg, [Const $i_OutputSinc=0],[Const $i_Timeout=5] )

###Parameters###
@@ParamTable@@
$s_Msg
Message to be displayed
$i_OutputSinc
Determine how the message is displayed
Optional: 	0=Default, search for otput sinc. The search is done in same order as these options.
			1=Use a debugger (DebugView from www.sysinternal.com) as sinc
			2=Use ConsoleWrite as sinc (SciTE will capture output)
			3=Use TrayTip as sinc. 
			4=Use MsgBox as sinc
$i_Timeout
Optional: 	Set timeout in seconds. It is used with TrayTip and MsgBox in $i_OutputSInc
@@End@@

###ReturnValue###
1 for success
0 for failure. When a failure occures @error is set to 1
###Remarks###
The code has not been tested with other debuggers than DebugView from sysinternals.

When chosing to use $i_OutputSinc=2 (ConsoleWrite) The messages might 
get lost because _Trace have non known way to determine if the 
message was captured.
When $i_OutputSinc=0 SciTE has to bee pressent for _Trace to choose ConsoleWrite.
###Related###


###Example###
@@IncludeExample@@
#ce

#cs - _Trace_Example.au3
#include <Trace.au3>
_Trace("Message ending at the first available sinc. If there is no debugger that would bee ConsoleWrite", 0)
_Trace("Specific to debugger",1)
_Trace("Passed to ConsoleWrite",2)
_Trace("Passed to TrayTip",3)
_Trace("Passed to TrayTip2 to see if first message is canseled before the timeout.",3)
_Trace("Passed to MsgBox",4)
_Trace("Should set the Error flag as there is no option for $i_OutputSInc=5",5)
msgbox(1,"Test _Trace","End of test: @error:=" & @error & " (expects 1))
#ce
;===============================================================================
;
; Function Name:    _Trace()
; Description:      Display messages to user containing debug information.
; Parameter(s):     $s_Msg			- Message to be displayed.
;					$i_OutputSinc	- How to display message.
;										0=default	: Search for first OutputSinc
;										1=debugger
;										2=ConsoleWrite
;										3=TrayTip
;										4=msgbox
;					$i_Timeout		- Timeout used with TrayTip and Msgbox calls
;
; Requirement(s):   Autoit > 3.1.1.75 Beta. 
;					DebugView from www.sysinternals.com is a nice to have.
; Return Value(s):  On Success - 1
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Uten: 
; Changelog:		Uten:	27 Sep 05   First release
;                           14 Mar 06   Changed name from Debug to Trace.
;							14 Mar 06   Pulished at www.autoitscrip.com
;===============================================================================
;
#include-once
Func _Trace(Const $s_Msg, Const $i_OutputSinc=0, Const $i_Timeout=5 )
	; $i_OutputSinc=[0=default, 1=debugger, 2=ConsoleWrite, 3=TrayTip, 4=msgbox]
	; If there is a debugger pressent use that
	; ElseIf scite is pressent use that
	; ElseIf trayicon is enabled then use the TrayTip
	; Else use msgbox
	
	Local $sTitleTrayTip = "Trace"
	Local $iTimeoutTrayTip = $i_Timeout
	Local $sTitleMsgBox = $sTitleTrayTip
	Local $iTimeoutMsgBox = $i_Timeout
	Local $sSciteWinTitleSub="SciTE"			; Sub pattern to search for in WinTitle
	Local $sDebugWievWinTitleSub="DebugView on"	; Sub pattern to search for in WinTitle
	Local $iReturnSuccess = 1
	Local $iReturnFailure = 0
	Local $iDone = $iReturnFailure
	
	If ($i_OutputSinc == 1 ) OR ($i_OutputSinc == 0 ) Then 
		Local $debugPrewWinTitleMatchMode = Opt("WinTitleMatchMode", 2)
		; The IsDebuggerPresent does not work with DebugView from www.sysinternal.com
		; but I have keept it because It hopfully would work when a executable is
		; started by a debugger.
		Local $aIDP = DllCall("kernel32.dll", "int", "IsDebuggerPresent")
		If (0 <> $aIDP[0]) OR WinExists($sDebugWievWinTitleSub,"") then 
			; SOURCE: http://www.autoitscript.com/forum/index.php?showtopic=6617&st=0&p=46080&#entry46080
			; KUDOS: tuape
			DllCall("kernel32.dll", "none", "OutputDebugString", "str", $s_Msg)
			Opt("WinTitleMatchMode", $debugPrewWinTitleMatchMode)
			$iDone = $iReturnSuccess
		ElseIf ($i_OutputSinc == 1 ) Then 
			;TODO: How do I provide more error information?
			SetError(1)
		EndIf 
		Opt("WinTitleMatchMode", $debugPrewWinTitleMatchMode)
	EndIf
	
	If (($i_OutputSinc == 2 ) OR ($i_OutputSinc == 0 )) And Not $iDone Then 
		
		if ($i_OutputSinc == 0) Then 
			Local $debugPrewWinTitleMatchMode = Opt("WinTitleMatchMode", 2)	
			;TODO: How do I detect that there is a application capturing ConsoleWrite? Have to use SciTE to get faltrough logic to work
			If WinExists($sSciteWinTitleSub,"") then 
				;TODO: Should we check for @LF?
				ConsoleWrite($s_Msg & @LF )
				$iDone = $iReturnSuccess				
			EndIf
			Opt("WinTitleMatchMode", $debugPrewWinTitleMatchMode)
		Else
			;TODO: Should we check for @LF?
			ConsoleWrite($s_Msg & @LF )
			$iDone = $iReturnSuccess
		EndIf 
	EndIf
	
	If (($i_OutputSinc == 3 ) OR ($i_OutputSinc == 0 )) And Not $iDone Then 
		;TraySetToolTip ($s_Msg)
		TrayTip($sTitleTrayTip, "", 0)
		TrayTip($sTitleTrayTip, $s_Msg, $iTimeoutTrayTip)
		$iDone = $iReturnSuccess
	EndIf 
	
	if (($i_OutputSinc == 4 ) OR ($i_OutputSinc == 0 )) And Not $iDone then 
		MsgBox(1, $sTitleMsgBox, $s_Msg, $iTimeoutMsgBox)
		$iDone = $iReturnSuccess
	EndIf
	
	If Not $iDone then 
		SetError(1)
	EndIf
	
	Return $iDone
EndFunc


#cs - TraceDumpArray.txt
###User Defined Function###
_TraceDumpArray

###Description###
Dump array content with call to _Trace(...). The array can be up to 6 dimensions.

###Syntax###
#include <Trace.au3>
_TraceDumpArray ( $arr, [Const $i_OutputSinc=0],[Const $i_Timeout=5] )

###Parameters###
@@ParamTable@@
$arr
Array to dump.
$i_OutputSinc
Determine how the message is displayed
Optional: 	0=Default, search for otput sinc. The search is done in same order as these options.
			1=Use a debugger (DebugView from www.sysinternal.com) as sinc
			2=Use ConsoleWrite as sinc (SciTE will capture output)
			3=Use TrayTip as sinc. 
			4=Use MsgBox as sinc
$i_Timeout
Optional: 	Set timeout in seconds. It is used with TrayTip and MsgBox in $i_OutputSInc
@@End@@

###ReturnValue###

###Remarks###

###Related###


###Example###
@@IncludeExample@@
#ce

#cs - _TraceDumpArray_Example.au3
#include <Trace.au3>
;TODO: Write _TraceDumpArray_Example code
#ce
;===============================================================================
;
; Function Name:    _TraceDumpArray()
; Description:      Dumps a array (upto 6 dimensions) to _Trace
; Parameter(s):     $arr			- Array to dump
;					$i_OutputSinc	- How to display message.
;										0=default	: Search for first OutputSinc
;										1=debugger
;										2=ConsoleWrite
;										3=TrayTip
;										4=msgbox
;					$i_Timeout		- Timeout used with TrayTip and Msgbox calls
;
; Requirement(s):   Autoit > 3.1.1.75 Beta. 
;					DebugView from www.sysinternals.com is a nice to have.
; Return Value(s):  Nothing
; Author(s):        Uten: 
; Changelog:		Uten:	27 Sep 05   First release
;                           14 Mar 06   Changed name from Debug... to Trace...
;							14 Mar 06   Added documentation.
;							14 Mar 06   Pulished at www.autoitscrip.com
;===============================================================================
Func _TraceDumpArray(ByRef $arr, Const $i_OutputSinc=0, Const $i_Timeout=5 )
	;walk a multidimensional array
	If IsArray($arr) Then 
		dim $i1, $i2, $i3, $i4, $i5, $i6
		dim $size = UBound($arr,0)
		for $i1 = 0 to UBound($arr,1) -1
			If $size <= 1 then 
				_Trace("$arr[" & $i1 & "]:=" & $arr[$i1], $i_OutputSinc, $i_Timeout)
			Else 
				for $i2 = 0 to UBound($arr,2) -1
					If $size <= 2 then 
						_Trace("$arr[" & $i1 & "][" & $i2 & "]:=" & $arr[$i1][$i2], $i_OutputSinc, $i_Timeout)
					Else 				
						for $i3 = 0 to UBound($arr,3) -1
							If $size <= 3 then 
								_Trace("$arr[" & $i1 & "][" & $i2 & "][" & $i3 & "]:=" & $arr[$i1][$i2][$i3], $i_OutputSinc, $i_Timeout)
							Else 					
								for $i4 = 0 to UBound($arr,4) -1
									If $size <= 4 then 
										_Trace("$arr[" & $i1 & "][" & $i2 & "][" & $i3 & "][" & $i4 & "]:=" & $arr[$i1][$i2][$i3][$i4], $i_OutputSinc, $i_Timeout)
									Else 						
										for $i5 = 0 to UBound($arr,5) -1
											If $size <= 5 then 
												_Trace("$arr[" & $i1 & "][" & $i2 & "][" & $i3 & "][" & $i4 & "][" & $i5 & "]:=" & $arr[$i1][$i2][$i3][$i4][$i5], $i_OutputSinc, $i_Timeout)
											Else 							
												for $i6 = 0 to UBound($arr,6) -1
													_Trace("$arr[" & $i1 & "][" & $i2 & "][" & $i3 & "][" & $i4 & "][" & $i5 & "][" & $i6 & "]:=" & $arr[$i1][$i2][$i3][$i4][$i5][$i6], $i_OutputSinc, $i_Timeout)
												Next
											EndIf
										Next
									EndIf
								Next
							EndIf
						Next
					EndIf
				Next
			EndIf
		Next	
	EndIf
EndFunc
