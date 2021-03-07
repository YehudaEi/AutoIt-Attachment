#include <Constants.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <GuiImageList.au3>
#include <GuiReBar.au3>
#include <GuiToolbar.au3>
#include <WindowsConstants.au3>

Global $hGui, $hGui2, $hReBar, $aStrings[5]
Global Enum $Hruntest = 1000, $Hconfig, $hDisplayCSV, $H_netmon, $H_graphdisplay

_Main()

Func _Main()

	$hGui = GUICreate("Rebar", 900, 396, 400, 200, BitOR($WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_MAXIMIZEBOX))

	$hImage = _GUIImageList_Create(18, 18, 5, 3)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 137)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 165)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 55)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 130)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 131)

	$hToolbar = _GUICtrlToolbar_Create($hGui, $TBSTYLE_FLAT + $TBSTYLE_LIST, $TBSTYLE_EX_DOUBLEBUFFER)
	$aStrings[0] = _GUICtrlToolbar_AddString($hToolbar, 'some long text')
	$aStrings[1] = _GUICtrlToolbar_AddString($hToolbar, 'Config')
	$aStrings[2] = _GUICtrlToolbar_AddString($hToolbar, 'CSV')
	$aStrings[3] = _GUICtrlToolbar_AddString($hToolbar, 'Display')
	$aStrings[4] = _GUICtrlToolbar_AddString($hToolbar, "Netmon")

	_GUICtrlToolbar_SetImageList($hToolbar, $hImage)
	_GUICtrlToolbar_AddButton($hToolbar, $Hruntest, 0, 0, $BTNS_AUTOSIZE)
	_GUICtrlToolbar_AddButton($hToolbar, $Hconfig, 1, 1, $BTNS_AUTOSIZE)
	_GUICtrlToolbar_AddButton($hToolbar, $hDisplayCSV, 2, 2, $BTNS_AUTOSIZE)
	_GUICtrlToolbar_AddButton($hToolbar, $H_graphdisplay, 3, 3, $BTNS_AUTOSIZE)
	_GUICtrlToolbar_AddButton($hToolbar, $H_netmon, 4, 4, $BTNS_AUTOSIZE)
	
	$hReBar = _GUICtrlRebar_Create($hGui, $CCS_TOP + $RBS_FIXEDORDER + $RBS_BANDBORDERS)
	_GUICtrlRebar_AddBand($hReBar, $hToolbar, 350, 350, "", 0)

	$hGui2 = GUICreate( "", 140, 20, -1, -1, BitXOR( $GUI_SS_DEFAULT_GUI, $WS_CAPTION ) )
	GUICtrlCreateLabel( "Cycle time (Minutes) :", 2, 3, 100, 20 )
	$Input1 = _GUICtrlEdit_Create($hGui2, "60", 112, 0, 20, 20, $ES_LEFT)
	_WinAPI_SetParent( $hGui2, $hGui )
	GUISwitch( $hGui )

	_GUICtrlRebar_AddBand($hReBar, $hGui2, 140, 140, "", 1, $RBBS_NOGRIPPER)

	$traybut = _GUICtrlButton_Create($hGui, 'Tray', 0, 0, 90, 28, $BS_DEFPUSHBUTTON)
	_GUICtrlRebar_AddBand($hReBar, $traybut, 90, 90, "", 2, $RBBS_NOGRIPPER)

	$btnExit = GUICtrlCreateButton("Exit", 150, 360, 100, 25)

	GUIRegisterMsg($WM_SIZE, "WM_SIZE")

	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $btnExit
				Exit
		EndSwitch
	WEnd
EndFunc

Func WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	If $hWnd = $hGui Then
		$wPos = WinGetPos($hGui)
		ControlMove($hGui, "", $hReBar, 0, 0, $wPos[2])
	EndIf
EndFunc
