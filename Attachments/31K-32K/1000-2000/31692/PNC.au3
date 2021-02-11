;Set Options
Opt("ExpandEnvStrings", 1)
Opt("ExpandVarStrings", 1)

; Set Variables
Dim $user = EnvGet("username"), $source = @ScriptDir & "\Users\%username%", $profile = EnvGet("userprofile"), $allusers = EnvGet("allusersprofile"), $notes = "c:\notes"
Dim $foldlist[6] = ["\all","\data","\docs","\desktop","\favorites","\notes"]

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>

;Create Screenshots Document
If FileExists (@ScriptDir & "\screenshots\%username%.doc") Then
	Else
		FileCopy (@ScriptDir & "\screenshots\blank.doc", @ScriptDir & "\screenshots\%username%.doc")
	EndIf

;Create User's Folder Tree
If FileExists ($source) Then
	Else
		DirCreate ($source)
	EndIf
	
	For $c = 0 To 5 Step 1
		If FileExists ($source & $foldlist[$c]) Then
			Sleep(1)
		Else
			DirCreate ($source & $foldlist[$c])
		EndIf
	Next

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("PNC Refresh Tool", 442, 450, 299, 218)
$PageControl1 = GUICtrlCreateTab(8, 8, 428, 216)
$TabSheet1 = GUICtrlCreateTabItem("Backup")
GUICtrlSetState(-1,$GUI_SHOW)
	$BackFull = GUICtrlCreateButton("Everything", 12, 37, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$BackPrint = GUICtrlCreateButton("Printers", 12, 84, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$BackNotes = GUICtrlCreateButton("Notes Data", 12, 178, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$BackDocs = GUICtrlCreateButton("My Documents", 12, 131, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label2 = GUICtrlCreateLabel("Backs up all files needed for a refresh", 112, 44, 189, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label3 = GUICtrlCreateLabel("Backs up the entire Lotus Notes Data Folder", 112, 185, 216, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label4 = GUICtrlCreateLabel("Backs up Printers ONLY", 112, 91, 167, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label5 = GUICtrlCreateLabel("Backs up the User's 'My Documents Folder", 112, 138, 216, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$TabSheet2 = GUICtrlCreateTabItem("Restore")
	$RestFull = GUICtrlCreateButton("Everything", 12, 37, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$RestPrint = GUICtrlCreateButton("Printers", 12, 84, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$RestNotes = GUICtrlCreateButton("Notes Data", 12, 178, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label5 = GUICtrlCreateLabel("Restores all files needed for a refresh", 112, 44, 188, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label6 = GUICtrlCreateLabel("Restores the entire Lotus Notes Data Folder", 112, 185, 215, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label7 = GUICtrlCreateLabel("Restores Printers ONLY", 112, 91, 167, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$RestDocs = GUICtrlCreateButton("My Documents", 12, 131, 97, 33)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$Label9 = GUICtrlCreateLabel("Restores the User's 'My Documents Folder", 112, 138, 216, 18)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$TabSheet3 = GUICtrlCreateTabItem("Tools")
	$OTIS = GUICtrlCreateButton("OTIS - Schedule", 20, 37, 137, 65)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	$PNCApps = GUICtrlCreateButton("PNC Apps", 180, 37, 137, 65)
	GUICtrlSetFont(-1, 8, 400, 0, "Arial")
	GUICtrlCreateTabItem("")
$Close = GUICtrlCreateButton("Close", 358, 415, 74, 25)
$Label1 = GUICtrlCreateLabel("Current User: " & EnvGet("username"), 175, 12, 300, 12)
$Pic1 = GUICtrlCreatePic("D:\picz\Array.gif", 272, 232, 161, 161)
$Progress1 = GUICtrlCreateProgress(8, 407, 337, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;GUI Event Checking
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $BackFull
			MsgBox (0, "Full Backup", "Full Backup Pressed")
		Case $BackPrint
			MsgBox (0, "Printer Backup", "Printer Backup Pressed")
		Case $BackDocs
			MsgBox (0, "My Documents Backup", "My Documents Backup Pressed")
		Case $BackNotes
			MsgBox (0, "Notes Backup", "Notes Data Backup Pressed")
		Case $RestFull
			MsgBox (0, "Full Restore", "Full Restore Pressed")
		Case $RestPrint
			MsgBox (0, "Printer Restore", "Printer Restore Pressed")
		Case $RestDocs
			MsgBox (0, "My Documents Restore", "My Documents Restore Pressed")
		Case $RestNotes
			MsgBox (0, "Notes Restore", "Notes Data Restore Pressed")
		Case $OTIS
			ShellExecute (@ProgramFilesDir & "\Internet Explorer\iexplore.exe", "https://domino.compucom.com/otis/pnc/otis.nsf")
		Case $PNCApps
			ShellExecute (@ProgramFilesDir & "\Internet Explorer\iexplore.exe", "http://ppnta037.pncbank.com/DTMenuPPNTA037.Htm?")
		Case $Close
			Exit
	EndSwitch
WEnd

;Backup functions
Func BackFull()
	
EndFunc

Func BackPrint()
	If FileExists ($source & "\printers.cab") Then
		FileDelete ($source & "\printers.cab")
		Run ("printmig -b %SRC%\printers.cab", ,@SW_HIDE)
	Else
		Run ("printmig -b %SRC%\printers.cab", ,@SW_HIDE)
	EndIf
EndFunc

Func BackDocs ()
	FileCopy ($profile & "\My Documents", $source & "\docs", 1)
EndFunc

Func BackNotes ()
	FileCopy ($notes & "\data", $source & "\data", 1)
EndFunc

;Restore Functions
Func RestFull ()
EndFunc

Func RestPrint ()
	If FileExists ($source & "\printers.cab") Then
		Run ("printmig -r %SRC%\printers.cab", ,@SW_HIDE)
	Else
		MsgBox (0, "Error", "Printers.cab missing")
	EndIf
EndFunc

Func RestDocs()
	FileCopy ($source & "\docs", $profile & "\My Documents", 1)
EndFunc

Func RestNotes()
	DirMove ($notes & "\data", $notes & "\data.bak"
	FileCopy ($source & "\data", $notes & "\data", 1)
EndFunc