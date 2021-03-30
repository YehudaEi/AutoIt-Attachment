#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.10.2
	Author:         Muzaiyan Abbas
	Mail:           hello2mozi@gmail.com

	Script Function:
	(Build Uninstallers list)

#ce ----------------------------------------------------------------------------
; Script Start - Add your code below here

#include <Array.au3>
#include <File.au3>
#include <WinAPI.au3>

;1	name
;2	uninstall command
;3	version;
;4	size
;5	date
;6	icon
7;	install dir

;~ $array = _Collect_Uninstallers_List()
;~ For $i = 1 To UBound($array)-1
;~ 	$array_mini = StringSplit($array[$i],"|")
;~ 	_ArrayDisplay($array_mini)
;~ Next

Func _Collect_Uninstallers_List()
	Local $_returning_array
	$_returning_array = _ReadRegUninstall('HKLM')
	If StringInStr(@OSArch, '64') Then $_returning_array = _ReadRegUninstall('HKLM64')
	_ArraySort($_returning_array, 0, 0, 0, 0)
	Return $_returning_array
EndFunc   ;==>_Collect_Uninstallers_List

Func _ReadRegUninstall($_HKLM)
	Local $_returning_array2[1], $_UninstallParentFolder
	Local $_Index = 0, $_RegKey, $_EndKey = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
	While 1
		Local $_DisplayName = '', $_UninstallString = '', $_DisplayVersion = '', $_EstimatedSize = '', $_InstallLocation = '', $_InstallDate = '', $_DisplayIcon = ''
		$_Index += 1
		$_RegKey = RegEnumKey($_HKLM & $_EndKey, $_Index)
		If @error <> 0 Then ExitLoop

		#Region ------ DisplayName ------------------------------
		$_DisplayName = RegRead($_HKLM & $_EndKey & '\' & $_RegKey, 'DisplayName')
		#EndRegion ------ DisplayName ------------------------------

		#Region ------ UninstallString ------------------------------
		$_UninstallString = RegRead($_HKLM & $_EndKey & '\' & $_RegKey, 'UninstallString')
		If $_UninstallString = '' And StringLeft($_RegKey, 1) = '{' Then $_UninstallString = 'MsiExec.exe /X' & $_RegKey
		If StringInStr($_UninstallString, 'MsiExec') Then $_UninstallString = StringReplace($_UninstallString, '/I', '/X')
		#EndRegion ------ UninstallString ------------------------------

		If $_DisplayName <> '' And $_UninstallString <> '' And Not _AlreadyInArray($_returning_array2, $_DisplayName, 1, 1) Then

			#Region ------ DisplayVersion ------------------------------
			$_DisplayVersion = RegRead($_HKLM & $_EndKey & '\' & $_RegKey, 'DisplayVersion')
			#EndRegion ------ DisplayVersion ------------------------------

			#Region ------ InstallLocation ------------------------------
			$_InstallLocation = RegRead($_HKLM & $_EndKey & '\' & $_RegKey, 'InstallLocation')
			$_UninstallParentFolder = FileGetLongName(_GetParentFolderPathByUninstallCmd(StringReplace($_UninstallString, '"', '')))
			If $_InstallLocation = '' And StringInStr($_UninstallString, @ProgramFilesDir) Then $_InstallLocation = $_UninstallParentFolder
			$_InstallLocation = StringReplace($_InstallLocation, '"', '')
			If StringRight($_InstallLocation, 1) = '\' Then $_InstallLocation = StringTrimRight($_InstallLocation, 1)
			#EndRegion ------ InstallLocation ------------------------------

			#Region ------ EstimatedSize ------------------------------
			$_EstimatedSize = RegRead($_HKLM & $_EndKey & '\' & $_RegKey, 'EstimatedSize')
			If $_EstimatedSize = '' Then
				If FileExists($_InstallLocation) Then
					$_EstimatedSize = Ceiling(DirGetSize($_InstallLocation) / 1024)
				Else
					If FileExists($_UninstallParentFolder) Then $_EstimatedSize = Ceiling(DirGetSize($_UninstallParentFolder) / 1024)
				EndIf
			EndIf
			#EndRegion ------ EstimatedSize ------------------------------

			#Region ------ InstallDate ------------------------------
			$_InstallDate = RegRead($_HKLM & $_EndKey & '\' & $_RegKey, 'InstallDate')
			#EndRegion ------ InstallDate ------------------------------

			#Region ------ DisplayIcon ------------------------------
			$_DisplayIcon = StringReplace(RegRead($_HKLM & $_EndKey & '\' & $_RegKey, 'DisplayIcon'), '"', '')
			If StringRight($_DisplayIcon, 2) = ',0' Then $_DisplayIcon = StringTrimRight($_DisplayIcon, 2)
			If Not FileExists($_DisplayIcon) And StringInStr(FileGetAttrib($_InstallLocation), 'D') Then $_DisplayIcon = _GetExecutableIcon($_InstallLocation)
			If Not FileExists($_DisplayIcon) And StringInStr(FileGetAttrib($_UninstallParentFolder), 'D') Then $_DisplayIcon = _GetExecutableIcon($_UninstallParentFolder)
			If Not FileExists($_DisplayIcon) Then $_DisplayIcon = @WindowsDir & '\System32\MsiExec.exe'
			#EndRegion ------ DisplayIcon ------------------------------

			_ArrayAdd($_returning_array2, $_DisplayName & '|' & $_UninstallString & '|' & $_DisplayVersion & '|' & $_EstimatedSize & '|' & $_InstallDate & '|' & $_DisplayIcon & '|' & $_InstallLocation)
		EndIf
	WEnd
	Return $_returning_array2
EndFunc   ;==>_ReadRegUninstall
Func _AlreadyInArray($_SearchArray, $_Item, $_Start = 0, $_Partial = 0)
	Local $_Index
	$_Index = _ArraySearch($_SearchArray, $_Item, $_Start, 0, 0, $_Partial)
	If Not @error Then Return 1
EndFunc   ;==>_AlreadyInArray
Func _GetParentFolderPathByUninstallCmd($_UninstallCmd)
	Local $_I
	If Not _OneOfThisStringInStr($_UninstallCmd, 'MsiExec|RunDll32') Then
		For $_I = StringLen($_UninstallCmd) To 2 Step -1
			If StringInStr(FileGetAttrib(StringLeft($_UninstallCmd, $_I)), 'D') Then Return StringLeft($_UninstallCmd, $_I)
		Next
	EndIf
	Return ''
EndFunc   ;==>_GetParentFolderPathByUninstallCmd
Func _ExecutableHasAnIcon($_ExePath)
	Return _WinAPI_ExtractIconEx($_ExePath, -1, 0, 0, 0) <> 0
EndFunc   ;==>_ExecutableHasAnIcon

Func _OneOfThisStringInStr($_InStr, $_String)
	Local $_I, $_StringArray = StringSplit($_String, '|')
	If @error Then Return
	For $_I = 1 To UBound($_StringArray) - 1
		If StringInStr($_InStr, $_StringArray[$_I]) Then Return 1
	Next
EndFunc   ;==>_OneOfThisStringInStr
Func _GetExecutableIcon($_ParentFolder)
	Local $_ExeList
	If StringInStr(FileGetAttrib($_ParentFolder), 'D') Then
		$_ExeList = _FileListToArray($_ParentFolder, '*.exe')
		For $_I = 1 To UBound($_ExeList) - 1
			If FileExists($_ParentFolder & '\' & $_ExeList[$_I]) And Not StringInStr($_ExeList[$_I], 'unins') And _
					_ExecutableHasAnIcon($_ParentFolder & '\' & $_ExeList[$_I]) And FileGetSize($_ParentFolder & '\' & $_ExeList[$_I]) > 300000 Then
				Return $_ParentFolder & '\' & $_ExeList[$_I]
			EndIf
		Next
	EndIf
EndFunc   ;==>_GetExecutableIcon
