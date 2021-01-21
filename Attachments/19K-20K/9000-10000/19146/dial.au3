; Dial Indicator:an ugly hack of Analog Clock which was
; Created April 2006
; By greenmachine
; Credit - Larry (region funcs), neogia (anti-flicker, erasing old lines), Valuater (tray, transparency)

#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
#include <GUIConstants.au3>
#Include <WinAPI.au3>


Opt ("GUIOnEventMode", 1)
Opt ("TrayMenuMode", 1)
Opt ("TrayOnEventMode", 1)



Global $Labels[7], $redline, $DialActive = 1, $WaitingForMin = 0
Global Const $PI = 3.1415926535897932384626433832795
Global $gdi_dll = DllOpen ("gdi32.dll"), $user32_dll = DllOpen ("user32.dll")
Global $LabW = 50, $LabH = 20, $Mid = 75, $Radius = $Mid, $redlineRad = 210, $BlacklineRad = 190, $boldBlacklineRad = 170, $OldFontSize
Global $BackgroundPens[3], $BlackPens[4]
Global $MousePos, $WinPos, $PosDiff[2]
Global $myredPen
Global $mybkPen 
Global $greenBrush
Global $redBrush


                $Radius = $Mid
                $redlineRad = $Mid * (21/30)
                $BlacklineRad = $Mid * (19/30)
                $boldBlacklineRad = $Mid * (17/30)
             ;   If $OldFontSize <> Int ($Mid/10) Then
 
              ;  EndIf
Global $myBlackPen  = 0

$GUI_Indicator = GUICreate ("Dial Indicator", $Mid*2, $Mid*2*0.8, @DesktopWidth/2 - $Mid, @DesktopHeight/2 - $Mid, BitOR ($WS_POPUP, $WS_MINIMIZEBOX))
GUISetBkColor (0x00FFFF)
GUISetFont ($Mid/10, 800)

 $hWnd = WinGetHandle("Dial Indicator")




$ContextMenu = GUICtrlCreateContextMenu ()
$MenuItemMoveIndicator = GUICtrlCreateMenuitem ("Move Indicator", $ContextMenu, 0)
GUICtrlSetOnEvent ($MenuItemMoveIndicator, "MoveTheIndicator")

$MenuItemResizeIndicator = GUICtrlCreateMenuitem ("Resize Indicator", $ContextMenu, 1)
GUICtrlSetOnEvent ($MenuItemResizeIndicator, "ResizeTheIndicator")



GUICtrlCreateMenuitem ("", $ContextMenu, 3)


$MenuItemExit = GUICtrlCreateMenuitem ("Exit Dial Indicator", $ContextMenu, 10)
GUICtrlSetOnEvent ($MenuItemExit, "quitme")
$Labels[0] = GUICtrlCreateLabel (0, $Mid + Cos ($PI)*($Radius - 10)-25, $Mid * 0.8 + 15, $LabW, $LabH, $SS_CENTER)


$Labels[1] = GUICtrlCreateLabel (20, $Mid + Cos ($PI)*($Radius - 10)-23, $Mid - 40, $LabW, $LabH, $SS_CENTER)
$Labels[2] = GUICtrlCreateLabel (40, $Mid - 32 + Cos (2*$PI/3)*($Radius - 10), $Mid - Sin (2*$PI/3)*($Radius - 10) -7, $LabW, $LabH, $SS_CENTER)
$Labels[3] = GUICtrlCreateLabel (60, $Mid - 25, $Mid - Sin ($PI/2)*($Radius - 10) - 10, $LabW, $LabH, $SS_CENTER)
$Labels[4] = GUICtrlCreateLabel (80, $Mid - 18 + Cos ($PI/3)*($Radius - 10), $Mid - Sin ($PI/3)*($Radius - 10) - 7 , $LabW, $LabH, $SS_CENTER)
$Labels[5] = GUICtrlCreateLabel (100, $Mid - 18 + Cos ($PI/6)*($Radius - 10), $Mid - 40 , $LabW, $LabH, $SS_CENTER)
$Labels[6] = GUICtrlCreateLabel (120, $Mid - 25 + Cos (0)*($Radius - 10), $Mid , $LabW, $LabH, $SS_CENTER)




For $i = 0 To 6
    GUICtrlSetColor ($Labels[$i], 0xFF0000)
Next


For $i = 0 To 6
	GUICtrlSetFont ($Labels[$i], Int ($Mid/10), 400)
Next
$OldFontSize = Int ($Mid/10)



$TrayItemMove = TrayCreateItem ("Move Indicator", -1, 0)
TrayItemSetOnEvent ($TrayItemMove, "MoveTheIndicator")

$TrayItemResize = TrayCreateItem ("Resize Indicator", -1, 1)
TrayItemSetOnEvent ($TrayItemResize, "ResizeTheIndicator")

TrayCreateItem ("", -1, 7)

$TrayItemExit = TrayCreateItem ("Exit Dial Indicator", -1, 10)
TrayItemSetOnEvent ($TrayItemExit, "quitme")

$curSecX = $Mid + Cos (TimeToRad("sec", 70))*$redlineRad
$curSecY = $Mid - Sin (TimeToRad("sec", 70))*$redlineRad

 
GUISetState ()

_GDIPlus_Startup ()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hWnd)
AllThatGoodStuff(1)

While 1
    CheckIndicatorStatus()
    Sleep (10)
WEnd

Func AllThatGoodStuff($FirstRun = 0, $value = 70)
	
	Local $aPoints[5][2]
	$aPoints[0][0]= 4
	
	If $FirstRun = 1 Then
		$myBlackPen = _GDIPlus_PenCreate(0xFF000000, 1)
		$myredPen = _GDIPlus_PenCreate(0xFFFF0000,1)
		$mybkPen= _GDIPlus_PenCreate(0xFF00FFFF,1)
		$greenBrush = _GDIPlus_BrushCreateSolid(0xFF00FF00)
	EndIf
	
	$tmpX = $Mid + Cos (TimeToRad("sec", $value))*$redlineRad
	$tmpY = $Mid - Sin (TimeToRad("sec", $value))*$redlineRad
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hWnd)
	_GDIPlus_GraphicsDrawLine($hGraphic ,$Mid , $Mid ,$curSecX  , $curSecY,$mybkPen)
	_GDIPlus_GraphicsDrawLine($hGraphic ,$Mid , $Mid , $tmpX, $tmpY,$myBlackPen)
	If $FirstRun Then
		
		For $i = 0 To $PI+$PI/30 Step $PI/30
			if $i > 0 then
				$aPoints[1][0] = $Mid + Cos ($i)*($Radius*4/5)
				$aPoints[1][1] = $Mid - Sin ($i)*($Radius*4/5)
	
				$aPoints[2][0] = $Mid + Cos ($i - $PI/30)*($Radius*4/5)
				$aPoints[2][1] = $Mid - Sin ($i - $PI/30)*($Radius*4/5)
	
				$aPoints[3][0] = $Mid + Cos ($i - $PI/30)*($Radius*5/6)
				$aPoints[3][1] = $Mid - Sin ($i - $PI/30)*($Radius*5/6)
	
				$aPoints[4][0] = $Mid + Cos ($i)*($Radius*5/6)
				$aPoints[4][1] = $Mid - Sin ($i)*($Radius*5/6)
				_GDIPlus_GraphicsFillClosedCurve($hGraphic, $aPoints , $greenBrush)
			EndIf			
		Next
		
		$Tempcounter = 0
        For $i = 0 To $PI+$PI/30 Step $PI/30
			If Mod ($Tempcounter, 5) = 0 Then
				_GDIPlus_GraphicsDrawLine($hGraphic , $Mid + Cos ($i)*($Radius*47/60) , $Mid - Sin ($i)*($Radius*47/60) ,$Mid + Cos ($i)*($Radius*5/6), $Mid - Sin ($i)*($Radius*5/6))
            Else
				_GDIPlus_GraphicsDrawLine($hGraphic , $Mid + Cos ($i)*($Radius*4/5) , $Mid - Sin ($i)*($Radius*4/5) , $Mid + Cos ($i)*($Radius*5/6) ,$Mid - Sin ($i)*($Radius*5/6))
            EndIf
            $Tempcounter += 1
        Next
    EndIf	
	$curSecX = $Mid + Cos (TimeToRad("sec", $value))*$redlineRad
    $curSecY = $Mid - Sin (TimeToRad("sec", $value))*$redlineRad
    $redline = @SEC

	return 
EndFunc



Func TimeToRad($TimeType, $TimeVal = @SEC)
    Local $Rads
    Switch $TimeType
        Case "sec"
           $Rads = $PI/2 - ($TimeVal * $PI/30)
    EndSwitch
    Return $Rads
EndFunc



Func ResizeTheIndicator()
    Opt ("MouseCoordMode", 2)
    GUISetCursor (13, 1, $GUI_Indicator)
    ToolTip ("Click and drag to resize the Indicator.  Release to set size.")
    While 1
        $MousePos = MouseGetPos ()
        $WinPos = WinGetPos ("Dial Indicator")
        $PosDiff[0] = $WinPos[2] - $MousePos[0]
        $PosDiff[1] = $WinPos[1] - $MousePos[1]
        If _IsPressed ("01", $user32_dll) Then
            While _IsPressed ("01", $user32_dll)
                $MousePos = MouseGetPos ()
                WinMove ("Dial Indicator", "", $WinPos[0], $WinPos[1], $MousePos[0] + $PosDiff[0], _
                ($MousePos[0] + $PosDiff[0])*0.8)
                $WinPos = WinGetPos ("Dial Indicator")
				;ConsoleWrite($WinPos[2] & " " & $WinPos[3] & " " & $WinPos[2] & " " & $WinPos[3] & @CRLF) 
                $Mid = $WinPos[2]/2
                $Radius = $Mid
                $redlineRad = $Mid * (21/30)
                $BlacklineRad = $Mid * (19/30)
                $boldBlacklineRad = $Mid * (17/30)
                If $OldFontSize <> Int ($Mid/10) Then
                    For $i = 0 To 6
                        GUICtrlSetFont ($Labels[$i], Int ($Mid/10), 400)
                    Next
                    $OldFontSize = Int ($Mid/10)
                EndIf
                CheckIndicatorStatus(2)
                Sleep (10)
            WEnd
            ExitLoop
        EndIf
        CheckIndicatorStatus()
        Sleep (10)
    WEnd
    ToolTip ("")
    GUISetCursor ()
    AllThatGoodStuff(2)
    Opt ("MouseCoordMode", 1)
EndFunc

Func MoveTheIndicator()
    GUISetCursor (9, 1, $GUI_Indicator)
    ToolTip ("Click and drag to move the Indicator.  Release to set position.")
    While 1
        $MousePos = MouseGetPos ()
        $WinPos = WinGetPos ("Dial Indicator")
        $PosDiff[0] = $WinPos[0] - $MousePos[0]
        $PosDiff[1] = $WinPos[1] - $MousePos[1]
        If _IsPressed ("01", $user32_dll) Then
            While _IsPressed("01", $user32_dll)
                $MousePos = MouseGetPos ()
                WinMove ("Dial Indicator", "", $MousePos[0] + $PosDiff[0], $MousePos[1] + $PosDiff[1])
                $WinPos = WinGetPos ("Dial Indicator")
                If ($WinPos[0] < -10) Or ($WinPos[1] < -10) Or ($WinPos[0] + $WinPos[2] > @DesktopWidth + 10) Or _
                    ($WinPos[1] + $WinPos[3] > @DesktopHeight + 10) Then
                    CheckIndicatorStatus(2)
                Else
                    CheckIndicatorStatus()
                EndIf
                Sleep (10)
            WEnd
            ExitLoop
        EndIf
        CheckIndicatorStatus()
        Sleep (10)
    WEnd
    ToolTip ("")
    GUISetCursor ()
    AllThatGoodStuff(2)
EndFunc


Func CheckIndicatorStatus($special = 0)
    If Not WinActive ("Dial Indicator") Then $DialActive = 0
    If WinActive ("Dial Indicator") And $DialActive = 0 Then
        AllThatGoodStuff(2)
        $DialActive = 1
    EndIf
    If $redline <> @SEC Then
		;$val = Random(0,70)
        AllThatGoodStuff($special)
    EndIf
EndFunc




Func quitme()
    Exit
EndFunc

Func OnAutoItExit()
	_GDIPlus_GraphicsDispose ($hGraphic)
    _GDIPlus_Shutdown ()
    DllClose ($gdi_dll)
    DllClose ($user32_dll)
EndFunc


