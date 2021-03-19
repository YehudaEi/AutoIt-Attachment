#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>

#region ### START Koda GUI section ### Form=C:\Users\PANKAJMI\Desktop\IS\AutoIT - Pankaj\Koda Files\PortnoxDeadlock.kxf
$PortnoxDeadlock = GUICreate("PortnoxDeadlock", 271, 173, 1533, 184)
$Revalidation = GUICtrlCreateLabel("Last Revalidation Check", 16, 32, 120, 17)
$Check1 = GUICtrlCreateButton("Check", 144, 24, 105, 25)
$Label1 = GUICtrlCreateLabel("Wrapper Check", 16, 80, 79, 17)
$Check2 = GUICtrlCreateButton("Check", 144, 72, 105, 25)
$Label2 = GUICtrlCreateLabel("Process Explorer", 16, 128, 83, 17)
$Open = GUICtrlCreateButton("Open", 144, 120, 107, 25)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $Check1
			DriveMapAdd("N:", "\\Server\Sharefolder", 0, "Domain\UserName", "password")

			$file = FileOpen("N:\Test.log", 0)

			; Check if file opened for reading OK
			If $file = -1 Then
				MsgBox(0, "Error", "Unable to open file.")
				Exit
			EndIf

			$last_line = FileReadLine($file, -1)
			MsgBox(0, "Last Revalidation Done", $last_line)

			DriveMapDel("N:")

		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
WEnd
