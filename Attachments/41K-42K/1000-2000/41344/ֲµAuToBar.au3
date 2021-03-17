#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Oxygen-Icons.org-Oxygen-Status-user-invisible.ico
#AutoIt3Wrapper_Compile_Both=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
;http://www.iconarchive.com/show/oxygen-icons-by-oxygen-icons.org/Status-user-invisible-icon.html
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <UpdownConstants.au3>
#include <Constants.au3>

Global Const $uT_GUILimit = 10

Global $uT_oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1"), $uT_oERROR = ObjEvent("AutoIt.Error", "__uT_Error")

Opt("GUIOnEventMode", 1)

Global Const $uT_HTTPREQUEST_SETCREDENTIALS_FOR_SERVER = 0, $uT_HTTPREQUEST_SETCREDENTIALS_FOR_PROXY = 1, _
		$uT_HTTPREQUEST_PROXYSETTING_DEFAULT = 0, $uT_HTTPREQUEST_PROXYSETTING_PRECONFIG = 0, _
		$uT_HTTPREQUEST_PROXYSETTING_DIRECT = 1, $uT_HTTPREQUEST_PROXYSETTING_PROXY = 2


Global $uT_Password = Default, $uT_Settings, $bValidSettings = False, $uT_Started = False, $uT_RM = Default
Global $uT_LastBar = Default, $uT_CM = Default, $uT_Paused = False, $uT_PM = Default, $uT_DM = Default
Global $uT_SID = "~", $uT_SIDc = StringLen($uT_SID), $uT_StatusColors = True, $uT_TrayState[10][3]

Global $sINI = @ScriptDir & "\µAuToBar.ini"

; Tray Icon/Menu Configuration
Opt("TrayOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 15)
Opt("TrayIconDebug", 0)
TraySetToolTip("µAuToBar")

; Tray Icon Menu Creation
TrayItemSetOnEvent(TrayCreateItem("Config"), "__uT_Configure")
$uT_DM = TrayCreateMenu("Display")

$uT_PM = TrayCreateItem("Pause")
TrayItemSetOnEvent($uT_PM, "__uT_Suspend")
$uT_EX = TrayCreateItem("Exit")
TrayItemSetOnEvent($uT_EX, "__uT_Exit")

__uT_Startup() ; Read settings from an INI file or prompt the user for server login information. Settings will be validated to an extent.

Do
	Sleep(100) ; I've noticed on windows 7 that if there isn't some sort of sleep then the CPU usage will report extremely high during an empty loop's execution
Until $bValidSettings ; Either $bValidSettings will become true VIA onevent functions or those functions will cause the program to exit

If UBound($uT_Settings) = 16 Then ; Settings integrity check
	If $uT_Settings[5] Then ; If the utorrent password index of the settings array isn't blank then give the global variable $uT_Password its value
		$uT_Password = $uT_Settings[5]
	ElseIf $uT_Password = Default Or $uT_Password = "" Or $uT_Settings[4] = "" Then ; Ensure we have a password
		MsgBox(262144, "µAuToBar", "Invalid username/password configuration! µAuToBar will now close.", 10)
		FileDelete(@ScriptDir & "\µAuToBar.ini") ; Delete the configuration file to allow for reconfiguration
		Exit
	Else
		$uT_Settings[5] = $uT_Password  ; Index #5 of the settings array may be blank if the user didn't choose to have their password stored. If $uT_Password isn't default then we'll use its value instead
	EndIf
Else
	MsgBox(262144, "µAuToBar", "Invalid configuration! µAuToBar cannot continue.", 10) ; The integrity check failed.
	FileDelete(@ScriptDir & "\µAuToBar.ini") ; Delete the configuration file to allow for reconfiguration
	Exit
EndIf

$uT_Started = True ; Settings have been validated

__uT_Auth($uT_Settings[4], $uT_Settings[5], $uT_Settings[2], $uT_Settings[3]) ; Set IP, Port, User, and Pass
If Int($uT_Settings[13]) = $GUI_CHECKED Then ; If the Proxy setting is enabled then check for credentials
	If $uT_Settings[11] <> "" And $uT_Settings[12] <> "" Then ; If both proxy user and pass are not blank then set proxy with credentials
		__uT_SetProxy($uT_Settings[9], $uT_Settings[10], $uT_Settings[11], $uT_Settings[12])
	Else ; Set proxy IP and Port without authentication
		__uT_SetProxy($uT_Settings[9], $uT_Settings[10])
	EndIf
EndIf

Global $aTorrent = __uT_GetList(), $aLast = $aTorrent, $aTemp[1][1], $iDefaultSleep = 1000, $iDelay = 10000, $iUbound, $uT_BarUpdate = 0, $iBarCount = 0
Global $uT_Limit = 11

While 1
	$iUbound = UBound($aTorrent, 2)
	If (UBound($aTorrent, 1) < 11) Or ($iUbound < 1) Then
		$aTorrent = $aTemp
		$iUbound = 1
		$iSleep = $iDelay
	Else
		$iSleep = $iDefaultSleep
	EndIf
	For $i = 0 To UBound($aLast, 2) - 1 Step 1
		For $n = 0 To $iUbound - 1 Step 1
			If $aTorrent[0][$n] = $aLast[0][$i] Then ExitLoop
			If $n = $iUbound - 1 Then
				__uT_Bar($aLast[0][$i], False)
			EndIf
		Next
	Next
	$aLast = $aTorrent
	$bSleep = True
	__uT_StateList()
	For $i = 0 To $iUbound - 1 Step 1
		If $i = 0 And UBound($aTorrent, 1) < 2 Then ExitLoop
		If $aTorrent[1][$i] And __uT_TrayStateMatch($i) Then
			$iBarCount = __uT_Bar($aTorrent[0][$i], $aTorrent[2][$i], Int($aTorrent[4][$i] / 10), __uT_GetSpeed($aTorrent[9][$i]), _
					__uT_GetSpeed($aTorrent[8][$i]), __uT_GetETA($aTorrent[10][$i]), $aTorrent[21][$i])
			If $iBarCount = 1 Then $uT_BarUpdate += 1
			$bSleep = False
		EndIf
		If $uT_BarUpdate >= $uT_Limit - 1 Then ExitLoop
	Next
	$uT_BarUpdate = 0
	If $bSleep Then $iSleep = $iDelay
	Sleep($iSleep)
	While $uT_Paused
		Sleep(100)
	WEnd
	$aTorrent = __uT_GetList()
WEnd

Func __uT_TrayStateMatch($iT)
	If Not UBound($aTorrent, 2) Or UBound($aTorrent, 1) < 22 Then Return SetError(1, 0, False)
	For $i = 0 To UBound($uT_TrayState, 1) - 1 Step 1
		If $uT_TrayState[$i][0] = "" Then ContinueLoop
		If $uT_TrayState[$i][2] And $aTorrent[21][$iT] == $uT_TrayState[$i][0] Then Return True
	Next
EndFunc

Func __uT_StateList()
	Local $iUbound = UBound($aTorrent, 2)
	If Not $iUbound Or UBound($aTorrent, 1) < 22 Then Return SetError(1, 0, "")
	For $i = 0 To $iUbound - 1 Step 1
		If Not __uT_TrayHasState($aTorrent[21][$i]) Then __uT_TrayCreateState($aTorrent[21][$i])
	Next
	__uT_CheckStateList()
EndFunc

Func __uT_ToggleTrayState(ByRef $iState, $iTrayID)
	If Not IsDeclared("aLast") Or Not UBound($aLast) Then Return
	If $uT_TrayState[$iState][2] = True Then
		$uT_TrayState[$iState][2] = False
		TrayItemSetState($iTrayID, $TRAY_UNCHECKED)
		IniWrite($sINI, "µTrayState", $uT_TrayState[$iState][0], $TRAY_UNCHECKED)
	Else
		$uT_TrayState[$iState][2] = True
		TrayItemSetState($iTrayID, $TRAY_CHECKED)
		IniWrite($sINI, "µTrayState", $uT_TrayState[$iState][0], $TRAY_CHECKED)
	EndIf
	For $i = 0 To UBound($aLast, 2) - 1 Step 1
		__uT_Bar($aLast[0][$i], False)
	Next
EndFunc

Func __uT_CheckStateList()
	Local $iUbound = UBound($aTorrent, 2), $bStateExist = False
	If Not $iUbound Or UBound($aTorrent, 1) < 22 Then Return SetError(1, 0, "")
	For $i = 0 To UBound($uT_TrayState, 1) - 1 Step 1
		If $uT_TrayState[$i][0] = "" Then ExitLoop
		$bStateExist = False
		For $n = 0 To $iUbound - 1 Step 1
			If $uT_TrayState[$i][0] == $aTorrent[21][$n] Then
				$bStateExist = True
				ExitLoop
			EndIf
		Next
		If Not $bStateExist Then __uT_TrayDeleteState($i)
	Next
EndFunc

Func __uT_TrayDeleteState($iState)
	TrayItemDelete($uT_TrayState[$iState][1])
	$uT_TrayState[$iState][0] = ""
	Local $nIndex = 0, $aTemp[UBound($uT_TrayState, 1) - 1][3]
	For $n = 0 To UBound($uT_TrayState, 1) - 1 Step 1
		If $uT_TrayState[$n][0] <> "" Then
			For $i = 0 To 2 Step 1
				$aTemp[$nIndex][$i] = $uT_TrayState[$n][$i]
			Next
			$nIndex += 1
		EndIf
	Next
EndFunc

Func __uT_TrayItemState()
	Local $iTrayID = @TRAY_ID
	For $i = 0 To UBound($uT_TrayState, 1) - 1 Step 1
		If $uT_TrayState[$i][1] = $iTrayID Then
			__uT_ToggleTrayState($i, $iTrayID)
			ExitLoop
		EndIf
	Next
EndFunc

Func __uT_TrayCreateState($sState)
	If Not $sState Then Return
	Static Local $iState = 0, $iStateuBound = UBound($uT_TrayState, 1), $bRedim = False
	If $iState > $iStateuBound - 1 Then
		$bRedim = True
		Local $aTemp[$iStateuBound+10][3]
	EndIf
	$uT_TrayState[$iState][0] = $sState
	$uT_TrayState[$iState][1] = TrayCreateItem($sState, $uT_DM)
	TrayItemSetOnEvent($uT_TrayState[$iState][1], "__uT_TrayItemState")
	Local $nTrayState = Int(IniRead($sINI, "µTrayState", $sState, $TRAY_CHECKED))
	TrayItemSetState($uT_TrayState[$iState][1], $nTrayState)
	$uT_TrayState[$iState][2] = ($nTrayState = $TRAY_CHECKED)
	If $bRedim Then
		For $i = 0 To $iState Step 1
			For $p = 0 To 2 Step 1
				$aTemp[$i][$p] = $uT_TrayState[$i][$p]
			Next
		Next
		$uT_TrayState = $aTemp
	EndIf
	$iState += 1
EndFunc

Func __uT_TrayHasState($sState)
	For $n = 0 To UBound($uT_TrayState, 1) - 1 Step 1
		If $sState == $uT_TrayState[$n][0] Then Return True
	Next
	Return False
EndFunc

Func __uT_GetETA($iSeconds)
	Static Local $iMin = 60, $iHour = $iMin * 60, $iDay = $iHour * 24
	If $iSeconds >= $iDay Then Return Int($iSeconds / $iDay) & "d"
	If $iSeconds >= $iHour Then Return Int($iSeconds / $iHour) & "h"
	If $iSeconds >= $iMin Then Return Int($iSeconds / $iMin) & "m"
	Return $iSeconds & "s"
EndFunc   ;==>__uT_GetETA

Func __uT_GetSpeed($iBytes)
	Static Local $iKB = 1024, $iMB = 1024 * 1024
	If $iBytes >= $iMB Then Return Round($iBytes / $iMB, 1) & " MB/s"
	$iBytes = Round($iBytes / $iKB, 1)
	If Not $iBytes Then Return "0.0 KB/s"
	Return $iBytes & " KB/s"
EndFunc   ;==>__uT_GetSpeed

Func __uT_GetStateColor($sState)
	Select
		Case StringInStr($sState, "Error", 2)
			Return "0xE63549"
		Case $sState == "Finished"
			Return "0x54A85F"
		Case $sState == "Seeding"
			Return "0xE9F76D"
		Case $sState == "[F] Seeding"
			Return "0xFCB25D"
		Case $sState == "Downloading metadata"
			Return "0x5D98FC"
		Case $sState == "[F] Downloading"
			Return "0x19D19A"
		Case $sState == "Downloading"
			Return "0x2BD119"
	EndSelect
	Return "0xE3E3E3"
EndFunc

Func __uT_Bar($sHash, $sName, $iPercent = 0, $iDownload = 0, $iUpload = 0, $iETA = "~", $sState = "", $iGuiX = Default, $iGuiY = Default)
	Local $iGuiWidth = 600, $iGuiHeight = 17, $aPos, $bDelete = False
	If IsBool($sName) Then $bDelete = True
	Local Enum $iLeft, $iTop, $iWidth, $iHeight
	Static Local $iBarOrder = 0
	Local Enum $iHash, $hBar, $hLabel, $hProg, $hDown, $hUp, $hETA, $iLastY, $iOrder, $iColor
	Static Local $iGuiX_Default = Int(((@DesktopWidth / 2) - ($iGuiWidth / 2)) + 200)
	Static Local $iGuiY_Default = Int(((@DesktopHeight / 2) - ($iGuiHeight / 2)) + 200)
	If $iGuiX = Default Then $iGuiX = $iGuiX_Default
	If $iGuiY = Default Then $iGuiY = $iGuiY_Default
	Local $uT_GUI[15] = [$sHash, 0, 0, 0, 0, 0, 0, $iGuiY, $iBarOrder, "", $sName, $iPercent, $iDownload, $iUpload, $iETA], $aBar, $vColor = "0xE3E3E3"
	Static Local $uT_Bar[$uT_Limit], $uT_Count = 0
	If $uT_Count Then
		For $i = 0 To $uT_Count Step 1
			$aBar = $uT_Bar[$i]
			If Not UBound($aBar) Then ContinueLoop
			If $aBar[$iHash] = $sHash Then
				If $bDelete Then
					GUIDelete($aBar[$hBar])
					$uT_Bar[$i] = ""
					Local $aTemp[$uT_Limit], $iTemp = 0
					For $i = 0 To $uT_Count Step 1
						$aBar = $uT_Bar[$i]
						If UBound($aBar) Then
							$aTemp[$iTemp] = $aBar
							$iTemp += 1
						EndIf
					Next
					$uT_Count = Int($uT_Count - 1)
					$uT_Bar = $aTemp
					Return True
				EndIf
				If Not WinExists($aBar[$hBar]) Then Return __uT_Bar($aBar[$iHash], False)
				If $sName And $sName <> $aBar[10] Then GUICtrlSetData($aBar[$hLabel], $sName)
				If $uT_StatusColors And $sState Then
					Local $vColor = __uT_GetStateColor($sState)
					If $aBar[$iColor] <> $vColor Then GUISetBkColor($vColor, $aBar[$hBar])
				EndIf
				If $aBar[11] <> $iPercent Then GUICtrlSetData($aBar[$hProg], $iPercent)
				If $aBar[12] <> $iDownload Then GUICtrlSetData($aBar[$hDown], $iDownload)
				If $aBar[13] <> $iUpload Then GUICtrlSetData($aBar[$hUp], $iUpload)
				If $aBar[14] <> $iETA Then GUICtrlSetData($aBar[$hETA], $iETA)
				Return 1
			EndIf
		Next
	EndIf
	If IsBool($sName) Then Return
	If $uT_Count + 1 > $uT_Limit - 1 Then Return SetError(1, 0, "")
	$uT_Count += 1
	If $uT_Count Then
		Local $iMinY = $iGuiY_Default - $iGuiHeight, $bClear
		Do
			$bClear = True
			For $i = 0 To $uT_Count Step 1
				$aBar = $uT_Bar[$i]
				If UBound($aBar) Then
					If $aBar[$iLastY] = $iMinY Then
						$iMinY = $aBar[$iLastY] - $iGuiHeight
						$bClear = False
					EndIf
				EndIf
			Next
		Until $bClear
		$iGuiY = $iMinY
		$uT_GUI[$iLastY] = $iMinY
	EndIf
	$aPos = __uT_ControlPos($iGuiX, $iGuiY, $iGuiWidth - 2, $iGuiHeight - 2)
	$uT_GUI[$hBar] = GUICreate("", $aPos[$iWidth], $aPos[$iHeight], $aPos[$iLeft], $aPos[$iTop], BitOR($WS_POPUP, $WS_BORDER), BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	If $uT_StatusColors And $sState Then $vColor = __uT_GetStateColor($sState)
	GUISetBkColor($vColor, $uT_GUI[$hBar])
	$uT_GUI[$iColor] = $vColor
	If $vColor <> "0xE3E3E3" Then
		$vColor = "0x000000"
	Else
		$vColor = "0x696566"
	EndIf

	$aPos = __uT_ControlPos(0, 0, $aPos[$iWidth], $aPos[$iHeight])
	GUICtrlCreateLabel("", $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], -1, BitOR($WS_EX_TRANSPARENT, $GUI_WS_EX_PARENTDRAG, $WS_EX_TOPMOST))
	GUICtrlSetBkColor(-1, -2)

	$aPos = __uT_ControlPos(1, 1, 3, $aPos[$iHeight] - 2)
	GUICtrlCreateLabel("", $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], -1)
	GUICtrlSetBkColor(-1, $vColor)

	$aPos = __uT_ControlPos($aPos[$iLeft] + 4, $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight])
	GUICtrlCreateLabel("", $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], -1)
	GUICtrlSetBkColor(-1, $vColor)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth] + 5, 0, ($iGuiWidth / 3) + 8, $aPos[$iHeight])
	$uT_GUI[$hLabel] = GUICtrlCreateLabel($sName, $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight])
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0x000000)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth], $aPos[$iTop] + 1, 100, $aPos[$iHeight])
	$uT_GUI[$hProg] = GUICtrlCreateProgress($aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], $PBS_SMOOTH)
	GUICtrlSetData($uT_GUI[$hProg], $iPercent)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth] + 9, $aPos[$iTop] - 1, 10, $aPos[$iHeight])
	GUICtrlCreateLabel("D:", $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], -1)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0x000000)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth] + 6, $aPos[$iTop], 60, $aPos[$iHeight])
	$uT_GUI[$hDown] = GUICtrlCreateLabel($iDownload, $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], $SS_LEFT)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0x000000)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth] + 6, $aPos[$iTop], 10, $aPos[$iHeight])
	GUICtrlCreateLabel("U:", $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight])
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0x000000)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth] + 6, $aPos[$iTop], 60, $aPos[$iHeight])
	$uT_GUI[$hUp] = GUICtrlCreateLabel($iUpload, $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], $SS_LEFT)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0x000000)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth] + 6, $aPos[$iTop], 22, $aPos[$iHeight])
	GUICtrlCreateLabel("ETA:", $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight])
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0x000000)

	$aPos = __uT_ControlPos($aPos[$iLeft] + $aPos[$iWidth] + 6, $aPos[$iTop], 60, $aPos[$iHeight])
	$uT_GUI[$hETA] = GUICtrlCreateLabel($iETA, $aPos[$iLeft], $aPos[$iTop], $aPos[$iWidth], $aPos[$iHeight], $SS_LEFT)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0x000000)

	GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "__uT_ContextMenu", $uT_GUI[$hBar])
	GUISetState(@SW_SHOW, $uT_GUI[$hBar])

	$uT_Bar[$uT_Count] = $uT_GUI
	$iBarOrder += 1
	Return 1
EndFunc   ;==>__uT_Bar

Func __uT_ContextMenu($bPersist = True)
	If Not IsDeclared("bPersist") Then Assign("bPersist", True, 1)
	$uT_LastBar = @GUI_WinHandle
	If Not $bPersist Then
		If $uT_CM <> Default Then
			GUIDelete($uT_CM)
			$uT_CM = Default
		EndIf
		Return AdlibUnRegister("__uT_CMHandler")
	EndIf
	If $uT_CM <> Default Then Return
	Local $aPos = WinGetPos($uT_LastBar), $iWidth = 70, $iHeight = 15, $vMsg
	If Not UBound($aPos) Then Return
	Local $iX = (MouseGetPos(0) - ($iWidth / 2))
	If $iX < $aPos[0] Then $iX = ($aPos[0] + 1)
	If ($iX + $iWidth) > ($aPos[0] + $aPos[2]) Then $iX = (($aPos[0] + $aPos[2]) - ($iWidth + 1))
	$uT_CM = GUICreate("", $iWidth, $iHeight, $iX, $aPos[1] + 1, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	GUICtrlCreateLabel("&Close", 0, 0, $iWidth, 12, $SS_CENTER)
	GUICtrlSetOnEvent(-1, "__uT_CloseBar")
	GUISetState(@SW_SHOW, $uT_CM)
	AdlibRegister("__uT_CMHandler", 250)
EndFunc   ;==>__uT_ContextMenu

Func __uT_CMHandler()
	If Not WinActive($uT_CM) Then __uT_ContextMenu(False)
EndFunc   ;==>__uT_CMHandler

Func __uT_CloseBar()
	GUIDelete($uT_LastBar)
	$uT_LastBar = Default
	__uT_ContextMenu(False)
EndFunc   ;==>__uT_CloseBar

Func __uT_ControlPos($iLeft = 0, $iTop = 0, $iWidth = 0, $iHeight = 0)
	Local $aPos[4] = [$iLeft, $iTop, $iWidth, $iHeight]
	Return $aPos
EndFunc   ;==>__uT_ControlPos

Func __uT_Auth($uT_User = Default, $uT_Pass = Default, $uT_IP = @IPAddress1, $uT_Port = 8080)
	Static Local $aInfo[4]
	If $uT_User <> Default And $uT_User And $uT_Pass <> Default And $uT_Pass Then
		$aInfo[0] = $uT_User
		$aInfo[1] = $uT_Pass
		$aInfo[2] = $uT_IP
		$aInfo[3] = $uT_Port
	ElseIf Not $aInfo[0] Or Not $aInfo[1] Then
		Return SetError(1, 0, "")
	EndIf
	Return $aInfo
EndFunc   ;==>__uT_Auth

Func __uT_ActionRequest($sAction, $bGetToken = True)
	Local $sURL = $sAction
	If $bGetToken Then
		$sURL = __uT_Token()
		If @error Then Return SetError(@error, __uT_ServerState(@extended), -1)
		$sURL &= $sAction
	EndIf
	__uT_Open("GET", $sURL, False)
	If @error Then Return SetError(@error, __uT_ServerState(@extended), -3)
	__uT_SetProxy(True)
	If @error Then Return SetError(@error, __uT_ServerState(@extended), -2)
	__uT_SetCredentials()
	If @error Then Return SetError(@error, __uT_ServerState(@extended), -4)
	__uT_SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	If @error Then Return SetError(@error, __uT_ServerState(@extended), -5)
	__uT_Send()
	If @error Then Return SetError(@error, __uT_ServerState(@extended), -6)
	Local $sResp = __uT_ResponseText()
	ConsoleWrite($sResp & @CRLF)
	If @error Then
		Return SetError(@error, __uT_ServerState(@extended), -7)
	Else
		Return SetError(0, 0, $sResp)
	EndIf
EndFunc   ;==>__uT_ActionRequest

Func __uT_SetRequestHeader($sHeader, $sValue = "")
	If Not IsDeclared("uT_oHTTP") Then Return SetError(1, 0, "")
	If Not IsObj($uT_oHTTP) Then Return SetError(2, 0, "")
	$uT_oHTTP.SetRequestHeader($sHeader, $sValue)
	If @error Then
		Return SetError(3, @error, "")
	Else
		Return SetError(0, 0, True)
	EndIf
EndFunc   ;==>__uT_SetRequestHeader

Func __uT_Open($sMethod, $sURL, $bAsync = False)
	If Not IsDeclared("uT_oHTTP") Then Return SetError(1, 0, "")
	If Not IsObj($uT_oHTTP) Then Return SetError(2, 0, "")
	$uT_oHTTP.Open($sMethod, $sURL, $bAsync)
	If @error Then
		Return SetError(3, @error, "")
	Else
		Return SetError(0, 0, True)
	EndIf
EndFunc   ;==>__uT_Open

Func __uT_Send($vBody = "")
	If Not IsDeclared("uT_oHTTP") Then Return SetError(1, 0, "")
	If Not IsObj($uT_oHTTP) Then Return SetError(2, 0, "")
	$uT_oHTTP.Send($vBody)
	If @error Then
		Return SetError(3, @error, "")
	Else
		Return SetError(0, 0, True)
	EndIf
EndFunc   ;==>__uT_Send

Func __uT_SetCredentials($nFlags = $uT_HTTPREQUEST_SETCREDENTIALS_FOR_SERVER)
	If Not IsDeclared("uT_oHTTP") Then Return SetError(1, 0, "")
	If Not IsObj($uT_oHTTP) Then Return SetError(2, 0, "")
	Local $uT_Auth = __uT_Auth()
	If @error Or UBound($uT_Auth, 1) <> 4 Then Return SetError(3, 0, "")
	$uT_oHTTP.SetCredentials($uT_Auth[0], $uT_Auth[1], $nFlags)
	If @error Then
		Return SetError(4, @error, "")
	Else
		Return SetError(0, 0, True)
	EndIf
EndFunc   ;==>__uT_SetCredentials

Func __uT_CacheString(Const ByRef $sResp)
	Local $uT_CacheString = StringRegExp($sResp, '"torrentc":(?:.*?)(\d+)"\v', 3)
	If @error Then Return SetError(1, 0, "")
	Return $uT_CacheString[0]
EndFunc   ;==>__uT_CacheString

Func __uT_ResponseText()
	If Not IsDeclared("uT_oHTTP") Then Return SetError(1, 0, "")
	If Not IsObj($uT_oHTTP) Then Return SetError(2, 0, "")
	Local $vReturn = $uT_oHTTP.ResponseText()
	If @error Then
		Return SetError(3, @error, "")
	Else
		Return SetError(0, 0, $vReturn)
	EndIf
EndFunc   ;==>__uT_ResponseText

Func __uT_Error($oError)
	ConsoleWrite("!>ScriptLine: " & $oError.scriptline & @CRLF & "!>Description: " & $oError.description & @CRLF)
EndFunc   ;==>__uT_Error

Func __uT_Token()
	Local $uT_Auth = __uT_Auth()
	If @error Or UBound($uT_Auth, 1) <> 4 Then Return SetError(1, 0, "")
	If Not $uT_Settings[1] Then $uT_Settings[1] = "http://"
	Local $sToken = __uT_ActionRequest($uT_Settings[1] & $uT_Auth[2] & ":" & $uT_Auth[3] & "/gui/token.html", False)
	If @error Then
		Return SetError(@error, @extended, "")
	Else
		$sToken = StringMid($sToken, 45, 64)
		If Not $sToken Then Return SetError(255, 0, "")
		Return $uT_Settings[1] & $uT_Auth[2] & ":" & $uT_Auth[3] & "/gui/?token=" & $sToken
	EndIf
EndFunc   ;==>__uT_Token

Func __uT_ParseList($sResp, $sPrefixRE)
	$sResp = StringRegExpReplace(StringReplace($sResp, "\\", "\", 0, 2), '(\\"|\\,)', "")
	$sResp = StringReplace($sResp, " ", $uT_SID, 0, 2)
	ConsoleWrite($sResp & @CRLF)
	Local $aResp = StringRegExp(StringStripWS($sResp, 8), $sPrefixRE & "\[\[(.*?)\]\]", 3)
	If @error Then Return SetError(1, 0, "")
	Local $aTemp = $aResp
	$aResp = StringSplit($aResp[0], "],[", 3)
	If @error Then $aResp = $aTemp
	Local $aTorrent[1]
	For $i = 0 To UBound($aResp, 1) Step 1
		$aTemp = StringRegExp($aResp[$i], '(?:\A[^,][a-zA-Z0-9]{40}[^,])[^"]\d+[^"](".*?")?', 3)
		If @error Then ContinueLoop
		$aResp[$i] = StringReplace(StringReplace($aResp[$i], $aTemp[0], StringReplace($aTemp[0], ",", "", 0, 2), 1, 2), '"', "", 0, 2)
		$aTemp = StringSplit($aResp[$i], ",", 3)
		If @error Or UBound($aTemp) < 1 Then ContinueLoop
		If $i = 0 Then ReDim $aTorrent[UBound($aTemp, 1)][UBound($aResp, 1)]
		For $n = 0 To UBound($aTemp, 1) - 1 Step 1
			$aTorrent[$n][$i] = StringReplace($aTemp[$n], $uT_SID, " ", 0, 1)
			If UBound($aTorrent, 1) - 1 <= $n Then ExitLoop
		Next
		If UBound($aTorrent, 2) - 1 <= $i Then ExitLoop
	Next
	Return $aTorrent
EndFunc   ;==>__uT_ParseList

Func __uT_SetProxy($sProxy = Default, $vPort = Default, $sUser = Default, $sPass = Default)
	If Not IsDeclared("uT_oHTTP") Then Return SetError(1, 0, "")
	If Not IsObj($uT_oHTTP) Then Return SetError(2, 0, "")
	Static Local $uT_Proxy, $uT_User, $uT_Pass
	If $sProxy <> Default And $vPort <> Default Then
		$uT_Proxy = $sProxy & ":" & String($vPort)
	ElseIf $uT_Proxy <> "" Then
		$uT_oHTTP.SetProxy($uT_HTTPREQUEST_PROXYSETTING_PROXY, $uT_Proxy)
		If @error Then Return SetError(3, @error, "")
	Else
		$uT_oHTTP.SetProxy($uT_HTTPREQUEST_PROXYSETTING_DEFAULT)
		If @error Then Return SetError(3, @error, "")
	EndIf
	If $sUser <> Default And $sPass <> Default Then
		$uT_User = $sUser
		$uT_User = $sPass
		If IsBool($sProxy) And $sProxy Then
			$uT_oHTTP.SetCredentials($uT_User, $uT_User, $uT_HTTPREQUEST_SETCREDENTIALS_FOR_PROXY)
			If @error Then Return SetError(4, @error, "")
		EndIf
	ElseIf $uT_User <> "" Then
		$uT_oHTTP.SetCredentials($uT_User, $uT_User, $uT_HTTPREQUEST_SETCREDENTIALS_FOR_PROXY)
		If @error Then Return SetError(4, @error, "")
	EndIf
	Return SetError(0, 0, True)
EndFunc   ;==>__uT_SetProxy

Func __uT_ServerState($nError = Default)
	Static Local $uT_ServerState = 0
	If $nError <> Default Then $uT_ServerState = $nError
	Return $uT_ServerState
EndFunc   ;==>__uT_ServerState

; #FUNCTION# ====================================================================================================================
; Name ..........: __uT_GetList
; Description ...: Returns a list of torrent jobs and their properties.
; Syntax ........: __uT_GetList([$bReset = False]) ; Optional param is for internal use only!
; Parameters ....: $bReset             - [optional] A boolean value. Default is False.
; Return values .: Success - 2 Dimensional array, where the colums represent the torrent jobs and rows are the properties.
;
;                 [0][0] = HASH (string),
;                 [1][0] = STATUS* (integer),
;                 [2][0] = NAME (string),
;                 [3][0] = SIZE (integer in bytes),
;                 [4][0] = PERCENT PROGRESS (integer in per mils 1000 = 100.0 complete),
;                 [5][0] = DOWNLOADED (integer in bytes),
;                 [6][0] = UPLOADED (integer in bytes),
;                 [7][0] = RATIO (integer in per mils),
;                 [8][0] = UPLOAD SPEED (integer in bytes per second),
;                 [9][0] = DOWNLOAD SPEED (integer in bytes per second),
;                 [10][0] = ETA (integer in seconds),
;                 [11][0] = LABEL (string),
;                 [12][0] = PEERS CONNECTED (integer),
;                 [13][0] = PEERS IN SWARM (integer),
;                 [14][0] = SEEDS CONNECTED (integer),
;                 [15][0] = SEEDS IN SWARM (integer),
;                 [16][0] = AVAILABILITY (integer in 1/65536ths),
;                 [17][0] = TORRENT QUEUE ORDER (integer),
;                 [18][0] = REMAINING (integer in bytes)
;
;				  [.....]
;
; Failure........: @error is nonzero
; Author ........: Decipher
; Remarks .......: Original UDF Credit - JohnOne/Supagusti, This function now should return 28 properties
; Related .......: __uT_ParseList, __uT_CacheString, __uT_GetProps, __uT_GetFiles, __uT_GetStats
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func __uT_GetList($bReset = False)
	Static Local $aTorrent, $uT_CacheString
	If $bReset Then
		$uT_CacheString = ""
		$aTorrent = ""
	EndIf
	Local $sResp = __uT_ActionRequest("&list=1&cid=" & $uT_CacheString)
	If @error Or Not $sResp Then Return SetError(1, 0, "")
	If $uT_CacheString Then
		Local $aTemp
		If @error Then Return SetError(2, 0, "")
		$aTemp = __uT_ParseList($sResp, 'torrentp[^\[]{' & (2 + $uT_SIDc) & '}')
		If Not @error Then
			Local $iUbound = UBound($aTemp, 1), $iLimit = 20, $aNew[$iUbound][$iLimit], $iNew = 0, $aNewTemp
			For $i = 0 To UBound($aTemp, 2) - 1 Step 1
				For $n = 0 To UBound($aTorrent, 2) - 1 Step 1
					If $aTorrent[0][$n] = $aTemp[0][$i] Then
						For $p = 1 To UBound($aTorrent, 1) - 1 Step 1
							$aTorrent[$p][$n] = $aTemp[$p][$i]
							If UBound($aTemp, 1) - 1 <= $p Then ExitLoop
						Next
						ExitLoop
					ElseIf $n = (UBound($aTorrent, 2) - 1) Then ; Create an array contain torrent entries that haven't been cached.
						$iNew += 1
						If $iNew > $iLimit Then
							$aNewTemp = $aNew
							$iLimit += 20
							ReDim $aNew[$iUbound][$iLimit]
							For $new = 0 To UBound($aNewTemp, 2) - 1 Step 1
								For $p = 0 To $iUbound - 1 Step 1
									$aNew[$p][$new] = $aNewTemp[$p][$new]
								Next
							Next
							$aNewTemp = ""
						Else
							For $p = 0 To $iUbound - 1
								$aNew[$p][$iNew - 1] = $aTemp[$p][$i]
							Next
						EndIf
					EndIf
				Next
			Next
			If $iNew <> 0 Then
				Local $iProps = UBound($aTorrent, 1), $iUbound = UBound($aTorrent, 2), $aNewArray[$iProps][$iUbound + $iNew]
				For $i = 0 To $iUbound - 1 Step 1
					For $p = 0 To $iProps - 1 Step 1
						$aNewArray[$p][$i] = $aTorrent[$p][$i]
					Next
				Next
				Local $n = 0
				For $i = $i To ($iUbound + $iNew) - 1 Step 1
					For $p = 0 To $iProps - 1 Step 1
						$aNewArray[$p][$i] = $aNew[$p][$n]
					Next
					$n += 1
				Next
				$aNew = ""
				$aTorrent = $aNewArray
			EndIf
			$aTemp = ""
		EndIf
		$aTemp = StringRegExp(StringStripWS($sResp, 8), '"torrentm":.{' & $uT_SIDc & '}\[(.*?)\]', 3)
		If Not @error And UBound($aTemp) And $aTemp[0] Then
			$aTemp = StringSplit(StringReplace($aTemp[0], '"', "", 0, 2), ",", 3)
			If UBound($aTemp) Then
				Local $avArray[UBound($aTorrent, 1)][UBound($aTorrent, 2) - UBound($aTemp, 1)], $bSkip, $d = 0
				For $i = 0 To UBound($aTorrent, 2) - 1 Step 1
					$bSkip = False
					For $n = 0 To UBound($aTemp, 1) - 1 Step 1
						If $aTorrent[0][$i] = $aTemp[$n] Then
							$bSkip = True
							ExitLoop
						EndIf
					Next
					If Not $bSkip Then
						For $p = 0 To UBound($aTorrent, 1) - 1 Step 1
							$avArray[$p][$d] = $aTorrent[$p][$i]
						Next
						If $d >= UBound($avArray, 2) - 1 Then ExitLoop
						$d += 1
					EndIf
				Next
				$aTorrent = $avArray
			EndIf
		EndIf
	Else
		$aTorrent = __uT_ParseList($sResp, 'torrents[^\[]{' & (2 + $uT_SIDc) & '}')
		If @error Then Return SetError(5, 0, "")
	EndIf
	$uT_CacheString = __uT_CacheString($sResp)
	If @error Then Return SetError(6, 0, "")
	Return $aTorrent
EndFunc   ;==>__uT_GetList

; GUI function for getting user's configuration information
Func __uT_LoginGUI($uT_Value)
	; Define Intial Coords
	Local $iWidth = 380, $iHeight = 170, $iLeft = 10, $iTop = 10, $iSpace = 8, $iEnd = 0
	; Control & Value Variable Index Enumeration
	Local $uT_Control[16]
	Local Enum $hGUI, $hScheme, $hIP, $hPort, $hUser, $hPass, $hStart, $hRem, $hProScheme, $hProIP, $hProPort, $hProUser, $hProPass, $hProState, _
			$hValidate, $hCancel
	; Intial GUI Creation
	$uT_Control[$hGUI] = GUICreate("                                              µAuToBar v1.0", $iWidth, $iHeight, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	; Logo
	GUICtrlCreateLabel("Decipher Systems", $iWidth - 195, 8, 150, 15, $SS_LEFT)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetFont(-1, 8.5, 400, 6, "Verdana")
	GUICtrlCreateTab($iLeft, $iTop, $iWidth - 23, $iHeight - 40, -1, -1)
	; Tab -1
	GUICtrlCreateTabItem("WebUI")
	GUICtrlCreateLabel("Server Address:", _Coord($iLeft, $iSpace + 12), _Coord($iTop, 45), _Coord($iWidth, 75), _Coord($iHeight, 15), $SS_RIGHT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hScheme] = GUICtrlCreateCombo($uT_Value[$hScheme], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 3), _Coord($iWidth, 65), _Coord($iHeight))
	Local $sData = "https://"
	If $uT_Value[$hScheme] = $sData Then $sData = "http://"
	GUICtrlSetData(-1, $sData)
	$uT_Control[$hIP] = GUICtrlCreateInput($uT_Value[$hIP], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop + 1), _Coord($iWidth, 93), _Coord($iHeight, $iHeight + 3))
	GUICtrlCreateLabel("Port:", _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop + 2), _Coord($iWidth, 21), _Coord($iHeight, $iHeight - 3), $SS_LEFT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hPort] = GUICtrlCreateInput($uT_Value[$hPort], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 2), _Coord($iWidth, 50), _Coord($iHeight, $iHeight + 3), $ES_NUMBER)
	GUICtrlCreateUpdown(-1, BitOR($UDS_ARROWKEYS, $UDS_NOTHOUSANDS))
	_Coord($iEnd, $iLeft + $iWidth)
	; New Row
	GUICtrlCreateLabel("Username:", _Coord($iLeft, $iSpace + 12), _Coord($iTop, 43 + $iHeight + $iSpace), _Coord($iWidth, 51), _Coord($iHeight, 15), $SS_RIGHT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hUser] = GUICtrlCreateInput($uT_Value[$hUser], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 1), _Coord($iWidth, $iEnd - $iLeft), _Coord($iHeight, $iHeight + 2))
	; New Row
	GUICtrlCreateLabel("Password:", _Coord($iLeft, $iSpace + 12), _Coord($iTop, $iTop + $iHeight + $iSpace), _Coord($iWidth, 51), _Coord($iHeight, 15), $SS_RIGHT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hPass] = GUICtrlCreateInput($uT_Value[$hPass], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 1), _Coord($iWidth, $iEnd - $iLeft), _Coord($iHeight, $iHeight + 2), $ES_PASSWORD)
	; New Row
	$uT_Control[$hStart] = GUICtrlCreateCheckbox("Start after validation", _Coord($iLeft, $iSpace + 12), _Coord($iTop, $iTop + $iHeight + $iSpace), _Coord($iWidth, 115), _Coord($iHeight, 17), $SS_LEFT)
	GUICtrlSetState(-1, $uT_Value[$hStart])
	GUICtrlSetFont(-1, 8.5, 400, -1, "Tahoma")
	$uT_Control[$hRem] = GUICtrlCreateCheckbox("Remember Password(s) - UNSAFE", _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop), _Coord($iWidth, 180), _Coord($iHeight))
	GUICtrlSetState(-1, $uT_Value[$hRem])
	GUICtrlSetFont(-1, 8.5, 400, -1, "Tahoma")
	; Tab -2
	GUICtrlCreateTabItem("Proxy")
	GUICtrlCreateLabel("Server Address:", _Coord($iLeft, $iSpace + 12), _Coord($iTop, 45), _Coord($iWidth, 75), _Coord($iHeight, 15), $SS_RIGHT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hProScheme] = GUICtrlCreateCombo($uT_Value[$hProScheme], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 3), _Coord($iWidth, 65), _Coord($iHeight))
	$sData = "https://"
	If $uT_Value[$hProScheme] = $sData Then $sData = "http://"
	GUICtrlSetData(-1, $sData)
	$uT_Control[$hProIP] = GUICtrlCreateInput($uT_Value[$hProIP], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop + 1), _Coord($iWidth, 93), _Coord($iHeight, $iHeight + 3))
	GUICtrlCreateLabel("Port:", _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop + 2), +_Coord($iWidth, 21), _Coord($iHeight, $iHeight - 3), $SS_LEFT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hProPort] = GUICtrlCreateInput($uT_Value[$hProPort], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 2), _Coord($iWidth, 50), _Coord($iHeight, $iHeight + 3), $ES_NUMBER)
	GUICtrlCreateUpdown(-1, BitOR($UDS_ARROWKEYS, $UDS_NOTHOUSANDS))
	_Coord($iEnd, $iLeft + $iWidth)
	; New Row
	GUICtrlCreateLabel("Username:", _Coord($iLeft, $iSpace + 12), _Coord($iTop, 43 + $iHeight + $iSpace), _Coord($iWidth, 51), _Coord($iHeight, 15), $SS_RIGHT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hProUser] = GUICtrlCreateInput($uT_Value[$hProUser], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 1), _Coord($iWidth, $iEnd - $iLeft), _Coord($iHeight, $iHeight + 2))
	; New Row
	GUICtrlCreateLabel("Password:", _Coord($iLeft, $iSpace + 12), _Coord($iTop, $iTop + $iHeight + $iSpace), _Coord($iWidth, 51), _Coord($iHeight, 15), $SS_RIGHT)
	GUICtrlSetColor(-1, 0x000000)
	$uT_Control[$hProPass] = GUICtrlCreateInput($uT_Value[$hProPass], _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop, $iTop - 1), _Coord($iWidth, $iEnd - $iLeft), _Coord($iHeight, $iHeight + 2), $ES_PASSWORD)
	; New Row
	GUICtrlCreateLabel("*Use blank credentials to connect without auth.", _Coord($iLeft, $iSpace + 12), _Coord($iTop, $iTop + $iHeight + $iSpace), _Coord($iWidth, 245), _Coord($iHeight, 15), $SS_LEFT)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetFont(-1, 8.5, 400, 2, "Tahoma")
	$uT_Control[$hProState] = GUICtrlCreateCheckbox("Use Proxy", _Coord($iLeft, $iLeft + $iWidth + $iSpace), _Coord($iTop), _Coord($iWidth, 65), _Coord($iHeight, $iHeight + 2))
	GUICtrlSetState(-1, $uT_Value[$hProState])
	; Tab Termination
	GUICtrlCreateTabItem("")
	; Outside of tab controls
	$uT_Control[$hValidate] = GUICtrlCreateButton("&Validate", 215 - $iSpace, 151 - $iSpace, 75, 20)
	GUICtrlSetOnEvent(-1, "__uT_Validate")
	$uT_Control[$hCancel] = GUICtrlCreateButton("&Cancel", 290, 151 - $iSpace, 75, 20)
	GUICtrlSetOnEvent(-1, "__uT_Abort")
	; Register GUI close special event handler
	GUISetOnEvent($GUI_EVENT_CLOSE, "__uT_Abort")
	; Return a one dimensional array of controls
	Return $uT_Control
EndFunc   ;==>__uT_LoginGUI

; Helper Function - Helps the programmer and makes the GUI creation sorta dynamic if updating positions. Without wasted space!
Func _Coord(ByRef $iCoord, $iNewCoord = Default)
	If $iNewCoord <> Default Then $iCoord = $iNewCoord
	Return $iCoord
EndFunc   ;==>_Coord

Func __uT_Manage($sAction)
	; Define settings file and array variables
	Static Local $uT_Control
	Switch ($sAction)
		Case "Configure"
			TrayItemSetState($uT_PM, $TRAY_CHECKED)
			TrayItemSetState($uT_PM, $TRAY_DISABLE)
			$uT_Paused = True
			Local $aTemp
			; Check for settings, Create default values array if neccessary, array bounds check, read stored settings to array if available
			If FileExists($sINI) Then $aTemp = IniReadSection($sINI, "µSettings")
			If @error Or UBound($aTemp, 1) <> 17 Then
				Local $uT_Value[16] = [15, "http://", @IPAddress1, 8080, "", "", $GUI_CHECKED, $GUI_UNCHECKED, "http://", "127.0.0.1", 8118, "", "", $GUI_UNCHECKED]
			Else
				Local $uT_Value[16]
				$uT_Value[0] = 15
				For $i = 1 To $aTemp[0][0] Step 1
					If IsInt($aTemp[$i][1]) Then $aTemp[$i][1] = Int($aTemp[$i][1])
					$uT_Value[$i - 1] = $aTemp[$i][1]
				Next
			EndIf
			; Pass stored or default settings array to the gui creation function, returns gui controls array
			$uT_Control = __uT_LoginGUI($uT_Value)
			; Show the Login Interface
			GUISetState(@SW_SHOW, $uT_Control[0])
		Case "Save"
			$uT_Paused = False
			TrayItemSetState($uT_PM, $TRAY_UNCHECKED)
			TrayItemSetState($uT_PM, $TRAY_ENABLE)
			If $uT_RM <> Default Then TrayItemDelete($uT_RM)
			$uT_RM = Default
			; create the array for compliance with Autoit's IniWriteSection function
			Local $uT_Value[16][2], $vData = "Undefined"
			; Read all the settings from the control array
			For $i = 0 To 15 Step 1
				; Weed out unneccessary function calls
				If $i > 0 And $i < 14 Then $vData = GUICtrlRead($uT_Control[$i])
				If $i = 7 And $vData = $GUI_UNCHECKED Then
					If $uT_Value[5][1] Then $uT_Password = $uT_Value[5][1]
					$uT_Value[5][1] = ""
				EndIf
				$uT_Value[$i][0] = "µOpt-" & $i
				$uT_Value[$i][1] = $vData
				$vData = "Undefined"
			Next
			; Destroy the GUI
			GUIDelete($uT_Control[0])
			; Save configuration
			IniWriteSection($sINI, "µSettings", $uT_Value, 0)
			If $uT_Started Then
				TrayTip("µAuToBar", "Restarting...", 5, 1)
				Run(@ScriptFullPath)
				Sleep(5000)
				Exit (0)
			EndIf
		Case "Startup"
			If Not FileExists($sINI) Then Return False
			Local $aTemp = IniReadSection($sINI, "µSettings")
			If @error Or UBound($aTemp, 1) <> 17 Then Return SetError(1, 0, "")
			For $i = 2 To 6 Step 1
				If Not $aTemp[$i][1] Then
					If $i = 6 And $uT_Password <> Default Then ExitLoop
					Return False
				EndIf
			Next
			If Int($aTemp[8][1]) <> $GUI_CHECKED Then Return False
			If Int($aTemp[14][1]) = $GUI_CHECKED Then
				For $i = 9 To 11 Step 1
					If Not $aTemp[$i][1] Then Return SetError(2, 0, "")
				Next
			EndIf
			Local $aSettings[16]
			For $i = 1 To 16 Step 1
				$aSettings[$i - 1] = $aTemp[$i][1]
			Next
			Return $aSettings
		Case "Validate"
			$uT_Paused = False
			TrayItemSetState($uT_PM, $TRAY_UNCHECKED)
			TrayItemSetState($uT_PM, $TRAY_ENABLE)
			If $uT_RM <> Default Then TrayItemDelete($uT_RM)
			$uT_RM = Default
			; create the array for compliance with Autoit's IniWriteSection function
			Local $uT_Value[16][2], $vData = "Undefined"
			; Read all the settings from the control array
			For $i = 0 To 15 Step 1
				; Weed out unneccessary function calls
				If $i > 0 And $i < 14 Then $vData = GUICtrlRead($uT_Control[$i])
				$uT_Value[$i][0] = "µOpt-" & $i
				$uT_Value[$i][1] = $vData
				$vData = "Undefined"
			Next
			For $i = 1 To 5 Step 1
				If Not $uT_Value[$i][1] And $i <> 6 Then Return SetError(4, 0, "")
			Next
			If $uT_Value[7][1] = $GUI_UNCHECKED Then
				$uT_Password = $uT_Value[5][1]
				$uT_Value[5][1] = ""
			Else
				$uT_Password = Default
			EndIf
			If Int($uT_Value[13][1]) = $GUI_CHECKED Then
				For $i = 8 To 10 Step 1
					If Not $uT_Value[$i][1] Then Return SetError(2, 0, "")
				Next
			EndIf
			Local $aSettings[16]
			For $i = 0 To 15 Step 1
				$aSettings[$i] = $uT_Value[$i][1]
			Next
			Return $aSettings
		Case "Quit"
			GUIDelete($uT_Control[0])
			Exit
	EndSwitch
EndFunc   ;==>__uT_Manage

Func __uT_Configure()
	__uT_Manage("Configure")
EndFunc   ;==>__uT_Configure

Func __uT_Startup()
	$uT_Settings = __uT_Manage("Startup")
	If @error = 2 Then MsgBox(262144, "µAuToBar", "There appears to be an error with the current proxy configuration!")
	If Not UBound($uT_Settings) Then
		__uT_Manage("Configure")
	Else
		$bValidSettings = True
	EndIf
EndFunc   ;==>__uT_Startup

Func __uT_Validate()
	$uT_Settings = __uT_Manage("Validate")
	If @error = 2 Then
		MsgBox(262144, "µAuToBar", "There appears to be an error with the current proxy configuration!")
	ElseIf @error = 4 Then
		MsgBox(262144, "µAuToBar", "The current µTorrent server information failed validation! Please the check WebUI tab.")
	ElseIf UBound($uT_Settings) Then
		__uT_Manage("Save")
		; Connection Failure Check should be done here!
		$bValidSettings = True
		If $uT_Settings[6] <> $GUI_CHECKED Then Exit
	Else
		MsgBox(262144, "µAuToBar", "The current µTorrent server information failed validation! An Unknown error occurred!")
	EndIf
EndFunc   ;==>__uT_Validate

Func __uT_Abort()
	MsgBox(262144, "µAuToBar", "User canceled configuration changes. µAuToBar will now close.", 15)
	__uT_Manage("Quit")
EndFunc   ;==>__uT_Abort

Func __uT_Exit()
	Exit (0)
EndFunc   ;==>__uT_Exit

Func __uT_Suspend()
	If $uT_Paused Then
		$uT_Paused = False
		TrayItemSetState($uT_PM, $TRAY_UNCHECKED)
		TrayItemSetState($uT_PM, $TRAY_ENABLE)
		TrayItemDelete($uT_RM)
		$uT_RM = Default
	Else
		$uT_Paused = True
		TrayItemSetState($uT_PM, $TRAY_CHECKED)
		TrayItemSetState($uT_PM, $TRAY_DISABLE)
		If $uT_RM = Default Then
			TrayItemDelete($uT_EX)
			$uT_RM = TrayCreateItem("Resume")
			TrayItemSetOnEvent($uT_RM, "__uT_Suspend")
			$uT_EX = TrayCreateItem("Exit")
			TrayItemSetOnEvent($uT_EX, "__uT_Exit")
		EndIf
	EndIf
EndFunc   ;==>__uT_Suspend