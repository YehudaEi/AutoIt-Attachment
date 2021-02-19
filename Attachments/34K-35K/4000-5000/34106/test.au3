#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt("Mustdeclarevars", 1) 

Global $Gui1
Global $Gui1Button1
Global $Gui2
Global $Gui2Button1
Local $msg

Main()
Func Main()
$Gui1=GUICreate("a test window", 600, 450, 150, 150, -1, -1)
GUISetState(@SW_SHOW, $Gui1)
$Gui1Button1=GUICtrlCreateButton("Utils", 10, 10, 50, 20)
While 1
	$msg=GUIGetMsg()
Select 
case $msg=$Gui1Button1
	Win7Utils()
EndSelect
If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd
GUIDelete($Gui1)
EndFunc

Func Win7Utils()
$Gui2=GUICreate( "Windows 7 Utilities", 600, 450, 150, 150, -1, -1)
GUISetState(@SW_SHOW, $Gui2)
$Gui2Button1=GUICtrlCreateButton("sweeper", 10, 10, 50, 20)
While 1
	$msg=GUIGetMsg()
	Select
	Case $msg=$Gui2Button1
		Local $filedir
		Local $filearray
		$filedir=FileFindFirstFile(@TempDir & "\*.*")
		FileDelete($filedir)
		Do
		$filearray=FileFindNextFile($filedir)
		FileDelete($filearray)
		Until @error
		MsgBox(1, "Success", "sweep success")
EndSelect
 If $msg = $GUI_EVENT_CLOSE Then ExitLoop
 WEnd	
 GUIDelete($Gui2)
 Main()
EndFunc