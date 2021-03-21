#include-once
#Include <APIConstants.au3>
#Include <GDIPlus.au3>
#Include <WinAPIEx.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <StringSize.au3>

#include <Array.au3>


Global Const $PRF_CLIENT = 0x04
Global Const $STM_SETIMAGE = 0x0172

Func DwmBox($DwmBoxFlag,$DwmBoxTitle,$DwmBoxText,$Mode=0)
  If Not _WinAPI_DwmIsCompositionEnabled() Then
    Local $DwmBoxNoDwm = 1
  Else
    Local $DwmBoxNoDwm = 0
  EndIf
  Local $DwmBoxHandle
  If $Mode = 0 Then
      Local $DwmBoxIconResourceDll, $DwmBoxIconResource
      Local $DwmBoxIconHandle, $DwmBoxIconPointer, $DwmBoxIcon
      Local $DwmBoxIconId, $DwmBoxResourceHandle, $DwmBoxResourceSize
      Local $DwmBoxResourceDataHandle, $DwmBoxResourceDataPointer
      Local $DwmBoxInput = Random(0,65535,1)
      $DwmBoxIconResourceDll = _WinAPI_LoadLibraryEx(@WindowsDir & '\System32\ImageRes.dll', $LOAD_LIBRARY_AS_DATAFILE)
      Switch $DwmBoxFlag
        Case 16 ; Error
          $DwmBoxIconResource = _WinAPI_FindResource($DwmBoxIconResourceDll, $RT_GROUP_ICON, 98)
        Case 32 ; Question
          $DwmBoxIconResource = _WinAPI_FindResource($DwmBoxIconResourceDll, $RT_GROUP_ICON, 99)
        Case 48 ; Warning
          $DwmBoxIconResource = _WinAPI_FindResource($DwmBoxIconResourceDll, $RT_GROUP_ICON, 84)
        Case 64 ; Info
          $DwmBoxIconResource = _WinAPI_FindResource($DwmBoxIconResourceDll, $RT_GROUP_ICON, 81)
      EndSwitch
      $DwmBoxIconHandle = _WinAPI_LoadResource($DwmBoxIconResourceDll, $DwmBoxIconResource)
      $DwmBoxIconPointer = _WinAPI_LockResource($DwmBoxIconHandle)
      $DwmBoxIconId = _WinAPI_LookupIconIdFromDirectoryEx($DwmBoxIconPointer, 1, 48, 48)
      $DwmBoxResourceDataHandle = _WinAPI_FindResource($DwmBoxIconResourceDll, $RT_ICON, $DwmBoxIconId)
      $DwmBoxResourceSize = _WinAPI_SizeOfResource($DwmBoxIconResourceDll, $DwmBoxResourceDataHandle)
      $DwmBoxResourceDataHandle = _WinAPI_LoadResource($DwmBoxIconResourceDll, $DwmBoxResourceDataHandle)
      $DwmBoxResourceDataPointer = _WinAPI_LockResource($DwmBoxResourceDataHandle)
      $DwmBoxIcon = _WinAPI_CreateIconFromResourceEx($DwmBoxResourceDataPointer, $DwmBoxResourceSize)
      _WinAPI_FreeLibrary($DwmBoxIconResourceDll)
  EndIf
  Local $DwmBoxHeight = @DesktopHeight/8-16
  Local $DwmBoxTextArray = StringSplit($DwmBoxText,@CR&@LF&@CRLF)
  If IsArray($DwmBoxTextArray) Then
      Local $DwmBoxTitleSize = _StringSize($DwmBoxTitle)
      Local $DwmBoxTextSize = _StringSize($DwmBoxTextArray[_ArrayMaxLenIndex($DwmBoxTextArray)],9,Default,Default,"Consolas")
      If Not IsArray($DwmBoxTextSize) Or Not IsArray($DwmBoxTitleSize) Then
        $DwmBoxWidth = (@DesktopWidth/16)+$DwmBoxTitleSize[2]
        $DwmBoxHeight += 25
      Else
        If $DwmBoxTitleSize[2] > $DwmBoxTextSize[2] Then
          Local $DwmBoxWidth = (@DesktopWidth/16)+$DwmBoxTitleSize[2]
        ElseIf $DwmBoxTitleSize[2] < $DwmBoxTextSize[2] Then
          Local $DwmBoxWidth = (@DesktopWidth/16)+$DwmBoxTextSize[2]
        ElseIf $DwmBoxTitleSize[2] = $DwmBoxTextSize[2] Then
          Local $DwmBoxWidth = (@DesktopWidth/16)+$DwmBoxTextSize[2]
        EndIf
        If $DwmBoxTextArray[0] > 1 Then
          $DwmBoxHeight += $DwmBoxTextSize[2]/6
        Else
          $DwmBoxHeight += 25
        EndIf
      EndIf
  EndIf
  $DwmBoxHandle = GUICreate($DwmBoxTitle, $DwmBoxWidth, $DwmBoxHeight, -1,-1,BitOR($WS_OVERLAPPED,$WS_POPUPWINDOW,$WS_CAPTION,$WS_SYSMENU))
  GUISetFont(9,Default,Default,"Consolas")
  If $Mode = 0 Then
    GUICtrlCreateIcon('', 0, $DwmBoxWidth/(16+16), $DwmBoxHeight/4, 48, 48)
    GUICtrlSendMsg(-1, $STM_SETIMAGE, 1, $DwmBoxIcon)
    GUICtrlCreateLabel($DwmBoxText,($DwmBoxWidth/16)+32+16,$DwmBoxHeight/4,$DwmBoxWidth-8)
    GUICtrlSetColor(-1,0x888888)
  ElseIf $Mode = 1 Then
    GUICtrlCreateEdit($DwmBoxText,4,4,$DwmBoxWidth-8,$DwmBoxHeight-32+8+4-1,$ES_READONLY,0)
    GUICtrlSetColor(-1,0x888888)
    If $DwmBoxNoDwm = 1 Then
      GUICtrlSetBkColor(-1,0x888888)
    Else
      GUICtrlSetBkColor(-1,0x000000)
    EndIf
  ElseIf $Mode = 2 Then
    Local $DwmBoxInput = GUICtrlCreateEdit($DwmBoxText,4,4,$DwmBoxWidth-8,$DwmBoxHeight-32,0,0)
    GUICtrlSetColor(-1,0x888888)
    If $DwmBoxNoDwm = 1 Then
      GUICtrlSetBkColor(-1,0x222222)
    Else
      GUICtrlSetBkColor(-1,0x000000)
    EndIf
  EndIf
    Local $DwmBoxButton = GUICtrlCreateButton("OK",($DwmBoxWidth/2)-40,($DwmBoxHeight)-25,80,25,0x0001)
    GUICtrlSetFont(-1,Default,Default,Default,Default)
  If Not $DwmBoxNoDwm Then
    GUISetBkColor(0)
  Else
    GUISetBkColor(0x222222)
  EndIf
  If Not $DwmBoxNoDwm Then
      Local $tMARGINS = _WinAPI_CreateMargins(($DwmBoxWidth/2)-40+16,($DwmBoxWidth/2)-40+16,($DwmBoxHeight)-25+5,5)
      _WinAPI_DwmExtendFrameIntoClientArea($DwmBoxHandle,$tMARGINS)
  EndIf
  GUISetState()
  While 1
    Switch GUIGetMsg()
      Case $GUI_EVENT_CLOSE
        GUIDelete($DwmBoxHandle)
        Return 1
      Case $DwmBoxButton
        If $Mode = 2 Then
          Local $DwmBoxInputData = GUICtrlRead($DwmBoxInput)
          If ($DwmBoxInputData <> "") And ($DwmBoxInputData <> $DwmBoxText) Then
            GUIDelete($DwmBoxHandle)
            Return $DwmBoxInputData
          EndIf
        Else
          GUIDelete($DwmBoxHandle)
          Return 0
        EndIf
    EndSwitch
  WEnd
EndFunc

Func _ArrayMaxLenIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, -1)

	Local $iMaxIndex = $iStart

	; Search
		For $i = $iStart To $iEnd
			If StringLen($avArray[$iMaxIndex]) < StringLen($avArray[$i]) Then $iMaxIndex = $i
		Next
  Return $iMaxIndex
EndFunc   ;==>_ArrayMaxLenIndex

Func _GDIPlus_CircularGradient2Image($hGraphic, $hBitmap, $iX, $iY, $iW, $iH, $iCenterColor = 0x00FFFFFF, $iBorderColor = 0xFF000000, $fCenterX = 0.5, $fCenterY = 0.5, $fFocus = 1, $fScale = 1)
    Local $hCtx = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0)
    Local $hPath = $aResult[2]
    DllCall($ghGDIPDll, "uint", "GdipAddPathEllipse", "handle", $hPath, "float", $iX, "float", $iY, "float", $iW * 2, "float", $iH * 2)
    $aResult = DllCall($ghGDIPDll, "uint", "GdipCreatePathGradientFromPath", "handle", $hPath, "int*", 0)
    Local $hBrush = $aResult[2]
    Local $tPoint = DllStructCreate("float;float")
    DllStructSetData($tPoint, 1, $iW * $fCenterX)
    DllStructSetData($tPoint, 2, $iH * $fCenterY)
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterPoint", "handle", $hBrush, "ptr", DllStructGetPtr($tPoint))
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterColor", "handle", $hBrush, "uint", $iCenterColor)
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSigmaBlend", "handle", $hBrush, "float", $fFocus, "float", $fScale)
    Local $tColors = DllStructCreate("uint")
    DllStructSetData($tColors, 1, $iBorderColor)
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSurroundColorsWithCount", "handle", $hBrush, "ptr", DllStructGetPtr($tColors), "int*", 1)
    _GDIPlus_GraphicsFillEllipse($hCtx, $iX, $iY, $iW * 2, $iH * 2, $hBrush)
    _GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 0, 0)
    DllCall($ghGDIPDll, "uint", "GdipDeletePath", "handle", $hPath)
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_GraphicsDispose($hCtx)
    Return 1
EndFunc

Func Encry($Input,$Mode=0)
	Local $_0001 = $Input, $_0002, $_0003, $_0004, $_0005, $_0006, $_0007=0, $_0008, $_0009, $_000A, $_000B, $_000C
	Local $_0000[98][2]
		$_0000[0][0] = 97
		$_0000[1][0] = 1
		$_0000[2][0] = 2
		$_0000[3][0] = 3
		$_0000[4][0] = 4
		$_0000[5][0] = 5
		$_0000[6][0] = 6
		$_0000[7][0] = 7
		$_0000[8][0] = 8
		$_0000[9][0] = 9
		$_0000[10][0] = 11
		$_0000[11][0] = 12
		$_0000[12][0] = 13
		$_0000[13][0] = 14
		$_0000[14][0] = 15
		$_0000[15][0] = 16
		$_0000[16][0] = 17
		$_0000[17][0] = 18
		$_0000[18][0] = 19
		$_0000[19][0] = 21
		$_0000[20][0] = 22
		$_0000[21][0] = 23
		$_0000[22][0] = 24
		$_0000[23][0] = 25
		$_0000[24][0] = 26
		$_0000[25][0] = 27
		$_0000[26][0] = 28
		$_0000[27][0] = 29
		$_0000[28][0] = 31
		$_0000[29][0] = 32
		$_0000[30][0] = 33
		$_0000[31][0] = 34
		$_0000[32][0] = 35
		$_0000[33][0] = 36
		$_0000[34][0] = 37
		$_0000[35][0] = 38
		$_0000[36][0] = 39
		$_0000[37][0] = 41
		$_0000[38][0] = 42
		$_0000[39][0] = 43
		$_0000[40][0] = 44
		$_0000[41][0] = 45
		$_0000[42][0] = 46
		$_0000[43][0] = 47
		$_0000[44][0] = 48
		$_0000[45][0] = 49
		$_0000[46][0] = 51
		$_0000[47][0] = 52
		$_0000[48][0] = 53
		$_0000[49][0] = 54
		$_0000[50][0] = 55
		$_0000[51][0] = 56
		$_0000[52][0] = 57
		$_0000[53][0] = 58
		$_0000[54][0] = 59
		$_0000[55][0] = 61
		$_0000[56][0] = 62
		$_0000[57][0] = 63
		$_0000[58][0] = 64
		$_0000[59][0] = 65
		$_0000[60][0] = 66
		$_0000[61][0] = 67
		$_0000[62][0] = 68
		$_0000[63][0] = 69
		$_0000[64][0] = 71
		$_0000[65][0] = 72
		$_0000[66][0] = 73
		$_0000[67][0] = 74
		$_0000[68][0] = 75
		$_0000[69][0] = 76
		$_0000[70][0] = 77
		$_0000[71][0] = 78
		$_0000[72][0] = 79
		$_0000[73][0] = 81
		$_0000[74][0] = 82
		$_0000[75][0] = 83
		$_0000[76][0] = 84
		$_0000[77][0] = 85
		$_0000[78][0] = 86
		$_0000[79][0] = 87
		$_0000[80][0] = 88
		$_0000[81][0] = 89
		$_0000[82][0] = 91
		$_0000[83][0] = 92
		$_0000[84][0] = 93
		$_0000[85][0] = 94
		$_0000[86][0] = 95
		$_0000[87][0] = 96
		$_0000[88][0] = 97
		$_0000[89][0] = 98
		$_0000[90][0] = 99
		$_0000[91][0] = 111
		$_0000[92][0] = 112
		$_0000[93][0] = 113
		$_0000[94][0] = 114
		$_0000[95][0] = 115
		$_0000[96][0] = 116
		$_0000[97][0] = 117
		$_0000[1][1] = "0"
		$_0000[2][1] = "1"
		$_0000[3][1] = "2"
		$_0000[4][1] = "3"
		$_0000[5][1] = "4"
		$_0000[6][1] = "5"
		$_0000[7][1] = "6"
		$_0000[8][1] = "7"
		$_0000[9][1] = "8"
		$_0000[10][1] = "9"
		$_0000[11][1] = "a"
		$_0000[12][1] = "b"
		$_0000[13][1] = "c"
		$_0000[14][1] = "d"
		$_0000[15][1] = "e"
		$_0000[16][1] = "f"
		$_0000[17][1] = "g"
		$_0000[18][1] = "h"
		$_0000[19][1] = "i"
		$_0000[20][1] = "j"
		$_0000[21][1] = "k"
		$_0000[22][1] = "l"
		$_0000[23][1] = "m"
		$_0000[24][1] = "n"
		$_0000[25][1] = "o"
		$_0000[26][1] = "p"
		$_0000[27][1] = "q"
		$_0000[28][1] = "r"
		$_0000[29][1] = "s"
		$_0000[30][1] = "t"
		$_0000[31][1] = "u"
		$_0000[32][1] = "v"
		$_0000[33][1] = "w"
		$_0000[34][1] = "x"
		$_0000[35][1] = "y"
		$_0000[36][1] = "z"
		$_0000[37][1] = "A"
		$_0000[38][1] = "B"
		$_0000[39][1] = "C"
		$_0000[40][1] = "D"
		$_0000[41][1] = "E"
		$_0000[42][1] = "F"
		$_0000[43][1] = "G"
		$_0000[44][1] = "H"
		$_0000[45][1] = "I"
		$_0000[46][1] = "J"
		$_0000[47][1] = "K"
		$_0000[48][1] = "L"
		$_0000[49][1] = "M"
		$_0000[50][1] = "N"
		$_0000[51][1] = "O"
		$_0000[52][1] = "P"
		$_0000[53][1] = "Q"
		$_0000[54][1] = "R"
		$_0000[55][1] = "S"
		$_0000[56][1] = "T"
		$_0000[57][1] = "U"
		$_0000[58][1] = "V"
		$_0000[59][1] = "W"
		$_0000[60][1] = "X"
		$_0000[61][1] = "Y"
		$_0000[62][1] = "Z"
		$_0000[63][1] = "`"
		$_0000[64][1] = "~"
		$_0000[65][1] = "!"
		$_0000[66][1] = "@"
		$_0000[67][1] = "#"
		$_0000[68][1] = "$"
		$_0000[69][1] = "%"
		$_0000[70][1] = "^"
		$_0000[71][1] = "&"
		$_0000[72][1] = "*"
		$_0000[73][1] = "("
		$_0000[74][1] = ")"
		$_0000[75][1] = "-"
		$_0000[76][1] = "_"
		$_0000[77][1] = "="
		$_0000[78][1] = "+"
		$_0000[79][1] = "["
		$_0000[80][1] = "{"
		$_0000[81][1] = "]"
		$_0000[82][1] = "}"
		$_0000[83][1] = "\"
		$_0000[84][1] = "|"
		$_0000[85][1] = ";"
		$_0000[86][1] = ":"
		$_0000[87][1] = "'"
		$_0000[88][1] = '"'
		$_0000[89][1] = ","
		$_0000[90][1] = "<"
		$_0000[91][1] = "."
		$_0000[92][1] = ">"
		$_0000[93][1] = "/"
		$_0000[94][1] = "?"
		$_0000[95][1] = " "
		$_0000[96][1] = @LF
		$_0000[97][1] = @TAB
 	Switch $Mode
		Case 0
			For $_0002 = 1 To StringLen($_0001)
				For $_000A = 1 to $_0000[0][0]
					If StringMid($_0001,$_0002,1) == $_0000[$_000A][1] Then $_0003 = $_0000[$_000A][0]
				Next
					For $_0004 = 1 To StringLen($_0003)
						Do
							$_0005 = Random(0, 65535, 1)
							$_0006 = $_0005
							$_0007=0
							Do
								If StringLen($_0007) > 1 Then
									$_0006 = $_0007
									$_0007 = 0
								EndIf
								For $_0008 = 0 To StringLen($_0006)
									$_0007 += StringLeft($_0006, 1)
									$_0006 = StringTrimLeft($_0006, 1)
								Next
							Until StringLen($_0007) <= 1
						Until $_0007 = StringMid($_0003, $_0004, 1)
            $_0009 &= Hex($_0005, 4)
					Next
          $_0009 = $_0009 & "NNNN"
					$_0007 = ""
			Next
			Return $_0009
    Case 1
      $_0009 = ""
			If StringInStr($_0001,"NNNN") Then
				$_0001 = StringSplit($_0001,"NNNN",1)
        If IsArray($_0001) Then
          For $_0002 = 1 to $_0001[0]
            $_0007 = ""
            $_000B = ""
            Do
              $_0003 = Dec(StringLeft($_0001[$_0002],4))
              $_0001[$_0002] = StringTrimLeft($_0001[$_0002],4)
              $_0004 = $_0003
              $_0005 = 0
              Do
                  If StringLen($_0005) > 1 Then
                    $_0004 = $_0005
                    $_0005 = 0
                  EndIf
                  For $_0006 = 0 To StringLen($_0004)
                    $_0005 += StringLeft($_0004, 1)
                    $_0004 = StringTrimLeft($_0004, 1)
                  Next
                Until StringLen($_0005) <= 1
              If $_0005 = 0 Then $_0005 = ""
            $_0007 &= $_0005
            Until StringLen($_0001[$_0002]) = 0
            For $_000A = 1 to $_0000[0][0]
              If $_0007 == $_0000[$_000A][0] Then
                $_000B &= $_0000[$_000A][1]
              EndIf
            Next
            $_0009 &= $_000B
          Next
            Return $_0009
        EndIf
			EndIf
		EndSwitch
EndFunc
