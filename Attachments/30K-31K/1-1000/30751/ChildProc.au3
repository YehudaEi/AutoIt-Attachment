#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region Header
#cs
	Title:   		ChildProc UDF Library for AutoIt3
	Filename:  		ChildProc.au3
	Description: 	A collection of functions for parallel processing within AutoIT
	Author:   		seangriffin & Florian 'Piccaso' Fida (author of the "CoProc" UDF)
	Version:  		V0.4
	Last Update: 	02/06/10
	Requirements: 	AutoIt3 3.2 or higher
	Changelog:		
					---------02/06/10---------- v0.4
					Added function "_ChildProc_WriteToCOPYDATA".
					Added function "_ChildProc_ReadFromCOPYDATA".
					Added function "_ChildProc_ReadFromAllCOPYDATA".
					Added function "_ChildProc_SendCOPYDATA".
					Added function "_ChildProc_WM_COPYDATA".
					
					---------29/05/10---------- v0.3
					Removed the "wait_for_availability" parameters from all functions (not really required).  Performance improvement.
					Added environment variable functions.
					
					---------28/05/10---------- v0.2
					Removed some references to the eBay UDF.
	
					---------27/05/10---------- v0.1
					Initial release.
					
#ce
#EndRegion Header
#Region Global Variables and Constants
Global $gs_SuperGlobalRegistryBase = "HKEY_CURRENT_USER\Software\AutoIt v3\ChildProc"
Global $gi_ChildProcParent = 0
Global $gs_ChildProcReciverFunction = ""
Global $gv_ChildProcReviverParameter = 0
Global $_ChildProc_pid[1], $_ChildProc_num_children = 0
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_Start()
; Description ...:	Starts a new child process.
; Syntax.........:	_ChildProc_Start($sFunction = Default, $vParameter = Default, $max_children = 0)
; Parameters ....:	$sFunction			- The function to run within the child process.
;										  This function must not accept any parameters.
;					$vParameter			- Optional, Parameter to pass.
;					$max_children		- A limit that may be imposed on the maximum number of
;										  child processes that can be created.
;										  0 (default) = no limit on the number of concurrent children.
;										  If a limit is provided, and a call to this function exceeds this limit, then
;										  this function will wait until the number of
;										  concurrent child processes drops below this limit before starting
;										  another child.
; Return values .: 	On Success			- Returns the PID of the new child process. 
;                 	On Failure			- Returns False.
; Author ........:	Florian 'Piccaso' Fida ("_CoProc" from the CoProc UDF with minor changes by seangriffin)
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_Start($sFunction = Default, $vParameter = Default, $max_children = 0)
	
	Local $iPid
	
	If IsKeyword($sFunction) Or $sFunction = "" Then $sFunction = "__ChildProcDummy"
	
	EnvSet("ChildProc", "0x" & Hex(StringToBinary ($sFunction)))
	EnvSet("ChildProcParent", @AutoItPID)
	
	If Not IsKeyword($vParameter) Then
	
		EnvSet("ChildProcParameterPresent", "True")
		EnvSet("ChildProcParameter", StringToBinary ($vParameter))
	Else
	
		EnvSet("ChildProcParameterPresent", "False")
	EndIf

	if $max_children > 0 And $_ChildProc_num_children >= $max_children Then
		
		while _ChildProc_GetChildCount() >= $max_children
		
			Sleep(250)
		WEnd
	EndIf

	If @Compiled Then
		
		$iPid = Run(FileGetShortName(@AutoItExe), @WorkingDir, @SW_HIDE, 1 + 2 + 4)
	Else
	
		$iPid = Run(FileGetShortName(@AutoItExe) & ' "' & @ScriptFullPath & '"', @WorkingDir, @SW_HIDE, 1 + 2 + 4)
	EndIf
	If @error Then SetError(1)
	
	If $_ChildProc_pid[0] = "" Then
		
		$_ChildProc_pid[0] = $iPid
	Else
		
		_ArrayAdd($_ChildProc_pid, $iPid)
	EndIf
	
	$_ChildProc_num_children = $_ChildProc_num_children + 1
	
	Return $iPid
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_WriteToCOPYDATA()
; Description ...:	Writes data to another process ($pid), for the purposes of inter-process
;					communication between a child process and the parent script.
; Syntax.........:	_ChildProc_WriteToCOPYDATA($name, $text = Default, $pid = "")
; Parameters ....:	$name				- A variable name to write data to.
;					$text				- The variable data to write.
;					$pid				- (optional) the ID of the child process (PID) to
;										  which the data is to be sent.
;										  This parameter is not required if called from a child
;										  process, to send data to the parent.
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_WriteToCOPYDATA($name, $text = Default, $pid = "")

	Local $win_name

	; if a child process
	if $_ChildProc_num_children = 0 Then

		$win_name = "ChildProcParent"

		; wait for all messages between parent and child are consumed before continuing
		while StringLen($sMsg_Rcvd) > 0
		WEnd

		; wait for the other process to generate a fake window for the purposes of WM_COPYDATA messaging
		While WinExists($win_name) = False
		WEnd

		; get the handle of the fake window
		$receiver_hwnd = WinGetHandle($win_name)
			
		; send the variable name to the parent process
		$sMsg_Rcvd = $name
		_ChildProc_SendCOPYDATA($receiver_hwnd, $sMsg_Rcvd)

		; wait for the variable name to be consumed
		while StringLen($sMsg_Rcvd) > 0
		WEnd

		; send the variable data to the parent process
		$sMsg_Rcvd = $text
		_ChildProc_SendCOPYDATA($receiver_hwnd, $sMsg_Rcvd)
		
		; wait for a message to be consumed
		while StringLen($sMsg_Rcvd) > 0
		WEnd

	; else the parent process
	Else

		$win_name = "ChildProc" & $pid

		; wait for all messages between parent and child are consumed before continuing
		while StringLen($sMsg_Rcvd) > 0
		WEnd

		; wait for the other process to generate a fake window for the purposes of WM_COPYDATA messaging
		While WinExists($win_name) = False
		WEnd

		; get the handle of the fake window
		$receiver_hwnd = WinGetHandle($win_name)
			
		; send the variable name to the child process
		$sMsg_Rcvd = $name & $pid
		_ChildProc_SendCOPYDATA($receiver_hwnd, $sMsg_Rcvd)

		; wait for the variable name to be consumed
		while StringLen($sMsg_Rcvd) > 0
		WEnd

		; send the variable data to the child process
		$sMsg_Rcvd = $text
		_ChildProc_SendCOPYDATA($receiver_hwnd, $sMsg_Rcvd)
		
		; wait for a message to be consumed
		while StringLen($sMsg_Rcvd) > 0
		WEnd
	EndIf

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_ReadFromCOPYDATA()
; Description ...:	Reads data sent to the current process via a previous
;					"_ChildProc_WriteToCOPYDATA" call, for the purposes of inter-process
;					communication between a child process and the parent script.
; Syntax.........:	_ChildProc_ReadFromCOPYDATA($name, $pid = "")
; Parameters ....:	$name				- A variable name to read data from.
;					$pid				- (optional) the ID of the child process (PID) which
;										  created the variable (using "_ChildProc_WriteToCOPYDATA").
;										  This parameter is not required if called from a child
;										  process, to retrieve data from the parent.
; Return values .: 	On Success			- Returns the text sent by the other process. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_ReadFromCOPYDATA($name, $pid = "")

	; if a child process
	if $_ChildProc_num_children = 0 Then

		$pid = @AutoItPID
		$win_name = "ChildProcParent"

		; wait for a variable from the sender process
		while StringCompare($sMsg_Rcvd, $name & $pid) <> 0
		WEnd
		
		; get the handle of the fake window
		$sender_hwnd = WinGetHandle($win_name)
		
		; consume the variable name and notify the sender process
		$sMsg_Rcvd = ""
		_ChildProc_SendCOPYDATA($sender_hwnd, $sMsg_Rcvd)
		
		; wait for the variable data to arrive
		while StringLen($sMsg_Rcvd) = 0
		WEnd
		
		; store the data
		$sMsg_Rcvd_tmp = $sMsg_Rcvd
		
		; consume the variable data and notify the sender process
		$sMsg_Rcvd = ""
		_ChildProc_SendCOPYDATA($sender_hwnd, $sMsg_Rcvd)

	; else the parent process
	Else

		$win_name = "ChildProc" & $pid

		; wait for a variable from the sender process
		while StringCompare($sMsg_Rcvd, $name) <> 0
		WEnd

		; get the handle of the fake window
		$sender_hwnd = WinGetHandle($win_name)
		
		; consume the variable name and notify the sender process
		$sMsg_Rcvd = ""
		_ChildProc_SendCOPYDATA($sender_hwnd, $sMsg_Rcvd)

		; wait for the variable data to arrive
		while StringLen($sMsg_Rcvd) = 0
		WEnd

		; store the data
		$sMsg_Rcvd_tmp = $sMsg_Rcvd
		
		; consume the variable data and notify the sender process
		$sMsg_Rcvd = ""
		_ChildProc_SendCOPYDATA($sender_hwnd, $sMsg_Rcvd)
	EndIf

	Return $sMsg_Rcvd_tmp
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_ReadFromAllCOPYDATA()
; Description ...:	Reads text from all processes pending output using WM_COPYDATA.
; Syntax.........:	_ChildProc_ReadFromAllCOPYDATA()
; Parameters ....:	
; Return values .: 	On Success			- Returns the text within all pending child processes.
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_ReadFromAllCOPYDATA()
	
	$text = ""
	
	for $pid in $_ChildProc_pid
		
		; notify the child that we want it's output
		_ChildProc_WriteToCOPYDATA("parent ready", "true", $pid)

;ConsoleWrite("notify pid " & $pid)

		; get the child's output
		$text = $text & _ChildProc_ReadFromCOPYDATA("output", $pid)
	Next

	Return $text
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_WriteToFile()
; Description ...:	Writes text to a temporary filename, automatically named with the (child's)
;					pid, for the purposes of inter-process communication between a child 
;					process and the parent script.
; Syntax.........:	_ChildProc_WriteToFile($name, $text = Default, $pid = @AutoItPID)
; Parameters ....:	$name				- (optional) A name to associate with the $text being written.
;										  By default, the filename has a suffix of the ID of the current process (PID).
;					$text				- (optional) The text (string) to transfer.
;										  If not specified, the file with the above name will be
;										  deleted.
;					$pid				- (optional) A process ID (PID) to include in the filename
;										  to make it more unique.
;										  By default, this is the PID of the current process.
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	See _ChildProc_WriteToRegistry() for a similar method of transferring
;					data using the Windows Registry.  It has a 64Kb limit.  Note that 
;					Although no more than 64 KB of data can be written to REG_BINARY and REG_MULTI_SZ values, the other types are unlimited except under Windows 95/98/ME, which have a 64 KB limit for all types. If the 64 KB limit applies, data beyond that limit will not be written. In other words, only the first 64 KB of a very large string will be saved to the registry.
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_WriteToFile($name, $text = Default, $pid = @AutoItPID)

	$file_fullpath = @TempDir & "\_ChildProc_" & $pid & "_" & $name & ".txt"

	If $text = "" Or $text = Default Then 
		
		FileDelete($file_fullpath)
		return True
	EndIf
	
	FileDelete($file_fullpath)
	FileWrite($file_fullpath, $text)
	
	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_ReadFromFile()
; Description ...:	Reads text from a temporary filename, as previously generated by a call
;					to the function "_ChildProc_WriteToFile", for the purposes of inter-process
;					communication between a child process and the parent script.
; Syntax.........:	_ChildProc_ReadFromFile($pid, $name, $fOption = 1)
; Parameters ....:	$pid				- (optional) the ID of the process (PID) which generated the file
;										  (from a call to "_ChildProc_WriteToFile").
;					$name				- (optional) A name that was optionally associated with the file
;										  when "_ChildProc_WriteToFile" was used to generate the file.
; 					$fOption 			- (optional) If True, the file will be deleted after sucessfully reading it
; Return values .: 	On Success			- Returns the text within the file. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_ReadFromFile($pid, $name, $fOption = 1)

	$file_fullpath = @TempDir & "\_ChildProc_" & $pid & "_" & $name & ".txt"

	If $fOption = "" Or $fOption = Default Then $fOption = False
	
	$text = FileRead($file_fullpath)
	
	If $fOption Then
	
		FileDelete($file_fullpath)
	EndIf
	
	Return $text
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_ReadFromAllFiles()
; Description ...:	Reads text from all temporary files generated by previous calls to
;					"_ChildProc_WriteToFile".
; Syntax.........:	_ChildProc_ReadFromAllFiles()
; Parameters ....:	
; Return values .: 	On Success			- Returns the text within all the files generated.
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	the function "_ChildProc_WriteToFile" must have been called prior to this,
;					to generate the temporary files with the data to be read.
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_ReadFromAllFiles()
	
	$text = ""
	
	for $pid in $_ChildProc_pid
		
		$text = $text & _ChildProc_ReadFromFile($pid, "")
	Next

	Return $text
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_WriteToEnvVar()
; Description ...:	Stores data from a process into an Environment Variable, for the purposes of
;					inter-process communication between a child process and the parent script.
; Syntax.........:	_ChildProc_WriteToEnvVar($sName, $vValue = Default)
; Parameters ....:	$sName 				- The name of the environment variable
; 					$vValue 			- (optional) the value to be stored
;										  If not specified, the environment variable
;										  with the above name will be deleted.
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	seangriffin
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_WriteToEnvVar($sName, $vValue = Default)

	Local $vTmp
	
	$sName = "_CP_" & $sName
	
	If $vValue = "" Or $vValue = Default Then 
		
		EnvSet($sName)
		return True
	EndIf
	
	EnvSet($sName, $vValue)
	
	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_ReadFromEnvVar()
; Description ...:	Gets data from an Environment Variable, for the purposes of
;					inter-process communication between a child process and the parent script.
; Syntax.........:	_ChildProc_ReadFromEnvVar($sName, $fOption = 1)
; Parameters ....:	$sName 				- The name of the environment variable
; 					$fOption 			- (Optional) If True, the environment variable will be deleted after sucessfully reading it
; Return values .: 	On Success			- Returns the text from the environment variable. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	seangriffin
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_ReadFromEnvVar($sName, $fOption = 1)

	$sName = "_CP_" & $sName

	If $fOption = "" Or $fOption = Default Then $fOption = False
	
	$value = EnvGet($sName)
	
	If $fOption Then
	
		EnvSet($sName)
	EndIf
	
	Return $value
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_WriteToRegistry()
; Description ...:	Stores data from a process into the Windows Registry, for the purposes of
;					inter-process communication between a child process and the parent script.
; Syntax.........:	_ChildProc_WriteToRegistry($sName, $vValue = Default, $sRegistryBase = Default)
; Parameters ....:	$sName 				- Identifier for the registry key
; 					$vValue 			- (optional) Value to be stored 
; 					$sRegistryBase 		- (optional) Registry Base Key 
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	Florian 'Piccaso' Fida ("_SuperGlobalSet" from the CoProc UDF with minor changes by seangriffin)
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_WriteToRegistry($sName, $vValue = Default, $sRegistryBase = Default)

	Local $vTmp
	
	If $sRegistryBase = Default Then $sRegistryBase = $gs_SuperGlobalRegistryBase
	
	If $vValue = "" Or $vValue = Default Then 
		
		RegDelete($sRegistryBase, $sName)
		return True
	EndIf
	
	If @error Then 
		
		Return SetError(2, 0, False) ; Registry Problem
	Else
	
		RegWrite($sRegistryBase, $sName, "REG_BINARY", StringToBinary ($vValue))
	
		If @error Then Return SetError(2, 0, False) ; Registry Problem
	EndIf
	
	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_ReadFromRegistry()
; Description ...:	Gets data from a key in the Windows Registry, for the purposes of
;					inter-process communication between a child process and the parent script.
; Syntax.........:	_ChildProc_ReadFromRegistry($sName, $fOption = 1, $sRegistryBase = Default)
; Parameters ....:	$sName 				- Identifier for the registry key
; 					$fOption 			- (optional) If True, the registry key will be deleted after sucessfully reading it
; 					$sRegistryBase 		- (optional) Registry Base Key
; Return values .: 	On Success			- Returns the text from the registry key. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	Florian 'Piccaso' Fida ("_SuperGlobalGet" from the CoProc UDF with minor changes by seangriffin)
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_ReadFromRegistry($sName, $fOption = 1, $sRegistryBase = Default)

	Local $vTmp
	
	If $fOption = "" Or $fOption = Default Then $fOption = False
	
	If $sRegistryBase = Default Then $sRegistryBase = $gs_SuperGlobalRegistryBase
	
	$vTmp = RegRead($sRegistryBase, $sName)
	
	If @error Then Return SetError(1, 0, "") ; Registry Problem
	
	If $fOption Then
	
		_ChildProc_WriteToRegistry($sName)
	
		If @error Then SetError(2)
	EndIf
	
	Return BinaryToString ("0x" & $vTmp)
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_GetChildCount()
; Description ...:	Gets a count of all the currently child processes that currently exist
;					for the calling script.
; Syntax.........:	_ChildProc_GetChildCount()
; Parameters ....:	
; Return values .: 	On Success			- Returns a count of the number of child processes. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_GetChildCount()
	
	$num_children = 0
	
	for $pid_num = 0 To (UBound($_ChildProc_pid) - 1)
	
		if ProcessExists($_ChildProc_pid[$pid_num]) = True Then $num_children = $num_children + 1
	Next
	
	Return $num_children
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_SendCOPYDATA()
; Description ...:	Sends data to a window (via WM_COPYDATA).
; Syntax.........:	_ChildProc_SendCOPYDATA($hWnd, $sData)
; Parameters ....:	$hWnd 				- The handle to the window that is to receive the data.
; 					$sData	 			- The data to send.
; Return values .: 	On Success			- Returns a count of the number of child processes. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_SendCOPYDATA($hWnd, $sData)

    Local $tCOPYDATA, $tMsg

    $tMsg = DllStructCreate("char[" & StringLen($sData) + 1 & "]")
    DllStructSetData($tMsg, 1, $sData)
    $tCOPYDATA = DllStructCreate("dword;dword;ptr")
    DllStructSetData($tCOPYDATA, 2, StringLen($sData) + 1)
    DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMsg))
    $Ret = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hWnd, "int", $WM_COPYDATA, "wparam", 0, "lparam", DllStructGetPtr($tCOPYDATA))
    If (@error) Or ($Ret[0] = -1) Then Return 0
    Return 1
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_ChildProc_WM_COPYDATA()
; Description ...:	Registers the Win32 WM_COPYDATA messaging service.
; Syntax.........:	_ChildProc_WM_COPYDATA($hWnd, $msgID, $wParam, $lParam)
; Parameters ....:	
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _ChildProc_WM_COPYDATA($hWnd, $msgID, $wParam, $lParam)

	Local $tCOPYDATA = DllStructCreate("dword;dword;ptr", $lParam)
    Local $tMsg = DllStructCreate("char[" & DllStructGetData($tCOPYDATA, 2) & "]", DllStructGetData($tCOPYDATA, 3))
    $sMsg_Rcvd = DllStructGetData($tMsg, 1)
    Return 0
EndFunc

#region Internal Functions
Func __ChildProcStartup()

	Local $sCmd = EnvGet("ChildProc")
	
	If StringLeft($sCmd, 2) = "0x" Then
	
		$sCmd = BinaryToString ($sCmd)
		$gi_ChildProcParent = Number(EnvGet("ChildProcParent"))
	
		If StringInStr($sCmd, "(") And StringInStr($sCmd, ")") Then
	
			Execute($sCmd)
			
			If @error And Not @Compiled Then MsgBox(16, "ChildProc Error", "Unable to Execute: " & $sCmd)
	
			Exit
		EndIf
	
		If EnvGet("ChildProcParameterPresent") = "True" Then
	
			Call($sCmd, BinaryToString (EnvGet("ChildProcParameter")))
	
			If @error And Not @Compiled Then MsgBox(16, "ChildProc Error", "Unable to Call: " & $sCmd & @LF & "Parameter: " & BinaryToString (EnvGet("ChildProcParameter")))
		Else
	
			Call($sCmd)
			
			If @error And Not @Compiled Then MsgBox(16, "ChildProc Error", "Unable to Call: " & $sCmd)
		EndIf
	
		Exit
	EndIf
EndFunc

Func __ChildProcDummy($vPar = Default)

	If Not IsKeyword($vPar) Then _ChildProcReciver($vPar)
	While ProcessExists($gi_ChildProcParent)
	Sleep(500)
	WEnd
EndFunc

__ChildProcStartup()

#endregion