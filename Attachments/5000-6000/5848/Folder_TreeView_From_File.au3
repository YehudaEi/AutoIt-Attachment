; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         exodius
;
; ----------------------------------------------------------------------------


#cs 
This script should be run from inside the directory that you want to propogate.
To that end, you need to change $RootFolder's "Root" to be the directory that you're
working in. This script should enumerate 6-7 folders deep, although it takes awhile
in folders that have a bazillion folders (like Program Files).
#ce
#include <GUIConstants.au3>
#include <file.au3>

RunWait(@ComSpec & " /c " & 'dir /A:D /S > File_Structure.txt', "", @SW_HIDE)

Parser()

ParseAgain()

$splitroot = StringSplit ( @ScriptDir, "\" )
$x = $splitroot[0]

$Form1 = GUICreate("AForm1", 622, 441, 192, 125)
$TreeView = GUICtrlCreateTreeView(56, 40, 489, 321)
$RootFolder = GUICtrlCreateTreeViewItem($splitroot[$x], $TreeView)

PieceTogetherTreeView()

Cleanup()

GUISetState(@SW_SHOW)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit


Func Parser()

FileDelete ( "Parsed.txt" )

$TotalLines = _FileCountLines ( "File_Structure.txt" )
$Line = 1

$FirstLine = 0

Do
	$read = FileReadLine ( "File_Structure.txt", $Line )
	$check = StringInStr ( $read, "Directory of" )
	If $check <> 0 Then
		
		If $FirstLine = 0 Then
			$folderfindsplit = StringSplit ( $read, "\" )
			$x = $folderfindsplit[0]
			$folderfind = $folderfindsplit[$x]
			$wherefolder = StringInStr ( $read, $folderfind )
			$folderlength = StringLen ( $folderfind )
			$wherefolder = $wherefolder + $folderlength + 1
			$extract = StringMid ( $folderfind, $wherefolder, 300 )
			$FirstLine = $FirstLine + 1
		EndIf
		
			$extract = StringMid ( $read, $wherefolder, 300 )

		If $extract <> "" Then
		FileWriteLine ( "Parsed.txt", $extract )
		EndIf
	EndIf
$Line = $Line + 1
Until $Line = $TotalLines + 1

EndFunc

Func ParseAgain()

FileDelete ( "Check.ini" )
FileDelete ( "Output.txt" )

	Dim $value
	
	$Lines = _FileCountLines ( "Parsed.txt" )
	$x = 1
	Do
		$read = FileReadLine ( "Parsed.txt", $x )
		$split = StringSplit ( $read, "\" )
	
		; Primary
			$Primary = $split[1]
				If $Primary = "Critical_Patches" Then
					$Critical_Patches = 1
				Else
					$Critical_Patches = 0
				EndIf
				If $Primary = "System_Tools" Then
					$System_Tools = 1
				Else
					$System_Tools = 0
				EndIf
		    $check = IniRead ( "Check.ini", "Validate", $Primary, "NotFound" )
			If $check = "Yes" Then
				$Primary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Primary, "Yes" )
		
		;Secondary
		If $split[0] = 2 Then
			$Secondary = $split[2]
		    $check = IniRead ( "Check.ini", "Validate", $Secondary, "NotFound" )
			If $check = "Yes" Then
				$Secondary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Secondary, "Yes" )
		;Tertiary
		ElseIf $split[0] = 3 Then
			$Secondary = $split[2]
		    $check = IniRead ( "Check.ini", "Validate", $Secondary, "NotFound" )
			If $check = "Yes" Then
				$Secondary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Secondary, "Yes" )
			$Tertiary = $split[3]
			If $Critical_Patches <> 1 Then
				$check = IniRead ( "Check.ini", "Validate", $Tertiary, "NotFound" )
				If $check = "Yes" Then
					$Tertiary = ""
				EndIf
			EndIf
			IniWrite ( "Check.ini", "Validate", $Tertiary, "Yes" )
		
		;Quaternary
		ElseIf $split[0] = 4 Then
			$Secondary = $split[2]
		    $check = IniRead ( "Check.ini", "Validate", $Secondary, "NotFound" )
			If $check = "Yes" Then
				$Secondary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Secondary, "Yes" )
			$Tertiary = $split[3]
			$check = IniRead ( "Check.ini", "Validate", $Tertiary, "NotFound" )
			If $check = "Yes" Then
				$Tertiary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Tertiary, "Yes" )
			$Quaternary = $split[4]
			If $System_Tools <> 1 Then
				$check = IniRead ( "Check.ini", "Validate", $Quaternary, "NotFound" )
				If $check = "Yes" Then
					$Quaternary = ""
				EndIf
			EndIf
			IniWrite ( "Check.ini", "Validate", $Quaternary, "Yes" )
		
		;Quinary
		ElseIf $split[0] = 5 Then
			$Secondary = $split[2]
		    $check = IniRead ( "Check.ini", "Validate", $Secondary, "NotFound" )
			If $check = "Yes" Then
				$Secondary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Secondary, "Yes" )
			$Tertiary = $split[3]
			$check = IniRead ( "Check.ini", "Validate", $Tertiary, "NotFound" )
			If $check = "Yes" Then
				$Tertiary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Tertiary, "Yes" )
			$Quaternary = $split[4]
		    $check = IniRead ( "Check.ini", "Validate", $Quaternary, "NotFound" )
			If $check = "Yes" Then
				$Quaternary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Quaternary, "Yes" )
			$Quinary = $split[5]
		    $check = IniRead ( "Check.ini", "Validate", $Quinary, "NotFound" )
			If $check = "Yes" Then
				$Quinary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Quinary, "Yes" )
			
		;Senary	
		ElseIf $split[0] = 6 Then
			$Secondary = $split[2]
		    $check = IniRead ( "Check.ini", "Validate", $Secondary, "NotFound" )
			If $check = "Yes" Then
				$Secondary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Secondary, "Yes" )
			$Tertiary = $split[3]
			$check = IniRead ( "Check.ini", "Validate", $Tertiary, "NotFound" )
			If $check = "Yes" Then
				$Tertiary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Tertiary, "Yes" )
			$Quaternary = $split[4]
		    $check = IniRead ( "Check.ini", "Validate", $Quaternary, "NotFound" )
			If $check = "Yes" Then
				$Quaternary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Quaternary, "Yes" )
			$Quinary = $split[5]
		    $check = IniRead ( "Check.ini", "Validate", $Quinary, "NotFound" )
			If $check = "Yes" Then
				$Quinary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Quinary, "Yes" )
			$Senary = $split[6]
		    $check = IniRead ( "Check.ini", "Validate", $Senary, "NotFound" )
			If $check = "Yes" Then
				$Senary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Senary, "Yes" )
			
		;Septenary	
		ElseIf $split[0] = 7 Then
			$Secondary = $split[2]
		    $check = IniRead ( "Check.ini", "Validate", $Secondary, "NotFound" )
			If $check = "Yes" Then
				$Secondary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Secondary, "Yes" )
			$Tertiary = $split[3]
			$check = IniRead ( "Check.ini", "Validate", $Tertiary, "NotFound" )
			If $check = "Yes" Then
				$Tertiary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Tertiary, "Yes" )
			$Quaternary = $split[4]
		    $check = IniRead ( "Check.ini", "Validate", $Quaternary, "NotFound" )
			If $check = "Yes" Then
				$Quaternary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Quaternary, "Yes" )
			$Quinary = $split[5]
		    $check = IniRead ( "Check.ini", "Validate", $Quinary, "NotFound" )
			If $check = "Yes" Then
				$Quinary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Quinary, "Yes" )
			$Senary = $split[6]
		    $check = IniRead ( "Check.ini", "Validate", $Senary, "NotFound" )
			If $check = "Yes" Then
				$Senary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Senary, "Yes" )
			$Septenary = $split[7]
		    $check = IniRead ( "Check.ini", "Validate", $Septenary, "NotFound" )
			If $check = "Yes" Then
				$Septenary = ""
			EndIf
			IniWrite ( "Check.ini", "Validate", $Septenary, "Yes" )
		EndIf
			
		If $split[0] = 1 Then
			FileWriteLine ( "Output.txt", "," & $Primary )
		ElseIf $split[0] = 2 Then
			FileWriteLine ( "Output.txt", ",," & $Secondary)
		ElseIf $split[0] = 3 Then
			FileWriteLine ( "Output.txt",  ",,," & $Tertiary )
		ElseIf $split[0] = 4 Then
			FileWriteLine ( "Output.txt",  ",,,," & $Quaternary)
		ElseIf $split[0] = 5 Then
			FileWriteLine ( "Output.txt",  ",,,,," & $Quinary)
		ElseIf $split[0] = 6 Then
			FileWriteLine ( "Output.txt",  ",,,,,," & $Senary)
		ElseIf $split[0] = 7 Then
			FileWriteLine ( "Output.txt",  ",,,,,,," & $Septenary)			
		EndIf
	
	
				
		$x = $x + 1
		
	Until $x = $Lines
EndFunc

Func PieceTogetherTreeView()
	
$Lines = _FileCountLines ( "Output.txt" )

For $x = 1 To $Lines
	$read = FileReadLine ( "Output.txt", $x )
	$split = StringSplit ( $read, "," )
	
	If StringRight ( $read, 1 ) = "," Then
		ContinueLoop
	EndIf
	
	$NumberOfSplits = $split[0]
	
	If $NumberOfSplits = 2 Then
		$Primary = $split[2]
		$TreeView2 = GUICtrlCreateTreeViewitem($Primary, $RootFolder)
	ElseIf $NumberOfSplits = 3 Then
		$Secondary = $split[3]
		$TreeView3 = GUICtrlCreateTreeViewitem($Secondary, $TreeView2)		
	ElseIf $NumberOfSplits = 4 Then
		$Tertiary = $split[4]
		$TreeView4 = GUICtrlCreateTreeViewitem($Tertiary, $TreeView3)	
	ElseIf $NumberOfSplits = 5 Then
		$Quaternary = $split[5]
		$TreeView5 = GUICtrlCreateTreeViewitem($Quaternary, $TreeView4)	
	ElseIf $NumberOfSplits = 6 Then
		$Quinary = $split[6]
		$TreeView6 = GUICtrlCreateTreeViewitem($Quinary, $TreeView5)	
	ElseIf $NumberOfSplits = 7 Then
		$Senary = $split[7]
		$TreeView7 = GUICtrlCreateTreeViewitem($Senary, $TreeView6)	
	EndIf

Next

EndFunc

Func Cleanup()
	FileDelete ( "Check.ini" )
	FileDelete ( "File_Structure.txt" )
	FileDelete ( "Output.txt" )
	FileDelete ( "Parsed.txt" )
EndFunc
	