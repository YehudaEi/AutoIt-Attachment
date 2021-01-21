; Mirror folder
; Place in SendTo menu
; Copies items to another drive that has the same folder structure
; i.e. C:\folder1\folder2\file.ext -> E:\folder1\folder2\file.ext

If $CmdLine[0] = 0 Then Exit 1

$copyto = FileSelectFolder ("Choose destination root", "")
If StringRight ($copyto, 1) = "\" Then $copyto = StringTrimRight ($copyto, 1)
If $copyto = "" Then Exit 1

For $i = 1 To $CmdLine[0]
	$file = FileGetLongName ($CmdLine [$i])
	$p = StringInStr ($file, "\", 0, -1)
	If StringMid ($file, 2, 1) = ":" Then
		$tree = StringMid ($file, 3, $p - 2)
	ElseIf StringLeft ($file, 2) = "\\" Then
		$q = StringInstr ($file, "\", 0, 3) + 1
		$tree = StringMid ($file, $q - 1, $p - $q + 2)
	Else
		$tree = StringLeft ($file, $p - 1)
	EndIf
;~ 	MsgBox (0, "", $tree)
	$ok = 0
	If Not FileExists ($copyto & $tree) Then
		$ans = MsgBox(4, "Mirror folder", "Folder structure " & $copyto & $tree & " does not exist. Create it?")
		If $ans = 6 Then ;yes
			DirCreate ($copyto & $tree)
			$ok = 1
		Else
			$ok = 0
		EndIf
	Else
		$ok = 1
	EndIf
	
	If $ok = 1 Then
		If StringInStr (FileGetAttrib ($file), "D") > 0 Then
			$res = DirCopy ($file, $copyto & $tree)
		Else
			$res = FileCopy ($file, $copyto & $tree)
		EndIf
		If $res = 0 Then
			MsgBox (0, "", "Mirror folder", "Error copying " & $file & " to " & $copyto & $tree)
		EndIf
	EndIf
Next
	