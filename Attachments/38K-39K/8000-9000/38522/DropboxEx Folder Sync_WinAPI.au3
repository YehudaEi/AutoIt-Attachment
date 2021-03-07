#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_icon=DropboxEx.ico
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#RequireAdmin
#include <File.au3>
#include <Array.au3>
#Include <APIConstants.au3>
#Include <WinAPIEx.au3>

Global $hToken, $aAdjust

Const $sDropboxDir = @UserProfileDir & "\Dropbox\External"
Const $sSourceDir = FileSelectFolder("Choose a folder.", "")

If @error Then
	Exit
EndIf

Dim $szDrive, $szDir, $szFName, $szExt
Dim $sPath = ""
Dim $sDestination = ""
Dim $aPath = _PathSplit($sSourceDir, $szDrive, $szDir, $szFName, $szExt)
Dim $iFlag = 1 ; overwrite

; Enable "SeCreateSymbolicLinkPrivilege" privilege to create a symbolic links
$hToken = _WinAPI_OpenProcessToken(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
_WinAPI_AdjustTokenPrivileges($hToken, $SE_CREATE_SYMBOLIC_LINK_NAME, $SE_PRIVILEGE_ENABLED, $aAdjust)

If @error Or @extended Then
    MsgBox(16, 'Error', 'You do not have the required privileges.')
    Exit
EndIf

For $i=0 To UBound($aPath)-1

	If $i < 2 then ContinueLoop

	$sPath = $sPath & $aPath[$i]

	; Create Dropbox Dir.
	If Not FileExists ($sDropboxDir & $sPath) Then

		;ConsoleWrite("Dir Created ? " & DirCreate($sDropboxDir & $sPath) & @CRLF)
		ConsoleWrite($i & " " & $sDropboxDir & $sPath& @CRLF)
	EndIf
Next

	$sDestination = $sDropboxDir & $sPath

	;ConsoleWrite("Data From " & '"' &  $sSourceDir & '"' & " To "  & '"' & $sDestination & '"' & @CRLF)
		Sleep(1000)
	_WinAPI_CreateSymbolicLink($sDestination, $sSourceDir, 1)

If @error Then
	MsgBox(4096,"Error ", "Can't Create Hardlinks !")
	_WinAPI_ShowLastError()
Else
	MsgBox(0,"Status ", "Hardlinks Created ! ")
EndIf

; Restore "SeCreateSymbolicLinkPrivilege" privilege by default
_WinAPI_AdjustTokenPrivileges($hToken, $aAdjust, 0, $aAdjust)
_WinAPI_CloseHandle($hToken)