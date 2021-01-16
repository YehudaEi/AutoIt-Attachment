#include <GUIConstants.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
;includes.  I wasn't sure which ones were required so I copied them from the original script.


; CREATE THE GUI
$GUI = GUICreate("_GUICtrlListView_SortItems causes hard crash", 800, 500)
$ListView = GUICtrlCreateListView("Item1|Item2|Item3|Item4|Item4|Item5|Item6|Item7", 0, 0, 800, 500)
GUISetState(@SW_SHOW)
$loop = 0 ;Set a loop variable to tell the script when to stop creating items
$d = "|" ; set a divider variable which kind of serves no real purpose other than saving one keypress big woop.

MsgBox(0, "Sort items crash", "Please wait until the list has finished being generated, after that, click a header to sort it.", 6)
;just some FYIs for you

_GUICtrlListView_RegisterSortCallBack($ListView)

Do
$chr0 = Chr(Random(33, 126))
$chr1 = Chr(Random(33, 126))
$chr2 = Chr(Random(33, 126))
$chr3 = Chr(Random(33, 126))
$chr4 = Chr(Random(33, 126))
$chr5 = Chr(Random(33, 126))
$chr6 = Chr(Random(33, 126))
;create random text for an entry

$text = $chr0 & $d & $chr1 & $d & $chr2 & $d & $chr3 & $d & $chr4 & $d & $chr5 & $d & $chr6 
;put it all into one var
GUICtrlCreateListViewItem($text, $ListView)
;create it
Sleep(10) ;allow some cooldown time
$loop = $loop + 1 ;add one to the loop (I hate FOR loops)
WinSetTitle("_GUICtrlListView_SortItems causes hard crash", "", "_GUICtrlListView_SortItems causes hard crash - Creating list: " & $loop & "/500")
;tell the user how many entries are left
Until $loop > 499

WinSetTitle("_GUICtrlListView_SortItems causes hard crash", "", "_GUICtrlListView_SortItems causes hard crash - Waiting for user input")
;more infoz

While 1
Switch GUIGetMsg() ;wait for input
	Case $GUI_EVENT_CLOSE
		Exit
	Case $ListView
		_GUICtrlListView_SortItems($ListView, GUICtrlGetState($ListView)) ;BOOM!
EndSwitch
WEnd