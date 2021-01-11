;Fileinstall Script Creator
;Author: The Kandie Man
#include <file.au3>
;IMPORTANT
;The second parameter of the GetFiles function must be 100% string.  You may not place a macro in it unless it is also in the string!
;Do NOT leave trailing slashes at the end of the path name on the second parameter!
;All subdirectories and files in the subdirectories will be installed from the folder specified in the first parameter
GetFiles(@ScriptDir & "\My Application Folder\", "@ProgramFilesDir & '\My Application Install Folder'")
Func GetFiles($path, $v_installpath = "@Tempdir & '\au3installtmp'")
	If StringRight($path, 1) = "\" Or StringRight($path, 1) = "/" Then
		$path = StringTrimRight($path, 1)
	EndIf
	$handle = FileOpen("installer.au3", 1)
	FileWriteLine($handle, 'SplashTextOn("Installing...","The program is being installed, please wait...","350","25","-1","-1",18,"Arial","","")')
	FileWriteLine($handle, 'If Not FileExists(' & $v_installpath & "&'\') Then " & 'DirCreate(' & $v_installpath & '&"\")')
	$array = _FileListToArray($path, "*", 1)
	For $counter = 1 To UBound($array) - 1
		FileWriteLine($handle, 'FileInstall("' & $path & "\" & $array[$counter] & '",' & $v_installpath & '&"\' & $array[$counter] & '",1)')
	Next
	$arrayfolders = _FileListToArray($path, "*", 2)
	Dim $foldercounter
	Dim $filecounter
	For $foldercounter = 1 To UBound($arrayfolders) - 1
		$arrayfiles = _FileListToArray($path & "\" & $arrayfolders[$foldercounter], "*", 1)
		FileWriteLine($handle, 'DirCreate ( ' & $v_installpath & '&"\' & $arrayfolders[$foldercounter] & '")')
		If IsArray($arrayfiles) Then
			For $filecounter = 1 To $arrayfiles[0]
				FileWriteLine($handle, 'FileInstall("' & $path & "\" & $arrayfolders[$foldercounter] & "\" & $arrayfiles[$filecounter] & '",' & $v_installpath & '&"\' & $arrayfolders[$foldercounter] & '\' & $arrayfiles[$filecounter] & '",1)')
			Next
		EndIf
		$arrayfiles = ""
		$test = _FileListToArray($path & "\" & $arrayfolders[$foldercounter], "*", 2)
		If IsArray($test) Then
			GETSubDirectories($path & "\" & $arrayfolders[$foldercounter], $path, $handle, $v_installpath)
		EndIf
		$test = ""
	Next
	FileWriteLine($handle, "SplashOff()")
	FileClose($handle)
EndFunc   ;==>GetFiles
Func GETSubDirectories($v_dir, $path, $handle, $v_installpath)
	$av_folderarray = _FileListToArray($v_dir, "*", 2)
	For $foldercounter = 1 To UBound($av_folderarray) - 1
		$arrayfiles = _FileListToArray($v_dir & "\" & $av_folderarray[$foldercounter], "*", 1)
		FileWriteLine($handle, 'DirCreate ( ' & $v_installpath & '&"\' & StringReplace($v_dir, $path & "\", "") & "\" & $av_folderarray[$foldercounter] & '")')
		If IsArray($arrayfiles) Then
			For $filecounter = 1 To $arrayfiles[0]
				FileWriteLine($handle, 'FileInstall("' & $v_dir & "\" & $av_folderarray[$foldercounter] & "\" & $arrayfiles[$filecounter] & '",' & $v_installpath & '&"\' & StringReplace($v_dir, $path & "\", "") & "\" & $av_folderarray[$foldercounter] & '\' & $arrayfiles[$filecounter] & '",1)')
			Next
		EndIf
		$arrayfiles = ""
		$test = _FileListToArray($v_dir & "\" & $av_folderarray[$foldercounter], "*", 2)
		If IsArray($test) Then
			GETSubDirectories($v_dir & "\" & $av_folderarray[$foldercounter], $path, $handle, $v_installpath)
		EndIf
		$test = ""
	Next
EndFunc   ;==>GETSubDirectories