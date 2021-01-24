; <AUT2EXE VERSION: 3.1.1.0>

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: M:\Downloads\Vidz\AutoGKAdd.au3>
; ----------------------------------------------------------------------------

AutoItSetOption("MouseCoordMode", 0) 		; Makes Mouse Coordinates relative to active Window
AutoItSetOption("RunErrorsFatal", 0)		; If Run command crashes don't quit the program
AutoItSetOption("WinDetectHiddenText", 1)	; For Folder Names

$Path="C:\Program Files\AutoGK\"
$EXE="AutoGK.EXE"
$AutoGKWinTitle="len0x presents:"

Select
  Case $CmdLine[0]=4			; 3 parameters, must be filesize/input/output
    $FileSize=$CmdLine[1]
    $InputFile=$CmdLine[2]
    $OutputFile=$CmdLine[3]
    $Priority=$CmdLine[4]

  Case Else
    MsgBox(48,"Error","Too Many or Too Few Parameters." & @CRLF & @CRLF & "USAGE: AutoGKAdd.exe filesize InputFile OutputFile Priority")
    Exit
EndSelect

If NOT FileExists($InputFile) Then
  MsgBox (48,"Error","Input File '" & $InputFile & "' Not Found!")	; No Input File
  Exit
EndIf

If Number($FileSize)=0 Then				; No Default or specified Filesize?
  MsgBox (48,"Error","No File Size Specified!")
  Exit
EndIf

$Pid=Run($Path & $EXE,$Path)				; Run AutoGK

If @error Then						; Couldn't Run?
  MsgBox(48,"Error","Can't find AutoGK.")
  Exit
EndIf

ProcessSetPriority($Pid,$Priority)			; Set Priority of AutoGK process
$state=WinGetState($AutoGKWinTitle)			; Minimized or Maximized currently?
If NOT BitAnd($state,2) OR BitAnd($state,16) Then	; Currently Not "Visible" or "Minimized"?
  WinSetState($AutoGKWinTitle,"",@SW_RESTORE)		; Restore it!
EndIf
WinActivate($AutoGKWinTitle)				; Make sure it's the active window
WinWaitActive($AutoGKWinTitle)				; Wait for it to become active

BlockInput(1)						; Don't Respond to User keypresses & Mouse

If StringRight($FileSize,1)="%" Then			; Percentage quality or File Size?
  ControlCommand($AutoGKWinTitle,"","Target quality (in percentage):","Check","")
  ControlSetText($AutoGKWinTitle,"","TJvSpinEdit1",StringTrimRight($FileSize,1))
Else
  ControlCommand($AutoGKWinTitle,"","Custom size (MB):","Check","") 	; Click the "Custom Size" Radio Button
  ControlSetText($AutoGKWinTitle,"","TJvSpinEdit2",$FileSize)		; Type in the Output File Size
EndIf

Send("^o")						; NEW - Open Input File Dialog
WinWaitActive("Open")					; Wait for the "Open" dialog
Sleep(200)						; Pause
ControlSetText("Open","","Edit1",$InputFile)		; Type in the Input filename
ControlClick("Open","","&Open")			        ; Click the "Open" Button

WinWaitActive($AutoGKWinTitle)			; Wait until Main window comes back
Send("^s")						; NEW - Open Save File Dialog
WinWaitActive("Save As")				; Wait for the "Save as" dialog
ControlSetText("Save As","","Edit1",$OutputFile)	; Type in the Output filename
ControlClick("Save As","","&Save")			; Click the "Save" Button

WinWaitActive($AutoGKWinTitle)				; Wait for the main window
Send("^a")						; NEW - Add job
BlockInput(0)						; And let the mouse/keybd go
Exit

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: M:\Downloads\Vidz\AutoGKAdd.au3>
; ----------------------------------------------------------------------------

