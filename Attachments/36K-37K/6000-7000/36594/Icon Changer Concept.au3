
Global $ARRAY_MODULE_STRUCTURE[1][1][1], _
		$global_types_count, _
		$iPopulateArray, _
		$global_langs_count, _
		$lang_count, _
		$global_names_count, _
		$name_count
Global $LangCodeCurrent, _
		$langNameCurrent[2], _
		$TypeCurrent, _
		$TypeNameCurrent[2]
Global Const $RT_CURSOR = 1, $RT_BITMAP = 2, $RT_ICON = 3, $RT_MENU = 4, $RT_DIALOG = 5, $RT_STRING = 6, $RT_FONTDIR = 7, _
		$RT_FONT = 8, $RT_ACCELERATOR = 9, $RT_RCDATA = 10, $RT_MESSAGETABLE = 11, $RT_GROUP_CURSOR = 12, $RT_GROUP_ICON = 14, _
		$RT_VERSION = 16, $RT_DLGINCLUDE = 17, $RT_PLUGPLAY = 19, $RT_VXD = 20, $RT_ANICURSOR = 21, $RT_ANIICON = 22, _
		$RT_HTML = 23, $RT_MANIFEST = 24; resource vars...

Global $Script = False

#region ### START Koda GUI section ### Form=
$Form2 = GUICreate("Icons", 441, 377, 305, 306)
$Input = GUICtrlCreateInput("", 56, 8, 249, 21)
$Button1 = GUICtrlCreateButton("Choose file", 312, 8, 73, 25)
$ListView1 = GUICtrlCreateListView("IconName", 8, 48, 425, 281)
GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -56, 8, 8, 32, 32)
$Button2 = GUICtrlCreateButton("Replace", 360, 336, 73, 25)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case -3
			Exit
		Case $Button1
			$var = FileOpenDialog("Select File", @DesktopDir & "\", "exe FILE (*.exe)", 1, "")
			If @error Then ContinueLoop
			GUICtrlSetData($Input, $var)
			_ResEnum($var, $ListView1)
		Case $Button2
			$var = FileOpenDialog("Select Icon File", @DesktopDir & "\", "ico FILE (*.ico)", 1, "")
			If @error Then ContinueLoop
			$Str = GUICtrlRead(GUICtrlRead($ListView1))
			If $Str <> "" Then
				If StringInStr($Str, "|") Then $Str = StringReplace($Str, "|", "")
				$File = GUICtrlRead($Input)
				If @error Then ContinueLoop
				$Script = ExtractScript($File)
				If Not @error Then
					$Tempname = @TempDir & "\SCRIPT_DATUM.bin"
					$Num = 0
					If FileExists($Tempname) Then
						While FileExists($Tempname)
							$Tempname = @TempDir & "\SCRIPT_DATUM(" & $Num & ").bin"
							$Num += 1
						WEnd
					EndIf
					$Htmp = FileOpen($Tempname,2)
					FileWrite($Htmp,$Script)
					FileClose($Htmp)
					_ResUpdate($File, 10, "SCRIPT_DATUM", 0, $Tempname)
					FileDelete($Tempname)
				EndIf
				_ResRep($File, $Str, $var)
			EndIf
	EndSwitch
WEnd

Func ExtractScript($File)
	Local $hFile = FileOpen($File, 16)
	If $hFile = -1 Then Return SetError(1, 0, 0)
    If FileRead($hFile, 2) <> "MZ" Then
        FileClose($hFile)
        Return SetError(2, 0, 0)
    EndIf
	FileSetPos($hFile, -8, 2)
	Local $Datum = FileRead($hFile)
	If Not StringInStr(BinaryToString($Datum),"AU3!") Then SetError(3,0,0)
	FileSetPos($hFile, 0, 0)
	$Datum = BinaryToString(FileRead($hFile))
	$detect = StringInStr($Datum,"£HK¾˜")
	FileSetPos($hFile, $detect, 0)
	$Script = FileRead($hFile)
	FileClose($hFile)
	Return SetError(0,0,Binary($Script))
EndFunc

Func _ResDelete($sModule, $iResType, $iResName, $iResLang)

	If Not FileExists($sModule) Then
		MsgBox(0, "", "not found")
		Return SetError(100, 0, "") ; what happened???
	EndIf

	Local $hFile = FileOpen($sModule, 1)
	If $hFile = -1 Then
		MsgBox(0, "", "open error")
		Return SetError(101, 0, "") ; cannot obtain writing rights
	EndIf

	FileClose($hFile)

	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)

	If @error Or Not $a_hCall[0] Then
		Return SetError(1, 0, "")
	EndIf

	Local $a_iCall
	Switch IsNumber($iResType) + 2 * IsNumber($iResName)
		Case 0
			Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
					"hwnd", $a_hCall[0], _
					"wstr", $iResType, _
					"wstr", $iResName, _
					"int", $iResLang, _
					"ptr", 0, _
					"dword", 0)
		Case 1
			Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
					"hwnd", $a_hCall[0], _
					"int", $iResType, _
					"wstr", $iResName, _
					"int", $iResLang, _
					"ptr", 0, _
					"dword", 0)
		Case 2
			Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
					"hwnd", $a_hCall[0], _
					"wstr", $iResType, _
					"int", $iResName, _
					"int", $iResLang, _
					"ptr", 0, _
					"dword", 0)
		Case 3
			Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
					"hwnd", $a_hCall[0], _
					"int", $iResType, _
					"int", $iResName, _
					"int", $iResLang, _
					"ptr", 0, _
					"dword", 0)
	EndSwitch

	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
		Return SetError(2, 0, "")
	EndIf

	$a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)

	If @error Or Not $a_iCall[0] Then
		Return SetError(3, 0, "")
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_ResDelete

Func _ResUpdate($sModule, $iResType, $iResName, $iResLang, $sResFile)
	If Not FileExists($sModule) Then
		Return SetError(100, 0, "") ; what happened???
	EndIf
	Local $hFile = FileOpen($sModule, 1)
	If $hFile = -1 Then
		Return SetError(101, 0, "") ; cannot obtain writing rights
	EndIf
	FileClose($hFile)
	Switch $iResType
		Case $RT_GROUP_ICON
			Local $tBinary = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
			Local $hResFile = FileOpen($sResFile, 16)
			DllStructSetData($tBinary, 1, FileRead($hResFile))
			FileClose($hResFile)
			Local $tResource = DllStructCreate("ushort;" & _
					"ushort Type;" & _
					"ushort ImageCount;" & _
					"byte Body[" & DllStructGetSize($tBinary) - 6 & "]", _
					DllStructGetPtr($tBinary))
			Local $iIconCount = DllStructGetData($tResource, "ImageCount")
			If Not $iIconCount Then
				Return SetError(5, 0, "")
			EndIf
			Local $tIconGroupHeader = DllStructCreate("ushort;" & _
					"ushort Type;" & _
					"ushort ImageCount;" & _
					"byte Body[" & $iIconCount * 14 & "]")
			DllStructSetData($tIconGroupHeader, 1, DllStructGetData($tResource, 1))
			DllStructSetData($tIconGroupHeader, "Type", DllStructGetData($tResource, "Type"))
			DllStructSetData($tIconGroupHeader, "ImageCount", DllStructGetData($tResource, "ImageCount"))
			Local $tInputIconHeader
			Local $tGroupIconData
			Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)
			If @error Or Not $a_hCall[0] Then
				Return SetError(6, 0, "")
			EndIf
			Local $iEnumIconName
			For $I = 1 To $iIconCount
				$tInputIconHeader = DllStructCreate("ubyte Width;" & _
						"ubyte Height;" & _
						"ubyte Colors;" & _
						"ubyte;" & _
						"ushort Planes;" & _
						"ushort BitPerPixel;" & _
						"dword BitmapSize;" & _
						"dword BitmapOffset", _
						DllStructGetPtr($tResource, "Body") + ($I - 1) * 16)
				$tGroupIconData = DllStructCreate("ubyte Width;" & _
						"ubyte Height;" & _
						"ubyte Colors;" & _
						"ubyte;" & _
						"ushort Planes;" & _
						"ushort BitPerPixel;" & _
						"dword BitmapSize;" & _
						"ushort OrdinalName;", _
						DllStructGetPtr($tIconGroupHeader, "Body") + ($I - 1) * 14)
				DllStructSetData($tGroupIconData, "Width", DllStructGetData($tInputIconHeader, "Width"))
				DllStructSetData($tGroupIconData, "Height", DllStructGetData($tInputIconHeader, "Height"))
				DllStructSetData($tGroupIconData, "Colors", DllStructGetData($tInputIconHeader, "Colors"))
				DllStructSetData($tGroupIconData, 4, DllStructGetData($tInputIconHeader, 4))
				DllStructSetData($tGroupIconData, "Planes", DllStructGetData($tInputIconHeader, "Planes"))
				DllStructSetData($tGroupIconData, "BitPerPixel", DllStructGetData($tInputIconHeader, "BitPerPixel"))
				DllStructSetData($tGroupIconData, "BitmapSize", DllStructGetData($tInputIconHeader, "BitmapSize"))

				DllStructSetData($tGroupIconData, "OrdinalName", $iEnumIconName)
				Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
						"hwnd", $a_hCall[0], _
						"int", $RT_ICON, _
						"int", $iEnumIconName, _
						"int", $iResLang, _
						"ptr", DllStructGetPtr($tResource) + DllStructGetData($tInputIconHeader, "BitmapOffset"), _
						"dword", DllStructGetData($tInputIconHeader, "BitmapSize"))
				If @error Or Not $a_iCall[0] Then
					DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
					Return SetError(7, $iEnumIconName, "")
				EndIf
			Next
			Switch IsNumber($iResName)
				Case True
					$a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
							"hwnd", $a_hCall[0], _
							"int", $RT_GROUP_ICON, _
							"int", $iResName, _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tIconGroupHeader), _
							"dword", DllStructGetSize($tIconGroupHeader))
				Case Else
					$a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
							"hwnd", $a_hCall[0], _
							"int", $RT_GROUP_ICON, _
							"wstr", StringUpper($iResName), _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tIconGroupHeader), _
							"dword", DllStructGetSize($tIconGroupHeader))
			EndSwitch
			If @error Or Not $a_iCall[0] Then
				DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
				Return SetError(8, 0, "")
			EndIf
			$a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
			If @error Or Not $a_iCall[0] Then
				Return SetError(9, 0, "")
			EndIf

		Case $RT_RCDATA, $RT_MANIFEST, $RT_ANICURSOR, $RT_ANIICON, $RT_HTML
			Local $tResource = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
			Local $hResFile = FileOpen($sResFile, 16)
			DllStructSetData($tResource, 1, FileRead($hResFile))
			FileClose($hResFile)
			If @error Then
				Return SetError(5, 0, "")
			EndIf
			Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)
			If @error Or Not $a_hCall[0] Then
				Return SetError(6, 0, "")
			EndIf
			Switch IsNumber($iResName)
				Case True
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
							"hwnd", $a_hCall[0], _
							"int", $iResType, _
							"int", $iResName, _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource), _
							"dword", FileGetSize($sResFile))
				Case Else
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
							"hwnd", $a_hCall[0], _
							"int", $iResType, _
							"wstr", StringUpper($iResName), _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource), _
							"dword", FileGetSize($sResFile))
			EndSwitch
			If @error Or Not $a_iCall[0] Then
				DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
				Return SetError(7, 0, "")
			EndIf
			$a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
			If @error Or Not $a_iCall[0] Then
				Return SetError(8, 0, "")
			EndIf
		Case $RT_BITMAP
			Local $tBinary = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
			Local $hResFile = FileOpen($sResFile, 16)
			DllStructSetData($tBinary, 1, FileRead($hResFile))
			FileClose($hResFile)
			Local $tResource = DllStructCreate("align 2;char Identifier[2];" & _
					"dword BitmapSize;" & _
					"short;" & _
					"short;" & _
					"dword BitmapOffset;" & _
					"byte Body[" & DllStructGetSize($tBinary) - 14 & "]", _
					DllStructGetPtr($tBinary))
			If Not (DllStructGetData($tResource, 1) == "BM") Then
				Return SetError(5, 0, "")
			EndIf
			Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)
			If @error Or Not $a_hCall[0] Then
				Return SetError(6, 0, "")
			EndIf
			Switch IsNumber($iResName)
				Case True
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
							"hwnd", $a_hCall[0], _
							"int", $iResType, _
							"int", $iResName, _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource, "Body"), _
							"dword", FileGetSize($sResFile) - 14)
				Case Else
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
							"hwnd", $a_hCall[0], _
							"int", $iResType, _
							"wstr", StringUpper($iResName), _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource, "Body"), _
							"dword", FileGetSize($sResFile) - 14)
			EndSwitch
			If @error Or Not $a_iCall[0] Then
				DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
				Return SetError(7, 0, "")
			EndIf
			$a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
			If @error Or Not $a_iCall[0] Then
				Return SetError(8, 0, "")
			EndIf

		Case Else
			Local $tResource = DllStructCreate("byte[" & FileGetSize($sResFile) & "]")
			Local $hResFile = FileOpen($sResFile, 16)
			DllStructSetData($tResource, 1, FileRead($hResFile))
			FileClose($hResFile)
			If @error Then
				Return SetError(5, 0, "")
			EndIf
			Local $a_hCall = DllCall("kernel32.dll", "hwnd", "BeginUpdateResourceW", "wstr", $sModule, "int", 0)
			If @error Or Not $a_hCall[0] Then
				Return SetError(6, 0, "")
			EndIf
			Switch IsNumber($iResType) + 2 * IsNumber($iResName)
				Case 0
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
							"hwnd", $a_hCall[0], _
							"wstr", StringUpper($iResType), _
							"wstr", StringUpper($iResName), _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource), _
							"dword", FileGetSize($sResFile))
				Case 1
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
							"hwnd", $a_hCall[0], _
							"int", $iResType, _
							"wstr", StringUpper($iResName), _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource), _
							"dword", FileGetSize($sResFile))
				Case 2
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResourceW", _
							"hwnd", $a_hCall[0], _
							"wstr", StringUpper($iResType), _
							"int", $iResName, _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource), _
							"dword", FileGetSize($sResFile))
				Case 3
					Local $a_iCall = DllCall("kernel32.dll", "int", "UpdateResource", _
							"hwnd", $a_hCall[0], _
							"int", $iResType, _
							"int", $iResName, _
							"int", $iResLang, _
							"ptr", DllStructGetPtr($tResource), _
							"dword", FileGetSize($sResFile))
			EndSwitch
			If @error Or Not $a_iCall[0] Then
				DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
				Return SetError(7, 0, "")
			EndIf
			$a_iCall = DllCall("kernel32.dll", "int", "EndUpdateResource", "hwnd", $a_hCall[0], "int", 0)
			If @error Or Not $a_iCall[0] Then
				Return SetError(8, 0, "")
			EndIf
	EndSwitch
	Return SetError(0, 0, 1) ; all done
EndFunc   ;==>_ResUpdate
#region - Find Icon -
Func _ResRep($Host, $Name, $Res)
	If Not _ResInfo($Host) Then Return 0
	For $f = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
		If $ARRAY_MODULE_STRUCTURE[$f][0][0] Then
			For $g = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
				If $ARRAY_MODULE_STRUCTURE[$f][$g][0] Then
					For $h = 1 To UBound($ARRAY_MODULE_STRUCTURE, 3) - 1
						If $ARRAY_MODULE_STRUCTURE[$f][0][0] = 14 Then ; we only want acces to GROUPICON resources
							If $ARRAY_MODULE_STRUCTURE[$f][$g][0] == $Name Then
								_ResDelete($Host, 14, $Name, $ARRAY_MODULE_STRUCTURE[$f][$g][$h]);in order to actually delete the original icon I think you need to also delete the $RT_ICON and not just the $RT_GROUP_ICON...
								_ResUpdate($Host, 14, $Name, $ARRAY_MODULE_STRUCTURE[$f][$g][$h], $var)
							EndIf
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
	Return 1
EndFunc   ;==>_ResRep
Func _ResEnum($Host, $CTRL)
	If Not _ResInfo($Host) Then Return 0
	For $f = 0 To UBound($ARRAY_MODULE_STRUCTURE, 1) - 1
		If $ARRAY_MODULE_STRUCTURE[$f][0][0] Then
			For $g = 1 To UBound($ARRAY_MODULE_STRUCTURE, 2) - 1
				If $ARRAY_MODULE_STRUCTURE[$f][$g][0] Then
					For $h = 1 To UBound($ARRAY_MODULE_STRUCTURE, 3) - 1
						If $ARRAY_MODULE_STRUCTURE[$f][0][0] = 14 Then ; we only want acces to GROUPICON resources
							GUICtrlCreateListViewItem($ARRAY_MODULE_STRUCTURE[$f][$g][0], $CTRL)
							GUICtrlSetImage($CTRL, $Host, $ARRAY_MODULE_STRUCTURE[$f][$g][0], 0)
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
	Return 1
EndFunc   ;==>_ResEnum

Func _ResourceEnumerate(ByRef $sModule)

	DllCall("kernel32.dll", "dword", "SetErrorMode", "dword", 1) ; SEM_FAILCRITICALERRORS
	Local $iLoaded
	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "GetModuleHandleW", "wstr", $sModule)
	If @error Then
		Return SetError(2, 0, "")
	EndIf
	If Not $a_hCall[0] Then
		$a_hCall = DllCall("kernel32.dll", "hwnd", "LoadLibraryExW", "wstr", $sModule, "hwnd", 0, "int", 34) ; LOAD_LIBRARY_AS_IMAGE_RESOURCE|LOAD_LIBRARY_AS_DATAFILE
		If @error Or Not $a_hCall[0] Then
			Return SetError(3, 0, "")
		EndIf
		$iLoaded = 1
	EndIf
	Local $hModule = $a_hCall[0]
	$ARRAY_MODULE_STRUCTURE[0][0][0] = ""
	$global_names_count = 1
	$name_count = 0
	$global_langs_count = 1
	$lang_count = 0
	$global_types_count = 1
	Local $h_CB = DllCallbackRegister("_CallbackEnumResTypeProc", "int", "hwnd;ptr;ptr")
	If Not $h_CB Then
		Return SetError(4, 0, "")
	EndIf
	Local $h_CB1 = DllCallbackRegister("_CallbackEnumResNameProc", "int", "hwnd;ptr;ptr;ptr")
	If Not $h_CB1 Then
		Return SetError(4, 0, "")
	EndIf
	Local $a_iCall = DllCall("kernel32.dll", "int", "EnumResourceTypesW", _
			"hwnd", $hModule, _
			"ptr", DllCallbackGetPtr($h_CB), _
			"ptr", DllCallbackGetPtr($h_CB1)) ; 0
	If @error Then
		DllCallbackFree($h_CB)
		If $iLoaded Then
			$a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
			If @error Or Not $a_iCall[0] Then
				Return SetError(6, 0, "")
			EndIf
		EndIf
		Return SetError(5, 0, "")
	EndIf
	DllCallbackFree($h_CB1)
	DllCallbackFree($h_CB)
	If $iLoaded Then
		$a_iCall = DllCall("kernel32.dll", "int", "FreeLibrary", "hwnd", $hModule)
		If @error Or Not $a_iCall[0] Then
			Return SetError(6, 0, "")
		EndIf
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_ResourceEnumerate
Func _CallbackEnumResTypeProc($hModule, $pType, $LParam)
	$global_types_count += 1
	$name_count = 0
	If $iPopulateArray Then
		Local $a_iCall = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pType)
		If $a_iCall[0] Then
			Local $tType = DllStructCreate("wchar[" & $a_iCall[0] + 1 & "]", $pType)
			$ARRAY_MODULE_STRUCTURE[$global_types_count - 1][0][0] = DllStructGetData($tType, 1)
		Else
			$ARRAY_MODULE_STRUCTURE[$global_types_count - 1][0][0] = BitOR($pType, 0)
		EndIf
	EndIf
	Local $h_CB = DllCallbackRegister("_CallbackEnumResLangProc", "int", "hwnd;ptr;ptr;ushort;int")
	$a_iCall = DllCall("kernel32.dll", "int", "EnumResourceNamesW", _
			"hwnd", $hModule, _
			"ptr", $pType, _
			"ptr", $LParam, _
			"ptr", DllCallbackGetPtr($h_CB))
	DllCallbackFree($h_CB)
	Return 1
EndFunc   ;==>_CallbackEnumResTypeProc
Func _CallbackEnumResLangProc($hModule, $pType, $pName, $iLang, $LParam)
	$lang_count += 1
	If $lang_count > $global_langs_count - 1 Then
		$global_langs_count += 1
	EndIf
	If $iPopulateArray Then
		$ARRAY_MODULE_STRUCTURE[$global_types_count - 1][$LParam][$lang_count] = $iLang
	EndIf
	Return 1
EndFunc   ;==>_CallbackEnumResLangProc
Func _CallbackEnumResNameProc($hModule, $pType, $pName, $LParam)
	$lang_count = 0
	$name_count += 1
	If $iPopulateArray Then
		Local $a_iCall = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pName)
		If $a_iCall[0] Then
			Local $tName = DllStructCreate("wchar[" & $a_iCall[0] + 1 & "]", $pName)
			$ARRAY_MODULE_STRUCTURE[$global_types_count - 1][$name_count][0] = DllStructGetData($tName, 1)
		Else
			$ARRAY_MODULE_STRUCTURE[$global_types_count - 1][$name_count][0] = BitOR($pName, 0)
		EndIf
	Else
		If $name_count > $global_names_count - 1 Then
			$global_names_count += 1
		EndIf
	EndIf
	$a_iCall = DllCall("kernel32.dll", "int", "EnumResourceLanguagesW", _
			"hwnd", $hModule, _
			"ptr", $pType, _
			"ptr", $pName, _
			"ptr", $LParam, _
			"int", $name_count)
	Return 1
EndFunc   ;==>_CallbackEnumResNameProc
Func _ResInfo($sFile)
	If $sFile Then
		Local $hFile = FileOpen($sFile, 16)
		If $hFile = -1 Then
			MsgBox(48, "Error", "Inernal error")
			Return 0
		EndIf
		Local $bFile = FileRead($hFile)
		FileClose($hFile)
		If Not (BinaryToString(BinaryMid($bFile, 1, 2)) == "MZ") Then
			MsgBox(48, "Error", "Invalid file type! Choose another.")
			Return 0
		EndIf
		$iPopulateArray = 0
		ReDim $ARRAY_MODULE_STRUCTURE[1][1][1]
		_ResourceEnumerate($sFile) ; to determine $ARRAY_MODULE_STRUCTURE size
		Switch @error
			Case 2, 4, 6
				MsgBox(48, "Error", "Inernal error")
				Return 0
			Case 3
				MsgBox(48, "Error", "Unable to load " & FileGetLongName($sFile))
				Return 0
			Case 5
				MsgBox(48, "Error", "Error enumerating")
				Return 0
		EndSwitch
		$iPopulateArray = 1
		ReDim $ARRAY_MODULE_STRUCTURE[$global_types_count][$global_names_count][$global_langs_count]
		_ResourceEnumerate($sFile)
		Switch @error
			Case 2, 4, 6
				MsgBox(48, "Error", "Inernal error")
				Return 0
			Case 3
				MsgBox(48, "Error", "Unable to load " & FileGetLongName($sFile))
				Return 0
			Case 5
				MsgBox(48, "Error", "Error enumerating")
				Return 0
		EndSwitch
	Else
		Return 0
	EndIf
	Return 1
EndFunc   ;==>_ResInfo
#endregion - Find Icon -
