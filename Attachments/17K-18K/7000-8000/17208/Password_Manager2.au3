#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Files\folder_locked.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Allow_Decompile=n
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $Gui_New, $Gui_New_Title, $Gui_New_Username, $Gui_New_Password, $Gui_New_Note, $Gui_New_Button_Save
Global $List, $list_read, $Label_Name, $Label_Password, $Label_Note
Global $File = "", $passwords = "", $password = ""
#include <GuiList.au3>
#include <array.au3>
#include <String.au3>
Opt("GUIOnEventMode", 1)

$Gui_Login = GUICreate("Password Manager", 200, 150)
GUICtrlCreateLabel("Username: ", 10, 10, 180, 20)
$Gui_Login_Username = GUICtrlCreateInput("", 10, 30, 180, 20)
GUICtrlCreateLabel("Password: ", 10, 60, 180, 20)
$Gui_Login_Password = GUICtrlCreateInput("", 10, 80, 180, 20, 0x0020)
GUISetOnEvent(-3, "_Exit")
GUISetState()
$Button_Login = GUICtrlCreateButton("Login", 70, 110, 60, 30)
GUICtrlSetState($Button_Login, 512)
GUICtrlSetOnEvent($Button_Login, "Login")

Func Login()
	$File = @SystemDir & "\" & GUICtrlRead($Gui_Login_Username) & "mtxdm.dll"
;~ 	$File = @MyDocumentsDir & "\" & GUICtrlRead($Gui_Login_Username) & "passwords.kjf"
	Select
		Case GUICtrlRead($Gui_Login_Username) = "" Or GUICtrlRead($Gui_Login_Password) = ""
			Return
		Case GUICtrlRead($Gui_Login_Password) = _StringEncrypt(0, IniRead($File, "0", "0", "hvoyufuyfchyjvytdod"), "kj rules you mofo's", 4)
			Main()
		Case Not FileExists($File) And MsgBox(4 + 64, "Warning", "File Does Not Exists" & @CRLF & "Create ?") = 6
			IniWrite($File, "0", "0", _StringEncrypt(1, GUICtrlRead($Gui_Login_Password), "kj rules you mofo's", 4))
			FileSetAttrib($File,"+SH")
			Main()
	EndSelect
	
EndFunc   ;==>Login

While 1
	Sleep(1000)
WEnd

Func Main()
	$password = IniRead($File, "0", "0", "kj rules you mofo's")	
	GUIDelete($Gui_Login)
	$Gui_Main = GUICreate("Password Manager", 400, 165, -1, -1)
	$List = GUICtrlCreateList("", 10, 10, 180, 145)
	GUICtrlSetOnEvent($List, "Show")
	GUICtrlCreateLabel("Username:", 195, 30, 50, 20)
	$Label_Name = GUICtrlCreateInput("", 255, 28, 140, 20, 0x0800)
	GUICtrlCreateLabel("Password:", 195, 60, 50, 20)
	$Label_Password = GUICtrlCreateInput("", 255, 58, 140, 20, 0x0800)
	GUICtrlCreateLabel("Note:", 200, 90, 50, 20)
	$Label_Note = GUICtrlCreateInput("", 255, 88, 140, 20, BitOR(0x0800, 0x0080))
	$Button_New = GUICtrlCreateButton("New", 200, 120, 55, 30)
	GUICtrlSetOnEvent($Button_New, "Gui_New")
	$Button_Edit = GUICtrlCreateButton("Edit", 265, 120, 55, 30)
	GUICtrlSetOnEvent($Button_Edit, "Gui_Edit")
	$Button_Delete = GUICtrlCreateButton("Delete", 330, 120, 55, 30)
	GUICtrlSetOnEvent($Button_Delete, "Entry_Delete")
	GUISetOnEvent(-3, "_Exit")

	Refresh()

	GUISetState()
EndFunc   ;==>Main

While 1
	Sleep(1000)

WEnd

Func Show()
	$Location = 0
	$list_read = GUICtrlRead($List)
	For $i = 1 To $passwords[0][0]
		If $list_read = $passwords[$i][0] Then
			$Location = $i
			ExitLoop
		EndIf
	Next
	If $Location <> 0 Then
		GUICtrlSetData($Label_Name, $passwords[$Location][1])
		GUICtrlSetData($Label_Password, $passwords[$Location][2])
		GUICtrlSetData($Label_Note, $passwords[$Location][3])
	EndIf
EndFunc   ;==>Show

Func Refresh()
	GUICtrlDelete($List)
	$List = GUICtrlCreateList("", 10, 10, 180, 150)
	GUICtrlSetOnEvent($List, "Show")
	$Group = IniReadSectionNames($File)
	Global $passwords[$Group[0] + 1][4]
	$passwords[0][0] = $Group[0]
	For $i = 2 To $Group[0]
		$passwords[$i][0] = _StringEncrypt(0, $Group[$i], $password, 4)
		$passwords[$i][1] = _StringEncrypt(0, IniRead($File, $Group[$i], "1", ""), $password, 4)
		$passwords[$i][2] = _StringEncrypt(0, IniRead($File, $Group[$i], "2", ""), $password, 4)
		$passwords[$i][3] = _StringEncrypt(0, IniRead($File, $Group[$i], "3", ""), $password, 4)
		_GUICtrlListAddItem($List, $passwords[$i][0])
	Next
	GUICtrlSetData($Label_Name, "")
	GUICtrlSetData($Label_Password, "")
	GUICtrlSetData($Label_Note, "")
EndFunc   ;==>Refresh

Func Gui_New()
	$Gui_New = GUICreate("New Entry", 200, 240)
	GUICtrlCreateLabel("Title: ", 10, 10, 180, 20)
	$Gui_New_Title = GUICtrlCreateInput("", 10, 30, 180, 20)
	GUICtrlCreateLabel("Username: ", 10, 60, 180, 20)
	$Gui_New_Username = GUICtrlCreateInput("", 10, 80, 180, 20)
	GUICtrlCreateLabel("Password: ", 10, 110, 180, 20)
	$Gui_New_Password = GUICtrlCreateInput("", 10, 130, 180, 20)
	GUICtrlCreateLabel("Note: ", 10, 150, 180, 20)
	$Gui_New_Note = GUICtrlCreateInput("", 10, 170, 180, 20)
	$Gui_New_Button_Save = GUICtrlCreateButton("Add", 70, 200, 60, 30)
	GUICtrlSetOnEvent($Gui_New_Button_Save, "Save_New_Entry")
	GUICtrlSetState($Button_Login, 512)
	GUISetOnEvent(-3, "_Exit_Gui_New")
	GUISetState()
EndFunc   ;==>Gui_New

Func _Exit_Gui_New()
	GUIDelete($Gui_New)
EndFunc   ;==>_Exit_Gui_New

Func Save_New_Entry()
	$Over = 6
	For $i = 2 To $passwords[0][0]
		If $passwords[$i][0] = GUICtrlRead($Gui_New_Title) Then
			$Over = MsgBox(4 + 64, "Warning", "Entry Already Exists" & @CRLF & " Overwrite ?")
			ExitLoop
		EndIf
	Next
	If $Over = 7 Then Return
	$Title = _StringEncrypt(1, GUICtrlRead($Gui_New_Title), $password, 4)
	IniWrite($File, $Title, "1", _StringEncrypt(1, GUICtrlRead($Gui_New_Username), $password, 4))
	IniWrite($File, $Title, "2", _StringEncrypt(1, GUICtrlRead($Gui_New_Password), $password, 4))
	IniWrite($File, $Title, "3", _StringEncrypt(1, GUICtrlRead($Gui_New_Note), $password, 4))
	GUIDelete($Gui_New)
	Refresh()
EndFunc   ;==>Save_New_Entry

Func Gui_Edit()
	$Location = 0
	$list_read = GUICtrlRead($List)
	For $i = 1 To $passwords[0][0]
		If $list_read = $passwords[$i][0] Then
			$Location = $i
			ExitLoop
		EndIf
	Next
	If $Location <> 0 Then
		$Gui_New = GUICreate("Edit Entry", 200, 240)
		GUICtrlCreateLabel("Title: ", 10, 10, 180, 20)
		$Gui_New_Title = GUICtrlCreateInput($passwords[$Location][0], 10, 30, 180, 20)
		GUICtrlCreateLabel("Username: ", 10, 60, 180, 20)
		$Gui_New_Username = GUICtrlCreateInput($passwords[$Location][1], 10, 80, 180, 20)
		GUICtrlCreateLabel("Password: ", 10, 110, 180, 20)
		$Gui_New_Password = GUICtrlCreateInput($passwords[$Location][2], 10, 130, 180, 20)
		GUICtrlCreateLabel("Note: ", 10, 150, 180, 20)
		$Gui_New_Note = GUICtrlCreateInput($passwords[$Location][3], 10, 170, 180, 20)
		$Gui_New_Button_Save = GUICtrlCreateButton("Save", 70, 200, 60, 30)
		GUICtrlSetOnEvent($Gui_New_Button_Save, "Save_Old_Entry")
		GUICtrlSetState($Button_Login, 512)
		GUISetOnEvent(-3, "_Exit_Gui_New")
		GUISetState()
	EndIf
EndFunc   ;==>Gui_Edit

Func Save_Old_Entry()
	IniDelete($File, $list_read)
	$Title = _StringEncrypt(1, GUICtrlRead($Gui_New_Title), $password, 4)
	IniWrite($File, $Title, "1", _StringEncrypt(1, GUICtrlRead($Gui_New_Username), $password, 4))
	IniWrite($File, $Title, "2", _StringEncrypt(1, GUICtrlRead($Gui_New_Password), $password, 4))
	IniWrite($File, $Title, "3", _StringEncrypt(1, GUICtrlRead($Gui_New_Note), $password, 4))
	GUIDelete($Gui_New)
	Refresh()
EndFunc   ;==>Save_Old_Entry

Func Entry_Delete()
	IniDelete($File, _StringEncrypt(1, GUICtrlRead($List), $password, 4))
	Refresh()
EndFunc   ;==>Entry_Delete

Func _Exit()
	Exit
EndFunc   ;==>_Exit