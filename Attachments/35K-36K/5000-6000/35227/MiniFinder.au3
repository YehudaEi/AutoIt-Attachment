#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         HAMID

 Script Function :
	MiniFinder
0 = Find Files/Folders
1 = Find Files
2 = Find Folders
#ce ----------------------------------------------------------------------------



; #FUNCTION# ====================================================================================================================
; Name...........: MiniFinder
; Description ...: Find Files and folder
; Syntax.........: MiniFinder($RootAddress,$FindDepth=-1,$TextToFind="",$FindType=0,$TargetFileTypes=-1,$TextInFileContent="")
; Parameters ....: $RootAddress - root address fo find work
;                  [optional] $FindDepth  - Value to add
;                  [optional] $TextToFind -
;                  [optional] $FindType -
;                  [optional] $TargetFileTypes -
;                  [optional] $TextInFileContent -
; Return values .: Success - array of result
;                  Failure - -1, sets @error
;                  |1 - $avArray is not an array
;                  |2 - $avArray is not a 1 dimensional array
; Author ........: HAMID
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes

;MiniFinder("c:\windows",6,"run|notepad",0,"exe|avi") ; = find folders with "Run" or "notepad" or filetype with "exe" or avi
;MiniFinder("c:\windows",6,"run|notepad",1,"exe") ; = find files with "Run" or "notepad" name and filetype with is exe
;MiniFinder("c:\windows",6,"run|notepad",2) ; = find folders with "Run" or "notepad"

; ===============================================================================================================================


;$aFFL=$FindedFolderList
;$aSFFL=$SubFindedFolderList
;$aFResult = $aFindResult
;$FindType = Find File Or Folders


#include <Timers.au3>
#include<File.au3>
#include<Array.au3>



$Starttime = _Timer_Init() ; Temp

$aFResult=MiniFinder("j:\",7,"")


_ArrayDisplay($aFResult)

$SecDiff=_Timer_Diff($starttime)/1000 ; Temp
ConsoleWrite( "Running Time = >     " & $SecDiff & @CRLF ) ; Temp





Func MiniFinder($RootAddress,$FindDepth=-1,$TextToFind="",$FindType=0,$TargetFileTypes=-1,$TextInFileContent="")

	If $FindType=2  And $TargetFileTypes<>-1 Then
		$TargetFileTypes=-1
		ConsoleWrite("Mini Finder : You can't define filetype in folder search" & @CRLF )
	EndIf


	If StringRight($RootAddress,1)<>"\" Then $RootAddress = $RootAddress & "\"
	If $TargetFileTypes<>-1 Then $TargetFileTypes = "|" & $TargetFileTypes & "|"
	Dim $aFResult[1]
	Dim $aFFL[2]
	$aFFL[0]=1
	$aFFL[1]=$RootAddress

	$i=1
	While 1
		$aSFFL=_FileListToArray($aFFL[$i],"*",0)
		If $i==$aFFL[0] And @error Then ExitLoop ; If Reached To last key of array and this key not have subdir
		If IsArray($aSFFL) Then
			$FolderCount=$aFFL[0]
			ReDim $aFFL[$aFFL[0]+1+$aSFFL[0]]
			$aFFL[0]=$aFFL[0]+$aSFFL[0]
			For $j= 1 To UBound($aSFFL)-1
				$aFFL[$FolderCount+$j]=$aFFL[$i] & $aSFFL[$j] & "\" ; Add Folder Name To Search Array ( With \ )
				If $FindType=0 Then ; add Files And Folders
					If Not StringInStr(FileGetAttrib($aFFL[$i] & $aSFFL[$j]),"D") Then ; Add file name
						;---------------------> For Getting FileType/Filename and For No Wrong Change File Name
						$FindDot = StringSplit($aSFFL[$j], ".")
						If @error Then
							$FileType="*" ; $TargetFileTypes
							$FileName=$aSFFL[$j]
						Else
							_ArrayReverse($FindDot)
							Global $FileType=$FindDot[0]
							_ArrayReverse($FindDot)
							_ArrayPop($FindDot)
							Global $FileName=_ArrayToString($FindDot,".",1)
						EndIf
						;---------------------> / For Getting FileType/Filename and For No Wrong Change File Name
						$TextToFindArray=StringSplit($TextToFind,"|")
						If @error Then
							If ($TextToFind="" Or StringInStr($FileName,$TextToFind)) And ($TargetFileTypes=-1 Or StringInStr($TargetFileTypes,"|" & $FileType & "|" )) Then
								$aFResult[0]=$aFResult[0]+1
								ReDim $aFResult [$aFResult[0]+1]
								$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
							EndIf
						Else
							For $k=1 To UBound($TextToFindArray)-1
								If  StringInStr($FileName,$TextToFindArray[$k]) And ($TargetFileTypes=-1 Or StringInStr($TargetFileTypes,"|" & $FileType & "|" )) Then
									$aFResult[0]=$aFResult[0]+1
									ReDim $aFResult [$aFResult[0]+1]
									$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
								EndIf
							Next
						EndIf
					Else ; add folder
					If StringInStr(FileGetAttrib($aFFL[$i] & $aSFFL[$j]),"D") Then
						$TextToFindArray=StringSplit($TextToFind,"|")
						If @error Then
							If ($TextToFind="" Or StringInStr($aSFFL[$j],$TextToFind))  Then
								$aFResult[0]=$aFResult[0]+1
								ReDim $aFResult [$aFResult[0]+1]
								$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
							EndIf
						Else
							For $k=1 To UBound($TextToFindArray)-1
								If  StringInStr($aSFFL[$j],$TextToFindArray[$k])  Then
									$aFResult[0]=$aFResult[0]+1
									ReDim $aFResult [$aFResult[0]+1]
									$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
									ExitLoop
								EndIf
							Next
						EndIf
					EndIf
					EndIf
				ElseIf $FindType=1 Then ;add File
					If Not StringInStr(FileGetAttrib($aFFL[$i] & $aSFFL[$j]),"D") Then
						;---------------------> For Getting FileType/Filename and For No Wrong Change File Name
						$FindDot = StringSplit($aSFFL[$j], ".")
						If @error Then
							$FileType="*" ; $TargetFileTypes
							$FileName=$aSFFL[$j]
						Else
							_ArrayReverse($FindDot)
							Global $FileType=$FindDot[0]
							_ArrayReverse($FindDot)
							_ArrayPop($FindDot)
							Global $FileName=_ArrayToString($FindDot,".",1)
						EndIf
						;---------------------> / For Getting FileType/Filename and For No Wrong Change File Name
						$TextToFindArray=StringSplit($TextToFind,"|")
						If @error Then
							If ($TextToFind="" Or StringInStr($FileName,$TextToFind)) And ($TargetFileTypes=-1 Or StringInStr($TargetFileTypes,"|" & $FileType & "|" )) Then
								$aFResult[0]=$aFResult[0]+1
								ReDim $aFResult [$aFResult[0]+1]
								$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
							EndIf
						Else
							For $k=1 To UBound($TextToFindArray)-1
								If  StringInStr($FileName,$TextToFindArray[$k]) And ($TargetFileTypes=-1 Or StringInStr($TargetFileTypes,"|" & $FileType & "|" )) Then
									$aFResult[0]=$aFResult[0]+1
									ReDim $aFResult [$aFResult[0]+1]
									$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
								EndIf
							Next
						EndIf
					EndIf
				ElseIf $FindType=2 Then ; Find Folders
					If StringInStr(FileGetAttrib($aFFL[$i] & $aSFFL[$j]),"D") Then
						$TextToFindArray=StringSplit($TextToFind,"|")
						If @error Then
							If ($TextToFind="" Or StringInStr($aSFFL[$j],$TextToFind))  Then
								$aFResult[0]=$aFResult[0]+1
								ReDim $aFResult [$aFResult[0]+1]
								$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
							EndIf
						Else
							For $k=1 To UBound($TextToFindArray)-1
								If  StringInStr($aSFFL[$j],$TextToFindArray[$k])  Then
									$aFResult[0]=$aFResult[0]+1
									ReDim $aFResult [$aFResult[0]+1]
									$aFResult[$aFResult[0]]=$aFFL[$i] & $aSFFL[$j]
									ExitLoop
								EndIf
							Next
						EndIf
					EndIf
				EndIf
			Next
			;-----------------> Define Depth
			$aTempSplit=StringSplit($aFFL[$FolderCount+$j-1],"\") ; Scrutiny backslash number in Last Key
			If $aTempSplit[0]-3=$FindDepth Then ExitLoop
			;-----------------> End Define Depth
		EndIf
		$aFFL[$i]=""
		$i=$i+1
	WEnd
		If UBound($aFResult)>1 Then
			Return $aFResult
		Else
			Return 0
		EndIf
EndFunc