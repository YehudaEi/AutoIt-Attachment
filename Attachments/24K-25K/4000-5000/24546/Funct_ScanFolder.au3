;----------------------------------------------------------------------------------------------------
;   Scan Folder Function
;
;   This Function scans files in the folder specified and sub folders tree (if any)
;   The first time it´s invoked CREATES a Search and returns the FULL PATH of the File found
;   Subsecuents calls, continues the search until no more files are found and closes de search
;   When end of search is reached, RETURNS -1 instead of the file name.
;
;   If the caller wants to cancel/stop/abort the search, calls the function with the Keyword "-ABORT-"
;   as Source Folder.
;
;   Input: 
;      Start Folder to Scan or "-ABORT-" 
;   Returns: 
;      Full path to file found or -1
;----------------------------------------------------------------------------------------------------

#include-once 

#Include <Array.au3>

; Field Definition
Enum $_FLD_SourceFolder, $_FLD_SearchHandle, $_FLD_File, $_FLD_FullFilePath, $_FLD_FileAttributes, $_FLD_SearchStat, $_FLD_RecursionLevel, $_Dim
Const $Stack_Deep = $_Dim * 256

; Work Arrays for the Function 
	DIM $SD [$_Dim]
	DIM $Stack [$Stack_Deep]
	Dim $Stack_Pointer = $Stack_Deep - 1

; Default Values
	$SD [$_FLD_SourceFolder] = "NONE"
	$SD [$_FLD_SearchHandle] = 0
	$SD [$_FLD_File] = "NONE"
	$SD [$_FLD_FullFilePath] = "NONE"
	$SD [$_FLD_FileAttributes] = "NONE"
	$SD [$_FLD_SearchStat] = "INIT"
	$SD [$_FLD_RecursionLevel] = 0

Func PushDTA ()
	Local $i
	For $i = 0 to ($_Dim - 1)
		$Stack [$Stack_Pointer] = $SD [$i]
		$Stack_Pointer -= 1
	Next
	
	$SD [$_FLD_RecursionLevel] += 1
EndFunc

Func PopDTA ()
	Local $i
	For $i = ($_Dim - 1) to 0 Step -1
		$Stack_Pointer += 1
		$SD[$i] = $Stack[$Stack_Pointer]
	Next
EndFunc


Func ScanFolder($SourceFolder)
	Local $RetVal = ""
	
	If $SourceFolder == "-ABORT-" Then
		Switch $SD [$_FLD_SearchStat]
			Case "INIT"
				$RetVal = -1		; Nothing Done - Return
				
			Case "FIND_FIRST"
				$SD [$_FLD_SearchStat] = "ABORT"
				
			Case "FIND_NEXT"
				$SD [$_FLD_SearchStat] = "ABORT"
				
			Case Else
				MsgBox(48,"ERROR","Unknown Internal Search State. ABORTED!")
				$RetVal = -1
		EndSwitch
		
	EndIf
	
	While $RetVal = ""
		Switch $SD [$_FLD_SearchStat]
			Case "INIT"
				; Init Search Array
				If StringRight($SourceFolder,1) == "\" Then
					$SourceFolder = StringLeft($SourceFolder,StringLen($SourceFolder)-1)
				EndIf
				$SD [$_FLD_SourceFolder] = $SourceFolder
				$SD [$_FLD_SearchHandle] = 0
				$SD [$_FLD_File] = "NONE"
				$SD [$_FLD_FullFilePath] = "NONE"
				$SD [$_FLD_FileAttributes] = "NONE"
				$SD [$_FLD_SearchStat] = "FIND_FIRST" ; Next Phase
				$SD [$_FLD_RecursionLevel] = 0
		   
			Case "FIND_FIRST"
				$SD [$_FLD_SearchHandle] = FileFindFirstFile($SD [$_FLD_SourceFolder] & "\*.*")
				If $SD [$_FLD_SearchHandle] = -1 Then
					If $SD [$_FLD_RecursionLevel] < 1 Then      ; Top Level ?
						$SD [$_FLD_SearchStat] = "INIT"         ; Next Phase Start. Work Done.
						$RetVal = -1                            ; End Execution and Retval NoMoreFiles
					Else
						PopDTA()								; Not in Top Level, Continue.
					EndIf
				Else
				   $SD [$_FLD_SearchStat] = "FIND_NEXT"          ; OK, Find Next File.				
				EndIf

			Case "FIND_NEXT"
				$SD [$_FLD_File] = FileFindNextFile($SD [$_FLD_SearchHandle])
					IF @error Then
						If $SD [$_FLD_RecursionLevel] < 1 Then      ; Top Level ?
							$SD [$_FLD_SearchStat] = "INIT"         ; Next Phase Start. Work Done.
							$RetVal = -1                            ; End Execution and Retval NoMoreFiles
							FileClose($SD [$_FLD_SearchHandle])
						Else
							FileClose($SD [$_FLD_SearchHandle])		; No More Files in current Level. Close current Search 
							PopDTA()								; Continue in upper level.
						EndIf
					Else
						$SD [$_FLD_FullFilePath] = $SD [$_FLD_SourceFolder]  & "\" & $SD [$_FLD_File] 	;   $FullFilePath = $SourceFolder & "\" & $ File
						$SD [$_FLD_FileAttributes] = FileGetAttrib($SD [$_FLD_FullFilePath])			;   $FileAttributes = FileGetAttrib($FullFilePath)
							If StringInStr($SD [$_FLD_FileAttributes],"D") Then								;   If StringInStr($FileAttributes,"D") Then
								PushDTA()	 																;   If Directory, Save Data and start recursion
								$SD [$_FLD_SourceFolder] = $SD [$_FLD_FullFilePath]
								$SD [$_FLD_SearchStat] = "FIND_FIRST" 									;   Next Phase: Find First starting from here
							Else																	;   Normal File To Report
								$RetVal = $SD [$_FLD_FullFilePath]			; Exit Procedure Returning File Found
							EndIf
					EndIf
						
				Case "ABORT"
					While $SD [$_FLD_RecursionLevel] > 0
						FileClose($SD [$_FLD_SearchHandle])
						PopDTA()
					WEnd
					If $SD [$_FLD_SearchHandle] > -1 Then
						FileClose($SD [$_FLD_SearchHandle])
					EndIf
					$SD [$_FLD_SearchStat] = "INIT"         ; Next Phase Start. Work Done.
					$RetVal = -1

			Case Else
				MsgBox(48,"ERROR","Unknown Internal Search State. ABORTED!")
				$RetVal = -1
				
		EndSwitch
	WEnd
		   
	Return $RetVal
EndFunc		

; --------------------------------------------------------
;
; MAIN - TESTING
;
; --------------------------------------------------------


$File=""
$Count=0
While $File > -1
	$File = ScanFolder("C:\")
	ToolTip($File,0,200)
	FileWriteLine(@ScriptDir & "\ScanFolder.txt" ,$File)
	$Count += 1
	If $Count >= 2000 Then
	   $File = ScanFolder("-ABORT-")
	EndIf
WEnd

MsgBox(0,"Scan Completed","Files Found: " & $Count)

