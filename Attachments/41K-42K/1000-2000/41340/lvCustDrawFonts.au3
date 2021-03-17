#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <FontConstants.au3>
#include <GuiListView.au3>
#include <GuiTab.au3>
#include <WinAPI.au3>

Opt( "MustDeclareVars", 1 )

Global Const $iBorderWidth = 4

; Structures
Global Const $tagENUMLOGFONTEX = $tagLOGFONT & ";wchar elfFullName[64]; wchar elfStyle[32]; wchar elfScript[32]"

Global Const $tagNEWTEXTMETRIC = _
	"long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;long tmAveCharWidth;" & _
	"long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;wchar tmFirstChar;" & _
	"wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & _
	"byte tmPitchAndFamily;byte tmCharSet;dword ntmFlags;uint ntmSizeEM;uint ntmCellHeight;uint ntmAvgWidth"
Global const $tagFONTSIGNATURE = "dword fsUsb[4];dword fsCsb[2]"
Global const $tagNEWTEXTMETRICEX = $tagNEWTEXTMETRIC & ";" & $tagFONTSIGNATURE

; Character sets
Global $iCharSet = 0
Global Const $iCharSets = 14
Global Const $sCharSets[$iCharSets] = [ _
	"ANSI", "Baltic", "Chinese Big5", "East Europe", "GB2312", "Greek", "Hangeul", _
	"MAC", "OEM", "Russian", "Shift JIS", "Symbol", "Turkish", "Vietnamese" ]
Global Const $aCharSets[$iCharSets] = [ _
	$ANSI_CHARSET, $BALTIC_CHARSET, $CHINESEBIG5_CHARSET, $EASTEUROPE_CHARSET, $GB2312_CHARSET, $GREEK_CHARSET, $HANGEUL_CHARSET, _
	$MAC_CHARSET, $OEM_CHARSET, $RUSSIAN_CHARSET, $SHIFTJIS_CHARSET, $SYMBOL_CHARSET, $TURKISH_CHARSET, $VIETNAMESE_CHARSET ]

; Fonts
Global $iFonts = 0, $aFonts[100], $lvFontHeight, $lvFontWidth

Global $hGui, $hLV, $hLVfont

MainScript()

Func MainScript()

	; Create GUI
	$hGui = GUICreate( "Fonts", 556, 360, 400, 200 )

	; Create Tab control
	Local $aPos = WinGetClientSize( $hGui )
	Local $idTab = GUICtrlCreateTab( $iBorderWidth, $iBorderWidth, $aPos[0]-2*$iBorderWidth, $aPos[1]-2*$iBorderWidth, $TCS_MULTILINE )

	; Add Tab items
	For $charset In $sCharSets
		GUICtrlCreateTabItem( $charset )
	Next
	GUICtrlCreateTabItem( "" )

	; Create ListView control
	Local $idLV = GUICtrlCreateListView( "", 12, 52, 529, 292, $GUI_SS_DEFAULT_LISTVIEW, BitOR( $WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT ) )
	$hLV = ControlGetHandle( $hGui, "", $idLV )
	
	; Add 2 columns to ListView control
	_GUICtrlListView_AddColumn( $hLV, "Font", 250 )
	_GUICtrlListView_AddColumn( $hLV, "Name", 250 )

	; Get the font of the ListView control
	; Copied from the _GUICtrlGetFont example by KaFu
	; See http://www.autoitscript.com/forum/index.php?showtopic=124526
	Local $hDC = _WinAPI_GetDC($hLV)
	Local $hFont = _SendMessage($hLV, $WM_GETFONT)
	Local $hObject = _WinAPI_SelectObject($hDC, $hFont)
	Local $lvLOGFONT = DllStructCreate($tagLOGFONT)
	Local $aRet = DllCall('gdi32.dll', 'int', 'GetObjectW', 'ptr', $hFont, 'int', DllStructGetSize($lvLOGFONT), 'ptr', DllStructGetPtr($lvLOGFONT))
	_WinAPI_SelectObject($hDC, $hObject)
	_WinAPI_ReleaseDC($hLV, $hDC)
	$lvFontHeight = DllStructGetData( $lvLOGFONT, "Height" )
	$lvFontWidth = DllStructGetData( $lvLOGFONT, "Width" )
	$hLVfont = _WinAPI_CreateFontIndirect( $lvLOGFONT )

	; Add fonts for character sets in FontConstants.au3
	EnumFontFamilies( $iCharSet )

	; Functions for Windows Messages
	GUIRegisterMsg( $WM_NOTIFY, "WM_NOTIFY" )

	; Show GUI
	GUISetState( @SW_SHOW, $hGui )

	; Message loop
	While 1

		Local $aMsg = GUIGetMsg(1)

		Switch $aMsg[1]

			; Events for the main GUI
			Case $hGui

				Switch $aMsg[0]

					Case $idTab
						For $i = 0 To $iFonts - 1
							_WinAPI_DeleteObject( $aFonts[$i] )
						Next
						$iFonts = 0
						$aFonts = 0
						Dim $aFonts[100]
						$iCharSet = GUICtrlRead( $idTab )
						_GUICtrlListView_BeginUpdate( $hLV )
						_GUICtrlListView_DeleteAllItems( $hLV )
						EnumFontFamilies( $iCharSet )
						_GUICtrlListView_EndUpdate( $hLV )

					Case $GUI_EVENT_CLOSE
						ExitLoop

				EndSwitch

		EndSwitch

	WEnd

	For $i = 0 To $iFonts - 1
		_WinAPI_DeleteObject( $aFonts[$i] )
	Next
	GUIDelete( $hGui )
	Exit

EndFunc


#cs###################################
#   Functions for Windows Messages   #
#ce###################################

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $tNMHDR, $hWndFrom, $iCode
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")

	Switch $hWndFrom

		Case $hLV

			Switch $iCode

				Case $NM_CUSTOMDRAW
					Local $tNMLVCUSTOMDRAW = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
					Local $dwDrawStage = DllStructGetData($tNMLVCUSTOMDRAW, "dwDrawStage")

					Switch $dwDrawStage													; Holds a value that specifies the drawing stage

						Case $CDDS_PREPAINT
							; Before the paint cycle begins
							Return $CDRF_NOTIFYITEMDRAW							; Notify the parent window of any item-related drawing operations

						Case $CDDS_ITEMPREPAINT
							; Before painting an item
							Return $CDRF_NOTIFYSUBITEMDRAW					; Notify the parent window of any subitem-related drawing operations

						Case BitOR( $CDDS_ITEMPREPAINT, $CDDS_SUBITEM )
							; Before painting a subitem
							Local $iSubItem = DllStructGetData($tNMLVCUSTOMDRAW, "iSubItem")				; Subitem index
							Local $hDC = DllStructGetData($tNMLVCUSTOMDRAW, "HDC")									; Handle to the item's device context
							If $iSubItem = 0 Then
								Local $dwItemSpec = DllStructGetData($tNMLVCUSTOMDRAW, "dwItemSpec")	; Item index
								_WinAPI_SelectObject($hDC, $aFonts[$dwItemSpec])
							Else
								_WinAPI_SelectObject($hDC, $hLVfont)
							EndIf
							Return $CDRF_NEWFONT										; $CDRF_NEWFONT must be returned after changing font or colors

					EndSwitch

			EndSwitch

	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc


#cs#######################
#   Callback functions   #
#ce#######################

Func EnumFontFamilies( $iCharSet )

	Local $tLOGFONT = DllStructCreate( $tagLOGFONT )
	DllStructSetData( $tLOGFONT, "CharSet", $aCharSets[$iCharSet] )
	DllStructSetData( $tLOGFONT, "FaceName", "" )

	; Call EnumFontFamiliesEx
	Local $hCallBack = DllCallbackRegister("EnumFontFamExProc", "int", "ptr;ptr;dword;lparam")

	; Call EnumFontFamiliesEx
	Local $hDC = _WinAPI_GetDC( $hLV )
	DllCall( "gdi32.dll", "int", "EnumFontFamiliesExW", "handle", $hDC, "struct*", $tLOGFONT, "ptr", DllCallbackGetPtr($hCallBack), "lparam", 0, "dword", 0 )
	_WinAPI_ReleaseDC( $hLV, $hDC )

	; Delete callback function
	DllCallbackFree( $hCallBack )

EndFunc

; Enumerate fonts for the character set in the CharSet member of $pENUMLOGFONTEX
Func EnumFontFamExProc( $pENUMLOGFONTEX, $pNEWTEXTMETRICEX, $FontType, $lParam )
	Local $tENUMLOGFONTEX = DllStructCreate( $tagENUMLOGFONTEX, $pENUMLOGFONTEX )
	Local $elfFullName = DllStructGetData( $tENUMLOGFONTEX, "elfFullName" )	; Full name of the font
	Local $tLOGFONT = DllStructCreate( $tagLOGFONT )												; $tagLOGFONT struct to create a new font
	DllStructSetData( $tLOGFONT, "Height", $lvFontHeight )									; Set height to height of the ListView font
	DllStructSetData( $tLOGFONT, "Width", $lvFontWidth )										; Set width to width of the ListView font
	DllStructSetData( $tLOGFONT, "FaceName", $elfFullName )									; Set facename to the full name
	If Mod( $iFonts, 100 ) = 0 Then ReDim $aFonts[$iFonts+100]
	$aFonts[$iFonts] = _WinAPI_CreateFontIndirect( $tLOGFONT )							; Create font and save it in aFonts
	_GUICtrlListView_AddItem( $hLV, $elfFullName )													; Add ListView item
	_GUICtrlListView_AddSubItem( $hLV, $iFonts, $elfFullName, 1 )						; Add sub item
	$iFonts += 1
	Return 1																																; Return 1 to continue enumeration
EndFunc
