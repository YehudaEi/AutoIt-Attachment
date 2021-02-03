#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
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
Bort med rotationer, animationer och annat skit, förenkla allt!			KLART v7.
Automatiskt hitta vilka format som får öppnas.							KLART v7.
Flytta tid och batteri-hämtning till adlib.								KLART v7.
Gå igenom alla funktioner och optimera!!								KLART v7.
Fixa så att $iRecursiveDrop bara kollas 1 gång.							KLART v7.

#ce ----------------------------------------------------------------------------

#Region ;Start
Global $aPlayList[1]
Opt("TrayIconDebug", 1)
FileChangeDir(@ScriptDir)

If IniRead(@ScriptDir & "/Settings.ini", "Beta", "FirstTimeRun", 1) <> 0 Then
	IniWrite(@ScriptDir & "/Settings.ini", "Beta", "MouseVisible", MsgBox(4+32+262144, "1/3 questions asked", "Do you want your mouse pointer to be visible??"))
	IniWrite(@ScriptDir & "/Settings.ini", "Beta", "RecursiveDrops", MsgBox(4+32+262144, "2/3 questions asked", "Do you want folder searches to be recursive??"))
	For $X = 3 To 9223372036854775807		;hehe
		If MsgBox(4+32+256+262144, $X & "/" & $X & " questions asked", _
			'To get these questions again delete the file "settings.ini".' & _
			@CRLF & @CRLF & "Do you understand??") <> 7 Then ExitLoop
	Next
	IniWrite(@ScriptDir & "/Settings.ini", "Beta", "FirstTimeRun", 0)
EndIf

Local $aFileExt[2] = ["bmp", "gif"]
If FileExists(@ScriptDir & "/jpeg.dll") Then
	ReDim $aFileExt[UBound($aFileExt) +2]
	$aFileExt[UBound($aFileExt) -2] = "jpg"
	$aFileExt[UBound($aFileExt) -1] = "jpeg"
EndIf
If FileExists(@ScriptDir & "/libpng12-0.dll") And FileExists(@ScriptDir & "/zlib1.dll") Then
	ReDim $aFileExt[UBound($aFileExt) +1]
	$aFileExt[UBound($aFileExt) -1] = "png"
EndIf

If IniRead(@ScriptDir & "/Settings.ini", "Beta", "RecursiveDrops", 0) <> 7 Then
	For $X = 1 To $CmdLine[0]
		If StringInStr(FileGetAttrib($CmdLine[$X]), "D") Then
			_PlayListAddRec($CmdLine[$X], $aFileExt)
		EndIf
	Next
Else
	For $X = 1 To $CmdLine[0]
		If StringInStr(FileGetAttrib($CmdLine[$X]), "D") Then
			_PlayListAdd($CmdLine[$X], $aFileExt)
		EndIf
	Next
EndIf
_FastArrayDel($aPlayList, 0)
If $aPlayList[0] = "" Then Exit MsgBox(32, "No playable items found", "Needs a folder with images in the command line")

#Include "..\..\Mina UDF's\SDL\SDL_image.au3"
#Include "..\..\Mina UDF's\SDL\SDL_gfx.au3"
#Include "..\..\Mina UDF's\SDL\SDL.au3"

OnAutoItExitRegister("_Quit")

Global $iNull = 0, $iFull = 16777215, $iCurrent = -1, $iSlideShowEnabled = False, $iRandomize = False

$GX = @DesktopWidth
$GY = @DesktopHeight
$iSlideShowTime = 5000

EnvSet("SDL_VIDEO_WINDOW_POS", $iNull & ", " & $iNull)

_SDL_Init_image()
_SDL_Startup_gfx()
_SDL_Init($_SDL_INIT_VIDEO)

For $X = $_SDL_NOEVENT To $_SDL_NUMEVENTS -1
	_SDL_EventState($X, $_SDL_IGNORE)
Next
_SDL_EventState($_SDL_MOUSEBUTTONUP, $_SDL_ENABLE)

Local $iFlags = BitOR($_SDL_SWSURFACE, $_SDL_NOFRAME)
$pSurface = _SDL_GuiCreate(@ScriptName, $GX, $GY, 24, $iFlags)
If IniRead(@ScriptDir & "/Settings.ini", "Beta", "MouseVisible", 0) <> 6 Then _SDL_ShowCursor($_SDL_DISABLE)

;Prepare time and battary
Local $pBattery = _SDL_CreateRGBSurface($_SDL_SWSURFACE, $GX, 1, 32, $iNull, $iNull, $iNull, $iNull)
$hDLL = DllOpen("kernel32.dll")
AdlibRegister("_PowerDrill", 5500)	;Should catch every minute without much waste
_PowerDrill()

Local $iCurrent = 0, $iTimer = 0
_MazyImage(StringTrimLeft($aPlayList[$iCurrent], StringInStr($aPlayList[$iCurrent], "\", 2, -1)))
#EndRegion

#Region ;Main-loop
While 1
	$tRet = _SDL_PollEventEasy()
	If $tRet = 0 Then
		Sleep(20)
	ElseIf $tRet[0] = $_SDL_MOUSEBUTTONUP Then
		If $tRet[4] < $GX*0.25 Then
			If $tRet[5] > $GY*0.75 Then
				If $tRet[2] = 3 Then
					_Next()
				ElseIf $tRet[2] = 1 Then
					_Previous()
				EndIf
			ElseIf $tRet[5] < $GY*0.25 Then
				Exit
			Else
				If $iSlideShowEnabled <> False Then
					$iSlideShowEnabled = False
				Else
					$iSlideShowEnabled = True
					$iTimer = TimerInit()
				EndIf
			EndIf
		Else
			If $tRet[5] > $GY*0.50 Then
				If $iSlideShowEnabled <> True Then
					_Next()
				Else
					$iSlideShowTime = Int($iSlideShowTime * 0.8)
				EndIf
			Else
				If $iSlideShowEnabled <> True Then
					_Previous()
				Else
					$iSlideShowTime = Int($iSlideShowTime * 1.2)
				EndIf
			EndIf
		EndIf
	EndIf

	If $iSlideShowEnabled <> False And TimerDiff($iTimer) > $iSlideShowTime Then
		_Next()
		$iTimer = TimerInit()
	EndIf
WEnd
#EndRegion

#Region ;Playlist
Func _PlayListAdd($sFileFolder, $aFileExts)
	For $Y = 0 To UBound($aFileExts) -1
		$hSearch = FileFindFirstFile($sFileFolder & "\*." & $aFileExts[$Y])
		While 1
			$sFile = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			If @extended = 1 Then ContinueLoop

			$UB = UBound($aPlayList)
			ReDim $aPlayList[$UB+1]
			$aPlayList[$UB] = $sFileFolder & "\" & $sFile
		WEnd
	Next
EndFunc

Func _PlayListAddRec($sFileFolder, $aFileExts)
	For $Y = 0 To UBound($aFileExts) -1
		$hSearch = FileFindFirstFile($sFileFolder & "\*." & $aFileExts[$Y])
		While 1
			$sFile = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			If @extended = 1 Then ContinueLoop

			$UB = UBound($aPlayList)
			ReDim $aPlayList[$UB+1]
			$aPlayList[$UB] = $sFileFolder & "\" & $sFile
		WEnd
	Next

	$hSearch = FileFindFirstFile($sFileFolder & "\*")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If @extended <> 1 Then ContinueLoop

		_PlayListAddRec($sFileFolder & "\" & $sFile, $aFileExts)
	WEnd
EndFunc

Func _SuperLoad()
	Return _IMG_Load($aPlayList[$iCurrent])
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
Func _MazyImage($sMessage)
	_SDL_FillRect($pSurface, 0, _SDL_MapRGB($pSurface, 0x00, 0x00, 0x00))
	$pImg = _SuperLoad()
	_BlitImage($pImg)
	_PowerBar()

	_SDL_stringRGBA($pSurface, 2, 2, @HOUR & ":" & @MIN & " | " & $sMessage, 255, 0, 0, 255)
	_SDL_Flip($pSurface)

	_SDL_FreeSurface($pImg)
EndFunc

Func _BlitImage($pSrc)		;Could be optimized
	$hStruct = DllStructCreate($tagSDL_SURFACE, $pSrc)
	$W = DllStructGetData($hStruct, "w")
	$Y = DllStructGetData($hStruct, "h")

	Local $DW, $DH, $DZ = 1
	If $W >= $Y Then	;Bilden är större på bredden så vi behöver bara zooma
		$ZoomX = $GX / $W
		$ZoomY = $GY / $Y
		If $ZoomX < $ZoomY Then
			$DZ = $ZoomX
		Else
			$DZ = $ZoomY
		EndIf
		$pDst = _SDL_zoomSurface($pSrc, $DZ, $DZ, 1)
	Else	;Bilden är större på höjden så vi måste rotera och sen zooma
		$ZoomX = $GX / $Y
		$ZoomY = $GY / $W
		If $ZoomX < $ZoomY Then
			$DZ = $ZoomX
		Else
			$DZ = $ZoomY
		EndIf
		$pDst = _SDL_rotozoomSurface($pSrc, 270, $DZ, 1)
	EndIf
	$hStruct = $iNull

	$hStruct2 = DllStructCreate($tagSDL_SURFACE, $pDst)
	$DW = DllStructGetData($hStruct2, "w")
	$DH = DllStructGetData($hStruct2, "h")
	$DX = ($GX-$DW)/2
	$DY = ($GY-$DH)/2

	_SDL_BlitSurface($pDst, 0, $pSurface, _SDL_Rect_Create($DX, $DY, $iNull, $iNull))
	_SDL_FreeSurface($pDst)
EndFunc

Func _PowerBar()
	_SDL_BlitSurface($pBattery, 0, $pSurface, _SDL_Rect_Create($iNull, $GY, $iNull, $iNull))
EndFunc
#EndRegion

#Region ;Internal
Func _FastArrayDel(ByRef $Array, $Element)
	$UBTemp = UBound($Array)-1
	If $UBTemp = 0 Then Return
	$Array[$Element] = $Array[$UBTemp]
	ReDim $Array[$UBTemp]
EndFunc

Func _PowerDrill()	;Should this func to time too?
	$aTemp = _GetSystemPowerStatus()
	If IsArray($aTemp) <> 0 Then
		If $aTemp[1] = 255 Or BitAND($aTemp[0], 128) Or BitAND($aTemp[0], 255) Then Return		;No battery or unknown
		Select
			Case $aTemp[0] = 8											;Currently charging
				$iColor = 0x800080FF
			Case $aTemp[1] > 65											;Over 66%
				$iColor = 0x00FF00FF
			Case $aTemp[1] < 34											;Under 33%
				$iColor = 0xFF0000FF
			Case Else													;Between 33-66%
				$iColor = 0xFFFF00FF
		EndSelect

		_SDL_hlineColor($pBattery, 0, $GX*0.01*$aTemp[1], 0, $iColor)
	EndIf
EndFunc

Func _GetSystemPowerStatus()
	Local $tagStruct = DllStructCreate('ubyte ACLineStatus;ubyte BatteryFlag;ubyte BatteryLifePercent;ubyte Reserved1;ulong BatteryLifeTime;ulong BatteryFullLifeTime')
	Local $aTemp1, $aTemp2[2]

	$aTemp1 = DllCall($hDLL, 'int', 'GetSystemPowerStatus', 'ptr', DllStructGetPtr($tagStruct))
	If (@error) Or ($aTemp1[0] = 0) Then Return 0
	$aTemp2[0] = DllStructGetData($tagStruct, 2) ;BatteryFlag
	$aTemp2[1] = DllStructGetData($tagStruct, 3) ;BatteryLifePercent
	Return $aTemp2
EndFunc

Func _Quit()
	If $__SDL_DLL <> -1 Then _SDL_Quit()
EndFunc
#EndRegion
