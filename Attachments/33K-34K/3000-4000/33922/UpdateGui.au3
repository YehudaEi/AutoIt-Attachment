;===============================================================================
; Function Name: 	_CreateUpdateGUI()
;
; Description: 		Update-GUI erstellen, indem Dateien zum Download angezeigt werden
;
; Parameters: 
; 					$sWindowTitel - Titel des Fensters
;					$sServerUrl - Url zum Server, auf dem die Dateiliste liegt
;					$sFilePathOnServer - Pfad zum Ordner auf dem Server, indem die Downloaddateien liegen
;					$sDataTextPathOnServer - Vollständiger Pfad auf dem Server, indem die Dateiliste liegt
;
; Requirements:
;					#include <GUIConstantsEx.au3>
;					#include <File.au3>
;					#include <GuiListView.au3>
;
; Return Values: 	@error:
;							1 - Erfolg
;						   -1 - Server auf dem die Dateien liegen ist nicht erreichbar
; 						   -2 - Keine Internetverbindung
;
; Author:   	 	Jautois (autoit.report@web.de)
;===============================================================================

#include <GUIConstantsEx.au3>
#include <File.au3>
#include <GuiListView.au3>

Func _CreateUpdateGUI($sWindowTitel, $sServerUrl, $sDataTextPathOnServer, $sFilePathOnServer)
	Local $hUpdateWindow, $sTempData, $iPercent = 0

	$hUpdateWindow = GUICreate($sWindowTitel, 472, 330)
	GUISetBkColor(0xBFCDDB)
	GUISetIcon(@SystemDir & "\shell32.dll", -14)
	$pDlProgress = GUICtrlCreateProgress(72, 24, 390, 25)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$pInternetIcon = GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -136, 20, 20)
	$pInternetErrorIcon = GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -220, 20, 20)
	GUICtrlSetState($pInternetErrorIcon, $GUI_HIDE)
	$pArrIcon = GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -268, 74, 50)
	$pListView = GUICtrlCreateListView("Dateiname|Version|Größe|Autor", 8, 80, 455, 201)
	GUICtrlSendMsg(-1, 0x101E, 0, 150)
	GUICtrlSendMsg(-1, 0x101E, 1, 100)
	GUICtrlSendMsg(-1, 0x101E, 2, 100)
	GUICtrlSendMsg(-1, 0x101E, 3, 100)
	$pButtonDL = GUICtrlCreateButton("Download", 200, 288, 129, 33, 0)
	$pButtonExit = GUICtrlCreateButton("Beenden", 334, 288, 129, 33, 0)
	$pLabelInfo = GUICtrlCreateLabel("", 100, 60, 340, 17)
	$pCheckboxDirOpen = GUICtrlCreateCheckbox("Ordner nach Download öffnen", 8, 288, 185, 17)
	$pCheckboxProClose = GUICtrlCreateCheckbox("Programm nach Download schließen", 8, 304, 190, 17)
	GUISetState(@SW_SHOW, $hUpdateWindow)

	Ping("www.google.de")
	If @error Then
		GUICtrlSetState($pInternetErrorIcon, $GUI_SHOW)
		GUICtrlSetData($pLabelInfo, "Keine Internetverbindung!")
		SetError(-2)
	Else
		Ping($sServerUrl)
		If @error Then
			GUICtrlSetState($pInternetErrorIcon, $GUI_SHOW)
			GUICtrlSetData($pLabelInfo, "Server nicht erreichbar!")
			SetError(-1)
		Else
			InetGet($sDataTextPathOnServer, @TempDir & "\data.txt", 1)
			_FileReadToArray(@TempDir & "\data.txt", $sTempData)
			GUICtrlSetData($pLabelInfo, "Informationen werden heruntergeladen ...")
			Dim $iDataFileSize[$sTempData[0] + 1]
			For $i = 1 To $sTempData[0]
				$iPercent = $iPercent + (100 / $sTempData[0])
				$sTempDataForRow = StringSplit($sTempData[$i], ",")
				$iDataFileSize[$i] = Round(InetGetSize($sFilePathOnServer & $sTempDataForRow[1]) / 1000)
				$ListView1_0 = GUICtrlCreateListViewItem($sTempDataForRow[1] & "|" & $sTempDataForRow[2] & "|" & $iDataFileSize[$i] & " KB|" & $sTempDataForRow[3], $pListView)
				GUICtrlSetData($pDlProgress, $iPercent)
			Next
			$iPercent = 0
			GUICtrlSetData($pDlProgress, $iPercent)
			GUICtrlSetData($pLabelInfo, "Informationen heruntergeladen!")
			SetError(1)
		EndIf

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					ExitLoop
				Case $pButtonDL
					$iDirOpen = GUICtrlRead($pCheckboxDirOpen)
					$iProClose = GUICtrlRead($pCheckboxProClose)
					$iTempIndex = _GUICtrlListView_GetSelectedIndices($pListView, True)
					$sNameSelectedFile = _GUICtrlListView_GetItemText($pListView, $iTempIndex[1])
					GUICtrlSetData($pLabelInfo, $sNameSelectedFile & " wird heruntergeladen")
					$sSaveFilePath = FileSelectFolder("Speichern unter ... ", @DesktopDir, 7, @DesktopDir)
					If @error = 1 Then
						;-
					Else
						InetGet($sFilePathOnServer & $sNameSelectedFile, $sSaveFilePath & "\" & $sNameSelectedFile, 1, 1)
						While @InetGetActive
							GUICtrlSetData($pDlProgress, (@InetGetBytesRead / $iDataFileSize[$iTempIndex[1] + 1] / 10))
							GUICtrlSetData($pLabelInfo, "Download: " & $sNameSelectedFile & " - " & Int(@InetGetBytesRead / 1000) & "/" & $iDataFileSize[$iTempIndex[1] + 1] & " KB - " & Int((@InetGetBytesRead / $iDataFileSize[$iTempIndex[1] + 1] / 10)) & " %")
							Sleep(100)
						WEnd
						GUICtrlSetData($pDlProgress, 100)
						GUICtrlSetData($pLabelInfo, "Fertig geladen!")
						Sleep(1000)
						WinFlash($sWindowTitel, "", 5)
					EndIf
					If $iDirOpen = 1 Then
						Run('explorer "' & $sSaveFilePath & '"')
					EndIf
					If $iProClose = 1 Then
						ExitLoop
					EndIf
				Case $pButtonExit
					ExitLoop
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>_CreateUpdateGUI