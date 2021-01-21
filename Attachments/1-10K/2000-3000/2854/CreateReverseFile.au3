; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Create a Reverse ordered file using unix command ported on Win32.
;                 This solution is derived from Sysadmin Magazine at the following
;				  address: http://www.samag.com/documents/s=9766/sam0506g/0506g.htm
;				  The unix utilities used in this example are downloadable from
;				  http://unxutils.sourceforge.net/
;
; Instruction:	  Download unix utilities from sourceforge.net and put nl.exe sort.exe
;				  and cut.exe in the same directory of the script
;				  Compile the script
;				  Run the script from command prompt: CreateReverseFile infile.txt outfile.txt
;				  Double click from windows explorer for file prompting
;				  Use -stdout as outfile name for displaying result on stdout
; ------------------------------------------------------------------------------


Dim $InFile, $OutFile, $Cmd

If $cmdline[0] = 0 Then
	$InFile = FileOpenDialog("Select a file to reverse", @ScriptDir, "Text files (*.txt)")
	If @error Then Exit
Else
	$InFile = $cmdline[1]
EndIf

If Not FileExists($InFile) Then Exit 1

If $cmdline[0] < 2 Then
	$OutFile = FileOpenDialog("Select an output file", @ScriptDir, "Text files (*.txt)", 8, "Reversed.txt")
	If @error Then Exit
Else
	$OutFile = $cmdline[2]
EndIf

FileChangeDir(@ScriptDir)

$cmd = "nl -ba " & $InFile & " | sort -nr | cut -f2-"
If StringUpper($OutFile) = "-STDOUT" Then
	Run(@ComSpec & " /k " & $cmd)
	Exit
Else
	$cmd = $cmd & " > " & $OutFile
	RunWait(@ComSpec & " /c " & $cmd, "", @SW_HIDE)
EndIf
Exit