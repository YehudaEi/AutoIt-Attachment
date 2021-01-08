; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         I.K. User
;
; Script Function:
;	Inselkampf Scorekeeper script, Text conversion.
;
; -----------------------------------------------------------------------------

; To be able to use IE commands
#include <IE.au3>
#include <file.au3>
#include <Array.au3>

; Set Variables
$pos1 = 1
$pos2 = 1

; Create a browser window and navigate to Inselkampf.co.uk
$o_IE = _IECreate ()
_IENavigate ($o_IE, "                                       ")

; Enter username & password then login and wait for the next page to load
$o_form = _IEFormGetObjByIndex($o_IE, 0)
$o_user = _IEFormElementGetObjByName($o_form, "member")
$o_password = _IEFormElementGetObjByName($o_form, "pwd")
_IEFormElementSetValue($o_user, "Foreplay")
_IEFormElementSetValue($o_password, "521j03")
_IEFormSubmit($o_form)
_IELoadWait($o_IE)

; Go to Ocean Square 1
_IEClickLinkByText ($o_IE, "Go To Your Isle »")
_IEClickLinkByText ($o_IE, "Map")
$o_form = _IEFormGetObjByIndex($o_IE, 0)
$ocean = _IEFormElementGetObjByName($o_form, "pos1")
$o_square = _IEFormElementGetObjByName($o_form, "pos2")
_IEFormElementSetValue($ocean, $pos1)
_IEFormElementSetValue($o_square, $pos2)
_IEFormSubmit($o_form)
_IELoadWait($o_IE)
$body = _IEBodyReadHTML($o_IE)

; Create log file
;~ $NewFileDir = "C:\Documents and Settings\Owner\My Documents\IK Tool Script\"
;~ $date = *******
_FileCreate ("C:\Documents and Settings\Owner\My Documents\IK Tool Script\IK_file.txt")
$file = FileOpen("IK_file.txt", 1)
FileWrite($file, $body)

; Go to Ocean Square 2
$pos2 = 2

_IEClickLinkByText ($o_IE, "Map")
$o_form = _IEFormGetObjByIndex($o_IE, 0)
$ocean = _IEFormElementGetObjByName($o_form, "pos1")
$o_square = _IEFormElementGetObjByName($o_form, "pos2")
_IEFormElementSetValue($ocean, $pos1)
_IEFormElementSetValue($o_square, $pos2)
_IEFormSubmit($o_form)
_IELoadWait($o_IE)
$body = _IEBodyReadHTML($o_IE)

; Create log file
;~ $NewFileDir = "C:\Documents and Settings\Owner\My Documents\IK Tool Script\"
;~ $date = *******
$file = FileOpen("IK_file.txt", 1)
FileWrite($file, $body)

$ret = StringRegExp($body, 'Isle: (.*?)\r\nPosition: (.*?):(.*?):(.*?)\r\nRuler: (.*?)\r\nAlliance: (.*?)\r\nScore: (.*?)\r\nColony: (.*?)"', 3) 
MsgBox(0, test, $ret)