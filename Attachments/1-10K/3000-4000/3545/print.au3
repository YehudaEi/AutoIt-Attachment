#include-once



Global Const $ERROR_OUT_OF_MEMORY	= 0	;The operating system is out of memory or resources.
Global Const $ERROR_FILE_NOT_FOUND	= 2	;The specified file was not found. 
Global Const $ERROR_PATH_NOT_FOUND	= 3	;The specified path was not found. 
Global Const $ERROR_BAD_FORMAT		= 11	;The .exe file is invalid (non-Microsoft Win32® .exe or error in .exe image). 
Global Const $SE_ERR_FNF		= 2	;The specified file was not found. 
Global Const $SE_ERR_PNF		= 3	;The specified path was not found. 
Global Const $SE_ERR_ACCESSDENIED	= 5	;The operating system denied access to the specified file. 
Global Const $SE_ERR_OOM		= 8	;There was not enough memory to complete the operation. 
Global Const $SE_ERR_SHARE		= 26	;A sharing violation occurred. 
Global Const $SE_ERR_ASSOCINCOMPLETE	= 27	;The file name association is incomplete or invalid. 
Global Const $SE_ERR_DDETIMEOUT		= 28	;The DDE transaction could not be completed because the request timed out. 
Global Const $SE_ERR_DDEFAIL		= 29	;The DDE transaction failed. 
Global Const $SE_ERR_DDEBUSY		= 30	;The Dynamic Data Exchange (DDE) transaction could not be completed because other DDE transactions were being processed. 
Global Const $SE_ERR_NOASSOC		= 31	;There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable. 
Global Const $SE_ERR_DLLNOTFOUND	= 32	;The specified dynamic-link library (DLL) was not found.



;===============================================================================
;
; Function Name:   _FilePrint()
;
; Description:     Prints a file.
;
; Syntax:          _FilePrint ( $s_File [, $i_Show] )
;
; Parameter(s):    $s_File     = The file to print.
;                  $i_Show     = The state of the window. (default = @SW_HIDE)
;
; Requirement(s):  External:   = shell32.dll (it's already in system32).
;                  Internal:   = None.
;
; Return Value(s): On Success: = Returns 1.
;                  On Failure: = Returns 0 and sets @error according to the global constants list.
;
; Author(s):       erifash <erifash [at] gmail [dot] com>
;
; Note(s):         Uses the ShellExecute function of shell32.dll.
;
; Example(s):
;   _FilePrint("C:\file.txt")
;
;===============================================================================
Func _FilePrint($s_File, $i_Show = @SW_HIDE)
	Local $a_Ret = DllCall("shell32.dll", "long", "ShellExecute", _
		"hwnd", 0, _
		"string", "print", _
		"string", $s_File, _
		"string", "", _
		"string", "", _
		"int", $i_Show)
	If $a_Ret[0] > 32 and not @error Then
		Return 1
	Else
		SetError($a_Ret[0])
		Return 0
	EndIf
EndFunc   ;==>_FilePrint()