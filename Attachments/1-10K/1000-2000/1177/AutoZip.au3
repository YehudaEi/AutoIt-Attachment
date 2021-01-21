; ----------------------------------------------------------------------------
; Includes
; ----------------------------------------------------------------------------
#include <file.au3>
#Include <string.au3>

; ----------------------------------------------------------------------------
; Script
; ----------------------------------------------------------------------------

#include <GuiConstants.au3>
#notrayicon

GuiCreate("AutoZip", 201, 80 )

$FileName = GuiCtrlCreateInput("File to compress", 0, 0, 200, 20)
$Browse = GuiCtrlCreateButton("Browse...", 0, 20, 126, 20)
$Quit = GuiCtrlCreateButton("Quit", 100, 40, 100, 40)
$Start = GuiCtrlCreateButton("Start", 0, 40, 100, 40)
$decompress = GUICtrlCreateCheckbox ( "Decompress", 127, 20 )
$loading = GUICtrlCreateLabel ( "", 30, 30, 170, 60 )
GUICtrlSetState ( $loading, 32 )

GuiSetState()
While 1
	Sleep ( 10 )
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Browse
		$F1 = FileOpenDialog ( "Browse for a file to compress", "", "All Files (*.*)" )
		If $F1 = 1 Then $F1 = "File to compress"
		GUICtrlSetData ( $FileName, $F1 )
	Case $msg = $Quit
		ExitLoop
	Case $msg = $Start
		If GUICtrlRead ( $decompress ) = $GUI_UNCHECKED Then
			$f2 = GuiCtrlRead ( $FileName )
			$out = $f2 & ".caz"
			$in = GUICtrlRead ( $FileName )
			GUICtrlSetState ( $FileName, 32 )
			GUICtrlSetState ( $Browse, 32 )
			GuiCtrlSetState ( $Quit, 32 )
			GUICtrlSetState ( $Start, 32 )
			GUICtrlSetState ( $loading, 16 )
			AutoZip ( $in, $out )
			GUICtrlSetState ( $FileName, 16 )
			GUICtrlSetState ( $Browse, 16 )
			GuiCtrlSetState ( $Quit, 16 )
			GUICtrlSetState ( $Start, 16 )
			GUICtrlSetState ( $loading, 32 )
		ElseIf GUICtrlRead ( $decompress ) = $GUI_CHECKED Then
			$out = StringTrimRight ( GuiCtrlRead ( $FileName ), 4 )
			$in = GUICtrlRead ( $FileName )
			GUICtrlSetState ( $FileName, 32 )
			GUICtrlSetState ( $Browse, 32 )
			GuiCtrlSetState ( $Quit, 32 )
			GUICtrlSetState ( $Start, 32 )
			GUICtrlSetState ( $loading, 16 )
			AutoUnZip ( $in, $out )
			GUICtrlSetState ( $FileName, 16 )
			GUICtrlSetState ( $Browse, 16 )
			GuiCtrlSetState ( $Quit, 16 )
			GUICtrlSetState ( $Start, 16 )
			GUICtrlSetState ( $loading, 32 )
		EndIf
	EndSelect
WEnd
Exit

; ----------------------------------------------------------------------------
; Functions
; ----------------------------------------------------------------------------
Func AutoZip($arg1, $arg2)
   $oldtime = TimerInit()
   
   $readfile = FileOpen($arg1, 0)
   $writefile = FileOpen($arg2, 2)
   $linesyet = 0
   $letters = 0
   $numbers = 0
   
   If $readfile = -1 Or $writefile = -1 Then
      MsgBox(0, "Error", "Unable to open file(s)." & @CRLF & "Pressing OK will exit." )
	  Exit
   EndIf
   
   $CountedLines = _FileCountLines ($arg1)
   GUICtrlSetData ( $loading, "Compressing... 0 %" )
   
   While 1
      $line = FileReadLine($readfile)
      If @error = -1 Then ExitLoop
      $len = StringLen($line)
      For $letters = 97 to 122
         If StringInStr($line, Chr($letters)) Then
            $letters = 1
            ExitLoop
         EndIf
      Next
      For $numbers = 48 to 57
         If StringInStr($line, Chr($numbers)) Then
            $numbers = 1
            ExitLoop
         EndIf
      Next
      If $numbers = 1 Then
         For $char2check = 48 To 57
            If StringInStr($line, Chr($char2check), 1) Then
                  If _StringRepeat(Chr($char2check), $len) == $line Then
                     $line = $len & "{" & Chr($char2check) & "}"
                  EndIf
            EndIf
         Next
      EndIf
      If $letters = 1 Then
         For $char2check = 65 To 90
            If StringInStr($line, Chr($char2check), 1) Then
                  If _StringRepeat(Chr($char2check), $len) == $line Then
                     $line = $len & "{" & Chr($char2check) & "}"
                  EndIf
            EndIf
         Next
         For $char2check = 97 To 122
            If StringInStr($line, Chr($char2check), 1) Then
                  If _StringRepeat(Chr($char2check), $len) == $line Then
                     $line = $len & "{" & Chr($char2check) & "}"
                  EndIf
            EndIf
         Next
      EndIf
      FileWriteLine($writefile, $line)
      $linesyet = $linesyet + 1
      $percent = $linesyet / $CountedLines
      $percent = $percent * 100
      GUICtrlSetData ( $loading, "Compressing..." & Round($percent, 2) & "%")
   Wend
   
   FileClose($readfile)
   FileClose($writefile)
   
   $readfilesize = FileGetSize($arg1)
   $writefilesize = FileGetSize($arg2)
   
   $timeneeded = TimerDiff($oldtime)
   MsgBox(0, "AutoZip: done!", "Needed " & Round($timeneeded / 1000, 0) & " seconds to compress " & $readfilesize & " Bytes to " & $writefilesize & " Bytes!" & @CR &_
             "Compressed file is " & 100 - Round(($writefilesize / $readfilesize) * 100, 2) & "% smaller than original file!" & @CR &_
             "Compressed " & Round($CountedLines / ($timeneeded / 1000), 2) & " lines per second!")
	EndFunc ;==>AutoZip
		 
Func AutoUnZip($arg1, $arg2)  
   $oldtime = TimerInit()

   $readfile = FileOpen($arg1, 0)
   $writefile = FileOpen($arg2, 2)
   $linesyet = 0
  
   If $readfile = -1 Or $writefile = -1 Then
      MsgBox(0, "Error", "Unable to open file(s)." & @CRLF & "Pressing OK will exit." )
      Exit
   EndIf
   
   $CountedLines = _FileCountLines ($arg1)
   GUICtrlSetData ( $loading, "Decompressing... 0%" )
   
   While 1
      $line = FileReadLine($readfile)
      If @error = -1 Then ExitLoop
      If StringInStr($line, "{") AND StringInStr($line, "}") Then
         For $i = 1 to 10
            If StringIsDigit(StringLeft($line, $i)) <> 1 Then
               If StringMid($line, $i, 1) = "{" And StringMid($line, $i + 2, 1) = "}" Then
                  $char2repeat = StringMid($line, $i+1, 1)
                  $times2repeat= StringMid($line, 1, $i-1)
                  FileWriteLine($writefile, _StringRepeat($char2repeat, $times2repeat))
                  ExitLoop
               EndIf
            EndIf
            If $i = 10 Then
               FileWriteLine($writefile, $line)
            EndIf
         Next
      EndIf
      $linesyet = $linesyet + 1
      $percent = $linesyet / $CountedLines
      $percent = $percent * 100
      GUICtrlSetData ( $loading, "Deompressing..." & Round($percent, 2) & "%" )
   Wend
   
   FileClose($readfile)
   FileClose($writefile)
   
   $readfilesize = FileGetSize($arg1)
   $writefilesize = FileGetSize($arg2)
   
   $timeneeded = TimerDiff($oldtime)
   MsgBox(0, "AutoUnZip: done!", "Needed " & Round($timeneeded / 1000, 0) & " seconds to decompress " & $readfilesize & " Bytes to " & $writefilesize & " Bytes!" & @CR &_
             "Decompressed file is " & 100 - Round(($readfilesize / $writefilesize) * 100, 2) & "% bigger than original file!" & @CR &_
             "Decompressed " & Round($CountedLines / ($timeneeded / 1000), 2) & " lines per second!")
EndFunc