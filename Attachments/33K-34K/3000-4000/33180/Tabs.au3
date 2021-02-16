#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GuiConstantsEx.au3>
#include <GuiTab.au3>
;"Tab Test"
;"[CLASS:SSTabCtlWndClass; INSTANCE:1]"
$hndl = ControlGetHandle ("Tab Test Form", "", "[CLASS:SSTabCtlWndClass; INSTANCE:1]" )



$uRet = _GUICtrlTab_GetItemCount($hndl)
msgbox(0,"Number of Tabs",$uRet)
