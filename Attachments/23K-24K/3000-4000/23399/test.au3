#include <Constants.au3>
;#include <InetFileUpdate.au3>
#include <Date.au3>
#include <GUIConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#AutoIt3Wrapper_Plugin_Funcs = MD5Hash

	FileInstall("MD5Hash.dll", @TempDir & "/hash.dll")
	HotKeySet("^!d", "scriptclose")
	Global $script = StringSplit(@ScriptName, ".")
	Global $mon = _DateToMonth(@MON, 1)
	Global $url = "                                "
	Global $upurl = "                                       "
	Global $Windowname = "PFCTN.com News Caster"
	Global $textfile = @TempDir & "/data.txt"
	Global $php_id = IniRead($script[1] & ".ini", "User", "username", "none")
	Global $php_pw = IniRead($script[1] & ".ini", "User", "userpass", "none")
	Global $Scriptname = "pfctn.exe"
	
  Opt("GUIOnEventMode", 1)
  Global $Form1 = GUICreate("Form1", 633, 473, 192, 124)
  GUISetOnEvent($GUI_EVENT_CLOSE,"scriptclose")
  Global $Tab1 = GUICtrlCreateTab(8, 32, 617, 411)
  GUICtrlSetResizing($Tab1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
  Global $TabSheet1 = GUICtrlCreateTabItem("Main")
  Global $Edit1 = GUICtrlCreateEdit("", 20, 121, 582, 276,$ES_AUTOVSCROLL+$ES_AUTOHSCROLL+$ES_READONLY)
  _GUICtrlEdit_SetText($Edit1,@CRLF & _
			"========================================================"& @CRLF & _
			"" & @CRLF & _
			"             Leave this Window Open it will look for new" & @CRLF & _
			"              messages posted by the admin every 30sec" & @CRLF & _
			"        It wont harm your internet or Computer`s speed in any way" & @CRLF & _
			"" & @CRLF & _
			"========================================================"& @CRLF & @CRLF)
  Global $Label5 = GUICtrlCreateLabel("We will recieve and post all messages here", 191, 85, 207, 17)
  Global $Button1 = GUICtrlCreateButton("Activate", 266, 406, 82, 25, 0)
  GUICtrlSetOnEvent($Button1, "getmsgs")
  Global $TabSheet2 = GUICtrlCreateTabItem("Settings")
  Global $Group1 = GUICtrlCreateGroup("Time Settings", 21, 70, 254, 134)
  Global $Label1 = GUICtrlCreateLabel("How often you want to check for new Messages", 37, 86, 233, 17)
  Global $Radio1 = GUICtrlCreateRadio("30 seconds", 37, 110, 113, 17)
  Global $Radio2 = GUICtrlCreateRadio("1 minute", 37, 134, 113, 17)
  Global $Radio3 = GUICtrlCreateRadio("2 minutes", 37, 158, 113, 17)
  Global $Radio4 = GUICtrlCreateRadio("5 minuutes", 37, 182, 113, 17)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $Group2 = GUICtrlCreateGroup("User Account Settings", 296, 70, 254, 135)
  Global $Label2 = GUICtrlCreateLabel("Please enter your username and password", 311, 86, 204, 17)
  Global $Input1 = GUICtrlCreateInput("", 391, 118, 121, 21)
  Global $Input2 = GUICtrlCreateInput("", 391, 150, 121, 21)
  Global $Label3 = GUICtrlCreateLabel("Username :", 311, 118, 58, 17)
  Global $Label4 = GUICtrlCreateLabel("Password :", 311, 150, 56, 17)
  GUICtrlCreateGroup("", -99, -99, 1, 1)
  Global $Button2 = GUICtrlCreateButton("Save Settings", 252, 238, 75, 25, 0)
  GUICtrlSetOnEvent($Button2, "savesettings")
  GUICtrlCreateTabItem("")
  Global $MenuItem1 = GUICtrlCreateMenu("File")
  Global $MenuItem2 = GUICtrlCreateMenuItem("Quit", $MenuItem1)
  GUICtrlSetOnEvent($MenuItem2, "scriptclose")
  Global $MenuItem3 = GUICtrlCreateMenuItem("Start", $MenuItem1)
  GUICtrlSetOnEvent($MenuItem3, "getmsgs")
  GUISetState(@SW_SHOW)
  
  Func getmsgs()
	  		$nExit= 1
	  While $nExit
		ToolTip("Inside function: Press CTRL+ALT+D for exit of 'While'")
		Sleep(100)
		$time = @HOUR & ":" & @MIN & ":" & @SEC
		$date = @MDAY & "." & $mon & "." & @YEAR
		$plH = PluginOpen(@TempDir & "/hash.dll")
		$pass = MD5Hash($php_pw, 2, True)
		InetGet($url & "getid.php?pass=" & $pass & "&user_id=" & $php_id, $textfile, 1, 0) ;gets the next command id from the mysql database
		$file = FileOpen($textfile, 0)
		$id = FileReadLine($file, 1)
		PluginClose($plH)
		FileClose($file)
		FileDelete($textfile)
		If (StringIsInt($id)) Then
			InetGet($url & "unset.php?user_id=" & $php_id & "&id=" & $id & "&stat=read", $textfile, 1, 0) ;reads the commands from the dtatabase at id above taken and sets status to 1 = starting
			$file = FileOpen($textfile, 0) ;reads request
			$au3 = FileReadLine($file, 1) ;request.au3
			FileClose($file)
			FileDelete($textfile)
			If ($au3 == "somefuncname") Then
				MsgBox(0, $Windowname, "put a function here", 5)
			Else
				_GUICtrlEdit_InsertText($Edit1,"=== New message recieved ===== Time : " & $time & " = Date : " & $date & " =====" & @CRLF & _
						"Message : " & $au3 & @CRLF & _
						"=============================================== End of Message ===" & @CRLF & @CRLF, -1)
			EndIf
			Sleep(3000)
			InetGet($url & "unset.php?user_id=" & $php_id & "&id=" & $id & "&stat=upd", $textfile, 1, 0) ;sets the status of the commands to 2 = finished
			FileDelete($textfile)
		Else
		Sleep(100)
	EndIf
WEnd
MsgBox(0, "", "I'm out!")
Exit
  EndFunc
  
  Func savesettings()
			if $Radio1 And BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED Then
                IniWrite($script[1] & ".ini", "User", "time", "30000")
			ElseIf $Radio2 And BitAND(GUICtrlRead($Radio2), $GUI_CHECKED) = $GUI_CHECKED Then
				IniWrite($script[1] & ".ini", "User", "time", "60000")
			ElseIf $Radio3 And BitAND(GUICtrlRead($Radio3), $GUI_CHECKED) = $GUI_CHECKED Then
				IniWrite($script[1] & ".ini", "User", "time", "120000")
			ElseIf $Radio4 And BitAND(GUICtrlRead($Radio4), $GUI_CHECKED) = $GUI_CHECKED Then
				IniWrite($script[1] & ".ini", "User", "time", "300000")
				EndIf
  	IniWrite($script[1] & ".ini", "User", "username", _GUICtrlEdit_GetText($Input1))
	IniWrite($script[1] & ".ini", "User", "userpass", _GUICtrlEdit_GetText($Input2))
	MsgBox(0,"",$Radio1)
  EndFunc
  
Func scriptclose()
	$nExit= 0
EndFunc
  
while 1
	sleep(100)
WEnd
