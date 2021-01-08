#include <GDIPlus.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <ButtonConstants.au3>
#include <Winapi.au3>
#include <Misc.au3>
#include <Process.au3>
#include <StaticConstants.au3>
#include <GuiConstants.au3>
#include <Constants.au3>
#include <GuiMenu.au3>
HotKeySet("{esc}","exitall")
$Struct = DllStructCreate("int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight;")
$sStruct = DllStructCreate("dword;int;ptr;int")
Global $aFactors[4] = [0.0, 0.6, 0.8, 1.0], $aPositions[4] = [0.0, 0.6, 0.8, 1.0]
Global $bGammaCorrection = False, $hbmp, $ongoing, $whoishovered, $iconwin
Global Const $AC_SRC_ALPHA = 1
setup()
	Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
	
	_Singleton("taskbar.exe", 0)
	global $transcolour="0x363636", $iconlist, $eyecandylist, $winlistall, $2ndsublist, $who=-1,$onlyonce=0,$timeupdate=0, $time, $timered=0
	Global $gw=@DesktopWidth,$gh=44, $iconheight=32, $pictureheight=$gh-$iconheight
	global $taskbar=GUICreate("taskbar", $gw, $gh,0,@DesktopHeight-44,$WS_POPUP, $WS_EX_TOOLWINDOW) ;,$WS_EX_LAYERED)
	GUISetState(@SW_SHOWNOACTIVATE, $taskbar)
	GUISetBkColor($transcolour,$taskbar)
	GUISetState()
	$proc1=0
dim $iconlist[10][4]
dim $winlist_previous[2][2]
dim $2ndsublist[10][6]
WinSetOnTop("taskbar","",1)
Global $date = GUICtrlCreatePic("", @DesktopWidth-103, 3, 100,40)
;GUIctrlSetBkColor($date,$transcolour)
If _Vista_ICE() Then

        _Vista_EnableBlurBehind($taskbar)

		 _Vista_EnableBlurBehind(GUICtrlGetHandle($date))
else	
	$Pic = GUICtrlCreatePic("", 0, 0, @DesktopWidth, 44)
	GUICtrlSetState(-1, $GUI_DISABLE)
	SetIcon($Pic,"", 0, @DesktopWidth, 44, $aFactors, $aPositions, "0x999999", "0x111111", 1)
;	SetIcon($date,"", 3, 100,40, $aFactors, $aPositions, "0x888888", newmessages(), 1,0,Update())
EndIf
	SetIcon($date,"", 3, 100,40, $aFactors, $aPositions, "0x888888", newmessages(), 1,0,Update())

AdlibEnable("hovering",300)

While 1
	
		Global $winlistall=_getwinlist()
		if $winlistall[0][1]>$winlist_previous[0][1] then
				icon_updater()
		ElseIf $winlistall[0][1]<$winlist_previous[0][1] then
				icon_reducer()
		EndIf
		$winlist_previous=$winlistall
	icon_changer()
sleep(1000)
if $timered>14 Then

if $time<>@MIN Then
	GUICtrlDelete($date)
Global $date = GUICtrlCreatePic("", @DesktopWidth-103, 3, 100,40)
SetIcon($date,"", 3, 100,40, $aFactors, $aPositions, "0x888888", newmessages(), 1,0,Update())
EndIf
$timered=0
Else
$timered=$timered+1
EndIf
;_ArrayDisplay($iconlist)
WEnd

Func OnAutoItExit()
	_WinAPI_DeleteObject($hbmp)
EndFunc
func _getwinlist ()
Local $sExclude_List = "|Start[CL:102939]|Start|Desktop|Start Menu[CL:102938]|taskbar|iconwin|desktop[CL:102937]|Program Manager|taskbar|Menu|Save As|Drag|"
Local $sExclude_class = "|tooltips_class32|gdkWindowToplevel|gdkWindowTempShadow|TaskSwitcherWnd|gdkWindowTemp|bosa_sdm_Microsoft Office Word 11.0|MsoCommandBarPopup|MsoCommandBarShadow|NUIDialog|CallTip|ThumbnailClass|#32770|Desktop User Picture|OfficeTooltip|"
Local $Listit
Local $aWinList = WinList()
dim $Listit[$aWinList[0][0]][5]
;Count windows

For $i = 1 To $aWinList[0][0]
;Only display visible windows that have a title
	If $aWinList[$i][0] = "" Or Not BitAND(WinGetState($aWinList[$i][1]), 2) Then ContinueLoop
;Add to array all win titles that is not in the exclude list
		$class = _WinAPI_GetClassName($aWinList[$i][1])
	If Not StringInStr($sExclude_List, "|" & $aWinList[$i][0] & "|") and Not StringInStr($sExclude_class, "|" & $class & "|") Then
		$Listit[0][1]=$Listit[0][1]+1
		$Listit[$Listit[0][1]][0]= _ProcessGetName (WinGetProcess($aWinList[$i][1]))
		$Listit[$Listit[0][1]][1]= $aWinList[$i][0]
		$Listit[$Listit[0][1]][2]= $aWinList[$i][1]
		$Listit[$Listit[0][1]][3]= $class
	EndIf 
Next
ReDim $Listit[$Listit[0][1]+1][5]
return $Listit
EndFunc

func icon_updater()
	
	for $i= 1 to $winlistall[0][1]
		SetError(0)
			$found =_ArraySearch($iconlist, $winlistall[$i][0], 0, 0, 0, 1)
			If not @error Then ContinueLoop
			$iconlist[0][0]=$iconlist[0][0]+1
			$iconlist[$iconlist[0][0]][0]= $winlistall[$i][0]
			$iconlist[$iconlist[0][0]][3]=$iconlist[0][0]*54
		icon_creator($iconlist[$iconlist[0][0]][0],$iconlist[0][0])
	Next
EndFunc

Func icon_creator($process,$arraynumber)
				$iconlist[$arraynumber][1] = GUICtrlCreatePic("", $iconlist[$arraynumber][3], 0, 54, 42)

				GUICtrlSetOnEvent($iconlist[$arraynumber][1],"actions")
				if $process=_ProcessGetName (WinGetProcess("","")) Then
					$iconlist[$arraynumber][2]=1
					local $colour="0x181818", $colour2="0x777777"
					local $line=1, $grade=1
				Else
					local $colour="0x333333", $colour2="0xF8F8F8"
					local $line=0, $grade=2
					$iconlist[$arraynumber][2]=0
				EndIf
				$a = _ProcessGetIcon($process)
				GUISetIcon($a)
				GUISwitch($taskbar)
				SetIcon($iconlist[$arraynumber][1],$a, 0, 54, 42, $aFactors, $aPositions, $colour, $colour2, $grade,$line)
				
				_WinAPI_RedrawWindow(GUICtrlGetHandle($iconlist[$arraynumber][1]))
EndFunc

func icon_reducer()
	$deletedicon=0
	for $i= 1 to $iconlist[0][0]
		SetError(0)
		$found =_ArraySearch($winlistall, $iconlist[$i][0], 0, 0, 0, 1)
		If not @error Then ContinueLoop
			$iconlist[$iconlist[0][0]][3]=$iconlist[$i][3]
						GUICtrlDelete($iconlist[$i][1])
			_ArrayDelete($iconlist,$i)
				$iconlist[0][0]=$iconlist[0][0]-1
			GUICtrlSetPos($iconlist[$iconlist[0][0]][1],$iconlist[$iconlist[0][0]][3],0)

					;_WinAPI_RedrawWindow(GUICtrlGetHandle($iconlist[$iconlist[0][0]][1]))
			ExitLoop
		Next
	;_WinAPI_RedrawWindow($taskbar,0,0,BitOR($RDW_ERASE,$RDW_INVALIDATE,$RDW_UPDATENOW,$RDW_FRAME,$RDW_ALLCHILDREN)) ; works, but redraws entire screen.
;_WinAPI_RedrawWindow($taskbar, "", "", BitOR($WM_ERASEBKGND, $RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
EndFunc
		
func icon_changer()
	$found =_ArraySearch($iconlist, _ProcessGetName (WinGetProcess("","")), 0, 0, 0, 1)
	if not @error Then
		if not $iconlist[$found][2]=1 Then
			GUICtrlDelete($iconlist[$found][1])
			icon_creator($iconlist[$found][0],$found)
		;	_WinAPI_RedrawWindow(GUICtrlGetHandle($iconlist[$iconlist[0][0]][1]))
			$iconlist[$found][2]=1
		EndIf
		for $i=1 to $iconlist[0][0]
			if $iconlist[$i][2]=1 and $i<>$found then
				GUICtrlDelete($iconlist[$i][1])
				icon_creator($iconlist[$i][0],$i)
			;	_WinAPI_RedrawWindow(GUICtrlGetHandle($iconlist[$i][1]))
				$iconlist[$i][2]=0
			EndIf
		Next
	EndIf		
EndFunc
		
Func FillArray($sData)
    Local $aDataSplit
    $aDataSplit = StringSplit(StringStripWS($sData, 8), ",")
    If $aDataSplit[0] < 2 Then
        MsgBox(0, "Error", "Must have at lease two (2) entries in input box", 2)
        Return 1
    Else
        Local $aRetArray[$aDataSplit[0]]
        For $x = 0 To UBound($aRetArray) - 1
            $aRetArray[$x] = $aDataSplit[$x + 1]
        Next
        Return $aRetArray
    EndIf
EndFunc   ;==>FillArray

func SetIcon($controlID, $sIcon, $iIndex, $iWidth, $iHeight, $aFactors, $aPositions, $iClr1="0x111111", $iClr2="0x999999", $iDirection=2, $pressed=0,$string="")
    const $STM_SETIMAGE = 0x0172
    local $tIcon, $tID, $hDC, $hBackDC, $hBackSv, $hBitmap, $hImage, $hIcon, $hBkIcon
   Local $w=$iWidth-32, $h=$iHeight-32
    $tIcon = DllStructCreate('hwnd')
    $tID = DllStructCreate('hwnd')

     _GDIPlus_Startup()
    Local Const $IMAGE_BITMAP = 0
    Local $hWnd, $iC1, $iC2, $hBitmap, $hImage, $hGraphic, $hBrushLin, $hbmp, $aBmp
    $hWnd = GUICtrlGetHandle($controlID)
    $iC1 = StringReplace($iClr1, "0x", "0xFF")
    $iC2 = StringReplace($iClr2, "0x", "0xFF")
    $hBitmap = _WinAPI_CreateBitmap($iWidth, $iHeight, 1, 32)
    $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
    $hBrushLin = _GDIPlus_CreateLineBrushFromRect(0, 0, $iWidth, $iHeight, $aFactors, $aPositions, $iC1, $iC2, $iDirection)
    GDIPlus_SetLineGammaCorrection($hBrushLin, $bGammaCorrection)
    _GDIPlus_GraphicsFillRect($hGraphic, 0+$pressed, 0, $iWidth-$pressed*2, $iHeight, $hBrushLin)
	if not $string="" then _GDIPlus_GraphicsDrawString($hGraphic,$string,2, 2,"arial",12)
	$hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
 
	if not $sIcon="" Then
		$hIcon = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', 32, 'int', 32, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)
		if (@error) or ($hIcon[0] = 0) then
			return SetError(1, 0, 0)
		endif
		$hIcon = DllStructGetData($tIcon, 1)
		$tIcon = 0
		$tID = 0

		$hDC = _WinAPI_GetDC(0)
		$hBackDC = _WinAPI_CreateCompatibleDC($hDC)
		;$hBitmap = _WinAPI_CreateSolidBitmap(0, $iBackground, $iWidth, $iHeight)
		$hBackSv = _WinAPI_SelectObject($hBackDC, $hbmp)
		If $hIcon <> 0 Then _WinAPI_DrawIconEx($hBackDC, $w/2, $h/2, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
	EndIf
     $aBmp = DllCall("user32.dll", "hwnd", "SendMessage", "hwnd", $hWnd, "int", $STM_SETIMAGE, "int", $IMAGE_BITMAP, "int", $hbmp)
    If $aBmp[0] <> 0 Then _WinAPI_DeleteObject($aBmp[0])
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_BrushDispose($hBrushLin)
    _GDIPlus_GraphicsDispose($hGraphic)
;   _WinAPI_DeleteObject($hbmp)

    _GDIPlus_Shutdown()
_WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteObject($hIcon)

if $sIcon="" Then Return SetError(0, 0, 1)
 _WinAPI_SelectObject($hBackDC, $hBackSv)
    _WinAPI_DeleteDC($hBackDC)
    _WinAPI_ReleaseDC(0, $hDC)
    return SetError(0, 0, 1)
endfunc; SetIcon
Func _Quit()
    Exit
EndFunc   ;==>_Quit

;==== GDIPlus_CreateLineBrushFromRect === Malkey's function
;Description - Creates a LinearGradientBrush object from a set of boundary points and boundary colors.
; $aFactors - If non-array, default array will be used.
;           Pointer to an array of real numbers that specify blend factors. Each number in the array
;           specifies a percentage of the ending color and should be in the range from 0.0 through 1.0.
;$aPositions - If non-array, default array will be used.
;            Pointer to an array of real numbers that specify blend factors' positions. Each number in the array
;            indicates a percentage of the distance between the starting boundary and the ending boundary
;            and is in the range from 0.0 through 1.0, where 0.0 indicates the starting boundary of the
;            gradient and 1.0 indicates the ending boundary. There must be at least two positions
;            specified: the first position, which is always 0.0, and the last position, which is always
;            1.0. Otherwise, the behavior is undefined. A blend position between 0.0 and 1.0 indicates a
;            line, parallel to the boundary lines, that is a certain fraction of the distance from the
;            starting boundary to the ending boundary. For example, a blend position of 0.7 indicates
;            the line that is 70 percent of the distance from the starting boundary to the ending boundary.
;            The color is constant on lines that are parallel to the boundary lines.
; $iArgb1    - First Top color in 0xAARRGGBB format
; $iArgb2    - Second color in 0xAARRGGBB format
; $LinearGradientMode -  LinearGradientModeHorizontal       = 0x00000000,
;                        LinearGradientModeVertical         = 0x00000001,
;                        LinearGradientModeForwardDiagonal  = 0x00000002,
;                        LinearGradientModeBackwardDiagonal = 0x00000003
; $WrapMode  - WrapModeTile       = 0,
;              WrapModeTileFlipX  = 1,
;              WrapModeTileFlipY  = 2,
;              WrapModeTileFlipXY = 3,
;              WrapModeClamp      = 4
; GdipCreateLineBrushFromRect(GDIPCONST GpRectF* rect, ARGB color1, ARGB color2,
;             LinearGradientMode mode, GpWrapMode wrapMode, GpLineGradient **lineGradient)
; Reference:  http://msdn.microsoft.com/en-us/library/ms534043(VS.85).aspx
;
Func _GDIPlus_CreateLineBrushFromRect($iX, $iY, $iWidth, $iHeight, $aFactors, $aPositions, _
        $iArgb1 = 0xFF0000FF, $iArgb2 = 0xFFFF0000, $LinearGradientMode = 0x00000001, $WrapMode = 0)

    Local $tRect, $pRect, $aRet, $tFactors, $pFactors, $tPositions, $pPositions, $iCount

    If $iArgb1 = Default Then $iArgb1 = 0xFF0000FF
    If $iArgb2 = Default Then $iArgb2 = 0xFFFF0000
    If $LinearGradientMode = -1 Or $LinearGradientMode = Default Then $LinearGradientMode = 0x00000001
    If $WrapMode = -1 Or $LinearGradientMode = Default Then $WrapMode = 1

    $tRect = DllStructCreate("float X;float Y;float Width;float Height")
    $pRect = DllStructGetPtr($tRect)
    DllStructSetData($tRect, "X", $iX)
    DllStructSetData($tRect, "Y", $iY)
    DllStructSetData($tRect, "Width", $iWidth)
    DllStructSetData($tRect, "Height", $iHeight)

    ;Note: Withn _GDIPlus_Startup(), $ghGDIPDll is defined
    $aRet = DllCall($ghGDIPDll, "int", "GdipCreateLineBrushFromRect", "ptr", $pRect, "int", $iArgb1, _
            "int", $iArgb2, "int", $LinearGradientMode, "int", $WrapMode, "int*", 0)

    If IsArray($aFactors) = 0 Then Dim $aFactors[4] = [0.0, 0.4, 0.6, 1.0]
    If IsArray($aPositions) = 0 Then Dim $aPositions[4] = [0.0, 0.3, 0.7, 1.0]

    $iCount = UBound($aPositions)
    $tFactors = DllStructCreate("float[" & $iCount & "]")
    $pFactors = DllStructGetPtr($tFactors)
    For $iI = 0 To $iCount - 1
        DllStructSetData($tFactors, 1, $aFactors[$iI], $iI + 1)
    Next
    $tPositions = DllStructCreate("float[" & $iCount & "]")
    $pPositions = DllStructGetPtr($tPositions)
    For $iI = 0 To $iCount - 1
        DllStructSetData($tPositions, 1, $aPositions[$iI], $iI + 1)
    Next

    $hStatus = DllCall($ghGDIPDll, "int", "GdipSetLineBlend", "hwnd", $aRet[6], _
            "ptr", $pFactors, "ptr", $pPositions, "int", $iCount)
    Return $aRet[6] ; Handle of Line Brush
EndFunc   ;==>_GDIPlus_CreateLineBrushFromRect

;===========================================================
; Description:  Specifies whether gamma correction is enabled for this linear gradient brush.
; Parameters
; $hBrush             - [in] Pointer to the LinearGradientBrush object.
; $useGammaCorrection - [in] Boolean value that specifies whether gamma correction occurs
;                     during rendering. TRUE specifies that gamma correction is enabled,
;                     and FALSE specifies that gamma correction is not enabled. By default,
;                     gamma correction is disabled during construction of a
;                     LinearGradientBrush object.
;GdipSetLineGammaCorrection(GpLineGradient *brush, BOOL useGammaCorrection)
;
Func GDIPlus_SetLineGammaCorrection($hBrush, $useGammaCorrection = True)
    Local $aResult  
    $aResult = DllCall($ghGDIPDll, "int", "GdipSetLineGammaCorrection", "hwnd", $hBrush, "int", $useGammaCorrection)
    Return $aResult[0]
EndFunc   ;==>GDIPlus_SetLineGammaCorrection

Func _ProcessGetIcon($vProcess)
    Local $iPID = ProcessExists($vProcess)
    If Not $iPID Then Return SetError(1, 0, -1)
    Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
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

Func actions()
if IsArray($iconlist)=1 and IsArray($winlistall)=1 Then
	GUISwitch($taskbar)
		$found =_ArraySearch($iconlist, @GUI_CTRLID, 0, 0, 0, 3)
for $i=1 to $iconlist[0][0]
	if $iconlist[$i][1]= @GUI_CTRLID Then
		$onit=$iconlist[$i][0]
		ExitLoop
	EndIf
Next
for $j= 1 to $winlistall[0][1]
	if $winlistall[$j][0] = $onit Then
		WinActivate($winlistall[$j][2])
		ExitLoop
	EndIf
Next
EndIf
EndFunc




func hovering()
if WinExists($taskbar) Then
	$hover=GUIGetCursorInfo(WinGetHandle($taskbar,""))
	if $hover[4]<>0 and not WinExists("iconwin") and IsArray($iconlist)=1 and IsArray($winlistall)=1 and IsArray($2ndsublist)=1 then
		for $i= 1 to $iconlist[0][0]
			If $iconlist[$i][1]=$hover[4] Then
				$whoishovered=$iconlist[$i][1]
				dim $2ndsublist[20][7]
				Global $iconwin=GUICreate("iconwin", 550, 500,5,@DesktopHeight-544,$WS_POPUP, bitor($WS_EX_TOOLWINDOW,$WS_EX_LAYERED))
				GUISetState(@SW_SHOWNOACTIVATE, $iconwin)
				WinSetOnTop("iconwin","",1)
				GUISetBkColor($transcolour, $iconwin)
				$bottom=470
				for $k= 1 to $winlistall[0][1]
					if $iconlist[$i][0]=$winlistall[$k][0] Then
				;		$2ndsublist[$k][0]=$winlistall[$k][0]
				if StringLen($winlistall[$k][1])>62 Then
					$2ndsublist[$k][1]=StringLeft($winlistall[$k][1],62)&"..."
				Else
					$2ndsublist[$k][1]=$winlistall[$k][1]
				EndIf
					;	$2ndsublist[$k][1]=$winlistall[$k][1]
						$2ndsublist[$k][0]=$winlistall[$k][2]
						$2ndsublist[$k][4]=0
					if WinActive($2ndsublist[$k][0]) Then
					local $colour="0x555555"
					$2ndsublist[$k][3]=1
					Else
					local $colour="0x888888"
					$2ndsublist[$k][3]=0
					EndIf
					;GUICtrlSetOnEvent($nothing,"actionslist")
						$2ndsublist[$k][2] = GUICtrlCreateLabel($2ndsublist[$k][1], 0, $bottom, 550, 30)
						GUICtrlSetOnEvent($2ndsublist[$k][2],"subactions")
						GUICtrlSetBkColor(-1,$colour)
						GUICtrlSetFont(-1,14,400,"Arial")
						$bottom=$bottom-30
					EndIf
				Next
				;_ArrayDisplay($2ndsublist)
				_API_SetLayeredWindowAttributes($iconwin,$transcolour)
				GUISetState(@SW_SHOW,$iconwin)
				Return
			EndIf
		Next
	elseif $hover[4]<>$whoishovered and WinExists("iconwin") then
		$hover=GUIGetCursorInfo(WinGetHandle($iconwin,""))
		if $hover[4]=0 then GUIDelete($iconwin)
	EndIf
EndIf
if WinExists("iconwin") Then
	$hover=GUIGetCursorInfo(WinGetHandle($iconwin,""))
	if $hover[4]<>0 and IsArray($iconlist)=1 and IsArray($winlistall)=1 and IsArray($2ndsublist)=1 then
		for $i=1 to UBound($2ndsublist)-1
			if $2ndsublist[$i][2]=$hover[4] and $2ndsublist[$i][4]<>1 Then
				for $k=1 to UBound($2ndsublist)-1
					if $2ndsublist[$k][4]=1 Then
						if WinActive($2ndsublist[$k][0]) Then
							GUICtrlSetBkColor($2ndsublist[$k][2],0x555555)
						Else
							GUICtrlSetBkColor($2ndsublist[$k][2],0x888888)
						EndIf
						$2ndsublist[$k][4]=0
					EndIf
				Next
				$2ndsublist[$i][4]=1
				GUICtrlSetBkColor($2ndsublist[$i][2],0x3090C7)
			;	_ArrayDisplay($2ndsublist)
				ExitLoop
			EndIf
		Next
	EndIf
EndIf
GUISwitch($taskbar)

EndFunc

Func subactions()
for $i = 1 to UBound($2ndsublist)-1
	;ToolTip(@GUI_CtrlId&$2ndsublist[$i][1])
if @GUI_CTRLID=$2ndsublist[$i][2] then
	WinActivate($2ndsublist[$i][0])
ExitLoop
EndIf
Next
GUIDelete($iconwin)
EndFunc

;===============================================================================
;
; Function Name:   _API_SetLayeredWindowAttributes
; Description::    Sets Layered Window Attributes:) See MSDN for more informaion
; Parameter(s):   
;                  $hwnd - Handle of GUI to work on
;                  $i_transcolor - Transparent color
;                  $Transparency - Set Transparancy of GUI
;                  $isColorRef - If True, $i_transcolor is a COLORREF-Strucure, else an RGB-Color
; Requirement(s):  Layered Windows
; Return Value(s): Success: 1
;                  Error: 0
;                   @error: 1 to 3 - Error from DllCall
;                   @error: 4 - Function did not succeed - use
;                               _WinAPI_GetLastErrorMessage or _WinAPI_GetLastError to get more information
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _API_SetLayeredWindowAttributes($hwnd, $i_transcolor, $Transparency = 255, $isColorRef = False)
   
Local Const $AC_SRC_ALPHA = 1
Local Const $ULW_ALPHA = 2
Local Const $LWA_ALPHA = 0x2
Local Const $LWA_COLORKEY = 0x1
    If Not $isColorRef Then
        $i_transcolor = Hex(String($i_transcolor), 6)
        $i_transcolor = Execute('0x00' & StringMid($i_transcolor, 5, 2) & StringMid($i_transcolor, 3, 2) & StringMid($i_transcolor, 1, 2))
    EndIf
    Local $Ret = DllCall("user32.dll", "int", "SetLayeredWindowAttributes", "hwnd", $hwnd, "long", $i_transcolor, "byte", $Transparency, "long", $LWA_COLORKEY + $LWA_ALPHA)
    Select
        Case @error
            Return SetError(@error,0,0)
        Case $ret[0] = 0
            Return SetError(4,0,0)
        Case Else
            Return 1
    EndSelect
EndFunc;==>_API_SetLayeredWindowAttributes

Func Update()
$h = @HOUR
$m = @MIN
$time=$m
If $h<10 then $h=StringRight($h,1)
If $h > 12 Then
$h = $h - 12
$m = $m & " PM"
Else
If $h = 12 Then
$m = $m & " PM"
Else
$m = $m & " AM"
EndIf
EndIf
$variable= $h & ":" & $m&@CRLF&GetDayOfWeek() & " " & GetMonth() & " " & @MDAY

Return $variable
EndFunc


Func GetDayOfWeek()
    Return _WinAPI_GetLocaleInfo(_WinAPI_GetUserDefaultLCID(), 49 + Mod(@WDAY + 5, 7))
EndFunc   ;==>GetDayOfWeek

Func GetMonth()
    Return _WinAPI_GetLocaleInfo(_WinAPI_GetUserDefaultLCID(), 67 + @MON)
EndFunc   ;==>GetMonth

Func Getyear()
    Return StringRight(@YEAR, 2)
EndFunc   ;==>Getyear

Func _WinAPI_GetLocaleInfo($Locale, $LCType)
    Local $aResult = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", $Locale, "long", $LCType, "ptr", 0, "long", 0)
    If @error Then Return SetError(1, 0, "")
    Local $lpBuffer = DllStructCreate("char[" & $aResult[0] & "]")
    $aResult = DllCall("kernel32.dll", "long", "GetLocaleInfo", "long", $Locale, "long", $LCType, "ptr", DllStructGetPtr($lpBuffer), "long", $aResult[0])
    If @error Or ($aResult[0] = 0) Then Return SetError(1, 0, "")
    Return SetError(0, 0, DllStructGetData($lpBuffer, 1))
EndFunc

Func _WinAPI_GetUserDefaultLCID()
    Local $aResult = DllCall("kernel32.dll", "long", "GetUserDefaultLCID") ; Get the default LCID for this user
    If @error Then Return SetError(1, 0, 0)
    Return SetError(0, 0, $aResult[0])
EndFunc

Func newmessages()
if ProcessExists("Outlook.exe") then

	$strsubject=""
	$otl = ObjCreate("Outlook.Application")
	$session = $otl.GetNameSpace("MAPI")
	$inbox = $session.GetDefaultFolder(6)
	$c=0
	For $m In $inbox.items
		If $m.unread Then
			$c = $c + 1
		EndIf
	Next
	$session.logoff
	
	if $c>0 Then
		$col= "0x666666"
	Else
		$col="0x736F6E"
	EndIf
else
	$col="0x736F6E"
EndIf

return $col

EndFunc

func exitall()
exit 0
EndFunc

func setup()
	Global Const $SPIF_SENDCHANGE = 0x0002
	$Structure = DllStructCreate("int var1; int var2; int var3; int var4")
	DllStructSetData($Structure, "var1", 0)
	DllStructSetData($Structure, "var2", 0)
	DllStructSetData($Structure, "var3", @DesktopWidth)
	DllStructSetData($Structure, "var4", @DesktopHeight-46)
	DllCall("user32.dll", "int", "SystemParametersInfo", "uint", 0x002F, "uint", 0, "ptr", DllStructGetPtr($Structure), "uint", $SPIF_SENDCHANGE)
EndFunc



; #FUNCTION#;===============================================================================
;
; Name...........: _Vista_ApplyGlass
; Description ...: Applys glass effect to a window
; Syntax.........: _Vista_ApplyGlass($hWnd, [$bColor)
; Parameters ....: $hWnd - Window handle:
;                  $bColor  - Background color
; Return values .: Success - No return
;                  Failure - Returns 0
; Author ........: James Brooks
; Modified.......:
; Remarks .......: Thanks to weaponx!
; Related .......:
; Link ..........;
; Example .......; Yes
;
;;==========================================================================================
Func _Vista_ApplyGlass($hWnd, $bColor = 0x000000)
     If @OSVersion <> "WIN_VISTA" Then
         MsgBox(16, "_Vista_ApplyGlass", "You are not running Vista!")
         Exit
     Else
         GUISetBkColor($bColor); Must be here!
         $Ret = DllCall("dwmapi.dll", "long", "DwmExtendFrameIntoClientArea", "hwnd", $hWnd, "long*", DllStructGetPtr($Struct))
         If @error Then
             Return 0
             SetError(1)
         Else
             Return $Ret
         EndIf
     EndIf
EndFunc ;==>_Vista_ApplyGlass

; #FUNCTION#;===============================================================================
;
; Name...........: _Vista_ApplyGlassArea
; Description ...: Applys glass effect to a window area
; Syntax.........: _Vista_ApplyGlassArea($hWnd, $Area, [$bColor)
; Parameters ....: $hWnd - Window handle:
;                   $Area - Array containing area points
;                  $bColor  - Background color
; Return values .: Success - No return
;                  Failure - Returns 0
; Author ........: James Brooks
; Modified.......:
; Remarks .......: Thanks to monoceres!
; Related .......:
; Link ..........;
; Example .......; Yes
;
;;==========================================================================================
Func _Vista_ApplyGlassArea($hWnd, $Area, $bColor = 0x000000)
     If @OSVersion <> "WIN_VISTA" Then
         MsgBox(16, "_Vista_ApplyGlass", "You are not running Vista!")
         Exit
     Else
         If IsArray($Area) Then
             DllStructSetData($Struct, "cxLeftWidth", $Area[0])
             DllStructSetData($Struct, "cxRightWidth", $Area[1])
             DllStructSetData($Struct, "cyTopHeight", $Area[2])
             DllStructSetData($Struct, "cyBottomHeight", $Area[3])
             GUISetBkColor($bColor); Must be here!
             $Ret = DllCall("dwmapi.dll", "long*", "DwmExtendFrameIntoClientArea", "hwnd", $hWnd, "ptr", DllStructGetPtr($Struct))
             If @error Then
                 Return 0
             Else
                 Return $Ret
             EndIf
         Else
             MsgBox(16, "_Vista_ApplyGlassArea", "Area specified is not an array!")
         EndIf
     EndIf
EndFunc ;==>_Vista_ApplyGlassArea

; #FUNCTION#;===============================================================================
;
; Name...........: _Vista_EnableBlurBehind
; Description ...: Enables the blur effect on the provided window handle.
; Syntax.........: _Vista_EnableBlurBehind($hWnd)
; Parameters ....: $hWnd - Window handle:
; Return values .: Success - No return
;                  Failure - Returns 0
; Author ........: James Brooks
; Modified.......:
; Remarks .......: Thanks to komalo
; Related .......:
; Link ..........;
; Example .......; Yes
;
;;==========================================================================================
Func _Vista_EnableBlurBehind($hWnd, $bColor = 0x000000)
     If @OSVersion <> "WIN_VISTA" Then
         MsgBox(16, "_Vista_ApplyGlass", "You are not running Vista!")
         Exit
     Else
         Const $DWM_BB_ENABLE = 0x00000001

         DllStructSetData($sStruct, 1, $DWM_BB_ENABLE)
         DllStructSetData($sStruct, 2, "1")
         DllStructSetData($sStruct, 4, "1")

         GUISetBkColor($bColor); Must be here!
         $Ret = DllCall("dwmapi.dll", "int", "DwmEnableBlurBehindWindow", "hwnd", $hWnd, "ptr", DllStructGetPtr($sStruct))
         If @error Then
             Return 0
         Else
             Return $Ret
         EndIf
     EndIf
EndFunc ;==>_Vista_EnableBlurBehind

; #FUNCTION#;===============================================================================
;
; Name...........: _Vista_ICE
; Description ...: Returns 1 if DWM is enabled or 0 if not
; Syntax.........: _Vista_ICE()
; Parameters ....: 
; Return values .: Success - Returns 1
;                  Failure - Returns 0
; Author ........: James Brooks
; Modified.......:
; Remarks .......: Thanks to BrettF
; Related .......:
; Link ..........;
; Example .......; Yes
;
;;==========================================================================================
Func _Vista_ICE()
     $ICEStruct = DllStructCreate("int;")
     $Ret = DllCall("dwmapi.dll", "int", "DwmIsCompositionEnabled", "ptr", DllStructGetPtr($ICEStruct))
     If @error Then
         Return 0
     Else
         Return DllStructGetData($ICEStruct, 1)
     EndIf
EndFunc ;==>_Vista_ICE