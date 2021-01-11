; Copy a number of files showing progress bar and keeping user advised of progress
; Stephan - 06/02/2006

Opt("MustDeclareVars", 1)     ; 0=no, 1=require pre-declare

#include <guiconstants.au3>

Const $WIDTH = 500
Const $HEIGHT = 120
Const $PROG_HEIGHT = 30
Const $CTRL_BORDER = 10
Const $MESS1 = "Copying file "
Const $MESS2 = " of "

; =========================================================================================
; CHANGE THIS LINE TO WHAT YOU WANT
;
; Parameters are <Title for Window>, <Source Directory>, <Destination Directory>
; You may want to do some error checking (see returns below)

MsgBox(0, "My file copy", " Copied " & MyFileCopy("Copying My Music", "D:\DC++\Ready\Kivotos", "D:\DC++\Ready\try me\"))
Exit

; =========================================================================================
; MyFileCopy
; 
; Copy all files from one directory while providing progress info.
; Destination directory is created if it doesn't exist
; Returns number of files copied (which could be 0).
; Returns -1 if source directory doesn't exist
; Returns -2 if can't create destination directory

Func MyFileCopy($WinTitle, $SourceDir, $DestDir)
    
    Local $NumFiles, $cnt, $Message, $OverallProg_Bar, $FileProg_Bar
    Local $DirInfo[3], $FileBytesDoneSoFar = 0, $TotalBytesDoneSoFar = 0
    Local $FileSearchHandle, $FileName, $test1, $test2
	Local $Percent, $Bytes, $TypeCommand
    
	; Create GUI
    GUICreate($WinTitle, $WIDTH, $HEIGHT, -1, -1, $WS_CAPTION, BitOR($WS_EX_TOPMOST, $WS_EX_DLGMODALFRAME))
    $Message = GUICtrlCreateLabel("Initialising for file copy...", $CTRL_BORDER, $CTRL_BORDER, $WIDTH - (2 * $CTRL_BORDER), 40, $SS_CENTER)
    $FileProg_Bar = GUICtrlCreateProgress($CTRL_BORDER, $HEIGHT - (2 * $PROG_HEIGHT)-(2 * $CTRL_BORDER), $WIDTH - (2 * $CTRL_BORDER), $PROG_HEIGHT)
	$OverallProg_Bar = GUICtrlCreateProgress($CTRL_BORDER, $HEIGHT - $PROG_HEIGHT - $CTRL_BORDER, $WIDTH - (2 * $CTRL_BORDER), $PROG_HEIGHT)
    GUICtrlSetFont($Message, 12)
    GUISetState(@SW_SHOW)
    
	; Check if destination directory exists
	If FileExists($DestDir) = 0 Then
		GUICtrlSetData($Message, "Creating destination directory: " & $DestDir)
		If DirCreate($DestDir) = 0 Then							; Directory doesn't exist so create it
			GUICtrlSetColor($Message, 0xff0000)					; Make the error message red
			GUICtrlSetData($Message, "ERROR: Could not create destination directory: " & $DestDir)	; Error message
			Sleep(5000)
			Return(-2)											; Couldn't create directory so return -2
		EndIf
	EndIf
	
	; Find out how many files we have to copy
	$DirInfo = DirGetSize($SourceDir, 1)                   		; 1 means use extended mode so get extra information
	$FileSearchHandle = FileFindFirstFile($SourceDir & "\*.*")	; Set up search handle to pick up files one by one

    
	; Copy files, advance progress bar and update message
	If $DirInfo == -1 Then
        GUIDelete()
        Return(-1)
	Else
		For $cnt = 1 To $DirInfo[1]
				$FileName = FileFindNextFile($FileSearchHandle)															; Get the next file to copy
				GUICtrlSetData($Message, $MESS1 & String($cnt) & $MESS2 & String($DirInfo[1]) & " (" & $FileName & ")")	; Update message about which file is being copied
				$TypeCommand = 'type "' & $SourceDir & '\' & $FileName & '" > "' & $DestDir & '\' & $FileName & '"'		; Type command for file to be streamed to destination directory
				Run(@ComSpec & ' /c ' & $TypeCommand, $DestDir, @SW_HIDE)												; Spawn the process to start streaming the file
				$Bytes = FileGetSize($SourceDir & "\" & $FileName)														; Find how big the file is
            
		; Watch how many bytes have been streamed so far until we have copied everything
			Do
					$FileBytesDoneSoFar = FileGetSize($DestDir & "\" & $FileName)										; Find how many bytes of the file have been streamed so far
					$Percent = ($FileBytesDoneSoFar / $Bytes) * 100														; What is that as a precentage?
					GUICtrlSetData($FileProg_Bar, $Percent)																; Update progress bar for individual file
					GUICtrlSetData($OverallProg_Bar, (100 / $DirInfo[0]) * ($TotalBytesDoneSoFar + $FileBytesDoneSoFar)); Overall progress bar
		Until $Bytes == $FileBytesDoneSoFar																		; Keep going till whole file is copied
				$TotalBytesDoneSoFar = $TotalBytesDoneSoFar + $Bytes													; Baseline for next file (bytes done so far in completed files)
		Next
				FileClose($FileSearchHandle)							; Loose the file search handle
				GUIDelete()												; Loose the window
			Return($DirInfo[1])										; Copied all files correctly so return how many have been copied
		EndIf
EndFunc