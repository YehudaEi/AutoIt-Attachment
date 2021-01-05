; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstants.au3>
$parent = GUICreate("HTML Code Generator", 400, 400, 400, -1, $WS_MINIMIZEBOX + $WS_CAPTION + $WS_SYSMENU)
$output = GUICtrlCreateEdit("", 0, 0, 400, 400, $ES_READONLY + $WS_VSCROLL + $WS_HSCROLL)
$child = GUICreate("Toolbar", 200, 300, 815, 185, $WS_CAPTION, -1, $parent)
$EditCtrl = GUICtrlCreateButton("Edit", 0, 20, 50, 50)
GUICtrlSetFont(-1, 8)
$InputCtrl = GUICtrlCreateButton("Input", 150, 20, 50, 50)
GUICtrlSetFont(-1, 8)
$ChckBoxCtrl = GUICtrlCreateButton("Checkbox", 0, 120, 50, 50)
GUICtrlSetFont(-1, 8)
$RadioCtrl = GUICtrlCreateButton("Radio", 150, 70, 50, 50)
GUICtrlSetFont(-1, 8)
$MarqueeCtrl = GUICtrlCreateButton("Marquee", 0, 70, 50, 50)
GUICtrlSetFont(-1, 8)
$PicCtrl = GUICtrlCreateButton("Picture", 75, 70, 50, 50)
GUICtrlSetFont(-1, 8)
$ButtonCtrl = GUICtrlCreateButton("Button", 75, 20, 50, 50)
GUICtrlSetFont(-1, 8)
$msgbox = GUICtrlCreateButton("MsgBox", 150, 120, 50, 50)
GUICtrlSetFont(-1, 8)
$text = GUICtrlCreateButton("Text", 75, 120, 50, 50)
GUICtrlSetFont(-1, 8)
$ParagraphCtrl = GUICtrlCreateButton ("Paragraph", 0, 170, 50, 50)
GUICtrlSetFont(-1, 7)
$wrapup = GUICtrlCreateButton("Wrap it up!", 75, 250)
GUICtrlSetFont(-1, 8)
$hardcode = GUICtrlCreateCheckbox("Hard code edit", 0, 225)
GUICtrlSetFont($hardcode, 8)
$setstyle = GUICtrlCreateButton("Set", 95, 223, 50)
GUICtrlSetFont($setstyle, 8)
$file = GUICtrlCreateMenu("File")
GUICtrlSetFont($file, 8)
$fileitem1 = GUICtrlCreateMenuItem("Open", $file)
GUICtrlSetFont($fileitem1, 8)
GUICtrlSetData($output, "<HTML>" & @CRLF, 1)
GUICtrlSetData($output, "<HEAD><TITLE>NEW TITLE HERE!!</TITLE></HEAD> <!-- CODE CREATED WITH HTML CODE GENERATOR BY RYAN rpm91m@gmail.com -->" & @CRLF, 1)
GUICtrlSetData($output, "<BODY>" & @CRLF, 1)
;$form = GUICreate("Form", 350, 400, 0, 185, $WS_CAPTION, -1, $parent)


GUISetState(@SW_SHOW, $parent)
GUISetState(@SW_SHOW, $child)
;GUISetState(@SW_SHOW, $form)
Func MainLoop()
   While 1
      $get = GUIGetMsg()
      If $get = -3 Then Exit
      If $get = $EditCtrl Then _AddEdit()
      If $get = $InputCtrl Then _AddInput()
      If $get = $ChckBoxCtrl Then _AddCheckBox()
      If $get = $MarqueeCtrl Then _AddMarquee()
      If $get = $wrapup Then _WrapItUp()
      If $get = $ButtonCtrl Then _AddButton()
      If $get = $RadioCtrl Then _AddRadio()
      If $get = $text Then _AddText()
      If $get = $PicCtrl Then _AddPic()
      If $get = $msgbox Then _AddMsgBox()
      If $get = $setstyle Then _SetHardCodeStyle()
      If $get = $fileitem1 Then _OpenHTML()
	  If $get = $ParagraphCtrl Then _AddParagraph()
   WEnd
EndFunc   ;==>MainLoop
MainLoop()

Func _AddEdit()
   Local $ID, $deftxt, $cols, $rows
   $ID = InputBox("ID", "Enter an ID for this Edit tag")
   If @error Then MainLoop()
   $deftxt = InputBox("Default Text", "Type in some default text for the edit control. Levae blank if none is wanted/needed.")
   If @error Then MainLoop()
   $cols = InputBox("Columns", "Enter the number of columns for the edit control")
   If @error Then MainLoop()
   $rows = InputBox("Rows", "Enter the number of rows for the edit control")
   If @error Then MainLoop()
   GUICtrlSetData($output, '<textarea name = "' & $ID & '" cols = "' & $cols & '" rows = "' & $rows & '">' & @CRLF, 1)
   GUICtrlSetData($output, $deftxt & @CRLF, 1)
   GUICtrlSetData($output, "</textarea><br>" & @CRLF, 1)
EndFunc   ;==>_AddEdit

Func _AddInput()
   Local $prompt
   $prompt = InputBox("Prompt", "Enter a prompt for the input control")
   If @error Then MainLoop()
   GUICtrlSetData($output, '<form>' & @CRLF & $prompt & '<input type="text">' & @CRLF, 1)
   GUICtrlSetData($output, "<br>" & @CRLF & "</form>", 1)
EndFunc   ;==>_AddInput

Func _AddCheckBox()
   Local $value, $text, $ID, $prompt, $i, $howmanychckboxes
   $prompt = InputBox("Prompt", "Enter the prompt for the checkboxes")
   If @error Then MainLoop()
   $howmanychckboxes = InputBox("How many?", "How many checkboxes will you want?")
   If @error Then MainLoop()
   $ID = InputBox("ID", "Enter an ID for the checkbox(es)")
   If @error Then MainLoop()
   GUICtrlSetData($output, "<form>" & @CRLF, 1)
   GUICtrlSetData($output, $prompt & "<br>" & @CRLF, 1)
   For $i = 1 To $howmanychckboxes
      $value = InputBox("Value#" & $i, "Enter the value for this checkbox (# " & $i & ")")
      If @error Then MainLoop()
      $text = InputBox("Text#" & $i, "Enter the text for the checkbox (# " & $i & ")")
      If @error Then MainLoop()
      GUICtrlSetData($output, @CRLF & '<input type = checkbox name = "' & $ID & '" value = "' & $value & '">' & $text & '<br>' & @CRLF, 1)
   Next
   GUICtrlSetData($output, "</form>" & @CRLF, 1)
EndFunc   ;==>_AddCheckBox


Func _AddMarquee()
   Local $message
   $message = InputBox("Message", "Enter the message to be played across the screen")
   If @error Then MainLoop()
   GUICtrlSetData($output, "<form>" & @CRLF & "<marquee>" & $message & "</marquee>" & @CRLF & "</form>" & @CRLF, 1)
EndFunc   ;==>_AddMarquee

Func _WrapItUp()
   Local $save, $msg
   GUICtrlSetData($output, "</BODY>" & @CRLF & "</HTML>" & @CRLF, 1)
   $save = FileSaveDialog("Save HTML Output", @DesktopDir, "HTML(*.html)", 16, "HTMLDoc")
   If @error Then
      MainLoop()
   Else
      FileWrite($save & ".html", GUICtrlRead($output))
      SplashTextOn("Saved", "HTML Output saved to file '" & $save & ".html'", 500, 200)
      Sleep(2000)
      SplashOff()
   EndIf
EndFunc   ;==>_WrapItUp

Func _AddButton()
   Local $text
   $text = InputBox("Name", "Enter the text to appear on the button")
   If @error Then MainLoop()
   GUICtrlSetData($output, "<form>" & @CRLF & '<input type="button" value="' & $text & '">' & @CRLF & "</form>" & @CRLF, 1)
EndFunc   ;==>_AddButton

Func _AddRadio()
   Local $value, $text, $ID, $prompt, $i, $howmanyradios
   $prompt = InputBox("Prompt", "Enter the prompt for the radio boxes")
   If @error Then MainLoop()
   $howmanyradios = InputBox("How many?", "How many radios will you want?")
   If @error Then MainLoop()
   $ID = InputBox("ID", "Enter an ID for the radio(s)")
   If @error Then MainLoop()
   GUICtrlSetData($output, "<form>" & @CRLF, 1)
   GUICtrlSetData($output, $prompt & "<br>" & @CRLF, 1)
   For $i = 1 To $howmanyradios
      $value = InputBox("Value#" & $i, "Enter the value for this radio (# " & $i & ")")
      If @error Then MainLoop()
      $text = InputBox("Text#" & $i, "Enter the text for the radio (# " & $i & ")")
      If @error Then MainLoop()
      GUICtrlSetData($output, @CRLF & '<input type = radio name = "' & $ID & '" value = "' & $value & '">' & $text & '<br>' & @CRLF, 1)
   Next
   GUICtrlSetData($output, "</form>" & @CRLF, 1)
EndFunc   ;==>_AddRadio

Func _AddText()
   Local $text
   $text = InputBox("Text", "Enter the text you want to appear")
   If @error Then MainLoop()
   GUICtrlSetData($output, $text, 1)
EndFunc   ;==>_AddText

Func _AddPic()
   Local $src
   $src = InputBox("Pic source", "Enter the source of the picture to use")
   If @error Then MainLoop()
   GUICtrlSetData($output, '<img src = "' & $src & '">', 1)
EndFunc   ;==>_AddPic

Func _AddMsgBox()
   Local $msg
   $msg = InputBox("Message", "Enter the message to appear in the messagebox")
   If @error Then MainLoop()
   GUICtrlSetData($output, '<script language = "javascript">' & @CRLF & 'alert("' & $msg & '")' & @CRLF & '</script>' & @CRLF, 1)
EndFunc   ;==>_AddMsgBox

Func _SetHardCodeStyle()
   If GUICtrlRead($hardcode) = $GUI_CHECKED Then
      GUICtrlSendMsg($output, 207, 0, 0)
   Else
      GUICtrlSendMsg($output, 207, 1, 1)
   EndIf
EndFunc   ;==>_SetHardCodeStyle

Func _OpenHTML()
   Local $open
   $open = FileOpenDialog("Open...", @DesktopDir, "HTML (*.html)")
   If @error Then MainLoop()
   If Not FileExists($open) Then
      MsgBox(16, "Error!", "Error! The specified file path doesn't exist!")
   Else
      GUICtrlSetData($output, "", "")
      GUICtrlSetData($output, FileRead($open, FileGetSize($open)), 1)
   EndIf
EndFunc   ;==>_OpenHTML

Func _AddParagraph()
	If GuiCtrlRead ( $ParagraphCtrl ) = "Paragraph" Then
		GUICtrlSetData($output, "<p>", 1)
		GUICtrlSetData($ParagraphCtrl, "Paragraph" & @CRLF )
	Else
		GUICtrlSetData($output, "</p>", 1)
		GUICtrlSetData($ParagraphCtrl, "Paragraph" )
	EndIf
EndFunc