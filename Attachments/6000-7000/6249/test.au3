opt("MustDeclareVars", 1)

msgbox(0,"Count:",_RegKeyCount("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"))

Func _RegKeyCount($s_key)
    Const $HKEY_CLASSES_ROOT = 0x80000000
    Const $HKEY_CURRENT_USER = 0x80000001
    Const $HKEY_LOCAL_MACHINE = 0x80000002
    Const $HKEY_USERS = 0x80000003
    Const $HKEY_CURRENT_CONFIG = 0x80000005
    
    Const $READ_CONTROL = 0x20000
    Const $STANDARD_RIGHTS_READ = ($READ_CONTROL)
    Const $KEY_QUERY_VALUE = 0x1
    Const $KEY_ENUMERATE_SUB_KEYS = 0x8
    Const $KEY_NOTIFY = 0x10
    Local $p, $a_key = StringSplit($s_key, "\"), $key, $subkey, $i

    Select
        Case StringUpper($a_key[1]) = "HKLM" Or StringUpper($a_key[1]) = "HKEY_LOCAL_MACHINE"
            $key = $HKEY_LOCAL_MACHINE
        Case StringUpper($a_key[1]) = "HKU" Or StringUpper($a_key[1]) = "HKEY_USERS"
            $key = $HKEY_USERS
        Case StringUpper($a_key[1]) = "HKCU" Or StringUpper($a_key[1]) = "HKEY_CURRENT_USER"
            $key = $HKEY_CURRENT_USER
        Case StringUpper($a_key[1]) = "HKCR" Or StringUpper($a_key[1]) = "HKEY_CLASSES_ROOT"
            $key = $HKEY_CLASSES_ROOT
        Case StringUpper($a_key[1]) = "HKCC" Or StringUpper($a_key[1]) = "HKEY_CURRENT_CONFIG"
            $key = $HKEY_CURRENT_CONFIG
    EndSelect

    For $i = 2 To $a_key[0]
        $subkey = $subkey & $a_key[$i] & "\"
    Next
    $subkey = StringTrimRight($subkey, 1)

    Local $str = DllStructCreate ("char[" & StringLen($subkey) + 1 & "]")
    DllStructSetData ($str, 1, $subkey)
    Local $handle = DllStructCreate ("int")
    DllCall("Advapi32.dll", "long", "RegOpenKeyEx", _
            "int", $key, _
            "ptr", DllStructGetPtr ($str), _
            "int", 0, _
            "long", BitOR($STANDARD_RIGHTS_READ, $KEY_QUERY_VALUE, $KEY_ENUMERATE_SUB_KEYS, $KEY_NOTIFY), _
            "ptr", DllStructGetPtr ($handle))
    If @error Then
        $str = 0
        $handle = 0
        SetError(1)
        Return 0
    EndIf
    Local $i_handle = DllStructGetData ($handle, 1)
    $str = 0
    $handle = 0
    DllCall("Advapi32.dll", "long", "RegCloseKey", "int", DllStructGetData ($handle, 1))
    
    $p = DllStructCreate ("dword")
    DllCall("Advapi32.dll", "long", "RegQueryInfoKey", "int", $i_handle,"ptr", 0,"ptr", 0,"ptr", 0,"ptr", DllStructGetPtr($p),"ptr", 0,"ptr", 0,"ptr", 0,"ptr", 0,"ptr", 0,"ptr", 0, "ptr", 0)
    If @error Then
        $p = 0
        SetError(2)
        Return 0
    EndIf
    Local $count = DllStructGetData ($p, 1)
    $p = 0
    Return $count
EndFunc  ;==>_RegKeyCount