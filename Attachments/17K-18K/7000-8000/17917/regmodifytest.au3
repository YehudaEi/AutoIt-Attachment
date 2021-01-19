; Test Script for Registry Permission Modifications
#include <Security.au3>

Opt("RunErrorsFatal",0)

Global Const $SECURITY_DESCRIPTOR_REVISION = 1
Global Const $ACL_REVISION = 2

;Global Const $GENERIC_ALL = 1 ; Defined in the Include, but listed here just for my sanity
Global Const $READ_CONTROL = 0x20000
Global Const $WRITE_DAC = 0x40000 ; 0x40000L
Global Const $DACL_SECURITY_INFORMATION = 4

Global Const $HKEY_LOCAL_MACHINE = 0X80000002
Global Const $KEY_QUERY_VALUE = 1
Global Const $KEY_ENUMERATE_SUB_KEYS = 8

Global Const $OBJECT_INHERIT_ACE = 1
Global Const $CONTAINER_INHERIT_ACE = 2

Global Const $SECURITY_DESCRIPTOR = "byte Revision;byte Sbz1;dword Control;ptr Owner;ptr Group;ptr Sacl;ptr Dacl"
Global Const $ACL = "byte AclRevision;byte Sbz1;short AclSize;short AclCount;short Sbz2"
Global Const $ACCESS_ALLOWED_ACE = "byte AceType;byte AceFlags;short AceSize;dword Mask;dword SidStart"
Global Const $ACE_HEADER = "byte AceType;byte AceFlags;short AceSize"

Local $admin_mask = BitOR($WRITE_DAC,$READ_CONTROL,$KEY_QUERY_VALUE,$KEY_ENUMERATE_SUB_KEYS)

Local $ap[2][2]
$ap[0][0] = "SYSTEM"
$ap[0][1] = $GENERIC_ALL
$ap[1][0] = "Administrators"
$ap[1][1] = $admin_mask

Local $sids[2]
Local $acl_size = 2 * DllStructGetSize(DllStructCreate($ACL)) + DllStructGetSize(DllStructCreate($ACCESS_ALLOWED_ACE)) + 4

For $i = 0 To 1
	$sids[$i] = _Security__GetAccountSid($ap[$i][0])
	$acl_size += _Security__GetLengthSid(DllStructGetPtr($sids[$i]))
	If @error = -1 Then
		MsgBox(0,'Error','GetLengthSid Failed.')
		Exit
	EndIf
Next

Local $sdout = DllStructCreate($SECURITY_DESCRIPTOR)
$err = DllCall("AdvAPI32.dll","int","InitializeSecurityDescriptor","ptr",DllStructGetPtr($sdout),"dword",$SECURITY_DESCRIPTOR_REVISION)

Local $pacl = DllStructCreate($ACL)
$err = DllCall("AdvAPI32.dll","int","InitializeAcl","ptr",DllStructGetPtr($pacl),"dword",$acl_size,"dword",$ACL_REVISION)
If $err[0] = 0 Then
	MsgBox(0,'Error','InitializeAcl Failed.')
	Exit
EndIf

$err = DllCall("AdvAPI32.dll","int","IsValidAcl","ptr",DllStructGetPtr($pacl))
If $err[0] = 0 Then
	$err = DllCall('Kernel32.dll','dword','GetLastError')
	ConsoleWrite('IsValidAcl Failed with error ' & $err[0] & @CRLF)
	MsgBox(0,'Error','IsValidAcl Failed with error ' & $err[0])
	Exit
EndIf


For $i = 0 To 1
	Local $ace_p = DllStructCreate($ACE_HEADER)
	$name = $ap[$i][0]
	$amask = $ap[$i][1]
	$err = DllCall('AdvAPI32.dll',"int","AddAccessAllowedAce","ptr",DllStructGetPtr($pacl),"dword",$ACL_REVISION,"dword",$amask,"ptr",DllStructGetPtr($sids[$i]))
	If $err[0] = 0 Then
		$err = DllCall('Kernel32.dll','dword','GetLastError')
		ConsoleWrite('AddAccessAllowedAce Failed with error ' & $err[0] & @CRLF)
		MsgBox(0,'Error','AddAccessAllowedAce Failed with error ' & $err[0])
		Exit
	EndIf
	
	$err = DllCall('AdvAPI32.dll',"int","GetAce","ptr",DllStructGetPtr($pacl),"dword",0,"ptr",DllStructGetPtr($ace_p))
	If $err[0] = 0 Then
		$err = DllCall('Kernel32.dll','dword','GetLastError')
		ConsoleWrite('GetAce Failed with error ' & $err[0] & @CRLF)
		MsgBox(0,'Error','GetAce Failed with error ' & $err[0])
		Exit
	EndIf
	DllStructSetData($ace_p,"AceFlags",BitOR(DllStructGetData($ace_p,"AceFlags"),$CONTAINER_INHERIT_ACE,$OBJECT_INHERIT_ACE))
Next

$err = DllCall('AdvAPI32.dll',"int","SetSecurityDescriptorDacl","ptr",DllStructGetPtr($sdout),"int",1,"ptr",DllStructGetPtr($pacl),"int",0)
If $err[0] = 0 Then
	$err = DllCall('Kernel32.dll','dword','GetLastError')
	ConsoleWrite('SetSecurityDescriptorDacl Failed with error ' & $err[0] & @CRLF)
	MsgBox(0,'Error','SetSecurityDescriptorDacl Failed with error ' & $err[0])
	Exit
EndIf

$err = DllCall('AdvAPI32.dll',"int","IsValidSecurityDescriptor","ptr",DllStructGetPtr($sdout))
If $err[0] = 0 Then
	$err = DllCall('Kernel32.dll','dword','GetLastError')
	ConsoleWrite('IsValidSecurityDescriptor Failed with error ' & $err[0] & @CRLF)
	MsgBox(0,'Error','IsValidSecurityDescriptor Failed with error ' & $err[0])
	Exit
EndIf

$pacl = 0

$apath = "SOFTWARE\Microsoft"
Local $apath = StringSplit($apath,"\"), $npath = ''
For $i = 1 To $apath[0]
	$npath &= $apath

	Local $handle = DllStructCreate ("ptr")
	$err = DllCall("Advapi32.dll", "long", "RegOpenKeyEx", _
		"ptr", 0x80000002, _
		"str", $npath, _
		"dword", 0, _
		"long", $WRITE_DAC, _
		"ptr", DllStructGetPtr ($handle))
	If $err[0] <> 0 Then
		ConsoleWrite('RegOpenKeyEx Failed with error ' & $err[0] & @CRLF)
		MsgBox(0,'Error','RegOpenKeyEx Failed with error ' & $err[0])
		Exit
	EndIf
	ConsoleWrite("I am here" & @CRLF)
	$err = DllCall("Advapi32.dll","long","RegSetKeySecurity", _
			"ptr", DllStructGetData($handle,1), _
			"dword", $DACL_SECURITY_INFORMATION, _
			"ptr", DllStructGetPtr($sdout))
	If $err[0] <> 0 Then
		ConsoleWrite('RegSetKeySecurity Failed with error ' & $err[0] & @CRLF)
		MsgBox(0,'Error','RegSetKeySecurity Failed with error ' & $err[0])
		DllCall('AdvAPI32.dll','Long','RegCloseKey','ptr',DllStructGetData($handle,1))
		Exit
	EndIf
	ConsoleWrite("I am here" & @CRLF)

	DllCall('AdvAPI32.dll','Long','RegCloseKey','ptr',DllStructGetData($handle,1))
	
	$npath &= "\"
Next
