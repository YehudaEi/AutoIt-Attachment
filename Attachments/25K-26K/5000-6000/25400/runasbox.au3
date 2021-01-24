#CS ---------------------
	credits:
	I borrowed the GUI from:
	;~ RunAS Box
	;~ Author: Shaun Burdick
	;~ Date: 11/30/2006

	The rest i have slowly pieced together.
	It should open any file that has an extension associated with
	a program. I have tested it on .rar .zip .dat .exe .reg .txt .vbs .msi, shortcuts, url links, among others.
	it works with a file that doesn't have an extension, asking you what you want to open it with.
	if you have any issues with opening a file, let me know.
	Enjoy

	Yeik 27-02-2008
#ce ---------

#include <GUIConstants.au3>
#include <WindowsConstants.au3>

$oMyError = ObjEvent("AutoIt.Error", "ComError")
Opt("GUIOnEventMode", 1)
Global $username
Global $password
Global $domain
Global $Browse

__main__()
Func __main__()
	if UBound($cmdline) > 3 Then
		$username = $cmdline[1]
		$domain = $cmdline[2]
		$password = $cmdline[3]
		if @UserName = $username Then
		Else
			_switchuser($username, $domain, $password)
		EndIf
	Else
	setcredentials()
	EndIf
	runwindow()
EndFunc

Func setcredentials()
	Local $user
	Local $error
	$defdom = ""
	If $username Then $username = 0
	If $domain Then $domain = 0
	If $password Then $password = 0
	$user = InputBox("Username", 'Enter your username', $defdom, "", 200, 100, -1, -1)
	If @error Then _exit()
	$password = InputBox("Password", 'Enter your password', "", "*M", 200, 100, -1, -1)
	If @error Then _exit()
	If StringInStr($user, "\") Then
		$domain = StringLeft($user, StringInStr($user, "\") - 1)
		$username = StringTrimLeft($user, StringLen($domain) + 1)
	ElseIf StringInStr($user, "@") Then
		$username = StringLeft($user, StringInStr($user, "@") - 1)
		$domain = StringTrimLeft($user, StringLen($username) + 1)
	Else
		$domain = @ComputerName
		$username = $user
	EndIf
	testcredentials()
EndFunc   ;==>setcredentials


Func testcredentials() ;Test to make sure you entered valid domain, username, and password
	Local $error
	Local $procpid
	$procpid = RunAs($username, $domain, $password, 1, @SystemDir &"\cmd.exe", "", @SW_HIDE)
	$error = @extended
	If ProcessExists($procpid) Then RunAs($username, $domain, $password, 1, "taskkill /F /T /IM " & $procpid, "", @SW_HIDE); Close test process
	If $error <> 0 Then
		Switch $error
			Case 1326
				MsgBox(4096, "ERROR", "Your credentials were wrong. ")
				setcredentials()
			Case 87
				MsgBox(4096, "ERROR", "can't find file")
				_exit()
			Case 1909
				MsgBox(4096, "ERROR", "Account is locked out")
				setcredentials()
			Case Else
				MsgBox(4096, "ERROR", "unkown error")
				MsgBox(4096, "", $error)
				_exit()
		EndSwitch
	EndIf
	_switchuser($username, $domain, $password)
EndFunc   ;==>testcredentials

Func _switchuser($usr, $dmn, $pwd)
	local $tmperror
	;MsgBox(0, "script file name", @ScriptFullPath)
	if StringRight(@ScriptFullPath, 3) = "exe" Then
		RunAs($usr, $dmn, $pwd, 1, @ScriptFullPath & " " & $usr & ' ' & $dmn & ' ' & $pwd)
		$tmperror = @extended
		if $tmperror Then
			FileCopy(@ScriptFullPath, @TempDir)
			RunAs($usr, $dmn, $pwd, 1, @TempDir & '\' & @ScriptName & " " & $usr & ' ' & $dmn & ' ' & $pwd)
			$tmperror = @extended
			If $tmperror Then
				MsgBox(0, "Error", "That user doesn't have proper rights to the file or the temp folder. Error: " & $tmperror, 15)
			EndIf
		EndIf
	Else
		RunAs($usr, $dmn, $pwd, 4, @AutoItExe & ' /autoit3executescript ' &'"' & @ScriptFullPath &'"' & " " & $usr & ' ' & $dmn & ' ' & $pwd)
		;MsgBox(0, "script execute", @AutoItExe & ' /autoit3executescript ' &'"' & @ScriptFullPath &'"' & " " & $usr & ' ' & $dmn & ' ' & $pwd)
		if @extended Then
			MsgBox(0, "File Rights", "That account doesn't have rights to autoit or the script", 10)
		EndIf
	EndIf
	_exit()
EndFunc

Func runfile($filename)
	Local $error
	Local $procpid
	$fileext = "noext"
	;MsgBox(0, "filename", $filename)
	If StringInStr($filename, ".") Then
		$filepath = StringLeft($filename, StringInStr($filename, ".") - 1)
		$fileext = StringTrimLeft($filename, StringLen($filename) + 1)
		$error = 0
	EndIf
	Switch $fileext
		Case "exe", "bat", "com"
			;MsgBox(0, "case exe", "case 1, exe")
			Run($filename)
			$error = @extended
		Case "noext"
			;MsgBox(0, "case noext", "case 2, no extension")
			ShellExecute("rundll32.exe", "shell32.dll, OpenAs_RunDLL " & $filename)
			$error = @extended
		Case Else
			;MsgBox(0, "case else", "case 3, else")
			$procpid = Run(@ComSpec & ' /c ' & '"' & $filename & '"', '', @SW_HIDE)
			$error = @extended
			;MsgBox(0, "case else", "case 3, after. " & $error)
	EndSwitch
	;MsgBox(0, "extended error", "error: " & $error)
	if $procpid Then Run("taskkill /F /IM " & $procpid, "", @SW_HIDE)
	If $error <> 0 Then
		Switch $error
			Case 1326
				MsgBox(4096, "ERROR", "Your credentials were wrong. ")
				setcredentials()
			Case 267
				MsgBox(4096, "Error", $username & " does not have rights to " & $filename)
			Case 87
				MsgBox(4096, "ERROR", "can't find file:" & $filename)
			Case 1909
				MsgBox(4096, "ERROR", "Account is locked out")
				setcredentials()
			Case Else
				MsgBox(4096, "ERROR", "unkown error")
				MsgBox(4096, "", "Error:" & $error & " file:" & $filename)
		EndSwitch
	EndIf
EndFunc   ;==>runfile

Func _killcmd($pid)
	$wait = TimerInit() + 10
	Do
	Until $wait <= TimerInit()
	MsgBox(4096, "Kill", "Time to kill " & $pid)
	If ProcessExists($pid) Then ProcessClose($pid)
	 If ProcessExists($pid) Then
		 Run("taskkill /F /IM " & $pid, "", @SW_HIDE)
		 MsgBox(4096, "Kill", "still exists " & $pid)
	EndIf
EndFunc

Func runwindow()
	Local $strBKCOLOR = 0x0000FF;Blue
	Local $strCOLOR = 0xFFFBF0;Off-White
	Local $intWindowHeight = 175
	Local $intWindowWidth = 130
	$ptrDragBox = GUICreate("RunAS: " & $username, $intWindowHeight, _
			$intWindowWidth + 25, -1, -1, -1, $WS_EX_ACCEPTFILES)
	$ptrDropLabel = GUICtrlCreateLabel("Run as: " & @LF & $domain & @LF & $username & @LF & @LF & "Drag File here", 1, 1, $intWindowHeight, $intWindowWidth)
	$Browse = GUICtrlCreateButton("Browse", 5, $intWindowWidth + 1)
	GUICtrlSetOnEvent(-1, "_browse")
	GUICtrlSetState($ptrDropLabel, $GUI_DROPACCEPTED)
	GUICtrlSetBkColor($ptrDropLabel, $strBKCOLOR)
	GUICtrlSetColor($ptrDropLabel, $strCOLOR)
	GUICtrlSetFont($ptrDropLabel, 16, "BOLD")
	GUISetState(@SW_SHOW, $ptrDragBox)
	;GUISetOnEvent($GUI_EVENT_MINIMIZE,"hide")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
	GUISetOnEvent($GUI_EVENT_DROPPED, "filerun")
	While 1
		Sleep(100000)
	WEnd
EndFunc   ;==>runwindow

Func _browse()
	Local $openfilename
	$openfilename = FileOpenDialog("open file as", @WindowsDir & "\", "All (*.*)", 1 + 4)
	If $openfilename Then runfile($openfilename)
EndFunc   ;==>_browse

Func filerun()
	runfile(@GUI_DragFile)
EndFunc   ;==>filerun

Func _exit()
	If @ScriptDir = @TempDir Then
		Run(@ComSpec & ' /c ping 127.0.0.1 & ping 127.0.0.1 & del ' & @ScriptFullPath, "", @SW_HIDE)
	EndIf
	Exit
EndFunc   ;==>_exit

Func ComError()
	If IsObj($oMyError) Then
		$HexNumber = Hex($oMyError.number, 8)
		SetError($HexNumber)
	Else
		SetError(1)
	EndIf
EndFunc   ;==>ComError
