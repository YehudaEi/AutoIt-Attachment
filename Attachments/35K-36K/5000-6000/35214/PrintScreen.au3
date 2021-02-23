
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <File.Au3>
#include <String.Au3>

Global $image_no = 1; the number system (done properly), is a logic problem. One that currently defies my understanding.

HotKeySet("{PRINTSCREEN}", "go")

If Not DirCreate(@MyDocumentsDir & "\PS_pic" & @MON & @MDAY & @YEAR) Then
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE


			Exit
	EndSwitch
WEnd

Func go()
	_ScreenCapture_Capture(@MyDocumentsDir & "\PS_pic" & @MON & @MDAY & @YEAR & "\" & $image_no & ".jpg")
	$image_no += 1
	If StringLen($image_no) = 1 Then; the rest of func go is the work of others. 'screen capture marquee2'
		$image_no = "0000" & $image_no
	ElseIf StringLen($image_no) = 2 Then
		$image_no = "000" & $image_no
	ElseIf StringLen($image_no) = 3 Then
		$image_no = "00" & $image_no
	ElseIf StringLen($image_no) = 4 Then
		$image_no = "0" & $image_no
	EndIf
	Sleep(500)

EndFunc   ;==>go