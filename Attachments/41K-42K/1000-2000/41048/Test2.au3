#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>
#include <DateTimeConstants.au3>
#include <IE.au3>
#include <GUIConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <GuiStatusBar.au3>
#include <Date.au3>
#include <EditConstants.au3>
#include <Excel.au3>
#include <Date.au3>
#include <File.au3>

; Create GUI
$NFY_Gui = GUICreate("Critical Event Gui", 758, 513)

; Set background color
GUISetBkColor(0x000000)

; Create buttons
$Button_1 = GUICtrlCreateButton("Copy SysDat and GPData (C:\)", 10, 160, 220, 30, -1, -1)
$Button_2 = GUICtrlCreateButton("Copy from C Drive to Test A", 10, 200, 220, 30, -1, -1)
$Button_3 = GUICtrlCreateButton("Copy from C Drive to Test B", 10, 240, 220, 30, -1, -1)
$Button_4 = GUICtrlCreateButton("Sync Test A with B", 10, 280, 220, 30, -1, -1)
$Button_5 = GUICtrlCreateButton("Sync Test B with A", 10, 320, 220, 30, -1, -1)

; Set pictures


; Display GUI
GUISetState(@SW_SHOW, $NFY_Gui)

; Message loop
Local $msg
Do
   $msg = GUIGetMsg()

   Select
	Case $msg = $Button_1
			if stringupper(StringLeft("SysDat",6)) = "SysDat" Then
				CopyWithProgress("C:\Test\SYSDAT", "C:\Test\SYSDAT " & @Year & " - " & @Min)
				CopyWithProgress("C:\Test\GPData", "C:\Test\GPData " & @Year & " - " & @Min)
				Else
				MsgBox(4096, "Error", "Division by Zero")
			EndIf
		Case $msg = $Button_2
			CopyWithProgress("C:\Test\SysDat\", "\\networkdrive\c$\TEST\")
			;MoveWithProgress("\\networkdrive\c$\TEST\GPData\", "\\networkdrive\c$\TEST\GPData " & @Year & " - " & @Min)
			;MoveWithProgress("\\networkdrive\c$\TEST\SysDat\", "\\networkdrive\c$\TEST\SysDat " & @Year & " - " & @Min)


		Case $msg = $Button_3
			CopyWithProgress("C:\Test\SYSDAT", "C:\Test\SYSDAT 1988")
		Case $msg = $Button_4
			CopyWithProgress("C:\Test\SYSDAT", "C:\Test\SYSDAT 1989")
		Case $msg = $Button_5
			CopyWithProgress("C:\Test\SYSDAT", "C:\Test\SYSDAT 1990")

	EndSelect


Until $msg = $GUI_EVENT_CLOSE

;End Script

Func CopyWithProgress($sourceDirectory, $destinationDirectory)

	; Calculate initial sizes
	local $sourceSize = DirGetSize($sourceDirectory,1)
	local $destSize = DirGetSize($destinationDirectory,1)

	; Turn on progress bar
	ProgressOn("","Copying",$destSize & " of " & $sourceSize)

	; Begin directory copy
	DirCopy ($sourceDirectory, $destinationDirectory,1)

	; While destination is smaller than source
	While  $destSize < $sourceSize

		; Update destination size
		$destSize = DirGetSize($destinationDirectory,1)

		; Update progress bar
		$progress = ($destSize / $sourceSize) * 100
		ProgressSet($progress,$destSize & " of " & $sourceSize)

	WEnd

	; Display completion message
	ProgressSet(100,"Done!")

	; Wait half a second
	Sleep(500)

	; Turn off progress bar
	ProgressOff()

EndFunc

Func MoveWithProgress($sourceDirectory, $destinationDirectory)

	; Calculate initial sizes
	local $sourceSize = DirGetSize($sourceDirectory,1)
	local $destSize = DirGetSize($destinationDirectory,1)

	; Turn on progress bar
	ProgressOn("","Moving",$destSize & " of " & $sourceSize)

	; Begin directory move
	DirMove ($sourceDirectory, $destinationDirectory )

	; While destination is smaller than source
	While  $destSize < $sourceSize

		; Update destination size
		$destSize = DirGetSize($destinationDirectory,1)

		; Update progress bar
		$progress = ($destSize / $sourceSize) * 100
		ProgressSet($progress,$destSize & " of " & $sourceSize)

	WEnd

	; Display completion message
	ProgressSet(100,"Done!")

	; Wait half a second
	Sleep(500)

	; Turn off progress bar
	ProgressOff()

EndFunc


