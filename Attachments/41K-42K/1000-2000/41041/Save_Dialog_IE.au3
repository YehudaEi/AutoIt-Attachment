;--------------------------------------------------------------------
;~ Save_Dialog_IE.au3
;~ Purpose: To handle the Dowload/save Dialogbox in Internet Explorer
;~ Usage: Save_Dialog_IE.exe "Dialog Title" "Opetaion" "Path"
;~ Create By: Gaurang Shah
;~ Email: gaurangnshah@gmail.com
;--------------------------------------------------------------------

AutoItSetOption("WinTitleMatchMode","2") ; set the select mode to select using substring

if $CmdLine[0] < 2 then
; Arguments are not enough
msgbox(0,"Error","Supply all the arguments, Dialog title,Run/Save/Cancel and Path to save(optional)")
Exit
EndIf

; wait Until dialog box appears
WinWait($CmdLine[1]) ; match the window with substring
$title = WinGetTitle($CmdLine[1]) ; retrives whole window title
WinActivate($title)

If (StringCompare($CmdLine[2],"Run",0) = 0) Then
WinActivate($title)
ControlClick($title,"","Button1")
EndIf

If (StringCompare($CmdLine[2],"Save",0) = 0) Then

WinWaitActive($title)
ControlClick($title,"","Button2")
; Wait for the new dialogbox to open
Sleep(2)
WinWait("Save")
$title = WinGetTitle("Save")
;$title = WinGetTitle("[active]")
if($CmdLine[0] = 2) Then
;click on the save button
WinWaitActive($title)
ControlClick($title,"","Button2")
Else
;Set path and save file
WinWaitActive($title)
ControlSetText($title,"","Edit1",$CmdLine[3])
ControlClick($title,"","Button2")
EndIf

EndIf

If (StringCompare($CmdLine[2],"Cancel",0) = 0) Then
WinWaitActive($title)
ControlClick($title,"","Button3")
EndIf
