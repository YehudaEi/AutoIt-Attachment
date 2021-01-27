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
#include <EditConstants.au3> 
#include <GuiImageList.au3>
#include <GuiButton.au3>
#include <GuiStatusBar.au3>
HotKeySet("+{esc}","exitall")
Global $aFactors[4] = [0.0, 0.6, 0.8, 1.0], $aPositions[4] = [0.0, 0.6, 0.8, 1.0]
Global $bGammaCorrection = False, $hbmp, $ongoing, $whoishovered, $iconwin, $trans, $taskbar, $bckcolour, $date
Global Const $AC_SRC_ALPHA = 1
Global $iconlist, $2ndcloselist, $shorton=0, $contextmenu, $maincontext, $pinnedfromini
Global $WM_DROPFILES = 0x233, $dll = DllOpen("user32.dll")
Global $gaDropFiles[1], $str = "", $Pic
if not FileExists("taskbar.ini") then writetheini()
	Dim $2ndcloselist[20]
	;changes workspace dimensions
	Global Const $SPIF_SENDCHANGE = 0x0002
	$Structure = DllStructCreate("int var1; int var2; int var3; int var4")
	DllStructSetData($Structure, "var1", 0)
	DllStructSetData($Structure, "var2", 0)
	DllStructSetData($Structure, "var3", @DesktopWidth)
	DllStructSetData($Structure, "var4", @DesktopHeight-46)
	DllCall("user32.dll", "int", "SystemParametersInfo", "uint", 0x002F, "uint", 0, "ptr", DllStructGetPtr($Structure), "uint", $SPIF_SENDCHANGE)

	Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
;;;;;;;;Needed for shellhook
Global $DoubleClicked = 0, $clicked = 0, $current_viz = 1
Global Const $HSHELL_WINDOWCREATED = 1;
Global Const $HSHELL_WINDOWDESTROYED = 2;
Global Const $HSHELL_WINDOWACTIVATED = 4;
Global $bHook = 1, $shortsfromini
Global $previous_hwnd = "", $previous_title = ""
Global $current_hwnd = ""
Global $tooltip_display1 = ""
Global $tooltip_display2 = ""

	;;;;;;;;;;;;;;;;;;;
	_Singleton("taskbar.exe", 0)
	global $transcolour="0x363636", $iconlist, $eyecandylist, $winlistall, $2ndsublist, $who=-1,$onlyonce=0,$timeupdate=0, $time, $timered=0
	Global $gw=@DesktopWidth,$gh=44, $iconheight=32, $pictureheight=$gh-$iconheight, $pinned, $totalavoided=0
		global $taskbar=GUICreate("taskbar", $gw, $gh,0,@DesktopHeight-44,$WS_POPUP, BitOR($WS_EX_ACCEPTFILES,$WS_EX_TOOLWINDOW)) ;,$WS_EX_LAYERED)
	GUISetState(@SW_SHOWNOACTIVATE, $taskbar)
WinSetOnTop("taskbar","",1)
setup()

;;;;;;;;;;;;shellhook again
GUIRegisterMsg(RegisterWindowMessage("SHELLHOOK"), "HShellWndProc")
ShellHookWindow($taskbar, $bHook)
	dim $iconlist[20][5]
	dim $winlist_previous[2][2]
pinned()
Global $esmNO = 0
;;;;;;;;;;;;Needed to identify double clicks
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg(0x0232, "ESM");$WM_EXITSIZEMOVE

AdlibEnable("hovering",100)
GUIRegisterMsg ($WM_DROPFILES, "WM_DROPFILES_UNICODE_FUNC")
GUISetOnEvent($GUI_EVENT_SECONDARYdown,"rightmouse")
_ShowTaskBar(IniRead("taskbar.ini","userchoose","taskbar","0"))
While 1

switchitup()
sleep(7000)
if $timered>1 Then

if $time<>@MIN Then
	GUICtrlDelete($date)
Global $date = GUICtrlCreatePic("", @DesktopWidth-103, 3, 100,40)
GUICtrlSetOnEvent($date,"actions")
SetIcon($date,"", 3, 100,40, $aFactors, $aPositions, $bckcolour[1], newmessages(), 1,0,Update())
_WinAPI_DeleteObject($hbmp)
EndIf
$timered=0
Else
$timered=$timered+1
EndIf
;_ArrayDisplay($iconlist)
WEnd

func setup()
		$chosencolour=IniRead("taskbar.ini","userchoose","colour","gray")
		global $trans=IniRead("taskbar.ini","userchoose","transparency","255")
		if $trans>255 then
			$trans=255
			Iniwrite("taskbar.ini","userchoose","transparency","255")
		elseif $trans<25 then
			$trans=25
			Iniwrite("taskbar.ini","userchoose","transparency","25")
		EndIf

	$colourlist=IniRead("taskbar.ini","colours",$chosencolour,"")
	Global $bckcolour=StringSplit($colourlist,";",1)
	$proc1=0
		dim $2ndsublist[20][6]
dim $pinned[10][5]
$Pic = GUICtrlCreatePic("", 0, 0, @DesktopWidth, 44)
GUICtrlSetState(-1, $GUI_DISABLE)

SetIcon($Pic,"", 0, @DesktopWidth, 44, $aFactors, $aPositions, $bckcolour[1], $bckcolour[2], 1)
Global $date = GUICtrlCreatePic("", @DesktopWidth-103, 3, 100,40)
SetIcon($date,"", 3, 100,40, $aFactors, $aPositions, $bckcolour[1], newmessages(), 1,0,Update())
GUICtrlSetOnEvent($date,"actions")

EndFunc


func exitall()
	_WinAPI_DeleteObject($hbmp)
	_ShowTaskBar(0)
	exit 0
EndFunc

func _getwinlist ()
Local $sExclude_List = "|Start[CL:102939]|Start|Desktop|Start Menu[CL:102938]|taskbar|iconwin|desktop[CL:102937]|Program Manager|taskbar|Menu|Save As|Drag|maincontext|context|"
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
	$avoidminus=0
	$totalavo=0
	_ArraySort($winlistall,0,1,0)
	for $i= 1 to $winlistall[0][1]
		SetError(0)
			$found =_ArraySearch($iconlist, $winlistall[$i][0], 0, 0, 0, 1)
			If not @error Then ContinueLoop
			
			$iconlist[0][0]=$iconlist[0][0]+1
			$iconlist[$iconlist[0][0]][0]= $winlistall[$i][0]
			$iconlist[$iconlist[0][0]][4] = _ProcessGetIcon($iconlist[$iconlist[0][0]][0])
			$avoidme=0
			for $y= 1 to $pinned[0][1]
				if $iconlist[$iconlist[0][0]][4]=$pinned[$y][1] Then
					GUICtrlDelete($pinned[$y][2])
					if $y=1 then $avoidme=1
					$avoidminus=$avoidminus+54
					$iconlist[$iconlist[0][0]][3]=$pinned[$y][3]
					$totalavo=$totalavo+1
				EndIf
			Next	
			if $iconlist[$iconlist[0][0]][3]="" and $avoidme=0 then $iconlist[$iconlist[0][0]][3]=$pinned[$pinned[0][1]][3]+$iconlist[0][0]*54-$avoidminus-$totalavoided*54
			
		icon_creator($iconlist[$iconlist[0][0]][0],$iconlist[0][0])
	Next
	$totalavoided=$totalavo+$totalavoided
EndFunc

Func icon_creator($process,$arraynumber)
	GUISwitch($taskbar)
				$iconlist[$arraynumber][1] = GUICtrlCreatePic("", $iconlist[$arraynumber][3], 0, 54, 42)
				;$iconlist[$arraynumber][4] = _ProcessGetIcon($iconlist[$arraynumber][0])
				GUICtrlSetOnEvent($iconlist[$arraynumber][1],"actions")
				if $iconlist[$arraynumber][0]=_ProcessGetName (WinGetProcess("","")) Then
					$iconlist[$arraynumber][2]=1
					local $colour=$bckcolour[2], $colour2=$bckcolour[3]
					local $line=1, $grade=1
				Else
					local $colour=$bckcolour[4], $colour2=$bckcolour[1]
					local $line=0, $grade=2
					$iconlist[$arraynumber][2]=0
				EndIf
				GUISetIcon($iconlist[$arraynumber][4])
				GUISwitch($taskbar)
				SetIcon($iconlist[$arraynumber][1],$iconlist[$arraynumber][4], 0, 54, 42, $aFactors, $aPositions, $colour, $colour2, $grade,$line)
				
				_WinAPI_RedrawWindow(GUICtrlGetHandle($iconlist[$arraynumber][1]))

EndFunc

func icon_reducer()
	$deletedicon=0
	for $i= 1 to $iconlist[0][0]
		SetError(0)
		$found =_ArraySearch($winlistall, $iconlist[$i][0], 0, 0, 0, 1)
		If not @error Then ContinueLoop
			$avoidme=0
			GUICtrlDelete($iconlist[$i][1])	
			for $y= 1 to $pinned[0][1]
				if $iconlist[$i][4]=$pinned[$y][1] Then
					GUISwitch($taskbar)
					$pinned[$y][2] = GUICtrlCreatePic("", $iconlist[$i][3], 0, 54, 42)
					GUICtrlSetOnEvent($pinned[$y][2],"pinnedactions")
					SetIcon($pinned[$y][2],$pinned[$y][1], 0, 54, 42, $aFactors, $aPositions, $bckcolour[1], $bckcolour[2], 1,0)
					_WinAPI_RedrawWindow(GUICtrlGetHandle($pinned[$y][2]))
					$avoidme=1
				EndIf
			Next	
$iconlist[$iconlist[0][0]][3]=$iconlist[$i][3]
			_ArrayDelete($iconlist,$i)
			$iconlist[0][0]=$iconlist[0][0]-1
			
	if $avoidme=0 Then
			GUICtrlSetPos($iconlist[$iconlist[0][0]][1],$iconlist[$iconlist[0][0]][3],0)
			
	EndIf
					
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

func SetIcon($controlID, $sIcon, $iIndex, $iWidth, $iHeight, $aFactors, $aPositions, $iClr1="0x111111", $iClr2="0x999999", $iDirection=2, $pressed=0,$string="", $fontsize="12", $over="1",$lef="2", $top="2",$style="Arial")
    const $STM_SETIMAGE = 0x0172
    local $tIcon, $tID, $hDC, $hBackDC, $hBackSv, $hBitmap, $hImage, $hIcon, $hBkIcon
   Local $w=$iWidth/2, $h=$iHeight/2
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
	if $over=0 and not $string="" then _GDIPlus_GraphicsDrawString($hGraphic,$string,$lef, $top,$style,$fontsize)
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
		If $hIcon <> 0 Then _WinAPI_DrawIconEx($hBackDC, $w-16, $h-16, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
	EndIf
	   if $over=1 and not $string="" then
        $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hbmp)
        Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
        _GDIPlus_GraphicsDrawString($hGraphic,$string,$lef, $top,$style,$fontsize)
        $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
        _GDIPlus_GraphicsDispose    ($hGraphic)
    EndIf
     $aBmp = DllCall("user32.dll", "hwnd", "SendMessage", "hwnd", $hWnd, "int", $STM_SETIMAGE, "int", $IMAGE_BITMAP, "int", $hbmp)
	If $aBmp[0] <> 0 Then _WinAPI_DeleteObject($aBmp[0])
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_BrushDispose($hBrushLin)
    _GDIPlus_GraphicsDispose($hGraphic)
;	_WinAPI_RedrawWindow(GUICtrlGetHandle($iconlist[$arraynumber][1]))
;  _WinAPI_DeleteObject($hbmp)

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
            If $clicked and IsArray($iconlist)=1 and IsArray($winlistall)=1 Then
				$found =_ArraySearch($iconlist, @GUI_CTRLID, 0, 0, 0, 3)
				if $date=@GUI_CtrlId then
				$onit=$date
				EndIf
				for $i=1 to $iconlist[0][0]
					if $iconlist[$i][1]= @GUI_CTRLID Then
						$onit=$iconlist[$i][0]
						ExitLoop
					EndIf
				Next
				
                $Begin = TimerInit()
                Do
                    Sleep(10)
                Until TimerDiff($Begin) > 100; Adjust to suit required double clicking speed
                If $DoubleClicked Then
							for $j= 1 to $winlistall[0][1]
								If $winlistall[$j][0] = $onit then
									WinSetState($winlistall[$j][2],"",@SW_MINIMIZE)
									ExitLoop
								EndIf
							Next
                            $DoubleClicked = 0
                            $clicked = 0
                Else
                    If Not $esmNO Then
						If $date = $onit then shortcuts()
							for $j= 1 to $winlistall[0][1]
								If $winlistall[$j][0] = $onit then
									WinActivate($winlistall[$j][2])
									ExitLoop
								EndIf
							Next
							
                    Else
                        $esmNO = 0
                    EndIf

                    $clicked = 0
                EndIf
				Sleep(300)
            EndIf
EndFunc

Func __GUIImageList_AddIcon($hWnd, $sFile, $iIndex = 0, $fLarge = False)

    Local $tIcon, $iResult, $hIcon

    $tIcon = DllStructCreate("int Handle")
    If $fLarge Then
        $iResult = _WinAPI_ExtractIconEx($sFile, $iIndex, DllStructGetPtr($tIcon), 0, 1)
    Else
        $iResult = _WinAPI_ExtractIconEx($sFile, $iIndex, 0, DllStructGetPtr($tIcon), 1)
    EndIf
    If $iResult <= 0 Then
        Return SetError(1, 0, -1)
    EndIf
    $hIcon = DllStructGetData($tIcon, "Handle")
    $iResult = _GUIImageList_ReplaceIcon($hWnd, -1, $hIcon)
    DllCall('user32.dll', 'int', 'DestroyIcon', 'ptr', $hIcon)
    If $iResult = -1 Then
        Return SetError(1, 0, -1)
    EndIf
    Return $iResult
EndFunc   ;==>__GUIImageList_AddIcon

func hovering()
if WinExists("taskbar") and not WinExists("context") and not WinExists("maincontext") Then
	$hover=GUIGetCursorInfo(WinGetHandle($taskbar,""))
		if $hover[4]>0 and $shorton=1 then
		for $i=1 to UBound($shortsfromini)-1
			if $hover[4]=$shortsfromini[$i][2] Then
				if _IsPressed("2e",$dll) then 
					GUICtrlDelete($shortsfromini[$i][2])
					IniDelete("taskbar.ini","shortcuts",$shortsfromini[$i][0])	
					_ArrayDelete($shortsfromini,$i)
				_WinAPI_RedrawWindow($taskbar, "", "", BitOR($WM_ERASEBKGND, $RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
				Return
				EndIf
				if $shortsfromini[$i][4]=0 then
					GUICtrlDelete($shortsfromini[$i][2])
					$shortsfromini[$i][2] = GUICtrlCreatePic("", $shortsfromini[$i][3], 0, 42, 42)
					GUICtrlSetOnEvent($shortsfromini[$i][2],"shortactions")
					$anyshort2=StringInStr($shortsfromini[$i][0],".")
					if $anyshort2=0 Then
						$anyshort=$shortsfromini[$i][0]
					Else
						$anyshort=StringLeft($shortsfromini[$i][0],$anyshort2-1)
					EndIf
					$anyshort=StringLower($anyshort)
					$leny=StringLen($anyshort)
					if $leny>9 then $anyshort=StringLeft($anyshort,9)
					$leny=9-$leny
					$lefter=$leny*3
				;	SetIcon($shortsfromini[$i][2],$shortsfromini[$i][1], 0, 70, 42, $aFactors, $aPositions, $bckcolour[1], $bckcolour[2], 1,0,$anyshort,10,1,$lefter,16, "Verdana")
				SetIcon($shortsfromini[$i][2],$shortsfromini[$i][1], 0, 42, 42, $aFactors, $aPositions, $bckcolour[2], $bckcolour[1], 1,2)				
				_WinAPI_RedrawWindow(GUICtrlGetHandle($shortsfromini[$i][2]))
					$shortsfromini[$i][4]=1 
				EndIf
			Elseif $hover[4]<>$shortsfromini[$i][2] and $shortsfromini[$i][4]=1 then
								GUICtrlDelete($shortsfromini[$i][2])
					$shortsfromini[$i][2] = GUICtrlCreatePic("", $shortsfromini[$i][3], 0, 42, 42)
					GUICtrlSetOnEvent($shortsfromini[$i][2],"shortactions")
					SetIcon($shortsfromini[$i][2],$shortsfromini[$i][1], 0, 42, 42, $aFactors, $aPositions, $bckcolour[1], $bckcolour[2], 1,0)
					_WinAPI_RedrawWindow(GUICtrlGetHandle($shortsfromini[$i][2]))
					$shortsfromini[$i][4]=0
			EndIf
		Next
		elseif $hover[4]=0 and $shorton=1 then
			for $i=1 to UBound($shortsfromini)-1
				if $shortsfromini[$i][4]=1 then
					GUICtrlDelete($shortsfromini[$i][2])
					$shortsfromini[$i][2] = GUICtrlCreatePic("", $shortsfromini[$i][3], 0, 42, 42)
					GUICtrlSetOnEvent($shortsfromini[$i][2],"shortactions")
					SetIcon($shortsfromini[$i][2],$shortsfromini[$i][1], 0, 42, 42, $aFactors, $aPositions, $bckcolour[1], $bckcolour[2], 1,0)
					_WinAPI_RedrawWindow(GUICtrlGetHandle($shortsfromini[$i][2]))
					$shortsfromini[$i][4]=0
					Return
				EndIf
			Next
		EndIf
	if $hover[4]<>0 and not WinExists("iconwin") and IsArray($iconlist)=1 and IsArray($winlistall)=1 and IsArray($2ndsublist)=1 then
		$maxlength=0
		for $i= 1 to $iconlist[0][0]
			If $iconlist[$i][1]=$hover[4] Then
				$hImagebtn3 = _GUIImageList_Create(16, 16, 5, 3)
				$blank=IniRead("taskbar.ini","iconnum", $iconlist[$i][0],1)
				$iew=__GUIImageList_AddIcon($hImagebtn3, $iconlist[$i][4],$blank, False)
				if $iew=-1 then _GUIImageList_AddIcon($hImagebtn3, $iconlist[$i][4],0, False)
				$whoishovered=$iconlist[$i][1]
				dim $2ndsublist[UBound($winlistall)][8]
				Global $iconwin=GUICreate("iconwin", 500, 500,5,@DesktopHeight-539,$WS_POPUP,BitOR($WS_EX_TOOLWINDOW,$WS_EX_LAYERED))
				GUISetState(@SW_SHOWNOACTIVATE, $iconwin)
				WinSetOnTop("iconwin","",1)
				GUISetBkColor($transcolour, $iconwin)
				$bottom=475
				for $k= 1 to $winlistall[0][1]
					if $iconlist[$i][0]=$winlistall[$k][0] Then
				;		$2ndsublist[$k][0]=$winlistall[$k][0]
				if StringLen($winlistall[$k][1])>58 Then
					$2ndsublist[$k][1]=StringLeft($winlistall[$k][1],58)&"..."
				Else
					$2ndsublist[$k][1]=$winlistall[$k][1]
				EndIf
					;	$2ndsublist[$k][1]=$winlistall[$k][1]
						$2ndsublist[$k][0]=$winlistall[$k][2]
						$2ndsublist[$k][4]=0
						$2ndsublist[$k][6]=0 ; close window on submenu delete
					if WinActive($2ndsublist[$k][0]) Then
					local $colour=$bckcolour[3]
					$2ndsublist[$k][3]=1
					Else
					local $colour=$bckcolour[1]
					$2ndsublist[$k][3]=0
					EndIf
						$2nd = GUICtrlCreateButton("", 0,$bottom, 22, 20,$BS_FLAT)
						_GUICtrlButton_SetImageList($2nd, $hImagebtn3)
						$2ndsublist[$k][2] = GUICtrlCreateLabel(" "&$2ndsublist[$k][1], 22, $bottom, 473, 20)

						GUICtrlSetOnEvent($2ndsublist[$k][2],"subactions")
						GUICtrlSetBkColor(-1,$colour)
						GUICtrlSetFont(-1,13,350,"Arial")
						GUICtrlSetColor(-1,$bckcolour[6])
						$2ndsublist[$k][5]=$bottom
						$bottom=$bottom-20
							$aLabel_Info = _Label_Size(" "&$2ndsublist[$k][1], 13, "Arial", @DesktopWidth)
						if $maxlength<$aLabel_Info[2] then $maxlength=$aLabel_Info[2]
						GUISwitch($iconwin)
					EndIf
				Next
				$bottom=475
					if $maxlength<144 then $maxlength=144
					if $iconlist[$i][3]-($maxlength/2)+22<0 then
						$placem=0
					Else
						$placem=$iconlist[$i][3]-($maxlength/2)+22
					EndIf
					WinMove($iconwin,"",$placem,@DesktopHeight-539,$maxlength+22,500)
				for $i=1 to UBound($2ndsublist)-1
					
					GUICtrlSetPos($2ndsublist[$i][2],22, $2ndsublist[$i][5], $maxlength+22, 20)
											GUICtrlSetBkColor($2ndsublist[$i][2],$colour)
						GUICtrlSetFont($2ndsublist[$i][2],13,350,"Arial")
						GUICtrlSetColor($2ndsublist[$i][2],$bckcolour[6])
					$bottom=$bottom-20
				Next
					
			;	_ArrayDisplay($2ndsublist)
				_API_SetLayeredWindowAttributes($iconwin,$transcolour)
	;    $fileName = GUICtrlCreateInput($file2, 0, 0, $aLabel_Info[2], $aLabel_Info[3])
				GUISetState(@SW_SHOW,$iconwin)
				Return
			EndIf
		Next
	elseif $hover[4]<>$whoishovered and WinExists("iconwin") then
		$hover=GUIGetCursorInfo(WinGetHandle($iconwin,""))
		if $hover[4]=0 then
			GUIDelete($iconwin)
			for $i=1 to UBound($2ndsublist)-1
						if $2ndsublist[$i][6]=1 then
							WinClose($2ndsublist[$i][0])
						EndIf
			Next
		EndIf
	EndIf
EndIf
if WinExists("iconwin") and not WinExists("context") Then
	$hover=GUIGetCursorInfo(WinGetHandle($iconwin,""))
	if $hover[4]<>0 and IsArray($iconlist)=1 and IsArray($winlistall)=1 and IsArray($2ndsublist)=1 then
		$justmoveit=0
		
		for $i=1 to UBound($2ndsublist)-1
			if $2ndsublist[$i][2]=$hover[4] and _IsPressed("02",$dll) then

						if $2ndsublist[$i][6]=0 then
							$2ndsublist[$i][6]=1
							GUICtrlSetColor($2ndsublist[$i][2],"0xFFFFFF")
							GUICtrlSetbkColor($2ndsublist[$i][2],"0x990000")
							Sleep(300)
							ExitLoop
						Else
							$2ndsublist[$i][6]=0
							if WinActive($2ndsublist[$i][0]) Then
								GUICtrlSetBkColor($2ndsublist[$i][2],$bckcolour[3])
								GUICtrlSetColor($2ndsublist[$i][2],$bckcolour[6])
							Else
								GUICtrlSetBkColor($2ndsublist[$i][2],$bckcolour[1])
								GUICtrlSetColor($2ndsublist[$i][2],$bckcolour[6])
							EndIf
							;sleep(300)
							$2ndsublist[$i][4]=0
							Return
						EndIf
			elseif $2ndsublist[$i][2]=$hover[4] and $2ndsublist[$i][4]<>1 Then
				for $k=1 to UBound($2ndsublist)-1
					if $2ndsublist[$k][4]=1 Then
						if $2ndsublist[$k][6]=1 then
							GUICtrlSetColor($2ndsublist[$k][2],"0xFFFFFF")
							GUICtrlSetbkColor($2ndsublist[$k][2],"0x990000")
						ElseIf WinActive($2ndsublist[$k][0]) Then
							GUICtrlSetBkColor($2ndsublist[$k][2],$bckcolour[3])
							GUICtrlSetColor($2ndsublist[$k][2],$bckcolour[6])
						Else
							GUICtrlSetBkColor($2ndsublist[$k][2],$bckcolour[1])
							GUICtrlSetColor($2ndsublist[$k][2],$bckcolour[6])
						EndIf

						$justmoveit=1
						$2ndsublist[$k][4]=0
					EndIf
				Next
				$2ndsublist[$i][4]=1
				GUISwitch($iconwin)
				if $2ndsublist[$i][6]=1 then
					GUICtrlSetBkColor($2ndsublist[$i][2],$bckcolour[5])
					GUICtrlSetColor($2ndsublist[$i][2],"0xFFFFFF")
				elseif $2ndsublist[$i][6]=0 then
					GUICtrlSetBkColor($2ndsublist[$i][2],$bckcolour[5])
					GUICtrlSetColor($2ndsublist[$i][2],$bckcolour[6])
				EndIf
				if $justmoveit=0 Then
				;	Global $closebutton=GUICtrlCreateLabel("X",480,$2ndsublist[$i][5],20,25,$SS_CENTER)
				;	GUICtrlSetFont($closebutton,18,400,"Arial")
				;	GUICtrlSetColor(-1,$bckcolour[6])
				;	GUICtrlSetOnEvent($closebutton,"closeit")
				;	GUICtrlSetBkColor($closebutton,$bckcolour[1])
				ElseIf $justmoveit=1 Then
				;	GUICtrlSetPos($closebutton,480,$2ndsublist[$i][5])
				EndIf
			;	_ArrayDisplay($2ndsublist)
				ExitLoop
			EndIf
		Next
	EndIf
EndIf
GUISwitch($taskbar)

EndFunc

Func closeit()
for $k=1 to UBound($2ndsublist)-1
		if $2ndsublist[$k][4]=1 Then
			WinActivate($2ndsublist[$k][0])
		WinClose($2ndsublist[$k][0])
		ExitLoop
		EndIf
Next
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
Func _API_SetLayeredWindowAttributes($hwnd, $i_transcolor, $Transparency = $trans, $isColorRef = False)
   
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

Func WM_DROPFILES_UNICODE_FUNC($hWnd, $msgID, $wParam, $lParam)
	
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("wchar[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "int", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
			$result = StringInStr($gaDropFiles[$i],"\",0,-1)
			$result2 = StringLen($gaDropFiles[$i])-$result
			$result = Stringright($gaDropFiles[$i],$result2)
		
	If $shorton=1 Then
			if StringRight($gaDropFiles[$i],3)<>"exe" then
		$whoopensit=_WinAPI_FindExecutable($gaDropFiles[$i])
	Else
		$whoopensit=$gaDropFiles[$i]
	EndIf
			$whopens1 = StringInStr($whoopensit,"\",0,-1)
			$whopens2 = StringLen($whoopensit)-$whopens1
			$whopens3 = Stringright($whoopensit,$whopens2)
		
		if not $whoopensit="" and not $whopens3="" then
			IniWrite("taskbar.ini","shortcuts",$whopens3,$whoopensit)
			for $i=1 to UBound($shortsfromini)-1
					GUICtrlDelete($shortsfromini[$i][2])
			Next
			$shorton=0	
			shortcuts()
			Return
		EndIf
	Else
		if StringRight($gaDropFiles[$i],3)="exe" then
			IniWrite("taskbar.ini","pins",$result,$gaDropFiles[$i])
		else
			$whoopensit=_WinAPI_FindExecutable($gaDropFiles[$i])
			$whopens1 = StringInStr($whoopensit,"\",0,-1)
			$whopens2 = StringLen($whoopensit)-$whopens1
			$whopens3 = Stringright($whoopensit,$whopens2)
			IniWrite("taskbar.ini",$whopens3,$result,$gaDropFiles[$i])
		EndIf
		fullrefresh()
	;	_WinAPI_RedrawWindow($taskbar, "", "", BitOR($WM_ERASEBKGND, $RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
	EndIf
		$pFileName = 0
	Next
	_WinAPI_RedrawWindow($taskbar, "", "", BitOR($WM_ERASEBKGND, $RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
EndFunc   ;==>WM_DROPFILES_UNICODE_FUNC

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
if $h=0 then $h=12
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
		$col= $bckcolour[3]
	Else
		$col=$bckcolour[4]
	EndIf
else
	$col=$bckcolour[4]
EndIf

return $col

EndFunc


Func pinned()
	
	Global $pinnedfromini=IniReadSection("taskbar.ini","pins")
	If @error Then
		if FileExists("taskbar.ini") then Return
		createini()
	Global $pinnedfromini=IniReadSection("taskbar.ini","pins")
	EndIf
	redim $pinned[10][6]
	for $i=1 to $pinnedfromini[0][0]
		$pinned[$i][0]=$pinnedfromini[$i][0]
		$pinned[$i][1]=$pinnedfromini[$i][1]
		;MsgBox(0,"",$pinned[$i][3])
		$pinned[$i][2] = GUICtrlCreatePic("", $pinned[0][1]*54, 0, 54, 42)
		GUICtrlSetOnEvent($pinned[$i][2],"pinnedactions")
		SetIcon($pinned[$i][2],$pinned[$i][1], 0, 54, 42, $aFactors, $aPositions, $bckcolour[1], $bckcolour[2], 1,0)

	;	_WinAPI_DeleteObject($hbmp)
		$pinned[$i][3]=$pinned[0][1]*54
		$pinned[0][1]=$pinned[0][1]+1
			$whopens1 = StringInStr($pinned[$i][1],"\",0,-1)
			$whopens2 = StringLen($pinned[$i][1])-$whopens1
			$pinned[$i][5] = Stringright($pinned[$i][1],$whopens2)
	Next
EndFunc

Func createini()
IniWrite("taskbar.ini","pins", "Notepad", "C:\Windows\System32\notepad.exe")
IniWrite("taskbar.ini","pins", "Calculator", "C:\Windows\System32\calc.exe")
EndFunc

func pinnedactions()
for $i = 1 to UBound($pinned)-1
	;ToolTip(@GUI_CtrlId&$2ndsublist[$i][1])
if @GUI_CTRLID=$pinned[$i][2] then
	ShellExecute($pinned[$i][1])
	ExitLoop
EndIf
Next

EndFunc

func fullrefresh()
if $shorton=0 then
	if WinExists("iconwin") then GUIDelete($iconwin)
	GUISwitch($taskbar)
	for $y= 1 to $pinned[0][1]
			GUICtrlDelete($pinned[$y][2])
	Next
	
	for $i= 1 to $iconlist[0][0]
			GUICtrlDelete($iconlist[$i][1])	
	Next
dim $iconlist[20][7]
dim $winlist_previous[2][2]
dim $2ndsublist[20][7]
dim $pinned[20][7]
$totalavoided=0
	pinned()
	switchitup()
EndIf
EndFunc
func shortcutsrightmenu($remember,$whichbar,$item,$item2,$actionstotake="unpin")
	;	$remember=$hover[4]
	$loco=MouseGetPos()
			if WinExists("iconwin") then GUIDelete($iconwin)
			if $loco[0]-30<0 then
				$where=0
			Else
				$where=$loco[0]-30
			EndIf
		$shortcuts=IniReadSection("taskbar.ini",$item)
		if @error then
			$wherehgt=@DesktopHeight-80
			$wheresize=75
			$math=0
			dim $shortcuts[2][2]
		Else
			$math=$shortcuts[0][0]*25+2
			$wherehgt=@DesktopHeight-80-$math
			$wheresize=75+$math
		EndIf
		$contextmenu=GUICreate("context",135,$wheresize, $where,$wherehgt,$WS_POPUP,$WS_EX_TOOLWINDOW)
		WinSetOnTop($contextmenu,"",1)
		$hover=GUIGetCursorInfo(WinGetHandle($contextmenu,""))
			if StringLen($item)>14 then 
				$item3=StringLeft($item,14)&"..."
			Else
				$item3=$item
			EndIf
		Dim $execute[4][3]
		Dim $unpin[3]
		Dim $closegroup[3]
		ReDim $shortcuts[$shortcuts[0][0]+1][4]
		$execute[1][0]=GUICtrlCreateLabel($item3,0,$math+0,135,25)
		$execute[2][0]=GUICtrlCreateLabel($actionstotake,0,$math+25,135,25)
		$execute[3][0]=GUICtrlCreateLabel("Close Group",0,$math+50,135,25)

		For $p= 1 to 3
			$execute[$p][1]=0
			GUIctrlSetFont($execute[$p][0],13,500,"Arial")
			GUICtrlSetColor(-1,$bckcolour[6])
			GUICtrlSetBkColor($execute[$p][0],$bckcolour[1])
		Next
		if $math<>0 Then
			for $p=1 to $shortcuts[0][0]
				if StringLen($shortcuts[$p][0])>14 Then
				$interim=StringLeft($shortcuts[$p][0],14)&"..."
				Else
				$interim=$shortcuts[$p][0]
				EndIf
				$shortcuts[$p][2]=GUICtrlCreateLabel($interim,0,$p*25-25,135,25)
				GUIctrlSetFont(-1,13,500,"Arial")
				GUICtrlSetColor(-1,$bckcolour[6])
				GUICtrlSetBkColor(-1,$bckcolour[1])
				$shortcuts[$p][3]=0
			Next
		EndIf
		SetError(0)
		GUISetState()
		$whosunder=-1
		$temp=-1
		$leaveyet=0
	do 
		$hover=GUIGetCursorInfo(WinGetHandle($contextmenu,""))
		if $math<>0 then
			for $p= 1 to $shortcuts[0][0]
				if _IsPressed(01) and $hover[4]=$shortcuts[$p][2] then
					ShellExecute($item2,""""&$shortcuts[$p][1]&"""")
					GUIDelete($contextmenu)
					Return
				ElseIf $hover[4]=$shortcuts[$p][2] and $whosunder<>$shortcuts[$p][2] and $hover[4]<>0 Then
					GUICtrlSetBkColor($shortcuts[$p][2],$bckcolour[3])
					$temp=$shortcuts[$p][2]
				Elseif $hover[4]<>$shortcuts[$p][2] and $whosunder=$shortcuts[$p][2] and $hover[4]<>0 then
					GUICtrlSetBkColor($shortcuts[$p][2],$bckcolour[1])
				ElseIf $hover[4]=$shortcuts[$p][2] and _IsPressed("2E",$dll) Then
					IniDelete("taskbar.ini",$item,$shortcuts[$p][0])
					GUIDelete($contextmenu)
					Return
				EndIf
			Next
		;	$whosunder=$temp
		EndIf
		for $p= 1 to 3
			if $hover[4]=$execute[$p][0] and $whosunder<>$execute[$p][0] and $hover[4]<>0 Then
				GUICtrlSetBkColor($execute[$p][0],$bckcolour[3])
				$temp=$execute[$p][0]
			Elseif $hover[4]<>$execute[$p][0] and $whosunder=$execute[$p][0] and $hover[4]<>0 then
				GUICtrlSetBkColor($execute[$p][0],$bckcolour[1])
			EndIf
		Next
		$whosunder=$temp
		if _IsPressed(01) and $hover[4]=$execute[2][0] then
			if $whichbar=0 then
				if $actionstotake=" pin" Then
					IniWrite("taskbar.ini","pins", $item, $item2)
				elseif $actionstotake=" unpin" then
					IniDelete("taskbar.ini","pins", $item)
				EndIf
				GUIDelete($contextmenu)
				fullrefresh()
				_WinAPI_RedrawWindow($taskbar, "", "", BitOR($WM_ERASEBKGND, $RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
			else

				GUIDelete($contextmenu)
				GUISwitch($taskbar)
					for $i=1 to UBound($shortsfromini)-1
						GUICtrlDelete($shortsfromini[$i][2])
					Next
				$shortsfromini=IniDelete("taskbar.ini","shortcuts",$item)
					dim $shortsfromini[40][4]
					$shorton=1
				shortssetup()
			EndIf
				return
		Elseif _IsPressed(01) and $hover[4]=$execute[1][0] then
				ShellExecute($item2)
				GUIDelete($contextmenu)
			Return
		Elseif _IsPressed(01) and $hover[4]=$execute[3][0] then
			for $i=1 to UBound($winlistall)-1
				if $winlistall[$i][0]=$item then
					;WinActivate($winlistall[$i][2])
					WinClose($winlistall[$i][2])
				EndIf
			Next
					GUIDelete($contextmenu)
					;fullrefresh()
					;_WinAPI_RedrawWindow($taskbar, "", "", BitOR($WM_ERASEBKGND, $RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
			Return
		EndIf
		sleep(30)
IF $hover[4]=0 Then
	if $leaveyet=5 then ExitLoop
	$leaveyet=$leaveyet+1
Else
$leaveyet=0
EndIf

	until not WinActive($contextmenu)
	GUIDelete($contextmenu)
	sleep(400)

	;_WinAPI_RedrawWindow($taskbar,0,0,BitOR($RDW_ERASE,$RDW_INVALIDATE,$RDW_UPDATENOW,$RDW_FRAME,$RDW_ALLCHILDREN)) ; works, but redraws entire screen.
	
EndFunc

func rightmouse()

if WinExists("taskbar") Then

	$hover=GUIGetCursorInfo(WinGetHandle($taskbar,""))
		if $hover[4]>3 and $shorton=1 then
			for $i=1 to UBound($shortsfromini)-1

				if $hover[4]=$shortsfromini[$i][2] Then
					shortcutsrightmenu($hover[4],1,$shortsfromini[$i][0],$shortsfromini[$i][1])
					ExitLoop
				EndIf
			Next
			Return
		EndIf
	if $hover[4]=3 and $shorton=0 Then
		$loco=MouseGetPos()
		$maincontext=GUICreate("maincontext",140,105, $loco[0]-30,@DesktopHeight-110,$WS_POPUP,$WS_EX_TOOLWINDOW)
		WinSetOnTop($maincontext,"",1)
		$combolist=IniReadSection("taskbar.ini","colours")
		$killtaskbar=GUICtrlCreateCheckbox("Kill taskbar",0,25,140,25)
		if Iniread("taskbar.ini","userchoose","taskbar","")="1" then GUICtrlSetState(-1, 1)
		GUIctrlSetFont(-1,12,500,"Arial")
		GUICtrlSetColor(-1,$bckcolour[6])
		GUICtrlSetBkColor(-1,$bckcolour[1])
		$justalabel=GUICtrlCreateLabel("Transparency",37,50,108,25)
		GUIctrlSetFont(-1,12,500,"Arial")
		GUICtrlSetColor(-1,$bckcolour[6])
		GUICtrlSetBkColor(-1,$bckcolour[1])
		$Transparency=GUICtrlCreateInput(Iniread("taskbar.ini","userchoose","transparency",""),0,52,33,20,$ES_NUMBER)
		GUIctrlSetFont(-1,10,500,"Arial")
		GUICtrlSetColor(-1,$bckcolour[6])
		$comb=GUICtrlCreateCombo("",0,0,140,25)
				GUIctrlSetFont(-1,12,500,"Arial")
				GUICtrlSetColor(-1,$bckcolour[6])
		 $newlist=$combolist[1][0]
		for $w= 2 to $combolist[0][0]
			$newlist= $newlist&"|"&$combolist[$w][0]
		Next
		GUICtrlSetData(-1,  $newlist, Iniread("taskbar.ini","userchoose","colour",""))
		$runner = GUICtrlCreateButton("Submit", 0, 75, 140,30)
		GUIctrlSetFont(-1,12,500,"Arial")
		GUICtrlSetColor(-1,$bckcolour[6])
		GUICtrlSetBkColor(-1,$bckcolour[3])
		
		GUISetState()
	do
		$hover2=GUIGetCursorInfo(WinGetHandle($maincontext,""))
			sleep(30)
			if _IsPressed("1B",$dll) Then
				GUIDelete($maincontext)
				Return 0
			EndIf
			if $hover2[4]=$runner and $hover2[2] then ExitLoop
	until not WinActive($maincontext) or _IsPressed("0D",$dll)
		IniWrite("taskbar.ini","userchoose","colour",GUICtrlread($comb))
		if Stringlen(GUICtrlRead($Transparency))<4 then IniWrite("taskbar.ini","userchoose","transparency",GUICtrlRead($Transparency))
		if GUICtrlRead($killtaskbar)=1 then
			IniWrite("taskbar.ini","userchoose","taskbar","1")
		Else
			IniWrite("taskbar.ini","userchoose","taskbar","0")
		EndIf
		GUIDelete($maincontext)	
		GUICtrlDelete($date)
		GUICtrlDelete($Pic)
		setup()
		fullrefresh()
	;	switchitup()
	_WinAPI_RedrawWindow($taskbar,0,0,BitOR($RDW_ERASE,$RDW_INVALIDATE,$RDW_UPDATENOW,$RDW_FRAME,$RDW_ALLCHILDREN)) ; works, but redraws entire screen.
	EndIf

	if $hover[4]>4 and IsArray($iconlist)=1 and IsArray($winlistall)=1 and $shorton=0 then
				$remember=$hover[4]
				for $i= 1 to $iconlist[0][0]
				If $iconlist[$i][1]=$remember Then
					for $g = 1 to $iconlist[0][0]
						if $iconlist[$g][1]=$remember Then
						
						$item=$iconlist[$i][0]
						$item2=$iconlist[$i][4]
						$actionstotake=" unpin"
						ExitLoop
						EndIf
					Next
					$actionstotake=" pin"
					$item2=$iconlist[$i][4]
					$item=$iconlist[$i][0]
				EndIf
				Next
				for $i= 1 to $pinned[0][1]
				If $pinned[$i][2]=$remember Then
					for $y= 1 to $pinned[0][1]
						If $pinned[$y][2]=$remember Then
						$item=$pinned[$i][5]
						$item2=$pinned[$i][1]
						$actionstotake=" unpin"
						ExitLoop
						EndIf
					Next
				EndIf
				Next
		shortcutsrightmenu($hover[4],0,$item,$item2,$actionstotake)
	EndIf
EndIf
EndFunc


Func _WinPrevious($z)
    If $z < 1 Then Return SetError(1, 0, 0) ; Bad parameter
    Local $avList = WinList()
    For $n = 1 to $avList[0][0]
        ; Test for non-blank title, and is visible
        If $avList[$n][0] <> "" And BitAND(WinGetState($avList[$n][1]), 2) Then
            If $z Then 
                $z -= 1
            Else
			return $avList[$n][1]
            EndIf
        EndIf
    Next
    Return SetError(2, 0, 0) ; z-depth exceeded
EndFunc

Func _ShowTaskBar($fShow)
    Local $hTaskBar
    If @OSVersion = "WIN_VISTA" Then _ShowStartButton($fShow)
    $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
    If $fShow=0 Then
        _WinAPI_ShowWindow($hTaskBar, @SW_SHOW)
    Else
        _WinAPI_ShowWindow($hTaskBar, @SW_HIDE)
    EndIf
EndFunc   ;==>_ShowTaskBar

Func _ShowStartButton($fShow )
    Local $hTaskBar, $hStartButton
    If @OSVersion = "WIN_VISTA" Then
        $hStartButton = _WinAPI_FindWindow("Button", "Start")
    Else
        $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
        $hStartButton = ControlGetHandle($hTaskBar, "", "Button1")
    EndIf
    If $fShow=0 Then
        _WinAPI_ShowWindow($hStartButton, @SW_SHOW)
    Else
        _WinAPI_ShowWindow($hStartButton, @SW_HIDE)
    EndIf
EndFunc   ;==>_ShowStartButton

func writetheini()
IniWrite("taskbar.ini","pins", "notepad.exe", "C:\Windows\System32\notepad.exe")
IniWrite("taskbar.ini","pins", "calc.exe", "C:\Windows\System32\calc.exe")

IniWrite("taskbar.ini","userchoose", "colour", "Pastel Blue")
IniWrite("taskbar.ini","userchoose", "taskbar", "0")
IniWrite("taskbar.ini","userchoose", "transparency", "222")

IniWrite("taskbar.ini","explorer.exe", "C:","c\")
IniWrite("taskbar.ini","iconnum", "explorer.exe","13")
IniWrite("taskbar.ini","colours", "gray", "0xAAAAAA;0x111111;0x555555;0x333333;0x888888;0x000000")
IniWrite("taskbar.ini","colours", "blue", "0x3366CC;0x000066;0x3366AA;0x33CCFF;0x3BB9FF;0xF2F2F2")
IniWrite("taskbar.ini","colours", "red", "0xCC6666;0x660000;0x993333;0x990000;0xCC8888;0x000000")
IniWrite("taskbar.ini","colours", "green", "0x99CC99;0x002200;0x006633;0x333300;0x00CC66;0x000000")
IniWrite("taskbar.ini","colours", "rainbow", "0xFFFC17;0x2554C7;0x4AA02C;0x617C58;0xC25A7C;0x000000")
IniWrite("taskbar.ini","colours", "Pastel Blue", "0x00FFFF;0x005599;0x0088CC;0x2266BB;0x00BBEE;0x000000")
IniWrite("taskbar.ini","colours", "Pastel Green", "0x00EE99;0x225544;0x009966;0x007755;0x00CC99;0x000000")

EndFunc

Func HShellWndProc($hWnd, $Msg, $wParam, $lParam)
    Switch $wParam
		
        Case $HSHELL_WINDOWACTIVATED
			switchitup()
			
    EndSwitch
EndFunc

Func ShellHookWindow($hWnd, $bFlag)
    Local $sFunc = 'DeregisterShellHookWindow'
    If $bFlag Then $sFunc = 'RegisterShellHookWindow'
    Local $aRet = DllCall('user32.dll', 'int', $sFunc, 'hwnd', $hWnd)
    Return $aRet[0]
EndFunc
Func RegisterWindowMessage($sText)
    Local $aRet = DllCall('user32.dll', 'int', 'RegisterWindowMessage', 'str', $sText)
    Return $aRet[0]
EndFunc

Func WM_COMMAND($hWnd, $MsgID, $wParam, $lParam)
    Local Const $STN_DBLCLK = 1, $STN_CLICKED = 0
    Local $nID = BitAND($wParam, 0xFFFF)
    Local $nNotifyCode = BitShift($wParam, 16)
    Switch $nNotifyCode
		Case $STN_CLICKED
            $clicked = $nID
        Case $STN_DBLCLK
            $DoubleClicked = $nID
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc  ;==>WM_COMMAND

Func esm()
    $esmNO = 1
    ConsoleWrite("esmed" & @CRLF)
EndFunc  ;==>esm

func switchitup()
	if $shorton=0 then
		Global $winlistall=_getwinlist()
		if $winlistall[0][1]>$winlist_previous[0][1] then
				icon_updater()
				_ReduceMemory()
		ElseIf $winlistall[0][1]<$winlist_previous[0][1] then
				icon_reducer()
		EndIf
		$winlist_previous=$winlistall
	icon_changer()
EndIf
sleep(500)
EndFunc

Func _ReduceMemory($i_PID = -1)
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    Return $ai_Return[0]
EndFunc;==> _ReduceMemory()

func no_tab()
    _WinAPI_SetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE, _
	BitAND(_WinAPI_GetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE), BitNOT($WS_TABSTOP)))
EndFunc

; #FUNCTION# =======================================================================================
; Name............: _Label_Size
; Description ....: Returns size of label required for a text, even if wrapped to a set width
; Syntax..........: _Label_Size($sText, $iFont_Size, $sFont_Name[, $iWidth])
; Parameters .....: $sText        -> Text to display with @CRLF line endings
;                   $iFont_Size    -> Font size in points
;                   $sFont_Name    -> Font name
;                   $iWidth        -> Max width of the label - default is width of desktop
; Requirement(s)..: v3.2.12.1 or higher
; Return values ..: Success:    Returns array with details of label required for text
;                               $array[0] = Number of unwrapped lines in text
;                               $array[1] = Height of single line of text
;                               $array[2] = Width of label required to hold text
;                               $array[3] = Height of label required to hold text
;                   Failure:    Returns 0
;                               - Error 1 - Failure to create GUI to test label size
;                               - Error 2 - Font too large for width - longest word will not fit
; Author .........: Melba23
; Example.........; Yes
;===================================================================================================

Func _Label_Size($sText, $iFont_Size, $sFont_Name, $iWidth = @DesktopWidth)
    Local $hWnd, $hFont, $hDC, $tSize, $hGUI, $hText_Label, $sTest_Line
    Local $iStart_Code, $iEnd_Code, $iFont_Width, $iLine_Count, $iLine_Width, $iWrap_Count, $iLast_Word
    Local $aLines[1], $aLabel_Info[4], $aPos[4], $aInfo[3]
    $hGUI = GUICreate("", 800, 1000, 800, 10)
    If $hGUI = 0 Then Return SetError(1, 0, 0)
    GUISetFont($iFont_Size, 400, 0, $sFont_Name)
    $aLines = StringSplit($sText, @CRLF, 1)
    $aLabel_Info[0] = $aLines[0]
    $hText_Label = GUICtrlCreateLabel($sText, 10, 10)
    $aPos = ControlGetPos($hGUI, "", $hText_Label)
    GUICtrlDelete($hText_Label)
    $aLabel_Info[1] = ($aPos[3] - 8) / $aLines[0]
    $aLabel_Info[2] = $aPos[2]
    $aLabel_Info[3] = $aPos[3]
    If $aPos[2] > $iWidth Then
        $aLabel_Info[2] = $iWidth
        $iLine_Count = 0
        For $j = 1 To $aLines[0]
            $hText_Label = GUICtrlCreateLabel($aLines[$j], 10, 10)
            $aPos = ControlGetPos($hGUI, "", $hText_Label)
            GUICtrlDelete($hText_Label)
            If $aPos[2] < $iWidth Then
                $iLine_Count += 1
            Else
                $hText_Label = GUICtrlCreateLabel("", 0, 0)
                $hWnd = ControlGetHandle($hGUI, "", $hText_Label)
                $hFont = _SendMessage($hWnd, $WM_GETFONT)
                $hDC = _WinAPI_GetDC($hWnd)
                _WinAPI_SelectObject($hDC, $hFont)
                $iWrap_Count = 0
                While 1
                    $iLine_Width = 0
                    $iLast_Word = 0
                    For $i = 1 To StringLen($aLines[$j])
                        If StringMid($aLines[$j], $i, 1) = " " Then $iLast_Word = $i - 1
                        $sTest_Line = StringMid($aLines[$j], 1, $i)
                        GUICtrlSetData($hText_Label, $sTest_Line)
                        $tSize = _WinAPI_GetTextExtentPoint32($hDC, $sTest_Line)
                        $iLine_Width = DllStructGetData($tSize, "X")
                        If $iLine_Width > $iWidth Then ExitLoop
                    Next
                    If $i > StringLen($aLines[$j]) Then
                        $iWrap_Count += 1
                        ExitLoop
                    Else
                        $iWrap_Count += 1
                        If $iLast_Word = 0 Then
                            GUIDelete($hGUI)
                            Return SetError(2, 0, 0)
                        EndIf
                        $aLines[$j] = StringTrimLeft($aLines[$j], $iLast_Word)
                        $aLines[$j] = StringStripWS($aLines[$j], 1)
                    EndIf
                WEnd
                $iLine_Count += $iWrap_Count
                _WinAPI_SelectObject($hDC, $hFont)
                _WinAPI_ReleaseDC($hWnd, $hDC)
                GUICtrlDelete($hText_Label)
            EndIf
        Next
        $aLabel_Info[3] = ($iLine_Count * $aLabel_Info[1]) + 8
    EndIf
    GUIDelete($hGUI)
    Return $aLabel_Info
EndFunc  ;==>_Label_Size

func shortcuts()
if $shorton=0 then
	if WinExists("iconwin") then GUIDelete($iconwin)
	if WinExists("context") then GUIDelete($contextmenu)
	if WinExists("maincontext") then GUIDelete($maincontext)
	GUISwitch($taskbar)
	for $y= 1 to $pinned[0][1]
			GUICtrlDelete($pinned[$y][2])
	Next
	
	for $i= 1 to $iconlist[0][0]
			GUICtrlDelete($iconlist[$i][1])	
		Next
dim $iconlist[20][7]
dim $winlist_previous[2][2]
dim $2ndsublist[20][7]
dim $pinned[20][7]
$totalavoided=0
$shorton=1
shortssetup()
elseif $shorton=1 then
	for $i=1 to UBound($shortsfromini)-1
		GUICtrlDelete($shortsfromini[$i][2])
	Next
	dim $shortsfromini[4][4]
	$shorton=0
	pinned()
	switchitup()
EndIf
EndFunc
Func shortssetup()
	$shortsfromini=IniReadSection("taskbar.ini","shortcuts")
	If @error Then
		if FileExists("taskbar.ini") then Return
		createini()
		Global $shortsfromini=IniReadSection("taskbar.ini","shortcuts")
	EndIf

	redim $shortsfromini[$shortsfromini[0][0]+1][5]
	$goingleft=@DesktopWidth-150
	for $i=1 to UBound($shortsfromini)-1
		$shortsfromini[$i][3] =$goingleft
		$shortsfromini[$i][2] = GUICtrlCreatePic("", $shortsfromini[$i][3], 0, 42, 42)
		GUICtrlSetOnEvent($shortsfromini[$i][2],"shortactions")
		
		SetIcon($shortsfromini[$i][2],$shortsfromini[$i][1], 0, 42, 42, $aFactors, $aPositions, $bckcolour[1], $bckcolour[2], 1,0)
		
		$shortsfromini[$i][4] =0
		$goingleft=$goingleft-42
		
	Next
	_WinAPI_RedrawWindow($taskbar, "", "", BitOR($WM_ERASEBKGND, $RDW_INVALIDATE, $RDW_UPDATENOW, $RDW_FRAME))
EndFunc
	
Func shortactions()
for $i=1 to UBound($shortsfromini)-1
	if @GUI_CtrlId = $shortsfromini[$i][2] Then ShellExecute($shortsfromini[$i][1])
Next
$shorton=1
shortcuts()
EndFunc
