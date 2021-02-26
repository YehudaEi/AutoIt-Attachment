#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; VnComp.au3
; compare file versions in a folder for exe and dll files
; files with no version will have version "0.0.0.0", matching such files will be considered to have the same version

#Include <File.au3>
#include <Array.au3>

Dim $Folder1
Dim $Folder2

Dim $bOnlyDifferences = False
Dim $bOnlyCommon = False
Dim $bRecursive = False

Dim $OutCommon = ""
Dim $OutDifferent = ""

;Dim $DEBUG = True
Dim $DEBUG = False


Main()

Func Main()
	if not ReadInputParms() Then
		ShowUsage ( "missing folder" )
		Exit
	EndIf

	CompareFilesInFolders ( $Folder1, $Folder2 )

EndFunc

Func CompareFilesInFolders ( $Fld1, $Fld2)
	Dim $File1Version
	Dim $File2Version
	Dim $arFileList1 = _FileListToArray ( $Fld1, "*", 1 )
	Dim $arFileList2 = _FileListToArray ( $Fld2, "*", 1 )
	Dim $FileList2 = _ArrayToString ( $arFileList2, "*" )
	if StringLen ( $FileList2 ) > 0 Then $FileList2 = "*" & $FileList2 & "*"
	Dim $arFolderList1 = _FileListToArray ( $Fld1, "*", 2 )
	Dim $arFolderList2 = _FileListToArray ( $Fld2, "*", 2 )
	for $i = 1 to $arFileList1 [ 0 ]
		; check if the file exists in folder $Folder2
		if StringInStr ( $FileList2, "*" & $arFileList1 [ $i ] & "*" ) > 0 Then
			$File1Version = FileGetVersion ( $Fld1 & "\" & $arFileList1 [ $i ] )
			$File2Version = FileGetVersion ( $Fld2 & "\" & $arFileList1 [ $i ] )
			if $File1Version = $File2Version Then
				$OutCommon &= @CRLF & $Fld1 & "\" & $arFileList1 [ $i ] & "+" & $Fld2 & "\" & $arFileList1 [ $i ] & ":" & $File1Version
				$FileList2 = StringReplace ( $FileList2, "*" & $arFileList1 [ $i ] & "*", "*" )
			Else
				$OutDifferent &= @CRLF & $Fld1 & "\" & $arFileList1 [ $i ] & ":" & $File1Version & ";" & $Fld2 & "\" & $arFileList1 [ $i ] & ":" & $File2Version
			EndIf
		Else
			$OutDifferent &= @CRLF & $Fld2 & "\" & $arFileList1 [ $i ] & " was not found"
		EndIf
	Next
	$arFileList2 = StringSplit ( $FileList2, "*" )
	for $i = 2 to $arFileList2 [ 0 ] - 1
		$OutDifferent &= @CRLF & $Fld1 & "\" & $arFileList2 [ $i ] & " was not found"
	Next

	if $bRecursive Then
		Dim $FolderList2 = "*" & _ArrayToString ( $arFolderList2, "*" ) & "*"
		for $i = 1 to $arFolderList1 [ 0 ]
			if StringInStr ( $FolderList2, "*" & $arFolderList1 [ $i ] & "*" ) > 0 Then
				CompareFilesInFolders ( $Fld1 & "\" & $arFolderList1, $Fld2 & "\" & $arFolderList1 )
				$FolderList2 = StringReplace ( $FolderList2, "*" & $arFolderList1 [ $i ] & "*", "*" )
			Else
				$OutDifferent &= @CRLF & "The folder '" & $Fld2 & "\" & $arFolderList1 & "' does not exist"
			EndIf
		Next
	EndIf
	if $bOnlyCommon Then
		ConsoleWrite ( @LF & "common:" & $OutCommon )
	EndIf
	if $bOnlyDifferences Then
		ConsoleWrite ( @LF & "---------------------" & @LF & "different:" & $OutDifferent)
	EndIf
	if Not $bOnlyCommon And Not $bOnlyDifferences Then
		ConsoleWrite ( @LF & "common:" & $OutCommon )
		ConsoleWrite ( @LF & "---------------------" & @LF & "different:" & $OutDifferent)
	EndIf
EndFunc

Func ReadInputParms()
	if $DEBUG Then
		$Folder1 = "C:\micropress\common"
		$Folder2 = "\\jeffhenk-7\MicroPress\Common"
	Else
		if $CmdLine [ 0 ] < 2 Then Return False
		for $i = 1 to $CmdLine [ 0 ]
			Switch $CmdLine [ $i ]
				case "/d", "-d"
					$bOnlyDifferences = True
				case "/c", "-c"
					$bOnlyCommon = True
				case "/r", "-r"
					$bRecursive = True
				case "/?", "-?"
					ShowUsage ( "" )
					Exit
				case Else
					if StringLen ( $Folder1 ) = 0 Then
						$Folder1 = $CmdLine [ 1 ]
					Elseif StringLen ( $Folder2 ) = 0 Then
						$Folder2 = $CmdLine [ 2 ]
					EndIf
			EndSwitch
		Next
	EndIf
	if Not FileExists ( $Folder1 ) Then
		MsgBox(0,"","1")
		Return False
	EndIf
	if Not FileExists ( $Folder2 ) Then
		MsgBox(0,"","2")
		Return False
	EndIf
	Return True
EndFunc

Func ShowUsage ( $Msg )
	Dim $Buf = $Msg & @LF
	$Buf &= "Compare File Versions" & @LF & "VnComp.exe" & @LF & "Usage:" & @LF
	$Buf &= "VnComp <Folder1> <Folder2> [-c] [-d] [-r]" & @LF
	$Buf &= "Folder1 (mandatory): folder where file versions need comparison" & @LF
	$Buf &= "Folder2 (mandatory): folder where reference files are found" & @LF
	$Buf &= "/c, -c (optional): show the files with same version" & @LF
	$Buf &= "/d, -d (optional): show the files with different version" & @LF
	$Buf &= "/r, -r (optional): compare files in subfolders" & @LF
	ConsoleWrite ( @LF & $Buf )
EndFunc