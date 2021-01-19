; Script generated by AutoBuilder 0.6 Prototype
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.8.1
	Author:         Tristan Farmer
	
	Script Function:
	ROBOCOPY GUI for transfering files, using advanced options to save bandwidth,
	allow a continuation point in the event of an error, and other options
	available in the GUI
	
#ce ----------------------------------------------------------------------------

#include <GuiConstants.au3>
#include <GuiEdit.au3>

GUICreate("HBOSA File Copy", 470, 610, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$source = ""
$destination = ""
$sub = ""
$del = ""
$excl = ""
$spare = ""
$id = ""

Opt("GUIOnEventMode", 1)

$Group_1 = GUICtrlCreateGroup("Source", 10, 10, 450, 50)
$Group_2 = GUICtrlCreateGroup("Destination", 10, 70, 450, 50)
$inputsource = GUICtrlCreateInput("", 30, 30, 330, 20)
$inputdestination = GUICtrlCreateInput("", 30, 90, 330, 20)
$btnfoldersource = GUICtrlCreateButton("Browse Folder", 370, 30, 80, 20)
$btnfolderdestination = GUICtrlCreateButton("Browse Folder", 370, 90, 80, 20)
$chkcopysub1 = GUICtrlCreateCheckbox("Copy Subdirectories (Excluding Empty)", 20, 140, 200, 20)
$chkcopysub2 = GUICtrlCreateCheckbox("Copy Subdirectories (Including Empty)", 20, 170, 430, 20)
$chkdeloriginal = GUICtrlCreateCheckbox("Delete Original Files", 20, 200, 430, 20)
$chkexclude = GUICtrlCreateCheckbox("Exclude Directores Named", 20, 230, 150, 20)
$inputexclude = GUICtrlCreateInput("", 170, 230, 280, 20)
$chksparebandwidth = GUICtrlCreateCheckbox("Only Use Spare Bandwidth", 20, 260, 430, 20)
$progresslog = GUICtrlCreateEdit("", 20, 310, 430, 230)
$Label_14 = GUICtrlCreateLabel("Progress...", 20, 290, 430, 20)
$Progress = GUICtrlCreateProgress(20, 550, 350, 10)
$lblprogress = GUICtrlCreateLabel("% Complete", 380, 550, 80, 20)
$btnstart = GUICtrlCreateButton("Start", 20, 570, 100, 30)
$btncancel = GUICtrlCreateButton("Cancel", 350, 570, 100, 30)

GUISetState()
GUICtrlSetOnEvent($btnfoldersource, "FolderSearch")
GUICtrlSetOnEvent($btnfolderdestination, "FolderDestination")
GUICtrlSetOnEvent($btncancel, "EndApp")
GUICtrlSetOnEvent($chkcopysub1, "CopySubNotEmpty")
GUICtrlSetOnEvent($chkcopysub2, "CopySubInclEmpty")
GUICtrlSetOnEvent($chkdeloriginal, "DeleteOriginal")
GUICtrlSetOnEvent($chkexclude, "ExcludeFiles")
GUICtrlSetOnEvent($chksparebandwidth, "SpareBandwidth")
GUICtrlSetOnEvent($btnstart, "blah")

While 1
	$msg = GUIGetMsg()
WEnd

Func blah()
	If $destination <> "" Then
		StartApp($source, $destination, $sub, $del, $excl, $spare)
	ElseIf $source = "" Then
		MsgBox(0, "Error", "Please Select a Source Folder")
	Else
		MsgBox(0, "Error", "Please Select a destination Folder")
	EndIf
EndFunc   ;==>blah

Func StartApp($source, $destination, $sub, $del, $excl, $spare)
	$commandline = Chr(34) & $source & Chr(34) & " " & Chr(34) & $destination & Chr(34) & " " & $sub & $del & $excl & $spare & " /NP /TEE"
	$confirm = MsgBox(1, "Please Confirm", "You are about to copy   " & $source & "   to   " & $destination & ".   Is this correct?")
	If $confirm = "1"  Then
		$id = run("robocopy.exe " & $commandline,@scriptdir,@SW_MAXIMIZE,6)
	;	msgbox(0,"",$id)
		While 1
			$prog = stdoutread($id)
			;msgbox(0,"",$prog)
			$update  = guictrlread($progresslog)
			$prog = $update & @crlf & $prog
			GUICtrlSetData($progresslog,$prog)
			if @error then ExitLoop
		WEnd
		While 1
			$prog = StderrRead($id)
			;msgbox(0,"",$prog)
			$update  = guictrlread($progresslog)
			$prog = $update & @crlf & $prog
			GUICtrlSetData($progresslog,$prog)
			if @error then ExitLoop
		WEnd
	EndIf
EndFunc   ;==>StartApp

Func FolderSearch()
	GUICtrlSetData($inputsource, "")
	$source = FileSelectFolder("Select Source Folder", @MyDocumentsDir, 7)
	GUICtrlSetData($inputsource, $source)
EndFunc   ;==>FolderSearch

Func FolderDestination()
	GUICtrlSetData($inputdestination, "")
	$destination = FileSelectFolder("Select Source File / Folder", @MyDocumentsDir, 7)
	GUICtrlSetData($inputdestination, $destination)
EndFunc   ;==>FolderDestination


Func EndApp()
	processclose($id)
	Exit
EndFunc   ;==>EndApp

Func CopySubNotEmpty()
	$subfolder = GUICtrlRead($chkcopysub1, 0)
	If $subfolder = "1"  Then
		$sub = " /s" 
		GUICtrlSetState($chkcopysub2, $gui_unchecked)
	Else
		$sub = ""
	EndIf
EndFunc   ;==>CopySubNotEmpty

Func CopySubInclEmpty()
	$subfolder = GUICtrlRead($chkcopysub2, 0)
	If $subfolder = "1"  Then
		$sub = " /e" 
		GUICtrlSetState($chkcopysub1, $gui_unchecked)
	Else
		$sub = ""
	EndIf
EndFunc   ;==>CopySubInclEmpty

Func DeleteOriginal()
	$delete = GUICtrlRead($chkdeloriginal, 0)
	If $delete = "1"  Then
		$del = " /move" 
	Else
		$del = ""
	EndIf
EndFunc   ;==>DeleteOriginal

Func ExcludeFiles()
	$exclude = GUICtrlRead($chkexclude, 0)
	If $exclude = "1"  Then
		$files = GUICtrlRead($inputexclude, 1)
		$excl = " /XD " & $files
	Else
		$excl = ""
	EndIf
EndFunc   ;==>ExcludeFiles

Func SpareBandwidth()
	$bandwidth = GUICtrlRead($chksparebandwidth, 0)
	If $bandwidth = "1"  Then
		$spare = " /IPG:10" 
	Else
		$spare = ""
	EndIf
EndFunc   ;==>SpareBandwidth