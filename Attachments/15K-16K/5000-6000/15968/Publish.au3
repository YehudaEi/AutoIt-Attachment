#include <Process.au3>
#include <File.au3>
#include <FTP.au3>
#include <GuiConstants.au3>
#include <GuiCombo.au3>
#include <INetUpdater.au3>

Opt("GUIResizeMode", 802)
Opt("GUIOnEventMode", 1)

$file = $CmdLine[1]
$AutoIt_Install = $CmdLine[2]

GuiCreate("Upload", 263, 238,-1, -1)

GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

$Combo_1 = GuiCtrlCreateCombo("", 10, 10, 240, 21)
GUICtrlSetOnEvent(-1, "populate")
$Server_Input = GuiCtrlCreateInput("", 60, 50, 190, 20)
$Directory_Input = GuiCtrlCreateInput("", 60, 80, 190, 20)
$Username_Input = GuiCtrlCreateInput("", 60, 110, 190, 20)
$Password_Input = GuiCtrlCreateInput("", 60, 140, 190, 20)
$Use = GuiCtrlCreateButton("Use", 20, 180, 100, 30)
GUICtrlSetOnEvent(-1, "Use")
$Cancel = GuiCtrlCreateButton("Cancel", 150, 180, 100, 30)
GUICtrlSetOnEvent(-1, "end")
$Label_7 = GuiCtrlCreateLabel("Server", 10, 50, 50, 20)
$Label_10 = GuiCtrlCreateLabel("Directory", 10, 80, 50, 20)
$Label_8 = GuiCtrlCreateLabel("Username", 10, 110, 50, 20)
$Label_9 = GuiCtrlCreateLabel("Password", 10, 140, 50, 30)

GuiSetState()

$Servernames = IniRead("Publish.ini", "ServerNames", "Names", "NotFound")
If $Servernames <> "NotFound" Then
	Dim $Serverarray[1]
	$index = 0
	$set_index = 0
	$Serverarray = StringSplit($Servernames,"|")
	$lastused = IniRead("Publish.ini", "Lastused", "Server", "NotFound")
	For $name in $Serverarray
		If IsString($name)Then
			_GUICtrlComboAddString($Combo_1, $name)
		EndIf
		If $name = $lastused Then
			$set_index = $index
		EndIf
		$index+=1
	Next
	_GUICtrlComboSetCurSel($Combo_1,$set_index-1)
	populate()
EndIf


While 1
	IniRead("Publish.ini", "ServerNames", "Names", "NotFound")
WEnd

Func populate()
	$index = _GUICtrlComboGetCurSel($Combo_1)
	_GUICtrlComboGetLBText($Combo_1,$index,$Name)
	GUICtrlSetData( $Server_Input, $Name)
	GUICtrlSetData( $Directory_Input, IniRead("Publish.ini", $Name, "Directory", "NotFound"))
	GUICtrlSetData( $Username_Input, IniRead("Publish.ini", $Name, "Username", "NotFound"))
	GUICtrlSetData( $Password_Input, IniRead("Publish.ini", $Name, "Password", "NotFound"))
EndFunc

Func Use()
	GuiSetState(@SW_HIDE)
	$Name = GUICtrlRead($Server_Input)
	$Name2 = ''
	$index = _GUICtrlComboGetCurSel($Combo_1)
	_GUICtrlComboGetLBText($Combo_1,$index,$Name2)
	If $Name <> $Name2 then
		_GUICtrlComboAddString($Combo_1, $Name)
	EndIf
	IniWrite("Publish.ini","ServerNames", "Names",_GUICtrlComboGetList($Combo_1))
	IniWrite("Publish.ini","Lastused", "Server",$Name)
	IniWrite("Publish.ini", $Name, "Server",GUICtrlRead($Server_Input))
	IniWrite("Publish.ini", $Name, "Directory",GUICtrlRead($Directory_Input))
	IniWrite("Publish.ini", $Name, "Username",GUICtrlRead($Username_Input))
	IniWrite("Publish.ini", $Name, "Password",GUICtrlRead($Password_Input))
	
	$Server = GUICtrlRead($Server_Input)
	$Directory = GUICtrlRead($Directory_Input)
	$Username = GUICtrlRead($Username_Input)
	$Password = GUICtrlRead($Password_Input)
	
	ConsoleWrite('+>Parsing File ' & $file & @CRLF)

	;Parse out file info from Command line args
	$title = StringSplit($file,"\")
	$title = $title[$title[0]]
	$title = StringTrimRight($title,4)
	$s_inu_ProgramTitle = $title
	$title = $title & '.exe'

	;Construct the location of everything
	$s_inu_WebSite = 'ftp://'&$Username&':'&$Password&'@'&$Server&$Directory
	$s_inu_IniFileName = "Updates.ini"
	Local $s_inu_GetVersFile = InetGet($s_inu_WebSite & "/" & $s_inu_IniFileName, @TempDir & "\" & $s_inu_IniFileName)
	InetGet($s_inu_WebSite & "/" & $title, @TempDir & "\" & $title)

	; grab latest version number
	Local $s_inu_LatestVersion = IniRead(@TempDir & "\" & $s_inu_IniFileName, $s_inu_ProgramTitle, "Vers", "Entry Not Found")
	If $s_inu_LatestVersion = "Entry Not Found" Then
		$s_inu_LatestVersion = .9
	EndIf
	$s_inu_LatestVersion = $s_inu_LatestVersion+.1
	IniWrite ( @TempDir & "\" & $s_inu_IniFileName, $s_inu_ProgramTitle, "Vers", Round($s_inu_LatestVersion,2) )
	ConsoleWrite('+>Rolling up to version ' & Round($s_inu_LatestVersion,2) & @CRLF)
	
	FileCopy($file, StringTrimRight($file,4)&".tmp")
	$file = StringTrimRight($file,4)&".tmp"
	
	$oFile = FileOpen($file, 0)
	$line = '#include'
	$include = False
	$endline = 0
	While StringInStr($line,"#include")
		$line = FileReadLine($ofile)
		If StringInStr($line,'<INetUpdater.au3>') Then
			$include = True
		EndIf
		$endline+=1
	WEnd
	$startline = 0
	$found = False
	While Not StringInStr($line,";Autoupdate variables")
		$line = FileReadLine($ofile)
		If StringInStr($line,";Autoupdate variables") Then
			$found = True
		EndIf
		If $startline > 100 then $line = ";Autoupdate variables"
		$startline+=1
	WEnd

	If $found Then
		_FileWriteToLine($file, $endline+$startline+1, '$s_Title = "'&StringTrimRight($title,4)&'"',1)
		_FileWriteToLine($file, $endline+$startline+2, '$s_Version = "'&Round($s_inu_LatestVersion,2)&'"; current version', 1)
		_FileWriteToLine($file, $endline+$startline+3, '$s_MyWebSite = "'&$s_inu_WebSite&'";', 1)
		_FileWriteToLine($file, $endline+$startline+4, '$s_inu_IniFileName = "Updates.ini"', 1)
		_FileWriteToLine($file, $endline+$startline+5, '$s_inu_RemoteFileName="'&$title&'"', 1)
		_FileWriteToLine($file, $endline+$startline+6, '_INetUpdater($s_Title, $s_Version, $s_MyWebSite, $s_inu_IniFileName, $s_inu_RemoteFileName, -1, -1, 1)', 1)
		_FileWriteToLine($file, $endline+$startline+7, 'Sleep(1000)', 1)
	Else
		_FileWriteToLine($file, $endline, ';End Autoupdate variables'&@CRLF, 0)
		_FileWriteToLine($file, $endline, 'Sleep(1000)', 0)
		_FileWriteToLine($file, $endline, '_INetUpdater($s_Title, $s_Version, $s_MyWebSite, $s_inu_IniFileName, $s_inu_RemoteFileName, -1, -1, 1)', 0)
		_FileWriteToLine($file, $endline, '$s_inu_RemoteFileName="'&$title&'"', 0)
		_FileWriteToLine($file, $endline, '$s_inu_IniFileName = "Updates.ini"', 0)
		_FileWriteToLine($file, $endline, '$s_MyWebSite = "'&$s_inu_WebSite&'";', 0)
		_FileWriteToLine($file, $endline, '$s_Version = "'&Round($s_inu_LatestVersion,2)&'"; current version', 0)
		_FileWriteToLine($file, $endline, '$s_Title = "'&StringTrimRight($title,4)&'"',0)
		_FileWriteToLine($file, $endline, @CRLF&';Autoupdate variables', 0)
	EndIf

	If $include = False Then
		_FileWriteToLine($file, $endline, '#include <INetUpdater.au3>', 0)
	EndIf

	;Compile the program with the new version number
	RunWait($AutoIt_Install&'\Aut2Exe\Aut2Exe.exe /in "' & $file & '"','')
	
	FileClose($ofile)
	FileDelete(StringTrimRight($file,4) & ".tmp")
	$file = StringTrimRight($file,3)&"exe"

	;Start doing all the FTP stuff
	$dllhandle = DllOpen('wininet.dll')
	$oFTP = _FTPOpen("MYFTP",0)

	$oConnect = _FTPConnect($oFTP, $Server,$Username,$Password,1)
	If @error Then ConsoleWrite('+>Could not connect to ' & $s_inu_WebSite & @CRLF)
	
	$Exitcode = _FTPPutFile($oConnect, $file, $Directory&"/"&$title)
	If @error Then ConsoleWrite('+>Could not upload ' & $file & @CRLF)
	_FTPPutFile($oConnect, @TempDir & "\" & $s_inu_IniFileName, $Directory&"/"&$s_inu_IniFileName)
	If @error Then ConsoleWrite('+>Could not upload ' & $s_inu_IniFileName & @CRLF)
	_FTPPutFile($oConnect, @TempDir & "\" & $title, $Directory&"/"&$s_inu_ProgramTitle&"/"&$s_inu_ProgramTitle&$s_inu_LatestVersion-.1&".exe")
	_FTPPutFile($oConnect, StringTrimRight($file,4)&".au3", $Directory&"/"&$s_inu_ProgramTitle&"/source/"&$s_inu_ProgramTitle&$s_inu_LatestVersion&".au3")
	If @error Then
		_FTPMakeDir($oConnect,$Directory&"/"&$s_inu_ProgramTitle&"/")
		_FTPMakeDir($oConnect,$Directory&"/"&$s_inu_ProgramTitle&"/source/")
		_FTPPutFile($oConnect, @TempDir & "\" & $title, $Directory&"/"&$s_inu_ProgramTitle&"/"&$s_inu_ProgramTitle&$s_inu_LatestVersion-.1&".exe")
		_FTPPutFile($oConnect, StringTrimRight($file,4)&".au3", $Directory&"/"&$s_inu_ProgramTitle&"/source/"&$s_inu_ProgramTitle&$s_inu_LatestVersion&".au3")
		If @error Then ConsoleWrite('+>Could not create old version backup of ' & $title & @CRLF)
	EndIf
		
	ConsoleWrite('+>Publishing complete.'& @CRLF)

	_FTPClose($oFTP)
	DllClose($dllhandle)
	end()
EndFunc

Func end()
	Exit
EndFunc

Func SpecialEvents() ;Handle Close/Minimize/Maximize operations

	Select
		Case @GUI_CTRLID = $GUI_EVENT_CLOSE
			end()
			;Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE

			;Case @GUI_CTRLID = $GUI_EVENT_RESTORE

	EndSelect

EndFunc