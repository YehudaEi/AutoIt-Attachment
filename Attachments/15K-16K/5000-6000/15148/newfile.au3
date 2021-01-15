#NoTrayIcon
#include <GUIConstants.au3>
Sleep(1000)

$title = "newFile"
$var = WinList()
#cs
For $i = 1 to $var[0][0] 
  ; Only display visble windows that have a title
  If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
    MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
  EndIf
Next
#ce
$dir=""
	For $i = 1 to $var[0][0]
	  ; Only display visble windows that have a title
	  ;If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
		;if StringInStr($var[$i][0],":") > 0 AND WinActive($var[$i][0]) Then
		if WinActive($var[$i][0]) AND IsVisible($var[$i][1]) AND $var[$i][0] <> "" Then
			;MsgBox(0,$var[$i][1],$var[$i][0])
			$dir = $var[$i][0]
			;MsgBox(0,"",$dir)
			ExitLoop
		EndIf
		;MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
	  ;EndIf
	Next


	if StringInStr($dir,":\") = 0 AND $dir <> "Documenti" AND $dir <> "Desktop" AND StringLeft($dir,2) <> "\\" Then
		$dir = _chooseFolder()
		;MsgBox(16,$title,"Directory error")
	
	EndIf
	
	if $dir = "Documenti" Then
		$dir = @MyDocumentsDir
	EndIf
	
	if $dir = "Desktop" Then
		$dir = @DesktopDir
	EndIf
	
	if StringRight($dir, 1) = "\" Then
		$dir = StringMid($dir,1,StringLen($dir)-1)
	EndIf

$open = 0
$autoDestroy = -1

if $cmdline[0] = 0 Then
	$file = "newfile_" & @YEAR & @MON & @MDAY & ".txt"

	if FileExists($dir & "\" & $file) Then
		;MsgBox(0,"","")
		$id = 1
		Do
			$file = "newfile_" & @YEAR & @MON & @MDAY & "_" & $id & ".txt"
			$id= $id +1
		Until FileExists($dir & "\" & $file) = 0
	EndIf
		
	
	$fileHandle= FileOpen($dir & "\" & $file, 9)
	FileClose($fileHandle)
ElseIf $cmdline[0] = 1 Then
	if $cmdline[1] = "\open" Or $cmdline[1] = "\o" Then
		$open = 1
		$file = "newfile_" & @YEAR & @MON & @MDAY & ".txt"
		if FileExists($dir & "\" & $file) Then
			$id = 1
			Do
				$file = "newfile_" & @YEAR & @MON & @MDAY & "_" & $id & ".txt"
				$id= $id +1
			Until FileExists($dir & "\" & $file) = 0
		EndIf
	Elseif StringLeft($cmdline[1],2) = "\d" Then
			if StringLen($cmdline[1]) > 2 Then
				$autoDestroy = StringMid($cmdline[1],3)
			Else
				$autoDestroy=30
			EndIf
			$file = "newfile_" & @YEAR & @MON & @MDAY & ".txt"
		if FileExists($dir & "\" & $file) Then
			$id = 1
			Do
				$file = "newfile_" & @YEAR & @MON & @MDAY & "_" & $id & ".txt"
				$id= $id +1
			Until FileExists($dir & "\" & $file) = 0
		EndIf
	Elseif StringLeft($cmdline[1],2) = "\clip" OR StringLeft($cmdline[1],2) = "\c" Then
		$open = 0
		$file = "newfile_" & @YEAR & @MON & @MDAY & ".txt"
		if FileExists($dir & "\" & $file) Then
			$id = 1
			Do
				$file = "newfile_" & @YEAR & @MON & @MDAY & "_" & $id & ".txt"
				$id= $id +1
			Until FileExists($dir & "\" & $file) = 0
		EndIf
		
			$fileHandle= FileOpen($dir & "\" & $file, 9)
			FileWrite($fileHandle, ClipGet())
			FileClose($fileHandle)
		;
		;
		;
	Else
		if StringInStr($cmdline[1],".") = 0 Then 
			$file = $cmdline[1] & ".txt"
		Else
			$file = $cmdline[1]
		EndIf
	EndIf
	
	$fileHandle= FileOpen($dir & "\" & $file, 9)
	FileClose($fileHandle)
ElseIf $cmdline[0] > 1 Then
	if $cmdline[1] = "\" Then 
		$file = "newfile_" & @YEAR & @MON & @MDAY & ".txt"
		if FileExists($dir & "\" & $file) Then
			$id = 1
			Do
				$file = "newfile_" & @YEAR & @MON & @MDAY & "_" & $id & ".txt"
				$id= $id +1
			Until FileExists($dir & "\" & $file) = 0
		EndIf
	Else
		if StringInStr($cmdline[1],".") = 0 Then 
			$file = $cmdline[1] & ".txt"
		Else
			$file = $cmdline[1]
		EndIf
	EndIf
	;MsgBox(0,"",$cmdline[0] & @CRLF & $cmdline[1] & @CRLF & $cmdline[2])
	$fileHandle= FileOpen($dir & "\" & $file, 9)
	for $i = 2 to $cmdline[0]
		if $cmdline[$i] = "\open" Or $cmdline[$i] = "\o" Then
			$open = 1
		Elseif StringLeft($cmdline[$i],2) = "\d" Then
			$autoDestroy = StringMid($cmdline[$i],3)
		Elseif $cmdline[$i] = "\clip" Or $cmdline[$i] = "\c" Then
			FileWriteLine($fileHandle, ClipGet())
		Else
			FileWriteLine($fileHandle, $cmdline[$i])
		EndIf
	Next
	
	FileClose($fileHandle)
EndIf

if $open = 1 Then
	Run("notepad.exe """ & $dir & "\" & $file & """")
EndIf


if FileExists($dir & "\" & $file) = 0 Then
	MsgBox(16,$title,"File create error")
EndIf 


if $autoDestroy > 0 Then
	Sleep($autoDestroy * 1000)
	FileDelete($dir & "\" & $file)
EndIf


Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc


Func _chooseFolder()
	
	$var = WinList()
	if StringInStr($dir,":\") = 0 AND $dir <> "Documenti" AND $dir <> "Desktop" AND StringLeft($dir,2) <> "\\" Then 
		$folderList = ""
		For $i = 1 to $var[0][0]
		  ; Only display visble windows that have a title
		  ;If $var[$i][0] <> "" AND IsVisible($var[$i][1]) Then
			;if StringInStr($var[$i][0],":") > 0 AND WinActive($var[$i][0]) Then
			
			if IsVisible($var[$i][1]) AND $var[$i][0] <> "" Then
				;MsgBox(0,$var[2][0],$folderList)
				;MsgBox(0,$var[$i][1],$var[$i][0])
				if StringInStr($var[$i][0],":\") > 0 OR $var[$i][0] = "Documenti" OR $var[$i][0] = "Desktop" OR StringLeft($var[$i][0],2) = "\\" Then
					$folderList = $folderList & "|" & $var[$i][0]
				EndIf
			EndIf
			;MsgBox(0, "Details", "Title=" & $var[$i][0] & @LF & "Handle=" & $var[$i][1])
		  ;EndIf
		Next
		;MsgBox(0,$var[2][0],$folderList)
		
		
		


		#Region ### START Koda GUI section ### Form=
		$Form1 = GUICreate("Folder list", 655, 165, 208, 362)
		$list = GUICtrlCreateList("", 8, 8, 633, 110)
		$Ok = GUICtrlCreateButton("Ok", 256, 128, 145, 25, $BS_DEFPUSHBUTTON)
		GUICtrlSetData($list, $folderList)
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $Ok
					$ret = GUICtrlRead($list)
					if $ret <> "" Then
						
						GUIDelete($Form1)
						Return $ret
						ExitLoop
					Else
						MsgBox(0,$title,"Select a folder")
					EndIf
				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
		WEnd
	EndIf
EndFunc