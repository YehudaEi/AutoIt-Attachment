; autoit debug dialog utility, jw 03Sept05
;   This utility is intended to provide the equivalent of vb's 
;   "immediate window".  You may post messages to it as the script 
;   is running, to record milestones and intermediate variables...
; --- end of heading -----------------------------
AutoItSetOption("MustDeclareVars", 1)  ; 1 => Option Explicit
AutoItSetOption("GUIOnEventMode", 1)  ; 1 => use onEvent mode
;
#include <Constants.au3>
#include <GuiConstants.au3>
#include <date.au3>
;
Const $dbDlgCaption = " < test/demo validate date+time string using vb's RegExp object > "  
Dim $ListBox, $CancelButton  ; as (control) object(s)
; (one would have expected these to have been pre-defined constants)
Const $FW_NORMAL = 400, $FW_BOLD = 600  
Const $vbTrue = -1, $vbFalse = 0
Const $vbCrLf = @CRLF  
Const $WM_VSCROLL = 0x115, $SB_BOTTOM = 7  ; scroll down api constants...
;
Dim $bCloseFlag  ; as boolean
Dim $m_hWnd  ; as long
Dim $bTestResult  ; as boolean
; --- end of declarations and constants ----------
Const $sMe = "[dbDlg:main], "

  Call_CreateDialog($dbDlgCaption)  ; create the dialog, and show it...
    dbPrint($sMe & "dlg opened, hWnd is: " & String($m_hWnd))  ; String = CStr

  ; run the test
  $bTestResult = Validate_DateTimeLocalFormat("09/16/05 05:06:07 AM")  
    dbPrint($sMe & "DateTimeValidation returned: " & CnvBool2String($bTestResult))
	dbPrint($sMe)
	dbPrint($sMe & "  .. review the results, and closee this window when finished.")

  $bCloseFlag = $vbFalse

  Do  ; wait loop (review the results then close the dialog)...
    Sleep(30)  ; allow for processing events (in milliseconds)

  Until $bCloseFlag = $vbTrue

dbPrint(" ")  ; space
dbPrint($sMe & "dbDlg closing now.. ")
Sleep(1000)  ; in milliseconds
GuiSetState(@SW_HIDE)  ; hide the dialog

Exit  ; not needed(?), but re-assuring...



; ------------------------------------------------
; --- SUBROUTINES FOLLOW -------------------------
; ------------------------------------------------

Func Validate_DateTimeLocalFormat($sDateTime)
Const $fName = "[isDTValid], "
Local $oRegExp  ; as object
Local $Match  ; as match item
Local $Matches  ; as collection...
Local $bResult = $vbFalse  ; as boolean (assume doesn't match)...
;
Local $FirstIndex  ; as integer
Local $sValue  ; as string
; --- end of constants and declarations ----------

  dbPrint($fName & "entered.. ")

  ; instantiate the (vbScript) regular expression object
  $oRegExp = ObjCreate("VBScript.RegExp")  

  With $oRegExp  ; set parameters
    .Pattern = "^[01]\d/[0-3]\d/\d\d [01]\d:[0-5]\d:[0-5]\d [AP]M$"  ; set pattern
    .IgnoreCase = $vbTrue  ; make case insensitive
    .Global = $vbFalse  ; after the first match, don't bother looking further 
  
    $Matches = .Execute($sDateTime)  ; execute the test
  EndWith

  dbPrint($fName & "$Matches.Count is: " & String($Matches.Count))

  If ($Matches.Count = 1) Then  ; =1 is the desired result...
  ; N.B., as there is only ONE item in the collection, no need to use 
  ;   enumeration, just go get the item directly.  But remember, "index must 
  ;   be a number from 1 to the value of the collection's Count property, 
  ;   i.e., contrary to common practice, this is NOT a zero-based array...
  ;
  ; uh-oh.  You may be able to pick an individual element out of a collection
  ;   with vbs, but I can't seem to find the magic way to do it with autoit.
  ; $FirstIndex = $Matches(1).FirstIndex
  ; $sValue =     $Matches(1).Value
  ; $FirstIndex = $Matches.Item(1).FirstIndex
  ; $sValue =     $Matches.Item(1).Value
  ; all of the above don't work.  (Note: tried "square brackets" too)...
  ; --- end of futile attempt --------------------

    ; going back to what DOES work (i.e., enumeration)...
    For $Match In $Matches   ; (for each) loop through the $Matches collection.
      $FirstIndex = $Match.FirstIndex  ; since only one match,
      $sValue =     $Match.Value       ; this is the one...
    Next  

    dbPrint($fName & "Results.. ")
    dbPrint($fName & "  Match found at position: " & String($FirstIndex))
    dbPrint($fName & "  The Matched Value is: " & $sValue)
    
	Return($vbTrue)  ; return true (indicates a match)...
  
  Else  ; doesn't match
    Return($vbFalse)  ; return false, (indicating match failed)...

  EndIf

EndFunc


; --- CONVERT BOOLEAN VALUE TO STRING ------------

Func CnvBool2String($bValue)
  If ($bValue = $vbTrue) then
    Return("True")
  Else
    Return("False")
  EndIf

EndFunc


; --- post debugging message ---------------------

Func dbPrint($sMsg)

  ; post a debugging message...
  GUICtrlSetData($ListBox, $sMsg)  ; post dbmsg
  GUICtrlSendMsg($ListBox, $WM_VSCROLL, $SB_BOTTOM, 0)  ; scroll listbox to bottom
EndFunc

; --- EVENT HANDLERS -----------------------------

Func frmMain_CloseClick()
  ; MsgBox(0, "autoIt Debug Dialog", "Close Pressed" & $vbCrLf & $vbCrLf _
  ;     & "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE, 2)  ; display 2sec
  $bCloseFlag = $vbTrue
  ; Exit
EndFunc

Func btnCancel_Click()
Dim $sTime  ; as string

  ; MsgBox(0, "autoIt Debug Dialog", "btnCancel_Click detected")
  $sTime = _DateTimeFormat( _NowCalc(), 3)  ; works for nt&xp, but not win9x...
  GUICtrlSetData($ListBox, "[dbDlg:btnClick], event detected at: " & $sTime)  ; post msg
  $bCloseFlag = $vbTrue
EndFunc



; --- CREATE DIALOG ------------------------------

Func Call_CreateDialog($sCaption)
Const $wdDlg = 500, $htDlg = 265  
Const $wdBtn = 100, $htBtn = 25
Dim $CorpLogo  ; as (control) object
Dim $sLogo = "brought to you by jawar productions (all rights reserved)... "
Dim $btnMargin  ; as long
; these styles get you a titlebar with icon, caption, and [X] button,  
;   but no min/max buttons...
Const $WS_DIALOG = 0x94C800C4  
Const $WS_EX_DIALOG = 0x00050101


  ; create the window...
  $m_hWnd = GuiCreate($sCaption, $wdDlg,$htDlg, 100,100, _
      $WS_DIALOG, $WS_EX_DIALOG) 
  GuiSetIcon(@ScriptDir & "\icons\mru.ico")  ; change default icon
  GUISetOnEvent($GUI_EVENT_CLOSE, "frmMain_CloseClick")
  GUISetFont(8, $FW_BOLD, 0, "MS Sans Serif")  ; applys to controls too...

  ; label for the listbox, as label (a.k.a., static) control...
  GuiCtrlCreateLabel("debugging messages:", 24,5)
  
  ; listbox (for debugging messages)...
  $ListBox = GuiCtrlCreateList("", 20,20, $wdDlg - 40,$htDlg - 60, $WS_VSCROLL) 

  ; button...
  $btnMargin = ($wdDlg - $wdBtn) / 2
  $CancelButton = GuiCtrlCreateButton("Cancel", $btnMargin,$htDlg - 45, $wdBtn,$htBtn)
  GUICtrlSetOnEvent($CancelButton, "btnCancel_Click")

  ; our corporate logo here...
  $CorpLogo = GuiCtrlCreateLabel($sLogo, $wdDlg - 250,$htDlg - 15)
  GUICtrlSetFont($CorpLogo, 7, $FW_NORMAL, $GUI_FONTITALIC, "Arial")  ; small font

  ; NOTA BENE: if the window has ws_visible style bit set, you will 
  ;   be able to see it, BUT, YOU AIN'T GONNA GET ANY BUTTON-CLICK EVENTS 
  ;   UNLESS YOU SHOW IT using the following statement!!!
  GuiSetState(@SW_SHOW)  ; show the dialog

EndFunc

; --- end of script code (er, autoIt code) -------

