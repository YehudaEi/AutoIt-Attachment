#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.9.18 (beta)
	Author:         FireFox

	Script Function:
	IP Camera

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <Constants.au3>
#include <WinAPI.au3>
#include <GDIPlus.au3>
#include <Memory.au3>

#region Global Vars
Global Const $_sProgramTitle = "IP Camera"
Global Const $_sIniFilePath = @ScriptDir & "\settings.ini"

Global Const $_iMaxCam = 1 ;EDIT HERE
Global Const $_iMaxHorzCam = (($_iMaxCam <= 2) ? $_iMaxCam : Ceiling($_iMaxCam / 2))

Global Const $STM_SETIMAGE = 0x0172

Global Const $SM_CXSIZEFRAME = 32, $_iBorderSize = _WinAPI_GetSystemMetrics($SM_CXSIZEFRAME)
Global $_iCaptionSize = _WinAPI_GetSystemMetrics($SM_CYCAPTION)

Global $_aPanelSize[2] = [320, 270]

Global Const $WMSZ_LEFT = 1, $WMSZ_RIGHT = 2, $WMSZ_TOP = 3, $WMSZ_BOTTOM = 6
Global Const $_iResizeRatio = (($_aPanelSize[0] * $_iMaxHorzCam) - $_iBorderSize * 2) / (($_aPanelSize[1] + 30) * Ceiling($_iMaxCam / $_iMaxHorzCam) - $_iBorderSize)

Global $_blGUIMinimized = False
Global Const $_sRecordDir = @ScriptDir & "\ipcamera_stream"

Global $gw_iStreamLen = 0, $iWritten = 0, $gw_iEOH = 0, $gw_iContLenPos = 0, $gw_hImgFile = 0, $gw_pBuffer = 0
Global Const $gw_iContLengthLen = StringLen("Content-Length: ")
Global $gw_bRecvtmp = "", $gw_sStream = "", $gw_sTrim2ContLen = ""
Global $gw_hBMP = 0, $gw_hGraphics = 0, $gw_hBITMAP2 = 0

Global $_hFamily = 0, $_hFont = 0, $_tLayout = 0, $_hFormat = 0, $_hBrush = 0

Global $_aCamData[$_iMaxCam][16]
Global Enum $index_hPaStream, $index_pPic, $index_hPic, $index_lMessage, $index_btnRecord, $index_btnSettings, _
		$index_blStreaming, $index_blRecording, $index_iSocket, $index_sIPAddress, $index_iPort, $index_sAuth, _
		$index_bStream, $index_iImgLen, $index_iImgCount, $index_iFramesCount

Global $_iSettingsCam = -1
#endregion Global Vars

TCPStartup()

#region GUI
AutoItSetOption("GUIOnEventMode", 1)

Global $_hGUI = GUICreate($_sProgramTitle, $_aPanelSize[0] * $_iMaxHorzCam, ($_aPanelSize[1] + 30) * Ceiling($_iMaxCam / $_iMaxHorzCam), -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
GUIRegisterMsg($WM_EXITSIZEMOVE, "WM_EXITSIZEMOVE")
GUIRegisterMsg($WM_SIZING, "WM_SIZING")

GUISetState(@SW_SHOW, $_hGUI)
#endregion GUI

#region GUISettings
Global $_hGUISettings = GUICreate("", 350, 370, -1, -1, -1, -1, $_hGUI)
GUISetOnEvent($GUI_EVENT_CLOSE, "_GUISettings_Hide")
GUISetFont(14)

#region GUI#Login
GUICtrlCreateGroup("Login", 10, 10, 330, 215)

GUICtrlCreateLabel("IP Address:", 30, 40, Default, 22)
Global $iInputIPAddress = GUICtrlCreateInput("", 30, 65, 180, 30)

GUICtrlCreateLabel("Port:", 220, 40, Default, 22)
Global $iInputPort = GUICtrlCreateInput("", 220, 65, 80, 30, $ES_NUMBER)
GUICtrlSetLimit(-1, 5, 0)

GUICtrlCreateLabel("Auth. (user:password) [optional]:", 30, 110, Default, 22)
Global $iInputAuth = GUICtrlCreateInput("", 30, 135, 270, 30)

Global $iBtnTryConnect = GUICtrlCreateButton("Try connect", 29, 180, 130, 35)
GUICtrlSetOnEvent($iBtnTryConnect, "_IPCam_TryConnect")

Global $iBtnApply = GUICtrlCreateButton("Apply", 170, 180, 80, 35)
GUICtrlSetOnEvent($iBtnApply, "_IPCam_SettingsApply")
#endregion GUI#Login

GUICtrlCreateGroup("Stream settings", 10, 240, 330, 120)

#region GUI#Brightness
Global $iLabelBrightness = GUICtrlCreateLabel("Brightness :", 30, 280, Default, 22)

Global $iInputBrightness = GUICtrlCreateInput("", 145, 275, 55, 30)
GUICtrlSetLimit($iInputBrightness, 2, 0)

Global $iUpdownBrightness = GUICtrlCreateUpdown($iInputBrightness)
GUICtrlSetLimit($iUpdownBrightness, 15, 0)
GUICtrlSetOnEvent($iUpdownBrightness, "_IPCam_Brightness")
#endregion GUI#Brightness

#region GUI#Contrast
GUICtrlCreateLabel("Contrast :", 30, 320)

Global $iInputContrast = GUICtrlCreateInput("", 145, 315, 55, 30)
GUICtrlSetLimit($iInputContrast, 2, 0)

Global $iUpdownContrast = GUICtrlCreateUpdown($iInputContrast)
GUICtrlSetLimit($iUpdownContrast, 6, 0)
GUICtrlSetOnEvent($iUpdownContrast, "_IPCam_Contrast")
#endregion GUI#Contrast

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
#endregion GUISettings

_Main()

While 1
	For $gw_iCam = 0 To $_iMaxCam - 1
		If ($_aCamData[$gw_iCam][$index_iSocket] = 0) Then ContinueLoop

		$gw_bRecvtmp = TCPRecv($_aCamData[$gw_iCam][$index_iSocket], 32768, 1) ;32 kiB
		If @error Then
;~ 			_IPCam_Disconnect($gw_iCam)
			ContinueLoop
		EndIf

		If BinaryLen($gw_bRecvtmp) = 0 Then ContinueLoop
		$_aCamData[$gw_iCam][$index_bStream] &= $gw_bRecvtmp

		If $_aCamData[$gw_iCam][$index_iImgLen] = 0 Then
			$gw_sStream = BinaryToString($_aCamData[$gw_iCam][$index_bStream])

			If Not $_aCamData[$gw_iCam][$index_blStreaming] Then
				$gw_iEOH = StringInStr($gw_sStream, @CRLF & @CRLF, 2)
				If $gw_iEOH > 0 Then
					$_aCamData[$gw_iCam][$index_blStreaming] = True
					$_aCamData[$gw_iCam][$index_bStream] = BinaryMid($_aCamData[$gw_iCam][$index_bStream], $gw_iEOH + 4)

					GUICtrlSetState($_aCamData[$gw_iCam][$index_lMessage], $GUI_HIDE)
					GUICtrlSetData($_aCamData[$gw_iCam][$index_lMessage], "")
					ContinueLoop
				EndIf
			EndIf

			$gw_iContLenPos = StringInStr($gw_sStream, "Content-Length: ", 2)
			$gw_iEOH = StringInStr($gw_sStream, @CRLF & @CRLF, 2, 1, $gw_iContLenPos)

			If $gw_iEOH = 0 Or $gw_iContLenPos = 0 Then ContinueLoop

			$gw_sTrim2ContLen = StringTrimLeft($gw_sStream, $gw_iContLenPos + $gw_iContLengthLen - 1)

			$_aCamData[$gw_iCam][$index_iImgLen] = Number(StringLeft($gw_sTrim2ContLen, StringInStr($gw_sTrim2ContLen, @CR, 2) - 1))

			$_aCamData[$gw_iCam][$index_bStream] = BinaryMid($_aCamData[$gw_iCam][$index_bStream], $gw_iEOH + 4)
		EndIf

		If $_aCamData[$gw_iCam][$index_iImgLen] = 0 Then ContinueLoop

		$gw_iStreamLen = BinaryLen($_aCamData[$gw_iCam][$index_bStream])
		If $gw_iStreamLen < $_aCamData[$gw_iCam][$index_iImgLen] Then ContinueLoop

		If Not $_blGUIMinimized Then
			$gw_hBMP = _GDIPlus_BitmapCreateFromMemory($_aCamData[$gw_iCam][$index_bStream])
			If $gw_hBMP = 0 Then
				$_aCamData[$gw_iCam][$index_bStream] = ""
				ContinueLoop
			EndIf

			If $_aCamData[$gw_iCam][$index_blRecording] Then
				$gw_hGraphics = _GDIPlus_ImageGetGraphicsContext($gw_hBMP)
				_GDIPlus_GraphicsDrawStringEx($gw_hGraphics, "[•REC]", $_hFont, $_tLayout, $_hFormat, $_hBrush)
			EndIf

			$gw_hBMP = _GDIPlus_ScaleImage($gw_hBMP, $_aPanelSize[0], $_aPanelSize[1] - 35)

			$gw_hBITMAP2 = __GDIPlus_BitmapCreateDIBFromBitmap($gw_hBMP)

			_WinAPI_DeleteObject(_SendMessage($_aCamData[$gw_iCam][$index_hPic], $STM_SETIMAGE, 0, $gw_hBITMAP2))

			_WinAPI_DeleteObject($gw_hBITMAP2)

			_GDIPlus_ImageDispose($gw_hBMP)
			If $_aCamData[$gw_iCam][$index_blRecording] Then _GDIPlus_GraphicsDispose($gw_hGraphics)
		EndIf

		If $_aCamData[$gw_iCam][$index_blRecording] Then
			$gw_pBuffer = DllStructCreate("byte[" & $_aCamData[$gw_iCam][$index_iImgLen] & "]")

			If $gw_iStreamLen > $_aCamData[$gw_iCam][$index_iImgLen] Then
				DllStructSetData($gw_pBuffer, 1, BinaryMid($_aCamData[$gw_iCam][$index_bStream], 1, $_aCamData[$gw_iCam][$index_iImgLen]))
			Else
				DllStructSetData($gw_pBuffer, 1, $_aCamData[$gw_iCam][$index_bStream])
			EndIf

			$gw_hImgFile = _WinAPI_CreateFile($_sRecordDir & "\snap-cam" & ($gw_iCam + 1) & "_" & StringFormat("%.4d", $_aCamData[$gw_iCam][$index_iImgCount]) & ".jpg", 3, 4, 4)
			_WinAPI_WriteFile($gw_hImgFile, DllStructGetPtr($gw_pBuffer), $_aCamData[$gw_iCam][$index_iImgLen], $iWritten)
			_WinAPI_CloseHandle($gw_hImgFile)

			$_aCamData[$gw_iCam][$index_iImgCount] += 1
		EndIf

		If $gw_iStreamLen > $_aCamData[$gw_iCam][$index_iImgLen] Then
			$_aCamData[$gw_iCam][$index_bStream] = BinaryMid($_aCamData[$gw_iCam][$index_bStream], $_aCamData[$gw_iCam][$index_iImgLen])
		Else
			$_aCamData[$gw_iCam][$index_bStream] = ""
		EndIf

		$_aCamData[$gw_iCam][$index_iImgLen] = 0
	Next
WEnd

Func _Main()
	_GDIPlus_Startup()

	$_hFamily = _GDIPlus_FontFamilyCreate("Arial")
	$_hFont = _GDIPlus_FontCreate($_hFamily, 17)
	$_tLayout = _GDIPlus_RectFCreate(10, 10, 100, 40)
	$_hFormat = _GDIPlus_StringFormatCreate()
	$_hBrush = _GDIPlus_BrushCreateSolid(0xAFFF0000)

	Local $aValidCam[$_iMaxCam]

	For $iCam = 0 To $_iMaxCam - 1
		_IPCam_Add($iCam)

		$_aCamData[$iCam][$index_sIPAddress] = IniRead($_sIniFilePath, "Cam" & $iCam, "ip", "")
		$_aCamData[$iCam][$index_iPort] = Number(IniRead($_sIniFilePath, "Cam" & $iCam, "port", ""))
		$_aCamData[$iCam][$index_sAuth] = IniRead($_sIniFilePath, "Cam" & $iCam, "auth", "")

		If $_aCamData[$iCam][$index_sIPAddress] = "" _
				Or $_aCamData[$iCam][$index_iPort] = 0 Then
			$aValidCam[$iCam] = False
			GUICtrlSetData($_aCamData[$iCam][$index_lMessage], "No valid camera.")
		Else
			$aValidCam[$iCam] = True
		EndIf
	Next

	For $iCam = 0 To $_iMaxCam - 1
		If Not $aValidCam[$iCam] Then ContinueLoop

		_IPCam_ProcessConnect($iCam)
	Next
EndFunc   ;==>_Main

Func _IPCam_ProcessConnect($iCam)
	GUICtrlSetData($_aCamData[$iCam][$index_lMessage], "Connecting...")
	GUICtrlSetState($_aCamData[$iCam][$index_lMessage], $GUI_SHOW)

	$_aCamData[$iCam][$index_iSocket] = _IPCam_Connect($iCam)
	If @error Then
		GUICtrlSetData($_aCamData[$iCam][$index_lMessage], "Could not connect !")
		Return 0
	Else
		GUICtrlSetData($_aCamData[$iCam][$index_lMessage], "Waiting for stream...")

		_IPCam_LoginAndStream($iCam)
	EndIf
EndFunc   ;==>_IPCam_ProcessConnect

Func _IPCam_Add($iCam)
	Local $aPos = _GetPanelPos($iCam)

	$_aCamData[$iCam][$index_hPaStream] = GUICreate("", $aPos[2], $aPos[3], $aPos[0], $aPos[1], $WS_CHILD, -1, $_hGUI)

	$_aCamData[$iCam][$index_pPic] = GUICtrlCreatePic("", 0, 0, $aPos[2], $aPos[3] - 35, BitOR($SS_BITMAP, $SS_CENTERIMAGE))
	GUICtrlSetResizing($_aCamData[$iCam][$index_pPic], $GUI_DOCKBORDERS)
	GUICtrlSetState($_aCamData[$iCam][$index_pPic], $GUI_DISABLE)
	$_aCamData[$iCam][$index_hPic] = GUICtrlGetHandle($_aCamData[$iCam][$index_pPic])

	$_aCamData[$iCam][$index_lMessage] = GUICtrlCreateLabel("", 0, $aPos[3] / 2 - 10, $aPos[2], 20, $SS_CENTER)
	GUICtrlSetFont($_aCamData[$iCam][$index_lMessage], 12)
	GUICtrlSetBkColor($_aCamData[$iCam][$index_lMessage], $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetResizing($_aCamData[$iCam][$index_lMessage], BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKVCENTER, $GUI_DOCKHEIGHT))

	GUICtrlCreateGroup("", 0, $aPos[3] - 41, $aPos[2], 41)
	GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKHEIGHT))

	$_aCamData[$iCam][$index_btnRecord] = GUICtrlCreateButton("Record", 10, $aPos[3] - 29, 80, 22)
	GUICtrlSetOnEvent($_aCamData[$iCam][$index_btnRecord], "_IPCam_Record")
	GUICtrlSetResizing($_aCamData[$iCam][$index_btnRecord], BitOR($GUI_DOCKLEFT, $GUI_DOCKBOTTOM, $GUI_DOCKSIZE))

	$_aCamData[$iCam][$index_btnSettings] = GUICtrlCreateButton("Settings...", 105, $aPos[3] - 29, 80, 22)
	GUICtrlSetOnEvent($_aCamData[$iCam][$index_btnSettings], "_IPCam_Settings")
	GUICtrlSetResizing($_aCamData[$iCam][$index_btnSettings], BitOR($GUI_DOCKLEFT, $GUI_DOCKBOTTOM, $GUI_DOCKSIZE))

	GUISetState(@SW_SHOWNOACTIVATE, $_aCamData[$iCam][$index_hPaStream])

	GUISwitch($_hGUI)
EndFunc   ;==>_IPCam_Add

Func _IPCam_Connect($iCam)
	Local $iSocket2 = TCPConnect($_aCamData[$iCam][$index_sIPAddress], $_aCamData[$iCam][$index_iPort])
	If @error Then Return SetError(1, 0, 0)

	Return $iSocket2
EndFunc   ;==>_IPCam_Connect

Func _IPCam_Disconnect($iCam)
	If $_aCamData[$iCam][$index_iSocket] > 0 Then
		TCPCloseSocket($_aCamData[$iCam][$index_iSocket])
		$_aCamData[$iCam][$index_iSocket] = 0
	EndIf

	$_aCamData[$iCam][$index_blStreaming] = False
	$_aCamData[$iCam][$index_blRecording] = False

	$_aCamData[$iCam][$index_bStream] = ""
	$_aCamData[$iCam][$index_iImgLen] = 0
EndFunc   ;==>_IPCam_Disconnect

Func _IPCam_Settings()
	For $iCam = 0 To $_iMaxCam - 1
		If $_aCamData[$iCam][$index_btnSettings] = @GUI_CtrlId Then ExitLoop
	Next

	$_iSettingsCam = $iCam

	GUICtrlSetData($iInputIPAddress, $_aCamData[$iCam][$index_sIPAddress])
	GUICtrlSetData($iInputPort, (($_aCamData[$iCam][$index_iPort] = 0) ? "" : $_aCamData[$iCam][$index_iPort]))

	GUICtrlSetData($iInputAuth, $_aCamData[$iCam][$index_sAuth])

	If $_aCamData[$iCam][$index_blStreaming] Then
		GUICtrlSetState($iInputBrightness, $GUI_ENABLE)
		GUICtrlSetState($iInputContrast, $GUI_ENABLE)
	Else
		GUICtrlSetState($iInputBrightness, $GUI_DISABLE)
		GUICtrlSetState($iInputContrast, $GUI_DISABLE)
	EndIf

	WinSetTitle($_hGUISettings, "", "Settings Cam" & ($iCam + 1) & " - " & $_sProgramTitle)

	GUISetState(@SW_SHOW, $_hGUISettings)
	GUISetState(@SW_DISABLE, $_hGUI)
EndFunc   ;==>_IPCam_Settings

Func _GUISettings_Hide()
	GUISetState(@SW_ENABLE, $_hGUI)
	GUISetState(@SW_HIDE, $_hGUISettings)

	$_iSettingsCam = -1
EndFunc   ;==>_GUISettings_Hide

Func _IPCam_SettingsApply()
	$_aCamData[$_iSettingsCam][$index_sIPAddress] = GUICtrlRead($iInputIPAddress)
	$_aCamData[$_iSettingsCam][$index_iPort] = Number(GUICtrlRead($iInputPort))
	$_aCamData[$_iSettingsCam][$index_sAuth] = GUICtrlRead($iInputAuth)

	_IPCam_Disconnect($_iSettingsCam)

	If $_aCamData[$_iSettingsCam][$index_sIPAddress] <> "" _
			And $_aCamData[$_iSettingsCam][$index_iPort] > 0 Then
		Local $aIniData[3][2] = [["ip", $_aCamData[$_iSettingsCam][$index_sIPAddress]],["port", $_aCamData[$_iSettingsCam][$index_iPort]],["auth", $_aCamData[$_iSettingsCam][$index_sAuth]]]
		IniWriteSection($_sIniFilePath, "Cam" & $_iSettingsCam, $aIniData, 0)

		_IPCam_ProcessConnect($_iSettingsCam)
	Else
		$_aCamData[$_iSettingsCam][$index_sIPAddress] = ""
		$_aCamData[$_iSettingsCam][$index_iPort] = 0
		$_aCamData[$_iSettingsCam][$index_sAuth] = ""

		IniDelete($_sIniFilePath, "Cam" & $_iSettingsCam)

		GUICtrlSetImage($_aCamData[$_iSettingsCam][$index_pPic], "")
		_WinAPI_RedrawWindow($_hGUI)

		GUICtrlSetData($_aCamData[$_iSettingsCam][$index_lMessage], "No valid camera.")
		GUICtrlSetState($_aCamData[$_iSettingsCam][$index_lMessage], $GUI_SHOW)
	EndIf

	_GUISettings_Hide()
EndFunc   ;==>_IPCam_SettingsApply

Func _IPCam_TryConnect()
	GUISetState(@SW_DISABLE, $_hGUISettings)
	GUICtrlSetState($iBtnTryConnect, $GUI_DISABLE)

	Local $iSocket = TCPConnect(GUICtrlRead($iInputIPAddress), Number(GUICtrlRead($iInputPort)))
	If @error Then
		MsgBox($MB_ICONHAND, $_sProgramTitle, "Could not connect !", 0, $_hGUISettings)
	Else
		TCPCloseSocket($iSocket)

		MsgBox($MB_ICONASTERISK, $_sProgramTitle, "Connection successful.", 0, $_hGUISettings)
	EndIf

	GUICtrlSetState($iBtnTryConnect, $GUI_ENABLE)
	GUISetState(@SW_ENABLE, $_hGUISettings)
EndFunc   ;==>_IPCam_TryConnect

Func _IPCam_LoginAndStream($iCam)
	TCPSend($_aCamData[$iCam][$index_iSocket], _IPCam_GenerateHeader($iCam))
EndFunc   ;==>_IPCam_LoginAndStream

Func _IPCam_GenerateHeader($iCam, $sParams = Default)
	Return "GET /" & (($sParams = Default ? "videostream.cgi" : "camera_control.cgi?" & $sParams)) & " HTTP/1.1" & @CRLF & _
			"Host: " & $_aCamData[$iCam][$index_sIPAddress] & ":" & $_aCamData[$iCam][$index_iPort] & @CRLF & _
			"Connection: keep-alive" & @CRLF & _
			(($_aCamData[$iCam][$index_sAuth] = "") ? "" : "Authorization: Basic " & _Base64Encode($_aCamData[$iCam][$index_sAuth]) & @CRLF) & _
			@CRLF
EndFunc   ;==>_IPCam_GenerateHeader

Func _IPCam_Brightness()
	Local $iBrightness = Number(GUICtrlRead($iInputBrightness))
	If $iBrightness > 15 Then $iBrightness = 15
	If $iBrightness < 0 Then $iBrightness = 0

	Local $iSocket = _IPCam_Connect($_iSettingsCam)
	TCPSend($iSocket, _IPCam_GenerateHeader($_iSettingsCam, "param=1&value=" & ($iBrightness * 16)))
	TCPCloseSocket($iSocket)
EndFunc   ;==>_IPCam_Brightness

Func _IPCam_Contrast()
	Local $iContrast = Number(GUICtrlRead($iInputContrast))
	If $iContrast > 6 Then $iContrast = 6
	If $iContrast < 0 Then $iContrast = 0

	Local $iSocket = _IPCam_Connect($_iSettingsCam)
	TCPSend($iSocket, _IPCam_GenerateHeader($_iSettingsCam, "param=2&value=" & $iContrast))
	TCPCloseSocket($iSocket)
EndFunc   ;==>_IPCam_Contrast

Func _IPCam_Record()
	For $iCam = 0 To $_iMaxCam - 1
		If $_aCamData[$iCam][$index_btnRecord] = @GUI_CtrlId Then ExitLoop
	Next

	If Not $_aCamData[$iCam][$index_blRecording] Then
		If FileExists($_sRecordDir) = 0 Then DirCreate($_sRecordDir)

		GUICtrlSetData($_aCamData[$iCam][$index_btnRecord], "Stop rec.")
	Else
		GUICtrlSetData($_aCamData[$iCam][$index_btnRecord], "Record")
	EndIf

	$_aCamData[$iCam][$index_blRecording] = Not $_aCamData[$iCam][$index_blRecording]
EndFunc   ;==>_IPCam_Record

Func _GetPanelPos($iPanel)
	Local $aWinPos = WinGetPos($_hGUI)

	$aWinPos[2] = Round(($aWinPos[2] - $_iBorderSize * 2) / $_iMaxHorzCam)
	$aWinPos[3] = Round(($aWinPos[3] - ($_iCaptionSize + $_iBorderSize * 2)) / Ceiling($_iMaxCam / $_iMaxHorzCam))

	Local $iLeft = 0, $iTop = 0

	For $iCam = 0 To $_iMaxCam - 1
		If $iCam > 0 And Mod($iCam, $_iMaxHorzCam) = 0 Then
			$iLeft = 0
			$iTop += $aWinPos[3]
		EndIf

		If $iCam = $iPanel Then ExitLoop

		$iLeft += $aWinPos[2]
	Next

	$aWinPos[0] = $iLeft
	$aWinPos[1] = $iTop

	Global $_aPanelSize[2] = [$aWinPos[2], $aWinPos[3]]

	Return $aWinPos
EndFunc   ;==>_GetPanelPos

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $iIDFrom = 0, $iCode = 0

	$iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
	$iCode = BitShift($iwParam, 16) ; Hi Word

	Switch $iIDFrom
		Case $iInputBrightness
			Switch $iCode
				Case $EN_UPDATE
					_IPCam_Brightness()
			EndSwitch
		Case $iInputContrast
			Switch $iCode
				Case $EN_UPDATE
					_IPCam_Contrast()
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_ACTIVATE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam

	$_blGUIMinimized = False

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_ACTIVATE

Func WM_SYSCOMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local Const $SC_MINIMIZE = 0xF020, $SC_RESTORE = 0xF120

	Switch BitAND($iwParam, 0xFFF0)
		Case $SC_MINIMIZE, $SC_RESTORE
			$_blGUIMinimized = Not $_blGUIMinimized
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SYSCOMMAND

Func WM_GETMINMAXINFO($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam

	Local Const $tagMINMAXINFO = "struct; long ReservedX;long ReservedY;long MaxSizeX;long MaxSizeY;long MaxPositionX;long MaxPositionY;" & _
			"long MinTrackSizeX;long MinTrackSizeY;long MaxTrackSizeX;long MaxTrackSizeY; endstruct"

	Local $tMINMAXINFO = DllStructCreate($tagMINMAXINFO, $ilParam)

	DllStructSetData($tMINMAXINFO, "MinTrackSizeX", (190 + ($_iBorderSize * 2)) * $_iMaxHorzCam)
	DllStructSetData($tMINMAXINFO, "MinTrackSizeY", (Int((190 + ($_iCaptionSize + $_iBorderSize * 2)) / 1.33) + 30) * Ceiling($_iMaxCam / $_iMaxHorzCam))

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_GETMINMAXINFO

Func WM_EXITSIZEMOVE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam

	Local $aPanelPos = 0
	For $iPanel = 0 To $_iMaxCam - 1
		$aPanelPos = _GetPanelPos($iPanel)
		_WinAPI_MoveWindow($_aCamData[$iPanel][$index_hPaStream], $aPanelPos[0], $aPanelPos[1], $aPanelPos[2], $aPanelPos[3])
	Next

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_EXITSIZEMOVE

Func WM_SIZING($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam

	Local $tRECT = DllStructCreate($tagRECT, $ilParam)

	Switch Int($iwParam)
		Case $WMSZ_LEFT, $WMSZ_RIGHT, $WMSZ_RIGHT + $WMSZ_BOTTOM
			DllStructSetData($tRECT, "Bottom", DllStructGetData($tRECT, "Top") + Int((DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")) / $_iResizeRatio))
		Case $WMSZ_TOP, $WMSZ_BOTTOM
			DllStructSetData($tRECT, "Right", DllStructGetData($tRECT, "Left") + Int((DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")) * $_iResizeRatio))
		Case $WMSZ_LEFT + $WMSZ_TOP
			DllStructSetData($tRECT, "Left", DllStructGetData($tRECT, "Right") + Int((DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")) * $_iResizeRatio))
	EndSwitch

	Return _WinAPI_DefWindowProc($hWnd, $iMsg, DllStructGetPtr($tRECT), $ilParam)
EndFunc   ;==>WM_SIZING

Func _Exit()
	GUIDelete($_hGUI)

	For $iCam = 0 To $_iMaxCam - 1
		TCPCloseSocket($_aCamData[$iCam][$index_iSocket])
	Next
	TCPShutdown()

	_GDIPlus_FontFamilyDispose($_hFamily)
	_GDIPlus_FontDispose($_hFont)
	$_tLayout = 0
	_GDIPlus_StringFormatDispose($_hFormat)
	_GDIPlus_BrushDispose($_hBrush)

	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_Exit

Func _GDIPlus_ScaleImage($hImage, $iW, $iH, $iInterpolationMode = 7)
	;Author: UEZ
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iW, $iH, 0, $GDIP_PXF32ARGB, 0)
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetInterpolationMode($hBmpCtxt, $iInterpolationMode)
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iW, $iH)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	Return $hBitmap
EndFunc   ;==>_GDIPlus_ScaleImage

Func _Base64Encode($input)
	;Author: trancexx
	$input = Binary($input)

	Local $struct = DllStructCreate("byte[" & BinaryLen($input) & "]")

	DllStructSetData($struct, 1, $input)

	Local $strc = DllStructCreate("int")

	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
			"ptr", DllStructGetPtr($struct), _
			"int", DllStructGetSize($struct), _
			"int", 1, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($strc))

	If @error Or Not $a_Call[0] Then
		Return SetError(1, 0, "") ; error calculating the length of the buffer needed
	EndIf

	Local $a = DllStructCreate("char[" & DllStructGetData($strc, 1) & "]")

	$a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
			"ptr", DllStructGetPtr($struct), _
			"int", DllStructGetSize($struct), _
			"int", 1, _
			"ptr", DllStructGetPtr($a), _
			"ptr", DllStructGetPtr($strc))

	If @error Or Not $a_Call[0] Then
		Return SetError(2, 0, ""); error encoding
	EndIf

	Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Encode
