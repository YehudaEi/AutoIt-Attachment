#include-once
; -------------------------------------------------------------------------------------
; AutoIT Variable Inspector
; -------------------------------------------------------------------------------------
; Function:	- Inspector will show global variables, their type and value in a popup window
;			- pressing a hotkey will show the popup window
;
; Usage:	- put Inspector.au3 into your AutoIT include directory. i.e.: d:\AutoIt3\Include
;			- include Inspector.au3 in your script: #include <Inspector.au3>
;			- activate Inspector, i.e.: init_Inspector("^{F1}") in your script
;			- when runnung your script, just press assigned hotkey (i.e.: Ctrl-F1)
;			- if you want to not see some variables, use the filter_Inspector function
;
; Interface to Inspector:
;			- init_Inspector("^{F1}")		Assign Ctrl-F1 to variable lookup, activate Inspector.
;											Returns 0 for success, text string for error.
;
;			- init_Inspector("")			Unassign hotkey, deactivate Inspector.
;											Returns 0 for success, text string for error.
;
;			- filter_Inspector("win,test")	Define exclude filter list: variables will be excluded,
;											if any string from list is found in variable name.
;											Subsequent calls will overwrite previous setting.
;											Returns number of active filters.
;
;			- call_Inspector()				Shows Inspector dialog, that means no hotkeys needed.
;											You will use this function directly in your source, 
;											like  a breakpoint.
;
; Informations:
;			- feel free to use this code.
;			- Inspector should reduce your MsgBox-lines while we are waiting for a 
;				full featured IDE for AutoIT.
;			- Inspector shows only declared vars that are in global scope
;				so, if testing, you could use global variables temporary in your functions.
; -------------------------------------------------------------------------------------
Dim $Ir__aVars[1]
$Ir__aVars[0] = 0
Dim $Ir__oldHotkey = ""
Dim $Ir__filter

Func init_Inspector($Ir__Hotkey)
	Local $Ir__rc
	If $Ir__Hotkey = "" Then
		if $Ir__oldHotkey = "" Then Return "ERROR: unable to unassign hotkey, you never assigned a key before"
		$Ir__rc=HotKeySet($Ir__oldHotkey)
		if $Ir__rc <> 1 Then Return "ERROR: unable to unassign old hotkey: " & $Ir__oldHotkey
		return 0
	Else	
		$Ir__oldHotkey = $Ir__Hotkey
		$Ir__rc=HotKeySet($Ir__Hotkey,"Ir__Inspector")
		if $Ir__rc <> 1 Then Return "ERROR: unable to assign hotkey: " & $Ir__Hotkey
		return 0
	EndIf
EndFunc

Func filter_Inspector($Ir__filterin)
	$Ir__filter = StringSplit($Ir__filterin,",")
	Return $Ir__filter[0]
EndFunc

Func call_Inspector()
	Ir__Inspector()
EndFunc

Func Ir__IsInArray($Ir__val)
	Local $Ir__ii
	For $Ir__ii=1 to $Ir__aVars[0]-1
		If $Ir__aVars[$Ir__ii] = $Ir__val Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc

Func Ir__Inspector()
	Local $Ir__script=@ScriptDir & "\" & @ScriptName
	Local $Ir__file = FileOpen($Ir__script,0)
	If $Ir__file = -1 Then
		MsgBox(0, "Error in file open", "Unable to open file for read: " & $Ir__script)
		Exit
	EndIf
;	MsgBox(0, "File read:", $Ir__script)
	Local $Ir__ii = 0
	Local $Ir__jj = 0
	Local $Ir__line
	Local $Ir__aWords
	While 1
		$Ir__line = FileReadLine($Ir__file)
		If @error = -1 Then ExitLoop
		$Ir__line = StringStripWS($Ir__line,7)
		If StringLeft($Ir__line,1) = ";" OR $Ir__line = "" Then ContinueLoop
		$Ir__aWords = StringSplit($Ir__line,"= )(][,;+-/\")
		For $Ir__ii=1 to UBound($Ir__aWords)-1
			If $Ir__aWords[$Ir__ii] = "" Then ContinueLoop
			If StringLeft($Ir__aWords[$Ir__ii],1) = "$" Then
				If ((Ir__IsInArray($Ir__aWords[$Ir__ii]) = 0) AND (Not StringInStr($Ir__aWords[$Ir__ii],"$Ir__"))) Then
					$Ir__jj = $Ir__jj + 1
					ReDim $Ir__aVars[$Ir__jj+1]
					$Ir__aVars[$Ir__jj] = $Ir__aWords[$Ir__ii]
					$Ir__aVars[0] = $Ir__jj + 1
				EndIf
			EndIf
		Next
	Wend
	FileClose($Ir__script)
;MsgBox(4096,"air_vars Elements","Number of variables found: " & $Ir__aVars[0]-1)

	Local $Ir__tmp,$Ir__tmp1,$Ir__tmp2,$Ir__str
	$Ir__str = "Script:" & $Ir__script & @LF & @LF

    For $Ir__jj=1 To $Ir__aVars[0]-1
		For $Ir__ii=1 To UBound($Ir__filter)-1
			If StringInStr($Ir__aVars[$Ir__jj],$Ir__filter[$Ir__ii]) Then ContinueLoop(2)
		Next		
		$Ir__tmp = $Ir__aVars[$Ir__jj]
		$Ir__tmp1 = StringRight($Ir__tmp,StringLen($Ir__tmp)-1)
		$Ir__tmp2 = Eval($Ir__tmp1)

		If IsDeclared ($Ir__tmp1) <> 1 Then ContinueLoop
;		If ($Ir__tmp2) == "" Then ContinueLoop
			
		If Not IsArray($Ir__tmp2) Then
			if IsString($Ir__tmp2) Then $Ir__str = $Ir__str & $Ir__jj & ": " & "string " & $Ir__aVars[$Ir__jj] & " = " & $Ir__tmp2 & @LF
			if IsInt($Ir__tmp2) Then $Ir__str = $Ir__str & $Ir__jj & ": " & "int " & $Ir__aVars[$Ir__jj] & " = " & $Ir__tmp2 & @LF
			if IsFloat($Ir__tmp2) Then $Ir__str = $Ir__str & $Ir__jj & ": " & "float " & $Ir__aVars[$Ir__jj] & " = " & $Ir__tmp2 & @LF
		ElseIf IsArray($Ir__tmp2) Then
			$Ir__str = $Ir__str & $Ir__jj & ": array " & $Ir__aVars[$Ir__jj] & " = " & @LF & "      "
			For $Ir__ii=0 To UBound($Ir__tmp2)-1
				$Ir__str = $Ir__str & "[" & $Ir__ii & "]: " & $Ir__tmp2[$Ir__ii] & ", "
			Next
			$Ir__str = $Ir__str & @LF
		EndIf
		
	Next
	MsgBox(4096, "Type Variable Value", $Ir__str)

EndFunc
