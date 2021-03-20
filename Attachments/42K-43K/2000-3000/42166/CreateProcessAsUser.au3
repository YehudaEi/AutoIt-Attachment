#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=CreateProcessAsUser.exe
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.9.21 (Beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <winapi.au3>
#include <array.au3>
#include <security.au3>
#include <StructureConstants.au3>

$NULL = 0
$WTS_CURRENT_SERVER_HANDLE = $NULL
$WTSActive = 0
$WTSShadow = 1
$WTSConnectQuery = 2
$CREATE_UNICODE_ENVIRONMENT = 0x00000400
$DETACHED_PROCESS = 0x00000008
$MAX_PATH = 260
$PROCESS_ALL_ACCESS = 0x001F0FFF
;~ $TOKEN_ALL_ACCESS = 0xf01ff
$ERROR_SUCCESS = 0
Global Const $tagWTS_SESSION_INFO = 'dword SessionId;ptr WinStationName;uint State'
$CREATE_NEW_CONSOLE = 0x00000010
$NORMAL_PRIORITY_CLASS = 0x20

RunOnDesktop(@ComSpec, False)

Func RunOnDesktop($app_path, $UseSystemRights=False)
	Local $bReturn = False
	Local $hToken = 0
	Local $env = 0
	Local $iConsoleID = 0
	Local $iProcessPID = 0
	Local $iWinlogonPID = 0
	Local $hWinlogon = 0

	;Get active Desktop ID
	$iConsoleID = WTSGetActiveConsoleSessionId()
	If $UseSystemRights Then
		$iWinlogonPID = _GetWinLogonPID($iConsoleID)
		;MsgBox(0, "Debug", $iWinlogonPID)
		$hWinlogon = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS,False,$iWinlogonPID) ;_ProcessGetHandle($iWinlogonPID)
		;MsgBox(0, "Debug", $hWinlogon)
		$hWinLogonToken = _Security__OpenProcessToken($hWinlogon,$TOKEN_ALL_ACCESS) ;_OpenProcessToken($hWinlogon)
		;MsgBox(0, "Debug", $hToken)
		$hToken = _Security__DuplicateTokenEx($hWinLogonToken, $TOKEN_ALL_ACCESS, $SECURITYIMPERSONATION, $TOKENPRIMARY) ;_DuplicateToken($hToken)
		_WinAPI_CloseHandle($hWinLogonToken);
		_WinAPI_CloseHandle($hWinlogon);
	Else
		;SetTBCPrivileges()
		$hToken = WTSQueryUserToken($iConsoleID)
	EndIf

	;CreateEnvironmentBlock($env, $hToken, False)

	$si=dllstructcreate($tagSTARTUPINFO)
	$pi=dllstructcreate($tagPROCESS_INFORMATION)
	$lpProcessAttributes=dllstructcreate($tagSECURITY_ATTRIBUTES)
	$lpThreadAttributes=dllstructcreate($tagSECURITY_ATTRIBUTES)
	DLLStructSetData($lpThreadAttributes,"Descriptor","")
	$ta_size=dllstructgetsize($lpThreadAttributes)
	DLLStructSetData($lpThreadAttributes,"Length",$ta_size)
	DLLStructSetData($lpProcessAttributes,"Descriptor","")
	$pa_size=dllstructgetsize($lpProcessAttributes)
	DLLStructSetData($lpProcessAttributes,"Length",$pa_size)
	DLLStructSetData($si,"lpDesktop","winsta0\default")
	$pi_size=dllstructgetsize($pi)
	$si_size=dllstructgetsize($si)
	DLLStructSetData($pi,"Size",$pi_size)
	DLLStructSetData($si,"Size",$si_size)
	$ret = CreateProcessAsUser($hToken, 0, $app_path, DllStructGetPtr($lpProcessAttributes), DllStructGetPtr($lpThreadAttributes), 0, $NORMAL_PRIORITY_CLASS + $CREATE_NEW_CONSOLE, $env, "", DllStructGetPtr($si), DllStructGetPtr($pi))
	$iProcessPID = DllStructGetData($pi, "ProcessID")
	_WinAPI_CloseHandle($hToken);

	;~ _MsgBox(0, 4, "abc")
	;CreateProcessAsUser(hToken,NULL,app_path,NULL,NULL,FALSE,CREATE_UNICODE_ENVIRONMENT |DETACHED_PROCESS,lpEnvironment,NULL,&StartUPInfo,&ProcessInfo)// C++
	;~ _MsgBox(0, $env, DllStructGetData($ProcessInfo, 3))
	Return $iProcessPID
EndFunc ;==>LaunchProcessWin


Func SetTBCPrivileges()
	$dwPID = @AutoItPID
	$hToken = 0
	$hProcess = 0
	$tpDebug = DllStructCreate($tagTOKEN_PRIVILEGES)
	$hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS,False,$dwPID)
	If not $hProcess Then return False
	;If not _WinAPI_OpenProcessToken($hProcess,$TOKEN_ALL_ACCESS,$hToken) Then return False
	$hToken = _Security__OpenProcessToken($hProcess,$TOKEN_ALL_ACCESS)
	If @error Then Return False

	$LUID = _Security__LookupPrivilegeValue("", $SE_DEBUG_NAME)
	if $LUID == 0 Then Return False
	DllStructSetData($tpDebug,"Count",1)
	DllStructSetData($tpDebug,"LUID",$LUID,1)
	DllStructSetData($tpDebug,"Attributes",$SE_PRIVILEGE_ENABLED,1)
	if _Security__AdjustTokenPrivileges($hToken,False,DllStructGetPtr($tpDebug),DllStructGetSize($tpDebug),$NULL,$NULL) = False Then Return false
	if _WinAPI_GetLastError() <> $ERROR_SUCCESS Then Return False
	_WinAPI_CloseHandle($hToken);
	_WinAPI_CloseHandle($hProcess);
Return true
EndFunc

Func WTSGetActiveConsoleSessionId()
	$Ret = DllCall('Kernel32.dll', 'dword', 'WTSGetActiveConsoleSessionId')
	Return $Ret[0]
EndFunc ;==>WTSGetActiveConsoleSessionId

Func WTSQueryUserToken($SessionId)
	$struct = DllStructCreate("HANDLE")
	$Ret = DllCall('wtsapi32.dll', 'bool', 'WTSQueryUserToken', _
	'ULONG', $SessionId, _
	'ptr*', DllStructGetPtr($struct))
	Return $Ret[2]
EndFunc ;==>WTSQueryUserToken

Func CreateProcessAsUser($hToken, $lpApplicationName, $lpCommandline, $lpProcessAttributes, $lpThreadAttributes, $bInheritHandles, $dwCreationFlags, $lpEnvironment, $lpCurrentDirectory, $lpStartupInfo, $lpProcessInformation)
	$ret = DllCall("advapi32.dll", "bool", "CreateProcessAsUserW", _ ; W is better
	"handle", $hToken, _
	"ptr", 0, _ ;$lpApplicationName, _
	"wstr", $lpCommandline, _ ; wstr for CreateProcessAsUserW
	"ptr", $lpProcessAttributes, _
	"ptr", $lpThreadAttributes, _
	"bool", 0, _ ;$bInheritHandles, _
	"dword", $dwCreationFlags, _
	"ptr", 0, _
	"ptr", 0, _
	"ptr", $lpStartupInfo, _
	"ptr", $lpProcessInformation)
	;If $ret[0] = 0 Then _MsgBox(16, "proc e "&@error&" "&$hToken, _WinAPI_GetLastErrorMessage())
	Return $ret[0]
EndFunc ;==>CreateProcessAsUser

Func _GetWinLogonPID($iActiveSession)
Local $aWinlogon, $i
	$aWinlogon = ProcessList ("winlogon.exe")

	For $i = 1 To $aWinlogon[0][0]
		If $iActiveSession = _ProcessGetSessionID($aWinlogon[$i][1]) Then
			Return $aWinlogon[$i][1]
		EndIf
	Next
	Return 0
EndFunc

Func _ProcessGetSessionID($vProcessID)
	Local $aRet=DllCall("Kernel32.dll","bool","ProcessIdToSessionId","dword",$vProcessID,"dword*",0)
	If @error Then Return SetError(2,@error,-1)
	If Not $aRet[0] Then Return SetError(3,0,-1)
	Return $aRet[2]
EndFunc
