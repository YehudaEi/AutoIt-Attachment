#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_outfile=Quick HOSTS Editor.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Requires administrator rights
#AutoIt3Wrapper_Res_Description=Quick and easy edit hosts system file
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Open source
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)
$MSGTitle = 'Quick HOSTS Editor'
If IsAdmin() Then
	;call a function
Else
	MsgBox (64,$MSGTitle," You need administrator rights to use this feature.")
	Exit ;or what ever
EndIf

Global $Input,$hostsGUI
If IniRead(@ScriptDir & "\Quick HOSTS Editor Quick HOSTS Editor settings.ini", "settings", "backupdir", "") = "" Then IniWrite (@ScriptDir & "\Quick HOSTS Editor settings.ini","settings","backupdir",StringLeft (@ScriptFullPath,3)& "Saved\System config files")
Global $BackupFolder = IniRead(@ScriptDir & "\Quick HOSTS Editor settings.ini", "settings", "backupdir", "")

$CheckforRunningWindow = WinExists ("hosts Quick Editor")
If $CheckforRunningWindow = 1 Then
	WinActivate ("hosts Quick Editor")
Else
	ModifyHostsEditorFunction()
EndIf

Func ModifyHostsEditorFunction()
	$hostsGUI = GUICreate("hosts Quick Editor",310,470,-1,-1)
	$AddressToAdd = GUICtrlCreateinput ("127.0.0.1 ",10,65,60,25)
	$AddressToAddActual = GUICtrlCreateinput ("www.",75,65,120,25)
	GUICtrlSetState (-1,$GUI_NOFOCUS)
	$AddAddressButton = GUICtrlCreateButton ("Add this address",200,65,100)

	GUICtrlCreateGroup ("Examples",5,5,300,45)
	GUICtrlCreateInput ("127.0.0.1 www.google.com",10,20,140,20)
	GUICtrlCreateinput ("127.0.0.1 111.222.333.444",160,20,140,20)
	GUICtrlCreateGroup ("Address",5,50,300,45)

	GUICtrlCreateGroup ("hosts",5,100,300,330)
	$Input = GUICtrlCreateEdit ("",10,120,290,300)
	$ButtonSave = GUICtrlCreateButton ("Save/Write",5,435,100,30)
	$ButtonCancel = GUICtrlCreateButton ("Cancel/Close",205,435,100,30)

	TrayCreateItem('Modify "HOSTS"')
	TrayItemSetOnEvent(-1,"ModifyHostsEditorFunction") ;function name
	TrayCreateItem('Exit')
	TrayItemSetOnEvent(-1,"ExitHostsEditorFunction") ;function name
	TraySetState()

	$hosts = (@WindowsDir & "\System32\drivers\etc\hosts")
	$checkIfSystemhostsExists = FileExists (@WindowsDir & "\System32\drivers\etc\hosts")
	$checkIfLocalhostsExist = FileExists ($BackupFolder & "\hosts")

	If $checkIfSystemhostsExists = 1 And $checkIfLocalhostsExist = 0 Then
		MsgBox(32,$MSGTitle,"local hosts file cant be found. Setup will copy system hosts " & StringLeft (@ScriptDir,3) & "Saved\System config files.",'',$hostsGUI)
		FileCopy ($hosts,$BackupFolder & "\hosts", 1+8) ;copy system to local
	ElseIf $checkIfSystemhostsExists = 1 And $checkIfLocalhostsExist = 1 Then
		FileCopy ($BackupFolder & "\hosts", $hosts, 1) ;copy local to system
	ElseIf $checkIfSystemhostsExists = 0 And $checkIfLocalhostsExist = 1 Then
		MsgBox(32,$MSGTitle,"hosts file cant be found in system directory. Setup will copy " & StringLeft (@ScriptDir,3) & "Saved\System config files\" & "hosts to system.",'',$hostsGUI)
		FileCopy ($BackupFolder & "\hosts", $hosts, 1) ;copy local to system
	ElseIf $checkIfSystemhostsExists = 0 And $checkIfLocalhostsExist = 0 Then
		MsgBox(32,$MSGTitle,"Both System and " & StringLeft (@ScriptDir,3) & "Saved\System config files\" & "hosts cannot be found. Setup will create new in " & StringLeft (@ScriptDir,3) & "Saved\System config files\hosts",'',$hostsGUI)
		FileCopy ($hosts,$BackupFolder & "\hosts",0+8) ;this will create new local empty file
		FileWrite ($BackupFolder & "\hosts", "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 " & @CRLF & "127.0.0.1 ")
	Else
		MsgBox(16,@ScriptName, "Unknown Error")
		;EscapeHostsEditor() ;Go to end of the function is error
	EndIf

	Global $OpenFile = FileOpen ($BackupFolder & "\hosts",0)
	If $OpenFile = -1 Then MsgBox (64,@ScriptName,"Error opening \Saved\hosts.",'',$hostsGUI)
	$fileLocalRead = FileRead ($OpenFile)
	GUICtrlSetData ($Input, $fileLocalRead)
	GUISetState(@SW_SHOW, $hostsGUI)

	While 1
		$msg   = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				GUIDelete ($hostsGUI)
				ExitLoop
			Case $ButtonSave
				_Save()
			Case $ButtonCancel
				FileClose ($OpenFile)
				GUIDelete ($hostsGUI)
				ExitLoop
			Case $AddAddressButton
				$ReadAddressToAdd = GUICtrlRead ($AddressToAdd) & GUICtrlRead ($AddressToAddActual)
				$LineToRead = "1"
				$searchprogress = GUICreate ("Status",300,60,-1,-1,$WS_POPUP)
				$searningline = GUICtrlCreateLabel ("",10,10,280,40)
				GUISetState (@SW_SHOW,$searchprogress)
				While 1
					GUISetState (@SW_DISABLE, $hostsGUI)
					Local $Readhosts = FileReadLine ($BackupFolder & "\hosts",$LineToRead)
					If $ReadAddressToAdd = $Readhosts Then ;if added address matches to one already stored then ask to remove stored addresss
						$AskToRemoveEntry = MsgBox(4+32,'ERROR',$ReadAddressToAdd & ' is already in Stored "HOSTS" file.'& @CRLF &'Would you like to remove '& $ReadAddressToAdd & ' from Stored "HOSTS" and update Stored and System "HOSTS" ?')
						If $AskToRemoveEntry = 6 Then
							$res = StringReplace (FileRead ($BackupFolder & '\hosts'),@CRLF & $ReadAddressToAdd,'')
							FileClose ($OpenFile)
							FileDelete ($BackupFolder & '\hosts')
							FileWrite ($BackupFolder & '\hosts',$res)
							GUICtrlSetData ($Input,$res)
							_Save()
						EndIf
						GUIDelete ($searchprogress)
						ExitLoop
					EndIf
					If @error = -1 Then ;End of file reached
						GUICtrlSetData ($Input,@CRLF & $ReadAddressToAdd,"EDIT")
						GUIDelete ($searchprogress)
						_Save() ;am not sure at what point i need to save
						ExitLoop
					Endif
					Assign ("LineToRead",Number ($LineToRead +1))
					GUICtrlSetData ($searningline,"Searching for "& $ReadAddressToAdd & " in line #" & $LineToRead)
				WEnd
				GUIDelete ($searchprogress)
				GUISetState (@SW_ENABLE, $hostsGUI)
				WinActivate ($hostsGUI)
		EndSwitch
	WEnd
EndFunc

Func _Save()
	Global $OpenFile
	$Sfile = FileOpen ($BackupFolder & "\hosts", 2)
	$readAgain = GUICtrlRead ($Input)
	FileClose ($OpenFile)
	FileClose ($Sfile)
	$SfileAgain = FileOpen ($BackupFolder & "\hosts", 2)
	$write = FileWrite ($SfileAgain, $readAgain)

	FileClose ($SfileAgain)
	$replacehost = FileCopy ($BackupFolder & "\hosts", @WindowsDir & "\System32\drivers\etc\hosts", 1)
	If $write = 0 and $replacehost = 1 Then
		MsgBox(16,$MSGTitle,"Error writing file.",'',$hostsGUI)
	ElseIf $write = 1 and $replacehost = 0 Then
		MsgBox(16,$MSGTitle,"Error replacing system file.",'',$hostsGUI)
	ElseIf $write = 0 and $replacehost = 0 Then
		MsgBox(16,$MSGTitle,"Error writing and replacing system file.",'',$hostsGUI)
	ElseIf $write = 1 and $replacehost = 1 Then
		MsgBox(64,$MSGTitle,'Stored and Sytem "HOSTS" were updated successfully !')
	Endif
EndFunc

Func EscapeHostsEditor() ;end of the function
	MsgBox(0,$MSGTitle,'Something made it to exit. Try Again')
EndFunc

Func ExitHostsEditorFunction()
Exit
EndFunc
