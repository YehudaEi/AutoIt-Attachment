#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=video.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <Array.au3>

If (@OSArch = "X64") And (@OSVersion = "WIN_7" Or @OSVersion = "WIN_8") Then
	_coreGUI()
Else
	MsgBox(0, "", "Operaèní systém není podporován")
	Exit
EndIf

Func _coreGUI()

	$Debug_LV = False

	Global $GUI, $ListSplit, $ListSplit64, $ListFiltr, $ListFiltr64, $ListVypis, $ListVypis64, $tab
	Global $ListSplitInput, $ListSplitCombo, $ListSplitButton
	Global $iCurrTab, $iLastTab = 0
	_MediaSubType()
	_MediaMajorType()

	$GUI = GUICreate("WinDSFilterManager", 940, 400)

	$tab = GUICtrlCreateTab(6, 6, 928, 388)
	GUICtrlCreateTabItem("splitter")
		GUICtrlCreateGroup("", 13, 26, 912, 272)
		$ListSplit = _GUICtrlListView_Create($GUI, "", 15, 35, 908, 260)
		GUICtrlCreateLabel("Kontejner:", 15, 320)
		$ListSplitInput = GUICtrlCreateInput(".", 70, 317, 80, 20)
		GUICtrlCreateLabel("Splitter:", 160, 320)
		$ListSplitCombo = GUICtrlCreateCombo("", 200, 317, 250)
		$ListSplitButton = GUICtrlCreateButton("Proveï", 470, 315, 80)
	GUICtrlCreateTabItem("splitter x64")
		$ListSplit64 = GUICtrlCreateListView("", 15, 35, 908, 260)
	GUICtrlCreateTabItem("filtr")
		$ListFiltr = GUICtrlCreateListView("", 15, 35, 908, 260)
	GUICtrlCreateTabItem("filtr x64")
		$ListFiltr64 = GUICtrlCreateListView("", 15, 35, 908, 260)
	GUICtrlCreateTabItem("výpis")
		$ListVypis = GUICtrlCreateListView("", 15, 35, 908, 260)
	GUICtrlCreateTabItem("výpis x64")
		$ListVypis64 = GUICtrlCreateListView("", 15, 35, 908, 260)
	GUICtrlCreateTabItem("info")
		$VytvoritLog = GUICtrlCreateButton("Vytvoøit LOG", 20, 50, 100)
	GUICtrlCreateTabItem("")
	GUISetState()

	_GUICtrlListView_AddColumn($ListSplit, "Kontejner", 80)
	_GUICtrlListView_AddColumn($ListSplit, "Splitter", 150)
	_GUICtrlListView_AddColumn($ListSplit, "SplitterID", 260)
	_GUICtrlListView_AddColumn($ListSplit64, "Kontejner", 80)
	_GUICtrlListView_AddColumn($ListSplit64, "Splitter", 150)
	_GUICtrlListView_AddColumn($ListSplit64, "SplitterID", 260)

	_GUICtrlListView_AddColumn($ListFiltr, "Formát", 120)
	_GUICtrlListView_AddColumn($ListFiltr, "FormátID", 260)
	_GUICtrlListView_AddColumn($ListFiltr, "Filtr", 220)
	_GUICtrlListView_AddColumn($ListFiltr, "FiltrID", 260)
	_GUICtrlListView_AddColumn($ListFiltr64, "Formát", 120)
	_GUICtrlListView_AddColumn($ListFiltr64, "FormátID", 260)
	_GUICtrlListView_AddColumn($ListFiltr64, "Filtr", 220)
	_GUICtrlListView_AddColumn($ListFiltr64, "FiltrID", 260)

	_GUICtrlListView_AddColumn($ListVypis, "Filtr", 280)
	_GUICtrlListView_AddColumn($ListVypis, "FiltrID", 280)
	_GUICtrlListView_AddColumn($ListVypis, "Druh", 160)
	_GUICtrlListView_AddColumn($ListVypis64, "Filtr", 280)
	_GUICtrlListView_AddColumn($ListVypis64, "FiltrID", 280)
	_GUICtrlListView_AddColumn($ListVypis64, "Druh", 160)


	_ParserSplitterArray("")
	_ParserSplitterArray("64")
	_ParserFiltrArray("")
	_ParserFiltrArray("64")
	_ParserVypisArray("")
	_ParserVypisArray("64")
	_ListSplitCombo()

	While 1
		Switch GUIGetMsg()
			Case -3
				Exit
			Case $VytvoritLog
				_VytvoritLog()
			Case $ListSplitButton
				_ListSplitNastavit()
		EndSwitch

		$iCurrTab = GUICtrlRead($tab)
		If $iCurrTab <> $iLastTab Then
			$iLastTab = $iCurrTab
			Switch $iCurrTab
				Case 0
					ControlShow($GUI, "", $ListSplit)
				Case 1
					ControlHide($GUI, "", $ListSplit)
				Case 2
					ControlHide($GUI, "", $ListSplit)
				Case 3
					ControlHide($GUI, "", $ListSplit)
				Case 4
					ControlHide($GUI, "", $ListSplit)
				Case 5
					ControlHide($GUI, "", $ListSplit)
				Case 6
					ControlHide($GUI, "", $ListSplit)
				Case 7
					ControlHide($GUI, "", $ListSplit)
				Case 8
					ControlHide($GUI, "", $ListSplit)
				Case 9
					ControlHide($GUI, "", $ListSplit)
			EndSwitch
		EndIf

	WEnd

	GUIDelete()

EndFunc   ;==>_coreGUI

Func _MediaSubType()
	Global $MediaSubType[50][2] = [ _
	["{00001600-0000-0010-8000-00aa00389b71}", "MPEG_ADTS_AAC"], _
	["{00001602-0000-0010-8000-00aa00389b71}", "MPEG_LOAS"], _
	["{000000FF-0000-0010-8000-00aa00389b71}", "RAW_AAC1"], _
	["{E06D8032-DB46-11CF-B4D1-00805F6CBBEA}", "DVD_LPCM_AUDIO"], _
	["{00000050-0000-0010-8000-00AA00389B71}", "MPEG1AudioPayload"], _
	["{e436eb80-524f-11ce-9f53-0020af0ba770}", "MPEG1Packet"], _
	["{e436eb81-524f-11ce-9f53-0020af0ba770}", "MPEG1Payload"], _
	["{e06d802b-db46-11cf-b4d1-00805f6cbbea}", "MPEG2_AUDIO"], _
	["{00000160-0000-0010-8000-00aa00389b71}", "WMAUDIO1"], _
	["{00000161-0000-0010-8000-00aa00389b71}", "WMAUDIO2"], _
	["{00000162-0000-0010-8000-00aa00389b71}", "WMAUDIO3"], _
	["{00000163-0000-0010-8000-00aa00389b71}", "WMAudio_Lossless"], _
	["{0000000A-0000-0010-8000-00AA00389B71}", "WMSP1"], _
	["{0000000B-0000-0010-8000-00AA00389B71}", "WMSP2"], _
	["{00000055-0000-0010-8000-00AA00389B71}", "MP3"], _
	["{31564D57-0000-0010-8000-00AA00389B71}", "WMV1"], _
	["{32564D57-0000-0010-8000-00AA00389B71}", "WMV2"], _
	["{33564D57-0000-0010-8000-00AA00389B71}", "WMV3"], _
	["{41564D57-0000-0010-8000-00AA00389B71}", "WMVA"], _
	["{31435657-0000-0010-8000-00AA00389B71}", "WVC1"], _
	["{50564D57-0000-0010-8000-00AA00389B71}", "WMVP"], _
	["{32505657-0000-0010-8000-00AA00389B71}", "WVP2"], _
	["{3153534D-0000-0010-8000-00AA00389B71}", "MSS1"], _
	["{3253534D-0000-0010-8000-00AA00389B71}", "MSS2"], _
	["{52564D57-0000-0010-8000-00AA00389B71}", "WMVR"], _
	["{e06d8026-db46-11cf-b4d1-00805f6cbbea}", "MPEG2_VIDEO"], _
	["{3467706D-0000-0010-8000-00AA00389B71}", "mpg4"], _
	["{3447504D-0000-0010-8000-00AA00389B71}", "MPG4"], _
	["{7334706D-0000-0010-8000-00AA00389B71}", "mp4s"], _
	["{5334504D-0000-0010-8000-00AA00389B71}", "MP4S"], _
	["{7634706D-0000-0010-8000-00AA00389B71}", "mp4v"], _
	["{5634504D-0000-0010-8000-00AA00389B71}", "MP4V"], _
	["{3273346D-0000-0010-8000-00AA00389B71}", "m4s2"], _
	["{3253344D-0000-0010-8000-00AA00389B71}", "M4S2"], _
	["{3234706D-0000-0010-8000-00AA00389B71}", "mp42"], _
	["{3234504D-0000-0010-8000-00AA00389B71}", "MP42"], _
	["{3334706D-0000-0010-8000-00AA00389B71}", "mp43"], _
	["{3334504D-0000-0010-8000-00AA00389B71}", "MP43"], _
	["{31435641-0000-0010-8000-00AA00389B71}", "AVC1"], _
	["{34363248-0000-0010-8000-00AA00389B71}", "H264"], _
	["{34363268-0000-0010-8000-00AA00389B71}", "h264"], _
	["{78766964-0000-0010-8000-00AA00389B71}", "divx"], _
	["{58564944-0000-0010-8000-00AA00389B71}", "DIVX"], _
	["{20637664-0000-0010-8000-00AA00389B71}", "DVC"], _
	["{6c737664-0000-0010-8000-00AA00389B71}", "dvsl"], _
	["{64737664-0000-0010-8000-00AA00389B71}", "dvsd"], _
	["{64687664-0000-0010-8000-00AA00389B71}", "dvhd"], _
	["{64697678-0000-0010-8000-00AA00389B71}", "xvid"], _
	["{44495658-0000-0010-8000-00AA00389B71}", "XVID"], _
	["{47504A4D-0000-0010-8000-00AA00389B71}", "MJPG"]]
EndFunc   ;==>_MediaSubType

Func _MediaMajorType()
	Global $MediaMajorType[4][2] = [ _
	["{73647561-0000-0010-8000-00AA00389B71}", "Audio"], _
	["{73646976-0000-0010-8000-00AA00389B71}", "Video"], _
	["{E436EB83-524F-11CE-9F53-0020AF0BA770}", "Stream"], _
	["{ED0B916A-044D-11D1-AA78-00C04FC31D60}", "MEDIATYPE_DVD_ENCRYPTED_PACK"]]

EndFunc   ;==>_MediaMajorType

Func _ParserSplitterArray($OSArch)
	Local $i = 1, $j, $var1, $var2, $regArray[1], $regArrayCLSID[1]
	While 1
		$var1 = RegEnumKey("HKCR"&$OSArch&"\Media Type\Extensions", $i)
		If @error <> 0 Then ExitLoop
		$var2 = RegRead("HKCR"&$OSArch&"\Media Type\Extensions\" & $var1, "Source Filter")
		If @error <> 0 Then
			$i = $i + 1
			ContinueLoop
		EndIf
		If $i = 1 Then
			$regArray[0] = $var1
			$regArrayCLSID[0] = $var2
		EndIf
		If $i > 1 Then
			_ArrayAdd($regArray, $var1)
			_ArrayAdd($regArrayCLSID, $var2)
		EndIf
		$i = $i + 1
	WEnd
	If UBound($regArray) > 0 And $regArray[0] <> "" Then
		Local $aItems[UBound($regArray)][3]
		For $j = 0 To UBound($regArray) - 1
			$aItems[$j][0] = $regArray[$j]
			$aItems[$j][2] = $regArrayCLSID[$j]
			$aItems[$j][1] = RegRead("HKCR"&$OSArch&"\CLSID\" & $aItems[$j][2], "")
			If @error <> 0 Then $aItems[$j][1] = "Nenaèteno"
		Next
	EndIf
	If $OSArch = "" Then _GUICtrlListView_AddArray($ListSplit, $aItems)
	If $OSArch = "64" Then _GUICtrlListView_AddArray($ListSplit64, $aItems)
EndFunc   ;==>_ParserSplitterArray


Func _ParserFiltrArray($OSArch)
	Local $i = 1, $j, $var, $regArray[1], $ArraySearch
	While 1
		$var = RegEnumVal("HKLM"&$OSArch&"\SOFTWARE\Microsoft\DirectShow\Preferred", $i)
		If @error <> 0 Then ExitLoop
		If $i = 1 Then $regArray[0] = $var
		If $i > 1 Then _ArrayAdd($regArray, $var)
		$i = $i + 1
	WEnd
	If UBound($regArray) > 0 And $regArray[0] <> "" Then
		Local $aItems[UBound($regArray)][4]
		For $j = 0 To UBound($regArray) - 1
			$ArraySearch = _ArraySearch($MediaSubType, $regArray[$j], 0, 0, 0, 1, 1, 0)
			If @error Then
				$aItems[$j][0] = ""
			Else
				$aItems[$j][0] = $MediaSubType[$ArraySearch][1]
			EndIf
			$aItems[$j][1] = $regArray[$j]
			$aItems[$j][3] = RegRead("HKLM"&$OSArch&"\SOFTWARE\Microsoft\DirectShow\Preferred",  $regArray[$j])
			$aItems[$j][2] = RegRead("HKCR"&$OSArch&"\CLSID\" & $aItems[$j][3], "")
		Next
	EndIf
	_ArraySort($aItems, 0, 0, 0, 1)
	If $OSArch = "" Then _GUICtrlListView_AddArray($ListFiltr, $aItems)
	If $OSArch = "64" Then _GUICtrlListView_AddArray($ListFiltr64, $aItems)
EndFunc   ;==>_ParserFiltrArray

Func _ParserVypisArray($OSArch)
	Local $i = 1, $j, $var, $regArrayDMOa[1], $regArrayDMOv[1], $regArrayDS[1]
	While 1
		$var = RegEnumKey("HKCR"&$OSArch&"\CLSID\{083863F1-70DE-11D0-BD40-00A0C911CE86}\Instance", $i)
		If @error <> 0 Then ExitLoop
		If $i = 1 Then $regArrayDS[0] = $var
		If $i > 1 Then _ArrayAdd($regArrayDS, $var)
		$i = $i + 1
	WEnd
	If UBound($regArrayDS) > 0 And $regArrayDS[0] <> "" Then
		Local $aItems1[UBound($regArrayDS)][3]
		For $j = 0 To UBound($regArrayDS) - 1
			$aItems1[$j][0] = RegRead("HKCR"&$OSArch&"\CLSID\{083863F1-70DE-11D0-BD40-00A0C911CE86}\Instance\" & $regArrayDS[$j], "FriendlyName")
			$aItems1[$j][1] = $regArrayDS[$j]
			$aItems1[$j][2] = "DirectShow"
		Next
	EndIf
	_ArraySort($aItems1, 0, 0, 0, 0)
	If $OSArch = "" Then _GUICtrlListView_AddArray($ListVypis, $aItems1)
	If $OSArch = "64" Then _GUICtrlListView_AddArray($ListVypis64, $aItems1)

	$i = 1
	While 1
		$var = RegEnumKey("HKCR"&$OSArch&"\DirectShow\MediaObjects\Categories\57f2db8b-e6bb-4513-9d43-dcd2a6593125", $i)
		If @error <> 0 Then ExitLoop
		If $i = 1 Then $regArrayDMOa[0] = $var
		If $i > 1 Then _ArrayAdd($regArrayDMOa, $var)
		$i = $i + 1
	WEnd
	If UBound($regArrayDMOa) > 0 And $regArrayDMOa[0] <> "" Then
		Local $aItems2[UBound($regArrayDMOa)][3]
		For $j = 0 To UBound($regArrayDMOa) - 1
			$aItems2[$j][0] = RegRead("HKCR"&$OSArch&"\DirectShow\MediaObjects\" & $regArrayDMOa[$j], "")
			$aItems2[$j][1] = $regArrayDMOa[$j]
			$aItems2[$j][2] = "DMO audio"
		Next
	EndIf
	_ArraySort($aItems2, 0, 0, 0, 0)
	If $OSArch = "" Then _GUICtrlListView_AddArray($ListVypis, $aItems2)
	If $OSArch = "64" Then _GUICtrlListView_AddArray($ListVypis64, $aItems2)

	$i = 1
	While 1
		$var = RegEnumKey("HKCR"&$OSArch&"\DirectShow\MediaObjects\Categories\4a69b442-28be-4991-969c-b500adf5d8a8", $i)
		If @error <> 0 Then ExitLoop
		If $i = 1 Then $regArrayDMOv[0] = $var
		If $i > 1 Then _ArrayAdd($regArrayDMOv, $var)
		$i = $i + 1
	WEnd
	If UBound($regArrayDMOv) > 0 And $regArrayDMOv[0] <> "" Then
		Local $aItems3[UBound($regArrayDMOv)][3]
		For $j = 0 To UBound($regArrayDMOv) - 1
			$aItems3[$j][0] = RegRead("HKCR"&$OSArch&"\DirectShow\MediaObjects\" & $regArrayDMOv[$j], "")
			$aItems3[$j][1] = $regArrayDMOv[$j]
			$aItems3[$j][2] = "DMO video"
		Next
	EndIf
	_ArraySort($aItems3, 0, 0, 0, 0)
	If $OSArch = "" Then _GUICtrlListView_AddArray($ListVypis, $aItems3)
	If $OSArch = "64" Then _GUICtrlListView_AddArray($ListVypis64, $aItems3)
EndFunc   ;==>_ParserVypisArray

Func _VytvoritLog()
	Local $i, $j, $temp, $tempFD, $trim, $flags, $midMajor, $midSub, $ArraySearch, $tempMerit
	Local $file = FileOpen("log.txt", 2)

	FileWriteLine($file, "----- Preferované Splitery (32-bit) -----" & @CRLF & @CRLF)
	For $j = 0 To _GUICtrlListView_GetItemCount($ListSplit) - 1
		$temp = _GUICtrlListView_GetItemText($ListSplit, $j, 0)
		While StringLen($temp) < 9
			$temp &= " "
		WEnd
		$temp &= _GUICtrlListView_GetItemText($ListSplit, $j, 2) & "  " & _GUICtrlListView_GetItemText($ListSplit, $j, 1)
		FileWriteLine($file, $temp)
	Next
	FileWriteLine($file, @CRLF & "----- Preferované Splitery (32-bit) -----" & @CRLF & @CRLF)

	FileWriteLine($file, "----- Preferované Splitery (64-bit) -----" & @CRLF & @CRLF)
	For $j = 0 To _GUICtrlListView_GetItemCount($ListSplit64) - 1
		$temp = _GUICtrlListView_GetItemText($ListSplit64, $j, 0)
		While StringLen($temp) < 9
			$temp &= " "
		WEnd
		$temp &= _GUICtrlListView_GetItemText($ListSplit64, $j, 2) & "  " & _GUICtrlListView_GetItemText($ListSplit64, $j, 1)
		FileWriteLine($file, $temp)
	Next
	FileWriteLine($file, @CRLF & "----- Preferované Splitery (64-bit) -----" & @CRLF & @CRLF)

	FileWriteLine($file, "------ Preferované Filtry (32-bit) ------" & @CRLF & @CRLF)
	For $j = 0 To _GUICtrlListView_GetItemCount($ListFiltr) - 1
		FileWriteLine($file, _GUICtrlListView_GetItemText($ListFiltr, $j,1) & "  " & _GUICtrlListView_GetItemText($ListFiltr, $j, 0))
		FileWriteLine($file, _GUICtrlListView_GetItemText($ListFiltr, $j,3) & "  " & _GUICtrlListView_GetItemText($ListFiltr, $j, 2) & @CRLF & @CRLF)
	Next
	FileWriteLine($file, "------ Preferované Filtry (32-bit) ------" & @CRLF & @CRLF)

	FileWriteLine($file, "------ Preferované Filtry (64-bit) ------" & @CRLF & @CRLF)
	For $j = 0 To _GUICtrlListView_GetItemCount($ListFiltr64) - 1
		FileWriteLine($file, _GUICtrlListView_GetItemText($ListFiltr64, $j,1) & "  " & _GUICtrlListView_GetItemText($ListFiltr64, $j, 0))
		FileWriteLine($file, _GUICtrlListView_GetItemText($ListFiltr64, $j,3) & "  " & _GUICtrlListView_GetItemText($ListFiltr64, $j, 2) & @CRLF & @CRLF)
	Next
	FileWriteLine($file, "------ Preferované Filtry (64-bit) ------" & @CRLF & @CRLF)

	FileWriteLine($file, "------------ Filtry (32-bit) ------------" & @CRLF & @CRLF)
	For $j = 0 To _GUICtrlListView_GetItemCount($ListVypis) - 1
		FileWriteLine($file, _GUICtrlListView_GetItemText($ListVypis, $j, 0) & " " & _GUICtrlListView_GetItemText($ListVypis, $j, 1))
		FileWriteLine($file, "    Druh:     " & _GUICtrlListView_GetItemText($ListVypis, $j, 2))
		If _GUICtrlListView_GetItemText($ListVypis, $j, 2) = "DirectShow" Then
			FileWriteLine($file, "    Soubor:   " & RegRead("HKCR\CLSID\" & _GUICtrlListView_GetItemText($ListVypis, $j, 1) & "\InprocServer32", ""))
			$tempFD = RegRead("HKCR\CLSID\{083863F1-70DE-11D0-BD40-00A0C911CE86}\Instance\" & _GUICtrlListView_GetItemText($ListVypis, $j, 1), "FilterData")
			$tempFD = StringTrimLeft ($tempFD, 2)
			$trim = StringTrimLeft ($tempFD, 32)
			FileWriteLine($file, "    Merit:    " & StringMid ($tempFD, 15, 2) & StringMid ($tempFD, 13, 2) & StringMid ($tempFD, 11, 2) & StringMid ($tempFD, 9, 2))
			While StringMid ($trim, 3, 2) & StringMid ($trim, 5, 2) & StringMid ($trim, 7, 2) = "706933"
				If StringMid ($trim, 9, 2) = "00" Then
					$flags = " Input"
				ElseIf StringMid ($trim, 9, 2) = "02" Then
					$flags = " Rendered"
				ElseIf StringMid ($trim, 9, 2) = "04" Then
					$flags = " Many"
				ElseIf StringMid ($trim, 9, 2) = "08" Then
					$flags = " Output"
				Else
					$flags = " Input"
				EndIf
				FileWriteLine($file, "    Pin " & Dec(StringMid ($trim, 1, 2)) - 48 & $flags)
				$trim = StringTrimLeft ($trim, 48)
				While StringMid ($trim, 3, 2) & StringMid ($trim, 5, 2) & StringMid ($trim, 7, 2) = "747933"
					FileWriteLine($file,  "        Type " & Dec(StringMid ($trim, 1, 2)) - 48)
					$mid = Dec (StringMid ($trim, 23, 2) & StringMid ($trim, 21, 2) & StringMid ($trim, 19, 2) & StringMid ($trim, 17, 2)) * 2 + 1
					$midMajor = _DecryptCLSID($tempFD, $mid)
					$ArraySearch = _ArraySearch($MediaMajorType, $midMajor, 0, 0, 0, 1, 1, 0)
					If @error Then
						$ArraySearch = ""
					Else
						$ArraySearch = " " & $MediaMajorType[$ArraySearch][1]
					EndIf
					FileWriteLine($file,  "            " & $midMajor & $ArraySearch)
					$mid = Dec (StringMid ($trim, 31, 2) & StringMid ($trim, 29, 2) & StringMid ($trim, 27, 2) & StringMid ($trim, 25, 2)) * 2 + 1
					$midSub = _DecryptCLSID($tempFD, $mid)
					$ArraySearch = _ArraySearch($MediaSubType, $midSub, 0, 0, 0, 1, 1, 0)
					If @error Then
						$ArraySearch = ""
					Else
						$ArraySearch = " " & $MediaSubType[$ArraySearch][1]
					EndIf
					FileWriteLine($file,  "            " & $midSub & $ArraySearch)
					$trim = StringTrimLeft ($trim, 32)
				WEnd
			WEnd
			FileWriteLine($file, @CRLF & @CRLF)
		Else
			FileWriteLine($file, "    Soubor:   " & RegRead("HKCR\CLSID\{" & _GUICtrlListView_GetItemText($ListVypis, $j, 1) & "}\InprocServer32", ""))
			$tempMerit = RegRead("HKCR\CLSID\{" & _GUICtrlListView_GetItemText($ListVypis, $j, 1) & "}", "Merit")
			If @error Then
				$tempMerit = "00600800"
			Else
				$tempMerit = Hex(String($tempMerit))
			EndIf
			FileWriteLine($file, "    Merit:    " & $tempMerit)
			$trim = StringTrimLeft (RegRead("HKCR\DirectShow\MediaObjects\" & _GUICtrlListView_GetItemText($ListVypis, $j, 1), "InputTypes"), 2)
			$i = 0
			FileWriteLine($file, "    Pin 0 Input")
			While StringLen ($trim) > 0
				FileWriteLine($file,  "        Type " & $i)
				$midMajor = _DecryptCLSID($trim, 1)
				$ArraySearch = _ArraySearch($MediaMajorType, $midMajor, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaMajorType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midMajor & $ArraySearch)
				$midSub = _DecryptCLSID($trim, 33)
				$ArraySearch = _ArraySearch($MediaSubType, $midSub, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaSubType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midSub & $ArraySearch)
				$trim = StringTrimLeft ($trim, 64)
				$i = $i + 1
			WEnd
			$trim = StringTrimLeft (RegRead("HKCR\DirectShow\MediaObjects\" & _GUICtrlListView_GetItemText($ListVypis, $j, 1), "OutputTypes"), 2)
			$i = 0
			FileWriteLine($file, "    Pin 1 Output")
			While StringLen ($trim) > 0
				FileWriteLine($file,  "        Type " & $i)
				$midMajor = _DecryptCLSID($trim, 1)
				$ArraySearch = _ArraySearch($MediaMajorType, $midMajor, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaMajorType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midMajor & $ArraySearch)
				$midSub = _DecryptCLSID($trim, 33)
				$ArraySearch = _ArraySearch($MediaSubType, $midSub, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaSubType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midSub & $ArraySearch)
				$trim = StringTrimLeft ($trim, 64)
				$i = $i + 1
			WEnd
			FileWriteLine($file, @CRLF & @CRLF)
		EndIf
	Next
	FileWriteLine($file, "------------ Filtry (32-bit) ------------" & @CRLF & @CRLF)

	FileWriteLine($file, "------------ Filtry (64-bit) ------------" & @CRLF & @CRLF)
	For $j = 0 To _GUICtrlListView_GetItemCount($ListVypis64) - 1
		FileWriteLine($file, _GUICtrlListView_GetItemText($ListVypis64, $j, 0) & " " & _GUICtrlListView_GetItemText($ListVypis64, $j, 1))
		FileWriteLine($file, "    Druh:     " & _GUICtrlListView_GetItemText($ListVypis64, $j, 2))
		If _GUICtrlListView_GetItemText($ListVypis64, $j, 2) = "DirectShow" Then
			FileWriteLine($file, "    Soubor:   " & RegRead("HKCR64\CLSID\" & _GUICtrlListView_GetItemText($ListVypis64, $j, 1) & "\InprocServer32", ""))
			$tempFD = RegRead("HKCR64\CLSID\{083863F1-70DE-11D0-BD40-00A0C911CE86}\Instance\" & _GUICtrlListView_GetItemText($ListVypis64, $j, 1), "FilterData")
			$tempFD = StringTrimLeft ($tempFD, 2)
			$trim = StringTrimLeft ($tempFD, 32)
			FileWriteLine($file, "    Merit:    " & StringMid ($tempFD, 15, 2) & StringMid ($tempFD, 13, 2) & StringMid ($tempFD, 11, 2) & StringMid ($tempFD, 9, 2))
			While StringMid ($trim, 3, 2) & StringMid ($trim, 5, 2) & StringMid ($trim, 7, 2) = "706933"
				If StringMid ($trim, 9, 2) = "00" Then
					$flags = " Input"
				ElseIf StringMid ($trim, 9, 2) = "02" Then
					$flags = " Rendered"
				ElseIf StringMid ($trim, 9, 2) = "04" Then
					$flags = " Many"
				ElseIf StringMid ($trim, 9, 2) = "08" Then
					$flags = " Output"
				Else
					$flags = " Input"
				EndIf
				FileWriteLine($file, "    Pin " & Dec(StringMid ($trim, 1, 2)) - 48 & $flags)
				$trim = StringTrimLeft ($trim, 48)
				While StringMid ($trim, 3, 2) & StringMid ($trim, 5, 2) & StringMid ($trim, 7, 2) = "747933"
					FileWriteLine($file,  "        Type " & Dec(StringMid ($trim, 1, 2)) - 48)
					$mid = Dec (StringMid ($trim, 23, 2) & StringMid ($trim, 21, 2) & StringMid ($trim, 19, 2) & StringMid ($trim, 17, 2)) * 2 + 1
					$midMajor = _DecryptCLSID($tempFD, $mid)
					$ArraySearch = _ArraySearch($MediaMajorType, $midMajor, 0, 0, 0, 1, 1, 0)
					If @error Then
						$ArraySearch = ""
					Else
						$ArraySearch = " " & $MediaMajorType[$ArraySearch][1]
					EndIf
					FileWriteLine($file,  "            " & $midMajor & $ArraySearch)
					$mid = Dec (StringMid ($trim, 31, 2) & StringMid ($trim, 29, 2) & StringMid ($trim, 27, 2) & StringMid ($trim, 25, 2)) * 2 + 1
					$midSub = _DecryptCLSID($tempFD, $mid)
					$ArraySearch = _ArraySearch($MediaSubType, $midSub, 0, 0, 0, 1, 1, 0)
					If @error Then
						$ArraySearch = ""
					Else
						$ArraySearch = " " & $MediaSubType[$ArraySearch][1]
					EndIf
					FileWriteLine($file,  "            " & $midSub & $ArraySearch)
					$trim = StringTrimLeft ($trim, 32)
				WEnd
			WEnd
			FileWriteLine($file, @CRLF & @CRLF)
		Else
			FileWriteLine($file, "    Soubor:   " & RegRead("HKCR64\CLSID\{" & _GUICtrlListView_GetItemText($ListVypis64, $j, 1) & "}\InprocServer32", ""))
			$tempMerit = RegRead("HKCR64\CLSID\{" & _GUICtrlListView_GetItemText($ListVypis64, $j, 1) & "}", "Merit")
			If @error Then
				$tempMerit = "00600800"
			Else
				$tempMerit = Hex(String($tempMerit))
			EndIf
			FileWriteLine($file, "    Merit:    " & $tempMerit)
			$trim = StringTrimLeft (RegRead("HKCR64\DirectShow\MediaObjects\" & _GUICtrlListView_GetItemText($ListVypis64, $j, 1), "InputTypes"), 2)
			$i = 0
			FileWriteLine($file, "    Pin 0 Input")
			While StringLen ($trim) > 0
				FileWriteLine($file,  "        Type " & $i)
				$midMajor = _DecryptCLSID($trim, 1)
				$ArraySearch = _ArraySearch($MediaMajorType, $midMajor, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaMajorType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midMajor & $ArraySearch)
				$midSub = _DecryptCLSID($trim, 33)
				$ArraySearch = _ArraySearch($MediaSubType, $midSub, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaSubType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midSub & $ArraySearch)
				$trim = StringTrimLeft ($trim, 64)
				$i = $i + 1
			WEnd
			$trim = StringTrimLeft (RegRead("HKCR64\DirectShow\MediaObjects\" & _GUICtrlListView_GetItemText($ListVypis64, $j, 1), "OutputTypes"), 2)
			$i = 0
			FileWriteLine($file, "    Pin 1 Output")
			While StringLen ($trim) > 0
				FileWriteLine($file,  "        Type " & $i)
				$midMajor = _DecryptCLSID($trim, 1)
				$ArraySearch = _ArraySearch($MediaMajorType, $midMajor, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaMajorType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midMajor & $ArraySearch)
				$midSub = _DecryptCLSID($trim, 33)
				$ArraySearch = _ArraySearch($MediaSubType, $midSub, 0, 0, 0, 1, 1, 0)
				If @error Then
					$ArraySearch = ""
				Else
					$ArraySearch = " " & $MediaSubType[$ArraySearch][1]
				EndIf
				FileWriteLine($file,  "            " & $midSub & $ArraySearch)
				$trim = StringTrimLeft ($trim, 64)
				$i = $i + 1
			WEnd
			FileWriteLine($file, @CRLF & @CRLF)
		EndIf
	Next
	FileWriteLine($file, "------------ Filtry (64-bit) ------------" & @CRLF & @CRLF)

	FileClose($file)
	ShellExecute("log.txt")
EndFunc   ;==>_VytvoritLog

Func _DecryptCLSID($tempFD, $mid)
	Return "{" & StringMid($tempFD, $mid + 6, 2) & StringMid($tempFD, $mid + 4, 2) & StringMid($tempFD, $mid + 2, 2) & StringMid($tempFD, $mid + 0, 2) & _
	"-" & StringMid($tempFD, $mid + 10, 2) & StringMid($tempFD, $mid + 8, 2) & "-" & StringMid($tempFD, $mid + 14, 2) & StringMid($tempFD, $mid + 12, 2) & _
	"-" & StringMid($tempFD, $mid + 16, 4) & "-" & StringMid($tempFD, $mid + 20, 12) & "}"
EndFunc   ;==>_DecryptCLSID

Func _ListSplitCombo()
	Local $string = "---Žádná akce---|---Smazat hodnotu v registru---|"
	For $i = 0 To _GUICtrlListView_GetItemCount($ListVypis) - 1
		If StringLeft(_GUICtrlListView_GetItemText($ListVypis, $i, 1), 1) = "{" Then $string &= _GUICtrlListView_GetItemText($ListVypis, $i) & "|"
	Next
	$string &= "Generate Still Video"
	GUICtrlSetData($ListSplitCombo, $string, "---Žádná akce---")
EndFunc   ;==>_ListSplitCombo

Func _ListSplitNastavit()
	Local $i, $string = "", $array[1][3]
	If StringLeft(GUICtrlRead ($ListSplitInput), 1) = "." And GUICtrlRead ($ListSplitInput) <> "." Then
		If GUICtrlRead ($ListSplitCombo) = "---Žádná akce---" Then
			$i = 0
		ElseIf GUICtrlRead ($ListSplitCombo) = "---Smazat hodnotu v registru---" Then
			RegDelete("HKCR\Media Type\Extensions\" & GUICtrlRead ($ListSplitInput), "Source Filter")
			RegEnumVal("HKCR\Media Type\Extensions\" & GUICtrlRead ($ListSplitInput), 1)
			If @error <> 0 Then RegDelete("HKCR\Media Type\Extensions\" & GUICtrlRead ($ListSplitInput))
			_GUICtrlListView_DeleteAllItems($ListSplit)
			_ParserSplitterArray("")
		ElseIf GUICtrlRead ($ListSplitCombo) = "Generate Still Video" Then
			RegWrite("HKCR\Media Type\Extensions\" & GUICtrlRead ($ListSplitInput), "Source Filter", "REG_SZ", "{7DF62B50-6843-11D2-9EEB-006008039E37}")
			_GUICtrlListView_DeleteAllItems($ListSplit)
			_ParserSplitterArray("")
		Else
			For $i = 0 To _GUICtrlListView_GetItemCount($ListVypis) - 1
				If GUICtrlRead ($ListSplitCombo) = _GUICtrlListView_GetItemText($ListVypis, $i) Then $string = _GUICtrlListView_GetItemText($ListVypis, $i, 1)
			Next
			If $string <> "" Then RegWrite("HKCR\Media Type\Extensions\" & GUICtrlRead ($ListSplitInput), "Source Filter", "REG_SZ", $string)
			_GUICtrlListView_DeleteAllItems($ListSplit)
			_ParserSplitterArray("")
		EndIf
	EndIf
EndFunc   ;==>_ListSplitNastavit