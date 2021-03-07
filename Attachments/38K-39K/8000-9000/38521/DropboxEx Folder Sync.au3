#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_icon=Dropbox.ico
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>
#include <Array.au3>


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
	local $iStatus = FileCreateNTFSLink($sSourceDir, $sDestination, $iFlag)

If @error Then
	MsgBox(4096,"Error " & $iStatus, "Can't Create Hardlinks !")
Else
	MsgBox(0,"Status " & $iStatus,"Hardlinks Created ! ")
EndIf