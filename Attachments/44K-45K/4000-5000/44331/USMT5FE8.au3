#RequireAdmin
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Date.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

FileInstall("streams.exe", @TempDir & "\streams.exe", 1)
ShellExecuteWait(@TempDir & "\streams.exe", "/accepteula", @TempDir, "open", @SW_HIDE)
$LastState = 1
Global $StartTime
Global $WaitMessageDots
Global $WaitIncrease = True
Global $FoundSize = False
Global $ProgFile, $ListFiles, $CurrentFile

$Main = GUICreate("USMT5 Front End - MaxImuM AdVaNtAgE SofTWarE " & Chr(169) & " 2013", 500, 430, -1, -1, Default, $WS_EX_ACCEPTFILES)
GUISetBkColor(0xb2ccff, $Main)
GUISetFont(8.5, 400)
GUICtrlCreateLabel("Specify the location to save the backup ( type, browse, or drag path )", 10, 10, 480, 15)
$SavePath = GUICtrlCreateInput("", 10, 30, 445, 20)
GUICtrlSetState($SavePath, $GUI_DROPACCEPTED)
$BrowseSavePath = GUICtrlCreateButton("...", 460, 30, 30, 20)
GUICtrlCreateLabel("Customer Last Name or Business Name", 10, 80, 200, 15)
$Name = GUICtrlCreateInput("", 10, 100, 200, 20)
GUICtrlCreateLabel("Repair Number", 220, 80, 130, 15)
$Number = GUICtrlCreateInput("", 220, 100, 130, 20)
GUICtrlCreateLabel("Tech's Initials", 360, 80, 130, 15)
$Tech = GUICtrlCreateInput("", 360, 100, 130, 20)
$OfflineCheckbox = GUICtrlCreateCheckbox("Specify a path for offline recovery if not backing up this computer", 10, 200, 480, 15)
$Message1 = GUICtrlCreateLabel("( IE X:\Windows, X:\Winnt, etc )", 25, 215, 300, 15)
$OfflinePath = GUICtrlCreateInput("", 10, 235, 445, 20)
$Message2 = GUICtrlCreateLabel("( type, browse, or drag path )", 25, 260, 300, 15)
GUICtrlSetState($OfflinePath, $GUI_HIDE)
GUICtrlSetState($Message1, $GUI_HIDE)
GUICtrlSetState($Message2, $GUI_HIDE)
GUICtrlSetState($OfflinePath, $GUI_DROPACCEPTED)
$BrowseOfflinePath = GUICtrlCreateButton("...", 460, 235, 30, 20)
$Go = GUICtrlCreateButton("GO", 200, 310, 100, 50)
GUICtrlSetFont($Go, 20, 400)
$Cancel = GUICtrlCreateCheckbox("Cancel", 175, 310, 140, 50)
GUICtrlSetState($Cancel, $GUI_HIDE)
GUICtrlSetFont($Cancel, 20, 400)
$ShowTime = GUICtrlCreateLabel("", 390, 310, 100, 15, $SS_RIGHT)
$ShowSize = GUICtrlCreateLabel("", 390, 330, 100, 15, $SS_RIGHT)
$ProgressBar = GUICtrlCreateProgress(10, 380, 370, 20)
GUICtrlSetState($ProgressBar, $GUI_HIDE)
$ProgressText = GUICtrlCreateLabel("", 390, 383, 100, 15, $SS_RIGHT)
$ShowWaitMessage = GUICtrlCreateLabel("Please  wait, setting up", 174, 380, 110, 15)
GUICtrlSetState($ShowWaitMessage, $GUI_HIDE)
$ShowWaitMessageDots = GUICtrlCreateLabel($WaitMessageDots, 284, 380, 200, 15)
GUICtrlSetState($ShowWaitMessageDots, $GUI_HIDE)
$ShowCurrentFile = GUICtrlCreateLabel("", 10, 405, 480, 15, $DT_END_ELLIPSIS)
GUISetState(@SW_SHOW, $Main)

Local $AccelKeys[1][2] = [["{ENTER}", $Go]]
GUISetAccelerators($AccelKeys)

Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit

	If $MSG == $BrowseSavePath Then
		$Where = FileSelectFolder("Choose the location to save the data", "", 1 + 4)
		GUICtrlSetData($SavePath, $Where)
	EndIf
	If $MSG == $BrowseOfflinePath Then
		$Where = FileSelectFolder("Choose the WINDOWS location of the drive to save data", "")
		GUICtrlSetData($OfflinePath, $Where)
	EndIf

	If $MSG == $Go Then
		$GetName = StringUpper(StringReplace(GUICtrlRead($Name), "-", "_"))
		$GetNumber = StringUpper(StringReplace(GUICtrlRead($Number), "-", "_"))
		$GetTech = StringUpper(StringReplace(GUICtrlRead($Tech), "-", "_"))
		$GetSavePath = GUICtrlRead($SavePath)
		$GetOfflinePath = GUICtrlRead($OfflinePath)
		$GetWorkOffline = GUICtrlRead($OfflineCheckbox)
		If $GetWorkOffline == 1 Then
			$WorkingOffline = True
		Else
			$WorkingOffline = False
		EndIf

		If $GetName == "" Then
			MsgBox(16, "ERROR", "You have not specified a customer/business name, please do so now.")
		Else
			If $GetNumber == "" Then
				MsgBox(16, "ERROR", "You have not specified a repair number, please do so now.")
			Else
				If $GetTech == "" Then
					MsgBox(16, "ERROR", "You have not specified the technician, please do so now.")
				Else
					If $GetSavePath == "" Then
						MsgBox(16, "ERROR", "You have not specified a path to save the data, please do so now.")
					Else
						If $WorkingOffline == True And $GetOfflinePath == "" Then
							MsgBox(16, "ERROR", "You have specified that you are backing up an offline drive but have not specified an offline path, please do so now.")
						Else
							If $WorkingOffline == True And $GetOfflinePath <> "" And Not FileExists($GetOfflinePath & "\system32\config\software") Then
								MsgBox(16, "ERROR", "The offline path you have specified does not appear to be a valid Windows installation folder.  Please check the path.")
							Else
								$Date = _NowCalcDate()
								$DateBreak = StringSplit($Date, "/")
								$FullSavePath = StringUpper(StringReplace($GetSavePath & "\" & $GetName & "-" & $GetNumber & "-" & $GetTech & "-" & $DateBreak[2] & $DateBreak[3] & StringRight($DateBreak[1], 2), "\\", "\"))
								If StringLeft($FullSavePath, 1) == "\" Then $FullSavePath = "\" & $FullSavePath
								$Exist = FileExists($FullSavePath)
								Local $YesOrNo
								If $Exist Then $YesOrNo = MsgBox(4, "Overwrite?", "The save path specified already exists:" & @CR & $FullSavePath & @CR & @CR & "Overwrite?")
								If $YesOrNo == 6 Or Not $Exist Then
									$TempFile = _TempFile($FullSavePath)
									$TestTempFile = FileOpen($TempFile, 1 + 8)
									FileClose($TestTempFile)
									FileDelete($TempFile)
									If $TestTempFile == -1 Then
										MsgBox(16, "ERROR", "The path you have specified does not exist or is not writable.  Please check the path.")
									Else
										$StartTime = TimerInit()
										GUICtrlDelete($Go)
										GUICtrlSetState($Cancel, $GUI_SHOW)
										GUICtrlSetState($SavePath, $GUI_DISABLE)
										GUICtrlSetState($BrowseSavePath, $GUI_DISABLE)
										GUICtrlSetState($Name, $GUI_DISABLE)
										GUICtrlSetState($Number, $GUI_DISABLE)
										GUICtrlSetState($Tech, $GUI_DISABLE)
										GUICtrlSetState($OfflineCheckbox, $GUI_DISABLE)
										GUICtrlSetState($OfflinePath, $GUI_DISABLE)
										GUICtrlSetState($BrowseOfflinePath, $GUI_DISABLE)
										AdlibRegister("_PlayWithWaitMessage", 100)
										_RunStreams($FullSavePath, $WorkingOffline, $GetOfflinePath)
										_BuildUSMTCommand($FullSavePath, $WorkingOffline, $GetOfflinePath)
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	If $LastState == 4 And GUICtrlRead($OfflineCheckbox) == 1 Then
		GUICtrlSetState($OfflinePath, $GUI_SHOW)
		GUICtrlSetState($Message1, $GUI_SHOW)
		GUICtrlSetState($Message2, $GUI_SHOW)
		GUICtrlSetState($BrowseOfflinePath, $GUI_SHOW)
	EndIf
	If $LastState == 1 And GUICtrlRead($OfflineCheckbox) == 4 Then
		GUICtrlSetState($OfflinePath, $GUI_HIDE)
		GUICtrlSetState($Message1, $GUI_HIDE)
		GUICtrlSetState($Message2, $GUI_HIDE)
		GUICtrlSetState($BrowseOfflinePath, $GUI_HIDE)
	EndIf
	$LastState = GUICtrlRead($OfflineCheckbox)
Until True == False


Func _BuildUSMTCommand($sFullSavePath, $sWorkingOffline, $sOfflinePath)
	GUICtrlSetData($ShowCurrentFile, "Extracting USMT archives")
	GUICtrlSetState($ShowWaitMessage, $GUI_SHOW)
	GUICtrlSetState($ShowWaitMessageDots, $GUI_SHOW)
	$ListFiles = @TempDir & "\listfiles.txt"
	$ProgFile = @TempDir & "\prog.txt"
	$LogFile = '"' & $sFullSavePath & '\log.txt"'
	FileDelete($ListFiles)
	FileDelete($ProgFile)
	FileDelete($LogFile)
	FileInstall("7z.exe", @TempDir & "\7z.exe", 1)
	FileInstall("7z.dll", @TempDir & "\7z.dll", 1)

	If @OSArch == "X86" Then
		$Inst = FileInstall("x86.7z", @TempDir & "\x86.7z", 1)
		RunWait(@TempDir & '\7z.exe x "' & @TempDir & '\x86.7z" -o"' & @TempDir & '\USMT5" -y', @TempDir, @SW_HIDE)
	Else
		$Inst = FileInstall("amd64.7z", @TempDir & "\amd64.7z", 1)
		RunWait(@TempDir & '\7z.exe x "' & @TempDir & '\amd64.7z" -o"' & @TempDir & '\USMT5" -y', @TempDir, @SW_HIDE)
	EndIf
	ConsoleWrite("inst -> " & $Inst & @CR)
	$Arguments = '"' & $sFullSavePath & '"' & ' /o /localonly /nocompress /auto /c /vsc /l:' & $LogFile & ' /progress:"' & $ProgFile & '" /listfiles:"' & $ListFiles & '"'
	If $sWorkingOffline == True Then $Arguments &= ' /offlinewindir:' & $sOfflinePath
	GUICtrlSetData($ShowCurrentFile, "Looking for data")
	ShellExecuteWait(@TempDir & "\USMT5\scanstate.exe", $Arguments, $sFullSavePath, "open", @SW_HIDE)
	ShellExecute("notepad.exe", $LogFile, @TempDir, "open", @SW_MAXIMIZE)
	Sleep(5000)
	Send("^{END}")
	MsgBox(64, "Done", "USMT has finished.  Please review the end of the log and confirm that the backup finished with no errors.")
	Exit
EndFunc   ;==>_BuildUSMTCommand


Func _PlayWithWaitMessage()
	If GUICtrlRead($Cancel) == 1 Then
		$YesOrNo = MsgBox(4, "Quit?", "Do you really want to quit?")
		If $YesOrNo == 6 Then
			Do
				Sleep(10)
				ProcessClose("scanstate.exe")
			Until Not ProcessExists("scanstate.exe")
			Exit
		EndIf
		GUICtrlSetState($Cancel, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($ShowTime, _NiceTime(TimerDiff($StartTime) / 1000))

	If $WaitIncrease == True Then
		$WaitMessageDots &= "."
	Else
		$WaitMessageDots = StringTrimRight($WaitMessageDots, 1)
	EndIf
	GUICtrlSetData($ShowWaitMessageDots, $WaitMessageDots)

	If StringLen($WaitMessageDots) < 1 Then $WaitIncrease = True
	If StringLen($WaitMessageDots) > 30 Then $WaitIncrease = False

	If $FoundSize == False Then
		$OpenProg = FileOpen($ProgFile, 0)
		Do
			$Line = FileReadLine($OpenProg)
			If @error Then ExitLoop
			If StringInStr($Line, "totalPercentageCompleted") Then
				FileClose($OpenProg)
				AdlibUnRegister("_PlayWithWaitMessage")
				AdlibRegister("_Progress", 500)
				FileClose($OpenProg)
				$OpenProg = FileOpen($ProgFile, 0)
				Do
					$Line = FileReadLine($OpenProg)
					If @error Then ExitLoop
					If StringInStr($Line, "totalSizeInMBToTransfer") Then
						$Break = StringSplit($Line, ",")
						GUICtrlSetData($ShowSize, _ByteSuffix($Break[5]))
						GUICtrlDelete($ShowWaitMessage)
						GUICtrlDelete($ShowWaitMessageDots)
						GUICtrlSetState($ProgressBar, $GUI_SHOW)
						$FoundSize = True
						$StartTime = TimerInit()
						FileClose($OpenProg)
					EndIf
				Until True == False
			EndIf
		Until True == False
		FileClose($OpenProg)
	EndIf
EndFunc   ;==>_PlayWithWaitMessage


Func _Progress()
	If GUICtrlRead($Cancel) == 1 Then
		$YesOrNo = MsgBox(4, "Quit?", "Do you really want to quit?")
		If $YesOrNo == 6 Then
			Do
				Sleep(10)
				ProcessClose("scanstate.exe")
			Until Not ProcessExists("scanstate.exe")
			Do
				Sleep(10)
				ProcessClose("streams.exe")
			Until Not ProcessExists("streams.exe")
			Exit
		EndIf
		GUICtrlSetState($Cancel, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($ShowTime, _NiceTime(TimerDiff($StartTime) / 1000))

	$OpenProg = FileOpen($ProgFile, 0)
	$Line = FileReadLine($OpenProg, -1)
	FileClose($OpenProg)
	$BreakProg = StringSplit($Line, ", ", 1)
	If $BreakProg[1] > 4 Then
		If $BreakProg[5] == "Saving" Then
			GUICtrlSetData($ProgressBar, 100)
			GUICtrlSetData($ProgressText, "100%")
			GUICtrlDelete($Cancel)
			AdlibUnRegister()
		Else
			GUICtrlSetData($ProgressBar, $BreakProg[5])
			GUICtrlSetData($ProgressText, $BreakProg[5] & "%")
		EndIf
	EndIf
	$LastFile = $CurrentFile
	$Count = _FileCountLines($ListFiles)
	$OpenList = FileOpen($ListFiles, 0)
	$CurrentFile = FileReadLine($OpenList, $Count)
	FileClose($OpenList)
	If $LastFile <> $CurrentFile Then GUICtrlSetData($ShowCurrentFile, StringTrimLeft($CurrentFile, 3))
EndFunc   ;==>_Progress


Func _NiceTime($iSecs)
	Return StringFormat('%02i:%02i:%02i', Floor($iSecs / 3600), Floor(Mod($iSecs, 3600) / 60), Mod($iSecs, 60))
EndFunc   ;==>_NiceTime


Func _ByteSuffix($Bytes)
	Local $BytesSuffix[4] = [" MB", " GB", " TB", " PB"]
	$x = 0
	While $Bytes > 1023
		$x += 1
		$Bytes /= 1024
	WEnd
	Return StringFormat('%.2f', $Bytes) & $BytesSuffix[$x]
EndFunc   ;==>_ByteSuffix


Func _RunStreams($rsFullSavePath, $rsWorkingOffline, $rsGetOfflinePath)
	If $rsWorkingOffline == True Then
		$rsDrive = StringLeft($rsGetOfflinePath, 1)
	Else
		$rsDrive = StringLeft(@WindowsDir, 1)
	EndIf

	$rsExclusions = StringSplit("application data|local settings|userdata|appdata", "|")

	$rsDocsFolder = $rsDrive & ":\documents and settings"
	For $a = 1 To 2
		$GetUserDirs = FileFindFirstFile($rsDocsFolder & "\*.*")
		Do
			$User = FileFindNextFile($GetUserDirs)
			If @error Then ExitLoop
			If StringInStr(FileGetAttrib($rsDocsFolder & "\" & $User), "D") Then
				GUICtrlSetData($ShowCurrentFile, 'Setting files in ' & $rsDocsFolder & '\' & $User & ' to "unblocked"')
				ShellExecuteWait(@TempDir & "\streams.exe", "-d " & $rsDocsFolder & "\" & $User, @TempDir, "open", @SW_HIDE)
				$GetDocDirs = FileFindFirstFile($rsDocsFolder & "\" & $User & "\*.*")
				Do
					$FoundFolders = FileFindNextFile($GetDocDirs)
					If @error Then ExitLoop
					If StringInStr(FileGetAttrib($rsDocsFolder & "\" & $User & "\" & $FoundFolders), "D") Then
						$CanRunStream = True
						For $b = 1 To $rsExclusions[0]
							If StringLower($FoundFolders) == $rsExclusions[$b] Then $CanRunStream = False
						Next
						If $CanRunStream == True Then
							GUICtrlSetData($ShowCurrentFile, 'Setting files in ' & $rsDocsFolder & '\' & $User & '\' & $FoundFolders & ' to "unblocked"')
							ShellExecuteWait(@TempDir & "\streams.exe", "-s -d " & $rsDocsFolder & "\" & $User & "\" & $FoundFolders, @TempDir, "open", @SW_HIDE)
						EndIf
					EndIf
				Until True == False
			EndIf
		Until True == False
		$rsDocsFolder = $rsDrive & ":\users"
	Next
EndFunc   ;==>_RunStreams
