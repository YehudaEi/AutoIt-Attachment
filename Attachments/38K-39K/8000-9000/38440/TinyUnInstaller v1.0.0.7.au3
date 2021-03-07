#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Windows\InstallShield.ico
#AutoIt3Wrapper_Outfile=TinyUninstaller.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Uninstall Softs
#AutoIt3Wrapper_Res_Fileversion=1.0.0.7
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=P
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © wakillon 2010 - 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#Include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiScrollBars.au3>
#Include <Constants.au3>
#include <WinAPI.au3>
#Include <String.au3>
#Include <Array.au3>
#Include <Misc.au3>
#Include <File.au3>
#Include <Math.au3>
#EndRegion ;************ Includes ************

If Not _Singleton ( @ScriptName, 1 ) Then Exit
OnAutoItExitRegister ( '_OnAutoItExit' )

Global $_Apps[1]
$_Apps = _EnumApps ( )
Global $_GUI, $_Ctrl, $_State=False, $_Max = UBound ( $_Apps )
Global $_LabArray[$_Max][3]
Global $_LabFontArray[$_Max], $_LabFontMin = 9, $_LabFontMax = 10
Global $_GuiBkColor = 0x1D3652, $_BaseColor = 0xFFFFFF, $_OverColor=0xFF0000, $_ClickedColor=0xFFAA00
Global $_Version = _GetScriptVersion ( ), $_TopicItem, $_I
Global $SCROLL_AMOUNTS[1][3]

Opt ( 'GUICloseOnESC', 0 )
Opt ( 'TrayOnEventMode', 1 )
Opt ( 'TrayMenuMode', 1 )

If _FileMissing ( ) Then _FileInstall ( )
_GuiCreate ( )
_SetTrayMenu ( )

#Region ------ Main Loop ------------------------------
While 1
    $_Msg = GUIGetMsg ( )
    Switch $_Msg
		Case $GUI_EVENT_CLOSE
			AdlibUnRegister ( '_GuiCtrlLabelFlash' )
			AdlibUnRegister ( '_TrayTipTimer' )
            Exit
        Case Else
			If $_GuiBkColor <> 0x1D3652 Then
			    $_GuiBkColor = 0x1D3652
			    GUISetBkColor ( $_GuiBkColor )
			EndIf
			If _IsVisible ( $_Gui ) And UBound ( $_LabArray ) -1 > 1 Then
				For $_I = 1 To UBound ( $_LabArray ) -1
					If $_Msg = $_LabArray[$_I][0] Then
						$_AppsSplit = StringSplit ( $_Apps[$_I], '|' )
						; ConsoleWrite ( '-->-- $_LabArray[' & $_I & '][0] was clicked' & @Crlf )
						If _IsPressed ( '11' ) Then ; 11 Left Ctrl key
							ClipPut ( $_AppsSplit[2] )
							_TrayTip ( $_Version, @CRLF & 'Uninstall Cmd : ' & $_AppsSplit[2] & @CRLF & 'of ' & $_AppsSplit[1] & ' was copied to the Clipboard ', 1 )
							AdlibRegister ( '_TrayTipTimer', 5000 )
						Else
							$_LabArray[$_I][2] = $_ClickedColor
							GUICtrlSetColor ( $_LabArray[$_I][0], $_LabArray[$_I][2] )
							SoundPlay ( @WindowsDir & '\Media\Windows User Account Control.wav' )
							If $_LabFontArray[$_I] <> $_LabFontMax Then
								$_LabFontArray[$_I] = $_LabFontMax
								GUICtrlSetFont ( $_LabArray[$_I][0], $_LabFontArray[$_I], 800 )
							EndIf
							$_MsgBox = MsgBox ( 262144+4+4160, 'Uninstall Operation', 'Do you want to Uninstall ' & $_AppsSplit[1]  & ' ?' )
							If $_MsgBox = 6 Then
								GUISetState ( @SW_HIDE, $_Gui )
								Run ( $_AppsSplit[2] )
							EndIf
						EndIf
					EndIf
					$_LabArray[$_I][1] = _GUICtrlLabelSetColor ( $_LabArray[$_I][0], $_LabArray[$_I][1], $_LabArray[$_I][2] )
				Next
			EndIf
	EndSwitch
	Sleep ( 10 )
WEnd
#EndRegion --- Main Loop ------------------------------

Func _GuiCreate ( )
	$_GUI = GUICreate ( $_Version, 700, 500, -1, -1, BitOR ( $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX ) )
	GUISetBkColor ( $_GuiBkColor )
	GUISetFont ( $_LabFontMin, 800 )
	GUISetIcon ( 'C:\Windows\InstallShield.ico' )
	Local $_Div = Int ( ( ( $_Max * 2 ) / 70 ) + 2 ) + 1, $_Left = 20, $_Step = Int ( $_Max/$_Div ), $_LabelWidht = 280
	For $_I = 1 To UBound ( $_LabArray ) -1
		$_Top = $_I
		$_Left = 20
		For $_J = $_Step To $_Max Step $_Step
			If $_I > $_J Then
				$_Left += $_LabelWidht +30
				$_Top = ( $_I - $_J )
			EndIf
		Next
		$_AppsSplit = StringSplit ( $_Apps[$_I], '|' )
		If $_AppsSplit[3] <> '' And $_AppsSplit[1] <> $_AppsSplit[3] Then $_AppsSplit[1] = StringReplace ( $_AppsSplit[1], $_AppsSplit[3], '' )
		$_LabArray[$_I][0] = GUICtrlCreateLabel ( $_AppsSplit[1], $_Left+20, 50 + $_Top * 45, $_LabelWidht, 30 )
		$_LabFontArray[$_I] = $_LabFontMin
		$_LabArray[$_I][1] = $_BaseColor
		GUICtrlSetColor ( -1, $_LabArray[$_I][1] )
		$_LabArray[$_I][2] = $_BaseColor
		GUICtrlSetResizing ( -1, $GUI_DOCKALL )
		If $_AppsSplit[7] <> '' Then $_AppsSplit[7] = 'Install Location : ' & $_AppsSplit[7] & @CRLF
		If $_AppsSplit[4] Then  $_AppsSplit[4] = 'Estimated Install Size : ' & $_AppsSplit[4] & ' KB' & @CRLF
		If $_AppsSplit[3] <> '' Then $_AppsSplit[3] = 'Version : ' & $_AppsSplit[3] & @CRLF
		If $_AppsSplit[5] <> '' Then $_AppsSplit[5] = 'Install Date : ' & $_AppsSplit[5] & @CRLF
		$_TipText = @CRLF & $_AppsSplit[3] & $_AppsSplit[5] & $_AppsSplit[7] & $_AppsSplit[4] & 'Uninstall Cmd : ' & _StringToMultiLines ( $_AppsSplit[2], 60 )
		GUICtrlSetTip ( -1, $_TipText, 'Infos on ' & $_AppsSplit[1], 1, 1 )
		GUICtrlSetCursor ( -1, 0 )
		GUICtrlCreateIcon ( $_AppsSplit[6], 0, $_Left, 50 + $_Top * 45, 16, 16, $SS_LEFT )
		GUICtrlSetResizing ( -1, $GUI_DOCKALL )
	Next
	$_NewWidth = _Min ( @DesktopWidth - 100, $_Left + $_LabelWidht +50 )
	$_NewHeight = _Max ( _Min ( @DesktopHeight - 180, ( $_Step + 2 ) * 45 ) + 100 , 300 )
	WinMove ( $_GUI, '', ( @DesktopWidth - $_NewWidth ) /2, ( ( @DesktopHeight - $_NewHeight ) /2 ), $_NewWidth, $_NewHeight )
	GUICtrlCreateLabel ( 'Tiny UnInstaller', 50, 20, $_NewWidth - 100, 50, 0x01 )
	GUICtrlSetFont ( -1, $_LabFontMin*3, 800 )
	GUICtrlSetColor ( -1, 0xFFAA00 )
	GUICtrlSetResizing ( -1, $GUI_DOCKALL )
	$SCROLL_AMOUNTS[0][0] = 1
	ScrollBar_Create ( $_GUI, $SB_HORZ, $_Left + $_LabelWidht )
	ScrollBar_Step ( 40, $_GUI, $SB_HORZ )
	ScrollBar_Create ( $_GUI, $SB_VERT, ( $_Step + 2 ) * 45 )
	ScrollBar_Step ( 40, $_GUI, $SB_VERT )
	GUIRegisterMsg ( $WM_LBUTTONDOWN, '_WM_LBUTTONDOWN' )
	GUIRegisterMsg ( $WM_SIZE, '_WM_SIZE' )
	GUIRegisterMsg ( $WM_GETMINMAXINFO, '_WM_GETMINMAXINFO' )
	GUIRegisterMsg ( $WM_MOUSEWHEEL, '_WM_MOUSEWHEEL' )
	GUISetState ( @SW_SHOW, $_Gui )
EndFunc

Func _StringToMultiLines ( $_String, $_MaxCharPerLine )
	Local $_I
	Do
		$_I += 1
		$_String = _StringInsert ( $_String, @CRLF, $_MaxCharPerLine*$_I )
	Until @error
    Return $_String
EndFunc ;==> _StringToMultiLines ( )

Func _GUICtrlLabelSetColor ( $_LabelCtrl, $_CtrlColor, $_DefaultColor )
   Local $_CursorInfoArray = GUIGetCursorInfo ( $_GUI )
	If @error Then Return
    If $_CursorInfoArray[4] = $_LabelCtrl Then ; if cursor over ctrl then set color to red
		If $_CtrlColor <> $_OverColor Then
			$_Ctrl = $_LabelCtrl
			If $_DefaultColor <> $_ClickedColor Then
		     	AdlibRegister ( '_GuiCtrlLabelFlash', 700 )
			    $_CtrlColor = $_OverColor
		        GUICtrlSetColor ( $_LabelCtrl, $_CtrlColor )
			Else
				If $_LabFontArray[$_I] <> $_LabFontMax Then
					SoundPlay ( @WindowsDir & '\Media\Windows User Account Control.wav' )
					$_LabFontArray[$_I] = $_LabFontMax
					GUICtrlSetFont ( $_LabelCtrl, $_LabFontArray[$_I], 800 )
				EndIf
			EndIf
		EndIf
    Else     ; if not cursor over ctrl then set color to white, or orange if clicked
		If  $_CtrlColor <> $_BaseColor And $_CtrlColor <> $_DefaultColor Then
			If $_Ctrl Then
			    $_Ctrl = 0
			    AdlibUnRegister ( '_GuiCtrlLabelFlash' )
			EndIf
		    $_CtrlColor = $_DefaultColor
		    GUICtrlSetColor ( $_LabelCtrl, $_CtrlColor )
		Else
			If $_CtrlColor = $_ClickedColor And $_LabFontArray[$_I] <> $_LabFontMin Then
				$_LabFontArray[$_I]=$_LabFontMin
		        GUICtrlSetFont ( $_LabelCtrl, $_LabFontArray[$_I], 800 )
			EndIf
		EndIf
    EndIf
	Return $_CtrlColor
EndFunc ;==> _GUICtrlLabelSetColor ( )

Func _GuiCtrlLabelFlash ( )
	If Not $_Ctrl Then Return
	$_State = Not $_State
	If $_State Then
		GUICtrlSetColor ( $_Ctrl, $_GuiBkColor )
	Else
		GUICtrlSetColor ( $_Ctrl, $_OverColor )
	EndIf
EndFunc ;==> _GuiCtrlLabelFlash ( )

Func _UpdateSoftsList ( )
	GUIDelete ( $_Gui )
	ReDim $_Apps[1]
	$_Apps = _EnumApps ( )
	$_Max = UBound ( $_Apps )
	ReDim $_LabArray[$_Max][3]
	ReDim $_LabFontArray[$_Max]
	_GuiCreate ( )
EndFunc ;==> _UpdateSoftsList ( )

Func _WM_LBUTTONDOWN ( $hWnd, $iMsg, $wParam, $lParam )
	$_GuiBkColor = Random ( 0x0000FF, 0xFFFF00, 1 )
	GUISetBkColor ( $_GuiBkColor, $hWnd )
	If BitAND ( WinGetState ( $hWnd ), 32 ) Then Return $GUI_RUNDEFMSG
    DllCall ( 'user32.dll', 'long', 'SendMessage', 'hwnd', $hWnd, 'int', $WM_SYSCOMMAND, 'int', 0xF009, 'int', 0 )
EndFunc ;==> _WM_LBUTTONDOWN ( )

Func _WM_SIZE($hWnd, $Msg, $wParam, $lParam)
    Local $index = -1, $yChar, $xChar, $xClientMax, $xClient, $yClient, $ivMax
    For $x = 0 To UBound($aSB_WindowInfo) - 1
        If $aSB_WindowInfo[$x][0] = $hWnd Then
            $index = $x
            $xClientMax = $aSB_WindowInfo[$index][1]
            $xChar = $aSB_WindowInfo[$index][2]
            $yChar = $aSB_WindowInfo[$index][3]
            $ivMax = $aSB_WindowInfo[$index][7]
            ExitLoop
        EndIf
    Next
    If $index = -1 Then Return 0
    Local $tSCROLLINFO = DllStructCreate($tagSCROLLINFO)
    $xClient = BitAND($lParam, 0x0000FFFF)
    $yClient = BitShift($lParam, 16)
    $aSB_WindowInfo[$index][4] = $xClient
    $aSB_WindowInfo[$index][5] = $yClient
    DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
    DllStructSetData($tSCROLLINFO, "nMin", 0)
    DllStructSetData($tSCROLLINFO, "nMax", $ivMax + 20 ) ; 0
    DllStructSetData($tSCROLLINFO, "nPage", $yClient / $yChar)
    _GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
    DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
    DllStructSetData($tSCROLLINFO, "nMin", 0 )
    DllStructSetData($tSCROLLINFO, "nMax", 100 + $xClientMax / $xChar) ; 2
    DllStructSetData($tSCROLLINFO, "nPage", $xClient / $xChar)
    _GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
    Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_SIZE ( )

Func _WM_GETMINMAXINFO ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $_Gui
			$_MinMaxInfo = DllStructCreate ( 'int;int;int;int;int;int;int;int;int;int', $lParam )
			DllStructSetData ( $_MinMaxInfo, 7, 900 ) ; min X
			DllStructSetData ( $_MinMaxInfo, 8, 500 ) ; min Y
			DllStructSetData ( $_MinMaxInfo, 9, @DesktopWidth - 20 ) ; max X
			DllStructSetData ( $_MinMaxInfo, 10, @DesktopHeight -50 ) ; max Y
			Return 0
	EndSwitch
EndFunc ;==> _WM_GETMINMAXINFO ( )

Func _WM_MOUSEWHEEL ( $hWnd, $iMsg, $iwParam, $ilParam )
    Local $iDelta = BitShift ( $iwParam, 16 )
    If $iDelta > 0 Then
        _SendMessage ( $_GUI, $WM_VSCROLL, $SB_LINEUP )
    Else
        _SendMessage ( $_GUI, $WM_VSCROLL, $SB_LINEDOWN )
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_MOUSEWHEEL ( )

#Region ------ GUIScroll by Kip ------------------------------
; http://www.autoitscript.com/forum/topic/79684-scroll-udf-much-easier-than-the-guiscrollbars-udf/#entry710515
Func ScrollBar_Create ( $hWnd, $iBar, $iMax )
    Local $Size = WinGetClientSize ( $hWnd )
    If $iBar = $SB_HORZ Then
        $Size = $Size[0]
    ElseIf $iBar = $SB_VERT Then
        $Size = $Size[1]
    Else
        Return 0
    EndIf
    ReDim $SCROLL_AMOUNTS[UBound ( $SCROLL_AMOUNTS )+1][3]
    $SCROLL_AMOUNTS[UBound ( $SCROLL_AMOUNTS )-1][0] = $hWnd
    $SCROLL_AMOUNTS[UBound ( $SCROLL_AMOUNTS )-1][1] = $iBar
    $SCROLL_AMOUNTS[UBound ( $SCROLL_AMOUNTS )-1][2] = $SCROLL_AMOUNTS[0][0]
    _GUIScrollBars_EnableScrollBar ( $hWnd, $iBar )
    _GUIScrollBars_SetScrollRange ( $hWnd, $iBar, 0, $iMax-1 )
    _GUIScrollBars_SetScrollInfoPage ( $hWnd, $iBar, $Size )
    GUIRegisterMsg ( $WM_VSCROLL, '_WM_VSCROLL' )
    GUIRegisterMsg ( $WM_HSCROLL, '_WM_HSCROLL' )
    Return $iMax
EndFunc ;==> ScrollBar_Create ( )

Func ScrollBar_GetPos ( $hWnd, $iBar )
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx ( $hWnd, $iBar )
    Return DllStructGetData ( $tSCROLLINFO, 'nPos' )
EndFunc ;==> ScrollBar_GetPos ( )

Func ScrollBar_Scroll ( $hWnd, $iBar, $iPos )
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx ( $hWnd, $iBar )
    $iCurrentPos = DllStructGetData ( $tSCROLLINFO, 'nPos' )
    DllStructSetData ( $tSCROLLINFO, 'nPos', $iPos )
    DllStructSetData ( $tSCROLLINFO, 'fMask', $SIF_POS )
    _GUIScrollBars_SetScrollInfo ( $hWnd, $iBar, $tSCROLLINFO )
    If $iBar = $SB_VERT Then
        $iRound = 0
        For $i = 1 To UBound ( $SCROLL_AMOUNTS )-1
            If $SCROLL_AMOUNTS[$i][0] = $hWnd And $SCROLL_AMOUNTS[$i][1] = $SB_VERT Then $iRound = $SCROLL_AMOUNTS[$i][2]
        Next
        If Not $iRound Then Return 0
        _GUIScrollBars_ScrollWindow ( $hWnd, 0, Round ( ( $iCurrentPos-$iPos )/$iRound )*$iRound )
    ElseIf $iBar = $SB_HORZ Then
        $iRound = 0
        For $i = 1 To UBound ( $SCROLL_AMOUNTS )-1
            If $SCROLL_AMOUNTS[$i][0] = $hWnd And $SCROLL_AMOUNTS[$i][1] = $SB_HORZ Then $iRound = $SCROLL_AMOUNTS[$i][2]
        Next
        If Not $iRound Then Return 0
        _GUIScrollBars_ScrollWindow ( $hWnd, Round ( ( $iCurrentPos-$iPos )/$iRound )*$iRound, 0 )
    Else
        Return 0
    EndIf
    Return 1
EndFunc ;==> ScrollBar_Scroll ( )

Func ScrollBar_Step ( $iStep, $hWnd=0, $iBar=0 )
    If Not $hWnd or Not $iBar Then
        $SCROLL_AMOUNTS[0][0] = $iStep
        Return 1
    EndIf
    $iID = 0
    For $i = 1 To UBound ( $SCROLL_AMOUNTS )-1
        If $SCROLL_AMOUNTS[$i][0] = $hWnd And $SCROLL_AMOUNTS[$i][1] = $iBar Then
            $iID = $i
            ExitLoop
        EndIf
    Next
    If Not $iID Then Return 0
    $SCROLL_AMOUNTS[$iID][2] = $iStep
    Return 1
EndFunc ;==> ScrollBar_Step ( )

Func _WM_VSCROLL ( $hWnd, $Msg, $wParam, $lParam )
    Local $nScrollCode = BitAND ( $wParam, 0x0000FFFF )
    Local $index = -1, $yChar, $yPos
    Local $Min, $Max, $Page, $Pos, $TrackPos
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx ( $hWnd, $SB_VERT )
    $Min = DllStructGetData ( $tSCROLLINFO, 'nMin' )
    $Max = DllStructGetData ( $tSCROLLINFO, 'nMax' )
    $Page = DllStructGetData ( $tSCROLLINFO, 'nPage' )
    $yPos = DllStructGetData ( $tSCROLLINFO, 'nPos' )
    $Pos = $yPos
    $TrackPos = DllStructGetData ( $tSCROLLINFO, 'nTrackPos' )
    $iRound = 0
    For $i = 1 To UBound ( $SCROLL_AMOUNTS )-1
        If $SCROLL_AMOUNTS[$i][0] = $hWnd And $SCROLL_AMOUNTS[$i][1] = $SB_VERT Then $iRound = $SCROLL_AMOUNTS[$i][2]
    Next
    If Not $iRound Then Return $GUI_RUNDEFMSG
    Switch $nScrollCode
        Case $SB_TOP ; user clicked the HOME keyboard key
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Min )
        Case $SB_BOTTOM ; user clicked the END keyboard key
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Max )
        Case $SB_LINEUP ; user clicked the top arrow
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos - $iRound )
        Case $SB_LINEDOWN ; user clicked the bottom arrow
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos + $iRound )
        Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos - $Page )
        Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos + $Page )
        Case $SB_THUMBTRACK ; user dragged the scroll box
            DllStructSetData ( $tSCROLLINFO, 'nPos', Round ( $TrackPos/$iRound )*$iRound )
    EndSwitch
    DllStructSetData ( $tSCROLLINFO, 'fMask', $SIF_POS )
    _GUIScrollBars_SetScrollInfo ( $hWnd, $SB_VERT, $tSCROLLINFO )
    _GUIScrollBars_GetScrollInfo ( $hWnd, $SB_VERT, $tSCROLLINFO )
    $Pos = DllStructGetData ( $tSCROLLINFO, 'nPos' )
    If $Pos <> $yPos Then _GUIScrollBars_ScrollWindow ( $hWnd, 0, $yPos - $Pos )
    Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_VSCROLL ( )

Func _WM_HSCROLL ( $hWnd, $Msg, $wParam, $lParam )
    Local $nScrollCode = BitAND ( $wParam, 0x0000FFFF )
    Local $index = -1, $yChar, $yPos
    Local $Min, $Max, $Page, $Pos, $TrackPos
    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx ( $hWnd, $SB_HORZ )
    $Min = DllStructGetData ( $tSCROLLINFO, 'nMin' )
    $Max = DllStructGetData ( $tSCROLLINFO, 'nMax' )
    $Page = DllStructGetData ( $tSCROLLINFO, 'nPage' )
    $yPos = DllStructGetData ( $tSCROLLINFO, 'nPos' )
    $Pos = $yPos
    $TrackPos = DllStructGetData ( $tSCROLLINFO, 'nTrackPos' )
    $iRound = 0
    For $i = 1 To UBound ( $SCROLL_AMOUNTS )-1
        If $SCROLL_AMOUNTS[$i][0] = $hWnd And $SCROLL_AMOUNTS[$i][1] = $SB_HORZ Then $iRound = $SCROLL_AMOUNTS[$i][2]
    Next
    If Not $iRound Then Return $GUI_RUNDEFMSG
    Switch $nScrollCode
        Case $SB_TOP ; user clicked the HOME keyboard key
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Min )
        Case $SB_BOTTOM ; user clicked the END keyboard key
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Max )
        Case $SB_LINEUP ; user clicked the top arrow
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos - $iRound )
        Case $SB_LINEDOWN ; user clicked the bottom arrow
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos + $iRound )
        Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos - $Page )
        Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
            DllStructSetData ( $tSCROLLINFO, 'nPos', $Pos + $Page )
        Case $SB_THUMBTRACK ; user dragged the scroll box
            DllStructSetData ( $tSCROLLINFO, 'nPos', Round ( $TrackPos/$iRound )*$iRound )
    EndSwitch
    DllStructSetData($tSCROLLINFO, 'fMask', $SIF_POS )
    _GUIScrollBars_SetScrollInfo ( $hWnd, $SB_HORZ, $tSCROLLINFO )
    _GUIScrollBars_GetScrollInfo ( $hWnd, $SB_HORZ, $tSCROLLINFO )
    $Pos = DllStructGetData ( $tSCROLLINFO, 'nPos' )
    If $Pos <> $yPos Then _GUIScrollBars_ScrollWindow ( $hWnd, $yPos - $Pos, 0 )
    Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_HSCROLL ( )
#EndRegion --- GUIScroll by Kip ------------------------------

Func _EnumApps ( )
	_ReadRegUninstall ( 'HKLM' )
	If StringInStr ( @OSArch, '64' ) Then _ReadRegUninstall ( 'HKLM64' )
	_ArraySort ( $_Apps, 0, 0, 0, 0 )
	Return $_Apps
EndFunc ;==> _EnumApps ( )

Func _ReadRegUninstall ( $_HKLM )
	Local $_Index = 0, $_RegKey, $_EndKey = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
	While 1
		Local $_DisplayName='', $_UninstallString='', $_DisplayVersion='', $_EstimatedSize='', $_InstallLocation='', $_InstallDate='', $_DisplayIcon=''
		$_Index += 1
		$_RegKey = RegEnumKey ( $_HKLM & $_EndKey, $_Index )
		If @error <> 0 Then Return

		#Region ------ DisplayName ------------------------------
		$_DisplayName = RegRead ( $_HKLM & $_EndKey & '\' & $_RegKey, 'DisplayName' )
		#EndRegion --- DisplayName ------------------------------

		#Region ------ UninstallString ------------------------------
		$_UninstallString = RegRead ( $_HKLM & $_EndKey & '\' & $_RegKey, 'UninstallString' )
		If $_UninstallString = '' And StringLeft ( $_RegKey, 1 ) = '{' Then $_UninstallString = 'MsiExec.exe /X' & $_RegKey
		If StringInStr ( $_UninstallString, 'MsiExec' ) Then $_UninstallString = StringReplace ( $_UninstallString, '/I', '/X' )
		#EndRegion --- UninstallString ------------------------------

		If $_DisplayName <> '' And $_UninstallString  <> '' And Not _AlreadyInArray ( $_Apps, $_DisplayName, 1, 1 ) Then

			#Region ------ DisplayVersion ------------------------------
			$_DisplayVersion = RegRead ( $_HKLM & $_EndKey & '\' & $_RegKey, 'DisplayVersion' )
			#EndRegion --- DisplayVersion ------------------------------

			#Region ------ InstallLocation ------------------------------
			$_InstallLocation = RegRead ( $_HKLM & $_EndKey & '\' & $_RegKey, 'InstallLocation' )
			$_UninstallParentFolder = FileGetLongName ( _GetParentFolderPathByUninstallCmd ( StringReplace ( $_UninstallString, '"', '' ) ) )
			If $_InstallLocation = '' And StringInStr ( $_UninstallString, @ProgramFilesDir ) Then $_InstallLocation = $_UninstallParentFolder
			$_InstallLocation = StringReplace ( $_InstallLocation, '"', '' )
			If StringRight ( $_InstallLocation, 1 ) = '\' Then $_InstallLocation = StringTrimRight ( $_InstallLocation, 1 )
			#EndRegion --- InstallLocation ------------------------------

			#Region ------ EstimatedSize ------------------------------
			$_EstimatedSize = RegRead ( $_HKLM & $_EndKey & '\' & $_RegKey, 'EstimatedSize' )
			If $_EstimatedSize = '' Then
				If FileExists ( $_InstallLocation ) Then
					$_EstimatedSize = Ceiling ( DirGetSize ( $_InstallLocation )/1024 )
				Else
					If FileExists ( $_UninstallParentFolder ) Then $_EstimatedSize = Ceiling ( DirGetSize ( $_UninstallParentFolder )/1024 )
				EndIf
			EndIf
			#EndRegion --- EstimatedSize ------------------------------

			#Region ------ InstallDate ------------------------------
			$_InstallDate = RegRead ( $_HKLM & $_EndKey & '\' & $_RegKey, 'InstallDate' )
			#EndRegion --- InstallDate ------------------------------

			#Region ------ DisplayIcon ------------------------------
			$_DisplayIcon = StringReplace ( RegRead ( $_HKLM & $_EndKey & '\' & $_RegKey, 'DisplayIcon' ), '"', '' )
			If StringRight ( $_DisplayIcon, 2 ) = ',0' Then $_DisplayIcon = StringTrimRight ( $_DisplayIcon, 2 )
			If Not FileExists ( $_DisplayIcon ) And StringInStr ( FileGetAttrib ( $_InstallLocation ), 'D' ) Then $_DisplayIcon = _GetExecutableIcon ( $_InstallLocation )
			If Not FileExists ( $_DisplayIcon ) And StringInStr ( FileGetAttrib ( $_UninstallParentFolder ), 'D' ) Then $_DisplayIcon = _GetExecutableIcon ( $_UninstallParentFolder )
			If Not FileExists ( $_DisplayIcon ) Then $_DisplayIcon = @WindowsDir & '\System32\MsiExec.exe'
			#EndRegion --- DisplayIcon ------------------------------

			_ArrayAdd ( $_Apps, $_DisplayName & '|' & $_UninstallString & '|' & $_DisplayVersion & '|' & $_EstimatedSize & '|' & $_InstallDate & '|' & $_DisplayIcon & '|' & $_InstallLocation )
		EndIf
	WEnd
EndFunc ;==> _ReadRegUninstall ( )

Func _GetExecutableIcon ( $_ParentFolder )
	If StringInStr ( FileGetAttrib ( $_ParentFolder ), 'D' ) Then
		$_ExeList = _FileListToArray ( $_ParentFolder, '*.exe' )
		For $_I = 1 To UBound ( $_ExeList ) -1
			If FileExists ( $_ParentFolder & '\' & $_ExeList[$_I] ) And Not StringInStr ( $_ExeList[$_I], 'unins' ) And _
				_ExecutableHasAnIcon ( $_ParentFolder & '\' & $_ExeList[$_I] ) And FileGetSize ( $_ParentFolder & '\' & $_ExeList[$_I] ) > 300000 Then
				Return $_ParentFolder & '\' & $_ExeList[$_I]
			EndIf
		Next
	EndIf
EndFunc ;==> _GetExecutableIcon ( )

Func _ExecutableHasAnIcon ( $_ExePath )
	Return _WinAPI_ExtractIconEx ( $_ExePath, -1, 0, 0, 0 ) <> 0
EndFunc ;==> _ExecutableHasAnIcon ( )

Func _OneOfThisStringInStr ( $_InStr, $_String )
    Local $_I , $_StringArray = StringSplit ( $_String, '|' )
	If @error Then Return
    For $_I = 1 To UBound ( $_StringArray ) -1
        If StringInStr ( $_InStr, $_StringArray[$_I] ) Then Return 1
	Next
EndFunc ;==> _OneOfThisStringInStr ( )

Func _AlreadyInArray ( $_SearchArray, $_Item, $_Start=0, $_Partial=0 )
	$_Index = _ArraySearch ( $_SearchArray, $_Item, $_Start, 0, 0, $_Partial )
    If Not @error Then Return 1
EndFunc ;==> _AlreadyInArray ( )

Func _GetParentFolderPathByUninstallCmd ( $_UninstallCmd )
	Local $_I
	If Not _OneOfThisStringInStr ( $_UninstallCmd, 'MsiExec|RunDll32' ) Then
		For $_I = StringLen ( $_UninstallCmd ) To 2 Step -1
			If StringInStr ( FileGetAttrib ( StringLeft ( $_UninstallCmd, $_I ) ), 'D' ) Then Return StringLeft ( $_UninstallCmd, $_I )
		Next
	EndIf
	Return ''
EndFunc ;==> _GetParentFolderPathByUninstallCmd ( )

Func _GetScriptVersion ( )
	Local $_Return
    If Not @Compiled Then
        $_Return = StringTrimRight ( @ScriptName, 4 ) & ' © wakillon 2010 - ' & @YEAR
    Else
		$_Return = StringTrimRight ( @ScriptName, 4 ) & ' v' & FileGetVersion ( @ScriptFullPath ) & ' © wakillon 2010 - ' & @YEAR
    EndIf
	Return $_Return
EndFunc ;==> _GetScriptVersion ( )

Func _OpenTopic ( )
	TrayItemSetState ( $_TopicItem, $TRAY_UNCHECKED )
	$_TopicUrl = 'http://www.autoitscript.com/forum/topic/143361-tinyuninstaller-v1006/'
	ShellExecute ( _GetDefaultBrowser ( ), $_TopicUrl )
EndFunc ;==> _OpenTopic ( )

Func _GetDefaultBrowser ( )
    Local $_DefautBrowser = StringRegExp ( RegRead ( 'HKCR\http\shell\open\command', '' ), '(?s)(?i)"(.*?)"', 3 )
    If Not @error And FileExists ( $_DefautBrowser[0] ) Then Return $_DefautBrowser[0]
	Local $_UserChoice = RegRead ( 'HKCU\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice', 'Progid' )
	If Not @error Then
		$_DefautBrowser = StringRegExp ( RegRead ( 'HKLM\Software\Classes\' & $_UserChoice & '\shell\open\command', '' ), '(?s)(?i)"(.*?)"', 3 )
		If Not @error And FileExists ( $_DefautBrowser[0] ) Then Return $_DefautBrowser[0]
	EndIf
	Return 'iexplore.exe'
EndFunc ;==> _GetDefaultBrowser ( )

Func _IsVisible ( $_Hwnd )
    If BitAnd ( WinGetState ( $_Hwnd ), 2 ) Then Return 1
EndFunc ;==> _IsVisible ( )

Func _TrayTip ( $_Title= 'Please Wait', $_Texte= '...', $_Ico=0 )
	TrayTip ( $_Title, $_Texte, 5, $_Ico )
EndFunc ;==> _TrayTip ( )

Func _TrayTipTimer ( )
	AdlibUnRegister ( '_TrayTipTimer' )
	TrayTip ( '', '', 1, 1 )
EndFunc ;==> _TrayTipTimer ( )

Func _SetTrayMenu ( )
    TraySetIcon ( 'C:\Windows\InstallShield.ico' )
	$_TopicItem = TrayCreateItem ( 'TinyUninstaller Topic' )
	TrayItemSetOnEvent ( -1, '_OpenTopic' )
	TrayCreateItem ( '' )
	TrayCreateItem ( 'Exit' )
	TrayItemSetOnEvent ( -1, '_Exit' )
	TraySetOnEvent ( $TRAY_EVENT_PRIMARYDOUBLE, '_UpdateSoftsList' )
	TraySetClick ( 16 )
	TraySetState ( 4 )
	TraySetToolTip ( $_Version )
EndFunc ;==> _SetTrayMenu ( )

Func _FileMissing ( )
	If Not FileExists ( 'C:\Windows\InstallShield.ico' ) Then Return True
EndFunc ;==> _FileMissing ( )

Func _FileInstall ( )
	ToolTip ( _StringRepeat ( ' ', 12 ) & @Crlf & 'Please Wait while downloading externals files' & @Crlf & @Crlf, @DesktopWidth/2-152, @DesktopHeight/3, $_Version, 1, 4 )
	Local $_RegKey = _Iif ( StringInStr ( @OSArch, '64' ), 'HKCU64', 'HKCU' )
	RegWrite ( $_RegKey & '\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced', 'EnableBalloonTips', 'REG_DWORD', '00000001' )
	Local $_Url = 'http://tinyurl.com/8h65prh'
	If Not FileExists ( 'C:\Windows\InstallShield.ico' ) Then InetGet ( $_Url & '/InstallShield.ico', 'C:\Windows\InstallShield.ico', 9, 0 )
	ToolTip ( '' )
EndFunc ;==> _FileInstall ( )

Func _Exit ( )
    Exit
EndFunc ;==> _Exit ( )

Func _OnAutoItExit ( )
	GUIDelete ( $_Gui )
	Opt ( 'TrayIconHide', 0 )
	$_Split = StringSplit ( $_Version, '©' )
	If Not @error Then TrayTip ( $_Split[1], $_Split[2], 1, 1 )
	Sleep ( 2000 )
	TrayTip ( '', '', 1, 1 )
EndFunc ;==> _OnAutoItExit ( )