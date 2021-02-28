#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: _Install
; Description ...:
; Syntax ........: _Install($DisplayName, $Publisher, $DisplayIcon, $InstallLocation[, $HKType = "HKCU"[, $DisplayVersion = ""[,
;                  $HelpLink = False]]])
;
; Parameters ....: $DisplayName         - Registry sub key name used and Software removal entry name that will be shown.
;                  $Publisher           - Publisher name to show in the control panel software removal applet.
;                  $DisplayIcon         - Icon to show in the software removal applet, should be icon index number or name.
;												Syntax can be (@SystemDir & "\shell32.dll,0") or just leave blank to use
;												the scripts default icon.
;                  $SelfDelete          - Delete ourseleves after compleation. Default is False.
;                  $InstallLocation     - [optional] Location to set the uninstaller and to install files. Default
;														is @ProgramFilesDir
;                  $HKType              - [optional] Registry key base to set the installation for. Default is
;														"HKCU", (I.E., current user).
;                  $DisplayVersion      - [optional] Version display entry. Default is the compiled application version.
;                  $HelpLink            - [optional] A link to where a user may get help. Default is none.
;                  $InstallFunc         - [optional] Your function to call that will install the program or required files.
;														Default is none. You should only use this function if it has proper
;														error checking and return values, I would recommend that you have
;														the suppled func return an error only if its something
;														critical (I.E., anything that would break the installation.)
;														But this can be handy if you configure your function correctly
;														so as to allow this function to remove anything it may have done
;														in case your function fails for some reason.
;
; Return values .: True if operation compleated successfully, false if errors occured and error set to one of positive
;						values listed below unless you supplied an installation function which will return its error and
;						set the @Extended macro to a positive value.
;
;					@Error ~
;						1 - Can be several things, such as the script not being compiled or an empty display name
;								value or incorrect base key format.
;						2 - Explicitly an incorrect base key format or name.
;						3 - Installation directory does not have the director attribute "D", meaning destination
;								may be a file.
;						4 - Installation path is read only.
;						5 - Installation directory already exists, I'll leave it up to you to handle this.
;						6 - Error creating the installation directory
;						7 - Supplied installation function does not exist.
;						8 - something is wrong with the registry value being used.
;					@Extended ~
;						1 - The supplied installtion function returned an error, if this value is positive, the
;								@error macro is set to the supplied installation functions @Error return code
;								and all registry entries will be removed.
;
; Author ........: THAT1ANONYMOUSDUDE
; Modified ......:
; Remarks .......: You are responsible for handling the files to be installed.
; Related .......: None
; Link ..........:
; Example .......: Depends on you, but mostly yes.
; ===============================================================================================================================

Func _Install($DisplayName, $Publisher, $DisplayIcon, $SelfDelete = False, $InstallLocation = @ProgramFilesDir, $HKType = "HKCU", $DisplayVersion = Default, $HelpLink = False, $InstallFunc = False)

	#Region - Variable Verification / Correction -

	If Not $HKType Then $HKType = "HKCU"
	If Not $InstallLocation Then $InstallLocation = @ProgramFilesDir
	If Not $DisplayVersion Then $DisplayVersion = Default
	If Not $HelpLink Then $HelpLink = False
	If Not $InstallFunc Then $InstallFunc = False
	If Not $SelfDelete Then $SelfDelete = False; we don't even need this...

	If (IsString($HKType) = False) Or (StringLen($HKType) < 4) Or (StringLen($DisplayName) = 0) Or Not @Compiled Then Return SetError(1,0,False)

	$HKType = _CheckBaseKey($HKType)
	If $HKType = @error Then
		Return SetError(2,0,False)
	EndIf

	#EndRegion - Variable Verification / Correction -

	Local $Key = $HKType & "\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $DisplayName

	If StringTrimLeft($InstallLocation,StringLen($InstallLocation) - 1) == '\' Then
		Local $SP = StringSplit($InstallLocation,"\",2)
		Local $NM = UBound($SP) - 1
		$InstallLocation = ''
		For $I = 0 To $NM
			$InstallLocation &= $SP[$I]
			If ($I + 1) = $NM Then ExitLoop
			$InstallLocation &= "\"
		Next
	EndIf

	Local $CHECK = False

	If FileExists($InstallLocation) Then
		$CHECK = FileGetAttrib($InstallLocation)
		If Not StringInStr($CHECK,"D",2) Then Return SetError(3,0,False)
		$CHECK = $InstallLocation & "\" & $DisplayName
		If FileExists($CHECK) Then Return SetError(5,0,False)
		DirCreate($CHECK)
		If @error Then Return SetError(6,0,False)
	Else
		$CHECK = $InstallLocation & "\" & $DisplayName
		DirCreate($CHECK)
		If @error Then Return SetError(6,0,False)
	EndIf

	If $InstallFunc Then
		Local $Return = Call($InstallFunc)
		Local $Error = @error
		If $Error Then
			Switch $Error
				Case 0xDEAD
					DirRemove($CHECK)
					Return SetError(7,0,False)
				Case Else
					DirRemove($CHECK)
					Return SetError($Error,1,$Return)
			EndSwitch
		Else
			;Continue operation
		EndIf
	EndIf

	RegWrite($Key, "InstallLocation","REG_SZ",$CHECK)
	If @error Then
		RegDelete($Key)
		Return SetError(8,0,False)
	EndIf

	RegWrite($Key, "DisplayName","REG_SZ",$DisplayName)
	If @error Then
		RegDelete($Key)
		Return SetError(8,0,False)
	EndIf

	If Not $DisplayIcon Then
		$DisplayIcon = $CHECK & "\" & @ScriptName
	EndIf

	RegWrite($Key, "DisplayIcon","REG_SZ",$DisplayIcon)
	If @error Then
		RegDelete($Key)
		Return SetError(8,0,False)
	EndIf

	RegWrite($Key, "Publisher","REG_SZ",$Publisher)
	If @error Then
		RegDelete($Key)
		Return SetError(8,0,False)
	EndIf

	If $HelpLink Then
		RegWrite($Key, "HelpLink","REG_SZ",$HelpLink)
		If @error Then
			RegDelete($Key)
			Return SetError(8,0,False)
		EndIf
	EndIf

	Switch $DisplayVersion
		Case Default,""
			$DisplayVersion = FileGetVersion(@AutoItExe,"FileVersion")
			If @error Then $DisplayVersion = FileGetVersion(@AutoItExe,"ProductVersion")
	EndSwitch

	RegWrite($Key, "DisplayVersion","REG_SZ",$DisplayVersion)
	If @error Then
		RegDelete($Key)
		Return SetError(8,0,False)
	EndIf

	RegWrite($Key, "Version","REG_SZ",$DisplayVersion)
	If @error Then
		RegDelete($Key)
		Return SetError(8,0,False)
	EndIf

	RegWrite($Key, "NoModify","REG_DWORD",1);No modification options
	RegWrite($Key, "NoRepair","REG_DWORD",1);No repair options
	RegWrite($Key, "InstallDate","REG_SZ",@YEAR&@MON&@MDAY)
	RegWrite($Key, "ID","REG_DWORD",1);Used to identify ourselves

	#cs
		When a user clicks the uninstall button in the control panel applet
		this parameter below will be passed to our compiled application letting
		us know we should uninstall our software from their machine...
	#ce

	RegWrite($Key, "UninstallString","REG_SZ",$CHECK&"\"&@ScriptName&" --uninstall")
	If @error Then
		RegDelete($Key)
		Return SetError(8,0,False)
	EndIf

	;Temporary method of testing this only...
	FileCopy(@AutoItExe,$CHECK&"\"&@ScriptName)
	If $SelfDelete Then
		_SelfDelete()
	EndIf

	Return SetError(-1,0,True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: CheckUninstallRequest
; Description ...:
; Syntax ........: CheckUninstallRequest($DisplayName[, $HKType = "HKCU"[, $Function = ""]])
; Parameters ....: $DisplayName         - Registry sub key name used and Software removal entry name that will be shown.
;                  $HKType              - [optional] Registry key base to set the installation for. Default is
;														"HKCU", (I.E., current user).
;                  $Function            - [optional] Your function to call that will uninstall program changes that were made.
;														Default is none. You should only use this function if it has proper
;														error checking and return values.
; Return values .: Returns true if operation compleated successfully, false if errors occure and sets error level to one of below.
;
;					@Error ~
;						1 - You will get this error only if you supplied an uninstall function and the function supplied
;								does not exist.
;						2 - Explicitly an incorrect base key format or name.
;						3 - Failed to read the registry key that has the install location defined, this is needed in order to
;								know what directory should be cleaned up and removed.
;						4 - Failed to delete the installation directory where the program is located.
;					@Extended ~
;						1 - The supplied uninstalltion function set an error, if this value is positive, maybe even 0, the
;								@error macro is set to the supplied installation functions @Error return code
;								and return value is also passed, make sure to set your functions error level to
;								a negative value if no errors are to be set.
;
; Author ........: THAT1ANONYMOUSDUDE
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Depends on you, again...
; ===============================================================================================================================

Func CheckUninstallRequest($DisplayName, $HKType = "HKCU", $Function = "")
	If $CmdLineRaw Then
		Local $Return = StringSplit($CmdLineRaw,"--",2)
		If IsArray($Return) Then
			If (UBound($Return) - 1) > 1 Then
				If $Return[2] == "uninstall" Then; no other paramaters should have been passed, so we
					If Not $Function Then; we will attempt to delete everything in our installation directory

						#Region - Application Removal -

						If FileGetShortName(@ScriptDir) <> FileGetShortName(@TempDir) Then; move a copy of this file to the temp directory so we can uninstall properly from there.
							Local $TmpFile = @TempDir & "\SetUp.exe"
							If FileExists($TmpFile) Then
								For $I = 0 To 99999999
									$TmpFile = @TempDir & "\SetUp(" & $I & ").exe"
									If Not FileExists($TmpFile) Then ExitLoop
								Next
								FileCopy(@ScriptFullPath,$TmpFile)
							EndIf
							FileCopy(@ScriptFullPath,$TmpFile)
							If Not ProcessExists(Run(FileGetShortName($TmpFile) & " --uninstall",@WorkingDir)) Then Return SetError(1,0,False)
							Exit
						Else; we are already in the temp directory, commence operation to remove everything possible.
							If Not $HKType Then $HKType = "HKCU"
							$HKType = _CheckBaseKey($HKType)
							If $HKType = @error Then Return SetError(2,0,False)
							Local $Key = $HKType & "\Software\Microsoft\Windows\CurrentVersion\Uninstall\" & $DisplayName
							Local $Directory = RegRead($Key,"InstallLocation")
							If $Directory = @error Then SetError(3,0,False)
							DirRemove($Directory,1)
							If @error Then
								CloseExecMods($Directory); maybe we're locked because an application is running in our dir, lets locate exes and close them.
								DirRemove($Directory,1)
								If @error Then Return SetError(4,0,False)
							EndIf
							RegDelete($HKType & "\Software\Microsoft\Windows\CurrentVersion\Uninstall",$DisplayName)
							Return SetError(-1,0,True)
						EndIf

						#EndRegion - Application Removal -

					Else; you supplied a function, we'll use that instead and then you can call this function again to handle the registry and directory.

						#Region - User Supplied Function -

						#cs
							This is useful if you have a function that will delete other files outside the installation directory. After it's done
							It will run itslef again and finish the deal.
						#ce
						$Return = Call($Function)
						If @error Then
							Switch @error
								Case 0xDEAD
									Return SetError(1,0,False)
								Case Else
									Return SetError(@error,1,$Return)
							EndSwitch
						Else
							CheckUninstallRequest($DisplayName, $HKType)
							Exit
						EndIf

						#EndRegion - User Supplied Function -

					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	Return SetError(-1,0,False)
EndFunc

#Region - Internal -

; #INTERNAL FUNCTION# ===========================================================================================================
; Name ..........: _CheckBaseKey
; Description ...: Fixes key base for registry
; Syntax ........: _CheckBaseKey($HKType)
; Parameters ....: $HKType              - Registry key to check.
; Return values .: The correct base key.
; Author ........: THAT1ANONYMOUSDUDE
; Modified ......:
; Remarks .......: This function is supposed to check if things are going to be written to the correct registry area.
; Related .......: None
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _CheckBaseKey($HKType)
	Local $CHECK = False
	If (@OSArch <> "X86") And @AutoItX64 Then
		If Number(StringTrimLeft($HKType,StringLen($HKType) - 2)) <> 64 Then

			#cs
				Jon once said somewhere that if running a compiled autoit script with an x86 interpreter
				the x64 OS will manually correct the key destination unless running with the x64 interpreter
				the system will assume the destination is correct, so just in case, we will attempt a correction
				manually in this area just for the heck of it..

				Also note: If no match is found, we will throw an error because this shouldn't be written anywhere else.
			#ce

			Local Const $KeyVal[4][2] = [ _
						["HKCU","HKCU64"], _
						["HKLM","HKLM64"], _
						["HKEY_LOCAL_MACHINE","HKEY_LOCAL_MACHINE64"], _
						["HKEY_CURRENT_USER","HKEY_CURRENT_USER64"] _
						]

			For $I = 0 To UBound($KeyVal,1) - 1
				If StringInStr($KeyVal[$I][0],$HKType,2) Then
					$HKType = $KeyVal[$I][1]
					$CHECK = True
					ExitLoop
				EndIf
			Next

			If Not $CHECK Then Return SetError(1,0,False)

		EndIf
	EndIf

	Return SetError(-1,0,$HKType)
EndFunc

; #INTERNAL FUNCTION# ===========================================================================================================
; Name ..........: CloseExecMods
; Description ...: closes exe programs in a directory.
; Syntax ........: CloseExecMods($Dir)
; Parameters ....: $Dir                 - the directory to recurse for executable moduluals
; Return values .: None
; Author ........: AutoIt Community
; Example .......: No
; ===============================================================================================================================

Func CloseExecMods($Dir)
	Local $FILE
	Local $SEARCH = FileFindFirstFile($Dir & "\*.*")
	If $SEARCH = -1 Then Return
	While 1
		Sleep(0)
		$FILE = FileFindNextFile($SEARCH)
		If @error Then ExitLoop
		If @extended Then
			CloseExecMods($Dir & "\" & $FILE)
		Else
			If StringInStr(StringRight($FILE,4),"exe",2) Then
				ProcessClose($FILE)
			EndIf
		EndIf
	WEnd
EndFunc

; #INTERNAL FUNCTION# ===========================================================================================================
; Name ..........: _SelfDelete
; Description ...: Deletes the running script
; Syntax ........: _SelfDelete()
; Parameters ....: None
; Return values .: None
; Author ........: MHz
; Modified ......: N/A
; Link ..........: http://www.autoitscript.com/forum/topic/19370-autoit-wrappers/page__view__findpost__p__199605
; Example .......: No
; ===============================================================================================================================

Func _SelfDelete($iDelay = 0)
    Local $sCmdFile
    FileDelete(@TempDir & "\scratch.bat")
    $sCmdFile = 'ping -n ' & $iDelay & '127.0.0.1 > nul' & @CRLF _
            & ':loop' & @CRLF _
            & 'del "' & @ScriptFullPath & '"' & @CRLF _
            & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
            & 'del ' & @TempDir & '\scratch.bat'
    FileWrite(@TempDir & "\scratch.bat", $sCmdFile)
    Run(@TempDir & "\scratch.bat", @TempDir, @SW_HIDE)
EndFunc

#EndRegion - Internal -