#include "wrapper.au3"
wrap("te#1st","testinglol","dyns","30","s","127.0.0.1",5657)
$g = GUICreate("lol",500,500)
$e = GUICtrlCreateEdit("",0,0,500,500)
guisetstate()
;~ reggui($g)
while 1
	GUICtrlSetData($e,$regged)
	sleep(250)
WEnd