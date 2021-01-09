Func _Open()
Global $OverWriteConfirm,$NoExtensionOverWriteConfirm,$Path,$RawPath,$RawHTML,$Open,$SavePath,$OpenFile,$CurrentPath

		$SavePath=$OpenFile
		if $SavePath="" and GUICtrlRead($RawHTML) <> "" Then
		$ask=MsgBox(52,"","You're now working on an unsaved source, open new source would erase the current" & @CRLF & "Do you want to save now ?")
		if $ask=6 Then
		_SaveAs()
		EndIf
		EndIf
		
		if FileRead($OpenFile)<>GUICtrlRead($RawHTML) and $SavePath<>"" Then
		$ask=MsgBox(52,"","Look like you've made some changes, want to save ?")
		if $ask=6 Then
		_SaveAs()
		EndIf
		EndIf
				
		
		$OpenFile=FileOpenDialog("WebScripts Supporter Opening ...","","Text files (*.txt)",2)
		$Data=FileRead($OpenFile)
		GUICtrlSetData($RawHTML,$Data)
		
		
		opt("WinTitleMatchMode",2)
		WinSetTitle("WebScripts Supporter ver1.0.0","","WebScripts Supporter ver1.0.0 [" & $OpenFile & "]")
		if $OpenFile="" Then
		WinSetTitle("WebScripts Supporter ver1.0.0","","WebScripts Supporter ver1.0.0")
			
		EndIf

		
		
		
EndFunc
