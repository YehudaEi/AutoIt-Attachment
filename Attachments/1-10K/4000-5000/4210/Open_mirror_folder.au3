; Open mirror folder
; Place in directory context menu
; Opens folder structure on another drive
; i.e. C:\folder1\folder2\ -> E:\folder1\folder2\

If $CmdLine[0] = 0 Then Exit 1

$copyto = FileSelectFolder ("Root of mirror folder:", "")
If StringRight ($copyto, 1) = "\" Then $copyto = StringTrimRight ($copyto, 1)
If $copyto = "" Then Exit 1

For $i = 1 To $CmdLine[0]
	$file = FileGetLongName ($CmdLine [$i])
	$p = StringLen ($file)
	$tree2 = ""
	If StringMid ($file, 2, 1) = ":" Then
		$tree = StringMid ($file, 3, $p - 2)
	ElseIf StringLeft ($file, 2) = "\\" Then
		$q = StringInstr ($file, "\", 0, 3) + 1
		$tree = StringMid ($file, $q - 1, $p - $q + 2)
		; check if \\server\share\folder2\ -> z:\folder2\ where z: is the destination
		$q = StringInstr ($file, "\", 0, 4) + 1
		If $q > 1 Then $tree2 = StringMid ($file, $q - 1, $p - $q + 2)
	Else
		$tree = StringLeft ($file, $p - 1)
	EndIf
;~ 	MsgBox (0, "", $tree)
	$ok = 0
	If Not FileExists ($copyto & $tree) Then
		If $tree2 <> "" And FileExists ($copyto & $tree2) Then
			;MsgBox (0, "", $copyto & $tree2 & " exists")
			Run ('explorer.exe "' & $copyto & $tree2 & '"')
		Else
			$ans = MsgBox(0, "Mirror folder", "Folder structure " & $copyto & $tree & " does not exist.")
		EndIf
	Else
		Run ('explorer.exe "' & $copyto & $tree & '"')
	EndIf
Next
	