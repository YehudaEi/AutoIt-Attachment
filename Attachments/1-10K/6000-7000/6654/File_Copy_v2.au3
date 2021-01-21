; Copy a number of files showing progress bar and keeping user
; advised of progress

Opt("MustDeclareVars", 1)     ; 0=no, 1=require pre-declare

#include <guiconstants.au3>

Const $WIDTH = 500
Const $HEIGHT = 120
Const $PROG_HEIGHT = 30
Const $CTRL_BORDER = 10
Const $MESS1 = "Copying file "
Const $MESS2 = " of "

; Temporary entry point for testing

MsgBox(0, "MyFileCopy...", "Returned : " & MyFileCopy("Test copy", "C:\Source", "C:\Dest", 1))
Exit

; MyFileCopy
; Copy all files from one directory while providing progress info.
; Returns number of files copied (which could be 0).
; Returns -1 if source directory doesn't exist

Func MyFileCopy($WinTitle, $SourceDir, $DestDir, $Flag)
    
    Local $NumFiles, $cnt, $Message, $OverallProg_Bar, $FileProg_Bar
    Local $DirInfo[3], $FileBytesDoneSoFar = 0, $TotalBytesDoneSoFar = 0
    Local $FileSearchHandle, $FileName
	Local $Percent, $Bytes, $TypeCommand
    
	; Create GUI
    GUICreate($WinTitle, $WIDTH, $HEIGHT, -1, -1, $WS_CAPTION, BitOR($WS_EX_TOPMOST, $WS_EX_DLGMODALFRAME))
    $Message = GUICtrlCreateLabel("Initialising for file copy...", $CTRL_BORDER, $CTRL_BORDER, $WIDTH - (2 * $CTRL_BORDER), 40, $SS_CENTER)
    $FileProg_Bar = GUICtrlCreateProgress($CTRL_BORDER, $HEIGHT - (2 * $PROG_HEIGHT)-(2 * $CTRL_BORDER), $WIDTH - (2 * $CTRL_BORDER), $PROG_HEIGHT)
	$OverallProg_Bar = GUICtrlCreateProgress($CTRL_BORDER, $HEIGHT - $PROG_HEIGHT - $CTRL_BORDER, $WIDTH - (2 * $CTRL_BORDER), $PROG_HEIGHT)
    GUICtrlSetFont($Message, 14)
    GUISetState(@SW_SHOW)
    
	; Find out how many files we have to copy
    $DirInfo = DirGetSize($SourceDir, 1)                   		; 1 means use extended mode so get extra information
    $FileSearchHandle = FileFindFirstFile($SourceDir & "\*.*")	; Set up search handle to pick up files one by one
    
	; Copy files, advance progress bar and update message
    If $DirInfo[0] == -1 Then
        GUIDelete()
        Return(-1)
    Else
        For $cnt = 1 To $DirInfo[1]
            $FileName = FileFindNextFile($FileSearchHandle)
            GUICtrlSetData($Message, $MESS1 & String($cnt) & $MESS2 & String($DirInfo[1]) & " (" & $FileName & ")")
            $TypeCommand = 'type "' & $SourceDir & '\' & $FileName & '" > "' & $DestDir & '\' & $FileName & '"'
            Run(@ComSpec & ' /c ' & $TypeCommand, $DestDir, @SW_HIDE)
			$Bytes = FileGetSize($SourceDir & "\" & $FileName)
            Do
                $FileBytesDoneSoFar = FileGetSize($DestDir & "\" & $FileName)
                $Percent = ($FileBytesDoneSoFar / $Bytes) * 100
                GUICtrlSetData($FileProg_Bar, $Percent)
				GUICtrlSetData($OverallProg_Bar, (100 / $DirInfo[0]) * ($TotalBytesDoneSoFar + $FileBytesDoneSoFar))
            Until $Bytes == $FileBytesDoneSoFar
			$TotalBytesDoneSoFar = $TotalBytesDoneSoFar + $Bytes
        Next
        FileClose($FileSearchHandle)
        GUIDelete()
        Return($DirInfo[1])
    EndIf
EndFunc