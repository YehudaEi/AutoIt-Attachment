;============================================================:

; Function Name:   _RegExt()
; Description:     Registers a file extension.
; Parameter(s):    $s_FileExt - File Extension
; Requirement(s):  None
; Return Value(s): On Success - Registers the extension
;                  On Failure - None
; Author(s):       Louie Raymond Coassin Jr.

;============================================================:

#Include-Once

Func _RegExt (ByRef $s_FileExt)
   Local $v_ExtInUse

   Opt ("WinWaitDelay", 0)
   
   Run ("explorer.exe", "", @SW_HIDE)
      Sleep (500)
      Send ("!to")

   WinSetState ("Folder Options", "", @SW_HIDE)
      Send ("+{TAB}{RIGHT}{RIGHT}")
      Sleep (1000)
      Send ("!n")

   WinSetState ("Create New Extension", "", @SW_HIDE)
      Send ($s_FileExt)
      Send ("{ENTER}")
      $v_ExtInUse = WinExists ("Extension is in use")
      If $v_ExtInUse = 1 Then
	Exit(0)
      EndIf
      Sleep (1000)
      Send ("!v")

   WinSetState ("Edit File Type", "", @SW_HIDE)
      Send ("!i")

   WinSetState ("Change Icon", "", @SW_HIDE)
      Send ("{TAB}{TAB}{DOWN}{DOWN}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{ENTER}!n")

   WinSetState ("New Action", "", @SW_HIDE)
      Send ("open{TAB}notepad.exe{ENTER}{ENTER}!{F4}!{F4}")
EndFunc

;============================================================: