#include <file.au3>
#include <Misc.au3>
#RequireAdmin

Opt("WinTitleMatchMode", 4)
Opt("TrayMenuMode", 1)

If _Singleton(@scriptname,1) = 0 Then
    MsgBox(64, "Same Process Detection", "Realtime Detection -  was already running  ", 5)
    Exit
EndIf

TraySetToolTip("Realtime Detection v1.0")
TraySetState()
$FIXREGISTRY = TrayCreateItem("Clean Registry")
$STARTUP = TrayCreateMenu("Startup")
$ADDSTARTUP = TrayCreateItem("Run Realtime Detection when system startup", $STARTUP)
$REMOVESTARTUP = TrayCreateItem("Remove Realtime Detection from system startup", $STARTUP)
TrayCreateItem("")
$ABOUTITEM = TrayCreateItem("About")
TrayCreateItem("")
$EXITITEM = TrayCreateItem("Exit")
If FileExists("C:\Realtime Detection\Realtime Detection.exe") = False Then
	TrayTip("Realtime Detection v1.0", "Right click for menu.", 5, 1)
EndIf
$NOTRAYITEMSDISPLAY = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoTrayContextMenu")
If $NOTRAYITEMSDISPLAY = "1" Then
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoTrayItemsDisplay")
	RegDelete("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoTrayItemsDisplay")
	ProcessClose("explorer.exe")
	If ProcessExists("explorer.exe") = False Then
		Run("explorer.exe")
	EndIf
EndIf
$NOTRAYCONTEXTMENU = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoTrayContextMenu")
If $NOTRAYCONTEXTMENU = "1" Then
	RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoTrayContextMenu")
	RegDelete("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", "NoTrayContextMenu")
	ProcessClose("explorer.exe")
	If ProcessExists("explorer.exe") = False Then
		Run("explorer.exe")
	EndIf
EndIf
While 1
	$MSG = GUIGetMsg()
	If $MSG = -3 Then Exit
	$REM = DriveGetDrive("REMOVABLE")
	If Not @error Then
		For $IREM = 1 To $REM[0]
			$REMDRIVE = $REM[$IREM]
			If $REMDRIVE <> "A:" And DriveGetFileSystem($REMDRIVE) <> "" Then
				If FileExists($REM[$IREM] & "\autorun.inf") Then
					$REMOPEN = IniRead($REMDRIVE & "\autorun.inf", "autorun", "open", "None")
					$REMSHELL = IniRead($REMDRIVE & "\autorun.inf", "autorun", "shellexecute", "None")
					If Not @error Then
						$SPLITREMSHELL = StringSplit($REMSHELL, " ")
						$SPLITREMOPEN = StringSplit($REMOPEN, " ")
						For $IREMOPEN = 1 To $SPLITREMOPEN[0]
							If $REMOPEN = "None" Then
								Sleep(1000)
							Else
								FileSetAttrib($REMDRIVE & "\" & $SPLITREMOPEN[$IREMOPEN], "-RASH")
								FileDelete($REMDRIVE & "\" & $SPLITREMOPEN[$IREMOPEN])
								FileSetAttrib($REMDRIVE & "\autorun.inf", "-RASH")
								FileDelete($REMDRIVE & "\autorun.inf")
								TrayTip("Malware detected!", "Malware " & $REMOPEN & " hase been kick away from your " & $REMDRIVE & " drive. You can relax now.", 5, 1)
								_FILEWRITELOG(@ScriptDir & "\RealtimeDetection.log", "[Malware] " & $REMSHELL & " was removed from " & $REMDRIVE & @CRLF)
								
								ProcessClose($SPLITREMOPEN[$IREMOPEN])
							EndIf
						Next
						For $IREMSHELL = 1 To $SPLITREMSHELL[0]
							If $REMSHELL = "None" Then
								Sleep(1000)
							Else
								FileSetAttrib($REMDRIVE & "\" & $SPLITREMSHELL[$IREMSHELL], "-RASH")
								FileDelete($REMDRIVE & "\" & $SPLITREMSHELL[$IREMSHELL])
								FileSetAttrib($REMDRIVE & "\autorun.inf", "-RASH")
								FileDelete($REMDRIVE & "\autorun.inf")
								TrayTip("Malware detected!", "Malware " & $REMOPEN & " hase been kick away from your " & $REMDRIVE & " drive. You can relax now.", 5, 1)
								_FILEWRITELOG(@ScriptDir & "\RealtimeDetection.log", "[Malware] " & $REMSHELL & " was removed from " & $REMDRIVE & @CRLF)
								ProcessClose($SPLITREMSHELL[$IREMSHELL])
							EndIf
						Next
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	$FIX = DriveGetDrive("FIXED")
	If Not @error Then
		For $F = 1 To $FIX[0]
			$FIXDRIVE = $FIX[$F]
			If $FIXDRIVE <> "A:" And DriveGetFileSystem($FIXDRIVE) <> "" Then
				If FileExists($FIX[$F] & "\autorun.inf") Then
					$FIXOPEN = IniRead($FIXDRIVE & "\autorun.inf", "autorun", "open", "None")
					$FIXSHELL = IniRead($FIXDRIVE & "\autorun.inf", "autorun", "shellexecute", "None")
					$SPLITFIXOPEN = StringSplit($FIXOPEN, " ")
					$SPLITFIXSHELL = StringSplit($FIXSHELL, " ")
					For $FOPEN = 1 To $SPLITFIXOPEN[0]
						$INSPLITOPEN = $SPLITFIXOPEN[$FOPEN]
						If $FIXOPEN = "None" Then
							Sleep(1000)
						Else
							ProcessClose($SPLITFIXOPEN[$FOPEN])
							FileSetAttrib($FIXDRIVE & "\" & $SPLITFIXOPEN[$FOPEN], "-RASH")
							FileDelete($FIXDRIVE & "\" & $SPLITFIXOPEN[$FOPEN])
							FileSetAttrib($FIXDRIVE & "\autorun.inf", "-RASH")
							FileDelete($FIXDRIVE & "\autorun.inf")
						EndIf
					Next
					For $FSHELL = 1 To $SPLITFIXSHELL[0]
						$INSPLITSHELL = $SPLITFIXSHELL[$FSHELL]
						If $FIXSHELL = "None" Then
							Sleep(1000)
						Else
							ProcessClose($SPLITFIXSHELL[$FSHELL])
							FileSetAttrib($FIXDRIVE & "\" & $SPLITFIXSHELL[$FSHELL], "-RASH")
							FileDelete($FIXDRIVE & "\" & $SPLITFIXSHELL[$FSHELL])
							FileSetAttrib($FIXDRIVE & "\autorun.inf", "-RASH")
							FileDelete($FIXDRIVE & "\autorun.inf")
						EndIf
					Next
				EndIf
			EndIf
		Next
	EndIf
	$MSG = TrayGetMsg()
	Select
		Case $MSG = $FIXREGISTRY
			$HCUEXPLORER = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
			$HLMEXPLORER = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
			$HCUSYSTEM = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System"
			$HCUADVANCED = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
			$HLMWINLOGON = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
			$HCUMAIN = "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main"
			RegDelete($HCUEXPLORER, "NoFolderOptions")
			RegDelete($HLMEXPLORER, "NoFolderOptions")
			RegDelete($HCUEXPLORER, "NoViewContextMenu")
			RegDelete($HLMEXPLORER, "NoViewContextMenu")
			RegDelete($HLMEXPLORER, "NoStartMenuMorePrograms")
			RegDelete($HCUEXPLORER, "NoStartMenuMorePrograms")
			RegDelete($HCUEXPLORER, "HideClock")
			RegDelete($HLMEXPLORER, "HideClock")
			RegDelete($HCUEXPLORER, "NoDesktop")
			RegDelete($HLMEXPLORER, "NoDesktop")
			RegDelete($HCUEXPLORER, "NoRun")
			RegDelete($HLMEXPLORER, "NoRun")
			RegDelete($HCUEXPLORER, "NoControlPanel")
			RegDelete($HLMEXPLORER, "NoControlPanel")
			RegDelete($HCUEXPLORER, "NoSMMyDocs")
			RegDelete($HLMEXPLORER, "NoSMMyDocs")
			RegDelete($HCUEXPLORER, "NoRecentDocsMenu")
			RegDelete($HLMEXPLORER, "NoRecentDocsMenu")
			RegDelete($HCUEXPLORER, "NoSMMyPictures")
			RegDelete($HLMEXPLORER, "NoSMMyPictures")
			RegDelete($HCUEXPLORER, "NoStartMenuMyMusic")
			RegDelete($HLMEXPLORER, "NoStartMenuMyMusic")
			RegDelete($HLMEXPLORER, "NoStartMenuNetworkPlaces")
			RegDelete($HCUEXPLORER, "NoStartMenuNetworkPlaces")
			RegDelete($HCUSYSTEM, "DisableRegistryTools")
			RegDelete($HCUSYSTEM, "DisableCMD")
			RegDelete($HCUSYSTEM, "Disabletaskmgr")
			RegDelete($HCUADVANCED, "HideFileExt")
			RegDelete($HCUMAIN, "Window Title")
			RegDelete($HCUEXPLORER, "NoFind")
			RegDelete($HLMEXPLORER, "NoFind")
			RegDelete($HCUEXPLORER, "NoWinKey")
			RegDelete($HLMEXPLORER, "NoWinKey")
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL", "CheckedValue", "REG_DWORD", "1")
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL", "DefaultValue", "REG_DWORD", "2")
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\NOHIDDEN", "CheckedValue", "REG_DWORD", "2")
			RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\NOHIDDEN", "DefaultValue", "REG_DWORD", "2")
			ProcessClose("explorer.exe")
			If ProcessExists("explorer.exe") = False Then
				Run("explorer.exe")
			EndIf
			MsgBox(64, "Realtime Detection v1.0", "Registry has been fixed")
		Case $MSG = $ADDSTARTUP
			FileCopy(@ScriptFullPath, "C:\Realtime Detection\Realtime Detection.exe", "9")
			RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "Realtime Detection", "REG_SZ", "C:\Realtime Detection\Realtime Detection.exe")
			MsgBox("64", "Realtime Detection v1.0", "Thanks for adding me.")
		Case $MSG = $REMOVESTARTUP
			FileDelete("C:\Realtime Detection\Realtime Detection.exe")
			RegDelete("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "Realtime Detection")
			MsgBox("64", "Realtime Detection v1.0", "You remove me..:-|.")
		Case $MSG = $ABOUTITEM
			ABOUT()
		Case $MSG = $EXITITEM
			ExitLoop
	EndSelect
WEnd

Func ABOUT()
	MsgBox("64", "Realtime Detection v1.0", "Is This OK?.")
EndFunc
