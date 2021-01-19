#include <GUIConstants.au3>
#include <GUIEdit.au3>
#include <misc.au3>
#include <GUIConstants.au3>
#include <GUIEdit.au3>
#include <string.au3>
HotKeySet ("^{NUMPADADD}", "IncreaseFont")
HotKeySet ("^{NUMPADSUB}", "DecreaseFont")
HotKeySet ("{f11}", "fullscreen")
;~ HotKeySet ("^{mousewheelup}", "IncreaseFont")
;~ HotKeySet ("^{Mousewheeldown}", "DecreaseFont")
$line = 1
$FontSize = 12
$Form1 = GUICreate ("Terminal", 499, 294, 201, 116, BitOr($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX))
$fsize = 10
GUISetCursor (7)
GUICtrlCreateTab(0,0,150,20)
GUICtrlCreateTabItem("edit")
$Edit = GUICtrlCreateEdit ("", 0, 40, 497, 273, BitOR ($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX))
$savebutton = GUICtrlCreateButton ("save",0,20,50,20)
$open = GUICtrlCreateButton("open", 50, 20, 50, 20)
$atext = GUICtrlCreateLabel("Address:", 100, 25, 45, 17)
$fileadress = GUICtrlCreateInput("Unknown 1", 145, 20, 121, 20)
GUICtrlSetTip(-1, "You can copy and paste File address here")
$attribtext = GUICtrlCreateLabel("Attributes:", 266, 25, 45, 17)
$fileattrib = GUICtrlCreateInput("Unknown 2", 310, 20, 50, 20)
GUICtrlSetTip(-1, "You can see file attributes here" & @CRLF & "Remarks :" & @CRLF & "R = READONLY"& @CRLF & "A = ARCHIVE"& @CRLF & "S = SYSTEM"& @CRLF & "H = HIDDEN"& @CRLF & "N = NORMAL"& @CRLF & "D = DIRECTORY"& @CRLF & "O = OFFLINE"& @CRLF & "C= COMPRESSED (NTFS compression, not ZIP compression)"& @CRLF & "T = TEMPORARY" )
$atext = GUICtrlCreateLabel("->", 360, 25, 10, 17)
$fileattribset = GUICtrlCreateInput("Unknown 3", 370, 20, 50, 20)
GUICtrlSetTip(-1, "You can Set file attributes here" & @CRLF & "Remarks :" & @CRLF & "R = READONLY"& @CRLF & "A = ARCHIVE"& @CRLF & "S = SYSTEM"& @CRLF & "H = HIDDEN"& @CRLF & "N = NORMAL"& @CRLF & "D = DIRECTORY"& @CRLF & "O = OFFLINE"& @CRLF & "C= COMPRESSED (NTFS compression, not ZIP compression)"& @CRLF & "T = TEMPORARY" )
$fileattribsetbutton = GUICtrlCreateButton("set", 420, 20, 30, 20)
GUICtrlCreateTabItem("Diff")
$MenuItem1 = GUICtrlCreateMenu("File")
$MenuItem2 = GUICtrlCreateMenuItem("New", $MenuItem1)
$MenuItem3 = GUICtrlCreateMenuItem("Open", $MenuItem1)
$MenuItem4 = GUICtrlCreateMenuItem("Save", $MenuItem1)
$MenuItem5 = GUICtrlCreateMenuItem("Print", $MenuItem1)
$MenuSep = GUICtrlCreateMenuItem("", $MenuItem1)
$MenuItem6 = GUICtrlCreateMenuItem("Exit", $MenuItem1)
$MenuSep = GUICtrlCreateMenuItem(" --Left--", $MenuItem1)
$MenuItem21 = GUICtrlCreateMenuItem("New", $MenuItem1)
$MenuItem22 = GUICtrlCreateMenuItem("Open", $MenuItem1)
$MenuItem23 = GUICtrlCreateMenuItem("Save", $MenuItem1)
$MenuItem24ok = GUICtrlCreateMenuItem("Print", $MenuItem1)
$MenuItem7 = GUICtrlCreateMenu("Edit")
$MenuItem8 = GUICtrlCreateMenuItem("Insert Current Time", $MenuItem7)
$MenuSep = GUICtrlCreateMenuItem("", $MenuItem7)
$MenuItem9 = GUICtrlCreateMenuItem("Reverse Text", $MenuItem7)
$MenuSep = GUICtrlCreateMenuItem("", $MenuItem7)
$MenuItem10 = GUICtrlCreateMenuItem("Word Count", $MenuItem7)
$MenuSep = GUICtrlCreateMenuItem("", $MenuItem7)
$MenuItem11 = GUICtrlCreateMenuItem("Copy", $MenuItem7)
$MenuItem12 = GUICtrlCreateMenuItem("Paste", $MenuItem7)
$MenuSep = GUICtrlCreateMenuItem("", $MenuItem7)
$MenuItem13 = GUICtrlCreateMenuItem("Undo", $MenuItem7)
$MenuSep = GUICtrlCreateMenuItem("", $MenuItem7)
$MenuItem15 = GUICtrlCreateMenuItem("Font", $MenuItem7)
$MenuItem19 = GUICtrlCreateMenu("About")
$MenuItem20 = GUICtrlCreateMenuItem("About", $MenuItem19)
GUISetState(@SW_SHOW)
$diffsaveleft = GUICtrlCreateButton ("save",0,20,50,20)
$diffopenleft = GUICtrlCreateButton("open", 50, 20, 50, 20)
$diffreopenleft = GUICtrlCreateButton("Re open", 100, 20, 50, 20)
$diffsaveright = GUICtrlCreateButton ("save",250,20,50,20)
$diffopenright = GUICtrlCreateButton("open", 300, 20, 50, 20)
$diffreopenright = GUICtrlCreateButton("Re open", 350, 20, 50, 20)
$atext = GUICtrlCreateLabel("Address:", 0, 45, 45, 17)
$fileadressleft = GUICtrlCreateInput("Unknown 4", 44, 40, 121, 20)
$atext = GUICtrlCreateLabel("Address:", 250, 45, 45, 17)
$fileadressright = GUICtrlCreateInput("Unknown 5", 295, 40, 121, 20)
$DiffEdit1 = GUICtrlCreateEdit ("", 0, 60, 247, 273, BitOR ($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX))
$DiffEdit2 = GUICtrlCreateEdit ("", 250, 60, 497, 273, BitOR ($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX))
GUICtrlCreateTabItem("shell")
$consolemodeallow = GUICtrlCreateButton ("Enable",300,0,50,20)
$consolemodedisallow = GUICtrlCreateButton ("Disable",350,0,50,20)
$CommandInput = GUICtrlCreateEdit ("To see avaible commands Type: commands ", 0, 20, 497, 273, BitOR ($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX))
GUICtrlSetData (-1, "shell:")
GUICtrlSetFont (-1, $fsize, 500, 0, "Terminal")
GUICtrlSetColor (-1, 0xFFFFFF)
GUICtrlSetBkColor (-1, 0x000000)

GUISetState()

While 1
    $msg = GUIGetMsg ()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            Exit
		Case $savebutton
             $SaveFile = FileSaveDialog("Select Location to Save:", "", "Text (*.*)")
             $ReadEdit = GuiCtrlRead($Edit)
             FileWrite($SaveFile, $ReadEdit)
			Case $open
             $path = FileOpenDialog("Select file:","", "text (*.*)")
                GUICtrlSetData($Edit,FileRead($path))
				GUICtrlSetData($fileadress,$path)
				$textattrib= FileGetAttrib($path)
				GUICtrlSetData($fileattrib,$textattrib)				
				WinSetTitle($Form1,"",$path)
			Case $fileadress
				WinSetTitle($Form1,"","modified")
			case $fileattribsetbutton
				$aset = GUICtrlRead($fileattribset)
				FileSetAttrib($path,$aset)
			Case $diffopenleft
             $diffpathleft = FileOpenDialog("Select file:","", "text (*.*)")
                GUICtrlSetData($DiffEdit1,FileRead($diffpathleft))
				GUICtrlSetData($fileadressleft,$diffpathleft)
				$textattrib= FileGetAttrib($diffpathleft)
				GUICtrlSetData($fileattrib,$textattrib)				
				WinSetTitle($Form1,"",$diffpathleft)
			Case $diffsaveleft
             $SaveFile = FileSaveDialog("Select Location to Save:", "", "Text (*.*)")
             $ReadEdit = GuiCtrlRead($DiffEdit1)
             FileWrite($SaveFile, $ReadEdit)
			 Case $diffopenright
             $diffpathright = FileOpenDialog("Select file:","", "text (*.*)")
                GUICtrlSetData($DiffEdit2,FileRead($diffpathright))
				GUICtrlSetData($fileadressright,$diffpathright)
				$textattrib= FileGetAttrib($diffpathright)
				GUICtrlSetData($fileattrib,$textattrib)				
				WinSetTitle($Form1,"",$diffpathright )
			Case $diffsaveright
             $SaveFile = FileSaveDialog("Select Location to Save:", "", "Text (*.*)")
             $ReadEdit = GuiCtrlRead($DiffEdit2)
             FileWrite($SaveFile, $ReadEdit)
		 Case $diffreopenleft
			 GUICtrlSetData($DiffEdit1,FileRead($diffpathleft))
			 Case $diffreopenright
			 GUICtrlSetData($DiffEdit2,FileRead($diffpathright))
		 Case $consolemodeallow
			 HotKeySet ("{enter}","read_func")
		Case $consolemodedisallow
			 HotKeySet ("{enter}")	 
			 
    EndSwitch
WEnd


Func read_func ()
    $line = _GUICtrlEdit_GetLineCount ($CommandInput) - 1
    $Input=_GUICtrlEdit_GetLine($CommandInput,$line)
    $command = StringTrimLeft ($Input, 6)
	$Say = StringInStr ($command, "say")
	$Exit = StringInStr ($command, "exit")
	$sysinfo = StringInStr ($command, "sys")
	$ipconfig = StringInStr ($command, "ipconfig")
	$ping = StringInStr ($command, "ping")
	$run = StringInStr ($command, "run")
	$play = StringInStr ($command, "play")
	$kill = StringInStr ($command, "kill")
	$delfile = StringInStr ($command, "delfile")
	$soundvol = StringInStr ($command, "soundvol")
	$diskfree = StringInStr ($command, "diskfree")
	$tcmd = StringInStr ($command, "tcmd")
	$transparent = StringInStr ($command, "transparent")
	$untrans = StringInStr ($command, "untrans")
	$aptgetupdate = StringInStr ($command, "aptgetupdate")
	$FileCopy= StringInStr ($command, "filecopy")
	$dirCopy= StringInStr ($command, "dircopy")
	$filemove= StringInStr ($command, "filemove")
    $commands= StringInStr ($command, "commands")
	$attribget= StringInStr ($command, "attribget")
	$attribset= StringInStr ($command, "attribset")
	$winminimizeall= StringInStr ($command, "winminimizeall")
	If $Say Then
		HotKeySet ("{enter}")
		$string = StringTrimLeft ($Input, 10)
		Send (@CRLF & $string & @CRLF & "shell:")
		$line = $line + 4
		Sleep (100)
		HotKeySet ("{enter}", "read_func")
	Else
		If $Exit Then
			Exit
		Else
			If $sysinfo Then
				sys()
				;HERE'S THE FIX========
				HotKeySet ("{enter}")
				Send (@CRLF & "shell:")
				$line = $line + 30
				HotKeySet ("{enter}", "read_func")
				;==========================
				Else
			If $commands Then
					HotKeySet ("{enter}")
	$string = StringTrimLeft ($Input, 15)
	GuiCtrlSetData($CommandInput,"")
	$Text=FileRead(@ScriptDir & "\help.txt")
	ClipPut($Text)
	Send("^v")
				HotKeySet ("{enter}")
				Send (@CRLF & "shell:")
				$line = $line + 30
				HotKeySet ("{enter}", "read_func")
				;==========================
				Else
			If $winminimizeall Then
				WinMinimizeAll()
				WinWaitActive("Terminal")
				HotKeySet ("{enter}")
		$string = StringTrimLeft ($Input, 21)
		Send (@CRLF & "all windows minimized" & @CRLF & "shell:")
		$line = $line + 4
		Sleep (100)
		HotKeySet ("{enter}", "read_func")
				Else
			If $attribget Then
				$string = StringTrimLeft ($Input, 16)
					$fileattrib = FileGetAttrib ($string)
					HotKeySet ("{enter}")
					ClipPut (@CRLF & "File has following attributes:" & $fileattrib & @CRLF)
					Send ("^v{enter}")
					HotKeySet ("{enter}", "read_func")
				;HERE'S THE FIX========
				HotKeySet ("{enter}")
				Send (@CRLF & "shell:")
				$line = $line + 30
				HotKeySet ("{enter}", "read_func")
				;==========================
			Else
				If $diskfree Then
					df()
					HotKeySet ("{enter}")
					Send (@CRLF & "shell:")
					$line = $line + 6
					HotKeySet ("{enter}", "read_func")
				EndIf
				If $kill Then
					HotKeySet ("{enter}")
					$string = StringTrimLeft ($Input, 11)
					Send (@CRLF & "Killing " & $string & "...")
					$PID = ProcessExists ($string & ".exe")
					If $PID Then
						ProcessClose ($PID & ".exe")
						Send (@CRLF & "Shell:")
						$line = $line + 4
					Else
						Send (@CRLF & "FATAL ERROR: could not find progress" & "..." & @CRLF & "Shell:")
						$line = $line + 6
					EndIf
					HotKeySet ("{enter}", "read_func")
				Else
					If $tcmd Then
						HotKeySet ("{enter}")
						WinSetTrans ("Terminal", "", 128)
						Send (@CRLF & "Shell:")
						$line = $line + 4
						HotKeySet ("{enter}", "read_func")
					Else
						If $transparent Then
							HotKeySet ("{enter}")
							$string = StringTrimLeft ($Input, 18)
							Send (@CRLF & "transparent " & $string & @CRLF & "Shell:")
							$line = $line + 4
							Sleep (100)
							HotKeySet ("{enter}", "read_func")
							WinSetTrans ($string, "", 128)
							If @error Then
								HotKeySet ("{enter}")
								$string = StringTrimLeft ($Input, 10)
								Send (@CRLF & "FATAL ERROR: could not find external window title" & "..." & @CRLF & "Shell:")
								$line = $line + 4
								Sleep (100)
								HotKeySet ("{enter}", "read_func")
							EndIf
						Else
							If $untrans Then
								HotKeySet ("{enter}")
								$string = StringTrimLeft ($Input, 14)
								Send (@CRLF & "untransparent " & $string & @CRLF & "Shell:")
								$line = $line + 4
								Sleep (100)
								HotKeySet ("{enter}", "read_func")
								WinSetTrans ($string, "", 255)
								If @error Then
									HotKeySet ("{enter}")
									$string = StringTrimLeft ($Input, 10)
									Send (@CRLF & "FATAL ERROR: could not find external window title" & "..." & @CRLF & "Shell:")
									$line = $line + 4
									Sleep (100)
									HotKeySet ("{enter}", "read_func")
								EndIf
							Else
								If $run Then
									HotKeySet ("{enter}")
									$string = StringTrimLeft ($Input, 10)
									Send (@CRLF & "running " & $string & "..." & @CRLF & "Shell:")
									$line = $line + 4
									Sleep (100)
									HotKeySet ("{enter}", "read_func")
									Run ($string)
									If @error Then
										HotKeySet ("{enter}")
										$string = StringTrimLeft ($Input, 10)
										Send (@CRLF & "FATAL ERROR: could not find external program" & "..." & @CRLF & "Shell:")
										$line = $line + 4
										Sleep (100)
										HotKeySet ("{enter}", "read_func")
									EndIf
									Else
								If $aptgetupdate Then
									Run(@ScriptDir&"\update.exe")
									Exit
								Else
									If $play Then
										HotKeySet ("{enter}")
										$string = StringTrimLeft ($Input, 11)
										Send (@CRLF & "running " & $string & "..." & @CRLF & "Shell:")
										$line = $line + 4
										Sleep (100)
										HotKeySet ("{enter}", "read_func")
										SoundPlay ($string)
										If @error Then
											HotKeySet ("{enter}")
											$string = StringTrimLeft ($Input, 10)
											Send (@CRLF & "FATAL ERROR: could not find external program" & "..." & @CRLF & "Shell:")
											$line = $line + 4
											Sleep (100)
											HotKeySet ("{enter}", "read_func")
										EndIf
									Else
										If $delfile Then
											HotKeySet ("{enter}")
											$string = StringTrimLeft ($Input, 11)
											Send (@CRLF & "Deleting" & $string & "..." & @CRLF & "Shell:")
											$line = $line + 4
											Sleep (100)
											HotKeySet ("{enter}", "read_func")
											FileDelete ($string)
											If @error Then
												HotKeySet ("{enter}")
												$string = StringTrimLeft ($Input, 10)
												Send (@CRLF & "FATAL ERROR: could not delete file" & "..." & @CRLF & "Shell:")
												$line = $line + 4
												Sleep (100)
												HotKeySet ("{enter}", "read_func")
											EndIf
										Else
											If $soundvol Then
												HotKeySet ("{enter}")
												$string = StringTrimLeft ($Input, 15)
												SoundSetWaveVolume ($string)
												Send (@CRLF & "Volume has been set to : " & $string & "%" & @CRLF & "shell:")
												$line = $line + 4
												Sleep (100)
												HotKeySet ("{enter}", "read_func")
											Else
												If $ipconfig Then
													HotKeySet ("{enter}")
													Send (@CRLF & "Your IP address is :" & @IPAddress1 & @CRLF & "shell:")
													$line = $line + 4
													Sleep (100)
													HotKeySet ("{enter}", "read_func")
												Else
													If $filecopy Then
														$Comm=StringSplit($Input,"+")
														MsgBox(0,"",$Comm[0])
														If $Comm[0]=3 Then
															HotKeySet ("{enter}")
															Send (@CRLF & "Copying :" & $Comm[2]&" to: "&$Comm[3] & @CRLF & "shell:")
															FileCopy($Comm[2],$Comm[3])
															
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														Else
															HotKeySet ("{enter}")
															Send (@CRLF & "Incorrect number of parameters in function call"& @CRLF & "shell:")
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														EndIf
														Else
													If $attribset Then
														$Comm=StringSplit($Input,"+")
														MsgBox(0,"",$Comm[0])
														If $Comm[0]=3 Then
															HotKeySet ("{enter}")
															Send (@CRLF & "Copying :" & $Comm[2]&" to: "&$Comm[3] & @CRLF & "shell:")
															FileSetAttrib($Comm[2],$Comm[3])
															
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														Else
															HotKeySet ("{enter}")
															Send (@CRLF & "Incorrect number of parameters in function call"& @CRLF & "shell:")
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														EndIf
													Else
													If $dircopy Then
														$Comm=StringSplit($Input,"+")
														MsgBox(0,"",$Comm[0])
														If $Comm[0]=3 Then
															HotKeySet ("{enter}")
															Send (@CRLF & "Copying :" & $Comm[2]&" to: "&$Comm[3] & @CRLF & "shell:")
															DirCopy($Comm[2],$Comm[3])
															
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														Else
															HotKeySet ("{enter}")
															Send (@CRLF & "Incorrect number of parameters in function call"& @CRLF & "shell:")
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														EndIf
														Else
													If $filemove Then
														$Comm=StringSplit($Input,"+")
														MsgBox(0,"",$Comm[0])
														If $Comm[0]=3 Then
															HotKeySet ("{enter}")
															Send (@CRLF & "Copying :" & $Comm[2]&" to: "&$Comm[3] & @CRLF & "shell:")
															FileMove($Comm[2],$Comm[3])
															
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														Else
															HotKeySet ("{enter}")
															Send (@CRLF & "Incorrect number of parameters in function call"& @CRLF & "shell:")
															$line = $line + 4
															Sleep (100)
															HotKeySet ("{enter}", "read_func")
														EndIf																				
													Else
														HotKeySet ("{enter}")
														Send (@CRLF & "'" & $command & "'" & "is not a valid command" & @CRLF & "shell:")
														$line = $line + 4
														Sleep (100)
														HotKeySet ("{enter}", "read_func")
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
EndIf
EndIf
EndIf
EndIf
EndIf
EndIf
EndFunc   ;==>read_func

Func sys ()
	HotKeySet ("{enter}")
	$VOL = DriveGetLabel ("C:\")
	$SERIAL = DriveGetSerial ("C:\")
	$TOTAL = DriveSpaceTotal ("C:\")
	$FREE = DriveSpaceFree ("C:\")
	$FS = DriveGetFileSystem ("C:\")
	ClipPut (@CRLF & "monitor:")
	Send ("^v{enter}")
	ClipPut ("Ekraanilaius: " & @DesktopWidth)
	Send ("^v{enter}")
	ClipPut ("Ekraanikõrgus: " & @DesktopHeight)
	Send ("^v{enter}")
	ClipPut ("Ekraanivärskendus: " & @DesktopRefresh)
	Send ("^v{enter}")
	ClipPut ("Ekraanivärvisügavus: " & @DesktopDepth)
	Send ("^v{enter}")
	ClipPut ("Arvuti ja süsteem")
	Send ("^v{enter}")
	ClipPut ("Süsteemi keel: " & @OSLang)
	Send ("^v{enter}")
	ClipPut ("Süsteem_tüüp: " & @OSTYPE)
	Send ("^v{enter}")
	ClipPut ("Süsteem_versioon: " & @OSVersion)
	Send ("^v{enter}")
	ClipPut ("Süsteem_ehitus: " & @OSBuild)
	Send ("^v{enter}")
	ClipPut ("Süsteem_SP: " & @OSServicePack)
	Send ("^v{enter}")
	ClipPut ("Klaviatuuri paigutus: " & @KBLayout)
	Send ("^v{enter}")
	ClipPut ("Protsessori arhidektuur: " & @ProcessorArch)
	Send ("^v{enter}")
	ClipPut ("Arvuti nimi: " & @ComputerName)
	Send ("^v{enter}")
	ClipPut ("Hetkel aktiivne kasutaja: " & @UserName)
	Send ("^v{enter}")
	ClipPut ("windows on kataloogis: " & @WindowsDir)
	Send ("^v{enter}")
	ClipPut ("Windows on kettal: " & @HomeDrive)
	Send ("^v{enter}")
	ClipPut ("Kasutaja profiilid: " & @UserProfileDir)
	Send ("^v{enter}")
	ClipPut ("start menüü: " & @StartMenuDir)
	Send ("^v{enter}")
	ClipPut ("töölaua asukoht: " & @DesktopDir)
	Send ("^v{enter}")
	ClipPut ("start menüü: " & @StartMenuDir)
	Send ("^v{enter}")
	ClipPut ("ketta C:\ nimetus: " & $VOL)
	Send ("^v{enter}")
	ClipPut ("ketta C:\ kogu suurus: " & $TOTAL)
	Send ("^v{enter}")
	ClipPut ("ketta C:\ vabaruum: " & $FREE)
	Send ("^v{enter}")
	ClipPut ("ketta C:\ serialli nr: " & $SERIAL)
	Send ("^v{enter}")
	ClipPut ("ketta C:\ failisüsteem: " & $FS)
	Send ("^v{enter}")
	ClipPut ("IP aadress on: " & @IPAddress1)
	Send ("^v{enter}")
	HotKeySet ("{enter}", "read_func")
EndFunc   ;==>sys

Func df ()
	$line = _GUICtrlEdit_GetLineCount ($CommandInput) - 1
	$Input = _GUICtrlEdit_GetLine ($CommandInput, $line)
	$string = StringTrimLeft ($Input, 15)
	HotKeySet ("{enter}")
	$VOL = DriveGetLabel ($string)
	$SERIAL = DriveGetSerial ($string)
	$TOTAL = DriveSpaceTotal ($string)
	$FREE = DriveSpaceFree ($string)
	$FS = DriveGetFileSystem ($string)
	$Total2 = $TOTAL / 1000
	$free2 = $FREE / 1000
	$Used = $TOTAL - $FREE
	$Used2 = $Used / 1000
	$total3 = Round ($Total2, 2)
	$used3 = Round ($Used2, 2)
	$free3 = Round ($free2, 2)
	$percentused = $used3 / $total3 * 100
	$percentusedrounded = Round ($percentused, 1)
	$freepercent = 100 - $percentusedrounded
	ClipPut (@CRLF)
	Send ("^v{enter}")
	ClipPut ("Volume Label " & $VOL)
	Send ("^v{enter}")
	ClipPut ("Total size of " & $string & $total3 & " Gb")
	Send ("^v{enter}")
	ClipPut ("Free space on " & $string & $free3 & "Gb (" & $freepercent & " %)")
	Send ("^v{enter}")
	ClipPut ("Disk " & $string & " S\N " & $SERIAL)
	Send ("^v{enter}")
	ClipPut ("Drive " & $string & " File System " & $FS)
	Send ("^v{enter}")
	ClipPut ("Drive " & $string & " used " & $used3 & "Gb (" & $percentusedrounded & " %)")
	Send ("^v{enter}")
	HotKeySet ("{enter}", "read_func")
EndFunc   ;==>df


Func IncreaseFont ()
	$FontSize += 1
	GUICtrlSetFont ($CommandInput, $FontSize)
EndFunc   ;==>IncreaseFont
Func DecreaseFont ()
	$FontSize -= 1
	GUICtrlSetFont ($CommandInput, $FontSize)
EndFunc   ;==>DecreaseFont

Func fullscreen ()
	$width = @DesktopWidth
	$height = @DesktopHeight
	WinMove("Terminal","",0,0,$width,$height)
EndFunc	