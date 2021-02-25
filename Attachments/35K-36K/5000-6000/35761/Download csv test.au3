;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Mark W. Greenberger
;
; Script Function:
;   Automates the Florida SHOTS daily submission from Doc-tor.com
;
; Create a browser window and navigate to hotmail
;

#include <IE.au3> 

_IEErrorHandlerRegister()

$oIE = _IECreate ("https://websrv01.physician-to-go.net/proxy.cgi/off/home/login.htm", 1, 1, 1)

;WinWaitActive("Office Channel Login")

; get pointers to the login form and username, password and signin fields
$o_form     = _IEFormGetObjByName ($oIE, "form1")
$o_login    = _IEFormElementGetObjByName ($o_form, "login")
$o_password = _IEFormElementGetObjByName ($o_form, "password")
$o_signin   = _IEFormElementGetObjByName ($o_form, "submit")

$username   = "testmauto"
$password   = "doctor"

; Set field values and submit the form
_IEFormElementSetValue ($o_login, $username)
_IEFormElementSetValue ($o_password, $password)
_IEAction ($o_signin, "click")

WinWaitActive("Doctor")

_IENavigate ($oIE, "https://websrv01.physician-to-go.net/proxy.cgi/off/home/todo_b.htm")

WinWaitActive("Reminders")
Sleep (5000)

; Click on the Sent column header
Send ("{TAB 6}")
Send ("{ENTER}")

WinWaitActive("Reminders")
Sleep (5000)

; Click on the Sent column header to make sure that the latest copy is on top
Send ("{TAB 6}")
Send ("{ENTER}")

WinWaitActive("Reminders")
Sleep (5000)

;_IELinkClickByText ($oIE, "SMA Bill", 1)


Send ("{TAB 10}")
Send ("{ENTER}")

; get pointers to the date fields
;$o_form     = _IEFormGetObjByName ($oIE, "todo_b")
;$o_submit   = _IEFormElementGetObjByName ($o_form, "Transactions")

; Set field values and submit the form
;_IEFormElementSetValue ($o_datefrom, $datefm)
;_IEFormElementSetValue ($o_dateto,   $dateto)
;_IEFormElementSetValue ($o_update,   $update)

WinWaitActive("View Reminder")
Sleep (5000)

Send ("{TAB 8}")
Send ("{ENTER}")

;WinWaitActive("Transactions")
;Sleep (5000)

;Send ("+{TAB 2}")
;Send ("{ENTER}")

WinWaitActive("File")
Sleep (5000)

ControlClick("File Download","","Button2") ; this clicks the default "save" button on the first dialog
;Send ("+{TAB 1}")
;Send ("{ENTER}")

WinWaitActive("Save")
Sleep (5000)

$FLmon = @mon
$FLday = @mday
$FLhou = @hour
$FLmin = @min
;

Send ("C:\Bill_file\SMA_bill_file_")
Send (@mon)
Send (@mday)
Send ("_")
Send (@hour)
Send (@min)
Send (".csv")
Send ("!s")

; Now quit by pressing Alt-f and then c (File menu -> Close)
;WinWaitActive("Navigator")
Sleep (5000)

_IEQuit ($oIE)

Send("!f")
Send("c")

; Finished!



;$FLmon = @mon
;$FLday = @mday
;
;If @wday  = 2 THEN
;   $FLday = $FLday - 3
;ELSE
;   $FLday = $FLday - 1
;Endif
;
;$FLdayC  = string($FLday)
;$FLmonC  = string($FLmon)
;$FLyearC = string(@year)
;
;If $FLday = 0 THEN
;   $FLmon = $FLmon - 1
;   If $FLmon = 2 or $FLmon = 4 or $FLmon = 6 or $FLmon = 9 or $FLmon = 11 THEN
;      $FLdayC = "30"
;   ELSE
;      $FLdayC = "31"
;   Endif
;Endif
;
;If $FLday = -1 THEN
;   $FLmon = $FLmon - 1
;   If $FLmon = 2 or $FLmon = 4 or $FLmon = 6 or $FLmon = 9 or $FLmon = 11 THEN
;      $FLdayC = "29"
;   ELSE
;      $FLdayC = "30"
;   Endif
;Endif
;
;If $FLday = -2 THEN
;   $FLmon = $FLmon - 1
;   If $FLmon = 2 or $FLmon = 4 or $FLmon = 6 or $FLmon = 9 or $FLmon = 11 THEN
;      $FLdayC = "28"
;   ELSE
;      $FLdayC = "29"
;   Endif
;Endif
;
;$FLmonC  = string($FLmon)
;
; get pointers to the date fields
;$o_form     = _IEFormGetObjByName ($oIE, "flshots")
;$o_datefrom = _IEFormElementGetObjByName ($o_form, "Immunization")
;$o_dateto   = _IEFormElementGetObjByName ($o_form, "To")
;$o_update   = _IEFormElementGetObjByName ($o_form, "UPDATE")
;$o_submit   = _IEFormElementGetObjByName ($o_form, "submit")

;$datefm = $FlmonC & "/" & $FLdayC & "/" & $FLyearC 
;$dateto = $FlmonC & "/" & $FLdayC & "/" & $FLyearC 
;$update = " "

; Set field values and submit the form
;_IEFormElementSetValue ($o_datefrom, $datefm)
;_IEFormElementSetValue ($o_dateto,   $dateto)
;_IEFormElementSetValue ($o_update,   $update)

;Send ("+{TAB 5}")

; This sequence sends the dates and Update = Y
;Send ($datefm)
;Send ("{TAB}")
;Send ($dateto)
;Send ("{TAB}")
;Send (" ")
;Send ("{ENTER}")
;Send ("{TAB}")
;
;Send ("{ENTER}")

;WinWaitActive("Navigator")
;Sleep (5000)
;
;Send ("+{TAB 2}")
;Send ("{ENTER}")
;
;WinWaitActive("https")
;
;Sleep (5000)
;Send ("!s")
;
;WinWaitActive("Save")
;Send ("C:\FL_SHOTS\FLSHOTS_Upload_")
;Send (@mon)
;Send (@mday)
;Send ("!s")

; Now quit by pressing Alt-f and then c (File menu -> Close)
;WinWaitActive("Navigator")
;Sleep (5000)

;_IEQuit ($oIE)
;
;Send("!f")
;Send("c")

; Finished!

;WinWaitClose("citywide")

;WinWaitActive("Navigator")
;Sleep (5000)

;Sleep (1000)

;WinWaitActive("Microsoft Internet Explorer")
;Send (" ")

;ControlSetText ("", "", "Button", " ")

;ControlSend ("Microsoft Internet Explorer", "", "[CLASS:Button]", " ")
;ControlClick ("Microsoft Internet Explorer", "", "[CLASS:Button]")
;ControlClick ("Microsoft Internet Explorer", "", 1)

; Send ("{ENTER}")
;_IEAction ($o_submit, "click")


;WinWaitActive("Navigator")

; get pointers to the Report HS field

;$o_frame    = _IEFrameGetObjByName($oIE, "ReportBody")
;$o_prntHS   = _IEFrameGetObjByName($o_frame, "RetrieveReport_gz")

; get pointers to the Report HS field
;$o_form     = _IEFormGetObjByName ($oIE, "Navigator")
;$o_prntHS   = _IEFormElementGetObjByName ($o_form, "RetrieveReport_gz")

;_IEAction ($o_prntHS, "click")


;Sleep (50000)

; Run Florida SHOTS 

;#include <IE.au3> 
;_IECreate ("https://websrv01.physician-to-go.net/proxy.cgi/off/home/login.htm", 1, 1, 0)

;WinWaitActive("Office Channel Login")

;Send ("{TAB 13}")
;Send("+{TAB 4}")
;Send ("mandmprov")
;Send ("{TAB}")
;Send ("doctor")
;Send ("{ENTER}")
;WinWaitActive("Practice List")
;Send ("{TAB 6}")
;Send ("{ENTER}")
;WinWaitActive("Doc-tor.com")
;Send ("{TAB}")
;Send ("https://websrv01.physician-to-go.net/proxy.cgi/off/forms/flshots.htm")
;Send ("{ENTER}")
;
;WinWaitActive("citywide")
;
;Send ("+{TAB 5}")
;
;   Send ($Flmon)
;   Send ("/")
;   Send ($FLday)
;   Send ("/")
;   Send (@year)
;   Send ("{TAB}")
;   Send ($FLmon)
;   Send ("/")
;   Send ($FLday)
;   Send ("/")
;   Send (@year)
;Send ("{TAB}")

; This sequence sends it as Update = Y
;Send (" ")
;Send ("{ENTER}")
;Send ("{TAB}")

;Send ("{ENTER}")

;WinWaitActive("Navigator")
;Sleep (5000)

;Send ("+{TAB 2}")
;Send ("{ENTER}")

;WinWaitActive("https")
;WinWaitNotActive("https")
;Sleep (5000)
;Send ("!s")

;WinWaitActive("Save")
;Send ("C:\FL_SHOTS\FLSHOTS_Upload_")
;Send (@mon)
;Send (@mday)
;Send ("!s")

; Now quit by pressing Alt-f and then c (File menu -> Close)
;WinWaitActive("Navigator")
;Sleep (5000)

;Send("!f")
;Send("c")

; Finished!

;WinWaitClose("citywide")

; Now quit by pressing Alt-f and then x (File menu -> Exit)
;Send("!f")
;Send("x")

