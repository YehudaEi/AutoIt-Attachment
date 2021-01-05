#Region Compiler directives section 
;** This is a list of compiler directives used by CompileAU3.exe.
;** comment the lines you don't need or else it will override the default settings
;#Compiler_Prompt=y              				;y=show compile menu   
;** AUT2EXE settings
;#Compiler_AUT2EXE=
#Compiler_Icon=Wizard.ico                  		;Filename of the Ico file to use
;#Compiler_OutFile=              				;Target exe filename.
#Compiler_Compression=2         				;Compression parameter 0-4  0=Low 2=normal 4=High
#Compiler_Allow_Decompile=y      				;y= allow decompile
;#Compiler_PassPhrase=           				;Password to use for compilation
;** Target program Resource info
#Compiler_Res_Comment=Generate MessageBox and Inputbox code. You can Preview the message/input box and copy the generated code to the clipboard or Standard Output (if the command-line parameter /StdOut is provided) for later use.
#Compiler_Res_Description=MessageBox and InputBox code generator
#Compiler_Res_Fileversion=1.1
#Compiler_Res_LegalCopyright=Giuseppe Criaco 
; free form resource fields ... max 15
#Compiler_Res_Field=Email|gcriaco@quipo.it   	;Free format fieldname|fieldvalue
#Compiler_Res_Field=Release Date|8/2/2005  		;Free format fieldname|fieldvalue
;#Compiler_Res_Field=Name|Value  				;Free format fieldname|fieldvalue
;#Compiler_Res_Field=Name|Value  				;Free format fieldname|fieldvalue
#Compiler_Run_AU3Check=y        	;Run au3check before compilation
; The following directives can contain:
;   %in% , %out%, %icon% which will be replaced by the fullpath\filename. 
;   %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
#Compiler_Run_Before=           				;process to run before compilation - you can have multiple records that will be processed in sequence
#Compiler_Run_After=move "%out%" "%scriptdir%"  ;process to run After compilation - you can have multiple records that will be processed in sequence
#EndRegion
;===============================================================================
;
; Program Name:     CodeWizard()
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

#Region - Include and Declarations

#include <GUIConstants.au3>
#include <Constants.au3>

Global $iMFlag, $Button, $sMsgBox, $asMsgText, $sOutType, $sMText, $sIPwdChr, $sIWidth, $sIHeight, $sILeft, $sITop, $sInputBox, _
   $asIPromptText, $sIPrompt, $sMFlag, $sMComment

$sOutType = "ClipBoard"
If $CmdLine[0] = 1 Then
   If $CmdLine[1] = "/StdOut" Then
	  $sOutType = "Console"
   EndIf
EndIf

#EndRegion - Include and Declarations

#Region - GUI objects creation

GUICreate("Code Wizard v. 1.1", 460, 540, 100, 100)  ; will create a dialog box 

$tab = GUICtrlCreateTab (10, 5, 440, 495) ; will create a Tab object

;MessageBox Tab Item Objects ---------------------------------------------------------------------------------------
$tabMsgBox = GUICtrlCreateTabitem ("MessageBox")

;Text Group
GUICtrlCreateGroup("Title", 20, 40, 205, 65)
$txtMTitle = GUICtrlCreateInput("", 30, 70, 185, 20)
GUICtrlSetState ( -1, $GUI_FOCUS)
GUICtrlSetTip(-1, "The title of the message box.")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateLabel("Text", 20, 120, 30)
$txtMText = GUICtrlCreateEdit("", 20, 135, 420, 70, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
GUICtrlSetTip(-1, "The text of the message box.")

;Icons Group
GUICtrlCreateGroup("Icons", 235, 40, 205, 65)
$chkMWarning = GUICtrlCreateCheckbox ("", 255, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
GUICtrlSetTip(-1, "Warning")
GUICtrlSetImage (-1, "user32.dll",1)
$chkMQuestion = GUICtrlCreateCheckbox ("", 295, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
GUICtrlSetTip(-1, "Informational")
GUICtrlSetImage (-1, "user32.dll", 2)
$chkMCritical = GUICtrlCreateCheckbox ("", 335, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
GUICtrlSetTip(-1, "Critical")
GUICtrlSetImage (-1, "user32.dll", 3)
$chkMInfo = GUICtrlCreateCheckbox ("", 375, 55, 40, 40, $BS_PUSHLIKE+$BS_ICON)
GUICtrlSetTip(-1, "Question")
GUICtrlSetImage (-1, "user32.dll", 4)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Options Group
GUICtrlCreateGroup("Options", 235, 320, 205, 70)
GUICtrlCreateLabel("Timeout", 245, 345, 40, 20)
$txtMTimeout = GUICtrlCreateInput("", 245, 360, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "Optional Timeout in seconds. After the timeout has elapsed the message box will be automatically closed.")
$chkMConstants = GUICtrlCreateCheckbox("Use Constants",340, 362, 85)
GUICtrlSetTip(-1, "Include <Constants.au3> in resulting code.")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Buttons 
GUICtrlCreateGroup("Buttons", 20, 220, 205, 170)
$optMOK = GUICtrlCreateRadio("OK", 30, 240, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optMYesNo = GUICtrlCreateRadio("Yes, No", 30, 260, 100, 20)
$optMOKCancel = GUICtrlCreateRadio("OK, Cancel", 30, 280, 100, 20)
$optMYesNoCancel = GUICtrlCreateRadio("Yes, No, Cancel", 30, 300, 100, 20)
$optMAbortRetryIgnore = GUICtrlCreateRadio("Abort, Retry, Ignore", 30, 320, 120, 20)
$optMRetryCancel = GUICtrlCreateRadio("Retry, Cancel", 30, 340, 100, 20)
$optMCancelTryContinue = GUICtrlCreateRadio("Cancel, Try Again, Continue", 30, 360, 150, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Modality Group
GUICtrlCreateGroup("Modality", 20, 400, 205, 90)
$optApplication = GUICtrlCreateRadio("Application", 30, 420, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optMSysModal = GUICtrlCreateRadio("System Modal", 30, 440, 100, 20)
$optMTaskModal = GUICtrlCreateRadio("Task Modal", 30, 460, 100, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Miscellaneous Group
GUICtrlCreateGroup("Miscellaneous",235, 400, 205, 90)
$chkMTopMost = GUICtrlCreateCheckbox("Top-most attribute", 245, 425, 130, 20)
$chkMRightJust = GUICtrlCreateCheckbox("Right-justified title/text", 245, 455, 150, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Default buttons Group
GUICtrlCreateGroup("Default Button", 235, 220, 205, 90)
$optMFirst = GUICtrlCreateRadio("First Button", 245, 240, 130, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$optMSecond = GUICtrlCreateRadio("Second Button", 245, 260, 130, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
$optMThird = GUICtrlCreateRadio("Third Button", 245, 280, 130, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlSetState ( $txtMTitle, $GUI_FOCUS)

GUICtrlCreateTabitem ("")    ; end tabitem definition

;InputBox Tab Item Objects -----------------------------------------------------------------------------------------
$tabInputBox = GUICtrlCreateTabitem ("InputBox")

; Text Objects
GUICtrlCreateLabel("Title", 20, 60, 20)
$txtITitle = GUICtrlCreateInput("", 20, 75, 420, 20)
GUICtrlSetState ( -1, $GUI_FOCUS)
GUICtrlSetTip(-1, "The title of the input box")
GUICtrlCreateLabel("Prompt", 20, 120, 50)
$txtIPrompt = GUICtrlCreateEdit("", 20, 135, 420, 70, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
GUICtrlSetTip(-1, "A message to the user indicating what kind of input is expected")
GUICtrlCreateLabel("Default text", 20, 230, 100)
$txtIDefault = GUICtrlCreateInput("", 20, 245, 420, 20)
GUICtrlSetTip(-1, "The value that the input box starts with")

;Options Group
GUICtrlCreateGroup("Options [Optional]", 20, 290, 420, 70)
GUICtrlCreateLabel("Input length", 30, 310, 100)
$txtIChrLen = GUICtrlCreateInput("", 30, 325, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The maximum length of the input box")
GUICtrlCreateLabel("Password char", 140, 310, 100)
$txtIPwdChr = GUICtrlCreateInput("", 140, 325, 70, 20)
GUICtrlSetTip(-1, "The character to replace all typed characters with")
GuiCtrlSetLimit($txtIPwdChr, 1, 0)
GUICtrlCreateLabel("Timeout", 250, 310, 100)
$txtITimeOut = GUICtrlCreateInput("", 250, 325, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "How many seconds to wait before automatically cancelling the InputBox")
$chkIMandatory = GUICtrlCreateCheckbox ("Mandatory", 360,325, 70, 20)
GUICtrlSetTip(-1, "Input is Mandatory; i.e. you must enter something")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Position Group
GUICtrlCreateGroup("Position [Optional]", 20, 390, 420, 70)
GUICtrlCreateLabel("Width", 30, 410, 100)
$txtIWidth = GUICtrlCreateInput("", 30, 425, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The width of the window. If defined, height must also be defined. Use -1 for default width")
GUICtrlCreateLabel("Height", 140, 410, 100)
$txtIHeight = GUICtrlCreateInput("", 140, 425, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The height of the window. If defined, width must also be defined. Use -1 for default height")
GUICtrlCreateLabel("Left", 250, 410, 100)
$txtILeft = GUICtrlCreateInput("", 250, 425, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The left side of the input box. By default, the box is centered. If defined, top must also be defined")
GUICtrlCreateLabel("Top", 360, 410, 60)
$txtITop = GUICtrlCreateInput("", 360, 425, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The top of the input box. By default, the box is centered. If defined, left must also be defined")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateTabitem ("")    ; end tabitem definition

;SplashText Tab Item Objects -----------------------------------------------------------------------------------------
$tabSplashText = GUICtrlCreateTabitem ("SplashText")

;Text Group
GUICtrlCreateLabel("Title", 20, 60, 20)
$txtSTitle = GUICtrlCreateInput("", 20, 75, 420, 20)
GUICtrlSetState ( -1, $GUI_FOCUS)
GUICtrlSetTip(-1, "The title of the splash screen.")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateLabel("Text", 20, 120, 30)
$txtSText = GUICtrlCreateEdit("", 20, 135, 420, 70, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
GUICtrlSetTip(-1, "The text of the splash screen.")

;Font Group
GUICtrlCreateGroup("Fonts", 20, 215, 420, 115)
GUICtrlCreateLabel("Font", 30, 235, 100)
$txtSFont = GuiCtrlCreateCombo("",30, 250, 400, 100)
GuiCtrlSetTip(-1,"")
GUICtrlCreateLabel("Size", 30, 280, 100)
$txtSSize = GuiCtrlCreateInput("", 30, 295, 70, 20, $ES_NUMBER)
GuiCtrlSetTip(-1,"")
GUICtrlCreateLabel("Weight", 140, 280, 100)
$txtSWeight = GUICtrlCreateInput("", 140, 295, 70, 20, $ES_NUMBER)
GuiCtrlSetTip(-1,"")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Options Group
GUICtrlCreateGroup("Options", 20, 335, 420, 70)
GUICtrlCreateLabel("Timeout", 30, 355, 40, 20)
$txtSTimeout = GUICtrlCreateInput("", 30, 370, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "Optional Timeout in seconds. After the timeout has elapsed the message box will be automatically closed.")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;Position Group
GUICtrlCreateGroup("Position [Optional]", 20, 420, 420, 70)
GUICtrlCreateLabel("Width", 30, 440, 100)
$txtSWidth = GUICtrlCreateInput("", 30, 455, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The width of the splash screen. If defined, height must also be defined. Use -1 for default width")
GUICtrlCreateLabel("Height", 140, 440, 100)
$txtSHeight = GUICtrlCreateInput("", 140, 455, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The height of the splash screen. If defined, width must also be defined. Use -1 for default height")
GUICtrlCreateLabel("Left", 250, 440, 100)
$txtSLeft = GUICtrlCreateInput("", 250, 455, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The left side of the splash screen. By default, the box is centered. If defined, top must also be defined")
GUICtrlCreateLabel("Top", 360, 440, 60)
$txtSTop = GUICtrlCreateInput("", 360, 455, 70, 20, $ES_NUMBER)
GUICtrlSetTip(-1, "The top of the splash screen. By default, the box is centered. If defined, left must also be defined")
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

GUICtrlCreateTabitem ("")    ; end tabitem definition

;Buttons ------------------------------------------------------------------------------------------------------------
$btnPreview = GUICtrlCreateButton("&Preview", 10, 510, 100)
GUICtrlSetTip(-1, "Show the MessageBox/InputBox")
$btnCopy = GUICtrlCreateButton("&Copy", 120, 510, 100)
If $sOutType = "Console" Then
   GUICtrlSetTip(-1, "Copy the generated AutoIt code to the Console")
Else
   GUICtrlSetTip(-1, "Copy the generated AutoIt code to the Clipboard")
EndIf
$btnExit = GUICtrlCreateButton("&Exit", 230, 510, 100)
GUICtrlSetTip(-1, "Quit the program")

#EndRegion - GUI objects creation

#Region GUI management

$Button = $optMOK

GuiSetState ()

; Run the GUI until the dialog is closed
While 1
   $msg = GUIGetMsg()
    
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $btnExit
		 Exit
      
	  Case Else
		 If GUICtrlRead($tab) = 0 Then
			_MsgBoxMgt($msg)	;MessageBox Wizard
		 Else
			_InputBoxMgt($msg)	;InputBox Wizard
		 EndIf
		 
   EndSelect
   
Wend

#EndRegion GUI management

#Region Functions

;===============================================================================
;
; Function Name:    _MsgBoxMgt()
; Description:      MessageBox Management 
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;
Func _MsgBoxMgt($msg)
   Select
	  Case $msg = $chkMWarning
		 GUICtrlSetState($chkMQuestion, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMCritical, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMInfo, $GUI_UNCHECKED)
	  
	  Case $msg = $chkMQuestion
		 GUICtrlSetState($chkMWarning, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMCritical, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMInfo, $GUI_UNCHECKED)
	  
	  Case $msg = $chkMCritical
		 GUICtrlSetState($chkMWarning, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMQuestion, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMInfo, $GUI_UNCHECKED)
	  
	  Case $msg = $chkMInfo
		 GUICtrlSetState($chkMWarning, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMQuestion, $GUI_UNCHECKED)
		 GUICtrlSetState($chkMCritical, $GUI_UNCHECKED)
	  
      Case $msg = $optMOK
         $Button = $optMOK
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_DISABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMOkCancel
         $Button = $optMOkCancel
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMYesNo
         $Button = $optMYesNo
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMYesNoCancel
         $Button = $optMYesNoCancel
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_ENABLE)
         
      Case $msg = $optMAbortRetryIgnore
         $Button = $optMAbortRetryIgnore
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_ENABLE)
         
      Case $msg = $optMRetryCancel
         $Button = $optMRetryCancel
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_DISABLE)
         
      Case $msg = $optMCancelTryContinue
         $Button = $optMCancelTryContinue
         GUICtrlSetState($optMFirst, $GUI_CHECKED)
         GUICtrlSetState($optMFirst, $GUI_ENABLE)
         GUICtrlSetState($optMSecond, $GUI_ENABLE)
         GUICtrlSetState($optMThird, $GUI_ENABLE)
         
      Case $msg = $btnPreview						;Preview Button
         MsgBox(_SetFlag(), GUICtrlRead($txtMTitle), GUICtrlRead($txtMText), GUICtrlRead($txtMTimeout))
  
      Case $msg = $btnCopy							;Copy Button
         $asMsgText = StringSplit(GUICtrlRead($txtMText), @CRLF, 1)
         If $asMsgText[0] = 1 Then
            $sMText = GUICtrlRead($txtMText)
         Else
            $sText = $asMsgText[1]
            
            For $iCtr = 2 To $asMsgText[0]
               $sMText = $sMText & Chr(34) & " & @CRLF & " & Chr(34) & $asMsgText[$iCtr]
            Next
            
         EndIf
		 
		 $sMComment = ""
         
		 Select
            Case $Button = $optMOK
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox =  "MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "   Case Else                ;OK" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optMOkCancel
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 1 ;OK" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 1 ;OK" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optMYesNo
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optMYesNoCancel
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 6 ;Yes" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 7 ;No" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optMAbortRetryIgnore
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 3 ;Abort" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 5 ;Ignore" & @CRLF & @CRLF & _
                        "EndSelect"
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 3 ;Abort" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 5 ;Ignore" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"
               EndIf
               
            Case $Button = $optMRetryCancel
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 4 ;Retry" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
               
            Case $Button = $optMCancelTryContinue
               If GUICtrlRead($txtMTimeout) = "" Then
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2 ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 10 ;Try Again" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 11 ;Continue" & @CRLF & @CRLF & _
                        "EndSelect"            
               Else
                  $sMsgBox = "Dim $iMsgBoxAnswer" & @CRLF & _
                        "$iMsgBoxAnswer = MsgBox(" & _SetFlag() & "," & Chr(34) & GUICtrlRead($txtMTitle) & Chr(34) & "," _
                         & Chr(34) & $sMText & Chr(34) & "," & GUICtrlRead($txtMTimeout) & ")" & @CRLF & _
                        "Select" & @CRLF & _
                        "   Case $iMsgBoxAnswer = 2  ;Cancel" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 10 ;Try Again" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = 11 ;Continue" & @CRLF & @CRLF & _
                        "   Case $iMsgBoxAnswer = -1 ;Timeout" & @CRLF & @CRLF & _
                        "EndSelect"            
               EndIf
         EndSelect

		 If GUICtrlRead($chkMConstants) = $GUI_CHECKED Then
			$sMsgBox = "#include <Constants.au3>" & @CRLF & @CRLF & $sMsgBox
			$sMsgBox = StringReplace($sMsgBox, "1 ;OK", "$IDOK")
			$sMsgBox = StringReplace($sMsgBox, "2 ;Cancel", "$IDCANCEL")
			$sMsgBox = StringReplace($sMsgBox, "3 ;Abort", "$IDABORT")
			$sMsgBox = StringReplace($sMsgBox, "4 ;Retry", "$IDRETRY")
			$sMsgBox = StringReplace($sMsgBox, "5 ;Ignore", "$IDIGNORE")			
			$sMsgBox = StringReplace($sMsgBox, "6 ;Yes", "$IDYES")
			$sMsgBox = StringReplace($sMsgBox, "7 ;No", "$IDNO")
			$sMsgBox = StringReplace($sMsgBox, "10 ;Try Again", "$IDTRYAGAIN")
			$sMsgBox = StringReplace($sMsgBox, "11 ;Continue", "$IDCONTINUE")
		 EndIf

		 $sMsgBox = _MComments() & $sMsgBox	& @CRLF & "#EndRegion --- CodeWizard generated code End ---" ;Comment string with MessageBox features

		 If $sOutType = "Console" Then
			ConsoleWrite($sMsgBox)
		 Else
			ClipPut($sMsgBox)
		 Endif
   EndSelect
EndFunc   

;===============================================================================
;
; Function Name:    _InputBoxMgt()
; Description:      InputBox Management  
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;

Func _InputBoxMgt($msg)
   Select
      Case $msg = $btnPreview
		 _Position()
         InputBox(GUICtrlRead($txtITitle), GUICtrlRead($txtIPrompt), GUICtrlRead($txtIDefault), _PwdChr(), _
			$sIWidth, $sIHeight, $sILeft, $sITop, GUICtrlRead($txtITimeOut))
		 
      Case $msg = $btnCopy
		_Position()
		_PwdChr()
         $asIPromptText = StringSplit(GUICtrlRead($txtIPrompt), @CRLF, 1)
         If $asIPromptText[0] = 1 Then
            $sIPrompt = GUICtrlRead($txtIPrompt)
         Else
            $sIPrompt = $asIPromptText[1]
            
            For $iCtr = 2 To $asIPromptText[0]
               $sIPrompt = $sIPrompt & Chr(34) & " & @CRLF & " & Chr(34) & $asIPromptText[$iCtr]
            Next
            
         EndIf
		 
		 _IComments()	;Comment string with InputBox features
		 
		 If GUICtrlRead($txtITimeout) = "" Then
			$sInputBox = $sInputBox & "Dim $iInputBoxAnswer" & @CRLF & _
			   "$iInputBoxAnswer = InputBox(" & Chr(34) & GUICtrlRead($txtITitle) & Chr(34) & "," & Chr(34) & $sIPrompt _
			   & Chr(34) & ","  & Chr(34) & GUICtrlRead($txtIDefault) & Chr(34) & "," & Chr(34) & $sIPwdChr & Chr(34) & "," & _
			   Chr(34) & $sIWidth & Chr(34) &  "," & Chr(34) & $sIHeight & Chr(34) & "," & Chr(34) & $sILeft & Chr(34) & "," _
			   & Chr(34) & $sITop & Chr(34) & ")" & @CRLF & _
			   "Select" & @CRLF & _
			   "   Case @Error = 0 ;OK - The string returned is valid" & @CRLF & @CRLF & _
			   "   Case @Error = 1 ;The Cancel button was pushed" & @CRLF & @CRLF & _
			   "   Case @Error = 3 ;The InputBox failed to open" & @CRLF & @CRLF & _
			   "EndSelect"            
		 Else   
			$sInputBox = $sInputBox & "Dim $iInputBoxAnswer" & @CRLF & _
			   "$iInputBoxAnswer = InputBox(" & Chr(34) & GUICtrlRead($txtITitle) & Chr(34) & "," & Chr(34) & $sIPrompt _
			   & Chr(34) & ","  & Chr(34) & GUICtrlRead($txtIDefault) & Chr(34) & "," & Chr(34) & $sIPwdChr & Chr(34) & "," & _
			   Chr(34) & $sIWidth & Chr(34) &  "," & Chr(34) & $sIHeight & Chr(34) & "," & Chr(34) & $sILeft & Chr(34) & "," _
			   & Chr(34) & $sITop & Chr(34) & "," & Chr(34) & GUICtrlRead($txtITimeOut) & Chr(34) & ")" & @CRLF & _
			   "Select" & @CRLF & _
			   "   Case @Error = 0 ;OK - The string returned is valid" & @CRLF & @CRLF & _
			   "   Case @Error = 1 ;The Cancel button was pushed" & @CRLF & @CRLF & _
			   "   Case @Error = 2 ;The Timeout time was reached" & @CRLF & @CRLF & _
			   "   Case @Error = 3 ;The InputBox failed to open" & @CRLF & @CRLF & _
			   "EndSelect"            
		 EndIf
		 
		 $sInputBox = $sInputBox & @CRLF & "#EndRegion --- CodeWizard generated code End ---" 
		 
		 If $sOutType = "Console" Then
			ConsoleWrite($sInputBox)
		 Else
			ClipPut($sInputBox)
		 Endif
   
   EndSelect
   
EndFunc   
		 
;===============================================================================
;
; Function Name:    _SetFlag()
; Description:      Set the flag that indicates the type of message box and the 
;                   possible button combinations.
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Returns the message box flag
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;

Func _SetFlag()
   ;Buttons
   $sMComment = $sMComment & " Buttons="

   Select
      Case GUICtrlRead($optMOkCancel) = $GUI_CHECKED			; Two push buttons: OK and Cancel
         $iMFlag = 1
		 $sMFlag = "$MB_OKCANCEL"
		 $sMComment = $sMComment & "OK and Cancel,"
      Case GUICtrlRead($optMYesNo) = $GUI_CHECKED				; Two push buttons: Yes and No
         $iMFlag = 4
		 $sMFlag = "$MB_YESNO"
		 $sMComment = $sMComment & "Yes and No,"
      Case GUICtrlRead($optMYesNoCancel) = $GUI_CHECKED			; Three push buttons: Yes, No, and Cancel
         $iMFlag = 3
		 $sMFlag = "$MB_YESNOCANCEL"
		 $sMComment = $sMComment & "Yes, No, and Cancel,"
      Case GUICtrlRead($optMAbortRetryIgnore) = $GUI_CHECKED	; Three push buttons: Abort, Retry, and Ignore	
         $iMFlag = 2
		 $sMFlag = "$MB_ABORTRETRYIGNORE"		
		 $sMComment = $sMComment & "Abort, Retry, and Ignore,"
      Case GUICtrlRead($optMRetryCancel) = $GUI_CHECKED			; Two push buttons: Retry and Cancel
         $iMFlag = 5
		 $sMFlag = "$MB_RETRYCANCEL"
		 $sMComment = $sMComment & "Retry and Cancel,"
      Case GUICtrlRead($optMCancelTryContinue) = $GUI_CHECKED	; Three push buttons: Cancel, Try Again, Continue
         $iMFlag = 6
		 $sMFlag = "$MB_CANCELTRYCONTINUE"
		 $sMComment = $sMComment & "Cancel, Try Again, Continue,"
	  Case Else													; One push button: OK
         $iMFlag = 0
		 $sMFlag = "$MB_OK"
		 $sMComment = $sMComment & "OK,"
   EndSelect
   
   ;Default Button
   Select
      Case GUICtrlRead($optMSecond) = $GUI_CHECKED					; The second button is the default button
         $iMFlag = $iMFlag + 256
		 $sMFlag = $sMFlag & " + " & "$MB_DEFBUTTON2"
		 $sMComment = $sMComment & " Default Button=Second,"
      Case GUICtrlRead($optMThird) = $GUI_CHECKED					; The third button is the default button
         $iMFlag = $iMFlag + 512
		 $sMFlag = $sMFlag & " + " & "$MB_DEFBUTTON3"
		 $sMComment = $sMComment & " Default Button=Third,"
	  Case Else														; The first button is the default button
		 If $sMFlag <> $MB_OK Then $sMComment = $sMComment & " Default Button=First,"
   EndSelect

   ;Icons
   $sMComment = $sMComment & " Icon="

   Select
      Case GUICtrlRead($chkMWarning) = $GUI_CHECKED				; Exclamation-point icon
         $iMFlag = $iMFlag + 48
		 $sMFlag = $sMFlag & " + " & "$MB_ICONEXCLAMATION"
		 $sMComment = $sMComment & "Warning,"
      Case GUICtrlRead($chkMInfo) = $GUI_CHECKED				; Icon consisting of an 'i' in a circle
         $iMFlag = $iMFlag + 64
		 $sMFlag = $sMFlag & " + " & "$MB_ICONASTERISK"
		 $sMComment = $sMComment & "Info,"
      Case GUICtrlRead($chkMCritical) = $GUI_CHECKED			; Stop-sign icon
         $iMFlag = $iMFlag + 16
		 $sMFlag = $sMFlag & " + " & "$MB_ICONHAND"
		 $sMComment = $sMComment & "Critical,"
      Case GUICtrlRead($chkMQuestion) = $GUI_CHECKED			; Question-mark icon
         $iMFlag = $iMFlag + 32
		 $sMFlag = $sMFlag & " + " & "$MB_ICONQUESTION"
		 $sMComment = $sMComment & "Question,"
	  Case Else													; None
		 $sMComment = $sMComment & "None,"
   EndSelect
   
   ;Modality
   Select
      Case GUICtrlRead($optMSysModal) = $GUI_CHECKED			; System modal
         $iMFlag = $iMFlag + 4096
		 $sMFlag = $sMFlag & " + " & "$MB_SYSTEMMODAL"
		 $sMComment = $sMComment & " Modality=System Modal,"
      Case GUICtrlRead($optMTaskModal) = $GUI_CHECKED			; Task modal
         $iMFlag = $iMFlag + 8192
		 $sMFlag = $sMFlag & " + " & "$MB_TASKMODAL"
		 $sMComment = $sMComment & " Modality=Task Modal,"
   EndSelect
   
   ;Timeout
   If GUICtrlRead($txtMTimeout) <> "" Then $sMComment = $sMComment & " Timeout=" & GUICtrlRead($txtMTimeout) & " ss,"
   
   ;Miscellaneous
   If GUICtrlRead($chkMTopMost) = $GUI_CHECKED Then 			; MsgBox has top-most attribute set
	  $iMFlag = $iMFlag + 262144
	  $sMFlag = $sMFlag & " + " & "262144"						
	  $sMComment = $sMComment & " Miscellaneous=Top-most attribute,"
   EndIf

   If GUICtrlRead($chkMRightJust) = $GUI_CHECKED Then 			; Title and text are right-justified
	  $iMFlag = $iMFlag + 524288
	  $sMFlag = $sMFlag & " + " & "524288"						
	  
	  If GUICtrlRead($chkMTopMost) = $GUI_CHECKED Then
		 $sMComment = StringTrimRight($sMComment, 1) & " and Title/text right-justified,"
	  Else
		 $sMComment = $sMComment & " Miscellaneous=Title/text right-justified,"		 
	  EndIf
   EndIf

   If GUICtrlRead($chkMConstants) = $GUI_CHECKED And $msg = $btnCopy Then
	  Return $sMFlag
   Else
	  Return $iMFlag
   EndIf
EndFunc   ;==>_SetFlag

;===============================================================================
;
; Function Name:    _PwdChr()
; Description:      Set the password char field that indicates the type of input
;					box. 
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Returns the password char field
;                   None
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;

Func _PwdChr()
   If GUICtrlRead($txtIPwdChr) = "" Then
	  $sIPwdChr = " " 
   Else
	  $sIPwdChr = GUICtrlRead($txtIPwdChr)
   EndIf
   
   If GUICtrlRead($chkIMandatory) = $GUI_CHECKED Then
	  $sIPwdChr = $sIPwdChr & "M"
	EndIf  
   
   $sIPwdChr = $sIPwdChr & GUICtrlRead($txtIChrLen)

   Return $sIPwdChr
EndFunc   

;===============================================================================
;
; Function Name:    _Position()
; Description:      Set the flag that indicates the size and position of input
;					box and the possible button combinations.
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Returns  Width
;										  Height
;										  Left
;										  Top
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;

Func _Position()
   If GUICtrlRead($txtIWidth) = "" Then
		 $sIWidth = "-1"
   Else
		 $sIWidth = GUICtrlRead($txtIWidth)
   EndIf
   
   If GUICtrlRead($txtIHeight) = "" Then
		 $sIHeight = "-1"
   Else
		 $sIHeight = GUICtrlRead($txtIHeight)
   EndIf
  
  If GUICtrlRead($txtILeft) = "" Then
		 $sILeft = "-1"
   Else
		 $sILeft = GUICtrlRead($txtILeft)
   EndIf
   
   If GUICtrlRead($txtITop) = "" Then
		 $sITop = "-1"
   Else
		 $sITop = GUICtrlRead($txtITop)
   EndIf
	  
   Return $sIWidth
   Return $sIHeight
   Return $sILeft
   Return $sITop
EndFunc   

#EndRegion Functions

;===============================================================================
;
; Function Name:    _MComments()
; Description:      Set the comment that indicates the features of message box
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Returns $sMsgBox (Comment string)
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;

Func _MComments()
   Local $sTmpComment
   
   If GUICtrlRead($txtMTitle) <> "" Then 
	  $sTmpComment = ";MsgBox features: Title=Yes,"  
   Else
	  $sTmpComment = ";MsgBox features: Title=No," 
   EndIf
	  
   If $sMText <> "" Then 
	  $sTmpComment = $sTmpComment & " Text=Yes,"  
   Else
	  $sTmpComment = $sTmpComment & " Text=No,"  
   EndIf

   $sMComment = "#Region --- CodeWizard generated code Start ---" & @CRLF & $sTmpComment & 	$sMComment		;Header of the comment string
   $sMComment = StringTrimRight($sMComment, 1)	;Remove the last comma

   $sMComment = $sMComment & @CRLF
	  
   Return $sMComment
EndFunc   

;===============================================================================
;
; Function Name:    _IComments()
; Description:      Set the comment that indicates the features of input box
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Returns $sInputBox (Comment string)
; Author(s):        Giuseppe Criaco <gcriaco@quipo.it>
;
;===============================================================================
;

Func _IComments()
   ;Header of comment
   $sInputBox = "#Region --- CodeWizard generated code Start ---" & @CRLF & _	
	  "InputBox features:" & $sInputBox	
   
   If GUICtrlRead($txtITitle) <> "" Then 
	  $sInputBox = $sInputBox & " Title=Yes,"
   Else
	  $sInputBox = $sInputBox & " Title=No,"
   EndIf
	  
   If $sIPrompt <> "" Then 
	  $sInputBox = $sInputBox & " Prompt=Yes,"
   Else
	  $sInputBox = $sInputBox & " Prompt=No,"
   EndIf

   If GUICtrlRead($txtIDefault) <> "" Then
	  $sInputBox = $sInputBox & " Default Text=Yes,"
   Else
	  $sInputBox = $sInputBox & " Default Text=No,"
   EndIf

   If GUICtrlRead($txtIChrLen) <> "" Then $sInputBox = $sInputBox & " Input Length=" & GUICtrlRead($txtIChrLen) & ","
   If GUICtrlRead($txtIPwdChr) <> "" Then $sInputBox = $sInputBox & " Pwd Char=" &  GUICtrlRead($txtIPwdChr) & ","
   If GUICtrlRead($txtITimeOut) <> "" Then $sInputBox = $sInputBox & " TimeOut=" &  GUICtrlRead($txtITimeOut) & " ss,"
   If GUICtrlRead($chkIMandatory) = $GUI_CHECKED Then $sInputBox = $sInputBox & " Mandatory," 
   If $sIWidth <> "-1" Then $sInputBox = $sInputBox & " Width=" &  $sIWidth & ","
   If $sIHeight <> "-1" Then $sInputBox = $sInputBox & " Height=" &  $sIHeight & ","
   If $sILeft <> "-1" Then $sInputBox = $sInputBox & " Left=" &  $sILeft & ","
   If $sITop <> "-1" Then $sInputBox = $sInputBox & " Top=" &  $sITop & ","
   
   $sInputBox = StringTrimRight($sInputBox, 1)		;Remove the last comma
   $sInputBox = $sInputBox & @CRLF 
	  
   Return $sInputBox
EndFunc   

#EndRegion Functions
