#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <ComboConstants.au3>
#Include <GuiComboBox.au3>
#Include <GuiListView.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <SliderConstants.au3>
#include <GuiSlider.au3>
#include <ProgressConstants.au3>
#include <TabConstants.au3>
#Include <GuiTab.au3>
#include <Array.au3>

Opt("GUIResizeMode",1)
Opt('MustDeclareVars', 1)


    Dim $msg
	Dim $tab, $tabHandle, $tabitem[3]	
	Dim $maingui, $ItemID = 0, $gui[3]
	
	$maingui = GUICreate("My GUI Tab", 800, 600,-1,-1,BitOR($WS_POPUPWINDOW,$WS_CAPTION,$WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$DS_SETFOREGROUND)); will create a dialog box that when displayed is centered
	GUISetBkColor(0xffd990,$maingui)
	
	GUICtrlCreateListView("ID|Item|Path",10,10,180,580)

	$tab = GUICtrlCreateTab(200, 10, 580, 580)
	$tabHandle = GUICtrlGetHandle($tab)
	
	
	;==============================================================
	$ItemID += 1
	$tabitem[0] = GUICtrlCreateTabItem("tab"&$ItemID)
	GUICtrlCreateButton("tab"&$ItemID&"_BTN",210,100,200,24)
	
;~ 	GUICtrlCreateTabItem("")		
    $gui[0] = GUICreate("",0,0, 300,0, $WS_POPUP+$WS_THICKFRAME,  $WS_EX_MDICHILD);, $maingui)
	GUISetBkColor(0x000000)
	GUICtrlCreateButton("tab"&$ItemID&"_BTN_BKGUI",210,300,200,30)
	GUICtrlCreateEdit($ItemID,210,350,200,200)
;~ 	GUISetState(@SW_HIDE,$gui[0])
	GUISwitch($maingui)	
	
	;==============================================================
	$ItemID += 1
	$tabitem[1] = GUICtrlCreateTabItem("tab"&$ItemID)
	GUICtrlCreateButton("tab"&$ItemID&"_BTN",210,100,200,24)
	
;~ 	GUICtrlCreateTabItem("")		
    $gui[1] = GUICreate("",0,0, 300,0, $WS_POPUP+$WS_THICKFRAME,  $WS_EX_MDICHILD);, $maingui)
	GUISetBkColor(0x000000)
	GUICtrlCreateButton("tab"&$ItemID&"_BTN_BKGUI",210,300,200,30)
	GUICtrlCreateEdit($ItemID,210,350,200,200)
	GUISwitch($maingui)

    ;==============================================================
    $ItemID += 1
	$tabitem[2] = GUICtrlCreateTabItem("tab----"&$ItemID)
	GUICtrlCreateButton("tab----"&$ItemID&"_BTN",210,100,200,24)	
	
;~ 	GUICtrlCreateTabItem("")		
    $gui[2] = GUICreate("",0,0, 300,0, $WS_POPUP+$WS_THICKFRAME,  $WS_EX_MDICHILD);, $maingui)
	GUISetBkColor(0x000000)
	GUICtrlCreateButton("tab"&$ItemID&"_BTN_BKGUI",210,300,200,30)
	GUICtrlCreateEdit($ItemID,210,350,200,200)
	GUISwitch($maingui)
	
	
	
	
	
	
	
	
	
	GUICtrlCreateTabItem("")	


	GUISetState(@SW_SHOW,$maingui)
	
	
	
	HotKeySet("{F1}","ADDItem")	
	GUIRegisterMsg($WM_NOTIFY,"WM_NOTIFY")



	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd


Func ADDItem()
	_ArrayAdd($tabitem,"")
	_ArrayAdd($gui,"")
	
	$ItemID += 1
	$tabitem[$ItemID-1] = GUICtrlCreateTabItem("tab++++"&$ItemID)
	GUICtrlCreateButton("tab++++"&$ItemID&"_BTN",210,100,200,24)
	
	;~ 	GUICtrlCreateTabItem("")		
    $gui[$ItemID-1] = GUICreate("",0,0, 300,0, $WS_POPUP+$WS_THICKFRAME,  $WS_EX_MDICHILD);, $maingui)
	GUISetBkColor(0x000000)
	GUICtrlCreateButton("tab"&$ItemID&"_BTN_BKGUI",210,300,200,30)
	GUICtrlCreateEdit($ItemID,210,350,200,200)
	GUISwitch($maingui)
	
	GUICtrlCreateTabItem("")	
EndFunc	


Func WM_NOTIFY($hWnd,$iMsg,$iwParam,$ilParam)
	Local $hWndFrom,$iIDFrom,$iCode,$tNMHDR
	$tNMHDR = DllStructCreate($tagNMHDR,$ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR,"hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR,"IDFrom")
	$iCode = DllStructGetData($tNMHDR,"Code")
	Switch $hWndFrom;$NM_CLICK,$NM_RCLICK,$NM_DBLCLK		
		Case $tabHandle
			Switch $iCode
				Case $NM_CLICK					
					Local $CurTabID = _GUICtrlTab_GetCurSel($maingui)
					If $CurTabID = -1 Then Return
			EndSwitch			
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc










