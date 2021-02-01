#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Global Const $WS_EX_COMPOSITED = 0x02000000 ;makes pictures show transition smoother
Global Const $IniPath = @ScriptDir & "\DeskBox.ini"
Global Const $GUISize = 60
Global Const $GUIX = 100
Global Const $GUIY = 100
Global Const $IconSize = 32
Global Const $VerticalSpacing = 10
Global $WindowState = "Minimized"

#cs Files Array
	$Icons[0][0] = unused
	$Icons[$i][0] = Icon Handle
	$Icons[$i][1] = Label Handle
	$Files[0][0] = number of files
	$Files[$i][0] = "File Title"
	$Files[$i][1] = "File Path"
#ce
Dim $Icons[1][2]
Dim $Files = PopulateFilesArray()

#Region Create GUI
$GUI = GUICreate("", $GUISize, $GUISize, $GUIX, $GUIY, $WS_POPUP, $WS_EX_COMPOSITED)
GUISetBkColor(0x404040)

GUICtrlCreateLabel("DeskBox", 0, $GUISize - 14, $GUISize, 14, $SS_CENTER, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKHEIGHT))
GUICtrlSetBkColor(-1, 0x202020)
GUICtrlSetColor(-1, 0xCCCCCC)

GUICtrlCreateLabel("", 0, 0, $GUISize - 15, 14, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKHEIGHT))
GUICtrlSetBkColor(-1, 0xBBFF00)

$CloseButton = GUICtrlCreateLabel("X", $GUISize - 15, 0, 15, 14, $SS_CENTER)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKSIZE))
GUICtrlSetBkColor(-1, 0xBBFF00)

GUISetState(@SW_SHOW, $GUI)
#EndRegion Create GUI


While 1
	$Msg = GUIGetMsg()

	Switch $Msg
		Case $CloseButton
			Exit
		Case Else
			CheckWindowSize()

			If $WindowState = "Maximized" Then
				;loop through icons
				For $i = 1 To $Files[0][0]
					If $Msg = $Icons[$i][0] Or $Msg = $Icons[$i][1] Then
						ConsoleWrite("You pressed icon " & $i & " which runs " & $Files[$i][1] & @CRLF)
						ShellExecute($Files[$i][1])
					EndIf
				Next
			EndIf
	EndSwitch
WEnd

Func CheckWindowSize()
	Local $MousePosition = MouseGetPos()
	Local $WindowPosition = WinGetPos($GUI)

	If $WindowState = "Maximized" And Not _WinAPI_PointInRect($MousePosition[0], $MousePosition[1], $WindowPosition[0], $WindowPosition[1], $WindowPosition[2], $WindowPosition[3]) Then
		;if window is maximized and mouse is not over the gui then minimize the window

		MinimizeWindow()

	ElseIf $WindowState = "Minimized" And _WinAPI_PointInRect($MousePosition[0], $MousePosition[1], $WindowPosition[0], $WindowPosition[1] + 14, $WindowPosition[2], $WindowPosition[3] - 28) Then
		;if window is minimized and mouse is over the gui then maximize the window

		MaximizeWindow()
		DrawIcons()

	EndIf
EndFunc   ;==>CheckWindowSize

Func DrawIcons()
	Local $IconsAcross = Ceiling(Sqrt($Files[0][0])) ;make icons into a square arrangement
	Local $MaximizedWidth = 14 + $VerticalSpacing + ($IconsAcross * $IconSize) + ((15 + $VerticalSpacing) * $IconsAcross) + 14
	If $MaximizedWidth < $GUISize Then $MaximizedWidth = $GUISize
	Local $HorizontalSpacing = ($MaximizedWidth - 28 - ($IconsAcross * $IconSize)) / ($IconsAcross + 1)
	Local $index = 1

	For $y = 1 To $IconsAcross
		For $x = 1 To $IconsAcross
			If StringRight($Files[$index][1], 4) = ".exe" Or StringRight($Files[$index][1], 4) = ".ani" Then
				$Icons[$index][0] = GUICtrlCreateIcon($Files[$index][1], -1, 14 + $HorizontalSpacing + ($IconSize * ($x - 1)) + ($HorizontalSpacing * ($x - 1)), 14 + $VerticalSpacing + ($IconSize * ($y - 1)) + ((15 + $VerticalSpacing) * ($y - 1)), $IconSize, $IconSize)
			ElseIf StringInStr(FileGetAttrib($Files[$index][1]), "D") Then
				$Icons[$index][0] = GUICtrlCreateIcon("shell32.dll", -5, 14 + $HorizontalSpacing + ($IconSize * ($x - 1)) + ($HorizontalSpacing * ($x - 1)), 14 + $VerticalSpacing + ($IconSize * ($y - 1)) + ((15 + $VerticalSpacing) * ($y - 1)), $IconSize, $IconSize)
			Else
				Local $DefaultIcon = _GetRegDefIcon($Files[$index][1])
				$Icons[$index][0] = GUICtrlCreateIcon($DefaultIcon[0], $DefaultIcon[1], 14 + $HorizontalSpacing + ($IconSize * ($x - 1)) + ($HorizontalSpacing * ($x - 1)), 14 + $VerticalSpacing + ($IconSize * ($y - 1)) + ((15 + $VerticalSpacing) * ($y - 1)), $IconSize, $IconSize)
			EndIf

			GUICtrlSetTip(-1, $Files[$index][1])
			$Icons[$index][1] = GUICtrlCreateLabel($Files[$index][0], 14 + ($HorizontalSpacing * (2 / 3)) + ($IconSize * ($x - 1)) + ($HorizontalSpacing * ($x - 1)), 14 + $VerticalSpacing + ($IconSize * ($y - 1)) + ((15 + $VerticalSpacing) * ($y - 1)) + $IconSize, $IconSize + ($HorizontalSpacing * (2 / 3)), 15, $SS_LEFTNOWORDWRAP)
			GUICtrlSetTip(-1, $Files[$index][0])
			GUICtrlSetFont(-1, 8)
			GUICtrlSetColor(-1, 0xEEEEEE)

			$index += 1
			If $index > $Files[0][0] Then ExitLoop
		Next
		If $index > $Files[0][0] Then ExitLoop
	Next
EndFunc   ;==>DrawIcons

Func MaximizeWindow()
	Local $IconsAcross = Ceiling(Sqrt($Files[0][0])) ;make icons into a square arrangement
	If $IconsAcross > 0 Then
		Local $IconsDown = $IconsAcross
		If $IconsAcross * $IconsAcross - $IconsAcross >= $Files[0][0] Then $IconsDown -= 1
		Local $MaximizedWidth = 14 + $VerticalSpacing + ($IconsAcross * $IconSize) + ((15 + $VerticalSpacing) * $IconsAcross) + 14
		If $MaximizedWidth < $GUISize Then $MaximizedWidth = $GUISize
		Local $MaximizedHeight = 14 + $VerticalSpacing + ($IconsDown * $IconSize) + ((15 + $VerticalSpacing) * $IconsDown) + 14
		If $MaximizedHeight < $GUISize Then $MaximizedHeight = $GUISize
		Local $SizingIncrement = 0.0075

		$i = $SizingIncrement
		While $i <= 1
			WinMove($GUI, "", Default, Default, $GUISize + ($i * ($MaximizedWidth - $GUISize)), $GUISize + ($i * ($MaximizedHeight - $GUISize)))
			$i += $SizingIncrement
		WEnd
		WinMove($GUI, "", Default, Default, $MaximizedWidth, $MaximizedHeight)
	EndIf

	$WindowState = "Maximized"
EndFunc   ;==>MaximizeWindow

Func MinimizeWindow()
	;delete icons and labels
	For $i = 1 To UBound($Icons) - 1
		GUICtrlDelete($Icons[$i][0])
		GUICtrlDelete($Icons[$i][1])
	Next

	WinMove($GUI, "", Default, Default, $GUISize, $GUISize)
	$WindowState = "Minimized"
EndFunc   ;==>MinimizeWindow

Func PopulateFilesArray()
	Local $Sections = IniReadSectionNames($IniPath)
	Local $aRet[2][2] = [[0, 0]] ;minimum number of elements

	If IsArray($Sections) And ($Sections[1] <> "Settings" Or UBound($Sections) > 2) Then
		;if ini exists and there is at least one file in the ini

		ReDim $aRet[$Sections[0] + 1][2] ;make sure there are enough elements

		For $i = 1 To $Sections[0]

			Local $FilePath = IniRead($IniPath, $Sections[$i], "FileName", "")

			If StringRight($FilePath, 4) = ".lnk" Then $FilePath = FileGetShortcutPath($FilePath) ;get target of shortcuts

			If FileExists($FilePath) Then

				$aRet[0][0] += 1 ;set the total number of files in the array
				$aRet[$aRet[0][0]][0] = FileTitleFromPath($FilePath)
				$aRet[$aRet[0][0]][1] = $FilePath

			Else

				IniDelete($IniPath, $Sections[$i]) ;delete from ini if file path isn't valid

			EndIf

		Next

		ReDim $aRet[$aRet[0][0] + 1][2] ;resize the files array in case some files didn't exist
		ReDim $Icons[UBound($aRet)][2] ;resize the icons array to hold the correct number of files

	Else ;either there isn't an ini file or the ini file only contains a settings section

		#Region Add a default element (optional)
		IniWrite($IniPath, "My Documents", "FileName", @MyDocumentsDir)

		$aRet[0][0] += 1 ;set the total number of files in the array
		$aRet[$aRet[0][0]][0] = "My Documents"
		$aRet[$aRet[0][0]][1] = @MyDocumentsDir
		#EndRegion Add a default element (optional)

	EndIf

	Return $aRet
EndFunc   ;==>PopulateFilesArray

#Region Auxiliary Functions
Func FileTitleFromPath($sFilePath)
	;will include handling for special folders such as My Computer later

	Local $SplitPath = StringSplit($sFilePath, "\")

	Return $SplitPath[UBound($SplitPath) - 1]
EndFunc   ;==>FileTitleFromPath

Func FileGetShortcutPath($sShortcut)
	Local $Shortcut = FileGetShortcut($sShortcut)

	Return $Shortcut[0]
EndFunc   ;==>FileGetShortcutPath

Func _WinAPI_PointInRect($iX, $iY, $iLeft, $iTop, $iWidth, $iHeight)
	Local $aResult
	Local $tRect = DllStructCreate("int Left;int Top;int Right;int Bottom")

	DllStructSetData($tRect, "Left", $iLeft)
	DllStructSetData($tRect, "Top", $iTop)
	DllStructSetData($tRect, "Right", $iLeft + $iWidth)
	DllStructSetData($tRect, "Bottom", $iTop + $iHeight)

	$aResult = DllCall("User32.dll", "int", "PtInRect", "ptr", DllStructGetPtr($tRect), "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, 0, False)

	Return $aResult[0] <> 0
EndFunc   ;==>_WinAPI_PointInRect

Func _GetRegDefIcon($path)
	Local $DF_NAME = @SystemDir & "\shell32.dll", $DF_INDEX = 0
	Local $FileName, $Count, $Name, $Ext, $Curver, $DefaultIcon, $Ret[2] = [$DF_NAME, $DF_INDEX]

	$FileName = StringTrimLeft($path, StringInStr($path, '\', 0, -1))
	$Count = StringInStr($FileName, '.', 0, -1)
	If $Count > 0 Then
		$Count = StringLen($FileName) - $Count + 1
	EndIf
	$Name = StringStripWS(StringTrimRight($FileName, $Count), 3)
	$Ext = StringStripWS(StringRight($FileName, $Count - 1), 8)
	If StringLen($Ext) = 0 Then
		Return $Ret
	EndIf
	$Curver = StringStripWS(RegRead('HKCR\' & RegRead('HKCR\' & '.' & $Ext, '') & '\CurVer', ''), 3)
	If (@error) Or (StringLen($Curver) = 0) Then
		$DefaultIcon = _WinAPI_ExpandEnvironmentStrings(StringReplace(RegRead('HKCR\' & RegRead('HKCR\' & '.' & $Ext, '') & '\DefaultIcon', ''), '''', ''))
	Else
		$DefaultIcon = _WinAPI_ExpandEnvironmentStrings(StringReplace(RegRead('HKCR\' & $Curver & '\DefaultIcon', ''), '''', ''))
	EndIf
	$Count = StringInStr($DefaultIcon, ',', 0, -1)
	If $Count > 0 Then
		$Count = StringLen($DefaultIcon) - $Count
		$Ret[0] = StringStripWS(StringTrimRight($DefaultIcon, $Count + 1), 3)
		If $Count > 0 Then
			$Ret[1] = StringStripWS(StringRight($DefaultIcon, $Count), 8)
		EndIf
	Else
		$Ret[0] = StringStripWS(StringTrimRight($DefaultIcon, $Count), 3)
	EndIf
	If StringLeft($Ret[0], 1) = '%' Then
		$Count = DllCall('shell32.dll', 'int', 'ExtractIcon', 'int', 0, 'str', $path, 'int', -1)
		If $Count[0] = 0 Then
			$Ret[0] = $DF_NAME
			If StringLower($Ext) = 'exe' Then
				$Ret[1] = 2
			Else
				$Ret[1] = 0
			EndIf
		Else
			$Ret[0] = StringStripWS($path, 3)
			$Ret[1] = 0
		EndIf
	Else
		If (StringLen($Ret[0]) > 0) And (StringInStr($Ret[0], '\', 0) = 0) Then
			$Ret[0] = @SystemDir & '\' & $Ret[0]
		EndIf
	EndIf
	If Not FileExists($Ret[0]) Then
		$Ret[0] = $DF_NAME
		$Ret[1] = $DF_INDEX
	EndIf
	Return $Ret
EndFunc   ;==>_GetRegDefIcon
#EndRegion Auxiliary Functions