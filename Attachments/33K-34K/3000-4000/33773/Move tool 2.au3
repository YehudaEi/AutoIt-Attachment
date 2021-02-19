#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 501, 128, 192, 124)
$Menu = GUICtrlCreateMenu("&Menu")
$MoveFile = GUICtrlCreateMenuItem("Move File", $Menu)
$Checkfile = GUICtrlCreateMenuItem("Check files", $Menu)
$Freespace = GUICtrlCreateMenuItem("Free Space", $Menu)
$History = GUICtrlCreateMenuItem("History", $Menu)
$Info = GUICtrlCreateMenuItem("Info", $Menu)
$FromGroup = GUICtrlCreateGroup("From", 0, 0, 500, 50)
$FromInput = GUICtrlCreateInput("", 10, 16, 329, 21)
$BrowseFrom = GUICtrlCreateButton("Browse", 368, 16, 113, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ToGroup = GUICtrlCreateGroup("To", 0, 53, 500, 50)
$ToInput = GUICtrlCreateInput("", 10, 70, 329, 21)
$BrowseTo = GUICtrlCreateButton("Browse", 368, 70, 113, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$From= GUICtrlRead($FromInput)
	$To = GUICtrlRead($ToInput)
	$Msg = GUIGetMsg() 
	$file ="MoveTool History.ini"
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			Exit
		case $FreeSpace
			_FreeSpace ()
		case $info
			_Info ()
		case $browsefrom
			_ReadDialogFrom ()
		case $browseto
			_ReadDialogTo ()
		case $MoveFile
			$Move = FileMove($From,$To)
			if $Move = 1 Then
				msgbox(0,"Succesfull","File was moved")
			Else
				msgbox(0,"Error","Fail to move file" & @crlf & "Please check files")
			EndIf
			_history ()
		Case $CheckFile
			_Check ()
		Case $History
			_OpenHistory ()
	EndSwitch
WEnd

Func _FreeSpace ()
	$freeD = floor(DriveSpaceFree("d:\") / 1000)
	$totalD = floor(DriveSpacetotal("d:\") / 1000)
	$freeC = floor(DriveSpaceFree("c:\") / 1000)
	$totalC = floor(DriveSpacetotal("c:\") / 1000)
	$freeE = floor(DriveSpaceFree("e:\") / 1000)
	$totalE = floor(DriveSpacetotal("e:\") / 1000)
	MsgBox(0,"",$freeD & " gb from " & $totalD& " gb in local disk D" & @crlf & $freeC & " gb from " & $totalC& " gb in local disk C" & @crlf & $freeE & " gb from " & $totalE & " gb in local disk E" )
EndFunc ;_FreeSpace

Func _Info ()
	msgbox (0,"Info Box","This too move your file to a secected folder" & @crlf & "Browse buttos help you to select file to move and destionation , first box is for file to move and secound for destination of file" & @crlf & "Checkfile check if file path is right" & @crlf & "Move file move your file to selected folder" & @crlf & "Free space show you free space from your locals disk" & @crlf & "History show you what you moved")
EndFunc ;_info

Func _Check ()
	if FileExists($From) and FileExists($To) Then
		MsgBox(0,"Files exist","File exist")
	EndIf
EndFunc ;_Check

Func _history ()
global $file = "MoveTool History.ini"
global $asection[100]

For $I = 0 To 99
    $asection[$I]= "section" & $I+1
Next 

For $i = 0 To 99
	$read = IniReadSection($file,$asection[$I])
	if @error then 
		iniwrite ($file,$asection[$I],"File",  $from )
		iniwrite ($file,$asection[$I],"File destination" ,  $to )
		ExitLoop
	EndIf
Next
EndFunc ;_History

Func _OpenHistory ()
Run("MoveTool History.ini")
if @error Then
	msgbox (0," ","File dosen't exist")
EndIf
EndFunc ;_OpenHistory

func _ReadDialogFrom ()
	$from = FileOpenDialog("123", @DesktopDir, "all(*.*)")
	$FromInput = GUICtrlCreateInput($from, 10, 16, 329, 21)
EndFunc ;_ReadDialogFrom

func _ReadDialogto ()
	$to = FileOpenDialog("123", @DesktopDir, "all(*.*)",2)
	$toInput = GUICtrlCreateInput($to, 10, 70, 329, 21)
EndFunc ;_ReadDialogto
