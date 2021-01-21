; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Language: English
; Platform: WindowsXP
;
; Script Function: Creates GUI frontend for Sysinternal PSEXEC tool.
; ----------------------------------------------------------------------------


#include <GUIConstants.au3>

Opt("GUICoordMode", 1)
Opt("ColorMode",1)
Opt("RunErrorsFatal", 1)
Opt("TrayIconHide", 1)

; Start GUI creation
GuiCreate("Remote Install", 380, 350)
$Iconfile = @SystemDir & "\icon.ico"
FileInstall("C:\icon.ico", $Iconfile, 1)
GUISetIcon ($Iconfile)
GUISetState ()

$destination = @SystemDir & "\psexec.exe"
FileInstall("C:\psexec.exe", $destination, 1)

$readme = @SystemDir & "\RemoteExecute.txt"
FileInstall("C:\RemoteExecute.txt", $readme, 1)

$PCLog = FileOpen(@scriptDir & "\executeLog.txt", 1)
$font="Arial Bold"
$helpmenu = GuiCtrlCreateMenu ("Info")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)
$helpitem = GuiCtrlCreateMenuitem ("Help",$helpmenu)
$exititem = GuiCtrlCreateMenuitem ("Exit",$helpmenu)

Opt("GuiCoordMode", 2)
$usernamelbl = GuiCtrlCreateLabel("Username (Domain\Username)", 10, 20, 170, 20)
$username = GuiCtrlCreateInput("", -1, 0, 140, 20)
$passwordlbl = GuiCtrlCreateLabel("Password", -1, 0, 140, 20)
$password = GuiCtrlCreateInput("", -1, 0, 140, 20, 0x0020)
Opt("GuiCoordMode", 0)

Opt("GuiCoordMode", 1)
$filelbl = GuiCtrlCreateLabel("Select file to execute", 240, 20, 100, 20)
$filebutton = GuiCtrlCreateButton("Browse", 240, 40, 100, 20)
$Proglbl = GuiCtrlCreateLabel("Remote Installation Tool", 170, 80, 220, 20)
GUICtrlSetFont($Proglbl,12, 400, $font, 4)

$Runlbl = GuiCtrlCreateLabel("Execute against machines", 10, 220, 140, 20)
$Runbutton = GuiCtrlCreateButton("Run", 10, 240, 100, 20)
$Cancelbutton = GuiCtrlCreateButton("Quit", 240, 240, 100, 20)



$var = ""
$line = ""
$passwrd = ""
$line = ""
$usrname = ""
;$execute = ('"' & @SystemDir & '\psexec.exe"')



$bLoop = 1
While $bLoop = 1
$msg = GuiGetMsg()
Select
Case $msg = -3
Exit

Case $msg = $filebutton
If GUICtrlRead($username) = "" Then
MsgBox(0, "Error", "you must enter a username.")
FileWriteLine($PCLog, "Error: Username not entered " & " Time: " & @hour & @Min & " Date: " & @MON & "/" & @MDAY & "/" & @YEAR & " By: " & @username & " From machine: " & @ComputerName)
ElseIf GUICtrlRead($Password) = "" Then
MsgBox(0, "Error", "you must enter a password.")
FileWriteLine($PCLog, "Error: Password not entered " & " Time: " & @hour & @Min & " Date: " & @MON & "/" & @MDAY & "/" & @YEAR & " By: " & @username & " From machine: " & @ComputerName)
Else
$var = FileOpenDialog("Select file", @ScriptDir, "Executables (*.exe;*.msi;*.vbs;*.hta)", 1)
$chosen = ('"' & $var & '"')
;$fullpcname = GUIRead($combo_1)
;$password = GUIRead($passwd)
;$usrname = GUIRead($username)
$bLoop = 1
;EndIf

EndIf

Case $msg = $Cancelbutton
FileWriteLine($PCLog, "User cancelled application " & " Time: " & @hour & @Min & " Date: " & @MON & "/" & @MDAY & "/" & @YEAR & " By: " & @username & " From machine: " & @ComputerName)
Exit

Case $msg = $Runbutton
$PCfile = FileOpen(@scriptDir & "\computers.txt", 0)
If $PCfile = -1 Then
MsgBox(0, "Error", "Unable to locate computers.txt file.")
FileWriteLine($PCLog, "computers.txt file not found " & " Time: " & @hour & @Min & " Date: " & @MON & "/" & @MDAY & "/" & @YEAR & " By: " & @username & " From machine: " & @ComputerName)
ElseIf $Var = "" Then
MsgBox(0, "Error", "Please select an executable.")
Else
$line = FileReadLine($PCfile)
$passwrd = GUICtrlRead($password)
$usrname = GUICtrlRead($username) 
$PathInfo = ('psexec @"' & @ScriptDir & '\computers.txt"' & " -u " & $usrname & " -p " & $passwrd & " -s -i -c " & $chosen & " -f -d 2>" & '"' & @ScriptDir & "\results.log")
MsgBox(0, "Executing", "Executing command on machines listed in computers.txt", 5)
Run(@comspec & " /c " & $PathInfo, "", @SW_HIDE)
FileWriteLine($PCLog, "Command " & $chosen & " executed successfully on : " & $line & " Time: " & @hour & @Min & " Date: " & @MON & "/" & @MDAY & "/" & @YEAR & " By: " & @username & " From machine: " & @ComputerName)
FileClose($PCfile)
MsgBox(0, "Completed", "Command executed against all listed machine names in computers.txt file.")
Exit
EndIF
Case $msg = $aboutitem
Msgbox(0,"About","Remote Installation Tool" & @CRLF & " Version 1.0" & @CRLF & "Created by NJDEV1K" & @CRLF & "Blah")

Case $msg = $helpitem
Run("notepad.exe " & @SystemDir & "\remoteexecute.txt" , @WindowsDir)

Case $msg = $exititem
Exit

EndSelect
WEnd

