#include <GUIConstants.au3>
#include <Process.au3>
#include <file.au3>
#include <Array.au3>

$ParentWin = GUICreate("Bas-Cheq!", 250,130)
GUISetState(@SW_SHOW)
$selectfileBut = GUICtrlCreateButton("Select .Bas File",65,3, 100)

While 1
   $msg = GUIGetMsg(1)
  Select
      Case $msg[0] = $GUI_EVENT_CLOSE
           GUIDelete()
            Exit
      Case $msg[0] = $selectfileBut
      	   $basfile = FileOpenDialog("Select .bas file to be checked", "C:\Windows\", "Actuate Basic Files (*.bas)", 1)   
      	   If $basfile = -1 Then
	       MsgBox(0, "Error", "Unable to open file.")
	       Exit
	   EndIf
	   GUICtrlCreateInput ($basfile , 10,  35, 300, 20)
	   $match_pattern1 = "Module C:"
	   $match_pattern2 = "Includes C:"
	  
	  
	  While 1
	      $line = FileReadLine($basfile)
	      If @error = -1 Then ExitLoop
	      MsgBox(0, "Line read:", $line)
	  Wend
	  ;_FileReadToArray($basfile,$lines)
	   ;_ArrayDisplay ( $lines, "gbc" )

	   ;For $i = 1 To 10
	   ;    If StringInStr($lines[$i],$match_pattern1) or StringInStr($lines[$i],$match_pattern2)Then
	   ;        MsgBox(0, "Found", $lines[$i])
	   ;    EndIf
	   ;Next
    
   EndSelect
WEnd