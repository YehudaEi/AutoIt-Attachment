#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <Process.au3>

GUICreate("Check services",380, 400,-1,-1)
$ListView1 = GUICtrlCreateListView("Program|Status", 40, 30, 300, 300, $WS_EX_ACCEPTFILES)
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11.5, 200)
$hListView1 = GUICtrlGetHandle($ListView1)
$yahoo = GUICtrlCreateListViewItem("Yahoo", $ListView1)
$itunes = GUICtrlCreateListViewItem("Itunes", $ListView1)
$process_yahoo = "C:\Program Files\Yahoo!\Messenger\YahooMessenger.exe"
$process_itunes = "itunes.exe"

$start = GUICtrlCreateButton("Start", 40, 350, 100, 25)
$close = GUICtrlCreateButton("Close", 240, 350, 100, 25)


GUISetState()

While 1
	 $msg = GUIGetMsg() 
		Select
			Case $msg = $close 
				ExitLoop
	
			Case $start
				
				
		EndSelect

WEnd

