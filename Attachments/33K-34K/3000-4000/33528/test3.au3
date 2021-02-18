#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <IE.au3>

Local $oUser, $oPass, $oSubmit
Local $sUser = "test"
Local $sPass = "test"
Local $url = "https://connect.williams-int.com/customers/login.asp"
Local $oIE = _IECreate($url, 1)

_IELoadWait($oIE)

$oInputs = _IETagNameGetCollection($oIE, "input")
for $oInput in $oInputs
    if $oInput.type = "text" And $oInput.name = "userid" And $oInput.size = "16" Then $oUser = $oInput
    if $oInput.type = "password" And $oInput.name = "password" And $oInput.size = "16" Then $oPass = $oInput
    if $oInput.type = "submit" And $oInput.value="   SIGN IN   " Then $oSubmit = $oInput
    if isObj($oUser) And isObj($oPass) And isObj($oSubmit) then exitloop
Next

$oUser.value = $sUser
$oPass.value = $sPass
_IEAction($oSubmit, "click")

_IELoadWait($oIE)
