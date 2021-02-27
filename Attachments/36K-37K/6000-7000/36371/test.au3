HotKeySet("{ESC}" , "quit")
Func quit()
    Exit 1
EndFunc

HotKeySet("{F1}" , "left")
Func left()
    MouseClick("left", $Inp1)
EndFunc


#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\owner\Desktop\Backup\AutoIt\Koda\Forms\test.kxf
$Example = GUICreate("Example", 281, 52, 207, 139)
$Button1 = GUICtrlCreateButton("Record", 160, 8, 105, 33)
$Input1 = GUICtrlCreateInput("Input1", 24, 16, 129, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$Inp1 = GUICtrlRead($Input1)

While 1
	Global $cd = 2		;CountDown Time
	
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
				Do	
					GUICtrlSetData( $Button1, $cd & "..")
					$cd = $cd-1
					sleep(1000)
				Until $cd = 0
					GUICtrlSetData( $Button1, "Record")

			$pos = MouseGetPos()
			GUICtrlSetData( $Input1, $pos[0] & ", " & $pos[1])

	EndSwitch
WEnd








