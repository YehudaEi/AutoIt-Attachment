;===================================================================================
; Used to retrieve the microsoft patch installer engine
;		Requires the File Props.vbs script 
;===================================================================================
dim $OSdisplay, $EngineDisplay

;Select a Patch file to identify
$input = FileOpenDialog("MS-Patch to identify", @ScriptDir, "(*.exe)")
if @error then Exit

;Retrieve just the file name from the input string
$PatchName = StringRight($input, StringLen($input) - StringInStr($input, "\", 0, -1))

;The path for the temporary ini file used to store the informaion
$output = @TempDir & "\PatchFile.ini"

;Location of the File Props.vbs
$VBScript = FileGetShortName(@ScriptDir & "\File Props.vbs")

;Get the 8.3 directory structure of the selected patch
$App = FileGetShortName($input)

;Create the outputfile
$file = FileOpen($output, 2)
If $file = -1 Then
	MsgBox(0, "Error", "Unable to create output file")
    Exit
EndIf
FileClose($file)

;Get the 8.3 directory structure of the selected patch
$output = FileGetShortName($output)

;launch the VBScript with the proper switches and wait until done
$Return = RunWait(@ComSpec & " /C " & @SystemDir & "\wscript.exe " & $VBScript & " " & $App & " " & $output , @ScriptDir)

;Read the output file for any specific OS the patch applies to
$OSVersions = IniRead($output, "Patch", "AppliesTo", "")

;if there are specific OS's then that info will be displayed in the ending message box
if $OSVersions <> "" then
	$OSdisplay = "This patch should be applied to the following Operating System(s):" & @CRLF & $OSVersions & @CRLF & @CRLF
EndIf

;Read the output file for the Installer Engine type
;If a known engine is detected specify the proper switches in the ending message box
Switch IniRead($output, "Patch", "InstallerEngine", "")
	case "Update.exe"
		$EngineDisplay = "This patch uses the Update.exe Installer Engine:  " & @CRLF & _
			"Use the following silent install switches:  /passive /norestart"
	Case "msiexec.exe"
		$EngineDisplay = "This patch uses the msiexec.exe Installer Engine:  " & @CRLF & _
			"Use the following silent install switches:  /Q"
	Case Else
		$EngineDisplay = "Unknown Installer Engine"
EndSwitch

;Delete the temporary ini file
FileDelete($output)

;Display the information about the selected patch
MsgBox(0, $PatchName,  $OSdisplay & $EngineDisplay)