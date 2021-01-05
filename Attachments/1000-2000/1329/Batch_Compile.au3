; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Josh McPherron aka Kerberuz @ http://www.autoitscript.com/forum/index.php?
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>

Dim $Enable_Button2, $Enable_Button3

GUICreate("Script Batch Compile tool", 260, 140)

; Create the controls
$button_1 = GUICtrlCreateButton("Compile", 30, 20, 60, 40, $BS_FLAT)
$button_2 = GUICtrlCreateButton("Script Dir", 110, 20, 120, 40, $BS_FLAT)
$button_3 = GUICtrlCreateButton("Aut2Exe Dir", 110, 80, 120, 40, $BS_FLAT)

$Script_Dir = IniRead(@WorkingDir & "\Script.ini", "settings", "SCRIPT_DIR", "FAIL")
If $Script_Dir = "FAIL" Then
   
   MsgBox(4096, "Error", "Select a script directory.")
   
   GUICtrlSetState($button_1, $GUI_DISABLE)
   
Else
   
   $Enable_Button2 = 1
   
EndIf

$AutoIt_Dir = IniRead(@WorkingDir & "\Script.ini", "settings", "AUTOIT_DIR", "FAIL")
If $AutoIt_Dir = "FAIL" Then
   
   MsgBox(4096, "Error", "Select the Aut2Exe.")
   
   GUICtrlSetState($button_1, $GUI_DISABLE)
   
Else
   
   $Enable_Button3 = 1
   
EndIf

; Show the GUI
GUISetState()

; In this message loop we use variables to keep track of changes to the radios, another
; way would be to use GUICtrlRead() at the end to read in the state of each control
While 1
   $msg = GUIGetMsg()
   Select
      
      Case $msg = $GUI_EVENT_CLOSE
         Exit
         
      Case $msg = $button_1
         ; Compiles all au3 scripts in the current directory
         $search = FileFindFirstFile($Script_Dir & "\*.au3")
         
         ; Check if the search was successful
         If $search = -1 Then
            MsgBox(0, "Error", "No files/directories matched the search pattern")
            Exit
         EndIf
         
         While 1
            $file = FileFindNextFile($search)
            
            If @error Then ExitLoop
            ; MsgBox(4096, "File:", $AutoIt_Dir & "\Aut2exe.exe /in """ & $Script_Dir & "\" & $file & "") ; Enable for troubleshooting
            RunWait($AutoIt_Dir & "\Aut2exe.exe /in """ & $Script_Dir & "\" & $file & "")
            
         WEnd
         
         ; Close the search handle
         FileClose($search)
         
      Case $msg = $button_2
         $Script_Dir = FileSelectFolder("Select AQUA directory", "", 2)
         
         If @error Then
            MsgBox(4096, "I/O Error", "Directory not written")
         Else
            IniWrite(@WorkingDir & "\Script.ini", "settings", "SCRIPT_DIR", $Script_Dir)
            $Enable_Button2 = 1
            
            If $Enable_Button2 = $Enable_Button3 Then
               GUICtrlSetState($button_1, $GUI_ENABLE)
            EndIf
            
         EndIf
         
      Case $msg = $button_3
         $AutoIt_Dir = FileSelectFolder("Select AQUA directory", "", 2)
         
         If @error Then
            MsgBox(4096, "I/O Error", "Directory not written")
         Else
            IniWrite(@WorkingDir & "\Script.ini", "settings", "AUTOIT_DIR", $AutoIt_Dir)
            $Enable_Button3 = 1
            
            If $Enable_Button2 = $Enable_Button3 Then
               GUICtrlSetState($button_1, $GUI_ENABLE)
            EndIf
            
         EndIf
         
   EndSelect
WEnd