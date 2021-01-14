#CS
;~ This script is demonstrate copy process with custom designed progress displayed, the progress display details about the copy process.
;~ 
;~ Syntax: _CopyWithProgress("C:\Source", "C:\Dest", 1)
;~ First parm is the source dir that files will be copied from.
;~ Second param is the destination path that files will be copied to.
;~ If the last parameter set as 1, then all existing files will be replaced with copied ones.
;~ 
;~ Author: G.Sandler a.k.a CreatoR
;~ Functions _DirListToArray() and _FileListToArrayEx() is originaly writen by amel27.
#CE

#include <Array.au3>
#include <File.au3>

_CopyWithProgress("C:\Source", "C:\Dest", 1)

Func _CopyWithProgress($SourcePath, $DestPath, $Replace=0)
	If Not FileExists($SourcePath) Then Return SetError(1, 0, -1)
	If Not StringInStr(FileGetAttrib($DestPath), "D") And Not DirCreate($DestPath) Then Return SetError(2, 0, "")
	If $Replace <> 0 And $Replace <> 1 Then SetError(3, 0, "")
	
	Local $PathName = StringRegExpReplace($SourcePath, "^.*\\", "")
	Local $Progress=0, $Counter, $ReadySize, $MidlePath, $Ready, $TimeRemained
	Local $CurrentFilePath, $CurrentFileName, $CurrentFilePathName, $CurrentParentDirName
	
	ProgressOn("Copy Files...", "Copy: " & $PathName, "Getting dir structure" & @LF & "Please wait...")
	
	Local $TotalDirSize = DirGetSize($SourcePath)
	Local $FilesArr = _FileListToArrayEx($SourcePath)
	Local $FilesCount = UBound($FilesArr)-1
	Local $ProgressStep = 100 / $FilesCount
	
	If IsArray($FilesArr) Then
		For $i = 1 To UBound($FilesArr)-1
			$CurrentFilePath = $FilesArr[$i]
			$CurrentFileName = StringRegExpReplace($CurrentFilePath, "^.*\\", "")
			$CurrentFilePathName = StringReplace($CurrentFilePath, $SourcePath & "\", "")
			
			$CurrentParentDirName = _GetParentDirName($CurrentFilePath)
			
			$Progress += $ProgressStep
			$Counter += 1
			
			$ReadySize = FileGetSize($CurrentFilePath)
			
			$MidlePath = _GetMidlePath($CurrentFilePath)
			$Ready = $Counter & "/" & $FilesCount
			$TimeRemained = _GetTimeRemained($TotalDirSize, $ReadySize, $FilesCount, $Counter)
			
			ProgressSet($Progress, 'Copy... from "' & $CurrentParentDirName & '" to "' & $CurrentParentDirName & '"' & @LF & _
				$MidlePath & @LF & "Approximately Remained Time: " & $TimeRemained, "Ready: " & $Ready)
			FileCopy($CurrentFilePath, $DestPath & "\" & $CurrentFilePathName, 8+$Replace)
		Next
	EndIf
	ProgressOff()
EndFunc

Func _FileListToArrayEx($sPath, $sMask='*')
	Local $i, $j, $blist, $rlist[1]=[0], $dlist = _DirListToArray($sPath)
	_ArrayAdd ($dlist, $sPath)
	For $i=1 To $dlist [0] +1
		$blist = _FileListToArray ($dlist [$i], $sMask, 1)
		If Not @error Then
			For $j=1 To $blist [0]
				_ArrayAdd ($rlist, $dlist[$i] & "\" & $blist [$j])
			Next
		EndIf
	Next
	$rlist [0] = UBound ($rlist) - 1
	Return $rlist
EndFunc

Func _DirListToArray($sPath)
    Local $rlist[2]=[1, $sPath], $blist, $alist=_FileListToArray ($sPath, '*', 2)
	If IsArray ($alist) Then
        For $i=1 To $alist [0]
            _ArrayAdd ($rlist, $sPath & "\" & $alist [$i])
			$blist = _DirListToArray ($sPath & "\" & $alist [$i])
            If $blist[0]>0 Then
                For $j=1 To $blist [0]
                    _ArrayAdd ($rlist, $blist [$j])
                Next
            EndIf
        Next
    EndIf
    $rlist[0] = UBound($rlist) - 1
    Return $rlist
EndFunc

Func _GetMidlePath($sPath)
	If StringLen($sPath) <= 50 Then Return $sPath
	Local $StartPath = StringLeft($sPath, 25)
	Local $EndPath = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -2)-1)
	Return $StartPath & "..." & $EndPath
EndFunc

Func _GetParentDirName($FullName)
	Local $LastSlashPos = StringInStr($FullName, "\", 0, -1)
	Local $SecondLastSlashPos = StringInStr($FullName, "\", 0, -2)
	Return StringMid($FullName, $SecondLastSlashPos+1, $LastSlashPos-$SecondLastSlashPos-1)
EndFunc

Func _GetTimeRemained($TotalSize, $CurrentSize, $FilesCount, $CurrentFilesCount)
	Local $NumLevl = 0.5
	
	If $TotalSize <= $CurrentSize Then Return _SecsToTime(0)
	
	Switch $FilesCount - $CurrentFilesCount
		Case 0 To 100
			$NumLevl = 0.1
		Case 100 To 1000
			$NumLevl = 0.5
		Case 1000 to 2000
			$NumLevl = 1
		Case Else
			$NumLevl = 2
	EndSwitch
	
	$Secs = ($TotalSize * $NumLevl) / (3600 * $CurrentFilesCount) - ($CurrentSize * $NumLevl) / (3600 * $CurrentFilesCount)
	Return _SecsToTime($Secs)
EndFunc

Func _SecsToTime($iTicks, $Delim=":")
	If Number($iTicks) >= 0 Then
		$iHours = Int($iTicks / 3600)
		$iTicks = Mod($iTicks, 3600)
		$iMins = Int($iTicks / 60)
		$iSecs = Round(Mod($iTicks, 60))
		If StringLen($iHours) = 1 Then $iHours = "0" & $iHours
		If StringLen($iMins) = 1 Then $iMins = "0" & $iMins
		If StringLen($iSecs) = 1 Then $iSecs = "0" & $iSecs
		Return $iHours & $Delim & $iMins & $Delim & $iSecs
	EndIf
	Return SetError(1, 0, 0)
EndFunc
