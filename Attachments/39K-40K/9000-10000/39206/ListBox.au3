#include <GUIConstantsEx.au3>
#include <GuiListBox.au3>

#include "APIConstants.au3"

Opt( "MustDeclareVars", 1 )

Global Const $dllGDI32 = DllOpen( "gdi32.dll" )
Global Const $dllUser32 = DllOpen( "user32.dll" )

; DRAWITEMSTRUCT
Global Const $tagDRAWITEMSTRUCT ="uint CtlType;uint CtlID;uint itemID;uint itemAction;uint itemState;hwnd hwndItem;handle hDC;dword rcItem[4];ptr itemData"

; CtlType
Global Const $ODT_LISTBOX = 2

; itemAction
Global Const $ODA_DRAWENTIRE = 0x1
Global Const $ODA_SELECT = 0x2
Global Const $ODA_FOCUS = 0x4

; itemState
Global Const $ODS_SELECTED = 0x1

; Colors
Global $iWhite = ColorConvert( 0xFFFFFF )
Global $iRed   = ColorConvert( 0xFF0000 )
Global $iBlue  = ColorConvert( 0x0000FF )
Global $iBlack = ColorConvert( 0x000000 )
Global $iGray  = ColorConvert( 0xD3D3D3 )

Global $hGui, $idList1, $hList1, $idList2, $hList2

MainScript()

Func MainScript()

	$hGui = GUICreate( "Ownerdrawn Listbox", 300, 265, -1, 300 )

	GUICtrlCreateLabel( "Normal", 10, 10, 130, 15 )
	$idList1 = GUICtrlCreateList( "", 10, 25, 130, 230, BitXOR( $GUI_SS_DEFAULT_LIST, $LBS_SORT ) )
	$hList1 = GUICtrlGetHandle( $idList1 )
	For $i = 1 To 30
		GUICtrlSetData( $idList1, "This is item # " & $i )
	Next

	Local $itemHeight = _GUICtrlListBox_GetItemHeight( $hList1 )

	Local $iStyle = BitOR( BitXOR( $GUI_SS_DEFAULT_LIST, $LBS_SORT ), $LBS_OWNERDRAWFIXED, $LBS_HASSTRINGS )

	GUICtrlCreateLabel( "Ownerdrawn", 160, 10, 130, 15 )
	$idList2 = GUICtrlCreateList( "", 160, 25, 130, 230, $iStyle )
	$hList2 = GUICtrlGetHandle( $idList2 )
	For $i = 1 To 30
		GUICtrlSetData( $idList2, "This is item # " & $i )
		_GUICtrlListBox_SetItemHeight( $hList2, $itemHeight, $i - 1 )
	Next

	GUIRegisterMsg( $WM_DRAWITEM, "WM_DRAWITEM" )

	GUISetState()

	While 1

		Switch GUIGetMsg()

			Case $GUI_EVENT_CLOSE
				ExitLoop

		EndSwitch

	WEnd

	DllClose( $dllUser32 )
	DllClose( $dllGDI32 )
	GUIDelete( $hGui )
	Exit

EndFunc

Func WM_DRAWITEM( $hWnd, $iMsg, $iwParam, $ilParam )
	Local $tDRAWITEMSTRUCT = DllStructCreate( $tagDRAWITEMSTRUCT, $ilParam )
	Local $CtlType = DllStructGetData( $tDRAWITEMSTRUCT, "CtlType" )
	If $CtlType <> $ODT_LISTBOX Then Return $GUI_RUNDEFMSG

	Local $itemID = DllStructGetData( $tDRAWITEMSTRUCT, "itemID" )
	Local $itemAction = DllStructGetData( $tDRAWITEMSTRUCT, "itemAction" )
	Local $itemState = DllStructGetData( $tDRAWITEMSTRUCT, "itemState" )
	Local $hDC = DllStructGetData( $tDRAWITEMSTRUCT, "hDC" )

	Local $tRECT, $iBrushColor, $aBrush, $aBrushOld, $sItemText, $iTextColor, $DT_LEFT = 0

	Switch $itemAction
		Case $ODA_DRAWENTIRE, $ODA_SELECT
			$tRECT = DllStructCreate( $tagRECT, DllStructGetPtr( $tDRAWITEMSTRUCT, "rcItem" ) )

			; Background
			If $itemState = $ODS_SELECTED Then
				$iBrushColor = $iGray
			Else
				$iBrushColor = $iWhite
			EndIf
			$aBrush = DLLCall( $dllGDI32,"hwnd","CreateSolidBrush", "int", $iBrushColor )
			$aBrushOld = DLLCall( "gdi32.dll","hwnd","SelectObject", "hwnd", $hDC, "hwnd", $aBrush[0] )
			DLLCall( $dllUser32,"int","FillRect", "hwnd", $hDC, "ptr", DllStructGetPtr( $tRECT ), "hwnd", $aBrush[0] )
			DLLCall( $dllGDI32,"hwnd","SelectObject", "hwnd", $hDC, "hwnd", $aBrushOld[0] )
			DLLCall( $dllGDI32,"int","DeleteObject", "hwnd", $aBrush[0] )
			DLLCall( $dllGDI32,"int","SetBkMode", "hwnd", $hDC, "int", 1 )

			; Item text
			$sItemText = _GUICtrlListBox_GetText( $hList2, $itemID )
			Switch Mod( $itemID, 3 )
				Case 0
					$iTextColor = $iRed
				Case 1
					$iTextColor = $iBlue
				Case 2
					$iTextColor = $iBlack
			EndSwitch
			DllCall( $dllGDI32,"int","SetTextColor", "hwnd", $hDC, "int", $iTextColor )
			DllCall( $dllUser32,"int","DrawText", "hwnd", $hDC, "str", $sItemText, "int", StringLen( $sItemText ), "ptr", DllStructGetPtr( $tRECT ), "int", $DT_LEFT )
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc

;RGB to BGR or BGR to RGB
Func ColorConvert($iColor)
	Return BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
EndFunc
