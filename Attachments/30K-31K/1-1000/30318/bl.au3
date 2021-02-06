#include <IE.au3>

$sUsername = "oDon"
$sPassword = "uh0uxt9t"
$sUrl = "http://www.bootleggers.us/"
$oIE = _IECreate ($sUrl)
$oForm = _IEFormGetCollection ($oIE, 2)
$oUsername = _IEFormElementGetObjByName ($oForm, "Username")
$oPassword = _IEFormElementGetObjByName ($oForm, "Password")
_IEFormElementSetValue ($oUsername, $sUsername)
_IEFormElementSetValue ($oPassword, $sPassword)
_IEFormSubmit ($oForm)
_IELinkClickByText ($oIE, "crimes")
$oForm = _IEFormGetCollection ($oIE, 0)
_IEFormElementRadioSelect  ($oForm, "3", "radiocrime3", 1, "byValue")