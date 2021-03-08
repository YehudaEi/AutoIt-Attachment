#include <array.au3>
#include <file.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <UDFb64.au3>

Global $timer, $previousbreak = ''
#NoTrayIcon
$GUI = GUICreate("Base64 Conversions", 700, 295, -1, -1)
$text = GUICtrlCreateEdit("", 16, 40, 662, 137, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL, $WS_BORDER))
GUICtrlSetFont(-1, 10, 200, 0, "Lucida Console")
GUICtrlSetColor(-1, 0x000000)
$Label1 = GUICtrlCreateLabel("Convert text", 16, 15, 150, 18)
GUICtrlSetFont(-1, 12, 800, 0, "Lucida Console")
GUICtrlSetColor(-1, 0x000000)
$plain2 = GUICtrlCreateButton("Encode Input", 226, 210, 107, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$base2 = GUICtrlCreateButton("Decode Input", 341, 210, 107, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$Label9 = GUICtrlCreateLabel("---------------------------------------------------------------------------------------------------------------------------------", 16, 235, 662, 15)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$convertp = GUICtrlCreateButton("Encode File", 218, 260, 115, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$convertb = GUICtrlCreateButton("Decode File", 342, 260, 115, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$ANSI = GUICtrlCreateRadio("ANSI", 250, 185, 73, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Lucida Console")
GUICtrlSetColor(-1, 0x000000)
$UTF8 = GUICtrlCreateRadio("UTF-8", 360, 185, 73, 17)
GUICtrlSetFont(-1, 10, 400, 0, "Lucida Console")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_CHECKED)
$LineBlabel = GUICtrlCreateLabel("Line Break 0-76", 25, 185, 131, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$LineBreakNum = GUICtrlCreateInput("64", 65, 210, 41, 24, BitOR($ES_CENTER, $ES_NUMBER, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
GUICtrlSetLimit(-1, 2)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$Clipcopy = GUICtrlCreateButton("Copy text", 165, 8, 80, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$Clippaste = GUICtrlCreateButton("Paste text", 255, 8, 80, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
$Cleartext = GUICtrlCreateButton("- Delete text -", 345, 8, 100, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Clipcopy
			ClipPut(GUICtrlRead($text))
		Case $Clippaste
			GUICtrlSetData($text, ClipGet())
		Case $Cleartext
			GUICtrlSetData($text, '')
		Case $plain2
			If GUICtrlRead($text) <> '' Then
				$encmode = 0
				If GUICtrlRead($UTF8) = $GUI_CHECKED Then $encmode = 1
				GUICtrlSetData($text, B64Encode(GUICtrlRead($text), $encmode, GUICtrlRead($LineBreakNum)))
			EndIf
		Case $base2
			If GUICtrlRead($text) <> '' Then
				$encmode = 0
				If GUICtrlRead($UTF8) = $GUI_CHECKED Then $encmode = 1
				GUICtrlSetData($text, B64Decode(GUICtrlRead($text), $encmode))
			EndIf
		Case $convertp
			$filelocation = FileOpenDialog('Choose file', @UserProfileDir, 'All Files (*.*)', 1)
			If $filelocation <> '' Then
				Local $szDrive, $szDir, $szFName, $szExt, $encoded, $result = ''
				_PathSplit($filelocation, $szDrive, $szDir, $szFName, $szExt)
				$savelocation = FileSaveDialog('Save as', @UserProfileDir, 'All Files (*.*)', 16, $szFName & '(Encoded)' & $szExt)
				If @error Then ContinueCase
				$encmode = 0
				If GUICtrlRead($UTF8) = $GUI_CHECKED Then $encmode = 1
				$encoded = B64Encode($filelocation, $encmode, GUICtrlRead($LineBreakNum), 1)
				$savefile = FileOpen($savelocation, 18)
				FileWrite($savefile, $encoded)
				FileClose($savefile)
				MsgBox(0, 'Completed', 'Process has completed')
			EndIf
		Case $convertb
			$filelocation = FileOpenDialog('Choose file', @UserProfileDir, 'All Files (*.*)', 1)
			If $filelocation <> '' Then
				Local $szDrive, $szDir, $szFName, $szExt
				_PathSplit($filelocation, $szDrive, $szDir, $szFName, $szExt)
				$savelocation = FileSaveDialog('Save as', @UserProfileDir, 'All Files (*.*)', 16, StringReplace($szFName, '(Encoded)', '', -1) & '(Decoded)' & $szExt)
				If @error Then ContinueCase
				$encmode = 0
				If GUICtrlRead($UTF8) = $GUI_CHECKED Then $encmode = 1
				$encoded = B64Decode($filelocation, $encmode, 1)
				$savefile = FileOpen($savelocation, 18)
				FileWrite($savefile, $encoded)
				FileClose($savefile)
				MsgBox(0, 'Completed', 'Process has completed')
			EndIf
		Case Else
			If GUICtrlRead($LineBreakNum) <> $previousbreak Then
				Local $value = GUICtrlRead($LineBreakNum)
				If $value > 76 Then
					Beep(1200, 150)
					$linebreak = 76
					GUICtrlSetData($LineBreakNum, 76)
				EndIf
			EndIf
			$previousbreak = GUICtrlRead($LineBreakNum)
	EndSwitch
WEnd