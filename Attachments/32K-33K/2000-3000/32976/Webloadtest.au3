#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <GuiTab.au3>









	$AlertTabbed = GUICreate("Web Alert", 504, 374, 378, 583, BitOR($WS_MINIMIZEBOX, $WS_SYSMENU, $WS_CAPTION, $WS_CLIPCHILDREN, $WS_POPUP, $WS_POPUPWINDOW, $WS_GROUP, $WS_BORDER, $WS_CLIPSIBLINGS))
	;GUISetIcon("D:\005.ico")
	$PageControl1 = GUICtrlCreateTab(10, 10, 487, 315)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$TabSheet1 = GUICtrlCreateTabItem("Alert")

	$Alerttext = GUICtrlCreateInput("Alerttext", 32, 56, 441, 60)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")

	$ChangedTextLabel = GUICtrlCreateEdit("", 32, 120, 449, 193, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL, $WS_BORDER))

	GUICtrlSetData(-1, "ChangedText")
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")

	$TabSheet2 = GUICtrlCreateTabItem("Web Page")
	$oIE = _IECreateEmbedded()
	$GUIActiveX = GUICtrlCreateObj($oIE, 15, 25, @DesktopWidth - 350, @DesktopHeight - 350)

	$TabSheet3 = GUICtrlCreateTabItem("TabSheet3")
	GUICtrlCreateTabItem("")
	$TabButton1 = GUICtrlCreateButton("&OK", 12, 335, 93, 31, $WS_GROUP)
	$TabButton2 = GUICtrlCreateButton("&Cancel", 111, 335, 92, 31, $WS_GROUP)
	$TabButton3 = GUICtrlCreateButton("&Help", 404, 335, 92, 31, $WS_GROUP)
	$OpenInBrowser = GUICtrlCreateButton("Open In Browser", 212, 336, 108, 31, $WS_GROUP)
	GUICtrlSetBkColor(-1, 0xC0DCC0)

GUISetState(@SW_SHOW)


$TimerStart=TimerInit()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $TabButton1
			ExitLoop

	EndSelect

	If TimerDiff($TimerStart)>10000 Then
		_IENavigate($oIE,"http://online.wsj.com/home-page")
		$TimerStart=TimerInit()
	EndIf
WEnd


