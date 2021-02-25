$oIE = _IECreate ("http://www.google.com",0,1,1,1)
Sleep(2000)
$oForm = _IEFormGetObjByName ($oIE, "f")
$oQuery = _IEFormElementGetObjByName ($oForm, "q")
_IEFormElementSetValue ($oQuery, "peugeot")
Sleep(2000)
Send ("{Enter}")
$sMyString = "Peugeot - Pricing & Specification"
$oLinks = _IELinkGetCollection($oIE)
For $oLink in $oLinks
    $sLinkText = _IEPropertyGet($oLink, "innerText")
    If StringInStr($sLinkText, $sMyString) Then
        _IEAction($oLink, "click")
        ExitLoop
    EndIf
Next