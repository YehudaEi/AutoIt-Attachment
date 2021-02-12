#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=repeat.ico
#AutoIt3Wrapper_outfile=..\..\Programming Tools\StringRepeater.exe
#AutoIt3Wrapper_Res_Description=String Repeater
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=(C)2010 Eric Walters
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt('MustDeclareVars', 0)
Opt('SendKeyDelay',1)

Global $me
Global $hndlist[50]
Global $the_window
Global $the_string
Global $the_count

Global $list
Global $startvalues[11]
Global $incvalues[11]
Global $currentvalues[11]
Global $stop

GetString()

Func GetString()
	#Region ### START Koda GUI section ### Form=
	$me = GUICreate("StringRepeater v0.1", 586, 424, 205, 158)
	$grpProgInfo = GUICtrlCreateGroup("Program Information", 8, 8, 241, 248)
	$InfoLabel = GUICtrlCreateLabel("Program info", 19, 25, 218, 218)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$listbox = GUICtrlCreateList("", 256, 30, 321, 201, BitOR($LBS_SORT,$LBS_STANDARD,$WS_HSCROLL,$WS_VSCROLL,$WS_BORDER))
	GUICtrlSetData(-1, "")
	$stringbox = GUICtrlCreateEdit("", 8, 280, 569, 100)
	GUICtrlSetData(-1, "")
	$Label1 = GUICtrlCreateLabel("Enter the string below to repeat:", 10, 263, 154, 17)
	$Label2 = GUICtrlCreateLabel("Repetitions:", 16, 392, 60, 17)
	$countbox = GUICtrlCreateInput("0", 80, 387, 74, 21)
	$Updown1 = GUICtrlCreateUpdown($countbox)
	$DemoButton = GUICtrlCreateButton("Run Demo", 244, 389, 97, 25, $WS_GROUP)
	$IdentifyButton = GUICtrlCreateButton("Identify", 380, 232, 97, 25, $WS_GROUP)
	$ReloadButton = GUICtrlCreateButton("Reload", 480, 232, 97, 25, $WS_GROUP)
	$Label3 = GUICtrlCreateLabel("Select the window to insert text:", 259, 13, 154, 17)
	$CancelButton = GUICtrlCreateButton("Cancel", 424, 389, 73, 25, $WS_GROUP)
	$OKButton = GUICtrlCreateButton("Next", 504, 389, 73, 25, $WS_GROUP)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	GetWinList($listbox)
	GUICtrlSetData($InfoLabel,"This script will type out a string a specified number of times. It can insert an incrementing or decrementing number into placeholders, and also press keys on your keyboard for you." & CHR(13) & CHR(13) & "Prefix two digit placeholders with $ and enclose key presses in curly braces" & CHR(13) & "Example: Test$01{TAB}={TAB}$02{ENTER}" & CHR(13) & CHR(13) & "The program will type exactly what you enter below. Search Google for 'autoit send' for a full list of keys you can insert." & CHR(13) & CHR(13) & "IMPORTANT: If something goes wrong, hit ESCAPE to stop the loop.")
	GUISetState(@SW_SHOW) ; will display an empty dialog box

	While 1
		$msg = GUIGetMsg()

		IF $msg = $OKButton Then
			IF StringLen(GUICtrlRead($listbox)) AND StringLen(GUICtrlREad($stringbox)) Then
				$the_window = WinGetHandle(GUICtrlRead($listbox))
				$the_string = GUICtrlRead($stringbox)
				$the_string = StringReplace($the_string,CHR(13) & CHR(10),CHR(13))
				$the_count = GUICtrlRead($countbox)

				If StringInStr($the_string,"$") Then GetMoreInfo($the_string)

				HotKeySet("{ESC}","StopLoop")
				If Not $stop Then
					For $i = 1 to 10
						$currentvalues[$i] = $startvalues[$i]
					Next

					WinActivate($the_window)

					For $i = 1 to $the_count
						If $stop Then ExitLoop
						$temp = $the_string

						For $j = 1 to 10
							If $startvalues[$j] <> 0 Then
								$temp = StringReplace($temp,"$" & StringFormat("%02u",$j),$currentvalues[$j])
							EndIf
						Next

						Send($temp)

						For $j = 1 to 10
							If $startvalues[$j] <> 0 Then
								$currentvalues[$j] = $currentvalues[$j] + $incvalues[$j]
							EndIf
						Next

					Next
				EndIf
				HotKeySet("{ESC}")

				WinActivate($me)
			Else
				MsgBox(0x30,"Error","You must enter a string to repeat and select a window to send the string to.")
			EndIf
		EndIf

		IF $msg = $DemoButton Then
			MsgBox(0,"Demo","First lets open Notepad so we can send text to it.")
			Sleep(1000)
			Run("notepad.exe")
			WinActivate($me)
			Sleep(1000)
			MsgBox(0,"Demo","We'll hit the Reload button to update the list of available windows. This is only necessary if the window you're trying to send to was opened after running this program.")
			Sleep(1000)
			GetWinList($listbox)
			Sleep(1000)
			MsgBox(0,"Demo","Let's select 'Untitled - Notepad' as the destination window.")
			Sleep(1000)
			GUICtrlSetData($listbox,"")
			GUICtrlSetData($listbox,$list,"Untitled - Notepad")
			Sleep(1000)
			MsgBox(0,"Demo","Now we'll put some text in the input box to be sent.")
			Sleep(1000)
			GUICtrlSetData($stringbox,"Variable[$01]{TAB}={TAB}$02{ENTER}")
			Sleep(1000)
			MsgBox(0,"Demo","The numbers prefixed with $ will be replaced with actual numbers and the keys in curly brackets will be sent as if you pressed those buttons." & CHR(13) & "The most important part is how many times to repeat the string. We'll set that in the bottom box.")
			Sleep(1000)
			GUICtrlSetData($countbox,"10")
			Sleep(1000)
			MsgBox(0,"Demo","That's pretty much it. After hitting OK, hit Next on the main window. It will ask you what number to start each variable with and what to add to it each time it repeats. After giving it this information, it will automatically enter the text in Notepad. Enjoy!")
		EndIf

		IF $msg = $ReloadButton Then
			GetWinList($listbox)
		EndIf

		IF $msg = $IdentifyButton AND StringLen(GUICtrlRead($listbox)) Then
			$the_window = WinGetHandle(GUICtrlRead($listbox))
			WinActivate($the_window)
			Sleep(1000)
			WinActivate($me)
		EndIf

		If $msg = $GUI_EVENT_CLOSE OR $msg = $CancelButton Then ExitLoop
	WEnd
	GUIDelete()
EndFunc

Func GetMoreInfo($string)
	$stop = False
	For $i = 1 to 10
		If StringInStr($string,"$" & StringFormat("%02u",$i)) Then
			$startvalues[$i] = Int(InputBox("Starting Value","Enter starting value for $" & StringFormat("%02u",$i)))
			$incvalues[$i] = Int(InputBox("Increment Value","Enter increment value for $" & StringFormat("%02u",$i)))
			If $incvalues[$i] = 0 Then
				$stop = True
				ExitLoop
			EndIf
		EndIf
	Next
EndFunc

Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then
    Return 1
  Else
    Return 0
  EndIf
EndFunc

Func GetWinList($handle)
	Local $j
	$j = -1

	$winlist = WinList()
	$list = ""

	For $i = 0 to 49
		$hndlist[$i] = 0
	Next

	For $i = 1 to $winlist[0][0]
		IF $winlist[$i][0] <> "" AND IsVisible($winlist[$i][1]) AND $winlist[$i][1] <> $me AND $winlist[$i][0] <> "Start" AND $winlist[$i][0] <> "Program Manager" Then
			$j = $j + 1
			IF StringLen($list) Then $list = $list & "|"
			$list = $list & $winlist[$i][0]
			$hndlist[$j] = $winlist[$i][1]
		EndIf
	Next
	GUICtrlSetData($handle,"")
	GUICtrlSetData($handle,$list)
	_GUICtrlListBox_UpdateHScroll($handle)
EndFunc

Func StopLoop()
	$stop = True
EndFunc