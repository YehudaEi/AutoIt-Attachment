#include <Array.au3>
#include <Winapi.au3>
#include<Misc.au3>
#include <Process.au3>
#include <StaticConstants.au3>
#include <GuiConstants.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
HotKeySet("{`}", "refresh")
HotKeySet("^+`", "Terminate")
_Singleton("AutoIt.au3", 0)
dim $string
Global $aWinList, $aRetWinList, $iHeight = 140, $left=8, $top=11, $count=0, $refresh=0,$icon, $date, $handle1="",$title,$winnumber=0, $peek=0, $picture,$exists=0,$update=0,$time=""
$taskbar=GUICreate("taskbar", @DesktopWidth, @DesktopHeight-174,10,@DesktopHeight-172,$WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
$date = GUICtrlCreatelabel("", @DesktopWidth-204, $iHeight+12, 194, 20,BitOr($SS_SUNKEN,$SS_center ))
GUISetControlsVisible($taskbar)
GUISetState(@SW_SHOW,$taskbar)

$sExclude_List = "Start[CL:102939]|Start|Desktop|Start Menu[CL:102938]|desktop[CL:102937]|Program Manager|taskbar|Menu|Save As|Drag"
Dim $aRetWinList[1][7]
GUISetState()
Update()
AdlibEnable("Buttonhover", 100) 

While GUIGetMsg() <> -3
		_WinListEx(Default, Default, $sExclude_List)
		$update=1+$update
If $update=10 Then
	Update()
	$update=0
EndIf

	sleep(300)
WEnd

Func _WinListEx($sTitle="", $sText="", $sExclude_List="")
	$sExclude_List = "|" & $sExclude_List & "|"
If $sTitle = -1 Or (IsKeyword($sTitle) And $sTitle = Default) Then
	$aWinList = WinList()
Else
	$aWinList = WinList($sTitle, $sText)
EndIf
;Count windows
$windows=0
For $i = 1 To $aWinList[0][0]
;Only display visible windows that have a title
	If $aWinList[$i][0] = "" Or Not BitAND(WinGetState($aWinList[$i][1]), 2) Then ContinueLoop
;Add to array all win titles that is not in the exclude list
	If Not StringInStr($sExclude_List, "|" & $aWinList[$i][0] & "|") and $aWinList[$i][1]<>$handle1 Then
		$windows=$windows+1
		;wait for window to open so icon can be cleanly grabbed, but not first run...
		if $count=1 Then
			$found =_ArraySearch($aRetWinList, $aWinList[$i][0], 0, 0, 0, 1)
			if $found=6 then WinWait($aWinList[$i][0],"",10000)
		EndIf
	EndIf 
Next
; If a window has been opened or closed, delete buttons and remake them

if $count=1 and $windows<>$aRetWinList[0][1] or $refresh=1 Then
	For $i = 1 To $aRetWinList[0][1]
		GUICtrlDelete($aRetWinList[$i][6])
	Next
	if $peek=1 Then
		GUICtrlDelete($picture)
		GUICtrlDelete($title)
		GUICtrlDelete($icon)
		$peek=0
	EndIf
EndIf

if $windows<>$aRetWinList[0][1] or $refresh=1 Then
; reset variables
	$count=1
	$left=5
	Dim $aRetWinList[$aWinList[0][0]][9]
; add data to array
	For $i = 1 To $aWinList[0][0]
;Only display visible windows that have a title
		If $aWinList[$i][0] = "" Or Not BitAND(WinGetState($aWinList[$i][1]), 2) Then ContinueLoop
;Add to array all win titles that is not in the exclude list
		If Not StringInStr($sExclude_List, "|" & $aWinList[$i][0] & "|") and $aWinList[$i][1]<>$handle1 Then
			$aRetWinList[0][1] += 1
			$aRetWinList[$aRetWinList[0][1]][0] = $aWinList[$i][0]
			$aRetWinList[$aRetWinList[0][1]][1] = $aWinList[$i][1]
			$classed = _WinAPI_GetClassName($aWinList[$i][1])
			$aRetWinList[$aRetWinList[0][1]][2] = "[CLASS:"&$classed&"]"
			$aRetWinList[$aRetWinList[0][1]][3] = _ProcessGetName (WinGetProcess ($aWinList[$i][0]))
			$aRetWinList[$aRetWinList[0][1]][4] = WinGetProcess ($aWinList[$i][0])
			$aRetWinList[$aRetWinList[0][1]][7]=ProcessGetStats($aRetWinList[$aRetWinList[0][1]][3],0)

	EndIf
	Next
	ReDim $aRetWinList[$i][9]
	_ArraySort($aRetWinList, 0, 1, $aRetWinList[0][1], 3)

;create screenshots
	For $i = 1 To $aRetWinList[0][1]
			$aWinPos = WinGetPos($aRetWinList[$i][1])
		if $aWinPos<>-32000 then
			snapshot($i)
		EndIf
	;create buttons	
		$aRetWinList[$i][5] = _ProcessGetIcon(_ProcessGetName (WinGetProcess ($aRetWinList[$i][0])))
		GUISetIcon($aRetWinList[$i][5])
		$button=GUICtrlCreateRadio("buttons",$left, $iHeight, 32, 32,BitOr($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		$aRetWinList[$i][6]=$button
		GUICtrlSetImage(-1, $aRetWinList[$i][5], 0)
		$left =$left+50
	;create hotkeysets
		If $aRetWinList[0][1] < 10 And $aRetWinList[0][1] > 1 Then HotKeySet("!" & $i, "windx")
		If $aRetWinList[0][1] = 10 Then HotKeySet("#0", "windx")
	
	Next
;turn off unused hotkeysets
	if $aRetWinList[0][1]<10 then
		For $i = $aRetWinList[0][1]+1 to 10
			HotKeySet("#"&$i)
		Next
	EndIf
	GUISetControlsVisible($taskbar)
	GUISetState()
	Return $aRetWinList
Else
	fixbuttons()
EndIf
EndFunc

Func buttonhover()
;Get mouse clicks and hovering.
$hov=WinGetHandle("taskbar","")
$hover=GUIGetCursorInfo($hov)
		if $winnumber+3<>$hover[4] and $hover[4]< $aRetWinList[0][1]+4 and $hover[4]<>0 then change()
if $hover[4]<>0 then
	;A button is being hovered
For $i = 1 To $aRetWinList[0][1]
	;Shift+left Click
	if $hover[2]= 1 and $hover[4]=$aRetWinList[$i][6] and _IsPressed(10) then
		ShellExecute($aRetWinList[$i][5])
		refresh()
		$i=$aRetWinList[0][1]
		;Left Click
	elseif $hover[2]= 1 and $hover[4]=$aRetWinList[$i][6] then
			$var2=WinGetPos($aRetWinList[$i][1],"")
		If $var2[0]=-32000 or $peek = 1 then
			WinActivate($aRetWinList[$i][1],"")
			snapshot($i)
		EndIf
		change()
		$i=$aRetWinList[0][1]
		; Right Click
	Elseif $hover[3]= 1 and $hover[4]=$aRetWinList[$i][6] then
		WinSetState($aRetWinList[$i][1],"",@SW_MINIMIZE)
		change()
		$i=$aRetWinList[0][1]
		; A button is being hovered
	Elseif $hover[4]= $i+3 Then
		$handle2=$aRetWinList[$i][1]
		$var2=WinGetPos($handle2,"")
		;Preview for non-minimized windows
		If $peek=0 and $var2[0]<>-32000 then
			peek($i,1)
		;Preview for minimized windows
		ElseIf $peek=0 and $var2[0]=-32000 then
			peek($i,0)
		EndIf
		
		;A preview is being hovered
	ElseIf $hover[4]> $aRetWinList[0][1]+3 Then
		;the closebutton is clicked
		if $hover[4]=$aRetWinList[0][1]+6 and $hover[2]= 1 Then
			;MsgBox(0,"",$hover[4]&"  "&$aRetWinList[0][1]+3)
			WinClose($aRetWinList[$winnumber][1],"")
			refresh()
			;click is left click on picture maximize it
		ElseIf $hover[4]=$aRetWinList[0][1]+4 and $hover[2]= 1 Then
			$whatisthestate=WinGetState($aRetWinList[$winnumber][1],"")
				$var2=WinGetPos($aRetWinList[$winnumber][1],"")
				if BitAnd($whatisthestate, 32) Then
					WinSetState($aRetWinList[$winnumber][1],"",@SW_RESTORE)
					change()
				elseIf $var2[0]<>-32000 then
						WinSetState($aRetWinList[$winnumber][1],"",@SW_MAXIMIZE)
						change()
					Else
						WinActivate($aRetWinList[$winnumber][1],"")
						snapshot($i)
						refresh()
					EndIf
				
				$i=$aRetWinList[0][1]
		;click is right click on picture minimize it
		ElseIf $hover[4]=$aRetWinList[0][1]+4 and $hover[3]= 1 Then
			WinSetState($aRetWinList[$winnumber][1],"",@SW_MINIMIZE)
		change()
		$i=$aRetWinList[0][1]
		;titlebar is left clicked set on top
	ElseIf $hover[4]=$aRetWinList[0][1]+5 and $hover[2]= 1 Then
		WinSetOnTop($aRetWinList[$winnumber][1],"",1)
		change()
		$i=$aRetWinList[0][1]
		;titlebar is right clicked set on top off
	ElseIf $hover[4]=$aRetWinList[0][1]+5 and $hover[3]= 1 Then
		WinSetOnTop($aRetWinList[$winnumber][1],"",0)
		change()
		$i=$aRetWinList[0][1]
	EndIf
	EndIf
Next
		;nothing is being hovered
	elseif $hover[4]=0 then
	if $peek=1 then
		change()
	EndIf
EndIf
EndFunc
func change()
		$peek=0
		GUICtrlDelete($picture)
		GUICtrlDelete($title)
		GUICtrlDelete($icon)
		GUISetControlsVisible($taskbar)
	GUISetState()

EndFunc
Func location($i)
	$xcoo=-76
	For $j = 1 to $i
		$xcoo=$xcoo+50
	Next
	return $xcoo
EndFunc
func snapshot($f)
			
			$aWinPos = WinGetPos($aRetWinList[$f][1])
			$hDC = _WinAPI_GetWindowDC($aRetWinList[$f][1])
			$hMemDC = _WinAPI_CreateCompatibleDC($hDC)
			$hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $aWinPos[2], $aWinPos[3])
			_WinAPI_SelectObject($hMemDC, $hBitmap)
			_PrintWindow($aRetWinList[$f][1], $hMemDC)
			_WinAPI_DeleteDC($hMemDC)
			_WinAPI_ReleaseDC($aRetWinList[$f][1], $hDC)
			_ScreenCapture_SaveImage(@ScriptDir &"\temp"&$f&".jpg", $hBitmap)
;create new x coordinate based on expected y coordinate of 125		
		$aRetWinList[$f][8]=125*$aWinPos[2]/$aWinPos[3]
	
	
EndFunc	
Func windx()
	;Alt hotkeys function
    If @HotKeyPressed = "#0" Then
		$x=$aRetWinList[2][1]
	Else
		$x=$aRetWinList[Int(StringMid(@HotKeyPressed, 2, 1))][1]
	EndIf
	$var2=WinGetPos($x,"")
	$state=WinGetState($x,"")
		If $var2[0]=-32000 then
			WinActivate($x,"")
			snapshot(Int(StringMid(@HotKeyPressed, 2, 1)))
		ElseIf not BitAND($state, 8) and $var2[0]<>-32000  then
			WinActivate($x,"")
		ElseIf $var2[0]<>-32000 then
			WinSetState($x,"",@SW_MINIMIZE)
		EndIf
	fixbuttons()
EndFunc

Func fixbuttons()
	; This function will ensure the button pressed is the active window
For $i = 1 To $aRetWinList[0][1]
	If WinActive($aRetWinList[$i][1],"") then
		If GUICtrlGetState($aRetWinList[$i][6])=$GUI_CHECKED Then
			$i = $aRetWinList[0][1]
		Else
			GUICtrlSetState($aRetWinList[$i][6], $GUI_CHECKED)
		EndIf
	else
		GUICtrlSetState($aRetWinList[$i][6], $GUI_unCHECKED)
	EndIf
Next
EndFunc

func peek($i,$minmaxed)
	;peek for maximized or restored windows
			;MsgBox(0,"",@ScriptDir &"\temp"&$i&".jpg")
			if StringInStr($aRetWinList[$i][0],"/")<>0 then
				$result = StringInStr($aRetWinList[$i][0],"/",0,-1)
				$result2 = StringLen($aRetWinList[$i][0])-$result
				$titl = Stringright($aRetWinList[$i][0],$result2)
			ElseIf StringInStr($aRetWinList[$i][0],"\")<>0 then
				$result = StringInStr($aRetWinList[$i][0],"\",0,-1)
				$result2 = StringLen($aRetWinList[$i][0])-$result
				$titl = Stringright($aRetWinList[$i][0],$result2)
			else
				$titl =$aRetWinList[$i][0]
			EndIf
			if $i=1 and $minmaxed=1 Then
				$picture=GUICtrlCreatePic(@ScriptDir &"\temp"&$i&".jpg",0, 16, $aRetWinList[$i][8], 125)	
				$title=GUICtrlCreateLabel($titl,0,0,$aRetWinList[$i][8], 16,$SS_left)
				$icon = GUICtrlCreateIcon("shell32.dll", 240, $aRetWinList[$i][8]-16, 0, 16, 16,$SS_SUNKEN,$WS_EX_TOPMOST)
		Elseif $minmaxed=1 then
				$picture=GUICtrlCreatePic(@ScriptDir &"\temp"&$i&".jpg",location($i), 16, $aRetWinList[$i][8], 125)	
				$title=GUICtrlCreateLabel($titl,location($i),0,$aRetWinList[$i][8]-16, 16,$SS_left)
				$icon = GUICtrlCreateIcon("shell32.dll", 240, location($i)+$aRetWinList[$i][8]-16, 0, 16, 16,$SS_SUNKEN,$WS_EX_TOPMOST)
		ElseIf $i=1 and $minmaxed=0 Then
		;Peek for Minimized windows
		
		$title=GUICtrlCreateLabel($titl,0,$iHeight-18,StringLen($titl)+55, 16,$SS_left)
		;in this case $picture is a placeholder and has been moved second, so clicking on title will behave like clicking on screencapture
		$picture=GUICtrlCreateLabel("nothing",-100,0)
		$icon = GUICtrlCreateIcon("shell32.dll", 240, StringLen($titl)+55, $iHeight-18, 16, 16,$SS_SUNKEN,$WS_EX_TOPMOST)
		Elseif $minmaxed=0 then
		$title=GUICtrlCreateLabel($titl,location($i),$iHeight-18,StringLen($titl)+50, 16,$SS_left)
		;in this case $picture is a placeholder and has been moved second, so clicking on title will behave like clicking on screencapture
		$picture=GUICtrlCreateLabel("nothing",-100,0)
		$icon = GUICtrlCreateIcon("shell32.dll", 240, location($i)+StringLen($titl)+50, $iHeight-18, 16, 16,$SS_SUNKEN,$WS_EX_TOPMOST)
			EndIf
	GUICtrlSetBkColor($icon, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont($icon,16,900,"arial")
	GUICtrlSetFont($title,11,400,"arial")
	GUICtrlSetBkColor($title,0x000000)
	GUICtrlSetColor($title,0xffffff)
		
		GUISetControlsVisible($taskbar)
		$peek=1
		$winnumber=$i
	GUISetState()
EndFunc


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


;;;;;;;;;;;;;Date and Time
Func Update()
$h = @HOUR
$m = @MIN
if $m<>$time Then

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
GUICtrlSetFont($date,12, 400,"verdana")
GUICtrlSetData($date, $h & ":" & $m&"  "&GetDayOfWeek() & " " & GetMonth() & " " & @MDAY)
$time=$m
EndIf
GUISetState()
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

Func Terminate()
	Exit 0
EndFunc
Func refresh()
	$refresh=1
	_WinListEx(Default, Default, $sExclude_List)
	$refresh=0
EndFunc
Func GUISetControlsVisible($hWnd)
    Local $aClassList, $aM_Mask, $aCtrlPos, $aMask
    
;Set $WS_POPUP style part:
    Local Const $GWL_STYLE = -16
    Local Const $GWL_EXSTYLE = -20
    Local Const $SWP_NOMOVE = 0x2
    Local Const $SWP_NOSIZE = 0x1
    Local Const $SWP_SHOWWINDOW = 0x40
    Local Const $SWP_NOZORDER = 0x4
    
    Local $iFlags = BitOR($SWP_SHOWWINDOW, $SWP_NOSIZE, $SWP_NOMOVE, $SWP_NOZORDER)
    DllCall("User32.dll", "int", "SetWindowLong", "hwnd", $hWnd, "int", $GWL_STYLE, "int", $WS_POPUP)
    DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $hWnd, "hwnd", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", $iFlags)
;End Set $WS_POPUP style part
    
    $aClassList = StringSplit(_WinGetClassListEx($hWnd), @LF)
    $aM_Mask = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", 0, "long", 0)
    
    For $i = 1 To UBound($aClassList) - 1
        $aCtrlPos = ControlGetPos($hWnd, '', $aClassList[$i])
        If Not IsArray($aCtrlPos) Then ContinueLoop
        
        $aMask = DllCall("gdi32.dll", "long", "CreateRectRgn", _
            "long", $aCtrlPos[0], _
            "long", $aCtrlPos[1], _
            "long", $aCtrlPos[0] + $aCtrlPos[2], _
            "long", $aCtrlPos[1] + $aCtrlPos[3])
        DllCall("gdi32.dll", "long", "CombineRgn", "long", $aM_Mask[0], "long", $aMask[0], "long", $aM_Mask[0], "int", 2)
    Next
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $hWnd, "long", $aM_Mask[0], "int", 1)
EndFunc

Func _WinGetClassListEx($sTitle)
    Local $sClassList = WinGetClassList($sTitle)
    Local $aClassList = StringSplit($sClassList, @LF)
    Local $sRetClassList = "", $sHold_List = "|"
    Local $aiInHold, $iInHold
    
    For $i = 1 To UBound($aClassList) - 1
        If $aClassList[$i] = "" Then ContinueLoop
        
        If StringRegExp($sHold_List, "\|" & $aClassList[$i] & "~(\d+)\|") Then
            $aiInHold = StringRegExp($sHold_List, ".*\|" & $aClassList[$i] & "~(\d+)\|.*", 1)
            $iInHold = Number($aiInHold[UBound($aiInHold)-1])
            
            If $iInHold = 0 Then $iInHold += 1
            
            $aClassList[$i] &= "~" & $iInHold + 1
            $sHold_List &= $aClassList[$i] & "|"
            
            $sRetClassList &= $aClassList[$i] & @LF
        Else
            $aClassList[$i] &= "~1"
            $sHold_List &= $aClassList[$i] & "|"
            $sRetClassList &= $aClassList[$i] & @LF
        EndIf
    Next
    
    Return StringReplace(StringStripWS($sRetClassList, 3), "~", "")
EndFunc


Func _PrintWindow($hWnd, $hMemDC, $iFlag = 0)
    $aRet = DllCall("User32.dll", "int", "PrintWindow", _
                                         "hwnd", $hWnd, _
                                         "hwnd", $hMemDC, _
                                         "int", $iFlag)
    Return $aRet[0]
EndFunc   ;==>_PrintWindow