#include "Dbug.au3"
Global $CurrentLink
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 615, 438, 192, 124)
$Label1 = GUICtrlCreateLabel("Label1", 144, 48, 84, 17)
$Radio1 = GUICtrlCreateRadio("Local", 320, 40, 97, 25)
$Radio2 = GUICtrlCreateRadio("Server", 312, 88, 105, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

dim $file
dim $line
dim $Ans
$file = FileOpen("C:\mydata.txt", 0)

; Check if file opened for reading OK
;If $file = -1 Then
;    MsgBox(0, "Error", "Unable to open file.")
;    Exit
;EndIf
;While 1
;    $line = FileReadLine($file)
;    If @error = -1 Then ExitLoop
;	$Ans =StringInStr($line,"C:\dbaseform")
;	if $Ans = 0 Then ;not fould, must be set to the remote server
;		$CurrentLink = "server"
;		GUICtrlSetData($Label1,"Remote Server")
;	Else
;		GUICtrlSetData($Label1,"Local")
;	EndIf

   ; MsgBox(0, "Line read:", $line)
;Wend
;FileClose($file)
dim $nMsg
Dim $LinkChanged
$LinkChanged = False

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		 Case $nmsg = $radio1
			$CurrentLink = "server"
			$LinkChanged = True
		 Case $nmsg = $radio2
			$CurrentLink = "local"
			$LinkChanged = True
	EndSwitch
	if $LinkChanged = true Then

		ChangeLink($CurrentLink)

		$LinkChanged = False
	EndIf

WEnd
Func ChangeLink($mystring)
	if $mystring = "local" Then

		$Ans = FileCopy("C:\mydatalocal.txt","C:\mydata.txt",1)
		if $Ans = 0 Then ;failure
			MsgBox(0,"ERROR","Unable to Write to Mydata.txt")
		EndIf
	Else
		FileCopy("C:\mydataserver.txt","C:\mydata.txt",1)
		if $Ans = 0 Then ;failure
			MsgBox(0,"ERROR","Unable to Write to Mydata.txt")
		EndIf
	EndIf

EndFunc