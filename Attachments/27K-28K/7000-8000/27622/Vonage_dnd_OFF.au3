#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author: Creeker  8/15/2009

 Script Function:
	to disable Vonage Do Not Disturb

#ce ----------------------------------------------------------------------------
#include <IE.au3>
;Go to the page
$0IE =_IECreate ("www.vonage.com/?login", 1, 1, 1,1)
WinSetState("Vonage - VoIP Internet Phone Service for Home","",@SW_MAXIMIZE)
Sleep(500)

$o_form = _IEFormGetObjByName ($0IE, "logonForm")
$o_login = _IEFormElementGetObjByName ($o_form, "username")
$o_password = _IEFormElementGetObjByName ($o_form, "password")
$o_feature = _IEFormElementGetObjByName ($o_form, "goToSelection")

;Confidential data
$username = "YourUsername"
$password = "YourPassword"
$feature = "features"

; Set field values and submit the form
_IEFormElementSetValue ($o_login, $username)
_IEFormElementSetValue ($o_password, $password)
_IEFormElementSetValue ($o_feature, $feature)

;This will sign in to your Vonage account.
 ;Beacause there was not a name for this button I tried several different ways to hit this button, this one worked may also be able to use the 'alt'
_IEFormImageClick($0IE, "http://www.vonage.com/images/homepage/btn_signin.gif", "src")

;Find the correct featurewhich is the Do Not Disturb function and click on the "Configure" button
_IELoadWait ($0IE)
sleep(5000)
$0IE = _IEAttach ("911 Dialing is NOT automatic" , "text")
$o_dnd = _IEGetObjByName($0IE, "dndButton")
_IEAction ($o_dnd, "click")


;select the "On" radio button and thwe the "Submit" button
_IELoadWait ($0IE)
$0IE = _IEAttach ("Do not Disturb" , "text")

;Thanks to Iceburg, this will select the "on" button and submit the changes.
$oDoc = _IEDocGetObj($0IE)
        $oArray = $oDoc.getElementsByTagName ("input")
        for $element in $oArray
            if $element.value="false" Then $element.checked=true
		next

        for $element in $oArray
            If $element.Value = "Submit"  Then _IEAction($element, "click")
		next


_IELoadWait ($0IE)
Sleep(2000);Just to make sure the settings are saved.
_IEQuit($0IE)
