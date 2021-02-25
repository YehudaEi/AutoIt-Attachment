#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****


;~ "Sync" - An app designed to facilitate easy copying of large amounts of files from one location to another, quickly, skipping files that do not need to
;~ be copied, with lots of real-time status information, and with several verification methods.
;~ Coded by Ian Maxwell (llewxam @ www.autoitscript/forum)
;~ Autoit 3.3.6.1
;~ 		Command line usage:
;~ 			Sync (Source path) (Destination path) {OPTIONAL [/VerifyMethod] [/PreserveDates] [/DeleteAfterSync] [/Mirror] [/Shutdown]}
;~ 		Command line switches:
;~ 			The Source and Destination paths follow standard DOS syntax rules, so if your paths include a space make sure you either put the path in quotes or
;~ 			use the DOS/short-name path (i.e. c:\progra~1\ rather than C:\Program Files\).  When using the command line switches, the Source and Destination
;~ 			paths are the only required arguments.
;~ 			/VerifyMethod:			By default an IfExist is used.
;~				/VerifyBySize		If the file sizes are different the Destination file is overwritten.
;~				/VerifyByDate		If the Source file's Modified timestamp is newer the Destination file is overwritten.
;~				/VerifyByMD5		If the Source and Destination file's MD5 hashes are different the Destination file is overwritten.
;~ 			/PreserveDates:			Off by default.  If used, the Source file's Created, Accessed, and Modified timestamps are applied to the Destination file.
;~ 									Otherwise, the current day and time are used.
;~ 			/DeleteAfterSync:		Off by default.  If used, the Source file is deleted upon sync completion.
;~ 									If a file copy fails, the Source file will not be deleted.
;~ 			/Mirror:				Off by default.  If used, files in the Destination that do not exist in the Source are deleted.  This can be fairly time-consuming.
;~ 			/Shutdown:				Off by default.  If used, the computer is shut down when the sync is completed.

;~ Thanks to:
;~ 		wraithdu for _LargeFileCopy						http://www.autoitscript.com/forum/topic/116880-largefilecopy-udf
;~ 		BaKaMu and others for _FileListToArrayXT		http://www.autoitscript.com/forum/topic/96952-improvement-of-included-filelisttoarray-function/page__view__findpost__p__825298
;~ 		Prog@ndy for GDIpProgress						http://www.autoitscript.com/forum/topic/74649-progressbar-with-gdiplus
;~ 		Ward for his machine code MD5					http://www.autoitscript.com/forum/topic/121985-autoit-machine-code-algorithm-collection
;~ 		Spiff59 for multiple suggestions and improvements to this script
;~ 		Melba23 for consistently good suggestions and advice!!


#include <MD5.au3>;										aquire this at the link above to compile
#include <Date.au3>
#include <Array.au3>
#include <GDIpProgress.au3>;							aquire this at the link above to compile
#include <StaticConstants.au3>
#include <ProgressConstants.au3>


;~ configure all options necessary for start
Local $MarqueeProgress, $FileCount, $TotalSize, $TotalTally, $FileCopiedSoFar, $OldSpeedCalcTally, $CopyDestination, $SyncedFiles, $SkippedFiles, $ScanningPath, $Green = 0x00ff11, $Blue = 0xb2ccff
Local $Started = False, $MarqueeScroll = False, $Mirroring = False
Local $Failed[1] = [0]
Local $DeleteAfterSync = False, $Mirror = False, $PreserveDates = False, $ShutdownWhenFinished = False, $RunWithSwitches = False, $VerifyMethod = "Exist"

;~ options for _StringAddThousandsSep
Local $rKey = "HKCU\Control Panel\International"
Local $sThousands = ',', $sDecimal = '.'
If $sDecimal = -1 Then $sDecimal = RegRead($rKey, "sDecimal")
If $sThousands = -1 Then $sThousands = RegRead($rKey, "sThousand")

;~ buffer for _LargeFileCopy
$iToRead = 1024 * 1024 * 8 ; 8 MB buffer, arbitrary


;~ check for command line switches
If $CmdLine[0] Then
	If $CmdLine[0] < 2 Then
		MsgBox(16, "ERROR", "Invalid number of arguments - in order to use the command line switches, you MUST specify at least the source path and the destination path.")
		Exit
	EndIf
	$RunWithSwitches = True
	$Source = $CmdLine[1]
	$Target = $CmdLine[2]
	If $CmdLine[0] > 2 Then
		$VerifyModeSet = False
		For $c = 3 To $CmdLine[0]
			$ValidCmdLine = False
			Select
				Case StringLower($CmdLine[$c]) == "/verifybysize"
					If $VerifyModeSet == True Then
						MsgBox(16, "ERROR", "You must only set one VerifyBy type at a time.  Check your syntax.")
						Exit
					Else
						$VerifyMethod = "Size"
						$VerifyModeSet = True
						$ValidCmdLine = True
					EndIf
				Case StringLower($CmdLine[$c]) == "/verifybydate"
					If $VerifyModeSet == True Then
						MsgBox(16, "ERROR", "You must only set one VerifyBy type at a time.  Check your syntax.")
						Exit
					Else
						$VerifyMethod = "Date"
						$VerifyModeSet = True
						$ValidCmdLine = True
					EndIf
				Case StringLower($CmdLine[$c]) == "/verifybymd5"
					If $VerifyModeSet == True Then
						MsgBox(16, "ERROR", "You must only set one VerifyBy type at a time.  Check your syntax.")
						Exit
					Else
						$VerifyMethod = "MD5"
						$VerifyModeSet = True
						$ValidCmdLine = True
					EndIf
				Case StringLower($CmdLine[$c]) == "/preservedates"
					$PreserveDates = True
					$ValidCmdLine = True
				Case StringLower($CmdLine[$c]) == "/deleteaftersync"
					$DeleteAfterSync = True
					$ValidCmdLine = True
				Case StringLower($CmdLine[$c]) == "/mirror"
					$Mirror = True
					$ValidCmdLine = True
				Case StringLower($CmdLine[$c]) == "/shutdown"
					$ShutdownWhenFinished = True
					$ValidCmdLine = True
			EndSelect
			If $ValidCmdLine == False Then
				MsgBox(16, "ERROR", "Improper syntax: " & $CmdLine[$c])
				Exit
			EndIf
		Next
	EndIf
EndIf


;~ set up GUI
$TitleText = @ScriptName
If StringInStr($TitleText, ".") Then $TitleText = StringTrimRight($TitleText, 4)
$NewTitle = $TitleText
$GUI = GUICreate($NewTitle, 400, 310, Default, Default, -1, $WS_EX_ACCEPTFILES)
GUISetBkColor($Blue, $GUI)
GUICtrlSetDefBkColor($Blue)
GUISetFont(8.5)
$SourceButton = GUICtrlCreateButton("Source", 5, 5, 50, 20)
$ShowFileCount = GUICtrlCreateLabel("", 295, 15, 100, 15, $SS_RIGHT)
$SourceInput = GUICtrlCreateInput("", 5, 30, 250, 20)
$ScanPathShow = GUICtrlCreateLabel("", 5, 60, 250, 15, $DT_END_ELLIPSIS)
$MarqueeBanner = GUICtrlCreateProgress(115, 5, 170, 20, BitOR($PBS_SMOOTH, $PBS_MARQUEE))
$ShowFileSize = GUICtrlCreateLabel("", 295, 30, 100, 15, $SS_RIGHT)
$ShowSpeed = GUICtrlCreateLabel("", 295, 45, 100, 20, $SS_RIGHT)
$DestinationInput = GUICtrlCreateInput("", 5, 60, 250, 20)
$DestinationButton = GUICtrlCreateButton("Destination", 5, 85, 70, 20)
$GoButton = GUICtrlCreateButton("GO", 185, 120, 30, 20)
$FileName = GUICtrlCreateLabel("", 5, 150, 300, 15, $DT_END_ELLIPSIS)
$FileSize = GUICtrlCreateLabel("", 320, 150, 75, 15, $SS_RIGHT)
$ShowSynced = GUICtrlCreateLabel("", 295, 80, 100, 15, $SS_RIGHT)
$ShowSkipped = GUICtrlCreateLabel("", 295, 95, 100, 15, $SS_RIGHT)
$ShowFailed = GUICtrlCreateLabel("", 295, 110, 100, 15, $SS_RIGHT)

GUICtrlCreateGroup("Sync/verify copy by: (fastest, slower, slowest)", 5, 210, 285, 45)
$VerifyByExist = GUICtrlCreateRadio("If Exist", 15, 230, 50, 20)
GUICtrlSetTip(-1, "If Destination does not exist, sync")
$VerifyBySize = GUICtrlCreateRadio("File Size", 72, 230, 60, 20)
GUICtrlSetTip(-1, "If Destination size is different, sync")
$VerifyByDate = GUICtrlCreateRadio("Date", 135, 230, 40, 20)
GUICtrlSetTip(-1, "If Destination is older, sync")
$VerifyByMD5 = GUICtrlCreateRadio("MD5 Hash", 185, 230, 95, 20)
GUICtrlSetTip(-1, "If Destination contents are different, sync")
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Mirror", 300, 210, 95, 45)
$NoMirror = GUICtrlCreateRadio("No", 310, 230, 30, 20)
$YesMirror = GUICtrlCreateRadio("Yes", 350, 230, 35, 20)
GUICtrlSetTip(-1, "Remove anything in the Destination that is not in the Source.  WARNING: MAY BE SLOW!!!")
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Delete after sync:", 5, 260, 105, 45)
$NoDelete = GUICtrlCreateRadio("No", 15, 280, 40, 20)
$YesDelete = GUICtrlCreateRadio("Yes", 65, 280, 40, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Preserve File Dates:", 127, 260, 125, 45)
$NoPreserveDates = GUICtrlCreateRadio("No", 137, 280, 40, 20)
GUICtrlSetTip(-1, "Not preserving the file date is faster, but the Create, Access, and Modify dates are changed to today")
$YesPreserveDates = GUICtrlCreateRadio("Yes", 187, 280, 40, 20)
GUICtrlSetTip(-1, "Keeps the file Create, Access, and Modify dates in tact")
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Shutdown when done:", 270, 260, 125, 45)
$NoShutdownWhenDone = GUICtrlCreateRadio("No", 280, 280, 40, 20)
$YesShutdownWhenDone = GUICtrlCreateRadio("Yes", 335, 280, 40, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$ShowElapsedTime = GUICtrlCreateLabel("", 142, 88, 120, 15)
$Quit = GUICtrlCreateCheckbox("QUIT", 195, 120, 80, 20)

GUICtrlSetState($SourceInput, $GUI_DROPACCEPTED)
GUICtrlSetState($MarqueeBanner, $GUI_HIDE)
GUICtrlSetState($DestinationButton, $GUI_HIDE)
GUICtrlSetState($DestinationInput, $GUI_DROPACCEPTED)
GUICtrlSetState($DestinationInput, $GUI_HIDE)
GUICtrlSetState($ScanPathShow, $GUI_HIDE)
GUICtrlSetState($GoButton, $GUI_HIDE)
GUICtrlSetState($VerifyByExist, $GUI_CHECKED)
GUICtrlSetState($NoPreserveDates, $GUI_CHECKED)
GUICtrlSetState($NoShutdownWhenDone, $GUI_CHECKED)
GUICtrlSetState($NoDelete, $GUI_CHECKED)
GUICtrlSetState($ShowElapsedTime, $GUI_HIDE)
GUICtrlSetState($Quit, $GUI_HIDE)
GUICtrlSetState($NoMirror, $GUI_CHECKED)
GUICtrlSetFont($Quit, 12, 800)
GUICtrlSetTip($SourceButton, "If the Source field is blank a " & Chr(34) & "Browse for Folder" & Chr(34) & " dialog is opened.  You may type a path or use Drag and Drop instead, in which case the button will validate the path.", Default, 1, 1)
GUICtrlSetTip($DestinationButton, "If the Destination field is blank a " & Chr(34) & "Browse for Folder" & Chr(34) & " dialog is opened.  You may type a path or use Drag and Drop instead, in which case the button will validate the path.", Default, 1, 1)

$LogoColor = 0xffffff
GUICtrlCreateLabel("Ian Maxwell", 5, 110, 160, 15)
GUICtrlSetColor(-1, $LogoColor)
GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE", 5, 130, 160, 15)
GUICtrlSetColor(-1, $LogoColor)
$Line = GUICtrlCreateGraphic(5, 125, 110, 2)
GUICtrlSetGraphic($Line, $GUI_GR_COLOR, $LogoColor)
GUICtrlSetGraphic($Line, $GUI_GR_MOVE, 0, 1)
GUICtrlSetGraphic($Line, $GUI_GR_LINE, 110, 1)

GUISetState(@SW_SHOW, $GUI)
;~ done with GUI


Do
	$MSG = GUIGetMsg()
	If $MSG = $GUI_EVENT_CLOSE Then Exit
	If $RunWithSwitches == True Then
		Select
			Case $VerifyMethod = "Size"
				GUICtrlSetState($VerifyBySize, $GUI_CHECKED)
			Case $VerifyMethod = "Date"
				GUICtrlSetState($VerifyByDate, $GUI_CHECKED)
			Case $VerifyMethod = "MD5"
				GUICtrlSetState($VerifyByMD5, $GUI_CHECKED)
		EndSelect
		If $DeleteAfterSync = True Then GUICtrlSetState($YesDelete, $GUI_CHECKED)
		If $Mirror = True Then GUICtrlSetState($YesMirror, $GUI_CHECKED)
		If $PreserveDates = True Then GUICtrlSetState($YesPreserveDates, $GUI_CHECKED)
		If $ShutdownWhenFinished = True Then GUICtrlSetState($YesShutdownWhenDone, $GUI_CHECKED)

		If Not FileExists($Source) Then
			MsgBox(48, "ERROR", "There has been a problem with the source specified, please check the source location:" & @CRLF & @CRLF & $Source)
			Exit
		Else
			If StringLen($Source) > 3 Then
				$SourcePathLength = StringLen($Source) + 1
			Else
				$SourcePathLength = 3
			EndIf
			$attrib = FileGetAttrib($Source)
			If StringInStr($attrib, "D") Then
				$MarqueeScroll = True
				AdlibRegister("_MarqueeScroll", 50)
				AdlibRegister("_SpeedCalc")
				GUICtrlSetState($MarqueeBanner, $GUI_SHOW)
				GUICtrlSetState($ScanPathShow, $GUI_SHOW)
				$FileList = _FileListToArrayXT($Source, Default, 1, 2, True)
				$FinalSize = $TotalSize
				AdlibUnRegister("_MarqueeScroll")
				AdlibUnRegister("_SpeedCalc")
				$MarqueeScroll = False
				GUICtrlSetData($ShowFileCount, _StringAddThousandsSep($FileCount) & " Files")
				GUICtrlSetState($MarqueeBanner, $GUI_HIDE)
			Else
				$TotalSize = FileGetSize($Source)
				$FileCount = 1
				$Source &= "|" & $TotalSize
				$FileList = StringSplit($Source, "|")
				GUICtrlSetData($ShowFileCount, "1 File")
			EndIf
			GUICtrlDelete($ScanPathShow)
			GUICtrlSetData($SourceInput, $Source)
			GUICtrlSetState($SourceInput, $GUI_DISABLE)
			GUICtrlSetData($ShowFileSize, _ByteSuffix($TotalSize))
			GUICtrlSetState($DestinationButton, $GUI_SHOW)
			GUICtrlSetState($DestinationInput, $GUI_SHOW)
			GUICtrlSetData($DestinationInput, $Target)
			GUICtrlSetState($DestinationInput, $GUI_DISABLE)
			GUICtrlSetState($DestinationButton, $GUI_DISABLE)

			If Not FileExists($Target) Then
				$create = DirCreate($Target)
				If $create == 0 Then
					MsgBox(48, "ERROR", "There has been a problem with the source specified, please check the source location:" & @CRLF & @CRLF & $Target)
					Exit
				EndIf
			EndIf
		EndIf

		If StringRight($Target, 1) <> "\" Then $Target &= "\"
		$MSG = $GoButton
	EndIf

	If $MSG = $SourceButton Then
		$FoundLegitSource = False
		$Source = GUICtrlRead($SourceInput)
		If $Source <> "" Then
			If Not FileExists($Source) Then
				MsgBox(48, "ERROR", "There has been a problem with the source specified, please check the source location:" & @CRLF & @CRLF & $Source)
				GUICtrlSetData($SourceInput, "")
			Else
				$FoundLegitSource = True
			EndIf
		Else
			$Source = FileSelectFolder("Select the source folder to be synchronized", "")
			If Not FileExists($Source) Then
				MsgBox(48, "ERROR", "There has been a problem with the source specified, please check the source location:" & @CRLF & @CRLF & $Source)
				GUICtrlSetData($SourceInput, "")
			Else
				GUICtrlSetData($SourceInput, $Source)
				$FoundLegitSource = True
			EndIf
		EndIf
		If $FoundLegitSource = True Then
			If StringLen($Source) > 3 Then
				$SourcePathLength = StringLen($Source) + 1
			Else
				$SourcePathLength = 3
			EndIf
			$attrib = FileGetAttrib($Source)
			If StringInStr($attrib, "D") Then
				$MarqueeScroll = True
				AdlibRegister("_MarqueeScroll", 50)
				AdlibRegister("_SpeedCalc")
				GUICtrlSetState($MarqueeBanner, $GUI_SHOW)
				GUICtrlSetState($ScanPathShow, $GUI_SHOW)
				$FileList = _FileListToArrayXT($Source, Default, 1, 2, True)
				GUICtrlDelete($ScanPathShow)
				$FinalSize = $TotalSize
				AdlibUnRegister("_MarqueeScroll")
				AdlibUnRegister("_SpeedCalc")
				$MarqueeScroll = False
				GUICtrlSetData($SourceInput, $Source)
				GUICtrlSetState($SourceInput, $GUI_DISABLE)
				GUICtrlSetData($ShowFileCount, _StringAddThousandsSep($FileCount) & " Files")
				GUICtrlSetState($MarqueeBanner, $GUI_HIDE)
				GUICtrlSetData($ShowFileSize, _ByteSuffix($TotalSize))
				GUICtrlSetState($DestinationButton, $GUI_SHOW)
				GUICtrlSetState($DestinationInput, $GUI_SHOW)
				GUICtrlSetState($SourceButton, $GUI_DISABLE)
			Else
				$TotalSize = FileGetSize($Source)
				$FileCount = 1
				$Source &= "|" & $TotalSize
				$FileList = StringSplit($Source, "|")
				GUICtrlSetData($SourceInput, $Source)
				GUICtrlSetData($ShowFileCount, "1 File")
				GUICtrlSetData($ShowFileSize, _ByteSuffix($TotalSize))
				GUICtrlSetState($DestinationButton, $GUI_SHOW)
				GUICtrlSetState($DestinationInput, $GUI_SHOW)
				GUICtrlSetState($SourceButton, $GUI_DISABLE)
				ControlFocus($TitleText, "", $DestinationButton)
			EndIf
		EndIf
	EndIf

	If $MSG = $DestinationButton Then
		$FoundLegitSource = False
		$Target = GUICtrlRead($DestinationInput)
		If $Target <> "" Then
			If Not FileExists($Target) Then
				$create = DirCreate($Target)
				If $create = 0 Then
					MsgBox(48, "ERROR", "There has been a problem with the source specified, please check the source location:" & @CRLF & @CRLF & $Target)
					GUICtrlSetData($DestinationInput, "")
				Else
					$FoundLegitSource = True
				EndIf
			Else
				$FoundLegitSource = True
			EndIf
		Else
			$Target = FileSelectFolder("Select the destination folder", @DesktopDir, 1)
			If Not FileExists($Target) Then
				MsgBox(48, "ERROR", "There has been a problem with the source specified, please check the source location:" & @CRLF & @CRLF & $Target)
				GUICtrlSetData($DestinationInput, "")
			Else
				GUICtrlSetData($DestinationInput, $Target)
				GUICtrlSetState($DestinationInput, $GUI_DISABLE)
				GUICtrlSetState($DestinationButton, $GUI_DISABLE)
				$FoundLegitSource = True
			EndIf
		EndIf
		If StringRight($Target, 1) <> "\" Then $Target &= "\"
		If $FoundLegitSource = True Then GUICtrlSetState($GoButton, $GUI_SHOW)
	EndIf

	If $MSG = $GoButton Then
		If BitAND(GUICtrlRead($VerifyBySize), $GUI_CHECKED) Then $VerifyMethod = "Size"
		If BitAND(GUICtrlRead($VerifyByDate), $GUI_CHECKED) Then $VerifyMethod = "Date"
		If BitAND(GUICtrlRead($VerifyByMD5), $GUI_CHECKED) Then $VerifyMethod = "MD5"
		If BitAND(GUICtrlRead($YesDelete), $GUI_CHECKED) Then $DeleteAfterSync = True
		If BitAND(GUICtrlRead($YesPreserveDates), $GUI_CHECKED) Then $PreserveDates = True
		GUICtrlSetState($ShowElapsedTime, $GUI_SHOW)
		GUICtrlSetState($Quit, $GUI_SHOW)
		GUICtrlSetState($SourceButton, $GUI_DISABLE)
		GUICtrlSetState($DestinationButton, $GUI_DISABLE)
		GUICtrlSetState($SourceInput, $GUI_DISABLE)
		GUICtrlSetState($DestinationInput, $GUI_DISABLE)
		GUICtrlSetState($VerifyByExist, $GUI_DISABLE)
		GUICtrlSetState($VerifyBySize, $GUI_DISABLE)
		GUICtrlSetState($VerifyByDate, $GUI_DISABLE)
		GUICtrlSetState($VerifyByMD5, $GUI_DISABLE)
		GUICtrlSetState($NoDelete, $GUI_DISABLE)
		GUICtrlSetState($YesDelete, $GUI_DISABLE)
		GUICtrlSetState($NoPreserveDates, $GUI_DISABLE)
		GUICtrlSetState($YesPreserveDates, $GUI_DISABLE)
		GUICtrlDelete($GoButton)
		$FileProg = _ProgressCreate(5, 180, 390, 10, $Green, $Green, $Blue, $Blue)
		_ProgressSetText($FileProg, "")
		$TotalProg = _ProgressCreate(5, 190, 390, 10, $Green, $Green, $Blue, $Blue)
		_ProgressSetText($TotalProg, "")

		If StringLeft($Source, 2) == "\\" Then
			$SourceUNCPrefix = "\\?\UNC"
			_ArrayTrim($FileList, 1, 0, 1)
			$SourcePathLength -= 1
		Else
			$SourceUNCPrefix = "\\?\"
		EndIf

		If StringLeft($Target, 2) == "\\" Then
			$TargetUNCPrefix = "\\?\UNC"
		Else
			$TargetUNCPrefix = "\\?\"
		EndIf

;~      get to work!
		$Started = True
		$Time = TimerInit()
		$TimeLastHere = TimerInit()
		AdlibRegister("_SpeedCalc")
		$SourceString = ""
		$DestinationString = ""
		For $a = 1 To $FileList[0] Step 2
			$CopySource = $FileList[$a]
			$TrimPath = StringTrimLeft($CopySource, $SourcePathLength)
			$Destination = $Target & $TrimPath
			$NewDir = StringMid($Destination, 1, StringInStr($Destination, "\", 2, -1) - 1)
			If Not FileExists($NewDir) Then DirCreate($NewDir)
			$CopySize = $FileList[$a + 1]
			_Copy($SourceUNCPrefix & $CopySource, $TargetUNCPrefix & $Destination, $CopySize)
		Next
;~      done...

;~ 		mirror option check
		If BitAND(GUICtrlRead($YesMirror), $GUI_CHECKED) Then $Mirror = True
		If $Mirror == True Then
			$Mirroring = True
			GUICtrlSetState($YesMirror, $GUI_DISABLE)
			GUICtrlSetState($NoMirror, $GUI_DISABLE)
			GUICtrlDelete($FileSize)
			$CopySource = "Running Mirror now..."
			If StringRight($Source, 1) <> "\" Then $Source &= "\"
			$DestinationList = _FileListToArrayXT($Target, Default, 1, 2, True)
			$SaveCount = $DestinationList[0]

			Local $NewFileList[($FileList[0] / 2) + 1]
			$NewFileList[0] = ($FileList[0] / 2)
			For $a = 1 To $FileList[0] Step 2
				$NewFileList[$a / 2 + 1] = StringUpper($FileList[$a])
			Next
			_ArraySort($NewFileList)
			_ArrayDelete($NewFileList, 0)

			_ArrayTrim($DestinationList, StringLen($Target))
			$DestinationList[0] = $SaveCount
			For $a = 1 To $DestinationList[0]
				$File = StringUpper($Source & $DestinationList[$a])
				$Index = _ArrayBinarySearch($NewFileList, $File)
				If $Index == -1 Then
					FileDelete($Target & $DestinationList[$a])
				EndIf
				$FileCount -= 1
			Next
			AdlibUnRegister()
			GUICtrlSetData($ShowFileCount, "0")
			_EmptyDirKill($Target)
		EndIf

;~ 		closeing GUI updates and checks
		AdlibUnRegister()
		$Started = False
		GUICtrlSetData($ShowSynced, _StringAddThousandsSep($SyncedFiles) & " Synced")
		GUICtrlSetData($ShowSkipped, _StringAddThousandsSep($SkippedFiles) & " Skipped")
		GUICtrlSetData($ShowFailed, _StringAddThousandsSep(UBound($Failed) - 1) & " Failed")
		GUICtrlSetState($ShowFileCount, $GUI_HIDE)
		GUICtrlSetState($ShowFileSize, $GUI_HIDE)
		GUICtrlSetState($ShowSpeed, $GUI_HIDE)
		GUICtrlSetState($FileName, $GUI_HIDE)
		GUICtrlSetState($FileSize, $GUI_HIDE)
		WinSetTitle($NewTitle, "", "100% - " & $TitleText)
		If $DeleteAfterSync == True Then
			_EmptyDirKill($Source)
		EndIf
		If GUICtrlRead($YesMirror) == 1 Then
			$Mirror = True
		Else
			$Mirror = False
		EndIf
		If BitAND(GUICtrlRead($YesShutdownWhenDone), $GUI_CHECKED) Then
			$ShutdownWhenFinished = True
		Else
			$ShutdownWhenFinished = False
		EndIf
		If $ShutdownWhenFinished == True Then
			Shutdown(1 + 4 + 16)
		Else
			If $RunWithSwitches == False Then
				MsgBox(0, "Done", "The syncronization is now finished.")
				If UBound($Failed) > 1 Then
					_ArrayDelete($Failed, 0)
					_ArrayDisplay($Failed, "Failed Items")
				EndIf
			Else
				MsgBox(0, "Done", "The syncronization is now finished.", 3)
				Exit
			EndIf
		EndIf
		Exit
	EndIf
Until 1 = 2


Func _FileListToArrayXT($sPath = @ScriptDir, $sFilter = "*", $iRetItemType = 0, $iRetPathType = 0, $bRecursive = False, $sExclude = "", $iRetFormat = 1)
	Local $hSearchFile, $sFile, $sFileList, $sWorkPath, $sRetPath, $iRootPathLen, $iPCount, $iFCount, $fDirFlag
	If $sPath = -1 Or $sPath = Default Then $sPath = @ScriptDir
	$sPath = StringRegExpReplace(StringRegExpReplace($sPath, "(\s*;\s*)+", ";"), "\A;|;\z", "")
	If $sPath = "" Then Return SetError(1, 1, "")
	If $sFilter = -1 Or $sFilter = Default Then $sFilter = "*"
	$sFilter = StringRegExpReplace(StringRegExpReplace($sFilter, "(\s*;\s*)+", ";"), "\A;|;\z", "")
	If StringRegExp($sFilter, "[\\/><:\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
	If $bRecursive Then
		$sFilter = StringRegExpReplace($sFilter, '([\Q\.+[^]$(){}=!\E])', '\\$1')
		$sFilter = StringReplace($sFilter, "?", ".")
		$sFilter = StringReplace($sFilter, "*", ".*?")
		$sFilter = "(?i)\A(" & StringReplace($sFilter, ";", "$|") & "$)" ;case-insensitive, convert ';' to '|', match from first char, terminate strings
	EndIf
	If $iRetItemType <> "1" And $iRetItemType <> "2" Then $iRetItemType = "0"
	If $iRetPathType <> "1" And $iRetPathType <> "2" Then $iRetPathType = "0"
	$bRecursive = ($bRecursive = "1")
	If $sExclude = -1 Or $sExclude = Default Then $sExclude = ""
	If $sExclude Then
		$sExclude = StringRegExpReplace(StringRegExpReplace($sExclude, "(\s*;\s*)+", ";"), "\A;|;\z", "")
		$sExclude = StringRegExpReplace($sExclude, '([\Q\.+[^]$(){}=!\E])', '\\$1')
		$sExclude = StringReplace($sExclude, "?", ".")
		$sExclude = StringReplace($sExclude, "*", ".*?")
		$sExclude = "(?i)\A(" & StringReplace($sExclude, ";", "$|") & "$)" ;case-insensitive, convert ';' to '|', match from first char, terminate strings
	EndIf
	If Not ($iRetItemType = 0 Or $iRetItemType = 1 Or $iRetItemType = 2) Then Return SetError(3, 3, "")
	Local $aPath = StringSplit($sPath, ';', 1) ;paths array
	Local $aFilter = StringSplit($sFilter, ';', 1) ;filters array
	For $iPCount = 1 To $aPath[0] ;Path loop
		$sPath = StringRegExpReplace($aPath[$iPCount], "[\\/]+\z", "") & "\" ;ensure exact one trailing slash
		If Not FileExists($sPath) Then ContinueLoop
		$iRootPathLen = StringLen($sPath) - 1
		Local $aPathStack[1024] = [1, $sPath]
		While $aPathStack[0] > 0
			$sWorkPath = $aPathStack[$aPathStack[0]]
			$aPathStack[0] -= 1
			$hSearchFile = FileFindFirstFile($sWorkPath & '*')
			If @error Then
				FileClose($hSearchFile)
				ContinueLoop
			EndIf
			$sRetPath = $sWorkPath
			While True ;Files only
				$sFile = FileFindNextFile($hSearchFile)
				If @error Then
					FileClose($hSearchFile)
					ExitLoop
				EndIf
				If @extended Then
					$aPathStack[0] += 1
					If UBound($aPathStack) <= $aPathStack[0] Then ReDim $aPathStack[UBound($aPathStack) * 2]
					$aPathStack[$aPathStack[0]] = $sWorkPath & $sFile & "\"
					ContinueLoop
				EndIf
				If StringRegExp($sFile, $sFilter) Then
					$FileCount += 1
					$sFileList &= $sRetPath & $sFile & "|"
					If $Mirroring == False Then
						$ScanningPath = $sRetPath
						$Size = FileGetSize($sRetPath & $sFile)
						$TotalSize += $Size
						$sFileList &= $Size & "|"
					EndIf
				EndIf
			WEnd
		WEnd
		FileClose($hSearchFile)
	Next ;$iPCount - next path
	If $sFileList Then
		Switch $iRetFormat
			Case 2 ;return a delimited string
				Return StringTrimRight($sFileList, 1)
			Case 0 ;return a 0-based array
				Return StringSplit(StringTrimRight($sFileList, 1), "|", 2)
			Case Else ;return a 1-based array
				Return StringSplit(StringTrimRight($sFileList, 1), "|", 1)
		EndSwitch
	Else
		Return SetError(4, 4, "")
	EndIf

EndFunc   ;==>_FileListToArrayXT


Func _Copy($CopySource, $CopyDestination, $CopySize)
	$Sync = False
	$PassedVerify = False
	$SourceHash = ""
	If Not FileExists($CopyDestination) Then
		$Sync = True
	Else
		Select
			Case $VerifyMethod == "Size"
				If FileGetSize($CopyDestination) <> $CopySize Then $Sync = True
			Case $VerifyMethod == "Date"
				If _CompareFileTimeEx($CopySource, $CopyDestination, 0) == 1 Then $Sync = True
			Case $VerifyMethod == "MD5"
				$SourceHash = _MD5(FileRead($CopySource))
				If _MD5(FileRead($CopyDestination)) <> $SourceHash Then $Sync = True
		EndSelect
	EndIf

	If $Sync == True Then;					copy
		$CopyTheFile = _LargeFileCopy($CopySource, $Destination, $CopySize)
		If $CopyTheFile <> 1 Then
			FileSetAttrib($CopySource, "-AHRS")
			$CopyTheFile = _LargeFileCopy($CopySource, $Destination, $CopySize)

			$WhatError = @error
		EndIf
		If $CopyTheFile == 1 Then;			verify
			If $PreserveDates == True Then _PreserveDate($CopySource, $CopyDestination)

			Select
				Case $VerifyMethod == "Exist"
					If FileExists($CopyDestination) Then $PassedVerify = True
				Case $VerifyMethod == "Size"
					If FileGetSize($CopyDestination) == $CopySize Then $PassedVerify = True
				Case $VerifyMethod == "Date"
					If _CompareFileTimeEx($CopySource, $CopyDestination, 0) <> 1 Then $PassedVerify = True
				Case $VerifyMethod == "MD5"
					If $SourceHash == "" Then $SourceHash = _MD5(FileRead($CopySource))
					If _MD5(FileRead($CopyDestination)) == $SourceHash Then $PassedVerify = True
			EndSelect

			If $PassedVerify == True Then
				$SyncedFiles += 1
			Else
				_Error($CopySource, $CopyDestination, 6)
			EndIf
		Else
			_Error($CopySource, $CopyDestination, $WhatError)
		EndIf
	Else
		$SkippedFiles += 1
		$TotalSize -= $CopySize
		$TotalTally += $CopySize
	EndIf

	If $DeleteAfterSync == True Then
		If $PassedVerify == True Or $Sync == False Then
			FileDelete($CopySource)
		EndIf
	EndIf
	$FileCount -= 1
EndFunc   ;==>_Copy


Func _LargeFileCopy($sSrc, $sDest, $CopySize)
	FileDelete($sDest) ;just to make sure that there is a fresh start on a file found to need syncing
	$FileCopiedSoFar = 0

	; open file for reading, fail if it doesn't exist or directory
	Local $hSrc = _LFC_CreateFile($sSrc, $GENERIC_READ, $File_SHARE_READ, $OPEN_EXISTING, 0)
	If Not $hSrc Then Return SetError(1, 0, 0)

	; check destination
	_LFC_CheckDestination($sSrc, $sDest)
	If @error Then
		_WinAPI_CloseHandle($hSrc)
		$TotalSize -= $CopySize
		Return SetError(2, 0, 0)
	EndIf

	; create new file for writing, overwrite
	Local $hDest = _LFC_CreateFile($sDest, $GENERIC_WRITE, 0, $CREATE_ALWAYS, 0)
	If Not $hDest Then
		_WinAPI_CloseHandle($hSrc)
		$TotalSize -= $CopySize
		Return SetError(3, 0, 0)
	EndIf

	; check for 0 byte source file
	Local $iSize = _WinAPI_GetFileSizeEx($hSrc)
	If $iSize = 0 Then
		; done, close handles and return success
		_WinAPI_CloseHandle($hDest)
		_WinAPI_CloseHandle($hSrc)
		Return SetError(0, 0, 1)
	EndIf

	; perform copy
	Local $iRead, $iWritten, $iTotal = 0, $iReadError = 0, $iWriteError = 0
	Local $hBuffer = DllStructCreate("byte[" & $iToRead & "]")
	Local $pBuffer = DllStructGetPtr($hBuffer)
	Local $mSrc = 0

	Do
		If Not _WinAPI_ReadFile($hSrc, $pBuffer, $iToRead, $iRead) Then
			$iReadError = 1
			ExitLoop
		EndIf
		If $iRead = 0 Then ExitLoop ; end of file, edge case if file is an exact multiple of the buffer size
		If Not _WinAPI_WriteFile($hDest, $pBuffer, $iRead, $iWritten) Or ($iRead <> $iWritten) Then
			$iWriteError = 1
			ExitLoop
		EndIf
		$FileCopiedSoFar += $iRead
		$TotalTally += $iRead
		$TotalSize -= $iRead
	Until $iRead < $iToRead
	_WinAPI_CloseHandle($hDest)
	_WinAPI_CloseHandle($hSrc)

	If $iReadError Then
		Return SetError(4, 0, 0)
	ElseIf $iWriteError Then
		Return SetError(5, 0, 0)
	Else
		Return SetError(0, 0, 1)
	EndIf
EndFunc   ;==>_LargeFileCopy

#region INTERNAL FUNCTIONS
Func _LFC_CheckDestination($sSrc, ByRef $sDest)
	If (StringRight($sDest, 1) = "\") Or StringInStr(FileGetAttrib($sDest), "D") Then
		; assume directory
		If $sSrc = "" Then
			; raw copy, must provide a file name
			Return SetError(2)
		Else
			; create it
			DirCreate($sDest)
			; use source file name
			If StringRight($sDest, 1) <> "\" Then $sDest &= "\" ; add trailing \
			$sDest &= StringRegExpReplace($sSrc, ".*\\", "")
		EndIf
	Else
		; assume file
		; if destination file exists, check overwrite flag
		If FileExists($sDest) Then Return SetError(1)
		; create destination parent directory
		DirCreate(StringRegExpReplace($sDest, "^(.*)\\.*?$", "${1}"))
	EndIf
EndFunc   ;==>_LFC_CheckDestination
Func _LFC_CreateFile($sPath, $iAccess, $iShareMode, $iCreation, $iFlags)
	; open the file with existing HIDDEN or SYSTEM attributes to avoid failure when using CREATE_ALWAYS
	If $iCreation = $CREATE_ALWAYS Then
		Local $sAttrib = FileGetAttrib($sPath)
		If StringInStr($sAttrib, "H") Then $iFlags = BitOR($iFlags, $File_ATTRIBUTE_HIDDEN)
		If StringInStr($sAttrib, "S") Then $iFlags = BitOR($iFlags, $File_ATTRIBUTE_SYSTEM)
	EndIf
	Local $hFile = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sPath, "dword", $iAccess, "dword", $iShareMode, "ptr", 0, _
			"dword", $iCreation, "dword", $iFlags, "ptr", 0)
	If @error Or ($hFile[0] = Ptr(-1)) Then Return SetError(1, 0, 0)
	Return $hFile[0]
EndFunc   ;==>_LFC_CreateFile
#endregion INTERNAL FUNCTIONS


Func _Error($CopySource, $CopyDestination, $WhatError)
	If $WhatError == 1 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Failed to open source file, or source was a directory: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	If $WhatError == 2 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Destination file exists and overwrite flag not set: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	If $WhatError == 3 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Failed to create destination file: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	If $WhatError == 4 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Read error during copy: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	If $WhatError == 5 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Write error during copy: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	If $WhatError == 6 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Verify failed: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	If StringLen($CopySource) > 255 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Source file name exceeded 255 characters: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	If StringLen($CopyDestination) > 255 Then $ErrorMessage = "**FAIL** " & Chr(34) & "Source file name exceeded 255 characters: " & Chr(34) & $CopySource & Chr(34) & " -> " & Chr(34) & $CopyDestination & Chr(34)
	_ArrayAdd($Failed, $ErrorMessage)
EndFunc   ;==>_Error


Func _EmptyDirKill($Target)
	If StringRight($Target, 1) == "\" Then $Target = StringTrimRight($Target, 1)
	$BaseSearch = FileFindFirstFile($Target & "\*.*")
	While @error <> 1
		$BaseFile = FileFindNextFile($BaseSearch)
		; skip these
		If $BaseFile == "." Or $BaseFile == ".." Or $BaseFile == "" Then
			ContinueLoop
		EndIf
		; if it's a non-empty dir then call this function again
		$Dir = $Target & "\" & $BaseFile
		If StringInStr(FileGetAttrib($Dir), "D") > 0 Then
			$Count = DirGetSize($Dir, 1)
			If $Count[1] == 0 Then
				DirRemove($Dir, 1)
			Else
				_EmptyDirKill($Dir)
			EndIf
		EndIf
	WEnd
	FileClose($BaseSearch)
EndFunc   ;==>_EmptyDirKill


Func _CompareFileTimeEx($hSource, $hDestination, $iMethod)
	;Parameters ....:		$hSource -		Full path to the first file
	;						$hDestination -	Full path to the second file
	;						$iMethod -		0   The date and time the file was modified
	;										1   The date and time the file was created
	;										2   The date and time the file was accessed
	;Return values .:						-1  The Source file time is earlier than the Destination file time
	;										0   The Source file time is equal to the Destination file time
	;										1   The Source file time is later than the Destination file time
	;Author ........:		Ian Maxwell (llewxam @ AutoIt forum)
	$aSource = FileGetTime($hSource, $iMethod, 0)
	$aDestination = FileGetTime($hDestination, $iMethod, 0)
	For $a = 0 To 5
		If $aSource[$a] <> $aDestination[$a] Then
			If $aSource[$a] < $aDestination[$a] Then
				Return -1
			Else
				Return 1
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>_CompareFileTimeEx


Func _PreserveDate($hSource, $hDestination)
	;Author ........:		Ian Maxwell (llewxam @ AutoIt forum)
	$hAttrib = FileGetAttrib($hSource)
	$hModifyTime = FileGetTime($hSource, 0, 1)
	$hCreateTime = FileGetTime($hSource, 1, 1)
	$hAccessTime = FileGetTime($hSource, 2, 1)
	FileSetTime($hDestination, $hModifyTime, 0)
	FileSetTime($hDestination, $hCreateTime, 1)
	FileSetTime($hDestination, $hAccessTime, 2)
EndFunc   ;==>_PreserveDate


Func _SpeedCalc()
	If $MarqueeScroll == True Then
		GUICtrlSetData($ShowFileSize, _ByteSuffix($TotalSize))
		If $FileCount > 1 Then
			GUICtrlSetData($ShowFileCount, _StringAddThousandsSep($FileCount) & " Files")
		Else
			GUICtrlSetData($ShowFileCount, _StringAddThousandsSep($FileCount) & " File")
		EndIf
		GUICtrlSetData($SourceInput, "Enumerating files, please wait")
		GUICtrlSetData($ScanPathShow, StringTrimRight($ScanningPath, 1))
	EndIf

	If $Started == True Then
;~      check for quit
		If BitAND(GUICtrlRead($Quit), $GUI_CHECKED) Then
			AdlibUnRegister("_SpeedCalc")
			$YesOrNo = MsgBox(4, "Quit?", "Quit?")
			If $YesOrNo = 6 Then
				FileDelete($CopyDestination)
				Exit
			Else
				AdlibRegister("_SpeedCalc")
				GUICtrlSetState($Quit, $GUI_UNCHECKED)
			EndIf
		EndIf

		$TimeLastHereDiff = TimerDiff($TimeLastHere)
		$Speed = ($TotalTally - $OldSpeedCalcTally) * $TimeLastHereDiff / 1000 * 4
		$OldSpeedCalcTally = $TotalTally
		If GUICtrlRead($FileName) <> $CopySource Then GUICtrlSetData($FileName, $CopySource)
		$ShowCopySize = "(" & _ByteSuffix($CopySize - ($FileCopiedSoFar)) & ")"
		If GUICtrlRead($FileSize) <> $ShowCopySize And $CopySize - $FileCopiedSoFar > 0 Then GUICtrlSetData($FileSize, $ShowCopySize)
		_ProgressSet($FileProg, ($FileCopiedSoFar / $CopySize) * 100)

		If $FileCount > 1 Then
			$NewFileCountMessage = _StringAddThousandsSep($FileCount) & " Files"
			If GUICtrlRead($ShowFileCount) <> $NewFileCountMessage Then GUICtrlSetData($ShowFileCount, $NewFileCountMessage)
		Else
			GUICtrlSetData($ShowFileCount, "1 File")
		EndIf
		$TotalSizeMessage = _ByteSuffix($TotalSize)
		If GUICtrlRead($ShowFileSize) <> $TotalSizeMessage Then GUICtrlSetData($ShowFileSize, $TotalSizeMessage)
		$SyncedFilesMessage = _StringAddThousandsSep($SyncedFiles) & " Synced"
		If GUICtrlRead($ShowSynced) <> $SyncedFilesMessage Then GUICtrlSetData($ShowSynced, $SyncedFilesMessage)
		$SkippedFilesMessage = _StringAddThousandsSep($SkippedFiles) & " Skipped"
		If GUICtrlRead($ShowSkipped) <> $SkippedFilesMessage Then GUICtrlSetData($ShowSkipped, $SkippedFilesMessage)
		$FailedFilesMessage = _StringAddThousandsSep(UBound($Failed) - 1) & " Failed"
		If GUICtrlRead($ShowFailed) <> $FailedFilesMessage Then GUICtrlSetData($ShowFailed, $FailedFilesMessage)
		$SpeedMessage = _ByteSuffix($Speed) & "/s"
		If GUICtrlRead($ShowSpeed) <> $SpeedMessage Then GUICtrlSetData($ShowSpeed, $SpeedMessage)

		$ElapsedSeconds = Int(TimerDiff($Time) / 1000)
		$ElapsedMinutes = 0
		$ElapsedHours = 0
		Do
			If $ElapsedSeconds >= 60 Then
				$ElapsedSeconds -= 60
				$ElapsedMinutes += 1
			EndIf
		Until $ElapsedSeconds < 60
		Do
			If $ElapsedMinutes >= 60 Then
				$ElapsedMinutes -= 60
				$ElapsedHours += 1
			EndIf
		Until $ElapsedMinutes < 60

		$NewTime = "Elapsed Time: " & StringFormat('%.2i', $ElapsedHours) & ":" & StringFormat('%.2i', $ElapsedMinutes) & ":" & StringFormat('%.2i', $ElapsedSeconds)
		If GUICtrlRead($ShowElapsedTime) <> $NewTime Then GUICtrlSetData($ShowElapsedTime, $NewTime)

		$TimeLastHere = TimerInit()

		_Title()
	EndIf
EndFunc   ;==>_SpeedCalc


Func _ByteSuffix($Bytes)
	Local $x, $BytesSuffix[6] = [" B", " KB", " MB", " GB", " TB", " PB"]
	While $Bytes > 1023
		$x += 1
		$Bytes /= 1024
	WEnd
	Return StringFormat('%.2f', $Bytes) & $BytesSuffix[$x]
EndFunc   ;==>_ByteSuffix


Func _Title()
	$Percent = ($FinalSize - ($FinalSize - $TotalTally)) / $FinalSize * 100
	_ProgressSet($TotalProg, $Percent)
	$OldTitle = $NewTitle
	$NewTitle = StringFormat('%.4f', $Percent) & "%" & " - " & $TitleText
	If $OldTitle <> $NewTitle Then WinSetTitle($OldTitle, "", $NewTitle)
EndFunc   ;==>_Title


Func _MarqueeScroll()
	$MarqueeProgress += 5
	If $MarqueeProgress > 100 Then $MarqueeProgress = 0
	GUICtrlSetData($MarqueeBanner, $MarqueeProgress)
EndFunc   ;==>_MarqueeScroll


Func _StringAddThousandsSep($sText)
	If Not StringIsInt($sText) And Not StringIsFloat($sText) Then Return 0
	Local $aSplit = StringSplit($sText, "-" & $sDecimal)
	Local $iInt = 1, $iMod
	If Not $aSplit[1] Then
		$aSplit[1] = "-"
		$iInt = 2
	EndIf
	If $aSplit[0] > $iInt Then
		$aSplit[$aSplit[0]] = "." & $aSplit[$aSplit[0]]
	EndIf
	$iMod = Mod(StringLen($aSplit[$iInt]), 3)
	If Not $iMod Then $iMod = 3
	$aSplit[$iInt] = StringRegExpReplace($aSplit[$iInt], '(?<=\d{' & $iMod & '})(\d{3})', $sThousands & '\1')
	For $i = 2 To $aSplit[0]
		$aSplit[1] &= $aSplit[$i]
	Next
	Return $aSplit[1]
EndFunc   ;==>_StringAddThousandsSep