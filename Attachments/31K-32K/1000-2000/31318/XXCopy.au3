
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Override.au3>
#Include <File.au3>
#include <Array.au3>
#Include <Misc.au3>

Opt("MustDeclareVars", 1)


Global $forceoverwritefile = 0
Global $forceoverwritefolder = 0
Global $overaktion = 0
Global $showcopytime = False
Global $displayhelp = False
Global $subfolder = False
Global $source = ""
Global $destination = ""

Global $cmdopts = $CmdLine
Global $sourcetype = ""
Global $DlgReturn
Global $fail = ""

Dim $filelist[1][3]


If ($cmdopts[0] < 2) Then
	displayHelp()
	Exit
EndIf

; Loop through command args for switches
For $i = 1 to ($cmdopts[0])
	Select
	Case StringLower($cmdopts[$i]) = "/y"
		$forceoverwritefile = 2
		$forceoverwritefolder = 2
	Case StringLower($cmdopts[$i]) = "/noerror"
		$noerror = 1
	case StringLower($cmdopts[$i]) = "/k"
		$showcopytime = True
	case StringLower($cmdopts[$i]) = "/s"
		$subfolder = True
case $cmdopts[$i] = "/?"
		$displayhelp = True
	Case Else
		$source = $cmdopts[1]
		$destination = $cmdopts[2]
	EndSelect
Next

; If displayhelp = 1, display help message
If $displayhelp Then
	displayHelp()
	Exit
EndIf

; Must specify both source and destination
If ($source = "" Or $destination = "") Then
	errorMsg ("Sie müssen sowohl Quelle als auch Ziel des Kopiervorgangs angeben.")
	Exit
EndIf

; Check for illegal characters in source
If ( validPath(getDirectory($source)) = 0 Or _
	 validPath(getFilename($source)) = 0 ) Then
	errorMsg ("Quell Dateiname ungültig." & @CRLF & @CRLF & "Dateiname darf folgende Zeichen nicht enthalten: " & @CRLF & $invalidChars)
	Exit
EndIf

; Check for illegal characters in destination
If ( validPath(getDirectory($destination)) = 0 Or _
	 validPath(getFilename($destination)) = 0 ) Then
	errorMsg ("Ziel Dateiname ist ungültig." & @CRLF & @CRLF & "Dateiname darf folgende Zeichen nicht enthalten: " & @CRLF & $invalidChars)
	Exit
EndIf

; Check if source and destination are the same
If (StringUpper($source) = StringUpper($destination)) Then
	errorMsg ("Quelle und Ziel sind identisch.")
	Exit
EndIf

; Convert any relative paths into absolute paths
If StringLen($source) > 2 Then
	$source = _PathFull($source)
EndIf
If StringLen($destination) > 2 Then
	$destination = _PathFull($destination)
EndIf

; Wenn Dateiname *.* oder * oder letztes Zeichen \, alles ab \ abschneiden
If (getFilename($source) = "*.*") or (getFilename($source) = "*") Then
	$source = StringLeft($source, StringInStr($source, '\', 0, -1)-1)
EndIf
If StringRight($source,1) = "\" Then
	$source = StringLeft($source,StringLen($source)-1)
EndIf
If (getFilename($destination) = "*.*") or (getFilename($destination) = "*") Then
	$destination = StringLeft($destination, StringInStr($destination, '\', 0, -1)-1)
EndIf
If StringRight($destination,1) = "\" Then
	$destination = StringLeft($destination,StringLen($destination)-1)
EndIf

; Check that source file exist
If (FileExists($source)) Then
	If (StringInStr(FileGetAttrib($source), "D", 0) = 0) Then
		; if source is a file, (not directory)
		$sourcetype = "file"
	Else
		; if source is a diretory
		$sourcetype = "dir"
		; replace folder ?
		If FileExists($destination) Then
			If $forceoverwritefolder < 2 Then
				$forceoverwritefolder = ReplaceFolder($source,$destination,1)
				If ($forceoverwritefolder = 0) or ($forceoverwritefolder = 3) then Exit
				If $forceoverwritefolder = 1 Then $forceoverwritefolder = 0
			EndIf
		Else
			;DirCreate($destination)
		EndIf
	EndIf
Else
	; if source does not exist
	errorMsg ($source & " existiert nicht.")
	Exit
EndIf


Global $CopyForm,$LFile,$LSource,$LDest,$LAll,$LSpeed,$LTime,$LRemaining
Global $LFileCount,$LAllFileSize,$LFileSize,$LFileByte
Global $PFile,$PAllFiles,$BCancel,$BPause,$nMsg

Global $aktsourcepath = "",$lastaktsourcepath = ""
Global $sourcesize = 0,$lastsourcesize = 0
Global $akttime,$lasttime = 0
Global $copyfiletime			; Timer Copy
Global $progresstimer			; Timer für Berechnungen
Global $statusrefresh = 1300	; calulate time remain, speed, etc. interval
Global $progressrefresh = 1000	; display stats (time est/remain, speed) interval

Global $destinationsize = 0,$lastdestinationsize = 0,$lastdestination = ""
;Global $destsizeupdate = 0,$lastdestsizeupdate = 0
Global $filecount = 0,$files = 0,$lastfiles = 0,$filenumber = 0,$lastfilenumber = 0
Global $destfilesize = 0,$lastdestfilesize = 0
Global $sourcefilesize = 0,$lastsourcefilesize = 0
Global $filename = "",$lastfilename = ""

Global $transferspeed = 0,$lasttransferspeed = 0,$timeremaining = 0,$lasttimeremaining = 0

Global $pause = False, $lastpause = False
Global $pid = 0

;Global $spintimer
;Global $spinrefresh = 170		; display top bar (bytes and spin) interval
Global $bytedecimalplace = 2
Global $Aktion = 0


#Region ### START Koda GUI section ### Form=e:\axa\_filecopyprogress\_neu\copyform.kxf
$CopyForm = GUICreate("Größe wird ermittelt...", 401, 231, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
$LSource = GUICtrlCreateLabel("Von: ",        16, 16, 250, 17)
$LTime = GUICtrlCreateLabel("Zeit: ",        290, 16, 150, 17)
$LDest = GUICtrlCreateLabel("Nach: ",         16, 40, 250, 17)
$LRemaining = GUICtrlCreateLabel("Rest: ",   290, 40, 150, 17)
$LFile = GUICtrlCreateLabel("Datei: ",        16, 64, 250, 17)
$LFileCount = GUICtrlCreateLabel("Anzahl: ", 290, 64, 150, 17)
$LFileSize = GUICtrlCreateLabel("Größe: ",    16, 88, 100, 17)
$LSpeed = GUICtrlCreateLabel("Rate: ",       150, 88, 100, 17)
$LFileByte = GUICtrlCreateLabel("Kopiert: ", 290, 88, 150, 17)

$LAll = GUICtrlCreateLabel("Gesamt:",         16, 140, 43, 17)
$LAllFileSize = GUICtrlCreateLabel("Größe:", 245, 140, 150, 17)
$PFile = GUICtrlCreateProgress(               16, 113, 366, 16)
$PAllFiles = GUICtrlCreateProgress(           16, 164, 366, 16)
$BCancel = GUICtrlCreateButton("Abbrechen",  304, 195, 75, 25, $WS_GROUP)
$BPause = GUICtrlCreateButton("Pause",       200, 195, 75, 25, $WS_GROUP)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; Start the timer(s)
$copyfiletime = TimerInit()

While 1
	Switch $Aktion
		Case 0
			getFileList($source)
		Case 10
			$sourcesize = getSourceSize()
			$Aktion = 20
		Case 100
			CopyFile()
		Case 200
			If $showcopytime Then
				GUICtrlSetState($BPause,$GUI_DISABLE)
				GUICtrlSetData($BCancel,"Ende")
			Else
				Exit
			EndIf
			$Aktion = 210
	EndSwitch

	UpdateDialog()
WEnd



Func UpdateDialog()
	;Dialog Update und Event Abfrage
Local $gMsg,$suffix,$prefix,$suffix1,$prefix1
	$nMsg = GUIGetMsg()
	;Update Timer
	If $Aktion <= 100 Then $akttime = TimerDiff($copyfiletime)
	if $akttime > $lasttime + $statusrefresh Then
		GUICtrlSetData($LTime,"Zeit: " & TimeFormat($akttime))
		$lasttime = $akttime

		;$LRemaining aktualisieren
		If $timeremaining <> $lasttimeremaining Then
			GUICtrlSetData($LRemaining,"Rest: " & TimeFormat($timeremaining))
			$lasttimeremaining = $timeremaining
		EndIf
	EndIf
	;Update Pause
	If $pause <> $lastpause Then
		If $pause Then
			GUICtrlSetData($BPause,"Fortsetzen")
		Else
			GUICtrlSetData($BPause,"Pause")
			ProcessSetPriority($pid,2)
		EndIf
		$lastpause = $pause
	EndIf
	;Wait Pause
	While $pause
		ProcessSetPriority($pid,0)
		$gMsg = GUIGetMsg()
		If $BPause  = $gMsg Then $pause = NOT($pause)
		If $BCancel = $gMsg Then Exit
		sleep(20)
	WEnd

	;$LFileByte aktualisieren
	If $destfilesize <> $lastdestfilesize Then
		getByteSuffix($destfilesize,$prefix,$suffix)
		GUICtrlSetData($LFileByte,"Kopiert: " & StringFormat("% 3.2f",$prefix) & $suffix)
		GUICtrlSetData($PFile, int(($destfilesize / $sourcefilesize) * 100))
		$lastdestfilesize = $destfilesize
	EndIf

	;$LSpeed aktualisieren
	If $transferspeed <> $lasttransferspeed Then
		getByteSuffix($transferspeed,$prefix,$suffix)
		GUICtrlSetData($LSpeed,"Rate: " & StringFormat("% 3.2f",$prefix) & $suffix)
		$lasttransferspeed = $transferspeed
	EndIf

	;$LFileSize aktualisieren
	If $sourcefilesize <> $lastsourcefilesize Then
		getByteSuffix($sourcefilesize,$prefix,$suffix)
		GUICtrlSetData($LFileSize,"Größe: " & StringFormat("% 3.2f",$prefix) & $suffix)
		$lastsourcefilesize = $sourcefilesize
	EndIf

	;LAllFileSize aktualisieren
	If ($sourcesize <> $lastsourcesize) or ($destinationsize <> $lastdestinationsize) Then
		getByteSuffix($sourcesize,$prefix,$suffix)
		getByteSuffix($destinationsize,$prefix1,$suffix1)
		GUICtrlSetData($LAllFileSize,"Größe: " & StringFormat("% 3.2f",$prefix1) & $suffix1 & "/" & StringFormat("% 3.2f",$prefix) & $suffix)
		GUICtrlSetData($PAllFiles, Int(($destinationsize / $sourcesize) * 100))
		$lastsourcesize = $sourcesize
		$lastdestinationsize = $destinationsize
	EndIf

	;LSource aktualisieren
	If $aktsourcepath <> $lastaktsourcepath Then
		GUICtrlSetData($LSource,shortText("Von: " & $aktsourcepath))
		$lastaktsourcepath = $aktsourcepath
	EndIf

	;LFilecount aktualisieren
	If ($filenumber <> $lastfilenumber) or ($files <> $lastfiles) Then
		GUICtrlSetData($LFileCount,shortText("Anzahl: " & $filenumber & "/" & $files))
		$lastfilenumber = $filenumber
		$lastfiles = $files
	EndIf

	;LFile aktualisieren
	If $filename <> $lastfilename Then
		GUICtrlSetData($LFile,shortText("Datei: " & $filename))
		$lastfilename = $filename
	EndIf

	;$LDest aktualisieren
	If $destination <> $lastdestination Then
		GUICtrlSetData($LDest,shortText("Nach: " & $destination))
		$lastdestination = $destination
	EndIf

	Switch $Aktion
		Case 0
			WinSetTitle("Dateiliste wird erstellt...","","Größe wird ermittelt...")
			$Aktion = 10
		Case 20
			WinSetTitle("Größe wird ermittelt...","","Kopiere...")
			$Aktion = 100
	EndSwitch

	Switch $nMsg
		Case $GUI_EVENT_CLOSE,$BCancel
			killproc($pid)
			Exit
		Case $BPause
			$pause = NOT($pause)
	EndSwitch

EndFunc

Func CopyFile()
	;Dateien kopieren
	Local $i,$log,$d,$T="|"
	Local $destsizefix = 0
	Local $runcmd = ""
	Local $procstats
	Local $starttime
	Local $copyrefresh = 50
	Local $BlockedFolder = ""

	$progresstimer = TimerInit()
	$destinationsize = 0
	for $i = 0 To $filecount-1

		If $BlockedFolder <> "" Then
			If $BlockedFolder = StringLeft($filelist[$i][2],StringLen($BlockedFolder)) Then
				If StringInStr($filelist[$i][1],"D") = 0 Then
					$filenumber = $filenumber + 1
					$destsizefix = $destinationsize
					$sourcefilesize = FileGetSize($filelist[$i][0])
					$destfilesize = FileGetSize($filelist[$i][0])
					$destinationsize = $destsizefix + $destfilesize
					$transferspeed = Int($destinationsize / (TimerDiff($progresstimer) / 1000))
					If ($transferspeed > 0) Then
						$timeremaining = (($sourcesize - $destinationsize) / $transferspeed) * 1000
					EndIf
					UpdateDialog()
				EndIf
			Else
				$BlockedFolder = ""
			EndIf
		EndIf

		If $BlockedFolder = "" Then
			If StringInStr($filelist[$i][1],"D") Then
				If FileExists($filelist[$i][2]) Then
					If $forceoverwritefolder < 2 Then
						$forceoverwritefolder = ReplaceFolder($filelist[$i][0],$filelist[$i][2])
						Switch $forceoverwritefolder
							Case 0
								Exit
							Case 1,2
								DirCreate($filelist[$i][2])
								If $forceoverwritefolder = 1 Then $forceoverwritefolder = 0
							Case 3
								$BlockedFolder = $filelist[$i][2]
								$forceoverwritefolder = 0
						EndSwitch
					Else
						DirCreate($filelist[$i][2])
					EndIf
				Else
					DirCreate($filelist[$i][2])
				EndIf
			Else
				If FileExists($filelist[$i][2]) Then
					If $forceoverwritefolder < 2 Then
						$forceoverwritefolder = ReplaceFolder($filelist[$i][0],$filelist[$i][2])
						Switch $forceoverwritefolder
							Case 0
								Exit
							Case 1,2
								DirCreate($filelist[$i][2])
								If $forceoverwritefolder = 1 Then $forceoverwritefolder = 0
							Case 3
								$BlockedFolder = $filelist[$i][2]
								$forceoverwritefolder = 0
						EndSwitch
					Else
						DirCreate($filelist[$i][2])
					EndIf
				Else
					DirCreate($filelist[$i][2])
				EndIf
				If FileExists($filelist[$i][2]) Then
					If $forceoverwritefile < 2 Then
						$forceoverwritefile = ReplaceFile($filelist[$i][0],$filelist[$i][2])
						If $forceoverwritefile = 0 then Exit
					EndIf
				EndIf

				If $forceoverwritefile < 3 Then
					$filename = getFilename($filelist[$i][0])
					$destination = getDrive($filelist[$i][2]) & getDirectory($filelist[$i][2])

					$sourcefilesize = FileGetSize($filelist[$i][0])
					$filenumber = $filenumber + 1
					FileSetAttrib($filelist[$i][0],"-RSHNOT")

					UpdateDialog()

					$runcmd = @ComSpec & " /c copy /y " & chr(34) & $filelist[$i][0] & chr(34) & " " & Chr(34) & $filelist[$i][2] & Chr(34)
					$pid = Run($runcmd, @ScriptDir, @SW_HIDE)
					If ($pid = 0) Then
						errorMsg ("Error running copy command")
						Return 0
					EndIf

					$starttime = TimerInit()
					$destsizefix = $destinationsize
					While (ProcessExists($pid))
						$procstats = ProcessGetStats($pid, 1)
						If (IsArray($procstats) And UBound($procstats) > 4) Then
							$destfilesize = $procstats[4]

							$destinationsize = $destsizefix + $destfilesize
							$transferspeed = Int($destinationsize / (TimerDiff($progresstimer) / 1000))

							If ($transferspeed > 0) Then
								$timeremaining = (($sourcesize - $destinationsize) / $transferspeed) * 1000
							EndIf

							If ($destfilesize > $sourcefilesize) Then
								$destfilesize = $sourcefilesize
							EndIf

							If (Int(timerdiff($starttime)) > $copyrefresh) Then
								UpdateDialog()
								$starttime = TimerInit()
							EndIf
						EndIf
					WEnd

					$destfilesize = FileGetSize($filelist[$i][2])
					$destinationsize = $destsizefix + $destfilesize

					; If destination file doesn't exist, display error
					If (FileExists($filelist[$i][2]) = 0) Then
						errorMsg ("Datei " & $filelist[$i][2] & " konnte nicht erstellt werden.")
						Return 0
					EndIf

					; Compare source file size and destination file size
					If ($sourcefilesize <> $destfilesize) Then
						FileDelete($filelist[$i][2])
						errorMsg ("Ein Fehler ist beim kopieren der Datei " & $filelist[$i][2] & " aufgetreten.")
						Return 0
					EndIf

					$transferspeed = Int($destinationsize / (TimerDiff($progresstimer) / 1000))
					If ($transferspeed > 0) Then
						$timeremaining = (($sourcesize - $destinationsize) / $transferspeed) * 1000
					EndIf

					FileSetAttrib($filelist[$i][0],"+" & $filelist[$i][1])
					FileSetAttrib($filelist[$i][2],"+" & $filelist[$i][1])

					UpdateDialog()
				Else
					$filenumber = $filenumber + 1
					$destsizefix = $destinationsize
					$sourcefilesize = FileGetSize($filelist[$i][0])
					$destfilesize = FileGetSize($filelist[$i][0])
					$destinationsize = $destsizefix + $destfilesize
					$transferspeed = Int($destinationsize / (TimerDiff($progresstimer) / 1000))
					If ($transferspeed > 0) Then
						$timeremaining = (($sourcesize - $destinationsize) / $transferspeed) * 1000
					EndIf
					UpdateDialog()
					$forceoverwritefile = 0
				EndIf
				If $forceoverwritefile = 1 Then $forceoverwritefile = 0
			EndIf
		EndIf
	Next
	$Aktion = 200
EndFunc


Func getFileList($path)
Local $search,$filename,$filepath
	;Dateiliste erstellen
	If $sourcetype = "dir" Then
		$search = FileFindFirstFile($path & "\*.*")
	Else
		$search = FileFindFirstFile($path)
	EndIf

	If $search = -1 Then
		If @error <> 1 Then
			Return
		EndIf
		; Leeres Verzeichnis
	EndIf
	While 1
		$aktsourcepath = $path
		$filename = FileFindNextFile($search)
		If @error Then ExitLoop
		If $sourcetype = "file" Then
			$filepath = StringLeft($path, StringInStr($path, '\', 0, -1)-1) & "\" & $filename
			$filecount = $filecount + 1
			$files = $files + 1
			ReDim $filelist[$filecount][3]
			$filelist[$filecount-1][0] = $filepath
			$filelist[$filecount-1][1] = FileGetAttrib($filepath)
			$filelist[$filecount-1][2] = $destination & "\" & StringRight($filepath,StringLen($filepath)-StringLen(getDrive($source) & getDirectory($source)))
			UpdateDialog()
		Else
			$filepath = $path & "\" & $filename
			If StringInStr(FileGetAttrib($filepath),"D") Then
				If $subfolder Then
					$filecount = $filecount + 1
					ReDim $filelist[$filecount][3]
					$filelist[$filecount-1][0] = $filepath
					$filelist[$filecount-1][1] = FileGetAttrib($filepath)
					$filelist[$filecount-1][2] = $destination & "\" & StringRight($filepath,StringLen($filepath)-StringLen(getDrive($source) & getDirectory($source) & getFilename($source))-1)
					getFileList($filepath)
				EndIf
			Else
				$files = $files + 1
				$filecount = $filecount + 1
				ReDim $filelist[$filecount][3]
				$filelist[$filecount-1][0] = $filepath
				$filelist[$filecount-1][1] = FileGetAttrib($filepath)
				$filelist[$filecount-1][2] = $destination & "\" & StringRight($filepath,StringLen($filepath)-StringLen(getDrive($source) & getDirectory($source) & getFilename($source))-1)
				UpdateDialog()
			EndIf
		EndIf
	WEnd
	FileClose($search)
EndFunc

Func getSourceSize()
	; Get size of source
	Local $i
	If ($sourcetype = "dir") Then
		If $subfolder Then
			$sourcesize = DirGetSize($source)
		Else
			$sourcesize = DirGetSize($source,2)
		EndIf
	EndIf
	If ($sourcetype = "file") Then
		For $i = 0 To $filecount - 1
			If StringInStr($filelist[$i][1],"D") = 0 Then $sourcesize += FileGetSize($filelist[$i][0])
		Next
	EndIf
	If ($sourcesize = -1) Then
		errorMsg ("Größe von " & $source & " konnte nicht ermittelt werden.")
		Exit
	EndIf
	Return $sourcesize
EndFunc

Func displayHelp()
	; displays help message
	; if noerror <> 0, don't display help message

	Local $helpmsg

	If ($noerror = 0) Then
		$helpmsg = "XXCopy.exe [Optionen] Quelle Ziel" & @CRLF  & @CRLF _
					  & "  [Optionen]:" & @CRLF _
					  & "   /noerror = Deaktiviert Fehlermeldungen" & @CRLF _
					  & "   /? = Zeigt diese Hilfe" & @CRLF _
					  & "   /y = Unterdrückt Abfrage zum Überschreiben" & @CRLF _
					  & "   /k = Dialog nach Vorgang nicht schliessen" & @CRLF _
					  & "   /title:<Titel> = Titel des Fensters" & @CRLF _
					  & @CRLF _
					  & "  Quelle = Quelle Datei/Verzeichnis" & @CRLF _
					  & "  Ziel = Ziel Datei/Verzeichnis" & @CRLF & @CRLF
		MsgBox(64, "Hilfe", $helpmsg)
	EndIf
EndFunc

