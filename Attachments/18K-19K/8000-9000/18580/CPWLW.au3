opt("RunErrorsFatal",0)
opt("MustDeclareVars",0)
;For 'CreateProcessWithLogonW' -> dwLogonFlags
Global Const $LOGON_WITH_PROFILE = 0x1
Global Const $LOGON_NETCREDENTIALS_ONLY = 0x2
;For'CreateProcessWithLogonW' -> dwCreationFlags
Global Const $CREATE_DEFAULT_ERROR_MODE = 0x4000000
;Les initialisations
Dim $STARTUPINFO = "",$si=""
Dim $PROCESS_INFORMATION ="",$pi=""
;
$STARTUPINFO &= "dword cb;long lpReserved;long lpDesktop;long lpTitle;dword dwX;dword dwY;"
$STARTUPINFO &= "dword dwXSize;dword dwYSize;dword dwXCountChars;dword dwYCountChars;"
$STARTUPINFO &= "dword dwFillAttribute;dword dwFlags;short wShowWindow;short cbReserved2;long lpReserved2;"
$STARTUPINFO &= "long hStdInput;long hStdOutput;long hStdError"
$si = DllStructCreate($STARTUPINFO)
If $si = 0 Then
	msg(@error)
	Exit
EndIf
DllStructSetData($si,"cb",DllStructGetSize($si))
$ptrSI = DllStructGetPtr($si)
;~ Msg($ptrSI)

$PROCESS_INFORMATION &= "long hProcess;long hThread;long dwProcessId;long dwThreadId"
$pi = DllStructCreate($PROCESS_INFORMATION)
If $pi = 0 Then
	msg(@error)
	Exit
EndIf
$ptrPI = DllStructGetPtr($pi)
;~ Msg($ptrPI)

$arrRet = DllCall("advapi32.dll","long","CreateProcessWithLogonW", _
	"wstr","user", _
	"wstr","domain", _
	"wstr","password", _
	"dword",$LOGON_WITH_PROFILE, _
	"wstr","", _
	"wstr","c:\windows\notepad.exe", _
	"dword",$CREATE_DEFAULT_ERROR_MODE, _
	"ptr",0, _
	"ptr",0, _
	"ptr",$ptrSI, _
	"ptr",$ptrPI)
If Not @error and $arrRet[0]<>0 Then
	$arrRet = DllCall("kernel32.dll", "int", "CloseHandle", "ptr",DllStructGetPtr($pi,"dwProcessId"))
	If Not @error and $arrRet[0]<>0 Then
		Msg("Return of 'CloseHandle' : "& $arrRet[0])
	Else
		Msg("Error (CloseHandle): "& @error)
		Msg("Return of 'CloseHandle' : "& $arrRet[0])
		Exit 1
	EndIf
Else
	Msg("Error (CreateProcessWithLogonW) : "& @error)
	Msg("Return of 'CreateProcessWithLogonW' : "& $arrRet[0])
	Exit 2
EndIf
Exit 0
;
Func Msg($letexte)
	MsgBox(0x43000,"Message...",$letexte)
EndFunc

