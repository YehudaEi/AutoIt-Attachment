#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Folder Log", 635, 456, 195, 117)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
$Group1 = GUICtrlCreateGroup("Files", 24, 24, 529, 113)
$Label1 = GUICtrlCreateLabel("Folder to Scan", 32, 48, 73, 17)
$Input1 = GUICtrlCreateInput("", 120, 48, 337, 21);set value later
$Button1 = GUICtrlCreateButton("Browse", 464, 48, 81, 25, 0)
GUICtrlSetOnEvent($Button1, "BrowseScanLocation")
$Label2 = GUICtrlCreateLabel("Output File", 32, 80, 55, 17)
$Input2 = GUICtrlCreateInput("", 120, 80, 337, 21);set value later
$Button2 = GUICtrlCreateButton("Browse", 464, 80, 81, 25, 0)
GUICtrlSetOnEvent($Button2, "BrowseSaveLocation")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button3 = GUICtrlCreateButton("GO!", 24, 152, 89, 73, 0)
GUICtrlSetOnEvent($Button3, "GoHelper")
$Input3 = GUICtrlCreateInput("Progress", 32, 288, 521, 21)
$Button4 = GUICtrlCreateButton("Abort!", 120, 152, 89, 73, 0)
GUICtrlSetOnEvent($Button4, "Terminate")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

HotKeySet("{ESC}", "Terminate")

$terminate = False
$run = False
$fileCount = 0

;If FileExists("FolderLogGuiSettings.ini") Then
	GUICtrlSetData ($Input1, IniRead("FolderLogGuiSettings.ini", "MRU", "Input", @HomeDrive))
	GUICtrlSetData ($Input2, IniRead("FolderLogGuiSettings.ini", "MRU", "Output", @DesktopDir & "\files.log"))

If ($CmdLine[0] > 0) Then
	GUICtrlSetData($Input1, $CmdLine[1])
EndIf

While 1
	Sleep(100)
	If $run Then Go()
WEnd

Func Close()
	IniWrite("FolderLogGuiSettings.ini", "MRU", "Input", GUICtrlRead($Input1))
	IniWrite("FolderLogGuiSettings.ini", "MRU", "Output", GUICtrlRead($Input2))
	FileSetAttrib("FolderLogGuiSettings.ini", "+H")
	Exit
EndFunc

Func BrowseScanLocation()
	GUICtrlSetData($Input1, FileSelectFolder("Choose a folder to scan.", "", 0, "c:\"))
EndFunc

Func BrowseSaveLocation()
	GUICtrlSetData($Input2, FileSaveDialog("Choose where to save the log", @DesktopDir & "\", "Log (*.log;*.txt)", 16, "files.log"))
EndFunc

Func GoHelper()
	$run = True
EndFunc

Func Go()
	$terminate = False
	$run = False
	$fileCount = 0
	
	$searchLocation = GUICtrlRead($Input1)
	$saveLocation = GUICtrlRead($Input2)
	
	If StringRight($searchLocation, 1) = "\" Then $searchLocation = StringTrimRight($searchLocation, 1)
	
	$searchHandle = FileFindFirstFile($searchLocation & "\*.*") 
	If ($searchHandle == -1) Then
		MsgBox(0, "Error", "The folder could not be opened.")
		Return
	EndIf
	; Check if the folder was empty
	If (@error == 1) Then
		MsgBox(0, "Error", "The folder is empty")
		Return
	EndIf
	
	If FileExists($saveLocation) Then
		If MsgBox(52,"Save As", $saveLocation & " already exists. Do you want to replace it?") = 7 Then Return
	EndIf
	
	$answer = search($searchHandle, $searchLocation)
	If Not $answer Then	Return
	
	FileClose($searchHandle)
	
	$saveFile = FileOpen($saveLocation, 2)
	If ($saveFile == -1) Then
		MsgBox(0, "Error", "Could not save file.")
		Return
	EndIf
	$answer = "You have " & $fileCount & " files and folders in " & $searchLocation & @CRLF & @CRLF & $answer
	FileWriteLine($saveFile, $answer)
	FileClose($saveFile)
	GUICtrlSetData($Input3, "Completed!")
EndFunc

Func Terminate()
	$terminate = True
EndFunc

Func search($searchHandle, $searchLocation)
$toReturn = ""
While (True)
	If $terminate Then
		$toReturn = 0
		GUICtrlSetData($Input3, "Aborted!")
		ExitLoop
	EndIf
	$file = FileFindNextFile($searchHandle) 
	If @error Then
		ExitLoop
	EndIf
	
	$toReturn = $toReturn & $searchLocation & "\" & $file & @CRLF
	$fileCount += 1
	If mod($fileCount, 10) = 0 Then ;only update the display every 10 files; helps speed
		GUICtrlSetData($Input3, $searchLocation & "\" & $file)
	EndIf
	
	$attrib = FileGetAttrib($searchLocation & "\" & $file)
	If StringInStr($attrib, "D") Then
		$search2 = FileFindFirstFile($searchLocation & "\" & $file & "\*.*")
		$toReturn = $toReturn & search($search2, $searchLocation & "\" & $file)
	EndIf
	
WEnd

return $toReturn
EndFunc