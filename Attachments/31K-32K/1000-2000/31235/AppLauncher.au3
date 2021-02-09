#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Local $ICON_ROOT = @WindowsDir & "\System32\Icons"
Local $ICON_PAD = 10	; Padding Between Icons
Local $ICON_X = 20		; Start Point For Icons X Position
Local $ICON_Y = 10		; Start Point For Icons Y Position
Local $LABEL_X = 10		; Start Point For Label X Position
Local $LABEL_Y = 45		; Start Point For Label Y Position

; Set our search to search for any file name.
$Search = FileFindFirstFile($ICON_ROOT & "\*.lnk")

;The array returned from this function is a single dimension array containing the following elements:
;$array[0] = Shortcut target path
;$array[1] = Working directory
;$array[2] = Arguments
;$array[3] = Description
;$array[4] = Icon filename
;$array[5] = Icon index
;$array[6] = The shortcut state (@SW_SHOWNORMAL, @SW_SHOWMINNOACTIVE, @SW_SHOWMAXIMIZED)

; Start a loop to loop through the Icons Folder.
While 1
	If $Search = -1 Then
		ExitLoop
	EndIf

	; Fill in our File variable and move on
	$File = FileFindNextFile($Search)

	; This really will never happen
	If @error Then ExitLoop

	; Set some variables to be used for file manipulation
	$FullFilePath = $ICON_ROOT & "\" & $File
	$FileAttributes = FileGetAttrib($FullFilePath)


	; Skip if we are looking at a Directory
	If Not StringInStr($FileAttributes,"D") Then
		; Let's Pull properties of it
		$Link=FileGetShortcut($FullFilePath)
		$LinkName = StringTrimRight( $File, 4)
	EndIf
WEnd

; GUI
GuiCreate("Application Launcher", 640, 480)
$icon = GUICtrlCreateIcon($Link[0], $Link[5], $ICON_X, $ICON_Y)
GuiCtrlCreateLabel($LinkName, $LABEL_X, $LABEL_Y, 100, 20)

; GUI MESSAGE LOOP
GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd
