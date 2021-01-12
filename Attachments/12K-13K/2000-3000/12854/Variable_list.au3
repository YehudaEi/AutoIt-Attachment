#include <array.au3>
#include <file.au3>

;choose the file you want to locate variables on
$fileToOpen = FileOpenDialog("Please choose the Auto-It Source file you want to use.", @DesktopDir, "Auto-It (*.au3)", 3)
$file = FileOpen($fileToOpen, 0)

;give an error if the file cannot be opened
If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf

;find number of lines to set the limits for the loop
$numOfLines = _FileCountLines($fileToOpen)

If $numOfLines = 0 Then
	MsgBox(0, "", "zero")
	Exit
EndIf

$count = 0
ProgressOn("Please Wait...", "Creating Variable List", "Starting", (@DesktopWidth - 306) / 2, (@DesktopHeight - 132) / 2, 16)

;loop until EOF is reached
While 1
	;current line number
	$count = $count + 1
	
	;update the progress bar every 20 lines read
	If Mod($count, 20) = 0 Then
		$calculation = ($count / $numOfLines) * 100
		$percent = Round($calculation)
		ProgressSet($percent, $percent & "%")
	EndIf
	
	;read in one line of script
	$string = FileReadLine($file, $count)
	If @error = -1 Then ExitLoop

	;check if the line is part of a comment and if it is then skip it
	$testForComment = StringLeft(StringStripWS($string, 1), 3)
	$testForComment2 = StringLeft($testForComment, 1)
	
	;if comment found then do nothing and if #cs is found continue reading until #ce is found
	If $testForComment2 == ";" Or $testForComment == "#cs" Then
		;MsgBox(0,"comment","Comment found")
		If $testForComment == "#cs" Then
			Do
				$count = $count + 1
				$string = FileReadLine($file, $count)
				If @error = -1 Then ExitLoop
				$testForComment = StringLeft(StringStripWS($string, 1), 3)
			Until $testForComment == "#ce"
		EndIf
	
	;line is not a comment so start parsing out the variables
	Else
		;split the string at every $ so that I can find out how many variables it contains
		$splitString = StringSplit($string, "$")
		$num = UBound($splitString) - 2
				
		;if no variables found then do nothing		
		If StringInStr($string, "$") == 0 Then
			;;;
		Else
			Local $array1[$num]  ;create an array of all variables found
			Local $array2[26]	;create an array of all chars that can follow a variable
			
			For $i = 1 To $num Step 1
				
				$pos = StringInStr($string, "$", 0, $i) ;find position of first var
				$modString = StringTrimLeft($string, $pos - 1) ;trim line of everything before the var starts
				
				;find first char in line after trimming the start
				$array2[0] = StringInStr($modString, " ", 0, 1)
				$array2[1] = StringInStr($modString, "&", 0, 1)
				$array2[2] = StringInStr($modString, "=", 0, 1)
				$array2[3] = StringInStr($modString, "-", 0, 1)
				$array2[4] = StringInStr($modString, "+", 0, 1)
				$array2[5] = StringInStr($modString, "<", 0, 1)
				$array2[6] = StringInStr($modString, ">", 0, 1)
				$array2[7] = StringInStr($modString, "(", 0, 1)
				$array2[8] = StringInStr($modString, ")", 0, 1)
				$array2[9] = StringInStr($modString, "]", 0, 1)
				$array2[10] = StringInStr($modString, "[", 0, 1)
				$array2[11] = StringInStr($modString, ".", 0, 1)
				$array2[12] = StringInStr($modString, "!", 0, 1)
				$array2[13] = StringInStr($modString, "^", 0, 1)
				$array2[14] = StringInStr($modString, "*", 0, 1)
				$array2[15] = StringInStr($modString, ",", 0, 1)
				$array2[16] = StringInStr($modString, ";", 0, 1)
				$array2[17] = StringInStr($modString, ":", 0, 1)
				$array2[18] = StringInStr($modString, "/", 0, 1)
				$array2[19] = StringInStr($modString, "\", 0, 1)
				$array2[20] = StringInStr($modString, "|", 0, 1)
				$array2[21] = StringInStr($modString, "{", 0, 1)
				$array2[22] = StringInStr($modString, "}", 0, 1)
				$array2[23] = StringInStr($modString, "%", 0, 1)
				$array2[24] = StringInStr($modString, "'", 0, 1)
				$array2[25] = StringInStr($modString, '"', 0, 1)
				
				;sort the array so that the lowest numbers come first
				_ArraySort($array2)
				
				;This is confusing I know but it looks at the array and if it is equal to zero then it moves to the next element of the array
				;and if the end of the array is reached the variable is the entire line of code that is left.  Otherwise it takes the first 
				;none zero number and that is the number of chars in the variable and it writes that many chars to the file
				;"Variable List.txt" on the desktop.
				$arrayReadPos = $array2[0]
				If $arrayReadPos == 0 Then
					$arrayReadPos = $array2[1]
					If $arrayReadPos == 0 Then
						$arrayReadPos = $array2[2]
						If $arrayReadPos == 0 Then
							$arrayReadPos = $array2[3]
							If $arrayReadPos == 0 Then
								$arrayReadPos = $array2[4]
								If $arrayReadPos == 0 Then
									$arrayReadPos = $array2[5]
									If $arrayReadPos == 0 Then
										$arrayReadPos = $array2[6]
										If $arrayReadPos == 0 Then
											$arrayReadPos = $array2[7]
											If $arrayReadPos == 0 Then
												$arrayReadPos = $array2[8]
												If $arrayReadPos == 0 Then
													$arrayReadPos = $array2[9]
													If $arrayReadPos == 0 Then
														$arrayReadPos = $array2[10]
														If $arrayReadPos == 0 Then
															$arrayReadPos = $array2[11]
															If $arrayReadPos == 0 Then
																$arrayReadPos = $array2[12]
																If $arrayReadPos == 0 Then
																	$arrayReadPos = $array2[13]
																	If $arrayReadPos == 0 Then
																		$arrayReadPos = $array2[14]
																		If $arrayReadPos == 0 Then
																			$arrayReadPos = $array2[15]
																			If $arrayReadPos == 0 Then
																				$arrayReadPos = $array2[16]
																				If $arrayReadPos == 0 Then
																					$arrayReadPos = $array2[17]
																					If $arrayReadPos == 0 Then
																						$arrayReadPos = $array2[18]
																						If $arrayReadPos == 0 Then
																							$arrayReadPos = $array2[19]
																							If $arrayReadPos == 0 Then
																								$arrayReadPos = $array2[20]
																								If $arrayReadPos == 0 Then
																									$arrayReadPos = $array2[21]
																									If $arrayReadPos == 0 Then
																										$arrayReadPos = $array2[22]
																										If $arrayReadPos == 0 Then
																											$arrayReadPos = $array2[23]
																											If $arrayReadPos == 0 Then
																												$arrayReadPos = $array2[24]
																												If $arrayReadPos == 0 Then
																													$arrayReadPos = $array2[25]
																													If $arrayReadPos == 0 Then
																														FileWriteLine(@DesktopDir & "\Variable List.txt", $modString)
																													Else
																														FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																													EndIf
																												Else
																													FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																												EndIf
																											Else
																												FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																											EndIf
																										Else
																											FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																										EndIf
																									Else
																										FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																									EndIf
																								Else
																									FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																								EndIf
																							Else
																								FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																							EndIf
																						Else
																							FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																						EndIf
																					Else
																						FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																					EndIf
																				Else
																					FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																				EndIf
																			Else
																				FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																			EndIf
																		Else
																			FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																		EndIf
																	Else
																		FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																	EndIf
																Else
																	FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
																EndIf
															Else
																FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
															EndIf
														Else
															FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
														EndIf
													Else
														FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
													EndIf
												Else
													FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
												EndIf
											Else
												FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
											EndIf
										Else
											FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
										EndIf
									Else
										FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
									EndIf
								Else
									FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
								EndIf
							Else
								FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
							EndIf
						Else
							FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
						EndIf
					Else
						FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
					EndIf
				Else
					FileWriteLine(@DesktopDir & "\Variable List.txt", StringLeft($modString, $arrayReadPos - 1))
				EndIf
			Next
		EndIf
	EndIf
WEnd

ProgressOff()  ;closing progress bar
FileClose($file)  ;closing file

;Prompt the user to see if I should continue
;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question, Miscellaneous=Top-most attribute
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(262180, "Question", "Would you like to clear up Duplicate Variables?")

;create an array of all variables that are part of the autoit code itself and add them to the exclude list.  ($array3 will become the exclude list)
Local $array3[232]

;declearing known Auto-It Variables so that they will not be listed
$array3[0] = "$GUI_CHECKED"
$array3[1] = "$GUI_UNCHECKED"
$array3[2] = "$GUI_ENABLE"
$array3[3] = "$GUI_DISABLE"
$array3[4] = "$GUI_HIDE"
$array3[5] = "$GUI_SHOW"
$array3[6] = "$GUI_FOCUS"
$array3[7] = "$GUI_EVENT_CLOSE"
$array3[8] = "$GUI_EVENT_MINIMIZE"
$array3[9] = "$GUI_EVENT_RESTORE"
$array3[10] = "$GUI_EVENT_MAXIMIZE"
$array3[11] = "$GUI_EVENT_EXIT"
$array3[12] = "$CMDLINE"
$array3[13] = "$CMDLINERAW"
$array3[14] = "$GUI_EVENT_PRIMARYDOWN"
$array3[15] = "$GUI_EVENT_PRIMARYUP"
$array3[16] = "$GUI_EVENT_SECONDARYDOWN"
$array3[17] = "$GUI_EVENT_SECONDARYUP"
$array3[18] = "$GUI_EVENT_MOUSEMOVE"
$array3[19] = "$GUI_EVENT_RESIZED"
$array3[20] = "$GUI_EVENT_DROPPED"
$array3[21] = "$msg"
$array3[22] = "$GUI_SS_DEFAULT_GUI"
$array3[23] = "$WS_BORDER"
$array3[24] = "$WS_POPUP"
$array3[25] = "$WS_CAPTION"
$array3[26] = "$WS_CLIPCHILDREN"
$array3[27] = "$WS_CLIPSIBLINGS"
$array3[28] = "$WS_DISABLED"
$array3[29] = "$WS_DLGFRAME"
$array3[30] = "$WS_HSCROLL"
$array3[31] = "$WS_MAXIMIZE"
$array3[32] = "$WS_MAXIMIZEBOX"
$array3[33] = "$WS_MINIMIZE"
$array3[34] = "$WS_MINIMIZEBOX"
$array3[35] = "$WS_OVERLAPPED"
$array3[36] = "$WS_OVERLAPPEDWINDOW"
$array3[37] = "$WS_POPUPWINDOW"
$array3[38] = "$WS_SIZEBOX"
$array3[39] = "$WS_SYSMENU"
$array3[40] = "$WS_THICKFRAME"
$array3[41] = "$WS_VSCROLL"
$array3[42] = "$WS_VISIBLE"
$array3[43] = "$WS_CHILD"
$array3[44] = "$WS_GROUP"
$array3[45] = "$WS_TABSTOP"
$array3[46] = "$DS_MODALFRAME"
$array3[47] = "$DS_SETFOREGROUND"
$array3[48] = "$DS_CONTEXTHELP"
$array3[49] = "$WS_EX_ACCEPTFILES"
$array3[50] = "$GUI_DROPACCEPTED"
$array3[51] = "$WS_EX_APPWINDOW"
$array3[52] = "$WS_EX_CLIENTEDGE"
$array3[53] = "$WS_EX_CONTEXTHELP"
$array3[54] = "$WS_EX_DLGMODALFRAME"
$array3[55] = "$WS_EX_MDICHILD"
$array3[56] = "$WS_EX_OVERLAPPEDWINDOW"
$array3[57] = "$WS_EX_STATICEDGE"
$array3[58] = "$WS_EX_TOPMOST"
$array3[59] = "$WS_EX_TRANSPARENT"
$array3[60] = "$WS_EX_TOOLWINDOW"
$array3[61] = "$WS_EX_WINDOWEDGE"
$array3[62] = "$WS_EX_LAYERED"
$array3[63] = "$GUI_WS_EX_PARENTDRAG"
$array3[64] = "$BS_3STATE"
$array3[65] = "$BS_AUTO3STATE"
$array3[66] = "$BS_AUTOCHECKBOX"
$array3[67] = "$BS_CHECKBOX"
$array3[68] = "$BS_LEFT"
$array3[69] = "$BS_PUSHLIKE"
$array3[70] = "$BS_RIGHT"
$array3[71] = "$BS_RIGHTBUTTON"
$array3[72] = "$BS_GROUPBOX"
$array3[73] = "$BS_AUTORADIOBUTTON"
$array3[74] = "$BS_BOTTOM"
$array3[75] = "$BS_CENTER"
$array3[76] = "$BS_DEFPUSHBUTTON"
$array3[77] = "$BS_MULTILINE"
$array3[78] = "$BS_TOP"
$array3[79] = "$BS_VCENTER"
$array3[80] = "$BS_ICON"
$array3[81] = "$BS_BITMAP"
$array3[82] = "$BS_FLAT"
$array3[83] = "$GUI_SS_DEFAULT_COMBO"
$array3[84] = "$CBS_AUTOHSCROLL"
$array3[85] = "$CBS_DISABLENOSCROLL"
$array3[86] = "$CBS_DROPDOWN"
$array3[87] = "$CBS_DROPDOWNLIST"
$array3[88] = "$CBS_LOWERCASE"
$array3[89] = "$CBS_NOINTEGRALHEIGHT"
$array3[90] = "$CBS_OEMCONVERT"
$array3[91] = "$CBS_SIMPLE"
$array3[92] = "$CBS_SORT"
$array3[93] = "$CBS_UPPERCASE"
$array3[94] = "$GUI_SS_DEFAULT_LIST"
$array3[95] = "$LBS_DISABLENOSCROLL"
$array3[96] = "$LBS_NOINTEGRALHEIGHT"
$array3[97] = "$LBS_NOSEL"
$array3[98] = "$LBS_NOTIFY"
$array3[99] = "$LBS_SORT"
$array3[100] = "$LBS_STANDARD"
$array3[101] = "$LBS_USETABSTOPS"
$array3[102] = "$GUI_SS_DEFAULT_EDIT"
$array3[103] = "$GUI_SS_DEFAULT_INPUT"
$array3[104] = "$ES_AUTOHSCROLL"
$array3[105] = "$ES_AUTOVSCROLL"
$array3[106] = "$ES_CENTER"
$array3[107] = "$ES_LOWERCASE"
$array3[108] = "$ES_NOHIDESEL"
$array3[109] = "$ES_NUMBER"
$array3[110] = "$ES_OEMCONVERT"
$array3[111] = "$ES_MULTILINE"
$array3[112] = "$ES_PASSWORD"
$array3[113] = "$ES_READONLY"
$array3[114] = "$ES_RIGHT"
$array3[115] = "$ES_UPPERCASE"
$array3[116] = "$ES_WANTRETURN"
$array3[117] = "$PBS_SMOOTH"
$array3[118] = "$PBS_VERTICAL"
$array3[119] = "$GUI_SS_DEFAULT_UPDOWN"
$array3[120] = "$UDS_ALIGNLEFT"
$array3[121] = "$UDS_ALIGNRIGHT"
$array3[122] = "$UDS_ARROWKEYS"
$array3[123] = "$UDS_HORZ"
$array3[124] = "$UDS_NOTHOUSANDS"
$array3[125] = "$UDS_WRAP"
$array3[126] = "$GUI_SS_DEFAULT_LABEL"
$array3[127] = "$GUI_SS_DEFAULT_ICON"
$array3[128] = "$GUI_SS_DEFAULT_PIC"
$array3[129] = "$SS_BLACKFRAME"
$array3[130] = "$SS_BLACKRECT"
$array3[131] = "$SS_CENTER"
$array3[132] = "$SS_CENTERIMAGE"
$array3[133] = "$SS_ETCHEDFRAME"
$array3[134] = "$SS_ETCHEDHORZ"
$array3[135] = "$SS_ETCHEDVERT"
$array3[136] = "$SS_GRAYFRAME"
$array3[137] = "$SS_GRAYRECT"
$array3[138] = "$SS_LEFT"
$array3[139] = "$SS_LEFTNOWORDWRAP"
$array3[140] = "$SS_NOPREFIX"
$array3[141] = "$SS_NOTIFY"
$array3[142] = "$SS_RIGHT"
$array3[143] = "$SS_RIGHTJUST"
$array3[144] = "$SS_SIMPLE"
$array3[145] = "$SS_SUNKEN"
$array3[146] = "$SS_WHITEFRAME"
$array3[147] = "$SS_WHITERECT"
$array3[148] = "$TCS_SCROLLOPPOSITE"
$array3[149] = "$TCS_BOTTOM"
$array3[150] = "$TCS_RIGHT"
$array3[151] = "$TCS_MULTISELECT"
$array3[152] = "$TCS_FLATBUTTONS"
$array3[153] = "$TCS_FORCEICONLEFT"
$array3[154] = "$TCS_FORCELABELLEFT"
$array3[155] = "$TCS_HOTTRACK"
$array3[156] = "$TCS_VERTICAL"
$array3[157] = "$TCS_TABS"
$array3[158] = "$TCS_BUTTONS"
$array3[159] = "$TCS_SINGLELINE"
$array3[160] = "$TCS_MULTILINE"
$array3[161] = "$TCS_RIGHTJUSTIFY"
$array3[162] = "$TCS_FIXEDWIDTH"
$array3[163] = "$TCS_RAGGEDRIGHT"
$array3[164] = "$TCS_FOCUSONBUTTONDOWN"
$array3[165] = "$TCS_OWNERDRAWFIXED"
$array3[166] = "$TCS_TOOLTIPS"
$array3[167] = "$TCS_FOCUSNEVER"
$array3[168] = "$GUI_SS_DEFAULT_AVI"
$array3[169] = "$ACS_AUTOPLAY"
$array3[170] = "$ACS_CENTER"
$array3[171] = "$ACS_TRANSPARENT"
$array3[172] = "$ACS_NONTRANSPARENT"
$array3[173] = "$GUI_SS_DEFAULT_DATE"
$array3[174] = "$DTS_UPDOWN"
$array3[175] = "$DTS_SHOWNONE"
$array3[176] = "$DTS_LONGDATEFORMAT"
$array3[177] = "$DTS_TIMEFORMAT"
$array3[178] = "$DTS_RIGHTALIGN"
$array3[179] = "$DTS_SHORTDATEFORMAT"
$array3[180] = "$MCS_NOTODAY"
$array3[181] = "$MCS_NOTODAYCIRCLE"
$array3[182] = "$MCS_WEEKNUMBERS"
$array3[183] = "$GUI_SS_DEFAULT_TREEVIEW"
$array3[184] = "$TVS_HASBUTTONS"
$array3[185] = "$TVS_HASLINES"
$array3[186] = "$TVS_LINESATROOT"
$array3[187] = "$TVS_DISABLEDRAGDROP"
$array3[188] = "$TVS_SHOWSELALWAYS"
$array3[189] = "$TVS_RTLREADING"
$array3[190] = "$TVS_NOTOOLTIPS"
$array3[191] = "$TVS_CHECKBOXES"
$array3[192] = "$TVS_TRACKSELECT"
$array3[193] = "$TVS_SINGLEEXPAND"
$array3[194] = "$TVS_FULLROWSELECT"
$array3[195] = "$TVS_NOSCROLL"
$array3[196] = "$TVS_NONEVENHEIGHT"
$array3[197] = "$GUI_SS_DEFAULT_SLIDER"
$array3[198] = "$TBS_AUTOTICKS"
$array3[199] = "$TBS_BOTH"
$array3[200] = "$TBS_BOTTOM"
$array3[201] = "$TBS_HORZ"
$array3[202] = "$TBS_VERT"
$array3[203] = "$TBS_NOTHUMB"
$array3[204] = "$TBS_NOTICKS"
$array3[205] = "$TBS_LEFT"
$array3[206] = "$TBS_RIGHT"
$array3[207] = "$TBS_TOP"
$array3[208] = "$GUI_SS_DEFAULT_LISTVIEW"
$array3[209] = "$LVS_ICON"
$array3[210] = "$LVS_REPORT"
$array3[211] = "$LVS_SMALLICON"
$array3[212] = "$LVS_LIST"
$array3[213] = "$LVS_EDITLABELS"
$array3[214] = "$LVS_NOCOLUMNHEADER"
$array3[215] = "$LVS_NOSORTHEADER"
$array3[216] = "$LVS_SINGLESEL"
$array3[217] = "$LVS_SHOWSELALWAYS"
$array3[218] = "$LVS_SORTASCENDING"
$array3[219] = "$LVS_SORTDESCENDING"
$array3[220] = "$LVS_NOLABELWRAP"
$array3[221] = "$LVS_EX_FULLROWSELECT"
$array3[222] = "$LVS_EX_GRIDLINES"
$array3[223] = "$LVS_EX_HEADERDRAGDROP"
$array3[224] = "$LVS_EX_TRACKSELECT"
$array3[225] = "$LVS_EX_CHECKBOXES"
$array3[226] = "$LVS_EX_BORDERSELECT"
$array3[227] = "$LVS_EX_DOUBLEBUFFER"
$array3[228] = "$LVS_EX_FLATSB"
$array3[229] = "$LVS_EX_MULTIWORKAREAS"
$array3[230] = "$LVS_EX_SNAPTOGRID"
$array3[231] = "$LVS_EX_SUBITEMIMAGES"

Select
	Case $iMsgBoxAnswer = 6 ;Yes
		$file = FileOpen(@DesktopDir & "\Variable List.txt", 0)
		$count = 0
		$varString = ""
		$numOfLines = _FileCountLines(@DesktopDir & "\Variable List.txt")
		ProgressOn("Please Wait...", "Clearing Duplicates...", "Starting", (@DesktopWidth - 306) / 2, (@DesktopHeight - 132) / 2, 16)
		
		While 1
			;create my line counter
			$count = $count + 1
			
			;update progress bar every 20 lines of text read
			If Mod($count, 20) = 0 Then
				$calculation = ($count / $numOfLines) * 100
				$percent = Round($calculation)
				ProgressSet($percent, $percent & "%")
			EndIf
			
			;read each variable in and exit loop if EOF is reached
			$variable = FileReadLine($file, $count)
			If @error = -1 Then ExitLoop
			
			;check that the variable read is not on the exclude list and if not then add the new variable to the array so it won't be
			;used again and write the variable to the file "Variable List No Dupes.txt" on the Desktop.
			_ArraySearch($array3, $variable)
			If @error = 6 Then
				_ArrayAdd($array3, $variable)
				FileWriteLine(@DesktopDir & "\Variable List No Dupes.txt", $variable)
			EndIf
		WEnd
	
	;if they don't want to get rid of the Dupes then exit the script
	Case $iMsgBoxAnswer = 7 ;No
		Exit
		
EndSelect