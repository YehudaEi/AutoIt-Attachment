#include <GuiConstants.au3>
Opt("GuiOnEventMode",1)
Opt("RunErrorsFatal",0)
#NoTrayIcon

Dim $SHFile

FileInstall("ShellNew.jpg",@TempDir&"\ShellNew.jpg")
$win=GUICreate("Au3 ShellNew  <d3monTools>",500,490,-1,-1,$WS_CAPTION,BitOr($WS_EX_APPWINDOW,$WS_EX_TOOLWINDOW))
$SH=GUICtrlCreateLabel("ShellNew",-10,10,250,40)
GUICtrlSetFont(-1,20,400,2)
GUICtrlCreateGroup("Create au3 ShellNew",5,50,490,400)
GUICtrlSetFont(-1,10,400)
GUICtrlCreateLabel("1. Create your own au3 ShellNew.",15,70,450)
GUICtrlSetFont(-1,12,400)
GUICtrlCreatePic(@TempDir&"\ShellNew.jpg",15,90,0,0)
GUICtrlSetTip(-1,"au3 ShellNew script")
GUICtrlCreateLabel("2. Browse your au3 ShellNew.",270,95,450)
GUICtrlSetFont(-1,12,400)
GUICtrlCreateButton("Browse au3 ShellNew",270,115,205,25)
GuiCtrlSetOnEvent(-1,"_Browse")
GUICtrlSetFont(-2,12,400)
GUICtrlCreateLabel("3. Replace au3 ShellNew.",270,150,450)
GUICtrlSetFont(-1,12,400)
$ShellNew=GUICtrlCreateButton("Replace au3 ShellNew",270,170,205,25)
GuiCtrlSetOnEvent(-1,"_ShellNew")
GUICtrlSetState($ShellNew,$GUI_DISABLE)
GUICtrlSetFont($ShellNew,12,400)
GUICtrlCreateLabel("Backup au3 ShellNew.",270,205,450)
GUICtrlSetFont(-1,12,400)
GUICtrlCreateButton("BackUp au3 ShellNew",270,225,205,25)
GuiCtrlSetOnEvent(-1,"_BackUp")
GUICtrlSetFont(-2,12,400)
$log=GUICtrlCreateEdit("---ShellNew log---",15,260,470,170,$ES_MULTILINE+$ES_WANTRETURN+$ES_READONLY+$ES_AUTOVSCROLL)
GUICtrlSetFont(-1,10)
GUICtrlCreateButton("EXIT",10,460,235)
GuiCtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-2,10)
GUICtrlCreateButton("MINIMIZE",255,460,235)
GuiCtrlSetOnEvent(-1,"_MINIMIZE")
GUICtrlSetFont(-2,10)
GUISetState(@SW_SHOW,$win)


Func _Browse()
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&@CRLF&"--Browsing for ShellNew Script--")
$SHFile=FileOpenDialog("Browse your au3 ShellNew Script",@ScriptDir,"Autoit3 (*.au3)",1+2)

If @error Then
MsgBox(3096,"","No ShellNew Script choosen !")
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"No ShellNew Script choosen !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"ShellNew Script : "&$SHFile)
GUICtrlSetState($ShellNew,$GUI_ENABLE)
EndIf
EndFunc


Func _ShellNew()
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&@CRLF&"--Replace ShellNew File--")
FileMove(@WindowsDir&"\ShellNew\Template.au3",@WindowsDir&"\ShellNew\Template.au3.bak")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't rename Template Script File !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Template File Succesfully renamed !")
EndIf

FileCopy($SHFile,@WindowsDir&"\ShellNew\Template.au3")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't Copy ShellNew Script File !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"ShellNew File Succesfully copied !")
EndIf

RegDelete("HKEY_CLASSES_ROOT\.au3\ShellNew","FileName")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't Delete ""FileName"" registry key !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"FileName registry key Succesfully Deleted !")
EndIf

RegWrite("HKEY_CLASSES_ROOT\.au3\ShellNew","FileName","REG_SZ",@WindowsDir&"\ShellNew\Template.au3")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't write ""FileName"" registry Key !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"FileName registry key Succesfully wrote !")
EndIf
EndFunc

Func _BackUp()
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&@CRLF&"--BackUp ShellNew File--")
FileDelete(@WindowsDir&"\ShellNew\Template.au3")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't delete ShellNew Script File !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"ShellNew File Succesfully deleted !")
EndIf

FileMove(@WindowsDir&"\ShellNew\Template.au3.bak",@WindowsDir&"\ShellNew\Template.au3")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't rename Back Template Script File !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Back Template File Succesfully renamed !")
EndIf

RegDelete("HKEY_CLASSES_ROOT\.au3\ShellNew","FileName")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't Delete ""FileName"" registry key !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"FileName registry key Succesfully Deleted !")
EndIf

RegWrite("HKEY_CLASSES_ROOT\.au3\ShellNew","FileName","REG_SZ",@WindowsDir&"\ShellNew\Template.au3")
If @error Then
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Can't write ""FileName"" registry Key !")
Else
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"FileName registry key Succesfully wrote !")
EndIf
EndFunc

Func _MINIMIZE()
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"ShellNew window Minimized")
GUISetState(@SW_MINIMIZE,$win)
EndFunc

While 1
sleep(25)
For $MOVE=-10 to 510
ControlMove($win,"",$SH,$MOVE,10)
sleep(25)
Next
WEnd

Func _Exit()
GUICtrlSetData($log,GuiCtrlRead($log)&@CRLF&"Exiting ShellNew..."&@CRLF&"--End log--")
FileWrite(@ScriptDir&"\log.txt",@CRLF&@MDAY&"/"&@MON&"/"&@YEAR&@CRLF&GuiCtrlRead($log))
FileDelete(@TempDir&"\ShellNew.jpg")
Exit
EndFunc