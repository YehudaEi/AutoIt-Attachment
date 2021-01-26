; *******************************************************
; Example 1 - Open a browser with the form example, fill in a form field and
;				reset the form back to default values
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
$oText = _IEFormElementGetObjByName ($oForm, "textExample")
_IEFormElementSetValue ($oText, "Hey! It works!")
_IEFormReset ($oForm)





; *******************************************************
; Example 1 - Open a browser with the basic example page, insert text
;		in and around the first Paragraph tag and display Body HTML
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
$oP = _IETagNameGetCollection($oIE, "p", 0)

_IEDocInsertText($oP, "(Text beforebegin)", "beforebegin")
_IEDocInsertText($oP, "(Text afterbegin)", "afterbegin")
_IEDocInsertText($oP, "(Text beforeend)", "beforeend")
_IEDocInsertText($oP, "(Text afterend)", "afterend")

ConsoleWrite(_IEBodyReadHTML($oIE) & @CR)







; *******************************************************
; Example 2 - Same as Example 1, except instead of using click, give the element focus
;				and then use ControlSend to send Enter.  Use this technique when the
;				browser-side scripting associated with a click action prevents control
;				from being automatically returned to your code.
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oSubmit = _IEGetObjByName ($oIE, "submitExample")
$hwnd = _IEPropertyGet($oIE, "hwnd")
_IEAction ($oSubmit, "focus")
ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{Enter}")

; Wait for Alert window, then click on OK
WinWait("Windows Internet Explorer", "ExampleFormSubmitted")
ControlClick("Windows Internet Explorer", "ExampleFormSubmitted", "[CLASS:Button; TEXT:OK; Instance:1;]")
_IELoadWait ($oIE)







; *******************************************************
; Example 1 - Open the AutoIt forum page, tab to the "View new posts"
;               link and activate the link with the enter key.
;               Then wait for the page load to complete before moving on.
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.autoitscript.com/forum/index.php")
Send("{TAB 12}")
Send("{ENTER}")
_IELoadWait ($oIE)
