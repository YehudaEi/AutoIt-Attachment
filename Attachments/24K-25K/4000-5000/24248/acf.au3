; auto coppy
; a script that auto runs and coppy's my foto's
; from my memory stick or sd card to the dir i entered
; specificly per computer.

$dir = @ScriptDir & "\"
$pcname = @ComputerName
$source = "?"
$destination = "?"
if FileExists($dir & "settings.ini") = 0 then 
	call("user_create")
Else
	call("user_read")
EndIf

;traytip( "pc name","pc name is: " & $pcname, 29)
;sleep(5000)

if DirGetSize($dir & $source) = -1 Then
MsgBox(0,"File error", "there are no foto's on this device",50)
Else
FileCopy($dir & $source &"\*.jpg", $destination)
dircreate($destination & "\org\")
Filemove($dir & $source &"\*.jpg", $destination & "\org\")
MsgBox(0,"done", "foto's are coppied",50)
EndIf

func user_create()
$destination = inputbox("path to copy to", "please enter path to copy the foto's to")
IniWrite($dir & "settings.ini", $pcname, "Path->", $destination)
$source = InputBox("source folder", "please enter the source folder from wich to copy the foto's","?")
IniWrite($dir & "settings.ini", $pcname, "Path<-", $dir&$source)
EndFunc

func user_read()
$destination = IniRead($dir & "settings.ini", $pcname, "Path->",  "?")
	$source = IniRead($dir & "settings.ini", $pcname, "Path<-", "?")
	if $destination = "?" Then call("user_create")	
EndFunc

; check if file exists
; compare computernames for settings
; when name doesn't come thru 
