; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; Set up our defaults
; ----------------------------------------------------------------------------


AutoItSetOption("WinTitleMatchMode", 4)


; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

Dim $title

;Make the Notes Window active
$title = "[CLASS:NOTES]"
WinActivate ($title, "")
WinSetState($title, "", @SW_MAXIMIZE)

;If Notes is not open stop execution
If NOT WinActive($title) Then
	Exit
EndIF

;Launch the Open Database Dialog
Send("{ALT}")
Send("{F}")
Send("{D}")
Send("{O}")

;Opens the User Registration database
Send("PAWCHHUBS01/VWRI")
Send("{TAB 2}")
Send("Administration\userregprd.nsf")
Send("{TAB 1}")
Send("{ENTER}")

AutoItSetOption("WinTitleMatchMode", 2)

;Run the User Registration Process
$title = "Notes Account Registration"
WinWaitActive ( $title, "", 5)
If WinActive($title) Then
	Send("{ALT}")
	Send("{A}")
	Send("{P}")
EndIf