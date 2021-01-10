#cs
	
	Per Incluïr a PingT Complet
	
#ce

#include <GuiConstants.au3>
#include <GuiListView.au3>
;~ #include "Menu\ModernMenuRaw.au3"

Global $GUI_Complet, $gcM_Sortir, $gcList, $gc_c_name, $gcL_M_Botiga, $gcL_M_Tots, $gcL_M_DSL, $gcL_M_RDSI, $gcL_M_Serv, $gcL_M_TPV, $gcL_M_CZ, $gcL_M_Pass, $gcAfegir, $gcIPAdress, $gcTreure, _
		$gcM_E_Bot, $gcM_E_Opc, $gcM_E_Prog, $gcBorrar, $gcList_C_UltErr, $gcList_C_Estat, $gcList_C_TaDiu, $gcList_C_ObDiu, $gcM_E_R_Act, $gcM_E_R_Des, $llista_Valvi, $stop = 1, $ADSL, $RDSI, _
		$val[6], $gcStart, $gcStop, $gcM_Radmin, $gcM_R_CTotal, $gcM_R_SVista, $gcM_R_File, $Tancada, $Activa, $gcList_C_HF, $gcList_C_HI, $gcList_Menu, $gcM_F_PingT, $InstallDir, _
		$Separador1, $Separador2, $GUI_Programacio, $gpList, $idGroup[1], $gcHost, $gcHosttoIP, $gcM_E_Borrar, $gcM_E_Radmin, $gcM_E_Start, $gcM_E_Stop, $gcM_L_Del, $gcM_L_Obrir, _
		$gcM_F_Fitxers, $gcList_C_Dir, $gcList_C_Temps, $gcFile, $gcF_Buscar, $gcF_Serv, $gcF_TPV, $gcF_DirEnv, $gcF_Lab, $Enviament_de_Fitxers = 0, $gcM_EnvFit, $gcM_EF_Sobr, $gcM_EF_Backup, _
		$gcM_EF_CrearDir, $gcM_EF_Attrib, $z, $valor[1000], $1 = "", $2 = "", $3 = "", $4 = "", $5 = "", $10 = "", $ToolCount, $gcM_Log, $gcStatus, $iChecked, $rChecked, $sImage, $cHour, $cMins, $cSecs, _
		$Options = 0, $gcProgress, $tTimer, $gcM_EF_Zip, $Zipped = 0, $gcM_L_Visor, $GUI_Log, $exitlog = 0, $log, $closed, $gcSearch, $gcS_In, $gcM_L_oV_Del, $gcM_L_oVisor, $gcS_List, $lSearch, _
		$hHook, $hStub_KeyProc

Global $REGISTRE = "HKLM\SOFTWARE\TaliSoft\PingT Complet", $REG_CONFIG = $REGISTRE & "\Configuracio", $REG_PROGRAMACIO = "HKLM\SOFTWARE\TaliSoft\PingT\Configuracio\Prog_Antiga", _
		$REG_UERROR = $REGISTRE & "\UltimError", $InstallDir = @ProgramFilesDir & "\TaliSoft\PingT", $PATH = @ProgramFilesDir & "\TaliSoft\PingT\Bin", $LOG_File = $InstallDir & "\LOG PTC\PingT Complet.log"

Func _ObrePingT()
	If FileExists($InstallDir & "\PingT.exe") Then
		Run($InstallDir & "\PingT.exe", $InstallDir)
	Else
		MsgBox(48, "El Fitxer no existeix", "El fitxer PingT.exe no existeix o no s'ha trobat en el directori " & $InstallDir)
	EndIf
	Exit
EndFunc   ;==>_ObrePingT

Func _FuncGuiLog()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			GUIDelete($GUI_Log)
			$closed = 1
			
		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_MINIMIZE, $GUI_Log)
		
	EndSwitch
EndFunc

Func _Window()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $gcM_Sortir
			Exit
		Case $GUI_EVENT_MAXIMIZE
			GUISetState(@SW_MAXIMIZE, $GUI_Complet)
		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_MINIMIZE, $GUI_Complet)
		Case $GUI_EVENT_RESTORE
			If BitAND(WinGetState($GUI_Complet), 32) = 32 Then
				GUISetState(@SW_MAXIMIZE, $GUI_Complet)
			Else
				GUISetState(@SW_RESTORE, $GUI_Complet)
			EndIf
		Case $gcM_F_PingT
			If $stop = 1 Then _ObrePingT()
		Case $gcL_M_Pass To $gcL_M_Tots
			_MarcarDesmarcar(@GUI_CtrlId)
		Case $gcAfegir
			If _GUICtrlIpAddress_IsBlank($gcIPAdress) = False Then
				$AfegirIP = _GUICtrlIpAddress_Get($gcIPAdress)
				GUICtrlCreateListViewItem("|" & $AfegirIP, $gcList)
				_GUICtrlListView_SetItemImage($gcList, _GUICtrlListView_FindInText($gcList, $AfegirIP), 2)
				_GUICtrlListView_SetItemChecked($gcList, _GUICtrlListView_FindInText($gcList, $AfegirIP), True)
				_GUICtrlIpAddress_ClearAddress($gcIPAdress)
			EndIf
			_GUICtrlIpAddress_SetFocus($gcIPAdress, 0)
		Case $gcTreure
			If _GUICtrlIpAddress_IsBlank($gcIPAdress) = False Then
				$address = _GUICtrlIpAddress_Get($gcIPAdress)
				For $i = 0 To 100
					$iIndex = _GUICtrlListView_FindInText($gcList, $address, $i, False, True)
					If _GUICtrlListView_GetItemText($gcList, $iIndex, 1) = $address Then
						If _GUICtrlListView_DeleteItem($gcList, $iIndex) = True Then _GUICtrlIpAddress_ClearAddress($gcIPAdress)
						ExitLoop
					EndIf
				Next
			Else
				_GUICtrlListView_DeleteItemsSelected($gcList)
			EndIf
			If _GUICtrlListView_GetItemCount($gcList) = 0 Then
				_GUICtrlListView_DeleteColumn($gcList, $gc_c_name)
				_GUICtrlListView_DeleteColumn($gcList, $gcList_C_HF)
				_GUICtrlListView_DeleteColumn($gcList, $gcList_C_HI)
			EndIf
		Case $gcStart, $gcM_E_Start
			_Start(True)
		Case $gcStop, $gcM_E_Stop
			_Stop(True)
		Case $gcM_E_Bot
			_CarregaLlista()
		Case $gcM_E_Opc
			_Opcions()
		Case $gcM_E_Prog
			_Programacio()
		Case $gcSearch
			$lSearch = _Search($gcList, GUICtrlRead($gcS_In))
			If @error Then
				MsgBox(64, "Recerca", "No s'ha trobat '" & $lSearch & "' a la llista.", 2, $GUI_Complet)
			EndIf
			GUICtrlSetState($gcS_In, $GUI_FOCUS)
			
		Case $gcS_List
			$lSearch = _Search($gcList, StringLeft(GUICtrlRead($gcS_List), 3))
			If @error Then
				MsgBox(64, "Recerca", "No s'ha trobat '" & $lSearch & "' a la llista.", 2, $GUI_Complet)
			EndIf
;~ 			GUICtrlSetState($gcS_List, $GUI_FOCUS)
			
		Case $gcBorrar, $gcM_E_Borrar
			GUICtrlSetState($gcList, $GUI_HIDE)
			_GUICtrlListView_RemoveAllGroups($gcList)
			_GUICtrlListView_DeleteAllItems($gcList)
			GUICtrlSetState($gcList, $GUI_SHOW)
			_GUICtrlListView_EnableGroupView($gcList, False)
			_GUICtrlListView_DeleteColumn($gcList, $gcList_C_UltErr)
			_GUICtrlListView_DeleteColumn($gcList, $gcList_C_Estat)
			_GUICtrlListView_DeleteColumn($gcList, $gcList_C_TaDiu)
			_GUICtrlListView_DeleteColumn($gcList, $gcList_C_ObDiu)
			_GUICtrlListView_DeleteColumn($gcList, $gcList_C_HF)
			_GUICtrlListView_DeleteColumn($gcList, $gcList_C_HI)
			_GUICtrlListView_DeleteColumn($gcList, $gc_c_name)
			GUICtrlSetState($gcS_List, $GUI_DISABLE)
			GUICtrlDelete($gcL_M_Tots)
			GUICtrlDelete($gcL_M_CZ)
			GUICtrlDelete($gcL_M_Serv)
			GUICtrlDelete($gcL_M_DSL)
			GUICtrlDelete($gcL_M_RDSI)
			GUICtrlDelete($gcL_M_Botiga)
			GUICtrlDelete($gcL_M_Pass)
			GUICtrlDelete($gcL_M_TPV)
			GUICtrlDelete($Separador1)
			GUICtrlSetData($gcS_In, "")
			If BitAND(GUICtrlGetState($gcAfegir), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($gcAfegir, $GUI_ENABLE)
			If BitAND(GUICtrlGetState($gcTreure), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($gcTreure, $GUI_ENABLE)
			If BitAND(GUICtrlGetState($gcHost), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($gcHost, $GUI_ENABLE)
			If BitAND(GUICtrlGetState($gcHosttoIP), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($gcHosttoIP, $GUI_ENABLE)
			If BitAND(GUICtrlGetState($gcM_E_Prog), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($gcM_E_Prog, $GUI_ENABLE)
			If BitAND(GUICtrlRead($gcM_F_Fitxers), $GUI_CHECKED) = $GUI_CHECKED Then _EnviamentFitxers(False)
			GUICtrlSetState($gcAfegir, $GUI_DEFBUTTON)
			_GUICtrlIpAddress_SetFocus($gcIPAdress, 0)
			$llista_Valvi = 0
			If @LogonDomain = "FAMILA" Then
				If BitAND(GUICtrlGetState($gcM_E_Bot), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($gcM_E_Bot, $GUI_ENABLE)
			EndIf
		Case $gcM_E_Radmin
			If BitAND(GUICtrlRead($gcM_E_Radmin), $GUI_UNCHECKED) Then
				$rFile = RegRead($REG_CONFIG, "RadminFile")
				If $rFile = "" Or Not FileExists(RegRead($REG_CONFIG, "RadminFile")) Then
					If $rFile = "" Then
						$dir = @ProgramFilesDir
					Else
						$dir = $rFile
					EndIf
					$Radmin = FileOpenDialog("Buscant el Radmin", $dir, "Radmin Executable (Radmin.exe)", 3, "Radmin.exe")
					If Not @error Then
						RegWrite($REG_CONFIG, "RadminFile", "REG_SZ", $Radmin)
						RegWrite($REG_CONFIG, "ActivarRadmin", "REG_DWORD", 1)
						GUICtrlSetState($gcM_Radmin, $GUI_ENABLE)
					Else
						GUICtrlSetState($gcM_E_R_Des, $GUI_CHECKED)
						GUICtrlSetState($gcM_E_R_Act, $GUI_UNCHECKED)
						GUICtrlSetState($gcM_Radmin, $GUI_DISABLE)
					EndIf
				Else
					RegWrite($REG_CONFIG, "ActivarRadmin", "REG_DWORD", 1)
					GUICtrlSetState($gcM_Radmin, $GUI_ENABLE)
				EndIf
				GUICtrlSetState($gcM_E_Radmin, $GUI_CHECKED)
			Else
				RegWrite($REG_CONFIG, "ActivarRadmin", "REG_DWORD", 0)
				GUICtrlSetState($gcM_Radmin, $GUI_DISABLE)
				GUICtrlSetState($gcM_E_Radmin, $GUI_UNCHECKED)
			EndIf
			
		Case $gcM_R_CTotal
			RegWrite($REG_CONFIG, "VistaRadmin", "REG_DWORD", 0)
			
		Case $gcM_R_SVista
			RegWrite($REG_CONFIG, "VistaRadmin", "REG_DWORD", 1)
			
		Case $gcM_R_File
			RegWrite($REG_CONFIG, "VistaRadmin", "REG_DWORD", 2)
			
		Case $gcM_L_Del
			If FileExists($LOG_File) Then
				If MsgBox(68, "Eliminar el LOG?", "Vols eliminar el LOG?", -1, $GUI_Complet) = 6 Then 
					FileDelete($LOG_File)
					GUICtrlSetState($gcM_L_Del, $GUI_DISABLE)
					GUICtrlSetState($gcM_L_Obrir, $GUI_DISABLE)
				EndIf
			EndIf

		Case $gcM_L_Obrir
			If FileExists($LOG_File) Then ShellExecute($LOG_File)
			
		Case $gcM_L_Visor
			If BitAND(GUICtrlRead($gcM_L_Visor), $GUI_UNCHECKED) Then
				RegWrite($REG_CONFIG, "ActivarVisorLog", "REG_DWORD", 1)
				GUICtrlSetState($gcM_L_Visor, $GUI_CHECKED)
				GUICtrlSetState($gcM_L_oVisor, $GUI_ENABLE)
			Else
				RegWrite($REG_CONFIG, "ActivarVisorLog", "REG_DWORD", 0)
				GUICtrlSetState($gcM_L_Visor, $GUI_UNCHECKED)
				GUICtrlSetState($gcM_L_oVisor, $GUI_DISABLE)
			EndIf
			
		Case $gcM_L_oV_Del
			If BitAND(GUICtrlRead($gcM_L_oV_Del), $GUI_UNCHECKED) Then
				RegWrite($REG_CONFIG, "DelVisorLog", "REG_DWORD", 1)
				GUICtrlSetState($gcM_L_oV_Del, $GUI_CHECKED)
			Else
				RegWrite($REG_CONFIG, "DelVisorLog", "REG_DWORD", 0)
				GUICtrlSetState($gcM_L_oV_Del, $GUI_UNCHECKED)
			EndIf
			
		Case $gcM_F_Fitxers
			If BitAND(GUICtrlRead($gcM_F_Fitxers), $GUI_CHECKED) Then
				$Enviament_de_Fitxers = _EnviamentFitxers(False)
			Else
				$Enviament_de_Fitxers = _EnviamentFitxers(True)
			EndIf
			
		Case $gcF_Serv
			If BitAND(GUICtrlRead($gcF_Serv), $GUI_CHECKED) = $GUI_CHECKED Then
				If GUICtrlRead($gcFile) <> "" Then
					$NUM = _GUICtrlListView_GetItemCount($gcList)
					For $i = 0 To $NUM
						If StringLeft(_GUICtrlListView_GetItemText($gcList, $i, 4), 3) = "S: " Then
							$File = GUICtrlRead($gcFile)
							$fLen = StringLen($File)
							$File = StringSplit($File, "\")
							$File = $File[$File[0]]
							$fDir = GUICtrlRead($gcF_DirEnv)
							$fDir = "\\" & _GUICtrlListView_GetItemText($gcList, $i, 1) & "\c" & $fDir & "\" & $File
							_GUICtrlListView_SetItemText($gcList, $i, $fDir, $gcList_C_Dir)
							_GUICtrlListView_SetItemText($gcList, $i, "", $gcList_C_Temps)
							_GUICtrlListView_SetItemImage($gcList, $i, 2)
						EndIf
					Next
					_MarcarDesmarcar($gcL_M_Serv, "", GUICtrlRead($gcF_Serv))
				Else
					GUICtrlSetState($gcF_Serv, $GUI_UNCHECKED)
					If $ToolCount = 0 Then
						$cPos = ControlGetPos($GUI_Complet, "", $gcFile)
						$wPos = WinGetPos($GUI_Complet)
						$X = $wPos[0] + $cPos[0]
						$Y = $wPos[1] + $cPos[1] + 70
						ToolTip("No hi ha cap Fitxer per copiar", $X, $Y)
						$ToolCount = 1
					Else
						ToolTip("")
						$ToolCount = 0
					EndIf
				EndIf
			Else
				$NUM = _GUICtrlListView_GetItemCount($gcList)
				For $i = 0 To $NUM
					If StringLeft(_GUICtrlListView_GetItemText($gcList, $i, 4), 3) = "S: " Then
						_GUICtrlListView_SetItem($gcList, "", $i, $gcList_C_Dir, 4)
					EndIf
				Next
				_MarcarDesmarcar($gcL_M_Serv, "", GUICtrlRead($gcF_Serv))
			EndIf
			
		Case $gcF_TPV
			If BitAND(GUICtrlRead($gcF_TPV), $GUI_CHECKED) = $GUI_CHECKED Then
				If GUICtrlRead($gcFile) <> "" Then
					$NUM = _GUICtrlListView_GetItemCount($gcList)
					For $i = 0 To $NUM
						If StringInStr(_GUICtrlListView_GetItemText($gcList, $i, 4), "Caixa") <> 0 Then
							$File = GUICtrlRead($gcFile)
							$fLen = StringLen($File)
							$File = StringSplit($File, "\")
							$File = $File[$File[0]]
							$fDir = GUICtrlRead($gcF_DirEnv)
							$fDir = "\\" & _GUICtrlListView_GetItemText($gcList, $i, 1) & "\c" & $fDir & "\" & $File
							_GUICtrlListView_SetItemText($gcList, $i, $fDir, $gcList_C_Dir)
							_GUICtrlListView_SetItemText($gcList, $i, "", $gcList_C_Temps)
							_GUICtrlListView_SetItemImage($gcList, $i, 2)
						EndIf
					Next
					_MarcarDesmarcar($gcL_M_TPV, "", GUICtrlRead($gcF_TPV))
				Else
					GUICtrlSetState($gcF_TPV, $GUI_UNCHECKED)
					If $ToolCount = 0 Then
						$cPos = ControlGetPos($GUI_Complet, "", $gcFile)
						$wPos = WinGetPos($GUI_Complet)
						$X = $wPos[0] + $cPos[0]
						$Y = $wPos[1] + $cPos[1] + 70
						ToolTip("No hi ha cap Fitxer per copiar", $X, $Y)
						$ToolCount = 1
					Else
						ToolTip("")
						$ToolCount = 0
					EndIf
				EndIf
			Else
				$NUM = _GUICtrlListView_GetItemCount($gcList)
				For $i = 0 To $NUM
					If StringInStr(_GUICtrlListView_GetItemText($gcList, $i, 4), "Caixa") <> 0 Then
						_GUICtrlListView_SetItemText($gcList, $i, "", $gcList_C_Dir)
					EndIf
				Next
				_MarcarDesmarcar($gcL_M_TPV, "", GUICtrlRead($gcF_TPV))
			EndIf
			
		Case $gcF_Buscar
			ToolTip("")
			$File = FileOpenDialog("Fitxer per enviar", @DesktopDir, "Tots (*.*)", 3, "", $GUI_Complet)
			If Not @error Then
				GUICtrlSetData($gcFile, $File)
				GUICtrlSetState($gcF_DirEnv, $GUI_FOCUS)
			EndIf
			
		Case $gcM_EF_Sobr To $gcM_EF_Zip
			_EF_Menu(@GUI_CtrlId, 0)
			
		Case $gcHosttoIP
			TCPStartup()
			$nti = TCPNameToIP(GUICtrlRead($gcHost))
			If Not @error Then
				_GUICtrlIpAddress_Set($gcIPAdress, $nti)
				GUICtrlSetData($gcHost, "")
			Else
				MsgBox(64, "Error", "S'ha produït l'error " & @error, 3, $GUI_Complet)
			EndIf
			TCPShutdown()
			
	EndSwitch
EndFunc   ;==>_Window

Func _Key()
	If BitAND(WinGetState($GUI_Complet), 8) Or BitAND(WinGetState("Lector de LOG"), 8) Then
		Switch @HotKeyPressed
			Case "^o"
				_Opcions()
				
			Case "+{ENTER}"
				_ExeRadmin()
				
			Case "^1" To "^8", "^+1" To "^+8"
				If $llista_Valvi = 1 Then
					Switch @HotKeyPressed
						Case "^1", "^+1"
							_MarcarDesmarcar($gcL_M_Tots)
						Case "^2", "^+2"
							_MarcarDesmarcar($gcL_M_Botiga)
						Case "^3", "^+3"
							_MarcarDesmarcar($gcL_M_DSL)
						Case "^4", "^+4"
							_MarcarDesmarcar($gcL_M_RDSI)
						Case "^5", "^+5"
							_MarcarDesmarcar($gcL_M_Serv)
						Case "^6", "^+6"
							_MarcarDesmarcar($gcL_M_TPV)
						Case "^7", "^+7"
							_MarcarDesmarcar($gcL_M_CZ)
						Case "^8", "^+8"
							_MarcarDesmarcar($gcL_M_Pass)
					EndSwitch
				EndIf
				
		EndSwitch
	EndIf
EndFunc   ;==>_Key

Func _Search($hWnd, $Find)
	Local $iFind, $result = $Find
	
	If $Find <> "" Then
		If StringLeft($Find, 1) = 8 And StringLen($Find) = 3 Then
			If StringInStr($Find, "0") = 2 Then
				$Find = "." & StringFormat("%1i", StringRight($Find, 2)) & "."
			Else
				$Find = "." & StringFormat("%2i", StringRight($Find, 2)) & "."
			EndIf
		EndIf
		If _GUICtrlListView_GetItemSelected($hWnd, $iFind) Then
			$start = $iFind
		Else
			$start = -1
		EndIf
		$iFind = _GUICtrlListView_FindInText($hWnd, $Find, $start)
		If $iFind <> -1 Then
			_GUICtrlListView_ClickItem($hWnd, $iFind)
			Return 1
		Else
			Return SetError(2, 0, $result)
		EndIf
	Else
		Return SetError(1, 0, $result)
	EndIf
EndFunc
			
Func _EnviamentFitxers($Activar)
	If $Activar = False Then
		GUICtrlSetState($gcM_F_Fitxers, $GUI_UNCHECKED)
		_GUICtrlListView_DeleteColumn($gcList, $gcList_C_Temps)
		_GUICtrlListView_DeleteColumn($gcList, $gcList_C_Dir)
		GUICtrlDelete($gcFile)
		GUICtrlDelete($gcF_Buscar)
		GUICtrlDelete($gcF_Serv)
		GUICtrlDelete($gcF_TPV)
		GUICtrlDelete($gcF_Lab)
		GUICtrlDelete($gcF_DirEnv)
		GUICtrlDelete($gcM_EnvFit)
		Return 0
	Else
		GUICtrlSetState($gcM_F_Fitxers, $GUI_CHECKED)
		$gcFile = GUICtrlCreateInput("", 460, 5, 150, 20, 3200)
		$gcF_Lab = GUICtrlCreateLabel("Dir envío", 460, 28, 60, 17)
		$gcF_DirEnv = GUICtrlCreateInput("", 520, 25, 90, 20, 1152)
		$gcF_Buscar = GUICtrlCreateButton("E&xaminar", 610, 5, 100, 40)
		$gcF_Serv = GUICtrlCreateCheckbox("Aplicar als &Servidors", 715, 10, 120, 15)
		$gcF_TPV = GUICtrlCreateCheckbox("Aplicar a les C&aixes", 715, 25, 120, 15)
		$gcM_EnvFit = GUICtrlCreateMenu("Opcions En&viament", -1)
		$gcM_EF_Sobr = GUICtrlCreateMenuItem("&Sobreescriptura", $gcM_EnvFit)
		$gcM_EF_Backup = GUICtrlCreateMenuItem("&BackUp del Fitxer", $gcM_EnvFit)
		$gcM_EF_Attrib = GUICtrlCreateMenuItem("&Treure Atribut de només lectura", $gcM_EnvFit)
		$gcM_EF_CrearDir = GUICtrlCreateMenuItem("&Crear Directori si no Existeix", $gcM_EnvFit)
		$gcM_EF_Zip = GUICtrlCreateMenuItem("Comprimir en zip els fitxers &MDB", $gcM_EnvFit)

		_EF_Menu($gcM_EF_Attrib, 1)
		_EF_Menu($gcM_EF_Backup, 1)
		_EF_Menu($gcM_EF_CrearDir, 1)
		_EF_Menu($gcM_EF_Sobr, 1)
		_EF_Menu($gcM_EF_Zip, 1)
		
		GUICtrlSetImage($gcF_Buscar, @ScriptFullPath, -10)
		GUICtrlSetOnEvent($gcF_Buscar, "_Window")
		GUICtrlSetOnEvent($gcF_Serv, "_Window")
		GUICtrlSetOnEvent($gcF_TPV, "_Window")
		GUICtrlSetOnEvent($gcM_EF_Backup, "_Window")
		GUICtrlSetOnEvent($gcM_EF_CrearDir, "_Window")
		GUICtrlSetOnEvent($gcM_EF_Sobr, "_Window")
		GUICtrlSetOnEvent($gcM_EF_Attrib, "_Window")
		GUICtrlSetOnEvent($gcM_EF_Zip, "_Window")
		GUICtrlSetBkColor($gcFile, 0xFFFFFF)
		GUICtrlSetTip($gcF_DirEnv, "Ex: \Dir\Dir" & @LF & "O deixeu en blanc per la c:")
		GUICtrlSetResizing($gcF_Buscar, 802)
		GUICtrlSetResizing($gcFile, 802)
		GUICtrlSetResizing($gcF_Serv, 802)
		GUICtrlSetResizing($gcF_TPV, 802)
		GUICtrlSetResizing($gcF_Lab, 802)
		GUICtrlSetResizing($gcF_DirEnv, 802)
		$gcList_C_Dir = _GUICtrlListView_AddColumn($gcList, "Direcció Enviament del Fitxer", 250)
		$gcList_C_Temps = _GUICtrlListView_AddColumn($gcList, "Temps d'Enviament", 80, 2)
		Return 1
	EndIf
EndFunc   ;==>_EnviamentFitxers

Func _EF_Menu($iID, $flag)
	If $flag = 0 Then
		If BitAND(GUICtrlRead($iID), $GUI_UNCHECKED) Then
			RegWrite($REG_CONFIG, $iID, "REG_DWORD", 1)
			GUICtrlSetState($iID, $GUI_CHECKED)
		Else
			RegWrite($REG_CONFIG, $iID, "REG_DWORD", 0)
			GUICtrlSetState($iID, $GUI_UNCHECKED)
		EndIf
	Else
		If RegRead($REG_CONFIG, $iID) = 1 Then GUICtrlSetState($iID, $GUI_CHECKED)
	EndIf
EndFunc   ;==>_EF_Menu

Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $tagNMHDR, $event
	
	If $wParam = $gcList And GUICtrlGetHandle($gcS_List) <> ControlGetHandle($hWndGUI, "", ControlGetFocus($hWndGUI)) Then
		$tagNMHDR = DllStructCreate("int;int;int", $lParam)
		$event = DllStructGetData($tagNMHDR, 3)

		If $event = -3 Then _ExeRadmin()
		
	EndIf
EndFunc   ;==>WM_Notify_Events

Func WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	_GUICtrlStatusBar_Resize($gcStatus)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func _ExeRadmin()
	$Radmin = RegRead($REG_CONFIG, "RadminFile")
	$text = StringSplit(GUICtrlRead(GUICtrlRead($gcList)), "|")
	If Not @error And $text[5] <> "RDSI" And $text[5] <> "ADSL" Then
		$iImage = _GUICtrlListView_GetSelectedIndices($gcList, True)
		$iImage = $iImage[1]
		If $Enviament_de_Fitxers = 0 Then
			If _GUICtrlListView_GetItemImage($gcList, $iImage) = 2 Then
				$MB = MsgBox(67, "Comprobació", "No has comprobat aquesta direcció per veure si està connectada, vols fer una comprobació ràpida?" & @LF & @LF & "Si cancel·les s'executarà el radmin directament", -1, $GUI_Complet)
				If $MB = 6 Then
					_GUICtrlListView_SetItemChecked($gcList, $iImage)
					If $stop = 1 Then
						_Start(False)
					Else
						_Stop(False)
						_Start(True)
					EndIf
					$iImage = _GUICtrlListView_GetItemImage($gcList, $iImage)
					If $iImage = 1 Or $iImage = 3 Then
						$run = 1
					Else
						If _GUICtrlListView_GetItemText($gcList, $iImage, 3) = "Tancada" Then
							$run = 3
						Else
							MsgBox(48, "Fora de línia", "Aquesta direcció no està activa." & @LF & @LF & "No es pot executar el Radmin", 3, $GUI_Complet)
							$run = 0
						EndIf
					EndIf
				ElseIf $MB = 7 Then
					$run = 1
				Else
					$run = 2
				EndIf
			ElseIf _GUICtrlListView_GetItemImage($gcList, $iImage) = 1 Or _GUICtrlListView_GetItemImage($gcList, $iImage) = 3 Then
				$run = 1
			Else
				$run = 0
			EndIf
		Else
			$run = 1
		EndIf
		If $run = 3 Then
			Switch MsgBox(68, "Caixa Tancada", "Sembla que la caixa està tancada, vols executar igualment el Radmin?", -1, $GUI_Complet)
				Case 6
					$run = 1
				Case 7
					$run = 0
			EndSwitch
		EndIf
		
		If $run = 1 Then
			Switch RegRead($REG_CONFIG, "VistaRadmin")
				Case 1
					$vista = " /noinput"
				Case 2
					$vista = " /file"
				Case Else
					$vista = ""
			EndSwitch
			Run($Radmin & " /connect:" & $text[2] & ":4899" & $vista)
		ElseIf $run = 0 Then
			MsgBox(48, "No es pot executar", "Per alguna raó no es pot executar el Radmin, és possible que el fallo estigui en el llistat.", -1, $GUI_Complet)
		EndIf
	EndIf
	Return
EndFunc   ;==>_ExeRadmin

Func _MarcarDesmarcar($mID, $mOP = "", $mState = "")
	If BitAND(GUICtrlRead($mID), $GUI_UNCHECKED) Then
		GUICtrlSetState($mID, $GUI_CHECKED)
		If $mOP = "" Then $mOP = True
		If $Enviament_de_Fitxers = 1 Then
			If $mState = 4 Then
				GUICtrlSetState($mID, $GUI_UNCHECKED)
				$mOP = False
			EndIf
		EndIf
	ElseIf BitAND(GUICtrlRead($mID), $GUI_CHECKED) Then
		GUICtrlSetState($mID, $GUI_UNCHECKED)
		If $mOP = "" Then $mOP = False
		If $Enviament_de_Fitxers = 1 Then
			If $mState = 1 Then
				GUICtrlSetState($mID, $GUI_CHECKED)
				$mOP = True
			EndIf
		EndIf
	EndIf

	Switch $mID
		Case $gcL_M_Botiga
			If _GUICtrlListView_GetSelectedIndices($gcList) <> "" Then
				$idGroup = _GUICtrlListView_GetItemGroupID($gcList, _GUICtrlListView_GetSelectedIndices($gcList, False))
				For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
					If _GUICtrlListView_GetItemGroupID($gcList, $i) = $idGroup Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
				Next
				If $mOP = False Then
					If BitAND(GUICtrlRead($gcL_M_Tots), $GUI_CHECKED) Then GUICtrlSetState($gcL_M_Tots, $GUI_UNCHECKED)
				EndIf
			Else
				MsgBox(64, "No hi ha Selecció", "No hi ha cap botiga seleccionada, primer marca la botiga o una de les direccions de la botiga.", -1, $GUI_Complet)
				GUICtrlSetState($mID, $GUI_UNCHECKED)
			EndIf
		Case $gcL_M_Tots
			For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
				_GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
			Next
			If $mOP = True Then
				GUICtrlSetState($gcL_M_DSL, $GUI_CHECKED)
				GUICtrlSetState($gcL_M_RDSI, $GUI_CHECKED)
				GUICtrlSetState($gcL_M_Serv, $GUI_CHECKED)
				GUICtrlSetState($gcL_M_TPV, $GUI_CHECKED)
				GUICtrlSetState($gcL_M_CZ, $GUI_CHECKED)
				GUICtrlSetState($gcL_M_Pass, $GUI_CHECKED)
				GUICtrlSetState($gcL_M_Botiga, $GUI_CHECKED)
			Else
				GUICtrlSetState($gcL_M_DSL, $GUI_UNCHECKED)
				GUICtrlSetState($gcL_M_RDSI, $GUI_UNCHECKED)
				GUICtrlSetState($gcL_M_Serv, $GUI_UNCHECKED)
				GUICtrlSetState($gcL_M_TPV, $GUI_UNCHECKED)
				GUICtrlSetState($gcL_M_CZ, $GUI_UNCHECKED)
				GUICtrlSetState($gcL_M_Pass, $GUI_UNCHECKED)
				GUICtrlSetState($gcL_M_Botiga, $GUI_UNCHECKED)
			EndIf
			
		Case $gcL_M_DSL
			For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
				If _GUICtrlListView_GetItemText($gcList, $i, $gc_c_name) = "ADSL" Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
			Next
			
		Case $gcL_M_RDSI
			For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
				If _GUICtrlListView_GetItemText($gcList, $i, $gc_c_name) = "RDSI" Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
			Next
			
		Case $gcL_M_Serv
			For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
				If StringLeft(_GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), 3) = "S: " Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
			Next
			
		Case $gcL_M_CZ
			For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
				If StringRight(_GUICtrlListView_GetItemText($gcList, $i, 1), 3) = "202" Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
				If StringRight(_GUICtrlListView_GetItemText($gcList, $i, 1), 3) = "203" Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
			Next
			
		Case $gcL_M_Pass
			For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
				If _GUICtrlListView_GetItemText($gcList, $i, $gc_c_name) = "Passarel·la" Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
			Next
			
		Case $gcL_M_TPV
			For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
				If StringInStr(_GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), "Caixa") <> 0 Then _GUICtrlListView_SetItemChecked($gcList, $i, $mOP)
			Next
			
	EndSwitch
	If $mOP = True Then
		If BitAND(GUICtrlRead($gcL_M_Tots), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_Tots, StringReplace(StringReplace(GUICtrlRead($gcL_M_Tots, 1), " Marcar", " Desmarcar"), "Control", "Control+Shift"))
		If BitAND(GUICtrlRead($gcL_M_DSL), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_DSL, StringReplace(StringReplace(GUICtrlRead($gcL_M_DSL, 1), " Marcar", " Desmarcar"), "Control", "Control+Shift"))
		If BitAND(GUICtrlRead($gcL_M_RDSI), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_RDSI, StringReplace(StringReplace(GUICtrlRead($gcL_M_RDSI, 1), " Marcar", " Desmarcar"), "Control", "Control+Shift"))
		If BitAND(GUICtrlRead($gcL_M_Serv), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_Serv, StringReplace(StringReplace(GUICtrlRead($gcL_M_Serv, 1), " Marcar", " Desmarcar"), "Control+5", "Control+Shift+5"))
		If BitAND(GUICtrlRead($gcL_M_TPV), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_TPV, StringReplace(StringReplace(GUICtrlRead($gcL_M_TPV, 1), " Marcar", " Desmarcar"), "Control+6", "Control+Shift+6"))
		If BitAND(GUICtrlRead($gcL_M_CZ), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_CZ, StringReplace(StringReplace(GUICtrlRead($gcL_M_CZ, 1), " Marcar", " Desmarcar"), "Control", "Control+Shift"))
		If BitAND(GUICtrlRead($gcL_M_Pass), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_Pass, StringReplace(StringReplace(GUICtrlRead($gcL_M_Pass, 1), " Marcar", " Desmarcar"), "Control", "Control+Shift"))
		If BitAND(GUICtrlRead($gcL_M_Botiga), $GUI_CHECKED) Then GUICtrlSetData($gcL_M_Botiga, StringReplace(StringReplace(GUICtrlRead($gcL_M_Botiga, 1), " Marcar", " Desmarcar"), "Control", "Control+Shift"))
	Else
		If BitAND(GUICtrlRead($gcL_M_Tots), $GUI_CHECKED) Then GUICtrlSetState($gcL_M_Tots, $GUI_UNCHECKED)
		If BitAND(GUICtrlRead($gcL_M_Tots), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_Tots, StringReplace(StringReplace(GUICtrlRead($gcL_M_Tots, 1), "Desmarcar", "Marcar"), "Control+Shift", "Control"))
		If BitAND(GUICtrlRead($gcL_M_DSL), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_DSL, StringReplace(StringReplace(GUICtrlRead($gcL_M_DSL, 1), "Desmarcar", "Marcar"), "Control+Shift", "Control"))
		If BitAND(GUICtrlRead($gcL_M_RDSI), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_RDSI, StringReplace(StringReplace(GUICtrlRead($gcL_M_RDSI, 1), "Desmarcar", "Marcar"), "Control+Shift", "Control"))
		If BitAND(GUICtrlRead($gcL_M_Serv), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_Serv, StringReplace(StringReplace(GUICtrlRead($gcL_M_Serv, 1), "Desmarcar", "Marcar"), "Control+Shift+5", "Control+5"))
		If BitAND(GUICtrlRead($gcL_M_TPV), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_TPV, StringReplace(StringReplace(GUICtrlRead($gcL_M_TPV, 1), "Desmarcar", "Marcar"), "Control+Shift+6", "Control+6"))
		If BitAND(GUICtrlRead($gcL_M_CZ), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_CZ, StringReplace(StringReplace(GUICtrlRead($gcL_M_CZ, 1), "Desmarcar", "Marcar"), "Control+Shift", "Control"))
		If BitAND(GUICtrlRead($gcL_M_Pass), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_Pass, StringReplace(StringReplace(GUICtrlRead($gcL_M_Pass, 1), "Desmarcar", "Marcar"), "Control+Shift", "Control"))
		If BitAND(GUICtrlRead($gcL_M_Botiga), $GUI_UNCHECKED) Then GUICtrlSetData($gcL_M_Botiga, StringReplace(StringReplace(GUICtrlRead($gcL_M_Botiga, 1), "Desmarcar", "Marcar"), "Control+Shift", "Control"))
	EndIf
EndFunc   ;==>_MarcarDesmarcar

Func _Ping()
	$countItem = _GUICtrlListView_GetItemCount($gcList)
	If $countItem > 0 Then
		If RegRead($REG_CONFIG, "ActivarVisorLog") = 1 And BitAND(WinGetState("Lector de LOG"), 1) = 0 And $closed <> 1 And $stop <> 1 Then
			_GuiLog()
		EndIf
		$rChecked = 0
		$iChecked = 0
		For $i = 0 To $countItem
			If _GUICtrlListView_GetItemChecked($gcList, $i) = True Then $iChecked += 1
		Next
		If $iChecked = 0 Then _Stop(True)
		$tTimer = TimerInit()
		For $i = 0 To $countItem
			$msg = GUIGetMsg()
			If _GUICtrlListView_GetItemChecked($gcList, $i) = True Then
				If RegRead($REG_CONFIG, "ActivarVisorLog") = 1 And BitAND(WinGetState("Lector de LOG"), 1) Then
					$file = FileOpen($LOG_File, 0)
					$text = FileRead($file)
					FileClose($file)
					GUICtrlSetData($log, $text)
					_GUICtrlEdit_Scroll($log, 7)
				EndIf
				If $llista_Valvi = 0 Then
					$H_inici = _GUICtrlListView_GetItemText($gcList, $i, $gcList_C_HI)
					$H_fi = _GUICtrlListView_GetItemText($gcList, $i, $gcList_C_HF)
					If _NowTime(4) >= $H_inici And _NowTime(4) <= $H_fi Or $H_inici = "" Or $H_fi = "" Then
						_GUICtrlListView_SetItemImage($gcList, $i, 1)
						$IPactual = _GUICtrlListView_GetItemText($gcList, $i, 1)
						$Resposta_Ping = Ping($IPactual, RegRead($REG_CONFIG, "PingWait"))
						If @error Then
							Switch @error
								Case 1
									_SetError("Fora de línea", 1, 0, $i, $IPactual)
								Case 2
									_SetError("No es pot resoldre", 2, 0, $i, $IPactual)
								Case 3
									_SetError("Destinació incorrecte", 3, 1, $i, $IPactual)
								Case 4
									_SetError("Altres errors", 4, 1, $i, $IPactual)
							EndSwitch
						Else
							$rChecked += 1
							GUICtrlSetData($gcProgress, $rChecked / $iChecked * 100)
							If $Resposta_Ping > RegRead($REG_CONFIG, "PingAvis") Then
								_GUICtrlListView_SetItemText($gcList, $i, $Resposta_Ping, 3)
								IniWrite($LOG_File, $IPactual, _NowCalc(), "Resposta superada " & $Resposta_Ping)
							EndIf
							_GUICtrlListView_SetItemImage($gcList, $i, 3)
							_GUICtrlListView_SetItemText($gcList, $i, $Resposta_Ping, 2)
							_GUICtrlListView_SetItemText($gcList, $i, "", 3)
						EndIf
					EndIf
				Else
					Switch @WDAY
						Case 1
							$H_inici = _GUICtrlListView_GetItemText($gcList, $i, 7)
							$H_fi = _GUICtrlListView_GetItemText($gcList, $i, 8)
						Case Else
							$H_inici = _GUICtrlListView_GetItemText($gcList, $i, 5)
							$H_fi = _GUICtrlListView_GetItemText($gcList, $i, 6)
					EndSwitch
					Switch _GUICtrlListView_GetItemText($gcList, $i, 9)
						Case "Tancada"
							$estat = 0
						Case "Fora Temporada"
							$estat = 0
						Case "Obres"
							$estat = 0
						Case Else
							$estat = 1
					EndSwitch

					Local $Reg_File = $InstallDir & "\Registres.log"
					
					$IPactual = _GUICtrlListView_GetItemText($gcList, $i, 1)
					$text = _GUICtrlListView_GetGroupInfo($gcList, _GUICtrlListView_GetItemGroupID($gcList, $i))
					Local $REG_UERROR_Final = $REG_UERROR & "\" & $text[0] & "\" & $IPactual
					If _NowTime(4) >= $H_inici And _NowTime(4) <= $H_fi And $estat = 1 Or $H_inici = "" And $estat = 1 Or $H_fi = ""And $estat = 1 Then
						$oberta = 1
						_GUICtrlListView_SetItemImage($gcList, $i, 1)
						_GUICtrlStatusBar_SetText($gcStatus, "Fent Ping a " & _GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), 0)
						_GUICtrlStatusBar_SetIcon($gcStatus, 0, _WinAPI_LoadShell32Icon(17))
						$iGroup = _GUICtrlListView_GetGroupInfo($gcList, _GUICtrlListView_GetItemGroupID($gcList, $i))
						_GUICtrlStatusBar_SetText($gcStatus, $iGroup[0], 1)
						$Resposta_Ping = Ping($IPactual, RegRead($REG_CONFIG, "PingWait"))
						$Ping_Error = @error
						If $Ping_Error Then
							Switch $Ping_Error
								Case 1
									_SetError("Fora de línea", 1, 0, $i, $IPactual)
								Case 2
									_SetError("No es pot resoldre", 2, 0, $i, $IPactual)
								Case 3
									_SetError("Destinació incorrecte", 3, 1, $i, $IPactual)
								Case 4
									_SetError("Altres errors", 4, 1, $i, $IPactual)
							EndSwitch
							RegWrite($REG_UERROR_Final, "UltimError", "REG_SZ", _NowCalc())
							If RegRead($REG_UERROR_Final, "Control") = 0 Then
								RegWrite($REG_UERROR_Final, "Control", "REG_DWORD", 1)
							EndIf
							If RegRead($REG_UERROR_Final, "Tancada") = 3 Then
								_GUICtrlListView_SetItemChecked($gcList, $i, False)
								_GUICtrlListView_SetItemText($gcList, $i, "Possiblement tancada", 3)
								_GUICtrlListView_SetItemImage($gcList, $i, 5)
								RegWrite($REG_UERROR_Final, "Tancada", "REG_DWORD", 0)
								If $stop <> 1 Then 
									IniWrite($LOG_File, $IPactual, _NowCalc(), "Possiblement tancada")
								EndIf
							EndIf
							If $Enviament_de_Fitxers = 1 Then
								If StringInStr(_GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), "Caixa") <> 0 Or StringInStr(_GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), "S: ") <> 0 Then $valor[$i] = 1
							EndIf
							If RegRead($REG_UERROR_Final, "Activa") <> 1 Then 
								RegWrite($REG_UERROR_Final, "Tancada", "REG_DWORD", Number(RegRead($REG_UERROR_Final, "Tancada")) + 1)
							EndIf
						Else
							$rChecked += 1
							GUICtrlSetData($gcProgress, Int($rChecked / $iChecked * 100))
							If RegRead($REG_UERROR_Final, "Activa") <> 1 Then 
								RegWrite($REG_UERROR_Final, "Activa", "REG_DWORD", 1)
							EndIf
							RegWrite($REG_UERROR_Final, "Control", "REG_DWORD", 0)
							$uError = _GetTimeError(RegRead($REG_UERROR_Final, "UltimError"))
							If $uError <> "" Then
								_GUICtrlListView_SetItemText($gcList, $i, $uError, 10)
							EndIf
							_GUICtrlListView_SetItemImage($gcList, $i, 3)
							_GUICtrlListView_SetItemText($gcList, $i, $Resposta_Ping, 2)
							_GUICtrlListView_SetItemText($gcList, $i, "", 3)
							If $Resposta_Ping > RegRead($REG_CONFIG, "PingAvis") Then
								_GUICtrlListView_SetItemText($gcList, $i, "Resp. sup. " & $Resposta_Ping, 3)
								IniWrite($LOG_File, $IPactual, _NowCalc(), "Resp. sup. " & $Resposta_Ping)
							EndIf
							_GUICtrlStatusBar_SetText($gcStatus, @TAB & $rChecked & " de " & $iChecked, 2)

							If $Enviament_de_Fitxers = 1 And _GUICtrlListView_GetItemText($gcList, $i, $gcList_C_Dir) <> "Copia Realitzada" Then
								If StringInStr(_GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), "Caixa") <> 0 Or StringInStr(_GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), "S: ") <> 0 Then
									$Origen = GUICtrlRead($gcFile)
									$Desti = _GUICtrlListView_GetItemText($gcList, $i, $gcList_C_Dir)
									$a = StringSplit($Origen, "\")
									If RegRead($REG_CONFIG, $gcM_EF_CrearDir) = 1 And Not FileExists(StringTrimRight($Desti, StringLen($a[$a[0]]))) Then
										_GUICtrlStatusBar_SetText($gcStatus, "Creant direcotri " & StringTrimRight($Desti, StringLen($a[$a[0]])), 0)
										_GUICtrlStatusBar_SetIcon($gcStatus, 0, _WinAPI_LoadShell32Icon(3))
										DirCreate(StringTrimRight($Desti, StringLen($a[$a[0]])))
									EndIf
									$iGroup = _GUICtrlListView_GetGroupInfo($gcList, _GUICtrlListView_GetItemGroupID($gcList, $i))
									_GUICtrlStatusBar_SetText($gcStatus, $iGroup[0], 1)
									If StringInStr(_GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), "S: ") Then
										_GUICtrlStatusBar_SetText($gcStatus, "Servidor", 3)
									Else
										_GUICtrlStatusBar_SetText($gcStatus, _GUICtrlListView_GetItemText($gcList, $i, $gc_c_name), 3)
									EndIf
									If StringInStr($Origen, ".mdb") And RegRead($REG_CONFIG, $gcM_EF_Zip) = 1 Then
										_GUICtrlStatusBar_SetText($gcStatus, "Comprimint " & $a[$a[0]], 0)
										_GUICtrlStatusBar_SetIcon($gcStatus, 0, _WinAPI_LoadShell32Icon(249))
										$r = RunWait($PATH & '\RarIt.exe ' & $Origen & " " & $i, $PATH)
										If $r = 0 And FileExists($PATH & "\PingT.zip") Then
											$Origen = $PATH & "\PingT" & $i & ".zip"
											$Desti = StringReplace($Desti, ".mdb", $i & ".zip")
											$a = StringSplit($Desti, "\")
											$Zipped = 1
										ElseIf $r = 20 Then
											MsgBox(48, "Error Intern", "Error al cridar el programa de compressió, paràmetres incorrectes.", 1, $GUI_Complet)
										EndIf
									EndIf
									If StringInStr(FileGetAttrib($Desti), "R") And RegRead($REG_CONFIG, $gcM_EF_Attrib) = 1 Then
										_GUICtrlStatusBar_SetText($gcStatus, "Canviant atribut de lectura", 0)
										_GUICtrlStatusBar_SetIcon($gcStatus, 0, _WinAPI_LoadShell32Icon(47))
										FileSetAttrib($Desti, "-R")
									EndIf
									_GUICtrlStatusBar_SetText($gcStatus, $Desti, 4)
									If RegRead($REG_CONFIG, $gcM_EF_Backup) = 1 And $Zipped <> 1 Then
										If FileExists($Desti) Then
											_GUICtrlStatusBar_SetText($gcStatus, "Creant Backup del fitxer", 0)
											_GUICtrlStatusBar_SetIcon($gcStatus, 0, _WinAPI_LoadShell32Icon(132))
											FileCopy($Desti, StringTrimRight($Desti, StringLen($a[$a[0]])) & "\Fitxers\BackUp\" & StringReplace(_NowCalcDate(), "/", "\") & "\" & $a[$a[0]], 8)
										EndIf
										RegWrite($REG_CONFIG, $gcM_EF_Sobr, "REG_DWORD", 1)
									EndIf
									If FileExists(StringTrimRight($Desti, StringLen($a[$a[0]]))) = 1 Then
										_GUICtrlStatusBar_SetText($gcStatus, "Enviant " & $a[$a[0]], 0)
										_GUICtrlStatusBar_SetIcon($gcStatus, 0, _WinAPI_LoadShell32Icon(24))
										$cTimer = _Timer_Init()
										If RegRead($REG_CONFIG, $gcM_EF_Sobr) = 1 Then
											$Options = 16
										EndIf
										If _ExplorerCopy($Origen, $Desti, $Options) = True Then
											_TicksToTime(_Timer_Diff($cTimer), $cHour, $cMins, $cSecs)
											_GUICtrlListView_SetItemText($gcList, $i, StringFormat("%02d:%02d:%02d", $cHour, $cMins, $cSecs), $gcList_C_Temps)
											_GUICtrlListView_SetItem($gcList, "Copia Realitzada", $i, $gcList_C_Dir, 3)
											_GUICtrlListView_SetItemChecked($gcList, $i, False)
											$valor[$i] = 10
											If $Zipped = 1 Then
												Run($PATH & '\UnRarIt.exe "' & $Desti & '" "' & $Origen & '" /' & RegRead($REG_CONFIG, $gcM_EF_Backup), $PATH)
												$Zipped = 0
											EndIf
										Else
											If FileExists($Desti) Then
												$fAttrib = FileGetAttrib($Desti)
												Switch StringInStr($fAttrib, "R")
													Case 0
														_GUICtrlListView_SetItemImage($gcList, $i, 1, $gcList_C_Dir)
														_GUICtrlListView_SetItemText($gcList, $i, "El fitxer ja existeix", 3)
														$valor[$i] = 2
													Case Else
														_GUICtrlListView_SetItemImage($gcList, $i, 5, $gcList_C_Dir)
														_GUICtrlListView_SetItemText($gcList, $i, "Attribut només de lectura", 3)
														$valor[$i] = 5
												EndSwitch
											Else
												_GUICtrlListView_SetItemImage($gcList, $i, 0, $gcList_C_Dir)
												_GUICtrlListView_SetItemText($gcList, $i, "Error a l'hora de copiar", 3)
												$valor[$i] = 4
											EndIf
										EndIf
									Else
										_GUICtrlListView_SetItemImage($gcList, $i, 0, $gcList_C_Dir)
										_GUICtrlListView_SetItemText($gcList, $i, "No existeix el directori", 3)
										$valor[$i] = 3
									EndIf
								EndIf
							EndIf
							_GUICtrlStatusBar_SetBlank($gcStatus, 2)
						EndIf
					Else
						If _GUICtrlListView_GetItemText($gcList, $i, 3) <> "Tancada" Then
							_GUICtrlListView_SetItemText($gcList, $i, "Tancada", 3)
							If $estat = 0 Then
								_GUICtrlListView_SetItemChecked($gcList, $i, False)
								$gID = _GUICtrlListView_GetItemGroupID($gcList, $i)
								$gText = _GUICtrlListView_GetGroupInfo($gcList, $gID)
								_GUICtrlListView_SetGroupInfo($gcList, $gID, $gText[0], 0, $LVGS_COLLAPSED)
							EndIf
						EndIf
					EndIf
				EndIf
				Sleep(10)
			EndIf
			If $stop = 1 Then ExitLoop
		Next
		GUICtrlSetData($gcProgress, 0)
		If $Enviament_de_Fitxers = 1 And $stop = 0 Then
			If _ArraySearch($valor, 2) <> -1 Then $2 = @LF & " - Alguns fitxers no s'han sobreescrit."
			If _ArraySearch($valor, 3) <> -1 Then $3 = @LF & " - Alguns fitxers no s'han pogut enviar, el directori de destí no existeix."
			If _ArraySearch($valor, 4) <> -1 Then $4 = @LF & " - Alguns fitxers no s'han pogut enviar, error en l'acció de copiar."
			If _ArraySearch($valor, 5) <> -1 Then $5 = @LF & " - Alguns fitxers tenen l'atribut de només lectura."
			If _ArraySearch($valor, 1) <> -1 Then $1 = @LF & " - Alguns ordinadors no tenen connexió."
			If _ArraySearch($valor, 10) <> -1 And $2 = "" And $3 = "" And $4 = "" And $5 = "" And $1 = "" Then $10 = 1
			If $4 <> "" Or $3 <> "" Or $2 <> "" Or $5 <> "" Or $1 <> "" Or $10 = 1 Then
				_Stop(True)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_Ping

Func _CarregaLlista()
	$llista_Valvi = 1
	$Separador1 = GUICtrlCreateMenuItem("", $gcList_Menu, 0)
	$gcL_M_Pass = GUICtrlCreateMenuItem("&8- Marcar Passarel·les" & @TAB & "Control+8", $gcList_Menu, 0)
	$gcL_M_CZ = GUICtrlCreateMenuItem("&7- Marcar Caps de Zona/Altres" & @TAB & "Control+7", $gcList_Menu, 0)
	$gcL_M_TPV = GUICtrlCreateMenuItem("&6- Marcar Caixes" & @TAB & "Control+6", $gcList_Menu, 0)
	$gcL_M_Serv = GUICtrlCreateMenuItem("&5- Marcar Servidors" & @TAB & "Control+5", $gcList_Menu, 0)
	$gcL_M_RDSI = GUICtrlCreateMenuItem("&4- Marcar els RDSI" & @TAB & "Control+4", $gcList_Menu, 0)
	$gcL_M_DSL = GUICtrlCreateMenuItem("&3- Marcar els ADSL" & @TAB & "Control+3", $gcList_Menu, 0)
	$gcL_M_Botiga = GUICtrlCreateMenuItem("&2- Marcar Botiga" & @TAB & "Control+2", $gcList_Menu, 0)
	$gcL_M_Tots = GUICtrlCreateMenuItem("&1- Marcar Tots" & @TAB & "Control+1", $gcList_Menu, 0)
;~ 	$Separador2 = GUICtrlCreateMenuItem("", $gcList_Menu, 0)
	GUICtrlSetOnEvent($gcL_M_Botiga, "_Window")
	GUICtrlSetOnEvent($gcL_M_Tots, "_Window")
	GUICtrlSetOnEvent($gcL_M_DSL, "_Window")
	GUICtrlSetOnEvent($gcL_M_RDSI, "_Window")
	GUICtrlSetOnEvent($gcL_M_Serv, "_Window")
	GUICtrlSetOnEvent($gcL_M_TPV, "_Window")
	GUICtrlSetOnEvent($gcL_M_CZ, "_Window")
	GUICtrlSetOnEvent($gcL_M_Pass, "_Window")

	GUICtrlSetState($gcAfegir, $GUI_DISABLE)
	GUICtrlSetState($gcTreure, $GUI_DISABLE)
	GUICtrlSetState($gcHost, $GUI_DISABLE)
	GUICtrlSetState($gcHosttoIP, $GUI_DISABLE)
	GUICtrlSetState($gcM_E_Bot, $GUI_DISABLE)
	GUICtrlSetState($gcM_E_Prog, $GUI_DISABLE)
	GUICtrlSetState($gcS_List, $GUI_ENABLE)
	
	GUICtrlSetState($gcList, $GUI_HIDE)
	_GUICtrlListView_DeleteAllItems($gcList)
	_GUICtrlListView_EnableGroupView($gcList)
	$gc_c_name = _GUICtrlListView_AddColumn($gcList, "Nom", 100)
	$gcList_C_HI = _GUICtrlListView_AddColumn($gcList, "Obertura", 50, 2)
	$gcList_C_HF = _GUICtrlListView_AddColumn($gcList, "Tancament", 50, 2)
	$gcList_C_ObDiu = _GUICtrlListView_AddColumn($gcList, "ObDiumenge", 50, 2)
	$gcList_C_TaDiu = _GUICtrlListView_AddColumn($gcList, "TaDiumenge", 50, 2)
	$gcList_C_Estat = _GUICtrlListView_AddColumn($gcList, "Estat", 60)
	$gcList_C_UltErr = _GUICtrlListView_AddColumn($gcList, "Últim Error", 100)
	ProgressOn("Carregant llista Valvi", "Carregant", "Un moment si us plau")
	For $i = 0 To $Botigues[0][0]
		ProgressSet(Int($i / $Botigues[0][0] * 100))
		$codi = $Botigues[$i][1]
		$iniIP = "192.168." & $codi
		$nGroup = StringFormat("8%02d", $Botigues[$i][1]) & " - " & $Botigues[$i][0]
		$idGroup = _GUICtrlListView_InsertGroup($gcList, -1, $i, $nGroup)
		_GUICtrlListView_SetGroupInfo($gcList, $idGroup, $nGroup, 0, $LVGS_COLLAPSIBLE)
		Switch $Botigues[$i][7]
			Case 0
				$estat = "Oberta"
			Case 1
				$temp = StringSplit($Botigues[$i][8], "|")
				If _NowCalcDate() >= @YEAR & "/" & $temp[1] And _NowCalcDate() <= @YEAR & "/" & $temp[2] Or $temp[1] = "" Or $temp[2] = "" Then
					$estat = "Temporada"
				Else
					$estat = "Fora Temporada"
				EndIf
			Case 2
				$estat = "Tancada"
			Case 3
				$estat = "Obres"
		EndSwitch
		For $i2 = 1 To $Botigues[$i][2]
			If $ADSL = 0 Then
				GUICtrlCreateListViewItem("|" & $iniIP & ".10|||ADSL|||||" & $estat, $gcList)
				$iIndex = _GUICtrlListView_FindInText($gcList, $iniIP & ".10")
				_GUICtrlListView_SetItemGroupID($gcList, $iIndex, $idGroup)
				_GUICtrlListView_SetItemImage($gcList, $iIndex, 2)
				$ADSL = 1
			EndIf
			If $RDSI = 0 Then
				GUICtrlCreateListViewItem("|" & $iniIP & ".11|||RDSI|||||" & $estat, $gcList)
				$iIndex = _GUICtrlListView_FindInText($gcList, $iniIP & ".11")
				_GUICtrlListView_SetItemGroupID($gcList, $iIndex, $idGroup)
				_GUICtrlListView_SetItemImage($gcList, $iIndex, 2)
				$RDSI = 1
			EndIf
			If $i2 = 1 Then
				$IP = $iniIP & ".200"
				$1Array = _ArraySearch($Codis, $codi, 0, 0, 0, 0, 1, 1)
				If @error Then MsgBox(48, "Error 1Array", "Error " & @error & " a 1Array" & @LF & "codi " & $codi)
				$2Array = _ArraySearch($CodiPC, $Codis[$1Array][0])
				If @error Then MsgBox(48, "Error 2Array", "Error " & @error & " a 2Array")
				$nom = StringUpper($CodiPC[$2Array][1])
				GUICtrlCreateListViewItem("|" & $IP & "|||S: " & $nom & "|||||" & $estat, $gcList)
				$iIndex = _GUICtrlListView_FindInText($gcList, $IP)
				_GUICtrlListView_SetItemGroupID($gcList, $iIndex, $idGroup)
			Else
				$IP = $iniIP & ".20" & $i2
				GUICtrlCreateListViewItem("|" & $IP & "||||||||" & $estat, $gcList)
				$iIndex = _GUICtrlListView_FindInText($gcList, $IP)
				_GUICtrlListView_SetItemGroupID($gcList, $iIndex, $idGroup)
				TCPStartup()
				_GUICtrlListView_SetItemText($gcList, $iIndex, _TCPIpToName($IP), $gc_c_name)
				TCPShutdown()
			EndIf
			_GUICtrlListView_SetItemImage($gcList, $iIndex, 2)
		Next
		$ADSL = 0
		$RDSI = 0
		For $i2 = 1 To $Botigues[$i][3]
			$Horari = StringSplit($Botigues[$i][5], "|")
			$Diumege = StringSplit($Botigues[$i][6], "|")
			GUICtrlCreateListViewItem("|" & $iniIP & ".10" & $i2 & "|||Caixa " & $i2 & "|" & $Horari[2] & "|" & $Horari[3] & "|" & $Diumege[2] & "|" & $Diumege[3] & "|" & $estat, $gcList)
			$iIndex = _GUICtrlListView_FindInText($gcList, $iniIP & ".10" & $i2)
			_GUICtrlListView_SetItemGroupID($gcList, $iIndex, $idGroup)
			_GUICtrlListView_SetItemImage($gcList, $iIndex, 2)
		Next
		If $Botigues[$i][4] = 15 Then
			GUICtrlCreateListViewItem("|" & $iniIP & ".15|||Passarel·la|||||" & $estat, $gcList)
			$iIndex = _GUICtrlListView_FindInText($gcList, $iniIP & ".15")
			_GUICtrlListView_SetItemGroupID($gcList, $iIndex, $idGroup)
			_GUICtrlListView_SetItemImage($gcList, $iIndex, 2)
		EndIf
	Next
	GUICtrlSetState($gcList, $GUI_SHOW)
	ProgressOff()
EndFunc   ;==>_CarregaLlista

Func _Text($index, $list)
	$c = _GUICtrlListView_GetColumn($list, $index)
	Return $c[5]
EndFunc   ;==>_Text

Func _Valors_Programacio($d)
	$Reg_Car = $REG_PROGRAMACIO & "\" & $d
	If RegRead($Reg_Car, "ExecutarSlim") = 1 Then
		$d1 = "Si"
	Else
		$d1 = "No"
	EndIf
	If RegRead($Reg_Car, "Diari") = 1 Then
		$d2 = "Si"
	Else
		$d2 = "No"
	EndIf
	$val[0] = $d
	$val[1] = RegRead($Reg_Car, "DataPrograma")
	$val[2] = RegRead($Reg_Car, "HoraInici")
	$val[3] = RegRead($Reg_Car, "HoraFi")
	$val[4] = $d1
	$val[5] = $d2
	Return $val
EndFunc   ;==>_Valors_Programacio

Func _Start($aEnable)
	If _GUICtrlListView_GetItemCount($gcList) > 0 Then
		For $i = 0 To _GUICtrlListView_GetItemCount($gcList)
			If _GUICtrlListView_GetItemChecked($gcList, $i) Then
				If $aEnable = True Then
					If RegRead($REG_CONFIG, "DelVisorLog") Then
						If FileExists($LOG_File) Then FileDelete($LOG_File)
					EndIf
					If _FileWriteLog($LOG_File, "Inici de Pings    <##################################<") Then 
						GUICtrlSetState($gcM_L_Del, $GUI_ENABLE)
						GUICtrlSetState($gcM_L_Obrir, $GUI_ENABLE)
					EndIf
				EndIf
				$stop = 0
				If $llista_Valvi = 0 Then
					GUICtrlSetState($gcAfegir, $GUI_DISABLE)
					GUICtrlSetState($gcTreure, $GUI_DISABLE)
				EndIf
				If $Enviament_de_Fitxers = 1 Then
					GUICtrlSetState($gcF_TPV, $GUI_DISABLE)
					GUICtrlSetState($gcF_Serv, $GUI_DISABLE)
					GUICtrlSetState($gcF_Buscar, $GUI_DISABLE)
				EndIf
				GUICtrlSetState($gcProgress, $GUI_SHOW)
				GUICtrlSetState($gcBorrar, $GUI_DISABLE)
				GUICtrlSetState($gcStart, $GUI_DISABLE)
				GUICtrlSetState($gcStop, $GUI_ENABLE)
				GUICtrlSetState($gcM_E_Start, $GUI_DISABLE)
				GUICtrlSetState($gcM_E_Stop, $GUI_ENABLE)
				GUICtrlSetState($gcM_F_Fitxers, $GUI_DISABLE)
				GUICtrlSetState($gcM_Log, $GUI_DISABLE)
				_Ping()
				If $aEnable = True Then
					AdlibEnable("_Ping", RegRead($REG_CONFIG, "PingPausa"))
				Else
					_Stop(True)
				EndIf
				$a = 1
				ExitLoop
			EndIf
			$a = 0
		Next
		If $a <> 1 Then MsgBox(64, "Cap Selecció", "No has fet cap selecció, no es poden fer els Pings.", -1, $GUI_Complet)
	EndIf
EndFunc   ;==>_Start

Func _Stop($aEnable)
	If $Enviament_de_Fitxers = 1 And $stop = 0 Then
		If $4 <> "" Or $3 <> "" Or $2 <> "" Or $5 <> "" Or $1 <> "" Or $10 = 1 Then
			If $10 = 1 Then
				MsgBox(64, "Enviament finalitzat", "Enviament finalitzat correctament." & @LF & @LF & $rChecked & " de " & $iChecked & " Copiats" & @LF & "Temps total " & _GetTotalTime(TimerDiff($tTimer)), -1, $GUI_Complet)
				$10 = ""
			Else
				MsgBox(64, "Enviament finalitzat", "Enviament finalitzat amb errors:" & $2 & $3 & $4 & $5 & $1 & @LF & @LF & $rChecked & " de " & $iChecked & " Copiats", -1, $GUI_Complet)
				$1 = ""
				$5 = ""
				$4 = ""
				$3 = ""
				$2 = ""
				$10 = ""
			EndIf
			For $i = 0 To 999
				$valor[$i] = ""
			Next
		EndIf
	EndIf
	$stop = 1
	$closed = 0
	If RegRead($REG_CONFIG, "ActivarVisorLog") = 1 And BitAND(WinGetState("Lector de LOG"), 1) Then GUIDelete($GUI_Log)
	_GUICtrlStatusBar_SetBlank($gcStatus, "")
	If $llista_Valvi = 0 Then
		GUICtrlSetState($gcAfegir, $GUI_ENABLE)
		GUICtrlSetState($gcTreure, $GUI_ENABLE)
	EndIf
	If $Enviament_de_Fitxers = 1 Then
		GUICtrlSetState($gcF_TPV, $GUI_ENABLE)
		GUICtrlSetState($gcF_Serv, $GUI_ENABLE)
		GUICtrlSetState($gcF_Buscar, $GUI_ENABLE)
	EndIf
	GUICtrlSetState($gcProgress, $GUI_HIDE)
	GUICtrlSetState($gcBorrar, $GUI_ENABLE)
	GUICtrlSetState($gcStart, $GUI_ENABLE)
	GUICtrlSetState($gcStop, $GUI_DISABLE)
	GUICtrlSetState($gcM_E_Start, $GUI_ENABLE)
	GUICtrlSetState($gcM_E_Stop, $GUI_DISABLE)
	GUICtrlSetState($gcM_F_Fitxers, $GUI_ENABLE)
	GUICtrlSetState($gcM_Log, $GUI_ENABLE)
	AdlibDisable()
	If $aEnable = True Then
		_FileWriteLog($LOG_File, "Fi de Pings    >##################################>" & @CRLF & @CRLF & @CRLF)
		$LOG = FileOpen($LOG_File, 0)
		$text = StringReplace(StringReplace(FileRead($LOG), "[", "------"), "]", "------")
		FileClose($LOG)
		$LOG = FileOpen($LOG_File, 2)
		FileWrite($LOG, $text)
		FileClose($LOG)
		RegDelete($REG_UERROR)
	EndIf
	_ReduceMemory()
EndFunc   ;==>_Stop

Func _GUICtrlStatusBar_SetBlank($hWnd, $sNoBlank = "")
	Local $sParts
	
	If Not IsHWnd($hWnd) Then SetError(1)
	$sParts = _GUICtrlStatusBar_GetCount($hWnd)
	
	Local $pTotal[$sParts + 1]
	
	For $i = 1 To $sParts
		If $sNoBlank = $i - 1 And $sNoBlank <> "" Then
			ContinueLoop
		Else
			If _GUICtrlStatusBar_SetText($hWnd, "", $i - 1) Then
				If _GUICtrlStatusBar_SetIcon($hWnd, $i - 1, -1) Then
					$pTotal[$i] = True
				Else
					$pTotal[$i] = 3
				EndIf
			Else
				$pTotal[$i] = 2
			EndIf
		EndIf
	Next
	
	$pTotal[0] = UBound($pTotal - 1)
	
	If _ArraySearch($pTotal, 2) <> -1 Then SetError(2)
	If _ArraySearch($pTotal, 3) <> -1 Then SetError(3)
	If _ArrayFindAll($pTotal, True) <> -1 Then Return True
EndFunc   ;==>_GUICtrlStatusBar_SetBlank

Func _GetTotalTime($Timer)
	Local $tHour, $tMins, $tSecs, $sFormat, $h = "Hores", $m = "Minuts", $s = "Segons"
	_TicksToTime($Timer, $tHour, $tMins, $tSecs)
	If $tHour = 1 Then $h = "Hora"
	If $tMins = 1 Then $m = "Minut"
	If $tSecs = 1 Then $s = "Segon"
	
	If $tMins = 0 Then
		Return StringFormat("%02i " & $s, $tSecs)
	ElseIf $tHour = 0 Then
		Return StringFormat("%02i " & $m & " i %02i " & $s, $tMins, $tSecs)
	Else
		Return StringFormat("%02i " & $h & ", %02i " & $m & " i %02i " & $s, $tHour, $tMins, $tSecs)
	EndIf
EndFunc   ;==>_GetTotalTime

Func _SetError($desc, $err, $ex, $iItem, $IP)
	_GUICtrlListView_SetItemImage($gcList, $iItem, 0)
	_GUICtrlListView_SetItemText($gcList, $iItem, $desc, 3)
	_GUICtrlListView_SetItemText($gcList, $iItem, "", 2)
	$text = _GUICtrlListView_GetGroupInfo($gcList, _GUICtrlListView_GetItemGroupID($gcList, $iItem))
	$REG_UERROR_Final = $REG_UERROR & "\" & $text[0] & "\" & $IP
	$uError = _GetTimeError(RegRead($REG_UERROR_Final, "UltimError"))
	If $uError <> "" And RegRead($REG_UERROR_Final, "Control") = 0 Then
		$uError = " | Últim Error Fa: " & $uError
	Else
		$uError = ""
	EndIf
	If $stop = 0 Then
		IniWrite($LOG_File, $IP, _NowCalc(), $desc & $uError)
	EndIf
	Return 1
EndFunc   ;==>_SetError

Func _GetTimeError($iDate)
	Local $iHour, $iMins, $iSecs
	If $iDate <> "" Then
		$sec = _DateDiff('s', $iDate, _NowCalc()) * 1000
		_TicksToTime($sec, $iHour, $iMins, $iSecs)
		Return StringFormat("%02d:%02d:%02d", $iHour, $iMins, $iSecs)
	Else
		Return ""
	EndIf
EndFunc   ;==>_GetTimeError

Func _ReduceMemory($i_PID = -1)
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall(@SystemDir & "\kernel32.dll", 'int', 'OpenProcess', 'int', 0x1F0FFF, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall(@SystemDir & "\psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall(@SystemDir & '\kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall(@SystemDir & "\psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf

    Return $ai_Return[0]
EndFunc  ;==>_ReduceMemory

Func EvaluateKey($keycode)
	If BitAND(WinGetState($GUI_Complet), 8) Then
		If $keycode = 116 Then
			If _IsEnable($gcStart) Then
				_Start(True)
			EndIf
		ElseIf $keycode = 117 Then
			If _IsEnable($gcStop) Then
				_Stop(True)
			EndIf
		ElseIf $keycode = 122 Then
			If $stop = 1 Then _ObrePingT()
		Else
			Return
		EndIf
	EndIf
EndFunc   ;==>EvaluateKey

Func _IsEnable($hID)
	If BitAND(GUICtrlGetState($hID), $GUI_ENABLE) = $GUI_ENABLE Then
		Return True
	Else
		Return False
	EndIf
EndFunc    ;==>_IsEnable
	
;===========================================================
; callback function
;===========================================================
Func _KeyProc($nCode, $wParam, $lParam)
	Local $tKEYHOOKS
	$tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
	EndIf
	If $wParam = $WM_KEYDOWN Then
		EvaluateKey(DllStructGetData($tKEYHOOKS, "vkCode"))
	EndIf
	Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
EndFunc   ;==>_KeyProc

Func OnAutoItExit()
	_WinAPI_UnhookWindowsHookEx($hHook)
	DllCallbackFree($hStub_KeyProc)
EndFunc   ;==>OnAutoItExit