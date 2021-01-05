;delete last listing
Filedelete("b.tmp")

;gets the computer list and a few other things
RunWait(@ComSpec & ' /c net view > a.tmp', @ScriptDir, @SW_HIDE)
;open the file for working
$file = FileOpen("a.tmp", 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

;Creates new file in which the result will be written
FileOpen("b.tmp", 1)

; Read in lines of text until the EOF is reached in file a.tmp
While 1
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
    ;find the string "\\"
    $result = StringInStr($line,"\\")
      if $result = 1 Then 
       ;find next blank
      $blankpos = StringInStr($line," ")
      ;Find length of line
      $len = StringLen($line)
      ;calculate from what position to Trim string to the right
      $len = $len - $blankpos
      ;Trim all characters after the computer name
      $line = StringTrimRight($line, $len)
      ;Write line to file, adding "|"
      FileWrite("b.tmp", $line & "|")
      EndIf

 Wend

FileClose($file)
FileDelete("a.tmp")
$file2 = FileReadline("b.tmp", 1)

;GUI Start
#include "GUIConstants.au3"

;Set GUI
Opt("GUICoordMode", 1)
Opt("GUINotifyMode", 1)
GuiCreate("PC Comment", 329,145)

;Create 2 buttons
$button_1 = GUICtrlCreateButton("DO IT", 20, 100, 80, 20)
               GUICtrlSetState(-1,$GUI_DEFBUTTON)
$button_2 = GUICtrlCreateButton("E&xit", 230, 100, 80, 20)

;Create 1 combo box, give focus and populate with contents of b.tmp
$combo_1 = GUICtrlCreateCombo( "", 180, 10, 120, 20)
               GUICtrlSetState(-1,$GUI_FOCUS) 
               GUICtrlSetData(-1,$file2)
;Create 1 input box
$input_2 = GUICtrlCreateInput( "", 180, 60, 120, 20)
;create 2 labels
$label_1 = GUICtrlCreateLabel( "Enter The Computer name", 20, 10, 150, 20)
$label_2 = GUICtrlCreateLabel("Enter the Comment", 20, 60, 150, 20)

;Show the GUI
GuiSetState (@SW_SHOW)
$msg = 0
While $msg <> -3
$msg = GuiGetMsg()
Select
case $msg = $button_2
	Exit
case $msg = $button_1
	$CPUID = GuiRead($combo_1)
	$COMMENT = GuiRead($input_2)
	$test = RegWrite($CPUID &"\HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\lanmanserver\parameters", "srvcomment", "REG_SZ", $comment)
	if $test = 1 then 
	MsgBox(0, "Success", "The requested changes were made sucessfully" & @CR & "The result will show when " & $CPUID & " next reboots")
	Else
	MsgBox(0,"Failure", "Could not write to " & $CPUID & @CR & "The computer may be turned off")
	endif
	GUICtrlSetData ( $combo_1, $file2)
   GUICtrlSetData ( $input_2, "")
    EndSelect
WEnd

Exit
