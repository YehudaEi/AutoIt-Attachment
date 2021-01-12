#include "_FileChangeRecursive.au3"

#include <Word.au3>

;Global $__glb_FileChangeRecursive_debug_file = "C:\temp\autoit\debug.txt"
$start_timer = TimerInit()

;$oWordApp = _InitWord()

;$retval = _FileChangeRecursive("C:\temp\word","*.txt",-1,"_ConvertFile")
;$retval = _FileChangeRecursive("C:\temp\autoit","*.au3",-1,"_CopyFile",".bakk")
;$retval = _FileChangeRecursive("C:\temp\autoit","*.au3",-1,"_DeleteFile")
;retval = _FileChangeRecursive("C:\temp\autoit","*.au3",-1,"_BackupFile","C:\temp\autoit","c:\temp\backup")

;$retval = _FileChangeRecursive("C:\","*",-1,"_ListFile")
$retval = _FileChangeRecursive("C:\temp\autoit","4051*.au3",-1,"_ListFile")

$timer_end = TimerDiff($start_timer) / 1000
MsgBox(0,"","Retval: " & $retval & " Error : " & @error  & " Extended: " & @extended & " Time: " & $timer_end)

;#==============================================================
;#== Copy the file and append the given extension
;#==============================================================
func _CopyFile($filepath,$extenstion)
	FileCopy($filepath,$filepath & $extenstion)
endfunc

;#==============================================================
;#== Delete the file. Only remove the comment if you are SURE
;#== what you are doing !!!
;#==============================================================
func _DeleteFile($filepath)
	;FileDelete($filepath)
	ConsoleWrite("Deleting: " & $filepath)
endfunc

;#==============================================================
;#== Rename the file, replace the extension with the given one
;#==============================================================
func _RenameFile($filepath,$extenstion)
	Local $parts = StringSplit($filepath,".")
	Local $newpath = ""
	For $n = 1 to $parts[0]-1
		$newpath &= $parts[$n]
	Next
	
	FileMove($filepath,$newpath & $extenstion)
endfunc

;#==============================================================
;#== Just list the found files. You can also write the names
;#== into a global array, to process it later
;#==============================================================
func _ListFile($filepath)
	ConsoleWrite($filepath & @CRLF)
endfunc

;#==============================================================
;#== Make a backup of the file. Copy the files to the given backup
;#== folder. The directory structure will be preserverd
;#==============================================================
func _BackupFile($filepath,$basepath,$backupfolder)
	Local $relpath = StringReplace($filepath,$basepath,"")
	FileCopy($filepath,$backupfolder & $relpath,8+1)
endfunc

;#==============================================================
;#== Convert the files with Word. Open the file and save it
;#== as a true WORD (*.doc) file. Add the extension _converted.doc
;#==============================================================
func _InitWord()
	_WordErrorHandlerRegister ()
	Local $oWordApp = _WordCreate ("", 0, 0)
	$oWordApp.DisplayAlerts = False
	$oWordApp.Options.DisableFeaturesbyDefault = True
	Return $oWordApp
EndFunc

func _ConvertFile($filepath,$oWordApp)
	Local $oDoc = _WordDocOpen ($oWordApp, $filepath)
	_WordDocSaveAs ($oDoc, $filepath & "_converted.doc")
	_WordDocClose ($oDoc, 0)
endfunc