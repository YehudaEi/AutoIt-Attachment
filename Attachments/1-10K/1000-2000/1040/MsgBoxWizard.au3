;;;;
; Slightly modified by CyberSlug - 29 Jan 2005
;;;;

;===============================================================================
;
; Program Name:     MsgBoxWizard()
; Description:      Generate the MessageBox function code according to the user 
;                   choices
; Parameter(s):     /StdOut [optional - from command line] - Copy the generated 
;					AutoIt code to the Console instead of Clipboard
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;
#include <GUIConstants.au3>

Global $iFlag, $Button, $sMsgBox, $asMsgText, $sOutType

$sOutType = "ClipBoard"
If $CmdLine[0] = 1 Then
   If $CmdLine[1] = "/StdOut" Then
	  $sOutType = "Console"
   EndIf
EndIf

#Region - GUI objects creation

GUICreate("MsgBox Wizard v.1.1", 440, 540, 100, 100)  ; will create a dialog box 

GUICtrlCreateLabel("Title", 10, 5, 30)
$sTitle = GUICtrlCreateInput("", 10, 20, 420, 20)
GUICtrlSetState ( -1, $GUI_FOCUS)
GUICtrlSetTip(-1, "The title of the message box.")
GUICtrlCreateLabel("Text", 10, 50, 30)
$sText = GUICtrlCreateEdit("", 10, 65, 420, 100, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
GUICtrlSetTip(-1, "The text of the message box.")

GUICtrlCreateGroup("Icons", 10, 170, 200, 130)
$optWarning = GUICtrlCreateRadio("Warning", 20, 190, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optInfo = GUICtrlCreateRadio("Informational", 20, 210, 100, 20)
$optCritical = GUICtrlCreateRadio("Critical", 20, 230, 100, 20)
$optQuestion = GUICtrlCreateRadio("Question", 20, 250, 100, 20)
$optNoIcon = GUICtrlCreateRadio("None", 20, 270, 100, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateGroup("Modality", 10, 310, 200, 90)
$optApplication = GUICtrlCreateRadio("Application", 20, 330, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optSysModal = GUICtrlCreateRadio("System Modal", 20, 350, 100, 20)
$optTaskModal = GUICtrlCreateRadio("Task Modal", 20, 370, 100, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateGroup("Buttons", 230, 170, 200, 170)
$optOK = GUICtrlCreateRadio("OK", 240, 190, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optYesNo = GUICtrlCreateRadio("Yes, No", 240, 230, 100, 20)
$optOkCancel = GUICtrlCreateRadio("OK, Cancel", 240, 210, 100, 20)
$optYesNoCancel = GUICtrlCreateRadio("Yes, No, Cancel", 240, 250, 100, 20)
$optAbortRetryIgnore = GUICtrlCreateRadio("Abort, Retry, Ignore", 240, 270, 120, 20)
$optRetryCancel = GUICtrlCreateRadio("Retry, Cancel", 240, 290, 100, 20)
$optCancelRetryContinue = GUICtrlCreateRadio("Cancel, Try Again, Continue", 240, 310, 150, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateGroup("Miscellaneous", 10, 410, 200, 90)
$optNothing = GUICtrlCreateRadio("Nothing", 20, 430, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optTopMost = GUICtrlCreateRadio("Top-most attribute set", 20, 450, 130, 20)
$optRightJust = GUICtrlCreateRadio("Right-justified title/text", 20, 470, 150, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateGroup("Default Buttons", 230, 350, 200, 90)
$optFirst = GUICtrlCreateRadio("First Button", 240, 370, 130, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optSecond = GUICtrlCreateRadio("Second Button", 240, 390, 130, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
$optThird = GUICtrlCreateRadio("Third Button", 240, 410, 130, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateGroup("Timeout", 230, 450, 200, 50)
$Timeout = GUICtrlCreateInput("", 240, 470, 100, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "Optional Timeout in seconds. After the timeout has elapsed the message box will be automatically closed.")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

$btnPreview = GUICtrlCreateButton("&Preview", 10, 510, 100)
GUICtrlSetTip(-1, "Show the MessageBox")
$btnCopy = GUICtrlCreateButton("&Copy", 120, 510, 100)
If $sOutType = "Console" Then
   GUICtrlSetTip(-1, "Copy the generated AutoIt code to the Console")
Else
   GUICtrlSetTip(-1, "Copy the generated AutoIt code to the Clipboard")
EndIf

$btnExit = GUICtrlCreateButton("&Exit", 230, 510, 100)
GUICtrlSetTip(-1, "Quit the program")

$chkboxConstants = GUICtrlCreateCheckbox("Use Constants", 340, 510, 100)
GUICtrlSetTip(-1, "Include <Constants.au3> in resulting code.")

$iconPreview = GuiCtrlCreateIcon("C:\Windows\system32\user32.dll", 1, 140, 220, 32, 32)

#EndRegion

#Region GUI management

$Button = $optOK

GUISetState()       ; will display an empty dialog box

; Run the GUI until the dialog is closed
While 1
   $MSG = GUIGetMsg()
   Select
      Case $MSG = $GUI_EVENT_CLOSE Or $MSG = $btnExit
         Exit
         
	Case $MSG = $optWarning
		GuiCtrlSetImage($iconPreview, "user32.dll", 1)
	Case $MSG = $optQuestion
		GuiCtrlSetImage($iconPreview, "user32.dll", 2)
	Case $MSG = $optCritical
		GuiCtrlSetImage($iconPreview, "user32.dll", 3)
	Case $MSG = $optInfo
		GuiCtrlSetImage($iconPreview, "user32.dll", 4)
	Case $MSG = $optNoIcon
		GuiCtrlSetImage($iconPreview, "user32.dll", 6)
		 
      Case $MSG = $optOK
         $Button = $optOK
         GUICtrlSetState($optFirst, $GUI_CHECKED)
         GUICtrlSetState($optFirst, $GUI_ENABLE)
         GUICtrlSetState($optSecond, $GUI_DISABLE)
         GUICtrlSetState($optThird, $GUI_DISABLE)
         
      Case $MSG = $optOkCancel
         $Button = $optOkCancel
         GUICtrlSetState($optFirst, $GUI_CHECKED)
         GUICtrlSetState($optFirst, $GUI_ENABLE)
         GUICtrlSetState($optSecond, $GUI_ENABLE)
         GUICtrlSetState($optThird, $GUI_DISABLE)
         
      Case $MSG = $optYesNo
         $Button = $optYesNo
         GUICtrlSetState($optFirst, $GUI_CHECKED)
         GUICtrlSetState($optFirst, $GUI_ENABLE)
         GUICtrlSetState($optSecond, $GUI_ENABLE)
         GUICtrlSetState($optThird, $GUI_DISABLE)
         
      Case $MSG = $optYesNoCancel
         $Button = $optYesNoCancel
         GUICtrlSetState($optFirst, $GUI_CHECKED)
         GUICtrlSetState($optFirst, $GUI_ENABLE)
         GUICtrlSetState($optSecond, $GUI_ENABLE)
         GUICtrlSetState($optThird, $GUI_ENABLE)
         
      Case $MSG = $optAbortRetryIgnore
         $Button = $optAbortRetryIgnore
         GUICtrlSetState($optFirst, $GUI_CHECKED)
         GUICtrlSetState($optFirst, $GUI_ENABLE)
         GUICtrlSetState($optSecond, $GUI_ENABLE)
         GUICtrlSetState($optThird, $GUI_ENABLE)
         
      Case $MSG = $optRetryCancel
         $Button = $optRetryCancel
         GUICtrlSetState($optFirst, $GUI_CHECKED)
         GUICtrlSetState($optFirst, $GUI_ENABLE)
         GUICtrlSetState($optSecond, $GUI_ENABLE)
         GUICtrlSetState($optThird, $GUI_DISABLE)
         
      Case $MSG = $optCancelRetryContinue
         $Button = $optCancelRetryContinue
         GUICtrlSetState($optFirst, $GUI_CHECKED)
         GUICtrlSetState($optFirst, $GUI_ENABLE)
         GUICtrlSetState($optSecond, $GUI_ENABLE)
         GUICtrlSetState($optThird, $GUI_ENABLE)
         
      Case $MSG = $btnPreview
         MsgBox(_SetFlag($iFlag), GUICtrlRead($sTitle), GUICtrlRead($sText), GUICtrlRead($Timeout))
         
      Case $MSG = $btnCopy
         $asMsgText = StringSplit(GUICtrlRead($sText), @CRLF, 1)
         If $asMsgText[0] = 1 Then
            $sText = GUICtrlRead($sText)
         Else
            $sText = $asMsgText[1]
            
            For $iCtr = 2 To $asMsgText[0]
               $sText = $sText & Chr(34) & " & @CRLF & " & Chr(34) & $asMsgText[$iCtr]
            Next
            
         EndIf
         
         Select
            Case $Button = $optOK
               If GUICtrlRead($Timeout) = "" Then
                  $sMsgBox = "MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & ")"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & "," & GUICtrlRead($Timeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "   Case Else                ;OK" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optOkCancel
               If GUICtrlRead($Timeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 1 ;OK" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & "," & GUICtrlRead($Timeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 1 ;OK" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optYesNo
               If GUICtrlRead($Timeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & "," & GUICtrlRead($Timeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optYesNoCancel
               If GUICtrlRead($Timeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & "," & GUICtrlRead($Timeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optAbortRetryIgnore
               If GUICtrlRead($Timeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 3 ;Abort" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 5 ;Ignore" & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & "," & GUICtrlRead($Timeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 3 ;Abort" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 5 ;Ignore" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optRetryCancel
               If GUICtrlRead($Timeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & "," & GUICtrlRead($Timeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optCancelRetryContinue
               If GUICtrlRead($Timeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 10 ;Try Again" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 11 ;Continue" & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag($iFlag) & "," & Chr(34) & GUICtrlRead($sTitle) & Chr(34) & "," _
                         & Chr(34) & $sText & Chr(34) & "," & GUICtrlRead($Timeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2  ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 10 ;Try Again" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 11 ;Continue" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
         EndSelect

		If GUICtrlRead($chkboxConstants) = $GUI_CHECKED Then
			$sMsgBox = "include# <Constants.au3>" & @CRLF & @CRLF & $sMsgBox
			$sMsgBox = StringReplace($sMsgBox, "1 ;OK", "$IDOK")
			$sMsgBox = StringReplace($sMsgBox, "2 ;Cancel", "$IDCANCEL")
			$sMsgBox = StringReplace($sMsgBox, "3 ;Abort", "$IDABORT")
			$sMsgBox = StringReplace($sMsgBox, "4 ;Retry", "$IDRETRY")
			$sMsgBox = StringReplace($sMsgBox, "5 ;Ignore", "$IDIGNORE")			
			$sMsgBox = StringReplace($sMsgBox, "6 ;Yes", "$IDYES")
			$sMsgBox = StringReplace($sMsgBox, "7 ;No", "$IDNO")
		EndIf

		 If $sOutType = "Console" Then
			ConsoleWrite($sMsgBox)
		 Else
			ClipPut($sMsgBox)
		 Endif
   EndSelect
   
Wend

#EndRegion

;===============================================================================
;
; Function Name:    _SetFlag()
; Description:      Set the flag that indicates the type of message box and the 
;                   possible button combinations.
; Parameter(s):     $iFlag        - MessageBox Flag
; Requirement(s):   None
; Return Value(s):  On Success - Returns the message box flag
;                   None
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;

Func _SetFlag($iFlag)
   $iFlag = 0
   
   ;Icons
   Select
      Case GUICtrlRead($optWarning) = $GUI_CHECKED
         $iFlag = $iFlag + 48
      Case GUICtrlRead($optInfo) = $GUI_CHECKED
         $iFlag = $iFlag + 64
      Case GUICtrlRead($optCritical) = $GUI_CHECKED
         $iFlag = $iFlag + 16
      Case GUICtrlRead($optQuestion) = $GUI_CHECKED
         $iFlag = $iFlag + 32
   EndSelect
   
   ;Modality
   Select
      Case GUICtrlRead($optSysModal) = $GUI_CHECKED
         $iFlag = $iFlag + 4096
      Case GUICtrlRead($optTaskModal) = $GUI_CHECKED
         $iFlag = $iFlag + 8192
   EndSelect
   
   ;Buttons
   Select
      Case GUICtrlRead($optOkCancel) = $GUI_CHECKED
         $iFlag = $iFlag + 1
      Case GUICtrlRead($optYesNo) = $GUI_CHECKED
         $iFlag = $iFlag + 4
      Case GUICtrlRead($optYesNoCancel) = $GUI_CHECKED
         $iFlag = $iFlag + 3
      Case GUICtrlRead($optAbortRetryIgnore) = $GUI_CHECKED
         $iFlag = $iFlag + 2
      Case GUICtrlRead($optRetryCancel) = $GUI_CHECKED
         $iFlag = $iFlag + 5
      Case GUICtrlRead($optCancelRetryContinue) = $GUI_CHECKED
         $iFlag = $iFlag + 6
   EndSelect
   
   ;Miscellaneous
   Select
      Case GUICtrlRead($optTopMost) = $GUI_CHECKED
         $iFlag = $iFlag + 262144
      Case GUICtrlRead($optRightJust) = $GUI_CHECKED
         $iFlag = $iFlag + 5244288
   EndSelect
   
   ;Default Buttons
   Select
      Case GUICtrlRead($optSecond) = $GUI_CHECKED
         $iFlag = $iFlag + 256
      Case GUICtrlRead($optThird) = $GUI_CHECKED
         $iFlag = $iFlag + 512
   EndSelect
   
   Return $iFlag
EndFunc   ;==>_SetFlag