#include-once
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3> ; $EM_SCROLLCARET

; #INDEX# =======================================================================================================================
; Title .........: RunCMD
; AutoIt Version : v3.3.8.1
; Language ......: English
; Description ...: Functions that assist with Running DOS commands
; Author(s) .....: jasc2v8, credits to jefhal, nfwu, guiness
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
; no global variables
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; no global constants
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _RunCMD
; _RunWaitCMD
; _RunCMD_Window
; _RunWaitCMD_Window
; _RunCMD_GUI
; _WinPath
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........:	_RunCMD
; Description ...:	Runs a DOS command or external program with no window
; Syntax.........:	_RunCMD( $sCmd )
; Parameters ....:	$sCmd - The DOS command or external program to run
; Return values .:	The same as the Run Function:
;					Success: The PID of the process that was launched.
;					Failure: Returns 0 and sets @error to non-zero.
; Author ........:	jasc2v8 [at] yahoo [dot] com, credit to jefhal from Autoit Snippets
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
; ===============================================================================================================================
Func _RunCMD($cmd)
	Local $iPID = Run(@ComSpec & " /c " & $cmd, "", @SW_HIDE)
	Return SetError(@error, @extended, $iPID)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........:	_RunWaitCMD
; Description ...:	Runs a DOS command or external program with no window, pause script until complete
; Syntax.........:	_RunCMD( $sCmd )
; Parameters ....:	$sCmd - The DOS command or external program to run
; Return values .:	The same as the Run Function:
;					Success: The PID of the process that was launched.
;					Failure: Returns 0 and sets @error to non-zero.
; Author ........:	jasc2v8 [at] yahoo [dot] com, credit to jefhal from Autoit Snippets
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
; ===============================================================================================================================
Func _RunWaitCMD($cmd)
	Local $iPID = RunWait(@ComSpec & " /c " & $cmd, "", @SW_HIDE)
	Return SetError(@error, @extended, $iPID)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........:	_RunCMD_Window
; Description ...:	Runs a DOS command or external program in a DOS command window
; Syntax.........:	_RunCMD_Window( $sCmd, $sTitle )
; Parameters ....:	$sCmd - The DOS command or external program to run
;					$sTitle - The text to display in the window title
; Return values .:	The same as the Run Function:
;					Success: The PID of the process that was launched.
;					Failure: Returns 0 and sets @error to non-zero.
; Author ........:	jasc2v8 [at] yahoo [dot] com, credit to nfwu from Autoit Snippets
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
; ===============================================================================================================================
Func _RunCMD_Window($cmd, $title="")
	Local $iPID = Run(@ComSpec & " /K title " & $title & " | " & $cmd, "", @SW_SHOW)
	Return SetError(@error, @extended, $iPID)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........:	_RunWaitCMD_Window
; Description ...:	Runs a DOS command or external program in a DOS command window, pause script until complete
; Syntax.........:	_RunCMD_Window( $sCmd, $sTitle )
; Parameters ....:	$sCmd - The DOS command or external program to run
;					$sTitle - The text to display in the window title
; Return values .:	The same as the Run Function:
;					Success: The PID of the process that was launched.
;					Failure: Returns 0 and sets @error to non-zero.
; Author ........:	jasc2v8 [at] yahoo [dot] com, credit to nfwu from Autoit Snippets
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
; ===============================================================================================================================
Func _RunWaitCMD_Window($cmd, $title="")
	Local $iPID = RunWait(@ComSpec & " /K title " & $title & " | " & $cmd, "", @SW_SHOW)
	Return SetError(@error, @extended, $iPID)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........:	_RunCMD_GUI
; Description ...:	Runs a DOS command or external program in a GUI window
;					STDIN + STDERR + STDOUT is displayed in an Edit control in the GUI window
;					The Copy button copies all text to the Clipboard
;					The Close button closes the GUI window
;					Optional title of the window, default is "CMD STDIN + STDERR + STDOUT"
;					Optional text at top of edit ctrl, default is "CMD: " & $cmd
;					Optional left and top coordinates of the window, default is center
;					Optional background color of the window, default is light yellow
; Syntax.........:	_RunCMD_Window( $sCmd [, $sTitle, $sText, $iLeft, $iTop, $iBkColor] )
; Parameters ....:	$sCmd - The DOS command or external program to run
; Return values .:	The same as the Run Function:
;					Success: The PID of the process that was launched.
;					Failure: Returns 0 and sets @error to non-zero.
; Author ........:	jasc2v8 [at] yahoo [dot] com, credit to guiness from Autoit Snippets
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
; ===============================================================================================================================
Func _RunCMD_GUI($cmd, $title="", $text="", $left=-1, $top=-1, $bkcolor="")

	;check defaults
	If $title = "" 		Then $title = "CMD STDIN + STDERR + STDOUT"
	If $text = "" 		Then $text  = "CMD: " & $cmd
	If $left = ""		Then $left = -1	;Default center
	If $top = ""		Then $top = -1	;Default center
	If $bkcolor = "" 	Then $bkcolor = "0xFFFFD6" ; light yellow
;	If $bkcolor = "" 	Then $bkcolor = "0xc0c0c0" ; dark grey
;	If $bkcolor = "" 	Then $bkcolor = "0xf8f8f8" ; light grey - used in Autoit forum code blocks
;	If $bkcolor = "" 	Then $bkcolor = "0xe1ffe1" ; light green

	;init variables
	Local $buffer, $line
	Local $iPID
	Local $iSavedError, $iSavedExtended

	Local $iGuiW = 640	;gui width
	Local $iGuiH = 480	;gui heigth
	Local $iGuiM = 10 	;gui margin

	Local $iBtnW = 60 	;button width
	Local $iBtnH = 30 	;button height
	Local $iBtnM = 5 	;button margin

	;create the gui, edit, buttons
	$hGui = GUICreate($title, $iGuiW, $iGuiH, $left, $top)

	$hEdit = GUICtrlCreateEdit($text & @CRLF, $iGuiM, $iGuiM, $iGuiW - ($iGuiM * 2), $iGuiH - $iBtnH - $iBtnH)
	GUICtrlSetBkColor(-1, $bkcolor) ; light yellow
	GUICtrlSetFont(-1, -1, -1, -1, "Lucida Console")
	;do not disable so the user can copy text GUICtrlSetState($hEdit, $GUI_DISABLE)

	$btnClose = GUICtrlCreateButton("Close", $iGuiW - ($iBtnW * 1) - ($iGuiM * 1), $iGuiH - $iBtnH - ($iBtnM*2), $iBtnW, $iBtnH)
	GUICtrlSetTip(-1, "Close this Window")
	GUICtrlSetState(-1, $GUI_FOCUS)

	$btnCopy = GUICtrlCreateButton("Copy", $iGuiW - ($iBtnW * 2) - ($iGuiM * 2), $iGuiH - $iBtnH - ($iBtnM*2), $iBtnW, $iBtnH)
	GUICtrlSetTip(-1, "Copy all text to Clipboard")

	;show the gui
	GUISetState(@SW_SHOW)

	;run the cmd
	$iPID = Run(@ComSpec & " /c " & $cmd, @ScriptDir, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)

	;save error info
	$iSavedError = @error
	$iSavedExtended = @extended

	;disable buttons while executing cmd
	GUICtrlSetState($btnCopy,  $GUI_DISABLE)
	GUICtrlSetState($btnClose, $GUI_DISABLE)

	;read stdin + stderr + stdout while executing
	$buffer = GUICtrlRead($hEdit) ;keep the 1st line of text from GUICtrlCreateEdit
	$line = ""
	While True
		$line = StdoutRead($iPID, False, False)
		If @error Then ExitLoop
		If $line <> "" Then
			$buffer = $buffer & $line
			GUICtrlSetData($hEdit, $buffer)
		EndIf
		Sleep(10)
	WEnd

	;scroll to bottom edit
	GUICtrlSendMsg($hEdit, $EM_SCROLLCARET, 0, 0)

	;enable buttons
	GUICtrlSetState($btnCopy,  $GUI_ENABLE)
	GUICtrlSetState($btnClose, $GUI_ENABLE)

	;gui button handler
	While True
		Local $msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($hGui)
				Return SetError($iSavedError, $iSavedExtended, $iPID)
			Case $btnClose
				GUIDelete($hGui)
				Return SetError($iSavedError, $iSavedExtended, $iPID)
			Case $btnCopy
				ClipPut($buffer)
		EndSwitch
	WEnd

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........:	_WinPath
; Description ...:	Add quotes when there are spaces in a Windows path
; Syntax.........:	_WinPath( $sPath )
; Parameters ....:	$sPath - The Windows path
; Return values .:	If there are spaces in the path then quotes are added
;					If no spaces in the path then the path is return without adding quotes
;					Return Values are the same as the StingInStr Function;
;					Success: Returns the path
;					Failure: Returns 0 if substring not found
;					@Error 0 - Normal operation
; Author ........:	jasc2v8 [at] yahoo [dot] com
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	Yes
; ===============================================================================================================================
Func _WinPath($path)
	If StringInStr($path, ' ') = 0 Then
		Return $path
	Else
		Return '"' & $path & '"'
	EndIf
EndFunc
