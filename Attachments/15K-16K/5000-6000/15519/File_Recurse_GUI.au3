#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("File Recursion and Logger                          ~~ By Firestorm", 462, 320, 193, 115)
$Label1 = GUICtrlCreateLabel("File Recursion and Logger", 180, 24, 130, 17, $WS_BORDER)
$Border1 = GUICtrlCreateLabel(" ", 8, 56, 443, 2, $SS_SUNKEN)
$FFile = GUICtrlCreateLabel("Found File: ", 32, 80, 420, 17, $SS_SUNKEN)
$FFolder = GUICtrlCreateLabel("File Folder: ", 32, 112, 420, 17, $SS_SUNKEN)
$TFFiles = GUICtrlCreateLabel("Total Files Found: ", 32, 176, 420, 17, $SS_SUNKEN)
$TFFolders = GUICtrlCreateLabel("Total Folders Found: ", 32, 208, 420, 17, $SS_SUNKEN)
$TFound = GUICtrlCreateLabel("Total Found: ", 32, 240, 420, 17, $SS_SUNKEN)
$FF = GUICtrlCreateLabel("Folder/File: ", 32, 144, 420, 17, $SS_SUNKEN)
$Input1 = GUICtrlCreateInput("Specify Directory..", 32, 272, 290)
$Button1 = GUICtrlCreateButton("Begin", 390, 272, 62, 17)
$Browse = GUICtrlCreateButton("Browse", 326, 272, 62, 17)
$LogFile = GUICtrlCreateLabel("Log File Dir: " & @ScriptDir & "\File_Output.txt", 32, 295, -1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			$path = GUICtrlRead($Input1)
			GUICtrlSetData($Button1, "Working")
			_Recursive($path)
		Case $Browse
			$browse_file = FileSelectFolder("Please select a folder to search.", @HomeDrive, 4)
			GUICtrlSetData($Input1, $browse_file)
	EndSwitch
WEnd


;;; RecursiveDir.au3;;;

; the target folder will be recursively searched through
; and returns an array of files and folder together with full path.
; thanks in big part to Larry and Beerman for the script which i modified
; useage : _Recursive($Sourcedir)
; Firestorm
;------------------------------------------------------------------------------------
_Recursive($path)
Func _Recursive($Sourcedir)
    $a = 0
    $f = 0
    $d = 0
	$FileFound = 0
    $grand = ""
    While 1
        $Fold = $Sourcedir
        
;~         $reject = StringLen($Fold)
;~         If $reject = 3 Then
;~             MsgBox(0, 'Rejected', "This routine is only meant for folders only. Slect Again")
;~             $dirrejected = FileSelectFolder("Choose a folder this time not a drive letter.", "")
;~             If $dirrejected = "" Then Exit
;~             $Sourcedir = $dirrejected
;~         Else
            
            
            $Stack = $Fold & ">"
            $FileList = $Fold & ">"
			$file_o = FileOpen("File_Output.txt", 2)
			FileWrite($file_o, @CRLF & "~~> " & $path & @CRLF)
            While $Stack <> ""
                $root = StringLeft($Stack, StringInStr($Stack, ">") - 1) & "\"
                $Stack = StringTrimLeft($Stack, StringInStr($Stack, ">"))
                $h = FileFindFirstFile($root & "*.*")
				
                If $h > - 1 Then
                    $FileFound = FileFindNextFile($h)
                    While Not @Error And $FileFound <> ""
                        If $FileFound <> "." And $FileFound <> ".." And _
           StringInStr(FileGetAttrib($root & $FileFound), "D") Then
                            $Stack = $Stack & $root & $FileFound & ">"
                            
                            $FileList = $FileList & $root & $FileFound & "<"
                            $d = $d + 1
                            $a = $a + 1
                        Else
                            
                            
                            If $FileFound = "." Or $FileFound = ".." Then
                            Else
                                $f = $f + 1
                                $a = $a + 1
                                $FileList = $FileList & $root & $FileFound & "<"
                            EndIf
                            
                        EndIf
                        
                        $len = StringLen($FileList)
                        If $len > 10000 Then
                            $grand = $grand & $FileList
                            $FileList = ""
                        Else
                        EndIf
                        
						GUICtrlSetData($TFFiles, "Total Files Found: " & $f)
						GUICtrlSetData($TFFolders, "Total Folders Found: " & $d)
						GUICtrlSetData($TFound, "Total Found: " & $a)
						GUICtrlSetData($FFile, "Found File: " & $FileFound)
						GUICtrlSetData($FFolder, "File Folder: " & $root)
						GUICtrlSetData($FF, "Folder/File: " & $root & $FileFound)
;~                         ToolTip("Building List: Files-" & $f & " Folders-" & $d & " Total-" & $a & " File-" & $FileFound & " Root-" & $root, 0, 0)
						FileWrite($file_o, $root & $FileFound & @CRLF)
                        $FileFound = FileFindNextFile($h)
                    WEnd
                    FileClose($h)
					
                EndIf
            WEnd
			MsgBox(0, "Complete", "Files-" & $f & " Folders-" & $d & " Total-" & $a)
			GUICtrlSetData($Button1, "Begin")
			WinActivate("File Recursion and Logger                          ~~ By Firestorm")
			$file_o = FileOpen("File_Output.txt", 1)
			FileWrite($file_o, @CRLF & "~~> " & $path & @CRLF)
			FileWrite($file_o, "Files - " & $f & @CRLF & "Folders - " & $d & @CRLF & " Total - " & $a) 
            $grand = $grand & $FileList
            $FileList = $grand
            $cleanup = StringReplace($FileList, ">", "<")
            $outputsubdirs = StringSplit($cleanup, "<", 1)
            Return $outputsubdirs
            Exit
;~         EndIf
    WEnd
EndFunc  ;==>_Recursive