#cs
	
	Per Incluïr a PingT Complet
	
#ce

Func _Opcions()
	Opt("GuiOnEventMode", 0)
	$GUI_Opcions = GUICreate("Opcions", 220, 200, Default, Default, 12582912)
	
	GUICtrlCreateLabel("Temps d'espera de resposta del Ping (ms)", 5, 5, 145, 25)
	$goIn_PingWait = GUICtrlCreateInput(RegRead($REG_CONFIG, "PingWait"), 155, 5, 60, 25, 8193)
	GUICtrlCreateLabel("Temps de pausa (ms)", 5, 40, 145, 25)
	$goIn_PingPausa = GUICtrlCreateInput(RegRead($REG_CONFIG, "PingPausa"), 155, 40, 60, 25, 8193)
	GUICtrlCreateLabel("Avís de 'supera temps' (ms)", 5, 75, 145, 25)
	$goIn_PingAvis = GUICtrlCreateInput(RegRead($REG_CONFIG, "PingAvis"), 155, 75, 60, 25, 8193)
	GUICtrlCreateLabel("Situació del programa Radmin.exe", 5, 110, 190, 15)
	$goIn_RadminFile = GUICtrlCreateInput(RegRead($REG_CONFIG, "RadminFile"), 5, 125, 145, 20, 1152)
	$goCercaRadmin = GUICtrlCreateButton("C&ercar", 150, 125, 65, 20)
	
	GUICtrlSetTip($goIn_PingPausa, "Mínim 1000 ms")
	GUICtrlSetTip($goIn_PingWait, "Mínim 500 ms")
	GUICtrlSetTip($goIn_PingAvis, "Mínim 500 ms")
	
	GUICtrlSetFont($goIn_PingPausa, 12)
	GUICtrlSetFont($goIn_PingWait, 12)
	GUICtrlSetFont($goIn_PingAvis, 12)
	
	$goDacord = GUICtrlCreateButton("&Acceptar", 5, 170, 65, 25, 1)
	$goCancel = GUICtrlCreateButton("&Cancel", 150, 170, 65, 25)
	
	GUISetState(@SW_SHOW, $GUI_Opcions)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $goCancel
				ExitLoop
			Case $goCercaRadmin
				$rFile = RegRead($REG_CONFIG, "RadminFile")
				If $rFile = "" Then
					$dir = @ProgramFilesDir
				Else
					$dir = $rFile
				EndIf
				$Radmin = FileOpenDialog("Buscant el Radmin", $dir, "Radmin Executable (Radmin.exe)", 3, "Radmin.exe")
				If Not @error Then
					RegWrite($REG_CONFIG, "RadminFile", "REG_SZ", $Radmin)
					RegWrite($REG_CONFIG, "ActivarRadmin", "REG_DWORD", 1)
					GUICtrlSetData($goIn_RadminFile, $Radmin)
					GUICtrlSetState($gcM_E_R_Des, $GUI_UNCHECKED)
					GUICtrlSetState($gcM_E_R_Act, $GUI_CHECKED)
				Else
					GUICtrlSetState($gcM_E_R_Des, $GUI_CHECKED)
					GUICtrlSetState($gcM_E_R_Act, $GUI_UNCHECKED)
					RegWrite($REG_CONFIG, "ActivarRadmin", "REG_DWORD", 0)
				EndIf
			Case $goDacord
				If RegRead($REG_CONFIG, "PingWait") <> GUICtrlRead($goIn_PingWait) Then
					If GUICtrlRead($goIn_PingWait) < 500 Then
						GUICtrlSetData($goIn_PingWait, 500)
					EndIf
					RegWrite($REG_CONFIG, "PingWait", "REG_DWORD", GUICtrlRead($goIn_PingWait))
				EndIf
				If RegRead($REG_CONFIG, "PingPausa") <> GUICtrlRead($goIn_PingPausa) Then
					If GUICtrlRead($goIn_PingPausa) < 1000 Then
						GUICtrlSetData($goIn_PingPausa, 1000)
					EndIf
					RegWrite($REG_CONFIG, "PingPausa", "REG_DWORD", GUICtrlRead($goIn_PingPausa))
				EndIf
				If RegRead($REG_CONFIG, "PingAvis") <> GUICtrlRead($goIn_PingAvis) Then
					If GUICtrlRead($goIn_PingAvis) < 500 Then
						GUICtrlSetData($goIn_PingAvis, 500)
					EndIf
					RegWrite($REG_CONFIG, "PingAvis", "REG_DWORD", GUICtrlRead($goIn_PingAvis))
				EndIf
				If RegRead($REG_CONFIG, "RadminFile") <> GUICtrlRead($goIn_RadminFile) Then
					RegWrite($REG_CONFIG, "RadminFile", "REG_SZ", GUICtrlRead($goIn_RadminFile))
				EndIf
				ExitLoop
		EndSwitch
		Sleep(10)
	WEnd
	$exitloop = 0
	GUIDelete($GUI_Opcions)
	_ReduceMemory()
	Opt("GuiOnEventMode", 1)
EndFunc   ;==>_Opcions

Func _Programacio()
	Opt("GuiOnEventMode", 0)
	$GUI_Programacio = GUICreate("Carregar Programacions", 450, 200, Default, Default, 12582912, 8, $GUI_Complet)
	
	$gpList = GUICtrlCreateListView("IP|Hora Inici|Hora Fi|Diari", 5, 5, 440, 150, 24, 33)
	_GUICtrlListView_SetColumnWidth($gpList, 0, 115)
	_GUICtrlListView_SetColumn($gpList, 1, _Text(1, $gpList), 65, 2)
	_GUICtrlListView_SetColumn($gpList, 2, _Text(2, $gpList), 55, 2)
	_GUICtrlListView_SetColumn($gpList, 3, _Text(3, $gpList), 50, 2)
	$hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gpList, 0x0000FF, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gpList, 0x00FF00, 16, 16))
	_GUICtrlListView_SetImageList($gpList, $hImage, 1)
	For $i = 1 To 100
		$key = RegEnumKey($REG_PROGRAMACIO, $i)
		If @error <> 0 Then ExitLoop
		_Valors_Programacio($key)
		GUICtrlCreateListViewItem($val[0] & "|" & $val[2] & "|" & $val[3] & "|" & $val[5], $gpList)
		_GUICtrlListView_SetItemImage($gpList, $i - 1, 0)
	Next
	
	$Car_Carregar = GUICtrlCreateButton("Carre&gar", 5, 170, 60, 25)
	$Car_SelTot = GUICtrlCreateButton("&Seleccionar Tot", 75, 170, 80, 25)
	$Car_cancel = GUICtrlCreateButton("&Cancel·lar", 385, 170, 60, 25, 1)
	
	GUICtrlSetTip($gpList, "Utilitza les tecles 'CTRL' i 'SHIFT' per seleccionar vàries configuracions.")
	
	GUISetState(@SW_SHOW, $GUI_Programacio)
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $Car_SelTot
				For $i = 0 To _GUICtrlListView_GetItemCount($gpList)
					_GUICtrlListView_SetItemSelected($gpList, $i)
				Next
			Case $msg = $Car_cancel Or $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $Car_Carregar
				$aCount = _GUICtrlListView_GetSelectedCount($gpList)
				If $aCount > 0 Then
					$llista = _GUICtrlListView_GetSelectedIndices($gpList, True)
					If $llista[0] <> 0 Then
						$aColumn = _GUICtrlListView_GetColumn($gcList, $gcList_C_HI)
						If $aColumn[5] <> "Hora Inici" Then
							$gcList_C_HI = _GUICtrlListView_AddColumn($gcList, "Hora Inici", 50, 2)
						EndIf
						$aColumn = _GUICtrlListView_GetColumn($gcList, $gcList_C_HF)
						If $aColumn[5] <> "Hora Fi" Then
							$gcList_C_HF = _GUICtrlListView_AddColumn($gcList, "Hora Fi", 50, 2)
						EndIf
						For $i = 1 To ($llista[0])
							If _GUICtrlListView_GetItemImage($gpList, $llista[$i]) = 0 Then
								$aCarregar = _GUICtrlListView_GetItemTextArray($gpList, $llista[$i])
								GUICtrlCreateListViewItem("|" & $aCarregar[1] & "|||" & $aCarregar[2] & "|" & $aCarregar[3], $gcList)
								$iIndex = _GUICtrlListView_FindInText($gcList, $aCarregar[1])
								_GUICtrlListView_SetItemImage($gcList, $iIndex, 2)
								_GUICtrlListView_SetItemChecked($gcList, $iIndex)
							EndIf
						Next
						ExitLoop
					EndIf
				Else
					MsgBox(48, "Cap programació carregada", "No has seleccionat cap programació antiga, no es pot carregar.", Default, $GUI_Programacio)
				EndIf
		EndSelect
		Sleep(10)	
	WEnd
	Opt("GuiOnEventMode", 1)
	_ReduceMemory()
	GUIDelete($GUI_Programacio)
EndFunc   ;==>_Programacio

Func _GuiComplet()
	Local $hmod
	
	$hStub_KeyProc = DllCallbackRegister("_KeyProc", "long", "int;wparam;lparam")
	$hmod = _WinAPI_GetModuleHandle(0)
	$hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hStub_KeyProc), $hmod)
	
	$GUI_Complet = GUICreate("PingT Complet v" & FileGetVersion(@ScriptFullPath), 500, 400, -1, -1, -2133917696)
	
	$gcM_Eines = GUICtrlCreateMenu("&Eines")
		$gcM_E_Start = GUICtrlCreateMenuItem("Co&mençar" & @TAB & "F5", $gcM_Eines)
		$gcM_E_Stop = GUICtrlCreateMenuItem("P&arar" & @TAB & "F6", $gcM_Eines)
		GUICtrlSetState($gcM_E_Stop, $GUI_DISABLE)
		$gcM_E_Borrar = GUICtrlCreateMenuItem("Borrar &Tot", $gcM_Eines)
		GUICtrlCreateMenuItem("", $gcM_Eines)
		$gcM_E_Bot = GUICtrlCreateMenuItem("&Carregar IP botigues", $gcM_Eines)
		$gcM_E_Prog = GUICtrlCreateMenuItem("&Programacio", $gcM_Eines)
		GUICtrlCreateMenuItem("", $gcM_Eines)
		$gcM_E_Opc = GUICtrlCreateMenuItem("&Opcions" & @TAB & "Ctrl+O", $gcM_Eines)
		$gcM_E_Radmin = GUICtrlCreateMenuItem("&Radmin", $gcM_Eines)
	$gcM_Log = GUICtrlCreateMenu("&Log")
		$gcM_L_Del = GUICtrlCreateMenuItem("&Eliminar", $gcM_Log)
		$gcM_L_Obrir = GUICtrlCreateMenuItem("&Obrir", $gcM_Log)
		GUICtrlCreateMenuItem("", $gcM_Log)
		$gcM_L_Visor = GUICtrlCreateMenuItem("&Visor de LOG", $gcM_Log)
		$gcM_L_oVisor = GUICtrlCreateMenu("O&pcions", $gcM_Log)
			$gcM_L_oV_Del = GUICtrlCreateMenuItem("&Eliminar el LOG al iniciar el Visor", $gcM_L_oVisor)
	$gcM_Radmin = GUICtrlCreateMenu("&Radmin", -1)
		$gcM_R_CTotal = GUICtrlCreateMenuItem("&Control Total", $gcM_Radmin, 0, 1)
		$gcM_R_SVista = GUICtrlCreateMenuItem("&Només Vista", $gcM_Radmin, 1, 1)
		$gcM_R_File = GUICtrlCreateMenuItem("&Fitxer", $gcM_Radmin, 2, 1)
	$gcM_Sortir = GUICtrlCreateMenuItem("&Sortir", -1)
	$gcM_Format = GUICtrlCreateMenu("&Format", -1)
		$gcM_F_PingT = GUICtrlCreateMenuItem("&PingT" & @TAB & "F11", $gcM_Format)
		$gcM_F_Fitxers = GUICtrlCreateMenuItem("&Envio Fitxers", $gcM_Format)
		If @LogonDomain <> "FAMILA" Then
			GUICtrlSetState($gcM_F_Fitxers, $GUI_DISABLE)
		EndIf

	If RegRead($REG_CONFIG, "ActivarRadmin") = 1 Then
		GUICtrlSetState($gcM_E_Radmin, $GUI_CHECKED)
		GUICtrlSetState($gcM_Radmin, $GUI_ENABLE)
	Else
		GUICtrlSetState($gcM_E_Radmin, $GUI_UNCHECKED)
		GUICtrlSetState($gcM_Radmin, $GUI_DISABLE)
	EndIf
	If RegRead($REG_CONFIG, "DelVisorLog") = 1 Then GUICtrlSetState($gcM_L_oV_Del, $GUI_CHECKED)
	If Not FileExists($LOG_File) Then 
		GUICtrlSetState($gcM_L_Del, $GUI_DISABLE)
		GUICtrlSetState($gcM_L_Obrir, $GUI_DISABLE)
	EndIf
	If RegRead($REG_CONFIG, "ActivarVisorLog") = 1 Then
		GUICtrlSetState($gcM_L_Visor, $GUI_CHECKED)
	Else
		GUICtrlSetState($gcM_L_oVisor, $GUI_DISABLE)
	EndIf
	Switch RegRead($REG_CONFIG, "VistaRadmin")
		Case 1
			GUICtrlSetState($gcM_R_SVista, $GUI_CHECKED)
		Case 2
			GUICtrlSetState($gcM_R_File, $GUI_CHECKED)
		Case Else
			GUICtrlSetState($gcM_R_CTotal, $GUI_CHECKED)
			RegWrite($REG_CONFIG, "VistaRadmin", "REG_DWORD", 0)
	EndSwitch
	
	Local $aParts[5] = [200, 370, 440, 500, -1]
	$gcStatus = _GUICtrlStatusBar_Create($GUI_Complet, $aParts)
	
	$gcIPAdress = _GUICtrlIpAddress_Create($GUI_Complet, 5, 15, 100, 20)
	$gcAfegir = GUICtrlCreateButton("+", 110, 5, 40, 40, 65)
	$gcTreure = GUICtrlCreateButton("-", 150, 5, 40, 40, 64)
	GUICtrlCreateLabel("Nom del PC:", 190, 18, 75, 20, 2)
	GUICtrlSetResizing(-1, 802)
	$gcHost = GUICtrlCreateInput("", 280, 15, 100, 20, BitOR(-1, 1))
	$gcHosttoIP = GUICtrlCreateButton("IP", 380, 5, 60, 40)
	
	$gcS_List = GUICtrlCreateCombo("", 300, 5, 125, 20, 2097475)
	If @LogonDomain = "FAMILA" Then
		For $i = 1 To $CodiNom[0][0]
			GUICtrlSetData($gcS_List, $CodiNom[$i][0] & " - " & $CodiNom[$i][1])
		Next
	Else
		GUICtrlSetState($gcS_List, $GUI_DISABLE)
	EndIf
	$gcS_In = GUICtrlCreateInput("", 300, 25, 125, 20, 1)
	$gcSearch = GUICtrlCreateButton("Buscar", 430, 5, 65, 40, 64)
	
	$gcList = GUICtrlCreateListView("|IP|Resposta|Error", 5, 50, 490, 270, 32808, 39)
	_GUICtrlListView_SetColumnWidth($gcList, 0, 40)
	_GUICtrlListView_SetColumnWidth($gcList, 1, 100)
	_GUICtrlListView_SetColumnWidth($gcList, 3, 100)
	$hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gcList, 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gcList, 0xFF7000, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gcList, 0x0000FF, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gcList, 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gcList, 0xFFFFFF, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($gcList, 0x000000, 16, 16))
	_GUICtrlListView_SetImageList($gcList, $hImage, 1)

	$gcList_Menu = GUICtrlCreateContextMenu($gcList)
	$gcL_M_exeRadmin = GUICtrlCreateMenuItem("&Executar Radmin" & @TAB & "Shift+Enter", $gcList_Menu)
	
	$gcProgress = GUICtrlCreateProgress(150, 325, 255, 25)
	GUICtrlSetTip($gcProgress, "Es carrega només amb els Ping's que surten bé.")
	
	$gcStart = GUICtrlCreateButton("&Començar", 5, 325, 75, 25)
	$gcStop = GUICtrlCreateButton("&Parar", 80, 325, 65, 25)
	$gcBorrar = GUICtrlCreateButton("&Borrar Tot", 410, 325, 85, 25)
	
	GUICtrlSetFont($gcS_In, 10)
	GUICtrlSetImage($gcStart, @ScriptFullPath, -6, 0)
	GUICtrlSetImage($gcStop, @ScriptFullPath, -5, 0)
	GUICtrlSetImage($gcBorrar, @ScriptFullPath, -11, 0)
	GUICtrlSetImage($gcAfegir, @ScriptFullPath, -8)
	GUICtrlSetImage($gcTreure, @ScriptFullPath, -9)
	GUICtrlSetImage($gcHosttoIP, @ScriptFullPath, -7)
	GUICtrlSetImage($gcSearch, @ScriptFullPath, -12)
	GUICtrlSetState($gcStop, $GUI_DISABLE)
	GUICtrlSetState($gcProgress, $GUI_HIDE)
	GUICtrlSetResizing($gcList, 102)
	GUICtrlSetResizing($gcAfegir, 802)
	GUICtrlSetResizing($gcTreure, 802)
	GUICtrlSetResizing($gcHost, 802)
	GUICtrlSetResizing($gcHosttoIP, 802)
	GUICtrlSetResizing($gcStart, 834)
	GUICtrlSetResizing($gcStop, 834)
	GUICtrlSetResizing($gcProgress, 582)
	GUICtrlSetResizing($gcBorrar, 836)
	GUICtrlSetResizing($gcSearch, 804)
	GUICtrlSetResizing($gcS_In, 804)
	GUICtrlSetResizing($gcS_List, 804)

	GUICtrlSetOnEvent($gcStop, "_Window")
	GUICtrlSetOnEvent($gcStart, "_Window")
	GUICtrlSetOnEvent($gcM_Sortir, "_Window")
	GUICtrlSetOnEvent($gcAfegir, "_Window")
	GUICtrlSetOnEvent($gcTreure, "_Window")
	GUICtrlSetOnEvent($gcM_E_Start, "_Window")
	GUICtrlSetOnEvent($gcM_E_Stop, "_Window")
	GUICtrlSetOnEvent($gcM_E_Borrar, "_Window")
	GUICtrlSetOnEvent($gcM_E_Bot, "_Window")
	GUICtrlSetOnEvent($gcM_E_Opc, "_Window")
	GUICtrlSetOnEvent($gcM_E_Prog, "_Window")
	GUICtrlSetOnEvent($gcM_E_Radmin, "_Window")
	GUICtrlSetOnEvent($gcM_R_CTotal, "_Window")
	GUICtrlSetOnEvent($gcM_R_SVista, "_Window")
	GUICtrlSetOnEvent($gcM_R_File, "_Window")
	GUICtrlSetOnEvent($gcM_F_PingT, "_Window")
	GUICtrlSetOnEvent($gcM_F_Fitxers, "_Window")
	GUICtrlSetOnEvent($gcM_L_Del, "_Window")
	GUICtrlSetOnEvent($gcM_L_Obrir, "_Window")
	GUICtrlSetOnEvent($gcM_L_Visor, "_Window")
	GUICtrlSetOnEvent($gcM_L_oV_Del, "_Window")
	GUICtrlSetOnEvent($gcHosttoIP, "_Window")
	GUICtrlSetOnEvent($gcBorrar, "_Window")
	GUICtrlSetOnEvent($gcL_M_exeRadmin, "_ExeRadmin")
	GUICtrlSetOnEvent($gcSearch, "_Window")
	GUICtrlSetOnEvent($gcS_List, "_Window")
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Window", $GUI_Complet)
	GUISetOnEvent($GUI_EVENT_MAXIMIZE, "_Window", $GUI_Complet)
	GUISetOnEvent($GUI_EVENT_RESTORE, "_Window", $GUI_Complet)
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "_Window", $GUI_Complet)

	GUIRegisterMsg(78, "WM_Notify_Events")
	GUIRegisterMsg(5, "WM_SIZE")
	
	If @LogonDomain = "FAMILA" Then
		_CarregaLlista()
		GUISetState(@SW_SHOW, $GUI_Complet)
		GUISetState(@SW_MAXIMIZE, $GUI_Complet)
		GUICtrlSetState($gcS_In, $GUI_FOCUS)
		GUICtrlSetState($gcSearch, $GUI_DEFBUTTON)
	Else
		GUICtrlSetState($gcM_E_Bot, $GUI_DISABLE)
		GUISetState(@SW_SHOW, $GUI_Complet)
	EndIf
	_ReduceMemory()
	While 1
		Sleep(10)
	WEnd
	GUIDelete()
EndFunc   ;==>_GuiComplet

Func _GuiLog()
	$exitlog = 0
	$GUI_Log = GUICreate("Lector de LOG", 500, 400)
	
	$log = GUICtrlCreateEdit("", 5, 5, 490, 390, BitOR(-1, 196))
	
	GUISetOnEvent($GUI_EVENT_CLOSE, "_FuncGuiLog", $GUI_Log)
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "_FuncGuiLog", $GUI_Log)
	
	GUISetState(@SW_SHOW, $GUI_Log)
EndFunc
