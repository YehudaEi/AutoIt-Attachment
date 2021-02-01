#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.1.1 (beta)
 Author:         AdmiralAlkex

 Script Function:
	Image viewer.

ToDo:
Optimera matematiken bakom alla positioner.								KLART v4.
Optimera animering.														KLART v4.
Kunna starta exefilen direkt.											KLART v4.
Klocka.																	KLART v4.
Batterimätare.															KLART v4.
Spellista (kanske typ som TCPMP?).										KLART v4.
Effekter när bilden byts.												KLART v4.
Valbart om autorotering ska ske.										KLART v4.
Välja om rotering ska ske med 90 lr 270 grader.							KLART v4.
Stänga HUD utan att något händer.										KLART v4.
Rekursiv addning av mappar.												KLART v4.
Fixa "smooth" buggen.													KLART v5.
Riktig Fullscreen.														KLART v5.
Fixa "batteri" buggen.													KLART v5.

#ce ----------------------------------------------------------------------------

#Region ;Start
If @AutoItVersion < "3.3.1.1" Then Exit

Global $aPlayList[1], $iRecursiveDrop = IniRead("Settings.ini", "Beta", "RecursiveDrops", 0), $iGuiActive = 0, $hListView = 0, $hIAmADummy
If $CmdLine[0] = 0 Then
	$sFolder = FileSelectFolder("Please select folder to search for images", "")
	If $sFolder = "" Then Exit
	_PlayListAdd($sFolder)
Else
	For $X = 1 To $CmdLine[0]
		If StringInStr(FileGetAttrib($CmdLine[$X]), "D") Then
			_PlayListAdd($CmdLine[$X])
		EndIf
	Next
EndIf
_FastArrayDel($aPlayList, 0)
If $aPlayList[0] = "" Then Exit

#Include "SDL_sprig.au3"
#Include "SDL_image.au3"
#Include "SDL_gfx.au3"
#Include "SDL.au3"
#Include <Array.au3>
#Include <File.au3>

OnAutoItExitRegister("_Quit")

Global $iNull = 0, $iFull = 16777215, $iCurrent = -1, $iSlideShowEnabled = False, $iRandomize = False, $iVisibleBack = 0, $GW, $GH, $GZ, $GR

$GX = Execute(IniRead("Settings.ini", "Stable", "GuiWidth", @DesktopWidth))			;Execute allows macros in the inifile ;)
$GY = Execute(IniRead("Settings.ini", "Stable", "GuiHeight", @DesktopHeight))			;Execute allows macros in the inifile ;)
$ISmoothness = IniRead("Settings.ini", "Beta", "SmoothZoom", 1)
$iThickness = Execute(IniRead("Settings.ini", "Beta", "LineWidth", $GX/200))
$iSlideShowTime = IniRead("Settings.ini", "Beta", "SlideShowTime", 5000)
$iCachingMethod = IniRead("Settings.ini", "Beta", "CachingMethod", 0)
$iRotateDegrees = IniRead("Settings.ini", "Beta", "RotateDegrees", 270)
$iRotateAuto = IniRead("Settings.ini", "Beta", "RotateAuto", 1)
$iSFXMethod = IniRead("Settings.ini", "Beta", "SFX", 0)
$iFullscreen = IniRead("Settings.ini", "Beta", "Fullscreen", 0)
$iFullscreenGX = Execute(IniRead("Settings.ini", "Beta", "FullscreenWidth", @DesktopWidth))			;Dunno?
$iFullscreenGY = Execute(IniRead("Settings.ini", "Beta", "FullscreenHeight", @DesktopHeight))			;Dunno?
$iGuiX = IniRead("Settings.ini", "Beta", "GuiX", 0)
$iGuiY = IniRead("Settings.ini", "Beta", "GuiY", 0)

If $iSFXMethod Then $iCachingMethod = 4		;Required for SFX effects.

EnvSet("SDL_VIDEO_WINDOW_POS", $iGuiX & ", " & $iGuiY)

_SDL_Init_image()
_SDL_Startup_gfx()
_SDL_Startup_sprig()
_SDL_Init($_SDL_INIT_VIDEO)

For $X = $_SDL_NOEVENT To $_SDL_NUMEVENTS -1
	_SDL_EventState($X, $_SDL_IGNORE)
Next
_SDL_EventState($_SDL_MOUSEBUTTONDOWN, $_SDL_ENABLE)

Switch $iCachingMethod
	Case 0 ;No caching
	Case 1 ;Keep 5 latest in memory
		Global $Cache[1][2]
	Case 2 ;Preload all images
		$UB = UBound($aPlayList) -1
		Global $Cache[$UB +1]
		For $X = 0 To $UB
			$Cache[$X] = _IMG_Load($aPlayList[$X])
		Next
	Case 3 ;Current + Preload 1 image
		Global $Cache[1][2]
	Case 4 ;Like 0 but for SFX
		Global $Cache[1][2]
EndSwitch

Local $iFlags = BitOR($_SDL_SWSURFACE, $_SDL_NOFRAME)
If $iFullscreen <> 0 Then $iFlags = BitOR($iFlags, $_SDL_FULLSCREEN)
$pSurface = _SDL_GuiCreate(@ScriptName, $GX, $GY, 32, $iFlags)

#Region Create background ;Too much math, needs optimizing
;ProfileBlockStart("_Background")
$Background = _SDL_CreateRGBSurface($_SDL_SWSURFACE, $GX, $GY, 32, $iNull, $iNull, $iNull, $iNull)
_SDL_SetColorKey($Background, BitOR($_SDL_SRCCOLORKEY, $_SDL_RLEACCEL), $iNull)
_SPG_PushThickness($iThickness)

_SPG_LineHFade($Background, $GX*0.80, $GY*0.25, $GX, $iFull, $iNull)
_SPG_LineHFade($Background, $GX*0.20, $GY*0.50, $GX, $iFull, $iNull)
_SPG_LineHFade($Background, $GX*0.80, $GY*0.75, $GX, $iFull, $iNull)

_SPG_LineHFade($Background, 0, $GY*0.25, $GX*0.20, $iFull, $iNull)

_SPG_LineFade($Background, $GX*0.20, 0, $GX*0.20, $GY, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.80, 0, $GX*0.80, $GY, $iFull, $iNull)

_SPG_LineFade($Background, $GX*0.83, $GY*0.03, $GX*0.97, $GY*0.22, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.97, $GY*0.03, $GX*0.83, $GY*0.22, $iFull, $iNull)

_SPG_TrigonFade($Background, $GX*0.83, $GY*0.28, $GX*0.90, $GY*0.3275, $GX*0.83, $GY*0.375, $iNull, $iNull, $iFull)
_SPG_LineFade($Background, $GX*0.83, $GY*0.375, $GX*0.90, $GY*0.47, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.83, $GY*0.375, $GX*0.83, $GY*0.47, $iFull, $iNull)

_SPG_TrigonFade($Background, $GX*0.83, $GY*0.53, $GX*0.97, $GY*0.625, $GX*0.83, $GY*0.72, $iFull, $iNull, $iFull)

_SPG_LineFade($Background, $GX*0.50, $GY*0.10, $GX*0.30, $GY*0.30, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.50, $GY*0.10, $GX*0.70, $GY*0.30, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.50, $GY*0.20, $GX*0.30, $GY*0.40, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.50, $GY*0.20, $GX*0.70, $GY*0.40, $iFull, $iNull)

_SPG_LineFade($Background, $GX*0.50, $GY*0.80, $GX*0.30, $GY*0.60, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.50, $GY*0.80, $GX*0.70, $GY*0.60, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.50, $GY*0.90, $GX*0.30, $GY*0.70, $iFull, $iNull)
_SPG_LineFade($Background, $GX*0.50, $GY*0.90, $GX*0.70, $GY*0.70, $iFull, $iNull)
;ProfileBlockStop()
#EndRegion

$iCurrent = 0
_MazyImage(StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)))
#EndRegion

#Region ;Main-loop
While 1
	Sleep(10)

	Do
		$Temp = _SDL_PollEvent4()
	Until $Temp = 0
WEnd
#EndRegion

#Region ;Playlist
Func _PlayListAdd($sFileFolder)
	Local $aFileExt[5] = ["jpg", "jpeg", "png", "bmp", "gif"]
	For $Y = 0 To UBound($aFileExt) -1
		$hSearch = FileFindFirstFile($sFileFolder & "\*." & $aFileExt[$Y])
		While 1
			$sFile = FileFindNextFile($hSearch)
			If @error Then ExitLoop

			$UB = UBound($aPlayList)
			ReDim $aPlayList[$UB+1]
			$aPlayList[$UB] = $sFileFolder & "\" & $sFile

			If $iGuiActive = 1 Then GUICtrlCreateListViewItem($sFileFolder & "\" & $sFile, $hListView)
		WEnd
	Next

	If $iRecursiveDrop = 1 Then
		Local $aTemp = _FileListToArray($sFileFolder, "*", 2)
		If @error <> 0 Then Return
		For $X = 1 To $aTemp[0]
			_PlayListAdd($sFileFolder & "\" & $aTemp[$X])
		Next
	EndIf
EndFunc

Func _PlayListAddFile($sFile)
	$UB = UBound($aPlayList)
	ReDim $aPlayList[$UB+1]
	$aPlayList[$UB] = $sFile

	If $iGuiActive = 1 Then GUICtrlCreateListViewItem($sFile, $hListView)
EndFunc

Func _SuperLoad()
	If $iCachingMethod = 0 Then
		Return _IMG_Load($aPlayList[$iCurrent])
	ElseIf $iCachingMethod = 1 Then
		$UB = UBound($Cache)
		For $X = 1 To $UB -1
			If $Cache[$X][0] = $iCurrent Then Return $Cache[$X][1]
		Next
		If $UB = 6 Then
			_SDL_FreeSurface($Cache[1][1])
			_ArrayDelete($Cache, 1)
			$UB = UBound($Cache)
		EndIf

		$iTemp = _IMG_Load($aPlayList[$iCurrent])
		ReDim $Cache[$UB +1][2]
		$Cache[$UB][0] = $iCurrent
		$Cache[$UB][1] = $iTemp
		Return $iTemp
	ElseIf $iCachingMethod = 2 Then
		Return $Cache[$iCurrent]
	ElseIf $iCachingMethod = 3 Then
		$UB = UBound($Cache)
		For $X = 1 To $UB -1
			If $Cache[$X][0] = $iCurrent Then Return $Cache[$X][1]
		Next
		If $UB = 3 Then
			_SDL_FreeSurface($Cache[1][1])
			_ArrayDelete($Cache, 1)
			$UB = UBound($Cache)
		EndIf

		$iTemp = _IMG_Load($aPlayList[$iCurrent])
		ReDim $Cache[$UB +1][2]
		$Cache[$UB][0] = $iCurrent
		$Cache[$UB][1] = $iTemp
		Return $iTemp
	ElseIf $iCachingMethod = 4 Then
		$UB = UBound($Cache)

		If $UB = 3 Then
			_SDL_FreeSurface($Cache[1][1])
			_ArrayDelete($Cache, 1)
			$UB = UBound($Cache)

			$iTemp = _IMG_Load($aPlayList[$iCurrent])
			ReDim $Cache[$UB +1][2]
			$Cache[$UB][0] = $iCurrent
			$Cache[$UB][1] = $iTemp
			Return $iTemp
		Else
			$iTemp = _IMG_Load($aPlayList[$iCurrent])
			ReDim $Cache[$UB +1][2]
			$Cache[$UB][0] = $iCurrent
			$Cache[$UB][1] = $iTemp
			Return $iTemp
		EndIf
	EndIf
EndFunc

Func _Randomize()
	$UB = UBound($aPlayList)
	Local $aRanPlayList[$UB]

	For $X = $UB -1 To 0 Step -1
		$Ran = Random(0, UBound($aPlayList) -1, 1)
		$aRanPlayList[$X] = $aPlayList[$Ran]
		_FastArrayDel($aPlayList, $Ran)
	Next
	$aPlayList = $aRanPlayList
EndFunc

Func _Next()
	$iCurrent += 1
	If $iCurrent = UBound($aPlayList) Then $iCurrent = 0

	_MazyImage(StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)))
EndFunc

Func _Previous()
	$iCurrent -= 1
	If $iCurrent < 0 Then $iCurrent = UBound($aPlayList)-1

	_MazyImage(StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)))
EndFunc
#EndRegion

#Region ;Drawing stuff
Func _MazyImage($sMessage, $DontAnimate = 0)
	_SDL_FillRect($pSurface, 0, _SDL_MapRGB($pSurface, 0x00, 0x00, 0x00))
	$pImg = _SuperLoad()
	_BlitImage($pImg, $DontAnimate)

	_SDL_stringRGBA($pSurface, 2, 2, $sMessage, 255, 0, 0, 255)
	_SDL_Flip($pSurface)

	Switch $iCachingMethod
		Case 0
			_SDL_FreeSurface($pImg)
		Case 3
			If $iCurrent +1 > UBound($aPlayList) -1 Then
				$iTemp = 0
			Else
				$iTemp = $iCurrent +1
			EndIf

			$UB = UBound($Cache)
			If $UB = 3 Then
				_SDL_FreeSurface($Cache[1][1])
				_ArrayDelete($Cache, 1)
				$UB = UBound($Cache)
			EndIf

			$UB = UBound($Cache)
			ReDim $Cache[$UB +1][2]
			$Cache[$UB][0] = $iTemp
			$Cache[$UB][1] = _IMG_Load($aPlayList[$iTemp])
	EndSwitch
EndFunc

Func _BlitImage($pSrc, $DontAnimate)		;Could be optimized
	$hStruct = DllStructCreate($tagSDL_SURFACE, $pSrc)
	$W = DllStructGetData($hStruct, "w")
	$Y = DllStructGetData($hStruct, "h")

	Local $DW, $DH, $DZ = 1
	If $W >= $Y Or $iRotateAuto <> 1 Then	;Bilden är större på bredden så vi behöver bara zooma
		$ZoomX = $GX / $W
		$ZoomY = $GY / $Y
		If $ZoomX < $ZoomY Then
			$DZ = $ZoomX
		Else
			$DZ = $ZoomY
		EndIf
		$pDst = _SDL_zoomSurface($pSrc, $DZ, $DZ, $ISmoothness)
		$GR = 0
	Else	;Bilden är större på höjden så vi måste rotera och sen zooma
		$ZoomX = $GX / $Y
		$ZoomY = $GY / $W
		If $ZoomX < $ZoomY Then
			$DZ = $ZoomX
		Else
			$DZ = $ZoomY
		EndIf
		$pDst = _SDL_rotozoomSurface($pSrc, $iRotateDegrees, $DZ, $ISmoothness)
		$GR = 1
	EndIf
	$hStruct = $iNull

	$hStruct2 = DllStructCreate($tagSDL_SURFACE, $pDst)
	$DW = DllStructGetData($hStruct2, "w")
	$DH = DllStructGetData($hStruct2, "h")
	$DX = ($GX-$DW)/2
	$DY = ($GY-$DH)/2
	$hStruct2 = $iNull

	If $iSFXMethod = 0 Or $DontAnimate = 1 Then
		_SDL_BlitSurface($pDst, 0, $pSurface, _SDL_Rect_Create($DX, $DY, $iNull, $iNull))
	ElseIf $iSFXMethod = 1 Then
		If UBound($Cache) -1 = 2 Then
			If $GR <> 1 Then
				$pTemp = _SDL_zoomSurface($Cache[1][1], $GZ, $GZ, $ISmoothness)
			Else		;Bilden roteras inte som den ska. Bug. TRASIG.
				$pTemp = _SDL_rotozoomSurface($Cache[1][1], $iRotateDegrees, $GZ, $ISmoothness)
			EndIf
			$pTemp3 = _SDL_DisplayFormat($pTemp)
			$pTemp2 = _SDL_DisplayFormat($pDst)

			For $X = 0 to 255 Step +51
				_SDL_SetAlpha($pTemp3, $_SDL_SRCALPHA, 255-$X)
				_SDL_SetAlpha($pTemp2, $_SDL_SRCALPHA, $X)

				_SDL_FillRect($pSurface, 0, _SDL_MapRGB($pSurface, 0x00, 0x00, 0x00))
				_SDL_BlitSurface($pTemp3, 0, $pSurface, _SDL_Rect_Create($GW, $GH, $iNull, $iNull))
				_SDL_BlitSurface($pTemp2, 0, $pSurface, _SDL_Rect_Create($DX, $DY, $iNull, $iNull))
				_SDL_Flip($pSurface)

				Sleep(75)
			Next

			_SDL_FreeSurface($pTemp)
			_SDL_FreeSurface($pTemp2)
			_SDL_FreeSurface($pTemp3)
		Else
			_SDL_BlitSurface($pDst, 0, $pSurface, _SDL_Rect_Create($DX, $DY, $iNull, $iNull))
		EndIf
	ElseIf $iSFXMethod = 2 Then
		If UBound($Cache) -1 = 2 Then
			If $GR <> 1 Then
				$pTemp = _SDL_zoomSurface($Cache[1][1], $GZ, $GZ, $ISmoothness)
			Else		;Bilden roteras inte som den ska. Bug. TRASIG.
				$pTemp = _SDL_rotozoomSurface($Cache[1][1], $iRotateDegrees, $GZ, $ISmoothness)
			EndIf
			$pTemp3 = _SDL_DisplayFormat($pTemp)
			$pTemp2 = _SDL_DisplayFormat($pDst)
			$pTemp4 = _SDL_CreateRGBSurface($_SDL_SWSURFACE, $GX, $GY, 32, 0, 0, 0, 0)
			_SDL_BlitSurface($pTemp3, 0, $pTemp4, _SDL_Rect_Create($GW, $GH, $iNull, $iNull))

			For $X = 1 To $GY
				_SDL_BlitSurface($pTemp4, _SDL_Rect_Create(1, $X, $GX, 1), $pSurface, _SDL_Rect_Create(1, $X, $iNull, $iNull))
				_SDL_Flip($pSurface)

				Sleep(0)
			Next

			_SDL_FreeSurface($pTemp)
			_SDL_FreeSurface($pTemp2)
			_SDL_FreeSurface($pTemp3)
			_SDL_FreeSurface($pTemp4)
		Else
			_SDL_BlitSurface($pDst, 0, $pSurface, _SDL_Rect_Create($DX, $DY, $iNull, $iNull))
		EndIf
	ElseIf $iSFXMethod = 3 Then
		If UBound($Cache) -1 = 2 Then
			If $GR <> 1 Then
				$pTemp = _SDL_zoomSurface($Cache[1][1], $GZ, $GZ, $ISmoothness)
			Else		;Bilden roteras inte som den ska. Bug. TRASIG.
				$pTemp = _SDL_rotozoomSurface($Cache[1][1], $iRotateDegrees, $GZ, $ISmoothness)
			EndIf
			$pTemp3 = _SDL_DisplayFormat($pTemp)
			$pTemp2 = _SDL_DisplayFormat($pDst)
			$pTemp4 = _SDL_CreateRGBSurface($_SDL_SWSURFACE, $GX, $GY, 32, 0, 0, 0, 0)
			_SDL_BlitSurface($pTemp3, 0, $pTemp4, _SDL_Rect_Create($GW, $GH, $iNull, $iNull))

			For $X = 1 To $GX
				_SDL_BlitSurface($pTemp4, _SDL_Rect_Create($X, 1, 1, $GY), $pSurface, _SDL_Rect_Create($X, 1, $iNull, $iNull))
				_SDL_Flip($pSurface)

				Sleep(0)
			Next

			_SDL_FreeSurface($pTemp)
			_SDL_FreeSurface($pTemp2)
			_SDL_FreeSurface($pTemp3)
			_SDL_FreeSurface($pTemp4)
		Else
			_SDL_BlitSurface($pDst, 0, $pSurface, _SDL_Rect_Create($DX, $DY, $iNull, $iNull))
		EndIf
	EndIf
	$GW = $DX
	$GH = $DY
	$GZ = $DZ

	_PowerBar()

	_SDL_FreeSurface($pDst)
EndFunc

Func _PowerBar()
	_SDL_stringRGBA($pSurface, 2, 11, @HOUR & ":" & @MIN, 255, 0, 0, 255)

	$aTemp = _GetSystemPowerStatus()
	If IsArray($aTemp) <> 0 Then
		If $aTemp[1] = 255 then Return
		Select
			Case BitAND($aTemp[0], 128) Or BitAND($aTemp[0], 255)		;No battery or unknown
				Return
			Case $aTemp[1] > 66											;Over 66%
				$iColor = 0x00FF00
			Case $aTemp[1] < 33											;Under 33%
				$iColor = 0xFF0000
			Case Else													;Between 33-66%
				$iColor = 0xFFFF00
		EndSelect

		$aTemp[1] = Number("0." & $aTemp[1])
		_SPG_LineH($pSurface, 0, $GY, $GX*$aTemp[1], $iColor)
	EndIf
EndFunc
#EndRegion

#Region ;Internal
Func _FastArrayDel(ByRef $Array, $Element)
	$UBTemp = UBound($Array)-1
	If $UBTemp = 0 Then Return
	$Array[$Element] = $Array[$UBTemp]
	ReDim $Array[$UBTemp]
EndFunc

Func _SDL_PollEvent4()
	Local $A1 = DllStructCreate($tagSDL_Event)
	DllStructSetData($A1, 1, 1)
	$iTemp = DllCall($__SDL_DLL, "int:cdecl", "SDL_PollEvent", "ptr", DllStructGetPtr($A1))
	If $iTemp[0] = 1 Then
		$B2 = DllStructCreate($tagSDL_SDL_MouseButtonEvent, DllStructGetPtr($A1))
		$X = DllStructGetData($B2, "x")
		$Y = DllStructGetData($B2, "y")
		Select
			Case $X > $GX*0.80 And $Y > $GY*0.75	;NinjaPad
				$B = DllStructGetData($B2, "button")
				If $B = 1 Then
					_Previous()
				ElseIf $B = 3 Then
					_Next()
				EndIf
			Case $X < $GX*0.20 And $Y > $GY*0.25	;Show/Hide HUD
				If $iVisibleBack = 0 Then
					_SDL_BlitSurface($Background, 0, $pSurface, 0)
					_SDL_stringRGBA($pSurface, 2, 2, StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)), 255, 0, 0, 255);Optimera
					_SDL_Flip($pSurface)
					$iVisibleBack = 1
				Else
					_MazyImage(StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)), 1)
					$iVisibleBack = 0
				EndIf
			Case $X < $GX*0.20 And $Y < $GY*0.25	;Activate playlist
				$hWnd = GUICreate(@ScriptName & " Playlist editor", $GX, $GY, 0, 0, 0x80000000);$WS_POPUP
				Global $hIAmADummy = GUICtrlCreateDummy()
				$hButtonBack = GUICtrlCreateButton("Go back to viewer", 10, 10, 130, 40)
				$hButtonRecursive = GUICtrlCreateButton("Add folder (recursive)", 10, 60, 130, 40)
				$hButtonFolder = GUICtrlCreateButton("Add folder", 10, 110, 130, 40)
				$hButtonFile = GUICtrlCreateButton("Add file", 10, 160, 130, 40)
				$hButtonDelete = GUICtrlCreateButton("Delete selected item(s)", 10, 210, 130, 40)
				Global $hListView = GUICtrlCreateListView("Files", 150, 10, $GX-160, $GY-20)

				For $X = 0 To UBound($aPlayList)-1
					GUICtrlCreateListViewItem($aPlayList[$X], $hListView)
				Next
				GUICtrlSendMsg($hListView, 4126, 0, -1) ;4126 = $LVM_SETCOLUMNWIDTH, -1 = $LVSCW_AUTOSIZE

				GUISetState()
				WinSetOnTop($hWnd, "", 1)
				$iGuiActive = 1

				While 1
					Switch GUIGetMsg()
						Case -3, $hButtonBack ;$GUI_EVENT_CLOSE
							ExitLoop
						Case $hButtonRecursive
							$sFolder = FileSelectFolder("Please select folder to search for images", "")
							If $sFolder = "" Then Exit
							$iRecursiveDrop = 1
							_ButtonDisable()
							_PlayListAdd($sFolder)
							_ButtonEnable()
						Case $hButtonFolder
							$sFolder = FileSelectFolder("Please select folder to search for images", "")
							If $sFolder = "" Then Exit
							$iRecursiveDrop = 0
							_ButtonDisable()
							_PlayListAdd($sFolder)
							_ButtonEnable()
						Case $hButtonFile
							$sFile = FileOpenDialog("Please select file to import", "", "All (*.*)", 1+2+4)
							FileChangeDir(@ScriptDir)
							If @error = 1 Then Exit
							If StringInStr($sFile, "|") <> 0 Then
								$aTemp = StringSplit($sFile, "|")

								For $X = 2 To $aTemp[0]
									_ButtonDisable()
									_PlayListAddFile($aTemp[1] & "\" & $aTemp[$X])
									_ButtonEnable()
								Next
							Else
								_PlayListAddFile($sFile)
							EndIf
					EndSwitch
				WEnd
				$iGuiActive = 0
				GUIDelete($hWnd)
			Case $X > $GX*0.80 And $Y < $GY*0.25	;Exit
				Exit
			Case $X > $GX*0.80 And $Y < $GY*0.50	;Random
				$iRandomize = True
				_Randomize()

				$iCurrent = 0
				_MazyImage(StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)), 1)
			Case $X > $GX*0.80 And $Y > $GY*0.50	;Slideshow
				_MazyImage(StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)), 1)
				$Timer = TimerInit()
				While 1
					Sleep(10)

					Local $C1 = DllStructCreate($tagSDL_Event)
					DllStructSetData($C1, 1, 1)
					$iTemp = DllCall($__SDL_DLL, "int:cdecl", "SDL_PollEvent", "ptr", DllStructGetPtr($C1))
					If $iTemp[0] = 1 Then
						$C2 = DllStructCreate($tagSDL_SDL_MouseButtonEvent, DllStructGetPtr($C1))
						$X = DllStructGetData($C2, "x")
						$Y = DllStructGetData($C2, "y")
						Select
							Case $X > $GX*0.20
								ExitLoop
							Case $Y < $GY*0.50
								$iSlideShowTime = Int($iSlideShowTime * 1.1)
								_MazyImage("Slideshow will now wait " & $iSlideShowTime & " ms between slides", 1)
							Case $Y > $GY*0.50
								$iSlideShowTime = Int($iSlideShowTime * 0.9)
								_MazyImage("Slideshow will now wait " & $iSlideShowTime & " ms between slides", 1)
						EndSelect
					EndIf

					If TimerDiff($Timer) > $iSlideShowTime Then
						_Next()
						$Timer = TimerInit()
					EndIf
				WEnd
			Case $Y < $GY*0.50	;Previous
				_Previous()
			Case $Y > $GY*0.50	;Next
				_Next()
		EndSelect

		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func _ButtonDisable()
	For $X = $hIAmADummy +1 To $hListView
		GUICtrlSetState($X, 128) ;$GUI_DISABLE
	Next
EndFunc

Func _ButtonEnable()
	For $X = $hIAmADummy +1 To $hListView
		GUICtrlSetState($X, 64) ;$GUI_ENABLE
	Next
EndFunc

Func _GetSystemPowerStatus()
	Local $tagStruct = DllStructCreate('ubyte ACLineStatus;ubyte BatteryFlag;ubyte BatteryLifePercent;ubyte Reserved1;ulong BatteryLifeTime;ulong BatteryFullLifeTime')
	Local $aTemp1, $aTemp2[2]

	$aTemp1 = DllCall('kernel32.dll', 'int', 'GetSystemPowerStatus', 'ptr', DllStructGetPtr($tagStruct))
	If (@error) Or ($aTemp1[0] = 0) Then Return 0
	$aTemp2[0] = DllStructGetData($tagStruct, 2) ;BatteryFlag
	$aTemp2[1] = DllStructGetData($tagStruct, 3) ;BatteryLifePercent
	Return $aTemp2
EndFunc

Func _Quit()
	ConsoleWrite("Reason for exit: " & @ExitMethod & @CRLF)
	If $__SDL_DLL <> -1 Then _SDL_Quit()
	If $__SDL_DLL_sprig <> -1 Then _SDL_Shutdown_sprig()
	If $__SDL_DLL_image <> -1 Then _SDL_Shutdown_image()
	If $__SDL_DLL_gfx <> -1 Then _SDL_Shutdown_gfx()
	Exit
EndFunc
#EndRegion
