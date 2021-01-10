#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Quickie", 207, 132, 193, 125)
If FileExists(@SystemDir&"\Quikie.ini") Then
$program1 = GUICtrlCreateRadio(IniRead(@SystemDir&"\Quikie.ini","links","1",""), 16, 8, 97, 17)
$path1 = IniRead(@SystemDir&"\Quikie.ini","paths","1","")
$program2 = GUICtrlCreateRadio(IniRead(@SystemDir&"\Quikie.ini","links","2",""), 16, 32, 97, 17)
$path2 = IniRead(@SystemDir&"\Quikie.ini","paths","2","")
$program3 = GUICtrlCreateRadio(IniRead(@SystemDir&"\Quikie.ini","links","3",""), 16, 56, 97, 17)
$path3 = IniRead(@SystemDir&"\Quikie.ini","paths","3","")
$program4 = GUICtrlCreateRadio(IniRead(@SystemDir&"\Quikie.ini","links","4",""), 16, 80, 97, 17)
$path4 = IniRead(@SystemDir&"\Quikie.ini","paths","4","")
$program5 = GUICtrlCreateRadio(IniRead(@SystemDir&"\Quikie.ini","links","5",""), 16, 104, 97, 17)
$path5 = IniRead(@SystemDir&"\Quikie.ini","paths","5","")
$pathfire= IniRead(@SystemDir&"\Quikie.ini","firefox","1","")
$pathmediaPlay= IniRead(@SystemDir&"\Quikie.ini","mediaplayer","1","")
Else
$pathmediaPlay= ""
$pathfire=""
$program1 = GUICtrlCreateRadio("program1", 16, 8, 97, 17)
$program2 = GUICtrlCreateRadio("program 2", 16, 32, 97, 17)
$program3 = GUICtrlCreateRadio("program 3", 16, 56, 97, 17)
$program4 = GUICtrlCreateRadio("program 4", 16, 80, 97, 17)
$program5 = GUICtrlCreateRadio("program 5", 16, 104, 97, 17)
EndIf
$firefox = GUICtrlCreateButton("Firefox", 128, 8, 73, 17, 0)
$mediaPlay = GUICtrlCreateButton("Media Player", 128, 32, 73, 17, 0)
$launch = GUICtrlCreateButton("Launch", 120, 104, 57, 17, 0)
$change = GUICtrlCreateButton("Change", 120, 80, 57, 17, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $change
			$path=InputBox("Change","Type in the path of the program like C:\Dokumente und Einstellungen\User\Desktop\Quikie.exe")
			$name=InputBox("Change","Type in the name for the Quikie like ICQ")
			If $program1 And BitAND(GUICtrlRead($program1), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetData($program1,$name)
				IniWrite(@SystemDir&"\Quikie.ini","links","1",$name)
				IniWrite(@SystemDir&"\Quikie.ini","paths","1",$path)
				$path1 = IniRead(@SystemDir&"\Quikie.ini","paths","1","")
			EndIf	
			If $program2 And BitAND(GUICtrlRead($program2), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetData($program2,$name)
				IniWrite(@SystemDir&"\Quikie.ini","links","2",$name)
				IniWrite(@SystemDir&"\Quikie.ini","paths","2",$path)
				$path2= IniRead(@SystemDir&"\Quikie.ini","paths","2","")
			EndIf	
			If $program3 And BitAND(GUICtrlRead($program3), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetData($program3,$name)
				IniWrite(@SystemDir&"\Quikie.ini","links","3",$name)
				IniWrite(@SystemDir&"\Quikie.ini","paths","3",$path)
				$path3 = IniRead(@SystemDir&"\Quikie.ini","paths","3","")
			EndIf	
			If $program4 And BitAND(GUICtrlRead($program4), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetData($program4,$name)
				IniWrite(@SystemDir&"\Quikie.ini","links","4",$name)
				IniWrite(@SystemDir&"\Quikie.ini","paths","4",$path)
				$path4 = IniRead(@SystemDir&"\Quikie.ini","paths","4","")
			EndIf
			If $program5 And BitAND(GUICtrlRead($program5), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetData($program5,$name)
				IniWrite(@SystemDir&"\Quikie.ini","links","5",$name)
				IniWrite(@SystemDir&"\Quikie.ini","paths","5",$path)
				$path5 = IniRead(@SystemDir&"\Quikie.ini","paths","5","")
			EndIf	
		Case $firefox
			If $pathfire= "" Then
				$pathfire=InputBox("Firefox","Type in the path of Firefox")
				IniWrite(@SystemDir&"\Quikie.ini","firefox","1",$pathfire)
				Run($pathfire)
			Else
				Run($pathfire)
			EndIf	
		Case $mediaPlay
			If $pathmediaPlay= "" Then
				$pathmediaPlay=InputBox("MediaPlayer","Type in the path of Windows Media Player")
				IniWrite(@SystemDir&"\Quikie.ini","mediaplayer","1",$pathmediaPlay)
				Run($pathmediaPlay)
			Else
				Run($pathmediaPlay)
			EndIf		
		Case $Launch 
			If $program1 And BitAND(GUICtrlRead($program1), $GUI_CHECKED) = $GUI_CHECKED Then
				If FileExists($path1) Then
					Run($path1)
				Else
					ToolTip("Couldn´t run program")
					Sleep("3000")
					ToolTip("")
				EndIf
			EndIf	
			If $program2 And BitAND(GUICtrlRead($program2), $GUI_CHECKED) = $GUI_CHECKED Then
				If FileExists($path2) Then
					Run($path2)
				Else
					ToolTip("Couldn´t run program")
					Sleep("3000")
					ToolTip("")
				EndIf
			EndIf
			If $program3 And BitAND(GUICtrlRead($program3), $GUI_CHECKED) = $GUI_CHECKED Then
				If FileExists($path3) Then
					Run($path3)
				Else
					ToolTip("Couldn´t run program")
					Sleep("3000")
					ToolTip("")
				EndIf
			EndIf	
			If $program4 And BitAND(GUICtrlRead($program4), $GUI_CHECKED) = $GUI_CHECKED Then
				If FileExists($path4) Then
					Run($path4)
				Else
					ToolTip("Couldn´t run program")
					Sleep("3000")
					ToolTip("")
				EndIf
			EndIf	
			If $program5 And BitAND(GUICtrlRead($program5), $GUI_CHECKED) = $GUI_CHECKED Then
				If FileExists($path5) Then
					Run($path5)
				Else
					ToolTip("Couldn´t run program")
					Sleep("3000")
					ToolTip("")
				EndIf
			EndIf	
	EndSwitch
WEnd
