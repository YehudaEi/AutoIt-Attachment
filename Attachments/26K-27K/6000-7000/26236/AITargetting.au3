#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=AITargetting.scr
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=AITargetting Screensaver
#AutoIt3Wrapper_Res_Description=AITargetting Screensaver
#AutoIt3Wrapper_Res_Fileversion=1.6
#AutoIt3Wrapper_Res_LegalCopyright=Crash Daemonicus
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-d
#Tidy_Parameters=/rel
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Auto-Targetting Screensaver
;By Crash Daemonicus (crashdemons)
FileInstall('.\move.wav', @ScriptDir & '\move.wav')
FileInstall('.\stop.wav', @ScriptDir & '\stop.wav')
FileInstall('.\target.wav', @ScriptDir & '\target.wav')
FileInstall('.\fakeout.wav', @ScriptDir & '\fakeout.wav')
; The following line is just to suspress extra SyntaxCheck/Au3Check extra Au3Check *warnings* - it's all defined before needed anyway.
Global $hGUI, $ReguMove, $hFormat, $ReguMove, $parent_PID, $child_PID, $ptext, $ptm, $DrawMode, $DrawDelay,$DoLockOn
Global $Exitting=False


Global $SetFile=@ScriptDir&'\AITargettingSS.ini'
Global $Settings=StringSplit('DrawMode|DrawDelay|DoLockOn','|')
LoadSetDefs()
LoadSets()
$DoLockOn=iLimit($DoLockOn,0,1)
$DrawMode=iLimit($DrawMode,0,1)



#include <Sound.au3>
#include <WinAPI.au3>
#include <GDIPlus.au3>
Global $Sounds[4] = ['move.wav', 'stop.wav', 'target.wav', 'fakeout.wav']
If WinExists("ScrnSav:" & @ScriptFullPath) Then WinClose("ScrnSav:" & @ScriptFullPath)
AutoItWinSetTitle("ScrnSav:" & @ScriptFullPath)
Global $CL
Local $CmdLinex = StringSplit($CmdLineRaw & ' ', ' '); is CmdLine not defined in later versions if blank or something??
$CL = StringLeft($CmdLinex[1], 2)
If Not @Compiled Then $CL = '/s'
Opt("GUIOnEventMode",1)
Switch StringTrimLeft($CL, 1)
	Case 's'
		Local $w = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 78);sm_virtualwidth
		Local $h = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 79);sm_virtualheight
		Local $x = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 76);sm_xvirtualscreen
		Local $y = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 77);sm_yvirtualscreen
		$w = $w[0]
		$h = $h[0]
		$x = $x[0]
		$y = $y[0]
		Init(0, $w, $h, $x, $y, True)
		Local $new, $last
		While $new >= $last and (Not $Exitting)
			$last = $new
			Draw($w, $h)
			Sleep($DrawDelay)
			$new = _IdleTicks()
		WEnd
		_Exit()
	Case 'p'
		If $CmdLine[0] < 2 Then
			MsgBox(0, 'AITargetting Screensaver', 'Invalid preview window information supplied.')
			Exit
		EndIf
		Init(HWnd($CmdLine[2]), 152, 112)
		$parent_PID = _ProcessGetParent(@AutoItPID)
		While Not $Exitting
			If Not WinExists($hGUI) Then _Exit()
			$child_PID = _ProcessGetChildren($parent_PID)
			If $child_PID[0] > 1 Then _Exit() ;if another screensaver is selected in ComboBox close ss
			Draw(152, 112)
			Sleep($DrawDelay)
		WEnd
		_Exit()
	Case Else;
		Global $Config_GUI=GUICreate("AITargetting SS Settings",205,140)
		GUISetOnEvent(-3,'Config_Cancel')
		GUICtrlCreateGroup('Draw Mode',1,0,200,70)
		Global $Config_DrawModeR0=GUICtrlCreateRadio('Clear Entire Image',5,20,150,20)
		Global $Config_DrawModeR1=GUICtrlCreateRadio('Erase Previous Drawn Area',05,40,150,20)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUICtrlCreateLabel('Frame Draw Delay',2,72,100,20)
		Global $Config_DrawDelay=GUICtrlCreateInput('',102,72,80,20)
		Global $Config_DoLockOn=GUICtrlCreateCheckbox('"Lock-on" to random points',2,92,200,20)
		GUICtrlCreateButton('Defaults',2,114,96,20)
		GUICtrlSetOnEvent(-1,'Config_Defaults')
		GUICtrlCreateButton('Save Settings',98,114,100,20)
		GUICtrlSetOnEvent(-1,'Config_Submit')
		Config_Load()
		While 1
			Sleep(300); doo dee doo da doo.
		WEnd
EndSwitch
Exit
Func Config_Defaults()
	LoadSetDefs()
	Config_Load()
EndFunc
Func Config_Submit()
	If BitAND(GUICtrlRead($Config_DrawModeR0), 1) = 1 Then $DrawMode=0
	If BitAND(GUICtrlRead($Config_DrawModeR1), 1) = 1 Then $DrawMode=1
	$DrawDelay=Int(GUICtrlRead($Config_DrawDelay))
	$DoLockOn=0
	If BitAND(GUICtrlRead($Config_DoLockOn), 1) = 1 Then $DoLockOn=1
	
	GUIDelete($Config_GUI)
	SaveSets()
	Exit
EndFunc
Func Config_Cancel()
	GUIDelete($Config_GUI)
	Exit
EndFunc
Func Config_Load()
	Local $Config_DrawModeRX=Eval('Config_DrawModeR'&$DrawMode)
	Local $Config_DoLockOnST=$DoLockOn
	If $Config_DoLockOnST=0 Then $Config_DoLockOnST=4
	GUICtrlSetState($Config_DrawModeRX,1)
	GUICtrlSetData($Config_DrawDelay,$DrawDelay&'ms')
	GUICtrlSetState($Config_DoLockOn,$Config_DoLockOnST)
	GUISetState()
EndFunc



Func LoadSetDefs(); possibly used in a Defaults button later
	Global $DrawMode=0
	Global $DrawDelay=50
	Global $DoLockOn=1
EndFunc
Func LoadSets()
	For $i=1 To UBound($Settings)-1
		Assign($Settings[$i],IniRead($SetFile,'Options',$Settings[$i],Eval($Settings[$i])),2)
		ConsoleWrite('INIR '&$Settings[$i]&'='&Eval($Settings[$i])&@CRLF)
	Next
EndFunc
Func SaveSets()
	For $i=1 To UBound($Settings)-1
		IniWrite($SetFile,'Options',$Settings[$i],Eval($Settings[$i]))
		ConsoleWrite('INIW '&$Settings[$i]&'='&Eval($Settings[$i])&@CRLF)
	Next
EndFunc

Func _CloseSS()
	Global $Exitting=True
EndFunc


Func Init($hWnd, $w, $h, $x = 0, $y = 0, $not_a_preview = False)
	Global $hDC, $gro, $hPen, $hGUI, $grb, $gr, $hPen2, $Sounds
	$hGUI = GUICreate('AITargetting Preview', $w, $h, $x, $y, 0x80000000)
	GUISetOnEvent(-3,'_CloseSS')
	GUISetBkColor(0, $hGUI)
	WinSetTrans($hGUI, '', 5)
	GUISetState(@SW_SHOW, $hGUI)
	WinSetOnTop($hGUI, '', 1)
	If $not_a_preview Then GUISetCursor(16, 1)
	_WinAPI_SetParent ($hGUI, $hWnd)
	_GDIPlus_Startup ()
	$hDC = _WinAPI_GetDC ($hGUI)
	$gro = _GDIPlus_GraphicsCreateFromHDC ($hDC)
	$grb = _GDIPlus_BitmapCreateFromGraphics ($w, $h, $gro)
	$gr = _GDIPlus_ImageGetGraphicsContext ($grb)
	$hPen = _GDIPlus_PenCreate (0xFF00FF00)
	$hPen2 = _GDIPlus_PenCreate (0xFFFF0000)
	Global $hBrush
	Global $hFormat = _GDIPlus_StringFormatCreate ()
	Global $hFamily = _GDIPlus_FontFamilyCreate ("Lucida Console")
	Global $hFont = _GDIPlus_FontCreate ($hFamily, 8, 2)
	Global $tLayout
	;_GDIPlus_GraphicsSetSmoothingMode ($gr, 2)
	For $i = 5 To 255 Step 50
		WinSetTrans($hGUI, '', $i); cheap fade-in
	Next
	;for targetting speed shifts - most of these were tested at 500x500
	Global $FastMove[2] = [Int((40 / 500) * $h), Int((20 / 500) * $h) ]
	Global $SlowMove[2] = [Int((15 / 500) * $h), Int((8 / 500) * $h) ]
	Global $SlowestMove = Int((10 / 768) * $h)
	;for regular floating
	Global $ReguMove[2] = [Int((1 / 500) * $h), Int((8 / 500) * $h) ]
	Global $target[4] = [Int((200 / 1024) * $w), Int((200 / 768) * $h), $ReguMove[0], $ReguMove[1]]
	Global $goto = False
	Global $XT = TimerInit()
	Global $point
	Global $ptext, $ptm
	Global $TargetTime = 5000
	Global $ifakeout = 0
	Global $ifakeout_max = 1
	For $i = 0 To 3
		If $not_a_preview Then
			$Sounds[$i] = _SoundOpen(@ScriptDir & '\' & $Sounds[$i])
		Else
			$Sounds[$i] = 0
		EndIf
	Next
EndFunc   ;==>Init
Func Draw($w, $h)
	;since the coordinates drawn here are relative to the GUI Created, the upper-left is always 0,0;
	; no need to worry about virtual coordinates.
	Global $Sounds, $hBrush, $hFormat, $hFont, $tLayout, $hPen, $hPen2, $gr, $gro, $grb, $DoLockOn
	Global $FastMove, $SlowMove, $SlowestMove
	Global $target, $goto, $XT, $TargetTime, $ifakeout, $ifakeout_max
	Global $point
	Local $line
	Local $k = Int((20 / 768) * $h)
	Local $k2 = Int((5 / 768) * $h)
	Local $x = $target[0]
	Local $y = $target[1]
	Local $thPen = $hPen
	Local $XTDiff = TimerDiff($XT)
	If $DoLockOn=1 And (Not $goto) And  $XTDiff > $TargetTime Then;False Then;
		$goto = True
		$target[2] = 0
		$target[3] = 0
		;$ygoto=True
		Local $pointx[2] = [Random($k, $w - $k, 1), Random($k, $h - $k, 1) ]
		$point = $pointx; shouldn't have to do this.
		$TargetTime = Random(5000, 15000, 1)
		$ifakeout = 0
		ConsoleWrite('*** Target Point (' & $point[0] & ',' & $point[1] & ')' & @CRLF)
		_SoundPlay($Sounds[2], 0)
		_SoundPlay($Sounds[2], 0)
	EndIf
	If $goto Then
		$thPen = $hPen2
		Local $xdiff = $point[0] - $target[0]
		Local $ydiff = $point[1] - $target[1]
		Local $xdiffa = Abs($xdiff)
		Local $ydiffa = Abs($ydiff)
		If $xdiff <> 0 Then
			ConsoleWrite(@TAB & 'Target X ' & $xdiff & @CRLF)
			$target[2] = $xdiff / $xdiffa
			Select
				Case $xdiffa > $FastMove[0]
					$target[2] *= $FastMove[1]
					_SoundPlay($Sounds[0], 0)
				Case $xdiffa > $SlowMove[0]
					$target[2] *= $SlowMove[1]
					_SoundPlay($Sounds[0], 0)
				Case $xdiffa >= $SlowestMove
					$target[2] *= $SlowestMove
					_SoundPlay($Sounds[1], 0)
				Case Else
					_SoundPlay($Sounds[1], 0)
			EndSelect
		Else
			$target[2] = 0
			If $ydiff <> 0 Then
				ConsoleWrite(@TAB & 'Target Y ' & $ydiff & @CRLF)
				$target[3] = $ydiff / $ydiffa
				Select
					Case $ydiffa > $FastMove[0]
						$target[3] *= $FastMove[1]
						_SoundPlay($Sounds[0], 0)
					Case $ydiffa > $SlowMove[0]
						$target[3] *= $SlowMove[1]
						_SoundPlay($Sounds[0], 0)
					Case $ydiffa >= $SlowestMove
						$target[3] *= $SlowestMove
						_SoundPlay($Sounds[1], 0)
					Case Else
						_SoundPlay($Sounds[1], 0)
				EndSelect
			Else
				If $ifakeout < $ifakeout_max And Random(0, 100, 1) < 40 Then; If there hasn't been $ifakeout_max fake-outs, there will be a 40% chance of getting one.
					$target[2] = 0
					$target[3] = 0
					Local $pointx[2] = [Random($k, $w - $k, 1), Random($k, $h - $k, 1) ]
					$point = $pointx
					$ifakeout += 1
					ConsoleWrite('- Target Faked-Out; Point (' & $point[0] & ',' & $point[1] & ')' & @CRLF)
					_SoundPlay($Sounds[3], 0)
				Else
					ConsoleWrite('- On Target' & @CRLF)
					$target[2] = Random($ReguMove[0], $ReguMove[1], 1)
					$target[3] = Random($ReguMove[0], $ReguMove[1], 1)
					$goto = False
					$thPen = $hPen
					$ptext = '+ 0064089BA72FF'
					$tLayout = 0
					$tLayout = _GDIPlus_RectFCreate ($point[0], $point[1], 100, 20)
					$XT = TimerInit()
					$ptm = TimerInit()
					$ifakeout = 0
					_SoundPlay($Sounds[2], 0)
				EndIf
			EndIf
		EndIf
	EndIf
	
	Local $ptmd = TimerDiff($ptm)
	Local $DrawTime, $unDrawTime
	For $i=0 To 1
		If $i=0 Then $DrawTime=TimerInit()
		If $i=1 Then $unDrawTime=TimerInit()
		;If $DrawMode=0 Then _GDIPlus_GraphicsClear ($gr, 0xFF000000)
		_GDIPlus_GraphicsDrawRect ($gr, $x - $k, $y - $k, $k * 2, $k * 2, $thPen);box
		_GDIPlus_GraphicsDrawLine ($gr, $x, -1, $x, $y - $k2, $thPen);top
		_GDIPlus_GraphicsDrawLine ($gr, $x, $y + $k2, $x, $h, $thPen);bottom
		_GDIPlus_GraphicsDrawLine ($gr, -1, $y, $x - $k2, $y, $thPen);left
		_GDIPlus_GraphicsDrawLine ($gr, $x + $k2, $y, $w, $y, $thPen);right
		
		If $i=0 Then
			
			If $ptmd < 5000 Then
				$hBrush = _GDIPlus_BrushCreateSolid (0xFF000000 + Floor(((5000 - $ptmd) / 5000) * 0xFF) * 0x10000)
				_GDIPlus_GraphicsDrawStringEx ($gr, $ptext, $hFont, $tLayout, $hFormat, $hBrush)
				_GDIPlus_BrushDispose ($hBrush)
			EndIf
			_GDIPlus_GraphicsDrawImageRect ($gro, $grb, 0, 0, $w, $h) ;copy to bitmap

			$thPen=0; overwrite black next loop
		Else
			If $ptmd < 5000 Then _GDIPlus_GraphicsFillRect($gr,$point[0],$point[1],100,20)
		EndIf
		
		
		If $i=0 Then ConsoleWrite('Draw Time: '&TimerDiff($DrawTime)&@CRLF)
		If $i=1 Then ConsoleWrite('Erase Time: '&TimerDiff($unDrawTime)&@CRLF)
		If $DrawMode=0 Then
			$unDrawTime=TimerInit()
			_GDIPlus_GraphicsClear ($gr, 0xFF000000)
			ConsoleWrite('Clear Time: '&TimerDiff($unDrawTime)&@CRLF)
			ExitLoop
		EndIf
	Next
	
	
	$target[0] += $target[2]
	$target[1] += $target[3]
	iLimit($target[0], $k, $w - $k)
	If @error Then $target[2] *= -1
	iLimit($target[1], $k, $h - $k)
	If @error Then $target[3] *= -1
EndFunc   ;==>Draw

	
	
Func iLimit($i, $n, $x)
	If $i >= $n And $i <= $x Then Return $i
	If $i < $n Then
		SetError(1)
		Return $n
	EndIf
	If $i > $x Then
		SetError(2)
		Return $x
	EndIf
EndFunc   ;==>iLimit
Func _Exit()
	Global $Sounds, $tLayout, $hFont, $hFamily, $hPen, $hPen2, $gr, $grb, $gro, $hDC
	For $i = 0 To 3
		_SoundClose($Sounds[$i])
	Next
	$tLayout = 0
	_GDIPlus_FontDispose ($hFont)
	_GDIPlus_StringFormatDispose ($hFormat)
	_GDIPlus_FontFamilyDispose ($hFamily)
	_GDIPlus_PenDispose ($hPen)
	_GDIPlus_PenDispose ($hPen2)
	_GDIPlus_GraphicsDispose ($gr)
	_GDIPlus_BitmapDispose ($grb)
	_GDIPlus_GraphicsDispose ($gro)
	_WinAPI_ReleaseDC (0, $hDC)
	Exit
EndFunc   ;==>_Exit
#Region OtherRequiredFuncs
Func _IdleTicks() ; thanks to erifash for the routine
	Local $aTSB = DllCall("kernel32.dll", "long", "GetTickCount")
	Local $ticksSinceBoot = $aTSB[0]
	Local $struct = DllStructCreate("uint;dword")
	DllStructSetData($struct, 1, DllStructGetSize($struct))
	DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($struct))
	Local $ticksSinceIdle = DllStructGetData($struct, 2)
	Return ($ticksSinceBoot - $ticksSinceIdle)
EndFunc   ;==>_IdleTicks
Func _ProcessGetParent($i_pid) ;get PID from parent process done by SmOke_N
	Local $TH32CS_SNAPPROCESS = 0x00000002
	Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
	If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_pid)
	Local $tagPROCESSENTRY32 = _
			DllStructCreate( _
			"dword dwsize;" & _
			"dword cntUsage;" & _
			"dword th32ProcessID;" & _
			"uint th32DefaultHeapID;" & _
			"dword th32ModuleID;" & _
			"dword cntThreads;" & _
			"dword th32ParentProcessID;" & _
			"long pcPriClassBase;" & _
			"dword dwFlags;" & _
			"char szExeFile[260]" _
			)
	DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))
	Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
	Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
	If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_pid)
	Local $a_pnext, $i_return = 0
	If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_pid Then
		$i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
		DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
		If $i_return Then Return $i_return
		Return $i_pid
	EndIf
	While @error = 0
		$a_pnext = DllCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
		If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_pid Then
			$i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
			If $i_return Then ExitLoop
			$i_return = $i_pid
			ExitLoop
		EndIf
	WEnd
	DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
	Return $i_return
EndFunc   ;==>_ProcessGetParent
Func _ProcessGetChildren($i_pid) ; First level children processes only done by SmOke_N
	Local Const $TH32CS_SNAPPROCESS = 0x00000002
	Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
	If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_pid)
	Local $tagPROCESSENTRY32 = _
			DllStructCreate _
			( _
			"dword dwsize;" & _
			"dword cntUsage;" & _
			"dword th32ProcessID;" & _
			"uint th32DefaultHeapID;" & _
			"dword th32ModuleID;" & _
			"dword cntThreads;" & _
			"dword th32ParentProcessID;" & _
			"long pcPriClassBase;" & _
			"dword dwFlags;" & _
			"char szExeFile[260]" _
			)
	DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))
	Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
	Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
	If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_pid)
	Local $a_pnext, $a_children[11] = [10], $i_child_pid, $i_parent_pid, $i_add = 0
	$i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")
	If $i_child_pid <> $i_pid Then
		$i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
		If $i_parent_pid = $i_pid Then
			$i_add += 1
			$a_children[$i_add] = $i_child_pid
		EndIf
	EndIf
	While 1
		$a_pnext = DllCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
		If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop
		$i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")
		If $i_child_pid <> $i_pid Then
			$i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
			If $i_parent_pid = $i_pid Then
				If $i_add = $a_children[0] Then
					ReDim $a_children[$a_children[0] + 10]
					$a_children[0] = $a_children[0] + 10
				EndIf
				$i_add += 1
				$a_children[$i_add] = $i_child_pid
			EndIf
		EndIf
	WEnd
	If $i_add <> 0 Then
		ReDim $a_children[$i_add + 1]
		$a_children[0] = $i_add
	EndIf
	DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
	If $i_add Then Return $a_children
	Return SetError(3, 0, 0)
EndFunc   ;==>_ProcessGetChildren
#EndRegion OtherRequiredFuncs