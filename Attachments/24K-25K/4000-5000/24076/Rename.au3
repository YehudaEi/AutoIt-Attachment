#include <GuiconstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <Array.au3>
global $source
local $gui = guicreate("Rename",200,60)
$button = guictrlcreatebutton("Click Me",50,5,100,50)
guisetstate()


Do

$msg = guigetmsg()

switch $msg

	Case $button
		$var = FileOpenDialog("Please Select a file",@WorkingDir,"All Files (*.*)",1 + 4)
		
		If @error Then
    MsgBox(4096,"","No File(s) chosen")
Else
	
    ;$var = StringReplace($var, "\", @CRLF)
	$Arr = StringSplit($var,"\")
	
	$total = $Arr[0]
	
	$sp = Stringsplit($Arr[$total],".")
	_arraydisplay($arr,"hmm")
	$ext = $sp[2]
	$f_name = $sp[1]
	
    MsgBox(4096,"","You chose " & $f_name & " With an Extention of " & $ext)
	
	$input = InputBox("File Rename","Please Rename your file, Including an extenstion is optional")
	
	$spl = StringSplit($input,".")
	
	If @Error then
	ExitLoop

	Else
	for $i = 1 to $Arr[0] - 1
		$source = $source & $Arr[$i] & "\"
		;MsgBox(0,"hmm",$source)
	next
	MsgBox(0,"hmm",$source & $Arr[$Arr[0]] & @crlf & $source & $spl[1] & "." & $spl[2])
	Filecopy($source & $Arr[$Arr[0]],$source & $spl[1] & "." & $spl[2])
	endIF

EndIf

	
EndSwitch

until $msg = $GUI_EVENT_CLOSE