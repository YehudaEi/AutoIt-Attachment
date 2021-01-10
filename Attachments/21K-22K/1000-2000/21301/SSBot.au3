#include <IE.au3>
#include <GUICONSTANTS.au3>

GUICreate("Search Google",300,145)
GUISetState()

$SearchBox = GUICtrlCreateInput("",0,100,300)
$logo = GUICtrlCreatePic(@DesktopDir & "\logo.gif",0,0,300,100)
$SearchButton = GUICtrlCreateButton("Google Search",0,120,150)
$SearchButton2 = GUICtrlCreateButton("Im Feeling Lucky",150,120,150)

Func Search1($SearchData)
ShellExecute ("iexplore.exe", "about:blank")
WinWait ("Blank Page")
$oIE = _IEAttach ("about:blank", "url")
_IELoadWait ($oIE)
_IENavigate ($oIE, "http://www.google.co.uk/search?hl=en&q=" & $SearchData &"&meta=")
EndFunc

Func Search2($SearchData)
ShellExecute ("iexplore.exe", "about:blank")
WinWait ("Blank Page")
$oIE = _IEAttach ("about:blank", "url")
_IELoadWait ($oIE)
_IENavigate ($oIE, "www.google.com")
$oForm = _IEFormGetObjByName($oIE,"f")
$oSearch = _IEFormElementGetObjByName($oForm,"q")
_IEFormElementSetValue($oSearch,$SearchData)
$oSearchBut2 = _IEFormElementGetObjByName($oForm,"btnI")
_IEAction($oSearchBut2,"click")
EndFunc

While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	Case $msg = $SearchButton
		Search1(GUICtrlRead($SearchBox))
	Case $msg = $SearchButton2
		Search2(GUICtrlRead($SearchBox))
	EndSelect
WEnd