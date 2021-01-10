#Include <ScreenCapture.au3>
#NoTrayIcon

If _MutexExists("ICU") Then Exit

Global $exit = False
Global $filedir = @ScriptDir & "\" & @MON & "-" & @MDAY & "-" & @YEAR & "\" & @HOUR & @MIN & @SEC & "\"
Global $fileINI = @ScriptDir & "\Settings.ini"
Global $interval = 2500
Global $quality = 50
Global $mode = 1
Global $scrnsave = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop","SCRNSAVE.EXE")

Init()

Func Init()
    HotKeySet("#{ESC}","ExitFunc")
    
    If $CMDLINE[0] Then
        Select
            Case StringInstr($CMDLINE[1],"c")
                ConfigGUI()
                Return 0
            Case StringInstr($CMDLINE[1],"?")
                msgbox(0,"ICU.EXE","Usage: ICU.EXE [option]" & @CRLF & @CRLF & "/C: Launch Configuration GUI")
                Return 0
			Case StringInstr($CMDLINE[1],"silent")
				CreateINI()
        EndSelect
    EndIf
    
	;ReadINI()
    StartUp()
EndFunc

Func StartUp()
	ReadINI()
	$scrnsave = StringRight($scrnsave,StringLen($scrnsave)-StringInStr($scrnsave,"\",0,-1))
	If DirCreate($filedir) = 0 Then 
        msgbox(0,"Failed to create dir","")
        Exit
    EndIf
    _ScreenCapture_SetJPGQuality($quality)
    DoCapture()
EndFunc

Func ConfigGUI()
    $xWin = @DesktopWidth * .3
    $yWin = @DesktopHeight * .2
    $gui = GUICreate("ICU",$xWin,$yWin,-1,-1)
		$inputInterval = GUICtrlCreateInput($interval / 1000,$xWin * .7,$yWin * .1125,$xWin * .125,$yWin * 0.15)
        $labelInterval = GUICtrlCreateLabel("Capture Interval (Seconds):",$xWin * .175, $yWin * .1375, $xWin * .45, $yWin * .2)
        $sliderQuality = GUICtrlCreateSlider($xWin * .35,$yWin * .35, $xWin * .5, $yWin * .2)
        GUICtrlSetLimit(-1,100,1)
        GUICtrlSetData($sliderQuality,$quality)
        $labelInterval = GUICtrlCreateLabel("Quality:",$xWin * .175, $yWin * .375, $xWin * .175, $yWin * .2)
        $radioMode1 = GUICtrlCreateRadio("Full Screen",$xWin * .175,$yWin * .625,$xWin * .275,$yWin * .1)
        $radioMode2 = GUICtrlCreateRadio("Active Window",$xWin * .475,$yWin * .625,$xWin * .285,$yWin * .1)
        If $mode = 0 Then
            GuiCtrlSetState($radioMode1,1)
        Else
            GuiCtrlSetState($radioMode2,1)
        EndIf
    GUISetState()
    
    Do
        $msg = GUIGetMsg()
    Until $msg = -3

    If BitAND(GUICtrlRead($radioMode1), 1) = 1 Then
        $mode = 0
    Else
        $mode = 1
    EndIf
    $interval = GUICtrlRead($inputInterval)
    $quality = GUICtrlRead($sliderQuality)
    
    GuiDelete()
	CreateINI($interval,$quality,$mode)
EndFunc

Func DoCapture()
    $x = 0
    $str = ""
    Do
		If Not FileExists($filedir) Then Exit
		$iIdleTime = _Timer_GetIdleTime()
        If $iIdleTime <= $interval And Not ProcessExists($scrnsave) And WinGetTitle("") <> "" Then
			$x += 1
			Do 
				$str &= "0"
			Until StringLen($str & $x) = 5
			$str = $str & $x
    
			DirCreate($filedir)
			$filename = $filedir & $str & ".JPG"
    
				Switch $mode
					Case 1
						$activewin = WinGetTitle("")
						$activewin = WinGetHandle($activewin)
						_ScreenCapture_CaptureWnd($filename,$activewin)
					Case Else
						$activewin = WinGetHandle("Program Manager")
						_ScreenCapture_CaptureWnd($filename,$activewin)
				EndSwitch
			TimeStampScreenshot($filename,@HOUR & ":" & @MIN & ":" & @SEC)
		EndIf

        sleep($interval)
        $str = ""
    Until $exit = True
EndFunc

Func ReadINI()
    If Not FileExists($fileINI) Then ConfigGUI()
    $arrINI = IniReadSection($fileINI,"Params")
    For $x = 0 to $arrINI[0][0]
        Switch $arrINI[$x][0]
            Case "INTERVAL"
                $interval = 1000 * Number($arrINI[$x][1])
            Case "QUALITY"
                $quality = Number($arrINI[$x][1])
            Case "MODE"
                $mode = Number($arrINI[$x][1])
        EndSwitch
    Next
    If IsNumber($interval) = 0 Or IsNumber($quality) = 0 Or IsNumber($mode) = 0 Then 
        CreateINI()
        ReadINI()
    EndIf
EndFunc

Func CreateINI($interval = 5,$quality = 25,$mode = 1)
    IniWrite($fileINI,"Params","INTERVAL",$interval)
    IniWrite($fileINI,"Params","QUALITY",$quality)
    INIWrite($fileINI,"Params","MODE",$mode)
EndFunc

Func ExitFunc()
    $exit = True
    Exit
EndFunc

Func TimeStampScreenshot($image,$timestamp)
	If Not FileExists($image) Then Return 0
	$sString  = $timestamp
	_GDIPlus_StartUp()
	$hImage   = _GDIPlus_ImageLoadFromFile($image)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
	$hFamily  = _GDIPlus_FontFamilyCreate("Arial")
	$hFont    = _GDIPlus_FontCreate($hFamily, 16, 1)
	$tLayout  = _GDIPlus_RectFCreate(0, 0)
	$hFormat  = _GDIPlus_StringFormatCreate(0)
	$hBrush1  = _GDIPlus_BrushCreateSolid(0xA2FFFFFF)
	$hBrush2  = _GDIPlus_BrushCreateSolid(0xC4FF0000)
	$hPen     = _GDIPlus_PenCreate(0xC4000000, 2)
	$aInfo    = _GDIPlus_GraphicsMeasureString($hGraphic, $sString, $hFont, $tLayout, $hFormat)
	$iWidth   = DllStructGetData($aInfo[0], "Width" )
	$iHeight  = DllStructGetData($aInfo[0], "Height")

	_GDIPlus_GraphicsFillRect($hGraphic, 0, 0, $iWidth, $iHeight, $hBrush1)
	_GDIPlus_GraphicsDrawRect($hGraphic, 1, 1, $iWidth, $iHeight, $hPen   )
	_GDIPlus_GraphicsDrawStringEx($hGraphic, $sString, $hFont, $aInfo[0], $hFormat, $hBrush2)

	; Save image
	_GDIPlus_ImageSaveToFile($hImage, $image & ".JPG")

	; Free resources
	_GDIPlus_PenDispose         ($hPen    )
	_GDIPlus_BrushDispose       ($hBrush1 )
	_GDIPlus_BrushDispose       ($hBrush2 )
	_GDIPlus_StringFormatDispose($hFormat )
	_GDIPlus_FontDispose        ($hFont   )
	_GDIPlus_FontFamilyDispose  ($hFamily )
	_GDIPlus_GraphicsDispose    ($hGraphic)
	_GDIPlus_ImageDispose       ($hImage  )
	_GDIPlus_ShutDown()
	FileMove($image & ".JPG",$image,1)
	Return 1
EndFunc

;Special Thanks to PsaltyDS
Func _Timer_GetIdleTime()
    Local $tStruct = DllStructCreate("uint;dword");
    DllStructSetData($tStruct, 1, DllStructGetSize($tStruct));
    DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($tStruct))

    Local $avTicks = DllCall("Kernel32.dll", "int", "GetTickCount")

    Local $iDiff = $avTicks[0] - DllStructGetData($tStruct, 2)
    If $iDiff >= 0 Then
        Return $iDiff
    Else
        Return SetError(0, 1, $avTicks[0])
    EndIf
EndFunc

Func _MutexExists($sOccurenceName)
    Local $ERROR_ALREADY_EXISTS = 183, $handle, $lastError
    
    $sOccurenceName = StringReplace($sOccurenceName, "\", ""); to avoid error
    $handle = DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", $sOccurenceName)

    $lastError = DllCall("kernel32.dll", "int", "GetLastError")
    Return $lastError[0] = $ERROR_ALREADY_EXISTS
    
EndFunc  ;==>_MutexExists