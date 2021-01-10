#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Include <Array.au3>
#Include <FileRegister.au3>

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.7 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
local $target 
local $here  
local $drive
Local $counter

$drive=DriveGetDrive ( "all" )
for $counter = 1 to $drive[0]
local $label =DriveGetLabel ( $drive[$counter] )
If $label = "Bernie's" Then
	local $target = $drive[$counter] & " "&$label
	local $here = $drive[$counter]
	ExitLoop
	EndIf
Next

_FileRegister ("knt", $here&"\KeyNote_Directory\keynote.exe", "Open with ProgramName", 1,"", "KeyNote file")
ShellExecute($here&"\KeyNote_Directory\keynote.exe",$here&"\My KeyNote files\bernie's notes.knt")

