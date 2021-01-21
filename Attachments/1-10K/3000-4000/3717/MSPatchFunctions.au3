#include-once
; ----------------------------------------------------------------------------
;
; Name:				MSPATCHFUNCTIONS.AU3
; Version:			4.0
;
; AutoIt Version:	3.1.1 (for better performance, use: 3.1.1.18 of higher)
; Language:			English
; Platform:			Win9x / WinMe / NT4 / 2K / XP / 2K3
; Author:			S.A. Pechler
; Date:				Fourth version: 12-APR-2005
;
; Description:		Helper functions for MSPATCH.AU3 and MSPATCHEDIT.AU3
; ----------------------------------------------------------------------------

;===============================================================================
; Global Variables
;===============================================================================
Dim $PatchDebug		; Flag for debugging
Dim $ShowErrors		; Flag to show a message if an error occures.

; Column definition of CSV file
Dim $c_QNumber		; Knowledgebase number
Dim $c_PatchNumber	; Security bulletin number
Dim $c_Date		; 13/Jun/2005, added Release Date Field
Dim $c_Description		; Patch description
Dim $c_Commandline	; Command line and parameters
Dim $c_Remarks		; Internal remarks
Dim $c_Win95		; Flag: applies to Windows 95
Dim $c_Win98		;
Dim $c_WinMe		;
Dim $c_winnt4sp1to5	; Flag: patch applies to Win NT4.0 Servicepack 1 to 5
Dim $c_winnt4sp6		; Flag: patch applies to Win NT4.0 Servicepack 6
Dim $c_win2Ksp1to2
Dim $c_win2ksp3to4
Dim $c_WinXP
Dim $c_WinXPsp1
Dim $c_WinXPsp2
Dim $c_Win2003
Dim $c_Win2003SP1	; Flag: patch applies to Windows 2003 with Servicepack 1
Dim $c_InstalledCrit		; Criteria: must result in TRUE when patch is installed
Dim $c_RequiredCrit	; Criteria: must result in TRUE when patch is required

;===============================================================================
Func ReadPatchList($Filename,ByRef $aArray,ByRef $aHeader)

; This function reads the CSV file
; Write each element (column) of the line in a temporary array
; Writes for each line the temporary array into $aArray[]

 Local $hFile		; Filehandle to opened file
 Local $TempArray		; One line of the hotfix list, splitted into an array
 Local $LineCounter	; Variable to count lines :-)
 Local $CriteriaLine		; AutoIt expression containing criteria for patch to be installed
 Local $Delimiter		; Separation character used in patchlist

 $Delimiter=";"		; our default separation character will be a ";"
 $LineCounter=1		; Line counter

 $hFile = Fileopen( $FileName, 0)
 if $hFile = -1 then
   ShowError("Error: Could not open patchlist. Filename: " & $Filename,0)
   Return -1
 endif

 ;The first line of the CSV file must contain a header that tells us the contents of the columns.
	 
 if FileReadLineToArray( $hFile, $aHeader,$Delimiter ) < 2 then

    $Delimiter = ","	; Read error, so we try again with a comma as separator
   
    ; Since AutoIt does not have a FileSeek function, we have to re-open the file to read from the start again.
    FileClose($hFile)
    $hFile = Fileopen( $FileName, 0)

    if FileReadLineToArray( $hFile, $aHeader,$Delimiter ) < 2 then
       ShowError("Error: Could not read contents of file: " & $Filename,  20)
       Return -1
    endif

 endif


 ; Now check if we have all required columns.

 if ReadHeader($aHeader) < $aHeader[0] then
    ShowError("Error: Column format invalid of file: " & $Filename,20)
    Return -1
 endif


 ; Read the remaining contents of the file

 while FileReadLineToArray( $hFile, $TempArray, $Delimiter ) > 1

 	ShowDebugMessage("ReadPatchList: $LineCounter: " & $LineCounter & " $TempArray[$LineCounter]: " & $TempArray[1])

	$aArray[$LineCounter]=$TempArray	; save the line for later use.	

	$LineCounter=$LineCounter + 1		; next line
 wend

 FileClose($hFile)

 $aArray[0]=$LineCounter-1

 Return $LineCounter-1

EndFunc


;===============================================================================
Func FileReadLineToArray( $hFile, ByRef $aArray, $Delimiter )
;
; This function is used by ReadPatchList() 
;
; It reads one line of a CSV file into an array of strings.
; The separation character is specified by parameter $Delimiter.
; (we use a semicolon (;) or a comma (,) in our Patchlist)
;
; Parameter(s):     $hFile     - Handle to the already opened file
;                   $aArray    - The array to store the line of the file
;                   $Delimiter - Separation character for the colums in the file.
;
; Requirement(s):   A file must be opened first.
;
; Return Value(s):  On Success   - Returns Number of elements
;                   On Failure   - Returns -1 and sets @error = 1
;                   On EndofFile - Returns -2 and sets @error = -1
;                   On LineError - Returns -3 and sets @error = -2
; Author(s):        Sven Pechler
; Note(s):          Based on _FileReadToArray of Jonathan Bennett <jon at hiddensoft com>
;
; When you export an Excel sheet to CSV it will really scramble the output:
; It uses the semicolon (;) as a separator (instead of a comma)
; When a field contains a double quote (") then Excel will surround it with additional double quotes 
; and it will double all double quotes in that field.


  Local $sLine		; One line read from the file
  Local $Counter	; Counter for each element in the array


  If $hFile = -1 Then	; Check if the file handle is valid
    SetError( 1 )
    Return -1
  EndIf

  $sLine = FileReadLine( $hFile)	; Read one line from the file

  if @error <> 0 then 		; End of file reached ?
    SetError( -1 )
    Return -2
  Endif

  $aArray = StringSplit( $sLine , $Delimiter )		; Fill the array 

  if @error <> 0 then 			; Filling the array was successful ?
    SetError( -2 )
    Return -3
  Endif


; Remove double double quoting ("") and replace it a single double quote (")
;
; then Trim surrounding "-characters, if present

  for $Counter = 1 to $aArray[0]

    $aArray[$Counter]=StringReplace($aArray[$Counter], '""', '"')

    if StringLeft($aArray[$Counter],1)='"' and StringRight($aArray[$Counter],1)='"' then
	$aArray[$Counter]=StringMid($aArray[$Counter],2,StringLen($aArray[$Counter])-2)
    endif
  next


  Return $aArray[0] 
EndFunc



;===============================================================================
Func ReadHeader($ColumnArray)

; This function is used by ReadPatchList()
;
; It reads the position of each column according to their description in the header

 Local $ColumnNumber	; Counter for current column number
 Local $ColumnCheck	; To check if we have the complete set of columns
 Local $ColumnName	; Name of column

 $ColumnCheck=0		; No columns checked yet
 $ColumnNumber=1		; We start at the first column

 While $ColumnNumber <= $ColumnArray[0]

   $ColumnName = stringlower($ColumnArray[$ColumnNumber])

   ShowDebugMessage ("Column name: " & $ColumnName)

   select 

	Case $ColumnName="q-number"
		$c_QNumber=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="patchnumber"
		$c_PatchNumber=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	; Added 13/Jun/2005
	Case $ColumnName="date"
		$c_Date=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="description"
		$c_Description=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="commandline"
		$c_Commandline=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="remarks"
		$c_Remarks=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="win95"
		$c_Win95=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="win98"
		$c_Win98=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="winme"
		$c_WinMe=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="winnt4sp1-5"
		$c_winnt4sp1to5=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="winnt4sp6"
		$c_winnt4sp6=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="win2000sp1-2"
		$c_win2Ksp1to2=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="win2000sp3-4"
		$c_win2ksp3to4=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="winxp"
		$c_WinXP=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="winxpsp1"
		$c_WinXPsp1=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="winxpsp2"
		$c_WinXPsp2=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="win2003"
		$c_Win2003=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="Win2003SP1"
		$c_Win2003SP1=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="installedcriteria"
		$c_InstalledCrit=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1
	Case $ColumnName="requiredcriteria"
		$c_RequiredCrit=$ColumnNumber
		$ColumnCheck=$ColumnCheck + 1

	Case Else	; invalid column header
		$ColumnCheck=0
		ExitLoop
   endselect

   $ColumnNumber = $ColumnNumber + 1

 wend

 ShowDebugMessage ("ReadHeader: $ColumnCheck:"& $ColumnCheck & " $c_description: " & $c_Description & _
		" $c_winxp: " & $c_winxp & "$c_installedcrit: " & $c_installedcrit & _
		" $c_requiredcrit: " & $c_requiredcrit)

 Return $ColumnCheck

Endfunc


;===============================================================================
; Custom error dialog box with timeout

Func ShowError($Message, $Timeout)

 if $ShowErrors = 1 then 
	if $Timeout > 0 then
		MsgBox(0,"MSPatch", $Message, $Timeout)
	else
		MsgBox(0,"MSPatch", $Message)
	endif
 endif

endfunc

;===============================================================================
; Shows debugging information using NOTEPAD.EXE
Func ShowDebugMessage($Text)

if $PatchDebug = 1 then

  ; If notepad is not already open, then run notepad
  if not WinExists ("Untitled - Notepad") then ; NOTE: This works only on ENGLISH operating systems !!

	Run("notepad.exe")

	; Wait for the Notepad become active - it is titled "Untitled - Notepad" on English systems
	Sleep(1000)	; Give it some time to start.

	if not WinActive("Untitled - Notepad") then
		if not WinWaitActive("Untitled - Notepad",8) then return  ; Could not open notepad
	endif
  endif

  WinActivate("Untitled - Notepad")			; Activate the notepad window.

  if not WinActive("Untitled - Notepad") then return  	; Could not open notepad

  Send($Text)						; Send our debug text
  Send("{ENTER}")					; Next line
endif

Endfunc

;===============================================================================
; <pete> http://www.autoitscript.com/forum/index.php?s=e3fef722b1da310e854018204d48929e&amp;showtopic=13448&view=findpost&p=91626
; FunctionName:     _StringCompareVersions()
; Description:      Compare 2 strings of the FileGetVersion format [a.b.c.d].
; Syntax:           _StringCompareVersions( $s_Version1, [$s_Version2] )
; Parameter(s):     $s_Version1          - The string being compared
;                   $s_Version2          - The string to compare against
;                                          [Optional] : Default = 0.0.0.0
; Requirement(s):   None
; Return Value(s):  0 - Strings are the same (if @error=0)
;                  -1 - First string is (<) older than second string
;                   1 - First string is (>) newer than second string
;                   0 and @error<>0 - String(s) are of incorrect format:
;                         @error 1 = 1st string; 2 = 2nd string; 3 = both strings.
; Author(s):        PeteW
; Note(s):          Comparison checks that both strings contain numeric (decimal) data.
;                   Supplied strings are contracted or expanded (with 0s)
;                     MostSignificant_Major.MostSignificant_minor.LeastSignificant_major.LeastSignificant_Minor
;
;===============================================================================

Func _StringCompareVersions($s_Version1, $s_Version2 = "0.0.0.0")
    
; Confirm strings are of correct basic format. Set @error to 1,2 or 3 if not.
    SetError((StringIsDigit(StringReplace($s_Version1, ".", ""))=0) + 2 * (StringIsDigit(StringReplace($s_Version2, ".", ""))=0))
    If @error>0 Then Return 0; Ought to Return something!

    Local $i_Index, $i_Result, $ai_Version1, $ai_Version2

; Split into arrays by the "." separator
    $ai_Version1 = StringSplit($s_Version1, ".")
    $ai_Version2 = StringSplit($s_Version2, ".")
    $i_Result = 0; Assume strings are equal
    
; Ensure strings are of the same (correct) format:
;  Short strings are padded with 0s. Extraneous components of long strings are ignored. Values are Int.
    If $ai_Version1[0] <> 4 Then ReDim $ai_Version1[5]
    For $i_Index = 1 To 4
        $ai_Version1[$i_Index] = Int($ai_Version1[$i_Index])
    Next

    If $ai_Version2[0] <> 4 Then ReDim $ai_Version2[5]
    For $i_Index = 1 To 4
        $ai_Version2[$i_Index] = Int($ai_Version2[$i_Index])
    Next

    For $i_Index = 1 To 4
        If $ai_Version1[$i_Index] < $ai_Version2[$i_Index] Then; Version1 older than Version2
            $i_Result = -1
        ElseIf $ai_Version1[$i_Index] > $ai_Version2[$i_Index] Then; Version1 newer than Version2
            $i_Result = 1
        EndIf
   ; Bail-out if they're not equal
        If $i_Result <> 0 Then ExitLoop
    Next

    Return $i_Result

EndFunc ;==>_StringCompareVersions

;===============================================================================
; <pete> Ref: http://www.autoitscript.com/forum/index.php?showtopic=7719&view=findpost&p=92796
; Simplify (& shorten) the Criteria - uses my _StringCompareVersions() UDF
Func _OldFileVerExists($s_Filename, $s_Version)
;   We usually install an update only if the current file: (a) exists and (b) is older than the version you're installing.
    If (FileGetVersion($s_Filename) <> "0.0.0.0") And (_StringCompareVersions(FileGetVersion($s_Filename), $s_Version) = -1) Then
        Return 1
    Else
        Return 0
    EndIf
    
EndFunc  ;==>_OldFileVerExists

