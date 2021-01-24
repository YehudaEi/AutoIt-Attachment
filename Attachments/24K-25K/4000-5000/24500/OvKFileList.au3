#cs
Function Name: FileList
Author: Overkill
Date: February 9, 2009
Version: RC 1.0.1

Syntax:
FileList("directory" [, subdirectories [,"filetype"]])

Params:
directory: The directory to search
subdirs: 0 = Exclude subdirectories (default), 1 = Include subdirectories
filetype: The type of file to search for. Default is * (all files).
#ce
$FileList = FileList("C:\MusicB\Music Compilations\CarTunes",1,"mp3")

Func FileList($dir,$subdirs=0,$filetype="*")
ConsoleWrite("FileList called" & @CRLF)
	Local $F = @TempDir&'\DirListFile.TMP'	; Define temp file locally

; ==> Verify $dir & $subdirs <==
$DLERROR1 = FileExists($dir)
If $DLERROR1 = 0 Then 
	SetError(1,Default,"")
	MsgBox(16,"ERROR","Directory " & $dir & " does not exist.")
	Exit
EndIf

If $subdirs = 0 Then
	$R1 = RunWait(@ComSpec & " /c " & 'DIR "' & $dir &"\*."& $filetype & '" /B > ' & $F, "", @SW_HIDE)		; Dump DIR result to temp file, no subdirectories
ElseIf $subdirs = 1 Then
	$R1 = RunWait(@ComSpec & " /c " & 'DIR "' & $dir &"\*."& $filetype & '" /B /S > ' & $F, "", @SW_HIDE)	; Dump DIR result to temp file, with subdirectores
Else
	MsgBox(16,"ERROR",$subdirs & " is not a valid value. Please use either 0 or 1.")
	Exit
EndIf

ConsoleWrite("FileList: R1 = " & $R1 & @CRLF)

Dim $FileRead[1]
$FileRead[0] = 0
	
Local $i=1
$Z = FileOpen($F,0)
IF $Z = -1 Then
	MsgBox(0,"ERROR","Unable to open file: " & $F)
	Exit
EndIf
While 1
$X=FileReadLine($Z)
If @ERROR = -1 Then ExitLoop
	If $X="" Then
		Do 
		$X=FileReadLine($Z)
		Until $X<>""
	EndIf
ReDim $FileRead[$FileRead[0]+2]
$FileRead[$FileRead[0]+1] = $X
$FileRead[0]=$FileRead[0] + 1
WEnd
FileClose($F)
Return $FileRead
EndFunc