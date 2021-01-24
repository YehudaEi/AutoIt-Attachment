#include <GuiConstants.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <GuiImageList.au3>
#include <Array.au3>
;

Opt("WinWaitDelay", 0)
Opt("GuiOnEventMode", 1)

Global $aButtons_IDs[100][3]
Global $nLast_MsgID = 0, $iLast_ActiveID = 0, $hLast_Active_Win = 0

$hGUI = GUICreate("TasksBar Demo | © By G.Sandler [(Mr)CreatoR - CreatoR's Lab - www.creator-lab.ucoz.ru]", _
	@DesktopWidth-5, 30, 0, 0, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))

GUISetOnEvent($GUI_EVENT_CLOSE, "_Main_Events")
GUISetBkColor(0xFFF3E8)

_Init_TasksBar_Proc()
AdlibEnable("_Check_TasksBar_Synch_Proc", 300)

GUISetState(@SW_SHOWNOACTIVATE)

While 1
	Sleep(100)
WEnd

Func _Main_Events()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $aButtons_IDs[1][0] To $aButtons_IDs[$aButtons_IDs[0][0]][0]
			$nLast_MsgID = @GUI_CtrlId
			_Check_TasksBar_Synch_Proc()
	EndSwitch
EndFunc

Func _Init_TasksBar_Proc()
	Local $iLeft = 10, $sShortWinTitle, $sIcon_File, $iIcon_ID, $iID
	Local $aAppVisible_Wins = StringSplit(_WinListTaskBarWindows(), @CRLF, 1)
	If @error And $aAppVisible_Wins[1] = "" Then Return 0
	
	$hLast_Active_Win = 0
	
	For $i = 1 To $aAppVisible_Wins[0]
		$sShortWinTitle = _StringGetShortString($aAppVisible_Wins[$i], 23)
		$sIcon_File = _WinGetIconFile($aAppVisible_Wins[$i])
		$iIcon_ID = 0
		
		If _WinGetClassName($aAppVisible_Wins[$i]) = "CabinetWClass" Then $iIcon_ID = 13
		
		$iID = _GUICtrlCreateButton($sShortWinTitle, $iLeft, 3, 150, 25, BitOr($BS_PUSHLIKE, $BS_LEFT), -1, $sIcon_File, $iIcon_ID)
		_GUICtrlSetTheme($iID)
		GUICtrlSetOnEvent($iID, "_Main_Events")
		
		$aButtons_IDs[0][0] += 1
		$aButtons_IDs[$aButtons_IDs[0][0]][0] = $iID
		$aButtons_IDs[$aButtons_IDs[0][0]][1] = $aAppVisible_Wins[$i]
		$aButtons_IDs[$aButtons_IDs[0][0]][2] = WinGetHandle($aAppVisible_Wins[$i])
		
		If WinActive($aAppVisible_Wins[$i]) Then
			$iLast_ActiveID = $iID
			$hLast_Active_Win = $aButtons_IDs[$aButtons_IDs[0][0]][2]
			GUICtrlSetState($iID, $GUI_CHECKED)
		EndIf
		
		$iLeft += 153
	Next
EndFunc

Func _Check_TasksBar_Synch_Proc()
	Local $sAppVisible_Wins = _WinListTaskBarWindows() & @CRLF
	Local $sTasksBar_Wins = "", $iTasksBar_Wins_Count = 0, $iAppVisible_Wins_Count = 0, $iWin_Active_Count = 0, $sCheck_Title
	
	If $sAppVisible_Wins <> @CRLF Then
		StringReplace($sAppVisible_Wins, @CRLF, "")
		$iAppVisible_Wins_Count = @extended
	EndIf
	
	For $i = 1 To $aButtons_IDs[0][0]
		If $aButtons_IDs[$i][0] = $nLast_MsgID Then
			$iLast_ActiveID = $nLast_MsgID
			
			If $hLast_Active_Win = $aButtons_IDs[$i][2] Then
				$hLast_Active_Win = 0
				
				_GUICtrlSetState($aButtons_IDs[$i][0], $GUI_UNCHECKED)
				WinSetState($aButtons_IDs[$i][2], "", @SW_MINIMIZE)
				
				;SoundPlay(@WindowsDir & "\Media\Windows Minimize.wav", 0)
			Else
				;$hLast_Active_Win = $aButtons_IDs[$i][2]
				
				_GUICtrlSetState($aButtons_IDs[$i][0], $GUI_CHECKED)
				WinActivate($aButtons_IDs[$i][2])
				
				;SoundPlay(@WindowsDir & "\Media\Windows Restore.wav", 0)
			EndIf
		EndIf
		
		$sCheck_Title = WinGetTitle($aButtons_IDs[$i][2])
		
		If $sCheck_Title <> $aButtons_IDs[$i][1] Then
			$aButtons_IDs[$i][1] = $sCheck_Title
			GUICtrlSetData($aButtons_IDs[$i][0], _StringGetShortString($sCheck_Title, 23))
		EndIf
		
		$sTasksBar_Wins &= $aButtons_IDs[$i][1] & @CRLF
		$iTasksBar_Wins_Count += 1
		
		If WinActive($aButtons_IDs[$i][2]) Then
			$hLast_Active_Win = $aButtons_IDs[$i][2]
			_GUICtrlSetState($aButtons_IDs[$i][0], $GUI_CHECKED)
		Else
			_GUICtrlSetState($aButtons_IDs[$i][0], $GUI_UNCHECKED)
		EndIf
	Next
	
	If $sTasksBar_Wins <> $sAppVisible_Wins And $iTasksBar_Wins_Count <> $iAppVisible_Wins_Count Then
		For $i = 1 To $aButtons_IDs[0][0]
			GUICtrlDelete($aButtons_IDs[$i][0])
		Next
		
		$aButtons_IDs = 0
		Dim $aButtons_IDs[100][3]
		_Init_TasksBar_Proc()
	EndIf
	
	$nLast_MsgID = 0
EndFunc

Func _WinListTaskBarWindows($sTitle="", $sText="", $iIgnoreTitlessWins=1)
	Local $aWinList, $aWin_Pos, $sAppVisible_Wins = ""
	
	If $sTitle <> "" Then
		$aWinList = WinList($sTitle, $sText)
	Else
		$aWinList = WinList()
	EndIf
	
	For $i = 1 To $aWinList[0][0]
		If $iIgnoreTitlessWins And $aWinList[$i][0] = "" Then ContinueLoop ;To ignore windows without titles
		If $aWinList[$i][0] = "Program Manager" Then ContinueLoop
		
		;To ignore windows that is not visible to the eye :) ...
		$aWin_Pos = WinGetPos($aWinList[$i][1])
		If Not @error And $aWin_Pos[1] < (-$aWin_Pos[3])+5 And $aWin_Pos[0] <> -32000 Then ContinueLoop
		
		;If _WinIsAppWindow($aWinList[$i][1]) And _WinIsVisible($aWinList[$i][1]) Then $sAppVisible_Wins &= $aWinList[$i][0] & @CRLF
		If WinGetHandle($aWinList[$i][1]) <> $hGUI And _WinIsVisible($aWinList[$i][1]) Then _
			$sAppVisible_Wins &= $aWinList[$i][0] & @CRLF
	Next
	
	Return StringStripWS($sAppVisible_Wins, 2)
EndFunc

Func _WinIsAppWindow($hWnd)
	Local $iWindowStyle = _WinGetStyle($hWnd, 0)
	Local $iWindowExStyle = _WinGetStyle($hWnd, 1)
	
	Return _
		BitAND($iWindowStyle, $WS_EX_APPWINDOW) = $WS_EX_APPWINDOW Or _
		BitAND($iWindowExStyle, $WS_EX_APPWINDOW) = $WS_EX_APPWINDOW
EndFunc

Func _WinIsVisible($hWnd)
	Return BitAND(_WinGetStyle($hWnd), $WS_VISIBLE) = $WS_VISIBLE
EndFunc

Func _WinGetStyle($hWnd, $iIndex=0)
	Local Const $GWL_STYLE = -16, $GWL_EXSTYLE = -20
	
	Local $iGWL_Index = $GWL_STYLE
	If $iIndex > 0 Then $iGWL_Index = $GWL_EXSTYLE
	
	Local $aStyles = DllCall('User32.dll', 'long', 'GetWindowLong', 'hwnd', $hWnd, 'int', $iGWL_Index)
	Return $aStyles[0]
EndFunc

Func _WinGetClassName($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = WinGetHandle($hWnd)
	Local $aClassName = DLLCall("user32.dll", "int", "GetClassName", "hWnd", $hWnd, "str", "", "int", 256)
	
	If Not @error And $aClassName[0] <> 0 Then Return $aClassName[2]
	Return @error
EndFunc

Func _WinGetIconFile($sTitle, $sText="")
	Local $iPID = WinGetProcess($sTitle, $sText)
	If $iPID = -1 Then Return SetError(1, 0, 0)
	
	Local $aProc = DllCall('Kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
	If Not IsArray($aProc) Or Not $aProc[0] Then Return SetError(2, 0, -1)
	
	Local $vStruct = DllStructCreate('int[1024]')
	
	Local $hPsapi_Dll = DllOpen('Psapi.dll')
	If $hPsapi_Dll = -1 Then $hPsapi_Dll = DllOpen(@SystemDir & '\Psapi.dll')
	If $hPsapi_Dll = -1 Then $hPsapi_Dll = DllOpen(@WindowsDir & '\Psapi.dll')
	If $hPsapi_Dll = -1 Then Return SetError(3, 0, '')
	
    DllCall($hPsapi_Dll, 'int', 'EnumProcessModules', _
		'hwnd', $aProc[0], _
		'ptr', DllStructGetPtr($vStruct), _
		'int', DllStructGetSize($vStruct), _
		'int_ptr', 0)
	
	Local $aRet = DllCall($hPsapi_Dll, 'int', 'GetModuleFileNameEx', _
		'hwnd', $aProc[0], _
		'int', DllStructGetData($vStruct, 1), _
		'str', '', _
		'int', 2048)
	
	DllClose($hPsapi_Dll)
	
	If Not IsArray($aRet) Or StringLen($aRet[3]) = 0 Then Return SetError(4, 0, '')
	Return $aRet[3]
EndFunc

Func _GUICtrlSetTheme($hWnd, $iTheme=0)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	
	Local $aOld_Theme = DllCall("UxTheme.dll", "int", "GetWindowTheme", "hwnd", $hWnd)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", $hWnd, "wstr", $iTheme, "wstr", 0)
	
	Return $aOld_Theme[0]
EndFunc

Func _GUICtrlCreateButton($sText,$iLeft,$iTop,$iWidth=-1,$iHeight=-1,$nStyle=-1,$nExStyle=-1,$sIconFile='', $nIconID=0, $nAlign=-1)
	Local $nID = GUICtrlCreateRadio($sText, $iLeft, $iTop, $iWidth, $iHeight, $nStyle, $nExStyle)
	
	If $sIconFile = '' Then Return $nID
	
	Local $hIL = _GUIImageList_Create(16, 16, 5, BitOr($ILC_MASK, $ILC_COLOR32), 0, 1)
	Local $stIcon = DllStructCreate("int")
    _WinAPI_ExtractIconEx($sIconFile, $nIconID, DllStructGetPtr($stIcon), 0, 1)
	
	_GUIImageList_AddIcon($hIL, $sIconFile, $nIconID)
	_GUIImageList_DestroyIcon(DllStructGetData($stIcon, 1))
	
	Local $stBIL = DllStructCreate("dword;int[4];uint")
	
	DllStructSetData($stBIL, 1, $hIL)
    
    DllStructSetData($stBIL, 2, 1, 1)
    DllStructSetData($stBIL, 2, 1, 2)
    DllStructSetData($stBIL, 2, 1, 3)
    DllStructSetData($stBIL, 2, 1, 4)

	DllStructSetData($stBIL, 3, $nAlign)
    
	GUICtrlSendMsg($nID, $BCM_SETIMAGELIST, 0, DllStructGetPtr($stBIL))
	Return $nID
EndFunc

Func _GUICtrlSetState($iCtrlID, $sState)
	If Not BitAND(GUICtrlRead($iCtrlID), $sState) Then GUICtrlSetState($iCtrlID, $sState)
EndFunc

Func _StringGetShortString($sString, $iMaxRetLen = 30, $iShift = 0)
    Local $iString = StringLen($sString)
    If $iString <= $iMaxRetLen Then Return $sString

    Local $sMidl= "...", $iMidl = StringLen($sMidl)
    Local $iCut = $iString - $iMaxRetLen
    If $iCut < $iMidl Then $sMidl = StringLeft($sMidl, $iCut)

    $iMaxRetLen -= $iMidl
    If $iMaxRetLen < 0 Then $iMaxRetLen = 0

    Local $iEven = BitShift($iMaxRetLen, 1)
	
    If $iShift > $iEven Then $iShift = $iEven
    If $iShift < -$iEven Then $iShift = -$iEven
	
    Local $iLeft = $iEven + $iShift + BitAND($iMaxRetLen, 1)
    Local $iRight = $iEven - $iShift

	;$sString = StringRegExpReplace($sString, "(.{"& $iLeft &"}).*(.{"& $iRight &"})", "\1"& $sMidl &"\2")
	$sString = StringLeft($sString, $iLeft) & $sMidl & StringRight($sString, $iRight)

    Return $sString
EndFunc

