#include <IE.au3>

$oIE = _IECreate("www.gmail.com", 0, 1, 0)
_IELoadWait ($oIE)
Sleep(5000);
$oForm = _IEFormGetObjByName($oIE, "gaia_loginform")
$oUser = _IEFormElementGetObjByName($oForm, "Email")
$oPasswd = _IEFormElementGetObjByName($oForm, "Passwd")

$user = "username"
$passwd = "password"

_IEFormElementSetValue($oUser, $user)
_IEFormElementSetValue($oPasswd, $passwd)
