#Include <Array.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>

Opt ('MustDeclareVars', 1)
ProcessSetPriority (StringTrimleft(@AutoItExe, StringInStr(@AutoItExe, '\', 0, -1)), 0)


Global $MacrosForKeys[26]

ShowToolTip("MacroRecorder Startup")
Sleep(1000)
ShowToolTip("")

Local $array
$array = ProcessList("MacroRecorder.exe")

If @compiled Then
	If $array[0][0] > 1 Then
		MsgBox(4096,"","Macro Recorder is already running.")
		Exit
	EndIf
Else
	If $array[0][0] > 0 Then
		MsgBox(4096,"","Macro Recorder is already running.")
		Exit
	EndIf
EndIf



Local $Count
For $Count = 1 to 26
	$MacrosForKeys[$Count-1] = ""
Next

Global $Done = False, $MacroString = "", $Save = False, $RecordForKey = ""
HotKeySet("^{F11}", "Abort")

;When we first run, the only active keys should be:
;CTRL-M to record
;CTRL-L to LOAD/SAVE
;CTRL-F11 to Exit
HotKeySet("^l","EditMacros")
HotKeySet("^m","BeginRecord")
HotKeySet("{F11}", "NextKeyIsPlayback")

Do
	Sleep(10)
Until $Done

Exit

Func NextKeyIsPlayback()
	SetNextKeyIsPlayBack(True)
EndFunc

Func CancelPlaybackKeyPressed()
	SetNextKeyIsPlayBack (False)
	ShowToolTip("Playback Cancelled")
	Sleep(500)
	ShowToolTip("")
EndFunc

Func SetNextKeyIsPlayBack( $On )
	Local $Count
	For $Count = 1 to 26
		If $On Then
			HotKeySet(chr($Count+64),"PlaybackKeyPressed")
			HotKeySet(chr($Count+96),"PlaybackKeyPressed")
		Else
			HotKeySet(chr($Count+64))
			HotKeySet(chr($Count+96))
		EndIf
	Next

	If $On Then 
		HotKeySet("{F11}") 									;Turn off F11
		HotKeySet("^l")										;CTRL-L Off
		HotKeySet("^m")										;CTRL-M Off
		HotKeySet("{ESC}","CancelPlaybackKeyPressed") 		;ESC to Cancel
		ShowToolTip("Press playback key, ESC to cancel")
	Else
		HotKeySet("{F11}", "NextKeyIsPlayback") 			;Turn F11 Back On
		HotKeySet("^l","EditMacros")						;CTRL-L Back On
		HotKeySet("^m","BeginRecord")						;CTRL-M Back On
		HotKeySet("{ESC}")									;ESC OFF
	EndIf
	

EndFunc

Func PlaybackKeyPressed()
	SetNextKeyIsPlayBack(False)

	Local $mKey = @HotKeyPressed
	Local $mString
	
	$mKey = StringUpper($mKey)
	$mString = $MacrosForKeys[Asc($mKey)-65]
	$mString = ReplaceInLineCalls($mString)
	
	If $mString <> "" Then
		ShowToolTip("PLAYBACK " & $mKey)
		BlockInput(1)
		Send($mString)
		BlockInput(0) 
		ShowToolTip("DONE PLAYBACK -" & $mKey)
		Sleep(500)
		ShowToolTip("")
	Else
		ShowToolTip("NOTHING TO PLAYBACK -" & $mKey)
		Sleep(500)
		ShowToolTip("")
	EndIf
	
EndFunc

Func ReplaceInLineCalls($mLine)
	Local $RetVal = $mLine, $Count, $Chars, $NewVal = ""
	
	For $Count = 1 to 26
		$Chars = "//" & chr($Count+64) ;//Abs
		If StringInStr($RetVal,$Chars) <> 0 Then
			$NewVal = $MacrosForKeys[$Count-1]
			$RetVal = StringReplace($RetVal,$Chars,$NewVal)
		EndIf
	Next
	
	Return $RetVal
EndFunc

Func SetHotKeys( $On)
	Local $Count, $fKeyName

	For $Count = 65 to 65+25 ;A thru Z
		If $On Then 
			HotKeySet(chr($Count),"RecKey")
		Else
			HotKeySet(chr($Count))
		EndIf
		
	Next
	
	
	For $Count = 1 to 10
		$fKeyName = "{F" & $Count & "}"
		If $On Then 
			HotKeySet($fKeyName,"RecKey")
		Else
			HotKeySet($fKeyName)
		EndIf

	Next
	
	For $Count = 33 to 64 ;!"#$%&'()*+,-./0123456789:;<=>?@
		If $On Then 
			HotKeySet(chr($Count),"RecKey")
			HotKeySet("^" & CHR($Count), "RecKey")  ;ctrl + 'letter'
		Else
			HotKeySet(chr($Count))
			HotKeySet("^" & CHR($Count))  ;ctrl + 'letter'
		EndIf
	Next
	
	
	;Special Keys Here
	If $On Then
		HotKeySet("{!}","RecKey")
		HotKeySet("{#}","RecKey")
		HotKeySet("{+}","RecKey")
		HotKeySet("{^}","RecKey")
		HotKeySet("{{}","RecKey")
		HotKeySet("{}}","RecKey")
		HotKeySet("_","RecKey")
		HotKeySet("`","RecKey")
		HotKeySet("~","RecKey")
		
	Else
		HotKeySet("{!}")
		HotKeySet("{#}")
		HotKeySet("{+}")
		HotKeySet("{^}")
		HotKeySet("{{}")
		HotKeySet("{}}")
		HotKeySet("_")
		HotKeySet("`")
		HotKeySet("~")
	EndIf

	For $Count = 97 to 97+25 ;a thru z
		
		If $On Then 
			HotKeySet(chr($Count),"RecKey")
			If $Count <> 109 and $Count <> 108 Then ;Do not touch CTRL-M ort CTRL-L
				HotKeySet("^" & CHR($Count), "RecKey")  ;ctrl + 'letter'
			EndIf

		Else
			HotKeySet(chr($Count))
			If $Count <> 109 and $Count <> 108 Then ;Do not touch CTRL-M ort CTRL-L
				HotKeySet("^" & CHR($Count))  ;ctrl + 'letter'
			EndIf
		EndIf
	Next


	If ($On) Then
		HotKeySet("{F11}", "AltTab")
	Else
		HotKeySet("{F11}")
	EndIf
	

	Local $Prefix = ""

	For $Count = 1 to 4
		;Shift
		;Ctrl
		;CtrlSift
		If $Count = 1 Then $Prefix = ""
		If $Count = 2 Then $Prefix = "+"
		If $Count = 3 Then $Prefix = "^"
		If $Count = 4 Then $Prefix = "^+"

		If $On Then
			HotKeySet($Prefix & "{SPACE}","RecKey")
			HotKeySet($Prefix & "{ENTER}","RecKey")
			HotKeySet($Prefix & "{TAB}","RecKey")
			HotKeySet($Prefix & "{BACKSPACE}","RecKey")
			HotKeySet($Prefix & "{DELETE}","RecKey")
			HotKeySet($Prefix & "{UP}","RecKey")
			HotKeySet($Prefix & "{DOWN}","RecKey")
			HotKeySet($Prefix & "{LEFT}","RecKey")
			HotKeySet($Prefix & "{RIGHT}","RecKey")
			HotKeySet($Prefix & "{HOME}","RecKey")
			HotKeySet($Prefix & "{END}","RecKey")
			HotKeySet($Prefix & "{ESCAPE}","RecKey")
			HotKeySet($Prefix & "{INSERT}","RecKey")
			HotKeySet($Prefix & "{PGUP}","RecKey")
			HotKeySet($Prefix & "{PGDN}","RecKey")
		Else
			HotKeySet($Prefix & "{SPACE}")
			HotKeySet($Prefix & "{ENTER}")
			HotKeySet($Prefix & "{TAB}")
			HotKeySet($Prefix & "{BACKSPACE}")
			HotKeySet($Prefix & "{DELETE}")
			HotKeySet($Prefix & "{UP}")
			HotKeySet($Prefix & "{DOWN}")
			HotKeySet($Prefix & "{LEFT}")
			HotKeySet($Prefix & "{RIGHT}")
			HotKeySet($Prefix & "{HOME}")
			HotKeySet($Prefix & "{END}")
			HotKeySet($Prefix & "{ESCAPE}")
			HotKeySet($Prefix & "{INSERT}")
			HotKeySet($Prefix & "{PGUP}")
			HotKeySet($Prefix & "{PGDN}")

			HotKeySet("^+{RIGHT}") ;CTRL-SHIFT-RIGHT
		EndIf

	Next

EndFunc

Func AltTab()

	ShowToolTip("ALT-TAB")
	$MacroString = $MacroString & "{ALTDOWN}{TAB}{ALTUP}"
	Send("!{TAB}")
	
EndFunc

Func BeginRecord()
	ShowToolTip("CTRL-M Pressed")

	HotKeySet("^l") ;Turn Off CTRL-L
	HotKeySet("^m") ;Turn Off CTRL-M
	HotKeySet("{F11}") ;Turn off F11

	Local $KeyToAssign = ""
	Local $Done = False
	Do
		$KeyToAssign = InputBox("","Assign to which key?","")
	
		If $KeyToAssign <> "" Then
			If StringLen($KeyToAssign) = 1 Then
				$RecordForKey = $KeyToAssign
				$RecordForKey = StringUpper($RecordForKey)
				If $MacrosForKeys[Asc($RecordForKey)-65] <> "" Then
					If MsgBox(4096+1,"","Overwrite current macro for this key?") = 1 Then
						SetHotKeys(True)
						HotKeySet("^m","")
						HotKeySet("^m","EndRecord")
						$Done = True
						ShowToolTip("RECORDING " & $RecordForKey )
					EndIf
				Else
					SetHotKeys(True)
					HotKeySet("^m","")
					HotKeySet("^m","EndRecord")
					$Done = True
					ShowToolTip("RECORDING " & $RecordForKey )
				EndIf
			Else
				MSgBox(4096, "", "Please provide only one key")
			EndIf
		Else
			MsgBox(4096,"","Macro Record Cancelled")
			HotKeySet("^l","EditMacros")
			HotKeySet("^m","BeginRecord")
			HotKeySet("{F11}", "NextKeyIsPlayback")
			ShowToolTip("")
			$Done = True
		EndIf
	Until $Done
	
EndFunc	

Func EndRecord()
	SetHotKeys(False)
	HotKeySet("^m","")
	HotKeySet("^l","EditMacros")
	HotKeySet("^m","BeginRecord")
	HotKeySet("{F11}", "NextKeyIsPlayback")

	ShowToolTip("DONE RECORDING -" & $RecordForKey)

	$MacrosForKeys[Asc($RecordForKey)-65] = $MacroString
	$MacroString = ""
	Sleep(1000)
	ShowToolTip("")

EndFunc

Func Abort()
	ShowToolTip("CTRL-F11 Pressed MacroRecorder Exit")
	Sleep(1000)
	$Done = True
EndFunc

Func Save()
	$Done = True
	$Save = True
EndFunc


Func RecKey()
	ShowToolTip("RECORDING -" & $RecordForKey & " NewKey = " & @HotKeyPressed)
	$MacroString = $MacroString & @HotKeyPressed
	HotKeySet(@HotKeyPressed)
	Send(@HotKeyPressed)
	HotKeySet(@HotKeyPressed,"RecKey")
EndFunc


Func ShowToolTip($mText)
	ToolTip("")
	ToolTip($mText,@DesktopWidth/2,@DesktopHeight-20,"",0,4)
EndFunc


Func EditMacros()

	;When we enter this function, turn off CTRL-L and CTRL-M
	HotKeySet("^l")
	HotKeySet("^m")

	Local $ListBox
	Local $Load_Btn, $Save_Btn, $Record_Btn, $Edit_Btn, $Done_Btn
	Local $Count, $msg

	GUICreate("Macro Maintenance", 410, 250)

	$ListBox = GUICtrlCreateList("",10,10,390,190)

	For $Count = 1 to 26
		If $MacrosForKeys[$Count-1] <> "" Then
			GUICtrlSetData($ListBox, chr($Count+64) & " = " & $MacrosForKeys[$Count-1])
		Else
			GUICtrlSetData($ListBox, chr($Count+64))
		EndIf
	Next

	
	$Load_Btn =  GUICtrlCreateButton("Load", 10, 210, 70, 25)
	$Save_Btn =  GUICtrlCreateButton("Save", 10+(80*1), 210, 70, 25)
	$Edit_Btn =  GUICtrlCreateButton("Edit", 10+(80*3), 210, 70, 25)
	$Done_Btn =  GUICtrlCreateButton("Done", 10+(80*4), 210, 70, 25)

	GUISetState(@SW_SHOW)

	Local $Done = False, $CurSel, $NewValue, $Index, $CurLetter
	Local $FileName, $Continue = True

	While Not $Done
		$msg = GUIGetMsg()

		Select

			Case $msg = $GUI_EVENT_CLOSE
				$Done = True

			Case $msg = $Done_Btn
				$Done = True

			Case $msg = $Save_Btn
				$FileName = FileSaveDialog("Please select macro file to save",".\","Macro Files (*.ini)", 1 + 4)
				If $FileName <> "" Then
					If FileExists($FileName) Then
						If MsgBox(4096+4, "Overwrite?", "Macro file already exists, overwrite?") = 1 Then
							FileDelete($FileName)
							$Continue = True
						EndIf
					EndIf
					If $Continue Then
						For $Count = 0 to 25
							$NewValue =	$MacrosForKeys[$Count] 
							IniWrite ( $FileName, "KEYS", chr(65+$Count), $NewValue )
						Next
					EndIf
				EndIf

			Case $msg = $Load_Btn
				$FileName = FileOpenDialog("Please select macro file",".\","Macro Files (*.ini)", 1 + 4)
				If $FileName <> "" Then
					For $Count = 0 to 25
						$NewValue = IniRead ( $FileName, "KEYS", chr(65+$Count), "" )
						If $NewValue <> "" Then
							_GUICtrlListBox_ReplaceString($ListBox, $Count, chr(65+$Count) & " = " & $NewValue)
							$MacrosForKeys[$Count] = $NewValue
						Else
							_GUICtrlListBox_ReplaceString($ListBox, $Count, chr(65+$Count))
							$MacrosForKeys[$Count] = ""
						EndIf
					Next
				Endif
					
				

			Case $msg = $Edit_Btn
				$CurSel = GUICtrlRead($ListBox)
				If $CurSel <> "" Then
					$CurLetter = StringMid($CurSel,1,1)
					$Index = Asc($CurLetter) - 65
					$CurSel = StringMid($CurSel,5)
					$NewValue = InputBox("","",$CurSel)
					If $NewValue <> "" Then
						_GUICtrlListBox_ReplaceString($ListBox, $Index, chr(65+$Index) & " = " & $NewValue)
						$MacrosForKeys[$Index] = $NewValue
					Else
						;Blank Return
						If @error = 0 Then ;Intentional Blank 
							_GUICtrlListBox_ReplaceString($ListBox, $Index, chr(65+$Index))
							$MacrosForKeys[$Index] = ""
						EndIf
					EndIf
				EndIf

			EndSelect
	WEnd
	
	GUIDelete()
	HotKeySet("^l","EditMacros")
	HotKeySet("^m","BeginRecord")
	HotKeySet("{F11}","NextKeyIsPlayback")


EndFunc   ;==>_Main
