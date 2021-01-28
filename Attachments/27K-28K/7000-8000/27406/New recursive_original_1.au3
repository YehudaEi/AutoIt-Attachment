#cs

Moves files and directories to new location

This requires two folders on c: drive, one called loop and the other loop3
The script will move any directories and files in "loop" over to "loop3"
There is a GUI that will show the progress

The 2nd level directories under "loop" won't be deleted as they are completed
but rather after everything is completed. I would prefer them to be deleted
as they are finished

#ce


;Recursive File Lister

Dim $FolderName = "C:\loop"
Dim $FileCount = 0

AutoItSetOption("TrayIconDebug",1)
AutoItSetOption("WinDetectHiddenText","1")
AutoItSetOption("WinTitleMatchMode","-1")
AutoItSetOption("GUIOnEventMode","1")


;If Script is running, close Script then rename
If WinExists("$AutoScriptName") then WinClose("$AutoScriptName")
AutoItWinSetTitle("$AutoScriptName")


GUICreate("Script Monitor", 400, 200)
GUICtrlCreateLabel("Monitoring the script.", 30, 10)
$OK = GUICtrlCreateButton("OK", 70, 50, 60)
GUICtrlSetOnEvent(-1, "OKPressed")
GUISetState(@SW_SHOW)
$ReportBox = GUICtrlCreateEdit ( "Ready" & @CRLF, 176, 32, 200, 150)
		$SearchCount = 0

while 1 = 1
ScanFolder($FolderName)
		$SearchCount = $SearchCount + 1
		GUICtrlSetData ( $ReportBox,@CRLF & "Count > " & $SearchCount & @CRLF,"input")
	sleep(20000)
WEnd


Func ScanFolder($SourceFolder)
	Local $Search = 0
	Local $File
	Local $FileAttributes
	Local $FullFilePath


	$Search = FileFindFirstFile($SourceFolder & "\*")
		GUICtrlSetData ( $ReportBox,@CRLF & "Search > " & $Search & " " & $SourceFolder & @CRLF,"input")


	While 1
		If $Search = -1 Then
			GUICtrlSetData ( $ReportBox, "$Search = -1"  &  @CRLF,"input")
			ExitLoop
		EndIf

		$File = FileFindNextFile($Search)

		If @error Then
			GUICtrlSetData ( $ReportBox, "Error" &  @CRLF ,"input")
			 ExitLoop
		EndIf

		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)

		If StringInStr($FileAttributes,"D") Then
			GUICtrlSetData ( $ReportBox, @CRLF & "D " & @CRLF & $FullFilePath & "$Search = " & $Search &  @CRLF ,"input")
			$aSize = DirGetSize($FullFilePath)
			If $aSize = 0 Then
				GUICtrlSetData ( $ReportBox, @CRLF & "D " & $aSize & @CRLF & "Root DirRemove: " &  $FullFilePath &  @CRLF ,"input")
				MsgBox(0,"","Ready to remove directories")
				sleep(1000)
				;$aDirRemove = DirRemove($FullFilePath,1)
				;FileClose($Search)
				ExitLoop
			EndIf
			ScanFolder($FullFilePath)
Else
	GUICtrlSetData ( $ReportBox,"Delete " & $FullFilePath & @CRLF ,"input")
		sleep(1000)
	FileMove($FullFilePath,"c:\loop3\" & StringTrimLeft($SourceFolder,3) & "\",9)

	$aSize = DirGetSize($SourceFolder)
	If $aSize = 0 Then
		GUICtrlSetData ( $ReportBox, @CRLF & "D " & $aSize & @CRLF & "DirRemove: " &  $SourceFolder &  @CRLF ,"input")
		;MsgBox(0,"","Ready to remove directory " &$SourceFolder )
		sleep(500)
		$aDirRemove = DirRemove($SourceFolder,1)

		$FileCount += 1
		ExitLoop
	EndIf
	$FileCount += 1
EndIf

	GUICtrlSetData ( $ReportBox, "Ready to WEnd"  &  @CRLF,"input")

	WEnd

	GUICtrlSetData ( $ReportBox, "Ready to FileClose"  &  @CRLF,"input")
	FileClose($Search)
	GUICtrlSetData ( $ReportBox,@CRLF &  "Seach Again >" & $FolderName& @CRLF ,"input")

EndFunc


Func OKPressed()
	MsgBox(0,"","You canceled")
	Exit
EndFunc
