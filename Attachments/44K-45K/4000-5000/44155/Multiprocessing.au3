;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; change log:
; 2014.5.15: Add AllSubProcess_Close function, and remove "An other limitation is I found if child process 
;                   (indicate function that pass to child process) wants use some functions from other UDF, better also add 
;                   them in this UDF head (remove this statement). But 3.3.11.4 and 3.3.10.2 has different  behiave without this action".
;                   Update to "Another attention is please place Multiprocessing.au3 to end of #include, then Multiprocessing.au3 can find your 
;                   what UDF need to use."
;--------------------------------------------------------------------------------------------------------------------------------------------------------

; -------------------------------------------------------------------------------------------------------------------
; Multiprocessing UDF (2014/04/15)
; Version: 0.1
; Purpose: Similar to the threading.  Simulate Python's multiprocessing framework and import into Autoit
; Author: oceanwaves
; Required: AutoIt v3.3.10.2 or above
; Tested with AutoIt Version 3.3.10.2 and 3.3.11.4

; Multiprocessing of Python 3 website: https://docs.python.org/3.1/library/multiprocessing.html
; Python's Multirprocessing introduction: http://pymotw.com/2/multiprocessing/basics.html

; The limitation:
; Because I use Ward's JSMN.au3 UDF for Autoti data serialization, and pass them to child process,
; so according to description from JSMN.au3, "Except object and null, other JSON data type will be decoded into corresponding
; AutoIt variable, including array, string, number, true, and false...Other unsupported types like 2D array, dllstruct
; or object will be encoded into null." Detail information please refer to 
; http://www.autoitscript.com/forum/topic/148114-jsmn-a-non-strict-json-udf/
; 
; Another attention is please place Multiprocessing.au3 to end of #include, then Multiprocessing.au3 can find your what UDF need to use.
; You can try. I think it related with Autoit interpreter how to find them. Maybe
; Autoit team can explain why.;

;  _CreateRandomString function is searched from Autoit Forum. Then further search, it should from guinness
; -------------------------------------------------------------------------------------------------------------------

; ---------------------------------------------------------------------------------------------------------------
; Public Function list:
; SubProcess
; SubProcess_Run
; GetActiveProcessCount
; GetActiveProcessList
; GetProcessExitCode
; GetProcessID
; ProcessIsAlive
; SubProcess_Join
; AllSubProcess_Close
;---------------------------------------------------------------------------------------------------------------

#include-once

#include <WinAPI.au3>
#include <WinAPIFiles.au3>
#include <WinAPIProc.au3>
#include <Debug.au3>
#include <Array.au3>
#include ".\3rd_UDF\JSMN\JSMN.au3" ;; JSMN.au3 in my PC location. Please replace to JSMN.au3 location in your PC.

Local $hJobObject ;, $MaxmumProcessLimit = 0
multiprocessing_main()

; #FUNCTION# ====================================================================================================================
; Name ..........: _is_subProcess
; Description ...: Determine current process is child process or not. Internal using.
; Syntax ........: _is_subProcess()
; Parameters ....: None
; Return values .: Child process is True or return False
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: Simulate Python's fork module in the multiprocessing modulel
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _is_subProcess()
	If $CmdLine[0] >= 1 And $CmdLine[1] == "multiprocessing-subprocess" Then Return True
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: SubProcess
; Description ...: 
; Syntax ........: SubProcess($Func, $args[, $group = ""])
; Parameters ....: $Func                - Functoin object.
;                  $args                - An 1-D array of $Func parameters. If no arguments please pass a null array.
;                  $group               - [optional] An unknown value. Default is "". Reserved, don't use it.
; Return values .: Success: Process struct
;                           Failure: sets @error to non-zero : 1------using group parameter
;                                                                                 2------Passed a invaild function
;                                                                                 3------function arguments is not saved in a 1-D array
;                                                                                 4------internal function error
;                                                                                 5------Create chidl process failed
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func SubProcess($Func, $args, $group="");, $name = "", $daemon = False)
	_Assert(Not _is_subProcess())
	;$group argument is reserved
	If $group = Default Then $group = ""
	If $group <> "" Then Return SetError(1, 0, "group parameter is reserved.")

	;Covnert Function object to string
	$Func = FuncName($Func)
	If @error Then Return SetError(2, 0, "Invalid function.")

	;The arguments for Function must be stored in one-dimensioned array, if it is an arrya then calculate byte size
	If UBound($args, 0) <> 1 Then Return SetError(3, 0, "arguments of function must be in 1-dimension array.")
	_ArrayAdd($args, $Func);add function name to end of the array. When child process to read it after decoding, using _ArrayPop

	Local $Preparation_Data = _PreparationData($args);Function _PreparationData will send data to file mapping, then return related file mapping info by a array
	If @error Then SetError(4, 0, "PreparationData function error.")

	;Miss prceoss name processing

	;Determine whether complied
	Local $para1, $para2
	If @Compiled Then
		$para1 = @ScriptFullPath
		$para2 = " multiprocessing-subprocess " & "fileMapping-" & _GetPreparationData($Preparation_Data, "size") & "-" & _GetPreparationData($Preparation_Data, "name")
	Else
		$para1 = @AutoItExe
		$para2 = " " & @ScriptFullPath & " multiprocessing-subprocess " & "fileMapping-" & _GetPreparationData($Preparation_Data, "size") & "-" & _GetPreparationData($Preparation_Data, "name")
	EndIf
		;ConsoleWrite("----para1:" & $para1 & @CRLF)
		;ConsoleWrite("----para2:" & $para2 & @CRLF)
	;Create process with job flag
	Local $tProcess = DllStructCreate($tagPROCESS_INFORMATION)
	Local $tStartup = DllStructCreate($tagSTARTUPINFO)
	If Not _WinAPI_CreateProcess($para1, $para2, 0, 0, False, BitOR($CREATE_BREAKAWAY_FROM_JOB, $CREATE_SUSPENDED), 0, "", DllStructGetPtr($tStartup), DllStructGetPtr($tProcess)) Then
		_WinAPI_UnmapViewOfFile(_GetPreparationData($Preparation_Data, "pointer"))
		_WinAPI_CloseHandle(_GetPreparationData($Preparation_Data, "handle"))
		Return SetError(5, 0, "Create process fail.")
	Else
		;Dulicate fileMapping object to child process, then close it in parent process
		_WinAPI_DuplicateHandle(_WinAPI_GetCurrentProcess(), _GetPreparationData($Preparation_Data, "handle"), DllStructGetData($tProcess, "hProcess"), Default, True, $DUPLICATE_SAME_ACCESS)
		_WinAPI_UnmapViewOfFile(_GetPreparationData($Preparation_Data, "pointer"))
		_WinAPI_CloseHandle(_GetPreparationData($Preparation_Data, "handle"))
	EndIf
	Return $tProcess
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: SubProcess_Run
; Description ...: Let child process join a job object and resume child process running
; Syntax ........: SubProcess_Run($ProcessStruct)
; Parameters ....: $ProcessStruct       - Process struct that returned by SubProcess function
; Return values .: Success: True
;                           Failure: Return False and sets @error to non-zero: 1-------AssignProcessToJobObject fail.
;                                                                                                            2-------Run process fail
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: job object information: http://msdn.microsoft.com/en-us/library/windows/desktop/ms684161%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func SubProcess_Run($ProcessStruct)
	_Assert(Not _is_subProcess())
	If Not _WinAPI_AssignProcessToJobObject($hJobObject, DllStructGetData($ProcessStruct, "hProcess")) Then 
    ProcessClose(DllStructGetData($ProcessStruct, "ProcessID"))
    Return SetError(1, 0, False) ;;"AssignProcessToJobObject fail."
  EndIf
	_WinAPI_ResumeThread(DllStructGetData($ProcessStruct, "hThread"))
	If @error Then
		ProcessClose(DllStructGetData($ProcessStruct, "ProcessID"))
		Return SetError(2, 0, False) ;;Run process fail.
	EndIf
	Return True
EndFunc

; only main process using
; #FUNCTION# ====================================================================================================================
; Name ..........: GetActiveProcessCount
; Description ...: Query how many child process is alive. 
; Syntax ........: GetActiveProcessCount()
; Parameters ....: None
; Return values .: How many child process is active.
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........:  job object information: http://msdn.microsoft.com/en-us/library/windows/desktop/ms684161%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func GetActiveProcessCount()
	_Assert(Not _is_subProcess())
	Local $tInfo = DllStructCreate($tagJOBOBJECT_BASIC_ACCOUNTING_INFORMATION)
	If _WinAPI_QueryInformationJobObject($hJobObject, 1, $tInfo) = 0 Then Return SetError(1, 0, -1)
	Return DllStructGetData($tInfo, "ActiveProcesses")
EndFunc

; only main process using
; #FUNCTION# ====================================================================================================================
; Name ..........: GetActiveProcessList
; Description ...: Return current live child PID list,  but beware processes which have already finished during you using this list.
; Syntax ........: GetActiveProcessList()
; Parameters ....: None
; Return values .: A 1-D array contains child PID
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func GetActiveProcessList()
	_Assert(Not _is_subProcess())
	;Local $tInfo = DllStructCreate('dword NumberOfAssignedProcesses;dword NumberOfProcessIdsInList;ulong_ptr ProcessIdList[1]')
	;If Not _WinAPI_QueryInformationJobObject($hJob, 3, $tInfo) Then Return SetError(1, 0, -1)
	Local $iNumberOfProcess = GetActiveProcessCount()
	If @error Then Return SetError(1, 0, -1)
	$tInfo = DllStructCreate('dword NumberOfAssignedProcesses;dword NumberOfProcessIdsInList;ulong_ptr ProcessIdList[' & $iNumberOfProcess & ']')
	If Not _WinAPI_QueryInformationJobObject($hJobObject, 3, $tInfo) Then Return SetError(1, 0, -1)
	Local $aProcessList[0]
	For $x = 1 To $iNumberOfProcess
		If DllStructGetData($tInfo, "ProcessIdList", $x) <> 0 Then _ArrayAdd($aProcessList, DllStructGetData($tInfo, "ProcessIdList", $x))
	Next
	Return $aProcessList
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GetProcessExitCode
; Description ...: Becareful, according to MSDN, if the GetExitCodeProcess failed, it returens 0, but exit code also can be 0, can't distinguish them.
; Syntax ........: GetProcessExitCode($ProcessStruct)
; Parameters ....: $ProcessStruct       - Process struct that returned by SubProcess function
; Return values .: Exit code that returned by specific process
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: Please refer with Autoit help file about _WinAPI_GetExitCodeProcess.
; Example .......: No
; ===============================================================================================================================
Func GetProcessExitCode($ProcessStruct)
  Local $iCode = _WinAPI_GetExitCodeProcess(DllStructGetData($ProcessStruct, "hProcess"))
  If @error Then Return SetError(1, 0, False)
  Return $iCode
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: GetProcessID
; Description ...: From process struct get PID
; Syntax ........: GetProcessID($ProcessStruct)
; Parameters ....: $ProcessStruct       -  Process struct that returned by SubProcess function
; Return values .: Success: PID
;                          Failure: 0
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func GetProcessID($ProcessStruct)
	If Not IsDllStruct($ProcessStruct) Then Return SetError(1, 0, 0)
	Return DllStructGetData($ProcessStruct, "ProcessID"); if return 0 means failure
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: ProcessIsAlive
; Description ...: Determine the specific process is alive
; Syntax ........: ProcessIsAlive($ProcessStruct)
; Parameters ....: $ProcessStruct       - Process struct that returned by SubProcess function
; Return values .: Success: True. The specific process is alive
;                          Failure: Flase. The process is exit or the process is not child process.
;                          @error: 1-----Parameter invalid. 
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func ProcessIsAlive($ProcessStruct)
	If Not IsDllStruct($ProcessStruct) Then Return SetError(1, 0, -1)
	If ProcessExists(DllStructGetData($ProcessStruct, "ProcessID")) And _WinAPI_IsProcessInJob(DllStructGetData($ProcessStruct, "hProcess"), $hJobObject) Then Return True
	Return False
EndFunc
#cs
Func GetMaxmumProcessLimit()
	If $MaxmumProcessLimit <= 0 Then
		Return 0
	Else
		Return $MaxmumProcessLimit
	EndIf
EndFunc

Func SetMaxmumProcessLimit($limit)
	If IsInt($limit) Then
		$MaxmumProcessLimit = $limit
	Else
		SetError(1)
	EndIf
EndFunc
#ce
; #FUNCTION# ====================================================================================================================
; Name ..........: _WinAPI_ResumeThread
; Description ...: Resume child process running
; Syntax ........: _WinAPI_ResumeThread($hThread)
; Parameters ....: $hThread             - A handle value.
; Return values .: None
; Author ........: Autoit help file
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: Please check Autoit helpfile about _WinAPI_CreateJobObject, copy from there.
; Example .......: No
; ===============================================================================================================================
Func _WinAPI_ResumeThread($hThread)
	Local $Ret = DllCall('kernel32.dll', 'dword', 'ResumeThread', 'ptr', $hThread)
	If @error Or (_WinAPI_DWordToInt($Ret[0]) = -1) Then Return SetError(1, 0, -1)
	Return $Ret[0]
EndFunc   ;==>_WinAPI_ResumeThread

; #FUNCTION# ====================================================================================================================
; Name ..........: SubProcess_Join
; Description ...: Waiting until sepcific process exit
; Syntax ........: SubProcess_Join($ProcessStruct[, $TimeOut = 0])
; Parameters ....: $ProcessStruct       -  Process struct that returned by SubProcess function
;                  $TimeOut             - [optional] waiting time before process exit. Default is 0. 0 means no wating, return result immediately
; Return values .: True means process is exit. False means process still exist.
;                           @error ------- -1, parameter invalid.
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func SubProcess_Join($ProcessStruct, $TimeOut=0)
	If Not IsDllStruct($ProcessStruct) Or Not IsInt($TimeOut) Or $TimeOut < 0 Then Return SetError(1, 0, -1)
	If Not ProcessIsAlive($ProcessStruct) Then Return True
	If ProcessWaitClose(DllStructGetData($ProcessStruct, "ProcessID"), $TimeOut) = 1 Then Return True
	Return False
EndFunc

; Prepare fucntion using determine self is chidl process or not. If not child process then do some pre-action.
Func multiprocessing_main()
	If _is_subProcess() Then
		Local $sFileMapName = StringSplit($CmdLine[2], "-", 2)[2]
		_Assert($sFileMapName <> "")
		Local $hFileMap = _WinAPI_OpenFileMapping($sFileMapName)
		Local $pBuffer = _WinAPI_MapViewOfFile($hFileMap)
		Local $tArgs = DllStructCreate("BYTE[" & StringSplit($CmdLine[2], "-", 2)[1] & "]", $pBuffer)
		Local $args = Jsmn_Decode(BinaryToString(DllStructGetData($tArgs, 1), 4))
    _WinAPI_UnmapViewOfFile($pBuffer)
    _WinAPI_CloseHandle($hFileMap)
		Local $Func = _ArrayPop($args)
		If UBound($args) = 0 Then
			Call($Func)
		Else
			_ArrayInsert($args, 0, "CallArgArray")
			Call($Func, $args)
		EndIf
		If @error=0xDEAD And @extended=0xBEEF Then Exit -255
		Exit; if this statement is not exist, then will jump out this au3 and go to main process scope.
	Else
		$hJobObject = _WinAPI_CreateJobObject()
		_Assert($hJobObject <> 0)
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _CreateRandomString
; Description ...: Generate a random string, consists with characters and numbers.
; Syntax ........: _CreateRandomString($length)
; Parameters ....: $length              - length
; Return values .: Return a radom string that is sepcific length
; Author ........:  guinness
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://www.autoitscript.com/wiki/Snippets_%28_Miscellaneous_%29
;                  http://www.autoitscript.com/forum/topic/96701-random-text/
; Example .......: No
; ===============================================================================================================================
Func _CreateRandomString($length)
	Local $sText = "", $temp
	For $i = 1 To $length
		$temp = Random(55, 116, 1)
		$sText &= Chr($temp+6*($temp>90)-7*($temp<65))
	Next
	Return $sText
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _PreparationData
; Description ...: Internel function using only. The data will send to mapping file, and child process will receive them.
; Syntax ........: _PreparationData($aArguments)
; Parameters ....: $aArguments          - a 1-D array that represnting function arguments collection 
; Return values .: None
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: Please windows mapping file on the MSDN
; Example .......: No
; ===============================================================================================================================
Func _PreparationData($aArguments)
	Local $MP_iSizeOfMapping = BinaryLen(StringToBinary(Jsmn_Encode($aArguments),4));Convert string to byte with UTF-8 then using in size for file mapping
	Local $MP_sFileMapName = _CreateRandomString(10) & "_" & @YEAR & @YDAY & @HOUR & @MIN & @SEC & @MSEC;Random + time to be avoid repeart as far as possible.
	Local $MP_hFileMap = _WinAPI_CreateFileMapping(-1, $MP_iSizeOfMapping, $MP_sFileMapName, $PAGE_READWRITE)
	If $MP_hFileMap = 0 Then Return SetError(1, 0, "CreateFileMapping fail.")
	Local $MP_pBuffer = _WinAPI_MapViewOfFile($MP_hFileMap)
	If $MP_pBuffer = 0 Then Return SetError(1, 0, "MapViewOfFile fail.")
	Local $tData = DllStructCreate("BYTE[" & $MP_iSizeOfMapping & "]" , $MP_pBuffer)
	DllStructSetData($tData, 1, StringToBinary(Jsmn_Encode($aArguments),4))
  If Not _WinAPI_FlushViewOfFile($MP_pBuffer) Then Return SetError(1, 0, "FlushViewOfFile fail.")
	Local $aData = [$MP_hFileMap, $MP_sFileMapName, $MP_pBuffer, $MP_iSizeOfMapping]
	Return $aData
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetPreparationData
; Description ...: Internel function using only.
; Syntax ........: _GetPreparationData($Preparation_Data, $sDataName)
; Parameters ....: $Preparation_Data    - Returnd by  _PreparationData function. Actaully the data includes mapping file information.
;                  $sDataName           - A string value. That indicate what detail information wants to return.
; Return values .: None
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _GetPreparationData($Preparation_Data, $sDataName)
	For $x in $Preparation_Data
		If $x = "" Then Return SetError(1, 0, 0)
	Next
	Switch $sDataName
		Case "handle"
			Return $Preparation_Data[0]
		Case "name"
			Return $Preparation_Data[1]
		Case "pointer"
			Return $Preparation_Data[2]
		Case "size"
			Return $Preparation_Data[3]
		Case Else
			SetError(1)
	EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: SubProcess_Close
; Description ...: Terminate subprocess that in the job
; Syntax ........: SubProcess_Close([$ProcessStruct = 0])
; Parameters ....:  $iExitCode             -   The exit code to be used by all processes and threads in the job object. Default is 0
; Return values .: None
; Author ........: oceanwaves
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms686709%28v=vs.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func AllSubProcess_Close($iExitCode = 0)
  If $iExitCode = Default Then $iExitCode = 0
  If _WinAPI_TerminateJobObject($hJobObject, $iExitCode) Then Return True
  Return SetError(1, 0, False)
EndFunc
