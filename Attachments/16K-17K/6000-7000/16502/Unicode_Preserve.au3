#include <GUIConstants.au3>
Global $StartComment = 0
Global $EndComment = 0
Global $Double = 0
Global $Single = 0
Global $UnicodeString
Global $Unicode
Global $LineTemp = ""

$UnicodePreserve = GUICreate ("Unicode Preserve", 468, 180, -1, -1)
GUISetBkColor (0xB6D9FC)
$Button1 = GUICtrlCreateButton ("Convert", 104, 144, 75, 25, 0)
GUICtrlSetCursor (-1, 0)
$Label1 = GUICtrlCreateLabel ("Source Path:", 8, 24, 66, 17)
$Label2 = GUICtrlCreateLabel ("Target Path:", 8, 64, 63, 17)
$Input1 = GUICtrlCreateInput ("", 80, 16, 289, 21, BitOR ($ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetColor (-1, 0x800000)
GUICtrlSetBkColor (-1, 0xB9D3B8)
$Input2 = GUICtrlCreateInput ("", 80, 56, 289, 21)
GUICtrlSetColor (-1, 0x800000)
GUICtrlSetBkColor (-1, 0xB9D3B8)
$Button2 = GUICtrlCreateButton ("Exit", 288, 145, 75, 25, 0)
GUICtrlSetCursor (-1, 0)
$Progress1 = GUICtrlCreateProgress (29, 120, 369, 12)
GUICtrlSetResizing (-1, $GUI_DOCKAUTO)
$Label3 = GUICtrlCreateLabel ("O %", 416, 120, 36, 17)
$Checkbox1 = GUICtrlCreateCheckbox ("Restore to original script", 56, 88, 137, 17)
$Checkbox2 = GUICtrlCreateCheckbox ("Allways Topmost", 248, 88, 97, 17)
$Button3 = GUICtrlCreateButton ("Browse", 384, 16, 67, 21, 0)
GUICtrlSetCursor (-1, 0)
$Button4 = GUICtrlCreateButton ("Browse", 384, 57, 67, 21, 0)
GUICtrlSetCursor (-1, 0)
GUISetState (@SW_SHOW)

GUICtrlSetData ($Input1, IniRead ("Settings.ini", "Settings", "SourcePath", ""))
GUICtrlSetData ($Input2, IniRead ("Settings.ini", "Settings", "TargetPath", ""))
GUICtrlSetState ($Checkbox1, IniRead ("Settings.ini", "Settings", "RestoreScript", ""))
If GUICtrlRead ($Checkbox1) = 1 Then
	GUICtrlSetData ($Button1, "Restore")
Else
	GUICtrlSetData ($Button1, "Convert")
EndIf
GUICtrlSetState ($Checkbox2, IniRead ("Settings.ini", "Settings", "TopMost", ""))
If GUICtrlRead ($Checkbox2) = 1 Then
	WinSetOnTop ($UnicodePreserve, "", 1)
Else
	WinSetOnTop ($UnicodePreserve, "", 0)
EndIf
While 1
	$nMsg = GUIGetMsg ()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch

	Select
		Case $nMsg = $Button1
			GUICtrlSetState ($Button1, $GUI_DISABLE)
			$Change = 0
			If GUICtrlRead ($Checkbox1) = 1 Then
				If GUICtrlRead ($Input1) <> "" And GUICtrlRead ($Input2) <> "" Then
					If FileExists (GUICtrlRead ($Input1)) Then
						If StringInStr (GUICtrlRead ($Input2), "\") Then
							For $i = StringLen (GUICtrlRead ($Input2)) To 1 Step - 1
								If StringMid (GUICtrlRead ($Input2), $i, 1) = "\" Then
									ExitLoop
								EndIf
							Next
							If FileExists (StringLeft (GUICtrlRead ($Input2), $i)) Then
								$File = FileOpen (GUICtrlRead ($Input1), 0 + 128)
								$Write = FileOpen (GUICtrlRead ($Input2), 2 + 128)
								$String = FileRead ($File)
								$Line = StringSplit ($String, @CRLF, 1)
								$NumberLine = $Line[0]
								For $i = 1 To $Line[0]
									$PerCent = Int (($i / $NumberLine) * 100)
									If $PerCent <> GUICtrlRead ($Progress1) Then
										GUICtrlSetData ($Label3, $PerCent & " %")
										GUICtrlSetData ($Progress1, $PerCent)
									EndIf
									If $Line[$i] = "" Then
										FileWriteLine ($Write, $Line[$i] & @CRLF)
										ContinueLoop
									Else
										If StringLeft ($Line[$i], 1) = ";" Then
											FileWriteLine ($Write, $Line[$i] & @CRLF)
										Else
											If StringLeft ($Line[$i], 14) = "#comments-start" Or _
													StringLeft ($Line[$i], 3) = "#cs" Then
												$StartComment = 1
											EndIf
											
											If $StartComment = 1 Then
												FileWriteLine ($Write, $Line[$i] & @CRLF)
												ContinueLoop
											Else
												$LineTemp = $Line[$i]
												If StringInStr ($Line[$i], " & ChrW(") Then
													$n = 1
													Do
														$Pos = StringInStr ($LineTemp, " & ChrW(", 0, $n)
														For $n1 = $Pos + 7 To Stringlen ($LineTemp)
															If StringMid ($LineTemp, $n1, 1) = ")" Then
																ExitLoop
															EndIf
														Next
														$ChrW = StringMid ($LineTemp, $Pos + 8, $n1 - $Pos - 8)
														If StringIsDigit ($ChrW) Then
															$LineTemp = StringReplace ($LineTemp, StringMid ($LineTemp, $Pos - 1, 14 + StringLen ($ChrW)), ChrW ($ChrW))
															$Change = $Change + 1
														Else
															$n = $n + 1
														EndIf
													Until StringInStr ($LineTemp, " & ChrW(", 0, $n) = 0
													FileWriteLine ($Write, $LineTemp & @CRLF)
												Else
													FileWriteLine ($Write, $LineTemp & @CRLF)
												EndIf
											EndIf
											
											If StringLeft ($Line[$i], 12) = "#comments-end" Or _
													StringLeft ($Line[$i], 3) = "#ce" Then
												$StartComment = 0
											EndIf
										EndIf
									EndIf
								Next
								FileClose ($Write)
								FileClose ($File)
								If $Change <> 0 Then
									MsgBox (0 + 64, "Successful", "Restore " & $Change & " Unicode character is Successful!")
									GUICtrlSetData ($Progress1, 0)
									GUICtrlSetData ($Label3, "0 %")
									IniWrite ("Settings.ini", "Settings", "SourcePath", GUICtrlRead($Input1))
									IniWrite ("Settings.ini", "Settings", "TargetPath", GUICtrlRead($Input2))
								Else
									GUICtrlSetData ($Progress1, 0)
									GUICtrlSetData ($Label3, "0 %")
									MsgBox (0 + 48, "Error", "No has change!")
								EndIf
							Else
								MsgBox (0 + 48, "Notice", "Target Path does not exist")
							EndIf
						Else
							MsgBox (0 + 48, "Notice", "Target Path does not exist")
						EndIf
					Else
						MsgBox (0 + 48, "Notice", "Source Path does not exist")
					EndIf
				EndIf
			EndIf
			
			If GUICtrlRead ($Checkbox1) = 4 Then
				If GUICtrlRead ($Input1) <> "" And GUICtrlRead ($Input2) <> "" Then
					If FileExists (GUICtrlRead ($Input1)) Then
						If StringInStr (GUICtrlRead ($Input2), "\") Then
							For $i = StringLen (GUICtrlRead ($Input2)) To 1 Step - 1
								If StringMid (GUICtrlRead ($Input2), $i, 1) = "\" Then
									ExitLoop
								EndIf
							Next
							If FileExists (StringLeft (GUICtrlRead ($Input2), $i)) Then
								$File = FileOpen (GUICtrlRead ($Input1), 0 + 128)
								$Write = FileOpen (GUICtrlRead ($Input2), 2 + 128)
								$String = FileRead ($File)
								$Line = StringSplit ($String, @CRLF, 1)
								$NumberLine = $Line[0]
								For $i = 1 To $Line[0]
									$PerCent = Int (($i / $NumberLine) * 100)
									If $PerCent <> GUICtrlRead ($Progress1) Then
										GUICtrlSetData ($Label3, $PerCent & " %")
										GUICtrlSetData ($Progress1, $PerCent)
									EndIf
									If $Line[$i] = "" Then
										FileWriteLine ($Write, $Line[$i] & @CRLF)
										ContinueLoop
									Else
										If StringLeft ($Line[$i], 1) = ";" Then
											FileWriteLine ($Write, $Line[$i] & @CRLF)
										Else
											If StringLeft ($Line[$i], 14) = "#comments-start" Or _
													StringLeft ($Line[$i], 3) = "#cs" Then
												$StartComment = 1
											EndIf
											
											If $StartComment = 1 Then
												FileWriteLine ($Write, $Line[$i] & @CRLF)
												ContinueLoop
											Else
												$LineTemp = ""
												For $Word = 1 To StringLen ($Line[$i])
													$character = StringMid ($Line[$i], $Word, 1)
													$characterAscW = AscW ($character)
													If $character = " " Then
														$LineTemp = $LineTemp & $character
														ContinueLoop
													Else
														If $character = "'" Then
															If $Double = 0 Then
																$Single = 1
															EndIf
															If $Single = 1 Then
																$Single = 0
															EndIf
															If $Single = 0 And $Double = 0 Then
																$Double = 1
															EndIf
														EndIf
														If $character = '"' Then
															If $Single = 0 Then
																$Double = 1
															EndIf
															If $Double = 1 Then
																$Double = 0
															EndIf
															If $Single = 0 And $Double = 0 Then
																$Double = 1
															EndIf
														EndIf
														
														If $Single = 1 Then
															If $characterAscW > 127 Then
																$LineTemp = $LineTemp & "' & ChrW(" & $characterAscW & ") & '"
																$Change = $Change + 1
															Else
																$LineTemp = $LineTemp & $character
															EndIf
														ElseIf $Double = 1 Then
															If $characterAscW > 127 Then
																$LineTemp = $LineTemp & '" & ChrW(' & $characterAscW & ') & "'
																$Change = $Change + 1
															Else
																$LineTemp = $LineTemp & $character
															EndIf
														Else
															$LineTemp = $LineTemp & $character
														EndIf
													EndIf
												Next
												FileWriteLine ($Write, $LineTemp & @CRLF)
											EndIf
											
											If StringLeft ($Line[$i], 12) = "#comments-end" Or _
													StringLeft ($Line[$i], 3) = "#ce" Then
												$StartComment = 0
											EndIf
										EndIf
									EndIf
								Next
								FileClose ($Write)
								FileClose ($File)
								If $Change <> 0 Then
									MsgBox (0 + 64, "Successful", "Convert " & $Change & " Unicode character is Successful!")
									GUICtrlSetData ($Progress1, 0)
									GUICtrlSetData ($Label3, "0 %")
									IniWrite ("Settings.ini", "Settings", "SourcePath", GUICtrlRead($Input1))
									IniWrite ("Settings.ini", "Settings", "TargetPath", GUICtrlRead($Input2))
								Else
									GUICtrlSetData ($Progress1, 0)
									GUICtrlSetData ($Label3, "0 %")
									MsgBox (0 + 48, "Error", "No has change")
								EndIf
							Else
								MsgBox (0 + 48, "Notice", "Target Path does not exist")
							EndIf
						Else
							MsgBox (0 + 48, "Notice", "Target Path does not exist")
						EndIf
					Else
						MsgBox (0 + 48, "Notice", "Source Path does not exist")
					EndIf
				EndIf
			EndIf
			GUICtrlSetState ($Button1, $GUI_ENABLE)
		Case $nMsg = $Button2
			Exit
		Case $nMsg = $Button3
			GUICtrlSetState ($Button3, $GUI_DISABLE)
			$Path = ""
			$Path = FileOpenDialog ("Choose a file", GUICtrlRead ($Input1), "All Files (*.*)", 1)
			If not @error and $Path <> "" then
				If FileExists ($Path) then
					GUICtrlSetData ($Input1, $Path)
					IniWrite ("Settings.ini", "Settings", "SourcePath", $Path)
				EndIf
			EndIf
			GUICtrlSetState ($Button3, $GUI_ENABLE)
		Case $nMsg = $Button4
			GUICtrlSetState ($Button4, $GUI_DISABLE)
			$Path = ""
			$Path = FileSaveDialog ("Choose a file", GUICtrlRead ($Input2), "All Files (*.*)", 16)
			If not @error and $Path <> "" then
				If StringRight ($Path, 4) <> ".au3" Then
					$Path = $Path & ".au3"
				EndIf
				GUICtrlSetData ($Input2, $Path)
				IniWrite ("Settings.ini", "Settings", "TargetPath", $Path)
			EndIf
			GUICtrlSetState ($Button4, $GUI_ENABLE)
		Case $nMsg = $Checkbox1
			If GUICtrlRead ($Checkbox1) = 1 Then
				GUICtrlSetData ($Button1, "Restore")
			Else
				GUICtrlSetData ($Button1, "Convert")
			EndIf
			IniWrite ("Settings.ini", "Settings", "RestoreScript", GUICtrlRead ($Checkbox1))
		Case $nMsg = $Checkbox2
			IniWrite ("Settings.ini", "Settings", "TopMost", GUICtrlRead ($Checkbox2))
			If GUICtrlRead ($Checkbox2) = 1 Then
				WinSetOnTop ($UnicodePreserve, "", 1)
			Else
				WinSetOnTop ($UnicodePreserve, "", 0)
			EndIf
	EndSelect
WEnd