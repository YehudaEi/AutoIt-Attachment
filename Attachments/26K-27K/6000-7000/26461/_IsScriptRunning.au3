
#include <process.au3>
#include <_WinAPI_GetCommandLine.au3>

#region example
ConsoleWrite(_IsScriptRunning(@ScriptName))
#endregion


Func _IsScriptRunning($ScriptName)
	Local $retVal = -1
	$AutoITProcesses = _GetAutoitScripts()
	
	If $AutoITProcesses[0][0] > 0 Then
		For $i = 0 to $AutoITProcesses[0][0]
			If StringInStr($AutoITProcesses[$i][1],$ScriptName) Then $retVal = 1
	
		Next
	Else
		$retVal = 2 
		SetExtended("Autoit Process Not Found Running?")
	EndIf
	
	
	Return $retVal
EndFunc

Func _GetAutoitScripts()
	; Script Name only not full path please.
Local $AutoItEXE = _ProcessGetName(@AutoItPID)
Local $ProcessList = ProcessList()
Local $procAutoIT[1][3]
For $i = 0 to $ProcessList[0][0] 
	If $ProcessList[$i][0] = $AutoItEXE Then 
		ReDim $procAutoIT[Ubound($procAutoIT)+1][3]
			$procAutoIT[Ubound($procAutoIT)-1][0] = $ProcessList[$i][1]
			$procAutoIT[Ubound($procAutoIT)-1][1] = _WinAPI_GetCommandLineFromPID($ProcessList[$i][1])
;~ 			$procAutoIT[$i][2] = 
		EndIf
	Next
	$procAutoIT[0][0] = UBound($procAutoIT)-1
	Return $procAutoIT
EndFunc
