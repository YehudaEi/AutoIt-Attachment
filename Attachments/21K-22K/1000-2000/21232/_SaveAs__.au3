Func _SaveAs()
Global $OverWriteConfirm,$NoExtensionOverWriteConfirm,$Path,$RawPath,$RawHTML,$Open,$SavePath,$OpenFile,$CurrentPath
$File=FileSaveDialog("WebScripts Supporter Saving ...","","Text files (*.txt)",2)
$Extension=StringSplit($File,".")
$Extension=$Extension[$Extension[0]]

;------------------------------------------------
Select ; CHOOSE FROM LIST (MEANT FILE EXIST !)
	Case $Extension="txt"
		If FileExists($File) Then
			$OverWriteConfirm=MsgBox(68,"Confirm !","File is already exists !" & @CRLF & "Do you want to overwrite it ?")
		EndIf
	
		If $OverWriteConfirm=6 Then
			FileDelete($File);dsdsd.txt
			FileWrite($File,GUICtrlRead($RawHTML))
			FileClose($File)
			$SavePath=$File
		EndIf
EndSelect
;----------------------------



;----------------------------
Select ;  TYPE NAME (MEANT FILE DOESN'T EXIST !)
	Case $Extension<>"txt"
		If FileExists($File & ".txt") And $File<>""  Then
			$NoExtensionOverWriteConfirm=MsgBox(68,"Confirm !","File is already exists !" & @CRLF & "Do you want to overwrite it ?")
		EndIf
	
		If $NoExtensionOverWriteConfirm=6 Then
			FileDelete($File & ".txt");dsdsd.txt
			FileWrite($File & ".txt",GUICtrlRead($RawHTML))
			FileClose($File & ".txt")
			$SavePath=$File
		EndIf
		
		If $File<>"" Then
			FileWrite($File & ".txt",GUICtrlRead($RawHTML))
			FileClose($File & ".txt")
			$SavePath=$File
		EndIf
EndSelect
;----------------------------


EndFunc